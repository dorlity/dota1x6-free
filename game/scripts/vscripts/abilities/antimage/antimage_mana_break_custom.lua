LinkLuaModifier( "modifier_antimage_mana_break_custom", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_legendary", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_target_effect", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_caster_effect", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_stun_cd", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_stats", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_haste", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_break_custom_haste_target", "abilities/antimage/antimage_mana_break_custom", LUA_MODIFIER_MOTION_NONE )


antimage_mana_break_custom = class({})


function antimage_mana_break_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/am_heal_mana.vpcf", context )
PrecacheResource( "particle", "particles/ogre_hit.vpcf", context )
PrecacheResource( "particle", "particles/am_no_mana.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/death_prophet/death_prophet_ti9/death_prophet_silence_custom_ti9_overhead_model.vpcf", context )
PrecacheResource( "particle", "particles/am_break_2.vpcf", context )
PrecacheResource( "particle", "particles/am_break_legendary.vpcf", context )
PrecacheResource( "particle", "particles/am_damage.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/gleipnir_root.vpcf", context )
PrecacheResource( "particle", "particles/anti-mage/manabreak_cleave.vpcf", context )
PrecacheResource( "particle", "particles/am_heal_mana.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_manaburn.vpcf", context )
PrecacheResource( "particle", "particles/am_no_mana.vpcf", context )
PrecacheResource( "particle", "particles/am_break_2.vpcf", context )
PrecacheResource( "particle", "particles/am_break_legendary.vpcf", context )
PrecacheResource( "particle", "particles/anti-mage/nomana_haste.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_mana_leak.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf", context )

end

function antimage_mana_break_custom:GetIntrinsicModifierName()
return "modifier_antimage_mana_break_custom"
end


function antimage_mana_break_custom:GetAbilityTargetFlags()
if self:GetCaster():HasTalent("modifier_antimage_hero_8") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end

function antimage_mana_break_custom:GetAbilityTextureName()
local caster = self:GetCaster()
if caster:HasModifier("modifier_antimage_basher_1_custom_golden") or caster:HasModifier("modifier_antimage_basher_2_custom_golden") then
    return "antimage/golden_basher_blades/antimage_mana_break"
end
if caster:HasModifier("modifier_antimage_basher_1_custom") or caster:HasModifier("modifier_antimage_basher_2_custom") then
    return "antimage/the_basher_blades/antimage_mana_break"
end
return "antimage_mana_break"
end

function antimage_mana_break_custom:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_antimage_break_7") then 
	return self:GetCaster():GetTalentValue("modifier_antimage_break_7", "talent_cd")
end
return
end

function antimage_mana_break_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_antimage_break_7") then
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function antimage_mana_break_custom:GetManaK(target)
local max_mana = target:GetMaxMana()
local min_mana = target:GetMana()
local mana_k = 0

if max_mana == 0 then 
	max_mana = self:GetSpecialValueFor("nomana_max")
	min_mana = self:GetSpecialValueFor("nomana_min")
end
mana_k = min_mana/max_mana

return mana_k
end

function antimage_mana_break_custom:OnSpellStart()
local caster = self:GetCaster()
caster:EmitSound("Antimage.Break_legendary")
caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, 1.3)

caster:Purge(false, true, false, false, false)
caster:AddNewModifier(caster, self, "modifier_antimage_mana_break_custom_legendary", {duration = caster:GetTalentValue("modifier_antimage_break_7", "duration")})
end




modifier_antimage_mana_break_custom = class(mod_hidden)
function modifier_antimage_mana_break_custom:OnCreated( kv )

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.nomana_max = self.ability:GetSpecialValueFor("nomana_max")
self.nomana_min = self.ability:GetSpecialValueFor("nomana_min")

self.percent_damage_per_burn = self.ability:GetSpecialValueFor("percent_damage_per_burn")
self.creeps_bonus = self.ability:GetSpecialValueFor("creeps_bonus")

self.mana_illusion = self.ability:GetSpecialValueFor("illusion_burn")
self.mana_flat = self.ability:GetSpecialValueFor("mana_per_hit")
self.mana_pct = self.ability:GetSpecialValueFor("mana_per_hit_pct")

self.stats_init = self.parent:GetTalentValue("modifier_antimage_hero_3", "stats_init")
self.stats_inc = self.parent:GetTalentValue("modifier_antimage_hero_3", "stats_inc")
self.stats_duration = self.parent:GetTalentValue("modifier_antimage_hero_3", "duration", true)

self.range_bonus = self.parent:GetTalentValue("modifier_antimage_break_3", "range")

self.armor_duration = self.parent:GetTalentValue("modifier_antimage_break_1", "duration", true)

self.haste_radius = self.parent:GetTalentValue("modifier_antimage_hero_8", "radius", true)
self.haste_mana = self.parent:GetTalentValue("modifier_antimage_hero_8", "mana", true)
self.haste_duration = self.parent:GetTalentValue("modifier_antimage_hero_8", "duration", true)

if self.parent:IsRealHero() then
	self.lifesteal = self.parent:GetTalentValue("modifier_antimage_hero_2", "heal")/100
	self.heal_bonus = self.parent:GetTalentValue("modifier_antimage_hero_2", "bonus", true)
	self.heal_mana = self.parent:GetTalentValue("modifier_antimage_hero_2", "mana", true)
	self.heal_creeps = self.parent:GetTalentValue("modifier_antimage_hero_2", "creeps", true)

	self.mana_bonus = self.parent:GetTalentValue("modifier_antimage_break_2", "mana")
	self.cleave_damage = self.parent:GetTalentValue("modifier_antimage_break_2", "cleave")/100

	self.low_mana = self.parent:GetTalentValue("modifier_antimage_break_4", "mana", true)
	self.stun_duration = self.parent:GetTalentValue("modifier_antimage_break_4", "stun", true)
	self.stun_cd = self.parent:GetTalentValue("modifier_antimage_break_4", "talent_cd", true)
end

self.particle_mana_burn = "particles/generic_gameplay/generic_manaburn.vpcf"
if self.parent:HasModifier("modifier_antimage_basher_1_custom") or self.parent:HasModifier("modifier_antimage_basher_2_custom") then
    self.particle_mana_burn = "particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf"
end
if self.parent:HasModifier("modifier_antimage_basher_1_custom_golden") or self.parent:HasModifier("modifier_antimage_basher_2_custom_golden") then
    self.particle_mana_burn = "particles/econ/items/antimage/antimage_weapon_basher_ti5_gold/am_manaburn_basher_ti_5_gold.vpcf"
end

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_antimage_mana_break_custom:OnRefresh( kv )
self.mana_flat = self.ability:GetSpecialValueFor("mana_per_hit")
self.mana_pct = self.ability:GetSpecialValueFor("mana_per_hit_pct")
end



function modifier_antimage_mana_break_custom:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_antimage_hero_3" or self.parent:HasTalent("modifier_antimage_hero_3") then
	self.stats_init = self.parent:GetTalentValue("modifier_antimage_hero_3", "stats_init")
	self.stats_inc = self.parent:GetTalentValue("modifier_antimage_hero_3", "stats_inc")
	self.parent:AddAttackEvent_inc(self, true)

	self.parent:CalculateStatBonus(true)
end

if name == "modifier_antimage_hero_2" or self.parent:HasTalent("modifier_antimage_hero_2") then
	self.lifesteal = self.parent:GetTalentValue("modifier_antimage_hero_2", "heal")/100
	self.parent:AddDamageEvent_out(self, true)
end

if name == "modifier_antimage_break_1" or self.parent:HasTalent("modifier_antimage_break_1") then
	self.parent:AddAttackRecordEvent_out(self)
end

if name == "modifier_antimage_break_7" or self.parent:HasTalent("modifier_antimage_break_7") then
	self.parent:AddAttackRecordEvent_out(self)
end

if name == "modifier_antimage_break_3" or self.parent:HasTalent("modifier_antimage_break_3") then
	self.parent:AddAttackRecordEvent_out(self)
	self.range_bonus = self.parent:GetTalentValue("modifier_antimage_break_3", "range")
end

if name == "modifier_antimage_hero_8" or self.parent:HasTalent("modifier_antimage_hero_8") then
	local interval = self.parent:IsRealHero() and 0.5 or 1
	self:OnIntervalThink()
	self:StartIntervalThink(interval)
end

if name == "modifier_antimage_break_2" or self.parent:HasTalent("modifier_antimage_break_2") then
	self.mana_bonus = self.parent:GetTalentValue("modifier_antimage_break_2", "mana")
	self.cleave_damage = self.parent:GetTalentValue("modifier_antimage_break_2", "cleave")/100
end

self:SendBuffRefreshToClients()
end


function modifier_antimage_mana_break_custom:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsAlive() then return end
if not self.parent:HasTalent("modifier_antimage_hero_8") then return end

for _,target in pairs(self.parent:FindTargets(self.haste_radius)) do
	if target:GetMaxMana() > 0 and target:GetManaPercent() <= self.haste_mana then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_antimage_mana_break_custom_haste", {duration = self.haste_duration})
		target:AddNewModifier(self.parent, self.ability, "modifier_antimage_mana_break_custom_haste_target", {duration = self.haste_duration})
	end
end

end


function modifier_antimage_mana_break_custom:AddCustomTransmitterData() 
return 
{
  range_bonus = self.range_bonus,
  stats_init = self.stats_init,
  stats_inc = self.stats_inc,
} 
end

function modifier_antimage_mana_break_custom:HandleCustomTransmitterData(data)
self.range_bonus = data.range_bonus
self.stats_init = data.stats_init
self.stats_inc = data.stats_inc
end


function modifier_antimage_mana_break_custom:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_antimage_hero_2") then return end
if not self.parent:CheckLifesteal(params) then return end

local target = params.unit
local mana_k = self.ability:GetManaK(target)
local heal = self.lifesteal*params.damage
local effect = ""

heal = target:IsCreep() and heal/self.heal_creeps or heal

if mana_k <= 0.5 then
	if not params.inflictor then
		effect = nil
	end
	heal = heal*self.heal_bonus
end

self.parent:GenericHeal(heal, self.ability, true, effect, "modifier_antimage_hero_2")
end


function modifier_antimage_mana_break_custom:AttackEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.target then return end
if not self.parent:HasTalent("modifier_antimage_hero_3") then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_antimage_mana_break_custom_stats", {duration = self.stats_duration})
end

function modifier_antimage_mana_break_custom:AttackRecordEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local target = params.target
local mana_k = self.ability:GetManaK(target)

if self.parent:HasTalent("modifier_antimage_break_1") or self.parent:HasTalent("modifier_antimage_break_3") then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_antimage_mana_break_custom_caster_effect", {mana_k = mana_k, duration = self.armor_duration})
end

local mod = self.parent:FindModifierByName("modifier_antimage_mana_break_custom_legendary")
if mod then
	mod:SetStack(mana_k)
end

end

function modifier_antimage_mana_break_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end

function modifier_antimage_mana_break_custom:GetModifierAttackRangeBonus()
return self.range_bonus
end

function modifier_antimage_mana_break_custom:GetModifierBonusStats_Strength()
return self.stats_init + self.stats_inc*self.parent:GetUpgradeStack("modifier_antimage_mana_break_custom_stats")
end

function modifier_antimage_mana_break_custom:GetModifierBonusStats_Agility()
return self.stats_init + self.stats_inc*self.parent:GetUpgradeStack("modifier_antimage_mana_break_custom_stats")
end

function modifier_antimage_mana_break_custom:GetModifierProcAttack_BonusDamage_Physical( params )
if not IsServer() then return end
local target = params.target

if not target then return end
if not target:IsUnit() then return end

local mana_k = self.ability:GetManaK(target)

if self.parent:HasModifier("modifier_antimage_mana_break_custom_legendary") then 
	target:EmitSound("Antimage.Break_legendary_hit")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(particle)
end

if self.parent:PassivesDisabled() then return end

local legendary_mod = self.parent:FindModifierByName("modifier_antimage_mana_void_custom_illusion")
local max_mana = target:GetMaxMana()
local min_mana = target:GetMana()
if max_mana == 0 then 
	max_mana = self.nomana_max
	min_mana = self.nomana_min
end

local bkb_ability = self.parent:BkbAbility(self.ability, self.parent:HasTalent("modifier_antimage_hero_8"))

local mana_burn = self.parent:IsIllusion() and self.mana_illusion or (self.mana_flat + (max_mana / 100 * (self.mana_pct + self.mana_bonus)))
mana_burn = math.min( min_mana, mana_burn )

if self.parent:GetQuest() == "Anti.Quest_5" and params.target:IsRealHero() and not self.parent:QuestCompleted() and not target:HasModifier("modifier_huskar_blood_magic") then 
	self.parent:UpdateQuest(math.floor(mana_burn))
end

if not legendary_mod then
	local real_mana = target:Script_ReduceMana(mana_burn, bkb_ability) 

	if self.parent:HasShard() then
		local ability = self.parent:FindAbilityByName("antimage_counterspell_custom")
		if ability then
			ability:ShardMana(real_mana)
		end
	end
end

target:GenericParticle(self.particle_mana_burn)

if self.parent:HasTalent("modifier_antimage_break_1") or self.parent:HasTalent("modifier_antimage_break_4") then 
	target:AddNewModifier(self.parent, bkb_ability, "modifier_antimage_mana_break_custom_target_effect", {mana_k = mana_k, duration = self.armor_duration})
end

if self.parent:HasTalent("modifier_antimage_break_2") then
	DoCleaveAttack( self.parent, target, self.ability, self.cleave_damage*params.damage, 150, 360, 500, "particles/anti-mage/manabreak_cleave.vpcf" )
end

mana_k = self.ability:GetManaK(target)
local sound = "Hero_Antimage.ManaBreak"
if mana_k <= 0.5 and target:GetMaxMana() ~= 0 then 
	sound = "Antimage.Low_mana"
end

if self.parent:HasTalent("modifier_antimage_break_4") and mana_k <= self.low_mana/100  and not target:HasModifier("modifier_antimage_mana_break_custom_stun_cd") then

	target:AddNewModifier(self.parent, self.parent:BkbAbility(self.ability, true), "modifier_bashed", {duration = self.stun_duration*(1 - target:GetStatusResistance())})
	target:AddNewModifier(self.parent, self.ability, "modifier_antimage_mana_break_custom_stun_cd", {duration = self.stun_cd})

	target:EmitSound("Antimage.Break_stun")
	sound = "Antimage.Break_stun2"
    local immortal_particle = ParticleManager:CreateParticle("particles/am_no_mana.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(immortal_particle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(immortal_particle, 1, self.parent:GetAbsOrigin() )
    ParticleManager:Delete(immortal_particle, 1)
end

target:EmitSound(sound)

if legendary_mod then
	legendary_mod:ManaBurn(target)
	return
end

if target:IsDebuffImmune() and not self.parent:HasTalent("modifier_antimage_hero_8") then return end

local damage_bonus = target:IsCreep() and self.creeps_bonus*self.percent_damage_per_burn or self.percent_damage_per_burn
return mana_burn * damage_bonus
end



modifier_antimage_mana_break_custom_target_effect = class(mod_hidden)
function modifier_antimage_mana_break_custom_target_effect:IsHidden() return true end
function modifier_antimage_mana_break_custom_target_effect:IsPurgable() return false end
function modifier_antimage_mana_break_custom_target_effect:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.armor = self.caster:GetTalentValue("modifier_antimage_break_1", "armor")

self.heal_mana = self.caster:GetTalentValue("modifier_antimage_break_4", "mana", true)
self.heal_reduce = self.caster:GetTalentValue("modifier_antimage_break_4", "heal_reduce")

if not IsServer() then return end
self:SetStackCount(table.mana_k*100)
end 

function modifier_antimage_mana_break_custom_target_effect:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(table.mana_k*100)
end

function modifier_antimage_mana_break_custom_target_effect:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_antimage_mana_break_custom_target_effect:GetModifierPhysicalArmorBonus()
return self.armor*(1 - self:GetStackCount()/100)
end

function modifier_antimage_mana_break_custom_target_effect:GetModifierLifestealRegenAmplify_Percentage() 
return self:GetStackCount() <= self.heal_mana and self.heal_reduce or 0
end

function modifier_antimage_mana_break_custom_target_effect:GetModifierHealAmplify_PercentageTarget() 
return self:GetStackCount() <= self.heal_mana and self.heal_reduce or 0
end

function modifier_antimage_mana_break_custom_target_effect:GetModifierHPRegenAmplify_Percentage() 
return self:GetStackCount() <= self.heal_mana and self.heal_reduce or 0
end





modifier_antimage_mana_break_custom_legendary = class({})
function modifier_antimage_mana_break_custom_legendary:IsHidden() return false end
function modifier_antimage_mana_break_custom_legendary:IsPurgable() return false end
function modifier_antimage_mana_break_custom_legendary:OnCreated(table)
self.parent = self:GetParent()

self.damage = self.parent:GetTalentValue("modifier_antimage_break_7", "damage")

if not IsServer() then return end
self.parent:Purge(false, true, false, false, false)
self.parent:GenericParticle("particles/am_break_2.vpcf", self)
self.parent:GenericParticle("particles/am_break_legendary.vpcf", self)

self.max_time = self:GetRemainingTime()

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_antimage_mana_break_custom_legendary:OnIntervalThink()
if not IsServer() then return end
self.parent:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = "+"..self:GetStackCount().."%", style = "AntimageManabreak"})
end

function modifier_antimage_mana_break_custom_legendary:SetStack(stack)
if not IsServer() then return end
self:SetStackCount(self.damage*(1 - stack))
end

function modifier_antimage_mana_break_custom_legendary:OnDestroy()
if not IsServer() then return end
self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "AntimageManabreak"})
end

function modifier_antimage_mana_break_custom_legendary:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MODEL_SCALE,
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_antimage_mana_break_custom_legendary:GetModifierModelScale()
return 15
end

function modifier_antimage_mana_break_custom_legendary:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount()
end


modifier_antimage_mana_break_custom_caster_effect = class(mod_visible)
function modifier_antimage_mana_break_custom_caster_effect:GetTexture() return "buffs/antimage/manabreak_3" end
function modifier_antimage_mana_break_custom_caster_effect:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.armor = self.parent:GetTalentValue("modifier_antimage_break_1", "armor")*-1
self.speed = self.parent:GetTalentValue("modifier_antimage_break_3", "speed")

if not IsServer() then return end
self:SetStackCount(table.mana_k*100)
end 


function modifier_antimage_mana_break_custom_caster_effect:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(table.mana_k*100)
end

function modifier_antimage_mana_break_custom_caster_effect:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_antimage_mana_break_custom_caster_effect:GetModifierPhysicalArmorBonus()
return self.armor*(1 - self:GetStackCount()/100)
end

function modifier_antimage_mana_break_custom_caster_effect:GetModifierAttackSpeedBonus_Constant()
return self.speed*(1 - self:GetStackCount()/100)
end



modifier_antimage_mana_break_custom_stun_cd = class(mod_hidden)
function modifier_antimage_mana_break_custom_stun_cd:OnCreated()
self.RemoveForDuel = true
end



modifier_antimage_mana_break_custom_stats = class(mod_visible)
function modifier_antimage_mana_break_custom_stats:GetTexture() return "buffs/antimage/hero_3" end
function modifier_antimage_mana_break_custom_stats:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_antimage_hero_3", "max")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_antimage_mana_break_custom_stats:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end


function modifier_antimage_mana_break_custom_stats:OnStackCountChanged(iStackCount)
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end


modifier_antimage_mana_break_custom_haste = class(mod_visible)
function modifier_antimage_mana_break_custom_haste:GetTexture() return "buffs/antimage/hero_8" end
function modifier_antimage_mana_break_custom_haste:OnCreated()
self.parent = self:GetParent()
self.move = self.parent:GetTalentValue("modifier_antimage_hero_8", "move")

self.activity = "haste"

if self.parent:HasModifier("modifier_antimage_persona_custom_1") or self.parent:HasModifier("modifier_antimage_persona_custom_2") or self.parent:HasModifier("modifier_antimage_persona_custom_3") or self.parent:HasModifier("modifier_antimage_persona_custom_4") or self.parent:HasModifier("modifier_antimage_persona_custom_5") or self.parent:HasModifier("modifier_antimage_persona_custom_6") then
    self.activity = "chase"
end
if not IsServer() then return end
self.parent:GenericParticle("particles/anti-mage/nomana_haste.vpcf", self)
end

function modifier_antimage_mana_break_custom_haste:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_antimage_mana_break_custom_haste:GetActivityTranslationModifiers()
return self.activity
end

function modifier_antimage_mana_break_custom_haste:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_antimage_mana_break_custom_haste:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end

function modifier_antimage_mana_break_custom_haste:GetStatusEffectName()
return "particles/units/heroes/hero_kez/status_effect_kez_afterimage_buff.vpcf"
end
 
function modifier_antimage_mana_break_custom_haste:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH
end


modifier_antimage_mana_break_custom_haste_target = class(mod_hidden)
function modifier_antimage_mana_break_custom_haste_target:GetEffectName()
return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_mana_leak.vpcf"
end

function modifier_antimage_mana_break_custom_haste_target:OnCreated()
self.parent = self:GetParent()

if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(1)
end


function modifier_antimage_mana_break_custom_haste_target:OnIntervalThink()
if not IsServer() then return end
self.parent:GenericParticle("particles/units/heroes/hero_keeper_of_the_light/keeper_mana_leak.vpcf")
end


