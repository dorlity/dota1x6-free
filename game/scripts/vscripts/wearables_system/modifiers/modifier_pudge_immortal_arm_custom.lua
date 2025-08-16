modifier_pudge_immortal_arm_custom = class({})
function modifier_pudge_immortal_arm_custom:IsHidden() return true end
function modifier_pudge_immortal_arm_custom:IsPurgable() return false end
function modifier_pudge_immortal_arm_custom:IsPurgeException() return false end
function modifier_pudge_immortal_arm_custom:RemoveOnDeath() return false end
function modifier_pudge_immortal_arm_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_pudge_immortal_arm_custom:GetActivityTranslationModifiers()
    return "pudge_ti7_immortal"
end