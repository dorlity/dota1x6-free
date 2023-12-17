

modifier_antimage_counter_1 = class({})


function modifier_antimage_counter_1:IsHidden() return true end
function modifier_antimage_counter_1:IsPurgable() return false end



function modifier_antimage_counter_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true 


local ability = self:GetParent():FindAbilityByName("antimage_counterspell_custom")

if ability then 
  self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_antimage_counterspell_custom_aura", {})
end

end


function modifier_antimage_counter_1:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_antimage_counter_1:RemoveOnDeath() return false end