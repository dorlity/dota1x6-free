


Game.init_talent_panel = (panel, hero_alt, pick_stage) =>
{

    var LayerGeneral = panel
    LayerGeneral.style.backgroundSize = "contain";

    hero_alt = String(hero_alt)
    if (hero_alt == "undefined") 
    {
        var hero_ent = Players.GetLocalPlayerPortraitUnit();
        var hero = Entities.GetUnitName(hero_ent)
    } else 
    {
        var hero = hero_alt
    }

    let use_new_system = false
    if (Game.new_talent_system[hero])
        use_new_system = true

    var LayerGray_Left = LayerGeneral.FindChildTraverse("LayerGray_left")
    var LayerPlayer_Skills = LayerGeneral.FindChildTraverse("LayerPlayer_Skills")
    var LayerGray_Right = LayerGeneral.FindChildTraverse("LayerGray_Right")
    var LayerOrange = LayerGeneral.FindChildTraverse("LayerOrange")
    var LayerPurple = LayerGeneral.FindChildTraverse("LayerPurple")
    var LayerBlue = LayerGeneral.FindChildTraverse("LayerBlue")

    let LayerHeroTalents = LayerGeneral.FindChildTraverse("LayerHeroTalents")

    var LayerPurple_skill = []
    var LayerBlue_skill = []

    for (var i = 0; i <= 4; i++)
    {
        LayerPurple_skill[i] = LayerGeneral.FindChildTraverse("LayerPurple_skill_" + String(i))
        LayerBlue_skill[i] = LayerGeneral.FindChildTraverse("LayerBlue_skill_" + String(i))
    }

    if (use_new_system == true)
    {
        LayerHeroTalents.RemoveClass("talents_panel_hidden")
        LayerGray_Right.AddClass("talents_panel_hidden") 
        LayerPlayer_Skills.AddClass("talents_panel_hidden")

        if (pick_stage == true)
        {
           LayerGray_Left.AddClass("talents_panel_hidden") 
        }else
        {
           LayerGray_Left.RemoveClass("talents_panel_hidden") 
        }
    }else
    {
        LayerHeroTalents.AddClass("talents_panel_hidden")
        LayerPlayer_Skills.RemoveClass("talents_panel_hidden")

        if (pick_stage == true)
        {
           LayerGray_Left.AddClass("talents_panel_hidden") 
           LayerGray_Right.AddClass("talents_panel_hidden") 
           LayerPlayer_Skills.RemoveClass("LayerPlayer_Skills_Normal")
           LayerPlayer_Skills.AddClass("LayerPlayer_Skills_PickStage")
        }else
        {
           LayerGray_Left.RemoveClass("talents_panel_hidden") 
           LayerGray_Right.RemoveClass("talents_panel_hidden")
           LayerPlayer_Skills.AddClass("LayerPlayer_Skills_Normal")
           LayerPlayer_Skills.RemoveClass("LayerPlayer_Skills_PickStage")
        }
    }

    var players_heroes = CustomNetTables.GetTableValue("hero_portrait_levels", hero)
    var player_id = Game.GetLocalPlayerID()

    if (players_heroes)
        player_id = players_heroes["id"]

    player_id = Number(player_id)

    let hero_index = Players.GetPlayerHeroEntityIndex(player_id)

    var player_table = CustomNetTables.GetTableValue("upgrades_player", hero)
    let common_bonus = 0
    if (player_table && player_table.common_bonus)
    {
        common_bonus = player_table.common_bonus/100
    }

    if (use_new_system)
    {
        let icon = $.GetContextPanel().FindChildTraverse("hero_talent_hero")
        icon.style.backgroundImage = 'url( "file://{images}/heroes/' + Game.GetHeroImage(player_id, hero) + '.png" );'
        icon.style.backgroundSize = 'contain';
        icon.style.backgroundRepeat = 'no-repeat'

        MouseOver(icon.GetParent(), $.Localize("#new_talent_system"))
    }

    var legendary_count = 1
    var purple_count = 1
    var blue_count = 1
    var icon_buffer = ''

    let talent_table = Game.talents_values[hero]
    Object.entries(talent_table).map(([key, data]) => (data["name"] = key, data["name_number"] = key[Object.keys(key).length - 1], data))

    talent_table = Object.values(talent_table)
    talent_table.sort((a, b) => (a["skill_number"] - b["skill_number"]))

    var skills_array = {}

    for (const index in talent_table)
    {
        let number = talent_table[index]["skill_number"]
        let name_number = talent_table[index]["name_number"]

        if (name_number == "y")  name_number = "7"
        if (!skills_array[number]) skills_array[number] = []   

        talent_table[index]["name_number"] = Number(name_number)

        skills_array[number].push(talent_table[index])
    }

    for (const skill in skills_array)
    {
        skills_array[skill].sort((a, b) => (a["name_number"] - b["name_number"]))
        
        let new_purple_count = 0
        let new_blue_count = 0

        for (const data of skills_array[skill])
        {
            let mini_icon = data["mini_icon"]
            let rarity = data["rarity"]
            let name = data["name"]
            let skill_number = data["skill_number"]
            let max_level = Game.GetMaxLevel(data)
            let skill_name = null

            if (Game.spells_by_number[hero] && Game.spells_by_number[hero][skill_number])  
                skill_name = Game.spells_by_number[hero][skill_number]["name"]

            let lvl = undefined

            if (player_table !== undefined)
                lvl = player_table.upgrades[name]

            let skill_panel = $.GetContextPanel().FindChildTraverse("LayerHeroTalents_Skill_" + skill_number)


            if (rarity == "orange") 
            {
                let orange_card = LayerOrange.FindChildTraverse("orange_card_" + String(legendary_count))
                let orange_content = orange_card.FindChildTraverse("orange_content_" + String(legendary_count))
                let orange_icon = orange_card.FindChildTraverse("orange_icon_" + String(legendary_count))
                let orange_lvl = orange_card.FindChildTraverse("orange_lvl_" + String(legendary_count))
                legendary_count++

                if (use_new_system && skill_panel)
                {
                    orange_content = skill_panel.FindChildTraverse("talent_orange_card")
                    orange_icon = skill_panel.FindChildTraverse("talent_orange_icon")
                    orange_lvl = skill_panel.FindChildTraverse("talent_orange_lvl")
                }
        
                orange_content.RemoveClass("orange_content_anim");

                let ability = Entities.GetAbilityByName(hero_index, skill_name)
                if (ability)
                    orange_icon.contextEntityIndex =  ability
                orange_icon.abilityname = skill_name

               // orange_icon.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + mini_icon + '.png")';
               // orange_icon.style.backgroundSize = "contain";
              //  orange_icon.style.backgroundRepeat = "no-repeat";

                icon_buffer = 'olevel_0'
                if (pick_stage == true)
                    lvl = 1

                if (lvl !== undefined) 
                {
                    icon_buffer = 'orange_lvl_1'
                    orange_icon.style.washColor = "none";
                    orange_icon.style.saturation = "1";
                    orange_content.AddClass("orange_content_anim");
                }else
                {
                    orange_icon.style.washColor = "#666666";
                    orange_icon.style.saturation = "0.1";
                }

                orange_lvl.style.backgroundImage = 'url("file://{images}/custom_game/' + icon_buffer + '.png")';
                orange_lvl.style.backgroundSize = "100%";
                orange_lvl.style.backgroundRepeat = "no-repeat";

                MouseOverTalent(orange_content, '#upgrade_disc_' + name, name, lvl, false, "legendary", max_level, player_id, hero)

            }
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


            if (rarity == "purple") 
            {

                let purple_card = LayerPurple.FindChildTraverse("purple_card_" + String(purple_count))
                let purple_content = LayerPurple.FindChildTraverse("purple_content_" + String(purple_count))
                let purple_icon = LayerPurple.FindChildTraverse("purple_icon_" + String(purple_count))
                let purple_lvl = LayerPurple.FindChildTraverse("purple_lvl_" + String(purple_count))

                if (use_new_system && skill_panel)
                {
                    new_purple_count++

                    purple_content = skill_panel.FindChildTraverse("talent_purple_card_" + new_purple_count)
                    purple_icon = skill_panel.FindChildTraverse("talent_purple_icon_" + new_purple_count)
                    purple_lvl = skill_panel.FindChildTraverse("talent_purple_level_" + new_purple_count)
                }
        
                if (purple_content == undefined)
                    continue

                purple_count++

                purple_content.RemoveClass("card_content_purple_anim");

                purple_content.style.backgroundSize = "contain";

                purple_icon.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + mini_icon + '.png")';
                purple_icon.style.backgroundSize = "contain";
                purple_icon.style.backgroundRepeat = "no-repeat";

                icon_buffer = 'slevel_0'
                if (pick_stage == true)
                    lvl = max_level

                if (lvl !== undefined) 
                {
                    icon_buffer = 'epic_level_' + max_level + lvl

                    purple_icon.style.washColor = "none";
                    purple_icon.style.saturation = "1";

                    if (lvl == max_level) 
                    {
                        purple_content.AddClass("card_content_purple_anim");
                    }
                }else
                {
                    purple_icon.style.washColor = "#666666";
                    purple_icon.style.saturation = "0.1";
                }

                MouseOverTalent(purple_content, "#upgrade_disc_" + name, name, lvl, true, "purple", max_level, player_id, hero)

                purple_lvl.style.backgroundImage = 'url("file://{images}/custom_game/' + icon_buffer + '.png")';
                purple_lvl.style.backgroundSize = "100%";
                purple_lvl.style.backgroundRepeat = "no-repeat";
            }


            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

            if (rarity == "blue") 
            {
                let blue_card = LayerBlue.FindChildTraverse("blue_card_" + String(blue_count))
                let blue_content = LayerBlue.FindChildTraverse("blue_content_"+ String(blue_count))
                let blue_icon = LayerBlue.FindChildTraverse("blue_icon_" + String(blue_count))
                let blue_lvl = LayerBlue.FindChildTraverse("blue_lvl_" + String(blue_count))

                if (use_new_system && skill_panel)
                {
                    new_blue_count++

                    blue_content = skill_panel.FindChildTraverse("talent_blue_card_" + new_blue_count)
                    blue_icon = skill_panel.FindChildTraverse("talent_blue_icon_" + new_blue_count)
                    blue_lvl = skill_panel.FindChildTraverse("talent_blue_level_" + new_blue_count)
                }
        
                if (blue_content == undefined)
                    continue

                blue_count++

                blue_content.RemoveClass("card_content_blue_anim");

                blue_content.style.backgroundSize = "contain";

                blue_icon.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + mini_icon + '.png")';
                blue_icon.style.backgroundSize = "contain";
                blue_icon.style.backgroundRepeat = "no-repeat";

                icon_buffer = 'slevel_0'
                if (pick_stage == true)
                    lvl = max_level

                if (lvl !== undefined) 
                {
                    icon_buffer = 'blue_level_' + lvl

                    blue_icon.style.washColor = "none";
                    blue_icon.style.saturation = "1";

                    if (lvl == max_level) {
                        blue_content.AddClass("card_content_blue_anim");
                    }
                }else
                {    
                    blue_icon.style.washColor = "#666666";
                    blue_icon.style.saturation = "0.1";
                }

                MouseOverTalent(blue_content, "#upgrade_disc_" + name, name, lvl, true, "blue", max_level, player_id, hero)
                
                blue_lvl.style.backgroundImage = 'url("file://{images}/custom_game/' + icon_buffer + '.png")';
                blue_lvl.style.backgroundSize = "100%";
                blue_lvl.style.backgroundRepeat = "no-repeat";
            }
        }
    }




    if (pick_stage == true)
        return

    var LayerGray_skill = []
    for (var i = 1; i <= 4; i++)
    {
        let panel = $.GetContextPanel().FindChildTraverse("LayerGray_skill_" + i)
        if (panel) panel.DeleteAsync(0)
    
        let parent = LayerGray_Left
        if (i >= 3) parent = LayerGray_Right
        
        LayerGray_skill[i] = $.CreatePanel("Panel", parent, "LayerGray_skill_" + i)
        LayerGray_skill[i].AddClass("Gray_Skill")
    }


    var purple_amount = 0
    var blue_amount = 0
    var gray_amount = 0

    var gray_general_count = 0
    var purple_general_count = 0
    var blue_general_count = 0

    var number = 0
    var text = ''

    var gray_max = 6

    var general_gray_border = $.CreatePanel("Panel", LayerGray_skill[1], "general_gray_border")
    general_gray_border.AddClass("general_border")
    var general_gray_border = $.CreatePanel("Panel", LayerGray_skill[2], "general_gray_border")
    general_gray_border.AddClass("general_border")

    var general_gray_border = $.CreatePanel("Panel", LayerGray_skill[3], "general_gray_border")
    general_gray_border.AddClass("general_border")
    var general_gray_border = $.CreatePanel("Panel", LayerGray_skill[4], "general_gray_border")
    general_gray_border.AddClass("general_border")

    if (!player_table)
        return

    for (const name in Game.talents_values["general"])
    {
        let data = Game.talents_values["general"][name]
        let rarity = data["rarity"]

        if (player_table["upgrades"][name])
        {
            if (rarity == "purple")
                purple_amount = purple_amount + 1
            if (rarity == "blue")
                blue_amount = blue_amount + 1
            if (rarity == "gray")
                gray_amount = gray_amount + 1
        }
    }

    if (gray_amount > 12)
        gray_max = Math.ceil(gray_amount / 2)


    for (const name in Game.talents_values["general"]) 
    {
        let data = Game.talents_values["general"][name]
        let rarity = data["rarity"]
        let icon = data["skill_icon"]
        let max_level = Game.GetMaxLevel(data)

        let lvl = player_table.upgrades[name]
        if (lvl === undefined)
            continue

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (use_new_system == false)
        {
            if (rarity == "purple") 
            {
                purple_general_count = purple_general_count + 1

                let general_purple_card = $.CreatePanel("Panel", LayerGray_skill[4], "general_purple_card" + purple_general_count)
                general_purple_card.AddClass("general_card")

                let general_purple_shadow = $.CreatePanel("Panel", general_purple_card, "general_purple_shadow" + purple_general_count)
                general_purple_shadow.AddClass("general_shadow")

                let general_purple_image = $.CreatePanel("Panel", general_purple_shadow, "general_purple_image" + purple_general_count)
                general_purple_image.AddClass("general_image_purple")
                general_purple_image.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + icon + '.png")';
                general_purple_image.style.backgroundSize = "contain";
                general_purple_image.style.backgroundRepeat = "no-repeat";

                let general_purple_color = $.CreatePanel("Panel", general_purple_shadow, "general_purple_color" + purple_general_count)
                general_purple_color.AddClass("general_color")
                general_purple_color.style.washColor = "#a619ff";

                let general_purple_stack = $.CreatePanel("Label", general_purple_shadow, "general_purple_stack" + purple_general_count)
                general_purple_stack.AddClass("general_stack")

                MouseOverTalent(general_purple_card, "#upgrade_disc_" + name, name, lvl, true, "purple", max_level, player_id, hero)

                if (lvl > 1)
                    general_purple_stack.text = String(lvl)

                if (purple_amount > 6) 
                {
                    number = 0
                    number = (96 / purple_amount)

                    text = String(number) + '%'
                    general_purple_card.style.height = text

                    number = number * 5.1468
                    text = String(number) + '%'
                    general_purple_card.style.width = text

                    number = (100 - number) / 2
                    text = String(number) + '%'
                    general_purple_card.style.marginLeft = text
                    general_purple_stack.style.fontSize = '22px'
                }
            }

            if (rarity == "blue")
            {
                blue_general_count = blue_general_count + 1

                let general_blue_card = $.CreatePanel("Panel", LayerGray_skill[3], "general_blue_card" + blue_general_count)
                general_blue_card.AddClass("general_card")

                let general_blue_shadow = $.CreatePanel("Panel", general_blue_card, "general_blue_shadow" + blue_general_count)
                general_blue_shadow.AddClass("general_shadow")

                let general_blue_image = $.CreatePanel("Panel", general_blue_shadow, "general_blue_image" + blue_general_count)
                general_blue_image.AddClass("general_image_blue")
                general_blue_image.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + icon + '.png")';
                general_blue_image.style.backgroundSize = "contain";
                general_blue_image.style.backgroundRepeat = "no-repeat";

                let general_blue_color = $.CreatePanel("Panel", general_blue_shadow, "general_blue_color" + blue_general_count)
                general_blue_color.AddClass("general_color")
                general_blue_color.style.washColor = "#1a99e8";

                let general_blue_stack = $.CreatePanel("Label", general_blue_shadow, "general_blue_stack" + blue_general_count)
                general_blue_stack.AddClass("general_stack")

                MouseOverTalent(general_blue_card, "#upgrade_disc_" + name, name, lvl, true, "blue", max_level, player_id, hero)

                if (lvl > 1) {
                    general_blue_stack.text = String(lvl)
                }

                if (blue_amount > 6) 
                {
                    number = 0
                    number = (96 / blue_amount)

                    text = String(number) + '%'
                    general_blue_card.style.height = text

                    number = number * 5.1468
                    text = String(number) + '%'
                    general_blue_card.style.width = text

                    number = (100 - number) / 2
                    text = String(number) + '%'
                    general_blue_card.style.marginLeft = text

                    general_blue_stack.style.fontSize = '22px'
                }
            }

        }


        if (rarity == "gray")
        {
            let gray_bonus = data["general_bonus"]
            gray_general_count = gray_general_count + 1

            let parent = LayerGray_skill[2]

            if (gray_general_count <= gray_max) 
            {
                parent = LayerGray_skill[1]
            }

            let general_gray_card = $.CreatePanel("Panel", parent, "general_gray_card" + gray_general_count)
            general_gray_card.AddClass("general_card")

            var value = '+' + String(Math.trunc(lvl * gray_bonus * (1 + common_bonus))) + $.Localize('#talent_disc_' + name)
            MouseOver(general_gray_card, value)

            let general_gray_shadow = $.CreatePanel("Panel", general_gray_card, "general_gray_shadow" + gray_general_count)
            general_gray_shadow.AddClass("general_shadow")

            let general_gray_image = $.CreatePanel("Panel", general_gray_shadow, "general_gray_image" + gray_general_count)
            general_gray_image.AddClass("general_image_gray")
            general_gray_image.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + icon + '.png")';
            general_gray_image.style.backgroundSize = "contain";
            general_gray_image.style.backgroundRepeat = "no-repeat";

            let general_gray_color = $.CreatePanel("Panel", general_gray_shadow, "general_gray_color" + gray_general_count)
            general_gray_color.AddClass("general_color")
            general_gray_color.style.washColor = "#e9e9e9";

            let general_gray_stack = $.CreatePanel("Label", general_gray_shadow, "general_gray_stack" + gray_general_count)
            general_gray_stack.AddClass("general_stack")

            if (lvl > 9)
            {
                general_gray_stack.style.marginLeft = "0px"
                general_gray_stack.text = String(lvl)
            }
            else if (lvl > 1)
                general_gray_stack.text = String(lvl)

            if (gray_amount > 12) 
            {
                number = 0
                number = (96 / Math.ceil(gray_amount / 2))

                text = String(number) + '%'
                general_gray_card.style.height = text

                number = number * 5.1468
                text = String(number) + '%'
                general_gray_card.style.width = text

                number = (100 - number) / 2
                text = String(number) + '%'
                general_gray_card.style.marginLeft = text

                general_gray_stack.style.fontSize = '22px'
            }
        }
    }
}


function MouseOver(panel, text) {
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, text)
    });

    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });
}

function MouseOverTalent(panel, talent_text, name, lvl, all_levels, rarity, max_level, player_id, hero) 
{
    panel.SetPanelEvent("onmouseover", () => 
    {
        Game.CustomTooltipOpened = true

        $.DispatchEvent(
            "UIShowCustomLayoutParametersTooltip",
            panel,
            "skill_tooltip",
            "file://{resources}/layout/custom_game/custom_tooltip.xml",
            "talent_text=" + talent_text + "&name=" + name + "&lvl=" + lvl + "&all_levels=" + all_levels + "&rarity=" + rarity + "&max_level=" + max_level + "&player_id=" + player_id + "&hero_name=" + hero,
        );
    });
    panel.SetPanelEvent("onmouseout", () => 
    {
        Game.CustomTooltipOpened = false
        $.DispatchEvent("UIHideCustomLayoutTooltip", panel, "skill_tooltip");
    });

}
