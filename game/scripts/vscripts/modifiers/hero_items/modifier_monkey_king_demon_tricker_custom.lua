modifier_monkey_king_demon_tricker_custom = class({})
function modifier_monkey_king_demon_tricker_custom:IsHidden() return true end
function modifier_monkey_king_demon_tricker_custom:IsPurgable() return false end
function modifier_monkey_king_demon_tricker_custom:IsPurgeException() return false end
function modifier_monkey_king_demon_tricker_custom:RemoveOnDeath() return false end
function modifier_monkey_king_demon_tricker_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_monkey_king_demon_tricker_custom:GetActivityTranslationModifiers()
    return "ti9_cape"
end