

modifier_marci_unleash_7 = class({})


function modifier_marci_unleash_7:IsHidden() return true end
function modifier_marci_unleash_7:IsPurgable() return false end



function modifier_marci_unleash_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetParent():FindAbilityByName("marci_unleash_custom")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_marci_unleash_custom_rage", {})
  end

end


function modifier_marci_unleash_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_marci_unleash_7:RemoveOnDeath() return false end