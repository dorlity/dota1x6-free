modifier_monkey_king_arcana_custom_v3 = class({})
function modifier_monkey_king_arcana_custom_v3:IsHidden() return true end
function modifier_monkey_king_arcana_custom_v3:IsPurgable() return false end
function modifier_monkey_king_arcana_custom_v3:IsPurgeException() return false end
function modifier_monkey_king_arcana_custom_v3:RemoveOnDeath() return false end
function modifier_monkey_king_arcana_custom_v3:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_monkey_king_arcana_custom_v3:GetActivityTranslationModifiers()
    return "arcana"
end