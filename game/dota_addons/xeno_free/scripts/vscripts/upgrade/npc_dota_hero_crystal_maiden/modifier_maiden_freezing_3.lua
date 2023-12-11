

modifier_maiden_freezing_3 = class({})


function modifier_maiden_freezing_3:IsHidden() return true end
function modifier_maiden_freezing_3:IsPurgable() return false end



function modifier_maiden_freezing_3:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_maiden_freezing_3:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_maiden_freezing_3:RemoveOnDeath() return false end