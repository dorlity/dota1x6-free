modifier_monkey_king_arcana_custom_v2 = class({})
function modifier_monkey_king_arcana_custom_v2:IsHidden() return true end
function modifier_monkey_king_arcana_custom_v2:IsPurgable() return false end
function modifier_monkey_king_arcana_custom_v2:IsPurgeException() return false end
function modifier_monkey_king_arcana_custom_v2:RemoveOnDeath() return false end
function modifier_monkey_king_arcana_custom_v2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_monkey_king_arcana_custom_v2:GetActivityTranslationModifiers()
    return "arcana"
end