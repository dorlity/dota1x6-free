

modifier_terror_sunder_stats = class({})


function modifier_terror_sunder_stats:IsHidden() return true end
function modifier_terror_sunder_stats:IsPurgable() return false end



function modifier_terror_sunder_stats:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetParent():FindAbilityByName("custom_terrorblade_sunder")
if not ability then return end

ability:ToggleAutoCast()
end


function modifier_terror_sunder_stats:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_terror_sunder_stats:RemoveOnDeath() return false end