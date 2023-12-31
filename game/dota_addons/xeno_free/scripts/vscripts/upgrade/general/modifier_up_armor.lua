

modifier_up_armor = class({})


function modifier_up_armor:IsHidden() return true end
function modifier_up_armor:IsPurgable() return false end

function modifier_up_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
  
    }

 end

function modifier_up_armor:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_armor:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_armor:GetModifierPhysicalArmorBonus() 

local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	k = 1.4
end

	return 3*self:GetStackCount()*(1+0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints") + k) 
end



function modifier_up_armor:RemoveOnDeath() return false end