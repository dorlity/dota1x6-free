
marci_innate_custom = class({})


function marci_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_marci.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_marci", context)
end


function marci_innate_custom:OnHeroLevelUp()
if not self:GetCaster():IsRealHero() then return end
if self:GetCaster():HasModifier("modifier_illusion") then return end

local level = self:GetSpecialValueFor("level")

if self:GetCaster():GetLevel() % level == 0 then 
    dota1x6:CreateUpgradeOrb(self:GetCaster(), 2)
end

end


