

modifier_snapfire_scatter_4 = class({})


function modifier_snapfire_scatter_4:IsHidden() return true end
function modifier_snapfire_scatter_4:IsPurgable() return false end



function modifier_snapfire_scatter_4:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  --self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("snapfire_scatterblast_custom"), "modifier_snapfire_scatterblast_custom_timer", {})

end


function modifier_snapfire_scatter_4:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_snapfire_scatter_4:RemoveOnDeath() return false end