LinkLuaModifier( "modifier_morphling_waveform_custom", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_tracker", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_damage", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_legendary", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_attacks", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_trail", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_trail_thinker", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_trail_aura", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_trail_armor", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_bonus", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_waveform_custom_silence_cd", "abilities/morphling/morphling_waveform_custom", LUA_MODIFIER_MOTION_NONE )


morphling_waveform_custom = class({})


function morphling_waveform_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_waveform.vpcf", context )
PrecacheResource( "particle", "particles/morphling/wave_legendary_stack.vpcf", context )
PrecacheResource( "particle", "particles/morphling/wave_legendary_attack.vpcf", context )
PrecacheResource( "particle", "particles/morphling/wave_trail.vpcf", context )
PrecacheResource( "particle", "particles/morphling/wave_trail_effect.vpcf", context )
PrecacheResource( "particle", "particles/puck/rift_legendary_damage.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/slardar/slardar_back_ti9/slardar_back_ti9_sprint.vpcf", context )
PrecacheResource( "particle", "particles/morphling/waveform_target.vpcf", context )
dota1x6:PrecacheShopItems("npc_dota_hero_morphling", context)
end

function morphling_waveform_custom:GetAbilityTextureName()
local caster = self:GetCaster()
if caster:HasModifier("modifier_morphling_morph_custom_legendary") then
  return "kunkka_tidal_wave"
end
if caster:HasModifier("modifier_morphling_crown_custom") then
    return "morphling/crown_of_tears/morphling_waveform"
end
return "morphling_waveform"
end

function morphling_waveform_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_morphling_waveform_custom_tracker"
end

function morphling_waveform_custom:GetCooldown(level)
if self:GetCaster():HasModifier("modifier_morphling_morph_custom_legendary") then
  return self:GetCaster():GetTalentValue("modifier_morphling_attribute_7", "wave_cd")
end
return self.BaseClass.GetCooldown( self, level )
end

function morphling_waveform_custom:GetCastRange(vLocation, hTarget)
return (IsClient() or self:GetCaster():HasModifier("modifier_morphling_morph_custom_legendary")) and self:GetRange() or 99999
end

function morphling_waveform_custom:GetRange()
return self:GetSpecialValueFor("AbilityCastRange")
end

function morphling_waveform_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level) 
end

function morphling_waveform_custom:GetCastPoint(iLevel)
local bonus = 1
if self:GetCaster():HasTalent("modifier_morphling_hero_5") then
  bonus =  bonus + self:GetCaster():GetTalentValue("modifier_morphling_hero_5", "cast")/100
end
return self.BaseClass.GetCastPoint(self) * bonus
end

function morphling_waveform_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_morphling_morph_custom_legendary") then
  return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end
return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end



function morphling_waveform_custom:OnSpellStart()
local caster = self:GetCaster()
local point = self:GetCursorPosition()
local origin = caster:GetAbsOrigin()

if caster == point then
  point = origin + caster:GetForwardVector()*10
end

local range = self:GetRange() + caster:GetCastRangeBonus()
local vec = point - origin
local radius = self:GetSpecialValueFor("width")
local speed = self:GetSpecialValueFor("speed")*(1 + caster:GetTalentValue("modifier_morphling_hero_5", "speed")/100)
local min_range = 100

if vec:Length2D() > range then
  point = origin + vec:Normalized()*range
elseif vec:Length2D() <= min_range then
  point = origin + vec:Normalized()*min_range
end 

vec = point - origin

local distance = vec:Length2D()
local direction = vec:Normalized()
direction.z = 0

local attribute_legendary = caster:FindModifierByName("modifier_morphling_morph_custom_legendary")
if not attribute_legendary then
  local info = 
  {
    EffectName = caster:HasModifier("modifier_morphling_crown_custom") and "particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform.vpcf" or "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
    Ability = self,
    vSpawnOrigin = caster:GetOrigin(), 
    fStartRadius = radius,
    fEndRadius = radius,
    vVelocity = direction * speed,
    fDistance = distance,
    Source = caster,
    bDeleteOnHit = faceless_void_backtrack,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    ExtraData = 
    {
      is_target = 0,
      start_x = origin.x,
      start_y = origin.y
    }
  }
  ProjectileManager:CreateLinearProjectile(info)
else
  local target = self:GetCursorTarget()
  local info = 
  {
    EffectName = caster:HasModifier("modifier_morphling_crown_custom") and "particles/morphling/waveform_target_immortal.vpcf" or "particles/morphling/waveform_target.vpcf",
    Ability = self,
    iMoveSpeed = speed,
    Source = caster,
    Target = target,
    bDodgeable = false,
    bProvidesVision = true,
    iVisionTeamNumber = caster:GetTeamNumber(),
    iVisionRadius = 100,
    ExtraData = 
    {
      is_target = 1,
      start_x = origin.x,
      start_y = origin.y
    }
  }
  ProjectileManager:CreateTrackingProjectile( info )
end

caster:EmitSound("Hero_Morphling.Waveform")
ProjectileManager:ProjectileDodge(caster)

if caster:HasTalent("modifier_morphling_wave_3") or caster:HasTalent("modifier_morphling_wave_4") then
  caster:AddNewModifier(caster, self, "modifier_morphling_waveform_custom_trail", {duration = caster:GetTalentValue("modifier_morphling_wave_3", "duration", true)})
end

caster:AddNewModifier(caster, self, "modifier_morphling_waveform_custom", {duration = 5})
end



function morphling_waveform_custom:OnProjectileThink(location)
if not IsServer() then return end
local caster = self:GetCaster()

if not caster:HasModifier("modifier_morphling_waveform_custom") then return end
caster:SetAbsOrigin(GetGroundPosition(location, nil))
end


function morphling_waveform_custom:OnProjectileHit_ExtraData(target, vLocation, table)
local caster = self:GetCaster()

if not target or (table.is_target == 1) then 
  caster:RemoveModifierByName("modifier_morphling_waveform_custom")

  if target then
    self:DealDamage(target)
    local target_abs = target:GetAbsOrigin()

    local start_point = GetGroundPosition(Vector(table.start_x, table.start_y, 0), nil)
    local vec = (target_abs - start_point):Normalized()
    local point = target_abs + vec*120

    FindClearSpaceForUnit(caster, point, false)
  end
  if caster:HasTalent("modifier_morphling_wave_2") then
    caster:AddNewModifier(caster, self, "modifier_morphling_waveform_custom_bonus", {duration = caster:GetTalentValue("modifier_morphling_wave_2", "duration")})
  end
  return 
end

self:DealDamage(target)
end



function morphling_waveform_custom:DealDamage(target)
if not IsServer() then return end

local caster = self:GetCaster()
local damage = self:GetSpecialValueFor("damage")*(1 + caster:GetTalentValue("modifier_morphling_wave_1", "damage")/100)

ApplyDamage({victim = target, attacker = caster, damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})

local mod = target:FindModifierByName("modifier_morphling_waveform_custom_legendary")
local attacks = mod and (mod:GetStackCount() + 1) or 1
target:AddNewModifier(caster, self, "modifier_morphling_waveform_custom_attacks", {stack = attacks})

if caster:HasTalent("modifier_morphling_wave_7") then
  target:AddNewModifier(caster, self, "modifier_morphling_waveform_custom_legendary", {duration = caster:GetTalentValue("modifier_morphling_wave_7", "duration")})
end

if caster:HasTalent("modifier_morphling_hero_4") then
  target:AddNewModifier(caster, caster:BkbAbility(self, true), "modifier_morphling_adaptive_strike_custom_heal_reduce", {duration = caster:GetTalentValue("modifier_morphling_hero_4", "duration")})
end

if caster:HasModifier("modifier_morphling_crown_custom") then
    target:GenericParticle("particles/econ/items/morphling/morphling_crown_of_tears/morphling_crown_waveform_dmg.vpcf")
end

if caster:HasTalent("modifier_morphling_hero_5") and not target:HasModifier("modifier_morphling_waveform_custom_silence_cd") and not target:IsDebuffImmune() then
  target:AddNewModifier(caster, self, "modifier_morphling_waveform_custom_silence_cd", {duration = caster:GetTalentValue("modifier_morphling_hero_5", "cd")})
  target:AddNewModifier(caster, self, "modifier_generic_silence", {sound = "Sf.Raze_Silence", duration = (1 - target:GetStatusResistance())*caster:GetTalentValue("modifier_morphling_hero_5", "silence")})
end 

end



modifier_morphling_waveform_custom = class(mod_hidden)
function modifier_morphling_waveform_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end
self.parent:AddNoDraw()
self.parent:NoDraw(self)
end

function modifier_morphling_waveform_custom:OnDestroy()
if not IsServer() then return end
FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)
self.parent:StartGesture(ACT_WAVEFORM_END)
self.parent:RemoveNoDraw()
end

function modifier_morphling_waveform_custom:CheckState()
return
{
  [MODIFIER_STATE_ROOTED] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
}
end


modifier_morphling_waveform_custom_damage = class(mod_hidden)
function modifier_morphling_waveform_custom_damage:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage = self.ability:GetSpecialValueFor("pct_damage") + self.parent:GetTalentValue("modifier_morphling_wave_1", "damage") - 100
end

function modifier_morphling_waveform_custom_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end


function modifier_morphling_waveform_custom_damage:GetModifierDamageOutgoing_Percentage()
return self.damage
end







modifier_morphling_waveform_custom_tracker = class(mod_hidden)
function modifier_morphling_waveform_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.legendary_distance = self.parent:GetTalentValue("modifier_morphling_wave_7", "distance", true)
self.legendary_cd = self.parent:GetTalentValue("modifier_morphling_wave_7", "cd_inc", true)

self.move_bonus = self.parent:GetTalentValue("modifier_morphling_wave_2", "bonus", true)
self.move = self.parent:GetTalentValue("modifier_morphling_wave_2", "move")
self.armor = self.parent:GetTalentValue("modifier_morphling_wave_2", "armor")

if not IsServer() then return end
self.interval = 0.1
self.distance = 0

self.pos = self.parent:GetAbsOrigin()

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end


function modifier_morphling_waveform_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_morphling_wave_7" or self.parent:HasTalent("modifier_morphling_wave_7") then
  self.pos = self.parent:GetAbsOrigin()
  self:StartIntervalThink(self.interval)
end

if name == "modifier_morphling_wave_2" or self.parent:HasTalent("modifier_morphling_wave_2") then
  self.move = self.parent:GetTalentValue("modifier_morphling_wave_2", "move")
  self.armor = self.parent:GetTalentValue("modifier_morphling_wave_2", "armor")
end

self:SendBuffRefreshToClients()
end


function modifier_morphling_waveform_custom_tracker:AddCustomTransmitterData() 
return 
{
  move = self.move,
  armor = self.armor,
} 
end

function modifier_morphling_waveform_custom_tracker:HandleCustomTransmitterData(data)
self.move = data.move
self.armor = data.armor
end


function modifier_morphling_waveform_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_morphling_waveform_custom_tracker:GetModifierPhysicalArmorBonus()
return self.parent:HasModifier("modifier_morphling_waveform_custom_bonus") and self.armor*self.move_bonus or self.armor
end

function modifier_morphling_waveform_custom_tracker:GetModifierMoveSpeedBonus_Constant()
return self.parent:HasModifier("modifier_morphling_waveform_custom_bonus") and self.move*self.move_bonus or self.move
end


function modifier_morphling_waveform_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_morphling_wave_7") then return end

local pass = (self.parent:GetAbsOrigin() - self.pos):Length2D()
self.pos = self.parent:GetAbsOrigin()

if self.parent:HasModifier("modifier_morphling_waveform_custom") then return end
if self.ability:GetCooldownTimeRemaining() <= 0 then 
  self.distance = 0
  return 
end

local final = self.distance + pass

if final >= self.legendary_distance then 

    local delta = math.floor(final/self.legendary_distance)

    for i = 1, delta do 
      self.parent:CdAbility(self.ability, self.legendary_cd)
    end 

    self.distance = final - delta*self.legendary_distance
else 
    self.distance = final
end 

end



modifier_morphling_waveform_custom_legendary = class(mod_visible)
function modifier_morphling_waveform_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_morphling_wave_7", "max") - 1
if not IsServer() then return end
self.RemoveForDuel = true
self.effect = self.parent:GenericParticle("particles/morphling/wave_legendary_stack.vpcf", self, true)

self:SetStackCount(1)
end

function modifier_morphling_waveform_custom_legendary:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_morphling_waveform_custom_legendary:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.effect then return end
ParticleManager:SetParticleControl(self.effect, 1, Vector(0, self:GetStackCount(), 0))
end



modifier_morphling_waveform_custom_attacks = class(mod_hidden)
function modifier_morphling_waveform_custom_attacks:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.procs = self.caster:HasTalent("modifier_morphling_wave_7")
self.interval = self.caster:GetTalentValue("modifier_morphling_wave_7", "interval", true)

if not IsServer() then return end

self:SetStackCount(table.stack)
self:StartIntervalThink(self.interval)
end

function modifier_morphling_waveform_custom_attacks:OnIntervalThink()
if not IsServer() then return end

self.caster:AddNewModifier(self.caster, self.ability, "modifier_morphling_waveform_custom_damage", {duration = FrameTime()})
self.caster:PerformAttack(self.parent, false, self.procs, true, true, false, false, true)
self.caster:RemoveModifierByName("modifier_morphling_waveform_custom_damage")

self.parent:EmitSound("Morph.Wave_legendary_attack")
self.parent:EmitSound("Hero_Morphling.attack")

if self.procs then
  local particle = ParticleManager:CreateParticle( "particles/morphling/wave_legendary_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
  ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt( particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex(particle)
end

self:DecrementStackCount()
if self:GetStackCount() <= 0 then
  self:Destroy()
  return
end

end


modifier_morphling_waveform_custom_trail = class(mod_visible)
function modifier_morphling_waveform_custom_trail:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.distance = self.parent:GetTalentValue("modifier_morphling_wave_3", "distance", true)
self.effect_duration = self.parent:GetTalentValue("modifier_morphling_wave_3", "effect_duration", true)
self.pass = self.distance
self.interval = 0.2
self.pos = self.parent:GetAbsOrigin()
if not IsServer() then return end

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_morphling_waveform_custom_trail:OnIntervalThink()
if not IsServer() then return end

local pass = (self.parent:GetAbsOrigin() - self.pos):Length2D()
self.pos = self.parent:GetAbsOrigin()

self.pass = self.pass + pass

if self.pass >= self.distance then 
  self.pass = 0
  CreateModifierThinker(self.parent, self.ability, "modifier_morphling_waveform_custom_trail_thinker", {duration = self.effect_duration}, self.pos, self.parent:GetTeamNumber(), false)
end 


end





modifier_morphling_waveform_custom_trail_thinker = class(mod_hidden)
function modifier_morphling_waveform_custom_trail_thinker:IsAura() return true end
function modifier_morphling_waveform_custom_trail_thinker:GetAuraDuration() return 0.1 end
function modifier_morphling_waveform_custom_trail_thinker:GetAuraRadius() return self.radius end
function modifier_morphling_waveform_custom_trail_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_morphling_waveform_custom_trail_thinker:GetModifierAura() return "modifier_morphling_waveform_custom_trail_aura" end
function modifier_morphling_waveform_custom_trail_thinker:GetAuraEntityReject(hEntity)
return hEntity:GetTeamNumber() == self.caster:GetTeamNumber() and self.caster ~= hEntity
end

function modifier_morphling_waveform_custom_trail_thinker:GetAuraSearchTeam() 
local result = 0
if self.caster:HasTalent("modifier_morphling_wave_3") then
  result = DOTA_UNIT_TARGET_TEAM_ENEMY
end
if self.caster:HasTalent("modifier_morphling_wave_4") then
  result = result + DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
return result 
end


function modifier_morphling_waveform_custom_trail_thinker:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.radius = self.caster:GetTalentValue("modifier_morphling_wave_3", "radius", true)

if not IsServer() then return end
self.puddle_particle = ParticleManager:CreateParticle("particles/morphling/wave_trail.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.puddle_particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.puddle_particle, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.puddle_particle, false, false, -1, false, false)
end



modifier_morphling_waveform_custom_trail_aura = class(mod_hidden)
function modifier_morphling_waveform_custom_trail_aura:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.is_enemy = self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber()

self.linger = self.caster:GetTalentValue("modifier_morphling_wave_3", "linger", true)
self.slow = self.caster:GetTalentValue("modifier_morphling_wave_3", "slow")

self.regen = self.caster:GetTalentValue("modifier_morphling_wave_4", "regen")

if not IsServer() then return end

if self.is_enemy then
  self.parent:GenericParticle("particles/morphling/wave_trail_effect.vpcf", self)
  self:OnIntervalThink()
  self:StartIntervalThink(1)
else
  self.parent:GenericParticle("particles/econ/items/slardar/slardar_back_ti9/slardar_back_ti9_sprint.vpcf", self)
end

end

function modifier_morphling_waveform_custom_trail_aura:OnIntervalThink()
if not IsServer() then return end
self.parent:AddNewModifier(self.caster, self.ability, "modifier_morphling_waveform_custom_trail_armor", {duration = self.linger})
end

function modifier_morphling_waveform_custom_trail_aura:GetStatusEffectName()
if self.is_enemy then
  return "particles/status_fx/status_effect_naga_riptide.vpcf"
end

end

function modifier_morphling_waveform_custom_trail_aura:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end


function modifier_morphling_waveform_custom_trail_aura:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_morphling_waveform_custom_trail_aura:GetModifierMoveSpeedBonus_Percentage()
if not self.is_enemy then return end
return self.slow
end


function modifier_morphling_waveform_custom_trail_aura:GetModifierHealthRegenPercentage()
if self.is_enemy then return end
return self.regen
end

function modifier_morphling_waveform_custom_trail_aura:CheckState()
if self.is_enemy then return end
return
{
  [MODIFIER_STATE_UNSLOWABLE] = true
}
end



modifier_morphling_waveform_custom_trail_armor = class(mod_visible)
function modifier_morphling_waveform_custom_trail_armor:GetTexture() return "buffs/morphling/wave_3" end
function modifier_morphling_waveform_custom_trail_armor:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.max = self.caster:GetTalentValue("modifier_morphling_wave_3", "max", true)
self.armor = self.caster:GetTalentValue("modifier_morphling_wave_3", "armor")/self.max

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_morphling_waveform_custom_trail_armor:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
  self.parent:EmitSound("Morph.Wave_armor")
  self.particle = ParticleManager:CreateParticle("particles/puck/rift_legendary_damage.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControlEnt( self.particle, 0, self.parent, PATTACH_OVERHEAD_FOLLOW, "", self.parent:GetOrigin(), true )
  ParticleManager:SetParticleControlEnt( self.particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "", self.parent:GetOrigin(), true )
  self:AddParticle(self.particle, false, false, -1, false, false)
end

end

function modifier_morphling_waveform_custom_trail_armor:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_morphling_waveform_custom_trail_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end


modifier_morphling_waveform_custom_bonus = class(mod_hidden)

modifier_morphling_waveform_custom_silence_cd = class(mod_hidden)
function modifier_morphling_waveform_custom_silence_cd:OnCreated()
self.RemoveForDuel = true
end