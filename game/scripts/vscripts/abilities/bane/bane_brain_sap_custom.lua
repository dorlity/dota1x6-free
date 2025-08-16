LinkLuaModifier( "modifier_bane_brain_sap_custom", "abilities/bane/bane_brain_sap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_brain_sap_custom_tracker", "abilities/bane/bane_brain_sap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_brain_sap_custom_legendary", "abilities/bane/bane_brain_sap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_brain_sap_custom_auto_cd", "abilities/bane/bane_brain_sap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_brain_sap_custom_shield", "abilities/bane/bane_brain_sap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_brain_sap_custom_shield_auto", "abilities/bane/bane_brain_sap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_brain_sap_custom_shield_auto_cd", "abilities/bane/bane_brain_sap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_brain_sap_custom_fear_cd", "abilities/bane/bane_brain_sap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bane_brain_sap_custom_spells", "abilities/bane/bane_brain_sap_custom", LUA_MODIFIER_MOTION_NONE )

bane_brain_sap_custom = class({})
bane_brain_sap_custom.talents = {}

function bane_brain_sap_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_bane/bane_sap.vpcf", context )
PrecacheResource( "particle", "particles/bane/sap_legendary.vpcf", context )
PrecacheResource( "particle", "particles/bane/sap_mana.vpcf", context )
PrecacheResource( "particle", "particles/bane/sap_legendary_start.vpcf", context )
PrecacheResource( "particle", "particles/bane/brain_shield.vpcf", context )
end

function bane_brain_sap_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_bane_brain_sap_custom_tracker"
end

function bane_brain_sap_custom:GetCooldown(level)
return (self.BaseClass.GetCooldown( self, level ) + self.talents.cd_inc)/math.max(1, self.talents.legendary_cd)
end

function bane_brain_sap_custom:GetAOERadius()
return self:GetSpecialValueFor("radius")
end

function bane_brain_sap_custom:GetCastRange(vLocation, hTarget)
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function bane_brain_sap_custom:GetBehavior()
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end

function bane_brain_sap_custom:GetManaCost(level)
return self.talents.has_legendary == 1 and self:GetCaster():GetMaxMana()*self.talents.legendary_mana or self.BaseClass.GetManaCost(self,level) 
end

function bane_brain_sap_custom:GetCastPoint(iLevel)
return self.BaseClass.GetCastPoint(self) + self.talents.cast_bonus
end

function bane_brain_sap_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end
self:DealDamage(target)
end


function bane_brain_sap_custom:DealDamage(target, is_auto)
local caster = self:GetCaster()
local damage = self:GetSpecialValueFor("brain_sap_damage") + self.talents.damage_bonus
local radius = self:GetSpecialValueFor("radius")
local damage_ability = nil
local visual_caster = self:GetCaster()

if self.talents.has_legendary == 1 then
  damage = damage + (caster:GetMaxMana() - caster:GetMana())*self.talents.legendary_damage/100
end

caster:EmitSound("Hero_Bane.BrainSap")
target:EmitSound("Hero_Bane.BrainSap.Target")

if is_auto then
  damage_ability = "modifier_bane_brain_3"
  damage = damage*self.talents.auto_damage
end

if self.talents.has_fear == 1 and caster:GetHealthPercent() < target:GetHealthPercent() and not is_auto then
  if not target:IsDebuffImmune() and not target:HasModifier("modifier_bane_brain_sap_custom_fear_cd") and not target:HasModifier("modifier_bane_nightmare_custom") then
    target:EmitSound("BS.Rupture_fear")
    target:AddNewModifier(caster, self, "modifier_bane_brain_sap_custom_fear_cd", {duration = self.talents.fear_cd})
    target:AddNewModifier(caster, self, "modifier_nevermore_requiem_fear", {duration = self.talents.fear_duration * (1 - target:GetStatusResistance())})
  end
end

local damage_table = {attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_PURE}

local targets = caster:FindTargets(radius, target:GetAbsOrigin())
for _,unit in pairs(targets) do
  local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_CUSTOMORIGIN, visual_caster )
  ParticleManager:SetParticleControlEnt( effect_cast, 0, visual_caster, PATTACH_POINT_FOLLOW, "attach_hitloc", visual_caster:GetOrigin(), true )
  ParticleManager:SetParticleControlEnt( effect_cast, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
  ParticleManager:ReleaseParticleIndex( effect_cast )

  damage_table.victim = unit
  local real_damage = DoDamage(damage_table, damage_ability)
  if target == unit and not target:IsIllusion() then
    caster:GenericHeal(real_damage, self, nil, nil, damage_ability)
  end
end

end


modifier_bane_brain_sap_custom_tracker = class(mod_hidden)
function modifier_bane_brain_sap_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
  MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_bane_brain_sap_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.legendary_ability = self.parent:FindAbilityByName("bane_brain_sap_custom_legendary")

self.ability.talents =
{
  cd_inc = 0,
  mana_bonus = 0,

  heal_inc = 0,
  damage_bonus = 0,

  auto_damage = 0,
  mana_damage = 0,
  auto_cd = self.parent:GetTalentValue("modifier_bane_brain_3", "cd", true),
  auto_radius = self.parent:GetTalentValue("modifier_bane_brain_3", "radius", true),

  range_bonus = 0,
  move_bonus = 0,

  has_fear = 0,
  cast_bonus = 0,
  fear_cd = 0,
  fear_duration = 0,

  shield_auto = 0,
  shield_overheal = 0,
  shield_cd = self.parent:GetTalentValue("modifier_bane_hero_6", "talent_cd", true),
  shield_health = self.parent:GetTalentValue("modifier_bane_hero_6", "health", true),
  shield_duration = self.parent:GetTalentValue("modifier_bane_hero_6", "duration", true),

  spells_regen = 0,
  spells_heal_reduce = 0,
  spells_duration = self.parent:GetTalentValue("modifier_bane_hero_4", "duration", true),

  has_legendary = 0,
  legendary_mana = 0,
  legendary_cd = 0,
  legendary_talent_cd = 0
}

self.has_spells = false
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_bane_brain_sap_custom_tracker:UpdateTalent(name)
  
if name == "modifier_bane_hero_2" or self.parent:HasTalent("modifier_bane_hero_2") then
  self.ability.talents.range_bonus = self.parent:GetTalentValue("modifier_bane_hero_2", "range")
  self.ability.talents.move_bonus = self.parent:GetTalentValue("modifier_bane_hero_2", "move")
end

if name == "modifier_bane_hero_4" or self.parent:HasTalent("modifier_bane_hero_4") then
  self.ability.talents.spells_regen = self.parent:GetTalentValue("modifier_bane_hero_4", "regen")
  self.ability.talents.spells_heal_reduce = self.parent:GetTalentValue("modifier_bane_hero_4", "heal_reduce")
  self.parent:AddSpellEvent(self, true)
  self.has_spells = true
end

if name == "modifier_bane_brain_1" or self.parent:HasTalent("modifier_bane_brain_1") then
  self.ability.talents.mana_bonus = self.parent:GetTalentValue("modifier_bane_brain_1", "mana")
  self.ability.talents.cd_inc = self.parent:GetTalentValue("modifier_bane_brain_1", "cd")
  if IsServer() then
    self.parent:CalculateStatBonus(true)
  end
end

if name == "modifier_bane_brain_2" or self.parent:HasTalent("modifier_bane_brain_2") then
  self.ability.talents.heal_inc = self.parent:GetTalentValue("modifier_bane_brain_2", "heal")
  self.ability.talents.damage_bonus = self.parent:GetTalentValue("modifier_bane_brain_2", "damage")
end

if name == "modifier_bane_brain_3" or self.parent:HasTalent("modifier_bane_brain_3") then
  self:StartIntervalThink(0.2)
  self.has_auto = true
  self.ability.talents.mana_damage = self.parent:GetTalentValue("modifier_bane_brain_3", "mana")
  self.ability.talents.auto_damage = self.parent:GetTalentValue("modifier_bane_brain_3", "damage")/100
end

if name == "modifier_bane_brain_4" or self.parent:HasTalent("modifier_bane_brain_4") then
  self.ability.talents.cast_bonus = self.parent:GetTalentValue("modifier_bane_brain_4", "cast")
  self.ability.talents.fear_cd = self.parent:GetTalentValue("modifier_bane_brain_4", "talent_cd")
  self.ability.talents.fear_duration = self.parent:GetTalentValue("modifier_bane_brain_4", "fear")
  self.ability.talents.has_fear = 1
end

if name == "modifier_bane_hero_6" or self.parent:HasTalent("modifier_bane_hero_6") then
  self.has_shield = true
  self.ability.talents.shield_auto = self.parent:GetTalentValue("modifier_bane_hero_6", "shield_auto")/100
  self.ability.talents.shield_overheal = self.parent:GetTalentValue("modifier_bane_hero_6", "shield")/100
  self.parent:AddDamageEvent_inc(self, true)
  self.parent:AddHealEvent_inc(self, true)
end

if name == "modifier_bane_brain_7" or self.parent:HasTalent("modifier_bane_brain_7") then
  self.ability.talents.has_legendary = 1
  self.ability.talents.legendary_cd = self.parent:GetTalentValue("modifier_bane_brain_7", "cd")
  self.ability.talents.legendary_mana = self.parent:GetTalentValue("modifier_bane_brain_7", "mana")/100
  self.ability.talents.legendary_damage = self.parent:GetTalentValue("modifier_bane_brain_7", "damage")
  self.ability.talents.legendary_talent_cd = self.parent:GetTalentValue("modifier_bane_brain_7", "talent_cd")
  self.legendary_ability.talents.legendary_talent_cd = self.ability.talents.legendary_talent_cd
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_bane_brain_sap_custom_tracker:AddCustomTransmitterData() 
return self.ability.talents
end

function modifier_bane_brain_sap_custom_tracker:HandleCustomTransmitterData(data)
if self.ability then
  self.ability.talents = data
end

if self.legendary_ability then
  self.legendary_ability.talents.legendary_talent_cd = data.legendary_talent_cd
end

end

function modifier_bane_brain_sap_custom_tracker:GetModifierLifestealRegenAmplify_Percentage() 
return self.ability.talents.heal_inc
end

function modifier_bane_brain_sap_custom_tracker:GetModifierHealAmplify_PercentageTarget()
return self.ability.talents.heal_inc
end

function modifier_bane_brain_sap_custom_tracker:GetModifierHPRegenAmplify_Percentage() 
return self.ability.talents.heal_inc
end

function modifier_bane_brain_sap_custom_tracker:GetModifierCastRangeBonusStacking()
return self.ability.talents.range_bonus
end

function modifier_bane_brain_sap_custom_tracker:GetModifierMoveSpeedBonus_Constant()
return self.ability.talents.move_bonus
end

function modifier_bane_brain_sap_custom_tracker:GetModifierSpellAmplify_Percentage()
if self.ability.talents.mana_damage == 0 then return end
return self.parent:GetMaxMana()/self.ability.talents.mana_damage
end

function modifier_bane_brain_sap_custom_tracker:GetModifierPercentageManacostStacking(params)
if self.ability.talents.has_legendary == 0 then return end
if not params.ability or params.ability == self.ability then return end
return 100
end

function modifier_bane_brain_sap_custom_tracker:GetModifierExtraManaPercentage()
return self.ability.talents.mana_bonus
end

function modifier_bane_brain_sap_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self.has_auto then return end
if self.parent:HasModifier("modifier_bane_brain_sap_custom_auto_cd") then return end
if not self.parent:IsAlive() or self.parent:IsInvisible() then return end

local target = self.parent:RandomTarget(self.ability.talents.auto_radius)
if not target or target:HasModifier("modifier_bane_nightmare_custom") then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_brain_sap_custom_auto_cd", {duration = self.ability.talents.auto_cd})
self.ability:DealDamage(target, true)
end

function modifier_bane_brain_sap_custom_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if not self.has_shield then return end
if self.parent:HasModifier("modifier_bane_brain_sap_custom_shield_auto_cd") then return end
if self.parent ~= params.unit then return end
if self.parent:PassivesDisabled() then return end
if not self.parent:IsAlive() then return end
if self.parent:GetHealthPercent() > self.ability.talents.shield_health then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_brain_sap_custom_shield_auto", {duration = self.ability.talents.shield_duration})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_brain_sap_custom_shield_auto_cd", {duration = self.ability.talents.shield_cd})
end

function modifier_bane_brain_sap_custom_tracker:HealEvent_inc(params)
if not IsServer() then return end
if not self.has_shield then return end
if params.unit ~= self.parent then return end
if not params.inflictor then return end

local final = params.prev_health + params.gain

if final <= self.parent:GetMaxHealth() then return end
local above = final - self.parent:GetMaxHealth()

self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_brain_sap_custom_shield", {shield = above})
end

function modifier_bane_brain_sap_custom_tracker:SpellEvent(params)
if not IsServer() then return end
if not self.has_spells then return end
if params.unit ~= self.parent then return end
if params.ability:IsItem() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_brain_sap_custom_spells", {duration = self.ability.talents.spells_duration})

if params.target then
  params.target:AddNewModifier(self.parent, self.ability, "modifier_bane_brain_sap_custom_spells", {duration = self.ability.talents.spells_duration})
end

end





bane_brain_sap_custom_legendary = class({})
bane_brain_sap_custom_legendary.talents = {}

function bane_brain_sap_custom_legendary:CreateTalent()
self:SetHidden(false)
end

function bane_brain_sap_custom_legendary:GetCooldown()
return self.talents.legendary_talent_cd
end

function bane_brain_sap_custom_legendary:OnAbilityPhaseStart()
local caster = self:GetCaster()
if caster:GetManaPercent() >= 99 then
  CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#bane_full_mana"})
  return false
end
return true
end

function bane_brain_sap_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local duration = caster:GetTalentValue("modifier_bane_brain_7", "duration")

caster:EmitSound("Bane.Sap_legendary_voice")
caster:EmitSound("Bane.Sap_legendary_cast")
caster:EmitSound("Bane.Sap_legendary_cast2")

caster:GenericParticle("particles/bane/sap_legendary_start.vpcf")
caster:AddNewModifier(caster, self, "modifier_bane_brain_sap_custom_legendary", {duration = duration})
end


modifier_bane_brain_sap_custom_legendary = class(mod_visible)
function modifier_bane_brain_sap_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_reduce = self.parent:GetTalentValue("modifier_bane_brain_7", "damage_reduce")
self.mana = 100/self:GetRemainingTime()

if not IsServer() then return end
self.parent:GenericParticle("particles/generic_gameplay/generic_sleep.vpcf", self, true)
self.parent:GenericParticle("particles/bane/sap_legendary.vpcf", self)
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_DISABLED, 0.5)

self.interval = 0.1

self.effect_interval = 0.5
self.effect_count = 0

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_bane_brain_sap_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.effect_count = self.effect_count + self.interval
if self.effect_count >= self.effect_interval then
  self.effect_count = 0
  self.parent:GenericParticle("particles/bane/sap_mana.vpcf")
end

local mana = self.mana*self.interval*self.parent:GetMaxMana()/100
self.parent:GiveMana(mana)

if self.parent:GetManaPercent() >= 99 then
  self:Destroy()
  return
end

end

function modifier_bane_brain_sap_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_nightmare.vpcf"
end

function modifier_bane_brain_sap_custom_legendary:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end

function modifier_bane_brain_sap_custom_legendary:CheckState()
return
{
  [MODIFIER_STATE_STUNNED] = true,
}
end

function modifier_bane_brain_sap_custom_legendary:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Bane.Sap_legendary_cast")
self.parent:EmitSound("Bane.Sap_legendary_end")
self.parent:FadeGesture(ACT_DOTA_DISABLED)
end

function modifier_bane_brain_sap_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_bane_brain_sap_custom_legendary:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end


modifier_bane_brain_sap_custom_auto_cd = class(mod_cd)
function modifier_bane_brain_sap_custom_auto_cd:GetTexture() return "buffs/bane/brain_3" end

modifier_bane_brain_sap_custom_shield_auto_cd = class(mod_cd)
function modifier_bane_brain_sap_custom_shield_auto_cd:GetTexture() return "buffs/bane/hero_6" end


modifier_bane_brain_sap_custom_fear_cd = class(mod_hidden)
function modifier_bane_brain_sap_custom_fear_cd:RemoveOnDeath() return false end
function modifier_bane_brain_sap_custom_fear_cd:OnCreated()
self.RemoveForDuel = true
end


modifier_bane_brain_sap_custom_shield = class(mod_visible)
function modifier_bane_brain_sap_custom_shield:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_bane_brain_sap_custom_shield:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.shield = self.ability.talents.shield_overheal
self.max_shield = self.shield*self.parent:GetMaxHealth()

if not IsServer() then return end
self.RemoveForDuel = true

self.shield_talent = "modifier_bane_hero_6"
self.cast_effect = ParticleManager:CreateParticle("particles/bane/brain_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.cast_effect, 0,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControl( self.cast_effect, 1, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControlEnt( self.cast_effect, 2,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
self:AddParticle( self.cast_effect, false, false, -1, false, false  )

self:SetHasCustomTransmitterData(true)
self:AddShield(table.shield)
end

function modifier_bane_brain_sap_custom_shield:OnRefresh(table)
if not IsServer() then return end
self:AddShield(table.shield)
end

function modifier_bane_brain_sap_custom_shield:AddShield(shield)
if not IsServer() then return end
self.max_shield = self.shield*self.parent:GetMaxHealth()
self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + shield))
self:SendBuffRefreshToClients()
end

function modifier_bane_brain_sap_custom_shield:AddCustomTransmitterData() 
return 
{
  max_shield = self.max_shield,
} 
end

function modifier_bane_brain_sap_custom_shield:HandleCustomTransmitterData(data)
self.max_shield = data.max_shield
end

function modifier_bane_brain_sap_custom_shield:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() == 0 then return end

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end

local real_damage = params.damage
local mod = self.parent:FindModifierByName("modifier_bane_fiends_grip_custom_absorb")
if mod and mod.damage_reduce then
  real_damage = real_damage * (1 + mod.damage_reduce/100)
end

local damage = math.min(real_damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end




modifier_bane_brain_sap_custom_shield_auto = class(mod_hidden)
function modifier_bane_brain_sap_custom_shield_auto:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_bane_brain_sap_custom_shield_auto:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max_shield = self.ability.talents.shield_auto*self.parent:GetMaxHealth()

if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(self.max_shield)
self.shield_talent = "modifier_bane_hero_6"
self.parent:EmitSound("Bane.Sap_shield")
self.cast_effect = ParticleManager:CreateParticle("particles/bane/brain_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.cast_effect, 0,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControl( self.cast_effect, 1, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControlEnt( self.cast_effect, 2,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
self:AddParticle( self.cast_effect, false, false, -1, false, false  )
end


function modifier_bane_brain_sap_custom_shield_auto:GetModifierIncomingDamageConstant( params )
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



modifier_bane_brain_sap_custom_spells = class(mod_visible)
function modifier_bane_brain_sap_custom_spells:IsHidden() return not self.is_friend end
function modifier_bane_brain_sap_custom_spells:GetTexture() return "buffs/bane/hero_4" end
function modifier_bane_brain_sap_custom_spells:OnCreated()
self.ability = self:GetAbility()
self.is_friend = self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber()

self.heal_reduce = self.ability.talents.spells_heal_reduce
self.regen = self.ability.talents.spells_regen

if self.is_friend then
  self.heal_reduce = 0
else
  self.regen = 0
end

end

function modifier_bane_brain_sap_custom_spells:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE, 
}
end

function modifier_bane_brain_sap_custom_spells:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_bane_brain_sap_custom_spells:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end

function modifier_bane_brain_sap_custom_spells:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_bane_brain_sap_custom_spells:GetModifierHealthRegenPercentage() 
return self.regen
end