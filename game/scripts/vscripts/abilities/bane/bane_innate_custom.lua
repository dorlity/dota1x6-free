LinkLuaModifier( "modifier_bane_innate_custom", "abilities/bane/bane_innate_custom", LUA_MODIFIER_MOTION_NONE )


bane_innate_custom = class({})


function bane_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "soundfile", "soundevents/npc_dota_hero_bane.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_bane", context)
end


function bane_innate_custom:GetIntrinsicModifierName()
return "modifier_bane_innate_custom"
end



modifier_bane_innate_custom = class({})
function modifier_bane_innate_custom:IsHidden() return true end
function modifier_bane_innate_custom:IsPurgable() return false end
function modifier_bane_innate_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage = self.ability:GetSpecialValueFor("damage")

if not IsServer() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_bane_ichor_of_nyctasha", {})
end

function modifier_bane_innate_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_bane_innate_custom:GetModifierTotalDamageOutgoing_Percentage(params)
if not IsServer() then return end
if not params.target then return end
if not params.target:IsCreep() then return end

return self.damage
end