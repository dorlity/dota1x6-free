LinkLuaModifier( "modifier_centaur_return_custom", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_legendary_banner", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_legendary_taunt", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_legendary_caster", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_legendary_destroy_banner", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_legendary_speed", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_shard_stun_cd", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_shard_spell_cd", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_regen", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_banner_aura", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_banner_purge", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_centaur_return_custom_banner_leash", "abilities/centaur/centaur_return_custom", LUA_MODIFIER_MOTION_NONE )

centaur_return_custom = class({})


function centaur_return_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_centaur_return_custom_legendary_destroy_banner") then
  return "retaliate_stop"
end
return "centaur_return"
end


function centaur_return_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_return.vpcf", context )
PrecacheResource( "particle", "particles/centaur/return_legendary_timer.vpcf", context )
PrecacheResource( "particle", "particles/centaur/reuturn_legendary_caster.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", context )
PrecacheResource( "particle", "particles/centaur/return_legendary_pulses.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf", context )
PrecacheResource( "particle", "particles/centaur/return_hit.vpcf", context )
PrecacheResource( "particle", "particles/mars/arena_linkena.vpcf", context )
PrecacheResource( "particle", "particles/centaur/return_leash.vpcf", context )
PrecacheResource( "particle", "particles/centaur/return_purge.vpcf", context )
PrecacheUnitByNameSync("npc_dota_centaur_banner", context, -1)

end


function centaur_return_custom:HasActive()
local caster = self:GetCaster()
return caster:HasTalent("modifier_centaur_retaliate_7") or caster:HasTalent("modifier_centaur_retaliate_5") or caster:HasTalent("modifier_centaur_retaliate_6")
end

function centaur_return_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_centaur_return_custom_legendary_destroy_banner") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
if self:HasActive() then
  return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function centaur_return_custom:GetAOERadius()
if not self:HasActive() then return end
return self:GetCaster():GetTalentValue("modifier_centaur_retaliate_7", "radius", true) 
end

function centaur_return_custom:GetCastRange(vLocation, hTarget)
if not self:HasActive() then return end
return self:GetCaster():GetTalentValue("modifier_centaur_retaliate_7", "range", true) 
end

function centaur_return_custom:GetCooldown(level)
if not self:HasActive() then return end
return self:GetCaster():GetTalentValue("modifier_centaur_retaliate_7", "cd", true) 
end

function centaur_return_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_centaur_return_custom"
end

function centaur_return_custom:DealDamage(target, new_caster, auto)
local caster = self:GetCaster()

if caster:PassivesDisabled() and not auto then return end
if not target or target:IsNull() or not target:IsAlive() then return end
if target:IsInvulnerable() then return end
if (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() >= 1200 then return end

local damage_base = self:GetSpecialValueFor("return_damage")
local damage_str = self:GetSpecialValueFor("return_damage_str") + caster:GetTalentValue("modifier_centaur_retaliate_1", "str")
local damage = damage_base + damage_str*caster:GetStrength()/100
local shard_chance = self:GetSpecialValueFor("shard_chance")

if caster:HasShard() and not target:HasModifier("modifier_centaur_return_custom_legendary_taunt") and not auto
  and not target:HasModifier("modifier_centaur_return_custom_shard_stun_cd") and RollPseudoRandomPercentage(shard_chance, 1896, caster) then

  target:AddNewModifier(caster, self, "modifier_bashed", {duration = (1 - target:GetStatusResistance())*self:GetSpecialValueFor("shard_stun")})
  target:AddNewModifier(caster, self, "modifier_centaur_return_custom_shard_stun_cd", {duration = self:GetSpecialValueFor("shard_cd")})
  target:EmitSound("Centaur.Return_shard_bash")
end

if auto then
  if auto == "modifier_centaur_retaliate_1" then
    damage = damage * caster:GetTalentValue("modifier_centaur_retaliate_1", "damage")/100
  end
end

if target:IsRealHero() and caster:GetQuest() == "Centaur.Quest_7" and not caster:QuestCompleted() then
  caster:UpdateQuest(1)
end

DoDamage({victim = target, attacker = caster, damage = damage, ability = self, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK}, auto)

if target:IsHero() and not auto then
  target:EmitSound("Hero_Centaur.Retaliate.Target")
end

if (caster:HasTalent("modifier_centaur_retaliate_3") or caster:HasTalent("modifier_centaur_retaliate_4")) and not auto then
  caster:AddNewModifier(caster, self, "modifier_centaur_return_custom_regen", {duration = caster:GetTalentValue("modifier_centaur_retaliate_3", "duration", true)})
end

local caster_pfx 
if new_caster then
  caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_ABSORIGIN_FOLLOW, new_caster)
  ParticleManager:SetParticleControlEnt(caster_pfx, 0, new_caster, PATTACH_POINT_FOLLOW, "torch", new_caster:GetAbsOrigin(), true)
else
  caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
  ParticleManager:SetParticleControlEnt(caster_pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
end

ParticleManager:SetParticleControlEnt(caster_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(caster_pfx)
end





function centaur_return_custom:OnSpellStart()
local caster = self:GetCaster()

local mod = caster:FindModifierByName("modifier_centaur_return_custom_legendary_destroy_banner")
if mod and mod.banner and not mod.banner:IsNull() then
  mod.banner:RemoveModifierByName("modifier_centaur_return_custom_legendary_banner")
  mod.banner:Kill(nil, nil)
  return
end

self:EndCooldown()
self:StartCooldown(1)

local duration = caster:GetTalentValue("modifier_centaur_retaliate_7", "duration", true) - 0.1
local point = self:GetCursorPosition()

caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

local banner = CreateUnitByName("npc_dota_centaur_banner", point, true, caster, caster, caster:GetTeamNumber())
banner.owner = caster
banner:AddNewModifier(caster, self, "modifier_kill", {duration = duration + 0.1})
banner:AddNewModifier(caster, self, "modifier_centaur_return_custom_legendary_banner", {duration = duration})

caster:AddNewModifier(caster, self, "modifier_centaur_return_custom_legendary_destroy_banner", {duration = duration, banner = banner:entindex()})
end




modifier_centaur_return_custom_legendary_banner = class({})
function modifier_centaur_return_custom_legendary_banner:IsHidden() return true end
function modifier_centaur_return_custom_legendary_banner:IsPurgable() return false end
function modifier_centaur_return_custom_legendary_banner:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.hits = self.caster:GetTalentValue("modifier_centaur_retaliate_7", "hits", true)
self.radius = self.caster:GetTalentValue("modifier_centaur_retaliate_7", "radius", true)
self.taunt = self.caster:GetTalentValue("modifier_centaur_retaliate_7", "taunt", true)
self.pause = self.caster:GetTalentValue("modifier_centaur_retaliate_7", "timer", true)
self.health = self.hits

self.parent:AddAttackEvent_inc(self)

if not IsServer() then return end
self.parent:EmitSound("Centaur.Return_legendary_banner1")
self.parent:EmitSound("Centaur.Return_legendary_banner2")
self.parent:EmitSound("Centaur.Return_legendary_banner3")

if self.caster:HasTalent("modifier_centaur_retaliate_6") then
  local purge = self.caster:GetTalentValue("modifier_centaur_retaliate_6", "purge")
  for _,target in pairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin(), nil, DOTA_UNIT_TARGET_FLAG_INVULNERABLE)) do
    if not target:IsDebuffImmune() then
      target:Purge(true, false, false, false,false)
    end
    target:AddNewModifier(self.caster, self.ability, "modifier_centaur_return_custom_banner_leash", {duration = self:GetRemainingTime(), banner = self.parent:entindex()})
    target:AddNewModifier(self.caster, self.ability, "modifier_centaur_return_custom_banner_purge", {duration = purge})
  end
end

self.blocked = 0

self.parent:SetMaxHealth(self.hits)
self.parent:SetHealth(self.hits)

local pos = self.parent:GetAbsOrigin() + self.parent:GetForwardVector()*10
local qangle = QAngle(0, -90, 0)
pos = RotatePosition(self.parent:GetAbsOrigin(), qangle, pos)

local dir = pos - self.parent:GetAbsOrigin()
self.parent:FaceTowards(pos)
self.parent:SetForwardVector(dir:Normalized())


self.interval = 0.1
self.count = 0
self.stage = 0
self.particle_count = 0.5
self.particle_number = -1
self.pulse_count = 1

self.timer = self.pause*2 
self:StartIntervalThink(self.interval)
self:OnIntervalThink()
end

function modifier_centaur_return_custom_legendary_banner:OnIntervalThink()
if not IsServer() then return end

local point = self.parent:GetAbsOrigin()

for _,target in pairs(self.caster:FindTargets(self.radius, point)) do 
  if target:IsRealHero() then
    AddFOWViewer(target:GetTeamNumber(), point, 50, self.interval*2, false)
  end
end

if self.pulse_count >= 0.98 then
  self.pulse_count = 0
  self.parent:EmitSound("Centaur.Return_legendary_pulse")

  local effect_cast = ParticleManager:CreateParticle( "particles/centaur/return_legendary_pulses.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent )
  ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, point, true )
  ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius,self.radius,self.radius))
  ParticleManager:SetParticleControlEnt( effect_cast, 2, self.parent, PATTACH_POINT_FOLLOW, "torch", point, true )
  ParticleManager:ReleaseParticleIndex( effect_cast )
end

self.count = self.count + self.interval
self.pulse_count = self.pulse_count + self.interval

if not self.caster:HasTalent("modifier_centaur_retaliate_7") then return end

local max = self.pause
if self.stage == 1 then
  max = self.taunt
end

if self.stage == 0 then
  self.particle_count = self.particle_count + self.interval

  if self.particle_count >= 0.5 then
    self.particle_count = 0
    self.particle_number = self.particle_number + 1

    local number = (self.timer-self.particle_number)/2 
    local int = number
    if number % 1 ~= 0 then 
      int = number - 0.5
    end

    local digits = math.floor(math.log10(number)) + 2
    local decimal = number % 1
    if decimal == 0.5 then
      decimal = 8
    else 
      decimal = 1
    end

    local particle = ParticleManager:CreateParticle("particles/centaur/return_legendary_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
    ParticleManager:SetParticleControl(particle, 0, point)
    ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
    ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
    ParticleManager:ReleaseParticleIndex(particle)
  end
end

if self.count < max then return end

self.count = 0

if self.stage == 0 then
  self.stage = 1
  self.particle_count = 0.5
  self.particle_number = -1

  if self.caster and not self.caster:IsNull() and self.caster:IsAlive() and  self.caster:HasTalent("modifier_centaur_retaliate_7") then

    if (self.caster:GetAbsOrigin() - point):Length2D() <= self.radius then
      self.caster:AddNewModifier(self.caster, self.ability, "modifier_centaur_return_custom_legendary_caster", {duration = self.taunt})
    end

    local effect_cast2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
    ParticleManager:SetParticleControlEnt( effect_cast2, 1, self.parent, PATTACH_POINT_FOLLOW, "torch", self.parent:GetAbsOrigin(), true )
    ParticleManager:ReleaseParticleIndex( effect_cast2 )

    local targets = self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())
    self.parent:EmitSound("Centaur.Return_legendary_taunt")

    local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
    ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 2, Vector(self.radius,self.radius,self.radius))
    ParticleManager:ReleaseParticleIndex( effect_cast )

    for _,target in pairs(targets) do 
      if target:IsHero() or target:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then
        target:AddNewModifier(self.caster, self.ability, "modifier_centaur_return_custom_legendary_taunt", {duration = self.taunt})
        target:AddNewModifier(self.caster, self.ability, "modifier_centaur_return_custom_legendary_speed", {duration = self.taunt})
      end
    end
  end
  return
else
  self.stage = 0
end

end

function modifier_centaur_return_custom_legendary_banner:OnDestroy()
if not IsServer() then return end
self.caster:RemoveModifierByName("modifier_centaur_return_custom_legendary_destroy_banner")
self.ability:StartCd()
self.parent:Kill(nil, nil)

self.parent:EmitSound("Centaur.Return_legendary_banner_death")
end

function modifier_centaur_return_custom_legendary_banner:DeclareFunctions() 
return
{
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
  MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
  MODIFIER_PROPERTY_HEALTHBAR_PIPS 
} 
end

function modifier_centaur_return_custom_legendary_banner:GetModifierHealthBarPips()
return self.health
end

function modifier_centaur_return_custom_legendary_banner:GetAbsoluteNoDamageMagical() return 1 end
function modifier_centaur_return_custom_legendary_banner:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_centaur_return_custom_legendary_banner:GetAbsoluteNoDamagePure() return 1 end



function modifier_centaur_return_custom_legendary_banner:AttackEvent_inc( params )
if not IsServer() then return end
if self.parent ~= params.target then return end
if params.attacker:IsIllusion() then return end
if params.attacker:IsCreep() then return end

self.ability:DealDamage(params.attacker, self.parent)
self.health = self.health - 1
 
if self.health <= 0 then
  self:Destroy()
  self.parent:Kill(nil, params.attacker)
else 
  self.parent:SetHealth(self.health)
end

end

function modifier_centaur_return_custom_legendary_banner:IsAura() return self.caster:HasTalent("modifier_centaur_retaliate_5") or self.caster:HasTalent("modifier_centaur_retaliate_6") end
function modifier_centaur_return_custom_legendary_banner:GetAuraDuration() return 0.1 end
function modifier_centaur_return_custom_legendary_banner:GetAuraRadius() return self.radius end
function modifier_centaur_return_custom_legendary_banner:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_centaur_return_custom_legendary_banner:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_centaur_return_custom_legendary_banner:GetModifierAura() return "modifier_centaur_return_custom_banner_aura" end
function modifier_centaur_return_custom_legendary_banner:GetAuraEntityReject(hEntity)
return hEntity:GetTeamNumber() == self.caster:GetTeamNumber() and hEntity ~= self.caster
end




modifier_centaur_return_custom = class({})
function modifier_centaur_return_custom:IsHidden() return true end
function modifier_centaur_return_custom:IsPurgable() return false end
function modifier_centaur_return_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.shard_spell_cd = self.ability:GetSpecialValueFor("shard_spell_cd")

self.edge = self.parent:FindAbilityByName("centaur_double_edge_custom")

if self.parent:IsRealHero() then
  self.parent:AddAttackEvent_inc(self)
end

self.parent:AddAttackEvent_out(self)
self.parent:AddDamageEvent_inc(self)

self.base_interval = self.parent:GetTalentValue("modifier_centaur_retaliate_1", "interval", true)
self.auto_radius = self.parent:GetTalentValue("modifier_centaur_retaliate_1", "radius", true)

self.edge_chance = self.parent:GetTalentValue("modifier_centaur_retaliate_4", "chance", true)

self.status = self.parent:GetTalentValue("modifier_centaur_retaliate_5", "status", true)
self.status_bonus = self.parent:GetTalentValue("modifier_centaur_retaliate_5", "bonus", true)

self.armor_health = self.parent:GetTalentValue("modifier_centaur_retaliate_2", "health", true)
self.armor_bonus = self.parent:GetTalentValue("modifier_centaur_retaliate_2", "bonus", true)

if not IsServer() then return end
self:StartIntervalThink(self.base_interval)
end

function modifier_centaur_return_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end

function modifier_centaur_return_custom:GetModifierStatusResistanceStacking() 
if not self.parent:HasTalent("modifier_centaur_retaliate_5") then return end
local bonus = self.status
if self.parent:HasModifier("modifier_centaur_return_custom_banner_aura") then
  bonus = bonus * self.status_bonus
end
return bonus
end

function modifier_centaur_return_custom:GetModifierPhysicalArmorBonus()
if not self.parent:HasTalent("modifier_centaur_retaliate_2") then return end
local bonus = self.parent:GetTalentValue("modifier_centaur_retaliate_2", "armor")
if self.parent:GetHealthPercent() <= self.armor_health then
  bonus = bonus * self.armor_bonus
end
return bonus
end

function modifier_centaur_return_custom:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_centaur_retaliate_2") then return end
local bonus = self.parent:GetTalentValue("modifier_centaur_retaliate_2", "move")
if self.parent:GetHealthPercent() <= self.armor_health then
  bonus = bonus * self.armor_bonus
end
return bonus
end

function modifier_centaur_return_custom:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_centaur_retaliate_1") then return end
if not self.parent:IsAlive() then return end

local targets = self.parent:FindTargets(self.auto_radius)

if #targets > 0 then
  self.parent:EmitSound("Hero_Centaur.Retaliate.Target")

  for _,target in pairs(targets) do
    self.ability:DealDamage(target, nil, "modifier_centaur_retaliate_1")
  end
else
  self:StartIntervalThink(0.2)
  return
end

self:StartIntervalThink(self.base_interval)
end

function modifier_centaur_return_custom:AttackEvent_out(params)
if not IsServer() then return end
local target = params.target

if self.parent == params.attacker and target:IsUnit() then
  if self.parent:HasTalent("modifier_centaur_retaliate_4") and self.edge and self.edge:IsTrained() and RollPseudoRandomPercentage(self.edge_chance, 1898, self.parent) then
    self.edge:OnSpellStart(target, "modifier_centaur_retaliate_4")
  end
end

end

function modifier_centaur_return_custom:AttackEvent_inc(params)
if not IsServer() then return end
if self.parent:HasShard() then return end
if self.parent ~= params.target then return end
if not params.attacker:IsUnit() then return end

self.ability:DealDamage(params.attacker)
end


function modifier_centaur_return_custom:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if not params.attacker:IsUnit() then return end
if params.attacker:GetTeamNumber() == self.parent:GetTeamNumber() then return end
  if params.original_damage <= 1 then return end

if not self.parent:HasShard() then return end

if params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then 
  if self.parent:HasModifier("modifier_centaur_return_custom_shard_spell_cd") then return end
  self.parent:AddNewModifier(self.parent, self.ability, "modifier_centaur_return_custom_shard_spell_cd", {duration = self.shard_spell_cd})
end

self.ability:DealDamage(params.attacker)
end





modifier_centaur_return_custom_legendary_taunt = class({})
function modifier_centaur_return_custom_legendary_taunt:IsPurgable() return false end
function modifier_centaur_return_custom_legendary_taunt:IsHidden() return true end

function modifier_centaur_return_custom_legendary_taunt:OnCreated( kv )
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.parent:Stop()
self.parent:Interrupt()

self.parent:SetForceAttackTarget( self:GetCaster() )
self.parent:MoveToTargetToAttack( self:GetCaster() )
self:StartIntervalThink(FrameTime())
end

function modifier_centaur_return_custom_legendary_taunt:OnIntervalThink()
if not IsServer() then return end

if not self.caster or self.caster:IsNull() or not self.caster:IsAlive() 
  or (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() >= 1200 then
  self.parent:Stop()
  self.parent:Interrupt()
  self:Destroy()
end

end

function modifier_centaur_return_custom_legendary_taunt:OnDestroy()
if not IsServer() then return end
self.parent:SetForceAttackTarget( nil )
end

function modifier_centaur_return_custom_legendary_taunt:CheckState()
return 
{
  [MODIFIER_STATE_TAUNTED] = true,
}
end

function modifier_centaur_return_custom_legendary_taunt:GetStatusEffectName()
return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_centaur_return_custom_legendary_taunt:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end



modifier_centaur_return_custom_legendary_caster = class({})
function modifier_centaur_return_custom_legendary_caster:IsHidden() return true end
function modifier_centaur_return_custom_legendary_caster:IsPurgable() return false end
function modifier_centaur_return_custom_legendary_caster:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_reduce = self.parent:GetTalentValue("modifier_centaur_retaliate_7", "damage_reduce")
if not IsServer() then return end

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_double_edge_body.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

self.parent:EmitSound("Centaur.Return_legendary_caster")
self.parent:GenericParticle("particles/centaur/reuturn_legendary_caster.vpcf", self)
end

function modifier_centaur_return_custom_legendary_caster:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_centaur_return_custom_legendary_caster:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end

function modifier_centaur_return_custom_legendary_caster:GetStatusEffectName()
return "particles/status_fx/status_effect_overpower.vpcf"
end

function modifier_centaur_return_custom_legendary_caster:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end


modifier_centaur_return_custom_legendary_speed = class({})
function modifier_centaur_return_custom_legendary_speed:IsHidden() return true end
function modifier_centaur_return_custom_legendary_speed:IsPurgable() return false end
function modifier_centaur_return_custom_legendary_speed:OnCreated( kv )
self.speed = self:GetCaster():GetTalentValue("modifier_centaur_retaliate_7", "speed")
end

function modifier_centaur_return_custom_legendary_speed:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_centaur_return_custom_legendary_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end



modifier_centaur_return_custom_shard_spell_cd = class({})
function modifier_centaur_return_custom_shard_spell_cd:IsHidden() return true end
function modifier_centaur_return_custom_shard_spell_cd:IsPurgable() return false end

modifier_centaur_return_custom_shard_stun_cd = class({})
function modifier_centaur_return_custom_shard_stun_cd:IsHidden() return true end
function modifier_centaur_return_custom_shard_stun_cd:IsPurgable() return false end




modifier_centaur_return_custom_regen = class({})
function modifier_centaur_return_custom_regen:IsHidden() return false end
function modifier_centaur_return_custom_regen:IsPurgable() return false end
function modifier_centaur_return_custom_regen:GetTexture() return "buffs/return_regen" end
function modifier_centaur_return_custom_regen:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_centaur_retaliate_3", "max", true)
self.str = self.parent:GetTalentValue("modifier_centaur_retaliate_3", "str")/self.max
self.regen = self.parent:GetTalentValue("modifier_centaur_retaliate_3", "regen")/self.max
self.speed = self.parent:GetTalentValue("modifier_centaur_retaliate_4", "speed")/self.max

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_centaur_return_custom_regen:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_centaur_return_custom_regen:OnStackCountChanged(iStackCount)
if not IsServer() then return end
self.PercentStr = self:GetStackCount()*self.str/100
end

function modifier_centaur_return_custom_regen:OnDestroy()
if not IsServer() then return end
self.parent:PercentRefresh()
end

function modifier_centaur_return_custom_regen:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_centaur_return_custom_regen:OnTooltip()
if not self.parent:HasTalent("modifier_centaur_retaliate_3") then return end
return self:GetStackCount()*self.str
end

function modifier_centaur_return_custom_regen:GetModifierConstantHealthRegen()
if not self.parent:HasTalent("modifier_centaur_retaliate_3") then return end
return self:GetStackCount()*self.regen
end

function modifier_centaur_return_custom_regen:GetModifierAttackSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_centaur_retaliate_4") then return end
return self:GetStackCount()*self.speed
end

modifier_centaur_return_custom_banner_aura = class({})
function modifier_centaur_return_custom_banner_aura:IsHidden() return true end
function modifier_centaur_return_custom_banner_aura:IsPurgable() return false end
function modifier_centaur_return_custom_banner_aura:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.is_enemy = self.parent ~= self.caster

self.slow = self.caster:GetTalentValue("modifier_centaur_retaliate_6", "slow", true)

if not IsServer() then return end

if not self.is_enemy and self.caster:HasTalent("modifier_centaur_retaliate_5") then
  self.parent:GenericParticle("particles/items4_fx/ascetic_cap.vpcf", self)
end

if self.is_enemy and self.caster:HasTalent("modifier_centaur_retaliate_6") then
  self.parent:GenericParticle("particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf", self)
end

end

function modifier_centaur_return_custom_banner_aura:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ABSORB_SPELL,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_centaur_return_custom_banner_aura:GetModifierMoveSpeedBonus_Percentage()
if not self.caster:HasTalent("modifier_centaur_retaliate_6") then return end
if not self.is_enemy then return end
return self.slow
end

function modifier_centaur_return_custom_banner_aura:GetAbsorbSpell(params) 
if not IsServer() then return end
if not self.caster:HasTalent("modifier_centaur_retaliate_5") then return end
if self.is_enemy then return end

local aura_owner = self:GetAuraOwner()
if not aura_owner or aura_owner:IsNull() then return end

local owner_mod = aura_owner:FindModifierByName("modifier_centaur_return_custom_legendary_banner")
if not owner_mod or owner_mod.blocked == 1 then return end

if not params.ability or not params.ability:GetCaster() then return end
if params.ability:GetCaster():GetTeamNumber() == self.parent:GetTeamNumber() then return end

owner_mod.blocked = 1

local particle = ParticleManager:CreateParticle("particles/mars/arena_linkena.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self.parent:EmitSound("DOTA_Item.LinkensSphere.Activate")
return 1 
end

function modifier_centaur_return_custom_banner_aura:GetStatusEffectName()
if not self:GetCaster():HasTalent("modifier_centaur_retaliate_6") then return end
if self:GetCaster() == self:GetParent() then return end
return "particles/status_fx/status_effect_monkey_king_spring_slow.vpcf"
end

function modifier_centaur_return_custom_banner_aura:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end




modifier_centaur_return_custom_legendary_destroy_banner = class({})
function modifier_centaur_return_custom_legendary_destroy_banner:IsHidden() return true end
function modifier_centaur_return_custom_legendary_destroy_banner:IsPurgable() return false end
function modifier_centaur_return_custom_legendary_destroy_banner:OnCreated(table)
if not IsServer() then return end
self.banner = EntIndexToHScript(table.banner)
end



modifier_centaur_return_custom_banner_leash = class({})
function modifier_centaur_return_custom_banner_leash:IsHidden() return true end
function modifier_centaur_return_custom_banner_leash:IsPurgable() return false end
function modifier_centaur_return_custom_banner_leash:OnCreated(table)
if not IsServer() then return end 

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.thinker = EntIndexToHScript(table.banner)
self.radius = self.caster:GetTalentValue("modifier_centaur_retaliate_7", "radius", true)
self.RemoveForDuel = true

self.knockback_duration = self.caster:GetTalentValue("modifier_centaur_retaliate_6", "knock_duration")

local effect_cast_2 = ParticleManager:CreateParticle( "particles/centaur/return_leash.vpcf", PATTACH_ABSORIGIN, self.parent )
ParticleManager:SetParticleControl( effect_cast_2, 0, self.thinker:GetAbsOrigin() )
ParticleManager:SetParticleControlEnt(effect_cast_2, 1, self.parent, PATTACH_POINT_FOLLOW,"attach_hitloc", self.parent:GetOrigin(),true)
self:AddParticle(effect_cast_2,false,false,-1,false,false)

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end 

function modifier_centaur_return_custom_banner_leash:OnIntervalThink()
if not IsServer() then return end 

if not self.thinker or self.thinker:IsNull() or not self.thinker:IsAlive() then 
  self:Destroy()
  return
end  

if (self.parent:GetAbsOrigin() - self.thinker:GetAbsOrigin()):Length2D() > self.radius and not self.parent:IsInvulnerable() and not self.parent:IsOutOfGame() then 
  self.parent:EmitSound("Centaur.Return_banner_knock")
  self.thinker:PullTarget(self.parent, self.ability, self.knockback_duration)
  self:Destroy()
end

end 


modifier_centaur_return_custom_banner_purge = class({})
function modifier_centaur_return_custom_banner_purge:IsHidden() return true end
function modifier_centaur_return_custom_banner_purge:IsPurgable() return false end

function modifier_centaur_return_custom_banner_purge:OnCreated()
if not IsServer() then return end 

self.parent = self:GetParent()
self.parent:GenericParticle("particles/centaur/return_purge.vpcf", self, true)

if self.parent:IsRealHero() then
  self.parent:EmitSound("Centaur.Return_purge")
end

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 

function modifier_centaur_return_custom_banner_purge:OnIntervalThink()
if not IsServer() then return end 
if self.parent:IsDebuffImmune() then return end

self.parent:Purge(true, false, false, false,false)
end 

