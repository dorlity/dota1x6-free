modifier_monkey_king_staff_of_gunyu_custom_golden = class({})
function modifier_monkey_king_staff_of_gunyu_custom_golden:IsHidden() return true end
function modifier_monkey_king_staff_of_gunyu_custom_golden:IsPurgable() return false end
function modifier_monkey_king_staff_of_gunyu_custom_golden:IsPurgeException() return false end
function modifier_monkey_king_staff_of_gunyu_custom_golden:RemoveOnDeath() return false end
function modifier_monkey_king_staff_of_gunyu_custom_golden:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_monkey_king_staff_of_gunyu_custom_golden:GetActivityTranslationModifiers()
    return "ti7"
end