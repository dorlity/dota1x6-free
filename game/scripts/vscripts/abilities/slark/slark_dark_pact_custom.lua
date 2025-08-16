LinkLuaModifier("modifier_slark_dark_pact_custom_delay", "abilities/slark/slark_dark_pact_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_dark_pact_custom", "abilities/slark/slark_dark_pact_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_dark_pact_custom_legendary", "abilities/slark/slark_dark_pact_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_dark_pact_custom_legendary_stack", "abilities/slark/slark_dark_pact_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_dark_pact_custom_tracker", "abilities/slark/slark_dark_pact_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_dark_pact_custom_speed", "abilities/slark/slark_dark_pact_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_dark_pact_custom_heal", "abilities/slark/slark_dark_pact_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_dark_pact_custom_health_perma", "abilities/slark/slark_dark_pact_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_dark_pact_custom_heal_reduce", "abilities/slark/slark_dark_pact_custom", LUA_MODIFIER_MOTION_NONE)


slark_dark_pact_custom = class({})


function slark_dark_pact_custom:CreateTalent()
local mod = self:GetCaster():FindModifierByName("modifier_slark_dark_pact_custom_tracker")
if mod then
	mod:UpdateJs()
end
end

function slark_dark_pact_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_dark_pact_start.vpcf", context )
PrecacheResource( "particle","particles/slark/pact_pulses.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_dark_pact_pulses_body.vpcf", context )
PrecacheResource( "particle","particles/slark/pact_legendary_stack.vpcf", context )
PrecacheResource( "particle","particles/econ/items/slardar/slardar_back_ti9/slardar_back_ti9_sprint.vpcf", context )
PrecacheResource( "particle","particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle","particles/slark/pact_damage.vpcf", context )
PrecacheResource( "particle","particles/slark/pounce_legendary_water.vpcf", context )
PrecacheResource( "particle","particles/slark/pact_legendary_heal.vpcf", context )
end


function slark_dark_pact_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_slark_dark_pact_custom_tracker"
end


function slark_dark_pact_custom:GetManaCost(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_slark_pact_3") then 
  bonus = self:GetCaster():GetTalentValue("modifier_slark_pact_3", "mana")
end 
return self.BaseClass.GetManaCost(self,level) + bonus
end


function slark_dark_pact_custom:GetCastRange(vLocation, hTarget)
return self:GetRadius()
end

function slark_dark_pact_custom:GetBehavior()
return DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function slark_dark_pact_custom:GetRadius()
return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_slark_pact_5", "radius")
end


function slark_dark_pact_custom:GetHealthCost(level)
local caster = self:GetCaster()
if not caster:HasModifier("modifier_slark_dark_pact_custom_legendary") and not caster:HasModifier("modifier_slark_dark_pact_custom_legendary_stack") then return end
return caster:GetMaxHealth()*caster:GetTalentValue("modifier_slark_pact_7", "cost")/100
end 


function slark_dark_pact_custom:GetCooldown(iLevel)
local bonus = 0
local caster = self:GetCaster()
if caster:HasTalent("modifier_slark_pact_3") then 
	bonus = caster:GetTalentValue("modifier_slark_pact_3", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function slark_dark_pact_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("delay")

local mod = caster:FindModifierByName("modifier_slark_dark_pact_custom_tracker")
if mod then
	mod:OnIntervalThink()
end

local legendary_mod = caster:FindModifierByName("modifier_slark_dark_pact_custom_legendary")

if legendary_mod then
	legendary_mod.early = true
	legendary_mod:Destroy()
	caster:AddNewModifier(caster, self, "modifier_slark_dark_pact_custom_legendary_stack", {})
end

caster:AddNewModifier(caster, self, "modifier_slark_dark_pact_custom_delay", {duration = duration})
end


modifier_slark_dark_pact_custom_delay = class({})
function modifier_slark_dark_pact_custom_delay:IsHidden() return true end
function modifier_slark_dark_pact_custom_delay:IsPurgable() return false end
function modifier_slark_dark_pact_custom_delay:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.duration = self.ability:GetSpecialValueFor("pulse_duration")

if not IsServer() then return end

self.ability:EndCd()

local effect_cast = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_slark/slark_dark_pact_start.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent, self.parent:GetTeamNumber() )
ParticleManager:SetParticleControlEnt(effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, nil, self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( effect_cast )

EmitSoundOnLocationForAllies( self.parent:GetAbsOrigin(), "Hero_Slark.DarkPact.PreCast", self.parent )
end

function modifier_slark_dark_pact_custom_delay:OnDestroy()
if not IsServer() then return end
local mod = nil

if self.parent:IsAlive() then 
	if self.parent:HasTalent("modifier_slark_pact_5") then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_dark_pact_custom_speed", {duration = self.parent:GetTalentValue("modifier_slark_pact_5", "duration")})
	end

	if self.parent:HasTalent("modifier_slark_pact_2") then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_dark_pact_custom_heal", {duration = self.parent:GetTalentValue("modifier_slark_pact_2", "duration")})
	end

	mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_dark_pact_custom", {})
end

if mod == nil then
	self.ability:StartCd()
end

end



modifier_slark_dark_pact_custom = class({})
function modifier_slark_dark_pact_custom:IsHidden() return true end
function modifier_slark_dark_pact_custom:IsPurgable() return false end
function modifier_slark_dark_pact_custom:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.ability:GetSpecialValueFor("total_pulses")
self.duration = self.ability:GetSpecialValueFor("pulse_duration") + self.parent:GetTalentValue("modifier_slark_pact_6", "duration")
self.interval = self.duration/self.max
self.radius = self.ability:GetRadius()
self.base_damage = self.ability:GetSpecialValueFor("total_damage")

self.damage = self.base_damage + self.parent:GetTalentValue("modifier_slark_pact_4", "damage")*self.parent:GetMaxHealth()/100
self.self_damage = self.base_damage*self.ability:GetSpecialValueFor("self_damage_pct")/100

self.damage = self.damage/self.max
self.self_damage = self.self_damage/self.max

self.damageTable = {attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}
self.damage_reduce = self.parent:GetTalentValue("modifier_slark_pact_6", "damage_reduce")

if not IsServer() then return end

self.legendary_stack = self.parent:FindModifierByName("modifier_slark_dark_pact_custom_legendary_stack")
if self.legendary_stack then
	self.damage = self.damage*(1 + self.legendary_stack:GetStackCount()*self.parent:GetTalentValue("modifier_slark_pact_7", "damage")/100)
end

if self.parent:HasTalent("modifier_slark_pact_6") then
	self.parent:GenericParticle("particles/slark/pact_damage.vpcf", self)
end

self.full_hero = true

self.targets = {}
self.legendary_active = false

self.heal_reduce_duration = self.parent:GetTalentValue("modifier_slark_pact_1", "duration", true)

self.knock_duration = self.parent:GetTalentValue("modifier_slark_pact_5", "knock_duration")

local anim_k = 1/self.duration
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, anim_k)
self.parent:EmitSound("Hero_Slark.DarkPact.Cast")

local effect_body = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_dark_pact_pulses_body.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(effect_body, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( effect_body )

local dance_mod = self.parent:FindModifierByName("modifier_slark_shadow_dance_custom")
local unit = self.parent
local point = "attach_hitloc"

if dance_mod and dance_mod.dummy then
	point = nil
	unit = dance_mod.dummy
end

local effect_cast = ParticleManager:CreateParticle( "particles/slark/pact_pulses.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
ParticleManager:SetParticleControlEnt( effect_cast, 0, unit, PATTACH_POINT_FOLLOW, point, unit:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( effect_cast, 1, unit, PATTACH_ABSORIGIN_FOLLOW, point, unit:GetOrigin(), true )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.duration, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:SetStackCount(self.max)
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_slark_dark_pact_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_slark_dark_pact_custom:GetModifierIncomingDamage_Percentage()
if not self.parent:HasTalent("modifier_slark_pact_6") then return end
return self.damage_reduce*(1 - self.parent:GetHealthPercent()/100)
end

function modifier_slark_dark_pact_custom:OnIntervalThink()
if not IsServer() then return end

local targets = self.parent:FindTargets(self.radius)

if not self.parent:HasTalent("modifier_slark_pact_6") then
	table.insert(targets, self.parent)
end

self.origin = self.parent:GetAbsOrigin()
local hit_hero = false

for _,target in pairs(targets) do
	
	local damage = self.damage
	self.damageTable.damage_flags = 0
	self.damageTable.victim = target

	if target == self.parent then
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		damage = self.self_damage
	else
		if target:IsRealHero() then
			hit_hero = true
		end

		if not self.targets[target:entindex()] then
			self.targets[target:entindex()] = true

			if self.parent:HasTalent("modifier_slark_pact_5") then
				self.parent:PullTarget(target, self.ability, self.knock_duration)
			end
		end

		if self.parent:HasTalent("modifier_slark_pact_1") then
			target:AddNewModifier(self.parent, self.ability, "modifier_slark_dark_pact_custom_heal_reduce", {duration = self.heal_reduce_duration})
		end
	end

	self.damageTable.damage = damage
	DoDamage(self.damageTable)
end

if hit_hero == false then
	self.full_hero = false
end

self.parent:Purge( false, true, false, true, true )

self:DecrementStackCount()
if self:GetStackCount() <= 0 then
	self:Destroy()
end

end



function modifier_slark_dark_pact_custom:OnDestroy()
if not IsServer() then return end

if self.full_hero == true then
	if self.parent:GetQuest() == "Slark.Quest_5" then
		self.parent:UpdateQuest(1)
	end
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_dark_pact_custom_health_perma", {})
end 

self.ability:StartCd()

if self.parent:HasTalent("modifier_slark_pact_7") then

	if self.legendary_stack and not self.legendary_stack:IsNull() and self.legendary_stack.max and self.legendary_stack:GetStackCount() >= self.legendary_stack.max then

		local effect_body = ParticleManager:CreateParticle( "particles/slark/pact_legendary_heal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(effect_body, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( effect_body )

		self.parent:EmitSound("Slark.Pact_legendary_heal")
		self.parent:GenericHeal(self.parent:GetMaxHealth()*self.parent:GetTalentValue("modifier_slark_pact_7", "heal")/100, self.ability, false, "particles/slark/dance_lifesteal.vpcf", "modifier_slark_pact_7")

		self.legendary_stack:Destroy()
	else
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_dark_pact_custom_legendary", {duration = self.parent:GetTalentValue("modifier_slark_pact_7", "duration")})
	end
end

end


modifier_slark_dark_pact_custom_tracker = class({})
function modifier_slark_dark_pact_custom_tracker:IsHidden() return true end
function modifier_slark_dark_pact_custom_tracker:IsPurgable() return false end
function modifier_slark_dark_pact_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:AddDamageEvent_out(self)

self.heal_creeps = self.parent:GetTalentValue("modifier_slark_pact_2", "creeps", true)
self.heal_bonus = self.parent:GetTalentValue("modifier_slark_pact_2", "bonus",  true)

self.legendary_max = self.parent:GetTalentValue("modifier_slark_pact_7", "max", true)
end

function modifier_slark_dark_pact_custom_tracker:UpdateJs()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_slark_pact_7") then return end

local max = self.legendary_max
local stack = 0

local mod = self.parent:FindModifierByName("modifier_slark_dark_pact_custom_legendary_stack")
if mod then
	stack = mod:GetStackCount()
end

self.parent:UpdateUIlong({max = max, stack = stack, style = "SlarkPact"})
end


function modifier_slark_dark_pact_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_slark_pact_2") then return end
if not self.parent:CheckLifesteal(params, 0) then return end

local heal = params.damage*self.parent:GetTalentValue("modifier_slark_pact_2", "heal")/100
local particle = ""
if self.parent:HasModifier("modifier_slark_dark_pact_custom_heal") then
	heal = heal*self.heal_bonus
	particle = nil
end
if params.unit:IsCreep() then
	heal = heal/self.heal_creeps
end
self.parent:GenericHeal(heal, self.ability, true, particle, "modifier_slark_pact_2")
end





modifier_slark_dark_pact_custom_legendary = class({})
function modifier_slark_dark_pact_custom_legendary:IsHidden() return false end
function modifier_slark_dark_pact_custom_legendary:IsPurgable() return false end
function modifier_slark_dark_pact_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.max_time = self:GetRemainingTime()

if not IsServer() then return end
self.early = false
self.ability:EndCooldown()
end

function modifier_slark_dark_pact_custom_legendary:OnDestroy()
if not IsServer() then return end
if self.early == true then return end

self.parent:RemoveModifierByName("modifier_slark_dark_pact_custom_legendary_stack")
self.ability:StartCd()
self.parent:CdAbility(self.ability, self.max_time)

end





modifier_slark_dark_pact_custom_legendary_stack = class({})
function modifier_slark_dark_pact_custom_legendary_stack:IsHidden() return true end
function modifier_slark_dark_pact_custom_legendary_stack:IsPurgable() return false end
function modifier_slark_dark_pact_custom_legendary_stack:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.max = self.caster:GetTalentValue("modifier_slark_pact_7", "max")

if not IsServer() then return end

self.particle = self.parent:GenericParticle("particles/slark/pact_legendary_stack.vpcf", self, true)
self:SetStackCount(1)
end

function modifier_slark_dark_pact_custom_legendary_stack:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end


function modifier_slark_dark_pact_custom_legendary_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end

local mod = self.parent:FindModifierByName("modifier_slark_dark_pact_custom_tracker")
if mod then
	mod:UpdateJs()
end

if not self.particle then return end
ParticleManager:SetParticleControl(self.particle, 1, Vector(0, self:GetStackCount(), 0))
end


function modifier_slark_dark_pact_custom_legendary_stack:OnDestroy()
if not IsServer() then return end

local mod = self.parent:FindModifierByName("modifier_slark_dark_pact_custom_tracker")
if mod then
	mod:UpdateJs()
end

end



modifier_slark_dark_pact_custom_speed = class({})
function modifier_slark_dark_pact_custom_speed:IsHidden() return false end
function modifier_slark_dark_pact_custom_speed:IsPurgable() return false end
function modifier_slark_dark_pact_custom_speed:GetTexture() return "buffs/pact_speed" end
function modifier_slark_dark_pact_custom_speed:OnCreated()
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_slark_pact_5", "speed")
if not IsServer() then return end
self.parent:GenericParticle("particles/econ/items/slardar/slardar_back_ti9/slardar_back_ti9_sprint.vpcf", self)
end

function modifier_slark_dark_pact_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_slark_dark_pact_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end



modifier_slark_dark_pact_custom_heal = class({})
function modifier_slark_dark_pact_custom_heal:IsHidden() return true end
function modifier_slark_dark_pact_custom_heal:IsPurgable() return false end





modifier_slark_dark_pact_custom_health_perma = class({})
function modifier_slark_dark_pact_custom_health_perma:IsHidden() return not self:GetCaster():HasTalent("modifier_slark_pact_4") end
function modifier_slark_dark_pact_custom_health_perma:IsPurgable() return false end
function modifier_slark_dark_pact_custom_health_perma:RemoveOnDeath() return false end
function modifier_slark_dark_pact_custom_health_perma:GetTexture() return "buffs/pact_health" end
function modifier_slark_dark_pact_custom_health_perma:OnCreated()

self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_slark_pact_4", "max", true)

if not IsServer() then return end 
self:SetStackCount(1)
self:StartIntervalThink(0.5)
end 

function modifier_slark_dark_pact_custom_health_perma:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end


function modifier_slark_dark_pact_custom_health_perma:OnIntervalThink()
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_slark_pact_4") then return end
if self:GetStackCount() < self.max then return end

local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle_peffect, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)
self.parent:EmitSound("BS.Thirst_legendary_active")

self:StartIntervalThink(-1)
end 

function modifier_slark_dark_pact_custom_health_perma:OnStackCountChanged()
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_slark_dark_pact_custom_health_perma:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_BONUS,
}
end 

function modifier_slark_dark_pact_custom_health_perma:GetModifierHealthBonus()
if not self.parent:HasTalent("modifier_slark_pact_4") then return end 
return self:GetStackCount()*self.parent:GetTalentValue("modifier_slark_pact_4", "health")/self.max
end 



modifier_slark_dark_pact_custom_heal_reduce = class({})
function modifier_slark_dark_pact_custom_heal_reduce:IsHidden() return false end
function modifier_slark_dark_pact_custom_heal_reduce:IsPurgable() return false end
function modifier_slark_dark_pact_custom_heal_reduce:OnCreated()
self.caster = self:GetCaster()

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_slark_pact_1", "heal_reduce")
self.damage = self:GetCaster():GetTalentValue("modifier_slark_pact_1", "damage")
end

function modifier_slark_dark_pact_custom_heal_reduce:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function modifier_slark_dark_pact_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_slark_dark_pact_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end

function modifier_slark_dark_pact_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_slark_dark_pact_custom_heal_reduce:GetModifierIncomingDamage_Percentage()
return self.damage
end