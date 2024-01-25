

modifier_templar_assassin_psiblades_6 = class({})


function modifier_templar_assassin_psiblades_6:IsHidden() return true end
function modifier_templar_assassin_psiblades_6:IsPurgable() return false end



function modifier_templar_assassin_psiblades_6:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetParent():FindAbilityByName("templar_assassin_psi_blades_custom")
  if ability then 
  	self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_templar_assassin_psi_blades_custom_attack", {})
  end

end


function modifier_templar_assassin_psiblades_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_templar_assassin_psiblades_6:RemoveOnDeath() return false end