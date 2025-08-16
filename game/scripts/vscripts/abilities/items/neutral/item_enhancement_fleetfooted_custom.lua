LinkLuaModifier("modifier_item_enhancement_fleetfooted_custom", "abilities/items/neutral/item_enhancement_fleetfooted_custom", LUA_MODIFIER_MOTION_NONE)

item_enhancement_fleetfooted_custom = class({})

function item_enhancement_fleetfooted_custom:GetIntrinsicModifierName()
return "modifier_item_enhancement_fleetfooted_custom"
end


modifier_item_enhancement_fleetfooted_custom = class({})
function modifier_item_enhancement_fleetfooted_custom:IsHidden() return true end
function modifier_item_enhancement_fleetfooted_custom:IsPurgable() return false end
function modifier_item_enhancement_fleetfooted_custom:RemoveOnDeath() return false end
function modifier_item_enhancement_fleetfooted_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.movespeed = self.ability:GetSpecialValueFor("movespeed")

if not IsServer() then return end
self.mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_enhancement_brawny", {})
end

function modifier_item_enhancement_fleetfooted_custom:OnDestroy()
if not IsServer() then return end
if not self.mod or self.mod:IsNull() then return end
self.mod:Destroy()
end

function modifier_item_enhancement_fleetfooted_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}
end

function modifier_item_enhancement_fleetfooted_custom:GetModifierMoveSpeedBonus_Constant()
return self.movespeed
end

