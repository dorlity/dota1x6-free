

modifier_patrol_reward_grenade = class({})


function modifier_patrol_reward_grenade:IsHidden() return true end
function modifier_patrol_reward_grenade:IsPurgable() return false end


function modifier_patrol_reward_grenade:OnCreated(table)
if not IsServer() then return end


  local item = CreateItem("item_patrol_fortifier", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end
    

self:Destroy()


end


