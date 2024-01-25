

modifier_monkey_king_boundless_4 = class({})


function modifier_monkey_king_boundless_4:IsHidden() return true end
function modifier_monkey_king_boundless_4:IsPurgable() return false end



function modifier_monkey_king_boundless_4:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("monkey_king_boundless_strike_custom"), "modifier_monkey_king_boundless_strike_custom_attack", {})
end


function modifier_monkey_king_boundless_4:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_monkey_king_boundless_4:RemoveOnDeath() return false end