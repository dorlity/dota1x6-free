

modifier_snapfire_cookie_7 = class({})


function modifier_snapfire_cookie_7:IsHidden() return true end
function modifier_snapfire_cookie_7:IsPurgable() return false end



function modifier_snapfire_cookie_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("snapfire_firesnap_cookie_custom"), "modifier_snapfire_firesnap_cookie_custom_legendary_tracker", {})
end


function modifier_snapfire_cookie_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_snapfire_cookie_7:RemoveOnDeath() return false end