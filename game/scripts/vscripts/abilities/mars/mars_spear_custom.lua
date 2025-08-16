LinkLuaModifier("modifier_mars_spear_custom", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_debuff", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_legendary", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_hit_speed", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_trail_thinker", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_trail_burn", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_incoming", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_healing", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_tracker", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_slow", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_leash", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)


mars_spear_custom = class({})


mars_spear_custom.projectiles = {}
mars_spear_custom.index = 0

function mars_spear_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
	
PrecacheResource( "particle", "particles/mars/spear_legendary_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_spear.vpcf", context )
PrecacheResource( "particle", "particles/sf_raze_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_spear_impact.vpcf", context )
PrecacheResource( "particle", "particles/mars/spear_legendary_rope.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_spear_impact_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_mars_spear.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/mars_trail.vpcf", context )
PrecacheResource( "particle", "particles/roshan_meteor_burn_.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_charge_mark.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/spirit_vessel_damage.vpcf", context )
PrecacheResource( "particle", "particles/jugg_legendary_proc_.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/iron_talon_active.vpcf", context )
PrecacheResource( "particle", "particles/lina_attack_slow.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_mars_spear.vpcf", context )
end



function mars_spear_custom:OnInventoryContentsChanged()
if self:GetCaster():HasShard() and not self.shard_init then
	self.shard_init = true
	self:ToggleAutoCast()
end

end 

function mars_spear_custom:GetManaCost(level)
if self:GetCaster():HasModifier("modifier_mars_spear_custom_legendary") then 
  return 0
end 
return self.BaseClass.GetManaCost(self,level)
end

function mars_spear_custom:GetCastRange(vLocation, hTarget)

local bonus = 0
if self:GetCaster():HasTalent("modifier_mars_spear_2") then 
	bonus = self:GetCaster():GetTalentValue("modifier_mars_spear_2", "range")
end 
return self:GetSpecialValueFor("spear_range") + bonus
end


function mars_spear_custom:GetIntrinsicModifierName()
return "modifier_mars_spear_custom_tracker"
end

function mars_spear_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_mars_spear_custom_legendary") then 
  return "mars_spear_stop"
end 
return "mars_spear"
end 

function mars_spear_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasShard() then 
	bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 
if self:GetCaster():HasModifier("modifier_mars_spear_custom_legendary") then 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + bonus
end
return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + bonus
end



function mars_spear_custom:GetCastPoint()
if self:GetCaster():HasTalent("modifier_mars_spear_7") then 
	return 0
else 
	return self.BaseClass.GetCastPoint(self)
end

end

function mars_spear_custom:GetCastAnimation()
if self:GetCaster():HasTalent("modifier_mars_spear_7") then 
	return 
else 
	return ACT_DOTA_CAST_ABILITY_5
end

end

function mars_spear_custom:GetCooldown(iLevel)
return self.BaseClass.GetCooldown(self, iLevel)
end


function mars_spear_custom:GetRange()
return self:GetSpecialValueFor("spear_range") + self:GetCaster():GetTalentValue("modifier_mars_spear_2", "range") + self:GetCaster():GetCastRangeBonus()
end

function mars_spear_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()
local point = self:GetCursorPosition()

if point == caster:GetAbsOrigin() then 
	point = point + caster:GetForwardVector()*10
end

local mod = caster:FindModifierByName("modifier_mars_spear_custom_legendary")

if mod then 
	mod:Destroy()
	return
end 


if caster:HasTalent("modifier_mars_spear_7") then 
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 0.06)
	caster:SetForwardVector( (point - caster:GetAbsOrigin()):Normalized() )
	caster:FaceTowards(point)

	self:EndCooldown()
	self:StartCooldown(0.2)

	local radius = caster:GetTalentValue("modifier_mars_spear_7", "radius")
	local slow_duration = caster:GetTalentValue("modifier_mars_spear_7", "slow_duration")

	local origin = caster:GetAbsOrigin()

	local nFXIndex = ParticleManager:CreateParticle( "particles/mars/spear_legendary_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( nFXIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	for _,target in pairs(caster:FindTargets(radius)) do

		local enemy_direction = (target:GetOrigin() - origin):Normalized()
		local point = origin + enemy_direction*(radius + 10) 
		local distance = (point - target:GetAbsOrigin()):Length2D()

		target:AddNewModifier(caster, caster:BkbAbility(self, true),
		"modifier_generic_knockback",
		{
			duration = 0.2,
			distance = distance,
			height = 0,
			direction_x = enemy_direction.x,
			direction_y = enemy_direction.y,
		})

		target:AddNewModifier(caster, caster:BkbAbility(self, true), "modifier_mars_spear_custom_slow", {duration = (1 - target:GetStatusResistance())*slow_duration})
	end 


	caster:AddNewModifier( caster, self, "modifier_mars_spear_custom_legendary", { duration = caster:GetTalentValue("modifier_mars_spear_7", "duration")})
	caster:EmitSound("Mars.Spear_cast")
	caster:EmitSound("Mars.Spear_legendary_start")
else 
	self:LaunchSpear(caster:GetAbsOrigin(), point, 0, 1)
end

end



function mars_spear_custom:LaunchSpear(origin, point, legendary_k, init_launch)
if not IsServer() then return end

local caster = self:GetCaster()

local projectile_distance = self:GetRange()
local projectile_speed = self:GetSpecialValueFor("spear_speed") * (1 + caster:GetTalentValue("modifier_mars_spear_5", "speed")/100)
local projectile_radius = self:GetSpecialValueFor("spear_width") * (1 + caster:GetTalentValue("modifier_mars_spear_5", "width")/100)
local projectile_vision = self:GetSpecialValueFor("spear_vision")
local damage = self:GetSpecialValueFor("damage")


local direction = point - origin
direction.z = 0

if init_launch == 0 then
	damage = self:GetSpecialValueFor("shard_damage") 
	projectile_distance = (origin - point):Length2D()
	projectile_speed = projectile_speed * (1 + self:GetSpecialValueFor("shard_speed")/100)
end

self.index = self.index + 1

local info = {
	Source = caster,
	Ability = self,
	vSpawnOrigin = origin,
  bDeleteOnHit = false,
  iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
  iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
  EffectName = "particles/units/heroes/hero_mars/mars_spear.vpcf",
  fDistance = projectile_distance,
  fStartRadius = projectile_radius,
  fEndRadius =projectile_radius,
	vVelocity = direction:Normalized() * projectile_speed,
	bHasFrontalCone = false,
	bReplaceExisting = false,
	bProvidesVision = true,
	iVisionRadius = projectile_vision,
	fVisionDuration = 10,
	iVisionTeamNumber = caster:GetTeamNumber(),
	ExtraData = 
	{
		damage = damage,
		index = self.index,
		legendary_k = legendary_k
	}
}

self.projectiles[self.index] = {}

caster:EmitSound("Hero_Mars.Spear.Cast")
caster:EmitSound("Hero_Mars.Spear")

local id = ProjectileManager:CreateLinearProjectile(info)

self.projectiles[self.index].projid = id
self.projectiles[self.index].init_launch = init_launch
self.projectiles[self.index].dir_x = direction.x
self.projectiles[self.index].dir_y = direction.y
self.projectiles[self.index].distance = 0
self.projectiles[self.index].total_distance = projectile_distance

end




function mars_spear_custom:OnChargeFinish(k)
if not IsServer() then return end
local caster = self:GetCaster()

if not caster:IsAlive() then return end

caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_5)
caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 1)
caster:Stop()

self:LaunchSpear(caster:GetAbsOrigin(), caster:GetForwardVector()*10 + caster:GetAbsOrigin(), k, 1)

end







function mars_spear_custom:OnProjectileHit_ExtraData(target, location, table)

local damage = table.damage
local caster = self:GetCaster()

if not target then

	self:EndSpear(table.index)

	local projectile_vision = self:GetSpecialValueFor("spear_vision")
	AddFOWViewer( caster:GetTeamNumber(), location, projectile_vision, 1, false)
	return
end

if caster:HasTalent("modifier_mars_spear_1") and not caster:HasModifier("modifier_mars_spear_custom_hit_speed")  then 
	
	caster:EmitSound("Sf.Speed_Heal")     

	self.particle_aoe_fx = ParticleManager:CreateParticle("particles/sf_raze_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(self.particle_aoe_fx, 0,  caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_aoe_fx, 1,  caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_aoe_fx, 2,  caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(self.particle_aoe_fx, 3,  caster:GetAbsOrigin())
	ParticleManager:DestroyParticle(self.particle_aoe_fx, false)
	ParticleManager:ReleaseParticleIndex(self.particle_aoe_fx) 

	caster:AddNewModifier(caster, self, "modifier_mars_spear_custom_hit_speed", {duration = caster:GetTalentValue("modifier_mars_spear_1", "duration")})
end

if table.legendary_k > 0 then
	target:RemoveModifierByName("modifier_mars_spear_custom_incoming") 
	target:AddNewModifier(caster, caster:BkbAbility(self, true), "modifier_mars_spear_custom_incoming", {k = table.legendary_k, duration = caster:GetTalentValue("modifier_mars_spear_7", "effect_duration")})
end 


if caster:HasTalent("modifier_mars_spear_4") then 
	target:AddNewModifier(caster, self, "modifier_mars_spear_custom_healing", {duration = caster:GetTalentValue("modifier_mars_spear_4", "duration")})
end

DoDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })

if not target:IsRealHero() or self.projectiles[table.index].entindex ~= nil or target:IsDebuffImmune() then

	local direction = Vector(self.projectiles[table.index].dir_x, self.projectiles[table.index].dir_y, 0):Normalized()
	local proj_angle = VectorToAngles( direction ).y
	local unit_angle = VectorToAngles( target:GetOrigin()-location ).y
	local angle_diff = unit_angle - proj_angle

	if AngleDiff( unit_angle, proj_angle )>=0 then
		direction = RotatePosition( Vector(0,0,0), QAngle( 0, 90, 0 ), direction )
	else
		direction = RotatePosition( Vector(0,0,0), QAngle( 0, -90, 0 ), direction )
	end

	local knockback_duration = self:GetSpecialValueFor("knockback_duration")
	local knockback_distance = self:GetSpecialValueFor("knockback_distance")
	local point = target:GetAbsOrigin() + direction*knockback_distance

  target:AddNewModifier( caster,  self,  "modifier_generic_arc",  
  {
    target_x = point.x,
    target_y = point.y,
    distance = knockback_distance,
    duration = knockback_duration,
    height = 0,
    fix_end = false,
    isStun = true,
  })
	target:EmitSound("Hero_Mars.Spear.Knockback")
	return false
end


self.projectiles[table.index].entindex = target:entindex()
self.projectiles[table.index].mod = target:AddNewModifier( caster, self, "modifier_mars_spear_custom", {index = table.index} )
target:EmitSound("Hero_Mars.Spear.Target")

end



function mars_spear_custom:OnProjectileThink_ExtraData(vLocation, table)

local caster = self:GetCaster()
local location = GetGroundPosition(vLocation, nil)
local old_pos = GetGroundPosition(Vector(self.projectiles[table.index].x, self.projectiles[table.index].y, 0), nil)
local direction = Vector(self.projectiles[table.index].dir_x, self.projectiles[table.index].dir_y, 0):Normalized()

self.projectiles[table.index].x = location.x
self.projectiles[table.index].y = location.y

if self.projectiles[table.index].init_launch == 0 then return true end

if caster:HasTalent("modifier_mars_spear_3") then 
	self.projectiles[table.index].distance = self.projectiles[table.index].distance + (old_pos - location):Length2D()

	if self.projectiles[table.index].distance >= caster:GetTalentValue("modifier_mars_spear_3", "radius") then 
		self.projectiles[table.index].distance = 0
		CreateModifierThinker(caster, self, "modifier_mars_spear_custom_trail_thinker", {duration = caster:GetTalentValue("modifier_mars_spear_3", "duration"), x = direction.x, y = direction.y }, location, caster:GetTeamNumber(), false)
	end
end

if self.projectiles[table.index].entindex == nil then return end

local tree_radius = 50
local wall_radius = 50
local building_radius = 30


if caster.current_arena ~= nil and caster.current_arena.radius ~= nil then 

	local center = caster.current_arena:GetAbsOrigin()
	local dist = (location - center):Length2D()
	local max_range = caster.current_arena.radius

	if (dist >= max_range - wall_radius) and (dist <= max_range + wall_radius) then 
		self:Pinned(table.index, true)
		return
	end 
end

local thinkers = Entities:FindAllByClassnameWithin( "npc_dota_thinker", location, wall_radius )
for _,thinker in pairs(thinkers) do
	if thinker:IsPhantomBlocker() then
		self:Pinned( table.index )
		return
	end
end

local base_loc = GetGroundPosition( location, nil )
local search_loc = GetGroundPosition( base_loc + direction*wall_radius, nil )
if  (not GridNav:IsTraversable( search_loc )) then
	self:Pinned( table.index )
	return
end

if GridNav:IsNearbyTree( vLocation, tree_radius, true) then
	self:Pinned( table.index )
	return
end

local buildings = FindUnitsInRadius( caster:GetTeamNumber(), location, nil, building_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

if #buildings>0 then
	self:Pinned( table.index )
	return
end

end





function mars_spear_custom:Pinned( index, is_arena )
if not self.projectiles[index] then return end
if self.projectiles[index].entindex == nil then return end

local caster = self:GetCaster()
local unit = EntIndexToHScript(self.projectiles[index].entindex)

local duration = (self:GetSpecialValueFor("stun_duration") + caster:GetTalentValue("modifier_mars_spear_2", "stun"))*(1 - unit:GetStatusResistance()) 
local projectile_vision = self:GetSpecialValueFor("spear_vision")

AddFOWViewer( caster:GetTeamNumber(), unit:GetOrigin(), projectile_vision, duration, false)

ProjectileManager:DestroyLinearProjectile( self.projectiles[index].projid )

if caster:HasTalent("modifier_mars_spear_6") then 
	caster:CdItems(caster:GetTalentValue("modifier_mars_spear_6", "cd_items"))
end

if is_arena then 
	local point = unit:GetAbsOrigin() + Vector(self.projectiles[index].dir_x, self.projectiles[index].dir_y, 0):Normalized()*-80
	point = GetGroundPosition(point, nil)
	FindClearSpaceForUnit(unit, point, true)
end

unit:AddNewModifier( caster, ability, "modifier_mars_spear_custom_debuff", {duration =  duration})

if unit:IsValidKill(caster) then 
	if caster:GetQuest() == "Mars.Quest_5" then 
		caster:UpdateQuest(1)
	end
end

self:PlayEffects( index, duration )
self:EndSpear(index)
end



function mars_spear_custom:EndSpear(index)
if not self.projectiles[index] then return end

local caster = self:GetCaster()

local miss = true

if self.projectiles[index].entindex then 

	local mod = self.projectiles[index].mod
	local unit = EntIndexToHScript(self.projectiles[index].entindex)

	if not unit:IsDebuffImmune() then 
		miss = false
	end 

	if mod and not mod:IsNull() then

		mod:Destroy()
		local dir = Vector(self.projectiles[index].dir_x, self.projectiles[index].dir_y, 0):Normalized()
		unit:SetOrigin( GetGroundPosition( unit:GetAbsOrigin() - dir*50, unit ) )
	end

end


if miss and caster:HasTalent("modifier_mars_spear_6") and self.projectiles[index].init_launch == 1 then 
	caster:CdAbility(self, self:GetCooldownTimeRemaining()*caster:GetTalentValue("modifier_mars_spear_6", "cd_self")/100)
	caster:GiveMana(self:GetManaCost(self:GetLevel()))
end


if self.projectiles[index].init_launch == 1 and caster:HasShard() and self:GetAutoCastState() == true then 

	local point = GetGroundPosition(Vector(self.projectiles[index].x, self.projectiles[index].y, 0), nil)
	local caster_loc = caster:GetAbsOrigin()
	local dir = (caster:GetAbsOrigin() - point):Normalized()
	local distance = (point - caster:GetAbsOrigin()):Length2D()
	local total_distance = self.projectiles[index].total_distance
	local delta = 200

	local new_point = point + dir*math.max(0, (math.min(distance, total_distance) - delta))

	self:LaunchSpear(point, new_point, 0, 0)
end 

self.projectiles[index] = nil
end



function mars_spear_custom:PlayEffects( index, duration )
if not self.projectiles[index] then return end
if self.projectiles[index].entindex == nil then return end

local unit = EntIndexToHScript(self.projectiles[index].entindex)
local direction = Vector(self.projectiles[index].dir_x, self.projectiles[index].dir_y, 0):Normalized()

unit:EmitSound("Hero_Mars.Spear.Root")

local delta = 50
local location = GetGroundPosition( unit:GetAbsOrigin(), unit ) + direction*delta


if self:GetCaster():HasShard() and self:GetAutoCastState() == true then return end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_spear_impact.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, location )
ParticleManager:SetParticleControl( effect_cast, 1, direction*1000 )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )
end









modifier_mars_spear_custom_legendary = class({})

function modifier_mars_spear_custom_legendary:IsPurgable()
	return false
end

function modifier_mars_spear_custom_legendary:GetTexture() return "buffs/arena_speed" end

function modifier_mars_spear_custom_legendary:OnCreated( kv )

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.turn_speed = self.parent:GetTalentValue("modifier_mars_spear_7", "turn_speed")
self.max_time = self.parent:GetTalentValue("modifier_mars_spear_7", "duration")

self.distance = self.ability:GetRange()
self.width = self.ability:GetSpecialValueFor("spear_width") * (1 + self.parent:GetTalentValue("modifier_mars_spear_5", "width")/100)

if not IsServer() then return end
self.parent:EmitSound("Mars.Spear_voice")

self.parent:AddOrderEvent(self)

self.anim_return = 0
self.origin = self.parent:GetOrigin()
self.charge_finish = false
self.target_angle = self.parent:GetAnglesAsVector().y
self.current_angle = self.target_angle
self.face_target = true

self.interval = FrameTime()
self.more_dist = 0

self:StartIntervalThink( self.interval )

self:PlayEffects1()
self:PlayEffects2()
end

function modifier_mars_spear_custom_legendary:OnDestroy()
if not IsServer() then return end

local dir = self.parent:GetForwardVector()
dir.z = 0

self.ability:UseResources(false, false, false, true)

self.parent:FaceTowards(self.parent:GetAbsOrigin() + dir*10)
self.parent:SetForwardVector(dir)

FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)

if self:GetStackCount() >= 80 then 
	self.parent:EmitSound("Mars.Spear_cast_voice")
end

self:GetAbility():OnChargeFinish(math.min(1, self:GetElapsedTime()/self.max_time))


if self.effect_cast then 
	ParticleManager:DestroyParticle(self.effect_cast, true)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end

end

function modifier_mars_spear_custom_legendary:DeclareFunctions()
local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_DISABLE_TURNING
}

return funcs
end

function modifier_mars_spear_custom_legendary:GetModifierDisableTurning()
return 1
end

function modifier_mars_spear_custom_legendary:OrderEvent( params )

if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
then
	self:SetDirection( params.pos )
elseif 
	(params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
	params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET) and params.target
then
	self:SetDirection( params.target:GetOrigin() )
elseif
	params.order_type==DOTA_UNIT_ORDER_STOP or 
	params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
then
	self:Destroy()
end	

end

function modifier_mars_spear_custom_legendary:SetDirection( location )
local dir = ((location-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
self.target_angle = VectorToAngles( dir ).y
self.face_target = false
end

function modifier_mars_spear_custom_legendary:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_mars_spear_custom_legendary:CheckState()
local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
}

return state
end

function modifier_mars_spear_custom_legendary:OnIntervalThink()
if IsServer() then
	self:SetStackCount(100*math.min(1,  self:GetElapsedTime()/self.max_time))


	self.anim_return = self.anim_return + FrameTime()
	if self.anim_return >= 1 then
		self.anim_return = 0
	end
end

self.more_dist = 0--math.min(1,  self:GetElapsedTime()/self.max_time)*self.max_range

AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), self.distance, FrameTime(), false)


if self.target and self.target:IsAlive() then 	
	local abs = self.target:GetAbsOrigin()
	abs.z = 0
	self:SetDirection(abs)
end

if self.parent:IsStunned() or self.parent:IsSilenced() or
	self.parent:IsCurrentlyHorizontalMotionControlled() or self.parent:IsCurrentlyVerticalMotionControlled()
then
	self:Destroy()
end
self:TurnLogic( FrameTime() )
self:SetEffects()
end

function modifier_mars_spear_custom_legendary:TurnLogic( dt )
if self.face_target then return end
local angle_diff = AngleDiff( self.current_angle, self.target_angle )
local turn_speed = self.turn_speed*dt

local sign = -1
if angle_diff<0 then sign = 1 end

if math.abs( angle_diff )<1.1*turn_speed then
	self.current_angle = self.target_angle
	self.face_target = true
else
	self.current_angle = self.current_angle + sign*turn_speed
end

local angles = self.parent:GetAnglesAsVector()
self.parent:SetLocalAngles( angles.x, self.current_angle, angles.z )
end



function modifier_mars_spear_custom_legendary:PlayEffects1()
self.effect_cast = ParticleManager:CreateParticleForPlayer( "particles/mars/spear_legendary_rope.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner() )
ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(self.width, 0, 0) )
self:SetEffects()
end


function modifier_mars_spear_custom_legendary:SetEffects()
if not self.effect_cast then return end

local target_pos = self.origin + self.parent:GetForwardVector() * (self.more_dist + self.distance)
ParticleManager:SetParticleControl( self.effect_cast, 1, target_pos )
end

function modifier_mars_spear_custom_legendary:PlayEffects2()
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf", PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControlEnt( effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
self:AddParticle( effect_cast, false, false, -1, false, false )
end




















modifier_mars_spear_custom = class({})

function modifier_mars_spear_custom:IsStunDebuff()
	return true
end
function modifier_mars_spear_custom:IsHidden()
	return true
end
function modifier_mars_spear_custom:IsPurgable()
	return false
end
function modifier_mars_spear_custom:IsPurgeException()
	return true
end

function modifier_mars_spear_custom:OnCreated( kv )
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not IsServer() then return end 

self.parent:Stop()

self.index = kv.index 
self.data = self.ability.projectiles[self.index]

self.dir = Vector(self.data.dir_x, self.data.dir_y, 0):Normalized()

self.parent:SetForwardVector( -self.dir )
self.parent:FaceTowards( self.parent:GetAbsOrigin() - self.dir*10 )


if not self.parent:HasModifier("modifier_mars_spear_stun") and not self.parent:IsDebuffImmune() then 
	--self.mod = self.parent:AddNewModifier(self.caster, self.ability, "modifier_mars_spear_stun", {})
end


self:StartIntervalThink(0.01)
end



function modifier_mars_spear_custom:OnDestroy()
if not IsServer() then return end

if self.mod and not self.mod:IsNull() then 
	self.mod:SetDuration(0.1, false)
end

self.parent:Stop()
self.parent:InterruptMotionControllers( false )
end



function modifier_mars_spear_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end


function modifier_mars_spear_custom:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end


function modifier_mars_spear_custom:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end


function modifier_mars_spear_custom:OnIntervalThink()
if not IsServer() then return end
if not self.data then 
	self:Destroy() 
	return 
end

local location = GetGroundPosition(Vector(self.data.x, self.data.y, 0), nil)

self.parent:SetOrigin( location + self.dir*60 )
end










modifier_mars_spear_custom_debuff = class({})


function modifier_mars_spear_custom_debuff:IsStunDebuff()
	return true
end
function modifier_mars_spear_custom_debuff:IsHidden()
	return true
end
function modifier_mars_spear_custom_debuff:IsPurgable()
	return false
end
function modifier_mars_spear_custom_debuff:IsPurgeException()
	return true
end


function modifier_mars_spear_custom_debuff:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_mars_spear_custom_debuff:OnCreated( kv )
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not IsServer() then return end 

self.parent:Stop()

self.projectile = kv.projectile

self.parent:AddNewModifier(self.caster, self.ability, "modifier_mars_spear_stun", {duration = self:GetRemainingTime()})
end




function modifier_mars_spear_custom_debuff:OnDestroy()
if not IsServer() then return end

self.parent:RemoveModifierByName("modifier_mars_spear_stun")

GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), 120, false )

if self.parent:IsAlive() and self.caster:HasTalent("modifier_mars_spear_5") then 
	self.parent:AddNewModifier(self.caster, self.ability, "modifier_mars_spear_custom_leash", {duration = (1 - self.parent:GetStatusResistance())*self.caster:GetTalentValue("modifier_mars_spear_5", "leash")})
end 

self.parent:Stop()
end


function modifier_mars_spear_custom_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
}
end

function modifier_mars_spear_custom_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_mars_spear_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED ] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_mars_spear_custom_debuff:GetEffectName()
	return "particles/units/heroes/hero_mars/mars_spear_impact_debuff.vpcf"
end

function modifier_mars_spear_custom_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_mars_spear_custom_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_mars_spear.vpcf"
end

function modifier_mars_spear_custom_debuff:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH  end

















modifier_mars_spear_custom_hit_speed = class({})
function modifier_mars_spear_custom_hit_speed:IsHidden() return false end
function modifier_mars_spear_custom_hit_speed:IsPurgable() return false end
function modifier_mars_spear_custom_hit_speed:GetTexture() return "buffs/spear_heal" end
function modifier_mars_spear_custom_hit_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}

end

function modifier_mars_spear_custom_hit_speed:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_mars_spear_custom_hit_speed:GetModifierHealthRegenPercentage()
return self.heal
end

function modifier_mars_spear_custom_hit_speed:GetActivityTranslationModifiers()
return "spear_stun"
end


function modifier_mars_spear_custom_hit_speed:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_mars_spear_custom_hit_speed:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_mars_spear_custom_hit_speed:OnCreated(table)

self.parent = self:GetParent()
self.move = self.parent:GetTalentValue("modifier_mars_spear_1", "move")
self.heal = self.parent:GetTalentValue("modifier_mars_spear_1", "heal")/self:GetRemainingTime()

if not IsServer() then return end
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle( effect_cast, false, false, -1, false, false )
end






















modifier_mars_spear_custom_trail_thinker = class({})
function modifier_mars_spear_custom_trail_thinker:IsHidden() return true end
function modifier_mars_spear_custom_trail_thinker:IsPurgable() return false end
function modifier_mars_spear_custom_trail_thinker:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.radius = self.caster:GetTalentValue("modifier_mars_spear_3", "radius")
self.duration = self.caster:GetTalentValue("modifier_mars_spear_3", "duration")
self.duration_fire = self.caster:GetTalentValue("modifier_mars_spear_3", "duration_burn")

self.dir = Vector(table.x, table.y, z)

self.start_pos = self.parent:GetAbsOrigin() - self.dir*self.radius/2
self.end_pos = self.parent:GetAbsOrigin() + self.dir*self.radius/2

self.pfx = ParticleManager:CreateParticle("particles/mars_trail.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.pfx, 0, self.start_pos)
ParticleManager:SetParticleControl(self.pfx, 1, self.end_pos)
ParticleManager:SetParticleControl(self.pfx, 2, Vector(self.duration, 0, 0))
ParticleManager:SetParticleControl(self.pfx, 3, Vector(self.radius, 0, 0))
self:AddParticle( self.pfx, false, false, -1, false, false )

self:StartIntervalThink(0.2)
end

function modifier_mars_spear_custom_trail_thinker:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInLine(self.caster:GetTeamNumber(), self.start_pos, self.end_pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)
for _,enemy in pairs(enemies) do
	enemy:AddNewModifier(self.caster, self.ability, "modifier_mars_spear_custom_trail_burn", {duration = self.duration_fire})
end


end

function modifier_mars_spear_custom_trail_thinker:OnDestroy()
if not IsServer() then return end

end






modifier_mars_spear_custom_trail_burn = class({})
function modifier_mars_spear_custom_trail_burn:IsHidden() return false end
function modifier_mars_spear_custom_trail_burn:IsPurgable() return false end
function modifier_mars_spear_custom_trail_burn:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.interval = self.caster:GetTalentValue("modifier_mars_spear_3", "interval")
self.damage = self.caster:GetTalentValue("modifier_mars_spear_3", "damage")*self.interval
self.slow = self.caster:GetTalentValue("modifier_mars_spear_3", "slow")

if not IsServer() then return end

self.parent:EmitSound("Mars.Fire_target")

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_mars_spear_custom_trail_burn:OnDestroy()
if not IsServer() then return end

self.parent:StopSound("Mars.Fire_target")
end

function modifier_mars_spear_custom_trail_burn:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_mars_spear_custom_trail_burn:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_mars_spear_custom_trail_burn:OnIntervalThink()
if not IsServer() then return end

DoDamage({ victim = self.parent, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability }, "modifier_mars_spear_3")
end

function modifier_mars_spear_custom_trail_burn:GetEffectName()
return "particles/roshan_meteor_burn_.vpcf"
end









modifier_mars_spear_custom_incoming = class({})
function modifier_mars_spear_custom_incoming:IsHidden() return false end
function modifier_mars_spear_custom_incoming:IsPurgable() return false end
function modifier_mars_spear_custom_incoming:GetTexture() return "buffs/odds_mark" end

function modifier_mars_spear_custom_incoming:OnCreated(table)
if not IsServer() then return end
self.caster = self:GetCaster()
self.parent = self:GetParent()

local max = self.caster:GetTalentValue("modifier_mars_spear_7", "damage")

self:SetStackCount(max*math.min(1, table.k))

self.particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_charge_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_mars_spear_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_mars_spear_custom_incoming:GetModifierIncomingDamage_Percentage() 
return self:GetStackCount()
end









modifier_mars_spear_custom_healing = class({})
function modifier_mars_spear_custom_healing:IsHidden() return false end
function modifier_mars_spear_custom_healing:IsPurgable() return false end
function modifier_mars_spear_custom_healing:GetTexture() return "buffs/arena_speed" end
function modifier_mars_spear_custom_healing:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.heal = self.caster:GetTalentValue("modifier_mars_spear_4", "heal_reduce")
self.damage = self.caster:GetTalentValue("modifier_mars_spear_4", "damage")/100
end

function modifier_mars_spear_custom_healing:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_mars_spear_custom_healing:GetModifierLifestealRegenAmplify_Percentage() return self.heal end
function modifier_mars_spear_custom_healing:GetModifierHealAmplify_PercentageTarget() return self.heal end
function modifier_mars_spear_custom_healing:GetModifierHPRegenAmplify_Percentage() return self.heal end

function modifier_mars_spear_custom_healing:GetEffectName()
    return "particles/items4_fx/spirit_vessel_damage.vpcf"
end


function modifier_mars_spear_custom_healing:OnDestroy()
if not IsServer() then return end 
if self:GetStackCount() == 0 then return end
if not self.parent:IsAlive() then return end

local damage = self:GetStackCount()*self.damage

self.parent:EmitSound("Mars.Spear_damage_after")


local trail_pfx2 = ParticleManager:CreateParticle("particles/jugg_legendary_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:ReleaseParticleIndex(trail_pfx2)

local trail_pfx = ParticleManager:CreateParticle("particles/items3_fx/iron_talon_active.vpcf", PATTACH_ABSORIGIN, self.parent)
ParticleManager:SetParticleControlEnt(trail_pfx, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt( trail_pfx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(trail_pfx)

local real_damage = DoDamage({victim = self.parent, attacker = self.caster, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}, "modifier_mars_spear_4")
self.parent:SendNumber(6, real_damage)
end 



modifier_mars_spear_custom_tracker = class({})
function modifier_mars_spear_custom_tracker:IsHidden() return true end
function modifier_mars_spear_custom_tracker:IsPurgable() return false end
function modifier_mars_spear_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()
if self.parent:IsRealHero() then 
	self.parent:AddDamageEvent_out(self)
end 

end 

function modifier_mars_spear_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_mars_spear_4") then return end 
if not params.unit:HasModifier("modifier_mars_spear_custom_healing") then return end

local mod = params.unit:FindModifierByName("modifier_mars_spear_custom_healing")

mod:SetStackCount(mod:GetStackCount() + params.damage)
end 





modifier_mars_spear_custom_slow = class({})
function modifier_mars_spear_custom_slow:IsHidden() return true end
function modifier_mars_spear_custom_slow:IsPurgable() return true end
function modifier_mars_spear_custom_slow:GetEffectName()
 return "particles/lina_attack_slow.vpcf" end


function modifier_mars_spear_custom_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_mars_spear_7", "slow")
end

function modifier_mars_spear_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_mars_spear_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end





modifier_mars_spear_custom_leash = class({})
function modifier_mars_spear_custom_leash:IsHidden() return true end
function modifier_mars_spear_custom_leash:IsPurgable() return false end
function modifier_mars_spear_custom_leash:CheckState()
return
{
  [MODIFIER_STATE_TETHERED] = true
}
end


function modifier_mars_spear_custom_leash:GetStatusEffectName()
	return "particles/status_fx/status_effect_mars_spear.vpcf"
end

function modifier_mars_spear_custom_leash:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH   end


function modifier_mars_spear_custom_leash:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_mars_spear_5", "attack_speed")
end

function modifier_mars_spear_custom_leash:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_mars_spear_custom_leash:GetModifierAttackSpeedBonus_Constant()
return self.speed
end