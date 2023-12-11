LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_damage", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_damage_aura", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_bonus", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_shield", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_root", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_charge", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_alchemist_unstable_concoction_custom_charge_effect", "abilities/alchemist/alchemist_unstable_concoction_custom", LUA_MODIFIER_MOTION_NONE)

alchemist_unstable_concoction_custom = class({})
alchemist_unstable_concoction_throw_custom = class({})





function alchemist_unstable_concoction_throw_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf", context )
PrecacheResource( "particle", "particles/alch_stun_legendary.vpcf", context )
PrecacheResource( "particle", "particles/alch_root.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf", context )

end

function alchemist_unstable_concoction_custom:GetBehavior()
local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_unstable_5") then
	bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + bonus
end




function alchemist_unstable_concoction_custom:OnSpellStart()
if not IsServer() then return end

local duration = self:GetSpecialValueFor( "brew_explosion" )
self:GetCaster():StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
local ability = self:GetCaster():FindAbilityByName("alchemist_unstable_concoction_throw_custom")

self:EndCooldown()

if self:GetCaster():HasModifier("modifier_alchemist_unstable_5") and self:GetAutoCastState() == true then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_alchemist_unstable_concoction_custom_charge", {duration = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_5", "duration")})
end 

self:GetCaster():AddNewModifier( self:GetCaster(), ability, "modifier_alchemist_unstable_concoction_custom", { duration = duration } )
end



function alchemist_unstable_concoction_throw_custom:GetCastPoint()

if self:GetCaster():HasModifier("modifier_alchemist_unstable_6") then 
  return 0
end

return self:GetSpecialValueFor("AbilityCastPoint")
end



function alchemist_unstable_concoction_throw_custom:GetAOERadius()
return self:GetSpecialValueFor( "midair_explosion_radius" )
end




function alchemist_unstable_concoction_throw_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_alchemist_unstable_legendary") then
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_POINT 
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_HIDDEN 
end



function alchemist_unstable_concoction_throw_custom:GetCastRange(vLocation, hTarget)
local max_dist = self:GetSpecialValueFor( "throw_distance" )

return max_dist
end



function alchemist_unstable_concoction_throw_custom:OnSpellStart(new_target)
if not IsServer() then return end

local caster = self:GetCaster()

local target
local brew_time = 0

local max_brew = self:GetSpecialValueFor( "brew_time" )
local projectile_speed = self:GetSpecialValueFor( "movement_speed" )
local projectile_vision = self:GetSpecialValueFor( "vision_range" )

if self:GetCursorTarget() ~= nil then 
	target = self:GetCursorTarget()

	if new_target ~= nil then 
		target = new_target
	end

else 
	local unit = CreateUnitByName("npc_dota_companion", self:GetCursorPosition(), false, nil, nil, 0)
	unit:AddNewModifier(unit, nil, "modifier_phased", {})
	unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
	target = unit
end

self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
self:GetCaster():StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION_THROW)

local legendary_damage = 0

local modifier = caster:FindModifierByName( "modifier_alchemist_unstable_concoction_custom" )
if modifier then

	if modifier.legendary_damage ~= 0 then 
		legendary_damage = modifier.legendary_damage
	end

	brew_time = math.min( GameRules:GetGameTime()-modifier:GetCreationTime(), max_brew )
	modifier.explode = true
	modifier:Destroy()
end




if target:IsRealHero() and caster:GetQuest() == "Alch.Quest_6" and brew_time >= caster.quest.number then 
	caster:UpdateQuest(1)
end

local info = {
	Target = target,
	Source = caster,
	Ability = self,	
	iSourceAttachment = self:GetCaster():ScriptLookupAttachment("attach_attack3"),
	EffectName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf",
	iMoveSpeed = projectile_speed,
	bDodgeable = false,                         
	bVisibleToEnemies = true,                   
	bProvidesVision = true,                     
	iVisionRadius = projectile_vision,          
	iVisionTeamNumber = caster:GetTeamNumber(), 
	ExtraData = {
		brew_time = brew_time,
		legendary_damage = legendary_damage,
	}
}
ProjectileManager:CreateTrackingProjectile(info)
self:GetCaster():EmitSound("Hero_Alchemist.UnstableConcoction.Throw")
end


function alchemist_unstable_concoction_throw_custom:OnProjectileHit_ExtraData( target, location, ExtraData )
if not target then return end

self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION_THROW)

local brew_time = ExtraData.brew_time

if target:TriggerSpellAbsorb( self ) then return end

local max_brew = self:GetSpecialValueFor( "brew_time" )
local min_stun = self:GetSpecialValueFor( "min_stun" )
local max_stun = self:GetSpecialValueFor( "max_stun" )
local min_damage = self:GetSpecialValueFor( "min_damage" )
local max_damage = self:GetSpecialValueFor( "max_damage" )
local radius = self:GetSpecialValueFor( "midair_explosion_radius" )


local stun = (brew_time/max_brew)*(max_stun-min_stun) + min_stun
local damage = (brew_time/max_brew)*(max_damage-min_damage) + min_damage


if ExtraData.legendary_damage ~= nil then 
	damage = damage + ExtraData.legendary_damage
end


local damageTable = { attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self, }
local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

for _,enemy in pairs(enemies) do
	damageTable.victim = enemy
	
	if self:GetCaster():HasModifier("modifier_alchemist_unstable_6") then 
		enemy:Purge(true, false, false, false, false)
	end

	local duration = stun*(1 - enemy:GetStatusResistance())

	ApplyDamage( damageTable )
	enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = duration } )

end

target:EmitSound("Hero_Alchemist.UnstableConcoction.Stun")

if target:GetName() == "npc_dota_companion" then 
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	UTIL_Remove(target)
else 
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

end





modifier_alchemist_unstable_concoction_custom = class({})

function modifier_alchemist_unstable_concoction_custom:IsHidden()
	return true
end

function modifier_alchemist_unstable_concoction_custom:IsPurgable()
	return false
end

function modifier_alchemist_unstable_concoction_custom:OnCreated( kv )

self.max_stun = self:GetAbility():GetSpecialValueFor( "max_stun" )
self.max_damage = self:GetAbility():GetSpecialValueFor( "max_damage" )

self.move_speed = self:GetAbility():GetSpecialValueFor("movespeed") + self:GetCaster():GetTalentValue("modifier_alchemist_unstable_1", "speed")
self.status = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_1", "status")

self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

self.legendary_damage = 0
self.legendary_k = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_legendary", "damage")/100
self.legendary_creeps = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_legendary", "damage_creeps")
self.legendary_shield = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_legendary", "shield")/100
self.legendary_duration = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_legendary", "duration")


if self:GetParent():HasModifier("modifier_alchemist_unstable_legendary") then

	self.particle_ally_fx = ParticleManager:CreateParticle("particles/alch_stun_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

end

self.heal_health = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_2", "heal")
self.heal_mana = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_2", "mana")/100

self.damage_delay = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_4", "delay")
self.damage_duration = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_4", "duration")
self.damage_cd = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_4", "cd")

self.dispel = false
self.dispel_delay = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_6", "delay")

self.root_targets = {}
self.root_radius = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_5", "radius")
self.root_duration = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_5", "root")

if not IsServer() then return end
self:SetStackCount(1)

self.max_duration = self:GetRemainingTime()

if self:GetCaster():HasModifier("modifier_alchemist_unstable_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_unstable_concoction_custom_damage", {})
end 

self:GetParent():SwapAbilities( "alchemist_unstable_concoction_custom", "alchemist_unstable_concoction_throw_custom", false, true )
self.tick_interval = 0.1
self.time = self:GetRemainingTime()
self.count = 0

if self:GetCaster():HasModifier("modifier_alchemist_unstable_legendary") then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'alchemist_stun_change',  {hide = 0, max_time = self.time, time = self:GetRemainingTime(), damage = self.legendary_damage})
end 

self.tick = self:GetRemainingTime()
self.tick_halfway = true
self.explode = false
self:StartIntervalThink( self.tick_interval )
self:GetParent():EmitSound("Hero_Alchemist.UnstableConcoction.Fuse")
end



function modifier_alchemist_unstable_concoction_custom:OnIntervalThink()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_alchemist_unstable_legendary") then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'alchemist_stun_change',  {hide = 0, max_time = self.time, time = self:GetRemainingTime(), damage = self.legendary_damage})
end 

self.count = self.count + self.tick_interval

if self:GetCaster():HasModifier("modifier_alchemist_unstable_5") then 
	local targets = self:GetCaster():FindTargets(self.root_radius)

	for _,target in pairs(targets) do 
		if not self.root_targets[target] then 
			self.root_targets[target] = target
			target:EmitSound("Alch.Root_target")
			target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_unstable_concoction_custom_root", {duration = (1 - target:GetStatusResistance())*self.root_duration})
		end 
	end
end 

if self:GetCaster():HasModifier("modifier_alchemist_unstable_4") and self.damage_delay ~= 0 and self:GetElapsedTime() >= self.damage_delay and not self:GetCaster():HasModifier("modifier_alchemist_unstable_concoction_custom_bonus") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_unstable_concoction_custom_bonus", {duration = self.damage_duration})
end 


if self:GetParent():HasModifier("modifier_alchemist_unstable_6") and self:GetElapsedTime() >= self.dispel_delay and self.dispel == false then

	self.dispel = true

	self:GetParent():Purge(false, true, false, true, false)
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( particle )
end



if self.count >= 0.5 then 
	self.count = 0
else 
	return
end 

self.tick = self.tick - 0.5

if self:GetStackCount() < 10 then
	self:IncrementStackCount()
end

if self.tick>0 then

	self.tick_halfway = not self.tick_halfway
	local time = math.floor( self.tick )
	local mid = 1
	if self.tick_halfway then mid = 8 end
	
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, time, mid ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 2, 0, 0 ) )

	if time<1 then
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, 0, 0 ) )
	end

	ParticleManager:ReleaseParticleIndex( effect_cast )
	return
end

end

function modifier_alchemist_unstable_concoction_custom:Concoction_Explode()
if not IsServer() then return end

self.explode = true

local damage_type = DAMAGE_TYPE_PHYSICAL

local damageTable = { attacker = self:GetCaster(), damage = self.max_damage, damage_type = damage_type, ability = self:GetAbility(), }

local flag_units = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
local flag_bonus = 0

local radius =  self:GetAbility():GetSpecialValueFor( "midair_explosion_radius" )

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, flag_units, flag_bonus, 0, false )

for _,enemy in pairs(enemies) do
	damageTable.victim = enemy
	local duration = self.max_stun*(1 - enemy:GetStatusResistance())

	ApplyDamage( damageTable )
	enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_stunned", { duration = duration } )
end

if not self:GetParent():IsInvulnerable() and self:GetParent():IsAlive() and not self:GetParent():IsMagicImmune() then
	damageTable.victim = self:GetParent()
	ApplyDamage( damageTable )
	local duration = self.max_stun*(1 - self:GetParent():GetStatusResistance())
	self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = duration } )
end


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:ReleaseParticleIndex( effect_cast )
self:GetParent():EmitSound("Hero_Alchemist.UnstableConcoction.Stun")
end






function modifier_alchemist_unstable_concoction_custom:OnDestroy()
if not IsServer() then return end

local mod = self:GetCaster():FindModifierByName("modifier_alchemist_unstable_concoction_custom_damage")

if mod then 
	mod:SetDuration(self:GetCaster():GetTalentValue("modifier_alchemist_unstable_3", "duration")*(self:GetElapsedTime()/self.max_duration), true)
end 


local ability = self:GetCaster():FindAbilityByName("alchemist_unstable_concoction_custom")

if ability then 
	ability:UseResources(false, false, false, true)

	if self:GetCaster():HasModifier("modifier_alchemist_unstable_concoction_custom_bonus") then 
		self:GetCaster():CdAbility(ability, self.damage_cd)
	end 

end 


if self:GetCaster():HasModifier("modifier_alchemist_unstable_legendary") then 

	if self.legendary_damage > 0 then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_unstable_concoction_custom_shield", {duration = self.legendary_duration, shield = self.legendary_damage*self.legendary_shield})
	end 

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'alchemist_stun_change',  {hide = 1, max_time = self.time, time = self:GetRemainingTime(), damage = self.legendary_damage})
end 

self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION_THROW)

self:GetParent():StopSound("Hero_Alchemist.UnstableConcoction.Fuse")
self:GetParent():SwapAbilities( "alchemist_unstable_concoction_throw_custom", "alchemist_unstable_concoction_custom", false, true )

if self.explode == false then
	self:Concoction_Explode()
end

end



function modifier_alchemist_unstable_concoction_custom:DeclareFunctions()
local decFuncs = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
}

return decFuncs
end

function modifier_alchemist_unstable_concoction_custom:GetModifierStatusResistanceStacking()
if not self:GetCaster():HasModifier("modifier_alchemist_unstable_1") then return end
return self.status
end



function modifier_alchemist_unstable_concoction_custom:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_alchemist_unstable_legendary") then return end
if not params.attacker then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end 
if params.attacker ~= self:GetParent() and params.unit ~= self:GetParent() then return end
if params.original_damage < 0 then return end

local damage = params.damage*self.legendary_k

if params.unit:IsCreep() then 
	damage = damage*self.legendary_creeps
end 

self.legendary_damage = self.legendary_damage + damage

end



function modifier_alchemist_unstable_concoction_custom:GetModifierHealthRegenPercentage()
if not self:GetCaster():HasModifier("modifier_alchemist_unstable_2") then return end 
return self.heal_health
end

function modifier_alchemist_unstable_concoction_custom:GetModifierConstantManaRegen()
if not self:GetCaster():HasModifier("modifier_alchemist_unstable_2") then return end 
return self.heal_mana*self:GetCaster():GetMaxMana()
end



function modifier_alchemist_unstable_concoction_custom:GetEffectName() 
if not self:GetCaster():HasModifier("modifier_alchemist_unstable_2") then return end 
	return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" 
end



function modifier_alchemist_unstable_concoction_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.move_speed
end














modifier_alchemist_unstable_concoction_custom_damage = class({})

function modifier_alchemist_unstable_concoction_custom_damage:IsHidden() return false end
function modifier_alchemist_unstable_concoction_custom_damage:IsPurgable() return false end
function modifier_alchemist_unstable_concoction_custom_damage:GetTexture() return "buffs/unstable_damage" end


function modifier_alchemist_unstable_concoction_custom_damage:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.damage = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_3", "damage")/100
self.aura_radius = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_3", "radius")
self.burn_interval = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_3", "interval")


self.burn_particle = ParticleManager:CreateParticle( "particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.burn_particle,false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(self.burn_interval)
end






function modifier_alchemist_unstable_concoction_custom_damage:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster():IsAlive() then return end

local enemies = self.parent:FindTargets(self.aura_radius)

local damage = self.parent:GetMaxHealth()*self.damage*self.burn_interval

for _,enemy in pairs(enemies) do 
	local real_damage = ApplyDamage({victim = enemy,  damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self.caster, ability = self:GetAbility()})
end

end



function modifier_alchemist_unstable_concoction_custom_damage:IsAura() return true end

function modifier_alchemist_unstable_concoction_custom_damage:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_alchemist_unstable_concoction_custom_damage:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_alchemist_unstable_concoction_custom_damage:GetModifierAura()
	return "modifier_alchemist_unstable_concoction_custom_damage_aura"
end

function modifier_alchemist_unstable_concoction_custom_damage:GetAuraRadius()
	return self.aura_radius
end


function modifier_alchemist_unstable_concoction_custom_damage:GetAuraDuration()
return 0
end








modifier_alchemist_unstable_concoction_custom_damage_aura = class({})

function modifier_alchemist_unstable_concoction_custom_damage_aura:IsHidden() return true end
function modifier_alchemist_unstable_concoction_custom_damage_aura:IsPurgable() return false end



function modifier_alchemist_unstable_concoction_custom_damage_aura:OnCreated()
if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/econ/events/fall_2022/radiance_target_fall2022.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())
self:AddParticle(self.particle,false, false, -1, false, false)

self:StartIntervalThink(0.5)
end

function modifier_alchemist_unstable_concoction_custom_damage_aura:OnIntervalThink()
if not IsServer() then return end 
if not self.particle then return end


ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())
end 




modifier_alchemist_unstable_concoction_custom_bonus = class({})
function modifier_alchemist_unstable_concoction_custom_bonus:IsHidden() return false end
function modifier_alchemist_unstable_concoction_custom_bonus:IsPurgable() return false end
function modifier_alchemist_unstable_concoction_custom_bonus:GetTexture() return "buffs/unstable_bonus" end
function modifier_alchemist_unstable_concoction_custom_bonus:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_4", "damage")

if not IsServer() then return end 

local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self:GetParent():EmitSound("Lc.Moment_Lowhp")
self.particle = ParticleManager:CreateParticle( "particles/lc_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.particle, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( self.particle, 1, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( self.particle, 2, self:GetParent():GetAbsOrigin() )
self:AddParticle(self.particle, false, false, 0, true, false)
end 


function modifier_alchemist_unstable_concoction_custom_bonus:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,

}
end




function modifier_alchemist_unstable_concoction_custom_bonus:GetModifierSpellAmplify_Percentage()
return self.damage
end



function modifier_alchemist_unstable_concoction_custom_bonus:GetModifierDamageOutgoing_Percentage()
return self.damage
end








modifier_alchemist_unstable_concoction_custom_shield = class({})
function modifier_alchemist_unstable_concoction_custom_shield:IsHidden() return false end
function modifier_alchemist_unstable_concoction_custom_shield:IsPurgable() return false end
function modifier_alchemist_unstable_concoction_custom_shield:OnCreated(table)


if not IsServer() then return end
self.RemoveForDuel = true

self.max_shield = table.shield
self:SetHasCustomTransmitterData(true)
self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.effect,false, false, -1, false, false)
self:SetStackCount(self.max_shield)

end



function modifier_alchemist_unstable_concoction_custom_shield:AddCustomTransmitterData() return {
shield = self.max_shield,

} end

function modifier_alchemist_unstable_concoction_custom_shield:HandleCustomTransmitterData(data)
self.max_shield = data.shield
end




function modifier_alchemist_unstable_concoction_custom_shield:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_alchemist_unstable_concoction_custom_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
     	return self:GetStackCount()
    end 
end

if not IsServer() then return end

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end




modifier_alchemist_unstable_concoction_custom_root = class({})
function modifier_alchemist_unstable_concoction_custom_root:IsHidden() return true end
function modifier_alchemist_unstable_concoction_custom_root:IsPurgable() return true end
function modifier_alchemist_unstable_concoction_custom_root:GetTexture() return "buffs/press_root" end
function modifier_alchemist_unstable_concoction_custom_root:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end
function modifier_alchemist_unstable_concoction_custom_root:GetEffectName() return "particles/alch_root.vpcf" end






modifier_alchemist_unstable_concoction_custom_charge = class({})

function modifier_alchemist_unstable_concoction_custom_charge:IsDebuff() return false end
function modifier_alchemist_unstable_concoction_custom_charge:IsHidden() return true end
function modifier_alchemist_unstable_concoction_custom_charge:IsPurgable() return true end

function modifier_alchemist_unstable_concoction_custom_charge:OnCreated(kv)
if not IsServer() then return end
self:GetParent():StartGesture(ACT_DOTA_RUN)

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_alchemist_unstable_concoction_custom_charge_effect", {duration = 1.4})

self:GetParent():EmitSound("Alch.Unstable_charge")

self.angle = self:GetParent():GetForwardVector():Normalized()

self.distance = self:GetCaster():GetTalentValue("modifier_alchemist_unstable_5", "range") / ( self:GetDuration() / FrameTime())

if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end

end

function modifier_alchemist_unstable_concoction_custom_charge:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
  MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_alchemist_unstable_concoction_custom_charge:GetActivityTranslationModifiers()
    return "haste"
end


function modifier_alchemist_unstable_concoction_custom_charge:GetModifierDisableTurning() return 1 end

function modifier_alchemist_unstable_concoction_custom_charge:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_alchemist_unstable_concoction_custom_charge:StatusEffectPriority() return 100 end

function modifier_alchemist_unstable_concoction_custom_charge:OnDestroy()
if not IsServer() then return end
self:GetParent():InterruptMotionControllers( true )

self:GetParent():FadeGesture(ACT_DOTA_RUN)

local dir = self:GetParent():GetForwardVector()
dir.z = 0
self:GetParent():SetForwardVector(dir)
self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

end


function modifier_alchemist_unstable_concoction_custom_charge:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
local pos = self:GetParent():GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(pos, 80, false)
local pos_p = self.angle * self.distance
local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
self:GetParent():SetAbsOrigin(next_pos)


end

function modifier_alchemist_unstable_concoction_custom_charge:OnHorizontalMotionInterrupted()
    self:Destroy()
end

modifier_alchemist_unstable_concoction_custom_charge_effect = class({})
function modifier_alchemist_unstable_concoction_custom_charge_effect:IsPurgable() return false end
function modifier_alchemist_unstable_concoction_custom_charge_effect:IsHidden() return true end
function modifier_alchemist_unstable_concoction_custom_charge_effect:GetEffectName() return "particles/econ/events/ti10/phase_boots_ti10.vpcf" end