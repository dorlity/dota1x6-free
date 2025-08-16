LinkLuaModifier( "modifier_tinker_warp_grenade_custom_leash", "abilities/tinker/tinker_warp_grenade_custom", LUA_MODIFIER_MOTION_NONE )

tinker_warp_grenade_custom = class({})

function tinker_warp_grenade_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_shard_warp_flare.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_shard_warp_start_b.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_shard_warp_debuff.vpcf", context )
end


function tinker_warp_grenade_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
local speed = self:GetSpecialValueFor("speed")

local info = 
{
  EffectName = "particles/units/heroes/hero_tinker/tinker_shard_warp_flare.vpcf",
  Ability = self,
  iMoveSpeed = speed,
  Source = caster,
  bDodgeable = true,
  Target = target,
  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1, 
}
caster:EmitSound("Hero_Tinker.Warp.Cast")
ProjectileManager:CreateTrackingProjectile(info)
end


function tinker_warp_grenade_custom:OnProjectileHit(target, vLocation)
if not target then return end
if target:TriggerSpellAbsorb(self) then return end

local caster = self:GetCaster()
local damage = self:GetSpecialValueFor("damage")
local leash = self:GetSpecialValueFor("leash")
local cast_range = self:GetSpecialValueFor("AbilityCastRange")
local max_range = self:GetSpecialValueFor("max_range")
local min_range = self:GetSpecialValueFor("min_range")

target:EmitSound("Hero_Tinker.Warp.Target")

local dir = target:GetAbsOrigin() - caster:GetAbsOrigin()
dir.z = 0

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_shard_warp_start_b.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
ParticleManager:SetParticleControlForward(particle, 0, dir:Normalized())
ParticleManager:ReleaseParticleIndex(particle)

DoDamage({victim = target, attacker = caster, damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL})

local dist_k = math.max(0, math.min(1, (1 - dir:Length2D()/cast_range)))
local knock_range = min_range + (max_range - min_range)*dist_k

local point = target:GetAbsOrigin() + dir:Normalized()*knock_range
FindClearSpaceForUnit(target, point, true)

target:AddNewModifier(caster, self, "modifier_tinker_warp_grenade_custom_leash", {duration = (1 - target:GetStatusResistance())*leash})
end


modifier_tinker_warp_grenade_custom_leash = class(mod_hidden)
function modifier_tinker_warp_grenade_custom_leash:IsPurgable() return true end
function modifier_tinker_warp_grenade_custom_leash:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:GenericParticle("particles/units/heroes/hero_tinker/tinker_shard_warp_debuff.vpcf", self)
self.slow = self.ability:GetSpecialValueFor("slow")
end

function modifier_tinker_warp_grenade_custom_leash:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_tinker_warp_grenade_custom_leash:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_tinker_warp_grenade_custom_leash:CheckState()
return
{
    [MODIFIER_STATE_TETHERED] = true
}
end