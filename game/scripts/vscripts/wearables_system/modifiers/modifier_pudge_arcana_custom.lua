modifier_pudge_arcana_custom = class({})
function modifier_pudge_arcana_custom:IsHidden() return true end
function modifier_pudge_arcana_custom:IsPurgable() return false end
function modifier_pudge_arcana_custom:IsPurgeException() return false end
function modifier_pudge_arcana_custom:RemoveOnDeath() return false end
function modifier_pudge_arcana_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_pudge_arcana_custom:GetActivityTranslationModifiers()
    return "arcana"
end