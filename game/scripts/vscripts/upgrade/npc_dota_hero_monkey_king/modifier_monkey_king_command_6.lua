

modifier_monkey_king_command_6 = class({})


function modifier_monkey_king_command_6:IsHidden() return true end
function modifier_monkey_king_command_6:IsPurgable() return false end



function modifier_monkey_king_command_6:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_monkey_king_command_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_monkey_king_command_6:RemoveOnDeath() return false end