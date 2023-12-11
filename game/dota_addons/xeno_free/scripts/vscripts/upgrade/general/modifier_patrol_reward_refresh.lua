

modifier_patrol_reward_refresh = class({})


function modifier_patrol_reward_refresh:IsHidden() return true end
function modifier_patrol_reward_refresh:IsPurgable() return false end


function modifier_patrol_reward_refresh:OnCreated(table)
if not IsServer() then return end

local item = CreateItem("item_patrol_refresh", self:GetParent(), self:GetParent())
if self:GetParent():GetNumItemsInInventory() < 10 then
  self:GetParent():AddItem(item)
 else
 	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
end

self:Destroy()

end


