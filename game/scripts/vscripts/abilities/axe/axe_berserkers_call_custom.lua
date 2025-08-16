LinkLuaModifier( "modifier_axe_berserkers_call_custom_buff", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_debuff", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_tracker", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_auto_cd", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_legendary", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_str", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_legendary_stack", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_legendary_target", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_shard_charge", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_heal_change", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )

axe_berserkers_call_custom = class({})

function axe_berserkers_call_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", context )
PrecacheResource( "particle", "particles/axe_aggro.vpcf", context )
PrecacheResource( "particle", "particles/star_shield.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/ascetic_cap.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/qop_linken.vpcf", context )
PrecacheResource( "particle", "particles/axe_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/axe/call_legendary_charge.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/fall_2022/radiance_target_fall2022.vpcf", context )
PrecacheResource( "particle", "particles/axe/call_legendary_aoe.vpcf", context )
PrecacheResource( "particle", "particles/axe/calling_legendary_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_centaur/centaur_return.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_armor.vpcf", context )
PrecacheResource( "particle", "particles/axe/call_shields.vpcf", context )
dota1x6:PrecacheShopItems("npc_dota_hero_axe", context)
end

function axe_berserkers_call_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_axe_item_ti9_head_immortal") then
    return "axe_berserkers_call_ti9"
end
if self:GetCaster():HasModifier("modifier_axe_item_ti9_head_immortal_gold") then
    return "axe_berserkers_call_ti9_gold"
end
if self:GetCaster():HasModifier("modifier_axe_shout_mask_custom") then
    return "axe_berserkers_call_shoutmask"
end
return "axe_berserkers_call"
end

function axe_berserkers_call_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_axe_berserkers_call_custom_tracker"
end

function axe_berserkers_call_custom:GetCastPoint()
local bonus = self:GetCaster():HasTalent("modifier_axe_call_4") and self:GetCaster():GetTalentValue("modifier_axe_call_4", "cast") or 0
return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end

function axe_berserkers_call_custom:GetCooldown(level)
local bonus = self:GetCaster():HasTalent("modifier_axe_call_2") and self:GetCaster():GetTalentValue("modifier_axe_call_2", "cd") or 0
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function axe_berserkers_call_custom:GetBehavior()
local base = self:GetCaster():HasShard() and (DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) or DOTA_ABILITY_BEHAVIOR_NO_TARGET
return base + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT
end

function axe_berserkers_call_custom:GetRadius()
return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_axe_helix_2", "radius")
end

function axe_berserkers_call_custom:GetCastRange(vLocation, hTarget)
local caster = self:GetCaster()
if caster:HasShard() then
	return IsServer() and 99999 or self:GetSpecialValueFor("shard_range")
end
return self:GetRadius()
end

function axe_berserkers_call_custom:GetAOERadius()
return self:GetRadius()
end

function axe_berserkers_call_custom:OnAbilityPhaseStart()
self.sound_start = "Hero_Axe.BerserkersCall.Start"
if self:GetCaster():HasModifier("modifier_axe_shout_mask_custom") then
    self.sound_start = "Hero_Axe.BerserkersCall.Item.Shoutmask"
end
self:GetCaster():EmitSound(self.sound_start)
return true
end

function axe_berserkers_call_custom:OnAbilityPhaseInterrupted()
self:GetCaster():StopSound(self.sound_start)
end

function axe_berserkers_call_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_axe_call_3", "duration")
local radius = self:GetRadius()
local target = self:GetCursorTarget()

if caster:HasShard() and not caster:IsRooted() and not caster:IsLeashed() and (not target or target ~= caster) then
	local point = self:GetCursorPosition()
	if target then
		point = target:GetAbsOrigin()
	end
	local origin = caster:GetAbsOrigin()

	if point == origin then
		point = origin + caster:GetForwardVector()*10
	end
	local max_range = self:GetSpecialValueFor("shard_range") + caster:GetCastRangeBonus()
	local vec = point - caster:GetAbsOrigin()
	if vec:Length2D() >= max_range then
		point = origin + vec:Normalized()*max_range
	end

	local charge_duration = ((point - origin):Length2D())/self:GetSpecialValueFor("shard_speed")
	caster:AddNewModifier(caster, self, "modifier_axe_berserkers_call_custom_shard_charge", {duration = charge_duration, x = point.x, y = point.y})
end

if caster:HasTalent("modifier_axe_hero_1") then 
	caster:AddNewModifier(caster, self, "modifier_axe_berserkers_call_custom_heal_change", {duration = caster:GetTalentValue("modifier_axe_hero_1", "duration")})
end 

caster:AddNewModifier( caster, self, "modifier_axe_berserkers_call_custom_buff", { duration = duration } )

caster:EmitSound("Hero_Axe.Berserkers_Call")
local particle_name = "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf"
if caster:HasModifier("modifier_axe_item_ti9_head_immortal") then
    particle_name = "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf"
elseif caster:HasModifier("modifier_axe_item_ti9_head_immortal_gold") then
    particle_name = "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_gold_call.vpcf"
elseif self:GetCaster():HasModifier("modifier_axe_shout_mask_custom") then
    particle_name = "particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf"
end
local effect_cast = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControlEnt( effect_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_mouth", Vector(0,0,0), true )
ParticleManager:SetParticleControl(effect_cast, 2, Vector(radius, radius, radius))
ParticleManager:ReleaseParticleIndex( effect_cast )
end



modifier_axe_berserkers_call_custom_buff = class(mod_visible)
function modifier_axe_berserkers_call_custom_buff:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.armor = self.ability:GetSpecialValueFor( "bonus_armor" )
self.radius = self.ability:GetRadius()
self.damage_reduce = self.parent:GetTalentValue("modifier_axe_call_4", "damage_reduce")

self.has_heal = self.parent:HasTalent("modifier_axe_hero_1")
self.heal_duration = self.parent:GetTalentValue("modifier_axe_hero_1", "duration")

if not IsServer() then return end
self.ability:EndCd()
self.targets = {}
self:Taunt(true)

if self.parent:HasTalent("modifier_axe_call_4") then 
	self.parent:GenericParticle("particles/axe/call_shields.vpcf", self)
end

end

function modifier_axe_berserkers_call_custom_buff:Taunt(first)
if not IsServer() then return end
local duration = self:GetRemainingTime()	
for _,enemy in pairs(self.parent:FindTargets(self.radius)) do
	if not self.targets[enemy] then 
		enemy:AddNewModifier( self.parent, self.ability, "modifier_axe_berserkers_call_custom_debuff", { duration = duration*(1 - enemy:GetStatusResistance())})
		
		if self.has_heal then 
			enemy:AddNewModifier(self.parent, self.ability, "modifier_axe_berserkers_call_custom_heal_change", {duration = self.heal_duration})
		end 

		if not first then 
			enemy:EmitSound("Hero_Axe.Berserkers_Call")
		end

		self.targets[enemy] = true
	end
end

end

function modifier_axe_berserkers_call_custom_buff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function modifier_axe_berserkers_call_custom_buff:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end

function modifier_axe_berserkers_call_custom_buff:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_axe_berserkers_call_custom_buff:GetEffectName()
return "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf"
end

function modifier_axe_berserkers_call_custom_buff:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_axe_berserkers_call_custom_buff:OnDestroy()
if not IsServer() then return end
self.ability:StartCd()
end





modifier_axe_berserkers_call_custom_debuff = class(mod_visible)
function modifier_axe_berserkers_call_custom_debuff:OnCreated( kv )
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.attack_speed = self.caster:GetTalentValue("modifier_axe_call_4", "speed")

if not IsServer() then return end

if self.parent:IsHero() or self.parent.owner ~= nil then 
	self.parent:SetForceAttackTarget( self.caster )
	self.parent:MoveToTargetToAttack( self.caster )
end

self:StartIntervalThink(0.1)
end

function modifier_axe_berserkers_call_custom_debuff:OnIntervalThink()
if not IsServer() then return end
if self.caster:IsAlive() then return end
self:Destroy()
end

function modifier_axe_berserkers_call_custom_debuff:OnDestroy()
if not IsServer() then return end

if self.parent:IsHero() or self.parent.owner ~= nil then 
	self.parent:SetForceAttackTarget( nil )
end

end

function modifier_axe_berserkers_call_custom_debuff:CheckState()
return 
{
	[MODIFIER_STATE_TAUNTED] = true,
}
end

function modifier_axe_berserkers_call_custom_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_axe_berserkers_call_custom_debuff:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end

function modifier_axe_berserkers_call_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_axe_berserkers_call_custom_debuff:GetModifierAttackSpeedBonus_Constant()
return self.attack_speed
end






modifier_axe_berserkers_call_custom_tracker = class(mod_hidden)
function modifier_axe_berserkers_call_custom_tracker:DeclareFunctions()
return
{
  	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end


function modifier_axe_berserkers_call_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.has_legendary = self.parent:HasTalent("modifier_axe_call_legendary")
self.legendary_duration = self.parent:GetTalentValue("modifier_axe_call_legendary", "duration", true)
self.legendary_duration_creeps = self.parent:GetTalentValue("modifier_axe_call_legendary", "duration_creeps", true)
self.legendary_damage = self.parent:GetTalentValue("modifier_axe_call_legendary", "damage", true)/100
self.legendary_max = self.parent:GetTalentValue("modifier_axe_call_legendary", "max", true)/100
self.visual_max = 5

self.has_auto = self.parent:HasTalent("modifier_axe_hero_5")
self.status_bonus = self.parent:GetTalentValue("modifier_axe_hero_5", "status")
self.auto_radius = self.parent:GetTalentValue("modifier_axe_hero_5", "radius", true)
self.auto_cd = self.parent:GetTalentValue("modifier_axe_hero_5", "talent_cd", true)
self.auto_duration = self.parent:GetTalentValue("modifier_axe_hero_5", "duration", true)

self.has_str = self.parent:HasTalent("modifier_axe_call_3")
self.str_duration = self.parent:GetTalentValue("modifier_axe_call_3", "effect_duration", true)
self.str_damage = self.parent:GetTalentValue("modifier_axe_call_3", "damage", true)
self.damage_count = 0

self.has_return = self.parent:HasTalent("modifier_axe_call_1")
self.damage_return = self.parent:GetTalentValue("modifier_axe_call_1", "damage_return")/100
self.damage_return_creeps = self.parent:GetTalentValue("modifier_axe_call_1", "damage_creeps")
self.return_bonus = self.parent:GetTalentValue("modifier_axe_call_1", "bonus", true)

self.cdr_bonus = self.parent:GetTalentValue("modifier_axe_call_2", "cdr")

self.legendary_ability = self.parent:FindAbilityByName("axe_berserkers_call_custom_legendary")

if not IsServer() then return end
self:StartIntervalThink(3)
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end 

function modifier_axe_berserkers_call_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_axe_call_legendary" or self.parent:HasTalent("modifier_axe_call_legendary") then
	self.has_legendary = true
	self:UpdateUI()
	self.parent:AddDamageEvent_inc(self, true)
end

if name == "modifier_axe_hero_5" or self.parent:HasTalent("modifier_axe_hero_5") then
	self.has_auto = true
	self.status_bonus = self.parent:GetTalentValue("modifier_axe_hero_5", "status")
	self.parent:AddSpellEvent(self, true)
end

if name == "modifier_axe_call_1" or self.parent:HasTalent("modifier_axe_call_1") then
	self.has_return = true
	self.damage_return = self.parent:GetTalentValue("modifier_axe_call_1", "damage_return")/100
	self.damage_return_creeps = self.parent:GetTalentValue("modifier_axe_call_1", "damage_creeps")
	self.parent:AddDamageEvent_inc(self, true)
end

if name == "modifier_axe_call_2" or self.parent:HasTalent("modifier_axe_call_2") then
	self.cdr_bonus = self.parent:GetTalentValue("modifier_axe_call_2", "cdr")
end

if name == "modifier_axe_call_3" or self.parent:HasTalent("modifier_axe_call_3") then
	self.has_str = true
	self.parent:AddDamageEvent_inc(self, true)
end

self:SendBuffRefreshToClients()
end

function modifier_axe_berserkers_call_custom_tracker:AddCustomTransmitterData() 
return 
{
  cdr_bonus = self.cdr_bonus,
  status_bonus = self.status_bonus
} 
end

function modifier_axe_berserkers_call_custom_tracker:HandleCustomTransmitterData(data)
self.cdr_bonus = data.cdr_bonus
self.status_bonus = data.status_bonus
end

function modifier_axe_berserkers_call_custom_tracker:GetModifierPercentageCooldown()
return self.cdr_bonus
end

function modifier_axe_berserkers_call_custom_tracker:GetModifierStatusResistanceStacking()
return self.status_bonus
end

function modifier_axe_berserkers_call_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not self.ability:IsActivated() and not self.parent:HasModifier("modifier_axe_berserkers_call_custom_buff") then
	self.ability:StartCd()
end

end

function modifier_axe_berserkers_call_custom_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if not params.attacker:IsUnit() then return end
if self.parent:GetTeamNumber() == params.attacker:GetTeamNumber() then return end

local unit = params.attacker

if self.has_str then
	local final = self.damage_count + params.original_damage

	if final >= self.str_damage then 
	    local delta = math.floor(final/self.str_damage)
	    for i = 1, delta do 
	      self.parent:AddNewModifier(self.parent, self.ability, "modifier_axe_berserkers_call_custom_str", {duration = self.str_duration})
	    end 
	    self.damage_count = final - delta*self.str_damage
	else 
	    self.damage_count = final
	end 
end

if self.has_legendary and self.legendary_ability and self.legendary_ability:GetCooldownTimeRemaining() <= 0 then
	local duration = params.attacker:IsCreep() and self.legendary_duration_creeps or self.legendary_duration
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_axe_berserkers_call_custom_legendary_stack", {stack = params.original_damage*self.legendary_damage, duration = duration})
end

if self.has_return and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
	local damage = params.original_damage*self.damage_return
	if unit:IsCreep() then
		damage = math.max(damage, self.damage_return_creeps)
	end
	if self.parent:HasModifier("modifier_axe_berserkers_call_custom_buff") then
		damage = damage*self.return_bonus
		local caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(caster_pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(caster_pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(caster_pfx)
	end

	DoDamage({victim = unit, attacker = self.parent, damage = damage, damage_type = params.damage_type,  damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION, ability = self.ability}, "modifier_axe_call_1")
end

end

function modifier_axe_berserkers_call_custom_tracker:SpellEvent(params) 
if not IsServer() then return end
if not self.has_auto then return end
if params.ability:IsItem() then return end
if not self.parent:IsAlive() then return end

local unit = params.unit
if unit:GetTeamNumber() == self.parent:GetTeamNumber() then return end
if unit:IsDebuffImmune() then return end
if (unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.auto_radius then return end
if unit:HasModifier("modifier_axe_berserkers_call_custom_auto_cd") then return end

unit:EmitSound("Hero_Axe.Berserkers_Call")
self.parent:EmitSound("Hero_Axe.BerserkersCall.Start")

for i = 1,3 do
	local caster_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_return.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(caster_pfx, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(caster_pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(caster_pfx)
end

unit:AddNewModifier(self.parent, self.ability, "modifier_axe_berserkers_call_custom_debuff", {duration = self.auto_duration*(1 - unit:GetStatusResistance()) } )
unit:AddNewModifier(self.parent, self.ability, "modifier_axe_berserkers_call_custom_auto_cd", {duration = self.auto_cd})	
end


function modifier_axe_berserkers_call_custom_tracker:UpdateUI()
if not IsServer() then return end
if not self.has_legendary then return end

local stack = 0
local override = nil
local max = 1
local interval = -1
local mod = self.parent:FindModifierByName("modifier_axe_berserkers_call_custom_legendary_stack")

if mod then
	max = self.parent:GetMaxHealth()*self.legendary_max
	stack = mod:GetStackCount()
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
else
	if not self.particle then
		self.particle = self.parent:GenericParticle("particles/axe/call_legendary_charge.vpcf", self, true)
		for i = 1,self.visual_max do 
			ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
		end
	end
end

if self.legendary_ability and self.legendary_ability:GetCooldownTimeRemaining() > 0 then
	override = self.legendary_ability:GetCooldownTimeRemaining()
	interval = 1
end

self.parent:UpdateUIlong({stack = stack, max = max, override_stack = override, style = "AxeCall"})
self:StartIntervalThink(interval)
end

function modifier_axe_berserkers_call_custom_tracker:OnIntervalThink()
if not IsServer() then return end
self:UpdateUI()
end

modifier_axe_berserkers_call_custom_auto_cd = class(mod_hidden)
function modifier_axe_berserkers_call_custom_auto_cd:RemoveOnDeath() return false end
function modifier_axe_berserkers_call_custom_auto_cd:OnCreated(table)
self.RemoveForDuel = true
end


modifier_axe_berserkers_call_custom_str = class(mod_visible)
function modifier_axe_berserkers_call_custom_str:GetTexture() return "buffs/axe/call_3" end
function modifier_axe_berserkers_call_custom_str:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_axe_call_3", "max")
self.str = self.parent:GetTalentValue("modifier_axe_call_3", "str")
self.model = 30/self.max

if not IsServer() then return end
self:SetStackCount(1)
self.parent:CalculateStatBonus(true)
end

function modifier_axe_berserkers_call_custom_str:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
self.parent:CalculateStatBonus(true)

if self:GetStackCount() >= self.max then
	self.parent:GenericParticle("particles/units/heroes/hero_axe/axe_armor.vpcf", self)
end

end

function modifier_axe_berserkers_call_custom_str:OnDestroy()
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_axe_berserkers_call_custom_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_axe_berserkers_call_custom_str:GetModifierBonusStats_Strength()
return self:GetStackCount()*self.str
end

function modifier_axe_berserkers_call_custom_str:GetModifierModelScale()
return self:GetStackCount()*self.model
end


modifier_axe_berserkers_call_custom_legendary_stack = class(mod_hidden)
function modifier_axe_berserkers_call_custom_legendary_stack:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max_health = self.parent:GetTalentValue("modifier_axe_call_legendary", "max")/100
if not IsServer() then return end
self.mod = self.parent:FindModifierByName("modifier_axe_berserkers_call_custom_tracker")

self.visual_max = 5
self.particle = self.parent:GenericParticle("particles/axe/call_legendary_charge.vpcf", self, true)

self:AddStack(table.stack)
end

function modifier_axe_berserkers_call_custom_legendary_stack:OnRefresh(table)
if not IsServer() then return end
self:AddStack(table.stack)
end

function modifier_axe_berserkers_call_custom_legendary_stack:AddStack(stack)
if not IsServer() then return end
self.max = self.max_health*self.parent:GetMaxHealth()
self:SetStackCount(math.min(self.max, self:GetStackCount() + stack))
end


function modifier_axe_berserkers_call_custom_legendary_stack:OnStackCountChanged()
if not IsServer() then return end

if self.mod then
	self.mod:UpdateUI()
end

if not self.particle then return end

for i = 1,self.visual_max do 
	if i <= math.floor(self:GetStackCount()/(self.max/self.visual_max)) then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end

function modifier_axe_berserkers_call_custom_legendary_stack:OnDestroy()
if not IsServer() then return end
if not self.mod then return end
self.mod:UpdateUI()
end




axe_berserkers_call_custom_legendary = class({})

function axe_berserkers_call_custom_legendary:CreateTalent()
self:SetHidden(false)
self:SetLevel(1)
end

function axe_berserkers_call_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_axe_call_legendary", "talent_cd")
end

function axe_berserkers_call_custom_legendary:OnAbilityPhaseStart()
local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_axe_berserkers_call_custom_legendary_stack")

if not mod or mod:GetStackCount() <= 0 then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetId()), "CreateIngameErrorMessage", {message = "#arc_no_charges"})
	return false
end

return true
end


function axe_berserkers_call_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_axe_berserkers_call_custom_legendary_stack")

if not mod or mod:GetStackCount() <= 0 then return end

caster:AddNewModifier(caster, self, "modifier_axe_berserkers_call_custom_legendary", {duration = caster:GetTalentValue("modifier_axe_call_legendary", "effect_duration")})
end



modifier_axe_berserkers_call_custom_legendary = class(mod_hidden)
function modifier_axe_berserkers_call_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.parent:GetTalentValue("modifier_axe_call_legendary", "radius")
self.heal = self.parent:GetTalentValue("modifier_axe_call_legendary", "heal")/100
self.duration = self.parent:GetTalentValue("modifier_axe_call_legendary", "effect_duration")
self.damage_type = self.parent:GetTalentValue("modifier_axe_call_legendary", "damage_type")

if not IsServer() then return end

self.parent:EmitSound("Axe.Calling_legendary")
self.parent:EmitSound("Axe.Calling_legendary2")
self.parent:EmitSound("Axe.Calling_legendary_vo")
self.parent:GenericParticle("particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf", self)
self.parent:GenericParticle("particles/axe/calling_legendary_cast.vpcf")

local effect_cast = ParticleManager:CreateParticle( "particles/axe/call_legendary_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_mouth", Vector(0,0,0), true )
ParticleManager:SetParticleControl(effect_cast, 2, Vector(self.radius, self.radius, self.radius))
self:AddParticle(effect_cast, false, false, -1, false, false ) 

self.stack = 0
local mod = self.parent:FindModifierByName("modifier_axe_berserkers_call_custom_legendary_stack")
if not mod or mod:GetStackCount() <= 0 then
	self:Destroy()
	return
end

self.stack = mod:GetStackCount()
self.interval = 0.5
self.interval_damage = self.stack/(self.duration/self.interval + 1)

self.damageTable = {attacker = self.parent, ability = self.ability, damage_type = self.damage_type, damage = self.interval_damage}
mod:Destroy()

self:OnIntervalThink()
self:StartIntervalThink(self.interval - FrameTime())
end

function modifier_axe_berserkers_call_custom_legendary:OnIntervalThink()
if not IsServer() then return end

for _,target in pairs(self.parent:FindTargets(self.radius)) do
	self.damageTable.victim = target
	DoDamage(self.damageTable, "modifier_axe_call_legendary")
end

self.parent:GenericHeal(self.interval_damage*self.heal, self.ability, false, "", "modifier_axe_call_legendary")
end

function modifier_axe_berserkers_call_custom_legendary:GetStatusEffectName() return "particles/econ/items/invoker/invoker_ti7/status_effect_alacrity_ti7.vpcf" end
function modifier_axe_berserkers_call_custom_legendary:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH end

function modifier_axe_berserkers_call_custom_legendary:IsAura() return true end
function modifier_axe_berserkers_call_custom_legendary:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_axe_berserkers_call_custom_legendary:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_axe_berserkers_call_custom_legendary:GetModifierAura() return "modifier_axe_berserkers_call_custom_legendary_target" end
function modifier_axe_berserkers_call_custom_legendary:GetAuraRadius() return self.radius end
function modifier_axe_berserkers_call_custom_legendary:GetAuraDuration() return 0.1 end


modifier_axe_berserkers_call_custom_legendary_target = class(mod_hidden)
function modifier_axe_berserkers_call_custom_legendary_target:OnCreated()
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.particle_index = ParticleManager:CreateParticle("particles/econ/events/fall_2022/radiance_target_fall2022.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.particle_index, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle_index, 1, self.caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
self:AddParticle(self.particle_index, false, false, -1, false, false ) 
end

function modifier_axe_berserkers_call_custom_legendary_target:GetStatusEffectName()
return "particles/status_fx/status_effect_burn.vpcf"
end

function modifier_axe_berserkers_call_custom_legendary_target:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end




modifier_axe_berserkers_call_custom_shard_charge = class(mod_hidden)
function modifier_axe_berserkers_call_custom_shard_charge:GetEffectName() return "particles/axe/axe_charge.vpcf" end
function modifier_axe_berserkers_call_custom_shard_charge:GetStatusEffectName() return "particles/econ/items/invoker/invoker_ti7/status_effect_alacrity_ti7.vpcf" end
function modifier_axe_berserkers_call_custom_shard_charge:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL  end
function modifier_axe_berserkers_call_custom_shard_charge:OnCreated(table)
if not IsServer() then return end
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.caster:StartGesture(ACT_DOTA_RUN)

self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)

local vec = self.point - self.caster:GetAbsOrigin()
self.angle = vec:Normalized()

self.caster:FaceTowards(self.point)
self.caster:SetForwardVector(self.angle)
self.distance = vec:Length2D() / ( self:GetDuration() / FrameTime())

if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end

end

function modifier_axe_berserkers_call_custom_shard_charge:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_axe_berserkers_call_custom_shard_charge:GetActivityTranslationModifiers()
return "haste"
end

function modifier_axe_berserkers_call_custom_shard_charge:GetModifierDisableTurning() 
return 1 
end

function modifier_axe_berserkers_call_custom_shard_charge:OnDestroy()
if not IsServer() then return end
self.caster:InterruptMotionControllers( true )
self.caster:FadeGesture(ACT_DOTA_RUN)

ResolveNPCPositions(self.caster:GetAbsOrigin(), 128)

local dir = self.caster:GetForwardVector()
dir.z = 0
self.caster:SetForwardVector(dir)
self.caster:FaceTowards(self.caster:GetAbsOrigin() + dir*10)
end

function modifier_axe_berserkers_call_custom_shard_charge:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
local pos = self.caster:GetAbsOrigin()
local pos_p = self.angle * self.distance
local next_pos = GetGroundPosition(pos + pos_p,self.caster)
self.caster:SetAbsOrigin(next_pos)

GridNav:DestroyTreesAroundPoint(pos, 120, false)

local mod = self.caster:FindModifierByName("modifier_axe_berserkers_call_custom_buff")
if mod then
	mod:Taunt()
end

end

function modifier_axe_berserkers_call_custom_shard_charge:OnHorizontalMotionInterrupted()
self:Destroy()
end

function modifier_axe_berserkers_call_custom_shard_charge:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true
}
end



modifier_axe_berserkers_call_custom_heal_change = class(mod_hidden)
function modifier_axe_berserkers_call_custom_heal_change:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

local effect = "particles/items2_fx/sange_maim.vpcf"
self.heal_reduce = self.caster:GetTalentValue("modifier_axe_hero_1", "heal_reduce")

if self.parent:GetTeamNumber() == self.caster:GetTeamNumber() then
	self.heal_reduce = self.caster:GetTalentValue("modifier_axe_hero_1", "heal_inc")
	effect = "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf"
end

if not IsServer() then return end
self.parent:GenericParticle(effect, self)
end

function modifier_axe_berserkers_call_custom_heal_change:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_axe_berserkers_call_custom_heal_change:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_axe_berserkers_call_custom_heal_change:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end

function modifier_axe_berserkers_call_custom_heal_change:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end


