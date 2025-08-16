modifier_terrorblade_arcana_custom_10 = class({})
function modifier_terrorblade_arcana_custom_10:IsHidden() return true end
function modifier_terrorblade_arcana_custom_10:IsPurgable() return false end
function modifier_terrorblade_arcana_custom_10:IsPurgeException() return false end
function modifier_terrorblade_arcana_custom_10:RemoveOnDeath() return false end

function modifier_terrorblade_arcana_custom_10:OnCreated()
    if not IsServer() then return end
    self.rgb = Vector(209,31,161)
    wearables_system:UpdateTerrorbladeColor(self:GetParent(), nil, self.rgb)
end

function modifier_terrorblade_arcana_custom_10:OnDestroy()
    if not IsServer() then return end
    local modifier_terrorblade_arcana_custom = self:GetParent():FindModifierByName("modifier_terrorblade_arcana_custom")
    if modifier_terrorblade_arcana_custom then
        modifier_terrorblade_arcana_custom.rgb = Vector(255,60,40)
    end
    wearables_system:UpdateTerrorbladeColor(self:GetParent(), true, Vector(255,60,40))
end