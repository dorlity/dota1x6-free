var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
var center_block = parentHUDElements.FindChildTraverse("center_with_stats")
var center_block_top = parentHUDElements.FindChildTraverse("center_block")

var buffs =  parentHUDElements.FindChildTraverse("buffs")
var debuffs = parentHUDElements.FindChildTraverse("debuffs")
CreateAllButtons()


var obs_bind = DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP5
var sentry_bind = DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP6
var dust_bind = DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP7


var table_keybinds = CustomNetTables.GetTableValue("keybinds", String(Players.GetLocalPlayer()))

var default_button_for_dust
var default_button_for_observer
var default_button_for_sentry

function CreateAllButtons() {

	buffs.style.marginBottom = "176px"
	debuffs.style.marginBottom = "176px"

	for (var i = 0; i < center_block.GetChildCount(); i++) {
		if (center_block.GetChild(i).id == "AllCustomButtons") {
			center_block.GetChild(i).DeleteAsync(0)
		}
	}

	for (var i = 0; i < center_block_top.GetChildCount(); i++) {
		if (center_block_top.GetChild(i).id == "AllCustomButtonsTop") {
			center_block_top.GetChild(i).DeleteAsync(0)
		}
	}


	// Вся панель
	var AllCustomButtons = $.CreatePanel("Panel", center_block, "AllCustomButtons");
	AllCustomButtons.style.padding = "-1px"
	AllCustomButtons.style.width = "80px"
	AllCustomButtons.style.height = "127px"
	AllCustomButtons.style.align = "center bottom"
	AllCustomButtons.style.flowChildren = "right-wrap"
	AllCustomButtons.style.marginRight = "0px"
	AllCustomButtons.style.backgroundImage = 'url("file://{images}/custom_game/items_background.png")'
	AllCustomButtons.style.backgroundSize = "100%"
	AllCustomButtons.style.transform = "TranslateX(-46px)"


	// Вся панель
	var AllCustomButtonsTop = $.CreatePanel("Panel", center_block_top, "AllCustomButtonsTop");
	AllCustomButtonsTop.style.align = "right top"
	AllCustomButtonsTop.style.flowChildren = "right"
	AllCustomButtonsTop.style.marginTop = "52px"
	AllCustomButtonsTop.style.marginRight = "49px"




	// Панели с кнопками
	//var TpScrollButtonMain = $.CreatePanel("Panel", AllCustomButtons, "TpScrollButton");
	//TpScrollButtonMain.style.width = "60px"
	//TpScrollButtonMain.style.height = "35px"
	//TpScrollButtonMain.style.margin = "5px"

	var SmokeMain = $.CreatePanel("Panel", AllCustomButtonsTop, "SmokeButton");
	SmokeMain.style.width = "60px"
	SmokeMain.style.height = "35px"
	SmokeMain.style.margin = "5px"

	var ObserverWardMain = $.CreatePanel("Panel", AllCustomButtons, "ObserverWard");
	ObserverWardMain.style.width = "55px"
	ObserverWardMain.style.height = "50px"
	ObserverWardMain.style.marginTop = "16px"
	ObserverWardMain.style.marginLeft = "5px"

	var SentryWardMain = $.CreatePanel("Panel", AllCustomButtons, "SentryWard");
	SentryWardMain.style.width = "55px"
	SentryWardMain.style.height = "50px"
	SentryWardMain.style.marginTop = "2px"
	SentryWardMain.style.marginLeft = "5px"

	var DustMain = $.CreatePanel("Panel", AllCustomButtonsTop, "Dust");
	DustMain.style.width = "60px"
	DustMain.style.height = "35px"
	DustMain.style.margin = "5px"

	//var GrenadeMain = $.CreatePanel("Panel", AllCustomButtonsTop, "Grenade");
	//GrenadeMain.style.width = "60px"
	//GrenadeMain.style.height = "35px"
	//GrenadeMain.style.margin = "5px"
	//GrenadeMain.style.visibility = "collapse";

	var InfoButton = $.CreatePanel("Panel", AllCustomButtonsTop, "InfoButton");
	InfoButton.style.width = "30px"
	InfoButton.style.height = "30px"
	InfoButton.style.margin = "5px"
	InfoButton.style.backgroundImage = 'url("s2r://panorama/images/custom_game/info_png.vtex")'
	InfoButton.style.verticalAlign = "bottom"
	SetShowText(InfoButton, "info_custom_buttons")





	// Панель информации
	//var InfoButton = $.CreatePanel("Panel", AllCustomButtons, "InfoButton");
	//InfoButton.style.width = "30px"
	//InfoButton.style.height = "30px"
	//InfoButton.style.margin = "5px"
	//InfoButton.style.backgroundImage = 'url("s2r://panorama/images/custom_game/info_png.vtex")'
	//InfoButton.style.verticalAlign = "bottom"
	//SetShowText(InfoButton, "info_custom_buttons")



	SetObserver(ObserverWardMain)
	SetSentry(SentryWardMain)
	SetSmoke(SmokeMain)
	SetDust(DustMain)
	//SetGrenade(GrenadeMain)

	// Кнопка на которую юзается тп
	//var TpScrollButtonHotkey = $.CreatePanel("Panel", TpScrollButtonMain, "TpScrollButtonHotkey");
	//TpScrollButtonHotkey.style.backgroundColor = "#2127268a"
	//TpScrollButtonHotkey.style.boxShadow = "fill #000000bb 1px 0px 1px 1px"
	//TpScrollButtonHotkey.style.border = "1px solid black"
	//TpScrollButtonHotkey.style.borderRadius = "2px"
	//TpScrollButtonHotkey.style.zIndex = "1"
	//TpScrollButtonHotkey.style.height = "13px"
//
	//var TpScrollButtonHotkeyLabel = $.CreatePanel("Label", TpScrollButtonHotkey, "TpScrollButtonHotkeyLabel");
	//TpScrollButtonHotkeyLabel.text = String(GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYTP))
	//TpScrollButtonHotkeyLabel.style.fontSize = "10px"
	//TpScrollButtonHotkeyLabel.style.color = "white"

	// Кнопка на которую юзается обсервер
	var ObserverWardButtonHotkey = $.CreatePanel("Panel", ObserverWardMain, "ObserverWardButtonHotkey");
	ObserverWardButtonHotkey.style.backgroundColor = "#2127268a"
	ObserverWardButtonHotkey.style.boxShadow = "fill #000000bb 1px 0px 1px 1px"
	ObserverWardButtonHotkey.style.border = "1px solid black"
	ObserverWardButtonHotkey.style.borderRadius = "2px"
	ObserverWardButtonHotkey.style.zIndex = "1"
	ObserverWardButtonHotkey.style.height = "13px"

	var ObserverWardHotkeyLabel = $.CreatePanel("Label", ObserverWardButtonHotkey, "ObserverWardHotkeyLabel");
	ObserverWardHotkeyLabel.text = String(GetGameKeybind(obs_bind))
	ObserverWardHotkeyLabel.style.fontSize = "10px"
	ObserverWardHotkeyLabel.style.color = "white"


	// Кнопка на которую юзается сентри
	var SentryWardButtonHotkey = $.CreatePanel("Panel", SentryWardMain, "SentryWardButtonHotkey");
	SentryWardButtonHotkey.style.backgroundColor = "#2127268a"
	SentryWardButtonHotkey.style.boxShadow = "fill #000000bb 1px 0px 1px 1px"
	SentryWardButtonHotkey.style.border = "1px solid black"
	SentryWardButtonHotkey.style.borderRadius = "2px"
	SentryWardButtonHotkey.style.zIndex = "1"
	SentryWardButtonHotkey.style.height = "13px"

	var SentryWardHotkeyLabel = $.CreatePanel("Label", SentryWardButtonHotkey, "SentryWardHotkeyLabel");
	SentryWardHotkeyLabel.text = String(GetGameKeybind(sentry_bind))
	SentryWardHotkeyLabel.style.fontSize = "10px"
	SentryWardHotkeyLabel.style.color = "white"



	var SmokeButtonHotkey = $.CreatePanel("Panel", SmokeMain, "SmokeButtonHotkey");
	SmokeButtonHotkey.style.backgroundColor = "#2127268a"
	SmokeButtonHotkey.style.boxShadow = "fill #000000bb 1px 0px 1px 1px"
	SmokeButtonHotkey.style.border = "1px solid black"
	SmokeButtonHotkey.style.borderRadius = "2px"
	SmokeButtonHotkey.style.zIndex = "1"
	SmokeButtonHotkey.style.height = "13px"
	SmokeButtonHotkey.style.opacity = "0"

	var SmokeHotkeyLabel = $.CreatePanel("Label", SmokeButtonHotkey, "SmokeHotkeyLabel");
	SmokeHotkeyLabel.style.fontSize = "10px"
	SmokeHotkeyLabel.style.color = "white"
	SmokeHotkeyLabel.style.textShadow = "1px 1px 0px 2 #000000"
	SmokeHotkeyLabel.style.textAlign = "center"


	var DustButtonHotkey = $.CreatePanel("Panel", DustMain, "DustButtonHotkey");
	DustButtonHotkey.style.backgroundColor = "#2127268a"
	DustButtonHotkey.style.boxShadow = "fill #000000bb 1px 0px 1px 1px"
	DustButtonHotkey.style.border = "1px solid black"
	DustButtonHotkey.style.borderRadius = "2px"
	DustButtonHotkey.style.zIndex = "1"
	DustButtonHotkey.style.height = "13px"
	DustButtonHotkey.style.opacity = "1"

	var DustHotkeyLabel = $.CreatePanel("Label", DustButtonHotkey, "DustHotkeyLabel");
	DustHotkeyLabel.style.fontSize = "10px"
	DustHotkeyLabel.style.color = "white"
	DustHotkeyLabel.style.textShadow = "1px 1px 0px 2 #000000"
	DustHotkeyLabel.style.textAlign = "center"

	//var GrenadeButtonHotkey = $.CreatePanel("Panel", GrenadeMain, "GrenadeButtonHotkey");
	//GrenadeButtonHotkey.style.backgroundColor = "#2127268a"
	//GrenadeButtonHotkey.style.boxShadow = "fill #000000bb 1px 0px 1px 1px"
	//GrenadeButtonHotkey.style.border = "1px solid black"
	//GrenadeButtonHotkey.style.borderRadius = "2px"
	//GrenadeButtonHotkey.style.zIndex = "1"
	//GrenadeButtonHotkey.style.height = "13px"

	//var GrenadeHotkeyLabel = $.CreatePanel("Label", GrenadeButtonHotkey, "GrenadeHotkeyLabel");
	//GrenadeHotkeyLabel.text = String(GetGameKeybind(dust_bind))
	//GrenadeHotkeyLabel.style.fontSize = "10px"
	//GrenadeHotkeyLabel.style.color = "white"
	//GrenadeHotkeyLabel.style.textShadow = "1px 1px 0px 2 #000000"
	//GrenadeHotkeyLabel.style.textAlign = "center"

	var ObserverCooldownLabel = $.CreatePanel("Label", ObserverWardMain, "ObserverCooldownLabel");
	ObserverCooldownLabel.text = ""
	ObserverCooldownLabel.style.fontSize = "12px"
	ObserverCooldownLabel.style.color = "white"
	ObserverCooldownLabel.style.zIndex = "1"
	ObserverCooldownLabel.style.verticalAlign = "bottom"
	ObserverCooldownLabel.style.marginLeft = "13px"
	ObserverCooldownLabel.style.textShadow = "1px 1px 0px 2 #000000"


	var SentryCooldownLabel = $.CreatePanel("Label", SentryWardMain, "SentryCooldownLabel");
	SentryCooldownLabel.text = ""
	SentryCooldownLabel.style.fontSize = "12px"
	SentryCooldownLabel.style.color = "white"
	SentryCooldownLabel.style.zIndex = "1"
	SentryCooldownLabel.style.verticalAlign = "bottom"
	SentryCooldownLabel.style.marginLeft = "13px"
	SentryCooldownLabel.style.textShadow = "1px 1px 0px 2 #000000"



	var SmokeCooldownLabel = $.CreatePanel("Label", SmokeMain, "SmokeCooldownLabel");
	SmokeCooldownLabel.text = ""
	SmokeCooldownLabel.style.fontSize = "14px"
	SmokeCooldownLabel.style.color = "white"
	SmokeCooldownLabel.style.zIndex = "1"
	SmokeCooldownLabel.style.verticalAlign = "bottom"
	SmokeCooldownLabel.style.marginLeft = "1px"
	SmokeCooldownLabel.style.textShadow = "1px 1px 0px 2 #000000"

	// Доп стили к тексту кнопок
	//TpScrollButtonHotkeyLabel.style.textShadow = "1px 1px 0px 2 #000000"
	ObserverWardHotkeyLabel.style.textShadow = "1px 1px 0px 2 #000000"
	SentryWardHotkeyLabel.style.textShadow = "1px 1px 0px 2 #000000"
	//TpScrollButtonHotkeyLabel.style.textAlign = "center"
	ObserverWardHotkeyLabel.style.textAlign = "center"
	SentryWardHotkeyLabel.style.textAlign = "center"


	// Иконки кнопок
	//var TpScrollButton = $.CreatePanel("Panel", TpScrollButtonMain, "TpScrollButton");
	//TpScrollButton.style.width = "60px"
	//TpScrollButton.style.height = "30px"
	//TpScrollButton.style.backgroundImage = "url('s2r://panorama/images/conduct/ovw-bar-bg_png.vtex')"
	//TpScrollButton.style.verticalAlign = "bottom"

	var ObserverWard = $.CreatePanel("Panel", ObserverWardMain, "ObserverWardIcon");
	ObserverWard.style.width = "45px"
	ObserverWard.style.height = "45px"
	ObserverWard.style.borderRadius = "50%"
	ObserverWard.style.border = "1px solid #393939"
	ObserverWard.style.verticalAlign = "bottom"
	ObserverWard.style.boxShadow = "inset #000000cc 1px 1px 8px 6px"

	var SentryWard = $.CreatePanel("Panel", SentryWardMain, "SentryWardIcon");
	SentryWard.style.width = "45px"
	SentryWard.style.height = "45px"
	SentryWard.style.borderRadius = "50%"
	SentryWard.style.boxShadow = "inset #000000cc 1px 1px 8px 6px"
	SentryWard.style.border = "1px solid #393939"
	SentryWard.style.verticalAlign = "bottom"

	var SmokePanel = $.CreatePanel("Panel", SmokeMain, "SmokeIcon");
	SmokePanel.style.width = "60px"
	SmokePanel.style.height = "30px"
	SmokePanel.style.backgroundImage = "url('s2r://panorama/images/conduct/ovw-bar-bg_png.vtex')"
	SmokePanel.style.verticalAlign = "bottom"	

	var DustPanel = $.CreatePanel("Panel", DustMain, "DustIcon");
	DustPanel.style.width = "60px"
	DustPanel.style.height = "30px"
	DustPanel.style.backgroundImage = "url('s2r://panorama/images/conduct/ovw-bar-bg_png.vtex')"
	DustPanel.style.verticalAlign = "bottom"	

	//var GrenadePanel = $.CreatePanel("Panel", GrenadeMain, "GrenadeIcon");
	//GrenadePanel.style.width = "60px"
	//GrenadePanel.style.height = "30px"
	//GrenadePanel.style.backgroundImage = "url('s2r://panorama/images/conduct/ovw-bar-bg_png.vtex')"
	//GrenadePanel.style.verticalAlign = "bottom"	





















	$.CreatePanel("DOTAItemImage", ObserverWard, "ward_image", { style: "width:100%;height:100%;", itemname: "item_ward_observer" });
	$.CreatePanel("DOTAItemImage", SentryWard, "ward_image", { style: "width:100%;height:100%;", itemname: "item_ward_sentry" });
	$.CreatePanel("DOTAItemImage", SmokePanel, "smoke_image", { style: "width:100%;height:100%;", itemname: "item_smoke_of_deceit" });
	$.CreatePanel("DOTAItemImage", DustPanel, "dust_image", { style: "width:100%;height:100%;", itemname: "item_dust" });
	//$.CreatePanel("DOTAItemImage", GrenadePanel, "grenade_image", { style: "width:100%;height:100%;", itemname: "item_patrol_grenade" });

	var SentryWardCount = $.CreatePanel("Label", SentryWardMain, "SentryWardCount");
	var ObserverWardCount = $.CreatePanel("Label", ObserverWardMain, "ObserverWardCount");
	var SmokeCount = $.CreatePanel("Label", SmokeMain, "SmokeCount");
	var DustCount = $.CreatePanel("Label", DustMain, "DustCount");
	//var GrenadeCount = $.CreatePanel("Label", GrenadeMain, "GrenadeCount");

	SentryWardCount.style.color = "white"
	ObserverWardCount.style.color = "white"
	SentryWardCount.style.align = "center bottom"
	ObserverWardCount.style.align = "center bottom"
	SentryWardCount.style.textShadow = "0px 0px 3px 1 red"
	ObserverWardCount.style.textShadow = "0px 0px 3px 1 red"
	SmokeCount.style.color = "white"
	SmokeCount.style.align = "right bottom"
	SmokeCount.style.textShadow = "0px 0px 3px 1 red"
	DustCount.style.color = "white"
	DustCount.style.align = "right bottom"
	DustCount.style.textShadow = "0px 0px 3px 1 red"
	DustCount.text = "0"
	SentryWardCount.style.marginLeft = "28px"
	ObserverWardCount.style.marginLeft = "28px"

	//GrenadeCount.style.color = "white"
	//GrenadeCount.style.align = "right bottom"
	//GrenadeCount.style.textShadow = "0px 0px 3px 1 red"
	//GrenadeCount.text = "0"

	//let Cooldown_grenade = $.CreatePanel("Panel", GrenadePanel, "Cooldown_grenade");
	//Cooldown_grenade.style.width = "100%"
    //Cooldown_grenade.style.height = "100%"
    //Cooldown_grenade.style.align = "center center"
    //Cooldown_grenade.zIndex = "5"
    //Cooldown_grenade.hittest = false

    //let CooldownOverlay_grenade = $.CreatePanel("Panel", GrenadePanel, "CooldownOverlay_grenade");
	//CooldownOverlay_grenade.style.backgroundColor = "#000000dc"
	//CooldownOverlay_grenade.style.width = "100%"
	//CooldownOverlay_grenade.style.height = "100%"
	//CooldownOverlay_grenade.style.brightness = "1.2"
	//CooldownOverlay_grenade.zIndex = "5"
	//CooldownOverlay_grenade.hittest = false

    //let CooldownTimer_grenade = $.CreatePanel("Label", GrenadePanel, "CooldownTimer_grenade");
    //CooldownTimer_grenade.style.color = "white"
    //CooldownTimer_grenade.style.fontSize = "12px"
    //CooldownTimer_grenade.style.textShadow = "0px 0px 6px 6 #000000"
    //CooldownTimer_grenade.style.width = "100%"
    //CooldownTimer_grenade.style.textAlign = "center"
    //CooldownTimer_grenade.style.verticalAlign = "center"
    //CooldownTimer_grenade.style.textOverflow = "shrink"
    //CooldownTimer_grenade.zIndex = "5"
    //CooldownTimer_grenade.hittest = false


	$.Schedule( 1/144, ButtonsUpdate );
	$.Schedule( 1/144, WardParticlesUpdate );
}

function ButtonsUpdate() {
	var AllCustomButtons = center_block.FindChildTraverse("AllCustomButtons")
	var AllCustomButtonsTop = center_block_top.FindChildTraverse("AllCustomButtonsTop")
	var ObserverCooldownLabel = center_block.FindChildTraverse("ObserverCooldownLabel")
	var SentryCooldownLabel = center_block.FindChildTraverse("SentryCooldownLabel")
	var SmokeCooldownLabel = center_block_top.FindChildTraverse("SmokeCooldownLabel")
	//var Cooldown_grenade = center_block_top.FindChildTraverse("Cooldown_grenade") 
	//var CooldownOverlay_grenade = center_block_top.FindChildTraverse("CooldownOverlay_grenade")
	//var CooldownTimer_grenade = center_block_top.FindChildTraverse("CooldownTimer_grenade")

	if (Players.GetLocalPlayerPortraitUnit() != Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()) ) {
		AllCustomButtons.visible = false
	} else {
		AllCustomButtons.visible = true
	}

	if (Players.GetLocalPlayerPortraitUnit() != Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()) ) {
		AllCustomButtonsTop.visible = false
	} else {
		AllCustomButtonsTop.visible = true
	}

	center_block_top.style.paddingLeft = "0px"
	center_block_top.style.paddingRight = "0px"

	//var tpscroll_button = center_block.FindChildTraverse("TpScrollButton")
	var observer_button = center_block.FindChildTraverse("ObserverWard")
	var sentry_button = center_block.FindChildTraverse("SentryWard")

	//var tpscroll_button_label = center_block.FindChildTraverse("Cooldown_tpscroll")
	var observer_button_label = center_block.FindChildTraverse("ObserverWardCount")
	var sentry_button_label = center_block.FindChildTraverse("SentryWardCount")
	var smoke_button_label = center_block_top.FindChildTraverse("SmokeCount")
	var dust_button_label = center_block_top.FindChildTraverse("DustCount")
	//var grenade_button_label = center_block_top.FindChildTraverse("GrenadeCount")

	//var TpScrollButtonHotkeyLabel = center_block.FindChildTraverse("TpScrollButtonHotkeyLabel")
	var ObserverWardHotkeyLabel = center_block.FindChildTraverse("ObserverWardHotkeyLabel")
	var SentryWardHotkeyLabel = center_block.FindChildTraverse("SentryWardHotkeyLabel")
	var SmokeHotkeyLabel = center_block.FindChildTraverse("SmokeHotkeyLabel")
	var DustHotkeyLabel = center_block.FindChildTraverse("DustHotkeyLabel")
	var GrenadeHotkeyLabel = center_block.FindChildTraverse("GrenadeHotkeyLabel")

	//TpScrollButtonHotkeyLabel.text = String(GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORYTP))


    SentryWardHotkeyLabel.text = String(GetGameKeybind(sentry_bind)).toUpperCase()
    ObserverWardHotkeyLabel.text = String(GetGameKeybind(obs_bind)).toUpperCase()
    DustHotkeyLabel.text = String(GetGameKeybind(dust_bind)).toUpperCase()

	if (default_button_for_dust != GetGameKeybind(dust_bind) ) {
		RegisterKeybindDust()
	}

	if (default_button_for_observer != GetGameKeybind(obs_bind) ) {
		RegisterKeybindObserver()
	}

	if (default_button_for_sentry != GetGameKeybind(sentry_bind) ) {
		RegisterKeybindSentry()
	}

    let ability_id_2 = -1
    for (var i = 0; i < 45; i++) {
        ability_id_2 = Entities.GetAbility( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), i )
        if (ability_id_2 > -1) {
            var ability_name =  Abilities.GetAbilityName( ability_id_2 )
            if (ability_name == "custom_ability_observer" ) {
				observer_button_label.text = String(HowStacks("modifier_item_custom_observer_ward_charges"))
				var time = 0
				if (true)
				{
                    let modifier = FindModifier(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), "modifier_item_custom_observer_ward_charges")
                    if (modifier != "No")
                    {
                        let check_time = Number(Buffs.GetRemainingTime(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), modifier))
                        if (check_time > 0)
                        {
                            time = Math.ceil(check_time)
                        }
                    }
				}

				var min = Math.trunc((time)/60) 
				var sec_n =  (time) - 60*Math.trunc((time)/60) 

				var hour = String( Math.trunc((min)/60) )

				var min = String(min - 60*( Math.trunc(min/60) ))

				var sec = String(sec_n)
				if (sec_n < 10) 
				{
					sec = '0' + sec

				}

				ObserverCooldownLabel.text = min + ':' + sec
				if (time > 180) {
					ObserverCooldownLabel.visible = false
				} else {
					ObserverCooldownLabel.visible = true
				}
                break
            }
        }
    }

    let ability_sentry = -1
    for (var i = 0; i < 45; i++) {
        ability_sentry = Entities.GetAbility( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), i )
        if (ability_sentry > -1) {
            var ability_name =  Abilities.GetAbilityName( ability_sentry )
            if (ability_name == "custom_ability_sentry" ) {
				sentry_button_label.text = String(HowStacks("modifier_item_custom_sentry_ward_charges"))



				var time = 0

				if (true)
				{
					let modifier = FindModifier(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), "modifier_item_custom_sentry_ward_charges")
                    if (modifier != "No")
                    {
                        let check_time = Number(Buffs.GetRemainingTime(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), modifier))
                        if (check_time > 0)
                        {
                            time = Math.ceil(check_time)
                        }
                    }
				}
				var min = Math.trunc((time)/60) 
				var sec_n =  (time) - 60*Math.trunc((time)/60) 

				var hour = String( Math.trunc((min)/60) )

				var min = String(min - 60*( Math.trunc(min/60) ))

				var sec = String(sec_n)
				if (sec_n < 10) 
				{
					sec = '0' + sec

				}

				SentryCooldownLabel.text = min + ':' + sec
				if (time > 180) {
					SentryCooldownLabel.visible = false
				} else {
					SentryCooldownLabel.visible = true
				}
                break
            }
        }
    }


    let ability_smoke = -1
    for (var i = 0; i < 45; i++) {
        ability_smoke = Entities.GetAbility( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), i )
        if (ability_smoke > -1) {
            var ability_name =  Abilities.GetAbilityName( ability_smoke )
            if (ability_name == "custom_ability_smoke" ) {
				smoke_button_label.text = String(HowStacks("modifier_item_custom_smoke_charges"))

				var time = 0

				if (true)
				{
					let modifier = FindModifier(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), "modifier_item_custom_smoke_charges")
                    if (modifier != "No")
                    {
                        let check_time = Number(Buffs.GetRemainingTime(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), modifier))
                        if (check_time > 0)
                        {
                            time = Math.ceil(check_time)
                        }
                    }
				}
				
				var min = Math.trunc((time)/60) 
				var sec_n =  (time) - 60*Math.trunc((time)/60) 

				var hour = String( Math.trunc((min)/60) )

				var min = String(min - 60*( Math.trunc(min/60) ))

				var sec = String(sec_n)
				if (sec_n < 10) 
				{
					sec = '0' + sec

				}

				SmokeCooldownLabel.text = min + ':' + sec
				if (time > 240) {
					SmokeCooldownLabel.visible = false
				} else {
					SmokeCooldownLabel.visible = true
				}
                break
            }
        }
    }

	    let ability_dust = -1
    for (var i = 0; i < 45; i++) {
        ability_dust = Entities.GetAbility( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), i )
        if (ability_dust > -1) {
            var ability_name =  Abilities.GetAbilityName( ability_dust )
            if (ability_name == "custom_ability_dust" ) {
				dust_button_label.text = String(HowStacks("modifier_item_custom_dust_charges"))
                break
            }
        }
    }


	$.Schedule( 1/144, ButtonsUpdate );
}

var ParticleWard;
var lastAbilityWard = -1;

function WardParticlesUpdate()
{
	if (Abilities.GetLocalPlayerActiveAbility() != lastAbilityWard) {
		lastAbilityWard = Abilities.GetLocalPlayerActiveAbility()
		if (ParticleWard) {
			Particles.DestroyParticleEffect(ParticleWard, true)
			ParticleWard = undefined;
		}
		if ( (Abilities.GetLocalPlayerActiveAbility() != 1) && (Abilities.GetAbilityName(Abilities.GetLocalPlayerActiveAbility()) == "custom_ability_observer") ) {
			ParticleWard = Particles.CreateParticle("particles/ui_mouseactions/range_finder_ward_aoe.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()) );
		}
		if ( (Abilities.GetLocalPlayerActiveAbility() != 1) && (Abilities.GetAbilityName(Abilities.GetLocalPlayerActiveAbility()) == "custom_ability_sentry") ) {
			ParticleWard = Particles.CreateParticle("particles/ui_mouseactions/range_finder_ward_aoe.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()) );
		}

	}

	if (ParticleWard)
	{
		const cursor = GameUI.GetCursorPosition();
		const worldPosition = GameUI.GetScreenWorldPosition(cursor);
		Particles.SetParticleControl(ParticleWard, 0, Entities.GetAbsOrigin( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID())) );
		Particles.SetParticleControl(ParticleWard, 1, [ 255, 255, 255 ]);
		Particles.SetParticleControl(ParticleWard, 6, [ 255, 255, 255 ]);
	    Particles.SetParticleControl(ParticleWard, 2, worldPosition);
	    
		if ( (Abilities.GetLocalPlayerActiveAbility() != 1) && (Abilities.GetAbilityName(Abilities.GetLocalPlayerActiveAbility()) == "custom_ability_observer") ) {
			Particles.SetParticleControl(ParticleWard, 11, [ 0, 0, 0 ]);
			Particles.SetParticleControl(ParticleWard, 3, [ 1600, 1600, 1600 ]);
			
		} else if ( (Abilities.GetLocalPlayerActiveAbility() != 1) && (Abilities.GetAbilityName(Abilities.GetLocalPlayerActiveAbility()) == "custom_ability_sentry") ) {
			Particles.SetParticleControl(ParticleWard, 11, [ 1, 0, 0 ]); 
			Particles.SetParticleControl(ParticleWard, 3, [ 700, 700, 700 ]);
		}
	}

    $.Schedule(1/144, WardParticlesUpdate)
}

(function () {
	//RegisterKeybindGrenade()
	RegisterKeybindObserver()
	RegisterKeybindSentry()
})();

function RegisterKeybindDust() 
{
    const name_bind = "use_dust" + Math.floor(Math.random() * 99999999);
    Game.AddCommand(name_bind, CastAbilityDust, "", 0);
    Game.CreateCustomKeyBind(GetGameKeybind(dust_bind), name_bind);
    default_button_for_dust = GetGameKeybind(dust_bind)
}

function RegisterKeybindObserver() 
{
    const name_bind = "use_observer" + Math.floor(Math.random() * 99999999);
    Game.AddCommand(name_bind, CastAbilityObserver, "", 0);
    Game.CreateCustomKeyBind(GetGameKeybind(obs_bind), name_bind);
    default_button_for_observer = GetGameKeybind(obs_bind)
}

function RegisterKeybindSentry() 
{
    const name_bind = "use_sentry" + Math.floor(Math.random() * 99999999);
    Game.AddCommand(name_bind, CastAbilitySentry, "", 0);
    Game.CreateCustomKeyBind(GetGameKeybind(sentry_bind), name_bind);
    default_button_for_sentry = GetGameKeybind(sentry_bind)
}

function GetGameKeybind(command) 
{
    if (command != undefined)
    {
        return Game.GetKeybindForCommand(command);
    }
}

function CastAbilityObserver() {
    let ability_id = -1
    for (var i = 0; i < 45; i++) {
        abilityId = Entities.GetAbility( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), i )
        if (abilityId > -1) {
            var ability_name =  Abilities.GetAbilityName( abilityId )
            if (ability_name == "custom_ability_observer" ) {
                ability_id = abilityId
                break
            }
        }
    }

    Abilities.ExecuteAbility(ability_id, Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), false);
}

function CastAbilitySentry() {
    let ability_id = -1

    for (var i = 0; i < 45; i++) {
        abilityId = Entities.GetAbility( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), i )
        if (abilityId > -1) {
            var ability_name =  Abilities.GetAbilityName( abilityId )
            if (ability_name == "custom_ability_sentry" ) {
                ability_id = abilityId
                break
            }
        }
    }

    Abilities.ExecuteAbility(ability_id, Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), false);
}

function CastAbilitySmoke() {
    let ability_id = -1
    for (var i = 0; i < 45; i++) {
        abilityId = Entities.GetAbility( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), i )
        if (abilityId > -1) {

            var ability_name =  Abilities.GetAbilityName( abilityId )

            if (ability_name == "custom_ability_smoke" ) {
                ability_id = abilityId
                break
            }
        }
    }
    Abilities.ExecuteAbility(ability_id, Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), false);
}


function CastAbilityDust() {
    let ability_id = -1
    for (var i = 0; i < 45; i++) {
        abilityId = Entities.GetAbility( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), i )
        if (abilityId > -1) {

            var ability_name =  Abilities.GetAbilityName( abilityId )

            if (ability_name == "custom_ability_dust" ) {
                ability_id = abilityId
                break
            }
        }
    }
    Abilities.ExecuteAbility(ability_id, Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), false);
}


//function CastAbilityGranade() {
//    let ability_id = -1
//    for (var i = 0; i < 45; i++) {
//        abilityId = Entities.GetAbility( Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID()), i )
//        if (abilityId > -1) {
//
//            var ability_name =  Abilities.GetAbilityName( abilityId )
//
//            if (ability_name == "custom_ability_grenade" ) {
//                ability_id = abilityId
//                break
//            }
//        }
//    }
//    Abilities.ExecuteAbility(ability_id, Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ), false);
//}



function SetShowText(panel, text)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, $.Localize("#" + text)); });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}




function HasModifier(unit, modifier) {
    for (var i = 0; i < Entities.GetNumBuffs(unit); i++) {
        if (Buffs.GetName(unit, Entities.GetBuff(unit, i)) == modifier){
            return true
        }
    }
    return false
}

function FindModifier(unit, modifier) {
    for (var i = 0; i < Entities.GetNumBuffs(unit); i++) {
        if (Buffs.GetName(unit, Entities.GetBuff(unit, i)) == modifier){
            return Entities.GetBuff(unit, i);
        }
    }
    return "No"
}

function HowStacks(mod) {

	var hero = Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() )

	for (var i = 0; i < Entities.GetNumBuffs(hero); i++) {
		var buffID = Entities.GetBuff(hero, i)
		if (Buffs.GetName(hero, buffID ) == mod ){
			var stack = Buffs.GetStackCount(hero, buffID ) 
			return stack
		}
	}
	return 0
}

function SetObserver(panel)
{
    panel.SetPanelEvent('onmouseactivate', function() {
      CastAbilityObserver()  });    
    panel.SetPanelEvent('oncontextmenu', function() {
      CastAbilityObserver()  });    
}

function SetSentry(panel)
{
    panel.SetPanelEvent('onmouseactivate', function() {
      CastAbilitySentry()  });    
    panel.SetPanelEvent('oncontextmenu', function() {
      CastAbilitySentry()  });    
}

function SetSmoke(panel)
{
    panel.SetPanelEvent('onmouseactivate', function() {
      CastAbilitySmoke()  });    
    panel.SetPanelEvent('oncontextmenu', function() {
      CastAbilitySmoke()  });    
}

function SetDust(panel)
{
    panel.SetPanelEvent('onmouseactivate', function() {
      CastAbilityDust()  });    
    panel.SetPanelEvent('oncontextmenu', function() {
      CastAbilityDust()  });    
}

//function SetGrenade(panel)
//{
//    panel.SetPanelEvent('onmouseactivate', function() {
//      CastAbilityGranade()  });    
//    panel.SetPanelEvent('oncontextmenu', function() {
//      CastAbilityGranade()  });    
//}










