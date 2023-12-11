LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom_debuff", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_goblins_greed_custom_anim", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )

alchemist_corrosive_weaponry_custom = class({})





function alchemist_corrosive_weaponry_custom:GetIntrinsicModifierName()
return "modifier_alchemist_corrosive_weaponry_custom"
end


function alchemist_corrosive_weaponry_custom:GetBehavior()
local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_greed_6") then 
	--bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

	if self:GetCaster():HasModifier("modifier_alchemist_greed_5") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + bonus
	end
    return DOTA_ABILITY_BEHAVIOR_PASSIVE + bonus
end

function alchemist_corrosive_weaponry_custom:GetManaCost(iLevel)
    return 0
end

function alchemist_corrosive_weaponry_custom:GetCooldown(iLevel)
	if self:GetCaster():HasModifier("modifier_alchemist_greed_5") then
    	return self:GetCaster():GetTalentValue("modifier_alchemist_greed_5", "cd")
    end
    return 0
end

function alchemist_corrosive_weaponry_custom:GetCastPoint()
	if self:GetCaster():HasModifier("modifier_alchemist_greed_5") then
    	return self:GetCaster():GetTalentValue("modifier_alchemist_greed_5", "cast")
    end
    return 0
end



function alchemist_corrosive_weaponry_custom:OnAbilityPhaseStart()


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_alchemist_goblins_greed_custom_anim", {})
self:GetCaster():StartGesture(ACT_DOTA_TAUNT)
return true
end

function alchemist_corrosive_weaponry_custom:OnAbilityPhaseInterrupted()
self:GetCaster():RemoveModifierByName("modifier_alchemist_goblins_greed_custom_anim")
self:GetCaster():FadeGesture(ACT_DOTA_TAUNT)

end

function alchemist_corrosive_weaponry_custom:OnSpellStart()
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_alchemist_goblins_greed_custom_anim")
self:GetCaster():FadeGesture(ACT_DOTA_TAUNT)

self:GetCaster():EmitSound("Alch.gold")


CreateRune(self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*120, DOTA_RUNE_BOUNTY)  

local effect_cast = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster(), self:GetCaster():GetPlayerOwner() )
ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )
end




function alchemist_corrosive_weaponry_custom:AddStack(target)
if not IsServer() then return end

local duration = self:GetSpecialValueFor("debuff_duration")

if self:GetCaster():HasModifier("modifier_alchemist_spray_5") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_alchemist_spray_5", "duration")
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

self.armor = self:GetCaster():GetTalentValue("modifier_alchemist_spray_4", "armor")
self.damage = self:GetCaster():GetTalentValue("modifier_alchemist_spray_4", "damage")
self.interval = self:GetCaster():GetTalentValue("modifier_alchemist_spray_4", "interval")

if not IsServer() then return end

self.max = self:GetAbility():GetSpecialValueFor("max_stacks")

if self:GetCaster():HasModifier("modifier_alchemist_spray_5") then 
	self.max = self.max + self:GetCaster():GetTalentValue("modifier_alchemist_spray_5", "max")
end

self:SetStackCount(1)


if self:GetCaster():HasModifier("modifier_alchemist_spray_4") then 
	self:StartIntervalThink(self.interval)
end

end


function modifier_alchemist_corrosive_weaponry_custom_debuff:OnIntervalThink()
if not IsServer() then return end 

local damage = self.damage*self:GetStackCount()*self.interval

local damageTable = { attacker = self:GetCaster(), damage = damage, victim = self:GetParent(), damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, ability = self:GetAbility(), }
ApplyDamage(damageTable)

end


function modifier_alchemist_corrosive_weaponry_custom_debuff:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max and self:GetCaster():HasModifier("modifier_alchemist_spray_4") then 

	self:GetParent():EmitSound("Hoodwink.Acorn_armor")
	self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end 


end


function modifier_alchemist_corrosive_weaponry_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierPhysicalArmorBonus()
if not self:GetCaster():HasModifier("modifier_alchemist_spray_4") then return end
return self.armor*self:GetStackCount()
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

 then return end
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