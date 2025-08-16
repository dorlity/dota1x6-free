LinkLuaModifier("modifier_item_stormcrafter_custom", "abilities/items/neutral/item_stormcrafter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_stormcrafter_custom_speed", "abilities/items/neutral/item_stormcrafter_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_stormcrafter_custom_slow", "abilities/items/neutral/item_stormcrafter_custom", LUA_MODIFIER_MOTION_NONE)

item_stormcrafter_custom = class({})

function item_stormcrafter_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_item_stormcrafter_custom"
end

modifier_item_stormcrafter_custom = class({})
function modifier_item_stormcrafter_custom:IsHidden() return true end
function modifier_item_stormcrafter_custom:IsPurgable() return false end
function modifier_item_stormcrafter_custom:RemoveOnDeath() return false end
function modifier_item_stormcrafter_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.ability:GetSpecialValueFor("max")
self.damage = self.ability:GetSpecialValueFor("damage")
self.duration = self.ability:GetSpecialValueFor("duration")
self.radius = self.ability:GetSpecialValueFor("radius")
self.cd = self.ability:GetSpecialValueFor("cd")
self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")

self.damageTable = {attacker = self.parent, ability = self.ability, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL}

self.parent:AddAttackEvent_inc(self, true)
end

function modifier_item_stormcrafter_custom:AttackEvent_inc(params)
if not IsServer() then return end
if not self.ability:IsFullyCastable() then return end
if self.parent ~= params.target then return end
if not params.attacker:IsUnit() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_stormcrafter_custom_speed", {duration = self.duration})
local count = 1
self:DealDamage(params.attacker)

for _,target in pairs(self.parent:FindTargets(self.radius)) do
    if self.parent:CanEntityBeSeenByMyTeam(target) and target ~= params.attacker then
        count = count + 1
        self:DealDamage(target)
        if count >= self.max then
            break
        end
    end
end

self.ability:UseResources(false, false, false, true)
end


function modifier_item_stormcrafter_custom:DealDamage(target)
if not IsServer() then return end

self.damageTable.victim = target
DoDamage(self.damageTable)
target:AddNewModifier(self.parent, self.ability, "modifier_item_stormcrafter_custom_slow", {duration = self.slow_duration})
target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

local nParticleIndex = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_POINT_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(nParticleIndex, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(nParticleIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(nParticleIndex)
end



modifier_item_stormcrafter_custom_speed = class({})
function modifier_item_stormcrafter_custom_speed:IsHidden() return false end
function modifier_item_stormcrafter_custom_speed:IsPurgable() return true end
function modifier_item_stormcrafter_custom_speed:OnCreated()
self.speed = self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_item_stormcrafter_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_item_stormcrafter_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end



modifier_item_stormcrafter_custom_slow = class({})
function modifier_item_stormcrafter_custom_slow:IsHidden() return true end
function modifier_item_stormcrafter_custom_slow:IsPurgable() return true end
function modifier_item_stormcrafter_custom_slow:OnCreated()
self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_item_stormcrafter_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_item_stormcrafter_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end
