

modifier_maiden_freezing_2 = class({})


function modifier_maiden_freezing_2:IsHidden() return true end
function modifier_maiden_freezing_2:IsPurgable() return false end



function modifier_maiden_freezing_2:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_maiden_freezing_2:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_maiden_freezing_2:RemoveOnDeath() return false end