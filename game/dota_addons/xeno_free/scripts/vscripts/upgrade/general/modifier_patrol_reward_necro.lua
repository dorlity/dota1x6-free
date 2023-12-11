

modifier_patrol_reward_necro = class({})


function modifier_patrol_reward_necro:IsHidden() return true end
function modifier_patrol_reward_necro:IsPurgable() return false end


function modifier_patrol_reward_necro:OnCreated(table)
if not IsServer() then return end

local item = CreateItem("item_roshan_necro", self:GetParent(), self:GetParent())

if self:GetParent():GetNumItemsInInventory() < 10 then
    self:GetParent():AddItem(item)
else
  CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
end

    

self:Destroy()


end


