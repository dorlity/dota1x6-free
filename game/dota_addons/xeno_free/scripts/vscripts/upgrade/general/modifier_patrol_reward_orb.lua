

modifier_patrol_reward_orb = class({})


function modifier_patrol_reward_orb:IsHidden() return true end
function modifier_patrol_reward_orb:IsPurgable() return false end


function modifier_patrol_reward_orb:OnCreated(table)
if not IsServer() then return end

  local item = CreateItem("item_patrol_restrained_orb", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


