modifier_legion_commander_wings_fallen_custom = class({})
function modifier_legion_commander_wings_fallen_custom:IsHidden() return true end
function modifier_legion_commander_wings_fallen_custom:IsPurgable() return false end
function modifier_legion_commander_wings_fallen_custom:IsPurgeException() return false end
function modifier_legion_commander_wings_fallen_custom:RemoveOnDeath() return false end
function modifier_legion_commander_wings_fallen_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_legion_commander_wings_fallen_custom:GetActivityTranslationModifiers()
    return "fallen_legion"
end