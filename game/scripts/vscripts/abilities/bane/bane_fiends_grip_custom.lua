LinkLuaModifier( "modifier_bane_fiends_grip_custom", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_tracker", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_sound", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_sound_caster", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_legendary_stack", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_legendary_cast", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_legendary_illusion", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_absorb", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_absorb_cd", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_spell_damage", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_move_stack", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_fiends_grip_custom_move", "abilities/bane/bane_fiends_grip_custom", LUA_MODIFIER_MOTION_NONE )


bane_fiends_grip_custom = class({})

bane_fiends_grip_custom.active_mod = nil
bane_fiends_grip_custom.legendary_illusion = nil
bane_fiends_grip_custom.talents = {}

function bane_fiends_grip_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_bane/bane_fiends_grip.vpcf", context )
PrecacheResource( "particle", "particles/bane/grip_legendary_status.vpcf", context )
PrecacheResource( "particle", "particles/bane/grip_legendary.vpcf", context )
PrecacheResource( "particle", "particles/bane/grip_legendary_stack_max.vpcf", context )
PrecacheResource( "particle", "particles/bane/grip_legendary_stack.vpcf", context )
PrecacheResource( "particle", "particles/bane/sap_legendaryc.vpcf", context )
PrecacheResource( "particle", "particles/bane/grip_absorb.vpcf", context )
PrecacheResource( "particle", "particles/bane/grip_absorb_proc.vpcf", context )
PrecacheResource( "particle", "particles/bane/grip_legendary_spells.vpcf", context )
PrecacheResource( "particle", "particles/bane/grip_move.vpcf", context )
PrecacheResource( "particle", "particles/bane/grip_move_trail.vpcf", context )
end

function bane_fiends_grip_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_bane_fiends_grip_custom_tracker"
end

function bane_fiends_grip_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_bane_immortal_head") then
  return "bane/bane_fall20_immortal_ability_icon/bane_fall20_immortal_fiends_grip"
end 
return "bane_fiends_grip"
end

function bane_fiends_grip_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level ) + self.talents.cd_inc
end

function bane_fiends_grip_custom:GetCastRange(vLocation, hTarget)
local bonus = 0
if self:GetCaster():HasScepter() then
  bonus = self.talents.scepter_range
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + bonus
end

function bane_fiends_grip_custom:GetChannelTime()
local caster = self:GetCaster()
if caster:HasScepter() then
  return self.talents.scepter_duration
end
if not caster:HasModifier("modifier_bane_fiends_grip_custom_tracker") then 
  return self:GetFullDuration()
end
return (caster:GetUpgradeStack("modifier_bane_fiends_grip_custom_tracker")*self:GetFullDuration()/100)
end


function bane_fiends_grip_custom:GetFullDuration()
return self:GetSpecialValueFor("AbilityChannelTime") + self.talents.duration_inc
end

function bane_fiends_grip_custom:GetBehavior()
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED
end

function bane_fiends_grip_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level) 
end

function bane_fiends_grip_custom:GetCastPoint(iLevel)
return self.BaseClass.GetCastPoint(self)
end

function bane_fiends_grip_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end

local duration = self:GetChannelTime()
if caster:HasScepter() then
  local full = self:GetFullDuration()
  duration = math.max(full, full*(1 - target:GetStatusResistance()))
end
self.current_target = target
target:RemoveModifierByName("modifier_bane_nightmare_custom")
self.active_mod = target:AddNewModifier(caster, self, "modifier_bane_fiends_grip_custom", {duration = duration})
end


function bane_fiends_grip_custom:OnChannelThink(flInterval)
local caster = self:GetCaster()
local target = self.current_target

if not target or target:IsNull() or not target:HasModifier("modifier_bane_fiends_grip_custom") then 
  caster:Interrupt()
  return 
end

end

function bane_fiends_grip_custom:OnChannelFinish(bInterrupted)
local caster = self:GetCaster()
local target = self.current_target

self.current_target = nil
self.active_mod = nil

if not target or target:IsNull() then return end

local mod = target:FindModifierByName("modifier_bane_fiends_grip_custom")
if not mod then return end
if caster:HasScepter() and mod:GetElapsedTime() >= self.talents.scepter_duration - 0.03 then return end

mod:Destroy()
end



modifier_bane_fiends_grip_custom = class({})
function modifier_bane_fiends_grip_custom:IsHidden() return false end
function modifier_bane_fiends_grip_custom:IsPurgable() return false end
function modifier_bane_fiends_grip_custom:IsStunDebuff() return true end
function modifier_bane_fiends_grip_custom:IsPurgeException() return true end
function modifier_bane_fiends_grip_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_bane_fiends_grip_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

if not IsServer() then return end
self.ticks = self.ability:GetSpecialValueFor("fiend_grip_ticks")

self.max_time = self:GetRemainingTime()
self.damage_ability = nil

self.auto = 0
if table.illusion then
  self.auto = 1
  self.damage_ability = "modifier_bane_grip_7"
  self.illusion = EntIndexToHScript(table.illusion)
  self.caster_sound = self.illusion:AddNewModifier(self.illusion, self.ability, "modifier_bane_fiends_grip_custom_sound_caster", {duration = self:GetRemainingTime()})
  self.ticks = 3
  self.interval = self.max_time/self.ticks

  local damage = self.parent:GetMaxHealth()*self.ability.talents.legendary_damage
  if self.parent:IsCreep() then
    damage = math.min(damage, self.ability.talents.legendary_creeps)
  end
  self.damage = damage/self.ticks
else
  self.interval = self.max_time/(self.ticks - 1)
  self.damage = (self.ability:GetSpecialValueFor("fiend_grip_damage")*self:GetRemainingTime())/self.ticks
  self.caster_sound = self.caster:AddNewModifier(self.caster, self.ability, "modifier_bane_fiends_grip_custom_sound_caster", {duration = self:GetRemainingTime()})
end

self.mana = (self.ability:GetSpecialValueFor("fiend_grip_mana_drain")*self:GetRemainingTime()/100)/self.ticks

self.damageTable = {attacker = self.caster, victim = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_PURE, damage = self.damage}

self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_fiends_grip_custom_sound", {duration = self:GetRemainingTime()})

local effect_name = "particles/units/heroes/hero_bane/bane_fiends_grip.vpcf"
if self.caster:HasModifier("modifier_bane_immortal_head") then
  effect_name = "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf"
end

self.parent:GenericParticle(effect_name, self)
self.sound = false
self.count = 0

if self.auto == 0 then
  self:OnIntervalThink()
end
self:StartIntervalThink(self.interval - 0.03)
end

function modifier_bane_fiends_grip_custom:OnIntervalThink()
if not IsServer() then return end

if self.caster:HasModifier("modifier_bane_fiends_grip_custom_absorb_cd") then
  self.caster:RemoveModifierByName("modifier_bane_fiends_grip_custom_absorb_cd")
end

if self.count >= self.ticks then return end

DoDamage(self.damageTable, self.damage_ability)

if self.auto == 0 then
  local mana = self.parent:GetMaxMana()*self.mana
  self.parent:Script_ReduceMana(mana, self.ability)
  self.caster:GiveMana(mana)
end

self.count = self.count + 1
end

function modifier_bane_fiends_grip_custom:OnDestroy()
if not IsServer() then return end
if not IsValid(self.parent) then return end

if self.ability.talents.has_damage == 1 and self.parent:IsAlive() and not self.illusion then
  local damage = (self.parent:GetMaxHealth() - self.parent:GetHealth())*self.ability.talents.end_damage
  local real_damage = DoDamage({damage = damage, ability = self.ability, attacker = self.caster, victim = self.parent, damage_type = self.ability.talents.end_damage_type}, "modifier_bane_grip_2")
  self.parent:SendNumber(6, real_damage)

  self.parent:EmitSound("Bane.Grip_end")

  local effect_cast = ParticleManager:CreateParticle( "particles/bane/enfeeble_damage.vpcf", PATTACH_WORLDORIGIN, self.parent )
  ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
  ParticleManager:SetParticleControl( effect_cast, 1, Vector( 250, 0, 0 ) )
  ParticleManager:Delete( effect_cast, 0 )
end

if not self.parent:HasModifier(self:GetName()) then
  self.parent:RemoveModifierByName("modifier_bane_fiends_grip_custom_sound")
end

if self.caster_sound and not self.caster_sound:IsNull() then
  self.caster_sound:Destroy()
end

end

function modifier_bane_fiends_grip_custom:CheckState()
local state =
{
  [MODIFIER_STATE_STUNNED] = true,
}
return state
end

function modifier_bane_fiends_grip_custom:GetStatusEffectName()
return "particles/status_fx/status_effect_fiendsgrip.vpcf"
end

function modifier_bane_fiends_grip_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end




modifier_bane_fiends_grip_custom_tracker = class(mod_hidden)
function modifier_bane_fiends_grip_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.ability.talents =
{
  scepter_range = self.ability:GetSpecialValueFor("scepter_range"),
  scepter_duration = self.ability:GetSpecialValueFor("scepter_duration"),

  cd_inc = 0,
  duration_inc = 0,

  end_damage = 0,
  end_damage_type = 0,

  cdr_bonus = 0,
  damage_inc = 0,
  damage_duration = self.parent:GetTalentValue("modifier_bane_grip_3", "duration", true),
  damage_max = self.parent:GetTalentValue("modifier_bane_grip_3", "max", true),

  spells_max = self.parent:GetTalentValue("modifier_bane_grip_4", "max", true),
  speed_duration = self.parent:GetTalentValue("modifier_bane_grip_4", "duration", true),
  spells_speed = self.parent:GetTalentValue("modifier_bane_grip_4", "move", true),
  cd_items = self.parent:GetTalentValue("modifier_bane_grip_4", "cd_items", true),
  spells_duration = self.parent:GetTalentValue("modifier_bane_grip_4", "effect_duration", true),

  absorb_damage = self.parent:GetTalentValue("modifier_bane_hero_8", "damage_reduce", true),
  absorb_status = self.parent:GetTalentValue("modifier_bane_hero_8", "status", true),
  absorb_cd = self.parent:GetTalentValue("modifier_bane_hero_8", "cd", true),
  absorb_duration = self.parent:GetTalentValue("modifier_bane_hero_8", "duration", true),

  legendary_duration = self.parent:GetTalentValue("modifier_bane_grip_7", "effect_duration", true),
  legendary_max = self.parent:GetTalentValue("modifier_bane_grip_7", "max", true),
  legendary_radius = self.parent:GetTalentValue("modifier_bane_grip_7", "radius", true),
  legendary_incoming = self.parent:GetTalentValue("modifier_bane_grip_7", "incoming", true),
  legendary_outgoing = self.parent:GetTalentValue("modifier_bane_grip_7", "outgoing", true),
  legendary_illusion_duration = self.parent:GetTalentValue("modifier_bane_grip_7", "duration", true),
  legendary_delay = self.parent:GetTalentValue("modifier_bane_grip_7", "delay", true),
  legendary_cast_range = self.parent:GetTalentValue("modifier_bane_grip_7", "cast_range", true),
  legendary_stun = self.parent:GetTalentValue("modifier_bane_grip_7", "stun", true),
  legendary_damage = self.parent:GetTalentValue("modifier_bane_grip_7", "damage", true)/100,
  legendary_creeps = self.parent:GetTalentValue("modifier_bane_grip_7", "creeps", true),
}

self.has_legendary = false
self.has_damage = false
self.has_move = false

if self.parent:IsRealHero() then
  self.parent:AddSpellEvent(self)
end

self.interval = 0.2

self:SetHasCustomTransmitterData(true)
self:SetStackCount(100)
self:UpdateTalent()
end

function modifier_bane_fiends_grip_custom_tracker:UpdateTalent(name)

if name == "modifier_bane_grip_1" or self.parent:HasTalent("modifier_bane_grip_1") then
  self.ability.talents.cd_inc = self.parent:GetTalentValue("modifier_bane_grip_1", "cd")
  self.ability.talents.duration_inc = self.parent:GetTalentValue("modifier_bane_grip_1", "duration")
end

if name == "modifier_bane_grip_2" or self.parent:HasTalent("modifier_bane_grip_2") then
  self.ability.talents.has_damage = 1
  self.ability.talents.end_damage = self.parent:GetTalentValue("modifier_bane_grip_2", "damage")/100
  self.ability.talents.end_damage_type = self.parent:GetTalentValue("modifier_bane_grip_2", "damage_type")
end

if name == "modifier_bane_grip_3" or self.parent:HasTalent("modifier_bane_grip_3") then
  self.has_damage = true
  self.ability.talents.cdr_bonus = self.parent:GetTalentValue("modifier_bane_grip_3", "cdr")
  self.ability.talents.damage_inc = self.parent:GetTalentValue("modifier_bane_grip_3", "damage")
end

if name == "modifier_bane_grip_4" or self.parent:HasTalent("modifier_bane_grip_4") then
  self.has_move = true
end

if name == "modifier_bane_grip_7" or self.parent:HasTalent("modifier_bane_grip_7") then
  self:StartIntervalThink(self.interval)
  self.has_legendary = true
  self:UpdateUI()
end

if name == "modifier_bane_hero_8" or self.parent:HasTalent("modifier_bane_hero_8") then
  self.parent:AddDamageEvent_inc(self, true)
  self:StartIntervalThink(self.interval)
  self.has_absorb = true
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_bane_fiends_grip_custom_tracker:AddCustomTransmitterData() 
return self.ability.talents
end

function modifier_bane_fiends_grip_custom_tracker:HandleCustomTransmitterData(data)
if not self.ability then return end
self.ability.talents = data
end

function modifier_bane_fiends_grip_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if self.has_absorb and not self.parent:HasModifier("modifier_bane_fiends_grip_custom_absorb") 
  and not self.parent:HasModifier("modifier_bane_fiends_grip_custom_absorb_cd") and self.parent:IsAlive() then

  self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_fiends_grip_custom_absorb", {})
end

end

function modifier_bane_fiends_grip_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end

function modifier_bane_fiends_grip_custom_tracker:GetModifierPercentageCooldown()
return self.ability.talents.cdr_bonus
end

function modifier_bane_fiends_grip_custom_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if not self.has_absorb then return end
if self.parent ~= params.unit then return end
if self.parent:GetTeamNumber() == params.attacker:GetTeamNumber() then return end
if IsValid(self.ability.active_mod) then return end

local mod = self.parent:FindModifierByName("modifier_bane_fiends_grip_custom_absorb")

if mod then
  mod:SetEnd()
  return
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_fiends_grip_custom_absorb_cd", {duration = self.ability.talents.absorb_cd})
end

function modifier_bane_fiends_grip_custom_tracker:SpellEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end

local target = params.target

if self.ability == params.ability and target then
  self:SetStackCount((1 - target:GetStatusResistance()) * 100)
end

if self.has_damage and target and target:IsUnit() and target:GetTeamNumber() ~= self.parent:GetTeamNumber() then
  target:AddNewModifier(self.parent, self.ability, "modifier_bane_fiends_grip_custom_spell_damage", {duration = self.ability.talents.damage_duration})
end

if self.has_move and not self.parent:HasModifier("modifier_bane_fiends_grip_custom_move") then
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_fiends_grip_custom_move_stack", {duration = self.ability.talents.spells_duration})
end

if not self.has_legendary then return end
if IsValid(self.ability.legendary_illusion) then return end

local index = nil
if target and target:GetTeamNumber() ~= self.parent:GetTeamNumber() then
  index = target:entindex()
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_fiends_grip_custom_legendary_stack", {target = index, duration = self.ability.talents.legendary_duration})
end

function modifier_bane_fiends_grip_custom_tracker:UpdateUI()
if not IsServer() then return end

local stack = 0
local zero = nil
local active = 0
local max = self.ability.talents.legendary_max

local mod = self.parent:FindModifierByName("modifier_bane_fiends_grip_custom_legendary_stack")

if mod then
  stack = mod:GetStackCount()
  if self.particle then
    ParticleManager:DestroyParticle(self.particle, true)
    ParticleManager:ReleaseParticleIndex(self.particle)
    self.particle = nil
  end
else
  if not self.particle then
    self.particle = self.parent:GenericParticle("particles/bane/grip_legendary_spells.vpcf", self, true)
    for i = 1,max do 
      ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
    end
  end
end

if IsValid(self.ability.legendary_illusion) and self.ability.legendary_illusion:IsAlive() then
  local mod = self.ability.legendary_illusion:FindModifierByName("modifier_bane_fiends_grip_custom_legendary_illusion")
  if mod then
    active = 1
    zero = 1
    stack = mod:GetRemainingTime()
    max = self.ability.talents.legendary_illusion_duration
  end
end

self.parent:UpdateUIlong({stack = stack, max = max, override_stack = override, use_zero = zero, active = active, style = "BaneGrip"})
end





modifier_bane_fiends_grip_custom_sound = class(mod_hidden)
function modifier_bane_fiends_grip_custom_sound:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self:StartIntervalThink(0.05)
end

function modifier_bane_fiends_grip_custom_sound:OnIntervalThink()
if not IsServer() then return end
self.parent:StartGesture(ACT_DOTA_FLAIL)
self.parent:EmitSound("Hero_Bane.FiendsGrip")
self:StartIntervalThink(-1)
end


function modifier_bane_fiends_grip_custom_sound:OnDestroy()
if not IsServer() then return end
self.parent:FadeGesture(ACT_DOTA_FLAIL)
self.parent:StopSound("Hero_Bane.FiendsGrip")
end



modifier_bane_fiends_grip_custom_sound_caster = class(mod_hidden)
function modifier_bane_fiends_grip_custom_sound_caster:OnCreated(table)
self.parent = self:GetParent()
if not IsServer() then return end
self:StartIntervalThink(0.05)
end

function modifier_bane_fiends_grip_custom_sound_caster:OnIntervalThink()
if not IsServer() then return end
self.parent:EmitSound("Hero_Bane.FiendsGrip.Cast")
self:StartIntervalThink(-1)
end

function modifier_bane_fiends_grip_custom_sound_caster:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Hero_Bane.FiendsGrip.Cast")
end





modifier_bane_fiends_grip_custom_legendary_stack = class(mod_hidden)
function modifier_bane_fiends_grip_custom_legendary_stack:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.max = self.ability.talents.legendary_max
self.radius = self.ability.talents.legendary_radius
self.duration = self.ability.talents.legendary_duration

if not IsServer() then return end
self.RemoveForDuel = true
self.mod = self.parent:FindModifierByName("modifier_bane_fiends_grip_custom_tracker")

self.visual_max = self.max
self.particle = self.parent:GenericParticle("particles/bane/grip_legendary_spells.vpcf", self, true)

self:SetStackCount(1)
self:StartIntervalThink(0.2)
end

function modifier_bane_fiends_grip_custom_legendary_stack:OnIntervalThink()
if not IsServer() then return end
local targets = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

if #targets > 0 then
  self:SetDuration(self.duration, true)
end

end

function modifier_bane_fiends_grip_custom_legendary_stack:OnRefresh(params)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
  self:SpawnIllusion(params.target)
  self:Destroy()
end

end

function modifier_bane_fiends_grip_custom_legendary_stack:OnStackCountChanged()
if not IsServer() then return end

if self.mod then
  self.mod:UpdateUI()
end

if not self.particle then return end

for i = 1,self.visual_max do 
  if i <= math.floor(self:GetStackCount()/(self.max/self.visual_max)) then 
    ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
  else 
    ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
  end
end

end

function modifier_bane_fiends_grip_custom_legendary_stack:OnDestroy()
if not IsServer() then return end
if not self.mod then return end
self.mod:UpdateUI()
end

function modifier_bane_fiends_grip_custom_legendary_stack:SpawnIllusion(target)
if not IsServer() then return end

local caster = self.parent

local illusion_target = nil
local point = caster:GetAbsOrigin()
if target then
  illusion_target = target
  point = EntIndexToHScript(target):GetAbsOrigin()
end

point = point + RandomVector(300)

local duration = self.ability.talents.legendary_illusion_duration
local incoming = self.ability.talents.legendary_incoming - 100
local damage = self.ability.talents.legendary_outgoing - 100

local illusions = CreateIllusions( caster, caster, {duration = duration, outgoing_damage = damage,incoming_damage = incoming}, 1, 1, false, true )
for _,illusion in pairs(illusions) do
  illusion:Stop()
  illusion:EmitSound("Bane.Grip_legendary")
  illusion:EmitSound("Bane.Grip_legendary2")
  illusion:AddNewModifier(caster, nil, "modifier_chaos_knight_phantasm_illusion", {})
  illusion:AddNewModifier(caster, self.ability, "modifier_bane_fiends_grip_custom_legendary_illusion", {duration = duration, target = illusion_target})

  illusion:SetAbsOrigin(point)
  FindClearSpaceForUnit(illusion, point, true)
  illusion:SetHealth(illusion:GetMaxHealth())

  illusion.owner = caster

  for _,mod in pairs(caster:FindAllModifiers()) do
    if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
        illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
    end
  end
end

self:Destroy()
end




modifier_bane_fiends_grip_custom_legendary_illusion = class(mod_hidden)
function modifier_bane_fiends_grip_custom_legendary_illusion:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.cast_range = self.ability.talents.legendary_cast_range
self.cast_duration = self.ability.talents.legendary_stun
self.first_delay = self.ability.talents.legendary_delay

if not IsServer() then return end
self.mod = self.caster:FindModifierByName("modifier_bane_fiends_grip_custom_tracker")
self.ability.legendary_illusion = self.parent

self.parent:GenericParticle("particles/bane/grip_legendary.vpcf", self)
self.target = nil

self.caster_vector = RandomVector(300)

if table.target then
  self.target = EntIndexToHScript(table.target)
end

self.interval = 0.1

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_bane_fiends_grip_custom_legendary_illusion:OnDestroy()
if not IsServer() then return end
self.ability.legendary_illusion = nil

if not self.mod then return end
self.mod:UpdateUI()
end

function modifier_bane_fiends_grip_custom_legendary_illusion:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MODEL_SCALE,
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_bane_fiends_grip_custom_legendary_illusion:GetActivityTranslationModifiers()
return "haste"
end

function modifier_bane_fiends_grip_custom_legendary_illusion:GetModifierModelScale()
return 20
end

function modifier_bane_fiends_grip_custom_legendary_illusion:GetModifierMoveSpeed_Absolute()
return 550
end

function modifier_bane_fiends_grip_custom_legendary_illusion:GetStatusEffectName()
return "particles/bane/grip_legendary_status.vpcf"
end

function modifier_bane_fiends_grip_custom_legendary_illusion:StatusEffectPriority()
return MODIFIER_PRIORITY_ILLUSION
end

function modifier_bane_fiends_grip_custom_legendary_illusion:OnIntervalThink()
if not IsServer() then return end

local target = nil

if self.mod then
  self.mod:UpdateUI()
end

if IsValid(self.target) and self.target:IsAlive() and self.target:IsHero() then
  target = self.target
else
  target = self.parent:RandomTarget(1000)
end

if not target then 
  local point = self.caster:GetAbsOrigin() + self.caster_vector
  if (point - self.parent:GetAbsOrigin()):Length2D() >= 50 then
    self.parent:MoveToPosition(point)
  end
  return
end

AddFOWViewer(self.caster:GetTeamNumber(), target:GetAbsOrigin(), 10, self.interval*2, false)

if not self.cast_stun and (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.cast_range
  and not target:IsInvulnerable() and not target:IsOutOfGame() and not target:HasModifier("modifier_bane_fiends_grip_custom") and self:GetElapsedTime() >= self.first_delay
  and not self.parent:IsStunned() and not self.parent:IsSilenced() and self.parent:CanEntityBeSeenByMyTeam(target) then

  self.cast_stun = true
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_bane_fiends_grip_custom_legendary_cast", {duration = self.cast_duration, target = target:entindex()})
end

self.target = target
self.parent:SetForceAttackTarget(target)
self.parent:MoveToTargetToAttack(target)
end


function modifier_bane_fiends_grip_custom_legendary_illusion:CheckState()
return
{
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true
}
end



modifier_bane_fiends_grip_custom_legendary_cast = class(mod_hidden)
function modifier_bane_fiends_grip_custom_legendary_cast:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not IsServer() then return end
self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_4)
self.target = EntIndexToHScript(table.target)

if not self.target or self.target:IsNull() then return end

self.target:AddNewModifier(self.caster, self.ability, "modifier_bane_fiends_grip_custom", {illusion = self.parent:entindex(), duration = self:GetRemainingTime()})

self.parent:FaceTowards(self.target:GetAbsOrigin())
local vec = (self.target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
vec.z = 0

self.parent:SetForwardVector(vec)

self:StartIntervalThink(0.5)
end


function modifier_bane_fiends_grip_custom_legendary_cast:OnIntervalThink()
if not IsServer() then return end
self.parent:StartGesture(ACT_DOTA_CHANNEL_ABILITY_4)
end


function modifier_bane_fiends_grip_custom_legendary_cast:CheckState()
return
{
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_DISARMED] = true
}
end


function modifier_bane_fiends_grip_custom_legendary_cast:OnDestroy()
if not IsServer() then return end
if not self.parent or self.parent:IsNull() then return end

if self.mod and not self.mod:IsNull() then
  self.mod:Destroy()
end

self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_4)
self.parent:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_4)
local mod = self.parent:FindModifierByName("modifier_bane_fiends_grip_custom_legendary_illusion")
if mod then
  mod:OnIntervalThink()
end

end



modifier_bane_fiends_grip_custom_absorb = class(mod_visible)
function modifier_bane_fiends_grip_custom_absorb:GetTexture() return "buffs/bane/hero_8" end
function modifier_bane_fiends_grip_custom_absorb:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.damage_cd = self.ability.talents.absorb_cd
self.damage_reduce = self.ability.talents.absorb_damage
self.duration = self.ability.talents.absorb_duration
self.status_bonus = self.ability.talents.absorb_status

if not IsServer() then return end
self.parent:GenericParticle("particles/bane/grip_absorb.vpcf", self)
self.parent:EmitSound("Bane.Grip_absorb")
end

function modifier_bane_fiends_grip_custom_absorb:OnDestroy()
if not IsServer() then return end
self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_fiends_grip_custom_absorb_cd", {duration = self.damage_cd})
end

function modifier_bane_fiends_grip_custom_absorb:GetStatusEffectName()
return "particles/status_fx/status_effect_phase_shift.vpcf"
end

function modifier_bane_fiends_grip_custom_absorb:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_bane_fiends_grip_custom_absorb:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_bane_fiends_grip_custom_absorb:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end

function modifier_bane_fiends_grip_custom_absorb:GetModifierStatusResistanceStacking() 
return self.status_bonus
end

function modifier_bane_fiends_grip_custom_absorb:SetEnd()
if not IsServer() then return end
if self.ended then return end
self.ended = true
self:SetDuration(self.duration, true)
self.parent:EmitSound("Bane.Grip_absorb_active")
self.parent:GenericParticle("particles/bane/sap_legendaryc.vpcf", self)
end



modifier_bane_fiends_grip_custom_absorb_cd = class(mod_cd)
function modifier_bane_fiends_grip_custom_absorb_cd:GetTexture() return "buffs/bane/hero_8" end


modifier_bane_fiends_grip_custom_spell_damage = class(mod_visible)
function modifier_bane_fiends_grip_custom_spell_damage:GetTexture() return "buffs/bane/grip_3" end
function modifier_bane_fiends_grip_custom_spell_damage:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.max = self.ability.talents.damage_max
self.damage = self.ability.talents.damage_inc

if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_bane_fiends_grip_custom_spell_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount() 
end

function modifier_bane_fiends_grip_custom_spell_damage:OnStackCountChanged()
if not IsServer() then return end

if not self.particle then 
  self.particle = self.parent:GenericParticle("particles/bane/grip_legendary_stack.vpcf", self, true)
end

if not self.particle then return end
ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
end

function modifier_bane_fiends_grip_custom_spell_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_bane_fiends_grip_custom_spell_damage:GetModifierIncomingDamage_Percentage(params)
if params.inflictor == nil then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if Not_spell_damage[params.inflictor:GetName()] then return end

return self.damage*self:GetStackCount()
end

function modifier_bane_fiends_grip_custom_spell_damage:OnTooltip()
return self.damage*self:GetStackCount()
end



modifier_bane_fiends_grip_custom_move_stack = class(mod_visible)
function modifier_bane_fiends_grip_custom_move_stack:GetTexture() return "buffs/bane/grip_4" end
function modifier_bane_fiends_grip_custom_move_stack:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.max = self.ability.talents.spells_max
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_bane_fiends_grip_custom_move_stack:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
  self.parent:CdItems(self.ability.talents.cd_items)
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_fiends_grip_custom_move", {duration = self.ability.talents.speed_duration})
  self:Destroy()
end

end

modifier_bane_fiends_grip_custom_move = class(mod_visible)
function modifier_bane_fiends_grip_custom_move:GetTexture() return "buffs/bane/grip_4" end
function modifier_bane_fiends_grip_custom_move:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.move = self.ability.talents.spells_speed
if not IsServer() then return end
self.parent:EmitSound("Bane.Grip_move")
self.parent:GenericParticle("particles/bane/grip_move_trail.vpcf", self)
self.parent:GenericParticle("particles/bane/grip_move.vpcf")
end

function modifier_bane_fiends_grip_custom_move:CheckState()
return
{
  [MODIFIER_STATE_UNSLOWABLE] = true
}
end

function modifier_bane_fiends_grip_custom_move:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_bane_fiends_grip_custom_move:GetActivityTranslationModifiers()
return "haste"
end

function modifier_bane_fiends_grip_custom_move:GetModifierMoveSpeedBonus_Percentage()
return self.move
end