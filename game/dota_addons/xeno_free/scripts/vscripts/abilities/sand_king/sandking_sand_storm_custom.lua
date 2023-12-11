LinkLuaModifier("modifier_sandking_sand_storm_custom", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_target", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_tracker", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_caster", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_invis", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_spider_ai", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_legendary", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_spider_effect", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_speed", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_cyclone", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_silence", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_damage_cd", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_heal", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sandking_sand_storm_custom_root", "abilities/sand_king/sandking_sand_storm_custom", LUA_MODIFIER_MOTION_NONE)



sandking_sand_storm_custom = class({})
		
function sandking_sand_storm_custom:Precache(context)
    
PrecacheResource( "particle", "particles/sand_king/sandking_sandstorm_custom.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/sand_tornado.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/tornado_damage.vpcf", context )
PrecacheResource( "particle", "particles/muerta/veil_pull.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/sand_root.vpcf", context )
end


function sandking_sand_storm_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("sand_storm_radius") + self:GetCaster():GetTalentValue("modifier_sand_king_sand_2", "radius")
end


function sandking_sand_storm_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_sand_king_sand_2") then 
	bonus = self:GetCaster():GetTalentValue("modifier_sand_king_sand_2", "cd")
end 

	return self.BaseClass.GetCooldown(self, level)  + bonus
end



function sandking_sand_storm_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_sandking_sand_storm_custom_tracker"
end


function sandking_sand_storm_custom:OnSpellStart()


if self:GetCaster():HasModifier("modifier_sand_king_sand_5") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_sand_storm_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_sand_king_sand_5", "duration")})
end

local duration = self:GetSpecialValueFor("duration")
local thinker =  CreateModifierThinker(self:GetCaster(), self, "modifier_sandking_sand_storm_custom", {duration = duration}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_sand_storm_custom_caster", {duration = duration, thinker = thinker:entindex()})

if self:GetCaster():HasModifier("modifier_sand_king_sand_4") then 

	for i = 1,self:GetCaster():GetTalentValue("modifier_sand_king_sand_4", "max") do

		local angel = (math.pi/2 + 2*math.pi/2 * i)
		CreateModifierThinker(self:GetCaster(), self, "modifier_sandking_sand_storm_custom_cyclone", {thinker = thinker:entindex(), angle = angel}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	end
end

self:GetCaster():EmitSound("SandKing.SandStorm.start")
end 


function sandking_sand_storm_custom:GetDamage(target)

local damage = self:GetSpecialValueFor("sand_storm_damage") + self:GetCaster():GetTalentValue("modifier_sand_king_sand_1", "damage")*self:GetCaster():GetMaxHealth()/100
local damage_inc = self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "damage")/100


local mod = target:FindModifierByName("modifier_sandking_sand_storm_custom_spider_effect")

if mod then 
	damage = damage*(1 + mod:GetStackCount()*damage_inc)
end 

return damage
end 


modifier_sandking_sand_storm_custom = class({})
function modifier_sandking_sand_storm_custom:IsPurgable() return false end

function modifier_sandking_sand_storm_custom:OnCreated(table)
if not IsServer() then return end

self:GetAbility():SetActivated(false)
self:GetAbility():EndCooldown()

if (self:GetCaster():HasModifier("modifier_sand_king_sand_7") or self:GetCaster():HasModifier("modifier_sand_king_sand_6")) and not self:GetAbility():IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetAbility():GetName(), "sandking_sand_storm_custom_legendary", false, true)

	self:GetCaster():FindAbilityByName("sandking_sand_storm_custom_legendary"):StartCooldown(0.5)

end


self.caster = self:GetCaster()
self.thinker = self:GetParent()
self.radius = self:GetAbility():GetSpecialValueFor("sand_storm_radius") + self.caster:GetTalentValue("modifier_sand_king_sand_2", "radius")
self.speed = self:GetAbility():GetSpecialValueFor("sand_storm_move_speed") + self.caster:GetTalentValue("modifier_sand_king_sand_5", "sand_speed")

self.scepter_max = nil
self.scepter_count = 0
self.ulti = self:GetCaster():FindAbilityByName("sandking_epicenter_custom")
if self.ulti and self:GetCaster():HasScepter() and self.ulti:GetLevel() > 0 then 
	
	self.scepter_max = self.ulti:GetSpecialValueFor("scepter_sand")
end 


local particle_cast = "particles/sand_king/sandking_sandstorm_custom.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:GetParent():EmitSound("SandKing.SandStorm.loop")

self.interval = 0.03

self:StartIntervalThink(self.interval)
end 


function modifier_sandking_sand_storm_custom:OnDestroy()
if not IsServer() then return end 

if (self:GetCaster():HasModifier("modifier_sand_king_sand_7") or self:GetCaster():HasModifier("modifier_sand_king_sand_6")) and self:GetAbility():IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetAbility():GetName(), "sandking_sand_storm_custom_legendary", true, false)
end


self:GetAbility():UseResources(false, false, false, true)
self:GetAbility():SetActivated(true)

self:GetParent():StopSound("SandKing.SandStorm.loop")
self:GetCaster():RemoveModifierByName("modifier_sandking_sand_storm_custom_caster")
self:GetCaster():RemoveModifierByName("modifier_sandking_sand_storm_custom_invis")

UTIL_Remove(self:GetParent())
end 


function modifier_sandking_sand_storm_custom:OnIntervalThink()
if not IsServer() then return end

if not self.thinker or self.thinker:IsNull() then 
	self:Destroy()
	return 
end

if self.scepter_max then 
	self.scepter_count = self.scepter_count + self.interval

	if self.scepter_count >= self.scepter_max then 
		self.scepter_count = 0
		self.ulti:Pulse(self:GetParent(), self.radius, true)
	end 
end 



local dir = (self.caster:GetAbsOrigin() - self.thinker:GetAbsOrigin())

if not self.caster or self.caster:IsNull() or not self.caster:IsAlive() or dir:Length2D() > self.radius then 
	self:Destroy()
	return 
end 

local speed = self.speed

if self.caster:HasModifier("modifier_sandking_sand_storm_custom_speed") then 
	speed = 550
end 


if dir:Length2D() <= speed/10 then return end 



local dist = speed*self.interval

self.thinker:SetAbsOrigin(GetGroundPosition((self.thinker:GetAbsOrigin() + dir:Normalized()*dist), nil))


if self.effect_cast then 
	ParticleManager:SetParticleControl( self.effect_cast, 0, self.thinker:GetAbsOrigin() )
end 

end



function modifier_sandking_sand_storm_custom:IsAura() return true end

function modifier_sandking_sand_storm_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_sandking_sand_storm_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_sandking_sand_storm_custom:GetModifierAura()
	return "modifier_sandking_sand_storm_custom_target"
end

function modifier_sandking_sand_storm_custom:GetAuraRadius()
	return self.radius
end


function modifier_sandking_sand_storm_custom:GetAuraDuration()
return 0
end



modifier_sandking_sand_storm_custom_target = class({})
function modifier_sandking_sand_storm_custom_target:IsHidden() return true end
function modifier_sandking_sand_storm_custom_target:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_target:OnCreated()

self.interval = self:GetAbility():GetSpecialValueFor("damage_tick_rate")

if not IsServer() then return end 

self.damageTable = {victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL}

self:StartIntervalThink(self.interval)
end 

function modifier_sandking_sand_storm_custom_target:OnIntervalThink()
if not IsServer() then return end 

if self:GetCaster():GetQuest() == "Sand.Quest_6" and self:GetParent():IsRealHero() then 
	self:GetCaster():UpdateQuest(self.interval)
end


local damage = self.interval*self:GetAbility():GetDamage(self:GetParent())


self.damageTable.damage = damage

ApplyDamage(self.damageTable)

end





modifier_sandking_sand_storm_custom_caster = class({})
function modifier_sandking_sand_storm_custom_caster:IsHidden() return false end
function modifier_sandking_sand_storm_custom_caster:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_caster:OnCreated(table)

self.status = self:GetCaster():GetTalentValue("modifier_sand_king_sand_3", "status")
self.regen = self:GetCaster():GetTalentValue("modifier_sand_king_sand_3", "heal")

if not IsServer() then return end 

self.thinker = EntIndexToHScript(table.thinker)

self.cd = self:GetAbility():GetSpecialValueFor("fade_delay")

self:OnIntervalThink()
end 




function modifier_sandking_sand_storm_custom_caster:DeclareFunctions()
local funcs = {
    MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
return funcs
end

function modifier_sandking_sand_storm_custom_caster:GetModifierStatusResistanceStacking()
if not self:GetParent():HasModifier("modifier_sand_king_sand_3") then return end
return self.status
end



function modifier_sandking_sand_storm_custom_caster:GetModifierHealthRegenPercentage()
if not self:GetParent():HasModifier("modifier_sand_king_sand_3") then return end
return self.regen
end


function modifier_sandking_sand_storm_custom_caster:OnIntervalThink()
if not IsServer() then return end 

local target = nil
if self:GetParent():GetAttackTarget() then 
	target = self:GetParent():GetAttackTarget():entindex()
end 

self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sandking_sand_storm_custom_invis", {target = target, duration = self:GetRemainingTime()})
self:StartIntervalThink(-1)
end 


function modifier_sandking_sand_storm_custom_caster:OnAbilityExecuted( params )
if not IsServer() then return end
if not params.ability then return end
if not params.unit then return end
if params.unit ~= self:GetParent() then return end

if self.mod and not self.mod:IsNull() then 
	self.mod:Destroy()
end

self:StartIntervalThink(self.cd)
end

function modifier_sandking_sand_storm_custom_caster:OnAttack(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker ~= self:GetParent() then return end

if self.mod and not self.mod:IsNull() then 
	self.mod:Destroy()
end

self:StartIntervalThink(self.cd)
end



function modifier_sandking_sand_storm_custom_caster:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end









modifier_sandking_sand_storm_custom_invis = class({})

function modifier_sandking_sand_storm_custom_invis:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_invis:IsHidden() return true end


function modifier_sandking_sand_storm_custom_invis:OnCreated(table)
if not IsServer() then return end

if table.target ~= nil  then
	self:GetParent():MoveToTargetToAttack(EntIndexToHScript(table.target))
end 

end


function modifier_sandking_sand_storm_custom_invis:DeclareFunctions()
local funcs = {
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
}
return funcs
end


function modifier_sandking_sand_storm_custom_invis:GetModifierInvisibilityLevel()
if self:GetCaster():IsInvulnerable() then return end
    return 1
end

function modifier_sandking_sand_storm_custom_invis:CheckState()
if self:GetCaster():IsInvulnerable() then return end
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
    }
end








sandking_sand_storm_custom_legendary = class({})


function sandking_sand_storm_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "cd", true)
end

function sandking_sand_storm_custom_legendary:GetChannelTime()
if not self:GetCaster():HasModifier("modifier_sand_king_sand_7") then return end
return self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "duration")
end



function sandking_sand_storm_custom_legendary:GetBehavior()
if self:GetCaster():HasModifier("modifier_sand_king_sand_7") then
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end


if self:GetCaster():HasModifier("modifier_sand_king_sand_4") then
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

end



function sandking_sand_storm_custom_legendary:GetChannelAnimation()
return ACT_DOTA_OVERRIDE_ABILITY_2
end


function sandking_sand_storm_custom_legendary:OnSpellStart()


if self:GetCaster():HasModifier("modifier_sand_king_sand_6") then 
	self.caster = self:GetCaster()

	local mod = self.caster:FindModifierByName("modifier_sandking_sand_storm_custom_caster")

	self.point = self.caster:GetAbsOrigin()

	local ability = self:GetCaster():FindAbilityByName("sandking_sand_storm_custom")
	local radius = ability:GetSpecialValueFor("sand_storm_radius") + self.caster:GetTalentValue("modifier_sand_king_sand_2", "radius") + self.caster:GetTalentValue("modifier_sand_king_sand_6", "more_radius")

	if mod and mod.thinker and not mod.thinker:IsNull() then 
		self.point = mod.thinker:GetAbsOrigin()

		local effect_cast = ParticleManager:CreateParticle( "particles/muerta/veil_pull.vpcf", PATTACH_ABSORIGIN_FOLLOW, mod.thinker )
		ParticleManager:SetParticleControl( effect_cast, 0, mod.thinker:GetAbsOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )

	end 

	EmitSoundOnLocationWithCaster(self.point, "SandKing.Sand_pull", self.caster)
	
	--[[self.caster:AddNewModifier(self.caster, self, "modifier_sandking_sand_storm_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_sand_king_sand_6", "duration")})

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:ReleaseParticleIndex(particle)

	self.caster:Purge(false, true, false, false, false)
	]]

	local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

	local root_duration = self:GetCaster():GetTalentValue("modifier_sand_king_sand_6", "duration")

	for _,unit in pairs(units) do

		local dir = (self.point -  unit:GetAbsOrigin()):Normalized()
		local point = self.point - dir*50
		local distance = (point - unit:GetAbsOrigin()):Length2D()

		distance = math.max(50, distance)
		point = unit:GetAbsOrigin() + dir*distance

		local mod = unit:AddNewModifier( self:GetCaster(),  self,  "modifier_generic_arc",  
		{
		  target_x = point.x,
		  target_y = point.y,
		  distance = distance,
		  duration = 0.3,
		  height = 0,
		  fix_end = false,
		  isStun = true,
		  activity = ACT_DOTA_FLAIL,
		})

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
		mod:AddParticle(effect_cast,false, false, -1, false, false)
		mod:SetEndCallback(function()

			unit:AddNewModifier(self:GetCaster(), self, "modifier_sandking_sand_storm_custom_root", {duration = (1 - unit:GetStatusResistance()*root_duration)})

		end)


	end
end

if not self:GetCaster():HasModifier("modifier_sand_king_sand_7") then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sandking_sand_storm_custom_legendary", {})
end 

function sandking_sand_storm_custom_legendary:OnChannelFinish(bInterrupted)


self:GetCaster():RemoveModifierByName("modifier_sandking_sand_storm_custom_legendary")
end



modifier_sandking_sand_storm_custom_legendary = class({})
function modifier_sandking_sand_storm_custom_legendary:IsHidden() return true end
function modifier_sandking_sand_storm_custom_legendary:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_legendary:OnCreated()
if not IsServer() then return end 

self.max = self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "max")
self.duration = self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "duration")
self.caster = self:GetCaster()

self.life_duration = self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "life_duration")

self.interval = self.duration/(self.max - 1) - 0.015

self.qangle_rotation_rate = 360 / self.max
self.line_position = self.caster:GetAbsOrigin() + RandomVector(300)

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 


function modifier_sandking_sand_storm_custom_legendary:OnIntervalThink()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end

local qangle = QAngle(0, self.qangle_rotation_rate, 0)
self.line_position = RotatePosition(self.caster:GetAbsOrigin() , qangle, self.line_position)

self:IncrementStackCount()

local unit = CreateUnitByName("npc_dota_sand_king_spider", self.line_position, false, self.caster, self.caster, self.caster:GetTeamNumber())
unit:AddNewModifier(self.caster, self:GetAbility(), "modifier_sandking_sand_storm_custom_spider_ai", {})

unit:AddNewModifier(self.caster, self:GetAbility(), "modifier_kill", { duration = self.life_duration })

unit.owner = self.caster

--unit:SetControllableByPlayer(self.caster:GetPlayerID(), true)
unit:SetAngles(0, 0, 0)
unit:SetForwardVector(self.caster:GetForwardVector())
FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)

EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "SandKing.Spider_spawn", self.caster)

if self:GetStackCount() >= self.max then 
	self.caster:Stop()
	self:Destroy()
end 

end 












modifier_sandking_sand_storm_custom_spider_ai = class({})

function modifier_sandking_sand_storm_custom_spider_ai:IsHidden() return true end
function modifier_sandking_sand_storm_custom_spider_ai:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_spider_ai:RemoveOnDeath() return false end

function modifier_sandking_sand_storm_custom_spider_ai:GetStatusEffectName()
return "particles/status_fx/status_effect_armadillo_shield.vpcf"
end

function modifier_sandking_sand_storm_custom_spider_ai:StatusEffectPriority()
	return 9999999
end


function modifier_sandking_sand_storm_custom_spider_ai:OnCreated(table)
if not IsServer() then return end

local health = self:GetCaster():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "health")/100

self:GetParent():SetBaseMaxHealth(health)
self:GetParent():SetHealth(self:GetParent():GetMaxHealth())

ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/neutral_fx/skeleton_spawn.vpcf", PATTACH_ABSORIGIN, self:GetParent() ) )
self:GetParent():SetRenderColor(246, 210, 143)

local vec = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin())

self.vec = vec:Normalized()*300

self.radius = 1500

self.target = nil

self:OnIntervalThink()
self:StartIntervalThink(0.2)
end


function modifier_sandking_sand_storm_custom_spider_ai:CheckState()
return
{
	--[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end


function modifier_sandking_sand_storm_custom_spider_ai:IsValidTarget(target)
if not IsServer() then return end 


if not target or target:IsNull() or not target:IsAlive() or 
 ((target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.radius) or (not target:IsHero() and not target:IsCreep())
or target:IsCourier() or target:GetUnitName() == "npc_teleport" or target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 

	return false 
end


return true
end 


function modifier_sandking_sand_storm_custom_spider_ai:SetTarget(target)
if not IsServer() then return end
if not self:IsValidTarget(target) then return end
if self.target == target then return end

self.target = target
self:GetParent():MoveToPositionAggressive(self.target:GetAbsOrigin())
self:GetParent():SetForceAttackTarget(self.target)

end 



function modifier_sandking_sand_storm_custom_spider_ai:MoveToCaster()
if not IsServer() then return end

self.target = nil
self:GetParent():SetForceAttackTarget(nil)

local point = self:GetCaster():GetAbsOrigin() + self.vec

if (point - self:GetParent():GetAbsOrigin()):Length2D() > 50 then 
	self:GetParent():MoveToPosition(self:GetCaster():GetAbsOrigin() + self.vec)
end

end


function modifier_sandking_sand_storm_custom_spider_ai:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():GetAggroTarget() then
    self.target = self:GetParent():GetAggroTarget()
end

local heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
local creeps = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

if self:IsValidTarget(self.target) and self.target:IsHero() then 
    self:SetTarget(self.target)
    return
end 

if (not self:IsValidTarget(self.target) or not self.target:IsHero()) and  #heroes > 0  then
	for _,hero in pairs(heroes) do
		if self:IsValidTarget(hero) then 
			self:SetTarget(hero)
        	break
		end
	end 
end

if not self:IsValidTarget(self.target) and #creeps > 0 then 
	for _,creep in pairs(creeps) do
		if self:IsValidTarget(creep) then 
			self:SetTarget(creep)
        	break
		end
	end
end 

if not self:IsValidTarget(self.target) then 
	self:MoveToCaster()
end


end






modifier_sandking_sand_storm_custom_spider_effect = class({})
function modifier_sandking_sand_storm_custom_spider_effect:IsHidden() return false end
function modifier_sandking_sand_storm_custom_spider_effect:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_spider_effect:GetTexture() return "buffs/sand_spider" end

function modifier_sandking_sand_storm_custom_spider_effect:GetEffectName()
return "particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf"
end

function modifier_sandking_sand_storm_custom_spider_effect:OnCreated()

--self.slow = self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "slow")
self.damage = self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "damage")
if not IsServer() then return end

self:SetStackCount(1)
end 

function modifier_sandking_sand_storm_custom_spider_effect:OnRefresh(table)
if not IsServer() then return end 
self:IncrementStackCount()

end 

function modifier_sandking_sand_storm_custom_spider_effect:DeclareFunctions()
return
{
	--MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_sandking_sand_storm_custom_spider_effect:GetModifierMoveSpeedBonus_Percentage()
--return self:GetStackCount()*self.slow
end

function modifier_sandking_sand_storm_custom_spider_effect:OnTooltip()
return self:GetStackCount()*self.damage
end






modifier_sandking_sand_storm_custom_tracker = class({})
function modifier_sandking_sand_storm_custom_tracker:IsHidden() return true end
function modifier_sandking_sand_storm_custom_tracker:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_tracker:OnCreated()

self.caster = self:GetCaster()
self.slow_duration = self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "slow_duration", true)
self.death_radius = self:GetCaster():GetTalentValue("modifier_sand_king_sand_7", "radius", true)
end 

function modifier_sandking_sand_storm_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_DEATH
}
end

function modifier_sandking_sand_storm_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self.caster:HasModifier("modifier_sand_king_sand_7") then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

local attacker = params.attacker

if attacker and attacker.owner and attacker.owner == self.caster and attacker:HasModifier("modifier_sandking_sand_storm_custom_spider_ai") then 
	params.target:AddNewModifier(self.caster, self:GetAbility(), "modifier_sandking_sand_storm_custom_spider_effect", {duration = self.slow_duration})
end 

end



function modifier_sandking_sand_storm_custom_tracker:OnDeath(params)
if not IsServer() then return end
if not self.caster:HasModifier("modifier_sand_king_sand_7") then return end

local unit = params.unit

if unit and unit.owner and unit.owner == self.caster and unit:HasModifier("modifier_sandking_sand_storm_custom_spider_ai") then 

	local effect_cast = ParticleManager:CreateParticle( "particles/sand_king/sandking_caustic_finale_explode_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	unit:EmitSound("Ability.SandKing_CausticFinale")

	local targets = self:GetCaster():FindTargets(self.death_radius, unit:GetAbsOrigin())

	local damage_table = {attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}

	for _,target in pairs(targets) do

		damage_table.damage = self:GetAbility():GetDamage(target)
		damage_table.victim = target
		local real_damage = ApplyDamage(damage_table)
	end 

end 

end














modifier_sandking_sand_storm_custom_speed = class({})
function modifier_sandking_sand_storm_custom_speed:IsHidden() return true end
function modifier_sandking_sand_storm_custom_speed:IsPurgable() return false end


function modifier_sandking_sand_storm_custom_speed:GetEffectName()
return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end 

function modifier_sandking_sand_storm_custom_speed:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_sandking_sand_storm_custom_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_sand_king_sand_5", "speed")

end


function modifier_sandking_sand_storm_custom_speed:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end

function modifier_sandking_sand_storm_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_sandking_sand_storm_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end



modifier_sandking_sand_storm_custom_cyclone = class({})
function modifier_sandking_sand_storm_custom_cyclone:IsHidden() return true end
function modifier_sandking_sand_storm_custom_cyclone:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_cyclone:OnCreated(table)
if not IsServer() then return end 

self.thinker = EntIndexToHScript(table.thinker)
self.hit_radius = 200
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.effect_cast = ParticleManager:CreateParticle( "particles/sand_king/sand_tornado.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.hit_radius, 0, 0) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)


self:GetParent():EmitSound("SandKing.Tornado_start")
self:GetParent():EmitSound("SandKing.Tornado_loop")

self.radius_min = 220

self.radius_max = self:GetAbility():GetSpecialValueFor("sand_storm_radius") + self.caster:GetTalentValue("modifier_sand_king_sand_2", "radius") - self.hit_radius

self.radius_speed = 60
self.radius_k = 1
self.radius_timer = 0 
self.radius_timer_max = 2
self.radius_stop = false
self.radius = self.radius_min

self.ability =  self:GetAbility()
self.caster = self:GetCaster()
self.target_point = nil
self.damage_dealt = false

self.center = self.thinker:GetAbsOrigin()

self.current_angle = table.angle

self.current_speed = 1.75

self.dt = 0.01
self:StartIntervalThink(self.dt)
self:OnIntervalThink()
end 

function modifier_sandking_sand_storm_custom_cyclone:OnIntervalThink()
if not IsServer() then return end 

if not self.thinker or self.thinker:IsNull() then 
	self:Destroy()
	return
end 


self.center = self.thinker:GetAbsOrigin()

self.current_angle = self.current_angle + self.current_speed * self.dt
if self.current_angle > 2*math.pi then
	self.current_angle = self.current_angle - 2*math.pi
end

local position = self:GetPosition()
self.parent:SetAbsOrigin(position)

--local targets = self.caster:FindTargets(self.hit_radius, position)



if self.radius_stop == true then 
	self.radius_timer = self.radius_timer + self.dt

	if self.radius_timer >= self.radius_timer_max then 
		self.radius_stop = false
		self.radius_timer = 0
	else 
		return
	end
end 

self.radius = self.radius + self.radius_k * self.radius_speed * self.dt

if self.radius >= self.radius_max then 
	self.radius_k = -1
	self.radius_stop = true
end 

if self.radius <= self.radius_min then 
	self.radius_k = 1
	self.radius_stop = true
end 


end


function modifier_sandking_sand_storm_custom_cyclone:GetPosition()

local abs = GetGroundPosition(self.center + Vector( math.cos( self.current_angle ), math.sin( self.current_angle ), 0 ) * self.radius, nil)

return abs
end

function modifier_sandking_sand_storm_custom_cyclone:OnDestroy()
if not IsServer() then return end 

self:GetParent():StopSound("SandKing.Tornado_loop")

end 



function modifier_sandking_sand_storm_custom_cyclone:IsAura()
    return true
end

function modifier_sandking_sand_storm_custom_cyclone:GetModifierAura()
    return "modifier_sandking_sand_storm_custom_damage_cd"
end

function modifier_sandking_sand_storm_custom_cyclone:GetAuraRadius()
    return self.hit_radius
end

function modifier_sandking_sand_storm_custom_cyclone:GetAuraDuration()
    return 0.1
end

function modifier_sandking_sand_storm_custom_cyclone:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_sandking_sand_storm_custom_cyclone:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end














modifier_sandking_sand_storm_custom_silence = class({})
function modifier_sandking_sand_storm_custom_silence:IsHidden() return true end
function modifier_sandking_sand_storm_custom_silence:IsPurgable() return true end
function modifier_sandking_sand_storm_custom_silence:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_sand_king_sand_4", "slow")
end

function modifier_sandking_sand_storm_custom_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
}
end


function modifier_sandking_sand_storm_custom_silence:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_sandking_sand_storm_custom_silence:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end



function modifier_sandking_sand_storm_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_sandking_sand_storm_custom_silence:ShouldUseOverheadOffset() return true end
function modifier_sandking_sand_storm_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_sandking_sand_storm_custom_silence:GetStatusEffectName()
return "particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf"
end


function modifier_sandking_sand_storm_custom_silence:StatusEffectPriority()
return 99999
end



modifier_sandking_sand_storm_custom_damage_cd = class({})
function modifier_sandking_sand_storm_custom_damage_cd:IsHidden() return true end
function modifier_sandking_sand_storm_custom_damage_cd:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_damage_cd:OnCreated()
if not IsServer() then return end
self.caster = self:GetCaster()

self.silence = self.caster:GetTalentValue("modifier_sand_king_sand_4", "silence")
self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_sandking_sand_storm_custom_silence", {duration = self.silence*(1 - self:GetParent():GetStatusResistance())})

self.damage = self:GetCaster():GetTalentValue("modifier_sand_king_sand_4", "damage")/100

ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetDamage(self:GetParent())*self.damage, damage_type = DAMAGE_TYPE_MAGICAL})

local particle = ParticleManager:CreateParticle("particles/sand_king/tornado_damage.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

self:GetParent():EmitSound("SandKing.Tornado_damage")
end 



modifier_sandking_sand_storm_custom_heal = class({})
function modifier_sandking_sand_storm_custom_heal:IsHidden() return true end
function modifier_sandking_sand_storm_custom_heal:IsPurgable() return false end
function modifier_sandking_sand_storm_custom_heal:OnCreated()

self.heal = self:GetCaster():GetTalentValue("modifier_sand_king_sand_6", "heal")/self:GetCaster():GetTalentValue("modifier_sand_king_sand_6", "duration")

if not IsServer() then return end 

self.interval = 0.5

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 

function modifier_sandking_sand_storm_custom_heal:OnIntervalThink()
if not IsServer() then return end 

self:GetParent():SendNumber(10, self.heal*self.interval*self:GetParent():GetMaxHealth()/100)
end 


function modifier_sandking_sand_storm_custom_heal:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_sandking_sand_storm_custom_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end



function modifier_sandking_sand_storm_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end


function modifier_sandking_sand_storm_custom_heal:GetModifierHealthRegenPercentage()
return self.heal
end


modifier_sandking_sand_storm_custom_root = class({})
function modifier_sandking_sand_storm_custom_root:IsHidden() return true end
function modifier_sandking_sand_storm_custom_root:IsPurgable() return true end
function modifier_sandking_sand_storm_custom_root:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(0.1)
end

function modifier_sandking_sand_storm_custom_root:OnIntervalThink()
if not IsServer() then return end

self.effect_cast = ParticleManager:CreateParticle( "particles/sand_king/sand_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.effect_cast,false, false, -1, false, false)


self:StartIntervalThink(-1)
end 

function modifier_sandking_sand_storm_custom_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end




