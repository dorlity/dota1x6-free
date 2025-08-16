LinkLuaModifier("modifier_item_phylactery_custom", "abilities/items/item_phylactery_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_phylactery_custom_debuff", "abilities/items/item_phylactery_custom", LUA_MODIFIER_MOTION_NONE)

item_phylactery_custom = class({})

function item_phylactery_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items_fx/phylactery_target.vpcf", context )
PrecacheResource( "particle","particles/items_fx/phylactery.vpcf", context )
PrecacheResource( "particle","particles/econ/items/skywrath_mage/skywrath_arcana/skywrath_arcana_phylactery.vpcf", context )
PrecacheResource( "particle","particles/econ/items/skywrath_mage/skywrath_arcana/skywrath_arcana_phylactery_v2.vpcf", context )
end

function item_phylactery_custom:GetIntrinsicModifierName()
	return "modifier_item_phylactery_custom"
end

function item_phylactery_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_skywrath_mage_arcana_style_1_custom") then
    return "phylactery_skywrath_mage_arcana_alt1"
end
if self:GetCaster():HasModifier("modifier_skywrath_mage_arcana_style_2_custom") then
    return "phylactery_skywrath_mage_arcana_alt2"
end
return "item_phylactery"
end

modifier_item_phylactery_custom = class({})
function modifier_item_phylactery_custom:IsPurgable() return false end
function modifier_item_phylactery_custom:IsHidden() return true end
function modifier_item_phylactery_custom:IsPurgeException() return false end
function modifier_item_phylactery_custom:IsPurgable() return false end
function modifier_item_phylactery_custom:RemoveOnDeath() return false end
function modifier_item_phylactery_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
}
end

function modifier_item_phylactery_custom:GetModifierManaBonus()
return self.bonus_mana
end

function modifier_item_phylactery_custom:GetModifierHealthBonus()
return self.bonus_health
end

function modifier_item_phylactery_custom:GetModifierBonusStats_Strength()
return self.bonus_all_stats
end

function modifier_item_phylactery_custom:GetModifierBonusStats_Agility()
return self.bonus_all_stats
end

function modifier_item_phylactery_custom:GetModifierBonusStats_Intellect()
return self.bonus_all_stats
end

function modifier_item_phylactery_custom:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.bonus_all_stats = self.ability:GetSpecialValueFor("bonus_all_stats")
self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
self.min_damage_to_activate = self.ability:GetSpecialValueFor("min_damage_to_activate")
self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
self.bonus_spell_damage = self.ability:GetSpecialValueFor("bonus_spell_damage")

if not IsServer() then return end

self.phyl_particle = "particles/items_fx/phylactery.vpcf"
if self.parent:HasModifier("modifier_skywrath_mage_arcana_style_1_custom") then
    self.phyl_particle = "particles/econ/items/skywrath_mage/skywrath_arcana/skywrath_arcana_phylactery.vpcf"
elseif self.parent:HasModifier("modifier_skywrath_mage_arcana_style_2_custom") then
    self.phyl_particle = "particles/econ/items/skywrath_mage/skywrath_arcana/skywrath_arcana_phylactery_v2.vpcf"
end

if self.parent:IsRealHero() then 
    self.parent:AddDamageEvent_out(self, true)
end 

end

function modifier_item_phylactery_custom:DamageEvent_out(params)
if not IsServer() then return end
local unit = params.unit

if not IsValid(self.ability) or not IsValid(unit) then return end
if not self.ability:IsFullyCastable() then return end

if params.attacker ~= self.parent then return end
if not self.parent:IsRealHero() then return end
if self.parent:IsTempestDouble() then return end
if params.unit == self.parent then return end
if params.inflictor == nil then return end
if params.inflictor == self.ability then return end
if params.inflictor:IsItem() then return end
if params.damage < self.min_damage_to_activate then return end
if self.parent:FindAllModifiersByName("modifier_item_phylactery_custom")[1] ~= self then return end
if self.parent:HasModifier("modifier_item_manaflare_lens_custom") then return end
if (self.parent:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() > 1200 then return end

self.ability:UseResources(false, false, false, true)
unit:SendNumber(4, self.bonus_spell_damage)
DoDamage({attacker = self.parent, victim = unit, ability = self.ability, damage = self.bonus_spell_damage, damage_type = DAMAGE_TYPE_MAGICAL})

unit:AddNewModifier(self.parent, self.ability, "modifier_item_phylactery_custom_debuff", {duration = self.slow_duration})

local particle = ParticleManager:CreateParticle("particles/items_fx/phylactery_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

local particle_2 = ParticleManager:CreateParticle(self.phyl_particle, PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle_2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle_2, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle_2)

unit:EmitSound("Item.Phylactery.Target")
end


modifier_item_phylactery_custom_debuff = class({})
function modifier_item_phylactery_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_item_phylactery_custom_debuff:OnCreated()
self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_item_phylactery_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.slow 
end