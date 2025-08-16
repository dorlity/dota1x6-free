LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_crit", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_double_thinker", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_legendary", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_legendary_caster", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_legendary_anim", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_tracker", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_attack_cd", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_attack_armor", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_damage_bonus", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_double_illusion", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_heal", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_boundless_strike_custom_anim", "abilities/monkey_king/monkey_king_boundless_strike_custom.lua", LUA_MODIFIER_MOTION_NONE)

monkey_king_boundless_strike_custom = class({})

function monkey_king_boundless_strike_custom:GetAbilityTextureName()

if self:GetCaster():HasModifier("modifier_monkey_king_boundless_strike_custom_legendary_caster") then 
  return "boundless_strike_stop"
end 

if self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_anniversary") then
  return "monkey_king_strike_anniversary"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_golden") then
  return "monkey_king_strike_immortal_gold"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom") then
  return "monkey_king_strike_immortal"
end
return "monkey_king_boundless_strike"
end

function monkey_king_boundless_strike_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
  
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_attack_05_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_attack_06_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_attack_06_near_blur_cud.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_attack_05_near_blur_cud.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_attack_01_near_blur_cud.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_attack_06_near_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_attack_05_near_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_attack_06_near_blur.vpcf", context )


PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_strike_slow_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_monkey_king_fur_army.vpcf", context )
PrecacheResource( "particle", "particles/monkey_king/cast_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf", context )
PrecacheResource( "particle", "particles/mk_heal_red_1.vpcf", context )
PrecacheResource( "particle", "particles/pangolier/buckle_refresh.vpcf", context )
PrecacheResource( "particle", "particles/boundless_attack.vpcf", context )
PrecacheResource( "particle", "particles/bloodseeker/thirst_cleave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_huskar_lifebreak.vpcf", context )
PrecacheResource( "particle", "particles/general/generic_armor_reduction.vpcf", context )
PrecacheResource( "particle", "particles/hoodwink/bush_damage.vpcf", context )

dota1x6:PrecacheShopItems("npc_dota_hero_monkey_king", context)
end


function monkey_king_boundless_strike_custom:OnInventoryContentsChanged()
if self:GetCaster():HasShard() and not self.shard_init then
  self.shard_init = true
  self:ToggleAutoCast()
end

end 



function monkey_king_boundless_strike_custom:GetIntrinsicModifierName()
return "modifier_monkey_king_boundless_strike_custom_tracker"
end

function monkey_king_boundless_strike_custom:GetManaCost(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_monkey_king_boundless_strike_custom_legendary_caster") then 
  return 0
end 
if self:GetCaster():HasTalent("modifier_monkey_king_boundless_1") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_1", "mana")
end
return self.BaseClass.GetManaCost(self,level) + bonus
end


function monkey_king_boundless_strike_custom:GetCooldown(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_monkey_king_boundless_1") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_1", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function monkey_king_boundless_strike_custom:GetCastPoint()
if self:GetCaster():HasTalent("modifier_monkey_king_boundless_7") then 
  return 0
end
return self:GetSpecialValueFor("AbilityCastPoint")
end


function monkey_king_boundless_strike_custom:GetCastAnimation()
if self:GetCaster():HasTalent("modifier_monkey_king_boundless_7") then
  return 0
end
return ACT_DOTA_MK_STRIKE
end


function monkey_king_boundless_strike_custom:GetBehavior()
local shard = 0
if self:GetCaster():HasShard() then 
  shard = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
if self:GetCaster():HasTalent("modifier_monkey_king_boundless_7") then
  return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + shard 
end
return DOTA_ABILITY_BEHAVIOR_POINT + shard 
end


function monkey_king_boundless_strike_custom:GetCastRange(vLocation, hTarget)
local bonus = 0 
if self:GetCaster():HasTalent("modifier_monkey_king_boundless_3") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_3", "range")
end 
return self:GetSpecialValueFor("strike_cast_range") + bonus
end

function monkey_king_boundless_strike_custom:GetRange()
return self:GetSpecialValueFor("strike_cast_range") + self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_3", "range")
end


function monkey_king_boundless_strike_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()

caster:EmitSound("Hero_MonkeyKing.Strike.Cast")

local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf"
if self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_anniversary") then
  particle_name = "particles/econ/items/monkey_king/ti7_weapon/mk_10th_anniversary_strike_cast.vpcf"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom_golden") then
  particle_name = "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_golden_immortal_strike_cast.vpcf"
elseif self:GetCaster():HasModifier("modifier_monkey_king_staff_of_gunyu_custom") then
  particle_name = "particles/econ/items/monkey_king/ti7_weapon/mk_ti7_immortal_strike_cast.vpcf"
end

self.pre_particleID = ParticleManager:CreateParticle(particle_name, PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControl(self.pre_particleID, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.pre_particleID, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon_bot", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.pre_particleID, 2, caster, PATTACH_POINT_FOLLOW, "attach_weapon_top", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(self.pre_particleID)

return true
end


function monkey_king_boundless_strike_custom:OnAbilityPhaseInterrupted()

if self.pre_particleID ~= nil then
  ParticleManager:DestroyParticle(self.pre_particleID, true)
  ParticleManager:ReleaseParticleIndex(self.pre_particleID)
  self.pre_particleID = nil
end

return true
end




function monkey_king_boundless_strike_custom:OnSpellStart()
local caster = self:GetCaster()

if caster:HasModifier("modifier_monkey_king_boundless_strike_custom_legendary_caster") then 

  local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), caster:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
     
  for _,unit in pairs(units) do 

    if unit:HasModifier("modifier_monkey_king_boundless_strike_custom_legendary") then 
      unit:FindModifierByName("modifier_monkey_king_boundless_strike_custom_legendary").activated = true
      unit:FindModifierByName("modifier_monkey_king_boundless_strike_custom_legendary"):Activate_Strike()
    end
  end

  caster:RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_legendary_caster")
  return
end

local point = self:GetCursorPosition()
if point == caster:GetAbsOrigin() then 
  point = point + caster:GetForwardVector()*10
end

if not caster:HasTalent("modifier_monkey_king_boundless_7") then 

  if self.pre_particleID ~= nil then
    ParticleManager:DestroyParticle(self.pre_particleID, false)
    ParticleManager:ReleaseParticleIndex(self.pre_particleID)
    self.pre_particleID = nil
  end

  self:Strike(caster:GetAbsOrigin(), point, 0)
else 

  self:EndCooldown()
  self:StartCooldown(0.2)
  local duration = caster:GetTalentValue("modifier_monkey_king_boundless_7", "delay") + 1 
  caster:AddNewModifier(caster, self, "modifier_monkey_king_boundless_strike_custom_legendary_caster", {duration = duration})


  local illusion_self = CreateIllusions(caster, caster, {
    outgoing_damage = 0,
    duration = duration
    }, 1, 0, false, false)

    local point = caster:GetAbsOrigin() - caster:GetForwardVector()*20
    for _,illusion in pairs(illusion_self) do

      illusion.owner = caster
      illusion.mk_strike = true

      illusion:AddNewModifier(caster, self, "modifier_monkey_king_boundless_strike_custom_legendary",  {})
      illusion:SetOrigin(GetGroundPosition(point, nil))
      illusion:StartGesture(ACT_DOTA_VICTORY)
      illusion:AddNewModifier(illusion, nil, "modifier_monkey_king_boundless_strike_custom_anim", {})
    end
end

end





function monkey_king_boundless_strike_custom:Strike(start_point, end_point, more_crit, double)
if not IsServer() then return end

local caster = self:GetCaster()

local duration = self:GetSpecialValueFor("duration")
local strike_radius = self:GetSpecialValueFor("strike_radius")
local strike_cast_range = self:GetRange()

self.stun = self:GetSpecialValueFor("stun")

if caster:HasTalent("modifier_monkey_king_boundless_3") then 
  self.stun = self.stun + caster:GetTalentValue("modifier_monkey_king_boundless_3", "stun")
end


local vStartPosition = start_point
local vTargetPosition = end_point

local vDirection = vTargetPosition - vStartPosition
vDirection.z = 0
vStartPosition = GetGroundPosition(vStartPosition+vDirection:Normalized()*(strike_radius/2), caster)
vTargetPosition = GetGroundPosition(vStartPosition+vDirection:Normalized()*(strike_cast_range-strike_radius/2), caster)


local sound_cast = "Hero_MonkeyKing.Strike.Impact"
if caster:HasModifier("modifier_monkey_king_staff_of_gunyu_custom_anniversary") then
  sound_cast = "Hero_MonkeyKing.Strike.Impact.Immortal"
elseif caster:HasModifier("modifier_monkey_king_staff_of_gunyu_custom_golden") then
  sound_cast = "Hero_MonkeyKing.Strike.Impact.Immortal"
elseif caster:HasModifier("modifier_monkey_king_staff_of_gunyu_custom") then
  sound_cast = "Hero_MonkeyKing.Strike.Impact.Immortal"
end

EmitSoundOnLocationWithCaster(vStartPosition, sound_cast, caster)
EmitSoundOnLocationWithCaster(vTargetPosition, "Hero_MonkeyKing.Strike.Impact.EndPos", caster)

local particle_name = "particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf"
if caster:HasModifier("modifier_monkey_king_staff_of_gunyu_custom_anniversary") then
    particle_name = "particles/monkey_king_custom/mk_10th_anniversary_strike.vpcf"
elseif caster:HasModifier("modifier_monkey_king_staff_of_gunyu_custom_golden") then
    particle_name = "particles/monkey_king_custom/mk_ti7_golden_immortal_strike.vpcf"
elseif caster:HasModifier("modifier_monkey_king_staff_of_gunyu_custom") then
    particle_name = "particles/monkey_king_custom/mk_ti7_immortal_strike.vpcf"
end

local particleID = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particleID, 0, vStartPosition)
ParticleManager:SetParticleControlForward(particleID, 0, vDirection:Normalized())
ParticleManager:SetParticleControl(particleID, 1, vTargetPosition)
ParticleManager:ReleaseParticleIndex(particleID)


if not double and caster:HasTalent("modifier_monkey_king_boundless_2") then 
  caster:AddNewModifier(caster, self, "modifier_monkey_king_boundless_strike_custom_damage_bonus", {duration = caster:GetTalentValue("modifier_monkey_king_boundless_2", "duration") })
end

local crit = self:GetSpecialValueFor("strike_crit_mult") + more_crit

if double then 
  self.stun = self.stun*caster:GetTalentValue("modifier_monkey_king_boundless_5", "damage")/100
  crit = crit*caster:GetTalentValue("modifier_monkey_king_boundless_5", "damage")/100
end

local crit_mod = caster:AddNewModifier(caster, self, "modifier_monkey_king_boundless_strike_custom_crit", {crit = crit})
local no_cleave = caster:AddNewModifier(caster, self, "modifier_tidehunter_anchor_smash_caster", {})
local armor_duration = caster:GetTalentValue("modifier_monkey_king_boundless_4", "duration", true)

local enemies = FindUnitsInLine(caster:GetTeamNumber(), vStartPosition , vTargetPosition, nil, strike_radius,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)

for _,enemy in pairs(enemies) do

  if caster:HasTalent("modifier_monkey_king_boundless_6") then 
    enemy:AddNewModifier(caster, self, "modifier_monkey_king_boundless_strike_custom_heal", {duration = caster:GetTalentValue("modifier_monkey_king_boundless_6", "duration")})
  end

  local mod = enemy:FindModifierByName("modifier_monkey_king_boundless_strike_custom_attack_armor")
  if mod and mod:GetStackCount() == 0 then 
    mod:SetStackCount(1)
    enemy:EmitSound("MK.Strike_hit_2")
    enemy:AddNewModifier(caster, self, mod:GetName(), {duration = armor_duration})
  end 


  local particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_slow_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
  ParticleManager:SetParticleControlEnt(particleID, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particleID)

  enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.stun})
  caster:PerformAttack(enemy, true, true, true, true, true, false, true)
end

if crit_mod then 
  crit_mod:Destroy()
end
if no_cleave then 
  no_cleave:Destroy()
end

local jingu_mod = caster:FindModifierByName("modifier_monkey_king_jingu_mastery_custom_buff")

if jingu_mod and jingu_mod:GetElapsedTime() > 0.1 then 
  jingu_mod:DecrementStackCount()
  if jingu_mod:GetStackCount() <= 0 then 
    jingu_mod:Destroy()
  end
end

if not double and caster:HasTalent("modifier_monkey_king_boundless_5") then 

  local illusion_self = CreateIllusions(caster, caster, {
      outgoing_damage = 0,
      duration    = caster:GetTalentValue("modifier_monkey_king_boundless_5", "delay") + 1 
      }, 1, 0, false, false)
      

  for _,illusion in pairs(illusion_self) do
    illusion.owner = caster
    FindClearSpaceForUnit(illusion, vTargetPosition, false)
    illusion:StartGesture(ACT_DOTA_VICTORY)
    illusion:AddNewModifier(illusion, nil, "modifier_monkey_king_boundless_strike_custom_anim", {})

    illusion:AddNewModifier(caster, self, "modifier_monkey_king_boundless_strike_custom_double_illusion", 
    {
      crit = more_crit
    })
  end

end

if caster:HasShard() and not double then 


  local point = start_point + vDirection:Normalized()*(strike_cast_range)

  if self:GetAutoCastState() == true then
    caster:EmitSound("MK.Mastery_legendary")
    local distance = (point - caster:GetAbsOrigin()):Length2D()
    local dir = (point - caster:GetAbsOrigin()):Normalized()
    distance = math.min(strike_cast_range, distance)

    local arc = caster:AddNewModifier( caster, self, "modifier_generic_arc",
    { 
      dir_x = dir.x,
      dir_y = dir.y,
      distance = distance,
      speed = 3000,
      height = 150,
      fix_end = true,
      isStun = true,
      isForward = true,
      activity =  ACT_DOTA_MK_SPRING_SOAR,
      effect = "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf",
    })

    arc:SetEndCallback( function( interrupted )
      caster:StartGesture(ACT_DOTA_MK_STRIKE_END)
    end)
  end

  local shard_damage = self:GetSpecialValueFor("shard_damage")
  local ability = caster:FindAbilityByName("monkey_king_primal_spring_custom")
  if ability and ability:IsTrained() then 
    ability:DealDamage(point, shard_damage/100)
  end 
end

end









modifier_monkey_king_boundless_strike_custom_crit = class({})

function modifier_monkey_king_boundless_strike_custom_crit:OnCreated(table)
if not IsServer() then return end
self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")


self.crit = table.crit
print(self.crit)
end

function modifier_monkey_king_boundless_strike_custom_crit:DeclareFunctions() 
return 
{
  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
  MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
} 
end
function modifier_monkey_king_boundless_strike_custom_crit:GetModifierProcAttack_BonusDamage_Physical()
return self.damage
end
function modifier_monkey_king_boundless_strike_custom_crit:GetModifierPreAttack_CriticalStrike()
return self.crit
end

function modifier_monkey_king_boundless_strike_custom_crit:GetCritDamage()
return self.crit
end

function modifier_monkey_king_boundless_strike_custom_crit:IsHidden()
return true
end














modifier_monkey_king_boundless_strike_custom_legendary = class({})
function modifier_monkey_king_boundless_strike_custom_legendary:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_legendary:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf" end
function modifier_monkey_king_boundless_strike_custom_legendary:StatusEffectPriority() return MODIFIER_PRIORITY_ILLUSION end



function modifier_monkey_king_boundless_strike_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.ability = self:GetAbility()

self.interval = self.caster:GetTalentValue("modifier_monkey_king_boundless_7", "interval")
self.delay_time = self.caster:GetTalentValue("modifier_monkey_king_boundless_7", "delay")


self.parent:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_boundless_strike_custom_legendary_anim", {duration = self.caster:GetTalentValue("modifier_monkey_king_boundless_7", "delay")})

self.activated = false
self:StartIntervalThink(self.delay_time)
self.delay = true 
self.more_crit = 0
end

function modifier_monkey_king_boundless_strike_custom_legendary:OnDestroy()
if not IsServer() then return end 
self.caster:RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_legendary_caster")
end


function modifier_monkey_king_boundless_strike_custom_legendary:OnIntervalThink()
if not IsServer() then return end

if self.delay == true then 
  self:Activate_Strike()
else 
  self.parent:FadeGesture(ACT_DOTA_MK_STRIKE)

  if self.pre_particleID ~= nil then
    ParticleManager:DestroyParticle(self.pre_particleID, true)
    ParticleManager:ReleaseParticleIndex(self.pre_particleID)
    self.pre_particleID = nil
  end

  self.caster:FindAbilityByName("monkey_king_boundless_strike_custom"):Strike(self.parent:GetAbsOrigin(), self.end_point, self.more_crit)

  self.parent:Kill(nil, nil)
  self:StartIntervalThink(-1)
end

end


function modifier_monkey_king_boundless_strike_custom_legendary:Activate_Strike()
if not IsServer() then return end
if self.delay == false then return end
if not self.caster then return end

self.caster:RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_legendary_caster")


local strike_cast_range = self.ability:GetRange()

local units_creeps = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, strike_cast_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
local units_heroes = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, strike_cast_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_CLOSEST, false )

local units = units_creeps 

if #units_heroes > 0 then 
  units = units_heroes
end 

local dir 

if #units == 0 then 
  dir = self.parent:GetForwardVector()
  self.end_point = self.parent:GetAbsOrigin() + dir*strike_cast_range
else 

  self.end_point = units[1]:GetAbsOrigin()

  if units[1]:IsMoving() then 
    self.end_point = self.end_point + units[1]:GetForwardVector()*100
  end 

  dir = (self.end_point - self.parent:GetAbsOrigin()):Normalized()
  dir.z = 0
end 


self.parent:FaceTowards(self.end_point)
self.parent:SetForwardVector(dir)

self.parent:RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_anim")
self.parent:FadeGesture(ACT_DOTA_VICTORY)

local cast = self.caster:GetTalentValue("modifier_monkey_king_boundless_7", "cast")

self.parent:StartGestureWithPlaybackRate(ACT_DOTA_MK_STRIKE, 0.4/cast)
self:StartIntervalThink(cast)
self.parent:RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_legendary_anim")
local caster = self.parent

caster:EmitSound("Hero_MonkeyKing.Strike.Cast")

local damage = self.caster:GetTalentValue("modifier_monkey_king_boundless_7", "damage")/(self.delay_time/self.interval)
self.more_crit = damage*(self:GetElapsedTime()/self.interval)

self.pre_particleID = ParticleManager:CreateParticle("particles/monkey_king/cast_legendary.vpcf", PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControl(self.pre_particleID, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.pre_particleID, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon_bot", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.pre_particleID, 2, caster, PATTACH_POINT_FOLLOW, "attach_weapon_top", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(self.pre_particleID)

self.delay = false
end




function modifier_monkey_king_boundless_strike_custom_legendary:DeathEvent(params)
if not IsServer() then return end
if self.caster ~= params.unit then return end

self.parent:Kill(nil, nil)
end


function modifier_monkey_king_boundless_strike_custom_legendary:CheckState()
return
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
}
end




modifier_monkey_king_boundless_strike_custom_legendary_anim = class({})

function modifier_monkey_king_boundless_strike_custom_legendary_anim:IsHidden() return true end 
function modifier_monkey_king_boundless_strike_custom_legendary_anim:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_legendary_anim:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()

self.t = -1
self.timer = table.duration*2 
self:StartIntervalThink(0.5)
self:OnIntervalThink()
end


function modifier_monkey_king_boundless_strike_custom_legendary_anim:OnIntervalThink()
if not IsServer() then return end
self.t = self.t + 1

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
  decimal = 8
else 
  decimal = 1
end

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)
end









modifier_monkey_king_boundless_strike_custom_double_illusion = class({})
function modifier_monkey_king_boundless_strike_custom_double_illusion:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_double_illusion:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_double_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf" end
function modifier_monkey_king_boundless_strike_custom_double_illusion:StatusEffectPriority()
return MODIFIER_PRIORITY_ILLUSION
end

function modifier_monkey_king_boundless_strike_custom_double_illusion:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.ability = self:GetAbility()

self.parent:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_boundless_strike_custom_legendary_anim", {duration = self.caster:GetTalentValue("modifier_monkey_king_boundless_5", "delay")})

self:StartIntervalThink(self.caster:GetTalentValue("modifier_monkey_king_boundless_5", "delay"))
self.delay = true 
self.more_crit = table.crit
end

function modifier_monkey_king_boundless_strike_custom_double_illusion:OnIntervalThink()
if not IsServer() then return end

if self.delay == true then 
  self.parent:FaceTowards(self.caster:GetAbsOrigin())
  self.parent:SetForwardVector((self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized())
  self.point = self.caster:GetAbsOrigin()
  self:Activate_Strike()
else 
  self.parent:FadeGesture(ACT_DOTA_MK_STRIKE)

  if self.pre_particleID ~= nil then
    ParticleManager:DestroyParticle(self.pre_particleID, true)
    ParticleManager:ReleaseParticleIndex(self.pre_particleID)
    self.pre_particleID = nil
  end

  if self.caster and self.caster:IsAlive() then 
    self.caster:FindAbilityByName("monkey_king_boundless_strike_custom"):Strike(self.parent:GetAbsOrigin(), self.point, self.more_crit, true)
  end

  self.parent:Kill(nil, nil)
  self:StartIntervalThink(-1)
end

end


function modifier_monkey_king_boundless_strike_custom_double_illusion:Activate_Strike()
if not IsServer() then return end
if self.delay == false then return end

self.parent:RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_anim")
self.parent:FadeGesture(ACT_DOTA_VICTORY)
self.parent:StartGesture(ACT_DOTA_MK_STRIKE)
self:StartIntervalThink(0.4)

self.parent:RemoveModifierByName("modifier_monkey_king_boundless_strike_custom_legendary_anim")
self.parent:EmitSound("Hero_MonkeyKing.Strike.Cast")

self.pre_particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf", PATTACH_POINT_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.pre_particleID, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.pre_particleID, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_bot", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.pre_particleID, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_top", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(self.pre_particleID)

self.delay = false
end



function modifier_monkey_king_boundless_strike_custom_double_illusion:DeathEvent(params)
if not IsServer() then return end
if self.caster ~= params.unit then return end

self.parent:Kill(nil, nil)
end


function modifier_monkey_king_boundless_strike_custom_double_illusion:CheckState()
return
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
}
end



















modifier_monkey_king_boundless_strike_custom_damage_bonus = class({})
function modifier_monkey_king_boundless_strike_custom_damage_bonus:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_damage_bonus:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_damage_bonus:GetTexture() return "buffs/acorn_armor" end
function modifier_monkey_king_boundless_strike_custom_damage_bonus:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end
function modifier_monkey_king_boundless_strike_custom_damage_bonus:GetModifierPreAttack_BonusDamage()
return self.damage
end


function modifier_monkey_king_boundless_strike_custom_damage_bonus:OnCreated()
  self.damage = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_2", "damage")
end 





modifier_monkey_king_boundless_strike_custom_heal = class({})
function modifier_monkey_king_boundless_strike_custom_heal:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_heal:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_heal:GetTexture() return "buffs/boundless_heal" end
function modifier_monkey_king_boundless_strike_custom_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_monkey_king_boundless_strike_custom_heal:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.heal_reduction = self.caster:GetTalentValue("modifier_monkey_king_boundless_6", "heal_reduce")
self.damage_reduction = self.caster:GetTalentValue("modifier_monkey_king_boundless_6", "damage_reduce")

if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/mk_heal_red_1.vpcf", PATTACH_POINT_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_monkey_king_boundless_strike_custom_heal:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduction
end
function modifier_monkey_king_boundless_strike_custom_heal:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduction
end
function modifier_monkey_king_boundless_strike_custom_heal:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduction
end
function modifier_monkey_king_boundless_strike_custom_heal:GetModifierDamageOutgoing_Percentage()
return self.damage_reduction
end
function modifier_monkey_king_boundless_strike_custom_heal:GetModifierSpellAmplify_Percentage()
return self.damage_reduction
end



modifier_monkey_king_boundless_strike_custom_anim = class({})
function modifier_monkey_king_boundless_strike_custom_anim:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_anim:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_anim:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_monkey_king_boundless_strike_custom_anim:GetOverrideAnimation()
return ACT_DOTA_VICTORY
end





modifier_monkey_king_boundless_strike_custom_legendary_caster = class({})
function modifier_monkey_king_boundless_strike_custom_legendary_caster:IsHidden() return true end
function modifier_monkey_king_boundless_strike_custom_legendary_caster:IsPurgable() return false end


function modifier_monkey_king_boundless_strike_custom_legendary_caster:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.interval = self.caster:GetTalentValue("modifier_monkey_king_boundless_7", "interval")
self.delay_time = self.caster:GetTalentValue("modifier_monkey_king_boundless_7", "delay")
self.cd = self.caster:GetTalentValue("modifier_monkey_king_boundless_7", "cd")/(self.delay_time/self.interval)
end


function modifier_monkey_king_boundless_strike_custom_legendary_caster:OnDestroy()
if not IsServer() then return end

self.more_cd = self.cd*(self:GetElapsedTime()/self.interval)

self.ability:EndCooldown()
self.ability:UseResources(false, false, false, true)

self.caster:CdAbility(self.ability, self.ability:GetCooldownTimeRemaining()*self.more_cd/100)

if (self.delay_time - self:GetElapsedTime()) <= self.interval then 

  local particle = ParticleManager:CreateParticle("particles/pangolier/buckle_refresh.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
  ParticleManager:SetParticleControlEnt( particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
  ParticleManager:ReleaseParticleIndex(particle)

  self.caster:EmitSound("Hero_Rattletrap.Overclock.Cast")
end

end








modifier_monkey_king_boundless_strike_custom_tracker = class({})
function modifier_monkey_king_boundless_strike_custom_tracker:IsHidden() return not self.parent:HasTalent("modifier_monkey_king_boundless_4") or self:GetStackCount() == 1 end
function modifier_monkey_king_boundless_strike_custom_tracker:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_tracker:GetTexture() return "buffs/boundless_attack" end
function modifier_monkey_king_boundless_strike_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.attack_range = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_4", "range", true)
self.duration = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_4", "duration", true)
self.cd = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_4", "cd", true)

self.heal = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_6", "heal", true)/100
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_monkey_king_boundless_6", "heal_creeps", true)


if not IsServer() then return end 

if self.parent:IsRealHero() and not self.parent:IsTempestDouble() then 
  self.parent:AddDamageEvent_out(self)
  self.parent:AddAttackEvent_out(self)
end 

end




function modifier_monkey_king_boundless_strike_custom_tracker:OnStackCountChanged()
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_monkey_king_boundless_4") then return end 

if self:GetStackCount() == 1 then 
  if self.particle then 
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
    self.particle = nil
  end 
end 

if self:GetStackCount() == 0 then 
  self.parent:EmitSound("MK.Strike_hit_ready")

  if not self.particle then 
    self.particle = ParticleManager:CreateParticle("particles/boundless_attack.vpcf", PATTACH_ABSORIGIN, self.parent)
    ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_top", self.parent:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_top", self.parent:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(self.particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_bot", self.parent:GetAbsOrigin(), true)
    self:AddParticle(self.particle,true,false,0,false,false)
  end
end 

end 





function modifier_monkey_king_boundless_strike_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
}
end


function modifier_monkey_king_boundless_strike_custom_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_monkey_king_boundless_4") then return end
if not self.parent:HasModifier("modifier_monkey_king_boundless_strike_custom_attack_cd") then 
  return self.attack_range
end
return 0
end


function modifier_monkey_king_boundless_strike_custom_tracker:GetActivityTranslationModifiers(params)
if not self.parent:HasTalent("modifier_monkey_king_boundless_4") then return end
if self.parent:HasModifier("modifier_monkey_king_boundless_strike_custom_attack_cd") then return end

return "iron_cudgel_charged_attack"
end




function modifier_monkey_king_boundless_strike_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end

if self.parent:HasTalent("modifier_monkey_king_boundless_2") then 
  DoCleaveAttack(self.parent, params.target, nil, params.damage * self.parent:GetTalentValue("modifier_monkey_king_boundless_2", "cleave")/100 , 150, 360, 650, "particles/bloodseeker/thirst_cleave.vpcf" )
end

if not self.parent:HasTalent("modifier_monkey_king_boundless_4") then return end
if self.parent:HasModifier("modifier_monkey_king_boundless_strike_custom_attack_cd") then return end
if params.no_attack_cooldown then return end

self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_monkey_king_boundless_strike_custom_attack_cd", {duration = self.cd})
params.target:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_boundless_strike_custom_attack_armor", {duration = self.duration})
self:SetStackCount(1)
params.target:EmitSound("MK.Strike_hit")

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, params.target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)
end



function modifier_monkey_king_boundless_strike_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_monkey_king_boundless_6") then return end 
if not params.unit:HasModifier("modifier_monkey_king_boundless_strike_custom_heal") then return end
if self.parent ~= params.attacker then return end
if params.unit:IsIllusion() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal*params.damage
if params.unit:IsCreep() then 
  heal = heal/self.heal_creeps
end

self.parent:GenericHeal(heal, self.ability, true, nil, "modifier_monkey_king_boundless_6")
end




modifier_monkey_king_boundless_strike_custom_attack_cd = class({})
function modifier_monkey_king_boundless_strike_custom_attack_cd:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_attack_cd:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_attack_cd:RemoveOnDeath() return false end
function modifier_monkey_king_boundless_strike_custom_attack_cd:IsDebuff() return true end
function modifier_monkey_king_boundless_strike_custom_attack_cd:GetTexture() return "buffs/boundless_attack" end
function modifier_monkey_king_boundless_strike_custom_attack_cd:OnCreated(table)

self.parent = self:GetParent()
self.RemoveForDuel = true 
end


function modifier_monkey_king_boundless_strike_custom_attack_cd:OnDestroy()
if not IsServer() then return end
if not self.parent or self.parent:IsNull() then return end

local mod = self.parent:FindModifierByName("modifier_monkey_king_boundless_strike_custom_tracker")
if mod then 
  mod:SetStackCount(0)
end 

end



modifier_monkey_king_boundless_strike_custom_attack_armor = class({})
function modifier_monkey_king_boundless_strike_custom_attack_armor:IsHidden() return false end
function modifier_monkey_king_boundless_strike_custom_attack_armor:IsPurgable() return false end
function modifier_monkey_king_boundless_strike_custom_attack_armor:GetTexture() return "buffs/boundless_attack" end
function modifier_monkey_king_boundless_strike_custom_attack_armor:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_monkey_king_boundless_strike_custom_attack_armor:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.armor = self.caster:GetPhysicalArmorValue(false)*self.caster:GetTalentValue("modifier_monkey_king_boundless_4", "armor")/100
self.move = self.caster:GetTalentValue("modifier_monkey_king_boundless_4", "slow")
self.bonus = self.caster:GetTalentValue("modifier_monkey_king_boundless_4", "bonus")/100

if not IsServer() then return end
self:SetStackCount(0)

self.particle_peffect = ParticleManager:CreateParticle("particles/general/generic_armor_reduction.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent) 
ParticleManager:SetParticleControl(self.particle_peffect, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_monkey_king_boundless_strike_custom_attack_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_monkey_king_boundless_strike_custom_attack_armor:GetModifierPhysicalArmorBonus()
return self.armor*(1 + self.bonus*self:GetStackCount())
end

function modifier_monkey_king_boundless_strike_custom_attack_armor:GetModifierMoveSpeedBonus_Percentage()
return self.move*(1 + self.bonus*self:GetStackCount())
end


function modifier_monkey_king_boundless_strike_custom_attack_armor:OnStackCountChanged(iStackCount)
if self:GetStackCount() ~= 1 then return end 

self.particle = ParticleManager:CreateParticle("particles/hoodwink/bush_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent) 
ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, true)

end