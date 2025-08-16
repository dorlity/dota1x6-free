LinkLuaModifier( "modifier_morphling_morph_agi_custom_tracker", "abilities/morphling/morphling_morph_agi_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_morph_custom_toggle", "abilities/morphling/morphling_morph_agi_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_morph_custom_legendary_stack", "abilities/morphling/morphling_morph_agi_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_morph_custom_legendary", "abilities/morphling/morphling_morph_agi_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_morph_custom_legendary_attack", "abilities/morphling/morphling_morph_agi_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_morph_custom_slow", "abilities/morphling/morphling_morph_agi_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_morph_custom_double", "abilities/morphling/morphling_morph_agi_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_morph_custom_double_damage", "abilities/morphling/morphling_morph_agi_custom", LUA_MODIFIER_MOTION_NONE )


morphling_morph_agi_custom = class({})


function morphling_morph_agi_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_morph_str.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf", context )
PrecacheResource( "particle", "particles/morphling/attribute_legendary_stack.vpcf", context )
PrecacheResource( "particle", "particles/morphling/attribute_legendary_effect.vpcf", context )
PrecacheResource( "particle", "particles/morphling/attribute_legendary_active.vpcf", context )
PrecacheResource( "particle", "particles/morphling/attribute_double.vpcf", context )
PrecacheResource( "particle", "particles/morphling/double_attack.vpcf", context )
end


function morphling_morph_agi_custom:GetAbilityTextureName()
return "morphling_morph_agi"
end

function morphling_morph_agi_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_morphling_morph_agi_custom_tracker"
end


function morphling_morph_agi_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasShard() then
	bonus = DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + bonus
end


function morphling_morph_agi_custom:LegendaryUI()
if not IsServer() then return end
local mod = self:GetCaster():FindModifierByName("modifier_morphling_morph_agi_custom_tracker")
if mod then
	mod:UpdateUI()
end

end

function morphling_morph_agi_custom:SendJs()
if not IsServer() then return end
local caster = self:GetCaster()
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetId()), 'morph_stats_refresh', {has_legendary = caster:HasTalent("modifier_morphling_attribute_7"), agi = caster:GetBaseAgility(), str = caster:GetBaseStrength()}) 
end


function morphling_morph_agi_custom:OnToggle()
local caster = self:GetCaster()
local state = self:GetToggleState()
local str_ability = caster:FindAbilityByName("morphling_morph_str_custom")

caster:RemoveModifierByName("modifier_morphling_morph_custom_toggle")
if state then
	if str_ability and str_ability:GetToggleState() then
		str_ability:ToggleAbility()
	end
	caster:AddNewModifier(caster, self, "modifier_morphling_morph_custom_toggle", {mode = 0})
end

end



function morphling_morph_agi_custom:OnProjectileHit(target, location)
if not target then return end
local caster = self:GetCaster()

target:EmitSound("Morph.Attribute_double")

local hit_effect = ParticleManager:CreateParticle("particles/morphling/attribute_double.vpcf", PATTACH_CUSTOMORIGIN, target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

caster:AddNewModifier(target, self, "modifier_morphling_morph_custom_double_damage", {duration = FrameTime()})
caster:PerformAttack(target, true, true, true, true, false, false, false)
caster:RemoveModifierByName("modifier_morphling_morph_custom_double_damage")
end



morphling_morph_str_custom = class({})


function morphling_morph_str_custom:GetAbilityTextureName()
return "morphling_morph_str"
end

function morphling_morph_str_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasShard() then
	bonus = DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_TOGGLE + bonus
end


function morphling_morph_str_custom:OnToggle()
local caster = self:GetCaster()
local state = self:GetToggleState()
local agi_ability = caster:FindAbilityByName("morphling_morph_agi_custom")

caster:RemoveModifierByName("modifier_morphling_morph_custom_toggle")
if state then
	if agi_ability and agi_ability:GetToggleState() then
		agi_ability:ToggleAbility()
	end
	caster:AddNewModifier(caster, self, "modifier_morphling_morph_custom_toggle", {mode = 1})
end

end





modifier_morphling_morph_custom_toggle = class(mod_visible)
function modifier_morphling_morph_custom_toggle:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()

if not IsServer() then return end

self.agi_ability = self.parent:FindAbilityByName("morphling_morph_agi_custom")

self.mode = table.mode
self.sound = self.mode == 1 and "Hero_Morphling.MorphStrengh" or "Hero_Morphling.MorphAgility"
local effect = self.mode == 1 and "particles/units/heroes/hero_morphling/morphling_morph_str.vpcf" or "particles/units/heroes/hero_morphling/morphling_morph_agi.vpcf"

self.parent:GenericParticle(effect, self)
self.str_health = GameRules:GetGameModeEntity():GetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP)

self.init = false
local rate = self.ability:GetSpecialValueFor("morph_rate_tooltip")*(1 + self.parent:GetTalentValue("modifier_morphling_hero_2", "speed")/100)

self.interval = 1/rate
self.mana = self.ability:GetSpecialValueFor("mana_cost")*self.interval

self:StartIntervalThink(self.interval)
end

function modifier_morphling_morph_custom_toggle:OnIntervalThink()
if not IsServer() then return end

if not self.init then
	self.init = true
	self.parent:EmitSound(self.sound)
end

if self.parent:GetMana() <= self.mana and not self.parent:HasShard() then return end

local agi = self.parent:GetBaseAgility()
local str = self.parent:GetBaseStrength()

if self.mode == 0 then
	local delta = math.min(1, str)
	if delta <= 0 then return end
	self.parent:SetBaseStrength(math.max(0, str - delta))
	self.parent:SetBaseAgility(agi + delta)

	self.parent:SetHealth(math.max(1, self.parent:GetHealth() - delta*self.str_health*(1 - self.parent:GetHealthPercent()/100)))
else
	local delta = math.min(1, agi)
	if delta <= 0 then return end
	self.parent:SetBaseAgility(math.max(0, agi - delta))
	self.parent:SetBaseStrength(str + delta)

	self.parent:GenericHeal(delta*self.str_health*(1 - self.parent:GetHealthPercent()/100), self.ability, true, "")
end

if not self.parent:HasShard() then
	self.parent:Script_ReduceMana(self.mana, self.ability)
end

if self.agi_ability then
	self.agi_ability:SendJs()
end

self.parent:CalculateStatBonus(true)
end


function modifier_morphling_morph_custom_toggle:OnDestroy()
if not IsServer() then return end
self.parent:StopSound(self.sound)
end






modifier_morphling_morph_agi_custom_tracker = class(mod_hidden)
function modifier_morphling_morph_agi_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.legendary_max = self.parent:GetTalentValue("modifier_morphling_attribute_7", "max", true)
self.legendary_linger = self.parent:GetTalentValue("modifier_morphling_attribute_7", "linger", true)
self.legendary_duration = self.parent:GetTalentValue("modifier_morphling_attribute_7", "duration", true)
self.visual_max = self.legendary_max/2

self.max_move = self.parent:GetTalentValue("modifier_morphling_attribute_4", "max_move_real", true)
self.agi_move = self.parent:GetTalentValue("modifier_morphling_attribute_4", "agi", true)
self.str_status = self.parent:GetTalentValue("modifier_morphling_attribute_4", "str", true)

self.str_speed = self.parent:GetTalentValue("modifier_morphling_attribute_3", "speed")/100
self.double_chance = self.parent:GetTalentValue("modifier_morphling_attribute_3", "chance", true)
self.double_delay = self.parent:GetTalentValue("modifier_morphling_attribute_3", "delay", true)

self.slow_duration = self.parent:GetTalentValue("modifier_morphling_attribute_2", "duration", true)

self.damage_bonus = self.parent:GetTalentValue("modifier_morphling_attribute_1", "damage")/100

self.heal_lifesteal = self.parent:GetTalentValue("modifier_morphling_hero_3", "heal")
self.mana_reduce = self.parent:GetTalentValue("modifier_morphling_hero_3", "mana")
self.heal_creeps = self.parent:GetTalentValue("modifier_morphling_hero_3", "creeps", true)

self.magic_resist = self.parent:GetTalentValue("modifier_morphling_hero_4", "magic")

self.attack_range = self.parent:GetTalentValue("modifier_morphling_hero_1", "attack_range")
self.cast_range = self.parent:GetTalentValue("modifier_morphling_hero_1", "cast_range")

if not IsServer() then return end

self.base_bonus = 0
self.ability:SendJs()

self.legendary_ability = self.parent:FindAbilityByName("morphling_attribute_legendary_custom")
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_morphling_morph_agi_custom_tracker:OnRefresh()
if not IsServer() then return end
self.ability:SendJs()
end


function modifier_morphling_morph_agi_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_morphling_attribute_2" or self.parent:HasTalent("modifier_morphling_attribute_2") then
	self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_morphling_hero_4" or self.parent:HasTalent("modifier_morphling_hero_4") then
	self.magic_resist = self.parent:GetTalentValue("modifier_morphling_hero_4", "magic")
end

if name == "modifier_morphling_hero_3" or self.parent:HasTalent("modifier_morphling_hero_3") then
	self.heal_lifesteal = self.parent:GetTalentValue("modifier_morphling_hero_3", "heal")
	self.mana_reduce = self.parent:GetTalentValue("modifier_morphling_hero_3", "mana")
	self.parent:AddDamageEvent_out(self, true)
end

if name == "modifier_morphling_attribute_7" or self.parent:HasTalent("modifier_morphling_attribute_7") then
	self.parent:AddAttackEvent_out(self, true)
	self.ability:SendJs() 
	self:UpdateUI()
end

if name == "modifier_morphling_attribute_3" or self.parent:HasTalent("modifier_morphling_attribute_3") then
	self.str_speed = self.parent:GetTalentValue("modifier_morphling_attribute_3", "speed")/100
	self.parent:AddAttackStartEvent_out(self)
end

if name == "modifier_morphling_hero_1" or self.parent:HasTalent("modifier_morphling_hero_1") then
	self.attack_range = self.parent:GetTalentValue("modifier_morphling_hero_1", "attack_range")
	self.cast_range = self.parent:GetTalentValue("modifier_morphling_hero_1", "cast_range")
end

if name == "modifier_morphling_attribute_1" or self.parent:HasTalent("modifier_morphling_attribute_1") then
	self.damage_bonus = self.parent:GetTalentValue("modifier_morphling_attribute_1", "damage")/100
end

if name == "modifier_morphling_hero_2" or self.parent:HasTalent("modifier_morphling_hero_2") then
	local delta = self.parent:GetTalentValue("modifier_morphling_hero_2", "str") - self.base_bonus
	self.base_bonus = self.parent:GetTalentValue("modifier_morphling_hero_2", "str")
	self.parent:SetBaseStrength(self.parent:GetBaseStrength() + delta)
	self.parent:CalculateStatBonus(true)
end
 
self:SendBuffRefreshToClients()
end



function modifier_morphling_morph_agi_custom_tracker:AddCustomTransmitterData() 
return 
{
  damage_bonus = self.damage_bonus,
  attack_range = self.attack_range,
  str_speed = self.str_speed,
  cast_range = self.cast_range,
  magic_resist = self.magic_resist,
  mana_reduce = self.mana_reduce,
} 
end

function modifier_morphling_morph_agi_custom_tracker:HandleCustomTransmitterData(data)
self.damage_bonus = data.damage_bonus
self.attack_range = data.attack_range
self.cast_range = data.cast_range
self.str_speed = data.str_speed
self.magic_resist = data.magic_resist
self.mana_reduce = data.mana_reduce
end


function modifier_morphling_morph_agi_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_morphling_hero_3") then return end
if not self.parent:CheckLifesteal(params) then return end

local heal = params.damage*self.heal_lifesteal/100
heal = params.unit:IsCreep() and heal/self.heal_creeps or heal

self.parent:GenericHeal(heal, self.ability, true, "", "modifier_morphling_hero_3")
end


function modifier_morphling_morph_agi_custom_tracker:AttackStartEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

local target = params.target
if not target:IsUnit() then return end

if self.parent:HasTalent("modifier_morphling_attribute_3") and not self.parent:HasModifier("modifier_morphling_morph_custom_double_damage") then
	if RollPseudoRandomPercentage(self.double_chance, 5960, self.parent) then
		target:AddNewModifier(self.parent, self.ability, "modifier_morphling_morph_custom_double", {duration = self.double_delay})
	end
end

end


function modifier_morphling_morph_agi_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

local target = params.target
if not target:IsUnit() then return end

if self.parent:HasTalent("modifier_morphling_attribute_2") then
	target:AddNewModifier(self.parent, self.ability, "modifier_morphling_morph_custom_slow", {duration = self.slow_duration})
end

if not self.parent:HasTalent("modifier_morphling_attribute_7") then return end
if not target:IsRealHero() then return end
if self.parent:HasModifier("modifier_morphling_morph_custom_legendary") then return end
if not self.legendary_ability or self.legendary_ability:GetCooldownTimeRemaining() > 0 then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_morph_custom_legendary_stack", {duration = self.legendary_linger})
end


function modifier_morphling_morph_agi_custom_tracker:UpdateUI()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_morphling_attribute_7") then return end
local stack = 0
local override = nil
local zero = nil
local interval = -1
local active = 0
local max = self.legendary_max
local mod = self.parent:FindModifierByName("modifier_morphling_morph_custom_legendary_stack")
local effect = self.parent:FindModifierByName("modifier_morphling_morph_custom_legendary")

if mod then
	stack = mod:GetStackCount()
end

if mod or effect then
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
else
	if not self.particle then
		self.particle = self.parent:GenericParticle("particles/morphling/attribute_legendary_stack.vpcf", self, true)
		for i = 1,self.visual_max do 
			ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
		end
	end
end

if effect then
	active = 1
	zero = 1
	stack = effect:GetRemainingTime()
	override = effect:GetRemainingTime()
	max = self.legendary_duration*self.legendary_max
else
	if self.legendary_ability and not self.legendary_ability:IsActivated() then
		self.legendary_ability:StartCd()
		self.ability:SetActivated(true)
		local str_ability = self.parent:FindAbilityByName("morphling_morph_str_custom")
		if str_ability then
			str_ability:SetActivated(true)
		end
	end
end

if self.legendary_ability and self.legendary_ability:GetCooldownTimeRemaining() > 0 then
	override = self.legendary_ability:GetCooldownTimeRemaining()
	stack = 0
	interval = 1
end

self.parent:UpdateUIlong({stack = stack, max = max, override_stack = override, priority = 1, use_zero = zero, active = active, style = "MorphAttribute"})
self:StartIntervalThink(interval)
end


function modifier_morphling_morph_agi_custom_tracker:OnIntervalThink()
if not IsServer() then return end
self:UpdateUI()
end


function modifier_morphling_morph_agi_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
  MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
  MODIFIER_PROPERTY_MOVESPEED_LIMIT,
  MODIFIER_PROPERTY_MOVESPEED_MAX,
  MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
  MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
  MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end


function modifier_morphling_morph_agi_custom_tracker:GetModifierPercentageManacostStacking()
return self.mana_reduce
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierAttackSpeedBonus_Constant()
return self.parent:GetStrength()*self.str_speed
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierMoveSpeedBonus_Percentage()
if not self.parent:HasTalent("modifier_morphling_attribute_4") then return end
return self.parent:GetAgility()/self.agi_move
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierStatusResistanceStacking() 
if not self.parent:HasTalent("modifier_morphling_attribute_4") then return end
return self.parent:GetStrength()/self.str_status
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierIgnoreMovespeedLimit()
if not self.parent:HasTalent("modifier_morphling_attribute_4") then return 0 end
return 1
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierMoveSpeed_Max()
if not self.parent:HasTalent("modifier_morphling_attribute_4") then return end
return self.max_move
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierMoveSpeed_Limit()
if not self.parent:HasTalent("modifier_morphling_attribute_4") then return end
return self.max_move
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierAttackRangeBonus()
return self.attack_range
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierCastRangeBonusStacking()
return self.cast_range
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierMagicalResistanceBonus()
return self.magic_resist
end

function modifier_morphling_morph_agi_custom_tracker:GetModifierPreAttack_BonusDamage()
return (self.parent:GetAgility() + self.parent:GetStrength())*self.damage_bonus
end








modifier_morphling_morph_custom_legendary_stack = class(mod_hidden)
function modifier_morphling_morph_custom_legendary_stack:IsDebuff() return true end
function modifier_morphling_morph_custom_legendary_stack:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.max = self.parent:GetTalentValue("modifier_morphling_attribute_7", "max", true)
self.radius = self.parent:GetTalentValue("modifier_morphling_attribute_7", "radius", true)
self.duration = self.parent:GetTalentValue("modifier_morphling_attribute_7", "linger", true)


if not IsServer() then return end
self.visual_max = self.max/2
self.particle = self.parent:GenericParticle("particles/morphling/attribute_legendary_stack.vpcf", self, true)

self:SetStackCount(1)
self:StartIntervalThink(0.2)
end

function modifier_morphling_morph_custom_legendary_stack:OnIntervalThink()
if not IsServer() then return end
local targets = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

if #targets > 0 then
	self:SetDuration(self.duration, true)
end

end

function modifier_morphling_morph_custom_legendary_stack:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then

end

end

function modifier_morphling_morph_custom_legendary_stack:OnStackCountChanged()
if not IsServer() then return end

self.ability:LegendaryUI()
if not self.particle then return end

for i = 1,self.visual_max do 
	if i <= math.floor(self:GetStackCount()/(self.max/self.visual_max)) then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end


function modifier_morphling_morph_custom_legendary_stack:OnDestroy()
if not IsServer() then return end
self.ability:LegendaryUI()
end



morphling_attribute_legendary_custom = class({})
function morphling_attribute_legendary_custom:CreateTalent()
if self:GetCaster():HasModifier("modifier_morphling_replicate_custom") then return end
self:SetHidden(false)
end

function morphling_attribute_legendary_custom:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_morphling_attribute_7", "talent_cd")
end

function morphling_attribute_legendary_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_morphling_morph_custom_legendary_stack")

if not mod or mod:GetStackCount() <= 0 then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer( caster:GetPlayerOwnerID() ), "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
	return false
end

return true
end


function morphling_attribute_legendary_custom:OnSpellStart()
local caster = self:GetCaster()

local mod = caster:FindModifierByName("modifier_morphling_morph_custom_legendary_stack")
if not mod or mod:GetStackCount() <= 0 then return end

local duration = caster:GetTalentValue("modifier_morphling_attribute_7", "duration")
caster:AddNewModifier(caster, self, "modifier_morphling_morph_custom_legendary", {duration = duration*mod:GetStackCount()})
caster:StartGestureWithPlaybackRate(ACT_DOTA_SPAWN, 1.2)

mod:Destroy()
end


modifier_morphling_morph_custom_legendary = class(mod_hidden)
function modifier_morphling_morph_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end

self.RemoveForDuel = true

local agility = self.parent:GetBaseAgility()
local strength = self.parent:GetBaseStrength()

self.str_bonus = agility > strength and (agility - strength) or 0
self.agi_bonus = strength > agility and (strength - agility) or 0

local waveform = self.parent:FindAbilityByName("morphling_waveform_custom")
if waveform then
	local cd = waveform:GetCooldownTimeRemaining()
	if cd > 0 then
		waveform:EndCooldown()
		waveform:StartCooldown(math.min(cd, self.parent:GetTalentValue("modifier_morphling_attribute_7", "wave_cd")))
	end
end

self.agi_ability = self.parent:FindAbilityByName("morphling_morph_agi_custom")
self.str_ability = self.parent:FindAbilityByName("morphling_morph_str_custom")

if self.agi_ability then
	if self.agi_ability:GetToggleState() then
		self.agi_ability:ToggleAbility()
	end
	self.agi_ability:SetActivated(false)
end

if self.str_ability then
	if self.str_ability:GetToggleState() then
		self.str_ability:ToggleAbility()
	end
	self.str_ability:SetActivated(false)
end

self.parent:GenericParticle("particles/morphling/attribute_legendary_effect.vpcf", self)
self.parent:GenericParticle("particles/units/heroes/hero_morphling/morphling_morph_str.vpcf", self)

self.max = self.parent:GetTalentValue("modifier_morphling_attribute_7", "max")
self.time_max = self.max*self.parent:GetTalentValue("modifier_morphling_attribute_7", "duration")
self.visual_max = self.max/2

self.particle = self.parent:GenericParticle("particles/morphling/attribute_legendary_stack.vpcf", self, true)

local radius = 250
local effect2 = ParticleManager:CreateParticle("particles/morphling/attribute_legendary_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(effect2, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(effect2, 1, Vector(radius, radius, radius))
ParticleManager:ReleaseParticleIndex(effect2)

self.parent:EmitSound("Morph.Attribute_legendary_cast")
self.parent:EmitSound("Morph.Attribute_legendary_cast2")
self.parent:EmitSound("Morph.Attribute_legendary_loop")

self.ability:EndCd()
self.parent:CalculateStatBonus(true)

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_morphling_morph_custom_legendary:OnIntervalThink()
if not IsServer() then return end

if self.agi_ability then
	self.agi_ability:LegendaryUI()
end

if not self.particle then return end

for i = 1,self.visual_max do 
	if i <= (math.floor((self:GetRemainingTime() - 0.1)/(self.time_max/self.visual_max)) + 1) then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end



function modifier_morphling_morph_custom_legendary:OnDestroy()
if not IsServer() then return end

if self.agi_ability then
	self.agi_ability:LegendaryUI()
end

self.parent:StopSound("Morph.Attribute_legendary_loop")

self.ability:StartCd()

if self.agi_ability then
	self.agi_ability:SetActivated(true)
end

if self.str_ability then
	self.str_ability:SetActivated(true)
end

end

function modifier_morphling_morph_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end

function modifier_morphling_morph_custom_legendary:GetModifierModelScale()
return 35
end

function modifier_morphling_morph_custom_legendary:GetModifierBonusStats_Strength()
return self.str_bonus
end

function modifier_morphling_morph_custom_legendary:GetModifierBonusStats_Agility()
return self.agi_bonus
end

function modifier_morphling_morph_custom_legendary:GetStatusEffectName()
return "particles/butterfly_status.vpcf" 
end

function modifier_morphling_morph_custom_legendary:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end



modifier_morphling_morph_custom_legendary_attack = class(mod_visible)
function modifier_morphling_morph_custom_legendary_attack:GetTexture() return "attribute_legendary" end
function modifier_morphling_morph_custom_legendary_attack:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.bva = self.ability:GetSpecialValueFor("strike_bva")
end


function modifier_morphling_morph_custom_legendary_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
}
end

function modifier_morphling_morph_custom_legendary_attack:GetModifierBaseAttackTimeConstant()
return self.bva
end


modifier_morphling_morph_custom_slow = class(mod_hidden)
function modifier_morphling_morph_custom_slow:IsPurgable() return true end
function modifier_morphling_morph_custom_slow:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.slow = self.caster:GetTalentValue("modifier_morphling_attribute_2", "slow")
self.slow_attack = self.caster:GetTalentValue("modifier_morphling_attribute_2", "slow_attack")
end

function modifier_morphling_morph_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_morphling_morph_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self.slow_attack
end

function modifier_morphling_morph_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_morphling_morph_custom_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_morphling_morph_custom_slow:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL
end


modifier_morphling_morph_custom_double = class(mod_hidden)
function modifier_morphling_morph_custom_double:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_morphling_morph_custom_double:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

if not IsServer() then return end
self.caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 3)

local dir =  (self.parent:GetOrigin() - self.caster:GetOrigin() ):Normalized()
local particle = ParticleManager:CreateParticle( "particles/morphling/double_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
ParticleManager:SetParticleControl( particle, 0, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControl( particle, 1, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControlForward( particle, 1, dir)
ParticleManager:SetParticleControl( particle, 2, Vector(1,1,1) )
ParticleManager:SetParticleControlForward( particle, 5, dir )
ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_morphling_morph_custom_double:OnDestroy()
if not IsServer() then return end
if not self.caster:IsAlive() then return end

self.info = 
{
	EffectName = "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf",
	Ability = self.ability,
	iMoveSpeed = self.caster:GetProjectileSpeed(),
	Source = self.caster,
	Target = self.parent,
	bDodgeable = true,
	bProvidesVision = true,
	iVisionTeamNumber = self.caster:GetTeamNumber(),
	iVisionRadius = 50,
	iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1, 
}
self.caster:EmitSound("Morph.Double_attack")
ProjectileManager:CreateTrackingProjectile( self.info )
end



modifier_morphling_morph_custom_double_damage = class(mod_hidden)
function modifier_morphling_morph_custom_double_damage:OnCreated()
self.damage = self:GetParent():GetTalentValue("modifier_morphling_attribute_3", "damage") - 100
end

function modifier_morphling_morph_custom_double_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_morphling_morph_custom_double_damage:GetModifierDamageOutgoing_Percentage()
return self.damage
end