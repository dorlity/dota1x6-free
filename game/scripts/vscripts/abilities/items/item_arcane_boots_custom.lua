item_arcane_boots_custom = class({})

LinkLuaModifier( "modifier_item_arcane_boots_custom", "abilities/items/item_arcane_boots_custom", LUA_MODIFIER_MOTION_NONE )

function item_arcane_boots_custom:GetIntrinsicModifierName()
	return "modifier_item_arcane_boots_custom"
end

function item_arcane_boots_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items_fx/arcane_boots.vpcf", context )
PrecacheResource( "particle","particles/items_fx/arcane_boots_recipient.vpcf", context )
end

function item_arcane_boots_custom:OnSpellStart()

local caster = self:GetCaster()
local replenish_amount = self:GetSpecialValueFor("replenish_amount")
local radius = self:GetSpecialValueFor("radius")

caster:EmitSound("DOTA_Item.ArcaneBoots.Activate")

local particle_1 = ParticleManager:CreateParticle("particles/items_fx/arcane_boots.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:ReleaseParticleIndex(particle_1)

local friends = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

for _,friend in pairs(friends) do

	local particle_2 = ParticleManager:CreateParticle("particles/items_fx/arcane_boots_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, friend)
	ParticleManager:ReleaseParticleIndex(particle_2)
	friend:GiveMana(replenish_amount)

	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD , friend, replenish_amount, nil)
end



end

modifier_item_arcane_boots_custom = class({})

function modifier_item_arcane_boots_custom:IsHidden()		return true end
function modifier_item_arcane_boots_custom:IsPurgable()		return false end
function modifier_item_arcane_boots_custom:RemoveOnDeath()	return false end
function modifier_item_arcane_boots_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_arcane_boots_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}
end

function modifier_item_arcane_boots_custom:GetModifierMoveSpeedBonus_Special_Boots()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_movement")
	end
end

function modifier_item_arcane_boots_custom:GetModifierConstantManaRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("mana_regen")
	end
end