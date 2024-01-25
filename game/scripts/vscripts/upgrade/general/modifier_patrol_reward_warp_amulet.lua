

modifier_patrol_reward_warp_amulet = class({})


function modifier_patrol_reward_warp_amulet:IsHidden() return true end
function modifier_patrol_reward_warp_amulet:IsPurgable() return false end


function modifier_patrol_reward_warp_amulet:OnCreated(table)
if not IsServer() then return end

  local item = CreateItem("item_patrol_warp_amulet", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


