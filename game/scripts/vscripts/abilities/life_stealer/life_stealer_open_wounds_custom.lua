LinkLuaModifier( "modifier_life_stealer_open_wounds_custom_tracker", "abilities/life_stealer/life_stealer_open_wounds_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_open_wounds_custom", "abilities/life_stealer/life_stealer_open_wounds_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_open_wounds_custom_legendary", "abilities/life_stealer/life_stealer_open_wounds_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_open_wounds_custom_damage_bonus", "abilities/life_stealer/life_stealer_open_wounds_custom", LUA_MODIFIER_MOTION_NONE )


life_stealer_open_wounds_custom = class({})
life_stealer_open_wounds_custom.active_mod = nil

function life_stealer_open_wounds_custom:GetAbilityTextureName()
local caster = self:GetCaster()
if caster:HasModifier("modifier_lifestealer_immortal_arms_custom_golden") then
    return "life_stealer_open_wounds_ti9_gold"
end
if caster:HasModifier("modifier_lifestealer_immortal_arms_custom") then
    return "life_stealer_open_wounds_ti9"
end
if caster:HasModifier("modifier_ls_bloody_ripper_head_1") then
    return "life_stealer/bloody_ripper_abilityicons/life_stealer_open_wounds"
end
if caster:HasModifier("modifier_ls_bloody_ripper_head_2") then
    return "life_stealer/promo_bloody_ripper_abilityicons/life_stealer_open_wounds"
end
return "life_stealer_open_wounds"
end

function life_stealer_open_wounds_custom:CreateTalent()
self:ToggleAutoCast()
end

function life_stealer_open_wounds_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/wounds_legendary_aoe.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/wounds_legendary_aoe_init.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/wounds_chains.vpcf", context )
PrecacheResource( "particle", "particles/sand_king/sandking_caustic_finale_explode_custom.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/wounds_legendary_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf", context )
PrecacheResource( "particle", "particles/bloodseeker/bloodrage_stack_main.vpcf", context )
end

function life_stealer_open_wounds_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsCreepHero() then return end
return "modifier_life_stealer_open_wounds_custom_tracker"
end

function life_stealer_open_wounds_custom:GetBehavior()
local caster = self:GetCaster()
local bonus = caster:HasTalent("modifier_lifestealer_hero_6") and DOTA_ABILITY_BEHAVIOR_AUTOCAST or 0
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + bonus
end


function life_stealer_open_wounds_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_lifestealer_wounds_4") then
	bonus = self:GetCaster():GetTalentValue("modifier_lifestealer_wounds_4", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end


function life_stealer_open_wounds_custom:PullTarget(target, min_distance)
local caster = self:GetCaster()
local caster_loc = caster:GetAbsOrigin()
local pull_duration = caster:GetTalentValue("modifier_lifestealer_hero_6", "pull_duration", true)

local chain_effect = ParticleManager:CreateParticle( "particles/lifestealer/wounds_chains.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(chain_effect, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
ParticleManager:SetParticleControlEnt(chain_effect, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(chain_effect)

target:EmitSound("Lifestealer.Wounds_chains")

local dir = (caster_loc - target:GetAbsOrigin())
local point = caster_loc - dir:Normalized()*min_distance

local distance = (point - target:GetAbsOrigin()):Length2D()

if (dir:Length2D() < min_distance) then
	distance = 20
end

point = target:GetAbsOrigin() + dir:Normalized()*distance

local arc = target:AddNewModifier( caster,  self,  "modifier_generic_arc",  
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
end


function life_stealer_open_wounds_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
caster:EmitSound("Hero_LifeStealer.OpenWounds.Cast")

if target:TriggerSpellAbsorb(self) then return end

if caster:HasTalent("modifier_lifestealer_hero_6") and self:GetAutoCastState() then
	self:PullTarget(target, caster:GetTalentValue("modifier_lifestealer_hero_6", "min_distance"))
end

local duration = self:GetSpecialValueFor("duration")
target:AddNewModifier(caster, self, "modifier_life_stealer_open_wounds_custom", {duration = duration*(1 - target:GetStatusResistance())})
end


modifier_life_stealer_open_wounds_custom = class(mod_visible)
function modifier_life_stealer_open_wounds_custom:IsPurgable() return not self.caster:HasTalent("modifier_lifestealer_wounds_4") end
function modifier_life_stealer_open_wounds_custom:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.duration = self.ability:GetSpecialValueFor("duration")
self.slow = self.ability:GetSpecialValueFor("slow") + self.caster:GetTalentValue("modifier_lifestealer_wounds_2", "slow")
self.lifesteal = (self.ability:GetSpecialValueFor("heal_percent") + self.caster:GetTalentValue("modifier_lifestealer_wounds_2", "heal"))/100

self.death_damage = self.ability:GetSpecialValueFor("damage")
self.damage_radius = self.ability:GetSpecialValueFor("radius")

self.damage_reduce = self.caster:GetTalentValue("modifier_lifestealer_hero_2", "damage_reduce")
self.damage_duration = self.caster:GetTalentValue("modifier_lifestealer_hero_2", "duration")

self.max_slow = self.slow
self.min_slow = self.slow/5
self.max_ticks = 2
self.min_ticks = 5
self.ticks = 0
self.silence_proc = false

if not IsServer() then return end
self.ability.active_mod = self
self.ability:EndCd()
self.parent:AddDamageEvent_inc(self)
self.RemoveForDuel = true

if self.caster:HasTalent("modifier_lifestealer_hero_2") then
	self.parent:AddAttackRecordEvent_inc(self)
end

local pfx_name = "particles/units/heroes/hero_life_stealer/life_stealer_open_wounds.vpcf"
local sound_name = "Hero_LifeStealer.OpenWounds"
local impact_particle = nil
self.sound_name = sound_name

local vec = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Normalized()
vec.z = 0

if self.caster:HasModifier("modifier_lifestealer_immortal_arms_custom") then
  pfx_name = "particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds.vpcf"
  sound_name = "Hero_LifeStealer.OpenWounds.TI9"
	impact_particle = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti9_immortal/ls_ti9_open_wounds_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
elseif self.caster:HasModifier("modifier_lifestealer_immortal_arms_custom_golden") then
  pfx_name = "particles/econ/items/lifestealer/ls_ti9_immortal_gold/ls_ti9_open_wounds_gold.vpcf"
  sound_name = "Hero_LifeStealer.OpenWounds.TI9"
	impact_particle = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti9_immortal_gold/ls_ti9_open_wounds_gold_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
else
	self.parent:GenericParticle("particles/units/heroes/hero_life_stealer/life_stealer_open_wounds_impact.vpcf")
end

if impact_particle then
	ParticleManager:SetParticleControl(impact_particle, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControlForward(impact_particle, 1, vec)
	ParticleManager:ReleaseParticleIndex(impact_particle)
end

self.parent:EmitSound(sound_name)
self.parent:GenericParticle(pfx_name, self)

self.feast_bonus = self.caster:GetTalentValue("modifier_lifestealer_wounds_3", "feast")/100
self.feast = self.caster:FindModifierByName("modifier_life_stealer_innate_custom_tracker")

self.silence = self.caster:GetTalentValue("modifier_lifestealer_hero_6", "silence", true)
self.silence_attacks = self.caster:GetTalentValue("modifier_lifestealer_hero_6", "attacks", true)

self.burn_damage = self.caster:GetTalentValue("modifier_lifestealer_wounds_1", "damage")/100
self.creeps_damage = self.caster:GetTalentValue("modifier_lifestealer_wounds_1", "creeps")
self.damage_type = self.caster:GetTalentValue("modifier_lifestealer_wounds_1", "damage_type")

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = self.damage_type}
self:SetHasCustomTransmitterData(true)

self.interval = 0.98
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_life_stealer_open_wounds_custom:OnIntervalThink()
if not IsServer() then return end

if self.caster:HasTalent("modifier_lifestealer_wounds_1") then
	self.damageTable.damage = self.parent:IsCreep() and self.creeps_damage or self.burn_damage*self.parent:GetMaxHealth()
	DoDamage(self.damageTable, "modifier_lifestealer_wounds_1")
end

if self.caster:HasTalent("modifier_lifestealer_wounds_4") then return end
self.ticks = self.ticks + 1
if self.ticks > self.max_ticks then
	self.slow = self.max_slow - (self.min_slow * (self.ticks - self.max_ticks))
end
if self.ticks > self.min_ticks then
	self.slow = self.min_slow
end

self:SendBuffRefreshToClients()
end

function modifier_life_stealer_open_wounds_custom:AddCustomTransmitterData() 
return 
{
  slow = self.slow,
} 
end

function modifier_life_stealer_open_wounds_custom:HandleCustomTransmitterData(data)
self.slow = data.slow
end

function modifier_life_stealer_open_wounds_custom:OnDestroy()
if not IsServer() then return end
self.ability.active_mod = nil
self.ability:StartCd()

self.parent:StopSound(self.sound_name)

if self.parent:IsAlive() then return end

self.parent:EmitSound("Lifestealer.Wounds_death")
local effect_cast = ParticleManager:CreateParticle( "particles/sand_king/sandking_caustic_finale_explode_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( effect_cast )

local damageTable = {attacker = self.caster, damage = self.death_damage, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL}
for _,target in pairs(self.caster:FindTargets(self.damage_radius, self.parent:GetAbsOrigin())) do
	damageTable.victim = target
	DoDamage(damageTable)
end

end

function modifier_life_stealer_open_wounds_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
}
end

function modifier_life_stealer_open_wounds_custom:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_life_stealer_open_wounds_custom:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_life_stealer_open_wounds_custom:AttackRecordEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.target then return end
if not params.attacker:IsUnit() then return end
if params.attacker:GetTeamNumber() ~= self.caster:GetTeamNumber() then return end

params.attacker:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_open_wounds_custom_damage_bonus", {duration = self.damage_duration})
end


function modifier_life_stealer_open_wounds_custom:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
local attacker = params.attacker

if not attacker:IsUnit() then return end
if attacker:GetTeamNumber() ~= self.caster:GetTeamNumber() then return end
 
local caster_attacker = self.caster
local feast = self.feast
local mod = caster_attacker:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.target and mod.is_legendary == 1 then
	caster_attacker = mod.target
	feast = caster_attacker:FindModifierByName("modifier_life_stealer_innate_custom_tracker")
end

if params.inflictor == nil and caster_attacker and self.caster:HasTalent("modifier_lifestealer_hero_6") and self.silence_proc == false then
	self:IncrementStackCount()
	if self:GetStackCount() >= self.silence_attacks then
		self.silence_proc = true
		self:SetStackCount(0)
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_generic_silence", {duration = (1 - self.parent:GetStatusResistance())*self.silence, })
		self.parent:EmitSound("Sf.Raze_Silence")
		self.parent:GenericParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodritual_impact.vpcf")

		if self.effect_cast then
			ParticleManager:Delete(self.effect_cast, 1)
			self.effect_cast = nil
		end
	end
end

if self.caster:HasTalent("modifier_lifestealer_wounds_3") and feast then
	feast:ProcDamage(params, self.feast_bonus)
end

if not attacker:CheckLifesteal(params) then return end

local heal = params.damage*self.lifesteal
local quest_heal = (self.caster == attacker and caster_attacker ~= self.caster) and caster_attacker:GenericHeal(heal, self.ability, true) or attacker:GenericHeal(heal, self.ability, true)

if self.parent:IsRealHero() and self.caster:GetQuest() == "Lifestealer.Quest_6" and not self.caster:QuestCompleted() and (self.caster == attacker or (caster_attacker == attacker and caster_attacker ~= self.caster)) then
	self.caster:UpdateQuest(quest_heal)
end

end

function modifier_life_stealer_open_wounds_custom:GetStatusEffectName()
if self.caster:HasModifier("modifier_lifestealer_immortal_arms_custom") then
  return "particles/econ/items/lifestealer/ls_ti9_immortal/status_effect_ls_ti9_open_wounds.vpcf"
end
if self.caster:HasModifier("modifier_lifestealer_immortal_arms_custom_golden") then
  return "particles/econ/items/lifestealer/ls_ti9_immortal_gold/status_effect_ls_ti9_open_wounds_gold.vpcf"
end
return "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf"
end

function modifier_life_stealer_open_wounds_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH
end

function modifier_life_stealer_open_wounds_custom:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if self.caster:HasTalent("modifier_lifestealer_infest_3") then return end

if not self.effect_cast then 
	self.effect_cast = self.parent:GenericParticle("particles/bloodseeker/bloodrage_stack_main.vpcf", self, true)
end

local k1 = 0
local k2 = self:GetStackCount()

if k2 >= 10 then 
	k1 = 1
	k2 = self:GetStackCount() - 10
end
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( k1, k2, 0 ) )
end






life_stealer_open_wounds_custom_legendary = class({})

function life_stealer_open_wounds_custom_legendary:CreateTalent()
self:SetHidden(false)
self:SetLevel(1)
end

function life_stealer_open_wounds_custom_legendary:GetAbilityTextureName()
return "open_wounds_legendary"..(self:GetCaster():HasModifier("modifier_life_stealer_open_wounds_custom_legendary") and "_end" or "")
end

function life_stealer_open_wounds_custom_legendary:GetBehavior()
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + (self:GetCaster():HasModifier("modifier_life_stealer_open_wounds_custom_legendary") and DOTA_ABILITY_BEHAVIOR_IMMEDIATE or 0)
end

function life_stealer_open_wounds_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_lifestealer_wounds_7", "talent_cd")
end

function life_stealer_open_wounds_custom_legendary:GetCastRange(vector, hTarget)
local caster = self:GetCaster()
return caster:GetTalentValue("modifier_lifestealer_wounds_7", "radius") - caster:GetCastRangeBonus()
end

function life_stealer_open_wounds_custom_legendary:OnSpellStart()

local caster = self:GetCaster()

local mod = caster:FindModifierByName("modifier_life_stealer_open_wounds_custom_legendary")
if mod then
	mod:Destroy()
	return
end

local pull_duration = self:GetSpecialValueFor("pull_duration")
local radius = caster:GetTalentValue("modifier_lifestealer_wounds_7", "radius")
local ability = caster:FindAbilityByName("life_stealer_open_wounds_custom")

for _,target in pairs(caster:FindTargets(radius)) do
	ability:PullTarget(target, 100)
end

caster:AddNewModifier(caster, self, "modifier_life_stealer_open_wounds_custom_legendary", {duration = caster:GetTalentValue("modifier_lifestealer_wounds_7", "duration")})
self:EndCooldown()
self:StartCooldown(0.3)
end




modifier_life_stealer_open_wounds_custom_legendary = class(mod_hidden)
function modifier_life_stealer_open_wounds_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.radius = self.parent:GetTalentValue("modifier_lifestealer_wounds_7", "radius")
self.stun = self.ability:GetSpecialValueFor("stun")
self.damage = self.parent:GetTalentValue("modifier_lifestealer_wounds_7", "damage")/100
self.damage_type = self.parent:GetTalentValue("modifier_lifestealer_wounds_7", "damage_type")

if not IsServer() then return end

self.RemoveForDuel = true
self.parent:EmitSound("Lifestealer.Wounds_legendary_start")
self.parent:EmitSound("Lifestealer.Wounds_legendary_loop")

self.heal_target = self.parent
local mod = self.parent:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.target and mod.is_legendary == 1 then
	self.heal_target = mod.target
end
self.heal_target:AddHealEvent_inc(self, true)

self.particle = self:DrawParticle(self.parent)
self.end_target = self.parent

self.max_time = self:GetRemainingTime()

self.count = 0
self.ended = false
self.interval = 0.1
self:StartIntervalThink(self.interval)
end

function modifier_life_stealer_open_wounds_custom_legendary:DrawParticle(target)
if not IsServer() then return end

local particle = ParticleManager:CreateParticle("particles/lifestealer/wounds_legendary_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, self.radius, self.radius))
self:AddParticle(particle, false, false, -1, false, false)

return particle
end


function modifier_life_stealer_open_wounds_custom_legendary:OnIntervalThink()
if not IsServer() then return end

local mod = self.parent:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.target then
	self.end_target = mod.target
	if self.particle then
		ParticleManager:Delete(self.particle, 2)
		self.particle = nil
		self.infest_particle = self:DrawParticle(mod.target)
	end
else
	self.end_target = self.parent
	if self.infest_particle then
		ParticleManager:Delete(self.infest_particle, 2)
		self.infest_particle = nil
		self.particle = self:DrawParticle(self.parent)
	end
end


if self.ended then return end
self.parent:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = self.count, style = "LifestealerWounds"})
end



function modifier_life_stealer_open_wounds_custom_legendary:HealEvent_inc(params)
if not IsServer() then return end
if self.heal_target ~= params.unit then return end

self.count = self.count + params.gain*self.damage
end 


function modifier_life_stealer_open_wounds_custom_legendary:OnDestroy()
if not IsServer() then return end

self.ability:StartCd()

self.ended = true
self.parent:StopSound("Lifestealer.Wounds_legendary_loop")
self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "LifestealerWounds"})

if not self.parent:IsAlive() then return end
if self.count <= 0 then return end

local particle = ParticleManager:CreateParticle("particles/lifestealer/wounds_legendary_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.end_target)
ParticleManager:SetParticleControl(particle, 0, self.end_target:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 2, Vector(self.radius, self.radius, self.radius))
ParticleManager:ReleaseParticleIndex(particle)

self.parent:EmitSound("Lifestealer.Wounds_legendary_end")
self.parent:EmitSound("Lifestealer.Wounds_legendary_end2")

local damageTable = {attacker = self.parent, ability = self.ability, damage = self.count, damage_type = self.damage_type}

for _,target in pairs(self.parent:FindTargets(self.radius)) do

	damageTable.victim = target
	local real_damage = DoDamage(damageTable)
	target:SendNumber(6, real_damage)

	local effect_cast = ParticleManager:CreateParticle( "particles/sand_king/sandking_caustic_finale_explode_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	target:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = self.stun})
end

end

function modifier_life_stealer_open_wounds_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf"
end

function modifier_life_stealer_open_wounds_custom_legendary:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end



modifier_life_stealer_open_wounds_custom_tracker = class(mod_hidden)
function modifier_life_stealer_open_wounds_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.spell_damage = self.caster:GetTalentValue("modifier_lifestealer_wounds_3", "damage")

if not IsServer() then return end

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
self:StartIntervalThink(2)
end

function modifier_life_stealer_open_wounds_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if (not self.ability.active_mod or self.ability.active_mod:IsNull()) and not self.ability:IsActivated() then
	self.ability:StartCd()
end

end

function modifier_life_stealer_open_wounds_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_lifestealer_wounds_3" or self.caster:HasTalent("modifier_lifestealer_wounds_3") then
	self.spell_damage = self.caster:GetTalentValue("modifier_lifestealer_wounds_3", "damage")
end

self:SendBuffRefreshToClients()
end

function modifier_life_stealer_open_wounds_custom_tracker:AddCustomTransmitterData() 
return 
{
  spell_damage = self.spell_damage,
} 
end

function modifier_life_stealer_open_wounds_custom_tracker:HandleCustomTransmitterData(data)
self.spell_damage = data.spell_damage
end

function modifier_life_stealer_open_wounds_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_life_stealer_open_wounds_custom_tracker:GetModifierSpellAmplify_Percentage() 
return self.spell_damage
end




modifier_life_stealer_open_wounds_custom_damage_bonus = class(mod_hidden)
function modifier_life_stealer_open_wounds_custom_damage_bonus:OnCreated()
self.caster = self:GetCaster()
self.damage = self.caster:GetTalentValue("modifier_lifestealer_hero_2", "damage_bonus")
end

function modifier_life_stealer_open_wounds_custom_damage_bonus:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_life_stealer_open_wounds_custom_damage_bonus:GetModifierDamageOutgoing_Percentage()
return self.damage
end