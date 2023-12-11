Game.isopened = false
Game.cd = false


function Upgrades_Click(hero) {

    hero = String(hero)

    var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
    if (!parentHUDElements) {
        parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().FindChild("HUDElements");
    }




    var LayerGeneral = parentHUDElements.FindChildTraverse("LayerGeneral");
    var Button = parentHUDElements.FindChildTraverse("Upgrades_Button");
    var Blur = parentHUDElements.FindChildTraverse("Upgrades_Blur");

    if (!LayerGeneral.init) {
        LayerGeneral.init = true
        $.RegisterEventHandler("InputFocusLost", LayerGeneral, function() {
            if ((Game.isopened === true) && (Game.cd === false))

            {
                Game.EmitSound("UI.Talent_hide")
                Upgrades_Click()
            }

        });
    }

    if (Game.cd == false) {
        Game.cd = true
        if (Game.isopened === false) {

            Game.isopened = true
            Game.EmitSound("UI.Talent_show")

            if (LayerGeneral.BHasClass("LayerGeneralClose")) {
                LayerGeneral.RemoveClass("LayerGeneralClose");
                LayerGeneral.AddClass("LayerGeneralOpen");
            }

            if (Button.BHasClass("ButtonClose")) {
                Button.RemoveClass("ButtonClose");
                Button.AddClass("ButtonOpen");
            }

            LayerGeneral.style.visibility = "visible";

            $.Schedule(0.4, function() {
                Game.cd = false
                LayerGeneral.SetAcceptsFocus(true)
                LayerGeneral.SetFocus()
            })

            init_space(hero)
        } else {
            Game.EmitSound("UI.Talent_hide")
            Game.isopened = false
            LayerGeneral.SetAcceptsFocus(false)

            if (Button.BHasClass("ButtonOpen")) {
                Button.RemoveClass("ButtonOpen");
                Button.AddClass("ButtonClose");
            }

            if (LayerGeneral.BHasClass("LayerGeneralOpen")) {
                LayerGeneral.RemoveClass("LayerGeneralOpen");
                LayerGeneral.AddClass("LayerGeneralClose");
            }

            $.Schedule(0.4, function() {
                LayerGeneral.style.visibility = "collapse";
                delete_space(hero)

                Game.cd = false
            })

        }
    }
}


Game.Upgrades = Upgrades_Click


function MouseOver(panel, text) {
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, text)
    });

    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });

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



function init_space(hero_alt) 
{

    if (hero_alt != "undefined") {
        var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
    } else {
        var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().FindChild("HUDElements");
    }




    var LayerGeneral = parentHUDElements.FindChildTraverse("LayerGeneral");
    LayerGeneral.style.backgroundSize = "contain";

    var LayerGray_Left = LayerGeneral.FindChildTraverse("LayerGray_left")

    var LayerPlayer_Skills = LayerGeneral.FindChildTraverse("LayerPlayer_Skills")

    var LayerGray_Right = LayerGeneral.FindChildTraverse("LayerGray_Right")

    var LayerOrange = LayerGeneral.FindChildTraverse("LayerOrange")

    var LayerPurple = LayerGeneral.FindChildTraverse("LayerPurple")

    var LayerBlue = LayerGeneral.FindChildTraverse("LayerBlue")

    var LayerPurple_skill = []
    var LayerBlue_skill = []

    for (var i = 0; i <= 4; i++)
    {
        LayerPurple_skill[i] = LayerGeneral.FindChildTraverse("LayerPurple_skill_" + String(i))
        LayerBlue_skill[i] = LayerGeneral.FindChildTraverse("LayerBlue_skill_" + String(i))

    }


    hero_alt = String(hero_alt)

    if (hero_alt == "undefined") {
        var hero_ent = Players.GetLocalPlayerPortraitUnit();
        var hero = Entities.GetUnitName(hero_ent)
    } else {
        var hero = hero_alt
    }


    var player_table = CustomNetTables.GetTableValue("upgrades_player", hero)

    var orange_card = []
    var orange_content = []
    var orange_icon = []
    var orange_lvl = []

    var blue_card = []
    var blue_content = []
    var blue_icon = []
    var blue_lvl = []

    var purple_card = []
    var purple_content = []
    var purple_icon = []
    var purple_lvl = []
    var c = 1
    var p = 1
    var b = 1
    var s = ''

	for (const data of Object.values(Game.upgrades_data[hero])) {
		const name = data[1]
		let lvl
		
        if (player_table !== undefined)
			lvl = player_table.upgrades[name]

		if (Game.UpgradeMatchesRarity(data, "orange")) 
        {
            orange_card[c] = LayerOrange.FindChildTraverse("orange_card_" + String(c))


            MouseOverTalent(orange_card[c], $.Localize('#upgrade_disc_' + name), name, lvl, false, true)

            orange_content[c] = orange_card[c].FindChildTraverse("orange_content_" + String(c))
            orange_icon[c] = orange_card[c].FindChildTraverse("orange_icon_" + String(c))

            orange_content[c].RemoveClass("orange_content_anim");
            orange_content[c].AddClass("orange_content");

            orange_icon[c].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + data[6] + '.png")';
            orange_icon[c].style.backgroundSize = "contain";
            orange_icon[c].style.backgroundRepeat = "no-repeat";
            orange_icon[c].style.washColor = "#666666";
            orange_icon[c].style.saturation = "0.1";


            orange_lvl[c] = orange_card[c].FindChildTraverse("orange_lvl_" + String(c))

            s = 'olevel_0'

            if (lvl !== undefined) {
				s = 'orange_lvl_1'
				orange_icon[c].style.washColor = "none";
				orange_icon[c].style.saturation = "1";
				orange_content[c].RemoveClass("orange_content");
				orange_content[c].AddClass("orange_content_anim");

			}

            orange_lvl[c].style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
            orange_lvl[c].style.backgroundSize = "100%";
            orange_lvl[c].style.backgroundRepeat = "no-repeat";

            c++

        }
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


		if (Game.UpgradeMatchesRarity(data, "purple")) {

            purple_card[p] = LayerPurple.FindChildTraverse("purple_card_" + String(p))

            purple_content[p] = LayerPurple.FindChildTraverse("purple_content_" + String(p))
            purple_content[p].RemoveClass("card_content_purple_anim");
            purple_content[p].AddClass("card_content_purple");

            purple_content[p].style.backgroundSize = "contain";
            //purple_content[p].style.backgroundImage = 'url("file://{images}/custom_game/talent.png")';


            purple_icon[p] = LayerPurple.FindChildTraverse("purple_icon_" + String(p))

            purple_icon[p].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + data[9] + '.png")';
            purple_icon[p].style.backgroundSize = "contain";
            purple_icon[p].style.backgroundRepeat = "no-repeat";
            purple_icon[p].style.washColor = "#666666";
            purple_icon[p].style.saturation = "0.1";

            s = 'slevel_0'

            if (lvl !== undefined) {
				s = 'epic_level_' + data[4] + lvl

				purple_icon[p].style.washColor = "none";
				purple_icon[p].style.saturation = "1";


				if (lvl == data[4]) 
                {
                    purple_content[p].RemoveClass("card_content_purple");
					purple_content[p].AddClass("card_content_purple_anim");
				}
			}

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

                MouseOver(purple_card[p], final_text )
            }else 
            {
                MouseOverTalent(purple_card[p], talent_text, name, lvl, true)
            }



            purple_lvl[p] = LayerPurple.FindChildTraverse("purple_lvl_" + String(p))

            purple_lvl[p].style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
            purple_lvl[p].style.backgroundSize = "100%";
            purple_lvl[p].style.backgroundRepeat = "no-repeat";

            p++

        }


        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		if (Game.UpgradeMatchesRarity(data, "blue")) {

            blue_card[b] = LayerBlue.FindChildTraverse("blue_card_" + String(b))

            blue_content[b] = LayerBlue.FindChildTraverse("blue_content_"+ String(b))

            blue_content[b].RemoveClass("card_content_blue_anim");
            blue_content[b].AddClass("card_content_blue");

            blue_content[b].style.backgroundSize = "contain";


            blue_icon[b] = LayerBlue.FindChildTraverse("blue_icon_" + String(b))

            blue_icon[b].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + data[9] + '.png")';
            blue_icon[b].style.backgroundSize = "contain";
            blue_icon[b].style.backgroundRepeat = "no-repeat";
            blue_icon[b].style.washColor = "#666666";
            blue_icon[b].style.saturation = "0.1";

            s = 'slevel_0'

            if (lvl !== undefined) {
				s = 'blue_level_' + lvl

				blue_icon[b].style.washColor = "none";
				blue_icon[b].style.saturation = "1";

				if (lvl == data[4]) {
					blue_content[b].RemoveClass("card_content_blue");
					blue_content[b].AddClass("card_content_blue_anim");
				}
			}

            let talent_text = $.Localize('#upgrade_disc_' + name)
            var final_text = ""

            if (talent_text == "#upgrade_disc_" + name)
            {
                if (data[4] > 1) {
                    let fake_lvl = lvl !== undefined ? lvl : 0
                    final_text = $.Localize('#talent_disc_' + name + '_' + fake_lvl)
                } else {
                    final_text = $.Localize('#upgrade_disc_' + name)
                }
                MouseOver(blue_card[b], final_text)
            }else 
            {
                MouseOverTalent(blue_card[b], talent_text, name, lvl, true)
            }



            blue_lvl[b] = LayerBlue.FindChildTraverse("blue_lvl_" + String(b))

            blue_lvl[b].style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
            blue_lvl[b].style.backgroundSize = "100%";
            blue_lvl[b].style.backgroundRepeat = "no-repeat";

            b++

        }


    }

    var LayerGray_skill = []
    LayerGray_skill[1] = $.CreatePanel("Panel", LayerGray_Left, "LayerGray_skill_1")
    LayerGray_skill[1].AddClass("Gray_Skill")
    LayerGray_skill[2] = $.CreatePanel("Panel", LayerGray_Left, "LayerGray_skill_2")
    LayerGray_skill[2].AddClass("Gray_Skill")
    LayerGray_skill[3] = $.CreatePanel("Panel", LayerGray_Right, "LayerGray_skill_3")
    LayerGray_skill[3].AddClass("Gray_Skill")
    LayerGray_skill[4] = $.CreatePanel("Panel", LayerGray_Right, "LayerGray_skill_4")
    LayerGray_skill[4].AddClass("Gray_Skill")


    var general_purple_card = []
    var general_purple_color = []
    var general_purple_shadow = []
    var general_purple_image = []
    var general_purple_stack = []

    var general_blue_card = []
    var general_blue_color = []
    var general_blue_shadow = []
    var general_blue_image = []
    var general_blue_stack = []

    var general_gray_card = []
    var general_gray_color = []
    var general_gray_shadow = []
    var general_gray_image = []
    var general_gray_stack = []

    var gp = 0
    var gb = 0
    var gg = 0
    var gray_count = 0
    var purple_count = 0
    var blue_count = 0

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


    if (player_table) {
		for (const data of Object.values(Game.upgrades_data.all))
			if (player_table.upgrades[data[1]] !== undefined) {
				if (Game.UpgradeMatchesRarity(data, "purple"))
					gp = gp + 1
				if (Game.UpgradeMatchesRarity(data, "blue"))
					gb = gb + 1
				if (Game.UpgradeMatchesRarity(data, "gray"))
					gg = gg + 1
			}

		if (gg > 12)
			gray_max = Math.ceil(gg / 2)


		for (const data of Object.values(Game.upgrades_data.all)) {
			const name = data[1]
			const lvl = player_table.upgrades[name]
			if (lvl === undefined)
				continue

            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


			if (Game.UpgradeMatchesRarity(data, "purple")) {

                purple_count = purple_count + 1

                general_purple_card[purple_count] = $.CreatePanel("Panel", LayerGray_skill[4], "general_purple_card" + purple_count)

                general_purple_card[purple_count].AddClass("general_card")

                MouseOver(general_purple_card[purple_count], $.Localize('#upgrade_disc_' + name) + '_1')


                general_purple_shadow[purple_count] = $.CreatePanel("Panel", general_purple_card[purple_count], "general_purple_shadow" + purple_count)
                general_purple_shadow[purple_count].AddClass("general_shadow")

                general_purple_image[purple_count] = $.CreatePanel("Panel", general_purple_shadow[purple_count], "general_purple_image" + purple_count)
                general_purple_image[purple_count].AddClass("general_image_purple")
                general_purple_image[purple_count].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + data[6] + '.png")';

                general_purple_image[purple_count].style.backgroundSize = "contain";
                general_purple_image[purple_count].style.backgroundRepeat = "no-repeat";


                general_purple_color[purple_count] = $.CreatePanel("Panel", general_purple_shadow[purple_count], "general_purple_color" + purple_count)

                general_purple_color[purple_count].AddClass("general_color")
                general_purple_color[purple_count].style.washColor = "#a619ff";


                general_purple_stack[purple_count] = $.CreatePanel("Label", general_purple_shadow[purple_count], "general_purple_stack" + purple_count)

                general_purple_stack[purple_count].AddClass("general_stack")

                if (lvl > 1)
                    general_purple_stack[purple_count].text = String(lvl)

                if (gp > 6) {
                    number = 0
                    number = (96 / gp)

                    text = String(number) + '%'
                    general_purple_card[purple_count].style.height = text

                    number = number * 5.1468
                    text = String(number) + '%'
                    general_purple_card[purple_count].style.width = text

                    number = (100 - number) / 2
                    text = String(number) + '%'
                    general_purple_card[purple_count].style.marginLeft = text

                    general_purple_stack[purple_count].style.fontSize = '22px'
                }

            }


            if (Game.UpgradeMatchesRarity(data, "blue")) {

                blue_count = blue_count + 1

                general_blue_card[blue_count] = $.CreatePanel("Panel", LayerGray_skill[3], "general_blue_card" + blue_count)

                general_blue_card[blue_count].AddClass("general_card")

                MouseOver(general_blue_card[blue_count], $.Localize('#upgrade_disc_' + name + '_' + lvl))


                general_blue_shadow[blue_count] = $.CreatePanel("Panel", general_blue_card[blue_count], "general_blue_shadow" + blue_count)
                general_blue_shadow[blue_count].AddClass("general_shadow")

                general_blue_image[blue_count] = $.CreatePanel("Panel", general_blue_shadow[blue_count], "general_blue_image" + blue_count)
                general_blue_image[blue_count].AddClass("general_image_blue")
                general_blue_image[blue_count].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + data[6] + '.png")';

                general_blue_image[blue_count].style.backgroundSize = "contain";
                general_blue_image[blue_count].style.backgroundRepeat = "no-repeat";


                general_blue_color[blue_count] = $.CreatePanel("Panel", general_blue_shadow[blue_count], "general_blue_color" + blue_count)

                general_blue_color[blue_count].AddClass("general_color")
                general_blue_color[blue_count].style.washColor = "#1a99e8";


                general_blue_stack[blue_count] = $.CreatePanel("Label", general_blue_shadow[blue_count], "general_blue_stack" + blue_count)

                general_blue_stack[blue_count].AddClass("general_stack")

                if (lvl > 1) {
                    general_blue_stack[blue_count].text = String(lvl)
                }

                if (gb > 6) {
                    number = 0
                    number = (96 / gb)

                    text = String(number) + '%'
                    general_blue_card[blue_count].style.height = text

                    number = number * 5.1468
                    text = String(number) + '%'
                    general_blue_card[blue_count].style.width = text

                    number = (100 - number) / 2
                    text = String(number) + '%'
                    general_blue_card[blue_count].style.marginLeft = text

                    general_blue_stack[blue_count].style.fontSize = '22px'


                }



            }


            if (Game.UpgradeMatchesRarity(data, "gray")) {

                gray_count = gray_count + 1

                if (gray_count <= gray_max) {
                    general_gray_card[gray_count] = $.CreatePanel("Panel", LayerGray_skill[1], "general_gray_card" + gray_count)
                } else {
                    general_gray_card[gray_count] = $.CreatePanel("Panel", LayerGray_skill[2], "general_gray_card" + gray_count)
                }

                general_gray_card[gray_count].AddClass("general_card")


                var t = '+' + String(Math.trunc(lvl * data[8] * (1 + 0.3 * player_table.hasup))) + $.Localize('#talent_disc_' + name)

                MouseOver(general_gray_card[gray_count], t)

                general_gray_shadow[gray_count] = $.CreatePanel("Panel", general_gray_card[gray_count], "general_gray_shadow" + gray_count)
                general_gray_shadow[gray_count].AddClass("general_shadow")

                general_gray_image[gray_count] = $.CreatePanel("Panel", general_gray_shadow[gray_count], "general_gray_image" + gray_count)
                general_gray_image[gray_count].AddClass("general_image_gray")
                general_gray_image[gray_count].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + data[6] + '.png")';

                general_gray_image[gray_count].style.backgroundSize = "contain";
                general_gray_image[gray_count].style.backgroundRepeat = "no-repeat";


                general_gray_color[gray_count] = $.CreatePanel("Panel", general_gray_shadow[gray_count], "general_gray_color" + gray_count)

                general_gray_color[gray_count].AddClass("general_color")
                general_gray_color[gray_count].style.washColor = "#e9e9e9";

                general_gray_stack[gray_count] = $.CreatePanel("Label", general_gray_shadow[gray_count], "general_gray_stack" + gray_count)

                general_gray_stack[gray_count].AddClass("general_stack")

                if (lvl > 9)
                {
                    general_gray_stack[gray_count].style.marginLeft = "0px"
                    general_gray_stack[gray_count].text = String(lvl)
                }
                else if (lvl > 1)
                    general_gray_stack[gray_count].text = String(lvl)


                if (gg > 12) {
                    number = 0
                    number = (96 / Math.ceil(gg / 2))

                    text = String(number) + '%'
                    general_gray_card[gray_count].style.height = text

                    number = number * 5.1468
                    text = String(number) + '%'
                    general_gray_card[gray_count].style.width = text

                    number = (100 - number) / 2
                    text = String(number) + '%'
                    general_gray_card[gray_count].style.marginLeft = text

                    general_gray_stack[gray_count].style.fontSize = '22px'


                }

            }


        }
    }




}


function delete_space(hero) {

    var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
    if (!parentHUDElements) {
        parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().GetParent().FindChild("HUDElements");
    }


    var LayerGeneral = parentHUDElements.FindChildTraverse("LayerGeneral");

    for (var i = 1; i <= 4; i++)
    {
        let gray_panel = LayerGeneral.FindChildTraverse("LayerGray_skill_" + String(i))

        if (gray_panel)
        {
            gray_panel.DeleteAsync(0)
        }

    }


// LayerGeneral.RemoveAndDeleteChildren();


}