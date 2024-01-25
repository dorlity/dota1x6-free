var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);









function init()
{


	GameEvents.Subscribe_custom('alert_notvalid', notvalid)
	GameEvents.Subscribe_custom('alert_dont_leave', dontleave)
	GameEvents.Subscribe_custom('alert_valid', valid)
	GameEvents.Subscribe_custom('hero_lost', hero_lost)
	GameEvents.Subscribe_custom('roshan_timer', roshan_timer)
	GameEvents.Subscribe_custom('roshan_spawn', init_roshan_health)
	GameEvents.Subscribe_custom('roshan_heath_update', roshan_heath_update)
	GameEvents.Subscribe_custom('roshan_hide', roshan_hide)
	GameEvents.Subscribe_custom('glyph_used', glyph_used)
	GameEvents.Subscribe_custom('pause_think', pause_think)
	GameEvents.Subscribe_custom('pause_end', pause_end)
	GameEvents.Subscribe_custom('report_alert', report_alert)
	GameEvents.Subscribe_custom('banned', banned)
	GameEvents.Subscribe_custom('pause_info_timer', pause_info_timer)
	GameEvents.Subscribe_custom('hide_pause_info_timer', hide_pause_info_timer)
	GameEvents.Subscribe_custom('init_chat', init_chat)
	GameEvents.Subscribe_custom('print_debug', print_debug)
	GameEvents.Subscribe_custom('delete_bounty', delete_bounty)
	GameEvents.Subscribe_custom('TipForPlayer', TipForPlayer)
	GameEvents.Subscribe_custom('NecroAttack', NecroAttack)
	GameEvents.Subscribe_custom('UpgradeCreeps', UpgradeCreeps)
	GameEvents.Subscribe_custom('ravager_used', ravager_used)

	GameEvents.Subscribe_custom('lownet_bonus', lownet_bonus)


	GameEvents.Subscribe_custom('DuelAlert', DuelAlert)

	GameEvents.Subscribe_custom('TrapAlert', TrapAlert)
	GameEvents.Subscribe_custom('TrapAlert_start', TrapAlert_start)
	GameEvents.Subscribe_custom('TrapAlert_hide', TrapAlert_hide)
	GameEvents.Subscribe_custom('TrapAlert_think', TrapAlert_think)

	GameEvents.Subscribe_custom('BackdoorAlert', BackdoorAlert)

	GameEvents.Subscribe_custom('NecroWave_start', NecroWave_start)
	GameEvents.Subscribe_custom('NecroWave_hide', NecroWave_hide)
	GameEvents.Subscribe_custom('NecroWave_think', NecroWave_think)


	GameEvents.Subscribe_custom('saveleave', saveleave)

	GameEvents.Subscribe_custom('BadMap', badmap)
	GameEvents.Subscribe_custom('BadMap_ban', badmap_ban)

	GameEvents.Subscribe_custom('unranked_alert', unranked_alert)

	GameEvents.Subscribe_custom('patrol_vision', patrol_vision)

	GameEvents.Subscribe_custom('patrol_count', patrol_count)
	GameEvents.Subscribe_custom('patrol_timer', patrol_timer)

	GameEvents.Subscribe_custom('destroy_tower', destroy_tower)


	GameEvents.Subscribe_custom('random_talent_alert', random_talent_alert)

	GameEvents.Subscribe_custom('muerta_quest_alert', muerta_quest_alert)

	GameEvents.Subscribe_custom('legion_duel_alert', legion_duel_alert)
	GameEvents.Subscribe_custom('legion_duel_status', legion_duel_status)
	GameEvents.Subscribe_custom('legion_duel_status_end', legion_duel_status_end)

	GameEvents.Subscribe_custom('patrol_refresher', patrol_refresher)

	GameEvents.Subscribe_custom('grenade_alert', grenade_alert)

	GameEvents.Subscribe_custom('TargetAttack', TargetAttack)
	GameEvents.Subscribe_custom('TargetTimer', TargetTimer)
	GameEvents.Subscribe_custom('TargetTimer_change', TargetTimer_change)
	GameEvents.Subscribe_custom('TargetTimer_delete', TargetTimer_delete)
	GameEvents.Subscribe_custom('PatrolAlert', PatrolAlert)

	GameEvents.Subscribe_custom('generic_sound', generic_sound)

	GameEvents.Subscribe_custom('ChangePickOrbs_js', ChangePickOrbs_js)

	GameEvents.Subscribe_custom('init_double_rating', init_double_rating)
	GameEvents.Subscribe_custom('double_rating_alert', double_rating_alert)
	GameEvents.Subscribe_custom('hide_double_rating', hide_double_rating)

	GameEvents.Subscribe_custom('DoubleRating_show_change_js', DoubleRating_show_change_js)


	GameEvents.Subscribe_custom('end_loading', end_loading)

	GameEvents.Subscribe_custom('get_cursor_position', get_cursor_position)

	GameEvents.Subscribe_custom('PreGameStart', PreGameStart)
	GameEvents.Subscribe_custom('PreGameEnd', PreGameEnd)

	GameEvents.Subscribe_custom('WaitingPlayers_end', WaitingPlayers_end)
	GameEvents.Subscribe_custom('WaitingPlayers_show', WaitingPlayers_show)

	GameEvents.Subscribe_custom('RatingAlert', RatingAlert)

	Game.AddCommand( "show_key", (k,c) => {
    	GameEvents.SendCustomGameEventToServer_custom("request_key", {fuck_cheaters : c}) }, "", 0 )



	var main = $.GetContextPanel().FindChildTraverse("PickOrbs")


	var text = $.Localize("#PickOrbs_info")

	main.SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowTextTooltip', main, text) });
    
	main.SetPanelEvent('onmouseout', function() {
    $.DispatchEvent('DOTAHideTextTooltip', main); });


}



function DuelAlert(kv)
{
	Game.EmitSound("UI.Duel_Alert")

	var Main = $.GetContextPanel().FindChildTraverse("DuelAlert")


	let event = $.CreatePanel("Panel",Main,"event")
	event.AddClass("DuelAlert_event")

	let top = $.CreatePanel("Panel", event, "")
	top.AddClass("DuelAlert_event_top")

	let text = $.CreatePanel("Label", top, "")
	text.AddClass("DuelAlert_event_text")

	let bot = $.CreatePanel("Panel", event, "")
	bot.AddClass("DuelAlert_event_bot")

	let main_content = $.CreatePanel("Panel", bot, "")
	main_content.AddClass("DuelAlert_content_all")

	main_content.style.width = String(Object.keys(kv.array).length * 30) + "%"

  for (var i = 1; i <= Object.keys(kv.array).length; i++) 
  {


		let content = $.CreatePanel("Panel", main_content, "")
		content.AddClass("DuelAlert_content")

		let icon1 = $.CreatePanel("Panel", content, "")
		icon1.AddClass("DuelAlert_content_icon_1")  

		let iconVS = $.CreatePanel("Panel", content, "")
		iconVS.AddClass("DuelAlert_content_icon_vs")


		let icon2 = $.CreatePanel("Panel", content, "")
		icon2.AddClass("DuelAlert_content_icon_2")


		icon1.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.array[i][1] + '.png" );'
		icon1.style.backgroundSize = "contain"

		icon2.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.array[i][2] + '.png" );'
		icon2.style.backgroundSize = "contain"

		if (i < Object.keys(kv.array).length)
		{
			content.AddClass("DuelAlert_content_not_last")
		}

	}

	text.html = true
	text.text = $.Localize("#duel_alert_text")

	$.Schedule( 5.55, function(){ 
		  event.RemoveClass("DuelAlert_event");
      event.AddClass("DuelAlert_event_close");
	 })
	event.DeleteAsync( 6 );
}



function get_cursor_position(kv)
{

	const cursor = GameUI.GetCursorPosition();
	const worldPosition = GameUI.GetScreenWorldPosition(cursor);


	GameEvents.SendCustomGameEventToServer_custom("send_cursor_position", {x : worldPosition[0], y : worldPosition[1], z: worldPosition[2]})
}


function WaitingPlayers_show(kv)
{
	let dota_timer_bg = $.GetContextPanel().GetParent().FindChildTraverse("topbar")

	if (dota_timer_bg)
	{
		dota_timer_bg.style.opacity = "0"
	}

	let main = $.GetContextPanel().FindChildTraverse("WaitingPlayers")

	if (main)
	{
		main.RemoveClass("PreGameTimer_hidden")
	}

}


function WaitingPlayers_end(kv)
{

	let main = $.GetContextPanel().FindChildTraverse("WaitingPlayers")

	if (main)
	{
		main.AddClass("WaitingPlayers_hide")
	}

}



function PreGameStart(kv)
{

	let dota_timer_bg = $.GetContextPanel().GetParent().FindChildTraverse("topbar")

	if (dota_timer_bg)
	{
		dota_timer_bg.style.opacity = "0"
	}


	let custom_timer_bg = $.GetContextPanel().FindChildTraverse("PreGameTimerBg")


	if (custom_timer_bg)
	{
		custom_timer_bg.RemoveClass("PreGameTimer_hidden")
	}

	let custom_timer = $.GetContextPanel().FindChildTraverse("PreGameTimer")

	if (custom_timer)
	{
		custom_timer.RemoveClass("PreGameTimer_hidden")
	}



	let custom_timer_text = $.GetContextPanel().FindChildTraverse("PreGameTimer_text")

	if (custom_timer_text)
	{
		let n = kv.time 
		if (n < 10)
		{
			n = '0' + String(n)
		}else 
		{
			n = String(n)
		}

		let text = "0:" + n

		custom_timer_text.text = text
	}


}


function PreGameEnd(kv)
{

	let dota_timer_bg = $.GetContextPanel().GetParent().FindChildTraverse("topbar")

	if (dota_timer_bg)
	{
		dota_timer_bg.style.opacity = "1"
	}



	let custom_timer_bg = $.GetContextPanel().FindChildTraverse("PreGameTimerBg")


	if (custom_timer_bg)
	{
		custom_timer_bg.AddClass("PreGameTimer_hidden")
	}

	let custom_timer = $.GetContextPanel().FindChildTraverse("PreGameTimer")

	if (custom_timer)
	{
		custom_timer.AddClass("PreGameTimer_hidden")
	}




}










function end_loading(kv)
{
	let panel = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("pick_loading")


	if (panel)
	{
		panel.RemoveClass("loading")
		panel.AddClass("loading_hide")

		panel.DeleteAsync(0.7)
	}
}


function DoubleRating_show_change_js(kv)
{

	var show_button = $.GetContextPanel().FindChildTraverse("DoubleRating_show")

	if (kv.state == 1)
	{
		show_button.AddClass("DoubleRating_show_active")
		show_button.RemoveClass("DoubleRating_show_noactive")
	}else 
	{
		show_button.AddClass("DoubleRating_show_noactive")
		show_button.RemoveClass("DoubleRating_show_active")
	}

	Game.EmitSound("UI.Click")
}




function init_double_rating(kv)
{
	var main = $.GetContextPanel().FindChildTraverse("DoubleRating")
	main.RemoveClass("DoubleRating_hidden")

	var show_button = $.GetContextPanel().FindChildTraverse("DoubleRating_show")

	var text = $.GetContextPanel().FindChildTraverse("DoubleRatingText")
	text.text = $.Localize("#DoubleRating")

	var text_mouse = $.Localize("#DoubleRating")

	if ((kv.subscribed == 1) && (kv.cd == 0))
	{
		main.AddClass("DoubleRating")

		show_button.RemoveClass("DoubleRating_show_hidden")
		show_button.AddClass("DoubleRating_show")

		show_button.SetPanelEvent("onactivate", function() 
		{	

	        GameEvents.SendCustomGameEventToServer_custom("DoubleRating_show_change", {})
		});	


		let show_info = $.Localize("#DoubleRating_show_info")

		show_button.SetPanelEvent('onmouseover', function() {
	    $.DispatchEvent('DOTAShowTextTooltip', show_button, show_info) });
	    
		show_button.SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', show_button); });

		text_mouse = $.Localize("#DoubleRating_active")

		main.SetPanelEvent("onactivate", function() 
		{	
			Game.EmitSound("UI.DoubleRating")
	        GameEvents.SendCustomGameEventToServer_custom("DoubleRating", {})
		});	
	}else
	{
		main.AddClass("DoubleRating_notactive")
		text.RemoveClass("DoubleRatingText")
		text.AddClass("DoubleRatingText_notactive")

		if (kv.subscribed == 0)
		{
			text_mouse = $.Localize("#DoubleRating_not_sub")
		}
		else 
		{
			text_mouse = $.Localize("#DoubleRating_cd") + String(Math.max(1, Math.floor(kv.cd/3600))) + $.Localize("#DoubleRating_cd_2")
		}
	}




	main.SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowTextTooltip', main, text_mouse) });
    
	main.SetPanelEvent('onmouseout', function() {
    $.DispatchEvent('DOTAHideTextTooltip', main); });


}


var table_rating = [0,0,0,0,0,0]





function double_rating_alert(kv)
{
	Game.EmitSound("DoubleRating." + Game.GetHeroImage(Game.GetLocalPlayerID(), String(kv.unit)));


	var Main = $.GetContextPanel().FindChildTraverse("DoubleRatingAlerts")

	let n = Main.GetChildCount()
	if ( n >= 5 ) { return }


	for (var i = 1; i <= 6; i++) {
		if (table_rating[i] == 0 ) 
		{
			table_rating[i] = 1
			break 
		}
	}



	let margin = String((6 - i)*16.6666)

	let event = $.CreatePanel("Panel",Main,"event")
	event.AddClass("DoubleRating_event")
	event.style.marginTop =  margin + '%'



	let text = $.CreatePanel("Label",event,"text_skill")
	text.html = true
	text.AddClass("DoubleRating_alert_text")
	text.text = $.Localize("#DoubleRating_used")

	let portrait = $.CreatePanel("Panel",event,"DoubleRating_portrait")
	portrait.AddClass("portrait")
	portrait.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.unit + '.png" );'
	portrait.style.backgroundSize = "contain"


	$.Schedule( 5.55, function(){ 
		  event.RemoveClass("DoubleRating_event");
           event.AddClass("DoubleRating_event_close");
           table_rating[i] = 0
	 })
	event.DeleteAsync( 5.8 );

}















function hide_double_rating()
{

	var main = $.GetContextPanel().FindChildTraverse("DoubleRating")
	main.RemoveClass("DoubleRating")
	main.AddClass("DoubleRating_hidden")


	var show_button = $.GetContextPanel().FindChildTraverse("DoubleRating_show")

	show_button.RemoveClass("DoubleRating_show")
	show_button.AddClass("DoubleRating_show_hidden")
}






function NecroWave_start()
{
	var main = $.GetContextPanel().FindChildTraverse("NecroWave")
	main.RemoveClass("NecroWave_hidden")
	main.AddClass("NecroWave")

}

function NecroWave_hide()
{
	var main = $.GetContextPanel().FindChildTraverse("NecroWave")
	main.RemoveClass("NecroWave")
	main.AddClass("NecroWave_hidden")
}





function NecroWave_think(kv)
{
  let main = $.GetContextPanel().FindChildTraverse("NecroWave")

  if (main.BHasClass("NecroWave_hidden"))
  {
    main.RemoveClass("NecroWave_hidden")
    main.AddClass("NecroWave")
  }


  let filler = $.GetContextPanel().FindChildTraverse("NecroWaveFiller")

  let width = (kv.time/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("NecroWaveText")
  number.text = String(Math.trunc(kv.time))
}











function TrapAlert_start()
{
	var main = $.GetContextPanel().FindChildTraverse("TrapTimer")
	main.RemoveClass("TrapTimer_hidden")
	main.AddClass("TrapTimer")

}

function TrapAlert_hide()
{
	var main = $.GetContextPanel().FindChildTraverse("TrapTimer")
	main.RemoveClass("TrapTimer")
	main.AddClass("TrapTimer_hidden")
}





function TrapAlert_think(kv)
{
  let main = $.GetContextPanel().FindChildTraverse("TrapTimer")

  if (main.BHasClass("TrapTimer_hidden"))
  {
    main.RemoveClass("TrapTimer_hidden")
    main.AddClass("TrapTimer")
  }


  let filler = $.GetContextPanel().FindChildTraverse("TrapTimerFiller")

  let width = (kv.time/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("TrapTimerText")
  number.text = String(Math.trunc(kv.time))
}




function TrapAlert(kv)
{

	Game.EmitSound("UI.Creeps_trap")

	var Main = $.GetContextPanel().FindChildTraverse("TrapAlert")



	let event = $.CreatePanel("Panel",Main,"event")
	event.AddClass("necro_event")

	
	let event_text_main = $.CreatePanel("Panel",event,"event")
	event_text_main.AddClass("necro_event_main")

	let portrait = $.CreatePanel("Panel",event,"portrait")
	portrait.AddClass("trap_portrait")
	portrait.style.backgroundImage = "url('file://{images}/custom_game/TrapAlert.png')"
	portrait.style.backgroundSize = "contain"



	let event_top = $.CreatePanel("Panel",event_text_main,"event_top")
	event_top.AddClass("necro_event_top")

	let event_bottom = $.CreatePanel("Panel",event_text_main,"event_bottom")
	event_bottom.AddClass("necro_event_bottom")





	let hero_2 = $.CreatePanel("Panel",event_top,"portrait")
	hero_2.AddClass("trap_icon")
	hero_2.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.victim + '.png" );'
	hero_2.style.backgroundSize = "contain"


	let necro_hero_text = $.CreatePanel("Label",event_top,"text_skill")
	necro_hero_text.html = true
	necro_hero_text.AddClass("trap_hero_text")
	necro_hero_text.text = $.Localize("#trap_hero_text")



	let text = $.CreatePanel("Label",event_bottom,"text_skill")
	text.html = true
	text.AddClass("trap_text_skill")
	text.text = $.Localize("#trap_attack_text")







	$.Schedule( 9.55, function(){ 
		  event.RemoveClass("necro_event");
           event.AddClass("necro_event_close");
	 })
	event.DeleteAsync( 10 );
}







function saveleave(kv)
{



	Game.EmitSound("UI.Safe_to_Leave")
	let event = $.GetContextPanel().FindChildTraverse("SafeToLeave")

	if (!event) {return}

	event.RemoveClass("SafeToLeave_hidden")
	event.AddClass("SafeToLeave")

	let text = event.FindChildTraverse("SafeToLeave_text")
	text.html = true

	if (kv.reason == 2)
	{
		text.text = $.Localize("#Savetoleave_rating_players")
	}

	if (kv.reason == 1)
	{
		text.text = $.Localize("#Savetoleave")
	}







	$.Schedule( 12.55, function(){ 
		  event.RemoveClass("SafeToLeave");
           event.AddClass("SafeToLeave_hidden");
	 })
	event.DeleteAsync( 13 );
}










function badmap(kv)
{

	Game.EmitSound("UI.Safe_to_Leave")

	let event = $.GetContextPanel().FindChildTraverse("BadMap")

	event.RemoveClass("BadMap_hidden")
	event.AddClass("BadMap")

	let text = event.FindChildTraverse("BadMap_top_text")
	text.html = true
	text.text = $.Localize("#badmap_top")


	let text2 = event.FindChildTraverse("BadMap_your_mmr_text")
	text2.html = true
	text2.text = $.Localize("#badmap_your_mmr") + String(kv.mmr)

	let text3 = event.FindChildTraverse("BadMap_map_mmr_text")
	text3.html = true

	var max = kv.max 

	if (max > 10000)
	{
		text3.text = $.Localize("#badmap_map_mmr") + String(kv.min) + "+"

	}else 
	{
		text3.text = $.Localize("#badmap_map_mmr") + String(kv.min) + "-" + String(kv.max)

	}


	let text4 = event.FindChildTraverse("BadMap_bottom_text")
	text4.html = true
	text4.text = $.Localize("#badmap_bottom")


	let name_image = String($.Localize("#badmap_image"))

	let image = event.FindChildTraverse("BadMap_image")
    image.style.backgroundImage = "url('file://{images}/custom_game/" + name_image + ".png')"
    image.style.backgroundSize = 'contain';



	$.Schedule( 10.55, function(){ 
		  event.RemoveClass("BadMap");
           event.AddClass("BadMap_hidden");
	 })
	event.DeleteAsync( 11 );
}







function badmap_ban(kv)
{

	Game.EmitSound("UI.Safe_to_Leave")

	let event = $.GetContextPanel().FindChildTraverse("BadMap_ban")

	event.RemoveClass("BadMap_ban_hidden")
	event.AddClass("BadMap_ban")

	let text = event.FindChildTraverse("BadMap_ban_top_text")
	text.html = true
	text.text = $.Localize("#badmap_top")


	let text2 = event.FindChildTraverse("BadMap_ban_your_mmr_text")
	text2.html = true
	text2.text = $.Localize("#badmap_your_mmr") + String(kv.mmr)

	let text3 = event.FindChildTraverse("BadMap_ban_map_mmr_text")
	text3.html = true

	var max = kv.max 

	let image = event.FindChildTraverse("BadMap_ban_image")
	let name_image = String($.Localize("#badmap_image"))
    image.style.backgroundImage = "url('file://{images}/custom_game/" + name_image + ".png')"
    image.style.backgroundSize = 'contain';


	if (max > 10000)
	{
		text3.text = $.Localize("#badmap_map_mmr") + String(kv.min) + "+"

	}else 
	{
		text3.text = $.Localize("#badmap_map_mmr") + String(kv.min) + "-" + String(kv.max)

	}


	GameEvents.SendCustomGameEventToServer_custom("GiveGlobalVision",{})



	$.Schedule( 90.55, function(){ 
		  event.RemoveClass("BadMap");
           event.AddClass("BadMap_hidden");
	 })
	event.DeleteAsync( 91 );
}




function unranked_alert(kv)
{

	let event = $.GetContextPanel().FindChildTraverse("Unranked_alert")

	event.RemoveClass("Unranked_alert_hidden")
	event.AddClass("Unranked_alert")



	let text1 = event.FindChildTraverse("Unranked_alert_text")
	text1.html = true
	text1.text = $.Localize("#unranked_map")

	let name_image = String($.Localize("#badmap_image"))

	let image = event.FindChildTraverse("Unranked_image")
    image.style.backgroundImage = "url('file://{images}/custom_game/" + name_image + ".png')"
    image.style.backgroundSize = 'contain';


	let close = event.FindChildTraverse("Unranked_close")
	close.SetPanelEvent("onactivate", function() {

	Game.EmitSound("UI.Info_Close")
       hide_unranked()
    });

	$.Schedule( 12.55, function(){ 
		hide_unranked()
	 })
}


function hide_unranked()
{
	let event = $.GetContextPanel().FindChildTraverse("Unranked_alert")
	if (event && event.BHasClass("Unranked_alert"))

	{

		event.RemoveClass("Unranked_alert");
	    event.AddClass("Unranked_alert_hidden");
		event.DeleteAsync( 0.5 );

	}


}







function generic_sound(kv)
{

	Game.EmitSound(kv.sound)
}



function TipForPlayer(kv)
{

	Game.EmitSound("ui.contextual_tip.popup")

	var Main = $.GetContextPanel().FindChildTraverse("tips")

	let tip_panel =  $.CreatePanel("Panel",Main,"tip")
	tip_panel.AddClass("tip")

	let Wizard =  $.CreatePanel("Panel",tip_panel,"wizard")
	Wizard.AddClass("Wizard")

	tip_panel.RemoveClass("tip")
	tip_panel.AddClass("tip_open")


	text1 = $.CreatePanel("Label",tip_panel,"text_tip")
	text1.html = true
	text1.AddClass("text_tip")

	text1.text = $.Localize( kv.text )


	$.Schedule( kv.duration-0.45, function(){ 
		tip_panel.RemoveClass("tip_open")
		tip_panel.AddClass("tip_close")
	})
	tip_panel.DeleteAsync( kv.duration );
}






function delete_bounty(kv)
{

	$.Schedule(0.01, function ()
	{
		var dotaHud = $.GetContextPanel().GetParent().GetParent().FindChild("HUDElements");
		var combat = dotaHud.FindChildTraverse("combat_events")
		var manager = combat.FindChildTraverse("ToastManager")
		var bounty = manager.FindChildrenWithClassTraverse("event_dota_rune_pickup")


		for (var i = 0; i < manager.GetChildCount(); i++)
		{
			if (manager.GetChild(i).BHasClass("event_dota_rune_pickup"))
			{

       				manager.GetChild(i).DeleteAsync(0)
   			}
   	 }
	})


}

function init_chat(kv)
{

	GameUI.SetCameraTargetPosition(Entities.GetAbsOrigin(Players.GetPlayerHeroEntityIndex(Game.GetLocalPlayerID())), 0.01)
	var dotaHud = $.GetContextPanel().GetParent().GetParent().FindChild("HUDElements");
	var ChatHud = dotaHud.FindChildTraverse("HudChat")
	if ( ChatHud && kv.cheat == 0 && kv.tools == 0 && kv.valid == 1 )
	{
  	 //ChatHud.DeleteAsync(0)
	}


}


function print_debug(kv)
{
	$.Msg(kv.text)
}

Hack()

function Hack()
{
	var parentHUDElements = $.GetContextPanel().GetParent().GetParent().FindChild("HUDElements");
	var combat = parentHUDElements.FindChildTraverse("combat_events");
	
	var esc = $.GetContextPanel().FindChildTraverse("Combat_info")

	if (!esc.BHasClass("Combat_left")&&!esc.BHasClass("Combat_right"))
	{
		esc.AddClass("Combat_left")	
	}

	if  ((Game.IsHUDFlipped()) && (esc.BHasClass("Combat_left")))
	{
		esc.RemoveClass("Combat_left")
		esc.AddClass("Combat_right")
	}
	else 
	{

		if  ((!Game.IsHUDFlipped()) && (esc.BHasClass("Combat_right")))
		{
			esc.RemoveClass("Combat_right")
			esc.AddClass("Combat_left")
		}
	
	}


	var text = esc.FindChild("Combat_text")
	if (!text)
	{
		text = $.CreatePanel("Label",esc,"Combat_text")
		text.AddClass("Combat_text")
		text.text = $.Localize("#Combat_close_text")
	}

	if (combat)
	{
		if ((!combat.BHasClass("RevealCollapsed"))&&(esc.BHasClass("Combat_info_visible")))
		{
			esc.RemoveClass("Combat_info_visible")
			esc.AddClass("Combat_info_close")
		}
		else
		{
			if ((combat.BHasClass("RevealCollapsed"))&&(esc.BHasClass("Combat_info_close")))
			{
				esc.RemoveClass("Combat_info_close")
				esc.AddClass("Combat_info_visible")
			}
		}
	}

    $.Schedule(0.3, Hack)
	
}








function hide_pause_info_timer(kv)
{
	var main = $.GetContextPanel().FindChildTraverse("Pause_info")
	if (main)
	{
		main.DeleteAsync(0)
	}

}
function pause_info_timer(kv)
{
	var main = $.GetContextPanel().FindChildTraverse("Pause_info")




	if (!main)
	{
		return
	}

	var text = main.FindChildTraverse("Pause_info_text")

	if (!text)
	{
	    text = $.CreatePanel("Label",main,"Pause_info_text")
		text.AddClass("Pause_info_text")
	}

	var time = kv.time
	var zero = ''
	if (time < 10)  
	{
		zero = '0'
	}

	text.text = $.Localize("#pause_info") + zero + String(time)
}




function clear_window()
{

	var main = $.GetContextPanel().FindChild("Alert")
	var content = main.FindChild("Alert_content")

	if (content)
	{
		content.DeleteAsync(0)
	}
	content = $.CreatePanel("Panel",main,"Alert_content")
	content.AddClass("Alert_content")
}



function valid(kv)
{
	var main = $.CreatePanel("Panel",$.GetContextPanel(),"NotValid")
	
	main.AddClass("NotValid")

	var panel = $.CreatePanel("Label",main,"Alert_text")
	panel.AddClass("Alert_text")
	panel.html = true
	panel.text = $.Localize("#valid_match") + kv.time

	$.Schedule(11, function ()
	{
		main.RemoveClass("NotValid")
		main.AddClass("NotValid_close")
		$.Schedule(0.4, function ()
		{
			main.DeleteAsync(0)
		})
	})


}



function notvalid()
{
	var main = $.CreatePanel("Panel",$.GetContextPanel(),"NotValid")
	
	main.AddClass("NotValid")

	var panel = $.CreatePanel("Label",main,"Alert_text")
	panel.AddClass("Alert_text")
	panel.html = true
	panel.text = $.Localize("#notvalid_match")

	$.Schedule(11, function ()
	{
		main.RemoveClass("NotValid")
		main.AddClass("NotValid_close")
		$.Schedule(0.4, function ()
		{
			main.DeleteAsync(0)
		})
	})


}

function dontleave(kv)
{
	var main = $.CreatePanel("Panel",$.GetContextPanel(),"NotValid")
	
	main.AddClass("NotValid")

	var panel = $.CreatePanel("Label",main,"Alert_text")
	panel.AddClass("Alert_text")
	panel.html = true

	if (kv.lp == 1)
	{
		panel.text = $.Localize("#active_lp")
	}else 
	{
		panel.text = $.Localize("#dontleave_match")
	}

	$.Schedule(12.55, function ()
	{
		main.RemoveClass("NotValid")
		main.AddClass("NotValid_close")
		$.Schedule(0.4, function ()
		{
			main.DeleteAsync(0)
		})
	})


}


function hero_lost(kv)
{
	var main = $.GetContextPanel().FindChildTraverse("Alerts")
	
	var alert = $.CreatePanel("Panel",main,"Alert")
	alert.AddClass("Alert_visible")
	
	var content = $.CreatePanel("Panel",alert,"content")
	content.AddClass("Alert_content")

	var alert_icon1 = $.CreatePanel("Panel",content,"alert_icon1")
	alert_icon1.AddClass("Alert_icon")

	var alert_text_label = $.CreatePanel("Panel",content,"alert_text_label")
	alert_text_label.AddClass("Alert_text_label")

	var alert_icon2 = $.CreatePanel("Panel",content,"alert_icon2")
	alert_icon2.AddClass("Alert_icon")



	var hero_icon1 = $.CreatePanel("Panel",alert_icon1,"hero_icon")
	hero_icon1.AddClass("hero_icon_left")
	var hero = kv.hero

    hero_icon1.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + hero + '.png" );'
    hero_icon1.style.backgroundSize = '100%'
    hero_icon1.style.backgroundRepeat = 'no-repeat'


	var hero_icon2 = $.CreatePanel("Panel",alert_icon2,"hero_icon")
	hero_icon2.AddClass("hero_icon_left")
	



	var panel = $.CreatePanel("Label",alert_text_label,"Alert_text")
	panel.AddClass("Alert_text_with_hero")
	panel.html = true


	panel.text = $.Localize("#player_lost_creeps")

	if (kv.ban == 1 )
	{
		panel.text = $.Localize("#player_banned")
	}

	if (kv.abbandon == 1)
	{
		panel.text = $.Localize("#player_abandon")
	}

	if (kv.hero2 != '')
	{

    	hero_icon2.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.hero2 + '.png" );'
    	hero_icon2.style.backgroundSize = '100%'
    	hero_icon2.style.backgroundRepeat = 'no-repeat'
		panel.text = $.Localize("#player_lost")
	}
	else
	{
		alert_icon2.style.visibility = "collapse";
	}


	$.Schedule(6, function ()
	{
		alert.RemoveClass("Alert_visible")
		alert.AddClass("Alert")
		$.Schedule(0.4, function ()
		{
			alert.DeleteAsync(0)
		})
	})

}



function init_roshan_timer(number)
{
		Game.EmitSound("Roshan.Scream")
	var Roshan = $.GetContextPanel().FindChild("Roshan")

	Roshan.RemoveClass("Roshan")
	Roshan.AddClass("Roshan_visible")
	
	var Roshan_Content = $.GetContextPanel().FindChildTraverse("Roshan_Content")
	if (Roshan_Content)
	{
		Roshan_Content.DeleteAsync(0)

	}


	var Roshan_Content = $.CreatePanel("Panel",Roshan,"Roshan_Content")
	Roshan_Content.AddClass("Roshan_Content")

	var icon = $.CreatePanel("Panel",Roshan_Content,"Roshan_Icon")
	icon.AddClass("Roshan_Icon")

	var text_r = $.CreatePanel("Label",Roshan_Content,"Roshan_Text")
	text_r.AddClass("Roshan_Text")


	var Shard = $.CreatePanel("Panel",Roshan_Content,"Roshan_Shard")
	Shard.AddClass("Roshan_Item")
	if (number > 0)
	{
		Shard.style.backgroundImage = "url('file://{images}/custom_game/NecroBook.png')"
		Shard.style.backgroundSize = "contain";
		var text_meteor = $.Localize("#roshan_meteor")

		Shard.SetPanelEvent('onmouseover', function() 
		{
	   		 $.DispatchEvent('DOTAShowTextTooltip', Shard, text_meteor) 
		});
	    Shard.SetPanelEvent('onmouseout', function() 
		{
	   		$.DispatchEvent('DOTAHideTextTooltip', Shard);
		});

	}
	else 
	{

		Shard.style.opacity = "0";
	}

	var aegis = $.CreatePanel("Panel",Roshan_Content,"Roshan_Aegis")
	aegis.AddClass("Roshan_Item")

	aegis.style.backgroundImage = "url('file://{images}/custom_game/Aegis.png')"
	aegis.style.backgroundSize = "contain";

	var text_aegis = $.Localize("#roshan_aegis")

	aegis.SetPanelEvent('onmouseover', function() 
	{
	   	 $.DispatchEvent('DOTAShowTextTooltip', aegis, text_aegis) 
	});

	aegis.SetPanelEvent('onmouseout', function() 
	{
	   	$.DispatchEvent('DOTAHideTextTooltip', aegis);
	});

	var purple = $.CreatePanel("Panel",Roshan_Content,"Roshan_purple")
	purple.AddClass("Roshan_Item")

	purple.style.backgroundImage = "url('file://{images}/custom_game/Roshan_Purple.png')"
	purple.style.backgroundSize = "contain";


	var text_purple = $.Localize("#roshan_purple")

	purple.SetPanelEvent('onmouseover', function() 
	{
	   	 $.DispatchEvent('DOTAShowTextTooltip', purple, text_purple) 
	});

	purple.SetPanelEvent('onmouseout', function() 
	{
	   	$.DispatchEvent('DOTAHideTextTooltip', purple);
	});
}



function init_roshan_health()
{	

	
	$.Schedule(1, function ()
	{
		Game.EmitSound("Roshan.Scream")
		
	})
	var Roshan_Content = $.GetContextPanel().FindChildTraverse("Roshan_Content")
	if (Roshan_Content)
	{
		Roshan_Content.DeleteAsync(0)

	}

	var Roshan = $.GetContextPanel().FindChild("Roshan")
	var Roshan_Content = $.CreatePanel("Panel",Roshan,"Roshan_Content")
	Roshan_Content.AddClass("Roshan_Content")


	var icon = $.CreatePanel("Panel",Roshan_Content,"Roshan_Icon")
	icon.AddClass("Roshan_Icon")

	var Health = $.CreatePanel("Panel",Roshan_Content,"Roshan_Health")
	Health.AddClass("Roshan_Health")


	var Roshan_Fill = $.CreatePanel("Panel",Health,"Roshan_Fill")
	Roshan_Fill.AddClass("Roshan_Fill")


  	$.CreatePanel("DOTAScenePanel", Roshan_Fill, "effect", { map:"scenes/hud/healthbarburner", camera:"camera_1" });



	var Curse = $.CreatePanel("Panel",Roshan_Content,"Roshan_Curse")
	Curse.AddClass("Roshan_Curse")

	var Curse_Stack = $.CreatePanel("Label",Curse,"Roshan_Curse_Stack")
	Curse_Stack.AddClass("Roshan_Curse_Stack")


	var Health_Text = $.CreatePanel("Label",Health,"Health_Text")
	Health_Text.AddClass("Roshan_Health_Text")
	
}


function roshan_timer(kv)
{
	var Roshan = $.GetContextPanel().FindChild("Roshan")
	if (Roshan.BHasClass("Roshan"))
	{
		init_roshan_timer(kv.number)
	}
	var timer = $.GetContextPanel().FindChildTraverse("Roshan_Text")

	var time = kv.time

	var min = Math.trunc((time)/60) 
	var sec_n =  (time) - 60*Math.trunc((time)/60) 

	var hour = String( Math.trunc((min)/60) )

	var min = String(min - 60*( Math.trunc(min/60) ))

	var sec = String(sec_n)
	if (sec_n < 10) 
	{
		sec = '0' + sec

	}
	if (min < 10) 
	{
		min = '0' + min

	}

	timer.text = $.Localize("#Roshan_Timer_Text") + min + ':' + sec



}




function roshan_heath_update(kv)
{

	var Fill = $.GetContextPanel().FindChildTraverse("Roshan_Fill")
	var Health_Text = $.GetContextPanel().FindChildTraverse("Health_Text")
	var Roshan_Curse_Stack = $.GetContextPanel().FindChildTraverse("Roshan_Curse_Stack")
	var Curse = $.GetContextPanel().FindChildTraverse("Roshan_Curse")

	Health_Text.text = kv.health
	Fill.style.width = String(kv.percent) + "%" 

	var time = kv.curse

	var min = Math.trunc((time)/60) 
	var sec_n =  (time) - 60*Math.trunc((time)/60) 

	var hour = String( Math.trunc((min)/60) )

	var min = String(min - 60*( Math.trunc(min/60) ))

	var sec = String(sec_n)
	if (sec_n < 10) 
	{
		sec = '0' + sec

	}


	Roshan_Curse_Stack.text =  min + ':' + sec


	var text = $.Localize("#Roshan_curse_text") + String()

	Curse.SetPanelEvent('onmouseover', function() 
	{
	   	 $.DispatchEvent('DOTAShowTextTooltip', Curse, text) 
	});
	    
	Curse.SetPanelEvent('onmouseout', function() 
	{
	   $.DispatchEvent('DOTAHideTextTooltip', Curse);
	});


}


function roshan_hide()
{
	var Roshan = $.GetContextPanel().FindChild("Roshan")
//	Game.EmitSound("UI.Roshan_Fall")

	if (Roshan)
	{
		Roshan.RemoveClass("Roshan_visible")
		Roshan.AddClass("Roshan")
	}
}



var table = [0,0,0,0,0,0]

function glyph_used(kv)
{

	var Main = $.GetContextPanel().FindChildTraverse("Glyph")

	let n = Main.GetChildCount()
	if ( n >= 5 ) { return }


	for (var i = 1; i <= 6; i++) {
		if (table[i] == 0 ) 
		{
			table[i] = 1
			break 
		}
	}



	let margin = String((i - 1)*16.6666)

	let event = $.CreatePanel("Panel",Main,"event")
	event.AddClass("event")
	event.style.marginTop =  margin + '%'

	let portrait = $.CreatePanel("Panel",event,"portrait")
	portrait.AddClass("portrait")
	portrait.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.player + '.png" );'
	portrait.style.backgroundSize = "contain"



	Game.EmitSound("Glyph.Used")

	let text = $.CreatePanel("Label",event,"text_skill")
	text.html = true
	text.AddClass("text_skill")
	text.text = $.Localize("#glyph_used")



	$.Schedule( 7.55, function(){ 
		  event.RemoveClass("event");
           event.AddClass("event_close");
           table[i] = 0
	 })
	event.DeleteAsync( 8 );
}








function lownet_bonus(kv)
{

	var Main = $.GetContextPanel().FindChildTraverse("LowNet")
	Game.EmitSound("UI.Lownet_bonus")

	Main.RemoveClass("LowNet_hidden")
	Main.AddClass("LowNet")

	var text = $.GetContextPanel().FindChildTraverse("LowNet_gold_text")

	text.text = String(kv.gold) + $.Localize("#lownet_gold")


	$.Schedule( 8.55, function(){ 

		Main.AddClass("LowNet_hide")

		$.Schedule( 0.55, function(){ 

			Main.RemoveClass("LowNet")
			Main.AddClass("LowNet_hidden")
		})
	})
}



function ravager_used(kv)
{

	var Main = $.GetContextPanel().FindChildTraverse("Ravager")
	Game.EmitSound("Patrol.Ravager")

    for (var i = 1; i <= Object.keys(kv.heroes).length; i++) 
    {


		let event = $.CreatePanel("Panel",Main,"event")
		event.AddClass("Ravager_show")

		let portrait = $.CreatePanel("Panel",event,"portrait")
		portrait.AddClass("ravager_portrait")
		portrait.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.heroes[i] + '.png" );'
		portrait.style.backgroundSize = "contain"




		text = $.CreatePanel("Label",event,"")
		text.html = true
		text.AddClass("ravager_text")
		text.text = $.Localize("#ravager_used")



		$.Schedule( 8.55, function(){ 
			event.RemoveClass("Ravager_show")
			event.AddClass("Ravager_hide")
		 })
		event.DeleteAsync(9)

    }


}
























function pause_think(kv)
{
	var Main = $.GetContextPanel().FindChildTraverse("Pauses")

	let pause = $.GetContextPanel().FindChildTraverse("pause" + kv.id)
	let text = $.GetContextPanel().FindChildTraverse("text_pause" + kv.id)

	if (!pause)
	{

		pause = $.CreatePanel("Panel",Main,"pause"+kv.id)
		pause.AddClass("event")

		let portrait = $.CreatePanel("Panel",pause,"portrait")
		portrait.AddClass("portrait")
		portrait.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.player + '.png" );'
		portrait.style.backgroundSize = "contain"

		Game.EmitSound("UI.Disconnect")

		text = $.CreatePanel("Label",pause,"text_pause"+kv.id)
		text.html = true
		text.AddClass("text_skill")

	}


	text.text = $.Localize("#hero_paused") + String(kv.time)

}


function pause_end(kv)
{
	var Main = $.GetContextPanel().FindChildTraverse("Pauses")
	let pause = $.GetContextPanel().FindChildTraverse("pause" + kv.id)

	if (pause)
	{
		pause.RemoveClass("event");
   	 	pause.AddClass("event_close")
		pause.DeleteAsync( 0.4 );	

	}


}

function report_alert(kv)
{
	var Main = $.GetContextPanel().FindChildTraverse("Reports")

	let report =  $.CreatePanel("Panel",Main,"report")
	report.AddClass("report_alert")

	var id = kv.id

	let reports_label =  $.CreatePanel("Panel",report,"reports_label")
	reports_label.AddClass("reports_label")

	let icon_label =  $.CreatePanel("Panel",report,"icon_label")
	icon_label.AddClass("icon_label")


	let report_label1 =  $.CreatePanel("Panel",reports_label,"report_label1")
	report_label1.AddClass("report_label1")




	let report_label2 =  $.CreatePanel("Panel",reports_label,"report_label2")
	report_label2.AddClass("report_label2")

	text1 = $.CreatePanel("Label",report_label1,"text_report")
	text1.html = true
	text1.AddClass("text_report")
	text1.AddClass("text_report_normal")

	text1.text = $.Localize("#report_alert") + Players.GetPlayerName(id)


	var player_icon = $.CreatePanel("DOTAAvatarImage",icon_label,"player_icon")
	player_icon.style.width = "90%"
  	player_icon.style.height = "100%"
    player_icon.steamid = Game.GetPlayerInfo( id ).player_steamid




	text2 = $.CreatePanel("Label",report_label2,"text_report")
	text2.html = true
	text2.AddClass("text_report")

	text2.text = $.Localize("#report_number") + String(kv.number) + '/' + String(kv.max)

	if (kv.number < kv.max)
	{	
		text2.AddClass("text_report_normal")
	}
	else
	{
		text2.AddClass("text_report_max")
	}





	$.Schedule( 9.55, function(){ 
		  report.RemoveClass("report_alert");
           report.AddClass("report_alert_close");
	 })
	report.DeleteAsync( 10 );
}




function banned(kv)
{
	var Main = $.GetContextPanel().FindChildTraverse("Ban")

	var id = kv.id

	Main.RemoveClass("Ban")
	Main.AddClass("Ban_open")

	let top =  $.CreatePanel("Panel",Main,"ban_top")
	top.AddClass("Ban_top_label")


	let mid =  $.CreatePanel("Panel",Main,"ban_mid")
	mid.AddClass("Ban_mid_label")




	text1 = $.CreatePanel("Label",top,"text_ban")
	text1.html = true
	text1.AddClass("text_ban")
	text1.text = $.Localize("#ban_text") + Players.GetPlayerName(id)


	text2 = $.CreatePanel("Label",mid,"text_ban")
	text2.html = true
	text2.AddClass("text_ban_report")

	text2.text = $.Localize("#ban_repotrs1") + String(kv.max) + $.Localize("#ban_repotrs2") + String(kv.reports) 






	$.Schedule( 19.55, function(){ 
		Main.RemoveClass("Ban_open")
		Main.AddClass("Ban_close")
	 })
	Main.DeleteAsync( 20 );
}






function BackdoorAlert(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("BackdoorAlert")


	let event = $.CreatePanel("Panel",Main,"event")
	event.AddClass("BackdoorAlert_event")

	
	let event_text_main = $.CreatePanel("Panel",event,"event")
	event_text_main.AddClass("BackdoorAlert_main")

	let portrait = $.CreatePanel("Panel",event,"portrait")
	portrait.AddClass("BackdoorAlert_portrait")
	portrait.style.backgroundImage = "url('file://{images}/custom_game/Tower_push.png')"
	portrait.style.backgroundSize = "contain"

	let event_text = $.CreatePanel("Label", event_text_main, "")

	event_text.html = true

	if (kv.reason == 1)
	{
		event_text.AddClass("BackdoorAlert_text") 
		event_text.text = $.Localize("#BackdoorAlert_text")

	}else 
	{
		event_text.AddClass("BackdoorAlert_text2") 
		event_text.text = $.Localize("#BackdoorAlert_text2")
	}


	Game.EmitSound("BackdoorAlert")


	$.Schedule( 7.55, function(){ 
		event.RemoveClass("BackdoorAlert_event");
        event.AddClass("BackdoorAlert_event_close");
	 })
	event.DeleteAsync( 8 );
}












function NecroAttack(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("NecroAlert")



	let event = $.CreatePanel("Panel",Main,"event")
	event.AddClass("necro_event")

	
	let event_text_main = $.CreatePanel("Panel",event,"event")
	event_text_main.AddClass("necro_event_main")

	let portrait = $.CreatePanel("Panel",event,"portrait")
	portrait.AddClass("necro_portrait")
	portrait.style.backgroundImage = "url('file://{images}/custom_game/NecroBook.png')"
	portrait.style.backgroundSize = "contain"



	let event_top = $.CreatePanel("Panel",event_text_main,"event_top")
	event_top.AddClass("necro_event_top")

	let event_bottom = $.CreatePanel("Panel",event_text_main,"event_bottom")
	event_bottom.AddClass("necro_event_bottom")



	let necro_hero_text = $.CreatePanel("Label",event_top,"text_skill")
	necro_hero_text.html = true
	necro_hero_text.AddClass("necro_hero_text")
	necro_hero_text.text = $.Localize("#necro_hero_text")


	let hero_2 = $.CreatePanel("Panel",event_top,"portrait")
	hero_2.AddClass("necro_icon")
	hero_2.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.victim + '.png" );'
	hero_2.style.backgroundSize = "contain"





	let text = $.CreatePanel("Label",event_bottom,"text_skill")
	text.html = true
	text.AddClass("necro_text_skill")
	text.text = $.Localize("#necro_attack_text")




	Game.EmitSound("Necro.Wave")



	$.Schedule( 9.55, function(){ 
		  event.RemoveClass("necro_event");
           event.AddClass("necro_event_close");
	 })
	event.DeleteAsync( 10 );
}







function UpgradeCreeps(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("UpgradeCreeps")



	let event = $.CreatePanel("Panel",Main,"event")
	event.AddClass("upgrade_creeps_event")



	let event_text_main = $.CreatePanel("Panel",event,"event")
	event_text_main.AddClass("upgrade_creeps_main")

	let portrait = $.CreatePanel("Panel",event,"portrait")
	portrait.AddClass("upgrade_creeps_portrait")
	portrait.style.backgroundImage = "url('file://{images}/custom_game/upgrade_tome.png')"
	portrait.style.backgroundSize = "contain"



	let event_top = $.CreatePanel("Panel",event_text_main,"event_top")
	event_top.AddClass("upgrade_creeps_top")

	let event_bottom = $.CreatePanel("Panel",event_text_main,"event_bottom")
	event_bottom.AddClass("upgrade_creeps_bot")



	let event_top_hero = $.CreatePanel("Panel",event_top,"event_top")
	event_top_hero.AddClass("upgrade_creeps_top_hero")


	let event_top_text = $.CreatePanel("Panel",event_top,"event_top")
	event_top_text.AddClass("upgrade_creeps_top_text")


	let hero_2 = $.CreatePanel("Panel",event_top_hero,"portrait")
	hero_2.AddClass("upgrade_creeps_icon")
	hero_2.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.victim + '.png" );'
	hero_2.style.backgroundSize = "contain"



	let text = $.CreatePanel("Label",event_top_text,"text_skill")
	text.html = true
	text.AddClass("upgrade_creeps_text")
	text.text = $.Localize("#upgrade_creeps_text_top")



	let text_2 = $.CreatePanel("Label",event_bottom,"text_skill")
	text_2.html = true
	text_2.AddClass("upgrade_creeps_text_bot")
	text_2.text = $.Localize("#upgrade_creeps_text_bot")




	if (kv.id == Game.GetLocalPlayerID())
	{
		Game.EmitSound("Necro.Wave")
	}




	$.Schedule( 9.55, function(){ 
		  event.RemoveClass("upgrade_creeps_event");
           event.AddClass("upgrade_creeps_close");
	 })
	event.DeleteAsync( 10 );
}







function patrol_vision(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("UpgradeCreeps")



	let event = $.CreatePanel("Panel",Main,"event")
	event.AddClass("upgrade_creeps_event")



	let event_text_main = $.CreatePanel("Panel",event,"event")
	event_text_main.AddClass("upgrade_creeps_main")

	let portrait = $.CreatePanel("Panel",event,"portrait")
	portrait.AddClass("upgrade_creeps_portrait")
	portrait.style.backgroundImage = "url('file://{images}/custom_game/Third_Eye.png')"
	portrait.style.backgroundSize = "contain"


	let event_left = $.CreatePanel("Panel",event_text_main,"event_top")
	event_left.AddClass("upgrade_creeps_left")

	let event_mid = $.CreatePanel("Panel",event_text_main,"event_top")
	event_mid.AddClass("upgrade_creeps_mid")




	let hero_2 = $.CreatePanel("Panel",event_left,"portrait")
	hero_2.AddClass("upgrade_creeps_icon")
	hero_2.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.hero + '.png" );'
	hero_2.style.backgroundSize = "contain"



	let text = $.CreatePanel("Label",event_mid,"text_skill")
	text.html = true
	text.AddClass("upgrade_creeps_text")
	text.text = $.Localize("#global_vision_text")


	Game.EmitSound("Patrol.Global_vision")
	


	$.Schedule( 9.55, function(){ 
		  event.RemoveClass("upgrade_creeps_event");
           event.AddClass("upgrade_creeps_close");
	 })
	event.DeleteAsync( 10 );
}











function TargetAttack(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("TargetAlert")


	let event = $.CreatePanel("Panel",Main,"TargetAlert")
	event.AddClass("TargetAlert_event")


	
		Game.EmitSound("Hunt.Start")



	let event_left = $.CreatePanel("Panel",event,"event_left")
	event_left.AddClass("TargetAlert_left_label")


	let event_right = $.CreatePanel("Panel",event,"event_right")
	event_right.AddClass("TargetAlert_right_label")


	let hero_icon = $.CreatePanel("Panel",event_right,"portrait")
	hero_icon.AddClass("TargetAlert_portrait")
    hero_icon.style.backgroundImage = 'url( "file://{images}/heroes/' + kv.hero + '.png" );'
   hero_icon.style.backgroundSize = 'contain';
   hero_icon.style.backgroundRepeat = 'no-repeat'


	let target_shadow = $.CreatePanel("Panel",event_right,"Target")
	target_shadow.AddClass("TargetAlert_portrait_target_shadow")

	let target = $.CreatePanel("Panel",event_right,"Target")
	target.AddClass("TargetAlert_portrait_target")



	let text = $.CreatePanel("Label",event_left,"text_skill")
	text.html = true
	text.AddClass("target_text")
	text.text = $.Localize("#Hunt_Start")



	$.Schedule( 9.55, function(){ 
		  event.RemoveClass("TargetAlert_event");
           event.AddClass("TargetAlert_event_close");
	 })
	event.DeleteAsync( 10);
}









function random_talent_alert(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("random_talent_alert")

	let event = Main.FindChildTraverse("RandomTalentAlert")
	let bot = Main.FindChildTraverse("RandomTalentAlert_bot")
	let first = false

	if (!event)
	{
		Game.EmitSound("powerup_03")

		event = $.CreatePanel("Panel",Main,"RandomTalentAlert")
		event.AddClass("random_talent_alert_event")


		let top = $.CreatePanel("Panel",event,"")
		top.AddClass("random_talent_alert_top")

		let text = $.CreatePanel("Label",top,"")
		text.html = true

		text.AddClass("random_talent_alert_text")
		text.text = $.Localize("#random_talents")

		bot = $.CreatePanel("Panel",event,"RandomTalentAlert_bot")
		bot.AddClass("random_talent_alert_bot")

		first = true
	}

	let hero = kv.hero
	let data = Game.FindUpgradeByName(hero, kv.skill)
	let type = data[2]

	let skill_icon = $.CreatePanel("Panel",bot,"")
	skill_icon.AddClass("random_talent_alert_icon")

	if (first == true)
	{

		if (data[3] == "gray")
		{

			skill_icon.AddClass("random_talent_alert_icon_first_gray")
		}else 
		{

			skill_icon.AddClass("random_talent_alert_icon_first")
		}
	}


	let show_text = ""

	if (type == 1) {
		if (Game.UpgradeMatchesRarity(data, "orange")) {
			skill_icon.style.backgroundImage = 'url( "file://{images}/custom_game/icons/mini/' + hero + '/' + data[6] + '.png" );'
			skill_icon.style.boxShadow = "fill #f29400 0px 0px 2px 1px"
		} else
		{
			skill_icon.style.backgroundImage = 'url( "file://{images}/custom_game/icons/mini/' + hero + '/' + data[9] + '.png" );'
			skill_icon.style.backgroundSize = "100%";

		}

		show_text = $.Localize("#talent_disc_" + data[1] + "_0")
	}
	if ( (type == 0)||(type == 2) ) {
		skill_icon.style.backgroundImage = 'url( "file://{images}/custom_game/icons/mini/general/' + data[6] + '.png" );'
		skill_icon.style.backgroundSize = "100%";

		show_text = $.Localize("#upgrade_disc_" + data[1] + "_3")
	}	

	if (data[3] == "gray")
	{
		show_text = '+' + String(Math.trunc(data[8] )) + $.Localize('#talent_disc_' + data[1])

	}


	if (data[3] == "blue" || data[3] == "gray")
	{
    
		skill_icon.SetPanelEvent('onmouseover', function() {
	    $.DispatchEvent('DOTAShowTextTooltip', skill_icon, show_text )});
	    
		skill_icon.SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', skill_icon); });
	}


	$.Schedule( 11.55, function(){ 
		if (event)
		{
		  event.RemoveClass("random_talent_alert_evente");
          event.AddClass("random_talent_alert_event_close");
	 	}
	 })
	event.DeleteAsync(11.9);
}










function muerta_quest_alert(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("muerta_quest_alert")

	let old = Main.FindChildTraverse("MuertaAlert")
	if (old)
	{
		old.DeleteAsync(0)
	}


	let event = $.CreatePanel("Panel",Main,"MuertaAlert")
	event.AddClass("muerta_quest_alert_event")



	let left = $.CreatePanel("Panel",event,"")
	left.AddClass("muerta_quest_alert_left")



	let text = $.CreatePanel("Label",left,"")
	text.html = true
	text.AddClass("muerta_quest_alert_text")


	let right = $.CreatePanel("Panel",event,"")
	right.AddClass("muerta_quest_alert_right")


	let icon = $.CreatePanel("Panel",right,"")
	icon.AddClass("muerta_quest_alert_icon")


	icon.AddClass("muerta_quest_alert_icon_" + String(kv.type))
	text.text =  $.Localize("#muerta_quest_text_"+ String(kv.type))
	
	if (kv.type == 2)
	{
		Game.EmitSound("Muerta.Quest_Dig_Complete")
		text.text = $.Localize("#muerta_quest_text_"+ String(kv.type)) + String(kv.stack) + '/' + String(kv.max)
	}


	if (kv.type == 1)
	{
		Game.EmitSound("Muerta.Quest_Dig")
	}

	if (kv.type == 4)
	{
		Game.EmitSound("Muerta.Quest_Creep")
	}


	$.Schedule( 7.55, function(){ 
		if (event !== undefined)
		{
		  event.RemoveClass("muerta_quest_alert_event");
          event.AddClass("muerta_quest_alert_event_close");
	 	}
	 })
	event.DeleteAsync( 8);
}




function patrol_refresher(kv)
{


var Main = $.GetContextPanel().FindChildTraverse("patrol_refresher_status_main")

let event = Main.FindChildTraverse("patrol_refresher_status")

if (event)
{
	return
}

let new_event = $.CreatePanel("Panel", Main, "patrol_refresher_status")
new_event.AddClass("patrol_refresher_status") 

let icon_1 = $.CreatePanel("Panel", new_event, "")
icon_1.AddClass("patrol_refresher_status_icon_1") 

let icon_vs = $.CreatePanel("Panel", new_event, "")
icon_vs.AddClass("patrol_refresher_status_icon_vs") 


let icon_2 = $.CreatePanel("Panel", new_event, "")
icon_2.AddClass("patrol_refresher_status_icon_2") 


icon_1.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.hero_1 + '.png" );'
icon_1.style.backgroundSize = "contain"


$.Schedule( 6.5, function(){ 
	if (new_event !== undefined)
	{
	  new_event.RemoveClass("patrol_refresher_status");
    new_event.AddClass("patrol_refresher_status_close");
 	}
 })
new_event.DeleteAsync(6.8);

}









function legion_duel_alert(kv)
{


var Main = $.GetContextPanel().FindChildTraverse("legion_duel_alert")

let old = Main.FindChildTraverse("LegionDuel")
if (old)
{
	old.DeleteAsync(0)
}


let event = $.CreatePanel("Panel",Main,"LegionDuel")
event.AddClass("legion_duel_alert_event")

let left = $.CreatePanel("Panel", event,"")
left.AddClass("legion_duel_alert_left")


let left_top = $.CreatePanel("Panel", left,"")
left_top.AddClass("legion_duel_alert_left_top")


let left_bot = $.CreatePanel("Panel", left,"")
left_bot.AddClass("legion_duel_alert_left_bot")


let right = $.CreatePanel("Panel", event,"")
right.AddClass("legion_duel_alert_right")

let icon = $.CreatePanel("Panel", right,"")
icon.AddClass("legion_duel_alert_icon")

let text_top = $.CreatePanel("Label",left_top,"")
text_top.html = true
text_top.AddClass("legion_duel_alert_text_top")

text_top.text = $.Localize("#legion_duel_alert_1")

let text_bot = $.CreatePanel("Label",left_bot,"")
text_bot.html = true
text_bot.AddClass("legion_duel_alert_text_bot")

text_bot.text = $.Localize("#legion_duel_alert_2")


$.Schedule( 7.5, function(){ 
	if (event !== undefined)
	{
	  event.RemoveClass("legion_duel_alert_event");
    event.AddClass("legion_duel_alert_close");
 	}
 })
event.DeleteAsync( 7.8);
}




function legion_duel_status(kv)
{


var Main = $.GetContextPanel().FindChildTraverse("legion_duel_alert")
let old = Main.FindChildTraverse("LegionDuel")
if (old)
{
	return
}

let status_main = $.GetContextPanel().FindChildTraverse("legion_duel_status_main")
let event = status_main.FindChildTraverse("legion_duel_status")


if (event)
{
	return
}

let new_event = $.CreatePanel("Panel", status_main, "legion_duel_status")
new_event.AddClass("legion_duel_status") 

let icon_1 = $.CreatePanel("Panel", new_event, "")
icon_1.AddClass("legion_duel_status_icon_1") 

let icon_vs = $.CreatePanel("Panel", new_event, "")
icon_vs.AddClass("legion_duel_status_icon_vs") 


let icon_2 = $.CreatePanel("Panel", new_event, "")
icon_2.AddClass("legion_duel_status_icon_2") 


icon_1.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.hero_1 + '.png" );'
icon_1.style.backgroundSize = "contain"

icon_2.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + kv.hero_2 + '.png" );'
icon_2.style.backgroundSize = "contain"
}


function legion_duel_status_end(kv)
{



let status_main = $.GetContextPanel().FindChildTraverse("legion_duel_status_main")
let event = status_main.FindChildTraverse("legion_duel_status")



if (!event || (event == undefined))
{
	return
}

event.RemoveClass("legion_duel_status");
event.AddClass("legion_duel_status_close");

event.DeleteAsync( 0.4);

}








function grenade_alert(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("grenade_alert")


	let event = $.CreatePanel("Panel",Main,"TargetAlert")
	event.AddClass("grenade_alert_event")


	Game.EmitSound("Patrol.Sound")


	let left = $.CreatePanel("Panel",event,"")
	left.AddClass("grenade_alert_left")

	let icon = $.CreatePanel("Panel",left,"")
	icon.AddClass("grenade_alert_icon")

	let right = $.CreatePanel("Panel",event,"")
	right.AddClass("grenade_alert_right")

	let text = $.CreatePanel("Label",right,"")
	text.html = true
	text.AddClass("grenade_alert_text")
	text.text =  $.Localize("#Grenade_alert")


	$.Schedule( 7.55, function(){ 
		  event.RemoveClass("grenade_alert_event");
           event.AddClass("grenade_alert_event_close");
	 })
	event.DeleteAsync( 8);
}







function destroy_tower(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("DesroyTower")


	let event = $.CreatePanel("Panel",Main,"TargetAlert")
	event.AddClass("DesroyTower_event")


	Game.EmitSound("Patrol.Sound")


	let left = $.CreatePanel("Panel",event,"")
	left.AddClass("DesroyTower_left")

	let icon = $.CreatePanel("Panel",left,"")
	icon.AddClass("DesroyTower_icon")

	let right = $.CreatePanel("Panel",event,"")
	right.AddClass("DesroyTower_right")

	let text = $.CreatePanel("Label",right,"")
	text.html = true
	text.AddClass("DesroyTower_text")
	text.text =  $.Localize("#DesroyTower")


	$.Schedule( 7.55, function(){ 
		  event.RemoveClass("DesroyTower_event");
           event.AddClass("DesroyTower_event_close");
	 })
	event.DeleteAsync( 8);
}

















function PatrolAlert(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("PatrolAlert")


	let event = $.CreatePanel("Panel",Main,"TargetAlert")
	event.AddClass("PatrolAlert_event")


	Game.EmitSound("Patrol.Sound")



	let patrol_top = $.CreatePanel("Panel",event,"event_left")
	patrol_top.AddClass("patrol_top")

	let text = $.CreatePanel("Label",patrol_top,"")
	text.html = true
	text.AddClass("TargetTimer_mid_text")

	let style = "patrol_bot_item"

	if (kv.number == 1) 
	{
		text.text =  $.Localize("#Patrol_first")
	}
	else 
	{
		style = "patrol_bot_item_2"
		text.text =  $.Localize("#Patrol_second")
	}


	let patrol_bot = $.CreatePanel("Panel",event,"event_right")
	patrol_bot.AddClass("patrol_bot")


	let patrol_bot_content = $.CreatePanel("Panel",patrol_bot,"event_right")
	patrol_bot_content.AddClass("patrol_bot_content")



	let patrol_bot_item1 = $.CreatePanel("DOTAItemImage",patrol_bot_content,"")
	patrol_bot_item1.itemname = kv.items[1]
	patrol_bot_item1.AddClass(style)

	let patrol_bot_item2 = $.CreatePanel("DOTAItemImage",patrol_bot_content,"")
	patrol_bot_item2.itemname = kv.items[2]
	patrol_bot_item2.AddClass(style)

	let patrol_bot_item3 = $.CreatePanel("DOTAItemImage",patrol_bot_content,"")
	patrol_bot_item3.itemname = kv.items[3]
	patrol_bot_item3.AddClass(style)

	let patrol_bot_item4 = $.CreatePanel("DOTAItemImage",patrol_bot_content,"")
	patrol_bot_item4.itemname = kv.items[4]
	patrol_bot_item4.AddClass(style)

	let patrol_bot_item5 = $.CreatePanel("DOTAItemImage",patrol_bot_content,"")
	patrol_bot_item5.itemname = kv.items[5]
	patrol_bot_item5.AddClass(style)

	if (kv.number !== 1) 
	{


		let patrol_bot_item6 = $.CreatePanel("DOTAItemImage",patrol_bot_content,"")
		patrol_bot_item6.itemname = kv.items[6]
		patrol_bot_item6.AddClass(style)
	}


	$.Schedule( 9.55, function(){ 
		  event.RemoveClass("PatrolAlert_event");
           event.AddClass("PatrolAlert_event_close");
	 })
	event.DeleteAsync( 10);
}



function TargetTimer(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("TargetTimer")


	let body = $.CreatePanel("Panel",Main,"TargetTimer_main")
	body.AddClass("TargetTimer_main")


	body.SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowTextTooltip', body, $.Localize("#Hunt_Tip")) });
    
	body.SetPanelEvent('onmouseout', function() {
    $.DispatchEvent('DOTAHideTextTooltip', body); });


	let top = $.CreatePanel("Panel",body,"TargetTimer")
	top.AddClass("TargetTimer_top")


	let hero = $.CreatePanel("Panel",top,"TargetTimer")
	hero.AddClass("TargetTimer_top_hero")

	let target_shadow = $.CreatePanel("Panel",top,"TargetTimer")
	target_shadow.AddClass("TargetTimer_top_shadow")
	let target = $.CreatePanel("Panel",top,"TargetTimer")
	target.AddClass("TargetTimer_top_target")


  hero.style.backgroundImage = 'url( "file://{images}/heroes/' + kv.hero + '.png" );'
  hero.style.backgroundSize = 'contain';
  hero.style.backgroundRepeat = 'no-repeat'


	let mid = $.CreatePanel("Panel",body,"TargetTimer")
	mid.AddClass("TargetTimer_mid")
   

	var time = kv.time

	var min = Math.trunc((time)/60) 
	var sec_n =  (time) - 60*Math.trunc((time)/60) 

	var hour = String( Math.trunc((min)/60) )

	var min = String(min - 60*( Math.trunc(min/60) ))

	var sec = String(sec_n)
	if (sec_n < 10) 
	{
		sec = '0' + sec

	}




	let timer = $.CreatePanel("Label",mid,"text_target_timer")
	timer.html = true
	timer.AddClass("TargetTimer_mid_text")
	timer.text =  $.Localize("#Hunt_time") +  min + ':' + sec


	let purple = $.CreatePanel("Panel",body,"TargetTimer")
	purple.AddClass("TargetTimer_epic")


	let damage_text = $.CreatePanel("Label",purple,"text_skill")
	damage_text.html = true
	damage_text.AddClass("TargetTimer_damage_text")
	damage_text.text = '+25%'+ $.Localize("#Hunt_damage")
	let gold = $.CreatePanel("Panel",body,"TargetTimer")
	gold.AddClass("TargetTimer_epic")



	if (kv.is_target == 1) 
	{

		top.RemoveClass("TargetTimer_top")
		top.AddClass("TargetTimer_top_is_target")
		return
	}
   
	let purple_text = $.CreatePanel("Label",gold,"text_skill")
	purple_text.html = true
	purple_text.AddClass("TargetTimer_epic_text")
	purple_text.text = '1'

	let purple_icon = $.CreatePanel("Panel",gold,"TargetTimer")
	purple_icon.AddClass("TargetTimer_epic_icon")

   
	let gold_text = $.CreatePanel("Label",gold,"text_target_gold")
	gold_text.html = true
	gold_text.AddClass("TargetTimer_gold_text")
	gold_text.text = String(kv.gold)

	let gold_icon = $.CreatePanel("Panel",gold,"TargetTimer")
	gold_icon.AddClass("TargetTimer_gold_icon")



}


function TargetTimer_change(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("TargetTimer")
	var timer = Main.FindChildTraverse("text_target_timer")
	if (timer) 
	{
		var time = kv.time

		var min = Math.trunc((time)/60) 
		var sec_n =  (time) - 60*Math.trunc((time)/60) 

		var hour = String( Math.trunc((min)/60) )

		var min = String(min - 60*( Math.trunc(min/60) ))

		var sec = String(sec_n)
		if (sec_n < 10) 
		{
			sec = '0' + sec

		}
		timer.text =  $.Localize("#Hunt_time") +  min + ':' + sec
	}

	if (kv.is_target == 1) return


	let gold_text = Main.FindChildTraverse("text_target_gold")
	if (gold_text) 
	{
		gold_text.text = String(kv.gold)
	}

}


function TargetTimer_delete(kv)
{


	var Main = $.GetContextPanel().FindChildTraverse("TargetTimer")
	var timer = Main.FindChildTraverse("TargetTimer_main")
	if (timer) 
	{
		timer.RemoveClass("TargetTimer_main")
		timer.AddClass("TargetTimer_main_close")
		timer.DeleteAsync(0.45)
	}



}





function RatingAlert()
{

	var Main = $.GetContextPanel().FindChildTraverse("RatingAlert")

	Main.RemoveClass("RatingAlert")
	Main.AddClass("RatingAlert_show")


//Main.SetPanelEvent("onactivate", function() {

       // $.DispatchEvent("ExternalBrowserGoToURL", "https://dota1x6.com/");
    //});
	var TopLabel =  $.CreatePanel("Panel",Main,'')
	TopLabel.AddClass("Rating_TopLabel")

	let TopLabel_text = $.CreatePanel("Label",TopLabel,"")
	TopLabel_text.html = true
	TopLabel_text.AddClass("Rating_Text")
	TopLabel_text.text = $.Localize("#Rating_top")


	var MidLabel =  $.CreatePanel("Panel",Main,'')
	MidLabel.AddClass("Rating_MidLabel")

	let MidLabel_text = $.CreatePanel("Label",MidLabel,"")
	MidLabel_text.html = true
	MidLabel_text.AddClass("Rating_Text_mid")
	MidLabel_text.text = $.Localize("#Rating_middle")

	let MidLabel1x6_text = $.CreatePanel("Label",MidLabel,"")
	MidLabel1x6_text.html = true
	MidLabel1x6_text.AddClass("Rating_Text_underline")
	MidLabel1x6_text.text = $.Localize("#Rating_dota1x6")


	var BotLabel =  $.CreatePanel("Panel",Main,'')
	BotLabel.AddClass("Rating_BotLabel")

	let BotLabel_text = $.CreatePanel("Label",BotLabel,"")
	BotLabel_text.html = true
	BotLabel_text.AddClass("Rating_Text_bot")
	BotLabel_text.text = $.Localize("#Rating_bottom")


    Main.SetPanelEvent('onmouseover', function() {
    	MidLabel1x6_text.RemoveClass("Rating_Text_underline")
    	MidLabel1x6_text.AddClass("Rating_Text_underline_in")
    })

    Main.SetPanelEvent('onmouseout', function() {
    	MidLabel1x6_text.RemoveClass("Rating_Text_underline_in")
    	MidLabel1x6_text.AddClass("Rating_Text_underline")
    	
    })


	$.Schedule( 11.65, function(){ 
		Main.RemoveClass("RatingAlert_show")
		Main.AddClass("RatingAlert_hide")
	 })
	Main.DeleteAsync(12)
}





function patrol_count(kv)
{
	let Main =  $.GetContextPanel().FindChildTraverse("Patrol")
	let Count_Main = Main.FindChildTraverse("Patrol_Count")
	let Bar_fill = Main.FindChildTraverse("Patrol_fill")
	let Bar_text = Main.FindChildTraverse("Patrol_text")

	if (!Count_Main)
	{
		Count_Main = $.CreatePanel("Panel",Main,'Patrol_Count')
		Count_Main.AddClass("Patrol_count_show")

		let Icon = $.CreatePanel("Panel",Count_Main,'')
		Icon.AddClass("Patrol_Icon")

		let text = $.Localize("#Patrol_meteor")

		Icon.SetPanelEvent('onmouseover', function() {
	    $.DispatchEvent('DOTAShowTextTooltip', Icon, text) });
	    
		Icon.SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', Icon); });


		let Bar = $.CreatePanel("Panel",Count_Main,'')
		Bar.AddClass("Patrol_bar")

		Bar_fill = $.CreatePanel("Panel",Bar,'Patrol_fill')
		Bar_fill.AddClass("Patrol_Fill")

		Bar_text = $.CreatePanel("Label",Bar,"Patrol_text")
		Bar_text.html = true
		Bar_text.AddClass("Patrol_text")

	}

	let width = (String(kv.count)/String(kv.max))*100
	Bar_fill.style.width = String(width) + '%';

	Bar_text.text = String(kv.count) + '/' + String(kv.max)


	if (kv.count == 0) 	
	{
		
		Count_Main.RemoveClass("Patrol_count_show")
		Count_Main.AddClass("Patrol_count_hide")

		Count_Main.DeleteAsync(0.5)
	}

}







function patrol_timer(kv)
{
	let Main =  $.GetContextPanel().FindChildTraverse("Patrol_timer")
	let Timer_Main = Main.FindChildTraverse("Patrol_Timer_main")
	let Timer_text = Main.FindChildTraverse("Patrol_timer_text")

	if (!Timer_Main)
	{
		Timer_Main = $.CreatePanel("Panel",Main,'Patrol_Timer_main')
		Timer_Main.AddClass("Patrol_timer_show")

		Timer_text = $.CreatePanel("Label",Timer_Main,"Patrol_timer_text")
		Timer_text.html = true
		Timer_text.AddClass("Patrol_timer_text")

	}


	Timer_text.text = $.Localize("#Patrol_timer") + String(kv.time)


	if (kv.time == 0) 	
	{
		
		Timer_Main.RemoveClass("Patrol_timer_show")
		Timer_Main.AddClass("Patrol_timer_hide")

		Timer_Main.DeleteAsync(0.5)
	}

}




function SwapPickOrbs()
{

	Game.EmitSound("UI.Click")



	GameEvents.SendCustomGameEventToServer_custom("ChangePickOrbs", {})
}

function ChangePickOrbs_js(kv)
{
	let button = $.GetContextPanel().FindChildTraverse("SwapPickOrbs")
	if (button)
	{
		if (kv.pick == 1)
		{
			button.RemoveClass("SwapPickOrbs")
			button.AddClass("SwapPickOrbs_active")
		}else 
		{

			button.RemoveClass("SwapPickOrbs_active")
			button.AddClass("SwapPickOrbs")
		}
	}
}







init()