modifier_monkey_king_staff_of_gunyu_custom_anniversary = class({})
function modifier_monkey_king_staff_of_gunyu_custom_anniversary:IsHidden() return true end
function modifier_monkey_king_staff_of_gunyu_custom_anniversary:IsPurgable() return false end
function modifier_monkey_king_staff_of_gunyu_custom_anniversary:IsPurgeException() return false end
function modifier_monkey_king_staff_of_gunyu_custom_anniversary:RemoveOnDeath() return false end
function modifier_monkey_king_staff_of_gunyu_custom_anniversary:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_monkey_king_staff_of_gunyu_custom_anniversary:GetActivityTranslationModifiers()
    return "ti7"
end