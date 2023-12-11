

modifier_patrol_reward_contract = class({})


function modifier_patrol_reward_contract:IsHidden() return true end
function modifier_patrol_reward_contract:IsPurgable() return false end


function modifier_patrol_reward_contract:OnCreated(table)
if not IsServer() then return end

  local item = CreateItem("item_contract", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


