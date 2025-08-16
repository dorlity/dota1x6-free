LinkLuaModifier("modifier_item_sange_and_yasha_custom", "abilities/items/item_sange_and_yasha_custom", LUA_MODIFIER_MOTION_NONE)

item_sange_and_yasha_custom = class({})

function item_sange_and_yasha_custom:GetIntrinsicModifierName() 
return "modifier_item_sange_and_yasha_custom" 
end




modifier_item_sange_and_yasha_custom = class({})
function modifier_item_sange_and_yasha_custom:IsHidden() return true end
function modifier_item_sange_and_yasha_custom:IsPurgable() return false end
function modifier_item_sange_and_yasha_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_sange_and_yasha_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_item_sange_and_yasha_custom:GetModifierBonusStats_Strength() 
return self.str
end

function modifier_item_sange_and_yasha_custom:GetModifierBonusStats_Agility()
return self.agi
end

function modifier_item_sange_and_yasha_custom:GetModifierStatusResistanceStacking() 
return self.status_bonus
end

function modifier_item_sange_and_yasha_custom:GetModifierAttackSpeedBonus_Constant()
return self.attack_speed
end

function modifier_item_sange_and_yasha_custom:GetModifierMoveSpeedBonus_Percentage() 
if self.parent:HasModifier("modifier_item_yasha") then return end
if self.parent:HasModifier("modifier_item_yasha_and_kaya") then return end
return self.move_bonus
end

function modifier_item_sange_and_yasha_custom:GetModifierLifestealRegenAmplify_Percentage() 
if self.parent:HasModifier("modifier_item_abyssal_blade_custom") then return end
if self.parent:HasModifier("modifier_item_kaya_and_sange_custom") then return end
return self.heal_amp
end

function modifier_item_sange_and_yasha_custom:GetModifierHealAmplify_PercentageTarget() 
if self.parent:HasModifier("modifier_item_abyssal_blade_custom") then return end
if self.parent:HasModifier("modifier_item_kaya_and_sange_custom") then return end
return self.heal_amp
end

function modifier_item_sange_and_yasha_custom:GetModifierHPRegenAmplify_Percentage() 
if self.parent:HasModifier("modifier_item_abyssal_blade_custom") then return end
if self.parent:HasModifier("modifier_item_kaya_and_sange_custom") then return end
return self.heal_amp
end

function modifier_item_sange_and_yasha_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.str = self.ability:GetSpecialValueFor("bonus_str")
self.agi = self.ability:GetSpecialValueFor("bonus_agi")
self.status_bonus = self.ability:GetSpecialValueFor("status_bonus")
self.attack_speed = self.ability:GetSpecialValueFor("attack_speed")
self.move_bonus = self.ability:GetSpecialValueFor("move_bonus")
self.heal_amp = self.ability:GetSpecialValueFor("heal_amp")

if not IsServer() then return end
self.mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_sange", {})
end


function modifier_item_sange_and_yasha_custom:OnDestroy()
if not IsServer() then return end
if not self.mod or self.mod:IsNull() then return end
self.mod:Destroy()
end
