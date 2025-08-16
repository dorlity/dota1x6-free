modifier_bane_immortal_head = class({})
function modifier_bane_immortal_head:IsHidden() return true end
function modifier_bane_immortal_head:IsPurgable() return false end
function modifier_bane_immortal_head:IsPurgeException() return false end
function modifier_bane_immortal_head:RemoveOnDeath() return false end
function modifier_bane_immortal_head:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_bane_immortal_head:GetActivityTranslationModifiers()
    return "fall20_head"
end