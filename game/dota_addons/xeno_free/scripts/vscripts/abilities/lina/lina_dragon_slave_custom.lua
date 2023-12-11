LinkLuaModifier( "modifier_lina_dragon_slave_custom_stack", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_legendary", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_tracker", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_burn", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_legendary_tracker", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_burn", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_burn_count", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_damage", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_dragon_slave_custom_magic", "abilities/lina/lina_dragon_slave_custom", LUA_MODIFIER_MOTION_NONE )

lina_dragon_slave_custom = class({})

lina_dragon_slave_custom.shard_damage = 20





lina_dragon_slave_custom.legendary_cd = 1
lina_dragon_slave_custom.legendary_max = 16
lina_dragon_slave_custom.legendary_attack = 1
lina_dragon_slave_custom.legendary_spells = 4
lina_dragon_slave_custom.legendary_duration = 6
lina_dragon_slave_custom.legendary_delay = 5
lina_dragon_slave_custom.legendary_range = 1000

lina_dragon_slave_custom.time_cast = 0.15
lina_dragon_slave_custom.time_cd = 0.8

lina_dragon_slave_custom.cd_init = 0.05
lina_dragon_slave_custom.cd_inc = 0.05







function lina_dragon_slave_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context )
PrecacheResource( "particle", "particles/huskar_spears_legen.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_omnislash.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", context )
PrecacheResource( "particle", "particles/roshan_meteor_burn_.vpcf", context )
PrecacheResource( "particle", "particles/lina_stack_stun.vpcf", context )

end




function lina_dragon_slave_custom:GetCastPoint()
if self:GetCaster():HasModifier("modifier_lina_dragon_5") then 
  return self.time_cast
end

return 0.45
end



function lina_dragon_slave_custom:GetCooldown(iLevel)

local k = 1
if self:GetCaster():HasModifier("modifier_lina_dragon_3") then 
  k = k - self.cd_init - self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_lina_dragon_3")
end

if self:GetCaster():HasModifier("modifier_lina_dragon_slave_custom_legendary") then 
  return self.legendary_cd*k
end

 return self.BaseClass.GetCooldown(self, iLevel)*k

end

function lina_dragon_slave_custom:GetIntrinsicModifierName()
return "modifier_lina_dragon_slave_custom_tracker"
end

function lina_dragon_slave_custom:OnSpellStart(new_target)
  if not IsServer() then return end
  local caster = self:GetCaster()

  local target = self:GetCursorTarget()
  if new_target ~= nil then 
    target = new_target
  end

  local point = self:GetCursorPosition()


  if target then point = target:GetAbsOrigin()  end

  if point == self:GetCaster():GetAbsOrigin() then 
    point = point + self:GetCaster():GetForwardVector()*10
  end

  local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
  local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
  local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
  local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )

  local direction = point-caster:GetAbsOrigin()
  direction.z = 0
  local projectile_normalized = direction:Normalized()


  if self:GetCaster():HasModifier("modifier_lina_dragon_5") then 

    self:GetCaster():CdItems(self.time_cd)

  end

  local info = {
      Source = caster,
      Ability = self,
      vSpawnOrigin = caster:GetAbsOrigin(),
      bDeleteOnHit = false,
      iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
      iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
      iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
      EffectName = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf",
      fDistance = projectile_distance,
      fStartRadius = projectile_start_radius,
      fEndRadius = projectile_end_radius,
      vVelocity = projectile_normalized * projectile_speed,
      bProvidesVision = false,
  }

  ProjectileManager:CreateLinearProjectile(info)
  self:GetCaster():EmitSound("Hero_Lina.DragonSlave.Cast")
  self:GetCaster():EmitSound("Hero_Lina.DragonSlave")

end

function lina_dragon_slave_custom:OnProjectileHitHandle( target, location, projectile )
if not IsServer() then return end
if not target then return end

local damage = self:GetAbilityDamage()


if self:GetCaster():HasShard() then 
  local mod = self:GetCaster():FindModifierByName("modifier_lina_fiery_soul_custom")
  if mod then 
    damage = damage + mod:GetStackCount()*self.shard_damage
  end
end

if self:GetCaster():HasModifier("modifier_lina_dragon_1") then 
  target:AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_magic", {duration = self:GetCaster():GetTalentValue("modifier_lina_dragon_1", "duration")})
end 

if self:GetCaster():HasModifier("modifier_lina_dragon_6") then 
  target:AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_damage", {duration = self:GetCaster():GetTalentValue("modifier_lina_dragon_6", "duration")})
  target:AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_stack", {duration = self:GetCaster():GetTalentValue("modifier_lina_dragon_6", "stack_duration")})
end

local burn_duration = self:GetCaster():GetTalentValue("modifier_lina_dragon_4", "duration") + self:GetSpecialValueFor("dragon_slave_burn_duration") + 2*FrameTime()

target:AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_burn", {duration = burn_duration})
target:AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_burn_count", {duration = burn_duration})


if target:IsRealHero() and self:GetCaster():GetQuest() == "Lina.Quest_5" and (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() >= self:GetCaster().quest.number then 
  self:GetCaster():UpdateQuest(1)
end

if self:GetCaster():GetQuest() == "Lina.Quest_7" and target:IsRealHero() and not self:GetCaster():QuestCompleted() then 
  target:AddNewModifier(self:GetCaster(), self, "modifier_lina_fiery_soul_custom_quest", {duration = self:GetCaster().quest.number})
end



ApplyDamage( { victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self } )

local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
direction.z = 0
direction = direction:Normalized()

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControlForward( particle, 1, direction )
ParticleManager:ReleaseParticleIndex( particle )
end



modifier_lina_dragon_slave_custom_stack = class({})
function modifier_lina_dragon_slave_custom_stack:IsHidden() return true end
function modifier_lina_dragon_slave_custom_stack:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_stack:GetTexture() return "buffs/dragon_stack" end
function modifier_lina_dragon_slave_custom_stack:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_lina_dragon_6", "max")
self.stun = self:GetCaster():GetTalentValue("modifier_lina_dragon_6", "stun")


if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end

function modifier_lina_dragon_slave_custom_stack:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
if self:GetStackCount() >= self.max then 

  self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetParent():GetAbsOrigin() )
  ParticleManager:ReleaseParticleIndex(self.effect_cast)
  self:GetParent():EmitSound("Hero_OgreMagi.Fireblast.Target")

  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun*(1 - self:GetParent():GetStatusResistance())})

  self:Destroy()

end

end


function modifier_lina_dragon_slave_custom_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

  local particle_cast = "particles/lina_stack_stun.vpcf"

  self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

  self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end


function modifier_lina_dragon_slave_custom_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_lina_dragon_slave_custom_stack:OnTooltip()
return self.max
end

modifier_lina_dragon_slave_custom_legendary = class({})
function modifier_lina_dragon_slave_custom_legendary:IsHidden() return false end
function modifier_lina_dragon_slave_custom_legendary:IsPurgable() return false end 
function modifier_lina_dragon_slave_custom_legendary:GetEffectName() return "particles/huskar_spears_legen.vpcf" end
function modifier_lina_dragon_slave_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_omnislash.vpcf"
end
function modifier_lina_dragon_slave_custom_legendary:StatusEffectPriority() return
11111
end

function modifier_lina_dragon_slave_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true

self:GetParent():EmitSound("Lina.Dragon_legendary")

self:StartIntervalThink(0.2)
end
function modifier_lina_dragon_slave_custom_legendary:OnIntervalThink()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'lina_change',  {max = self:GetAbility().legendary_duration, current = self:GetRemainingTime(), active = 1})

end





function modifier_lina_dragon_slave_custom_legendary:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'lina_change',  {max = self:GetAbility().legendary_max, current = 0, active = 0})

end






modifier_lina_dragon_slave_custom_tracker = class({})
function modifier_lina_dragon_slave_custom_tracker:IsHidden() return true end
function modifier_lina_dragon_slave_custom_tracker:IsPurgable() return false end
function modifier_lina_dragon_slave_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_lina_dragon_slave_custom_tracker:OnCreated(table)
if not IsServer() then return end
self.active = 0

self:StartIntervalThink(1)
end

function modifier_lina_dragon_slave_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_lina_dragon_legendary") then 
  return
else
  if self.active == 0 then 
    self.active = 1
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'lina_change',  {max = self:GetAbility().legendary_max, current = self:GetStackCount(), active = 0})
  end

end



if self:GetStackCount() == 0 then return end

self:DecrementStackCount()

self:StartIntervalThink(0.2)
end


function modifier_lina_dragon_slave_custom_tracker:OnTakeDamage( params )
if not IsServer() then return end
if self:GetParent() ~= params.unit and self:GetParent() ~= params.attacker then return end
if (self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() >= self:GetAbility().legendary_range then return end
if params.inflictor and params.inflictor:IsItem() then return end

self:StartIntervalThink(self:GetAbility().legendary_delay)

end



function modifier_lina_dragon_slave_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end


if self:GetCaster():HasModifier("modifier_lina_dragon_2") then 

    local chance = self:GetCaster():GetTalentValue("modifier_lina_dragon_2", "chance")
    local random = RollPseudoRandomPercentage(chance,123,self:GetCaster())

    if random then 
      local mana = self:GetCaster():GetMaxMana()*self:GetCaster():GetTalentValue("modifier_lina_dragon_2", "mana")/100
      local heal = mana
      
      local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
      ParticleManager:SetParticleControl( particle, 0, self:GetCaster():GetAbsOrigin() )
      ParticleManager:ReleaseParticleIndex( particle )
      self:GetCaster():EmitSound("Lina.Dragon_heal")

      self:GetCaster():GenericHeal(heal, self:GetAbility())
      self:GetCaster():GiveMana(mana)
    end
end

if self:GetParent():HasModifier("modifier_lina_dragon_slave_custom_legendary") then return end
if not self:GetParent():HasModifier("modifier_lina_dragon_legendary") then return end

self:GiveStacks(self:GetAbility().legendary_spells)

self:StartIntervalThink(self:GetAbility().legendary_delay)


end



function modifier_lina_dragon_slave_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_lina_dragon_slave_custom_legendary") then return end
if not self:GetParent():HasModifier("modifier_lina_dragon_legendary") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

self:GiveStacks(self:GetAbility().legendary_attack)

end


function modifier_lina_dragon_slave_custom_tracker:GiveStacks(count)
if not IsServer() then return end

self:SetStackCount(self:GetStackCount() + count)

if self:GetStackCount() >= self:GetAbility().legendary_max then 

   self:GetAbility():EndCooldown()
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_dragon_slave_custom_legendary", {duration = self:GetAbility().legendary_duration})
  
  self:SetStackCount(0)
end

end


function modifier_lina_dragon_slave_custom_tracker:OnStackCountChanged(iStackCount)
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_lina_dragon_slave_custom_legendary")


local max = self:GetAbility().legendary_max
local current = self:GetStackCount()
local active = 0

if mod then 
  max = self:GetAbility().legendary_duration
  current = mod:GetRemainingTime()
  active = 1
end

self.active = 1
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'lina_change',  {max = max, current = current, active = active})


end






modifier_lina_dragon_slave_custom_burn = class({})
function modifier_lina_dragon_slave_custom_burn:IsHidden() return true end
function modifier_lina_dragon_slave_custom_burn:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_burn:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lina_dragon_slave_custom_burn:OnCreated(table)

self.damage = self:GetAbility():GetSpecialValueFor("dragon_slave_burn")

self.bonus_damage = self:GetCaster():GetTalentValue("modifier_lina_dragon_4", "damage")/100
self.creeps = self:GetCaster():GetTalentValue("modifier_lina_dragon_4", "creeps")

if not IsServer() then return end
self:StartIntervalThink(1)
end

function modifier_lina_dragon_slave_custom_burn:OnIntervalThink()
if not IsServer() then return end

local bonus = 0

if self:GetCaster():HasModifier("modifier_lina_dragon_4") then 
  bonus = self:GetParent():GetHealth()*self.bonus_damage

  if self:GetParent():IsCreep() then 
    bonus = bonus/self.creeps
  end 

end 

local damage = self.damage + bonus

local real_damage = ApplyDamage( { victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() } )

SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), real_damage, nil)

end


function modifier_lina_dragon_slave_custom_burn:OnDestroy()
if not IsServer() then return end 

local mod = self:GetParent():FindModifierByName("modifier_lina_dragon_slave_custom_burn_count")

if not mod then return end 

mod:DecrementStackCount()

if mod:GetStackCount() <= 0 then 
  mod:Destroy()
end 

end 


modifier_lina_dragon_slave_custom_burn_count = class({})
function modifier_lina_dragon_slave_custom_burn_count:IsHidden() return false end
function modifier_lina_dragon_slave_custom_burn_count:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_burn_count:GetEffectName()
return "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_burn.vpcf"
end


function modifier_lina_dragon_slave_custom_burn_count:OnCreated()
if not IsServer() then return end 

self:SetStackCount(1)
end 


function modifier_lina_dragon_slave_custom_burn_count:OnRefresh()
if not IsServer() then return end 

self:IncrementStackCount()
end

modifier_lina_dragon_slave_custom_damage = class({})
function modifier_lina_dragon_slave_custom_damage:IsHidden() return true end
function modifier_lina_dragon_slave_custom_damage:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_lina_dragon_slave_custom_damage:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_lina_dragon_6", "slow")
end 

function modifier_lina_dragon_slave_custom_damage:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end











modifier_lina_dragon_slave_custom_magic = class({})
function modifier_lina_dragon_slave_custom_magic:IsHidden() return false end
function modifier_lina_dragon_slave_custom_magic:IsPurgable() return true end
function modifier_lina_dragon_slave_custom_magic:GetTexture() return "buffs/remnant_lowhp" end
function modifier_lina_dragon_slave_custom_magic:OnCreated(table)

self.resist = self:GetCaster():GetTalentValue("modifier_lina_dragon_1", "resist")
self.max = self:GetCaster():GetTalentValue("modifier_lina_dragon_1", "max")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_lina_dragon_slave_custom_magic:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 


end

end

function modifier_lina_dragon_slave_custom_magic:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_lina_dragon_slave_custom_magic:GetModifierMagicalResistanceBonus()
return self:GetStackCount()*self.resist
end