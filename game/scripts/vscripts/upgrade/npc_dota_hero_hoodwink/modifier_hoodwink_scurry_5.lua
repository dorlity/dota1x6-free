

modifier_hoodwink_scurry_5 = class({})


function modifier_hoodwink_scurry_5:IsHidden() return true end
function modifier_hoodwink_scurry_5:IsPurgable() return false end



function modifier_hoodwink_scurry_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability1 = self:GetParent():FindAbilityByName("hoodwink_scurry_custom")
local ability2 = self:GetParent():FindAbilityByName("hoodwink_scurry_custom_1")

if not ability1 then return end 
if not ability2 then return end 

self:GetCaster():SwapAbilities("hoodwink_scurry_custom_1", "hoodwink_scurry_custom", true, false)

ability2:ToggleAutoCast()

ability2:SetCurrentAbilityCharges(ability1:GetCurrentAbilityCharges())
end



function modifier_hoodwink_scurry_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_hoodwink_scurry_5:RemoveOnDeath() return false end