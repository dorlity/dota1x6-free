

modifier_marci_unleash_5 = class({})


function modifier_marci_unleash_5:IsHidden() return true end
function modifier_marci_unleash_5:IsPurgable() return false end



function modifier_marci_unleash_5:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_marci_unleash_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_marci_unleash_5:RemoveOnDeath() return false end