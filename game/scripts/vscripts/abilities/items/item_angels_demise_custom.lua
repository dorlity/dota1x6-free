LinkLuaModifier("modifier_item_angels_demise_custom", "abilities/items/item_angels_demise_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_angels_demise_custom_debuff", "abilities/items/item_angels_demise_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_angels_demise_custom_active", "abilities/items/item_angels_demise_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_angels_demise_custom_cd", "abilities/items/item_angels_demise_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_angels_demise_custom_break", "abilities/items/item_angels_demise_custom", LUA_MODIFIER_MOTION_NONE)

item_angels_demise_custom = class({})

function item_angels_demise_custom:GetIntrinsicModifierName()
return "modifier_item_angels_demise_custom"
end

function item_angels_demise_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/empyreal_lens_target.vpcf", context )
PrecacheResource( "particle","particles/empyreal_lens.vpcf", context )
PrecacheResource( "particle","particles/items/khanda_active.vpcf", context )
end


function item_angels_demise_custom:OnSpellStart()
local caster = self:GetCaster()
caster:EmitSound("Item.Khanda_active")
local duration = self:GetSpecialValueFor("active_duration")
caster:RemoveModifierByName("modifier_item_angels_demise_custom_cd")
caster:AddNewModifier(caster, self, "modifier_item_angels_demise_custom_active", {duration = duration})
end


modifier_item_angels_demise_custom = class({})
function modifier_item_angels_demise_custom:IsHidden() return true end
function modifier_item_angels_demise_custom:IsPurgable() return false end
function modifier_item_angels_demise_custom:IsPurgeException() return false end
function modifier_item_angels_demise_custom:IsPurgable() return false end
function modifier_item_angels_demise_custom:RemoveOnDeath() return false end

function modifier_item_angels_demise_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
}
end


function modifier_item_angels_demise_custom:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

if self.parent:IsRealHero() then 
	self.parent:AddDamageEvent_out(self, true)
end 

self.stats = self.ability:GetSpecialValueFor("bonus_all_stats")
self.health = self.ability:GetSpecialValueFor("bonus_health")
self.mana = self.ability:GetSpecialValueFor("bonus_mana")
self.regen = self.ability:GetSpecialValueFor("bonus_regen")

self.passive_cd = self.ability:GetSpecialValueFor("passive_cd")
self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
self.break_duration = self.ability:GetSpecialValueFor("active_slow")

self.min_damage = self.ability:GetSpecialValueFor("min_damage_to_activate")
self.base_damage = self.ability:GetSpecialValueFor("bonus_spell_damage")
end 


function modifier_item_angels_demise_custom:DamageEvent_out(params)
if not IsServer() then return end
if params.attacker ~= self.parent  then return end
if params.unit == self.parent  then return end
if not self.parent:IsRealHero() then return end
if params.inflictor == nil then return end
if params.inflictor == self.ability then return end
if params.inflictor:IsItem() then return end
if not self.parent:IsAlive() then return end
if params.damage < self.min_damage then return end
if self.parent:HasModifier("modifier_item_angels_demise_custom_cd") then return end
if self.parent :HasModifier("modifier_item_phylactery_lens_custom") then return end
if (self.parent :GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() > 1200 then return end

local unit = params.unit
local duration = self.slow_duration
local damage = self.base_damage
local name ="modifier_item_angels_demise_custom_debuff" 
local mod = self.parent:FindModifierByName("modifier_item_angels_demise_custom_active")
if mod then
	if not unit:IsRealHero() then
		return
	end
	name = "modifier_item_angels_demise_custom_break"
	duration = self.break_duration*(1 - unit:GetStatusResistance())
	mod:Destroy()
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_angels_demise_custom_cd", {duration = self.passive_cd})
SendOverheadEventMessage(unit, 4, params.unit, damage, nil)
DoDamage({attacker = self.parent, victim = unit, ability = self.ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
unit:AddNewModifier(self.parent , self.ability, name, {duration = duration})

local phyl_particle = "particles/items_fx/phylactery.vpcf"
if self.parent:HasModifier("modifier_skywrath_mage_arcana_style_1_custom") then
    phyl_particle = "particles/econ/items/skywrath_mage/skywrath_arcana/skywrath_arcana_phylactery.vpcf"
elseif self.parent:HasModifier("modifier_skywrath_mage_arcana_style_2_custom") then
    phyl_particle = "particles/econ/items/skywrath_mage/skywrath_arcana/skywrath_arcana_phylactery_v2.vpcf"
end

local particle_2 = ParticleManager:CreateParticle(phyl_particle, PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle_2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle_2, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle_2)

unit:EmitSound("Item.Phylactery.Target")
end


function modifier_item_angels_demise_custom:GetModifierManaBonus()
return self.mana
end

function modifier_item_angels_demise_custom:GetModifierHealthBonus()
return self.health
end

function modifier_item_angels_demise_custom:GetModifierBonusStats_Strength()
return self.stats
end

function modifier_item_angels_demise_custom:GetModifierBonusStats_Agility()
return self.stats
end

function modifier_item_angels_demise_custom:GetModifierBonusStats_Intellect()
return self.stats
end

function modifier_item_angels_demise_custom:GetModifierConstantManaRegen()
return self.regen
end





modifier_item_angels_demise_custom_debuff = class({})
function modifier_item_angels_demise_custom_debuff:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_item_angels_demise_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_item_angels_demise_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end



modifier_item_angels_demise_custom_cd = class({})
function modifier_item_angels_demise_custom_cd:IsHidden() return false end
function modifier_item_angels_demise_custom_cd:IsPurgable() return false end
function modifier_item_angels_demise_custom_cd:IsDebuff() return true end
function modifier_item_angels_demise_custom_cd:RemoveOnDeath() return false end




modifier_item_angels_demise_custom_break = class({})
function modifier_item_angels_demise_custom_break:IsHidden() return false end
function modifier_item_angels_demise_custom_break:IsPurgable() return false end
function modifier_item_angels_demise_custom_break:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end
function modifier_item_angels_demise_custom_break:GetEffectName() return "particles/items3_fx/silver_edge.vpcf" end

function modifier_item_angels_demise_custom_break:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_item_angels_demise_custom_break:OnCreated(table)
self.speed = self:GetAbility():GetSpecialValueFor("slow")
self.parent = self:GetParent()
if not IsServer() then return end
self.parent:EmitSound("DOTA_Item.SilverEdge.Target")
self.parent:GenericParticle("particles/generic_gameplay/generic_break.vpcf", self, true)
end

function modifier_item_angels_demise_custom_break:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end


modifier_item_angels_demise_custom_active = class({})
function modifier_item_angels_demise_custom_active:IsHidden() return false end
function modifier_item_angels_demise_custom_active:IsPurgable() return false end
function modifier_item_angels_demise_custom_active:GetEffectName() return "particles/items/khanda_active.vpcf" end