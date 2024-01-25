

modifier_sniper_assassinate_7 = class({})


function modifier_sniper_assassinate_7:IsHidden() return true end
function modifier_sniper_assassinate_7:IsPurgable() return false end



function modifier_sniper_assassinate_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetCaster():FindAbilityByName("sniper_assassinate_custom_legendary"):SetHidden(false)
end


function modifier_sniper_assassinate_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_sniper_assassinate_7:RemoveOnDeath() return false end