

modifier_zuus_arc_4 = class({})


function modifier_zuus_arc_4:IsHidden() return true end
function modifier_zuus_arc_4:IsPurgable() return false end



function modifier_zuus_arc_4:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
    self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("zuus_arc_lightning_custom"), "modifier_zuus_arc_lightning_attack_stack_visual", {})
  
end


function modifier_zuus_arc_4:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_zuus_arc_4:RemoveOnDeath() return false end