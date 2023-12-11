CustomNetTables.SubscribeNetTableListener( "test_mode", UpdateHeroInfo );

var BotHeroes = CustomNetTables.GetTableValue("test_mode", "bot_heroes")

var local_hero = null

function UpdateHeroInfo(table, key, data ) 
{
	if (table == "test_mode") 
	{
		if (key == "banned_heroes") 
        {	
        	CheckBannedHeroes()
		}
		

	}
}


function CheckBannedHeroes()
{
	var banned_heroes = CustomNetTables.GetTableValue("test_mode", "banned_heroes")

	if (banned_heroes == undefined)
		return


	for (const name of Object.values(banned_heroes)) 
	{
		let panel = $.GetContextPanel().FindChildTraverse(name)

		if (panel && panel !== undefined)
		{
			panel.AddClass("NoTalent")
		}
	}

}


var selected_ent = -1

function CheckSelectedUnit()
{

	if (local_hero == null) 
    {	
		var PlayersHeroes = CustomNetTables.GetTableValue("test_mode", "players_heroes")
    	for (const lua_data of Object.values(PlayersHeroes))
		{
			if (lua_data.id == Game.GetLocalPlayerID())
			{
				let ent = lua_data.ent 

				let icon = $.GetContextPanel().FindChildTraverse("PlayerHero_icon")

				if (icon && icon !== undefined)
				{
					local_hero = Entities.GetUnitName(ent)
					let icon_name = "url('file://{images}/heroes/icons/" + String( Entities.GetUnitName(ent)) + ".png')"
					icon.style.backgroundImage = icon_name
				    icon.style.backgroundSize = "contain";
				    icon.style.backgroundRepeat = "no-repeat";
				}
				break
			}
		} 
	}

  	let ent = Players.GetLocalPlayerPortraitUnit()
  	let is_bot = false

  	let old_ent = selected_ent

	var BotHeroes = CustomNetTables.GetTableValue("test_mode", "bot_heroes")

	if (BotHeroes && BotHeroes !== undefined)
	{
		for (const number of Object.values(BotHeroes)) 
		{
			if (ent == number)
			{
				is_bot = true
				break
			}
		}
		
	}

	let icon_name 

	let icon = $.GetContextPanel().FindChildTraverse("GiveBotTalent_icon")


	if (is_bot == false)
	{
		icon_name = "url('file://{images}/custom_game/no_hero.png')"
		selected_ent = -1
	}else 
	{
		icon_name = "url('file://{images}/heroes/icons/" + String( Entities.GetUnitName(ent)) + ".png')"
		selected_ent = ent
	}

	if (icon !== undefined)
	{
		icon.style.backgroundImage = icon_name
	    icon.style.backgroundSize = "contain";
	    icon.style.backgroundRepeat = "no-repeat";
	}


	if (old_ent !== selected_ent)
	{
		if (current_state == 5)
		{
			ChangeTalentWindow(5)
		}
		if (current_state == 4)
		{
			ChangeTalentWindow(4)
		}
	}

  	$.Schedule(0.1, CheckSelectedUnit)
}



function init()
{
	GameEvents.Subscribe_custom("update_test_talents", update_test_talents)
	GameEvents.Subscribe_custom("lua_timer_stop", lua_timer_stop)
	GameEvents.Subscribe_custom("lua_wtf_mode", lua_wtf_mode)
	GameEvents.Subscribe_custom("set_test_mode", set_test_mode)
}

function lua_timer_stop(kv)
{
	let stop = kv.stop
	let button = $.GetContextPanel().FindChildTraverse("StopTimer")

	if (button == undefined)
		return

	if (stop == 1)
	{
		button.AddClass("TestMode_botton_pressed")
	}else 
	{
		button.RemoveClass("TestMode_botton_pressed")
	}

}

function lua_wtf_mode(kv)
{
	let wtf = kv.wtf
	let button = $.GetContextPanel().FindChildTraverse("WtfMode")

	if (button == undefined)
		return

	if (wtf == 1)
	{
		button.AddClass("TestMode_botton_pressed")
	}else 
	{
		button.RemoveClass("TestMode_botton_pressed")
	}

}


function set_test_mode(kv)
{
	let state = kv.state

	let main = $.GetContextPanel().FindChildTraverse("TestMode_panel_and_button")


	if (main == undefined)
	return

	if (state == 1 && !main.BHasClass("TestMode_open"))
	{
		main.RemoveClass("TestMode_disabled")
		ChangeState()	
	}
}


var cd = false

function ChangeState()
{

	if (cd == true)
	return
	
	let main = $.GetContextPanel().FindChildTraverse("TestMode_panel_and_button")
	let icon = $.GetContextPanel().FindChildTraverse("TestMode_button_icon")

	
	let content = $.GetContextPanel().FindChildTraverse("TestMode_Content")
	let list = $.GetContextPanel().FindChildTraverse("TalentsList")
	if (main == undefined)
	return


	cd = true

	$.Schedule( 0.25, function(){ 
		cd = false
 	})

	if (main.BHasClass("TestMode_open"))
	{
		main.RemoveClass("TestMode_open")
		main.AddClass("TestMode_close")
        Game.EmitSound("UI.Talent_hide")
        CloseContentWindow()

		$.Schedule( 0.20, function(){ 
			icon.AddClass("TestMode_button_closed")
			main.AddClass("TestMode_closed")
	 	})

	}else
	{
        Game.EmitSound("UI.Talent_show")
		main.RemoveClass("TestMode_close")
		main.RemoveClass("TestMode_closed")
		main.AddClass("TestMode_open")
		icon.RemoveClass("TestMode_button_closed")
	}
	

}


var orb_cd = false

function GiveOrb(type)
{
	if (orb_cd == true)
	return

	orb_cd = true

	$.Schedule( 0.2, function(){ 
		orb_cd = false
	})
	Game.EmitSound("UI.Click")	
   GameEvents.SendCustomGameEventToServer_custom("GiveOrb", {type})
}

var talent_cd = false

function ChangeTalentWindow(type)
{
	if (talent_cd == true)
	return

	talent_cd = true

	$.Schedule( 0.1, function(){ 
		talent_cd = false
	})


	let main = $.GetContextPanel().FindChildTraverse("TestMode_Content")

	if (main == undefined)
	return
	Game.EmitSound("UI.Click")	

	if (type == current_state)
	{
		CloseContentWindow()
		return
	}

	main.RemoveClass("TestMode_hidden")
	if (type == 1)
	{
		ShowTalents()
	}

	if (type == 2)
	{
		ShowItems()
	}

	if (type == 3)
	{
		ShowHeroes()
	}

	if (type == 4)
	{
		ShowBotItems()
	}

	if (type == 5)
	{
		ShowBotTalents()
	}

}


var current_state = 0

function ClearWindow()
{

	let talents_button = $.GetContextPanel().FindChildTraverse("TalentsList")
	let items_button = $.GetContextPanel().FindChildTraverse("GiveItem")
	let heroes_button = $.GetContextPanel().FindChildTraverse("CreateBot")
	let bot_items_button = $.GetContextPanel().FindChildTraverse("GiveBotItem")
	let bot_talents_button = $.GetContextPanel().FindChildTraverse("GiveBotTalent")

	let main = $.GetContextPanel().FindChildTraverse("TestMode_Content")

	heroes_button.RemoveClass("TestMode_botton_pressed")
	talents_button.RemoveClass("TestMode_botton_pressed")
	items_button.RemoveClass("TestMode_botton_pressed")
	bot_items_button.RemoveClass("TestMode_botton_pressed")
	bot_talents_button.RemoveClass("TestMode_botton_pressed")


	main.RemoveClass("TestMode_Content_Items")
	main.RemoveClass("TestMode_Content_Talents")
	main.RemoveClass("TestMode_Content_Heroes")
	main.RemoveClass("TestMode_Content_BotItems")
	main.RemoveClass("TestMode_Content_BotTalents")

	let tempo = $.GetContextPanel().FindChildTraverse("TestMode_content_tempo")

	if (tempo && tempo !== undefined)
	{
		tempo.DeleteAsync(0)
	}
}



function CloseContentWindow()
{
	let main = $.GetContextPanel().FindChildTraverse("TestMode_Content")
	current_state = 0


	main.AddClass("TestMode_hidden")
	main.RemoveClass("TestMode_Content_Items")
	main.RemoveClass("TestMode_Content_Talents")

	ClearWindow()
}


var damage_items = 
[
	"item_moon_shard",
	"item_rapier",
	"item_monkey_king_bar",
	"item_greater_crit",
	"item_nullifier",
	"item_desolator",
	"item_disperser",
	"item_silver_edge_custom",
	"item_mjollnir",
	"item_bloodthorn",
	"item_revenants_brooch",
	"item_witchfury",
	"item_radiance_custom",
	"item_veil_of_corruption",
	"item_dagon_5_custom",
	"item_manaflare_lens_custom"
]

var surv_items = 
[
	"item_black_king_bar_custom",
	"item_heart_custom",
	"item_satanic",
	"item_shivas_guard",
	"item_assault",
	"item_crimson_guard_custom",
	"item_spell_breaker",
	"item_guardian_greaves_custom",
	"item_blade_mail_custom",
	"item_butterfly_custom",
	"item_skadi",
	"item_sange_and_yasha",
	"item_bloodstone_custom",
	"item_lotus_orb",
	"item_aeon_disk_custom",
	"item_sphere_custom"
]

var util_items = 
[
	"item_heavens_halberd",
	"item_abyssal_blade",
	"item_sheepstick",
	"item_rod_of_atos",
	"item_manta_custom",
	"item_celestial_spear_custom",
	"item_harpoon_custom",
	"item_hurricane_pike",
	"item_wind_waker",
	"item_ethereal_blade",
	"item_octarine_core",
	"item_blink",
	"item_travel_boots_2_custom",
	"item_gem",
	"item_ultimate_scepter",
	"item_aghanims_shard"

]

var neutral_items = 
[
	"item_titan_sliver",
	"item_book_of_shadows",
	"item_mirror_shield",
	"item_force_boots_custom",
	"item_apex",
	"item_pirate_hat",
	"item_seer_stone_custom"

]

function ShowBotItems()
{

	if (selected_ent == -1)
	{	
		GameEvents.SendCustomGameEventToServer_custom("NoBot", {})
		return
	}

	$.Msg('asdg')

	let ent = selected_ent

	ClearWindow()

	let items_button = $.GetContextPanel().FindChildTraverse("GiveBotItem")

	items_button.AddClass("TestMode_botton_pressed")

	current_state = 4

	let main = $.GetContextPanel().FindChildTraverse("TestMode_Content")

	main.AddClass("TestMode_Content_BotItems")

	let tempo = $.CreatePanel("Panel", main, "TestMode_content_tempo")
	tempo.AddClass("TestMode_content_tempo")
	tempo.AddClass("flow_down")
	tempo.AddClass("ItemsList")


	let attribute_info = $.CreatePanel("Panel", tempo, "");
	attribute_info.AddClass("attribute_info")

	let hero_label_str = $.CreatePanel("Label", attribute_info, "");
	hero_label_str.AddClass("hero_label")
	hero_label_str.text = $.Localize("#item_damage")

	const damage_row = $.CreatePanel("Panel", tempo, "StrengthHeroes");


	let attribute_info_2 = $.CreatePanel("Panel", tempo, "");
	attribute_info_2.AddClass("attribute_info")

	let hero_label_agi = $.CreatePanel("Label", attribute_info_2, "");
	hero_label_agi.AddClass("hero_label")
	hero_label_agi.text =  $.Localize("#item_surv")

	const surv_row = $.CreatePanel("Panel", tempo, "AgilityHeroes");


	let attribute_info_3 = $.CreatePanel("Panel", tempo, "");
	attribute_info_3.AddClass("attribute_info")

	let hero_label_int = $.CreatePanel("Label", attribute_info_3, "");
	hero_label_int.AddClass("hero_label")
	hero_label_int.text =  $.Localize("#item_util")

	const util_row =  $.CreatePanel("Panel", tempo, "IntellectHeroes");




	let attribute_info_4 = $.CreatePanel("Panel", tempo, "");
	attribute_info_4.AddClass("attribute_info")

	let neutral_labal = $.CreatePanel("Label", attribute_info_4, "");
	neutral_labal.AddClass("hero_label")
	neutral_labal.text = $.Localize("#item_neutral")

	const neutral_row =  $.CreatePanel("Panel", tempo, "AllHeroes");




	for (var i = 0; i < Object.keys(damage_items).length; i++) 
	{
		CreateItemPanel(damage_row, damage_items[i], ent)
	}

	for (var i = 0; i < Object.keys(surv_items).length; i++) 
	{
		CreateItemPanel(surv_row, surv_items[i], ent)
	}

	for (var i = 0; i < Object.keys(util_items).length; i++) 
	{
		CreateItemPanel(util_row, util_items[i], ent)
	}

	for (var i = 0; i < Object.keys(neutral_items).length; i++) 
	{
		CreateItemPanel(neutral_row, neutral_items[i], ent)
	}
}


function CreateItemPanel(panel, item_name, ent) 
{



	var item = $.CreatePanel("DOTAItemImage", panel, item_name)
	item.AddClass("ItemImage")
	item.itemname = item_name

    SetClickEnt(item, item_name, "AddBotItem", ent)

}





var item_list = 
[	
	"item_aghanims_shard",
	"item_essence_of_speed",
	"item_patrol_trap",
	"item_gem",
	"item_gray_upgrade",
	"item_blue_upgrade",
	"item_purple_upgrade",
	"item_legendary_upgrade",
	"item_patrol_reward_1",
	"item_patrol_reward_2",
	"item_tier5_token",
	"item_tier4_token",
	"item_tier3_token",
	"item_tier2_token",
	"item_tier1_token",
	"item_alchemist_gold_heart",
	"item_alchemist_gold_octarine",
	"item_alchemist_gold_cuirass",
	"item_alchemist_gold_daedalus",
	"item_alchemist_gold_skadi",
	"item_alchemist_gold_shiva",
	"item_alchemist_gold_bfury",
	"item_muerta_mercy_and_grace_full_custom",


]

function ShowItems()
{
	ClearWindow()

	let items_button = $.GetContextPanel().FindChildTraverse("GiveItem")

	items_button.AddClass("TestMode_botton_pressed")

	current_state = 2

	let main = $.GetContextPanel().FindChildTraverse("TestMode_Content")

	main.AddClass("TestMode_Content_Items")

	let tempo = $.CreatePanel("Panel", main, "TestMode_content_tempo")
	tempo.AddClass("TestMode_content_tempo")
	tempo.AddClass("flow_down")
	tempo.AddClass("HeroItemsList")



	const neutral_row =  $.CreatePanel("Panel", tempo, "AllHeroes");

	for (const name of Object.values(item_list)) 
	{
		
		let item = $.CreatePanel("DOTAItemImage", neutral_row, name)
		item.AddClass("ItemImage");
		item.itemname = name

		SetClick(item, name, "AddItem")
	}


}





function ShowHeroes()
{
	ClearWindow()

	let heroes_button = $.GetContextPanel().FindChildTraverse("CreateBot")
	heroes_button.AddClass("TestMode_botton_pressed")

	current_state = 3

	let main = $.GetContextPanel().FindChildTraverse("TestMode_Content")

	main.AddClass("TestMode_Content_Heroes")

	let tempo = $.CreatePanel("Panel", main, "TestMode_content_tempo")
	tempo.AddClass("TestMode_content_tempo")
	tempo.AddClass("flow_down")
	tempo.AddClass("HeroList")

	let table_heroes = CustomNetTables.GetTableValue("custom_pick", "hero_list")

	const hero_names_sorted = [...Object.keys(table_heroes)].sort()

	let heroes_strength = []
	let heroes_agility = []
	let heroes_intellect = []
	let heroes_all = []

	for (const hero_name of hero_names_sorted)
	{
		if (table_heroes[hero_name] == 0)
		{
			heroes_strength.push(hero_name)
		} else if (table_heroes[hero_name] == 1) {
			heroes_agility.push(hero_name)
		} else if (table_heroes[hero_name] == 2) {
			heroes_intellect.push(hero_name)
		} else if (table_heroes[hero_name] == 3) {
			heroes_all.push(hero_name)
		}
	}



	let attribute_info = $.CreatePanel("Panel", tempo, "");
	attribute_info.AddClass("attribute_info")

	let hero_icon_str = $.CreatePanel("Panel", attribute_info, "");
	hero_icon_str.AddClass("hero_icon_str")

	let hero_label_str = $.CreatePanel("Label", attribute_info, "");
	hero_label_str.AddClass("hero_label")
	hero_label_str.text = $.Localize("#DOTA_Tooltip_Ability_item_power_treads_str")

	const str_row = $.CreatePanel("Panel", tempo, "StrengthHeroes");


	let attribute_info_2 = $.CreatePanel("Panel", tempo, "");
	attribute_info_2.AddClass("attribute_info")

	let hero_icon_agi = $.CreatePanel("Panel", attribute_info_2, "");
	hero_icon_agi.AddClass("hero_icon_agi")

	let hero_label_agi = $.CreatePanel("Label", attribute_info_2, "");
	hero_label_agi.AddClass("hero_label")
	hero_label_agi.text = $.Localize("#DOTA_Tooltip_Ability_item_power_treads_agi")



	const agi_row = $.CreatePanel("Panel", tempo, "AgilityHeroes");


	let attribute_info_3 = $.CreatePanel("Panel", tempo, "");
	attribute_info_3.AddClass("attribute_info")

	let hero_icon_int = $.CreatePanel("Panel", attribute_info_3, "");
	hero_icon_int.AddClass("hero_icon_int")

	let hero_label_int = $.CreatePanel("Label", attribute_info_3, "");
	hero_label_int.AddClass("hero_label")
	hero_label_int.text = $.Localize("#DOTA_Tooltip_Ability_item_power_treads_int")

	const int_row = $.CreatePanel("Panel", tempo, "IntellectHeroes");


	let attribute_info_4 = $.CreatePanel("Panel", tempo, "");
	attribute_info_4.AddClass("attribute_info")

	let hero_icon_all = $.CreatePanel("Panel", attribute_info_4, "");
	hero_icon_all.AddClass("hero_icon_all")

	let hero_label_all = $.CreatePanel("Label", attribute_info_4, "");
	hero_label_all.AddClass("hero_label")
	hero_label_all.text = $.Localize("#stats_all")

	const all_row = $.CreatePanel("Panel", tempo, "AllHeroes");

	for (var i = 0; i < Object.keys(heroes_strength).length; i++) 
	{
		CreateHeroPanel(str_row, heroes_strength[i], 1)
	}

	for (var i = 0; i < Object.keys(heroes_agility).length; i++) 
	{
		CreateHeroPanel(agi_row, heroes_agility[i], 2)
	}

	for (var i = 0; i < Object.keys(heroes_intellect).length; i++) 
	{
		CreateHeroPanel(int_row, heroes_intellect[i], 3)
	}

	for (var i = 0; i < Object.keys(heroes_all).length; i++) 
	{
		CreateHeroPanel(all_row, heroes_all[i], 4)
	}
	
	CheckBannedHeroes()
}





function CreateHeroPanel(panel, hero_name, stat) 
{

	var HeroImage = $.CreatePanel("Panel", panel, hero_name)
	HeroImage.AddClass("HeroImage")
	HeroImage.style.backgroundImage = "url('file://{images}/heroes/" + String(hero_name) + ".png')"
    HeroImage.style.backgroundSize = "contain";
    HeroImage.style.backgroundRepeat = "no-repeat";

    SetClick(HeroImage, hero_name, "AddHero")

}



function ShowBotTalents()
{

	if (selected_ent == -1)
	{
		GameEvents.SendCustomGameEventToServer_custom("NoBot", {})
		return
	}

	ClearWindow()
	current_state = 5

	let button = $.GetContextPanel().FindChildTraverse("GiveBotTalent")
	button.AddClass("TestMode_botton_pressed")

	let main = $.GetContextPanel().FindChildTraverse("TestMode_Content")
	main.AddClass("TestMode_Content_BotTalents")

	let tempo = $.CreatePanel("Panel", main, "TestMode_content_tempo")
	tempo.AddClass("TestMode_content_tempo")
	tempo.AddClass("flow_down")


	DrawTalents(tempo, selected_ent)
}

function ShowTalents()
{


	var PlayersHeroes = CustomNetTables.GetTableValue("test_mode", "players_heroes")
	let ent = -1 

	if (PlayersHeroes && PlayersHeroes !== undefined)
	{
		for (const data of Object.values(PlayersHeroes))
		{
			if (data.id == Game.GetLocalPlayerID())
			{
				ent = data.ent 
				break
			}
		} 
	}


	if (ent == -1)
		return

	ClearWindow()
	current_state = 1

	let button = $.GetContextPanel().FindChildTraverse("TalentsList")
	button.AddClass("TestMode_botton_pressed")

	let main = $.GetContextPanel().FindChildTraverse("TestMode_Content")

	main.AddClass("TestMode_Content_Talents")

	let tempo = $.CreatePanel("Panel", main, "TestMode_content_tempo")
	tempo.AddClass("TestMode_content_tempo")
	tempo.AddClass("flow_down")

	
	DrawTalents(tempo, ent)
}




function DrawTalents(main, ent)
{

	let orange_layer = $.CreatePanel("Panel", main, "OrangeLayer")
	orange_layer.AddClass("OrangeLayer")

	let purple_layer = $.CreatePanel("Panel", main, "PurpleLayer")
	purple_layer.AddClass("PurpleLayer")

	let blue_layer = $.CreatePanel("Panel", main, "BlueLayer")
	blue_layer.AddClass("BlueLayer")

	let general_layer = $.CreatePanel("Panel", main, "GeneralLayer")
	general_layer.AddClass("GeneralLayer")

	let general_layer_purple = $.CreatePanel("Panel", general_layer, "")
	general_layer_purple.AddClass("GeneralPurple_Layer")

	let general_layer_blue = $.CreatePanel("Panel", general_layer, "")
	general_layer_blue.AddClass("GeneralBlue_Layer")

	let general_layer_gray = $.CreatePanel("Panel", general_layer, "")
	general_layer_gray.AddClass("GeneralGray_Layer")

    var hero = Entities.GetUnitName(ent)

    var player_table = CustomNetTables.GetTableValue("upgrades_player", hero)


    let purple_blocks = []
    let blue_blocks = []
    let orange_blocks = []

    for (var i = 1; i <= 4; i++)
    {
    	orange_blocks[i] = $.CreatePanel("Panel", orange_layer, "")
    	orange_blocks[i].AddClass("Block_container")

    	let container = $.CreatePanel("Panel", purple_layer, "")
    	container.AddClass("Block_container")

    	purple_blocks[i] = $.CreatePanel("Panel", container, "")
    	purple_blocks[i].AddClass("TalentBlocks")
    
		container = $.CreatePanel("Panel", blue_layer, "")
    	container.AddClass("Block_container")

    	blue_blocks[i] = $.CreatePanel("Panel", container, "")
    	blue_blocks[i].AddClass("TalentBlocks")

    }	

	for (const data of Object.values(Game.upgrades_data[hero])) 
	{
		let name = data[1]
		let lvl
		
        if (player_table !== undefined)
			lvl = player_table.upgrades[name]

		let icon 
		let icon_name

		if (data[3] == "orange")
		{
			icon = $.CreatePanel("Panel", orange_blocks[data[9]], name)
			icon.AddClass("OrangeLayer_icon")
            MouseOverTalent(icon, $.Localize('#upgrade_disc_' + name), name, lvl, false, true)
            icon_name = data[6]
		}

		if (data[3] == "purple")
		{

			let icon_and_level = $.CreatePanel("Panel", purple_blocks[data[8]], "")
			icon_and_level.AddClass("icon_and_level")
			icon_and_level.AddClass("purple_border")

			icon = $.CreatePanel("Panel", icon_and_level, name)
			icon.AddClass("PurpleBlueLayer_icon")

          	let talent_text = $.Localize('#upgrade_disc_' + name)
            var final_text = ""

            if (talent_text == "#upgrade_disc_" + name)
            {
                if (data[4] > 1) 
                {
                    let fake_lvl = lvl !== undefined ? lvl : 0
                    final_text = $.Localize('#talent_disc_' + name + '_' + fake_lvl)
                } else {
                    final_text = $.Localize('#upgrade_disc_' + name + '_1')
                }

                MouseOver(icon, final_text )
            }else 
            {
                MouseOverTalent(icon, talent_text, name, lvl, true)
            }


            s = 'slevel_0'

            if (lvl !== undefined) 
            {
				s = 'epic_level_' + data[4] + lvl

			}

            let level = $.CreatePanel("Panel", icon_and_level, name + "_level")
            level.AddClass("PurpleBlueLayer_level")
			level.AddClass("purple_border_top")
            level.style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
            level.style.backgroundSize = "100%";
            level.style.backgroundRepeat = "no-repeat";

			icon_name = data[9]

		}


		if (data[3] == "blue")
		{
			let icon_and_level = $.CreatePanel("Panel", blue_blocks[data[8]], "")
			icon_and_level.AddClass("icon_and_level")
			icon_and_level.AddClass("blue_border")

			icon = $.CreatePanel("Panel", icon_and_level, name)
			icon.AddClass("PurpleBlueLayer_icon")

          	let talent_text = $.Localize('#upgrade_disc_' + name)
            var final_text = ""

            if (talent_text == "#upgrade_disc_" + name)
            {
                if (data[4] > 1) 
                {
                    let fake_lvl = lvl !== undefined ? lvl : 0
                    final_text = $.Localize('#talent_disc_' + name + '_' + fake_lvl)
                } else {
                    final_text = $.Localize('#upgrade_disc_' + name + '_1')
                }

                MouseOver(icon, final_text )
            }else 
            {
                MouseOverTalent(icon, talent_text, name, lvl, true)
            }
			icon_name = data[9]

        	s = 'slevel_0'

            if (lvl !== undefined) 
            {
				s = 'blue_level_' + lvl
			}


			let level = $.CreatePanel("Panel", icon_and_level, name + "_level")
            level.AddClass("PurpleBlueLayer_level")
			level.AddClass("blue_border_top")
            level.style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
            level.style.backgroundSize = "100%";
            level.style.backgroundRepeat = "no-repeat";
		}


		if (icon && icon !== undefined)
		{
	        icon.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + icon_name + '.png")';
	        icon.style.backgroundSize = "contain";
	        icon.style.backgroundRepeat = "no-repeat";

	        if (lvl == undefined) 
	        {
	        	icon.AddClass("NoTalent")
	        }
	        SetClickEnt(icon, name, "AddTalent",  ent)
	    }
	}



	for (const data of Object.values(Game.upgrades_data.all))
	{
		let name = data[1]
		let lvl
		
        if (player_table !== undefined)
			lvl = player_table.upgrades[name]

		let icon 
		let icon_name

		let type = data[3]

		if (type[1] !== undefined && type[1][1] !== undefined)
		{
			for (const table of Object.values(type))
			{
				if (table == "gray" || table == "blue" || table == "purple")
				{
					type = table
					break
				}
			}
		}

		if (type == "gray")
		{
			icon = $.CreatePanel("Panel", general_layer_gray, name)
			icon.AddClass("GeneralTalent")
			icon.AddClass("gray_border")

            var t = '+' + String(Math.trunc(data[8])) + $.Localize('#talent_disc_' + name)
            MouseOver(icon, t)

            let level = $.CreatePanel("Label", icon, name + '_count')
            level.AddClass("GeneralTalent_count")

            if (lvl !== undefined)
            level.text = String(lvl)

		}
		if (type == "blue")
		{
			icon = $.CreatePanel("Panel", general_layer_blue, name)
			icon.AddClass("GeneralTalent")
			icon.AddClass("blue_border")
			let fake_lvl = lvl !== undefined ? lvl : 1
            MouseOver(icon, $.Localize('#upgrade_disc_' + name + '_' + fake_lvl))

            let level = $.CreatePanel("Label", icon, name + '_count')
            level.AddClass("GeneralTalent_count")

            if (lvl !== undefined)
            level.text = String(lvl)

		}
		if (type == "purple")
		{
			icon = $.CreatePanel("Panel", general_layer_purple, name)
			icon.AddClass("GeneralTalent")
			icon.AddClass("purple_border")

            MouseOver(icon, $.Localize('#upgrade_disc_' + name) + '_1')
		}

		if (icon && icon !== undefined)
		{
	        icon.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + data[6] + '.png")';
	        icon.style.backgroundSize = "contain";
	        icon.style.backgroundRepeat = "no-repeat";

	        if (lvl == undefined) 
	        {
	        	icon.AddClass("NoTalent")
	        }
	        SetClickEnt(icon, name, "AddTalent", ent)
	    }
	}
}



function MouseOverTalent(panel, talent_text, name, lvl, all_levels, legendary) 
{

    panel.SetPanelEvent('onmouseover', function() 
    {
        let text = Game.ShowTalentValues(talent_text, name, lvl, all_levels, legendary)

        $.DispatchEvent('DOTAShowTextTooltip', panel, text)
    });

    panel.SetPanelEvent('onmouseout', function() 
    {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });

}

function MouseOver(panel, text) {
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, text)
    });

    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });

}




function update_test_talents(data)
{

	let lvl = data.level
	let type = data.type
	let name = data.name
	let max = data.max

	let icon = $.GetContextPanel().FindChildTraverse(name)
	let level = $.GetContextPanel().FindChildTraverse(name + '_level')
	let count = $.GetContextPanel().FindChildTraverse(name + '_count')

	if (icon && icon !== undefined)
	{
		icon.RemoveClass("NoTalent")
	}

	if (level && level !== undefined)
	{
		if (type == "purple")
		{
			let s = 'slevel_0'

            if (lvl !== undefined) 
            {
				s = 'epic_level_' + max + lvl
			}
            level.style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
            level.style.backgroundSize = "100%";
            level.style.backgroundRepeat = "no-repeat";
		}

		if (type == "blue")
		{
			s = 'slevel_0'

            if (lvl !== undefined) 
            {
				s = 'blue_level_' + lvl
			}
            level.style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
            level.style.backgroundSize = "100%";
            level.style.backgroundRepeat = "no-repeat";
		}
	}
	if (count && count !== undefined)
	{
		count.text = String(lvl)
	}

}




var pick_cd = false


function SetClickEnt(panel, value, event, ent)
{


	panel.SetPanelEvent("onactivate", function() 
	{
		if (pick_cd == true)
		return

		pick_cd = true

		$.Schedule( 0.1, function(){ 
			pick_cd = false
		})

		Game.EmitSound("UI.Click")	
   		GameEvents.SendCustomGameEventToServer_custom(event, {value, ent})
	});
}


function SetClick(panel, value, event)
{


	panel.SetPanelEvent("onactivate", function() 
	{
		if (pick_cd == true)
		return

		pick_cd = true

		$.Schedule( 0.1, function(){ 
			pick_cd = false
		})

		Game.EmitSound("UI.Click")	
   		GameEvents.SendCustomGameEventToServer_custom(event, {value})
	});
}


function GiveLevel(value)
{

	Game.EmitSound("UI.Click")	
	GameEvents.SendCustomGameEventToServer_custom("AddLevel", {value})
}

function GiveGold(value)
{

	Game.EmitSound("UI.Click")	
	GameEvents.SendCustomGameEventToServer_custom("AddGold", {value})
}


function LevelBots(value)
{

	Game.EmitSound("UI.Click")	
	if (selected_ent == -1)
	{
		GameEvents.SendCustomGameEventToServer_custom("NoBot", {})
		return
	}

	let ent = selected_ent
	GameEvents.SendCustomGameEventToServer_custom("LevelBots", {value, ent})
}

function StopTimer()
{

	Game.EmitSound("UI.Click")	
	GameEvents.SendCustomGameEventToServer_custom("stop_timer", {})
}
function RefreshButton()
{

	Game.EmitSound("UI.Click")	
	GameEvents.SendCustomGameEventToServer_custom("RefreshButton", {})
}



function WtfMode()
{

	Game.EmitSound("UI.Click")	
	GameEvents.SendCustomGameEventToServer_custom("wtf_mode", {})
}


init()
CheckSelectedUnit()