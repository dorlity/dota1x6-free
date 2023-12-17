item_guardian_greaves_custom = class({})

LinkLuaModifier( "modifier_item_guardian_greaves_custom", "abilities/items/item_guardian_greaves_custom", LUA_MODIFIER_MOTION_NONE )

function item_guardian_greaves_custom:GetIntrinsicModifierName()
	return "modifier_item_guardian_greaves_custom"
end

function item_guardian_greaves_custom:OnSpellStart()
	if not IsServer() then return end
	local heal_amount = self:GetSpecialValueFor("replenish_health")*self:GetCaster():GetMaxHealth()/100
	local mana_amount = self:GetSpecialValueFor("replenish_mana")*self:GetCaster():GetMaxMana()/100
	self:GetCaster():EmitSound("Item.GuardianGreaves.Activate")

	local particle_1 = ParticleManager:CreateParticle("particles/items3_fx/warmage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(particle_1)

	self:GetCaster():GiveMana(mana_amount)
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self:GetCaster(), mana_amount, nil)
	self:GetCaster():Purge(false, true, false, false, false)
	self:GetCaster():Heal(heal_amount, self:GetCaster())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetCaster(), heal_amount, nil)
	self:GetCaster():EmitSound("Item.GuardianGreaves.Target")

	local particle_2 = ParticleManager:CreateParticle("particles/items3_fx/warmage_recipient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_2, 0, self:GetCaster():GetAbsOrigin())
end


modifier_item_guardian_greaves_custom = class({})

function modifier_item_guardian_greaves_custom:IsHidden()	


if self:GetParent():GetHealthPercent() < self:GetAbility():GetSpecialValueFor("aura_bonus_threshold") then 
	return false
end

return true
end
function modifier_item_guardian_greaves_custom:IsPurgable()		return false end
function modifier_item_guardian_greaves_custom:RemoveOnDeath()	return false end
function modifier_item_guardian_greaves_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_guardian_greaves_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_item_guardian_greaves_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if not self:GetParent():IsRealHero() then return end
if self:GetParent():GetHealthPercent() > self:GetAbility():GetSpecialValueFor("aura_bonus_threshold") then return end
if self:GetAbility():GetCooldownTimeRemaining() > 0 then return end
if self:GetParent():HasModifier("modifier_death") then return end

self:GetAbility():UseResources(false, false, false, true)
self:GetAbility():OnSpellStart()

end

function modifier_item_guardian_greaves_custom:GetModifierMoveSpeedBonus_Special_Boots()
	return self:GetAbility():GetSpecialValueFor("bonus_movement")
end

function modifier_item_guardian_greaves_custom:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
end

function modifier_item_guardian_greaves_custom:GetModifierPhysicalArmorBonus()

	return self:GetAbility():GetSpecialValueFor("bonus_armor") 
end

function modifier_item_guardian_greaves_custom:GetModifierConstantHealthRegen()

	return self:GetAbility():GetSpecialValueFor("aura_health_regen")
end

function modifier_item_guardian_greaves_custom:GetModifierIncomingDamage_Percentage()
if IsClient() then
	if self:GetParent():GetHealthPercent() < self:GetAbility():GetSpecialValueFor("aura_bonus_threshold") then
		return self:GetAbility():GetSpecialValueFor("aura_reduction")
	end
else 

	if self:GetParent():FindAllModifiersByName(self:GetName())[1] ~= self then return end 

	if self:GetParent():GetHealthPercent() < self:GetAbility():GetSpecialValueFor("aura_bonus_threshold") then
		return self:GetAbility():GetSpecialValueFor("aura_reduction")
	end
	
end

end






