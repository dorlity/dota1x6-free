LinkLuaModifier( "modifier_centaur_hoof_stomp_custom_prepair", "abilities/centaur/centaur_hoof_stomp_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_hoof_stomp_custom_charge", "abilities/centaur/centaur_hoof_stomp_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_hoof_stomp_custom_charge_target", "abilities/centaur/centaur_hoof_stomp_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_hoof_stomp_custom_legendary", "abilities/centaur/centaur_hoof_stomp_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_hoof_stomp_custom_legendary_damage", "abilities/centaur/centaur_hoof_stomp_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_hoof_stomp_custom_attack", "abilities/centaur/centaur_hoof_stomp_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_hoof_stomp_custom_tracker", "abilities/centaur/centaur_hoof_stomp_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_hoof_stomp_custom_damage_reduce", "abilities/centaur/centaur_hoof_stomp_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_hoof_stomp_custom_leash", "abilities/centaur/centaur_hoof_stomp_custom", LUA_MODIFIER_MOTION_NONE )

centaur_hoof_stomp_custom = class({})


function centaur_hoof_stomp_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stomp_charge.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stomp_attack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stomp_crit.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stomp_crit_hit.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", context )

end

function centaur_hoof_stomp_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_centaur_hoof_stomp_custom_tracker"
end

function centaur_hoof_stomp_custom:GetBehavior()
local caster = self:GetCaster()
if caster:HasTalent("modifier_centaur_stomp_5") and not caster:HasModifier("modifier_centaur_hoof_stomp_custom_legendary") then
  return DOTA_ABILITY_BEHAVIOR_POINT
end
local bonus = 0
if caster:HasModifier("modifier_centaur_hoof_stomp_custom_legendary") then
  bonus = DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + bonus
end

function centaur_hoof_stomp_custom:GetManaCost(level)
if self:GetCaster():HasModifier("modifier_centaur_hoof_stomp_custom_legendary") then
  return 0
end
local bonus = 0 
if self:GetCaster():HasTalent("modifier_centaur_stomp_2") then
  bonus = self:GetCaster():GetTalentValue("modifier_centaur_stomp_2", "mana")
end
return self.BaseClass.GetManaCost(self,level) + bonus
end

function centaur_hoof_stomp_custom:GetCooldown(level)
local bonus = 0 
if self:GetCaster():HasTalent("modifier_centaur_stomp_2") then
  bonus = self:GetCaster():GetTalentValue("modifier_centaur_stomp_2", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function centaur_hoof_stomp_custom:GetCastRange(vLocation, hTarget)
local caster = self:GetCaster()
if caster:HasTalent("modifier_centaur_stomp_5") and not caster:HasModifier("modifier_centaur_hoof_stomp_custom_legendary") then
  if IsClient() then
    return caster:GetTalentValue("modifier_centaur_stomp_5", "distance")
  else
    return 999999
  end
end
return self:GetRadius() - caster:GetCastRangeBonus()
end

function centaur_hoof_stomp_custom:GetRadius()
return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_centaur_stomp_5", "radius")
end


function centaur_hoof_stomp_custom:Stomp(is_legendary)
local caster = self:GetCaster()
local radius = self:GetRadius()
local damage = self:GetSpecialValueFor("stomp_damage") + caster:GetTalentValue("modifier_centaur_stomp_1", "damage")*caster:GetAverageTrueAttackDamage(nil)/100
local stun = self:GetSpecialValueFor("stun_duration") + caster:GetTalentValue("modifier_centaur_stomp_3", "stun")
local effect_duration = caster:GetTalentValue("modifier_centaur_stomp_7", "effect_duration", true)
local slow_duration = caster:GetTalentValue("modifier_centaur_stomp_3", "duration", true)
local leash_duration = caster:GetTalentValue("modifier_centaur_stomp_6", "duration", true)


local point = caster:GetAbsOrigin()

local particle_stomp_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl(particle_stomp_fx, 0, point)
ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(radius, radius, radius))
ParticleManager:SetParticleControl(particle_stomp_fx, 2, point)
ParticleManager:SetParticleControl(particle_stomp_fx, 3, point)
ParticleManager:ReleaseParticleIndex(particle_stomp_fx)

caster:EmitSound("Hero_Centaur.HoofStomp")

if is_legendary and is_legendary == 1 then
  stun = caster:GetTalentValue("modifier_centaur_stomp_7", "stun")
  damage = damage * caster:GetTalentValue("modifier_centaur_stomp_7", "damage")/100
end

if caster:HasTalent("modifier_centaur_stomp_7") then
  self:EndCooldown()
  caster:AddNewModifier(caster, self, "modifier_centaur_hoof_stomp_custom_legendary", {})
  self:StartCooldown(caster:GetTalentValue("modifier_centaur_stomp_7", "min_time") - 0.05)
end

local targets = caster:FindTargets(radius, point)
local damageTable = {attacker = caster, ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage}

for _,target in pairs(targets) do
  damageTable.victim = target
  DoDamage(damageTable)

  local stun_duration = stun*(1 - target:GetStatusResistance())

  if not is_legendary or is_legendary == 0 then
    target:RemoveModifierByName("modifier_centaur_hoof_stomp_custom_legendary_damage")

    if caster:HasTalent("modifier_centaur_stomp_3") then
      target:AddNewModifier(caster, self, "modifier_centaur_hoof_stomp_custom_damage_reduce", {duration = stun_duration + slow_duration})
    end
  end

  if caster:HasTalent("modifier_centaur_stomp_7") then
    target:AddNewModifier(caster, self, "modifier_centaur_hoof_stomp_custom_legendary_damage", {duration = effect_duration})
  end

  local stun = target:AddNewModifier(caster, self, "modifier_generic_stun", {duration = stun_duration})

  if target:IsRealHero() and caster:GetQuest() == "Centaur.Quest_5" and not caster:QuestCompleted() then
    caster:UpdateQuest(1)
  end

  if stun and not stun:IsNull() and (not is_legendary or is_legendary == 0) then 
    stun:SetEndRule(function()
      if caster:HasTalent("modifier_centaur_stomp_6") then
        target:AddNewModifier(caster, self, "modifier_centaur_hoof_stomp_custom_leash", {duration = leash_duration})
      end
    end)
  end
end

if #targets > 0 and caster:HasTalent("modifier_centaur_stampede_7") then
  local ability = caster:FindAbilityByName("centaur_stampede_custom")
  if ability and ability:IsTrained() then
    ability:LegendaryStack(caster:GetTalentValue("modifier_centaur_stampede_7", "spells"))
  end
end

if caster:HasTalent("modifier_centaur_stomp_4") then 
  caster:AddNewModifier(caster, self, "modifier_centaur_hoof_stomp_custom_attack", {duration = caster:GetTalentValue("modifier_centaur_stomp_4", "duration", true)})
end

end




function centaur_hoof_stomp_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("windup_time") + caster:GetTalentValue("modifier_centaur_stomp_6", "cast")
self:RefundManaCost()

local mod = caster:FindModifierByName("modifier_centaur_hoof_stomp_custom_legendary")
local is_legendary = 0

if mod and mod.count and mod.line_min and mod.line_max then
  local success = mod.count >= mod.line_min and mod.count <= mod.line_max
  if success == false then
    mod:Destroy()
    return false
  end
  caster:EmitSound("Centaur.Stomp_legendary_cast")
  self:Stomp(1)
  return
end

local distance = 0

if caster:HasTalent("modifier_centaur_stomp_5") then
  local point = self:GetCursorPosition()
  local vec = point - caster:GetAbsOrigin()
  local max = caster:GetTalentValue("modifier_centaur_stomp_5", "distance") + caster:GetCastRangeBonus()

  if point == caster:GetAbsOrigin() then
    point = caster:GetAbsOrigin() + caster:GetForwardVector()*10
  end

  if vec:Length2D() > max then
    point = caster:GetAbsOrigin() + vec:Normalized()*max
  end

  distance = (point - caster:GetAbsOrigin()):Length2D()
  caster:FaceTowards(point)
  caster:SetForwardVector(vec:Normalized())
end


caster:AddNewModifier(caster, self, "modifier_centaur_hoof_stomp_custom_prepair", {distance = distance, duration = duration})
end



modifier_centaur_hoof_stomp_custom_prepair = class({})
function modifier_centaur_hoof_stomp_custom_prepair:IsHidden() return false end
function modifier_centaur_hoof_stomp_custom_prepair:IsPurgable() return false end
function modifier_centaur_hoof_stomp_custom_prepair:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end

self.parent:AddOrderEvent(self)

self.distance = table.distance
self.ability:EndCd()
self.base_time = self.ability:GetSpecialValueFor("windup_time")

local anim_k = self.base_time/self:GetRemainingTime()

if self.parent:HasTalent("modifier_centaur_stomp_5") then
  anim_k = 0.85
  if self.parent:HasTalent("modifier_centaur_stomp_6") then
    anim_k = 0.95
  end
end

self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, anim_k)
self.full_time = self:GetRemainingTime()

self.interval = 0.1

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_centaur_hoof_stomp_custom_prepair:OnIntervalThink()
if not IsServer() then return end

if self.parent:IsStunned() or self.parent:IsHexed() or self.parent:IsSilenced() or self.parent:GetForceAttackTarget() ~= nil then
  self:Destroy()
end

end


function modifier_centaur_hoof_stomp_custom_prepair:OrderEvent( params )

if params.order_type == DOTA_UNIT_ORDER_STOP or 
  params.order_type == DOTA_UNIT_ORDER_HOLD_POSITION or
  params.order_type == DOTA_UNIT_ORDER_CAST_POSITION or 
  params.order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET or 
  params.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE or 
  params.order_type == DOTA_UNIT_ORDER_CAST_TARGET then
  
  self:Destroy()
end

end

function modifier_centaur_hoof_stomp_custom_prepair:OnDestroy()
if not IsServer() then return end

self.ability:StartCd()

if self:GetRemainingTime() >= 0.03 then
  self.ability:EndCooldown()
  local mod = self.parent:FindModifierByName("modifier_centaur_hoof_stomp_custom_legendary")
  if mod then
    mod:Reset()
  end

  self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_1)
  return
end

if self.parent:HasTalent("modifier_centaur_stomp_5") and self.distance > 0 then
  self.parent:EmitSound("Centaur.Stomp_charge1")
  self.parent:EmitSound("Centaur.Stomp_charge2")
  self.parent:EmitSound("Centaur.Stomp_charge3")
  local duration = self.distance/self.parent:GetTalentValue("modifier_centaur_stomp_5", "speed")
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_centaur_hoof_stomp_custom_charge", {distance = self.distance, duration = duration})
else
  self.ability:Stomp(0)
end

self.ability:UseResources(true, false, false, false)
end



modifier_centaur_hoof_stomp_custom_tracker = class({})
function modifier_centaur_hoof_stomp_custom_tracker:IsHidden() return true end
function modifier_centaur_hoof_stomp_custom_tracker:IsPurgable() return false end
function modifier_centaur_hoof_stomp_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_duration = self.parent:GetTalentValue("modifier_centaur_stomp_4", "duration", true)

self.cleave_damage = self.parent:GetTalentValue("modifier_centaur_stomp_4", "cleave", true)/100

self.parent:AddAttackEvent_out(self)
self.parent:AddSpellEvent(self)
end

function modifier_centaur_hoof_stomp_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_centaur_hoof_stomp_custom_tracker:GetModifierDamageOutgoing_Percentage()
if not self.parent:HasTalent("modifier_centaur_stomp_1") then return end
return self.parent:GetTalentValue("modifier_centaur_stomp_1", "attack")
end

function modifier_centaur_hoof_stomp_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local target = params.target

local mod = self.parent:FindModifierByName("modifier_centaur_hoof_stomp_custom_attack")

if mod and mod.max and mod:GetStackCount() >= mod.max then
  local heal = self.parent:GetMaxHealth()*self.parent:GetTalentValue("modifier_centaur_stomp_4", "heal")/100
  self.parent:GenericHeal(heal, self.ability, false, "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", "modifier_centaur_stomp_4")
  target:EmitSound("Centaur.Stomp_crit_attack1")
  target:EmitSound("Centaur.Stomp_crit_attack2")
 
  DoCleaveAttack(self.parent, target,self.ability, params.damage*self.cleave_damage, 150, 360, 650, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")

  local vec = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()

  local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControlEnt( coup_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
  ParticleManager:SetParticleControl( coup_pfx, 1, target:GetOrigin() )
  ParticleManager:SetParticleControlForward( coup_pfx, 1, -vec )
  ParticleManager:ReleaseParticleIndex( coup_pfx )

  local particle_edge_fx = ParticleManager:CreateParticle("particles/centaur/stomp_crit.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
  ParticleManager:SetParticleControlEnt(particle_edge_fx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
  ParticleManager:SetParticleControlForward(particle_edge_fx, 2, vec)
  ParticleManager:ReleaseParticleIndex(particle_edge_fx)

  self.parent:GenericParticle("particles/centaur/stomp_crit_hit.vpcf")

  mod:Destroy()
end

end 

function modifier_centaur_hoof_stomp_custom_tracker:SpellEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if params.ability:IsItem() then return end
if not self.parent:HasTalent("modifier_centaur_stomp_4") then return end
if self.ability == params.ability then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_centaur_hoof_stomp_custom_attack", {duration = self.damage_duration})
end




modifier_centaur_hoof_stomp_custom_charge = class({})
function modifier_centaur_hoof_stomp_custom_charge:IsHidden() return true end
function modifier_centaur_hoof_stomp_custom_charge:IsPurgable() return false end

function modifier_centaur_hoof_stomp_custom_charge:OnCreated(kv)
if not IsServer() then return end

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:AddOrderEvent(self)

self.dt = 0.01
self.aoe = self.parent:GetTalentValue("modifier_centaur_stomp_5", "hit_radius")

self.parent:GenericParticle("particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf", self)
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 0.8)

self.distance = kv.distance/(kv.duration/self.dt)

self.angle = self.parent:GetForwardVector():Normalized()
self.origin = self.parent:GetAbsOrigin()

self.bkb_mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {duration = self:GetRemainingTime() + 1})

self.targets = {}
self:StartIntervalThink(self.dt)
end


function modifier_centaur_hoof_stomp_custom_charge:OnIntervalThink()
if not IsServer() then return end

if self.parent:IsCurrentlyVerticalMotionControlled() or self.parent:IsCurrentlyHorizontalMotionControlled() or self.parent:IsHexed() or self.parent:IsStunned() then 
  self:Destroy()
  return
end

self:Motion()
self:CheckTargets()
end 


function modifier_centaur_hoof_stomp_custom_charge:Motion()
if not IsServer() then return end

local pos = self.parent:GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(pos, 100, false)

local pos_p = self.angle * self.distance
local next_pos = GetGroundPosition(pos + pos_p,self.parent)
self.parent:SetAbsOrigin(next_pos)
end


function modifier_centaur_hoof_stomp_custom_charge:CheckTargets()
if not IsServer() then return end 

local targets = self.parent:FindTargets(self.aoe)

for _,target in pairs(targets) do 
  if not self.targets[target] and target:IsHero() then 
    self.targets[target] = true
    target:EmitSound("Hero_Centaur.Stampede.Stun")
    target:InterruptMotionControllers(false)
    target:AddNewModifier(self.parent, self.ability, "modifier_centaur_hoof_stomp_custom_charge_target", {duration = self:GetRemainingTime() + 0.1})
  end 
end 

local point = self.parent:GetAbsOrigin() + self.parent:GetForwardVector()*60

for target,_ in pairs(self.targets) do
  target:SetAbsOrigin(point)
end

end 


function modifier_centaur_hoof_stomp_custom_charge:OnDestroy()
if not IsServer() then return end

if self.bkb_mod and not self.bkb_mod:IsNull() then
  self.bkb_mod:Destroy()
end

self.parent:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)

local center = self.parent:GetAbsOrigin()
for target,_ in pairs(self.targets) do
  target:RemoveModifierByName("modifier_centaur_hoof_stomp_custom_charge_target")
  FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
  local knockbackProperties =
  {
    center_x = center.x,
    center_y = center.y,
    center_z = center.z,
    duration = 0.25,
    knockback_duration = 0.25,
    knockback_distance = 100,
    knockback_height = 30,
    should_stun = 1,
  }
  target:AddNewModifier( self.parent, self.ability, "modifier_knockback", knockbackProperties )
end

self.ability:Stomp()
end

function modifier_centaur_hoof_stomp_custom_charge:CheckState()
return
{
  [MODIFIER_STATE_ROOTED] = true,
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_SILENCED] = true
}
end

function modifier_centaur_hoof_stomp_custom_charge:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  MODIFIER_PROPERTY_DISABLE_TURNING,
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
}
end

function modifier_centaur_hoof_stomp_custom_charge:GetOverrideAnimation()
return ACT_DOTA_RUN
end

function modifier_centaur_hoof_stomp_custom_charge:GetActivityTranslationModifiers()
return "haste"
end

function modifier_centaur_hoof_stomp_custom_charge:GetModifierDisableTurning()
return 1
end

function modifier_centaur_hoof_stomp_custom_charge:OrderEvent( params )

if params.order_type==DOTA_UNIT_ORDER_STOP or params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION then
  self:Destroy()
end

end

function modifier_centaur_hoof_stomp_custom_charge:GetStatusEffectName()
return "particles/econ/items/invoker/invoker_ti7/status_effect_alacrity_ti7.vpcf"
end

function modifier_centaur_hoof_stomp_custom_charge:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end


modifier_centaur_hoof_stomp_custom_charge_target = class({})
function modifier_centaur_hoof_stomp_custom_charge_target:IsHidden() return true end
function modifier_centaur_hoof_stomp_custom_charge_target:IsPurgable() return false end
function modifier_centaur_hoof_stomp_custom_charge_target:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_centaur_hoof_stomp_custom_charge_target:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end


function modifier_centaur_hoof_stomp_custom_charge_target:CheckState()
return
{
  [MODIFIER_STATE_STUNNED] = true
}
end



modifier_centaur_hoof_stomp_custom_legendary = class({})
function modifier_centaur_hoof_stomp_custom_legendary:IsHidden() return true end
function modifier_centaur_hoof_stomp_custom_legendary:IsPurgable() return false end
function modifier_centaur_hoof_stomp_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.interval = 0.03
self.max_time = self.parent:GetTalentValue("modifier_centaur_stomp_7", "duration")*100
self.min_time = self.parent:GetTalentValue("modifier_centaur_stomp_7", "min_time")*100
self.marker_width = self.parent:GetTalentValue("modifier_centaur_stomp_7", "interval")*100
self.max = self.parent:GetTalentValue("modifier_centaur_stomp_7", "max") + 1

self.ended = false

if not IsServer() then return end
self.RemoveForDuel = true

self:Reset()
self:IncrementStackCount()
self.good_ending = false

if self:GetStackCount() >= self.max then 
  self.good_ending = true
  self:Destroy()
  return
end

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_centaur_hoof_stomp_custom_legendary:OnRefresh(table)
self:OnCreated()
end

function modifier_centaur_hoof_stomp_custom_legendary:Reset()
if not IsServer() then return end
self.count = 0
self.line_time = math.floor(RandomFloat(self.min_time + self.marker_width/2, self.max_time - self.marker_width/2))

if self.last_time then
  while math.abs(self.last_time - self.line_time) < 50 do
    self.line_time = math.floor(RandomFloat(self.min_time + self.marker_width/2, self.max_time - self.marker_width/2))
  end
end

self.last_time = self.line_time
self.line_min = self.line_time - self.marker_width/2
self.line_max = self.line_time + self.marker_width/2
self.line_width = (self.marker_width/self.max_time)*100
self.line_pos = (self.line_min/self.max_time)*100
end

function modifier_centaur_hoof_stomp_custom_legendary:OnIntervalThink()
if not IsServer() then return end
if self.ended == true then return end
if self.parent:HasModifier("modifier_centaur_hoof_stomp_custom_prepair") then return end

self.count = self.count + self.interval*100

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "centaur_stomp",  
{
  stack_icon = self:GetStackCount(),
  max_time = self.max_time,
  time = self.count,
  line_width = self.line_width,
  line_pos = self.line_pos,
})


if self.count >= self.max_time then
  self:Destroy()
  return
end

end

function modifier_centaur_hoof_stomp_custom_legendary:OnDestroy()
if not IsServer() then return end
self.ended = true

if self.good_ending == false then
  self.parent:EmitSound("Centaur.Stomp_legendary_fail2")
  self.parent:EmitSound("Centaur.Stomp_legendary_fail")
end

self.ability:StartCd()
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "centaur_stomp",  
{
  hide = 1
})

end




modifier_centaur_hoof_stomp_custom_legendary_damage = class({})
function modifier_centaur_hoof_stomp_custom_legendary_damage:IsHidden() return false end
function modifier_centaur_hoof_stomp_custom_legendary_damage:IsPurgable() return false end
function modifier_centaur_hoof_stomp_custom_legendary_damage:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.damage = self.caster:GetTalentValue("modifier_centaur_stomp_7", "damage_inc")

if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.particle, 3, self.parent, PATTACH_OVERHEAD_FOLLOW, nil, self.parent:GetAbsOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

self:SetStackCount(1)
end

function modifier_centaur_hoof_stomp_custom_legendary_damage:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_centaur_hoof_stomp_custom_legendary_damage:OnStackCountChanged()
if not IsServer() then return end
if not self.particle then return end

ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetStackCount(), 0, 0))
end


function modifier_centaur_hoof_stomp_custom_legendary_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_centaur_hoof_stomp_custom_legendary_damage:GetModifierIncomingDamage_Percentage()
return self.damage*self:GetStackCount()
end

modifier_centaur_hoof_stomp_custom_attack = class({})
function modifier_centaur_hoof_stomp_custom_attack:IsHidden() return false end
function modifier_centaur_hoof_stomp_custom_attack:IsPurgable() return false end
function modifier_centaur_hoof_stomp_custom_attack:GetTexture() return "buffs/stomp_attack" end
function modifier_centaur_hoof_stomp_custom_attack:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.max = self.parent:GetTalentValue("modifier_centaur_stomp_4", "count")
self.crit = self.parent:GetTalentValue("modifier_centaur_stomp_4", "crit")
self.range = self.parent:GetTalentValue("modifier_centaur_stomp_4", "range")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_centaur_hoof_stomp_custom_attack:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
  self.parent:GenericParticle("particles/centaur/stomp_attack.vpcf", self, true)
  self.parent:EmitSound("Centaur.Stomp_crit_ready")
end

end

function modifier_centaur_hoof_stomp_custom_attack:CheckState()
if self:GetStackCount() < self.max then return end
return
{
  [MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_centaur_hoof_stomp_custom_attack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_centaur_hoof_stomp_custom_attack:GetModifierAttackRangeBonus()
if self:GetStackCount() < self.max then return end
return self.range
end

function modifier_centaur_hoof_stomp_custom_attack:GetModifierPreAttack_CriticalStrike()
if self:GetStackCount() < self.max then return end
return self.crit
end

function modifier_centaur_hoof_stomp_custom_attack:GetCritDamage()
if self:GetStackCount() < self.max then return end
return self.crit
end



modifier_centaur_hoof_stomp_custom_damage_reduce = class({})
function modifier_centaur_hoof_stomp_custom_damage_reduce:IsHidden() return false end
function modifier_centaur_hoof_stomp_custom_damage_reduce:IsPurgable() return false end
function modifier_centaur_hoof_stomp_custom_damage_reduce:GetTexture() return "buffs/dismember_damage" end
function modifier_centaur_hoof_stomp_custom_damage_reduce:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.damage_reduce = self.caster:GetTalentValue("modifier_centaur_stomp_3", "damage_reduce")

if not IsServer() then return end
self.parent:GenericParticle("particles/items2_fx/sange_maim.vpcf", self)
self.parent:GenericParticle("particles/items2_fx/sange_maim.vpcf", self)
end

function modifier_centaur_hoof_stomp_custom_damage_reduce:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_centaur_hoof_stomp_custom_damage_reduce:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_centaur_hoof_stomp_custom_damage_reduce:GetModifierSpellAmplify_Percentage()
return self.damage_reduce
end






modifier_centaur_hoof_stomp_custom_leash = class({})
function modifier_centaur_hoof_stomp_custom_leash:IsHidden() return true end
function modifier_centaur_hoof_stomp_custom_leash:IsPurgable() return true end
function modifier_centaur_hoof_stomp_custom_leash:GetEffectName() return "particles/lina_attack_slow.vpcf" end

function modifier_centaur_hoof_stomp_custom_leash:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_centaur_hoof_stomp_custom_leash:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_centaur_hoof_stomp_custom_leash:GetModifierAttackSpeedBonus_Constant()
return self.attack
end

function modifier_centaur_hoof_stomp_custom_leash:OnCreated()
self.caster = self:GetCaster()
self.move = self.caster:GetTalentValue("modifier_centaur_stomp_6", "slow")
self.attack = self.caster:GetTalentValue("modifier_centaur_stomp_6", "attack")
end

function modifier_centaur_hoof_stomp_custom_leash:CheckState()
return
{
  [MODIFIER_STATE_TETHERED] = true
}
end



