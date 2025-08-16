modifier_morphling_crown_custom = class({})
function modifier_morphling_crown_custom:IsHidden() return true end
function modifier_morphling_crown_custom:IsPurgable() return false end
function modifier_morphling_crown_custom:IsPurgeException() return false end
function modifier_morphling_crown_custom:RemoveOnDeath() return false end
function modifier_morphling_crown_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_morphling_crown_custom:GetActivityTranslationModifiers()
    return "tears"
end