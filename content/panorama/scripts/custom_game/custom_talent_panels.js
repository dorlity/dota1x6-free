var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");

if (parentHUDElements)
{
 var center_block = parentHUDElements.FindChildTraverse("center_block");
 $.GetContextPanel().SetParent(center_block);
}

function GetDotaHud()
{
  let hPanel = $.GetContextPanel();

  while ( hPanel && hPanel.id !== 'Hud')
  {
      hPanel = hPanel.GetParent();
  }

  if (!hPanel)
  {
      throw new Error('Could not find Hud root from panel with id: ' + $.GetContextPanel().id);
  }

  return hPanel;
}


var names =
[
  "Legion_Duel_Panel",
  "Pa_hunt_init_Panel",
  "Tb_reflection_init_Panel",
  "TalentUI_short_Panel",
  "Centaur_Stomp_Panel",
]


for (var i = 0; i < Object.keys(names).length; i++) 
{
  let panel = $.GetContextPanel().FindChildTraverse(names[i])
  if (panel && panel != null && parentHUDElements)
  {
    panel.SetParent(parentHUDElements)
  }
}


CustomNetTables.SubscribeNetTableListener( "hero_portrait_levels", update_levels );
GameEvents.Subscribe("reconnect_hero_levels", reconnect_hero_levels)



const level_colors = ['#edb96e','#d5edf3','#feeb44',"#c4eaff",'#d1ce89','#d1ce89']
var level_init = false
var level_heroes = {}

function update_levels(table, key, data)
{
  if (table != "hero_portrait_levels") return
  if (key == "") return

  if (key == -1 || key == "-1" || key == "") return

  level_heroes[key] = data
}


function reconnect_hero_levels(kv)
{
  let hero = kv.hero
  update_levels("hero_portrait_levels", hero, CustomNetTables.GetTableValue("hero_portrait_levels", hero))
}



function check_level_timer()
{

  let hero_id = Players.GetLocalPlayerPortraitUnit()
  let hero = Entities.GetUnitName(hero_id)


  let level_data = level_heroes[hero]
  let level_icon = $.GetContextPanel().FindChildTraverse("level_icon_custom")
  let hero_label = $.GetContextPanel().GetParent().FindChildTraverse("UnitNameLabel");

  let dota_level = center_block.FindChildTraverse('unitbadge')

  if (dota_level)
  {
    dota_level.style.opacity = '0';
  }

  if (!level_icon)
  {
    level_icon =  $.CreatePanel("Panel", $.GetContextPanel(), "level_icon_custom")
    level_icon.AddClass("level_icon_custom")
  }  
  

  if ((level_data)&&(level_data.tier != undefined)&&(level_data.tier > -1))
  {
    hero_label.style.color = level_colors[level_data.tier];
    level_icon.style.backgroundImage = 'url("s2r://panorama/images/hud/portrait_hero_badge_frame_tier_' + String(level_data.tier + 1) + '_psd.vtex")';
    level_icon.style.opacity = "1";

  }
  else 
  {
    hero_label.style.color = 'white';
    level_icon.style.opacity = "0";
  }


  $.Schedule( 0.1, function()
  { 
    check_level_timer()
  })
  
}



function init()
{

  GameEvents.Subscribe_custom('pa_hunt_think', pa_hunt_think)
  GameEvents.Subscribe_custom('pa_hunt_end', pa_hunt_end)
  GameEvents.Subscribe_custom('pa_hunt_init', pa_hunt_init)
  GameEvents.Subscribe_custom('pa_hunt_init_end', pa_hunt_init_end)

  GameEvents.Subscribe_custom('tb_reflection_init', tb_reflection_init)
  GameEvents.Subscribe_custom('tb_reflection_init_end', tb_reflection_init_end)
  
  GameEvents.Subscribe_custom('muerta_quest_panel', muerta_quest_panel)
  GameEvents.Subscribe_custom('legion_duel_init', legion_duel_init)
  GameEvents.Subscribe_custom('legion_duel_end', legion_duel_end)
  GameEvents.Subscribe_custom('centaur_stomp', centaur_stomp)

  GameEvents.Subscribe_custom('init_hero_level', init_hero_level)

  GameEvents.Subscribe_custom('invoker_hide_neutral', invoker_hide_neutral)

  GameEvents.Subscribe_custom('talent_ui_long', talent_ui_long)
  GameEvents.Subscribe_custom('talent_ui_short', talent_ui_short)
}


function invoker_hide_neutral()
{
  let dotahud = GetDotaHud()
  let panel = dotahud.FindChildTraverse("inventory_neutral_craft_holder")
  
  if (panel)
  {
    panel.style.opacity = "0"
  }
}




function init_hero_level(kv)
{
  check_level_timer()
}


var current_style = "Default"
var current_style_short = "Default"


var main_long = $.GetContextPanel().FindChildTraverse("TalentUI_long_Panel")
var filler_long = $.GetContextPanel().FindChildTraverse("TalentUI_long_Filler")
var number_long = $.GetContextPanel().FindChildTraverse("TalentUI_long_Number")
var bar_long = $.GetContextPanel().FindChildTraverse("TalentUI_long_Bar")
var icon_long = $.GetContextPanel().FindChildTraverse("TalentUI_long_Icon")

function talent_ui_long(kv)
{

  let hide = kv.hide

  if (hide == 1)
  {
    if (!main_long.BHasClass("TalentUI_long_Panel_hidden"))
    {
      main_long.AddClass("TalentUI_long_Panel_hidden")
    }

    filler_long.style.width = '0%'
    return
  }

  if (main_long.BHasClass("TalentUI_long_Panel_hidden"))
  {
    main_long.RemoveClass("TalentUI_long_Panel_hidden")
  }

  let max = kv.max
  let stack = Math.min(kv.stack, max)
  let style = kv.style
  let no_min = kv.no_min
  let max_style = style + "_Max"
  let override_stack = kv.override_stack
  let hide_number = kv.hide_number
  let active = kv.active
  let use_zero = kv.use_zero

  if (current_style != style)
  {
    bar_long.RemoveClass(current_style + "_Bar")
    filler_long.RemoveClass(current_style + "_Filler")
    icon_long.RemoveClass(current_style + "_Icon")
    number_long.RemoveClass(current_style + "_Number")

    bar_long.AddClass(style + "_Bar")
    filler_long.AddClass(style + "_Filler")
    icon_long.AddClass(style + "_Icon")
    number_long.AddClass(style + "_Number")
    current_style = style
  }

  filler_long.style.width = String((stack/max) * 95)+'%'

  if (hide_number == 1)
  {
    number_long.text = ""
  }else
  {
    let num = stack
    if (override_stack != -1)
    {
      num = override_stack
    }

    if (use_zero == 1)
    {
      num = roundPlus(num, 1)
      if (num % 1 == 0)
      {
        number_long.text = String(num) + '.0'
      }else 
      {
        number_long.text = String(num)
      }
    }else
    {
      if (typeof(num) == "string")
      {
        number_long.text = num
      }else
      { 
        number_long.text = String(Math.trunc(num))
      } 
    } 
  }


  if (!bar_long.BHasClass("TalentUI_long_inactive") && no_min == 0 && stack <= 0)
  {  
    bar_long.AddClass("TalentUI_long_inactive")
    icon_long.AddClass("TalentUI_long_inactive")
    filler_long.AddClass("TalentUI_long_inactive")
  }
  if (bar_long.BHasClass("TalentUI_long_inactive") && (no_min == 1 || stack > 0))
  {  
    bar_long.RemoveClass("TalentUI_long_inactive")
    icon_long.RemoveClass("TalentUI_long_inactive")
    filler_long.RemoveClass("TalentUI_long_inactive")
  }

  if (active != -1)
  {
    if (active == 1)
    {
      if (!bar_long.BHasClass(style + "_Bar_Active"))
      {  
        bar_long.AddClass(style + "_Bar_Active")
        icon_long.AddClass(style + "_Icon_Active")
        filler_long.AddClass(style + "_Filler_Active")
        bar_long.RemoveClass(style + "_Bar")
        icon_long.RemoveClass(style + "_Icon")
        filler_long.RemoveClass(style + "_Filler")
      }
    }else
    {
      if (bar_long.BHasClass(style + "_Bar_Active"))
      {  
        bar_long.RemoveClass(style + "_Bar_Active")
        icon_long.RemoveClass(style + "_Icon_Active")
        filler_long.RemoveClass(style + "_Filler_Active")
        bar_long.AddClass(style + "_Bar")
        icon_long.AddClass(style + "_Icon")
        filler_long.AddClass(style + "_Filler")
      }
    }
    return
  }

  if (stack >= max)
  {
    if (!bar_long.BHasClass(max_style))
    {  
      bar_long.AddClass(max_style)
      icon_long.AddClass(max_style)
      filler_long.AddClass(style + "_Max_Filler")
    }
  }else
  {
    if (bar_long.BHasClass(max_style))
    {  
      bar_long.RemoveClass(max_style)
      icon_long.RemoveClass(max_style)
      filler_long.RemoveClass(style + "_Max_Filler")
    }
  }
}




var main_short = parentHUDElements.FindChildTraverse("TalentUI_short_Panel")
var filler_short = parentHUDElements.FindChildTraverse("TalentUI_short_Filler")
var number_short = parentHUDElements.FindChildTraverse("TalentUI_short_Number")
var bar_short = parentHUDElements.FindChildTraverse("TalentUI_short_Bar")
var icon_short = parentHUDElements.FindChildTraverse("TalentUI_short_Icon")
var icon_number_short = parentHUDElements.FindChildTraverse("TalentUI_short_Icon_Number")
var ability_icon_short = parentHUDElements.FindChildTraverse("TalentUI_short_Ability")
var top_text_short = parentHUDElements.FindChildTraverse("TalentUI_short_TopText")


function talent_ui_short(kv)
{
  let max_time = kv.max_time
  let time = Math.min(kv.time, max_time)
  let stack = kv.stack
  let style = kv.style
  let hide = kv.hide
  let hide_full = kv.hide_full
  let active = kv.active
  let use_zero = kv.use_zero
  let stack_icon = kv.stack_icon
  let dots = kv.dots
  let override_ability = kv.override_ability
  let text = kv.top_text
  let stack_icon_zero = kv.stack_icon_zero

  if (hide == 1)  
  {
    if (!main_short.BHasClass("TalentUI_short_Panel_hidden"))
    {
      main_short.AddClass("TalentUI_short_Panel_hidden")
    }

    if (hide_full == 1)
    {
      filler_short.style.width = '100%'
    }
    if (hide_full == 0)
    {
      filler_short.style.width = '0%'
    }
    return
  }

  if (main_short.BHasClass("TalentUI_short_Panel_hidden"))
  {
    main_short.RemoveClass("TalentUI_short_Panel_hidden")
  }

  if (current_style_short != style)
  {
    bar_short.RemoveClass(current_style_short + "_Bar")
    filler_short.RemoveClass(current_style_short + "_Filler")
    icon_short.RemoveClass(current_style_short + "_Icon")

    bar_short.RemoveClass(current_style_short + "_Bar_Active")
    filler_short.RemoveClass(current_style_short + "_Filler_Active")
    icon_short.RemoveClass(current_style_short + "_Icon_Active")

    if (dots <= 0)
    {
      for (var i = 1; i <= 5; i++) 
      {
        let dot_panel = main_short.FindChildTraverse("TalentUI_short_Dot_" + String(Math.trunc(i)))
        if (dot_panel && dot_panel != null)
        {
          dot_panel.AddClass("TalentUI_short_Panel_hidden")
        }
      }
    }else
    {
      let margin = 100/dots
      for (var i = 1; i < dots; i++) 
      {
        let dot_panel = main_short.FindChildTraverse("TalentUI_short_Dot_" + String(Math.trunc(i)))
        if (dot_panel && dot_panel != null)
        {
          dot_panel.RemoveClass("TalentUI_short_Panel_hidden")
          dot_panel.RemoveClass(current_style_short + "_Dot")
          dot_panel.AddClass(style + "_Dot")
          dot_panel.style.marginLeft = String(margin*i) + "%"
        }
      }
    }

    bar_short.AddClass(style + "_Bar")
    filler_short.AddClass(style + "_Filler")
    icon_short.AddClass(style + "_Icon")
    current_style_short = style
  }

  if (text != -1)
  {
    if (top_text_short.BHasClass("TalentUI_short_Panel_hidden"))
    {
      top_text_short.RemoveClass("TalentUI_short_Panel_hidden")
      top_text_short.text = $.Localize("#" + text)
    }
  }else
  {
    top_text_short.text = ""
    top_text_short.AddClass("TalentUI_short_Panel_hidden")
  }

  if (override_ability != -1)
  {
    ability_icon_short.RemoveClass("TalentUI_short_Panel_hidden")
    ability_icon_short.abilityname = String(override_ability)
  }else
  {
    if (!ability_icon_short.BHasClass("TalentUI_short_Panel_hidden"))
    {
      ability_icon_short.AddClass("TalentUI_short_Panel_hidden")
    }
  }

  if (filler_short.BHasClass("TalentUI_short_Panel_hidden"))
  {
    filler_short.RemoveClass("TalentUI_short_Panel_hidden")
  }

  filler_short.style.width = String((time/max_time) * 97)+'%'

  if (stack != -1)
  {
    if (use_zero == 1)
    {
      let num = roundPlus(stack, 1)
      if (num % 1 == 0)
      {
        number_short.text = String(num) + '.0'
      }else 
      {
        number_short.text = String(num)
      }
    }else
    {
      if (typeof(stack) == "string")
      {
        number_short.text = stack
      }else
      { 
        number_short.text = String(Math.trunc(stack))
      }
    } 
  }else
  {
    number_short.text = ""
  }

  if (stack_icon != -1)
  {
    if (stack_icon_zero == 1)
    {
      let num = roundPlus(stack_icon, 1)

      if (icon_number_short.BHasClass("TalentUI_short_Icon_Number_normal"))
      {
        icon_number_short.RemoveClass("TalentUI_short_Icon_Number_normal")
        icon_number_short.AddClass("TalentUI_short_Icon_Number_zero")
      }

      if (num % 1 == 0)
      {
        icon_number_short.text = String(num) + '.0'
      }else 
      {
        icon_number_short.text = String(num)
      }
    }else
    {
      if (icon_number_short.BHasClass("TalentUI_short_Icon_Number_zero"))
      {
        icon_number_short.RemoveClass("TalentUI_short_Icon_Number_zero")
        icon_number_short.AddClass("TalentUI_short_Icon_Number_normal")
      }
      
      if (typeof(stack_icon) == "string")
      {
        icon_number_short.text = stack_icon
      }else
      { 
        icon_number_short.text = String(Math.trunc(stack_icon))
      }
    } 
  }else
  {
    icon_number_short.text = ""  
  }

  if (active == 1)
  {
    if (!bar_short.BHasClass(style + "_Bar_Active"))
    {  
      bar_short.AddClass(style + "_Bar_Active")
      icon_short.AddClass(style + "_Icon_Active")
      filler_short.AddClass(style + "_Filler_Active")
    }
  }else
  {
    if (bar_short.BHasClass(style + "_Bar_Active"))
    {  
      bar_short.RemoveClass(style + "_Bar_Active")
      icon_short.RemoveClass(style + "_Icon_Active")
      filler_short.RemoveClass(style + "_Filler_Active")
    }
  }
}






function centaur_stomp(kv)
{

  let main = parentHUDElements.FindChildTraverse("Centaur_Stomp_Panel")
  let filler_marker = parentHUDElements.FindChildTraverse("Centaur_Stomp_Marker")
  let bar_line = parentHUDElements.FindChildTraverse("Centaur_Stomp_Line")
  let icon_number = parentHUDElements.FindChildTraverse("Centaur_Stomp_Icon_Number")

  let max_time = kv.max_time
  let time = Math.min(kv.time, max_time)

  let hide = kv.hide

  let stack_icon = kv.stack_icon
  let line_pos = kv.line_pos
  let line_width = kv.line_width

  if (hide == 1)  
  {
    if (!main.BHasClass("Centaur_Stomp_Panel_hidden"))
    {
      main.AddClass("Centaur_Stomp_Panel_hidden")
    }
    return
  }

  if (main.BHasClass("Centaur_Stomp_Panel_hidden"))
  {
    main.RemoveClass("Centaur_Stomp_Panel_hidden")
  }


  bar_line.style.width = String(line_width) + '%'
  bar_line.style.marginLeft = String(line_pos) + '%'


  filler_marker.style.marginLeft = String((time/max_time)*100) + '%'
  icon_number.text = String(Math.trunc(stack_icon))
 
}






function muerta_quest_panel(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Muerta_Quest_Panel")

  if (kv.stage == 4)
  {
    main.AddClass("Muerta_Quest_Panel_hidden")
    main.RemoveClass("Muerta_Quest_Panel")
    return
  }

  if (main.BHasClass("Muerta_Quest_Panel_hidden"))
  {
    main.RemoveClass("Muerta_Quest_Panel_hidden")
    main.AddClass("Muerta_Quest_Panel")
  }

  let icon = $.GetContextPanel().FindChildTraverse("Muerta_Quest_Icon")
  let bar = $.GetContextPanel().FindChildTraverse("Muerta_Quest_Bar")



  for (var i = 1; i <= 5; i++) {

    let filler = $.GetContextPanel().FindChildTraverse("Muerta_Quest_Filler_" + String(i))

    if (i <= kv.stack)
    {
      filler.style.visibility = "visible"
    }else 
    {
      filler.style.visibility = "collapse"
    }

    if (kv.stage == 1)
    {
      filler.AddClass("Muerta_Quest_Filler")
      filler.RemoveClass("Muerta_Quest_Filler_2")
      filler.RemoveClass("Muerta_Quest_Filler_3")

      bar.AddClass("Muerta_Quest_Bar")
      bar.RemoveClass("Muerta_Quest_Bar_2")
      bar.RemoveClass("Muerta_Quest_Bar_3")

      icon.AddClass("Muerta_Quest_Icon")
      icon.RemoveClass("Muerta_Quest_Icon_2")
      icon.RemoveClass("Muerta_Quest_Icon_3")
    }


    if (kv.stage == 2)
    {
      filler.AddClass("Muerta_Quest_Filler_2")
      filler.RemoveClass("Muerta_Quest_Filler")
      filler.RemoveClass("Muerta_Quest_Filler_3")

      bar.AddClass("Muerta_Quest_Bar_2")
      bar.RemoveClass("Muerta_Quest_Bar")
      bar.RemoveClass("Muerta_Quest_Bar_3")

      icon.AddClass("Muerta_Quest_Icon_2")
      icon.RemoveClass("Muerta_Quest_Icon")
      icon.RemoveClass("Muerta_Quest_Icon_3")
    }


    if (kv.stage == 3)
    {
      filler.AddClass("Muerta_Quest_Filler_3")
      filler.RemoveClass("Muerta_Quest_Filler_2")

      bar.AddClass("Muerta_Quest_Bar_3")
      bar.RemoveClass("Muerta_Quest_Bar")
      bar.RemoveClass("Muerta_Quest_Bar_2")

      icon.AddClass("Muerta_Quest_Icon_3")
      icon.RemoveClass("Muerta_Quest_Icon")
      icon.RemoveClass("Muerta_Quest_Icon_2")
    }
  }





  if (kv.stack >= kv.max) 
  {
   // bar.AddClass("Muerta_Quest_Glow")
  //  icon.AddClass("Muerta_Quest_Glow")
  }
  else
  {
  //  bar.RemoveClass("Muerta_Quest_Glow")
   // icon.RemoveClass("Muerta_Quest_Glow")   
  }


}
















function pa_hunt_think(kv)
{


  let main = $.GetContextPanel().FindChildTraverse("PA_Hunt_Panel")
  if (main.BHasClass("PA_Hunt_Panel_hidden"))
  {
    main.RemoveClass("PA_Hunt_Panel_hidden")
    main.AddClass("PA_Hunt_Panel")
  }


  let hero_icon = $.GetContextPanel().FindChildTraverse("PA_Hunt_Icon")
  hero_icon.style.backgroundImage = "url('file://{images}/heroes/" + kv.hero + ".png')"
  hero_icon.style.backgroundSize = "contain";

  var text = ''
  var min = String( Math.trunc(kv.timer/60 ))
  var sec_n =  kv.timer - 60*Math.trunc(kv.timer/60)  
  var sec = String(sec_n)
  if (sec_n < 10) 
  {
    sec = '0' + sec

  }

  text = min  + ':' + sec



  let timer = $.GetContextPanel().FindChildTraverse("PA_Hunt_gold_timer")
  timer.text = text

}


function pa_hunt_end(kv)
{


  let main = $.GetContextPanel().FindChildTraverse("PA_Hunt_Panel")
  
  if (main.BHasClass("PA_Hunt_Panel"))
  {
    main.RemoveClass("PA_Hunt_Panel")
    main.AddClass("PA_Hunt_Panel_hidden")
  }
}






function roundPlus(x, n) { //x - число, n - количество знаков

  if (isNaN(x) || isNaN(n)) return false;

  var m = Math.pow(10, n);

  return Math.round(x * m) / m;

}





function legion_duel_init(kv)
{
  let main = parentHUDElements.FindChildTraverse("Legion_Duel_Panel")

  if (main.BHasClass("Legion_Duel_Panel_show") || main.BHasClass("Legion_Duel_Panel_visible") || main.BHasClass("Legion_Duel_Panel_hide"))
  {
    return
  }else 
  {
    main.RemoveClass("Legion_Duel_Panel_hidden")
    main.RemoveClass("Legion_Duel_Panel_hide")
    main.AddClass("Legion_Duel_Panel_show")
    main.AddClass("Legion_Duel_Panel_visible")

    $.Schedule( 0.3, function()
    { 
      main.RemoveClass("Legion_Duel_Panel_show")
    })
  }

  Game.EmitSound("Lc.Duel_target_start")

  let hero_1 = main.FindChildTraverse("Legion_Duel_hero_1")
  let hero_2 = main.FindChildTraverse("Legion_Duel_hero_2")


  hero_1.style.backgroundImage =  'url( "file://{images}/heroes/' + kv.hero_1 + '.png")'
  hero_1.style.backgroundSize = '100%'

  hero_2.style.backgroundImage =  'url( "file://{images}/heroes/' + kv.hero_2 + '.png")'
  hero_2.style.backgroundSize = '100%'


  hero_1.SetPanelEvent("onactivate", function() 
  {
    if ( !main.BHasClass("Legion_Duel_Panel_show") && !main.BHasClass("Legion_Duel_Panel_hide"))
    {
      Game.EmitSound("UI.Click")
      GameEvents.SendCustomGameEventToServer_custom("LcDuelPick", {pick : 1}); 
    }
  });


  hero_2.SetPanelEvent("onactivate", function() 
  {
    if ( !main.BHasClass("Legion_Duel_Panel_show") && !main.BHasClass("Legion_Duel_Panel_hide"))
    {
      Game.EmitSound("UI.Click")
      GameEvents.SendCustomGameEventToServer_custom("LcDuelPick", {pick : 2}); 
    }
  });

}





function legion_duel_end(kv)
{
  let main = parentHUDElements.FindChildTraverse("Legion_Duel_Panel")

  if (main.BHasClass("Legion_Duel_Panel_hidden") || main.BHasClass("Legion_Duel_Panel_show") || main.BHasClass("Legion_Duel_Panel_hide"))
  {
    return
  }else 
  {
    main.RemoveClass("Legion_Duel_Panel_visible")
    main.RemoveClass("Legion_Duel_Panel_show")
    main.AddClass("Legion_Duel_Panel_hide")
    main.AddClass("Legion_Duel_Panel_hidden")

    $.Schedule( 0.3, function()
    { 
      main.RemoveClass("Legion_Duel_Panel_hide")
    })
  }


}





function pa_hunt_init(data)
{

  let main = parentHUDElements.FindChildTraverse("Pa_hunt_init_Panel")

  if (main.BHasClass("Pa_hunt_init_Panel_show") || main.BHasClass("Pa_hunt_init_Panel_visible") || main.BHasClass("Pa_hunt_init_Panel_hide"))
  {
    return
  }else 
  {
    main.RemoveClass("Pa_hunt_init_Panel_hidden")
    main.RemoveClass("Pa_hunt_init_Panel_hide")
    main.AddClass("Pa_hunt_init_Panel_show")
    main.AddClass("Pa_hunt_init_Panel_visible")

    $.Schedule( 0.3, function()
    { 
      main.RemoveClass("Pa_hunt_init_Panel_show")
    })
  }

  Game.EmitSound("Lc.Duel_target_start")


  for (var i = 1; i <= Object.keys(data).length; i++)  
  {
    let icon = main.FindChildTraverse("Pa_hunt_init_hero_" + String(i))
    if (icon)
    {
      icon.SetPanelEvent("onactivate", function() 
      {

      });

      if (data[i] && data[i]["target"])
      {
        let name = data[i]["target"]
        let red = data[i]["killed"]
        icon.style.backgroundImage =  'url( "file://{images}/heroes/' + name + '.png")'
        icon.style.backgroundSize = '100%'
        
        if (red == 1)
        {
          let killed = icon.FindChildTraverse("Pa_hunt_init_hero_killed_overlay_" + String(i))
          if (icon)
          {
            killed.AddClass("Pa_hunt_init_hero_killed_overlay_show")
          }else 
          {
            killed.RemoveClass("Pa_hunt_init_hero_killed_overlay_show")
          }
          icon.AddClass("Pa_hunt_init_hero_killed")
        }else 
        {
          pa_hunt_set_event(icon, i)
          icon.RemoveClass("Pa_hunt_init_hero_killed")
        }
      }
    }
  }
}

function pa_hunt_set_event(panel, i)
{
  let main = parentHUDElements.FindChildTraverse("Pa_hunt_init_Panel")
  panel.SetPanelEvent("onactivate", function() 
  {
    if ( !main.BHasClass("Pa_hunt_init_Panel_show") && !main.BHasClass("Pa_hunt_init_Panel_hide"))
    {
      Game.EmitSound("UI.Click")
      GameEvents.SendCustomGameEventToServer_custom("PaHuntPick", {pick : i}); 
    }
  });
}


function pa_hunt_init_end(kv)
{
  let main = parentHUDElements.FindChildTraverse("Pa_hunt_init_Panel")

  if (main.BHasClass("Pa_hunt_init_Panel_hidden") || main.BHasClass("Pa_hunt_init_Panel_show") || main.BHasClass("Pa_hunt_init_Panel_hide"))
  {
    return
  }else 
  {
    main.RemoveClass("Pa_hunt_init_Panel_visible")
    main.RemoveClass("Pa_hunt_init_Panel_show")
    main.AddClass("Pa_hunt_init_Panel_hide")
    main.AddClass("Pa_hunt_init_Panel_hidden")

    $.Schedule( 0.3, function()
    { 
      main.RemoveClass("Pa_hunt_init_Panel_hide")
    })
  }
}








function tb_reflection_init(data)
{

let main = parentHUDElements.FindChildTraverse("Tb_reflection_init_Panel")

if (main.BHasClass("Tb_reflection_init_Panel_show") || main.BHasClass("Tb_reflection_init_Panel_visible") || main.BHasClass("Tb_reflection_init_Panel_hide"))
{
  return
}else 
{
  main.RemoveClass("Tb_reflection_init_Panel_hidden")
  main.RemoveClass("Tb_reflection_init_Panel_hide")
  main.AddClass("Tb_reflection_init_Panel_show")
  main.AddClass("Tb_reflection_init_Panel_visible")

  $.Schedule( 0.3, function()
  { 
    main.RemoveClass("Tb_reflection_init_Panel_show")
  })
}

for (var i = 1; i <= 10; i++)  
{
  let icon = main.FindChildTraverse("Tb_reflection_init_hero_" + String(i))
  if (icon)
  {
    icon.SetPanelEvent("onactivate", function() 
    {

    });
    if (data[i])
    {
      if (data["lifestealer_legendary"])
      {
        let name = data[i]
        icon.style.visibility = "visible"
        icon.style.backgroundImage =  "url('file://{images}/custom_game/icons/mini/npc_dota_hero_life_stealer/" + name + ".png')"
        icon.style.backgroundSize = '100%'
      }else
      {
        let name = data[i]["target"]
        icon.style.visibility = "visible"
        icon.style.backgroundImage =  'url( "file://{images}/heroes/' + name + '.png")'
        icon.style.backgroundSize = '100%'
      }
      tb_reflection_set_event(icon, i)
    }else
    {
      icon.style.visibility = "collapse"
    } 
  }else
  {
    break
  }
}

}

function tb_reflection_set_event(panel, i)
{
  let main = parentHUDElements.FindChildTraverse("Tb_reflection_init_Panel")
  panel.SetPanelEvent("onactivate", function() 
  {
    if ( !main.BHasClass("Tb_reflection_init_Panel_show") && !main.BHasClass("Tb_reflection_init_Panel_hide"))
    {
      Game.EmitSound("UI.Click")
      GameEvents.SendCustomGameEventToServer_custom("TbReflectionPick", {pick : i}); 
    }
  });
}


function tb_reflection_init_end(kv)
{
  let main = parentHUDElements.FindChildTraverse("Tb_reflection_init_Panel")

  if (main.BHasClass("Tb_reflection_init_Panel_hidden") || main.BHasClass("Tb_reflection_init_Panel_show") || main.BHasClass("Tb_reflection_init_Panel_hide"))
  {
    return
  }else 
  {
    main.RemoveClass("Tb_reflection_init_Panel_visible")
    main.RemoveClass("Tb_reflection_init_Panel_show")
    main.AddClass("Tb_reflection_init_Panel_hide")
    main.AddClass("Tb_reflection_init_Panel_hidden")

    $.Schedule( 0.3, function()
    { 
      main.RemoveClass("Tb_reflection_init_Panel_hide")
    })
  }
}







init()

