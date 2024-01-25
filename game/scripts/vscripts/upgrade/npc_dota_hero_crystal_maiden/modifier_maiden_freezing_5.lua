

modifier_maiden_freezing_5 = class({})


function modifier_maiden_freezing_5:IsHidden() return true end
function modifier_maiden_freezing_5:IsPurgable() return false end



function modifier_maiden_freezing_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetParent():FindAbilityByName("crystal_maiden_freezing_field_custom")
if ability then 
  ability:ToggleAutoCast()
end 


end


function modifier_maiden_freezing_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_maiden_freezing_5:RemoveOnDeath() return false end