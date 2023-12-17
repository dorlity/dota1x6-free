LinkLuaModifier("modifier_item_heart_custom", "abilities/items/item_heart_custom", LUA_MODIFIER_MOTION_NONE)

item_heart_custom = class({})

function item_heart_custom:GetIntrinsicModifierName()
return "modifier_item_heart_custom"
end


modifier_item_heart_custom = class({})

function modifier_item_heart_custom:IsHidden() return true end
function modifier_item_heart_custom:IsPurgable() return false end
function modifier_item_heart_custom:RemoveOnDeath() return false end
function modifier_item_heart_custom:GetAttributes()
if test then 
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

end



function modifier_item_heart_custom:OnCreated(table)
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.health_regen_pct = self:GetAbility():GetSpecialValueFor("health_regen_pct")

end


function modifier_item_heart_custom:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end


function modifier_item_heart_custom:GetModifierBonusStats_Strength()
	return self.bonus_strength
end



function modifier_item_heart_custom:GetModifierHealthRegenPercentage()
	return self.health_regen_pct
end


