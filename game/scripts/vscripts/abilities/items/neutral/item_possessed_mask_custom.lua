LinkLuaModifier("modifier_item_possessed_mask_custom", "abilities/items/neutral/item_possessed_mask_custom", LUA_MODIFIER_MOTION_NONE)

item_possessed_mask_custom = class({})

function item_possessed_mask_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_item_possessed_mask_custom"
end


modifier_item_possessed_mask_custom = class({})
function modifier_item_possessed_mask_custom:IsHidden() return true end
function modifier_item_possessed_mask_custom:IsPurgable() return false end
function modifier_item_possessed_mask_custom:RemoveOnDeath() return false end
function modifier_item_possessed_mask_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.heal = self.ability:GetSpecialValueFor("heal")
self.bonus = self.ability:GetSpecialValueFor("bonus")
self.parent:AddAttackEvent_out(self, true)
end

function modifier_item_possessed_mask_custom:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local heal = self.heal
if params.target:IsHero() then
    heal = heal*self.bonus
end

self.parent:GenericHeal(heal, self.ability, true)
end