

modifier_sven_cry_7 = class({})


function modifier_sven_cry_7:IsHidden() return true end
function modifier_sven_cry_7:IsPurgable() return false end



function modifier_sven_cry_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_sven_cry_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_sven_cry_7:RemoveOnDeath() return false end