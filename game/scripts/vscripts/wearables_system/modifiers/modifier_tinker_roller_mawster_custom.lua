modifier_tinker_roller_mawster_custom = class({})
function modifier_tinker_roller_mawster_custom:IsHidden() return true end
function modifier_tinker_roller_mawster_custom:IsPurgable() return false end
function modifier_tinker_roller_mawster_custom:IsPurgeException() return false end
function modifier_tinker_roller_mawster_custom:RemoveOnDeath() return false end
function modifier_tinker_roller_mawster_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_tinker_roller_mawster_custom:GetActivityTranslationModifiers()
    return "tinker_rollermaw"
end