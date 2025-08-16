modifier_zuus_lightning_weapon_custom = class({})
function modifier_zuus_lightning_weapon_custom:IsHidden() return true end
function modifier_zuus_lightning_weapon_custom:IsPurgable() return false end
function modifier_zuus_lightning_weapon_custom:IsPurgeException() return false end
function modifier_zuus_lightning_weapon_custom:RemoveOnDeath() return false end
function modifier_zuus_lightning_weapon_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end
function modifier_zuus_lightning_weapon_custom:GetActivityTranslationModifiers()
    return "lightning"
end
function modifier_zuus_lightning_weapon_custom:GetModifierProjectileName()
    return "particles/econ/items/zeus/lightning_weapon_fx/zuus_base_attack_immortal_lightning.vpcf"
end