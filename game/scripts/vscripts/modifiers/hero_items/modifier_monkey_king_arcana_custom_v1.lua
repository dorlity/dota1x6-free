modifier_monkey_king_arcana_custom_v1 = class({})
function modifier_monkey_king_arcana_custom_v1:IsHidden() return true end
function modifier_monkey_king_arcana_custom_v1:IsPurgable() return false end
function modifier_monkey_king_arcana_custom_v1:IsPurgeException() return false end
function modifier_monkey_king_arcana_custom_v1:RemoveOnDeath() return false end
function modifier_monkey_king_arcana_custom_v1:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_monkey_king_arcana_custom_v1:GetActivityTranslationModifiers()
    return "arcana"
end