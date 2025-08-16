LinkLuaModifier( "modifier_bristleback_innate_custom", "abilities/bristleback/bristleback_innate_custom", LUA_MODIFIER_MOTION_NONE )


bristleback_innate_custom = class({})



function bristleback_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_bristleback_innate_custom"
end

function bristleback_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_bristleback.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_bristleback", context)
end



modifier_bristleback_innate_custom = class({})
function modifier_bristleback_innate_custom:IsHidden() return true end
function modifier_bristleback_innate_custom:IsPurgable() return false end
function modifier_bristleback_innate_custom:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.heal = self.ability:GetSpecialValueFor("heal")/100
self.creeps = self.ability:GetSpecialValueFor("creeps")
self.damage = self.ability:GetSpecialValueFor("damage")

self.back = self.parent:FindAbilityByName("bristleback_bristleback_custom")

self.parent:AddDamageEvent_out(self)
end

function modifier_bristleback_innate_custom:DamageEvent_out(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if self.parent ~= params.attacker then return end
if not params.unit:IsUnit() then return end
local unit = params.unit

if self.back and self.back:IsTrained() and self.back:IsFacingBack(unit) == true then
	local heal = params.damage*self.heal
	if unit:IsCreep() then
		heal = heal/self.creeps
	end
	self.parent:GenericHeal(heal, self.ability, true)
end

end

function modifier_bristleback_innate_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_bristleback_innate_custom:GetModifierTotalDamageOutgoing_Percentage(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if not params.target then return end
if not params.target:IsUnit() then return end

if self.back and self.back:IsTrained() and self.back:IsFacingBack(params.target) == true then
	return self.damage
end

end