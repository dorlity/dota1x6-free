modifier_morphling_blade_tears_custom = class({})
function modifier_morphling_blade_tears_custom:IsHidden() return true end
function modifier_morphling_blade_tears_custom:IsPurgable() return false end
function modifier_morphling_blade_tears_custom:IsPurgeException() return false end
function modifier_morphling_blade_tears_custom:RemoveOnDeath() return false end
function modifier_morphling_blade_tears_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_morphling_blade_tears_custom:GetActivityTranslationModifiers()
    return "ancient_armor"
end