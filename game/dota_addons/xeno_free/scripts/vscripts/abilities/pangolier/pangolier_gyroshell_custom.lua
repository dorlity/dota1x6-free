LinkLuaModifier("modifier_pangolier_gyroshell_custom", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_tracker", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_heal", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_damage", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_dummy_thinker", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_stunned", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_stop", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_VERTICAL)
LinkLuaModifier("modifier_pangolier_rollup_custom", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_damage_cd", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_shard_damage_cd", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_turn_boost", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_legendary_cast", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_legendary", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_gyroshell_custom_legendary_target", "abilities/pangolier/pangolier_gyroshell_custom", LUA_MODIFIER_MOTION_NONE)



pangolier_gyroshell_custom = class({})

pangolier_gyroshell_custom.cd_inc = {-6, -8, -10}
pangolier_gyroshell_custom.cd_speed = {50, 75, 100}


pangolier_gyroshell_custom.damage_inc = {0.05, 0.075, 0.1}
pangolier_gyroshell_custom.damage_creeps = 0.33

pangolier_gyroshell_custom.heal_inc = {2, 3, 4}
pangolier_gyroshell_custom.heal_duration = 2


pangolier_gyroshell_custom.stack_damage = {6, 10}
pangolier_gyroshell_custom.stack_heal = {-5, -8}
pangolier_gyroshell_custom.stack_max = 6
pangolier_gyroshell_custom.stack_duration = 10

pangolier_gyroshell_custom.bkb_armor = 20
pangolier_gyroshell_custom.bkb_duration = 2

pangolier_gyroshell_custom.items_cd = 2
pangolier_gyroshell_custom.items_cd_creeps = 0.33
pangolier_gyroshell_custom.items_cast = -0.4




function pangolier_gyroshell_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0



if self:GetCaster():HasModifier("modifier_pangolier_rolling_3") then  
  upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_pangolier_rolling_3")]
end 

 return (self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown)

end

function pangolier_gyroshell_custom:GetCastPoint(iLevel)
local bonus = 0

if self:GetCaster():HasModifier('modifier_pangolier_rolling_6') then 
	bonus = self.items_cast
end

return self.BaseClass.GetCastPoint(self) + bonus
end








function pangolier_gyroshell_custom:GetIntrinsicModifierName()
return "modifier_pangolier_gyroshell_custom_tracker"
end


function pangolier_gyroshell_custom:OnAbilityPhaseStart()
local sound_cast = "Hero_Pangolier.Gyroshell.Cast"
local caster = self:GetCaster()

caster:EmitSound(sound_cast)



if self:GetCaster():HasModifier("modifier_pangolier_rolling_6") then 

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4, 1.5)
else 

	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
end

self.cast_effect = ParticleManager:CreateParticle("particles/pangolier/pangolier_gyroshell_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleControlEnt( self.cast_effect, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.cast_effect, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
ParticleManager:SetParticleControlForward( self.cast_effect, 0,  caster:GetForwardVector())
ParticleManager:SetParticleControlForward( self.cast_effect, 3,  caster:GetForwardVector())

return true
end

function pangolier_gyroshell_custom:OnAbilityPhaseInterrupted()

local caster = self:GetCaster()
ParticleManager:DestroyParticle(self.cast_effect, true)
ParticleManager:ReleaseParticleIndex(self.cast_effect)
	
caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
caster:StopSound("Hero_Pangolier.Gyroshell.Cast")
end




function pangolier_gyroshell_custom:DealDamage(enemy, legendary)

self.passive = self:GetCaster():FindAbilityByName("pangolier_lucky_shot_custom")

local legendary_ability = self:GetCaster():FindAbilityByName("pangolier_gyroshell_custom_legendary")

local mod = self:GetCaster():FindModifierByName("modifier_pangolier_gyroshell_custom")
local stun_duration = self:GetSpecialValueFor("stun_duration")
local knock_duration = self:GetSpecialValueFor("bounce_duration")

if enemy:IsHero() then 
	enemy:EmitSound("Hero_Pangolier.Gyroshell.Stun")
else 
	enemy:EmitSound("Hero_Pangolier.Gyroshell.Stun.Creep")
end
	

if self:GetCaster():HasModifier("modifier_pangolier_rolling_6") then 

	local cd = self.items_cd
	if enemy:IsCreep() then 
		cd = cd*self.items_cd_creeps
	end 

    self:GetCaster():CdItems(cd)
end


if self.passive and self.passive:GetLevel() > 0 then 
	self.passive:ProcPassive(enemy, false)
end

if self:GetCaster():HasModifier("modifier_pangolier_rolling_4") then 
	enemy:AddNewModifier(self:GetCaster(), self, "modifier_pangolier_gyroshell_custom_damage", {duration = self.stack_duration})
end

local damage = self:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_pangolier_rolling_1") then 

	local damage_inc = enemy:GetMaxHealth()*self.damage_inc[self:GetCaster():GetUpgradeStack("modifier_pangolier_rolling_1")]

	if enemy:IsCreep() then 
		damage_inc = damage_inc*self.damage_creeps
	end

	damage = damage + damage_inc
end

if legendary_ability and legendary then 
	damage = damage*legendary_ability:GetSpecialValueFor("damage_inc")/100
end 

local number = ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})

SendOverheadEventMessage(enemy, 4, enemy, number, nil)



if self:GetCaster():GetQuest() == "Pangolier.Quest_8" and enemy:IsRealHero() then 
	self:GetCaster():UpdateQuest(1)
end


if self:GetCaster():HasModifier("modifier_pangolier_gyroshell_custom_legendary") and mod and mod.target == nil and enemy:IsRealHero() and not legendary then 
	mod.target = enemy
	enemy:AddNewModifier(self:GetCaster(), legendary_ability, "modifier_pangolier_gyroshell_custom_legendary_target", {})
else 
	enemy:AddNewModifier(self:GetCaster(), self, "modifier_pangolier_gyroshell_custom_stunned", {duration = stun_duration*(1 - enemy:GetStatusResistance()) + knock_duration, legendary = legendary})
	enemy:AddNewModifier(self:GetCaster(), self, 'modifier_pangolier_gyroshell_custom_damage_cd', {duration = stun_duration + knock_duration})
end

end 



function pangolier_gyroshell_custom:RollUpDamage(new_radius)

local hit_radius = self:GetSpecialValueFor("hit_radius")

if new_radius then 
	hit_radius = new_radius
end

local mod = self:GetCaster():FindModifierByName("modifier_pangolier_gyroshell_custom")

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, hit_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
for _, enemy in pairs(enemies) do

	if (not enemy:HasModifier("modifier_pangolier_gyroshell_custom_damage_cd") or 
		(self:GetCaster():HasModifier("modifier_pangolier_gyroshell_custom_legendary") and not enemy:IsCreep() and mod and not mod.target )) 
		and not enemy:HasModifier("modifier_pangolier_gyroshell_custom_legendary_target") then
		


		self:DealDamage(enemy)
	end
end


end



function pangolier_gyroshell_custom:OnSpellStart()
if not IsServer() then return end
local duration = self:GetSpecialValueFor("duration")


self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)

ParticleManager:DestroyParticle(self.cast_effect, true)
ParticleManager:ReleaseParticleIndex(self.cast_effect)



local point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()

self:GetCaster():Purge(false, true, false, false, false)

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pangolier_gyroshell_custom", {duration = duration})
end






pangolier_gyroshell_stop_custom = class({})

function pangolier_gyroshell_stop_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():RemoveModifierByName("modifier_pangolier_gyroshell")
	self:GetCaster():RemoveModifierByName("modifier_pangolier_gyroshell_custom")
end











modifier_pangolier_gyroshell_custom = class({})

function modifier_pangolier_gyroshell_custom:IsPurgable() return false end
function modifier_pangolier_gyroshell_custom:IsHidden() return false end




function modifier_pangolier_gyroshell_custom:OnCreated()


self.max_speed = self:GetAbility():GetSpecialValueFor("forward_move_speed")

if self:GetCaster():HasModifier("modifier_pangolier_rolling_3") then 
	self.max_speed = self.max_speed + self:GetAbility().cd_speed[self:GetCaster():GetUpgradeStack('modifier_pangolier_rolling_3')]
end

self.legendary_ability = self:GetParent():FindAbilityByName("pangolier_gyroshell_custom_legendary")


if not IsServer() then return end

self.RemoveForDuel = true

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pangolier_gyroshell_custom_turn_boost", {duration = self:GetAbility():GetSpecialValueFor("jump_recover_time")})

self:GetParent():RemoveModifierByName("modifier_pangolier_gyroshell_custom_heal")

local shard = self:GetParent():FindModifierByName("modifier_pangolier_rollup_custom")

if shard then 
	shard.early_stop = true 
	shard:Destroy()

end

self:GetParent():Stop()

self.bkb_mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_debuff_immune", {})

self.cast_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_gyroshell.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt( self.cast_effect, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
self:AddParticle(self.cast_effect,false, false, -1, false, false)


if self:GetCaster():HasModifier("modifier_pangolier_rolling_5") then 
	self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect,false, false, -1, false, false)
end 


self:GetParent():EmitSound("Hero_Pangolier.Gyroshell.Loop")
self:GetParent():EmitSound("Hero_Pangolier.Gyroshell.Layer")


self.main = self:GetAbility():GetName()
self.stop = self:GetParent():FindAbilityByName("pangolier_gyroshell_stop_custom")

self:GetParent():SwapAbilities(self.main, self.stop:GetName(), false, true)



if self:GetParent():HasAbility("pangolier_gyroshell_custom_legendary") then 
	self:GetParent():FindAbilityByName("pangolier_gyroshell_custom_legendary"):SetActivated(true)
end 

if self:GetParent():HasModifier("modifier_pangolier_rolling_7") and self:GetParent():HasModifier("modifier_pangolier_lucky_7") then
	self:GetParent():SwapAbilities("pangolier_heartpiercer_custom", "pangolier_gyroshell_custom_legendary", false, true)
end




local jump = self:GetParent():FindAbilityByName("pangolier_shield_crash_custom")

if jump and jump:GetLevel() > 0 then 

	local cd = jump:GetCooldownTimeRemaining()

	if cd > self:GetAbility():GetSpecialValueFor("crash_cd") then 
		jump:EndCooldown()
		jump:StartCooldown(self:GetAbility():GetSpecialValueFor("crash_cd"))
	end

end

self.target = nil

local hAbility = self:GetAbility()


self.acceleration = 350
self.deceleration = 500

self.turn_rate_min = self:GetAbility():GetSpecialValueFor("turn_rate")
self.turn_rate_max = self:GetAbility():GetSpecialValueFor("turn_rate")

self.flCurrentSpeed = self.max_speed

self.flDespawnTime = 0.5
self.nTreeDestroyRadius = 75
self.bMaxSpeedNotified = false
self.bCrashScheduled = false
self.hCrashScheduledUnit = nil

if self:GetParent().flDesiredYaw == nil then
	self:GetParent().flDesiredYaw = self:GetParent():GetAnglesAsVector().y
end


self:StartIntervalThink( 0.01 )


end



function modifier_pangolier_gyroshell_custom:OnDestroy()
if not IsServer() then return end

if self.bkb_mod and not self.bkb_mod:IsNull() then 
	self.bkb_mod:Destroy()
end

if not self:GetParent():HasModifier("modifier_generic_arc") then
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
end 


if not self.early_stop then 
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
	self:GetParent():EmitSound("Hero_Pangolier.Gyroshell.Stop")

	if self:GetParent():HasModifier("modifier_pangolier_rolling_5") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_debuff_immune", {duration = self:GetAbility().bkb_duration, effect = 1})
	end
end
 
if self.target and not self.target:IsNull() and self.target:IsAlive() then 
	local mod = self.target:FindModifierByName("modifier_pangolier_gyroshell_custom_legendary_target")
	if mod then 
		mod:Destroy()
	end 

	self.target = nil 
end 


self:GetParent():RemoveModifierByName("modifier_pangolier_gyroshell_custom_legendary")

self:GetParent():StopSound("Hero_Pangolier.Gyroshell.Loop")
self:GetParent():StopSound("Hero_Pangolier.Gyroshell.Layer")

local mod = self:GetParent():FindModifierByName("modifier_pangolier_rolling_3")

self.main = self:GetAbility():GetName()


self:GetParent():SwapAbilities(self.stop:GetName(), self.main, false, true)


if self:GetParent():HasModifier("modifier_pangolier_rolling_7") and self:GetParent():HasModifier("modifier_pangolier_lucky_7")  then 
	self:GetParent():SwapAbilities("pangolier_heartpiercer_custom", "pangolier_gyroshell_custom_legendary", true , false)
	
end

if self:GetParent():HasAbility("pangolier_gyroshell_custom_legendary") then 
	self:GetParent():FindAbilityByName("pangolier_gyroshell_custom_legendary"):SetActivated(false)
end 



if self:GetParent():HasModifier("modifier_pangolier_rolling_2") or self:GetParent():HasModifier("modifier_pangolier_rolling_5") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pangolier_gyroshell_custom_heal", {duration = self:GetAbility().heal_duration})
end

end



function modifier_pangolier_gyroshell_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MODEL_CHANGE,
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    MODIFIER_PROPERTY_DISABLE_TURNING,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_pangolier_gyroshell_custom:GetModifierHealthRegenPercentage()
if not self:GetCaster():HasModifier("modifier_pangolier_rolling_2") then return end 

return self:GetAbility().heal_inc[self:GetCaster():GetUpgradeStack("modifier_pangolier_rolling_2")]
end

function modifier_pangolier_gyroshell_custom:GetModifierPhysicalArmorBonus()
if not self:GetCaster():HasModifier("modifier_pangolier_rolling_5") then return end 

return self:GetAbility().bkb_armor
end




function modifier_pangolier_gyroshell_custom:GetModifierModelChange()
return "models/heroes/pangolier/pangolier_gyroshell2.vmdl"
end

function modifier_pangolier_gyroshell_custom:GetOverrideAnimation()
return ACT_DOTA_RUN
end



function modifier_pangolier_gyroshell_custom:GetModifierMoveSpeed_Absolute()
if not IsClient() then return end

self.max_speed = self:GetAbility():GetSpecialValueFor("forward_move_speed")

if self:GetCaster():HasModifier("modifier_pangolier_rolling_3") then 
	self.max_speed = self.max_speed + self:GetAbility().cd_speed[self:GetCaster():GetUpgradeStack('modifier_pangolier_rolling_3')]
end

if self:GetCaster():HasModifier("modifier_pangolier_gyroshell_custom_legendary") and self.legendary_ability then 
	self.max_speed = self.legendary_ability:GetSpecialValueFor("cast_speed")
end

return self.max_speed
end



function modifier_pangolier_gyroshell_custom:CheckState()
	local state = 
	{
		[ MODIFIER_STATE_DISARMED ] = true,
	}
	return state
end

function modifier_pangolier_gyroshell_custom:GetModifierDisableTurning( params )
	return 1
end


function modifier_pangolier_gyroshell_custom:OnIntervalThink()

self.max_speed = self:GetAbility():GetSpecialValueFor("forward_move_speed")

if self:GetCaster():HasModifier("modifier_pangolier_rolling_3") then 
	self.max_speed = self.max_speed + self:GetAbility().cd_speed[self:GetCaster():GetUpgradeStack('modifier_pangolier_rolling_3')]
end

if self:GetCaster():HasModifier("modifier_pangolier_gyroshell_custom_legendary") and self.legendary_ability then 
	self.max_speed = self.legendary_ability:GetSpecialValueFor("cast_speed")
end


self.flCurrentSpeed = self.max_speed


self.turn_rate_min = self:GetAbility():GetSpecialValueFor("turn_rate")


if self:GetParent():HasModifier("modifier_pangolier_gyroshell_custom_turn_boost") or self:GetCaster():HasModifier("modifier_pangolier_gyroshell_custom_legendary") then 
	self.turn_rate_min = self:GetAbility():GetSpecialValueFor("turn_rate_boosted")
end


self.turn_rate_max = self.turn_rate_min


if not IsServer() then return end

self:GetParent():SetForceAttackTarget(nil)
self:GetParent():Stop()


if not self:GetParent():HasModifier("modifier_generic_arc") then 
	self:GetAbility():RollUpDamage()
end 

if self:GetParent():HasModifier("modifier_pangolier_gyroshell_custom_legendary_cast") then 
	return
end
self:UpdateHorizontalMotionCustom(self:GetParent(), 0.01)

end




function modifier_pangolier_gyroshell_custom:OnOrderCustom( new_pos, target )
if not IsServer() then return end

local vTargetPos = new_pos
if target ~= nil and target:IsNull() == false then
	vTargetPos = target:GetAbsOrigin()
end

local vMountOrigin = self:GetParent():GetOrigin()
if self.angle_correction ~= nil and self.angle_correction > 0 then
	local flOrderDist = (vMountOrigin - vTargetPos):Length2D()
	vMountOrigin = vMountOrigin + self:GetParent():GetForwardVector() * math.min(self.angle_correction, flOrderDist * 0.75)
end

local vDir = vTargetPos - vMountOrigin
vDir.z = 0
vDir = vDir:Normalized()
local angles = VectorAngles( vDir )
self:GetParent().flDesiredYaw = angles.y

end





function modifier_pangolier_gyroshell_custom:UpdateHorizontalMotionCustom( me, dt )
if not IsServer() or not self:GetParent() then return end

if self:GetParent():IsCurrentlyHorizontalMotionControlled() or self:GetParent():IsCurrentlyVerticalMotionControlled() 
 	or self:GetParent():IsStunned() or self:GetParent():IsRooted() then 
	self:UpdateTarget()	
	return
end 


if self:GetParent():HasModifier("modifier_pangolier_gyroshell_custom_stop") then return end

if self.bCrashScheduled then
	self:Crash( self.hCrashScheduledUnit )
	return
end

local curAngles = self:GetParent():GetAnglesAsVector()
local flAngleDiff = AngleDiff( self:GetParent().flDesiredYaw, curAngles.y ) or 0
local flTurnAmount = dt * ( self.turn_rate_min + self:GetSpeedMultiplier() * ( self.turn_rate_max - self.turn_rate_min ) )

if self.flLastCrashTime ~= nil and GameRules:GetDOTATime(false, true) - self.flLastCrashTime <= 2.0 then
	flTurnAmount = flTurnAmount * 1.5
end

flTurnAmount = math.min( flTurnAmount, math.abs( flAngleDiff ) )

if flAngleDiff < 0.0 then
	flTurnAmount = flTurnAmount * -1
end

if flAngleDiff ~= 0.0 then
	curAngles.y = curAngles.y + flTurnAmount
	me:SetAbsAngles( curAngles.x, curAngles.y, curAngles.z )
end

local flMaxSpeed = self.max_speed

local flAcceleration = self.acceleration or -self.deceleration

self.flCurrentSpeed = math.max( math.min( self.flCurrentSpeed + ( dt * flAcceleration ), flMaxSpeed ), 0 )

local vNewPos = self:GetParent():GetOrigin() + self:GetParent():GetForwardVector() *( ( dt * self.flCurrentSpeed ))

local range_vector = self:GetParent():GetForwardVector()
local check_pos = vNewPos + range_vector

if not GridNav:CanFindPath( me:GetOrigin(), check_pos ) then
	GridNav:DestroyTreesAroundPoint( check_pos, self.nTreeDestroyRadius, true )

	if GridNav:CanFindPath( me:GetOrigin(), check_pos ) then
		self:Crash( nil, true )
	else
		self:Crash()
		return
	end
end

me:SetOrigin(GetGroundPosition( vNewPos , me))

self:UpdateTarget()



end



function modifier_pangolier_gyroshell_custom:UpdateTarget()
if not IsServer() then return end

if self.target and not self.target:IsNull() and self.target:IsAlive() and self:GetParent():HasModifier("modifier_pangolier_gyroshell_custom_legendary") then 
	self.point = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*100

	self.target:SetAbsOrigin(self.point)
	self.target:FaceTowards(self:GetParent():GetAbsOrigin())

else 
	if self.target then 
		self.target:RemoveModifierByName("modifier_pangolier_gyroshell_custom_legendary_target")
	end 
	self.target = nil 
end

end 



function modifier_pangolier_gyroshell_custom:ScheduleCrash( hHitUnit )
	self.bCrashScheduled = true
	self.hCrashScheduledUnit = hHitUnit
end

function modifier_pangolier_gyroshell_custom:Crash( hHitUnit, bHitTree )
	if bHitTree == nil then bHitTree = false end

	if not bHitTree then
		if self.flLastCrashTime ~= nil and GameRules:GetDOTATime(false, true) - self.flLastCrashTime <= 0.1 then
			if self.hLastCrashUnit ~= nil and self.hLastCrashUnit == hHitUnit then
				return
			elseif self.hLastCrashUnit == nil and hHitUnit == nil then
				return
			end
		end
		self.flLastCrashTime = GameRules:GetDOTATime(false, true)
		self.hLastCrashUnit = hHitUnit
	end

	if not bHitTree then
		local resetDistance = 0
		local vResetPos = self:GetParent():GetAbsOrigin() 
		local vAngles = self:GetParent():GetAngles()
		

		local old_vec = self:GetParent():GetForwardVector()

		self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() - old_vec)
		self:GetParent():SetForwardVector(old_vec*-1)
		self:GetParent():SetOrigin( vResetPos )
		--FindClearSpaceForUnit( self:GetParent(), vResetPos, false )
		self:GetParent().flDesiredYaw = self:GetParent():GetAnglesAsVector().y

		self:GetParent():EmitSound("Hero_Pangolier.Gyroshell.Carom")
		self:GetParent():EmitSound("Hero_Pangolier.Carom.Layer")

				
		if self.target and not self.target:IsNull() and self.target:IsAlive() then 
			local mod = self.target:FindModifierByName("modifier_pangolier_gyroshell_custom_legendary_target")
			if mod then 
				mod.deal_damage = true

		    local particle = ParticleManager:CreateParticle("particles/pangolier/buckle_refresh.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		    ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
		    ParticleManager:ReleaseParticleIndex(particle)


		    self:GetCaster():EmitSound("Hero_Rattletrap.Overclock.Cast")


				self:SetDuration(self:GetRemainingTime() + self.legendary_ability:GetSpecialValueFor("ulti_duration"), true)
				mod:Destroy()
			end 

			self.target = nil 
		end 

		self:GetParent():RemoveModifierByName("modifier_pangolier_gyroshell_custom_legendary")
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pangolier_gyroshell_custom_stop", {duration = self:GetAbility():GetSpecialValueFor("jump_recover_time")})
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pangolier_gyroshell_custom_turn_boost", {duration = 2*self:GetAbility():GetSpecialValueFor("jump_recover_time")})
	end
	
	self.bCrashScheduled = false
	self.hCrashScheduledUnit = nil
end

function modifier_pangolier_gyroshell_custom:GetSpeedMultiplier()
	return 0.5 + 0.5 * (self.flCurrentSpeed / self.max_speed)
end










modifier_pangolier_gyroshell_custom_tracker = class({})

function modifier_pangolier_gyroshell_custom_tracker:IsHidden() return true end
function modifier_pangolier_gyroshell_custom_tracker:IsPurgable() return false end
function modifier_pangolier_gyroshell_custom_tracker:DeclareFunctions()
return
{
}
end







modifier_pangolier_gyroshell_custom_heal = class({})
function modifier_pangolier_gyroshell_custom_heal:IsHidden() return false end
function modifier_pangolier_gyroshell_custom_heal:IsPurgable() return false end
function modifier_pangolier_gyroshell_custom_heal:GetTexture() return "buffs/rolling_heal" end
function modifier_pangolier_gyroshell_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, 
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_pangolier_gyroshell_custom_heal:GetModifierHealthRegenPercentage()
if not self:GetParent():HasModifier("modifier_pangolier_rolling_2") then return end 

return self:GetAbility().heal_inc[self:GetCaster():GetUpgradeStack("modifier_pangolier_rolling_2")]
end


function modifier_pangolier_gyroshell_custom_heal:GetModifierPhysicalArmorBonus()
if not self:GetParent():HasModifier("modifier_pangolier_rolling_5") then return end 

return self:GetAbility().bkb_armor
end

function modifier_pangolier_gyroshell_custom_heal:OnCreated()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_pangolier_rolling_5") then 
	self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect,false, false, -1, false, false)
end 

if self:GetCaster():HasModifier("modifier_pangolier_rolling_2") then 
	self.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect,false, false, -1, false, false)
end 


end 




modifier_pangolier_gyroshell_custom_damage = class({})
function modifier_pangolier_gyroshell_custom_damage:IsHidden() return false end
function modifier_pangolier_gyroshell_custom_damage:IsPurgable() return false end 
function modifier_pangolier_gyroshell_custom_damage:GetTexture() return "buffs/rolling_damage" end
function modifier_pangolier_gyroshell_custom_damage:OnCreated(table)

self.damage = self:GetAbility().stack_damage[self:GetCaster():GetUpgradeStack("modifier_pangolier_rolling_4")]
self.heal = self:GetAbility().stack_heal[self:GetCaster():GetUpgradeStack("modifier_pangolier_rolling_4")]
self.max = self:GetAbility().stack_max

if not IsServer() then return end


local particle_cast = "particles/pangolier/rolling_stack.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)

end

function modifier_pangolier_gyroshell_custom_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

end


function modifier_pangolier_gyroshell_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
   	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end




function modifier_pangolier_gyroshell_custom_damage:GetModifierIncomingDamage_Percentage()
return self:GetStackCount()*self.damage
end

function modifier_pangolier_gyroshell_custom_damage:GetModifierLifestealRegenAmplify_Percentage() 
return self:GetStackCount()*self.heal
end

function modifier_pangolier_gyroshell_custom_damage:GetModifierHealAmplify_PercentageTarget() 
return self:GetStackCount()*self.heal
end

function modifier_pangolier_gyroshell_custom_damage:GetModifierHPRegenAmplify_Percentage() 
return self:GetStackCount()*self.heal
end



function modifier_pangolier_gyroshell_custom_damage:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if self.effect_cast then 
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end

end















modifier_pangolier_gyroshell_custom_stunned = class({})

function modifier_pangolier_gyroshell_custom_stunned:OnCreated(table)
if not IsServer() then return end


local direction = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
local distance = self:GetAbility():GetSpecialValueFor("knockback_radius")


if table.legendary then 
	direction = direction*-1
	distance = distance*2
end 


local mod = self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(),
"modifier_generic_knockback",
{	
direction_x = direction.x,
direction_y = direction.y,
distance = distance,
height = self:GetAbility():GetSpecialValueFor("knockback_radius"),	
duration = self:GetAbility():GetSpecialValueFor("bounce_duration"),
IsStun = true,
IsFlail = true,
})

local particle_stomp_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, self:GetParent())
ParticleManager:SetParticleControl(particle_stomp_fx, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(300, 1, 1))
ParticleManager:SetParticleControl(particle_stomp_fx, 2, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_stomp_fx)

self.cast_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_blast_off_trail.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt( self.cast_effect, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.cast_effect, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )


mod:AddParticle( self.cast_effect, false, false, -1, false, false  )

self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("bounce_duration"))
end



function modifier_pangolier_gyroshell_custom_stunned:OnIntervalThink()
if not IsServer() then return end

self:GetParent():RemoveGesture(ACT_DOTA_FLAIL)
self:GetParent():StartGesture(ACT_DOTA_DISABLED)

self:StartIntervalThink(-1)
end

function modifier_pangolier_gyroshell_custom_stunned:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true
}
end


function modifier_pangolier_gyroshell_custom_stunned:OnDestroy()
if not IsServer() then return end 

self:GetParent():FadeGesture(ACT_DOTA_DISABLED)
end



function modifier_pangolier_gyroshell_custom_stunned:GetEffectName()
return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_pangolier_gyroshell_custom_stunned:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end








modifier_pangolier_gyroshell_custom_stop = class({})

function modifier_pangolier_gyroshell_custom_stop:IsHidden() return true end
function modifier_pangolier_gyroshell_custom_stop:IsPurgable() return false end 

function modifier_pangolier_gyroshell_custom_stop:OnCreated(table)
if not IsServer() then return end

self.abs = self:GetParent():GetAbsOrigin()
self.interrupted = false 

self.dir = self:GetParent():GetForwardVector()

self:SetJumpParameters(
	{
		dir_x = self.dir.x,
		dir_y = self.dir.y,
		duration = self:GetRemainingTime(),
		distance = 0,
		height = 50,
		fix_end = true,
		isStun = false,
		isForward = true,
	})

if not self:ApplyVerticalMotionController() then
	self.interrupted = true
	self:Destroy()
end

end


function modifier_pangolier_gyroshell_custom_stop:OnDestroy()
if not IsServer() then return end 

self:GetParent():RemoveVerticalMotionController( self )
self:GetParent():SetAbsOrigin(self.abs)
end


function modifier_pangolier_gyroshell_custom_stop:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end


function modifier_pangolier_gyroshell_custom_stop:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end





function modifier_pangolier_gyroshell_custom_stop:UpdateVerticalMotion( me, dt )
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



function modifier_pangolier_gyroshell_custom_stop:OnVerticalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_pangolier_gyroshell_custom_stop:SetJumpParameters( kv )
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



function modifier_pangolier_gyroshell_custom_stop:InitVerticalArc( height_start, height_max, height_end, duration )
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

function modifier_pangolier_gyroshell_custom_stop:GetVerticalPos( time )
	return self.const1*time - self.const2*time*time
end

function modifier_pangolier_gyroshell_custom_stop:GetVerticalSpeed( time )
	return self.const1 - 2*self.const2*time
end

function modifier_pangolier_gyroshell_custom_stop:SetEndCallback( func )
	self.endCallback = func
end









modifier_pangolier_gyroshell_custom_damage_cd = class({})
function modifier_pangolier_gyroshell_custom_damage_cd:IsHidden() return true end
function modifier_pangolier_gyroshell_custom_damage_cd:IsPurgable() return false end
































pangolier_rollup_custom = class({})

function pangolier_rollup_custom:GetBehavior()


if self:GetCaster():HasModifier("modifier_pangolier_gyroshell_custom") and self:GetCaster():HasShard() then 
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET +  DOTA_ABILITY_BEHAVIOR_HIDDEN
end



function pangolier_rollup_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()

caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 3)

self.cast_effect = ParticleManager:CreateParticle("particles/pangolier/pangolier_gyroshell_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleControlEnt( self.cast_effect, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.cast_effect, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
ParticleManager:SetParticleControlForward( self.cast_effect, 0,  caster:GetForwardVector())
ParticleManager:SetParticleControlForward( self.cast_effect, 3,  caster:GetForwardVector())

return true
end


function  pangolier_rollup_custom:OnAbilityPhaseInterrupted()

local caster = self:GetCaster()

if self.cast_effect then 
	ParticleManager:DestroyParticle(self.cast_effect, true)
	ParticleManager:ReleaseParticleIndex(self.cast_effect)
end

caster:FadeGesture(ACT_DOTA_CAST_ABILITY_4)

end






function pangolier_rollup_custom:OnSpellStart()
if not IsServer() then return end


self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)

if self.cast_effect then 
	ParticleManager:DestroyParticle(self.cast_effect, true)
	ParticleManager:ReleaseParticleIndex(self.cast_effect)
end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pangolier_rollup_custom", {duration = self:GetSpecialValueFor("duration")})
end








modifier_pangolier_rollup_custom = class({})

function modifier_pangolier_rollup_custom:IsPurgable() return false end
function modifier_pangolier_rollup_custom:IsPurgeException() return false end
function modifier_pangolier_rollup_custom:OnCreated()
if not IsServer() then return end

self:GetParent():Stop()

self.old_duration = nil
self.ability = self:GetCaster():FindAbilityByName("pangolier_gyroshell_custom")
local modifier = self:GetCaster():FindModifierByName("modifier_pangolier_gyroshell_custom")

if modifier then
	self.old_duration = modifier:GetRemainingTime()

	modifier.early_stop = true
	modifier:Destroy()
end

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_shard_rollup_cast_dust_poof.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
ParticleManager:ReleaseParticleIndex(hit_effect)


self:GetParent():SwapAbilities("pangolier_rollup_custom", "pangolier_rollup_stop_custom", false, true)
self.parent = self:GetParent()

if self:GetParent():HasAbility("pangolier_rollup_stop_custom") then 
	self:GetParent():FindAbilityByName("pangolier_rollup_stop_custom"):StartCooldown(0.5)
end 

self.turn_rate = self:GetAbility():GetSpecialValueFor("turn_rate_boosted")

local first_point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 100
self:SetDirection( Vector(first_point.x, first_point.y, 0) ) 
self.current_dir = self.target_dir
self.turn_speed = FrameTime()*self.turn_rate
self.proj_time = 0

self.bkb_mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_debuff_immune", {effect = 1, duration = self:GetRemainingTime()})

self:GetParent():StartGesture(ACT_DOTA_SPAWN)
self:GetParent():EmitSound("Hero_Pangolier.Gyroshell.Layer")

self:StartIntervalThink(FrameTime())
self:OnIntervalThink()
end

function modifier_pangolier_rollup_custom:DeclareFunctions()
	return
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_EVENT_ON_ORDER,
        MODIFIER_PROPERTY_DISABLE_TURNING,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end



function modifier_pangolier_rollup_custom:GetOverrideAnimation()
return ACT_DOTA_IDLE
end


function modifier_pangolier_rollup_custom:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker == self:GetParent() then return end
if params.target ~= self:GetParent() then return end
if self:GetParent():HasModifier("modifier_pangolier_gyroshell_custom_shard_damage_cd") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pangolier_gyroshell_custom_shard_damage_cd", {duration = self:GetAbility():GetSpecialValueFor("damage_cd")})

self:GetCaster():RemoveGesture(ACT_DOTA_SPAWN)
self:GetParent():StartGesture(ACT_DOTA_SPAWN)

local smash = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(smash, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:DestroyParticle(smash, false)
ParticleManager:ReleaseParticleIndex(smash)


self.ability:RollUpDamage(self:GetAbility():GetSpecialValueFor("hit_radius"))
end

function modifier_pangolier_rollup_custom:OnDestroy()
if not IsServer() then return end

self:GetCaster():RemoveGesture(ACT_DOTA_SPAWN)

if self.bkb_mod and not self.bkb_mod:IsNull() then 
	self.bkb_mod:Destroy()
end

self:GetParent():StopSound("Hero_Pangolier.Gyroshell.Layer")

if not self.early_stop and self.old_duration == nil then 
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4_END)
	self:GetParent():EmitSound("Hero_Pangolier.Gyroshell.Stop")
end


if self.old_duration ~= nil then
	self:GetCaster():AddNewModifier(self:GetCaster(), self.ability, "modifier_pangolier_gyroshell_custom", {duration = self.old_duration})
end
self:GetParent():SwapAbilities("pangolier_rollup_stop_custom", "pangolier_rollup_custom", false, true)
end

function modifier_pangolier_rollup_custom:GetModifierModelChange()
return "models/heroes/pangolier/pangolier_gyroshell2.vmdl"
end

function modifier_pangolier_rollup_custom:GetModifierMoveSpeed_Limit()
    return 0.1
end

function modifier_pangolier_rollup_custom:GetModifierDisableTurning()
    return 1
end

function modifier_pangolier_rollup_custom:OnOrder( params )
    if params.unit~=self:GetParent() then return end
    if  params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
        params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
    then
        self:SetDirection( params.new_pos )
    elseif 
        params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
        params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
    then
        self:SetDirection( params.target:GetOrigin() )
    end
end

function modifier_pangolier_rollup_custom:SetDirection( vec )
    if vec.x == self:GetCaster():GetAbsOrigin().x and vec.y == self:GetCaster():GetAbsOrigin().y then 
        vec = self:GetCaster():GetAbsOrigin() + 100*self:GetCaster():GetForwardVector()
    end
    self.target_dir = ((vec-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
    self.face_target = false
end

function modifier_pangolier_rollup_custom:OnIntervalThink()
    if not IsServer() then return end
    self:TurnLogic()
end

function modifier_pangolier_rollup_custom:CheckState()
return
{
		[ MODIFIER_STATE_DISARMED ] = true,
}
end

function modifier_pangolier_rollup_custom:TurnLogic()
    if self.face_target then return end
    local current_angle = VectorToAngles( self.current_dir ).y
    local target_angle = VectorToAngles( self.target_dir ).y
    local angle_diff = AngleDiff( current_angle, target_angle )
    local sign = -1
    if angle_diff<0 then sign = 1 end
    if math.abs( angle_diff )<1.1*self.turn_speed then
        self.current_dir = self.target_dir
        self.face_target = true
    else
        self.current_dir = RotatePosition( Vector(0,0,0), QAngle(0, sign*self.turn_speed, 0), self.current_dir )
    end
    local a = self.parent:IsCurrentlyHorizontalMotionControlled()
    local b = self.parent:IsCurrentlyVerticalMotionControlled()
    if not (a or b) then
        self.parent:SetForwardVector( self.current_dir )
    end
end

pangolier_rollup_stop_custom = class({})
function pangolier_rollup_stop_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():RemoveModifierByName("modifier_pangolier_rollup_custom")
end



modifier_pangolier_gyroshell_custom_shard_damage_cd = class({})
function modifier_pangolier_gyroshell_custom_shard_damage_cd:IsHidden() return true end
function modifier_pangolier_gyroshell_custom_shard_damage_cd:IsPurgable() return false end



modifier_pangolier_gyroshell_custom_turn_boost = class({})
function modifier_pangolier_gyroshell_custom_turn_boost:IsHidden() return true end
function modifier_pangolier_gyroshell_custom_turn_boost:IsPurgable() return false end









pangolier_gyroshell_custom_legendary = class({})

function pangolier_gyroshell_custom_legendary:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Pango.Ulti_legendary")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pangolier_gyroshell_custom_legendary_cast", {duration = self:GetSpecialValueFor("cast_duration")})
end


modifier_pangolier_gyroshell_custom_legendary_cast = class({})
function modifier_pangolier_gyroshell_custom_legendary_cast:IsHidden() return true end
function modifier_pangolier_gyroshell_custom_legendary_cast:IsPurgable() return false end
function modifier_pangolier_gyroshell_custom_legendary_cast:OnCreated(table)
if not IsServer() then return end

local mod = self:GetCaster():FindModifierByName("modifier_pangolier_gyroshell_custom")
self.ability = self:GetParent():FindAbilityByName("pangolier_gyroshell_custom")

self.no_mod = false 


if not mod then 
	self.no_mod = true
	self:Destroy()
	return
end


self.bkb_mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_debuff_immune", {})

self.ulti_time = mod:GetRemainingTime()
mod.early_stop = true

mod:Destroy()

self:GetCaster():StartGesture(ACT_DOTA_SPAWN)


self.effect_cast = ParticleManager:CreateParticle( "particles/beast_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
self:AddParticle( self.effect_cast, false, false, -1, false, false )

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_chargeup.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
self:AddParticle( effect_cast, false, false, -1, false, false )

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_shard_rollup_cast_dust_poof.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
ParticleManager:ReleaseParticleIndex(hit_effect)

self.parent = self:GetParent()

self.turn_rate = self:GetAbility():GetSpecialValueFor("turn_rate")

local first_point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 100
self:SetDirection( Vector(first_point.x, first_point.y, 0) ) 
self.current_dir = self.target_dir
self.turn_speed = 0.01*self.turn_rate

self:GetParent():EmitSound("Hero_Pangolier.Gyroshell.Layer")

self:StartIntervalThink(0.01)
self:OnIntervalThink()
end



function modifier_pangolier_gyroshell_custom_legendary_cast:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
	[ MODIFIER_STATE_DISARMED ] = true,
}

end
function modifier_pangolier_gyroshell_custom_legendary_cast:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_EVENT_ON_ORDER,
        MODIFIER_PROPERTY_DISABLE_TURNING,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}
end

function modifier_pangolier_gyroshell_custom_legendary_cast:GetModifierModelChange()
return "models/heroes/pangolier/pangolier_gyroshell2.vmdl"
end

function modifier_pangolier_gyroshell_custom_legendary_cast:GetModifierMoveSpeed_Limit()
    return 0.1
end

function modifier_pangolier_gyroshell_custom_legendary_cast:GetModifierDisableTurning()
    return 1
end

function modifier_pangolier_gyroshell_custom_legendary_cast:OnOrder( params )
    if params.unit~=self:GetParent() then return end
    if  params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
        params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
    then
        self:SetDirection( params.new_pos )
    elseif 
        params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
        params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
    then
        self:SetDirection( params.target:GetOrigin() )
    end
end

function modifier_pangolier_gyroshell_custom_legendary_cast:SetDirection( vec )
    if vec.x == self:GetCaster():GetAbsOrigin().x and vec.y == self:GetCaster():GetAbsOrigin().y then 
        vec = self:GetCaster():GetAbsOrigin() + 100*self:GetCaster():GetForwardVector()
    end
    self.target_dir = ((vec-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
    self.face_target = false
end

function modifier_pangolier_gyroshell_custom_legendary_cast:OnIntervalThink()
    if not IsServer() then return end
    self:TurnLogic()
end

function modifier_pangolier_gyroshell_custom_legendary_cast:TurnLogic()
    if self.face_target then return end
    local current_angle = VectorToAngles( self.current_dir ).y
    local target_angle = VectorToAngles( self.target_dir ).y
    local angle_diff = AngleDiff( current_angle, target_angle )
    local sign = -1
    if angle_diff<0 then sign = 1 end
    if math.abs( angle_diff )<1.1*self.turn_speed then
        self.current_dir = self.target_dir
        self.face_target = true
    else
        self.current_dir = RotatePosition( Vector(0,0,0), QAngle(0, sign*self.turn_speed, 0), self.current_dir )
    end
    local a = self.parent:IsCurrentlyHorizontalMotionControlled()
    local b = self.parent:IsCurrentlyVerticalMotionControlled()
    if not (a or b) then
        self.parent:SetForwardVector( self.current_dir )
    end
	if self.effect_cast then 
		local target_pos = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*500
		ParticleManager:SetParticleControl( self.effect_cast, 1, target_pos )

	end
end





function modifier_pangolier_gyroshell_custom_legendary_cast:OnDestroy()
if not IsServer() then return end 
if self.no_mod == true then return end

if self.bkb_mod and not self.bkb_mod:IsNull() then 
	self.bkb_mod:Destroy()
end

self:GetParent():StopSound("Hero_Pangolier.Gyroshell.Layer")


self:GetCaster():AddNewModifier(self:GetCaster(), self.ability, "modifier_pangolier_gyroshell_custom", {duration = self.ulti_time})

self:GetCaster():EmitSound("Pango.Ulti_legendary_cast")

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_gyroshell_custom_legendary", {duration = self:GetAbility():GetSpecialValueFor("duration")})
end











modifier_pangolier_gyroshell_custom_legendary = class({})
function modifier_pangolier_gyroshell_custom_legendary:IsHidden() return false end
function modifier_pangolier_gyroshell_custom_legendary:IsPurgable() return false end

function modifier_pangolier_gyroshell_custom_legendary:GetEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
end

function modifier_pangolier_gyroshell_custom_legendary:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_pangolier_gyroshell_custom_legendary:OnCreated(table)
if not IsServer() then return end 

self.cast_effect = ParticleManager:CreateParticle("particles/lc_odd_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.cast_effect,false, false, -1, false, false)


end 




modifier_pangolier_gyroshell_custom_legendary_target = class({})
function modifier_pangolier_gyroshell_custom_legendary_target:IsHidden() return true end 
function modifier_pangolier_gyroshell_custom_legendary_target:IsPurgable() return false end
function modifier_pangolier_gyroshell_custom_legendary_target:OnCreated(table)
if not IsServer() then return end 

self.caster = self:GetCaster()

self:GetParent():FaceTowards(self.caster:GetAbsOrigin())

self:GetParent():RemoveModifierByName("modifier_pangolier_gyroshell_custom_stunned")

self.ability = self:GetCaster():FindAbilityByName("pangolier_gyroshell_custom")
end 


function modifier_pangolier_gyroshell_custom_legendary_target:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}

end 


function modifier_pangolier_gyroshell_custom_legendary_target:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_pangolier_gyroshell_custom_legendary_target:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end




function modifier_pangolier_gyroshell_custom_legendary_target:OnDestroy()
if not IsServer() then return end 

if self:GetParent():IsDebuffImmune() or not self.deal_damage then 
	FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
end


if self.deal_damage then 
	self.ability:DealDamage(self:GetParent(), true)
else 
	self:GetParent():AddNewModifier(self:GetCaster(), self.ability, 'modifier_pangolier_gyroshell_custom_damage_cd', {duration = 1.5})
end


end 