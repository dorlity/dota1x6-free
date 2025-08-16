LinkLuaModifier( "modifier_lina_light_strike_array_custom", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_slow", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_fire", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_fire_effect", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_fire_damage", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_legendary", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_legendary_caster", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_triple", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_blink", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_range", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_light_strike_array_custom_shield", "abilities/lina/lina_light_strike_array_custom", LUA_MODIFIER_MOTION_NONE )


lina_light_strike_array_custom = class({})

function lina_light_strike_array_custom:CreateTalent()
self:ToggleAutoCast()
end

function lina_light_strike_array_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", context )

PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context )
PrecacheResource( "particle", "particles/lina/array_fire.vpcf", context )
PrecacheResource( "particle", "particles/general/generic_armor_reduction.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_burn.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_qop_tgt_arcana.vpcf", context )
PrecacheResource( "particle", "particles/lina/stun_clone.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf", context )
PrecacheResource( "particle", "particles/lina_timer.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_start.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_end.vpcf", context )
PrecacheResource( "particle", "particles/lina/array_shield.vpcf", context ) 
PrecacheResource( "particle", "particles/status_fx/status_effect_armadillo_shield.vpcf", context )
PrecacheResource( "particle", "particles/lina/stun_stack.vpcf", context )

end



function lina_light_strike_array_custom:GetAbilityTextureName()

if self:GetCaster():HasModifier("modifier_lina_light_strike_array_custom_legendary_caster") then 
  return "phoenix_launch_fire_spirit"
end 

if self:GetCaster():HasModifier("modifier_lina_immrotal_ti7_custom_golden") then
    return "lina/lina_ti7_immortal/lina_lightstrike_array_gold"
end
if self:GetCaster():HasModifier("modifier_lina_immrotal_ti7_custom") then
    return "lina/lina_ti7_immortal/lina_light_strike_array"
end
return "lina_light_strike_array"

end


function lina_light_strike_array_custom:GetBehavior()

local bonus = 0

if self:GetCaster():HasTalent("modifier_lina_array_legendary") then 
  bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

if self:GetCaster():HasModifier("modifier_lina_light_strike_array_custom_legendary_caster") then 
  return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + bonus
end 

return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + bonus
end



function lina_light_strike_array_custom:GetCastPoint()
local bonus = 0
if self:GetCaster():HasTalent("modifier_lina_array_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_lina_array_5", "cast")
end 

return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end


function lina_light_strike_array_custom:GetManaCost(iLevel)

if self:GetCaster():HasModifier("modifier_lina_light_strike_array_custom_legendary_caster") then 
  return 0
end

return self.BaseClass.GetManaCost(self, iLevel)
end



function lina_light_strike_array_custom:GetCastRange(vLocation, hTarget)
local bonus = 0

if self:GetCaster():HasTalent("modifier_lina_array_2") then 
  bonus = self:GetCaster():GetTalentValue("modifier_lina_array_2", "range")
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + bonus
end


function lina_light_strike_array_custom:GetCooldown(iLevel)
local bonus = 0 

if self:GetCaster():HasTalent("modifier_lina_array_6") then 
  bonus = self:GetCaster():GetTalentValue("modifier_lina_array_6", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function lina_light_strike_array_custom:GetAOERadius()
local bonus = 0 

if self:GetCaster():HasTalent("modifier_lina_array_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_lina_array_5", "radius")
end

return self:GetSpecialValueFor( "light_strike_array_aoe" ) + bonus
end


function lina_light_strike_array_custom:GetDamage()
if not IsServer() then return end
local caster = self:GetCaster()

local damage = self:GetSpecialValueFor( "light_strike_array_damage" ) + caster:GetTalentValue("modifier_lina_array_1", "damage")*caster:GetAverageTrueAttackDamage(nil)/100

return damage
end


function lina_light_strike_array_custom:PlayEffect(point, radius)
if not IsServer() then return end 
local caster = self:GetCaster()

local particle_name_stun = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
if caster:HasModifier("modifier_lina_immrotal_ti7_custom_golden") then
  particle_name_stun = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7_gold.vpcf"
elseif caster:HasModifier("modifier_lina_immrotal_ti7_custom") then
  particle_name_stun = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
end
local particle_end = ParticleManager:CreateParticle( particle_name_stun, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle_end, 0, point )
ParticleManager:SetParticleControl( particle_end, 1, Vector( radius, 1, 1 ) )
ParticleManager:ReleaseParticleIndex( particle_end )

EmitSoundOnLocationWithCaster( point, "Ability.LightStrikeArray", caster )
end 



function lina_light_strike_array_custom:GetCastAnimation()
if self:GetCaster():HasTalent("modifier_lina_array_5") then 
  return 0
end 
  return ACT_DOTA_CAST_ABILITY_2
end


function lina_light_strike_array_custom:OnAbilityPhaseStart()

if self:GetCaster():HasTalent("modifier_lina_array_5") then 
  local cast = self:GetSpecialValueFor("AbilityCastPoint")
  self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, cast/(cast + self:GetCaster():GetTalentValue("modifier_lina_array_5", "cast"))*0.5)
end 

return true
end

function lina_light_strike_array_custom:OnAbilityPhaseInterrupted()
if not self:GetCaster():HasTalent("modifier_lina_array_5") then return end

self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_2)
end 







function lina_light_strike_array_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()

local mod = caster:FindModifierByName("modifier_lina_light_strike_array_custom_legendary_caster")

if mod then 

  local clone = caster.lina_clone
  if clone and not clone:IsNull() and clone:IsAlive() then 
    clone:RemoveModifierByName("modifier_lina_light_strike_array_custom_legendary")

    if self:GetAutoCastState() then 
      caster:SetForwardVector(clone:GetForwardVector())
      caster:FaceTowards(clone:GetAbsOrigin() + clone:GetForwardVector()*10)
      caster:AddNewModifier(caster, self, "modifier_lina_light_strike_array_custom_blink", {duration = 0.05, x = clone:GetAbsOrigin().x, y = clone:GetAbsOrigin().y})
    end

  end 

  mod:Destroy()

  return
end 


local point = self:GetCursorPosition()
local duration = self:GetSpecialValueFor( "light_strike_array_delay_time" )


if caster:HasTalent("modifier_lina_array_5") then 
  CreateModifierThinker( caster, self, "modifier_lina_light_strike_array_custom", {duration = duration, main = 0}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false )
end

if caster:HasTalent("modifier_lina_array_legendary") then 

  caster:AddNewModifier(caster, self, "modifier_lina_light_strike_array_custom_legendary_caster", {duration = duration + caster:GetTalentValue("modifier_lina_array_legendary", "duration") + FrameTime()*2})

  self:EndCooldown()
  self:StartCooldown(duration + 0.2)
end 

if caster:HasTalent("modifier_lina_array_2") then 
  caster:AddNewModifier(caster, self, "modifier_lina_light_strike_array_custom_range", {duration = caster:GetTalentValue("modifier_lina_array_2", "duration")})
end 

CreateModifierThinker( caster, self, "modifier_lina_light_strike_array_custom", {duration = duration, main = 1}, point, caster:GetTeamNumber(), false )
end





modifier_lina_light_strike_array_custom = class({})

function modifier_lina_light_strike_array_custom:IsHidden() return true end
function modifier_lina_light_strike_array_custom:IsPurgable() return false end

function modifier_lina_light_strike_array_custom:OnCreated( kv )
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.point = self.parent:GetAbsOrigin()
self.soul = self.caster:FindAbilityByName("lina_fiery_soul_custom")

self.main = kv.main

self.stun_duration = self:GetAbility():GetSpecialValueFor( "light_strike_array_stun_duration" ) + self.caster:GetTalentValue("modifier_lina_array_1", "stun")
self.radius = self:GetAbility():GetSpecialValueFor( "light_strike_array_aoe" ) + self.caster:GetTalentValue("modifier_lina_array_5", "radius")
self.damage = self:GetAbility():GetDamage()

self.resist_duration = self.caster:GetTalentValue("modifier_lina_dragon_1", "duration")

if kv.duration ~= 0 then 
  local particlename = "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf"
  if self.caster:HasModifier("modifier_lina_immrotal_ti7_custom_golden") then
    particlename = "particles/econ/items/lina/lina_ti7/light_strike_array_pre_ti7_gold.vpcf"
  elseif self.caster:HasModifier("modifier_lina_immrotal_ti7_custom") then
    particlename = "particles/econ/items/lina/lina_ti7/light_strike_array_pre_ti7.vpcf"
  end

  local particle = ParticleManager:CreateParticleForTeam( particlename, PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeamNumber() )
  ParticleManager:SetParticleControl( particle, 0, self.point )
  ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
  ParticleManager:ReleaseParticleIndex( particle )
  local cast_sound = "Ability.PreLightStrikeArray"
  if self.caster:HasModifier("modifier_lina_immrotal_ti7_custom") or self.caster:HasModifier("modifier_lina_immrotal_ti7_custom_golden") then
    cast_sound = "Ability.PreLightStrikeArray.ti7"
  end

  EmitSoundOnLocationForAllies( self.point, cast_sound, self.caster)
end

end



function modifier_lina_light_strike_array_custom:OnDestroy()
if not IsServer() then return end

if self.caster:HasTalent("modifier_lina_array_legendary") and self.main == 1 then 

  local delay = self.caster:GetTalentValue("modifier_lina_array_legendary", "duration")
  local point = self.point
  if point == self.caster:GetAbsOrigin() then 
    point = point + self.caster:GetForwardVector()*5
  end 


  local illusion_self = CreateIllusions(self.caster, self.caster, {
    outgoing_damage = -100,
    incoming_damage = self.caster:GetTalentValue("modifier_lina_array_legendary", "incoming") - 100,
    duration = delay 
  }, 1, 0, false, false)

  for _,illusion in pairs(illusion_self) do

    illusion:SetHealth(illusion:GetMaxHealth())

    illusion.owner = self.caster

    illusion:AddNewModifier(self.caster, self.ability, "modifier_lina_light_strike_array_custom_legendary",  {duration = delay})
    illusion:AddNewModifier(self.caster, self.ability, "modifier_chaos_knight_phantasm_illusion", {})
    illusion:SetOrigin(GetGroundPosition(point, nil))

    local vec = (point - self.caster:GetAbsOrigin())
    vec.z = 0
    illusion:SetForwardVector(vec:Normalized())
    illusion:FaceTowards(illusion:GetAbsOrigin() + vec:Normalized()*10)
    FindClearSpaceForUnit(illusion, illusion:GetAbsOrigin(), false)
  end
end


GridNav:DestroyTreesAroundPoint( self:GetParent():GetAbsOrigin(), self.radius, false )

local enemies = self.caster:FindTargets(self.radius, self.point)

if self.caster:HasTalent("modifier_lina_array_6") and self.main == 1 and #enemies > 0 then 
  self.caster:RemoveModifierByName("modifier_lina_light_strike_array_custom_shield")
  self.caster:AddNewModifier(self.caster, self.ability, "modifier_lina_light_strike_array_custom_shield", {duration = self.caster:GetTalentValue("modifier_lina_array_6", "duration")})
end

if self.caster:HasTalent("modifier_lina_array_4") then 
  CreateModifierThinker(self.caster, self.ability, "modifier_lina_light_strike_array_custom_fire", {duration = self.caster:GetTalentValue("modifier_lina_array_4", "duration")}, self.point, self.caster:GetTeamNumber(), false)
end

local damage = self.damage
if self.soul and not self.soul:IsNull() and self.soul:GetLevel() > 0 then 
  damage = damage + self.soul:GetShardDamage()
end 

local damage_ability = nil
if self.main == 0 then 
  damage_ability = "modifier_lina_array_5"
  damage = damage * self.caster:GetTalentValue("modifier_lina_array_5", "damage")/100
end 

for _,enemy in pairs(enemies) do

  if enemy:IsRealHero() and self.caster:GetQuest() == "Lina.Quest_6" then 
    self.caster:UpdateQuest(1)
  end
  if self.caster:GetQuest() == "Lina.Quest_7" and enemy:IsRealHero() and not self.caster:QuestCompleted() then 
    enemy:AddNewModifier(self.caster, self.ability, "modifier_lina_fiery_soul_custom_quest", {duration = self.caster.quest.number})
  end

  if self.caster:HasTalent("modifier_lina_dragon_1") then 
    enemy:AddNewModifier(self.caster, self.ability, "modifier_lina_dragon_slave_custom_magic", {duration = self.resist_duration})
  end 

  local stun = enemy:AddNewModifier( self.caster, self.ability, "modifier_generic_stun", { duration = self.stun_duration * (1 - enemy:GetStatusResistance()) } )

  if stun and not stun:IsNull() then 
    stun:SetEndRule(function()
      if self.caster:HasTalent("modifier_lina_array_3") then 
        enemy:AddNewModifier(self.caster, self.ability, "modifier_lina_light_strike_array_custom_slow", {duration = self.caster:GetTalentValue("modifier_lina_array_3", "duration")})
      end 
    end)
  end

  DoDamage({victim = enemy, attacker = self.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability }, damage_ability)
end

self.ability:PlayEffect(self.parent:GetAbsOrigin(), self.radius)

if self.caster:HasTalent("modifier_lina_soul_4") and #enemies > 0 then 
  self.caster:AddNewModifier(self.caster, self.ability, "modifier_lina_fiery_soul_custom_stack", {duration = self.caster:GetTalentValue("modifier_lina_soul_4", "duration", true)})
end 

UTIL_Remove( self.parent )
end







modifier_lina_light_strike_array_custom_slow = class({})
function modifier_lina_light_strike_array_custom_slow:IsHidden() return true end
function modifier_lina_light_strike_array_custom_slow:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_slow:GetEffectName() return "particles/units/heroes/hero_terrorblade/ember_slow.vpcf" end
function modifier_lina_light_strike_array_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_lina_light_strike_array_custom_slow:GetModifierDamageOutgoing_Percentage()
return self.damage
end

function modifier_lina_light_strike_array_custom_slow:GetModifierSpellAmplify_Percentage() 
return self.damage
end

function modifier_lina_light_strike_array_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_lina_light_strike_array_custom_slow:OnCreated()
local caster = self:GetCaster()
self.slow = caster:GetTalentValue("modifier_lina_array_3", "slow")
self.damage = caster:GetTalentValue("modifier_lina_array_3", "damage")

end 





modifier_lina_light_strike_array_custom_fire = class({})
function modifier_lina_light_strike_array_custom_fire:IsHidden() return true end
function modifier_lina_light_strike_array_custom_fire:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_fire:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.radius = self:GetCaster():GetTalentValue("modifier_lina_array_4", "radius")
self.duration = self:GetCaster():GetTalentValue("modifier_lina_array_4", "duration")

self.start_pos = self:GetParent():GetAbsOrigin()

self.nFXIndex = ParticleManager:CreateParticle("particles/lina/array_fire.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.nFXIndex, 0, self.parent:GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 1, self.parent:GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(self.radius, 0, 0))
ParticleManager:SetParticleControl(self.nFXIndex, 4, Vector(self.duration - 0.5, 0, 0))
ParticleManager:ReleaseParticleIndex(self.nFXIndex)

self:AddParticle(self.nFXIndex,false,false,-1,false,false)

self.parent:EmitSound("Lina.Array_burn")
end


function modifier_lina_light_strike_array_custom_fire:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Lina.Array_burn")
end


function modifier_lina_light_strike_array_custom_fire:IsAura() return true end
function modifier_lina_light_strike_array_custom_fire:GetAuraDuration() return 0.1 end
function modifier_lina_light_strike_array_custom_fire:GetAuraRadius() return self.radius end
function modifier_lina_light_strike_array_custom_fire:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_lina_light_strike_array_custom_fire:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_lina_light_strike_array_custom_fire:GetModifierAura() return "modifier_lina_light_strike_array_custom_fire_effect" end




modifier_lina_light_strike_array_custom_fire_effect = class({})
function modifier_lina_light_strike_array_custom_fire_effect:IsHidden() return true end
function modifier_lina_light_strike_array_custom_fire_effect:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_fire_effect:OnCreated()
if not IsServer() then return end 
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.damage = self.caster:GetTalentValue("modifier_lina_array_4", "damage")
self.interval = self.caster:GetTalentValue("modifier_lina_array_4", "interval")
self.duration = self.caster:GetTalentValue("modifier_lina_array_4", "damage_duration")

self.damage = self.damage*self.interval
self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage}

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 


function modifier_lina_light_strike_array_custom_fire_effect:OnIntervalThink()
if not IsServer() then return end 

self.parent:EmitSound("Lina.Array_burn_target")

DoDamage(self.damageTable, "modifier_lina_array_4")
self.parent:AddNewModifier(self.caster, self.ability, "modifier_lina_light_strike_array_custom_fire_damage", {duration = self.duration})
end 





modifier_lina_light_strike_array_custom_fire_damage = class({})
function modifier_lina_light_strike_array_custom_fire_damage:IsHidden() return false end
function modifier_lina_light_strike_array_custom_fire_damage:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_fire_damage:GetTexture() return "buffs/array_double" end
function modifier_lina_light_strike_array_custom_fire_damage:OnCreated()

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.RemoveForDuel = true

self.max = self.caster:GetTalentValue("modifier_lina_array_4", "max")
self.damage = self.caster:GetTalentValue("modifier_lina_array_4", "damage_inc")

if not IsServer() then return end
self.effect = nil
end 

function modifier_lina_light_strike_array_custom_fire_damage:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
  self.parent:EmitSound("Hoodwink.Acorn_armor")
end 

end

function modifier_lina_light_strike_array_custom_fire_damage:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if not self.effect then
  self.effect = self.parent:GenericParticle("particles/lina/stun_stack.vpcf", self, true)
end

ParticleManager:SetParticleControl(self.effect, 1, Vector(0, self:GetStackCount(), 0))
end


function modifier_lina_light_strike_array_custom_fire_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_lina_light_strike_array_custom_fire_damage:GetModifierIncomingDamage_Percentage()
return self.damage*self:GetStackCount()
end

function modifier_lina_light_strike_array_custom_fire_damage:GetEffectName()
return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end
function modifier_lina_light_strike_array_custom_fire_damage:GetStatusEffectName()
return "particles/status_fx/status_effect_burn.vpcf"
end

function modifier_lina_light_strike_array_custom_fire_damage:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end









modifier_lina_light_strike_array_custom_legendary = class({})
function modifier_lina_light_strike_array_custom_legendary:IsHidden() return true end
function modifier_lina_light_strike_array_custom_legendary:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_qop_tgt_arcana.vpcf" end
function modifier_lina_light_strike_array_custom_legendary:StatusEffectPriority() return MODIFIER_PRIORITY_ILLUSION end


function modifier_lina_light_strike_array_custom_legendary:GetEffectName()
return "particles/lina/stun_clone.vpcf"
end


function modifier_lina_light_strike_array_custom_legendary:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.speed = self.caster:GetTalentValue("modifier_lina_array_legendary", "speed")

if not IsServer() then return end

self.range = self.parent:Script_GetAttackRange()*-1
self.player = PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID())
self.caster.lina_clone = self.parent

self.burn_particle = ParticleManager:CreateParticle( "particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
self:AddParticle(self.burn_particle,false, false, -1, false, false)

self.max_time = self:GetRemainingTime()

self.damage = self.caster:GetTalentValue("modifier_lina_array_legendary", "damage")/100
self.radius = self.caster:GetTalentValue("modifier_lina_array_legendary", "radius")
self.duration = self.caster:GetTalentValue("modifier_lina_array_legendary", "duration")
self.stun = self.caster:GetTalentValue("modifier_lina_array_legendary", "stun")

self.time = self:GetRemainingTime()

self.interval = 0.5
self.t = -1

self.timer = self.duration*2 
self:StartIntervalThink(self.interval)
self:OnIntervalThink()
end



function modifier_lina_light_strike_array_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.t = self.t + 1

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5 end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
  decimal = 8
else 
  decimal = 1
end

local particle = ParticleManager:CreateParticle("particles/lina_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)
end




function modifier_lina_light_strike_array_custom_legendary:OnDestroy()
if not IsServer() then return end

self.caster.lina_clone = nil
local mod = self.caster:FindModifierByName("modifier_lina_light_strike_array_custom_legendary_caster")

AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 600, 3, false)

self.ability:PlayEffect(self.parent:GetAbsOrigin(), self.radius)

if self.caster:HasTalent("modifier_lina_array_4") then 
  CreateModifierThinker(self.caster, self.ability, "modifier_lina_light_strike_array_custom_fire", {duration = self.caster:GetTalentValue("modifier_lina_array_4", "duration")}, self.parent:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
end

local enemies = self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())

if mod then 

  local damage = self.ability:GetDamage()*self.damage*mod:GetStackCount()
  print(damage)

  for _,enemy in pairs(enemies) do 

    enemy:AddNewModifier( self.caster, self.ability, "modifier_stunned", { duration = self.stun * (1 - enemy:GetStatusResistance()) } )

    if mod:GetStackCount() > 0 then 
      DoDamage({victim = enemy, attacker = self.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability }, "modifier_lina_array_legendary")
    end
  end 

  mod:Destroy()
end

if self.caster:HasTalent("modifier_lina_soul_4") and #enemies > 0 then 
  self.caster:AddNewModifier(self.caster, self.ability, "modifier_lina_fiery_soul_custom_stack", {duration = self.caster:GetTalentValue("modifier_lina_soul_4", "duration", true)})
end 

self.parent:Kill(nil, nil) 
end




function modifier_lina_light_strike_array_custom_legendary:CheckState()
return
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_DISARMED] = true,
}
end

function modifier_lina_light_strike_array_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_lina_light_strike_array_custom_legendary:GetModifierMoveSpeed_Absolute()
return self.speed
end


function modifier_lina_light_strike_array_custom_legendary:GetModifierAttackRangeBonus()
if not IsServer() then return end
if not self.range then return end
return self.range
end










modifier_lina_light_strike_array_custom_blink = class({})
function modifier_lina_light_strike_array_custom_blink:IsHidden() return true end
function modifier_lina_light_strike_array_custom_blink:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_blink:OnCreated(table)
if not IsServer() then return end 
self.parent = self:GetParent()
self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.parent:NoDraw(self)
self.parent:AddNoDraw()

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Lina.Array_blink", self.parent)

local effect_end = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect_end, 0, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(effect_end)

ProjectileManager:ProjectileDodge(self.parent)

self.parent:SetAbsOrigin(self.point)
FindClearSpaceForUnit(self.parent, self.point, false)
end 


function modifier_lina_light_strike_array_custom_blink:CheckState()
return
{
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_STUNNED] = true
}
end

function modifier_lina_light_strike_array_custom_blink:OnDestroy()
if not IsServer() then return end 


local effect_end = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect_end, 0, self.point)
ParticleManager:ReleaseParticleIndex(effect_end)
self.parent:Stop()
self.parent:RemoveNoDraw()
end 





modifier_lina_light_strike_array_custom_range = class({})
function modifier_lina_light_strike_array_custom_range:IsHidden() return false end
function modifier_lina_light_strike_array_custom_range:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_range:GetTexture() return "buffs/acorn_range" end
function modifier_lina_light_strike_array_custom_range:OnCreated()
 
self.range = self:GetCaster():GetTalentValue("modifier_lina_array_2", "attack")
end

function modifier_lina_light_strike_array_custom_range:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_lina_light_strike_array_custom_range:GetModifierAttackRangeBonus()
return self.range
end








modifier_lina_light_strike_array_custom_shield = class({})
function modifier_lina_light_strike_array_custom_shield:IsHidden() return false end
function modifier_lina_light_strike_array_custom_shield:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_shield:GetTexture() return "buffs/berserker_armor" end
function modifier_lina_light_strike_array_custom_shield:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.shield_talent = "modifier_lina_array_6"
self.max_shield = self.parent:GetMaxHealth()*self.parent:GetTalentValue("modifier_lina_array_6", "max")/100
self.shield = self.parent:GetTalentValue("modifier_lina_array_6", "shield")/100
self.creeps = self.parent:GetTalentValue("modifier_lina_array_6", "creeps")

if not IsServer() then return end

self.parent:AddDamageEvent_out(self)

self.particle = ParticleManager:CreateParticle("particles/lina/array_shield.vpcf" , PATTACH_CUSTOMORIGIN, self:GetCaster())
ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
self:AddParticle(self.particle,false,false,-1,false,false)

self:SetStackCount(self.parent:GetMaxHealth()*self.parent:GetTalentValue("modifier_lina_array_6", "base")/100)
self.RemoveForDuel = true

end



function modifier_lina_light_strike_array_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_lina_light_strike_array_custom_shield:DamageEvent_out(params)
if not IsServer() then return end 
if not params.attacker then return end 
if self.parent ~= params.attacker then return end 

local unit = params.unit
if not unit:IsHero() and not unit:IsCreep() then return end 
if not unit:IsStunned() then return end
if unit:IsIllusion() then return end

local shield = params.damage*self.shield
if unit:IsCreep() then 
  shield = shield/self.creeps
end 

self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + shield))
end 


function modifier_lina_light_strike_array_custom_shield:GetModifierIncomingDamageConstant( params )

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


function modifier_lina_light_strike_array_custom_shield:GetStatusEffectName()
return "particles/status_fx/status_effect_armadillo_shield.vpcf"
end

function modifier_lina_light_strike_array_custom_shield:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end














modifier_lina_light_strike_array_custom_legendary_caster = class({})
function modifier_lina_light_strike_array_custom_legendary_caster:IsHidden() return true end
function modifier_lina_light_strike_array_custom_legendary_caster:IsPurgable() return false end
function modifier_lina_light_strike_array_custom_legendary_caster:RemoveOnDeath() return false end

function modifier_lina_light_strike_array_custom_legendary_caster:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not IsServer() then return end

self.caster:AddAttackEvent_out(self)

self.max_time = self:GetRemainingTime()

self.max = self.caster:GetTalentValue("modifier_lina_array_legendary", "max")

self.time = self:GetRemainingTime()

self.interval = 0.1

self:StartIntervalThink(self.interval)
self:OnIntervalThink()
end



function modifier_lina_light_strike_array_custom_legendary_caster:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIshort({max_time = self.time, time = self:GetRemainingTime(), stack = self:GetStackCount(), style = "LinaArray"})
end


function modifier_lina_light_strike_array_custom_legendary_caster:OnDestroy()
if not IsServer() then return end

self.ability:UseResources(false, false, false, true)
self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "LinaArray"})
end





function modifier_lina_light_strike_array_custom_legendary_caster:AttackEvent_out(params)
if not IsServer() then return end 
if params.attacker ~= self.caster then return end
if not params.target:IsUnit() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end 


