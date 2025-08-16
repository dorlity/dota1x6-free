LinkLuaModifier( "modifier_abaddon_borrowed_time_custom", "abilities/abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_borrowed_time_custom_tracker", "abilities/abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_borrowed_time_custom_legendary", "abilities/abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_borrowed_time_custom_legendary_caster", "abilities/abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_borrowed_time_custom_legendary_knock", "abilities/abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_abaddon_borrowed_time_custom_attack_cd", "abilities/abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_borrowed_time_custom_aura", "abilities/abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_borrowed_time_custom_aura_damage", "abilities/abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_borrowed_time_custom_heal", "abilities/abaddon/abaddon_borrowed_time_custom", LUA_MODIFIER_MOTION_NONE )


abaddon_borrowed_time_custom = class({})

function abaddon_borrowed_time_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_abaddon_alliance_weapon_custom") then
    return "abaddon_borrowed_time_alliance"
end
return "abaddon_borrowed_time"
end

function abaddon_borrowed_time_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_speed.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/curse_proc.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/ulti_attack.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/ulti_attacka1.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_legendary_heal.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/ulti_legendary_cast.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/ulti_legendary_link.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/ulti_legendary.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/ulti_legendary_head.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/ulti_legendary_proc.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/ulti_burn.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/ulti_heal.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf", context )
end


function abaddon_borrowed_time_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_abaddon_borrowed_time_custom_tracker"
end


function abaddon_borrowed_time_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_abaddon_borrowed_1") then
  bonus = self:GetCaster():GetTalentValue("modifier_abaddon_borrowed_1", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end


function abaddon_borrowed_time_custom:OnSpellStart()

local caster = self:GetCaster()
local duration = self:GetSpecialValueFor( "duration" ) + caster:GetTalentValue("modifier_abaddon_borrowed_1", "duration")

local mod = caster:FindModifierByName("modifier_abaddon_borrowed_time_custom_attack_cd")
if mod then
  local time = mod:GetRemainingTime()/caster:GetTalentValue("modifier_abaddon_borrowed_3", "bonus")
  mod:Destroy()
  caster:AddNewModifier(caster, self, mod:GetName(), {duration = time})
end

if caster:HasScepter() then
  local coil = caster:FindAbilityByName("abaddon_death_coil_custom")
  if coil then
    coil:EndCooldown()
  end
end

caster:AddNewModifier(caster, self, "modifier_abaddon_borrowed_time_custom", {duration = duration} )
caster:Purge( false, true, false, true, true)
end




modifier_abaddon_borrowed_time_custom = class(mod_visible)
function modifier_abaddon_borrowed_time_custom:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.RemoveForDuel = true

self.status_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_8", "status")

if not IsServer() then return end
self.parent:EmitSound("Hero_Abaddon.BorrowedTime")

if self.parent:HasTalent("modifier_abaddon_hero_8") then
  local effect_cast = ParticleManager:CreateParticle( "particles/abaddon/coil_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
  ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin()) 
  self:AddParticle( effect_cast, false, false, -1, false, false )
end 

if not self.parent:HasTalent("modifier_abaddon_borrowed_4") then return end 

self.radius = self.parent:GetTalentValue("modifier_abaddon_borrowed_4", "radius", true)
self.taunt = self.parent:GetTalentValue("modifier_abaddon_borrowed_4", "taunt", true)
self.taunt_targets = {}

self:StartIntervalThink(0.2)
end

function modifier_abaddon_borrowed_time_custom:OnIntervalThink()
if not IsServer() then return end 

if not self.parent:HasTalent("modifier_abaddon_borrowed_4") then return end

for _,target in pairs(self.parent:FindTargets(self.radius)) do 
  if target:IsHero() and not self.taunt_targets[target:entindex()] then 
    self.taunt_targets[target:entindex()] = true

    local particle_2 = ParticleManager:CreateParticle("particles/abaddon/curse_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(particle_2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle_2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle_2)
    target:AddNewModifier(self.parent, self.ability, "modifier_generic_taunt", {duration = self.taunt})
  end 
end 

end 


function modifier_abaddon_borrowed_time_custom:DamageLogic(params)
if not IsServer() then return end 
if self.parent:HasModifier("modifier_death") then return 0 end

local attacker = params.attacker
local damage = params.damage

if not attacker then return 0 end
if damage <= 0 then return 0 end

if attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then 
  self.parent:DaggerCd()
end

if attacker:IsBuilding() then return 1 end

local heal_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_heal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( heal_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControl(heal_particle, 1, attacker:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(heal_particle)

if self.parent:GetQuest() == "Abaddon.Quest_8" and not self.parent:QuestCompleted() and attacker:IsHero() and attacker ~= self.parent then 
  self.parent:UpdateQuest(math.min(damage, (self.parent:GetMaxHealth() - self.parent:GetHealth())))
end 

self.parent:GenericHeal(damage, self.ability, true, "")
return 1
end 


function modifier_abaddon_borrowed_time_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end

function modifier_abaddon_borrowed_time_custom:GetModifierStatusResistanceStacking() 
return self.status_bonus
end

function modifier_abaddon_borrowed_time_custom:GetAbsoluteNoDamagePhysical(params)
return self:DamageLogic(params)
end

function modifier_abaddon_borrowed_time_custom:GetAbsoluteNoDamageMagical(params)
return self:DamageLogic(params)
end

function modifier_abaddon_borrowed_time_custom:GetAbsoluteNoDamagePure(params)
return self:DamageLogic(params)
end

function modifier_abaddon_borrowed_time_custom:CheckState()
if not self.parent:HasTalent("modifier_abaddon_hero_8") then return end
return
{
  [MODIFIER_STATE_UNSLOWABLE] = true
}
end

function modifier_abaddon_borrowed_time_custom:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_borrowed_time.vpcf" end
function modifier_abaddon_borrowed_time_custom:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_abaddon_borrowed_time_custom:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_borrowed_time.vpcf" end
function modifier_abaddon_borrowed_time_custom:StatusEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA  end

function modifier_abaddon_borrowed_time_custom:OnDestroy()
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_abaddon_hero_8") then return end 
self.parent:AddNewModifier(self.parent, self.ability, "modifier_abaddon_borrowed_time_custom_heal", {duration = self.parent:GetTalentValue("modifier_abaddon_hero_8", "duration")})
end







modifier_abaddon_borrowed_time_custom_tracker = class({})
function modifier_abaddon_borrowed_time_custom_tracker:IsHidden() 
if not self.parent:HasTalent("modifier_abaddon_hero_4") then return true end
return self:GetStackCount() == 1 
end

function modifier_abaddon_borrowed_time_custom_tracker:GetTexture() return "buffs/borrowed_cdr" end
function modifier_abaddon_borrowed_time_custom_tracker:IsPurgable() return false end
function modifier_abaddon_borrowed_time_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.health = self.ability:GetSpecialValueFor("hp_threshold")

self.heal_bonus = self.parent:GetTalentValue("modifier_abaddon_borrowed_4", "heal_bonus")

self.health_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_4", "health")
self.cdr_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_4", "cdr")

self.attack_radius = self.parent:GetTalentValue("modifier_abaddon_borrowed_3", "radius", true)
self.attack_cd = self.parent:GetTalentValue("modifier_abaddon_borrowed_3", "cd", true)
self.attack_cd_ulti = self.parent:GetTalentValue("modifier_abaddon_borrowed_3", "bonus", true)
self.attack_damage = self.parent:GetTalentValue("modifier_abaddon_borrowed_3", "heal")/100

if not IsServer() then return end 

self.parent:AddDamageEvent_inc(self, true)

self:SetStackCount(1)

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end 


function modifier_abaddon_borrowed_time_custom_tracker:AddCustomTransmitterData() 
return 
{
  heal_bonus = self.heal_bonus,
  health_bonus = self.health_bonus,
  cdr_bonus = self.cdr_bonus,
} 
end

function modifier_abaddon_borrowed_time_custom_tracker:HandleCustomTransmitterData(data)
self.heal_bonus = data.heal_bonus
self.health_bonus = data.health_bonus
self.cdr_bonus = data.cdr_bonus
end


function modifier_abaddon_borrowed_time_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_abaddon_borrowed_4" or self.parent:HasTalent("modifier_abaddon_borrowed_4") then
  self.heal_bonus = self.parent:GetTalentValue("modifier_abaddon_borrowed_4", "heal_bonus")
end

if name == "modifier_abaddon_hero_4" or self.parent:HasTalent("modifier_abaddon_hero_4") then
  self.health_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_4", "health")
  self.cdr_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_4", "cdr")
  self:StartIntervalThink(0.2)
end

if name == "modifier_abaddon_borrowed_2" or self.parent:HasTalent("modifier_abaddon_borrowed_2") then
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_abaddon_borrowed_time_custom_aura", {})
end

if name == "modifier_abaddon_borrowed_3" or self.parent:HasTalent("modifier_abaddon_borrowed_3") then
  self.attack_damage = self.parent:GetTalentValue("modifier_abaddon_borrowed_3", "heal")/100
  self.parent:AddAttackEvent_out(self, true)
end

self:SendBuffRefreshToClients()
end


function modifier_abaddon_borrowed_time_custom_tracker:OnIntervalThink()
if not IsServer() then return end 

local stack = self.ability:GetCooldownTimeRemaining() > 0 and 0 or 1

if stack ~= self:GetStackCount() then 
  self:SetStackCount(stack)
  self.parent:CalculateStatBonus(true)
end

end

function modifier_abaddon_borrowed_time_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
  MODIFIER_PROPERTY_HEALTH_BONUS,
  MODIFIER_PROPERTY_MIN_HEALTH,
}
end

function modifier_abaddon_borrowed_time_custom_tracker:GetModifierPercentageCooldown() 
return self.cdr_bonus
end

function modifier_abaddon_borrowed_time_custom_tracker:GetModifierHealthBonus()
if self:GetStackCount() == 1 then return end 
return self.health_bonus
end
  
function modifier_abaddon_borrowed_time_custom_tracker:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_bonus
end

function modifier_abaddon_borrowed_time_custom_tracker:GetModifierHealAmplify_PercentageTarget() 
return self.heal_bonus
end

function modifier_abaddon_borrowed_time_custom_tracker:GetModifierHPRegenAmplify_Percentage() 
return self.heal_bonus
end

function modifier_abaddon_borrowed_time_custom_tracker:CheckState()
if not self.parent:HasTalent("modifier_abaddon_borrowed_3") then return end
if self.parent:HasModifier("modifier_abaddon_borrowed_time_custom_attack_cd") then return end
return
{
  [MODIFIER_STATE_CANNOT_MISS] = true
}
end


function modifier_abaddon_borrowed_time_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_abaddon_borrowed_3") then return end
if self.parent:HasModifier("modifier_abaddon_borrowed_time_custom_attack_cd") then return end
if not params.target:IsUnit() then return end
if self.parent ~= params.attacker then return end

local heal = self.parent:GetMaxHealth()*self.attack_damage

local effect_cast = ParticleManager:CreateParticle( "particles/abaddon/ulti_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
ParticleManager:SetParticleControl(effect_cast, 0, params.target:GetAbsOrigin() + Vector( 0, 0, 64 ))
ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() + Vector( 0, 0, 64 ) )
ParticleManager:SetParticleControlForward( effect_cast, 3, (params.target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized() )
ParticleManager:ReleaseParticleIndex( effect_cast )

params.target:EmitSound("Abaddon.Borrowed_attack")
params.target:EmitSound("Abaddon.Borrowed_attack2")

for _,target in pairs(self.parent:FindTargets(self.attack_radius, params.target:GetAbsOrigin())) do

  local effect = ParticleManager:CreateParticle( "particles/abaddon/ulti_attacka1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target )
  ParticleManager:SetParticleControlEnt(effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
  ParticleManager:ReleaseParticleIndex( effect )

  local real_damage = DoDamage({victim = target, attacker = self.parent, ability = self.ability, damage = heal, damage_type = DAMAGE_TYPE_MAGICAL}, "modifier_abaddon_borrowed_3")

  if target == params.target then 
    target:SendNumber(24, real_damage)
  end 
end

local cd = self.ability:GetCooldownTimeRemaining() > 0 and self.attack_cd / self.attack_cd_ulti or self.attack_cd

self.parent:AddNewModifier(self.parent, self.ability, "modifier_abaddon_borrowed_time_custom_attack_cd", {duration = cd})
self.parent:GenericHeal(heal, self.ability, false, "particles/abaddon/coil_legendary_heal.vpcf", "modifier_abaddon_borrowed_3")
end 


function modifier_abaddon_borrowed_time_custom_tracker:GetMinHealth()
if not self.parent:HasScepter() then return end
if not self.ability:IsFullyCastable() then return end 
if self.parent:HasModifier("modifier_death") then return end
if not self.parent:IsAlive() then return end
return 1
end


function modifier_abaddon_borrowed_time_custom_tracker:DamageEvent_inc(params)
if not IsServer() then return end 
if not self.ability:IsFullyCastable() then return end 
if self.parent:HasModifier("modifier_death") then return end
if not params.attacker then return end 
if not self.parent:IsAlive() then return end
if self.parent ~= params.unit then return end 
if self.parent:GetHealth() > self.health then return end 
if self.parent:PassivesDisabled() and not self.parent:HasScepter() then return end

self.ability:OnSpellStart()
self.ability:UseResources(false, false, false, true)
end 



abaddon_borrowed_time_custom_legendary = class({})

function abaddon_borrowed_time_custom_legendary:CreateTalent()
self:SetHidden(false)
end

function abaddon_borrowed_time_custom_legendary:CastFilterResultTarget(target)
if not IsServer() then return end
if target.isboss then
  return UF_FAIL_OTHER
end
return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
end

function abaddon_borrowed_time_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_abaddon_borrowed_7", "talent_cd")
end


function abaddon_borrowed_time_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

local particle = ParticleManager:CreateParticle("particles/abaddon/ulti_legendary_cast.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

if not caster:HasTalent("modifier_abaddon_borrowed_7") then return end
if target:TriggerSpellAbsorb(self) then return end 

local duration = caster:GetTalentValue("modifier_abaddon_borrowed_7", "duration")

target:EmitSound("Abaddon.Borrowed_legendary_cast")
target:EmitSound("Abaddon.Borrowed_legendary_knock")
caster:EmitSound("Abaddon.Borrowed_legendary_cast2")

caster:AddNewModifier(caster, self, "modifier_abaddon_borrowed_time_custom_legendary_caster", {duration = duration, target = target:entindex()})
target:AddNewModifier(caster, self, "modifier_abaddon_borrowed_time_custom_legendary", {duration = duration})
end


modifier_abaddon_borrowed_time_custom_legendary = class(mod_visible)
function modifier_abaddon_borrowed_time_custom_legendary:OnCreated()

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.RemoveForDuel = true

self.radius = self.caster:GetTalentValue("modifier_abaddon_borrowed_7", "radius")
self.knock_dist = self.caster:GetTalentValue("modifier_abaddon_borrowed_7", "knock_dist")
self.knockback_duration = self.caster:GetTalentValue("modifier_abaddon_borrowed_7", "knock_duration")

self.heal_reduction = self.caster:GetTalentValue("modifier_abaddon_borrowed_7", "heal_reduce")

if not IsServer() then return end 

self.pfx = ParticleManager:CreateParticle("particles/abaddon/ulti_legendary_link.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.pfx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true )
self:AddParticle( self.pfx, false, false, -1, false, false )

self.pfx2 = ParticleManager:CreateParticle("particles/abaddon/ulti_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.pfx2, 2, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
self:AddParticle( self.pfx2, false, false, -1, false, false )

self:StartIntervalThink(FrameTime())
end 

function modifier_abaddon_borrowed_time_custom_legendary:OnIntervalThink()
if not IsServer() then return end
if self.parent:HasModifier("modifier_abaddon_borrowed_time_custom_legendary_knock") then return end
if self.parent:IsInvulnerable() or self.parent:IsOutOfGame() then return end

local center = self.caster:GetAbsOrigin()

if (self.parent:GetAbsOrigin() - center):Length2D() <= self.radius then return end
  
local vec = (self.parent:GetAbsOrigin() - center):Normalized()
local knock_point = center + vec*self.knock_dist

self.parent:EmitSound("Abaddon.Borrowed_legendary_knock")
self.parent:EmitSound("Abaddon.Borrowed_legendary_knock2")

self.parent:AddNewModifier(self.caster, self.caster:BkbAbility(self.ability, true), "modifier_abaddon_borrowed_time_custom_legendary_knock", {duration = self.knockback_duration, x = knock_point.x, y = knock_point.y}) 
end


function modifier_abaddon_borrowed_time_custom_legendary:GetEffectName()
return  "particles/abaddon/ulti_legendary_head.vpcf"
end

function modifier_abaddon_borrowed_time_custom_legendary:GetEffectAttachType()
return  PATTACH_OVERHEAD_FOLLOW
end


function modifier_abaddon_borrowed_time_custom_legendary:OnDestroy()
if not IsServer() then return end 
self.caster:RemoveModifierByName("modifier_abaddon_borrowed_time_custom_legendary_caster")
end

function modifier_abaddon_borrowed_time_custom_legendary:CheckState()
return
{
  [MODIFIER_STATE_TETHERED] = true
}
end



modifier_abaddon_borrowed_time_custom_legendary_knock = class(mod_hidden)
function modifier_abaddon_borrowed_time_custom_legendary_knock:OnCreated(params)
if not IsServer() then return end
  
self.ability = self:GetAbility()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.parent:StartGesture(ACT_DOTA_FLAIL)

self.knockback_duration   = self:GetRemainingTime()
self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
self.knockback_distance = (self.parent:GetAbsOrigin() -self.position):Length2D() 

self.knockback_speed    = self.knockback_distance / self.knockback_duration

if self:ApplyHorizontalMotionController() == false then 
  self:Destroy()
  return
end

end

function modifier_abaddon_borrowed_time_custom_legendary_knock:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
local distance = (self.position - me:GetOrigin()):Normalized()
me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_abaddon_borrowed_time_custom_legendary_knock:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_abaddon_borrowed_time_custom_legendary_knock:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end

function modifier_abaddon_borrowed_time_custom_legendary_knock:OnDestroy()
if not IsServer() then return end
self.parent:RemoveHorizontalMotionController( self )
self.parent:FadeGesture(ACT_DOTA_FLAIL)
FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)
end







modifier_abaddon_borrowed_time_custom_legendary_caster = class(mod_visible)
function modifier_abaddon_borrowed_time_custom_legendary_caster:OnCreated(table)
if not IsServer() then return end 

self.RemoveForDuel = true

self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.damage = self.caster:GetTalentValue("modifier_abaddon_borrowed_7", "damage")/100

self.caster:AddHealEvent_inc(self, true)

self.target = EntIndexToHScript(table.target)
self.ability:EndCd()
end 

function modifier_abaddon_borrowed_time_custom_legendary_caster:OnDestroy()
if not IsServer() then return end
self.ability:StartCd()
end

function modifier_abaddon_borrowed_time_custom_legendary_caster:HealEvent_inc(params)
if not IsServer() then return end
if self.caster ~= params.unit then return end
if not self.target or self.target:IsNull() or not self.target:IsAlive() then return end

local gain = params.gain
local damage = self.damage*gain

if damage >= 100 then 
  self.target:EmitSound("Abaddon.Borrowed_legendary_damage")
  local pfx = ParticleManager:CreateParticle("particles/abaddon/ulti_legendary_proc.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.target)
  ParticleManager:SetParticleControlEnt( pfx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true )
  ParticleManager:SetParticleControlEnt( pfx, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true )
  ParticleManager:ReleaseParticleIndex(pfx)
end 

DoDamage({victim = self.target, attacker = self.caster, ability = self.ability, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_REFLECTION})
end 


modifier_abaddon_borrowed_time_custom_attack_cd = class(mod_cd)
function modifier_abaddon_borrowed_time_custom_attack_cd:GetTexture() return "buffs/borrowed_attack" end






modifier_abaddon_borrowed_time_custom_aura = class(mod_hidden)
function modifier_abaddon_borrowed_time_custom_aura:RemoveOnDeath() return false end

function modifier_abaddon_borrowed_time_custom_aura:OnCreated()
self.caster = self:GetCaster()
self.radius = self.caster:GetTalentValue("modifier_abaddon_borrowed_2", "radius", true)
end 

function modifier_abaddon_borrowed_time_custom_aura:GetAuraRadius()
return self.radius
end

function modifier_abaddon_borrowed_time_custom_aura:GetAuraSearchTeam()
return self.caster:HasModifier("modifier_abaddon_borrowed_time_custom") and DOTA_UNIT_TARGET_TEAM_BOTH or  DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_abaddon_borrowed_time_custom_aura:GetAuraSearchType()  return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_abaddon_borrowed_time_custom_aura:GetModifierAura() return "modifier_abaddon_borrowed_time_custom_aura_damage" end
function modifier_abaddon_borrowed_time_custom_aura:IsAura() return true end

function modifier_abaddon_borrowed_time_custom_aura:GetAuraEntityReject(hEntity)
if hEntity:GetTeamNumber() == self.caster:GetTeamNumber() and hEntity ~= self.caster then 
  return true
end
return false
end




modifier_abaddon_borrowed_time_custom_aura_damage = class(mod_hidden)
function modifier_abaddon_borrowed_time_custom_aura_damage:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.interval = self.caster:GetTalentValue("modifier_abaddon_borrowed_2", "interval")
self.damage = self.caster:GetTalentValue("modifier_abaddon_borrowed_2", "damage")*self.interval

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage = self.damage, damage_type = DAMAGE_TYPE_PURE}

if not IsServer() then return end
self:StartIntervalThink(self.interval)
end

function modifier_abaddon_borrowed_time_custom_aura_damage:OnIntervalThink()
if not IsServer() then return end
DoDamage(self.damageTable, "modifier_abaddon_borrowed_2")
end

function modifier_abaddon_borrowed_time_custom_aura_damage:GetEffectName()
return "particles/abaddon/ulti_burn.vpcf"
end

function modifier_abaddon_borrowed_time_custom_aura_damage:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end




modifier_abaddon_borrowed_time_custom_heal = class(mod_hidden)
function modifier_abaddon_borrowed_time_custom_heal:OnCreated()

self.parent = self:GetParent()

self.heal = self.parent:GetTalentValue("modifier_abaddon_hero_8", "regen")*(self.parent:GetMaxHealth() - self.parent:GetHealth())/100
self.duration = self.parent:GetTalentValue("modifier_abaddon_hero_8", "duration")

self.regen = self.heal/self.duration
if not IsServer() then return end 
self.parent:EmitSound("Abaddon.Borrowed_heal")
end

function modifier_abaddon_borrowed_time_custom_heal:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}
end

function modifier_abaddon_borrowed_time_custom_heal:GetModifierConstantHealthRegen()
return self.regen
end

function modifier_abaddon_borrowed_time_custom_heal:GetEffectName()
return "particles/abaddon/ulti_heal.vpcf"
end

function modifier_abaddon_borrowed_time_custom_heal:GetStatusEffectName()
return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function modifier_abaddon_borrowed_time_custom_heal:StatusEffectPriority()
return MODIFIER_PRIORITY_LOW 
end

