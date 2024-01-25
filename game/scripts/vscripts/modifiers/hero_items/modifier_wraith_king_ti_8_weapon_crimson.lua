modifier_wraith_king_ti_8_weapon_crimson = class({})
function modifier_wraith_king_ti_8_weapon_crimson:IsHidden() return true end
function modifier_wraith_king_ti_8_weapon_crimson:IsPurgable() return false end
function modifier_wraith_king_ti_8_weapon_crimson:IsPurgeException() return false end
function modifier_wraith_king_ti_8_weapon_crimson:RemoveOnDeath() return false end
function modifier_wraith_king_ti_8_weapon_crimson:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end
function modifier_wraith_king_ti_8_weapon_crimson:GetActivityTranslationModifiers()
    return "ti8"
end
function modifier_wraith_king_ti_8_weapon_crimson:GetAttackSound()
    return "Hero_SkeletonKing.Attack.TI8"
end