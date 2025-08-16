LinkLuaModifier( "modifier_leshrac_defilement_custom", "abilities/leshrac/leshrac_innate_custom", LUA_MODIFIER_MOTION_NONE )


leshrac_innate_custom = class({})


function leshrac_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_leshrac_defilement_custom"
end

function leshrac_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_leshrac.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_leshrac", context)
end


modifier_leshrac_defilement_custom = class({})
function modifier_leshrac_defilement_custom:IsHidden() return true end
function modifier_leshrac_defilement_custom:IsPurgable() return false end
function modifier_leshrac_defilement_custom:RemoveOnDeath() return false end
function modifier_leshrac_defilement_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")
if not IsServer() then return end 
self:StartIntervalThink(0.5)
end

function modifier_leshrac_defilement_custom:OnIntervalThink()
if not IsServer() then return end 

local bonus = self.radius*self.parent:GetIntellect(false)

if self.parent:HasTalent("modifier_leshrac_nova_3") then 
    bonus = bonus * (1 + self.parent:GetTalentValue("modifier_leshrac_nova_3", "radius")/100)
end

self:SetStackCount(bonus)
end

