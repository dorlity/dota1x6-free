
modifier_up_statusresist = class({})


function modifier_up_statusresist:IsHidden() return true end
function modifier_up_statusresist:IsPurgable() return false end


function modifier_up_statusresist:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_statusresist:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_statusresist:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
} 
end


function modifier_up_statusresist:GetModifierStatusResistanceStacking() 
local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
  k = 1.4
end

  return 4*(1 + k +0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints"))*self:GetStackCount()
end



function modifier_up_statusresist:RemoveOnDeath() return false end




