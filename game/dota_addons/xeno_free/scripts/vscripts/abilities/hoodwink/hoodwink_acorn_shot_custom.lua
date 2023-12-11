LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_thinker", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_thinker_tree", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_debuff", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_thinker_talent", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_armor_stack", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_armor_count", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_armor_caster", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_tracker", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_auto_cd", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_acorn_shot_custom_range", "abilities/hoodwink/hoodwink_acorn_shot_custom", LUA_MODIFIER_MOTION_NONE )

hoodwink_acorn_shot_custom = class({})

hoodwink_acorn_shot_custom.tree_duration = 20
hoodwink_acorn_shot_custom.tree_vision = 300

hoodwink_acorn_shot_custom.bounce_init = 0
hoodwink_acorn_shot_custom.bounce_inc = 1



hoodwink_acorn_shot_custom.stun_duration = 0.5
hoodwink_acorn_shot_custom.stun_cd = 10


hoodwink_acorn_shot_custom.legendary_creeps = -40





function hoodwink_acorn_shot_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tree.vpcf", context )
PrecacheResource( "particle", "particles/tree_fx/tree_simple_explosion.vpcf", context )

end





function hoodwink_acorn_shot_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_hoodwink_acorn_4") then
	bonus = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_4", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end






function hoodwink_acorn_shot_custom:GetIntrinsicModifierName()
if not self:GetCaster():HasModifier("modifier_hoodwink_acorn_shot_custom_tracker") then 
	return "modifier_hoodwink_acorn_shot_custom_tracker"
end

return
end

function hoodwink_acorn_shot_custom:GetBehavior()
  	if self:GetCaster():HasModifier("modifier_hoodwink_acorn_legendary") then
    	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
  	end
 	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end


function hoodwink_acorn_shot_custom:GetVectorTargetRange()
  return 500
end

function hoodwink_acorn_shot_custom:OnVectorCastStart(vStartLocation, vDirection)
	local target = self:GetCursorPosition()
	if target == self:GetCaster():GetAbsOrigin() then 
	  target = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*30
	  return
	end
	local pos1 = self:GetVectorPosition() + 250*vDirection
	local pos2 = self:GetVectorPosition() - 250*vDirection


	self:CastBuffs()
	self:CastVector(pos1,pos2,self:GetCaster())
end



function hoodwink_acorn_shot_custom:CastBuffs()
if not IsServer() then return end 

if self:GetCaster():HasModifier("modifier_hoodwink_acorn_6") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_acorn_shot_custom_range", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_6", "duration")})
end

if self:GetCaster():HasModifier("modifier_hoodwink_acorn_4") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_acorn_shot_custom_armor_caster", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_4", "duration")})
end



end 




function hoodwink_acorn_shot_custom:GetCastRange( vLocation, hTarget )

	local bonus = 0
	if self:GetCaster():HasModifier("modifier_hoodwink_acorn_6") then 
		bonus = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_6", "cast_range")
	end

	return self:GetCaster():Script_GetAttackRange() + self:GetSpecialValueFor( "bonus_range" ) + self:GetCaster():GetCastRangeBonus() + bonus
end



function hoodwink_acorn_shot_custom:CastVector(pos1,pos2,caster)
if not IsServer() then return end
	
	local thinker = CreateModifierThinker( caster, self, "modifier_hoodwink_acorn_shot_custom_thinker_talent", {}, caster:GetOrigin(), caster:GetTeamNumber(), false )
	local mod = thinker:FindModifierByName( "modifier_hoodwink_acorn_shot_custom_thinker_talent" )
	thinker:SetOrigin( GetGroundPosition(pos1, nil) +Vector(0,0,pos1.z+128)) 
	mod.source = caster
	mod.target = thinker
	mod.pos1 = pos1
	mod.pos2 = pos2
	self:GetCaster():EmitSound("Hero_Hoodwink.AcornShot.Cast")

end







function hoodwink_acorn_shot_custom:Cast(point, target, caster, ability)

local thinker = CreateModifierThinker( caster, self, "modifier_hoodwink_acorn_shot_custom_thinker", {}, caster:GetOrigin(), caster:GetTeamNumber(), false )
local mod = thinker:FindModifierByName( "modifier_hoodwink_acorn_shot_custom_thinker" )

if not target or ability:GetAutoCastState() then 
	target = thinker 
	thinker:SetOrigin( point ) 
end

mod.source = caster
mod.target = target
caster:EmitSound("Hero_Hoodwink.AcornShot.Cast")

end

function hoodwink_acorn_shot_custom:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	self:CastBuffs()
	self:Cast(point,target,caster,self)
end



function hoodwink_acorn_shot_custom:PerformHit(caster,target,creeps,first)
if not IsServer() then return end

local mod = caster:AddNewModifier( caster, self, "modifier_hoodwink_acorn_shot_custom", {creeps = creeps, first = first} )


local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_impact.vpcf", PATTACH_CUSTOMORIGIN, target )
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )


caster:PerformAttack( target, true, true, true, true, false, false, false )
if mod then
	mod:Destroy()
end


target:EmitSound("Hero_Hoodwink.AcornShot.Target")

end


function hoodwink_acorn_shot_custom:OnProjectileHit_ExtraData( target, location, ExtraData )
local caster = self:GetCaster()

local duration = self:GetSpecialValueFor( "debuff_duration" )

if self:GetCaster():HasModifier("modifier_hoodwink_acorn_3") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_3", "duration")
end

if ExtraData.auto and ExtraData.auto == 1  then 

	if target then 

		self:PerformHit(caster,target,0,true)
		target:AddNewModifier( caster, self, "modifier_stunned", { duration = self.stun_duration*(1 - target:GetStatusResistance()) } )
		target:Stop()
		target:AddNewModifier( caster, self, "modifier_hoodwink_acorn_shot_custom_debuff", { duration = duration } )
		target:EmitSound("Hero_Hoodwink.AcornShot.Slow")


	end
	return
end



local thinker = EntIndexToHScript( ExtraData.thinker )

if not thinker then return end

local mod_talent = thinker:FindModifierByName( "modifier_hoodwink_acorn_shot_custom_thinker_talent" )
if mod_talent then
	if ExtraData.first==1 then
		mod_talent.one_tree = CreateModifierThinker( caster, self, "modifier_hoodwink_acorn_shot_custom_thinker_tree", {duration = 20-FrameTime()}, GetGroundPosition(mod_talent.pos1, nil)+Vector(0,0,mod_talent.pos2.z+128), caster:GetTeamNumber(), false )
		mod_talent.two_tree = CreateModifierThinker( caster, self, "modifier_hoodwink_acorn_shot_custom_thinker_tree", {duration = 20-FrameTime()}, GetGroundPosition(mod_talent.pos2, nil)+Vector(0,0,mod_talent.pos2.z+128), caster:GetTeamNumber(), false )
	else 
		thinker.first_hit = false
	end
	mod_talent:Bounce()
end




local mod = thinker:FindModifierByName( "modifier_hoodwink_acorn_shot_custom_thinker" )
if not mod then return end


thinker:SetOrigin( location )
mod:Bounce()

if ExtraData.first==1 then
	if target==thinker then
		CreateModifierThinker( caster, self, "modifier_hoodwink_acorn_shot_custom_thinker_tree", {duration = 20-FrameTime()}, location, caster:GetTeamNumber(), false )
		return
	end

	if not target then
		CreateModifierThinker( caster, self, "modifier_hoodwink_acorn_shot_custom_thinker_tree", {duration = 20-FrameTime()}, location, caster:GetTeamNumber(), false )
		mod.target = thinker
		return
	end
	
	if target:TriggerSpellAbsorb( self ) then
		mod:Destroy()
		return
	end
end

if not target then mod:Destroy() return end

local first = false

if thinker.first_hit == true then 
	thinker.first_hit = false
	first = true

	if self:GetCaster():HasModifier("modifier_hoodwink_acorn_5") then 
		target:AddNewModifier( caster, self, "modifier_stunned", { duration = self.stun_duration*(1 - target:GetStatusResistance()) } )
	end
end

target:AddNewModifier( caster, self, "modifier_hoodwink_acorn_shot_custom_debuff", { duration = duration } )
target:EmitSound("Hero_Hoodwink.AcornShot.Slow")

self:PerformHit(caster,target,0, first)

end


function hoodwink_acorn_shot_custom:OnProjectileThink_ExtraData(location, ExtraData)
if ExtraData.auto and ExtraData.auto == 1 then return end

local caster = self:GetCaster()
local thinker = EntIndexToHScript( ExtraData.thinker )

local duration = self:GetSpecialValueFor( "debuff_duration" )
if self:GetCaster():HasModifier("modifier_hoodwink_acorn_3") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_3", "duration")
end


if not thinker then return end

local mod_talent = thinker:FindModifierByName( "modifier_hoodwink_acorn_shot_custom_thinker_talent" )


if mod_talent then
	if ExtraData.first~=1 then
		local enemies = FindUnitsInRadius( caster:GetTeamNumber(), location, nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
		for _,enemy in pairs(enemies) do
			if not mod_talent.targets[enemy:entindex()] and not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then
				mod_talent.targets[enemy:entindex()] = enemy

				local creeps = 0
				if not enemy:IsHero() then 
					creeps = 1
				end


				if thinker.first_hit == true and caster:HasModifier("modifier_hoodwink_acorn_5") then 
					enemy:AddNewModifier( caster, self, "modifier_stunned", { duration = self.stun_duration*(1 - enemy:GetStatusResistance()) } )
				end

				enemy:AddNewModifier( caster, self, "modifier_hoodwink_acorn_shot_custom_debuff", { duration = duration } )
				enemy:EmitSound("Hero_Hoodwink.AcornShot.Slow")

				self:PerformHit(caster,enemy,creeps,thinker.first_hit)
			end
		end
	end

end



end














modifier_hoodwink_acorn_shot_custom_thinker = class({})

function modifier_hoodwink_acorn_shot_custom_thinker:OnCreated( kv )
	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.parent.first_hit = true

	self.projectile_speed = self.caster:GetProjectileSpeed()
	self.bounces = self:GetAbility():GetSpecialValueFor( "bounce_count" )+1
	self.delay = self:GetAbility():GetSpecialValueFor( "bounce_delay" )
	self.range = self:GetAbility():GetSpecialValueFor( "bounce_range" )
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	if self.caster:HasModifier("modifier_hoodwink_acorn_1") then 
		self.bounces = self.bounces + self:GetAbility().bounce_init + self:GetAbility().bounce_inc*self.caster:GetUpgradeStack("modifier_hoodwink_acorn_1")
	end


	self.info = {
		Ability = self.ability,	
		EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
		iMoveSpeed = self.projectile_speed,
		bDodgeable = true,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bVisibleToEnemies = true,
		bProvidesVision = true,
		iVisionRadius = 200,
		iVisionTeamNumber = self.caster:GetTeamNumber(),
		ExtraData = { thinker = self.parent:entindex() }
	}

	self:StartIntervalThink( 0 )
end

function modifier_hoodwink_acorn_shot_custom_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_hoodwink_acorn_shot_custom_thinker:OnIntervalThink()
	self.bounces = self.bounces-1
	if self.bounces<0 then
		self:Destroy()
		return
	end

	self:StartIntervalThink(-1)

	local first = 0
	if not self.first then
		self.first = true
		first = 1
		self.info.iMoveSpeed = self.projectile_speed
	else
		self.source = self.target
		local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.target:GetOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
		if #enemies<1 then
			self:Destroy()
			return
		end
		local next_target
		for _,enemy in pairs(enemies) do
			if enemy~=self.target and not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then
				next_target = enemy
				break
			end
		end
		if not next_target then
			self:Destroy()
			return
		end
		self.target = next_target
		self.info.iMoveSpeed = self.caster:GetProjectileSpeed() / 2
	end

	self.info.Source = self.source
	self.info.Target = self.target
	self.info.ExtraData.first = first
	ProjectileManager:CreateTrackingProjectile( self.info )
	self.source:EmitSound("Hero_Hoodwink.AcornShot.Bounce")
end

function modifier_hoodwink_acorn_shot_custom_thinker:Bounce()
	self:StartIntervalThink( self.delay )
end

modifier_hoodwink_acorn_shot_custom = class({})

function modifier_hoodwink_acorn_shot_custom:IsHidden()
	return true
end

function modifier_hoodwink_acorn_shot_custom:IsPurgable()
	return false
end

function modifier_hoodwink_acorn_shot_custom:OnCreated( kv )
self.bonus = self:GetAbility():GetSpecialValueFor( "acorn_shot_damage" )
self.damage_percentage = (100 - self:GetAbility():GetSpecialValueFor("base_damage_pct")) * -1

if not IsServer() then return end

self.creeps = kv.creeps

self.first = kv.first

end

function modifier_hoodwink_acorn_shot_custom:OnRefresh( kv )
self.bonus = self:GetAbility():GetSpecialValueFor( "acorn_shot_damage" )
self.damage_percentage = (100 - self:GetAbility():GetSpecialValueFor("base_damage_pct")) * -1

if not IsServer() then return end

self.creeps = kv.creeps
self.first = kv.first
end

function modifier_hoodwink_acorn_shot_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end


function modifier_hoodwink_acorn_shot_custom:GetCritDamage() return
self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_2", "crit")
end


function modifier_hoodwink_acorn_shot_custom:GetModifierPreAttack_CriticalStrike( params )
if not self:GetParent():HasModifier("modifier_hoodwink_acorn_2") then return end

if self.first == 1 or self.first == true then 

	self.record = params.record
	return self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_2", "crit")
end 

local random = RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_2", "chance"),122,self:GetParent())
if not random then return end

self.record = params.record
return self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_2", "crit")
end




function modifier_hoodwink_acorn_shot_custom:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
if not self.record or self.record ~= params.record then return end

self.record = nil
params.target:EmitSound("DOTA_Item.Daedelus.Crit")
end




function modifier_hoodwink_acorn_shot_custom:GetModifierPreAttack_BonusDamage()
if not IsServer() then return end
if self.creeps == 1 then return end
	return (self.bonus) * 100/(100+self.damage_percentage)
end

function modifier_hoodwink_acorn_shot_custom:GetModifierDamageOutgoing_Percentage()
if not IsServer() then return end
if self.creeps == 1 then 
	return self:GetAbility().legendary_creeps
end
return self.damage_percentage
end




modifier_hoodwink_acorn_shot_custom_debuff = class({})

function modifier_hoodwink_acorn_shot_custom_debuff:IsHidden()
	return false
end

function modifier_hoodwink_acorn_shot_custom_debuff:IsDebuff()
	return true
end

function modifier_hoodwink_acorn_shot_custom_debuff:IsStunDebuff()
	return false
end

function modifier_hoodwink_acorn_shot_custom_debuff:IsPurgable()
	return true
end

function modifier_hoodwink_acorn_shot_custom_debuff:OnCreated( kv )
self.slow = -1 * self:GetAbility():GetSpecialValueFor( "slow" )

self.turn_slow = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_3", "turn")
self.attack_slow = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_3", "attack")

end

function modifier_hoodwink_acorn_shot_custom_debuff:OnRefresh( kv )
	self:OnCreated()
end

function modifier_hoodwink_acorn_shot_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
	}

	return funcs
end

function modifier_hoodwink_acorn_shot_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_hoodwink_acorn_shot_custom_debuff:GetEffectName()
	return "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_slow.vpcf"
end

function modifier_hoodwink_acorn_shot_custom_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_hoodwink_acorn_shot_custom_debuff:GetModifierTurnRate_Percentage()
if not self:GetCaster():HasModifier("modifier_hoodwink_acorn_3") then return end
return self.turn_slow
end


function modifier_hoodwink_acorn_shot_custom_debuff:GetModifierAttackSpeedBonus_Constant()
if not self:GetCaster():HasModifier("modifier_hoodwink_acorn_3") then return end
return self.attack_slow
end


modifier_hoodwink_acorn_shot_custom_thinker_tree = class({})

function modifier_hoodwink_acorn_shot_custom_thinker_tree:IsHidden() return true end

function modifier_hoodwink_acorn_shot_custom_thinker_tree:OnCreated()
	if not IsServer() then return end
	self.tree = CreateTempTreeWithModel( self:GetParent():GetAbsOrigin(), self:GetAbility().tree_duration, "models/heroes/hoodwink/hoodwink_tree_model.vmdl" )

	self.tree:SetSequence("hoodwink_tree_spawn")
	self.tree:SetSequence("hoodwink_tree_idle")

	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0,	 false	 )
	for _,unit in pairs(units) do
		if unit:GetUnitName() ~= "npc_teleport" and (unit:IsHero() or unit:IsCreep()) then
			FindClearSpaceForUnit( unit, unit:GetOrigin(), true )
		end
	end
	local particle_1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tree.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.tree )
	ParticleManager:SetParticleControl( particle_1, 0, self.tree:GetOrigin() )
	ParticleManager:SetParticleControl( particle_1, 1, Vector( 1, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( particle_1 )
	local particle_2 = ParticleManager:CreateParticle( "particles/tree_fx/tree_simple_explosion.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle_2, 0, self.tree:GetOrigin()+Vector(1,0,0) )
	ParticleManager:ReleaseParticleIndex( particle_2 ) 
	self:StartIntervalThink(FrameTime())
end

function modifier_hoodwink_acorn_shot_custom_thinker_tree:OnIntervalThink()
	if not IsServer() then return end
	AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility().tree_vision, FrameTime(), false )
	if self.tree:IsNull() then
		self:Destroy()
	end
end

function modifier_hoodwink_acorn_shot_custom_thinker_tree:OnDestroy()
if not IsServer() then return end
GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 10, true)
end


modifier_hoodwink_acorn_shot_custom_thinker_talent = class({})

function modifier_hoodwink_acorn_shot_custom_thinker_talent:OnCreated( kv )
	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.parent.first_hit = true

	self.speed_k = 1.3


	self.targets = {}
	self.projectile_speed = self.caster:GetProjectileSpeed()*self.speed_k
	self.bounces = self:GetAbility():GetSpecialValueFor( "bounce_count" )+1
	self.delay = self:GetAbility():GetSpecialValueFor( "bounce_delay" )
	self.range = self:GetAbility():GetSpecialValueFor( "bounce_range" )
	self.abilityDamageType = self:GetAbility():GetAbilityDamageType()
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	if self.caster:HasModifier("modifier_hoodwink_acorn_1") then 
		self.bounces = self.bounces + self:GetAbility().bounce_init + self:GetAbility().bounce_inc*self.caster:GetUpgradeStack("modifier_hoodwink_acorn_1")
	end

	self.info = {
		Ability = self.ability,	
		EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
		iMoveSpeed = self.projectile_speed,
		bDodgeable = true,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bVisibleToEnemies = true,
		bProvidesVision = true,
		iVisionRadius = 200,
		iVisionTeamNumber = self.caster:GetTeamNumber(),
		ExtraData = { thinker = self.parent:entindex(), hit = {} }
	}

	self:StartIntervalThink( 0 )
end

function modifier_hoodwink_acorn_shot_custom_thinker_talent:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_hoodwink_acorn_shot_custom_thinker_talent:OnIntervalThink()
	self.bounces = self.bounces-1
	if self.bounces<0 then
		self:Destroy()
		return
	end

	self:StartIntervalThink(-1)

	local first = 0
	if not self.first then
		self.first = true
		first = 1
		self.info.iMoveSpeed = self.projectile_speed
	else

		self.info.iMoveSpeed = self.caster:GetProjectileSpeed() / self.speed_k
	end
	if self.one_tree and self.two_tree then
		if self.one_tree:IsNull() or self.two_tree:IsNull() then self:Destroy() return end
		if self.target ~= self.one_tree and self.target ~= self.two_tree then
			self.target = self.two_tree
			self.source = self.one_tree
		elseif self.target == self.one_tree then
			self.target = self.two_tree
			self.source = self.one_tree
		elseif self.target == self.two_tree then
			self.target = self.one_tree
			self.source = self.two_tree
		end
	end
	self.info.Source = self.source
	self.info.Target = self.target
	self.info.ExtraData.first = first
	self.info.ExtraData.hit = {}
	self.targets = {}
	ProjectileManager:CreateTrackingProjectile( self.info )
	self.source:EmitSound("Hero_Hoodwink.AcornShot.Bounce")
end

function modifier_hoodwink_acorn_shot_custom_thinker_talent:Bounce()
	self:StartIntervalThink( self.delay )
end




modifier_hoodwink_acorn_shot_custom_armor_stack = class({})
function modifier_hoodwink_acorn_shot_custom_armor_stack:IsHidden() return true end
function modifier_hoodwink_acorn_shot_custom_armor_stack:IsPurgable() return false end
function modifier_hoodwink_acorn_shot_custom_armor_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_hoodwink_acorn_shot_custom_armor_stack:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end

function modifier_hoodwink_acorn_shot_custom_armor_stack:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_hoodwink_acorn_shot_custom_armor_count")

if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end


end

modifier_hoodwink_acorn_shot_custom_armor_count = class({})
function modifier_hoodwink_acorn_shot_custom_armor_count:IsHidden() return false end
function modifier_hoodwink_acorn_shot_custom_armor_count:IsPurgable() return false end
function modifier_hoodwink_acorn_shot_custom_armor_count:GetTexture() return "buffs/acorn_armor" end
function modifier_hoodwink_acorn_shot_custom_armor_count:OnCreated(table)
if IsServer() then 
	self:SetStackCount(1)
	self.RemoveForDuel = true
end

self.max = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_4", "max")
self.armor = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_4", "armor")
end



function modifier_hoodwink_acorn_shot_custom_armor_count:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()


if self:GetStackCount() >= self.max then 

	self:GetParent():EmitSound("Hoodwink.Acorn_armor")
 	self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

end


function modifier_hoodwink_acorn_shot_custom_armor_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}

end



function modifier_hoodwink_acorn_shot_custom_armor_count:GetModifierPhysicalArmorBonus()
if not self.armor then return end
return self.armor*self:GetStackCount()
end




modifier_hoodwink_acorn_shot_custom_armor_caster = class({})
function modifier_hoodwink_acorn_shot_custom_armor_caster:IsHidden() return false end
function modifier_hoodwink_acorn_shot_custom_armor_caster:IsPurgable() return false end
function modifier_hoodwink_acorn_shot_custom_armor_caster:GetTexture() return "buffs/acorn_armor" end
function modifier_hoodwink_acorn_shot_custom_armor_caster:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end



function modifier_hoodwink_acorn_shot_custom_armor_caster:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_acorn_shot_custom_armor_count", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_4", "armor_duration")})
end 




modifier_hoodwink_acorn_shot_custom_tracker = class({})
function modifier_hoodwink_acorn_shot_custom_tracker:IsHidden() return true end
function modifier_hoodwink_acorn_shot_custom_tracker:IsPurgable() return false end
function modifier_hoodwink_acorn_shot_custom_tracker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_hoodwink_acorn_shot_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ABILITY_START
}
end

function modifier_hoodwink_acorn_shot_custom_tracker:OnAbilityStart(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_hoodwink_acorn_5") then return end
if self:GetCaster():HasModifier("modifier_hoodwink_acorn_shot_custom_auto_cd") then return end
if not params.ability then return end
if not params.ability:GetCaster() then return end
if params.ability:GetCaster() == self:GetParent() then return end
if not params.target then return end
if params.target and params.target ~= self:GetParent() then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_acorn_shot_custom_auto_cd", {duration = self:GetAbility().stun_cd})

local caster = self:GetCaster()
local parent = self:GetParent()
local ability = self:GetAbility()


local projectile_speed = caster:GetProjectileSpeed()

self:GetCaster():EmitSound("Hero_Hoodwink.AcornShot.Cast")


self.info = 
{
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
		iMoveSpeed = projectile_speed,
		bDodgeable = true,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		bVisibleToEnemies = true,
		bProvidesVision = true,
		iVisionRadius = 200,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = {auto = true }
}

self.info.Source = caster
self.info.Target = params.unit
ProjectileManager:CreateTrackingProjectile( self.info )

end




modifier_hoodwink_acorn_shot_custom_auto_cd = class({})

function modifier_hoodwink_acorn_shot_custom_auto_cd:IsPurgable() return false end
function modifier_hoodwink_acorn_shot_custom_auto_cd:IsHidden() return false end
function modifier_hoodwink_acorn_shot_custom_auto_cd:IsDebuff() return true end
function modifier_hoodwink_acorn_shot_custom_auto_cd:RemoveOnDeath() return false end
function modifier_hoodwink_acorn_shot_custom_auto_cd:GetTexture()
  return "buffs/acorn_cd" end
function modifier_hoodwink_acorn_shot_custom_auto_cd:OnCreated(table)
  self.RemoveForDuel = true
end



modifier_hoodwink_acorn_shot_custom_range = class({})
function modifier_hoodwink_acorn_shot_custom_range:IsHidden() return false end
function modifier_hoodwink_acorn_shot_custom_range:IsPurgable() return false end
function modifier_hoodwink_acorn_shot_custom_range:GetTexture() return "buffs/acorn_range" end
function modifier_hoodwink_acorn_shot_custom_range:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_hoodwink_acorn_shot_custom_range:GetModifierAttackRangeBonus()
return self.range
end


function modifier_hoodwink_acorn_shot_custom_range:OnCreated()
self.range = self:GetCaster():GetTalentValue("modifier_hoodwink_acorn_6", "attack_range")
end