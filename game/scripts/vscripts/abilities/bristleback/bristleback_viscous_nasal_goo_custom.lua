LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_custom", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_tracker", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_damage", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_no_stun", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_speed", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_shard_unit", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)

bristleback_viscous_nasal_goo_custom              = class({})




function bristleback_viscous_nasal_goo_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_crimson_nasal_goo_proj.vpcf", context )
PrecacheResource( "particle", "particles/bristle_goo_ground.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_goo.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", context )

end



function bristleback_viscous_nasal_goo_custom:GetIntrinsicModifierName() return "modifier_bristleback_viscous_nasal_goo_tracker" end


function bristleback_viscous_nasal_goo_custom:GetCastPoint(iLevel)
if self:GetCaster():HasShard() then 
  return self:GetSpecialValueFor("cast_shard") 
end

return self.BaseClass.GetCastPoint(self)
end



function bristleback_viscous_nasal_goo_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_bristle_goo_stack") then 
    bonus = self:GetCaster():GetTalentValue("modifier_bristle_goo_stack", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end





function bristleback_viscous_nasal_goo_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end 

function bristleback_viscous_nasal_goo_custom:OnSpellStart(target, vLocation)

local enemy = self:GetCursorTarget()

self.caster = self:GetCaster()

if target ~= nil then 
  enemy = target
end

local shard_radius = 0

local shard_ability = self:GetCaster():FindAbilityByName("bristleback_hairball_custom")
if shard_ability then 
  shard_radius = shard_ability:GetSpecialValueFor("radius")
end 


self.location = self:GetCaster():GetAbsOrigin()
self.source_caster = self:GetCaster()

local shard_unit = nil

local is_shard = 0 
local attach = DOTA_PROJECTILE_ATTACHMENT_ATTACK_3

if vLocation ~= nil then 

  attach = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION

  shard_unit = CreateUnitByName("npc_dota_templar_assassin_psionic_trap", vLocation, false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
  shard_unit:AddNewModifier(unit, self, "modifier_bristleback_viscous_nasal_goo_shard_unit", {duration = 1})

  self.location = shard_unit:GetAbsOrigin()
  self.source_caster = shard_unit
  is_shard = 1

  shard_unit:EmitSound("Hero_Bristleback.ViscousGoo.Cast")
else 

  self.caster:EmitSound("Hero_Bristleback.ViscousGoo.Cast")
end


if not IsServer() then return end




local projectile =
{
  Source        = self.source_caster,
  Ability       = self,
  iSourceAttachment = attach,
  EffectName      = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
  iMoveSpeed      = self:GetSpecialValueFor("goo_speed"),
  vSourceLoc      = self.location,
  bDrawsOnMinimap   = false,
  bDodgeable      = true,
  bIsAttack       = false,
  bVisibleToEnemies = true,
  bReplaceExisting  = false,
  flExpireTime    = GameRules:GetGameTime() + 10,
  bProvidesVision   = false,
  ExtraData = {is_shard = is_shard}
}

if  vLocation ~= nil and shard_unit and not shard_unit:IsNull() then

  for _,target in pairs(self.caster:FindTargets(shard_radius, shard_unit:GetAbsOrigin())) do
    projectile.Target = target
    ProjectileManager:CreateTrackingProjectile(projectile)
  end

else

  if enemy then 
    for _,target in pairs(self:GetCaster():FindTargets(self:GetSpecialValueFor("aoe_radius"), enemy:GetAbsOrigin())) do 
        projectile.Target = target
        ProjectileManager:CreateTrackingProjectile(projectile)
    end 
  end 
end 

    
if self.caster:GetName() == "npc_dota_hero_bristleback" and RollPercentage(40) then
  self.caster:EmitSound("bristleback_bristle_nasal_goo_0"..math.random(1,7))
end

end




function bristleback_viscous_nasal_goo_custom:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
if hTarget == nil or not hTarget:IsAlive() or hTarget:IsMagicImmune() then return end

if ExtraData.is_shard and ExtraData.is_shard == 0 then 
  if hTarget:TriggerSpellAbsorb(self) then return end
end

self:AddStack(hTarget)
end




function bristleback_viscous_nasal_goo_custom:AddStack(target)

local duration = self:GetSpecialValueFor("goo_duration") + self:GetCaster():GetTalentValue("modifier_bristle_goo_max", "duration")

target:AddNewModifier(self:GetCaster(), self, "modifier_bristleback_viscous_nasal_goo_custom", {duration = duration * (1 - target:GetStatusResistance())})
end






modifier_bristleback_viscous_nasal_goo_custom = class({})

function modifier_bristleback_viscous_nasal_goo_custom:IsHidden() return false end
function modifier_bristleback_viscous_nasal_goo_custom:IsPurgable() return true end

function modifier_bristleback_viscous_nasal_goo_custom:GetEffectName()
  return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end

function modifier_bristleback_viscous_nasal_goo_custom:GetStatusEffectName()
  return "particles/status_fx/status_effect_goo.vpcf"
end

function modifier_bristleback_viscous_nasal_goo_custom:StatusEffectPriority()
    return 10
end



function modifier_bristleback_viscous_nasal_goo_custom:OnCreated()
self.ability  = self:GetAbility()
self.caster   = self:GetCaster()
self.parent   = self:GetParent()
self.RemoveForDuel = true

self.armor_per_stack    = self.ability:GetSpecialValueFor("armor_per_stack") + self:GetCaster():GetTalentValue("modifier_bristle_goo_status", "armor")
self.move_slow_per_stack  = self.ability:GetSpecialValueFor("move_slow_per_stack") + self:GetCaster():GetTalentValue("modifier_bristle_goo_stack", "slow")
self.stack_limit      = self.ability:GetSpecialValueFor("stack_limit") + self:GetCaster():GetTalentValue("modifier_bristle_goo_max", "max")

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_bristle_goo_proc", "damage_reduce")
self.damage_reduce_max = self:GetCaster():GetTalentValue("modifier_bristle_goo_proc", "max")

self.dispel_stun = self:GetCaster():GetTalentValue("modifier_bristle_goo_status", "stun")

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
self:AddParticle(self.particle, false, false, -1, false, false)

self:Init()

if self:GetCaster():GetQuest() == "Brist.Quest_5" and self:GetCaster():QuestCompleted() == false and self:GetParent():IsRealHero() then 
  self:StartIntervalThink(0.1)
end

end

function modifier_bristleback_viscous_nasal_goo_custom:OnRefresh(table)
self:Init()
end



function modifier_bristleback_viscous_nasal_goo_custom:Init()
if not IsServer() then return end 

if self:GetStackCount() < self.stack_limit then 
  self:IncrementStackCount()
end 

if self:GetCaster():HasModifier("modifier_bristle_goo_ground") then 
  self.parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bristleback_viscous_nasal_goo_damage", {})
end
self.parent:EmitSound("Hero_Bristleback.ViscousGoo.Target")

if self.particle then 
  ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
end

end 



function modifier_bristleback_viscous_nasal_goo_custom:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster():GetQuest() then return end
if self:GetStackCount() < self:GetCaster().quest.number then return end

self:GetCaster():UpdateQuest(0.1)
end




function modifier_bristleback_viscous_nasal_goo_custom:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end



function modifier_bristleback_viscous_nasal_goo_custom:GetModifierTotalDamageOutgoing_Percentage()
if not self:GetCaster():HasModifier("modifier_bristle_goo_proc") then return end 

return self.damage_reduce * math.min(self:GetStackCount(), self.damage_reduce_max)
end



function modifier_bristleback_viscous_nasal_goo_custom:GetModifierMoveSpeedBonus_Percentage()
return self.move_slow_per_stack * self:GetStackCount() 
end



function modifier_bristleback_viscous_nasal_goo_custom:GetModifierPhysicalArmorBonus()
return self.armor_per_stack * self:GetStackCount() 
end




function modifier_bristleback_viscous_nasal_goo_custom:OnDestroy()
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_bristle_goo_status") then return end
if self:GetRemainingTime() <= 0.1 then return end 

local stun = self.dispel_stun*self:GetStackCount()

self.parent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = stun*(1 - self.parent:GetStatusResistance())})
self.parent:EmitSound("BB.Goo_stun")   

self:GetAbility():AddStack(self.parent)
end





modifier_bristleback_viscous_nasal_goo_tracker = class({})
function modifier_bristleback_viscous_nasal_goo_tracker:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_tracker:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
}

end


function modifier_bristleback_viscous_nasal_goo_tracker:GetModifierCastRangeBonusStacking()
if not self:GetCaster():HasModifier("modifier_bristle_goo_stack") then return end 

return self.range_bonus
end



function modifier_bristleback_viscous_nasal_goo_tracker:OnCreated()

self.parent = self:GetParent()
self.legendary_chance = self:GetCaster():GetTalentValue("modifier_bristle_goo_legendary", "chance", true)
self.legendary_damage = self:GetCaster():GetTalentValue("modifier_bristle_goo_legendary", "damage", true)/100
self.legendary_stun = self:GetCaster():GetTalentValue("modifier_bristle_goo_legendary", "stun", true)

self.attack_duration = self:GetCaster():GetTalentValue("modifier_bristle_goo_damage", "duration", true)

self.heal_creeps = self.parent:GetTalentValue("modifier_bristle_goo_proc", "heal_creeps", true)
self.heal_max = self.parent:GetTalentValue("modifier_bristle_goo_proc", "max", true)

self.range_bonus = self.parent:GetTalentValue("modifier_bristle_goo_stack", "range", true)

end 



function modifier_bristleback_viscous_nasal_goo_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker ~= self.parent then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local unit = params.unit
local mod =  params.unit:FindModifierByName("modifier_bristleback_viscous_nasal_goo_custom")

if not mod then return end

if self.parent:HasModifier("modifier_bristle_goo_proc") then 

  local heal = self.parent:GetTalentValue("modifier_bristle_goo_proc", "heal")*(math.min(mod:GetStackCount(), self.heal_max))/100

  if unit:IsCreep() then 
    heal = heal*self.heal_creeps
  end 

  self.parent:GenericHeal(heal*params.damage, self:GetAbility(), true)

end

if not self.parent:HasModifier("modifier_bristle_goo_legendary") then return end
if self.parent:HasModifier("modifier_bristleback_viscous_nasal_goo_no_stun") then return end


local random = RollPseudoRandomPercentage(mod:GetStackCount()*self.legendary_chance,1612,self.parent)
if not random  then return end 

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bristleback_viscous_nasal_goo_no_stun", {})


local damage = ApplyDamage({ victim = params.unit, damage = self.parent:GetAverageTrueAttackDamage(nil)*self.legendary_damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, attacker = self:GetCaster(), ability= self:GetAbility() })

SendOverheadEventMessage(params.unit, 4, params.unit, damage, nil)

local stun = 0.1
if params.unit:IsHero() then 
  stun = self.legendary_stun*(1 - params.unit:GetStatusResistance())
end

params.unit:AddNewModifier(self.parent, self:GetAbility(), "modifier_stunned", { duration = stun})
params.unit:EmitSound("BB.Goo_stun")     


self:GetCaster():RemoveModifierByName("modifier_bristleback_viscous_nasal_goo_no_stun")
end



function modifier_bristleback_viscous_nasal_goo_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self.parent:HasModifier("modifier_bristle_goo_damage") then return end
if self.parent ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end

local mod =  params.target:FindModifierByName("modifier_bristleback_viscous_nasal_goo_custom")

if mod then 
  local self_mod = self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_bristleback_viscous_nasal_goo_speed", {duration = self.attack_duration})

  if self_mod then 
    self_mod:SetStackCount(mod:GetStackCount())
  end 
else
  self.parent:RemoveModifierByName("modifier_bristleback_viscous_nasal_goo_speed") 
end 

if not RollPseudoRandomPercentage(self.parent:GetTalentValue("modifier_bristle_goo_damage", "chance") ,7229,self:GetCaster()) then return end

self:GetAbility():AddStack(params.target)   
end




modifier_bristleback_viscous_nasal_goo_damage = class({})

function modifier_bristleback_viscous_nasal_goo_damage:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_damage:IsPurgable() return true end
function modifier_bristleback_viscous_nasal_goo_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_bristleback_viscous_nasal_goo_damage:OnCreated(table)
if not IsServer() then return end

self.max = self:GetCaster():GetTalentValue("modifier_bristle_goo_ground", "duration")
self.interval = self:GetCaster():GetTalentValue("modifier_bristle_goo_ground", "interval")
self.damage = self:GetCaster():GetTalentValue("modifier_bristle_goo_ground", "damage")*self.interval 

self.damage_table = {victim = self:GetParent(),damage = self.damage ,damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, attacker = self:GetCaster(),ability = self:GetAbility()}
       

self:StartIntervalThink(self.interval)
end

function modifier_bristleback_viscous_nasal_goo_damage:OnIntervalThink()
if not IsServer() then return end
ApplyDamage(self.damage_table)            

self:IncrementStackCount()
if self:GetStackCount() >= self.max then 
  self:Destroy()
  return
end   

end







modifier_bristleback_viscous_nasal_goo_no_stun = class({})
function modifier_bristleback_viscous_nasal_goo_no_stun:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_no_stun:IsPurgable() return false end




modifier_bristleback_viscous_nasal_goo_speed = class({})
function modifier_bristleback_viscous_nasal_goo_speed:IsHidden() return false end
function modifier_bristleback_viscous_nasal_goo_speed:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_speed:GetTexture() return "buffs/goo_speed" end
function modifier_bristleback_viscous_nasal_goo_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_bristle_goo_damage", "speed")
end

function modifier_bristleback_viscous_nasal_goo_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_bristleback_viscous_nasal_goo_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed*self:GetStackCount()
end


modifier_bristleback_viscous_nasal_goo_shard_unit = class({})
function modifier_bristleback_viscous_nasal_goo_shard_unit:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_shard_unit:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_shard_unit:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true
}

end


function modifier_bristleback_viscous_nasal_goo_shard_unit:OnCreated()
if not IsServer() then return end 
self:GetParent():AddNoDraw()
end


function modifier_bristleback_viscous_nasal_goo_shard_unit:OnDestroy()
if not IsServer() then return end 

UTIL_Remove(self:GetParent())
end