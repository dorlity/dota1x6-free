LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_thinker_speed", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_speed", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_tracker", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_knock_cd", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_legendary", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_legendary_illusion", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_stun", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_linger", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_magnetic_field_custom_agi", "abilities/arc_warden/arc_warden_magnetic_field_custom", LUA_MODIFIER_MOTION_NONE )




arc_warden_magnetic_field_custom = class({})

function arc_warden_magnetic_field_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_magnetic_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/arc_warden_magnetic.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/arc_warden_magnetic_shard.vpcf", context )
PrecacheResource( "particle", "particles/duel_stun.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/arc_warden_magnetic_tempest.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/immunity_sphere.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/field_blink_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_faceless_chronosphere.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/field_attack.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_heall.vpcf", context )
PrecacheResource( "particle", "particles/puck_heal.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/field_attack_end.vpcf", context )
PrecacheResource( "particle", "particles/troll_hit.vpcf", context )

end

function arc_warden_magnetic_field_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_arc_warden_magnetic_field_custom_tracker"
end 

function arc_warden_magnetic_field_custom:GetBehavior()
local base = self:GetCaster():HasTalent("modifier_arc_warden_field_7") and DOTA_ABILITY_BEHAVIOR_NO_TARGET or (DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE)
return base + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function arc_warden_magnetic_field_custom:GetAOERadius()
return self:GetSpecialValueFor("radius")
end

function arc_warden_magnetic_field_custom:GetCastPoint(iLevel)
local bonus = self:GetCaster():HasTalent("modifier_arc_warden_hero_6") and self:GetCaster():GetTalentValue("modifier_arc_warden_hero_6", "cast") or 0
return self.BaseClass.GetCastPoint(self) + bonus
end

function arc_warden_magnetic_field_custom:GetCooldown(level)
local bonus = self:GetCaster():HasTalent("modifier_arc_warden_field_4") and self:GetCaster():GetTalentValue("modifier_arc_warden_field_4", "cd") or 0
return self.BaseClass.GetCooldown(self, level)  + bonus
end

function arc_warden_magnetic_field_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_arc_warden_frostivus_head") then
    return "arc_warden_magnetic_field_frostivus"
end
if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
	return "arc_warden_magnetic_field_tempest"
end
return "arc_warden_magnetic_field"
end

function arc_warden_magnetic_field_custom:OnSpellStart()
local caster = self:GetCaster()

caster:EmitSound("Hero_ArcWarden.MagneticField.Cast")
caster:GenericParticle("particles/units/heroes/hero_arc_warden/arc_warden_magnetic_cast.vpcf")

local duration = self:GetSpecialValueFor("duration")
local point = self:GetCursorTarget() and self:GetCursorTarget():GetAbsOrigin() or self:GetCursorPosition()
local radius = self:GetSpecialValueFor("radius")

if caster:HasTalent("modifier_arc_warden_field_7") then
	point = caster:GetAbsOrigin()
	radius = caster:GetTalentValue("modifier_arc_warden_field_7", "radius")
elseif caster:HasTalent("modifier_arc_warden_field_4") and not caster:IsRooted() and not caster:IsLeashed() then

	ProjectileManager:ProjectileDodge(caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arc.Field_blink_start", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Arc.Field_blink_start2", caster)

	local effect = ParticleManager:CreateParticle("particles/arc_warden/field_blink_start.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect, 0, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(effect)

	caster:SetOrigin(point)
	FindClearSpaceForUnit(caster, point, false)

	effect = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(effect, 0, point)
	ParticleManager:ReleaseParticleIndex(effect)

	caster:EmitSound("Arc.Field_blink_end")
	caster:EmitSound("Arc.Field_blink_end2")
end

if caster:HasTalent("modifier_arc_warden_field_7") then 
	caster:AddNewModifier(caster, self, "modifier_arc_warden_magnetic_field_custom_thinker_speed", { duration = duration, original = 1} )
else 
	CreateModifierThinker(caster, self, "modifier_arc_warden_magnetic_field_custom_thinker_speed", { duration = duration}, point, caster:GetTeamNumber(), false)
end 

end

function arc_warden_magnetic_field_custom:CheckActive()
local caster = self:GetCaster()
local legendary_ability = caster:FindAbilityByName("arc_warden_magnetic_field_custom_legendary")

if not caster:HasTalent("modifier_arc_warden_field_7") then
	self:StartCd()
elseif not self:IsActivated() and not caster:HasModifier("modifier_arc_warden_magnetic_field_custom_thinker_speed") and not caster:HasModifier("modifier_arc_warden_magnetic_field_custom_legendary") then
	if legendary_ability and not legendary_ability:IsHidden() then 
		caster:SwapAbilities(self:GetName(), legendary_ability:GetName(), true, false)
	end 
	self:StartCd()
end

end


modifier_arc_warden_magnetic_field_custom_thinker_speed = class(mod_hidden)
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.ability:EndCd()

self.parent_owner = self.parent:FindOwner()
self.priority = 0
self.event = "ArcField_Tempest"
if self.parent == self.parent_owner then
	self.priority = 1
	self.event = "ArcField"
end

self.has_legendary = self.caster:HasTalent("modifier_arc_warden_field_7")
self.has_knock = self.caster:HasTalent("modifier_arc_warden_hero_6")

self.legendary_ability = self.parent:FindAbilityByName("arc_warden_magnetic_field_custom_legendary")

self.knock_cd = self.caster:GetTalentValue("modifier_arc_warden_hero_6", "talent_cd", true)
self.knock_range = self.caster:GetTalentValue("modifier_arc_warden_hero_6", "range", true)
self.knock_stun = self.caster:GetTalentValue("modifier_arc_warden_hero_6", "stun", true)
self.knock_duration = 0.2

self.RemoveForDuel = true

if table.original and table.original == 1 and self.legendary_ability and self.legendary_ability:IsHidden() then 
	self.parent:SwapAbilities(self.ability:GetName(), self.legendary_ability:GetName(), false, true)
end 

self.duration = self.ability:GetSpecialValueFor("duration")
self.radius	= self.ability:GetSpecialValueFor("radius")
if self.parent:IsHero() then 
	self.radius = self.caster:GetTalentValue("modifier_arc_warden_field_7", "radius")
end 

self.parent:EmitSound("Hero_ArcWarden.MagneticField")

local part = self.has_knock and "particles/arc_warden/arc_warden_magnetic_shard.vpcf" or "particles/arc_warden/arc_warden_magnetic.vpcf"
if self.caster:HasModifier("modifier_arc_warden_frostivus_head") then
    part = "arc_warden/arc_warden_magnetic_ti9.vpcf"
end

self.magnetic_particle = ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.magnetic_particle, 1, Vector(self.radius, 1, 1))
self:AddParticle(self.magnetic_particle, false, false, 1, false, false)

if not self.has_knock and not self.has_legendary then return end

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_arc_warden_magnetic_field_custom_thinker_speed:OnIntervalThink()
if not IsServer() then return end 

if self.has_legendary and not self.parent:IsIllusion() then
	local time = self:GetRemainingTime()
	local active = (self.legendary_ability and self.legendary_ability:IsFullyCastable()) and 1 or 0
	self.parent_owner:UpdateUIshort({max_time = self.duration, time = time, stack = time, use_zero = 1, active = active, priority = self.priority, style = self.event})
end

if not self.has_knock then return end
if self.parent:HasModifier("modifier_arc_warden_magnetic_field_custom_legendary") then return end

for _,enemy in pairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())) do 
	if not enemy:HasModifier("modifier_arc_warden_magnetic_field_custom_knock_cd") and not enemy:IsDebuffImmune() then

		enemy:EmitSound("Arc.Field_shard")
	  	enemy:AddNewModifier(self.caster, self.ability, "modifier_arc_warden_magnetic_field_custom_knock_cd", {duration = self.knock_cd})

		local attack_particle = ParticleManager:CreateParticle("particles/duel_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControlEnt(attack_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(attack_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(attack_particle, 60, Vector(31,82,167))
		ParticleManager:SetParticleControl(attack_particle, 61, Vector(1,0,0))
		ParticleManager:ReleaseParticleIndex(attack_particle)

		local direction = enemy:GetOrigin()-self.parent:GetOrigin()
		direction.z = 0
		direction = direction:Normalized()
		if enemy:GetAbsOrigin() == self.parent:GetAbsOrigin() then 
			direction = enemy:GetForwardVector()
		end 

		local point = self.parent:GetAbsOrigin() + direction*(self.radius + self.knock_range)
		local distance = (enemy:GetAbsOrigin() - point):Length2D()

		local mod = enemy:AddNewModifier( caster, self,  "modifier_generic_arc",  
		{
		    target_x = point.x,
		    target_y = point.y,
		    distance = distance,
		    duration = self.knock_duration,
		    height = 0,
		    fix_end = false,
		    isStun = true,
		    activity = ACT_DOTA_FLAIL,
		})

		if mod then 
		 	enemy:GenericParticle("particles/items_fx/harpoon_pull.vpcf", mod)
			mod:SetEndCallback( function( interrupted )
				enemy:AddNewModifier(self.caster, self.ability, "modifier_arc_warden_magnetic_field_custom_stun", {duration = (1 - enemy:GetStatusResistance())*self.knock_stun})
			end)
		end 
	end
end 

end 


function modifier_arc_warden_magnetic_field_custom_thinker_speed:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Hero_ArcWarden.MagneticField")

if self.parent:IsIllusion() then return end
if self.parent:HasModifier("modifier_arc_warden_magnetic_field_custom_legendary") then return end

self.parent_owner:UpdateUIshort({hide = 1, hide_full = 1, priority = self.priority, style = self.event})

self.ability:CheckActive()
end


function modifier_arc_warden_magnetic_field_custom_thinker_speed:IsAura() return true end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAuraDuration() return 0.1 end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAuraRadius() return self.radius end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_arc_warden_magnetic_field_custom_thinker_speed:GetModifierAura()	return "modifier_arc_warden_magnetic_field_custom_speed" end



modifier_arc_warden_magnetic_field_custom_speed = class(mod_visible)
function modifier_arc_warden_magnetic_field_custom_speed:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_arc_warden_magnetic_field_custom_speed:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.aura_owner = self:GetAuraOwner()
self.caster = self:GetCaster()

self.radius	= self.ability:GetSpecialValueFor("radius")

if IsValid(self.aura_owner) and self.aura_owner:IsHero() then 
	self.radius = self.caster:GetTalentValue("modifier_arc_warden_field_7", "radius")
end 

self.heal_duration = self.parent:GetTalentValue("modifier_arc_warden_field_2", "duration", true)

self.status_resist = self.parent:GetTalentValue("modifier_arc_warden_field_4", "status")

self.evasion_chance	= self.ability:GetSpecialValueFor("evasion_chance")
self.attack_speed_bonus	= self.ability:GetSpecialValueFor("attack_speed_bonus") + self.parent:GetTalentValue("modifier_arc_warden_field_1", "speed")
self.attack_range_bonus	= self.ability:GetSpecialValueFor("shard_range")
end

function modifier_arc_warden_magnetic_field_custom_speed:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_EVASION_CONSTANT,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_arc_warden_magnetic_field_custom_speed:OnDestroy()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_arc_warden_field_2") and not self.parent:HasTalent("modifier_arc_warden_hero_2") then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_magnetic_field_custom_linger", {duration = self.heal_duration})
end

function modifier_arc_warden_magnetic_field_custom_speed:GetModifierAttackSpeedBonus_Constant()
if IsClient() then
	return self.attack_speed_bonus
end

if self.parent:FindAllModifiersByName(self:GetName())[1] ~= self then return end
return self.attack_speed_bonus
end

function modifier_arc_warden_magnetic_field_custom_speed:GetModifierStatusResistanceStacking()
return self.status_resist
end

function modifier_arc_warden_magnetic_field_custom_speed:GetModifierEvasion_Constant(params)
if not IsValid(self.aura_owner, params.attacker) then return end 
if (params.attacker:GetAbsOrigin() - self.aura_owner:GetAbsOrigin()):Length2D() <= self.radius then return end
return self.evasion_chance
end





modifier_arc_warden_magnetic_field_custom_tracker = class(mod_hidden)
function modifier_arc_warden_magnetic_field_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
}
end 

function modifier_arc_warden_magnetic_field_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.has_legendary = self.parent:HasTalent("modifier_arc_warden_field_7")
self.legendary_duration_inc = self.parent:GetTalentValue("modifier_arc_warden_field_7", "duration_inc", true)

self.has_cleave = self.parent:HasTalent("modifier_arc_warden_field_1")
self.cleave_damage = self.parent:GetTalentValue("modifier_arc_warden_field_1", "cleave")/100
self.crit_radius = self.parent:GetTalentValue("modifier_arc_warden_field_1", "radius", true)

self.lifesteal = self.parent:GetTalentValue("modifier_arc_warden_field_2", "heal")/100
self.lifesteal_creeps = self.parent:GetTalentValue("modifier_arc_warden_field_2", "creeps", true)

self.move_bonus = self.parent:GetTalentValue("modifier_arc_warden_hero_2", "move")
self.resist_bonus = self.parent:GetTalentValue("modifier_arc_warden_hero_2", "magic")
self.move_inc = self.parent:GetTalentValue("modifier_arc_warden_hero_2", "bonus", true)

self.agi_duration = self.parent:GetTalentValue("modifier_arc_warden_field_3", "duration", true)
self.agi_duration_creep = self.parent:GetTalentValue("modifier_arc_warden_field_3", "duration_creeps", true)
self.agi_damage = self.parent:GetTalentValue("modifier_arc_warden_field_3", "damage")/100
self.has_agi = self.parent:HasTalent("modifier_arc_warden_field_3")

self.records = {}

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)

self.aoe_table = {attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION}
self:UpdateTalent()
end 

function modifier_arc_warden_magnetic_field_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_arc_warden_field_7" or self.parent:HasTalent("modifier_arc_warden_field_7") then
	self.has_legendary = true
	self.parent:AddAttackEvent_out(self, true)
	self:StartIntervalThink(3)
end

if name == "modifier_arc_warden_field_3" or self.parent:HasTalent("modifier_arc_warden_field_3") then
	self.agi_damage = self.parent:GetTalentValue("modifier_arc_warden_field_3", "damage")/100
	self.has_agi = true
	self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_arc_warden_field_2" or self.parent:HasTalent("modifier_arc_warden_field_2") then
	self.lifesteal = self.parent:GetTalentValue("modifier_arc_warden_field_2", "heal")/100
	self.parent:AddDamageEvent_out(self, true)
end

if name == "modifier_arc_warden_field_1" or self.parent:HasTalent("modifier_arc_warden_field_1") then
	self.has_cleave = true
	self.cleave_damage = self.parent:GetTalentValue("modifier_arc_warden_field_1", "cleave")/100
	self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_arc_warden_hero_2" or self.parent:HasTalent("modifier_arc_warden_hero_2") then
	self.move_bonus = self.parent:GetTalentValue("modifier_arc_warden_hero_2", "move")
	self.resist_bonus = self.parent:GetTalentValue("modifier_arc_warden_hero_2", "magic")
end

self:SendBuffRefreshToClients()
end


function modifier_arc_warden_magnetic_field_custom_tracker:OnIntervalThink()
if not IsServer() then return end

self.ability:CheckActive()
end

function modifier_arc_warden_magnetic_field_custom_tracker:AddCustomTransmitterData() 
return 
{
  move_bonus = self.move_bonus,
  agi_damage = self.agi_damage,
  resist_bonus = self.resist_bonus,
} 
end

function modifier_arc_warden_magnetic_field_custom_tracker:HandleCustomTransmitterData(data)
self.move_bonus = data.move_bonus
self.agi_damage = data.agi_damage
self.resist_bonus = data.resist_bonus
end



function modifier_arc_warden_magnetic_field_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
local attacker = params.attacker
local target = params.target

if not params.target:IsUnit() then return end
if not attacker:IsRealHero() then return end
if attacker ~= self.parent then return end

if self.has_cleave and attacker:HasModifier("modifier_arc_warden_magnetic_field_custom_speed") then

	local particle = ParticleManager:CreateParticle("particles/troll_hit.vpcf", PATTACH_WORLDORIGIN, nil)	
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:Delete(particle, 1)
	
	self.aoe_table.damage = params.damage*self.cleave_damage
	for _,aoe_target in pairs(self.parent:FindTargets(self.crit_radius, target:GetAbsOrigin())) do
		if aoe_target ~= target then
			self.aoe_table.victim = aoe_target
			DoDamage(self.aoe_table, "modifier_arc_warden_field_1")
		end
	end
end

if self.has_agi and attacker:HasModifier("modifier_arc_warden_magnetic_field_custom_speed") then
	local duration = target:IsCreep() and self.agi_duration_creep or self.agi_duration
	attacker:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_magnetic_field_custom_agi", {duration = duration})

	local agi_target = attacker:GetTempest()
	if agi_target then
		agi_target:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_magnetic_field_custom_agi", {duration = duration})
	end
end

if not self.has_legendary then return end
local mod = attacker:FindModifierByName("modifier_arc_warden_magnetic_field_custom_thinker_speed")
if not mod then return end
mod:SetDuration(math.min(mod.duration, mod:GetRemainingTime() + self.legendary_duration_inc), true)
end

function modifier_arc_warden_magnetic_field_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
local attacker = params.attacker

if attacker:IsIllusion() and (not attacker.owner or attacker.owner ~= self.parent) then return end
if attacker:IsRealHero() and attacker ~= self.parent then return end

if not attacker:HasTalent("modifier_arc_warden_field_2") then return end
if not attacker:HasModifier("modifier_arc_warden_magnetic_field_custom_speed") and not attacker:HasModifier("modifier_arc_warden_magnetic_field_custom_linger") then return end
if not attacker:CheckLifesteal(params) then return end 

local heal = params.damage*self.lifesteal
heal = params.unit:IsCreep() and heal/self.lifesteal_creeps or heal

attacker:GenericHeal(heal, self.ability, false, nil, "modifier_arc_warden_field_2")
end


function modifier_arc_warden_magnetic_field_custom_tracker:GetModifierMoveSpeedBonus_Percentage()
if self.parent:IsNull() then return end
return (self.parent:HasModifier("modifier_arc_warden_magnetic_field_custom_speed") or self.parent:HasModifier("modifier_arc_warden_magnetic_field_custom_linger")) and self.move_bonus*self.move_inc or self.move_bonus
end

function modifier_arc_warden_magnetic_field_custom_tracker:GetModifierMagicalResistanceBonus()
if self.parent:IsNull() then return end
return (self.parent:HasModifier("modifier_arc_warden_magnetic_field_custom_speed") or self.parent:HasModifier("modifier_arc_warden_magnetic_field_custom_linger")) and self.resist_bonus*self.move_inc or self.resist_bonus
end

function modifier_arc_warden_magnetic_field_custom_tracker:GetModifierBaseAttack_BonusDamage()
if self.parent:IsNull() then return end
return self.parent:GetAgility()*self.agi_damage
end





arc_warden_magnetic_field_custom_legendary = class({})

function arc_warden_magnetic_field_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_arc_warden_field_7", "talent_cd")
end 

function arc_warden_magnetic_field_custom_legendary:GetBehavior()
local base = self:GetCaster():HasTalent("modifier_arc_warden_field_4") and DOTA_ABILITY_BEHAVIOR_POINT or DOTA_ABILITY_BEHAVIOR_NO_TARGET 
return base + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end

function arc_warden_magnetic_field_custom_legendary:GetCastRange(vLocation, hTarget)
local caster = self:GetCaster()
if not caster:HasTalent("modifier_arc_warden_field_4") then return end
return IsClient() and caster:GetTalentValue("modifier_arc_warden_field_4", "range") or 99999
end

function arc_warden_magnetic_field_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local duration = caster:GetTalentValue("modifier_arc_warden_field_7", "invun")

local point = caster:GetAbsOrigin()
if caster:HasTalent("modifier_arc_warden_field_4") then
	local dir = self:GetCursorPosition() - point
	local max_range = caster:GetTalentValue("modifier_arc_warden_field_4", "range") + caster:GetCastRangeBonus()
	local range = math.min(max_range, dir:Length2D())
	point = point + dir:Normalized()*range
end

caster:AddNewModifier(caster, self, "modifier_arc_warden_magnetic_field_custom_legendary", {x = point.x, y = point.y, duration = duration})
end 



modifier_arc_warden_magnetic_field_custom_legendary = class(mod_hidden)
function modifier_arc_warden_magnetic_field_custom_legendary:OnCreated(table)
if not IsServer() then return end 
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.main_ability = self.parent:FindAbilityByName("arc_warden_magnetic_field_custom")

self.radius = self.parent:GetTalentValue("modifier_arc_warden_field_7", "radius")

ProjectileManager:ProjectileDodge(self.parent)

self.point = GetGroundPosition((Vector(table.x, table.y, 0)), nil)

self.old_pos = self.parent:GetAbsOrigin()
self.old_pos.z = self.old_pos.z + 150

local effect = ParticleManager:CreateParticle("particles/arc_warden/field_blink_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(effect)

local qangle_rotation_rate = 120
local line_position = self.parent:GetAbsOrigin() + self.parent:GetForwardVector() * self.parent:GetTalentValue("modifier_arc_warden_field_7", "radius")
for i = 1, 3 do
	local qangle = QAngle(0, qangle_rotation_rate, 0)
	line_position = RotatePosition(self.parent:GetAbsOrigin() , qangle, line_position)

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(cast_particle, 0, self.old_pos )
	ParticleManager:SetParticleControl(cast_particle, 1, line_position)
	ParticleManager:SetParticleControl(cast_particle, 2, self.old_pos )
	ParticleManager:ReleaseParticleIndex(cast_particle)
end


local speed_mod = self.parent:FindModifierByName("modifier_arc_warden_magnetic_field_custom_thinker_speed")
if speed_mod then
	self.mod_duration = speed_mod:GetRemainingTime()
	speed_mod:OnIntervalThink()
	speed_mod:Destroy()
end

self.parent:EmitSound("Arc.Field_blink_start")
self.parent:EmitSound("Arc.Field_blink_start2")

self.parent:NoDraw(self)
self.parent:AddNoDraw()
if not self.parent:HasTalent("modifier_arc_warden_field_4") then return end
self:StartIntervalThink(0.2)
end 

function modifier_arc_warden_magnetic_field_custom_legendary:OnIntervalThink()
if not IsServer() then return end
FindClearSpaceForUnit(self.parent, self.point, true)
self:StartIntervalThink(-1)
end

function modifier_arc_warden_magnetic_field_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_DISARMED] = true
}
end 

function modifier_arc_warden_magnetic_field_custom_legendary:OnDestroy()
if not IsServer() then return end 

self.parent:RemoveNoDraw()
self.point.z = self.point.z + 150

self:PlayEffect(self.parent)

if not self.parent:IsAlive() then return end
local illusions = CreateIllusions( self.parent, self.parent, 
{
	duration = self.parent:GetTalentValue("modifier_arc_warden_field_7", "duration"),
	outgoing_damage= -100 + self.parent:GetTalentValue("modifier_arc_warden_field_7", "damage"),
	incoming_damage = self.parent:GetTalentValue("modifier_arc_warden_field_7", "incoming") -100
}, 1, self.radius/2 + 60, not self.parent:HasTalent("modifier_arc_warden_field_4"), true)  

for k, illusion in pairs(illusions) do
	for _,mod in pairs(self.parent:FindAllModifiers()) do
	  if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
	      illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
	  end
	end

  	illusion:AddNewModifier(illusion, self:GetAbility(), "modifier_arc_warden_magnetic_field_custom_legendary_illusion", {})
	self:PlayEffect(illusion)

	illusion.owner = self.parent	
	illusion:SetOwner(nil)

	local enemies = FindUnitsInRadius(illusion:GetTeamNumber(), illusion:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
	local creeps = FindUnitsInRadius(illusion:GetTeamNumber(), illusion:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

	if #enemies > 0 then 
		illusion:SetForceAttackTarget(enemies[1])
	else 
		if #creeps > 0 then 
			illusion:SetForceAttackTarget(creeps[1])
		end 
	end  

	Timers:CreateTimer(0.5, function()
		if IsValid(illusion) then 
			illusion:SetForceAttackTarget(nil)
		end 
	end)
end

end 

function modifier_arc_warden_magnetic_field_custom_legendary:PlayEffect(unit)
if not IsServer() then return end

unit:EmitSound("Arc.Field_blink_end")
unit:EmitSound("Arc.Field_blink_end2")

if self.mod_duration then
	unit:AddNewModifier(self.parent, self.main_ability, "modifier_arc_warden_magnetic_field_custom_thinker_speed", {duration = self.mod_duration, original = 0})
end

unit:MoveToPositionAggressive(unit:GetAbsOrigin())

local point = unit:GetAbsOrigin()
point.z = point.z + 150

local qangle_rotation_rate = 120
local line_position = unit:GetAbsOrigin() + unit:GetForwardVector() * self.radius
for i = 1, 3 do
	local qangle = QAngle(0, qangle_rotation_rate, 0)
	line_position = RotatePosition(unit:GetAbsOrigin() , qangle, line_position)

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(cast_particle, 0, line_position )
	ParticleManager:SetParticleControl(cast_particle, 1, point)
	ParticleManager:SetParticleControl(cast_particle, 2, line_position )
	ParticleManager:ReleaseParticleIndex(cast_particle)
end

local effect = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_arcana/earthshaker_arcana_blink_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, unit:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(effect)

if unit:IsIllusion() then 
	local illusion = unit
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion)
	ParticleManager:SetParticleControlEnt(cast_particle, 0, illusion, PATTACH_POINT_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 2, illusion, PATTACH_POINT_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)

	cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(cast_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 1, illusion, PATTACH_POINT_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(cast_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)
end 

end 


modifier_arc_warden_magnetic_field_custom_legendary_illusion = class(mod_hidden)
function modifier_arc_warden_magnetic_field_custom_legendary_illusion:CheckState()
return
{
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
}
end 



modifier_arc_warden_magnetic_field_custom_knock_cd = class(mod_hidden)
function modifier_arc_warden_magnetic_field_custom_knock_cd:RemoveOnDeath() return false end
function modifier_arc_warden_magnetic_field_custom_knock_cd:OnCreated()
self.RemoveForDuel = true
end 

modifier_arc_warden_magnetic_field_custom_stun = class(mod_hidden)
function modifier_arc_warden_magnetic_field_custom_stun:IsStunDebuff() return true end
function modifier_arc_warden_magnetic_field_custom_stun:IsPurgeException() return true end
function modifier_arc_warden_magnetic_field_custom_stun:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_arc_warden_magnetic_field_custom_stun:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_arc_warden_magnetic_field_custom_stun:CheckState()
return
{
	[MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_STUNNED] = true
}
end




modifier_arc_warden_magnetic_field_custom_linger = class(mod_hidden)


modifier_arc_warden_magnetic_field_custom_agi = class(mod_visible)
function modifier_arc_warden_magnetic_field_custom_agi:GetTexture() return "buffs/arc_warden/field_3" end
function modifier_arc_warden_magnetic_field_custom_agi:OnCreated()
self.parent = self:GetParent()
self.agi = self.parent:GetTalentValue("modifier_arc_warden_field_3", "agi")
self.max = self.parent:GetTalentValue("modifier_arc_warden_field_3", "max")

if not IsServer() then return end
self.StackOnIllusion = true
self:SetStackCount(1)
self.parent:CalculateStatBonus(true)
end

function modifier_arc_warden_magnetic_field_custom_agi:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end

function modifier_arc_warden_magnetic_field_custom_agi:OnDestroy()
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_arc_warden_magnetic_field_custom_agi:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end

function modifier_arc_warden_magnetic_field_custom_agi:GetModifierBonusStats_Agility()
return self.agi*self:GetStackCount()
end