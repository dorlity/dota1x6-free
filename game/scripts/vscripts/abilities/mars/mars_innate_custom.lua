LinkLuaModifier( "modifier_mars_innate_custom", "abilities/mars/mars_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_innate_custom_effect", "abilities/mars/mars_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_innate_custom_cd", "abilities/mars/mars_innate_custom", LUA_MODIFIER_MOTION_NONE )


mars_innate_custom = class({})


function mars_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_mars_innate_custom"
end

function mars_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_mars.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_mars", context)
end



modifier_mars_innate_custom = class({})
function modifier_mars_innate_custom:IsHidden() return true end
function modifier_mars_innate_custom:IsPurgable() return false end
function modifier_mars_innate_custom:RemoveOnDeath() return false end
function modifier_mars_innate_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.duration = self.ability:GetSpecialValueFor("duration")
self.cd = self.ability:GetSpecialValueFor("cd")
if not IsServer() then return end 
self:StartIntervalThink(0.2)
end

function modifier_mars_innate_custom:OnIntervalThink()
if not IsServer() then return end 
if self.parent:PassivesDisabled() then return end
if self.parent:HasModifier("modifier_mars_innate_custom_cd") then return end
if self.parent:HasModifier("modifier_start_stun") then return end
if not self.parent:IsStunned() and not self.parent:IsHexed() and self.parent:GetForceAttackTarget() == nil and not self.parent:IsFeared() then return end


self.parent:AddNewModifier(self.parent, self.ability, "modifier_mars_innate_custom_cd", {duration = self.cd})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_mars_innate_custom_effect", {duration = self.duration})
end




modifier_mars_innate_custom_effect = class({})
function modifier_mars_innate_custom_effect:IsHidden() return false end
function modifier_mars_innate_custom_effect:IsPurgable() return false end
function modifier_mars_innate_custom_effect:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.PercentStr = self.ability:GetSpecialValueFor("str")/100
self.regen = self.ability:GetSpecialValueFor("regen")/self.ability:GetSpecialValueFor("duration")
if not IsServer() then return end

self.parent:EmitSound("Mars.Innate_active")
end

function modifier_mars_innate_custom_effect:OnDestroy()
if not IsServer() then return end
self.parent:PercentRefresh()
end

function modifier_mars_innate_custom_effect:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_mars_innate_custom_effect:GetModifierHealthRegenPercentage()
return self.regen
end

function modifier_mars_innate_custom_effect:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end


modifier_mars_innate_custom_cd = class({})
function modifier_mars_innate_custom_cd:IsHidden() return false end
function modifier_mars_innate_custom_cd:IsPurgable() return false end
function modifier_mars_innate_custom_cd:RemoveOnDeath() return false end
function modifier_mars_innate_custom_cd:IsDebuff() return true end
function modifier_mars_innate_custom_cd:OnCreated()
self.RemoveForDuel = true
end