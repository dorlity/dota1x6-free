LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_thinker", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_purge", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_legendary", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_legendary_zone", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_fear_count", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_fear_cd", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_slow", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_haste", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )



arc_warden_spark_wraith_custom = class({})







function arc_warden_spark_wraith_custom:Precache(context)

PrecacheResource( "particle", "particles/blue_zone.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_cast.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_heall.vpcf", context )
PrecacheResource( "particle", "particles/zuus_speed.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_tempest.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_hero.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/fall_2021/phase_boots_fall_2021_lvl2.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_fear_stack.vpcf", context )

end






function arc_warden_spark_wraith_custom:GetCastPoint(iLevel)
if self:GetCaster():HasModifier('modifier_arc_warden_spark_6') then 
	return self.BaseClass.GetCastPoint(self) + self:GetCaster():GetTalentValue("modifier_arc_warden_spark_6", "cast")
end

return self.BaseClass.GetCastPoint(self)
end



function arc_warden_spark_wraith_custom:DealDamage(target, not_main)
if not IsServer() then return end 

local spark_damage		= self:GetSpecialValueFor("spark_damage_base")
local slow_duration =  self:GetSpecialValueFor("ministun_duration")

local k = 1
local bonus = 0 

if self:GetCaster():HasModifier("modifier_arc_warden_spark_1") then 
	bonus = self:GetCaster():GetTalentValue("modifier_arc_warden_spark_1", "damage")*self:GetCaster():GetIntellect()/100
end 

if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
	spark_damage = self:GetSpecialValueFor("spark_damage_tempest")
	slow_duration =  self:GetSpecialValueFor("ministun_duration_tempest")

	bonus = bonus*self:GetCaster():GetTalentValue("modifier_arc_warden_spark_1", "dire_damage")/100
end


if not_main then 
	k = self:GetSpecialValueFor("damage_near")/100
else 
	if self:GetCaster():HasModifier("modifier_arc_warden_spark_5") and not target:HasModifier("modifier_arc_warden_spark_wraith_custom_fear_cd") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_spark_wraith_custom_fear_count", {duration = self:GetCaster():GetTalentValue("modifier_arc_warden_spark_5", "duration")})
	end 

	if self:GetCaster():HasModifier("modifier_arc_warden_spark_2") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_spark_wraith_custom_slow", {duration = self:GetCaster():GetTalentValue("modifier_arc_warden_spark_2", "duration")})
	end
end  


local hero = self:GetCaster()

if hero:IsTempestDouble() and hero.owner then 
	hero = hero.owner
end

if hero:GetQuest() == "Arc.Quest_7" and target:IsRealHero() and not hero:QuestCompleted() then 
	hero:UpdateQuest(1)
end



target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")

ApplyDamage({
	victim 			= target,
	damage 			= (spark_damage + bonus)*k,
	damage_type		= self:GetAbilityDamageType(),
	damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
	attacker 		= self:GetCaster(),
	ability 		= self
})

target:AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_spark_wraith_custom_purge", {duration = slow_duration * (1 - target:GetStatusResistance())})


end 




function arc_warden_spark_wraith_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end


function arc_warden_spark_wraith_custom:GetManaCost(level)

local bonus = 0

if self:GetCaster():HasModifier("modifier_arc_warden_spark_3") then 
	bonus = self:GetCaster():GetTalentValue("modifier_arc_warden_spark_3", "mana")
end 

return self.BaseClass.GetManaCost(self,level) + bonus
end







function arc_warden_spark_wraith_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_arc_warden_spark_4") then 
	bonus = self:GetCaster():GetTalentValue("modifier_arc_warden_spark_4", "cd")
end 

	return self.BaseClass.GetCooldown(self, level)  + bonus
end

function arc_warden_spark_wraith_custom:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
		return 'arc_warden_spark_wraith_tempest'
	else
		return "arc_warden_spark_wraith"
	end
end


function arc_warden_spark_wraith_custom:OnAbilityPhaseStart()

self:GetCaster():EmitSound("Hero_ArcWarden.SparkWraith.Cast")

return true
end



function arc_warden_spark_wraith_custom:CreateSpark(point, is_double)
if not IsServer() then return end 

local cast_point = GetGroundPosition(point, nil)

EmitSoundOnLocationWithCaster(cast_point, "Hero_ArcWarden.SparkWraith.Appear", self:GetCaster())

local double = 0

if is_double and is_double == true then 
	double = 1
end

local duration = self:GetSpecialValueFor("duration")

local towers = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), cast_point, nil, self:GetSpecialValueFor("tower_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

for _,tower in pairs(towers) do 
	if tower:GetUnitName() == "npc_towerdire" or tower:GetUnitName() == "npc_towerradiant" then 
		duration = self:GetSpecialValueFor("tower_duration")
	end 	
end 


CreateModifierThinker(self:GetCaster(), self, "modifier_arc_warden_spark_wraith_custom_thinker", {double = double, duration = duration }, cast_point, self:GetCaster():GetTeamNumber(), false)

end 



function arc_warden_spark_wraith_custom:OnSpellStart()

local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_wraith_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(cast_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:DestroyParticle(cast_particle, false)
ParticleManager:ReleaseParticleIndex(cast_particle)

if self:GetCaster():IsTempestDouble() then 
	self:GetCaster():MoveToPositionAggressive(self:GetCaster():GetAbsOrigin())
end 

self:CreateSpark(self:GetCursorPosition())
end





function arc_warden_spark_wraith_custom:OnProjectileHit_ExtraData(target, location, ExtraData)
if not target then return end

local damage_radius = self:GetSpecialValueFor("damage_radius")

local ability = self:GetCaster():FindAbilityByName("arc_warden_spark_wraith_custom_legendary")

if target:GetUnitName() == "npc_dota_companion" and ability then 
	damage_radius = ability:GetSpecialValueFor("tempest_aoe")
end



AddFOWViewer(self:GetCaster():GetTeamNumber(), location, self:GetSpecialValueFor("wraith_vision_radius"), self:GetSpecialValueFor("wraith_vision_duration"), true)

local caster = self:GetCaster()
if caster.owner then 
	caster = caster.owner
end 


if self:GetCaster():HasModifier("modifier_arc_warden_spark_4") and ExtraData.double and ExtraData.double == 0 
	and RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_arc_warden_spark_4", "chance"),729,caster) then 

	self:CreateSpark(location, true)
end 


if self:GetCaster():HasModifier("modifier_arc_warden_spark_3") then 


	local particle = ParticleManager:CreateParticle( "particles/arc_warden/spark_heall.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:ReleaseParticleIndex(particle)

	--caster:EmitSound("Arc.Spark_heal")

	caster:GenericHeal(caster:GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_arc_warden_spark_3", "heal")/100, self, false, "particles/puck_heal.vpcf")
end 


local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

for _,unit in pairs(units) do 
	self:DealDamage(unit, (unit ~= target) and target:GetUnitName() ~= "npc_dota_companion" )
end

if target:GetUnitName() == "npc_dota_companion" then 

	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_ArcWarden.SparkWraith.Damage", self:GetCaster())

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl(particle, 0, GetGroundPosition(target:GetAbsOrigin(), nil))
	ParticleManager:ReleaseParticleIndex(particle)

	UTIL_Remove(target)
end 

return true
end





---------------------------------------------------

modifier_arc_warden_spark_wraith_custom_thinker = class({})

function modifier_arc_warden_spark_wraith_custom_thinker:OnCreated(table)
if not self:GetAbility() then self:Destroy() return end

self.radius				= self:GetAbility():GetSpecialValueFor("radius")
self.activation_delay	= self:GetAbility():GetSpecialValueFor("base_activation_delay")
self.wraith_speed		= self:GetAbility():GetSpecialValueFor("wraith_speed_base")
self.think_interval			= self:GetAbility():GetSpecialValueFor("think_interval")
self.wraith_vision_radius	= self:GetAbility():GetSpecialValueFor("wraith_vision_radius")

self.part = "particles/arc_warden/spark_hero.vpcf"


self.double = table.double

if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
	self.activation_delay	= self:GetAbility():GetSpecialValueFor("tempest_activation_delay")
	self.wraith_speed		= self:GetAbility():GetSpecialValueFor("wraith_speed_tempest")
	self.part = "particles/arc_warden/spark_tempest.vpcf"
end


if self:GetCaster():HasModifier("modifier_arc_warden_spark_5") then 
	self.activation_delay = self.activation_delay*(1 - self:GetCaster():GetTalentValue("modifier_arc_warden_spark_5", "activate")/100)
end 


if not IsServer() then return end

self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Loop")

self.wraith_particle = ParticleManager:CreateParticle(self.part, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.wraith_particle, 1, Vector(self.radius, 1, 1))
self:AddParticle(self.wraith_particle, false, false, -1, false, false)


AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.wraith_vision_radius, self.activation_delay, false)

self:StartIntervalThink(self.activation_delay)
end

function modifier_arc_warden_spark_wraith_custom_thinker:OnIntervalThink()
if not IsServer() then return end 


AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.wraith_vision_radius, self.think_interval, false)

local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

for _, enemy in pairs(units) do
	self:FireSpark(enemy, nil)
	break
end

self:StartIntervalThink(self.think_interval)

end


function modifier_arc_warden_spark_wraith_custom_thinker:FireSpark(target, position)
if not IsServer() then return end 

local spark_target = target
local speed = self.wraith_speed

if not target and position then 

	local ability = self:GetCaster():FindAbilityByName("arc_warden_spark_wraith_custom_legendary")

	if ability then 
		speed = speed*(1 + ability:GetSpecialValueFor("speed_inc")/100)
	end


    spark_target =  CreateUnitByName("npc_dota_companion", position, false, nil, nil, self:GetCaster():GetTeamNumber())
	spark_target:AddNewModifier(spark_target, nil, "modifier_phased", {})
	spark_target:AddNewModifier(spark_target, nil, "modifier_no_healthbar", {})
	spark_target:AddNewModifier(spark_target, nil, "modifier_invulnerable", {})
	spark_target:AddNewModifier(spark_target, ability, "modifier_arc_warden_spark_wraith_custom_legendary_zone", {})

	spark_target:SetAbsOrigin(Vector(spark_target:GetAbsOrigin().x, spark_target:GetAbsOrigin().y, spark_target:GetAbsOrigin().z + 50))
end 


self:GetParent():EmitSound("Hero_ArcWarden.SparkWraith.Activate")

ProjectileManager:CreateTrackingProjectile({
	EffectName			= "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf",
	Ability				= self:GetAbility(),
	Source				= self:GetParent(),
	vSourceLoc			= self:GetParent():GetAbsOrigin(),
	Target				= spark_target,
	iMoveSpeed			= speed,
	flExpireTime		= nil,
	bDodgeable			= false,
	bIsAttack			= false,
	bReplaceExisting	= false,
	iSourceAttachment	= nil,
	bDrawsOnMinimap		= nil,
	bVisibleToEnemies	= true,
	bProvidesVision		= true,
	iVisionRadius		= self.wraith_vision_radius,
	iVisionTeamNumber	= self:GetCaster():GetTeamNumber(),
	ExtraData			= {
		double = self.double
	}
})

self:Destroy()


end 



function modifier_arc_warden_spark_wraith_custom_thinker:OnDestroy()
	if not IsServer() then return end
	
	self:GetParent():StopSound("Hero_ArcWarden.SparkWraith.Loop")
end

function modifier_arc_warden_spark_wraith_custom_thinker:IsAura() 
if self:GetCaster():HasModifier("modifier_arc_warden_spark_6") then 
	return true 
end

end

function modifier_arc_warden_spark_wraith_custom_thinker:GetAuraDuration() return self:GetCaster():GetTalentValue("modifier_arc_warden_spark_6", "duration") end

function modifier_arc_warden_spark_wraith_custom_thinker:GetAuraRadius() return self.radius
end

function modifier_arc_warden_spark_wraith_custom_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_arc_warden_spark_wraith_custom_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end

function modifier_arc_warden_spark_wraith_custom_thinker:GetModifierAura() return "modifier_arc_warden_spark_wraith_custom_haste" end




modifier_arc_warden_spark_wraith_custom_haste = class({})

function modifier_arc_warden_spark_wraith_custom_haste:IsHidden() return false end
function modifier_arc_warden_spark_wraith_custom_haste:IsPurgable() return false end
function modifier_arc_warden_spark_wraith_custom_haste:GetTexture() return "buffs/remnant_speed" end
function modifier_arc_warden_spark_wraith_custom_haste:GetEffectName() return "particles/econ/events/fall_2021/phase_boots_fall_2021_lvl2.vpcf" end
function modifier_arc_warden_spark_wraith_custom_haste:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end 

function modifier_arc_warden_spark_wraith_custom_haste:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end 


function modifier_arc_warden_spark_wraith_custom_haste:GetModifierMoveSpeedBonus_Percentage()
return self:GetCaster():GetTalentValue("modifier_arc_warden_spark_6", "move")
end

function modifier_arc_warden_spark_wraith_custom_haste:OnCreated()
if not IsServer() then return end 

self.parent = self:GetParent()

self.particle_ally_fx = ParticleManager:CreateParticle("particles/zuus_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)  

self:GetParent():EmitSound("Arc.Spark_haste")
end 












modifier_arc_warden_spark_wraith_custom_purge = class({})


function modifier_arc_warden_spark_wraith_custom_purge:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.move_speed_slow_pct	= self:GetAbility():GetSpecialValueFor("move_speed_slow_pct") * (-1)
end

function modifier_arc_warden_spark_wraith_custom_purge:DeclareFunctions()
	return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE}
end

function modifier_arc_warden_spark_wraith_custom_purge:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed_slow_pct
end







arc_warden_spark_wraith_custom_legendary = class({})

function arc_warden_spark_wraith_custom_legendary:GetChannelTime()
return self:GetCaster():GetTalentValue("modifier_arc_warden_spark_7", "cast")
end 




function arc_warden_spark_wraith_custom_legendary:GetBehavior()
if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then 
	return DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
end 	

return DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
end 



function arc_warden_spark_wraith_custom_legendary:GetAOERadius()

if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then 
	return self:GetSpecialValueFor("tempest_aoe")
else 
	return self:GetSpecialValueFor("hero_aoe")
end 

end 


function arc_warden_spark_wraith_custom_legendary:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double_custom") then 
	return self:GetCaster():GetTalentValue("modifier_arc_warden_spark_7", "cd_clone")
end 

return self:GetCaster():GetTalentValue("modifier_arc_warden_spark_7", "cd")
end


function arc_warden_spark_wraith_custom_legendary:OnAbilityPhaseStart()

if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then 
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_AW_MAGNETIC_FIELD, 1.3)
else 
	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 1.3)
end 

return true
end 
function arc_warden_spark_wraith_custom_legendary:OnAbilityPhaseInterrupted()

self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_3)

end 


function arc_warden_spark_wraith_custom_legendary:OnSpellStart()


local point = self:GetCursorPosition()

if not self:GetCursorTarget() then 

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_spark_wraith_custom_legendary", {x = point.x, y = point.y, z = point.z})
else 

	local target = self:GetCursorTarget()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_arc_warden_spark_wraith_custom_legendary", {target = target:entindex(), x = point.x, y = point.y, z = point.z})
end 


end 

function arc_warden_spark_wraith_custom_legendary:OnChannelFinish(bInterrupted)

self:GetCaster():RemoveModifierByName("modifier_arc_warden_spark_wraith_custom_legendary")
end 






modifier_arc_warden_spark_wraith_custom_legendary = class({})
function modifier_arc_warden_spark_wraith_custom_legendary:IsHidden() return false end
function modifier_arc_warden_spark_wraith_custom_legendary:IsPurgable() return false end
function modifier_arc_warden_spark_wraith_custom_legendary:OnCreated(table)
if not IsServer() then return end 

self.parent = self:GetParent()

self.particle_ally_fx = ParticleManager:CreateParticle("particles/arc_warden/spark_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)  

self.target = nil 
self.center = Vector(table.x, table.y, table.z)


self.main_ability = self:GetParent():FindAbilityByName("arc_warden_spark_wraith_custom")


self.interval = 0.05
self.count = 0.05
self.launch_part = false
self.launch_anim = false


self.max_dist = self:GetAbility():GetSpecialValueFor("max_dist")
self.min_dist = self:GetAbility():GetSpecialValueFor("min_dist")
self.tempest_aoe =  self:GetAbility():GetSpecialValueFor("tempest_aoe")
self.ticks = self:GetAbility():GetSpecialValueFor("ticks")


if table.target then 
	self.target = EntIndexToHScript(table.target)
end 


if self:GetParent():HasModifier("modifier_arc_warden_tempest_double") then 
	self.radius =  self:GetAbility():GetSpecialValueFor("tempest_search")
	self.spark_count = self:GetCaster():GetTalentValue("modifier_arc_warden_spark_7", "max")/self.ticks

else 
	self.radius =  self:GetAbility():GetSpecialValueFor("hero_aoe")
	self.spark_count = self:GetCaster():GetTalentValue("modifier_arc_warden_spark_7", "max")/self.ticks
end 

local qangle_rotation_rate = 360/8
self.qangle = QAngle(0, qangle_rotation_rate, 0)
self.line_position = self.center + RandomVector(1)
self.k = 1

self:OnIntervalThink()

self:StartIntervalThink(self.interval)
end 





function modifier_arc_warden_spark_wraith_custom_legendary:GetPoint()
if not IsServer() then return end 

self.line_position = RotatePosition(self.center , self.qangle, self.line_position)
self.k = self.k*-1

local vec = (self.line_position - self.center):Normalized()

return self.center + vec*RandomInt(self.min_dist, self.max_dist)*self.k
end 





function modifier_arc_warden_spark_wraith_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

self.count = self.count + self.interval


if self.count >= 0.1 and self.launch_part == false then
	self.launch_part = true

	self.parent:EmitSound("Arc.Spark_legendary")
	self.parent:EmitSound("Arc.Spark_legendary2")


	for i = 1,3 do

		local line_position = self.parent:GetAbsOrigin() + RandomVector(RandomInt(150, 250))

		local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(cast_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(cast_particle, 1, line_position)
		ParticleManager:SetParticleControlEnt(cast_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(cast_particle)

	end


	if not self:GetParent():HasModifier("modifier_arc_warden_tempest_double") then 

		for i = 1,self.spark_count do 

			local line_position = self:GetPoint()

			local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
			ParticleManager:SetParticleControlEnt(cast_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(cast_particle, 1, line_position)
			ParticleManager:SetParticleControlEnt(cast_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(cast_particle)

			EmitSoundOnLocationWithCaster(line_position, "Hero_ArcWarden.SparkWraith.Cast", self.parent)

			self.main_ability:CreateSpark(line_position)
		end
	
	else 
		local units = Entities:FindAllByClassnameWithin("npc_dota_thinker", self:GetParent():GetAbsOrigin(), self.radius)

		local n = 0

		for _,unit in pairs(units) do 
			local mod = unit:FindModifierByName("modifier_arc_warden_spark_wraith_custom_thinker")

			if mod and mod.double and mod.double == 0 then
				local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
				ParticleManager:SetParticleControlEnt(cast_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(cast_particle, 1, unit:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(cast_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(cast_particle)

				local point 

				if self.target and not self.target:IsNull() and self.target:IsAlive() 
					and (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() < self.radius then 

					point = self.target:GetAbsOrigin() 

					if self.target:IsMoving() then 
						point = self.target:GetAbsOrigin() + self.target:GetForwardVector()*100
					end 
				else 
					point = self.center + RandomVector(RandomInt(1, self.tempest_aoe/2))
				end 

				mod:FireSpark(nil, point )


				n = n + 1

				if n >= self.spark_count then 
					break
				end 
			end
		end 

	end 

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_wraith_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self.parent)
	ParticleManager:SetParticleControlEnt(cast_particle, 1,  self.parent, PATTACH_POINT_FOLLOW, "attach_attack1",  self.parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)

end 

if self.count >= 0.6 and self.launch_anim == false then
	self.launch_anim = true 
	if self.parent:HasModifier("modifier_arc_warden_tempest_double") then 
		self.parent:StartGestureWithPlaybackRate(ACT_DOTA_AW_MAGNETIC_FIELD, 1.1)
	else 
		self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 1.1)
	end 

end 

if self.count >= 0.9 then 
	self.count = 0
	self.launch_part = false
	self.launch_anim = false
end 

end


function modifier_arc_warden_spark_wraith_custom_legendary:OnDestroy()
if not IsServer() then return end 

--self:GetParent():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end 



modifier_arc_warden_spark_wraith_custom_legendary_zone = class({})
function modifier_arc_warden_spark_wraith_custom_legendary_zone:IsHidden() return false end
function modifier_arc_warden_spark_wraith_custom_legendary_zone:IsPurgable() return false end
function modifier_arc_warden_spark_wraith_custom_legendary_zone:OnCreated()
if not IsServer() then return end 


local particle_cast = "particles/blue_zone.vpcf"
self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetAbility():GetSpecialValueFor("tempest_aoe"), 0, -self:GetAbility():GetSpecialValueFor("tempest_aoe")) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( 0, 0, 0 ) )
self:AddParticle(self.effect_cast, false, false, -1, false, false)
end 




modifier_arc_warden_spark_wraith_custom_fear_count = class({})

function modifier_arc_warden_spark_wraith_custom_fear_count:IsHidden() return true end
function modifier_arc_warden_spark_wraith_custom_fear_count:IsPurgable() return false end
function modifier_arc_warden_spark_wraith_custom_fear_count:OnCreated()
if not IsServer() then return end 

local particle_cast = "particles/arc_warden/spark_fear_stack.vpcf"
self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end 

function modifier_arc_warden_spark_wraith_custom_fear_count:OnRefresh(table)
if not IsServer() then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_arc_warden_spark_5", "max") then 

	self:GetParent():EmitSound("BS.Rupture_fear")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_nevermore_requiem_fear", {duration  = self:GetCaster():GetTalentValue("modifier_arc_warden_spark_5", "fear") * (1 - self:GetParent():GetStatusResistance())})
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_arc_warden_spark_wraith_custom_fear_cd", {duration  =self:GetCaster():GetTalentValue("modifier_arc_warden_spark_5", "cd")})


	self:Destroy()
end 

end 




function modifier_arc_warden_spark_wraith_custom_fear_count:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end

if self.effect_cast then 
   ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end


end











modifier_arc_warden_spark_wraith_custom_fear_cd = class({})
function modifier_arc_warden_spark_wraith_custom_fear_cd:IsHidden() return true end
function modifier_arc_warden_spark_wraith_custom_fear_cd:IsPurgable() return false end
function modifier_arc_warden_spark_wraith_custom_fear_cd:RemoveOnDeath() return false end





modifier_arc_warden_spark_wraith_custom_slow = class({})
function modifier_arc_warden_spark_wraith_custom_slow:IsHidden() return false end
function modifier_arc_warden_spark_wraith_custom_slow:IsPurgable() return false end
function modifier_arc_warden_spark_wraith_custom_slow:GetTexture() return "buffs/spark_slow" end
function modifier_arc_warden_spark_wraith_custom_slow:OnCreated()
if not IsServer() then return end 

self:SetStackCount(1)
end 

function modifier_arc_warden_spark_wraith_custom_slow:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_arc_warden_spark_2", "max") then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_arc_warden_spark_2", "max") then 

	self.flux_particle = ParticleManager:CreateParticle("particles/void_astral_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.flux_particle, false, false, -1, false, false)
end 

end 


function modifier_arc_warden_spark_wraith_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end 


function modifier_arc_warden_spark_wraith_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_arc_warden_spark_2", "slow_attack")
end 


function modifier_arc_warden_spark_wraith_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_arc_warden_spark_2", "slow_move")
end 



