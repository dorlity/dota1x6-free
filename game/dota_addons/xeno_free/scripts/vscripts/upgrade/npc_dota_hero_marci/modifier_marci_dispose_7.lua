

modifier_marci_dispose_7 = class({})


function modifier_marci_dispose_7:IsHidden() return true end
function modifier_marci_dispose_7:IsPurgable() return false end



function modifier_marci_dispose_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)


  local ability = self:GetParent():FindAbilityByName("marci_dispose_swap")

  if ability then 
  	ability:SetHidden(false)
  end
end


function modifier_marci_dispose_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_marci_dispose_7:RemoveOnDeath() return false end