modifier_legion_commander_wings_fallen_custom_2 = class({})
function modifier_legion_commander_wings_fallen_custom_2:IsHidden() return true end
function modifier_legion_commander_wings_fallen_custom_2:IsPurgable() return false end
function modifier_legion_commander_wings_fallen_custom_2:IsPurgeException() return false end
function modifier_legion_commander_wings_fallen_custom_2:RemoveOnDeath() return false end
function modifier_legion_commander_wings_fallen_custom_2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_legion_commander_wings_fallen_custom_2:GetActivityTranslationModifiers()
    return "fallen_legion"
end