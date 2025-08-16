LinkLuaModifier( "modifier_ogre_magi_smash_custom_buff", "abilities/ogre_magi/ogre_magi_smash", LUA_MODIFIER_MOTION_NONE )

ogre_magi_smash_custom = class({})

function ogre_magi_smash_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile.vpcf", context )
end


function ogre_magi_smash_custom:GetBehavior()
local base = DOTA_ABILITY_BEHAVIOR_NO_TARGET
if not IsSoloMode() then 
  base = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end
return base
end


function ogre_magi_smash_custom:OnSpellStart(new_target)
local caster = self:GetCaster()
local target = caster

if self:GetCursorTarget() then
	target = self:GetCursorTarget()
end
if new_target then
	target = new_target
end

target:EmitSound("Hero_OgreMagi.FireShield.Target")

local duration = self:GetSpecialValueFor("duration")
target:AddNewModifier(caster, self, "modifier_ogre_magi_smash_custom_buff", {duration = duration})
end

function ogre_magi_smash_custom:OnProjectileHit(target, vLocation)
if not target then return end

local damage = self:GetSpecialValueFor("damage")
target:EmitSound("Hero_OgreMagi.FireShield.Damage")
DoDamage( { victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self } )
end



modifier_ogre_magi_smash_custom_buff = class({})

function modifier_ogre_magi_smash_custom_buff:IsPurgable() return false end
function modifier_ogre_magi_smash_custom_buff:IsHidden() return false end

function modifier_ogre_magi_smash_custom_buff:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.speed = self.ability:GetSpecialValueFor("projectile_speed")
self.damage_reduce = self.ability:GetSpecialValueFor("damage_reduce")
self.max_stacks = self.ability:GetSpecialValueFor("attacks")
self.add_stacks = self.ability:GetSpecialValueFor("attacks_multi")
self.max = self.ability:GetSpecialValueFor("max")

if not IsServer() then return end

self.RemoveForDuel = true

self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield.vpcf", PATTACH_CENTER_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt(  self.particle, 0, self.parent, PATTACH_CENTER_FOLLOW , nil, self.parent:GetOrigin(), true )
ParticleManager:SetParticleControl( self.particle, 1, Vector( 3, 0, 0 ) )
ParticleManager:SetParticleControl( self.particle, 9, Vector( 1, 0, 0 ) )
ParticleManager:SetParticleControl( self.particle, 10, Vector( 1, 0, 0 ) )
ParticleManager:SetParticleControl( self.particle, 11, Vector( 1, 0, 0 ) )
self:AddParticle(self.particle,false, false, -1, false, false)

self:SetStackCount(self.max_stacks)
end



function modifier_ogre_magi_smash_custom_buff:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:SetStackCount(self:GetStackCount() + self.add_stacks)
end


function modifier_ogre_magi_smash_custom_buff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function modifier_ogre_magi_smash_custom_buff:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end
if not params.attacker then return end
if params.inflictor then return end 
if not params.attacker:IsHero() then return end

self:RemoveStack(params.attacker)
return self.damage_reduce
end



function modifier_ogre_magi_smash_custom_buff:RemoveStack(target)
if not IsServer() then return end


local info = {
	Target = target,
	Source = self.parent,
	Ability = self.ability,	
	EffectName = "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile.vpcf",
	iMoveSpeed = self.speed,
	bReplaceExisting = false,
	bProvidesVision = true,
	iVisionRadius = 50,
	iVisionTeamNumber = self.parent:GetTeamNumber(),			
}
ProjectileManager:CreateTrackingProjectile(info)
self:DecrementStackCount()

if self:GetStackCount() <= 0 then 
	self:Destroy()
end

end


