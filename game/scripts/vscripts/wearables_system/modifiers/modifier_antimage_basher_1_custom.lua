modifier_antimage_basher_1_custom = class({})
function modifier_antimage_basher_1_custom:IsHidden() return true end
function modifier_antimage_basher_1_custom:IsPurgable() return false end
function modifier_antimage_basher_1_custom:IsPurgeException() return false end
function modifier_antimage_basher_1_custom:RemoveOnDeath() return false end
function modifier_antimage_basher_1_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_antimage_basher_1_custom:GetActivityTranslationModifiers()
    return "basher"
end