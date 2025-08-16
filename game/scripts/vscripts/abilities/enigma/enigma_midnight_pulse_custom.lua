LinkLuaModifier( "modifier_enigma_midnight_pulse_custom", "abilities/enigma/enigma_midnight_pulse_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_midnight_pulse_custom_tracker", "abilities/enigma/enigma_midnight_pulse_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_midnight_pulse_custom_debuff", "abilities/enigma/enigma_midnight_pulse_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_midnight_pulse_custom_can_channel", "abilities/enigma/enigma_midnight_pulse_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_midnight_pulse_custom_channel", "abilities/enigma/enigma_midnight_pulse_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_midnight_pulse_custom_channel_pull", "abilities/enigma/enigma_midnight_pulse_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_enigma_midnight_pulse_custom_caster", "abilities/enigma/enigma_midnight_pulse_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_midnight_pulse_custom_haste", "abilities/enigma/enigma_midnight_pulse_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_midnight_pulse_custom_fear", "abilities/enigma/enigma_midnight_pulse_custom", LUA_MODIFIER_MOTION_NONE )

enigma_midnight_pulse_custom = class({})

function enigma_midnight_pulse_custom:CreateTalent()
local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_enigma_midnight_pulse_custom_tracker")

if mod then
  mod.PercentStr = caster:GetTalentValue("modifier_enigma_midnight_5", "str")/100
end

end


function enigma_midnight_pulse_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/enigma/midnight_pulse.vpcf", context )
PrecacheResource( "particle", "particles/enigma/midnight_charge.vpcf", context )
PrecacheResource( "particle", "particles/enigma/malefice_pull_field.vpcf", context )
PrecacheResource( "particle", "particles/enigma/malefice_pull_caster.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf", context )
PrecacheResource( "particle", "particles/enigma/midnight_status.vpcf", context )
PrecacheResource( "particle", "particles/enigma/midnight_speed_aura.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", context )
PrecacheResource( "particle", "particles/enigma/midnight_speed.vpcf", context )
PrecacheResource( "particle", "particles/enigma/midnight_pull_target.vpcf", context )

end

function enigma_midnight_pulse_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_enigma_midnight_pulse_custom_tracker"
end

function enigma_midnight_pulse_custom:GetChannelAnimation()
return ACT_DOTA_CAST_ABILITY_4
end

function enigma_midnight_pulse_custom:GetCastAnimation()
local caster = self:GetCaster()
if caster:HasModifier("modifier_enigma_midnight_pulse_custom_can_channel") or caster:HasModifier("modifier_enigma_midnight_pulse_custom_channel") then
  return ACT_DOTA_CAST_ABILITY_4
end
return ACT_DOTA_MIDNIGHT_PULSE
end

function enigma_midnight_pulse_custom:GetChannelTime()
local caster = self:GetCaster()

if caster:HasModifier("modifier_enigma_midnight_pulse_custom_can_channel") or caster:HasModifier("modifier_enigma_midnight_pulse_custom_channel") then
  return caster:GetTalentValue("modifier_enigma_midnight_7", "duration")
end

end

function enigma_midnight_pulse_custom:GetBehavior()
local caster = self:GetCaster()
if caster:HasModifier("modifier_enigma_midnight_pulse_custom_can_channel") or caster:HasModifier("modifier_enigma_midnight_pulse_custom_channel") then
  return DOTA_ABILITY_BEHAVIOR_CHANNELLED + DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
if caster:HasTalent("modifier_enigma_midnight_7") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end

function enigma_midnight_pulse_custom:GetManaCost(level)
local caster = self:GetCaster()
if caster:HasModifier("modifier_enigma_midnight_pulse_custom_can_channel") or caster:HasModifier("modifier_enigma_midnight_pulse_custom_channel") then
  return 0
end
return self.BaseClass.GetManaCost(self,level) 
end


function enigma_midnight_pulse_custom:GetAOERadius()
return self:GetRadius()
end

function enigma_midnight_pulse_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_enigma_midnight_6") then
  bonus = self:GetCaster():GetTalentValue("modifier_enigma_midnight_6", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function enigma_midnight_pulse_custom:GetCastRange(vLocation, hTarget)
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function enigma_midnight_pulse_custom:GetCastPoint(iLevel)
return self.BaseClass.GetCastPoint(self)
end

function enigma_midnight_pulse_custom:GetRadius()
return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_enigma_midnight_3", "radius")
end

function enigma_midnight_pulse_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration")

local mod = caster:FindModifierByName("modifier_enigma_midnight_pulse_custom_can_channel")
if mod then

  local pulse_mod = caster:FindModifierByName("modifier_enigma_midnight_pulse_custom")
  if pulse_mod then
    pulse_mod:ClearStack()
  end
  caster:EmitSound("Enigma.Midnight_pull_voice")

  caster:AddNewModifier(caster, self, "modifier_enigma_midnight_pulse_custom_channel", {duration = self:GetChannelTime()})
  mod:Destroy()
  self:EndCd()
  return
end

if caster:HasTalent("modifier_enigma_midnight_6") then
  caster:AddNewModifier(caster, self, "modifier_enigma_midnight_pulse_custom_haste", {duration = caster:GetTalentValue("modifier_enigma_midnight_6", "duration")})
end

if caster:HasTalent("modifier_enigma_midnight_7") then
  caster:AddNewModifier(caster, self, "modifier_enigma_midnight_pulse_custom", {duration = duration})
else
  local point = self:GetCursorPosition()
  CreateModifierThinker(caster, self, "modifier_enigma_midnight_pulse_custom", {duration = duration}, point, caster:GetTeamNumber(), false)
end

self:EndCd()
end

function enigma_midnight_pulse_custom:OnChannelFinish()
local caster = self:GetCaster()

caster:RemoveModifierByName("modifier_enigma_midnight_pulse_custom_channel")
end





modifier_enigma_midnight_pulse_custom = class({})
function modifier_enigma_midnight_pulse_custom:IsHidden() return true end
function modifier_enigma_midnight_pulse_custom:IsPurgable() return false end
function modifier_enigma_midnight_pulse_custom:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetRadius()

if not IsServer() then return end

self.max_time = self:GetRemainingTime()

self.RemoveForDuel = true

self.legendary_count = 0
self.legendary_proc = false
self.ability.active_mod = self
self.targets = {}

self.legendary_timer = self.caster:GetTalentValue("modifier_enigma_midnight_7", "timer", true)

self.parent:EmitSound("Hero_Enigma.Midnight_Pulse")

if self.parent == self.caster then
  self.particle = ParticleManager:CreateParticle("particles/enigma/midnight_pulse.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  self.effect = self.parent:GenericParticle("particles/enigma/midnight_charge.vpcf", self, true)
  self:SetStackCount(0)
else
  self.particle = ParticleManager:CreateParticle("particles/enigma/midnight_pulse.vpcf", PATTACH_WORLDORIGIN, nil)
end

ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius, 0, 0))
self:AddParticle( self.particle, false, false, -1, false, false )

self.interval = 0.2

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_enigma_midnight_pulse_custom:OnIntervalThink()
if not IsServer() then return end

if (self.caster:HasTalent("modifier_enigma_midnight_5") or self.caster:HasTalent("modifier_enigma_midnight_6")) 
  and (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.radius then

  self.caster:AddNewModifier(self.caster, self.ability, "modifier_enigma_midnight_pulse_custom_caster", {duration = 0.5})
end

if not self.caster:HasTalent("modifier_enigma_midnight_7") then return end

local stack = self:GetStackCount()
if not self.effect then
  stack = nil
end
local active = 0
if self.caster:HasModifier("modifier_enigma_midnight_pulse_custom_can_channel") then
  active = 1
end

if not self.caster:HasModifier("modifier_enigma_midnight_pulse_custom_channel") then
  self.caster:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = stack, active = active, style = "EnigmaPulse"})
else
  self.caster:UpdateUIshort({hide = 1, hide_full = 2, style = "EnigmaPulse"})
end

if self.legendary_proc then return end

local targets = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_CLOSEST, false )
if #targets <= 0 then return end

self.legendary_count = self.legendary_count + self.interval

if self.legendary_count <= 0.99 then return end

self.legendary_count = 0
self:IncrementStackCount()



if self:GetStackCount() >= self.legendary_timer and self.legendary_proc == false then
  self.legendary_proc = true
  self.caster:AddNewModifier(self.caster, self.ability, "modifier_enigma_midnight_pulse_custom_can_channel", {duration = self:GetRemainingTime()})
end

end

function modifier_enigma_midnight_pulse_custom:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.effect then return end

for i = 1,self.legendary_timer do 
  if i <= self:GetStackCount() then 
    ParticleManager:SetParticleControl(self.effect, i, Vector(1, 0, 0)) 
  else 
    ParticleManager:SetParticleControl(self.effect, i, Vector(0, 0, 0)) 
  end
end

end

function modifier_enigma_midnight_pulse_custom:ClearStack()
if not IsServer() then return end
self:SetStackCount(0)
if self.effect then
  ParticleManager:DestroyParticle(self.effect, false)
  ParticleManager:ReleaseParticleIndex(self.effect)
  self.effect = nil
end
self:OnIntervalThink()
end


function modifier_enigma_midnight_pulse_custom:OnDestroy()
if not IsServer() then return end

if self.caster:HasTalent("modifier_enigma_midnight_7") then
  self.caster:UpdateUIshort({hide = 1, hide_full = 1, style = "EnigmaPulse"})
end

self.ability.active_mod = nil
self.ability:StartCd()

if not self.parent or self.parent:IsNull() then return end
--self.parent:StopSound("Hero_Enigma.Midnight_Pulse")
end



function modifier_enigma_midnight_pulse_custom:IsAura() return true end
function modifier_enigma_midnight_pulse_custom:GetAuraDuration() return 0.5 end
function modifier_enigma_midnight_pulse_custom:GetAuraRadius() return self.radius end
function modifier_enigma_midnight_pulse_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_enigma_midnight_pulse_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_enigma_midnight_pulse_custom:GetModifierAura() return "modifier_enigma_midnight_pulse_custom_debuff" end








modifier_enigma_midnight_pulse_custom_debuff = class({})
function modifier_enigma_midnight_pulse_custom_debuff:IsHidden() return false end
function modifier_enigma_midnight_pulse_custom_debuff:IsPurgable() return false end
function modifier_enigma_midnight_pulse_custom_debuff:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()
self.aura_owner = self:GetAuraOwner()

self.base_damage = self.ability:GetSpecialValueFor("base_damage") + self.caster:GetTalentValue("modifier_enigma_midnight_1", "damage")
self.health_damage = self.ability:GetSpecialValueFor("damage_percent")/100
self.damage_creeps = self.ability:GetSpecialValueFor("damage_creeps") + self.caster:GetTalentValue("modifier_enigma_midnight_1", "damage")
self.interval = self.ability:GetSpecialValueFor("tick_rate")

self.heal_reduce = self.caster:GetTalentValue("modifier_enigma_midnight_1", "heal_reduce")

self.attack_speed = self.caster:GetTalentValue("modifier_enigma_midnight_2", "slow")

self.damage_health = self.caster:GetTalentValue("modifier_enigma_midnight_4", "health", true)
self.damage_low = self.caster:GetTalentValue("modifier_enigma_midnight_4", "damage")
self.damage_low_creeps = self.caster:GetTalentValue("modifier_enigma_midnight_4", "creeps")

self.damage_fear = self.caster:GetTalentValue("modifier_enigma_midnight_4", "stun")

self.max_slow = self.caster:GetTalentValue("modifier_enigma_midnight_3", "slow")

self.legendary_max = self.caster:GetTalentValue("modifier_enigma_midnight_7", "damage_max", true)/100
self.legendary_min = self.caster:GetTalentValue("modifier_enigma_midnight_7", "damage_min", true)/100
self.distance_max = self.ability:GetRadius()
self.distance_min = self.caster:GetTalentValue("modifier_enigma_midnight_7", "range_min", true) 

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

if not IsServer() then return end

if self.caster:HasTalent("modifier_enigma_midnight_3") then
  self.parent:GenericParticle("particles/void_astral_slow.vpcf", self)
end

self:StartIntervalThink(self.interval)
end

function modifier_enigma_midnight_pulse_custom_debuff:OnIntervalThink()
if not IsServer() then return end
if not self.aura_owner or self.aura_owner:IsNull() then return end

local damage_k = 1

if self.caster:HasTalent("modifier_enigma_midnight_7") then
  local length = math.min(self.distance_max, math.max(self.distance_min, (self.parent:GetAbsOrigin() - self.aura_owner:GetAbsOrigin()):Length2D())) - self.distance_min
  damage_k = self.legendary_min + (self.legendary_max - self.legendary_min)*(1 - length/(self.distance_max - self.distance_min))
end

if self.caster:HasTalent("modifier_enigma_midnight_3") then
  local length = math.min(self.distance_max - self.distance_min,  (self.parent:GetAbsOrigin() - self.aura_owner:GetAbsOrigin()):Length2D())
  self:SetStackCount(self.max_slow*(length/(self.distance_max - self.distance_min)))
end

local damage = (self.parent:GetHealth()*self.health_damage + self.base_damage)*self.interval*damage_k
if self.parent:IsHero() then
  damage = (self.parent:GetHealth()*self.health_damage + self.base_damage)
else
  damage = self.damage_creeps
end
damage = damage*self.interval*damage_k

self.damageTable.damage = damage
DoDamage(self.damageTable)

if self.caster:HasTalent("modifier_enigma_midnight_4") and self.parent:GetHealthPercent() <= self.damage_health then
  local mod = self.aura_owner:FindModifierByName("modifier_enigma_midnight_pulse_custom")
  if mod and mod.targets and not mod.targets[self.parent:entindex()] then

    mod.targets[self.parent:entindex()] = true
    self.damageTable.damage = self.parent:GetMaxHealth()*self.damage_low/100

    if not self.parent:IsHero() then
      self.damageTable.damage = self.damage_low_creeps
    else
      if not self.parent:IsDebuffImmune() then
        self.parent:EmitSound("Enigma.Midnight_fear")
        self.parent:AddNewModifier(self.caster, self.ability, "modifier_enigma_midnight_pulse_custom_fear", {unit = self.aura_owner:entindex(), duration = (1 - self.parent:GetStatusResistance())*self.damage_fear})
      end
    end

    self.parent:GenericParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf")


    self.parent:EmitSound("Enigma.Midnight_fear_damage")
    local real_damage = DoDamage(self.damageTable, "modifier_enigma_midnight_4")
    self.parent:SendNumber(6, real_damage)
  end
end

end


function modifier_enigma_midnight_pulse_custom_debuff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end


function modifier_enigma_midnight_pulse_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if not self.caster:HasTalent("modifier_enigma_midnight_1") then return end
return self.heal_reduce
end

function modifier_enigma_midnight_pulse_custom_debuff:GetModifierHealAmplify_PercentageTarget()
if not self.caster:HasTalent("modifier_enigma_midnight_1") then return end
return self.heal_reduce
end

function modifier_enigma_midnight_pulse_custom_debuff:GetModifierHPRegenAmplify_Percentage() 
if not self.caster:HasTalent("modifier_enigma_midnight_1") then return end
return self.heal_reduce
end

function modifier_enigma_midnight_pulse_custom_debuff:GetModifierAttackSpeedBonus_Constant()
if not self.caster:HasTalent("modifier_enigma_midnight_2") then return end
return self.attack_speed
end

function modifier_enigma_midnight_pulse_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
if not self.caster:HasTalent("modifier_enigma_midnight_3") then return end
return self:GetStackCount()*-1
end



modifier_enigma_midnight_pulse_custom_tracker = class({})
function modifier_enigma_midnight_pulse_custom_tracker:IsHidden() return true end
function modifier_enigma_midnight_pulse_custom_tracker:IsPurgable() return false end
function modifier_enigma_midnight_pulse_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self:StartIntervalThink(1)
end

function modifier_enigma_midnight_pulse_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if (not self.ability.active_mod or self.ability.active_mod:IsNull()) and not self.ability:IsActivated() then
  self.ability:StartCd()
end

end


modifier_enigma_midnight_pulse_custom_can_channel = class({})
function modifier_enigma_midnight_pulse_custom_can_channel:IsHidden() return true end
function modifier_enigma_midnight_pulse_custom_can_channel:IsPurgable() return false end
function modifier_enigma_midnight_pulse_custom_can_channel:OnCreated()
self.ability = self:GetAbility()
if not IsServer() then return end
self.ability:SetActivated(true)
end




modifier_enigma_midnight_pulse_custom_channel = class({})
function modifier_enigma_midnight_pulse_custom_channel:IsHidden() return true end
function modifier_enigma_midnight_pulse_custom_channel:IsPurgable() return false end
function modifier_enigma_midnight_pulse_custom_channel:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetRadius()

if not IsServer() then return end

self.parent:EmitSound("Enigma.Midnight_pull_caster")
self.parent:EmitSound("Enigma.Midnight_pull_start")

self.parent:GenericParticle("particles/enigma/malefice_pull_caster.vpcf", self)

self.effect = ParticleManager:CreateParticle("particles/enigma/malefice_pull_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( self.effect, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl( self.effect, 1, Vector(self.radius, 0, 0) )
self:AddParticle( self.effect, false, false, -1, false, false )

self.mod = self.parent:FindModifierByName("modifier_enigma_midnight_pulse_custom")
if self.mod then
  self.mod_duration = self.mod:GetRemainingTime()
  self.mod:SetDuration(-1, true)
end

self.targets = {}
self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_enigma_midnight_pulse_custom_channel:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_enigma_midnight_pulse_custom_channel:GetModifierModelScale()
return 40
end

function modifier_enigma_midnight_pulse_custom_channel:OnIntervalThink()
if not IsServer() then return end

local targets = self.parent:FindTargets(self.radius)

for _,target in pairs(targets) do
  if not target:HasModifier("modifier_enigma_midnight_pulse_custom_channel_pull") and not target:IsDebuffImmune() then
    self.targets[target:entindex()] = true
    target:AddNewModifier(self.parent, self.ability, "modifier_enigma_midnight_pulse_custom_channel_pull", {duration = self:GetRemainingTime() + 0.1})
  end
end

end


function modifier_enigma_midnight_pulse_custom_channel:OnDestroy()
if not IsServer() then return end

self.parent:StopSound("Enigma.Midnight_pull_caster")

self.mod = self.parent:FindModifierByName("modifier_enigma_midnight_pulse_custom")
if self.mod and self.mod_duration then
  self.mod:SetDuration(self.mod_duration, true)
end


for index,_ in pairs(self.targets) do
  local unit = EntIndexToHScript(index)

  if unit and not unit:IsNull() then
    unit:RemoveModifierByName("modifier_enigma_midnight_pulse_custom_channel_pull")
  end
end

end

function modifier_enigma_midnight_pulse_custom_channel:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true
}
end





modifier_enigma_midnight_pulse_custom_channel_pull = class({})
function modifier_enigma_midnight_pulse_custom_channel_pull:IsHidden() return true end
function modifier_enigma_midnight_pulse_custom_channel_pull:IsPurgable() return false end
function modifier_enigma_midnight_pulse_custom_channel_pull:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.vec = self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()

self.max_duration = self.caster:GetTalentValue("modifier_enigma_midnight_7", "duration", true)
self.max_range = self.ability:GetRadius()
self.min_range = 120

self.speed = (self.max_range - self.min_range)/self.max_duration

self.min_point = self.caster:GetAbsOrigin() - self.vec:Normalized()*120

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/enigma/midnight_pull_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack"..RandomInt(1, 2), self.caster:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
self:AddParticle( self.particle, false, false, -1, false, false )

self.effect = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_black_hole_scepter_pull_debuff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.effect, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.effect, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
self:AddParticle( self.effect, false, false, -1, false, false )

if not self:ApplyHorizontalMotionController() then
  self:Destroy()
  return
end

end

function modifier_enigma_midnight_pulse_custom_channel_pull:OnDestroy()
if not IsServer() then return end
self.parent:RemoveHorizontalMotionController(self)
FindClearSpaceForUnit( self.parent, self.parent:GetOrigin(), false )
end

function modifier_enigma_midnight_pulse_custom_channel_pull:UpdateHorizontalMotion( me, dt )

if self.parent:IsDebuffImmune() then
  self:Destroy()
  return
end

if self.effect then
 -- ParticleManager:SetParticleControl( self.effect, 1, self.caster:GetOrigin()) 
end

local origin = me:GetOrigin()

if (origin - self.caster:GetAbsOrigin()):Length2D() <= self.min_range then
  return
end

local nextpos = origin + self.vec:Normalized() * self.speed * dt
me:SetOrigin(nextpos)
end

function modifier_enigma_midnight_pulse_custom_channel_pull:OnHorizontalMotionInterrupted()
self:Destroy()
end

function modifier_enigma_midnight_pulse_custom_channel_pull:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
}
end

function modifier_enigma_midnight_pulse_custom_channel_pull:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end

function modifier_enigma_midnight_pulse_custom_channel_pull:CheckState()
return
{
  [MODIFIER_STATE_ROOTED] = true
}
end

function modifier_enigma_midnight_pulse_custom_channel_pull:GetStatusEffectName()
return "particles/status_fx/status_effect_enigma_blackhole_tgt.vpcf"
end

function modifier_enigma_midnight_pulse_custom_channel_pull:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end



modifier_enigma_midnight_pulse_custom_caster = class({})
function modifier_enigma_midnight_pulse_custom_caster:IsHidden() return true end
function modifier_enigma_midnight_pulse_custom_caster:IsPurgable() return false end
function modifier_enigma_midnight_pulse_custom_caster:GetTexture() return "buffs/midnight_caster" end
function modifier_enigma_midnight_pulse_custom_caster:OnCreated()
self.parent = self:GetParent()

self.heal = self.parent:GetTalentValue("modifier_enigma_midnight_5", "heal", true)
self.status = self.parent:GetTalentValue("modifier_enigma_midnight_5", "status", true)

if not IsServer() then return end
if not self.parent:HasTalent("modifier_enigma_midnight_5") then return end

self.parent:GenericParticle("particles/enigma/midnight_status.vpcf", self)
end

function modifier_enigma_midnight_pulse_custom_caster:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_enigma_midnight_pulse_custom_caster:GetModifierStatusResistanceStacking()
if not self.parent:HasTalent("modifier_enigma_midnight_5") then return end
return self.status 
end

function modifier_enigma_midnight_pulse_custom_caster:GetModifierHealthRegenPercentage()
if not self.parent:HasTalent("modifier_enigma_midnight_5") then return end
return self.heal*(1 - self.parent:GetHealthPercent()/100)
end




modifier_enigma_midnight_pulse_custom_haste = class({})
function modifier_enigma_midnight_pulse_custom_haste:IsHidden() return false end
function modifier_enigma_midnight_pulse_custom_haste:IsPurgable() return false end
function modifier_enigma_midnight_pulse_custom_haste:GetTexture() return "buffs/midnight_haste" end
function modifier_enigma_midnight_pulse_custom_haste:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.silence = self.parent:GetTalentValue("modifier_enigma_midnight_6", "silence")
self.speed = self.parent:GetTalentValue("modifier_enigma_midnight_6", "speed")
self.radius = self.parent:GetTalentValue("modifier_enigma_midnight_6", "radius")

if not IsServer() then return end

self.parent:EmitSound("Enigma.Midnight_speed")

self.parent:GenericParticle("particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", self)
self.parent:GenericParticle("particles/enigma/midnight_speed.vpcf", self)

self.effect = ParticleManager:CreateParticle("particles/enigma/midnight_speed_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( self.effect, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl( self.effect, 1, Vector(self.radius, 0, 0) )
self:AddParticle( self.effect, false, false, -1, false, false )

self.targets = {}

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_enigma_midnight_pulse_custom_haste:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasModifier("modifier_enigma_midnight_pulse_custom_caster") then return end

for _,target in pairs(self.parent:FindTargets(self.radius)) do
  if not self.targets[target:entindex()] then
    self.targets[target:entindex()] = true
    target:EmitSound("Enigma.Midnight_silence")
    target:AddNewModifier(self.parent, self.ability, "modifier_generic_silence", {duration = (1 - target:GetStatusResistance())*self.silence})
  end
end

end

function modifier_enigma_midnight_pulse_custom_haste:CheckState()
return
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end

function modifier_enigma_midnight_pulse_custom_haste:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_enigma_midnight_pulse_custom_haste:GetActivityTranslationModifiers()
if not self.parent:HasModifier("modifier_enigma_midnight_pulse_custom_caster") then return end
return "haste"
end

function modifier_enigma_midnight_pulse_custom_haste:GetModifierMoveSpeed_Absolute()
if not self.parent:HasModifier("modifier_enigma_midnight_pulse_custom_caster") then return end
return self.speed
end





modifier_enigma_midnight_pulse_custom_fear = class({})
function modifier_enigma_midnight_pulse_custom_fear:IsPurgable() return false end
function modifier_enigma_midnight_pulse_custom_fear:IsPurgeException() return true end
function modifier_enigma_midnight_pulse_custom_fear:IsHidden() return true end

function modifier_enigma_midnight_pulse_custom_fear:OnCreated(data)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.speed = self.caster:GetTalentValue("modifier_enigma_midnight_4", "speed")

if not IsServer() then return end

self.unit = EntIndexToHScript(data.unit)

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_enigma_midnight_pulse_custom_fear:OnIntervalThink()
if not IsServer() then return end
if not self.unit or self.unit:IsNull() or not self.unit:IsAlive() or not self.unit:HasModifier("modifier_enigma_midnight_pulse_custom") then return end

self.position = GetGroundPosition(self.unit:GetAbsOrigin(), nil)
self.parent:MoveToPosition( self.position )
end

function modifier_enigma_midnight_pulse_custom_fear:GetEffectName() return "particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_debuff.vpcf" end
function modifier_enigma_midnight_pulse_custom_fear:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH  end
function modifier_enigma_midnight_pulse_custom_fear:GetStatusEffectName() return "particles/status_fx/status_effect_lone_druid_savage_roar.vpcf" end

function modifier_enigma_midnight_pulse_custom_fear:CheckState()
return 
{
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_FEARED] = true,
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_SILENCED] = true,
}
end

function modifier_enigma_midnight_pulse_custom_fear:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
}
end

function modifier_enigma_midnight_pulse_custom_fear:GetModifierMoveSpeed_Absolute()
return self.speed
end

function modifier_enigma_midnight_pulse_custom_fear:OnDestroy()
if not IsServer() then return end
self.parent:Stop()
end
