

modifier_bloodseeker_thirst_7 = class({})


function modifier_bloodseeker_thirst_7:IsHidden() return true end
function modifier_bloodseeker_thirst_7:IsPurgable() return false end



function modifier_bloodseeker_thirst_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetParent():FindAbilityByName("bloodseeker_thirst_custom")
if ability and ability:GetLevel() > 0 then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("bloodseeker_thirst_custom"), "modifier_bloodseeker_thirst_custom_legendary", {})
end

end


function modifier_bloodseeker_thirst_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bloodseeker_thirst_7:RemoveOnDeath() return false end