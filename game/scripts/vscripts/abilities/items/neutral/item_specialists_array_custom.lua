LinkLuaModifier("modifier_item_specialists_array_custom", "abilities/items/neutral/item_specialists_array_custom", LUA_MODIFIER_MOTION_NONE)

item_specialists_array_custom = class({})

function item_specialists_array_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_item_specialists_array_custom"
end


modifier_item_specialists_array_custom = class({})
function modifier_item_specialists_array_custom:IsHidden() return true end
function modifier_item_specialists_array_custom:IsPurgable() return false end
function modifier_item_specialists_array_custom:RemoveOnDeath() return false end
function modifier_item_specialists_array_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")
self.max = self.ability:GetSpecialValueFor("max")
self.crit = self.ability:GetSpecialValueFor("crit")
self.parent:AddAttackStartEvent_out(self)
end

function modifier_item_specialists_array_custom:AttackStartEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
if not self.ability:IsFullyCastable() then return end
if params.no_attack_cooldown then return end

local count = 0
local unit = params.target

for _,target in pairs(self.parent:FindTargets(self.radius, unit:GetAbsOrigin())) do
    if target ~= unit then
        count = count + 1
        self.parent:PerformAttack(target, true, false, true, true, true, false, true)

        if count >= self.max then
            break
        end
    end
end

self.ability:UseResources(false, false, false, true)
end


function modifier_item_specialists_array_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
}
end

function modifier_item_specialists_array_custom:GetCritDamage() 
return self.crit
end

function modifier_item_specialists_array_custom:GetModifierPreAttack_CriticalStrike()
if not self.ability:IsFullyCastable() then return end
return self.crit
end