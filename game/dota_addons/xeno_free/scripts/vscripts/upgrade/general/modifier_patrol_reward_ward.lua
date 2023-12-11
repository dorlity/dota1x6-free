

modifier_patrol_reward_ward = class({})


function modifier_patrol_reward_ward:IsHidden() return true end
function modifier_patrol_reward_ward:IsPurgable() return false end


function modifier_patrol_reward_ward:OnCreated(table)
if not IsServer() then return end

  local item = CreateItem("item_ward_observer", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

Timers:CreateTimer(0.2, function()

local item = CreateItem("item_ward_sentry", self:GetParent(), self:GetParent())
if self:GetParent():GetNumItemsInInventory() < 10 then
    self:GetParent():AddItem(item)
else
    CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
end  

self:Destroy()

end)

end


