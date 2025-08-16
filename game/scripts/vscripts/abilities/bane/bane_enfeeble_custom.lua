LinkLuaModifier( "modifier_bane_enfeeble_custom", "abilities/bane/bane_enfeeble_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_enfeeble_custom_tracker", "abilities/bane/bane_enfeeble_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_enfeeble_custom_legendary", "abilities/bane/bane_enfeeble_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_enfeeble_custom_legendary_effect", "abilities/bane/bane_enfeeble_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_enfeeble_custom_legendary_caster", "abilities/bane/bane_enfeeble_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_enfeeble_custom_root", "abilities/bane/bane_enfeeble_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_enfeeble_custom_slow", "abilities/bane/bane_enfeeble_custom", LUA_MODIFIER_MOTION_NONE )

bane_enfeeble_custom = class({})
bane_enfeeble_custom.talents = {}
bane_enfeeble_custom.active_mod = nil

function bane_enfeeble_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_bane/bane_enfeeble.vpcf", context )
PrecacheResource( "particle", "particles/bane/enfeeble_legendary_aoe.vpcf", context )
PrecacheResource( "particle", "particles/bane/enfeeble_damage.vpcf", context )
PrecacheResource( "particle", "particles/bane/enfeeble_root.vpcf", context )
PrecacheResource( "particle", "particles/void_spirit/shield_buff.vpcf", context )
PrecacheResource( "particle", "particles/bane/enfeeble_dispell.vpcf", context )

end


function bane_enfeeble_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_bane_enfeeble_custom_tracker"
end

function bane_enfeeble_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level ) + self.talents.cd_inc
end

function bane_enfeeble_custom:GetCastRange(vLocation, hTarget)
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function bane_enfeeble_custom:GetAOERadius()
if self.talents.has_legendary == 0 then return end
return self.talents.legendary_radius
end

function bane_enfeeble_custom:GetBehavior()
local bonus = self.talents.has_legendary == 1 and DOTA_ABILITY_BEHAVIOR_AOE or 0
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + bonus
end

function bane_enfeeble_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level) 
end

function bane_enfeeble_custom:GetCastPoint(iLevel)
return self.BaseClass.GetCastPoint(self)
end

function bane_enfeeble_custom:ProcDispel(target)
if self.talents.has_dispel == 0 then return end
if not target:IsAlive() then return end

target:AddNewModifier(self:GetCaster(), self, "modifier_bane_enfeeble_custom", {duration = self.talents.dispel_duration, dispelled = 1})
end

function bane_enfeeble_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

caster:RemoveModifierByName("modifier_bane_enfeeble_custom_legendary_caster")

if target:TriggerSpellAbsorb(self) then 
  self:ProcDispel(target)
  return 
end

caster:EmitSound("Hero_Bane.Enfeeble.Cast")
target:EmitSound("Hero_Bane.Enfeeble")
local duration = self:GetSpecialValueFor("duration")
if self.talents.has_legendary == 1 then
  duration = nil
end
target:AddNewModifier(caster, self, "modifier_bane_enfeeble_custom", {dispelled = 0, duration = duration})
self:EndCd()

if self.talents.has_root == 1 then
  target:AddNewModifier(caster, self, "modifier_bane_enfeeble_custom_root", {duration = (1 - target:GetStatusResistance())*self.talents.root_duration})
end

if self.talents.has_legendary == 1 then
  CreateModifierThinker(caster, self, "modifier_bane_enfeeble_custom_legendary", {duration = duration, target = target:entindex() }, target:GetAbsOrigin(), caster:GetTeamNumber(), false)
end

end


modifier_bane_enfeeble_custom = class({})
function modifier_bane_enfeeble_custom:IsHidden() return false end
function modifier_bane_enfeeble_custom:IsPurgable() return self.ability.talents.has_legendary == 0 and self.dispelled == 0 end
function modifier_bane_enfeeble_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.slow = self.ability:GetSpecialValueFor("slow") + self.ability.talents.slow_inc
self.range_reduce = self.ability.talents.root_range

if IsServer() then
  self.ability.active_mod = self

  self.slow_mod = self.parent:AddNewModifier(self.caster, self.caster:BkbAbility(self.ability, self.ability.talents.has_dispel == 1), "modifier_bane_enfeeble_custom_slow", {slow = self.slow*-1})

  self.max_health = self.parent:GetMaxHealth()
  self.max_damage = self.parent:GetAverageTrueAttackDamage(nil)
  self.range_max = self.parent:Script_GetAttackRange()

  self.dispelled = table.dispelled
  local particle = "particles/units/heroes/hero_bane/bane_enfeeble.vpcf"
  if self.dispelled == 1 then
    particle = "particles/bane/enfeeble_dispell.vpcf"
    self.parent:EmitSound("Bane.Enfeeble_dispell")
  end

  self.parent:GenericParticle(particle, self, true)

  if self.ability.talents.has_root == 1 then
    self.vision = self.parent:AddNewModifier(self.caster, self.ability, "modifier_generic_vision", {})
  end

  self.range = 0
  self:SetHasCustomTransmitterData(true)
end

self.interval = self.ability:GetSpecialValueFor("damage_tick_rate")
self.damage = self.ability:GetSpecialValueFor("enfeeble_tick_damage") + self.ability.talents.damage_inc
self.radius = self.ability:GetSpecialValueFor("radius")
self.damage_reduce = self.ability:GetSpecialValueFor("damage_reduction") + self.ability.talents.reduce_inc

self.health_reduce = self.ability.talents.health_inc
self.status_reduce = self.ability.talents.status_inc
self.speed_reduce = self.ability.talents.speed_inc

self.damageTable = {attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_PURE, damage = self.damage}
self.count = -1

self:OnIntervalThink()
self:StartIntervalThink(self.interval - 0.02)
end

function modifier_bane_enfeeble_custom:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + 1

if self.parent:IsRealHero() and self.caster:GetQuest() and self.caster:GetQuest() == "Bane.Quest_5" and not self.caster:QuestCompleted() and self:GetElapsedTime() > 0.1 then
  self.caster:UpdateQuest(self.interval)
end

if self.ability.talents.has_legendary == 1 then
  self.caster:AddNewModifier(self.caster, self.ability, "modifier_bane_enfeeble_custom_legendary_caster", 
  {
    duration = self.ability.talents.legendary_duration,
    damage = self.max_damage*self.damage_reduce/100,
    health = self.max_health*self.health_reduce/100,
    speed = self.speed_reduce,
    move = self.slow,
    status = self.status_reduce,
    range = self.range_max*self.range_reduce
  })
end

for _,target in pairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())) do
  self.damageTable.victim = target
  DoDamage(self.damageTable)
end

if self.ability.talents.has_root == 1 then
  self.range = 0
  self.range = self.parent:Script_GetAttackRange()*self.range_reduce
  self:SendBuffRefreshToClients()
end

end

function modifier_bane_enfeeble_custom:AddCustomTransmitterData() 
return 
{
  range = self.range,
} 
end

function modifier_bane_enfeeble_custom:HandleCustomTransmitterData(data)
self.range = data.range
end

function modifier_bane_enfeeble_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end

function modifier_bane_enfeeble_custom:GetModifierAttackRangeBonus()
return self.range
end

function modifier_bane_enfeeble_custom:GetModifierStatusResistanceStacking() 
return self.status_reduce
end

function modifier_bane_enfeeble_custom:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_bane_enfeeble_custom:GetModifierExtraHealthPercentage()
return self.health_reduce
end

function modifier_bane_enfeeble_custom:GetModifierAttackSpeedBonus_Constant()
return self.speed_reduce
end

function modifier_bane_enfeeble_custom:OnDestroy()
if not IsServer() then return end
if not IsValid(self.parent) then return end

if IsValid(self.vision) then
  self.vision:Destroy()
end

if IsValid(self.slow_mod) then
  self.slow_mod:Destroy()
end

if self.ability.talents.has_dispel == 1 and self.dispelled == 0 and self.ability.talents.has_legendary == 0 and self:GetRemainingTime() >= 0.1 then
  self.ability:ProcDispel(self.parent)
  return
end

self.ability.active_mod = nil
self.ability:StartCd()
end


modifier_bane_enfeeble_custom_tracker = class(mod_hidden)
function modifier_bane_enfeeble_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.ability.talents =
{
  damage_inc = 0,
  health_inc = 0,

  slow_inc = 0,
  status_inc = 0,

  speed_inc = 0,
  reduce_inc = 0,

  has_root = 0,
  root_range = 0,
  root_duration = self.parent:GetTalentValue("modifier_bane_hero_5", "root", true),

  cd_inc = 0,
  has_dispel = 0,
  dispel_duration = 0,

  has_legendary = 0,
  legendary_radius = self.parent:GetTalentValue("modifier_bane_enfeeble_7", "radius", true),
  legendary_duration = self.parent:GetTalentValue("modifier_bane_enfeeble_7", "duration", true),
  legendary_max = self.parent:GetTalentValue("modifier_bane_enfeeble_7", "max", true),
  legendary_value = self.parent:GetTalentValue("modifier_bane_enfeeble_7", "value", true)/100,
}

self.has_proc = self.parent:HasTalent("modifier_bane_enfeeble_3")
self.proc_chance = self.parent:GetTalentValue("modifier_bane_enfeeble_3", "chance", true)
self.proc_damage = self.parent:GetTalentValue("modifier_bane_enfeeble_3", "damage")/100
self.proc_heal = self.parent:GetTalentValue("modifier_bane_enfeeble_3", "heal", true)/100
self.proc_bonus = self.parent:GetTalentValue("modifier_bane_enfeeble_3", "bonus", true)
self.proc_radius = self.parent:GetTalentValue("modifier_bane_enfeeble_3", "radius", true)

self.damageTable = {attacker = self.parent, ability = self.ability, damage_type = self.parent:GetTalentValue("modifier_bane_enfeeble_3", "damage_type", true)}

self:StartIntervalThink(3)
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end 

function modifier_bane_enfeeble_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not self.ability:IsActivated() and (not self.ability.active_mod or self.ability.active_mod:IsNull()) then
  self.ability:StartCd()
end

end

function modifier_bane_enfeeble_custom_tracker:UpdateTalent(name)

if name == "modifier_bane_enfeeble_1" or self.parent:HasTalent("modifier_bane_enfeeble_1") then
  self.ability.talents.speed_inc = self.parent:GetTalentValue("modifier_bane_enfeeble_1", "speed")
  self.ability.talents.reduce_inc = self.parent:GetTalentValue("modifier_bane_enfeeble_1", "damage")
end

if name == "modifier_bane_enfeeble_2" or self.parent:HasTalent("modifier_bane_enfeeble_2") then
  self.ability.talents.damage_inc = self.parent:GetTalentValue("modifier_bane_enfeeble_2", "damage")
  self.ability.talents.health_inc = self.parent:GetTalentValue("modifier_bane_enfeeble_2", "health")
end

if name == "modifier_bane_hero_1" or self.parent:HasTalent("modifier_bane_hero_1") then
  self.ability.talents.status_inc = self.parent:GetTalentValue("modifier_bane_hero_1", "status")
  self.ability.talents.slow_inc = self.parent:GetTalentValue("modifier_bane_hero_1", "slow")
end

if name == "modifier_bane_hero_5" or self.parent:HasTalent("modifier_bane_hero_5") then
  self.ability.talents.has_root = 1
  self.ability.talents.root_range = self.parent:GetTalentValue("modifier_bane_hero_5", "range")/100
end

if name == "modifier_bane_enfeeble_3" or self.parent:HasTalent("modifier_bane_enfeeble_3") then
  self.has_proc = true
  self.proc_damage = self.parent:GetTalentValue("modifier_bane_enfeeble_3", "damage")/100
  self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_bane_enfeeble_4" or self.parent:HasTalent("modifier_bane_enfeeble_4") then
  self.ability.talents.cd_inc = self.parent:GetTalentValue("modifier_bane_enfeeble_4", "cd")
  self.ability.talents.dispel_duration = self.parent:GetTalentValue("modifier_bane_enfeeble_4", "duration")
  self.ability.talents.has_dispel = 1
end

if name == "modifier_bane_enfeeble_7" or self.parent:HasTalent("modifier_bane_enfeeble_7") then
  self.ability.talents.has_legendary = 1
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_bane_enfeeble_custom_tracker:AddCustomTransmitterData() 
return self.ability.talents
end

function modifier_bane_enfeeble_custom_tracker:HandleCustomTransmitterData(data)
if not self.ability then return end
self.ability.talents = data
end

function modifier_bane_enfeeble_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not self.has_proc then return end
if self.parent ~= params.attacker then return end
local target = params.target

if not target:IsUnit() then return end
local chance = target:HasModifier("modifier_bane_enfeeble_custom") and self.proc_chance*self.proc_bonus or self.proc_chance
if not RollPseudoRandomPercentage(chance, 4351, self.parent) then return end

target:EmitSound("Bane.Enfeeble_end")
target:EmitSound("Bane.Enfeeble_end_2")

local effect_cast = ParticleManager:CreateParticle( "particles/bane/enfeeble_damage.vpcf", PATTACH_WORLDORIGIN, target )
ParticleManager:SetParticleControl( effect_cast, 0, target:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.proc_radius*0.7, 0, 0 ) )
ParticleManager:Delete( effect_cast, 0 )

local damage = self.parent:GetAverageTrueAttackDamage(nil)*self.proc_damage
self.damageTable.damage = damage

if self.parent:IsAlive() then
  self.parent:GenericHeal(damage*self.proc_heal, self.ability, nil, nil, "modifier_bane_enfeeble_3")
end

for _,enemy in pairs(self.parent:FindTargets(self.proc_radius, target:GetAbsOrigin())) do
  self.damageTable.victim = enemy
  local real_damage = DoDamage(self.damageTable, "modifier_bane_enfeeble_3")
  if enemy == target then
    target:SendNumber(6, real_damage)
  end
end

end



modifier_bane_enfeeble_custom_legendary = class(mod_hidden)
function modifier_bane_enfeeble_custom_legendary:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.center = self.parent:GetAbsOrigin()

self.radius = self.ability.talents.legendary_radius
self.max_timer = self.ability.talents.dispel_duration

if not IsServer() then return end
self.target = EntIndexToHScript(table.target)

local particle = ParticleManager:CreateParticle( "particles/bane/enfeeble_legendary_aoe.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle, 0, self.center )
ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, 0, 0))
self:AddParticle(particle, false, false, -1, false, false)

self.interval = 0.1
self.count = 0


self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_bane_enfeeble_custom_legendary:OnIntervalThink()
if not IsServer() then return end

if not IsValid(self.target) or not self.target:HasModifier("modifier_bane_enfeeble_custom") then 
  self:Destroy()
  return 
end

if self:GetElapsedTime() > 0.05 and not self.init_sound then
  self.init_sound = true
  self.parent:EmitSound("Bane.Enfeeble_legendary_loop")
end

if (self.target:GetAbsOrigin() - self.center):Length2D() > self.radius then
  self.count = self.count + self.interval
  if self.count >= self.max_timer then
    self.target:RemoveModifierByName("modifier_bane_enfeeble_custom")
    return
  end
else
  self.count = 0
end

end

function modifier_bane_enfeeble_custom_legendary:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Bane.Enfeeble_legendary_loop")
end

function modifier_bane_enfeeble_custom_legendary:IsAura() return true end
function modifier_bane_enfeeble_custom_legendary:GetAuraDuration() return 0.1 end
function modifier_bane_enfeeble_custom_legendary:GetAuraRadius() return self.radius end
function modifier_bane_enfeeble_custom_legendary:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_bane_enfeeble_custom_legendary:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_bane_enfeeble_custom_legendary:GetAuraEntityReject(target) return target ~= self.target end
function modifier_bane_enfeeble_custom_legendary:GetModifierAura() return "modifier_bane_enfeeble_custom_legendary_effect" end


modifier_bane_enfeeble_custom_legendary_effect = class({})
function modifier_bane_enfeeble_custom_legendary_effect:IsHidden() return true end
function modifier_bane_enfeeble_custom_legendary_effect:IsPurgable() return false end
function modifier_bane_enfeeble_custom_legendary_effect:GetEffectName() return "particles/bane/enfeeble_legendary_aoe_debuff.vpcf" end
function modifier_bane_enfeeble_custom_legendary_effect:GetStatusEffectName() return "particles/status_fx/status_effect_nightmare.vpcf" end
function modifier_bane_enfeeble_custom_legendary_effect:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH  end




modifier_bane_enfeeble_custom_legendary_caster = class({})
function modifier_bane_enfeeble_custom_legendary_caster:IsHidden() return false end
function modifier_bane_enfeeble_custom_legendary_caster:IsPurgable() return false end
function modifier_bane_enfeeble_custom_legendary_caster:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.ability.talents.legendary_max
self.value = self.ability.talents.legendary_value
self.model = 4

if not IsServer() then return end

self.RemoveForDuel = true

self.health = table.health*-1
self.damage = table.damage*-1
self.move = table.move*-1
self.speed = table.speed*-1
self.status = table.status*-1
self.range = table.range*-1

self.parent:GenericParticle("particles/units/heroes/hero_bane/bane_enfeeble.vpcf", self, true)
self:SetHasCustomTransmitterData(true)
end

function modifier_bane_enfeeble_custom_legendary_caster:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
  self.parent:GenericParticle("particles/void_spirit/shield_buff.vpcf", self)
end

self:SendBuffRefreshToClients()
self.parent:CalculateStatBonus(true)
end

function modifier_bane_enfeeble_custom_legendary_caster:AddCustomTransmitterData() 
return 
{
  damage = self.damage,
  move = self.move,
  speed = self.speed,
  health = self.health,
  status = self.status,
  range = self.range
} 
end

function modifier_bane_enfeeble_custom_legendary_caster:HandleCustomTransmitterData(data)
self.damage = data.damage
self.move = data.move
self.health = data.health
self.speed = data.speed
self.status = data.status
self.range = data.range
end

function modifier_bane_enfeeble_custom_legendary_caster:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_HEALTH_BONUS,
  MODIFIER_PROPERTY_MODEL_SCALE,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end

function modifier_bane_enfeeble_custom_legendary_caster:GetModifierAttackRangeBonus()
return self.range*(self:GetStackCount()*self.value)
end

function modifier_bane_enfeeble_custom_legendary_caster:GetModifierStatusResistanceStacking() 
return self.status*(self:GetStackCount()*self.value)
end

function modifier_bane_enfeeble_custom_legendary_caster:GetModifierPreAttack_BonusDamage()
return self.damage*(self:GetStackCount()*self.value)
end

function modifier_bane_enfeeble_custom_legendary_caster:GetModifierMoveSpeedBonus_Percentage()
return self.move*(self:GetStackCount()*self.value)
end

function modifier_bane_enfeeble_custom_legendary_caster:GetModifierModelScale()
return self.model*self:GetStackCount()
end

function modifier_bane_enfeeble_custom_legendary_caster:GetModifierHealthBonus()
return self.health*(self:GetStackCount()*self.value)
end

function modifier_bane_enfeeble_custom_legendary_caster:GetModifierAttackSpeedBonus_Constant()
return self.speed*(self:GetStackCount()*self.value)
end





modifier_bane_enfeeble_custom_root = class({})
function modifier_bane_enfeeble_custom_root:IsHidden() return true end
function modifier_bane_enfeeble_custom_root:IsPurgable() return true end
function modifier_bane_enfeeble_custom_root:OnCreated()
self.parent = self:GetParent()
if not IsServer() then return end
self.parent:EmitSound("Bane.Enfeeble_root")
self.parent:GenericParticle("particles/bane/enfeeble_root.vpcf", self)
end

function modifier_bane_enfeeble_custom_root:CheckState()
return
{
  [MODIFIER_STATE_ROOTED] = true
}
end



modifier_bane_enfeeble_custom_slow =  class(mod_hidden)
function modifier_bane_enfeeble_custom_slow:OnCreated(table)
if IsServer() then 
  self:SetStackCount(table.slow)
end

self.slow = self:GetStackCount()*-1
end

function modifier_bane_enfeeble_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_bane_enfeeble_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

