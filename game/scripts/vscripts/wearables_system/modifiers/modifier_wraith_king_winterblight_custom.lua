modifier_wraith_king_winterblight_custom = class({})
function modifier_wraith_king_winterblight_custom:IsHidden() return true end
function modifier_wraith_king_winterblight_custom:IsPurgable() return false end
function modifier_wraith_king_winterblight_custom:IsPurgeException() return false end
function modifier_wraith_king_winterblight_custom:RemoveOnDeath() return false end
function modifier_wraith_king_winterblight_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_wraith_king_winterblight_custom:GetActivityTranslationModifiers()
    return "winterblight"
end