

modifier_patrol_reward_repair = class({})


function modifier_patrol_reward_repair:IsHidden() return true end
function modifier_patrol_reward_repair:IsPurgable() return false end


function modifier_patrol_reward_repair:OnCreated(table)
if not IsServer() then return end

  local item = CreateItem("item_repair_patrol", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


