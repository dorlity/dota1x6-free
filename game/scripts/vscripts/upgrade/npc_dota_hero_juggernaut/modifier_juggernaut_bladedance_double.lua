

modifier_juggernaut_bladedance_double = class({})


function modifier_juggernaut_bladedance_double:IsHidden() return true end
function modifier_juggernaut_bladedance_double:IsPurgable() return false end



function modifier_juggernaut_bladedance_double:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

if not self:GetParent():HasAbility("custom_juggernaut_blade_dance") then return end 

self:GetParent():FindAbilityByName("custom_juggernaut_blade_dance"):ToggleAutoCast()
self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("custom_juggernaut_blade_dance"), "modifier_custom_juggernaut_blade_dance_blink_cd", {})
end

function modifier_juggernaut_bladedance_double:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end





function modifier_juggernaut_bladedance_double:RemoveOnDeath() return false end