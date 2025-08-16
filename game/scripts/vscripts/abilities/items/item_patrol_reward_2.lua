
item_patrol_reward_2               = class({})


function item_patrol_reward_2:OnAbilityPhaseStart()
local player = self:GetCaster()


if player:HasModifier("modifier_end_choise") then 
   return false
end


return true 

end


function item_patrol_reward_2:OnSpellStart()
if not IsServer() then return end


self.parent = self:GetParent()

upgrade:init_upgrade(self.parent, nil, nil, after_legen, nil, nil, "patrol_2")

self:SpendCharge(0)

end
