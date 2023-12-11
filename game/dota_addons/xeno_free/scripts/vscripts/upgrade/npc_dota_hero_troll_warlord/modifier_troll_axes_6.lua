

modifier_troll_axes_6 = class({})


function modifier_troll_axes_6:IsHidden() return true end
function modifier_troll_axes_6:IsPurgable() return false end



function modifier_troll_axes_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetParent():FindAbilityByName("troll_warlord_whirling_axes_melee_custom")

if ability then 
  ability:ToggleAutoCast()
end 

end


function modifier_troll_axes_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_troll_axes_6:RemoveOnDeath() return false end