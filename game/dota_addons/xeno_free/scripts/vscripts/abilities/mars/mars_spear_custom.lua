LinkLuaModifier("modifier_mars_spear_custom", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_mars_spear_custom_debuff", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_debuff_knockback", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier("modifier_mars_spear_custom_legendary", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_legendary_anim", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_legendary_tracker", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_hit_speed", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_return", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_str", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_trail_thinker", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_trail_burn", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_incoming", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mars_spear_custom_healing", "abilities/mars/mars_spear_custom", LUA_MODIFIER_MOTION_NONE)


mars_spear_custom = class({})

mars_spear_custom.damage_inc = {6, 9, 12}
mars_spear_custom.damage_duration = 5

mars_spear_custom.range_speed = {1.2, 1.3, 1.4}
mars_spear_custom.range_stun = {0.2, 0.3, 0.4}

mars_spear_custom.legendary_duration = 2
mars_spear_custom.legendary_dist = 500
mars_spear_custom.legendary_damage = 150
mars_spear_custom.legendary_turn_speed = 120

mars_spear_custom.double_delay = 2
mars_spear_custom.double_damage = 0.2
mars_spear_custom.double_speed = 1.6

mars_spear_custom.hit_move = {10, 15, 20}
mars_spear_custom.hit_heal = {6, 9, 12}
mars_spear_custom.hit_heal_duration = 3


mars_spear_custom.stun_cd = -1
mars_spear_custom.stun_heal = -40
mars_spear_custom.stun_heal_duration = 5

mars_spear_custom.stun_max_damage = {8, 12}
mars_spear_custom.stun_max = 20
mars_spear_custom.stun_damage = {10, 15}


mars_spear_custom.spear_array = {}





function mars_spear_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_mars/mars_spear.vpcf', context )
PrecacheResource( "particle", 'particles/beast_charge.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf', context )
PrecacheResource( "particle", 'particles/sf_raze_heal.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_mars/mars_spear_impact.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_mars/mars_spear_impact_debuff.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_mars_spear.vpcf', context )
PrecacheResource( "particle", 'particles/mars_spear_grounded.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf', context )
PrecacheResource( "particle", 'particles/brist_lowhp_.vpcf', context )
PrecacheResource( "particle", 'particles/mars_trail.vpcf', context )
PrecacheResource( "particle", 'particles/roshan_meteor_burn_.vpcf', context )

end






function mars_spear_custom:OnAbilityPhaseStart()
	local mars_bulwark_custom = self:GetCaster():FindAbilityByName("mars_bulwark_custom")
	if mars_bulwark_custom and mars_bulwark_custom:GetToggleState() then
		mars_bulwark_custom:ToggleAbility()
	end
	return true
end

function mars_spear_custom:GetCastRange(vLocation, hTarget)
if IsServer() then return end
local bonus = 0

return self:GetSpecialValueFor("spear_range") + bonus
end

function mars_spear_custom:GetCastPoint()
if self:GetCaster():HasModifier("modifier_mars_spear_7") then 
	return 0
else 
	return 0.25
end

end
function mars_spear_custom:GetCastAnimation()
if self:GetCaster():HasModifier("modifier_mars_spear_7") then 
	return 
else 
	return ACT_DOTA_CAST_ABILITY_5
end

end


function mars_spear_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_mars_spear_5") then  
  upgrade_cooldown = self.stun_cd
end 


 return (self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown)

end


function mars_spear_custom:OnSpellStart()
if not IsServer() then return end
local point = self:GetCursorPosition()

if point == self:GetCaster():GetAbsOrigin() then 
	point = point + self:GetCaster():GetForwardVector()*10
end



if self:GetCaster():HasModifier("modifier_mars_spear_7") then 
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 0.1)
	self:GetCaster():SetForwardVector( (point - self:GetCaster():GetAbsOrigin()):Normalized() )
	self:GetCaster():FaceTowards(point)

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_mars_spear_custom_legendary", { duration = self.legendary_duration } )
	self:GetCaster():EmitSound("Mars.Spear_cast")
else 
	self:LaunchSpear(self:GetCaster():GetAbsOrigin(), point, 0, 1)
end

end

function mars_spear_custom:LaunchSpear(origin, point, k, init_launch, override_damage)
	if not IsServer() then return end

	local projectile_distance = self:GetSpecialValueFor("spear_range") + self:GetCaster():GetCastRangeBonus()
	local projectile_speed = self:GetSpecialValueFor("spear_speed")
	local projectile_radius = self:GetSpecialValueFor("spear_width")
	local projectile_vision = self:GetSpecialValueFor("spear_vision")

	--projectile_speed = projectile_speed + projectile_speed*k*self.legendary_speed/100


	projectile_distance = projectile_distance + k*self.legendary_dist

	if self:GetCaster():HasModifier("modifier_mars_spear_2") then 
		projectile_speed = projectile_speed*self.range_speed[self:GetCaster():GetUpgradeStack("modifier_mars_spear_2")]
	end 

	if init_launch == 0 then 
		projectile_speed = projectile_speed*self.double_speed
	end


	local direction = point - origin
	direction.z = 0
	direction = direction:Normalized()


	if init_launch == 0 then 
		local bonus = 0 
		if self:GetCaster():HasModifier("modifier_mars_spear_7") then 
			bonus = self.legendary_dist
		end 

		projectile_distance = math.min(projectile_distance + bonus, (origin - point):Length2D())
	end

	local info = {
		Source = self:GetCaster(),
		Ability = self,
		vSpawnOrigin = origin,
    bDeleteOnHit = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    EffectName = "particles/units/heroes/hero_mars/mars_spear.vpcf",
    fDistance = projectile_distance,
    fStartRadius = projectile_radius,
    fEndRadius =projectile_radius,
		vVelocity = direction * projectile_speed,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = true,
		iVisionRadius = projectile_vision,
		fVisionDuration = 10,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
	}

	self:GetCaster():EmitSound("Hero_Mars.Spear.Cast")

	local id = ProjectileManager:CreateLinearProjectile(info)
	

	local damage = self:GetSpecialValueFor("damage")


	if self:GetCaster():HasModifier("modifier_mars_spear_custom_str") and self:GetCaster():HasModifier("modifier_mars_spear_4") then 
		damage = damage + self:GetCaster():FindModifierByName("modifier_mars_spear_custom_str"):GetStackCount()*self.stun_damage[self:GetCaster():GetUpgradeStack("modifier_mars_spear_4")]
	end

	damage = damage*(1 + (self.legendary_damage/100)*(k))

	self.spear_array[id] = {}
	self.spear_array[id].init_launch = init_launch
	self.spear_array[id].k = k
	self.spear_array[id].damage = damage
	self.spear_array[id].hit = false
	self.spear_array[id].distance = self:GetSpecialValueFor("shard_trail_radius")*0.4
	self.spear_array[id].origin = origin



	if override_damage then 
		self.spear_array[id].damage = override_damage
	end


	self:GetCaster():EmitSound("Hero_Mars.Spear")
end







function mars_spear_custom:OnChargeFinish(k)
if not IsServer() then return end
if not self:GetCaster():IsAlive() then return end


self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_5)
self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 1.3)
self:GetCaster():Stop()

self:LaunchSpear(self:GetCaster():GetAbsOrigin(), self:GetCaster():GetForwardVector()*10 + self:GetCaster():GetAbsOrigin(), k, 1)

end


modifier_mars_spear_custom_legendary_anim = class({})
function modifier_mars_spear_custom_legendary_anim:IsHidden() return true end
function modifier_mars_spear_custom_legendary_anim:IsPurgable() return false end
function modifier_mars_spear_custom_legendary_anim:CheckState()
return
{
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
}
end


mars_spear_custom_end = class({})

function mars_spear_custom_end:OnSpellStart()

self:GetCaster():RemoveModifierByName("modifier_mars_spear_custom_legendary")
end






mars_spear_custom_return = class({})

function mars_spear_custom_return:OnSpellStart()

self:GetCaster():RemoveModifierByName("modifier_mars_spear_custom_return")
end




modifier_mars_spear_custom_legendary = class({})

function modifier_mars_spear_custom_legendary:IsPurgable()
	return false
end

function modifier_mars_spear_custom_legendary:OnCreated( kv )
	self.turn_speed = self:GetAbility().legendary_turn_speed
	self.max_time = self:GetAbility().legendary_duration
	self.distance =  self:GetAbility():GetSpecialValueFor("spear_range") + self:GetCaster():GetCastRangeBonus()

	if not IsServer() then return end
	self:GetCaster():EmitSound("Mars.Spear_voice")
	local release_ability = self:GetCaster():FindAbilityByName( "mars_spear_custom_end" )

	if release_ability then
		release_ability:StartCooldown(0.1)
	end

	self:GetCaster():SwapAbilities( "mars_spear_custom_end", "mars_spear_custom", true, false )


	self.anim_return = 0
	self.origin = self:GetParent():GetOrigin()
	self.charge_finish = false
	self.target_angle = self:GetParent():GetAnglesAsVector().y
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

	local dir = self:GetParent():GetForwardVector()
	dir.z = 0

	self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)
	self:GetParent():SetForwardVector(dir)

	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

	self:GetCaster():SwapAbilities( "mars_spear_custom_end", "mars_spear_custom", false, true )

	if self:GetStackCount() >= 80 then 
		self:GetCaster():EmitSound("Mars.Spear_cast_voice")
	end

	self:GetAbility():OnChargeFinish(math.min(1, self:GetElapsedTime()/self:GetAbility().legendary_duration) )


	if self.effect_cast then 
		ParticleManager:DestroyParticle(self.effect_cast, true)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
	end

end

function modifier_mars_spear_custom_legendary:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_DISABLE_TURNING
	}

	return funcs
end

function modifier_mars_spear_custom_legendary:GetModifierDisableTurning()
 return 1
end

function modifier_mars_spear_custom_legendary:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
	then
		self:SetDirection( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
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
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
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
		self:SetStackCount(100*math.min(1,  self:GetElapsedTime()/self:GetAbility().legendary_duration) )


		self.anim_return = self.anim_return + FrameTime()
		if self.anim_return >= 1 then
			self.anim_return = 0
		end
	end

	self.more_dist = math.min(1,  self:GetElapsedTime()/self:GetAbility().legendary_duration)*self:GetAbility().legendary_dist

	AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.distance, FrameTime(), false)



	if self.target and self.target:IsAlive() then 	
		local abs = self.target:GetAbsOrigin()
		abs.z = 0
		self:SetDirection(abs)
	end

	if self:GetParent():IsStunned() or self:GetParent():IsSilenced() or
		self:GetParent():IsCurrentlyHorizontalMotionControlled() or self:GetParent():IsCurrentlyVerticalMotionControlled()
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

	local angles = self:GetParent():GetAnglesAsVector()
	self:GetParent():SetLocalAngles( angles.x, self.current_angle, angles.z )
end

function modifier_mars_spear_custom_legendary:PlayEffects1()

self.effect_cast = ParticleManager:CreateParticleForPlayer( "particles/beast_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
self:SetEffects()

end

function modifier_mars_spear_custom_legendary:SetEffects()
if not self.effect_cast then return end
	local target_pos = self.origin + self:GetParent():GetForwardVector() * (self.more_dist + self.distance)
	ParticleManager:SetParticleControl( self.effect_cast, 1, target_pos )
end

function modifier_mars_spear_custom_legendary:PlayEffects2()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false )

end




















local mars_projectiles = {}

function mars_projectiles:Init( projectileID, caster, ability, init_launch )
	self[projectileID] = {}
	self[projectileID].location = ProjectileManager:GetLinearProjectileLocation( projectileID )
	self[projectileID].init_pos = self[projectileID].location
	self[projectileID].caster = EntIndexToHScript(caster)
	self[projectileID].ability = ability
	self[projectileID].init_launch = init_launch
	self[projectileID].damage = ability.spear_array[projectileID].damage

	if self[projectileID].origin == nil then 
		self[projectileID].origin = self[projectileID].location
	end

	local direction = ProjectileManager:GetLinearProjectileVelocity( projectileID )
	direction.z = 0
	direction = direction:Normalized()
	self[projectileID].direction = direction
end




function mars_projectiles:Destroy( projectileID )
local caster = self[projectileID].caster
local ability = self[projectileID].ability

if caster:HasModifier("modifier_mars_spear_6") and self[projectileID].init_launch == 1
 and not caster:HasModifier("modifier_mars_spear_custom_return") then 

	local dir = self[projectileID].origin - self[projectileID].location

	local thinker = CreateModifierThinker(caster, ability, "modifier_mars_spear_custom_legendary_tracker", 
		{
		 damage = self[projectileID].damage*ability.double_damage,
		 duration = ability.double_delay,
		 x = dir.x,
		 y = dir.y
		},

	self[projectileID].location + self[projectileID].direction*100,
	self[projectileID].caster:GetTeamNumber(),
	false)
	
	caster:AddNewModifier(caster, ability, "modifier_mars_spear_custom_return", {duration = ability.double_delay, thinker = thinker:entindex()})
end


ability.spear_array[projectileID] = nil
self[projectileID] = nil

end


mars_spear_custom.projectiles = mars_projectiles











function mars_spear_custom:OnProjectileHitHandle( target, location, iProjectileHandle )

	if not self.projectiles[iProjectileHandle] then

		if self.spear_array[iProjectileHandle] then 
			init_launch = self.spear_array[iProjectileHandle].init_launch
			self.projectiles:Init( iProjectileHandle, self:GetCaster():entindex(), self,  init_launch )
		else 
			return
		end

	end

	if not target then
		local projectile_vision = self:GetSpecialValueFor("spear_vision")
		AddFOWViewer( self:GetCaster():GetTeamNumber(), location, projectile_vision, 1, false)
		self.projectiles:Destroy( iProjectileHandle )
		return
	end


	if self:GetCaster():HasModifier("modifier_mars_spear_1") and not self:GetCaster():HasModifier("modifier_mars_spear_custom_hit_speed") and self.spear_array[iProjectileHandle].init_launch == 1 then 
		
		self:GetCaster():EmitSound("Sf.Speed_Heal")     

		self.particle_aoe_fx = ParticleManager:CreateParticle("particles/sf_raze_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(self.particle_aoe_fx, 0,  self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_aoe_fx, 1,  self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_aoe_fx, 2,  self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_aoe_fx, 3,  self:GetCaster():GetAbsOrigin())
		ParticleManager:DestroyParticle(self.particle_aoe_fx, false)
		ParticleManager:ReleaseParticleIndex(self.particle_aoe_fx) 

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mars_spear_custom_hit_speed", {duration = self.hit_heal_duration})
	end

	if self:GetCaster():HasModifier("modifier_mars_spear_3") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_mars_spear_custom_incoming", {duration = self.damage_duration})
	end 


	ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = self.spear_array[iProjectileHandle].damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })

	if (not target:IsHero()) or self.projectiles[iProjectileHandle].unit then

		local direction = self.projectiles[iProjectileHandle].direction
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

		target:AddNewModifier( self:GetCaster(), self, "modifier_mars_spear_custom_debuff_knockback", { duration = knockback_duration, distance = knockback_distance, direction_x = direction.x, direction_y = direction.y, IsFlail = false } )
		target:EmitSound("Hero_Mars.Spear.Knockback")

		return false
	end

	self.spear_array[iProjectileHandle].hit = true 
	local modifier = target:AddNewModifier( self:GetCaster(), self, "modifier_mars_spear_custom", {projectile = iProjectileHandle } )
	self.projectiles[iProjectileHandle].unit = target
	self.projectiles[iProjectileHandle].modifier = modifier
	self.projectiles[iProjectileHandle].active = false

	target:EmitSound("Hero_Mars.Spear.Target")
end

function mars_spear_custom:OnProjectileThinkHandle( iProjectileHandle )


	if not self.projectiles[iProjectileHandle] then	

		if self.spear_array[iProjectileHandle] then 
			init_launch = self.spear_array[iProjectileHandle].init_launch
			self.projectiles:Init( iProjectileHandle, self:GetCaster():entindex(), self,  init_launch )
		else 
			return
		end
	end

	local data = self.projectiles[iProjectileHandle]

	local location = ProjectileManager:GetLinearProjectileLocation( iProjectileHandle )
	data.location = location

	if self.spear_array[iProjectileHandle] and self:GetCaster():HasShard() and self.spear_array[iProjectileHandle].init_launch == 1 then 
		local distance = (self.spear_array[iProjectileHandle].origin - location):Length2D()
		local direction = (location - self.spear_array[iProjectileHandle].origin):Normalized()

		self.spear_array[iProjectileHandle].origin = location

		self.spear_array[iProjectileHandle].distance = self.spear_array[iProjectileHandle].distance + distance

		if self.spear_array[iProjectileHandle].distance >= self:GetSpecialValueFor("shard_trail_radius")*0.8 then 
			self.spear_array[iProjectileHandle].distance = 0
			CreateModifierThinker(self:GetCaster(), self, "modifier_mars_spear_custom_trail_thinker", {damage = self.spear_array[iProjectileHandle].damage, duration = self:GetSpecialValueFor("shard_trail_duration"), x = direction.x, y = direction.y }, location, self:GetCaster():GetTeamNumber(), false)
	
		end

	end

	local tree_radius = 120
	local wall_radius = 50
	local building_radius = 30
	local blocker_radius = 70



	if not data.unit then return end


	if not data.active then
		local difference = (data.unit:GetOrigin()-data.init_pos):Length2D() - (data.location-data.init_pos):Length2D()
		if difference>0 then return end
		data.active = true
	end

	if self.spear_array[iProjectileHandle].init_launch == 0 then return true end

	local location = GetGroundPosition(data.location, nil)
	local arena_walls = Entities:FindAllByClassnameWithin( "npc_dota_companion", location, wall_radius*1.2 )

	for _,arena_wall in pairs(arena_walls) do
		if arena_wall:HasModifier( "modifier_mars_arena_of_blood_custom_blocker" ) then
			self:Pinned( iProjectileHandle )
			return			
		end
	end

	local thinkers = Entities:FindAllByClassnameWithin( "npc_dota_thinker", data.location, wall_radius )
	for _,thinker in pairs(thinkers) do
		if thinker:IsPhantomBlocker() then
			self:Pinned( iProjectileHandle )
			return
		end
	end

	local base_loc = GetGroundPosition( data.location, data.unit )
	local search_loc = GetGroundPosition( base_loc + data.direction*wall_radius, data.unit )
	if search_loc.z-base_loc.z>10 and (not GridNav:IsTraversable( search_loc )) then
		self:Pinned( iProjectileHandle )
		return
	end

	if GridNav:IsNearbyTree( data.location, tree_radius, false) then
		self:Pinned( iProjectileHandle )
		return
	end

	local buildings = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), data.location, nil, building_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

	if #buildings>0 then
		self:Pinned( iProjectileHandle )
		return
	end
end

function mars_spear_custom:Pinned( iProjectileHandle )
	local data = self.projectiles[iProjectileHandle]

	local duration = self:GetSpecialValueFor("stun_duration")

	if self:GetCaster():HasModifier("modifier_mars_spear_2") then 
		duration = duration + self.range_stun[self:GetCaster():GetUpgradeStack("modifier_mars_spear_2")]
	end

	local projectile_vision = self:GetSpecialValueFor("spear_vision")

	AddFOWViewer( self:GetCaster():GetTeamNumber(), data.unit:GetOrigin(), projectile_vision, duration, false)

	ProjectileManager:DestroyLinearProjectile( iProjectileHandle )

	if data.modifier and not data.modifier:IsNull() then
		data.modifier:Destroy()

		data.unit:SetOrigin( GetGroundPosition( data.location, data.unit ) )
	end
	local ability = self
	local caster = self:GetCaster()
	local duration_stun = duration*(1 - data.unit:GetStatusResistance()) 

	if self:GetCaster():HasModifier("modifier_mars_spear_5") then 
		data.unit:AddNewModifier(self:GetCaster(), self, "modifier_mars_spear_custom_healing", {duration = self.stun_heal_duration})
	end



	data.unit:AddNewModifier( caster, ability, "modifier_mars_spear_custom_debuff", { duration =  duration_stun} )


	if data.unit:IsValidKill(self:GetCaster()) then 

		if self:GetCaster():GetQuest() == "Mars.Quest_5" then 
			self:GetCaster():UpdateQuest(1)
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mars_spear_custom_str", {})
	end

	self:PlayEffects( iProjectileHandle, duration )

	self.projectiles:Destroy( iProjectileHandle )
end

function mars_spear_custom:PlayEffects( projID, duration )
local data = self.projectiles[projID]
data.unit:EmitSound("Hero_Mars.Spear.Root")

if self:GetCaster():HasModifier("modifier_mars_spear_6") then return end

	local delta = 50
	local location = GetGroundPosition( data.location, data.unit ) + data.direction*delta

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_spear_impact.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, location )
	ParticleManager:SetParticleControl( effect_cast, 1, data.direction*1000 )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )
	ParticleManager:SetParticleControlForward( effect_cast, 0, data.direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end

modifier_mars_spear_custom = class({})

function modifier_mars_spear_custom:IsStunDebuff()
	return true
end

function modifier_mars_spear_custom:IsPurgable()
	return true
end

function modifier_mars_spear_custom:OnCreated( kv )
	self.ability = self:GetAbility()
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_spear_stun", {})
		self.projectile = kv.projectile
		self:GetParent():SetForwardVector( -self:GetAbility().projectiles[kv.projectile].direction )
		self:GetParent():FaceTowards( self.ability.projectiles[self.projectile].init_pos )
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_mars_spear_custom:OnRemoved()
	if not IsServer() then return end
	local parent = self:GetParent()

	Timers:CreateTimer(0.1, function()
		parent:RemoveModifierByName("modifier_mars_spear_stun")
	end)


 

	self:GetParent():InterruptMotionControllers( false )
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

function modifier_mars_spear_custom:UpdateHorizontalMotion( me, dt )
	if not self.ability.projectiles[self.projectile] then
		self:Destroy()
		return
	end
	local data = self.ability.projectiles[self.projectile]
	if not data.active then return end
--if self:GetParent():HasModifier("modifier_mars_spear_custom_debuff") then return end
	self:GetParent():SetOrigin( data.location + data.direction*60 )
end

function modifier_mars_spear_custom:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

modifier_mars_spear_custom_debuff = class({})

function modifier_mars_spear_custom_debuff:IsStunDebuff()
	return true
end

function modifier_mars_spear_custom_debuff:IsPurgable()
	return true
end

function modifier_mars_spear_custom_debuff:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

function modifier_mars_spear_custom_debuff:OnCreated( kv )
	if not IsServer() then return end
	self.projectile = kv.projectile
	self:StartIntervalThink(FrameTime())
end

function modifier_mars_spear_custom_debuff:OnIntervalThink()
if not IsServer() then return end

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_spear_stun", {duration = FrameTime()*2})

end

function modifier_mars_spear_custom_debuff:OnRemoved()
	if not IsServer() then return end
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 120, false )
	local parent = self:GetParent()
	

end

function modifier_mars_spear_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_mars_spear_custom_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_mars_spear_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
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

function modifier_mars_spear_custom_debuff:StatusEffectPriority() return 10 end

modifier_mars_spear_custom_debuff_knockback = class({})

function modifier_mars_spear_custom_debuff_knockback:IsHidden()
	return true
end

function modifier_mars_spear_custom_debuff_knockback:IsPurgable()
	return false
end

function modifier_mars_spear_custom_debuff_knockback:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_mars_spear_custom_debuff_knockback:OnCreated( kv )
	if IsServer() then
		self.distance = kv.distance or 0
		self.height = kv.height or -1
		self.duration = kv.duration or 0
		if kv.direction_x and kv.direction_y then
			self.direction = Vector(kv.direction_x,kv.direction_y,0):Normalized()
		else
			self.direction = -(self:GetParent():GetForwardVector())
		end
		self.tree = kv.tree_destroy_radius or self:GetParent():GetHullRadius()

		if kv.IsStun then self.stun = kv.IsStun==1 else self.stun = false end
		if kv.IsFlail then self.flail = kv.IsFlail==1 else self.flail = true end

		if self.duration == 0 then
			self:Destroy()
			return
		end

		self.parent = self:GetParent()
		self.origin = self.parent:GetOrigin()

		self.hVelocity = self.distance/self.duration

		local half_duration = self.duration/2
		self.gravity = 2*self.height/(half_duration*half_duration)
		self.vVelocity = self.gravity*half_duration

		if self.distance>0 then
			if self:ApplyHorizontalMotionController() == false then 
				self:Destroy()
				return
			end
		end
		if self.height>=0 then
			if self:ApplyVerticalMotionController() == false then 
				self:Destroy()
				return
			end
		end

		if self.flail then
			self:SetStackCount( 1 )
		elseif self.stun then
			self:SetStackCount( 2 )
		end
	else
		self.anim = self:GetStackCount()
		self:SetStackCount( 0 )
	end
end

function modifier_mars_spear_custom_debuff_knockback:OnDestroy( kv )
	if not IsServer() then return end

	if not self.interrupted then
		if self.tree>0 then
			GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree, true )
		end
	end

	if self.EndCallback then
		self.EndCallback( self.interrupted )
	end

	self:GetParent():InterruptMotionControllers( true )
end

function modifier_mars_spear_custom_debuff_knockback:SetEndCallback( func ) 
	self.EndCallback = func
end

function modifier_mars_spear_custom_debuff_knockback:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end

function modifier_mars_spear_custom_debuff_knockback:GetOverrideAnimation( params )
	if self.anim==1 then
		return ACT_DOTA_FLAIL
	elseif self.anim==2 then
		return ACT_DOTA_DISABLED
	end
end

function modifier_mars_spear_custom_debuff_knockback:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.stun,
	}
	return state
end

function modifier_mars_spear_custom_debuff_knockback:UpdateHorizontalMotion( me, dt )
	local parent = self:GetParent()
	local target = self.direction*self.distance*(dt/self.duration)
	parent:SetOrigin( parent:GetOrigin() + target )
end

function modifier_mars_spear_custom_debuff_knockback:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end

function modifier_mars_spear_custom_debuff_knockback:UpdateVerticalMotion( me, dt )
	local time = dt/self.duration
	self.parent:SetOrigin( self.parent:GetOrigin() + Vector( 0, 0, self.vVelocity*dt ) )
	self.vVelocity = self.vVelocity - self.gravity*dt
end

function modifier_mars_spear_custom_debuff_knockback:OnVerticalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end

function modifier_mars_spear_custom_debuff_knockback:GetEffectName()
	if not IsServer() then return end
	if self.stun then
		return "particles/generic_gameplay/generic_stunned.vpcf"
	end
end

function modifier_mars_spear_custom_debuff_knockback:GetEffectAttachType()
	if not IsServer() then return end
	return PATTACH_OVERHEAD_FOLLOW
end






modifier_mars_spear_custom_legendary_tracker = class({})
function modifier_mars_spear_custom_legendary_tracker:IsPurgable() return false end
function modifier_mars_spear_custom_legendary_tracker:OnCreated(table)
if not IsServer() then return end
AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 400, self:GetAbility().double_delay, false)

local particle_cast = "particles/mars_spear_grounded.vpcf"
self.dir = Vector(table.x, table.y, 0)

self.damage = table.damage

direction = self.dir:Normalized()

local abs = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)

	-- Create Particle
local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, abs )
ParticleManager:SetParticleControl( effect_cast, 1, abs )
ParticleManager:SetParticleControlForward( effect_cast, 0, direction )

self:AddParticle( effect_cast, false, false, -1, false, false )

--EmitSoundOnLocationWithCaster(abs, "Hero_Mars.Spear.Root", self:GetCaster())


end


function modifier_mars_spear_custom_legendary_tracker:Activate()
if not IsServer() then return end

self:GetAbility():LaunchSpear(self:GetParent():GetAbsOrigin(), self:GetCaster():GetAbsOrigin(), 0, 0, self.damage)
self:Destroy()
end


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
return self:GetAbility().hit_move[self:GetCaster():GetUpgradeStack("modifier_mars_spear_1")]
end

function modifier_mars_spear_custom_hit_speed:GetModifierHealthRegenPercentage()
return self:GetAbility().hit_heal[self:GetCaster():GetUpgradeStack("modifier_mars_spear_1")]/self:GetAbility().hit_heal_duration
end


function modifier_mars_spear_custom_hit_speed:GetActivityTranslationModifiers()
return "spear_stun"
end


function modifier_mars_spear_custom_hit_speed:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_mars_spear_custom_hit_speed:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_mars_spear_custom_hit_speed:OnCreated(table)
if not IsServer() then return end

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle( effect_cast, false, false, -1, false, false )
end









modifier_mars_spear_custom_return = class({})
function modifier_mars_spear_custom_return:IsHidden() return false end
function modifier_mars_spear_custom_return:IsPurgable() return true end
function modifier_mars_spear_custom_return:GetTexture() return "buffs/spear_return" end
function modifier_mars_spear_custom_return:OnCreated(table)
if not IsServer() then return end

local ability = self:GetParent():FindAbilityByName("mars_spear_custom")
if ability and not ability:IsHidden() then 
	self:GetParent():SwapAbilities(ability:GetName(), "mars_spear_custom_return", false, true)
else 
	self:Destroy()
	return
end

self.thinker = EntIndexToHScript(table.thinker)

end

function modifier_mars_spear_custom_return:OnDestroy()
if not IsServer() then return end

local ability = self:GetParent():FindAbilityByName("mars_spear_custom")
if ability and ability:IsHidden() then 
	self:GetParent():SwapAbilities(ability:GetName(), "mars_spear_custom_return", true, false)
end

if (self:GetAbility().double_delay - self:GetElapsedTime() > 0.1) and self.thinker and not self.thinker:IsNull() then 
	self.thinker:FindModifierByName("modifier_mars_spear_custom_legendary_tracker"):Activate()
end

end




modifier_mars_spear_custom_str = class({})
function modifier_mars_spear_custom_str:IsHidden() return not self:GetParent():HasModifier("modifier_mars_spear_4") end
function modifier_mars_spear_custom_str:IsPurgable() return false end
function modifier_mars_spear_custom_str:RemoveOnDeath() return false end
function modifier_mars_spear_custom_str:GetTexture() return "buffs/spear_str" end
function modifier_mars_spear_custom_str:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.str_bonus  = 0
self.init = false

end
function modifier_mars_spear_custom_str:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().stun_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().stun_max then 
	local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
	self:GetCaster():EmitSound("BS.Thirst_legendary_active")

end

end





function modifier_mars_spear_custom_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end


function modifier_mars_spear_custom_str:GetModifierSpellAmplify_Percentage()
if not self:GetParent():HasModifier("modifier_mars_spear_4") then return end
if self:GetStackCount() < self:GetAbility().stun_max then return end

return self:GetAbility().stun_max_damage[self:GetCaster():GetUpgradeStack("modifier_mars_spear_4")]
end


function modifier_mars_spear_custom_str:OnTooltip()
return self:GetStackCount()
end

function modifier_mars_spear_custom_str:OnTooltip2()
if not self:GetParent():HasModifier("modifier_mars_spear_4") then return end
return self:GetStackCount()*self:GetAbility().stun_damage[self:GetCaster():GetUpgradeStack("modifier_mars_spear_4")]
end


modifier_mars_spear_custom_trail_thinker = class({})
function modifier_mars_spear_custom_trail_thinker:IsHidden() return true end
function modifier_mars_spear_custom_trail_thinker:IsPurgable() return false end
function modifier_mars_spear_custom_trail_thinker:OnCreated(table)
if not IsServer() then return end
self.radius = self:GetAbility():GetSpecialValueFor("shard_trail_radius")
self.duration = self:GetAbility():GetSpecialValueFor("shard_trail_duration")
self.interval = self:GetAbility():GetSpecialValueFor("shard_interval")
self.duration_fire = self:GetAbility():GetSpecialValueFor("shard_debuff_linger_duration")
self.damage = table.damage

self.dir = Vector(table.x, table.y, z)

self.start_pos = self:GetParent():GetAbsOrigin() - self.dir*self.radius/2
self.end_pos = self:GetParent():GetAbsOrigin() + self.dir*self.radius/2

self.pfx = ParticleManager:CreateParticle("particles/mars_trail.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControl(self.pfx, 0, self.start_pos)
ParticleManager:SetParticleControl(self.pfx, 1, self.end_pos)
ParticleManager:SetParticleControl(self.pfx, 2, Vector(self.duration, 0, 0))
ParticleManager:SetParticleControl(self.pfx, 3, Vector(self.radius, 0, 0))
self:AddParticle( self.pfx, false, false, -1, false, false )

self:StartIntervalThink(self.interval)
end

function modifier_mars_spear_custom_trail_thinker:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(), self.start_pos, self.end_pos, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)
for _,enemy in pairs(enemies) do
	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_spear_custom_trail_burn", {damage = self.damage, duration = self.duration_fire})
end


end




modifier_mars_spear_custom_trail_burn = class({})
function modifier_mars_spear_custom_trail_burn:IsHidden() return false end
function modifier_mars_spear_custom_trail_burn:IsPurgable() return false end
function modifier_mars_spear_custom_trail_burn:OnCreated(table)
self.interval = self:GetAbility():GetSpecialValueFor("shard_interval")
self.slow = self:GetAbility():GetSpecialValueFor("shard_move_slow_pct")
if not IsServer() then return end

self.damage = self:GetAbility():GetSpecialValueFor("shard_dps")*self.interval
self:StartIntervalThink(self.interval)
end


function modifier_mars_spear_custom_trail_burn:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_mars_spear_custom_trail_burn:OnTooltip()
--return self.damage/self.interval
end

function modifier_mars_spear_custom_trail_burn:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_mars_spear_custom_trail_burn:OnIntervalThink()
if not IsServer() then return end
ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)

end

function modifier_mars_spear_custom_trail_burn:GetEffectName()
return "particles/roshan_meteor_burn_.vpcf"
end


modifier_mars_spear_custom_incoming = class({})
function modifier_mars_spear_custom_incoming:IsHidden() return false end
function modifier_mars_spear_custom_incoming:IsPurgable() return true end
function modifier_mars_spear_custom_incoming:GetTexture() return "buffs/odds_mark" end

function modifier_mars_spear_custom_incoming:OnCreated(table)
if not IsServer() then return end

self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_mars_spear_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_mars_spear_custom_incoming:GetModifierIncomingDamage_Percentage() 
	return self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_mars_spear_3")]
end





modifier_mars_spear_custom_healing = class({})
function modifier_mars_spear_custom_healing:IsHidden() return false end
function modifier_mars_spear_custom_healing:IsPurgable() return false end
function modifier_mars_spear_custom_healing:GetTexture() return "buffs/blast_heal" end
function modifier_mars_spear_custom_healing:OnCreated(table)
self.heal = self:GetAbility().stun_heal
end

function modifier_mars_spear_custom_healing:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
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

function modifier_mars_spear_custom_healing:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end