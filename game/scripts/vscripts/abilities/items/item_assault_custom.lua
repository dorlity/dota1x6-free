LinkLuaModifier("modifier_item_assault_custom", "abilities/items/item_assault_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_assault_custom_active_debuff", "abilities/items/item_assault_custom", LUA_MODIFIER_MOTION_NONE)

item_assault_custom = class({})

function item_assault_custom:GetIntrinsicModifierName()
	return "modifier_item_assault_custom"
end




modifier_item_assault_custom	= class({})

function modifier_item_assault_custom:IsPurgable()		return false end
function modifier_item_assault_custom:RemoveOnDeath()	return false end
function modifier_item_assault_custom:IsHidden()	return true end

function modifier_item_assault_custom:OnCreated()
self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
self.radius = self:GetAbility():GetSpecialValueFor("aura_radius")

self.parent = self:GetParent()

self:StartIntervalThink(0.2)
end


function modifier_item_assault_custom:OnIntervalThink()
if not IsServer() then return end

local stack = 0

for _,enemy in pairs(FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST,false)) do 
	local mod = enemy:FindModifierByName("modifier_item_assault_custom_active_debuff")

	if mod and mod.activated and mod.activated == true then
		stack = 1
		break
	end  
end 

if self:GetStackCount() ~= stack then

	if stack == 1 then  

		if self.particle == nil then 
			self:GetParent():EmitSound("BB.Back_shield")

			self.particle = ParticleManager:CreateParticle("particles/bristleback/armor_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(self.particle, false, false, -1, false, false)
		end
	else 

		if self.particle then 
			ParticleManager:DestroyParticle(self.particle, false)
			ParticleManager:ReleaseParticleIndex(self.particle)
			self.particle = nil
		end 

	end 
end 

self:SetStackCount(stack)
end 

function modifier_item_assault_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_item_assault_custom:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_assault_custom:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end


function modifier_item_assault_custom:GetAuraRadius()
return self.radius
end

function modifier_item_assault_custom:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_item_assault_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_item_assault_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_assault_custom:GetModifierAura()
	return "modifier_item_assault_custom_active_debuff"
end

function modifier_item_assault_custom:IsAura()
	return true
end






modifier_item_assault_custom_active_debuff = class({})

function modifier_item_assault_custom_active_debuff:OnCreated()
if not self:GetAbility() then self:Destroy() return end

self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_aura_armor")
self.bonus_speed = self:GetAbility():GetSpecialValueFor("bonus_aura_speed")


self.armor = self:GetAbility():GetSpecialValueFor("aura_negative_armor")
self.speed = 0

if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then 
	self.armor = self:GetAbility():GetSpecialValueFor("aura_positive_armor")
	self.speed = self:GetAbility():GetSpecialValueFor("aura_attack_speed")
end 

self.activated = false

if not IsServer() then return end 
if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
if not self:GetParent():IsHero() then return end

self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("timer"))
end


function modifier_item_assault_custom_active_debuff:OnIntervalThink()
if not IsServer() then return end 

self.activated = true

self:StartIntervalThink(-1)
end


function modifier_item_assault_custom_active_debuff:IsHidden() return false end
function modifier_item_assault_custom_active_debuff:IsPurgable() return false end

function modifier_item_assault_custom_active_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_item_assault_custom_active_debuff:GetModifierPhysicalArmorBonus()
local bonus = 0

if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and 
	self:GetCaster():HasModifier("modifier_item_assault_custom") and self:GetCaster():GetUpgradeStack("modifier_item_assault_custom") > 0 then 
	bonus = self.bonus_armor
end 

return self.armor + bonus
end



function modifier_item_assault_custom_active_debuff:GetModifierAttackSpeedBonus_Constant()

local bonus = 0

if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() and 
	self:GetCaster():HasModifier("modifier_item_assault_custom") and self:GetCaster():GetUpgradeStack("modifier_item_assault_custom") > 0 then 
	bonus = self.bonus_speed
end 

return self.speed + bonus
end



