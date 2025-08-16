LinkLuaModifier( "modifier_life_stealer_ursa_clap_slow", "abilities/life_stealer/infest_creeps_ursa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ursa_overpower", "abilities/life_stealer/infest_creeps_ursa", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_ursa_crit", "abilities/life_stealer/infest_creeps_ursa", LUA_MODIFIER_MOTION_NONE )

life_stealer_ursa_clap = class({})

function life_stealer_ursa_clap:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf", context )
end

function life_stealer_ursa_clap:GetCastRange(vector, hTarget)
return self:GetSpecialValueFor("aoe")
end

function life_stealer_ursa_clap:OnAbilityPhaseStart()
local caster = self:GetCaster()
caster:EmitSound("n_creep_Ursa.Clap")

caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1.3)
return true
end

function life_stealer_ursa_clap:OnAbilityPhaseInterrupted()
self:GetCaster():StopSound("n_creep_Ursa.Clap")
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end


function life_stealer_ursa_clap:OnSpellStart()
local caster = self:GetCaster()

local owner = caster.owner
local bonus_duration = owner and owner:GetTalentValue("modifier_lifestealer_infest_3", "duration") or 0

local duration = self:GetSpecialValueFor("duration")
local radius = self:GetSpecialValueFor("aoe")
local damage = self:GetSpecialValueFor("damage")

local trail_pfx = ParticleManager:CreateParticle("particles/neutral_fx/ursa_thunderclap.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl(trail_pfx, 1, Vector(radius, radius, radius))
ParticleManager:ReleaseParticleIndex(trail_pfx) 

local damageTable = {attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self }

for _,target in pairs(caster:FindTargets(radius)) do
	target:RemoveModifierByName("modifier_life_stealer_ursa_clap_slow")
	target:AddNewModifier(caster, self, "modifier_life_stealer_ursa_clap_slow", { duration = duration })
	damageTable.victim = target
	DoDamage(damageTable)

	if owner and owner:HasTalent("modifier_lifestealer_infest_3") then
		target:AddNewModifier(owner, self, "modifier_life_stealer_infest_custom_legendary_bonus", {duration = bonus_duration})
	end
end
      
end


modifier_life_stealer_ursa_clap_slow = class({})
function modifier_life_stealer_ursa_clap_slow:IsPurgable() return true end
function modifier_life_stealer_ursa_clap_slow:IsHidden() return false end
function modifier_life_stealer_ursa_clap_slow:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_life_stealer_ursa_clap_slow:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.slow = self.ability:GetSpecialValueFor("slow")
if not IsServer() then return end
self.armor = math.min(0, self.ability:GetSpecialValueFor("armor")*self.parent:GetPhysicalArmorValue(false)/100)
local mod = self.parent:FindModifierByName("modifier_life_stealer_infest_custom_legendary_bonus")

local owner = self.caster.owner
if owner and mod then
	local bonus = owner:GetTalentValue("modifier_lifestealer_infest_3", "bonus")/100
	self.armor = self.armor*(1 + bonus*mod:GetStackCount())
end

self.parent:GenericParticle("particles/general/generic_armor_reduction.vpcf", self, true)
self:SetHasCustomTransmitterData(true)
self:SendBuffRefreshToClients()
end

function modifier_life_stealer_ursa_clap_slow:AddCustomTransmitterData() 
return 
{
  armor = self.armor,
} 
end

function modifier_life_stealer_ursa_clap_slow:HandleCustomTransmitterData(data)
self.armor = data.armor
end

function modifier_life_stealer_ursa_clap_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_life_stealer_ursa_clap_slow:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_life_stealer_ursa_clap_slow:GetEffectName()
return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_life_stealer_ursa_clap_slow:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_life_stealer_ursa_clap_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_life_stealer_ursa_clap_slow:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL
end






life_stealer_ursa_overpower = class({})

function life_stealer_ursa_overpower:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf", context )
end


function life_stealer_ursa_overpower:OnSpellStart()
local caster = self:GetCaster()
local owner = caster.owner
local duration = self:GetSpecialValueFor("duration")
if owner and owner:HasTalent("modifier_lifestealer_hero_8") then
	duration = duration * (1 + owner:GetTalentValue("modifier_lifestealer_hero_8", "duration")/100)
end

caster:EmitSound("Lifestealer.Infest_ursa_overpower")
caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
print(duration)
caster:RemoveModifierByName("modifier_life_stealer_infest_custom_legendary_creep_status")
caster:AddNewModifier(caster, self, "modifier_life_stealer_ursa_overpower", {duration = duration})
end


modifier_life_stealer_ursa_overpower = class(mod_visible)
function modifier_life_stealer_ursa_overpower:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.move = self.ability:GetSpecialValueFor("move")
self.speed = self.ability:GetSpecialValueFor("speed")

if not IsServer() then return end

local ursa_overpower_buff_particle_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(ursa_overpower_buff_particle_fx, false, false, -1, false, false)
end

function modifier_life_stealer_ursa_overpower:OnDestroy()
if not IsServer() then return end
self.parent:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_infest_custom_legendary_creep_status", {})
end

function modifier_life_stealer_ursa_overpower:CheckState()
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_life_stealer_ursa_overpower:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_life_stealer_ursa_overpower:GetModifierMoveSpeedBonus_Constant()
return self.move
end

function modifier_life_stealer_ursa_overpower:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_life_stealer_ursa_overpower:GetStatusEffectName()
return "particles/status_fx/status_effect_overpower.vpcf"
end

function modifier_life_stealer_ursa_overpower:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA
end




life_stealer_ursa_crit = class({})

function life_stealer_ursa_crit:GetIntrinsicModifierName()
return "modifier_life_stealer_ursa_crit"
end

modifier_life_stealer_ursa_crit = class(mod_hidden)
function modifier_life_stealer_ursa_crit:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.chance = self.ability:GetSpecialValueFor("chance")
self.crit = self.ability:GetSpecialValueFor("damage")
self.cd_inc = self.ability:GetSpecialValueFor("cd_inc")
self.record = nil
end

function modifier_life_stealer_ursa_crit:OnRefresh(table)
self.crit = self.ability:GetSpecialValueFor("damage")
end

function modifier_life_stealer_ursa_crit:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
}
end

function modifier_life_stealer_ursa_crit:GetCritDamage() 
return self.crit
end

function modifier_life_stealer_ursa_crit:GetModifierPreAttack_CriticalStrike(params)
if not params.target:IsUnit() then return end
if self.parent:PassivesDisabled() then return end

if not RollPseudoRandomPercentage(self.chance, 3520, self.parent) then return end
self.record = params.record
return self.crit
end


function modifier_life_stealer_ursa_crit:GetModifierProcAttack_Feedback(params)
if not self.record or not params.record then return end
if self.record ~= params.record then return end

local overpower = self.parent:FindAbilityByName("life_stealer_ursa_overpower")
if overpower then
	self.parent:CdAbility(overpower, self.cd_inc)
end

params.target:EmitSound("DOTA_Item.Daedelus.Crit")
end