LinkLuaModifier( "modifier_bane_nightmare_custom", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_tracker", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_legendary", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_legendary_illusion", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_legendary_end", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_legendary_end_effect", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_legendary_damage", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_slow", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_silence", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_speed", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_attack", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_nightmare_custom_invun", "abilities/bane/bane_nightmare_custom", LUA_MODIFIER_MOTION_NONE )


bane_nightmare_custom = class({})
bane_nightmare_custom.talents = {}
bane_nightmare_custom.friend_mod = nil
bane_nightmare_custom.current_mod = nil

function bane_nightmare_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_bane/bane_nightmare.vpcf", context )
PrecacheResource( "particle", "particles/bane/nightmare_legendary_screen.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_riki/riki_shard_sleep.vpcf", context )
PrecacheResource( "particle", "particles/terrorblade/image_blink.vpcf", context )
PrecacheResource( "particle", "particles/bane/nightmare_legendary_soul.vpcf", context )
PrecacheResource( "particle", "particles/bane/nightmare_legendary_link.vpcf", context )
PrecacheResource( "particle", "particles/bane/nightmare_legendary_end.vpcf", context )
PrecacheResource( "particle", "particles/bane/nightmare_legendary_end_soul.vpcf", context )
PrecacheResource( "particle", "particles/bane/nightmare_legendary_silence.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/soul_keeper.vpcf", context )
PrecacheResource( "particle", "particles/bane/nightmare_legendary_damage.vpcf", context )
PrecacheResource( "particle", "particles/bane/nightmare_legendary_damage_start.vpcf", context )
PrecacheResource( "particle", "particles/void_buf2.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_perma.vpcf", context )

end

function bane_nightmare_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_bane_immortal_shoulder") then
    return "bane/slumbering_terror/bane_nightmare"
end
return "bane_nightmare"
end

function bane_nightmare_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_bane_nightmare_custom_tracker"
end

function bane_nightmare_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level ) + self.talents.cd_inc
end

function bane_nightmare_custom:GetCastRange(vLocation, hTarget)
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function bane_nightmare_custom:GetBehavior()
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function bane_nightmare_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level) 
end

function bane_nightmare_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasShard() then
  bonus = self.talents.shard_cast
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function bane_nightmare_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end

self:ApplyEffect(target)
end

function bane_nightmare_custom:OnProjectileHit(target, location)
if not target then return end

local caster = self:GetCaster()
caster:AddNewModifier(caster, self, "modifier_bane_nightmare_custom_attack", {duration = FrameTime()})
caster:PerformAttack(target, true, true, true, true, false, false, true)
caster:RemoveModifierByName("modifier_bane_nightmare_custom_attack")
end

function bane_nightmare_custom:ApplyEffect(target, from_attack)
if not IsServer() then return end
local caster = self:GetCaster()
caster:EmitSound("Hero_Bane.Nightmare")

local attack = 0
if from_attack then
  attack = 1
end

local duration = self:GetSpecialValueFor("duration")
if target:GetTeamNumber() ~= caster:GetTeamNumber() then
  duration = duration*(1 - target:GetStatusResistance())
end
self.current_mod = target:AddNewModifier(caster, self, "modifier_bane_nightmare_custom", {duration = duration, from_attack = attack})
end


modifier_bane_nightmare_custom = class({})
function modifier_bane_nightmare_custom:IsHidden() return false end
function modifier_bane_nightmare_custom:IsPurgable() return true end
function modifier_bane_nightmare_custom:IsStunDebuff() return true end
function modifier_bane_nightmare_custom:IsDebuff() return true end
function modifier_bane_nightmare_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()
self.is_friend = self.caster:GetTeamNumber() == self.parent:GetTeamNumber()

self.rate = 0.2
self.max = self.ability:GetSpecialValueFor("max_damage") + self.ability.talents.health_inc*self.parent:GetMaxHealth()
self.invun = self.ability:GetSpecialValueFor("nightmare_invuln_time")
self.max_time = self:GetRemainingTime()

self.regen = 0
if self.is_friend and self.ability.talents.has_heal == 1 then
  self.regen = self.ability.talents.heal_regen
end

if not IsServer() then return end

if self.caster:HasShard() then
  self.invun = self.invun + self.ability.talents.shard_invun
end

if self.is_friend then
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_bane_nightmare_custom_invun", {duration = self.invun})
end

self.from_attack = table.from_attack

self.ability:EndCd()
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_FLAIL, self.rate)

if not self.is_friend then
  self:SetStackCount(self.max)
else
  self.ability.friend_mod = self
  local ability = self.caster:FindAbilityByName("bane_nightmare_end_custom")
  if ability and ability:IsHidden() then
    self.caster:SwapAbilities(self.ability:GetName(), ability:GetName(), false, true)
  end
end

self.parent:EmitSound("Hero_Bane.Nightmare.Loop")
local effect_name = "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
if self.caster:HasModifier("modifier_bane_immortal_shoulder") then
    effect_name = "particles/econ/items/bane/slumbering_terror/bane_slumber_nightmare.vpcf"
end
self.parent:GenericParticle(effect_name, self)
self.interval = 0.1

self.attack_count = 0
self.attack_max = self.ability.talents.auto_attacks
self.attack_range = self.ability.talents.auto_radius
self.attack_interval = self:GetRemainingTime()/(self.attack_max + 1)
self.attacks_made = 0

self.parent:AddDamageEvent_inc(self)
self.parent:AddAttackRecordEvent_inc(self, true)

self:StartIntervalThink(self.interval)
end

function modifier_bane_nightmare_custom:OnIntervalThink()
if not IsServer() then return end

if self.ability.talents.has_auto == 1 and self.attacks_made < self.attack_max then
  self.attack_count = self.attack_count + self.interval

  if self.attack_count >= self.attack_interval - 0.05 then
    self.attack_count = 0
    self.attacks_made = self.attacks_made + 1
    local projectile =
    {
      Source = self.caster,
      Ability = self.ability,
      EffectName = "particles/units/heroes/hero_bane/bane_projectile.vpcf",
      iMoveSpeed = self.caster:GetProjectileSpeed(),
      vSourceLoc = self.caster:GetAbsOrigin(),
      bDodgeable = true,
      bProvidesVision = false,
    }
    if self.is_friend then
      local targets = self.parent:FindTargets(self.attack_range)
      if #targets > 0 and self.caster == self.parent then
        self.caster:EmitSound("Hero_Bane.Attack")
        for _,target in pairs(targets) do
          projectile.Target = target
          local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )
        end
      end
    elseif (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.attack_range and self.caster:IsAlive() then
      self.caster:EmitSound("Hero_Bane.Attack")
      projectile.Target = self.parent
      local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )
    end
  end
end

if self.is_friend then return end

AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), 10, self.interval*2, false)
self.caster:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = self:GetStackCount(), style = "BaneNightmare"})
end


function modifier_bane_nightmare_custom:CheckState()
local state =
{
  [MODIFIER_STATE_NIGHTMARED] = true
}

if self.is_friend and self.caster:HasShard() then
  state[MODIFIER_STATE_SILENCED] = true
  state[MODIFIER_STATE_DISARMED] = true
  state[MODIFIER_STATE_MUTED] = true
else
  state[MODIFIER_STATE_STUNNED] = true
end

return state
end


function modifier_bane_nightmare_custom:OnDestroy()
if not IsServer() then return end

self.parent:Stop()
FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)
self.parent:RemoveModifierByName("modifier_bane_nightmare_custom_move")

if not self.new_sleep then
  self.ability.current_mod = nil
  self.ability:StartCd()

  if self.caster:HasShard() and (self.is_friend or self.from_attack == 1) then
    self.caster:CdAbility(self.ability, self.ability:GetCooldownTimeRemaining()*self.ability.talents.shard_cd)
  end
end

if self.ability.talents.has_silence == 1 and not self.is_friend then
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_bane_nightmare_custom_silence", {duration = (1 - self.parent:GetStatusResistance())*self.ability.talents.silence_duration})
end

if not self.is_friend then
  self.caster:UpdateUIshort({hide = 1, hide_full = 1, style = "BaneNightmare"})
else
  self.ability.friend_mod = nil
  local ability = self.caster:FindAbilityByName("bane_nightmare_end_custom")
  if ability and not ability:IsHidden() then
    self.caster:SwapAbilities(self.ability:GetName(), ability:GetName(), true, false)
  end
end

self.parent:FadeGesture(ACT_DOTA_FLAIL)
self.parent:StopSound("Hero_Bane.Nightmare.Loop")
self.parent:EmitSound("Hero_Bane.Nightmare.End")
end


function modifier_bane_nightmare_custom:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if params.damage <= 0 then return end

if params.inflictor and params.inflictor:GetName() == "bane_enfeeble_custom" then return end
if params.attacker:HasModifier("modifier_bane_nightmare_custom_attack") then return end

if self.is_friend then
  self:Destroy()
  return
end

local stack = self:GetStackCount()
local end_stack = stack - params.damage

if end_stack <= 0 then
  self:SetStackCount(0)
  self:Destroy()
else
  self:SetStackCount(end_stack)
end

end

function modifier_bane_nightmare_custom:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_FIXED_DAY_VISION,
  MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
  MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
}
end

function modifier_bane_nightmare_custom:GetModifierHealthRegenPercentage()
return self.regen
end

function modifier_bane_nightmare_custom:GetFixedDayVision()
if self.is_friend then return end
return 0
end

function modifier_bane_nightmare_custom:GetFixedNightVision()
if self.is_friend then return end
return 0
end

function modifier_bane_nightmare_custom:GetBonusVisionPercentage() 
if self.is_friend then return end
return -100  
end

function modifier_bane_nightmare_custom:GetStatusEffectName()
return "particles/status_fx/status_effect_nightmare.vpcf"
end

function modifier_bane_nightmare_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_bane_nightmare_custom:AttackRecordEvent_inc(params)
if not IsServer() then return end
if not params.attacker:IsUnit() then return end
if self.parent ~= params.target then return end

local attacker = params.attacker

if self.ability.talents.has_speed == 1 and attacker == self.caster then
  attacker:AddNewModifier(attacker, self.ability, "modifier_bane_nightmare_custom_speed", {duration = self.ability.talents.speed_duration})
end

if not self.is_friend then return end

self.new_sleep = true
self.ability:ApplyEffect(params.attacker, true)
self:Destroy()
end




modifier_bane_nightmare_custom_tracker = class(mod_hidden)
function modifier_bane_nightmare_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.legendary_ability = self.parent:FindAbilityByName("bane_nightmare_custom_legendary")

self.ability.talents =
{
  shard_cast = self.ability:GetSpecialValueFor("shard_cast"),
  shard_invun = self.ability:GetSpecialValueFor("shard_invun"),
  shard_cd = self.ability:GetSpecialValueFor("shard_cd")/100,

  cd_inc = 0,
  health_inc = 0,

  range_bonus = 0,
  move_slow = 0,

  attack_speed = 0,
  has_speed = 0,
  speed_duration = self.parent:GetTalentValue("modifier_bane_nightmare_2", "duration", true),

  has_auto = 0,
  auto_radius = self.parent:GetTalentValue("modifier_bane_nightmare_3", "radius", true),
  auto_attacks = self.parent:GetTalentValue("modifier_bane_nightmare_3", "attacks", true),
  auto_damage = 0,

  has_silence = 0,
  magic_inc = 0,
  silence_duration = self.parent:GetTalentValue("modifier_bane_hero_7", "silence", true),
  silence_slow = self.parent:GetTalentValue("modifier_bane_hero_7", "slow", true),

  has_heal = 0,
  status_bonus = 0,
  heal_regen = self.parent:GetTalentValue("modifier_bane_nightmare_4", "regen", true),

  has_legendary = 0,
  legendary_cd = self.parent:GetTalentValue("modifier_bane_nightmare_7", "talent_cd", true),
  legendary_duration = self.parent:GetTalentValue("modifier_bane_nightmare_7", "duration", true),
  legendary_effect_duration = self.parent:GetTalentValue("modifier_bane_nightmare_7", "effect_duration", true),
  legendary_damage = self.parent:GetTalentValue("modifier_bane_nightmare_7", "damage", true),
  legendary_silence = self.parent:GetTalentValue("modifier_bane_nightmare_7", "silence", true),
}

self.speed_bonus = self.parent:GetTalentValue("modifier_bane_nightmare_2", "bonus", true)
self.heal_bonus = self.parent:GetTalentValue("modifier_bane_nightmare_4", "bonus", true)
self.heal_creeps = self.parent:GetTalentValue("modifier_bane_nightmare_4", "creeps", true)
self.heal_damage = self.parent:GetTalentValue("modifier_bane_nightmare_4", "heal", true)/100

self.has_slow = false
self.slow_duration = self.parent:GetTalentValue("modifier_bane_nightmare_1", "duration", true)

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
self:StartIntervalThink(3)
end

function modifier_bane_nightmare_custom_tracker:UpdateTalent(name)

if name == "modifier_bane_hero_3" or self.parent:HasTalent("modifier_bane_hero_3") then
  self.ability.talents.cd_inc = self.parent:GetTalentValue("modifier_bane_hero_3", "cd")
  self.ability.talents.health_inc = self.parent:GetTalentValue("modifier_bane_hero_3", "health")/100
end

if name == "modifier_bane_hero_7" or self.parent:HasTalent("modifier_bane_hero_7") then
  self.ability.talents.has_silence = 1
  self.ability.talents.magic_inc = self.parent:GetTalentValue("modifier_bane_hero_7", "magic")
end

if name == "modifier_bane_nightmare_1" or self.parent:HasTalent("modifier_bane_nightmare_1") then
  self.has_slow = true
  self.ability.talents.range_bonus = self.parent:GetTalentValue("modifier_bane_nightmare_1", "range")
  self.ability.talents.move_slow = self.parent:GetTalentValue("modifier_bane_nightmare_1", "slow")
  self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_bane_nightmare_2" or self.parent:HasTalent("modifier_bane_nightmare_2") then
  self.ability.talents.attack_speed = self.parent:GetTalentValue("modifier_bane_nightmare_2", "speed")
  self.ability.talents.has_speed = 1
end

if name == "modifier_bane_nightmare_3" or self.parent:HasTalent("modifier_bane_nightmare_3") then
  self.ability.talents.auto_damage = self.parent:GetTalentValue("modifier_bane_nightmare_3", "damage")
  self.ability.talents.has_auto = 1

  self.PercentAgi = self.parent:GetTalentValue("modifier_bane_nightmare_3", "stats")/100
  self.PercentInt = self.PercentAgi
  self.PercentStr = self.PercentAgi
end

if name == "modifier_bane_nightmare_4" or self.parent:HasTalent("modifier_bane_nightmare_4") then
  self.ability.talents.has_heal = 1
  self.ability.talents.status_bonus = self.parent:GetTalentValue("modifier_bane_nightmare_4", "status")
  self.parent:AddDamageEvent_out(self, true)
end

if name == "modifier_bane_nightmare_7" or self.parent:HasTalent("modifier_bane_nightmare_7") then
  self.ability.talents.has_legendary = 1
  self.legendary_ability.talents.legendary_cd = self.ability.talents.legendary_cd
  self.legendary_ability.talents.legendary_duration = self.ability.talents.legendary_duration
  self.legendary_ability.talents.legendary_effect_duration = self.ability.talents.legendary_effect_duration
  self.legendary_ability.talents.legendary_damage = self.ability.talents.legendary_damage
  self.legendary_ability.talents.legendary_silence = self.ability.talents.legendary_silence
  self.parent:AddAttackEvent_out(self, true)
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_bane_nightmare_custom_tracker:AddCustomTransmitterData() 
return self.ability.talents
end

function modifier_bane_nightmare_custom_tracker:HandleCustomTransmitterData(data)
if self.ability then 
  self.ability.talents = data
end

if self.legendary_ability then
  self.legendary_ability.talents.legendary_cd = data.legendary_cd
  self.legendary_ability.talents.legendary_damage = data.legendary_damage
end

end

function modifier_bane_nightmare_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not self.ability:IsActivated() and (not self.ability.current_mod or self.ability.current_mod:IsNull()) then
  self.ability:StartCd()
end

if self.ability.talents.has_legendary == 1 and self.legendary_ability then
  if not self.legendary_ability:IsActivated() and not self.parent:HasModifier("modifier_bane_nightmare_custom_legendary") then
    self.legendary_ability:StartCd()
  end
end

end

function modifier_bane_nightmare_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_bane_nightmare_custom_tracker:GetModifierAttackRangeBonus()
return self.ability.talents.range_bonus
end

function modifier_bane_nightmare_custom_tracker:GetModifierAttackSpeedBonus_Constant()
return self.parent:HasModifier("modifier_bane_nightmare_custom_speed") and self.ability.talents.attack_speed*self.speed_bonus or self.ability.talents.attack_speed
end

function modifier_bane_nightmare_custom_tracker:GetModifierMagicalResistanceBonus() 
return self.ability.talents.magic_inc
end

function modifier_bane_nightmare_custom_tracker:GetModifierStatusResistanceStacking() 
return self.ability.talents.status_bonus
end

function modifier_bane_nightmare_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
local target = params.target

local mod = target:FindModifierByName("modifier_bane_nightmare_custom_legendary_damage")
if mod and mod:GetStackCount() == 0 then
  target:EmitSound("Bane.Nightmare_legendary_damage_attack")
end

if self.has_slow then
  target:AddNewModifier(self.parent, self.ability, "modifier_bane_nightmare_custom_slow", {duration = self.slow_duration})
end

end

function modifier_bane_nightmare_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if self.ability.talents.has_heal == 0 then return end
if not self.parent:CheckLifesteal(params) then return end

local mod = params.unit:FindModifierByName("modifier_bane_nightmare_custom")

local heal = params.damage*self.heal_damage
if mod then
  heal = heal*self.heal_bonus
end
if params.unit:IsCreep() then
  heal = heal/self.heal_creeps
end

self.parent:GenericHeal(heal, self.ability, true, "particles/items3_fx/octarine_core_lifesteal.vpcf", "modifier_bane_nightmare_4")
end





bane_nightmare_end_custom = class({})

function bane_nightmare_end_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_bane_immortal_shoulder") then
    return "bane/slumbering_terror/bane_nightmare_end"
end
return "bane_nightmare_end"
end

function bane_nightmare_end_custom:OnSpellStart()
local caster = self:GetCaster()
local ability = caster:FindAbilityByName("bane_nightmare_custom")
if not ability then return end

local mod = ability.friend_mod
if mod and not mod:IsNull() then
  mod:Destroy()
  return
end

end




bane_nightmare_custom_legendary = class({})
bane_nightmare_custom_legendary.talents = {}

function bane_nightmare_custom_legendary:CreateTalent()
self:SetHidden(false)
end

function bane_nightmare_custom_legendary:GetCooldown()
return self.talents.legendary_cd
end

function bane_nightmare_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
local start_duration = self:GetSpecialValueFor("start_duration")
local duration = self.talents.legendary_duration + start_duration

target:RemoveModifierByName("modifier_bane_nightmare_custom_legendary_damage")
target:AddNewModifier(caster, self, "modifier_bane_nightmare_custom_legendary_damage", {duration = duration + 1})
target:AddNewModifier(caster, self, "modifier_bane_nightmare_custom_legendary", {duration = duration, enemy = caster:entindex()})
caster:AddNewModifier(caster, self, "modifier_bane_nightmare_custom_legendary", {duration = duration, enemy = target:entindex()})
end


modifier_bane_nightmare_custom_legendary = class(mod_visible)
function modifier_bane_nightmare_custom_legendary:IsDebuff() return true end
function modifier_bane_nightmare_custom_legendary:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.is_enemy = self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber()
self.start_duration = self.ability:GetSpecialValueFor("start_duration")
self.end_duration = self.ability:GetSpecialValueFor("end_duration")

if not IsServer() then return end
self.RemoveForDuel = true

self.parent:AddDamageEvent_inc(self)

self.parent:EmitSound("Bane.Nightmare_legendary_start")
self.parent:EmitSound("Bane.Nightmare_legendary_start2")
self.parent:EmitSound("Bane.Nightmare_legendary_loop")

ProjectileManager:ProjectileDodge(self.parent)
self.enemy = EntIndexToHScript(table.enemy)
self.health = self.parent:GetHealthPercent()/100
self.mana = self.parent:GetManaPercent()/100

self.parent:SetHealth(self.parent:GetMaxHealth())
self.parent:SetMana(self.parent:GetMaxMana())
self.parent:Purge(true, true, false, true, true)

if self.is_enemy then
  self.parent:GenericParticle("particles/bane/nightmare_legendary_silence.vpcf", self, true)
else
  self.ability:EndCd()
end

self.particle = ParticleManager:CreateParticle("particles/bane/nightmare_legendary_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

self.particle = ParticleManager:CreateParticleForPlayer("particles/bane/nightmare_legendary_screen.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()))
self:AddParticle(self.particle, false, false, -1, false, false)

local duration = self:GetRemainingTime() + 5
self.point = self.parent:GetAbsOrigin()
self.illusion = nil

local illusions = CreateIllusions( self.parent, self.parent, {duration = duration, outgoing_damage = -100 ,incoming_damage = 0}, 1, 1, false, true )
for _,illusion in pairs(illusions) do
  self.illusion = illusion
  illusion:Stop()

  illusion:AddNewModifier(self.parent, nil, "modifier_chaos_knight_phantasm_illusion", {})
  illusion:AddNewModifier(self.parent, nil, "modifier_bane_nightmare_custom_legendary_illusion", {} )

  illusion:SetAbsOrigin(self.point)
  FindClearSpaceForUnit(illusion, self.point, true)

  illusion.owner = self.parent

  for _,mod in pairs(self.parent:FindAllModifiers()) do
    if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
        illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
    end
  end
end

local center = self.parent:GetAbsOrigin() + RandomVector(10)

local knockbackProperties =
{
  center_x = center.x,
  center_y = center.y,
  center_z = center.z,
  duration = self.start_duration,
  knockback_duration = self.start_duration,
  knockback_distance = 180,
  knockback_height = 80
}
self.parent:AddNewModifier( self.parent, self.ability, "modifier_knockback", knockbackProperties )

self.laugh_count = 1
self.laugh_max = 1.5
self.interval = 0.05

self:StartIntervalThink(self.interval)
end



function modifier_bane_nightmare_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.laugh_count = self.laugh_count + self.interval
if self.laugh_count >= self.laugh_max then
  self.laugh_count = 0
  EmitAnnouncerSoundForPlayer("Bane.Nightmare_legendary_laugh", self.parent:GetPlayerOwnerID())
end

if not self.enemy or self.enemy:IsNull() or not self.enemy:IsAlive() or not self.enemy:HasModifier(self:GetName()) then
  self:Destroy()
  return
end

end


function modifier_bane_nightmare_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MIN_HEALTH,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_ABSORB_SPELL,
}
end

function modifier_bane_nightmare_custom_legendary:NoDamage(params)
if not params.attacker then return 0 end
if not self.enemy or self.enemy:IsNull() then return 0 end
local attacker = params.attacker
if attacker.owner then
  attacker = attacker.owner
end
if attacker == self.enemy then return 0 end
if attacker == self.parent then return 0 end
return 1
end

function modifier_bane_nightmare_custom_legendary:GetMinHealth()
if self.parent:HasModifier("modifier_death") then return end
return 3
end

function modifier_bane_nightmare_custom_legendary:GetModifierTotalDamageOutgoing_Percentage(params)
if not params.target then return 0 end
if not self.enemy or self.enemy:IsNull() then return 0 end
local target = params.target
if target.owner then
  target = target.owner
end
if target == self.enemy then return 0 end
if target == self.parent then return 0 end
return -150
end

function modifier_bane_nightmare_custom_legendary:GetAbsorbSpell(params)
if not IsServer() then return end
if not params.ability:GetCaster() then return  end
if not self.enemy or self.enemy:IsNull() then return end
local unit = params.ability:GetCaster()
if unit.owner then
  unit = unit.owner
end
if unit == self.enemy then return end
if unit == self.parent then return end
return 1
end

function modifier_bane_nightmare_custom_legendary:GetAbsoluteNoDamagePhysical(params)
return self:NoDamage(params)
end

function modifier_bane_nightmare_custom_legendary:GetAbsoluteNoDamageMagical(params)
return self:NoDamage(params)
end

function modifier_bane_nightmare_custom_legendary:GetAbsoluteNoDamagePure(params)
return self:NoDamage(params)
end

function modifier_bane_nightmare_custom_legendary:CheckHealth()
if not IsServer() then return end
if self.is_enemy then return end
if not self.enemy or self.enemy:IsNull() then return end
if self.enemy:GetHealthPercent() > self.parent:GetHealthPercent() then return end
if self.enemy:GetHealthPercent() == self.parent:GetHealthPercent() and self.enemy:GetHealth() > self.parent:GetHealth() then return end

return true
end


function modifier_bane_nightmare_custom_legendary:DamageEvent_inc(params)
if not IsServer() then return end
if params.unit ~= self.parent then return end
if self.parent:GetHealth() > 4 then return end

self:Destroy()
end


function modifier_bane_nightmare_custom_legendary:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Bane.Nightmare_legendary_loop")

if not self.is_enemy then
  self.ability:StartCd()
end

if not self.illusion or self.illusion:IsNull() then return end

local mod = nil
local duration = self.end_duration
local active = 0

if self.parent:IsAlive() and self.parent:GetHealth() > 0 then

  local health = self.health
  local mana = self.mana

  if not self.is_enemy and self:CheckHealth() then
    active = 1
  end

  self.parent:EmitSound("Bane.Nightmare_legendary_end")
  self.parent:EmitSound("Bane.Nightmare_legendary_end2")

  mod = self.parent:AddNewModifier(self.caster, self.ability, "modifier_bane_nightmare_custom_legendary_end", {illusion = self.illusion:entindex(), duration = duration, mana = mana, health = health, active = active})
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_nightmare_custom_legendary_end_effect", {duration = duration + 0.1})

  self.parent:Purge(false, true, false, true, true)
end

if not mod then
  self.illusion:AddNoDraw()
  self.illusion:Kill(nil, nil)
end

if not self.enemy or self.enemy:IsNull() then return end

local damage_mod = self.enemy:FindModifierByName("modifier_bane_nightmare_custom_legendary_damage")
if not damage_mod then return end

if active == 1 then
  damage_mod:SetActive()
else
  damage_mod:Destroy()
end

end


function modifier_bane_nightmare_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_nightmare.vpcf"
end

function modifier_bane_nightmare_custom_legendary:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA
end

function modifier_bane_nightmare_custom_legendary:CheckState()
local state =
{
  [MODIFIER_STATE_NIGHTMARED] = true,
}
if self.is_enemy then
  state[MODIFIER_STATE_SILENCED] = true
end

if self:GetElapsedTime() <= self.start_duration then
  state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
  state[MODIFIER_STATE_STUNNED] = true
  state[MODIFIER_STATE_NO_HEALTH_BAR] = true
  state[MODIFIER_STATE_INVULNERABLE] = true
  state[MODIFIER_STATE_OUT_OF_GAME] = true
end

return state
end






modifier_bane_nightmare_custom_legendary_illusion = class(mod_hidden)
function modifier_bane_nightmare_custom_legendary_illusion:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.parent:GenericParticle("particles/units/heroes/hero_riki/riki_shard_sleep.vpcf", self, true)
self.parent:GenericParticle("particles/units/heroes/hero_bane/bane_nightmare.vpcf", self)

self.particle = ParticleManager:CreateParticle("particles/bane/nightmare_legendary_link.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

self.parent:StartGesture(ACT_DOTA_DISABLED)
end

function modifier_bane_nightmare_custom_legendary_illusion:CheckState()
return
{
  [MODIFIER_STATE_NIGHTMARED] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
}

end

function modifier_bane_nightmare_custom_legendary_illusion:GetStatusEffectName()
return "particles/status_fx/status_effect_nightmare.vpcf"
end

function modifier_bane_nightmare_custom_legendary_illusion:StatusEffectPriority()
return MODIFIER_PRIORITY_ILLUSION
end

function modifier_bane_nightmare_custom_legendary_illusion:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_bane_nightmare_custom_legendary_illusion:GetActivityTranslationModifiers()
return ACT_DOTA_DISABLED
end

function modifier_bane_nightmare_custom_legendary_illusion:GetModifierModelScale()
return 15
end





modifier_bane_nightmare_custom_legendary_end = class(mod_hidden)
function modifier_bane_nightmare_custom_legendary_end:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.caster = self:GetCaster()
if not IsServer() then return end

self.parent:AddNoDraw()
self.parent:NoDraw(self)
self.health = table.health
self.mana = table.mana
self.active = table.active

self.illusion = EntIndexToHScript(table.illusion) 
self.point = GetGroundPosition(self.illusion:GetAbsOrigin(), nil)

local effect = ParticleManager:CreateParticle("particles/bane/nightmare_legendary_end_soul.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(effect, 1, self.illusion:GetAbsOrigin())
ParticleManager:Delete(effect, 0)

local particle_2 = ParticleManager:CreateParticle("particles/items_fx/phylactery.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle_2, 0, self.parent:GetAbsOrigin() + Vector(0, 0, 100))
ParticleManager:SetParticleControl(particle_2, 1, self.illusion:GetAbsOrigin() + Vector(0, 0, 100))
ParticleManager:ReleaseParticleIndex(particle_2)

local sunder_particle_1 = ParticleManager:CreateParticle("particles/bane/nightmare_legendary_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.illusion)
ParticleManager:SetParticleControlEnt(sunder_particle_1, 0, self.illusion, PATTACH_POINT_FOLLOW, "attach_hitloc", self.illusion:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(sunder_particle_1, 1, self.parent:GetAbsOrigin() + Vector(0, 0, 100))
ParticleManager:SetParticleControl(sunder_particle_1, 2, self.illusion:GetAbsOrigin())
ParticleManager:SetParticleControl(sunder_particle_1, 15, Vector(191, 100, 255))
ParticleManager:SetParticleControl(sunder_particle_1, 16, Vector(1,0,0))
ParticleManager:ReleaseParticleIndex(sunder_particle_1)

self.parent:SetAbsOrigin(self.point)
FindClearSpaceForUnit(self.parent, self.point, false)
self.parent:SetForwardVector(self.illusion:GetForwardVector())
self.parent:FaceTowards(self.illusion:GetAbsOrigin() + self.illusion:GetForwardVector()*10)

ProjectileManager:ProjectileDodge(self.parent)
end


function modifier_bane_nightmare_custom_legendary_end:OnDestroy()
if not IsServer() then return end
if not self.parent or self.parent:IsNull() then return end

if self.active == 1 then
  self.parent:GenericParticle("particles/void_buf2.vpcf")
  self.parent:SetHealth(self.parent:GetMaxHealth())
  self.parent:SetMana(self.parent:GetMaxMana())
else
  self.parent:SetHealth(math.max(1, self.health*self.parent:GetMaxHealth()))
  self.parent:SetMana(math.max(1, self.mana*self.parent:GetMaxMana()))
end

self.parent:RemoveNoDraw()
self.parent:Stop()

if self.illusion and not self.illusion:IsNull() then
  self.illusion:AddNoDraw()
  self.illusion:Kill(nil, nil)
end

local main_ability = self.caster:FindAbilityByName("bane_nightmare_custom")
if main_ability and main_ability.talents.has_silence == 1 and self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber() then  
  self.parent:AddNewModifier(self.caster, main_ability, "modifier_bane_nightmare_custom_silence", {duration = (1 - self.parent:GetStatusResistance())*main_ability.talents.silence_duration})
end

end

function modifier_bane_nightmare_custom_legendary_end:CheckState()
return 
{
  [MODIFIER_STATE_INVULNERABLE]       = true,
  [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
  [MODIFIER_STATE_STUNNED]            = true,
  [MODIFIER_STATE_OUT_OF_GAME]        = true,
  [MODIFIER_STATE_SILENCED]           = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION]  = true
}
end





modifier_bane_nightmare_custom_legendary_end_effect = class(mod_hidden)
function modifier_bane_nightmare_custom_legendary_end_effect:OnCreated(table)
self.parent = self:GetParent()
if not IsServer() then return end
local effect_name = "particles/units/heroes/hero_bane/bane_nightmare.vpcf"
if self:GetCaster():HasModifier("modifier_bane_immortal_shoulder") then
    effect_name = "particles/econ/items/bane/slumbering_terror/bane_slumber_nightmare.vpcf"
end
self.parent:GenericParticle(effect_name, self)
self.parent:StartGesture(ACT_DOTA_DISABLED)
end


function modifier_bane_nightmare_custom_legendary_end_effect:OnDestroy()
if not IsServer() then return end
if not self.parent or self.parent:IsNull() then return end

self.parent:FadeGesture(ACT_DOTA_DISABLED)
end



modifier_bane_nightmare_custom_legendary_damage = class({})
function modifier_bane_nightmare_custom_legendary_damage:IsHidden() return self:GetStackCount() == 1 end
function modifier_bane_nightmare_custom_legendary_damage:IsPurgable() return false end
function modifier_bane_nightmare_custom_legendary_damage:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent() 
self.ability = self:GetAbility()

self.delay = self.ability:GetSpecialValueFor("end_duration")
self.damage = self.ability.talents.legendary_damage 

if not IsServer() then return end
self.duration = self.ability.talents.legendary_effect_duration + self.delay
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_bane_nightmare_custom_legendary_damage:SetActive()
if not IsServer() then return end
self:SetDuration(self.duration, true)
self:SetStackCount(0)

self:StartIntervalThink(self.delay + 0.1)
end

function modifier_bane_nightmare_custom_legendary_damage:OnIntervalThink()
if not IsServer() then return end
self.parent:EmitSound("Bane.Nightmare_legendary_damage")
self.parent:GenericParticle("particles/items4_fx/soul_keeper.vpcf", self)
self.parent:GenericParticle("particles/bane/nightmare_legendary_damage_start.vpcf")
self.parent:GenericParticle("particles/bane/nightmare_legendary_damage.vpcf", self, true)
self.parent:EmitSound("Bane.Nightmare_legendary_damage_loop")

self:StartIntervalThink(-1)
end


function modifier_bane_nightmare_custom_legendary_damage:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Bane.Nightmare_legendary_damage_loop")
end

function modifier_bane_nightmare_custom_legendary_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_bane_nightmare_custom_legendary_damage:GetModifierIncomingDamage_Percentage(params)
if self:GetStackCount() == 1 then return end
if params.inflictor then return end
return self.damage
end


modifier_bane_nightmare_custom_speed = class(mod_visible)
function modifier_bane_nightmare_custom_speed:GetTexture() return "buffs/bane/nightmare_2" end


modifier_bane_nightmare_custom_slow = class({})
function modifier_bane_nightmare_custom_slow:IsHidden() return true end
function modifier_bane_nightmare_custom_slow:IsPurgable() return true end
function modifier_bane_nightmare_custom_slow:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.slow = self.ability.talents.move_slow
if not IsServer() then return end
self:SetStackCount(1)
self.parent:GenericParticle("particles/void_astral_slow.vpcf", self)
end

function modifier_bane_nightmare_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_bane_nightmare_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end




modifier_bane_nightmare_custom_silence = class({})
function modifier_bane_nightmare_custom_silence:IsHidden() return true end
function modifier_bane_nightmare_custom_silence:IsPurgable() return true end
function modifier_bane_nightmare_custom_silence:OnCreated()
self.parent = self:GetParent()
self.slow = self:GetAbility().talents.silence_slow
if not IsServer() then return end
self.parent:EmitSound("Sf.Raze_Silence")
self.parent:GenericParticle("particles/void_astral_slow.vpcf", self)
self.parent:GenericParticle("particles/bane/nightmare_legendary_silence.vpcf", self, true)
end

function modifier_bane_nightmare_custom_silence:CheckState()
return
{
  [MODIFIER_STATE_SILENCED] = true
}
end

function modifier_bane_nightmare_custom_silence:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_bane_nightmare_custom_silence:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end



modifier_bane_nightmare_custom_attack = class(mod_hidden)
function modifier_bane_nightmare_custom_attack:OnCreated()
self.damage = self:GetAbility().talents.auto_damage - 100
end

function modifier_bane_nightmare_custom_attack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_bane_nightmare_custom_attack:GetModifierDamageOutgoing_Percentage()
return self.damage
end


modifier_bane_nightmare_custom_invun = class(mod_hidden)
function modifier_bane_nightmare_custom_invun:CheckState()
return
{
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSLOWABLE] = true
}
end