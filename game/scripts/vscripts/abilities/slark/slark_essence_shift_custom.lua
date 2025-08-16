LinkLuaModifier("modifier_slark_essence_shift_custom_tracker", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_caster", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_target", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_perma", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_legendary_steal", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_legendary_target", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_legendary_debuff", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_double", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_double_attack", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_double_cd", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_double_slow", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_stun_cd", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_essence_shift_custom_slow", "abilities/slark/slark_essence_shift_custom", LUA_MODIFIER_MOTION_NONE)


slark_essence_shift_custom = class({})

function slark_essence_shift_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_slark_essence_shift_custom_tracker"
end

function slark_essence_shift_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_essence_shift.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_legendary_cast.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_legendary_cast_head.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_cast_chains.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_legendary_proc.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_double.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_double_hit.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_legendary_effect.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_fish_bait_slow.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_legendary_effect_start.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_legendary_proc_water.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_stun.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_cleave.vpcf", context )
PrecacheResource( "particle","particles/slark/essence_resist.vpcf", context )
end

function slark_essence_shift_custom:GetCastRange(vLocation, hTarget)
if not self:GetCaster():HasTalent("modifier_slark_essence_7") then return end
return self:GetCaster():GetTalentValue("modifier_slark_essence_7", "range")
end

function slark_essence_shift_custom:GetCooldown(level)
if not self:GetCaster():HasTalent("modifier_slark_essence_7") then return end
return self:GetCaster():GetTalentValue("modifier_slark_essence_7", "cd")
end

function slark_essence_shift_custom:GetCastAnimation()
if self:GetCaster():HasTalent("modifier_slark_essence_7") then
	return ACT_DOTA_CAST_ABILITY_4
else
	return 0
end

end


function slark_essence_shift_custom:AddStack(target, override_duration)
if not target:IsHero() then return end
if not target:IsAlive() then return end

local duration = self:GetSpecialValueFor("duration")
local caster = self:GetCaster()
local name = "modifier_slark_essence_shift_custom_target"

if override_duration then
	duration = self:GetSpecialValueFor("duration_creeps")
end

if target:GetTeamNumber() == caster:GetTeamNumber() then
	name = "modifier_slark_essence_shift_custom_caster"
end

target:AddNewModifier(caster, self, name, {duration = duration})
end


function slark_essence_shift_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_slark_essence_7") then
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function slark_essence_shift_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

self:EndCd()
target:AddNewModifier(caster, self, "modifier_slark_essence_shift_custom_legendary_target", {duration = caster:GetTalentValue("modifier_slark_essence_7", "duration")})
end






modifier_slark_essence_shift_custom_tracker = class({})
function modifier_slark_essence_shift_custom_tracker:IsHidden() return true end
function modifier_slark_essence_shift_custom_tracker:IsPurgable() return false end
function modifier_slark_essence_shift_custom_tracker:OnCreated(table)

self.parent = self:GetParent()
self.parent:AddDeathEvent(self)
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("steal_radius")
self.max = self.ability:GetSpecialValueFor("steal_max")
self.parent:AddAttackEvent_out(self)
self.parent:AddSpellStartEvent(self)
self.parent:AddSpellEvent(self)

self.legendary_cdr = self.parent:GetTalentValue("modifier_slark_essence_7", "cdr", true)

self.double_delay = self.parent:GetTalentValue("modifier_slark_essence_4", "delay", true)
self.double_slow = self.parent:GetTalentValue("modifier_slark_essence_4", "duration", true)
self.double_cd = self.parent:GetTalentValue("modifier_slark_essence_4", "cd_inc", true)

self.stun_cd = self.parent:GetTalentValue("modifier_slark_essence_6", "cd", true)
self.stun_stack = self.parent:GetTalentValue("modifier_slark_essence_6", "stack", true)
self.stun_duration = self.parent:GetTalentValue("modifier_slark_essence_6", "stun", true)

self.slow_duration = self.parent:GetTalentValue("modifier_slark_essence_2", "duration", true)


self.spells = 
{
	["custom_juggernaut_blade_dance"] = true,
	["custom_phantom_assassin_coup_de_grace"] = true,
	["custom_huskar_berserkers_blood"] = true,
	["nevermore_frenzy_custom"] = true,
	["custom_legion_commander_overwhelming_odds"] = true,
	["custom_queenofpain_blink"] = true,
	["custom_terrorblade_metamorphosis"] = true,
	["bristleback_viscous_nasal_goo_custom"] = true,
	["custom_puck_waning_rift"] = true,
	["void_spirit_aether_remnant_custom"] = true,
	["ember_spirit_searing_chains_custom"] = true,
	["custom_pudge_meat_hook"] = true,
	["hoodwink_scurry_custom"] = true,
	["skeleton_king_mortal_strike_custom"] = true,
	["lina_fiery_soul_custom"] = true,
	["troll_warlord_fervor_custom"] = true,
	["axe_berserkers_call_custom"] = true,
	["alchemist_corrosive_weaponry_custom"] = true,
	["ogre_magi_bloodlust_custom"] = true,
	["antimage_mana_break_custom"] = true,
	["primal_beast_uproar_custom"] = true,
	["marci_guardian_custom"] = true,
	["templar_assassin_refraction_custom"] = true,
	["bloodseeker_bloodrage_custom"] = true,
	["monkey_king_jingu_mastery_custom"] = true,
	["mars_spear_custom"] = true,
	["zuus_heavenly_jump_custom"] = true,
	["leshrac_split_earth_custom"] = true,
	["crystal_maiden_frostbite_custom"] = true,
	["snapfire_lil_shredder_custom"] = true,
	["sven_storm_bolt_custom"] = true,
	["sniper_take_aim_custom"] = true,
	["muerta_dead_shot_custom"] = true,
	["pangolier_swashbuckle_custom"] = true,
	["arc_warden_magnetic_field_custom"] = true,
	["invoker_alacrity_custom"] = true,
	["razor_static_link_custom"] = true,
	["sandking_burrowstrike_custom"] = true,
	["furion_teleportation_custom"] = true,
	["abaddon_frostmourne_custom"] = true,
	["drow_ranger_frost_arrows_custom"] = true,
	["skywrath_mage_ancient_seal_custom"] = true,
	["centaur_hoof_stomp_custom"] = true,
	["enigma_malefice_custom"] = true,
	["bane_brain_sap_custom"] = true,
	["morphling_waveform_custom"] = true,
	["life_stealer_rage_custom"] = true,
	["tinker_defense_matrix_custom"] = true
}

self.current_spell = nil
self.hidden_spell = nil
self.interval = 1
self.timer = 0

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:StartIntervalThink(self.interval)
end

function modifier_slark_essence_shift_custom_tracker:ForceDelete(spell)
if not IsServer() then return end

local units = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
for _,unit in pairs(units) do
	for _,mod in pairs(unit:FindAllModifiers()) do
		if mod:GetAbility() and mod:GetAbility() == spell then
			mod:Destroy()
		end
	end
end

end


function modifier_slark_essence_shift_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_slark_essence_7") then return end
if not self.hidden_spell then return end

self.timer = self.timer + self.interval
if self.timer < 10 and self:CheckMods(self.hidden_spell) > 0 then return end

if self.timer >= 10 then
	self:ForceDelete(self.hidden_spell)
end

self.parent:RemoveAbility(self.hidden_spell:GetName())
self.hidden_spell = nil
self.timer = 0
end


function modifier_slark_essence_shift_custom_tracker:StealSpell(target)

if self.hidden_spell then
	self:ForceDelete(self.hidden_spell)
	self.parent:RemoveAbility(self.hidden_spell:GetName())
	self.hidden_spell = nil
	self.timer = 0
end

self:ClearSpell()

local new_ability = nil
local possible_ability = {}

for index = 0, 20 do
	local current_ability = target:GetAbilityByIndex(index)
	if current_ability then

		local type_ability = current_ability:GetAbilityType()
		local behavior = current_ability:GetBehaviorInt()

		if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE) == 0 and (type_ability == 0 or type_ability == 1) 
			and not current_ability:IsHidden() and current_ability:GetMaxLevel() >= 3 then  

			possible_ability[#possible_ability + 1] = current_ability:GetName()
		end

		if self.spells[current_ability:GetName()] == true then
			new_ability = current_ability:GetName()
			break
		end
	end
end

if not new_ability then 
	if #possible_ability > 0 then
		new_ability = possible_ability[RandomInt(1, #possible_ability)]
	else
		return 
	end
end

if self.ability:IsHidden() then return end

self.current_spell = self.parent:AddAbility(new_ability)
if self.current_spell then

	local level = self.current_spell:GetMaxLevel()
	local target_ability = target:FindAbilityByName(new_ability)
	if target_ability and target_ability:GetAbilityType() == 1 then
		level = target_ability:GetLevel()
	end

	self.current_spell:SetRefCountsModifiers(true)
	self.current_spell:SetStolen(true)
	self.current_spell:SetLevel(level)
	self.current_spell:EndCooldown()

	if bit.band(self.current_spell:GetBehaviorInt() , DOTA_ABILITY_BEHAVIOR_AUTOCAST) ~= 0 then
		self.current_spell:ToggleAutoCast()
	end
end

self.parent:SwapAbilities(self.ability:GetName(), self.current_spell:GetName(), false, true)
self:SendBuffRefreshToClients()

return self.current_spell:GetName()
end


function modifier_slark_essence_shift_custom_tracker:ClearSpell()
if not self.current_spell then return end

self.parent:SwapAbilities(self.ability:GetName(), self.current_spell:GetName(), true, false)

if self.current_spell:GetIntrinsicModifierName() ~= nil and self.parent:FindModifierByName(self.current_spell:GetIntrinsicModifierName()) then
	self.parent:RemoveModifierByName(self.current_spell:GetIntrinsicModifierName())
end

if bit.band(self.current_spell:GetBehaviorInt() , DOTA_ABILITY_BEHAVIOR_TOGGLE) ~= 0 and self.current_spell:GetToggleState() then
	self.current_spell:ToggleAbility()
end

if self:CheckMods(self.current_spell) <= 0 then
	self.parent:RemoveAbility(self.current_spell:GetName())
else
	self.hidden_spell = self.current_spell
end

self.current_spell = nil
end


function modifier_slark_essence_shift_custom_tracker:CheckMods(ability)
if not IsServer() then return end
local count = 0

if ability:GetIntrinsicModifierName() ~= nil and self.parent:FindModifierByName(ability:GetIntrinsicModifierName()) then
	count = -1
end
count = count + ability:NumModifiersUsingAbility()
return count
end


function modifier_slark_essence_shift_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local target = params.target

local mod = target:FindModifierByName("modifier_slark_essence_shift_custom_legendary_target")
if mod then
	mod:AddStack()
end

if self.parent:HasTalent("modifier_slark_essence_3") then 
	DoCleaveAttack( self.parent, target, self.ability, self.parent:GetTalentValue("modifier_slark_essence_3", "cleave")*params.damage/100, 150, 360, 650, "particles/slark/essence_cleave.vpcf" )
end 

if self.parent:HasTalent("modifier_slark_essence_2") then
	target:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_custom_slow", {duration = self.slow_duration})
end

if not params.no_attack_cooldown and self.parent:HasTalent("modifier_slark_essence_4") and not self.parent:HasModifier("modifier_slark_essence_shift_custom_double_cd") then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_custom_double_cd", {})
	target:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_custom_double_slow", {duration = self.double_slow*(1 - target:GetStatusResistance())})
	target:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_custom_double", {duration = self.double_delay, stack = self.parent:GetTalentValue("modifier_slark_essence_4", "attacks") - 1})
end

local essence_mod = target:FindModifierByName("modifier_slark_essence_shift_custom_target")
if essence_mod and self.parent:HasTalent("modifier_slark_essence_6") and not target:HasModifier("modifier_slark_essence_shift_custom_stun_cd") and not target:IsDebuffImmune() and essence_mod:GetStackCount() >= self.stun_stack then
	target:EmitSound("Slark.Essence_stun")

	local effect_cast = ParticleManager:CreateParticle( "particles/slark/essence_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() + Vector( 0, 0, 64 ) )
	ParticleManager:SetParticleControlForward( effect_cast, 3, (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	target:AddNewModifier(self.parent, self.ability, "modifier_bashed", {duration = (1 - target:GetStatusResistance())*self.stun_duration})
	target:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_custom_stun_cd", {duration = self.stun_cd})
end

if self.parent:PassivesDisabled() and not self.parent:HasTalent("modifier_slark_essence_6") then return end
if target:IsIllusion() then return end

local dance_mod = self.parent:FindModifierByName("modifier_slark_shadow_dance_custom")

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_essence_shift.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target )
ParticleManager:SetParticleControlEnt( effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )

if params.no_attack_cooldown then
	ParticleManager:SetParticleControlEnt( effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
else
	if dance_mod and dance_mod.dummy then
		ParticleManager:SetParticleControlEnt( effect_cast, 1, dance_mod.dummy, PATTACH_POINT_FOLLOW, nil, dance_mod.dummy:GetAbsOrigin(), true )
	else
		ParticleManager:SetParticleControlEnt( effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
	end
end

ParticleManager:ReleaseParticleIndex( effect_cast )

self.ability:AddStack(self.parent, target:IsCreep())
self.ability:AddStack(target)
end

function modifier_slark_essence_shift_custom_tracker:AddCustomTransmitterData() 
if not self.current_spell then return end
return 
{
	current_spell = self.current_spell:entindex(),
} 
end

function modifier_slark_essence_shift_custom_tracker:HandleCustomTransmitterData(data)
if not data.current_spell then return end
self.current_spell = EntIndexToHScript(data.current_spell)
end


function modifier_slark_essence_shift_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end

function modifier_slark_essence_shift_custom_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_slark_essence_3") then return end
return self.parent:GetTalentValue("modifier_slark_essence_3", "range")
end

function modifier_slark_essence_shift_custom_tracker:GetModifierPreAttack_BonusDamage()
if not self.parent:HasTalent("modifier_slark_essence_1") then return end
return self.parent:GetAgility()*self.parent:GetTalentValue("modifier_slark_essence_1", "damage")/100
end


function modifier_slark_essence_shift_custom_tracker:SpellStartEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if not self.current_spell or self.current_spell ~= params.ability then return end
self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
end


function modifier_slark_essence_shift_custom_tracker:SpellEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if params.ability:IsItem() then return end

local mod = self.parent:FindModifierByName("modifier_slark_essence_shift_custom_double_cd")
if mod then
	mod:ReduceCd(self.double_cd)
end

if not self.current_spell or self.current_spell ~= params.ability then return end
if bit.band(self.current_spell:GetBehaviorInt() , DOTA_ABILITY_BEHAVIOR_IMMEDIATE) == 0 then return end

self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
end


function modifier_slark_essence_shift_custom_tracker:DeathEvent(params)
if not IsServer() then return end
if not params.unit or not params.unit:IsValidKill(self.parent) then return end
if not self.parent:IsAlive() then return end

local attacker = params.attacker:FindOwner()
if attacker ~= self.parent and (self.parent:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() > self.radius then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_essence_shift_custom_perma", {})
end


function modifier_slark_essence_shift_custom_tracker:GetModifierPercentageCooldown(params) 
if not params.ability or not self.current_spell then return end
if params.ability ~= self.current_spell then return end

return self.legendary_cdr
end
   




modifier_slark_essence_shift_custom_caster = class({})
function modifier_slark_essence_shift_custom_caster:IsHidden() return false end
function modifier_slark_essence_shift_custom_caster:IsPurgable() return false end

function modifier_slark_essence_shift_custom_caster:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.agi = self.ability:GetSpecialValueFor("agi_gain")
self.agi_bonus = self.parent:GetTalentValue("modifier_slark_essence_1", "agi")

self.str = self.parent:GetTalentValue("modifier_slark_essence_5", "str", true)
self.str_max = self.parent:GetTalentValue("modifier_slark_essence_5", "max", true)
self.status = self.parent:GetTalentValue("modifier_slark_essence_5", "status", true)

if not IsServer() then return end
self.RemoveForDuel = true
self:AddStack(table.duration)
end


function modifier_slark_essence_shift_custom_caster:AddStack(duration)
if not IsServer() then return end

self.max_timer = self:GetRemainingTime()

Timers:CreateTimer(duration, function() 
  if self and not self:IsNull() then 
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then 
      self:Destroy()
    end 
  end 
end)

self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end 


function modifier_slark_essence_shift_custom_caster:OnRefresh(table)
self.agi_bonus = self.parent:GetTalentValue("modifier_slark_essence_1", "agi")
if not IsServer() then return end
self:AddStack(table.duration)
end


function modifier_slark_essence_shift_custom_caster:OnStackCountChanged(iStackCount)
if not IsServer() then return end
self.parent:CalculateStatBonus(true)

if not self.parent:HasTalent("modifier_slark_essence_5") then return end

if self:GetStackCount() >= self.str_max and not self.particle then
	self.particle = self.parent:GenericParticle("particles/slark/essence_resist.vpcf", self)
end

if self:GetStackCount() < self.str_max and self.particle then
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
	self.particle = nil
end

end

function modifier_slark_essence_shift_custom_caster:OnDestroy()
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_slark_essence_shift_custom_caster:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end

function modifier_slark_essence_shift_custom_caster:GetModifierBonusStats_Agility()
return (self.agi + self.agi_bonus)*self:GetStackCount()
end

function modifier_slark_essence_shift_custom_caster:GetModifierBonusStats_Strength()
if not self.parent:HasTalent("modifier_slark_essence_5") then return end
return self.str*math.min(self.str_max, self:GetStackCount())
end

function modifier_slark_essence_shift_custom_caster:GetModifierStatusResistanceStacking() 
if not self.parent:HasTalent("modifier_slark_essence_5") then return end
return self.status*math.min(self.str_max, self:GetStackCount())
end




modifier_slark_essence_shift_custom_target = class({})
function modifier_slark_essence_shift_custom_target:IsHidden() return false end
function modifier_slark_essence_shift_custom_target:IsPurgable() return false end

function modifier_slark_essence_shift_custom_target:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.legendary_bonus = self.caster:GetTalentValue("modifier_slark_essence_7", "bonus", true)/100

self.stats = self.ability:GetSpecialValueFor("stat_loss")

if not IsServer() then return end
self.RemoveForDuel = true
self:AddStack(table.duration)
end

function modifier_slark_essence_shift_custom_target:AddStack(duration)
if not IsServer() then return end

self.max_timer = self:GetRemainingTime()

Timers:CreateTimer(duration, function() 
  if self and not self:IsNull() then 
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then 
      self:Destroy()
    end 
  end 
end)

self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end 


function modifier_slark_essence_shift_custom_target:OnRefresh(table)
if not IsServer() then return end
self:AddStack(table.duration)
end

function modifier_slark_essence_shift_custom_target:OnStackCountChanged(iStackCount)
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_slark_essence_shift_custom_target:OnDestroy()
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_slark_essence_shift_custom_target:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
}
end

function modifier_slark_essence_shift_custom_target:GetStats()
local bonus = 1
if self.parent:HasModifier("modifier_slark_essence_shift_custom_legendary_debuff") then
	bonus = bonus + self.legendary_bonus
end
return self.stats*self:GetStackCount()*bonus
end


function modifier_slark_essence_shift_custom_target:GetModifierBonusStats_Agility()
return self:GetStats()
end

function modifier_slark_essence_shift_custom_target:GetModifierBonusStats_Strength()
return self:GetStats()
end

function modifier_slark_essence_shift_custom_target:GetModifierBonusStats_Intellect()
return self:GetStats()
end




modifier_slark_essence_shift_custom_perma = class({})
function modifier_slark_essence_shift_custom_perma:IsHidden() return false end
function modifier_slark_essence_shift_custom_perma:IsPurgable() return false end
function modifier_slark_essence_shift_custom_perma:RemoveOnDeath() return false end

function modifier_slark_essence_shift_custom_perma:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.str = self.parent:GetTalentValue("modifier_slark_essence_5", "str_perma", true)

self.max = self.ability:GetSpecialValueFor("steal_max")
self.agi = self.ability:GetSpecialValueFor("perma_agi")
self:SetStackCount(1)
end

function modifier_slark_essence_shift_custom_perma:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end


function modifier_slark_essence_shift_custom_perma:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end

function modifier_slark_essence_shift_custom_perma:GetModifierBonusStats_Agility()
return self.agi*self:GetStackCount()
end

function modifier_slark_essence_shift_custom_perma:GetModifierBonusStats_Strength()
if not self.parent:HasTalent("modifier_slark_essence_5") then return end
return self.str*self:GetStackCount()
end


modifier_slark_essence_shift_custom_legendary_steal = class({})
function modifier_slark_essence_shift_custom_legendary_steal:IsHidden() return true end
function modifier_slark_essence_shift_custom_legendary_steal:IsPurgable() return false end
function modifier_slark_essence_shift_custom_legendary_steal:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.spell_name = nil

if not IsServer() then return end
self.RemoveForDuel = true
self.target = EntIndexToHScript(table.target)
self.max_timer = self:GetRemainingTime()

if not self.target or self.target:IsNull() then
	self:Destroy()
	return
end

self.mod = self.parent:FindModifierByName("modifier_slark_essence_shift_custom_tracker")
if self.mod then
	self.spell_name = self.mod:StealSpell(self.target)
end

if not self.spell_name then
	self:Destroy()
	return
end

local effect_cast = self.parent:GenericParticle("particles/slark/essence_legendary_effect.vpcf", self)
ParticleManager:SetParticleControlEnt( effect_cast, 5, self.parent, PATTACH_POINT_FOLLOW, "attach_eyeR", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( effect_cast, 6, self.parent, PATTACH_POINT_FOLLOW, "attach_eyeL", Vector(0,0,0), true )

self.parent:GenericParticle("particles/slark/essence_legendary_effect_start.vpcf")

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_slark_essence_shift_custom_legendary_steal:OnDestroy()
if not IsServer() then return end

if self.mod and not self.mod:IsNull() then
	self.mod:ClearSpell()
end

self.ability:StartCd()
self.parent:UpdateUIshort({hide = 1, style = "SlarkEssence"})
end


function modifier_slark_essence_shift_custom_legendary_steal:OnIntervalThink()
if not IsServer() then return end
self.parent:UpdateUIshort({max_time = self.max_timer, time = self:GetRemainingTime(), stack = self:GetRemainingTime(), override_ability = self.spell_name, use_zero = 1, style = "SlarkEssence"})
end




modifier_slark_essence_shift_custom_legendary_target = class({})
function modifier_slark_essence_shift_custom_legendary_target:IsHidden() return false end
function modifier_slark_essence_shift_custom_legendary_target:IsPurgable() return false end
function modifier_slark_essence_shift_custom_legendary_target:GetTexture() return "buffs/Blink_armor" end
function modifier_slark_essence_shift_custom_legendary_target:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.max = self.caster:GetTalentValue("modifier_slark_essence_7", "attacks")
self.effect_duration = self.caster:GetTalentValue("modifier_slark_essence_7", "effect_duration")

self.max_timer = self:GetRemainingTime()

if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/slark/essence_legendary_cast.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetOrigin(), true )
ParticleManager:SetParticleControl(effect_cast, 2, Vector(self.max_timer, 0, 0))
self:AddParticle(effect_cast, true, false, -1, false, false) 

self.parent:GenericParticle("particles/slark/essence_legendary_cast_head.vpcf", self, true)

self.chain_effect = ParticleManager:CreateParticle( "particles/slark/essence_cast_chains.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.chain_effect, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
ParticleManager:SetParticleControlEnt(self.chain_effect, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
self:AddParticle(self.chain_effect, true, false, -1, false, false) 

self.parent:EmitSound("Slark.Essence_legendary_cast1")
self.parent:EmitSound("Slark.Essence_legendary_cast2")
self.parent:EmitSound("Slark.Essence_legendary_cast3")

self.RemoveForDuel = true
self.interval = 0.1

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_slark_essence_shift_custom_legendary_target:OnIntervalThink()
if not IsServer() then return end

if self:GetElapsedTime() >= 2 and self.chain_effect then
	ParticleManager:DestroyParticle(self.chain_effect, false)
	ParticleManager:ReleaseParticleIndex(self.chain_effect)
	self.chain_effect = nil
end

AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 300, self.interval*2, false)
self.caster:UpdateUIshort({max_time = self.max_timer, time = self:GetElapsedTime(), stack = self:GetStackCount(), style = "SlarkEssence"})
end


function modifier_slark_essence_shift_custom_legendary_target:OnDestroy()
if not IsServer() then return end

self.parent:StopSound("Slark.Essence_legendary_cast3")

if self:GetStackCount() >= self.max then

	self.parent:EmitSound("Slark.essence_legendary_proc1")
	self.parent:EmitSound("Slark.essence_legendary_proc2")
	self.parent:EmitSound("Slark.essence_legendary_proc3")
	self.caster:EmitSound("Slark.essence_legendary_proc4")

	local effect_cast = ParticleManager:CreateParticle( "particles/slark/essence_legendary_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 350, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast2 = ParticleManager:CreateParticle( "particles/slark/essence_legendary_proc_water.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast2, 0, self.parent:GetOrigin())
	ParticleManager:SetParticleControl( effect_cast2, 2, Vector(250, 0, 0))
	ParticleManager:SetParticleControl( effect_cast2, 3, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex( effect_cast2 )

	self.parent:AddNewModifier(self.caster, self.ability, "modifier_slark_essence_shift_custom_legendary_debuff", {duration = self.effect_duration})
	self.caster:AddNewModifier(self.caster, self.ability, "modifier_slark_essence_shift_custom_legendary_steal", {duration = self.effect_duration, target = self.parent:entindex()})
else
	self.ability:StartCd()
	self.caster:UpdateUIshort({hide = 1, style = "SlarkEssence"})
end

end


function modifier_slark_essence_shift_custom_legendary_target:AddStack()
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
	self:Destroy()
end

end



modifier_slark_essence_shift_custom_legendary_debuff = class({})
function modifier_slark_essence_shift_custom_legendary_debuff:IsHidden() return false end
function modifier_slark_essence_shift_custom_legendary_debuff:IsPurgable() return false end
function modifier_slark_essence_shift_custom_legendary_debuff:GetTexture() return "buffs/Blink_armor" end
function modifier_slark_essence_shift_custom_legendary_debuff:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

end

function modifier_slark_essence_shift_custom_legendary_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_naga_riptide.vpcf"
end

function modifier_slark_essence_shift_custom_legendary_debuff:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end


function modifier_slark_essence_shift_custom_legendary_debuff:GetEffectName()
return "particles/units/heroes/hero_slark/slark_fish_bait_slow.vpcf"
end






modifier_slark_essence_shift_custom_double = class({})
function modifier_slark_essence_shift_custom_double:IsHidden() return true end
function modifier_slark_essence_shift_custom_double:IsPurgable() return false end
function modifier_slark_essence_shift_custom_double:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_slark_essence_shift_custom_double:OnCreated(table)
if not IsServer() then return end 

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.double_delay = self.caster:GetTalentValue("modifier_slark_essence_4", "delay", true)

self.stack = table.stack

if not self.caster:HasModifier("modifier_slark_dark_pact_custom") then
	self.caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 2)
end

local dir =  (self.parent:GetOrigin() - self.caster:GetOrigin() ):Normalized()

self.caster:EmitSound("Slark.Essence_double")

local particle = ParticleManager:CreateParticle( "particles/slark/essence_double.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
ParticleManager:SetParticleControl( particle, 0, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControl( particle, 1, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControlForward( particle, 1, dir)
ParticleManager:SetParticleControl( particle, 2, Vector(1,1,1) )
ParticleManager:SetParticleControlForward( particle, 5, dir )
ParticleManager:ReleaseParticleIndex(particle)
end 

function modifier_slark_essence_shift_custom_double:OnDestroy()
if not IsServer() then return end 
if not self.caster:IsAlive() or self.caster:IsNull() then return end


self.caster:AddNewModifier(self.caster, self.ability, "modifier_slark_essence_shift_custom_double_attack", {duration = FrameTime()})
self.caster:PerformAttack(self.parent, true, true, true, true, false, false, false)
self.caster:RemoveModifierByName("modifier_slark_essence_shift_custom_double_attack")

local hit_effect = ParticleManager:CreateParticle("particles/slark/essence_double_hit.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt(hit_effect, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)
self.stack = self.stack - 1
if self.stack <= 0 then return end

self.parent:AddNewModifier(self.caster, self.ability, "modifier_slark_essence_shift_custom_double", {duration = self.double_delay, stack = self.stack})
end 




modifier_slark_essence_shift_custom_double_cd = class({})
function modifier_slark_essence_shift_custom_double_cd:IsHidden() return false end
function modifier_slark_essence_shift_custom_double_cd:IsPurgable() return false end
function modifier_slark_essence_shift_custom_double_cd:IsDebuff() return true end
function modifier_slark_essence_shift_custom_double_cd:RemoveOnDeath() return false end
function modifier_slark_essence_shift_custom_double_cd:GetTexture() return "buffs/essence_double" end
function modifier_slark_essence_shift_custom_double_cd:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()

self.RemoveForDuel = true
self:SetStackCount(self.parent:GetTalentValue("modifier_slark_essence_4", "cd", true))
self:StartIntervalThink(1)
end

function modifier_slark_essence_shift_custom_double_cd:OnIntervalThink()
if not IsServer() then return end
self:ReduceCd(1)
end


function modifier_slark_essence_shift_custom_double_cd:ReduceCd(cd)
if not IsServer() then return end

for i = 1,cd do
	self:DecrementStackCount()
	if self:GetStackCount() <= 0 then
		self:Destroy()
		return
	end
end

end


modifier_slark_essence_shift_custom_double_slow = class({})
function modifier_slark_essence_shift_custom_double_slow:IsHidden() return false end
function modifier_slark_essence_shift_custom_double_slow:IsPurgable() return true end
function modifier_slark_essence_shift_custom_double_slow:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.slow = self.caster:GetTalentValue("modifier_slark_essence_4", "slow")
if not IsServer() then return end 
self.parent:GenericParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", self, true)
end 


function modifier_slark_essence_shift_custom_double_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_slark_essence_shift_custom_double_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


modifier_slark_essence_shift_custom_double_attack = class({})
function modifier_slark_essence_shift_custom_double_attack:IsHidden() return true end
function modifier_slark_essence_shift_custom_double_attack:IsPurgable() return false end





modifier_slark_essence_shift_custom_stun_cd = class({})
function modifier_slark_essence_shift_custom_stun_cd:IsHidden() return true end
function modifier_slark_essence_shift_custom_stun_cd:IsPurgable() return false end
function modifier_slark_essence_shift_custom_stun_cd:RemoveOnDeath() return false end
function modifier_slark_essence_shift_custom_stun_cd:OnCreated()
self.RemoveForDuel = true
end




modifier_slark_essence_shift_custom_slow = class({})
function modifier_slark_essence_shift_custom_slow:IsHidden() return true end
function modifier_slark_essence_shift_custom_slow:IsPurgable() return false end
function modifier_slark_essence_shift_custom_slow:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.max = self.caster:GetTalentValue("modifier_slark_essence_2", "max")
self.slow = self.caster:GetTalentValue("modifier_slark_essence_2", "slow")/self.max
self.spell = self.caster:GetTalentValue("modifier_slark_essence_2", "spell")/self.max

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_slark_essence_shift_custom_slow:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
	self.parent:GenericParticle("particles/slark/pounce_slow.vpcf", self)
end

end


function modifier_slark_essence_shift_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_slark_essence_shift_custom_slow:GetModifierSpellAmplify_Percentage()
return self.spell*self:GetStackCount()
end

function modifier_slark_essence_shift_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow*self:GetStackCount()
end
