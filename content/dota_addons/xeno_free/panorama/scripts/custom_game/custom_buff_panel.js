UpdateHeroHudBuffs();

function UpdateHeroHudBuffs()
{
	let hero_id = Players.GetLocalPlayerPortraitUnit()
	let hero = Entities.GetUnitName(hero_id)



	if ((hero === "npc_dota_hero_ogre_magi") && HasModifier(hero_id, "modifier_ogremagi_bloodlust_7") != false) {
        $("#BuffPanel").style.visibility = "visible"
    } else {
    	$("#BuffPanel").style.visibility = "collapse"
   	}

   	// Какой модификатор на каком месте
   	// Иконки прописываются в css
   	let modifier_1_id = HasModifier(hero_id, "modifier_ogre_magi_bloodlust_custom_legendary_1")
   	let modifier_2_id = HasModifier(hero_id, "modifier_ogre_magi_bloodlust_custom_legendary_2")
   	let modifier_3_id = HasModifier(hero_id, "modifier_ogre_magi_bloodlust_custom_legendary_3")
   	let modifier_4_id = HasModifier(hero_id, "modifier_ogre_magi_bloodlust_custom_legendary_4")
   	let modifier_5_id = HasModifier(hero_id, "modifier_ogre_magi_bloodlust_custom_legendary_5") 
	  let modifier_6_id = HasModifier(hero_id, "modifier_ogre_magi_bloodlust_custom_legendary_6") 

   	SetShowText($("#Buff_1"), $.Localize("#DOTA_Tooltip_modifier_ogre_magi_bloodlust_custom_legendary_1_Description"))
   	SetShowText($("#Buff_2"), $.Localize("#DOTA_Tooltip_modifier_ogre_magi_bloodlust_custom_legendary_2_Description"))
   	SetShowText($("#Buff_3"), $.Localize("#DOTA_Tooltip_modifier_ogre_magi_bloodlust_custom_legendary_3_Description"))
   	SetShowText($("#Buff_4"), $.Localize("#DOTA_Tooltip_modifier_ogre_magi_bloodlust_custom_legendary_4_Description"))
   	SetShowText($("#Buff_5"), $.Localize("#DOTA_Tooltip_modifier_ogre_magi_bloodlust_custom_legendary_5_Description"))
   	SetShowText($("#Buff_6"), $.Localize("#DOTA_Tooltip_modifier_ogre_magi_bloodlust_custom_legendary_6_Description"))

   	if ( modifier_1_id != false ) {
   		$("#Buff_1_icon").RemoveClass("DisableModifier")
   		let cooldown_time = Math.ceil(Buffs.GetRemainingTime(hero_id, modifier_1_id))
   		$("#Buff_1_cooldown").text = String(cooldown_time)
   		$("#Buff_1_cooldown_border").AddClass("CooldownBorderActive")
   	} else {
		$("#Buff_1_icon").AddClass("DisableModifier")
		$("#Buff_1_cooldown").text = "" 
		$("#Buff_1_cooldown_border").RemoveClass("CooldownBorderActive")
   	}

   	if ( modifier_2_id != false ) {
   		$("#Buff_2_icon").RemoveClass("DisableModifier")
   		let cooldown_time = Math.ceil(Buffs.GetRemainingTime(hero_id, modifier_2_id))
   		$("#Buff_2_cooldown").text = String(cooldown_time)
   		$("#Buff_2_cooldown_border").AddClass("CooldownBorderActive")
   	} else {
		$("#Buff_2_icon").AddClass("DisableModifier") 
		$("#Buff_2_cooldown").text = ""   	
		$("#Buff_2_cooldown_border").RemoveClass("CooldownBorderActive")	
   	}

   	if ( modifier_3_id != false ) {
   		$("#Buff_3_icon").RemoveClass("DisableModifier")
   		let cooldown_time = Math.ceil(Buffs.GetRemainingTime(hero_id, modifier_3_id))
   		$("#Buff_3_cooldown").text = String(cooldown_time)
   		$("#Buff_3_cooldown_border").AddClass("CooldownBorderActive")
   	} else {
		$("#Buff_3_icon").AddClass("DisableModifier")   
		$("#Buff_3_cooldown").text = "" 	
		$("#Buff_3_cooldown_border").RemoveClass("CooldownBorderActive")	
   	}

   	if ( modifier_4_id != false ) {
   		$("#Buff_4_icon").RemoveClass("DisableModifier")
   		let cooldown_time = Math.ceil(Buffs.GetRemainingTime(hero_id, modifier_4_id))
   		$("#Buff_4_cooldown").text = String(cooldown_time)
   		$("#Buff_4_cooldown_border").AddClass("CooldownBorderActive")
   	} else {
		$("#Buff_4_icon").AddClass("DisableModifier")   	
		$("#Buff_4_cooldown").text = "" 	
		$("#Buff_4_cooldown_border").RemoveClass("CooldownBorderActive")
   	}

   	if ( modifier_5_id != false ) {
   		$("#Buff_5_icon").RemoveClass("DisableModifier")
   		let cooldown_time = Math.ceil(Buffs.GetRemainingTime(hero_id, modifier_5_id))
   		$("#Buff_5_cooldown").text = String(cooldown_time)
   		$("#Buff_5_cooldown_border").AddClass("CooldownBorderActive")
   	} else {
		$("#Buff_5_icon").AddClass("DisableModifier")  
		$("#Buff_5_cooldown").text = "" 
		$("#Buff_5_cooldown_border").RemoveClass("CooldownBorderActive")		
   	} 
 
   	if ( modifier_6_id != false ) {
   		$("#Buff_6_icon").RemoveClass("DisableModifier")
   		let cooldown_time = Math.ceil(Buffs.GetRemainingTime(hero_id, modifier_6_id))
   		$("#Buff_6_cooldown").text = String(cooldown_time)
   		$("#Buff_6_cooldown_border").AddClass("CooldownBorderActive")
   	} else {
		$("#Buff_6_icon").AddClass("DisableModifier")   
		$("#Buff_6_cooldown").text = "" 
		$("#Buff_6_cooldown_border").RemoveClass("CooldownBorderActive")		
   	} 

	$.Schedule(1/144, UpdateHeroHudBuffs)
}

function SetShowText(panel, text)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, $.Localize(text)); });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}

function HasModifier(unit, modifier) {
    for (var i = 0; i < Entities.GetNumBuffs(unit); i++) {
        if (Buffs.GetName(unit, Entities.GetBuff(unit, i)) == modifier){
            return Entities.GetBuff(unit, i)
        }
    }
	return false
}