LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_custom", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_tracker", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_damage", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_stack", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_stack_cd", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_ground_tracker", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_ground_poison", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_viscous_nasal_goo_no_stun", "abilities/bristleback/bristleback_viscous_nasal_goo_custom", LUA_MODIFIER_MOTION_NONE)

bristleback_viscous_nasal_goo_custom              = class({})



bristleback_viscous_nasal_goo_custom.proc_inc = 4
bristleback_viscous_nasal_goo_custom.proc_init = 4


bristleback_viscous_nasal_goo_custom.legendary_chance = 3
bristleback_viscous_nasal_goo_custom.legendary_stun = 0.5
bristleback_viscous_nasal_goo_custom.legendary_damage = 0.02
bristleback_viscous_nasal_goo_custom.legendary_creeps = 0.33


bristleback_viscous_nasal_goo_custom.damage_amount = 30
bristleback_viscous_nasal_goo_custom.damage_interval = 1
bristleback_viscous_nasal_goo_custom.damage_duration = {2, 3, 4}

bristleback_viscous_nasal_goo_custom.dispel_stun = 1
bristleback_viscous_nasal_goo_custom.dispel_max = 4
bristleback_viscous_nasal_goo_custom.dispel_armor = 1


bristleback_viscous_nasal_goo_custom.ground_duration = 8
bristleback_viscous_nasal_goo_custom.ground_damage = 40
bristleback_viscous_nasal_goo_custom.ground_radius = 150
bristleback_viscous_nasal_goo_custom.ground_chance = {20,30}
bristleback_viscous_nasal_goo_custom.ground_interval = 1
bristleback_viscous_nasal_goo_custom.ground_armor = -3




function bristleback_viscous_nasal_goo_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_crimson_nasal_goo_proj.vpcf", context )
PrecacheResource( "particle", "particles/bristle_goo_ground.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_goo.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", context )

end



function bristleback_viscous_nasal_goo_custom:GetIntrinsicModifierName() return "modifier_bristleback_viscous_nasal_goo_tracker" end


function bristleback_viscous_nasal_goo_custom:GetCastPoint(iLevel)
if self:GetCaster():HasShard() then 
  return self:GetSpecialValueFor("cast_shard") 
end

return self.BaseClass.GetCastPoint(self)
end



function bristleback_viscous_nasal_goo_custom:GetBehavior()
 -- if self:GetCaster():HasScepter() then
 --   return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
 -- else
    return self.BaseClass.GetBehavior(self)
 -- end
end

function bristleback_viscous_nasal_goo_custom:GetCastRange(location, target)
 -- if self:GetCaster():HasScepter() then
  --  return self:GetSpecialValueFor("radius_scepter")
  --else
    return self.BaseClass.GetCastRange(self, location, target)
  --end
end


function bristleback_viscous_nasal_goo_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end 

function bristleback_viscous_nasal_goo_custom:OnSpellStart(target, unit, add_stacks)

  if target == nil then 
    enemy = self:GetCursorTarget()

  else 
    enemy = target
  end

  if unit == nil then 
    self.location = self:GetCaster():GetAbsOrigin()
    self.source_caster = self:GetCaster()
  else 
    self.location = unit:GetAbsOrigin()
    self.source_caster = unit
  end




  self.caster = self:GetCaster()

  self.goo_speed          = self:GetSpecialValueFor("goo_speed")
  self.goo_duration       = self:GetSpecialValueFor("goo_duration")
  self.goo_duration_creep     = self:GetSpecialValueFor("goo_duration_creep")
  self.radius_scepter       = self:GetSpecialValueFor("radius_scepter") + self:GetCaster():GetCastRangeBonus()


  local projectile = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf"
  local more_stacks = 0
  if self:GetCaster():HasModifier("modifier_bristle_goo_stack") 
    and RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_bristle_goo_stack", "chance") ,119,self:GetCaster()) then 
  
    projectile = "particles/econ/items/bristleback/ti7_head_nasal_goo/bristleback_ti7_crimson_nasal_goo_proj.vpcf"
    more_stacks = more_stacks + self:GetCaster():GetTalentValue("modifier_bristle_goo_stack", "more_stacks")
 
  end

  if add_stacks then 
    more_stacks = more_stacks + add_stacks
  end 


  if not IsServer() then return end

  self.caster:EmitSound("Hero_Bristleback.ViscousGoo.Cast")

  if self.caster:HasScepter() and unit == nil and false then
    local enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.radius_scepter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)



    for _, enemy in pairs(enemies) do
      local projectile =
      {
        Target        = enemy,
        Source        = self.caster,
        Ability       = self,
        EffectName      = projectile,
        iMoveSpeed      = self.goo_speed,
        vSourceLoc      = self.caster:GetAbsOrigin(),
        bDrawsOnMinimap   = false,
        bDodgeable      = true,
        bIsAttack       = false,
        bVisibleToEnemies = true,
        bReplaceExisting  = false,
        flExpireTime    = GameRules:GetGameTime() + 10,
        bProvidesVision   = false,
        iVisionRadius     = 0,
        iVisionTeamNumber   = self.caster:GetTeamNumber(),
        ExtraData = {more_stacks = more_stacks}
      }

      ProjectileManager:CreateTrackingProjectile(projectile)
    end
  else

    local radius = self:GetSpecialValueFor("aoe_radius")

    local is_shard = 0 

    if unit ~= nil then 
      radius = 1
      is_shard = 1
    end 

    self.targets = self:GetCaster():FindTargets(radius, enemy:GetAbsOrigin())

    local projectile =
    {
      Source        = self.source_caster,
      Ability       = self,
      EffectName      = projectile,
      iMoveSpeed      = self.goo_speed,
      vSourceLoc      = self.location,
      bDrawsOnMinimap   = false,
      bDodgeable      = true,
      bIsAttack       = false,
      bVisibleToEnemies = true,
      bReplaceExisting  = false,
      flExpireTime    = GameRules:GetGameTime() + 10,
      bProvidesVision   = false,
      ExtraData = {more_stacks = more_stacks, is_shard = is_shard}
    }
    

    for _,unit in pairs(self.targets) do 
      projectile.Target = unit
      ProjectileManager:CreateTrackingProjectile(projectile)
    end 

  end
    


  if self.caster:GetName() == "npc_dota_hero_bristleback" and RollPercentage(40) then
    self.caster:EmitSound("bristleback_bristle_nasal_goo_0"..math.random(1,7))
  end

end

function bristleback_viscous_nasal_goo_custom:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
if hTarget == nil or not hTarget:IsAlive() or hTarget:IsMagicImmune() then return end

if ExtraData.is_shard and ExtraData.is_shard == 0 then 
  if hTarget:TriggerSpellAbsorb(self) then return end
end

local duration = self.goo_duration
if hTarget:IsCreep() then 
  duration = self.goo_duration_creep
end

if self:GetCaster():HasModifier("modifier_bristle_goo_stack") then 
  duration = duration + self:GetCaster():GetTalentValue("modifier_bristle_goo_stack", "duration")
end

local stacks = 1
if ExtraData.more_stacks then 
  stacks = stacks + ExtraData.more_stacks
end

if self:GetCaster():HasModifier("modifier_bristle_goo_damage") then 


  local chance = self:GetCaster():GetTalentValue("modifier_bristle_goo_damage", "chance")

  local random = RollPseudoRandomPercentage(chance,117,self:GetCaster())
 
  if random  then 
     CreateModifierThinker(self:GetCaster(), self, "modifier_bristleback_viscous_nasal_goo_ground_tracker", {duration = self:GetCaster():GetTalentValue("modifier_bristle_goo_damage", "duration")}, hTarget:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
     hTarget:EmitSound("BB.Goo_poison")
     self.particle = ParticleManager:CreateParticle("particles/bristle_goo_ground.vpcf", PATTACH_WORLDORIGIN, nil)
     ParticleManager:SetParticleControl(self.particle, 1, hTarget:GetAbsOrigin())
     ParticleManager:SetParticleControl(self.particle, 3, hTarget:GetAbsOrigin())
     ParticleManager:ReleaseParticleIndex(self.particle)
  end
end


for i = 1,stacks do
   hTarget:AddNewModifier(self.caster, self, "modifier_bristleback_viscous_nasal_goo_custom", {duration = duration * (1 - hTarget:GetStatusResistance())})
end

hTarget:EmitSound("Hero_Bristleback.ViscousGoo.Target")


if self:GetCaster():HasModifier("modifier_bristle_goo_ground") then 
  hTarget:AddNewModifier(self:GetCaster(), self, "modifier_bristleback_viscous_nasal_goo_damage", {duration = self.damage_duration[self:GetCaster():GetUpgradeStack("modifier_bristle_goo_ground")]})
end

end

modifier_bristleback_viscous_nasal_goo_custom = class({})


function modifier_bristleback_viscous_nasal_goo_custom:GetEffectName()
  return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end

function modifier_bristleback_viscous_nasal_goo_custom:GetStatusEffectName()
  return "particles/status_fx/status_effect_goo.vpcf"
end



function modifier_bristleback_viscous_nasal_goo_custom:StatusEffectPriority()
    return 10
end



function modifier_bristleback_viscous_nasal_goo_custom:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  self.RemoveForDuel = true
  
  self.base_armor       = self.ability:GetSpecialValueFor("base_armor")
  self.armor_per_stack    = self.ability:GetSpecialValueFor("armor_per_stack")
  self.base_move_slow     = self.ability:GetSpecialValueFor("base_move_slow")
  self.move_slow_per_stack  = self.ability:GetSpecialValueFor("move_slow_per_stack")
  self.stack_limit      = self.ability:GetSpecialValueFor("stack_limit")
  

  if self:GetCaster():HasModifier("modifier_bristle_goo_max") then 
    self.stack_limit = self.stack_limit + self:GetCaster():GetTalentValue("modifier_bristle_goo_max", "max")
  end

  if self:GetCaster():HasModifier("modifier_bristle_goo_status") then 
    self.armor_per_stack = self.armor_per_stack + self.ability.dispel_armor
  end



  if not IsServer() then return end


  self:SetStackCount(1)
  
  self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
  self:AddParticle(self.particle, false, false, -1, false, false)

  if self:GetCaster():GetQuest() == "Brist.Quest_5" and self:GetCaster():QuestCompleted() == false and self:GetParent():IsRealHero() then 
    self:StartIntervalThink(0.1)
  end
end

function modifier_bristleback_viscous_nasal_goo_custom:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster():GetQuest() then return end
if self:GetStackCount() < self:GetCaster().quest.number then return end

self:GetCaster():UpdateQuest(0.1)

end



function modifier_bristleback_viscous_nasal_goo_custom:OnRefresh()
  if not IsServer() then return end

  if self:GetStackCount() < self.stack_limit then
    self:IncrementStackCount()
    ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
  end

end



function modifier_bristleback_viscous_nasal_goo_custom:DeclareFunctions()
return {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end


function modifier_bristleback_viscous_nasal_goo_custom:GetModifierMoveSpeedBonus_Percentage()
    return ((self.base_move_slow + (self.move_slow_per_stack * self:GetStackCount())) * (-1))
end

function modifier_bristleback_viscous_nasal_goo_custom:GetModifierPhysicalArmorBonus()
    return ((self.base_armor + (self.armor_per_stack * self:GetStackCount())) * (-1))
end

function modifier_bristleback_viscous_nasal_goo_custom:OnDestroy()
if not IsServer() then return end
if self:GetStackCount() < self:GetAbility().dispel_max then return end
if self:GetParent():IsMagicImmune() then return end
if not self:GetCaster():HasModifier("modifier_bristle_goo_status") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bashed", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().dispel_stun})


local duration = self:GetAbility():GetSpecialValueFor("goo_duration")

if self:GetCaster():HasModifier("modifier_bristle_goo_stack") then 
  duration = duration + self:GetAbility().stacks_duration
end

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bristleback_viscous_nasal_goo_custom", {duration = duration * (1 - self:GetParent():GetStatusResistance())})


self:GetParent():EmitSound("Hero_Bristleback.ViscousGoo.Target")

end


modifier_bristleback_viscous_nasal_goo_tracker = class({})
function modifier_bristleback_viscous_nasal_goo_tracker:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_tracker:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}

end

function modifier_bristleback_viscous_nasal_goo_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.unit:IsBuilding() then return end

if not self:GetParent():HasModifier("modifier_bristle_goo_legendary") then return end
if not params.unit:HasModifier("modifier_bristleback_viscous_nasal_goo_custom") then return end
if self:GetParent():HasModifier("modifier_bristleback_viscous_nasal_goo_no_stun") then return end

if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end


local chance = params.unit:FindModifierByName("modifier_bristleback_viscous_nasal_goo_custom"):GetStackCount()*self:GetAbility().legendary_chance
local random = RollPseudoRandomPercentage(chance,112,self:GetParent())
if not  random  then return end 


self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bristleback_viscous_nasal_goo_no_stun", {})

local damage = params.unit:GetMaxHealth()*self:GetAbility().legendary_damage

if params.unit:IsCreep() then 
  damage = damage*self:GetAbility().legendary_creeps
end

ApplyDamage({ victim = params.unit, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, attacker = self:GetCaster(), ability= self:GetAbility() })

SendOverheadEventMessage(params.unit, 4, params.unit, damage, nil)

local stun = 0.1
if params.unit:IsHero() then 
  stun = self:GetAbility().legendary_stun*(1 - params.unit:GetStatusResistance())
end

params.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = stun})
params.unit:EmitSound("BB.Goo_stun")     


self:GetCaster():RemoveModifierByName("modifier_bristleback_viscous_nasal_goo_no_stun")
end










function modifier_bristleback_viscous_nasal_goo_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_bristle_goo_proc") then return end

local target = nil

if params.attacker == self:GetParent() then 
  target = params.target
else
  if params.target == self:GetParent() then 
    target = params.attacker
  end
end

if target == nil then return end
if target:IsBuilding() then return end
if target:IsMagicImmune() then return end


local chance = self:GetAbility().proc_init + self:GetAbility().proc_inc*self:GetCaster():GetUpgradeStack("modifier_bristle_goo_proc")
local random = RollPseudoRandomPercentage(chance,72,self:GetCaster())


if not random then return end

local duration = self:GetAbility():GetSpecialValueFor("goo_duration")
if target:IsCreep() then 
    duration = self:GetAbility():GetSpecialValueFor("goo_duration_creep")
end

target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_viscous_nasal_goo_custom", {duration = duration * (1 - target:GetStatusResistance())})
    
self:GetParent():EmitSound("Hero_Bristleback.ViscousGoo.Cast")
target:EmitSound("Hero_Bristleback.ViscousGoo.Target")

end




modifier_bristleback_viscous_nasal_goo_damage = class({})

function modifier_bristleback_viscous_nasal_goo_damage:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_damage:IsPurgable() return true end
function modifier_bristleback_viscous_nasal_goo_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_bristleback_viscous_nasal_goo_damage:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(1)
end

function modifier_bristleback_viscous_nasal_goo_damage:OnIntervalThink()
if not IsServer() then return end
  local damage = self:GetAbility().damage_amount
                  
  ApplyDamage( {
        victim      = self:GetParent(),
        damage      = damage,
        damage_type   = DAMAGE_TYPE_PHYSICAL,
        damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
        attacker    = self:GetCaster(),
        ability     = self:GetAbility()
       }
       ) 
end






modifier_bristleback_viscous_nasal_goo_stack = class({})
function modifier_bristleback_viscous_nasal_goo_stack:IsHidden() 
return self:GetParent():HasModifier("modifier_bristleback_viscous_nasal_goo_stack_cd") end
function modifier_bristleback_viscous_nasal_goo_stack:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_stack:GetTexture() return "buffs/goo_stack" end
function modifier_bristleback_viscous_nasal_goo_stack:RemoveOnDeath() return false end

modifier_bristleback_viscous_nasal_goo_stack_cd = class({})
function modifier_bristleback_viscous_nasal_goo_stack_cd:IsHidden() return false end
function modifier_bristleback_viscous_nasal_goo_stack_cd:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_stack_cd:GetTexture() return "buffs/goo_stack" end
function modifier_bristleback_viscous_nasal_goo_stack_cd:IsDebuff() return true end
function modifier_bristleback_viscous_nasal_goo_stack_cd:RemoveOnDeath() return false end
function modifier_bristleback_viscous_nasal_goo_stack_cd:OnCreated(table)
if not IsServer() then return end
  self.RemoveForDuel = true
end


modifier_bristleback_viscous_nasal_goo_ground_tracker = class({})
function modifier_bristleback_viscous_nasal_goo_ground_tracker:IsHidden() return false end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:IsAura() return true end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetAuraDuration() return 0.1 end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetAuraRadius() return self.radius
 end

function modifier_bristleback_viscous_nasal_goo_ground_tracker:OnCreated(table)

self.radius = self:GetCaster():GetTalentValue("modifier_bristle_goo_damage", "radius")

if not IsServer() then return end
end


function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_bristleback_viscous_nasal_goo_ground_tracker:GetModifierAura() return "modifier_bristleback_viscous_nasal_goo_ground_poison" end


modifier_bristleback_viscous_nasal_goo_ground_poison = class({})
function modifier_bristleback_viscous_nasal_goo_ground_poison:IsHidden() return false end
function modifier_bristleback_viscous_nasal_goo_ground_poison:IsPurgable() return false end
function modifier_bristleback_viscous_nasal_goo_ground_poison:GetTexture() return "buffs/goo_ground" end
function modifier_bristleback_viscous_nasal_goo_ground_poison:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_bristleback_viscous_nasal_goo_ground_poison:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_bristleback_viscous_nasal_goo_ground_poison:OnTooltip()
return self.damage
end


function modifier_bristleback_viscous_nasal_goo_ground_poison:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_bristleback_viscous_nasal_goo_ground_poison:GetStatusEffectName()
  return "particles/status_fx/status_effect_goo.vpcf"
end


function modifier_bristleback_viscous_nasal_goo_ground_poison:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_bristle_goo_damage", "damage")
self.armor = self:GetCaster():GetTalentValue("modifier_bristle_goo_damage", "armor")

if not IsServer() then return end

self:StartIntervalThink(self:GetCaster():GetTalentValue("modifier_bristle_goo_damage", "interval"))
self:OnIntervalThink()
end

function modifier_bristleback_viscous_nasal_goo_ground_poison:OnIntervalThink()
if not IsServer() then return end
ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL,damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, ability = self:GetAbility()})

end



modifier_bristleback_viscous_nasal_goo_no_stun = class({})
function modifier_bristleback_viscous_nasal_goo_no_stun:IsHidden() return true end
function modifier_bristleback_viscous_nasal_goo_no_stun:IsPurgable() return false end