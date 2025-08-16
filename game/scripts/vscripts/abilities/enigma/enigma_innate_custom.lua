LinkLuaModifier( "modifier_enigma_innate_custom", "abilities/enigma/enigma_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_innate_custom_debuff", "abilities/enigma/enigma_innate_custom", LUA_MODIFIER_MOTION_NONE )


enigma_innate_custom = class({})

function enigma_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_enigma_innate_custom"
end


function enigma_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_enigma.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_enigma", context)
end

modifier_enigma_innate_custom = class({})
function modifier_enigma_innate_custom:IsHidden() return true end
function modifier_enigma_innate_custom:IsPurgable() return false end
function modifier_enigma_innate_custom:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")

end

function modifier_enigma_innate_custom:IsAura() return not self.parent:PassivesDisabled() end
function modifier_enigma_innate_custom:GetAuraDuration() return 0.1 end
function modifier_enigma_innate_custom:GetAuraRadius() return self.radius end
function modifier_enigma_innate_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_enigma_innate_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_enigma_innate_custom:GetModifierAura() return "modifier_enigma_innate_custom_debuff" end



modifier_enigma_innate_custom_debuff = class({})
function modifier_enigma_innate_custom_debuff:IsHidden() return true end
function modifier_enigma_innate_custom_debuff:IsPurgable() return false end
function modifier_enigma_innate_custom_debuff:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.damage_reduce = self.ability:GetSpecialValueFor("damage_reduction")
self.min_dist = self.ability:GetSpecialValueFor("min_dist")
self.max_dist = self.ability:GetSpecialValueFor("radius")
if not IsServer() then return end

local interval = 0.1
if self.parent:IsCreep() then
	interval = 0.5
end

self:OnIntervalThink()
self:StartIntervalThink(interval)
end

function modifier_enigma_innate_custom_debuff:OnIntervalThink()
if not IsServer() then return end

local damage_reduce = self.damage_reduce
if self.caster:HasTalent("modifier_enigma_midnight_2") then
	damage_reduce = damage_reduce + self.caster:GetTalentValue("modifier_enigma_midnight_2", "damage_reduce")
end

local vec = (self.parent:GetAbsOrigin() - self.caster:GetAbsOrigin())

local length = math.min(self.max_dist, math.max(self.min_dist, vec:Length2D())) - self.min_dist
local damage_reduce = damage_reduce*(1 - length/(self.max_dist - self.min_dist))

self:SetStackCount(damage_reduce)
end

function modifier_enigma_innate_custom_debuff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_enigma_innate_custom_debuff:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount()*-1
end

function modifier_enigma_innate_custom_debuff:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*-1
end