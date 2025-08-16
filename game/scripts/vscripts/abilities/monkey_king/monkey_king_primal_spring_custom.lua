LinkLuaModifier( "modifier_monkey_king_primal_spring_custom", "abilities/monkey_king/monkey_king_primal_spring_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_monkey_king_primal_spring_custom_instant", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_king_primal_spring_custom_stack", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_king_primal_spring_custom_tracker", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_king_primal_spring_custom_banana", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_king_primal_spring_custom_legendary", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_king_primal_spring_silence", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_monkey_king_primal_spring_custom_bonus", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)


monkey_king_primal_spring_custom = class({})


function monkey_king_primal_spring_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_monkey_king_arcana_custom_v1") then
    return "monkey_king/great_sages_reckoning/monkey_king_spring"
end
if self:GetCaster():HasModifier("modifier_monkey_king_arcana_custom_v2") then
    return "monkey_king/great_sages_reckoning/monkey_king_spring"
end
if self:GetCaster():HasModifier("modifier_monkey_king_arcana_custom_v3") then
    return "monkey_king/great_sages_reckoning/monkey_king_spring"
end
if self:GetCaster():HasModifier("modifier_monkey_king_arcana_custom_v4") then
    return "monkey_king/great_sages_reckoning/monkey_king_spring"
end
return "monkey_king_primal_spring"
end


function monkey_king_primal_spring_custom:CreateTalent(name)

if name == "modifier_monkey_king_tree_7" then 

  if dota1x6.current_wave >= upgrade_orange then 

    local caster = self:GetCaster()
    local max = caster:GetTalentValue("modifier_monkey_king_tree_7", "max")

    local mod = caster:AddNewModifier(caster, self, "modifier_monkey_king_primal_spring_custom_legendary", {})
    if mod then 
      mod:SetStackCount(max)
    end
  end
end

end 



function monkey_king_primal_spring_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end


PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_spring_channel.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_spring_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_spring.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_spring_slow.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_monkey_king_spring_slow.vpcf", context )
PrecacheResource( "particle", "particles/mk_double_proc.vpcf", context )
PrecacheResource( "particle", "particles/mk_refresh.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", context )
PrecacheResource( "particle", "particles/alch_stun_legendary.vpcf", context )
PrecacheResource( "particle", "particles/mk_buff_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )

end



function monkey_king_primal_spring_custom:GetManaCost(level)
if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_instant") then 
  return 0
end 
return self.BaseClass.GetManaCost(self,level)
end


function monkey_king_primal_spring_custom:GetChannelTime()
local bonus = 0

if self:GetCaster():HasTalent("modifier_monkey_king_tree_4") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_4", "cast")
end
return self:GetSpecialValueFor( "channel_time" ) + bonus
end


function monkey_king_primal_spring_custom:CanBeCast()
if not self or self:IsNull() then return false end

local caster = self:GetCaster()

if caster:HasModifier("modifier_monkey_king_mischief_custom") then return false end 
if caster:HasModifier("modifier_monkey_king_tree_dance_custom") then return true end 
if caster:HasModifier("modifier_monkey_king_primal_spring_custom_instant") then return true end

local mod = caster:FindModifierByName("modifier_monkey_king_primal_spring_custom_legendary")
if mod and mod:GetStackCount() >= caster:GetTalentValue("modifier_monkey_king_tree_7", "max") then 
  return true
end

return false
end 




function monkey_king_primal_spring_custom:GetAOERadius()
local bonus = 0
if self:GetCaster():HasTalent("modifier_monkey_king_tree_6") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_6", "radius")
end
return self:GetSpecialValueFor("impact_radius") + bonus
end


function monkey_king_primal_spring_custom:GetCastRange(location, target)
if IsServer() then 
  return 99999
else 
  return self:GetSpecialValueFor( "max_distance" )
end

end



function monkey_king_primal_spring_custom:GetCooldown(iLevel)
return self.BaseClass.GetCooldown(self, iLevel)
end

function monkey_king_primal_spring_custom:GetIntrinsicModifierName()
return "modifier_monkey_king_primal_spring_custom_tracker"
end


function monkey_king_primal_spring_custom:OnSpellStart()

local caster = self:GetCaster()
local point = self:GetCursorPosition()

self.max_distance = self:GetSpecialValueFor( "max_distance" ) + caster:GetCastRangeBonus()

if caster:HasTalent("modifier_monkey_king_tree_3") then
  self.max_distance = self.max_distance + caster:GetTalentValue("modifier_monkey_king_tree_3", "range")
end

local radius = self:GetSpecialValueFor( "impact_radius" )

local direction = (point-caster:GetOrigin())

direction.z = 0
if direction:Length2D() > self.max_distance  then
  point = caster:GetOrigin() + direction:Normalized() * self.max_distance
  point.z = GetGroundHeight( point, caster )
end

AddFOWViewer(caster:GetTeamNumber(), point, radius, 2, false)

caster:StartGesture(ACT_DOTA_MK_SPRING_CAST)

self.point = point

if not caster:HasModifier("modifier_monkey_king_tree_dance_custom") then 
  caster:SetOrigin(Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z + 50))
end

if self.point == caster:GetAbsOrigin() then 
  self.point = caster:GetAbsOrigin() + caster:GetForwardVector()*25
end

self.sub = caster:FindAbilityByName("monkey_king_primal_spring_early_custom")

self:PlayEffects1()
self:PlayEffects2( self.point )
self.new_pct = 0

if caster:HasModifier("modifier_monkey_king_primal_spring_custom_instant") then 
  caster:RemoveModifierByName("modifier_monkey_king_primal_spring_custom_instant")
end 

if self.sub and not self.sub:IsNull() then
  caster:SwapAbilities( "monkey_king_primal_spring_custom", "monkey_king_primal_spring_early_custom",  false, true )
end

end



function monkey_king_primal_spring_custom:OnChannelFinish( bInterrupted )

local caster = self:GetCaster()


caster:FadeGesture(ACT_DOTA_MK_SPRING_CAST)
caster:FadeGesture(ACT_DOTA_MK_SPRING_END)

caster:SetOrigin(Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y, caster:GetAbsOrigin().z - 50))

local caster = caster
local point = self.point
local channel_pct =  math.min(1, (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime() + 0.01)

local direction = (point-caster:GetOrigin())
direction.z = 0
if direction:Length2D()> self.max_distance then
  point = caster:GetOrigin() + direction:Normalized() * self.max_distance
  point.z = GetGroundHeight( point, caster )
end

if self.new_pct ~= 0 then 
  channel_pct = self.new_pct
end


local speed = self:GetSpecialValueFor( "speed" )
local distance = (point-caster:GetOrigin()):Length2D()

local perch_height = -192
local ground = GetGroundPosition(caster:GetAbsOrigin(), nil)
local perch_height = -1*(caster:GetAbsOrigin().z - ground.z)


local height = 160
if distance < 80 then 
  height = 0
end

caster:FaceTowards(point)
caster:SetForwardVector(direction)

local arc = caster:AddNewModifier(caster, self, "modifier_generic_arc",
{
  target_x = point.x,
  target_y = point.y,
  distance = distance,
  speed = speed,
  height = height,
  fix_end = false,
  isStun = true,
  activity = ACT_DOTA_MK_SPRING_SOAR,
  end_offset = perch_height,
  end_anim = ACT_DOTA_MK_SPRING_END,
})


if self.sub and not self.sub:IsNull() then
  caster:SwapAbilities( "monkey_king_primal_spring_custom", "monkey_king_primal_spring_early_custom", true, false)
end

self:StopEffects()

if not arc then return end
self:PlayEffects4( arc )

arc:SetEndCallback(function()

  local dir = caster:GetForwardVector()
  dir.z = 0

  if (caster:GetAbsOrigin() - point):Length2D() > 200 then 
    FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)
    return 
  end

  FindClearSpaceForUnit(caster, point, false)
  caster:SetForwardVector(dir)

  self:DealDamage(point, channel_pct)
end)

end


function monkey_king_primal_spring_custom:DealDamage(point, channel_pct)
if not self or self:IsNull() then return end

local caster = self:GetCaster()

local radius = self:GetSpecialValueFor( "impact_radius" )
local damage = self:GetSpecialValueFor( "impact_damage" )
local slow = self:GetSpecialValueFor( "impact_movement_slow" )*channel_pct
local duration = self:GetSpecialValueFor( "impact_slow_duration" )
local silence_duration = caster:GetTalentValue("modifier_monkey_king_tree_6", "silence")

if caster:HasModifier("modifier_monkey_king_primal_spring_custom_legendary") then 
  damage = damage + caster:GetTalentValue("modifier_monkey_king_tree_7", "damage")*caster:FindModifierByName("modifier_monkey_king_primal_spring_custom_legendary"):GetStackCount()
end 

damage = damage*channel_pct

if caster:HasTalent("modifier_monkey_king_tree_6") then 
  radius = radius + caster:GetTalentValue("modifier_monkey_king_tree_6", "radius")
end

if caster:HasTalent("modifier_monkey_king_tree_1") then 
  caster:AddNewModifier(caster, self, "modifier_monkey_king_primal_spring_custom_bonus", {duration = caster:GetTalentValue("modifier_monkey_king_tree_1", "duration")})
end

local type = DAMAGE_TYPE_MAGICAL

if caster:HasModifier("modifier_monkey_king_primal_spring_custom_legendary") and 
  caster:GetUpgradeStack("modifier_monkey_king_primal_spring_custom_legendary") >= caster:GetTalentValue("modifier_monkey_king_tree_7", "max_2") then 
   type = DAMAGE_TYPE_PURE
end

local enemies = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
local damageTable = {attacker = caster, damage = damage, damage_type = type, ability = self,}


for _,enemy in pairs(enemies) do

  if caster:GetQuest() == "Monkey.Quest_6" and channel_pct > 0.98 and enemy:IsRealHero() then 
    caster:UpdateQuest(1)
  end

  damageTable.victim = enemy
  DoDamage(damageTable)

  if caster:HasTalent("modifier_monkey_king_tree_6") then
    enemy:AddNewModifier(caster, self, "modifier_monkey_king_primal_spring_silence", {duration = (1 - enemy:GetStatusResistance())*silence_duration})
  end

  local mod = enemy:FindModifierByName("modifier_monkey_king_primal_spring_custom")
  if not mod then 
    mod = enemy:AddNewModifier( caster, self, "modifier_monkey_king_primal_spring_custom", {duration = duration})
  end

  if mod and mod:GetStackCount() < slow then 
    mod:SetStackCount(slow)
  end

end

self:PlayEffects3( point, radius )
end





function monkey_king_primal_spring_custom:PlayEffects1()

local caster = self:GetCaster()
local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_spring_channel.vpcf"

if caster:HasModifier("modifier_monkey_king_arcana_custom_v2") then
  particle_cast = "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water_channel.vpcf"
end
if caster:HasModifier("modifier_monkey_king_arcana_custom_v3") then
  particle_cast = "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_arcana_death_channel.vpcf"
end
if caster:HasModifier("modifier_monkey_king_arcana_custom_v4") then
  particle_cast = "particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire_channel.vpcf"
end

self.effect_cast1 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControlEnt( self.effect_cast1, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true  )
end


function monkey_king_primal_spring_custom:PlayEffects2( point )

local caster = self:GetCaster()
local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_spring_cast.vpcf"
local sound_cast = "Hero_MonkeyKing.Spring.Channel"

if caster:HasModifier("modifier_monkey_king_arcana_custom_v2") then
  particle_cast = "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_cast_arcana_water.vpcf"
end
if caster:HasModifier("modifier_monkey_king_arcana_custom_v3") then
  particle_cast = "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_cast_arcana_death.vpcf"
end
if caster:HasModifier("modifier_monkey_king_arcana_custom_v4") then
  particle_cast = "particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_cast_arcana_fire.vpcf"
end

self.effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber())
ParticleManager:SetParticleControl( self.effect_cast2, 0, point )
ParticleManager:SetParticleControl( self.effect_cast2, 4, point )

EmitSoundOnLocationWithCaster( point, sound_cast, caster )
end



function monkey_king_primal_spring_custom:PlayEffects3( point, radius )

local caster = self:GetCaster()
local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_spring.vpcf"
local sound_cast = "Hero_MonkeyKing.Spring.Impact"

if caster:HasModifier("modifier_monkey_king_arcana_custom_v2") then
  particle_cast = "particles/econ/items/monkey_king/arcana/water/monkey_king_spring_arcana_water.vpcf"
  sound_cast = "Hero_MonkeyKing.Spring.Impact.Water"
end
if caster:HasModifier("modifier_monkey_king_arcana_custom_v3") then
  particle_cast = "particles/econ/items/monkey_king/arcana/death/monkey_king_spring_arcana_death.vpcf"
end
if caster:HasModifier("modifier_monkey_king_arcana_custom_v4") then
  particle_cast = "particles/econ/items/monkey_king/arcana/fire/monkey_king_spring_arcana_fire.vpcf"
end

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
ParticleManager:SetParticleControl( effect_cast, 0, point )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

EmitSoundOnLocationWithCaster( point, sound_cast, caster )
end


function monkey_king_primal_spring_custom:PlayEffects4( modifier )

local caster = self:GetCaster()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
modifier:AddParticle(effect_cast, false, false,  -1, false, false )
caster:EmitSound("Hero_MonkeyKing.TreeJump.Cast")
end


function monkey_king_primal_spring_custom:StopEffects()

if self.effect_cast2 ~= nil then
  ParticleManager:DestroyParticle( self.effect_cast2, false )
  ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
end

if self.effect_cast1 ~= nil then
  ParticleManager:DestroyParticle( self.effect_cast1, false )
  ParticleManager:ReleaseParticleIndex( self.effect_cast1 )
end

StopSoundOn( "Hero_MonkeyKing.Spring.Channel", self:GetCaster() )
end




modifier_monkey_king_primal_spring_custom = class({})


function modifier_monkey_king_primal_spring_custom:IsHidden() return false end
function modifier_monkey_king_primal_spring_custom:IsPurgable() return true end
function modifier_monkey_king_primal_spring_custom:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_monkey_king_primal_spring_custom:GetModifierMoveSpeedBonus_Percentage()
return -self:GetStackCount()
end

function modifier_monkey_king_primal_spring_custom:GetEffectName()
return "particles/units/heroes/hero_monkey_king/monkey_king_spring_slow.vpcf"
end

function modifier_monkey_king_primal_spring_custom:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_monkey_king_primal_spring_custom:GetStatusEffectName()
return "particles/status_fx/status_effect_monkey_king_spring_slow.vpcf"
end

function modifier_monkey_king_primal_spring_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL
end




monkey_king_primal_spring_early_custom = class({})

function monkey_king_primal_spring_early_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_monkey_king_arcana_custom_v1") then
    return "monkey_king/great_sages_reckoning/monkey_king_spring"
end
if self:GetCaster():HasModifier("modifier_monkey_king_arcana_custom_v2") then
    return "monkey_king/great_sages_reckoning/monkey_king_spring"
end
if self:GetCaster():HasModifier("modifier_monkey_king_arcana_custom_v3") then
    return "monkey_king/great_sages_reckoning/monkey_king_spring"
end
if self:GetCaster():HasModifier("modifier_monkey_king_arcana_custom_v4") then
    return "monkey_king/great_sages_reckoning/monkey_king_spring"
end
return "monkey_king_primal_spring"
end


function monkey_king_primal_spring_early_custom:OnSpellStart()
if not self.main or self.main:IsNull() then return end

self.main:EndChannel( true )
end






modifier_monkey_king_primal_spring_custom_instant = class({})
function modifier_monkey_king_primal_spring_custom_instant:IsHidden() return false end
function modifier_monkey_king_primal_spring_custom_instant:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_instant:GetTexture() return "buffs/spring_double" end
function modifier_monkey_king_primal_spring_custom_instant:GetEffectName() return "particles/mk_double_proc.vpcf"
end

function modifier_monkey_king_primal_spring_custom_instant:OnCreated(table)
if not IsServer() then return end
self:GetAbility():SetActivated(true)

end

function modifier_monkey_king_primal_spring_custom_instant:OnDestroy()
if not IsServer() then return end
self:GetAbility():SetActivated(self:GetAbility():CanBeCast())
end




modifier_monkey_king_primal_spring_custom_tracker = class({})
function modifier_monkey_king_primal_spring_custom_tracker:IsHidden() return true end
function modifier_monkey_king_primal_spring_custom_tracker:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_tracker:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.bonus = self.parent:GetTalentValue("modifier_monkey_king_tree_1", "bonus", true)

self.range_bonus = self.parent:GetTalentValue("modifier_monkey_king_tree_6", "range", true)

self.stack_duration = self.parent:GetTalentValue("modifier_monkey_king_tree_2", "duration", true)

if not IsServer() then return end

self.ability:SetActivated(self.ability:CanBeCast())

if not self.parent:IsTempestDouble() then 
  self.parent:AddAttackEvent_out(self)
  self.parent:AddSpellEvent(self)
end

self.clone_chance = self.parent:GetTalentValue("modifier_monkey_king_tree_4", "clone", true)
self.chance_duration = self.parent:GetTalentValue("modifier_monkey_king_tree_4", "duration", true)

self.max_timer = self.parent:GetTalentValue("modifier_monkey_king_tree_7", "cd", true)
self.duration = self.parent:GetTalentValue("modifier_monkey_king_tree_7", "duration", true)
self.radius = self.parent:GetTalentValue("modifier_monkey_king_tree_7", "tower_radius", true)
self.expire_timer = self.parent:GetTalentValue("modifier_monkey_king_tree_7", "expire_timer", true)

self.count = self.max_timer
self:StartIntervalThink(1)
end

function modifier_monkey_king_primal_spring_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_monkey_king_tree_7") then return end

self.count = self.count + 1 

local time = math.max(0, (self.max_timer - self.count))
local min = tostring(math.floor(time/self.max_timer))
local sec = time - 60*math.floor(time/60)
if sec < 10 then
  sec = "0"..tostring(sec)
else
  sec = tostring(sec)
end

self.parent:UpdateUIlong({override_stack = min..":"..sec, no_min = 1, style = "MonkeyBanana"})

if self.count < self.max_timer then return end 

self.count = 0

local point
repeat point = Vector(RandomInt(-6600,6600), RandomInt(-6600,6600), 215)
until self:IsValidPoint(point)

local banana = CreateUnitByName("npc_monkey_king_banana", point, true, nil, nil, self.parent:GetTeamNumber())

banana:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_primal_spring_custom_banana", {duration = self.duration - self.expire_timer, original = 1})
GameRules:ExecuteTeamPing(self.parent:GetTeamNumber(), point.x, point.y, self.parent, 0 )

FindClearSpaceForUnit(banana, banana:GetAbsOrigin(), false)
end



function modifier_monkey_king_primal_spring_custom_tracker:IsValidPoint(point)
if not IsServer() then return end 

local towers = FindUnitsInRadius( self.parent:GetTeamNumber(), point, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, 0, 0, false)

for _,tower in pairs(towers) do 
  if tower:GetUnitName() == "npc_towerradiant" or tower:GetUnitName() == "npc_towerdire" then 
    return false 
  end
end 

return true
end 


function modifier_monkey_king_primal_spring_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_EVASION_CONSTANT,
  MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_monkey_king_primal_spring_custom_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_monkey_king_tree_2") then return end 
return self.parent:GetTalentValue("modifier_monkey_king_tree_2", "range")
end

function modifier_monkey_king_primal_spring_custom_tracker:GetModifierCastRangeBonusStacking()
if not self.parent:HasTalent("modifier_monkey_king_tree_6") then return end 
return self.range_bonus
end


function modifier_monkey_king_primal_spring_custom_tracker:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_monkey_king_tree_1") then return end 
local bonus = 1 
if self.parent:HasModifier("modifier_monkey_king_primal_spring_custom_bonus") then 
  bonus = self.bonus
end 
return self.parent:GetTalentValue("modifier_monkey_king_tree_1", "move")*bonus
end


function modifier_monkey_king_primal_spring_custom_tracker:SpellEvent(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_monkey_king_tree_2") and not self.parent:HasTalent("modifier_monkey_king_tree_3") then return end
if params.unit ~= self.parent then return end
if params.ability:IsItem() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_primal_spring_custom_stack", {duration = self.stack_duration})
end



function modifier_monkey_king_primal_spring_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_monkey_king_tree_4") then return end 
if self.parent:HasModifier("modifier_monkey_king_primal_spring_custom_instant") then return end
if not params.target:IsUnit() then return end
if params.no_attack_cooldown then return end

local attacker = params.attacker
if not attacker then return end 

if (attacker == self.parent) or (attacker.owner and attacker.owner == self.parent and (attacker:IsIllusion() or attacker:IsTempestDouble())) then 

  local chance = self.parent:GetTalentValue("modifier_monkey_king_tree_4", "chance")
  if attacker ~= self.parent then 
    chance = chance/self.clone_chance
  end
  if RollPseudoRandomPercentage(chance, 182, self.parent) then 
    self.ability:EndCooldown()
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_monkey_king_primal_spring_custom_instant", {duration = self.chance_duration})

    local particle = ParticleManager:CreateParticle("particles/mk_refresh.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
    ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particle)
    self.parent:EmitSound("Hero_Rattletrap.Overclock.Cast")  
  end
end 

end 








modifier_monkey_king_primal_spring_custom_banana = class({})
function modifier_monkey_king_primal_spring_custom_banana:IsHidden() return true end
function modifier_monkey_king_primal_spring_custom_banana:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_banana:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
}
end

function modifier_monkey_king_primal_spring_custom_banana:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.original = table.original
self.expire_timer = self.caster:GetTalentValue("modifier_monkey_king_tree_7", "expire_timer", true)
self.radius = self.caster:GetTalentValue("modifier_monkey_king_tree_7", "radius", true)
self.vision = self.caster:GetTalentValue("modifier_monkey_king_tree_7", "vision", true)
self.bounty = self.caster:GetTalentValue("modifier_monkey_king_tree_7", "bounty", true)/100

if self.original and self.original == 1 then 

  local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(part, 0, self.parent:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(part)
  self.parent:EmitSound("Hero_MonkeyKing.Transform.On")
end 

self.particle_ally_fx = ParticleManager:CreateParticleForTeam("particles/alch_stun_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetTeamNumber())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

self:StartIntervalThink(0.2)
end


function modifier_monkey_king_primal_spring_custom_banana:OnIntervalThink()
if not IsServer() then return end
if not self.caster then return end
AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), self.vision, 0.2, false)

if (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() > self.radius then return end  
if not self.caster:IsAlive() then return end 

self.caster:EmitSound("MK.Tree_legendary_buff")
local particle_peffect = ParticleManager:CreateParticle("particles/mk_buff_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
ParticleManager:SetParticleControl(particle_peffect, 0, self.caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self.caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_monkey_king_primal_spring_custom_legendary", {})

local minute = math.floor(GameRules:GetDOTATime(false, false) / 60)
local gold = (bounty_gold_init + minute * bounty_gold_per_minute)*self.bounty
local blue = (bounty_blue_init + minute * bounty_blue_per_minute)*self.bounty
local exp = (bounty_exp_init + minute * bounty_exp_per_minute)*self.bounty

self.caster:AddExperience(exp, 5, false, false)
dota1x6:AddBluePoints(self.caster, blue)

self.caster:GiveGold(gold, true)
self.caster:EmitSound("MK.Tree_bounty")
self:Destroy()
end


function modifier_monkey_king_primal_spring_custom_banana:OnDestroy()
if not IsServer() then return end

local abs = self.parent:GetAbsOrigin()

UTIL_Remove(self.parent)

if self.original and self.original == 1 and self:GetRemainingTime() <= 0.1 then 
  local banana = CreateUnitByName("npc_monkey_king_banana_expire", abs, true, nil, nil, self.caster:GetTeamNumber())
  banana:AddNewModifier(self.caster, self:GetAbility(), "modifier_monkey_king_primal_spring_custom_banana", {duration = self.expire_timer, original = 0})
else 
  local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(part, 0, abs)
  ParticleManager:ReleaseParticleIndex(part)
  EmitSoundOnLocationWithCaster(abs, "Hero_MonkeyKing.Transform.On", self.caster)
end 

end




modifier_monkey_king_primal_spring_custom_legendary = class({})
function modifier_monkey_king_primal_spring_custom_legendary:IsHidden() return false end
function modifier_monkey_king_primal_spring_custom_legendary:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_legendary:GetTexture() return "buffs/rebound_resist" end
function modifier_monkey_king_primal_spring_custom_legendary:RemoveOnDeath() return false end
function modifier_monkey_king_primal_spring_custom_legendary:OnCreated(table)

self.parent = self:GetParent()
self.damage = self.parent:GetTalentValue("modifier_monkey_king_tree_7", "damage", true)
if not IsServer() then return end
self:SetStackCount(1)

self.max = self.parent:GetTalentValue("modifier_monkey_king_tree_7", "max", true)
self.max_2 = self.parent:GetTalentValue("modifier_monkey_king_tree_7", "max_2", true)
end


function modifier_monkey_king_primal_spring_custom_legendary:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if self:GetStackCount() == self.max or self:GetStackCount() == self.max_2 then 
  self.parent:EmitSound("BS.Thirst_legendary_active")
  local particle_peffect = ParticleManager:CreateParticle("particles/mk_buff_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl(particle_peffect, 0, self.parent:GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self.parent:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_peffect)
end 

if self:GetStackCount() == self.max then 
  self:GetAbility():SetActivated(true)
end 

end 

function modifier_monkey_king_primal_spring_custom_legendary:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_monkey_king_primal_spring_custom_legendary:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_monkey_king_primal_spring_custom_legendary:OnTooltip()
return self:GetStackCount()*self.damage
end





modifier_monkey_king_primal_spring_silence = class({})

function modifier_monkey_king_primal_spring_silence:IsHidden() return true end
function modifier_monkey_king_primal_spring_silence:IsPurgable() return true end
function modifier_monkey_king_primal_spring_silence:GetTexture() return "silencer_last_word" end
function modifier_monkey_king_primal_spring_silence:OnCreated(table)

self.speed = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_6", "speed")
end

function modifier_monkey_king_primal_spring_silence:CheckState()
return
{
  [MODIFIER_STATE_SILENCED] = true,
}
end

function modifier_monkey_king_primal_spring_silence:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_monkey_king_primal_spring_silence:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_monkey_king_primal_spring_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_monkey_king_primal_spring_silence:ShouldUseOverheadOffset() return true end
function modifier_monkey_king_primal_spring_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end






modifier_monkey_king_primal_spring_custom_bonus = class({})
function modifier_monkey_king_primal_spring_custom_bonus:IsHidden() return false end
function modifier_monkey_king_primal_spring_custom_bonus:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_bonus:GetTexture() return "buffs/tree_speed" end
function modifier_monkey_king_primal_spring_custom_bonus:GetEffectName()
return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end 

function modifier_monkey_king_primal_spring_custom_bonus:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end










modifier_monkey_king_primal_spring_custom_stack = class({})
function modifier_monkey_king_primal_spring_custom_stack:IsHidden() return false end 
function modifier_monkey_king_primal_spring_custom_stack:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_stack:GetTexture() return "buffs/back_reflect" end
function modifier_monkey_king_primal_spring_custom_stack:OnCreated()

self.parent = self:GetParent()

self.speed = self.parent:GetTalentValue("modifier_monkey_king_tree_2", "speed")

self.armor = self.parent:GetTalentValue("modifier_monkey_king_tree_3", "armor")
self.regen = self.parent:GetTalentValue("modifier_monkey_king_tree_3", "regen")
self.max = self.parent:GetTalentValue("modifier_monkey_king_tree_3", "max", true)
if not IsServer() then return end 

self.RemoveForDuel = true
self:SetStackCount(1)
end 


function modifier_monkey_king_primal_spring_custom_stack:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end 

function modifier_monkey_king_primal_spring_custom_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_monkey_king_primal_spring_custom_stack:GetModifierAttackSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_monkey_king_tree_2") then return end
return self.speed*self:GetStackCount()
end

function modifier_monkey_king_primal_spring_custom_stack:GetModifierPhysicalArmorBonus()
if not self.parent:HasTalent("modifier_monkey_king_tree_3") then return end
return self.armor*self:GetStackCount()
end

function modifier_monkey_king_primal_spring_custom_stack:GetModifierConstantHealthRegen()
if not self.parent:HasTalent("modifier_monkey_king_tree_3") then return end
return self.regen*self:GetStackCount()
end

