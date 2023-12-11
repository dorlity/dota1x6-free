LinkLuaModifier("modifier_bristleback_bristleback_custom", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_legendary_active", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_reflect_cd", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_reflect_ready", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_damage", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_damage_count", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_taunt_stack", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_taunt_effect", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_taunt_cd", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_make_spray", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bristleback_bristleback_scepter", "abilities/bristleback/bristleback_bristleback_custom", LUA_MODIFIER_MOTION_NONE)



bristleback_bristleback_custom  = class({})

bristleback_bristleback_custom.quill_init = 0
bristleback_bristleback_custom.quill_inc = -10



bristleback_bristleback_custom.reflect_cd = 12

bristleback_bristleback_custom.damage_duration = 8
bristleback_bristleback_custom.damage_spell = {2, 3}
bristleback_bristleback_custom.damage_speed = {10, 15}


bristleback_bristleback_custom.reduction_inc = {5, 7.5, 10}

bristleback_bristleback_custom.return_inc = {0.1, 0.15, 0.2}


bristleback_bristleback_custom.taunt_count = 5
bristleback_bristleback_custom.taunt_duration = 2
bristleback_bristleback_custom.taunt_cd = 10
bristleback_bristleback_custom.taunt_radius = 600
bristleback_bristleback_custom.taunt_timer = 8
bristleback_bristleback_custom.taunt_heal = 0.06



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
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bristleback_bristleback_scepter", {})


end







function bristleback_bristleback_custom:GetIntrinsicModifierName()
  return "modifier_bristleback_bristleback_custom"
end


modifier_bristleback_bristleback_custom = class({})

function modifier_bristleback_bristleback_custom:IsPurgable() return false end
function modifier_bristleback_bristleback_custom:IsHidden() return true end


function modifier_bristleback_bristleback_custom:OnCreated()
  self.ability  = self:GetAbility()
  self.caster   = self:GetCaster()
  self.parent   = self:GetParent()
  
  self.front_damage_reduction   = 0

  self.side_angle         = self.ability:GetSpecialValueFor("side_angle")
  self.back_angle         = self.ability:GetSpecialValueFor("back_angle")
  
  self.cumulative_damage      = self.cumulative_damage or 0
end

function modifier_bristleback_bristleback_custom:OnRefresh()
  self:OnCreated()
end

function modifier_bristleback_bristleback_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_ABSORB_SPELL
    }
end

function modifier_bristleback_bristleback_custom:GetAbsorbSpell(params)
if not IsServer() then return end

if params.ability and params.ability:GetCaster() == self:GetParent() then return end
if not self:GetParent():HasModifier("modifier_bristle_back_reflect") then return end
if self:GetParent():PassivesDisabled() and not self:GetParent():HasModifier("modifier_bristleback_bristleback_scepter") then return end

local forwardVector     = self:GetParent():GetForwardVector()
local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
        
local reverseEnemyVector  = (self:GetParent():GetAbsOrigin() - params.ability:GetCaster():GetAbsOrigin()):Normalized()
local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

local difference = math.abs(forwardAngle - reverseEnemyAngle)

if (difference <= (self.back_angle / 1)) or (difference >= (360 - (self.back_angle / 1)))  or self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active")  then
    if not self:GetParent():HasModifier("modifier_bristleback_bristleback_reflect_cd") then 
         
       local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_defense_matrix_ball_sphere_rings.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(particle)

        self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_reflect_cd", {duration = self:GetAbility().reflect_cd})
        return 1
    end
end


end



function modifier_bristleback_bristleback_custom:GetModifierIncomingDamage_Percentage(keys)
if not IsServer() then return end 

if self.parent:PassivesDisabled() and not self:GetParent():HasModifier("modifier_bristleback_bristleback_scepter") then return end 
if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end 
if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return  end

local forwardVector     = self.caster:GetForwardVector()
local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
    
local reverseEnemyVector  = (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

local difference = math.abs(forwardAngle - reverseEnemyAngle)

self.front_damage_reduction   = 0

self.side_damage_reduction    = self.ability:GetSpecialValueFor("side_damage_reduction")
self.back_damage_reduction    = self.ability:GetSpecialValueFor("back_damage_reduction")

if self:GetParent():HasModifier("modifier_bristle_back_heal") then 
  self.side_damage_reduction    = self.side_damage_reduction + self:GetAbility().reduction_inc[self:GetCaster():GetUpgradeStack("modifier_bristle_back_heal")]
  self.back_damage_reduction    = self.back_damage_reduction + self:GetAbility().reduction_inc[self:GetCaster():GetUpgradeStack("modifier_bristle_back_heal")]
end


if (difference <= (self.back_angle / 1)) or (difference >= (360 - (self.back_angle / 1))) or self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active") then

  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
  ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle)

  local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_lrg_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControlEnt(particle2, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle2)
  
  self.parent:EmitSound("Hero_Bristleback.Bristleback")

  if self:GetParent():GetQuest() == "Brist.Quest_7" and keys.attacker:IsRealHero() then 
    self:GetParent():UpdateQuest(math.floor(keys.original_damage))
  end


  return self.back_damage_reduction * (-1)


elseif (difference <= (self.side_angle)) or (difference >= (360 - (self.side_angle))) then 

  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bristleback/bristleback_back_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(particle, 1, self.parent:GetAbsOrigin())
  ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex(particle)


  return self.side_damage_reduction * (-1)
else
  return self.front_damage_reduction * (-1)
end


end




function modifier_bristleback_bristleback_custom:OnTakeDamage( keys )
if keys.attacker == nil then return end
if keys.unit ~= self.parent then return end
if self.parent:PassivesDisabled() and not self:GetParent():HasModifier("modifier_bristleback_bristleback_scepter") then return end  
if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end 
if bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS  then return end 
if not self.parent:HasAbility("bristleback_quill_spray_custom") then return end 
if not self.parent:FindAbilityByName("bristleback_quill_spray_custom"):IsTrained() then return end
  
  
self.quill_release_threshold  = self.ability:GetSpecialValueFor("quill_release_threshold")

if self:GetParent():HasModifier("modifier_bristle_back_spray") then 
  self.quill_release_threshold = self.quill_release_threshold + self:GetAbility().quill_init + self:GetAbility().quill_inc*self:GetParent():GetUpgradeStack("modifier_bristle_back_spray")
end

if self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active") then 
  self.quill_release_threshold = self.quill_release_threshold + self:GetCaster():GetTalentValue("modifier_bristle_back_legendary", "spray_damage")
end




local forwardVector     = self.caster:GetForwardVector()
local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
        
local reverseEnemyVector  = (self.caster:GetAbsOrigin() - keys.attacker:GetAbsOrigin()):Normalized()
local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))


local difference = math.abs(forwardAngle - reverseEnemyAngle)

if (difference <= (self.back_angle / 1)) or (difference >= (360 - (self.back_angle / 1)))  or self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active")  then
      
  
    
  local stack = keys.damage

  while stack > 0 do 
    self:SetStackCount(self:GetStackCount() + stack)

    if self:GetStackCount() < self.quill_release_threshold then 
      stack = 0
    else 
      stack =  self:GetStackCount() - self.quill_release_threshold
      self:SetStackCount(0)
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_make_spray", {})
    end
  end

end

end






function modifier_bristleback_bristleback_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetParent():PassivesDisabled()  and not self:GetParent():HasModifier("modifier_bristleback_bristleback_scepter") then return end  
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end 
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end



local forwardVector     = self:GetParent():GetForwardVector()
local forwardAngle      = math.deg(math.atan2(forwardVector.x, forwardVector.y))
        
local reverseEnemyVector  = (self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized()
local reverseEnemyAngle   = math.deg(math.atan2(reverseEnemyVector.x, reverseEnemyVector.y))

local difference = math.abs(forwardAngle - reverseEnemyAngle)

if (difference <= (self.back_angle / 1)) or (difference >= (360 - (self.back_angle / 1)))  or self:GetParent():HasModifier("modifier_bristleback_bristleback_legendary_active")  then




if self:GetParent():HasModifier("modifier_bristle_back_return") then

    local damage = self:GetParent():GetAverageTrueAttackDamage(nil)*(self:GetAbility().return_inc[self:GetParent():GetUpgradeStack("modifier_bristle_back_return")])
    
    ApplyDamage( {
        victim      = params.attacker,
        damage      = damage,
        damage_type   = DAMAGE_TYPE_PHYSICAL,
        damage_flags  = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK,
        attacker    = self:GetParent(),
        ability     = self:GetAbility()
       }
     )

end

end

end








modifier_bristleback_bristleback_legendary_active = class({})


function modifier_bristleback_bristleback_legendary_active:IsHidden() return false end
function modifier_bristleback_bristleback_legendary_active:IsPurgable() return false end
--function modifier_bristleback_bristleback_legendary_active:CheckState() return {[MODIFIER_STATE_DISARMED] = true} end
function modifier_bristleback_bristleback_legendary_active:GetTexture() return "buffs/Blade_fury_shield" end




function modifier_bristleback_bristleback_legendary_active:OnCreated(table)
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




modifier_bristleback_bristleback_reflect_ready = class({})
function modifier_bristleback_bristleback_reflect_ready:IsHidden() return
  self:GetParent():HasModifier("modifier_bristleback_bristleback_reflect_cd")
end
function modifier_bristleback_bristleback_reflect_ready:IsPurgable() return false end
function modifier_bristleback_bristleback_reflect_ready:RemoveOnDeath() return false end
function modifier_bristleback_bristleback_reflect_ready:GetTexture() return "buffs/back_reflect" end



modifier_bristleback_bristleback_reflect_cd = class({})
function modifier_bristleback_bristleback_reflect_cd:IsHidden() return false end
function modifier_bristleback_bristleback_reflect_cd:GetTexture() return "buffs/back_reflect" end
function modifier_bristleback_bristleback_reflect_cd:IsPurgable() return false end
function modifier_bristleback_bristleback_reflect_cd:RemoveOnDeath() return false end
function modifier_bristleback_bristleback_reflect_cd:IsDebuff() return true end
function modifier_bristleback_bristleback_reflect_cd:OnCreated(table)
self.RemoveForDuel = true 
end



modifier_bristleback_bristleback_damage_count = class({})
function modifier_bristleback_bristleback_damage_count:IsHidden() return false end
function modifier_bristleback_bristleback_damage_count:IsPurgable() return false end
function modifier_bristleback_bristleback_damage_count:GetTexture() return "buffs/back_damage" end


function modifier_bristleback_bristleback_damage_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end
function modifier_bristleback_bristleback_damage_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_bristleback_bristleback_damage_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

end

function modifier_bristleback_bristleback_damage_count:GetModifierSpellAmplify_Percentage() 
  return self:GetStackCount()*self:GetAbility().damage_spell[self:GetParent():GetUpgradeStack("modifier_bristle_back_damage")]
end

function modifier_bristleback_bristleback_damage_count:GetModifierAttackSpeedBonus_Constant()
 return self:GetStackCount()*self:GetAbility().damage_speed[self:GetParent():GetUpgradeStack("modifier_bristle_back_damage")]
end




modifier_bristleback_bristleback_damage = class({})
function modifier_bristleback_bristleback_damage:IsHidden() return true end
function modifier_bristleback_bristleback_damage:IsPurgable() return false end
function modifier_bristleback_bristleback_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_bristleback_bristleback_damage_count:GetEffectName() return "particles/bristle_back_buff_.vpcf" end

function modifier_bristleback_bristleback_damage:OnCreated(table)
self.RemoveForDuel = true
end

function modifier_bristleback_bristleback_damage:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_bristleback_bristleback_damage_count")
if not mod then return end
mod:DecrementStackCount()

if mod:GetStackCount() == 0 then 
  mod:Destroy()
end
end






modifier_bristleback_bristleback_taunt_stack = class({})
function modifier_bristleback_bristleback_taunt_stack:IsHidden() return false end
function modifier_bristleback_bristleback_taunt_stack:IsPurgable() return false end
function modifier_bristleback_bristleback_taunt_stack:GetTexture() return "buffs/back_taunt" end

function modifier_bristleback_bristleback_taunt_stack:OnCreated()
if not IsServer() then return end
self:SetStackCount(1)


local particle_cast = "particles/back_stack_brist.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

self:AddParticle(self.effect_cast,false, false, -1, false, false)

self.RemoveForDuel = true
end


function modifier_bristleback_bristleback_taunt_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().taunt_count then 

  local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().taunt_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

  for _,enemy in pairs(enemies) do 
    if enemy:GetUnitName() ~= "npc_teleport" then
      enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_taunt_effect", {duration = (1 - enemy:GetStatusResistance())*self:GetAbility().taunt_duration})
    end
  end

  local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
  ParticleManager:ReleaseParticleIndex( particle )

  self:GetParent():EmitSound("Item.BM_heal")

  self:GetParent():GenericHeal(self:GetParent():GetMaxHealth()*self:GetAbility().taunt_heal, self:GetAbility())

  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_taunt_cd", {duration = self:GetAbility().taunt_cd})

  self:Destroy()
end

end




function modifier_bristleback_bristleback_taunt_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 1 then return end

if self.effect_cast then 
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end

end






modifier_bristleback_bristleback_taunt_effect = class({})

function modifier_bristleback_bristleback_taunt_effect:IsPurgable()
  return false
end
function modifier_bristleback_bristleback_taunt_effect:IsHidden()
  return true
end

function modifier_bristleback_bristleback_taunt_effect:OnCreated( kv )
if not IsServer() then return end

self:GetParent():SetForceAttackTarget( self:GetCaster() )
self:GetParent():MoveToTargetToAttack( self:GetCaster() )

self:GetParent():EmitSound("Hero_Axe.Berserkers_Call")
self:StartIntervalThink(FrameTime())
end

function modifier_bristleback_bristleback_taunt_effect:OnIntervalThink()
  if not IsServer() then return end
  if not self:GetCaster():IsAlive() then
    self:Destroy()
  end
end

function modifier_bristleback_bristleback_taunt_effect:OnDestroy()
if not IsServer() then return end

self:GetParent():SetForceAttackTarget( nil )
  
end

function modifier_bristleback_bristleback_taunt_effect:CheckState()
  local state = {
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_TAUNTED] = true,
  }

  return state
end

function modifier_bristleback_bristleback_taunt_effect:GetStatusEffectName()
  return "particles/status_fx/status_effect_beserkers_call.vpcf"
end




modifier_bristleback_bristleback_taunt_cd = class({})
function modifier_bristleback_bristleback_taunt_cd:IsHidden() return false end
function modifier_bristleback_bristleback_taunt_cd:IsPurgable() return false end
function modifier_bristleback_bristleback_taunt_cd:IsDebuff() return true end
function modifier_bristleback_bristleback_taunt_cd:RemoveOnDeath() return false end
function modifier_bristleback_bristleback_taunt_cd:GetTexture() return "buffs/back_taunt" end
function modifier_bristleback_bristleback_taunt_cd:OnCreated(table)
self.RemoveForDuel = true
end



modifier_bristleback_bristleback_make_spray = class({})
function modifier_bristleback_bristleback_make_spray:IsHidden() return true end
function modifier_bristleback_bristleback_make_spray:IsPurgable() return false end
function modifier_bristleback_bristleback_make_spray:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
self:Proc()

self:StartIntervalThink(0.1)
end

function modifier_bristleback_bristleback_make_spray:Proc()
if not IsServer() then return end
if self:GetStackCount() == 0 then return end

self:DecrementStackCount()

local quill_spray_ability = self:GetParent():FindAbilityByName("bristleback_quill_spray_custom")
local warpath = self:GetParent():FindModifierByName("modifier_custom_bristleback_warpath")

if not quill_spray_ability then return end
if not quill_spray_ability:IsTrained() then return end

quill_spray_ability:MakeSpray(self:GetParent():GetAbsOrigin(), false, false)

if warpath then 
  warpath:IncStacks()
end

if self:GetParent():HasModifier("modifier_bristle_back_ground") and not self:GetParent():HasModifier("modifier_bristleback_bristleback_taunt_cd") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_taunt_stack", {duration = self:GetAbility().taunt_timer})
end

if self:GetParent():HasModifier("modifier_bristle_back_damage") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_damage", {duration = self:GetAbility().damage_duration})    
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bristleback_bristleback_damage_count", {duration = self:GetAbility().damage_duration})
end


end

function modifier_bristleback_bristleback_make_spray:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()

end



function modifier_bristleback_bristleback_make_spray:OnIntervalThink()
if not IsServer() then return end

self:Proc()

if self:GetStackCount() == 0 then 
  self:Destroy()
end

end




modifier_bristleback_bristleback_scepter = class({})

function modifier_bristleback_bristleback_scepter:IsHidden() return true end
function modifier_bristleback_bristleback_scepter:IsPurgable() return false end
function modifier_bristleback_bristleback_scepter:OnCreated()
if not IsServer() then return end 

self.parent = self:GetParent()

self.count = 0
self.max = self:GetAbility():GetSpecialValueFor("activation_num_quill_sprays")
self.interval = self:GetAbility():GetSpecialValueFor("activation_spray_interval")
self.quill_spray_ability = self.parent:FindAbilityByName("bristleback_quill_spray_custom")
self.ulti_mod = self.parent:FindModifierByName("modifier_custom_bristleback_warpath")

self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("activation_delay"))
end 

function modifier_bristleback_bristleback_scepter:OnIntervalThink()
if not IsServer() then return end 


if self.quill_spray_ability and self.quill_spray_ability:IsTrained() then 

  self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
  self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_2)
  self.quill_spray_ability:MakeSpray(self.parent:GetAbsOrigin(), false, false, true)

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


function modifier_bristleback_bristleback_scepter:OnDestroy()
if not IsServer() then return end 

self.parent:RemoveModifierByName("modifier_bristleback_active_conical_quill_spray")
end 







bristleback_bristleback_custom_legendary = class({})

function bristleback_bristleback_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_bristle_back_legendary", "cd")
end 

function bristleback_bristleback_custom_legendary:OnSpellStart()
local caster = self:GetCaster()

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bristleback_bristleback_legendary_active", {duration = self:GetCaster():GetTalentValue("modifier_bristle_back_legendary", "duration")})

end