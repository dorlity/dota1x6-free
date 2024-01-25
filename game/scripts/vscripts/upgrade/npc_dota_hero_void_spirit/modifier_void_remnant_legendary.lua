

modifier_void_remnant_legendary = class({})


function modifier_void_remnant_legendary:IsHidden() return true end
function modifier_void_remnant_legendary:IsPurgable() return false end



function modifier_void_remnant_legendary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

if not self:GetParent():HasAbility("void_spirit_aether_remnant_custom_legendary") then return end 

self:GetParent():FindAbilityByName("void_spirit_aether_remnant_custom_legendary"):SetHidden(false)
self:GetParent():FindAbilityByName("void_spirit_aether_remnant_custom_legendary"):SetActivated(false)

end


function modifier_void_remnant_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_void_remnant_legendary:RemoveOnDeath() return false end