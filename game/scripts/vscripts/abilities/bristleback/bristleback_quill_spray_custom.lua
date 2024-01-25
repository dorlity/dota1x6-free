LinkLuaModifier("modifier_custom_bristleback_quillspray_thinker", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_count", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_tracker", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_legendary", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_bristleback_quill_spray_proc_slow", "abilities/bristleback/bristleback_quill_spray_custom", LUA_MODIFIER_MOTION_NONE)



bristleback_quill_spray_custom              = class({})






function bristleback_quill_spray_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_quill_spray_hit_creep.vpcf", context )
PrecacheResource( "particle", "particles/lc_lowhp.vpcf", context )
PrecacheResource( "particle", "particles/brist_proc.vpcf", context )

end


function bristleback_quill_spray_custom:GetIntrinsicModifierName()  return "modifier_custom_bristleback_quill_spray_tracker" end




function bristleback_quill_spray_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_bristle_spray_legendary") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end




function bristleback_quill_spray_custom:GetManaCost(level)

local bonus = 0

if self:GetCaster():HasModifier("modifier_bristle_spray_damage") then 
  bonus = self:GetCaster():GetTalentValue("modifier_bristle_spray_damage", "mana")
end 

return self.BaseClass.GetManaCost(self,level) + bonus
end




function bristleback_quill_spray_custom:GetCastRange(vLocation, hTarget)

local bonus = 0
if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
  bonus = self:GetCaster():GetTalentValue("modifier_bristle_spray_reduce", "radius")
end

return self:GetSpecialValueFor("radius") + bonus
end


function bristleback_quill_spray_custom:GetCooldown(iLevel)
local cd = self.BaseClass.GetCooldown(self, iLevel)

if self:GetCaster():HasModifier("modifier_custom_bristleback_quill_spray_legendary") then 
 cd = cd  + self:GetCaster():GetUpgradeStack("modifier_custom_bristleback_quill_spray_legendary")*self:GetCaster():GetTalentValue("modifier_bristle_spray_legendary", "cd")
end 

if self:GetCaster():HasModifier("modifier_bristle_spray_lowhp") and self:GetCaster():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "health") then 
  cd = cd * (1 + self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "cd")/100)
end

return cd

end






function bristleback_quill_spray_custom:OnSpellStart()
self:MakeSpray(nil)

if not self:GetCaster():HasModifier("modifier_bristle_spray_legendary") then return end

if self:GetAutoCastState() == true then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_bristleback_quill_spray_legendary", {duration = self:GetCaster():GetTalentValue("modifier_bristle_spray_legendary", "duration")})
else 
  self:GetCaster():RemoveModifierByName("modifier_custom_bristleback_quill_spray_legendary")
end


end 



function bristleback_quill_spray_custom:GetHealthCost(level)

if self:GetCaster():HasModifier("modifier_bristle_spray_legendary") and self:GetCaster():HasModifier("modifier_custom_bristleback_quill_spray_legendary") then 
  return self:GetCaster():GetUpgradeStack("modifier_custom_bristleback_quill_spray_legendary")*self:GetCaster():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_bristle_spray_legendary", "cost")/100
end

end




function bristleback_quill_spray_custom:MakeSpray(location, is_passive, is_scepter)

self.caster = self:GetCaster()
self.radius         = self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_bristle_spray_reduce", "radius")
self.projectile_speed   = self:GetSpecialValueFor("projectile_speed")

self.duration       = self.radius / self.projectile_speed
self.location = self:GetCaster():GetAbsOrigin()

if location ~= nil then  
  self.location = location
end

if not IsServer() then return end

if location == nil then 
  self.caster:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
  self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
end


local cone = 0

if is_scepter and is_scepter == true then 
  cone = 1
end 

local passive = 0
if is_passive and is_passive == true then 
  passive = 1
end 

self.caster:AddNewModifier(self.caster, self, "modifier_custom_bristleback_quillspray_thinker", {duration = self.duration, passive = passive,  cone = cone})

self.caster:EmitSound("Hero_Bristleback.QuillSpray.Cast")

end



modifier_custom_bristleback_quillspray_thinker = class({})

function modifier_custom_bristleback_quillspray_thinker:IsHidden() return true end
function modifier_custom_bristleback_quillspray_thinker:IsPurgable() return false end
function modifier_custom_bristleback_quillspray_thinker:RemoveOnDeath() return false end
function modifier_custom_bristleback_quillspray_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_custom_bristleback_quillspray_thinker:OnCreated(table)
self.ability  = self:GetAbility()
self.caster   = self:GetCaster()
self.parent   = self:GetParent()
self.back = self:GetCaster():FindAbilityByName("bristleback_bristleback_custom")

self.radius         = self.ability:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_bristle_spray_reduce", "radius")
self.quill_base_damage    = self.ability:GetSpecialValueFor("quill_base_damage")
self.quill_stack_damage   = self.ability:GetSpecialValueFor("quill_stack_damage") + self:GetCaster():GetTalentValue("modifier_bristle_spray_damage", "damage")

if self.back then 
  self.angle = self.back:GetSpecialValueFor("activation_angle")
end 

self.proc_chance = self:GetCaster():GetTalentValue("modifier_bristle_spray_max", "chance")
self.slow_duration = self:GetCaster():GetTalentValue("modifier_bristle_spray_max", "duration")

self.quill_stack_duration = self.ability:GetSpecialValueFor("quill_stack_duration") + self:GetCaster():GetTalentValue("modifier_bristle_spray_reduce", "duration")
self.max_damage       = self.ability:GetSpecialValueFor("max_damage") + self:GetCaster():GetTalentValue("modifier_bristle_spray_double", "damage")

self.armor_duration = self:GetCaster():GetTalentValue("modifier_bristle_back_return", "duration")

if not IsServer() then return end

self.cast_point = self.parent:GetAbsOrigin()

self.should_heal = false

self.passive = table.passive
self.cone = table.cone

if self:GetCaster():HasModifier("modifier_bristle_spray_heal") then 
  self.should_heal = true
  self.heal = self:GetCaster():GetTalentValue("modifier_bristle_spray_heal", "heal")*(self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())/100

  if self.passive == 1 then 
    self.heal = self.heal/self:GetCaster():GetTalentValue("modifier_bristle_spray_heal", "passive")
  end 

end

self.proc = false
if self:GetCaster():HasModifier("modifier_bristle_spray_max") and RollPseudoRandomPercentage(self.proc_chance,7001,self:GetCaster()) then 
  self.proc = true
end


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

local origin = self.cast_point
local cast_direction = self.direction
cast_direction.z = 0
local cast_angle = VectorToAngles( cast_direction ).y

local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), origin, nil, self.radius * radius_pct, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

for _, enemy in pairs(enemies) do

  local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
  local enemy_angle = VectorToAngles( enemy_direction ).y
  local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )


  if angle_diff <= self.angle or self.cone == 0 then

    if not self.hit_enemies[enemy] then 

      self.hit_enemies[enemy] = true

      if self.should_heal == true then 
        self.should_heal = false
        self:GetCaster():GenericHeal(self.heal , self:GetAbility())
      end 

      local quill_spray_stacks  = 0
      local quill_spray_modifier  = enemy:FindModifierByName("modifier_custom_bristleback_quill_spray")
      
      if quill_spray_modifier then
        quill_spray_stacks   = quill_spray_modifier:GetStackCount() 
      end


      local damageTable = {victim = enemy, damage = math.min(self.quill_base_damage + (self.quill_stack_damage * quill_spray_stacks), self.max_damage), damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK, attacker = self.caster, ability = self.ability}        
      ApplyDamage(damageTable)
      
      if self.proc then 
        enemy:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_bristleback_quill_spray_proc_slow", {duration = self.slow_duration*(1 - enemy:GetStatusResistance())})
      end

      local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
      ParticleManager:SetParticleControlEnt(particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
      ParticleManager:ReleaseParticleIndex(particle)
      
      enemy:EmitSound("Hero_Bristleback.QuillSpray.Target")

      enemy:AddNewModifier(self.caster, self.ability, "modifier_custom_bristleback_quill_spray", {duration = self.quill_stack_duration * (1 - enemy:GetStatusResistance())})
      enemy:AddNewModifier(self.caster, self.ability, "modifier_custom_bristleback_quill_spray_count", {duration = self.quill_stack_duration * (1 - enemy:GetStatusResistance())})
      
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

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_bristle_spray_reduce", "heal_reduce")

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
    return self:GetStackCount()*self.heal_reduce
end
end

function modifier_custom_bristleback_quill_spray:GetModifierHealAmplify_PercentageTarget() 
if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
    return self:GetStackCount()*self.heal_reduce
end
end


function modifier_custom_bristleback_quill_spray:GetModifierHPRegenAmplify_Percentage() 
if self:GetCaster():HasModifier("modifier_bristle_spray_reduce") then 
    return self:GetStackCount()*self.heal_reduce
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
function modifier_custom_bristleback_quill_spray_tracker:IsHidden()
if self:GetCaster():HasModifier("modifier_bristle_spray_lowhp") and self:GetParent():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "health") then 
  return false 
else 
  return true
end

end



function modifier_custom_bristleback_quill_spray_tracker:GetTexture() return "buffs/spray_lowhp" end
function modifier_custom_bristleback_quill_spray_tracker:RemoveOnDeath() return false end

function modifier_custom_bristleback_quill_spray_tracker:OnCreated(table)

self.health = self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "health", true)
self.heal = self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "heal", true)
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_bristle_spray_lowhp", "heal_creeps", true)

self.parent = self:GetParent()

if not IsServer() then return end
self:StartIntervalThink(1)
 
end

function modifier_custom_bristleback_quill_spray_tracker:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasModifier("modifier_bristle_spray_lowhp") then return end


if not self.particle and self:GetParent():GetHealthPercent() <= self.health then 

  self:GetParent():EmitSound("Lc.Moment_Lowhp")
  self.particle = ParticleManager:CreateParticle( "particles/lc_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
  ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
  ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() )  
end


if self.particle and self:GetParent():GetHealthPercent() > self.health then

  ParticleManager:DestroyParticle(self.particle, false)
  ParticleManager:ReleaseParticleIndex(self.particle)
  self.particle = nil
end

self:StartIntervalThink(0.1)
end





function modifier_custom_bristleback_quill_spray_tracker:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end

function modifier_custom_bristleback_quill_spray_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_bristle_spray_double") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if not RollPseudoRandomPercentage(self.parent:GetTalentValue("modifier_bristle_spray_double", "chance") ,7031, self.parent) then return end


Timers:CreateTimer(0.15, function()
  self:GetAbility():MakeSpray(self.parent:GetAbsOrigin())
end)

end


function modifier_custom_bristleback_quill_spray_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self.parent:HasModifier("modifier_bristle_spray_lowhp") then return end
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












modifier_custom_bristleback_quill_spray_legendary = class({})

function modifier_custom_bristleback_quill_spray_legendary:IsHidden() return true end
function modifier_custom_bristleback_quill_spray_legendary:IsPurgable() return false end
function modifier_custom_bristleback_quill_spray_legendary:GetTexture() return "buffs/quill_cdr" end
function modifier_custom_bristleback_quill_spray_legendary:OnCreated()
if not IsServer() then return end 
self.max = self:GetCaster():GetTalentValue("modifier_bristle_spray_legendary", "max")
self:SetStackCount(1)

self.time = self:GetRemainingTime()

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end 

function modifier_custom_bristleback_quill_spray_legendary:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end


function modifier_custom_bristleback_quill_spray_legendary:OnIntervalThink()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'bristle_spray_change',  {hide = 0, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})
end

function modifier_custom_bristleback_quill_spray_legendary:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'bristle_spray_change',  {hide = 1, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})
end





modifier_custom_bristleback_quill_spray_proc_slow = class({})
function modifier_custom_bristleback_quill_spray_proc_slow:IsHidden() return true end
function modifier_custom_bristleback_quill_spray_proc_slow:IsPurgable() return true end
function modifier_custom_bristleback_quill_spray_proc_slow:GetTexture() return "buffs/spray_slow" end
function modifier_custom_bristleback_quill_spray_proc_slow:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_bristle_spray_max", "slow")
if not IsServer() then return end

local damage = self:GetCaster():GetTalentValue("modifier_bristle_spray_max", "damage")

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


function modifier_custom_bristleback_quill_spray_proc_slow:OnRefresh()
self:OnCreated()
end 

function modifier_custom_bristleback_quill_spray_proc_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end
function modifier_custom_bristleback_quill_spray_proc_slow:GetModifierAttackSpeedBonus_Constant()
return self.slow
end

