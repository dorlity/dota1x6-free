modifier_antimage_basher_2_custom = class({})
function modifier_antimage_basher_2_custom:IsHidden() return true end
function modifier_antimage_basher_2_custom:IsPurgable() return false end
function modifier_antimage_basher_2_custom:IsPurgeException() return false end
function modifier_antimage_basher_2_custom:RemoveOnDeath() return false end
function modifier_antimage_basher_2_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_antimage_basher_2_custom:GetActivityTranslationModifiers()
    return "offhand_basher"
end