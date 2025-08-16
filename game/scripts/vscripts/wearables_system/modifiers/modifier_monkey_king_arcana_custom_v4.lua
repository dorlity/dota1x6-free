modifier_monkey_king_arcana_custom_v4 = class({})
function modifier_monkey_king_arcana_custom_v4:IsHidden() return true end
function modifier_monkey_king_arcana_custom_v4:IsPurgable() return false end
function modifier_monkey_king_arcana_custom_v4:IsPurgeException() return false end
function modifier_monkey_king_arcana_custom_v4:RemoveOnDeath() return false end
function modifier_monkey_king_arcana_custom_v4:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_monkey_king_arcana_custom_v4:GetActivityTranslationModifiers()
    return "arcana"
end