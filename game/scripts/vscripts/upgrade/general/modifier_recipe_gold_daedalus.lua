

modifier_recipe_gold_daedalus = class({})


function modifier_recipe_gold_daedalus:IsHidden() return true end
function modifier_recipe_gold_daedalus:IsPurgable() return false end


function modifier_recipe_gold_daedalus:OnCreated(table)
if not IsServer() then return end

if self:GetParent().alchemist_chosen_item == nil then 
	self:GetParent().alchemist_chosen_item = {}
end

self:GetParent().alchemist_chosen_item[self:GetName()] = true

  local item = CreateItem("item_recipe_alchemist_gold_daedalus", self:GetParent(), self:GetParent())
  	if self:GetParent():GetNumItemsInInventory() < 10 then
            self:GetParent():AddItem(item)
     else
     	CreateItemOnPositionSync(GetGroundPosition(self:GetParent():GetAbsOrigin(),  self:GetParent()), item)
    end

    

self:Destroy()


end


