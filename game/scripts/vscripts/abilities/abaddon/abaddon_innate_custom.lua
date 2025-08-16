LinkLuaModifier( "modifier_abaddon_font_of_avernus_custom", "abilities/abaddon/abaddon_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_font_of_avernus_custom_heal_reduce", "abilities/abaddon/abaddon_innate_custom", LUA_MODIFIER_MOTION_NONE )


abaddon_innate_custom = class({})


function abaddon_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_withering_mist_debuff.vpcf", context )
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_abaddon.vsndevts", context )

dota1x6:PrecacheShopItems("npc_dota_hero_abaddon", context)
end


function abaddon_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_abaddon_font_of_avernus_custom"
end



modifier_abaddon_font_of_avernus_custom = class({})
function modifier_abaddon_font_of_avernus_custom:IsHidden() return true end
function modifier_abaddon_font_of_avernus_custom:IsPurgable() return false end
function modifier_abaddon_font_of_avernus_custom:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.duration = self.ability:GetSpecialValueFor("duration")
self.health = self.ability:GetSpecialValueFor("health")

self.health_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_3", "health")

if not IsServer() then return end
self.parent:AddDamageEvent_out(self, true)
self:UpdateTalent()
end

function modifier_abaddon_font_of_avernus_custom:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_abaddon_hero_3" or self.parent:HasTalent("modifier_abaddon_hero_3") then 
	self.health_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_3", "health")
end

end


function modifier_abaddon_font_of_avernus_custom:DamageEvent_out(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if self.parent ~= params.attacker then return end
if not params.unit:IsUnit() then return end

local unit = params.unit
local health = self.health + self.health_bonus

if unit:GetHealthPercent() > health then return end
unit:AddNewModifier(self.parent, self.parent:BkbAbility(self.ability, self.parent:HasTalent("modifier_abaddon_hero_7")) , "modifier_abaddon_font_of_avernus_custom_heal_reduce", {duration = self.duration})
end




modifier_abaddon_font_of_avernus_custom_heal_reduce = class({})
function modifier_abaddon_font_of_avernus_custom_heal_reduce:IsHidden() return true end
function modifier_abaddon_font_of_avernus_custom_heal_reduce:IsPurgable() return true end
function modifier_abaddon_font_of_avernus_custom_heal_reduce:OnCreated()
self.caster = self:GetCaster()
self.ability = self.caster:FindAbilityByName("abaddon_innate_custom")
if not self.ability then
	self:Destroy()
	return
end

self.heal_reduce = self.ability:GetSpecialValueFor("heal_reduce") + self.caster:GetTalentValue("modifier_abaddon_hero_3", "effect")
self.damage_reduction = self.ability:GetSpecialValueFor("damage_reduction") + self.caster:GetTalentValue("modifier_abaddon_hero_3", "effect")
end

function modifier_abaddon_font_of_avernus_custom_heal_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_abaddon_font_of_avernus_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage()
return self.heal_reduce
end

function modifier_abaddon_font_of_avernus_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end

function modifier_abaddon_font_of_avernus_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage()
return self.heal_reduce
end

function modifier_abaddon_font_of_avernus_custom_heal_reduce:GetModifierSpellAmplify_Percentage()
return self.damage_reduction
end

function modifier_abaddon_font_of_avernus_custom_heal_reduce:GetModifierDamageOutgoing_Percentage()
return self.damage_reduction
end


function modifier_abaddon_font_of_avernus_custom_heal_reduce:GetEffectName()
return "particles/units/heroes/hero_abaddon/abaddon_withering_mist_debuff.vpcf"
end