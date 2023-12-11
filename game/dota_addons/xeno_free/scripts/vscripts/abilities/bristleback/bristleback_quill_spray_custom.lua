LinkLuaModifier("modifier_custom_bristleback_quillspray_thinker", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_count", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_tracker", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_legendary", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_lowhp_tracker", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_proc_slow", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)



bristleback_quill_spray_custom              = class({})

bristleback_quill_spray_custom.damage_init = 4
bristleback_quill_spray_custom.damage_inc = 4




bristleback_quill_spray_custom.double_chance = {20, 35}

bristleback_quill_spray_custom.heal = {0.01 , 0.015, 0.02}

bristleback_quill_spray_custom.reduce = -1.5
bristleback_quill_spray_custom.reduce_duration = 20




function bristleback_quill_spray_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf", context )
PrecacheResource( "particle", "particles/lc_lowhp.vpcf", context )
PrecacheResource( "particle", "particles/brist_proc.vpcf", context )

end





function bristleback_quill_spray_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_bristle_spray_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST end
 return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end


function bristleback_quill_spray_custom:GetIntrinsicModifierName()  return "modifier_custom_bristleback_quill_spray_tracker" end


function bristleback_quill_spray_custom:GetCooldown(iLevel)
local cd = 0
if self:GetCaster():HasModifier("modifier_bristle_spray_lowhp") and self:GetCaster():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "health") then 
    cd = self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "cd")
  else 
    cd = self.BaseClass.GetCooldown(self, iLevel)
end
if self:GetCaster():HasModifier("modifier_bristle_spray_legendary") and self:GetCaster():HasModifier("modifier_custom_bristleback_quill_spray_legendary") then 
  cd = cd/self:GetCaster():GetTalentValue("modifier_bristle_spray_legendary", "cd")
end
return cd

end


function bristleback_quill_spray_custom:OnSpellStart()




self:MakeSpray(nil, nil, true)

end 



function bristleback_quill_spray_custom:GetHealthCost(level)

if self:GetCaster():HasModifier("modifier_bristle_spray_legendary") and self:GetCaster():HasModifier("modifier_custom_bristleback_quill_spray_legendary") then 
  return self:GetCaster():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_bristle_spray_legendary", "cost")/100
end

end

function bristleback_quill_spray_custom:MakeSpray(location, double, active, is_cone)

self.caster = self:GetCaster()
self.radius         = self:GetSpecialValueFor("radius") 

self.projectile_speed   = self:GetSpecialValueFor("projectile_speed")

self.duration       = self.radius / self.projectile_speed


if location == nil then 
  self.location = self:GetCaster():GetAbsOrigin()
else  
  self.location = location
end

if not IsServer() then return end


if location == nil then 
  self.caster:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
  self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
end

if self:GetCaster():HasModifier("modifier_bristle_spray_heal") and (active or double) then 
  self:GetCaster():GenericHeal(self.heal[self:GetCaster():GetUpgradeStack("modifier_bristle_spray_heal")]*self:GetCaster():GetMaxHealth(), self)
end


local cone = 0

if is_cone and is_cone == true then 
  cone = 1
end 

CreateModifierThinker(self.caster, self, "modifier_custom_bristleback_quillspray_thinker", {duration = self.duration, cone = cone}, self.location, self.caster:GetTeamNumber(), false)

self.caster:EmitSound("Hero_Bristleback.QuillSpray.Cast")

if self:GetCaster():HasModifier("modifier_bristle_spray_double") and active  then 

  local chance = self.double_chance[self:GetCaster():GetUpgradeStack("modifier_bristle_spray_double")]

  local random = RollPseudoRandomPercentage(chance,75,self:GetCaster())
  if random then 
    Timers:CreateTimer(0.3, function() self:MakeSpray(location, true, false) end)
  end

end

end



modifier_custom_bristleback_quillspray_thinker = class({})


function modifier_custom_bristleback_quillspray_thinker:OnCreated(table)
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  self.back = self:GetCaster():FindAbilityByName("bristleback_bristleback_custom")

  self.radius         = self.ability:GetSpecialValueFor("radius")
  self.quill_base_damage    = self.ability:GetSpecialValueFor("quill_base_damage")
  self.quill_stack_damage   = self.ability:GetSpecialValueFor("quill_stack_damage") 

  if self.back then 
    self.angle = self.back:GetSpecialValueFor("activation_angle")
  end 

  self.proc_chance = self:GetCaster():GetTalentValue("modifier_bristle_spray_max", "chance")


  if self:GetCaster():HasModifier("modifier_bristle_spray_damage") then 
     self.quill_stack_damage = self.quill_stack_damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetCaster():GetUpgradeStack("modifier_bristle_spray_damage")
  end


  self.quill_stack_duration = self.ability:GetSpecialValueFor("quill_stack_duration")
  self.max_damage       = self.ability:GetSpecialValueFor("max_damage")
  

  if not IsServer() then return end
  

  self.cone = table.cone


  self.direction = self:GetCaster():GetForwardVector()

  if self.cone == 1 then 
    self.direction = self.direction*-1

    local particle = "particles/units/heroes/hero_bristleback/bristleback_quill_spray_conical.vpcf"

    self.particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.caster)
    self:AddParticle(self.particle, false, false, -1, false, false)
  else 

    local particle = "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf"
    self.particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, self.parent)
    self:AddParticle(self.particle, false, false, -1, false, false)
  end

  self.hit_enemies = {}
  
  self:StartIntervalThink(FrameTime())
end

function modifier_custom_bristleback_quillspray_thinker:OnIntervalThink()
if not IsServer() then return end

local radius_pct = math.min((self:GetDuration() - self:GetRemainingTime()) / self:GetDuration(), 1)



local origin = self.parent:GetAbsOrigin()
local cast_direction = self.direction
cast_direction.z = 0
local cast_angle = VectorToAngles( cast_direction ).y

local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius * radius_pct, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

local proc = false 
if self:GetCaster():HasModifier("modifier_bristle_spray_max") then 

  local random = RollPseudoRandomPercentage(self.proc_chance,78,self:GetCaster())
  if random then 
    proc = true
  end

end

for _, enemy in pairs(enemies) do

  local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
  local enemy_angle = VectorToAngles( enemy_direction ).y
  local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )


  if angle_diff <= self.angle or self.cone == 0 then

    local hit_already = false

    for _, hit_enemy in pairs(self.hit_enemies) do
      if hit_enemy == enemy then
        hit_already = true
        break
      end
    end

    if not hit_already then
      local quill_spray_stacks  = 0
      local quill_spray_modifier  = enemy:FindModifierByName("modifier_custom_bristleback_quill_spray")
      
      if quill_spray_modifier then
        quill_spray_stacks    = quill_spray_modifier:GetStackCount()
      end
    
      local damageTable = {
        victim      = enemy,
        damage      = math.min(self.quill_base_damage + (self.quill_stack_damage * quill_spray_stacks), self.max_damage),
        damage_type   = DAMAGE_TYPE_PHYSICAL,
        damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
        attacker    = self.caster,
        ability     = self.ability
      }
                  
      ApplyDamage(damageTable)
      

      if not enemy:IsMagicImmune() and proc == true and self:GetCaster():HasModifier("modifier_bristle_spray_max") then 
          enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_bristleback_quill_spray_proc_slow", {duration = self:GetCaster():GetTalentValue("modifier_bristle_spray_max", "duration")})
      end


      local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
      ParticleManager:SetParticleControlEnt(particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
      ParticleManager:ReleaseParticleIndex(particle)
      
      enemy:EmitSound("Hero_Bristleback.QuillSpray.Target")
      
      local stack_duration = self.quill_stack_duration

      if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
        stack_duration = stack_duration + self:GetAbility().reduce_duration
      end

      enemy:AddNewModifier(self.caster, self.ability, "modifier_custom_bristleback_quill_spray", {duration = stack_duration * (1 - enemy:GetStatusResistance())})
      enemy:AddNewModifier(self.caster, self.ability, "modifier_custom_bristleback_quill_spray_count", {duration = stack_duration * (1 - enemy:GetStatusResistance())})
      

      
      table.insert(self.hit_enemies, enemy)
      
      if not enemy:IsAlive() and enemy:IsRealHero() and (enemy.IsReincarnating and not enemy:IsReincarnating()) then
        self.caster:EmitSound("bristleback_bristle_quill_spray_0"..math.random(1,6))
      end
    end
  end
end



end




modifier_custom_bristleback_quill_spray = class({})


function modifier_custom_bristleback_quill_spray:IsPurgable() return false end

function modifier_custom_bristleback_quill_spray:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  
  self.RemoveForDuel = true
  
  if not IsServer() then return end
  
  self:IncrementStackCount()
  
  local particle_name = "particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit.vpcf"
  if self.parent:IsCreep() then 
    particle_name ="particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf"
  end

  self.particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.parent)


  ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  self:AddParticle(self.particle, false, false, -1, false, false)
  
  
end

function modifier_custom_bristleback_quill_spray:OnRefresh()
  if not IsServer() then return end

  self:IncrementStackCount()
  
end

function modifier_custom_bristleback_quill_spray:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
 MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end



function modifier_custom_bristleback_quill_spray:GetModifierLifestealRegenAmplify_Percentage() 
if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
    return self:GetStackCount()*self:GetAbility().reduce
else 
     return
end

end

function modifier_custom_bristleback_quill_spray:GetModifierHealAmplify_PercentageTarget() 
if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
    return self:GetStackCount()*self:GetAbility().reduce
else 
     return
end

end

function modifier_custom_bristleback_quill_spray:GetModifierHPRegenAmplify_Percentage() 

if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
    return self:GetStackCount()*self:GetAbility().reduce
else 
     return
end

end




modifier_custom_bristleback_quill_spray_count = class({})

function modifier_custom_bristleback_quill_spray_count:IsHidden() return true end
function modifier_custom_bristleback_quill_spray_count:IsPurgable() return false end
function modifier_custom_bristleback_quill_spray_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_bristleback_quill_spray_count:OnCreated(table)
if not IsServer() then return end
  self.RemoveForDuel = true
end

function modifier_custom_bristleback_quill_spray_count:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_custom_bristleback_quill_spray")

if mod then 
  mod:DecrementStackCount()
end

end



modifier_custom_bristleback_quill_spray_tracker = class({})
function modifier_custom_bristleback_quill_spray_tracker:IsHidden() return true end
function modifier_custom_bristleback_quill_spray_tracker:IsPurgable() return false end










modifier_custom_bristleback_quill_spray_legendary = class({})

function modifier_custom_bristleback_quill_spray_legendary:IsHidden() return false end
function modifier_custom_bristleback_quill_spray_legendary:IsPurgable() return false end
function modifier_custom_bristleback_quill_spray_legendary:GetTexture() return "buffs/quill_cdr" end
function modifier_custom_bristleback_quill_spray_legendary:RemoveOnDeath() return false end



modifier_custom_bristleback_quill_spray_lowhp_tracker = class({})

function modifier_custom_bristleback_quill_spray_lowhp_tracker:IsHidden()
if self:GetParent():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "health") then 
  return false 
else 
  return true
end

end



function modifier_custom_bristleback_quill_spray_lowhp_tracker:GetTexture() return "buffs/spray_lowhp" end
function modifier_custom_bristleback_quill_spray_lowhp_tracker:IsPurgable() return false end
function modifier_custom_bristleback_quill_spray_lowhp_tracker:RemoveOnDeath() return false end

function modifier_custom_bristleback_quill_spray_lowhp_tracker:OnCreated(table)

self.health = self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "health")
self.heal = self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "heal")
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "heal_creeps")

if not IsServer() then return end
self:StartIntervalThink(0.1)
self.flag = false 
end

function modifier_custom_bristleback_quill_spray_lowhp_tracker:OnIntervalThink()
if not IsServer() then return end
if self.flag == false then 
  if self:GetParent():GetHealthPercent() <= self.health then 
    self.flag = true 
    self:GetParent():EmitSound("Lc.Moment_Lowhp")
    self.particle = ParticleManager:CreateParticle( "particles/lc_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
     ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
       ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
     ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() )
    
  end
end

if self.flag == true then
  if self:GetParent():GetHealthPercent() > self.health then
    self.flag = false 
    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)
  end
end

end




function modifier_custom_bristleback_quill_spray_lowhp_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_custom_bristleback_quill_spray_lowhp_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():GetHealthPercent() > self.health then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal/100
if params.unit:IsCreep() then 
  heal = heal /self.heal_creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end 




modifier_custom_bristleback_quill_spray_proc_slow = class({})
function modifier_custom_bristleback_quill_spray_proc_slow:IsHidden() return true end
function modifier_custom_bristleback_quill_spray_proc_slow:IsPurgable() return true end
function modifier_custom_bristleback_quill_spray_proc_slow:GetTexture() return "buffs/spray_slow" end
function modifier_custom_bristleback_quill_spray_proc_slow:OnCreated(table)
if not IsServer() then return end

local damage = self:GetCaster():GetTalentValue("modifier_bristle_spray_max", "damage")
self.slow = self:GetCaster():GetTalentValue("modifier_bristle_spray_max", "slow")

self:GetParent():EmitSound("BB.Quill_proc")

local particle = ParticleManager:CreateParticle("particles/brist_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:ReleaseParticleIndex(particle)


local damageTable = 
{
    victim      = self:GetParent(),
    damage      = damage,
    damage_type   = DAMAGE_TYPE_MAGICAL,
    damage_flags  = DOTA_DAMAGE_FLAG_NONE,
    attacker    = self:GetCaster(),
    ability     = self:GetAbility()
}
                  
ApplyDamage(damageTable)
      

end

function modifier_custom_bristleback_quill_spray_proc_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_bristleback_quill_spray_proc_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end