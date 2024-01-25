

modifier_legion_duel_passive = class({})


function modifier_legion_duel_passive:IsHidden() return true end
function modifier_legion_duel_passive:IsPurgable() return false end



function modifier_legion_duel_passive:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

end


function modifier_legion_duel_passive:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_duel_passive:RemoveOnDeath() return false end