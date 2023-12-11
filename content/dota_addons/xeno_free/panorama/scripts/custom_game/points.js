var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);

Hack()

function Hack()
{



	var parentHUDElements = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("QuickBuyRows");
	var stash = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("stash_bg");
	var Row = parentHUDElements.FindChildTraverse("Row1")
	var Info = $.GetContextPanel().FindChildTraverse("AllPointsAndInfo");

	var minimap = $.GetContextPanel().GetParent().GetParent().FindChildTraverse("HUDElements").GetParent()


	var Dota1x6 = $.GetContextPanel().FindChildTraverse("Dota1x6")

	if ((Game.IsHUDFlipped()) && (Info.BHasClass("AllPointsAndInfo")))
	{	

		Info.RemoveClass("AllPointsAndInfo")
		Info.AddClass("AllPointsAndInfo_left")
	}

	if (( !Game.IsHUDFlipped() ) && (Info.BHasClass("AllPointsAndInfo_left")))
	{
		Info.RemoveClass("AllPointsAndInfo_left")
		Info.AddClass("AllPointsAndInfo")
	}

	if (minimap.BHasClass("MinimapExtraLarge"))
	{

		Dota1x6.RemoveClass("Dota1x6_small")
		Dota1x6.AddClass("Dota1x6_large")
	}else 
	{

		Dota1x6.RemoveClass("Dota1x6_large")
		Dota1x6.AddClass("Dota1x6_small")
	}



	if ((Game.IsHUDFlipped()) && (Dota1x6.BHasClass("Dota1x6")))
	{	

		Dota1x6.RemoveClass("Dota1x6")
		Dota1x6.AddClass("Dota1x6_right")
	}

	if (( !Game.IsHUDFlipped() ) && (Dota1x6.BHasClass("Dota1x6_right")))
	{
		Dota1x6.RemoveClass("Dota1x6_right")
		Dota1x6.AddClass("Dota1x6")
	}




	var bonus = 0
	var margin = 0

	

	if (Row.visible)
	{	
		margin = 62.3
		bonus = 3
	}
	else
	{
		margin = 65.5
		bonus = 0
	}

	if (stash.visible)
	{	
		margin = 49.3 - bonus
	}

	var text = String(margin) + '%'
	Info.style.marginTop = text



   $.Schedule(0.3, Hack)
	
}







function init()
{
	GameEvents.Subscribe_custom('kill_progress', OnKill)

	GameEvents.Subscribe_custom('hero_quest_init', hero_quest_init)
	GameEvents.Subscribe_custom('hero_quest_complete', hero_quest_complete)
	GameEvents.Subscribe_custom('hero_quest_update', hero_quest_update)

	GameEvents.Subscribe_custom('grenade_count_change', grenade_count_change)

	var Info = $.GetContextPanel().FindChildTraverse("ButtonInfo");
 	var text = $.Localize('#talent_disc_upgrade_info')

	Info.SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowTextTooltip', Info, text) });
    
Info.SetPanelEvent('onmouseout', function() {
    $.DispatchEvent('DOTAHideTextTooltip', Info);
});

}

init();





function OnKill( kv )
{
	$.Msg('qqqqq')

	 BPoints = kv.blue
	 PPoints = kv.purple
	 max = kv.max
	 max_p = kv.max_p

	var BluePoints = $.GetContextPanel().FindChildTraverse("BluePoints");

	var BlueProgress = $.GetContextPanel().FindChildTraverse("BlueProgress");

	var BlueNumber = $.GetContextPanel().FindChildTraverse("BlueNumber");


	var PurplePoints = $.GetContextPanel().FindChildTraverse("PurplePoints");

	var PurpleProgress = $.GetContextPanel().FindChildTraverse("PurpleProgress");

	var PurpleNumber = $.GetContextPanel().FindChildTraverse("PurpleNumber");



	var Info = $.GetContextPanel().FindChildTraverse("ButtonInfo");


	var text = ""
	var number = 0
	var prev = 0 

	text = String(BPoints) + "/" + String(max) 

	prev = Number(BlueNumber.text)

	BlueNumber.text = text






	if (prev > Number(BlueNumber.text)) 

	{
		 BlueProgress.RemoveClass("Progress")
		BlueProgress.AddClass("ProgressFull")
		BlueProgress.style.width = "0%"
        BlueProgress.RemoveClass("ProgressFull")
		BlueProgress.AddClass("Progress")


	}

	number = (BPoints/max) * 95
	text = String(number)+'%'

	BlueProgress.style.width = text


	text = String(PPoints) + "/" + String(max_p) 

	prev = Number(PurpleNumber.text)

	PurpleNumber.text = text






	if (prev > Number(PurpleNumber.text)) 

	{
		 PurpleProgress.RemoveClass("Progress")
		PurpleProgress.AddClass("ProgressFull")
		PurpleProgress.style.width = "0%"
        PurpleProgress.RemoveClass("ProgressFull")
		PurpleProgress.AddClass("Progress")


	}

	number = (PPoints/max_p) * 95
	text = String(number)+'%'

	PurpleProgress.style.width = text



		
}




function grenade_count_change(kv)
{
  let main = $.GetContextPanel().FindChildTraverse("Grenade_count")
  if (main.BHasClass("Grenade_count_hidden"))
  {
    main.RemoveClass("Grenade_count_hidden")
   
    main.AddClass("Grenade_count")
  }

  if (kv.inc == 1)
  {
  	Game.EmitSound("UI.Grenade_Gain")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Grenade_count_Filler")

  let width = (kv.count/kv.max) * 96
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Grenade_count_Number")
  number.text = String(kv.count)

  var text1 = $.Localize("#Grenade_count_text")

	main.SetPanelEvent('onmouseover', function() {
   $.DispatchEvent('DOTAShowTextTooltip', main, text1) });
    
	main.SetPanelEvent('onmouseout', function() {
   $.DispatchEvent('DOTAHideTextTooltip', main); });
}


function roundPlus(x, n) { //x - число, n - количество знаков

	if (isNaN(x) || isNaN(n)) return false;

	var m = Math.pow(10, n);

	return Math.round(x * m) / m;

}


function hero_quest_init(kv)
{
	let main = $.GetContextPanel().FindChildTraverse("HeroQuest")

	let goal = kv.goal
	let progress = 0
	let icon = kv.icon
	let exp = kv.exp
	let shards = kv.shards
	let name = kv.name

	if (main.BHasClass("HeroQuest_hidden"))
	{
		main.RemoveClass("HeroQuest_hidden")
	}

	let icon_panel = $.GetContextPanel().FindChildTraverse("HeroQuest_icon")

	let text_panel = $.GetContextPanel().FindChildTraverse("HeroQuest_text")

	icon_panel.style.backgroundImage = "url('file://{images}/custom_game/icons/skills/" + icon + ".png')"
	icon_panel.style.backgroundSize = "contain"

	let goal_text = String(goal)
	let progress_text = String(progress)

	if (goal >= 10000)
	{
		goal_text = String(Math.floor(goal/1000)) + 'k'

		if (progress > 0)
		{
			progress_text = String((progress/1000).toFixed(1)) + 'k'
		}
	}

	text_panel.text = progress_text + '/' + goal_text


	let place = ""
	if (!kv.legendary)
	{
		place = '<br><br>' + $.Localize("#QuestDiscWin")
	}

	let text_info = $.Localize('#' + name) + '<br><br>' + $.Localize('#QuestReward') + "<b><font color='#53ea48'>" + String(shards) + "</font></b>" + $.Localize('#QuestReward2') + "<b><font color='#53ea48'>" + String(exp) + "</font></b>" + $.Localize('#QuestReward3') + place


	main.SetPanelEvent('onmouseover', function() {
    $.DispatchEvent('DOTAShowTextTooltip', main, text_info) });
    
	main.SetPanelEvent('onmouseout', function() {
    $.DispatchEvent('DOTAHideTextTooltip', main)});
}



function hero_quest_complete(kv)
{
	let main = $.GetContextPanel().FindChildTraverse("HeroQuest")

	if (main.BHasClass("HeroQuest_hidden"))
	{
		main.RemoveClass("HeroQuest_hidden")
	}


	Game.EmitSound("UI.Quest_Complete")

	let icon_panel = $.GetContextPanel().FindChildTraverse("HeroQuest_icon")
	icon_panel.AddClass("HeroQuest_complete")

	let text_panel = $.GetContextPanel().FindChildTraverse("HeroQuest_text_panel")
	text_panel.style.visibility = "collapse"

	main.style.width = "22.5%";


}


function hero_quest_update(kv)
{
	let main = $.GetContextPanel().FindChildTraverse("HeroQuest")

	if (main.BHasClass("HeroQuest_hidden"))
	{
		main.RemoveClass("HeroQuest_hidden")
	}

	if (kv.inc == 0)
	{

	let icon_panel = $.GetContextPanel().FindChildTraverse("HeroQuest_icon")

		icon_panel.style.backgroundImage = "url('file://{images}/custom_game/icons/skills/" + kv.icon + ".png')"
		icon_panel.style.backgroundSize = "contain"
	}

	let goal = kv.goal
	let progress = kv.progress


	if (progress% 1 != 0)
	{
		progress = progress.toFixed(1)
	}



	let text_panel = $.GetContextPanel().FindChildTraverse("HeroQuest_text")

	let goal_text = String(goal)
	let progress_text = String(progress)


	if (goal >= 10000)
	{
		goal_text = String(Math.floor(goal/1000)) + 'k'

		if (progress > 0)
		{
			progress_text = String((progress/1000).toFixed(1)) + 'k'
		}
	}

	text_panel.text = progress_text + '/' + goal_text
}