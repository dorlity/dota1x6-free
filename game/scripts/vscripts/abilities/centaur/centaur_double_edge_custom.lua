LinkLuaModifier( "modifier_centaur_double_edge_custom_legendary", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_double_edge_custom_legendary_blood", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_double_edge_custom_legendary_blood_count", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_double_edge_custom_tracker", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_double_edge_custom_str", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_double_edge_custom_slow", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_double_edge_custom_shield", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_double_edge_custom_shield_cd", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_double_edge_custom_silence_cd", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_double_edge_custom_silence_ready", "abilities/centaur/centaur_double_edge_custom", LUA_MODIFIER_MOTION_NONE )


centaur_double_edge_custom = class({})

function centaur_double_edge_custom:CreateTalent()
self:ToggleAutoCast()
local caster = self:GetCaster()
caster:AddNewModifier(caster, self, "modifier_centaur_double_edge_custom_silence_ready", {})
end

function centaur_double_edge_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/centaur/double_edge.vpcf", context )
PrecacheResource( "particle", "particles/centaur/edge_legendary_caster.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", context )
PrecacheResource( "particle", "particles/brist_proc.vpcf", context )
PrecacheResource( "particle", "particles/centaur/edge_shield.vpcf", context )
PrecacheResource( "particle", "particles/centaur/edge_stack.vpcf", context )
PrecacheResource( "particle", "particles/centaur/edge_pull_cast.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/centaur/centaur_2022_immortal/centaur_2022_immortal_stampede_cast.vpcf", context )

end

function centaur_double_edge_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_centaur_double_edge_custom_tracker"
end

function centaur_double_edge_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasTalent("modifier_centaur_edge_5") then
  bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + bonus
end

function centaur_double_edge_custom:GetCooldown(level)
local k = 1
local bonus = 0
local caster = self:GetCaster()
if caster:HasModifier("modifier_centaur_double_edge_custom_legendary") then
  k = 1 + caster:GetTalentValue("modifier_centaur_edge_7", "cd_inc")/100
end
if caster:HasTalent("modifier_centaur_edge_2") then
  bonus = caster:GetTalentValue("modifier_centaur_edge_2", "cd")
end
return (self.BaseClass.GetCooldown( self, level ) + bonus) * k
end

function centaur_double_edge_custom:GetAOERadius()
return self:GetSpecialValueFor("radius") 
end

function centaur_double_edge_custom:GetCastRange(vLocation, hTarget)
local bonus = 0
local caster = self:GetCaster()
if caster:HasTalent("modifier_centaur_edge_5") and not caster:HasModifier("modifier_centaur_double_edge_custom_silence_cd") and caster:HasModifier("modifier_centaur_double_edge_custom_silence_ready") then
  bonus = caster:GetTalentValue("modifier_centaur_edge_5", "range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + bonus
end

function centaur_double_edge_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_centaur_edge_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_centaur_edge_5", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function centaur_double_edge_custom:OnSpellStart(new_target, auto)
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if new_target then
  target = new_target
end

if not auto then
  if target:TriggerSpellAbsorb(self) then
   return 
  end
end

local mod_shield = caster:FindModifierByName("modifier_centaur_double_edge_custom_shield_cd")
if mod_shield and not auto then
  mod_shield:ReduceCd(caster:GetTalentValue("modifier_centaur_edge_6", "cd_inc"))
end

local point = target:GetAbsOrigin()
local radius = self:GetSpecialValueFor("radius")
local damage_base = self:GetSpecialValueFor("edge_damage")
local damage_str = self:GetSpecialValueFor("strength_damage")

local damage = damage_base + damage_str*caster:GetStrength()/100
if auto then
  damage = damage * caster:GetTalentValue("modifier_centaur_retaliate_4", "damage")/100
end

local targets = caster:FindTargets(radius, point)

if not auto then
  table.insert(targets, caster)
end

local damageTable = {attacker = caster, ability = self, damage_type = DAMAGE_TYPE_MAGICAL}
local damage_bonus = caster:GetTalentValue("modifier_centaur_edge_1", "damage")/100
local self_bonus = caster:GetTalentValue("modifier_centaur_edge_1", "damage_self")/100

local slow_duration = caster:GetTalentValue("modifier_centaur_edge_3", "duration")

local silence_duration = caster:GetTalentValue("modifier_centaur_edge_5", "silence")
local pull_duration = caster:GetTalentValue("modifier_centaur_edge_5", "knock_duration")
local proc_silence = false

if caster:HasTalent("modifier_centaur_edge_5") and not caster:HasModifier("modifier_centaur_double_edge_custom_silence_cd") and not auto and self:GetAutoCastState() then
  proc_silence = true
  caster:AddNewModifier(caster, self, "modifier_centaur_double_edge_custom_silence_cd", {duration = caster:GetTalentValue("modifier_centaur_edge_5", "cd")})
end


for _,target in pairs(targets) do
  damageTable.victim = target
  local real_damage = damage

  if target == caster then
    real_damage = real_damage * (1 + self_bonus)
    damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
  else
    real_damage = real_damage * (1 + damage_bonus)
    damageTable.damage_flags = 0

    if caster:HasTalent("modifier_centaur_edge_3") and not auto then
      target:AddNewModifier(caster, self, "modifier_centaur_double_edge_custom_slow", {duration = slow_duration})
    end

    if proc_silence then
      caster:PullTarget(target, self, pull_duration)
      target:AddNewModifier(caster, self, "modifier_generic_silence", {duration = (1 - target:GetStatusResistance())*silence_duration})

      local chain_effect = ParticleManager:CreateParticle( "particles/centaur/edge_pull_cast.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
      ParticleManager:SetParticleControlEnt(chain_effect, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
      ParticleManager:SetParticleControlEnt(chain_effect, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
      ParticleManager:ReleaseParticleIndex(chain_effect)
      target:EmitSound("Centaur.Edge_pull")
      target:EmitSound("Centaur.Edge_pull2")
    end
  end
  damageTable.damage = real_damage

  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge_body.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex(particle)

  DoDamage(damageTable, auto)
end


if caster:HasTalent("modifier_centaur_edge_4") and not auto then
  local duration = caster:GetTalentValue("modifier_centaur_edge_4", "duration")
  for i = 1, caster:GetTalentValue("modifier_centaur_edge_4", "stack") do
    caster:AddNewModifier(caster, self, "modifier_centaur_double_edge_custom_str", {duration = duration})
  end
end

local vec = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
vec.z = 0

local caster_unit = caster
if auto then
  caster_unit = target
end

local particle_edge_fx = ParticleManager:CreateParticle("particles/centaur/double_edge.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster_unit)
ParticleManager:SetParticleControlEnt(particle_edge_fx, 0, caster_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", caster_unit:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt(particle_edge_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:SetParticleControlForward(particle_edge_fx, 2, vec)
ParticleManager:SetParticleControl(particle_edge_fx, 5, caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc")))
ParticleManager:SetParticleControlForward(particle_edge_fx, 5, vec)
ParticleManager:ReleaseParticleIndex(particle_edge_fx)

target:EmitSound("Hero_Centaur.DoubleEdge")
end





centaur_double_edge_custom_legendary = class({})

function centaur_double_edge_custom_legendary:CreateTalent()
self:SetHidden(false)
end

function centaur_double_edge_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_centaur_edge_7", "cd")
end

function centaur_double_edge_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local duration = caster:GetTalentValue("modifier_centaur_edge_7", "duration")

caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
caster:EmitSound("Centaur.Edge_legendary_cast1")
caster:EmitSound("Centaur.Edge_legendary_cast2")
caster:EmitSound("Centaur.Edge_legendary_cast3")
caster:GenericParticle("particles/econ/items/centaur/centaur_2022_immortal/centaur_2022_immortal_stampede_cast.vpcf")
caster:GenericParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf")
caster:AddNewModifier(caster, self, "modifier_centaur_double_edge_custom_legendary", {duration = duration})
end



modifier_centaur_double_edge_custom_legendary = class({})
function modifier_centaur_double_edge_custom_legendary:IsHidden() return false end
function modifier_centaur_double_edge_custom_legendary:IsPurgable() return false end
function modifier_centaur_double_edge_custom_legendary:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
if not IsServer() then return end
self.RemoveForDuel = true

self.ability:EndCd()

local particle = ParticleManager:CreateParticle("particles/centaur/edge_legendary_caster.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
self:AddParticle(particle, false, false, -1, false, false) 

self.healed = false
self.ended = false
self.max_time = self:GetRemainingTime()

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_centaur_double_edge_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_centaur_double_edge_custom_legendary:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH
end

function modifier_centaur_double_edge_custom_legendary:OnIntervalThink()
if not IsServer() then return end
if self.ended == true then return end

local stack = self:GetStackCount()
if self.healed == true then
  stack = nil
end

self.parent:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = stack, style = "CentaurEdge"})
end


function modifier_centaur_double_edge_custom_legendary:OnDestroy()
if not IsServer() then return end
self.ability:StartCd()

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "CentaurEdge"})

self.ended = true
if self.healed == true then return end
self:ProcHeal()
end


function modifier_centaur_double_edge_custom_legendary:ProcHeal()
if not IsServer() then return end
self.parent:EmitSound("Centaur.Edge_legendary_heal")
self.parent:EmitSound("Centaur.Edge_legendary_heal2")
self.parent:GenericParticle("particles/brist_lowhp_.vpcf")
self.parent:GenericHeal(self:GetStackCount(), self.ability, false, "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", "modifier_centaur_edge_7")
self:SetStackCount(0)
self.healed = true
end

function modifier_centaur_double_edge_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MIN_HEALTH,
}
end


function modifier_centaur_double_edge_custom_legendary:GetMinHealth()
if not IsServer() then return end
if self.healed == true then return end
if not self.parent:IsAlive() then return end
if self:GetStackCount() <= 0 then return end
if self.parent:HasModifier("modifier_death") then return end

return 1
end






modifier_centaur_double_edge_custom_legendary_blood = class({})
function modifier_centaur_double_edge_custom_legendary_blood:IsHidden() return true end
function modifier_centaur_double_edge_custom_legendary_blood:IsPurgable() return false end
function modifier_centaur_double_edge_custom_legendary_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_centaur_double_edge_custom_legendary_blood:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.duration = self.caster:GetTalentValue("modifier_centaur_edge_7", "blood_duration")
self.heal = self.caster:GetTalentValue("modifier_centaur_edge_7", "heal")/100
self.heal_creeps = self.caster:GetTalentValue("modifier_centaur_edge_7", "creeps")
if not IsServer() then return end
self.RemoveForDuel = true

self.mod = self.caster:FindModifierByName("modifier_centaur_double_edge_custom_legendary")
self.damage = table.damage/self.duration
self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage}

self:StartIntervalThink(1)
end

function modifier_centaur_double_edge_custom_legendary_blood:OnIntervalThink()
if not IsServer() then return end
local real_damage = DoDamage(self.damageTable)

if not self.parent:IsIllusion() and self.mod and not self.mod:IsNull() and not self.mod.healed and real_damage > 0 then
  local heal = real_damage*self.heal
  if self.parent:IsCreep() then
    heal = heal/self.heal_creeps
  end
  self.mod:SetStackCount(self.mod:GetStackCount() + heal)
end

self:IncrementStackCount()

if self:GetStackCount() >= self.duration then
  self:Destroy()
end

end


function modifier_centaur_double_edge_custom_legendary_blood:OnDestroy()
if not IsServer() then return end

local mod = self.parent:FindModifierByName("modifier_centaur_double_edge_custom_legendary_blood_count")
if not mod then return end
mod:DecrementStackCount()

if mod:GetStackCount() <= 0 then
  mod:Destroy()
end

end



modifier_centaur_double_edge_custom_legendary_blood_count = class({})
function modifier_centaur_double_edge_custom_legendary_blood_count:IsHidden() return false end
function modifier_centaur_double_edge_custom_legendary_blood_count:IsPurgable() return false end
function modifier_centaur_double_edge_custom_legendary_blood_count:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self:IncrementStackCount()
self.parent:GenericParticle("particles/brist_proc.vpcf")

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)
end

function modifier_centaur_double_edge_custom_legendary_blood_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_centaur_double_edge_custom_legendary_blood_count:GetStatusEffectName()
return "particles/status_fx/status_effect_rupture.vpcf"
end

function modifier_centaur_double_edge_custom_legendary_blood_count:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end







modifier_centaur_double_edge_custom_tracker = class({})
function modifier_centaur_double_edge_custom_tracker:IsHidden() return true end
function modifier_centaur_double_edge_custom_tracker:IsPurgable() return false end
function modifier_centaur_double_edge_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.legendary = self.parent:FindAbilityByName("centaur_double_edge_custom_legendary")

self.blood_duration = self.parent:GetTalentValue("modifier_centaur_edge_7", "blood_duration", true)
self.blood_damage = self.parent:GetTalentValue("modifier_centaur_edge_7", "blood_damage", true)/100

self.resist_bonus = self.parent:GetTalentValue("modifier_centaur_edge_6", "resist", true)

self.slow_duration = self.parent:GetTalentValue("modifier_centaur_edge_3", "duration", true)

self.str_duration = self.parent:GetTalentValue("modifier_centaur_edge_4", "duration", true)

self.shield_health = self.parent:GetTalentValue("modifier_centaur_edge_6", "health", true)
self.shield_duration = self.parent:GetTalentValue("modifier_centaur_edge_6", "duration", true)

self.parent:AddDamageEvent_inc(self)
self.parent:AddDamageEvent_out(self)
self.parent:AddAttackEvent_out(self)
end

function modifier_centaur_double_edge_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

if self.parent:HasTalent("modifier_centaur_edge_4") then
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_centaur_double_edge_custom_str", {duration = self.str_duration})
end

if not self.parent:HasTalent("modifier_centaur_edge_3") then return end
params.target:AddNewModifier(self.parent, self.ability, "modifier_centaur_double_edge_custom_slow", {duration = self.slow_duration})
end


function modifier_centaur_double_edge_custom_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if params.attacker == params.unit then return end

if self.parent == params.unit then
  local mod = self.parent:FindModifierByName("modifier_centaur_double_edge_custom_legendary")

  if mod and mod:GetStackCount() > 0 and mod.healed == false and not self.parent:HasModifier("modifier_death") and self.parent:GetHealth() <= 1 then
    mod:ProcHeal()
  end

  if self.parent:HasTalent("modifier_centaur_edge_6") and self.parent:GetHealthPercent() <= self.shield_health
    and not self.parent:HasModifier("modifier_centaur_double_edge_custom_shield") and not self.parent:HasModifier("modifier_centaur_double_edge_custom_shield_cd") then

    self.parent:AddNewModifier(self.parent, self.ability, "modifier_centaur_double_edge_custom_shield", {duration = self.shield_duration})
  end
end

end

function modifier_centaur_double_edge_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if params.attacker == params.unit then return end

if self.parent ~= params.attacker then return end
if not params.unit:IsUnit() then return end

local unit = params.unit

if not self.parent:HasTalent("modifier_centaur_edge_7") then return end
if not self.parent:HasModifier("modifier_centaur_double_edge_custom_legendary") then return end
if not self.legendary then return end
if params.inflictor and (params.inflictor == self.legendary or params.inflictor:IsItem()) then return end
if params.damage <= 0 then return end

unit:AddNewModifier(self.parent, self.legendary, "modifier_centaur_double_edge_custom_legendary_blood", {damage = params.damage*self.blood_damage})
unit:AddNewModifier(self.parent, self.legendary, "modifier_centaur_double_edge_custom_legendary_blood_count", {duration = self.blood_duration + 0.1})
end

function modifier_centaur_double_edge_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
  MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_centaur_double_edge_custom_tracker:GetModifierSpellAmplify_Percentage()
if not self.parent:HasTalent("modifier_centaur_edge_4") then return end 
return self.parent:GetStrength()/self.parent:GetTalentValue("modifier_centaur_edge_4", "str_spell")
end

function modifier_centaur_double_edge_custom_tracker:GetModifierCastRangeBonusStacking()
if not self.parent:HasTalent("modifier_centaur_edge_2") then return end 
return self.parent:GetTalentValue("modifier_centaur_edge_2", "range")
end

function modifier_centaur_double_edge_custom_tracker:GetModifierMagicalResistanceBonus()
if not self.parent:HasTalent("modifier_centaur_edge_6") then return end 
return self.resist_bonus
end








modifier_centaur_double_edge_custom_str = class({})
function modifier_centaur_double_edge_custom_str:IsHidden() return false end
function modifier_centaur_double_edge_custom_str:IsPurgable() return false end
function modifier_centaur_double_edge_custom_str:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_centaur_edge_4", "max")
self.str = self.parent:GetTalentValue("modifier_centaur_edge_4", "str")/self.max

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_centaur_double_edge_custom_str:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_centaur_double_edge_custom_str:OnStackCountChanged(iStackCount)
if not IsServer() then return end

self.PercentStr = self:GetStackCount()*self.str/100
self.parent:CalculateStatBonus(true)
end

function modifier_centaur_double_edge_custom_str:OnDestroy()
if not IsServer() then return end

self.parent:PercentRefresh()
end


function modifier_centaur_double_edge_custom_str:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_centaur_double_edge_custom_str:OnTooltip()
return self.str*self:GetStackCount()
end

function modifier_centaur_double_edge_custom_str:GetModifierModelScale()
return 2*self:GetStackCount()
end



modifier_centaur_double_edge_custom_slow = class({})
function modifier_centaur_double_edge_custom_slow:IsHidden() return false end
function modifier_centaur_double_edge_custom_slow:IsPurgable() return false end
function modifier_centaur_double_edge_custom_slow:GetTexture() return "buffs/edge_slow" end
function modifier_centaur_double_edge_custom_slow:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.heal = self.caster:GetTalentValue("modifier_centaur_edge_3", "heal_reduce")
self.slow = self.caster:GetTalentValue("modifier_centaur_edge_3", "slow")
self.max = self.caster:GetTalentValue("modifier_centaur_edge_3", "max")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_centaur_double_edge_custom_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
  self.parent:GenericParticle("particles/items2_fx/sange_maim.vpcf", self)
  self.parent:EmitSound("DOTA_Item.Maim")
end

end


function modifier_centaur_double_edge_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_centaur_double_edge_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow*self:GetStackCount()
end

function modifier_centaur_double_edge_custom_slow:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal*self:GetStackCount()
end

function modifier_centaur_double_edge_custom_slow:GetModifierHealAmplify_PercentageTarget()
return self.heal*self:GetStackCount()
end

function modifier_centaur_double_edge_custom_slow:GetModifierHPRegenAmplify_Percentage() 
return self.heal*self:GetStackCount()
end









modifier_centaur_double_edge_custom_shield = class({})
function modifier_centaur_double_edge_custom_shield:IsHidden() return false end
function modifier_centaur_double_edge_custom_shield:IsPurgable() return false end
function modifier_centaur_double_edge_custom_shield:GetTexture() return "buffs/edge_shield" end
function modifier_centaur_double_edge_custom_shield:GetEffectName() return "particles/centaur/edge_shield.vpcf" end
function modifier_centaur_double_edge_custom_shield:OnCreated(table)
self.RemoveForDuel = true
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max_shield = self.parent:GetTalentValue("modifier_centaur_edge_6", "shield")*self.parent:GetMaxHealth()/100

if not IsServer() then return end
self.shield_talent = "modifier_centaur_edge_6"
self:SetStackCount(self.max_shield )
self.parent:EmitSound("Centaur.Edge_shield")
end

function modifier_centaur_double_edge_custom_shield:OnDestroy()
if not IsServer() then return end
self.parent:AddNewModifier(self.parent, self.ability, "modifier_centaur_double_edge_custom_shield_cd", {})
end

function modifier_centaur_double_edge_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_centaur_double_edge_custom_shield:GetModifierIncomingDamageConstant( params )

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


modifier_centaur_double_edge_custom_shield_cd = class({})
function modifier_centaur_double_edge_custom_shield_cd:IsHidden() return false end
function modifier_centaur_double_edge_custom_shield_cd:IsPurgable() return false end
function modifier_centaur_double_edge_custom_shield_cd:RemoveOnDeath() return false end
function modifier_centaur_double_edge_custom_shield_cd:IsDebuff() return true end
function modifier_centaur_double_edge_custom_shield_cd:GetTexture() return "buffs/edge_shield" end
function modifier_centaur_double_edge_custom_shield_cd:OnCreated()
self.parent = self:GetParent()
self.RemoveForDuel = true

if not IsServer() then return end
self:SetStackCount(self.parent:GetTalentValue("modifier_centaur_edge_6", "cd"))
self:StartIntervalThink(1)
end

function modifier_centaur_double_edge_custom_shield_cd:OnIntervalThink()
if not IsServer() then return end
self:ReduceCd(1)
end

function modifier_centaur_double_edge_custom_shield_cd:ReduceCd(count) 
if not IsServer() then return end

for i = 1, count do
  self:DecrementStackCount()

  if self:GetStackCount() <= 0 then
    self:Destroy()
    break
  end
end


end






modifier_centaur_double_edge_custom_silence_cd  = class({})
function modifier_centaur_double_edge_custom_silence_cd:IsHidden() return false end
function modifier_centaur_double_edge_custom_silence_cd:IsPurgable() return false end
function modifier_centaur_double_edge_custom_silence_cd:RemoveOnDeath() return false end
function modifier_centaur_double_edge_custom_silence_cd:IsDebuff() return true end
function modifier_centaur_double_edge_custom_silence_cd:GetTexture() return "buffs/edge_silence" end
function modifier_centaur_double_edge_custom_silence_cd:OnCreated()
self.RemoveForDuel = true
end


modifier_centaur_double_edge_custom_silence_ready = class({})
function modifier_centaur_double_edge_custom_silence_ready:IsHidden() return self:GetParent():HasModifier("modifier_centaur_double_edge_custom_silence_cd") end
function modifier_centaur_double_edge_custom_silence_ready:IsPurgable() return false end
function modifier_centaur_double_edge_custom_silence_ready:RemoveOnDeath() return false end
function modifier_centaur_double_edge_custom_silence_ready:GetTexture() return "buffs/edge_silence" end