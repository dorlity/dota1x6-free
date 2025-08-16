LinkLuaModifier( "modifier_tinker_innate_custom", "abilities/tinker/tinker_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_innate_custom_scepter", "abilities/tinker/tinker_innate_custom", LUA_MODIFIER_MOTION_NONE )


tinker_innate_custom = class({})


function tinker_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "soundfile", "soundevents/npc_dota_hero_tinker.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_tinker", context)
end


function tinker_innate_custom:GetIntrinsicModifierName()
return "modifier_tinker_innate_custom"
end


modifier_tinker_innate_custom = class(mod_hidden)
function modifier_tinker_innate_custom:OnCreated(params)
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.int_per_cdr = self.ability:GetSpecialValueFor("int_per_one_cdr")
self.max_cdr = self.ability:GetSpecialValueFor("max_cdr")

if not IsServer() then return end
self:StartIntervalThink(0.5)
end

function modifier_tinker_innate_custom:OnRefresh(params)
self.int_per_cdr = self.ability:GetSpecialValueFor("int_per_one_cdr")
self.max_cdr = self.ability:GetSpecialValueFor("max_cdr")
end

function modifier_tinker_innate_custom:OnIntervalThink()
if not IsServer() then return end

local intelligence = self.parent:GetIntellect(false)
local cdr = intelligence / self.int_per_cdr

self:SetStackCount(math.min(cdr, self.max_cdr))
end

function modifier_tinker_innate_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end

function modifier_tinker_innate_custom:GetModifierPercentageCooldown(params)
if self.parent:PassivesDisabled() then return end
if not params.ability or not params.ability:IsItem() then return end

return self:GetStackCount()
end



modifier_tinker_innate_custom_scepter = class(mod_visible)
function modifier_tinker_innate_custom_scepter:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.root_duration = self.ability:GetSpecialValueFor("scepter_root")

if not IsServer() then return end
self.parent:GenericParticle("particles/generic_gameplay/rune_arcane_owner.vpcf", self)
end

function modifier_tinker_innate_custom_scepter:Proc()
if not IsServer() then return end
self.parent:EmitSound("Tinker.Scepter_proc")
self.parent:GenericParticle("particles/tinker/scepter_proc.vpcf")
self:Destroy()
end