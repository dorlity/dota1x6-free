LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_silence", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_legendary", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_legendary_illusion", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_legendary_attack", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_tracker", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_speed", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_swap", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_blink", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_range", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_wave_of_silence_custom_damage", "abilities/drow_ranger/drow_ranger_wave_of_silence_custom", LUA_MODIFIER_MOTION_NONE )


drow_ranger_wave_of_silence_custom = class({})


function drow_ranger_wave_of_silence_custom:CreateTalent(name)

local caster = self:GetCaster()

if name == "modifier_drow_gust_7" then
	local ability = caster:FindAbilityByName("drow_ranger_wave_of_silence_custom_legendary")
	if ability then 
		ability:SetHidden(false)
	end 
end

end

function drow_ranger_wave_of_silence_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/drow_ranger/frost_legendary_hit_2.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/silence_legendary_damage.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/silence_legendary_speed.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/silence_legendary_speed_start.vpcf", context )
PrecacheResource( "particle", "particles/zuus_speed.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/drow/drow_arcana/drow_arcana_item_force_staff.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/silence_proc_damage.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/silence_burn.vpcf", context )

end



function drow_ranger_wave_of_silence_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_drow_ranger_ti6_cape_custom") then
    return "drow_ranger/immortal/drow_ranger_wave_of_silence"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_ti6_cape_custom_golden") then
    return "drow_ranger/immortal_gold/drow_ranger_wave_of_silence"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_ti6_cape_custom_witness") then
    return "drow_ranger/immortal/drow_ranger_wave_of_silence"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
    return "drow_ranger_silence_arcana"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    return "drow_ranger_silence_arcana_alt1"
end
if self:GetCaster():HasModifier("modifier_drow_eldwurm_head_custom") then
    return "drow_ranger/dragons_touch_ability_icons/drow_ranger_wave_of_silence"
end
return "drow_ranger_wave_of_silence"
end



function drow_ranger_wave_of_silence_custom:GetIntrinsicModifierName()
return "modifier_drow_ranger_wave_of_silence_custom_tracker"
end

function drow_ranger_wave_of_silence_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_drow_gust_3") then 
	bonus = self:GetCaster():GetTalentValue("modifier_drow_gust_3", "cd")
end 
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function drow_ranger_wave_of_silence_custom:GetCastPoint()
local bonus = 0
if self:GetCaster():HasTalent("modifier_drow_gust_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_drow_gust_5", "cast")
end
return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end


function drow_ranger_wave_of_silence_custom:OnSpellStart()
 
local caster = self:GetCaster()
local point = self:GetCursorPosition()

if caster:HasTalent("modifier_drow_gust_1") then
	caster:RemoveModifierByName("modifier_drow_ranger_wave_of_silence_custom_speed")
	caster:AddNewModifier(caster, self, "modifier_drow_ranger_wave_of_silence_custom_speed", {duration = caster:GetTalentValue("modifier_drow_gust_1", "duration")})
end

if caster:HasTalent("modifier_drow_gust_7") then 

	local ability = caster:FindAbilityByName("drow_ranger_wave_of_silence_custom_legendary")
	if ability then
		ability:SpawnIllusion(1)
	end
end 

if caster:HasTalent("modifier_drow_gust_5") then 
	caster:AddNewModifier(caster, self, "modifier_drow_ranger_wave_of_silence_custom_swap", {duration = caster:GetTalentValue("modifier_drow_gust_5", "duration_swap")})
end


if point == caster:GetAbsOrigin() then 
	point = caster:GetAbsOrigin() + caster:GetForwardVector()*10
end 

local speed = self:GetSpecialValueFor( "wave_speed" )
local width = self:GetSpecialValueFor( "wave_width" )

local projectile_distance = self:GetCastRange( point, nil )
local projectile_direction = point-caster:GetOrigin()
projectile_direction.z = 0
projectile_direction = projectile_direction:Normalized()

local proj_particle = "particles/units/heroes/hero_drow/drow_silence_wave.vpcf"
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
    proj_particle = "particles/econ/items/drow/drow_arcana/drow_arcana_silence_wave.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    proj_particle = "particles/econ/items/drow/drow_arcana/drow_arcana_silence_wave_v2.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_ti6_cape_custom") or self:GetCaster():HasModifier("modifier_drow_ranger_ti6_cape_custom_witness") then
    proj_particle = "particles/econ/items/drow/drow_ti6/drow_ti6_silence_wave.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_ti6_cape_custom_golden") then
    proj_particle = "particles/econ/items/drow/drow_ti6_gold/drow_ti6_silence_gold_wave.vpcf"
end

local info = {
	Source = caster,
	Ability = self,
	vSpawnOrigin = caster:GetAbsOrigin(),

	bDeleteOnHit = false,

	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

	EffectName = proj_particle,
	fDistance = projectile_distance,
	fStartRadius = width,
	fEndRadius = width,
	vVelocity = projectile_direction * speed,
	
	ExtraData = {
		x = caster:GetOrigin().x,
		y = caster:GetOrigin().y,
		illusion = 0
	}
}
ProjectileManager:CreateLinearProjectile(info)

caster:EmitSound("Hero_DrowRanger.Silence")
end


function drow_ranger_wave_of_silence_custom:OnProjectileHit_ExtraData( target, location, data )
if not target then return end

local caster = self:GetCaster()

if data.illusion == 0 then 

	local silence = self:GetSpecialValueFor( "silence_duration" )
	local duration = self:GetSpecialValueFor( "knockback_duration" ) + caster:GetTalentValue("modifier_drow_gust_3", "duration")
	local max_dist = self:GetSpecialValueFor( "knockback_distance_max" )


	local vec = target:GetOrigin()-Vector(data.x,data.y,0)
	vec.z = 0
	local distance = vec:Length2D()
	distance = (1-distance/self:GetCastRange( Vector(0,0,0), nil ))*max_dist

	if max_dist<0 then 
		distance = 0 
	end

	vec = vec:Normalized()

	if not target:IsDebuffImmune() then 

		target:AddNewModifier( caster, self, "modifier_generic_knockback",
		{	
			direction_x = vec.x,
			direction_y = vec.y,
			distance = distance,
			height = 0,	
			duration = duration,
			IsStun = false,
			IsFlail = true,
			Purgable = 1,
		})
	end

	target:AddNewModifier(caster, self, "modifier_drow_ranger_wave_of_silence_custom_silence", {duration = silence*(1 - target:GetStatusResistance())})


	if caster:HasTalent("modifier_drow_gust_2") then 
		local damage = caster:GetTalentValue("modifier_drow_gust_2", "damage")*caster:GetAverageTrueAttackDamage(nil)/100
		DoDamage({victim = target, attacker = caster, ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage}, "modifier_drow_gust_2")

		target:AddNewModifier(caster, self, "modifier_drow_ranger_wave_of_silence_custom_damage", {duration = caster:GetTalentValue("modifier_drow_gust_2", "duration") + FrameTime()*2})
	end

	if caster:HasTalent("modifier_drow_gust_6") then 
		if not target:IsDebuffImmune() then 
			target:Purge(true, false, false, false, false)
		end
	end

	self:PlayEffects( target )
end 

if data.illusion == 1 and target:IsUnit() then 
	local radius = caster:GetTalentValue("modifier_drow_gust_7", "radius")
	local damage = caster:GetTalentValue("modifier_drow_gust_7", "damage")*caster:GetAverageTrueAttackDamage(nil)/100
	local silence = caster:GetTalentValue("modifier_drow_gust_7", "silence")

	local effect_cast = ParticleManager:CreateParticle( "particles/drow_ranger/silence_legendary_damage.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl(effect_cast, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(effect_cast, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex( effect_cast )

	target:EmitSound("Drow.Silence_legendary_damage")
	target:EmitSound("Drow.Silence_legendary_damage2")

	for _,unit in pairs(caster:FindTargets(radius, target:GetAbsOrigin())) do 

		unit:AddNewModifier(caster, self, "modifier_generic_silence", {duration = silence*(1 - unit:GetStatusResistance())})

		local real_damage = DoDamage({victim = unit, attacker = caster, ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage}, "modifier_drow_gust_7")
		unit:SendNumber(4, real_damage)
	end
end


end


function drow_ranger_wave_of_silence_custom:PlayEffects( target )
local effect_silence = "particles/units/heroes/hero_drow/drow_hero_silence.vpcf"
if self:GetCaster():HasModifier("modifier_drow_ranger_ti6_cape_custom") then
    effect_silence = "particles/econ/items/drow/drow_ti6/drow_hero_silence_ti6.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_ti6_cape_custom_golden") then
    effect_silence = "particles/econ/items/drow/drow_ti6/drow_hero_silence_ti6.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_ti6_cape_custom_witness") then
    effect_silence = "particles/econ/items/drow/drow_ti6/drow_hero_silence_ti6.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
    effect_silence = "particles/econ/items/drow/drow_arcana/drow_arcana_silence_impact_dust.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    effect_silence = "particles/econ/items/drow/drow_arcana/drow_arcana_silence_impact_v2_dust.vpcf"
end
local effect_cast = ParticleManager:CreateParticle( effect_silence, PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:ReleaseParticleIndex( effect_cast )
end







drow_ranger_wave_of_silence_custom_legendary = class({})


function drow_ranger_wave_of_silence_custom_legendary:SpawnIllusion(dont_move)
local caster = self:GetCaster()
local life_duration = caster:GetTalentValue("modifier_drow_gust_7", "life_duration")
local illusion_damage = self:GetSpecialValueFor("illusion_damage") - 100
local illusion_incoming = self:GetSpecialValueFor("illusion_incoming") - 100

local illusions = CreateIllusions( caster, caster, {duration=life_duration + 1, outgoing_damage=illusion_damage,incoming_damage=illusion_incoming}, 1, 0, true, true)  

for k,illusion in pairs(illusions) do

	for _,mod in pairs(caster:FindAllModifiers()) do
	    if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
	        illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
	    end
	end
	illusion.owner = caster
	illusion:AddNewModifier(caster, self, "modifier_drow_ranger_wave_of_silence_custom_legendary_illusion", {dont_move = dont_move})
end

end


function drow_ranger_wave_of_silence_custom_legendary:OnSpellStart()

local caster = self:GetCaster()
caster:EmitSound("Drow.Silence_legendary_start")
caster:AddNewModifier(caster, self, "modifier_drow_ranger_wave_of_silence_custom_legendary", {duration = caster:GetTalentValue("modifier_drow_gust_7", "duration")})
end




modifier_drow_ranger_wave_of_silence_custom_legendary = class({})
function modifier_drow_ranger_wave_of_silence_custom_legendary:IsHidden() return false end
function modifier_drow_ranger_wave_of_silence_custom_legendary:IsPurgable() return false end
function modifier_drow_ranger_wave_of_silence_custom_legendary:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.dist = self.ability:GetSpecialValueFor("distance")
self.max = self.ability:GetSpecialValueFor("max")

self.count = self.dist/2
self.pos = self.parent:GetAbsOrigin()

if not IsServer() then return end 


local effect_cast = ParticleManager:CreateParticle( "particles/drow_ranger/silence_legendary_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin()) 
self:AddParticle( effect_cast, false, false, -1, false, false )

self:StartIntervalThink(0.1)
end


function modifier_drow_ranger_wave_of_silence_custom_legendary:OnIntervalThink()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 


local new_pos = self.parent:GetAbsOrigin()
local dist = (new_pos - self.pos):Length2D()
self.count = self.count + dist
self.pos = new_pos

if self.count < self.dist then return end 

self.count = 0

self.parent:EmitSound("Drow.Silence_legendary_proc")
self:IncrementStackCount()

local effect_cast = ParticleManager:CreateParticle( "particles/drow_ranger/silence_legendary_speed_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:ReleaseParticleIndex(effect_cast)

self.ability:SpawnIllusion(0)

end 


function modifier_drow_ranger_wave_of_silence_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end








modifier_drow_ranger_wave_of_silence_custom_legendary_illusion = class({})
function modifier_drow_ranger_wave_of_silence_custom_legendary_illusion:IsHidden() return true end
function modifier_drow_ranger_wave_of_silence_custom_legendary_illusion:IsPurgable() return false end
function modifier_drow_ranger_wave_of_silence_custom_legendary_illusion:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not IsServer() then return end
self.dist = self.ability:GetSpecialValueFor("distance")
self.duration = self.caster:GetTalentValue("modifier_drow_gust_7", "life_duration")

self.dont_move = table.dont_move

self.radius = 1000
self.phase = 0
self.init = false

if self.dont_move == 1 then 
	self.init = true
end

self.frost_ability = self.caster:FindAbilityByName("drow_ranger_frost_arrows_custom")
if self.frost_ability then 
	self.parent:SetRangedProjectileName(self.frost_ability:GetProj())
end

self.effect_cast = ParticleManager:CreateParticle( "particles/drow_ranger/silence_legendary_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetAbsOrigin()) 
self:AddParticle( self.effect_cast, false, false, -1, false, false )

self:StartIntervalThink(FrameTime())
end

function modifier_drow_ranger_wave_of_silence_custom_legendary_illusion:OnIntervalThink()
if not IsServer() then return end


if not self.caster:HasModifier("modifier_drow_ranger_wave_of_silence_custom_legendary") and self.effect_cast then 
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	self.effect_cast = nil
end 

if self.phase ~= 0 then 
	self:SetTarget()
end

if self.phase == 1 and self:GetElapsedTime() >= self.duration then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_wave_of_silence_custom_legendary_attack", {})
	self.phase = 2
end 

if self.phase == 0 then 

	if self.dont_move == 0 then 
		self.parent:MoveToPosition(self.parent:GetAbsOrigin() + self.caster:GetForwardVector()*self.dist)
	end

	if self.init == false then 
		self.init = true
	end
end

if self.phase == 0 and (self:GetElapsedTime() >= 1 or self.dont_move == 1) then
	self.phase = 1
	self.parent:Stop()
	self:SetTarget()
end

end


function modifier_drow_ranger_wave_of_silence_custom_legendary_illusion:SetTarget()
if not IsServer() then return end


local heroes = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
local creeps = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

local target = nil
if #heroes > 0 then 
	target = heroes[1]
else 
	if #creeps > 0 then 
		target = creeps[1]
	end 
end 

if target == nil then 
	self.parent:SetForceAttackTarget(nil)
	return
end 

self.parent:SetForceAttackTarget(target)
self.parent:MoveToTargetToAttack(target)

end


function modifier_drow_ranger_wave_of_silence_custom_legendary_illusion:CheckState()
if self.init == false then 
	return
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
else 
	return
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	end
end








modifier_drow_ranger_wave_of_silence_custom_tracker = class({})
function modifier_drow_ranger_wave_of_silence_custom_tracker:IsHidden() return true end
function modifier_drow_ranger_wave_of_silence_custom_tracker:IsPurgable() return false end
function modifier_drow_ranger_wave_of_silence_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.bonus = self.parent:GetTalentValue("modifier_drow_gust_1", "bonus", true)

self.creeps = self.parent:GetTalentValue("modifier_drow_gust_4", "creeps", true)

if not IsServer() then return end 

if self.parent:IsRealHero() then 
	self.parent:AddDamageEvent_out(self)
	self.parent:AddAttackEvent_out(self)
	self.parent:AddAttackStartEvent_out(self)
end

end

function modifier_drow_ranger_wave_of_silence_custom_tracker:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_EVASION_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}
end

function modifier_drow_ranger_wave_of_silence_custom_tracker:GetModifierEvasion_Constant()
if not self.parent:HasTalent("modifier_drow_gust_1") then return end 
local bonus = 1
if self.parent:HasModifier("modifier_drow_ranger_wave_of_silence_custom_speed") then 
	bonus = self.bonus
end 
return self.parent:GetTalentValue("modifier_drow_gust_1", "evasion")*bonus
end



function modifier_drow_ranger_wave_of_silence_custom_tracker:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_drow_gust_1") then return end 
local bonus = 1
if self.parent:HasModifier("modifier_drow_ranger_wave_of_silence_custom_speed") then 
	bonus = self.bonus
end 
return self.parent:GetTalentValue("modifier_drow_gust_1", "move")*bonus
end


function modifier_drow_ranger_wave_of_silence_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_drow_gust_4") then return end
if not params.unit:IsUnit() then return end 

local attacker = params.attacker
if attacker.owner then
	attacker = attacker.owner
end

if self.parent ~= attacker then return end

if params.unit:IsSilenced() then 
	local heal = params.damage*self.parent:GetTalentValue("modifier_drow_gust_4", "heal")/100
	if params.unit:IsCreep() then 
		heal = heal/self.creeps
	end 
	self.parent:GenericHeal(heal, self.ability, true, "", "modifier_drow_gust_4")
end

local mod = params.unit:FindModifierByName("modifier_drow_ranger_wave_of_silence_custom_silence")

if mod and mod.damage then 
	mod:SetStackCount(mod:GetStackCount() + mod.damage*params.damage)
end 

end 


function modifier_drow_ranger_wave_of_silence_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end 
if not params.attacker:HasModifier("modifier_drow_ranger_wave_of_silence_custom_legendary_illusion") then return end

local ability = params.attacker:FindAbilityByName("drow_ranger_frost_arrows_custom")

if not ability or ability:GetLevel() < 1 then return end
ability:ApplySlow(params.target)
end 



function modifier_drow_ranger_wave_of_silence_custom_tracker:AttackStartEvent_out(params)
if not IsServer() then return end
if not params.attacker.owner then return end
if params.attacker.owner ~= self.parent then return end

local mod = params.attacker:FindModifierByName("modifier_drow_ranger_wave_of_silence_custom_legendary_attack")

if not mod then return end

local effect = "particles/units/heroes/hero_drow/drow_marksmanship_frost_arrow.vpcf"

local ability = self.parent:FindAbilityByName("drow_ranger_frost_arrows_custom")
if ability then 
	effect = ability:GetProjUlti()
end

local projectile =
{
	Source 				= params.attacker,
	Ability 			= self.ability,
	iMoveSpeed			= 1500,
	Target 				= params.target,
	EffectName 			= effect,
	vSourceLoc 			= params.attacker:GetAbsOrigin(),
	bDrawsOnMinimap 	= false,
	bDodgeable 			= true,
	bIsAttack 			= false,
	bVisibleToEnemies 	= true,
	bReplaceExisting 	= false,
	flExpireTime 		= GameRules:GetGameTime() + 20,
	bProvidesVision 	= false,
	ExtraData			= {illusion = 1}
}

ProjectileManager:CreateTrackingProjectile(projectile)

mod:Destroy()
params.attacker:Kill(nil, nil)
end






modifier_drow_ranger_wave_of_silence_custom_legendary_attack = class({})
function modifier_drow_ranger_wave_of_silence_custom_legendary_attack:IsHidden() return true end
function modifier_drow_ranger_wave_of_silence_custom_legendary_attack:IsPurgable() return false end
function modifier_drow_ranger_wave_of_silence_custom_legendary_attack:OnCreated()

end



modifier_drow_ranger_wave_of_silence_custom_speed = class({})
function modifier_drow_ranger_wave_of_silence_custom_speed:IsHidden() return false end
function modifier_drow_ranger_wave_of_silence_custom_speed:IsPurgable() return false end
function modifier_drow_ranger_wave_of_silence_custom_speed:OnCreated() 
self.parent = self:GetParent()

if not IsServer() then return end
local effect_cast = ParticleManager:CreateParticle( "particles/zuus_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
self:AddParticle( effect_cast, false, false, -1, false, false)
end



function modifier_drow_ranger_wave_of_silence_custom_speed:IsAura() return self.parent:IsRealHero() end
function modifier_drow_ranger_wave_of_silence_custom_speed:GetAuraDuration() return 0.1 end
function modifier_drow_ranger_wave_of_silence_custom_speed:GetAuraRadius() return 1000 end
function modifier_drow_ranger_wave_of_silence_custom_speed:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_drow_ranger_wave_of_silence_custom_speed:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_drow_ranger_wave_of_silence_custom_speed:GetModifierAura() return self:GetName() end
function modifier_drow_ranger_wave_of_silence_custom_speed:GetAuraEntityReject(hEntity)
if not hEntity:IsIllusion() or not hEntity.owner or hEntity.owner ~= self.parent then 
	return true
end
return false
end



drow_ranger_wave_of_silence_custom_blink = class({})
function drow_ranger_wave_of_silence_custom_blink:OnSpellStart()
local caster = self:GetCaster()
caster:RemoveModifierByName("modifier_drow_ranger_wave_of_silence_custom_swap")

caster:EmitSound("Drow.Silence_blink")
caster:EmitSound("Drow.Silence_blink2")
ProjectileManager:ProjectileDodge(caster)
caster:AddNewModifier(caster, self, "modifier_drow_ranger_wave_of_silence_custom_blink", {duration = caster:GetTalentValue("modifier_drow_gust_5", "duration")})
end



modifier_drow_ranger_wave_of_silence_custom_swap = class({})
function modifier_drow_ranger_wave_of_silence_custom_swap:IsHidden() return true end
function modifier_drow_ranger_wave_of_silence_custom_swap:IsPurgable() return false end
function modifier_drow_ranger_wave_of_silence_custom_swap:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.blink = self.parent:FindAbilityByName("drow_ranger_wave_of_silence_custom_blink")
if not self.blink then 
	self:Destroy()
	return
end

if not IsServer() then return end 

self.parent:SwapAbilities(self.ability:GetName(), self.blink:GetName(), false, true)
end

function modifier_drow_ranger_wave_of_silence_custom_swap:OnDestroy()
if not IsServer() then return end 
if not self.blink then return end

self.parent:SwapAbilities(self.ability:GetName(), self.blink:GetName(), true, false)

end






modifier_drow_ranger_wave_of_silence_custom_blink = class({})
function modifier_drow_ranger_wave_of_silence_custom_blink:IsHidden() return true end
function modifier_drow_ranger_wave_of_silence_custom_blink:IsPurgable() return true end

function modifier_drow_ranger_wave_of_silence_custom_blink:OnCreated(kv)
if not IsServer() then return end

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle( self.pfx, false, false, -1, false, false )

self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)

self.angle = -1*(self.parent:GetForwardVector():Normalized())
self.distance = self.parent:GetTalentValue("modifier_drow_gust_5", "distance") / ( self:GetDuration() / FrameTime())

if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end

end

function modifier_drow_ranger_wave_of_silence_custom_blink:DeclareFunctions()
return
{
MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_drow_ranger_wave_of_silence_custom_blink:GetActivityTranslationModifiers()
return "haste"
end


function modifier_drow_ranger_wave_of_silence_custom_blink:GetModifierDisableTurning() return 1 end

function modifier_drow_ranger_wave_of_silence_custom_blink:GetEffectName() return "particles/econ/items/drow/drow_arcana/drow_arcana_item_force_staff.vpcf" end
function modifier_drow_ranger_wave_of_silence_custom_blink:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_drow_ranger_wave_of_silence_custom_blink:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH end

function modifier_drow_ranger_wave_of_silence_custom_blink:OnDestroy()
if not IsServer() then return end
self.parent:InterruptMotionControllers( true )

self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_wave_of_silence_custom_range", {duration = self.parent:GetTalentValue("modifier_drow_gust_5", "range_duration")})

local dir = self.parent:GetForwardVector()
dir.z = 0
self.parent:SetForwardVector(dir)
self.parent:FaceTowards(self.parent:GetAbsOrigin() + dir*10)

ResolveNPCPositions(self.parent:GetAbsOrigin(), 128)
end


function modifier_drow_ranger_wave_of_silence_custom_blink:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
local pos = self.parent:GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(pos, 80, false)
local pos_p = self.angle * self.distance
local next_pos = GetGroundPosition(pos + pos_p,self.parent)
self.parent:SetAbsOrigin(next_pos)
end

function modifier_drow_ranger_wave_of_silence_custom_blink:OnHorizontalMotionInterrupted()
self:Destroy()
end







modifier_drow_ranger_wave_of_silence_custom_silence = class({})
function modifier_drow_ranger_wave_of_silence_custom_silence:IsHidden() return false end
function modifier_drow_ranger_wave_of_silence_custom_silence:IsPurgable() return true end
function modifier_drow_ranger_wave_of_silence_custom_silence:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.attack_range = self.caster:GetTalentValue("modifier_drow_gust_6", "attack_range", true)/100

if not IsServer() then return end

self:SetStackCount(0)

self.damage = self.caster:GetTalentValue("modifier_drow_gust_4", "damage")/100

local particle = "particles/generic_gameplay/generic_silenced.vpcf"

if self.caster:HasModifier("modifier_drow_ranger_arcana_custom") then
	particle = "particles/econ/items/drow/drow_arcana/drow_arcana_silenced.vpcf"
end
if self.caster:HasModifier("modifier_drow_ranger_arcana_custom_v2") then
	particle = "particles/econ/items/drow/drow_arcana/drow_arcana_silenced_v2.vpcf"
end

self.particle = ParticleManager:CreateParticle(particle, PATTACH_OVERHEAD_FOLLOW, self.parent)
self:AddParticle(self.particle, false, false, -1, false, false)


if not self.caster:HasTalent("modifier_drow_gust_6") then return end
self.particle = ParticleManager:CreateParticle("particles/items3_fx/silver_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle(self.particle, false, false, -1, false, false)

self:SetHasCustomTransmitterData(true)

self:OnIntervalThink() 
self:StartIntervalThink(0.2)
end

function modifier_drow_ranger_wave_of_silence_custom_silence:OnDestroy()
if not IsServer() then return end 
if self:GetStackCount() <= 0 then return end

local damage = self:GetStackCount()

self.parent:EmitSound("Drow.Silence_damage")

local trail_pfx2 = ParticleManager:CreateParticle("particles/drow_ranger/silence_proc_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:ReleaseParticleIndex(trail_pfx2)

local real_damage = DoDamage({victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage}, "modifier_drow_gust_4")
self.parent:SendNumber(6, real_damage)

end 

function modifier_drow_ranger_wave_of_silence_custom_silence:CheckState()
if self.caster:HasTalent("modifier_drow_gust_6") then 
	return 
	{
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
else 
	return
	{
		[MODIFIER_STATE_SILENCED] = true,
	}
end

end

function modifier_drow_ranger_wave_of_silence_custom_silence:OnIntervalThink()
if not IsServer() then return end 

self.range = 0
self.range = self.parent:Script_GetAttackRange()*self.attack_range
self:SendBuffRefreshToClients()
end

function modifier_drow_ranger_wave_of_silence_custom_silence:DeclareFunctions()
return
{
  	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_drow_ranger_wave_of_silence_custom_silence:GetModifierAttackRangeBonus()
if not self.caster:HasTalent("modifier_drow_gust_6") then return end
return self.range
end

function modifier_drow_ranger_wave_of_silence_custom_silence:AddCustomTransmitterData() 
return 
{
    range = self.range,
} 
end

function modifier_drow_ranger_wave_of_silence_custom_silence:HandleCustomTransmitterData(data)
self.range = data.range
end












modifier_drow_ranger_wave_of_silence_custom_range = class({})
function modifier_drow_ranger_wave_of_silence_custom_range:IsHidden() return false end
function modifier_drow_ranger_wave_of_silence_custom_range:IsPurgable() return false end
function modifier_drow_ranger_wave_of_silence_custom_range:GetTexture() return "buffs/gust_range" end
function modifier_drow_ranger_wave_of_silence_custom_range:OnCreated()
self.range = self:GetCaster():GetTalentValue("modifier_drow_gust_5", "range")
end

function modifier_drow_ranger_wave_of_silence_custom_range:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_drow_ranger_wave_of_silence_custom_range:GetModifierAttackRangeBonus()
return self.range
end


modifier_drow_ranger_wave_of_silence_custom_damage = class({})
function modifier_drow_ranger_wave_of_silence_custom_damage:IsHidden() return true end
function modifier_drow_ranger_wave_of_silence_custom_damage:IsPurgable() return false end
function modifier_drow_ranger_wave_of_silence_custom_damage:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.heal_reduce = self.caster:GetTalentValue("modifier_drow_gust_2", "heal_reduce")
end
--[[
function modifier_drow_ranger_wave_of_silence_custom_damage:GetEffectName()
return  "particles/drow_ranger/silence_burn.vpcf"
end

function modifier_drow_ranger_wave_of_silence_custom_damage:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end]]

function modifier_drow_ranger_wave_of_silence_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end


function modifier_drow_ranger_wave_of_silence_custom_damage:GetModifierLifestealRegenAmplify_Percentage()
return self.heal_reduce
end

function modifier_drow_ranger_wave_of_silence_custom_damage:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end


function modifier_drow_ranger_wave_of_silence_custom_damage:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end





