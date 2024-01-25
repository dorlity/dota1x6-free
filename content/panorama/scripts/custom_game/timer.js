var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);

function init()
{

	GameEvents.Subscribe_custom('timer_progress', OnTimer)

	//GameEvents.Subscribe_custom('PreGameEnd', ShowTimer)

	GameEvents.Subscribe_custom('duel_timer_progress', OnDuelTimer)

	var HeaderText = $.GetContextPanel().FindChildTraverse("DuelHeaderText");
	HeaderText.text = "РАУНД 1"

	var DuelText = $.GetContextPanel().FindChildTraverse("DuelTimerText");
	DuelText.text = "1:00"



	var GoldIcon = $.GetContextPanel().FindChildTraverse("GoldIcon");
	var MkbIcon = $.GetContextPanel().FindChildTraverse("MkbIcon");
	var Necro = $.GetContextPanel().FindChildTraverse("NecroWave");

	 var text = $.Localize('#talent_disc_gold_info')

		GoldIcon.SetPanelEvent('onmouseover', function() {
	    $.DispatchEvent('DOTAShowTextTooltip', GoldIcon, text) });
	    
		GoldIcon.SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', GoldIcon);
	});

	 var text_mkb = $.Localize('#talent_disc_Mkb_info')

		MkbIcon.SetPanelEvent('onmouseover', function() {
	    $.DispatchEvent('DOTAShowTextTooltip', MkbIcon, text_mkb) });
	    
		MkbIcon.SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', MkbIcon);
	});


	 var text_necro = $.Localize('#necro_wave_tip')

		Necro.SetPanelEvent('onmouseover', function() {
	    $.DispatchEvent('DOTAShowTextTooltip', Necro, text_necro) });
	    
		Necro.SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', Necro);
	});

}

init();

function ShowTimer()
{
	let main = $.GetContextPanel().FindChildTraverse("AllTimer")

	if (main && main.BHasClass("Timer_hidden"))
	{
		main.RemoveClass("Timer_hidden")
		main.RemoveClass("Timer_hide")
		main.AddClass("Timer_show")


	}
}


function MouseOver( panel , skill)
{
	panel.SetPanelEvent('onmouseover', function() {
		$.DispatchEvent('DOTAShowAbilityTooltip', panel, skill) 
	});

	panel.SetPanelEvent('onmouseout', function() {
		$.DispatchEvent('DOTAHideAbilityTooltip', panel);
	});

}





function HideTimer()
{

	let main = $.GetContextPanel().FindChildTraverse("AllTimer")

	if (main && main.BHasClass("Timer_show"))
	{
		main.RemoveClass("Timer_show")
		main.AddClass("Timer_hide")

		$.Schedule(0.7, function ()
		{ 
			main.AddClass("Timer_hidden")
		})
	}

}



function HideDuelTimer()
{

	let main = $.GetContextPanel().FindChildTraverse("AllDuelTimer")

	if (main && main.BHasClass("Timer_show"))
	{
		main.RemoveClass("Timer_show")
		main.AddClass("Timer_hide")


		$.Schedule(0.7, function ()
		{ 
			main.AddClass("Timer_hidden")
		})
	}

}


function ShowDuelTimer()
{

	let main = $.GetContextPanel().FindChildTraverse("AllDuelTimer")

	if (main && main.BHasClass("Timer_hidden"))
	{
		main.RemoveClass("Timer_hide")
		main.RemoveClass("Timer_hidden")
		main.AddClass("Timer_show")

	}

}



function OnTimer( kv )
{
	let units = kv.units
	let units_max = kv.units_max
	let time = kv.time
	let max = kv.max
	let name = kv.name
	let skills = kv.skills 
	let  reward = kv.reward
	let  nwave = kv.number 
	let gold = kv.gold
	let mkb = kv.mkb
	let necro = kv.necro
	let upgrade = kv.upgrade


	let hide = kv.game_start 

	if (hide == 1)
	{
		HideDuelTimer()
		ShowTimer()
	}



	


	var Timer = $.GetContextPanel().FindChildTraverse("TimerTime");
	var TimerText = $.GetContextPanel().FindChildTraverse("TimerText");
	var EncounterSkill = $.GetContextPanel().FindChildTraverse("EncounterSkill");
	var SkillText = $.GetContextPanel().FindChildTraverse("EncounterSkillText");
	var WaveText = $.GetContextPanel().FindChildTraverse("WaveName_Text");
	var WaveNumber = $.GetContextPanel().FindChildTraverse("WaveNumber_Text");
	var WaveNumberBlock = $.GetContextPanel().FindChildTraverse("WaveNumber");
	var RewardIcon = $.GetContextPanel().FindChildTraverse("RewardIcon");
	var GoldIcon = $.GetContextPanel().FindChildTraverse("GoldIcon");
	var MkbIcon = $.GetContextPanel().FindChildTraverse("MkbIcon");

	var Necro = $.GetContextPanel().FindChildTraverse("NecroWave")
	var Upgrade = $.GetContextPanel().FindChildTraverse("UpgradeWave")



	if (necro == true)
	{
		Necro.style.visibility = "visible"
	} else 
	{
		Necro.style.visibility = "collapse"
	}


	if (upgrade > 0)
	{
		Upgrade.style.visibility = "visible"
		var UpgradeText  = $.GetContextPanel().FindChildTraverse("UpgradeWaveText")
		if (UpgradeText)
		{
			UpgradeText.text = upgrade
		}

		var text_up = $.Localize('#upgrade_creeps_text') + String(upgrade)*8 + '%'

		//Upgrade.SetPanelEvent('onmouseover', function() {
	  //  $.DispatchEvent('DOTAShowTextTooltip', Upgrade, text_up) });
	    
		Upgrade.SetPanelEvent('onmouseout', function() {
	    $.DispatchEvent('DOTAHideTextTooltip', Upgrade) });


	} else 
	{
		//Upgrade.style.visibility = "collapse"
	}


	if (gold == true)
	{
		GoldIcon.style.visibility = "visible"
	} else 
	{
		GoldIcon.style.visibility = "collapse"
	}

	if (mkb == 1)
	{
		MkbIcon.style.visibility = "visible"
	} else 
	{
		MkbIcon.style.visibility = "collapse"
	}

	var SkillIcons = $.GetContextPanel().FindChildTraverse("SkillIcons");


	var SkillText = $.GetContextPanel().FindChildTraverse("EncounterSkillText");
	//SkillText.text = $.Localize("#wave_skills")

	var RewardText = $.GetContextPanel().FindChildTraverse("RewardText");


	WaveNumberBlock.RemoveClass("WaveNumber_normal")
	WaveNumberBlock.RemoveClass("WaveNumber_purple")
	WaveNumberBlock.RemoveClass("WaveNumber_orange")


	WaveNumberBlock.AddClass("WaveNumber_normal")


	if (reward !== 0)
	{
		//RewardText.text = $.Localize("#wave_reward")
		RewardIcon.style.backgroundImage = 'url("file://{images}/custom_game/icons/wave_icons/' + reward + '.png")';
		RewardIcon.style.backgroundSize = "contain";


		if (reward == 4)
		{
			WaveNumberBlock.RemoveClass("WaveNumber_normal")
			WaveNumberBlock.AddClass("WaveNumber_orange")
		}
		if (reward == 3)
		{
			WaveNumberBlock.RemoveClass("WaveNumber_normal")
			WaveNumberBlock.AddClass("WaveNumber_purple")
		}
	}
	else 
	{
	//	RewardText.text = ""
		RewardIcon.style.visibility = "collapse"
	}


	var icon = []
	var b_icon = null 
	var b_text = ''

	for (var i = 1; i <= 4; i++) 

	{
		b_icon = $.GetContextPanel().FindChildTraverse("SkillIcon"+i)
		if (skills[i] != null ) {
		
		b_icon.style.visibility = "visible"
		b_icon.abilityname = skills[i]
		MouseOver(b_icon, skills[i])

	   } else 

	   {


		b_icon.style.visibility = "collapse"

	   }
	}


	if (time > 0) 
	{
		let wave_text = $.Localize('#wave_name')

		WaveText.text =  $.Localize('#wave_name_' + name)

		WaveNumber.text =   String(nwave)

	 

		var text = ''
		var min = String( Math.trunc((max - time)/60) )
		var sec_n =  (max - time) - 60*Math.trunc((max - time)/60)  
		var sec = String(sec_n)
		if (sec_n < 10) 
		{
			sec = '0' + sec

		}

		text = min  + ':' + sec


		TimerText.text = text
		var number = 0
		number = (time/(max-1)) * 100
		text = String(number)+'%'
		TimerText.style.align = 'right center'
		//if (Timer.BHasClass("TimerTimeGreen"))
		//{
			//Timer.RemoveClass("TimerTimeGreen")
			//Timer.AddClass("TimerTimeRed")
		//}

		if (reward !== 0)
		{

			RewardIcon.style.backgroundImage = 'url("file://{images}/custom_game/icons/wave_icons/' + reward + '.png")';
		}
		Timer.style.width = text
	}
	else 
	{	

		WaveText.text =  $.Localize('#wave_name_' + name)
		WaveNumber.text =   String(nwave)

		//if (Timer.BHasClass("TimerTimeRed"))
		//{
			//Timer.RemoveClass("TimerTimeRed")
			//Timer.AddClass("TimerTimeGreen")
		//}

		text = ''
		text = String(units) + '/' + String(units_max)
		
		TimerText.style.align = 'center center'	
		TimerText.text = text

		var number = 0
		number = (units/(units_max)) * 100
		text = String(number)+'%'
		Timer.style.width = text

	}

}	









function OnDuelTimer( kv )
{
	let time = kv.time
	let max = kv.max
	let show = kv.show 
	let stage = kv.stage
	let round = kv.round
	let hero1 = kv.hero1
	let hero2 = kv.hero2 
	let wins1 = kv.wins1
	let wins2 = kv.wins2
	let final_duel = kv.final
	let id1 = kv.id1 
	let id2 = kv.id2

	var text = ''

	let main = $.GetContextPanel().FindChildTraverse("AllTimer")

	if (main && main.BHasClass("Timer_show") && final_duel == 0)
	{	
		$.Schedule(1, function ()
		{ 
			Game.EmitSound("Duel.Normal")
		})
		
	}

	HideTimer()
	ShowDuelTimer()

	var normal = $.GetContextPanel().FindChildTraverse("NormalDuelBot");
	var final = $.GetContextPanel().FindChildTraverse("FinalDuelBot");

	if (final_duel == 0)
	{

		normal.RemoveClass("PanelHidden")
		final.AddClass("PanelHidden")

		var DuelHero = $.GetContextPanel().FindChildTraverse("NormalDuelHeroLeft");
		DuelHero.style.backgroundImage =  'url( "file://{images}/heroes/' +  Game.GetHeroImage(id1 , hero1) + '.png")'
		DuelHero.style.backgroundSize = '100%'

		var DuelHero2 = $.GetContextPanel().FindChildTraverse("NormalDuelHeroRight");
		DuelHero2.style.backgroundImage =  'url( "file://{images}/heroes/' +  Game.GetHeroImage(id2 , hero2) + '.png")'
		DuelHero2.style.backgroundSize = '100%'
	}else 
	{

		normal.AddClass("PanelHidden")
		final.RemoveClass("PanelHidden")

		var DuelHero = $.GetContextPanel().FindChildTraverse("DuelHeroLeft");
		DuelHero.style.backgroundImage =  'url( "file://{images}/heroes/' + Game.GetHeroImage(id1 , hero1) + '.png")'
		DuelHero.style.backgroundSize = '100%'

		var DuelHero2 = $.GetContextPanel().FindChildTraverse("DuelHeroRight");
		DuelHero2.style.backgroundImage =  'url( "file://{images}/heroes/' + Game.GetHeroImage(id2 , hero2) + '.png")'
		DuelHero2.style.backgroundSize = '100%'

		var DuelTextLeft = $.GetContextPanel().FindChildTraverse("DuelTimerTextLeft");
		DuelTextLeft.text = String(wins1)

		var DuelTextRight = $.GetContextPanel().FindChildTraverse("DuelTimerTextRight");
		DuelTextRight.text = String(wins2)

	}



	var HeaderText = $.GetContextPanel().FindChildTraverse("DuelHeaderText");

	if (stage == 1)
	{
		HeaderText.text = $.Localize('#duel_prepair')
	}
	else 
	{
		HeaderText.text = $.Localize('#duel_round') + String(round)
	}

	

	var Timer = $.GetContextPanel().FindChildTraverse("DuelTimerTime");
	var TimerText = $.GetContextPanel().FindChildTraverse("DuelTimerText");


	var DuelText = $.GetContextPanel().FindChildTraverse("DuelTimerText");

	var text = ''
	var min = String( Math.trunc((max - time)/60) )
	var sec_n =  (max - time) - 60*Math.trunc((max - time)/60)  
	var sec = String(sec_n)
	if (sec_n < 10) 
	{
		sec = '0' + sec

	}

	text = min  + ':' + sec


	DuelText.text = text



	var number = 0
	number = 100 - (time/(max)) * 100
	text = String(number)+'%'
	Timer.style.width = text


}	