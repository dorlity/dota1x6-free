
modifier_juggernaut_bladefury_legendary = class({})


function modifier_juggernaut_bladefury_legendary:IsHidden() return true end
function modifier_juggernaut_bladefury_legendary:IsPurgable() return false end



function modifier_juggernaut_bladefury_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():FindAbilityByName("custom_juggernaut_whirling_blade_custom"):SetHidden(false)
end


function modifier_juggernaut_bladefury_legendary:RemoveOnDeath() return false end