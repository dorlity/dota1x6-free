LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_tracker", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_legendary_poison", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_active", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_double", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_double_damage", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_double_chance", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_speed_bonus", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_vision", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_vision_speed", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_stun_cd", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_shield", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ghoul_frenzy_custom_slow", "abilities/life_stealer/life_stealer_ghoul_frenzy_custom", LUA_MODIFIER_MOTION_NONE )



life_stealer_ghoul_frenzy_custom = class({})


function life_stealer_ghoul_frenzy_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsCreepHero() then return end
return "modifier_life_stealer_ghoul_frenzy_custom_tracker"
end


function life_stealer_ghoul_frenzy_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
	
PrecacheResource( "particle", "particles/lifestealer/frenzy_legendary_attack_2.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/frenzy_legendary_attack.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7_explosion.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_debuff_ti7.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/ghoul_legendary_head.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/ghoul_legendary_active.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/double_attack.vpcf", context )
PrecacheResource( "particle", "particles/bloodseeker/thirst_cleave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/heal_shield.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/heal_shield_creeps.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/double_attack_creep.vpcf", context )
end


function life_stealer_ghoul_frenzy_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_lifestealer_ghoul_7") then
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function life_stealer_ghoul_frenzy_custom:GetCooldown(level)
if not self:GetCaster():HasTalent("modifier_lifestealer_ghoul_7") then return end
return self:GetCaster():GetTalentValue("modifier_lifestealer_ghoul_7", "talent_cd")
end


function life_stealer_ghoul_frenzy_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = caster:GetTalentValue("modifier_lifestealer_ghoul_7", "duration", true)
local target = caster

local mod = caster:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.target and mod.is_legendary == 1 then
	target = mod.target
end

caster:StartGesture(ACT_DOTA_LIFESTEALER_RAGE)
target:AddNewModifier(caster, self, "modifier_life_stealer_ghoul_frenzy_custom_active", {duration = duration})
end



modifier_life_stealer_ghoul_frenzy_custom_tracker = class(mod_hidden)
function modifier_life_stealer_ghoul_frenzy_custom_tracker:IsHidden() return (self.parent and not self.parent:IsNull() and self.parent:IsHero()) end
function modifier_life_stealer_ghoul_frenzy_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.move_speed = self.ability:GetSpecialValueFor("movement_speed_bonus")
self.attack_speed = self.ability:GetSpecialValueFor("attack_speed_bonus")

self.move_bonus = self.caster:GetTalentValue("modifier_lifestealer_hero_3", "move")
self.status_bonus = self.caster:GetTalentValue("modifier_lifestealer_hero_3", "status")

self.range_bonus = self.caster:GetTalentValue("modifier_lifestealer_ghoul_2", "range")
self.cleave_bonus = self.caster:GetTalentValue("modifier_lifestealer_ghoul_2", "cleave")/100

self.speed_bonus = self.caster:GetTalentValue("modifier_lifestealer_ghoul_1", "speed")
self.speed_max = self.caster:GetTalentValue("modifier_lifestealer_ghoul_1", "max", true)

self.double_bonus = self.caster:GetTalentValue("modifier_lifestealer_ghoul_3", "bonus", true)
self.double_chance = self.caster:GetTalentValue("modifier_lifestealer_ghoul_3", "chance", true)
self.double_delay = self.caster:GetTalentValue("modifier_lifestealer_ghoul_3", "delay", true)
self.double_max = self.caster:GetTalentValue("modifier_lifestealer_ghoul_3", "max", true)

self.effect_duration = self.caster:GetTalentValue("modifier_lifestealer_ghoul_7", "effect_duration", true)

self.shield_duration = self.caster:GetTalentValue("modifier_lifestealer_hero_7", "duration", true)

self.slow_duration = self.caster:GetTalentValue("modifier_lifestealer_hero_4", "duration", true)

self.aura_acitve = false
self.search_radius = self.caster:GetTalentValue("modifier_lifestealer_ghoul_4", "radius", true)
self.stun_health = self.caster:GetTalentValue("modifier_lifestealer_ghoul_4", "health", true)
self.stun_duration = self.caster:GetTalentValue("modifier_lifestealer_ghoul_4", "stun", true)
self.stun_cd = self.caster:GetTalentValue("modifier_lifestealer_ghoul_4", "talent_cd", true)

if not IsServer() then return end

self.interval = 0.1

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:OnRefresh(table)
self.move_speed = self.ability:GetSpecialValueFor("movement_speed_bonus")
self.attack_speed = self.ability:GetSpecialValueFor("attack_speed_bonus")
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_lifestealer_ghoul_1" or self.caster:HasTalent("modifier_lifestealer_ghoul_1") then
	self.speed_bonus = self.caster:GetTalentValue("modifier_lifestealer_ghoul_1", "speed")
	self.caster:AddAttackEvent_out(self, true)
end

if name == "modifier_lifestealer_hero_3" or self.caster:HasTalent("modifier_lifestealer_hero_3") then
	self.move_bonus = self.caster:GetTalentValue("modifier_lifestealer_hero_3", "move")
	self.status_bonus = self.caster:GetTalentValue("modifier_lifestealer_hero_3", "status")
end

if name == "modifier_lifestealer_hero_4" or self.caster:HasTalent("modifier_lifestealer_hero_4") then
	self.caster:AddAttackEvent_out(self, true)
end

if name == "modifier_lifestealer_ghoul_2" or self.caster:HasTalent("modifier_lifestealer_ghoul_2") then
	self.range_bonus = self.caster:GetTalentValue("modifier_lifestealer_ghoul_2", "range")
	self.cleave_bonus = self.caster:GetTalentValue("modifier_lifestealer_ghoul_2", "cleave")/100
	self.caster:AddAttackEvent_out(self, true)
end

if name == "modifier_lifestealer_ghoul_7" or self.caster:HasTalent("modifier_lifestealer_ghoul_7") then
	self.caster:AddAttackEvent_out(self, true)
	self:StartIntervalThink(self.interval)
end

if name == "modifier_lifestealer_ghoul_4" or self.caster:HasTalent("modifier_lifestealer_ghoul_4") then
	if self.caster == self.parent then
		self.aura_acitve = true
	end
	self.caster:AddAttackEvent_out(self, true)
end

if name == "modifier_lifestealer_hero_7" or self.caster:HasTalent("modifier_lifestealer_hero_7") then
  self.parent:AddHealEvent_inc(self, true)
end

if name == "modifier_lifestealer_ghoul_3" or self.caster:HasTalent("modifier_lifestealer_ghoul_3") then
	self.caster:AddAttackStartEvent_out(self)
end

local mod = self.parent:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.target and mod.is_legendary == 1 and mod.target:HasModifier(self:GetName()) then
	mod.target:FindModifierByName(self:GetName()):UpdateTalent(name)
end

self:SendBuffRefreshToClients()
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_lifestealer_ghoul_7") then return end

local mod = nil
local stack = 0
local time = 0

if self.legendary_target and not self.legendary_target:IsNull() then
	mod = self.legendary_target:FindModifierByName("modifier_life_stealer_ghoul_frenzy_custom_legendary_poison")
end

if mod then
	time = mod:GetRemainingTime()
	stack = mod:GetStackCount()
end

local active = (stack ~= 0 and self.parent:HasModifier("modifier_life_stealer_ghoul_frenzy_custom_active")) and 1 or 0

self.parent:UpdateUIlong({max = self.effect_duration, stack = time, override_stack = stack, active = active, style = "LifestealerGhoul"})

if stack == 0 then
	self.legendary_target = nil
	self:StartIntervalThink(-1)
else
	self:StartIntervalThink(self.interval)
end

end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:AddCustomTransmitterData() 
return 
{
  rage_legendary = self.rage_legendary,
  status_bonus = self.status_bonus,
  move_bonus = self.move_bonus,
  speed_bonus = self.speed_bonus,
  range_bonus = self.range_bonus,
  aura_acitve = self.aura_acitve
} 
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:HandleCustomTransmitterData(data)
self.rage_legendary = data.rage_legendary
self.status_bonus = data.status_bonus
self.move_bonus = data.move_bonus
self.speed_bonus = data.speed_bonus
self.range_bonus = data.range_bonus
self.aura_acitve = data.aura_acitve
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:HealEvent_inc(params)
if not IsServer() then return end
if params.unit ~= self.parent then return end
if not params.inflictor then return end

local final = params.prev_health + params.gain

if final <= self.parent:GetMaxHealth() then return end
local above = final - self.parent:GetMaxHealth()

self.parent:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_shield", {duration = self.shield_duration, shield = above})
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:AttackStartEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

local target = params.target
if not target:IsUnit() then return end

if self.caster:HasTalent("modifier_lifestealer_ghoul_3") and not self.parent:HasModifier("modifier_life_stealer_ghoul_frenzy_custom_double_damage") then

	local mod = self.parent:FindModifierByName("modifier_life_stealer_ghoul_frenzy_custom_double_chance")
	local chance = self.double_chance
	if mod then
		if mod.target and target:entindex() ~= mod.target then
			mod:SetStackCount(0)
			mod.target = target:entindex()
		end
		chance = chance + mod:GetStackCount()*self.double_bonus
	end
	if RollPseudoRandomPercentage(chance, 1968, self.parent) then
		target:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_double", {attacker = self.parent:entindex()})
		self.parent:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_double_chance", {target = target:entindex()})
	end
end

end



function modifier_life_stealer_ghoul_frenzy_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local target = params.target

if self.caster:HasTalent("modifier_lifestealer_ghoul_7") then
	local mod = self.parent == self.caster and self or self.caster:FindModifierByName(self:GetName())
	if mod then
		mod.legendary_target = target
		mod:StartIntervalThink(mod.interval)
	end
end

if self.caster:HasTalent("modifier_lifestealer_ghoul_1") then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_speed_bonus", {max = self.speed_max, target = target:entindex()})
end

if self.caster:HasTalent("modifier_lifestealer_hero_4") then
	target:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_slow", {duration = self.slow_duration})
end

if self.caster:HasTalent("modifier_lifestealer_ghoul_2") then
	DoCleaveAttack( self.parent, target, self.ability, self.cleave_bonus*params.damage, 150, 360, 650, "particles/bloodseeker/thirst_cleave.vpcf" )
end  

if self.caster:HasTalent("modifier_lifestealer_ghoul_4") and target:GetHealthPercent() <= self.stun_health and not target:HasModifier("modifier_life_stealer_ghoul_frenzy_custom_stun_cd") then
	target:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_stun_cd", {duration = self.stun_cd})
	target:AddNewModifier(self.caster, self.caster:BkbAbility(self.ability, true), "modifier_bashed", {duration = (1 - target:GetStatusResistance())*self.stun_duration})

    local immortal_particle = ParticleManager:CreateParticle("particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(immortal_particle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(immortal_particle, 1, self.parent:GetAbsOrigin() )
    ParticleManager:Delete(immortal_particle, 1)
    target:EmitSound("Lifestealer.Frenzy_bash")
end

if self.parent:HasModifier("modifier_life_stealer_ghoul_frenzy_custom_active") then

	local vec = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
	vec.z = 0

	local effect = RandomInt(1, 2) == 1 and "particles/lifestealer/frenzy_legendary_attack_2.vpcf" or "particles/lifestealer/frenzy_legendary_attack.vpcf"

	local rage_particle = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(rage_particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlForward(rage_particle, 1, vec)
	ParticleManager:ReleaseParticleIndex(rage_particle)

	local attack_particle = ParticleManager:CreateParticle("particles/econ/items/viper/viper_ti7_immortal/viper_poison_attack_ti7_explosion.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControlEnt( attack_particle, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(attack_particle)

	target:EmitSound("Lifestealer.Frenzy_legendary_attack")
	target:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_legendary_poison", {duration = self.effect_duration})
	return
end

local mod = target:FindModifierByName("modifier_life_stealer_ghoul_frenzy_custom_legendary_poison")
if mod then
	mod:SetDuration(self.effect_duration, true)
end

end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetModifierAttackRangeBonus()
return self.range_bonus
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetModifierStatusResistanceStacking()
if self.parent:PassivesDisabled() then return end
return self.status_bonus
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetModifierMoveSpeedBonus_Percentage()
if self.parent:PassivesDisabled() then return end
return self.move_speed + self.move_bonus
end

function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetModifierAttackSpeedBonus_Constant()
if self.parent:PassivesDisabled() then return end
if self.parent:HasModifier("modifier_life_stealer_infest_custom") then return end
return self.attack_speed + self.parent:GetUpgradeStack("modifier_life_stealer_ghoul_frenzy_custom_speed_bonus")*self.speed_bonus
end


function modifier_life_stealer_ghoul_frenzy_custom_tracker:IsAura() return self.aura_acitve end
function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetAuraDuration() return 0.1 end
function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetAuraRadius() return self.search_radius end
function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetModifierAura() return "modifier_life_stealer_ghoul_frenzy_custom_vision" end
function modifier_life_stealer_ghoul_frenzy_custom_tracker:GetAuraEntityReject(hEntity)
return hEntity:GetHealthPercent() > self.stun_health
end





modifier_life_stealer_ghoul_frenzy_custom_legendary_poison = class(mod_visible)
function modifier_life_stealer_ghoul_frenzy_custom_legendary_poison:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.interval = self.caster:GetTalentValue("modifier_lifestealer_ghoul_7", "interval")
self.heal = self.caster:GetTalentValue("modifier_lifestealer_ghoul_7", "heal")/100
self.damage = self.caster:GetTalentValue("modifier_lifestealer_ghoul_7", "damage")*self.interval
self.damage_type = self.caster:GetTalentValue("modifier_lifestealer_ghoul_7", "damage_type")

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = self.damage_type}

if not IsServer() then return end

self.RemoveForDuel = true

self.parent:GenericParticle("particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_debuff_ti7.vpcf", self)
self:SetStackCount(1)
self:StartIntervalThink(self.interval)
end

function modifier_life_stealer_ghoul_frenzy_custom_legendary_poison:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_life_stealer_ghoul_frenzy_custom_legendary_poison:OnIntervalThink()
if not IsServer() then return end

self.damageTable.damage = self.damage*self:GetStackCount()
local real_damage = DoDamage(self.damageTable, "modifier_lifestealer_ghoul_7")
self.parent:SendNumber(OVERHEAD_ALERT_BONUS_POISON_DAMAGE, real_damage)

local caster = self.caster

local mod = caster:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.target and mod.is_legendary == 1 then
	caster = mod.target
end

if caster:IsAlive() then
	caster:GenericHeal(real_damage*self.heal, self.ability, true, "", "modifier_lifestealer_ghoul_7")
end

end

function modifier_life_stealer_ghoul_frenzy_custom_legendary_poison:GetStatusEffectName()
return "particles/status_fx/status_effect_poison_venomancer.vpcf"
end

function modifier_life_stealer_ghoul_frenzy_custom_legendary_poison:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL
end


modifier_life_stealer_ghoul_frenzy_custom_active = class(mod_visible)
function modifier_life_stealer_ghoul_frenzy_custom_active:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end
self.parent:EmitSound("Lifestealer.Frenzy_legendary_start")
self.parent:EmitSound("Lifestealer.Frenzy_legendary_start2")
self.parent:GenericParticle("particles/lifestealer/ghoul_legendary_active.vpcf", self)
self.parent:GenericParticle("particles/lifestealer/ghoul_legendary_head.vpcf", self, true)
end





modifier_life_stealer_ghoul_frenzy_custom_double = class(mod_hidden)
function modifier_life_stealer_ghoul_frenzy_custom_double:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_life_stealer_ghoul_frenzy_custom_double:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

if not IsServer() then return end

self.attacker = EntIndexToHScript(table.attacker)
self.delay = self.caster:GetTalentValue("modifier_lifestealer_ghoul_3", "delay")
self:SetStackCount(self.caster:GetTalentValue("modifier_lifestealer_ghoul_3", "attacks") - 1)

self.caster:EmitSound("Lifestealer.Frenzy_double_start")

if self.attacker then
	local name = self.attacker == self.caster and "particles/lifestealer/double_attack.vpcf" or "particles/lifestealer/double_attack_creep.vpcf"
	local dir =  (self.parent:GetOrigin() - self.attacker:GetOrigin() ):Normalized()
	self.attacker:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 3)
	local particle = ParticleManager:CreateParticle( name, PATTACH_ABSORIGIN_FOLLOW, self.attacker )
	ParticleManager:SetParticleControl( particle, 0, self.attacker:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 1, self.attacker:GetAbsOrigin() )
	ParticleManager:SetParticleControlForward( particle, 1, dir)
	ParticleManager:SetParticleControl( particle, 2, Vector(1,1,1) )
	ParticleManager:SetParticleControlForward( particle, 5, dir )
	ParticleManager:ReleaseParticleIndex(particle)
end

self:StartIntervalThink(self.delay)
end


function modifier_life_stealer_ghoul_frenzy_custom_double:OnIntervalThink()
if not IsServer() then return end
if not self.attacker or self.attacker:IsNull() or not self.attacker:IsAlive() then 
	self:Destroy() 
	return 
end

self.attacker:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_double_damage", {duration = FrameTime()})
self.attacker:PerformAttack(self.parent, false, true, true, true, false, false, false)
self.attacker:RemoveModifierByName("modifier_life_stealer_ghoul_frenzy_custom_double_damage")
self.parent:EmitSound("Lifestealer.Frenzy_double_end")

self:DecrementStackCount()
if self:GetStackCount() <= 0 then
	self:Destroy()
	return
else
	self.attacker:EmitSound("Lifestealer.Frenzy_double_start")
end

end



modifier_life_stealer_ghoul_frenzy_custom_double_damage = class(mod_hidden)
function modifier_life_stealer_ghoul_frenzy_custom_double_damage:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_lifestealer_ghoul_3", "damage") - 100
end

function modifier_life_stealer_ghoul_frenzy_custom_double_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_life_stealer_ghoul_frenzy_custom_double_damage:GetModifierDamageOutgoing_Percentage()
return self.damage
end


modifier_life_stealer_ghoul_frenzy_custom_double_chance = class(mod_visible)
function modifier_life_stealer_ghoul_frenzy_custom_double_chance:GetTexture() return "buffs/lifestealer/ghoul_3" end
function modifier_life_stealer_ghoul_frenzy_custom_double_chance:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_lifestealer_ghoul_3", "max")
self.chance_bonus = self.caster:GetTalentValue("modifier_lifestealer_ghoul_3", "bonus")
self.chance = self.caster:GetTalentValue("modifier_lifestealer_ghoul_3", "chance")
self.RemoveForDuel = true

if not IsServer() then return end
self.target = table.target
self:IncrementStackCount()
end

function modifier_life_stealer_ghoul_frenzy_custom_double_chance:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_life_stealer_ghoul_frenzy_custom_double_chance:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_life_stealer_ghoul_frenzy_custom_double_chance:OnTooltip()
return self.chance + self:GetStackCount()*self.chance_bonus
end




modifier_life_stealer_ghoul_frenzy_custom_speed_bonus = class(mod_visible)
function modifier_life_stealer_ghoul_frenzy_custom_speed_bonus:GetTexture() return "buffs/lifestealer/ghoul_1" end
function modifier_life_stealer_ghoul_frenzy_custom_speed_bonus:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.RemoveForDuel = true

if not IsServer() then return end
self.max = table.max
self.target = table.target
self:IncrementStackCount()
end

function modifier_life_stealer_ghoul_frenzy_custom_speed_bonus:OnRefresh(table)
if not IsServer() then return end

if table.target ~= self.target then
	self.target = table.target
	self:SetStackCount(0)
	return
end

if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end



modifier_life_stealer_ghoul_frenzy_custom_vision = class(mod_hidden)
function modifier_life_stealer_ghoul_frenzy_custom_vision:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.interval = 0.3

if not IsServer() then return end
self.parent:GenericParticle("particles/items2_fx/sange_maim.vpcf", self)
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_life_stealer_ghoul_frenzy_custom_vision:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 50, self.interval*2, false)

local target = self.caster
local mod = self.caster:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.target and mod.is_legendary == 1 then
	target = mod.target
end

target:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_ghoul_frenzy_custom_vision_speed", {duration = self.interval*2})
end

function modifier_life_stealer_ghoul_frenzy_custom_vision:GetEffectName()
return "particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf"
end




modifier_life_stealer_ghoul_frenzy_custom_vision_speed = class(mod_hidden)
function modifier_life_stealer_ghoul_frenzy_custom_vision_speed:OnCreated()
self.caster = self:GetCaster()
self.move = self.caster:GetTalentValue("modifier_lifestealer_ghoul_4", "move")
end

function modifier_life_stealer_ghoul_frenzy_custom_vision_speed:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true,
}
end

function modifier_life_stealer_ghoul_frenzy_custom_vision_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_life_stealer_ghoul_frenzy_custom_vision_speed:GetActivityTranslationModifiers()
return "chase"
end

function modifier_life_stealer_ghoul_frenzy_custom_vision_speed:GetModifierMoveSpeedBonus_Constant()
return self.move
end

function modifier_life_stealer_ghoul_frenzy_custom_vision_speed:GetEffectName()
return "particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf"
end

function modifier_life_stealer_ghoul_frenzy_custom_vision_speed:GetStatusEffectName()
return "particles/status_fx/status_effect_thirst_vision.vpcf"
end

function modifier_life_stealer_ghoul_frenzy_custom_vision_speed:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end



modifier_life_stealer_ghoul_frenzy_custom_stun_cd = class(mod_hidden)
function modifier_life_stealer_ghoul_frenzy_custom_stun_cd:OnCreated()
self.RemoveForDuel = true
end







modifier_life_stealer_ghoul_frenzy_custom_shield = class(mod_visible)
function modifier_life_stealer_ghoul_frenzy_custom_shield:GetTexture() return "buffs/lifestealer/hero_7" end
function modifier_life_stealer_ghoul_frenzy_custom_shield:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_life_stealer_ghoul_frenzy_custom_shield:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.shield_talent = "modifier_lifestealer_hero_7"
self.shield = self.caster:GetTalentValue("modifier_lifestealer_hero_7", "shield", true)
self.max_shield = self.shield*self.parent:GetMaxHealth()/100

if not IsServer() then return end
self.RemoveForDuel = true

if self.parent == self.caster then
	self.parent:GenericParticle("particles/lifestealer/heal_shield.vpcf", self)
else
	self.cast_effect = ParticleManager:CreateParticle("particles/lifestealer/heal_shield_creeps.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt( self.cast_effect, 0,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( self.cast_effect, 1, self.parent:GetAbsOrigin() )
	ParticleManager:SetParticleControlEnt( self.cast_effect, 2,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
	self:AddParticle( self.cast_effect, false, false, -1, false, false  )
end

self:SetHasCustomTransmitterData(true)
self:AddShield(table.shield)
end

function modifier_life_stealer_ghoul_frenzy_custom_shield:OnRefresh(table)
if not IsServer() then return end

self:AddShield(table.shield)
end

function modifier_life_stealer_ghoul_frenzy_custom_shield:AddShield(shield)
if not IsServer() then return end
self.max_shield = self.shield*self.parent:GetMaxHealth()/100
self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + shield))
self:SendBuffRefreshToClients()
end

function modifier_life_stealer_ghoul_frenzy_custom_shield:AddCustomTransmitterData() 
return 
{
  max_shield = self.max_shield,
} 
end

function modifier_life_stealer_ghoul_frenzy_custom_shield:HandleCustomTransmitterData(data)
self.max_shield = data.max_shield
end

function modifier_life_stealer_ghoul_frenzy_custom_shield:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() == 0 then return end

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end




modifier_life_stealer_ghoul_frenzy_custom_slow = class({})
function modifier_life_stealer_ghoul_frenzy_custom_slow:IsHidden() return false end
function modifier_life_stealer_ghoul_frenzy_custom_slow:IsPurgable() return true end
function modifier_life_stealer_ghoul_frenzy_custom_slow:GetTexture() return "buffs/lifestealer/hero_4" end
function modifier_life_stealer_ghoul_frenzy_custom_slow:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_lifestealer_hero_4", "max")
self.slow = self.caster:GetTalentValue("modifier_lifestealer_hero_4", "slow")/self.max
self.heal_reduce = self.caster:GetTalentValue("modifier_lifestealer_hero_4", "heal_reduce")/self.max

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_life_stealer_ghoul_frenzy_custom_slow:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
if self:GetStackCount() >= self.max then
	self.parent:GenericParticle("particles/items2_fx/sange_maim.vpcf", self)
	self.parent:EmitSound("Lifestealer.Frenzy_double_end")
end

end

function modifier_life_stealer_ghoul_frenzy_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_life_stealer_ghoul_frenzy_custom_slow:GetModifierMoveSpeedBonus_Percentage() 
return self.slow*self:GetStackCount()
end

function modifier_life_stealer_ghoul_frenzy_custom_slow:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_life_stealer_ghoul_frenzy_custom_slow:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce*self:GetStackCount()
end

function modifier_life_stealer_ghoul_frenzy_custom_slow:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end
