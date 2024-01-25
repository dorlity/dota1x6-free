

modifier_up_magicresist = class({})


function modifier_up_magicresist:IsHidden() return true end
function modifier_up_magicresist:IsPurgable() return false end


function modifier_up_magicresist:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
} 
end

function modifier_up_magicresist:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true 
end


function modifier_up_magicresist:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_up_magicresist:GetModifierMagicalResistanceBonus() 

	local k = 0
	if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
		k = 1.4
	end


	return 3*self:GetStackCount()*(1 + k+0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) 
end


function modifier_up_magicresist:RemoveOnDeath() return false end