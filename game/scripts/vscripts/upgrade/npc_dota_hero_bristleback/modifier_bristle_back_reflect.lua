

modifier_bristle_back_reflect = class({})


function modifier_bristle_back_reflect:IsHidden() return true end
function modifier_bristle_back_reflect:IsPurgable() return false end



function modifier_bristle_back_reflect:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)


end


function modifier_bristle_back_reflect:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_back_reflect:RemoveOnDeath() return false end