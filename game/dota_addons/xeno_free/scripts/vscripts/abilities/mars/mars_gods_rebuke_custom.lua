LinkLuaModifier( "modifier_mars_gods_rebuke_custom", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_slow", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_run", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_tracker", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_anim", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_legendary", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_legendary_anim", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_stack", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_attacks", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_attacks_anim", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_gods_rebuke_custom_armor", "abilities/mars/mars_gods_rebuke_custom", LUA_MODIFIER_MOTION_NONE )

mars_gods_rebuke_custom = class({})




mars_gods_rebuke_custom.damage_heal = {0.3, 0.45, 0.6}
mars_gods_rebuke_custom.damage_heal_creeps = 0.33




mars_gods_rebuke_custom.charge_duration = 3
mars_gods_rebuke_custom.charge_speed = 1000
mars_gods_rebuke_custom.charge_cast = 700







function mars_gods_rebuke_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_mars/mars_shield_bash.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf', context )
PrecacheResource( "particle", 'particles/lc_odd_charge.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf', context )
PrecacheResource( "particle", 'particles/brist_lowhp_.vpcf', context )
PrecacheResource( "particle", 'particles/mars_shield_legendary.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_gods_strength.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf', context )
end


function mars_gods_rebuke_custom:GetCastPoint(iLevel)

local bonus = 0

if self:GetCaster():HasModifier("modifier_mars_gods_rebuke_custom_anim") then 
  return 0
end

if self:GetCaster():HasModifier('modifier_mars_rebuke_5') then 
  bonus = self:GetCaster():GetTalentValue("modifier_mars_rebuke_5", "cast")
end

return self.BaseClass.GetCastPoint(self) + bonus
end


function mars_gods_rebuke_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_mars_rebuke_1") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_mars_rebuke_1", "cd")
end 

 return (self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown)

end

function mars_gods_rebuke_custom:GetManaCost(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_mars_rebuke_1") then  
  bonus = self:GetCaster():GetTalentValue("modifier_mars_rebuke_1", "mana")
end

return self.BaseClass.GetManaCost(self,level) + bonus
end



function mars_gods_rebuke_custom:GetCastRange(vLocation, hTarget)
local bonus = 0
if self:GetCaster():HasModifier("modifier_mars_rebuke_6") and not self:GetCaster():HasModifier("modifier_mars_spear_custom_legendary")
and not self:GetCaster():HasModifier("modifier_mars_bulwark_custom_idle") then 
  bonus = self.charge_cast
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + bonus
end


function mars_gods_rebuke_custom:OnAbilityPhaseStart()
if not self:GetCaster():HasModifier("modifier_mars_rebuke_6") or self:GetCaster():HasModifier("modifier_mars_spear_custom_legendary") 
  or self:GetCaster():HasModifier("modifier_mars_bulwark_custom_idle") then 
  return true
end
local dir = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized()
local point = self:GetCursorPosition() - dir*(self:GetSpecialValueFor("radius")*0.5)

if (self:GetCaster():GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D() >= self:GetSpecialValueFor("radius") then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mars_gods_rebuke_custom_run", {duration = self.charge_duration, x = point.x, y = point.y, z = point.z})
 
  self:UseResources(true, false, false, true)
  return false
end

return true
end





function mars_gods_rebuke_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():RemoveModifierByName('modifier_mars_gods_rebuke_custom_anim')

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
  local slow_duration = self:GetSpecialValueFor("knockback_slow_duration")



  local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)


  local origin = caster:GetOrigin()
  local cast_direction = (point-origin):Normalized()
  cast_direction.z = 0
  local cast_angle = VectorToAngles( cast_direction ).y

  local caught = false


  local buff = caster:AddNewModifier(caster, self, "modifier_mars_gods_rebuke_custom", {} )

  if self:GetCaster():HasModifier("modifier_mars_rebuke_5") and #enemies > 0 then
    self:GetCaster():RemoveModifierByName("modifier_mars_gods_rebuke_custom_armor")
  end

  local armor = self:GetCaster():GetPhysicalArmorValue(false)*self:GetCaster():GetTalentValue("modifier_mars_rebuke_5", "armor")/100
  local armor_duration = self:GetCaster():GetTalentValue("modifier_mars_rebuke_5", "duration")

  if self:GetCaster():HasModifier("modifier_mars_rebuke_5") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mars_gods_rebuke_custom_armor", {duration = armor_duration})
  end

  for _,enemy in pairs(enemies) do

    if enemy:GetUnitName() ~= "npc_teleport" and enemy:GetUnitName() ~= "modifier_monkey_king_wukongs_command_custom_soldier" then  

      local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
      local enemy_angle = VectorToAngles( enemy_direction ).y
      local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
      if angle_diff<=angle then
     

        if self:GetCaster():HasModifier("modifier_mars_rebuke_5") then 
          enemy:AddNewModifier(caster, self, "modifier_generic_armor_reduction", {duration = armor_duration, armor_reduction = armor})
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



  if self:GetCaster():HasModifier("modifier_mars_rebuke_4") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mars_gods_rebuke_custom_attacks", {duration = self:GetCaster():GetTalentValue("modifier_mars_rebuke_4", "duration")})
  end
  buff:Destroy()

  self:PlayEffects1( caught, (point-origin):Normalized() )

end




--------------------------------------------------------------------------------
-- Play Effects
function mars_gods_rebuke_custom:PlayEffects1( caught, direction )
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"
  local sound_cast = "Hero_Mars.Shield.Cast"
  if caught == false then
    sound_cast = "Hero_Mars.Shield.Cast.Small"
  end

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
  ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
  ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
  ParticleManager:SetParticleControl( effect_cast, 6, self:GetCaster():GetOrigin() )
  ParticleManager:SetParticleControlForward( effect_cast, 6, direction )
  ParticleManager:ReleaseParticleIndex( effect_cast )

  -- Create Sound
  EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function mars_gods_rebuke_custom:PlayEffects2( target, origin, direction )
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"
  local sound_cast = "Hero_Mars.Shield.Crit"

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
  ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
  ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
  ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
  ParticleManager:ReleaseParticleIndex( effect_cast )

  -- Create Sound
  target:EmitSound(sound_cast)
end






modifier_mars_gods_rebuke_custom = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_gods_rebuke_custom:IsHidden()
  return true
end

function modifier_mars_gods_rebuke_custom:IsDebuff()
  return false
end

function modifier_mars_gods_rebuke_custom:IsPurgable()
  return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_mars_gods_rebuke_custom:OnCreated( kv )

self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_vs_heroes" )
self.bonus_crit = self:GetAbility():GetSpecialValueFor( "crit_mult" )
self.damage = 0

if self:GetParent():HasModifier("modifier_mars_rebuke_2") then 
  self.bonus_crit = self.bonus_crit + self:GetCaster():GetTalentValue("modifier_mars_rebuke_2", "damage")
end

if not IsServer() then return end

end

function modifier_mars_gods_rebuke_custom:OnRefresh( kv )
end


function modifier_mars_gods_rebuke_custom:OnDestroy()
if not IsServer() then return end
if self.damage == 0 then return end

my_game:GenericHeal(self:GetCaster(), self.damage*self:GetAbility().damage_heal[self:GetCaster():GetUpgradeStack("modifier_mars_rebuke_3")], self:GetAbility())

end

function modifier_mars_gods_rebuke_custom:GetCritDamage()
  return self.bonus_crit 
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_mars_gods_rebuke_custom:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_EVENT_ON_TAKEDAMAGE
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



function modifier_mars_gods_rebuke_custom:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.inflictor then return end
if not self:GetParent():HasModifier("modifier_mars_rebuke_3") then return end

local k = 1 
if not params.unit:IsRealHero() then 
  k = self:GetAbility().damage_heal_creeps
end

self.damage = self.damage + params.damage*k

end

modifier_mars_gods_rebuke_custom_slow = class({})
function modifier_mars_gods_rebuke_custom_slow:IsHidden() return false end
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
  return 2
end







modifier_mars_gods_rebuke_custom_run = class({})
function modifier_mars_gods_rebuke_custom_run:IsHidden() return true end
function modifier_mars_gods_rebuke_custom_run:IsPurgable() return false end
function modifier_mars_gods_rebuke_custom_run:OnCreated(table)
if not IsServer() then return end
self.point = Vector(table.x, table.y, table.z)
self:GetParent():MoveToPosition(self.point)
self:StartIntervalThink(FrameTime())
self.anim = false
self:GetParent():EmitSound("Mars.Rebuke_charge")

self.cast = false

self.effect_cast = ParticleManager:CreateParticle( "particles/lc_odd_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
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
return self:GetAbility().charge_speed
end


function modifier_mars_gods_rebuke_custom_run:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():IsStunned() or self:GetParent():IsHexed() or self:GetParent():GetForceAttackTarget() ~= nil then 
  self:Destroy()
end

GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 200, true)
local distance = (self:GetParent():GetAbsOrigin() - self.point):Length2D()

if self.anim == false and distance <= 0.2*self:GetAbility().charge_speed then 
  self.anim = true
  self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_4)
end

if distance >= self:GetAbility().charge_speed*FrameTime() then return end

self.cast = true
self:Destroy()

end


function modifier_mars_gods_rebuke_custom_run:OnDestroy()
if not IsServer() then return end
if self.cast == false then return end
self:GetAbility():Strike(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*5)

--self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_gods_rebuke_custom_anim", {duration = 0.2})
--self:GetParent():CastAbilityOnPosition(self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*5, self:GetAbility(), 1)

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
  [MODIFIER_STATE_MAGIC_IMMUNE] = true,
}

end

modifier_mars_gods_rebuke_custom_anim = class({})
function modifier_mars_gods_rebuke_custom_anim:IsHidden() return true end
function modifier_mars_gods_rebuke_custom_anim:IsPurgable() return false end











mars_avatar_custom = class({})


function mars_avatar_custom:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_mars_rebuke_7", "cd")
end

function mars_avatar_custom:OnSpellStart()
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("mars_gods_rebuke_custom")
if ability and ability:GetCooldownTimeRemaining() > 2 then 
  --ability:EndCooldown()
  --ability:StartCooldown(2)
end

self:GetCaster():EmitSound("Mars.Avatar_voice")
self:GetCaster():EmitSound("Mars.Avatar_cast")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mars_gods_rebuke_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_mars_rebuke_7", "duration")})


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

end


modifier_mars_gods_rebuke_custom_legendary = class({})
function modifier_mars_gods_rebuke_custom_legendary:IsHidden() return false end
function modifier_mars_gods_rebuke_custom_legendary:IsPurgable() return false end

function modifier_mars_gods_rebuke_custom_legendary:OnCreated(table)
self.resist = self:GetCaster():GetTalentValue("modifier_mars_rebuke_7", "status")
self.cd_reduction = self:GetCaster():GetTalentValue("modifier_mars_rebuke_7", "cd_reduce")

if not IsServer() then return end
self:SetStackCount(0)
self.effect_cast = ParticleManager:CreateParticle( "particles/mars_shield_legendary.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.effect_cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_shield", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.effect_cast, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon", self:GetParent():GetAbsOrigin(), true )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

end

function modifier_mars_gods_rebuke_custom_legendary:OnRefresh()
if not IsServer() then return end
self:OnCreated(table)
end




function modifier_mars_gods_rebuke_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MODEL_SCALE,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_mars_gods_rebuke_custom_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_mars_gods_rebuke_custom") then return end

local ability = self:GetParent():FindAbilityByName("mars_gods_rebuke_custom")

self:GetCaster():CdAbility(ability, self.cd_reduction)

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
return 111111
end





modifier_mars_gods_rebuke_custom_attacks = class({})
function modifier_mars_gods_rebuke_custom_attacks:IsHidden() return false end
function modifier_mars_gods_rebuke_custom_attacks:IsPurgable() return false end
function modifier_mars_gods_rebuke_custom_attacks:GetTexture() return "buffs/rebuke_stack" end
function modifier_mars_gods_rebuke_custom_attacks:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_mars_rebuke_4", "attacks")
self.speed = self:GetCaster():GetTalentValue("modifier_mars_rebuke_4", "speed")
self.range = self:GetCaster():GetTalentValue("modifier_mars_rebuke_4", "range")
self.distance = self:GetCaster():GetTalentValue("modifier_mars_rebuke_4", "distance")
if not IsServer() then return end

self:SetStackCount(self.max)
end


function modifier_mars_gods_rebuke_custom_attacks:CheckState()
return
{
  [MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_mars_gods_rebuke_custom_attacks:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end


function modifier_mars_gods_rebuke_custom_attacks:GetModifierAttackSpeedBonus_Constant()
return self.speed 
end

function modifier_mars_gods_rebuke_custom_attacks:GetModifierAttackRangeBonus()
return self.range
end


function modifier_mars_gods_rebuke_custom_attacks:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():HasModifier("modifier_mars_gods_rebuke_custom") then return end
if self:GetParent():HasModifier("modifier_mars_scepter_damage") then return end
if params.no_attack_cooldown then return end

local dir = (self:GetParent():GetAbsOrigin() - params.target:GetAbsOrigin()):Normalized()

local distance = (self:GetParent():GetAbsOrigin() - params.target:GetAbsOrigin()):Length2D()
 


if not params.target:HasModifier("modifier_mars_spear_custom_debuff") and (params.target:IsHero() or params.target:IsCreep())
  and params.target:GetUnitName() ~= "npc_teleport" then
  local target = params.target

  target:AddNewModifier(target, nil, "modifier_mars_gods_rebuke_custom_attacks_anim", {duration = 0.2})
  params.target:AddNewModifier(caster, self, "modifier_generic_knockback",
    {
      duration = 0.2,
      distance = math.max(0, math.min(self.distance, distance - 150)),
      height = 0,
      direction_x = dir.x,
      direction_y = dir.y,
    }
  )
end

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
ParticleManager:SetParticleControl(hit_effect, 1, params.target:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(hit_effect)

self:DecrementStackCount()
if self:GetStackCount() == 0 then 
  self:Destroy()
end

end

modifier_mars_gods_rebuke_custom_attacks_anim = class({})
function modifier_mars_gods_rebuke_custom_attacks_anim:IsHidden() return true end
function modifier_mars_gods_rebuke_custom_attacks_anim:IsPurgable() return false end
function modifier_mars_gods_rebuke_custom_attacks_anim:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end
function modifier_mars_gods_rebuke_custom_attacks_anim:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end


modifier_mars_gods_rebuke_custom_armor = class({})
function modifier_mars_gods_rebuke_custom_armor:IsHidden() return false end
function modifier_mars_gods_rebuke_custom_armor:IsPurgable() return false end
function modifier_mars_gods_rebuke_custom_armor:GetTexture() return "buffs/rebuke_armor" end
function modifier_mars_gods_rebuke_custom_armor:OnCreated(table)
self.armor = -1*self:GetParent():GetPhysicalArmorValue(false)*self:GetCaster():GetTalentValue("modifier_mars_rebuke_5", "armor")/100
if not IsServer() then return end

self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "Hero_Pangolier.TailThump.Shield"
self.buff_particles = {}

self:GetCaster():EmitSound( self.sound)


self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)

end


function modifier_mars_gods_rebuke_custom_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_mars_gods_rebuke_custom_armor:GetModifierPhysicalArmorBonus()
return self.armor
end



