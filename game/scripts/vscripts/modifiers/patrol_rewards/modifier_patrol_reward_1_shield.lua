
modifier_patrol_reward_1_shield = class({})
function modifier_patrol_reward_1_shield:IsHidden() return false end
function modifier_patrol_reward_1_shield:GetTexture() return "rune_shield" end
function modifier_patrol_reward_1_shield:RemoveOnDeath() return false end
function modifier_patrol_reward_1_shield:IsPurgable() return false end
function modifier_patrol_reward_1_shield:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:AddDeathEvent(self, true)
self.parent:AddRespawnEvent(self, true)

self.duration = self.parent:GetTalentValue("modifier_patrol_reward_shield", "duration")
self.wave_shield = self.parent:GetTalentValue("modifier_patrol_reward_shield", "shield")
self.delay = self.parent:GetTalentValue("modifier_patrol_reward_shield", "delay")
self.regen = self.parent:GetTalentValue("modifier_patrol_reward_shield", "regen")/100
self.interval = 0.2

self:SetHasCustomTransmitterData(true)

self:UpdateShield()
end

function modifier_patrol_reward_1_shield:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsAlive() then return end

local regen = self.regen*self.interval*self.max_shield
self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + regen))

if not self.particle then
	self.particle = self.parent:GenericParticle("particles/generic_gameplay/rune_shield_owner_glow.vpcf", self)
end

self:StartIntervalThink(self.interval)
end



function modifier_patrol_reward_1_shield:OnRefresh(table)
if not IsServer() then return end
self:UpdateShield()
end

function modifier_patrol_reward_1_shield:UpdateShield()
if not IsServer() then return end

self.max_shield = math.max(1, self.wave_shield*dota1x6.current_wave)
self:SetStackCount(self.max_shield)
self.parent:EmitSound("Patrol.Shield")

if not self.particle then
	self.particle = self.parent:GenericParticle("particles/generic_gameplay/rune_shield_owner_glow.vpcf", self)
end

self:SendBuffRefreshToClients()
end


function modifier_patrol_reward_1_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
  MODIFIER_PROPERTY_TOOLTIP,
}
end

function modifier_patrol_reward_1_shield:OnTooltip()
return self.delay
end

function modifier_patrol_reward_1_shield:DeathEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end

self.reinc = false 
if self.parent:IsReincarnating() then 
	self.reinc = true
	return
end

self:SetDuration(-1, true)
end

function modifier_patrol_reward_1_shield:RespawnEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if self.reinc then return end

self:SetDuration(self.duration, true)
self:UpdateShield()
end


function modifier_patrol_reward_1_shield:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() <= 0 then return end

if IsClient() then 
  if params.report_max then 
      return self.max_shield
  else  
      return self:GetStackCount()
  end 
end

if not IsServer() then return end

self:StartIntervalThink(self.delay)

if self:GetStackCount() > params.damage then
	self:SetStackCount(self:GetStackCount() - params.damage)
	self:SendBuffRefreshToClients()
	local i = params.damage
	return -i
else
	local i = self:GetStackCount()
	self:SetStackCount(0)
	self:SendBuffRefreshToClients()

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end

	return -i
end

end

function modifier_patrol_reward_1_shield:AddCustomTransmitterData()
return 
{
	max_shield = self.max_shield
}
end

function modifier_patrol_reward_1_shield:HandleCustomTransmitterData(data)
self.max_shield = data.max_shield
end
