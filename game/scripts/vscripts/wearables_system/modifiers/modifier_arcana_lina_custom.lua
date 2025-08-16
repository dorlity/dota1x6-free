modifier_arcana_lina_custom = class({})
function modifier_arcana_lina_custom:IsHidden() return true end
function modifier_arcana_lina_custom:IsPurgable() return false end
function modifier_arcana_lina_custom:IsPurgeException() return false end
function modifier_arcana_lina_custom:RemoveOnDeath() return false end
function modifier_arcana_lina_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_arcana_lina_custom:GetActivityTranslationModifiers()
    return "fiery_soul"
end