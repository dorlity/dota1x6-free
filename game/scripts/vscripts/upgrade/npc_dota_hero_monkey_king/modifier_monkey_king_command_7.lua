

modifier_monkey_king_command_7 = class({})


function modifier_monkey_king_command_7:IsHidden() return true end
function modifier_monkey_king_command_7:IsPurgable() return false end



function modifier_monkey_king_command_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

self:GetParent():RemoveModifierByName("modifier_monkey_king_transform")
self:GetParent():SwapAbilities("monkey_king_mischief", "monkey_king_mischief_custom", false, true)
end


function modifier_monkey_king_command_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_monkey_king_command_7:RemoveOnDeath() return false end