LinkLuaModifier("modifier_custom_huskar_life_break", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_huskar_life_break_charge", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_break_slow", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_break_taunt", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_break_legendary", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_heal", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_legendary_thinker", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_legendary_slow", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_legendary_stack", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_life_legendary_double", "abilities/huskar/custom_huskar_life_break", LUA_MODIFIER_MOTION_NONE)


custom_huskar_life_break                  = class({})
modifier_custom_huskar_life_break             = class({})
modifier_custom_huskar_life_break_charge          = class({})
modifier_custom_huskar_life_break_slow          = class({})
modifier_custom_huskar_life_break_taunt         = class({})
modifier_custom_huskar_life_break_legendary     = class({})
modifier_custom_huskar_life_heal        = class({})



custom_huskar_life_break.creep_reduce = 0.33

custom_huskar_life_break.cd_init = -2
custom_huskar_life_break.cd_inc = -1



custom_huskar_life_break.shield_duration = 3
custom_huskar_life_break.shield_damage = 50

custom_huskar_life_break.heal = {8, 12, 16}
custom_huskar_life_break.heal_duration = 4

custom_huskar_life_break.aoe_range = 300
custom_huskar_life_break.aoe_cast = 200

custom_huskar_life_break.double_delay = 3
custom_huskar_life_break.double_damage = {0.15, 0.25}

custom_huskar_life_break.resist_magic = {-8, -12, -16}
custom_huskar_life_break.resist_status = {-8, -12, -16}



function custom_huskar_life_break:Precache(context)

PrecacheResource( "particle", "particles/huskar/huskar_life_break.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_life_break_spellstart.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_life_break_cast.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_huskar_lifebreak.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield.vpcf", context )
PrecacheResource( "particle", "particles/huskar_earth_hit.vpcf", context )
PrecacheResource( "particle", "particles/huskar_earth_stack.vpcf", context )
PrecacheResource( "particle", "particles/huskar_fire.vpcf", context )

end


function custom_huskar_life_break:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_huskar_dominator_custom") then
    return "huskar_life_break_alt"
end
if self:GetCaster():HasModifier("modifier_huskar_draca_mane_custom_golden") then
    return "huskar/husk_2022_immortal/husk_2022_immortal_life_break_gold"
end
if self:GetCaster():HasModifier("modifier_huskar_draca_mane_custom") then
    return "huskar/husk_2022_immortal/husk_2022_immortal_life_break"
end
return "huskar_life_break"
end


function custom_huskar_life_break:GetCooldown(iLevel)
 
local upgrade = 0
if self:GetCaster():HasModifier("modifier_huskar_leap_cd") then 
  upgrade = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_huskar_leap_cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + upgrade

end




function custom_huskar_life_break:GetBehavior()
  if self:GetCaster():HasModifier("modifier_huskar_leap_resist") then
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
      end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET 
end


function custom_huskar_life_break:GetAOERadius() 
if self:GetCaster():HasModifier("modifier_huskar_leap_resist") then 
  return self.aoe_range
end
return 0
end



function custom_huskar_life_break:GetCastRange(vLocation, hTarget)
local upgrade = 0


if self:GetCaster():HasScepter() then 
  upgrade = upgrade + self:GetSpecialValueFor("scepter_range")
end
if self:GetCaster():HasModifier("modifier_huskar_leap_resist") then 
  upgrade = upgrade + self.aoe_cast
end

 return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end







function custom_huskar_life_break:OnSpellStart(target)
  if not IsServer() then return end

  if target == nil then 
    enemy = self:GetCursorTarget()
  else 
    enemy = target
  end

  self:GetCaster():EmitSound("Hero_Huskar.Life_Break")

 
  self:GetCaster():Purge(false, true, false, false, false)

  local life_break_charge_max_duration = 5
  
  local point = self:GetCursorPosition()


  if enemy then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_life_break", {ent_index = enemy:entindex()})

    if enemy:IsRealHero() and self:GetCaster():GetQuest() == "Huskar.Quest_8" and not self:GetCaster():QuestCompleted() and self:GetCaster():GetHealthPercent() <= self:GetCaster().quest.number then 
      self:GetCaster():UpdateQuest(1)
    end

  else 
     self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_life_break", {x = point.x, y = point.y, z = point.z})
  end

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_life_break_charge", { duration = life_break_charge_max_duration})
end



function modifier_custom_huskar_life_break:IsHidden()   return true end
function modifier_custom_huskar_life_break:IsPurgable() return false end

function modifier_custom_huskar_life_break:OnCreated(params)
self.ability  = self:GetAbility()
self.caster   = self:GetCaster()
self.parent   = self:GetParent()

self.health_cost_percent  = self.ability:GetSpecialValueFor("tooltip_health_cost_percent")/100
self.health_damage      = self.ability:GetSpecialValueFor("tooltip_health_damage")/100
self.health_damage_scepter  = self.ability:GetSpecialValueFor("health_damage_scepter")
self.charge_speed     = self.ability:GetSpecialValueFor("charge_speed")
self.taunt_duration       = self.ability:GetSpecialValueFor("scepter_taunt")

if not IsServer() then return end

local particle_name_start = "particles/units/heroes/hero_huskar/huskar_life_break_spellstart.vpcf"


if self:GetCaster():HasModifier("modifier_huskar_draca_mane_custom") then
    particle_name_start = "particles/econ/items/huskar/huskar_2022_immortal/huskar_2022_immortal_life_break_spellstart.vpcf"
elseif self:GetCaster():HasModifier("modifier_huskar_dominator_custom") then
    particle_name_start = "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_spellstart.vpcf"
elseif self:GetCaster():HasModifier("modifier_huskar_draca_mane_custom_golden") then
    particle_name_start = "particles/econ/items/huskar/huskar_2022_immortal/huskar_2022_immortal_life_break_gold_spellstart.vpcf"
end

local caster = self:GetCaster()
particle = ParticleManager:CreateParticle(particle_name_start, PATTACH_POINT_FOLLOW, caster)
ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 5, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)



if params.ent_index then 
  self.target     = EntIndexToHScript(params.ent_index)
else 
  self.point = Vector(params.x, params.y, params.z)
end

self.break_range  = 1450

if self:ApplyHorizontalMotionController() == false then
   self:Destroy()
end



end







function modifier_custom_huskar_life_break:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
  
  local target
  if self.target then 
    target = self.target:GetAbsOrigin()
  else 
    target = self.point
  end

  me:FaceTowards(target)

  local distance = (target - me:GetOrigin()):Normalized()
  me:SetOrigin( me:GetOrigin() + distance * self.charge_speed * dt )
  
  
  if (self.target and (self.target:GetAbsOrigin() - self.parent:GetOrigin()):Length2D() <= 128)
  or (self.point and (self.point - self.parent:GetOrigin()):Length2D() <= 30)  
  or (self.target and (self.target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.break_range)
  or self.parent:IsHexed() or self.parent:IsNightmared() or self.parent:IsStunned() then
    self:Destroy()
  end

end


function modifier_custom_huskar_life_break:OnHorizontalMotionInterrupted()
  self:Destroy()
end




function modifier_custom_huskar_life_break:OnDestroy()
  if not IsServer() then return end

  self.parent:RemoveHorizontalMotionController( self )

  if self.parent:HasModifier("modifier_custom_huskar_life_break_charge") then
    self.parent:RemoveModifierByName("modifier_custom_huskar_life_break_charge")
  end
  
  local target
  if self.target then 
    target = self.target:GetAbsOrigin()
  else 
    target = self.point
  end

  if (self.target and (self.target:GetAbsOrigin() - self.parent:GetOrigin()):Length2D() <= 128)
  or (self.point and (self.point - self.parent:GetOrigin()):Length2D() <= 30) then
   
    if self.target and self.target:TriggerSpellAbsorb(self.ability) then
      return nil
    end

    if self.target then
      self.parent:StartGesture(ACT_DOTA_CAST_LIFE_BREAK_END)
    else 
      self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    end

    if self.target then 
      self.target:EmitSound("Hero_Huskar.Life_Break.Impact")
    else 
      self:GetParent():EmitSound("Hero_Huskar.Life_Break.Impact")
    end

    local damageTable_self = {
      victim      = self.parent,
      attacker    = self.parent,
      damage      = self.health_cost_percent * self.parent:GetHealth(),
      damage_type   = DAMAGE_TYPE_MAGICAL,
      ability     = self.ability,
      damage_flags  = DOTA_DAMAGE_FLAG_NON_LETHAL
    }
    local self_damage = ApplyDamage(damageTable_self)



    if self:GetParent():HasModifier("modifier_huskar_leap_damage") then 
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_life_heal", {duration = self:GetAbility().heal_duration})
    end

    if self.parent:HasModifier("modifier_huskar_leap_immune")  then
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_huskar_life_break_legendary", {duration = self:GetAbility().shield_duration, stack = self:GetAbility().shield_damage*(1 - self:GetParent():GetHealthPercent()/100)})
    end

    if self:GetParent():HasModifier("modifier_huskar_leap_resist") then 

      local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_WORLDORIGIN, nil)
      ParticleManager:SetParticleControl(particle, 1, self.point or self.target:GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(particle)

       local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(),self.point or self.target:GetAbsOrigin(), nil, self:GetAbility().aoe_range, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0,  false )
       for _,enemy in pairs(enemies) do 
          self:ImpactEnemy(enemy)
       end

    else

      self:ImpactEnemy(self.target)
    end


    if self.target then 
      self.parent:MoveToTargetToAttack( self.target )
    else 
      self:GetParent():MoveToPositionAggressive(self.point)
    end
  end
end


function modifier_custom_huskar_life_break:ImpactEnemy(target)
if not IsServer() then return end


local particle_name_end = "particles/huskar/huskar_life_break.vpcf"


if self:GetCaster():HasModifier("modifier_huskar_draca_mane_custom") then
    particle_name_end = "particles/econ/items/huskar/huskar_2022_immortal/huskar_2022_immortal_life_break.vpcf"
elseif self:GetCaster():HasModifier("modifier_huskar_dominator_custom") then
    particle_name_end = "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_life_break.vpcf"
elseif self:GetCaster():HasModifier("modifier_huskar_draca_mane_custom_golden") then
    particle_name_end = "particles/econ/items/huskar/huskar_2022_immortal/huskar_2022_immortal_life_break_gold.vpcf"
end

local particle = ParticleManager:CreateParticle(particle_name_end, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, target:GetOrigin())
ParticleManager:SetParticleControl(particle, 1, target:GetOrigin())
ParticleManager:ReleaseParticleIndex(particle)




local enemy_damage_to_use = self.health_damage


local duration = self.ability:GetDuration()


local enemy_damage = enemy_damage_to_use * target:GetHealth()

if target:HasModifier("modifier_custom_huskar_life_legendary_stack") then 
  local more_damage = target:GetMaxHealth()*target:FindModifierByName("modifier_custom_huskar_life_legendary_stack"):GetStackCount()*self:GetCaster():FindAbilityByName("custom_huskar_sacred_earth"):GetSpecialValueFor("stack_damage")/100

  SendOverheadEventMessage(target, 6, target, more_damage, nil)
  enemy_damage = enemy_damage + more_damage

  target:RemoveModifierByName("modifier_custom_huskar_life_legendary_stack")
end

if not target:IsHero() then 
  enemy_damage = enemy_damage*self:GetAbility():GetSpecialValueFor("creeps_damage")/100
end

if self:GetCaster():HasModifier("modifier_huskar_leap_shield") then 
  target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_huskar_life_legendary_double", {duration = self:GetAbility().double_delay})
end

if target ~= self:GetParent() then 
  target:AddNewModifier(self.parent, self.ability, "modifier_custom_huskar_life_break_slow", {duration = duration * (1 - target:GetStatusResistance() ) })
end

local damageTable_enemy = {
  victim      = target,
  attacker    = self.parent,
  damage      =  enemy_damage,
  damage_type   = DAMAGE_TYPE_MAGICAL,
  ability     = self.ability,
  damage_flags  = DOTA_DAMAGE_FLAG_NONE
}


ApplyDamage(damageTable_enemy)




if self.caster:HasScepter() and self.caster ~= target and target:IsHero() and not target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then
  target:AddNewModifier(self.caster, self.ability, "modifier_custom_huskar_life_break_taunt", {duration = (1 - target:GetStatusResistance())*self.taunt_duration})
end

    

end

--------------------------------
-- LIFE BREAK CHARGE MODIFIER --
--------------------------------

--"This modifier turns him spell immune, disarms him, forces him to face the target and is responsible for the leap animation."
-- I'm gonna put the "forces him to face the target" in the other modifier cause it seems to make sense to just deal with that logic in the motion controller

function modifier_custom_huskar_life_break_charge:IsHidden()    return true end
function modifier_custom_huskar_life_break_charge:IsPurgable()  return false end

function modifier_custom_huskar_life_break_charge:CheckState()
  local state = {
    [MODIFIER_STATE_DISARMED] = true,
  }

  return state
end

function modifier_custom_huskar_life_break_charge:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,

    }

    return decFuncs
end









function modifier_custom_huskar_life_break_charge:GetOverrideAnimation()
  return ACT_DOTA_CAST_LIFE_BREAK_START
end



function modifier_custom_huskar_life_break_charge:OnCreated()
if not IsServer() then return end

self.bkb = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_debuff_immune", {})

local particle_name_cast = "particles/units/heroes/hero_huskar/huskar_life_break_cast.vpcf"
if self:GetCaster():HasModifier("modifier_huskar_draca_mane_custom") then
    particle_name_cast = "particles/econ/items/huskar/huskar_2022_immortal/huskar_2022_immortal_life_break_cast.vpcf"
elseif self:GetCaster():HasModifier("modifier_huskar_dominator_custom") then
    particle_name_cast = "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast.vpcf"
elseif self:GetCaster():HasModifier("modifier_huskar_draca_mane_custom_golden") then
  particle_name_cast = "particles/econ/items/huskar/huskar_2022_immortal/huskar_2022_immortal_life_break_cast.vpcf"
end 

self.pfx = ParticleManager:CreateParticle(particle_name_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
self:AddParticle(self.pfx,false, false, -1, false, false)

end

function modifier_custom_huskar_life_break_charge:OnDestroy()
if not IsServer() then return end
if not self.bkb or self.bkb:IsNull() then return end 

self.bkb:Destroy()
end

------------------------------
-- LIFE BREAK SLOW MODIFIER --
------------------------------
function modifier_custom_huskar_life_break_slow:IsPurgable() 
return true end

function modifier_custom_huskar_life_break_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_custom_huskar_life_break_slow:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  
  self.attackspeed = self.ability:GetSpecialValueFor("attack_speed")
  self.movespeed  = self.ability:GetSpecialValueFor("movespeed")
end

function modifier_custom_huskar_life_break_slow:OnRefresh()
  self:OnCreated()
end

function modifier_custom_huskar_life_break_slow:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING

}
end


function modifier_custom_huskar_life_break_slow:GetModifierAttackSpeedBonus_Constant()
  return self.attackspeed
end
function modifier_custom_huskar_life_break_slow:GetModifierMoveSpeedBonus_Percentage()
  return self.movespeed * (-1)
end

function modifier_custom_huskar_life_break_slow:GetModifierStatusResistanceStacking()
if not self:GetCaster():HasModifier("modifier_huskar_leap_double") then return end
return self:GetAbility().resist_status[self:GetCaster():GetUpgradeStack("modifier_huskar_leap_double")]
end


function modifier_custom_huskar_life_break_slow:GetModifierMagicalResistanceBonus()
if not self:GetCaster():HasModifier("modifier_huskar_leap_double") then return end
return self:GetAbility().resist_magic[self:GetCaster():GetUpgradeStack("modifier_huskar_leap_double")]
end



-------------------------------------------
-- MODIFIER_custom_HUSKAR_LIFE_BREAK_TAUNT --
-------------------------------------------

function modifier_custom_huskar_life_break_taunt:IsPurgable() return false end

function modifier_custom_huskar_life_break_taunt:GetStatusEffectName()
  return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_custom_huskar_life_break_taunt:OnCreated()
  if not IsServer() then return end
  
  self:GetParent():SetForceAttackTarget(self:GetCaster())
  self:GetParent():MoveToTargetToAttack(self:GetCaster())
  self:StartIntervalThink(0.1)
end

function modifier_custom_huskar_life_break_taunt:OnIntervalThink()
  self:GetParent():SetForceAttackTarget(self:GetCaster())
end

function modifier_custom_huskar_life_break_taunt:OnDestroy()
  if not IsServer() then return end
  
  self:GetParent():SetForceAttackTarget(nil)
end

function modifier_custom_huskar_life_break_taunt:CheckState()
  return {[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_TAUNTED] = true}

end





-------------------------------------------------ТАЛАНТ ЛЕГЕНДАРНЫЙ--------------------------------
function modifier_custom_huskar_life_break_legendary:IsHidden() return false end
function modifier_custom_huskar_life_break_legendary:IsPurgable() return true end
function modifier_custom_huskar_life_break_legendary:GetTexture() return "buffs/leap_shield" end
function modifier_custom_huskar_life_break_legendary:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Huskar.Leap_Legendary")

self:SetStackCount(table.stack)

caster = self:GetParent()
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield.vpcf", PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleControlEnt( self.particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
ParticleManager:SetParticleControl( self.particle, 1, Vector(5,0,0) )
ParticleManager:SetParticleControl( self.particle, 9, Vector(1,0,0) )
ParticleManager:SetParticleControl( self.particle, 10, Vector(1,0,0) )
ParticleManager:SetParticleControl( self.particle, 11, Vector(1,0,0) )
end

function modifier_custom_huskar_life_break_legendary:OnDestroy()
if not IsServer() then return end
if not self.particle then return end

  ParticleManager:DestroyParticle(self.particle, true)
  ParticleManager:ReleaseParticleIndex(self.particle) 
end


function modifier_custom_huskar_life_break_legendary:DeclareFunctions()
return
{
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_custom_huskar_life_break_legendary:GetModifierIncomingDamage_Percentage() return -1*self:GetStackCount()
 end









modifier_custom_huskar_life_heal = class({})
function modifier_custom_huskar_life_heal:IsHidden() return false end
function modifier_custom_huskar_life_heal:IsPurgable() return true end
function modifier_custom_huskar_life_heal:GetTexture() return "buffs/lifebreak_heal" end
function modifier_custom_huskar_life_heal:OnCreated(table)
self.regen = (self:GetAbility().heal[self:GetParent():GetUpgradeStack("modifier_huskar_leap_damage")])/self:GetRemainingTime()
end

function modifier_custom_huskar_life_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_custom_huskar_life_heal:GetModifierHealthRegenPercentage() return self.regen end






custom_huskar_sacred_earth = class({})

function custom_huskar_sacred_earth:GetAOERadius()
return self:GetSpecialValueFor("radius")
end




function custom_huskar_sacred_earth:GetCooldown(iLevel)
 
local upgrade = self:GetSpecialValueFor("cd_max")*(1 - self:GetCaster():GetHealthPercent()/100)

return self.BaseClass.GetCooldown(self, iLevel) - upgrade

end




function custom_huskar_sacred_earth:OnSpellStart()
if not IsServer() then return end
local point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*100

local particle = ParticleManager:CreateParticle("particles/huskar_earth_hit.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, point)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("Huskar.Sacrifice")
self:GetCaster():EmitSound("Huskar.Sacrifice_2")
CreateModifierThinker( self:GetCaster(), self, "modifier_custom_huskar_life_legendary_thinker", {duration = self:GetSpecialValueFor("delay") }, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false )


AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetCursorPosition(), self:GetSpecialValueFor("radius"), 1.5, false)
end





modifier_custom_huskar_life_legendary_thinker = class({})

function modifier_custom_huskar_life_legendary_thinker:IsHidden() return true end
function modifier_custom_huskar_life_legendary_thinker:IsPurgable() return false end
function modifier_custom_huskar_life_legendary_thinker:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetAbility():GetSpecialValueFor("radius")


local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
self.effect_cast = ParticleManager:CreateParticleForTeam(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent(), self:GetParent():GetTeamNumber())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )

end





function modifier_custom_huskar_life_legendary_thinker:OnDestroy(table)
if not IsServer() then return end

ParticleManager:DestroyParticle( self.effect_cast, true )
ParticleManager:ReleaseParticleIndex( self.effect_cast )

EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Huskar.Sacrifice", self:GetCaster())

local point = self:GetParent():GetAbsOrigin()

local particle = ParticleManager:CreateParticle("particles/huskar_earth_hit.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, point)
ParticleManager:ReleaseParticleIndex(particle)


local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0,  false )
for _,enemy in pairs(enemies) do 
  enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_huskar_life_legendary_slow", {duration = self:GetAbility():GetSpecialValueFor("slow_duration")*(1 - enemy:GetStatusResistance())})
  enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_huskar_life_legendary_stack", {duration = self:GetAbility():GetSpecialValueFor("stack_duration")})

end

if #enemies > 0 then 
  local heal = self:GetCaster():GetMaxHealth()*self:GetAbility():GetSpecialValueFor("heal")/100
  my_game:GenericHeal(self:GetCaster(), heal, self:GetAbility())
end

end


modifier_custom_huskar_life_legendary_slow = class({})
------------------------------
function modifier_custom_huskar_life_legendary_slow:IsPurgable() 
return true end


function modifier_custom_huskar_life_legendary_slow:IsHidden() return true end

function modifier_custom_huskar_life_legendary_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_custom_huskar_life_legendary_slow:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  
  -- AbilitySpecials
  self.movespeed  = self.ability:GetSpecialValueFor("slow")
end

function modifier_custom_huskar_life_legendary_slow:OnRefresh()
  self:OnCreated()
end

function modifier_custom_huskar_life_legendary_slow:DeclareFunctions()
return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
 end


function modifier_custom_huskar_life_legendary_slow:GetModifierMoveSpeedBonus_Percentage()

    return self.movespeed

end



modifier_custom_huskar_life_legendary_stack = class({})
function modifier_custom_huskar_life_legendary_stack:IsHidden() return false end
function modifier_custom_huskar_life_legendary_stack:IsPurgable() return false end
function modifier_custom_huskar_life_legendary_stack:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
local particle_cast = "particles/huskar_earth_stack.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)


end


function modifier_custom_huskar_life_legendary_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end



function modifier_custom_huskar_life_legendary_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if self.effect_cast then  
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end

end


function modifier_custom_huskar_life_legendary_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_custom_huskar_life_legendary_stack:OnTooltip() return self:GetStackCount()*self:GetAbility():GetSpecialValueFor("stack_damage")

end





modifier_custom_huskar_life_legendary_double = class({})
function modifier_custom_huskar_life_legendary_double:IsHidden() return false end
function modifier_custom_huskar_life_legendary_double:IsPurgable() return false end
function modifier_custom_huskar_life_legendary_double:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_huskar_life_legendary_double:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(self:GetAbility().double_delay)
self.count = true
end


function modifier_custom_huskar_life_legendary_double:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_huskar_life_legendary_double:GetEffectName() return "particles/huskar_fire.vpcf" end
 
function modifier_custom_huskar_life_legendary_double:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_custom_huskar_life_legendary_double:GetTexture() return "buffs/berserker_active" end


function modifier_custom_huskar_life_legendary_double:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if self:GetParent() ~= params.unit then return end
if self:GetCaster() ~= params.attacker then return end
--if not params.inflictor then return end
--if params.inflictor ~= self:GetAbility() then return end
--if self.count == false then return end

--self.count = false
self:SetStackCount(self:GetStackCount() + self:GetAbility().double_damage[self:GetCaster():GetUpgradeStack("modifier_huskar_leap_shield")]*params.damage)

end


function modifier_custom_huskar_life_legendary_double:OnDestroy()
if not IsServer() then return end
if self:GetStackCount() == 0 then return end
if not self:GetParent():IsAlive() then return end

local damage = self:GetStackCount()
local target = self:GetParent()
local damageTable_self = {
victim      = self:GetParent(),
attacker    = self:GetCaster(),
damage      = damage,
damage_type   = DAMAGE_TYPE_PURE,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
ability     = self:GetAbility(),
    }
ApplyDamage(damageTable_self)


my_game:GenericHeal(self:GetCaster(), damage, self:GetAbility())
target:EmitSound("Hero_Huskar.Life_Break.Impact")
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControl(particle, 1, target:GetOrigin())
ParticleManager:ReleaseParticleIndex(particle)

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_life_break_spellstart.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControl(particle, 1, target:GetOrigin())
ParticleManager:ReleaseParticleIndex(particle)
end