

modifier_mars_bulwark_6 = class({})


function modifier_mars_bulwark_6:IsHidden() return true end
function modifier_mars_bulwark_6:IsPurgable() return false end



function modifier_mars_bulwark_6:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
 -- self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("mars_bulwark_custom"), "modifier_mars_bulwark_custom_taunt_aura", {})
end


function modifier_mars_bulwark_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_mars_bulwark_6:RemoveOnDeath() return false end