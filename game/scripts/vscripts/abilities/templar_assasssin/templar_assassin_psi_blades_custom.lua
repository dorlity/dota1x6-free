LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom", "abilities/templar_assasssin/templar_assassin_psi_blades_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_speed", "abilities/templar_assasssin/templar_assassin_psi_blades_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_slow", "abilities/templar_assasssin/templar_assassin_psi_blades_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_psi", "abilities/templar_assasssin/templar_assassin_psi_blades_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_legendary", "abilities/templar_assasssin/templar_assassin_psi_blades_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_crystal", "abilities/templar_assasssin/templar_assassin_psi_blades_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_attack", "abilities/templar_assasssin/templar_assassin_psi_blades_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_custom", "modifiers/generic/modifier_generic_knockback_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_attack_cd", "abilities/templar_assasssin/templar_assassin_psi_blades_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psi_blades_custom_attack_ready", "abilities/templar_assasssin/templar_assassin_psi_blades_custom", LUA_MODIFIER_MOTION_NONE )



templar_assassin_psi_blades_custom = class({})

templar_assassin_psi_blades_custom.range_attack = {50, 100, 150}
templar_assassin_psi_blades_custom.range_blades = {50, 100, 150}

templar_assassin_psi_blades_custom.damage_inc = {0.06, 0.09, 0.12}

templar_assassin_psi_blades_custom.speed_move = 10
templar_assassin_psi_blades_custom.speed_evasion = 10
templar_assassin_psi_blades_custom.speed_max = 4
templar_assassin_psi_blades_custom.speed_duration = 3




templar_assassin_psi_blades_custom.knockback_duration = 0.3
templar_assassin_psi_blades_custom.knockback_min_distance = 100
templar_assassin_psi_blades_custom.knockback_max_distance = 350
templar_assassin_psi_blades_custom.knockback_meele = 200
templar_assassin_psi_blades_custom.knockback_slow = -50
templar_assassin_psi_blades_custom.knockback_slow_duration = 2
templar_assassin_psi_blades_custom.knockback_cd = 10



function templar_assassin_psi_blades_custom:Precache(context)

PrecacheResource( "particle", 'particles/ta_crystall_spawn.vpcf', context )
PrecacheResource( "particle", 'particles/ta_crystal_end.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf', context )
PrecacheResource( "particle", 'particles/ta_psi_speed.vpcf', context )
PrecacheResource( "particle", 'particles/void_astral_slow.vpcf', context )
PrecacheResource( "particle", 'particles/templar_assassin_knockback.vpcf', context )

end






function templar_assassin_psi_blades_custom:GetIntrinsicModifierName()
	return "modifier_templar_assassin_psi_blades_custom"
end


function templar_assassin_psi_blades_custom:GetCooldown(iLevel)


if self:GetCaster():HasModifier("modifier_templar_assassin_psiblades_7") then 
  return self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_7", "cd")
end

return 0

end


function templar_assassin_psi_blades_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_templar_assassin_psiblades_7") then 
    return self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_7", "castrange")
end

end



function templar_assassin_psi_blades_custom:GetBehavior()


    if self:GetCaster():HasModifier("modifier_templar_assassin_psiblades_7") then
        return DOTA_ABILITY_BEHAVIOR_POINT
    end
    return DOTA_ABILITY_BEHAVIOR_PASSIVE
end



function templar_assassin_psi_blades_custom:OnSpellStart()
if not IsServer() then return end


local pos = self:GetCursorPosition()

local crystal = CreateUnitByName("npc_psi_blades_crystal", pos, true, nil, nil, DOTA_TEAM_CUSTOM_5)

crystal.player_unit = true

crystal:EmitSound("Lina.Array_triple")
local particle_peffect = ParticleManager:CreateParticle("particles/ta_crystall_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, crystal)
ParticleManager:SetParticleControl(particle_peffect, 0, crystal:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, crystal:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

crystal:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psi_blades_custom_legendary", {})
crystal:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_7", "duration")})

crystal:SetBaseMaxHealth(self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_7", "attacks"))
crystal:SetHealth(self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_7", "attacks"))


end











modifier_templar_assassin_psi_blades_custom_legendary = class({})
function modifier_templar_assassin_psi_blades_custom_legendary:IsHidden() return true end
function modifier_templar_assassin_psi_blades_custom_legendary:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.hits = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_7", "attacks")

self:StartIntervalThink(0.2)
end

function modifier_templar_assassin_psi_blades_custom_legendary:DeclareFunctions()
return
  {
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_EVENT_ON_TAKEDAMAGE
	--MODIFIER_PROPERTY_HEALTHBAR_PIPS
 } 
end

function modifier_templar_assassin_psi_blades_custom_legendary:GetModifierHealthBarPips()
if IsClient() then 
	return 5
end 

end

function modifier_templar_assassin_psi_blades_custom_legendary:GetAbsoluteNoDamagePhysical()
return 1
end
function modifier_templar_assassin_psi_blades_custom_legendary:GetAbsoluteNoDamageMagical()
return 1
end

function modifier_templar_assassin_psi_blades_custom_legendary:GetAbsoluteNoDamagePure()
return 1
end

function modifier_templar_assassin_psi_blades_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
}
end


function modifier_templar_assassin_psi_blades_custom_legendary:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, 0.2, false)
end


function modifier_templar_assassin_psi_blades_custom_legendary:GetModifierIncomingDamage_Percentage()
return -100
end

function modifier_templar_assassin_psi_blades_custom_legendary:OnTakeDamage( param )
if not IsServer() then return end
if param.inflictor ~= nil then return end

local attacker = param.attacker
if attacker.owner then 
	attacker = attacker.owner
end


if attacker ~= self:GetCaster() then return end
if self:GetParent() == param.unit then

   self.hits = self.hits - 1
	self:GetParent():EmitSound("TA.Psibaldes_crystall_attack")
    if self.hits <= 0 then
    	self.stun = true
        self:GetParent():Kill(nil, attacker)
    else 

    	self:GetParent():SetHealth(self.hits)
    end
end

end


function modifier_templar_assassin_psi_blades_custom_legendary:OnDestroy()
if not IsServer() then return end

self:GetParent():AddNoDraw()

local explode_particle = ParticleManager:CreateParticle("particles/ta_crystal_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(explode_particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(explode_particle, 60, Vector(12,198,255))
ParticleManager:SetParticleControl(explode_particle, 61, Vector(1,0,0))
ParticleManager:ReleaseParticleIndex(explode_particle)



self:GetParent():EmitSound("TA.Psibaldes_crystall_end_stun")
self:GetParent():EmitSound("TA.Psibaldes_crystall_end")


end







modifier_templar_assassin_psi_blades_custom = class({})

function modifier_templar_assassin_psi_blades_custom:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom:IsHidden() return true end

function modifier_templar_assassin_psi_blades_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
        MODIFIER_EVENT_ON_ATTACK
    }
    return funcs
end








function modifier_templar_assassin_psi_blades_custom:GetModifierAttackRangeBonus()
local bonus = 0
if self:GetParent():HasModifier("modifier_templar_assassin_psiblades_1") then 
	bonus = bonus + self:GetAbility().range_attack[self:GetParent():GetUpgradeStack("modifier_templar_assassin_psiblades_1")]
end
	return self:GetAbility():GetSpecialValueFor("bonus_attack_range") + bonus
end




function modifier_templar_assassin_psi_blades_custom:OnTakeDamage(params)
if not IsServer() then return end

if params.attacker ~= self:GetParent() then return end
if params.unit:IsBuilding() then return end
if params.inflictor then return end
if self:GetParent():PassivesDisabled() then return end

if self:GetParent():HasModifier("modifier_templar_assassin_psiblades_5") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_speed", {duration = self:GetAbility().speed_duration})
end

if self:GetCaster():HasModifier("modifier_templar_assassin_psiblades_3") then 
	params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_slow", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_3", "duration")})
end 

params.unit:EmitSound("Hero_TemplarAssassin.PsiBlade")

local direction = params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
direction.z = 0
direction = direction:Normalized()

local distance = self:GetAbility():GetSpecialValueFor("attack_spill_range")

if self:GetParent():HasModifier("modifier_templar_assassin_psiblades_1") then 
	distance = distance + self:GetAbility().range_blades[self:GetParent():GetUpgradeStack("modifier_templar_assassin_psiblades_1")]
end

local attack_spill_width = self:GetAbility():GetSpecialValueFor("attack_spill_width")
local attack_spill_pct = self:GetAbility():GetSpecialValueFor("attack_spill_pct")/100


local damage = params.damage



if params.unit:GetUnitName() == "npc_psi_blades_crystal" then 
	damage = params.original_damage
	self:GetCaster():GenericHeal(damage*self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_7", "heal")/100, self:GetAbility())
end

local enemies

if params.unit:GetUnitName() == "npc_psi_blades_crystal_mini" then 
	enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), nil, distance,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	damage = params.original_damage
else 
	enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),  params.unit:GetAbsOrigin() + direction * distance , params.unit:GetAbsOrigin() + direction*attack_spill_width, self:GetCaster(), attack_spill_width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
end

local hit_units = {}


damage = damage*attack_spill_pct

local hit = false
for _, enemy in pairs(enemies) do
    if enemy ~= params.unit and enemy:IsAlive() and enemy:GetUnitName() ~= "npc_psi_blades_crystal_mini" then

		hit = true
    	self:DealDamage(damage, enemy, params.unit)
	
		hit_units[enemy:entindex()] = true
    end
end

if params.unit:GetUnitName() == "npc_psi_blades_crystal" then 	
	local more_targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_7", "radius"),  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
	for _,enemy in pairs(more_targets) do
	    if enemy ~= params.unit and enemy:IsAlive() and not hit_units[enemy:entindex()] and enemy:GetUnitName() ~= "npc_psi_blades_crystal_mini" then

			hit = true
	    	self:DealDamage(damage, enemy, params.unit)
		
			hit_units[enemy:entindex()] = true
	    end
	end
end






if self:GetParent():HasModifier("modifier_templar_assassin_psiblades_2") and hit then 
	local damage = self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_psiblades_2")]*params.damage
	
	ApplyDamage({victim = params.unit, attacker = self:GetCaster(), damage = damage, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})
	
	SendOverheadEventMessage(params.unit, 4, params.unit, damage, nil)
end


if self:GetParent():HasModifier("modifier_templar_assassin_psiblades_4") then 

	local chance = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_4", "chance")
	local random = RollPseudoRandomPercentage(chance,27,self:GetParent())

	if random then 

		local pos = params.unit:GetAbsOrigin() + RandomVector(250)


		local crystal = CreateUnitByName("npc_psi_blades_crystal_mini", pos, true, nil, nil, DOTA_TEAM_CUSTOM_5)

		crystal.player_unit = true

		crystal:EmitSound("Lina.Array_triple")
		local particle_peffect = ParticleManager:CreateParticle("particles/ta_crystall_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, crystal)
		ParticleManager:SetParticleControl(particle_peffect, 0, crystal:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_peffect, 2, crystal:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_peffect)


		crystal:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_crystal", {})
		crystal:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_4", "duration")})

		crystal:SetBaseMaxHealth(1)
		crystal:SetHealth(1)

	end

end


end


function modifier_templar_assassin_psi_blades_custom:DealDamage(damage, enemy, unit)


local creeps_k = 1

if enemy:IsCreep() then 
--	creeps_k = self:GetAbility():GetSpecialValueFor("creeps_damage")/100
end

local k = 1
if self:GetCaster():HasModifier("modifier_templar_assassin_psiblades_2") then 
	k = 1 + self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_psiblades_2")]
end

if self:GetCaster():HasModifier("modifier_templar_assassin_psiblades_3") then 
	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_slow", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_3", "duration")})
end 


if unit:GetUnitName() == "npc_psi_blades_crystal_mini" then 
	enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_4", "stun")})
end	

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_psi_blade.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)

if self:GetCaster():GetQuest() == "Templar.Quest_7" and enemy:IsRealHero() and not self:GetCaster():QuestCompleted() then 
	self:GetCaster():UpdateQuest(1)
end

ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = damage*creeps_k*k, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})

if unit:GetUnitName() == "npc_psi_blades_crystal" then 
	enemy:EmitSound("TA.Psibaldes_crystall_attack")
	enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_7", "stun")*(1 - enemy:GetStatusResistance())})
end

end







modifier_templar_assassin_psi_blades_custom_speed = class({})
function modifier_templar_assassin_psi_blades_custom_speed:IsHidden() return false end
function modifier_templar_assassin_psi_blades_custom_speed:IsPurgable() return true end
function modifier_templar_assassin_psi_blades_custom_speed:GetTexture() return "buffs/psiblades_speed" end

function modifier_templar_assassin_psi_blades_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_EVASION_CONSTANT
}
end

function modifier_templar_assassin_psi_blades_custom_speed:GetModifierEvasion_Constant()
return
self:GetAbility().speed_evasion*self:GetStackCount()
end

function modifier_templar_assassin_psi_blades_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return
self:GetAbility().speed_move*self:GetStackCount()
end

function modifier_templar_assassin_psi_blades_custom_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_templar_assassin_psi_blades_custom_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().speed_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().speed_max then 

	local effect_cast = ParticleManager:CreateParticle( "particles/ta_psi_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
	self:AddParticle( effect_cast, false, false, -1, false, false)
end


end










modifier_templar_assassin_psi_blades_custom_slow = class({})
function modifier_templar_assassin_psi_blades_custom_slow:IsHidden() return false end
function modifier_templar_assassin_psi_blades_custom_slow:IsPurgable() return true end
function modifier_templar_assassin_psi_blades_custom_slow:GetTexture() return "buffs/psiblades_slow" end
function modifier_templar_assassin_psi_blades_custom_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end

function modifier_templar_assassin_psi_blades_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_templar_assassin_psi_blades_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self.slow
end

function modifier_templar_assassin_psi_blades_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self.attack
end


function modifier_templar_assassin_psi_blades_custom_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_3", "slow")
self.max = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_3", "max")
self.attack = self:GetCaster():GetTalentValue("modifier_templar_assassin_psiblades_3", "attack")

if not IsServer() then return end 
self:SetStackCount(1)

end

function modifier_templar_assassin_psi_blades_custom_slow:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

end







modifier_templar_assassin_psi_blades_custom_crystal = class({})
function modifier_templar_assassin_psi_blades_custom_crystal:IsHidden() return true end
function modifier_templar_assassin_psi_blades_custom_crystal:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom_crystal:OnCreated(table)
if not IsServer() then return end
self.hits = 1
self:StartIntervalThink(0.2)
end

function modifier_templar_assassin_psi_blades_custom_crystal:DeclareFunctions()
return
  {
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_EVENT_ON_TAKEDAMAGE
 } 
end


function modifier_templar_assassin_psi_blades_custom_crystal:CheckState()
return
{
	[MODIFIER_STATE_MAGIC_IMMUNE] = true
}
end


function modifier_templar_assassin_psi_blades_custom_crystal:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, 0.2, false)

end

function modifier_templar_assassin_psi_blades_custom_crystal:GetAbsoluteNoDamagePhysical()
return 1
end
function modifier_templar_assassin_psi_blades_custom_crystal:GetAbsoluteNoDamageMagical()
return 1
end

function modifier_templar_assassin_psi_blades_custom_crystal:GetAbsoluteNoDamagePure()
return 1
end

function modifier_templar_assassin_psi_blades_custom_crystal:GetModifierIncomingDamage_Percentage()
return -100
end

function modifier_templar_assassin_psi_blades_custom_crystal:OnTakeDamage( param )
if not IsServer() then return end
if param.inflictor ~= nil then return end

local attacker = param.attacker
if attacker.owner then 
	attacker = attacker.owner
end


if attacker ~= self:GetCaster() then return end
if self:GetParent() == param.unit then

   self.hits = self.hits - 1
	self:GetParent():EmitSound("TA.Psibaldes_crystall_attack")
    if self.hits <= 0 then
    	self.stun = true
        self:GetParent():Kill(nil, attacker)
    else 

    	self:GetParent():SetHealth(self.hits)
    end
end

end




function modifier_templar_assassin_psi_blades_custom_crystal:OnDestroy()
if not IsServer() then return end

self:GetParent():AddNoDraw()
self:GetParent():EmitSound("TA.Psibaldes_crystall_end_stun")

local explode_particle = ParticleManager:CreateParticle("particles/ta_crystal_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(explode_particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(explode_particle, 60, Vector(12,198,255))
ParticleManager:SetParticleControl(explode_particle, 61, Vector(1,0,0))
ParticleManager:ReleaseParticleIndex(explode_particle)


end




modifier_templar_assassin_psi_blades_custom_attack = class({})
function modifier_templar_assassin_psi_blades_custom_attack:IsHidden() 
	return true
end

function modifier_templar_assassin_psi_blades_custom_attack:RemoveOnDeath() return false end
function modifier_templar_assassin_psi_blades_custom_attack:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom_attack:GetTexture() return "buffs/psiblades_attack" end

function modifier_templar_assassin_psi_blades_custom_attack:OnCreated(table)
self.cd = false
if not IsServer() then return end
self.origin = nil
self.record = nil
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_attack_ready", {})
end

function modifier_templar_assassin_psi_blades_custom_attack:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_RECORD,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end







function modifier_templar_assassin_psi_blades_custom_attack:OnAttack(params)
if params.target:IsBuilding() then return end
if self.cd == true then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if (self:GetParent():GetAbsOrigin() - params.target:GetAbsOrigin()):Length2D() >= self:GetAbility().knockback_meele then return end

        local projectile =
        {
            Target = params.target,
            Source = self:GetParent(),
            Ability = self:GetAbility(),
            EffectName = "particles/templar_assassin_knockback.vpcf",
            iMoveSpeed = self:GetParent():GetProjectileSpeed()*0.7,
            vSourceLoc = self:GetParent():GetAbsOrigin(),
            bDodgeable = false,
            bProvidesVision = false,
        }

        local hProjectile = ProjectileManager:CreateTrackingProjectile( projectile )

self.origin = self:GetCaster():GetAbsOrigin()
self.record = params.record

self.cd = true
self:GetCaster():RemoveModifierByName("modifier_templar_assassin_psi_blades_custom_attack_ready")
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_attack_cd", {duration = self:GetAbility().knockback_cd})
self:StartIntervalThink(self:GetAbility().knockback_cd)
end


function modifier_templar_assassin_psi_blades_custom_attack:OnIntervalThink()
self.cd = false
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_attack_ready", {})

end





function modifier_templar_assassin_psi_blades_custom_attack:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.record ~= self.record then return end


if params.target:IsBuilding() or
	params.target:GetUnitName() == "npc_teleport" or
	params.target:GetUnitName() == "npc_psi_blades_crystal" or
	params.target:GetUnitName() == "npc_psi_blades_crystal_mini" then return end
	
params.target:EmitSound("TA.Psibaldes_knockback")

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_templar_assassin_psi_blades_custom_psi", {duration =  self:GetAbility().knockback_slow_duration*(1 - params.target:GetStatusResistance())})

params.target:AddNewModifier(
	self:GetCaster(),
	self:GetAbility(),
	"modifier_generic_knockback_custom",
	{	
		duration = self:GetAbility().knockback_duration, 
		min_distance = self:GetAbility().knockback_min_distance,
		max_distance = self:GetAbility().knockback_max_distance,
		x = self.origin.x, 
		y = self.origin.y
	})
			
end



modifier_templar_assassin_psi_blades_custom_attack_ready = class({})
function modifier_templar_assassin_psi_blades_custom_attack_ready:IsHidden() return false end
function modifier_templar_assassin_psi_blades_custom_attack_ready:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom_attack_ready:GetTexture() return "buffs/psiblades_attack" end
function modifier_templar_assassin_psi_blades_custom_attack_ready:RemoveOnDeath() return false end



modifier_templar_assassin_psi_blades_custom_attack_cd = class({})
function modifier_templar_assassin_psi_blades_custom_attack_cd:IsHidden() return false end
function modifier_templar_assassin_psi_blades_custom_attack_cd:IsPurgable() return false end
function modifier_templar_assassin_psi_blades_custom_attack_cd:GetTexture() return "buffs/psiblades_attack" end
function modifier_templar_assassin_psi_blades_custom_attack_cd:RemoveOnDeath() return false end
function modifier_templar_assassin_psi_blades_custom_attack_cd:IsDebuff() return true end