modifier_lifestealer_immortal_back_custom = class({})
function modifier_lifestealer_immortal_back_custom:IsHidden() return true end
function modifier_lifestealer_immortal_back_custom:IsPurgable() return false end
function modifier_lifestealer_immortal_back_custom:IsPurgeException() return false end
function modifier_lifestealer_immortal_back_custom:RemoveOnDeath() return false end
function modifier_lifestealer_immortal_back_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_lifestealer_immortal_back_custom:GetActivityTranslationModifiers()
    return "back"
end