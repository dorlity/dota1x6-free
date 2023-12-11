LinkLuaModifier("modifier_up_ignore_armor_stack", "upgrade/general/modifier_up_ignore_armor", LUA_MODIFIER_MOTION_NONE)


modifier_up_ignore_armor = class({})


function modifier_up_ignore_armor:IsHidden() return true end
function modifier_up_ignore_armor:IsPurgable() return false end
function modifier_up_ignore_armor:RemoveOnDeath() return false end

function modifier_up_ignore_armor:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
  
}

end


function modifier_up_ignore_armor:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true 
end

function modifier_up_ignore_armor:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_up_ignore_armor:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.unit:IsMagicImmune() then return end
if params.unit:IsBuilding() then return end
if params.unit == params.attacker then return end

params.unit:AddNewModifier(self:GetParent(), nil, "modifier_up_ignore_armor_stack", {duration = 4})

end

modifier_up_ignore_armor_stack = class({})
function modifier_up_ignore_armor_stack:IsHidden() return true end
function modifier_up_ignore_armor_stack:IsPurgable() return false end
function modifier_up_ignore_armor_stack:GetTexture() return "item_orb_of_venom" end

function modifier_up_ignore_armor_stack:OnCreated()
if not IsServer() then return end 

self:SetStackCount(self:GetCaster():GetUpgradeStack("modifier_up_ignore_armor"))
end 
function modifier_up_ignore_armor_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end



function modifier_up_ignore_armor_stack:GetModifierPhysicalArmorBonus()


local k = 1
if self:GetCaster():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
  k = k + 0.4
end

if self:GetCaster():HasModifier("modifier_up_graypoints") then 
  k = k + 0.3
end 


return self:GetStackCount()*-1*k
end
