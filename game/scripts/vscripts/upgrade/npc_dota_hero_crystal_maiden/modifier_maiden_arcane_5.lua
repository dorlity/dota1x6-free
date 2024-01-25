

modifier_maiden_arcane_5 = class({})


function modifier_maiden_arcane_5:IsHidden() return true end
function modifier_maiden_arcane_5:IsPurgable() return false end



function modifier_maiden_arcane_5:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("crystal_maiden_arcane_aura_custom"), "modifier_crystal_maiden_arcane_aura_custom_shield_tracker", {})
end


function modifier_maiden_arcane_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_maiden_arcane_5:RemoveOnDeath() return false end