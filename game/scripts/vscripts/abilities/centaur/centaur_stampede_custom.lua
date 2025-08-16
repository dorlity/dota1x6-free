LinkLuaModifier( "modifier_centaur_stampede_custom", "abilities/centaur/centaur_stampede_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_stampede_custom_slow", "abilities/centaur/centaur_stampede_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_stampede_custom_tracker", "abilities/centaur/centaur_stampede_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_stampede_custom_legendary_thinker", "abilities/centaur/centaur_stampede_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_stampede_custom_legendary_unit", "abilities/centaur/centaur_stampede_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_stampede_custom_legendary_stack", "abilities/centaur/centaur_stampede_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_stampede_custom_str_reduce", "abilities/centaur/centaur_stampede_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_stampede_custom_distance_hit", "abilities/centaur/centaur_stampede_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_stampede_custom_recast", "abilities/centaur/centaur_stampede_custom", LUA_MODIFIER_MOTION_NONE )

centaur_stampede_custom = class({})

function centaur_stampede_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_stampede_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_stampede_cast.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/leashed.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_charge_active.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stampede_vector.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stampede_legendary_start.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stampede_legendary_end.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stampede_legendary_cast.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stomp_legendary_stack.vpcf", context )
PrecacheResource( "particle", "particles/centaur/stampede_hit.vpcf", context )

end

function centaur_stampede_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_centaur_stampede_custom_tracker"
end

function centaur_stampede_custom:GetManaCost(level)
if self:GetCaster():HasTalent("modifier_centaur_stampede_5") then
  return 0
end
return self.BaseClass.GetManaCost(self,level)
end

function centaur_stampede_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasTalent("modifier_centaur_stampede_5") then
  bonus = DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + bonus
end

function centaur_stampede_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_centaur_stampede_3") then
  bonus = self:GetCaster():GetTalentValue("modifier_centaur_stampede_3", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end


function centaur_stampede_custom:LegendaryUI()
if not IsServer() then return end
local mod = self:GetCaster():FindModifierByName("modifier_centaur_stampede_custom_tracker")
if mod then
  mod:UpdateUI()
end

end


function centaur_stampede_custom:LegendaryStack(count)
local caster = self:GetCaster()
local ability = caster:FindAbilityByName("centaur_stampede_custom_legendary")

if not caster:HasTalent("modifier_centaur_stampede_7") then return end
if not ability then return end
if ability:GetCooldownTimeRemaining() > 0 then return end

local mod = caster:FindModifierByName("modifier_centaur_stampede_custom_tracker")

for i = 1,count do
  caster:AddNewModifier(caster, self, "modifier_centaur_stampede_custom_legendary_stack", {duration = caster:GetTalentValue("modifier_centaur_stampede_7", "stack_duration", true)})
end

end

function centaur_stampede_custom:DealDamage(target, damage_ability)
local caster = self:GetCaster()
local damage_str = self:GetSpecialValueFor("strength_damage") + caster:GetTalentValue("modifier_centaur_stampede_1", "str")/100
local slow_duration = self:GetSpecialValueFor("slow_duration")
local damage = damage_str*caster:GetStrength()

if damage_ability == "modifier_centaur_stampede_7" then
  damage = damage * caster:GetTalentValue("modifier_centaur_stampede_7", "damage")/100
end

if caster:HasTalent("modifier_centaur_stampede_1") then
  target:AddNewModifier(caster, self, "modifier_centaur_stampede_custom_str_reduce", {duration = caster:GetTalentValue("modifier_centaur_stampede_1", "duration")})
end

if not caster:HasTalent("modifier_centaur_stampede_6") then
  slow_duration = slow_duration*(1 - target:GetStatusResistance())
else
  target:AddNewModifier(caster, caster:BkbAbility(self, caster:HasTalent("modifier_centaur_stampede_6")), "modifier_generic_break", {duration = slow_duration})
end

target:AddNewModifier(caster, caster:BkbAbility(self, caster:HasTalent("modifier_centaur_stampede_6")), "modifier_centaur_stampede_custom_slow", {duration = slow_duration})
DoDamage({attacker = caster, ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage, victim = target}, damage_ability)
end


function centaur_stampede_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_centaur_stampede_4", "duration")
local mod = caster:FindModifierByName("modifier_centaur_stampede_custom_recast")

self:EndCd()

if mod then
  caster:EmitSound("Centaur.Stampede_bkb")
  caster:AddNewModifier(caster, self, "modifier_generic_debuff_immune", {duration = caster:GetTalentValue("modifier_centaur_stampede_5", "bkb"), effect = 1})
  mod:Destroy()
  return
end

local targets = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false )

caster:EmitSound("Hero_Centaur.Stampede.Cast")
caster:StartGesture(ACT_DOTA_CENTAUR_STAMPEDE)

if caster:HasTalent("modifier_centaur_stampede_5") then
  caster:Purge(false, true, false, true, false)
  caster:AddNewModifier(caster, self, "modifier_centaur_stampede_custom_recast", {duration = duration})
  self:SetActivated(true)
  self:StartCooldown(0.2)
end

for _,target in pairs(targets) do
  target:AddNewModifier(caster, self, "modifier_centaur_stampede_custom", {duration = duration})
end

end


modifier_centaur_stampede_custom = class({})
function modifier_centaur_stampede_custom:IsHidden() return false end
function modifier_centaur_stampede_custom:IsPurgable() return false end
function modifier_centaur_stampede_custom:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.speed = 100
self.distance_pass = 0

if self.caster:HasScepter() and self.caster == self.parent then
  self.speed = self.ability:GetSpecialValueFor("scepter_stampede")
end

self.damage_reduce = self.caster:GetTalentValue("modifier_centaur_stampede_3", "damage_reduce")

self.distance_max = self.caster:GetTalentValue("modifier_centaur_stampede_4", "distance")
self.hit_radius = self.caster:GetTalentValue("modifier_centaur_stampede_4", "radius")
self.pos = self.parent:GetAbsOrigin()

if not IsServer() then return end
self.parent:EmitSound("Hero_Centaur.Stampede.Movement")
self.parent:GenericParticle("particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf", self, true)
self.parent:GenericParticle("particles/units/heroes/hero_centaur/centaur_stampede.vpcf", self)
self.parent:GenericParticle("particles/units/heroes/hero_centaur/centaur_stampede_cast.vpcf")

if self.parent ~= self.caster then return end


self.radius = self.ability:GetSpecialValueFor("radius")
self.targets = {}

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_centaur_stampede_custom:OnIntervalThink()
if not IsServer() then return end

if self.distance_max > 0 and self.caster:HasTalent("modifier_centaur_stampede_4") then
  local new_pos = self.parent:GetAbsOrigin()
  self.distance_pass = self.distance_pass + (new_pos - self.pos):Length2D()
  self.pos = new_pos
  if self.distance_pass >= self.distance_max then

    local effect_cast = ParticleManager:CreateParticle( "particles/centaur/stampede_hit.vpcf", PATTACH_ABSORIGIN, self.parent )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.hit_radius, 1, 1))
    ParticleManager:ReleaseParticleIndex( effect_cast )

    self.parent:EmitSound("Hero_PrimalBeast.Trample")
    self.distance_pass = 0

    self.parent:AddNewModifier(self.parent, self.ability, "modifier_centaur_stampede_custom_distance_hit", {})
    local targets = self.parent:FindTargets(self.hit_radius)
    for _,target in pairs(targets) do
      self.parent:PerformAttack(target, true, true, true, true, false, false, true)
    end

    if #targets > 0 then
      self.ability:LegendaryStack(1)
    end

    self.parent:RemoveModifierByName("modifier_centaur_stampede_custom_distance_hit")
  end
end


local targets = self.caster:FindTargets(self.radius)
if #targets <= 0 then return end

for _,target in pairs(targets) do
  if not self.targets[target:entindex()] then
    self.targets[target:entindex()] = true

    self.ability:DealDamage(target)
    target:EmitSound("Hero_Centaur.Stampede.Stun")
  end
end

end

function modifier_centaur_stampede_custom:CheckState()
return
{
  [MODIFIER_STATE_UNSLOWABLE] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end


function modifier_centaur_stampede_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_centaur_stampede_custom:GetModifierIncomingDamage_Percentage()
if not self.caster:HasTalent("modifier_centaur_stampede_3") then return end
return self.damage_reduce
end

function modifier_centaur_stampede_custom:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_centaur_stampede_custom:GetActivityTranslationModifiers()
return "haste"
end

function modifier_centaur_stampede_custom:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Hero_Centaur.Stampede.Movement")
self.parent:RemoveModifierByName("modifier_centaur_stampede_custom_recast")

if self.parent == self.caster then
  self.ability:StartCd()
end

end


modifier_centaur_stampede_custom_slow = class({})
function modifier_centaur_stampede_custom_slow:IsHidden() return false end
function modifier_centaur_stampede_custom_slow:GetTexture() return "centaur_stampede" end
function modifier_centaur_stampede_custom_slow:IsPurgable() return not self:GetCaster():HasTalent("modifier_centaur_stampede_6") end
function modifier_centaur_stampede_custom_slow:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self.caster:FindAbilityByName("centaur_stampede_custom")
if not self.ability then 
  self:Destroy()
  return
end

self.slow = self.ability:GetSpecialValueFor("slow_movement_speed")
if not IsServer() then return end
self.parent:GenericParticle("particles/items2_fx/leashed.vpcf", self)

if not self.parent:IsRealHero() then return end
if self.caster:GetQuest() ~= "Centaur.Quest_8" then return end
if self.caster:QuestCompleted() then return end

self.interval = 0.1
self:StartIntervalThink(self.interval)
end


function modifier_centaur_stampede_custom_slow:OnIntervalThink()
if not IsServer() then return end
self.caster:UpdateQuest(self.interval)
end

function modifier_centaur_stampede_custom_slow:DeclareFunctions()
return
{ 
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_centaur_stampede_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end







centaur_stampede_custom_legendary = class({})

function centaur_stampede_custom_legendary:CreateTalent()
self:SetHidden(false)
self:UpdateVectorValues()

local ability = self:GetCaster():FindAbilityByName("centaur_stampede_custom")
if ability then
  ability:LegendaryUI()
end

end

function centaur_stampede_custom_legendary:GetAOERadius()
return self:GetSpecialValueFor("radius")
end


function centaur_stampede_custom_legendary:OnVectorCastStart(vStartLocation, vDirection)
local caster = self:GetCaster()

local mod = caster:FindModifierByName("modifier_centaur_stampede_custom_legendary_stack")
if not mod then return end

local stack = mod:GetStackCount()
local duration = stack*caster:GetTalentValue("modifier_centaur_stampede_7", "duration") + 0.2
mod:Destroy()

local point = vStartLocation
local vec = vDirection

if self:GetCursorPosition() == caster:GetAbsOrigin() then
  point = caster:GetAbsOrigin() + caster:GetForwardVector()*10
  vec = caster:GetForwardVector()
end

caster:EmitSound("Centaur.Stampede_legendary_cast1")

local particle = ParticleManager:CreateParticle( "particles/centaur/stampede_legendary_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControlEnt( particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_head", caster:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle ) 

particle = ParticleManager:CreateParticle( "particles/items_fx/drum_of_endurance_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex( particle ) 

CreateModifierThinker(caster, self, "modifier_centaur_stampede_custom_legendary_thinker", {duration = duration, stack = stack, x = vec.x, y = vec.y}, point, caster:GetTeamNumber(), false)
end


modifier_centaur_stampede_custom_legendary_thinker = class({})
function modifier_centaur_stampede_custom_legendary_thinker:IsHidden() return true end
function modifier_centaur_stampede_custom_legendary_thinker:IsPurgable() return false end
function modifier_centaur_stampede_custom_legendary_thinker:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.distance_start = 100
self.width = self.ability:GetSpecialValueFor("width")
self.interval = self.ability:GetSpecialValueFor("interval")
self.hit_radius = self.ability:GetSpecialValueFor("hit_radius")
self.distance = self.ability:GetSpecialValueFor("distance")
self.speed = self.ability:GetSpecialValueFor("speed")
self.hit_radius = self.ability:GetSpecialValueFor("hit_radius")

if not IsServer() then return end

self.stack = table.stack

if self.stack >= self.caster:GetTalentValue("modifier_centaur_stampede_7", "max") then
  self.speed = self.speed*(1 + self.ability:GetSpecialValueFor("speed_bonus")/100)
  self.caster:EmitSound("Centaur.Stampede_legendary_cast2")
end

self.vec = Vector(table.x, table.y, 0)
self.center_point = self.parent:GetAbsOrigin() - self.distance_start*self.vec
local line_pos = self.center_point + self.vec*self.width

self.left = RotatePosition(self.center_point, QAngle(0, 90, 0), line_pos)
self.right = RotatePosition(self.center_point, QAngle(0, -90, 0), line_pos)

self.dir = (self.right - self.left)
self.length = self.dir:Length2D()
self.dir = self.dir:Normalized()

self.last_left = 0
self.last_right = 0

self.parent:SetAbsOrigin(GetGroundPosition((self.parent:GetAbsOrigin() + self.vec*self.distance/2), nil))
self.parent:EmitSound("Centaur.Stampede_legendary_thinker")

self.units = {}
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_centaur_stampede_custom_legendary_thinker:OnDestroy()
if not IsServer() then return end

self.parent:StopSound("Centaur.Stampede_legendary_thinker")
end

function modifier_centaur_stampede_custom_legendary_thinker:OnIntervalThink()
if not IsServer() then return end

local length
local count = 0

repeat length = RandomInt(0, self.length/2)
  count = count + 1
until (math.abs(length - self.last_left) > self.hit_radius) or (count >= 20)
 
count = 0

local point = self.center_point + self.dir*length
self.last_left = length
self:SpawnUnit(point)


repeat length = RandomInt(0, self.length/2)
  count = count + 1
until ((math.abs(length - self.last_right) > self.hit_radius) and (math.abs(length - self.last_left) > self.hit_radius)) or (count >= 20)
 
point = self.center_point - self.dir*length
self.last_right = length
self:SpawnUnit(point)

self:StartIntervalThink(self.interval)
end


function modifier_centaur_stampede_custom_legendary_thinker:SpawnUnit(point)
if not IsServer() then return end

local unit = CreateUnitByName("custom_centaur_scepter_unit_"..tostring(RandomInt(1, 2)), point, false, self.caster, self.caster, self.caster:GetTeamNumber())
unit.owner = self.caster
unit:SetForwardVector(self.vec)
unit:FaceTowards(unit:GetAbsOrigin() + self.vec*5)
unit:AddNewModifier(self.caster, self.ability, "modifier_centaur_stampede_custom_legendary_unit", {duration = self.distance/self.speed + 2, stack = self.stack, speed = self.speed, x = self.vec.x, y = self.vec.y})
end






modifier_centaur_stampede_custom_legendary_unit = class({})
function modifier_centaur_stampede_custom_legendary_unit:IsHidden() return true end
function modifier_centaur_stampede_custom_legendary_unit:IsPurgable() return false end
function modifier_centaur_stampede_custom_legendary_unit:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.distance = self.ability:GetSpecialValueFor("distance")
self.hit_radius = self.ability:GetSpecialValueFor("hit_radius")
self.hit_stun = self.ability:GetSpecialValueFor("hit_stun")
self.hit_knock = self.ability:GetSpecialValueFor("hit_knock")
self.silence = self.ability:GetSpecialValueFor("silence")
self.max = self.caster:GetTalentValue("modifier_centaur_stampede_7", "max")

if not IsServer() then return end
self.speed = table.speed
self.stack = table.stack

if self.stack >= self.max then
  self.stampede_particle = self.parent:GenericParticle("particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf", self, true)
  self.parent:GenericParticle("particles/units/heroes/hero_centaur/centaur_stampede_cast.vpcf")
end

self.parent:GenericParticle("particles/units/heroes/hero_centaur/centaur_stampede.vpcf", self)
self.parent:EmitSound("Hero_Centaur.Stampede.Movement")

self.stampede = self.caster:FindAbilityByName("centaur_stampede_custom")

local effect = ParticleManager:CreateParticle("particles/centaur/stampede_legendary_start.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt( effect, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(effect)

self.stampede_particle = nil

self.targets = {}
self.damageTable = {attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

self.dir = Vector(table.x, table.y, 0)
self.final_point = self.parent:GetAbsOrigin() + self.dir*self.distance

self.pass = 0
self.position = self.parent:GetAbsOrigin()

self:OnIntervalThink()
self:StartIntervalThink(0.2)
end

function modifier_centaur_stampede_custom_legendary_unit:CheckState()
return
{
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_DISARMED] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
  [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_INVULNERABLE] = true
}
end


function modifier_centaur_stampede_custom_legendary_unit:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
  MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_centaur_stampede_custom_legendary_unit:GetActivityTranslationModifiers()
return "haste"
end

function modifier_centaur_stampede_custom_legendary_unit:GetModifierMoveSpeed_Absolute()
return self.speed
end


function modifier_centaur_stampede_custom_legendary_unit:OnIntervalThink()
if not IsServer() then return end

self.parent:MoveToPosition(self.final_point + self.dir*500)

local point = self.parent:GetAbsOrigin()
self.pass = self.pass + (point - self.position):Length2D()
self.position = point

if self.pass >= self.distance then
  self:Destroy()
  return
end

for _,target in pairs(self.parent:FindTargets(self.hit_radius)) do
  if not self.targets[target:entindex()] then
    self.targets[target:entindex()] = true
    target:EmitSound("Hero_Centaur.Stampede.Stun")

    self.damageTable.victim = target
    if self.stampede and self.stampede:IsTrained() then
      self.stampede:DealDamage(target, "modifier_centaur_stampede_7")
    end

    if self.stack >= self.max then
      target:AddNewModifier(self.caster, self.caster:BkbAbility(self.stampede, self.caster:HasTalent("modifier_centaur_stampede_6")), "modifier_generic_silence", {duration = (1 - target:GetStatusResistance())*self.silence})
    end

    local center = target:GetAbsOrigin() - self.dir*10

    local knockbackProperties =
    {
      center_x = center.x,
      center_y = center.y,
      center_z = center.z,
      duration = self.hit_stun,
      knockback_duration = self.hit_stun,
      knockback_distance = self.hit_knock,
      knockback_height = 30,
      should_stun = 1,
    }
    target:AddNewModifier( self.caster, self.caster:BkbAbility(self.stampede, self.caster:HasTalent("modifier_centaur_stampede_6")), "modifier_knockback", knockbackProperties )
  end
end

end


function modifier_centaur_stampede_custom_legendary_unit:OnDestroy()
if not IsServer() then return end

local effect = ParticleManager:CreateParticle("particles/centaur/stampede_legendary_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect, 0, self.parent:GetOrigin())
ParticleManager:ReleaseParticleIndex(effect)

self.parent:StopSound("Hero_Centaur.Stampede.Movement")
UTIL_Remove(self.parent)
end







modifier_centaur_stampede_custom_legendary_stack = class({})
function modifier_centaur_stampede_custom_legendary_stack:IsHidden() return false end
function modifier_centaur_stampede_custom_legendary_stack:IsPurgable() return false end
function modifier_centaur_stampede_custom_legendary_stack:IsDebuff() return true end
function modifier_centaur_stampede_custom_legendary_stack:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.max = self.parent:GetTalentValue("modifier_centaur_stampede_7", "max", true)
self.radius = self.parent:GetTalentValue("modifier_centaur_stampede_7", "stack_radius", true)
self.duration = self.parent:GetTalentValue("modifier_centaur_stampede_7", "stack_duration", true)

if not IsServer() then return end
self.visual_max = 6
self.particle = self.parent:GenericParticle("particles/centaur/stomp_legendary_stack.vpcf", self, true)

self:SetStackCount(1)
self:StartIntervalThink(0.2)
end

function modifier_centaur_stampede_custom_legendary_stack:OnIntervalThink()
if not IsServer() then return end
local targets = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

if #targets > 0 then
  self:SetDuration(self.duration, true)
end

end

function modifier_centaur_stampede_custom_legendary_stack:OnRefresh()
if not IsServer() then return end

if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_centaur_stampede_custom_legendary_stack:OnStackCountChanged()
if not IsServer() then return end

self.ability:LegendaryUI()
if not self.particle then return end

for i = 1,self.visual_max do 
  if i <= math.floor(self:GetStackCount()/(self.max/self.visual_max)) then 
    ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
  else 
    ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
  end
end

end

function modifier_centaur_stampede_custom_legendary_stack:OnDestroy()
if not IsServer() then return end
self.ability:LegendaryUI()
end






modifier_centaur_stampede_custom_tracker = class({})
function modifier_centaur_stampede_custom_tracker:IsHidden() return true end
function modifier_centaur_stampede_custom_tracker:IsPurgable() return false end
function modifier_centaur_stampede_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.legendary_ability = self.parent:FindAbilityByName("centaur_stampede_custom_legendary")

self.legendary_max = self.parent:GetTalentValue("modifier_centaur_stampede_7", "max", true)
self.legendary_spells = self.parent:GetTalentValue("modifier_centaur_stampede_7", "spells", true)
self.visual_max = 6

self.heal_creeps = self.parent:GetTalentValue("modifier_centaur_stampede_2", "creeps", true)
self.heal_bonus = self.parent:GetTalentValue("modifier_centaur_stampede_2", "bonus", true)

self.cdr_bonus = self.parent:GetTalentValue("modifier_centaur_stampede_6", "cdr", true)

self.parent:AddAttackEvent_out(self)
self.parent:AddSpellEvent(self)
self.parent:AddDamageEvent_out(self)
end 


function modifier_centaur_stampede_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_centaur_stampede_2") then return end
if not self.parent:CheckLifesteal(params) then return end

local heal = params.damage*self.parent:GetTalentValue("modifier_centaur_stampede_2", "heal")/100
local hide_number = true

if self.parent:HasModifier("modifier_centaur_stampede_custom") then
  heal = heal*self.heal_bonus
  hide_number = false
end

if params.unit:IsCreep() then
  heal = heal/self.heal_bonus
end

self.parent:GenericHeal(heal, self.ability, hide_number, "particles/items3_fx/octarine_core_lifesteal.vpcf", "modifier_centaur_stampede_2")
end

function modifier_centaur_stampede_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end

function modifier_centaur_stampede_custom_tracker:GetModifierPercentageCooldown() 
if not self.parent:HasTalent("modifier_centaur_stampede_6") then return end
return self.cdr_bonus
end
 
function modifier_centaur_stampede_custom_tracker:SpellEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if params.ability:IsItem() then return end
if params.ability:GetName() == "centaur_hoof_stomp_custom" then return end
if params.ability:GetName() == "centaur_stampede_custom_legendary" then return end
if params.ability == self.ability and self.parent:HasModifier("modifier_centaur_stampede_custom_recast") then return end

self.ability:LegendaryStack(self.legendary_spells)
end


function modifier_centaur_stampede_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
if params.no_attack_cooldown then return end

self.ability:LegendaryStack(1)
end

function modifier_centaur_stampede_custom_tracker:UpdateUI()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_centaur_stampede_7") then return end
local stack = 0
local interval = -1
local override = nil
local mod = self.parent:FindModifierByName("modifier_centaur_stampede_custom_legendary_stack")

if mod then
  stack = mod:GetStackCount()
  if self.legendary_ability then
    self.legendary_ability:SetActivated(true)
  end
  if self.particle then
    ParticleManager:DestroyParticle(self.particle, true)
    ParticleManager:ReleaseParticleIndex(self.particle)
    self.particle = nil
  end
else
  if self.legendary_ability then
    self.legendary_ability:SetActivated(false)
  end
  if not self.particle then
    self.particle = self.parent:GenericParticle("particles/centaur/stomp_legendary_stack.vpcf", self, true)
    for i = 1,self.visual_max do 
      ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
    end
  end
end

if self.legendary_ability:GetCooldownTimeRemaining() > 0 then
  override = self.legendary_ability:GetCooldownTimeRemaining()
  interval = 1
end

self.parent:UpdateUIlong({stack = stack, max = self.legendary_max, override_stack = override,  style = "CentaurStampede"})
self:StartIntervalThink(interval)
end


function modifier_centaur_stampede_custom_tracker:OnIntervalThink()
if not IsServer() then return end
self:UpdateUI()
end






modifier_centaur_stampede_custom_str_reduce = class({})
function modifier_centaur_stampede_custom_str_reduce:IsHidden() return true end
function modifier_centaur_stampede_custom_str_reduce:IsPurgable() return false end
function modifier_centaur_stampede_custom_str_reduce:OnCreated()
self.PercentStr = self:GetCaster():GetTalentValue("modifier_centaur_stampede_1", "str_reduce")/100
end

function modifier_centaur_stampede_custom_str_reduce:OnDestroy()
if not IsServer() then return end
self:GetParent():PercentRefresh()
end

modifier_centaur_stampede_custom_distance_hit = class({})
function modifier_centaur_stampede_custom_distance_hit:IsHidden() return true end
function modifier_centaur_stampede_custom_distance_hit:IsPurgable() return false end
function modifier_centaur_stampede_custom_distance_hit:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_centaur_stampede_4", "damage") - 100
end

function modifier_centaur_stampede_custom_distance_hit:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_centaur_stampede_custom_distance_hit:GetModifierDamageOutgoing_Percentage()
if not IsServer() then return end
return self.damage
end


modifier_centaur_stampede_custom_recast = class({})
function modifier_centaur_stampede_custom_recast:IsHidden() return true end
function modifier_centaur_stampede_custom_recast:IsPurgable() return false end