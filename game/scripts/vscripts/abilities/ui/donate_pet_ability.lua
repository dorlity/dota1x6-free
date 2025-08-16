
donate_pet_ability = class({})

function donate_pet_ability:OnToggle()

local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_donate_pet")

if not mod then return end

if mod:GetStackCount() == 1 then 
	mod:SetStackCount(0)
else 
	mod:SetStackCount(1)
end 


end
