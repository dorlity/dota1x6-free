modifier_terrorblade_arcana_custom_1 = class({})
function modifier_terrorblade_arcana_custom_1:IsHidden() return true end
function modifier_terrorblade_arcana_custom_1:IsPurgable() return false end
function modifier_terrorblade_arcana_custom_1:IsPurgeException() return false end
function modifier_terrorblade_arcana_custom_1:RemoveOnDeath() return false end

function modifier_terrorblade_arcana_custom_1:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_terrorblade_arcana_custom_1:GetActivityTranslationModifiers()
    return "abysm"
end

function modifier_terrorblade_arcana_custom_1:OnCreated()
    if not IsServer() then return end
    self.rgb = Vector(255,0,0)
    wearables_system:UpdateTerrorbladeColor(self:GetParent(), nil, Vector(255,0,0))
end

function modifier_terrorblade_arcana_custom_1:OnDestroy()
    if not IsServer() then return end
    wearables_system:UpdateTerrorbladeColor(self:GetParent(), true, Vector(255,0,0))
end