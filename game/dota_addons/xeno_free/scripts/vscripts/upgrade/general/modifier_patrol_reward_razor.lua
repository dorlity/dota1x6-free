

modifier_patrol_reward_razor = class({})


function modifier_patrol_reward_razor:IsHidden() return true end
function modifier_patrol_reward_razor:IsPurgable() return false end


function modifier_patrol_reward_razor:OnCreated(table)
if not IsServer() then return end

  local item = CreateItem("item_patrol_razor", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


