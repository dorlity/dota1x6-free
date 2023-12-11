
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

upgrade:init_upgrade(self:GetCaster(),11,nil,after_legen)
self:SpendCharge()

end
