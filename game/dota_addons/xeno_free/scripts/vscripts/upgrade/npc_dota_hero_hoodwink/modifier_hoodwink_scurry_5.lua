

modifier_hoodwink_scurry_5 = class({})


function modifier_hoodwink_scurry_5:IsHidden() return true end
function modifier_hoodwink_scurry_5:IsPurgable() return false end



function modifier_hoodwink_scurry_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local name = "hoodwink_scurry_custom"

if self:GetCaster():HasModifier("modifier_hoodwink_scurry_1") then 
  name = name.."_"..tostring(self:GetCaster():GetUpgradeStack("modifier_hoodwink_scurry_1"))
end


if not self:GetCaster():FindAbilityByName(name) then return end 

self:GetCaster():FindAbilityByName(name):ToggleAutoCast()

end


function modifier_hoodwink_scurry_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_hoodwink_scurry_5:RemoveOnDeath() return false end