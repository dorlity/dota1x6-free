

modifier_leshrac_nova_7 = class({})


function modifier_leshrac_nova_7:IsHidden() return true end
function modifier_leshrac_nova_7:IsPurgable() return false end



function modifier_leshrac_nova_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  
 local ability = self:GetParent():FindAbilityByName("leshrac_pulse_nova_custom_legendary")
 ability:SetHidden(false)
end


function modifier_leshrac_nova_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_leshrac_nova_7:RemoveOnDeath() return false end