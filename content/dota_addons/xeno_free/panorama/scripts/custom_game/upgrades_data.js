Game.upgrades_data = {}
Game.talents_values = {}

GameEvents.OnLoaded(() => {
	const hero_list = CustomNetTables.GetTableValue("custom_pick", "hero_list")
	for (const hero_name of Object.keys(hero_list))
		Game.upgrades_data[hero_name] = CustomNetTables.GetTableValue("all_upgrades", hero_name)

	for (const hero_name of Object.keys(hero_list))
		Game.talents_values[hero_name] = CustomNetTables.GetTableValue("talents_values", hero_name)


	Game.upgrades_data.all = CustomNetTables.GetTableValue("all_upgrades", "all")
	Game.upgrades_data.lowest = CustomNetTables.GetTableValue("all_upgrades", "lowest")
	Game.upgrades_data.patrol_1 = CustomNetTables.GetTableValue("all_upgrades", "patrol_1")
	Game.upgrades_data.patrol_2 = CustomNetTables.GetTableValue("all_upgrades", "patrol_2")
	Game.upgrades_data.alchemist_items = CustomNetTables.GetTableValue("all_upgrades", "alchemist_items")
})



Game.GetHeroImage = (id, hero_name) => 
{

	let name = undefined

	if (hero_name == undefined || hero_name == " " || hero_name == "")
	{
		let info = Game.GetPlayerInfo(Number(id))
		if (info && info.player_selected_hero !== "")
		{
			name = info.player_selected_hero
		}
	}else 
	{
		name = hero_name
	}

	var sub_data = CustomNetTables.GetTableValue("sub_data",  id);

	if (sub_data && sub_data.player_items_onequip)
	{

		let hero_items = sub_data.player_items_onequip[String(hero_name)]

		//$.Msg(hero_items)
		if (hero_items)
		{
	        for (var i = 1; i <= Object.keys(hero_items).length; i++) 
	        {
	            if (String(hero_items[i]) == "2059")
	            {
	                return "npc_dota_hero_juggernaut_alt1"
	            }
	            if (String(hero_items[i]) == "2068")
	            {
	                return "npc_dota_hero_juggernaut_alt2"
	            }

	            if (String(hero_items[i]) == "4239" || String(hero_items[i]) == "4560" || String(hero_items[i]) == "4561")
	            {
	                return "npc_dota_hero_phantom_assassin_alt1"
	            }

	            if (String(hero_items[i]) == "4480" )
	            {
	            	return "npc_dota_hero_phantom_assassin_persona1"
	            }
	        }
	    }
	}

	return hero_name
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


Game.GetValuesCount = (text) => 
{

	let count = 0 

    for (var j = 0; j <= Object.keys(text).length; j++) 
    {
        if (text[j] == "*")
        {
        	count = count + 1
        }	
    }

    if ((count > 0) && (count % 2 == 0))
    {
    	return count/2
    }

	return count
}


Game.GetValuesArray = (text) => 
{

	let array = {}
	let count = 0
    let record = false 

	for (var j = 0; j <= Object.keys(text).length; j++) 
    {
        if (text[j] == "*")
        {
            if (record == true)
            {
                record = false
            }else 
            {
                record = true
            	count = count + 1
            }
        }else
        {
            if ((record == true) && (text[j] !== '%') && (text[j] !== '!') && (text[j] !== '+') && (text[j] !== '-') && (text[j] !== '^'))
            {	
            	if (array[count] == undefined)
            	{
            		array[count] = text[j]
            	}else
            	{
                	array[count] = array[count] + text[j]
            	}
            }
        }
    }

	return array
}



Game.roundPlus = (x, n) =>
{ //x - число, n - количество знаков


	if (isNaN(x) || isNaN(n)) return false;

	var m = Math.pow(10, n);

	return Math.round(x * m) / m;

}



Game.InsertTalentValue = (text, value_name, value, all_levels, level, legendary) => 
{

	let talent_text = text

	let start_index = 0
	let end_index = 0
	let buffer = ""
	let record = false
	let text_before = ""
	let text_after = ""
	let percent = false
	let use_color = false
	let use_sign = ""
	let sign_count = 1


	for (var j = 0; j <= Object.keys(talent_text).length; j++)
	{
		if (text[j] == "*")
        {
            if (record == true)
            {
                record = false

                if (buffer == value_name)
                {
                	end_index = j
					for (var i = 0; i <= Object.keys(talent_text).length; i++)
					{
						if ((i < start_index) && (talent_text[i] !== undefined))
						{
							text_before = text_before + talent_text[i]
						}
	
						if ((i > end_index) && (talent_text[i] !== undefined))
						{
							text_after = text_after + talent_text[i]
						}
					}

                	break
                }else 
                {
                	buffer = ""
                }
            }else 
            {
            	start_index = j
                record = true
            }
        }else
        {
            if (record == true)
            {	
            	if (talent_text[j] == "%")
            	{
            		percent = true
            	}else 
            	{
            		if (talent_text[j] == "!")
            		{
            			use_color = true
            		}else 
            		{
	            		if (talent_text[j] == "^")
	            		{
	            			sign_count = 3
	            		}else 
	            		{
	            			if (talent_text[j] == '+' || talent_text[j] == '-')
	            			{
	            				use_sign = talent_text[j]
	            			}else 
	            			{
	            				buffer = buffer + talent_text[j]
	            			}
	            		}
            		}
            	}
            }
        }
	} 


	if ((text_before !== "") || (text_after !== ""))
	{	
		let add_text = ""

		if ((all_levels == true) && (value[1]))
		{
			for (var j = 1; j <= Object.keys(value).length; j++)
			{

				let level_value = Game.roundPlus(Math.abs(value[j]), sign_count)

				level_value = use_sign + level_value

				if (percent == true)
				{
					level_value = level_value + '%'
				}

				if (use_color == true)
				{

					let color = "297016"

					if (level && level == j)
					{
						color = "53ea48"
					}
					if (legendary == true)
					{
						color = "fb9531"
					}

					level_value = "<b><font color='#" + color + "'>" + level_value + "</font></b>"
				}

				if (j < Object.keys(value).length)
				{
					level_value = level_value + '/'
				}

				add_text = add_text + level_value

			}
		}else 
		{
			if (value[level])
			{
			    value = value[level]
			}

			add_text = use_sign + Game.roundPlus(Math.abs(value), sign_count)

			if (percent == true)
			{
				add_text = add_text + '%'
			}

			if (use_color == true)
			{
				let color = "53ea48"
				if (legendary == true)
				{
					color = "fb9531"
				}
				add_text = "<b><font color='#" + color + "'>" + add_text + "</font></b>"
			}
		}

		talent_text = text_before + add_text + text_after
	}

	return talent_text
}




Game.ShowTalentValues = (text, name, level, all_levels, legendary) => 
{
	let talent_text = text
    let values_count = Game.GetValuesCount(talent_text)


    if (values_count > 0)
    {
        let values_array = Game.GetValuesArray(talent_text)


        for (var j = 1; j <= Object.keys(values_array).length; j++) 
        {
            let talent_value = Game.GetTalentValue(name, values_array[j])

            if (talent_value !== undefined)
            {
                talent_text = Game.InsertTalentValue(talent_text, values_array[j], talent_value, all_levels, level, legendary)
            }
        }

    }

    return talent_text
}




Game.FindUpgradeByName = (hero, name) => {
	for (const group_name of [hero, "all", "lowest", "patrol_1", "patrol_2", "alchemist_items"]) {
		const skills_group = Game.upgrades_data[group_name]
		if (skills_group !== undefined)
			for (const data of Object.values(skills_group))
				if (data[1] === name)
					return data
	}
	return undefined
}

Game.UpgradeMatchesRarity = (data, rarity) => {
	if (typeof data[3] === "string")
		return data[3] === rarity
	for (const v of Object.values(data[3]))
		if (v === rarity)
			return true
	return false
}
