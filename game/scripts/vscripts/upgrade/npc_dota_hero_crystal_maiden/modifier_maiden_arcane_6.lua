

modifier_maiden_arcane_6 = class({})


function modifier_maiden_arcane_6:IsHidden() return true end
function modifier_maiden_arcane_6:IsPurgable() return false end



function modifier_maiden_arcane_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
  
local ability = self:GetParent():FindAbilityByName("crystal_maiden_arcane_aura_custom")
if ability then 
  ability:ToggleAutoCast()
end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'crystal_attack_change',  {max = 1, damage = 0})


end


function modifier_maiden_arcane_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_maiden_arcane_6:RemoveOnDeath() return false end