LinkLuaModifier( "modifier_leshrac_split_earth_custom", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_charge", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_tracker", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_legendary_aoe", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_stack", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_heal", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_legendary", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_move", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_slow", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_leash", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_split_earth_custom_stun", "abilities/leshrac/leshrac_split_earth_custom", LUA_MODIFIER_MOTION_NONE )



leshrac_split_earth_custom = class({})


function leshrac_split_earth_custom:CreateTalent()
self:ToggleAutoCast()
end


function leshrac_split_earth_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth_aoe.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_forcestaff.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/ogre_seal_totem_trail.vpcf", context )
PrecacheResource( "particle", "particles/falcon_blade_charge.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_earth_legendary.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_earth_legendary_stun.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_lifesteal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_stunned.vpcf", context )
PrecacheResource( "particle", "particles/lina_attack_slow.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_enchantress_shard_debuff.vpcf", context )
end



function leshrac_split_earth_custom:GetIntrinsicModifierName()
return "modifier_leshrac_split_earth_custom_tracker"
end


function leshrac_split_earth_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasTalent("modifier_leshrac_earth_4") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_leshrac_earth_4", "cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end



function leshrac_split_earth_custom:GetAOERadius()
local bonus = 0
if self:GetCaster():HasTalent("modifier_leshrac_earth_6") then 
  bonus = self:GetCaster():GetTalentValue("modifier_leshrac_earth_6", "radius")
end
return self:GetSpecialValueFor( "radius" ) + self:GetCaster():GetLeshracRadius() + bonus
end


function leshrac_split_earth_custom:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_leshrac_pulse_nova_custom_low_mana") then
  return self:GetCaster():GetUpgradeStack("modifier_leshrac_pulse_nova_custom_low_mana")
end
return self.BaseClass.GetManaCost(self, iLevel)
end

function leshrac_split_earth_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_leshrac_earth_5") then 
  return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT
end


function leshrac_split_earth_custom:GetCastAnimation()
if self:GetCaster():HasTalent("modifier_leshrac_earth_6") then
  return 0
end 
  return ACT_DOTA_CAST_ABILITY_1
end



function leshrac_split_earth_custom:OnAbilityPhaseStart()

local caster = self:GetCaster()

if caster:HasTalent("modifier_leshrac_earth_6") then 
  local cast = self:GetSpecialValueFor("AbilityCastPoint")
  caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, cast/(cast + caster:GetTalentValue("modifier_leshrac_earth_6", "cast"))*0.9)
end 

return true
end

function leshrac_split_earth_custom:OnAbilityPhaseInterrupted()
if not self:GetCaster():HasTalent("modifier_leshrac_earth_6") then return end

self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end 



function leshrac_split_earth_custom:GetCastPoint()
local bonus = 0
if self:GetCaster():HasTalent("modifier_leshrac_earth_6") then 
  bonus = self:GetCaster():GetTalentValue("modifier_leshrac_earth_6", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function leshrac_split_earth_custom:GetCastRange(vLocation, hTarget)
local upgrade = 0
if self:GetCaster():HasTalent("modifier_leshrac_earth_5") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_leshrac_earth_5", "range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function leshrac_split_earth_custom:GetStunDamage(target)
local damage = self:GetAbilityDamage() + self:GetCaster():GetTalentValue("modifier_leshrac_earth_2", "damage")*self:GetCaster():GetIntellect(false)/100
return damage
end





function leshrac_split_earth_custom:OnSpellStart()

local caster = self:GetCaster()
local point = self:GetCursorPosition()

local delay = self:GetSpecialValueFor("delay")

if caster:HasTalent("modifier_leshrac_earth_7") then 
  caster:AddNewModifier(caster, self, "modifier_leshrac_split_earth_custom_legendary", {duration = caster:GetTalentValue("modifier_leshrac_earth_7", "duration")})
end

if caster:HasTalent("modifier_leshrac_earth_1") then 
  caster:AddNewModifier(caster, self, "modifier_leshrac_split_earth_custom_move", {duration = caster:GetTalentValue("modifier_leshrac_earth_1", "duration")})
end 

if caster:HasTalent("modifier_leshrac_earth_5") and self:GetAutoCastState() == true and not caster:IsRooted() and not caster:IsLeashed() then 

  caster:FadeGesture(ACT_DOTA_CAST_ABILITY_1)

  local distance = (point - self:GetCaster():GetAbsOrigin()):Length2D()
  local speed = self:GetCaster():GetTalentValue("modifier_leshrac_earth_5", "speed")
  local height = 0

  caster:EmitSound("Leshrac.Earth_run_start")

  local mod = caster:AddNewModifier(caster, self, "modifier_leshrac_split_earth_custom_charge", {})

  local arc = caster:AddNewModifier(caster, self, "modifier_generic_arc",
    {
      target_x = point.x,
      target_y = point.y,
      distance = distance,
      speed = speed,
      height = height,
      fix_end = false,
      isStun = true,
      activity = ACT_DOTA_RUN,
      end_anim = ACT_DOTA_CAST_ABILITY_4,
    })

  arc:SetEndCallback(function()
    caster:RemoveModifierByName("modifier_leshrac_split_earth_custom_charge")
  end)

  delay = distance/speed
end


CreateModifierThinker( caster, self, "modifier_leshrac_split_earth_custom", {active = 1, duration = delay, shard = 0 }, point, caster:GetTeamNumber(), false)
end






modifier_leshrac_split_earth_custom = class({})

function modifier_leshrac_split_earth_custom:IsHidden() return true end
function modifier_leshrac_split_earth_custom:IsPurgable() return false end
function modifier_leshrac_split_earth_custom:OnCreated( kv )
if not IsServer() then return end

self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.duration = self:GetAbility():GetSpecialValueFor( "duration" ) + self:GetCaster():GetTalentValue("modifier_leshrac_earth_2", "stun")
self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) + self:GetCaster():GetTalentValue("modifier_leshrac_earth_6", "radius") + self.caster:GetLeshracRadius()

if kv.radius then 
  self.radius = kv.radius
end

self.active = kv.active

if kv.shard == 1 then 
  local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth_aoe.vpcf", PATTACH_WORLDORIGIN, nil )
  ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
  ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
  ParticleManager:ReleaseParticleIndex( effect_cast )
end

end



function modifier_leshrac_split_earth_custom:OnDestroy()
if not IsServer() then return end

local enemies = self:GetCaster():FindTargets(self.radius, self:GetParent():GetAbsOrigin())

for _,enemy in pairs(enemies) do

  if enemy:IsRealHero()  then 
    self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_leshrac_split_earth_custom_stack", {})

    if (self.caster:GetQuest() == "Leshrac.Quest_5") then 
      self.caster:UpdateQuest(1)
    end
  end 
  local damage = self.ability:GetStunDamage(enemy)
  local real_damage = DoDamage({attacker = self.caster, victim = enemy, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage})
  enemy:AddNewModifier( self.caster, self:GetAbility(), "modifier_leshrac_split_earth_custom_stun", { duration = self.duration*(1 - enemy:GetStatusResistance()) } )

end


if self:GetCaster():HasTalent("modifier_leshrac_earth_3") and #enemies > 0 then 

  self.caster:AddNewModifier(self:GetCaster(), self:GetAbility(),  "modifier_leshrac_split_earth_custom_heal", {duration = self.caster:GetTalentValue("modifier_leshrac_earth_3", "duration")})

  self.caster:EmitSound("Puck.Rift_Mana")

  local mana_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_chakra_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(mana_particle, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(mana_particle, 1, self:GetCaster():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(mana_particle)
end


if self:GetCaster():HasShard() and self.active == 1 then 
  CreateModifierThinker( self.caster, self:GetAbility(), "modifier_leshrac_split_earth_custom", {duration = self:GetAbility():GetSpecialValueFor("shard_delay"), radius = self.radius + self:GetAbility():GetSpecialValueFor("shard_radius"), shard = 1, active = 0}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), self.radius, true )

self:PlayEffects()
UTIL_Remove( self:GetParent() )
end



function modifier_leshrac_split_earth_custom:PlayEffects()

local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf"
local sound_cast = "Hero_Leshrac.Split_Earth"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end












modifier_leshrac_split_earth_custom_charge = class({})
function modifier_leshrac_split_earth_custom_charge:IsHidden() return true end
function modifier_leshrac_split_earth_custom_charge:IsPurgable() return false end
function modifier_leshrac_split_earth_custom_charge:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_leshrac_split_earth_custom_charge:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end

function modifier_leshrac_split_earth_custom_charge:OnCreated(table)
if not IsServer() then return end

self.particle_peffect = ParticleManager:CreateParticle("particles/items_fx/ogre_seal_totem_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())   
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

self.particle_peffect1 = ParticleManager:CreateParticle("particles/falcon_blade_charge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())   
self:AddParticle(self.particle_peffect1, false, false, -1, false, true)

self.count = 0

self:GetParent():EmitSound("Leshrac.Earth_run")
self.targets = {}

self:StartIntervalThink(FrameTime())
end

function modifier_leshrac_split_earth_custom_charge:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_leshrac_split_earth_custom_charge:GetActivityTranslationModifiers()
return "staff_run_haste"
end


function modifier_leshrac_split_earth_custom_charge:GetEffectName()
  return "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf"
end

function modifier_leshrac_split_earth_custom_charge:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_leshrac_split_earth_custom_charge:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + FrameTime()
if self.count >= 0.35 then 
  ParticleManager:DestroyParticle(self.particle_peffect1, false)
  ParticleManager:ReleaseParticleIndex(self.particle_peffect1)
end


local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

for _,enemy in pairs(enemies) do
  if  not self.targets[enemy] and enemy:GetUnitName() ~= "npc_teleport" 
    and not (enemy:IsCurrentlyHorizontalMotionControlled() or enemy:IsCurrentlyVerticalMotionControlled()) then

    self.targets[enemy] = true
    local direction = enemy:GetOrigin()-self:GetParent():GetOrigin()

    direction.z = 0
    direction = direction:Normalized()

    local knockbackProperties =
    {
      center_x = enemy:GetOrigin().x,
      center_y = enemy:GetOrigin().y,
      center_z = enemy:GetOrigin().z,
      duration = 0.4,
      knockback_duration = 0.4,
      knockback_distance = 50,
      knockback_height = 100
    }
    enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", knockbackProperties )
  end
end


end






modifier_leshrac_split_earth_custom_tracker = class({})
function modifier_leshrac_split_earth_custom_tracker:IsHidden() return true end
function modifier_leshrac_split_earth_custom_tracker:IsPurgable() return false end



function modifier_leshrac_split_earth_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

}
end

function modifier_leshrac_split_earth_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.bonus_k = self:GetCaster():GetTalentValue("modifier_leshrac_earth_1", "bonus", true)
end



function modifier_leshrac_split_earth_custom_tracker:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_leshrac_earth_1") then return end 

local bonus = self.parent:GetTalentValue("modifier_leshrac_earth_1", "move")
if self.parent:HasModifier("modifier_leshrac_split_earth_custom_move") then 
  bonus = bonus*self.bonus_k
end 

return bonus
end







modifier_leshrac_split_earth_custom_legendary_aoe = class({})
function modifier_leshrac_split_earth_custom_legendary_aoe:IsHidden() return false end
function modifier_leshrac_split_earth_custom_legendary_aoe:IsPurgable() return false end
function modifier_leshrac_split_earth_custom_legendary_aoe:OnCreated(table)

self.caster = self:GetCaster()
self.damage = self.caster:GetTalentValue("modifier_leshrac_earth_7", "damage")/100
self.stun = self.caster:GetTalentValue("modifier_leshrac_earth_7", "stun")
if not IsServer() then return end
self:GetParent():EmitSound("Leshrac.Earth_legendary_pre")

self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) + self.caster:GetTalentValue("modifier_leshrac_earth_6", "radius") + self.caster:GetLeshracRadius()

local effect_cast = ParticleManager:CreateParticle( "particles/leshrac_earth_legendary.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )
self:AddParticle(effect_cast, false, false, -1, false, true)

end

function modifier_leshrac_split_earth_custom_legendary_aoe:OnDestroy()
if not IsServer() then return end

GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), self.radius, true )


for _,target in pairs(self.caster:FindTargets(self.radius, self:GetParent():GetAbsOrigin())) do
  local knockbackProperties =
  {
    center_x = target:GetOrigin().x,
    center_y = target:GetOrigin().y,
    center_z = target:GetOrigin().z,
    duration = self.stun*(1 - target:GetStatusResistance()),
    knockback_duration = self.stun,
    knockback_distance = 0,
    knockback_height = 150
  }

  DoDamage( { attacker = self.caster,victim = target, damage = self:GetAbility():GetStunDamage(target)*self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), }, "modifier_leshrac_earth_7")

  target:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", knockbackProperties )
end


local particle_cast = "particles/leshrac_earth_legendary_stun.vpcf"
local sound_cast = "Leshrac.Earth_legendary"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self.caster )

end








modifier_leshrac_split_earth_custom_stack = class({})
function modifier_leshrac_split_earth_custom_stack:IsHidden() return not self:GetParent():HasTalent("modifier_leshrac_earth_4") end
function modifier_leshrac_split_earth_custom_stack:IsPurgable() return false end
function modifier_leshrac_split_earth_custom_stack:RemoveOnDeath() return false end
function modifier_leshrac_split_earth_custom_stack:GetTexture() return "buffs/earth_stack" end
function modifier_leshrac_split_earth_custom_stack:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_leshrac_earth_4", "max", true)
if self.max <= 0 then
  self:Destroy()
  return
end
self.parent = self:GetParent()

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(0.5)
end


function modifier_leshrac_split_earth_custom_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_leshrac_split_earth_custom_stack:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_leshrac_earth_4") then return end 

if self:GetStackCount() >= self.max then 


  self:GetParent():EmitSound("BS.Thirst_legendary_active")
  local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_peffect)
  
  self:StartIntervalThink(-1)
end

end 


function modifier_leshrac_split_earth_custom_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

 
function modifier_leshrac_split_earth_custom_stack:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*(self.parent:GetTalentValue("modifier_leshrac_earth_4", "damage")/self.max)
end 








modifier_leshrac_split_earth_custom_heal = class({})
function modifier_leshrac_split_earth_custom_heal:IsHidden() return false end
function modifier_leshrac_split_earth_custom_heal:IsPurgable() return true end
function modifier_leshrac_split_earth_custom_heal:GetTexture() return "buffs/nova_damage" end

function modifier_leshrac_split_earth_custom_heal:OnCreated(table)
self.heal = (self:GetCaster():GetTalentValue("modifier_leshrac_earth_3", "heal")*self:GetCaster():GetMaxMana()/100)/self:GetRemainingTime()

if not IsServer() then return end

self:StartIntervalThink(1)
end

function modifier_leshrac_split_earth_custom_heal:OnIntervalThink()
if not IsServer() then return end
local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal, nil)
end


function modifier_leshrac_split_earth_custom_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
  MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
}
end

function modifier_leshrac_split_earth_custom_heal:GetModifierConstantHealthRegen()
return self.heal
end

function modifier_leshrac_split_earth_custom_heal:GetModifierConstantManaRegen()
return self.heal
end


function modifier_leshrac_split_earth_custom_heal:GetEffectName()
return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf"
end


modifier_leshrac_split_earth_custom_legendary = class({})
function modifier_leshrac_split_earth_custom_legendary:IsHidden() return true end
function modifier_leshrac_split_earth_custom_legendary:IsPurgable() return false end
function modifier_leshrac_split_earth_custom_legendary:OnCreated()
self.caster = self:GetCaster()
self.aoe = self.caster:GetTalentValue("modifier_leshrac_earth_7", "aoe")
self.delay = self.caster:GetTalentValue("modifier_leshrac_earth_7", "delay")
self.distance = self.caster:GetTalentValue("modifier_leshrac_earth_7", "distance")
self.pass = 0

if not IsServer() then return end 

self.time = self:GetRemainingTime()

self.parent = self.caster
self.pos = self.parent:GetAbsOrigin()

self.interval = FrameTime()
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 

function modifier_leshrac_split_earth_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.caster:UpdateUIshort({max_time = self.time, time = self:GetRemainingTime(), stack = self:GetRemainingTime(), use_zero = 1, style = "LeshracSplit"})
local pos = self.parent:GetAbsOrigin()
self.pass = self.pass + (pos - self.pos):Length2D() 
self.pos = pos

if self.pass < self.distance then return end

self.pass = 0

CreateModifierThinker( self.parent, self:GetAbility(), "modifier_leshrac_split_earth_custom_legendary_aoe", {duration = self:GetRemainingTime(), }, self.parent:GetAbsOrigin(), self.parent:GetTeamNumber(), false)
end 



function modifier_leshrac_split_earth_custom_legendary:OnDestroy()
if not IsServer() then return end

self.caster:UpdateUIshort({hide = 1, hide_full = 1, style = "LeshracSplit"})
end 




modifier_leshrac_split_earth_custom_move = class({})
function modifier_leshrac_split_earth_custom_move:IsHidden() return true end
function modifier_leshrac_split_earth_custom_move:IsPurgable() return false end
function modifier_leshrac_split_earth_custom_move:GetEffectName()
return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end







modifier_leshrac_split_earth_custom_stun = class({})

function modifier_leshrac_split_earth_custom_stun:IsHidden() return true end
function modifier_leshrac_split_earth_custom_stun:IsStunDebuff() return true end
function modifier_leshrac_split_earth_custom_stun:IsPurgeException() return true end
function modifier_leshrac_split_earth_custom_stun:CheckState()
return
{
  [MODIFIER_STATE_STUNNED] = true
}
end

function modifier_leshrac_split_earth_custom_stun:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_leshrac_split_earth_custom_stun:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end


function modifier_leshrac_split_earth_custom_stun:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end


function modifier_leshrac_split_earth_custom_stun:GetOverrideAnimation()
return ACT_DOTA_DISABLED
end


function modifier_leshrac_split_earth_custom_stun:OnDestroy()
if not IsServer() then return end

local parent = self:GetParent()
local caster = self:GetCaster()

if parent:IsInvulnerable() then return end

if caster:HasTalent("modifier_leshrac_earth_1") then 
  parent:AddNewModifier(caster, self:GetAbility(), "modifier_leshrac_split_earth_custom_slow", {duration = (1 - parent:GetStatusResistance())*caster:GetTalentValue("modifier_leshrac_earth_1", "duration")})
end 

if caster:HasTalent("modifier_leshrac_earth_6") then
  parent:AddNewModifier(caster, self:GetAbility(), "modifier_leshrac_split_earth_custom_leash", {duration = (1 - parent:GetStatusResistance())*caster:GetTalentValue("modifier_leshrac_earth_6", "duration")})
end


end









modifier_leshrac_split_earth_custom_slow = class({})
function modifier_leshrac_split_earth_custom_slow:IsHidden() return true end
function modifier_leshrac_split_earth_custom_slow:IsPurgable() return true end
function modifier_leshrac_split_earth_custom_slow:GetEffectName() return "particles/lina_attack_slow.vpcf" end
function modifier_leshrac_split_earth_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_leshrac_split_earth_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end 


function modifier_leshrac_split_earth_custom_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_leshrac_earth_1", "slow")
end

function modifier_leshrac_split_earth_custom_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_enchantress_shard_debuff.vpcf"
end

function modifier_leshrac_split_earth_custom_slow:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end










modifier_leshrac_split_earth_custom_leash = class({})
function modifier_leshrac_split_earth_custom_leash:IsHidden() return true end
function modifier_leshrac_split_earth_custom_leash:IsPurgable() return false end
function modifier_leshrac_split_earth_custom_leash:CheckState()
return
{
  [MODIFIER_STATE_TETHERED] = true
}
end
