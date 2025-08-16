LinkLuaModifier("modifier_item_heavens_halberd_custom", "abilities/items/item_heavens_halberd_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_heavens_halberd_custom_disarm", "abilities/items/item_heavens_halberd_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_item_heavens_halberd_custom_speed", "abilities/items/item_heavens_halberd_custom", LUA_MODIFIER_MOTION_HORIZONTAL)

item_heavens_halberd_custom = class({})



function item_heavens_halberd_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items2_fx/heavens_halberd.vpcf", context )
PrecacheResource( "particle","particles/items_fx/harpoon_pull.vpcf", context )
end

function item_heavens_halberd_custom:GetIntrinsicModifierName()
return "modifier_item_heavens_halberd_custom"
end

function item_heavens_halberd_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

caster:EmitSound("Item.heavens_halberd.Cast")

if target:TriggerSpellAbsorb(self) then
    return nil
end

local duration = self:GetSpecialValueFor("disarm_range")
if not target:IsRangedAttacker() then
   -- duration = self:GetSpecialValueFor("disarm_melee")
end

local dir = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
local point = caster:GetAbsOrigin() - dir*100
local distance = (point - target:GetAbsOrigin()):Length2D()
local max_dist = self:GetSpecialValueFor("pull_distance")
local pull_duration = self:GetSpecialValueFor("pull_duration")

distance = math.min(max_dist, math.max(40, distance))
point = target:GetAbsOrigin() + dir*distance

local mod = target:AddNewModifier( caster, self,  "modifier_generic_arc",  
{
    target_x = point.x,
    target_y = point.y,
    distance = distance,
    duration = pull_duration,
    height = 0,
    fix_end = false,
    isStun = false,
    activity = ACT_DOTA_FLAIL,
})

if mod then 
    target:GenericParticle("particles/items_fx/harpoon_pull.vpcf", mod)
end 

target:EmitSound("DOTA_Item.HeavensHalberd.Activate")
target:AddNewModifier(caster, self, "modifier_item_heavens_halberd_custom_disarm", {duration = (1 - target:GetStatusResistance())*duration})
caster:AddNewModifier(caster, self, "modifier_item_heavens_halberd_custom_speed", {duration = self:GetSpecialValueFor("speed_duration")})
end



modifier_item_heavens_halberd_custom = class(mod_hidden)
function modifier_item_heavens_halberd_custom:RemoveOnDeath() return false end
function modifier_item_heavens_halberd_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_heavens_halberd_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
}
end

function modifier_item_heavens_halberd_custom:GetModifierAttackRangeBonus()
if self:GetParent():IsRangedAttacker() then return end
return self.range
end

function modifier_item_heavens_halberd_custom:GetModifierBonusStats_Strength() 
return self.str
end

function modifier_item_heavens_halberd_custom:GetModifierBonusStats_Agility() 
return self.agi
end

function modifier_item_heavens_halberd_custom:GetModifierHealthBonus() 
return self.health
end

function modifier_item_heavens_halberd_custom:GetModifierConstantHealthRegen()
return self.health_regen
end

function modifier_item_heavens_halberd_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.str = self.ability:GetSpecialValueFor("bonus_str")
self.agi = self.ability:GetSpecialValueFor("bonus_agi")
self.health = self.ability:GetSpecialValueFor("bonus_health")
self.health_regen = self.ability:GetSpecialValueFor("bonus_health_regen")
self.range = self.ability:GetSpecialValueFor("attack_range")

self.block_chance = self.ability:GetSpecialValueFor("block_chance")
self.block_damage_melee = self.ability:GetSpecialValueFor("block_damage_melee")
self.block_damage_ranged = self.ability:GetSpecialValueFor("block_damage_ranged")
end

function modifier_item_heavens_halberd_custom:GetModifierPhysical_ConstantBlock(params)
if not IsServer() then return end
if self.parent ~= params.target then return end
if params.inflictor then return end
if self.parent:HasModifier("modifier_item_crimson_guard_custom") then return end
if params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end

if not RollPseudoRandomPercentage(self.block_chance, 2622, self.parent) then return end

local block = self.block_damage_melee
if self.parent:IsRangedAttacker() then
    block = self.block_damage_ranged
end
return block
end



modifier_item_heavens_halberd_custom_disarm = class({})
function modifier_item_heavens_halberd_custom_disarm:IsHidden() return true end
function modifier_item_heavens_halberd_custom_disarm:IsPurgable() return true end
function modifier_item_heavens_halberd_custom_disarm:CheckState()
return
{
    [MODIFIER_STATE_DISARMED] = true
}
end

function modifier_item_heavens_halberd_custom_disarm:OnCreated()
if not IsServer() then return end
self:GetParent():GenericParticle("particles/items2_fx/heavens_halberd.vpcf", self, true)
end


modifier_item_heavens_halberd_custom_speed = class({})
function modifier_item_heavens_halberd_custom_speed:IsHidden() return false end
function modifier_item_heavens_halberd_custom_speed:IsPurgable() return true end
function modifier_item_heavens_halberd_custom_speed:OnCreated()
self.speed = self:GetAbility():GetSpecialValueFor("attack_speed")
end

function modifier_item_heavens_halberd_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_item_heavens_halberd_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end