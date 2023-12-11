modifier_shadow_fiend_desolator_custom = class({})
function modifier_shadow_fiend_desolator_custom:IsHidden() return true end
function modifier_shadow_fiend_desolator_custom:IsPurgable() return false end
function modifier_shadow_fiend_desolator_custom:IsPurgeException() return false end
function modifier_shadow_fiend_desolator_custom:RemoveOnDeath() return false end
function modifier_shadow_fiend_desolator_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
    }
end
function modifier_shadow_fiend_desolator_custom:GetActivityTranslationModifiers()
    return "desolation"
end
function modifier_shadow_fiend_desolator_custom:GetModifierProjectileName()
    return "particles/econ/items/shadow_fiend/sf_desolation/sf_base_attack_desolation.vpcf"
end