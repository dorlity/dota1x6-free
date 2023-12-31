

modifier_alchemist_unstable_5 = class({})


function modifier_alchemist_unstable_5:IsHidden() return true end
function modifier_alchemist_unstable_5:IsPurgable() return false end



function modifier_alchemist_unstable_5:OnCreated(table)
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("alchemist_unstable_concoction_custom")
if ability then 
  ability:ToggleAutoCast()
end 

  self:SetStackCount(1)
end


function modifier_alchemist_unstable_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_alchemist_unstable_5:RemoveOnDeath() return false end