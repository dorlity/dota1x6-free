

modifier_mars_bulwark_4 = class({})


function modifier_mars_bulwark_4:IsHidden() return true end
function modifier_mars_bulwark_4:IsPurgable() return false end



function modifier_mars_bulwark_4:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("mars_bulwark_custom"), "modifier_mars_bulwark_custom_face_buff", {})
end


function modifier_mars_bulwark_4:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_mars_bulwark_4:RemoveOnDeath() return false end