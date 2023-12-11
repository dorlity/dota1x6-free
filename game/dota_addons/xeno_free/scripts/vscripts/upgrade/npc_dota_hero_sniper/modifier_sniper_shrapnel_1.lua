

modifier_sniper_shrapnel_1 = class({})


function modifier_sniper_shrapnel_1:IsHidden() return true end
function modifier_sniper_shrapnel_1:IsPurgable() return false end



function modifier_sniper_shrapnel_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:LearnAbility()
end


function modifier_sniper_shrapnel_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
self:LearnAbility()
 
end

function modifier_sniper_shrapnel_1:LearnAbility()
if not IsServer() then return end

local name = "sniper_shrapnel_custom"

local mod = self:GetParent():FindModifierByName("modifier_sniper_shrapnel_6")

if mod then 
	name = "sniper_shrapnel_custom_4"
end

if self:GetStackCount() == 1 then 
	self:Swap(name, name..'_'..tostring(self:GetStackCount()))
else 
	self:Swap(name..'_'..tostring(self:GetStackCount() - 1), name..'_'..tostring(self:GetStackCount()))
end

end




function modifier_sniper_shrapnel_1:Swap(name1, name2)
if not IsServer() then return end

local ability1 = self:GetParent():FindAbilityByName(name1)
local ability2 = self:GetParent():FindAbilityByName(name2)

ability1:SetHidden(true)
ability2:SetHidden(false)
ability2:SetLevel(ability1:GetLevel())

ability2:SetCurrentAbilityCharges(ability1:GetCurrentAbilityCharges())

self:GetParent():SwapAbilities(name1, name2, false, true)

end





function modifier_sniper_shrapnel_1:RemoveOnDeath() return false end