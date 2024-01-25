LinkLuaModifier("modifier_item_patrol_refresh", "abilities/items/item_patrol_refresh", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_patrol_refresh_cd", "abilities/items/item_patrol_refresh", LUA_MODIFIER_MOTION_NONE)

item_patrol_refresh                = class({})



function item_patrol_refresh:OnAbilityPhaseStart()
if not IsServer() then return end


if self:GetCaster():HasModifier("modifier_item_patrol_refresh_cd") then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#respawn_cd"})
 
    return false
end


if self:GetCaster():HasModifier("modifier_item_patrol_refresh") then
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#restrained_orb"})
 
    return false
end

return true
end


function item_patrol_refresh:OnSpellStart()
if not IsServer() then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_patrol_refresh", {})

self:SpendCharge()

end

modifier_item_patrol_refresh = class({})
function modifier_item_patrol_refresh:IsHidden() return false end
function modifier_item_patrol_refresh:IsPurgable() return false end
function modifier_item_patrol_refresh:RemoveOnDeath() return false end
function modifier_item_patrol_refresh:GetTexture() return "item_refresher_shard" end
function modifier_item_patrol_refresh:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_DEATH
}
end


function modifier_item_patrol_refresh:OnCreated(table)
if not IsServer() then return end

self.cd = self:GetAbility():GetSpecialValueFor("cd")

self:GetParent():EmitSound("Lina.Array_triple")
local particle_peffect = ParticleManager:CreateParticle("particles/general/patrol_refresh.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

end




function modifier_item_patrol_refresh:OnDeath(params)
if not IsServer() then return end

local attacker = params.attacker
if attacker.owner and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 
    attacker = attacker.owner
end


if self:GetParent() ~= attacker then return end
if not params.unit:IsValidKill(self:GetParent()) then return end
if params.unit.died_on_duel == true then return end

self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_item_patrol_refresh_cd", {duration = self.cd})

CustomGameEventManager:Send_ServerToAllClients('patrol_refresher',  {hero_1 = self:GetParent():GetUnitName()})


my_game:RefreshCooldowns(self:GetParent(), true)

my_game:CreateUpgradeOrb(self:GetParent(), 2)
self:Destroy()
end




modifier_item_patrol_refresh_cd = class({})
function modifier_item_patrol_refresh_cd:IsHidden() return false end
function modifier_item_patrol_refresh_cd:IsPurgable() return false end
function modifier_item_patrol_refresh_cd:IsDebuff() return true end
function modifier_item_patrol_refresh_cd:RemoveOnDeath() return false end
function modifier_item_patrol_refresh_cd:GetTexture() return "item_refresher_shard" end
