LinkLuaModifier( "modifier_marci_summon_tracker", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_disarm", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_luna_aura", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_luna_aura_damage", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_dragon_armor", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_dragon_armor_aura", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_mirana_aura", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_luna_glaive", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_mirana_starfall", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_mirana_starfall_aura", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_mirana_starfall_slow", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_dragon_knight_cd", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_summon_mirana_cd", "abilities/marci/marci_summon", LUA_MODIFIER_MOTION_NONE )


marci_summon_mirana = class({})


function marci_summon_mirana:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_demonartist/demonartist_engulf_disarm/items2_fx/heavens_halberd.vpcf', context )
PrecacheResource( "particle", 'particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf', context )
PrecacheResource( "particle", 'particles/econ/items/dragon_knight/dk_persona/dk_persona_dragon_tail.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_meepo/meepo_ransack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf', context )

end





function marci_summon_mirana:OnAbilityPhaseStart()

if self:GetCaster():HasModifier("modifier_marci_summon_damage_cd") then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#marci_summon_damage"})
 
	return false
end
return true
end

function marci_summon_mirana:OnSpellStart()
if not IsServer() then return end



local next_name = "marci_summon_dragon_knight"

self:GetCaster():SwapAbilities(self:GetName(), next_name, false, true)
self:GetCaster():FindAbilityByName(next_name):StartCooldown(0.8)

self:SummonFriend("npc_marci_summon_mirana", self)

end



function marci_summon_mirana:SummonFriend(name, ability)
if not IsServer() then return end

local friends = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false)

for _,friend in pairs(friends) do 
	if friend.MacriSummon then 
		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl(particle, 0, friend:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( particle )
		UTIL_Remove(friend)
	end
end	


local point = self:GetCaster():GetAbsOrigin() - self:GetCaster():GetForwardVector()*200

local unit = CreateUnitByName(name, point, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
unit:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
unit.MacriSummon = true 


unit.owner = self:GetCaster()
unit:EmitSound("Marci.Sidekick_summon")
Timers:CreateTimer(1.35, 
	function() 
		if unit and not unit:IsNull() then 
			unit:EmitSound(name..'_spawn')

		end
	end)


for abilitySlot = 0,5 do

	local ability = unit:GetAbilityByIndex(abilitySlot)

	if ability ~= nil then
		ability:SetLevel(1)
		if ability:GetName() == "marci_summon_dragon_knight_dispell" and self:GetCaster():HasModifier("modifier_marci_summon_dragon_knight_cd") then 
			ability:StartCooldown(self:GetCaster():FindModifierByName("modifier_marci_summon_dragon_knight_cd"):GetRemainingTime())
		end
		if ability:GetName() == "marci_summon_mirana_arrow" and self:GetCaster():HasModifier("modifier_marci_summon_mirana_cd") then 
			ability:StartCooldown(self:GetCaster():FindModifierByName("modifier_marci_summon_mirana_cd"):GetRemainingTime())
		end
	end
end


local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )


unit:AddNewModifier(self:GetCaster(), ability, "modifier_marci_summon_tracker", {})
end





marci_summon_dragon_knight = class({})


function marci_summon_dragon_knight:OnAbilityPhaseStart()

if self:GetCaster():HasModifier("modifier_marci_summon_damage_cd") then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#marci_summon_damage"})
 
	return false
end
return true
end



function marci_summon_dragon_knight:OnSpellStart()
if not IsServer() then return end

local main = self:GetCaster():FindAbilityByName("marci_summon_mirana")
local next_name = "marci_summon_luna"

self:GetCaster():SwapAbilities(self:GetName(), next_name, false, true)
self:GetCaster():FindAbilityByName(next_name):StartCooldown(0.8)

main:SummonFriend("npc_marci_summon_dragon_knight", self)
end




marci_summon_luna = class({})

function marci_summon_luna:OnAbilityPhaseStart()

if self:GetCaster():HasModifier("modifier_marci_summon_damage_cd") then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#marci_summon_damage"})
 
	return false
end
return true
end


function marci_summon_luna:OnSpellStart()
if not IsServer() then return end


local main = self:GetCaster():FindAbilityByName("marci_summon_mirana")
local next_name = "marci_summon_mirana"

self:GetCaster():SwapAbilities(self:GetName(), next_name, false, true)
self:GetCaster():FindAbilityByName(next_name):StartCooldown(0.8)

main:SummonFriend("npc_marci_summon_luna", self)
end





modifier_marci_summon_tracker = class({})
function modifier_marci_summon_tracker:IsHidden() return true end
function modifier_marci_summon_tracker:IsPurgable() return false end
function modifier_marci_summon_tracker:OnCreated(table)

self.speed = 100
self.movespeed = 50

self.armor = self:GetCaster():GetPhysicalArmorValue(false)*self:GetAbility():GetSpecialValueFor("armor")/100

if not IsServer() then return end


local ability = self:GetAbility()
local stat = 0

if self:GetAbility():GetName() == "marci_summon_mirana" then 
	stat = self:GetCaster():GetIntellect()
end

if self:GetAbility():GetName() == "marci_summon_dragon_knight" then 
	stat = self:GetCaster():GetStrength()
end
if self:GetAbility():GetName() == "marci_summon_luna" then 
	stat = self:GetCaster():GetAgility()
end


self.damage = ability:GetSpecialValueFor("stats_damage")
self.health = ability:GetSpecialValueFor("stats_health")

self.damage_cd = 3
self.death_cd = 10

local damage = self:GetParent():GetBaseDamageMax() + stat*self.damage


self.change_health = self:GetCaster():GetLevel()*self.health + 99



self:GetParent():SetBaseDamageMin(damage)
self:GetParent():SetBaseDamageMax(damage)



self:SetHasCustomTransmitterData(true)
self:StartIntervalThink(0.3)
end





function modifier_marci_summon_tracker:GetModifierExtraHealthBonus()
return self.change_health
end




function modifier_marci_summon_tracker:OnIntervalThink()

if not IsServer() then return end



if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 1500 and self:GetParent():HasModifier("modifier_marci_summon_disarm") then 
	self:GetParent():RemoveModifierByName("modifier_marci_summon_disarm")
end


if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 1500 and not self:GetParent():HasModifier("modifier_marci_summon_disarm") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_marci_summon_disarm", {})
end


end




function modifier_marci_summon_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS

}
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


function modifier_marci_summon_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end 
if not self:GetParent():IsAlive() then return end


if params.attacker then 

	self:StartCD("marci_summon_mirana", self.damage_cd)
	self:StartCD("marci_summon_luna", self.damage_cd)
	self:StartCD("marci_summon_dragon_knight", self.damage_cd)
end

end


function modifier_marci_summon_tracker:OnDeath(params)
if not IsServer() then return end

if self:GetParent().owner == params.unit then 

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( particle )
	UTIL_Remove(self:GetParent())
	return
end


if self:GetParent() ~= params.unit then return end 

self:GetParent():EmitSound(self:GetParent():GetUnitName()..'_death')

self:StartCD("marci_summon_mirana", self.death_cd)
self:StartCD("marci_summon_luna", self.death_cd)
self:StartCD("marci_summon_dragon_knight", self.death_cd)


end


function modifier_marci_summon_tracker:StartCD(name, cd)
if not IsServer() then return end

	local ability = self:GetCaster():FindAbilityByName(name)
	if ability and ability:GetCooldownTimeRemaining() < cd then 
		ability:EndCooldown()
		ability:StartCooldown(cd)
	end

end





modifier_marci_summon_damage_cd = class({})
function modifier_marci_summon_damage_cd:IsHidden() return true end
function modifier_marci_summon_damage_cd:IsPurgable() return false end


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

function modifier_marci_summon_luna_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
}

end

function modifier_marci_summon_luna_aura:GetModifierBaseAttackTimeConstant()
	return self.self_speed
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
self.damage = self:GetAbility():GetSpecialValueFor("damage")/100
self.max = self:GetAbility():GetSpecialValueFor("targets")
self.radius = self:GetAbility():GetSpecialValueFor("radius")

end

function modifier_marci_summon_luna_glaive:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_marci_summon_luna_glaive:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.inflictor then return end

local damage = params.original_damage*self.damage
local targets = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
local n = 0

for _,target in pairs(targets) do 
	if target ~= params.unit then 
		n = n + 1

		local damageTable = {victim = target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility(), }
		ApplyDamage(damageTable)

		if n == self.max then 
			break
		end
	end
end


end 


marci_summon_dragon_knight_armor = class({})
function marci_summon_dragon_knight_armor:GetIntrinsicModifierName()
	return "modifier_marci_summon_dragon_armor"
end

modifier_marci_summon_dragon_armor = class({})
function modifier_marci_summon_dragon_armor:IsHidden() return true end
function modifier_marci_summon_dragon_armor:IsPurgable() return false end
function modifier_marci_summon_dragon_armor:OnCreated(table)
self.radius = self:GetAbility():GetSpecialValueFor("radius")

end


function modifier_marci_summon_dragon_armor:IsAura()
return true
end


function modifier_marci_summon_dragon_armor:GetAuraRadius()
	return self.radius
end

function modifier_marci_summon_dragon_armor:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

function modifier_marci_summon_dragon_armor:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_marci_summon_dragon_armor:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO 
end


function modifier_marci_summon_dragon_armor:GetModifierAura()
	return "modifier_marci_summon_dragon_armor_aura"
end


function modifier_marci_summon_dragon_armor:GetAuraDuration()
	return 0
end

function modifier_marci_summon_dragon_armor:GetAuraEntityReject(hEntity)
if self:GetParent().owner ~= hEntity then 
	return true
end

return false
end



modifier_marci_summon_dragon_armor_aura = class({})
function modifier_marci_summon_dragon_armor_aura:IsHidden() return false end
function modifier_marci_summon_dragon_armor_aura:IsPurgable() return false end
function modifier_marci_summon_dragon_armor_aura:OnCreated(table)
self.damage = self:GetAbility():GetSpecialValueFor("reduction")/100
end


function modifier_marci_summon_dragon_armor_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_marci_summon_dragon_armor_aura:OnTooltip()
return self.damage*100
end

function modifier_marci_summon_dragon_armor_aura:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if not self:GetCaster() then return end
if self:GetParent() == params.attacker then return end

if params.damage_type == DAMAGE_TYPE_MAGICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_magic_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

if params.damage_type == DAMAGE_TYPE_PHYSICAL then 
  local mod = self:GetParent():FindModifierByName("modifier_attack_shield")
  if mod and mod:GetStackCount() > 0 then 
    return
  end
end

local reduce = params.damage*self.damage

self:GetCaster():SetHealth(math.max(1, self:GetCaster():GetHealth() - reduce))

return reduce

end

marci_summon_mirana_starfall = class({})
function marci_summon_mirana_starfall:GetIntrinsicModifierName()
	return "modifier_marci_summon_mirana_starfall"
end



modifier_marci_summon_mirana_starfall = class({})
function modifier_marci_summon_mirana_starfall:IsHidden() return true end
function modifier_marci_summon_mirana_starfall:IsPurgable() return false end


function modifier_marci_summon_mirana_starfall:OnCreated(table)
self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.duration = self:GetAbility():GetSpecialValueFor("duration")
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
if hEntity ~= self:GetParent().owner then return true end
return false
end


function modifier_marci_summon_mirana_starfall:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_marci_summon_mirana_starfall:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO
end


function modifier_marci_summon_mirana_starfall:GetModifierAura()
	return "modifier_marci_summon_mirana_starfall_aura"
end


function modifier_marci_summon_mirana_starfall:GetAuraDuration()
	return 0
end


function modifier_marci_summon_mirana_starfall:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
}
end


function modifier_marci_summon_mirana_starfall:GetModifierProcAttack_BonusDamage_Magical(params)
if not IsServer() then return end
if not self:GetCaster() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if not self:GetAbility() then return end

if not RollPseudoRandomPercentage(self:GetAbility():GetSpecialValueFor("chance"),27,self:GetParent()) then return end

self:GetParent():EmitSound("Ability.Starfall")
local particle = ParticleManager:CreateParticle( "particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target )
ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_marci_summon_mirana_starfall_slow", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility():GetSpecialValueFor("slow_duration")})

local damage = self:GetAbility():GetSpecialValueFor("damage")*self:GetCaster():GetAverageTrueAttackDamage(nil)/100
	local damageTable = {
	victim = params.target,
	attacker = self:GetCaster(),
	damage = damage,
	damage_type = DAMAGE_TYPE_MAGICAL,
	ability = self:GetAbility(), --Optional.
}
--ApplyDamage(damageTable)
SendOverheadEventMessage(params.target, 4, params.target, damage, nil)

return damage
end



modifier_marci_summon_mirana_starfall_slow = class({})
function modifier_marci_summon_mirana_starfall_slow:IsHidden() return true end
function modifier_marci_summon_mirana_starfall_slow:IsPurgable() return false end

function modifier_marci_summon_mirana_starfall_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end
function modifier_marci_summon_mirana_starfall_slow:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("slow_move")
end

function modifier_marci_summon_mirana_starfall_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_marci_summon_mirana_starfall_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
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






marci_summon_dragon_knight_dispell = class({})
function marci_summon_dragon_knight_dispell:OnSpellStart()
local target = self:GetCursorTarget()

local particle = ParticleManager:CreateParticle( "particles/econ/items/dragon_knight/dk_persona/dk_persona_dragon_tail.vpcf", PATTACH_POINT, self:GetCaster())
ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:ReleaseParticleIndex( particle )

target:EmitSound("Hero_DragonKnight.DragonTail.Target")

target:Purge(false, true, false, true, false)

local heal = self:GetSpecialValueFor("heal")*target:GetMaxHealth()/100

target:Heal(heal, self:GetCaster())
SendOverheadEventMessage(target, 10, target, heal, nil)

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:ReleaseParticleIndex( particle )

self:GetCaster().owner:AddNewModifier(self:GetCaster().owner, self, "modifier_marci_summon_dragon_knight_cd", {duration = self:GetCooldownTimeRemaining()})
end

modifier_marci_summon_dragon_knight_cd = class({})
function modifier_marci_summon_dragon_knight_cd:IsHidden() return true end
function modifier_marci_summon_dragon_knight_cd:IsPurgable() return false end

modifier_marci_summon_mirana_cd = class({})
function modifier_marci_summon_mirana_cd:IsHidden() return true end
function modifier_marci_summon_mirana_cd:IsPurgable() return false end





 marci_summon_mirana_arrow = class({})

function marci_summon_mirana_arrow:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local origin = caster:GetOrigin()
	local point = self:GetCursorPosition()

	caster:MoveToPositionAggressive(origin)
	-- load data


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

	-- logic
	local info = {
		Source = caster,
		Ability = self,
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

	-- Effects
	local sound_cast = "Hero_Mirana.ArrowCast"
	 caster:EmitSound(sound_cast)

	self:GetCaster().owner:AddNewModifier(self:GetCaster().owner, self, "modifier_marci_summon_mirana_cd", {duration = self:GetCooldownTimeRemaining()})

end

--------------------------------------------------------------------------------
-- Projectile
function marci_summon_mirana_arrow:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	if hTarget==nil then return end

	-- calculate distance percentage
	local origin = Vector( extraData.originX, extraData.originY, extraData.originZ )
	local distance = (vLocation-origin):Length2D()
	local bonus_pct = math.min(1,distance/extraData.max_distance)



	local damageTable = {
		victim = hTarget,
		attacker = self:GetCaster(),
		damage = extraData.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- stun
	hTarget:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_stunned", -- modifier name
		{ duration = math.max(extraData.min_stun, extraData.max_stun*bonus_pct)*(1 - hTarget:GetStatusResistance()) } -- kv
	)

	AddFOWViewer( self:GetCaster():GetTeamNumber(), vLocation, 500, 3, false )

	-- effects
	local sound_cast = "Hero_Mirana.ArrowImpact"
	hTarget:EmitSound(sound_cast)

	return true
end