LinkLuaModifier("modifier_item_tranquil_boots_custom", "abilities/items/item_tranquil_boots_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_tranquil_boots_custom_broken", "abilities/items/item_tranquil_boots_custom", LUA_MODIFIER_MOTION_NONE)

item_tranquil_boots_custom = class({})

function item_tranquil_boots_custom:GetIntrinsicModifierName()
	return "modifier_item_tranquil_boots_custom"
end

function item_tranquil_boots_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_item_tranquil_boots_custom_broken") then 
    return "item_tranquil_boots_active"
end

return "item_tranquil_boots"
end



modifier_item_tranquil_boots_custom = class({})

function modifier_item_tranquil_boots_custom:IsHidden() return true end
function modifier_item_tranquil_boots_custom:IsPurgable() return false end
function modifier_item_tranquil_boots_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_tranquil_boots_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
    }

    return funcs
end

function modifier_item_tranquil_boots_custom:OnCreated(table)

self.damage_min = self:GetAbility():GetSpecialValueFor("break_threshold")
self.cd = self:GetAbility():GetSpecialValueFor("break_time")

self.heal = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
self.break_heal = self:GetAbility():GetSpecialValueFor("bonus_health_regen")*-1

self.move = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
self.break_move = self:GetAbility():GetSpecialValueFor("broken_movement_speed")
end

function modifier_item_tranquil_boots_custom:OnTakeDamage(params)
if not IsServer() then return end 
if not params.attacker then return end 
if params.attacker == self:GetParent() then return end 
if self:GetParent() ~= params.unit then return end 
if params.damage < self.damage_min then return end 

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_tranquil_boots_custom_broken", {duration = self.cd})
self:GetAbility():StartCooldown(self.cd)

end 




function modifier_item_tranquil_boots_custom:GetModifierConstantHealthRegen()

local bonus = 0 

if self:GetCaster():HasModifier("modifier_item_tranquil_boots_custom_broken") then 
    bonus = self.break_heal
end 

return self.heal + bonus
end



function modifier_item_tranquil_boots_custom:GetModifierMoveSpeedBonus_Constant()


if self:GetCaster():HasModifier("modifier_item_tranquil_boots_custom_broken") then 
    return self.break_move
end 

return self.move
end



modifier_item_tranquil_boots_custom_broken = class({})
function modifier_item_tranquil_boots_custom_broken:IsHidden() return true end
function modifier_item_tranquil_boots_custom_broken:IsPurgable() return false end
function modifier_item_tranquil_boots_custom_broken:RemoveOnDeath() return false end
function modifier_item_tranquil_boots_custom_broken:OnCreated()
self.RemoveForDuel = true
end