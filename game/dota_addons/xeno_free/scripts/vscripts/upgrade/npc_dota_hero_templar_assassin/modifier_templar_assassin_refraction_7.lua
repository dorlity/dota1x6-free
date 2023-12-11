

modifier_templar_assassin_refraction_7 = class({})


function modifier_templar_assassin_refraction_7:IsHidden() return true end
function modifier_templar_assassin_refraction_7:IsPurgable() return false end



function modifier_templar_assassin_refraction_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  local ability = self:GetCaster():FindAbilityByName("templar_assassin_refraction_custom")
  if ability then 
  	self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_templar_assassin_refraction_custom_legendary_stack", {})
  end
end


function modifier_templar_assassin_refraction_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_templar_assassin_refraction_7:RemoveOnDeath() return false end