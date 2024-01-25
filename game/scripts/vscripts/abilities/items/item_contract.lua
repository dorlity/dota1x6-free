LinkLuaModifier("modifier_contract_vision", "abilities/items/item_contract", LUA_MODIFIER_MOTION_NONE)

item_contract                = class({})


function item_contract:OnAbilityPhaseStart()

local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #towers == 0 then 
    return false 
end

local tower = towers[1]

local player = players[tower:GetTeamNumber()]

if player == nil then return false end

return true 

end


function item_contract:OnSpellStart()
if not IsServer() then return end

local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #towers == 0 then 
    return false 
end

local tower = towers[1]

local player = players[tower:GetTeamNumber()]

EmitSoundOnEntityForPlayer("Hero_BountyHunter.Target", self:GetCaster(),  self:GetCaster():GetPlayerOwnerID())

if not player then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_contract_speed", {duration = self:GetSpecialValueFor("duration")})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_contract_vision", {hero = player:entindex(), duration = self:GetSpecialValueFor("duration")})

self:SpendCharge()

end

modifier_contract_vision = class({})
function modifier_contract_vision:IsHidden() return false end
function modifier_contract_vision:GetTexture() return "buffs/contract" end
function modifier_contract_vision:RemoveOnDeath() return false end
function modifier_contract_vision:IsPurgable() return false end
function modifier_contract_vision:OnCreated(table)
if not IsServer() then return end

self.hero = EntIndexToHScript(table.hero)

self:StartIntervalThink(0.1)
end

function modifier_contract_vision:OnIntervalThink()
if not IsServer() then return end
if not self.hero or self.hero:IsNull() or not self.hero:IsAlive() then return end 

AddFOWViewer(self:GetCaster():GetTeamNumber(), self.hero:GetAbsOrigin(), 10, 0.1, false)
end



modifier_contract_speed = class({})
function modifier_contract_speed:IsHidden() return true end
function modifier_contract_speed:IsPurgable() return false end
function modifier_contract_speed:RemoveOnDeath() return false end
function modifier_contract_speed:OnCreated(table)
self.speed = self:GetAbility():GetSpecialValueFor("movespeed")
self.interval = self:GetAbility():GetSpecialValueFor("interval")
end

function modifier_contract_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_contract_speed:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end

self:SetStackCount(1)

self:StartIntervalThink(self.interval)
end


function modifier_contract_speed:OnIntervalThink()
if not IsServer() then return end

self:SetStackCount(0)

self:StartIntervalThink(-1)
end


function modifier_contract_speed:GetModifierMoveSpeedBonus_Percentage()
if self:GetStackCount() == 1 then return end
return self.speed
end