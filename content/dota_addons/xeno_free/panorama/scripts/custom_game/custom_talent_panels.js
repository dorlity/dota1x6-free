var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");

 var center_block = parentHUDElements.FindChildTraverse("center_block");
 $.GetContextPanel().SetParent(center_block);

 $.GetContextPanel().FindChildTraverse("Pudge_devour_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("Snapfire_Shredder_Panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("Sven_Shield_Panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("Bloodseeker_Rage_Panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("Bloodseeker_rite_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("PangolierShield_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("AxeCall_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("Antimage_counter_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("LegionPress_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("LegionOdds_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("EmberShield_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("MarciJump_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("MuertaUlti_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("BeastCharge_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("LinaArray_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("AlchemistStun_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("ArcField_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("ArcField_Tempest_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("VoidShield_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("InvokerEmp_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("InvokerUlt_panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("Legion_Duel_Panel").SetParent(parentHUDElements)
 $.GetContextPanel().FindChildTraverse("SandKingFinale_panel").SetParent(parentHUDElements)



const level_colors = ['#edb96e','#d5edf3','#feeb44',"#c4eaff",'#d1ce89','#d1ce89']


function check_level_timer()
{


  let hero_id = Players.GetLocalPlayerPortraitUnit()
  let hero = Entities.GetUnitName(hero_id)

  let level_data =  CustomNetTables.GetTableValue('hero_portrait_levels', String(hero));



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

  GameEvents.Subscribe_custom('axe_culling_change', axe_culling_change)

  GameEvents.Subscribe_custom('mk_banana_change', mk_banana_change)

  GameEvents.Subscribe_custom('pudge_devour_change', pudge_devour_change)

  GameEvents.Subscribe_custom('marci_rage_change', marci_rage_change)

  GameEvents.Subscribe_custom('mars_shield_change', mars_shield_change)

  GameEvents.Subscribe_custom('zuus_bolt_change', zuus_bolt_change)

  GameEvents.Subscribe_custom('leshrac_storm_change', leshrac_storm_change)

  GameEvents.Subscribe_custom('ember_remnant_change', ember_remnant_change)

  GameEvents.Subscribe_custom('crystal_attack_change', crystal_attack_change)

  GameEvents.Subscribe_custom('pudge_shard_change', pudge_shard_change)

  GameEvents.Subscribe_custom('troll_axes_change', troll_axes_change)

  GameEvents.Subscribe_custom('courage_crit_change', courage_crit_change)

  GameEvents.Subscribe_custom('void_mark_change', void_mark_change)

  GameEvents.Subscribe_custom('sven_shield_change', sven_shield_change)
  GameEvents.Subscribe_custom('sven_shield_hide', sven_shield_hide)

  GameEvents.Subscribe_custom('snapfire_scatter_change', snapfire_scatter_change)

  GameEvents.Subscribe_custom('snapfire_shredder_change', snapfire_shredder_change)

  GameEvents.Subscribe_custom('puck_charge_change', puck_charge_change)

  GameEvents.Subscribe_custom('qop_attack_change', qop_attack_change)

  GameEvents.Subscribe_custom('beast_ulti_change', beast_ulti_change)

  GameEvents.Subscribe_custom('hoodwink_change', hoodwink_change)

  GameEvents.Subscribe_custom('lina_change', lina_change)

  GameEvents.Subscribe_custom('razor_eye_change', razor_eye_change)

  GameEvents.Subscribe_custom('muerta_quest_panel', muerta_quest_panel)

  GameEvents.Subscribe_custom('bloodseeker_rage_change', bloodseeker_rage_change)
  GameEvents.Subscribe_custom('bloodseeker_rite_change', bloodseeker_rite_change)

  GameEvents.Subscribe_custom('pangolier_stack_change', pangolier_stack_change)

  GameEvents.Subscribe_custom('pangolier_shield_change', pangolier_shield_change)

  GameEvents.Subscribe_custom('muerta_ulti_change', muerta_ulti_change)

  GameEvents.Subscribe_custom('beast_charge_change', beast_charge_change)

  GameEvents.Subscribe_custom('marci_jump_change', marci_jump_change)


  GameEvents.Subscribe_custom('invoker_meteor_change', invoker_meteor_change)

  GameEvents.Subscribe_custom('invoker_emp_change', invoker_emp_change)

  GameEvents.Subscribe_custom('invoker_ult_change', invoker_ult_change)

  GameEvents.Subscribe_custom('axe_call_change', axe_call_change)

  GameEvents.Subscribe_custom('antimage_counter_damage', antimage_counter_damage)

  GameEvents.Subscribe_custom('legion_press_change', legion_press_change)
  GameEvents.Subscribe_custom('legion_odds_change', legion_odds_change)
  GameEvents.Subscribe_custom('legion_duel_init', legion_duel_init)
  GameEvents.Subscribe_custom('legion_duel_end', legion_duel_end)

  GameEvents.Subscribe_custom('sandking_finale_change', sandking_finale_change)

  GameEvents.Subscribe_custom('lina_array_change', lina_array_change)

  GameEvents.Subscribe_custom('alchemist_stun_change', alchemist_stun_change)

  GameEvents.Subscribe_custom('arc_field_change', arc_field_change)

  GameEvents.Subscribe_custom('arc_field_tempest_change', arc_field_tempest_change)

  GameEvents.Subscribe_custom('ember_shield_change', ember_shield_change)

  GameEvents.Subscribe_custom('snapfire_cookie_change', snapfire_cookie_change)

  GameEvents.Subscribe_custom('void_shield_change', void_shield_change)

  GameEvents.Subscribe_custom('sven_rage_change', sven_rage_change)

  GameEvents.Subscribe_custom('BloodSeeker_change', BloodSeeker_change)

  GameEvents.Subscribe_custom('Templar_Refraction_shield', Templar_Refraction_shield)
  GameEvents.Subscribe_custom('Templar_Refraction_change', Templar_Refraction_change)

  GameEvents.Subscribe_custom('alchemist_progress_update', OnProgress)
  GameEvents.Subscribe_custom('alchemist_progress_close', OnClose)


  GameEvents.Subscribe_custom('init_hero_level', init_hero_level)
}

function init_hero_level(kv)
{
  check_level_timer()
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

  let gold = $.GetContextPanel().FindChildTraverse("PA_Hunt_gold_number")
  gold.text = String(kv.gold)



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






function pudge_devour_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("Pudge_devour_panel")


  if (kv.max == 0 && main.BHasClass("Pudge_devour_panel"))
  {
    main.RemoveClass("Pudge_devour_panel")
    main.AddClass("Pudge_devour_panel_hidden")
    return
  }



  if (main.BHasClass("Pudge_devour_panel_hidden"))
  {
    main.RemoveClass("Pudge_devour_panel_hidden")
    main.AddClass("Pudge_devour_panel")
  }

  if (kv.caster == 0)
  {
      let top_panel = main.FindChildTraverse("Pudge_devour_toplabel")
      let bar = main.FindChildTraverse("Pudge_devour_Bar")
      let top_text = main.FindChildTraverse("Pudge_devour_text")

      if (top_panel.BHasClass("Pudge_devour_toplabel_hero"))
      {
        top_panel.RemoveClass("Pudge_devour_toplabel_hero")
        top_panel.AddClass("Pudge_devour_toplabel_target")
      }

      if (bar.BHasClass("Pudge_devour_Bar_hero"))
      {
        bar.RemoveClass("Pudge_devour_Bar_hero")
        bar.AddClass("Pudge_devour_Bar_target")
      }

      top_text.text = $.Localize("#deal_damage_to_pudge")
  }



  let filler = main.FindChildTraverse("Pudge_devour_filler")

  let damage = Math.floor(kv.damage)

  let width = (1 - damage/kv.max) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("Pudge_devour_number")
  number.text = String(kv.max - damage)
}








function pangolier_shield_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("PangolierShield_panel")


  if (main.BHasClass("PangolierShield_panel_hidden"))
  {
    main.RemoveClass("PangolierShield_panel_hidden")
    main.AddClass("PangolierShield_panel")
  }

  let filler = main.FindChildTraverse("PangolierShield_filler")

  if ((kv.hide == 1) && (main.BHasClass("PangolierShield_panel")))
  {
    main.RemoveClass("PangolierShield_panel")
    main.AddClass("PangolierShield_panel_hidden")
    filler.style.width = '0%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (1 - kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("PangolierShield_number")
  number.text = String(damage)

  let icon = main.FindChildTraverse("PangolierShield_Icon")
  let bar = main.FindChildTraverse("PangolierShield_Bar")

  if (kv.stage == 0)
  {
    icon.RemoveClass("PangolierShield_Icon_jump")
    icon.AddClass("PangolierShield_Icon_shield")

    filler.RemoveClass("PangolierShield_filler_jump")
    filler.AddClass("PangolierShield_filler_shield")

    bar.RemoveClass("PangolierShield_Bar_jump")
  }else 
  {
    icon.RemoveClass("PangolierShield_Icon_shield")
    icon.AddClass("PangolierShield_Icon_jump")

    filler.RemoveClass("PangolierShield_filler_shield")
    filler.AddClass("PangolierShield_filler_jump")

    bar.AddClass("PangolierShield_Bar_jump")

  }

}




function roundPlus(x, n) { //x - число, n - количество знаков

  if (isNaN(x) || isNaN(n)) return false;

  var m = Math.pow(10, n);

  return Math.round(x * m) / m;

}



function muerta_ulti_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("MuertaUlti_panel")


  if (main.BHasClass("MuertaUlti_panel_hidden"))
  {
    main.RemoveClass("MuertaUlti_panel_hidden")
    main.AddClass("MuertaUlti_panel")
  }

  let filler = main.FindChildTraverse("MuertaUlti_filler")

  if ((kv.hide == 1) && (main.BHasClass("MuertaUlti_panel")))
  {
    main.RemoveClass("MuertaUlti_panel")
    main.AddClass("MuertaUlti_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage =roundPlus(kv.damage, 1)


  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("MuertaUlti_number")

  if (damage % 1 == 0)
  {
    number.text = String(damage) + '.0'
  }else 
  {
    number.text = String(damage)
  }

}




function beast_charge_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("BeastCharge_panel")


  if (main.BHasClass("BeastCharge_panel_hidden"))
  {
    main.RemoveClass("BeastCharge_panel_hidden")
    main.AddClass("BeastCharge_panel")
  }

  let filler = main.FindChildTraverse("BeastCharge_filler")

  if ((kv.hide == 1) && (main.BHasClass("BeastCharge_panel")))
  {
    main.RemoveClass("BeastCharge_panel")
    main.AddClass("BeastCharge_panel_hidden")
    filler.style.width = '0%'

    return
  }


  let width = 100 - (kv.time/kv.max_time) * 100
  let text = String(width)+'%'


  filler.style.width = text

}






function marci_jump_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("MarciJump_panel")


  if (main.BHasClass("MarciJump_panel_hidden"))
  {
    main.RemoveClass("MarciJump_panel_hidden")
    main.AddClass("MarciJump_panel")
  }

  let filler = main.FindChildTraverse("MarciJump_filler")

  if ((kv.hide == 1) && (main.BHasClass("MarciJump_panel")))
  {
    main.RemoveClass("MarciJump_panel")
    main.AddClass("MarciJump_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("MarciJump_number")
  number.text = String(damage)
}



function invoker_emp_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("InvokerEmp_panel")


  if (main.BHasClass("InvokerEmp_panel_hidden"))
  {
    main.RemoveClass("InvokerEmp_panel_hidden")
    main.AddClass("InvokerEmp_panel")
  }

  let filler = main.FindChildTraverse("InvokerEmp_filler")

  if ((kv.hide == 1) && (main.BHasClass("InvokerEmp_panel")))
  {

    main.RemoveClass("InvokerEmp_panel")
    main.AddClass("InvokerEmp_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("InvokerEmp_number")
  number.text = String(damage)
}



function invoker_ult_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("InvokerUlt_panel")


  if (main.BHasClass("InvokerUlt_panel_hidden"))
  {
    main.RemoveClass("InvokerUlt_panel_hidden")
    main.AddClass("InvokerUlt_panel")
  }

  let filler = main.FindChildTraverse("InvokerUlt_filler")

  if ((kv.hide == 1) && (main.BHasClass("InvokerUlt_panel")))
  {

    main.RemoveClass("InvokerUlt_panel")
    main.AddClass("InvokerUlt_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = roundPlus(kv.damage, 1)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("InvokerUlt_number")
  
  if (damage % 1 == 0)
  {
    number.text = String(damage) + '.0'
  }else 
  {
    number.text = String(damage)
  }

}










function axe_call_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("AxeCall_panel")


  if (main.BHasClass("AxeCall_panel_hidden"))
  {
    main.RemoveClass("AxeCall_panel_hidden")
    main.AddClass("AxeCall_panel")
  }

  let filler = main.FindChildTraverse("AxeCall_filler")

  if ((kv.hide == 1) && (main.BHasClass("AxeCall_panel")))
  {
    main.RemoveClass("AxeCall_panel")
    main.AddClass("AxeCall_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("AxeCall_number")
  number.text = String(damage)
}








function antimage_counter_damage(kv)
{
  let main = parentHUDElements.FindChildTraverse("Antimage_counter_panel")


  if (main.BHasClass("Antimage_counter_panel_hidden"))
  {
    main.RemoveClass("Antimage_counter_panel_hidden")
    main.AddClass("Antimage_counter_panel")
  }

  let filler = main.FindChildTraverse("Antimage_counter_filler")

  if ((kv.hide == 1) && (main.BHasClass("Antimage_counter_panel")))
  {
    main.RemoveClass("Antimage_counter_panel")
    main.AddClass("Antimage_counter_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("Antimage_counter_number")
  number.text = String(damage)
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





function legion_press_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("LegionPress_panel")

  if (main.BHasClass("LegionPress_panel_hidden"))
  {
    main.RemoveClass("LegionPress_panel_hidden")
    main.AddClass("LegionPress_panel")
  }

  let filler = main.FindChildTraverse("LegionPress_filler")

  if ((kv.hide == 1) && (main.BHasClass("LegionPress_panel")))
  {
    main.RemoveClass("LegionPress_panel")
    main.AddClass("LegionPress_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("LegionPress_number")
  number.text = String(damage)
}




function legion_odds_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("LegionOdds_panel")
  let press = parentHUDElements.FindChildTraverse("LegionPress_panel")

  if (press && press.BHasClass("LegionPress_panel"))
  {
    main.RemoveClass("LegionOdds_panel")
    main.AddClass("LegionOdds_panel_hidden")
    return
  }


  if (main.BHasClass("LegionOdds_panel_hidden"))
  {
    main.RemoveClass("LegionOdds_panel_hidden")
    main.AddClass("LegionOdds_panel")
  }

  let filler = main.FindChildTraverse("LegionOdds_filler")

  if ((kv.hide == 1) && (main.BHasClass("LegionOdds_panel")))
  {
    main.RemoveClass("LegionOdds_panel")
    main.AddClass("LegionOdds_panel_hidden")
    filler.style.width = '100%'

    return
  }

  if (kv.active == 0)
  {
    filler.RemoveClass("LegionOdds_filler_active")
    filler.AddClass("LegionOdds_filler")
  }else 
  {
    filler.RemoveClass("LegionOdds_filler")
    filler.AddClass("LegionOdds_filler_active")

  }



  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("LegionOdds_number")
  number.text = String(damage)
}






function sandking_finale_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("SandKingFinale_panel")
  let press = parentHUDElements.FindChildTraverse("LegionPress_panel")

  if (press && press.BHasClass("LegionPress_panel"))
  {
    main.RemoveClass("SandKingFinale_panel")
    main.AddClass("SandKingFinale_panel_hidden")
    return
  }


  if (main.BHasClass("SandKingFinale_panel_hidden"))
  {
    main.RemoveClass("SandKingFinale_panel_hidden")
    main.AddClass("SandKingFinale_panel")
  }

  let filler = main.FindChildTraverse("SandKingFinale_filler")

  if ((kv.hide == 1) && (main.BHasClass("SandKingFinale_panel")))
  {
    main.RemoveClass("SandKingFinale_panel")
    main.AddClass("SandKingFinale_panel_hidden")
    filler.style.width = '100%'

    return
  }


  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("SandKingFinale_number")
  number.text = String(damage)
}







function bloodseeker_rage_change(kv)
{

  let main =  parentHUDElements.FindChildTraverse("Bloodseeker_Rage_Panel")

  let rite = parentHUDElements.FindChildTraverse("Bloodseeker_rite_panel")

  let filler =  parentHUDElements.FindChildTraverse("Bloodseeker_Rage_Filler")

  let width = (kv.rage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  if (rite.BHasClass("Bloodseeker_rite_panel"))
  {
    main.RemoveClass("Bloodseeker_Rage_Panel")
    main.AddClass("Bloodseeker_Rage_Panel_hidden")
    return
  }

  if (kv.hide == 1)
  {

    filler.style.width = "0%";
    main.RemoveClass("Bloodseeker_Rage_Panel")
    main.AddClass("Bloodseeker_Rage_Panel_hidden")
    return
  }

  if (main.BHasClass("Bloodseeker_Rage_Panel_hidden"))
  {
    main.RemoveClass("Bloodseeker_Rage_Panel_hidden")
    main.AddClass("Bloodseeker_Rage_Panel")
  }


  let number =  parentHUDElements.FindChildTraverse("Bloodseeker_Rage_Number")
  let icon =  parentHUDElements.FindChildTraverse("Bloodseeker_Rage_Icon")
  number.text = String(kv.stack)

}


function bloodseeker_rite_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("Bloodseeker_rite_panel")


  if (main.BHasClass("Bloodseeker_rite_panel_hidden"))
  {
    main.RemoveClass("Bloodseeker_rite_panel_hidden")
    main.AddClass("Bloodseeker_rite_panel")
  }

  let filler = main.FindChildTraverse("Bloodseeker_rite_filler")

  if ((kv.hide == 1) && (main.BHasClass("Bloodseeker_rite_panel")))
  {
    main.RemoveClass("Bloodseeker_rite_panel")
    main.AddClass("Bloodseeker_rite_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("Bloodseeker_rite_number")
  number.text = String(damage)
}










function lina_array_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("LinaArray_panel")


  if (main.BHasClass("LinaArray_panel_hidden"))
  {
    main.RemoveClass("LinaArray_panel_hidden")
    main.AddClass("LinaArray_panel")
  }

  let filler = main.FindChildTraverse("LinaArray_filler")

  if ((kv.hide == 1) && (main.BHasClass("LinaArray_panel")))
  {
    main.RemoveClass("LinaArray_panel")
    main.AddClass("LinaArray_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("LinaArray_number")
  number.text = String(damage)
}









function alchemist_stun_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("AlchemistStun_panel")


  if (main.BHasClass("AlchemistStun_panel_hidden"))
  {
    main.RemoveClass("AlchemistStun_panel_hidden")
    main.AddClass("AlchemistStun_panel")
  }

  let filler = main.FindChildTraverse("AlchemistStun_filler")

  if ((kv.hide == 1) && (main.BHasClass("AlchemistStun_panel")))
  {
    main.RemoveClass("AlchemistStun_panel")
    main.AddClass("AlchemistStun_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("AlchemistStun_number")
  number.text = String(damage)
}






function arc_field_change(kv)
{

let main = parentHUDElements.FindChildTraverse("ArcField_panel")

let hero_id = Players.GetLocalPlayerPortraitUnit()

let filler = main.FindChildTraverse("ArcField_filler")
let bar = main.FindChildTraverse("ArcField_Bar")
let icon = main.FindChildTraverse("ArcField_Icon")
let number = main.FindChildTraverse("ArcField_number")

let damage = Math.floor(kv.damage)

let width = (kv.time/kv.max_time) * 97
let text = String(width)+'%'

filler.style.width = text

number.text = String(damage)


if ((kv.hide == 1) || (kv.index != hero_id))
{
  if (main.BHasClass("ArcField_panel"))
  {

    main.RemoveClass("ArcField_panel")
    main.AddClass("ArcField_panel_hidden")
  }
  if (kv.hide == 1)
  {
    filler.style.width = '0%'
  }
  return
}else 
{

  if (main.BHasClass("ArcField_panel_hidden"))
  {
    main.RemoveClass("ArcField_panel_hidden")
    main.AddClass("ArcField_panel")
  }
}


if (kv.active == 1)
{
  if (!bar.BHasClass("ArcField_active"))
  {
    bar.AddClass("ArcField_active")
    icon.AddClass("ArcField_active")
    icon.RemoveClass("ArcField_not_active")
  }
}
 else 
{
  if (bar.BHasClass("ArcField_active"))
  {
    bar.RemoveClass("ArcField_active")
    icon.RemoveClass("ArcField_active")
    icon.AddClass("ArcField_not_active")
  }
}

}



function arc_field_tempest_change(kv)
{

let main = parentHUDElements.FindChildTraverse("ArcField_Tempest_panel")

let hero_id = Players.GetLocalPlayerPortraitUnit()

let filler = main.FindChildTraverse("ArcField_Tempest_filler")
let bar = main.FindChildTraverse("ArcField_Tempest_Bar")
let icon = main.FindChildTraverse("ArcField_Tempest_Icon")
let number = main.FindChildTraverse("ArcField_Tempest_number")

let damage = Math.floor(kv.damage)

let width = (kv.time/kv.max_time) * 97
let text = String(width)+'%'

filler.style.width = text

number.text = String(damage)


if ((kv.hide == 1) || (kv.index != hero_id))
{
  if (main.BHasClass("ArcField_Tempest_panel"))
  {

    main.RemoveClass("ArcField_Tempest_panel")
    main.AddClass("ArcField_Tempest_panel_hidden")
  }
  if (kv.hide == 1)
  {
    filler.style.width = '0%'
  }
  return
}else 
{

  if (main.BHasClass("ArcField_Tempest_panel_hidden"))
  {
    main.RemoveClass("ArcField_Tempest_panel_hidden")
    main.AddClass("ArcField_Tempest_panel")
  }
}




if (kv.active == 1)
{
  if (!bar.BHasClass("ArcField_Tempest_active"))
  {
    bar.AddClass("ArcField_Tempest_active")
    icon.AddClass("ArcField_Tempest_active")
    icon.RemoveClass("ArcField_Tempest_not_active")
  }
}
 else 
{
  if (bar.BHasClass("ArcField_Tempest_active"))
  {
    bar.RemoveClass("ArcField_Tempest_active")
    icon.RemoveClass("ArcField_Tempest_active")
    icon.AddClass("ArcField_Tempest_not_active")
  }
}

}






function void_shield_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("VoidShield_panel")

  if (main.BHasClass("VoidShield_panel_hidden"))
  {
    main.RemoveClass("VoidShield_panel_hidden")
    main.AddClass("VoidShield_panel")
  }

  let filler = main.FindChildTraverse("VoidShield_filler")

  if ((kv.hide == 1) && (main.BHasClass("VoidShield_panel")))
  {
    main.RemoveClass("VoidShield_panel")
    main.AddClass("VoidShield_panel_hidden")
    filler.style.width = '100%'

    return
  }


  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%' 

  filler.style.width = text

  let number = main.FindChildTraverse("VoidShield_number")
  number.text = String(damage)
}










function ember_shield_change(kv)
{
  let main = parentHUDElements.FindChildTraverse("EmberShield_panel")


  if (main.BHasClass("EmberShield_panel_hidden"))
  {
    main.RemoveClass("EmberShield_panel_hidden")
    main.AddClass("EmberShield_panel")
  }

  let filler = main.FindChildTraverse("EmberShield_filler")

  if ((kv.hide == 1) && (main.BHasClass("EmberShield_panel")))
  {
    main.RemoveClass("EmberShield_panel")
    main.AddClass("EmberShield_panel_hidden")
    filler.style.width = '100%'

    return
  }




  let damage = Math.floor(kv.damage)

  let width = (kv.time/kv.max_time) * 97
  let text = String(width)+'%' 

  filler.style.width = text

  let number = main.FindChildTraverse("EmberShield_number")
  number.text = '+' + String(damage)
}






function mk_banana_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("MK_Banana_Panel")
  if (main.BHasClass("MK_Banana_Panel_hidden"))
  {
    main.RemoveClass("MK_Banana_Panel_hidden")
    main.AddClass("MK_Banana_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("MK_Banana_buff_filler")
  let filler_timer = $.GetContextPanel().FindChildTraverse("MK_Banana_buff_timer")
  let number = $.GetContextPanel().FindChildTraverse("MK_Banana_spawn_timer")
  let active = $.GetContextPanel().FindChildTraverse("MK_Banana_Icon")


  var text = ''
  let max_timer = kv.max_timer
  let time = Math.max(0, (max_timer - kv.banana_timer))
  var min = String( Math.trunc(time/max_timer ))
  var sec_n =  time - 60*Math.trunc(time/60)  
  var sec = String(sec_n)
  if (sec_n < 10) 
  {
    sec = '0' + sec

  }

  text = min  + ':' + sec

  number.text = text



}



function axe_culling_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Axe_Culling_Panel")
  if (main.BHasClass("Axe_Culling_Panel_hidden"))
  {
    main.RemoveClass("Axe_Culling_Panel_hidden")
    main.AddClass("Axe_Culling_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Axe_Culling_buff_filler")
  let filler_timer = $.GetContextPanel().FindChildTraverse("Axe_Culling_buff_timer")
  let number = $.GetContextPanel().FindChildTraverse("Axe_Culling_spawn_timer")
  let active = $.GetContextPanel().FindChildTraverse("Axe_Culling_Icon")


  var text = String(kv.damage)
 
  number.text = text


}





function mars_shield_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Mars_Shield_Panel")
  if (main.BHasClass("Mars_Shield_Panel_hidden"))
  {
    main.RemoveClass("Mars_Shield_Panel_hidden")
    main.AddClass("Mars_Shield_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Mars_Shield_Filler")

  let width = Math.min(95, (kv.damage/kv.max) * 95)
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Mars_Shield_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Mars_Shield_Icon")
  number.text = String(kv.damage)


  if (kv.damage >= Math.floor(kv.max))
  {
    if (icon.BHasClass("Mars_Shield_Icon"))
    {
      icon.RemoveClass("Mars_Shield_Icon")
      icon.AddClass("Mars_Shield_Icon_active")
    }
  }else 
  {
    if (icon.BHasClass("Mars_Shield_Icon_active"))
    {
      icon.RemoveClass("Mars_Shield_Icon_active")
      icon.AddClass("Mars_Shield_Icon")
    }
  }

}






function snapfire_shredder_change(kv)
{

  let main =  parentHUDElements.FindChildTraverse("Snapfire_Shredder_Panel")
  if (kv.time == 0)
  {

    main.RemoveClass("Snapfire_Shredder_Panel")
    main.AddClass("Snapfire_Shredder_Panel_hidden")
    return
  }

  if (main.BHasClass("Snapfire_Shredder_Panel_hidden"))
  {
    main.RemoveClass("Snapfire_Shredder_Panel_hidden")
    main.AddClass("Snapfire_Shredder_Panel")
  }


  let filler =  parentHUDElements.FindChildTraverse("Snapfire_Shredder_Filler")
  let blur =  parentHUDElements.FindChildTraverse("Snapfire_Shredder_Icon_blur")

  let height = 60*( 1 - kv.time )
  let h_text = String(height) + '%'
  blur.style.height = h_text

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number =  parentHUDElements.FindChildTraverse("Snapfire_Shredder_Number")
  let icon =  parentHUDElements.FindChildTraverse("Snapfire_Shredder_Icon")
  number.text = String(kv.damage)

  filler.AddClass("Snapfire_Shredder_Filler_1")
  filler.RemoveClass("Snapfire_Shredder_Filler_2")
  filler.RemoveClass("Snapfire_Shredder_Filler_3")

  if (kv.damage >= 30)
  {
    filler.RemoveClass("Snapfire_Shredder_Filler_1")
    filler.AddClass("Snapfire_Shredder_Filler_2")
  }

  if (kv.damage >= 70)
  {
    filler.RemoveClass("Snapfire_Shredder_Filler_2")
    filler.AddClass("Snapfire_Shredder_Filler_3")
  }

}








function snapfire_scatter_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Snapfire_Scatter_Panel")
  if (main.BHasClass("Snapfire_Scatter_Panel_hidden"))
  {
    main.RemoveClass("Snapfire_Scatter_Panel_hidden")
    main.AddClass("Snapfire_Scatter_Panel")
  }

  for (var i = 1; i <= kv.max; i++) {
    let filler = $.GetContextPanel().FindChildTraverse("Snapfire_Scatter_Filler_" + String(i))

    if (i <= kv.stack)
    {
      filler.style.visibility = "visible"
    }else 
    {
      filler.style.visibility = "collapse"
    }

  }


  let icon = $.GetContextPanel().FindChildTraverse("Snapfire_Scatter_Icon")
  let bar = $.GetContextPanel().FindChildTraverse("Snapfire_Scatter_Bar")

  if (kv.active == 1)
  { 
    icon.RemoveClass("Icon_not_active")

  }else 
  {
    icon.AddClass("Icon_not_active")
  }

  if (kv.stack >= kv.max) 
  {
    bar.AddClass("Snapfire_Scatter_Glow")
    icon.AddClass("Snapfire_Scatter_Glow")
  }
  else
  {
    bar.RemoveClass("Snapfire_Scatter_Glow")
    icon.RemoveClass("Snapfire_Scatter_Glow")   
  }


}










function leshrac_storm_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Leshrac_Storm_Panel")
  if (main.BHasClass("Leshrac_Storm_Panel_hidden"))
  {
    main.RemoveClass("Leshrac_Storm_Panel_hidden")
    main.AddClass("Leshrac_Storm_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Leshrac_Storm_Filler")

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Leshrac_Storm_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Leshrac_Storm_Icon")
  number.text = String(kv.damage)

  if (kv.damage >= kv.max)
  {
    if (icon.BHasClass("Leshrac_Storm_Icon"))
    {
      icon.RemoveClass("Leshrac_Storm_Icon")
      icon.AddClass("Leshrac_Storm_Icon_active")
    }
 }else 
 {
    if (icon.BHasClass("Leshrac_Storm_Icon_active"))
    {
      icon.RemoveClass("Leshrac_Storm_Icon_active")
      icon.AddClass("Leshrac_Storm_Icon")
    }
  
 }

}






function razor_eye_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Razor_Eye_Panel")


  if (kv.hide == 0)
  {

    if (main.BHasClass("Razor_Eye_Panel_hidden"))
    {
      main.RemoveClass("Razor_Eye_Panel_hidden")
      main.AddClass("Razor_Eye_Panel")
    }
  }else
  {

    if (main.BHasClass("Razor_Eye_Panel"))
    {
      main.RemoveClass("Razor_Eye_Panel")
      main.AddClass("Razor_Eye_Panel_hidden")
    }
  }

  let filler = $.GetContextPanel().FindChildTraverse("Razor_Eye_Filler")
  let number = $.GetContextPanel().FindChildTraverse("Razor_Eye_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Razor_Eye_Icon")
  let bar = $.GetContextPanel().FindChildTraverse("Razor_Eye_Bar")

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  if (kv.active == 0)
  {
    number.text = String(kv.damage)

    bar.RemoveClass("Razor_active")

    if (icon.BHasClass("Razor_Eye_Icon_active"))
    {
      icon.RemoveClass("Razor_Eye_Icon_active")
      icon.AddClass("Razor_Eye_Icon")
    }
    
  }else 
  {

    if (kv.damage % 1 == 0)
    {
      number.text = String(kv.damage) + '.0'
    }else 
    {
      number.text = String(roundPlus(kv.damage, 1))
    }

    if (icon.BHasClass("Razor_Eye_Icon"))
    {
      icon.RemoveClass("Razor_Eye_Icon")
      icon.AddClass("Razor_Eye_Icon_active")
    }
    
    bar.AddClass("Razor_active")
    
  }

}





function ember_remnant_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Ember_Remnant_Panel")
  if (main.BHasClass("Ember_Remnant_Panel_hidden"))
  {
    main.RemoveClass("Ember_Remnant_Panel_hidden")
    main.AddClass("Ember_Remnant_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Ember_Remnant_Filler")

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Ember_Remnant_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Ember_Remnant_Icon")
  number.text = String(kv.damage)

}



function crystal_attack_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Crystal_Attack_Panel")
  if (main.BHasClass("Crystal_Attack_Panel_hidden"))
  {
    main.RemoveClass("Crystal_Attack_Panel_hidden")
    main.AddClass("Crystal_Attack_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Crystal_Attack_Filler")

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Crystal_Attack_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Crystal_Attack_Icon")
  number.text = String(kv.damage)

  if (kv.damage >= kv.max)
  {
    number.text = ''
    if (icon.BHasClass("Crystal_Attack_Icon"))
    {
      icon.RemoveClass("Crystal_Attack_Icon")
      icon.AddClass("Crystal_Attack_Icon_active")
    }
 }else 
 {
    if (icon.BHasClass("Crystal_Attack_Icon_active"))
    {
      icon.RemoveClass("Crystal_Attack_Icon_active")
      icon.AddClass("Crystal_Attack_Icon")
    }
  
 }

}



function courage_crit_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Courage_Crit_Panel")
  if (main.BHasClass("Courage_Crit_Panel_hidden"))
  {
    main.RemoveClass("Courage_Crit_Panel_hidden")
    main.AddClass("Courage_Crit_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Courage_Crit_Filler")

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Courage_Crit_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Courage_Crit_Icon")


  if ((kv.max - kv.damage) <= 0)
  {
    number.text = ''
  }else 
  {
     number.text = String(kv.max - kv.damage)
  }

  if (kv.damage >= kv.max)
  {
    if (icon.BHasClass("Courage_Crit_Icon"))
    {
      icon.RemoveClass("Courage_Crit_Icon")
      icon.AddClass("Courage_Crit_Icon_active")
    }
 }else 
 {
    if (icon.BHasClass("Courage_Crit_Icon_active"))
    {
      icon.RemoveClass("Courage_Crit_Icon_active")
      icon.AddClass("Courage_Crit_Icon")
    }
  
 }

}




function void_mark_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Void_Mark_Panel")
  if (main.BHasClass("Void_Mark_Panel_hidden"))
  {
    main.RemoveClass("Void_Mark_Panel_hidden")
    main.AddClass("Void_Mark_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Void_Mark_Filler")

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Void_Mark_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Void_Mark_Icon")


  if ((kv.max - kv.damage) <= 0)
  {
    number.text = ''
  }else 
  {
     number.text = String(kv.max - kv.damage)
  }

  if (kv.damage >= kv.max)
  {
    if (icon.BHasClass("Void_Mark_Icon"))
    {
      icon.RemoveClass("Void_Mark_Icon")
      icon.AddClass("Void_Mark_Icon_active")
    }
 }else 
 {
    if (icon.BHasClass("Void_Mark_Icon_active"))
    {
      icon.RemoveClass("Void_Mark_Icon_active")
      icon.AddClass("Void_Mark_Icon")
    }
  
 }

}




function pudge_shard_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Pudge_Shard_Panel")
  if (main.BHasClass("Pudge_Shard_Panel_hidden"))
  {
    main.RemoveClass("Pudge_Shard_Panel_hidden")
    main.AddClass("Pudge_Shard_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Pudge_Shard_Filler")

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Pudge_Shard_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Pudge_Shard_Icon")
  number.text = String(kv.damage)



  if (kv.hide == 1)
  {
    main.RemoveClass("Pudge_Shard_Panel")
    main.AddClass("Pudge_Shard_Panel_hidden")

  }

}




function troll_axes_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Troll_Axes_Panel")
  if (main.BHasClass("Troll_Axes_Panel_hidden"))
  {
    main.RemoveClass("Troll_Axes_Panel_hidden")
    main.AddClass("Troll_Axes_Panel")
  }

  let bar = $.GetContextPanel().FindChildTraverse("Troll_Axes_Bar")
  let filler = $.GetContextPanel().FindChildTraverse("Troll_Axes_Filler")

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Troll_Axes_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Troll_Axes_Icon")
  number.text = String(kv.damage)


  if (kv.type == 1)
  {
    bar.AddClass("Troll_Axes_Bar_Ranged")
    icon.AddClass("Troll_Axes_Icon_Ranged")
    filler.AddClass("Troll_Axes_Filler_Ranged")

    bar.RemoveClass("Troll_Axes_Bar_Melee")
    icon.RemoveClass("Troll_Axes_Icon_Melee")
    filler.RemoveClass("Troll_Axes_Filler_Melee")
  }  

  if (kv.type == 2)
  {
    bar.RemoveClass("Troll_Axes_Bar_Ranged")
    icon.RemoveClass("Troll_Axes_Icon_Ranged")
    filler.RemoveClass("Troll_Axes_Filler_Ranged")

    bar.AddClass("Troll_Axes_Bar_Melee")
    icon.AddClass("Troll_Axes_Icon_Melee")
    filler.AddClass("Troll_Axes_Filler_Melee")

  }


  if (kv.damage == 0)
  {
    bar.AddClass("Troll_Axes_Disabled")
    icon.AddClass("Troll_Axes_Disabled")
    filler.AddClass("Troll_Axes_Disabled")

  }else 
  {
    bar.RemoveClass("Troll_Axes_Disabled")
    icon.RemoveClass("Troll_Axes_Disabled")
    filler.RemoveClass("Troll_Axes_Disabled")
  }

}



function invoker_meteor_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Invoker_Meteor_Panel")
  if (main.BHasClass("Invoker_Meteor_Panel_hidden"))
  {
    main.RemoveClass("Invoker_Meteor_Panel_hidden")
    main.AddClass("Invoker_Meteor_Panel")
  }

  let bar = $.GetContextPanel().FindChildTraverse("Invoker_Meteor_Bar")
  let filler = $.GetContextPanel().FindChildTraverse("Invoker_Meteor_Filler")

  let count = roundPlus(kv.number, 1)


  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Invoker_Meteor_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Invoker_Meteor_Icon")
 
  if (count % 1 == 0)
  {
    number.text = String(count) + '.0'
  }else 
  {
    number.text = String(count)
  }


  if (kv.damage == 0)
  {
    bar.AddClass("Invoker_Meteor_Disabled")
    icon.AddClass("Invoker_Meteor_Disabled")
    filler.AddClass("Invoker_Meteor_Disabled")

  }else 
  {
    bar.RemoveClass("Invoker_Meteor_Disabled")
    icon.RemoveClass("Invoker_Meteor_Disabled")
    filler.RemoveClass("Invoker_Meteor_Disabled")
  }

}









function sven_shield_change(kv)
{

  let main = parentHUDElements.FindChildTraverse("Sven_Shield_Panel")
  if (main.BHasClass("Sven_Shield_Panel_hidden"))
  {
    main.RemoveClass("Sven_Shield_Panel_hidden")
    main.AddClass("Sven_Shield_Panel")
  }


  let filler = main.FindChildTraverse("Sven_Shield_Filler")

  let blur =  parentHUDElements.FindChildTraverse("Sven_Shield_Icon_blur")

  let height = 58*( 1 - Math.max(0, kv.time) )
  let h_text = String(height) + '%'
  blur.style.height = h_text


  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = main.FindChildTraverse("Sven_Shield_Number")
  let icon = main.FindChildTraverse("Sven_Shield_Icon")
  number.text = String(kv.damage)



}





function sven_shield_hide(kv)
{

  let main = parentHUDElements.FindChildTraverse("Sven_Shield_Panel")
  if (main.BHasClass("Sven_Shield_Panel"))
  {
    main.RemoveClass("Sven_Shield_Panel")
    main.AddClass("Sven_Shield_Panel_hidden")
  }



}










function zuus_bolt_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Zuus_Bolt_Panel")
  if (main.BHasClass("Zuus_Bolt_Panel_hidden"))
  {
    main.RemoveClass("Zuus_Bolt_Panel_hidden")
    main.AddClass("Zuus_Bolt_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Zuus_Bolt_Filler")

  let width = (kv.damage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Zuus_Bolt_Number")
  let icon = $.GetContextPanel().FindChildTraverse("Zuus_Bolt_Icon")
  number.text = String(kv.damage)

  if (kv.damage >= kv.max)
  {
    if (icon.BHasClass("Zuus_Bolt_Icon"))
    {
      icon.RemoveClass("Zuus_Bolt_Icon")
      icon.AddClass("Zuus_Bolt_Icon_active")
    }
 }else 
 {
    if (icon.BHasClass("Zuus_Bolt_Icon_active"))
    {
      icon.RemoveClass("Zuus_Bolt_Icon_active")
      icon.AddClass("Zuus_Bolt_Icon")
    }
  
 }

}








function marci_rage_change(kv)
{
  let main = $.GetContextPanel().FindChildTraverse("MarciRage_Panel")
  if (main.BHasClass("MarciRage_Panel_hidden"))
  {
    main.RemoveClass("MarciRage_Panel_hidden")
    main.AddClass("MarciRage_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("MarciRage_Filler")

  let width = (kv.rage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("MarciRage_Number")
  number.text = String(kv.rage)
}









function hoodwink_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Hoodwink_Panel")
  if (main.BHasClass("Hoodwink_Panel_hidden"))
  {
    main.RemoveClass("Hoodwink_Panel_hidden")
    main.AddClass("Hoodwink_Panel")
  }
  let filler = $.GetContextPanel().FindChildTraverse("Hoodwink_Filler")

  let current = kv.current
  if (kv.active == 0)
  {
    current = Math.floor(kv.current)
  } 


  let width = (current/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Hoodwink_Number")

  if (kv.active == 0)
  {
    number.text = String(current)
  }
  else 
  {
    number.text = ''
  }
  let icon = $.GetContextPanel().FindChildTraverse("Hoodwink_Icon")

  if (kv.active == 1)
  {
    if (icon.BHasClass("Hoodwink_Icon"))
    {
      icon.RemoveClass("Hoodwink_Icon")
      icon.AddClass("Hoodwink_Icon_activated")
      
      filler.AddClass('Hoodwink_Filler_active')

    }
  }
  else 
  {
    if (icon.BHasClass("Hoodwink_Icon_activated"))
    {
      icon.RemoveClass("Hoodwink_Icon_activated")
      icon.AddClass("Hoodwink_Icon")
      filler.RemoveClass('Hoodwink_Filler_active')
    }
  }

}






function snapfire_cookie_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Snapfire_Cookie_Panel")
  if (main.BHasClass("Snapfire_Cookie_Panel_hidden"))
  {
    main.RemoveClass("Snapfire_Cookie_Panel_hidden")
    main.AddClass("Snapfire_Cookie_Panel")
  }
  let filler = $.GetContextPanel().FindChildTraverse("Snapfire_Cookie_Filler")

  let current = kv.current

  if (kv.active == 0)
  {
    current = 0
  } 


  let width = (current/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Snapfire_Cookie_Number")

  if (kv.active == 0)
  {
    number.text = String(kv.current.toFixed(1))
  }
  else 
  {
    number.text =  String(kv.current)
  }


  let icon = $.GetContextPanel().FindChildTraverse("Snapfire_Cookie_Icon")

  if (kv.active == 1)
  {
    if (icon.BHasClass("Snapfire_Cookie_Icon"))
    {
      icon.RemoveClass("Snapfire_Cookie_Icon")
      icon.AddClass("Snapfire_Cookie_Icon_activated")
      

    }
  }
  else 
  {
    if (icon.BHasClass("Snapfire_Cookie_Icon_activated"))
    {
      icon.RemoveClass("Snapfire_Cookie_Icon_activated")
      icon.AddClass("Snapfire_Cookie_Icon")
    }
  }

}







function lina_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Lina_Panel")
  if (main.BHasClass("Lina_Panel_hidden"))
  {
    main.RemoveClass("Lina_Panel_hidden")
    main.AddClass("Lina_Panel")
  }
  let filler = $.GetContextPanel().FindChildTraverse("Lina_Filler")

  let current = kv.current
  if (kv.active == 0)
  {
    current = Math.floor(kv.current)
  } 


  let width = (current/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Lina_Number")

  if (kv.active == 0)
  {
    number.text = String(current)
  }
  else 
  {
    number.text = ''
  }
  let icon = $.GetContextPanel().FindChildTraverse("Lina_Icon")

  if (kv.active == 1)
  {
    if (icon.BHasClass("Lina_Icon"))
    {
      icon.RemoveClass("Lina_Icon")
      icon.AddClass("Lina_Icon_activated")
      
      filler.AddClass('Lina_Filler_active')

    }
  }
  else 
  {
    if (icon.BHasClass("Lina_Icon_activated"))
    {
      icon.RemoveClass("Lina_Icon_activated")
      icon.AddClass("Lina_Icon")
      filler.RemoveClass('Lina_Filler_active')
    }
  }

}




function sven_rage_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Sven_Rage_Panel")
  if (main.BHasClass("Sven_Rage_Panel_hidden"))
  {
    main.RemoveClass("Sven_Rage_Panel_hidden")
    main.AddClass("Sven_Rage_Panel")
  }
  let filler = $.GetContextPanel().FindChildTraverse("Sven_Rage_Filler")

  let bar = $.GetContextPanel().FindChildTraverse("Sven_Rage_Bar")

  let current = kv.current


  let width = (current/kv.max) * 96
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Sven_Rage_Number")

  number.text = String(current)

  let icon = $.GetContextPanel().FindChildTraverse("Sven_Rage_Icon")


  if (kv.current == 0)
  {
    icon.RemoveClass("Sven_Rage_Icon_activated")
    icon.AddClass("Sven_Rage_Icon")
  }else 
  {
    if (icon.BHasClass("Sven_Rage_Icon"))
    {
      icon.RemoveClass("Sven_Rage_Icon")
      icon.AddClass("Sven_Rage_Icon_activated")
    }
  }



  if (kv.current == kv.max)
  {
    icon.AddClass('Sven_Rage_Bar_active')
    bar.AddClass('Sven_Rage_Bar_active')
  }
  else 
  {
    bar.RemoveClass('Sven_Rage_Bar_active')
    icon.RemoveClass('Sven_Rage_Bar_active')
  }

}










function BloodSeeker_change(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("BloodSeeker_Panel")
  if (main.BHasClass("BloodSeeker_Panel_hidden"))
  {
    main.RemoveClass("BloodSeeker_Panel_hidden")
    main.AddClass("BloodSeeker_Panel")
  }

  let filler = $.GetContextPanel().FindChildTraverse("BloodSeeker_Filler")
  let number = $.GetContextPanel().FindChildTraverse("BloodSeeker_Number")
  let icon = $.GetContextPanel().FindChildTraverse("BloodSeeker_Icon")



  let width = (kv.rage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  if (kv.stage == 1)
  {


    number.text = String(kv.rage)


    if (kv.rage == kv.max)
    {
      if (icon.BHasClass("BloodSeeker_Icon"))
      {
        icon.RemoveClass("BloodSeeker_Icon")
        icon.AddClass("BloodSeeker_Icon_activated")
      }
    }
    else 
    {
      if (icon.BHasClass("BloodSeeker_Icon_activated"))
      {
        icon.RemoveClass("BloodSeeker_Icon_activated")
        icon.AddClass("BloodSeeker_Icon")
      }
    }
  }
}




function puck_charge_change(kv)
{
  let main = $.GetContextPanel().FindChildTraverse("PuckCharge_Panel")
  if (main.BHasClass("PuckCharge_Panel_hidden"))
  {
    main.RemoveClass("PuckCharge_Panel_hidden")
    main.AddClass("PuckCharge_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("PuckCharge_Filler")

  let width = (kv.rage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("PuckCharge_Number")
  number.text = String(kv.rage)
}







function pangolier_stack_change(kv)
{
  let main = $.GetContextPanel().FindChildTraverse("PangolierStack_Panel")
  if (main.BHasClass("PangolierStack_Panel_hidden"))
  {
    main.RemoveClass("PangolierStack_Panel_hidden")
    main.AddClass("PangolierStack_Panel")
  }

  let dist = kv.stack_dist*kv.current + kv.current_dist

  dist = Math.min(dist, kv.max_dist)

  let filler = $.GetContextPanel().FindChildTraverse("PangolierStack_Filler")

  let width = (dist/kv.max_dist) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("PangolierStack_Number")
  number.text = String(kv.current)

  let icon = $.GetContextPanel().FindChildTraverse("PangolierStack_Icon")
  let bar = $.GetContextPanel().FindChildTraverse("PangolierStack_Bar")


  if (kv.current == kv.max_stack)
  {
    if (icon.BHasClass("PangolierStack_active") == false)
    {
      icon.AddClass("PangolierStack_active")
      bar.AddClass("PangolierStack_active")

    }
  }
  else 
  {
    if (icon.BHasClass("PangolierStack_active"))
    {
      icon.RemoveClass("PangolierStack_active")
      bar.RemoveClass("PangolierStack_active")

    }
  }
}














function beast_ulti_change(kv)
{
  let main = $.GetContextPanel().FindChildTraverse("BeastUlti_Panel")
  if (main.BHasClass("BeastUlti_Panel_hidden"))
  {
    main.RemoveClass("BeastUlti_Panel_hidden")
    main.AddClass("BeastUlti_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("BeastUlti_Filler")

  let width = (kv.rage/kv.max) * 95
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("BeastUlti_Number")
  number.text = String(kv.rage)
}




function qop_attack_change(kv)
{
  let main = $.GetContextPanel().FindChildTraverse("QopAttack_Panel")
  if (main.BHasClass("QopAttack_Panel_hidden"))
  {
    main.RemoveClass("QopAttack_Panel_hidden")
    main.AddClass("QopAttack_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("QopAttack_Filler")

  let width = Math.min((kv.rage/10) * 95, 95)
  let text = String(width)+'%'

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("QopAttack_Number")
  number.text = String(kv.rage)
}







function Templar_Refraction_shield(kv)
{

  let main = $.GetContextPanel().FindChildTraverse("Templar_Shield_Panel")
  if (main.BHasClass("Templar_Shield_Panel_hidden"))
  {
    main.RemoveClass("Templar_Shield_Panel_hidden")
    main.AddClass("Templar_Shield_Panel")
  }


  let filler = $.GetContextPanel().FindChildTraverse("Templar_Shield_Filler")

  let width = 95*(1 -  (kv.charges/kv.max))
  let text = String(width)+'%'
  if (kv.damage == 0)
  {
    text = '0%'
  }

  filler.style.width = text

  let number = $.GetContextPanel().FindChildTraverse("Templar_Shield_Number")
  number.text = String(kv.damage)
}




function Templar_Refraction_change(kv)
{
  let filler = $.GetContextPanel().FindChildTraverse("Templar_Shield_Filler")
  if (filler.BHasClass("Templar_Shield_Filler"))
  {
    filler.RemoveClass("Templar_Shield_Filler")
    filler.AddClass("Templar_Attack_Filler")
  }
  else 
  {
    filler.AddClass("Templar_Shield_Filler")
    filler.RemoveClass("Templar_Attack_Filler")

  }

  let bar = $.GetContextPanel().FindChildTraverse("Templar_Shield_Bar")
  if (bar.BHasClass("Templar_Shield_Bar"))
  {
    bar.RemoveClass("Templar_Shield_Bar")
    bar.AddClass("Templar_Attack_Bar")
  }
  else 
  {
    bar.AddClass("Templar_Shield_Bar")
    bar.RemoveClass("Templar_Attack_Bar")

  }


  let icon = $.GetContextPanel().FindChildTraverse("Templar_Shield_Icon")
  if (icon.BHasClass("Templar_Shield_Icon"))
  {
    icon.RemoveClass("Templar_Shield_Icon")
    icon.AddClass("Templar_Attack_Icon")
  }
  else 
  {
    icon.AddClass("Templar_Shield_Icon")
    icon.RemoveClass("Templar_Attack_Icon")

  }

}
















function OnProgress(data)
{
  $('#AlchemistPanel').visible = true
  $('#AlchemistNumber').text = data.current_gold + " / " + data.max_gold
  let gold_percentage = ((data.max_gold-data.current_gold)*95)/data.max_gold
  $('#AlchemistProgress').style['width'] = (95 - gold_percentage) +'%';
} 

function OnClose(data)
{
  $('#AlchemistPanel').visible = false
} 


init()

