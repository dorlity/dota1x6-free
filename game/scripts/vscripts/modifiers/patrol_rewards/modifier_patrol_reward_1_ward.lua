
modifier_patrol_reward_1_ward = class({})
function modifier_patrol_reward_1_ward:IsHidden() return false end
function modifier_patrol_reward_1_ward:GetTexture() return "item_ward_observer" end
function modifier_patrol_reward_1_ward:RemoveOnDeath() return false end
function modifier_patrol_reward_1_ward:IsPurgable() return false end
function modifier_patrol_reward_1_ward:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:AddDeathEvent(self, true)

self.radius = self.parent:GetTalentValue("modifier_patrol_reward_ward", "radius")
self.max = self.parent:GetTalentValue("modifier_patrol_reward_ward", "max")

EmitSoundOnEntityForPlayer("Item.SeerStone", self.parent, self.parent:GetPlayerOwnerID())

self:SetStackCount(self.max)

self.interval = 0.2

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_patrol_reward_1_ward:OnIntervalThink()
if not IsServer() then return end

local targets = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER,false)

for _,target in pairs(targets) do
	if target:GetUnitName() == "npc_dota_observer_wards" then
		AddFOWViewer(self.parent:GetTeamNumber(), target:GetAbsOrigin(), 20, self.interval*2, false)
		target:AddNewModifier(self.parent, nil, "modifier_truesight", {duration = self.interval*2})
	end
end

end



function modifier_patrol_reward_1_ward:DeathEvent(params)
if not IsServer() then return end
local attacker = params.attacker

if not attacker then return end
if attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end
if params.unit:GetUnitName() ~= "npc_dota_observer_wards" then return end

self:DecrementStackCount()

if self:GetStackCount() <= 0 then
	self:Destroy()
end

end


