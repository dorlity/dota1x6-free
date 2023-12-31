LinkLuaModifier("modifier_towerresist_aura", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_towerresist", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_towercourier", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_stun", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_stun_thinker", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_stun_debuff", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_stun_cd", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_stun_search", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_plasma", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_plasma_cd", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_plasma_search", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_plasma_dire", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_plasma_cd_dire", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tower_plasma_search_dire", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_ring_tower_lua", "abilities/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_armor_aura", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_armor_cd", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_resist_filler", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stun_filler", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_plasma_filler", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_plasma_filler_dire", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fillerstun_armor", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fillerresist_armor", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fillerplasma_armor", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_filler_armor", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_truesight", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_resist_regen", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_resist_vision", "abilities/tower_abilities.lua", LUA_MODIFIER_MOTION_NONE )









tower_aura_regen = class({})

function tower_aura_regen:GetIntrinsicModifierName() return "modifier_towerresist" end

function tower_aura_regen:GetCastRange(vLocation, hTarget) return self:GetCaster():Script_GetAttackRange() end 

modifier_towerresist = class({})

function modifier_towerresist:IsHidden() return true end

function modifier_towerresist:IsPurgable() return false end

function modifier_towerresist:IsAura() 
if self:GetParent():HasModifier("modifier_razor_tower_custom") then return false end
return true end

function modifier_towerresist:GetAuraDuration() return 3 end

function modifier_towerresist:GetAuraRadius() return self:GetCaster():Script_GetAttackRange() end

function modifier_towerresist:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_towerresist:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING 
 end

function modifier_towerresist:GetModifierAura() return "modifier_towerresist_aura" end


function modifier_towerresist:CheckState()
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end


function modifier_towerresist:OnCreated()

	if not IsServer() then
        return
    end
    self.count = 0
	self:StartIntervalThink(0.3)


end


function modifier_towerresist:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_tower_aura") then 
  self:GetParent():RemoveModifierByName("modifier_tower_aura")
end

if GameRules:GetDOTATime(false, false) < push_timer then return end

local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS  + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES  + DOTA_UNIT_TARGET_FLAG_INVULNERABLE  + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD , FIND_CLOSEST, false)
 
for _,unit in pairs(units) do
	if unit:IsRealHero()
	and not unit:HasModifier("modifier_custom_terrorblade_reflection_unit")
	and not unit:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
		unit:AddNewModifier(unit, nil, "modifier_resist_vision", {team = self:GetParent():GetTeamNumber(), duration = 0.5})
	end
end
end


modifier_towerresist_aura = class({})

function modifier_towerresist_aura:IsHidden() 
return self:GetStackCount() > 0
end

function modifier_towerresist_aura:IsPurgable() return false end
function modifier_towerresist_aura:CheckState()

 if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then return end
if self:GetParent() == nil then return end  
if not self:GetParent():IsHero() then return end
if not PlayerResource:GetConnectionState(self:GetParent():GetPlayerOwnerID())  then return end
if PlayerResource:GetConnectionState(self:GetParent():GetPlayerOwnerID()) ~= DOTA_CONNECTION_STATE_DISCONNECTED 
	and PlayerResource:GetConnectionState(self:GetParent():GetPlayerOwnerID()) ~= DOTA_CONNECTION_STATE_ABANDONED then return end
if players[self:GetParent():GetTeamNumber()] == nil then return end
if self:GetParent():HasModifier("modifier_death") then return end	

return
{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true
	}
end



function modifier_towerresist_aura:DeclareFunctions()

	return 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,	
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end 

function modifier_towerresist_aura:OnTooltip() return self.health_regen end 
function modifier_towerresist_aura:OnTooltip2() return self.mana_regen end 







function modifier_towerresist_aura:OnCreated(table)
if not self:GetAbility() then return end

self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")

self.interval = self:GetAbility():GetSpecialValueFor("damage_interval")

self.tower_heal = 0
if self:GetParent():IsBuilding() then 
	if self:GetParent():GetUnitName() == "npc_towerradiant" or self:GetParent():GetUnitName() == "npc_towerdire" then 
		self.tower_heal = 2
	else 
		self.tower_heal = 10
	end
end

self:SetStackCount(0)
end


function modifier_towerresist_aura:GetModifierConstantHealthRegen()
if self:GetParent():HasModifier("modifier_tower_incoming_no_heal") then return end

return self.tower_heal
end


function modifier_towerresist_aura:GetModifierHealthRegenPercentage() 
if self:GetParent():IsBuilding() then return end
if self:GetStackCount() > 0 then return end
return self.health_regen 
end

function modifier_towerresist_aura:GetModifierTotalPercentageManaRegen() 
if self:GetParent():IsBuilding() then return end
if self:GetStackCount() > 0 then return end
return self.mana_regen 
end


function modifier_towerresist_aura:OnIntervalThink()
self:SetStackCount(0)
self:StartIntervalThink(-1)

end

function modifier_towerresist_aura:OnTakeDamage(params)
if self:GetParent():IsBuilding() then return end
if self:GetParent() ~= params.unit then return end
if not params.attacker then return end
if params.attacker == self:GetParent() then return end
if (params.attacker:GetAbsOrigin() - towers[self:GetParent():GetTeamNumber()]:GetAbsOrigin()):Length2D() > 900 then return end

self:SetStackCount(1)


self:StartIntervalThink(self.interval)

end


tower_aura_courier = class({})

function tower_aura_courier:GetIntrinsicModifierName() return "modifier_towercourier" end

function tower_aura_courier:GetCastRange(vLocation, hTarget) return self:GetCaster():Script_GetAttackRange() end 

modifier_towercourier = class({})

function modifier_towercourier:IsHidden() return true end

function modifier_towercourier:IsPurgable() return false end

function modifier_towercourier:IsAura() return true end

function modifier_towercourier:GetAuraDuration() return 0.1 end

function modifier_towercourier:GetAuraRadius() return self:GetCaster():Script_GetAttackRange() end

function modifier_towercourier:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_towercourier:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_towercourier:GetAuraSearchType() return DOTA_UNIT_TARGET_COURIER
 end

function modifier_towercourier:GetModifierAura() return "modifier_invulnerable" end


tower_truesight = class({})



function tower_truesight:GetIntrinsicModifierName() return "modifier_tower_truesight" end


modifier_tower_truesight = class({})


function modifier_tower_truesight:IsHidden() return true end
function modifier_tower_truesight:IsPurgable() return false end
function modifier_tower_truesight:RemoveOnDeath() return false end


function modifier_tower_truesight:GetAuraRadius()
	return 1200
end

function modifier_tower_truesight:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_tower_truesight:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_tower_truesight:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_tower_truesight:GetModifierAura()
	return "modifier_truesight"
end
function modifier_tower_truesight:IsAura() return true end






tower_stun = class({})




function tower_stun:GetIntrinsicModifierName() return "modifier_tower_stun_search" end


modifier_tower_stun_search = class({})



function modifier_tower_stun_search:IsHidden() return true end

function modifier_tower_stun_search:OnCreated(table)
 if not IsServer() then return end
 	self.aoe = self:GetAbility():GetSpecialValueFor("aoe")
    self:StartIntervalThink(FrameTime())
end

function modifier_tower_stun_search:OnIntervalThink()
if not IsServer() then return end

if GameRules:State_Get() <= DOTA_GAMERULES_STATE_PRE_GAME then
    return
end

local owner = players[self:GetParent():GetTeamNumber()]
if owner then 
	if owner:HasModifier("modifier_target") then 
		return
	end
end

if self:GetParent():HasModifier("modifier_razor_tower_custom") then return end


if self:GetParent():HasModifier("modifier_tower_stun_cd") then return end
if not self:GetParent():IsAlive() then return end
local enemy_for_ability = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE , FIND_CLOSEST, false)
 if #enemy_for_ability > 0 then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tower_stun_cd", {duration = self:GetAbility():GetSpecialValueFor("cd")})
    CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_tower_stun_thinker", {duration = self:GetAbility():GetSpecialValueFor("delay")}, enemy_for_ability[1]:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
     

 end
end




modifier_tower_stun_thinker = class({})

function modifier_tower_stun_thinker:IsHidden() return true end

function modifier_tower_stun_thinker:IsPurgable() return false end

function modifier_tower_stun_thinker:OnCreated(table)
if not IsServer() then return end
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
	self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )

end





function modifier_tower_stun_thinker:OnDestroy(table)
if not IsServer() then return end
if not self:GetCaster() then return end

	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

    self:GetParent():EmitSound("Ability.FrostNova")
    local seed_particle = ParticleManager:CreateParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova.vpcf", PATTACH_WORLDORIGIN, nil)
	  ParticleManager:SetParticleControl(seed_particle, 0, self:GetParent():GetAbsOrigin())
	  ParticleManager:SetParticleControl(seed_particle, 1, self:GetParent():GetAbsOrigin())
	  ParticleManager:SetParticleControl(seed_particle, 2, self:GetParent():GetAbsOrigin())
	  ParticleManager:ReleaseParticleIndex(seed_particle)



  local  enemy_for_ability = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE , FIND_CLOSEST, false)
   for _,i in ipairs(enemy_for_ability) do
   	if not i:IsMagicImmune() then 

   		local damage = self:GetAbility():GetSpecialValueFor("damage")*i:GetMaxHealth()/100
			SendOverheadEventMessage(i, 4, i, damage, nil)

   		ApplyDamage({ victim = i, attacker = self:GetAbility():GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

   	end

   end
   


end





modifier_tower_stun_cd = class({})

function modifier_tower_stun_cd:IsHidden() return false end
function modifier_tower_stun_cd:IsPurgable() return false end






tower_plasma = class({})


function tower_plasma:GetIntrinsicModifierName() return "modifier_tower_plasma_search" end

modifier_tower_plasma_search = class({})

function modifier_tower_plasma_search:OnCreated(table)
 if not IsServer() then return end
 	self.aoe = self:GetAbility():GetSpecialValueFor("aoe")
    self:StartIntervalThink(FrameTime())
end

function modifier_tower_plasma_search:OnIntervalThink()
if not IsServer() then return end


if GameRules:State_Get() <= DOTA_GAMERULES_STATE_PRE_GAME then
    return
end

local owner = players[self:GetParent():GetTeamNumber()]
if owner then 
	if owner:HasModifier("modifier_target") then 
		return
	end
end
if self:GetParent():HasModifier("modifier_razor_tower_custom") then return end

if self:GetParent():HasModifier("modifier_tower_plasma_cd") then return end
if not self:GetParent():IsAlive() then return end
local time = self:GetAbility():GetSpecialValueFor("radius")/self:GetAbility():GetSpecialValueFor("speed")
local enemy_for_ability = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_CLOSEST, false)
 if #enemy_for_ability > 0 then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tower_plasma_cd", {duration = self:GetAbility():GetSpecialValueFor("cd")})
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tower_plasma", {duration = time})

 end
end

function modifier_tower_plasma_search:IsHidden() return 
 true end
function modifier_tower_plasma_search:IsPurgable() return
 false end

modifier_tower_plasma = class({})

function modifier_tower_plasma:IsHidden() return true end
function modifier_tower_plasma:IsPurchasable() return false end



function modifier_tower_plasma:OnCreated(table)
if not IsServer() then return end
	local caster = self:GetParent()
	local radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local speed = self:GetAbility():GetSpecialValueFor( "speed" )

	local particle_cast = "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"
	if caster:GetUnitName() == "npc_towerdire" then 
		particle_cast =  "particles/dire_plasma.vpcf"
	end
	local sound_cast = "Ability.PlasmaField"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( speed, radius, 1 ) )

	caster:EmitSound( sound_cast )


	local pulse = caster:AddNewModifier(
		caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_ring_tower_lua", -- modifier name
		{
			end_radius = radius,
			speed = speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO,
		} -- kv
	)
	pulse:SetCallback()


		
end

function modifier_tower_plasma:OnDestroy()
if not IsServer() then return end
if not self.effect_cast then return end
ParticleManager:DestroyParticle(self.effect_cast, false)
ParticleManager:ReleaseParticleIndex(self.effect_cast)
end

--------------------------------------------------------------------------------


modifier_tower_plasma_cd = class({})

function modifier_tower_plasma_cd:IsHidden() return false end
function modifier_tower_plasma_cd:IsPurgable() return false end






tower_aura_resist = class({})

function tower_aura_resist:GetIntrinsicModifierName()
 return "modifier_tower_armor_aura" 
end


modifier_tower_armor_aura = class({})

function modifier_tower_armor_aura:IsHidden() return false end

function modifier_tower_armor_aura:IsPurgable() return false end

function modifier_tower_armor_aura:OnCreated(table)
if not IsServer() then return end
self.respawn = self:GetAbility():GetSpecialValueFor("respawn")/100
end















modifier_tower_armor_cd = class({})


function modifier_tower_armor_cd:IsPurgable() return false end
function modifier_tower_armor_cd:IsHidden()
 return false end
function modifier_tower_armor_cd:IsDebuff() return true end





tower_resist_filler = class({})

function tower_resist_filler:GetIntrinsicModifierName() return "modifier_resist_filler" end

modifier_resist_filler = class({})
function modifier_resist_filler:IsHidden() return true end
function modifier_resist_filler:IsPurgable() return false end

function modifier_resist_filler:IsAura() return true end

function modifier_resist_filler:GetAuraDuration() return 0.1 end

function modifier_resist_filler:GetAuraRadius() return 1500 end

function modifier_resist_filler:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_resist_filler:GetAbilityTargetFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_resist_filler:GetAuraSearchType() return DOTA_UNIT_TARGET_BUILDING
end


function modifier_resist_filler:GetAuraEntityReject(hEntity)
if hEntity:GetUnitName() ~= "npc_towerdire" and hEntity:GetUnitName() ~= "npc_towerradiant" then return true end
return false
end

function modifier_resist_filler:GetModifierAura() return "modifier_fillerresist_armor" end
function modifier_resist_filler:DeclareFunctions()
return
{
MODIFIER_EVENT_ON_DEATH
}
end
function modifier_resist_filler:OnDeath(params)
if not IsServer() then return end
if self:GetParent() == params.unit then 
	local towers = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
 	for _,tower in ipairs(towers) do
 		if tower:GetUnitName() == "npc_towerdire" or tower:GetUnitName() == "npc_towerradiant" then
 			local ability = tower:FindAbilityByName("tower_aura_resist")
 			if ability then
 				ability:SetLevel(0)
 			end
 			local mod = tower:FindModifierByName("modifier_tower_armor_aura")
 			if mod then 
 				mod:Destroy()
 			end
 		end
 	end	
end
end



tower_stun_filler = class({})

function tower_stun_filler:GetIntrinsicModifierName() return "modifier_stun_filler" end

modifier_stun_filler = class({})
function modifier_stun_filler:IsHidden() return true end
function modifier_stun_filler:IsPurgable() return false end

function modifier_stun_filler:IsAura() return true end

function modifier_stun_filler:GetAuraDuration() return 0.1 end

function modifier_stun_filler:GetAuraRadius() return 1500 end

function modifier_stun_filler:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_stun_filler:GetAbilityTargetFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_stun_filler:GetAuraSearchType() return DOTA_UNIT_TARGET_BUILDING
end

function modifier_stun_filler:GetModifierAura() return "modifier_fillerstun_armor" end

function modifier_stun_filler:GetAuraEntityReject(hEntity)
if hEntity:GetUnitName() ~= "npc_towerdire" and hEntity:GetUnitName() ~= "npc_towerradiant" then return true end
return false
end

function modifier_stun_filler:OnCreated(table)
if not IsServer() then return end
local i = self:GetParent()
local effect_name = ''

 end


function modifier_stun_filler:DeclareFunctions()
return
{
MODIFIER_EVENT_ON_DEATH
}
end
function modifier_stun_filler:OnDeath(params)
if not IsServer() then return end
if self:GetParent() == params.unit then 
	local towers = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
 	for _,tower in ipairs(towers) do
 		if tower:GetUnitName() == "npc_towerdire" or tower:GetUnitName() == "npc_towerradiant" then
 			local ability = tower:FindAbilityByName("tower_stun")
 			if ability then
 				ability:SetLevel(0)
 			end
 			local mod = tower:FindModifierByName("modifier_tower_stun_search")
 			if mod then 
 				mod:Destroy()
 			end

 			mod = tower:FindModifierByName("modifier_tower_stun")
 			if mod then 
 				mod:Destroy()
 			end


 		end
 	end	
end
end


tower_plasma_filler = class({})

function tower_plasma_filler:GetIntrinsicModifierName() return "modifier_plasma_filler" end

modifier_plasma_filler = class({})
function modifier_plasma_filler:IsHidden() return true end
function modifier_plasma_filler:IsPurgable() return false end

function modifier_plasma_filler:IsAura() return true end

function modifier_plasma_filler:GetAuraDuration() return 0.1 end

function modifier_plasma_filler:GetAuraRadius() return 1500 end

function modifier_plasma_filler:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_plasma_filler:GetAbilityTargetFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end

function modifier_plasma_filler:GetAuraSearchType() return DOTA_UNIT_TARGET_BUILDING
end

function modifier_plasma_filler:GetModifierAura() return "modifier_fillerplasma_armor" end

function modifier_plasma_filler:GetAuraEntityReject(hEntity)
if hEntity:GetUnitName() ~= "npc_towerdire" and hEntity:GetUnitName() ~= "npc_towerradiant" then return true end
return false
end

function modifier_plasma_filler:DeclareFunctions()
return
{
MODIFIER_EVENT_ON_DEATH
}
end
function modifier_plasma_filler:OnDeath(params)
if not IsServer() then return end
if self:GetParent() == params.unit then 
	local towers = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
 	for _,tower in ipairs(towers) do
 		if tower:GetUnitName() == "npc_towerdire" or tower:GetUnitName() == "npc_towerradiant" then
 			local ability = tower:FindAbilityByName("tower_plasma")
 			if not ability then 
 				ability = tower:FindAbilityByName("tower_plasma_dire")
 			end
 			if ability then
 				ability:SetLevel(0)
 			end
 			local mod = tower:FindModifierByName("modifier_tower_plasma_search")
 			if mod then 
 				mod:Destroy()
 			end
 		end
 	end	
end
end





tower_plasma_dire = class({})


function tower_plasma_dire:GetIntrinsicModifierName() return "modifier_tower_plasma_search" end



tower_plasma_filler_dire = class({})

function tower_plasma_filler_dire:GetIntrinsicModifierName() return "modifier_plasma_filler" end






modifier_fillerplasma_armor = class({})
function modifier_fillerplasma_armor:IsHidden() return true end
function modifier_fillerplasma_armor:IsPurgable() return false end
function modifier_fillerplasma_armor:OnCreated(table)
if not IsServer() then return end
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_filler_armor", {})
end

function modifier_fillerplasma_armor:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_filler_armor")
if mod then 
	
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end


modifier_fillerresist_armor = class({})
function modifier_fillerresist_armor:IsHidden() return true end
function modifier_fillerresist_armor:IsPurgable() return false end
function modifier_fillerresist_armor:OnCreated(table)
if not IsServer() then return end
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_filler_armor", {})
end

function modifier_fillerresist_armor:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_filler_armor")
if mod then 
	
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end

modifier_fillerstun_armor = class({})
function modifier_fillerstun_armor:IsHidden() return true end
function modifier_fillerstun_armor:IsPurgable() return false end
function modifier_fillerstun_armor:OnCreated(table)
if not IsServer() then return end
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_filler_armor", {})
end

function modifier_fillerstun_armor:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_filler_armor")
if mod then 

	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end



modifier_filler_armor = class({})
function modifier_filler_armor:IsHidden() return false end
function modifier_filler_armor:IsPurgable() return false end
function modifier_filler_armor:GetTexture() return "buffs/tower_armor" end
function modifier_filler_armor:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_filler_armor:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_filler_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_filler_armor:GetModifierPhysicalArmorBonus() return 
--6*self:GetStackCount() 
end


function modifier_filler_armor:OnTooltip()
return self:GetStackCount()*20
end



tower_filler_aura = class({})



modifier_resist_vision = class({})
function modifier_resist_vision:IsHidden() return true end
function modifier_resist_vision:IsPurgable() return false end
function modifier_resist_vision:RemoveOnDeath() return false end
function modifier_resist_vision:OnCreated(table)
if not IsServer() then return end
local team = table.team
self.tower = towers[team]

self:StartIntervalThink(0.5)
end

function modifier_resist_vision:OnIntervalThink()
if not IsServer() then return end
if self.tower == nil then
	self:Destroy()
	return
end
if not self.tower or self.tower:IsNull() then return end


AddFOWViewer(self:GetParent():GetTeamNumber(), self.tower:GetAbsOrigin(), 1000, 3, false)
end