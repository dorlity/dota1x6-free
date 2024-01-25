

modifier_patrol_reward_trap = class({})


function modifier_patrol_reward_trap:IsHidden() return true end
function modifier_patrol_reward_trap:IsPurgable() return false end


function modifier_patrol_reward_trap:OnCreated(table)
if not IsServer() then return end

  local item = CreateItem("item_patrol_trap", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


