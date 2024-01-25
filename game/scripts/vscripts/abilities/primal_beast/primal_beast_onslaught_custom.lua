LinkLuaModifier( "modifier_primal_beast_onslaught_custom_cast", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_tracker", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_speed", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_knockback", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_slow", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_thinker", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_legendary_target", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_stacks", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_absorb", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_damage", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_onslaught_custom_stun_slow", "abilities/primal_beast/primal_beast_onslaught_custom", LUA_MODIFIER_MOTION_NONE )


primal_beast_onslaught_custom = class({})

primal_beast_onslaught_custom.cd = {-2,-3,-4}


primal_beast_onslaught_custom.damage_inc = {8, 12, 16}
primal_beast_onslaught_custom.damage_duration = 5

primal_beast_onslaught_custom.stun_slow = {-20, -30, -40} 
primal_beast_onslaught_custom.stun_inc = {0.2, 0.3, 0.4}
primal_beast_onslaught_custom.stun_duration = 3

primal_beast_onslaught_custom.knockback_duration = 0.4
primal_beast_onslaught_custom.knockback_distance = 100
primal_beast_onslaught_custom.knockback_range = 400
primal_beast_onslaught_custom.knockback_slow = -80
primal_beast_onslaught_custom.knockback_slow_duration = 2


primal_beast_onslaught_custom.legendary_max = 4
primal_beast_onslaught_custom.legendary_damage = 0.5
primal_beast_onslaught_custom.legendary_heal = 0.5
primal_beast_onslaught_custom.legendary_range = 100
primal_beast_onslaught_custom.finish_radius = 400
primal_beast_onslaught_custom.finish_interval = 1

primal_beast_onslaught_custom.cast_time = -0.4
primal_beast_onslaught_custom.cast_cd = 0.3
primal_beast_onslaught_custom.cast_duration = 3



function primal_beast_onslaught_custom:Precache(context)
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_attack_blur_left_to_right.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_attack_blur_right_to_left.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primalbeast_footstep_dust_impact.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_attack_fist_blur_left_to_right.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_attack_fist_blur_right_to_left.vpcf', context )


PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf', context )
PrecacheResource( "particle", 'particles/primal_knockback.vpcf', context )
PrecacheResource( "particle", 'particles/beast_charge.vpcf', context )
PrecacheResource( "particle", 'particles/beast_haste.vpcf', context )
PrecacheResource( "particle", 'particles/lina_attack_slow.vpcf', context )
PrecacheResource( "particle", "particles/pangolier/linken_active.vpcf", context )

end



function primal_beast_onslaught_custom:GetIntrinsicModifierName()
return "modifier_primal_beast_onslaught_custom_tracker"
end

function primal_beast_onslaught_custom:GetCastRange(vLocation, hTarget)
if IsClient() then 
 	return self:GetSpecialValueFor("max_distance")
end

return 999999
end


function primal_beast_onslaught_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_1") then 
  upgrade_cooldown = self.cd[self:GetCaster():GetUpgradeStack("modifier_primal_beast_onslaught_1")]
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end



function primal_beast_onslaught_custom:GetDamage()
if not IsServer() then return end 

local damage = self:GetSpecialValueFor("knockback_damage")

local mod = self:GetCaster():FindModifierByName("modifier_primal_beast_onslaught_custom_stacks")

if mod and self:GetCaster():HasModifier("modifier_primal_beast_onslaught_4") then 
	damage = damage + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_primal_beast_onslaught_4", "damage")*self:GetCaster():GetAverageTrueAttackDamage(nil)/100
end 


return damage
end 



function primal_beast_onslaught_custom:GetChargeTime()
if not IsServer() then return end 


local duration = self:GetSpecialValueFor( "chargeup_time" )

if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_6") then 
	duration = duration + self.cast_time 
end 	

return duration
end



function primal_beast_onslaught_custom:KnockTarget(enemy, knock)
if not IsServer() then return end 

local height = 50
local radius = self:GetSpecialValueFor( "knockback_radius" )
local distance = self:GetSpecialValueFor( "knockback_distance" )
local duration = self:GetSpecialValueFor( "knockback_duration" )
local stun = self:GetSpecialValueFor( "stun_duration" )*(1 - enemy:GetStatusResistance())

if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_3") then
	stun = (self:GetSpecialValueFor( "stun_duration" ) + self.stun_inc[self:GetCaster():GetUpgradeStack("modifier_primal_beast_onslaught_3")])*(1 - enemy:GetStatusResistance())

	enemy:AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_onslaught_custom_stun_slow", { duration = stun + self.stun_duration } )
end 

enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = stun } )



if knock and knock == true then 
	distance = 20
end


if not (enemy:IsCurrentlyHorizontalMotionControlled() or enemy:IsCurrentlyVerticalMotionControlled()) then
	local direction = enemy:GetOrigin()-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

  local knockbackProperties =
  {
      center_x = self:GetCaster():GetOrigin().x,
      center_y = self:GetCaster():GetOrigin().y,
      center_z = self:GetCaster():GetOrigin().z,
      duration = duration,
      knockback_duration = duration,
      knockback_distance = distance,
      knockback_height = height
  }
  enemy:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
end

end 


function primal_beast_onslaught_custom:OnSpellStart()
if not IsServer() then return end

local duration = self:GetChargeTime()


local point = self:GetCursorPosition()

local dir = point - self:GetCaster():GetAbsOrigin()

self:GetCaster():FaceTowards(point)
self:GetCaster():SetForwardVector(dir:Normalized())

local release_ability = self:GetCaster():FindAbilityByName( "primal_beast_onslaught_release_custom" )

if release_ability then
	release_ability:UseResources( false, false, false, true )
end

self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_onslaught_custom_cast", { duration = duration } )



if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_5") then 

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_onslaught_custom_absorb", {})

	local nFXIndex = ParticleManager:CreateParticle( "particles/primal_knockback.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.knockback_range, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	self:GetCaster():EmitSound("PBeast.Onslaught_knock_caster")

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.knockback_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	for _,enemy in pairs(enemies) do 

	  enemy:EmitSound("PBeast.Onslaught_knock")
	  enemy:AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_onslaught_custom_knockback", {duration = self.knockback_duration, x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
	end
end


end

function primal_beast_onslaught_custom:OnChargeFinish( interrupt, max )
if not IsServer() then return end


local max_duration = self:GetChargeTime()
local max_distance = self:GetSpecialValueFor( "max_distance" ) 


local speed = self:GetSpecialValueFor( "charge_speed" )
local charge_duration = max_duration


local mod = self:GetCaster():FindModifierByName( "modifier_primal_beast_onslaught_custom_cast" )
if mod then
	if mod.effect_cast then
		ParticleManager:DestroyParticle(mod.effect_cast, true)
	end

	charge_duration = mod:GetElapsedTime()
	mod.charge_finish = true
	mod:Destroy()
end

local k = charge_duration / max_duration

local charge = math.floor(charge_duration/( max_duration/self.legendary_max) )


if k == 1 then 
	local ult = self:GetCaster():FindAbilityByName("primal_beast_pulverize_custom")
	if ult and self:GetCaster():HasModifier("modifier_primal_beast_pulverize_7") then 
		ult:AddLegendaryStack()
	end 
end


if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_6") then 

	if max == 1 or max == true then

    local particle = ParticleManager:CreateParticle("particles/pangolier/buckle_refresh.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particle)


    self:GetCaster():EmitSound("Hero_Rattletrap.Overclock.Cast")
		local cd = self:GetCooldownTimeRemaining()
		self:EndCooldown()
		self:StartCooldown(cd - cd*self.cast_cd)
	end

end


local distance = max_distance * k

local duration = distance / speed

if interrupt then
	self:GetCaster():RemoveModifierByName("modifier_primal_beast_onslaught_custom_absorb")
	return
end 

self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_onslaught_custom", {charge = charge, duration = duration, max = max } )

self:GetCaster():EmitSound("Hero_PrimalBeast.Onslaught")

end















-- Абилка внезапного побега

primal_beast_onslaught_release_custom = class({})

function primal_beast_onslaught_release_custom:OnSpellStart()
	local ability = self:GetCaster():FindAbilityByName("primal_beast_onslaught_custom")
	if ability then
		ability:OnChargeFinish( false, false )
	end
end











modifier_primal_beast_onslaught_custom_cast = class({})

function modifier_primal_beast_onslaught_custom_cast:IsPurgable()
	return false
end

function modifier_primal_beast_onslaught_custom_cast:OnCreated( kv )
self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
self.turn_speed = self:GetAbility():GetSpecialValueFor( "turn_rate" )
self.max_time = self:GetAbility():GetChargeTime()

if not IsServer() then return end


self:GetCaster():SwapAbilities( "primal_beast_onslaught_custom", "primal_beast_onslaught_release_custom", false, true )

self.anim_return = 0
self.origin = self:GetParent():GetOrigin()
self.target_angle = self:GetParent():GetAnglesAsVector().y
self.current_angle = self.target_angle
self.face_target = true
self.charge_finish = false
self.time = self:GetAbility():GetSpecialValueFor("max_distance") / self:GetAbility():GetSpecialValueFor( "charge_speed" ) 

self:OnIntervalThink()

self:StartIntervalThink( FrameTime() )

self:PlayEffects1()
self:PlayEffects2()
end

function modifier_primal_beast_onslaught_custom_cast:OnDestroy()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_7") then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'beast_charge_change',  {hide = 1, max_time = self.max_time, time = self:GetRemainingTime()})
end 

self:GetCaster():SwapAbilities( "primal_beast_onslaught_custom", "primal_beast_onslaught_release_custom", true ,  false)

self:GetParent():EmitSound("Hero_PrimalBeast.Onslaught.Channel")
self:GetParent():RemoveGesture(ACT_DOTA_CAST_ABILITY_2)

if self.charge_finish == false then 
	self:GetAbility():OnChargeFinish( false, self:GetRemainingTime() <= 0.05 )

end 

end

function modifier_primal_beast_onslaught_custom_cast:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_DISABLE_TURNING
	}

	return funcs
end


function modifier_primal_beast_onslaught_custom_cast:GetModifierDisableTurning()
 return 1
end


function modifier_primal_beast_onslaught_custom_cast:OnOrder( params )
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
		self:GetAbility():OnChargeFinish( false, false )
	end	
end

function modifier_primal_beast_onslaught_custom_cast:SetDirection( location )
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_primal_beast_onslaught_custom_cast:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_primal_beast_onslaught_custom_cast:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}

	if self.target then 
		state = 
		{
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
			[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
		}
	end

	return state
end

function modifier_primal_beast_onslaught_custom_cast:OnIntervalThink()
if IsServer() then
	self.anim_return = self.anim_return + FrameTime()
	if self.anim_return >= 1 then
		self.anim_return = 0
		self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)
	end

	if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_7") then 
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'beast_charge_change',  {hide = 0, max_time = self.max_time, time = self:GetRemainingTime()})
	end

end

if self.target and self.target:IsAlive() then 
	self:SetDirection(self.target:GetAbsOrigin())
end

	--self:GetParent():IsCurrentlyHorizontalMotionControlled() or self:GetParent():IsCurrentlyVerticalMotionControlled()

if self:GetParent():IsRooted() or self:GetParent():IsStunned() or self:GetParent():IsHexed()  then

	self:GetAbility():OnChargeFinish( true,  false )
end

self:TurnLogic( FrameTime() )
self:SetEffects()
end

function modifier_primal_beast_onslaught_custom_cast:TurnLogic( dt )
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

function modifier_primal_beast_onslaught_custom_cast:PlayEffects1()
	self.effect_cast = ParticleManager:CreateParticleForPlayer( "particles/beast_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetPlayerOwner() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	self:AddParticle( self.effect_cast, false, false, -1, false, false )
	self:SetEffects()
end

function modifier_primal_beast_onslaught_custom_cast:SetEffects()
if not self.effect_cast then return end
	local time = self:GetElapsedTime()

	local k =  time/self.max_time

	local speed_time = k*self.time
	local target_pos = self.origin + self:GetParent():GetForwardVector() * self.speed * speed_time


	ParticleManager:SetParticleControl( self.effect_cast, 1, target_pos )
end

function modifier_primal_beast_onslaught_custom_cast:PlayEffects2()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false )
	self:GetParent():EmitSound("Hero_PrimalBeast.Onslaught.Channel")
end



























modifier_primal_beast_onslaught_custom = class({})

function modifier_primal_beast_onslaught_custom:IsPurgable()
	return false
end


function modifier_primal_beast_onslaught_custom:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end


function modifier_primal_beast_onslaught_custom:OnCreated( kv )
self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
self.turn_speed = self:GetAbility():GetSpecialValueFor( "turn_rate" )
self.radius = self:GetAbility():GetSpecialValueFor( "knockback_radius" )
self.damage = self:GetAbility():GetDamage()

self.tree_radius = 100

if not IsServer() then return end


self.max = kv.max 

self.charge = kv.charge


self.charge = math.max(0, self.charge)
self.charge = math.min(self:GetAbility().legendary_max, self.charge)


self.target_angle = self:GetParent():GetAnglesAsVector().y
self.current_angle = self.target_angle
self.face_target = true

self.knockback_units = {}
self.knockback_units[self:GetParent()] = true

if not self:ApplyHorizontalMotionController() then
	self:Destroy()
	return
end


self.damageTable = { attacker = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() }
end




function modifier_primal_beast_onslaught_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

	}

	return funcs
end

function modifier_primal_beast_onslaught_custom:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	if params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetDirection( params.new_pos )
	elseif
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
		params.order_type==DOTA_UNIT_ORDER_CAST_TARGET or
		params.order_type==DOTA_UNIT_ORDER_CAST_POSITION or
		params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION
	then
		self:Destroy()
	end	
end

function modifier_primal_beast_onslaught_custom:GetModifierDisableTurning()
	return 1
end

function modifier_primal_beast_onslaught_custom:SetDirection( location )
	local dir = ((location-self:GetParent():GetOrigin())*Vector(1,1,0)):Normalized()
	self.target_angle = VectorToAngles( dir ).y
	self.face_target = false
end

function modifier_primal_beast_onslaught_custom:GetOverrideAnimation()
	return ACT_DOTA_RUN
end

function modifier_primal_beast_onslaught_custom:GetActivityTranslationModifiers()
	return "onslaught_movement"
end


function modifier_primal_beast_onslaught_custom:TurnLogic( dt )
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

function modifier_primal_beast_onslaught_custom:HitLogic()
GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree_radius, false )
local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

for unit,index in pairs(self.knockback_units) do 
	if unit and not unit:IsNull() and unit:HasModifier("modifier_primal_beast_onslaught_custom_legendary_target") then 
		local point = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*self:GetAbility().legendary_range

		unit:SetAbsOrigin(point)
	end 
end  

for _,unit in pairs(units) do
	if not self.knockback_units[unit] then
		self.knockback_units[unit] = true

		self.damageTable.victim = unit

		if unit:IsValidKill(self:GetCaster()) and self.max == 1 then 
			
			if self:GetCaster():GetQuest() == "Beast.Quest_5"  then 
				self:GetCaster():UpdateQuest(1)
			end 

			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_stacks", {})

		end


		if self.charge > 0 and self:GetCaster():HasModifier("modifier_primal_beast_onslaught_2") then 
			unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_damage", {duration = self:GetAbility().damage_duration, charge = self.charge})
		end 

		ApplyDamage(self.damageTable)

		if unit:IsHero() and self:GetParent():HasModifier("modifier_primal_beast_onslaught_7") then 
			unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_legendary_target", {duration = self:GetRemainingTime() + FrameTime()*3})
		else 
			self:GetAbility():KnockTarget(unit)
		end 

		self:PlayEffects( unit, self.radius )
	end
end

end

function modifier_primal_beast_onslaught_custom:UpdateHorizontalMotion( me, dt )
	if self:GetParent():IsRooted() then
		return
	end



	self:HitLogic()
	self:TurnLogic( dt )
	local nextpos = me:GetOrigin() + me:GetForwardVector() * self.speed * dt
	me:SetOrigin(nextpos)

end

function modifier_primal_beast_onslaught_custom:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_primal_beast_onslaught_custom:GetEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
end

function modifier_primal_beast_onslaught_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_primal_beast_onslaught_custom:PlayEffects( target, radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	target:EmitSound("Hero_PrimalBeast.Onslaught.Hit")
end



function modifier_primal_beast_onslaught_custom:OnDestroy()
if not IsServer() then return end

self:GetCaster():RemoveModifierByName("modifier_primal_beast_onslaught_custom_absorb")

self:GetParent():RemoveHorizontalMotionController(self)
FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetOrigin(), false )

if self:GetParent():HasModifier("modifier_primal_beast_onslaught_7") then 


	CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_thinker", {duration = self.charge}, self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*self:GetAbility().legendary_range, self:GetCaster():GetTeamNumber(), false)
end


for unit,index in pairs(self.knockback_units) do 
	if unit and not unit:IsNull() and unit:HasModifier("modifier_primal_beast_onslaught_custom_legendary_target") then 
		unit:RemoveModifierByName("modifier_primal_beast_onslaught_custom_legendary_target")
	end 
end  



if self:GetCaster():HasModifier("modifier_primal_beast_onslaught_6") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_speed", {duration = self:GetAbility().cast_duration})
end

end



modifier_primal_beast_onslaught_custom_thinker = class({})

function modifier_primal_beast_onslaught_custom_thinker:IsHidden() return true end

function modifier_primal_beast_onslaught_custom_thinker:IsPurgable() return false end

function modifier_primal_beast_onslaught_custom_thinker:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(self:GetAbility().finish_interval)

end





function modifier_primal_beast_onslaught_custom_thinker:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end

local radius = self:GetAbility().finish_radius
local damage = self:GetAbility():GetDamage()*self:GetAbility().legendary_damage

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_pulverize_hit.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
ParticleManager:DestroyParticle( effect_cast, false )
ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_PrimalBeast.Pulverize.Impact", self:GetCaster() )

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, }

for _,enemy in pairs(enemies) do 
	damageTable.victim = enemy
	ApplyDamage(damageTable)
	SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, enemy, damage, nil )
end

if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= radius then 
	self:GetCaster():GenericHeal(damage*self:GetAbility().legendary_heal, self:GetAbility())
end 

  
end





modifier_primal_beast_onslaught_custom_speed = class({})
function modifier_primal_beast_onslaught_custom_speed:IsHidden() return false end
function modifier_primal_beast_onslaught_custom_speed:IsPurgable() return false end
function modifier_primal_beast_onslaught_custom_speed:GetTexture() return "buffs/onslaught_speed" end
function modifier_primal_beast_onslaught_custom_speed:DeclareFunctions()
return
{
	--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_primal_beast_onslaught_custom_speed:GetEffectName()
return "particles/beast_haste.vpcf"
end

function modifier_primal_beast_onslaught_custom_speed:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end 




modifier_primal_beast_onslaught_custom_knockback = class({})

function modifier_primal_beast_onslaught_custom_knockback:IsHidden() return true end

function modifier_primal_beast_onslaught_custom_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.knockback_duration

  self.knockback_distance   = math.max((self.ability.knockback_distance + self.ability.knockback_range)  - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(),  self:GetAbility().knockback_distance)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_primal_beast_onslaught_custom_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_primal_beast_onslaught_custom_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_primal_beast_onslaught_custom_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_primal_beast_onslaught_custom_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_primal_beast_onslaught_custom_slow", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().knockback_slow_duration})
end





modifier_primal_beast_onslaught_custom_slow = class({})
function modifier_primal_beast_onslaught_custom_slow:IsHidden() return false end
function modifier_primal_beast_onslaught_custom_slow:IsPurgable() return true end
function modifier_primal_beast_onslaught_custom_slow:GetTexture() return "buffs/trample_silence" end
function modifier_primal_beast_onslaught_custom_slow:GetEffectName()
 return "particles/lina_attack_slow.vpcf" end



function modifier_primal_beast_onslaught_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_primal_beast_onslaught_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().knockback_slow
end





modifier_primal_beast_onslaught_custom_stun_slow = class({})
function modifier_primal_beast_onslaught_custom_stun_slow:IsHidden() return false end
function modifier_primal_beast_onslaught_custom_stun_slow:IsPurgable() return true end
function modifier_primal_beast_onslaught_custom_stun_slow:GetTexture() return "buffs/trample_silence" end
function modifier_primal_beast_onslaught_custom_stun_slow:GetEffectName()
 return "particles/lina_attack_slow.vpcf" end



function modifier_primal_beast_onslaught_custom_stun_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_primal_beast_onslaught_custom_stun_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().stun_slow[self:GetCaster():GetUpgradeStack("modifier_primal_beast_onslaught_3")]
end






modifier_primal_beast_onslaught_custom_damage = class({})
function modifier_primal_beast_onslaught_custom_damage:IsHidden() return false end
function modifier_primal_beast_onslaught_custom_damage:IsPurgable() return false end
function modifier_primal_beast_onslaught_custom_damage:GetTexture() return "buffs/moment_armor" end
function modifier_primal_beast_onslaught_custom_damage:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(table.charge)

if self:GetStackCount() >= self:GetAbility().legendary_max then 
	self:GetParent():EmitSound("DOTA_Item.MedallionOfCourage.Activate")
end 

self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_primal_beast_onslaught_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end




function modifier_primal_beast_onslaught_custom_damage:GetModifierIncomingDamage_Percentage()
return self:GetStackCount()*(self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_primal_beast_onslaught_2")]/self:GetAbility().legendary_max)
end











modifier_primal_beast_onslaught_custom_legendary_target = class({})
function modifier_primal_beast_onslaught_custom_legendary_target:IsHidden() return true end 
function modifier_primal_beast_onslaught_custom_legendary_target:IsPurgable() return false end
function modifier_primal_beast_onslaught_custom_legendary_target:OnCreated(table)
if not IsServer() then return end 

self.caster = self:GetCaster()

self:GetParent():FaceTowards(self.caster:GetAbsOrigin())


end 





function modifier_primal_beast_onslaught_custom_legendary_target:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}

end 


function modifier_primal_beast_onslaught_custom_legendary_target:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_primal_beast_onslaught_custom_legendary_target:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end


function modifier_primal_beast_onslaught_custom_legendary_target:OnDestroy()
if not IsServer() then return end 

if self:GetParent():IsDebuffImmune() or not self.deal_damage then 
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
end

self:GetAbility():KnockTarget(self:GetParent(), true)
end 



modifier_primal_beast_onslaught_custom_stacks = class({})
function modifier_primal_beast_onslaught_custom_stacks:IsHidden() return not self:GetCaster():HasModifier("modifier_primal_beast_onslaught_4") end
function modifier_primal_beast_onslaught_custom_stacks:IsPurgable() return false end
function modifier_primal_beast_onslaught_custom_stacks:RemoveOnDeath() return false end
function modifier_primal_beast_onslaught_custom_stacks:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_primal_beast_onslaught_4", "max", true)

if not IsServer() then return end 

self:SetStackCount(1)
end 

function modifier_primal_beast_onslaught_custom_stacks:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

  local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_peffect)
  self:GetCaster():EmitSound("BS.Thirst_legendary_active")

end 

end 


function modifier_primal_beast_onslaught_custom_stacks:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end 

function modifier_primal_beast_onslaught_custom_stacks:GetModifierSpellAmplify_Percentage()
if not self:GetCaster():HasModifier("modifier_primal_beast_onslaught_4") then return end 
if self:GetStackCount() < self.max then return end 

return self:GetCaster():GetTalentValue("modifier_primal_beast_onslaught_4", "spell")
end 

function modifier_primal_beast_onslaught_custom_stacks:OnTooltip()
return self:GetStackCount()
end 


function modifier_primal_beast_onslaught_custom_stacks:OnTooltip2()
if not self:GetCaster():HasModifier("modifier_primal_beast_onslaught_4") then return end 

return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_primal_beast_onslaught_4", "damage")
end 





modifier_primal_beast_onslaught_custom_absorb = class({})
function modifier_primal_beast_onslaught_custom_absorb:IsHidden() return true end
function modifier_primal_beast_onslaught_custom_absorb:IsPurgable() return false end
function modifier_primal_beast_onslaught_custom_absorb:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/pangolier/linken_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)


end



function modifier_primal_beast_onslaught_custom_absorb:DeclareFunctions()
return
{
MODIFIER_PROPERTY_ABSORB_SPELL,
}
end

function modifier_primal_beast_onslaught_custom_absorb:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

local particle = ParticleManager:CreateParticle("particles/pangolier/linken_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

self:Destroy()

return 1 
end


