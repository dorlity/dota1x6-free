LinkLuaModifier( "modifier_life_stealer_dragon_fireball_thinker", "abilities/life_stealer/infest_creeps_dragon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_dragon_fireball_burn", "abilities/life_stealer/infest_creeps_dragon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_dragon_fireball_resist", "abilities/life_stealer/infest_creeps_dragon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_dragon_flight", "abilities/life_stealer/infest_creeps_dragon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_dragon_arcane_power", "abilities/life_stealer/infest_creeps_dragon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_dragon_arcane_power_aura", "abilities/life_stealer/infest_creeps_dragon", LUA_MODIFIER_MOTION_NONE )

life_stealer_dragon_fireball = class({})

function life_stealer_dragon_fireball:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/lifestealer/infest_dragon_proj.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/infest_dragon_fire.vpcf", context )
PrecacheResource( "particle", "particles/lifestealer/infest_dragon_projf.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf", context )
end


function life_stealer_dragon_fireball:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end


function life_stealer_dragon_fireball:OnSpellStart()
local caster = self:GetCaster()
local point = self:GetCursorPosition()
local speed = self:GetSpecialValueFor("projectile_speed")
local dir = (point - caster:GetAbsOrigin())

caster:EmitSound("Lifestealer.Infest_dragin_fire_cast")
local projectile =
{
  Ability              = self,
  EffectName           = "particles/lifestealer/infest_dragon_proj.vpcf",
  vSpawnOrigin        = caster:GetAbsOrigin() + Vector(0, 0, 150),
  fDistance            = dir:Length2D(),
  fStartRadius        = 0,
  fEndRadius            = 0,
  Source                = caster,
  bHasFrontalCone        = false,
  bReplaceExisting    = false,
  fExpireTime         = GameRules:GetGameTime() + 5.0,
  bDeleteOnHit        = false,
  vVelocity            = dir:Normalized()*speed*(Vector(1,1,0)),
  
	bProvidesVision = true,
	iVisionTeamNumber = caster:GetTeamNumber(),
	iVisionRadius = 100,
}
ProjectileManager:CreateLinearProjectile(projectile)   
end


function life_stealer_dragon_fireball:OnProjectileHit(target, vLocation)
if target then return end
local caster = self:GetCaster()

local owner = caster.owner
local bonus_duration = owner and owner:GetTalentValue("modifier_lifestealer_infest_3", "duration") or 0
local bonus = owner and owner:GetTalentValue("modifier_lifestealer_infest_3", "bonus")/100 or 0

local duration = self:GetSpecialValueFor("fire_duration")
local point = GetGroundPosition(vLocation, nil)
local radius = self:GetSpecialValueFor("aoe_radius")
local damage = self:GetSpecialValueFor("damage_init")

local effect = ParticleManager:CreateParticle("particles/lifestealer/infest_dragon_projf.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, point + Vector(0, 0, 60))
ParticleManager:ReleaseParticleIndex(effect)

local damageTable = {attacker = caster, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL}
for _,target in pairs(caster:FindTargets(radius, vLocation)) do
	damageTable.victim = target
	local target_damage = damage

	local mod = target:FindModifierByName("modifier_life_stealer_infest_custom_legendary_bonus")
	if mod then
		target_damage = target_damage*(1 + bonus*mod:GetStackCount())
	end

	damageTable.damage = target_damage
	local real_damage = DoDamage(damageTable)
	target:SendNumber(6, real_damage)

	if owner and owner:HasTalent("modifier_lifestealer_infest_3") then
		target:AddNewModifier(owner, self, "modifier_life_stealer_infest_custom_legendary_bonus", {duration = bonus_duration})
	end
end

EmitSoundOnLocationWithCaster(point, "Lifestealer.Infest_dragin_fire_hit", caster)
AddFOWViewer(caster:GetTeamNumber(), point, radius, duration, false)

CreateModifierThinker(caster, self, "modifier_life_stealer_dragon_fireball_thinker", {duration =  duration}, point, caster:GetTeamNumber(), false)
end 





modifier_life_stealer_dragon_fireball_thinker = class(mod_hidden)
function modifier_life_stealer_dragon_fireball_thinker:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("aoe_radius")
self.duration = self:GetRemainingTime()

self.nFXIndex = ParticleManager:CreateParticle("particles/lifestealer/infest_dragon_fire.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.nFXIndex, 0, self.parent:GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 1, Vector(self.duration, 0, 0))
self:AddParticle(self.nFXIndex, false, false, -1, false, false)

self.parent:EmitSound("Lifestealer.Infest_dragin_fire_burn")
end

function modifier_life_stealer_dragon_fireball_thinker:OnDestroy()
if not IsServer() then return end 
self.parent:StopSound("Lifestealer.Infest_dragin_fire_burn")
end 

function modifier_life_stealer_dragon_fireball_thinker:IsAura() return true end
function modifier_life_stealer_dragon_fireball_thinker:GetAuraDuration() return 0.1 end
function modifier_life_stealer_dragon_fireball_thinker:GetAuraRadius() return self.radius end
function modifier_life_stealer_dragon_fireball_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_life_stealer_dragon_fireball_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_life_stealer_dragon_fireball_thinker:GetModifierAura() return "modifier_life_stealer_dragon_fireball_burn" end





modifier_life_stealer_dragon_fireball_burn = class(mod_hidden)
function modifier_life_stealer_dragon_fireball_burn:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.resist_duration = self.ability:GetSpecialValueFor("resist_duration")

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.ability:GetSpecialValueFor("damage_fire")}

if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(1)
end

function modifier_life_stealer_dragon_fireball_burn:OnIntervalThink()
if not IsServer() then return end
self.parent:AddNewModifier(self.caster, self.ability, "modifier_life_stealer_dragon_fireball_resist", {duration = self.resist_duration})

local real_damage = DoDamage(self.damageTable)
self.parent:SendNumber(4, real_damage)
end

function modifier_life_stealer_dragon_fireball_burn:GetStatusEffectName()
return "particles/status_fx/status_effect_burn.vpcf"
end

function modifier_life_stealer_dragon_fireball_burn:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end



modifier_life_stealer_dragon_fireball_resist = class(mod_visible)
function modifier_life_stealer_dragon_fireball_resist:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.max = self.ability:GetSpecialValueFor("max_resist")
self.magic_resist = self.ability:GetSpecialValueFor("magic_resist")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_life_stealer_dragon_fireball_resist:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_life_stealer_dragon_fireball_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_life_stealer_dragon_fireball_resist:GetModifierMagicalResistanceBonus()
return self.magic_resist*self:GetStackCount()
end

function modifier_life_stealer_dragon_fireball_resist:GetEffectName()
return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end



life_stealer_dragon_flight = class({})

function life_stealer_dragon_flight:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/lifestealer/infest_dragon_flight.vpcf", context )
end


function life_stealer_dragon_flight:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration")

local owner = caster.owner
local duration = self:GetSpecialValueFor("duration")
if owner and owner:HasTalent("modifier_lifestealer_hero_8") then
	duration = duration * (1 + owner:GetTalentValue("modifier_lifestealer_hero_8", "duration")/100)
end

caster:EmitSound("Lifestealer.Infest_dragin_flight")
caster:AddNewModifier(caster, self, "modifier_life_stealer_dragon_flight", {duration = duration})
end


modifier_life_stealer_dragon_flight = class(mod_visible)
function modifier_life_stealer_dragon_flight:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.move = self.ability:GetSpecialValueFor("move")
self.range = self.ability:GetSpecialValueFor("attack_range")
self.vision = self.ability:GetSpecialValueFor("vision")
if not IsServer() then return end

end

function modifier_life_stealer_dragon_flight:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_BONUS_DAY_VISION,
	MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_life_stealer_dragon_flight:GetBonusDayVision()
return self.vision
end

function modifier_life_stealer_dragon_flight:GetBonusNightVision()
return self.vision
end

function modifier_life_stealer_dragon_flight:GetModifierMoveSpeedBonus_Constant()
return self.move
end

function modifier_life_stealer_dragon_flight:GetModifierAttackRangeBonus()
return self.range
end

function modifier_life_stealer_dragon_flight:CheckState()
return
{
	[MODIFIER_STATE_FLYING] = true
}
end

function modifier_life_stealer_dragon_flight:GetEffectName()
return "particles/lifestealer/infest_dragon_flight.vpcf"
end

function modifier_life_stealer_dragon_flight:OnDestroy()
if not IsServer() then return end
self.parent:EmitSound("Lifestealer.Infest_dragin_flight_end")
GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), 150, true )
end




life_stealer_dragon_arcane_power = class({})
function life_stealer_dragon_arcane_power:GetIntrinsicModifierName()
return "modifier_life_stealer_dragon_arcane_power"
end

modifier_life_stealer_dragon_arcane_power = class(mod_hidden)
function modifier_life_stealer_dragon_arcane_power:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end
self:StartIntervalThink(0.2)
end


function modifier_life_stealer_dragon_arcane_power:OnIntervalThink()
if not IsServer() then return end
local owner = self.parent.owner

if owner and not owner:IsNull() then
	if not owner:HasModifier("modifier_life_stealer_dragon_arcane_power_aura") then
		owner:AddNewModifier(owner, self.ability, "modifier_life_stealer_dragon_arcane_power_aura", {})
	end

	if not self.parent:IsAlive() or self.parent:IsNull() then
		owner:RemoveModifierByName("modifier_life_stealer_dragon_arcane_power_aura")
		self:StartIntervalThink(-1)
	end
end 

end

function modifier_life_stealer_dragon_arcane_power:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
 -- MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
}
end

function modifier_life_stealer_dragon_arcane_power:GetOverrideAttackMagical()
return 1
end

function modifier_life_stealer_dragon_arcane_power:GetModifierTotalDamageOutgoing_Percentage(params)
if not IsServer() then return end
if not params.record then return end 
if params.inflictor then return 0 end
if params.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
if params.damage_type == DAMAGE_TYPE_MAGICAL then return 0 end

local damageTable = {
  attacker = self.parent,
  damage = params.original_damage,
  damage_type = DAMAGE_TYPE_MAGICAL,
  victim = params.target,
  ability = self.ability,
  damage_flags = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK
}
DoDamage(damageTable)
return -200
end



modifier_life_stealer_dragon_arcane_power_aura = class(mod_visible)
function modifier_life_stealer_dragon_arcane_power_aura:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.cdr = self.ability:GetSpecialValueFor("cdr")
self.cast_range = self.ability:GetSpecialValueFor("cast_range")
end

function modifier_life_stealer_dragon_arcane_power_aura:OnRefresh()
self.cdr = self.ability:GetSpecialValueFor("cdr")
self.cast_range = self.ability:GetSpecialValueFor("cast_range")
end


function modifier_life_stealer_dragon_arcane_power_aura:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
  MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
}
end

function modifier_life_stealer_dragon_arcane_power_aura:GetModifierCastRangeBonusStacking()
return self.cast_range
end

function modifier_life_stealer_dragon_arcane_power_aura:GetModifierPercentageCooldown() 
return self.cdr
end


