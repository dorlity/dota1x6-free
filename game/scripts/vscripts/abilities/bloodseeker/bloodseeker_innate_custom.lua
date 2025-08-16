LinkLuaModifier( "modifier_bloodseeker_sanguivore_custom", "abilities/bloodseeker/bloodseeker_innate_custom", LUA_MODIFIER_MOTION_NONE )


bloodseeker_innate_custom = class({})


function bloodseeker_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_bloodseeker_sanguivore_custom"
end


function bloodseeker_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_bloodseeker.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_bloodseeker", context)
end



modifier_bloodseeker_sanguivore_custom = class({})
function modifier_bloodseeker_sanguivore_custom:IsHidden() return true end
function modifier_bloodseeker_sanguivore_custom:IsPurgable() return false end
function modifier_bloodseeker_sanguivore_custom:RemoveOnDeath() return false end
function modifier_bloodseeker_sanguivore_custom:OnCreated(table)
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.ability = self:GetAbility()

self.base_heal = self.ability:GetSpecialValueFor("base_heal")
self.heal_pct = self.ability:GetSpecialValueFor("heal_pct")/100
self.culling = self.ability:GetSpecialValueFor("culling")

end



function modifier_bloodseeker_sanguivore_custom:DeathEvent(params)
if not IsServer() then return end 
if self.parent:PassivesDisabled() then return end
if not params.attacker then return end
if params.attacker ~= self.parent then return end
if not params.unit:IsUnit() then return end
if params.unit:IsIllusion() then return end

local heal = self.base_heal + params.unit:GetMaxHealth()*self.heal_pct*self.parent:GetLevel()

self.parent:GenericHeal(heal, self.ability,false, "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf")
end
