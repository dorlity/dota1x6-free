LinkLuaModifier( "modifier_legion_commander_innate_custom", "abilities/legion_commander/legion_commander_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_legion_commander_innate_custom_heal", "abilities/legion_commander/legion_commander_innate_custom", LUA_MODIFIER_MOTION_NONE )


legion_commander_innate_custom = class({})

function legion_commander_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_legion_commander.vsndevts", context )
PrecacheResource( "soundfile", "soundevents/vo_custom/legion_commander_vo_custom.vsndevts", context ) 
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/jugg_agility_boost.vpcf", context )
end

function legion_commander_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_legion_commander_innate_custom"
end



modifier_legion_commander_innate_custom = class({})
function modifier_legion_commander_innate_custom:IsHidden() return true end
function modifier_legion_commander_innate_custom:IsPurgable() return false end
function modifier_legion_commander_innate_custom:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.duration = self.ability:GetSpecialValueFor("duration")
self.parent:AddAttackEvent_out(self)
end

function modifier_legion_commander_innate_custom:AttackEvent_out(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
if self.parent:GetHealthPercent() >= params.target:GetHealthPercent() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_legion_commander_innate_custom_heal", {duration = self.duration})
end



modifier_legion_commander_innate_custom_heal = class({})
function modifier_legion_commander_innate_custom_heal:IsPurgable() return false end
function modifier_legion_commander_innate_custom_heal:IsHidden() return false end

function modifier_legion_commander_innate_custom_heal:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.heal = self.ability:GetSpecialValueFor("heal") + self.parent:GetTalentValue("modifier_legion_duel_2", "heal_bonus")
end

function modifier_legion_commander_innate_custom_heal:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_legion_commander_innate_custom_heal:GetModifierLifestealRegenAmplify_Percentage()
return self.heal
end

function modifier_legion_commander_innate_custom_heal:GetModifierHealAmplify_PercentageTarget()
return self.heal
end

function modifier_legion_commander_innate_custom_heal:GetModifierHPRegenAmplify_Percentage()
return self.heal
end

function modifier_legion_commander_innate_custom_heal:GetEffectName()
return "particles/units/heroes/hero_juggernaut/jugg_agility_boost.vpcf"
end