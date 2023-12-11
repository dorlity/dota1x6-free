

modifier_bristle_back_ground = class({})


function modifier_bristle_back_ground:IsHidden() return true end
function modifier_bristle_back_ground:IsPurgable() return false end



function modifier_bristle_back_ground:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

end


function modifier_bristle_back_ground:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_back_ground:RemoveOnDeath() return false end