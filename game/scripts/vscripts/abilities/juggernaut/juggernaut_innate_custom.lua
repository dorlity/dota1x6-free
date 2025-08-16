LinkLuaModifier( "modifier_juggernaut_duelist_custom", "abilities/juggernaut/juggernaut_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_juggernaut_duelist_custom_cd", "abilities/juggernaut/juggernaut_innate_custom", LUA_MODIFIER_MOTION_NONE )


juggernaut_innate_custom = class({})


function juggernaut_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_juggernaut_duelist_custom"
end

function juggernaut_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/jugg_parry.vpcf", context )
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_juggernaut.vsndevts", context )
PrecacheResource( "soundfile", "soundevents/vo_custom/juggernaut_vo_custom.vsndevts", context ) 
end



modifier_juggernaut_duelist_custom = class({})
function modifier_juggernaut_duelist_custom:IsHidden() return true end
function modifier_juggernaut_duelist_custom:IsPurgable() return false end
function modifier_juggernaut_duelist_custom:RemoveOnDeath() return false end
function modifier_juggernaut_duelist_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_inc = self.ability:GetSpecialValueFor("damage_inc")
self.damage_reduce = self.ability:GetSpecialValueFor("damage_reduce")

self.cd = false
end


function modifier_juggernaut_duelist_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_juggernaut_duelist_custom:GetModifierTotalDamageOutgoing_Percentage(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if not params.target:IsUnit() then return end

local facing_direction = params.target:GetAnglesAsVector().y
local attacker_vector = (self.parent:GetOrigin() - params.target:GetOrigin()):Normalized()
local attacker_direction = VectorToAngles(attacker_vector).y
local angle_diff =  math.abs(AngleDiff(facing_direction, attacker_direction))

if self.parent:HasModifier("modifier_custom_juggernaut_omnislash") or (angle_diff < 85) then 
  return self.damage_inc
end 

end

function modifier_juggernaut_duelist_custom:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if not params.attacker:IsUnit() then return end

local vector = (self.parent:GetAbsOrigin()-params.attacker:GetAbsOrigin()):Normalized()
local center_angle = VectorToAngles( vector ).y
local facing_angle = VectorToAngles(self.parent:GetForwardVector() ).y
local facing = ( math.abs( AngleDiff(center_angle,facing_angle) ) > 85 )

if facing then 
  if self.cd == false then 
    self.cd = true
    self:StartIntervalThink(2)
    self.parent:EmitSound("Juggernaut.Parry")
    local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
    ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControl( particle, 1, self.parent:GetAbsOrigin() )
  end 
  return self.damage_reduce
end 

end


function modifier_juggernaut_duelist_custom:OnIntervalThink()
if not IsServer() then return end 

self.cd = false
self:StartIntervalThink(-1)
end
