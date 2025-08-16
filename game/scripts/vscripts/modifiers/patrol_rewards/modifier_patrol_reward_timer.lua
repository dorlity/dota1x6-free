LinkLuaModifier( "modifier_patrol_reward_damage", "modifiers/patrol_rewards/modifier_patrol_reward_timer", LUA_MODIFIER_MOTION_NONE)

modifier_patrol_reward_timer = class({})


function modifier_patrol_reward_timer:IsHidden() return self:GetStackCount() == 0 end
function modifier_patrol_reward_timer:IsPurgable() return false end
function modifier_patrol_reward_timer:RemoveOnDeath() return false end
function modifier_patrol_reward_timer:GetTexture() return "item_tome_of_aghanim" end
function modifier_patrol_reward_timer:OnCreated(table)

self.parent = self:GetParent()

if not IsServer() then return end 
self.rewards = {}

self.parent:AddDamageEvent_inc(self, true)
self.parent:AddDamageEvent_out(self, true)
end


function modifier_patrol_reward_timer:SetReward(name)
if not IsServer() then return end

table.insert(self.rewards, name)

self:SetStackCount(#self.rewards)
self:StartIntervalThink(2)
end

function modifier_patrol_reward_timer:OnIntervalThink()
if not IsServer() then return end 

if self.parent:HasModifier("modifier_end_choise") or #players[self.parent:GetId()].choise ~= 0 or self.parent:HasModifier("modifier_patrol_reward_damage") or not self.parent:IsAlive() then 
    self:StartIntervalThink(0.5)
    return 
end

if self.rewards[1] then
    upgrade:init_upgrade(self.parent, nil, nil, after_legen, nil, nil, self.rewards[1])
    table.remove(self.rewards, 1)
end

self:SetStackCount(#self.rewards)

if #self.rewards == 0 then
    self:StartIntervalThink(-1)
end

end


function modifier_patrol_reward_timer:DamageEvent_inc(params)
if not IsServer() then return end
if self:GetStackCount() == 0 then return end

local unit = params.unit
local attacker = params.attacker

if (attacker:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() > 1200 then return end
if not attacker:IsAlive() then return end
if attacker:GetTeamNumber() == unit:GetTeamNumber() then return end

local unit_id = unit:GetId()
if players[unit_id] then
    unit = players[unit_id]
end

if attacker.is_patrol_creep and self.parent == params.unit then
    self.parent:AddNewModifier(self.parent, nil, "modifier_patrol_reward_damage", {duration = 2})
    return
end

if players[attacker:GetId()] and params.unit == self.parent then
    self.parent:AddNewModifier(self.parent, nil, "modifier_patrol_reward_damage", {duration = 4})
    return
end

end




function modifier_patrol_reward_timer:DamageEvent_out(params)
if not IsServer() then return end
if self:GetStackCount() == 0 then return end

local unit = params.unit
local attacker = params.attacker

if (attacker:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() > 1200 then return end
if not attacker:IsAlive() then return end
if attacker:GetTeamNumber() == unit:GetTeamNumber() then return end

local attacker_id = attacker:GetId()
if players[attacker_id] then
    attacker = players[attacker_id]
end

if (unit.is_patrol_creep and self.parent == attacker) then
    self.parent:AddNewModifier(self.parent, nil, "modifier_patrol_reward_damage", {duration = 2})
    return
end

if (players[unit:GetId()] and params.attacker == self.parent) then
    self.parent:AddNewModifier(self.parent, nil, "modifier_patrol_reward_damage", {duration = 4})
    return
end

end





modifier_patrol_reward_damage = class({})
function modifier_patrol_reward_damage:IsHidden() return true end
function modifier_patrol_reward_damage:IsPurgable() return false end
function modifier_patrol_reward_damage:RemoveOnDeath() return false end