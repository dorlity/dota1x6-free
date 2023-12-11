

modifier_huskar_disarm_str = class({})


function modifier_huskar_disarm_str:IsHidden() return true end
function modifier_huskar_disarm_str:IsPurgable() return false end



function modifier_huskar_disarm_str:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("custom_huskar_inner_fire"), "modifier_custom_huskar_inner_fire_aura", {})
end


function modifier_huskar_disarm_str:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_huskar_disarm_str:RemoveOnDeath() return false end