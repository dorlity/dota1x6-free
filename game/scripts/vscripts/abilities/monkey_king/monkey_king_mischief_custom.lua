LinkLuaModifier("modifier_monkey_king_mischief_custom", "abilities/monkey_king/monkey_king_mischief_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_mischief_anim", "abilities/monkey_king/monkey_king_mischief_custom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_monkey_king_mischief_invun", "abilities/monkey_king/monkey_king_mischief_custom.lua", LUA_MODIFIER_MOTION_NONE)




monkey_king_mischief_custom = class({})


function monkey_king_mischief_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
  
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_monkey_king.vsndevts", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", context )
PrecacheResource( "soundfile", "soundevents/vo_custom/monkey_king_vo_custom.vsndevts", context ) 
end


function monkey_king_mischief_custom:CreateTalent(name)

self:GetCaster():RemoveModifierByName("modifier_monkey_king_transform")
self:GetCaster():SwapAbilities("monkey_king_mischief", "monkey_king_mischief_custom", false, true)
self:ToggleAutoCast()
end


function monkey_king_mischief_custom:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_monkey_king_command_7", "cd")
end

function monkey_king_mischief_custom:GetCastRange()

if IsClient() then 
  return self:GetSpecialValueFor("range")
else 
  return 999999
end

end

function monkey_king_mischief_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_monkey_king_mischief_custom") then
  return "monkey_king_untransform"
end
return "monkey_king_mischief"
end

function monkey_king_mischief_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_monkey_king_mischief_custom") then 
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE +  DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IMMEDIATE +  DOTA_ABILITY_BEHAVIOR_AUTOCAST
end



function monkey_king_mischief_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_monkey_king_mischief_custom")

if mod then 
  mod:Destroy()
  return
end 

local point = self:GetCursorPosition()
local range = self:GetSpecialValueFor("range") + caster:GetCastRangeBonus()
local duration = caster:GetTalentValue("modifier_monkey_king_command_7", "duration")

local min_range = 150

if point == caster:GetAbsOrigin() then 
  point = caster:GetAbsOrigin() + caster:GetForwardVector()
end 

local vec = point - caster:GetAbsOrigin()

if vec:Length2D() < min_range then 
    point = caster:GetAbsOrigin() + vec:Normalized()*min_range
end 

if vec:Length2D() > range then 
  point = caster:GetAbsOrigin() + vec:Normalized()*range
end 


local main = caster:FindAbilityByName("monkey_king_wukongs_command_custom")
if main:GetLevel() < 1 then return end 


local monkey_origin = main:SpawnMonkeyKingPointScepter(caster:GetAbsOrigin(), duration, true, true)
local monkey_target = main:SpawnMonkeyKingPointScepter(point, duration, true, true)

if not monkey_target or not monkey_origin then return end

local monkey = monkey_origin
if self:GetAutoCastState() == true then 
  monkey = monkey_target
end

EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_MonkeyKing.Transform.On", caster)
caster:RemoveModifierByName("modifier_monkey_king_tree_dance_custom")
caster:Stop()
ProjectileManager:ProjectileDodge(caster)
FindClearSpaceForUnit(caster, monkey:GetAbsOrigin(), false)



caster:AddNewModifier(caster, self, "modifier_monkey_king_mischief_invun", {duration = self:GetSpecialValueFor("invun")})
caster:AddNewModifier(caster, self, "modifier_monkey_king_mischief_custom", {duration = duration, monkey = monkey:entindex()})


local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)

for _,target in pairs(targets) do 
  local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(part, 0, target:GetAbsOrigin())
  ParticleManager:ReleaseParticleIndex(part)

  FindClearSpaceForUnit(target, target:GetAbsOrigin(), false)
end 

self:EndCooldown()
self:StartCooldown(0.3)
end





modifier_monkey_king_mischief_custom = class({})

function modifier_monkey_king_mischief_custom:IsHidden() return false end
function modifier_monkey_king_mischief_custom:IsPurgable() return false end

function modifier_monkey_king_mischief_custom:OnCreated(params)
if not IsServer() then return end

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:NoDraw(self)
self.parent:AddNoDraw()
self.RemoveForDuel = true 


self.monkey = EntIndexToHScript(params.monkey)
self.pos = self:GetCaster():GetAbsOrigin()

self.monkey:AddAttackEvent_inc(self)
self.monkey:AddAttackFailEvent_inc(self)

self.skills = {}

self.skills[1] = self.parent:FindAbilityByName("monkey_king_boundless_strike_custom")
self.skills[2] = self.parent:FindAbilityByName("monkey_king_tree_dance_custom")
self.skills[3] = self.parent:FindAbilityByName("monkey_king_primal_spring_custom")
self.skills[4] = self.parent:FindAbilityByName("monkey_king_jingu_mastery_custom")
--self.skills[5] = self.parent:FindAbilityByName("monkey_king_wukongs_command_custom")

for _,skill in pairs(self.skills) do 
  skill:SetActivated(false)
end

self:StartIntervalThink(0.2)
end



function modifier_monkey_king_mischief_custom:OnIntervalThink()
if not IsServer() then return end
if not self.monkey or self.monkey:IsNull() or self.monkey:HasModifier("modifier_monkey_king_wukongs_command_custom_inactive") then 
  self:Destroy()
  return
end 

self.parent:SetAbsOrigin(self.monkey:GetAbsOrigin())
end




function modifier_monkey_king_mischief_custom:CheckState()
return {
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_ROOTED] = true,
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_MUTED] = true,
  }
end



function modifier_monkey_king_mischief_custom:AttackEvent_inc(params)
if not IsServer() then return end
if not params.attacker:IsHero() then return end
if self.monkey == nil or self.monkey:IsNull() then 
  self:Destroy()
  return
end

if self.monkey ~= params.target then return end
print('attack!')
self:Destroy()

end


function modifier_monkey_king_mischief_custom:AttackFailEvent_inc(params)
if not IsServer() then return end
if not params.attacker:IsHero() then return end
if self.monkey == nil or self.monkey:IsNull() then 
  self:Destroy()
  return
end

if self.monkey ~= params.target then return end
if params.inflictor then return end
if params.damage_category == 0 then return end

self:Destroy()
end


function modifier_monkey_king_mischief_custom:OnDestroy()
if not IsServer() then return end
self.parent:RemoveNoDraw()

self.ability:UseResources(false, false, false, true)

local ability = self.parent:FindAbilityByName("monkey_king_mischief_custom")

if ability then 
  ability:UseResources(false, false, false, true)
end

for _,skill in pairs(self.skills) do 
  if skill:GetName() == "monkey_king_primal_spring_custom" then 

    skill:SetActivated(skill:CanBeCast())
  else 
    skill:SetActivated(true)
  end 
end

self:GetCaster():SetForwardVector(self.monkey:GetForwardVector())
self:GetCaster():FaceTowards(self:GetCaster():GetAbsOrigin() + self.monkey:GetForwardVector()*10)

if self.monkey then 
 self.monkey:RemoveModifierByName("modifier_monkey_king_wukongs_command_custom_soldier_active")
end

local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part, 0, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(part)

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Hero_MonkeyKing.Transform.On", self.parent)
end













modifier_monkey_king_mischief_anim = class({})
function modifier_monkey_king_mischief_anim:IsHidden() return false end
function modifier_monkey_king_mischief_anim:IsPurgable() return false end


modifier_monkey_king_mischief_invun = class({})
function modifier_monkey_king_mischief_invun:IsHidden() return true end
function modifier_monkey_king_mischief_invun:IsPurgable() return false end