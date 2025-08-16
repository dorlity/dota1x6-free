modifier_crystal_maiden_immortal_shoulders_custom = class({})
function modifier_crystal_maiden_immortal_shoulders_custom:IsHidden() return true end
function modifier_crystal_maiden_immortal_shoulders_custom:IsPurgable() return false end
function modifier_crystal_maiden_immortal_shoulders_custom:IsPurgeException() return false end
function modifier_crystal_maiden_immortal_shoulders_custom:RemoveOnDeath() return false end
function modifier_crystal_maiden_immortal_shoulders_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function modifier_crystal_maiden_immortal_shoulders_custom:GetActivityTranslationModifiers()
    return "immortal_shoulder"
end

function modifier_crystal_maiden_immortal_shoulders_custom:GetModifierProjectileName()
    if self:GetParent():HasModifier("modifier_crystal_maiden_persona_1") then return end
    if self:GetParent():HasModifier("modifier_crystal_maiden_persona_2") then return end
    if self:GetParent():HasModifier("modifier_crystal_maiden_persona_3") then return end
    if self:GetParent():HasModifier("modifier_crystal_maiden_persona_4") then return end
    return "particles/econ/items/crystal_maiden/ti7_immortal_shoulder/cm_ti7_immortal_base_attack.vpcf"
end