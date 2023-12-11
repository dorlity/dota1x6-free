LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom_debuff", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_anim", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )

alchemist_corrosive_weaponry_custom = class({})

alchemist_corrosive_weaponry_custom.damage_tick = {6,9,12}
alchemist_corrosive_weaponry_custom.damage_tick_interval = 0.5

alchemist_corrosive_weaponry_custom.damage_reduction = {-1,-1.5,-2}
alchemist_corrosive_weaponry_custom.damage_heal = {-1, -1.5, -2}

alchemist_corrosive_weaponry_custom.weapon_damage = {2, 3}


alchemist_corrosive_weaponry_custom.duration_inc = {1, 1.5, 2}
alchemist_corrosive_weaponry_custom.max_inc = {2, 3, 4}

alchemist_corrosive_weaponry_custom.armor_inc = {-0.8, -1.2, -1.6}


alchemist_corrosive_weaponry_custom.active_manacost = 0
alchemist_corrosive_weaponry_custom.active_cooldown = 100
alchemist_corrosive_weaponry_custom.active_channel_time = 1.5


function alchemist_corrosive_weaponry_custom:GetIntrinsicModifierName()
return "modifier_alchemist_corrosive_weaponry_custom"
end


function alchemist_corrosive_weaponry_custom:GetBehavior()
	if self:GetCaster():HasModifier("modifier_alchemist_greed_5") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
	end
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function alchemist_corrosive_weaponry_custom:GetManaCost(iLevel)
	if self:GetCaster():HasModifier("modifier_alchemist_greed_5") then
    	return self.active_manacost
    end
    return 0
end

function alchemist_corrosive_weaponry_custom:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_alchemist_greed_5") then
    	return self.active_cooldown
    end
    return 0
end

function alchemist_corrosive_weaponry_custom:GetChannelTime()
	if self:GetCaster():HasModifier("modifier_alchemist_greed_5") then
    	return self.active_channel_time
    end
    return 0
end

function alchemist_corrosive_weaponry_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_alchemist_goblins_greed_custom_anim", {duration = self.active_channel_time})
	self:GetCaster():StartGesture(ACT_DOTA_TAUNT)
	self:EndCooldown()
end

function alchemist_corrosive_weaponry_custom:OnChannelFinish(bInterrupted)
	if not IsServer() then return end
	self:GetCaster():FadeGesture(ACT_DOTA_TAUNT)
	self:GetCaster():RemoveModifierByName("modifier_alchemist_goblins_greed_custom_anim")
	self:UseResources(false, false, false, true)
	if bInterrupted then return end
	local particle = 4
	self:GetCaster():EmitSound("Alch.gold")

	
	CreateRune(self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*120, DOTA_RUNE_BOUNTY)  

	local effect_cast = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster():GetPlayerOwner() )
	ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end



function alchemist_corrosive_weaponry_custom:AddStack(target)
if not IsServer() then return end

local duration = self:GetSpecialValueFor("debuff_duration")

if self:GetCaster():HasModifier("modifier_alchemist_unstable_1") then 
	duration = duration + self.duration_inc[self:GetCaster():GetUpgradeStack("modifier_alchemist_unstable_1")]
end

target:AddNewModifier(self:GetCaster(), self, "modifier_alchemist_corrosive_weaponry_custom_debuff", {duration = duration})

end


modifier_alchemist_corrosive_weaponry_custom = class({})
function modifier_alchemist_corrosive_weaponry_custom:IsHidden() return true end
function modifier_alchemist_corrosive_weaponry_custom:IsPurgable() return false end
function modifier_alchemist_corrosive_weaponry_custom:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_alchemist_corrosive_weaponry_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent():IsIllusion() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:GetAbility():AddStack(params.target)
end


modifier_alchemist_corrosive_weaponry_custom_debuff = class({})

function modifier_alchemist_corrosive_weaponry_custom_debuff:IsHidden() return false end
function modifier_alchemist_corrosive_weaponry_custom_debuff:IsPurgable() return true end
function modifier_alchemist_corrosive_weaponry_custom_debuff:OnCreated(table)

self.move = self:GetAbility():GetSpecialValueFor("slow_per_stack")
self.status = self:GetAbility():GetSpecialValueFor("status_resist_per_stack")
self.bonus = self:GetAbility():GetSpecialValueFor("chemical_bonus")

if not IsServer() then return end

self.max = self:GetAbility():GetSpecialValueFor("max_stacks")

if self:GetCaster():HasModifier("modifier_alchemist_unstable_1") then 
	self.max = self.max + self:GetAbility().max_inc[self:GetCaster():GetUpgradeStack("modifier_alchemist_unstable_1")]
end

self:SetStackCount(1)


if self:GetCaster():HasModifier("modifier_alchemist_unstable_3") then 
	self:StartIntervalThink(self:GetAbility().damage_tick_interval)
end

end


function modifier_alchemist_corrosive_weaponry_custom_debuff:OnIntervalThink()
if not IsServer() then return end 

local damage = self:GetAbility().damage_tick[self:GetCaster():GetUpgradeStack("modifier_alchemist_unstable_3")]*self:GetStackCount()*self:GetAbility().damage_tick_interval

local damageTable = { attacker = self:GetCaster(), damage = damage, victim = self:GetParent(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), }
ApplyDamage(damageTable)

end


function modifier_alchemist_corrosive_weaponry_custom_debuff:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_alchemist_corrosive_weaponry_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
   	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
 	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
 	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierPhysicalArmorBonus()
if not self:GetCaster():HasModifier("modifier_alchemist_rage_2") then return end
return self:GetAbility().armor_inc[self:GetCaster():GetUpgradeStack("modifier_alchemist_rage_2")]*self:GetStackCount()
end



function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierIncomingDamage_Percentage(params)
if not self:GetCaster():HasModifier("modifier_alchemist_unstable_4") then return end
if not params.inflictor then return end

return self:GetAbility().weapon_damage[self:GetCaster():GetUpgradeStack("modifier_alchemist_unstable_4")]*self:GetStackCount()

end


function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierTotalDamageOutgoing_Percentage()
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
return self:GetAbility().damage_reduction[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_2")]*self:GetStackCount()
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
return self:GetAbility().damage_heal[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_2")]*self:GetStackCount()
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierHealAmplify_PercentageTarget() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
return self:GetAbility().damage_heal[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_2")]*self:GetStackCount()
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierHPRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
return self:GetAbility().damage_heal[self:GetCaster():GetUpgradeStack("modifier_alchemist_spray_2")]*self:GetStackCount()
end



function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierStatusResistanceStacking() 
local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_chemical_rage_custom") then
 	bonus = self.bonus
end

  return (self.status + bonus)*self:GetStackCount()
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierMoveSpeedBonus_Percentage()

local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_chemical_rage_custom") then
 	bonus = self.bonus
end


  return (self.move + bonus)*self:GetStackCount()
end


function modifier_alchemist_corrosive_weaponry_custom_debuff:GetEffectName()
return "particles/units/heroes/hero_alchemist/alchemist_corrosive_weaponry.vpcf"

end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_alchemist_corrosive_weaponry.vpcf"

end
function modifier_alchemist_corrosive_weaponry_custom_debuff:StatusEffectPriority()
return 100

end


modifier_alchemist_goblins_greed_custom_anim = class({})

function modifier_alchemist_goblins_greed_custom_anim:IsHidden() return true end
function modifier_alchemist_goblins_greed_custom_anim:IsPurgable() return false end
function modifier_alchemist_goblins_greed_custom_anim:DeclareFunctions() return {MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS} end
function modifier_alchemist_goblins_greed_custom_anim:GetActivityTranslationModifiers() return "ogre_hop_gesture" end