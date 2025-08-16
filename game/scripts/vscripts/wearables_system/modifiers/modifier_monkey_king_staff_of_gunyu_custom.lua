modifier_monkey_king_staff_of_gunyu_custom = class({})
function modifier_monkey_king_staff_of_gunyu_custom:IsHidden() return true end
function modifier_monkey_king_staff_of_gunyu_custom:IsPurgable() return false end
function modifier_monkey_king_staff_of_gunyu_custom:IsPurgeException() return false end
function modifier_monkey_king_staff_of_gunyu_custom:RemoveOnDeath() return false end
function modifier_monkey_king_staff_of_gunyu_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_monkey_king_staff_of_gunyu_custom:GetActivityTranslationModifiers()
    return "ti7"
end