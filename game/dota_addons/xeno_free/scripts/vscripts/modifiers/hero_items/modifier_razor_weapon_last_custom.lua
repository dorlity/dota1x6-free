modifier_razor_weapon_last_custom = class({})
function modifier_razor_weapon_last_custom:IsHidden() return true end
function modifier_razor_weapon_last_custom:IsPurgable() return false end
function modifier_razor_weapon_last_custom:IsPurgeException() return false end
function modifier_razor_weapon_last_custom:RemoveOnDeath() return false end
function modifier_razor_weapon_last_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
    }
end
function modifier_razor_weapon_last_custom:GetActivityTranslationModifiers()
    return "ti6"
end
function modifier_razor_weapon_last_custom:GetModifierProjectileName()
    return "particles/econ/items/razor/razor_ti6/razor_base_attack_ti6.vpcf"
end