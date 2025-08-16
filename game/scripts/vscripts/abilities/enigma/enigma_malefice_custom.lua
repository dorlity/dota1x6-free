LinkLuaModifier( "modifier_enigma_malefice_custom", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_malefice_custom_tracker", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_malefice_custom_legendary", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_malefice_custom_legendary_stun", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_malefice_custom_legendary_effect", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_malefice_custom_speed", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_malefice_custom_stun_cd", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_malefice_custom_str", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_malefice_custom_speed_change", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_malefice_custom_shield", "abilities/enigma/enigma_malefice_custom", LUA_MODIFIER_MOTION_NONE )



enigma_malefice_custom = class({})

enigma_malefice_custom.active_mod = nil

function enigma_malefice_custom:CreateTalent()
self:ToggleAutoCast()
end


function enigma_malefice_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_enigma/enigma_malefice.vpcf", context )
PrecacheResource( "particle", "particles/enigma/malefice_legendary_stack.vpcf", context )
PrecacheResource( "particle", "particles/enigma/malefice_legendary_stack_max.vpcf", context )
PrecacheResource( "particle", "particles/enigma/malefice_legendary_damage.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/enigma/malefice_shield.vpcf", context )

end

function enigma_malefice_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_enigma_malefice_custom_legendary") then
    return "malefice_legendary"
end 
return "enigma_malefice"
end

function enigma_malefice_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_enigma_malefice_custom_tracker"
end

function enigma_malefice_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_enigma_malefice_3") then
  bonus = self:GetCaster():GetTalentValue("modifier_enigma_malefice_3", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function enigma_malefice_custom:GetCastRange(vLocation, hTarget)
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end


function enigma_malefice_custom:GetBehavior()
local caster = self:GetCaster()
if caster:HasModifier("modifier_enigma_malefice_custom_legendary") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
local bonus = 0
if caster:HasTalent("modifier_enigma_malefice_6") then
  bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + bonus
end


function enigma_malefice_custom:GetManaCost(level)
local caster = self:GetCaster()
if caster:HasModifier("modifier_enigma_malefice_custom_legendary") then
  return 0
end
return self.BaseClass.GetManaCost(self,level) 
end


function enigma_malefice_custom:GetCastAnimation()
local caster = self:GetCaster()
if caster:HasModifier("modifier_enigma_malefice_custom_legendary") then
  return ACT_DOTA_MIDNIGHT_PULSE
end
return ACT_DOTA_CAST_ABILITY_1
end


function enigma_malefice_custom:GetCastPoint(iLevel)
local caster = self:GetCaster()
if caster:HasModifier("modifier_enigma_malefice_custom_legendary") then
  return 0.1
end
local bonus = 0
if caster:HasTalent("modifier_enigma_malefice_5") then
  bonus = caster:GetTalentValue("modifier_enigma_malefice_5", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function enigma_malefice_custom:GetDamage()
local caster = self:GetCaster()
local damage = self:GetSpecialValueFor("damage")
if caster:HasTalent("modifier_enigma_malefice_3") then
  damage = damage + caster:GetAverageTrueAttackDamage(nil)*caster:GetTalentValue("modifier_enigma_malefice_3", "damage")/100
end
return damage
end


function enigma_malefice_custom:ProcStun(target, sound)
local caster = self:GetCaster()
local damage = self:GetDamage()
local stun = self:GetSpecialValueFor("stun_duration") + caster:GetTalentValue("modifier_enigma_malefice_2", "stun")

if sound then
  target:EmitSound("Hero_Enigma.MaleficeTick")
end

local mod = target:FindModifierByName("modifier_enigma_malefice_custom") 

if mod and caster:HasTalent("modifier_enigma_malefice_7") then
  damage = damage * (1 + mod:GetStackCount()*mod.legendary_damage)
end

if caster:HasTalent("modifier_enigma_malefice_1") then
  local duration = caster:GetTalentValue("modifier_enigma_malefice_1", "duration")
  caster:AddNewModifier(caster, self, "modifier_enigma_malefice_custom_speed_change", {duration = duration})
  target:AddNewModifier(caster, self, "modifier_enigma_malefice_custom_speed_change", {duration = duration})
end

if caster:HasTalent("modifier_enigma_malefice_6") then
  target:AddNewModifier(caster, self, "modifier_generic_vision", {duration = caster:GetTalentValue("modifier_enigma_malefice_6", "vision_duration")})
end

if caster:HasTalent("modifier_enigma_malefice_4") or caster:HasShard() then
  local speed_duration = caster:GetTalentValue("modifier_enigma_malefice_4", "duration", true)
  local speed_radius = caster:GetTalentValue("modifier_enigma_malefice_4", "radius", true)

  for _,ally in pairs(target:FindTargets(speed_radius)) do
    if ally:IsUnit() and ally:GetTeamNumber() == caster:GetTeamNumber() then
      ally:AddNewModifier(caster, self, "modifier_enigma_malefice_custom_speed", {duration = speed_duration})
    end
  end
end

if target:IsRealHero() and caster:GetQuest() == "Enigma.Quest_5" and not caster:QuestCompleted() then
  caster:UpdateQuest(1)
end

target:AddNewModifier(caster, self, "modifier_stunned", {duration = (1 - target:GetStatusResistance())*stun})
DoDamage({victim = target, attacker = caster, damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})
target:SendNumber(4, damage)
end




function enigma_malefice_custom:OnSpellStart(new_target)
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if new_target then
  target = new_target
end

local mod = caster:FindModifierByName("modifier_enigma_malefice_custom_legendary")
if mod then
  mod:Destroy()
  if self.active_mod and not self.active_mod:IsNull() then
    self.active_mod:LegendaryProc()
  end
  return
end

if not target or target:IsNull() then return end

if target:TriggerSpellAbsorb(self) then
 return 
end

if caster:HasShard() then
  local ability = caster:FindAbilityByName("enigma_demonic_conversion_custom")
  if ability and ability:GetLevel() > 0 then
    local spawn_duration = self:GetSpecialValueFor("shard_summon_duration")
    for i = 1,self:GetSpecialValueFor("shard_count") do
      ability:SummonUnit(target:GetAbsOrigin() + RandomVector(250), 0, spawn_duration)
    end
  end
end

if caster:HasTalent("modifier_enigma_malefice_6") and self:GetAutoCastState() then 

  local dir = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
  local point = caster:GetAbsOrigin() - dir*100
  local distance = (point - target:GetAbsOrigin()):Length2D()
  local max_dist = caster:GetTalentValue("modifier_enigma_malefice_6", "range")

  distance = math.min(max_dist, math.max(40, distance))
  point = target:GetAbsOrigin() + dir*distance

  local mod = target:AddNewModifier( caster, self,  "modifier_generic_arc",  
  {
    target_x = point.x,
    target_y = point.y,
    distance = distance,
    duration = 0.4,
    height = 0,
    fix_end = false,
    isStun = false,
    activity = ACT_DOTA_FLAIL,
  })

  if mod then 
    target:GenericParticle("particles/void_astral_slow.vpcf", mod)
  end 
end

local max = self:GetSpecialValueFor("stun_instances") + caster:GetTalentValue("modifier_enigma_malefice_5", "stun")
local interval = self:GetSpecialValueFor("tick_rate")
local duration = (max - 1)*interval

self.active_mod =  target:AddNewModifier(caster, self, "modifier_enigma_malefice_custom", {duration = duration + 0.1})

if caster:HasTalent("modifier_enigma_malefice_7") then
  caster:AddNewModifier(caster, self, "modifier_enigma_malefice_custom_legendary", {})
  self:EndCooldown()
  self:StartCooldown(0.5)
else
  self:EndCd()
end

target:EmitSound("Hero_Enigma.Malefice")
end




modifier_enigma_malefice_custom = class({})
function modifier_enigma_malefice_custom:IsHidden() return false end
function modifier_enigma_malefice_custom:GetTexture() return "enigma_malefice" end
function modifier_enigma_malefice_custom:IsPurgable() return not self:GetCaster():HasShard() end
function modifier_enigma_malefice_custom:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.max_duration = self:GetRemainingTime()
self.max = self.ability:GetSpecialValueFor("stun_instances") + self.caster:GetTalentValue("modifier_enigma_malefice_5", "stun")
self.max_interval = self.ability:GetSpecialValueFor("tick_rate")

self.shield_max = self.caster:GetTalentValue("modifier_enigma_malefice_6", "max", true)
self.shield_duration = self.caster:GetTalentValue("modifier_enigma_malefice_6", "duration", true)

self.legendary_max = self.caster:GetTalentValue("modifier_enigma_malefice_7", "max", true)
self.legendary_damage = self.caster:GetTalentValue("modifier_enigma_malefice_7", "damage_inc", true)/100

self.count = 0

if not IsServer() then return end
self.RemoveForDuel = true

self.damage_count = self.max_interval
self.interval = 0.1

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_enigma_malefice_custom:OnIntervalThink()
if not IsServer() then return end

if self.caster:HasTalent("modifier_enigma_malefice_7") and not self.ended then
  self.caster:UpdateUIshort({max_time = self.max_duration, time = self:GetRemainingTime(), stack = self:GetStackCount(), priority = 1, style = "EnigmaMalefice" })
end

self.damage_count = self.damage_count + self.interval
if self.damage_count < self.max_interval - 0.03 then return end
self.damage_count = 0

self.ability:ProcStun(self.parent, self.count ~= 0)

self.count = self.count + 1

if self.caster:HasTalent("modifier_enigma_malefice_6") and self.count <= self.shield_max and self.caster:IsAlive() then
  self.caster:AddNewModifier(self.caster, self.ability, "modifier_enigma_malefice_custom_shield", {duration = self.shield_duration})
end

if self.count >= self.max and not self.caster:HasTalent("modifier_enigma_malefice_7") then
  self:Destroy()
end

end

function modifier_enigma_malefice_custom:LegendaryProc()
if not IsServer() then return end
if self.legendary_proc then return end

self.legendary_proc = true

local stun = self:GetStackCount()*self.caster:GetTalentValue("modifier_enigma_malefice_7", "stun")
local damage = self:GetStackCount()*self.caster:GetTalentValue("modifier_enigma_malefice_7", "damage")*self.ability:GetDamage()/100
local radius = self.caster:GetTalentValue("modifier_enigma_malefice_7", "radius")

self.parent:EmitSound("Enigma.Malefice_legendary_damage")
self.parent:EmitSound("Enigma.Malefice_legendary_damage2")

CreateModifierThinker(self.caster, self.ability, "modifier_enigma_malefice_custom_legendary_effect", {duration = math.max(1, stun)}, self.parent:GetAbsOrigin(), self.caster:GetTeamNumber(), false)

for _,aoe_target in pairs(self.caster:FindTargets(radius, self.parent:GetAbsOrigin())) do
  aoe_target:AddNewModifier(self.caster, self.caster:BkbAbility(self.ability, true), "modifier_enigma_malefice_custom_legendary_stun", {duration = (1 - aoe_target:GetStatusResistance())*stun})
  local real_damage = DoDamage({victim = aoe_target, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage}, "modifier_enigma_malefice_7")
  aoe_target:SendNumber(24, real_damage)

end

self:Destroy()
end




function modifier_enigma_malefice_custom:AddStack()
if not IsServer() then return end
if self:GetStackCount() >= self.legendary_max then return end

if not self.effect then
  self.effect = self.parent:GenericParticle("particles/enigma/malefice_legendary_stack.vpcf", self ,true)
end

self:IncrementStackCount()

if self:GetStackCount() >= self.legendary_max then
  ParticleManager:DestroyParticle(self.effect, false)
  ParticleManager:ReleaseParticleIndex(self.effect)

  self.effect = self.parent:GenericParticle("particles/enigma/malefice_legendary_stack_max.vpcf", self ,true)
  ParticleManager:SetParticleControl(self.effect, 1, Vector(1, self:GetStackCount() - 10, 0))
else
  ParticleManager:SetParticleControl(self.effect, 1, Vector(0, self:GetStackCount(), 0))
end

end


function modifier_enigma_malefice_custom:GetStatusEffectName()
return "particles/status_fx/status_effect_enigma_malefice.vpcf"
end

function modifier_enigma_malefice_custom:GetEffectName()
return "particles/units/heroes/hero_enigma/enigma_malefice.vpcf"
end

function modifier_enigma_malefice_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end


function modifier_enigma_malefice_custom:OnDestroy()
if not IsServer() then return end

if self.caster:HasTalent("modifier_enigma_malefice_7") then
  self:LegendaryProc()
  self.ended = true
  self.caster:UpdateUIshort({hide = 1, hide_full = 1, priority = 1, style = "EnigmaMalefice" })
end

self.caster:RemoveModifierByName("modifier_enigma_malefice_custom_legendary")
self.ability.active_mod = nil
self.ability:StartCd()
end




modifier_enigma_malefice_custom_tracker = class({})
function modifier_enigma_malefice_custom_tracker:IsHidden() return true end
function modifier_enigma_malefice_custom_tracker:IsPurgable() return false end
function modifier_enigma_malefice_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.stun_cd = self.parent:GetTalentValue("modifier_enigma_malefice_5", "cd", true)

self.str_duration = self.parent:GetTalentValue("modifier_enigma_malefice_4", "str_duration", true)

if not IsServer() then return end

if self.parent:IsRealHero() then
  self.parent:AddAttackEvent_inc(self)
end

self.parent:AddAttackEvent_out(self)
self:StartIntervalThink(1)
end

function modifier_enigma_malefice_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
}
end


function modifier_enigma_malefice_custom_tracker:GetModifierCastRangeBonusStacking()
if not self.parent:HasTalent("modifier_enigma_malefice_2") then return end 
return self.parent:GetTalentValue("modifier_enigma_malefice_2", "range")
end

function modifier_enigma_malefice_custom_tracker:AttackEvent_inc(params)
if not IsServer() then return end
if not params.target:IsUnit() then return end

local attacker = params.attacker
local target = params.target

if self.parent:HasTalent("modifier_enigma_malefice_5") and self.parent == target and attacker:IsUnit() and attacker:IsAlive() 
  and not attacker:HasModifier("modifier_enigma_malefice_custom_stun_cd") then

  attacker:AddNewModifier(attacker, self, "modifier_enigma_malefice_custom_stun_cd", {duration = self.stun_cd})
  self.ability:ProcStun(attacker, true)
end

end

function modifier_enigma_malefice_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not params.target:IsUnit() then return end

local attacker = params.attacker
local target = params.target

if attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end

if self.parent == attacker and self.parent:HasTalent("modifier_enigma_malefice_4") and not target:IsCreep() and not self.parent:PassivesDisabled() then
  target:AddNewModifier(self.parent, self.ability, "modifier_enigma_malefice_custom_str", {duration = self.str_duration})
end

if not self.parent:HasTalent("modifier_enigma_malefice_7") then return end

local mod = target:FindModifierByName("modifier_enigma_malefice_custom")

if not mod then return end

if attacker.owner == self.parent and attacker:HasModifier("modifier_enigma_demonic_conversion_custom") then
  mod:SetDuration(mod.max_duration, true)
end

if attacker == self.parent then
  mod:AddStack()
end

end


function modifier_enigma_malefice_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not self.ability:IsActivated() and (not self.ability.active_mod or self.ability.active_mod:IsNull()) then
  self.ability.active_mod = nil
  self.ability:StartCd()
end

end



modifier_enigma_malefice_custom_legendary = class({})
function modifier_enigma_malefice_custom_legendary:IsHidden() return true end
function modifier_enigma_malefice_custom_legendary:IsPurgable() return false end
function modifier_enigma_malefice_custom_legendary:RemoveOnDeath() return false end




modifier_enigma_malefice_custom_legendary_stun = class({})
function modifier_enigma_malefice_custom_legendary_stun:IsHidden() return true end
function modifier_enigma_malefice_custom_legendary_stun:IsPurgable() return false end
function modifier_enigma_malefice_custom_legendary_stun:IsStunDebuff() return true end
function modifier_enigma_malefice_custom_legendary_stun:IsPurgeException() return true end
function modifier_enigma_malefice_custom_legendary_stun:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA  end
function modifier_enigma_malefice_custom_legendary_stun:GetStatusEffectName() return "particles/status_fx/status_effect_enigma_blackhole_tgt.vpcf" end
function modifier_enigma_malefice_custom_legendary_stun:CheckState()
return
{
    [MODIFIER_STATE_STUNNED] = true
}
end
function modifier_enigma_malefice_custom_legendary_stun:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_FLAIL, 0.1)
end

function modifier_enigma_malefice_custom_legendary_stun:OnDestroy()
if not IsServer() then return end
self.parent:FadeGesture(ACT_DOTA_FLAIL)
end


function modifier_enigma_malefice_custom_legendary_stun:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_VISUAL_Z_DELTA
}
end


function modifier_enigma_malefice_custom_legendary_stun:GetVisualZDelta()
return 50
end





modifier_enigma_malefice_custom_legendary_effect = class({})
function modifier_enigma_malefice_custom_legendary_effect:IsHidden() return true end
function modifier_enigma_malefice_custom_legendary_effect:IsPurgable() return false end

function modifier_enigma_malefice_custom_legendary_effect:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max_time = self:GetRemainingTime()
local radius = self.caster:GetTalentValue("modifier_enigma_malefice_7", "radius")

self.effect = ParticleManager:CreateParticle("particles/enigma/malefice_legendary_damage.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( self.effect, 0, self.parent:GetOrigin())
ParticleManager:SetParticleControl( self.effect, 1, Vector(radius, radius, self.max_time) )
ParticleManager:SetParticleControl( self.effect, 4, Vector(0, 0, 0) )
self:AddParticle( self.effect, false, false, -1, false, false  )

self:StartIntervalThink(self.max_time*0.8)
end



function modifier_enigma_malefice_custom_legendary_effect:OnIntervalThink()
if not IsServer() then return end

if self.effect then
  ParticleManager:SetParticleControl( self.effect, 4, Vector(1, 0, 0) )
end

self:StartIntervalThink(-1)
end




modifier_enigma_malefice_custom_speed = class({})
function modifier_enigma_malefice_custom_speed:IsHidden() return false end
function modifier_enigma_malefice_custom_speed:IsPurgable() return false end
function modifier_enigma_malefice_custom_speed:GetTexture() return "buffs/malefice_speed" end
function modifier_enigma_malefice_custom_speed:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.range = self.ability:GetSpecialValueFor("shard_range")
self.speed = self.caster:GetTalentValue("modifier_enigma_malefice_4", "speed")
end

function modifier_enigma_malefice_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_enigma_malefice_custom_speed:GetModifierAttackSpeedBonus_Constant()
if not self.caster:HasTalent("modifier_enigma_malefice_4") then return end
return self.speed
end

function modifier_enigma_malefice_custom_speed:GetModifierAttackRangeBonus()
if not self.caster:HasShard() then return end
return self.range
end


modifier_enigma_malefice_custom_stun_cd = class({})
function modifier_enigma_malefice_custom_stun_cd:IsHidden() return true end
function modifier_enigma_malefice_custom_stun_cd:IsPurgable() return false end
function modifier_enigma_malefice_custom_stun_cd:RemoveOnDeath() return false end


modifier_enigma_malefice_custom_str = class({})
function modifier_enigma_malefice_custom_str:IsHidden() return false end
function modifier_enigma_malefice_custom_str:IsPurgable() return false end
function modifier_enigma_malefice_custom_str:GetTexture() return "buffs/malefice_speed" end
function modifier_enigma_malefice_custom_str:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.max = self.caster:GetTalentValue("modifier_enigma_malefice_4", "max")
self.str = self.caster:GetTalentValue("modifier_enigma_malefice_4", "str")/self.max

if not IsServer() then return end
self:IncStack()
end

function modifier_enigma_malefice_custom_str:OnRefresh(table)
if not IsServer() then return end
self:IncStack()
end

function modifier_enigma_malefice_custom_str:IncStack()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
self.PercentStr = self.str*self:GetStackCount()/100
end

function modifier_enigma_malefice_custom_str:OnDestroy()
if not IsServer() then return end
self.parent:PercentRefresh()
end


function modifier_enigma_malefice_custom_str:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_enigma_malefice_custom_str:OnTooltip()
return self:GetStackCount()*self.str
end





modifier_enigma_malefice_custom_speed_change = class({})
function modifier_enigma_malefice_custom_speed_change:IsHidden() return false end
function modifier_enigma_malefice_custom_speed_change:IsPurgable() return false end
function modifier_enigma_malefice_custom_speed_change:GetTexture() return "buffs/malefice_slow" end
function modifier_enigma_malefice_custom_speed_change:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_enigma_malefice_1", "max")
self.speed = self.caster:GetTalentValue("modifier_enigma_malefice_1", "slow")

if self.parent == self.caster then
  self.speed = self.caster:GetTalentValue("modifier_enigma_malefice_1", "speed")
end

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_enigma_malefice_custom_speed_change:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max and self.caster ~= self.parent then
  self.parent:GenericParticle("particles/void_astral_slow.vpcf", self)
end

end

function modifier_enigma_malefice_custom_speed_change:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_enigma_malefice_custom_speed_change:GetModifierMoveSpeedBonus_Percentage()
return self.speed*self:GetStackCount()
end






modifier_enigma_malefice_custom_shield = class({})
function modifier_enigma_malefice_custom_shield:IsHidden()  return false end
function modifier_enigma_malefice_custom_shield:GetTexture() return "buffs/malefice_shield" end
function modifier_enigma_malefice_custom_shield:IsPurgable() return false end

function modifier_enigma_malefice_custom_shield:OnCreated(table)

self.parent = self:GetParent()

self.shield = self.parent:GetTalentValue("modifier_enigma_malefice_6", "shield")/100
self.max = self.parent:GetTalentValue("modifier_enigma_malefice_6", "max")
self.shield_talent = "modifier_enigma_malefice_6"

self.add_shield =  self.shield*self.parent:GetMaxHealth()
self.max_shield = self.add_shield*self.max

if not IsServer() then return end

self.cast_effect = ParticleManager:CreateParticle("particles/enigma/malefice_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.cast_effect, 0,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControl( self.cast_effect, 1, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControlEnt( self.cast_effect, 2,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
self:AddParticle( self.cast_effect, false, false, -1, false, false  )

self.RemoveForDuel = true
self:AddShield()
end


function modifier_enigma_malefice_custom_shield:OnRefresh()
self:AddShield()
end 

function modifier_enigma_malefice_custom_shield:AddShield()
if not IsServer() then return end
self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + self.add_shield))
end 


function modifier_enigma_malefice_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_enigma_malefice_custom_shield:GetModifierIncomingDamageConstant( params )
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
