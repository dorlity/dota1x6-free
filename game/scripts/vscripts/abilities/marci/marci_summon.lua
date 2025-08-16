LinkLuaModifier( "modifier_marci_summon_tracker", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_disarm", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_luna_aura", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_luna_aura_damage", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_dragon_blood", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_dragon_blood_debuff", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_luna_glaive", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_mirana_starfall", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_mirana_starfall_aura", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_dragon_knight_cd", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_mirana_cd", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_damage_cd", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )


marci_summon_mirana = class({})


function marci_summon_mirana:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end


PrecacheResource( "particle", "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/sange_maim.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/dragon_knight/dk_persona/dk_persona_dragon_tail.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/jugg_agility_boost.vpcf", context )

end





function marci_summon_mirana:OnSpellStart()
if not IsServer() then return end
local next_name = "marci_summon_dragon_knight"

self:GetCaster():SwapAbilities(self:GetName(), next_name, false, true)
self:GetCaster():FindAbilityByName(next_name):StartCooldown(0.4)

self:SummonFriend("npc_marci_summon_mirana", self)

end


function marci_summon_mirana:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
if hTarget==nil then return end

local caster = self:GetCaster()

local origin = Vector( extraData.originX, extraData.originY, extraData.originZ )
local distance = (vLocation-origin):Length2D()
local bonus_pct = math.min(1,distance/extraData.max_distance)

local damageTable = {
	victim = hTarget,
	attacker = caster,
	damage = extraData.damage,
	damage_type = DAMAGE_TYPE_MAGICAL,
	ability = self,
}
DoDamage(damageTable)

hTarget:AddNewModifier( caster, self, "modifier_stunned", { duration = math.max(extraData.min_stun, extraData.max_stun*bonus_pct)*(1 - hTarget:GetStatusResistance()) } )
AddFOWViewer( caster:GetTeamNumber(), vLocation, 500, 3, false )

hTarget:EmitSound("Hero_Mirana.ArrowImpact")

return true
end



function marci_summon_mirana:SummonFriend(name, ability)
if not IsServer() then return end
local caster = self:GetCaster()
local health = 100
local friends = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false)

for _,friend in pairs(friends) do 
	if friend.MacriSummon then 
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl(particle, 0, friend:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( particle )
		health = friend:GetHealthPercent()
		UTIL_Remove(friend)
	end
end	

caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
local point = caster:GetAbsOrigin() - caster:GetForwardVector()*200

local unit = CreateUnitByName(name, point, true, caster, caster, caster:GetTeamNumber())
unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
unit.MacriSummon = true 


unit.owner = caster
unit:EmitSound("Marci.Sidekick_summon")
Timers:CreateTimer(1.35, function() 
	if unit and not unit:IsNull() then 
		unit:EmitSound(name.."_spawn")
	end
end)


for abilitySlot = 0,5 do
	local ability = unit:GetAbilityByIndex(abilitySlot)

	if ability ~= nil then
		ability:SetLevel(1)
		if ability:GetName() == "marci_summon_dragon_knight_dispell" and caster:HasModifier("modifier_marci_summon_dragon_knight_cd") then 
			ability:StartCooldown(caster:FindModifierByName("modifier_marci_summon_dragon_knight_cd"):GetRemainingTime())
		end
		if ability:GetName() == "marci_summon_mirana_arrow" and caster:HasModifier("modifier_marci_summon_mirana_cd") then 
			ability:StartCooldown(caster:FindModifierByName("modifier_marci_summon_mirana_cd"):GetRemainingTime())
		end
	end
end


local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )


unit:AddNewModifier(caster, ability, "modifier_marci_summon_tracker", {health = health})
end





marci_summon_dragon_knight = class({})



function marci_summon_dragon_knight:OnSpellStart()
if not IsServer() then return end

local main = self:GetCaster():FindAbilityByName("marci_summon_mirana")
local next_name = "marci_summon_luna"

self:GetCaster():SwapAbilities(self:GetName(), next_name, false, true)
self:GetCaster():FindAbilityByName(next_name):StartCooldown(0.4)
main:SummonFriend("npc_marci_summon_dragon_knight", self)
end


marci_summon_luna = class({})

function marci_summon_luna:OnSpellStart()
if not IsServer() then return end


local main = self:GetCaster():FindAbilityByName("marci_summon_mirana")
local next_name = "marci_summon_mirana"

self:GetCaster():SwapAbilities(self:GetName(), next_name, false, true)
self:GetCaster():FindAbilityByName(next_name):StartCooldown(0.4)

main:SummonFriend("npc_marci_summon_luna", self)
end





modifier_marci_summon_tracker = class({})
function modifier_marci_summon_tracker:IsHidden() return true end
function modifier_marci_summon_tracker:IsPurgable() return false end
function modifier_marci_summon_tracker:OnCreated(table)

self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.parent:AddDamageEvent_inc(self)

self.damage = self.ability:GetSpecialValueFor("stats_damage")
self.health = self.ability:GetSpecialValueFor("stats_health")
self.armor = self.caster:GetPhysicalArmorValue(false)*self:GetAbility():GetSpecialValueFor("armor")/100
self.speed = self.ability:GetSpecialValueFor("stats_speed")*self.caster:GetLevel()
self.status = self.ability:GetSpecialValueFor("stats_status")

self.damage_cd = self.caster:GetTalentValue("modifier_marci_sidekick_7", "damage_cd")
self.damage_regen = self.caster:GetTalentValue("modifier_marci_sidekick_7", "regen")

if not IsServer() then return end

local stat = 0

if self.ability:GetName() == "marci_summon_mirana" then 
	stat = self.caster:GetIntellect(false)
end

if self.ability:GetName() == "marci_summon_dragon_knight" then 
	stat = self.caster:GetStrength()
end
if self.ability:GetName() == "marci_summon_luna" then 
	stat = self.caster:GetAgility()
end

self.death_cd = 10

local damage = self.parent:GetBaseDamageMax() + stat*self.damage

self.change_health = self.caster:GetLevel()*self.health + 99

self.parent:SetBaseDamageMin(damage)
self.parent:SetBaseDamageMax(damage)

self.health_percent = table.health

self:SetHasCustomTransmitterData(true)
self:StartIntervalThink(FrameTime())
end

function modifier_marci_summon_tracker:GetModifierExtraHealthBonus()
return self.change_health
end


function modifier_marci_summon_tracker:OnIntervalThink()
if not IsServer() then return end

if self.health_percent then
	self.parent:SetHealth(math.max(0, self.parent:GetMaxHealth()*self.health_percent/100))
	self.health_percent = nil
end

if not self.heal_particle and not self.caster:HasModifier("modifier_marci_summon_damage_cd") then
	self.heal_particle = self.parent:GenericParticle("particles/units/heroes/hero_juggernaut/jugg_agility_boost.vpcf", self)
end 

if self.heal_particle and self.caster:HasModifier("modifier_marci_summon_damage_cd") then
	ParticleManager:DestroyParticle(self.heal_particle, false)
	ParticleManager:ReleaseParticleIndex(self.heal_particle)
	self.heal_particle = nil
end


if (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= 1500 and self.parent:HasModifier("modifier_marci_summon_disarm") then 
	self.parent:RemoveModifierByName("modifier_marci_summon_disarm")
end


if (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > 1500 and not self.parent:HasModifier("modifier_marci_summon_disarm") then 
	self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_marci_summon_disarm", {})
end

self:StartIntervalThink(0.3)
end


function modifier_marci_summon_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING

}
end


function modifier_marci_summon_tracker:GetModifierHealthRegenPercentage()
if not self.caster or self.caster:HasModifier("modifier_marci_summon_damage_cd") then
	return 0
end
return self.damage_regen
end

function modifier_marci_summon_tracker:GetModifierStatusResistanceStacking()
return self.status
end

function modifier_marci_summon_tracker:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_marci_summon_tracker:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_marci_summon_tracker:GetModifierMoveSpeedBonus_Constant()
return self.movespeed
end


function modifier_marci_summon_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if not params.attacker then return end
if self.parent ~= params.unit then return end 
if not self.parent:IsAlive() then return end

self.caster:AddNewModifier(self.caster, self.ability, "modifier_marci_summon_damage_cd", {duration = self.damage_cd})
end


function modifier_marci_summon_tracker:DeathEvent(params)
if not IsServer() then return end

if self.parent.owner == params.unit then 

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex( particle )
	UTIL_Remove(self.parent)
	return
end


if self.parent ~= params.unit then return end 

self.parent:EmitSound(self.parent:GetUnitName().."_death")

self:StartCD("marci_summon_mirana", self.death_cd)
self:StartCD("marci_summon_luna", self.death_cd)
self:StartCD("marci_summon_dragon_knight", self.death_cd)
end


function modifier_marci_summon_tracker:StartCD(name, cd)
if not IsServer() then return end

	local ability = self.caster:FindAbilityByName(name)
	if ability and ability:GetCooldownTimeRemaining() < cd then 
		ability:EndCooldown()
		ability:StartCooldown(cd)
	end

end








modifier_marci_summon_damage_cd = class({})
function modifier_marci_summon_damage_cd:IsHidden() return false end
function modifier_marci_summon_damage_cd:IsPurgable() return false end
function modifier_marci_summon_damage_cd:IsDebuff() return true end



modifier_marci_summon_disarm = class({})
function modifier_marci_summon_disarm:IsHidden() return true end
function modifier_marci_summon_disarm:IsPurgable() return false end
function modifier_marci_summon_disarm:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end

function modifier_marci_summon_disarm:GetEffectName() 
	return "particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd.vpcf"
end
function modifier_marci_summon_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end






marci_summon_luna_aura = class({})
function marci_summon_luna_aura:GetIntrinsicModifierName()
return "modifier_marci_summon_luna_aura"
end


modifier_marci_summon_luna_aura = class({})
function modifier_marci_summon_luna_aura:IsHidden() return true end
function modifier_marci_summon_luna_aura:IsPurgable() return false end

function modifier_marci_summon_luna_aura:OnCreated(table)
self.self_speed = self:GetAbility():GetSpecialValueFor("self_speed")
self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_marci_summon_luna_aura:IsAura()
return true
end

function modifier_marci_summon_luna_aura:GetAuraRadius()
	return self.aura_radius
end

function modifier_marci_summon_luna_aura:GetAuraSearchFlags()
	return  DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_marci_summon_luna_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_marci_summon_luna_aura:GetAuraSearchType()
return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO 
end

function modifier_marci_summon_luna_aura:GetModifierAura()
	return "modifier_marci_summon_luna_aura_damage"
end

function modifier_marci_summon_luna_aura:GetAuraDuration()
	return 0.1
end



modifier_marci_summon_luna_aura_damage = class({})
function modifier_marci_summon_luna_aura_damage:IsHidden() return false end
function modifier_marci_summon_luna_aura_damage:IsPurgable() return false end

function modifier_marci_summon_luna_aura_damage:OnCreated(table)
self.speed = self:GetAbility():GetSpecialValueFor("aura_speed")
end

function modifier_marci_summon_luna_aura_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_marci_summon_luna_aura_damage:GetModifierMoveSpeedBonus_Percentage()
	return self.speed
end


marci_summon_luna_glaive = class({})
function marci_summon_luna_glaive:GetIntrinsicModifierName()
return "modifier_marci_summon_luna_glaive"
end

modifier_marci_summon_luna_glaive = class({})
function modifier_marci_summon_luna_glaive:IsHidden() return true end
function modifier_marci_summon_luna_glaive:IsPurgable() return false end
function modifier_marci_summon_luna_glaive:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()


self.damage = self.ability:GetSpecialValueFor("damage")/100
self.max = self.ability:GetSpecialValueFor("targets")
self.radius = self.ability:GetSpecialValueFor("radius")

if not IsServer() then return end
self:StartIntervalThink(0.1)
end


function modifier_marci_summon_luna_glaive:OnIntervalThink()
if not IsServer() then return end

if self.parent.owner then
	self.parent.owner:AddDamageEvent_out(self)
	self:StartIntervalThink(-1)
end

end

function modifier_marci_summon_luna_glaive:DamageEvent_out(params)
if not IsServer() then return end
if not params.attacker then return end
if self.parent ~= params.attacker then return end
if not params.unit:IsUnit() then return end 
if params.inflictor then return end

local damage = params.original_damage*self.damage
local targets = self.parent:FindTargets(self.radius, params.unit:GetAbsOrigin()) 
local n = 0

for _,target in pairs(targets) do 
	if target ~= params.unit then 
		n = n + 1

		local damageTable = {victim = target, attacker = self.parent, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self.ability, }
		DoDamage(damageTable)

		if n == self.max then 
			break
		end
	end
end

end 


marci_summon_dragon_knight_blood = class({})
function marci_summon_dragon_knight_blood:GetIntrinsicModifierName()
	return "modifier_marci_summon_dragon_blood"
end

modifier_marci_summon_dragon_blood = class({})
function modifier_marci_summon_dragon_blood:IsHidden() return true end
function modifier_marci_summon_dragon_blood:IsPurgable() return false end
function modifier_marci_summon_dragon_blood:OnCreated(table)

self.ability = self:GetAbility()
self.parent = self:GetParent()
self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_marci_summon_dragon_blood:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
}
end


function modifier_marci_summon_dragon_blood:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

params.target:AddNewModifier(self.parent, self.ability, "modifier_marci_summon_dragon_blood_debuff", {duration = self.duration})
end 




modifier_marci_summon_dragon_blood_debuff = class({})
function modifier_marci_summon_dragon_blood_debuff:IsHidden() return true end
function modifier_marci_summon_dragon_blood_debuff:IsPurgable() return true end
function modifier_marci_summon_dragon_blood_debuff:OnCreated()
self.damage_reduce = self:GetAbility():GetSpecialValueFor("reduction")
end 

function modifier_marci_summon_dragon_blood_debuff:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end

function modifier_marci_summon_dragon_blood_debuff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}

end

function modifier_marci_summon_dragon_blood_debuff:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_marci_summon_dragon_blood_debuff:GetModifierSpellAmplify_Percentage()
return self.damage_reduce
end






marci_summon_dragon_knight_dispell = class({})
function marci_summon_dragon_knight_dispell:OnSpellStart()
local target = self:GetCursorTarget()
local caster = self:GetCaster()

local particle = ParticleManager:CreateParticle( "particles/econ/items/dragon_knight/dk_persona/dk_persona_dragon_tail.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:ReleaseParticleIndex(particle)

target:EmitSound("Brewmaster_Storm.DispelMagic")
target:EmitSound("Hero_DragonKnight.DragonTail.Target")

target:Purge(false, true, false, true, false)

local heal = self:GetSpecialValueFor("heal")*target:GetMaxHealth()/100

target:GenericHeal(heal, self)
caster.owner:AddNewModifier(caster.owner, self, "modifier_marci_summon_dragon_knight_cd", {duration = self:GetCooldownTimeRemaining()})
end








marci_summon_mirana_starfall = class({})
function marci_summon_mirana_starfall:GetIntrinsicModifierName()
	return "modifier_marci_summon_mirana_starfall"
end



modifier_marci_summon_mirana_starfall = class({})
function modifier_marci_summon_mirana_starfall:IsHidden() return true end
function modifier_marci_summon_mirana_starfall:IsPurgable() return false end


function modifier_marci_summon_mirana_starfall:OnCreated(table)
self.parent = self:GetParent()
self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.ability = self:GetAbility()

self.damage = self.ability:GetSpecialValueFor("damage")
self.chance = self.ability:GetSpecialValueFor("chance")

end


function modifier_marci_summon_mirana_starfall:IsAura()
return true
end


function modifier_marci_summon_mirana_starfall:GetAuraRadius()
	return self.radius
end

function modifier_marci_summon_mirana_starfall:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_marci_summon_mirana_starfall:GetAuraEntityReject(hEntity)
if not self.parent.owner then return true end
return hEntity ~= self.parent.owner
end

function modifier_marci_summon_mirana_starfall:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_marci_summon_mirana_starfall:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_marci_summon_mirana_starfall:GetModifierAura() return "modifier_marci_summon_mirana_starfall_aura" end
function modifier_marci_summon_mirana_starfall:GetAuraDuration() return 0 end


function modifier_marci_summon_mirana_starfall:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
}
end



function modifier_marci_summon_mirana_starfall:GetModifierProcAttack_BonusDamage_Magical(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
if not RollPseudoRandomPercentage(self.chance,2718,self.parent) then return end

params.target:EmitSound("Ability.Starfall")
local particle = ParticleManager:CreateParticle( "particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )

damage = self.damage*self.parent:GetAverageTrueAttackDamage(nil)/100

return damage
end







modifier_marci_summon_mirana_starfall_aura = class({})
function modifier_marci_summon_mirana_starfall_aura:IsHidden() return false end
function modifier_marci_summon_mirana_starfall_aura:IsPurgable() return false end
function modifier_marci_summon_mirana_starfall_aura:OnCreated(table)
self.cdr = self:GetAbility():GetSpecialValueFor("cdr")
end

function modifier_marci_summon_mirana_starfall_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end


function modifier_marci_summon_mirana_starfall_aura:GetModifierPercentageCooldown()
return self.cdr
end






 marci_summon_mirana_arrow = class({})

function marci_summon_mirana_arrow:OnSpellStart()

local caster = self:GetCaster()
local origin = caster:GetOrigin()
local point = self:GetCursorPosition()
local owner = caster.owner

if not owner then return end

local main_ability = owner:FindAbilityByName("marci_summon_mirana")

if not main_ability then return end

caster:MoveToPositionAggressive(origin)

local projectile_name = "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf"
local projectile_speed = self:GetSpecialValueFor("arrow_speed")
local projectile_distance = self:GetSpecialValueFor("arrow_range")
local projectile_start_radius = self:GetSpecialValueFor("arrow_width")
local projectile_end_radius = self:GetSpecialValueFor("arrow_width")
local projectile_vision = self:GetSpecialValueFor("arrow_vision")

local damage = self:GetSpecialValueFor( "damage" )*self:GetCaster():GetAverageTrueAttackDamage(nil)/100

local min_stun = self:GetSpecialValueFor( "arrow_min_stun" )
local max_stun = self:GetSpecialValueFor( "arrow_max_stun" )
local max_distance = self:GetSpecialValueFor( "arrow_max_stunrange" )

local projectile_direction = (Vector( point.x-origin.x, point.y-origin.y, 0 )):Normalized()

local info = {
	Source = owner,
	Ability = main_ability,
	vSpawnOrigin = caster:GetOrigin(),
	
    bDeleteOnHit = true,
    
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    
    EffectName = projectile_name,
    fDistance = projectile_distance,
    fStartRadius = projectile_start_radius,
    fEndRadius =projectile_end_radius,
	vVelocity = projectile_direction * projectile_speed,

	bHasFrontalCone = false,
	bReplaceExisting = false,
	fExpireTime = GameRules:GetGameTime() + 10.0,
	
	bProvidesVision = true,
	iVisionRadius = projectile_vision,
	iVisionTeamNumber = caster:GetTeamNumber(),

	ExtraData = {
		originX = origin.x,
		originY = origin.y,
		originZ = origin.z,

		max_distance = max_distance,
		min_stun = min_stun,
		max_stun = max_stun,

		damage = damage

	}
}
ProjectileManager:CreateLinearProjectile(info)

caster:EmitSound("Hero_Mirana.ArrowCast")

owner:AddNewModifier(self:GetCaster().owner, self, "modifier_marci_summon_mirana_cd", {duration = self:GetCooldownTimeRemaining()})
end



modifier_marci_summon_dragon_knight_cd = class({})
function modifier_marci_summon_dragon_knight_cd:IsHidden() return true end
function modifier_marci_summon_dragon_knight_cd:IsPurgable() return false end

modifier_marci_summon_mirana_cd = class({})
function modifier_marci_summon_mirana_cd:IsHidden() return true end
function modifier_marci_summon_mirana_cd:IsPurgable() return false end
