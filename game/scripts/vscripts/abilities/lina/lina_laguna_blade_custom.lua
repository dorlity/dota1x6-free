LinkLuaModifier( "modifier_lina_laguna_blade_custom", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_legendary", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_legendary_thinker", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_shield", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_shield_slow", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_rooted", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_tracker", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_no_count", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_passive_max", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_heal", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_attacks", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_heal_reduce", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_unslow", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )

lina_laguna_blade_custom = class({})

function lina_laguna_blade_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_lina_immortal_ii_custom") then
    return "lina/lina_ti6_immortal/lina_laguna_blade"
end
return "lina_laguna_blade"
end



function lina_laguna_blade_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end


PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", context )

PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_scorch.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_units_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/rune_doubledamage_owner.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_mjollnir_shield.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/chain_lightning.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/gleipnir_root.vpcf", context )
PrecacheResource( "particle", "particles/lina/soul_attack_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_supercharge_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/lina/soul_attack.vpcf", context )

end




function lina_laguna_blade_custom:GetCastPoint()
local bonus = 0
if self:GetCaster():HasTalent("modifier_lina_laguna_5") then 
  bonus = self:GetCaster():GetTalentValue("modifier_lina_laguna_5", "cast")
end 

return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end


function lina_laguna_blade_custom:GetIntrinsicModifierName()
if not self:GetCaster():HasModifier("modifier_lina_laguna_blade_custom_tracker") then 
  return "modifier_lina_laguna_blade_custom_tracker"
end 
  return 
end



function lina_laguna_blade_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasTalent("modifier_lina_laguna_1") then 
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_lina_laguna_1", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end


function lina_laguna_blade_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_lina_laguna_legendary") then
  return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT
end
return self.BaseClass.GetBehavior(self)
end



function lina_laguna_blade_custom:GetCastRange(location, target)
local bonus = 0

if self:GetCaster():HasTalent("modifier_lina_laguna_1") then
  bonus = self:GetCaster():GetTalentValue("modifier_lina_laguna_1", "range")
end
return self.BaseClass.GetCastRange(self, location, target) + bonus
end



function lina_laguna_blade_custom:GetLagunaDamage(k)

local caster = self:GetCaster()
local damage = self:GetSpecialValueFor( "damage" )

if caster:HasTalent("modifier_lina_laguna_2") then 
  damage = damage + caster:GetIntellect(false)*caster:GetTalentValue("modifier_lina_laguna_2", "damage")/100
end 

if k then 
  damage = damage*k
end 

return damage
end 



function lina_laguna_blade_custom:OnSpellStart(new_target)
if not IsServer() then return end

local caster = self:GetCaster()
local target = self:GetCursorTarget()
local delay = self:GetSpecialValueFor( "damage_delay" )
local width = 125

caster:AddNewModifier(caster, self, "modifier_lina_laguna_blade_custom_passive_max", {duration = self:GetSpecialValueFor("supercharge_duration")})

if new_target ~= nil then 
  target = new_target
end

if caster:HasTalent("modifier_lina_laguna_5") then 
  caster:AddNewModifier(caster, self, "modifier_lina_laguna_blade_custom_shield", {duration = caster:GetTalentValue("modifier_lina_laguna_5", "duration")})
end

if caster:HasTalent("modifier_lina_soul_5") then
  caster:AddNewModifier(caster, self, "modifier_lina_laguna_blade_custom_unslow", {duration = caster:GetTalentValue("modifier_lina_soul_5", "duration")})
end

if caster:HasTalent("modifier_lina_laguna_3") then 
  caster:AddNewModifier(caster, self, "modifier_lina_laguna_blade_custom_heal", {duration = caster:GetTalentValue("modifier_lina_laguna_3", "duration")})
end 

local laguna_sound = "Ability.LagunaBlade"
local laguna_particle = "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf"

if caster:HasModifier("modifier_lina_immortal_ii_custom") then
  laguna_sound = "Hero_Lina.LagunaBlade.Immortal"
  laguna_particle = "particles/econ/items/lina/lina_ti6/lina_ti6_laguna_blade.vpcf"
end

caster:EmitSound(laguna_sound)

if caster:HasTalent("modifier_lina_laguna_legendary") then
  local point = self:GetCursorPosition()

  if new_target ~= nil then 
    point = new_target:GetAbsOrigin()
  end

  local direction = point-caster:GetAbsOrigin()
  direction.z = 0
  local projectile_normalized = direction:Normalized()

  local range = self:GetCastRange(caster:GetAbsOrigin(), nil) + caster:GetCastRangeBonus()

  local end_point = caster:GetAbsOrigin() + projectile_normalized * range
  end_point = GetGroundPosition(end_point, nil)

  local particle = ParticleManager:CreateParticle( laguna_particle, PATTACH_CUSTOMORIGIN, nil )
  ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
  ParticleManager:SetParticleControl(particle, 1, end_point)
  ParticleManager:ReleaseParticleIndex( particle )

  local particle_smoke = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_scorch.vpcf", PATTACH_CUSTOMORIGIN, caster )
  ParticleManager:SetParticleControlEnt( particle_smoke, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
  ParticleManager:SetParticleControl(particle_smoke, 1, end_point)
  ParticleManager:ReleaseParticleIndex( particle_smoke )

  local units = FindUnitsInLine(caster:GetTeamNumber(), caster:GetAbsOrigin(),end_point, nil, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0)
  for _, unit in pairs(units) do
    unit:AddNewModifier( caster, self, "modifier_lina_laguna_blade_custom", { duration = delay } )
  end


  if caster:HasTalent("modifier_lina_soul_4") and #units > 0 then 
    caster:AddNewModifier(caster, self, "modifier_lina_fiery_soul_custom_stack", {duration = caster:GetTalentValue("modifier_lina_soul_4", "duration", true)})
  end 

  return
end

local particle = ParticleManager:CreateParticle( laguna_particle, PATTACH_CUSTOMORIGIN, nil )
ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
ParticleManager:ReleaseParticleIndex( particle )

if target:TriggerSpellAbsorb( self ) then return end

if caster:HasTalent("modifier_lina_soul_4") then 
  caster:AddNewModifier(caster, self, "modifier_lina_fiery_soul_custom_stack", {duration = caster:GetTalentValue("modifier_lina_soul_4", "duration", true)})
end 

target:AddNewModifier( caster, self, "modifier_lina_laguna_blade_custom", { duration = delay } )
end





modifier_lina_laguna_blade_custom = class({})

function modifier_lina_laguna_blade_custom:IsHidden() return true end
function modifier_lina_laguna_blade_custom:IsPurgable() return false end
function modifier_lina_laguna_blade_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lina_laguna_blade_custom:OnCreated( kv )

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()
self.soul = self.caster:FindAbilityByName("lina_fiery_soul_custom")

self.resist_duration = self.caster:GetTalentValue("modifier_lina_dragon_1", "duration")

self.root = self.caster:GetTalentValue("modifier_lina_laguna_6", "root")
self.break_duration = self.caster:GetTalentValue("modifier_lina_laguna_6", "break_duration")

if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_units_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

local impact_sound = "Ability.LagunaBladeImpact"

if self.caster:HasModifier("modifier_lina_immortal_ii_custom") then
  impact_sound = "Hero_Lina.LagunaBladeImpact.Immortal"
end

self.parent:EmitSound(impact_sound)

self.damage = self.ability:GetLagunaDamage()
self.RemoveForDuel = true

end



function modifier_lina_laguna_blade_custom:OnDestroy()
if not IsServer() then return end

local damage = self.damage
if self.soul and self.soul:GetLevel() > 0 then 
  self.damage = self.damage + self.soul:GetShardDamage()
end 

if self.caster:GetQuest() == "Lina.Quest_7" and self.parent:IsRealHero() and not self.caster:QuestCompleted() then 
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_lina_laguna_blade_custom_tracker_quest", {duration = self.caster.quest.number})
end

if self.caster:HasTalent("modifier_lina_dragon_1") then 
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_lina_dragon_slave_custom_magic", {duration = self.caster:GetTalentValue("modifier_lina_dragon_1", "duration")})
end 

if self.caster:HasTalent("modifier_lina_laguna_6") then 
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_lina_laguna_blade_custom_rooted", {duration = self.root*(1 - self.parent:GetStatusResistance())})
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_generic_break", {duration = self.break_duration*(1 - self.parent:GetStatusResistance())})
end

if self.caster:HasTalent("modifier_lina_laguna_2") then 
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_lina_laguna_blade_custom_heal_reduce", {duration = self.caster:GetTalentValue("modifier_lina_laguna_2", "duration")})
end 

DoDamage({ victim = self.parent, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability})
end








modifier_lina_laguna_blade_custom_legendary = class({})
function modifier_lina_laguna_blade_custom_legendary:IsHidden() return true end
function modifier_lina_laguna_blade_custom_legendary:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.radius = self.caster:GetTalentValue("modifier_lina_laguna_legendary", "radius", true)
self.delay = self.caster:GetTalentValue("modifier_lina_laguna_legendary", "delay", true)

self.RemoveForDuel = true 
self:SetStackCount(1)

self:StartIntervalThink(self:GetCaster():GetTalentValue("modifier_lina_laguna_legendary", "interval"))  

end


function modifier_lina_laguna_blade_custom_legendary:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

end


function modifier_lina_laguna_blade_custom_legendary:OnIntervalThink()
if not IsServer() then return end

local enemy_for_ability = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
local creeps_for_ability = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
  

local point 
local vector_random = RandomVector(RandomInt(1,100))

if #enemy_for_ability > 0 then 

  if enemy_for_ability[1]:IsMoving() then 
    vector_random = enemy_for_ability[1]:GetForwardVector()*(100)
  end

  point = enemy_for_ability[1]:GetAbsOrigin() + vector_random
else 
  if #creeps_for_ability > 0 then 

   point = creeps_for_ability[1]:GetAbsOrigin() + vector_random
  else 
    point = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(100,  self.radius))
  end
end

CreateModifierThinker(self.caster, self.ability, "modifier_lina_laguna_blade_custom_legendary_thinker", { duration = self.delay }, point, self.caster:GetTeamNumber(), false )

self:DecrementStackCount()
if self:GetStackCount() == 0 then 
  self:Destroy()
end

end






modifier_lina_laguna_blade_custom_legendary_thinker = class({})
function modifier_lina_laguna_blade_custom_legendary_thinker:IsHidden() return true end
function modifier_lina_laguna_blade_custom_legendary_thinker:IsPurgable() return false end

function modifier_lina_laguna_blade_custom_legendary_thinker:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.point = self.parent:GetAbsOrigin()

self.radius = self.caster:GetTalentValue("modifier_lina_laguna_legendary", "aoe")

self.effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControl( self.effect_cast, 0, self.point )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )
self:AddParticle( self.effect_cast, false, false, -1, false, false  )

self.damage = self.ability:GetLagunaDamage(self.caster:GetTalentValue("modifier_lina_laguna_legendary", "damage")/100)
end

function modifier_lina_laguna_blade_custom_legendary_thinker:OnDestroy(table)
if not IsServer() then return end
    
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil )
ParticleManager:SetParticleControlEnt( particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_attack1", self.caster:GetAbsOrigin(), true )
ParticleManager:SetParticleControl(particle, 1, self.point)
ParticleManager:ReleaseParticleIndex( particle )

self.parent:EmitSound("Lina.Laguna_legendary")

local mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_lina_laguna_blade_custom_no_count", {})

for _,enemy in pairs(self.caster:FindTargets(self.radius, self.point)) do
  DoDamage({ victim = enemy, attacker = self.caster, ability = self.ability, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL}, "modifier_lina_laguna_legendary")
end
   
if mod then 
  mod:Destroy()
end

end









modifier_lina_laguna_blade_custom_shield = class({})
function modifier_lina_laguna_blade_custom_shield:IsHidden() return true end
function modifier_lina_laguna_blade_custom_shield:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_shield:GetTexture() return "buffs/laguna_shield" end
function modifier_lina_laguna_blade_custom_shield:GetEffectName() return "particles/generic_gameplay/rune_doubledamage_owner.vpcf" end
function modifier_lina_laguna_blade_custom_shield:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_lina_laguna_blade_custom_shield:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA  end

function modifier_lina_laguna_blade_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function modifier_lina_laguna_blade_custom_shield:AttackEvent_inc(params)
if not IsServer() then return end
local attacker = params.attacker

if params.target ~= self.caster then return end
if not attacker:IsHero() and not attacker:IsCreep() then return end
if attacker:IsRangedAttacker() and (attacker:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() >= self.range then return end


local enemyAbs = attacker:GetAbsOrigin()
local center = self.caster:GetAbsOrigin()
local direction = enemyAbs - center
direction.z = 0
direction = direction:Normalized()

if self.caster == enemyAbs then
  direction = attacker:GetForwardVector()
end 

local point = center + self.range*direction
local length = (point - enemyAbs):Length2D() 

local knockbackProperties =
{
  center_x = center.x,
  center_y = center.y,
  center_z = center.z,
  duration = self.knock_duration,
  knockback_duration = self.knock_duration,
  knockback_distance = math.min(self.max_distance, math.max(length, self.min_distance)),
  knockback_height = 0,
  should_stun = 0
}
attacker:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
attacker:EmitSound("Lina.Laguna_knock")

local particle = ParticleManager:CreateParticle( "particles/items_fx/chain_lightning.vpcf", PATTACH_POINT_FOLLOW, self.caster )
ParticleManager:SetParticleControlEnt( particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )

attacker:AddNewModifier(self.caster, self.ability, "modifier_lina_laguna_blade_custom_shield_slow", {duration = self.slow_duration})
end


function modifier_lina_laguna_blade_custom_shield:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end

function modifier_lina_laguna_blade_custom_shield:OnCreated()

self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.caster:AddAttackEvent_inc(self)

self.min_distance = self.caster:GetTalentValue("modifier_lina_laguna_5", "range_min")
self.max_distance = self.caster:GetTalentValue("modifier_lina_laguna_5", "range_max")
self.knock_duration = self.caster:GetTalentValue("modifier_lina_laguna_5", "knock_duration")
self.slow_duration = self.caster:GetTalentValue("modifier_lina_laguna_5", "slow_duration")
self.range = self.caster:GetTalentValue("modifier_lina_laguna_5", "range")
self.damage_reduce = self.caster:GetTalentValue("modifier_lina_laguna_5", "damage_reduce")
end 






modifier_lina_laguna_blade_custom_shield_slow = class({})
function modifier_lina_laguna_blade_custom_shield_slow:IsHidden() return true end
function modifier_lina_laguna_blade_custom_shield_slow:IsPurgable() return true end
function modifier_lina_laguna_blade_custom_shield_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_lina_laguna_blade_custom_shield_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_lina_laguna_blade_custom_shield_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_lina_laguna_5", "slow")
end

function modifier_lina_laguna_blade_custom_shield_slow:GetEffectName()
return "particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf"
end





modifier_lina_laguna_blade_custom_rooted = class({})
function modifier_lina_laguna_blade_custom_rooted:IsHidden() return true end
function modifier_lina_laguna_blade_custom_rooted:IsPurgable() return true end
function modifier_lina_laguna_blade_custom_rooted:OnCreated(table)
self.stun = false

local caster = self:GetCaster()
local parent = self:GetParent()

if caster:GetHealthPercent() <= caster:GetTalentValue("modifier_lina_laguna_6", "health") then 
  self.stun = true 

  if IsServer() then 
    parent:AddNewModifier(caster, self:GetAbility(), "modifier_stunned", {duration = self:GetRemainingTime()})
  end
end

end


function modifier_lina_laguna_blade_custom_rooted:CheckState()
if self.stun == false then 
  return
  {
    [MODIFIER_STATE_ROOTED] = true
  }
  end
end

function modifier_lina_laguna_blade_custom_rooted:GetEffectName() return "particles/items3_fx/gleipnir_root.vpcf" end








modifier_lina_laguna_blade_custom_tracker = class({})
function modifier_lina_laguna_blade_custom_tracker:IsHidden() return true end
function modifier_lina_laguna_blade_custom_tracker:IsPurgable() return false end


function modifier_lina_laguna_blade_custom_tracker:OnCreated(table)

self.parent = self:GetParent()

self.ability = self:GetAbility()

if self.parent:IsRealHero() then 
  self.parent:AddSpellEvent(self)
  self.parent:AddDamageEvent_out(self)
  self.parent:AddAttackStartEvent_out(self)
  self.parent:AddRecordDestroyEvent(self)
end

self.heal_active = self.parent:GetTalentValue("modifier_lina_laguna_3", "active", true)
self.heal_creeps = self.parent:GetTalentValue("modifier_lina_laguna_3", "creeps", true)

self.legendary_creeps = self.parent:GetTalentValue("modifier_lina_laguna_legendary", "creeps", true)
self.legendary_count = self.parent:GetTalentValue("modifier_lina_laguna_legendary", "count", true)
self.legendary_cd = self.parent:GetTalentValue("modifier_lina_laguna_legendary", "cd", true)

self.attack_duration = self.parent:GetTalentValue("modifier_lina_laguna_4", "duration", true)

self.attack_records = {}
self.damage_count = 0
end

function modifier_lina_laguna_blade_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
}
end



function modifier_lina_laguna_blade_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end
if params.ability:IsItem() then return end

if self.parent:HasTalent("modifier_lina_laguna_4") then 
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_lina_laguna_blade_custom_attacks", {duration = self.attack_duration})
end 

end





function modifier_lina_laguna_blade_custom_tracker:AttackStartEvent_out(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end
if params.no_attack_cooldown then return end

local mod = self.parent:FindModifierByName("modifier_lina_laguna_blade_custom_attacks")
if not mod then return end 

self.parent:EmitSound("Lina.Soul_attack_start")
self.attack_records[params.record] = true

mod:DecrementStackCount()
if mod:GetStackCount() <= 0 then 
  mod:Destroy()
end 

end 


function modifier_lina_laguna_blade_custom_tracker:GetOverrideAttackMagical()
if self.parent:HasModifier("modifier_lina_laguna_blade_custom_attacks") then return 1 end

local magical = 0

for _,record in pairs(self.attack_records) do 
  if record then 
    magical = 1
    break
  end 
end

return magical
end



function modifier_lina_laguna_blade_custom_tracker:GetModifierTotalDamageOutgoing_Percentage(params)
if not IsServer() then return end
if not params.record then return end 
if not self.attack_records[params.record] then return end
if params.inflictor then return 0 end
if params.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
if params.damage_type == DAMAGE_TYPE_MAGICAL then return 0 end

if self.parent:HasModifier("modifier_revenants_brooch_custom_counter") then return end 

local damageTable = {
  attacker = self.parent,
  damage = params.original_damage,
  damage_type = DAMAGE_TYPE_MAGICAL,
  victim = params.target,
  ability = self.ability,
  damage_flags = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK
}
DoDamage(damageTable, "modifier_lina_laguna_4")

params.target:EmitSound("Lina.Soul_attack_end")

local hit_effect = ParticleManager:CreateParticle("particles/lina/soul_attack_end.vpcf", PATTACH_CUSTOMORIGIN, params.target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

return -200
end



function modifier_lina_laguna_blade_custom_tracker:RecordDestroyEvent(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.record then return end 
if not self.attack_records[params.record] then return end

self.attack_records[params.record] = nil
end




function modifier_lina_laguna_blade_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end

local attacker = params.attacker

if not attacker then return end
if params.unit:IsIllusion() then return end 
if not params.inflictor then return end

if self.parent == attacker and self.parent:HasTalent("modifier_lina_laguna_legendary") and not self.parent:HasModifier("modifier_lina_laguna_blade_custom_no_count") then 

  local damage = params.damage

  if params.unit:IsCreep() then 
    damage = damage/self.legendary_creeps
  end

  local final = damage + self.damage_count

  if final >= self.legendary_count then 

    local delta = math.floor(final/self.legendary_count)

    for i = 1, delta do 
      self.parent:AddNewModifier(self.parent, self.ability, "modifier_lina_laguna_blade_custom_legendary", {})
      self.parent:CdAbility(self.ability, self.legendary_cd)
    end 

    self.damage_count = final - delta*self.legendary_count
  else 
    self.damage_count = final
  end 

end


if not self.parent:HasTalent("modifier_lina_laguna_3") then return end
if params.attacker ~= self.parent then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end


local heal = params.damage*self.parent:GetTalentValue("modifier_lina_laguna_3", "heal")/100

if self.parent:HasModifier("modifier_lina_laguna_blade_custom_heal") then 
  heal = heal*self.heal_active
end 

if params.unit:IsCreep() then 
  heal = heal/self.heal_creeps
end

self.parent:GenericHeal(heal, self.ability, true, "particles/items3_fx/octarine_core_lifesteal.vpcf", "modifier_lina_laguna_3")

end



modifier_lina_laguna_blade_custom_no_count = class({})
function modifier_lina_laguna_blade_custom_no_count:IsHidden() return true end
function modifier_lina_laguna_blade_custom_no_count:IsPurgable() return false end









modifier_lina_laguna_blade_custom_passive_max = class({})
function modifier_lina_laguna_blade_custom_passive_max:IsHidden() return false end
function modifier_lina_laguna_blade_custom_passive_max:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_passive_max:OnCreated()
if not IsServer() then return end 
self.parent = self:GetParent()

self.ability = self.parent:FindAbilityByName("lina_fiery_soul_custom")
self.mod = self.parent:FindModifierByName("modifier_lina_fiery_soul_custom")

if not self.mod then return end 
if not self.ability then return end 

local stacks = self:GetAbility():GetSpecialValueFor("supercharge_stacks")
if self.parent:HasShard() then
  stacks = stacks + self.ability:GetSpecialValueFor("shard_stacks")
end

self.mod:SetStacks(stacks)
end 



function modifier_lina_laguna_blade_custom_passive_max:GetEffectName()
return "particles/units/heroes/hero_lina/lina_supercharge_buff.vpcf"
end

function modifier_lina_laguna_blade_custom_passive_max:OnDestroy()
if not IsServer() then return end
if not self.mod then return end 
if not self.ability then return end 

self.mod:SetStacks(0, true)
end 



modifier_lina_laguna_blade_custom_heal = class({})
function modifier_lina_laguna_blade_custom_heal:IsHidden() return true end
function modifier_lina_laguna_blade_custom_heal:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_heal:GetEffectName()
return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf"
end










modifier_lina_laguna_blade_custom_attacks = class({})
function modifier_lina_laguna_blade_custom_attacks:IsHidden() return true end
function modifier_lina_laguna_blade_custom_attacks:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_attacks:OnCreated(table)
self.RemoveForDuel = true
self:SetStackCount(self:GetCaster():GetTalentValue("modifier_lina_laguna_4", "max"))
end

function modifier_lina_laguna_blade_custom_attacks:OnRefresh()
self:OnCreated()
end

function modifier_lina_laguna_blade_custom_attacks:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_PROJECTILE_NAME,
}
end

function modifier_lina_laguna_blade_custom_attacks:GetModifierProjectileName()
return "particles/lina/soul_attack.vpcf"
end


function modifier_lina_laguna_blade_custom_attacks:CheckState()
return
{
  [MODIFIER_STATE_CANNOT_MISS] = true
}
end




modifier_lina_laguna_blade_custom_heal_reduce = class({})
function modifier_lina_laguna_blade_custom_heal_reduce:IsHidden() return true end
function modifier_lina_laguna_blade_custom_heal_reduce:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_heal_reduce:OnCreated()
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_lina_laguna_2", "heal_reduce")
end

function modifier_lina_laguna_blade_custom_heal_reduce:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end


function modifier_lina_laguna_blade_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_lina_laguna_blade_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget() 
return self.heal_reduce
end

function modifier_lina_laguna_blade_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end


modifier_lina_laguna_blade_custom_unslow = class({})
function modifier_lina_laguna_blade_custom_unslow:IsHidden() return true end
function modifier_lina_laguna_blade_custom_unslow:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_unslow:CheckState()
return
{
  [MODIFIER_STATE_UNSLOWABLE] = true
}
end