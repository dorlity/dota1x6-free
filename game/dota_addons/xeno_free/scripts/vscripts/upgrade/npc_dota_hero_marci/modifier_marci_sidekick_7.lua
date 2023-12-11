

modifier_marci_sidekick_7 = class({})


function modifier_marci_sidekick_7:IsHidden() return true end
function modifier_marci_sidekick_7:IsPurgable() return false end



function modifier_marci_sidekick_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetParent():FindAbilityByName("marci_summon_mirana")

  if ability then 
  	ability:SetHidden(false)
  end

end


function modifier_marci_sidekick_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_marci_sidekick_7:RemoveOnDeath() return false end