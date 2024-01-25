

modifier_zuus_bolt_7 = class({})


function modifier_zuus_bolt_7:IsHidden() return true end
function modifier_zuus_bolt_7:IsPurgable() return false end



function modifier_zuus_bolt_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
self:GetParent():FindAbilityByName("zuus_stormkeeper_custom"):SetHidden(false)
end


function modifier_zuus_bolt_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_zuus_bolt_7:RemoveOnDeath() return false end