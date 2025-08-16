LinkLuaModifier( "modifier_ogre_magi_fireblast_tracker", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_fireblast_fire", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_fireblast_shield_cd", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_fireblast_shield", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_fireblast_speed", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_fireblast_attack", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_fireblast_damage", "abilities/ogre_magi/ogre_magi_fireblast", LUA_MODIFIER_MOTION_NONE )



ogre_magi_fireblast_custom = class({})
ogre_magi_unrefined_fireblast_custom = class({})


function ogre_magi_fireblast_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom") then
    return "ogre_magi/arcana/ogre_magi_fireblast_arcana"
end
if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom_2") then
    return "ogre_magi/arcana/ogre_magi_fireblast_arcana_alt1"
end
return "ogre_magi_fireblast"
end

function ogre_magi_unrefined_fireblast_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom") then
    return "ogre_magi/arcana/ogre_magi_unrefined_fireblast_arcana"
end
if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom_2") then
    return "ogre_magi/arcana/ogre_magi_unrefined_fireblast_arcana_alt1"
end
return "ogre_magi_unrefined_fireblast"
end



function ogre_magi_fireblast_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context )
PrecacheResource( "particle","particles/ogre_fireball.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast.vpcf", context )
PrecacheResource( "particle","particles/ogre_fireball_agh.vpcf", context )
PrecacheResource( "particle","particles/ogre_knockback.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf", context )
PrecacheResource( "particle","particles/ogre_fire_stack.vpcf", context )
PrecacheResource( "particle","particles/ogre_magi/fire_shield.vpcf", context )
PrecacheResource( "particle","particles/ogre_magichit.vpcf", context )
PrecacheResource( "particle","particles/ogre_hit.vpcf", context )
PrecacheResource( "particle","particles/ogre_magi/fireblast_stack.vpcf", context )
 
dota1x6:PrecacheShopItems("npc_dota_hero_ogre_magi", context)
end


function ogre_magi_unrefined_fireblast_custom:GetManaCost( level )
return math.floor( self:GetCaster():GetMana() * self:GetSpecialValueFor( "scepter_mana" ) / 100 )
end


function ogre_magi_fireblast_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_ogremagi_blast_5") then 
    bonus = self:GetCaster():GetTalentValue("modifier_ogremagi_blast_5", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function ogre_magi_unrefined_fireblast_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_ogremagi_blast_5") then 
    bonus = self:GetCaster():GetTalentValue("modifier_ogremagi_blast_5", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function ogre_magi_fireblast_custom:GetIntrinsicModifierName()
return "modifier_ogre_magi_fireblast_tracker"
end

function ogre_magi_fireblast_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_ogremagi_blast_7") then
	return  DOTA_ABILITY_BEHAVIOR_POINT
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end


function ogre_magi_fireblast_custom:GetCooldown(iLevel)
local bonus = 0 
if self:GetCaster():HasTalent("modifier_ogremagi_blast_3") then 
  bonus = self:GetCaster():GetTalentValue("modifier_ogremagi_blast_3", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function ogre_magi_fireblast_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasTalent("modifier_ogremagi_blast_7") then 
	if IsClient() then 
		return self:GetCaster():GetTalentValue("modifier_ogremagi_blast_7", "range")
	else 
		return 999999
	end
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end


function ogre_magi_unrefined_fireblast_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_ogremagi_blast_7") then
	return  DOTA_ABILITY_BEHAVIOR_POINT
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end


function ogre_magi_unrefined_fireblast_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasTalent("modifier_ogremagi_blast_7") then 
	if IsClient() then 
		return self:GetCaster():GetTalentValue("modifier_ogremagi_blast_7", "range")
	else 
		return 999999
	end
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end




function ogre_magi_fireblast_custom:GetParticle(type)
if type == 1 then 

	local effect_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf"
	if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom") then
	    effect_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast.vpcf"
	elseif self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom_2") then
	    effect_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_secondstyle_fireblast.vpcf"
	end

	return effect_name
end 
if type == 2 then 
	return "particles/ogre_fireball.vpcf"
end

end


function ogre_magi_fireblast_custom:GetDamage(target)
local caster = self:GetCaster()
local damage = self:GetSpecialValueFor("fireblast_damage")

if caster:HasTalent("modifier_ogremagi_blast_1") then 
	damage = damage + caster:GetStrength()*caster:GetTalentValue("modifier_ogremagi_blast_1", "damage")/100
end
if target and target:IsCreep() and caster:HasTalent("modifier_ogremagi_blast_7") then 
	damage = damage * caster:GetTalentValue("modifier_ogremagi_blast_7", "creeps")/100
end
return damage
end



function ogre_magi_fireblast_custom:Impact(target, ability, damage_inc)
if not IsServer() then return end

local caster = self:GetCaster()

local duration = ability:GetSpecialValueFor( "stun_duration" ) 
if ability == self and caster:HasTalent("modifier_ogremagi_blast_1") then 
	duration = duration + caster:GetTalentValue("modifier_ogremagi_blast_1", "stun")
end
duration = duration * (1 - target:GetStatusResistance())

local damage = ability:GetDamage(target)
local cleave = ability:GetSpecialValueFor( "cleave_damage" )/100

if caster:GetQuest() == "Ogre.Quest_5" and target:IsRealHero() and not caster:QuestCompleted() then 
	caster:UpdateQuest(duration)
end
target:AddNewModifier( caster, ability,  "modifier_stunned",  {duration = duration})


if not caster:HasTalent("modifier_ogremagi_blast_7") then 
	for _,aoe_target in pairs(caster:FindTargets(ability:GetSpecialValueFor("cleave_radius"), target:GetAbsOrigin())) do 
		if aoe_target ~= target then
			DoDamage( { victim = aoe_target, attacker = caster, damage = damage*cleave, damage_type = ability:GetAbilityDamageType(), ability = ability }) 
		end 
	end 
else
	local mod = caster:FindModifierByName("modifier_ogre_magi_dumb_luck_custom")
	if mod and target:IsRealHero() then 
		mod:AddStack()
	end	
end

if damage_inc and damage_inc == 1 then 
	target:AddNewModifier(caster, self, "modifier_ogre_magi_fireblast_damage", {duration = caster:GetTalentValue("modifier_ogremagi_blast_7", "duration")})
end

DoDamage( { victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType(), ability = ability } )

local particle = ParticleManager:CreateParticle(ability:GetParticle(1), PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( particle, 1, target:GetOrigin() )
ParticleManager:ReleaseParticleIndex( particle )
target:EmitSound("Hero_OgreMagi.Fireblast.Target")
end




function ogre_magi_fireblast_custom:OnHit(target, location, data, ability)
local caster = self:GetCaster()

if not target then 
	if caster:HasTalent("modifier_ogremagi_blast_7") then
		local point = GetGroundPosition(location, nil) + Vector(0,0,70)
		local particle = ParticleManager:CreateParticle(ability:GetParticle(1), PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, point)
		ParticleManager:SetParticleControl( particle, 1, point)
		ParticleManager:ReleaseParticleIndex( particle )
		EmitSoundOnLocationWithCaster(location, "Hero_OgreMagi.Fireblast.Target", caster)
	end
	return
end


local damage_inc = 0
if data.x and data.y then  
	local dist = (target:GetAbsOrigin() - GetGroundPosition(Vector(data.x, data.y, 0), nil)):Length2D() 

	if dist >= caster:GetTalentValue("modifier_ogremagi_blast_7", "distance") then 
		damage_inc = 1
	end 
end

self:Impact(target,ability,damage_inc)
end


function ogre_magi_fireblast_custom:OnProjectileHit_ExtraData(target, location, data)
self:OnHit(target, location, data, self)
end


function ogre_magi_fireblast_custom:OnSpellStart(new_target, point)
self:Cast(new_target, point, self)
end



function ogre_magi_fireblast_custom:Cast(new_target, point, ability)

local caster = self:GetCaster()
caster:EmitSound("Hero_OgreMagi.Fireblast.Cast")
local target = nil 

if not new_target then 
	if caster:HasModifier("modifier_ogre_magi_arcana_custom") then
	    local particle = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_fireblast_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	    ParticleManager:ReleaseParticleIndex(particle)
	elseif caster:HasModifier("modifier_ogre_magi_arcana_custom_2") then
	    local particle = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_secondstyle_fireblast_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	    ParticleManager:ReleaseParticleIndex(particle)
	end
end


if caster:HasTalent("modifier_ogremagi_blast_7") then 
	target = self:GetCursorPosition()
	if point ~= nil then 
		target = point
	end

	if target == caster:GetAbsOrigin() then 
		target = caster:GetAbsOrigin() + caster:GetForwardVector()
	end
else 
	target = self:GetCursorTarget()

	if new_target ~= nil then 
		target = new_target
	end
end


if caster:HasTalent("modifier_ogremagi_blast_5") then 
	caster:AddNewModifier(caster, ability, "modifier_ogre_magi_fireblast_speed", {duration = caster:GetTalentValue("modifier_ogremagi_blast_5", "duration")})
end	


if caster:HasTalent("modifier_ogremagi_blast_7") then 

	local point = target

	local radius = caster:GetTalentValue("modifier_ogremagi_blast_7", "width")
	local speed = caster:GetTalentValue("modifier_ogremagi_blast_7", "speed")
	local range = caster:GetTalentValue("modifier_ogremagi_blast_7", "range") + caster:GetCastRangeBonus()
	local vision = 280

	local direction = point-caster:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()
	local origin = caster:GetAbsOrigin()

	origin.z = origin.z + 100

	local info = {
		Source = caster,
		Ability = ability,
		vSpawnOrigin = origin,

		bDeleteOnHit = false,

		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

		EffectName = ability:GetParticle(2),
		fDistance = range,
		fStartRadius = radius,
		fEndRadius = radius,
		vVelocity = direction * speed,

		bProvidesVision = true,
		iVisionRadius = vision,
		iVisionTeamNumber = caster:GetTeamNumber(),
		ExtraData = 
		{
			x = caster:GetAbsOrigin().x,
			y = caster:GetAbsOrigin().y,
		}
	}
	ProjectileManager:CreateLinearProjectile(info)
else 
	if target:TriggerSpellAbsorb( self ) then return end
	self:Impact(target, ability)
end

end




function ogre_magi_unrefined_fireblast_custom:GetParticle(type)
if type == 1 then 

	local effect_name = "particles/units/heroes/hero_ogre_magi/ogre_magi_unr_fireblast.vpcf"
	if self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom") then
	    effect_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast.vpcf"
	elseif self:GetCaster():HasModifier("modifier_ogre_magi_arcana_custom_2") then
	    effect_name = "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_unrefined_fireblast_secondstyle.vpcf"
	end

	return effect_name
end 
if type == 2 then 
	return "particles/ogre_fireball_agh.vpcf"
end

end


function ogre_magi_unrefined_fireblast_custom:GetDamage(target)
local caster = self:GetCaster()
local damage = self:GetSpecialValueFor( "fireblast_damage" ) + caster:GetStrength()*self:GetSpecialValueFor("str_damage")/100

if target:IsCreep() and caster:HasTalent("modifier_ogremagi_blast_7") then 
	damage = damage * caster:GetTalentValue("modifier_ogremagi_blast_7", "creeps")/100
end
return damage
end


function ogre_magi_unrefined_fireblast_custom:OnProjectileHit_ExtraData( target, location, data)
local ability = self:GetCaster():FindAbilityByName("ogre_magi_fireblast_custom")
if ability then 
	ability:OnHit(target, location, data, self)
end 

end


function ogre_magi_unrefined_fireblast_custom:OnSpellStart(new_target, point)
local ability = self:GetCaster():FindAbilityByName("ogre_magi_fireblast_custom")

if ability then 
	ability:Cast(new_target, point, self)
end

end











modifier_ogre_magi_fireblast_tracker = class({})
function modifier_ogre_magi_fireblast_tracker:IsHidden() return true end
function modifier_ogre_magi_fireblast_tracker:IsPurgable() return false end
function modifier_ogre_magi_fireblast_tracker:GetTexture() return "buffs/fireblast_fullhp" end
function modifier_ogre_magi_fireblast_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ABSORB_SPELL,
  	MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end


function modifier_ogre_magi_fireblast_tracker:GetModifierPercentageManacostStacking()
if not self.parent:HasTalent("modifier_ogremagi_blast_3") then return end
return self.parent:GetTalentValue("modifier_ogremagi_blast_3", "mana")
end



function modifier_ogre_magi_fireblast_tracker:GetModifierCastRangeBonusStacking()
if not self.parent:HasTalent("modifier_ogremagi_blast_5") then return end 
return self.range_bonus
end


function modifier_ogre_magi_fireblast_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.heal_creeps = self.parent:GetTalentValue("modifier_ogremagi_blast_2", "creeps", true)
self.heal_bonus = self.parent:GetTalentValue("modifier_ogremagi_blast_2", "bonus", true)

self.shield_cd = self.parent:GetTalentValue("modifier_ogremagi_blast_6", "cd", true)
self.shield_duration = self.parent:GetTalentValue("modifier_ogremagi_blast_6", "duration", true)

self.range_bonus = self.parent:GetTalentValue("modifier_ogremagi_blast_5", "range", true)

if self.parent:IsRealHero() then 
	self.parent:AddDamageEvent_out(self)
end

end


function modifier_ogre_magi_fireblast_tracker:GetAbsorbSpell(params) 
if not IsServer() then return end
if not self.parent:HasTalent("modifier_ogremagi_blast_6") then return end
if self.parent:HasModifier("modifier_ogre_magi_fireblast_shield_cd") then return end
if self.parent:PassivesDisabled() then return end
if not params.ability then return end
if not params.ability:GetCaster() then return end

local caster = params.ability:GetCaster()

if caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_fireblast_shield_cd", {duration = self.shield_cd})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_ogre_magi_fireblast_shield", {duration = self.shield_duration})
end




function modifier_ogre_magi_fireblast_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_ogremagi_blast_2") then return end
if self.parent ~= params.attacker then return end
if not self.parent:IsAlive() then return end
if not params.unit:IsUnit() then return end

local heal = params.damage*self.parent:GetTalentValue("modifier_ogremagi_blast_2", "heal")/100

if params.unit:IsStunned() then 
	heal = heal * self.heal_bonus
end

if params.unit:IsCreep() then 
	heal = heal/self.heal_creeps
end

self.parent:GenericHeal(heal, self.ability, true, nil, "modifier_ogremagi_blast_2")
end



modifier_ogre_magi_fireblast_shield_cd = class({})
function modifier_ogre_magi_fireblast_shield_cd:IsHidden() return false end
function modifier_ogre_magi_fireblast_shield_cd:IsPurgable() return false end
function modifier_ogre_magi_fireblast_shield_cd:RemoveOnDeath() return false end
function modifier_ogre_magi_fireblast_shield_cd:IsDebuff() return true end
function modifier_ogre_magi_fireblast_shield_cd:GetTexture() return "buffs/fireblast_lowhp" end
function modifier_ogre_magi_fireblast_shield_cd:OnCreated(table)
self.RemoveForDuel = true 
end


modifier_ogre_magi_fireblast_shield = class({})
function modifier_ogre_magi_fireblast_shield:IsHidden() return false end
function modifier_ogre_magi_fireblast_shield:IsPurgable() return false end
function modifier_ogre_magi_fireblast_shield:GetTexture() return "buffs/fireblast_lowhp" end
function modifier_ogre_magi_fireblast_shield:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.shield_talent = "modifier_ogremagi_blast_6"
self.max_shield = self.parent:GetTalentValue("modifier_ogremagi_blast_6", "shield")*self.parent:GetMaxHealth()/100

if not IsServer() then return end

self.effect = ParticleManager:CreateParticle( "particles/ogre_magi/fire_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent  )
self:AddParticle(self.effect,false, false, -1, false, false)

self.target = nil
self.parent:EmitSound("Ogre.Blast_shield")
self:SetStackCount(self.max_shield)

self.activated = false
self:StartIntervalThink(0.1)
end

function modifier_ogre_magi_fireblast_shield:OnIntervalThink()
if not IsServer() then return end 

self.activated = true
self:StartIntervalThink(-1)
end


function modifier_ogre_magi_fireblast_shield:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_ogre_magi_fireblast_shield:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() == 0 then return end

if IsClient() then 
  if params.report_max then 
  	return self.max_shield
  else 
	  return self:GetStackCount()
	end 
end

if not IsServer() then return end
if self.activated == false then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
	self.target = params.attacker
  self:Destroy()
end

return -damage
end



function modifier_ogre_magi_fireblast_shield:OnDestroy()
if not IsServer() then return end 
if self:GetStackCount() > 0 then return end 

self.parent:EmitSound("Ogre.Blast_knock")

local radius = self.parent:GetTalentValue("modifier_ogremagi_blast_6", "radius")
local knock_distance = self.parent:GetTalentValue("modifier_ogremagi_blast_6", "knock_distance")
local targets = self.parent:FindTargets(radius)

if self.target and not self.target:IsNull() then
	table.insert(targets, self.target)
end

local particle = ParticleManager:CreateParticle("particles/ogre_knockback.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

local origin = self.parent:GetAbsOrigin()
local targets_hit = {}

for _,enemy in pairs(targets) do
	if not targets_hit[enemy:entindex()] then 
		targets_hit[enemy:entindex()] = true

		local dir = (enemy:GetOrigin() - origin)
		dir.z = 0

		local enemy_direction = dir:Normalized()
		local point = origin + enemy_direction*knock_distance 
		local distance = (point - enemy:GetAbsOrigin()):Length2D()

		if (dir:Length2D() > knock_distance) then 
			distance = 25
		end 

		enemy:AddNewModifier(self.parent, self.ability,
		"modifier_generic_knockback",
		{
			duration = 0.2,
			distance = distance,
			height = 0,
			direction_x = enemy_direction.x,
			direction_y = enemy_direction.y,
		})

		self.ability:Impact(enemy, self.ability)
	end
end

end


function modifier_ogre_magi_fireblast_shield:GetStatusEffectName()
return "particles/status_fx/status_effect_lina_flame_cloak.vpcf"
end

function modifier_ogre_magi_fireblast_shield:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end








modifier_ogre_magi_fireblast_speed = class({})
function modifier_ogre_magi_fireblast_speed:IsHidden() return true end
function modifier_ogre_magi_fireblast_speed:IsPurgable() return false end
function modifier_ogre_magi_fireblast_speed:OnCreated(table)
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_ogremagi_blast_5", "speed")
end

function modifier_ogre_magi_fireblast_speed:GetEffectName()
return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end
function modifier_ogre_magi_fireblast_speed:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ogre_magi_fireblast_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_ogre_magi_fireblast_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end






modifier_ogre_magi_fireblast_attack = class({})
function modifier_ogre_magi_fireblast_attack:IsHidden() return true end
function modifier_ogre_magi_fireblast_attack:IsPurgable() return false end
function modifier_ogre_magi_fireblast_attack:GetTexture() return "buffs/multi_attack" end

function modifier_ogre_magi_fireblast_attack:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self:GetCaster():GetTalentValue("modifier_ogremagi_blast_4", "max")
self.range = self:GetCaster():GetTalentValue("modifier_ogremagi_blast_4", "range")
self.damage = self:GetCaster():GetTalentValue("modifier_ogremagi_blast_4", "damage")/100
self.radius = self:GetCaster():GetTalentValue("modifier_ogremagi_blast_4", "radius")
self.stun = self:GetCaster():GetTalentValue("modifier_ogremagi_blast_4", "stun")

if not IsServer() then return end

self.RemoveForDuel = true 
self:SetStackCount(1)
end


function modifier_ogre_magi_fireblast_attack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() == self.max then 
	self.particle = ParticleManager:CreateParticle( "particles/ogre_magichit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( self.particle, 0, self.parent:GetAbsOrigin() )
	self:AddParticle(self.particle, false, false, -1, false, false) 

	self.parent:AddAttackEvent_out(self)
end

end

function modifier_ogre_magi_fireblast_attack:CheckState()
if self:GetStackCount() < self.max then return end
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_ogre_magi_fireblast_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end


function modifier_ogre_magi_fireblast_attack:GetModifierAttackRangeBonus()
if self:GetStackCount() < self.max then return end
return self.range
end



function modifier_ogre_magi_fireblast_attack:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local damage = self.damage*self.parent:GetStrength() --self.ability:GetDamage()

local particle = ParticleManager:CreateParticle("particles/ogre_hit.vpcf", PATTACH_WORLDORIGIN, nil)	
ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

params.target:EmitSound("Ogre.Spell_hit")

for _,unit in pairs(self.parent:FindTargets(self.radius, params.target:GetAbsOrigin())) do 

	local particle = ParticleManager:CreateParticle(self.ability:GetParticle(1), PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( particle, 1, unit:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	unit:EmitSound("Hero_OgreMagi.Fireblast.Target")

	unit:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = (1 - unit:GetStatusResistance())*self.stun})

	local real_damage = DoDamage({ victim = unit, attacker = self.parent, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability}, "modifier_ogremagi_blast_4" )
	unit:SendNumber(4, real_damage)
end

self:Destroy()
end

function modifier_ogre_magi_fireblast_attack:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if self:GetStackCount() == 0 then return end

if self:GetStackCount() == self.max then 

	self.parent:EmitSound("Ogre.Multi_proc")

	if self.effect_cast then 
		ParticleManager:DestroyParticle(self.effect_cast, true)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
	end

	self.effect_cast_2 = ParticleManager:CreateParticle( "particles/ogre_head.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )

	self:AddParticle(self.effect_cast_2,false, false, -1, false, false)

	return
end


if self:GetStackCount() == 1 then 

	local particle_cast = "particles/ogre_count.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 
  if self.effect_cast then 
  	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  end
end

end








modifier_ogre_magi_fireblast_damage = class({})
function modifier_ogre_magi_fireblast_damage:IsHidden() return false end
function modifier_ogre_magi_fireblast_damage:IsPurgable() return false end
function modifier_ogre_magi_fireblast_damage:GetTexture() return "buffs/fireblast_damage" end
function modifier_ogre_magi_fireblast_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_ogre_magi_fireblast_damage:GetModifierIncomingDamage_Percentage()
return self.damage*self:GetStackCount()
end

function modifier_ogre_magi_fireblast_damage:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.damage = self.caster:GetTalentValue("modifier_ogremagi_blast_7", "damage")
self.max = self.caster:GetTalentValue("modifier_ogremagi_blast_7", "max")
if not IsServer() then return end 


self.effect_cast = ParticleManager:CreateParticle( "particles/ogre_magi/fireblast_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
self.RemoveForDuel = true 
end


function modifier_ogre_magi_fireblast_damage:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self.parent:EmitSound("Hoodwink.Acorn_armor")
end

end


function modifier_ogre_magi_fireblast_damage:OnStackCountChanged(iStackCount)
if not self.effect_cast then return end	
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end