modifier_bane_immortal_shoulder = class({})
function modifier_bane_immortal_shoulder:IsHidden() return true end
function modifier_bane_immortal_shoulder:IsPurgable() return false end
function modifier_bane_immortal_shoulder:IsPurgeException() return false end
function modifier_bane_immortal_shoulder:RemoveOnDeath() return false end
function modifier_bane_immortal_shoulder:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_bane_immortal_shoulder:GetActivityTranslationModifiers()
    return "terror"
end