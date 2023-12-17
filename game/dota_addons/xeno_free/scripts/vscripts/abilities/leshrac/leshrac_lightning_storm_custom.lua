LinkLuaModifier( "modifier_leshrac_lightning_storm_custom", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_slow", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_legendary", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_tracker", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_passive", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_speed", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_knockback", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_leshrac_lightning_storm_custom_knockback_cd", "abilities/leshrac/leshrac_lightning_storm_custom", LUA_MODIFIER_MOTION_NONE )



leshrac_lightning_storm_custom = class({})

leshrac_lightning_storm_custom.damage_inc = {40, 60, 80}

leshrac_lightning_storm_custom.heal_damage = {0.3 , 0.45, 0.6}
leshrac_lightning_storm_custom.heal_creeps = 0.25




leshrac_lightning_storm_custom.speed_duration = 8
leshrac_lightning_storm_custom.speed_attack = {20, 30, 40}
leshrac_lightning_storm_custom.speed_move = {4, 6, 8}
leshrac_lightning_storm_custom.speed_max = 3 


leshrac_lightning_storm_custom.bkb_range = 250
leshrac_lightning_storm_custom.bkb_cd = -1





function leshrac_lightning_storm_custom:Precache(context)

PrecacheResource( "particle", "particles/leshrac_storm.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_leshrac/leshrac_lightning_slow.vpcf", context )

end


function leshrac_lightning_storm_custom:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_leshrac_storm_6") then 
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
  return DOTA_UNIT_TARGET_FLAG_NONE
end

end



function leshrac_lightning_storm_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_leshrac_storm_6") then  
  upgrade_cooldown = self.bkb_cd
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end

function leshrac_lightning_storm_custom:GetIntrinsicModifierName()
if not self:GetCaster():HasModifier("modifier_leshrac_lightning_storm_custom_passive") then 
  return "modifier_leshrac_lightning_storm_custom_passive"
end

end


function leshrac_lightning_storm_custom:GetManaCost(iLevel)

if self:GetCaster():HasModifier("modifier_leshrac_nova_5") then 
  return self:GetCaster():FindAbilityByName("leshrac_pulse_nova_custom").spells_cost
end


return self.BaseClass.GetManaCost(self, iLevel)
end


function leshrac_lightning_storm_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_leshrac_storm_7") then
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
  end
 return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end


function leshrac_lightning_storm_custom:CastFilterResultTarget(target)



if self:GetCaster():HasModifier("modifier_leshrac_storm_6") then 
  return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
else 
  return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
end

end

function leshrac_lightning_storm_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_leshrac_storm_6") then 
  upgrade = self.bkb_range
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function leshrac_lightning_storm_custom:GetAOERadius()
if not self:GetCaster():HasModifier("modifier_leshrac_storm_7") then return end

return self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "radius")
end


function leshrac_lightning_storm_custom:OnSpellStart(new_target)
if not IsServer() then return end

local target = self:GetCursorTarget()
if new_target then 
  target = new_target
end

if target:TriggerSpellAbsorb(self) then return end


if self:GetCaster():HasModifier("modifier_leshrac_storm_3") then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_leshrac_lightning_storm_custom_speed", {duration = self.speed_duration})
end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_leshrac_lightning_storm_custom", {starting_unit_entindex = target:entindex()})

local legen_mod = self:GetCaster():FindModifierByName("modifier_leshrac_lightning_storm_custom_tracker")

if self:GetCaster():HasModifier("modifier_leshrac_storm_7") and legen_mod and legen_mod:GetStackCount() > 0 then  
  CreateModifierThinker(self:GetCaster(), self, "modifier_leshrac_lightning_storm_custom_legendary", {count = legen_mod:GetStackCount()}, target:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
    
  if legen_mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "max") then 
    target:AddNewModifier(self:GetCaster(), self, "modifier_generic_silence", {sound = "Sf.Raze_Silence", duration = (1 - target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "silence")})
  end

  legen_mod:SetStackCount(0)

end
    
end






function leshrac_lightning_storm_custom:DealDamage(target, damage_k, slow)
if not IsServer() then return end
local duration = self:GetSpecialValueFor( "slow_duration" )
local damage = self:GetSpecialValueFor("damage")


if slow ~= 1 then 
  duration = slow
end

if self:GetCaster():HasModifier("modifier_leshrac_storm_1") then  
  damage = damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self.damage_inc[self:GetCaster():GetUpgradeStack("modifier_leshrac_storm_1")]/100
end 

target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_leshrac_storm_6")), "modifier_leshrac_lightning_storm_custom_slow", {duration = duration*(1 - target:GetStatusResistance())})


ApplyDamage({ victim = target, damage = damage*damage_k, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self })

end







modifier_leshrac_lightning_storm_custom_legendary = class({})
function modifier_leshrac_lightning_storm_custom_legendary:IsHidden()    return true end
function modifier_leshrac_lightning_storm_custom_legendary:IsPurgable()    return false end
function modifier_leshrac_lightning_storm_custom_legendary:RemoveOnDeath() return false end
function modifier_leshrac_lightning_storm_custom_legendary:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_leshrac_lightning_storm_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "radius")

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

local flag = 0
if self:GetCaster():HasModifier("modifier_leshrac_storm_6") then 
  flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, flag, 0, false )

for _,target in pairs(enemies) do 
  self:GetAbility():DealDamage(target, self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "damage")/100, 0)
end

end



modifier_leshrac_lightning_storm_custom = class({})

function modifier_leshrac_lightning_storm_custom:IsHidden()    return true end
function modifier_leshrac_lightning_storm_custom:IsPurgable()    return false end
function modifier_leshrac_lightning_storm_custom:RemoveOnDeath() return false end
function modifier_leshrac_lightning_storm_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_leshrac_lightning_storm_custom:OnCreated(keys)
if not IsServer() or not self:GetAbility() then return end

self.jump_delay = self:GetAbility():GetSpecialValueFor( "jump_delay" )
self.jump_count = self:GetAbility():GetSpecialValueFor( "jump_count" )
self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

if keys.bounces then 
  self.jump_count = keys.bounces
end

self.damage = 1
if keys.damage then 
  self.damage = keys.damage
end

self.slow = 1
if keys.slow then 
  self.slow = keys.slow
end


self.starting_unit_entindex = keys.starting_unit_entindex
self.units_affected     = {}
self.max_per_target = 1
self.current_unit = nil


if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
    self.current_unit           = EntIndexToHScript(self.starting_unit_entindex)
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


self:GetAbility():DealDamage(target, self.damage, self.slow)

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
self.zapped = false
local team = DOTA_UNIT_TARGET_TEAM_ENEMY

local flag = 0
if self:GetCaster():HasModifier("modifier_leshrac_storm_6") then 
  flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end


for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.radius, team, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + flag, FIND_CLOSEST, false)) do
    
  if (not self.units_affected[enemy] or self.units_affected[enemy] < self.max_per_target) 
      and enemy ~= self.current_unit 
      and enemy:GetUnitName() ~= "npc_teleport" then
      

    
    self.unit_counter           = self.unit_counter + 1
    self.previous_unit            = self.current_unit
    self.current_unit           = enemy
      
    if self.units_affected[self.current_unit] then
      self.units_affected[self.current_unit]  = self.units_affected[self.current_unit] + 1
    else
      self.units_affected[self.current_unit]  = 1
    end
      
    self.zapped               = true
      
    if enemy:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
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
function modifier_leshrac_lightning_storm_custom_slow:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_slow:OnCreated(table)
self.ability = self:GetCaster():FindAbilityByName("leshrac_lightning_storm_custom")

if not self.ability then 
  self:Destroy()
  return
end

self.attack = self.ability:GetSpecialValueFor("slow_attack")
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
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_leshrac_lightning_storm_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end



function modifier_leshrac_lightning_storm_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack
end






modifier_leshrac_lightning_storm_custom_tracker = class({})
function modifier_leshrac_lightning_storm_custom_tracker:IsHidden() return true end
function modifier_leshrac_lightning_storm_custom_tracker:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_tracker:RemoveOnDeath() return false end
function modifier_leshrac_lightning_storm_custom_tracker:OnCreated(table)
if not IsServer() then return end

self.max = self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "max")
self.interval = self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "interval")
self.waste = self:GetCaster():GetTalentValue("modifier_leshrac_storm_7", "waste")

self:SetStackCount(0)
end

function modifier_leshrac_lightning_storm_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_leshrac_lightning_storm_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:StartIntervalThink(self.waste)

if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

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

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'leshrac_storm_change',  {max = self.max, damage = self:GetStackCount()})
end






modifier_leshrac_lightning_storm_custom_passive = class({})
function modifier_leshrac_lightning_storm_custom_passive:IsHidden() return true end
function modifier_leshrac_lightning_storm_custom_passive:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_passive:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end


function modifier_leshrac_lightning_storm_custom_passive:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_leshrac_storm_4") then return end

return self:GetCaster():GetTalentValue("modifier_leshrac_storm_4", "range")
end

function modifier_leshrac_lightning_storm_custom_passive:OnTakeDamage(params)
if not IsServer() then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if not params.attacker then return end
if params.unit:IsInvulnerable() then return end

if self:GetParent() == params.unit and not params.attacker:IsBuilding() and (not params.attacker:IsMagicImmune())
 and self:GetParent():HasModifier("modifier_leshrac_storm_5") and params.inflictor == nil
 and (self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() <= self:GetCaster():GetTalentValue("modifier_leshrac_storm_5", "distance")
 and not params.attacker:HasModifier("modifier_leshrac_lightning_storm_custom_knockback_cd") then 


  params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_lightning_storm_custom_knockback_cd", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_storm_5", "cd")})


  local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf"
  local sound_cast = "Hero_Leshrac.Lightning_Storm"
  local location = params.attacker:GetAbsOrigin()


  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, params.attacker )
  ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc",self:GetParent():GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt(effect_cast, 1, params.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc",params.attacker:GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex( effect_cast )

  EmitSoundOnLocationWithCaster(location, sound_cast, self:GetCaster())

  params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_lightning_storm_custom_knockback", {duration = self:GetCaster():GetTalentValue("modifier_leshrac_storm_5", "duration")})
  
  self:GetAbility():DealDamage(params.attacker, 1, 1)
end


if self:GetParent() ~= params.attacker then return end

if self:GetParent():HasModifier("modifier_leshrac_storm_4") and params.inflictor == nil and (not params.unit:IsMagicImmune() or self:GetCaster():HasModifier("modifier_leshrac_storm_6"))
  and RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_leshrac_storm_4", "chance"),247,self:GetParent()) then 

  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_lightning_storm_custom", 
  {
    damage = self:GetCaster():GetTalentValue("modifier_leshrac_storm_4", "damage")/100, 
    slow = self:GetCaster():GetTalentValue("modifier_leshrac_storm_4", "slow"),
    starting_unit_entindex = params.unit:entindex(),
    bounces = self:GetCaster():GetTalentValue("modifier_leshrac_storm_4", "count")
  })
end
 


if not self:GetParent():HasModifier("modifier_leshrac_storm_2") then return end
if not self:GetParent():IsAlive() then return end
if not params.inflictor then return end
if params.inflictor ~= self:GetAbility() then return end
if params.unit and params.unit:IsIllusion() then return end

local heal = self:GetAbility().heal_damage[self:GetCaster():GetUpgradeStack("modifier_leshrac_storm_2")]*params.damage

if params.unit:IsCreep() then 
  heal = heal*self:GetAbility().heal_creeps
end

my_game:GenericHeal(self:GetCaster(), heal, self:GetAbility())

end

modifier_leshrac_lightning_storm_custom_speed = class({})
function modifier_leshrac_lightning_storm_custom_speed:IsHidden() return false end
function modifier_leshrac_lightning_storm_custom_speed:IsPurgable() return false end
function modifier_leshrac_lightning_storm_custom_speed:GetTexture() return "buffs/storm_speed" end

function modifier_leshrac_lightning_storm_custom_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_leshrac_lightning_storm_custom_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().speed_max then return end
self:IncrementStackCount()

end


function modifier_leshrac_lightning_storm_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_leshrac_lightning_storm_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().speed_attack[self:GetCaster():GetUpgradeStack("modifier_leshrac_storm_3")]*self:GetStackCount()
end

function modifier_leshrac_lightning_storm_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().speed_move[self:GetCaster():GetUpgradeStack("modifier_leshrac_storm_3")]*self:GetStackCount()
end





modifier_leshrac_lightning_storm_custom_knockback = class({})

function modifier_leshrac_lightning_storm_custom_knockback:IsHidden() return true end

function modifier_leshrac_lightning_storm_custom_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self:GetCaster():GetTalentValue("modifier_leshrac_storm_5", "duration")


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
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_leshrac_lightning_storm_custom_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_leshrac_lightning_storm_custom_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
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