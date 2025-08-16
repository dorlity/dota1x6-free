

modifier_top_donate = class({})


function modifier_top_donate:IsHidden() return true end
function modifier_top_donate:IsPurgable() return false end
function modifier_top_donate:RemoveOnDeath() return false end
function modifier_top_donate:OnCreated(table)
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)
self.parent:AddRespawnEvent(self)

if not IsServer() then return end 

self.name = TopDonat[tostring(PlayerResource:GetSteamAccountID(self.parent:GetPlayerOwnerID()))]

self.particle = self.parent:GenericParticle(self.name, self)
end



function modifier_top_donate:DeathEvent(params)
if not IsServer() then return end 
if self.parent ~= params.unit then return end 
if not self.particle then return end

ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)
self.particle = nil
end

function modifier_top_donate:RespawnEvent(params)
if not IsServer() then return end 
if self.parent ~= params.unit then return end 
if self.particle then return end

self.particle = self.parent:GenericParticle(self.name, self)
end