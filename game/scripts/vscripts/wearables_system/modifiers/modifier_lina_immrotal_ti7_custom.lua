modifier_lina_immrotal_ti7_custom = class({})
function modifier_lina_immrotal_ti7_custom:IsHidden() return true end
function modifier_lina_immrotal_ti7_custom:IsPurgable() return false end
function modifier_lina_immrotal_ti7_custom:IsPurgeException() return false end
function modifier_lina_immrotal_ti7_custom:RemoveOnDeath() return false end
function modifier_lina_immrotal_ti7_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_lina_immrotal_ti7_custom:GetActivityTranslationModifiers()
    return "ti7"
end