modifier_queenofpain_immortal_custom_v2 = class({})
function modifier_queenofpain_immortal_custom_v2:IsHidden() return true end
function modifier_queenofpain_immortal_custom_v2:IsPurgable() return false end
function modifier_queenofpain_immortal_custom_v2:IsPurgeException() return false end
function modifier_queenofpain_immortal_custom_v2:RemoveOnDeath() return false end
function modifier_queenofpain_immortal_custom_v2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_queenofpain_immortal_custom_v2:GetActivityTranslationModifiers()
    return "qop_2022"
end
function modifier_queenofpain_immortal_custom_v2:OnCreated()
    if not IsServer() then return end
    if self:GetParent():HasModifier("modifier_queenofpain_arcana_custom_1") or self:GetParent():HasModifier("modifier_queenofpain_arcana_custom_2") then
        shop:QueenOfPainUpdateShoulder(self:GetParent(), true)
    end
end