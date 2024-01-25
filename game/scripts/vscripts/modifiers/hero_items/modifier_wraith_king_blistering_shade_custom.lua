modifier_wraith_king_blistering_shade_custom = class({})
function modifier_wraith_king_blistering_shade_custom:IsHidden() return true end
function modifier_wraith_king_blistering_shade_custom:IsPurgable() return false end
function modifier_wraith_king_blistering_shade_custom:IsPurgeException() return false end
function modifier_wraith_king_blistering_shade_custom:RemoveOnDeath() return false end
function modifier_wraith_king_blistering_shade_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_wraith_king_blistering_shade_custom:GetActivityTranslationModifiers()
    return "shade"
end