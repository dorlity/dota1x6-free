

modifier_primal_beast_pulverize_7 = class({})


function modifier_primal_beast_pulverize_7:IsHidden() return true end
function modifier_primal_beast_pulverize_7:IsPurgable() return false end



function modifier_primal_beast_pulverize_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  local ability = self:GetParent():FindAbilityByName("primal_beast_pulverize_custom")
  self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_primal_beast_pulverize_custom_legendary_tracker", {})
end


function modifier_primal_beast_pulverize_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_primal_beast_pulverize_7:RemoveOnDeath() return false end