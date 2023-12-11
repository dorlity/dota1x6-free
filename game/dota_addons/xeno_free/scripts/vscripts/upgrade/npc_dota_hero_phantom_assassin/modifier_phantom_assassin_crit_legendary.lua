

modifier_phantom_assassin_crit_legendary = class({})


function modifier_phantom_assassin_crit_legendary:IsHidden() return true end
function modifier_phantom_assassin_crit_legendary:IsPurgable() return false end



function modifier_phantom_assassin_crit_legendary:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.ActiveTalent = true

  local ability = self:GetCaster():FindAbilityByName("custom_phantom_assassin_coup_de_grace")
  if ability then 
  	
 end
end




function modifier_phantom_assassin_crit_legendary:RemoveOnDeath() return false end