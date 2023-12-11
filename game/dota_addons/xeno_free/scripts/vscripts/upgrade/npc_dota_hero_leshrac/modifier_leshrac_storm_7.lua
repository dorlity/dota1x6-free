

modifier_leshrac_storm_7 = class({})


function modifier_leshrac_storm_7:IsHidden() return true end
function modifier_leshrac_storm_7:IsPurgable() return false end



function modifier_leshrac_storm_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("leshrac_lightning_storm_custom"), "modifier_leshrac_lightning_storm_custom_tracker", {})
end


function modifier_leshrac_storm_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_leshrac_storm_7:RemoveOnDeath() return false end