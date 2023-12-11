LinkLuaModifier("modifier_necro_attack", "abilities/items/item_roshan_necro", LUA_MODIFIER_MOTION_NONE)

item_roshan_necro                = class({})


function item_roshan_necro:OnAbilityPhaseStart()


local find_towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #find_towers == 0 then 
    return false 
end

local tower = towers[find_towers[1]:GetTeamNumber()]
local player = players[find_towers[1]:GetTeamNumber()]

if not player or not tower then return end


if player.active_necro == false then 
    --CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#active_necro"}) 
    --return false
end

if player.necro_cd and player.necro_cd > 0 then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#necro_cd"..player.necro_cd}) 
    return false
end


if tower:HasModifier("modifier_tower_incoming_duel_soon") then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#duel_necro"}) 
    return false
end


if duel_data[player.duel_data] and duel_data[player.duel_data].finished == 0 and duel_data[player.duel_data].stage == 2 then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#duel_active_necro"}) 
    return false
end




if tower:HasModifier("modifier_necro_attack") then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#cant_necro"}) 
    return false
end

return true 

end


function item_roshan_necro:OnSpellStart()
if not IsServer() then return end



local find_towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

if #find_towers == 0 then 
    return false 
end

local tower = towers[find_towers[1]:GetTeamNumber()]
local player = players[find_towers[1]:GetTeamNumber()]

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#necro_cd"..33}) 

if not tower or not player then 
    return 
end 

CustomGameEventManager:Send_ServerToAllClients('NecroAttack',  {id = player:GetPlayerOwnerID(), victim = player:GetUnitName(), attacker = self:GetCaster():GetUnitName()})

player.used_necro = true
player.necro_cd = self:GetSpecialValueFor("cd")

tower:AddNewModifier(player, self, "modifier_necro_attack", {enemy_caster = self:GetCaster():entindex(),duration = self:GetSpecialValueFor("delay")})

self:SpendCharge()


end




modifier_necro_attack = class({})
function modifier_necro_attack:IsHidden() return true end
function modifier_necro_attack:IsPurgable() return false end 

function modifier_necro_attack:OnCreated(table)
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'NecroWave_start',  {})

self.enemy_caster = table.enemy_caster

self.timer = self:GetAbility():GetSpecialValueFor("delay") + 1
self:OnIntervalThink()
self:StartIntervalThink(1)
end 

function modifier_necro_attack:OnIntervalThink()
if not IsServer() then return end 

self.timer = self.timer - 1

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'NecroWave_think',  {time = self.timer, max = 15})

if self.timer == 5 then 
    my_game:spawn_portal( self:GetParent():GetTeamNumber() )
end 


end 


function modifier_necro_attack:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

--CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "Necro.Wave_spawn"})
  
my_game:SpawnNecro(self:GetParent():GetTeamNumber(), self:GetCaster(), self.enemy_caster)
end 





modifier_necro_creeps = class({})
function modifier_necro_creeps:IsHidden() return true end
function modifier_necro_creeps:IsPurgable() return false end 
function modifier_necro_creeps:OnCreated(table)
if not IsServer() then return end 

self.caster = self:GetCaster()
self.enemy_caster = EntIndexToHScript(table.enemy_caster)


if not self:GetParent().ally then
    self:Destroy()
    return
else 
    self.max = #self:GetParent().ally
end 


self:OnIntervalThink()
self:StartIntervalThink(0.1)
end 


function modifier_necro_creeps:OnIntervalThink()
if not IsServer() then return end 

if self.enemy_caster and not self.enemy_caster:IsNull() then
    AddFOWViewer(self.enemy_caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), 1000, 0.1, true)
end 


if towers[self:GetCaster():GetTeamNumber()] and towers[self:GetCaster():GetTeamNumber()]:HasModifier("modifier_necro_attack") then return end

local count = 0 

for i = 1,#self:GetParent().ally do 
    if self:GetParent().ally[i] and not self:GetParent().ally[i]:IsNull() and self:GetParent().ally[i]:IsAlive() then 
        count = count + 1
    end     
end 


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'NecroWave_think',  {max = self.max, time = count})

if count == 0 then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'NecroWave_hide',  {})
end 


end 



function modifier_necro_creeps:OnDestroy()
if not IsServer() then return end 
self:OnIntervalThink() 
end 