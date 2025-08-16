modifier_lina_immortal_ii_custom = class({})
function modifier_lina_immortal_ii_custom:IsHidden() return true end
function modifier_lina_immortal_ii_custom:IsPurgable() return false end
function modifier_lina_immortal_ii_custom:IsPurgeException() return false end
function modifier_lina_immortal_ii_custom:RemoveOnDeath() return false end
function modifier_lina_immortal_ii_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_lina_immortal_ii_custom:GetActivityTranslationModifiers()
    return "ti6"
end