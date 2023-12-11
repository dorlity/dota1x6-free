modifier_pa_gleaming_seal_custom = class({})
function modifier_pa_gleaming_seal_custom:IsHidden() return true end
function modifier_pa_gleaming_seal_custom:IsPurgable() return false end
function modifier_pa_gleaming_seal_custom:IsPurgeException() return false end
function modifier_pa_gleaming_seal_custom:RemoveOnDeath() return false end
function modifier_pa_gleaming_seal_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_pa_gleaming_seal_custom:GetActivityTranslationModifiers()
    return "loda"
end