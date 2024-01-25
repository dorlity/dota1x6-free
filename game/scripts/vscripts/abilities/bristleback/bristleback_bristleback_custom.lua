LinkLuaModifier("modifier_bristleback_bristleback_custom_custom", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_legendary_active", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_reflect_cd", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_reflect_ready", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_str", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_str_count", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_taunt_cd", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_taunt_attack", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_make_spray", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_scepter", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_armor", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_shield", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_custom_timer", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)



bristleback_bristleback_custom  = class({})




function bristleback_bristleback_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_defense_matrix_ball_sphere_rings.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", context )
PrecacheResource( "particle", "particles/bristle_back_buff_.vpcf", context )
PrecacheResource( "particle", "particles/back_stack_brist.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )


end




function bristleback_bristleback_custom:IsStealable()       return false end
function bristleback_bristleback_custom:ResetToggleOnRespawn()  return true end





function bristleback_bristleback_custom:GetBehavior()
if self:GetCaster():HasScepter() then
    return DOTA_ABILITY_BEHAVIOR_POINT 
end

return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

function bristleback_bristleback_custom:GetCooldown(iLevel)
if self:GetCaster():HasScepter() then
 return self:GetSpecialValueFor("activation_cooldown")
end  

end

function bristleback_bristleback_custom:GetManaCost(iLevel)
if self:GetCaster():HasScepter() then
 return self:GetSpecialValueFor("activation_manacost")
end  

end 


function bristleback_bristleback_custom:OnSpellStart()
local caster = self:GetCaster()


caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
caster:EmitSound("Hero_Bristleback.Bristleback.Active")

local point = self:GetCursorPosition()
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bristleback_active_conical_quill_spray", {x = point.x, y = point.y, z = point.z})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bristleback_bristleback_custom_scepter", {})


end



function bristleback_bristleback_custom:IsFacingBack(attacker)


local forwardVector     = self:GetCaster():GetForwardVector()
local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
        
local reverseEnemyVector  = (self:GetCaster():GetAbsOrigin() - attacker:GetAbsOrigin()):Normalized()
local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

local back_angle         = self:GetSpecialValueFor("back_angle")

local difference = math.abs(forwardAngle - reverseEnemyAngle)

if (difference <= (back_angle / 1)) or (difference >= (360 - (back_angle / 1)))  or self:GetCaster():HasModifier("modifier_bristleback_bristleback_custom_legendary_active")  then
  return true
end

return false
end



function bristleback_bristleback_custom:IncStacks(add_stack)

local stack = add_stack
local mod = self:GetCaster():FindModifierByName("modifier_bristleback_bristleback_custom_custom")
  
  
local quill_release_threshold  = self:GetSpecialValueFor("quill_release_threshold") + self:GetCaster():GetTalentValue("modifier_bristle_back_spray", "damage")

if self:GetCaster():HasModifier("modifier_bristleback_bristleback_custom_legendary_active") then 
  quill_release_threshold = quill_release_threshold + self:GetCaster():GetTalentValue("modifier_bristle_back_legendary", "spray_damage")
end


if not mod then return end

while stack > 0 do 
  mod:SetStackCount(mod:GetStackCount() + stack)

  if mod:GetStackCount() < quill_release_threshold then 
    stack = 0
  else 
    stack =  mod:GetStackCount() - quill_release_threshold
    mod:SetStackCount(0)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bristleback_bristleback_custom_make_spray", {})
  end
end

end




function bristleback_bristleback_custom:GetIntrinsicModifierName()
  return "modifier_bristleback_bristleback_custom_custom"
end


modifier_bristleback_bristleback_custom_custom = class({})

function modifier_bristleback_bristleback_custom_custom:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_custom:IsHidden() return true end


function modifier_bristleback_bristleback_custom_custom:OnCreated()
self.ability  = self:GetAbility()
self.caster   = self:GetCaster()
self.parent   = self:GetParent()

self.front_damage_reduction   = 0

self.side_angle         = self.ability:GetSpecialValueFor("side_angle")
self.back_angle         = self.ability:GetSpecialValueFor("back_angle")

self.reflect_cd = self:GetCaster():GetTalentValue("modifier_bristle_back_reflect", "cd", true)
self.reflect_duration = self:GetCaster():GetTalentValue("modifier_bristle_back_reflect", "duration", true)

self.damage_interval = self:GetCaster():GetTalentValue("modifier_bristle_back_damage", "interval", true)
self.damage_radius = self:GetCaster():GetTalentValue("modifier_bristle_back_damage", "radius", true)

self.armor_duration = self:GetCaster():GetTalentValue("modifier_bristle_back_return", "duration", true)
self.armor_radius = self:GetCaster():GetTalentValue("modifier_bristle_back_return", "radius", true)

self.shield_timer = self:GetCaster():GetTalentValue("modifier_bristle_back_heal", "timer", true)

self.interval = 0.1
self.count = 0

self:StartIntervalThink(self.interval)
end





function modifier_bristleback_bristleback_custom_custom:OnIntervalThink()
if not IsServer() then return end 
if not self:GetParent():IsAlive() then return end

if self.caster:HasModifier("modifier_bristle_back_heal") then 
  if self.caster:IsAlive() and not self.caster:HasModifier("modifier_bristleback_bristleback_custom_shield") and not self.caster:HasModifier("modifier_bristleback_bristleback_custom_timer") then 
    self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_bristleback_bristleback_custom_timer", {duration = self.shield_timer})
  end
end 


if not self.caster:HasModifier("modifier_bristle_back_damage") and not self.caster:HasModifier("modifier_bristle_back_return") then return end 

self.count = self.count + self.interval
if self.count < self.damage_interval then 
  return
end 


self.count = 0

local damage = self.caster:GetStrength()*self.caster:GetTalentValue("modifier_bristle_back_damage", "damage")/100

for _,target in pairs(self.caster:FindTargets(self.armor_radius)) do 

  if self.caster:HasModifier("modifier_bristle_back_return") then 
    target:AddNewModifier(self.caster, self:GetAbility(), "modifier_bristleback_bristleback_custom_armor", {duration = self.armor_duration + 2*FrameTime()})
  end 

  if (target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() <= self.damage_radius and self.caster:HasModifier("modifier_bristle_back_damage") then 

    ApplyDamage({victim = target, attacker = self.caster, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})

    target:EmitSound("BB.Back_damage")

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)

    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_quill_spray_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(particle2, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle2)
  end
end 


end



function modifier_bristleback_bristleback_custom_custom:OnRefresh()
  self:OnCreated()
end

function modifier_bristleback_bristleback_custom_custom:DeclareFunctions()
return {
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_ABSORB_SPELL
}
end

function modifier_bristleback_bristleback_custom_custom:GetAbsorbSpell(params)
if not IsServer() then return end
if params.ability and params.ability:GetCaster() == self:GetParent() then return end
if not self:GetParent():HasModifier("modifier_bristle_back_reflect") then return end


local mod = self.caster:FindModifierByName("modifier_bristleback_bristleback_custom_reflect_ready")

if mod and not mod.blocked then 

  mod.blocked = true

  local particle = ParticleManager:CreateParticle("particles/pangolier/linken_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle)

  if mod.particle then 
    ParticleManager:DestroyParticle(mod.particle, true)
    ParticleManager:ReleaseParticleIndex(mod.particle)
  end 

  self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

  return 1 
end 


if self:GetParent():PassivesDisabled() and not self:GetParent():HasModifier("modifier_bristleback_bristleback_custom_scepter") then return end


if self:GetAbility():IsFacingBack(params.ability:GetCaster()) and not self:GetParent():HasModifier("modifier_bristleback_bristleback_custom_reflect_cd") then 
      
    self:GetCaster():EmitSound("BB.Back_reflect")
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_custom_reflect_ready", {duration = self.reflect_duration})
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_custom_reflect_cd", {duration = self.reflect_cd})

end

return 0
end



function modifier_bristleback_bristleback_custom_custom:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end 

if self.parent:PassivesDisabled() and not self:GetParent():HasModifier("modifier_bristleback_bristleback_custom_scepter") then return end 
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end 
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return  end

local forwardVector     = self.caster:GetForwardVector()
local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
    
local reverseEnemyVector  = (self.caster:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

local difference = math.abs(forwardAngle - reverseEnemyAngle)

self.front_damage_reduction   = 0

self.side_damage_reduction    = self.ability:GetSpecialValueFor("side_damage_reduction") + self.parent:GetTalentValue("modifier_bristle_back_spray", "damage_reduce")
self.back_damage_reduction    = self.ability:GetSpecialValueFor("back_damage_reduction") + self.parent:GetTalentValue("modifier_bristle_back_spray", "damage_reduce")


if (difference <= (self.back_angle / 1)) or (difference >= (360 - (self.back_angle / 1))) or self:GetParent():HasModifier("modifier_bristleback_bristleback_custom_legendary_active") then

  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
  ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle)

  local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle2)
  
  self.parent:EmitSound("Hero_Bristleback.Bristleback")

  if self:GetParent():GetQuest() == "Brist.Quest_7" and params.attacker:IsRealHero() then 
    self:GetParent():UpdateQuest(math.floor(params.original_damage))
  end


  return self.back_damage_reduction * (-1)


elseif (difference <= (self.side_angle)) or (difference >= (360 - (self.side_angle))) then 

  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
  ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle)


  return self.side_damage_reduction * (-1)
else


  if self.caster:HasModifier("modifier_bristle_back_heal") and not self.caster:HasModifier("modifier_bristleback_bristleback_custom_shield") then 
    self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_bristleback_bristleback_custom_timer", {duration = self.shield_timer})
  end

  return self.front_damage_reduction * (-1)
end


end




function modifier_bristleback_bristleback_custom_custom:OnTakeDamage( params )
if params.attacker == nil then return end
if params.unit ~= self.parent then return end
if self.parent:PassivesDisabled() and not self:GetParent():HasModifier("modifier_bristleback_bristleback_custom_scepter") then return end  
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end 
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS  then return end 
if not self.parent:HasAbility("bristleback_quill_spray_custom") then return end 
if not self.parent:FindAbilityByName("bristleback_quill_spray_custom"):IsTrained() then return end



if self:GetAbility():IsFacingBack(params.attacker)  then
      
  self:GetAbility():IncStacks(params.damage)

end

end













modifier_bristleback_bristleback_custom_legendary_active = class({})


function modifier_bristleback_bristleback_custom_legendary_active:IsHidden() return false end
function modifier_bristleback_bristleback_custom_legendary_active:IsPurgable() return false end
--function modifier_bristleback_bristleback_custom_legendary_active:CheckState() return {[MODIFIER_STATE_DISARMED] = true} end
function modifier_bristleback_bristleback_custom_legendary_active:GetTexture() return "buffs/Blade_fury_shield" end




function modifier_bristleback_bristleback_custom_legendary_active:OnCreated(table)
if not IsServer() then return end
self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "Hero_Pangolier.TailThump.Shield"
self.buff_particles = {}

self:GetCaster():EmitSound( self.sound)


self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)

end




modifier_bristleback_bristleback_custom_reflect_ready = class({})
function modifier_bristleback_bristleback_custom_reflect_ready:IsHidden() return false end
function modifier_bristleback_bristleback_custom_reflect_ready:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_reflect_ready:GetTexture() return "buffs/back_reflect" end
function modifier_bristleback_bristleback_custom_reflect_ready:OnCreated()

self.heal = self:GetCaster():GetTalentValue("modifier_bristle_back_reflect", "heal")/self:GetCaster():GetTalentValue("modifier_bristle_back_reflect", "duration")

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/pangolier/linken_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
end


function modifier_bristleback_bristleback_custom_reflect_ready:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_bristleback_bristleback_custom_reflect_ready:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_bristleback_bristleback_custom_reflect_ready:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end



function modifier_bristleback_bristleback_custom_reflect_ready:GetModifierHealthRegenPercentage()
return self.heal
end









modifier_bristleback_bristleback_custom_reflect_cd = class({})
function modifier_bristleback_bristleback_custom_reflect_cd:IsHidden() return false end
function modifier_bristleback_bristleback_custom_reflect_cd:GetTexture() return "buffs/back_reflect" end
function modifier_bristleback_bristleback_custom_reflect_cd:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_reflect_cd:RemoveOnDeath() return false end
function modifier_bristleback_bristleback_custom_reflect_cd:IsDebuff() return true end
function modifier_bristleback_bristleback_custom_reflect_cd:OnCreated(table)
self.RemoveForDuel = true 
end



modifier_bristleback_bristleback_custom_str_count = class({})
function modifier_bristleback_bristleback_custom_str_count:IsHidden() return false end
function modifier_bristleback_bristleback_custom_str_count:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_str_count:GetTexture() return "buffs/back_ground" end
function modifier_bristleback_bristleback_custom_str_count:GetEffectName() return "particles/bristle_back_buff_.vpcf" end


function modifier_bristleback_bristleback_custom_str_count:OnCreated(table)

self.str = self:GetCaster():GetTalentValue("modifier_bristle_back_damage", "str")

if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end
function modifier_bristleback_bristleback_custom_str_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_bristleback_bristleback_custom_str_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}

end

function modifier_bristleback_bristleback_custom_str_count:GetModifierBonusStats_Strength()
  return self:GetStackCount()*self.str
end





modifier_bristleback_bristleback_custom_str = class({})
function modifier_bristleback_bristleback_custom_str:IsHidden() return true end
function modifier_bristleback_bristleback_custom_str:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_str:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_bristleback_bristleback_custom_str:OnCreated(table)
self.RemoveForDuel = true
end

function modifier_bristleback_bristleback_custom_str:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_bristleback_bristleback_custom_str_count")
if not mod then return end
mod:DecrementStackCount()

if mod:GetStackCount() == 0 then 
  mod:Destroy()
end
end








modifier_bristleback_bristleback_custom_taunt_attack = class({})
function modifier_bristleback_bristleback_custom_taunt_attack:IsHidden() return true end
function modifier_bristleback_bristleback_custom_taunt_attack:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_taunt_attack:GetTexture() return "buffs/back_taunt" end

function modifier_bristleback_bristleback_custom_taunt_attack:OnCreated(table)

self.taunt_duration = self:GetCaster():GetTalentValue("modifier_bristle_back_ground", "taunt", true)
self.range = self:GetCaster():GetTalentValue("modifier_bristle_back_ground", "range", true)
self.taunt_cd = self:GetCaster():GetTalentValue("modifier_bristle_back_ground", "cd", true)

if not IsServer() then return end
self:GetParent():EmitSound("BB.Taunt_ready")
self.parent = self:GetParent()
end

function modifier_bristleback_bristleback_custom_taunt_attack:GetModifierAttackRangeBonus()
return self.range
end


function modifier_bristleback_bristleback_custom_taunt_attack:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end


function modifier_bristleback_bristleback_custom_taunt_attack:OnAttackLanded(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if self.parent ~= params.attacker then return end
if params.no_attack_cooldown then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end 

self.parent:EmitSound("Item.BM_heal")
params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_generic_taunt", {duration = (1 -params.target:GetStatusResistance())*self.taunt_duration})



local mod = self:GetParent():FindModifierByName('modifier_bristleback_bristleback_custom_taunt_cd')
if mod then 
  mod:SetStackCount(self.taunt_cd)
end 

self:Destroy()

end






modifier_bristleback_bristleback_custom_taunt_cd = class({})
function modifier_bristleback_bristleback_custom_taunt_cd:IsHidden() return true end
function modifier_bristleback_bristleback_custom_taunt_cd:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_taunt_cd:IsDebuff() return true end
function modifier_bristleback_bristleback_custom_taunt_cd:RemoveOnDeath() return false end
function modifier_bristleback_bristleback_custom_taunt_cd:GetTexture() return "buffs/back_taunt" end
function modifier_bristleback_bristleback_custom_taunt_cd:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_bristle_back_ground", "cd")
if not IsServer() then return end

self:SetStackCount(0)

self:StartIntervalThink(FrameTime())
end


function modifier_bristleback_bristleback_custom_taunt_cd:OnIntervalThink()
if not IsServer() then return end 

if self:GetStackCount() <= 0 then 

  if not self:GetParent():HasModifier("modifier_bristleback_bristleback_custom_taunt_attack") then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_custom_taunt_attack", {})
  end 

else 
  self:DecrementStackCount()
end 


end 




function modifier_bristleback_bristleback_custom_taunt_cd:OnStackCountChanged(iStackCount)
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'bristle_taunt_change',  {max = self.max, damage = self.max - self:GetStackCount()})


if self:GetStackCount() <= 0 then 
  self:StartIntervalThink(FrameTime())
else 
  self:StartIntervalThink(1)
end 

end







modifier_bristleback_bristleback_custom_make_spray = class({})
function modifier_bristleback_bristleback_custom_make_spray:IsHidden() return true end
function modifier_bristleback_bristleback_custom_make_spray:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_make_spray:OnCreated(table)
if not IsServer() then return end

self.taunt_cd_reduce = self:GetCaster():GetTalentValue("modifier_bristle_back_ground", "cd_reduce", true)
self.taunt_cd = self:GetCaster():GetTalentValue("modifier_bristle_back_ground", "cd", true)

self.damage_duration = self:GetCaster():GetTalentValue("modifier_bristle_back_damage", "duration")

self.parent = self:GetParent()

self:SetStackCount(1)
self:Proc()

self:StartIntervalThink(0.1)
end

function modifier_bristleback_bristleback_custom_make_spray:Proc()
if not IsServer() then return end
if self:GetStackCount() == 0 then return end

self:DecrementStackCount()

local quill_spray_ability = self:GetParent():FindAbilityByName("bristleback_quill_spray_custom")
local warpath = self:GetParent():FindModifierByName("modifier_custom_bristleback_warpath")

if not quill_spray_ability then return end
if not quill_spray_ability:IsTrained() then return end

quill_spray_ability:MakeSpray(self:GetParent():GetAbsOrigin(), true)
  
if warpath then 
  warpath:IncStacks()
end


if self:GetParent():HasModifier("modifier_bristle_back_damage") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_custom_str", {duration = self.damage_duration})    
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_custom_str_count", {duration = self.damage_duration})
end

local mod = self.parent:FindModifierByName("modifier_bristleback_bristleback_custom_taunt_cd")

if mod and mod:GetStackCount() > 0 then 
  mod:SetStackCount(math.max(0, mod:GetStackCount() + self.taunt_cd_reduce) )
end 

end

function modifier_bristleback_bristleback_custom_make_spray:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()

end



function modifier_bristleback_bristleback_custom_make_spray:OnIntervalThink()
if not IsServer() then return end

self:Proc()

if self:GetStackCount() == 0 then 
  self:Destroy()
end

end




modifier_bristleback_bristleback_custom_scepter = class({})

function modifier_bristleback_bristleback_custom_scepter:IsHidden() return true end
function modifier_bristleback_bristleback_custom_scepter:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_scepter:OnCreated()
if not IsServer() then return end 

self.parent = self:GetParent()

self.count = 0
self.max = self:GetAbility():GetSpecialValueFor("activation_num_quill_sprays")
self.interval = self:GetAbility():GetSpecialValueFor("activation_spray_interval")
self.quill_spray_ability = self.parent:FindAbilityByName("bristleback_quill_spray_custom")
self.ulti_mod = self.parent:FindModifierByName("modifier_custom_bristleback_warpath")

self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("activation_delay"))
end 

function modifier_bristleback_bristleback_custom_scepter:OnIntervalThink()
if not IsServer() then return end 


if self.quill_spray_ability and self.quill_spray_ability:IsTrained() then 

  self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
  self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_2)
  self.quill_spray_ability:MakeSpray(self.parent:GetAbsOrigin(), false ,true)

  if self.ulti_mod then 
    self.ulti_mod:IncStacks()
  end
end

self.count = self.count + 1

if self.count >= self.max then 
  self:Destroy()
end 

self:StartIntervalThink(self.interval)
end 


function modifier_bristleback_bristleback_custom_scepter:OnDestroy()
if not IsServer() then return end 

self.parent:RemoveModifierByName("modifier_bristleback_active_conical_quill_spray")
end 







bristleback_bristleback_custom_legendary = class({})

function bristleback_bristleback_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_bristle_back_legendary", "cd")
end 

function bristleback_bristleback_custom_legendary:OnSpellStart()
local caster = self:GetCaster()

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bristleback_bristleback_custom_legendary_active", {duration = self:GetCaster():GetTalentValue("modifier_bristle_back_legendary", "duration")})

end







modifier_bristleback_bristleback_custom_armor = class({})
function modifier_bristleback_bristleback_custom_armor:IsHidden() return false end
function modifier_bristleback_bristleback_custom_armor:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_armor:GetTexture() return "buffs/moment_armor" end
function modifier_bristleback_bristleback_custom_armor:OnCreated()

self.armor = self:GetCaster():GetTalentValue("modifier_bristle_back_return", "armor")
self.slow = self:GetCaster():GetTalentValue("modifier_bristle_back_return", "slow")
self.max = self:GetCaster():GetTalentValue("modifier_bristle_back_return", "max")

self:SetStackCount(1)
end

function modifier_bristleback_bristleback_custom_armor:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

  self:GetParent():EmitSound("Hoodwink.Acorn_armor")
  self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent()) 
  ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end 

end


function modifier_bristleback_bristleback_custom_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_bristleback_bristleback_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end

function modifier_bristleback_bristleback_custom_armor:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self.slow
end














modifier_bristleback_bristleback_custom_shield = class({})
function modifier_bristleback_bristleback_custom_shield:IsHidden() return true end
function modifier_bristleback_bristleback_custom_shield:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_shield:OnCreated(table)

self.max_shield = self:GetCaster():GetTalentValue("modifier_bristle_back_heal", "shield")*self:GetCaster():GetMaxHealth()/100
self.timer = self:GetCaster():GetTalentValue("modifier_bristle_back_heal", "timer")


if not IsServer() then return end
self.RemoveForDuel = true
self.caster = self:GetCaster()
self:SetStackCount(self.max_shield)
end

function modifier_bristleback_bristleback_custom_shield:GetEffectName() return "particles/bristleback/armor_buff.vpcf" end

function modifier_bristleback_bristleback_custom_shield:OnIntervalThink()
self:OnCreated()
self:StartIntervalThink(-1)
end 

function modifier_bristleback_bristleback_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_bristleback_bristleback_custom_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
      return self:GetStackCount()
    end 
end

if not IsServer() then return end
if self:GetParent() == params.attacker then return end

self:StartIntervalThink(self.timer)

local back_damage_reduction    = self:GetAbility():GetSpecialValueFor("back_damage_reduction") + self:GetParent():GetTalentValue("modifier_bristle_back_spray", "damage_reduce")

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage

    if self:GetAbility():IsFacingBack(params.attacker)  then    
      self:GetAbility():IncStacks(i*(1 - back_damage_reduction/100))
    end

    return -i
else
    
    local i = self:GetStackCount()

    if self:GetAbility():IsFacingBack(params.attacker)  then    
      self:GetAbility():IncStacks(i*(1 - back_damage_reduction/100))
    end

    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end






modifier_bristleback_bristleback_custom_timer = class({})
function modifier_bristleback_bristleback_custom_timer:IsHidden() return false end
function modifier_bristleback_bristleback_custom_timer:IsPurgable() return false end
function modifier_bristleback_bristleback_custom_timer:IsDebuff() return true end
function modifier_bristleback_bristleback_custom_timer:GetTexture() return "buffs/back_shield" end


function modifier_bristleback_bristleback_custom_timer:OnCreated()
if not IsServer() then return end 

end 

function modifier_bristleback_bristleback_custom_timer:OnDestroy()
if not IsServer() then return end 
if self:GetRemainingTime() > 0.1 then return end 

self:GetParent():EmitSound("BB.Back_shield")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_custom_shield", {})
end