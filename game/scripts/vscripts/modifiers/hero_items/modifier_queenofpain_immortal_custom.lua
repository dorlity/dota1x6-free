modifier_queenofpain_immortal_custom = class({})
function modifier_queenofpain_immortal_custom:IsHidden() return true end
function modifier_queenofpain_immortal_custom:IsPurgable() return false end
function modifier_queenofpain_immortal_custom:IsPurgeException() return false end
function modifier_queenofpain_immortal_custom:RemoveOnDeath() return false end
function modifier_queenofpain_immortal_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_queenofpain_immortal_custom:GetActivityTranslationModifiers()
    return "qop_2022"
end
function modifier_queenofpain_immortal_custom:OnCreated()
    if not IsServer() then return end
    if self:GetParent():HasModifier("modifier_queenofpain_arcana_custom_1") or self:GetParent():HasModifier("modifier_queenofpain_arcana_custom_2") then
        shop:QueenOfPainUpdateShoulder(self:GetParent(), true)
    end
end