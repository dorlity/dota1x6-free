LinkLuaModifier( "modifier_monkey_king_primal_spring_custom", "abilities/monkey_king/monkey_king_primal_spring_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_speed", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_instant", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_tracker", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_banana", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_legendary", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_silence", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier(  "modifier_monkey_king_primal_spring_custom_bonus", "abilities/monkey_king/monkey_king_primal_spring_custom.lua", LUA_MODIFIER_MOTION_NONE)


monkey_king_primal_spring_custom = class({})






function monkey_king_primal_spring_custom:Precache(context)

PrecacheResource( "particle", 'particles/mk_refresh.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_spring_channel.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_spring_cast.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_spring.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_spring_slow.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_monkey_king_spring_slow.vpcf', context )
PrecacheResource( "particle", 'particles/mk_double_proc.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf', context )
PrecacheResource( "particle", 'particles/alch_stun_legendary.vpcf', context )
PrecacheResource( "particle", 'particles/mk_buff_start.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_shredder_whirl.vpcf', context )

end


function monkey_king_primal_spring_custom:GetManaCost(level)


if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_instant") then 
  return 0
end 

return self.BaseClass.GetManaCost(self,level)
end



function monkey_king_primal_spring_custom:OnUpgrade()
if self:GetLevel() == 1 then 
self:SetActivated(false)
end

end


function monkey_king_primal_spring_custom:GetChannelTime()

local bonus = 0

if self:GetCaster():HasModifier("modifier_monkey_king_tree_4") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_4", "cast")
end

return self:GetSpecialValueFor( "channel_time" ) + bonus
end


function monkey_king_primal_spring_custom:CanBeCast()

if self:GetCaster():HasModifier("modifier_monkey_king_mischief_custom") then return false end 
if self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") then return true end 
if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_instant") then return true end

local mod = self:GetCaster():FindModifierByName("modifier_monkey_king_primal_spring_custom_legendary")
if mod and mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "max") then 
  return true
end

return false
end 




function monkey_king_primal_spring_custom:GetAOERadius()
local bonus = 0
if self:GetCaster():HasModifier("modifier_monkey_king_tree_6") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_6", "radius")
end
return self:GetSpecialValueFor("impact_radius") + bonus
end

function monkey_king_primal_spring_custom:GetCastRange(location, target)
if IsServer() then 
  return 99999
else 

  local bonus = 0

  if self:GetCaster():HasModifier("modifier_monkey_king_tree_3") then
    bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_3", "range")
  end
  return (self:GetSpecialValueFor( "max_distance" ) + bonus)
end

end



function monkey_king_primal_spring_custom:GetCooldown(iLevel)
local bonus = 0 
--[[
if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_legendary") and 
  self:GetCaster():GetUpgradeStack("modifier_monkey_king_primal_spring_custom_legendary") >= self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "max_2") then 

    bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "bonus_cd")
end 
]]
 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end




function monkey_king_primal_spring_custom:GetIntrinsicModifierName()
return "modifier_monkey_king_primal_spring_custom_tracker"
end





function monkey_king_primal_spring_custom:OnSpellStart()

local caster = self:GetCaster()
local point = self:GetCursorPosition()

self.max_distance = self:GetSpecialValueFor( "max_distance" ) + self:GetCaster():GetCastRangeBonus()

if self:GetCaster():HasModifier("modifier_monkey_king_tree_3") then
  self.max_distance = self.max_distance + self:GetCaster():GetTalentValue("modifier_monkey_king_tree_3", "range")
end


local radius = self:GetSpecialValueFor( "impact_radius" )

local direction = (point-caster:GetOrigin())

direction.z = 0
if direction:Length2D() > self.max_distance  then
  point = caster:GetOrigin() + direction:Normalized() * self.max_distance
  point.z = GetGroundHeight( point, caster )
end

AddFOWViewer(self:GetCaster():GetTeamNumber(), point, radius, 2, false)

self:GetCaster():StartGesture(ACT_DOTA_MK_SPRING_CAST)

self.point = point


if not self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") then 
  self:GetCaster():SetOrigin(Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, self:GetCaster():GetAbsOrigin().z + 50))
end

if self.point == self:GetCaster():GetAbsOrigin() then 
  self.point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*25
end


if not self.sub then

  local sub = caster:FindAbilityByName( 'monkey_king_primal_spring_early_custom' )
  if not sub then
    sub = caster:AddAbility( 'monkey_king_primal_spring_early_custom' )
  end
  self.sub = sub
  self.sub.main = self
end

self.sub:SetLevel( self:GetLevel() )


self:PlayEffects1()
self:PlayEffects2( self.point )
self.new_pct = 0


if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_instant") then 
    self:GetCaster():RemoveModifierByName("modifier_monkey_king_primal_spring_custom_instant")
end 

caster:SwapAbilities( 'monkey_king_primal_spring_custom', 'monkey_king_primal_spring_early_custom',  false, true )

end



function monkey_king_primal_spring_custom:OnChannelFinish( bInterrupted )

  self:GetCaster():FadeGesture(ACT_DOTA_MK_SPRING_CAST)
  self:GetCaster():FadeGesture(ACT_DOTA_MK_SPRING_END)

  self:GetCaster():SetOrigin(Vector(self:GetCaster():GetAbsOrigin().x, self:GetCaster():GetAbsOrigin().y, self:GetCaster():GetAbsOrigin().z - 50))

  local caster = self:GetCaster()
  local point = self.point
  local channel_pct =  math.min(1, (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime() + 0.01)

  -- limit distance
  local direction = (point-caster:GetOrigin())
  direction.z = 0
  if direction:Length2D()> self.max_distance then
    point = caster:GetOrigin() + direction:Normalized() * self.max_distance
    point.z = GetGroundHeight( point, caster )
  end

  if self.new_pct ~= 0 then 
    channel_pct = self.new_pct
  end

  -- load data

  local speed = self:GetSpecialValueFor( "speed" )
  local distance = (point-caster:GetOrigin()):Length2D()


  local perch_height = -192
 
  if not self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") then 
    perch_height = 0
  end


  local height = 150
  if distance < 80 then 
    height = 0
  end

  self:GetCaster():FaceTowards(point)
  self:GetCaster():SetForwardVector(direction)

  local arc = caster:AddNewModifier(
    caster,
    self,
    "modifier_generic_arc",
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

    }
  )


  if self.sub and self.sub:IsHidden() == false then
    caster:SwapAbilities( 'monkey_king_primal_spring_custom', 'monkey_king_primal_spring_early_custom', true, false)
  end

  self:StopEffects()

  if not arc then return end
  self:PlayEffects4( arc )

  arc:SetEndCallback(function()

    self:DealDamage(point, channel_pct)

  end)

end


function monkey_king_primal_spring_custom:DealDamage(point, channel_pct)

local caster = self:GetCaster()

local radius = self:GetSpecialValueFor( "impact_radius" )
local damage = self:GetSpecialValueFor( "impact_damage" )
local slow = self:GetSpecialValueFor( "impact_movement_slow" )*channel_pct
local duration = self:GetSpecialValueFor( "impact_slow_duration" )

if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_legendary") then 
  damage = damage + self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "damage")*self:GetCaster():FindModifierByName("modifier_monkey_king_primal_spring_custom_legendary"):GetStackCount()
end 

damage = damage*channel_pct

if self:GetCaster():HasModifier("modifier_monkey_king_tree_6") then 
  radius = radius + self:GetCaster():GetTalentValue("modifier_monkey_king_tree_6", "radius")
end

if self:GetCaster():HasModifier("modifier_monkey_king_tree_2") then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_primal_spring_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_2", "duration")})
end 

if self:GetCaster():HasModifier("modifier_monkey_king_tree_1") then 
  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_primal_spring_custom_bonus", {duration = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_1", "duration")})
end

local dir = self:GetCaster():GetForwardVector()
dir.z = 0

if (self:GetCaster():GetAbsOrigin() - point):Length2D() > 200 then 
  FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), false)
  return 
end

FindClearSpaceForUnit(self:GetCaster(), point, false)
self:GetCaster():SetForwardVector(dir)


local ability = self:GetCaster():FindAbilityByName("monkey_king_wukongs_command_custom") 
if ability and ability:GetLevel() > 0 and self:GetCaster():HasModifier("modifier_monkey_king_command_4") then 
  ability:SpawnMonkeyKingPointScepter(self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTalentValue("modifier_monkey_king_command_4", "duration"), true)
end

local type = DAMAGE_TYPE_MAGICAL

if self:GetCaster():HasModifier("modifier_monkey_king_primal_spring_custom_legendary") and 
  self:GetCaster():GetUpgradeStack("modifier_monkey_king_primal_spring_custom_legendary") >= self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "max_2") then 

   type = DAMAGE_TYPE_PURE
end 


local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
local damageTable = {attacker = caster, damage = damage, damage_type = type, ability = self,}

for _,enemy in pairs(enemies) do

  if self:GetCaster():GetQuest() == "Monkey.Quest_6" and channel_pct > 0.98 and enemy:IsRealHero() then 
    self:GetCaster():UpdateQuest(1)
  end

  damageTable.victim = enemy
  ApplyDamage(damageTable)

  if self:GetCaster():HasModifier("modifier_monkey_king_tree_6") then
    local duration = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_6", "silence")
    enemy:AddNewModifier(self:GetCaster(), self, "modifier_monkey_king_primal_spring_silence", {duration = (1 - enemy:GetStatusResistance())*duration})
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










--------------------------------------------------------------------------------
-- Graphics & Animations
function monkey_king_primal_spring_custom:PlayEffects1()
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_spring_channel.vpcf"

  -- Get Data
  local caster = self:GetCaster()

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
  ParticleManager:SetParticleControlEnt(
    effect_cast,
    1,
    caster,
    PATTACH_POINT_FOLLOW,
    "attach_hitloc",
    Vector(0,0,0), -- unknown
    true -- unknown, true
  )
  -- ParticleManager:ReleaseParticleIndex( effect_cast )
  self.effect_cast1 = effect_cast
end

function monkey_king_primal_spring_custom:PlayEffects2( point )
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_spring_cast.vpcf"
  local sound_cast = "Hero_MonkeyKing.Spring.Channel"

  -- Get Data
  local caster = self:GetCaster()

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, caster, caster:GetTeamNumber() )
  ParticleManager:SetParticleControl( effect_cast, 0, point )
  ParticleManager:SetParticleControl( effect_cast, 4, point )
  -- ParticleManager:ReleaseParticleIndex( effect_cast )

  -- Create Sound
  EmitSoundOnLocationWithCaster( point, sound_cast, caster )

  self.effect_cast2 = effect_cast
end

function monkey_king_primal_spring_custom:StopEffects()
  ParticleManager:DestroyParticle( self.effect_cast1, false )
  ParticleManager:DestroyParticle( self.effect_cast2, false )
  ParticleManager:ReleaseParticleIndex( self.effect_cast1 )
  ParticleManager:ReleaseParticleIndex( self.effect_cast2 )

  local sound_cast = "Hero_MonkeyKing.Spring.Channel"
  StopSoundOn( sound_cast, caster )
end

function monkey_king_primal_spring_custom:PlayEffects3( point, radius )
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_spring.vpcf"
  local sound_cast = "Hero_MonkeyKing.Spring.Impact"

  -- Get Data
  local caster = self:GetCaster()

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
  ParticleManager:SetParticleControl( effect_cast, 0, point )
  ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
  ParticleManager:ReleaseParticleIndex( effect_cast )

  -- Create Sound
  EmitSoundOnLocationWithCaster( point, sound_cast, caster )
end

function monkey_king_primal_spring_custom:PlayEffects4( modifier )
  -- Get Resources
  local particle_cast = "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf"
  local sound_cast = "Hero_MonkeyKing.TreeJump.Cast"

  -- Create Particle
  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

  -- buff particle
  modifier:AddParticle(
    effect_cast,
    false, -- bDestroyImmediately
    false, -- bStatusEffect
    -1, -- iPriority
    false, -- bHeroEffect
    false -- bOverheadEffect
  )
  self:GetCaster():EmitSound(sound_cast)
end





modifier_monkey_king_primal_spring_custom = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_monkey_king_primal_spring_custom:IsHidden()
  return false
end

function modifier_monkey_king_primal_spring_custom:IsPurgable()
  return true
end

--------------------------------------------------------------------------------
-- Initializations

function modifier_monkey_king_primal_spring_custom:OnRefresh( kv )
self:OnCreated(kv)

end

function modifier_monkey_king_primal_spring_custom:OnRemoved()
end

function modifier_monkey_king_primal_spring_custom:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_monkey_king_primal_spring_custom:DeclareFunctions()
  local funcs = {
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  }

  return funcs
end

function modifier_monkey_king_primal_spring_custom:GetModifierMoveSpeedBonus_Percentage()
  return -self:GetStackCount()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
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
function monkey_king_primal_spring_early_custom:OnSpellStart()
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

self.bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_1", "bonus", true)

if not IsServer() then return end

self.parent = self:GetParent()

self.max_timer = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "cd", true)
self.duration = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "duration", true)
self.radius = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "tower_radius", true)
self.expire_timer = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "expire_timer", true)

self.count = self.max_timer


self:StartIntervalThink(1)
end

function modifier_monkey_king_primal_spring_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_monkey_king_tree_7") then return end

self.count = self.count + 1 


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), "mk_banana_change",  {banana_timer = self.count, max_timer = self.max_timer})

if self.count < self.max_timer then return end 


self.count = 0

local point

repeat point = Vector(RandomInt(-7800,7800), RandomInt(-7800,7800), 215)
until self:IsValidPoint(point)


local banana = CreateUnitByName("npc_monkey_king_banana", point, true, nil, nil, self:GetCaster():GetTeamNumber())

banana:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_monkey_king_primal_spring_custom_banana", {duration = self.duration - self.expire_timer, original = 1})
GameRules:ExecuteTeamPing(self:GetCaster():GetTeamNumber(), point.x, point.y, self:GetCaster(), 0 )

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
  MODIFIER_EVENT_ON_ATTACK_LANDED,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_EVASION_CONSTANT
}
end


function modifier_monkey_king_primal_spring_custom_tracker:GetModifierMoveSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_monkey_king_tree_1") then return end 

local bonus = 1 

if self:GetParent():HasModifier("modifier_monkey_king_primal_spring_custom_bonus") then 
  bonus = self.bonus
end 

return self:GetCaster():GetTalentValue("modifier_monkey_king_tree_1", "move")*bonus
end


function modifier_monkey_king_primal_spring_custom_tracker:GetModifierEvasion_Constant()
if not self:GetParent():HasModifier("modifier_monkey_king_tree_1") then return end 

local bonus = 1 

if self:GetParent():HasModifier("modifier_monkey_king_primal_spring_custom_bonus") then 
  bonus = self.bonus
end 

return self:GetCaster():GetTalentValue("modifier_monkey_king_tree_1", "evasion")*bonus
end


function modifier_monkey_king_primal_spring_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end 
if not self:GetCaster():HasModifier("modifier_monkey_king_tree_4") then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.no_attack_cooldown then return end

local attacker = params.attacker
if not attacker then return end 
if (attacker == self:GetParent()) or (attacker:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and attacker.owner and attacker.owner == self:GetParent()) then 

  local random = RollPseudoRandomPercentage(self:GetCaster():GetTalentValue("modifier_monkey_king_tree_4", "chance"),182, self:GetCaster()) 

  if random then 


    self:GetAbility():EndCooldown()
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_monkey_king_primal_spring_custom_instant", {duration = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_4", "duration")})

    local particle = ParticleManager:CreateParticle("particles/mk_refresh.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particle)

    self:GetCaster():EmitSound("Hero_Rattletrap.Overclock.Cast")  
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

self.original = table.original
self.expire_timer = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "expire_timer", true)
self.radius = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "radius", true)
self.vision = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "vision", true)
self.bounty = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "bounty", true)/100

if self.original and self.original == 1 then 

  local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(part, 0, self:GetParent():GetAbsOrigin())
  self:GetParent():EmitSound("Hero_MonkeyKing.Transform.On")
end 

self.particle_ally_fx = ParticleManager:CreateParticleForTeam("particles/alch_stun_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

self:StartIntervalThink(0.2)
end


function modifier_monkey_king_primal_spring_custom_banana:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end
AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision, 0.2, false)

if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.radius 
  and self:GetCaster():IsAlive() then 


  self:GetCaster():EmitSound("MK.Tree_legendary_buff")
  local particle_peffect = ParticleManager:CreateParticle("particles/mk_buff_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(particle_peffect)


  self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_monkey_king_primal_spring_custom_legendary", {})

  local minute = math.floor(GameRules:GetDOTATime(false, false) / 60)
  local gold = (bounty_gold_init + minute * bounty_gold_per_minute)*self.bounty
  local blue = (bounty_blue_init + minute * bounty_blue_per_minute)*self.bounty
  local exp = (bounty_exp_init + minute * bounty_exp_per_minute)*self.bounty


  self:GetCaster():AddExperience(exp, 5, false, false)

  my_game:AddBluePoints(self:GetCaster(), blue)

  self:GetCaster():ModifyGold(gold, true, DOTA_ModifyGold_BountyRune)
  SendOverheadEventMessage(self:GetCaster(), 0, self:GetCaster(), gold, nil)
  self:GetCaster():EmitSound("MK.Tree_bounty")

  self:Destroy()
end

end


function modifier_monkey_king_primal_spring_custom_banana:OnDestroy()
if not IsServer() then return end

local abs = self:GetParent():GetAbsOrigin()

UTIL_Remove(self:GetParent())
if self.original and self.original == 1 and self:GetRemainingTime() <= 0.1 then 

  local banana = CreateUnitByName("npc_monkey_king_banana_expire", abs, true, nil, nil, self:GetCaster():GetTeamNumber())

  banana:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_monkey_king_primal_spring_custom_banana", {duration = self.expire_timer, original = 0})

else 

  local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(part, 0, abs)
  EmitSoundOnLocationWithCaster(abs, "Hero_MonkeyKing.Transform.On", self:GetCaster())
end 

end




modifier_monkey_king_primal_spring_custom_legendary = class({})
function modifier_monkey_king_primal_spring_custom_legendary:IsHidden() return false end
function modifier_monkey_king_primal_spring_custom_legendary:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_legendary:GetTexture() return "buffs/rebound_resist" end
function modifier_monkey_king_primal_spring_custom_legendary:RemoveOnDeath() return false end
function modifier_monkey_king_primal_spring_custom_legendary:OnCreated(table)
self.damage = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "damage", true)
if not IsServer() then return end
self:SetStackCount(1)

self.max = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "max", true)
self.max_2 = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "max_2", true)
end


function modifier_monkey_king_primal_spring_custom_legendary:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if self:GetStackCount() == self.max or self:GetStackCount() == self.max_2 then 

  self:GetCaster():EmitSound("BS.Thirst_legendary_active")
  local particle_peffect = ParticleManager:CreateParticle("particles/mk_buff_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
  ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
  ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
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
function modifier_monkey_king_primal_spring_custom_bonus:IsHidden() return true end
function modifier_monkey_king_primal_spring_custom_bonus:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_bonus:GetEffectName()
return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end 

function modifier_monkey_king_primal_spring_custom_bonus:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end


modifier_monkey_king_primal_spring_custom_speed = class({})
function modifier_monkey_king_primal_spring_custom_speed:IsHidden() return false end 
function modifier_monkey_king_primal_spring_custom_speed:IsPurgable() return false end
function modifier_monkey_king_primal_spring_custom_speed:GetTexture() return 'buffs/mastery_speed' end
function modifier_monkey_king_primal_spring_custom_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_2", "speed")
self.range = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_2", "range")
end 

function modifier_monkey_king_primal_spring_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_monkey_king_primal_spring_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_monkey_king_primal_spring_custom_speed:GetModifierAttackRangeBonus()
return self.range
end