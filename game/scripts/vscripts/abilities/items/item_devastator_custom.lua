LinkLuaModifier("item_devastator_custom_passive", "abilities/items/item_devastator_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_devastator_custom_resist", "abilities/items/item_devastator_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_devastator_custom_poison", "abilities/items/item_devastator_custom", LUA_MODIFIER_MOTION_NONE)

item_devastator_custom = class({})


function item_devastator_custom:GetIntrinsicModifierName()
return "item_devastator_custom_passive"
end


item_devastator_custom_passive = class({})
function item_devastator_custom_passive:IsHidden() return true end
function item_devastator_custom_passive:IsPurgable() return false end
function item_devastator_custom_passive:RemoveOnDeath() return false end
function item_devastator_custom_passive:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
  MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
  MODIFIER_PROPERTY_PROJECTILE_NAME
}
end


function item_devastator_custom_passive:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.int_bonus = self.ability:GetSpecialValueFor("bonus_intellect")
self.attack_bonus = self.ability:GetSpecialValueFor("bonus_attack_speed")
self.armor_bonus = self.ability:GetSpecialValueFor("bonus_armor")
self.speed_bonus = self.ability:GetSpecialValueFor("projectile_speed")
self.regen_bonus = self.ability:GetSpecialValueFor("bonus_regen")

self.resist_duration = self.ability:GetSpecialValueFor("resist_duration")
self.damage_duration = self.ability:GetSpecialValueFor("slow_duration")

if not IsServer() then return end

if self.parent:IsRealHero() then
  self.parent:AddAttackEvent_out(self, true)
end

end

function item_devastator_custom_passive:GetModifierBonusStats_Intellect()
return self.int_bonus
end

function item_devastator_custom_passive:GetModifierAttackSpeedBonus_Constant()
return self.attack_bonus
end

function item_devastator_custom_passive:GetModifierPhysicalArmorBonus()
return self.armor_bonus
end

function item_devastator_custom_passive:GetModifierProjectileSpeedBonus()
return self.speed_bonus
end

function item_devastator_custom_passive:GetModifierConstantManaRegen()
return self.regen_bonus
end


function item_devastator_custom_passive:AttackEvent_out(params)
if not IsServer() then return end
if params.attacker:IsIllusion() then return end

local target = params.target
local attacker = params.attacker

if self.parent ~= attacker then return end

local ability = params.attacker:FindItemInInventory(self.ability:GetName())
if not ability then return end
if not target:IsUnit() then return end

target:AddNewModifier(self.parent, ability, "item_devastator_custom_resist", {duration = self.resist_duration})

if not ability:IsFullyCastable() then return end
if self.parent:HasModifier("modifier_item_witch_blade") then return end

target:EmitSound("Item.WitchBlade.Target")
target:AddNewModifier(self.parent, ability, "item_devastator_custom_poison", {duration = self.damage_duration})
ability:UseResources(false, false, false, true)
end

function item_devastator_custom_passive:GetModifierProjectileName()
if not self.parent or self.parent:IsNull() then return end
if not self.parent:IsRealHero() then return end
if self.parent:HasModifier("modifier_item_witch_blade") then return end
if not self.ability:IsFullyCastable() then return end
return "particles/items_fx/parasma/parasma_base.vpcf"
end

function item_devastator_custom_passive:CheckState()
if not self.parent or self.parent:IsNull() then return end
if not self.parent:IsRealHero() then return end
if self.parent:HasModifier("modifier_item_witch_blade") then return end
if not self.ability:IsFullyCastable() then return end
return
{
  [MODIFIER_STATE_CANNOT_MISS] = true
}
end




item_devastator_custom_resist = class({})
function item_devastator_custom_resist:IsHidden() return true end
function item_devastator_custom_resist:IsPurgable() return true end
function item_devastator_custom_resist:OnCreated(table)
self.resist = self:GetAbility():GetSpecialValueFor("active_mres_reduction")*-1
end

function item_devastator_custom_resist:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function item_devastator_custom_resist:GetModifierMagicalResistanceBonus()
return self.resist
end



item_devastator_custom_poison = class({})
function item_devastator_custom_poison:IsHidden() return false end
function item_devastator_custom_poison:IsPurgable() return true end
function item_devastator_custom_poison:GetEffectName() return "particles/items3_fx/witch_blade_debuff.vpcf" end

function item_devastator_custom_poison:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.damage = self.ability:GetSpecialValueFor("int_damage_multiplier")
self.interval = 1
self.slow = self.ability:GetSpecialValueFor("slow")*-1
if not IsServer() then return end
self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

self:StartIntervalThink(self.interval)
end


function item_devastator_custom_poison:OnIntervalThink()
if not IsServer() then return end

local damage = self.caster:GetIntellect(false)*self.damage*self.interval
self.damageTable.damage = damage

DoDamage(self.damageTable)
self.parent:SendNumber(9, damage)
end


function item_devastator_custom_poison:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function item_devastator_custom_poison:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end