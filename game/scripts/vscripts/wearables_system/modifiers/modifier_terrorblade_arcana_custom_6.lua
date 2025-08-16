modifier_terrorblade_arcana_custom_6 = class({})
function modifier_terrorblade_arcana_custom_6:IsHidden() return true end
function modifier_terrorblade_arcana_custom_6:IsPurgable() return false end
function modifier_terrorblade_arcana_custom_6:IsPurgeException() return false end
function modifier_terrorblade_arcana_custom_6:RemoveOnDeath() return false end

function modifier_terrorblade_arcana_custom_6:OnCreated()
    if not IsServer() then return end
    self.rgb = Vector(247,157,0)
    wearables_system:UpdateTerrorbladeColor(self:GetParent(), nil, self.rgb)
end

function modifier_terrorblade_arcana_custom_6:OnDestroy()
    if not IsServer() then return end
    local modifier_terrorblade_arcana_custom = self:GetParent():FindModifierByName("modifier_terrorblade_arcana_custom")
    if modifier_terrorblade_arcana_custom then
        modifier_terrorblade_arcana_custom.rgb = Vector(255,60,40)
    end
    wearables_system:UpdateTerrorbladeColor(self:GetParent(), true, Vector(255,60,40))
end


