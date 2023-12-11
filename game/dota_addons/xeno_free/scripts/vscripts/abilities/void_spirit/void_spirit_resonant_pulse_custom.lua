LinkLuaModifier("modifier_void_spirit_resonant_pulse", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_ring_lua", "util/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_void_spirit_resonant_pulse_aura", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_pulse_aura_damage", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_pulse_silence", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_invun", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_damage", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_slow", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_damage_tracker", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_tracker", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_resonant_speed", "abilities/void_spirit/void_spirit_resonant_pulse_custom", LUA_MODIFIER_MOTION_NONE)


void_spirit_resonant_pulse_custom = class({})





function void_spirit_resonant_pulse_custom:Precache(context)

PrecacheResource( "particle", "particles/void_shield_legen.vpcf", context )
PrecacheResource( "particle", "particles/am_heal.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield_deflect.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_void_debuff.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/void_spirit/pulse_legendary.vpcf", context )

end


function void_spirit_resonant_pulse_custom:GetIntrinsicModifierName()

return "modifier_void_spirit_resonant_tracker"
end


function void_spirit_resonant_pulse_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor( "buff_duration" )


local bonus = 0

if self:GetCaster():HasModifier("modifier_void_spirit_resonant_damage_tracker") then 

    for _,mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_void_spirit_resonant_damage_tracker")) do 
        bonus = bonus + mod:GetStackCount()
        mod:Destroy()
    end

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( particle )

		self:GetCaster():EmitSound("Juggernaut.WardDeath")  

    self:GetCaster():GenericHeal(bonus, self)
end



caster:AddNewModifier(caster, self, "modifier_void_spirit_resonant_pulse", { duration = duration })

end




function void_spirit_resonant_pulse_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_void_pulse_6") then 
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_void_pulse_6", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end


function void_spirit_resonant_pulse_custom:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end




function void_spirit_resonant_pulse_custom:GetBehavior()

local bonus = 0
if self:GetCaster():HasModifier("modifier_void_pulse_5") then 
	--bonus = DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + bonus
end






modifier_void_spirit_resonant_pulse = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_void_spirit_resonant_pulse:IsHidden()
	return false
end

function modifier_void_spirit_resonant_pulse:IsDebuff()
	return false
end

function modifier_void_spirit_resonant_pulse:IsPurgable()
	return not self:GetCaster():HasModifier("modifier_void_pulse_legendary")
end

function modifier_void_spirit_resonant_pulse:CreateWave(caster, new_damage)


self.radius = self:GetAbility():GetSpecialValueFor( "radius" ) + 90
self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
self.return_speed = self:GetAbility():GetSpecialValueFor( "return_projectile_speed" )


self.ulti = self:GetCaster():FindAbilityByName("void_spirit_astral_step_custom")

if new_damage then
	self.damage = new_damage
end

if not IsServer() then return end

self.damageTable = {attacker = caster, damage = self.damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility()}

self.info = {Target = caster, Ability = self:GetAbility(), EffectName = "", iMoveSpeed = self.return_speed, bDodgeable = false, iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION}

local pulse = caster:AddNewModifier(
		caster, 
		self:GetAbility(), 
		"modifier_generic_ring_lua",
		{
			end_radius = self.radius,
			speed = self.speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		} 
	)



local pull_duration = self:GetCaster():GetTalentValue("modifier_void_pulse_6", "duration")
local slow_duration = self:GetCaster():GetTalentValue("modifier_void_pulse_6", "slow_duration")
local min_distance = self:GetCaster():GetTalentValue("modifier_void_pulse_6", "min_distance")

local caster = self:GetCaster()

pulse:SetCallback( function( enemy )

	self.damageTable.victim = enemy
	local real_damage = ApplyDamage(self.damageTable)

	if new_damage then 
		enemy:SendNumber(6, real_damage)
	end

	if pulse:GetCaster():HasScepter() and not new_damage then

		if self.ulti then 
			self.ulti:AddMark(enemy)
		end

		enemy:AddNewModifier(pulse:GetCaster(), pulse:GetAbility(), "modifier_void_spirit_resonant_pulse_silence", {duration = (1 - enemy:GetStatusResistance())*pulse:GetAbility():GetSpecialValueFor("scepter_silence")})
	end

	if caster:HasModifier("modifier_void_step_4") and not enemy:HasModifier("modifier_void_spirit_astral_step_spells_max") then 
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_void_spirit_astral_step_spells", {duration = caster:GetTalentValue("modifier_void_step_4", "duration")})
	end


	if pulse:GetCaster():HasModifier("modifier_void_spirit_resonant_pulse") then 

		self:PlayEffects3( enemy )
		if not enemy:IsHero() then return end

		self.info.Source = enemy
		ProjectileManager:CreateTrackingProjectile(self.info)

		self:PlayEffects4( pulse:GetCaster(), enemy )
	end

end)

self:PlayEffects1(new_damage)
end



function modifier_void_spirit_resonant_pulse:OnCreated( kv )
self.max_shield = self:GetAbility():GetSpecialValueFor( "base_absorb_amount" ) + self:GetCaster():GetMaxMana()*self:GetCaster():GetTalentValue("modifier_void_pulse_1", "shield")/100


if not IsServer() then return end
self.shield = 0
self.RemoveForDuel = true
self:PlayEffects2()

self.legendary_k = self:GetCaster():GetTalentValue("modifier_void_pulse_legendary", "damage")/100
self.legendary_k_shield = self:GetCaster():GetTalentValue("modifier_void_pulse_legendary", "shield")/100
self.legendary_creeps = self:GetCaster():GetTalentValue("modifier_void_pulse_legendary", "creeps")/100


self.legendary_damage = 0


self.max_time = self:GetRemainingTime()

if self:GetCaster():HasModifier("modifier_void_pulse_legendary") then
	self:OnIntervalThink()
	self:StartIntervalThink(0.1)
end


if self:GetParent():HasModifier("modifier_void_pulse_6") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_void_spirit_resonant_speed", {duration = self:GetCaster():GetTalentValue("modifier_void_pulse_6", "speed_duration")})
end

if self:GetParent():HasModifier("modifier_void_pulse_2") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_void_spirit_resonant_damage", {})
end

self:SetStackCount(self.max_shield)

self:CreateWave(self:GetCaster())

self:GetAbility():EndCooldown()
self:GetAbility():SetActivated(false)
end



function modifier_void_spirit_resonant_pulse:OnIntervalThink()
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'void_shield_change',  {hide = 0, max_time = self.max_time, time = self:GetRemainingTime(), damage = self.legendary_damage})

end 


function modifier_void_spirit_resonant_pulse:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_void_spirit_resonant_damage")

if mod then 
	mod:SetDuration(self:GetCaster():GetTalentValue("modifier_void_pulse_2", "duration"), true)
end

self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)

local sound_destroy = "Hero_VoidSpirit.Pulse.Destroy"
self:GetParent():EmitSound(sound_destroy)


if self:GetCaster():HasModifier("modifier_void_pulse_5") then 
	self:GetCaster():Purge(false, true, false, false, false)

	local caster = self:GetCaster()

	Timers:CreateTimer(0.1, function() 
		if caster and not caster:IsNull() and caster:IsAlive() then 
			caster:Purge(false, true, false, false, false)
		end

	end)

	self:GetParent():EmitSound("VoidSpirit.Shield_legendary")

	local effect_cast = ParticleManager:CreateParticle( "particles/void_shield_legen.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(),  true )
	ParticleManager:ReleaseParticleIndex( effect_cast )	

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_void_spirit_resonant_invun", {duration = self:GetCaster():GetTalentValue("modifier_void_pulse_5", "duration")})
end

if self:GetParent():HasModifier("modifier_void_pulse_legendary") then

	self:CreateWave(self:GetParent(), self.legendary_damage)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'void_shield_change',  {hide = 1, max_time = self.max_time, time = self:GetRemainingTime(), damage = self.legendary_damage})


end


end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_void_spirit_resonant_pulse:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end





function modifier_void_spirit_resonant_pulse:GetModifierIncomingDamageConstant( params )
if not self:GetParent():HasModifier("modifier_void_pulse_legendary") then return end

if IsClient() then 
	if params.report_max then 
		return self.max_shield 
	else 
		return self:GetStackCount()
	end 
end

self:PlayEffects5()

if params.damage>=self:GetStackCount() then
	self:Destroy()

	if self:GetParent():GetQuest() == "Void.Quest_7" and params.attacker:IsRealHero() then 
		self:GetParent():UpdateQuest(self:GetStackCount())
	end

	return -self:GetStackCount()
else
	self:SetStackCount(self:GetStackCount()-params.damage)


	if self:GetParent():GetQuest() == "Void.Quest_7" and params.attacker:IsRealHero() then 
		self:GetParent():UpdateQuest(params.damage)
	end

	return -params.damage
end

end




function modifier_void_spirit_resonant_pulse:OnTakeDamage(params)
if not IsServer() then return end 

if not self:GetParent():HasModifier("modifier_void_pulse_legendary") then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if params.unit:IsIllusion() then return end 
if params.damage < 0 then return end

local k = self.legendary_k
local shield_k = self.legendary_k_shield


if params.unit:IsCreep() then 
	shield_k = shield_k*self.legendary_creeps
	k = k*self.legendary_creeps
end 

self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + shield_k*params.damage))

self.legendary_damage = self.legendary_damage + params.damage*k
end 



function modifier_void_spirit_resonant_pulse:GetModifierIncomingPhysicalDamageConstant( params )
if self:GetParent():HasModifier("modifier_void_pulse_legendary") then return end

if IsClient() then 
	if params.report_max then 
		return self.max_shield 
	else 
		return self:GetStackCount()
	end 
end



self:PlayEffects5()

if params.damage>=self:GetStackCount() then
	self:Destroy()

	if self:GetParent():GetQuest() == "Void.Quest_7" and params.attacker:IsRealHero() then 
		self:GetParent():UpdateQuest(self:GetStackCount())
	end

	return -self:GetStackCount()
else
	self:SetStackCount(self:GetStackCount()-params.damage)


	if self:GetParent():GetQuest() == "Void.Quest_7" and params.attacker:IsRealHero() then 
		self:GetParent():UpdateQuest(params.damage)
	end

	return -params.damage
end

end










--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_void_spirit_resonant_pulse:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf"
end

function modifier_void_spirit_resonant_pulse:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_void_spirit_resonant_pulse:PlayEffects1(new_damage)
if not self then return end


	

	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse.vpcf"
	local sound_cast = "Hero_VoidSpirit.Pulse"

	if new_damage then 
			particle_cast =  "particles/void_spirit/pulse_legendary.vpcf"
			sound_cast = "VoidSpirit.Pulse_legendary"
	end 

	-- adjustment
	local radius = self.radius * 2

	-- Create Particle

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt(effect_cast, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)

	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )

	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	self:GetParent():EmitSound(sound_cast)
end

function modifier_void_spirit_resonant_pulse:PlayEffects2()

if not self then return end
	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_buff.vpcf"
	local sound_cast = "Hero_VoidSpirit.Pulse.Cast"

	-- Get Data
	local radius = 130

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	self:GetParent():EmitSound(sound_cast)
end


function modifier_void_spirit_resonant_pulse:PlayEffects3( target )
if not self then return end


	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_impact.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf"
	local sound_cast = "Hero_VoidSpirit.Pulse.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	target:EmitSound(sound_cast)
end

function modifier_void_spirit_resonant_pulse:PlayEffects4( parent, target )
if not self then return end

	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_absorb.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0),  true )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true  )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_void_spirit_resonant_pulse:PlayEffects5()
if not self then return end
	local particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_pulse_shield_deflect.vpcf"

	-- Get Data
	local radius = 100

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end





modifier_void_spirit_resonant_pulse_aura = class({})

function modifier_void_spirit_resonant_pulse_aura:IsHidden() return false end
function modifier_void_spirit_resonant_pulse_aura:IsPurgable() return false end
function modifier_void_spirit_resonant_pulse_aura:IsDebuff() return false end
function modifier_void_spirit_resonant_pulse_aura:GetTexture() return "buffs/astral_burn" end
function modifier_void_spirit_resonant_pulse_aura:RemoveOnDeath() return false end

function modifier_void_spirit_resonant_pulse_aura:OnCreated()

if self:GetParent():IsIllusion() then 
	self:Destroy()
	return
end

self.radius = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "radius", true)
end


function modifier_void_spirit_resonant_pulse_aura:GetAuraRadius()
	return self.radius
end

function modifier_void_spirit_resonant_pulse_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_void_spirit_resonant_pulse_aura:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_void_spirit_resonant_pulse_aura:GetModifierAura()
	return "modifier_void_spirit_resonant_pulse_aura_damage"
end

function modifier_void_spirit_resonant_pulse_aura:IsAura()
	return true
end

function modifier_void_spirit_resonant_pulse_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
--	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}
end

function modifier_void_spirit_resonant_pulse_aura:OnTooltip()

local damage = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "damage")/100

local k = 1
if self:GetParent():HasModifier("modifier_void_spirit_resonant_pulse") then 
	k = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "shield")/100 + 1
end

return (self:GetCaster():GetMaxMana()*damage)*k
end

	

function modifier_void_spirit_resonant_pulse_aura:GetModifierConstantHealthRegen()
if true then return end
if not self:GetParent():HasModifier("modifier_void_spirit_resonant_pulse") then return end

local damage = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "damage")/100
local heal = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "heal")/100
local k = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "shield")/100 + 1


return self:GetCaster():GetMaxMana()*damage*k*heal

end




modifier_void_spirit_resonant_pulse_aura_damage = class({})
function modifier_void_spirit_resonant_pulse_aura_damage:IsHidden() return false end
function modifier_void_spirit_resonant_pulse_aura_damage:IsPurgable() return false end
function modifier_void_spirit_resonant_pulse_aura_damage:GetTexture() return "buffs/astral_burn" end

function modifier_void_spirit_resonant_pulse_aura_damage:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "damage")/100
self.shield = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "shield")/100 + 1
self.interval = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "interval")
self.slow = self:GetCaster():GetTalentValue("modifier_void_pulse_4", "slow")

if not IsServer() then return end
self:StartIntervalThink(self.interval)

end

function modifier_void_spirit_resonant_pulse_aura_damage:OnIntervalThink()
if not IsServer() then return end


local k = 1
if self:GetCaster():HasModifier("modifier_void_spirit_resonant_pulse") then 
	k = self.shield
end

local damage =  (self.interval*self:GetCaster():GetMaxMana()*self.damage)*k 


ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end




function modifier_void_spirit_resonant_pulse_aura_damage:GetEffectName()
	return "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf"
end

function modifier_void_spirit_resonant_pulse_aura_damage:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_void_spirit_resonant_pulse_aura_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_void_spirit_resonant_pulse_aura_damage:GetModifierMoveSpeedBonus_Percentage()
if not self:GetCaster():HasModifier("modifier_void_spirit_resonant_pulse") then return end 

return self.slow
end


function modifier_void_spirit_resonant_pulse_aura_damage:OnTooltip()

local k = 1
if self:GetCaster():HasModifier("modifier_void_spirit_resonant_pulse") then 
	k = self.shield
end

return self:GetCaster():GetMaxMana()*self.damage*k
end





modifier_void_spirit_resonant_pulse_silence = class({})

function modifier_void_spirit_resonant_pulse_silence:IsHidden() return false end
function modifier_void_spirit_resonant_pulse_silence:IsPurgable() return true end
function modifier_void_spirit_resonant_pulse_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
}
end
function modifier_void_spirit_resonant_pulse_silence:GetEffectName() return "particles/units/heroes/hero_brewmaster/brewmaster_void_debuff.vpcf" end
 
function modifier_void_spirit_resonant_pulse_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end







modifier_void_spirit_resonant_invun = class({})
function modifier_void_spirit_resonant_invun:IsHidden() return false end
function modifier_void_spirit_resonant_invun:IsPurgable() return false end
function modifier_void_spirit_resonant_invun:GetTexture() return "buffs/Pulse_reduce" end


function modifier_void_spirit_resonant_invun:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_void_spirit_resonant_invun:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf"
end

function modifier_void_spirit_resonant_invun:StatusEffectPriority()
	return 99999
end


function modifier_void_spirit_resonant_invun:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_void_pulse_5", "damage_reduce")
end


function modifier_void_spirit_resonant_invun:GetModifierIncomingDamage_Percentage()
return self.damage
end



modifier_void_spirit_resonant_damage = class({})
function modifier_void_spirit_resonant_damage:IsHidden() return false end
function modifier_void_spirit_resonant_damage:IsPurgable() return false end
function modifier_void_spirit_resonant_damage:GetTexture() return "buffs/Pulse_damage" end
function modifier_void_spirit_resonant_damage:OnCreated()

self.spell = self:GetCaster():GetTalentValue("modifier_void_pulse_2", "spell")
self.attack = self:GetCaster():GetTalentValue("modifier_void_pulse_2", "attack")
end

function modifier_void_spirit_resonant_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_void_spirit_resonant_damage:GetModifierDamageOutgoing_Percentage()
return self.attack
end


function modifier_void_spirit_resonant_damage:GetModifierSpellAmplify_Percentage()
return self.spell
end


modifier_void_spirit_resonant_slow = class({})
function modifier_void_spirit_resonant_slow:IsHidden() return true end
function modifier_void_spirit_resonant_slow:IsPurgable() return true end
function modifier_void_spirit_resonant_slow:GetTexture() return "buffs/Pulse_slow" end
function modifier_void_spirit_resonant_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end

function modifier_void_spirit_resonant_slow:OnCreated(table)

self.move = self:GetCaster():GetTalentValue("modifier_void_pulse_6", "slow")

end

function modifier_void_spirit_resonant_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_void_spirit_resonant_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move
end







modifier_void_spirit_resonant_damage_tracker = class({})
function modifier_void_spirit_resonant_damage_tracker:IsHidden() return true end
function modifier_void_spirit_resonant_damage_tracker:IsPurgable() return false end
function modifier_void_spirit_resonant_damage_tracker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end




modifier_void_spirit_resonant_tracker = class({})
function modifier_void_spirit_resonant_tracker:IsHidden() return true end
function modifier_void_spirit_resonant_tracker:IsPurgable() return false end
function modifier_void_spirit_resonant_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
}
end




function modifier_void_spirit_resonant_tracker:GetModifierMagicalResistanceBonus()
local bonus = 0

if self:GetParent():HasModifier("modifier_void_pulse_3") then
	bonus = self:GetCaster():GetTalentValue("modifier_void_pulse_3", "magic")

	if self:GetCaster():HasModifier("modifier_void_spirit_resonant_pulse") then 
		bonus = bonus*self:GetCaster():GetTalentValue("modifier_void_pulse_3", "shield")
	end
end

return bonus
end



function modifier_void_spirit_resonant_tracker:GetModifierStatusResistanceStacking()
local bonus = 0

if self:GetParent():HasModifier("modifier_void_pulse_3") then
	bonus = self:GetCaster():GetTalentValue("modifier_void_pulse_3", "status")
	
	if self:GetCaster():HasModifier("modifier_void_spirit_resonant_pulse") then 
		bonus = bonus*self:GetCaster():GetTalentValue("modifier_void_pulse_3", "shield")
	end
end

return bonus
end








function modifier_void_spirit_resonant_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_void_pulse_6") then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end
if not params.attacker:IsCreep() and not params.attacker:IsHero() then return end


local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_void_spirit_resonant_damage_tracker", {duration = self:GetCaster():GetTalentValue("modifier_void_pulse_6", "duration")})

if mod then 
    mod:SetStackCount(params.damage*self:GetCaster():GetTalentValue("modifier_void_pulse_6", "heal")/100)
end

end




modifier_void_spirit_resonant_speed = class({})
function modifier_void_spirit_resonant_speed:IsHidden() return true end
function modifier_void_spirit_resonant_speed:IsPurgable() return false end
function modifier_void_spirit_resonant_speed:GetEffectName() return "particles/void_step_speed.vpcf" end
function modifier_void_spirit_resonant_speed:GetTexture() return "buffs/remnant_speed" end

function modifier_void_spirit_resonant_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_void_spirit_resonant_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_void_spirit_resonant_speed:GetActivityTranslationModifiers()
return "haste"
end


function modifier_void_spirit_resonant_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_void_pulse_6", "speed")
end


