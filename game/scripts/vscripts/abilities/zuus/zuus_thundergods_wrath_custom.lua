LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_slow", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_kills", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_kills_tracker", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_vision", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_legendary_thinker", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_legendary_teleport", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_cloud", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_shield", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_thundergods_wrath_custom_tracker", "abilities/zuus/zuus_thundergods_wrath_custom", LUA_MODIFIER_MOTION_NONE)
zuus_thundergods_wrath_custom = class({})

function zuus_thundergods_wrath_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf", context )
PrecacheResource( "particle","particles/generic_gameplay/generic_break.vpcf", context )
PrecacheResource( "particle","particles/rare_orb_patrol.vpcf", context )
PrecacheResource( "particle","particles/zuus_wrath_kill.vpcf", context )
PrecacheResource( "particle","particles/zeus_wrath_cloud.vpcf", context )
PrecacheResource( "particle","particles/zuus_wrath_legendary.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zeus/zeus_cloud.vpcf", context )
PrecacheResource( "particle","particles/zeus_landing.vpcf", context )
PrecacheResource( "particle","particles/zeus_blinks_start.vpcf", context )
PrecacheResource( "particle","particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", context )
PrecacheResource( "particle","particles/zeus_wrath_end.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_static_field.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_mjollnir_shield.vpcf", context )

end


function zuus_thundergods_wrath_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_zuus_arcana_custom") then
    return "zuus_thundergods_wrath_alt1"
end 
return "zuus_thundergods_wrath"
end

function zuus_thundergods_wrath_custom:GetCooldown(iLevel)
return self.BaseClass.GetCooldown(self, iLevel)
end

function zuus_thundergods_wrath_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_zuus_thundergods_wrath_custom_tracker"
end


function zuus_thundergods_wrath_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("damage_range")
end


function zuus_thundergods_wrath_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_zuus_wrath_4") then 
    bonus = self:GetCaster():GetTalentValue("modifier_zuus_wrath_4", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function zuus_thundergods_wrath_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()

local precast_sound = "Hero_Zuus.GodsWrath.PreCast"
local particle_start = "particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf"
if caster:HasModifier("modifier_zuus_arcana_custom") then
    precast_sound = "Hero_Zuus.GodsWrath.PreCast.Arcana"
    particle_start = "particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath_start.vpcf"
end

if caster:HasModifier("modifier_zuus_arcana_custom") then
    self.thundergod_spell_cast = ParticleManager:CreateParticle(particle_start, PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControlEnt(self.thundergod_spell_cast, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(self.thundergod_spell_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(self.thundergod_spell_cast, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt(self.thundergod_spell_cast, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), false)
    ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 6, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
else
    self.thundergod_spell_cast = ParticleManager:CreateParticle(particle_start, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.thundergod_spell_cast, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetOrigin(), true )
end

caster:EmitSound(precast_sound)
return true
end


function zuus_thundergods_wrath_custom:OnAbilityPhaseInterrupted()
if self.thundergod_spell_cast then
	ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
	ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
end

end


function zuus_thundergods_wrath_custom:GetWrathDamage(target)
if not IsServer() then return end
if not target or target:IsNull() then return end 
local caster = self:GetCaster()
local bonus = 0
if caster:HasTalent("modifier_zuus_wrath_2") then 
	bonus = target:GetMaxHealth()*caster:GetTalentValue("modifier_zuus_wrath_2", "damage")/100
	if target:IsCreep() then 
		bonus = math.min(bonus, caster:GetTalentValue("modifier_zuus_wrath_2", "creeps"))
	end
end
return self:GetSpecialValueFor("damage") + bonus
end


function zuus_thundergods_wrath_custom:OnSpellStart() 
local caster = self:GetCaster()

if self.thundergod_spell_cast then
	ParticleManager:DestroyParticle(self.thundergod_spell_cast, false)
	ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
end

local sight_duration = caster:HasTalent("modifier_zuus_wrath_7") and caster:GetTalentValue("modifier_zuus_wrath_7", "duration") or self:GetSpecialValueFor("sight_duration")
caster:RemoveModifierByName("modifier_zuus_thundergods_wrath_custom_vision")
caster:AddNewModifier(caster, self, "modifier_zuus_thundergods_wrath_custom_vision", {duration = sight_duration})

EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Zuus.GodsWrath", caster)

if caster:HasTalent("modifier_zuus_wrath_7") then
	return 
end

self:DealDamage()
end


function zuus_thundergods_wrath_custom:DealDamage() 

local caster = self:GetCaster()
local damage_radius = self:GetSpecialValueFor("damage_range")
local damage_reduction = self:GetSpecialValueFor("damage_reduction")/100

local position = caster:GetAbsOrigin()	

if caster:HasTalent("modifier_zuus_wrath_1") then 
	caster:AddNewModifier(caster, self, "modifier_zuus_thundergods_wrath_custom_shield", {duration = caster:GetTalentValue("modifier_zuus_wrath_1", "duration")})
end

local silence_duration = caster:GetTalentValue("modifier_zuus_wrath_4", "silence", true)

caster:AddNewModifier(caster, self, "modifier_zuus_thundergods_wrath_custom_kills_tracker", {duration = caster:GetTalentValue("modifier_zuus_hero_8", "duration", true)})

local units = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
local hit = false
local mod = caster:FindModifierByName("modifier_zuus_heavenly_jump_custom_passive")

for _,hero in pairs(units) do
	if (hero:IsRealHero() or (hero:IsCreep() and (hero:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() <= self:GetSpecialValueFor("creeps_range")))
	 and not hero:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and hero:IsUnit() and not caster:DuelRestrict(hero) then 

		local target_point = hero:GetAbsOrigin()
		local vStartPosition = target_point + Vector(0,0,4000)

        if caster:HasModifier("modifier_zuus_arcana_custom") then
            local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, hero )
            ParticleManager:SetParticleControl( nFXIndex, 0, vStartPosition )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 6, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
            ParticleManager:ReleaseParticleIndex( nFXIndex )

            if hero:IsHero() then 
	            local nFXIndex2 = ParticleManager:CreateParticle("particles/zeus/arcana_ulti.vpcf", PATTACH_CUSTOMORIGIN, hero )
	            ParticleManager:SetParticleControlEnt( nFXIndex2, 0, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true )
	            ParticleManager:SetParticleControlEnt( nFXIndex2, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true )
	            ParticleManager:SetParticleControlEnt( nFXIndex2, 2, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true )
	            ParticleManager:ReleaseParticleIndex( nFXIndex2 )
	        end
        else
            local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, hero )
            ParticleManager:SetParticleControl( nFXIndex, 0, vStartPosition )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, hero, PATTACH_POINT_FOLLOW, "attach_hitloc", hero:GetOrigin(), true )
            ParticleManager:DestroyParticle(nFXIndex, false)
            ParticleManager:ReleaseParticleIndex( nFXIndex )
        end

		local damage = self:GetWrathDamage(hero)
		local damage_table = {attacker = caster, damage = damage, ability = self, damage_type = DAMAGE_TYPE_MAGICAL }

		if (not hero:IsInvulnerable() and not hero:IsOutOfGame() and (not hero:IsInvisible() or caster:CanEntityBeSeenByMyTeam(hero))) then

			damage_table.victim  = hero

			if caster:HasTalent("modifier_zuus_wrath_4") then 
				hero:AddNewModifier(caster, self, "modifier_zuus_thundergods_wrath_custom_slow", {duration = (1 - hero:GetStatusResistance())*silence_duration})
			end 

			local k = (hero:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() > damage_radius and damage_reduction or 1
			damage_table.damage = damage*k

			local static = caster:FindModifierByName("modifier_zuus_innate_custom") 
			if static then 
				static:DealDamage(hero)
			end

			if mod then
				if not hit then
					hit = true
					mod:LegendaryStack(true)
				end
				mod:PassiveProc(hero)
			end
			DoDamage(damage_table)
		end

		hero:EmitSound("Hero_Zuus.GodsWrath.Target")
	end
end	

end





modifier_zuus_thundergods_wrath_custom_slow = class({})
function modifier_zuus_thundergods_wrath_custom_slow:IsHidden() return true end 
function modifier_zuus_thundergods_wrath_custom_slow:IsPurgable() return true end
function modifier_zuus_thundergods_wrath_custom_slow:GetTexture() return "buffs/wrath_slow" end
function modifier_zuus_thundergods_wrath_custom_slow:GetEffectName() return "particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf" end
function modifier_zuus_thundergods_wrath_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_zuus_thundergods_wrath_custom_slow:OnCreated(table)
self.slow = self:GetCaster():GetTalentValue("modifier_zuus_wrath_4", "slow")
if not IsServer() then return end
self:GetParent():GenericParticle("particles/generic_gameplay/generic_silenced.vpcf", self, true)
end

function modifier_zuus_thundergods_wrath_custom_slow:GetModifierMoveSpeedBonus_Percentage() 
return self.slow
end

function modifier_zuus_thundergods_wrath_custom_slow:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
}
end









modifier_zuus_thundergods_wrath_custom_kills = class({})
function modifier_zuus_thundergods_wrath_custom_kills:IsHidden() return not self.parent:HasTalent("modifier_zuus_hero_8") or self:GetStackCount() >= self.max end
function modifier_zuus_thundergods_wrath_custom_kills:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_kills:RemoveOnDeath() return false end
function modifier_zuus_thundergods_wrath_custom_kills:GetTexture() return "buffs/wrath_kills" end
function modifier_zuus_thundergods_wrath_custom_kills:OnCreated(table)

self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_zuus_hero_8", "max", true)
self.damage = self.parent:GetTalentValue("modifier_zuus_hero_8", "damage", true)

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(0.5)
end


function modifier_zuus_thundergods_wrath_custom_kills:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_zuus_hero_8") then return end 

if self:GetStackCount() >= self.max then 
	self.parent:EmitSound("BS.Thirst_legendary_active")
	self.parent:GenericParticle("particles/rare_orb_patrol.vpcf")
	self:StartIntervalThink(-1)
end

end


function modifier_zuus_thundergods_wrath_custom_kills:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then  return end
self:IncrementStackCount()
end


function modifier_zuus_thundergods_wrath_custom_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end


function modifier_zuus_thundergods_wrath_custom_kills:GetModifierSpellAmplify_Percentage()
if not self.parent:HasTalent("modifier_zuus_hero_8") then return end
return self.damage*self:GetStackCount()
end






modifier_zuus_thundergods_wrath_custom_kills_tracker = class({})
function modifier_zuus_thundergods_wrath_custom_kills_tracker:IsHidden() return true end
function modifier_zuus_thundergods_wrath_custom_kills_tracker:IsPurgable() return false end


function modifier_zuus_thundergods_wrath_custom_kills_tracker:OnCreated()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self, true)
self.ability = self:GetAbility()
end

function modifier_zuus_thundergods_wrath_custom_kills_tracker:DeathEvent(params)
if not IsServer() then return end
local attacker = params.attacker
if attacker.owner then 
	attacker = attacker.owner
end

if attacker ~= self.parent then return end
if not params.unit:IsValidKill(attacker) then return end

if self.parent:GetQuest() == "Zuus.Quest_8" then 
	self.parent:UpdateQuest(1)
end

local particle = ParticleManager:CreateParticle("particles/zuus_wrath_kill.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( particle, 0, params.unit:GetAbsOrigin() )
ParticleManager:SetParticleControl( particle, 1, params.unit:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)

self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_thundergods_wrath_custom_kills", {})
end





modifier_zuus_thundergods_wrath_custom_vision = class({})
function modifier_zuus_thundergods_wrath_custom_vision:IsHidden() return not self.parent:HasTalent("modifier_zuus_wrath_7") end
function modifier_zuus_thundergods_wrath_custom_vision:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_vision:RemoveOnDeath() return false end
function modifier_zuus_thundergods_wrath_custom_vision:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end
self.RemoveForDuel = true

self.interval = 0.2
self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")

if self.parent:HasTalent("modifier_zuus_wrath_7") and not self.ability:IsHidden() then
	self.parent:SwapAbilities(self.ability:GetName(), "zuus_thundergods_wrath_custom_legendary", false, true)
end

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_zuus_thundergods_wrath_custom_vision:OnIntervalThink()
if not IsServer() then return end

for _,player in pairs(players) do
	if player:GetTeamNumber() ~= self.parent:GetTeamNumber() and player:IsAlive() then
		AddFOWViewer(self.parent:GetTeamNumber(), player:GetAbsOrigin(), self.vision_radius, self.interval*2, false)
		player:AddNewModifier(self.parent, self.ability, "modifier_truesight", {duration = self.interval*2})
	end
end 

end


function modifier_zuus_thundergods_wrath_custom_vision:OnDestroy()
if not IsServer() then return end

if self.parent:HasTalent("modifier_zuus_wrath_7") and self.ability:IsHidden() then
	self.parent:SwapAbilities(self.ability:GetName(), "zuus_thundergods_wrath_custom_legendary", true, false)
end

end





zuus_thundergods_wrath_custom_legendary = class({})

function zuus_thundergods_wrath_custom_legendary:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_zuus_wrath_4") then 
    bonus = self:GetCaster():GetTalentValue("modifier_zuus_wrath_4", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function zuus_thundergods_wrath_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local heroes = FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

local position = caster:GetAbsOrigin()
local target = caster

for _,hero in pairs(heroes) do 
	if hero:IsRealHero() and not hero:IsTempestDouble() and not caster:DuelRestrict(hero) then 
		target = hero
		position = hero:GetAbsOrigin()
		break
	end
end

local ability = caster:FindAbilityByName("zuus_thundergods_wrath_custom")
if ability then
	ability:DealDamage()
	caster:RemoveModifierByName("modifier_zuus_thundergods_wrath_custom_vision")
end

CreateModifierThinker(caster, self, "modifier_zuus_thundergods_wrath_custom_legendary_thinker", {duration = caster:GetTalentValue("modifier_zuus_wrath_7", "delay"), target = target:entindex()}, position, caster:GetTeamNumber(), false)
end



modifier_zuus_thundergods_wrath_custom_legendary_thinker = class(mod_hidden)
function modifier_zuus_thundergods_wrath_custom_legendary_thinker:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.target = EntIndexToHScript(table.target)

self.wrath_ability = self.caster:FindAbilityByName("zuus_thundergods_wrath_custom")
self.radius = self.ability:GetSpecialValueFor("aoe")
self.speed = self.ability:GetSpecialValueFor("speed")
self.delay = self.caster:GetTalentValue("modifier_zuus_wrath_7", "delay")
self.stun = self.caster:GetTalentValue("modifier_zuus_wrath_7", "stun")
self.damage = self.caster:GetTalentValue("modifier_zuus_wrath_7", "damage")/100

local point = self.parent:GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(point, self.radius, true)

self.caster:AddNewModifier(self.caster, self.ability, "modifier_zuus_thundergods_wrath_custom_legendary_teleport", {duration = self.delay})

self.caster:SetAbsOrigin(point)

local effect_cast = ParticleManager:CreateParticle( "particles/zuus_wrath_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( effect_cast, 0, point )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
self:AddParticle(effect_cast, false, false, -1, false, false )

self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/zeus/arc_legendary_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, point)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Zuus.Wrath_legendary_aoe", self.caster)

self.interval = 0.03
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_zuus_thundergods_wrath_custom_legendary_thinker:OnIntervalThink()
if not IsServer() then return end
if not self.target or self.target:IsNull() or not self.target:IsAlive() then return end
local vec = self.target:GetAbsOrigin() - self.parent:GetAbsOrigin()

if vec:Length2D() <= 50 then return end
local dist = vec:Normalized()*self.speed*self.interval
self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + dist)
self.caster:SetAbsOrigin(self.parent:GetAbsOrigin())
end



function modifier_zuus_thundergods_wrath_custom_legendary_thinker:OnDestroy()
if not IsServer() then return end

FindClearSpaceForUnit(self.caster, self.parent:GetAbsOrigin(), true)
EmitSoundOnLocationWithCaster( self.parent:GetAbsOrigin(), "Zuus.Wrath_legendary_impact", self.caster )
self.parent:EmitSound("Hero_Zuus.GodsWrath.Target")

local damage_table = {attacker = self.caster, damage = damage, ability = self.wrath_ability, damage_type = DAMAGE_TYPE_MAGICAL }

for _,unit in pairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())) do

	local target_point = unit:GetAbsOrigin()
	local vStartPosition = target_point + Vector(0,0,4000)

	local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, unit )
	ParticleManager:SetParticleControl( nFXIndex, 0, vStartPosition )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex)

	EmitSoundOnLocationWithCaster(target_point, "Hero_Zuus.LightningBolt", self.caster)
	unit:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = (1 - unit:GetStatusResistance())*self.stun})

	if self.wrath_ability and self.wrath_ability:IsTrained() then
		local static = self.caster:FindModifierByName("modifier_zuus_innate_custom") 
		if static then 
			static:DealDamage(unit)
		end
		damage_table.damage = self.wrath_ability:GetWrathDamage(unit)*self.damage
		damage_table.victim = unit
		DoDamage(damage_table, "modifier_zuus_wrath_7")
	end
end

local target_point = self.caster:GetAbsOrigin()
local vStartPosition = target_point + Vector(0,0,4000)

local nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_CUSTOMORIGIN, self.caster )
ParticleManager:SetParticleControl( nFXIndex, 0, vStartPosition )
ParticleManager:SetParticleControlEnt( nFXIndex, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( nFXIndex )

local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle2, 0, vStartPosition)
ParticleManager:SetParticleControl(particle2, 1, self.caster:GetOrigin())
ParticleManager:ReleaseParticleIndex(particle2)

local line_position = self.caster:GetAbsOrigin() + self.caster:GetForwardVector() * self:GetAbility():GetSpecialValueFor("aoe")
local max = 5
for i = 1, max do
	local qangle = QAngle(0, 360/max, 0)
	line_position = RotatePosition(self.parent:GetAbsOrigin() , qangle, line_position)
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, Vector(line_position.x, line_position.y, 3000))
	ParticleManager:SetParticleControl(particle, 1, Vector(line_position.x, line_position.y, line_position.z))
	ParticleManager:ReleaseParticleIndex(particle)
end

local part = ParticleManager:CreateParticle("particles/zeus_wrath_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part, 0, self.caster:GetAbsOrigin())
ParticleManager:SetParticleControl(part, 1, self.caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(part)

local effect_cast = ParticleManager:CreateParticle( "particles/zeus_landing.vpcf", PATTACH_WORLDORIGIN,  nil )
ParticleManager:SetParticleControl( effect_cast, 0, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, self.caster:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
ParticleManager:ReleaseParticleIndex( effect_cast )
end


modifier_zuus_thundergods_wrath_custom_legendary_teleport = class({})
function modifier_zuus_thundergods_wrath_custom_legendary_teleport:IsHidden() return true end
function modifier_zuus_thundergods_wrath_custom_legendary_teleport:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_legendary_teleport:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.parent = self:GetParent()
self.parent:AddNoDraw()
self.parent:NoDraw(self)

AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), 500, 3, false)

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Zuus.Wrath_legendary_start", self.parent)
EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Zuus.Wrath_legendary_start_2", self.parent)

local part = ParticleManager:CreateParticle("particles/zeus_blinks_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(part, 1, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(part)

local part2 = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(part2, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(part2, 1, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(part2)
end


function modifier_zuus_thundergods_wrath_custom_legendary_teleport:CheckState()
return
{
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
}
end


function modifier_zuus_thundergods_wrath_custom_legendary_teleport:OnDestroy()
if not IsServer() then return end
self.parent:RemoveNoDraw()
self.parent:StartGesture(ACT_DOTA_SPAWN)
end




modifier_zuus_thundergods_wrath_custom_shield = class(mod_visible)
function modifier_zuus_thundergods_wrath_custom_shield:GetTexture() return "buffs/laguna_shield" end
function modifier_zuus_thundergods_wrath_custom_shield:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_zuus_thundergods_wrath_custom_shield:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_zuus_thundergods_wrath_custom_shield:OnCreated(table)

self.parent = self:GetParent()
self.shield_talent = "modifier_zuus_wrath_1"
self.max_shield = self.parent:GetTalentValue("modifier_zuus_wrath_1", "shield") + self.parent:GetTalentValue("modifier_zuus_wrath_1", "health")*self.parent:GetMaxHealth()/100

if not IsServer() then return end
self.RemoveForDuel = true

local shield_size = self.parent:GetModelRadius() 
local common_vector = Vector(shield_size,0,shield_size)

local particle = ParticleManager:CreateParticle("particles/zuus_shield_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle, 1, common_vector)
ParticleManager:SetParticleControl(particle, 2, common_vector)
ParticleManager:SetParticleControl(particle, 4, common_vector)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)

self.parent:EmitSound("DOTA_Item.Mjollnir.Loop")
self:SetStackCount(self.max_shield)
end

function modifier_zuus_thundergods_wrath_custom_shield:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("DOTA_Item.Mjollnir.Loop")
self.parent:EmitSound("DOTA_Item.Mjollnir.DeActivate")
end

function modifier_zuus_thundergods_wrath_custom_shield:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_zuus_thundergods_wrath_custom_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
     	return self:GetStackCount()
    end 
end

if not IsServer() then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end







modifier_zuus_thundergods_wrath_custom_tracker = class({})
function modifier_zuus_thundergods_wrath_custom_tracker:IsHidden() return true end
function modifier_zuus_thundergods_wrath_custom_tracker:IsPurgable() return false end
function modifier_zuus_thundergods_wrath_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end


function modifier_zuus_thundergods_wrath_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.cdr = self.parent:GetTalentValue("modifier_zuus_hero_8", "cdr", true)

self.cloud_chance = self.parent:GetTalentValue("modifier_zuus_wrath_3", "chance", true)
self.cloud_duration = self.parent:GetTalentValue("modifier_zuus_wrath_3", "duration", true)

if not IsServer() then return end
self:UpdateTalent()
end

function modifier_zuus_thundergods_wrath_custom_tracker:GetModifierPercentageCooldown()
if not self.parent:HasTalent("modifier_zuus_hero_8") then return end
return self.cdr 
end

function modifier_zuus_thundergods_wrath_custom_tracker:UpdateTalent(name)

if name == "modifier_zuus_wrath_3" or self.parent:HasTalent("modifier_zuus_wrath_3") then
	self.parent:AddSpellEvent(self, true)
end

end

function modifier_zuus_thundergods_wrath_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if not self.parent:HasTalent("modifier_zuus_wrath_3") then return end
if params.unit ~= self.parent then return end
if params.ability:IsItem() then return end

local random = RollPseudoRandomPercentage(self.cloud_chance, 78, self.parent)
if not random then return end

self.parent:EmitSound("Zuus.Wrath_cloud")
self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_thundergods_wrath_custom_cloud", {duration = self.cloud_duration})
end





modifier_zuus_thundergods_wrath_custom_cloud = class(mod_visible)
function modifier_zuus_thundergods_wrath_custom_cloud:GetTexture() return "buffs/wrath_cloud" end
function modifier_zuus_thundergods_wrath_custom_cloud:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.lifesteal = self.parent:GetTalentValue("modifier_zuus_wrath_3", "heal")/100
self.lifesteal_creeps = self.parent:GetTalentValue("modifier_zuus_wrath_3", "heal_creeps", true)
self.radius = self.parent:GetTalentValue("modifier_zuus_wrath_3", "radius")
self.damage = self.parent:GetTalentValue("modifier_zuus_wrath_3", "damage")/100

local target_point = self:GetParent():GetAbsOrigin()

self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/zeus_wrath_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)	
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, self.parent:GetAbsOrigin())
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

self.min_interval = 0.1
self.interval = 1 - FrameTime()

self.damageTable = {attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL }
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_zuus_thundergods_wrath_custom_cloud:OnIntervalThink()
if not IsServer() then return end

local units = self.parent:FindTargets(self.radius)
local total_damage = 0

if #units > 0 then 
	for _,unit in pairs(units) do 

		self.damageTable.victim = unit
		self.damageTable.damage = self.damage*self.ability:GetWrathDamage(unit)

		local real_damage = DoDamage(self.damageTable, "modifier_zuus_wrath_3")
		real_damage = unit:IsCreep() and real_damage/self.lifesteal_creeps or real_damage
		if not unit:IsIllusion() then
			total_damage = total_damage + real_damage
		end

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_OVERHEAD_FOLLOW, "attach_spawn", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:DestroyParticle(particle, false)	
		ParticleManager:ReleaseParticleIndex(particle)

		unit:GenericParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf")
		unit:EmitSound("Hero_Zuus.StaticField")
	end

	EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Zuus.Wrath_cloud_ground", self.parent)
	self:StartIntervalThink(self.interval)
else 
	self:StartIntervalThink(self.min_interval)
end

if total_damage > 0 then
	self.parent:GenericHeal(self.lifesteal*total_damage, self.ability, true, nil, "modifier_zuus_wrath_3")
end

end



