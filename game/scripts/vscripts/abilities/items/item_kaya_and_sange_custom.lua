LinkLuaModifier("modifier_item_kaya_and_sange_custom", "abilities/items/item_kaya_and_sange_custom", LUA_MODIFIER_MOTION_NONE)

item_kaya_and_sange_custom = class({})

function item_kaya_and_sange_custom:GetIntrinsicModifierName() 
return "modifier_item_kaya_and_sange_custom" 
end




modifier_item_kaya_and_sange_custom = class({})
function modifier_item_kaya_and_sange_custom:IsHidden() return true end
function modifier_item_kaya_and_sange_custom:IsPurgable() return false end
function modifier_item_kaya_and_sange_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,

    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_item_kaya_and_sange_custom:GetModifierBonusStats_Strength() 
return self.str
end

function modifier_item_kaya_and_sange_custom:GetModifierBonusStats_Intellect()
return self.int
end

function modifier_item_kaya_and_sange_custom:GetModifierSpellAmplify_Percentage() 
if self.parent:HasModifier("modifier_item_yasha_and_kaya") then return end 
if self.parent:HasModifier("modifier_item_kaya") then return end
return self.spell_damage
end

function modifier_item_kaya_and_sange_custom:GetModifierMPRegenAmplify_Percentage()
if self.parent:HasModifier("modifier_item_yasha_and_kaya") then return end 
if self.parent:HasModifier("modifier_item_kaya") then return end
return self.regen_amp
end

function modifier_item_kaya_and_sange_custom:GetModifierPercentageManacostStacking()
return self.mana_reduce
end

function modifier_item_kaya_and_sange_custom:GetModifierLifestealRegenAmplify_Percentage() 
if self.parent:HasModifier("modifier_item_abyssal_blade_custom") then return end
return self.heal_amp
end

function modifier_item_kaya_and_sange_custom:GetModifierHealAmplify_PercentageTarget() 
if self.parent:HasModifier("modifier_item_abyssal_blade_custom") then return end
return self.heal_amp
end

function modifier_item_kaya_and_sange_custom:GetModifierHPRegenAmplify_Percentage() 
if self.parent:HasModifier("modifier_item_abyssal_blade_custom") then return end
return self.heal_amp
end

function modifier_item_kaya_and_sange_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.str = self.ability:GetSpecialValueFor("bonus_str")
self.int = self.ability:GetSpecialValueFor("bonus_int")
self.spell_damage = self.ability:GetSpecialValueFor("spell_damage")
self.mana_reduce = self.ability:GetSpecialValueFor("mana_reduce")
self.regen_amp = self.ability:GetSpecialValueFor("regen_amp")
self.heal_amp = self.ability:GetSpecialValueFor("heal_amp")

if not IsServer() then return end
self.mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_sange", {})
end


function modifier_item_kaya_and_sange_custom:OnDestroy()
if not IsServer() then return end
if not self.mod or self.mod:IsNull() then return end
self.mod:Destroy()
end
