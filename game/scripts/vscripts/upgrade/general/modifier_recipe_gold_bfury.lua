

modifier_recipe_gold_bfury = class({})


function modifier_recipe_gold_bfury:IsHidden() return true end
function modifier_recipe_gold_bfury:IsPurgable() return false end


function modifier_recipe_gold_bfury:OnCreated(table)
if not IsServer() then return end

if self:GetParent().alchemist_chosen_item == nil then 
	self:GetParent().alchemist_chosen_item = {}
end

self:GetParent().alchemist_chosen_item[self:GetName()] = true

  local item = CreateItem("item_recipe_alchemist_gold_bfury", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


