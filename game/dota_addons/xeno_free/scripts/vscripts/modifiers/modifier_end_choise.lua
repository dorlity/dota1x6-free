

modifier_end_choise = class({})


function modifier_end_choise:IsHidden() return false end
function modifier_end_choise:IsPurgable() return false end
function modifier_end_choise:RemoveOnDeath() return false end
function modifier_end_choise:GetTexture() return "buffs/purple" end


function modifier_end_choise:OnDestroy()
if not IsServer() then return end
if self:GetRemainingTime() > 0.1 then return end

local player = players[self:GetParent():GetTeamNumber()]

if not player or not player.choise or #player.choise == 0 then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), "end_choise", {max = #player.choise, number = RandomInt(1, #player.choise), } )
end