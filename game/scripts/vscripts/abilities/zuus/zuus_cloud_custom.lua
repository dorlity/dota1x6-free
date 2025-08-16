LinkLuaModifier("modifier_zuus_cloud_custom", "abilities/zuus/zuus_cloud_custom", LUA_MODIFIER_MOTION_NONE)

zuus_cloud_custom = class({})


function zuus_cloud_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_zeus/zeus_cloud.vpcf", context )
end


function zuus_cloud_custom:GetAOERadius()
return self:GetSpecialValueFor("cloud_radius")
end


function zuus_cloud_custom:OnSpellStart()

local caster = self:GetCaster()
local target_point 	= self:GetCursorPosition()
local cloud_duration = self:GetSpecialValueFor("cloud_duration")

EmitSoundOnLocationWithCaster(target_point, "Hero_Zuus.Cloud.Cast", caster)

self.zuus_nimbus_unit = CreateUnitByName("npc_dota_zeus_cloud", target_point + Vector(0, 0, 450), false, caster, nil, caster:GetTeamNumber())

self.zuus_nimbus_unit:SetControllableByPlayer(caster:GetPlayerID(), true)
self.zuus_nimbus_unit:SetModelScale(0.7)
self.zuus_nimbus_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_phased", {})
self.zuus_nimbus_unit:AddNewModifier(caster, self, "modifier_zuus_cloud_custom", {duration = cloud_duration})
self.zuus_nimbus_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = cloud_duration})
end

modifier_zuus_cloud_custom = class(mod_hidden)


function modifier_zuus_cloud_custom:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self:SetStackCount(450)
self.strike_delay = self.ability:GetSpecialValueFor("cloud_bolt_interval")
self.radius = self.ability:GetSpecialValueFor("cloud_radius")
self.hits_to_kill = self.ability:GetSpecialValueFor("hits_to_kill")

if not IsServer() then return end

self.ability:EndCd()
self.parent:AddAttackEvent_inc(self, true)

self.lightning_bolt =self.caster:FindAbilityByName("zuus_lightning_bolt_custom")
self.point = GetGroundPosition(self.parent:GetAbsOrigin(), nil)

self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, self.point)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.radius, 0, 0))
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, self.point + Vector(0, 0, self:GetStackCount()))	
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

self.count = self.strike_delay
self.interval = 0.1
self:StartIntervalThink(self.interval)
end

function modifier_zuus_cloud_custom:OnDestroy()
if not IsServer() then return end
self.ability:StartCd()
end


function modifier_zuus_cloud_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_PROPERTY_HEALTHBAR_PIPS,
}
end

function modifier_zuus_cloud_custom:GetModifierHealthBarPips() return self.hits_to_kill end

function modifier_zuus_cloud_custom:GetVisualZDelta()
return self:GetStackCount()
end

function modifier_zuus_cloud_custom:OnIntervalThink()
if not IsServer() then return end
if not self.lightning_bolt or self.lightning_bolt:IsNull() or not self.lightning_bolt:IsTrained() then return end

if self.count < self.strike_delay then
	self.count = self.count + self.interval
	return
end

for _,unit in pairs(self.caster:FindTargets(self.radius, self.point)) do
	self.lightning_bolt:CastLightningBolt(unit:GetAbsOrigin(), self.parent)
	self.count = 0
	break
end

end


function modifier_zuus_cloud_custom:AttackEvent_inc(params)
if params.target ~= self:GetParent() then return end

if self.parent:GetHealth() > 1 then 
	self.parent:SetHealth(self.parent:GetHealth() - 1)
else 
	self.parent:Kill(nil, params.attacker)
end

end

function modifier_zuus_cloud_custom:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_zuus_cloud_custom:GetAbsoluteNoDamageMagical() return 1 end
function modifier_zuus_cloud_custom:GetAbsoluteNoDamagePure() return 1 end

