modifier_huskar_dominator_custom = class({})
function modifier_huskar_dominator_custom:IsHidden() return true end
function modifier_huskar_dominator_custom:IsPurgable() return false end
function modifier_huskar_dominator_custom:IsPurgeException() return false end
function modifier_huskar_dominator_custom:RemoveOnDeath() return false end
function modifier_huskar_dominator_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_huskar_dominator_custom:GetActivityTranslationModifiers()
    return "dominator"
end