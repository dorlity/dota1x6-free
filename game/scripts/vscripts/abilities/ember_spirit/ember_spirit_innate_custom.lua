LinkLuaModifier( "modifier_ember_spirit_innate_custom", "abilities/ember_spirit/ember_spirit_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ember_spirit_innate_custom_burn", "abilities/ember_spirit/ember_spirit_innate_custom", LUA_MODIFIER_MOTION_NONE )


ember_spirit_innate_custom = class({})

function ember_spirit_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_smolder.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_fire_immolation_child.vpcf", context )
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_ember_spirit.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_ember_spirit", context)
end


function ember_spirit_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_ember_spirit_innate_custom"
end



modifier_ember_spirit_innate_custom = class({})
function modifier_ember_spirit_innate_custom:IsHidden() return true end
function modifier_ember_spirit_innate_custom:IsPurgable() return false end
function modifier_ember_spirit_innate_custom:RemoveOnDeath() return false end
function modifier_ember_spirit_innate_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")
if not IsServer() then return end
self.parent:GenericParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_smolder.vpcf", self)
end

function modifier_ember_spirit_innate_custom:IsAura() return not self.parent:PassivesDisabled() end
function modifier_ember_spirit_innate_custom:GetAuraDuration() return 0.1 end
function modifier_ember_spirit_innate_custom:GetAuraRadius() return self.radius end
function modifier_ember_spirit_innate_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_ember_spirit_innate_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_ember_spirit_innate_custom:GetModifierAura() return "modifier_ember_spirit_innate_custom_burn" end




modifier_ember_spirit_innate_custom_burn = class({})
function modifier_ember_spirit_innate_custom_burn:IsHidden() return true end
function modifier_ember_spirit_innate_custom_burn:IsPurgable() return false end
function modifier_ember_spirit_innate_custom_burn:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.interval = self.ability:GetSpecialValueFor("interval")
self.damage = (self.ability:GetSpecialValueFor("damage") + self.caster:GetTalentValue("modifier_ember_guard_3", "passive")) *self.interval
if not IsServer() then return end

self.particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_fire_immolation_child.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.particle_index, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle_index, 1, self.caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
self:AddParticle(self.particle_index, false, false, -1, false, false ) 

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage}
self:StartIntervalThink(self.interval)
end

function modifier_ember_spirit_innate_custom_burn:OnIntervalThink()
if not IsServer() then return end

DoDamage(self.damageTable)
end

function modifier_ember_spirit_innate_custom_burn:GetStatusEffectName()
return "particles/status_fx/status_effect_burn.vpcf"
end


function modifier_ember_spirit_innate_custom_burn:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end