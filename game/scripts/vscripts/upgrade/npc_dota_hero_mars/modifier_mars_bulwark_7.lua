

modifier_mars_bulwark_7 = class({})


function modifier_mars_bulwark_7:IsHidden() return true end
function modifier_mars_bulwark_7:IsPurgable() return false end



function modifier_mars_bulwark_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("mars_bulwark_custom"), "modifier_mars_bulwark_custom_legendary", {})
  self:GetParent():FindAbilityByName("mars_revenge_custom"):SetHidden(false)
end


function modifier_mars_bulwark_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_mars_bulwark_7:RemoveOnDeath() return false end