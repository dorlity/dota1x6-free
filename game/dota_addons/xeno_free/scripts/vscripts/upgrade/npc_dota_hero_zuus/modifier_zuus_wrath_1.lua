

modifier_zuus_wrath_1 = class({})


function modifier_zuus_wrath_1:IsHidden() return true end
function modifier_zuus_wrath_1:IsPurgable() return false end



function modifier_zuus_wrath_1:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_zuus_wrath_1:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_zuus_wrath_1:RemoveOnDeath() return false end