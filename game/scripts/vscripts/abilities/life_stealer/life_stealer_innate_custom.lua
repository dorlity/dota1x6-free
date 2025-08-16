LinkLuaModifier( "modifier_life_stealer_innate_custom_tracker", "abilities/life_stealer/life_stealer_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_innate_custom_health", "abilities/life_stealer/life_stealer_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_innate_custom_proc_cd", "abilities/life_stealer/life_stealer_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_innate_custom_scepter_unit", "abilities/life_stealer/life_stealer_innate_custom", LUA_MODIFIER_MOTION_NONE )

life_stealer_innate_custom = class({})



function life_stealer_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_health_steal.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/rage_legendary_attack.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/rage_legendary_attack_2.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/scepter_blood.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context )
PrecacheResource( "model", "models/events/crownfall/survivors/skeleton_melee/skeleton_melee.vmdl", context )

PrecacheResource( "soundfile", "soundevents/npc_dota_hero_life_stealer.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_life_stealer", context)
end


function life_stealer_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsCreepHero() then return end
return "modifier_life_stealer_innate_custom_tracker"
end

function life_stealer_innate_custom:OnInventoryContentsChanged()
if self:IsStolen() then return end
local caster = self:GetCaster()

if not caster:HasScepter() then return end
if caster:HasModifier("modifier_life_stealer_innate_custom_health") then return end

local mod = caster:FindModifierByName("modifier_life_stealer_innate_custom_tracker")
if mod then
	mod:OnIntervalThink()
	mod:StartIntervalThink(0.1)
end

end


modifier_life_stealer_innate_custom_tracker = class(mod_hidden)
function modifier_life_stealer_innate_custom_tracker:IsHidden() return not self.parent:HasScepter() end
function modifier_life_stealer_innate_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.damage = self.ability:GetSpecialValueFor("hp_leech_percent")/100
self.creeps_max = self.ability:GetSpecialValueFor("damage_creeps_max")
self.creeps_bonus = self.ability:GetSpecialValueFor("creeps_bonus")

self.feast_bonus = self.ability:GetSpecialValueFor("feast_bonus")
self.feast_init = self.ability:GetSpecialValueFor("feast_init")
self.scepter_max = self.ability:GetSpecialValueFor("scepter_max")
self.health_init = self.ability:GetSpecialValueFor("health_init")
self.scepter_health_hero = self.ability:GetSpecialValueFor("scepter_health_hero")

self.scepter_timer = self.ability:GetSpecialValueFor("scepter_timer")*60

self.proc_damage_type = self.caster:GetTalentValue("modifier_lifestealer_wounds_3", "damage_type", true)

self.rage_bonus = self.caster:GetTalentValue("modifier_lifestealer_rage_7", "feast", true)
self.rage_active = self.caster:GetTalentValue("modifier_lifestealer_rage_7", "bonus", true)

self.proc_cd = self.caster:GetTalentValue("modifier_lifestealer_wounds_3", "cd", true)

if not IsServer() then return end
self.caster:AddAttackEvent_out(self, true)

if self.parent:IsRealHero() then
	self.parent:AddDeathEvent(self, true)
end

end

function modifier_life_stealer_innate_custom_tracker:OnRefresh(table)
self.damage = self.ability:GetSpecialValueFor("hp_leech_percent")/100
end

function modifier_life_stealer_innate_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_life_stealer_innate_custom_tracker:GetModifierHealthBonus()
if not self.parent:HasScepter() then return end
return self.health_init + self.scepter_health_hero*self:GetStackCount()
end

function modifier_life_stealer_innate_custom_tracker:OnTooltip()
if not self.parent:HasScepter() then return end
return self.feast_init + self.feast_bonus*self:GetStackCount()
end

function modifier_life_stealer_innate_custom_tracker:GetBonus(target, damage_k)
if self.parent:HasTalent("modifier_lifestealer_infest_7") then return 0 end

local bonus = (self.parent:HasScepter() and (self.feast_init + self:GetStackCount()*self.feast_bonus)/100 or 0)
if self.parent ~= self.caster then
	bonus = (self.caster:HasScepter() and (self.feast_init + self.caster:GetUpgradeStack(self:GetName())*self.feast_bonus)/100 or 0)
end
local feast_k = self.damage + bonus
if self.caster:HasTalent("modifier_lifestealer_rage_7") then
	local bonus = feast_k*self.rage_bonus*(self.parent:GetMaxHealth() - self.parent:GetHealth())
	if self.parent:HasModifier("modifier_life_stealer_rage_custom") then
		bonus = bonus*self.rage_active
	end
	return bonus
end

local result = target:GetMaxHealth()*feast_k*(damage_k and damage_k or 1)
if target:IsCreep() then
	result = math.min(self.creeps_max, result)
end
return result 
end

function modifier_life_stealer_innate_custom_tracker:GetModifierPreAttack_BonusDamage(params)
if self.parent:PassivesDisabled() then return end

if self.caster:HasTalent("modifier_lifestealer_rage_7") then
	return self:GetBonus()
end

if not IsServer() then return end
if not params.target or not params.target:IsUnit() then return end

local bonus = self:GetBonus(params.target) 
return params.target:IsCreep() and bonus*self.creeps_bonus or bonus
end

function modifier_life_stealer_innate_custom_tracker:ProcDamage(params, damage_k)
if not IsServer() then return end
local target = params.unit

if target:HasModifier("modifier_life_stealer_innate_custom_proc_cd") then return end
if self.parent ~= params.attacker and self.caster ~= params.attacker then return end
if self.parent:PassivesDisabled() then return end
if not params.unit:IsUnit() then return end
if params.inflictor and params.inflictor == self.ability then return end

local heal = self:GetBonus(target, damage_k)
target:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_innate_custom_proc_cd", {duration = self.proc_cd})

local real_damage = DoDamage({victim = target, attacker = self.parent, ability = self.ability, damage = heal, damage_type = self.proc_damage_type}, "modifier_lifestealer_wounds_3")
if heal > 0 then
	self.parent:GenericHeal(heal, self.ability, false, nil, "modifier_lifestealer_wounds_3")
end
target:EmitSound("Lifestealer.Wounds_feast")
target:SendNumber(4, real_damage)
end



function modifier_life_stealer_innate_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if self.parent:PassivesDisabled() then return end
if not params.target:IsUnit() then return end

local target = params.target
local heal = self:GetBonus(target)

if self.parent:HasModifier("modifier_life_stealer_rage_custom") and self.caster:HasTalent("modifier_lifestealer_rage_7") then
	target:SendNumber(6, heal)
	local vec = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
	vec.z = 0

	local effect = RandomInt(1, 2) == 1 and "particles/lifestealer/rage_legendary_attack_2.vpcf" or "particles/lifestealer/rage_legendary_attack.vpcf"

	local rage_particle = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(rage_particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControlForward(rage_particle, 1, vec)
	ParticleManager:ReleaseParticleIndex(rage_particle)
	target:EmitSound("Lifestealer.Rage_legenary_attack")
end

if heal > 0 then
	self.parent:GenericHeal(heal, self.ability, false)
end

end


function modifier_life_stealer_innate_custom_tracker:DeathEvent(params)
if not IsServer() then return end
if not self.ability or self.ability:IsNull() or self.ability:IsStolen() then return end
if not self.parent:HasScepter() then return end
if not players[self.parent:GetId()] then return end

if params.unit:IsRealHero() and not params.unit:IsReincarnating() and not params.unit:IsTempestDouble() and params.unit:GetTeamNumber() ~= self.parent:GetTeamNumber() 
	and self:GetStackCount() < self.scepter_max then 

	local point = params.unit:GetAbsOrigin()
	local unit = CreateUnitByName("npc_lifestealer_scepter_unit", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
	unit:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_innate_custom_scepter_unit", {duration = self.scepter_timer})
end

end

function modifier_life_stealer_innate_custom_tracker:AddStack()
if not IsServer() then return end
if self:GetStackCount() >= self.scepter_max then return end

self:IncrementStackCount()
self.parent:CalculateStatBonus(true)

local effect = self.parent:GenericParticle("particles/units/heroes/hero_life_stealer/life_stealer_health_steal.vpcf", self, true)
ParticleManager:SetParticleControl(effect, 1, Vector(11, 0, 0))
ParticleManager:Delete(effect)

if self:GetStackCount() >= self.scepter_max then
	self.parent:GenericParticle("particles/lc_odd_proc_.vpcf")
	self.parent:EmitSound("BS.Thirst_legendary_active")
end

end




modifier_life_stealer_innate_custom_proc_cd = class(mod_hidden)


modifier_life_stealer_innate_custom_scepter_unit = class(mod_hidden)
function modifier_life_stealer_innate_custom_scepter_unit:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_FROZEN] = true,
  	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
}
end

function modifier_life_stealer_innate_custom_scepter_unit:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

if not IsServer() then return end

self.collected = false
self.timer = 0
self.pos = GetGroundPosition(self.parent:GetAbsOrigin(), nil)
self.radius = 150
self.max_timer = 1

local base_particle = ParticleManager:CreateParticleForPlayer("particles/shrine/capture_point_ring_overthrow.vpcf", PATTACH_WORLDORIGIN, nil, PlayerResource:GetPlayer(self.caster:GetId()))
ParticleManager:SetParticleControl(base_particle, 0, self.pos)
ParticleManager:SetParticleControl(base_particle, 3, Vector(255,70,70))
ParticleManager:SetParticleControl(base_particle, 9, Vector(self.radius, 0, 0))
self:AddParticle(base_particle, false, false, -1, false, false)

local particle = ParticleManager:CreateParticle("particles/lifestealer/scepter_blood.vpcf", PATTACH_WORLDORIGIN, self.parent)
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(self:GetRemainingTime(), 0, 0))
self:AddParticle(particle, false, false, -1, false, false)

self.interval = FrameTime()
self.parent:StartGesture(ACT_DOTA_DIE)

self:StartIntervalThink(self.interval)
end

function modifier_life_stealer_innate_custom_scepter_unit:OnIntervalThink()
if not IsServer() then return end 

self:UpdateParticle()

if (self.caster:GetAbsOrigin() - self.pos):Length2D() > self.radius then
	self.timer = 0
else 
	self.timer = self.timer + self.interval
	if self.timer >= self.max_timer then 
		self.collected = true
		self:Destroy()
		return
	end 
end 

end 

function modifier_life_stealer_innate_custom_scepter_unit:UpdateParticle()
if not IsServer() then return end 

if self.timer > 0 and not self.part_particle then 
	self.part_particle = ParticleManager:CreateParticleForPlayer("particles/shrine/capture_point_ring_clock_overthrow.vpcf", PATTACH_WORLDORIGIN, nil, PlayerResource:GetPlayer(self.caster:GetId()))
	ParticleManager:SetParticleControl(self.part_particle, 0, self.pos + Vector(0,0,20))
	ParticleManager:SetParticleControl(self.part_particle, 11, Vector(0, 0, 1))
	self:AddParticle(self.part_particle, false, false, -1, false, false) 
end 

if not self.part_particle then return end

ParticleManager:SetParticleControl(self.part_particle, 3, Vector(255,90,90))
ParticleManager:SetParticleControl(self.part_particle, 9, Vector(self.radius*1.3, 0, 0))
ParticleManager:SetParticleControl(self.part_particle, 17, Vector(self.timer/self.max_timer, 0, 0))
end


function modifier_life_stealer_innate_custom_scepter_unit:OnDestroy()
if not IsServer() then return end

if self.collected then
	local visual_caster = self.caster
	local mod = visual_caster:FindModifierByName("modifier_life_stealer_infest_custom")
	if mod and mod.target then
		visual_caster = mod.target
	end

	self.parent:EmitSound("Lifestealer.Wounds_death")
	local mod = self.caster:FindModifierByName("modifier_life_stealer_innate_custom_tracker")
	if mod then
		mod:AddStack()
	end

	if self.caster:GetQuest() == "Lifestealer.Quest_7" and not self.caster:QuestCompleted() then
		self.caster:UpdateQuest(1)
	end

	visual_caster:EmitSound("Lifestealer.Scepter_collect")
	visual_caster:GenericParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf")
	local effect_cast = ParticleManager:CreateParticle( "particles/sand_king/sandking_caustic_finale_explode_custom.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.pos + Vector(0, 0, 30))
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

UTIL_Remove(self.parent)
end

function modifier_life_stealer_innate_custom_scepter_unit:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_VISUAL_Z_DELTA
}
end

function modifier_life_stealer_innate_custom_scepter_unit:GetVisualZDelta()
return 25
end

function modifier_life_stealer_innate_custom_scepter_unit:GetActivityTranslationModifiers()
return "expired"
end