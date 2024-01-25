LinkLuaModifier("modifier_item_bloodstone_custom", "abilities/items/item_bloodstone_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloodstone_custom_buff", "abilities/items/item_bloodstone_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_bloodstone_custom_debuff", "abilities/items/item_bloodstone_custom", LUA_MODIFIER_MOTION_NONE)

item_bloodstone_custom = class({})

function item_bloodstone_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():EmitSound("DOTA_Item.Bloodstone.Cast")

	if self:GetCaster():HasModifier("modifier_item_bloodstone_custom_debuff") then return end

	local duration = self:GetSpecialValueFor("buff_duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_bloodstone_custom_buff", {duration = duration})
end

function item_bloodstone_custom:GetIntrinsicModifierName()
	return "modifier_item_bloodstone_custom"
end

modifier_item_bloodstone_custom = class({})

function modifier_item_bloodstone_custom:IsHidden() return true end
function modifier_item_bloodstone_custom:IsPurgable() return false end

function modifier_item_bloodstone_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end




function modifier_item_bloodstone_custom:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end

function modifier_item_bloodstone_custom:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana")
	end
end


function modifier_item_bloodstone_custom:OnCreated(table)
if not IsServer() then return end

self.lifesteal = self:GetAbility():GetSpecialValueFor("spell_lifesteal") / 100
self.lifesteal_creep = self:GetAbility():GetSpecialValueFor("spell_lifesteal_creep") / 100
self.multiple = self:GetAbility():GetSpecialValueFor("lifesteal_active")
self.mana_active = self:GetAbility():GetSpecialValueFor("mana_active") / 100
self.mana_active_creep = self:GetAbility():GetSpecialValueFor("mana_active_creep") / 100

end

function modifier_item_bloodstone_custom:OnTakeDamage(params)
if params.unit == self:GetParent() then return end
if params.attacker ~= self:GetParent() then return end
if params.inflictor == nil then return end
if self:GetParent():IsIllusion() then return end
if not params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end
if (params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 2000 then return end

	local lifesteal = self.lifesteal
	local mana = self.mana_active

	if not params.unit:IsHero() then
		lifesteal = self.lifesteal_creep
		mana = self.mana_active_creep
	end


	if self:GetParent():HasModifier("modifier_item_bloodstone_custom_buff") then
		lifesteal = lifesteal * self.multiple	
	end

	local heal = params.damage * lifesteal
	local active_mana = params.damage * mana


	self:GetParent():Heal(heal, self:GetAbility())


	if self:GetParent():HasModifier("modifier_item_bloodstone_custom_buff") then

		self:GetParent():GiveMana(active_mana)
   		SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)
	end


	local particle = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:ReleaseParticleIndex( particle )
end

modifier_item_bloodstone_custom_buff = class({})

function modifier_item_bloodstone_custom_buff:IsPurgable() return false end
function modifier_item_bloodstone_custom_buff:IsPurgeException() return false end

function modifier_item_bloodstone_custom_buff:OnCreated()

self.reduce =  self:GetAbility():GetSpecialValueFor("mana_cost_active")

if not IsServer() then return end


local particle = ParticleManager:CreateParticle("particles/items_fx/bloodstone_heal.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)
end
function modifier_item_bloodstone_custom_buff:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MANACOST_PERCENTAGE
}
end


function modifier_item_bloodstone_custom_buff:GetModifierPercentageManacost(params)
if params.ability == nil then return end

return self.reduce
end






modifier_item_bloodstone_custom_debuff = class({})

function modifier_item_bloodstone_custom_debuff:IsPurgable() return false end
function modifier_item_bloodstone_custom_debuff:RemoveOnDeath() return false end
function modifier_item_bloodstone_custom_debuff:IsPurgeException() return false end