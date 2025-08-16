modifier_wraith_king_ti_8_weapon = class({})
function modifier_wraith_king_ti_8_weapon:IsHidden() return true end
function modifier_wraith_king_ti_8_weapon:IsPurgable() return false end
function modifier_wraith_king_ti_8_weapon:IsPurgeException() return false end
function modifier_wraith_king_ti_8_weapon:RemoveOnDeath() return false end
function modifier_wraith_king_ti_8_weapon:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end
function modifier_wraith_king_ti_8_weapon:GetActivityTranslationModifiers()
    return "ti8"
end
function modifier_wraith_king_ti_8_weapon:GetAttackSound()
    return "Hero_SkeletonKing.Attack.TI8"
end