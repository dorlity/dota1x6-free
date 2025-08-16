LinkLuaModifier( "modifier_mars_gods_rebuke_custom", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_slow", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_run", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_tracker", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_legendary", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_attacks", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_armor", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_silence_cd", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_speed", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )



mars_gods_rebuke_custom = class({})




function mars_gods_rebuke_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_charge.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/mars_shield_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_gods_strength.vpcf", context )
PrecacheResource( "particle", "particles/general/generic_armor_reduction.vpcf", context )

end



function mars_gods_rebuke_custom:CreateTalent(name)
if not IsServer() then return end 

if name == "modifier_mars_rebuke_7" then 
  self:GetCaster():FindAbilityByName("mars_avatar_custom"):SetHidden(false)
end 

end 



function mars_gods_rebuke_custom:GetIntrinsicModifierName()
return "modifier_mars_gods_rebuke_custom_tracker"
end



function mars_gods_rebuke_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_mars_rebuke_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_mars_rebuke_5", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function mars_gods_rebuke_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasTalent("modifier_mars_rebuke_1") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_mars_rebuke_1", "cd")
end 
return (self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown)
end



function mars_gods_rebuke_custom:GetManaCost(level)
local bonus = 0

if self:GetCaster():HasTalent("modifier_mars_rebuke_1") then  
  bonus = self:GetCaster():GetTalentValue("modifier_mars_rebuke_1", "mana")
end

return self.BaseClass.GetManaCost(self,level) + bonus
end



function mars_gods_rebuke_custom:GetCastRange(vLocation, hTarget)
local bonus = 0
if self:GetCaster():HasTalent("modifier_mars_rebuke_6") and not self:GetCaster():HasModifier("modifier_mars_spear_custom_legendary") and not self:GetCaster():HasModifier("modifier_mars_bulwark_custom_idle") then 
  bonus = self:GetCaster():GetTalentValue("modifier_mars_rebuke_6", "range")
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + bonus
end


function mars_gods_rebuke_custom:OnAbilityPhaseStart()

local caster = self:GetCaster()

if not caster:HasTalent("modifier_mars_rebuke_6") or caster:HasModifier("modifier_mars_spear_custom_legendary") 
  or caster:HasModifier("modifier_mars_bulwark_custom_idle") or caster:IsRooted() or caster:IsLeashed() then 
  return true
end

local dir = (self:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
local point = self:GetCursorPosition() - dir*(self:GetSpecialValueFor("radius")*0.5)

if (caster:GetCursorPosition() - caster:GetAbsOrigin()):Length2D() >= self:GetSpecialValueFor("radius") then 
  caster:AddNewModifier(caster, self, "modifier_mars_gods_rebuke_custom_run", {duration = caster:GetTalentValue("modifier_mars_rebuke_6", "duration"), x = point.x, y = point.y, z = point.z})
 
  self:UseResources(true, false, false, true)
  return false
end

return true
end





function mars_gods_rebuke_custom:OnSpellStart()
if not IsServer() then return end

self.point = self:GetCursorPosition()
if self.point == self:GetCaster():GetAbsOrigin() or self:GetCaster():HasModifier("modifier_mars_bulwark_custom_idle") then 
  self.point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*5
end


self:Strike(self.point)
end




function mars_gods_rebuke_custom:Strike(point)
local caster = self:GetCaster()

local radius = self:GetSpecialValueFor("radius")
local angle = self:GetSpecialValueFor("angle")/2
local duration = self:GetSpecialValueFor("knockback_duration")
local distance = self:GetSpecialValueFor("knockback_distance")
local slow_duration = self:GetSpecialValueFor("knockback_slow_duration") + caster:GetTalentValue("modifier_mars_rebuke_5", "slow")

local stun_cd = caster:GetTalentValue("modifier_mars_rebuke_5", "cd", true)
local silence_duration = caster:GetTalentValue("modifier_mars_rebuke_5", "silence", true)

local armor_duration = caster:GetTalentValue("modifier_mars_rebuke_4", "duration", true)
local armor_stack = caster:GetTalentValue("modifier_mars_rebuke_4", "stack", true)


if caster:HasTalent("modifier_mars_rebuke_2") then 
  caster:AddNewModifier(caster, self, "modifier_mars_gods_rebuke_custom_speed", {duration = caster:GetTalentValue("modifier_mars_rebuke_2", "duration")})
end 

local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

local origin = caster:GetOrigin()
local cast_direction = (point-origin):Normalized()
cast_direction.z = 0
local cast_angle = VectorToAngles( cast_direction ).y

local caught = false

local buff = caster:AddNewModifier(caster, self, "modifier_mars_gods_rebuke_custom", {} )

for _,enemy in pairs(enemies) do

  if enemy:GetUnitName() ~= "npc_teleport" and enemy:GetUnitName() ~= "modifier_monkey_king_wukongs_command_custom_soldier" then  

    local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
    local enemy_angle = VectorToAngles( enemy_direction ).y
    local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
    if angle_diff<=angle then

      if caster:HasTalent("modifier_mars_rebuke_5") and not enemy:HasModifier("modifier_mars_gods_rebuke_custom_silence_cd") then
        enemy:EmitSound("SF.Raze_silence") 
        enemy:AddNewModifier(caster, self, "modifier_mars_gods_rebuke_custom_silence_cd", {duration = stun_cd})
        enemy:AddNewModifier(caster, self, "modifier_generic_silence", {duration = (1 - enemy:GetStatusResistance())*silence_duration})
      end 

      if caster:HasTalent("modifier_mars_rebuke_4") then 
        for i = 1,armor_stack do
          enemy:AddNewModifier(caster, self, "modifier_mars_gods_rebuke_custom_armor", {duration = armor_duration})
        end
      end 

      enemy:AddNewModifier(caster, self, "modifier_mars_gods_rebuke_custom_slow", {duration = (1 - enemy:GetStatusResistance())*slow_duration})

      if not enemy:HasModifier("modifier_mars_spear_custom_debuff") then
        enemy:AddNewModifier(caster, self,
          "modifier_generic_knockback",
          {
            duration = duration,
            distance = distance,
            height = 0,
            direction_x = enemy_direction.x,
            direction_y = enemy_direction.y,
          }
        )
      end

      caster:PerformAttack(enemy, true, true, true, true, true, false, true )
      caught = true

      self:PlayEffects2( enemy, origin, cast_direction )
    end
  end
end

if buff then 
  buff:Destroy()
end 

if caught == true and caster:HasTalent("modifier_mars_rebuke_4") then 
  for i = 1,armor_stack do
    caster:AddNewModifier(caster, self, "modifier_mars_gods_rebuke_custom_armor", {duration = armor_duration})
  end
end 

self:PlayEffects1( caught, (point-origin):Normalized() )
end



function mars_gods_rebuke_custom:PlayEffects1( caught, direction )

local sound_cast = "Hero_Mars.Shield.Cast"
if caught == false then
  sound_cast = "Hero_Mars.Shield.Cast.Small"
end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
ParticleManager:SetParticleControl( effect_cast, 6, self:GetCaster():GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 6, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )

EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function mars_gods_rebuke_custom:PlayEffects2( target, origin, direction )

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf", PATTACH_WORLDORIGIN, target )
ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )


target:EmitSound("Hero_Mars.Shield.Crit")
end






modifier_mars_gods_rebuke_custom = class({})

function modifier_mars_gods_rebuke_custom:IsHidden() return true end
function modifier_mars_gods_rebuke_custom:IsPurgable() return false end

function modifier_mars_gods_rebuke_custom:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.bonus_damage = self.ability:GetSpecialValueFor( "bonus_damage_vs_heroes" )
self.bonus_crit = self.ability:GetSpecialValueFor( "crit_mult" ) + self.parent:GetTalentValue("modifier_mars_rebuke_2", "damage")

if not IsServer() then return end

self.parent = self:GetParent()
end


function modifier_mars_gods_rebuke_custom:GetCritDamage()
  return self.bonus_crit 
end


function modifier_mars_gods_rebuke_custom:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
  }

  return funcs
end

function modifier_mars_gods_rebuke_custom:GetModifierPreAttack_BonusDamagePostCrit( params )
if not IsServer() then return end
if not params.target:IsHero() then return end
return self.bonus_damage
end

function modifier_mars_gods_rebuke_custom:GetModifierPreAttack_CriticalStrike( params )
return self.bonus_crit
end








modifier_mars_gods_rebuke_custom_slow = class({})
function modifier_mars_gods_rebuke_custom_slow:IsHidden() return true end
function modifier_mars_gods_rebuke_custom_slow:IsPurgable() return true end
function modifier_mars_gods_rebuke_custom_slow:OnCreated(table)
self.slow = -1*self:GetAbility():GetSpecialValueFor("knockback_slow")
end

function modifier_mars_gods_rebuke_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_mars_gods_rebuke_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_mars_gods_rebuke_custom_slow:GetEffectName()
  return "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf"
end
function modifier_mars_gods_rebuke_custom_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf"
end


function modifier_mars_gods_rebuke_custom_slow:StatusEffectPriority()
  return MODIFIER_PRIORITY_NORMAL 
end








modifier_mars_gods_rebuke_custom_run = class({})
function modifier_mars_gods_rebuke_custom_run:IsHidden() return true end
function modifier_mars_gods_rebuke_custom_run:IsPurgable() return false end
function modifier_mars_gods_rebuke_custom_run:OnCreated(table)
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_mars_rebuke_6", "speed")

if not IsServer() then return end

self.bkb = self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_generic_debuff_immune", {})

self.point = Vector(table.x, table.y, table.z)

self.parent:MoveToPosition(self.point)
self:StartIntervalThink(FrameTime())
self.anim = false
self.parent:EmitSound("Mars.Rebuke_charge")

self.cast = false

self.effect_cast = ParticleManager:CreateParticle( "particles/lc_odd_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
self:AddParticle(self.effect_cast,false, false, -1, false, false)
end

function modifier_mars_gods_rebuke_custom_run:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_mars_gods_rebuke_custom_run:GetActivityTranslationModifiers()
return "spear_stun"
end


function modifier_mars_gods_rebuke_custom_run:GetModifierMoveSpeed_Absolute()
return self.speed
end


function modifier_mars_gods_rebuke_custom_run:OnIntervalThink()
if not IsServer() then return end

if self.parent:IsStunned() or self.parent:IsHexed() or self.parent:GetForceAttackTarget() ~= nil then 
  self:Destroy()
end

GridNav:DestroyTreesAroundPoint(self.parent:GetAbsOrigin(), 200, true)
local distance = (self.parent:GetAbsOrigin() - self.point):Length2D()

if self.anim == false and distance <= 0.2*self.speed then 
  self.anim = true
  self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_4)
end

if distance >= self.speed*FrameTime() then return end

self.cast = true
self:Destroy()

end


function modifier_mars_gods_rebuke_custom_run:OnDestroy()
if not IsServer() then return end

if self.bkb and not self.bkb:IsNull() then
  self.bkb:Destroy()
end

if self.cast == false then return end

self:GetAbility():Strike(self.parent:GetAbsOrigin() + self.parent:GetForwardVector()*5)
end


function modifier_mars_gods_rebuke_custom_run:GetEffectName()
  return "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
end

function modifier_mars_gods_rebuke_custom_run:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_mars_gods_rebuke_custom_run:CheckState()
return
{
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
}

end




modifier_mars_gods_rebuke_custom_tracker = class({})
function modifier_mars_gods_rebuke_custom_tracker:IsHidden() return true end
function modifier_mars_gods_rebuke_custom_tracker:IsPurgable() return false end
function modifier_mars_gods_rebuke_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.armor_duration = self.parent:GetTalentValue("modifier_mars_rebuke_4", "duration", true)

self.heal_creeps = self.parent:GetTalentValue("modifier_mars_rebuke_3", "creeps", true)
self.heal_bonus = self.parent:GetTalentValue("modifier_mars_rebuke_3", "bonus", true)

if self.parent:IsRealHero() then 
  self.parent:AddAttackEvent_out(self)
  self.parent:AddDamageEvent_out(self)
end 

end 

function modifier_mars_gods_rebuke_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end


function modifier_mars_gods_rebuke_custom_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_mars_rebuke_4") then return end 

return self.parent:GetTalentValue("modifier_mars_rebuke_4", "range")
end


function modifier_mars_gods_rebuke_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_mars_rebuke_4") then return end 
if self.parent:HasModifier("modifier_mars_gods_rebuke_custom") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_mars_gods_rebuke_custom_armor", {duration = self.armor_duration})
params.target:AddNewModifier(self.parent, self.ability, "modifier_mars_gods_rebuke_custom_armor", {duration = self.armor_duration})

end 


function modifier_mars_gods_rebuke_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_mars_rebuke_3") then return end 
if self.parent ~= params.attacker then return end 
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if not params.unit:IsUnit() then return end 
if params.unit:IsIllusion() then return end

local heal = params.damage*self.parent:GetTalentValue("modifier_mars_rebuke_3", "heal")/100

if self.parent:HasModifier("modifier_mars_gods_rebuke_custom") then 
  heal = heal*self.heal_bonus
end 

if params.unit:IsCreep() then 
  heal = heal/self.heal_creeps
end 

self.parent:GenericHeal(heal, self.ability, true, nil, "modifier_mars_rebuke_3")
end




mars_avatar_custom = class({})


function mars_avatar_custom:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_mars_rebuke_7", "cd")
end

function mars_avatar_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()

caster:EmitSound("Mars.Avatar_voice")
caster:EmitSound("Mars.Avatar_cast")
caster:AddNewModifier(caster, self, "modifier_mars_gods_rebuke_custom_legendary", {duration = caster:GetTalentValue("modifier_mars_rebuke_7", "duration")})

caster:GenericParticle("particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf")

local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControl(particle_peffect, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

end


modifier_mars_gods_rebuke_custom_legendary = class({})
function modifier_mars_gods_rebuke_custom_legendary:IsHidden() return false end
function modifier_mars_gods_rebuke_custom_legendary:IsPurgable() return false end

function modifier_mars_gods_rebuke_custom_legendary:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.resist = self.parent:GetTalentValue("modifier_mars_rebuke_7", "status")
self.cd_reduction = self.parent:GetTalentValue("modifier_mars_rebuke_7", "cd_reduce")
self.bva = self.parent:GetTalentValue("modifier_mars_rebuke_7", "bva")
self.distance = self:GetCaster():GetTalentValue("modifier_mars_rebuke_7", "distance")

if not IsServer() then return end
self.RemoveForDuel = true

self.effect_cast = ParticleManager:CreateParticle( "particles/mars_shield_legendary.vpcf", PATTACH_CUSTOMORIGIN, self.parent )
ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_shield", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.effect_cast, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon", self.parent:GetAbsOrigin(), true )
self:AddParticle(self.effect_cast,false, false, -1, false, false)
end




function modifier_mars_gods_rebuke_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MODEL_SCALE,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
  MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
}
end


function modifier_mars_gods_rebuke_custom_legendary:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
if params.no_attack_cooldown then return end

local ability = self.parent:FindAbilityByName("mars_gods_rebuke_custom")

self.parent:CdAbility(ability, self.cd_reduction)

if params.target:HasModifier("modifier_mars_spear_custom_debuff") then return end


local dir = (self.parent:GetAbsOrigin() - params.target:GetAbsOrigin()):Normalized()
local distance = (self.parent:GetAbsOrigin() - params.target:GetAbsOrigin()):Length2D()
local real_dist = math.max(0, math.min(self.distance, distance - 150))

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, params.target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

if real_dist == 0 then return end

params.target:AddNewModifier(self.parent, self, "modifier_generic_knockback",
  {
    duration = 0.2,
    distance = real_dist,
    height = 0,
    direction_x = dir.x,
    direction_y = dir.y,
    IsFlail = 1,
  }
)

end

function modifier_mars_gods_rebuke_custom_legendary:GetModifierBaseAttackTimeConstant()
return self.bva
end


function modifier_mars_gods_rebuke_custom_legendary:GetModifierStatusResistanceStacking() 
  return self.resist
end

function modifier_mars_gods_rebuke_custom_legendary:GetModifierModelScale()
return 30
end

function modifier_mars_gods_rebuke_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_gods_strength.vpcf"
end


function modifier_mars_gods_rebuke_custom_legendary:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end






modifier_mars_gods_rebuke_custom_armor = class({})
function modifier_mars_gods_rebuke_custom_armor:IsHidden() return false end
function modifier_mars_gods_rebuke_custom_armor:IsPurgable() return false end
function modifier_mars_gods_rebuke_custom_armor:GetTexture() return "buffs/rebuke_armor" end
function modifier_mars_gods_rebuke_custom_armor:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.armor = self.caster:GetTalentValue("modifier_mars_rebuke_4", "armor")
self.max = self.caster:GetTalentValue("modifier_mars_rebuke_4", "max")
if self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber() then 
  self.armor = self.armor*-1
end 

if not IsServer() then return end 
self:SetStackCount(1)
end


function modifier_mars_gods_rebuke_custom_armor:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max and self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber() then 

  self.parent:EmitSound("Item.StarEmblem.Enemy")
  self.particle_peffect = ParticleManager:CreateParticle("particles/general/generic_armor_reduction.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent) 
  ParticleManager:SetParticleControl(self.particle_peffect, 0, self.parent:GetAbsOrigin())
  self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end 

end 


function modifier_mars_gods_rebuke_custom_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_mars_gods_rebuke_custom_armor:GetModifierPhysicalArmorBonus()
return self.armor*self:GetStackCount()
end




modifier_mars_gods_rebuke_custom_silence_cd = class({})
function modifier_mars_gods_rebuke_custom_silence_cd:IsHidden() return true end
function modifier_mars_gods_rebuke_custom_silence_cd:IsPurgable() return false end
function modifier_mars_gods_rebuke_custom_silence_cd:RemoveOnDeath() return false end
function modifier_mars_gods_rebuke_custom_silence_cd:OnCreated()
self.RemoveForDuel = true
end



modifier_mars_gods_rebuke_custom_speed = class({})
function modifier_mars_gods_rebuke_custom_speed:IsHidden() return false end
function modifier_mars_gods_rebuke_custom_speed:IsPurgable() return false end
function modifier_mars_gods_rebuke_custom_speed:GetTexture() return "buffs/moment_damage" end
function modifier_mars_gods_rebuke_custom_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_mars_rebuke_2", "speed")
end

function modifier_mars_gods_rebuke_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_mars_gods_rebuke_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end