LinkLuaModifier("modifier_custom_void_remnant_thinker", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_target", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_tracker", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_slow", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_legendary_caster", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_speed", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_move", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_legendary_illusion", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_heal_reduce", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_void_remnant_lifesteal", "abilities/void_spirit/void_spirit_aether_remnant_custom", LUA_MODIFIER_MOTION_NONE)



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




function void_spirit_aether_remnant_custom:GetManaCost(level)

if self:GetCaster():HasModifier("modifier_void_remnant_6") then 
	return 0
end 
return self.BaseClass.GetManaCost(self,level)
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

if self:GetCaster():HasModifier("modifier_void_remnant_2") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_void_remnant_move", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_2", "duration")})
end 

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
	self.delay = 0
end	

self.watch_vision = self:GetAbility():GetSpecialValueFor( "watch_path_vision_radius" )
self.duration = self:GetAbility():GetSpecialValueFor( "duration" )



self.pull_duration = self:GetAbility():GetSpecialValueFor( "pull_duration" ) + self:GetCaster():GetTalentValue("modifier_void_remnant_1", "stun")
self.pull = self:GetAbility():GetSpecialValueFor( "pull_destination" )


if not IsServer() then return end
self.damage = self:GetAbility():GetSpecialValueFor( "impact_damage" ) + self:GetCaster():GetTalentValue("modifier_void_remnant_1", "damage")*self:GetCaster():GetAverageTrueAttackDamage(nil)/100

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

		local damageTable = {victim = creep, attacker = self:GetCaster(), damage = self.damage*self.creeps_damage*self.creeps_interval, damage_type = self.abilityDamageType, ability = self:GetAbility(), }
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

local stun_duration = self.pull_duration*(1 - enemy:GetStatusResistance())

enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_target", {duration = stun_duration, pos_x = self.origin.x, pos_y = self.origin.y, pull = self.pull, durat = self.pull_duration })

if self:GetCaster():HasModifier("modifier_void_step_4")  and not enemy:HasModifier("modifier_void_spirit_astral_step_spells_max") then 
	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_void_spirit_astral_step_spells", {duration = self:GetCaster():GetTalentValue("modifier_void_step_4", "duration")})
end

if self:GetCaster():HasModifier("modifier_void_remnant_6") then 
	local health = enemy:GetHealth()*self:GetCaster():GetTalentValue("modifier_void_remnant_6", "health")/100
	enemy:SetHealth(math.max(1, enemy:GetHealth() - health))

	self:GetCaster():GenericHeal(health, self:GetAbility())

	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_lifesteal", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_6", "duration")})
end 


local clone = nil

if self:GetCaster():HasModifier("modifier_void_remnant_legendary") then
	local duration = self:GetCaster():GetTalentValue("modifier_void_remnant_legendary", "duration", true)
	local incoming = self:GetCaster():GetTalentValue("modifier_void_remnant_legendary", "incoming", true) - 100

	local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=duration, outgoing_damage=-100,incoming_damage=incoming}, 1, 0, false, true)  

	for k, illusion in pairs(illusion) do
		clone = illusion

		for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
		    if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
		        illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
		    end
		end

		illusion:SetOwner(nil)
		illusion.owner = self:GetCaster()
		FindClearSpaceForUnit(illusion, self.origin, true)
    	illusion:AddNewModifier(illusion, nil, "modifier_chaos_knight_phantasm_illusion", {})
		illusion:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_legendary_illusion", {})

		Timers:CreateTimer(0.1, function()
		   	illusion:SetForceAttackTarget(enemy)
		end)
	end
end


local damageTable = {victim = enemy, attacker = self:GetCaster(), damage = self.damage, damage_type = self.abilityDamageType, ability = self:GetAbility(),}
ApplyDamage(damageTable)

self.state = STATE_PULL
self:SetDuration( self.pull_duration*(1 - enemy:GetStatusResistance()), false )

local direction = enemy:GetOrigin()-self.origin
local dist = direction:Length2D()
direction.z = 0
direction = direction:Normalized()
AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin, self.watch_vision, self.pull_duration, true)
AddFOWViewer( self:GetParent():GetTeamNumber(), self.origin + direction*dist/2, self.watch_vision, self.pull_duration, true)
AddFOWViewer( self:GetParent():GetTeamNumber(), enemy:GetOrigin(), self.watch_vision, self.pull_duration, true)

self:PlayEffects4( enemy, clone )
end



function modifier_custom_void_remnant_thinker:PlayEffects1()

local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf"
local sound_cast = "Hero_VoidSpirit.AetherRemnant"

local direction = self.origin-self:GetCaster():GetOrigin()
direction.z = 0
direction = direction:Normalized()

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin() , true)
ParticleManager:SetParticleControl( effect_cast, 1, direction * self.speed )
ParticleManager:SetParticleControlForward( effect_cast, 0, -direction )

self.effect_cast = effect_cast

self:GetParent():EmitSound(sound_cast)
end



function modifier_custom_void_remnant_thinker:PlayEffects2()

local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pre.vpcf"

ParticleManager:DestroyParticle( self.effect_cast, false )
ParticleManager:ReleaseParticleIndex( self.effect_cast )

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self.origin )
ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )

self.effect_cast = effect_cast
end


function modifier_custom_void_remnant_thinker:PlayEffects3()

local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_watch.vpcf"
local sound_cast = "Hero_VoidSpirit.AetherRemnant.Spawn_lp"

ParticleManager:DestroyParticle( self.effect_cast, false )
ParticleManager:ReleaseParticleIndex( self.effect_cast )

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self.origin )
ParticleManager:SetParticleControl( effect_cast, 1, self.target )
ParticleManager:SetParticleControlEnt(effect_cast, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
ParticleManager:SetParticleControlForward( effect_cast, 2, self.direction )

self.effect_cast = effect_cast

self:GetParent():EmitSound(sound_cast)
end



function modifier_custom_void_remnant_thinker:PlayEffects4( target, illusion )

local sound_cast = "Hero_VoidSpirit.AetherRemnant.Triggered"
local sound_target = "Hero_VoidSpirit.AetherRemnant.Target"

ParticleManager:DestroyParticle( self.effect_cast, false )
ParticleManager:ReleaseParticleIndex( self.effect_cast )


local direction = target:GetOrigin()-self.origin
direction.z = 0
direction = -direction:Normalized()

local effect_cast 

if illusion then 

	effect_cast = ParticleManager:CreateParticle("particles/void_spirit/pull_legendary.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 150) )
	ParticleManager:SetParticleControlForward( effect_cast, 2, direction )
	ParticleManager:SetParticleControlEnt(effect_cast, 3, illusion, PATTACH_POINT_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true )
else 

	effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl(effect_cast, 2, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 150) )
	ParticleManager:SetParticleControlForward( effect_cast, 2, direction )
	ParticleManager:SetParticleControl(effect_cast, 3, self.origin )
end 

self.effect_cast = effect_cast

self:GetParent():EmitSound(sound_cast)
target:EmitSound(sound_target)
end




function modifier_custom_void_remnant_thinker:PlayEffects5()

local particle_cast = "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_flash.vpcf"
local sound_target = "Hero_VoidSpirit.AetherRemnant.Destroy"

ParticleManager:DestroyParticle( self.effect_cast, false )
ParticleManager:ReleaseParticleIndex( self.effect_cast )

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 3, self:GetParent():GetOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound(sound_target)
end






modifier_custom_void_remnant_target = class({})


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

function modifier_custom_void_remnant_target:OnCreated( kv )
if not IsServer() then return end
self.target = Vector( kv.pos_x, kv.pos_y, 0 )

local dist = (self:GetParent():GetOrigin()-self.target):Length2D()
self.speed = kv.pull/100*dist/kv.durat

if not self:GetParent():IsDebuffImmune() then 
	self:GetParent():MoveToPosition( self.target )
end 

if self:GetCaster():HasModifier("modifier_void_remnant_3") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_heal_reduce", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_3", "duration")})
end 

end


function modifier_custom_void_remnant_target:OnRefresh( kv )
self:OnCreated( kv )
end


function modifier_custom_void_remnant_target:OnDestroy()
if not IsServer() then return end

if not self:GetParent():IsDebuffImmune() then 
	self:GetParent():Stop()
end 


if self:GetCaster():HasModifier("modifier_void_remnant_5") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_slow", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_5", "duration")*(1 - self:GetParent():GetStatusResistance())})
end

end



function modifier_custom_void_remnant_target:DeclareFunctions()
local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
}

return funcs
end

function modifier_custom_void_remnant_target:GetModifierMoveSpeed_Absolute()
if IsServer() then 
	return self.speed 
end

end

function modifier_custom_void_remnant_target:CheckState()
local state = 
{
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_TAUNTED] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_DISARMED] = true
}
return state
end


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
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end

function modifier_custom_void_remnant_tracker:GetModifierAttackSpeedBonus_Constant()
if not self:GetCaster():HasModifier("modifier_void_remnant_2") then return end 
local k = 1
if self:GetCaster():HasModifier("modifier_custom_void_remnant_move") then 
	k = self.move_bonus
end 
return self:GetCaster():GetTalentValue("modifier_void_remnant_2", "speed")*k
end

function modifier_custom_void_remnant_tracker:GetModifierMoveSpeedBonus_Constant()
if not self:GetCaster():HasModifier("modifier_void_remnant_2") then return end 
local k = 1
if self:GetCaster():HasModifier("modifier_custom_void_remnant_move") then 
	k = self.move_bonus
end 
return self:GetCaster():GetTalentValue("modifier_void_remnant_2", "move")*k
end




function modifier_custom_void_remnant_tracker:OnCreated()
self.move_bonus = self:GetCaster():GetTalentValue("modifier_void_remnant_2", "bonus", true)

self.speed_duration = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "duration", true)
end


function modifier_custom_void_remnant_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_void_remnant_4") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end

if self:GetCaster().void_clone and not self:GetCaster().void_clone:IsNull() and self:GetCaster().void_clone:IsAlive() then 
	self:GetParent().void_clone:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_void_remnant_speed", {duration = self.speed_duration})
end 

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_void_remnant_speed", {duration = self.speed_duration})
end 











modifier_custom_void_remnant_slow = class({})
function modifier_custom_void_remnant_slow:IsHidden() return true end
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

function modifier_custom_void_remnant_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_void_spirit_aether_remnant.vpcf"
end

function modifier_custom_void_remnant_slow:StatusEffectPriority()
return 999999
end



function modifier_custom_void_remnant_slow:CheckState()
return
{
	[MODIFIER_STATE_TETHERED] = true
}
end













modifier_custom_void_remnant_speed = class({})
function modifier_custom_void_remnant_speed:IsHidden() return false end
function modifier_custom_void_remnant_speed:IsPurgable() return false end
function modifier_custom_void_remnant_speed:GetTexture() return "buffs/manavoid_int" end

function modifier_custom_void_remnant_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_ATTACK_FAIL
}
end

function modifier_custom_void_remnant_speed:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "max")
self.range = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "range")
self.speed = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "speed")
self.cd = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "cd")

if not IsServer() then return end 

self:SetStackCount(self.max)
end


function modifier_custom_void_remnant_speed:OnRefresh()
self:OnCreated()
end 

function modifier_custom_void_remnant_speed:GetModifierAttackRangeBonus()
return self.range
end
function modifier_custom_void_remnant_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_custom_void_remnant_speed:OnAttackFail(params)
if not IsServer() then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:ReduceStack()
end 


function modifier_custom_void_remnant_speed:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.no_attack_cooldown then return end
 

for i = 1,3 do
	local particle = ParticleManager:CreateParticle( "particles/void_spirit/void_mark_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetParent() )
	ParticleManager:SetParticleControlEnt( particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end 


local hit_effect = ParticleManager:CreateParticle("particles/void_spirit/remnant_hit.vpcf", PATTACH_CUSTOMORIGIN, params.target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)
params.target:EmitSound("Hoodwink.Scurry_attack")

if self:GetCaster() ~= self:GetParent() and self:GetCaster():HasModifier(self:GetName()) then 
	self:GetCaster():CdAbility(self:GetAbility(), self.cd)
	self:GetCaster():FindModifierByName(self:GetName()):ReduceStack()
else 
	if self:GetCaster() == self:GetParent() then 
		self:GetCaster():CdAbility(self:GetAbility(), self.cd)
	end
end 

self:ReduceStack()
end 


function modifier_custom_void_remnant_speed:ReduceStack()
if not IsServer() then return end 

self:DecrementStackCount()
if self:GetStackCount() == 0 then 
	self:Destroy()
end 

end 




modifier_custom_void_remnant_legendary_illusion = class({})
function modifier_custom_void_remnant_legendary_illusion:IsHidden() return true end
function modifier_custom_void_remnant_legendary_illusion:IsPurgable() return false end
function modifier_custom_void_remnant_legendary_illusion:GetEffectName() return "particles/void_spirit/remnant_legendary.vpcf" end
function modifier_custom_void_remnant_legendary_illusion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_custom_void_remnant_legendary_illusion:GetStatusEffectName() return "particles/void_step_texture.vpcf" end
function modifier_custom_void_remnant_legendary_illusion:StatusEffectPriority() return 9999999 end


function modifier_custom_void_remnant_legendary_illusion:OnCreated()

self.status = self:GetCaster():GetTalentValue("modifier_void_remnant_legendary", "status")

if not IsServer() then return end

if self:GetCaster().void_clone and not self:GetCaster().void_clone:IsNull() then 
	self:GetCaster().void_clone:Kill(nil, self:GetCaster())
end 

local mod = self:GetCaster():FindModifierByName("modifier_custom_void_remnant_speed")

if mod then 
	local new_mod = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_speed", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_4", "duration")})
	new_mod:SetStackCount(mod:GetStackCount())
end 

if self:GetCaster():HasModifier("modifier_void_remnant_2") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_move", {duration = self:GetCaster():GetTalentValue("modifier_void_remnant_2", "duration")})
end 

self:GetCaster().void_clone = self:GetParent()

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_void_remnant_legendary_caster", {})

self:GetParent():EmitSound("VoidSpirit.Remnant_legendary")

local effect_cast = ParticleManager:CreateParticle( "particles/void_buf2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:ReleaseParticleIndex(effect_cast)
end 


function modifier_custom_void_remnant_legendary_illusion:OnDestroy()
if not IsServer() then return end

self:GetCaster().void_clone = nil

self:GetCaster():RemoveModifierByName('modifier_custom_void_remnant_legendary_caster')

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

function modifier_custom_void_remnant_legendary_illusion:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}
end


function modifier_custom_void_remnant_legendary_illusion:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_MODEL_SCALE,
}
end


function modifier_custom_void_remnant_legendary_illusion:GetModifierModelScale()
return 15
end

function modifier_custom_void_remnant_legendary_illusion:GetModifierStatusResistanceStacking() 
return self.status
end


function modifier_custom_void_remnant_legendary_illusion:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:GetCaster():PerformAttack(params.target, true, true, true, true, true, false, true)
end 




modifier_custom_void_remnant_legendary_caster = class({})
function modifier_custom_void_remnant_legendary_caster:IsHidden() return true end
function modifier_custom_void_remnant_legendary_caster:IsPurgable() return false end
function modifier_custom_void_remnant_legendary_caster:RemoveOnDeath() return false end
function modifier_custom_void_remnant_legendary_caster:OnCreated(table)
if not IsServer() then return end 

self.ability = self:GetParent():FindAbilityByName("void_spirit_aether_remnant_custom_legendary")

if self.ability then 
	self.ability:SetActivated(true)
end 

end

function modifier_custom_void_remnant_legendary_caster:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end


function modifier_custom_void_remnant_legendary_caster:GetEffectName() return "particles/units/heroes/hero_brewmaster/brewmaster_void_debuff.vpcf" end
 
function modifier_custom_void_remnant_legendary_caster:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


function modifier_custom_void_remnant_legendary_caster:OnDestroy()
if not IsServer() then return end 

if self.ability then 
	self.ability:SetActivated(false)
end 

end 




void_spirit_aether_remnant_custom_legendary = class({})


function void_spirit_aether_remnant_custom_legendary:OnSpellStart()
if not self:GetCaster().void_clone then return end 

local dir = self:GetCaster().void_clone:GetForwardVector()
local point = self:GetCaster().void_clone:GetAbsOrigin() + dir*10


local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(effect)

EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "VoidSpirit.Remnant_blink", self:GetCaster())

FindClearSpaceForUnit(self:GetCaster(), self:GetCaster().void_clone:GetAbsOrigin(), true)


effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(effect)

self:GetCaster():SetForwardVector(dir)
self:GetCaster():FaceTowards(point)

self:GetCaster().void_clone:Kill(nil, self:GetCaster())
self:GetCaster():MoveToPositionAggressive(self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*50)

EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "VoidSpirit.Remnant_blink_end", self:GetCaster())
end





modifier_custom_void_remnant_move = class({})
function modifier_custom_void_remnant_move:IsHidden() return false end
function modifier_custom_void_remnant_move:IsPurgable() return false end
function modifier_custom_void_remnant_move:GetTexture() return "buffs/remnant_stats" end
function modifier_custom_void_remnant_move:GetEffectName() return "particles/void_step_speed.vpcf" end
function modifier_custom_void_remnant_move:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end


function modifier_custom_void_remnant_move:GetActivityTranslationModifiers()
return "haste"
end



modifier_custom_void_remnant_heal_reduce = class({})
function modifier_custom_void_remnant_heal_reduce:IsHidden() return false end
function modifier_custom_void_remnant_heal_reduce:IsPurgable() return false end
function modifier_custom_void_remnant_heal_reduce:GetTexture() return "buffs/flux_speed" end
function modifier_custom_void_remnant_heal_reduce:OnCreated()

self.heal_reduce =  self:GetCaster():GetTalentValue("modifier_void_remnant_3", "heal_reduce")
self.damage_reduce =  self:GetCaster():GetTalentValue("modifier_void_remnant_3", "damage_reduce")
end


function modifier_custom_void_remnant_heal_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_custom_void_remnant_heal_reduce:GetModifierSpellAmplify_Percentage()
return self.damage_reduce
end

function modifier_custom_void_remnant_heal_reduce:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_custom_void_remnant_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_custom_void_remnant_heal_reduce:GetModifierHealAmplify_PercentageTarget() 
return self.heal_reduce
end

function modifier_custom_void_remnant_heal_reduce:GetModifierHPRegenAmplify_Percentage()
return self.heal_reduce
end





modifier_custom_void_remnant_lifesteal = class({})
function modifier_custom_void_remnant_lifesteal:IsHidden() return true end
function modifier_custom_void_remnant_lifesteal:IsPurgable() return false end
function modifier_custom_void_remnant_lifesteal:OnCreated()
self.heal = self:GetCaster():GetTalentValue("modifier_void_remnant_6", "lifesteal")/100
end

function modifier_custom_void_remnant_lifesteal:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_void_remnant_lifesteal:OnTakeDamage(params)
if not IsServer() then return end 
if not params.attacker then return end 
if params.unit ~= self:GetParent() then return end 
if params.attacker ~= self:GetCaster() then return end 
if self:GetParent():IsIllusion() then return end


self:GetCaster():GenericHeal(self.heal*params.damage, self:GetAbility(), true)
end 