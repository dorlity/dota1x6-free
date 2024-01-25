

modifier_bristle_back_ground = class({})


function modifier_bristle_back_ground:IsHidden() return true end
function modifier_bristle_back_ground:IsPurgable() return false end



function modifier_bristle_back_ground:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
if not self:GetParent():HasAbility("bristleback_bristleback_custom") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("bristleback_bristleback_custom"), "modifier_bristleback_bristleback_custom_taunt_cd", {})

end


function modifier_bristle_back_ground:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bristle_back_ground:RemoveOnDeath() return false end