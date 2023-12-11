var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);


var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "DamageAbilitiesIncome";

UpdateAbilitiesHudDamage()
UpdateAbilitiesHudDamageIncoming()

function init()
{


	GameEvents.Subscribe_custom('init_damage_table', init_damage_table)
}



function init_damage_table(kv)
{
	let main = $.GetContextPanel().FindChildTraverse("DamageBlockWithButton")

	var sub_data = CustomNetTables.GetTableValue("sub_data", Players.GetLocalPlayer());

	
	if (sub_data.subscribed == 1)
	{
		main.AddClass("DamageBlockWithButton_visible")
	}


}



init()


function DamageToggle() 
{
    if (toggle === false) {
        if (cooldown_panel == false) {
            toggle = true;
            if (first_time === false) {
                first_time = true;
                $("#DamageBlockWithButton").AddClass("damage_close");
            }  
            if ($("#DamageBlockWithButton").BHasClass("damage_close")) {
                $("#DamageBlockWithButton").RemoveClass("damage_close");
            }
            $("#DamageBlockWithButton").AddClass("damage_open");

           	Game.EmitSound("UI.Talent_show")

            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    } else {
        if (cooldown_panel == false) {
            toggle = false;
            if ($("#DamageBlockWithButton").BHasClass("damage_open")) {
                $("#DamageBlockWithButton").RemoveClass("damage_open");
            }
            $("#DamageBlockWithButton").AddClass("damage_close");
           	Game.EmitSound("UI.Talent_hide")
            cooldown_panel = true
            $.Schedule( 0.503, function(){
                cooldown_panel = false
            })
        }
    }
}

function DamageToggleButton(tab, button) 
{
	$("#DamageAbilities").style.visibility = "collapse";
	$("#DamageAbilitiesIncome").style.visibility = "collapse";
	$("#" + tab).style.visibility = "visible";

	for (var i = 0; i < $("#Damage_MenuButtons").GetChildCount(); i++) {
		$("#Damage_MenuButtons").GetChild(i).RemoveClass("button_select")
	}

	Game.EmitSound("UI.Click")

	current_sub_tab = tab;

	$("#" + button).AddClass("button_select")
}

function UpdateAbilitiesHudDamage() 
{
	var maximum_damage = 0

	var table_units = CustomNetTables.GetTableValue("player_damages", Players.GetLocalPlayer());
	if (table_units) 
	{
		if (Object.keys(table_units).length > 0) 
		{
			for (var i = 1; i <= Object.keys(table_units).length; i++) 
			{
				maximum_damage = maximum_damage + table_units[i].damage
			}
		}
	}

	if (table_units) 
	{
		if (Object.keys(table_units).length > 0) 
		{
			for (var i = 1; i <= Object.keys(table_units).length; i++) 
			{
				let ability_panel = $( "#DamageAbilities" ).FindChildTraverse("unit_damage_" + table_units[i].name)

				if (ability_panel == null)
				{
					ability_panel = CreateNewAbility(table_units[i], $( "#DamageAbilities" ))
				}

				var percent = (table_units[i].damage * 100) / (maximum_damage || 1)

				if ($( "#DamageAbilities" ).GetChild(i-1))
				{
					$( "#DamageAbilities" ).MoveChildAfter( ability_panel, $( "#DamageAbilities" ).GetChild(i-1) );
				}

				ability_panel.FindChildTraverse("DamageLine").style['width'] = percent.toFixed(0) +'%';
						
				var damage_text = CheckStringDamage(table_units[i].damage) + " " + "( " + percent.toFixed(0) + "% )"

				ability_panel.FindChildTraverse("DamageUnitLabel").text = String(damage_text)
			}
		}
	}
	$.Schedule(1/144, UpdateAbilitiesHudDamage)
}

function UpdateAbilitiesHudDamageIncoming() {
	var maximum_damage = 0
	var maximum_damage_phys = 0
	var maximum_damage_magic = 0
	var maximum_damage_pure = 0

	var table_units = CustomNetTables.GetTableValue("player_damages_income", Players.GetLocalPlayer());

	if (table_units) 
	{
		if (Object.keys(table_units).length > 0) 
		{
			for ( var info of Object.keys(table_units) )
			{
				maximum_damage = maximum_damage + table_units[info].all_damage
				maximum_damage_phys = maximum_damage_phys + table_units[info].phys
				maximum_damage_magic = maximum_damage_magic + table_units[info].magic
				maximum_damage_pure = maximum_damage_pure + table_units[info].pure
			}
		}
	}

	var percent_phys = (maximum_damage_phys * 100) / (maximum_damage || 1)
	var percent_magic = (maximum_damage_magic * 100) / (maximum_damage || 1)
	var percent_pure = (maximum_damage_pure * 100) / (maximum_damage || 1)

	$( "#AllDamagePhys" ).style.width = percent_phys.toFixed(0) +'%';

	if (percent_phys > 16)	
	{
		$( "#AllDamagePhysPercent" ).text = percent_phys.toFixed(0)+'%';
	}else 
	{
		$( "#AllDamagePhysPercent" ).text = '';
	}

	$( "#AllDamageMagical" ).style.width = percent_magic.toFixed(0) +'%';

	if (percent_magic > 16)	
	{
		$( "#AllDamageMagicalPercent" ).text = percent_magic.toFixed(0)+'%';
	}
	else 
	{
		$( "#AllDamageMagicalPercent" ).text = '';
	}


	$( "#AllDamagePure" ).style.width = percent_pure.toFixed(0) +'%';


	if (percent_pure > 16)	
	{
		$( "#AllDamagePurePercent" ).text = percent_pure.toFixed(0)+'%';		
	}
	else 
	{
		$( "#AllDamagePurePercent" ).text = '';
	}

	
	if (table_units) 
	{
		if (Object.keys(table_units).length > 0) 
		{
			for ( var info of Object.keys(table_units) )
			{
				let hero_panel = $( "#DamageAbilitiesIncome" ).FindChildTraverse("unit_name_" + info)
				
				if (hero_panel == null)
				{
					hero_panel = CreateNewHero(info, $( "#DamageAbilitiesIncome" ))
				} else {
					hero_panel = hero_panel.FindChildTraverse("abilities")
				}

				var hero_max_damage = table_units[info].phys + table_units[info].magic + table_units[info].pure

				let phys_line = hero_panel.FindChildTraverse("DamageLinePhys")
				let magic_line = hero_panel.FindChildTraverse("DamageLineMagic")
				let pure_line = hero_panel.FindChildTraverse("DamageLinePure")

				var phys_percent = (table_units[info].phys * 100) / (hero_max_damage || 1)
				var magic_percent = (table_units[info].magic * 100) / (hero_max_damage || 1)
				var pure_percent = (table_units[info].pure * 100) / (hero_max_damage || 1)

				phys_line.style['width'] = phys_percent.toFixed(0) +'%';
				magic_line.style['width'] = magic_percent.toFixed(0) +'%';
				pure_line.style['width'] = pure_percent.toFixed(0) +'%';

				hero_panel.FindChildTraverse("DamageUnitLabelPhys").text = CheckStringDamage(table_units[info].phys)
				hero_panel.FindChildTraverse("DamageUnitLabelMagic").text = CheckStringDamage(table_units[info].magic)
				hero_panel.FindChildTraverse("DamageUnitLabelPure").text =CheckStringDamage(table_units[info].pure)

		
				//if (hero_panel.GetChild(i-1))
				//{
				//	hero_panel.MoveChildAfter( hero_panel, hero_panel.GetChild(i-1) );
				//}
			}
		}
	}

	$.Schedule(1/144, UpdateAbilitiesHudDamageIncoming)
} 

function compareFunc( a, b)
{
	if ( a < b )
	{
		return 1; // [ B, A ]
	}
	else if ( a > b )
	{
		return -1; // [ A, B ]
	}
	else
	{
		return 0;
	}
};

function CreateNewAbility(table, general) 
{
	var UnitDamagePanel = $.CreatePanel( "Panel", general, "unit_damage_"+table.name );
	UnitDamagePanel.AddClass( "UnitDamagePanel" );

	if (table.type == "item" )
	{
		var UnitPortrait = $.CreatePanel("DOTAItemImage", UnitDamagePanel, "UnitPortrait");
    	UnitPortrait.itemname = table.name;
    	UnitPortrait.style.height = "22px"
	} else if (table.type == "ability" ) {
		var UnitPortrait = $.CreatePanel("DOTAAbilityImage", UnitDamagePanel, "UnitPortrait");
    	UnitPortrait.abilityname = table.name;
    } else if (table.type == "unit" ) {
    	var UnitPortrait = $.CreatePanel("Panel", UnitDamagePanel, "UnitPortrait");
    	let creep_name = table.name
    	creep_name = creep_name.replace("_1", '')
    	creep_name = creep_name.replace("_2", '')
    	creep_name = creep_name.replace("_3", '')
    	creep_name = creep_name.replace("_4", '')
    	creep_name = creep_name.replace("1", '')
    	creep_name = creep_name.replace("2", '')
    	creep_name = creep_name.replace("3", '')
    	creep_name = creep_name.replace("4", '')
    	UnitPortrait.style.backgroundImage = 'url("s2r://panorama/images/heroes/' + creep_name + '_png.vtex")';
    	UnitPortrait.style.backgroundSize = "100%";
    	UnitPortrait.style.height = "22px"
	} else {
		var UnitPortrait = $.CreatePanel("DOTAAbilityImage", UnitDamagePanel, "UnitPortrait");
    	UnitPortrait.abilityname = "action_attack";
    	UnitPortrait.SetImage( "s2r://panorama/images/spellicons/action_attack_png.vtex" )
	}

	var UnitDamageInfoPanel = $.CreatePanel( "Panel", UnitDamagePanel, "" );
	UnitDamageInfoPanel.AddClass( "UnitDamageInfoPanel" );

	var DamageUnitLabel = $.CreatePanel( "Label", UnitDamageInfoPanel, "DamageUnitLabel" );
	DamageUnitLabel.text = CheckStringDamage(table.damage)

	var DamageLineBG = $.CreatePanel( "Panel", UnitDamageInfoPanel, "DamageLineBG" );

	var DamageLineBG2 = $.CreatePanel( "Panel", DamageLineBG, "DamageLineBG2" );

	var DamageLineStart = $.CreatePanel( "Panel", DamageLineBG2, "" );
	DamageLineStart.AddClass( "DamageLineStart" );

	var DamageLine = $.CreatePanel( "Panel", DamageLineBG2, "DamageLine" );

	if (table.damage_type == 1 )
	{
	//	DamageLineStart.style.backgroundColor = "#ae2f28"
		DamageLine.style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from( #6d1915 ), to( #f23e34 ) )"
	} else if (table.damage_type == 2 ) {
	//	DamageLineStart.style.backgroundColor = "#5b93d1"
		DamageLine.style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from( #304c6c ), to( #6db2ff ) )"
	} else if (table.damage_type == 4 ) {
	//	DamageLineStart.style.backgroundColor = "#d8ae53"
		DamageLine.style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from( #7c632c ), to( #ffcd62 ) )"
	} else {
	//	DamageLineStart.style.backgroundColor = "white"
		DamageLine.style.backgroundColor = "white"
	}

	return UnitDamagePanel
}

function CreateNewHero(hero_name, general) 
{
	var UnitHeroInfo = $.CreatePanel( "Panel", general, "unit_name_"+hero_name );
	UnitHeroInfo.AddClass( "UnitHeroInfo" );

    var UnitPortrait_hero = $.CreatePanel("Panel", UnitHeroInfo, "UnitPortrait_hero");
    UnitPortrait_hero.style.backgroundImage = 'url("s2r://panorama/images/heroes/icons/' + hero_name + '_png.vtex")';
    UnitPortrait_hero.style.backgroundSize = "100%";
    UnitPortrait_hero.style.height = "30px"
    UnitPortrait_hero.style.width = "30px"

    var UnitHeroInfoAbilities = $.CreatePanel( "Panel", UnitHeroInfo, "abilities" );
	UnitHeroInfoAbilities.AddClass( "UnitHeroInfoAbilities" );

	var UnitDamageInfoPanelPhys = $.CreatePanel( "Panel", UnitHeroInfoAbilities, "" );
	UnitDamageInfoPanelPhys.AddClass( "UnitDamageInfoPanelIncome" );
	
	var DamageUnitLabelPhys = $.CreatePanel( "Label", UnitDamageInfoPanelPhys, "DamageUnitLabelPhys" );

	var DamageLineBGPhys = $.CreatePanel( "Panel", UnitDamageInfoPanelPhys, "DamageLineBGPhys" );

	var DamageLineBG2Phys = $.CreatePanel( "Panel", DamageLineBGPhys, "DamageLineBG2Phys" );

	//var DamageLineStart = $.CreatePanel( "Panel", DamageLineBG2Phys, "" );
	//DamageLineStart.AddClass( "DamageLineStart" );
	//DamageLineStart.style.backgroundColor = "#ae2f28"

	var DamageLinePhys = $.CreatePanel( "Panel", DamageLineBG2Phys, "DamageLinePhys" );
	DamageLinePhys.style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from( #6d1915 ), to( #f23e34 ) )"
	DamageLinePhys.AddClass("DamageLineInc")

	var UnitDamageInfoPanelMagic = $.CreatePanel( "Panel", UnitHeroInfoAbilities, "" );
	UnitDamageInfoPanelMagic.AddClass( "UnitDamageInfoPanelIncome" );
	
	var DamageUnitLabelMagic = $.CreatePanel( "Label", UnitDamageInfoPanelMagic, "DamageUnitLabelMagic" );

	var DamageLineBGMagic = $.CreatePanel( "Panel", UnitDamageInfoPanelMagic, "DamageLineBGMagic" );

	var DamageLineBG2Magic = $.CreatePanel( "Panel", DamageLineBGMagic, "DamageLineBG2Magic" );

	//var DamageLineStart = $.CreatePanel( "Panel", DamageLineBG2Magic, "" );
	//DamageLineStart.AddClass( "DamageLineStart" );
	//DamageLineStart.style.backgroundColor = "#5b93d1"

	var DamageLineMagic = $.CreatePanel( "Panel", DamageLineBG2Magic, "DamageLineMagic" );
	DamageLineMagic.style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from( #304c6c ), to( #6db2ff ) )"
	DamageLineMagic.AddClass("DamageLineInc")

	var UnitDamageInfoPanelPure = $.CreatePanel( "Panel", UnitHeroInfoAbilities, "" );
	UnitDamageInfoPanelPure.AddClass( "UnitDamageInfoPanelIncome" );
	
	var DamageUnitLabelPure = $.CreatePanel( "Label", UnitDamageInfoPanelPure, "DamageUnitLabelPure" );

	var DamageLineBGPure = $.CreatePanel( "Panel", UnitDamageInfoPanelPure, "DamageLineBGPure" );

	var DamageLineBG2Pure = $.CreatePanel( "Panel", DamageLineBGPure, "DamageLineBG2Pure" );

	//var DamageLineStart = $.CreatePanel( "Panel", DamageLineBG2Pure, "" );
	//DamageLineStart.AddClass( "DamageLineStart" );
	//DamageLineStart.style.backgroundColor = "#d8ae53"

	var DamageLinePure = $.CreatePanel( "Panel", DamageLineBG2Pure, "DamageLinePure" );
	DamageLinePure.style.backgroundColor = "gradient( linear, 0% 0%, 100% 0%, from( #7c632c ), to( #ffcd62 ) )"
	DamageLinePure.AddClass("DamageLineInc")

    return UnitHeroInfoAbilities
}

function CheckStringDamage(damage) {
	if (damage > 999999) 
	{
		return String((damage/1000000).toFixed(1)) + "M"
	} else if (damage > 999) {
		return String((damage/1000).toFixed(1)) + "K"
	} else {
		return damage.toFixed(0)
	}
}
