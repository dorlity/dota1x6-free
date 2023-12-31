

modifier_antimage_counter_6 = class({})


function modifier_antimage_counter_6:IsHidden() return true end
function modifier_antimage_counter_6:IsPurgable() return false end



function modifier_antimage_counter_6:OnCreated(table)
if not IsServer() then return end

local ability = self:GetParent():FindAbilityByName("antimage_counterspell_custom")

if ability then 
  ability:ToggleAutoCast()
end 

  self:SetStackCount(1)
end


function modifier_antimage_counter_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_antimage_counter_6:RemoveOnDeath() return false end