LinkLuaModifier("modifier_item_sange_custom", "abilities/items/item_sange_custom", LUA_MODIFIER_MOTION_NONE)

item_sange_custom = class({})

function item_sange_custom:GetIntrinsicModifierName() 
return "modifier_item_sange_custom" 
end




modifier_item_sange_custom = class({})
function modifier_item_sange_custom:IsHidden() return true end
function modifier_item_sange_custom:IsPurgable() return false end
function modifier_item_sange_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_sange_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_item_sange_custom:GetModifierBonusStats_Strength() 
return self.str
end

function modifier_item_sange_custom:GetModifierLifestealRegenAmplify_Percentage() 
if self.parent:HasModifier("modifier_item_abyssal_blade_custom") then return end
if self.parent:HasModifier("modifier_item_sange_and_yasha_custom") then return end
if self.parent:HasModifier("modifier_item_kaya_and_sange_custom") then return end
return self.heal_amp
end

function modifier_item_sange_custom:GetModifierHealAmplify_PercentageTarget() 
if self.parent:HasModifier("modifier_item_abyssal_blade_custom") then return end
if self.parent:HasModifier("modifier_item_sange_and_yasha_custom") then return end
if self.parent:HasModifier("modifier_item_kaya_and_sange_custom") then return end
return self.heal_amp
end

function modifier_item_sange_custom:GetModifierHPRegenAmplify_Percentage() 
if self.parent:HasModifier("modifier_item_abyssal_blade_custom") then return end
if self.parent:HasModifier("modifier_item_sange_and_yasha_custom") then return end
if self.parent:HasModifier("modifier_item_kaya_and_sange_custom") then return end
return self.heal_amp
end

function modifier_item_sange_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.str = self.ability:GetSpecialValueFor("bonus_str")
self.heal_amp = self.ability:GetSpecialValueFor("heal_amp")

if not IsServer() then return end
self.mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_sange", {})
end


function modifier_item_sange_custom:OnDestroy()
if not IsServer() then return end
if not self.mod or self.mod:IsNull() then return end
self.mod:Destroy()
end
