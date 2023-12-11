

modifier_bristle_goo_stack = class({})


function modifier_bristle_goo_stack:IsHidden() return true end
function modifier_bristle_goo_stack:IsPurgable() return false end



function modifier_bristle_goo_stack:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)  
end


function modifier_bristle_goo_stack:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_goo_stack:RemoveOnDeath() return false end