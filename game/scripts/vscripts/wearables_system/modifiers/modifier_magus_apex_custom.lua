modifier_magus_apex_custom = class({})
function modifier_magus_apex_custom:IsHidden() return true end
function modifier_magus_apex_custom:IsPurgable() return false end
function modifier_magus_apex_custom:IsPurgeException() return false end
function modifier_magus_apex_custom:RemoveOnDeath() return false end
function modifier_magus_apex_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_magus_apex_custom:GetActivityTranslationModifiers()
    return "apex"
end