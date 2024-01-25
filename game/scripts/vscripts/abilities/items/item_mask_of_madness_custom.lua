LinkLuaModifier("modifier_item_mask_of_madness_custom", "abilities/items/item_mask_of_madness_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mask_of_madness_custom_speed", "abilities/items/item_mask_of_madness_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mask_of_madness_custom_slow", "abilities/items/item_mask_of_madness_custom", LUA_MODIFIER_MOTION_NONE)

item_mask_of_madness_custom = class({})

function item_mask_of_madness_custom:GetIntrinsicModifierName()
	return "modifier_item_mask_of_madness_custom"
end

function item_mask_of_madness_custom:OnSpellStart()
if not IsServer() then return end


self:GetParent():EmitSound("DOTA_Item.MaskOfMadness.Activate")
self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_item_mask_of_madness_custom_speed", {duration = self:GetSpecialValueFor("berserk_duration")})
end


modifier_item_mask_of_madness_custom = class({})

function modifier_item_mask_of_madness_custom:IsHidden() return true end
function modifier_item_mask_of_madness_custom:IsPurgable() return false end
function modifier_item_mask_of_madness_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_mask_of_madness_custom:DeclareFunctions()
local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
}

return funcs
end

function modifier_item_mask_of_madness_custom:OnCreated()

self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
self.lifesteal = self:GetAbility():GetSpecialValueFor("lifesteal_percent")/100
self.lifesteal_creeps = self:GetAbility():GetSpecialValueFor("creep_lifesteal_reduction_pct")/100
self.parent = self:GetParent()
end 


function modifier_item_mask_of_madness_custom:GetModifierPreAttack_BonusDamage()
return self.damage
end



function modifier_item_mask_of_madness_custom:OnTakeDamage(params)
if not IsServer() then return end 
if not params.attacker then return end 
if self.parent ~= params.attacker then return end 
if not params.unit:IsHero() and not params.unit:IsCreep() then return end 
if params.inflictor then return end
if self.parent == params.unit then return end

local heal = params.damage*self.lifesteal

if params.unit:IsCreep() then 
    heal = heal * (1 - self.lifesteal_creeps)
end 

self.parent:GenericHeal(heal, self:GetAbility(), true)
end 





modifier_item_mask_of_madness_custom_speed = class({})
function modifier_item_mask_of_madness_custom_speed:IsHidden() return false end
function modifier_item_mask_of_madness_custom_speed:IsPurgable() return true end

function modifier_item_mask_of_madness_custom_speed:OnCreated(table)
self.speed = self:GetAbility():GetSpecialValueFor("berserk_bonus_attack_speed")

self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")
self.movespeed = self:GetAbility():GetSpecialValueFor("berserk_bonus_movement_speed")
self.armor_max = self:GetAbility():GetSpecialValueFor("armor_max")
self.armor_inc = self:GetAbility():GetSpecialValueFor("armor_inc")*-1

self.ability = self:GetAbility()
self.parent = self:GetParent()

if not IsServer() then return end

local particle = ParticleManager:CreateParticle("particles/items2_fx/mask_of_madness.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(particle, false, false, -1, false, false)   

self:OnIntervalThink()
self:StartIntervalThink(1 + FrameTime())
end

function modifier_item_mask_of_madness_custom_speed:OnIntervalThink()
if not IsServer() then return end 

self:IncrementStackCount()
end


function modifier_item_mask_of_madness_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
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
return self.armor_inc*self:GetStackCount()
end


function modifier_item_mask_of_madness_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_item_mask_of_madness_custom_speed:GetModifierMoveSpeedBonus_Constant()
return self.movespeed
end



function modifier_item_mask_of_madness_custom_speed:OnAttackLanded(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 
if not self:GetAbility() then return end

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
    return 11111
end