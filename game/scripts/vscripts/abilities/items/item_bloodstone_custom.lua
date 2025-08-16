LinkLuaModifier("modifier_item_bloodstone_custom", "abilities/items/item_bloodstone_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloodstone_custom_buff", "abilities/items/item_bloodstone_custom", LUA_MODIFIER_MOTION_NONE)

item_bloodstone_custom = class({})


function item_bloodstone_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items3_fx/octarine_core_lifesteal.vpcf", context )
PrecacheResource( "particle","particles/items_fx/bloodstone_heal.vpcf", context )
end

function item_bloodstone_custom:OnSpellStart()
local caster = self:GetCaster()
caster:EmitSound("DOTA_Item.Bloodstone.Cast")
caster:Purge(false, true, false, false, false)

local duration = self:GetSpecialValueFor("buff_duration")
caster:AddNewModifier(caster, self, "modifier_item_bloodstone_custom_buff", {duration = duration})
end

function item_bloodstone_custom:GetIntrinsicModifierName()
	return "modifier_item_bloodstone_custom"
end

modifier_item_bloodstone_custom = class({})

function modifier_item_bloodstone_custom:IsHidden() return true end
function modifier_item_bloodstone_custom:IsPurgable() return false end

function modifier_item_bloodstone_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_PROPERTY_MANA_BONUS,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
}
end


function modifier_item_bloodstone_custom:GetModifierConstantManaRegen()
return self.mana_regen
end

function modifier_item_bloodstone_custom:GetModifierHealthBonus()
return self.bonus_health
end

function modifier_item_bloodstone_custom:GetModifierManaBonus()
return self.bonus_mana
end


function modifier_item_bloodstone_custom:OnCreated(table)
if not IsServer() then return end

self.ability = self:GetAbility()
self.parent = self:GetParent()

if self.parent:IsRealHero() then 
    self.parent:AddDamageEvent_out(self, true)
end 

self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")
self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")

self.heal_creeps = self.ability:GetSpecialValueFor("creeps")
self.lifesteal = self.ability:GetSpecialValueFor("spell_lifesteal") / 100
self.lifesteal_active = self.ability:GetSpecialValueFor("lifesteal_active") / 100
end

function modifier_item_bloodstone_custom:DamageEvent_out(params)
if not self.parent:CheckLifesteal(params, 1) then return end
if (params.unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > 2000 then return end

local lifesteal = self.lifesteal
local hide_number = true

if self.parent:HasModifier("modifier_item_bloodstone_custom_buff") then
	hide_number = false
	lifesteal = self.lifesteal_active
end

if params.unit:IsCreep() then
	lifesteal = lifesteal/self.heal_creeps
end

self.parent:GenericHeal(params.damage * lifesteal, self.ability, hide_number, "particles/items3_fx/octarine_core_lifesteal.vpcf") 
end





modifier_item_bloodstone_custom_buff = class({})
function modifier_item_bloodstone_custom_buff:IsPurgable() return false end
function modifier_item_bloodstone_custom_buff:IsPurgeException() return false end
function modifier_item_bloodstone_custom_buff:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.reduce =  self.ability:GetSpecialValueFor("mana_cost_active")
self.spell_damage = self.ability:GetSpecialValueFor("spell_damage")

if not IsServer() then return end
local particle = ParticleManager:CreateParticle("particles/items_fx/bloodstone_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 6, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)
end
function modifier_item_bloodstone_custom_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_item_bloodstone_custom_buff:GetModifierSpellAmplify_Percentage()
return (1 - self.parent:GetHealthPercent()/100) * self.spell_damage 
end

function modifier_item_bloodstone_custom_buff:GetModifierPercentageManacostStacking(params)
if params.ability == nil then return end
return self.reduce
end


