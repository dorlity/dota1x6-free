LinkLuaModifier( "modifier_marci_companion_run_custom", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_marci_companion_run_custom_legendary", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_marci_companion_run_custom_buff", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_legendary_second", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_marci", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_marci_companion_run_custom_speed", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_after_cd", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_root", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_attacks", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_hits", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_no_root", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_resist", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_resist_tracker", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_companion_run_custom_tracker", "abilities/marci/marci_companion_run_custom", LUA_MODIFIER_MOTION_NONE )



marci_companion_run_custom = class({})

marci_companion_run_custom.legendary_damage = 0.3
marci_companion_run_custom.legendary_duration = 6

marci_companion_run_custom.cd_inc = {-1, -1.5, -2}

marci_companion_run_custom.speed_bonus = {10,15,20}
marci_companion_run_custom.speed_bonus_duration = 5
marci_companion_run_custom.speed_range = {100, 150, 200}

marci_companion_run_custom.bkb_stun = 0.3
marci_companion_run_custom.bkb_damage = 0.5


marci_companion_run_custom.hits_count = {2,3,4}
marci_companion_run_custom.hits_interval = 0.15
marci_companion_run_custom.hits_damage = 30

marci_companion_run_custom.resist_duration = 6
marci_companion_run_custom.resist_damage = -20
marci_companion_run_custom.resist_heal = 3
marci_companion_run_custom.resist_radius = 250






function marci_companion_run_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_charge_projectile.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_bounce.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_landing_zone.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_snapfire_slow.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf', context )
PrecacheResource( "particle", "particles/lina_timer.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net.vpcf", context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_attack.vpcf', context )
PrecacheResource( "particle", 'particles/marci_field.vpcf', context )

end


function marci_companion_run_custom:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_marci_rebound_5") then 
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
  return DOTA_UNIT_TARGET_FLAG_NONE
end

end



function marci_companion_run_custom:GetIntrinsicModifierName()
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

function marci_companion_run_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_marci_rebound_1") then 
  upgrade = self.speed_range[self:GetCaster():GetUpgradeStack("modifier_marci_rebound_1")]
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function marci_companion_run_custom:GetCustomCastErrorTarget( hTarget )
	if self:GetCaster() == hTarget then
		return "#dota_hud_error_cant_cast_on_self"
	end

	return ""
end

function marci_companion_run_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_marci_rebound_2") then  
	upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_marci_rebound_2")]
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end

function marci_companion_run_custom:GetAOERadius()
if self:GetCaster():HasModifier("modifier_marci_rebound_7") then
	return self:GetSpecialValueFor("landing_radius")
end

end


function marci_companion_run_custom:DealDamage()
if not IsServer() then return end

local damage = self:GetSpecialValueFor("impact_damage")
local radius = self:GetSpecialValueFor("landing_radius")

local stun = self:GetSpecialValueFor("stun_duration")

if self:GetCaster():HasModifier("modifier_marci_rebound_5") then 
	stun = stun + self.bkb_stun
	damage = damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self.bkb_damage
end

if self:GetCaster():HasModifier("modifier_marci_rebound_4") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_marci_companion_run_custom_attacks", {duration = self:GetCaster():GetTalentValue("modifier_marci_rebound_4", "duration")})
end

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END,1)

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, }
		
for _,enemy in pairs(enemies) do
	damageTable.victim = enemy
	ApplyDamage(damageTable)

	if enemy:IsRealHero() and self:GetCaster():GetQuest() == "Marci.Quest_6" then 
		self:GetCaster():UpdateQuest(1)
	end

	enemy:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_marci_rebound_5")), "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*stun})
end


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 9, Vector(radius, radius, radius) )
ParticleManager:SetParticleControl( effect_cast, 10, self:GetCaster():GetAbsOrigin() )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex( effect_cast )
EmitSoundOnLocationWithCaster( self:GetCaster():GetAbsOrigin(), "Hero_Marci.Rebound.Impact", self:GetCaster() )

if self:GetCaster():HasModifier("modifier_marci_rebound_1") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_marci_companion_run_custom_speed", {duration = self.speed_bonus_duration})
end


if self:GetCaster():HasModifier("modifier_marci_rebound_6") then 
	CreateModifierThinker(self:GetCaster(), self, "modifier_marci_companion_run_custom_resist_tracker", {duration = self.resist_duration, radius = self.resist_radius}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end	

if self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_marci_unleash_custom") then
	local ability = self:GetCaster():FindAbilityByName("marci_unleash_custom")
	ability:Pulse(self:GetCaster():GetAbsOrigin(), nil)
end


end



function marci_companion_run_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_marci_rebound_7") then
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES 
end


function marci_companion_run_custom:OnVectorCastStart(vStartLocation, vDirection)

local caster = self:GetCaster()
local target = self.targetcast
local speed = self:GetSpecialValueFor( "move_speed" )
local info = { Target = target, Source = caster, Ability = self, iMoveSpeed = speed, bDodgeable = false, }
local proj = ProjectileManager:CreateTrackingProjectile(info)

if self:GetCaster():HasModifier("modifier_marci_rebound_7") then

		caster:AddNewModifier(caster, self, "modifier_marci_companion_run_custom_legendary_second", {target = target:entindex(), duration = self.legendary_duration})

		self.modifier = caster:AddNewModifier( caster, self, "modifier_marci_companion_run_custom_legendary", { proj = tostring(proj), target = target:entindex() } )
		

	else 

		local point = self:GetVector2Position()
		local point_check = self:GetTargetPositionCheck()
		local jump_heh = false
		local sravnenie = ((point_check-point):Length2D())
		sravnenie = math.abs(sravnenie)

		if sravnenie<= 50 then
			jump_heh = true
		end
		self.modifier = caster:AddNewModifier( caster, self, "modifier_marci_companion_run_custom", { proj = tostring(proj), target = target:entindex(), point_x = point.x, point_y = point.y, point_z = point.z, jump_heh = jump_heh } )
	end

end

function marci_companion_run_custom:OnSpellStart()
if not self:GetCaster():HasModifier("modifier_marci_rebound_7") then return end



local target = self:GetCursorTarget()
local caster = self:GetCaster()

local speed = self:GetSpecialValueFor( "move_speed" )
local info = { Target = target, Source = caster, Ability = self, iMoveSpeed = speed, bDodgeable = false, }
local proj = ProjectileManager:CreateTrackingProjectile(info)
self.modifier = caster:AddNewModifier( caster, self, "modifier_marci_companion_run_custom_legendary", { proj = tostring(proj), target = target:entindex() } )

caster:AddNewModifier(caster, self, "modifier_marci_companion_run_custom_legendary_second", {target = target:entindex(), duration = self:GetCaster():GetTalentValue("modifier_marci_rebound_7", "duration")})

end


function marci_companion_run_custom:OnProjectileHit( target, location )
	if not self.modifier:IsNull() then
		if not target then
			self.modifier.interrupted = true
		end
		self.modifier:Destroy()
	end
end

-- модификатор полета до цели

modifier_marci_companion_run_custom = class({})

function modifier_marci_companion_run_custom:IsHidden()
	return true
end

function modifier_marci_companion_run_custom:IsDebuff()
	return false
end

function modifier_marci_companion_run_custom:IsPurgable()
	return false
end

function modifier_marci_companion_run_custom:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.duration = 0.5
	self.height = self:GetAbility():GetSpecialValueFor( "min_height_above_highest" )
	self.min_distance = self:GetAbility():GetSpecialValueFor( "min_jump_distance" )
	self.max_distance = self:GetAbility():GetSpecialValueFor( "max_jump_distance" )
	self.radius = self:GetAbility():GetSpecialValueFor( "landing_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "impact_damage" )
	self.debuff = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
	self.buff = self:GetAbility():GetSpecialValueFor( "ally_buff_duration" )

	if not IsServer() then return end

	self.projectile = tonumber(kv.proj)
	self.target = EntIndexToHScript( kv.target )
	self.point = Vector( kv.point_x, kv.point_y, kv.point_z )
	self.targetpos = self.target:GetOrigin()
	self.distancethreshold = 1000
	self.jump_heh = kv.jump_heh
	self.start_direction = self.targetpos - self:GetParent():GetAbsOrigin()

	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	local speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self:PlayEffects1( self.parent, speed )

	local origin =  self:GetParent():GetOrigin()
	self.direction = self.point - self.target:GetAbsOrigin()
	self.distance = self.direction:Length2D()

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
	self:GetParent():RemoveHorizontalMotionController( self )

	if self.interrupted then return end

	local origin =  self:GetParent():GetOrigin()

	local allied = self.target:GetTeamNumber()==self.parent:GetTeamNumber()
	if allied then
		self.target:AddNewModifier( self.parent, self.ability, "modifier_marci_companion_run_custom_buff", { duration = self.buff } )
	end

	self:GetParent():SetForwardVector( self.direction )


	local arc = self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_generic_arc_marci",{ dir_x = self.direction.x,dir_y = self.direction.y,duration = self.duration,distance = self.distance,height = self.height,fix_end = false,isStun = true,isForward = true,activity = ACT_DOTA_OVERRIDE_ABILITY_2,})

	if self:GetCaster():HasModifier("modifier_marci_rebound_3") and self.target:GetTeam() ~= self:GetCaster():GetTeam() then 
		local duration = self:GetAbility().hits_count[self:GetCaster():GetUpgradeStack("modifier_marci_rebound_3")]*self:GetAbility().hits_interval

		self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_marci_companion_run_custom_hits", {duration = duration})
	end


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
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

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

function modifier_marci_companion_run_custom_buff:IsHidden()
	return false
end

function modifier_marci_companion_run_custom_buff:IsDebuff()
	return false
end

function modifier_marci_companion_run_custom_buff:IsPurgable()
	return true
end

function modifier_marci_companion_run_custom_buff:OnCreated( kv )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "ally_movespeed_pct" )
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Marci.Rebound.Ally")
end

function modifier_marci_companion_run_custom_buff:OnRefresh( kv )
	self:OnCreated( kv )
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









modifier_generic_arc_marci = class({})

function modifier_generic_arc_marci:IsHidden()
	return true
end

function modifier_generic_arc_marci:IsDebuff()
	return false
end

function modifier_generic_arc_marci:IsStunDebuff()
	return false
end

function modifier_generic_arc_marci:IsPurgable()
	return false
end

function modifier_generic_arc_marci:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_generic_arc_marci:OnCreated( kv )
	if not IsServer() then return end
	self.interrupted = false
	self:SetJumpParameters( kv )
	self:Jump()
end

function modifier_generic_arc_marci:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_generic_arc_marci:OnDestroy()
	if not IsServer() then return end

	local dir = self:GetParent():GetForwardVector()
    dir.z = 0
    self:GetParent():SetForwardVector(dir)
    self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

    FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

	local pos = self:GetParent():GetOrigin()
	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )
	if self.end_offset~=0 then
		self:GetParent():SetOrigin( pos )
	end
	if self.endCallback then
		self.endCallback( self.interrupted )
	end
end

function modifier_generic_arc_marci:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	if self:GetStackCount()>0 then
		table.insert( funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION )
	end
	return funcs
end

function modifier_generic_arc_marci:GetModifierDisableTurning()
	if not self.isForward then return end
	return 1
end

function modifier_generic_arc_marci:GetOverrideAnimation()
	return self:GetStackCount()
end

function modifier_generic_arc_marci:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.isStun or false,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = self.isRestricted or false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

function modifier_generic_arc_marci:UpdateHorizontalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end
	local pos = me:GetOrigin() + self.direction * self.speed * 0.84 * dt 
	me:SetOrigin( pos )
end

function modifier_generic_arc_marci:UpdateVerticalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end
	local pos = me:GetOrigin()
	local time = self:GetElapsedTime()
	local height = pos.z
	local speed = self:GetVerticalSpeed( time )
	pos.z = height + speed * dt
	me:SetOrigin( pos )
	if not self.fix_duration then
		local ground = GetGroundHeight( pos, me ) + self.end_offset
		if pos.z <= ground then
			pos.z = ground
			me:SetOrigin( pos )
			self:Destroy()
		end
	end
end

function modifier_generic_arc_marci:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_generic_arc_marci:OnVerticalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_generic_arc_marci:SetJumpParameters( kv )
	self.parent = self:GetParent()
	self.fix_end = true
	self.fix_duration = true
	self.fix_height = true
	if kv.fix_end then
		self.fix_end = kv.fix_end==1
	end
	if kv.fix_duration then
		self.fix_duration = kv.fix_duration==1
	end
	if kv.fix_height then
		self.fix_height = kv.fix_height==1
	end
	self.isStun = kv.isStun==1
	self.isRestricted = kv.isRestricted==1
	self.isForward = kv.isForward==1
	self.activity = kv.activity or 0
	self:SetStackCount( self.activity )
	if kv.target_x and kv.target_y then
		local origin = self.parent:GetOrigin()
		local dir = Vector( kv.target_x, kv.target_y, 0 ) - origin
		dir.z = 0
		dir = dir:Normalized()
		self.direction = dir
	end
	if kv.dir_x and kv.dir_y then
		self.direction = Vector( kv.dir_x, kv.dir_y, 0 ):Normalized()
	end
	if not self.direction then
		self.direction = self.parent:GetForwardVector()
	end
	self.duration = kv.duration
	self.distance = kv.distance
	self.speed = kv.speed
	if not self.duration then
		self.duration = self.distance/self.speed
	end
	if not self.distance then
		self.speed = self.speed or 0
		self.distance = self.speed*self.duration
	end
	if not self.speed then
		self.distance = self.distance or 0
		self.speed = self.distance/self.duration
	end

	print(self.speed, self.distance, self.duration)

	self.height = kv.height or 0
	self.start_offset = kv.start_offset or 0
	self.end_offset = kv.end_offset or 0
	local pos_start = self.parent:GetOrigin()
	local pos_end = pos_start + self.direction * self.distance
	local height_start = GetGroundHeight( pos_start, self.parent ) + self.start_offset
	local height_end = GetGroundHeight( pos_end, self.parent ) + self.end_offset
	local height_max
	if not self.fix_height then
		self.height = math.min( self.height, self.distance/4 )
	end

	if self.fix_end then
		height_end = height_start
		height_max = height_start + self.height
	else
		local tempmin, tempmax = height_start, height_end
		if tempmin>tempmax then
			tempmin,tempmax = tempmax, tempmin
		end
		local delta = (tempmax-tempmin)*2/3

		height_max = tempmin + delta + self.height
	end

	if not self.fix_duration then
		self:SetDuration( -1, false )
	else
		self:SetDuration( self.duration, true )
	end

	self:InitVerticalArc( height_start, height_max, height_end, self.duration )
end

function modifier_generic_arc_marci:Jump()
	if self.distance>0 then
		if not self:ApplyHorizontalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end

	if self.height>0 then
		if not self:ApplyVerticalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end
end

function modifier_generic_arc_marci:InitVerticalArc( height_start, height_max, height_end, duration )
	local height_end = height_end - height_start
	local height_max = height_max - height_start

	if height_max<height_end then
		height_max = height_end+0.01
	end

	if height_max<=0 then
		height_max = 0.01
	end

	local duration_end = ( 1 + math.sqrt( 1 - height_end/height_max ) )/2
	self.const1 = 4*height_max*duration_end/duration
	self.const2 = 4*height_max*duration_end*duration_end/(duration*duration)
end

function modifier_generic_arc_marci:GetVerticalPos( time )
	return self.const1*time - self.const2*time*time
end

function modifier_generic_arc_marci:GetVerticalSpeed( time )
	return self.const1 - 2*self.const2*time
end

function modifier_generic_arc_marci:SetEndCallback( func )
	self.endCallback = func
end




modifier_marci_companion_run_custom_legendary = class({})

function modifier_marci_companion_run_custom_legendary:IsHidden()
	return true
end

function modifier_marci_companion_run_custom_legendary:IsDebuff()
	return false
end

function modifier_marci_companion_run_custom_legendary:IsPurgable()
	return false
end

function modifier_marci_companion_run_custom_legendary:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()


	self.radius = self:GetAbility():GetSpecialValueFor( "landing_radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "impact_damage" )
	self.debuff = self:GetAbility():GetSpecialValueFor( "debuff_duration" )
	self.buff = self:GetAbility():GetSpecialValueFor( "ally_buff_duration" )

	if not IsServer() then return end

	self.projectile = tonumber(kv.proj)
	self.target = EntIndexToHScript( kv.target )

	self.targetpos = self.target:GetOrigin()

	self.distancethreshold = 2000

	self.start_direction = self.targetpos - self:GetParent():GetAbsOrigin()

	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	local speed = self:GetAbility():GetSpecialValueFor( "move_speed" )
	self:PlayEffects1( self.parent, speed )

	self:PlayEffects3( self.target, self.radius )
end

function modifier_marci_companion_run_custom_legendary:OnDestroy()
	if not IsServer() then return end	
	self:GetParent():RemoveHorizontalMotionController( self )


	if self.interrupted then return end

	local origin =  self:GetParent():GetOrigin()

	local allied = self.target:GetTeamNumber()==self.parent:GetTeamNumber()
	if allied then
		self.target:AddNewModifier( self.parent, self.ability, "modifier_marci_companion_run_custom_buff", { duration = self.buff } )
	end


	if self:GetCaster():HasModifier("modifier_marci_rebound_3") and self.target:GetTeam() ~= self:GetCaster():GetTeam() then 
		local duration = self:GetAbility().hits_count[self:GetCaster():GetUpgradeStack("modifier_marci_rebound_3")]*self:GetAbility().hits_interval

		self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_marci_companion_run_custom_hits", {duration = duration})
	end
	
	self:GetAbility():DealDamage()


end

function modifier_marci_companion_run_custom_legendary:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_marci_companion_run_custom_legendary:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_2_ALLY
end

function modifier_marci_companion_run_custom_legendary:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_marci_companion_run_custom_legendary:UpdateHorizontalMotion( me, dt )
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

function modifier_marci_companion_run_custom_legendary:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_marci_companion_run_custom_legendary:PlayEffects1( caster, speed )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_charge_projectile.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( speed, 0, 0 ) )
	self:AddParticle( effect_cast, false, false, -1, false, false)
	caster:EmitSound("Hero_Marci.Rebound.Cast")
end

function modifier_marci_companion_run_custom_legendary:PlayEffects2( caster, buff )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( effect_cast, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	buff:AddParticle( effect_cast, false, false, -1, false, false )
	caster:EmitSound("Hero_Marci.Rebound.Leap")
end

function modifier_marci_companion_run_custom_legendary:PlayEffects3( target, radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_landing_zone.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
	ParticleManager:DestroyParticle(effect_cast, false)
	ParticleManager:ReleaseParticleIndex( effect_cast )
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

local mod = self:GetCaster():FindModifierByName("modifier_marci_companion_run_custom_legendary_second")
if not mod then return end

self.parent = self:GetCaster()



self.target_abs = self:GetCursorPosition() -- mod.target:GetAbsOrigin() + self.direction * 120

if self.target_abs == self:GetCaster():GetAbsOrigin() then 
	self.target_abs = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*10
end 


self.direction = (self.target_abs - self:GetCaster():GetAbsOrigin())
self.direction.z = 0
self.direction = self.direction:Normalized()

if (self.target_abs - self:GetCaster():GetAbsOrigin()):Length2D() > self:GetSpecialValueFor("range") then 
	self.target_abs = self.target_abs + self:GetSpecialValueFor("range")*(self.target_abs - self:GetCaster():GetAbsOrigin()):Normalized()
end 


self.parent:EmitSound("Hero_Marci.Rebound.Cast")

self.ability = self:GetCaster():FindAbilityByName("marci_companion_run_custom")

self.max_distance = self:GetSpecialValueFor("max_distance")

local origin =  self:GetCaster():GetOrigin()


self.distance = (self.target_abs - origin):Length2D()

self.duration = 0.3
if self.distance >= 600 then 
	self.duration = 0.5
end


self:GetCaster():SetForwardVector( self.direction )

self.distance = math.min(self.distance, self.max_distance)

self.damage = math.max(1, mod:GetStackCount())

self.radius = self:GetSpecialValueFor("radius")
local center = self:GetCaster():GetAbsOrigin() + self.distance*self.direction

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_landing_zone.vpcf", PATTACH_WORLDORIGIN, nil )
	
ParticleManager:SetParticleControl( effect_cast, 0, center )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius, self.radius, self.radius) )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex( effect_cast )


local arc = self:GetCaster():AddNewModifier( self:GetCaster(), self.ability, "modifier_generic_arc_marci",
	{ 
	dir_x = self.direction.x,
	dir_y = self.direction.y,
	duration = self.duration,
	distance = self.distance,
	height = self.ability:GetSpecialValueFor( "min_height_above_highest" ),
	fix_end = false,
	isStun = true,
	isForward = true,
	activity = ACT_DOTA_OVERRIDE_ABILITY_2,
})
	
arc:SetEndCallback( function( interrupted )

	self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END,1)

  EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Pango.Shield_legendary", self.parent)

  local smash2 = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_burst.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(smash2, 0, self.parent:GetAbsOrigin())
  ParticleManager:SetParticleControl(smash2, 1, Vector(self.radius, self.radius, self.radius))
  ParticleManager:DestroyParticle(smash2, false)
  ParticleManager:ReleaseParticleIndex(smash2)



	local enemies = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
	
	local damageTable = { attacker = self.parent, damage = self.damage, damage_type = DAMAGE_TYPE_PURE, ability = self.ability, }
	
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		local real_damage = ApplyDamage(damageTable)

		enemy:SendNumber(6,  real_damage)
	end

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( particle, 1, Vector(self.radius, self.radius,self.radius) )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 9, Vector(self.radius, self.radius, self.radius) )
	ParticleManager:SetParticleControl( effect_cast, 10, self.parent:GetOrigin() )
	ParticleManager:DestroyParticle(effect_cast, false)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( self.parent:GetOrigin(), "Hero_Marci.Rebound.Impact", self.parent )

	if self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_marci_unleash_custom") then
		local ability = self:GetCaster():FindAbilityByName("marci_unleash_custom")
		ability:Pulse(self:GetCaster():GetAbsOrigin(), nil)
	end
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
if not IsServer() then return end

self.damage_count = self:GetCaster():GetTalentValue("modifier_marci_rebound_7", "damage")/100

self.RemoveForDuel = true
local ability = self:GetCaster():FindAbilityByName("marci_companion_run_custom")
local ability_2 = self:GetCaster():FindAbilityByName("marci_rebound_bounce_legendary")

self:GetCaster():SwapAbilities(ability:GetName(), ability_2:GetName(), false, true)

ability_2:StartCooldown(0.5)

self.target = EntIndexToHScript(table.target)


self.t = -1

if not IsServer() then return end

self.max_time = self:GetRemainingTime()

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'marci_jump_change',  {hide = 0, max_time = self.max_time, time = self:GetRemainingTime(), damage = self:GetStackCount()})

self.interval = FrameTime()

self.count = 0.5

self.timer = self:GetAbility().legendary_duration*2 
self:StartIntervalThink(self.interval)
self:OnIntervalThink()


end





function modifier_marci_companion_run_custom_legendary_second:OnIntervalThink()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'marci_jump_change',  {hide = 0, max_time = self.max_time, time = self:GetRemainingTime(), damage = self:GetStackCount()})

self.count = self.count + self.interval 

if self.count >= 0.5 then  
	self.count = 0 
else 
	return
end 


if not self.target or self.target:IsNull() or not self.target:IsAlive() then 
	return
end


self.t = self.t + 1

local caster = self.target

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
  decimal = 8
else 
  decimal = 1
end

local particleName = "particles/lina_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex(particle)

end







function modifier_marci_companion_run_custom_legendary_second:OnDestroy()
if not IsServer() then return end
local ability = self:GetCaster():FindAbilityByName("marci_companion_run_custom")
local ability_2 = self:GetCaster():FindAbilityByName("marci_rebound_bounce_legendary")

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'marci_jump_change',  {hide = 1, max_time = self.max_time, time = self:GetRemainingTime(), damage = self:GetStackCount()})


self:GetCaster():SwapAbilities(ability_2:GetName(), ability:GetName(), false, true)
ability:UseResources(false, false, false, true)

local mod = self:GetParent():FindModifierByName("modifier_marci_companion_run_custom_after_cd")

if mod then 
	self:GetCaster():CdAbility(ability, mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_marci_rebound_4", "cd"))
	mod:Destroy()
end

end


function modifier_marci_companion_run_custom_legendary_second:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_marci_companion_run_custom_legendary_second:OnTakeDamage(params)
if not IsServer() then return end
if not self.target then return end
if self.target:IsNull() then return end
if self.target ~= params.unit then return end
if self:GetParent() ~= params.attacker then return end

self:SetStackCount(self:GetStackCount() + params.damage*self.damage_count)

end









modifier_marci_companion_run_custom_speed = class({})

function modifier_marci_companion_run_custom_speed:IsHidden()
	return false
end

function modifier_marci_companion_run_custom_speed:IsDebuff()
	return false
end

function modifier_marci_companion_run_custom_speed:IsPurgable()
	return true
end

function modifier_marci_companion_run_custom_speed:OnCreated( kv )
self.ms_bonus = self:GetAbility().speed_bonus[self:GetCaster():GetUpgradeStack("modifier_marci_rebound_1")]
if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Marci.Rebound.Ally")
end

function modifier_marci_companion_run_custom_speed:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_companion_run_custom_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_marci_companion_run_custom_speed:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

function modifier_marci_companion_run_custom_speed:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end

function modifier_marci_companion_run_custom_speed:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_marci_companion_run_custom_root = class({})

function modifier_marci_companion_run_custom_root:GetEffectName()
  return "particles/units/heroes/hero_troll_warlord/troll_warlord_bersekers_net.vpcf"
end

function modifier_marci_companion_run_custom_root:CheckState()
  return {[MODIFIER_STATE_ROOTED] = true}
end


function modifier_marci_companion_run_custom_root:IsHidden() return true end
function modifier_marci_companion_run_custom_root:IsPurgable() return true end


function modifier_marci_companion_run_custom_root:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("n_creep_TrollWarlord.Ensnare")

end




modifier_marci_companion_run_custom_attacks = class({})
function modifier_marci_companion_run_custom_attacks:IsHidden() return false end
function modifier_marci_companion_run_custom_attacks:IsPurgable() return false end
function modifier_marci_companion_run_custom_attacks:GetTexture() return "buffs/rebound_range_attacks" end
function modifier_marci_companion_run_custom_attacks:OnCreated(table)

self.speed = self:GetCaster():GetTalentValue("modifier_marci_rebound_4", "speed")

if not IsServer() then return end



end

function modifier_marci_companion_run_custom_attacks:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_marci_companion_run_custom_attacks:GetModifierAttackSpeedBonus_Constant()
return self.speed
end



modifier_marci_companion_run_custom_hits = class({})
function modifier_marci_companion_run_custom_hits:IsHidden() return true end
function modifier_marci_companion_run_custom_hits:IsPurgable() return false end
function modifier_marci_companion_run_custom_hits:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().hits_interval)

self.pos = self:GetParent():GetAbsOrigin() + ((self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized())*100

end

function modifier_marci_companion_run_custom_hits:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster():IsAlive() then return end

local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_marci_companion_run_custom_no_root", {})

self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, true)



for i = 1,3 do
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( particle, 0,self.pos )
	ParticleManager:SetParticleControlEnt( particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end 

self:GetParent():EmitSound("Marci.Dispose_hits")
if mod then 
	mod:Destroy()
end

end

modifier_marci_companion_run_custom_no_root = class({})
function modifier_marci_companion_run_custom_no_root:IsHidden() return true end
function modifier_marci_companion_run_custom_no_root:IsPurgable() return false end
function modifier_marci_companion_run_custom_no_root:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end
function modifier_marci_companion_run_custom_no_root:GetModifierDamageOutgoing_Percentage()
	return -1*(100 - self:GetAbility().hits_damage)
end






modifier_marci_companion_run_custom_resist_tracker = class({})

function modifier_marci_companion_run_custom_resist_tracker:IsHidden() return true end

function modifier_marci_companion_run_custom_resist_tracker:IsPurgable() return false end

function modifier_marci_companion_run_custom_resist_tracker:IsAura() return true end

function modifier_marci_companion_run_custom_resist_tracker:GetAuraDuration() return 0.1 end


function modifier_marci_companion_run_custom_resist_tracker:GetAuraRadius() return self.radius
end

function modifier_marci_companion_run_custom_resist_tracker:OnCreated(table)
self.radius = table.radius

if not IsServer() then return end
particle_cast = "particles/marci_field.vpcf"



local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 1 ) )


self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end


function modifier_marci_companion_run_custom_resist_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY
 end

function modifier_marci_companion_run_custom_resist_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_marci_companion_run_custom_resist_tracker:GetModifierAura() return "modifier_marci_companion_run_custom_resist" end





modifier_marci_companion_run_custom_resist = class({})

function modifier_marci_companion_run_custom_resist:IsPurgable() return false end

function modifier_marci_companion_run_custom_resist:IsHidden() return false end 
function modifier_marci_companion_run_custom_resist:GetTexture() return "buffs/rebound_resist" end
function modifier_marci_companion_run_custom_resist:GetEffectName()
	return "particles/alch_stun_legendary.vpcf"
end

function modifier_marci_companion_run_custom_resist:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_marci_companion_run_custom_resist:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}

end
function modifier_marci_companion_run_custom_resist:GetModifierIncomingDamage_Percentage()
return 
self:GetAbility().resist_damage
end




function modifier_marci_companion_run_custom_resist:GetModifierHealthRegenPercentage()
return self:GetAbility().resist_heal
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
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end



function modifier_marci_companion_run_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_marci_rebound_4") then return end
if self:GetParent() ~= params.attacker then return end

if self:GetParent():HasModifier("modifier_marci_companion_run_custom_no_root") then 

	for i = 1,3 do
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControlEnt( particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
		ParticleManager:DestroyParticle(particle, false)
		ParticleManager:ReleaseParticleIndex( particle )
	end 

end


if self:GetParent():HasModifier("modifier_marci_companion_run_custom_legendary_second") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_marci_companion_run_custom_after_cd", {})
else 

	self:GetCaster():CdAbility(self:GetAbility(), self:GetCaster():GetTalentValue("modifier_marci_rebound_4", "cd"))
end


end

