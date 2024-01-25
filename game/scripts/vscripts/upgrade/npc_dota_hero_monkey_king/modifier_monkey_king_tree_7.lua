

modifier_monkey_king_tree_7 = class({})


function modifier_monkey_king_tree_7:IsHidden() return true end
function modifier_monkey_king_tree_7:IsPurgable() return false end



function modifier_monkey_king_tree_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local max = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_7", "max")

if my_game.current_wave >= upgrade_orange then 

  local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("monkey_king_primal_spring_custom"), "modifier_monkey_king_primal_spring_custom_legendary", {})

  if mod then 
    mod:SetStackCount(max)
  end
end

end




function modifier_monkey_king_tree_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_monkey_king_tree_7:RemoveOnDeath() return false end