LinkLuaModifier( "modifier_slark_innate_custom", "abilities/slark/slark_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_innate_custom_creeps", "abilities/slark/slark_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_innate_custom_effect", "abilities/slark/slark_innate_custom", LUA_MODIFIER_MOTION_NONE )


slark_innate_custom = class({})

function slark_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_slark.vsndevts", context )
PrecacheResource( "particle",  "particles/units/heroes/hero_slark/slark_regen.vpcf", context )
dota1x6:PrecacheShopItems("npc_dota_hero_slark", context)
end


function slark_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_slark_innate_custom"
end



modifier_slark_innate_custom = class({})
function modifier_slark_innate_custom:IsHidden() return true end
function modifier_slark_innate_custom:IsPurgable() return false end
function modifier_slark_innate_custom:RemoveOnDeath() return false end
function modifier_slark_innate_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.move = self.ability:GetSpecialValueFor("bonus_movement_speed")
self.regen = self.ability:GetSpecialValueFor("bonus_regen")
self.creeps_duration = self.ability:GetSpecialValueFor("neutral_disable")
self.radius = self.ability:GetSpecialValueFor("radius")

if not IsServer() then return end
self.parent:AddDamageEvent_inc(self)

self:StartIntervalThink(0.2)
end

function modifier_slark_innate_custom:OnRefresh(table)
self:OnCreated()
end

function modifier_slark_innate_custom:OnIntervalThink()
if not IsServer() then return end

local seen = false
for _,player in pairs(players) do
  if player:GetTeamNumber() ~= self.parent:GetTeamNumber() and (player:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.radius and player:CanEntityBeSeenByMyTeam(self.parent) then
    seen = true
    break
  end
end

local mod = self.parent:FindModifierByName("modifier_slark_innate_custom_effect")

if self.parent:PassivesDisabled() then
  mod:SetEnd()
  return
end

if self.parent:HasModifier("modifier_slark_shadow_dance_custom_effect") then
  self:ApplyEffect()
else
  if seen == true or self.parent:HasModifier("modifier_slark_innate_custom_creeps") then
    if mod then
      mod:SetEnd()
    end
  else
    self:ApplyEffect()
  end
end

end


function modifier_slark_innate_custom:OnDestroy()
if not IsServer() then return end
self.parent:RemoveModifierByName("modifier_slark_innate_custom_effect")
end


function modifier_slark_innate_custom:ApplyEffect()
if not IsServer() then return end
self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_innate_custom_effect", {})
end

function modifier_slark_innate_custom:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if not params.attacker:IsCreep() then return end
if params.attacker:GetTeamNumber() ~= DOTA_TEAM_NEUTRALS and not params.attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_innate_custom_creeps", {duration = self.creeps_duration})
end






modifier_slark_innate_custom_creeps = class({})
function modifier_slark_innate_custom_creeps:IsHidden() return true end
function modifier_slark_innate_custom_creeps:IsPurgable() return false end





modifier_slark_innate_custom_effect = class({})
function modifier_slark_innate_custom_effect:IsHidden() return false end
function modifier_slark_innate_custom_effect:IsPurgable() return false end
function modifier_slark_innate_custom_effect:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.ending = false
self.move = self.ability:GetSpecialValueFor("bonus_movement_speed")
self.regen = self.ability:GetSpecialValueFor("bonus_regen") + self.parent:GetTalentValue("modifier_slark_dance_2", "heal")*self.parent:GetMaxHealth()/100
self.delay = self.ability:GetSpecialValueFor("shard_delay")
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_regen.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false) 
end

function modifier_slark_innate_custom_effect:SetEnd()
if not IsServer() then return end
if self.ending == true then return end

if not self.parent:HasShard() then
  self:Destroy()
else
  self:SetDuration(self.delay, true)
  self.ending = true
end

end


function modifier_slark_innate_custom_effect:OnRefresh()
self.ending = false
self.move = self.ability:GetSpecialValueFor("bonus_movement_speed")
self.regen = self.ability:GetSpecialValueFor("bonus_regen") + self.parent:GetTalentValue("modifier_slark_dance_2", "heal")*self.parent:GetMaxHealth()/100
if not IsServer() then return end
self:SetDuration(-1, true)
end


function modifier_slark_innate_custom_effect:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}
end

function modifier_slark_innate_custom_effect:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_slark_innate_custom_effect:GetModifierConstantHealthRegen()
return self.regen
end