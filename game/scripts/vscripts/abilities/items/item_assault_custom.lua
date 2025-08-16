LinkLuaModifier("modifier_item_assault_custom", "abilities/items/item_assault_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_assault_custom_aura", "abilities/items/item_assault_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_assault_custom_buff", "abilities/items/item_assault_custom", LUA_MODIFIER_MOTION_NONE)

item_assault_custom = class({})

function item_assault_custom:GetIntrinsicModifierName()
return "modifier_item_assault_custom"
end

function item_assault_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/bristleback/armor_buff.vpcf", context )
end


modifier_item_assault_custom	= class(mod_hidden)
function modifier_item_assault_custom:RemoveOnDeath()	return false end
function modifier_item_assault_custom:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
self.radius = self.ability:GetSpecialValueFor("AbilityCastRange")
self.bonus_max = self.ability:GetSpecialValueFor("bonus_max")
self.timer = self.ability:GetSpecialValueFor("timer")
end

function modifier_item_assault_custom:AddStack()
if not IsServer() then return end

if self:GetStackCount() < self.bonus_max then
	self:IncrementStackCount()
	if self:GetStackCount() >= self.bonus_max and not self.particle then
		self.parent:EmitSound("BB.Back_shield")
		self.particle = self.parent:GenericParticle("particles/bristleback/armor_buff.vpcf", self)
	end
end
self:StartIntervalThink(self.timer)
end

function modifier_item_assault_custom:OnStackCountChanged(iStackCount)
if not IsServer() then return end
local mod = self.parent:FindModifierByName("modifier_item_assault_custom_aura")
if mod then
	mod:SetStackCount(self:GetStackCount())
end

end

function modifier_item_assault_custom:OnIntervalThink()
if not IsServer() then return end

if self.particle then
	ParticleManager:Delete(self.particle, 1)
	self.particle = nil
end

self:SetStackCount(0)
self:StartIntervalThink(-1)
end

function modifier_item_assault_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end

function modifier_item_assault_custom:GetModifierAttackSpeedBonus_Constant()
return self.bonus_attack_speed
end

function modifier_item_assault_custom:GetModifierPhysicalArmorBonus()
return self.bonus_armor
end

function modifier_item_assault_custom:GetAuraRadius() return self.radius end
function modifier_item_assault_custom:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_assault_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_item_assault_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_assault_custom:GetModifierAura() return "modifier_item_assault_custom_aura" end
function modifier_item_assault_custom:IsAura() 
if not IsServer() then return end
return IsValid(self.parent) and self.parent:IsRealHero() and not self.parent:IsTempestDouble()
end




modifier_item_assault_custom_aura = class(mod_visible)
function modifier_item_assault_custom_aura:IsHidden() return false end
function modifier_item_assault_custom_aura:IsPurgable() return false end
function modifier_item_assault_custom_aura:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.is_enemy = self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber()

self.aura_positive_armor = self.ability:GetSpecialValueFor("aura_positive_armor")
self.aura_attack_speed = self.ability:GetSpecialValueFor("aura_attack_speed")
self.aura_negative_armor = self.ability:GetSpecialValueFor("aura_negative_armor")

self.bonus_aura_armor = self.ability:GetSpecialValueFor("bonus_aura_armor")
self.bonus_aura_speed = self.ability:GetSpecialValueFor("bonus_aura_speed")
self.radius = self.ability:GetSpecialValueFor("AbilityCastRange")
end

function modifier_item_assault_custom_aura:GetAuraRadius() return self.radius end
function modifier_item_assault_custom_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_assault_custom_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_assault_custom_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_item_assault_custom_aura:GetModifierAura() return "modifier_item_assault_custom_buff" end
function modifier_item_assault_custom_aura:IsAura() return self.is_enemy and self.parent:IsRealHero() end
function modifier_item_assault_custom_aura:GetAuraEntityReject(hEntity)
return self.caster ~= hEntity
end

function modifier_item_assault_custom_aura:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_item_assault_custom_aura:GetModifierPhysicalArmorBonus()
if self.is_enemy then
	return self.aura_negative_armor
end
return self.aura_positive_armor + self.caster:GetUpgradeStack("modifier_item_assault_custom")*self.bonus_aura_armor
end

function modifier_item_assault_custom_aura:GetModifierAttackSpeedBonus_Constant()
if self.is_enemy then return end
return self.aura_attack_speed + self.caster:GetUpgradeStack("modifier_item_assault_custom")*self.bonus_aura_speed
end




modifier_item_assault_custom_buff = class(mod_hidden)
function modifier_item_assault_custom_buff:OnCreated()
self.parent = self:GetParent()

if not IsServer() then return end
self:StartIntervalThink(1)
end

function modifier_item_assault_custom_buff:OnIntervalThink()
if not IsServer() then return end
local mod = self.parent:FindModifierByName("modifier_item_assault_custom")
if mod then
	mod:AddStack()
end

end
