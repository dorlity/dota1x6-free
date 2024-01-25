
item_patrol_reward_2_always_gadget               = class({})


function item_patrol_reward_2_always_gadget:OnAbilityPhaseStart()
local player = self:GetCaster()


if player:HasModifier("modifier_end_choise") then 
   return false
end


return true 

end


function item_patrol_reward_2_always_gadget:OnSpellStart()
if not IsServer() then return end


upgrade:init_upgrade(self:GetCaster(),12,nil,after_legen,nil,nil,2)
self:SpendCharge()

end
