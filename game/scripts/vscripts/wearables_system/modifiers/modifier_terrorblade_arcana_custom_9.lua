modifier_terrorblade_arcana_custom_9 = class({})
function modifier_terrorblade_arcana_custom_9:IsHidden() return true end
function modifier_terrorblade_arcana_custom_9:IsPurgable() return false end
function modifier_terrorblade_arcana_custom_9:IsPurgeException() return false end
function modifier_terrorblade_arcana_custom_9:RemoveOnDeath() return false end

function modifier_terrorblade_arcana_custom_9:OnCreated()
    if not IsServer() then return end
    self.rgb = Vector(220,242,255)
    wearables_system:UpdateTerrorbladeColor(self:GetParent(), nil, self.rgb)
end

function modifier_terrorblade_arcana_custom_9:OnDestroy()
    if not IsServer() then return end
    local modifier_terrorblade_arcana_custom = self:GetParent():FindModifierByName("modifier_terrorblade_arcana_custom")
    if modifier_terrorblade_arcana_custom then
        modifier_terrorblade_arcana_custom.rgb = Vector(255,60,40)
    end
    wearables_system:UpdateTerrorbladeColor(self:GetParent(), true, Vector(255,60,40))
end