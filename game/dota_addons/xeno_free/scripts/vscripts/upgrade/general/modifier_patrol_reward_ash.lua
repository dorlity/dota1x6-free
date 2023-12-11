

modifier_patrol_reward_ash = class({})


function modifier_patrol_reward_ash:IsHidden() return true end
function modifier_patrol_reward_ash:IsPurgable() return false end


function modifier_patrol_reward_ash:OnCreated(table)
if not IsServer() then return end

  local item = CreateItem("item_patrol_respawn", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


