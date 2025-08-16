modifier_drow_ranger_madness_custom = class({})
function modifier_drow_ranger_madness_custom:IsHidden() return true end
function modifier_drow_ranger_madness_custom:IsPurgable() return false end
function modifier_drow_ranger_madness_custom:IsPurgeException() return false end
function modifier_drow_ranger_madness_custom:RemoveOnDeath() return false end
function modifier_drow_ranger_madness_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_drow_ranger_madness_custom:GetActivityTranslationModifiers()
    return "manias_mask"
end