

modifier_snapfire_kisses_7 = class({})


function modifier_snapfire_kisses_7:IsHidden() return true end
function modifier_snapfire_kisses_7:IsPurgable() return false end



function modifier_snapfire_kisses_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  self:GetParent():FindAbilityByName("snapfire_mortimer_kisses_custom_legendary"):SetHidden(false)
end


function modifier_snapfire_kisses_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_snapfire_kisses_7:RemoveOnDeath() return false end