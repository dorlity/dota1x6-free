

modifier_sven_god_7 = class({})


function modifier_sven_god_7:IsHidden() return true end
function modifier_sven_god_7:IsPurgable() return false end



function modifier_sven_god_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():FindAbilityByName("sven_gods_strength_custom_legendary"):SetHidden(false)
  self:GetParent():FindAbilityByName("sven_gods_strength_custom_legendary"):SetActivated(false)
end


function modifier_sven_god_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_sven_god_7:RemoveOnDeath() return false end