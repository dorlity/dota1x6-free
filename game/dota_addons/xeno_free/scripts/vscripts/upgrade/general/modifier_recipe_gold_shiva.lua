

modifier_recipe_gold_shiva = class({})


function modifier_recipe_gold_shiva:IsHidden() return true end
function modifier_recipe_gold_shiva:IsPurgable() return false end


function modifier_recipe_gold_shiva:OnCreated(table)
if not IsServer() then return end

if self:GetParent().alchemist_chosen_item == nil then 
	self:GetParent().alchemist_chosen_item = {}
end

self:GetParent().alchemist_chosen_item[self:GetName()] = true

  local item = CreateItem("item_recipe_alchemist_gold_shiva", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


