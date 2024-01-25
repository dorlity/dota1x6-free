LinkLuaModifier("modifier_item_patrol_restrained_orb", "abilities/items/item_patrol_restrained_orb", LUA_MODIFIER_MOTION_NONE)

item_patrol_restrained_orb                = class({})



function item_patrol_restrained_orb:OnAbilityPhaseStart()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_item_patrol_restrained_orb") then
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#restrained_orb"})
 
    return false
end

return true
end


function item_patrol_restrained_orb:OnSpellStart()
if not IsServer() then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_patrol_restrained_orb", {})

self:SpendCharge()

end

modifier_item_patrol_restrained_orb = class({})
function modifier_item_patrol_restrained_orb:IsHidden() return false end
function modifier_item_patrol_restrained_orb:IsPurgable() return false end
function modifier_item_patrol_restrained_orb:RemoveOnDeath() return false end
function modifier_item_patrol_restrained_orb:GetTexture() return "buffs/restrained_orb" end
function modifier_item_patrol_restrained_orb:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_DEATH
}
end


function modifier_item_patrol_restrained_orb:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Lina.Array_triple")
local particle_peffect = ParticleManager:CreateParticle("particles/rare_orb_patrol.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

end




function modifier_item_patrol_restrained_orb:OnDeath(params)
if not IsServer() then return end

local attacker = params.attacker
if attacker.owner and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 
    attacker = attacker.owner
end


if self:GetParent() ~= attacker then return end
if not params.unit:IsValidKill(self:GetParent()) then return end

my_game:CreateUpgradeOrb(self:GetParent(), 2)
self:Destroy()
end