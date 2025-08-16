LinkLuaModifier( "modifier_morphling_adaptive_strike_custom_tracker", "abilities/morphling/morphling_adaptive_strike_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_adaptive_strike_custom_legendary_aoe", "abilities/morphling/morphling_adaptive_strike_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_adaptive_strike_custom_auto_stack", "abilities/morphling/morphling_adaptive_strike_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_adaptive_strike_custom_shield", "abilities/morphling/morphling_adaptive_strike_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_adaptive_strike_custom_slow", "abilities/morphling/morphling_adaptive_strike_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_adaptive_strike_custom_heal_reduce", "abilities/morphling/morphling_adaptive_strike_custom", LUA_MODIFIER_MOTION_NONE )


morphling_adaptive_strike_custom = class({})



function morphling_adaptive_strike_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_adaptive_strike_agi_proj.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_adaptive_strike_str_proj.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_adaptive_strike_str.vpcf", context )
PrecacheResource( "particle", "particles/morphling/adaptive_linear.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/stinger_target.vpcf", context )
PrecacheResource( "particle", "particles/morphling/adaptive_aoe.vpcf", context )
PrecacheResource( "particle", "particles/morphling/adaptive_aoe_zone.vpcf", context )
PrecacheResource( "particle", "particles/morphling/adaptive_refresh.vpcf", context )
PrecacheResource( "particle", "particles/morphling/adaptive_shield.vpcf", context )
end


function morphling_adaptive_strike_custom:GetAbilityTextureName()
local caster = self:GetCaster()
if caster:HasModifier("modifier_morphling_morph_custom_legendary") then
  return "morphling_adaptive_strike_str"
end
if caster:HasModifier("modifier_morphling_blade_tears_custom") then
    return "morphling_adaptive_strike_agi_ethereal_blade"
end
return "morphling_adaptive_strike_agi"
end

function morphling_adaptive_strike_custom:GetIntrinsicModifierName()
return "modifier_morphling_adaptive_strike_custom_tracker"
end

function morphling_adaptive_strike_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_morphling_adaptive_7") then
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end

function morphling_adaptive_strike_custom:GetAOERadius()
return self:GetCaster():HasTalent("modifier_morphling_adaptive_7") and self:GetCaster():GetTalentValue("modifier_morphling_adaptive_7", "radius") or self:GetSpecialValueFor("radius")
end

function morphling_adaptive_strike_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_morphling_adaptive_4") then
	bonus = self:GetCaster():GetTalentValue("modifier_morphling_adaptive_4", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end


function morphling_adaptive_strike_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_morphling_adaptive_4") then
	bonus = self:GetCaster():GetTalentValue("modifier_morphling_adaptive_4", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end

function morphling_adaptive_strike_custom:GetCastRange(vLocation, hTarget)
local bonus = 0
if self:GetCaster():HasTalent("modifier_morphling_adaptive_7") then
	bonus = self:GetCaster():GetTalentValue("modifier_morphling_adaptive_7", "range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + bonus
end

function morphling_adaptive_strike_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level) 
end




function morphling_adaptive_strike_custom:OnSpellStart(new_target)
local caster = self:GetCaster()
local target = new_target and new_target or self:GetCursorTarget()
local attribute_legendary = caster:HasModifier("modifier_morphling_morph_custom_legendary")
local sound = attribute_legendary and "Hero_Morphling.AdaptiveStrikeStr.Cast" or "Hero_Morphling.AdaptiveStrikeAgi.Cast"

if caster:HasTalent("modifier_morphling_hero_7") then
	caster:AddNewModifier(caster, self, "modifier_can_not_push", {duration = 3})
end

local speed = self:GetSpecialValueFor("projectile_speed")
local extra_data =
{
	is_auto = new_target ~= nil,
	is_attribute_legendary = attribute_legendary,
}

if not new_target and caster:HasTalent("modifier_morphling_adaptive_7") then
	local point = self:GetCursorPosition()
	local origin = caster:GetAbsOrigin()
	if (origin == point) then
		point = origin + caster:GetForwardVector()*10
	end

	local dir = (point - origin)
	speed = caster:GetTalentValue("modifier_morphling_adaptive_7", "speed")

	local info = 
	{
		EffectName = "particles/morphling/adaptive_linear.vpcf",
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fStartRadius = 50,
		fEndRadius = 50,
		vVelocity = dir:Normalized() * speed,
		fDistance = dir:Length2D(),
		Source = caster,
		bProvidesVision = true,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iVisionRadius = 150,
		ExtraData = extra_data
	}
	ProjectileManager:CreateLinearProjectile( info )

	CreateModifierThinker(caster, self, "modifier_morphling_adaptive_strike_custom_legendary_aoe", {duration = dir:Length2D()/speed}, point, caster:GetTeamNumber(), false)
else
	local info = 
	{
		EffectName = attribute_legendary and "particles/units/heroes/hero_morphling/morphling_adaptive_strike_str_proj.vpcf" or "particles/units/heroes/hero_morphling/morphling_adaptive_strike_agi_proj.vpcf",
		Ability = self,
		iMoveSpeed = speed,
		Source = caster,
		Target = target,
		bDodgeable = true,
		bProvidesVision = true,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iVisionRadius = 100,
		ExtraData = extra_data
	}
	ProjectileManager:CreateTrackingProjectile( info )
end

if attribute_legendary then
	local ability = caster:FindAbilityByName("morphling_attribute_legendary_custom")
	if ability then
		caster:AddNewModifier(caster, ability, "modifier_morphling_morph_custom_legendary_attack", {duration = caster:GetTalentValue("modifier_morphling_attribute_7", "strike_duration")})
	end
end

if caster:HasTalent("modifier_morphling_hero_7") then
	caster:GenericHeal(caster:GetStrength()*caster:GetTalentValue("modifier_morphling_hero_7", "heal")/100, self, nil, nil, "modifier_morphling_hero_7")
end

caster:EmitSound(sound)
end


function morphling_adaptive_strike_custom:DealDamage(target, damage, knock_distance, center, is_auto)
local caster = self:GetCaster()
local knockback_max = self:GetSpecialValueFor("knockback_max")
local knockback_speed = knockback_max/self:GetSpecialValueFor("knockback_duration")
local creeps_shield = caster:GetTalentValue("modifier_morphling_adaptive_2", "creeps", true)

local real_damage = DoDamage({victim = target, attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}, is_auto and "modifier_morphling_adaptive_3" or nil)

if target:IsRealHero() and caster:GetQuest() == "Morphling.Quest_6" and not caster:QuestCompleted() and caster:GetBaseStrength() <= 1 then
	caster:UpdateQuest(1)
end

if caster:HasTalent("modifier_morphling_hero_4") then
	target:AddNewModifier(caster, caster:BkbAbility(self, true), "modifier_morphling_adaptive_strike_custom_heal_reduce", {duration = caster:GetTalentValue("modifier_morphling_hero_4", "duration")})
end

if caster:HasTalent("modifier_morphling_adaptive_7") and not is_auto then
	target:SendNumber(24, real_damage)
end

if not target:IsIllusion() then
	real_damage = target:IsCreep() and real_damage/creeps_shield or real_damage 
else
	real_damage = 0
end

if not is_auto then 
	local knockbackProperties =
	{
	  center_x = center.x,
	  center_y = center.y,
	  center_z = center.z,
	  duration = knock_distance/knockback_speed,
	  knockback_duration = knock_distance/knockback_speed,
	  knockback_distance = knock_distance,
	  knockback_height = 0,
	  should_stun = caster:HasTalent("modifier_morphling_hero_7") and 1 or 0
	}
	target:AddNewModifier( caster, self, "modifier_knockback", knockbackProperties )
end

return real_damage
end


function morphling_adaptive_strike_custom:OnProjectileHit_ExtraData(target, location, table)
local caster = self:GetCaster()
local agility = caster:GetAgility()
local strength = caster:GetStrength()
local point = GetGroundPosition(location, nil)
local cd_items = true
local is_auto = table.is_auto ~= nil and table.is_auto ~= 0

local slow_duration = caster:GetTalentValue("modifier_morphling_adaptive_3", "duration", true)

local ratio = agility/strength
local sound =  (agility >= strength or is_auto) and "Hero_Morphling.AdaptiveStrikeAgi.Target" or "Hero_Morphling.AdaptiveStrikeStr.Target"
EmitSoundOnLocationWithCaster(point, sound, caster)

local radius = self:GetSpecialValueFor("radius")

local stats_max = 1 + self:GetSpecialValueFor("stats_max")/100
local base_damage = self:GetSpecialValueFor("damage_base")

local base_damage = self:GetSpecialValueFor("damage_base")
local min_damage = self:GetSpecialValueFor("damage_min")
local max_damage = self:GetSpecialValueFor("damage_max")

local knockback_min = self:GetSpecialValueFor("knockback_min")
local knockback_max = self:GetSpecialValueFor("knockback_max")

local stun_min = caster:GetTalentValue("modifier_morphling_hero_7", "stun_min", true)
local stun_max = caster:GetTalentValue("modifier_morphling_hero_7", "stun_max", true)

local stun_duration
local knock_distance 

if ratio <= 1/stats_max then
	knock_distance = knockback_max
	stun_duration = stun_max
elseif ratio >= stats_max then 
	knock_distance = knockback_min
	stun_duration = stun_min
else
	stun_duration = stun_min + (stun_max - stun_min)*((strength/agility)/stats_max)
	knock_distance = knockback_min + (knockback_max - knockback_min)*((strength/agility)/stats_max)
end

local min_ratio = 0.5
local max_ratio = 1.5

local clamped = math.min(math.max(ratio, min_ratio),  max_ratio )
local t = (clamped - min_ratio) / (max_ratio - min_ratio)
local multiplier = min_damage + (max_damage - min_damage) * t

if table.is_attribute_legendary == 1 then
	multiplier = max_damage
end

local damage = base_damage + agility * (multiplier + caster:GetTalentValue("modifier_morphling_adaptive_1", "damage"))

damage = is_auto and damage*caster:GetTalentValue("modifier_morphling_adaptive_3", "damage")/100 or damage

local total_damage = 0

if not target then 
	if caster:HasTalent("modifier_morphling_adaptive_7") then
		radius = caster:GetTalentValue("modifier_morphling_adaptive_7", "radius")
		local inner_radius = caster:GetTalentValue("modifier_morphling_adaptive_7", "inner_radius")

		local aoe_effect = caster:HasModifier("modifier_morphling_blade_tears_custom") and "particles/morphling/adaptive_aoe_immortal.vpcf" or "particles/morphling/adaptive_aoe.vpcf"

		local effect2 = ParticleManager:CreateParticle(aoe_effect, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect2, 0, point)
		ParticleManager:SetParticleControl(effect2, 1, point)
		ParticleManager:SetParticleControl(effect2, 2, Vector(radius, radius, radius))
		ParticleManager:SetParticleControl(effect2, 7, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(effect2)

		local near_hit = false

		for _,unit in pairs(caster:FindTargets(radius, point)) do
			local vec = (unit:GetAbsOrigin() - point)
			if vec:Length2D() <= inner_radius then
				near_hit = true
			end
			local knock_center = point
			if table.is_attribute_legendary == 1 then
				knock_center = unit:GetAbsOrigin() + vec:Normalized()*100 
				knock_distance = vec:Length2D()
			end
			total_damage = total_damage + self:DealDamage(unit, damage, knock_distance, knock_center, is_auto)

			if caster:HasTalent("modifier_morphling_hero_7") then
				unit:AddNewModifier(caster, self, "modifier_stunned", {duration = (1 - unit:GetStatusResistance())*stun_duration})
			end
		end

		if near_hit then
			caster:CdAbility(self, self:GetCooldownTimeRemaining()*caster:GetTalentValue("modifier_morphling_adaptive_7", "cd_inc")/100)

			local effect = ParticleManager:CreateParticle("particles/morphling/adaptive_refresh.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt( effect, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex(effect)

			caster:EmitSound("Morph.Adaptive_refresh")
		else
			cd_items = false
		end
	end
else
	if not is_auto then
		if target:TriggerSpellAbsorb(self) then return end
	end

	for _,unit in pairs(caster:FindTargets(radius, point)) do

		local knock_center = caster:GetAbsOrigin()
		if table.is_attribute_legendary == 1 then
			local vec = (unit:GetAbsOrigin() - knock_center)

			knock_center = unit:GetAbsOrigin() + vec:Normalized()*100 
			knock_distance = math.min(vec:Length2D() - 180, knockback_max)
		end

		total_damage = total_damage + self:DealDamage(unit, damage, knock_distance, knock_center, is_auto)
		if is_auto then
			unit:AddNewModifier(caster, self, "modifier_morphling_adaptive_strike_custom_slow", {duration = slow_duration})
		else
			if caster:HasTalent("modifier_morphling_hero_7") then
				unit:AddNewModifier(caster, self, "modifier_stunned", {duration = (1 - unit:GetStatusResistance())*stun_duration})
			end
		end
	end

	if table.is_attribute_legendary == 0 then

		local effect_point = point
        local adaptiva_fx_name = "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf"
        if caster:HasModifier("modifier_morphling_blade_tears_custom") then
        	effect_point = caster:GetAbsOrigin()
            adaptiva_fx_name = "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf"
        end
		local particle = (agility >= strength or is_auto) and adaptiva_fx_name or "particles/units/heroes/hero_morphling/morphling_adaptive_strike_str.vpcf"

		local effect = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(effect, 0, effect_point)
		ParticleManager:SetParticleControl(effect, 1, point)
		ParticleManager:ReleaseParticleIndex(effect)
	end
end

if cd_items and caster:HasTalent("modifier_morphling_adaptive_4") and not is_auto then
	caster:CdItems(caster:GetTalentValue("modifier_morphling_adaptive_4", "cd_items"))
end

if total_damage > 0 and caster:HasTalent("modifier_morphling_adaptive_2") then
	local shield = total_damage*caster:GetTalentValue("modifier_morphling_adaptive_2", "shield")/100
	caster:AddNewModifier(caster, self, "modifier_morphling_adaptive_strike_custom_shield", {shield = shield, duration = caster:GetTalentValue("modifier_morphling_adaptive_2", "duration")})
end

end



modifier_morphling_adaptive_strike_custom_tracker = class(mod_hidden)
function modifier_morphling_adaptive_strike_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.auto_duration = self.parent:GetTalentValue("modifier_morphling_adaptive_3", "effect_duration", true)

self.legendary_spell = self.parent:GetTalentValue("modifier_morphling_adaptive_7", "spell", true)
self.legendary_agi = self.parent:GetTalentValue("modifier_morphling_adaptive_7", "agi", true)
self.legendary_cd = self.parent:GetTalentValue("modifier_morphling_adaptive_7", "cd_items", true)

if not IsServer() then return end
self:UpdateTalent()
end

function modifier_morphling_adaptive_strike_custom_tracker:OnRefresh()
if not IsServer() then return end
self:UpdateTalent()
end


function modifier_morphling_adaptive_strike_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_morphling_adaptive_7" or self.parent:HasTalent("modifier_morphling_adaptive_7") then
	self.parent:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)
	local mod = self.parent:FindModifierByName("modifier_morphling_innate_custom_buff")
	if mod then
		mod:UpdateMainStat()
	end

	if self.parent:IsRealHero() then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "ability_morphling_adaptive",  {})
		self:StartIntervalThink(0.5)
	end
end

if name == "modifier_morphling_adaptive_3" or self.parent:HasTalent("modifier_morphling_adaptive_3") then
	self.parent:AddSpellEvent(self, true)
end

end


function modifier_morphling_adaptive_strike_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if self.parent:HasTalent("modifier_morphling_attribute_7") then return end
self.parent:UpdateUIlong({override_stack = math.floor(self.parent:GetSpellAmplification(false)*100).."%", no_min = 1, style = "MorphAdaptive"})
end


function modifier_morphling_adaptive_strike_custom_tracker:SpellEvent(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_morphling_adaptive_3") then return end
if self.parent ~= params.unit then return end

local index = nil
local delay = nil
if params.target then
	index = params.target:entindex()
end
if params.ability == self.ability then
	delay = 0.25
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_adaptive_strike_custom_auto_stack", {target = index, delay = delay, duration = self.auto_duration})
end


function modifier_morphling_adaptive_strike_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_morphling_adaptive_strike_custom_tracker:GetModifierSpellAmplify_Percentage()
if not self.parent:HasTalent("modifier_morphling_adaptive_7") then return end
return (self.parent:GetAgility()/self.legendary_agi)*self.legendary_spell
end






modifier_morphling_adaptive_strike_custom_auto_stack = class(mod_visible)
function modifier_morphling_adaptive_strike_custom_auto_stack:GetTexture() return "buffs/morphling/adaptive_3" end
function modifier_morphling_adaptive_strike_custom_auto_stack:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.parent:GetTalentValue("modifier_morphling_adaptive_3", "count")
self.radius = self.parent:GetTalentValue("modifier_morphling_adaptive_3", "radius") + self.parent:GetCastRangeBonus()

self.RemoveForDuel = true

self:SetStackCount(1)
end

function modifier_morphling_adaptive_strike_custom_auto_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() < self.max then return end

self.target = table.target and EntIndexToHScript(table.target) or nil
local delay = table.delay and table.delay or 0

self:StartIntervalThink(delay)
end


function modifier_morphling_adaptive_strike_custom_auto_stack:OnIntervalThink()
if not IsServer() then return end

if not self.target or self.target:IsNull() then
	self.target = self.parent:RandomTarget(self.radius)
end
if self.target then
	self.ability:OnSpellStart(self.target)
end

self:Destroy()
end





modifier_morphling_adaptive_strike_custom_legendary_aoe = class(mod_hidden)
function modifier_morphling_adaptive_strike_custom_legendary_aoe:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.radius = self.caster:GetTalentValue("modifier_morphling_adaptive_7", "radius")
self.time = self:GetRemainingTime()

if not IsServer() then return end
AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), self.radius, self.time + 3, false)
self.effect_cast = ParticleManager:CreateParticleForTeam( "particles/morphling/adaptive_aoe_zone.vpcf", PATTACH_CUSTOMORIGIN, self.caster, self.caster:GetTeamNumber() )
ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -(self.radius/self.time) ) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self.time, 0, 0 ) )
self:AddParticle(self.effect_cast, false, false, -1, false, false)
end





modifier_morphling_adaptive_strike_custom_shield = class(mod_visible)
function modifier_morphling_adaptive_strike_custom_shield:GetTexture() return "buffs/morphling/adaptive_2" end
function modifier_morphling_adaptive_strike_custom_shield:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_morphling_adaptive_strike_custom_shield:OnTooltip()
return self.max_shield
end

function modifier_morphling_adaptive_strike_custom_shield:OnTooltip2()
return self.damage_reduce
end

function modifier_morphling_adaptive_strike_custom_shield:OnCreated(table)
self.parent = self:GetParent()
self.shield_talent = "modifier_morphling_adaptive_2"

self.damage_reduce = self.parent:GetTalentValue("modifier_morphling_adaptive_2", "damage_reduce")

if not IsServer() then return end
self:AddShield(table.shield)
self:SetHasCustomTransmitterData(true)
self.RemoveForDuel = true

self.cast_effect = ParticleManager:CreateParticle("particles/morphling/adaptive_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.cast_effect, 0,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControl( self.cast_effect, 1, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControlEnt( self.cast_effect, 2,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
self:AddParticle( self.cast_effect, false, false, -1, false, false  )
end


function modifier_morphling_adaptive_strike_custom_shield:AddCustomTransmitterData() 
return 
{
  max_shield = self.max_shield,
} 
end

function modifier_morphling_adaptive_strike_custom_shield:HandleCustomTransmitterData(data)
self.max_shield = data.max_shield
end


function modifier_morphling_adaptive_strike_custom_shield:OnRefresh(table)
if not IsServer() then return end
self:AddShield(table.shield)
end

function modifier_morphling_adaptive_strike_custom_shield:AddShield(shield)
if not IsServer() then return end
self.max_shield = self.parent:GetTalentValue("modifier_morphling_adaptive_2", "max_shield")
self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + shield))

self:SendBuffRefreshToClients()
end


function modifier_morphling_adaptive_strike_custom_shield:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() == 0 then return end

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end

local damage = math.min(params.damage*self.damage_reduce/100, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end



modifier_morphling_adaptive_strike_custom_slow = class(mod_hidden)
function modifier_morphling_adaptive_strike_custom_slow:IsPurgable() return true end
function modifier_morphling_adaptive_strike_custom_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_morphling_adaptive_3", "slow")
end

function modifier_morphling_adaptive_strike_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_morphling_adaptive_strike_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end



modifier_morphling_adaptive_strike_custom_heal_reduce = class(mod_visible)
function modifier_morphling_adaptive_strike_custom_heal_reduce:GetTexture() return "buffs/morphling/hero_4" end
function modifier_morphling_adaptive_strike_custom_heal_reduce:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.heal_reduce = self.caster:GetTalentValue("modifier_morphling_hero_4", "heal_reduce")
end

function modifier_morphling_adaptive_strike_custom_heal_reduce:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end


function modifier_morphling_adaptive_strike_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_morphling_adaptive_strike_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end

function modifier_morphling_adaptive_strike_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end
