

modifier_nevermore_darklord_self = class({})


function modifier_nevermore_darklord_self:IsHidden() return true end
function modifier_nevermore_darklord_self:IsPurgable() return false end



function modifier_nevermore_darklord_self:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

end


function modifier_nevermore_darklord_self:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_nevermore_darklord_self:RemoveOnDeath() return false end