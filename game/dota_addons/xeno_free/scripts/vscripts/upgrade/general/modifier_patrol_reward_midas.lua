

modifier_patrol_reward_midas = class({})


function modifier_patrol_reward_midas:IsHidden() return true end
function modifier_patrol_reward_midas:IsPurgable() return false end


function modifier_patrol_reward_midas:OnCreated(table)
if not IsServer() then return end

  local item = CreateItem("item_patrol_midas", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


