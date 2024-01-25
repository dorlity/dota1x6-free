

modifier_sniper_shrapnel_2 = class({})


function modifier_sniper_shrapnel_2:IsHidden() return true end
function modifier_sniper_shrapnel_2:IsPurgable() return false end



function modifier_sniper_shrapnel_2:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_sniper_shrapnel_2:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_sniper_shrapnel_2:RemoveOnDeath() return false end