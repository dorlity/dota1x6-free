LinkLuaModifier("modifier_custom_juggernaut_omnislash", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_tracker", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omnislash_cd", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_effect", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_root", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_mark", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_attacks", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_attacks_damage", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_move", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_shield", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_omnislash_shield_timer", "abilities/juggernaut/custom_juggernaut_omnislash.lua", LUA_MODIFIER_MOTION_NONE)


custom_juggernaut_omnislash = class({})


function custom_juggernaut_omnislash:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_omnislash.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt_scepter.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail_scepter.vpcf", context )
PrecacheResource( "particle", "particles/jugg_omni_aoe.vpcf", context )
PrecacheResource( "particle", "particles/jugger_stack.vpcf", context )
PrecacheResource( "particle", "particles/jugg_omni_proc.vpcf", context )
PrecacheResource( "particle", "particles/beast_root.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_huskar_lifebreak.vpcf", context )

end


function custom_juggernaut_omnislash:TgtParticle()
local part = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt.vpcf"

if self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
  part = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_arcana") then
  part = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
  part = "particles/econ/items/juggernaut/bladekeeper_omnislash/_dc_juggernaut_omni_slash_tgt.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_item_custom_serrakura") then
  part = "particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_tgt_serrakura.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladeform") then
  part = "particles/econ/items/juggernaut/pw_blossom_sword/juggernaut_omni_slash_tgt.vpcf"
end
return part
end


function custom_juggernaut_omnislash:TrailParticle()
local part = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail.vpcf"

if self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
  part = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_arcana") then
  part = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_trail.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
  part = "particles/econ/items/juggernaut/bladekeeper_omnislash/_dc_juggernaut_omni_slash_trail.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_item_custom_serrakura") then
  part = "particles/econ/items/juggernaut/jugg_serrakura/juggernaut_omni_slash_trail_serrakura.vpcf"
elseif self:GetCaster():HasModifier("modifier_juggernaut_bladeform") then
  part = "particles/econ/items/juggernaut/pw_blossom_sword/juggernaut_omni_slash_trail.vpcf"
end
return part
end




function custom_juggernaut_omnislash:HitEffect(enemy, scepter)

local effect = self:TgtParticle()
if scepter == 1 then 
  effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_tgt_scepter.vpcf" 
end

if (self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") or self:GetCaster():HasModifier("modifier_juggernaut_arcana")) and scepter == 0 then 
  local particle = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, enemy )
  ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt( particle, 1, enemy, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex(particle)
else 
  local particle = ParticleManager:CreateParticle( effect, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
  ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_sword", self:GetCaster():GetAbsOrigin(), true )
  ParticleManager:SetParticleControl( particle, 1, self:GetCaster():GetAbsOrigin() )
  ParticleManager:ReleaseParticleIndex(particle)
end

end 





function custom_juggernaut_omnislash:GetAbilityTextureName()
if not self:GetCaster() then return end
if self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
    return "juggernaut/bladekeeper/juggernaut_omni_slash"
end
if self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
    return "juggernaut_omni_slash_arcana"
end
return "juggernaut_omni_slash"
end





function custom_juggernaut_omnislash:GetCastPoint()

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_aoe_attack") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_aoe_attack", "cast")
end

return self:GetSpecialValueFor("AbilityCastPoint")
end


function custom_juggernaut_omnislash:GetCooldown(iLevel)
local k = 1 
local bonus = 0 

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_stack") then 
  bonus = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_stack", "cd")
end

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  k = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "cd")/100
end

return (self.BaseClass.GetCooldown(self, iLevel) + bonus) * k
end



function custom_juggernaut_omnislash:GetBehavior()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then
  return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK  
end

return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end



function custom_juggernaut_omnislash:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  if IsClient() or hTarget ~= nil then 
    return self:GetRange()
  end
  return 999999
end

return self:GetRange()
end



function custom_juggernaut_omnislash:GetIntrinsicModifierName()
if self:GetCaster():IsRealHero() then  
  return "modifier_custom_juggernaut_omnislash_tracker" 
end

end


function custom_juggernaut_omnislash:GetRange()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_aoe_attack") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_aoe_attack", "range")
end

return self:GetSpecialValueFor("AbilityCastRange")
end



function custom_juggernaut_omnislash:OnSpellStart(new_target)
  
local target = self:GetCursorTarget()

if new_target then 
  target = new_target
end


self:Cast(self, target, self:GetCursorPosition())
end





function custom_juggernaut_omnislash:Cast(ability, target, point)

self:GetCaster():EmitSound("Hero_Juggernaut.OmniSlash")

self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_omnislash")

local scepter = 0
local trail = self:TrailParticle()
if ability:GetName() == "custom_juggernaut_swift_slash" then 
  scepter = 1
  trail = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail_scepter.vpcf"
end   


if scepter == 0 and (self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2")) then 

  local name = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_dash.vpcf"
  if self:GetCaster():HasModifier("modifier_juggernaut_arcana") then 
    name = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_dash.vpcf"
  end 

  local hParent = self:GetCaster()

  local point
  if target then
    point = target:GetAbsOrigin()
  else 
    point = self:GetCursorPosition()
  end 

  local vDirection = point - hParent:GetAbsOrigin()
  vDirection.z = 0
  local vPosition =  point + vDirection:Normalized() * (hParent:GetHullRadius() + 70)

  local iParticleID = ParticleManager:CreateParticle(name, PATTACH_CUSTOMORIGIN, hParent)
  ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
  ParticleManager:SetParticleControlForward(iParticleID, 0, -vDirection:Normalized())

  if target then 
    ParticleManager:SetParticleControlEnt(iParticleID, 1, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(iParticleID, 2, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
  else 

    ParticleManager:SetParticleControl(iParticleID, 1, point)
    ParticleManager:SetParticleControl(iParticleID, 2, point)
  end

  ParticleManager:ReleaseParticleIndex(iParticleID)
end 



if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") and not target then 
    
  local point = self:GetCursorPosition()
  local distance = (point - self:GetCaster():GetAbsOrigin())
  local range = ability:GetRange()  + self:GetCaster():GetCastRangeBonus()

  if distance:Length2D() > range then 
    point = self:GetCaster():GetAbsOrigin() + distance:Normalized()*range
  end 

  local particle = ParticleManager:CreateParticle(trail, PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle, 1, point)
  ParticleManager:ReleaseParticleIndex(particle)

  FindClearSpaceForUnit(self:GetCaster(), point, false)

  self:GetCaster():GiveMana(ability:GetManaCost(ability:GetLevel()))

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_omnislash_effect", {duration = 0.5})
  return
end


self:GetCaster():Purge(false, true, false, false, false)
self.duration = ability:GetSpecialValueFor("duration")

if scepter == 0 then 

  self.duration = self.duration + self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_stack", "duration")

  if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
    self.duration = self.duration * self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_legendary", "cd")/100
  end 
end

if self:GetCaster():IsIllusion() then 
  self.duration = 1
end 


self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_omnislash_shield")
self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_omnislash_shield_timer")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_omnislash", {duration = self.duration, target = target:entindex(), scepter = scepter})

end





modifier_custom_juggernaut_omnislash = class({})

function modifier_custom_juggernaut_omnislash:IsPurgable() return false end

function modifier_custom_juggernaut_omnislash:OnCreated(table)

self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.speed = self:GetAbility():GetSpecialValueFor("speed")
self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.bonusrate = self:GetAbility():GetSpecialValueFor("bonus_rate")

self.ishitting = false
self.lastenemy = nil
self.root_target = nil

self.count = 0

self.parent = self:GetParent()

self.root = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_aoe_attack", "root", true)

if not IsServer() then return end 

self.scepter = table.scepter
self:SetStackCount(self.scepter)
self.target = EntIndexToHScript(table.target)

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_cd") then 
  self.target:RemoveModifierByName("modifier_custom_juggernaut_omnislash_mark")
  self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_omnislash_mark", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_cd", "duration")})
end

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_speed") then 
  self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_omnislash_attacks", {scepter = self.scepter, duration = 1})
end  


self.juggernaut_tgt_particle = self:GetAbility():TgtParticle()
self.juggernaut_trail_particle = self:GetAbility():TrailParticle()


self.ability = self:GetAbility()
if self.scepter == 1 and self.parent:HasAbility("custom_juggernaut_swift_slash") then 
  self.ability = self.parent:FindAbilityByName("custom_juggernaut_swift_slash")
end 

self.turn = self:GetCaster():GetForwardVector()

self.fury = self:GetParent():FindAbilityByName("custom_juggernaut_blade_fury")
if self.fury then  
  self.fury:SetActivated(false) 
end 

self.crit = self:GetParent():FindAbilityByName("custom_juggernaut_blade_dance")

if self.crit and self:GetParent():HasModifier("modifier_juggernaut_bladedance_legendary") then  
  self.crit:SetActivated(false) 
end 

self.end_interval = 0.15

self.rate = (1/self:GetParent():GetAttacksPerSecond(true))/self.bonusrate
self:OnIntervalThink()
self:StartIntervalThink(self.rate)    
end

 

function modifier_custom_juggernaut_omnislash:CheckState()
local state = {
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_MAGIC_IMMUNE] = true,
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_ROOTED] = true,
}

return state
end


function modifier_custom_juggernaut_omnislash:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
}
end



function modifier_custom_juggernaut_omnislash:GetModifierIgnoreCastAngle()
return 1
end

function modifier_custom_juggernaut_omnislash:GetModifierAttackSpeedBonus_Constant()
return self.speed 
end

function modifier_custom_juggernaut_omnislash:GetModifierPreAttack_BonusDamage() 
return self.damage 
end


function modifier_custom_juggernaut_omnislash:StatusEffectPriority()
return 999999
end


function modifier_custom_juggernaut_omnislash:GetStatusEffectName()
if self:GetStackCount() == 0 then 

  if self:GetParent():HasModifier("modifier_juggernaut_arcana") then 
    return "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_omni.vpcf"
  end 

  if self:GetParent():HasModifier("modifier_juggernaut_arcana_v2") then 
    return "particles/econ/items/juggernaut/jugg_arcana/status_effect_jugg_arcana_v2_omni.vpcf"
  end 

  return "particles/status_fx/status_effect_omnislash.vpcf"
else 
  return "particles/status_fx/status_effect_swiftslash.vpcf"
end 

end 


function modifier_custom_juggernaut_omnislash:OnIntervalThink()
if not IsServer() then return end


if self.scepter == 0 then 
  self.parent:RemoveModifierByName("modifier_custom_juggernaut_omnislash_shield_timer")
end 


self.rate = (1/self:GetParent():GetAttacksPerSecond(true))/self.bonusrate
self.count = self.count + 1

local enemy = nil
local final = self.target == nil

if self.target and not self.target:IsNull() and self.target:IsAlive() and not self.target:IsOutOfGame() and ((self.target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.radius or self.count == 1) then 
  enemy = self.target
end 

if enemy == nil then 

  local targets = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
      
  for _,target in pairs(targets) do
    enemy = target
    break
  end
end 

if enemy ~= nil then 

  self.target = enemy

  self:PlayEffect(enemy)
  local linken = false 
  if self.count == 1 and self.parent:GetName() == "npc_dota_hero_juggernaut" then 
    if enemy:TriggerSpellAbsorb(self:GetAbility()) then 
      linken = true
    end
  end

  if self.count == 1 and self.scepter == 0 and self.parent:HasModifier("modifier_juggernaut_omnislash_aoe_attack") then 
    local particle = ParticleManager:CreateParticle("particles/jugger_stack.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy )
    ParticleManager:SetParticleControl( particle, 2, enemy:GetAbsOrigin() + Vector(0,0,-100))
    ParticleManager:SetParticleControl( particle, 3, enemy:GetAbsOrigin() )
    ParticleManager:ReleaseParticleIndex(particle)
    enemy:EmitSound("PBeast.Uproar_root")
    enemy:AddNewModifier(self.parent, self:GetAbility(), "modifier_custom_juggernaut_omnislash_root", {duration = (1 - enemy:GetStatusResistance())*self.root})
  end 

  if linken == false then
    self.parent:PerformAttack(enemy, true, true, true, false, false, false, false)
    enemy:EmitSound("Hero_Juggernaut.OmniSlash")
  end
else 
  if final == true then 
    self:Destroy()
    return
  end 

  self.target = nil
  self:StartIntervalThink(self.end_interval)
  return
end 

self:StartIntervalThink(self.rate) 
end



function modifier_custom_juggernaut_omnislash:PlayEffect(enemy)

self.parent:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
self.parent:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_4)

local position1 = self.parent:GetAbsOrigin()

if self.count%2 ~= 0 then       
  FindClearSpaceForUnit(self.parent, (enemy:GetAbsOrigin() - (self.turn)*70), false)
else 
  FindClearSpaceForUnit(self.parent, (enemy:GetAbsOrigin() + (self.turn)*70), false)   
end

local position2 = self.parent:GetAbsOrigin()

if self.count ~= 1 then  
  local angel = (enemy:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
  angel.z = 0 
  self.parent:SetForwardVector(angel)
  self.parent:FaceTowards(enemy:GetAbsOrigin())
end

self:GetAbility():HitEffect(enemy, self.scepter)

effect = self.juggernaut_trail_particle
if self.scepter == 1 then 
  effect = "particles/units/heroes/hero_juggernaut/juggernaut_omni_slash_trail_scepter.vpcf" 
end

local trail_pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN, self.parent)
ParticleManager:SetParticleControl(trail_pfx, 0, position1)
ParticleManager:SetParticleControl(trail_pfx, 1, position2)
ParticleManager:ReleaseParticleIndex(trail_pfx)

end




function modifier_custom_juggernaut_omnislash:OnDestroy()
if not IsServer() then return end

if self.parent:HasModifier("modifier_juggernaut_arcana") then 
  local arcana_particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_end.vpcf", PATTACH_POINT_FOLLOW, self.parent )
  ParticleManager:SetParticleControlEnt(  arcana_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt(  arcana_particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex(arcana_particle)
end 
  

if self.parent:HasModifier("modifier_juggernaut_arcana_v2") then 
  local arcana_particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_end.vpcf", PATTACH_POINT_FOLLOW, self.parent )
  ParticleManager:SetParticleControlEnt(  arcana_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt(  arcana_particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex(arcana_particle)
end 
  

if self.fury then
  self.fury:SetActivated(true) 
end

if self.crit then 
  self.crit:SetActivated(true)
end 


self.parent:FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
self.parent:MoveToPositionAggressive(self.parent:GetAbsOrigin())

end








modifier_custom_juggernaut_omnislash_tracker = class({})

function modifier_custom_juggernaut_omnislash_tracker:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_tracker:IsPurgable() return false end 

function modifier_custom_juggernaut_omnislash_tracker:DeclareFunctions()
return 
{
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    MODIFIER_PROPERTY_MOVESPEED_MAX,
    MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
}

end

function modifier_custom_juggernaut_omnislash_tracker:GetModifierIgnoreMovespeedLimit( params )
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_clone") then 
  return 1
end
  return 0
end

function modifier_custom_juggernaut_omnislash_tracker:GetModifierMoveSpeed_Max( params )
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_clone") then 
  return self.max_move
end

return 
end

function modifier_custom_juggernaut_omnislash_tracker:GetModifierMoveSpeed_Limit()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_clone") then 
  return self.max_move
end

return 
end



function modifier_custom_juggernaut_omnislash_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_clone") then 
  self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_omnislash_move", {duration = self.speed_duration})
end 

if not self:GetParent():HasScepter() then return end
if not self:GetParent():HasModifier("modifier_juggernaut_omnislash_legendary") then return end

self:GetCaster():CdAbility(self:GetAbility(), self.cd_inc)

if self.scepter_ability then 
  self:GetCaster():CdAbility(self.scepter_ability, self.cd_inc)
end 

end



function modifier_custom_juggernaut_omnislash_tracker:OnCreated()

self.speed_duration = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_clone", "duration", true)
self.max_move = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_clone", "max_move", true)

self.shield_timer = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_heal", "timer", true)

self.scepter_ability = self:GetCaster():FindAbilityByName("custom_juggernaut_swift_slash")
self.cd_inc = self:GetAbility():GetSpecialValueFor("scepter_cd")
self.parent = self:GetParent()

self:StartIntervalThink(1)
end



function modifier_custom_juggernaut_omnislash_tracker:OnIntervalThink()
if not IsServer() then return end 
if not self.parent:HasModifier("modifier_juggernaut_omnislash_heal") then return end 
if self.parent:HasModifier("modifier_custom_juggernaut_omnislash_shield") then return end 
if self.parent:HasModifier("modifier_custom_juggernaut_omnislash_shield_timer") then return end 

self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_custom_juggernaut_omnislash_shield_timer", {duration = self.shield_timer})

self:StartIntervalThink(0.1)
end 



custom_juggernaut_swift_slash = class({})


function custom_juggernaut_swift_slash:GetCastPoint()

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_aoe_attack") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_aoe_attack", "cast")
end

return self:GetSpecialValueFor("AbilityCastPoint")
end


function custom_juggernaut_swift_slash:GetBehavior()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then
  return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK  
end

return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end

function custom_juggernaut_swift_slash:GetRange()
if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_aoe_attack") then 
  return self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_aoe_attack", "range")
end

return self:GetSpecialValueFor("AbilityCastRange")
end


function custom_juggernaut_swift_slash:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary") then 
  if IsClient() or hTarget ~= nil then 
    return self:GetRange()
  end
  return 999999
end

return self:GetRange()
end


function custom_juggernaut_swift_slash:OnInventoryContentsChanged()
if (self:GetCaster():HasScepter() or self:GetCaster():HasModifier("modifier_juggernaut_omnislash_legendary")) and self:GetCaster():GetUnitName() == "npc_dota_hero_juggernaut" then
  self:SetHidden(false)        
else
  self:SetHidden(true)
end

end


function custom_juggernaut_swift_slash:OnHeroCalculateStatBonus()
self:OnInventoryContentsChanged()
end



function custom_juggernaut_swift_slash:OnSpellStart(new_target)
local ability = self:GetCaster():FindAbilityByName("custom_juggernaut_omnislash")

if not ability then return end 

local target = self:GetCursorTarget()

if new_target then 
  target = new_target
end

ability:Cast(self, target, self:GetCursorPosition())
end


















modifier_custom_juggernaut_omnislash_effect = class({})
function modifier_custom_juggernaut_omnislash_effect:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_effect:IsPurgable() return false end

function modifier_custom_juggernaut_omnislash_effect:StatusEffectPriority()
return 20
end

function modifier_custom_juggernaut_omnislash_effect:GetStatusEffectName()
return "particles/status_fx/status_effect_omnislash.vpcf"
end


function modifier_custom_juggernaut_omnislash_effect:OnCreated(table)
if not IsServer() then return end
self:GetParent():StartGesture(ACT_DOTA_SPAWN_STATUE)
self.pos = self:GetParent():GetAbsOrigin()
self.fade = false
self:StartIntervalThink(0.1)
end

function modifier_custom_juggernaut_omnislash_effect:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():GetAbsOrigin() ~= self.pos then 
  self.fade = true 
  self:GetParent():FadeGesture(ACT_DOTA_SPAWN_STATUE)
end

end

function modifier_custom_juggernaut_omnislash_effect:OnDestroy()
if not IsServer() then return end
if self.fade == true then return end
self:GetParent():FadeGesture(ACT_DOTA_SPAWN_STATUE)
end
      
    




modifier_custom_juggernaut_omnislash_root = class({})
function modifier_custom_juggernaut_omnislash_root:IsPurgable() return true end
function modifier_custom_juggernaut_omnislash_root:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_root:CheckState()
return
{
  [MODIFIER_STATE_ROOTED] = true
}
end

function modifier_custom_juggernaut_omnislash_root:GetEffectName()
return "particles/beast_root.vpcf"
end








modifier_custom_juggernaut_omnislash_mark = class({})

function modifier_custom_juggernaut_omnislash_mark:IsHidden() return false end
function modifier_custom_juggernaut_omnislash_mark:IsPurgable() return false end
function modifier_custom_juggernaut_omnislash_mark:GetTexture() return  "buffs/Blade_dance_mortal" end

function modifier_custom_juggernaut_omnislash_mark:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_cd", "damage")
self.max = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_cd", "max")
self.heal = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_cd", "heal")/100

if not IsServer() then return end
self:SetStackCount(0)
end


function modifier_custom_juggernaut_omnislash_mark:OnDestroy()
if not IsServer() then return end

local trail_pfx2 = ParticleManager:CreateParticle("particles/jugg_legendary_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:ReleaseParticleIndex(trail_pfx2)

local trail_pfx = ParticleManager:CreateParticle("particles/items3_fx/iron_talon_active.vpcf", PATTACH_ABSORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(trail_pfx, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt( trail_pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(trail_pfx)

self:GetParent():EmitSound("DOTA_Item.Daedelus.Crit")
local real_damage = ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage*self:GetStackCount(), damage_type = DAMAGE_TYPE_PURE})

self:GetCaster():GenericHeal(self.damage*self.heal*self:GetStackCount(), self:GetAbility())
end


function modifier_custom_juggernaut_omnislash_mark:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_EVENT_ON_ATTACK_LANDED
} 
end

function modifier_custom_juggernaut_omnislash_mark:OnTooltip()
return self.damage*self:GetStackCount()
end

function modifier_custom_juggernaut_omnislash_mark:OnAttackLanded(params)
if not IsServer() then return end 
if self:GetParent() ~= params.target or self:GetCaster() ~= params.attacker then return end 

self:IncrementStackCount()
end 





modifier_custom_juggernaut_omnislash_attacks = class({})
function modifier_custom_juggernaut_omnislash_attacks:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_attacks:IsPurgable() return false end
function modifier_custom_juggernaut_omnislash_attacks:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_custom_juggernaut_omnislash_attacks:OnCreated(table)
self.max = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_speed", "max")
self.interval = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_speed", "interval")

if not IsServer() then return end 
self.scepter = table.scepter

self:SetStackCount(self.max)
self:StartIntervalThink(self.interval)
end 

function modifier_custom_juggernaut_omnislash_attacks:OnIntervalThink()
if not IsServer() then return end

self:DecrementStackCount()

if not self:GetParent():IsNull() and self:GetParent():IsAlive() and not self:GetCaster():IsNull() and self:GetCaster():IsAlive() then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), 'modifier_custom_juggernaut_omnislash_attacks_damage', {})
  self:GetCaster():PerformAttack(self:GetParent(), true, true, true, true, false, false, true)
  self:GetAbility():HitEffect(self:GetParent(), self.scepter)

  self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_omnislash_attacks_damage")
end 

if self:GetStackCount() <= 0 then 
  self:Destroy()
end 

end 


modifier_custom_juggernaut_omnislash_attacks_damage = class({})
function modifier_custom_juggernaut_omnislash_attacks_damage:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_attacks_damage:IsPurgable() return false end
function modifier_custom_juggernaut_omnislash_attacks_damage:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_speed", "damage") - 100
end

function modifier_custom_juggernaut_omnislash_attacks_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end


function modifier_custom_juggernaut_omnislash_attacks_damage:GetModifierDamageOutgoing_Percentage()
return self.damage
end


modifier_custom_juggernaut_omnislash_move = class({})
function modifier_custom_juggernaut_omnislash_move:IsHidden() return false end
function modifier_custom_juggernaut_omnislash_move:IsPurgable() return false end
function modifier_custom_juggernaut_omnislash_move:GetTexture() return "buffs/omni_speed" end
function modifier_custom_juggernaut_omnislash_move:OnCreated()

self.move = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_clone", "move")
self.max = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_clone", "max")
self.cdr = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_clone", "cdr")
self:SetStackCount(1)
end 

function modifier_custom_juggernaut_omnislash_move:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
  local effect_cast = ParticleManager:CreateParticle( "particles/juggernaut/crit_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
  ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin()) 
  self:AddParticle( effect_cast, false, false, -1, false, false )
end 


end

function modifier_custom_juggernaut_omnislash_move:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end

function modifier_custom_juggernaut_omnislash_move:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self.move
end

function modifier_custom_juggernaut_omnislash_move:GetModifierPercentageCooldown() 
if self:GetStackCount() < self.max then return end
return self.cdr
end
   









modifier_custom_juggernaut_omnislash_shield = class({})
function modifier_custom_juggernaut_omnislash_shield:IsHidden() return true end
function modifier_custom_juggernaut_omnislash_shield:IsPurgable() return false end
function modifier_custom_juggernaut_omnislash_shield:OnCreated(table)

self.max_shield = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_heal", "shield")*self:GetCaster():GetMaxHealth()/100
self.timer = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_heal", "timer")

if not IsServer() then return end
self.RemoveForDuel = true
self.caster = self:GetCaster()
self:SetStackCount(self.max_shield)
end

function modifier_custom_juggernaut_omnislash_shield:GetEffectName() return "particles/bristleback/armor_buff.vpcf" end

function modifier_custom_juggernaut_omnislash_shield:OnIntervalThink()
self:OnCreated()
self:StartIntervalThink(-1)
end 

function modifier_custom_juggernaut_omnislash_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_custom_juggernaut_omnislash_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
      return self:GetStackCount()
    end 
end

if not IsServer() then return end
if self:GetParent() == params.attacker then return end

self:GetParent():EmitSound("Juggernaut.Parry")
local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )

self:StartIntervalThink(self.timer)

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage

    return -i
else
    
    local i = self:GetStackCount()

    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end




modifier_custom_juggernaut_omnislash_shield_timer = class({})
function modifier_custom_juggernaut_omnislash_shield_timer:IsHidden() return false end
function modifier_custom_juggernaut_omnislash_shield_timer:IsPurgable() return false end
function modifier_custom_juggernaut_omnislash_shield_timer:IsDebuff() return true end
function modifier_custom_juggernaut_omnislash_shield_timer:GetTexture() return "buffs/jugg_shield" end
function modifier_custom_juggernaut_omnislash_shield_timer:OnDestroy()
if not IsServer() then return end 

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_juggernaut_omnislash_shield", {})
end 

function modifier_custom_juggernaut_omnislash_shield_timer:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_custom_juggernaut_omnislash_shield_timer:OnTakeDamage(params)
if not IsServer() then return end 
if self:GetParent() ~= params.unit then return end 
if not params.attacker then return end 
if self:GetParent() == params.attacker then return end 

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), self:GetName(), {duration = self.shield_timer})
end


function modifier_custom_juggernaut_omnislash_shield_timer:OnCreated()

self.shield_timer = self:GetCaster():GetTalentValue("modifier_juggernaut_omnislash_heal", "timer", true)
end