LinkLuaModifier("modifier_legion_commander_arcana_custom_2", "modifiers/hero_items/modifier_legion_commander_arcana_custom", LUA_MODIFIER_MOTION_NONE)
modifier_legion_commander_arcana_custom = class({})
function modifier_legion_commander_arcana_custom:IsHidden() return true end
function modifier_legion_commander_arcana_custom:IsPurgable() return false end
function modifier_legion_commander_arcana_custom:IsPurgeException() return false end
function modifier_legion_commander_arcana_custom:RemoveOnDeath() return false end
function modifier_legion_commander_arcana_custom:OnCreated()
    if not IsServer() then return end
    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_legion_commander_arcana_custom_2", {})
end
function modifier_legion_commander_arcana_custom:OnDestroy()
    if not IsServer() then return end
    self:GetParent():RemoveModifierByName("modifier_legion_commander_arcana_custom_2")
end
function modifier_legion_commander_arcana_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_legion_commander_arcana_custom:GetActivityTranslationModifiers()
    return "dualwield"
end
modifier_legion_commander_arcana_custom_2 = class({})
function modifier_legion_commander_arcana_custom_2:IsHidden() return true end
function modifier_legion_commander_arcana_custom_2:IsPurgable() return false end
function modifier_legion_commander_arcana_custom_2:IsPurgeException() return false end
function modifier_legion_commander_arcana_custom_2:RemoveOnDeath() return false end
function modifier_legion_commander_arcana_custom_2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_legion_commander_arcana_custom_2:GetActivityTranslationModifiers()
    return "arcana"
end