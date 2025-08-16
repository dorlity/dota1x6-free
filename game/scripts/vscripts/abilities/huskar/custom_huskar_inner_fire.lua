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
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf", context )
PrecacheResource( "particle", "particles/huskar_silence.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf", context )
PrecacheResource( "particle", "particles/huskar_disarm_coil.vpcf", context )
PrecacheResource( "particle", "particles/huskar_disarm_tether.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/ember_spirit/attack_slow.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_huskar_lifebreak.vpcf", context )

PrecacheResource( "soundfile", "soundevents/npc_dota_hero_huskar.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_huskar", context)

end



function custom_huskar_inner_fire:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_custom_huskar_inner_fire_silence_timer") then 
    return "inner_fire_silence"
end 

return "huskar_inner_fire"
end 


function custom_huskar_inner_fire:GetAOERadius()
return  self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_huskar_disarm_5", "radius")
end
  


function custom_huskar_inner_fire:GetIntrinsicModifierName() return
"modifier_custom_huskar_inner_fire_tracker"
end



function custom_huskar_inner_fire:GetCastPoint()

if self:GetCaster():HasTalent("modifier_huskar_disarm_6") then 
  return 0
end
return self:GetSpecialValueFor("AbilityCastPoint")
end





function custom_huskar_inner_fire:CastFilterResultTarget(target)
if not self:GetCaster():HasTalent("modifier_huskar_disarm_7") then return end

if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() and self:GetCaster() ~= target then
  return UF_FAIL_FRIENDLY 
end

return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, 0, self:GetCaster():GetTeamNumber())
end




function custom_huskar_inner_fire:GetBehavior() 

if self:GetCaster():HasTalent("modifier_huskar_disarm_6") and self:GetCaster():IsStunned() then 
  return  DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end

if self:GetCaster():HasModifier("modifier_custom_huskar_inner_fire_silence_timer") then 
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 

if self:GetCaster():HasTalent("modifier_huskar_disarm_7") then 
  return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end 


return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end 




function custom_huskar_inner_fire:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasTalent("modifier_huskar_disarm_7") then 
  return self:GetCaster():GetTalentValue("modifier_huskar_disarm_7", "range")
end 

return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_huskar_disarm_5", "radius")
end




function custom_huskar_inner_fire:GetCooldown(iLevel)

local k = 0

if self:GetCaster():HasTalent("modifier_huskar_disarm_6") then 
  k = (1 - self:GetCaster():GetHealthPercent()/100)*self:GetCaster():GetTalentValue("modifier_huskar_disarm_6", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + k
end





function custom_huskar_inner_fire:GetDamage()
local damage = self:GetSpecialValueFor("damage")

if self:GetCaster():HasTalent("modifier_huskar_disarm_3") then
  damage = damage + self:GetCaster():GetTalentValue("modifier_huskar_disarm_3", "damage") * self:GetCaster():GetMaxHealth()/100
end

return damage
end



function custom_huskar_inner_fire:GetCastAnimation()
if self:GetCaster():HasTalent("modifier_huskar_disarm_6") then 
  return 0
end 
  return ACT_DOTA_CAST_ABILITY_1
end




function custom_huskar_inner_fire:OnSpellStart(new_cd, stack, new_x, new_y)
local caster = self:GetCaster()

local mod = caster:FindModifierByName("modifier_custom_huskar_inner_fire_silence_timer")

if caster:HasTalent("modifier_huskar_disarm_6") and not caster:IsStunned() and not new_cd and not mod then 
  caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1.3)
end 

local damage = self:GetDamage()
local radius = self:GetSpecialValueFor("radius") + caster:GetTalentValue("modifier_huskar_disarm_5", "radius")
local silence_duration = self:GetSpecialValueFor("silence_duration") + caster:GetTalentValue("modifier_huskar_disarm_5", "silence")
local knockback_duration = self:GetSpecialValueFor("knockback_duration")

local stun = 0
local stun_duration = caster:GetTalentValue("modifier_huskar_disarm_4", "stun")

local legendary_duration = caster:GetTalentValue("modifier_huskar_disarm_7", "duration")


local point = caster:GetAbsOrigin()
local self_cast = 1

if caster:HasTalent("modifier_huskar_disarm_7") and not new_cd then 

  self_cast = 0
  if self:GetCursorPosition() and not caster:IsStunned() then 
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

local damage_ability = nil
local sound = "Hero_Huskar.Inner_Fire.Cast"
local part = "particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf"

if new_cd then 
  part = "particles/huskar_silence.vpcf" 
  sound = "Huskar.Inner_Silence"
  knockback_duration = knockback_duration/3

  self:EndCooldown()
  self:StartCooldown(new_cd)

  if stack then 
    if stack >= caster:GetTalentValue("modifier_huskar_disarm_4", "stack") then 
      stun = 1
      EmitSoundOnLocationWithCaster(point, "Huskar.Inner_Silence_Proc", caster)
    end 
    damage_ability = "modifier_huskar_disarm_4"
    damage = self:GetDamage()*stack*caster:GetTalentValue("modifier_huskar_disarm_4", "damage")/100
  end 
end 

EmitSoundOnLocationWithCaster(point, sound, caster)

local particle = ParticleManager:CreateParticle(part, PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, point)
ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
ParticleManager:SetParticleControl(particle, 3, point)
ParticleManager:ReleaseParticleIndex(particle)


if caster:HasTalent("modifier_huskar_disarm_4") and not new_cd then 
  caster:AddNewModifier(caster, self, "modifier_custom_huskar_inner_fire_silence_timer", {cd = self:GetCooldownTimeRemaining(), self_cast = self_cast, x = point.x, y = point.y, duration = caster:GetTalentValue("modifier_huskar_disarm_4", "duration")})
  self:EndCooldown()
  self:StartCooldown(0.5) 
end

if caster:HasTalent("modifier_huskar_disarm_2") and not new_cd then 
  caster:AddNewModifier(caster, self, "modifier_custom_huskar_inner_fire_heal", {duration = caster:GetTalentValue("modifier_huskar_disarm_2", "duration")})
end 

if caster:HasTalent("modifier_huskar_disarm_1") and not new_cd then 
  caster:AddNewModifier(caster, self, "modifier_custom_huskar_inner_fire_shield", {duration = caster:GetTalentValue("modifier_huskar_disarm_1", "duration")})
end 


local damageTable = {damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = caster, ability = self}

for _, enemy in pairs(caster:FindTargets(radius, point)) do

  damageTable.victim = enemy
  DoDamage(damageTable, damage_ability)  

  enemy:AddNewModifier(caster, self, "modifier_custom_huskar_inner_fire_knockback", {stun = stun, duration = knockback_duration * (1 - enemy:GetStatusResistance()), x = point.x, y = point.y})
  if not new_cd then
    if caster:HasTalent("modifier_huskar_disarm_7") then  
      enemy:AddNewModifier(caster, self, "modifier_custom_huskar_inner_fire_root", {duration = legendary_duration*(1 - enemy:GetStatusResistance()), x = point.x, y = point.y})
    end 
    enemy:AddNewModifier(caster, self, "modifier_custom_huskar_inner_fire_disarm", {duration = silence_duration * (1 - enemy:GetStatusResistance())})
  end 
end

if caster:HasTalent("modifier_huskar_disarm_7") then 
  CreateModifierThinker(caster,self,"modifier_custom_huskar_inner_fire_coil",{ duration = legendary_duration },point, caster:GetTeamNumber(),false) 
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

self.stun = params.stun

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


if self.stun == 1 then 
  self.parent:EmitSound("Huskar.Inner_Silence_target")
  self.parent:AddNewModifier(caster, self.ability, "modifier_stunned", {duration = self.caster:GetTalentValue("modifier_huskar_disarm_4", "stun") * (1 - self.parent:GetStatusResistance())})
end

if self.caster:HasTalent("modifier_huskar_disarm_5") then 
  self.parent:Stop()
end

self.parent:RemoveHorizontalMotionController( self )
self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end


function modifier_custom_huskar_inner_fire_knockback:CheckState()
if not self:GetCaster():HasTalent("modifier_huskar_disarm_5") then return end 
return
{
  [MODIFIER_STATE_STUNNED] = true
}
end





modifier_custom_huskar_inner_fire_disarm  = class({})

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
  [MODIFIER_STATE_SILENCED] = true
}
end

function modifier_custom_huskar_inner_fire_disarm:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_custom_huskar_inner_fire_disarm:GetModifierAttackSpeedBonus_Constant()
return self.attack_slow
end


function modifier_custom_huskar_inner_fire_disarm:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.attack_slow = self.caster:GetTalentValue("modifier_huskar_disarm_1", "slow")

if not self.parent:IsRealHero() then return end

if self.caster:GetQuest() == "Huskar.Quest_5" then 
  self:StartIntervalThink(0.1)
end

end

function modifier_custom_huskar_inner_fire_disarm:OnIntervalThink()
if not IsServer() then return end
if self.caster:QuestCompleted() then return end

self.caster:UpdateQuest(0.1)
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

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not IsServer() then return end

self.center = GetGroundPosition(Vector(params.x, params.y, 0), nil)

self.legendary_damage = self.caster:GetTalentValue("modifier_huskar_disarm_7", "damage")/100
self.radius = self.caster:GetTalentValue("modifier_huskar_disarm_7", "radius")
self.knock_dist = self.caster:GetTalentValue("modifier_huskar_disarm_7", "knock_dist")
self.knockback_duration = self.caster:GetTalentValue("modifier_huskar_disarm_7", "knock_duration")

self:StartIntervalThink(FrameTime())

local effect_cast = ParticleManager:CreateParticle( "particles/huskar_disarm_tether.vpcf", PATTACH_ABSORIGIN, self.parent )
ParticleManager:SetParticleControl( effect_cast, 0, self.center )
ParticleManager:SetParticleControlEnt(effect_cast,1,self.parent,PATTACH_POINT_FOLLOW,"attach_hitloc",self.parent:GetOrigin(),true)
self:AddParticle(effect_cast,false,false,-1,false,false)
end



function modifier_custom_huskar_inner_fire_root:OnIntervalThink()
if not IsServer() then return end
if self.parent:HasModifier("modifier_custom_huskar_inner_fire_legendary_knock") then return end
if self.parent:IsInvulnerable() or self.parent:IsOutOfGame() then return end
if self.parent:IsDebuffImmune() then return end
if  (self.parent:GetAbsOrigin() - self.center):Length2D() <= self.radius then return end
  
self.parent:EmitSound("Huskar.Disarm_Legendary") 

local damage = self.ability:GetDamage()*self.legendary_damage

DoDamage({victim = self.parent, attacker = self.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability}, "modifier_huskar_disarm_7")          

local vec = (self.parent:GetAbsOrigin() - self.center):Normalized()
local knock_point = self.center + vec*self.knock_dist

self.parent:RemoveModifierByName("modifier_custom_huskar_inner_fire_knockback")
self.parent:AddNewModifier(self.caster, self.ability, "modifier_custom_huskar_inner_fire_legendary_knock", {duration = self.knockback_duration, x = knock_point.x, y = knock_point.y})
        
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

self.caster = self:GetCaster()
self.cd = table.cd
self.max = self:GetCaster():GetTalentValue("modifier_huskar_disarm_4", "stack")
self.max_total = self.caster:GetTalentValue("modifier_huskar_disarm_4", "max")
self.time = self:GetRemainingTime()

self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.self_cast = table.self_cast

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end

function modifier_custom_huskar_inner_fire_silence_timer:OnIntervalThink()
if not IsServer() then return end

self.caster:UpdateUIshort({active = self:GetStackCount() >= self.max, max_time = self.time, time = self:GetRemainingTime(), stack = self:GetStackCount(), style = "HuskarInner"})
end

function modifier_custom_huskar_inner_fire_silence_timer:OnDestroy()
if not IsServer() then return end

self.caster:UpdateUIshort({hide = 1, hide_full = 1, style = "HuskarInner"})

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
  MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
}
end

function modifier_custom_huskar_inner_fire_silence_timer:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end 
if self:GetStackCount() >= self.max_total then return end
if self:GetParent() ~= params.attacker then return end 
if not params.target:IsUnit() then return end 


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
if not self:GetParent():HasTalent("modifier_huskar_disarm_3") then return end 

return self:GetCaster():GetStrength()*self:GetCaster():GetTalentValue("modifier_huskar_disarm_3", "health")
end








modifier_custom_huskar_inner_fire_heal = class({})
function modifier_custom_huskar_inner_fire_heal:IsHidden() return false end
function modifier_custom_huskar_inner_fire_heal:IsPurgable() return true end
function modifier_custom_huskar_inner_fire_heal:GetTexture() return "buffs/inner_heal" end
function modifier_custom_huskar_inner_fire_heal:OnCreated(table)

self.parent = self:GetParent()
self.parent:AddDamageEvent_out(self)

self.heal = self:GetCaster():GetTalentValue("modifier_huskar_disarm_2", "lifesteal")/100
self.creeps = self:GetCaster():GetTalentValue("modifier_huskar_disarm_2", "creeps")
self.status = self:GetCaster():GetTalentValue("modifier_huskar_disarm_2", "status")
end

function modifier_custom_huskar_inner_fire_heal:GetEffectName()
return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf"
end

function modifier_custom_huskar_inner_fire_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end

function modifier_custom_huskar_inner_fire_heal:GetModifierStatusResistanceStacking() 
return self.status
end

function modifier_custom_huskar_inner_fire_heal:DamageEvent_out(params)
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

self:GetParent():GenericHeal(heal, self:GetAbility(), true, nil, "modifier_huskar_disarm_2")

end










modifier_custom_huskar_inner_fire_shield = class({})

function modifier_custom_huskar_inner_fire_shield:IsHidden() return true end
function modifier_custom_huskar_inner_fire_shield:IsPurgable() return true end

function modifier_custom_huskar_inner_fire_shield:OnCreated( params )
self.parent = self:GetParent()
self.shield_talent = "modifier_huskar_disarm_1"
self.max_shield = self:GetCaster():GetTalentValue("modifier_huskar_disarm_1", "shield")*self:GetCaster():GetMaxHealth()/100

if not IsServer() then return end
self:SetStackCount(self.max_shield)
end

function modifier_custom_huskar_inner_fire_shield:OnRefresh()
self:OnCreated()
end

function modifier_custom_huskar_inner_fire_shield:DeclareFunctions()
  return 
{
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
}
end


function modifier_custom_huskar_inner_fire_shield:GetModifierIncomingPhysicalDamageConstant(params)

if IsClient() then 
  if params.report_max then 
    return self.max_shield 
  else 
    return self:GetStackCount()
  end 
end


if not IsServer() then return end

if self:GetStackCount() == 0 then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end
