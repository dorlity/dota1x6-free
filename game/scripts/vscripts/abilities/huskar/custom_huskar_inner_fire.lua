LinkLuaModifier("modifier_custom_huskar_inner_fire_knockback", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_huskar_inner_fire_disarm", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_coil", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_root", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_silence_timer", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_tracker", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_heal", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_legendary_knock", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_huskar_inner_fire_slow", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_huskar_inner_fire_shield", "abilities/huskar/custom_huskar_inner_fire", LUA_MODIFIER_MOTION_NONE)




custom_huskar_inner_fire = class({})



function custom_huskar_inner_fire:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf", context )
PrecacheResource( "particle", "particles/huskar_disarm_coil.vpcf", context )
PrecacheResource( "particle", "particles/huskar_disarm_tether.vpcf", context )
PrecacheResource( "particle", "particles/huskar_disarm_heal.vpcf", context )
PrecacheResource( "particle", "particles/huskar_timer.vpcf", context )
PrecacheResource( "particle", "particles/huskar_silence.vpcf", context )
PrecacheResource( "particle", "particles/huskar_leap_heal.vpcf", context )
PrecacheResource( "particle", "particles/huskar_burn_aura.vpcf", context )

my_game:PrecacheShopItems("npc_dota_hero_huskar", context)

end



function custom_huskar_inner_fire:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_custom_huskar_inner_fire_silence_timer") then 
    return "inner_fire_silence"
end 

return "huskar_inner_fire"
end 


function custom_huskar_inner_fire:GetAOERadius()
return  self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_huskar_disarm_silence", "radius")
end
  


function custom_huskar_inner_fire:GetIntrinsicModifierName() return
"modifier_custom_huskar_inner_fire_tracker"
end



function custom_huskar_inner_fire:GetCastPoint()

if self:GetCaster():HasModifier("modifier_huskar_disarm_lowhp") then 
  return 0
end
return self:GetSpecialValueFor("AbilityCastPoint")
end





function custom_huskar_inner_fire:CastFilterResultTarget(target)
if not self:GetCaster():HasModifier("modifier_huskar_disarm_legendary") then return end

if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and self:GetCaster() ~= target then
  return UF_FAIL_FRIENDLY 
end

return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, self:GetCaster():GetTeamNumber())
end




function custom_huskar_inner_fire:GetBehavior() 

if self:GetCaster():HasModifier("modifier_huskar_disarm_lowhp") and self:GetCaster():IsStunned() then 
  return  DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end

if self:GetCaster():HasModifier("modifier_custom_huskar_inner_fire_silence_timer") then 
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 

if self:GetCaster():HasModifier("modifier_huskar_disarm_legendary") then 
  return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end 


return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end 




function custom_huskar_inner_fire:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasModifier("modifier_huskar_disarm_legendary") then 
  return self:GetCaster():GetTalentValue("modifier_huskar_disarm_legendary", "range")
end 

return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_huskar_disarm_silence", "radius")
end




function custom_huskar_inner_fire:GetCooldown(iLevel)

local k = 0

if self:GetCaster():HasModifier("modifier_huskar_disarm_lowhp") then 
  k = (1 - self:GetCaster():GetHealthPercent()/100)*self:GetCaster():GetTalentValue("modifier_huskar_disarm_lowhp", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + k
end





function custom_huskar_inner_fire:GetManaCost(level)
if self:GetCaster():HasModifier("modifier_huskar_disarm_lowhp") or self:GetCaster():HasModifier("modifier_custom_huskar_inner_fire_silence_timer") then
  return 0
end
return self.BaseClass.GetManaCost(self,level)
end


function custom_huskar_inner_fire:GetHealthCost(level)
if not self:GetCaster():HasModifier("modifier_huskar_disarm_lowhp") then end
if self:GetCaster():HasModifier("modifier_custom_huskar_inner_fire_silence_timer") then return end

return self:GetCaster():GetHealth()*self:GetCaster():GetTalentValue("modifier_huskar_disarm_lowhp", "cost")/100
end



function custom_huskar_inner_fire:GetDamage()
local damage = self:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_huskar_disarm_crit") then
  damage = damage + self:GetCaster():GetTalentValue("modifier_huskar_disarm_crit", "damage") * (self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())/100
end

return damage
end



function custom_huskar_inner_fire:GetCastAnimation()
if self:GetCaster():HasModifier("modifier_huskar_disarm_lowhp") then 
  return 0
end 
  return ACT_DOTA_CAST_ABILITY_1
end




function custom_huskar_inner_fire:OnSpellStart(new_cd, stack, new_x, new_y)
if not IsServer() then return end

local mod = self:GetCaster():FindModifierByName("modifier_custom_huskar_inner_fire_silence_timer")

if self:GetCaster():HasModifier("modifier_huskar_disarm_lowhp") and not self:GetCaster():IsStunned() and not new_cd and not mod then 
  self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1.3)
end 

local damage = self:GetDamage()
local radius = self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_huskar_disarm_silence", "radius")
local disarm_duration = self:GetSpecialValueFor("disarm_duration") + self:GetCaster():GetTalentValue("modifier_huskar_disarm_duration", "disarm")
local knockback_duration = self:GetSpecialValueFor("knockback_duration")

local silence = false
local silence_duration = self:GetCaster():GetTalentValue("modifier_huskar_disarm_str", "silence")

local legendary_duration = self:GetCaster():GetTalentValue("modifier_huskar_disarm_legendary", "duration")


local point = self:GetCaster():GetAbsOrigin()
local self_cast = 1

if self:GetCaster():HasModifier("modifier_huskar_disarm_legendary") and not new_cd then 

  self_cast = 0
  if self:GetCursorPosition() and not self:GetCaster():IsStunned() then 
    point = self:GetCursorPosition()
  end  
end 

if new_x and new_y then 
  point = GetGroundPosition(Vector(new_x, new_y, 0), nil)
end 


if mod then 
  mod:Destroy()
  return
end 

local sound = "Hero_Huskar.Inner_Fire.Cast"
local part = "particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf"

if new_cd then 
  part = "particles/huskar_silence.vpcf" 
  sound = "Huskar.Inner_Silence"
  self:EndCooldown()
  self:StartCooldown(new_cd)

  if stack then 
    if stack >= self:GetCaster():GetTalentValue("modifier_huskar_disarm_str", "stack") then 
      silence = true
      EmitSoundOnLocationWithCaster(point, "Huskar.Inner_Silence_Proc", self:GetCaster())
    end 

    damage = self:GetDamage()*stack*self:GetCaster():GetTalentValue("modifier_huskar_disarm_str", "damage")/100
  end 
end 

EmitSoundOnLocationWithCaster(point, sound, self:GetCaster())

local particle = ParticleManager:CreateParticle(part, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, point)
ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
ParticleManager:SetParticleControl(particle, 3, point)
ParticleManager:ReleaseParticleIndex(particle)


if self:GetCaster():HasModifier("modifier_huskar_disarm_str") and not new_cd then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_silence_timer", {cd = self:GetCooldownTimeRemaining(), self_cast = self_cast, x = point.x, y = point.y, duration = self:GetCaster():GetTalentValue("modifier_huskar_disarm_str", "duration")})
  self:EndCooldown()
  self:StartCooldown(0.5) 
end

if self:GetCaster():HasModifier("modifier_huskar_disarm_heal") and not new_cd then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_heal", {duration = self:GetCaster():GetTalentValue("modifier_huskar_disarm_heal", "duration")})
end 

if self:GetCaster():HasModifier("modifier_huskar_disarm_duration") and not new_cd then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_shield", {duration = self:GetCaster():GetTalentValue("modifier_huskar_disarm_duration", "duration")})
end 


local damageTable = {damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self:GetCaster(), ability = self}

for _, enemy in pairs(self:GetCaster():FindTargets(radius, point)) do

  damageTable.victim = enemy
  ApplyDamage(damageTable)  

  enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_knockback", {duration = knockback_duration * (1 - enemy:GetStatusResistance()), x = point.x, y = point.y})
  
  if not new_cd then
    if self:GetCaster():HasModifier("modifier_huskar_disarm_legendary") then  
      enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_root", {duration = legendary_duration*(1 - enemy:GetStatusResistance()), x = point.x, y = point.y})
    end 

    enemy:AddNewModifier(self:GetCaster(), self, "modifier_custom_huskar_inner_fire_disarm", {duration = disarm_duration * (1 - enemy:GetStatusResistance())})
  else 
    if silence then 
      enemy:EmitSound("Huskar.Inner_Silence_target")
      enemy:AddNewModifier(self:GetCaster(), self, "modifier_generic_silence", {duration = silence_duration * (1 - enemy:GetStatusResistance())})
    end
  end 

  if self:GetCaster():HasModifier("modifier_huskar_disarm_legendary") then 
  end 
    
end

if self:GetCaster():HasModifier("modifier_huskar_disarm_legendary") then 
  CreateModifierThinker(self:GetCaster(),self,"modifier_custom_huskar_inner_fire_coil",{ duration = legendary_duration },point, self:GetCaster():GetTeamNumber(),false) 
end 
  
end





modifier_custom_huskar_inner_fire_knockback       = class({})

function modifier_custom_huskar_inner_fire_knockback:IsHidden() return true end

function modifier_custom_huskar_inner_fire_knockback:OnCreated(params)
if not IsServer() then return end

self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self:GetParent():StartGesture(ACT_DOTA_FLAIL)

self.knockback_duration   = self:GetAbility():GetSpecialValueFor("knockback_duration")

local point = GetGroundPosition(Vector(params.x, params.y, 0), nil)
local max_dist = self.ability:GetSpecialValueFor("knockback_distance")

self.knockback_distance   = math.max(max_dist - (point - self.parent:GetAbsOrigin()):Length2D(), 50)
self.knockback_speed    = self.knockback_distance / self.knockback_duration

self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

if self:ApplyHorizontalMotionController() == false then 
  self:Destroy()
  return
end

end

function modifier_custom_huskar_inner_fire_knockback:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

local distance = (me:GetOrigin() - self.position):Normalized()

me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_huskar_inner_fire_knockback:DeclareFunctions()
local decFuncs = {
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
  }

  return decFuncs
end

function modifier_custom_huskar_inner_fire_knockback:GetOverrideAnimation()
  return ACT_DOTA_FLAIL
end


function modifier_custom_huskar_inner_fire_knockback:OnDestroy()
if not IsServer() then return end

self.parent:RemoveHorizontalMotionController( self )
self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end


function modifier_custom_huskar_inner_fire_knockback:CheckState()
if not self:GetCaster():HasModifier("modifier_huskar_disarm_silence") then return end 
return
{
  [MODIFIER_STATE_STUNNED] = true
}
end





modifier_custom_huskar_inner_fire_disarm          = class({})

function modifier_custom_huskar_inner_fire_disarm:IsHidden() return false end
function modifier_custom_huskar_inner_fire_disarm:IsPurgable() return true end

function modifier_custom_huskar_inner_fire_disarm:GetEffectName()
  return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
end

function modifier_custom_huskar_inner_fire_disarm:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end

function modifier_custom_huskar_inner_fire_disarm:CheckState()
return 
{
  [MODIFIER_STATE_DISARMED] = true
}
end


function modifier_custom_huskar_inner_fire_disarm:OnCreated(table)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end

if self:GetCaster():GetQuest() == "Huskar.Quest_5" then 
  self:StartIntervalThink(0.1)
end

end

function modifier_custom_huskar_inner_fire_disarm:OnIntervalThink()
if not IsServer() then return end
if self:GetCaster():QuestCompleted() then return end

self:GetCaster():UpdateQuest(0.1)
end

function modifier_custom_huskar_inner_fire_disarm:OnDestroy()
if not IsServer() then return end 
if not self:GetCaster():HasModifier("modifier_huskar_disarm_silence") then return end 
if self:GetRemainingTime() < 0.1 then return end 


self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_huskar_inner_fire_slow", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_huskar_disarm_silence", "slow_duration")})
end 













modifier_custom_huskar_inner_fire_coil = class({})

function modifier_custom_huskar_inner_fire_coil:IsHidden() return true end
function modifier_custom_huskar_inner_fire_coil:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_coil:OnCreated(table)
if not IsServer() then return end

self.effect_cast = ParticleManager:CreateParticle( "particles/huskar_disarm_coil.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
self:AddParticle(self.effect_cast,false,false,-1,false,false)
end






modifier_custom_huskar_inner_fire_root = class({})

function modifier_custom_huskar_inner_fire_root:IsHidden() return true end
function modifier_custom_huskar_inner_fire_root:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_root:GetTexture() return "buffs/disarm_root" end
function modifier_custom_huskar_inner_fire_root:OnCreated(params)
if not IsServer() then return end

self.center = GetGroundPosition(Vector(params.x, params.y, 0), nil)

self.radius = self:GetCaster():GetTalentValue("modifier_huskar_disarm_legendary", "radius")
self.knock_dist = self:GetCaster():GetTalentValue("modifier_huskar_disarm_legendary", "knock_dist")
self.knockback_duration = self:GetCaster():GetTalentValue("modifier_huskar_disarm_legendary", "knock_duration")



self:StartIntervalThink(FrameTime())

local effect_cast = ParticleManager:CreateParticle( "particles/huskar_disarm_tether.vpcf", PATTACH_ABSORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self.center )
ParticleManager:SetParticleControlEnt(effect_cast,1,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetOrigin(),true)
self:AddParticle(effect_cast,false,false,-1,false,false)
end



function modifier_custom_huskar_inner_fire_root:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_custom_huskar_inner_fire_legendary_knock") then return end
if self:GetParent():IsInvulnerable() or self:GetParent():IsOutOfGame() then return end
if self:GetParent():IsDebuffImmune() then return end
if  (self:GetParent():GetAbsOrigin() - self.center):Length2D() <= self.radius then return end
  
self:GetParent():EmitSound("Huskar.Disarm_Legendary") 


ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self:GetAbility():GetDamage(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})          

local vec = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
local knock_point = self.center + vec*self.knock_dist

self:GetParent():RemoveModifierByName("modifier_custom_huskar_inner_fire_knockback")
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_huskar_inner_fire_legendary_knock", {duration = self.knockback_duration, x = knock_point.x, y = knock_point.y})
        
end

function modifier_custom_huskar_inner_fire_root:CheckState()
return
{
  [MODIFIER_STATE_TETHERED] = true
}
end




modifier_custom_huskar_inner_fire_legendary_knock = class({})

function modifier_custom_huskar_inner_fire_legendary_knock:IsHidden() return true end

function modifier_custom_huskar_inner_fire_legendary_knock:OnCreated(params)
if not IsServer() then return end
  
self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self:GetParent():StartGesture(ACT_DOTA_FLAIL)

self.knockback_duration   = self:GetRemainingTime()
self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

self.knockback_distance = (self:GetParent():GetAbsOrigin() -self.position):Length2D() 

self.knockback_speed    = self.knockback_distance / self.knockback_duration

if self:ApplyHorizontalMotionController() == false then 
  self:Destroy()
  return
end

end

function modifier_custom_huskar_inner_fire_legendary_knock:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

local distance = (self.position - me:GetOrigin()):Normalized()

me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_huskar_inner_fire_legendary_knock:DeclareFunctions()
local decFuncs = {
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
  }

  return decFuncs
end

function modifier_custom_huskar_inner_fire_legendary_knock:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_huskar_inner_fire_legendary_knock:OnDestroy()
if not IsServer() then return end
self.parent:RemoveHorizontalMotionController( self )
self:GetParent():FadeGesture(ACT_DOTA_FLAIL)

FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
end










modifier_custom_huskar_inner_fire_silence_timer  = class({})

function modifier_custom_huskar_inner_fire_silence_timer:IsHidden() return true end 
function modifier_custom_huskar_inner_fire_silence_timer:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_silence_timer:GetTexture() return "buffs/inner_timer" end
function modifier_custom_huskar_inner_fire_silence_timer:OnCreated(table)
if not IsServer() then return end

self.cd = table.cd
self.max = self:GetCaster():GetTalentValue("modifier_huskar_disarm_str", "stack")
self.time = self:GetRemainingTime()

self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.self_cast = table.self_cast

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end

function modifier_custom_huskar_inner_fire_silence_timer:OnIntervalThink()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'huskar_inner_change',  {hide = 0, active = self:GetStackCount() >= self.max, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})

end

function modifier_custom_huskar_inner_fire_silence_timer:OnDestroy()
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'huskar_inner_change',  {hide = 1, active = self:GetStackCount() >= self.max, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})

local new_x = self.point.x
local new_y = self.point.y

if self.self_cast and self.self_cast == 1 then 
  new_x = self:GetParent():GetAbsOrigin().x
  new_y = self:GetParent():GetAbsOrigin().y
end 

self:GetAbility():OnSpellStart(self.cd, self:GetStackCount(), new_x, new_y)
end


function modifier_custom_huskar_inner_fire_silence_timer:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_custom_huskar_inner_fire_silence_timer:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 

self:IncrementStackCount()
end








modifier_custom_huskar_inner_fire_tracker  = class({})

function modifier_custom_huskar_inner_fire_tracker:IsHidden() return true end
function modifier_custom_huskar_inner_fire_tracker:IsPurgable() return false end
function modifier_custom_huskar_inner_fire_tracker:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_HEALTH_BONUS
}
end


function modifier_custom_huskar_inner_fire_tracker:GetModifierHealthBonus()
if not self:GetParent():HasModifier("modifier_huskar_disarm_crit") then return end 

return self:GetCaster():GetStrength()*self:GetCaster():GetTalentValue("modifier_huskar_disarm_crit", "health")
end








modifier_custom_huskar_inner_fire_heal = class({})
function modifier_custom_huskar_inner_fire_heal:IsHidden() return false end
function modifier_custom_huskar_inner_fire_heal:IsPurgable() return true end
function modifier_custom_huskar_inner_fire_heal:GetTexture() return "buffs/inner_heal" end
function modifier_custom_huskar_inner_fire_heal:OnCreated(table)

self.heal = self:GetCaster():GetTalentValue("modifier_huskar_disarm_heal", "lifesteal")/100
self.creeps = self:GetCaster():GetTalentValue("modifier_huskar_disarm_heal", "creeps")
self.status = self:GetCaster():GetTalentValue("modifier_huskar_disarm_heal", "status")
end

function modifier_custom_huskar_inner_fire_heal:GetEffectName()
return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf"
end

function modifier_custom_huskar_inner_fire_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_huskar_inner_fire_heal:GetModifierStatusResistanceStacking() 
return self.status
end

function modifier_custom_huskar_inner_fire_heal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if params.unit:IsIllusion() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal*params.damage
if params.unit:IsCreep() then 
  heal = heal / self.creeps
end

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end






modifier_custom_huskar_inner_fire_slow = class({})
function modifier_custom_huskar_inner_fire_slow:IsHidden() return true end
function modifier_custom_huskar_inner_fire_slow:IsPurgable() return true end
function modifier_custom_huskar_inner_fire_slow:OnCreated()

self.attack = self:GetCaster():GetTalentValue("modifier_huskar_disarm_silence", "attack")
self.slow = self:GetCaster():GetTalentValue("modifier_huskar_disarm_silence", "slow")

if not IsServer() then return end 
self:GetParent():EmitSound("Huskar.Disarm_dispel")
end 

function modifier_custom_huskar_inner_fire_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_custom_huskar_inner_fire_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack
end

function modifier_custom_huskar_inner_fire_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_custom_huskar_inner_fire_slow:GetEffectName()
return "particles/ember_spirit/attack_slow.vpcf"
end

function modifier_custom_huskar_inner_fire_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_custom_huskar_inner_fire_slow:StatusEffectPriority()
return 99999
end







modifier_custom_huskar_inner_fire_shield = class({})

function modifier_custom_huskar_inner_fire_shield:IsHidden() return true end
function modifier_custom_huskar_inner_fire_shield:IsPurgable() return true end

function modifier_custom_huskar_inner_fire_shield:OnCreated( params )
self.max_shield = self:GetCaster():GetTalentValue("modifier_huskar_disarm_duration", "shield")*self:GetCaster():GetMaxHealth()/100

if not IsServer() then return end
self:SetStackCount(self.max_shield)
end

function modifier_custom_huskar_inner_fire_shield:OnRefresh()
self:OnCreated()
end

function modifier_custom_huskar_inner_fire_shield:DeclareFunctions()
  return 
{
    MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
}
end


function modifier_custom_huskar_inner_fire_shield:GetModifierIncomingSpellDamageConstant(params)

if IsClient() then 
  if params.report_max then 
    return self.max_shield 
  else 
    return self:GetStackCount()
  end 
end


if not IsServer() then return end

if self:GetStackCount() == 0 then return end


if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:Destroy()
    return -i
end

end
