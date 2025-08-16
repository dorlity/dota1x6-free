LinkLuaModifier( "modifier_enigma_demonic_conversion_custom", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_demonic_conversion_custom_tracker", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_demonic_conversion_custom_legendary_delay", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_demonic_conversion_custom_legendary_caster", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_demonic_conversion_custom_legendary_creep", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_demonic_conversion_custom_perma", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_demonic_conversion_custom_attack_cd", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_demonic_conversion_custom_attack_damage", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_demonic_conversion_custom_absorb_cd", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_demonic_conversion_custom_invun", "abilities/enigma/enigma_demonic_conversion_custom", LUA_MODIFIER_MOTION_NONE )


enigma_demonic_conversion_custom = class({})

enigma_demonic_conversion_custom.spawned_units = {}


function enigma_demonic_conversion_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_enigma/enigma_demonic_conversion.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_legendary_delay.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_legendary_creep_spawn.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_legendary_creep_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_enigma/enigma_eidolon_ambient.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_legendary_attack.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_legendary_end.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_perma.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_heal.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_spell_damage.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_absorb.vpcf", context )
PrecacheResource( "particle", "particles/empyreal_lens.vpcf", context )

end

function enigma_demonic_conversion_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_enigma_demonic_conversion_custom_tracker"
end

function enigma_demonic_conversion_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_enigma_conversion_3") then
  bonus = self:GetCaster():GetTalentValue("modifier_enigma_conversion_3", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function enigma_demonic_conversion_custom:GetCastRange(vLocation, hTarget)
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function enigma_demonic_conversion_custom:GetCastPoint(iLevel)
return self.BaseClass.GetCastPoint(self)
end



function enigma_demonic_conversion_custom:SummonUnit(point, can_double, new_duration, legendary_name)

local caster = self:GetCaster()

local damage = self:GetSpecialValueFor("eidelon_base_damage") + caster:GetTalentValue("modifier_enigma_conversion_1", "damage")*caster:GetAverageTrueAttackDamage(nil)/100
local health = self:GetSpecialValueFor("eidelon_max_health")
local health_bonus = caster:GetMaxHealth()*(self:GetSpecialValueFor("health_pct") + caster:GetTalentValue("modifier_enigma_conversion_1", "health"))/100
local duration = self:GetSpecialValueFor("AbilityDuration")
local magic_resist = self:GetSpecialValueFor("eidolon_magic_resist")
local move_speed = self:GetSpecialValueFor("eidelon_base_movespeed") + caster:GetTalentValue("modifier_enigma_conversion_2", "move")
local base_armor = self:GetSpecialValueFor("eidolon_armor") + caster:GetTalentValue("modifier_enigma_conversion_2", "armor")

if caster:HasTalent("modifier_enigma_conversion_3") then
  caster:GenericHeal(caster:GetTalentValue("modifier_enigma_conversion_3", "heal")*caster:GetMaxHealth()/100, self, true, "particles/enigma/summon_heal.vpcf", "modifier_enigma_conversion_3")
end

health = health + health_bonus

if new_duration then
  duration = new_duration
end

local name = "npc_dota_lesser_eidolon_custom"
if legendary_name then
  name = legendary_name
end

local new_eidolon = CreateUnitByName(name, point, true, caster, caster, caster:GetTeamNumber())
new_eidolon:AddNewModifier(caster, self, "modifier_kill", { duration = duration })
new_eidolon:AddNewModifier(caster, self, "modifier_enigma_demonic_conversion_custom", {can_double = can_double, duration = duration})

if caster:HasTalent("modifier_enigma_conversion_5") then
  new_eidolon:AddNewModifier(caster, self, "modifier_enigma_demonic_conversion_custom_invun", {duration = caster:GetTalentValue("modifier_enigma_conversion_5", "duration")})
end

local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_demonic_conversion.vpcf", PATTACH_CUSTOMORIGIN, new_eidolon)
ParticleManager:SetParticleControlEnt( effect, 0, new_eidolon, PATTACH_POINT_FOLLOW, "attach_hitloc", new_eidolon:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( effect, 1, new_eidolon, PATTACH_POINT_FOLLOW, "attach_hitloc", new_eidolon:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(effect)

new_eidolon.owner = caster

if not legendary_name then
  new_eidolon:SetBaseMaxHealth(health)
  new_eidolon:SetMaxHealth(health)
  new_eidolon:SetHealth(health)
  new_eidolon:SetBaseDamageMin(damage)
  new_eidolon:SetBaseDamageMax(damage)
end

new_eidolon:SetPhysicalArmorBaseValue(base_armor)
new_eidolon:SetBaseMoveSpeed(move_speed)
new_eidolon:SetControllableByPlayer(caster:GetPlayerID(), true)

new_eidolon:SetBaseMagicalResistanceValue(magic_resist)
FindClearSpaceForUnit(new_eidolon, new_eidolon:GetOrigin(), false)
new_eidolon:SetAngles(0, 0, 0)
new_eidolon:SetForwardVector(caster:GetForwardVector())

if can_double == 1 then 
  self.spawned_units[#self.spawned_units + 1] = new_eidolon
end 

return new_eidolon
end



function enigma_demonic_conversion_custom:OnSpellStart()
local caster = self:GetCaster()

local point = self:GetCursorPosition()
local range = self:GetSpecialValueFor("spawn_offset")
local count = self:GetSpecialValueFor("spawn_count")

EmitSoundOnLocationWithCaster(point, "Hero_Enigma.Demonic_Conversion", caster)

for _, unit in pairs(self.spawned_units) do
    if unit and not unit:IsNull() and unit:IsAlive() then
        unit:Kill(nil, nil)
    end
end

self.spawned_units = {}

local new_point = point + caster:GetForwardVector()*range

for i = 1,count do 
  new_point = RotatePosition( point, QAngle( 0, 360/count, 0 ), new_point )
  self:SummonUnit(new_point, 1)
end

end






modifier_enigma_demonic_conversion_custom_tracker = class({})
function modifier_enigma_demonic_conversion_custom_tracker:IsHidden() return not self:GetParent():HasTalent("modifier_enigma_conversion_2") or self:GetStackCount() <= 0 end
function modifier_enigma_demonic_conversion_custom_tracker:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.ability = self:GetAbility()

self.auto_duration = self.parent:GetTalentValue("modifier_enigma_conversion_4", "auto_duration", true)
self.spell_duration = self.parent:GetTalentValue("modifier_enigma_conversion_4", "duration", true)

self.absorb_radius = self.parent:GetTalentValue("modifier_enigma_conversion_5", "radius", true)
self.absorb_cd = self.parent:GetTalentValue("modifier_enigma_conversion_5", "cd", true)

if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "subscribe_redirect",  {})

self.parent:AddAttackStartEvent_out(self)
self.parent:AddAttackEvent_out(self)
end

function modifier_enigma_demonic_conversion_custom_tracker:OnRefresh(table)
self:OnCreated()
end

function modifier_enigma_demonic_conversion_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_ABSORB_SPELL,
}
end

function modifier_enigma_demonic_conversion_custom_tracker:GetModifierPhysicalArmorBonus()
if not self.parent:HasTalent("modifier_enigma_conversion_2") then return end
if self:GetStackCount() <= 0 then return end
return self.parent:GetTalentValue("modifier_enigma_conversion_2", "armor")
end

function modifier_enigma_demonic_conversion_custom_tracker:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_enigma_conversion_2") then return end
if self:GetStackCount() <= 0 then return end
return self.parent:GetTalentValue("modifier_enigma_conversion_2", "move")
end

function modifier_enigma_demonic_conversion_custom_tracker:DeathEvent(params)
if not IsServer() then return end
if self.parent:GetTeamNumber() ~= params.unit:GetTeamNumber() then return end
local mod = params.unit:FindModifierByName("modifier_enigma_demonic_conversion_custom_legendary_creep")

if not mod then return end
mod:DeathEffect()
end


function modifier_enigma_demonic_conversion_custom_tracker:GetAbsorbSpell(params) 
if not self.parent:HasTalent("modifier_enigma_conversion_5") then return end
if self.parent:HasModifier("modifier_enigma_demonic_conversion_custom_absorb_cd") then return end
if params.ability:GetCaster():GetTeamNumber() == self.parent:GetTeamNumber() then return end
if self.parent:IsInvulnerable() then return end

local units = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.absorb_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false )
local target = nil

for _,unit in pairs(units) do
  if unit.owner and unit.owner == self.parent and unit:HasModifier("modifier_enigma_demonic_conversion_custom") then
    target = unit
    break
  end
end

if not target then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_enigma_demonic_conversion_custom_absorb_cd", {duration = self.absorb_cd})

if not target:IsInvulnerable() then
  target:Kill(nil, params.ability:GetCaster())
end

self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate")

local particle = ParticleManager:CreateParticle("particles/enigma/summon_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex(particle)

local particle_2 = ParticleManager:CreateParticle("particles/empyreal_lens.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle_2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle_2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle_2)

return 1 
end



function modifier_enigma_demonic_conversion_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_enigma_conversion_4") then return end
if not params.target:IsUnit() then return end
local attacker = params.attacker

if attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end
if not attacker.owner or attacker.owner ~= self.parent then return end

local mod = attacker:FindModifierByName("modifier_enigma_demonic_conversion_custom")

if not mod then return end

params.target:AddNewModifier(self.parent, self.ability, "modifier_enigma_demonic_conversion_custom_attack_damage", {duration = self.spell_duration})
end


function modifier_enigma_demonic_conversion_custom_tracker:AttackStartEvent_out(params)
if not IsServer() then return end
if not params.target:IsUnit() then return end
local attacker = params.attacker

if attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end

if attacker == self.parent and self.parent:HasTalent("modifier_enigma_conversion_4") and not self.parent:HasModifier("modifier_enigma_demonic_conversion_custom_attack_cd") then
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_enigma_demonic_conversion_custom_attack_cd", {duration = self.parent:GetTalentValue("modifier_enigma_conversion_4", "cd")})

  local point = self.parent:GetAbsOrigin() + RandomVector(200)
  self.ability:SummonUnit(point, 0, self.auto_duration)
end

local mod = attacker:FindModifierByName("modifier_enigma_demonic_conversion_custom")
if not mod or mod:GetStackCount() == 0 then return end

mod.count = mod.count + 1
if mod.count >= mod.max_attacks then

  if params.target:IsRealHero() then

    if self.parent:GetQuest() == "Enigma.Quest_6" and not self.parent:QuestCompleted() then
      self.parent:UpdateQuest(1)
    end

    self.parent:AddNewModifier(self.parent, self.ability, "modifier_enigma_demonic_conversion_custom_perma", {})
  end

  mod:ProcDouble()
end


end



modifier_enigma_demonic_conversion_custom = class({})
function modifier_enigma_demonic_conversion_custom:IsHidden() return true end
function modifier_enigma_demonic_conversion_custom:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.range = self.ability:GetSpecialValueFor("eidolon_attack_range") + self.caster:GetTalentValue("modifier_enigma_conversion_6", "range")
self.count = 0
self.max_attacks = self.ability:GetSpecialValueFor("split_attack_count") + self.caster:GetTalentValue("modifier_enigma_conversion_6", "attacks")

if not IsServer() then return end

local mod = self.caster:FindModifierByName("modifier_enigma_demonic_conversion_custom_tracker")
if mod then
  mod:IncrementStackCount()
end

self:SetStackCount(table.can_double)
end

function modifier_enigma_demonic_conversion_custom:OnDestroy()
if not IsServer() then return end
if not self.caster or self.caster:IsNull() then return end

local mod = self.caster:FindModifierByName("modifier_enigma_demonic_conversion_custom_tracker")
if mod then
  mod:DecrementStackCount()
end

end

function modifier_enigma_demonic_conversion_custom:ProcDouble()
if not IsServer() then return end

self:SetStackCount(0)
self.count = 0

self.parent:SetHealth(self.parent:GetMaxHealth())
self.ability:SummonUnit(self.parent:GetAbsOrigin(), 0, self:GetRemainingTime())
end

function modifier_enigma_demonic_conversion_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_enigma_demonic_conversion_custom:GetModifierAttackRangeBonus()
return self.range
end








enigma_demonic_conversion_custom_legendary = class({})

function enigma_demonic_conversion_custom_legendary:CreateTalent()
local caster = self:GetCaster()
local far_ability = caster:FindAbilityByName("enigma_black_hole_custom_legendary_far")
local close_ability = caster:FindAbilityByName("enigma_black_hole_custom_legendary_close")

if caster:HasTalent("modifier_enigma_blackhole_7") and far_ability and close_ability then

  if close_ability:GetToggleState() then
    close_ability:ToggleAbility()
  end

  if far_ability:GetToggleState() then
    far_ability:ToggleAbility()
  end
  caster:RemoveModifierByName("modifier_enigma_black_hole_custom_legendary_toggle_far")
  caster:RemoveModifierByName("modifier_enigma_black_hole_custom_legendary_toggle_close")
end

caster:SwapAbilities("enigma_black_hole_custom_legendary_far", self:GetName(), false, true)
end

function enigma_demonic_conversion_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_enigma_conversion_7", "cd")
end

function enigma_demonic_conversion_custom_legendary:OnAbilityPhaseStart()
return not self:GetCaster():HasModifier("modifier_custom_pudge_dismember_devour")
end


function enigma_demonic_conversion_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("invun_duration")

local damage = self:GetSpecialValueFor("base_damage")
local health = self:GetSpecialValueFor("base_health")
local health_pct = self:GetSpecialValueFor("health_pct")/100
local damage_pct = self:GetSpecialValueFor("damage_pct")/100
local speed = 0
local speed_inc = caster:GetTalentValue("modifier_enigma_conversion_7", "speed")

local units = FindUnitsInRadius( caster:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false )

for _,unit in pairs(units) do
  if not unit:IsNull() and unit:IsAlive() and unit:GetUnitName() == "npc_dota_lesser_eidolon_custom" and unit.owner and unit.owner == caster then
    damage = damage + unit:GetAverageTrueAttackDamage(nil)*damage_pct
    health = health + unit:GetMaxHealth()*health_pct
    speed = speed + speed_inc

    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt( effect_cast, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(),  true )
    ParticleManager:SetParticleControlEnt( effect_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true  )
    ParticleManager:ReleaseParticleIndex( effect_cast )
    unit:Kill(nil, nil)
  end
end

ProjectileManager:ProjectileDodge(caster)
caster:Purge(false, true, false, true, true)
caster:Stop()

caster:EmitSound("Enigma.Summon_legendary_start")
caster:EmitSound("Enigma.Summon_legendary_start2")
caster:AddNewModifier(caster, self, "modifier_enigma_demonic_conversion_custom_legendary_delay", {duration = duration + 0.2, health = health, damage = damage, speed = speed})
end



modifier_enigma_demonic_conversion_custom_legendary_delay = class({})
function modifier_enigma_demonic_conversion_custom_legendary_delay:IsHidden() return true end
function modifier_enigma_demonic_conversion_custom_legendary_delay:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_legendary_delay:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.main_ability = self.parent:FindAbilityByName("enigma_demonic_conversion_custom")
self.invun = self.ability:GetSpecialValueFor("invun_duration")

self.duration = self.ability:GetSpecialValueFor("duration")
self.count = self.parent:GetTalentValue("modifier_enigma_conversion_7", "count")

self.units = {}

if not IsServer() then return end

self.health = table.health
self.damage = table.damage
self.speed = table.speed

local effect = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_demonic_conversion.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt( effect, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( effect, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(effect)

local effect2 = ParticleManager:CreateParticle("particles/enigma/summon_legendary_delay.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt( effect2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( effect2, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetOrigin(), true )
self:AddParticle( effect2, false, false, -1, false, false  )

self:StartIntervalThink(self.invun)
end

function modifier_enigma_demonic_conversion_custom_legendary_delay:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE]       = true,
  [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
  [MODIFIER_STATE_STUNNED]            = true,
  [MODIFIER_STATE_OUT_OF_GAME]        = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION]  = true
}
end

function modifier_enigma_demonic_conversion_custom_legendary_delay:OnDestroy()
if not IsServer() then return end

local mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_enigma_demonic_conversion_custom_legendary_caster", {})

if mod and self.units and #self.units > 0 then
  mod.units = self.units
end

end


function modifier_enigma_demonic_conversion_custom_legendary_delay:OnIntervalThink()
if not IsServer() then return end
if not self.main_ability then return end

local new_point = self.parent:GetAbsOrigin() + self.parent:GetForwardVector()*120
new_point = RotatePosition( self.parent:GetAbsOrigin(), QAngle( 0, 90 , 0 ), new_point )

for i = 1,self.count do 

  local unit = self.main_ability:SummonUnit(new_point, 0, self.duration, "npc_dota_eidolon_custom_legendary")
  unit:SetAbsOrigin(self.parent:GetAbsOrigin())

  table.insert(self.units, unit)

  unit:AddNewModifier(unit, self.ability, "modifier_stunned", {duration = self:GetRemainingTime()})
  unit:AddNewModifier(unit, self.ability, "modifier_invulnerable", {duration = self:GetRemainingTime()})
  unit:AddNewModifier(unit, self.ability, "modifier_enigma_demonic_conversion_custom_legendary_creep", {speed = self.speed})


  new_point = RotatePosition( self.parent:GetAbsOrigin(), QAngle( 0, 360/self.count, 0 ), new_point )
  local dir = (new_point - self.parent:GetAbsOrigin())
  local center = 10*dir:Normalized() + self.parent:GetAbsOrigin()

  local knockbackProperties =
  {
    center_x = center.x,
    center_y = center.y,
    center_z = center.z,
    duration = 0.25,
    knockback_duration = 0.25,
    knockback_distance = dir:Length2D(),
    knockback_height = 60
  }
  unit:AddNewModifier( unit, self.ability, "modifier_knockback", knockbackProperties )

  unit:SetBaseMaxHealth(self.health)
  unit:SetMaxHealth(self.health)
  unit:SetHealth(self.health)
  unit:SetBaseDamageMin(self.damage)
  unit:SetBaseDamageMax(self.damage)

  local ability = unit:FindAbilityByName("enigma_demonic_conversion_custom_legendary_stop")
  if ability then
    ability:SetLevel(1)
  end
end

self:StartIntervalThink(-1)
end



modifier_enigma_demonic_conversion_custom_legendary_caster = class({})
function modifier_enigma_demonic_conversion_custom_legendary_caster:IsHidden() return true end
function modifier_enigma_demonic_conversion_custom_legendary_caster:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_legendary_caster:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.playerID = self.parent:GetPlayerOwnerID()
self.saved_unit = nil
self.ended = false

if not IsServer() then return end

self.parent:AddNoDraw()
self.parent:NoDraw(self)
self.RemoveForDuel = true

self:StartIntervalThink(0.05)
end

function modifier_enigma_demonic_conversion_custom_legendary_caster:IsValid()
return self.saved_unit and not self.saved_unit:IsNull() and self.saved_unit:IsAlive()
end

function modifier_enigma_demonic_conversion_custom_legendary_caster:OnIntervalThink()
if not IsServer() then return end
if not self.units then return end
if self.ended == true then return end

if not self:IsValid() then

  for _,unit in pairs(self.units) do
    if unit and not unit:IsNull() and unit:IsAlive() then
      self.saved_unit = unit
      PlayerResource:SetDefaultSelectionEntity(self.playerID, unit)
      PlayerResource:ResetSelection(self.playerID)
      break
    end
  end
end

if self:IsValid() then
  local point = self.saved_unit:GetAbsOrigin()
  self.parent:SetAbsOrigin(point)
  self.parent:SetForwardVector(self.saved_unit:GetForwardVector())
  self.parent:FaceTowards(point + self.saved_unit:GetForwardVector()*10)
else
  self:SetEnd()
end

end

function modifier_enigma_demonic_conversion_custom_legendary_caster:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE]       = true,
  [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
  [MODIFIER_STATE_STUNNED]            = true,
  [MODIFIER_STATE_OUT_OF_GAME]        = true,
  [MODIFIER_STATE_UNSELECTABLE]        = true,
  [MODIFIER_STATE_UNTARGETABLE]        = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION]  = true
}
end

function modifier_enigma_demonic_conversion_custom_legendary_caster:SetEnd()
if not IsServer() then return end
if self.ended == true then return end

self.ended = true

for _,unit in pairs(self.units) do
  if unit and not unit:IsNull() and unit:IsAlive() then
    unit:Kill(nil, nil)
  end
end

PlayerResource:SetDefaultSelectionEntity(self.playerID, -1)
PlayerResource:ResetSelection(self.playerID)

local particle2 = ParticleManager:CreateParticle( "particles/enigma/summon_legendary_end.vpcf",  PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( particle2, 0, self.parent:GetOrigin() )
ParticleManager:ReleaseParticleIndex(particle2)

self:SetDuration(0.2, true)
end


function modifier_enigma_demonic_conversion_custom_legendary_caster:OnDestroy()
if not IsServer() then return end

self:SetEnd()

self.parent:RemoveNoDraw()
self.parent:Stop()
self.ability:StartCd()

self.parent:StartGesture(ACT_DOTA_TELEPORT_END) 
self.parent:EmitSound("Enigma.Summon_legendary_hero_end")

FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)
end





modifier_enigma_demonic_conversion_custom_legendary_creep = class({})
function modifier_enigma_demonic_conversion_custom_legendary_creep:IsHidden() return true end
function modifier_enigma_demonic_conversion_custom_legendary_creep:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_legendary_creep:RemoveOnDeath() return false end
function modifier_enigma_demonic_conversion_custom_legendary_creep:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end
self:SetStackCount(table.speed)

self.damageTable = 
{
  attacker = self.parent,
  damage_type = DAMAGE_TYPE_PURE,
  ability = self.ability,
  damage_flags = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK
}

self.particle = self.parent:GenericParticle("particles/units/heroes/hero_enigma/enigma_eidolon_ambient.vpcf", self)
self.parent:EmitSound("Enigma.Summon_legendary_unit")

local particle2 = ParticleManager:CreateParticle( "particles/enigma/summon_legendary_creep_spawn.vpcf",  PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( particle2, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControlForward(particle2, 0, self.parent:GetForwardVector())
ParticleManager:SetParticleControl( particle2, 2, Vector(0, 1, 0) )
ParticleManager:ReleaseParticleIndex(particle2)

self.duration = self.ability:GetSpecialValueFor("duration")

self:StartIntervalThink(self.duration)
end

function modifier_enigma_demonic_conversion_custom_legendary_creep:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_PROJECTILE_NAME,
  MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE 
}
end

function modifier_enigma_demonic_conversion_custom_legendary_creep:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()
end

function modifier_enigma_demonic_conversion_custom_legendary_creep:GetModifierSpellAmplify_Percentage()
if not IsServer() then return end
if not self.parent.owner then return end
return self.parent.owner:GetSpellAmplification(false)*100
end

function modifier_enigma_demonic_conversion_custom_legendary_creep:GetModifierProjectileName()
return "particles/enigma/summon_legendary_attack.vpcf"
end

function modifier_enigma_demonic_conversion_custom_legendary_creep:GetOverrideAttackMagical()
return 1
end

function modifier_enigma_demonic_conversion_custom_legendary_creep:GetModifierTotalDamageOutgoing_Percentage(params)
local parent = self.parent
if params.inflictor then return 0 end
if params.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
if params.damage_type == DAMAGE_TYPE_MAGICAL then return 0 end
if not self.ability then return 0 end

self.damageTable.damage = params.original_damage
self.damageTable.victim = params.target

DoDamage(self.damageTable)

params.target:EmitSound("Enigma.Summon_legendary_attack")
return -200
end


function modifier_enigma_demonic_conversion_custom_legendary_creep:CheckState()
return 
{
  [MODIFIER_STATE_CANNOT_TARGET_BUILDINGS] = true
}
end


function modifier_enigma_demonic_conversion_custom_legendary_creep:OnIntervalThink()
if not IsServer() then return end
self:DeathEffect()
end

function modifier_enigma_demonic_conversion_custom_legendary_creep:DeathEffect()
if not IsServer() then return end

if self.particle then
  ParticleManager:ReleaseParticleIndex(self.particle)
  ParticleManager:DestroyParticle(self.particle, true)
  self.particle = nil
end

self.parent:EmitSound("Enigma.Summon_legendary_unit_end")

local effect = ParticleManager:CreateParticle("particles/enigma/summon_legendary_creep_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect, 0, self.parent:GetOrigin() )
ParticleManager:ReleaseParticleIndex(effect)

local particle2 = ParticleManager:CreateParticle( "particles/enigma/summon_legendary_creep_spawn.vpcf",  PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( particle2, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControlForward(particle2, 0, self.parent:GetForwardVector())
ParticleManager:SetParticleControl( particle2, 2, Vector(1, 0, 0) )
ParticleManager:ReleaseParticleIndex(particle2)

self.parent:AddNoDraw()
self:StartIntervalThink(-1)
end




enigma_demonic_conversion_custom_legendary_stop = class({})
function enigma_demonic_conversion_custom_legendary_stop:OnSpellStart()
local caster = self:GetCaster()
local owner = caster.owner

if not owner then return end
local mod = owner:FindModifierByName("modifier_enigma_demonic_conversion_custom_legendary_caster")

if mod then

  local point = caster:GetAbsOrigin()
  owner:SetAbsOrigin(point)
  owner:SetForwardVector(caster:GetForwardVector())
  owner:FaceTowards(point + caster:GetForwardVector()*10)

  mod:SetEnd()
end

end



modifier_enigma_demonic_conversion_custom_perma = class({})
function modifier_enigma_demonic_conversion_custom_perma:IsHidden() return not self:GetCaster():HasTalent("modifier_enigma_conversion_6") end
function modifier_enigma_demonic_conversion_custom_perma:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_perma:RemoveOnDeath() return false end
function modifier_enigma_demonic_conversion_custom_perma:GetTexture() return "buffs/wrath_perma" end
function modifier_enigma_demonic_conversion_custom_perma:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_enigma_conversion_6", "max", true)
self.cdr = self.parent:GetTalentValue("modifier_enigma_conversion_6", "cdr", true)

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(0.5)
end

function modifier_enigma_demonic_conversion_custom_perma:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end

function modifier_enigma_demonic_conversion_custom_perma:OnIntervalThink()
if not IsServer() then return end 
if self:GetStackCount() < self.max then return end
if not self.parent:HasTalent("modifier_enigma_conversion_6") then return end

self.parent:GenericParticle("particles/enigma/summon_perma.vpcf")

self.parent:EmitSound("BS.Thirst_legendary_active")
self:StartIntervalThink(-1)
end 


function modifier_enigma_demonic_conversion_custom_perma:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end


function modifier_enigma_demonic_conversion_custom_perma:GetModifierPercentageCooldown() 
if not self.parent:HasTalent("modifier_enigma_conversion_6") then return end
return self:GetStackCount()*self.cdr
end


modifier_enigma_demonic_conversion_custom_absorb_cd = class({})
function modifier_enigma_demonic_conversion_custom_absorb_cd:IsHidden() return false end
function modifier_enigma_demonic_conversion_custom_absorb_cd:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_absorb_cd:GetTexture() return "buffs/summon_absorb" end
function modifier_enigma_demonic_conversion_custom_absorb_cd:IsDebuff() return true end
function modifier_enigma_demonic_conversion_custom_absorb_cd:RemoveOnDeath() return false end
function modifier_enigma_demonic_conversion_custom_absorb_cd:OnCreated()
self.RemoveForDuel = true
end

modifier_enigma_demonic_conversion_custom_attack_cd = class({})
function modifier_enigma_demonic_conversion_custom_attack_cd:IsHidden() return false end
function modifier_enigma_demonic_conversion_custom_attack_cd:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_attack_cd:GetTexture() return "buffs/summon_attack" end
function modifier_enigma_demonic_conversion_custom_attack_cd:IsDebuff() return true end
function modifier_enigma_demonic_conversion_custom_attack_cd:RemoveOnDeath() return false end
function modifier_enigma_demonic_conversion_custom_attack_cd:OnCreated()
self.RemoveForDuel = true
end

modifier_enigma_demonic_conversion_custom_attack_damage = class({})
function modifier_enigma_demonic_conversion_custom_attack_damage:IsHidden() return false end
function modifier_enigma_demonic_conversion_custom_attack_damage:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_attack_damage:GetTexture() return "buffs/summon_attack" end
function modifier_enigma_demonic_conversion_custom_attack_damage:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_enigma_conversion_4", "max", true)
self.damage = self.caster:GetTalentValue("modifier_enigma_conversion_4", "damage")/self.max
if not IsServer() then return end
self.parent:GenericParticle("particles/items2_fx/veil_of_discord_debuff.vpcf", self)
self:SetStackCount(1)
end

function modifier_enigma_demonic_conversion_custom_attack_damage:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
  self.parent:GenericParticle("particles/enigma/summon_spell_damage.vpcf", self, true)
  self.parent:EmitSound("Enigma.Summon_damage_max")
end

end

function modifier_enigma_demonic_conversion_custom_attack_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_enigma_demonic_conversion_custom_attack_damage:GetModifierIncomingDamage_Percentage(params)
local damage = self.damage*self:GetStackCount()

if IsClient() then
  return damage
end

if params.inflictor == nil then return end
return damage
end



modifier_enigma_demonic_conversion_custom_invun = class({})
function modifier_enigma_demonic_conversion_custom_invun:IsHidden() return true end
function modifier_enigma_demonic_conversion_custom_invun:IsPurgable() return false end
function modifier_enigma_demonic_conversion_custom_invun:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true
}
end

function modifier_enigma_demonic_conversion_custom_invun:OnCreated()
self.parent = self:GetParent()

end