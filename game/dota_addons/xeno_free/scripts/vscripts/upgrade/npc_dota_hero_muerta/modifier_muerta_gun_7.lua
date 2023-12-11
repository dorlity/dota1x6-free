

modifier_muerta_gun_7 = class({})


function modifier_muerta_gun_7:IsHidden() return true end
function modifier_muerta_gun_7:IsPurgable() return false end



function modifier_muerta_gun_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

self:GetCaster():EmitSound("Muerta.Quest_item2")

if my_game.current_wave < upgrade_orange then 

	my_game:MuertaQuestPhase(self:GetParent())

	local item = CreateItem("item_muerta_shovel_custom", self:GetParent(), self:GetParent())
	self:GetParent():AddItem(item)

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'muerta_quest_panel',  { max = 0, stack = 0, stage = 1})
else 

	local item = CreateItem("item_muerta_mercy_and_grace_custom", self:GetParent(), self:GetParent())
	self:GetParent():AddItem(item)	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'muerta_quest_panel',  { max = 0, stack = 0, stage = 3})

end


end


function modifier_muerta_gun_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end




function modifier_muerta_gun_7:RemoveOnDeath() return false end