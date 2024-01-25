LinkLuaModifier("modifier_item_manaflare_lens_custom", "abilities/items/item_manaflare_lens_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_manaflare_lens_custom_debuff", "abilities/items/item_manaflare_lens_custom", LUA_MODIFIER_MOTION_NONE)

item_manaflare_lens_custom = class({})

function item_manaflare_lens_custom:GetIntrinsicModifierName()
	return "modifier_item_manaflare_lens_custom"
end

modifier_item_manaflare_lens_custom = class({})
function modifier_item_manaflare_lens_custom:IsHidden() return true end
function modifier_item_manaflare_lens_custom:IsPurgable() return false end
function modifier_item_manaflare_lens_custom:IsPurgeException() return false end
function modifier_item_manaflare_lens_custom:IsPurgable() return false end
function modifier_item_manaflare_lens_custom:RemoveOnDeath() return false end

function modifier_item_manaflare_lens_custom:DeclareFunctions()
	return
	{
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
	}
end


function modifier_item_manaflare_lens_custom:GetModifierCastRangeBonusStacking()
if self:GetCaster():HasModifier("modifier_item_aether_lens") then return end

	return self:GetAbility():GetSpecialValueFor("cast_range_bonus")
end

function modifier_item_manaflare_lens_custom:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("mana_regen")
end




function modifier_item_manaflare_lens_custom:OnTakeDamage(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.unit == self:GetParent() then return end
	if not self:GetParent():IsRealHero() then return end
	if params.inflictor == nil then return end
	if params.inflictor == self:GetAbility() then return end
	if params.inflictor:IsItem() then return end
	if params.damage < self:GetAbility():GetSpecialValueFor("min_damage_to_activate") then return end
	if not self:GetAbility():IsFullyCastable() then return end
	if self:GetParent():HasModifier("modifier_item_phylactery_lens_custom") then return end
	if (self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() > 1200 then return end

	local damage = self:GetAbility():GetSpecialValueFor("bonus_spell_damage") + self:GetCaster():GetMaxMana()*self:GetAbility():GetSpecialValueFor("bonus_spell_damage_mana")/100

	SendOverheadEventMessage(params.unit, 4, params.unit, damage, nil)

	self:GetAbility():UseResources(false, false, false, true)
	ApplyDamage({attacker = self:GetCaster(), victim = params.unit, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	params.unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_manaflare_lens_custom_debuff", {duration = self:GetAbility():GetSpecialValueFor("slow_duration")})
	
	local particle = ParticleManager:CreateParticle("particles/empyreal_lens_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.unit)
	ParticleManager:SetParticleControlEnt(particle, 0, params.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", params.unit:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	local particle_2 = ParticleManager:CreateParticle("particles/empyreal_lens.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle_2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_2, 1, params.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", params.unit:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_2)

	params.unit:EmitSound("Item.Phylactery.Target")
end

function modifier_item_manaflare_lens_custom:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana")
	end
end

function modifier_item_manaflare_lens_custom:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end

function modifier_item_manaflare_lens_custom:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	end
end

function modifier_item_manaflare_lens_custom:GetModifierBonusStats_Agility()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	end
end

function modifier_item_manaflare_lens_custom:GetModifierBonusStats_Intellect()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	end
end




modifier_item_manaflare_lens_custom_debuff = class({})


function modifier_item_manaflare_lens_custom_debuff:GetTexture() return "buffs/manaflare" end


function modifier_item_manaflare_lens_custom_debuff:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_item_manaflare_lens_custom_debuff:DeclareFunctions()
	return
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_item_manaflare_lens_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end