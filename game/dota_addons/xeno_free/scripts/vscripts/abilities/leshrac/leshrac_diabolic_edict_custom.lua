LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_speed", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_legendary", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_legendary_damage", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_diabolic_edict_custom_tracker", "abilities/leshrac/leshrac_diabolic_edict_custom", LUA_MODIFIER_MOTION_NONE )

leshrac_diabolic_edict_custom = class({})


leshrac_diabolic_edict_custom.cd_inc = {-2, -4, -6}

leshrac_diabolic_edict_custom.mana_steal = {0.15, 0.2, 0.25}

leshrac_diabolic_edict_custom.count_inc = {8, 12, 16}

leshrac_diabolic_edict_custom.heal_amount = 0.3
leshrac_diabolic_edict_custom.heal_amount_creeps = 0.33
leshrac_diabolic_edict_custom.heal_health = 30



leshrac_diabolic_edict_custom.distance_max = 500
leshrac_diabolic_edict_custom.distance_duration = 3
leshrac_diabolic_edict_custom.distance_count = 5
leshrac_diabolic_edict_custom.distance_damage = {4, 6}
leshrac_diabolic_edict_custom.distance_incoming = {-4, -6}


function leshrac_diabolic_edict_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_diabolic_legendary_damage.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/lesh_charges.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/ogre_dd.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_speed.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_edict_legendary.vpcf", context )
PrecacheResource( "particle", "particles/lesh_edict_stun.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_edict_mark.vpcf", context )
PrecacheResource( "particle", "particles/cleance_blade.vpcf", context )

end






function leshrac_diabolic_edict_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_leshrac_edict_2") then  
  upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_leshrac_edict_2")]
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end

function leshrac_diabolic_edict_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_leshrac_edict_7") then 
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end



function leshrac_diabolic_edict_custom:GetManaCost(iLevel)

if self:GetCaster():HasModifier("modifier_leshrac_nova_5") then 
  return self:GetCaster():FindAbilityByName("leshrac_pulse_nova_custom").spells_cost
end


return self.BaseClass.GetManaCost(self, iLevel)
end



function leshrac_diabolic_edict_custom:GetIntrinsicModifierName()
return "modifier_leshrac_diabolic_edict_custom_tracker"
end



function leshrac_diabolic_edict_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetDuration()


if self:GetCaster():HasModifier("modifier_leshrac_edict_6") and self:GetCaster():FindAbilityByName("leshrac_diabolic_edict_custom_surge"):IsHidden() then 
  self:GetCaster():SwapAbilities("leshrac_diabolic_edict_custom", "leshrac_diabolic_edict_custom_surge", false, true)
end


if self:GetCaster():HasModifier("modifier_leshrac_edict_7") then 
  local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetCaster():GetTalentValue("modifier_leshrac_edict_7", "radius") , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

  for _,enemy in pairs(enemies) do 
    enemy:AddNewModifier(self:GetCaster(), self, "modifier_leshrac_diabolic_edict_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_edict_7", "duration")})
  end

  if #enemies > 0 then 
    self:GetCaster():EmitSound("Leshrac.Edict_legendary_link")
  end
end


caster:AddNewModifier(caster, self, "modifier_leshrac_diabolic_edict_custom", { duration = duration })
end



function leshrac_diabolic_edict_custom:PlayEffects( unit )
local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf"
local sound_cast = "Hero_Leshrac.Diabolic_Edict"

local effect_cast 
local point

if unit then
  if unit:HasModifier("modifier_leshrac_diabolic_edict_custom_legendary_damage") then 
    particle_cast = "particles/leshrac_diabolic_legendary_damage.vpcf"

    EmitSoundOnLocationWithCaster(unit:GetAbsOrigin(), "Leshrac.Edict_legendary_break_active"..RandomInt(1, 4), self:GetCaster())

    local abs = unit:GetAbsOrigin()
    abs.z = abs.z + RandomInt(-20, 130)

    local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
    ParticleManager:SetParticleControl(hit_effect, 1, abs)
    ParticleManager:ReleaseParticleIndex(hit_effect)
  end



  effect_cast  = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, unit )
  ParticleManager:SetParticleControlEnt( effect_cast, 1, unit, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
else

  effect_cast  = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )

  point = self:GetCaster():GetOrigin() + RandomVector( RandomInt(0,self:GetSpecialValueFor( "radius" )) )
  ParticleManager:SetParticleControl( effect_cast, 1, point )
end

ParticleManager:ReleaseParticleIndex( effect_cast )

if unit then
  unit:EmitSound(sound_cast)
else
  EmitSoundOnLocationWithCaster(point, sound_cast, self:GetCaster())
end

end



function leshrac_diabolic_edict_custom:DealDamage(unit)
if not IsServer() then return end
local damage = self:GetAbilityDamage()

if self:GetCaster():HasModifier("modifier_leshrac_edict_3") then 
  --damage = damage + self.damage_inc[self:GetCaster():GetUpgradeStack("modifier_leshrac_edict_3")]
end

local mod = unit:FindModifierByName("modifier_leshrac_diabolic_edict_custom_legendary_damage")

if unit:HasModifier("modifier_leshrac_diabolic_edict_custom_legendary_damage") then 

  mod:IncrementStackCount()
  damage = damage + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_leshrac_edict_7", "damage")

end

 ApplyDamage( {attacker = self:GetCaster(), victim = unit, damage = damage, damage_type = self:GetAbilityDamageType(), ability = self,})
end





modifier_leshrac_diabolic_edict_custom = class({})


function modifier_leshrac_diabolic_edict_custom:IsHidden()
  return false
end

function modifier_leshrac_diabolic_edict_custom:IsDebuff()
  return false
end

function modifier_leshrac_diabolic_edict_custom:IsPurgable()
  return false
end

function modifier_leshrac_diabolic_edict_custom:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_leshrac_diabolic_edict_custom:RemoveOnDeath()
  return false
end


function modifier_leshrac_diabolic_edict_custom:OnCreated( kv )
if not IsServer() then return end
self.RemoveForDuel = true
local explosion = self:GetAbility():GetSpecialValueFor( "num_explosions" )
local duration = self:GetAbility():GetSpecialValueFor( "duration" )
self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

self.heal = self:GetCaster():GetTalentValue("modifier_leshrac_edict_5", "heal")/100
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_leshrac_edict_5", "heal_creeps")
self.health_heal = self:GetCaster():GetTalentValue("modifier_leshrac_edict_5", "health")

if self:GetParent():HasModifier("modifier_leshrac_edict_3") then 
  explosion = explosion + self:GetAbility().count_inc[self:GetCaster():GetUpgradeStack("modifier_leshrac_edict_3")]
end

local interval = duration/explosion --self:GetAbility():GetSpecialValueFor( "interval" )
self.parent = self:GetParent()
  


self.pos = self:GetParent():GetAbsOrigin()
self.distance = 0

if self:GetParent():HasModifier("modifier_leshrac_edict_4") then 

  self.particle_stack = ParticleManager:CreateParticle("particles/lesh_charges.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())

  for i = 1,self:GetAbility().distance_count do 
    if i <= self:GetStackCount() then 
      ParticleManager:SetParticleControl(self.particle_stack, i, Vector(1, 0, 0)) 
    else 
      ParticleManager:SetParticleControl(self.particle_stack, i, Vector(0, 0, 0)) 
    end
  end

  self:AddParticle(self.particle_stack, false, false, -1, false, false)
end

local sound_loop = "Hero_Leshrac.Diabolic_Edict_lp"
self.parent:EmitSound(sound_loop)


self:StartIntervalThink( interval )
end



function modifier_leshrac_diabolic_edict_custom:OnDestroy()
  if not IsServer() then return end
  local sound_loop = "Hero_Leshrac.Diabolic_Edict_lp"
  
  if not self:GetParent():HasModifier(self:GetName()) then 
    self.parent:StopSound(sound_loop)
  end

if not self:GetParent():HasModifier(self:GetName()) and self:GetCaster():HasModifier("modifier_leshrac_edict_6") and not self:GetCaster():FindAbilityByName("leshrac_diabolic_edict_custom_surge"):IsHidden()  then 
  self:GetCaster():SwapAbilities("leshrac_diabolic_edict_custom", "leshrac_diabolic_edict_custom_surge", true, false)
end

end




function modifier_leshrac_diabolic_edict_custom:OnIntervalThink()
if not IsServer() then return end


if self:GetParent():GetHealthPercent() <= self:GetAbility().heal_health and self:GetParent():HasModifier("modifier_leshrac_edict_5") 
  and self.particle == nil then 
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  self:AddParticle(self.particle, false, false, -1, false, false)
end


if self:GetParent():GetHealthPercent() > self:GetAbility().heal_health and self:GetParent():HasModifier("modifier_leshrac_edict_5") 
  and self.particle ~= nil then 

  ParticleManager:DestroyParticle(self.particle, false)
  ParticleManager:ReleaseParticleIndex(self.particle)

end



if self:GetParent():HasModifier("modifier_leshrac_edict_4") and self.particle_stack then 


  self.distance = self.distance + (self.pos - self:GetParent():GetAbsOrigin()):Length2D()
  self.pos = self:GetParent():GetAbsOrigin()


  if self.distance >= self:GetAbility().distance_max and self:GetStackCount() < self:GetAbility().distance_count then 
    self.distance = 0
    self:IncrementStackCount()

    if self:GetStackCount() >= self:GetAbility().distance_count then 

      self:GetCaster():EmitSound("Leshrac.Edict_damage")

      local effect_cast = ParticleManager:CreateParticle( "particles/ogre_dd.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
      self:AddParticle( effect_cast, false, false, -1, false, false )

      local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
      ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
      ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
      ParticleManager:ReleaseParticleIndex(particle_peffect)
    end

  end

  for i = 1,self:GetAbility().distance_count do 
    if i <= self:GetStackCount() then 
      ParticleManager:SetParticleControl(self.particle_stack, i, Vector(1, 0, 0)) 
    else 
      ParticleManager:SetParticleControl(self.particle_stack, i, Vector(0, 0, 0)) 
    end
  end

end





local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )

local enemy = nil
local max = 1

if self:GetCaster():HasShard() then 
  max = self:GetAbility():GetSpecialValueFor("shard_targets")
end

local count = 0


for _,enemy in pairs(enemies) do 

  if count < max then 

    self:GetAbility():DealDamage(enemy)
    self:GetAbility():PlayEffects( enemy )

  else 
    break
  end

  count = count + 1

end


if count == 0 then 
  self:GetAbility():PlayEffects( nil )
end

end

 




function modifier_leshrac_diabolic_edict_custom:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end


function modifier_leshrac_diabolic_edict_custom:GetModifierIncomingDamage_Percentage()
if not self:GetParent():HasModifier("modifier_leshrac_edict_4") then return end
return self:GetStackCount()*self:GetAbility().distance_incoming[self:GetCaster():GetUpgradeStack("modifier_leshrac_edict_4")]
end


function modifier_leshrac_diabolic_edict_custom:GetModifierSpellAmplify_Percentage()
if not self:GetParent():HasModifier("modifier_leshrac_edict_4") then return end
return self:GetStackCount()*self:GetAbility().distance_damage[self:GetCaster():GetUpgradeStack("modifier_leshrac_edict_4")]
end


function modifier_leshrac_diabolic_edict_custom:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_leshrac_edict_5") then return end
if params.attacker ~= self:GetParent() then return end
if not params.unit then return end
if self:GetParent():GetHealthPercent() > self.health_heal then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end

local heal = params.damage*self.heal

if params.unit:IsCreep() then 
  heal = heal/self.heal_creeps
end

self:GetCaster():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")



end



function modifier_leshrac_diabolic_edict_custom:CheckState()
if not self:GetParent():HasModifier("modifier_leshrac_edict_5") then return end
if self:GetParent():GetHealthPercent() > self.health_heal then return end
return
{
  [MODIFIER_STATE_UNSLOWABLE] = true
}
end




modifier_leshrac_diabolic_edict_custom_speed = class({})
function modifier_leshrac_diabolic_edict_custom_speed:IsHidden() return false end
function modifier_leshrac_diabolic_edict_custom_speed:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_speed:GetTexture() return "buffs/edict_speed" end
function modifier_leshrac_diabolic_edict_custom_speed:OnCreated(table)
self.speed = self:GetAbility():GetSpecialValueFor("speed")
self.resist = self:GetAbility():GetSpecialValueFor("resist")

if not IsServer() then return end
  local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  self:AddParticle( effect_cast, false, false, -1, false, false )
end

function modifier_leshrac_diabolic_edict_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_leshrac_diabolic_edict_custom_speed:GetModifierStatusResistanceStacking() 
  return self.resist
end

function modifier_leshrac_diabolic_edict_custom_speed:GetModifierMoveSpeedBonus_Percentage()
  return self.speed
end


function modifier_leshrac_diabolic_edict_custom_speed:GetEffectName() 
return "particles/leshrac_speed.vpcf"
end

function modifier_leshrac_diabolic_edict_custom_speed:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end




modifier_leshrac_diabolic_edict_custom_legendary = class({})
function modifier_leshrac_diabolic_edict_custom_legendary:IsHidden() return true end
function modifier_leshrac_diabolic_edict_custom_legendary:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetCaster():GetTalentValue("modifier_leshrac_edict_7", "radius")
self.stun = self:GetCaster():GetTalentValue("modifier_leshrac_edict_7", "stun")

local effect_cast = ParticleManager:CreateParticle( "particles/leshrac_edict_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt(effect_cast,0,self:GetCaster(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetCaster():GetOrigin(),true)
ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetOrigin(),true)
self:AddParticle(effect_cast,false,false,-1,false,false)

self:StartIntervalThink(FrameTime())
end


function modifier_leshrac_diabolic_edict_custom_legendary:CheckState()
return
{
  [MODIFIER_STATE_TETHERED] = true
}
end

function modifier_leshrac_diabolic_edict_custom_legendary:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime()*2, false)

if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.radius
  or not self:GetCaster():IsAlive() then
    self:Destroy()
end


end


function modifier_leshrac_diabolic_edict_custom_legendary:OnDestroy()
if not IsServer() then return end
if self:GetRemainingTime() > 0.1 then
  self:GetParent():EmitSound("Leshrac.Edict_legendary_break")
return
end


  self:GetParent():EmitSound("Leshrac.Edict_legendary_stun")

local particle_peffect = ParticleManager:CreateParticle("particles/lesh_edict_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

ParticleManager:ReleaseParticleIndex(particle_peffect)


self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_diabolic_edict_custom_legendary_damage", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_edict_7", "effect_duration")})
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun*(1 - self:GetParent():GetStatusResistance())})
end









modifier_leshrac_diabolic_edict_custom_legendary_damage = class({})
function modifier_leshrac_diabolic_edict_custom_legendary_damage:IsHidden() return false end
function modifier_leshrac_diabolic_edict_custom_legendary_damage:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_legendary_damage:GetEffectName() return "particles/leshrac_edict_mark.vpcf" end
function modifier_leshrac_diabolic_edict_custom_legendary_damage:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_leshrac_diabolic_edict_custom_legendary_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_leshrac_diabolic_edict_custom_legendary_damage:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_leshrac_edict_7", "damage")
end


function modifier_leshrac_diabolic_edict_custom_legendary_damage:OnTooltip()
return self.damage*self:GetStackCount()
end


leshrac_diabolic_edict_custom_surge = class({})


function leshrac_diabolic_edict_custom_surge:OnSpellStart()
if not IsServer() then return end
local caster = self:GetCaster()

local effect_cast = ParticleManager:CreateParticle( "particles/cleance_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl( effect_cast, 1, Vector(300,0,0) )
ParticleManager:ReleaseParticleIndex( effect_cast )

caster:EmitSound("Leshrac.Edict_purge")

caster:Purge(false, true, false, false, false)

caster:AddNewModifier(caster, self, "modifier_leshrac_diabolic_edict_custom_speed", {duration = self:GetSpecialValueFor("duration")})

self:GetCaster():SwapAbilities("leshrac_diabolic_edict_custom", "leshrac_diabolic_edict_custom_surge", true, false)
end



modifier_leshrac_diabolic_edict_custom_tracker = class({})
function modifier_leshrac_diabolic_edict_custom_tracker:IsHidden() return true end
function modifier_leshrac_diabolic_edict_custom_tracker:IsPurgable() return false end
function modifier_leshrac_diabolic_edict_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_leshrac_diabolic_edict_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_leshrac_edict_1") then return end
if self:GetParent() ~= params.attacker then return end
if not params.inflictor then return end
if params.inflictor ~= self:GetAbility() then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if params.unit:IsMagicImmune() then return end

local mana = self:GetAbility().mana_steal[self:GetCaster():GetUpgradeStack("modifier_leshrac_edict_1")]*params.damage

params.unit:Script_ReduceMana(mana, self:GetAbility())

self:GetParent():GiveMana(mana)

end