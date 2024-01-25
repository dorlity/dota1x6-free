

modifier_legion_odds_mark = class({})


function modifier_legion_odds_mark:IsHidden() return true end
function modifier_legion_odds_mark:IsPurgable() return false end



function modifier_legion_odds_mark:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
local ability = self:GetParent():FindAbilityByName("custom_legion_commander_overwhelming_odds")
if ability then 
  ability:ToggleAutoCast()
end 


end


function modifier_legion_odds_mark:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_odds_mark:RemoveOnDeath() return false end