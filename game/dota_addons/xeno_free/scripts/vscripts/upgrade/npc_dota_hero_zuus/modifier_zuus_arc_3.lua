

modifier_zuus_arc_3 = class({})


function modifier_zuus_arc_3:IsHidden() return true end
function modifier_zuus_arc_3:IsPurgable() return false end



function modifier_zuus_arc_3:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_zuus_arc_3:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_zuus_arc_3:RemoveOnDeath() return false end