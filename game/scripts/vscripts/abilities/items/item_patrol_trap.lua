--LinkLuaModifier("", "abilities/items/item_patrol_trap", LUA_MODIFIER_MOTION_NONE)

item_patrol_trap                = class({})


function item_patrol_trap:OnAbilityPhaseStart()
local player = self:GetCaster()

if player == nil then return false end


if player.trap_wave == true  then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#active_trap"}) 
    return false
end

if duel_data[player.duel_data] and duel_data[player.duel_data].finished == 0 then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#active_duel"}) 
    return false
end

if player.active_necro == false then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#active_necro"}) 
    return false
end

return true 

end


function item_patrol_trap:OnSpellStart()
if not IsServer() then return end

local player = self:GetCaster()

CustomGameEventManager:Send_ServerToAllClients('TrapAlert',  {victim = self:GetCaster():GetUnitName()})

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'TrapAlert_start',  {})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'TrapAlert_think',  {time = Trap_Duration, max = Trap_Duration})

player.trap_wave = true

self:SpendCharge()


end