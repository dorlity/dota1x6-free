LinkLuaModifier( "modifier_zuus_innate_custom", "abilities/zuus/zuus_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zuus_innate_custom_cast_cd", "abilities/zuus/zuus_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zuus_innate_custom_purge_cd", "abilities/zuus/zuus_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_zuus_innate_custom_damage_reduce", "abilities/zuus/zuus_innate_custom", LUA_MODIFIER_MOTION_NONE )


zuus_innate_custom = class({})

function zuus_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_static_field.vpcf", context )
PrecacheResource( "particle","particles/zeus/lowhp_damage_reduce.vpcf", context )
PrecacheResource( "soundfile", "soundevents/vo_custom/zuus_vo_custom.vsndevts", context ) 

PrecacheResource( "soundfile", "soundevents/npc_dota_hero_zuus.vsndevts", context )
end


function zuus_innate_custom:GetAbilityTargetFlags()
if self:GetCaster():HasShard() then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function zuus_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_zuus_innate_custom"
end

modifier_zuus_innate_custom = class({})
function modifier_zuus_innate_custom:IsHidden() return true end
function modifier_zuus_innate_custom:IsPurgable() return false end
function modifier_zuus_innate_custom:RemoveOnDeath() return false end
function modifier_zuus_innate_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.shard_heal = self.ability:GetSpecialValueFor("shard_heal")/100
self.shard_damage = self.ability:GetSpecialValueFor("shard_damage")/100

self.damage = self.ability:GetSpecialValueFor("damage")/100
self.creeps = self.ability:GetSpecialValueFor("damage_creeps")

self.status_bonus = self.parent:GetTalentValue("modifier_zuus_hero_6", "status", true)
self.cast_radius = self.parent:GetTalentValue("modifier_zuus_hero_6", "radius", true)
self.cast_cd = self.parent:GetTalentValue("modifier_zuus_hero_6", "talent_cd", true)
self.cast_stun = self.parent:GetTalentValue("modifier_zuus_hero_6", "stun", true)

self.purge_cd = self.parent:GetTalentValue("modifier_zuus_hero_7", "talent_cd", true)
self.purge_health = self.parent:GetTalentValue("modifier_zuus_hero_7", "health", true)
self.purge_duration = self.parent:GetTalentValue("modifier_zuus_hero_7", "duration", true)
self.knock_radius = self.parent:GetTalentValue("modifier_zuus_hero_7", "radius", true)
self.knock_duation = self.parent:GetTalentValue("modifier_zuus_hero_7", "knock_duration", true)
 
self:UpdateTalent()
end

function modifier_zuus_innate_custom:OnRefresh(table)
self:OnCreated()
end

function modifier_zuus_innate_custom:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_zuus_hero_6" or self.parent:HasTalent("modifier_zuus_hero_6") then
	self.parent:AddSpellEvent(self, true)
end

if name == "modifier_zuus_hero_7" or self.parent:HasTalent("modifier_zuus_hero_7") then
	self.parent:AddDamageEvent_inc(self, true)
end

end

function modifier_zuus_innate_custom:DamageEvent_inc(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_zuus_hero_7") then return end
if self.parent ~= params.unit then return end
if self.parent:PassivesDisabled() then return end
if not self.parent:IsAlive() then return end
if self.parent:GetHealthPercent() > self.purge_health then return end
if self.parent:HasModifier("modifier_zuus_innate_custom_purge_cd") then return end

self.parent:Purge(false, true, false, true, false)
self.parent:GenericParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf")

self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_innate_custom_damage_reduce", {duration = self.purge_duration})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_innate_custom_purge_cd", {duration = self.purge_cd})
self.parent:EmitSound("Zuus.Wrath_knockback")
self.parent:EmitSound("Zuus.Purge_dispel")

local max = 6
local line_position = self.parent:GetAbsOrigin() + self.parent:GetForwardVector() * 400
for i = 1, max do
	local qangle = QAngle(0, 360/max, 0)
	line_position = RotatePosition(self.parent:GetAbsOrigin() , qangle, line_position)

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	local n = RandomInt(1, 2)
	ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack"..n, self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, line_position)
	ParticleManager:DestroyParticle(particle, false)	
	ParticleManager:ReleaseParticleIndex(particle)
end

for _,unit in pairs(self.parent:FindTargets(self.knock_radius)) do
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack"..RandomInt(1, 2), self.parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)
	unit:GenericParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf")
	
	local vec = unit:GetAbsOrigin() - self.parent:GetAbsOrigin()
	local point = self.parent:GetAbsOrigin() + vec:Normalized()*self.knock_radius

	local knockbackProperties =
	{
	  center_x = self.parent:GetOrigin().x,
	  center_y = self.parent:GetOrigin().y,
	  center_z = self.parent:GetOrigin().z,
	  duration = self.knock_duation,
	  knockback_duration = self.knock_duation,
	  knockback_distance = (point - unit:GetAbsOrigin()):Length2D(),
	  knockback_height = 0
	}
	unit:AddNewModifier( self.parent, self, "modifier_knockback", knockbackProperties )
end

end


function modifier_zuus_innate_custom:SpellEvent(params)
if not self.parent:HasTalent("modifier_zuus_hero_6") then return end

local unit = params.unit

if unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end
if self.parent:PassivesDisabled() then return end
if params.ability:IsItem() then return end
if (unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.cast_radius then return end
if not self.parent:IsAlive() then return end

if unit:IsInvulnerable() then return end
if unit:HasModifier("modifier_zuus_innate_custom_cast_cd") then return end

local target_point = unit:GetAbsOrigin()
local z_pos = 3000
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, z_pos))
ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, target_point.z))
ParticleManager:ReleaseParticleIndex(particle)

local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle2, 0, Vector(target_point.x, target_point.y, z_pos))
ParticleManager:SetParticleControl(particle2, 1, Vector(target_point.x, target_point.y, target_point.z))
ParticleManager:ReleaseParticleIndex(particle2)

unit:EmitSound("Hero_Zuus.LightningBolt.Righteous")
unit:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = self.cast_stun})
unit:AddNewModifier(self.parent, self.ability, "modifier_zuus_innate_custom_cast_cd", {duration = self.cast_cd})
end


function modifier_zuus_innate_custom:DealDamage(target)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end

local damage = self.parent:HasShard() and (self.damage + self.shard_damage) or self.damage
damage = damage*target:GetHealth()

if target:IsCreep() then
	damage = math.min(damage, self.creeps)
end


local real_damage = DoDamage({victim = target, attacker = self.parent, ability = self.ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

if self.parent:HasShard() and self.parent:IsRealHero() then
	self.parent:GenericHeal(real_damage*self.shard_heal, self.ability, true, "", "shard")
end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_zuus_innate_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end


function modifier_zuus_innate_custom:GetModifierStatusResistanceStacking() 
if not self.parent:HasTalent("modifier_zuus_hero_6") then return end
return self.status_bonus
end


modifier_zuus_innate_custom_cast_cd = class(mod_hidden)
function modifier_zuus_innate_custom_cast_cd:OnCreated()
self.RemoveForDuel = true
end

modifier_zuus_innate_custom_purge_cd = class(mod_cd)
function modifier_zuus_innate_custom_purge_cd:GetTexture() return "buffs/Pulse_damage" end




modifier_zuus_innate_custom_damage_reduce = class(mod_hidden)
function modifier_zuus_innate_custom_damage_reduce:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_zuus_innate_custom_damage_reduce:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_zuus_innate_custom_damage_reduce:OnCreated()
self.parent = self:GetParent()
self.damage_reduce = self.parent:GetTalentValue("modifier_zuus_hero_7", "damage_reduce")
if not IsServer() then return end
self.parent:GenericParticle("particles/zeus/lowhp_damage_reduce.vpcf", self)
end

function modifier_zuus_innate_custom_damage_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_zuus_innate_custom_damage_reduce:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end