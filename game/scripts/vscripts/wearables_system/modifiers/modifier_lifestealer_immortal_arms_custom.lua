modifier_lifestealer_immortal_arms_custom = class({})
function modifier_lifestealer_immortal_arms_custom:IsHidden() return true end
function modifier_lifestealer_immortal_arms_custom:IsPurgable() return false end
function modifier_lifestealer_immortal_arms_custom:IsPurgeException() return false end
function modifier_lifestealer_immortal_arms_custom:RemoveOnDeath() return false end
function modifier_lifestealer_immortal_arms_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_lifestealer_immortal_arms_custom:GetActivityTranslationModifiers()
    return "ti9_arms"
end