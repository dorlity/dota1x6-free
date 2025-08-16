LinkLuaModifier( "modifier_arc_warden_flux_custom", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_legendary", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_legendary_cd", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_legendary_tempest_cd", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_count", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_resist", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_tracker", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_haste", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_flux_custom_heal", "abilities/arc_warden/arc_warden_flux_custom", LUA_MODIFIER_MOTION_NONE )


arc_warden_flux_custom = class({})

arc_warden_flux_custom.active_mod = nil

function arc_warden_flux_custom:CreateTalent()
self:ToggleAutoCast()
end


function arc_warden_flux_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_flux_tempest_tgt.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/flux_self.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/flux_self_tempest.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/force_staff.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/harpoon_pull.vpcf", context )
PrecacheResource( "particle", "particles/zuus_speed.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_silenced.vpcf", context )
PrecacheResource( "particle", "particles/ta_trap_damage.vpcf", context )
end

function arc_warden_flux_custom:GetIntrinsicModifierName()
return "modifier_arc_warden_flux_custom_tracker"
end 

function arc_warden_flux_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_arc_warden_flux_2") then 
	bonus = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_2", "cd")
end 
return self.BaseClass.GetCooldown(self, level)  + bonus
end

function arc_warden_flux_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_arc_warden_flux_4") then 
	bonus = self:GetCaster():GetTalentValue("modifier_arc_warden_flux_4", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end

function arc_warden_flux_custom:GetBehavior()
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + (self:GetCaster():HasTalent("modifier_arc_warden_hero_5") and DOTA_ABILITY_BEHAVIOR_AUTOCAST or 0)
end


function arc_warden_flux_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
	return "arc_warden_flux_tempest"
end
return "arc_warden_flux"
end

function arc_warden_flux_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end 
local duration = self:GetSpecialValueFor("duration")
local caster_mod = nil
local target_mod = nil

caster:MoveToTargetToAttack(target)
caster:EmitSound("Hero_ArcWarden.Flux.Cast")
target:EmitSound("Hero_ArcWarden.Flux.Target")

local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(cast_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(cast_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(cast_particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(cast_particle)

if caster:HasTalent("modifier_arc_warden_flux_7") then 
	local qangle_rotation_rate = 60
	local line_position = caster:GetAbsOrigin() + caster:GetForwardVector() * 350
	for i = 1, 6 do

		local qangle = QAngle(0, qangle_rotation_rate, 0)
		line_position = RotatePosition(caster:GetAbsOrigin() , qangle, line_position)

		local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(cast_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(cast_particle, 1, line_position)
		ParticleManager:SetParticleControlEnt(cast_particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(cast_particle)
	end
	caster_mod = caster:AddNewModifier(caster, self, "modifier_arc_warden_flux_custom_legendary", {duration = duration})
end

if caster:HasTalent("modifier_arc_warden_hero_5") then
	local max_dist = caster:GetTalentValue("modifier_arc_warden_hero_5", "range")
	local pull_duration = caster:GetTalentValue("modifier_arc_warden_hero_5", "pull_duration")
	local speed = max_dist/pull_duration

	local target_loc = target:GetAbsOrigin()
	local caster_loc = caster:GetAbsOrigin()

	local dir = (caster_loc - target_loc):Normalized()
	local point = target_loc + dir*100
	local distance = (point - caster_loc):Length2D()

	distance = math.min(max_dist, math.max(50, distance))
	point = caster_loc + dir*distance
	local pull_target = target

	if self:GetAutoCastState() then
		local max_range = 700
		local dist = (caster_loc - target_loc):Length2D()
		distance = math.max(50, (1 - dist/max_range)*max_dist)
		point = target_loc - dir*distance
		pull_duration = distance/speed
	end

	caster:AddNewModifier(caster, self, "modifier_arc_warden_flux_custom_haste", {duration = caster:GetTalentValue("modifier_arc_warden_hero_5", "duration")})
	local mod = pull_target:AddNewModifier( caster, self,  "modifier_generic_arc",  
	{
	    target_x = point.x,
	    target_y = point.y,
	    distance = distance,
	    duration = pull_duration,
	    height = 0,
	    fix_end = false,
	    isStun = false,
	    activity = ACT_DOTA_FLAIL,
	})

	if mod then 
	  pull_target:GenericParticle("particles/items_fx/harpoon_pull.vpcf", mod)
	end 
end

if caster:HasTalent("modifier_arc_warden_flux_4") then
	target:EmitSound("Sf.Raze_silence")
	target:AddNewModifier(caster, self, "modifier_generic_silence", {duration = (1 - target:GetStatusResistance())*caster:GetTalentValue("modifier_arc_warden_flux_4", "silence")})
end

target_mod = target:AddNewModifier(caster, self, "modifier_arc_warden_flux_custom", {duration = duration, is_legendary = 0})

self.active_mod = caster_mod and caster_mod or target_mod
self:EndCd()
end


modifier_arc_warden_flux_custom = class({})
function modifier_arc_warden_flux_custom:IsHidden() return true end 
function modifier_arc_warden_flux_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_arc_warden_flux_custom:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.think_interval	= self.ability:GetSpecialValueFor("think_interval")
self.search_radius = self.ability:GetSpecialValueFor("search_radius")
self.move_speed_slow_pct	= self.ability:GetSpecialValueFor("move_speed_slow_pct") + self.caster:GetTalentValue("modifier_arc_warden_flux_4", "slow")
self.damage_per_interval	= (self.ability:GetSpecialValueFor("damage_per_second") + self.caster:GetMaxHealth()*self.caster:GetTalentValue("modifier_arc_warden_flux_1", "damage")/100)
self.damage_per_interval = self.damage_per_interval * self.think_interval

local duration = self.ability:GetSpecialValueFor("duration")

if IsServer() then
	self:SetStackCount(self.move_speed_slow_pct*(1 - self.parent:GetStatusResistance()))
end

self.move_speed_slow_pct = self:GetStackCount()

if not IsServer() then return end

self.has_legendary = self.caster:HasTalent("modifier_arc_warden_flux_7")
self.damage_ability = table.is_legendary == 1 and "modifier_arc_warden_flux_7" or nil

self.damageTable = {victim = self.parent, damage = self.damage_per_interval, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self.caster, ability	= self.ability}
self.parent:AddNewModifier(self.caster, self.ability, "modifier_arc_warden_flux_custom_count", {duration = duration})

self.flux_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.flux_particle, 2, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
self:AddParticle(self.flux_particle, false, false, -1, false, false)

self.count = 0
self.max = duration/self.think_interval + 1

self:StartIntervalThink(FrameTime())
end

function modifier_arc_warden_flux_custom:OnIntervalThink()
if not IsServer() then return end 
self:SetStackCount(0)

local no_near = true 

if not self.has_legendary then
	local units = self.caster:FindTargets(self.search_radius, self.parent:GetAbsOrigin())
	for _,unit in pairs(units) do 
		if unit ~= self.parent then 
			no_near = false
			break
		end 
	end 
end

if no_near == true then
	ParticleManager:SetParticleControl(self.flux_particle, 4, Vector(1, 0, 0))
	DoDamage(self.damageTable, self.damage_ability)
else
	ParticleManager:SetParticleControl(self.flux_particle, 4, Vector(0, 0, 0))
end

self.count = self.count + 1 

if self.count >= self.max then
	self:Destroy()
	return 
end

self:StartIntervalThink(self.think_interval)
end

function modifier_arc_warden_flux_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_arc_warden_flux_custom:GetModifierMoveSpeedBonus_Percentage()
return self.move_speed_slow_pct
end

function modifier_arc_warden_flux_custom:OnDestroy()
if not IsServer() then return end 

if not self.caster:HasTalent("modifier_arc_warden_flux_7") then
	self.ability.active_mod = nil
	self.ability:StartCd()
end

local mod = self.parent:FindModifierByName("modifier_arc_warden_flux_custom_count")

if not mod then return end 
mod:DecrementStackCount() 

if mod:GetStackCount() <= 0 then 
	mod:Destroy()
end

end 

modifier_arc_warden_flux_custom_count = class(mod_visible)
function modifier_arc_warden_flux_custom_count:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.has_talent = self.caster:HasTalent("modifier_arc_warden_flux_3")
self.resist_duration = self.caster:GetTalentValue("modifier_arc_warden_flux_3", "duration")

self.has_heal_talent = self.caster:HasTalent("modifier_arc_warden_flux_2")

if not IsServer() then return end 
self:SetStackCount(1)
self.think_interval = 0.5

self.count = 0
self:StartIntervalThink(self.think_interval)
end 

function modifier_arc_warden_flux_custom_count:OnRefresh(table)
if not IsServer() then return end 
self:IncrementStackCount()
end 

function modifier_arc_warden_flux_custom_count:OnIntervalThink()
if not IsServer() then return end 

local hero = self.caster
if hero:IsTempestDouble() and hero.owner then 
	hero = hero.owner
end

if hero:GetQuest() == "Arc.Quest_5" and self.parent:IsRealHero() and not hero:QuestCompleted() then 
	hero:UpdateQuest(self.think_interval)
end

if self.has_heal_talent then
	self.caster:AddNewModifier(self.caster, self.ability, "modifier_arc_warden_flux_custom_heal", {duration = self.think_interval + 0.1})
	local heal_target = self.caster:GetTempest()
	if heal_target then
		heal_target:AddNewModifier(self.caster, self.ability, "modifier_arc_warden_flux_custom_heal", {duration = self.think_interval + 0.1})
	end
end

if self.has_talent then 
	self.count = self.count + self.think_interval

	if self.count >= (1 - FrameTime()*2) then
		self.count = 0
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_arc_warden_flux_custom_resist", {duration = self.resist_duration})
	end
end 

end





modifier_arc_warden_flux_custom_legendary = class(mod_visible)
function modifier_arc_warden_flux_custom_legendary:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.cd = self.parent:GetTalentValue("modifier_arc_warden_flux_7", "interval") - 0.1
self.duration = self.ability:GetSpecialValueFor("duration")

if not IsServer() then return end
self.part = "particles/units/heroes/hero_arc_warden/arc_warden_flux_tgt.vpcf"
self.part_2 = "particles/arc_warden/flux_self.vpcf"
self.cd_mod = "modifier_arc_warden_flux_custom_legendary_cd"

if self.parent:HasModifier("modifier_arc_warden_tempest_double") then
	self.part = "particles/units/heroes/hero_arc_warden/arc_warden_flux_tempest_tgt.vpcf"
	self.part_2 = "particles/arc_warden/flux_self_tempest.vpcf"
	self.cd_mod = "modifier_arc_warden_flux_custom_legendary_tempest_cd"
end

self.radius = self.parent:GetTalentValue("modifier_arc_warden_flux_7", "radius")

self.flux_particle = ParticleManager:CreateParticle(self.part, PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.flux_particle, 2, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(self.flux_particle, 4, Vector(1, 0, 0))
self:AddParticle(self.flux_particle, false, false, -1, false, false)

local effect_cast = ParticleManager:CreateParticle( self.part_2, PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius*0.9, 1, 1 ) )
self:AddParticle( effect_cast, false, false, -1, false, false )

self.interval = 0.05

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 


function modifier_arc_warden_flux_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

for _,unit in pairs(self.parent:FindTargets(self.radius)) do 
	if not unit:HasModifier(self.cd_mod) then 
		unit:AddNewModifier(self.parent, self.ability, self.cd_mod, {duration = self.cd})

		self.parent:EmitSound("Hero_ArcWarden.Flux.Cast")
		unit:EmitSound("Hero_ArcWarden.Flux.Target")

		local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(cast_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(cast_particle)

		unit:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_flux_custom", {duration = self.duration, is_legendary = 1})
	end 
end 

end

function modifier_arc_warden_flux_custom_legendary:OnDestroy()
if not IsServer() then return end
self.ability.active_mod = nil
self.ability:StartCd()
end


modifier_arc_warden_flux_custom_legendary_cd = class({})
function modifier_arc_warden_flux_custom_legendary_cd:IsHidden() return true end
function modifier_arc_warden_flux_custom_legendary_cd:IsPurgable() return false end


modifier_arc_warden_flux_custom_legendary_tempest_cd = class({})
function modifier_arc_warden_flux_custom_legendary_tempest_cd:IsHidden() return true end
function modifier_arc_warden_flux_custom_legendary_tempest_cd:IsPurgable() return false end






modifier_arc_warden_flux_custom_tracker = class(mod_hidden)
function modifier_arc_warden_flux_custom_tracker:IsHidden() return true end
function modifier_arc_warden_flux_custom_tracker:IsPurgable() return false end


function modifier_arc_warden_flux_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.attack_range = self.parent:GetTalentValue("modifier_arc_warden_hero_1", "attack_range")
self.cast_range = self.parent:GetTalentValue("modifier_arc_warden_hero_1", "cast_range")

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()

if not self:GetCaster():IsRealHero() then return end
self:StartIntervalThink(2)
end 

function modifier_arc_warden_flux_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_arc_warden_hero_1" or self.parent:HasTalent("modifier_arc_warden_hero_1") then
	self.attack_range = self.parent:GetTalentValue("modifier_arc_warden_hero_1", "attack_range")
	self.cast_range = self.parent:GetTalentValue("modifier_arc_warden_hero_1", "cast_range")
end

self:SendBuffRefreshToClients()
end

function modifier_arc_warden_flux_custom_tracker:AddCustomTransmitterData() 
return 
{
  attack_range = self.attack_range,
  cast_range = self.cast_range,
} 
end

function modifier_arc_warden_flux_custom_tracker:HandleCustomTransmitterData(data)
self.attack_range = data.attack_range
self.cast_range = data.cast_range
end


function modifier_arc_warden_flux_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not self.ability:IsActivated() and not IsValid(self.ability.active_mod) then
	self.ability:StartCd()
end

end


function modifier_arc_warden_flux_custom_tracker:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING
}
end

function modifier_arc_warden_flux_custom_tracker:GetModifierCastRangeBonusStacking()
return self.cast_range
end

function modifier_arc_warden_flux_custom_tracker:GetModifierAttackRangeBonus()
return self.attack_range
end









modifier_arc_warden_flux_custom_resist = class(mod_visible)
function modifier_arc_warden_flux_custom_resist:GetTexture() return "buffs/arc_warden/flux_3" end
function modifier_arc_warden_flux_custom_resist:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_arc_warden_flux_3", "max")
self.resist = self.caster:GetTalentValue("modifier_arc_warden_flux_3", "resist")/self.max
self.damage_reduce = self.caster:GetTalentValue("modifier_arc_warden_flux_3", "damage_reduce")/self.max

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_arc_warden_flux_custom_resist:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
  self.parent:GenericParticle("particles/enigma/summon_spell_damage.vpcf", self, true)
  self.parent:EmitSound("Arc.Flux_resist_max")
end 

end 

function modifier_arc_warden_flux_custom_resist:DeclareFunctions()
return 
{ 
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_arc_warden_flux_custom_resist:GetModifierMagicalResistanceBonus()
return self.resist*self:GetStackCount()
end 

function modifier_arc_warden_flux_custom_resist:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce*self:GetStackCount()
end

function modifier_arc_warden_flux_custom_resist:GetModifierSpellAmplify_Percentage()
return self.damage_reduce*self:GetStackCount()
end


modifier_arc_warden_flux_custom_heal = class(mod_hidden)
function modifier_arc_warden_flux_custom_heal:OnCreated()
self.parent = self:GetParent()
self.heal = self.parent:GetTalentValue("modifier_arc_warden_flux_2", "heal")
end

function modifier_arc_warden_flux_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_arc_warden_flux_custom_heal:GetModifierHealthRegenPercentage()
return self.heal
end



modifier_arc_warden_flux_custom_haste = class(mod_visible)
function modifier_arc_warden_flux_custom_haste:GetTexture() return "buffs/arc_warden/hero_5" end
function modifier_arc_warden_flux_custom_haste:GetEffectName() return "particles/econ/events/fall_2021/phase_boots_fall_2021_lvl2.vpcf" end
function modifier_arc_warden_flux_custom_haste:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end 


function modifier_arc_warden_flux_custom_haste:OnCreated()
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_arc_warden_hero_5", "speed")

if not IsServer() then return end
self.parent:GenericParticle("particles/zuus_speed.vpcf", self)
self.parent:EmitSound("Arc.Spark_haste")
end 

function modifier_arc_warden_flux_custom_haste:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end 

function modifier_arc_warden_flux_custom_haste:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end



