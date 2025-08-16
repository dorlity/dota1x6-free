LinkLuaModifier("modifier_patrol_reward_2_respawn_cd", "modifiers/patrol_rewards/modifier_patrol_reward_2_respawn", LUA_MODIFIER_MOTION_NONE)

modifier_patrol_reward_2_respawn = class({})
function modifier_patrol_reward_2_respawn:IsHidden() return false end
function modifier_patrol_reward_2_respawn:GetTexture() return "omniknight_guardian_angel" end
function modifier_patrol_reward_2_respawn:RemoveOnDeath() return false end
function modifier_patrol_reward_2_respawn:IsPurgable() return false end


function modifier_patrol_reward_2_respawn:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()

self.parent:AddRespawnEvent(self, true)
self.proced = false
self.respawn_time = self.parent:GetTalentValue("modifier_patrol_reward_ash", "respawn")
self.cd = self.parent:GetTalentValue("modifier_patrol_reward_ash", "cd")*60

self:IncrementStackCount()
self:OnIntervalThink()
self:StartIntervalThink(0.5)
end

function modifier_patrol_reward_2_respawn:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
end

function modifier_patrol_reward_2_respawn:OnIntervalThink()
if not IsServer() then return end

local active = self.parent:IsAlive() and not self.parent:HasModifier("modifier_patrol_reward_2_respawn_cd") and not self.particle

if active then
	EmitSoundOnEntityForPlayer("Patrol.Respawn", self.parent, self.parent:GetPlayerOwnerID())
	if not self.particle then
		self.particle = self.parent:GenericParticle("particles/patrol_respawn.vpcf", self)
	end
end


end


function modifier_patrol_reward_2_respawn:Proc(params)
if not IsServer() then return end

self.proced = true

if self.particle then
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
	self.particle = nil
end

end


function modifier_patrol_reward_2_respawn:RespawnEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if self.proced == false then return end

self.proced = false
self.parent:AddNewModifier(self.parent, nil, "modifier_patrol_reward_2_respawn_cd", {duration = self.cd})

self:DecrementStackCount()
if self:GetStackCount() <= 0 then
	self:Destroy()
end

end




modifier_patrol_reward_2_respawn_cd = class({})
function modifier_patrol_reward_2_respawn_cd:IsHidden() return false end
function modifier_patrol_reward_2_respawn_cd:IsPurgable() return false end
function modifier_patrol_reward_2_respawn_cd:IsDebuff() return true end
function modifier_patrol_reward_2_respawn_cd:RemoveOnDeath() return false end
function modifier_patrol_reward_2_respawn_cd:GetTexture() return "omniknight_guardian_angel" end
