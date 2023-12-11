LinkLuaModifier("modifier_custom_void_remnant_thinker", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_target", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_tracker", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_slow", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_stats", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_legendary", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_legendary_caster", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_legendary_far", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_resist", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_armor", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)



void_spirit_aether_remnant_custom = class({})





function void_spirit_aether_remnant_custom:Precache(context)
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/void_spirit_attack_alt_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/void_spirit_attack_alt_02_blur.vpcf", context )


PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_agi.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_str.vpcf", context )
PrecacheResource( "particle", "particles/ogre_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pre.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_watch.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_flash.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_void_spirit_aether_remnant.vpcf", context )
PrecacheResource( "particle", "particles/void_step_texture.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/void_spirit/remnant_legendary.vpcf", context )
PrecacheResource( "particle", "particles/void_spirit/remnant_hit.vpcf", context )

end


function void_spirit_aether_remnant_custom:GetCooldown(iLevel)

local upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_void_remnant_1", "cd")

return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end


function void_spirit_aether_remnant_custom:ProcDamage(target)


local damage = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "damage")
local heal = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "heal")/100


local hit_effect = ParticleManager:CreateParticle("particles/void_spirit/remnant_hit.vpcf", PATTACH_CUSTOMORIGIN, target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

local real_damage = ApplyDamage({victim = target, attacker = self:GetCaster(), damage = damage, ability = self,  damage_type = DAMAGE_TYPE_MAGICAL})

target:SendNumber(4, real_damage)

local heal_target = self:GetCaster()
if self:GetCaster().owner then 
	heal_target = self:GetCaster().owner
end

heal_target:GenericHeal(real_damage*heal, self)

target:EmitSound("Hoodwink.Scurry_attack")
end




function void_spirit_aether_remnant_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0

if self:GetCaster():HasShard() then 
	upgrade = self:GetSpecialValueFor("shard_distance")
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function void_spirit_aether_remnant_custom:GetIntrinsicModifierName()
return "modifier_custom_void_remnant_tracker"
end

function void_spirit_aether_remnant_custom:OnVectorCastStart(vStartLocation, vDirection)
-- unit identifier
local caster = self:GetCaster()

local point = self:GetCursorPosition()

if point == self:GetCaster():GetAbsOrigin() then 
	point = self:GetCaster():GetAbsOrigin() + 10*self:GetCaster():GetForwardVector()
end 

CreateModifierThinker(
	caster, 
	self,
	"modifier_custom_void_remnant_thinker", 
	{
		dir_x = vDirection.x,
		dir_y = vDirection.y,
		dir_z = vDirection.z,
	}, 
	point,
	caster:GetTeamNumber(),
	false
)


local sound_cast = "Hero_VoidSpirit.AetherRemnant.Cast"
caster:EmitSound(sound_cast)
end



modifier_custom_void_remnant_thinker = class({})


local STATE_RUN = 1
local STATE_DELAY = 2
local STATE_WATCH = 3
local STATE_PULL = 4

function modifier_custom_void_remnant_thinker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
}
end
function modifier_custom_void_remnant_thinker:GetModifierProvidesFOWVision() return 1 end

function modifier_custom_void_remnant_thinker:OnCreated( kv )

	self.interval = self:GetAbility():GetSpecialValueFor( "think_interval" )
	self.delay = self:GetAbility():GetSpecialValueFor( "activation_delay" )
	self.speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )

	self.width = self:GetAbility():GetSpecialValueFor( "remnant_watch_radius" )
	self.distance = self:GetAbility():GetSpecialValueFor( "remnant_watch_distance" )


	if self:GetCaster():HasShard() then 
		self.speed = self.speed + self:GetAbility():GetSpecialValueFor("shard_speed")
		self.distance = self.distance + self:GetAbility():GetSpecialValueFor("shard_range")
	end	

	if self:GetCaster():HasModifier("modifier_void_remnant_5") then 
		self.delay = 0
	end


	self.watch_vision = self:GetAbility():GetSpecialValueFor( "watch_path_vision_radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )



	self.damage = self:GetAbility():GetSpecialValueFor( "impact_damage" )
	self.pull_duration = self:GetAbility():GetSpecialValueFor( "pull_duration" ) + self:GetCaster():GetTalentValue("modifier_void_remnant_5", "stun")
	self.pull = self:GetAbility():GetSpecialValueFor( "pull_destination" )


	if not IsServer() then return end

	self.creeps_interval = self:GetAbility():GetSpecialValueFor("creeps_interval")
	self.creeps_damage = self:GetAbility():GetSpecialValueFor("creeps_damage")/100
	self.creeps_count = self.creeps_interval


	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	self.origin = self:GetParent():GetAbsOrigin()

	self.direction = Vector( kv.dir_x, kv.dir_y, kv.dir_z )

	self.target = GetGroundPosition( self.origin + self.direction * self.distance, nil )

	local run_dist = (self.origin-self:GetCaster():GetOrigin()):Length2D()
	local run_delay = run_dist/self.speed

	self.state = STATE_RUN

	self:StartIntervalThink( run_delay )
	self:PlayEffects1()
end

function modifier_custom_void_remnant_thinker:OnRefresh( kv )
	if not IsServer() then return end
	self.state = kv.state
end

function modifier_custom_void_remnant_thinker:OnRemoved()
end

function modifier_custom_void_remnant_thinker:OnDestroy()
	if not IsServer() then return end
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Spawn_lp"
	self:GetParent():StopSound( sound_cast )
	self:PlayEffects5()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_custom_void_remnant_thinker:OnIntervalThink()
	if self.state == STATE_RUN then
		-- change state
		self.state = STATE_DELAY
		self:StartIntervalThink( self.delay )

		-- play delay effects
		self:PlayEffects2()
		return
	elseif self.state == STATE_DELAY then
		-- change state
		self.state = STATE_WATCH
		self:StartIntervalThink( self.interval )

		-- start remnant duration
		self:SetDuration( self.duration, false )

		-- play remnant effects
		self:PlayEffects3()
		return
	elseif self.state == STATE_WATCH then
		self:WatchLogic()
	else -- self.state == STATE_PULL
		-- stop looping
		self:StartIntervalThink( -1 )
		

	end
end

function modifier_custom_void_remnant_thinker:WatchLogic()

AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin, self.watch_vision, 0.1, true)
AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin + self.direction*self.distance/2, self.watch_vision, 0.1, true)
AddFOWViewer( self:GetParent():GetTeamNumber(), self.target, self.watch_vision, 0.1, true)


self.creeps_count = self.creeps_count + self.interval

local origin = self.origin + 150*self.direction

local enemies_heroes = FindUnitsInLine( self:GetCaster():GetTeamNumber(), origin, self.target, nil,	 self.width, self.abilityTargetTeam, DOTA_UNIT_TARGET_HERO, self.abilityTargetFlags)

if self.creeps_count >= self.creeps_interval then 

	self.creeps_count = 0

	local enemies_creeps = FindUnitsInLine( self:GetCaster():GetTeamNumber(), origin, self.target, nil,	 self.width, self.abilityTargetTeam, DOTA_UNIT_TARGET_BASIC, self.abilityTargetFlags)

	for _,creep in pairs(enemies_creeps) do 

		local damageTable = {
			victim = creep,
			attacker = self:GetCaster(),
			damage = self.damage*self.creeps_damage*self.creeps_interval,
			damage_type = self.abilityDamageType,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)
	end
end


if #enemies_heroes==0 then return end

local min = 999

local min_i = 0

for i,enemy in pairs(enemies_heroes) do 
	if enemy:HasModifier("modifier_custom_void_remnant_target") then 
		table.remove(enemies_heroes,i)
	end
end

if #enemies_heroes==0 then return end

for i = 1,#enemies_heroes do
	if (enemies_heroes[i]:GetAbsOrigin() - origin):Length2D() <= min then 
		min = (enemies_heroes[i]:GetAbsOrigin() - origin):Length2D()
		min_i = i
	end
end


if min_i == 0 then return end

local enemy = enemies_heroes[min_i]


local agi = 0
local str = 0
local int = 0

if self:GetCaster():HasModifier("modifier_void_remnant_6") then 

	
	local k = self:GetCaster():GetTalentValue("modifier_void_remnant_6", "stats")/100

	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf"
	local duration = self:GetCaster():GetTalentValue("modifier_void_remnant_6", "duration")

	if enemy:IsHero() then 

		str = enemy:GetStrength()*k
		agi = enemy:GetAgility()*k
		int = enemy:GetIntellect()*k

		if enemy:GetPrimaryAttribute() == 1 then  
		particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_agi.vpcf"
		end

		if enemy:GetPrimaryAttribute() == 0 then  
		particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_str.vpcf"
		end

		if enemy:GetPrimaryAttribute() == 2 then  
		particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf"
		end
	end

	local targets = {}
	targets[1] = self:GetCaster()

	if self:GetCaster().tempest_double_tempest and not self:GetCaster().tempest_double_tempest:IsNull() and self:GetCaster().tempest_double_tempest:IsAlive() then 
		targets[2] = self:GetCaster().tempest_double_tempest
	end 

	for _,target in pairs(targets) do

	  target:RemoveModifierByName("modifier_custom_void_remnant_stats")

		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt( effect_cast, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(),  true )
		ParticleManager:SetParticleControlEnt( effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true  )
		ParticleManager:ReleaseParticleIndex( effect_cast )

		target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_stats", {agi = agi, str = str, int = int, duration = duration})

	end 


	enemy:RemoveModifierByName("modifier_custom_void_remnant_stats")
	if enemy:IsHero() then 
		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_stats", {agi = -agi, str = -str, int = -int, duration = duration})
	end
end


local damageTable = {
	victim = enemy,
	attacker = self:GetCaster(),
	damage = self.damage,
	damage_type = self.abilityDamageType,
	ability = self:GetAbility(), --Optional.
}
ApplyDamage(damageTable)

local stun_duration = self.pull_duration*(1 - enemy:GetStatusResistance())

enemy:AddNewModifier(
	self:GetCaster(), -- player source
	self:GetAbility(), -- ability source
	"modifier_custom_void_remnant_target", -- modifier name
	{
		duration = stun_duration,
		pos_x = self.origin.x,
		pos_y = self.origin.y,
		pull = self.pull,
		durat = self.pull_duration
	} -- kv
)



if self:GetCaster():HasModifier("modifier_void_step_4")  and not enemy:HasModifier("modifier_void_spirit_astral_step_spells_max") then 
	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_void_spirit_astral_step_spells", {duration = self:GetCaster():GetTalentValue("modifier_void_step_4", "duration")})
end


self.state = STATE_PULL
self:SetDuration( self.pull_duration*(1 - enemy:GetStatusResistance()), false )

local direction = enemy:GetOrigin()-self.origin
local dist = direction:Length2D()
direction.z = 0
direction = direction:Normalized()
AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin, self.watch_vision, self.pull_duration, true)
AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin + direction*dist/2, self.watch_vision, self.pull_duration, true)
AddFOWViewer( self:GetParent():GetTeamNumber(), enemy:GetOrigin(), self.watch_vision, self.pull_duration, true)

self:PlayEffects4( enemy )


end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_custom_void_remnant_thinker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf"
	local sound_cast = "Hero_VoidSpirit.AetherRemnant"

	-- get data
	local direction = self.origin-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )

	ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin() , true)


	ParticleManager:SetParticleControl( effect_cast, 1, direction * self.speed )
	ParticleManager:SetParticleControlForward( effect_cast, 0, -direction )

	-- store for later use
	self.effect_cast = effect_cast

	-- Create Sound
	self:GetParent():EmitSound(sound_cast)
end

function modifier_custom_void_remnant_thinker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pre.vpcf"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
		ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- store for later use
	self.effect_cast = effect_cast
end

function modifier_custom_void_remnant_thinker:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_watch.vpcf"
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Spawn_lp"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self.origin )
	ParticleManager:SetParticleControl( effect_cast, 1, self.target )
	ParticleManager:SetParticleControlEnt(effect_cast, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControlForward( effect_cast, 2, self.direction )

	-- store for later use
	self.effect_cast = effect_cast

	-- Create Sound
	 self:GetParent():EmitSound(sound_cast)
end


function modifier_custom_void_remnant_thinker:PlayEffects4( target )
	-- Get Resources
	local sound_cast = "Hero_VoidSpirit.AetherRemnant.Triggered"
	local sound_target = "Hero_VoidSpirit.AetherRemnant.Target"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- get data
	local direction = target:GetOrigin()-self.origin
	direction.z = 0
	direction = -direction:Normalized()

	-- Create Particle

	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )

	ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)

	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 150) )
	ParticleManager:SetParticleControlForward( effect_cast, 2, direction )
	ParticleManager:SetParticleControl( effect_cast, 3, self.origin )
	-- store for later use
	self.effect_cast = effect_cast

	-- Create Sound
	self:GetParent():EmitSound(sound_cast)
	 target:EmitSound(sound_target)
end

function modifier_custom_void_remnant_thinker:PlayEffects5()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_flash.vpcf"
	local sound_target = "Hero_VoidSpirit.AetherRemnant.Destroy"

	-- Destroy previous effect
	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 3, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	self:GetParent():EmitSound(sound_target)
end






modifier_custom_void_remnant_target = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_custom_void_remnant_target:IsHidden()
	return false
end

function modifier_custom_void_remnant_target:IsDebuff()
	return true
end

function modifier_custom_void_remnant_target:IsStunDebuff()
	return true
end

function modifier_custom_void_remnant_target:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_custom_void_remnant_target:OnCreated( kv )
	if not IsServer() then return end
	self.target = Vector( kv.pos_x, kv.pos_y, 0 )

	-- get speed
	local dist = (self:GetParent():GetOrigin()-self.target):Length2D()
	self.speed = kv.pull/100*dist/kv.durat

	self:GetParent():MoveToPosition( self.target )


	if self:GetCaster():HasModifier("modifier_void_remnant_4") then 
		local attacks = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "count")

		local interval = self:GetRemainingTime() / attacks - FrameTime()*2

		self:StartIntervalThink(interval)

	end
end


function modifier_custom_void_remnant_target:OnIntervalThink()
if not IsServer() then return end

self:GetAbility():ProcDamage(self:GetParent())
end


function modifier_custom_void_remnant_target:OnRefresh( kv )
	self:OnCreated( kv )
end




function modifier_custom_void_remnant_target:OnDestroy()
if not IsServer() then return end
self:GetParent():Stop()

if self:GetCaster():HasModifier("modifier_void_remnant_5") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_slow", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_5", "duration")*(1 - self:GetParent():GetStatusResistance())})
end


end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_custom_void_remnant_target:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function modifier_custom_void_remnant_target:GetModifierMoveSpeed_Absolute()
	if IsServer() then return self.speed end
end




	





--------------------------------------------------------------------------------



function modifier_custom_void_remnant_target:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_TAUNTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_DISARMED] = true
	}

	if not self:GetParent():IsHero() then 
		state = {
			[MODIFIER_STATE_STUNNED] = true
		}
	end

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_custom_void_remnant_target:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_aether_remnant.vpcf"
end

function modifier_custom_void_remnant_target:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

modifier_custom_void_remnant_tracker = class({})
function modifier_custom_void_remnant_tracker:IsHidden() return true end
function modifier_custom_void_remnant_tracker:IsPurgable() return false end
function modifier_custom_void_remnant_tracker:RemoveOnDeath() return false end
function modifier_custom_void_remnant_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end




function modifier_custom_void_remnant_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_void_remnant_2") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end

if self:GetCaster().tempest_double_tempest and not self:GetCaster().tempest_double_tempest:IsNull() and self:GetCaster().tempest_double_tempest:IsAlive() then 
	self:GetParent().tempest_double_tempest:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_void_remnant_armor", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_2", "duration")})

end 

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_void_remnant_armor", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_2", "duration")})
end 





function modifier_custom_void_remnant_tracker:OnAttackLanded(params)
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end
if self:GetParent():IsIllusion() then return end

if self:GetParent():HasModifier("modifier_void_remnant_3") then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_void_remnant_resist", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_3", "duration")})
end 


if not self:GetParent():HasModifier("modifier_void_remnant_4") then return end

local chance = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "chance")


local random = RollPseudoRandomPercentage(chance,63,self:GetCaster())

if not random then return end

self:GetAbility():ProcDamage(params.target)

end









modifier_custom_void_remnant_slow = class({})
function modifier_custom_void_remnant_slow:IsHidden() return false end
function modifier_custom_void_remnant_slow:IsPurgable() return true end
function modifier_custom_void_remnant_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end
function modifier_custom_void_remnant_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_custom_void_remnant_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move
end 

function modifier_custom_void_remnant_slow:GetModifierAttackSpeedBonus_Constant()
return self.speed
end 


function modifier_custom_void_remnant_slow:OnCreated()

self.move = self:GetCaster():GetTalentValue("modifier_void_remnant_5", "move")
self.speed = self:GetCaster():GetTalentValue("modifier_void_remnant_5", "speed")
end



modifier_custom_void_remnant_stats = class({})

function modifier_custom_void_remnant_stats:IsHidden() return false end
function modifier_custom_void_remnant_stats:IsPurgable() return false end
function modifier_custom_void_remnant_stats:GetTexture()
	return "buffs/remnant_stats" 
end

function modifier_custom_void_remnant_stats:OnCreated(table)

self.amp = self:GetCaster():GetTalentValue("modifier_void_remnant_6", "amp")
if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
	self.amp = self.amp*-1
end 

if not IsServer() then return end

self:SetHasCustomTransmitterData(true)
self.agi = table.agi
self.str = table.str
self.int = table.int 

self:GetParent():CalculateStatBonus(true)
end

function modifier_custom_void_remnant_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,  
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end
function modifier_custom_void_remnant_stats:AddCustomTransmitterData() return {
agi = self.agi,
int = self.int,
str = self.str,

} end

function modifier_custom_void_remnant_stats:HandleCustomTransmitterData(data)
self.agi = data.agi
self.int = data.int
self.str = data.str
end


function modifier_custom_void_remnant_stats:GetModifierSpellAmplify_Percentage() 
	return self.amp
end

function modifier_custom_void_remnant_stats:GetModifierBonusStats_Agility() 
return self.agi 
end
function modifier_custom_void_remnant_stats:GetModifierBonusStats_Strength() 
return self.str
end
function modifier_custom_void_remnant_stats:GetModifierBonusStats_Intellect()
return self.int
end









void_spirit_aether_remnant_custom_legendary = class({})


function void_spirit_aether_remnant_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_void_remnant_legendary", "cd")
end


function void_spirit_aether_remnant_custom_legendary:GetCastRange()

if IsClient() then 
	return self:GetSpecialValueFor("range")
else 
	return 99999
end

end


function void_spirit_aether_remnant_custom_legendary:OnAbilityPhaseStart()

self.effect_cast = ParticleManager:CreateParticle( "particles/items2_fx/manta_phase.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

return true
end


function void_spirit_aether_remnant_custom_legendary:OnAbilityPhaseInterrupted()


if self.effect_cast then 
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end

end

function void_spirit_aether_remnant_custom_legendary:OnSpellStart()


if self.effect_cast then 
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end

local caster = self:GetCaster()
local ability = self

local point = self:GetCursorPosition()
local max_dist = self:GetSpecialValueFor("range") + self:GetCaster():GetCastRangeBonus()
local vec = (point - self:GetCaster():GetAbsOrigin())

if vec:Length2D() > max_dist then 
	point = self:GetCaster():GetAbsOrigin() + vec:Normalized()*max_dist
end 

if not caster or caster:IsNull() then return end

if caster:IsTempestDouble() then return end

local tempest = ability:GetHerotempest()

if not tempest or tempest:IsNull() then return end

tempest:RespawnHero(false, false)

self:ModifyTempest(tempest)

tempest:SetHealth(caster:GetHealth())
tempest:SetMana(caster:GetMana())
tempest:SetBaseAgility(caster:GetBaseAgility())
tempest:SetBaseStrength(caster:GetBaseStrength())
tempest:SetBaseIntellect(caster:GetBaseIntellect())
tempest:Purge(true, true, false, true, true)
tempest:SetAbilityPoints(0)
tempest:SetHasInventory(false)
tempest:SetCanSellItems(false)
tempest.owner = caster
tempest:RemoveModifierByName("modifier_fountain_invulnerability")


Timers:CreateTimer(FrameTime(), function()
    tempest:RemoveModifierByName("modifier_fountain_invulnerability")
end)

local duration = self:GetCaster():GetTalentValue("modifier_void_remnant_legendary", "duration")

caster.tempest_double_tempest = tempest

tempest:RemoveGesture(ACT_DOTA_DIE)


FindClearSpaceForUnit(tempest, point, true)


tempest:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
tempest:AddNewModifier(caster, self, "modifier_custom_void_remnant_legendary", {})

local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"

tempest:SetForwardVector(self:GetCaster():GetForwardVector())
tempest:FaceTowards(tempest:GetAbsOrigin() + self:GetCaster():GetForwardVector()*10)

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, tempest )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, tempest:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )
tempest:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)

tempest:EmitSound("VoidSpirit.Remnant_legendary")
tempest:EmitSound("Hero_VoidSpirit.AstralStep.End")
self:GetCaster():EmitSound("VoidSpirit.Remnant_legendary_vo")
self:GetCaster():EmitSound("Hero_VoidSpirit.AstralStep.Start")
--self:GetCaster():EmitSound("VoidSpirit.Remnant_legendary_cast")


local effect_cast2 = ParticleManager:CreateParticle( "particles/void_buf2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast2, 0, self:GetCaster():GetOrigin() )

local effect_cast2 = ParticleManager:CreateParticle( "particles/void_buf2.vpcf", PATTACH_ABSORIGIN_FOLLOW, tempest )
ParticleManager:SetParticleControl( effect_cast2, 0, tempest:GetOrigin() )


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_void_remnant_legendary_caster", {target = tempest:entindex()})
end






function void_spirit_aether_remnant_custom_legendary:GetHerotempest()
local caster = self:GetCaster()
if not caster or caster:IsNull() then return end

if not self.tempest then
	if caster.tempest_double_tempest then
		self.tempest = caster.tempest_double_tempest
	else
		local tempest = CreateUnitByName( caster:GetUnitName(), caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber()  )

		tempest.owner = caster
		tempest:SetUnitCanRespawn(true)
		tempest:SetRespawnsDisabled(true)
    tempest:RemoveModifierByName("modifier_fountain_invulnerability")
		tempest.IsRealHero = function() return true end
		tempest.IsMainHero = function() return false end
		tempest.IsTempestDouble = function() return true end
		tempest:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
		--tempest:SetRenderColor(0, 0, 190)
		self.tempest = tempest
	end
end



return self.tempest
end




function void_spirit_aether_remnant_custom_legendary:ManageItems(tempest)
if not IsServer() then return end 
if not tempest or tempest:IsNull() then return end

local caster = self:GetCaster()
if not caster or caster:IsNull() then return end


for i = 0 , 16 do
	local tempest_item = tempest:GetItemInSlot(i)
	if tempest_item then
		UTIL_Remove(tempest_item)
	end
end

-- Выдача предметов
for itemSlot = 0,16 do
  local itemName = caster:GetItemInSlot(itemSlot)

  if itemName then 
    if itemName:GetName() ~= "item_rapier" and itemName:GetName() ~= "item_gem" and itemName:IsPermanent() then


			local newItem = CreateItem(itemName:GetName(), nil, nil)
			tempest:AddItem(newItem)


			if itemName and itemName:GetCurrentCharges() > 0 and newItem and not newItem:IsNull() then
			  newItem:SetCurrentCharges(itemName:GetCurrentCharges())
			end
			if newItem and not newItem:IsNull() then
			  tempest:SwapItems(newItem:GetItemSlot(), itemSlot)
			end


			newItem:SetSellable(false)
			newItem:SetDroppable(false)
			newItem:SetShareability( ITEM_FULLY_SHAREABLE )
			newItem:SetPurchaser( nil )
    end
  end
end

end 



function void_spirit_aether_remnant_custom_legendary:ManageBuffs(tempest) 
if not IsServer() then return end 
if not tempest or tempest:IsNull() then return end

local caster = self:GetCaster()
if not caster or caster:IsNull() then return end




while tempest:GetLevel() < caster:GetLevel() do
	tempest:HeroLevelUp( false )
end


tempest:SetAbilityPoints(0)

for _,modifier in pairs(caster:FindAllModifiers()) do 

    if (modifier.StackOnIllusion ~= nil and modifier.StackOnIllusion == true) or modifier:GetName() == "modifier_item_ultimate_scepter_consumed"
    or modifier:GetName() == "modifier_item_aghanims_shard" or modifier:GetName() == "modifier_item_moon_shard_consumed" then 

    	local mod = tempest:FindModifierByName(modifier:GetName())

    	local ability = modifier:GetAbility()
    	local cast_ability = nil

    	if ability and tempest:HasAbility(ability:GetName()) then 
    		cast_ability = tempest:FindAbilityByName(ability:GetName())
    	end

    	if not mod then 
        mod = tempest:AddNewModifier(tempest, cast_ability, modifier:GetName(), {})
    	end

    	if mod then 
    		mod:SetStackCount(modifier:GetStackCount())
    	end 
    end 

end

for i = 0, 24 do
	local ability = caster:GetAbilityByIndex(i)
		if ability then
		  local tempest_ability = tempest:FindAbilityByName(ability:GetAbilityName())
		  if tempest_ability then
	      tempest_ability:SetLevel(ability:GetLevel())
	      tempest_ability:SetActivated(ability:GetAbilityName() == "void_spirit_astral_step_custom")
		  end
		end
end

tempest:CalculateStatBonus(true)


end 


function void_spirit_aether_remnant_custom_legendary:ModifyTempest(tempest)
if not IsServer() then return end 
local caster = self:GetCaster()
if not caster or caster:IsNull() then return end


self:ManageItems(tempest)

self:ManageBuffs(tempest)



end 





modifier_custom_void_remnant_legendary = class({})
function modifier_custom_void_remnant_legendary:IsHidden() return true end
function modifier_custom_void_remnant_legendary:IsPurgable() return false end
function modifier_custom_void_remnant_legendary:RemoveOnDeath() return false end
function modifier_custom_void_remnant_legendary:GetEffectName() return "particles/void_spirit/remnant_legendary.vpcf" end
function modifier_custom_void_remnant_legendary:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end





function modifier_custom_void_remnant_legendary:OnCreated()
local caster = self:GetCaster()
local ability = self:GetAbility()
if not ability or ability:IsNull() then return end

self.status = self:GetCaster():GetTalentValue("modifier_void_remnant_legendary", "status")
self.move = self:GetCaster():GetTalentValue("modifier_void_remnant_legendary", "move")
self.damage = self:GetCaster():GetTalentValue("modifier_void_remnant_legendary", "damage") - 100

self.far_distance = ability:GetSpecialValueFor("far_distance")

if not IsServer() then return end

self.dead = false


self.parent = self:GetParent()
self.caster = caster
self.ability = ability


self:StartIntervalThink(FrameTime())
end

function modifier_custom_void_remnant_legendary:OnIntervalThink()
if not IsServer() then return end


if self:GetParent():IsAlive() and self.dead == true then 
	self.dead = false
	self:GetParent():RemoveNoDraw()
end 

if not self:GetParent():IsAlive() and self.dead == false then 
	self.dead = true
	self:GetParent():AddNoDraw()

	self:GetParent():EmitSound("VoidSpirit.Remnant_legendary_death")

	local point = self:GetParent():GetAbsOrigin()


	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_puff.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast, 0, point)
	ParticleManager:DestroyParticle(effect_cast, false)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	point.z = point.z + 150


	local effect_cast2 = ParticleManager:CreateParticle( "particles/void_spirit/legendary_remnant_end.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect_cast2, 0, point)
	ParticleManager:DestroyParticle(effect_cast2, false)
	ParticleManager:ReleaseParticleIndex(effect_cast2)


end 


if not self:GetParent():IsAlive() then return end

local length = (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()
if length > self.far_distance and self.caster:IsAlive() then
    self.parent:AddNewModifier(self.caster, self.ability, "modifier_custom_void_remnant_legendary_far", {})
else
   self.parent:RemoveModifierByName("modifier_custom_void_remnant_legendary_far")
end

end


function modifier_custom_void_remnant_legendary:DeclareFunctions()
return 
{
		MODIFIER_PROPERTY_TEMPEST_DOUBLE,
  	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
}
end

function modifier_custom_void_remnant_legendary:GetModifierDamageOutgoing_Percentage()
return self.damage
end

function modifier_custom_void_remnant_legendary:GetModifierStatusResistanceStacking() 
return self.status
end

function modifier_custom_void_remnant_legendary:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_custom_void_remnant_legendary:GetModifierTempestDouble(params)
	return 1
end


function modifier_custom_void_remnant_legendary:OnDeath(params)
if not IsServer() then return end 

if params.unit == self:GetCaster() then 
	self:GetParent():Kill(nil, params.attacker)
end 

end 


function modifier_custom_void_remnant_legendary:GetStatusEffectName() return "particles/void_step_texture.vpcf" end


function modifier_custom_void_remnant_legendary:StatusEffectPriority()
    return 99999
end


function modifier_custom_void_remnant_legendary:CheckState()
return
{
	[MODIFIER_STATE_MUTED] = true
}
end



modifier_custom_void_remnant_legendary_caster = class({})
function modifier_custom_void_remnant_legendary_caster:IsHidden() return false end
function modifier_custom_void_remnant_legendary_caster:IsPurgable() return false end
function modifier_custom_void_remnant_legendary_caster:RemoveOnDeath() return false end
function modifier_custom_void_remnant_legendary_caster:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_void_remnant_legendary", "damage") - 100

if not IsServer() then return end 

self:GetAbility():SetActivated(false)
self:GetAbility():EndCooldown()

self.target = EntIndexToHScript(table.target)


self:StartIntervalThink(0.2)
end

function modifier_custom_void_remnant_legendary_caster:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_custom_void_remnant_legendary_caster:GetModifierDamageOutgoing_Percentage()
return self.damage
end


function modifier_custom_void_remnant_legendary_caster:OnDestroy()
if not IsServer() then return end 

self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)
end 


function modifier_custom_void_remnant_legendary_caster:OnIntervalThink()
if not IsServer() then return end 


if not self.target or self.target:IsNull() or not self.target:IsAlive() then 
	self:Destroy()
end


end 


modifier_custom_void_remnant_legendary_far = class({})
function modifier_custom_void_remnant_legendary_far:IsPurgable() return false end
function modifier_custom_void_remnant_legendary_far:IsHidden() return true end
function modifier_custom_void_remnant_legendary_far:IsPurgeException() return false end

function modifier_custom_void_remnant_legendary_far:CheckState()
if self:GetParent():HasModifier("modifier_arc_warden_tempest_double_custom_legendary") then return end
return
{
	[MODIFIER_STATE_DISARMED] = true,
}
end

function modifier_custom_void_remnant_legendary_far:GetEffectName() 
	return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd.vpcf"
end
function modifier_custom_void_remnant_legendary_far:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end




modifier_custom_void_remnant_resist = class({})
function modifier_custom_void_remnant_resist:IsHidden() return false end
function modifier_custom_void_remnant_resist:IsPurgable() return false end
function modifier_custom_void_remnant_resist:GetTexture() return "buffs/remnant_lowhp" end
function modifier_custom_void_remnant_resist:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_void_remnant_3", "max")
self.magic = self:GetCaster():GetTalentValue("modifier_void_remnant_3", "magic")
if not IsServer() then return end 

self:SetStackCount(1)

end 

function modifier_custom_void_remnant_resist:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 


self:IncrementStackCount()
end 

function modifier_custom_void_remnant_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_custom_void_remnant_resist:GetModifierMagicalResistanceBonus()
return self:GetStackCount()*self.magic
end






modifier_custom_void_remnant_armor = class({})
function modifier_custom_void_remnant_armor:IsHidden() return false end
function modifier_custom_void_remnant_armor:IsPurgable() return false end
function modifier_custom_void_remnant_armor:GetTexture() return "buffs/manavoid_int" end

function modifier_custom_void_remnant_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_custom_void_remnant_armor:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_void_remnant_2", "max")
self.speed = self:GetCaster():GetTalentValue("modifier_void_remnant_2", "speed")
self.armor = self:GetCaster():GetTalentValue("modifier_void_remnant_2", "armor")

if not IsServer() then return end 

self:SetStackCount(1)
end


function modifier_custom_void_remnant_armor:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end 

function modifier_custom_void_remnant_armor:GetModifierPhysicalArmorBonus()
return self.armor*self:GetStackCount()
end


function modifier_custom_void_remnant_armor:GetModifierAttackSpeedBonus_Constant()
return self.speed*self:GetStackCount()
end


