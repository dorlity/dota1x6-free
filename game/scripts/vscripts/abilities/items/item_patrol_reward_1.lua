
item_patrol_reward_1               = class({})


function item_patrol_reward_1:OnAbilityPhaseStart()
local player = self:GetCaster()


if player:HasModifier("modifier_end_choise") then 
   return false
end


return true 

end


function item_patrol_reward_1:OnSpellStart()
if not IsServer() then return end

self.parent = self:GetParent()

upgrade:init_upgrade(self.parent, nil, nil, after_legen, nil, nil, "patrol_1")
self:SpendCharge(0)
end
