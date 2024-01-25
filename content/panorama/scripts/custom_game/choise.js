var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);


function init() {
    GameEvents.Subscribe_custom('show_choise', OnShow)
    GameEvents.Subscribe_custom('end_choise', EndChoise)
}

init();

var global_choise = []


var active = false

function OnShow(kv) {
    var table = kv.choise

    var alert = kv.alert
    var hasup = kv.hasup
    var stack = kv.mods
    var can_refresh = kv.refresh
    var after_legen = kv.after_legen
    var perma_info = kv.perma_info


    //$.GetContextPanel().SetDisableFocusOnMouseDown(true )

    let card = []
    let card_body = []
    let text = []
    let icon = []
    let stacks = []
    let blur = []
    let font_size = ''
    let number = 0
    let close = null
    let close_text = null
    let refresh = null
    let refresh_text = null

    var parentHUDElements = $.GetContextPanel().GetParent().GetParent().FindChild("HUDElements");
    var ClosePanel = parentHUDElements.FindChildTraverse("ClosePanel");

    Game.EmitSound("UI.Choise_show")

    if (alert == 1) 
    {
        var alert_window = $.CreatePanel("Panel", $.GetContextPanel(), "alert_window")
        alert_window.AddClass("alert_window_show")

        $.Schedule(0.4, function() {
            alert_window.RemoveClass("alert_window_show")
            alert_window.AddClass("alert_window")
        })

        var alert_text = $.CreatePanel("Label", alert_window, "alert_text")
        alert_text.AddClass("alert_text")
        alert_text.html = true
        alert_text.text = $.Localize("#alert_text")
    }


    if (ClosePanel.BHasClass("ClosePanel")) 
    {
        ClosePanel.RemoveClass("ClosePanel")
        ClosePanel.AddClass("ClosePanelOpen")
    }

    ClosePanel.style.visibility = "visible"

    close = parentHUDElements.FindChildTraverse("close")

    close_text = close.FindChildTraverse("close_text")
    close_text.text = $.Localize('#choise_hide')


    if (can_refresh == 1) 
    {
        refresh = parentHUDElements.FindChildTraverse("refresh")
        refresh.style.visibility = "visible"
        refresh_text = refresh.FindChildTraverse("refresh_text")
        refresh_text.text = $.Localize('#refresh')

    }


    const h = Game.GetScreenHeight() / Game.GetScreenWidth()

    var main = parentHUDElements.FindChildTraverse("Cards")
    main.SetFocus()

	const hero = Entities.GetUnitName(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()))

    global_choise[1] = Game.FindUpgradeByName(hero, kv.choise[1])

    if (kv.choise[2] !== undefined)
    {
        global_choise[2] = Game.FindUpgradeByName(hero, kv.choise[2])
    }

    if (kv.choise[3] !== undefined)
    {
        global_choise[3] = Game.FindUpgradeByName(hero, kv.choise[3])
    }

    for (var j = 1; j <= 4; j++) 
    {
        card[j] = parentHUDElements.FindChildTraverse("card" + String(j))


        if (card[j] && card[j].style.opacity == "0") 
        {
            card[j].style.opacity = "1"
            card[j].style.visibility = "collapse"
        }

        stacks[j] = card[j].FindChildTraverse("stacks" + String(j))
        
        if (stacks[j] && card[j].style.opacity == "0")
        {
            stacks[j].style.opacity = "1"
            stacks[j].style.visibility = "collapse"
        }
    }


    active = true


	const max = Object.keys(table).length
	let i = 0
	for (const name of Object.values(table)) {
		const data = Game.FindUpgradeByName(hero, name)
		i++
        card[i] = parentHUDElements.FindChildTraverse("card" + String(i))

        card[i].RemoveClass("card_1_3")
        card[i].RemoveClass("card_3_3")
        card[i].RemoveClass("card_1_4")
        card[i].RemoveClass("card_4_4")
        card[i].RemoveClass("card_1_3_43")
        card[i].RemoveClass("card_3_3_43")
        card[i].RemoveClass("card_1_4_43")
        card[i].RemoveClass("card_4_4_43")

        if (h === 0.75) {
            if (max === 4) {
                if (i === 1) {
                    card[i].AddClass("card_1_4_43")
                } else {
                    card[i].AddClass("card_4_4_43")
                }
            } else {
                if (i === 1) {
                    card[i].AddClass("card_1_3_43")
                } else {
                    card[i].AddClass("card_3_3_43")
                }
            }
        } else {
            if (max === 4) {
                if (i === 1) {
                    card[i].AddClass("card_1_4")
                } else {
                    card[i].AddClass("card_4_4")
                }
            } else {
                if (i === 1) {
                    card[i].AddClass("card_1_3")
                } else {
                    card[i].AddClass("card_3_3")
                }
            }
        }


        if (card[i].BHasClass("card")) 
        {
            card[i].RemoveClass("card")
            card[i].AddClass("cardOpen")
        }
        if (card[i].BHasClass("card_chosen")) 
        {
            card[i].RemoveClass("card_chosen")
            card[i].AddClass("cardOpen")
        }

        card[i].style.visibility = "visible"
        card[i].style.opacity = "1"


        card_body[i] = card[i].FindChildTraverse("card_body_main_" + String(i))

        let info = $.GetContextPanel().FindChildTraverse("card_info_" + String(i))

        if ((max == 4) &&  (Game.UpgradeMatchesRarity(data, "orange")))
        {
            SetInfoActivate(i, name)


            info.style.opacity = "1"
        }else
        {
            info.style.opacity = "0"
        }


        text[i] = card[i].FindChildTraverse("text" + String(i))
        stacks[i] = card[i].FindChildTraverse("stacks" + String(i))


        icon[i] = card[i].FindChildTraverse("card_icon" + String(i))

        blur[i] = card[i].FindChildTraverse("blur" + String(i))




        card_body[i].style.backgroundImage = 'url("file://{images}/custom_game/' + data[5] + '.png")';
        card_body[i].style.backgroundSize = "contain";




        text[i].html = true
		if (Game.UpgradeMatchesRarity(data, "gray")) {
            number = data[8] * (1 + 0.3 * hasup)
            if (number !== Math.floor(number))
                number = (data[8] * (1 + 0.3 * hasup)).toFixed(1)
            text[i].text = "<b><font color=#53ea48>" + '+' + String(number) + "</font></b>" + $.Localize('#talent_disc_' + name)
        }

        if (Game.UpgradeMatchesRarity(data, "orange")) {
         text[i].text = Game.ShowTalentValues($.Localize("#upgrade_disc_" + name), name, stack[i] + 1, false, true)
        }


        if (Game.UpgradeMatchesRarity(data, "blue") || Game.UpgradeMatchesRarity(data, "purple"))
        {
            let talent_text = $.Localize("#upgrade_disc_" + name)


            if ((talent_text == "") || (talent_text == undefined) || (talent_text == "#upgrade_disc_" + name))
            {
                text[i].text = $.Localize("#upgrade_disc_" + name + '_' + (stack[i] + 1))
            
            }else
            {
                text[i].text = Game.ShowTalentValues(talent_text, name, stack[i] + 1, false, false)
            }
        }

        font_size = $.Localize("#font_disc_" + name) + "px"
        text[i].style.fontSize = font_size

        if ((max == 4) &&  (Game.UpgradeMatchesRarity(data, "orange")))
        {
            text[i].text = $.Localize("#" + hero + '_legendary_' + String(i))
            text[i].style.fontSize = '20px'
        }


        if (perma_info && perma_info[i] && perma_info[i].stack !== -1)
        {

            stacks[i].style.visibility = "visible"
            stacks[i].html = true
            stacks[i].AddClass("text_stacks_perma")
            stacks[i].style.color = '#d7d7d7'

            let stack_text = String(perma_info[i].stack)

            if (perma_info[i].stack !== 0)
            {
                stack_text = "<b><font color='#53ea48'>" + String(perma_info[i].stack) + "</font></b>"
            }


            if (perma_info[i].max !== -1)
            {
                stacks[i].text = $.Localize('#perma_progress') + stack_text + "/" + String(perma_info[i].max)
            }else 
            {
                stacks[i].text = $.Localize('#perma_progress') + stack_text
            }
        } else 
        {
            if (data[4] !== 0) 
            {

                stacks[i].RemoveClass("text_stacks_perma")

                stacks[i].style.visibility = "visible"
                stacks[i].html = true
                stacks[i].text = $.Localize(stack[i] + "/" + data[4])
    			if (Game.UpgradeMatchesRarity(data, "blue")) {
                    stacks[i].style.color = '#a5cdff'
                } else {
                    stacks[i].style.color = '#9c67e2'
                }

            }
        }

        stacks[i].style.opacity = "1"



        blur[i].style.backgroundRepeat = "no-repeat";
        blur[i].style.backgroundImage = 'url("file://{images}/custom_game/' + data[3] + '.png")';
        blur[i].style.backgroundSize = "contain";


        if (icon[i].BHasClass("card_icon")) {
            icon[i].RemoveClass("card_icon")
        }
        if (icon[i].BHasClass("card_icon_skill")) {
            icon[i].RemoveClass("card_icon_skill")
        }


        if (data[5].endsWith("_item")) {
            icon[i].AddClass("card_icon")
            icon[i].style.backgroundImage = 'url("file://{images}/custom_game/icons/items/' + data[6] + '.png")';

        } else {
            icon[i].AddClass("card_icon_skill")
            icon[i].style.backgroundImage = 'url("file://{images}/custom_game/icons/skills/' + data[6] + '.png")';
        }
        icon[i].style.backgroundSize = "contain";


    }

    $.Schedule(0.8, function() {

        for (var i = 1; i <= max; i++) {

            SetChoise(i, max)
        }

        close.SetPanelEvent("onactivate", function() {
            hide_cards(max, can_refresh)
        })

        if (can_refresh == 1) {
            refresh.SetPanelEvent("onactivate", function() {
                refresh_choise(card, max, after_legen)
            })
        }

    })

}




function hide_cards(max, can_refresh) {

    Game.EmitSound("UI.Choise_hide")

    var parentHUDElements = $.GetContextPanel().GetParent().GetParent().FindChild("HUDElements");
    var text = parentHUDElements.FindChildTraverse("close_text")
    var card = parentHUDElements.FindChildTraverse("card1")
    var refresh = parentHUDElements.FindChildTraverse("refresh")
    var flag = false

    if (card.style.visibility == "visible") {
        flag = false
        text.text = $.Localize('#choise_show')

        if (can_refresh == 1) {
            refresh.style.visibility = "collapse"
        }

    } else {
        flag = true
        text.text = $.Localize('#choise_hide')

        if (can_refresh == 1) {
            refresh.style.visibility = "visible"
        }

    }

    var card_array = []

    for (var i = 1; i <= max; i++) {
        card_array[i] = parentHUDElements.FindChildTraverse("card" + String(i))
        if (flag == false) {
            card_array[i].style.visibility = "collapse"
        } else {
            card_array[i].style.visibility = "visible"
        }

    }


}




function SetChoise(i, max) {


    let card_body = $.GetContextPanel().FindChildTraverse("card_body_main_" + String(i))

    card_body.SetFocus()

    card_body.SetPanelEvent("onactivate", function() {
        select_card(card_body, i, max)
    })
}

function SetInfoActivate(i, name)
{
    let info = $.GetContextPanel().FindChildTraverse("card_info_" + String(i))
    let text = $.GetContextPanel().FindChildTraverse("text" + String(i))
  //  info.SetPanelEvent('onmouseover', function() {
 //       info.AddClass("card_info_hover")
  //  })

   // info.SetPanelEvent('onmouseout', function() {
  //      info.RemoveClass("card_info_hover")
    //})

    info.SetPanelEvent("onactivate", function() {
        info.style.opacity = "0"
        Game.EmitSound("UI.Click")

        text.text = GetLegendaryText(name)

        font_size = $.Localize("#font_disc_" + name) + "px"
        text.style.fontSize = font_size

        info.SetPanelEvent("onactivate", function() {})
    })

}

function GetLegendaryText(name) {

    return Game.ShowTalentValues($.Localize("#upgrade_disc_" + name), name, 0, false, true)
}


function DeleteChoise(card) {
    card.SetPanelEvent("onactivate", function() {})
}

function test_text()
{
}


function select_card(card, name, max) {
    hide_all(max, name)

}



function refresh_choise(card, max, after_legen) {


    for (var i = 1; i <= max; i++) {
        DeleteChoise(card[i])
    }

    hide_all(max, 0)


    $.Schedule(0.6, function() {
        GameEvents.SendCustomGameEventToServer_custom("refresh_sphere", {global_choise, after_legen})
    })

}


function EndChoise(kv) 
{
    hide_all(kv.max, kv.number)
}


function hide_all(max, chosen) {
    Game.EmitSound("UI.Talent_chose")


    GameEvents.SendCustomGameEventToServer_custom("end_choise_js", {})


    var parentHUDElements = $.GetContextPanel().GetParent().GetParent().FindChild("HUDElements");
    var ClosePanel = parentHUDElements.FindChildTraverse("ClosePanel");
    var close = parentHUDElements.FindChildTraverse("close")


    var alert_window = $.GetContextPanel().FindChildTraverse("alert_window")
    if (alert_window) 
    {
        alert_window.AddClass("alert_window_hide")
        $.Schedule(0.4, function() 
        {
            alert_window.DeleteAsync(0)
        })
    }

    if (ClosePanel.BHasClass("ClosePanelOpen")) 
    {
        ClosePanel.RemoveClass("ClosePanelOpen")
        ClosePanel.AddClass("ClosePanel")
    }

    var refresh = parentHUDElements.FindChildTraverse("refresh")

    refresh.style.visibility = "collapse"
    DeleteChoise(refresh)
    DeleteChoise(close)


    var card = []
    var stacks = []
    var card_body = []

    for (var i = 1; i <= max; i++) 
    {
        card[i] = parentHUDElements.FindChildTraverse("card" + String(i))
        card_body[i] = card[i].FindChildTraverse("card_body_main_" + String(i))

        if (card_body[i])
        {
            DeleteChoise(card_body[i])
        }

        if (card[i])
        {

            if (card[i].BHasClass("cardOpen"))
            {
                card[i].RemoveClass("cardOpen")
                if (chosen == i) {
                    card[i].AddClass("card_chosen")
                } else {
                    card[i].AddClass("card")
                }
            }

            card[i].style.visibility = "visible"
        }
    }



    active = false

    $.Schedule(0.4, function() 
    {  
        if (active == false)
        {


            ClosePanel.style.visibility = "collapse"
            for (var i = 1; i <= max; i++) 
            {
                if (i != chosen) {
                    card[i] = parentHUDElements.FindChildTraverse("card" + String(i))

                    if (card[i])
                    {
                        card[i].style.opacity = "0"
                    }
                    stacks[i] = card[i].FindChildTraverse("stacks" + String(i))
                    
                    if (stacks[i])
                    {
                        stacks[i].style.opacity = "0"
                    }
                }

            }
        }
    })



    if (chosen != 0) 
    {
        var player = Players.GetLocalPlayer()
        GameEvents.SendCustomGameEventToServer_custom("activate_choise", {
            chosen
        })

        $.Schedule(0.55, function() 
        {

            if (active == false)
            {

                for (var i = 1; i <= max; i++) 
                {
                    card[i] = parentHUDElements.FindChildTraverse("card" + String(i))
                    if (card[i]) 
                    {
                        card[i].style.opacity = "1"
                        card[i].style.visibility = "collapse"
                    }
                
                    stacks[i] = card[i].FindChildTraverse("stacks" + String(i))
                    
                    if (stacks[i])
                    {
                        stacks[i].style.opacity = "1"
                        stacks[i].style.visibility = "collapse"
                    }
                }
            }
        })
    }
}


function test_print() {

}