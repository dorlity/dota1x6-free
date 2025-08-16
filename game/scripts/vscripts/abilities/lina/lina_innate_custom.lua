LinkLuaModifier( "modifier_lina_innate_custom", "abilities/lina/lina_innate_custom", LUA_MODIFIER_MOTION_NONE )


lina_innate_custom = class({})

function lina_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_overheat_explosion.vpcf", context )
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_lina.vsndevts", context )
end

function lina_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_lina_innate_custom"
end



modifier_lina_innate_custom = class({})
function modifier_lina_innate_custom:IsHidden() return true end
function modifier_lina_innate_custom:IsPurgable() return false end
function modifier_lina_innate_custom:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.thresh = self.ability:GetSpecialValueFor("thresh")
self.radius = self.ability:GetSpecialValueFor("radius")
self.creeps = self.ability:GetSpecialValueFor("creeps")

self.damage = self.ability:GetSpecialValueFor("damage")
self.heal = self.ability:GetSpecialValueFor("heal")

self.parent:AddDamageEvent_out(self)
self.damage_count = 0
end


function modifier_lina_innate_custom:OnRefresh(table)
self.damage = self.ability:GetSpecialValueFor("damage")
self.heal = self.ability:GetSpecialValueFor("heal")
end



function modifier_lina_innate_custom:DamageEvent_out(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end

local attacker = params.attacker
local unit = params.unit

if not attacker then return end
if not unit:IsUnit() then return end
if unit:IsIllusion() then return end 
if self.parent ~= attacker then return end
if params.inflictor and params.inflictor == self.ability then return end

local damage = params.damage

if params.unit:IsCreep() then 
	damage = damage/self.creeps
end

local final = damage + self.damage_count


if final >= self.thresh then 

	local delta = math.floor(final/self.thresh)

	self.parent:GenericHeal(delta*self.heal, self.ability, true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
	unit:EmitSound("Hero_Lina.Overheat.Explosion")

	for _,target in pairs(self.parent:FindTargets(self.radius, unit:GetAbsOrigin())) do
		DoDamage({victim = target, attacker = self.parent, ability = self.ability, damage = self.damage*delta, damage_type = DAMAGE_TYPE_MAGICAL})

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_overheat_explosion.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, unit )
		ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true )
		ParticleManager:ReleaseParticleIndex( particle )
	end

	self.damage_count = final - delta*self.thresh
else 
	self.damage_count = final
end 

end

