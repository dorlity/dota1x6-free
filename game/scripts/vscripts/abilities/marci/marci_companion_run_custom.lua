LinkLuaModifier( "modifier_marci_companion_run_custom", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_marci_companion_run_custom_buff", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_legendary_second", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_after_cd", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_resist", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_resist_tracker", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_tracker", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_double", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_slow", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )



marci_companion_run_custom = class({})


function marci_companion_run_custom:CreateTalent()
local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_marci_companion_run_custom_tracker")
if mod then
	mod.PercentStr = caster:GetTalentValue("modifier_marci_rebound_3", "str")/100
end

end


function marci_companion_run_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_charge_projectile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_landing_zone.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_landing_zone.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_burst.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce.vpcf", context )
PrecacheResource( "particle", "particles/marci_field.vpcf", context )
PrecacheResource( "particle", "particles/alch_stun_legendary.vpcf", context )
PrecacheResource( "particle", "particles/marci/rebound_double.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/sange_maim.vpcf", context )
end



function marci_companion_run_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_marci_companion_run_custom_tracker"
end 


function marci_companion_run_custom:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end
	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		self:GetCaster():GetTeamNumber()
	)
	if nResult ~= UF_SUCCESS then
		return nResult
	end
	self.targetcast = hTarget
	return UF_SUCCESS
end

function marci_companion_run_custom:GetManaCost(iLevel)

if self:GetCaster():HasTalent("modifier_marci_rebound_5") then 
  return 0
end
return self.BaseClass.GetManaCost(self, iLevel)
end


function marci_companion_run_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasTalent("modifier_marci_rebound_1") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_marci_rebound_1", "range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function marci_companion_run_custom:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end


function marci_companion_run_custom:GetAOERadius()
if self:GetCaster():HasTalent("modifier_marci_rebound_7") then
	return self:GetSpecialValueFor("landing_radius")
end

end


function marci_companion_run_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_marci_rebound_7") then
  return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE 
end

return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES 
end


function marci_companion_run_custom:GetDamage()
local caster = self:GetCaster()
return self:GetSpecialValueFor("impact_damage") + caster:GetTalentValue("modifier_marci_rebound_3", "damage")*caster:GetStrength()/100
end

function marci_companion_run_custom:DealDamage()
if not IsServer() then return end

local caster = self:GetCaster()
local radius = self:GetSpecialValueFor("landing_radius")
local stun = self:GetSpecialValueFor("stun_duration") + caster:GetTalentValue("modifier_marci_rebound_1", "stun")
local slow_duration = caster:GetTalentValue("modifier_marci_rebound_2", "duration")

caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END,1)

local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
local damageTable = { attacker = caster, damage = self:GetDamage(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self, }
		
for _,enemy in pairs(enemies) do
	damageTable.victim = enemy
	DoDamage(damageTable)

	if enemy:IsRealHero() and caster:GetQuest() == "Marci.Quest_6" then 
		caster:UpdateQuest(1)
	end
	enemy:AddNewModifier(caster, self, "modifier_marci_companion_run_custom_slow", {duration = slow_duration})
	enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*stun})
end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, caster:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 9, Vector(radius, radius, radius) )
ParticleManager:SetParticleControl( effect_cast, 10, caster:GetAbsOrigin() )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( caster:GetAbsOrigin(), "Hero_Marci.Rebound.Impact", caster )


if caster:HasTalent("modifier_marci_rebound_6") then 
	CreateModifierThinker(caster, self, "modifier_marci_companion_run_custom_resist_tracker", {duration = caster:GetTalentValue("modifier_marci_rebound_6", "duration")}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
end	

end



function marci_companion_run_custom:OnVectorCastStart(vStartLocation, vDirection)

local caster = self:GetCaster()
local target = self.targetcast

if target and target:GetTeamNumber() ~= caster:GetTeamNumber() and target:TriggerSpellAbsorb(self) then
	return
end

local speed = self:GetSpecialValueFor( "move_speed" )
local info = { Target = target, Source = caster, Ability = self, iMoveSpeed = speed, bDodgeable = false, }
local proj = ProjectileManager:CreateTrackingProjectile(info)

local point = target:GetAbsOrigin()
local point_check = point

if not caster:HasTalent("modifier_marci_rebound_7") then 
	point = self:GetVector2Position()
	point_check = self:GetTargetPositionCheck()
end 

local jump_heh = false
local sravnenie = ((point_check-point):Length2D())
sravnenie = math.abs(sravnenie)

if sravnenie<= 50 then
	jump_heh = true
end

self.modifier = caster:AddNewModifier( caster, self, "modifier_marci_companion_run_custom", { proj = tostring(proj), target = target:entindex(), point_x = point.x, point_y = point.y, point_z = point.z, jump_heh = jump_heh } )

if caster:HasTalent("modifier_marci_rebound_7") and caster:GetTeamNumber() ~= target:GetTeamNumber() then 
	caster:AddNewModifier(caster, self, "modifier_marci_companion_run_custom_legendary_second", {target = target:entindex(), duration = caster:GetTalentValue("modifier_marci_rebound_7", "duration")})
end 

end



function marci_companion_run_custom:OnSpellStart()
if not self:GetCaster():HasTalent("modifier_marci_rebound_7") then return end 
self:OnVectorCastStart()
end 




function marci_companion_run_custom:OnProjectileHit( target, location )
if not self.modifier:IsNull() then
	if not target then
		self.modifier.interrupted = true
	end
	self.modifier:Destroy()
end

end




modifier_marci_companion_run_custom = class({})

function modifier_marci_companion_run_custom:IsHidden() return true end
function modifier_marci_companion_run_custom:IsPurgable() return false end

function modifier_marci_companion_run_custom:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.duration = 0.5
self.height = self.ability:GetSpecialValueFor( "min_height_above_highest" )
self.min_distance = self.ability:GetSpecialValueFor( "min_jump_distance" )
self.max_distance = self.ability:GetSpecialValueFor( "max_jump_distance" )
self.radius = self.ability:GetSpecialValueFor( "landing_radius" )
self.damage = self.ability:GetSpecialValueFor( "impact_damage" )
self.debuff = self.ability:GetSpecialValueFor( "debuff_duration" )
self.buff = self.ability:GetSpecialValueFor( "ally_buff_duration" )


if not IsServer() then return end

self.projectile = tonumber(kv.proj)
self.target = EntIndexToHScript( kv.target )
self.targetpos = self.target:GetOrigin()
self.distancethreshold = 2000

if not self:ApplyHorizontalMotionController() then
	self.interrupted = true
	self:Destroy()
end

local speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
self:PlayEffects1( self.parent, speed )


if self.parent:HasTalent("modifier_marci_rebound_7") then return end

self.start_direction = self.targetpos - self.parent:GetAbsOrigin()

self.point = Vector( kv.point_x, kv.point_y, kv.point_z )

self.direction = self.point - self.target:GetAbsOrigin()

self.distance = self.direction:Length2D()

self.jump_heh = kv.jump_heh
if self.jump_heh == 1 then
	self.direction = self.start_direction
end

self.direction.z = 0
self.direction = self.direction:Normalized()

self.distance = math.min(math.max(self.distance,self.min_distance),self.max_distance)

self:PlayEffects3( self.target:GetAbsOrigin() + self.distance * self.direction, self.radius )
end




function modifier_marci_companion_run_custom:OnDestroy()
if not IsServer() then return end	
self.parent:RemoveHorizontalMotionController( self )

if self.interrupted then return end

if self.target and not self.target:IsNull() and self.target:IsAlive() then 

	if self.parent:HasTalent("modifier_marci_rebound_4") then 
		self.target:AddNewModifier(self.parent, self.ability, "modifier_marci_companion_run_custom_double", {duration = self.parent:GetTalentValue("modifier_marci_rebound_4", "delay")})
	end	

end


if self.parent:HasTalent("modifier_marci_rebound_7") then 
	self.ability:DealDamage()
	return
end


local allied = self.target:GetTeamNumber()==self.parent:GetTeamNumber()
if allied then
	self.target:AddNewModifier( self.parent, self.ability, "modifier_marci_companion_run_custom_buff", { duration = self.buff } )
end

self.parent:SetForwardVector( self.direction )

local arc = self.parent:AddNewModifier( self.parent, self:GetAbility(), "modifier_generic_arc",
{ 
	dir_x = self.direction.x,
	dir_y = self.direction.y,
	duration = self.duration,
	distance = self.distance,
	height = self.height,
	fix_end = false,
	isStun = true,
	isForward = true,
	isInvun = self.parent:HasTalent("modifier_marci_rebound_5"),
	activity = ACT_DOTA_OVERRIDE_ABILITY_2,
})


arc:SetEndCallback( function( interrupted )
	self.ability:DealDamage()
end)

self:PlayEffects2( self.parent, arc, allied )
end


function modifier_marci_companion_run_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_marci_companion_run_custom:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_2_ALLY
end

function modifier_marci_companion_run_custom:CheckState()
local state = 
{
	[MODIFIER_STATE_STUNNED] = true,
}

if self.parent:HasTalent("modifier_marci_rebound_5") then 
	state = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end 

return state
end

function modifier_marci_companion_run_custom:UpdateHorizontalMotion( me, dt )
local targetpos = self.target:GetOrigin()
if (targetpos - self.targetpos):Length2D()>self.distancethreshold then
	self.dodged = true
	self.interrupted = true
	return
end
self.targetpos = targetpos
local loc = ProjectileManager:GetTrackingProjectileLocation( self.projectile )
me:SetOrigin( GetGroundPosition( loc, me ) )
me:FaceTowards( self.target:GetOrigin() )
end


function modifier_marci_companion_run_custom:OnHorizontalMotionInterrupted()
self.interrupted = true
self:Destroy()
end




function modifier_marci_companion_run_custom:PlayEffects1( caster, speed )
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_charge_projectile.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControlEnt( effect_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( speed, 0, 0 ) )
self:AddParticle( effect_cast, false, false, -1, false, false)
caster:EmitSound("Hero_Marci.Rebound.Cast")
end

function modifier_marci_companion_run_custom:PlayEffects2( caster, buff )
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControlEnt( effect_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( effect_cast, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
buff:AddParticle( effect_cast, false, false, -1, false, false )
caster:EmitSound("Hero_Marci.Rebound.Leap")
end

function modifier_marci_companion_run_custom:PlayEffects3( center, radius )
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_landing_zone.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, center )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_marci_companion_run_custom:PlayEffects4( center, origin, radius )
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, center )
ParticleManager:SetParticleControl( effect_cast, 1, origin )
ParticleManager:SetParticleControl( effect_cast, 9, Vector(radius, radius, radius) )
ParticleManager:SetParticleControl( effect_cast, 10, center )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( center, "Hero_Marci.Rebound.Impact", self.parent )
end














modifier_marci_companion_run_custom_buff = class({})

function modifier_marci_companion_run_custom_buff:IsHidden() return false end
function modifier_marci_companion_run_custom_buff:IsPurgable() return true end
function modifier_marci_companion_run_custom_buff:OnCreated( kv )
self.ms_bonus = self:GetAbility():GetSpecialValueFor( "ally_movespeed_pct" )

if not IsServer() then return end
self:GetParent():EmitSound("Hero_Marci.Rebound.Ally")
end



function modifier_marci_companion_run_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_marci_companion_run_custom_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

function modifier_marci_companion_run_custom_buff:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end
function modifier_marci_companion_run_custom_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end












marci_rebound_bounce_legendary = class({})

function marci_rebound_bounce_legendary:GetAOERadius()
return self:GetSpecialValueFor("radius")
end 

function marci_rebound_bounce_legendary:GetCastRange()
if IsClient() then 
	return self:GetSpecialValueFor("range")
end 

return 99999
end 

function marci_rebound_bounce_legendary:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()

local mod = caster:FindModifierByName("modifier_marci_companion_run_custom_legendary_second")
if not mod then return end

self.target_abs = self:GetCursorPosition()

if self.target_abs == caster:GetAbsOrigin() then 
	self.target_abs = caster:GetAbsOrigin() + caster:GetForwardVector()*10
end 

self.radius = self:GetSpecialValueFor("radius")
self.direction = (self.target_abs - caster:GetAbsOrigin())
self.direction.z = 0
self.direction = self.direction:Normalized()

local origin =  caster:GetOrigin()
local max_range = self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()

if (self.target_abs - origin):Length2D() > max_range then 
	self.target_abs = origin + max_range*self.direction
end 

self.distance = (self.target_abs - origin):Length2D()
caster:EmitSound("Hero_Marci.Rebound.Cast")

self.ability = caster:FindAbilityByName("marci_companion_run_custom")

self.duration = 0.3
if self.distance >= 600 then 
	self.duration = 0.5
end

caster:SetForwardVector( self.direction )

self.damage = self.ability:GetDamage()*mod:GetStackCount()*caster:GetTalentValue("modifier_marci_rebound_7", "damage")/100

self.heal = caster:GetTalentValue("modifier_marci_rebound_7", "heal")/100

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_landing_zone.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self.target_abs )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex( effect_cast )


local arc = caster:AddNewModifier( caster, self.ability, "modifier_generic_arc",
	{ 
	dir_x = self.direction.x,
	dir_y = self.direction.y,
	duration = self.duration,
	distance = self.distance,
	height = self.ability:GetSpecialValueFor( "min_height_above_highest" ),
	fix_end = false,
	isStun = true,
	isForward = true,
	isInvun = caster:HasTalent("modifier_marci_rebound_5"),
	activity = ACT_DOTA_OVERRIDE_ABILITY_2,
})
	
arc:SetEndCallback( function( interrupted )

	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END, 1)

  EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Pango.Shield_legendary", caster)

  local smash2 = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_burst.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(smash2, 0, caster:GetAbsOrigin())
  ParticleManager:SetParticleControl(smash2, 1, Vector(self.radius, self.radius, self.radius))
  ParticleManager:DestroyParticle(smash2, false)
  ParticleManager:ReleaseParticleIndex(smash2)

	local enemies = caster:FindTargets(self.radius, caster:GetAbsOrigin())
	
	local damageTable = { attacker = caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability, }
	
	caster:GenericHeal(self.damage*self.heal, self.ability, nil, nil, "modifier_marci_rebound_7")

	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		local real_damage = DoDamage(damageTable, "modifier_marci_rebound_7")

		enemy:SendNumber(6,  real_damage)
	end

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, caster:GetOrigin() )
	ParticleManager:SetParticleControl( particle, 1, Vector(self.radius, self.radius,self.radius) )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, caster:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 9, Vector(self.radius, self.radius, self.radius) )
	ParticleManager:SetParticleControl( effect_cast, 10, caster:GetOrigin() )
	ParticleManager:DestroyParticle(effect_cast, false)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( caster:GetOrigin(), "Hero_Marci.Rebound.Impact", caster )

end)

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( effect_cast, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
arc:AddParticle( effect_cast, false, false, -1, false, false )


mod:Destroy()

end




modifier_marci_companion_run_custom_legendary_second = class({})
function modifier_marci_companion_run_custom_legendary_second:IsHidden() return true end
function modifier_marci_companion_run_custom_legendary_second:IsPurgable() return false end
function modifier_marci_companion_run_custom_legendary_second:OnCreated(table)

self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_marci_rebound_7", "max")

if not IsServer() then return end
self.RemoveForDuel = true

self.ability = self.parent:FindAbilityByName("marci_companion_run_custom")
self.ability_2 = self.parent:FindAbilityByName("marci_rebound_bounce_legendary")

if not self.ability or not self.ability_2 then 
	self:Destroy()
	return
end

self.ability_2:StartCooldown(0.5)
self.parent:SwapAbilities(self.ability:GetName(), self.ability_2:GetName(), false, true)

self.target = EntIndexToHScript(table.target)
self.max_time = self:GetRemainingTime()
self.interval = FrameTime()

self.timer = self.parent:GetTalentValue("modifier_marci_rebound_7", "duration")*2 
self:StartIntervalThink(self.interval)
self:OnIntervalThink()
end



function modifier_marci_companion_run_custom_legendary_second:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = self:GetStackCount(), style = "MarciRebound", priority = 1})
end




function modifier_marci_companion_run_custom_legendary_second:OnDestroy()
if not IsServer() then return end

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "MarciRebound", priority = 1})

if not self.ability or not self.ability_2 then return end

self.parent:SwapAbilities(self.ability:GetName(), self.ability_2:GetName(), true, false)
self.ability:UseResources(false, false, false, true)

local mod = self.parent:FindModifierByName("modifier_marci_companion_run_custom_after_cd")

if mod then 
	self.parent:CdAbility(self.ability, mod:GetStackCount()*self.parent:GetTalentValue("modifier_marci_rebound_5", "cd"))
	mod:Destroy()
end

end






















modifier_marci_companion_run_custom_resist_tracker = class({})
function modifier_marci_companion_run_custom_resist_tracker:IsHidden() return true end
function modifier_marci_companion_run_custom_resist_tracker:IsPurgable() return false end
function modifier_marci_companion_run_custom_resist_tracker:IsAura() return true end
function modifier_marci_companion_run_custom_resist_tracker:GetAuraDuration() return 0.1 end
function modifier_marci_companion_run_custom_resist_tracker:GetAuraRadius() return self.radius end
function modifier_marci_companion_run_custom_resist_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_marci_companion_run_custom_resist_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_marci_companion_run_custom_resist_tracker:GetModifierAura() return "modifier_marci_companion_run_custom_resist" end
function modifier_marci_companion_run_custom_resist_tracker:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.radius = self.caster:GetTalentValue("modifier_marci_rebound_6", "radius")

if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/marci_field.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 1 ) )
self:AddParticle( effect_cast, 	false, false, -1, false, false )
end




modifier_marci_companion_run_custom_resist = class({})

function modifier_marci_companion_run_custom_resist:IsPurgable() return false end
function modifier_marci_companion_run_custom_resist:IsHidden() return true end 
function modifier_marci_companion_run_custom_resist:GetEffectName() return "particles/alch_stun_legendary.vpcf" end

function modifier_marci_companion_run_custom_resist:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end	

function modifier_marci_companion_run_custom_resist:GetModifierIncomingDamage_Percentage()
return self.damage
end

function modifier_marci_companion_run_custom_resist:GetModifierStatusResistanceStacking()
return self.status
end

function modifier_marci_companion_run_custom_resist:OnCreated()

self.parent = self:GetParent()

self.status = self.parent:GetTalentValue("modifier_marci_rebound_6", "status")
self.damage = self.parent:GetTalentValue("modifier_marci_rebound_6", "damage")
end 






modifier_marci_companion_run_custom_after_cd = class({})
function modifier_marci_companion_run_custom_after_cd:IsHidden() return true end
function modifier_marci_companion_run_custom_after_cd:IsPurgable() return false end
function modifier_marci_companion_run_custom_after_cd:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_marci_companion_run_custom_after_cd:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end





modifier_marci_companion_run_custom_tracker = class({})
function modifier_marci_companion_run_custom_tracker:IsHidden() return true end
function modifier_marci_companion_run_custom_tracker:IsPurgable() return false end

function modifier_marci_companion_run_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
}

end

function modifier_marci_companion_run_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.cd_inc = self.parent:GetTalentValue("modifier_marci_rebound_5", "cd", true)
end 




function modifier_marci_companion_run_custom_tracker:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local mod = self.parent:FindModifierByName("modifier_marci_companion_run_custom_legendary_second")

if mod and mod:GetStackCount() < mod.max then 
	mod:IncrementStackCount()
end 



if not self.parent:HasTalent("modifier_marci_rebound_5") then return end

if self.parent:HasModifier("modifier_marci_companion_run_custom_legendary_second") then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_companion_run_custom_after_cd", {})
else 

	self.parent:CdAbility(self.ability, self.cd_inc)
end


end




modifier_marci_companion_run_custom_double = class({})
function modifier_marci_companion_run_custom_double:IsHidden() return true end
function modifier_marci_companion_run_custom_double:IsPurgable() return false end
function modifier_marci_companion_run_custom_double:OnCreated()

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.point = self.parent:GetAbsOrigin()

self.radius = self.caster:GetTalentValue("modifier_marci_rebound_4", "radius")
self.stun = self.caster:GetTalentValue("modifier_marci_rebound_4", "stun")
self.attacks = self.caster:GetTalentValue("modifier_marci_rebound_4", "attacks")

if not IsServer() then return end 

self.timer = self:GetRemainingTime()

self.effect_cast = ParticleManager:CreateParticle("particles/marci/rebound_double.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( self.effect_cast, 0, self.point )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius/self.timer) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self.timer, 0, 0 ) )
self:AddParticle( self.effect_cast, false, false, -1, false, false)

end 


function modifier_marci_companion_run_custom_double:OnDestroy()
if not IsServer() then return end

self.point = self.parent:GetAbsOrigin()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self.point )
ParticleManager:SetParticleControl( effect_cast, 1, self.point )
ParticleManager:SetParticleControl( effect_cast, 9, Vector(self.radius, self.radius, self.radius) )
ParticleManager:SetParticleControl( effect_cast, 10, self.point )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self.point, "Hero_Marci.Rebound.Impact", self.caster )


for _,enemy in pairs(self.caster:FindTargets(self.radius, self.point)) do
	enemy:AddNewModifier(self.caster, self.ability, "modifier_marci_dispose_custom_attacks", {max = self.attacks})
	enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.stun})
end 

end 





modifier_marci_companion_run_custom_slow = class({})
function modifier_marci_companion_run_custom_slow:IsHidden() return true end
function modifier_marci_companion_run_custom_slow:IsPurgable() return false end

function modifier_marci_companion_run_custom_slow:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_marci_rebound_2", "slow")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_marci_rebound_2", "heal_reduce")

if not IsServer() then return end 
self:AddParticle( ParticleManager:CreateParticle( "particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ), false, false, -1, false, false)
end

function modifier_marci_companion_run_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_marci_companion_run_custom_slow:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end


function modifier_marci_companion_run_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_marci_companion_run_custom_slow:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_marci_companion_run_custom_slow:GetModifierHealAmplify_PercentageTarget() 
return self.heal_reduce
end

function modifier_marci_companion_run_custom_slow:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end
