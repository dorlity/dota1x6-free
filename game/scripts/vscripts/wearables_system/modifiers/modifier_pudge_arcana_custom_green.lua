modifier_pudge_arcana_custom_green = class({})
function modifier_pudge_arcana_custom_green:IsHidden() return true end
function modifier_pudge_arcana_custom_green:IsPurgable() return false end
function modifier_pudge_arcana_custom_green:IsPurgeException() return false end
function modifier_pudge_arcana_custom_green:RemoveOnDeath() return false end
function modifier_pudge_arcana_custom_green:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_pudge_arcana_custom_green:GetActivityTranslationModifiers()
    return "arcana"
end
function modifier_pudge_arcana_custom_green:OnCreated()
    if not IsServer() then return end
    self:GetCaster():AddActivityModifier("green")
end