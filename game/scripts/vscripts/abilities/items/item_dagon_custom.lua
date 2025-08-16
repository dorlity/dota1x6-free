LinkLuaModifier("modifier_item_dagon_custom", "abilities/items/item_dagon_custom", LUA_MODIFIER_MOTION_NONE)

item_dagon_custom = class({})
item_dagon_2_custom = class({})
item_dagon_3_custom = class({})
item_dagon_4_custom = class({})
item_dagon_5_custom = class({})


function item_dagon_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items_fx/dagon.vpcf", context )
PrecacheResource( "particle","particles/items3_fx/octarine_core_lifesteal.vpcf", context )
PrecacheResource( "particle","particles/items3_fx/silver_edge.vpcf", context )
PrecacheResource( "particle","particles/generic_gameplay/generic_break.vpcf", context )
end

function item_dagon_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end
function item_dagon_2_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end
function item_dagon_3_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end
function item_dagon_4_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end
function item_dagon_5_custom:GetIntrinsicModifierName() return "modifier_item_dagon_custom" end

function item_dagon_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end

function item_dagon_2_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end

function item_dagon_3_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end

function item_dagon_4_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end

function item_dagon_5_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end



function item_dagon_custom:OnSpellStart()
local mod = self:GetCaster():FindModifierByName("modifier_item_dagon_custom")
if mod then
    mod:DealDamage(self:GetCursorTarget())
end

end

function item_dagon_2_custom:OnSpellStart()
local mod = self:GetCaster():FindModifierByName("modifier_item_dagon_custom")
if mod then
    mod:DealDamage(self:GetCursorTarget())
end

end

function item_dagon_3_custom:OnSpellStart()
local mod = self:GetCaster():FindModifierByName("modifier_item_dagon_custom")
if mod then
    mod:DealDamage(self:GetCursorTarget())
end

end

function item_dagon_4_custom:OnSpellStart()
local mod = self:GetCaster():FindModifierByName("modifier_item_dagon_custom")
if mod then
    mod:DealDamage(self:GetCursorTarget())
end

end

function item_dagon_5_custom:OnSpellStart()
local mod = self:GetCaster():FindModifierByName("modifier_item_dagon_custom")
if mod then
    mod:DealDamage(self:GetCursorTarget())
end

end



modifier_item_dagon_custom = class({})
function modifier_item_dagon_custom:IsHidden() return true end
function modifier_item_dagon_custom:IsPurgable() return false end
function modifier_item_dagon_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
}
end

function modifier_item_dagon_custom:GetModifierBonusStats_Strength() 
return self.stats 
end

function modifier_item_dagon_custom:GetModifierBonusStats_Agility()
return self.stats 
end

function modifier_item_dagon_custom:GetModifierBonusStats_Intellect()
return self.stats 
end


function modifier_item_dagon_custom:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.creeps = self.ability:GetSpecialValueFor("creeps")
self.stats = self.ability:GetSpecialValueFor("bonus_stats")
self.lifesteal = self.ability:GetSpecialValueFor("spell_lifesteal")/100
self.active_heal = self.ability:GetSpecialValueFor("active_heal")/100

self.radius = self.ability:GetSpecialValueFor("aoe_radius")
self.damage = self.ability:GetSpecialValueFor("damage")
self.mana_damage = self.ability:GetSpecialValueFor("mana_damage")/100

if self.parent:IsRealHero() then 
    self.parent:AddDamageEvent_out(self, true)
end 

end

function modifier_item_dagon_custom:DealDamage(target)
if not IsServer() then return end

local caster = self.parent
local point = target:GetAbsOrigin()

target:EmitSound("DOTA_Item.Dagon"..self.ability:GetLevel()..".Target")

if target:TriggerSpellAbsorb(self.ability) then return end

caster:EmitSound("DOTA_Item.Dagon.Activate")
local damage_table = { attacker = caster, ability = self.ability, damage = self.damage + self.mana_damage*caster:GetMaxMana(), damage_type = DAMAGE_TYPE_MAGICAL }

local visual_caster = caster
local mod = caster:FindModifierByName("modifier_life_stealer_infest_custom")
if mod and mod.target then
    visual_caster = mod.target
end

for _, enemy in pairs(caster:FindTargets(self.radius, point)) do
    local dagon_pfx = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf", PATTACH_RENDERORIGIN_FOLLOW, visual_caster)
    ParticleManager:SetParticleControlEnt(dagon_pfx, 0, visual_caster, PATTACH_POINT_FOLLOW, "attach_attack1", visual_caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(dagon_pfx, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false)
    ParticleManager:SetParticleControl(dagon_pfx, 2, Vector(damage, 0, 0))
    ParticleManager:SetParticleControl(dagon_pfx, 3, Vector(0.3, 0, 0))
    ParticleManager:ReleaseParticleIndex(dagon_pfx)

    damage_table.victim = enemy
    local damage = DoDamage(damage_table)

    if enemy == target and not enemy:IsIllusion() then 
        caster:GenericHeal(damage*self.active_heal, self.ability)
    end

    if enemy:IsIllusion() and not enemy:HasModifier("modifier_chaos_knight_phantasm_illusion") then
        enemy:Kill(self.ability, caster)
    end
end

end


function modifier_item_dagon_custom:DamageEvent_out(params)
if not self.parent:CheckLifesteal(params, 1) then return end
if (params.unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > 2000 then return end

local heal = self.lifesteal*params.damage

if not params.unit:IsHero() then
    heal = heal / self.creeps
end

self.parent:GenericHeal(heal, self.ability, true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
end






