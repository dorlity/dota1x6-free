Game.talents_values = {}
Game.new_talent_system = {}
Game.spells_by_number = {}
Game.achivment_table = {}
Game.pickrate_talents = {}
Game.local_chosen_build = -1
Game.CustomTooltipOpened = false
Game.Subscribed = false


CustomNetTables.SubscribeNetTableListener( "sub_data", update_hero_image );
CustomNetTables.SubscribeNetTableListener( "custom_pick", update_custom_pick );
GameEvents.Subscribe("reconnect_hero_image", reconnect_hero_image)

var custom_pick_table

function update_custom_pick(table, key, data)
{
	if (table != "custom_pick") return
	if (key != "game_mode") return

	custom_pick_table = data
}

Game.talents_values = []

GameEvents.OnLoaded(() => {
	const hero_list = CustomNetTables.GetTableValue("custom_pick", "hero_list")
	custom_pick_table = CustomNetTables.GetTableValue("custom_pick", "game_mode")

	request_talent_values()
  GameEvents.Subscribe_custom('SendTalents', SendTalents)
  GameEvents.Subscribe_custom('SendNewTalentSystem', SendNewTalentSystem)
  GameEvents.Subscribe_custom('SendAchivments', SendAchivments)
  GameEvents.Subscribe_custom('SendPickRates', SendPickRates)
  GameEvents.Subscribe_custom('SendPickRates', SendPickRates)
  GameEvents.Subscribe_custom('SendSubscribed', SendSubscribed)
  GameEvents.Subscribe_custom('select_unit_custom', select_unit_custom)


  GameEvents.SendCustomGameEventToServer_custom("RequestAchivments", {})
  GameEvents.SendCustomGameEventToServer_custom("RequestPickRates", {})
  GameEvents.SendCustomGameEventToServer_custom("RequestSubscribed", {})
})

var talents_recieved = false
var pickrate_recieved = false

function request_talent_values()
{
	$.Msg('RequestTalents ',talents_recieved)

    GameEvents.SendCustomGameEventToServer_custom("RequestTalents", {})

    if (talents_recieved == true)
    	return

	$.Schedule(1, request_talent_values)
}

function SendAchivments(data)
{
	for (key in data)
	{
		if (key != "n")
			Game.achivment_table[key] = data[key]
	}
}


function SendSubscribed(data)
{
	Game.Subscribed = false

	if (data.sub && (data.sub == 1 || data.sub == true))
		Game.Subscribed = true
}



function SendPickRates(data)
{
	if (pickrate_recieved == true)
		return

	for (let name in data)
	{
		if (name != "n")
		{
			Game.pickrate_talents[name] = {}
			let data_table = data[name]["talents"]

			for (let legendary_name in data_table)
			{
				let legendary_data = data_table[legendary_name]
				Game.pickrate_talents[name][legendary_name] = {}
				let second_legendary = []
				let second_legendary_sum = 0

				for (let id in legendary_data)
				{
					let id_data = legendary_data[id]
					Game.pickrate_talents[name][legendary_name][id_data.name] = id_data.pickRate

					let talent_data = Game.talents_values[name][id_data.name]

					if (talent_data && talent_data["skill_icon"] != legendary_name && talent_data["rarity"] == "orange")
					{
						second_legendary.push(id_data.name)
						if (Game.pickrate_talents[name][legendary_name][id_data.name])
						{
							second_legendary_sum = second_legendary_sum + Game.pickrate_talents[name][legendary_name][id_data.name]
						}
					}
				}
				for (legendary_id in second_legendary)
				{
					let second_legendary_name = second_legendary[legendary_id]

					if (Game.pickrate_talents[name][legendary_name][second_legendary_name])
						Game.pickrate_talents[name][legendary_name][second_legendary_name] = Game.pickrate_talents[name][legendary_name][second_legendary_name]/second_legendary_sum
				}
			}
		}
	}
}




function SendTalents(data)
{
	if (talents_recieved == true)
		return


	talents_recieved = true
	for (let name in data)
	{
		if (name != "n")
		{
			Game.talents_values[name] = data[name]
			for (let talent_name in data[name])
			{
				let talent_data = data[name][talent_name]
				let skill_number = talent_data["skill_number"]
				let skill_name = talent_data["skill_name"]
				let skill_icon = talent_data["skill_icon"]


				if (skill_number && skill_name)
				{
					if (Game.spells_by_number[name] == undefined)
						Game.spells_by_number[name] = {}

					if (Game.spells_by_number[name][skill_number] == undefined)
					{
						Game.spells_by_number[name][skill_number] = {}
						Game.spells_by_number[name][skill_number]["name"] = skill_name
						Game.spells_by_number[name][skill_number]["skill_icon"] = skill_icon
					}
				}
			}
		}
	}

	if (true) return

	let rarity = ["blue", "purple", "orange"]
	let local = ["Редкие таланты:", "Эпические таланты:", "Легендарный талант:"]

	for (let name in Game.spells_by_number)
	{
		if (name != "n" && name != "npc_dota_hero_axe")
		{
			$.Msg("-------")
			$.Msg($.Localize("#" + name) + ":")

			for (let skill_number in Game.spells_by_number[name])
			{
				let skill_data = Game.spells_by_number[name][skill_number]
				let skill_name = skill_data["name"]

				$.Msg("Таланты для ", $.Localize("#DOTA_Tooltip_ability_" + skill_name))

				let hero_data = Game.talents_values[name]

				for (rarity_nubmer in rarity)
				{
					let rarity_name = rarity[rarity_nubmer]
					$.Msg()
					$.Msg(local[rarity_nubmer])
					let count = 1
					for (let talent_name in hero_data)
					{
						let talent_data = hero_data[talent_name]
						let talent_number = talent_data["skill_number"]
						let talent_rarity = talent_data["rarity"]

						if (talent_number == skill_number && talent_rarity == rarity_name)
						{
							$.Msg(count + ") " + Game.ShowTalentValues("#upgrade_disc_" + talent_name, talent_name, 1, false, talent_data["rarity"] == "orange", false, true))
							count++
						}
					}

				}

				$.Msg()
			}
		}
	}
}


function SendNewTalentSystem(data)
{

	for (let name in data)
	{
		if (name != "n")
			Game.new_talent_system[name] = data[name]
	}
}


function select_unit_custom(data)
{
	GameUI.SelectUnit( data.index, false)
}


Game.GetGameMode = () =>
{
	if (!custom_pick_table || !custom_pick_table.team_size) return
	return custom_pick_table.team_size
}

Game.GetWinPlace = () =>
{
	if (!custom_pick_table || !custom_pick_table.win_place) return
	return custom_pick_table.win_place
}


Game.GetMaxTeams = () =>
{
	if (!custom_pick_table || !custom_pick_table.max_teams) return
	return custom_pick_table.max_teams
}

Game.GetMaxLevel = (data) =>
{
	let rarity = data["rarity"]
	let max_level = 0

    if (rarity == "blue")
    {
        max_level = 3
    }else if (rarity == "purple" || rarity == "orange")
    {
        max_level = 1
    }

    if (data["main_epic"] == 1)
        max_level = 2

    return max_level
}

Game.GetLocalLegendary = () =>
{	
	let IDs = Game.GetAllPlayerIDs()
	let hero = Entities.GetUnitName(Players.GetLocalPlayerPortraitUnit())
	let result = []
	result[0] = 0
	result[1] = 0
	result[2] = 0

	for (var i = 0; i < Object.keys(IDs).length; i++) 
	{
		var table = CustomNetTables.GetTableValue("networth_players", IDs[i].toString());
		if (table && table.hero_name && table.hero_name == hero)
		{
			if (table.legendary)
			{
				result[0] = table.legendary
			}
			if (table.legendary_talent)
			{
				result[1] = table.legendary_talent
			}
			if (table.legendary_skill_name)
			{
				result[2] = table.legendary_skill_name
			}
			break
		}
	}
	return result
}



Game.HasTalent = (hero_name, talent_name) =>
{

	let talents = CustomNetTables.GetTableValue("upgrades_player", hero_name)

	if ((talents == undefined) || (talents == null))
	{
		return
	}

	let upgrades = talents.upgrades


	if ((upgrades == undefined) || (upgrades == null) || (upgrades[talent_name] == null) || (upgrades[talent_name] == undefined))
	{
		return
	}


	if ((upgrades[talent_name]) > 0)
	{
		return true
	}else 
	{
		return false
	}
	
}


var images_keys =
{

	"2059": "npc_dota_hero_juggernaut_alt1",
	"2068": "npc_dota_hero_juggernaut_alt2",
	"4239": "npc_dota_hero_phantom_assassin_alt1",
	"4560": "npc_dota_hero_phantom_assassin_alt1",
	"4561": "npc_dota_hero_phantom_assassin_alt1",
	"4480": "npc_dota_hero_phantom_assassin_persona1",
	"31081": "npc_dota_hero_phantom_assassin_persona1",
	"28320": "npc_dota_hero_phantom_assassin_persona1",
	"5810":"npc_dota_hero_legion_commander_alt1",
	"6996": "npc_dota_hero_nevermore_alt1",
	"23095": "npc_dota_hero_razor_alt1",
	"2309599": "npc_dota_hero_razor_alt2",
	"12930": "npc_dota_hero_queenofpain_alt1",
	"1293001": "npc_dota_hero_queenofpain_alt2",
	"13456": "npc_dota_hero_skeleton_king_alt1",
	"1345601": "npc_dota_hero_skeleton_king_alt2",
	"905001": "npc_dota_hero_monkey_king_alt1",
	"905002": "npc_dota_hero_monkey_king_alt1",
	"905003": "npc_dota_hero_monkey_king_alt1",
	"905004": "npc_dota_hero_monkey_king_alt1",
	"4794": "npc_dota_hero_lina_alt1",
	"6914": "npc_dota_hero_zuus_alt1",
	"7756": "npc_dota_hero_pudge_alt1",
	"77561": "npc_dota_hero_pudge_alt2",
	"999251": "npc_dota_hero_pudge_persona1",
	"999252": "npc_dota_hero_pudge_persona1",
	"999253": "npc_dota_hero_pudge_persona1",
	"30385": "npc_dota_hero_pudge_persona1",
	"19090": "npc_dota_hero_drow_ranger_alt1",
	"190901": "npc_dota_hero_drow_ranger_alt2",
	"18539": "npc_dota_hero_skywrath_mage_alt1",
	"185391": "npc_dota_hero_skywrath_mage_alt2",
	"13783": "npc_dota_hero_antimage_persona1",
	"27297": "npc_dota_hero_antimage_persona1",
	"29137": "npc_dota_hero_antimage_persona1",
	"29296": "npc_dota_hero_antimage_persona1",
	"28278": "npc_dota_hero_antimage_persona1",
	"29126": "npc_dota_hero_antimage_persona1",
	"12964": "npc_dota_hero_axe_alt",
	"13670":"npc_dota_hero_ogre_magi_alt1",
	"136701": "npc_dota_hero_ogre_magi_alt2",
	"13042": "npc_dota_hero_invoker_persona1",
	"21836": "npc_dota_hero_invoker_persona1",
	"25513": "npc_dota_hero_invoker_persona1",
	"23257": "npc_dota_hero_invoker_persona1",
	"30575": "npc_dota_hero_invoker_persona1",
	"30721": "npc_dota_hero_invoker_persona1",
	"7385": "npc_dota_hero_crystal_maiden_alt1"	,
	"26559": "npc_dota_hero_crystal_maiden_persona1",
	"265591": "npc_dota_hero_crystal_maiden_persona1",
	"265592": "npc_dota_hero_crystal_maiden_persona1",
	"29578": "npc_dota_hero_crystal_maiden_persona1",	
	"5957": "npc_dota_hero_terrorblade_alt1",
}

var hero_images = {}

function update_hero_image(table, key, data)
{
	if (table != "sub_data") return
	if (key == "heroes_vote" || key == -1 || key == "-1") return

	if (!hero_images[key])
		hero_images[key] = {}

	if (data && data.player_items_onequip)
	{
		for (const hero_name of Object.keys(data.player_items_onequip)) 
		{
			let hero_items = data.player_items_onequip[hero_name]

		    hero_images[key][hero_name] = ""

			if (hero_items)
			{
		        for (var i = 1; i <= Object.keys(hero_items).length; i++) 
		        {
		        	let item_id = String(hero_items[i])
		        	if (images_keys[item_id])
		        	{
		        		hero_images[key][hero_name] = images_keys[item_id]
		        	}
		        }
		    }
		}
	}
}

function reconnect_hero_image()
{
	if (Game.GetLocalPlayerID() == -1 || Game.GetLocalPlayerID() == "-1")
	{
		$.Schedule(1, reconnect_hero_image)
	}	

	update_hero_image("sub_data", Game.GetLocalPlayerID(), CustomNetTables.GetTableValue("sub_data", Game.GetLocalPlayerID()))
}




Game.GetHeroImage = (id, hero_name) => 
{

	let name = undefined
	let player_id = Number(id)

	if (hero_name == undefined || hero_name == " " || hero_name == "")
	{
		let info = Game.GetPlayerInfo(player_id)
		if (info && info.player_selected_hero !== "")
		{
			name = info.player_selected_hero
		}
	}else 
	{
		name = hero_name
	}

	if (hero_images[player_id] && hero_images[player_id][hero_name] && hero_images[player_id][hero_name] != "")
	{
		name = hero_images[player_id][hero_name]
	}
	return name
}


Game.GetTalentValue = (name, value_name) => 
{
	for (const hero_name of Object.keys(Game.talents_values)) 
	{	
		if (Game.talents_values[hero_name] !== undefined)
		{
			for (const talent_data of Object.keys(Game.talents_values[hero_name]))
			{

				if ((talent_data == name) && (Game.talents_values[hero_name][talent_data][value_name] !== undefined))
				{

					return Game.talents_values[hero_name][talent_data][value_name]
				}
			} 
		}
	}
	return undefined
}




Game.GetValuesArray = (text) => {
    const keys = new Set(); // Используем Set для уникальных значений
    const regex = /\*!?[+-]?(\w+)[%^]?\*/g;
    
    let match;
    while ((match = regex.exec(text)) !== null) {
        // match[1] содержит чистый ключ без спецсимволов
        keys.add(match[1]);
    }
    
    return Array.from(keys); // Возвращаем массив уникальных ключей
};


Game.roundPlus = (x, n) =>
{ //x - число, n - количество знаков


	if (isNaN(x) || isNaN(n)) return false;

	var m = Math.pow(10, n);

	return Math.round(x * m) / m;

}


Game.ShowTalentValues = (text, name, level, all_levels, legendary, no_color, no_tags) => 
{
	let talent_text = $.Localize(text)

	if (Game.GetTalentValue(name, "alt_talent") != undefined)
	{	
		let hero = Entities.GetUnitName(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()))
		if (hero != undefined && Game.HasTalent(hero, Game.GetTalentValue(name, "alt_talent")))
		{	
			let key = text + "_alt"
			let new_text = $.Localize(key)
			if (key != new_text)
			{
				talent_text = new_text
			}
		}
	}

    let values_array = Game.GetValuesArray(talent_text)
    let values_map = {}
   
    for (const value of values_array) 
    {	
    	values_map[value] = Game.GetTalentValue(name, value)
    }

    talent_text = replaceValues(talent_text, values_map, level, all_levels, legendary, no_color, no_tags);  

    //$.Msg(talent_text)
    //$.Msg()
    return talent_text
}


function replaceValues(str, valuesMap, level, showAll, legendary, no_color, no_tags) 
{
  let color = "#53ea48"; // Стандартный зелёный
  if (legendary) color = "#fb9531"; // Оранжевый для легендарных
  if (no_color) color = "#eee"; // Серый, если no_color
  const darkColor = "#297016"; // Цвет для неактивных уровней

  // Преобразуем level в число один раз в начале
  const currentLevel = Number(level);

  return str.replace(/\*(!?([+-])?)(\w+)(%?)(\^?)\*/g, (match, prefix, sign, key, percent, precisionMark) => {
    if (!valuesMap.hasOwnProperty(key)) return match;

    // Функция для форматирования значения с цветом
    const formatWithColor = (value, useMainColor) => {
      const decimalPlaces = precisionMark === '^' ? 3 : 1;
      const rawValue = String(value).replace(/^[+-]/, '');
      const roundedValue = Game.roundPlus(parseFloat(rawValue), decimalPlaces);
      const formatted = (sign || '') + roundedValue + percent;
      const usedColor = no_color ? color : (useMainColor ? color : darkColor);

      let result = no_tags ? formatted : `<b><font color='${usedColor}'>${formatted}</font></b>`
      return result;
    };

    // Обычные значения (не объект с уровнями)
    if (typeof valuesMap[key] !== 'object' || Array.isArray(valuesMap[key])) {
      if (no_color) {
        return formatWithColor(valuesMap[key], true);
      }
      return prefix.includes('!') 
        ? formatWithColor(valuesMap[key], true)
        : (sign || '') + Game.roundPlus(parseFloat(String(valuesMap[key]).replace(/^[+-]/, '')), precisionMark === '^' ? 3 : 1) + percent;
    }

    // Обработка значений с уровнями (объект)
    const levelValues = valuesMap[key];
    const levels = Object.keys(levelValues).map(Number).sort((a,b) => a-b);
    
    if (showAll) {
      // Показываем все уровни
      return levels.map(lvl => {
        const isCurrentLevel = (lvl === currentLevel); // Используем Number(level)
        return formatWithColor(levelValues[lvl], isCurrentLevel);
      }).join('/');
    } else {
      // Показываем только текущий уровень
      const displayLevel = currentLevel > 0 ? currentLevel : 1;
      return formatWithColor(levelValues[displayLevel], currentLevel > 0);
    }
  });
}


Game.CreateScoreBind = (score_table) => 
{
   const name_bind = "OpenDamageStats" + Math.floor(Math.random() * 99999999);
   var keybind = Game.GetKeybindForCommand(DOTAKeybindCommand_t.DOTA_KEYBIND_SCOREBOARD_TOGGLE);
   Game.CreateCustomKeyBind(keybind, "+" + name_bind);

   Game.AddCommand("+" + name_bind, () => {Game.DamageToggle(true); score_table.OpenScores(true)}, "", 0);
   Game.AddCommand("-" + name_bind, () => {Game.DamageToggle(false); score_table.OpenScores(false)}, "", 0);
}

Game.AllowShop = (id) =>
{
  let lang = $.Localize("#lang")
  let data = CustomNetTables.GetTableValue("server_data", String(id))

  if ((!data?.total_games || data.total_games < 5) && lang !== "rus") 
  {
    return false
  }
  return true
}