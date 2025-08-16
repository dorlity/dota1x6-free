modifier_queenofpain_ti_8_weapon_custom_golden = class({})
function modifier_queenofpain_ti_8_weapon_custom_golden:IsHidden() return true end
function modifier_queenofpain_ti_8_weapon_custom_golden:IsPurgable() return false end
function modifier_queenofpain_ti_8_weapon_custom_golden:IsPurgeException() return false end
function modifier_queenofpain_ti_8_weapon_custom_golden:RemoveOnDeath() return false end
function modifier_queenofpain_ti_8_weapon_custom_golden:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end
function modifier_queenofpain_ti_8_weapon_custom_golden:GetActivityTranslationModifiers()
    return "ti8"
end
function modifier_queenofpain_ti_8_weapon_custom_golden:GetModifierProjectileName()
    return "particles/econ/items/queen_of_pain/qop_ti8_immortal/qop_ti8_golden_base_attack.vpcf"
end