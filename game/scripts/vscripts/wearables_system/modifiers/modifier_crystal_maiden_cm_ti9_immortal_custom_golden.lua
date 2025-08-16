modifier_crystal_maiden_cm_ti9_immortal_custom_golden = class({})
function modifier_crystal_maiden_cm_ti9_immortal_custom_golden:IsHidden() return true end
function modifier_crystal_maiden_cm_ti9_immortal_custom_golden:IsPurgable() return false end
function modifier_crystal_maiden_cm_ti9_immortal_custom_golden:IsPurgeException() return false end
function modifier_crystal_maiden_cm_ti9_immortal_custom_golden:RemoveOnDeath() return false end
function modifier_crystal_maiden_cm_ti9_immortal_custom_golden:DecalreFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_crystal_maiden_cm_ti9_immortal_custom_golden:GetActivityTranslationModifiers()
    return "ti9"
end