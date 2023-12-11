

modifier_sniper_shrapnel_6 = class({})


function modifier_sniper_shrapnel_6:IsHidden() return true end
function modifier_sniper_shrapnel_6:IsPurgable() return false end



function modifier_sniper_shrapnel_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local name = "sniper_shrapnel_custom"
local name2 = "sniper_shrapnel_custom_4"


local mod = self:GetParent():FindModifierByName("modifier_sniper_shrapnel_1")

if mod then 
	name = name.."_"..tostring(mod:GetStackCount())
	name2 = name2.."_"..tostring(mod:GetStackCount())
end

self:Swap(name, name2)

end


function modifier_sniper_shrapnel_6:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_sniper_shrapnel_6:RemoveOnDeath() return false end


function modifier_sniper_shrapnel_6:Swap(name1, name2)
if not IsServer() then return end

local ability1 = self:GetParent():FindAbilityByName(name1)
local ability2 = self:GetParent():FindAbilityByName(name2)

ability1:SetHidden(true)
ability2:SetHidden(false)
ability2:SetLevel(ability1:GetLevel())

ability2:SetCurrentAbilityCharges(ability1:GetCurrentAbilityCharges())

self:GetParent():SwapAbilities(name1, name2, false, true)

end

