LinkLuaModifier("modifier_item_desolator_custom", "abilities/items/item_desolator_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_desolator_custom_debuff", "abilities/items/item_desolator_custom", LUA_MODIFIER_MOTION_NONE)

item_desolator_custom = class({})

function item_desolator_custom:GetIntrinsicModifierName()
	return "modifier_item_desolator_custom"
end

modifier_item_desolator_custom	= class({})

function modifier_item_desolator_custom:IsPurgable()		return false end
function modifier_item_desolator_custom:RemoveOnDeath()	return false end
function modifier_item_desolator_custom:IsHidden()	return true end

function modifier_item_desolator_custom:OnCreated()

self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
self.corruption_duration = self:GetAbility():GetSpecialValueFor("corruption_duration")
end

function modifier_item_desolator_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE

	}

	return funcs
end

function modifier_item_desolator_custom:GetModifierPreAttack_BonusDamage(keys)
	return self.bonus_damage
end

function modifier_item_desolator_custom:GetModifierProjectileName()
    return "particles/items_fx/desolator_projectile.vpcf"
end

function modifier_item_desolator_custom:GetModifierProcAttack_Feedback(params)
if params.attacker ~= self:GetParent() then return end
local target = params.target

target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_desolator_custom_debuff", {duration = self.corruption_duration})
target:EmitSound("Item_Desolator.Target")

end




modifier_item_desolator_custom_debuff	= class({})

function modifier_item_desolator_custom_debuff:IsPurgable()		return true end


function modifier_item_desolator_custom_debuff:OnCreated()
	self.corruption_armor = self:GetAbility():GetSpecialValueFor("corruption_armor")

end

function modifier_item_desolator_custom_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_desolator_custom_debuff:GetModifierPhysicalArmorBonus()
    return self.corruption_armor
end