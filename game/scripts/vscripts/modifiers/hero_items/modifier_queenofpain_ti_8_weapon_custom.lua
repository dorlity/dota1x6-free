modifier_queenofpain_ti_8_weapon_custom = class({})
function modifier_queenofpain_ti_8_weapon_custom:IsHidden() return true end
function modifier_queenofpain_ti_8_weapon_custom:IsPurgable() return false end
function modifier_queenofpain_ti_8_weapon_custom:IsPurgeException() return false end
function modifier_queenofpain_ti_8_weapon_custom:RemoveOnDeath() return false end
function modifier_queenofpain_ti_8_weapon_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end
function modifier_queenofpain_ti_8_weapon_custom:GetActivityTranslationModifiers()
    return "ti8"
end
function modifier_queenofpain_ti_8_weapon_custom:GetModifierProjectileName()
    return "particles/econ/items/queen_of_pain/qop_ti8_immortal/qop_ti8_base_attack.vpcf"
end