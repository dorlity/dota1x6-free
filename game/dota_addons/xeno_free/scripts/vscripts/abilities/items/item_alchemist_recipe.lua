

item_alchemist_recipe = class({})

function item_alchemist_recipe:OnSpellStart()
if not IsServer() then return end

upgrade:init_upgrade(self:GetCaster(),13,nil,nil)	
self:SpendCharge()
end

function item_alchemist_recipe:OnAbilityPhaseStart()
if not IsServer() then return end
if players[self:GetCaster():GetTeamNumber()]:HasModifier("modifier_end_choise")
 then return false end
return true
end


------------------------------------------------------------

