LinkLuaModifier( "modifier_leshrac_lightning_storm_custom", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_slow", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_legendary", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_tracker", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_passive", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_stack", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_knockback", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_knockback_cd", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_silence_stack", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_silence_cd", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_reduce", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_auto_cd", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_stack_max", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )



leshrac_lightning_storm_custom = class({})

function leshrac_lightning_storm_custom:CreateTalent()

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_leshrac_lightning_storm_custom_tracker", {})
end


function leshrac_lightning_storm_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/leshrac/storm_refresh.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_storm.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf", context )
PrecacheResource( "particle", "particles/lesh_charges.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", context )
PrecacheResource( "particle", "particles/leshrac/storm_max.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/octarine_core_lifesteal.vpcf", context )
PrecacheResource( "particle", "particles/leshrac_stack.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_mjollnir_shield.vpcf", context )


end




function leshrac_lightning_storm_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_leshrac_lightning_storm_custom_passive"
end


function leshrac_lightning_storm_custom:GetCooldown(iLevel)
local k = 1
if self:GetCaster():HasModifier("modifier_leshrac_lightning_storm_custom_tracker") then 
  k = k + self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "cd")*self:GetCaster():GetUpgradeStack("modifier_leshrac_lightning_storm_custom_tracker")/100
end 
return math.max(0.2, self.BaseClass.GetCooldown(self, iLevel) * k)
end



function leshrac_lightning_storm_custom:GetManaCost(iLevel)

local k = 1
local mana = self.BaseClass.GetManaCost(self, iLevel)
if self:GetCaster():HasModifier("modifier_leshrac_lightning_storm_custom_tracker")then 
  k = k + self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "cd")*self:GetCaster():GetUpgradeStack("modifier_leshrac_lightning_storm_custom_tracker")/100
end 

if self:GetCaster():HasModifier("modifier_leshrac_pulse_nova_custom_low_mana") then
  mana = self:GetCaster():GetUpgradeStack("modifier_leshrac_pulse_nova_custom_low_mana")
end
return mana * k
end


function leshrac_lightning_storm_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_leshrac_storm_7") then
  return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end



function leshrac_lightning_storm_custom:GetCastPoint()

local upgrade = 0
if self:GetCaster():HasTalent("modifier_leshrac_storm_6") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_leshrac_storm_6", "cast")
end

return self.BaseClass.GetCastPoint(self) + upgrade
end



function leshrac_lightning_storm_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasTalent("modifier_leshrac_storm_6") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_leshrac_storm_6", "range")
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function leshrac_lightning_storm_custom:GetAOERadius()
if not self:GetCaster():HasTalent("modifier_leshrac_storm_7") then return end
return self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "radius") + self:GetCaster():GetLeshracRadius()
end


function leshrac_lightning_storm_custom:OnSpellStart(new_target)
if not IsServer() then return end

local target = self:GetCursorTarget()
if new_target then 
  target = new_target
end

if target:TriggerSpellAbsorb(self) then return end

local caster = self:GetCaster()


if caster:HasTalent("modifier_leshrac_storm_4") then 
  caster:AddNewModifier(caster, self, "modifier_leshrac_lightning_storm_custom_stack", {duration = caster:GetTalentValue("modifier_leshrac_storm_4", "duration", true)})
end 

if caster:HasTalent("modifier_leshrac_storm_2") then 
  target:AddNewModifier(caster, self, "modifier_leshrac_lightning_storm_custom_reduce", {duration = caster:GetTalentValue("modifier_leshrac_storm_2", "duration")})
end 


caster:AddNewModifier(caster, self, "modifier_leshrac_lightning_storm_custom", {starting_unit_entindex = target:entindex()})

local legen_mod = caster:FindModifierByName("modifier_leshrac_lightning_storm_custom_tracker")

if caster:HasTalent("modifier_leshrac_storm_7") and legen_mod and legen_mod:GetStackCount() > 0 then  
  CreateModifierThinker(caster, self, "modifier_leshrac_lightning_storm_custom_legendary", {count = legen_mod:GetStackCount()}, target:GetAbsOrigin(), caster:GetTeamNumber(), false)
    
  if legen_mod:GetStackCount() >= caster:GetTalentValue("modifier_leshrac_storm_7", "max") then 
   -- self:EndCooldown()
    caster:EmitSound("Leshrac.Storm_refresh")

    local particle = ParticleManager:CreateParticle("particles/leshrac/storm_refresh.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particle)
 end

  legen_mod:SetStackCount(0)

end
    
end






function leshrac_lightning_storm_custom:DealDamage(target, damage_k, slow, ability)
if not IsServer() then return end
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor( "slow_duration" ) + caster:GetTalentValue("modifier_leshrac_storm_5", "slow")
local damage = self:GetSpecialValueFor("damage") + caster:GetTalentValue("modifier_leshrac_storm_1", "damage")*caster:GetAverageTrueAttackDamage(nil)/100
local mod = caster:FindModifierByName("modifier_leshrac_lightning_storm_custom_stack") 


local damage_ability = nil
if ability then 
  damage_ability = ability
end 

if slow ~= 1 then 
  duration = slow
end



target:AddNewModifier(caster, self, "modifier_leshrac_lightning_storm_custom_slow", {duration = duration*(1 - target:GetStatusResistance())})
DoDamage({ victim = target, damage = damage*damage_k, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = caster, ability = self }, damage_ability)
end








modifier_leshrac_lightning_storm_custom_legendary = class({})
function modifier_leshrac_lightning_storm_custom_legendary:IsHidden()    return true end
function modifier_leshrac_lightning_storm_custom_legendary:IsPurgable()    return false end
function modifier_leshrac_lightning_storm_custom_legendary:RemoveOnDeath() return false end
function modifier_leshrac_lightning_storm_custom_legendary:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_leshrac_lightning_storm_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "radius") + self:GetCaster():GetLeshracRadius()

self.count = table.count

local target_point = self:GetParent():GetAbsOrigin()
self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/leshrac_storm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

self:StartIntervalThink(self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "interval"))
end


function modifier_leshrac_lightning_storm_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self:DoDamage(self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(1, self.radius)))
self:IncrementStackCount()

if self:GetStackCount() >= self.count then 
  self:Destroy()
end

end


function modifier_leshrac_lightning_storm_custom_legendary:DoDamage(location)
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), location, 50, 1, false)
local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf"
local sound_cast = "Hero_Leshrac.Lightning_Storm"


local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, location + Vector( 0, 0, 1500 ) )
ParticleManager:SetParticleControl(effect_cast, 1, location)
ParticleManager:ReleaseParticleIndex( effect_cast )

EmitSoundOnLocationWithCaster(location, sound_cast, self:GetCaster())

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

for _,target in pairs(enemies) do 
  self:GetAbility():DealDamage(target, self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "damage")/100, 0, "modifier_leshrac_storm_7")
end

end



modifier_leshrac_lightning_storm_custom = class({})

function modifier_leshrac_lightning_storm_custom:IsHidden()    return true end
function modifier_leshrac_lightning_storm_custom:IsPurgable()    return false end
function modifier_leshrac_lightning_storm_custom:RemoveOnDeath() return false end
function modifier_leshrac_lightning_storm_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_leshrac_lightning_storm_custom:OnCreated(params)
if not IsServer() then return end

self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.jump_delay = self:GetAbility():GetSpecialValueFor( "jump_delay" )
self.jump_count = self:GetAbility():GetSpecialValueFor( "jump_count" )
self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) + self.caster:GetLeshracRadius()

self.silence_cd = self.caster:GetTalentValue("modifier_leshrac_storm_6", "cd", true)
self.silence = self.caster:GetTalentValue("modifier_leshrac_storm_6", "silence", true)

if params.bounces then 
  self.jump_count = params.bounces
end

self.damage_ability = nil
if params.damage_ability then 
  self.damage_ability = params.damage_ability
end 

self.damage = 1
if params.damage then 
  self.damage = params.damage
end

self.slow = 1
if params.slow then 
  self.slow = params.slow
end

self.starting_unit_entindex = params.starting_unit_entindex
self.units_affected     = {}
self.max_per_target = 1
self.current_unit = nil

if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
    self.current_unit = EntIndexToHScript(self.starting_unit_entindex)

    self.units_affected[self.current_unit]  = 1

    self:DoDamage(self.current_unit)
else
  self:Destroy()
  return
end

self.unit_counter     = 0
self:StartIntervalThink(self.jump_delay)
end


function modifier_leshrac_lightning_storm_custom:DoDamage(target)
if not IsServer() then return end

if self.caster:HasTalent("modifier_leshrac_storm_6") and not target:HasModifier("modifier_leshrac_lightning_storm_custom_silence_cd") and self.damage_ability == nil then 
  target:AddNewModifier(self.caster, self.ability, "modifier_leshrac_lightning_storm_custom_silence_cd", {duration = self.silence_cd})  
  target:AddNewModifier(self.caster, self.ability, "modifier_generic_silence", {sound = "Sf.Raze_Silence", duration = (1 - target:GetStatusResistance())*self.silence})
end 

self.ability:DealDamage(target, self.damage, self.slow, self.damage_ability)

local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf"
local sound_cast = "Hero_Leshrac.Lightning_Storm"

local location = target:GetOrigin()

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, target )
ParticleManager:SetParticleControl( effect_cast, 0, location + Vector( 0, 0, 1500 ) )
ParticleManager:SetParticleControlEnt(effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc",Vector(0,0,0), true )
ParticleManager:ReleaseParticleIndex( effect_cast )

target:EmitSound(sound_cast)
end




function modifier_leshrac_lightning_storm_custom:OnIntervalThink()
if not IsServer() then return end
self.zapped = false
local team = DOTA_UNIT_TARGET_TEAM_ENEMY

for _, enemy in pairs(FindUnitsInRadius(self.caster:GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.radius, team, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
    
  if (not self.units_affected[enemy] or self.units_affected[enemy] < self.max_per_target) and enemy ~= self.current_unit and enemy:GetUnitName() ~= "npc_teleport" then
      
    self.unit_counter           = self.unit_counter + 1
    self.previous_unit            = self.current_unit
    self.current_unit           = enemy
      
    if self.units_affected[self.current_unit] then
      self.units_affected[self.current_unit]  = self.units_affected[self.current_unit] + 1
    else
      self.units_affected[self.current_unit]  = 1
    end
      
    self.zapped               = true
      
    if enemy:GetTeamNumber() ~= self.caster:GetTeamNumber() then 
        self:DoDamage(enemy)
    end

    break
  end
end
  
if (self.unit_counter >= self.jump_count and self.jump_count > 0) or not self.zapped then
  self:StartIntervalThink(-1)
  self:Destroy()
end

end




modifier_leshrac_lightning_storm_custom_slow = class({})
function modifier_leshrac_lightning_storm_custom_slow:IsHidden() return false end
function modifier_leshrac_lightning_storm_custom_slow:IsPurgable() return true end
function modifier_leshrac_lightning_storm_custom_slow:OnCreated(table)

self.ability = self:GetAbility()
self.slow = self.ability:GetSpecialValueFor("slow_movement_speed")

if not IsServer() then return end

self.particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle_index, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle_index, 1, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_index, false, false, -1, false, false ) 
end

function modifier_leshrac_lightning_storm_custom_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end


function modifier_leshrac_lightning_storm_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end






modifier_leshrac_lightning_storm_custom_tracker = class({})
function modifier_leshrac_lightning_storm_custom_tracker:IsHidden() return true end
function modifier_leshrac_lightning_storm_custom_tracker:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_tracker:RemoveOnDeath() return false end
function modifier_leshrac_lightning_storm_custom_tracker:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_leshrac_storm_7", "max")
self.interval = self.parent:GetTalentValue("modifier_leshrac_storm_7", "interval")
self.waste = self.parent:GetTalentValue("modifier_leshrac_storm_7", "waste")

self.particle = self.parent:GenericParticle("particles/lesh_charges.vpcf", self, true)

self:SetStackCount(0)
end


function modifier_leshrac_lightning_storm_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if self:GetStackCount() > 0 then 
  self:DecrementStackCount()
end

self:StartIntervalThink(self.interval)
end


function modifier_leshrac_lightning_storm_custom_tracker:OnStackCountChanged(iStackCount)
if not IsServer() then return end

self.parent:UpdateUIlong({max = self.max, stack = self:GetStackCount(), style = "LeshracStorm"})

if not self.particle then return end

for i = 0,self.max do 
  if i <= self:GetStackCount() then 
    ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
  else 
    ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
  end
end

end











modifier_leshrac_lightning_storm_custom_passive = class(mod_hidden)
function modifier_leshrac_lightning_storm_custom_passive:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_leshrac_lightning_storm_custom_passive:GetModifierBaseAttackTimeConstant()
if not self.parent:HasTalent("modifier_leshrac_storm_7") then return end
return self.bva
end


function modifier_leshrac_lightning_storm_custom_passive:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_leshrac_storm_3") then return end
return self.parent:GetTalentValue("modifier_leshrac_storm_3", "range")
end

function modifier_leshrac_lightning_storm_custom_passive:GetModifierAttackSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_leshrac_storm_1") then return end
return self.parent:GetTalentValue("modifier_leshrac_storm_1", "speed")
end

function modifier_leshrac_lightning_storm_custom_passive:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:AddAttackEvent_out(self)

if self.parent:IsRealHero() then
  self.parent:AddAttackEvent_inc(self)
end

self.bva = self.parent:GetTalentValue("modifier_leshrac_storm_7", "bva", true)

self.knock_range = self.parent:GetTalentValue("modifier_leshrac_storm_5", "distance", true)
self.knock_cd = self.parent:GetTalentValue("modifier_leshrac_storm_5", "cd", true)
self.knock_duration = self.parent:GetTalentValue("modifier_leshrac_storm_5", "duration", true)
end 

function modifier_leshrac_lightning_storm_custom_passive:CheckState()
if not self.parent:HasTalent("modifier_leshrac_storm_3") then return end 
if self.parent:HasModifier("modifier_leshrac_lightning_storm_custom_auto_cd") then return end 
return
{
  [MODIFIER_STATE_CANNOT_MISS] = true
}

end



function modifier_leshrac_lightning_storm_custom_passive:AttackEvent_inc(params)
if not IsServer() then return end
if not params.attacker then return end 

local attacker = params.attacker
local target = params.target

if not attacker:IsUnit() then return end

if self.parent:HasTalent("modifier_leshrac_storm_5") and target == self.parent and not attacker:IsInvulnerable()
  and not attacker:HasModifier("modifier_leshrac_lightning_storm_custom_knockback_cd") and (self.parent:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D() <= self.knock_range then 

  attacker:AddNewModifier(self.parent, self.ability, "modifier_leshrac_lightning_storm_custom_knockback_cd", {duration = self.knock_cd})

  local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker )
  ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt(effect_cast, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex( effect_cast )

  EmitSoundOnLocationWithCaster(attacker:GetAbsOrigin(), "Hero_Leshrac.Lightning_Storm", self.parent)

  attacker:AddNewModifier(self.parent, self.ability, "modifier_leshrac_lightning_storm_custom_knockback", {duration = self.knock_duration})
  self.ability:DealDamage(attacker, 1, 1, "modifier_leshrac_storm_5")
end


end

function modifier_leshrac_lightning_storm_custom_passive:AttackEvent_out(params)
if not IsServer() then return end
if not params.attacker then return end 

local attacker = params.attacker
local target = params.target

if not target:IsUnit() then return end
if self.parent ~= attacker then return end 

local mod = self.parent:FindModifierByName("modifier_leshrac_lightning_storm_custom_tracker")

if mod then 

  mod:StartIntervalThink(mod.waste)

  if mod:GetStackCount() < mod.max then 
    mod:IncrementStackCount()
  end 
end

if self.parent:HasTalent("modifier_leshrac_storm_3") and not self.parent:HasModifier("modifier_leshrac_lightning_storm_custom_auto_cd") then 

  self.parent:AddNewModifier(self.parent, self.ability, "modifier_leshrac_lightning_storm_custom_auto_cd", {duration = self.parent:GetTalentValue("modifier_leshrac_storm_3", "cd")})

  self.parent:AddNewModifier(self.parent, self.ability, "modifier_leshrac_lightning_storm_custom", 
  {
    starting_unit_entindex = target:entindex(),
    damage_ability = "modifier_leshrac_storm_3"
  })
end

end











modifier_leshrac_lightning_storm_custom_stack = class({})
function modifier_leshrac_lightning_storm_custom_stack:IsHidden() return false end
function modifier_leshrac_lightning_storm_custom_stack:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_stack:GetTexture() return "buffs/storm_damage" end

function modifier_leshrac_lightning_storm_custom_stack:OnCreated(table)
self.caster = self:GetCaster()

self.spell = self.caster:GetTalentValue("modifier_leshrac_storm_4", "damage")
self.heal = self.caster:GetTalentValue("modifier_leshrac_storm_4", "heal")/100
self.creeps = self.caster:GetTalentValue("modifier_leshrac_storm_4", "creeps", true)
self.max = self.caster:GetTalentValue("modifier_leshrac_storm_4", "max", true)

if not IsServer() then return end

self:SetStackCount(1)
self.caster:AddDamageEvent_out(self)
end

function modifier_leshrac_lightning_storm_custom_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
  self.caster:EmitSound("Leshrac.Edict_damage")
  self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_leshrac_lightning_storm_custom_stack_max", {})

  self.max_particle = ParticleManager:CreateParticle( "particles/leshrac/storm_max.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
  ParticleManager:SetParticleControl( self.max_particle, 0, self.caster:GetAbsOrigin() )
  ParticleManager:SetParticleControl( self.max_particle, 1, self.caster:GetAbsOrigin() )
  ParticleManager:SetParticleControl( self.max_particle, 2, self.caster:GetAbsOrigin() )
  self:AddParticle(self.max_particle, false, false, 0, true, false)
end 

end



function modifier_leshrac_lightning_storm_custom_stack:OnDestroy()
if not IsServer() then return end 
self.caster:RemoveModifierByName("modifier_leshrac_lightning_storm_custom_stack_max")
end 


function modifier_leshrac_lightning_storm_custom_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP,
}
end


function modifier_leshrac_lightning_storm_custom_stack:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*self.spell
end

function modifier_leshrac_lightning_storm_custom_stack:OnTooltip()
return self:GetStackCount()*self.heal*100
end


function modifier_leshrac_lightning_storm_custom_stack:DamageEvent_out(params)
if not IsServer() then return end
--if not params.inflictor then return end
if not params.attacker then return end
if params.attacker ~= self.caster then return end
if not params.unit then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end

local heal = params.damage*self.heal*self:GetStackCount()

if params.unit:IsCreep() then 
  heal = heal/self.creeps
end

self.caster:GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf", "modifier_leshrac_storm_4")
end







modifier_leshrac_lightning_storm_custom_knockback = class({})

function modifier_leshrac_lightning_storm_custom_knockback:IsHidden() return true end

function modifier_leshrac_lightning_storm_custom_knockback:OnCreated(params)
if not IsServer() then return end

self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self:GetParent():StartGesture(ACT_DOTA_FLAIL)

self.knockback_duration  = self:GetCaster():GetTalentValue("modifier_leshrac_storm_5", "duration")

local dir = (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin())
dir.z = 0
dir = dir:Normalized()

local point = self:GetCaster():GetAbsOrigin() + dir*self:GetCaster():GetTalentValue("modifier_leshrac_storm_5", "distance_max")

self.knockback_distance = math.max(self:GetCaster():GetTalentValue("modifier_leshrac_storm_5", "distance_min"), (point - self:GetParent():GetAbsOrigin()):Length2D())
self.knockback_speed    = self.knockback_distance / self.knockback_duration
self.position = GetGroundPosition(Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, 0), nil)

if self:ApplyHorizontalMotionController() == false then 
  self:Destroy()
  return
end

end

function modifier_leshrac_lightning_storm_custom_knockback:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

local distance = (me:GetOrigin() - self.position):Normalized()
me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_leshrac_lightning_storm_custom_knockback:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_leshrac_lightning_storm_custom_knockback:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end


function modifier_leshrac_lightning_storm_custom_knockback:OnDestroy()
if not IsServer() then return end
self.parent:RemoveHorizontalMotionController( self )
FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end






modifier_leshrac_lightning_storm_custom_knockback_cd = class({})
function modifier_leshrac_lightning_storm_custom_knockback_cd:IsHidden() return true end
function modifier_leshrac_lightning_storm_custom_knockback_cd:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_knockback_cd:RemoveOnDeath() return false end
function modifier_leshrac_lightning_storm_custom_knockback_cd:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end







modifier_leshrac_lightning_storm_custom_silence_stack = class({})
function modifier_leshrac_lightning_storm_custom_silence_stack:IsHidden() return true end
function modifier_leshrac_lightning_storm_custom_silence_stack:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_silence_stack:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_leshrac_storm_6", "stack")
self.silence = self:GetCaster():GetTalentValue("modifier_leshrac_storm_6", "silence")

if not IsServer() then return end

self.effect_cast = ParticleManager:CreateParticle( "particles/leshrac_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end

function modifier_leshrac_lightning_storm_custom_silence_stack:OnRefresh()
if not IsServer() then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_silence", {sound = "Sf.Raze_Silence", duration = (1 - self:GetParent():GetStatusResistance())*self.silence})
  self:Destroy()
end 

end 


function modifier_leshrac_lightning_storm_custom_silence_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end

if self.effect_cast then 
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end

end






modifier_leshrac_lightning_storm_custom_reduce = class({})
function modifier_leshrac_lightning_storm_custom_reduce:IsHidden() return true end
function modifier_leshrac_lightning_storm_custom_reduce:IsPurgable() return true end
function modifier_leshrac_lightning_storm_custom_reduce:GetTexture() return "buffs/arc_speed" end
function modifier_leshrac_lightning_storm_custom_reduce:OnCreated()

self.attack = self:GetCaster():GetTalentValue("modifier_leshrac_storm_2", "speed")
self.damage = self:GetCaster():GetTalentValue("modifier_leshrac_storm_2", "damage")
end 


function modifier_leshrac_lightning_storm_custom_reduce:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_leshrac_lightning_storm_custom_reduce:GetModifierDamageOutgoing_Percentage()
return self.damage
end

function modifier_leshrac_lightning_storm_custom_reduce:GetModifierSpellAmplify_Percentage() 
return self.damage
end

function modifier_leshrac_lightning_storm_custom_reduce:GetModifierAttackSpeedBonus_Constant()
return self.attack
end



modifier_leshrac_lightning_storm_custom_auto_cd = class({})
function modifier_leshrac_lightning_storm_custom_auto_cd:IsHidden() return false end
function modifier_leshrac_lightning_storm_custom_auto_cd:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_auto_cd:IsDebuff() return true end
function modifier_leshrac_lightning_storm_custom_auto_cd:GetTexture() return "buffs/storm_speed" end
function modifier_leshrac_lightning_storm_custom_auto_cd:RemoveOnDeath() return false end
function modifier_leshrac_lightning_storm_custom_auto_cd:OnCreated()

self.RemoveForDuel = true
end



modifier_leshrac_lightning_storm_custom_stack_max = class({})
function modifier_leshrac_lightning_storm_custom_stack_max:IsHidden() return true end
function modifier_leshrac_lightning_storm_custom_stack_max:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_stack_max:GetStatusEffectName()
return "particles/status_fx/status_effect_mjollnir_shield.vpcf"
end

function modifier_leshrac_lightning_storm_custom_stack_max:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end


modifier_leshrac_lightning_storm_custom_silence_cd = class({})
function modifier_leshrac_lightning_storm_custom_silence_cd:IsHidden() return true end
function modifier_leshrac_lightning_storm_custom_silence_cd:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_silence_cd:RemoveOnDeath() return false end