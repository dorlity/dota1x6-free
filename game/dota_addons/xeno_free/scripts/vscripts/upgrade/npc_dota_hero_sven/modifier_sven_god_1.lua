

modifier_sven_god_1 = class({})


function modifier_sven_god_1:IsHidden() return true end
function modifier_sven_god_1:IsPurgable() return false end



function modifier_sven_god_1:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_sven_god_1:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_sven_god_1:RemoveOnDeath() return false end