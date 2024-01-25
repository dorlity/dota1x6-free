var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);


function init() {
	GameEvents.Subscribe_custom('show_skill_event', show_skill)
}

init();
var table = [0,0,0,0,0,0]

function show_skill(kv) {
	let hero = kv.hero
	let data = Game.FindUpgradeByName(hero, kv.skill)
	let type = data[2]

	let n = Math.abs($("#PickEvent").GetChildCount())
	if (n >= 5)
		return


	for (var i = 1; i <= 6; i++)
		if (table[i] == 0) {
			table[i] = 1
			break 
		}



	let text = ""
	let margin = String((i - 1)*16.6666)

	let event = $.CreatePanel("Panel",$("#PickEvent"),"event")
	event.AddClass("event")

	let skill_icon = $.CreatePanel("Panel",event,"skill_icon")
	skill_icon.style.backgroundSize = "contain"
	skill_icon.AddClass("skill_icon")

	let text_box = $.CreatePanel("Panel",event,"text_box")
	text_box.AddClass("text_box")


	let text_skill = $.CreatePanel("Label",text_box,"text_skill")
	text_skill.html = true
	text_skill.AddClass("text_skill")

	// text_skill.text = "Эпические сферы улучшения содержат дополнительный выбор"
	text_skill.text = $.Localize("#mini_disc_" + kv.skill)

	if (type == 1) {
		if (Game.UpgradeMatchesRarity(data, "orange")) {
			skill_icon.style.backgroundImage = 'url( "file://{images}/custom_game/icons/mini/' + hero + '/' + data[6] + '.png" );'
			skill_icon.style.boxShadow = "fill #f29400 0px 0px 2px 1px"
		} else
			skill_icon.style.backgroundImage = 'url( "file://{images}/custom_game/icons/mini/' + hero + '/' + data[9] + '.png" );'
	}
	if ( (type == 0)||(type == 2) ) {
		skill_icon.style.backgroundImage = 'url( "file://{images}/custom_game/icons/mini/general/' + data[6] + '.png" );'
	}	



	text = margin + '%'
	event.style.marginTop = text
	event.style.backgroundImage = 'url("s2r://panorama/images/hud/reborn/item_purchase_bg_psd.vtex")'

	let portrait = $.CreatePanel("Panel",event,"portrait")
	portrait.AddClass("portrait")
	portrait.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + hero + '.png" );'
	portrait.style.backgroundSize = "contain"



	


	$.Schedule( 7.55, function(){ 
		event.RemoveClass("event");
		event.AddClass("event_close");
		table[i] = 0
	})
	event.DeleteAsync( 8 );

}