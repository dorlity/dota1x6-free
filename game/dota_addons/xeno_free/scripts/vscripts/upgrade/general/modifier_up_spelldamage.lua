

modifier_up_spelldamage = class({})


function modifier_up_spelldamage:IsHidden() return true end
function modifier_up_spelldamage:IsPurgable() return false end


function modifier_up_spelldamage:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
} 
end

function modifier_up_spelldamage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_spelldamage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_spelldamage:GetModifierSpellAmplify_Percentage() 

local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	k = 1.4
end

	return 2*self:GetStackCount()*(1 + k +0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) 
end


function modifier_up_spelldamage:RemoveOnDeath() return false end