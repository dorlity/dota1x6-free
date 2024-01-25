LinkLuaModifier("modifier_troll_warlord_fervor_custom", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_speed", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_armor", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_max", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_legendary", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_legendary_damage", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_legendary_timer", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_fervor_custom_incoming", "abilities/troll_warlord/troll_warlord_fervor_custom", LUA_MODIFIER_MOTION_NONE)



troll_warlord_fervor_custom = class({})


troll_warlord_fervor_custom.incoming_damage = {-6,-9,-12}
troll_warlord_fervor_custom.incoming_duration = 1

troll_warlord_fervor_custom.armor_duration = 2
troll_warlord_fervor_custom.armor_max_init = 2
troll_warlord_fervor_custom.armor_max_inc = 2
troll_warlord_fervor_custom.armor_armor = -1

troll_warlord_fervor_custom.max_duration_init = 1
troll_warlord_fervor_custom.max_duration_inc = 2
troll_warlord_fervor_custom.max_bva = 1.2





function troll_warlord_fervor_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_hands_glow.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_v2_omni.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_rampage.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_rampage_resistance_buff.vpcf", context )
PrecacheResource( "particle", "particles/troll_fervor_buf.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", context )
end






function troll_warlord_fervor_custom:GetIntrinsicModifierName()
	return "modifier_troll_warlord_fervor_custom"
end

function troll_warlord_fervor_custom:GetCooldown(level)
	if self:GetCaster():HasModifier("modifier_troll_fervor_legendary") then
		return self:GetCaster():GetTalentValue("modifier_troll_fervor_legendary", "cd")
	end
	return 0
end


function troll_warlord_fervor_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_troll_fervor_legendary") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function troll_warlord_fervor_custom:OnSpellStart()
if not IsServer() then return end
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_fervor_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_troll_fervor_legendary", "duration")})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_fervor_custom_legendary_timer", {duration = self:GetCaster():GetTalentValue("modifier_troll_fervor_legendary", "timer")})
end

modifier_troll_warlord_fervor_custom = class({})

function modifier_troll_warlord_fervor_custom:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom:RemoveOnDeath() return false end
function modifier_troll_warlord_fervor_custom:IsHidden() return true end




function modifier_troll_warlord_fervor_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end



function modifier_troll_warlord_fervor_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_troll_fervor_6") then return end 
if self:GetParent():IsRangedAttacker() then return end 

return self:GetCaster():GetTalentValue("modifier_troll_fervor_6",  "range")
end


function modifier_troll_warlord_fervor_custom:OnAttackLanded( params )
if not IsServer() then return end
if params.attacker~=self:GetParent() then return end
if params.no_attack_cooldown then return end


local duration = self:GetAbility():GetSpecialValueFor("duration")


if self:GetParent():HasModifier("modifier_troll_fervor_3") then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_armor", {duration = self:GetAbility().armor_duration})
end

if self:GetParent():HasModifier("modifier_troll_fervor_2") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_incoming", {duration = self:GetAbility().incoming_duration})
end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_speed", {target =  params.target:entindex(), duration = duration})
end





modifier_troll_warlord_fervor_custom_speed = class({})

function modifier_troll_warlord_fervor_custom_speed:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_speed:RemoveOnDeath() return false end
function modifier_troll_warlord_fervor_custom_speed:IsHidden() return self:GetStackCount() == 0 end

function modifier_troll_warlord_fervor_custom_speed:OnCreated(table)

self.stack_multiplier = self:GetAbility():GetSpecialValueFor("attack_speed")
self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")


self.move = self:GetCaster():GetTalentValue("modifier_troll_fervor_1", "move")
self.status = self:GetCaster():GetTalentValue("modifier_troll_fervor_1", "status")
self.more_speed = self:GetCaster():GetTalentValue("modifier_troll_fervor_6", "speed")

if not IsServer() then return end


self:SetStackCount(0)

if self:GetCaster():HasModifier("modifier_troll_fervor_6") then 
	self:SetStackCount(self:GetCaster():GetTalentValue("modifier_troll_fervor_6", "stack"))
end

self.currentTarget = table.target



self.str = 0
self.str_percentage = self:GetCaster():GetTalentValue("modifier_troll_fervor_5", "str")/100

if self:GetCaster():HasModifier("modifier_troll_fervor_5") then 
	self:StartIntervalThink(0.2)
end 


end




function modifier_troll_warlord_fervor_custom_speed:OnRefresh(table)
if not IsServer() then return end
	if self.currentTarget == table.target then 
		self:MoreStack()
	else 
		if self.particle then
			ParticleManager:DestroyParticle(self.particle, false)
			ParticleManager:ReleaseParticleIndex(self.particle)
		end

		self:OnCreated(table)
	end


end


function modifier_troll_warlord_fervor_custom_speed:OnDestroy()
if not IsServer() then return end


end


function modifier_troll_warlord_fervor_custom_speed:MoreStack()
if not IsServer() then return end
if self:GetStackCount() >= self.max_stacks then  return end

self:IncrementStackCount()

if self:GetParent():HasModifier("modifier_troll_fervor_4") and self:GetStackCount() == self.max_stacks then 

	local duration = self:GetCaster():GetTalentValue("modifier_troll_fervor_4", "duration")
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_max", {duration = duration})

end


if self:GetStackCount() >= self.max_stacks and self:GetParent():HasModifier("modifier_troll_fervor_5") then 
	self:GetParent():EmitSound("BS.Bloodrite_purge")
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_debuff_immune", {effect = 1, duration = self:GetCaster():GetTalentValue("modifier_troll_fervor_5", "bkb")})
end 

end 


function modifier_troll_warlord_fervor_custom_speed:DeclareFunctions()
local funcs = 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

	return funcs
end




function modifier_troll_warlord_fervor_custom_speed:OnIntervalThink()
if not IsServer() then return end

self.str  = 0

self.str   = self:GetParent():GetStrength() * self.str_percentage * self:GetStackCount()

self:GetParent():CalculateStatBonus(true)

end

function modifier_troll_warlord_fervor_custom_speed:GetModifierBonusStats_Strength()
if not self:GetParent():HasModifier("modifier_troll_fervor_5") then return end
return self.str
end


function modifier_troll_warlord_fervor_custom_speed:GetModifierAttackSpeedBonus_Constant()
	if self:GetParent():PassivesDisabled() then return 0 end
	local bonus = 0
	if self:GetCaster():HasModifier("modifier_troll_fervor_6") then 
		bonus = self.more_speed
	end

	return self:GetStackCount() * (self.stack_multiplier + bonus)
end



function modifier_troll_warlord_fervor_custom_speed:GetModifierMoveSpeedBonus_Percentage()
if self:GetParent():PassivesDisabled() then return 0 end
	local bonus = 0
	if self:GetCaster():HasModifier("modifier_troll_fervor_1") then 
		bonus = self.move
	end

	return self:GetStackCount() * bonus
end



function modifier_troll_warlord_fervor_custom_speed:GetModifierStatusResistanceStacking() 
if self:GetParent():PassivesDisabled() then return 0 end
	local bonus = 0
	if self:GetCaster():HasModifier("modifier_troll_fervor_1") then 
		bonus = self.status
	end

	return self:GetStackCount() * bonus
end





modifier_troll_warlord_fervor_custom_armor = class({})

function modifier_troll_warlord_fervor_custom_armor:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_armor:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_armor:GetTexture() return "buffs/fervor_armor" end

function modifier_troll_warlord_fervor_custom_armor:OnCreated(table)
self.max = self:GetAbility().armor_max_init + self:GetAbility().armor_max_inc*self:GetCaster():GetUpgradeStack("modifier_troll_fervor_3")
if not IsServer() then return end
	self:SetStackCount(1)
end

function modifier_troll_warlord_fervor_custom_armor:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() < self.max then 
	self:IncrementStackCount()
end
end

function modifier_troll_warlord_fervor_custom_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_troll_warlord_fervor_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount() * self:GetAbility().armor_armor
end


modifier_troll_warlord_fervor_custom_max  = class({})
function modifier_troll_warlord_fervor_custom_max:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_max:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_max:GetTexture() return "buffs/fervor_max" end

function modifier_troll_warlord_fervor_custom_max:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end




function modifier_troll_warlord_fervor_custom_max:GetModifierBaseAttackTimeConstant()
return self.bva
end




function modifier_troll_warlord_fervor_custom_max:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

if not RollPseudoRandomPercentage(self.chance, 543, self:GetParent()) then return end


params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = (1 - params.target:GetStatusResistance())*self.stun})
params.target:EmitSound("Ogre.Bloodlust_hit")


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0,  params.target:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(300,0,0) )



end










function modifier_troll_warlord_fervor_custom_max:OnCreated(table)


self.bva = self:GetCaster():GetTalentValue("modifier_troll_fervor_4", "bva")
self.chance = self:GetCaster():GetTalentValue("modifier_troll_fervor_4", "chance")
self.stun = self:GetCaster():GetTalentValue("modifier_troll_fervor_4", "stun")
	
if not IsServer() then return end

self:GetParent():EmitSound("Troll.Fervor_max")
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle, false, false, -1, false, false)

self.effect_impact = ParticleManager:CreateParticle( "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_hands_glow.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
ParticleManager:SetParticleControlEnt(self.effect_impact, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.effect_impact, false, false, -1, false, false)
end





modifier_troll_warlord_fervor_custom_legendary = class({})
function modifier_troll_warlord_fervor_custom_legendary:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_legendary:IsPurgable() return false end

function modifier_troll_warlord_fervor_custom_legendary:GetTexture() return "buffs/warpath_lowhp" end

function modifier_troll_warlord_fervor_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.duration = self:GetCaster():GetTalentValue("modifier_troll_fervor_legendary", "damage_duration")

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_troll_warlord/troll_warlord_rampage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:ReleaseParticleIndex(particle)

self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4)
self:GetParent():EmitSound("Troll.Fervor_legendary")

local parent = self:GetParent()

parent:EmitSound("Troll.Fervor_legendary_alt") 

parent:EmitSound("Troll.Fervor_voice")


self.particle_peffect = ParticleManager:CreateParticle("particles/troll_fervor_buf.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end





function modifier_troll_warlord_fervor_custom_legendary:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_troll_warlord_fervor_custom_legendary_timer")

if mod then 
	mod:Destroy()
end

local ability = self:GetParent():FindAbilityByName("troll_warlord_berserkers_rage_custom")
if ability then 
	--ability:SetActivated(true)
end
end

function modifier_troll_warlord_fervor_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end



function modifier_troll_warlord_fervor_custom_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_troll_warlord_fervor_custom_legendary_damage", {duration = self.duration})

end






modifier_troll_warlord_fervor_custom_legendary_timer = class({})
function modifier_troll_warlord_fervor_custom_legendary_timer:IsHidden() return true end
function modifier_troll_warlord_fervor_custom_legendary_timer:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_legendary_timer:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_START
}

end

function modifier_troll_warlord_fervor_custom_legendary_timer:OnAttackStart(params)
if self:GetParent() ~= params.attacker then return end

self:SetDuration(self.timer, true)
end


function modifier_troll_warlord_fervor_custom_legendary_timer:OnCreated()
self.timer = self:GetCaster():GetTalentValue("modifier_troll_fervor_legendary", "timer")
end

function modifier_troll_warlord_fervor_custom_legendary_timer:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_troll_warlord_fervor_custom_legendary")

if mod then 
	self:GetParent():RemoveModifierByName("modifier_troll_warlord_fervor_custom_legendary_damage")
	mod:Destroy()
	self:GetParent():EmitSound("Troll.Fervor_legendary_stun")
	local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0,  self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetCaster():GetTalentValue("modifier_troll_fervor_legendary", "stun")*(1 - self:GetParent():GetStatusResistance())})
end

end






modifier_troll_warlord_fervor_custom_incoming = class({})
function modifier_troll_warlord_fervor_custom_incoming:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_incoming:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_incoming:GetTexture() return "buffs/fervor_damage" end


function modifier_troll_warlord_fervor_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_troll_warlord_fervor_custom_incoming:GetModifierIncomingDamage_Percentage()
	return self:GetAbility().incoming_damage[self:GetParent():GetUpgradeStack("modifier_troll_fervor_2")]
end



modifier_troll_warlord_fervor_custom_legendary_damage = class({})

function modifier_troll_warlord_fervor_custom_legendary_damage:IsHidden() return false end
function modifier_troll_warlord_fervor_custom_legendary_damage:IsPurgable() return false end
function modifier_troll_warlord_fervor_custom_legendary_damage:GetEffectName() return 
"particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity.vpcf"
end
function modifier_troll_warlord_fervor_custom_legendary_damage:GetStatusEffectName() return 
"particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_v2_omni.vpcf"
end

function modifier_troll_warlord_fervor_custom_legendary_damage:StatusEffectPriority() return 20 end

function modifier_troll_warlord_fervor_custom_legendary_damage:GetTexture() return "buffs/warpath_lowhp" end

function modifier_troll_warlord_fervor_custom_legendary_damage:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_troll_fervor_legendary", "damage")

if not IsServer() then return end

self:SetStackCount(1)

self.particle_burn = ParticleManager:CreateParticle("particles/units/heroes/hero_troll_warlord/troll_warlord_rampage_resistance_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_burn, false, false, -1, false, false)

end


function modifier_troll_warlord_fervor_custom_legendary_damage:OnRefresh()
if not IsServer() then return end 

self:IncrementStackCount()
end 

function modifier_troll_warlord_fervor_custom_legendary_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end



function modifier_troll_warlord_fervor_custom_legendary_damage:GetModifierPreAttack_BonusDamage()
	return self.damage*self:GetStackCount()
end

