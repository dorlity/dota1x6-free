LinkLuaModifier( "modifier_tinker_defense_matrix_custom_tracker", "abilities/tinker/tinker_defense_matrix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_defense_matrix_custom", "abilities/tinker/tinker_defense_matrix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_defense_matrix_custom_legendary_laser", "abilities/tinker/tinker_defense_matrix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_defense_matrix_custom_legendary_target", "abilities/tinker/tinker_defense_matrix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_defense_matrix_custom_invun", "abilities/tinker/tinker_defense_matrix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_defense_matrix_custom_shield_cd", "abilities/tinker/tinker_defense_matrix_custom", LUA_MODIFIER_MOTION_NONE )

tinker_defense_matrix_custom = class({})
tinker_defense_matrix_custom.talents = {}

function tinker_defense_matrix_custom:CreateTalent()
self:ToggleAutoCast()
end

function tinker_defense_matrix_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_defense_matrix_pulse.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_defense_matrix_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_defense_matrix.vpcf", context )
PrecacheResource( "particle", "particles/zeus/bolt_disarm.vpcf", context )
PrecacheResource( "particle", "particles/tinker/matrix_legendary_laser.vpcf", context )
PrecacheResource( "particle", "particles/puck/rift_blink_starta0.vpcf", context )
PrecacheResource( "particle", "particles/tinker/matrix_invun.vpcf", context )
PrecacheResource( "particle", "particles/tinker/matrix_legendary_red.vpcf", context )
end


function tinker_defense_matrix_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsCreepHero() then return end
return "modifier_tinker_defense_matrix_custom_tracker"
end

function tinker_defense_matrix_custom:GetBehavior()
local bonus = self.talents.has_auto == 1 and DOTA_ABILITY_BEHAVIOR_IMMEDIATE or 0
if self.talents.has_blink == 1 then
  bonus = bonus + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + bonus
end

function tinker_defense_matrix_custom:OnSpellStart()
local target = self:GetCaster()
local caster = self:GetCaster()

local duration = self.duration
if self.talents.has_legendary == 1 then
  duration = nil
end

target:RemoveModifierByName("modifier_tinker_defense_matrix_custom")
target:AddNewModifier(caster, self, "modifier_tinker_defense_matrix_custom", {duration = duration, auto = 0})
end

function tinker_defense_matrix_custom:ProcBlink(auto, attacker)
if not IsServer() then return end
if self.talents.has_blink == 0 then return end

local caster = self:GetCaster()
caster:Purge(false, true, false, false, false)

if not self:GetAutoCastState() or auto == 1 then return end

local old_point = caster:GetAbsOrigin()
local dir = caster:GetForwardVector()
if attacker then
  dir = (caster:GetAbsOrigin() - attacker:GetAbsOrigin()):Normalized()
end

local point = caster:GetAbsOrigin() + dir*self.talents.blink_range
caster:Teleport(point, true, "particles/puck/rift_blink_starta0.vpcf", "particles/items_fx/blink_dagger_end.vpcf", "Tinker.Matrix_blink")
end

function tinker_defense_matrix_custom:OnProjectileHit_ExtraData(target, vLocation, table)
if not target then return end
if table.damage <= 0 then return end
local caster = self:GetCaster()

local damage_table = {victim = target, attacker = caster, ability = self, damage = table.damage, damage_type = self.talents.stack_damage_type, custom_flag = CUSTOM_FLAG_TINKER_MATRIX}
local real_damage = DoDamage(damage_table, "modifier_tinker_matrix_3")
target:SendNumber(24, real_damage)
target:EmitSound("Tinker.Matrix_hit")
end



modifier_tinker_defense_matrix_custom = class({})
function modifier_tinker_defense_matrix_custom:IsHidden() return false end
function modifier_tinker_defense_matrix_custom:IsPurgable() return self.ability.talents.has_legendary == 0 end
function modifier_tinker_defense_matrix_custom:OnCreated(params)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.max_shield = self.ability.max_shield + self.ability.talents.shield_inc*self.parent:GetMaxHealth()
self.base_bva = self.parent:GetBaseAttackTime()

if self.parent:HasModifier("modifier_tinker_innate_custom_scepter") then
  local ability = self.parent:FindAbilityByName("tinker_innate_custom")
  if ability then
    self.max_shield = self.max_shield*(1 + ability:GetSpecialValueFor("scepter_matrix")/100)
  end
end

if not IsServer() then return end

local scepter_mod = self.parent:FindModifierByName("modifier_tinker_innate_custom_scepter")
if scepter_mod then
  scepter_mod:Proc()
end

self.RemoveForDuel = true
self:SetStackCount(self.max_shield)

if self.ability.talents.has_auto == 1 then
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_tinker_defense_matrix_custom_invun", {duration = self.ability.talents.invun_duration})
end

self.ability:ProcBlink(params.auto)

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_defense_matrix_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
ParticleManager:SetParticleControlEnt(particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_defense_matrix.vpcf", PATTACH_POINT_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(particle2, false, false, -1, false, false)

self.caster:EmitSound("Hero_Tinker.DefensiveMatrix.Cast")
self.parent:EmitSound("Hero_Tinker.DefensiveMatrix.Target")

self.damage_stack = 0
if self.ability.talents.has_stack == 1 then
  self.parent:AddDamageEvent_out(self, true)
  self.interval = 0.2
  self.damage_delay = 0
  self:OnIntervalThink()
  self:StartIntervalThink(self.interval)
end

end

function modifier_tinker_defense_matrix_custom:DamageEvent_out(params)
if not IsServer() then return end
if self.ability.talents.has_stack == 0 then return end
if self.parent ~= params.attacker then return end
if not params.unit:IsUnit() then return end
if params.custom_flag == CUSTOM_FLAG_TINKER_MATRIX then return end

local damage = params.damage*self.ability.talents.stack_damage
if params.unit:IsCreep() then
  damage = damage/self.ability.talents.stack_creeps
end

self.damage_stack = math.min(self.damage_stack + damage, self.ability.talents.stack_max)
self.damage_delay = self.ability.talents.stack_duration
end

function modifier_tinker_defense_matrix_custom:OnIntervalThink()
if not IsServer() then return end

if self.damage_delay > 0 then
  self.damage_delay = self.damage_delay - self.interval
  if self.damage_delay <= 0 then
    self.damage_stack = 0
  end
end

self.parent:UpdateUIshort({max_time = self.ability.talents.stack_max, time = self.damage_stack, stack = self.damage_stack, style = "TinkerMatrix"})
end

function modifier_tinker_defense_matrix_custom:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Hero_Tinker.DefensiveMatrix.Target")

if self.ability.talents.has_stack == 1 then
  self.parent:UpdateUIshort({hide = 1, style = "TinkerMatrix"})
  if self.damage_stack > 0 then
    if self.parent:IsAlive() then
      local heal = self.damage_stack*self.ability.talents.stack_heal  
      self.parent:GenericHeal(heal, self.ability, false, "", "modifier_tinker_matrix_3")
    end
    local info = 
    {
      EffectName = "particles/units/heroes/hero_tinker/tinker_shard_warp_flare.vpcf",
      Ability = self.ability,
      iMoveSpeed = 1500,
      Source = self.parent,
      bDodgeable = false,
      iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1, 
      ExtraData = {damage = self.damage_stack}
    }
    self.parent:EmitSound("Tinker.Matrix_launch")
    for _,target in pairs(self.parent:FindTargets(self.ability.talents.stack_radius)) do
      info.Target = target
      ProjectileManager:CreateTrackingProjectile(info)
    end
  end
end

end

function modifier_tinker_defense_matrix_custom:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
  MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
}
end

function modifier_tinker_defense_matrix_custom:GetModifierStatusResistanceStacking()
return self.ability.status_resistance + self.ability.talents.status_inc
end

function modifier_tinker_defense_matrix_custom:GetModifierMoveSpeedBonus_Constant()
return self.ability.talents.move_inc
end

function modifier_tinker_defense_matrix_custom:GetModifierDamageOutgoing_Percentage()
return self.ability.talents.damage_inc
end

function modifier_tinker_defense_matrix_custom:GetModifierSpellAmplify_Percentage()
return self.ability.talents.damage_inc
end

function modifier_tinker_defense_matrix_custom:GetModifierAttackRangeBonus()
return self.ability.talents.legendary_range
end

function modifier_tinker_defense_matrix_custom:GetModifierBaseAttackTimeConstant()
return self.base_bva + self.ability.talents.legendary_bva
end


function modifier_tinker_defense_matrix_custom:GetModifierIncomingDamageConstant(params)
if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_defense_matrix_pulse.vpcf", PATTACH_POINT_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

if players[params.attacker:GetId()] and not params.attacker:IsBuilding() and self.parent:GetQuest() == "Tinker.Quest_7" and not self.parent:QuestCompleted() then
  self.parent:UpdateQuest(damage)
end

if not self.parent:HasModifier("modifier_tinker_defense_matrix_custom_invun") then
  self:SetStackCount(self:GetStackCount() - damage)
  if self:GetStackCount() <= 0 then
    self.ability:ProcBlink(false, params.attacker)
    self:Destroy()
  end
else
  self.parent:EmitSound("Tinker.Matrix_invun")
  local forward = self.parent:GetAbsOrigin() - params.attacker:GetAbsOrigin()
  forward.z = 0
  forward = forward:Normalized()

  local particle_2 = ParticleManager:CreateParticle("particles/tinker/matrix_invun.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
  ParticleManager:SetParticleControlEnt(particle_2, 0, self.parent, PATTACH_POINT, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:SetParticleControl(particle_2, 1, self.parent:GetAbsOrigin())
  ParticleManager:SetParticleControlForward(particle_2, 1, forward)
  ParticleManager:SetParticleControlEnt(particle_2, 2, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), false)
  ParticleManager:ReleaseParticleIndex(particle_2)
end

return -damage
end


modifier_tinker_defense_matrix_custom_tracker = class(mod_hidden)
function modifier_tinker_defense_matrix_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.ability.duration = self.ability:GetSpecialValueFor("barrier_duration")
self.ability.status_resistance = self.ability:GetSpecialValueFor("status_resistance")
self.ability.max_shield = self.ability:GetSpecialValueFor("damage_absorb")

self.ability.talents =
{
  move_inc = 0,
  status_inc = 0,

  shield_inc = 0,

  damage_inc = 0,

  has_stack = 0,
  stack_damage = 0,
  stack_max = 0,
  stack_duration = self.parent:GetTalentValue("modifier_tinker_matrix_3", "duration", true),
  stack_radius = self.parent:GetTalentValue("modifier_tinker_matrix_3", "radius", true),
  stack_creeps = self.parent:GetTalentValue("modifier_tinker_matrix_3", "creeps", true),
  stack_damage_type = self.parent:GetTalentValue("modifier_tinker_matrix_3", "damage_type", true),
  stack_heal = self.parent:GetTalentValue("modifier_tinker_matrix_3", "heal", true)/100,

  has_auto = 0,
  invun_duration = self.parent:GetTalentValue("modifier_tinker_matrix_4", "invun", true),
  auto_health = self.parent:GetTalentValue("modifier_tinker_matrix_4", "health", true),
  auto_duration = self.parent:GetTalentValue("modifier_tinker_matrix_4", "duration", true),
  auto_cd = self.parent:GetTalentValue("modifier_tinker_matrix_4", "talent_cd", true),

  has_blink = 0,
  blink_range = self.parent:GetTalentValue("modifier_tinker_hero_7", "range", true),

  has_legendary = 0,
  legendary_range = 0,
  legendary_bva = 0,
  legendary_damage = 0,
  legendary_duration = self.parent:GetTalentValue("modifier_tinker_matrix_7", "duration", true),
  legendary_interval = self.parent:GetTalentValue("modifier_tinker_matrix_7", "interval", true),
  legendary_chance = self.parent:GetTalentValue("modifier_tinker_matrix_7", "chance", true),
  legendary_damage_type = self.parent:GetTalentValue("modifier_tinker_matrix_7", "damage_type", true),
  legendary_radius = self.parent:GetTalentValue("modifier_tinker_matrix_7", "radius", true),
  legendary_damage_reduce = self.parent:GetTalentValue("modifier_tinker_matrix_7", "damage_reduce", true),
}

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_tinker_defense_matrix_custom_tracker:OnRefresh()
self.ability.status_resistance = self.ability:GetSpecialValueFor("status_resistance")
self.ability.max_shield = self.ability:GetSpecialValueFor("damage_absorb")
end

function modifier_tinker_defense_matrix_custom_tracker:UpdateTalent(name)

if name == "modifier_tinker_hero_3" or self.parent:HasTalent("modifier_tinker_hero_3") then
  self.ability.talents.status_inc = self.parent:GetTalentValue("modifier_tinker_hero_3", "status")
  self.ability.talents.move_inc = self.parent:GetTalentValue("modifier_tinker_hero_3", "move")
end

if name == "modifier_tinker_matrix_1" or self.parent:HasTalent("modifier_tinker_matrix_1") then
  self.ability.talents.damage_inc = self.parent:GetTalentValue("modifier_tinker_matrix_1", "damage")
end

if name == "modifier_tinker_matrix_2" or self.parent:HasTalent("modifier_tinker_matrix_2") then
  self.ability.talents.shield_inc = self.parent:GetTalentValue("modifier_tinker_matrix_2", "shield")/100
end

if name == "modifier_tinker_matrix_3" or self.parent:HasTalent("modifier_tinker_matrix_3") then
  self.ability.talents.has_stack = 1
  self.ability.talents.stack_damage = self.parent:GetTalentValue("modifier_tinker_matrix_3", "damage")/100
  self.ability.talents.stack_max = self.parent:GetTalentValue("modifier_tinker_matrix_3", "max")
end

if name == "modifier_tinker_matrix_4" or self.parent:HasTalent("modifier_tinker_matrix_4") then
  self.ability.talents.has_auto = 1
  self.parent:AddDamageEvent_inc(self, true)
end

if name == "modifier_tinker_hero_7" or self.parent:HasTalent("modifier_tinker_hero_7") then
  self.ability.talents.has_blink = 1
end

if name == "modifier_tinker_matrix_7" or self.parent:HasTalent("modifier_tinker_matrix_7") then
  self.ability.talents.has_legendary = 1
  self.ability.talents.legendary_range = self.parent:GetTalentValue("modifier_tinker_matrix_7", "range")
  self.ability.talents.legendary_bva = self.parent:GetTalentValue("modifier_tinker_matrix_7", "bva")
  self.ability.talents.legendary_damage = (self.parent:GetTalentValue("modifier_tinker_matrix_7", "damage", true)/100)/self.ability.talents.legendary_duration
  self.parent:AddAttackStartEvent_out(self, true)
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_tinker_defense_matrix_custom_tracker:AddCustomTransmitterData() 
return self.ability.talents
end

function modifier_tinker_defense_matrix_custom_tracker:HandleCustomTransmitterData(data)
if not self.ability then return end
self.ability.talents = data
end



function modifier_tinker_defense_matrix_custom_tracker:AttackStartEvent_out(params)
if not IsServer() then return end
if self.ability.talents.has_legendary == 0 then return end
if not self.parent:HasModifier("modifier_tinker_defense_matrix_custom") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
if self.parent:HasModifier("modifier_tinker_defense_matrix_custom_legendary_laser") then return end
if not RollPseudoRandomPercentage(self.ability.talents.legendary_chance, 2932, self.parent) then return end

local target = params.target
self.parent:AddNewModifier(self.parent, self.ability, "modifier_tinker_defense_matrix_custom_legendary_laser", {target = target:entindex()})
end

function modifier_tinker_defense_matrix_custom_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if self.ability.talents.has_auto == 0 then return end
if params.damage <= 0 then return end
if self.parent ~= params.unit then return end
if self.parent:PassivesDisabled() then return end
if self.parent:GetHealthPercent() > self.ability.talents.auto_health then return end
if self.parent:HasModifier("modifier_death") then return end
if self.parent:HasModifier("modifier_tinker_defense_matrix_custom_shield_cd") then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_tinker_defense_matrix_custom_shield_cd", {duration = self.ability.talents.auto_cd})

self.parent:RemoveModifierByName("modifier_tinker_defense_matrix_custom")
self.parent:AddNewModifier(self.parent, self.ability, "modifier_tinker_defense_matrix_custom", {duration = self.ability.talents.auto_duration, auto = 1})
end



modifier_tinker_defense_matrix_custom_legendary_laser = class(mod_hidden)
function modifier_tinker_defense_matrix_custom_legendary_laser:OnCreated(params)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability.talents.legendary_radius
self.interval = self.ability.talents.legendary_interval
self.duration = self.ability.talents.legendary_duration
self.max = self.duration/self.interval

self.damage = self.ability.talents.legendary_damage*self.interval

if not IsServer() then return end
self.count = 0
self.target = EntIndexToHScript(params.target)

self:GiveVision()

local particle_name = self.parent:HasModifier("modifier_tinker_ti10_immortal_laser_custom") and "particles/tinker/matrix_legendary_red.vpcf" or "particles/tinker/matrix_legendary_laser.vpcf"
local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
ParticleManager:SetParticleControlEnt(particle, 9, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
self:AddParticle(particle, false, false, -1, false, false)

self.parent:EmitSound("Tinker.Matrix_legendary")
self.target:EmitSound("Tinker.Matrix_legendary2")
self.target:EmitSound("Tinker.Matrix_legendary_loop")

self.tareget_mod = self.target:AddNewModifier(self.parent, self.ability, "modifier_tinker_defense_matrix_custom_legendary_target", {duration = 5})

self.damageTable = { attacker = self.parent, ability = self.ability, damage_type = self.ability.talents.legendary_damage_type}
self:StartIntervalThink(self.interval)
end

function modifier_tinker_defense_matrix_custom_legendary_laser:OnIntervalThink()
if not IsServer() then return end
if not IsValid(self.target) or not self.target:IsAlive() then 
  self:Destroy()
  return 
end

local damage = self.damage*self.parent:GetAverageTrueAttackDamage(nil)
self.damageTable.damage = damage

for _,enemy in pairs(self.parent:FindTargets(self.radius, self.target:GetAbsOrigin())) do
  self.damageTable.victim = enemy

  local real_damage = DoDamage(self.damageTable, "modifier_tinker_matrix_7")
  if enemy == self.target then
    self.target:SendNumber(4, real_damage)
  end
end

self:GiveVision()
self.count = self.count + 1
if self.count >= self.max then
  self:Destroy()
  return
end

end

function modifier_tinker_defense_matrix_custom_legendary_laser:OnDestroy()
if not IsServer() then return end
self.target:StopSound("Tinker.Matrix_legendary_loop")

if IsValid(self.tareget_mod) then
  self.tareget_mod:Destroy()
end

end

function modifier_tinker_defense_matrix_custom_legendary_laser:GiveVision()
if not IsServer() then return end
AddFOWViewer(self.target:GetTeamNumber(), self.parent:GetAbsOrigin(), 10, self.interval, false)
AddFOWViewer(self.parent:GetTeamNumber(), self.target:GetAbsOrigin(), 10, self.interval, false)
end


modifier_tinker_defense_matrix_custom_invun = class(mod_hidden)

modifier_tinker_defense_matrix_custom_shield_cd = class(mod_cd)
function modifier_tinker_defense_matrix_custom_shield_cd:GetTexture() return "buffs/tinker/matrix_4" end



modifier_tinker_defense_matrix_custom_legendary_target = class(mod_hidden)
function modifier_tinker_defense_matrix_custom_legendary_target:OnCreated()
self.damage_reduce = self:GetAbility().talents.legendary_damage_reduce
end

function modifier_tinker_defense_matrix_custom_legendary_target:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_tinker_defense_matrix_custom_legendary_target:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_tinker_defense_matrix_custom_legendary_target:GetModifierSpellAmplify_Percentage()
return self.damage_reduce
end
