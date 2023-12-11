LinkLuaModifier( "modifier_lina_laguna_blade_custom", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_legendary", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_legendary_thinker", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_shield", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_shield_knockback", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_shield_slow", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_shield_rooted", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_tracker", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_no_count", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_spell_steal", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_spell_steal_count", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_passive_max", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lina_laguna_blade_custom_heal", "abilities/lina/lina_laguna_blade_custom", LUA_MODIFIER_MOTION_NONE )


lina_laguna_blade_custom = class({})

lina_laguna_blade_custom.shard_damage = 20

lina_laguna_blade_custom.cd_init = -5
lina_laguna_blade_custom.cd_inc = -5

lina_laguna_blade_custom.shard_manacost_reduced = 100
lina_laguna_blade_custom.bonus_cast_range = 250




lina_laguna_blade_custom.shield_damage = -25
lina_laguna_blade_custom.shield_range = 300
lina_laguna_blade_custom.shield_slow = -80
lina_laguna_blade_custom.shield_slow_duration = 0.7
lina_laguna_blade_custom.shield_duration = 5
lina_laguna_blade_custom.shield_knock_duration = 0.25
lina_laguna_blade_custom.shield_knock_range = 350

lina_laguna_blade_custom.root_root = 2
lina_laguna_blade_custom.root_health = 40




function lina_laguna_blade_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_scorch.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_units_hit.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_mjollnir_shield.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/chain_lightning.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/gleipnir_root.vpcf", context )

end



function lina_laguna_blade_custom:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_lina_laguna_6") then 
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
  return DOTA_UNIT_TARGET_FLAG_NONE
end

end




function lina_laguna_blade_custom:GetIntrinsicModifierName()
if not self:GetCaster():HasModifier("modifier_lina_laguna_blade_custom_tracker") then 
  return "modifier_lina_laguna_blade_custom_tracker"
end 
  return 
end



function lina_laguna_blade_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_lina_laguna_1") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_lina_laguna_1")
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end




function lina_laguna_blade_custom:CastFilterResultTarget(target)



if self:GetCaster():HasModifier("modifier_lina_laguna_6") then 
  return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, self:GetCaster():GetTeamNumber())
else 
  return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, self:GetCaster():GetTeamNumber())
end

end








function lina_laguna_blade_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_lina_laguna_legendary") then
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT
  else
    return self.BaseClass.GetBehavior(self)
  end
end

function lina_laguna_blade_custom:GetCastRange(location, target)
    if self:GetCaster():HasModifier("modifier_lina_laguna_legendary") then
      return self.BaseClass.GetCastRange(self, location, target) + self.bonus_cast_range
    end
    return self.BaseClass.GetCastRange(self, location, target)
end


function lina_laguna_blade_custom:GetLagunaDamage(k)

local damage =  self:GetSpecialValueFor( "damage" )

if self:GetCaster():HasModifier("modifier_lina_laguna_2") then 
  damage = damage + self:GetCaster():GetIntellect()*self:GetCaster():GetTalentValue("modifier_lina_laguna_2", "damage")/100
end 

if k then 
  damage = damage*k
end 

return damage
end 



function lina_laguna_blade_custom:OnSpellStart(new_target)
 if not IsServer() then return end

  local target = self:GetCursorTarget()
  local delay = self:GetSpecialValueFor( "damage_delay" )

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_laguna_blade_custom_passive_max", {duration = self:GetSpecialValueFor("supercharge_duration")})

  if new_target ~= nil then 
    target = new_target
  end


  if self:GetCaster():HasModifier("modifier_lina_laguna_5") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_laguna_blade_custom_shield", {duration = self.shield_duration})
  end

  if self:GetCaster():HasModifier("modifier_lina_laguna_3") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_lina_laguna_blade_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_lina_laguna_3", "duration")})
  end 

  if self:GetCaster():HasModifier("modifier_lina_laguna_legendary") then
    local point = self:GetCursorPosition()

    if new_target ~= nil then 
      point = new_target:GetAbsOrigin()
    end

    local direction = point-self:GetCaster():GetAbsOrigin()
    direction.z = 0
    local projectile_normalized = direction:Normalized()

    local range = 600 + self.bonus_cast_range + self:GetCaster():GetCastRangeBonus()

    local end_point = self:GetCaster():GetAbsOrigin() + projectile_normalized * range
    end_point = GetGroundPosition(end_point, nil)

    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
    ParticleManager:SetParticleControl(particle, 1, end_point)
    ParticleManager:ReleaseParticleIndex( particle )

    local particle_smoke = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_scorch.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
    ParticleManager:SetParticleControlEnt( particle_smoke, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
    ParticleManager:SetParticleControl(particle_smoke, 1, end_point)
    ParticleManager:ReleaseParticleIndex( particle_smoke )


    self:GetCaster():EmitSound("Ability.LagunaBlade")

    local flag_type = 0
    local damage_type = DAMAGE_TYPE_MAGICAL
    local damage = self:GetSpecialValueFor( "damage" )

    if self:GetCaster():HasModifier("modifier_lina_laguna_6") then 
      flag_type = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    end


    local units = FindUnitsInLine(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(),end_point, nil, 125, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, flag_type)
    for _, unit in pairs(units) do
      unit:AddNewModifier( self:GetCaster(), self, "modifier_lina_laguna_blade_custom", { duration = delay } )
      unit:EmitSound("Ability.LagunaBladeImpact")
      local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade_shard_units_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
      ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
    end
  
    return
  end



  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil )
  ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
  ParticleManager:ReleaseParticleIndex( particle )
  self:GetCaster():EmitSound("Ability.LagunaBlade")

  if target:TriggerSpellAbsorb( self ) then return end
  target:AddNewModifier( self:GetCaster(), self, "modifier_lina_laguna_blade_custom", { duration = delay } )
end

modifier_lina_laguna_blade_custom = class({})

function modifier_lina_laguna_blade_custom:IsHidden()
  return true
end

function modifier_lina_laguna_blade_custom:IsPurgable()
  return false
end

function modifier_lina_laguna_blade_custom:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_lina_laguna_blade_custom:OnCreated( kv )
  if not IsServer() then return end
  self:GetParent():EmitSound("Ability.LagunaBladeImpact")
  self.damage = self:GetAbility():GetLagunaDamage(1)


  self.RemoveForDuel = true

  self.type = DAMAGE_TYPE_MAGICAL

end

function modifier_lina_laguna_blade_custom:OnDestroy()
  if not IsServer() then return end
  if self:GetParent():IsInvulnerable() then return end
  if self:GetParent():IsMagicImmune() and not self:GetCaster():HasModifier("modifier_lina_laguna_6") then return end

  if self:GetCaster():HasShard() then 
    local mod = self:GetCaster():FindModifierByName("modifier_lina_fiery_soul_custom")
    if mod then 
      self.damage = self.damage + mod:GetStackCount()*self:GetAbility().shard_damage
    end
  end

    
  if self:GetCaster():GetQuest() == "Lina.Quest_7" and self:GetParent():IsRealHero() and not self:GetCaster():QuestCompleted() then 
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_fiery_soul_custom_quest", {duration = self:GetCaster().quest.number})
  end


  if self:GetCaster():HasModifier("modifier_lina_dragon_1") then 
    self:GetParent():AddNewModifier(self:GetCaster(), self, "modifier_lina_dragon_slave_custom_magic", {duration = self:GetCaster():GetTalentValue("modifier_lina_dragon_1", "duration")})
  end 
    


  ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = self.type, ability = self:GetAbility()})

  if not self:GetParent():IsAlive() then return end



  if self:GetCaster():HasModifier("modifier_lina_laguna_6") then 
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self:GetAbility(), self:GetCaster():HasModifier("modifier_lina_laguna_6")), "modifier_lina_laguna_blade_custom_shield_rooted", {duration = self:GetAbility().root_root*(1 - self:GetParent():GetStatusResistance())})
  end

end






modifier_lina_laguna_blade_custom_legendary = class({})
function modifier_lina_laguna_blade_custom_legendary:IsHidden() return false end
function modifier_lina_laguna_blade_custom_legendary:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_legendary:OnCreated(table)
if not IsServer() then return end
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


local radius = self:GetCaster():GetTalentValue("modifier_lina_laguna_legendary", "radius")

local flag = 0

if self:GetCaster():HasModifier("modifier_lina_laguna_6") then 
  flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

local enemy_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + flag , FIND_CLOSEST, false)
local creeps_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + flag , FIND_CLOSEST, false)
  

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
    point = self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(100, radius))
  end
end
  CreateModifierThinker( self:GetCaster(), self:GetAbility(), "modifier_lina_laguna_blade_custom_legendary_thinker", { duration = self:GetCaster():GetTalentValue("modifier_lina_laguna_legendary", "delay") }, point, self:GetCaster():GetTeamNumber(), false )


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

self.radius = self:GetCaster():GetTalentValue("modifier_lina_laguna_legendary", "aoe")
local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )


self.damage = self:GetAbility():GetLagunaDamage(self:GetCaster():GetTalentValue("modifier_lina_laguna_legendary", "damage")/100)

self.type = DAMAGE_TYPE_MAGICAL


end



function modifier_lina_laguna_blade_custom_legendary_thinker:OnDestroy(table)
if not IsServer() then return end
    
ParticleManager:DestroyParticle( self.effect_cast, true )
ParticleManager:ReleaseParticleIndex( self.effect_cast )


local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, nil )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )

self:GetParent():EmitSound("Lina.Laguna_legendary")

local flag = 0
if self:GetCaster():HasModifier("modifier_lina_laguna_6") then 
  flag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end


local enemy_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, flag, FIND_CLOSEST, false)
    
local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_laguna_blade_custom_no_count", {})

for _,i in ipairs(enemy_for_ability) do
  ApplyDamage({ victim = i, attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = self.type})
end
   
if mod then 
  mod:Destroy()
end

end




modifier_lina_laguna_blade_custom_shield = class({})
function modifier_lina_laguna_blade_custom_shield:IsHidden() return false end
function modifier_lina_laguna_blade_custom_shield:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_shield:GetTexture() return "buffs/laguna_shield" end
function modifier_lina_laguna_blade_custom_shield:GetEffectName()
return "particles/generic_gameplay/rune_doubledamage_owner.vpcf"
end
function modifier_lina_laguna_blade_custom_shield:GetStatusEffectName()
return "particles/status_fx/status_effect_mjollnir_shield.vpcf"
end

function modifier_lina_laguna_blade_custom_shield:StatusEffectPriority()
return 1111
end

function modifier_lina_laguna_blade_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_lina_laguna_blade_custom_shield:OnAttackLanded(params)
if not IsServer() then return end
if params.target ~= self:GetParent() then return end
if params.attacker:IsMagicImmune() or params.attacker:IsInvulnerable() or params.attacker:IsBuilding() then return end
if ((params.attacker:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() >= self:GetAbility().shield_range) and params.attacker:IsRangedAttacker() then return end



local particle = ParticleManager:CreateParticle( "particles/items_fx/chain_lightning.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, params.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", params.attacker:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )

params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_laguna_blade_custom_shield_knockback", {duration = self:GetAbility().shield_knock_duration * (1 - params.attacker:GetStatusResistance()), x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})

end

function modifier_lina_laguna_blade_custom_shield:GetModifierIncomingDamage_Percentage()
return self:GetAbility().shield_damage
end



modifier_lina_laguna_blade_custom_shield_knockback = class({})

function modifier_lina_laguna_blade_custom_shield_knockback:IsHidden() return true end

function modifier_lina_laguna_blade_custom_shield_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  
  self.knockback_duration   = self.ability.shield_knock_duration

  self.knockback_distance   = math.max(self.ability.shield_knock_range -  (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), 60)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_lina_laguna_blade_custom_shield_knockback:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_lina_laguna_blade_custom_shield_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_lina_laguna_blade_custom_shield_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_lina_laguna_blade_custom_shield_knockback:OnDestroy()
  if not IsServer() then return end
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_laguna_blade_custom_shield_slow", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().shield_slow_duration})
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end




modifier_lina_laguna_blade_custom_shield_slow = class({})
function modifier_lina_laguna_blade_custom_shield_slow:IsHidden() return false end
function modifier_lina_laguna_blade_custom_shield_slow:IsPurgable() return true end
function modifier_lina_laguna_blade_custom_shield_slow:GetTexture() return "buffs/laguna_shield" end

function modifier_lina_laguna_blade_custom_shield_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_lina_laguna_blade_custom_shield_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().shield_slow
end

modifier_lina_laguna_blade_custom_shield_rooted = class({})
function modifier_lina_laguna_blade_custom_shield_rooted:IsHidden() return true end
function modifier_lina_laguna_blade_custom_shield_rooted:IsPurgable() return true end
function modifier_lina_laguna_blade_custom_shield_rooted:OnCreated(table)
self.stun = false
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("lina_laguna_blade_custom")

if not ability then return end

if self:GetCaster():GetHealthPercent() <= ability.root_health then 
  self.stun = true 
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(ability, self:GetCaster():HasModifier("modifier_lina_laguna_6")), "modifier_stunned", {duration = self:GetRemainingTime()})
end

end

function modifier_lina_laguna_blade_custom_shield_rooted:CheckState()
if self.stun == false then 
return
{
  [MODIFIER_STATE_ROOTED] = true
}

end

end
function modifier_lina_laguna_blade_custom_shield_rooted:GetEffectName() return "particles/items3_fx/gleipnir_root.vpcf" end



modifier_lina_laguna_blade_custom_tracker = class({})
function modifier_lina_laguna_blade_custom_tracker:IsHidden() return true end
function modifier_lina_laguna_blade_custom_tracker:IsPurgable() return false end



function modifier_lina_laguna_blade_custom_tracker:OnCreated(table)
if not IsServer() then return end

self.damage_count = 0
end

function modifier_lina_laguna_blade_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end
function modifier_lina_laguna_blade_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end



if self:GetParent() == params.attacker  and (self:GetParent():HasModifier("modifier_lina_laguna_legendary") or self:GetParent():HasModifier("modifier_lina_laguna_4")) 
  and not params.unit:IsIllusion()
  and params.inflictor and not self:GetParent():HasModifier("modifier_lina_laguna_blade_custom_no_count") then 

  local count = self:GetCaster():GetTalentValue("modifier_lina_laguna_legendary", "count")
  local creeps = self:GetCaster():GetTalentValue("modifier_lina_laguna_legendary", "creeps")

  if self:GetCaster():HasModifier("modifier_lina_laguna_4") then 
    count = self:GetCaster():GetTalentValue("modifier_lina_laguna_4", "count")
    creeps = self:GetCaster():GetTalentValue("modifier_lina_laguna_4", "creeps")
  end 

  local damage = params.damage


  if params.unit:IsCreep() then 
    damage = damage/creeps
  end


  while damage > 0 do 
    self.damage_count = damage + self.damage_count

    if self.damage_count < count then 
      damage = 0
    else 
      damage =  self.damage_count - count
      self.damage_count = 0

      if self:GetParent():HasModifier("modifier_lina_laguna_legendary") then 
        self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lina_laguna_blade_custom_legendary", {})
      end

      if self:GetParent():HasModifier("modifier_lina_laguna_4") then 

        local duration = self:GetCaster():GetTalentValue("modifier_lina_laguna_4", "duration")

        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_laguna_blade_custom_spell_steal_count", {duration = duration})
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_laguna_blade_custom_spell_steal", {duration = duration})

        self:GetCaster():CdAbility(self:GetAbility(), self:GetCaster():GetTalentValue("modifier_lina_laguna_4", "cd"))
      
      end 
    end
  end
end



if params.attacker ~= self:GetParent() then return end


if self:GetParent():HasModifier("modifier_lina_laguna_3") and params.inflictor then 

  local heal = params.damage*self:GetCaster():GetTalentValue("modifier_lina_laguna_3", "heal")/100

  if self:GetCaster():HasModifier("modifier_lina_laguna_blade_custom_heal") then 
    heal = heal*self:GetCaster():GetTalentValue("modifier_lina_laguna_3", "active")
  end 

  if params.unit:IsCreep() then 
    heal = heal/self:GetCaster():GetTalentValue("modifier_lina_laguna_3", "creeps")
  end

  self:GetCaster():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
end






end



modifier_lina_laguna_blade_custom_no_count = class({})
function modifier_lina_laguna_blade_custom_no_count:IsHidden() return true end
function modifier_lina_laguna_blade_custom_no_count:IsPurgable() return false end





modifier_lina_laguna_blade_custom_spell_steal = class({})
function modifier_lina_laguna_blade_custom_spell_steal:IsHidden() return false end
function modifier_lina_laguna_blade_custom_spell_steal:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_spell_steal:GetTexture() return "buffs/laguna_heal" end

function modifier_lina_laguna_blade_custom_spell_steal:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_lina_laguna_4", "damage")

if not IsServer() then return end

self.RemoveForDuel = true
self:SetStackCount(1)
end


function modifier_lina_laguna_blade_custom_spell_steal:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
end


function modifier_lina_laguna_blade_custom_spell_steal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}

end



function modifier_lina_laguna_blade_custom_spell_steal:GetModifierSpellAmplify_Percentage()
return self.damage*self:GetStackCount()
end





modifier_lina_laguna_blade_custom_spell_steal_count = class({})
function modifier_lina_laguna_blade_custom_spell_steal_count:IsHidden() return true end
function modifier_lina_laguna_blade_custom_spell_steal_count:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_spell_steal_count:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true 

end

function modifier_lina_laguna_blade_custom_spell_steal_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_lina_laguna_blade_custom_spell_steal_count:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_lina_laguna_blade_custom_spell_steal")
if not mod then return end

mod:DecrementStackCount()

if mod:GetStackCount() <= 0 then 
  mod:Destroy()
end

end


modifier_lina_laguna_blade_custom_passive_max = class({})
function modifier_lina_laguna_blade_custom_passive_max:IsHidden() return false end
function modifier_lina_laguna_blade_custom_passive_max:IsPurgable() return false end
function modifier_lina_laguna_blade_custom_passive_max:OnCreated()
if not IsServer() then return end 

self.ability = self:GetParent():FindAbilityByName("lina_fiery_soul_custom")
self.mod = self:GetParent():FindModifierByName("modifier_lina_fiery_soul_custom")

if not self.mod then return end 
if not self.ability then return end 

self.mod:SetStacks(self:GetAbility():GetSpecialValueFor("supercharge_stacks"))

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