

modifier_antimage_void_2 = class({})


function modifier_antimage_void_2:IsHidden() return true end
function modifier_antimage_void_2:IsPurgable() return false end



function modifier_antimage_void_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true 


local ability = self:GetParent():FindAbilityByName("antimage_mana_void_custom")

if ability then 
  self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_antimage_mana_void_custom_aura", {})
end

end


function modifier_antimage_void_2:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_antimage_void_2:RemoveOnDeath() return false end