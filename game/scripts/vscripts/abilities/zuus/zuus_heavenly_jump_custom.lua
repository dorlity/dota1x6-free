LinkLuaModifier("modifier_zuus_heavenly_jump_custom_buff", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_debuff", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_move_speed", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_heal", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_passive", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_legendary", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_attack_speed_effect", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_illusion", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_quest", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_invun", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_attacks", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_attacks_caster", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)


zuus_heavenly_jump_custom = class({})



function zuus_heavenly_jump_custom:CreateTalent()
local caster = self:GetCaster()
caster:UpdateUIlong({max = caster:GetTalentValue("modifier_zuus_jump_7", "duration"), stack = 0, active = 0, style = "ZeusJump"})
end

function zuus_heavenly_jump_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_shard.vpcf", context )
PrecacheResource( "particle","particles/zuus_glow.vpcf", context )
PrecacheResource( "particle","particles/zuus_speed.vpcf", context )
PrecacheResource( "particle","particles/zuus_heal.vpcf", context )
PrecacheResource( "particle","particles/zuus_jump_count.vpcf", context )
PrecacheResource( "particle","particles/zuus_speed_max.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_mjollnir_shield.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", context )
PrecacheResource( "particle","particles/huskar_timer.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_mjollnir_shield.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf", context )

end


function zuus_heavenly_jump_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_zuus_jump_4") then
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end


function zuus_heavenly_jump_custom:GetCastRange(vLocation, hTarget)
if IsServer() and self:GetCaster():HasTalent("modifier_zuus_jump_4") then
	return 999999
end
return self:GetRange() - self:GetCaster():GetCastRangeBonus()
end


function zuus_heavenly_jump_custom:GetRange()
local caster = self:GetCaster()
return self:GetSpecialValueFor("hop_distance") + caster:GetTalentValue("modifier_zuus_jump_4", "range")
end

function zuus_heavenly_jump_custom:GetCooldown(iLevel)
local bonus = 0
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function zuus_heavenly_jump_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_zuus_heavenly_jump_custom_passive"
end


function zuus_heavenly_jump_custom:OnSpellStart()

local caster = self:GetCaster()

local height = self:GetSpecialValueFor("hop_height")
local distance = self:GetRange()
local hop_duration = self:GetSpecialValueFor("hop_duration")
local range = self:GetSpecialValueFor("range")
local max_targets = self:GetSpecialValueFor("max_targets")
local vision_duration = self:GetSpecialValueFor("vision_duration")
local vision_radius = self:GetSpecialValueFor("vision_radius")

if caster:HasTalent("modifier_zuus_jump_4") then
	local point = self:GetCursorPosition()
	if point == caster:GetAbsOrigin() then
		point = caster:GetAbsOrigin() + caster:GetForwardVector()*10
	end

	local vec = point - caster:GetAbsOrigin()
	local dir = vec:Normalized()
	dir.z = 0
	caster:FaceTowards(caster:GetAbsOrigin() + dir*10)
	caster:SetForwardVector(dir)
	if vec:Length2D() >= distance then
		point = caster:GetAbsOrigin() + dir*distance
	end

	distance = (point - caster:GetAbsOrigin()):Length2D()
	ProjectileManager:ProjectileDodge(caster)
	caster:AddNewModifier(caster, self, "modifier_zuus_heavenly_jump_custom_invun", {duration = hop_duration + 0.1})
end

local direction = caster:GetForwardVector()
caster:EmitSound("Hero_Zuus.StaticField")

AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), vision_radius, vision_duration, false)

if caster:HasTalent("modifier_zuus_hero_5") then 
	local duration = caster:GetTalentValue("modifier_zuus_hero_5", "delay")
  	local illusion_self = CreateIllusions(caster, caster, 
  	{
	    outgoing_damage = 0,
	    duration = duration
    }, 1, 0, false, false)

    local point = caster:GetAbsOrigin()
    for _,illusion in pairs(illusion_self) do

      illusion.owner = caster
      illusion:AddNewModifier(caster, self, "modifier_zuus_heavenly_jump_custom_illusion",  {duration = duration})
      illusion:SetOrigin(GetGroundPosition(point, nil))
    end
end

if caster:HasTalent("modifier_zuus_hero_2") then 
	caster:AddNewModifier(caster, self, "modifier_zuus_heavenly_jump_custom_heal", {duration = caster:GetTalentValue("modifier_zuus_hero_2", "duration")})
end

local arc = caster:AddNewModifier( caster, self, "modifier_generic_arc",
{ 
	dir_x = direction.x,
	dir_y = direction.y,
	duration = hop_duration,
	distance = distance,
	height = height,
	fix_end = false,
	isStun = true,
	isForward = true,
	activity = ACT_DOTA_CAST_ABILITY_3,
})

if arc then 
	arc:SetEndCallback(function()
		if caster:HasTalent("modifier_zuus_jump_2") then 
			caster:RemoveModifierByName("modifier_zuus_heavenly_jump_custom_move_speed")
			caster:AddNewModifier(caster, self, "modifier_zuus_heavenly_jump_custom_move_speed", {duration = caster:GetTalentValue("modifier_zuus_jump_2", "duration")})
		end

		if caster:GetQuest() == "Zuus.Quest_7" and not caster:QuestCompleted() then 
			caster:AddNewModifier(caster, self, "modifier_zuus_heavenly_jump_custom_quest", {duration = caster.quest.number})
		end
	end)
end

local units = {}
local units_heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
local units_creeps = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	
if #units_heroes > 0 then 
	for i = 1, #units_heroes do 
		units[#units + 1] = units_heroes[i]
	end
end
if #units_creeps > 0 then 
	for i = 1, #units_creeps do 
		units[#units + 1] = units_creeps[i]
	end
end

if #units == 0 then return end

max_targets = math.min(max_targets, #units)

local hit_hero = false

for i = 1,max_targets do
	local unit = units[i]
	if unit and not unit:IsNull() then
		if caster:HasTalent("modifier_zuus_jump_1") then
			unit:AddNewModifier(caster, self, "modifier_zuus_heavenly_jump_custom_attacks", {})
		end
		self:DealDamage(unit)

		if mod then
			mod:PassiveProc(unit)
		end

		if unit:IsRealHero() then
			hit_hero = true
		end
	end
end

local mod = caster:FindModifierByName("modifier_zuus_heavenly_jump_custom_passive")
if mod then
	mod:LegendaryStack(hit_hero)
end

end






function zuus_heavenly_jump_custom:DealDamage(target)
if not IsServer() then return end
local caster = self:GetCaster()

local damage = self:GetSpecialValueFor("damage")
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_zuus_hero_1", "slow")

local static = caster:FindModifierByName("modifier_zuus_innate_custom") 
if static then 
	static:DealDamage(target)
end

if caster:HasTalent("modifier_zuus_hero_5") then
	target:AddNewModifier(caster, self, "modifier_generic_leash", {duration = duration})
end

target:AddNewModifier(caster, self, "modifier_zuus_heavenly_jump_custom_debuff", {duration = duration})
DoDamage({ victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = caster, ability = self })
target:EmitSound("Hero_Zuus.ArcLightning.Target")

local particle = "particles/units/heroes/hero_zuus/zuus_shard.vpcf"
if caster:HasModifier("modifier_zuus_2021_immortal_custom") then
    particle = "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_shard_static_field.vpcf"
end
if caster:HasModifier("modifier_zuus_2021_immortal_custom_witness") then
    particle = "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_crimson_shard_static_field.vpcf"
end
if caster:HasModifier("modifier_zuus_2021_immortal_custom_golden") then
    particle = "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_gold_shard_static_field.vpcf"
end

local thunder = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(thunder, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(thunder, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(thunder, 2, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(thunder)

local self_particle = ParticleManager:CreateParticle("particles/zuus_glow.vpcf", PATTACH_POINT, caster)
ParticleManager:SetParticleControlEnt(self_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self_particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(self_particle)
end



function zuus_heavenly_jump_custom:OnProjectileHit(target, location)
if not target then return end
local caster = self:GetCaster()

target:EmitSound("Hero_Zuus.ProjectileImpact")
target:EmitSound("Hero_Zuus.ArcLightning.Target")

caster:AddNewModifier(caster, self, "modifier_zuus_heavenly_jump_custom_attacks_caster", {})
caster:PerformAttack(target, true, true, true, true, false, false, true)
caster:RemoveModifierByName("modifier_zuus_heavenly_jump_custom_attacks_caster")
end




modifier_zuus_heavenly_jump_custom_passive = class({})
function modifier_zuus_heavenly_jump_custom_passive:IsHidden() return true end
function modifier_zuus_heavenly_jump_custom_passive:IsPurgable() return false end
function modifier_zuus_heavenly_jump_custom_passive:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end

function modifier_zuus_heavenly_jump_custom_passive:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_zuus_jump_7") then return end
return self.range_bonus
end

function modifier_zuus_heavenly_jump_custom_passive:GetModifierPhysicalArmorBonus()
local bonus = self.armor
if self.parent:HasModifier("modifier_zuus_heavenly_jump_custom_move_speed") then
	bonus = bonus*self.move_bonus
end
return bonus
end

function modifier_zuus_heavenly_jump_custom_passive:GetModifierMoveSpeedBonus_Constant()
local bonus = self.move
if self.parent:HasModifier("modifier_zuus_heavenly_jump_custom_move_speed") then
	bonus = bonus*self.move_bonus
end
return bonus
end


function modifier_zuus_heavenly_jump_custom_passive:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.move_bonus = self.parent:GetTalentValue("modifier_zuus_jump_2", "bonus", true)

self.range_bonus = self.parent:GetTalentValue("modifier_zuus_jump_7", "range", true)
self.cd_inc = self.parent:GetTalentValue("modifier_zuus_jump_7", "cd_inc", true)
self.legendary_duration = self.parent:GetTalentValue("modifier_zuus_jump_7", "duration", true)
self.legendary_duration_creeps = self.parent:GetTalentValue("modifier_zuus_jump_7", "duration_creeps", true)

self.proc_chance = self.parent:GetTalentValue("modifier_zuus_jump_3", "chance")
self.proc_slow = self.parent:GetTalentValue("modifier_zuus_jump_3", "slow", true)
self.proc_damage = self.parent:GetTalentValue("modifier_zuus_jump_3", "damage", true)
self.proc_damage_type = self.parent:GetTalentValue("modifier_zuus_jump_3", "damage_type", true)

self.move = self.parent:GetTalentValue("modifier_zuus_jump_2", "move")
self.armor = self.parent:GetTalentValue("modifier_zuus_jump_2", "armor")

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end


function modifier_zuus_heavenly_jump_custom_passive:UpdateTalent(name)

if name == "modifier_zuus_jump_7" or self.parent:HasTalent("modifier_zuus_jump_7") then
	self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_zuus_jump_3" or self.parent:HasTalent("modifier_zuus_jump_3") then
	self.proc_chance = self.parent:GetTalentValue("modifier_zuus_jump_3", "chance")
	self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_zuus_jump_2" or self.parent:HasTalent("modifier_zuus_jump_2") then
	self.move = self.parent:GetTalentValue("modifier_zuus_jump_2", "move")
	self.armor = self.parent:GetTalentValue("modifier_zuus_jump_2", "armor")
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_zuus_heavenly_jump_custom_passive:AddCustomTransmitterData() 
return 
{
    armor = self.armor,
    move = self.move
} 
end

function modifier_zuus_heavenly_jump_custom_passive:HandleCustomTransmitterData(data)
self.armor = data.armor
self.move = data.move
end




function modifier_zuus_heavenly_jump_custom_passive:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

self:PassiveProc(params.target)

if params.no_attack_cooldown then return end
if not self.parent:HasTalent("modifier_zuus_jump_7") then return end
self.parent:CdAbility(self.ability, self.cd_inc)
end

function modifier_zuus_heavenly_jump_custom_passive:PassiveProc(target)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_zuus_jump_3") then return end
if not target or target:IsNull() or not target:IsAlive() then return end
if not RollPseudoRandomPercentage(self.proc_chance, 1985, self.parent) then return end

local static = self.parent:FindModifierByName("modifier_zuus_innate_custom") 
if static then 
	static:DealDamage(target)
end

target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
target:SendNumber(4, self.proc_damage)
target:GenericParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf")

target:AddNewModifier(self.parent, self.ability, "modifier_zuus_heavenly_jump_custom_debuff", {duration = self.proc_slow})
DoDamage({ victim = target, damage = self.proc_damage, damage_type = self.proc_damage_type, attacker = self.parent, ability = self.ability }, "modifier_zuus_jump_3")
end

function modifier_zuus_heavenly_jump_custom_passive:LegendaryStack(hit_hero)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_zuus_jump_7") then return end

local duration = hit_hero and self.legendary_duration or self.legendary_duration_creeps

self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_heavenly_jump_custom_legendary", {duration = duration})
end



modifier_zuus_heavenly_jump_custom_debuff = class({})
function modifier_zuus_heavenly_jump_custom_debuff:IsPurgable() return true end
function modifier_zuus_heavenly_jump_custom_debuff:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.move_slow = self.ability:GetSpecialValueFor("move_slow")
self.aspd_slow = self.ability:GetSpecialValueFor("aspd_slow")

if not IsServer() then return end

local particle = "particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf"
if self.caster:HasModifier("modifier_zuus_2021_immortal_custom_golden") then
    particle = "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_shard_gold_slow.vpcf"
end
if self.caster:HasModifier("modifier_zuus_2021_immortal_custom_witness") then
    particle = "particles/units/heroes/hero_zuus/zuus_shard_crimson_slow.vpcf"
end
self.parent:GenericParticle(particle, self)
end

function modifier_zuus_heavenly_jump_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_zuus_heavenly_jump_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.move_slow
end

function modifier_zuus_heavenly_jump_custom_debuff:GetModifierAttackSpeedBonus_Constant()
return self.aspd_slow
end




modifier_zuus_heavenly_jump_custom_move_speed = class(mod_hidden)
function modifier_zuus_heavenly_jump_custom_move_speed:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:GenericParticle("particles/zuus_speed.vpcf", self)
end






modifier_zuus_heavenly_jump_custom_heal = class(mod_visible)
function modifier_zuus_heavenly_jump_custom_heal:GetTexture() return "buffs/jump_heal" end
function modifier_zuus_heavenly_jump_custom_heal:OnCreated(table)
self.parent = self:GetParent()
self.duration = self.parent:GetTalentValue("modifier_zuus_hero_2", "duration")
self.mana = (self.parent:GetMaxMana()*self.parent:GetTalentValue("modifier_zuus_hero_2", "mana")/100)/self.duration

if not IsServer() then return end
self.parent:GenericParticle("particles/zuus_heal.vpcf", self)
end


function modifier_zuus_heavenly_jump_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
}
end

function modifier_zuus_heavenly_jump_custom_heal:GetModifierConstantHealthRegen()
return self.mana
end

function modifier_zuus_heavenly_jump_custom_heal:GetModifierConstantManaRegen()
return self.mana
end







modifier_zuus_heavenly_jump_custom_legendary = class(mod_hidden)

function modifier_zuus_heavenly_jump_custom_legendary:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.speed = self.parent:GetTalentValue("modifier_zuus_jump_7", "speed")
self.max = self.parent:GetTalentValue("modifier_zuus_jump_7", "max")
self.duration = self:GetRemainingTime()

if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_zuus_heavenly_jump_custom_legendary:OnRefresh(table)
if not IsServer() then return end
self.duration = self:GetRemainingTime()

if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_heavenly_jump_custom_attack_speed_effect", {})
end

end


function modifier_zuus_heavenly_jump_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIlong({max = self.duration, stack = self:GetRemainingTime(), override_stack = self:GetStackCount(), active = self:GetStackCount() >= self.max and 1 or 0, style = "ZeusJump"})
end



function modifier_zuus_heavenly_jump_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_zuus_heavenly_jump_custom_legendary:GetModifierAttackSpeedBonus_Constant(params)
return self.speed*self:GetStackCount()
end

function modifier_zuus_heavenly_jump_custom_legendary:OnDestroy()
if not IsServer() then return end
self.parent:UpdateUIlong({max = self.duration, stack = 0, active = 0, style = "ZeusJump"})
self.parent:RemoveModifierByName("modifier_zuus_heavenly_jump_custom_attack_speed_effect")
end



modifier_zuus_heavenly_jump_custom_attack_speed_effect = class(mod_hidden)
function modifier_zuus_heavenly_jump_custom_attack_speed_effect:IsHidden() return true end
function modifier_zuus_heavenly_jump_custom_attack_speed_effect:IsPurgable() return false end
function modifier_zuus_heavenly_jump_custom_attack_speed_effect:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_zuus_heavenly_jump_custom_attack_speed_effect:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH  end
function modifier_zuus_heavenly_jump_custom_attack_speed_effect:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:EmitSound("Zuus.Jump_speed")
self.parent:EmitSound("Zuus.Jump_speed2")
self.parent:GenericParticle("particles/zuus_speed_max.vpcf", self)
end

function modifier_zuus_heavenly_jump_custom_attack_speed_effect:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_zuus_heavenly_jump_custom_attack_speed_effect:GetModifierModelScale()
return 25
end



modifier_zuus_heavenly_jump_custom_illusion = class(mod_hidden)
function modifier_zuus_heavenly_jump_custom_illusion:CheckState()
return
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
}
end

function modifier_zuus_heavenly_jump_custom_illusion:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.radius = self.caster:GetTalentValue("modifier_zuus_hero_5", "radius")
self.stun = self.caster:GetTalentValue("modifier_zuus_hero_5", "stun")

self.parent:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
self.parent:GenericParticle("particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf", self)
self.parent:EmitSound("Zuus.Jump_remnant")

self.t = -1
self.timer = self.caster:GetTalentValue("modifier_zuus_hero_5", "delay")*2 
self:StartIntervalThink(0.5)
self:OnIntervalThink()
end


function modifier_zuus_heavenly_jump_custom_illusion:OnIntervalThink()
if not IsServer() then return end
self.t = self.t + 1

local number = (self.timer-self.t)/2 
local int = number

if number % 1 ~= 0 then 
	int = number - 0.5 
end

local digits = math.floor(math.log10(number)) + 2
local decimal = number % 1

if decimal == 0.5 then
    decimal = 8
else 
    decimal = 1
end

local particle = ParticleManager:CreateParticle("particles/huskar_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)
end


function modifier_zuus_heavenly_jump_custom_illusion:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}

end
function modifier_zuus_heavenly_jump_custom_illusion:GetOverrideAnimation()return ACT_DOTA_GENERIC_CHANNEL_1 end
function modifier_zuus_heavenly_jump_custom_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_zuus_heavenly_jump_custom_illusion:StatusEffectPriority() return MODIFIER_PRIORITY_ILLUSION end
function modifier_zuus_heavenly_jump_custom_illusion:OnDestroy()
if not IsServer() then return end

local particle_explode_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle_explode_fx, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_explode_fx, 1, Vector(self.radius, 1, 1))
ParticleManager:SetParticleControl(particle_explode_fx, 3, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_explode_fx)

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

self.parent:EmitSound("Zuus.Jump_illusion")

for _,unit in pairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())) do 
	unit:EmitSound("Zuus.Jump_stun")
	unit:GenericParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf")
	unit:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = (1 - unit:GetStatusResistance())*self.stun})
end

end



modifier_zuus_heavenly_jump_custom_quest = class({})
function modifier_zuus_heavenly_jump_custom_quest:IsHidden() return true end
function modifier_zuus_heavenly_jump_custom_quest:IsPurgable() return false end


modifier_zuus_heavenly_jump_custom_invun = class(mod_hidden)
function modifier_zuus_heavenly_jump_custom_invun:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true
}
end


modifier_zuus_heavenly_jump_custom_attacks = class(mod_hidden)
function modifier_zuus_heavenly_jump_custom_attacks:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

if not IsServer() then return end
self:SetStackCount(self.caster:GetTalentValue("modifier_zuus_jump_1", "attacks"))
self.interval = self.caster:GetTalentValue("modifier_zuus_jump_1", "interval")

self.info = 
{
	EffectName = "particles/units/heroes/hero_zuus/zuus_base_attack.vpcf",
	Ability = self.ability,
	iMoveSpeed = 1500,
	Source = self.caster,
	Target = self.parent,
	bDodgeable = true,
	bProvidesVision = true,
	iVisionTeamNumber = self.caster:GetTeamNumber(),
	iVisionRadius = 50,
	iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1, 
}

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_zuus_heavenly_jump_custom_attacks:OnIntervalThink()
if not IsServer() then return end


ProjectileManager:CreateTrackingProjectile( self.info )

self:DecrementStackCount()
if self:GetStackCount() <= 0 then
	self:Destroy()
end

end


modifier_zuus_heavenly_jump_custom_attacks_caster = class(mod_hidden)
function modifier_zuus_heavenly_jump_custom_attacks_caster:OnCreated()
self.damage = self:GetParent():GetTalentValue("modifier_zuus_jump_1", "damage") - 100
end

function modifier_zuus_heavenly_jump_custom_attacks_caster:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_zuus_heavenly_jump_custom_attacks_caster:GetModifierDamageOutgoing_Percentage()
if not IsServer() then return end
return self.damage
end