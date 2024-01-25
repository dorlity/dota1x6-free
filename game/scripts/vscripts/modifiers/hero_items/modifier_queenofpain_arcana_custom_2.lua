modifier_queenofpain_arcana_custom_2 = class({})
function modifier_queenofpain_arcana_custom_2:IsHidden() return true end
function modifier_queenofpain_arcana_custom_2:IsPurgable() return false end
function modifier_queenofpain_arcana_custom_2:IsPurgeException() return false end
function modifier_queenofpain_arcana_custom_2:RemoveOnDeath() return false end
function modifier_queenofpain_arcana_custom_2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_queenofpain_arcana_custom_2:GetActivityTranslationModifiers()
    return "arcana"
end

function modifier_queenofpain_arcana_custom_2:OnCreated()
    if not IsServer() then return end
    shop:QueenOfPainUpdateShoulder(self:GetParent(), true)
    self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_queenofpain_arcana", {})
end

function modifier_queenofpain_arcana_custom_2:OnDestroy()
    if not IsServer() then return end
    shop:QueenOfPainUpdateShoulder(self:GetParent(), false)
    local modifier_queenofpain_arcana = self:GetCaster():FindModifierByName("modifier_queenofpain_arcana")
    if modifier_queenofpain_arcana then
        modifier_queenofpain_arcana:Destroy()
    end
end