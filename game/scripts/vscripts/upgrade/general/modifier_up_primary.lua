

modifier_up_primary = class({})



function modifier_up_primary:IsHidden() return true end
function modifier_up_primary:IsPurgable() return false end

function modifier_up_primary:DeclareFunctions()
if not IsServer() then return end
  if self:GetParent():GetPrimaryAttribute() == 1 then  return {MODIFIER_PROPERTY_STATS_AGILITY_BONUS  } end
  if self:GetParent():GetPrimaryAttribute() == 0 then return { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS } end
  if self:GetParent():GetPrimaryAttribute() == 2 then return { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS } end

 end

function modifier_up_primary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_primary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end

function modifier_up_primary:GetModifierBonusStats_Agility() 

	local k = 0
	if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
		k = 1.4
	end


	return 4*self:GetStackCount()*(1 + k +0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints"))
end

function modifier_up_primary:GetModifierBonusStats_Strength() 

	local k = 0
	if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
		k = 1.4
	end


	return 4*self:GetStackCount()*(1 + k +0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) 
end



function modifier_up_primary:GetModifierBonusStats_Intellect() 
local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	k = 1.4
end


 return 4*self:GetStackCount()*(1 + k +0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) 
end




function modifier_up_primary:StackOnIllusion() return true end
function modifier_up_primary:RemoveOnDeath() return false end