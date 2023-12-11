

modifier_legion_moment_armor = class({})


function modifier_legion_moment_armor:IsHidden() return true end
function modifier_legion_moment_armor:IsPurgable() return false end



function modifier_legion_moment_armor:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

if not self:GetParent():HasAbility("custom_legion_commander_moment_of_courage") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("custom_legion_commander_moment_of_courage"), "modifier_moment_of_courage_custom_crit_stack", {})
end


function modifier_legion_moment_armor:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_moment_armor:RemoveOnDeath() return false end