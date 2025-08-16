LinkLuaModifier("modifier_item_mask_of_madness_custom", "abilities/items/item_mask_of_madness_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mask_of_madness_custom_speed", "abilities/items/item_mask_of_madness_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mask_of_madness_custom_slow", "abilities/items/item_mask_of_madness_custom", LUA_MODIFIER_MOTION_NONE)

item_mask_of_madness_custom = class({})


function item_mask_of_madness_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items2_fx/mask_of_madness.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_monkey_king_spring_slow.vpcf", context )
PrecacheResource( "particle","particles/econ/items/drow/drow_head_mania/mask_of_madness_mania.vpcf", context )
PrecacheResource( "particle","particles/econ/items/drow/drow_head_mania/mask_of_madness_active_mania.vpcf", context )
end


function item_mask_of_madness_custom:GetAbilityTextureName()
if not self or not self:GetCaster() then return end 
if self:GetCaster():HasModifier("modifier_item_mask_of_madness_custom_speed") then
    return "items/mask_of_madness_active"
end
return "mask_of_madness"
end



function item_mask_of_madness_custom:GetIntrinsicModifierName()
	return "modifier_item_mask_of_madness_custom"
end

function item_mask_of_madness_custom:OnSpellStart()
local parent = self:GetParent()
local mod = parent:FindModifierByName("modifier_item_mask_of_madness_custom_speed")

if mod then
    mod:Destroy()
    return
end

self:EndCooldown()
self:StartCooldown(0.3)

parent:EmitSound("DOTA_Item.MaskOfMadness.Activate")
parent:AddNewModifier(parent, self, "modifier_item_mask_of_madness_custom_speed", {duration = self:GetSpecialValueFor("berserk_duration")})
end


modifier_item_mask_of_madness_custom = class({})

function modifier_item_mask_of_madness_custom:IsHidden() return true end
function modifier_item_mask_of_madness_custom:IsPurgable() return false end
function modifier_item_mask_of_madness_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_mask_of_madness_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end

function modifier_item_mask_of_madness_custom:OnCreated()

self.ability = self:GetAbility()
self.damage = self.ability:GetSpecialValueFor("bonus_damage")
self.lifesteal = self.ability:GetSpecialValueFor("lifesteal_percent")/100
self.lifesteal_creeps = self.ability:GetSpecialValueFor("creep_lifesteal_reduction_pct")/100
self.parent = self:GetParent()

if self.parent:IsRealHero() then 
    self.parent:AddDamageEvent_out(self, true)
end

end 


function modifier_item_mask_of_madness_custom:GetModifierPreAttack_BonusDamage()
return self.damage
end


function modifier_item_mask_of_madness_custom:DamageEvent_out(params)
if not IsServer() then return end 
if not self.parent:CheckLifesteal(params, 2) then return end

local heal = params.damage*self.lifesteal
if params.unit:IsCreep() then 
    heal = heal * (1 - self.lifesteal_creeps)
end 
self.parent:GenericHeal(heal, self.ability, true)
end 





modifier_item_mask_of_madness_custom_speed = class({})
function modifier_item_mask_of_madness_custom_speed:IsHidden() return false end
function modifier_item_mask_of_madness_custom_speed:IsPurgable() return true end

function modifier_item_mask_of_madness_custom_speed:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.speed = self.ability:GetSpecialValueFor("berserk_bonus_attack_speed")

self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
self.movespeed = self.ability:GetSpecialValueFor("berserk_bonus_movement_speed")
self.armor_reduce = self.ability:GetSpecialValueFor("armor_reduce")


if not IsServer() then return end

self.parent:AddAttackEvent_out(self, true)

local default_particle = "particles/items2_fx/mask_of_madness.vpcf"
if self:GetCaster():HasModifier("modifier_drow_ranger_madness_custom") then
    default_particle = "particles/econ/items/drow/drow_head_mania/mask_of_madness_mania.vpcf"
    local new_particle = ParticleManager:CreateParticle("particles/econ/items/drow/drow_head_mania/mask_of_madness_active_mania.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(new_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_mom_l", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(new_particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_mom_r", self:GetParent():GetAbsOrigin(), true)
    self:AddParticle(new_particle, false, false, -1, false, false)
end

local particle = ParticleManager:CreateParticle(default_particle, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(particle, false, false, -1, false, false)   
end

function modifier_item_mask_of_madness_custom_speed:OnDestroy()
if not IsServer() then return end
if self.ability and not self.ability:IsNull() then
    self.ability:UseResources(false, false, false, true)
end

end


function modifier_item_mask_of_madness_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_item_mask_of_madness_custom_speed:CheckState()
return
{
    [MODIFIER_STATE_SILENCED] = true
}
end

function modifier_item_mask_of_madness_custom_speed:GetModifierPhysicalArmorBonus()
return self.armor_reduce
end

function modifier_item_mask_of_madness_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_item_mask_of_madness_custom_speed:GetModifierMoveSpeedBonus_Constant()
return self.movespeed
end

function modifier_item_mask_of_madness_custom_speed:AttackEvent_out(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end 
if not IsValid(self.ability) then return end

params.target:AddNewModifier(self.parent, self.ability, "modifier_item_mask_of_madness_custom_slow", {duration = self.slow_duration*(1 - params.target:GetStatusResistance())})
end



modifier_item_mask_of_madness_custom_slow = class({})
function modifier_item_mask_of_madness_custom_slow:IsHidden() return false end
function modifier_item_mask_of_madness_custom_slow:IsPurgable() return true end
function modifier_item_mask_of_madness_custom_slow:OnCreated()
if not self:GetAbility() then self:Destroy() return end
self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_item_mask_of_madness_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_item_mask_of_madness_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_item_mask_of_madness_custom_slow:GetEffectName()
    return "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf"
end

function modifier_item_mask_of_madness_custom_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_mask_of_madness_custom_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_monkey_king_spring_slow.vpcf"
end

function modifier_item_mask_of_madness_custom_slow:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL 
end