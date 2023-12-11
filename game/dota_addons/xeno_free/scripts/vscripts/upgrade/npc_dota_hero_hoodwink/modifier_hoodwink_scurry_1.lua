

modifier_hoodwink_scurry_1 = class({})


function modifier_hoodwink_scurry_1:IsHidden() return true end
function modifier_hoodwink_scurry_1:IsPurgable() return false end



function modifier_hoodwink_scurry_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:Swap("hoodwink_scurry_custom","hoodwink_scurry_custom_1")
end


function modifier_hoodwink_scurry_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
  
if self:GetStackCount() == 2 then 
  self:Swap("hoodwink_scurry_custom_1","hoodwink_scurry_custom_2")
end

if self:GetStackCount() == 3 then 
  self:Swap("hoodwink_scurry_custom_2","hoodwink_scurry_custom_3")
end

end

function modifier_hoodwink_scurry_1:RemoveOnDeath() return false end




function modifier_hoodwink_scurry_1:Swap(name1, name2)
if not IsServer() then return end

local ability1 = self:GetParent():FindAbilityByName(name1)
local ability2 = self:GetParent():FindAbilityByName(name2)

ability1:SetHidden(true)
ability2:SetHidden(false)

ability2:SetCurrentAbilityCharges(ability1:GetCurrentAbilityCharges())

if ability2:GetAutoCastState() ~= ability1:GetAutoCastState() then 
  ability2:ToggleAutoCast()
end

self:GetParent():SwapAbilities(name1, name2, false, true)

end
