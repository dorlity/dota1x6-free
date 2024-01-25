LinkLuaModifier("modifier_custom_sonic_heal_knock", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_custom_sonic_heal", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_kills", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_kills_cd", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_tracker", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_fire_thinker", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_lifesteal", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_stack", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_attack_cd", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_kill", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_quest", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_damage", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_sonic_damage_arcana_visual", "abilities/queen_of_pain/custom_queenofpain_sonic_wave", LUA_MODIFIER_MOTION_NONE)




custom_queenofpain_sonic_wave = class({})

custom_queenofpain_sonic_wave.blink_heal = 1


custom_queenofpain_sonic_wave.lifesteal_duration = 5
custom_queenofpain_sonic_wave.lifesteal_bonus = {0.2, 0.3, 0.4}
custom_queenofpain_sonic_wave.lifesteal_creeps = 0.33



custom_queenofpain_sonic_wave.fire_duration = 12
custom_queenofpain_sonic_wave.fire_radius = 150
custom_queenofpain_sonic_wave.fire_length = 1300
custom_queenofpain_sonic_wave.fire_interval = 0.5
custom_queenofpain_sonic_wave.fire_damage_init = 0.05
custom_queenofpain_sonic_wave.fire_damage_inc = 0.05



custom_queenofpain_sonic_wave.attack_cd = 6
custom_queenofpain_sonic_wave.attack_aoe = 300
custom_queenofpain_sonic_wave.attack_damage = 0.25
custom_queenofpain_sonic_wave.attack_heal = 1


custom_queenofpain_sonic_wave.cd_inc = {6, 9, 12}


function custom_queenofpain_sonic_wave:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_1") then
        return "queen_of_pain/arcana/queenofpain_sonic_wave_alt1"
    elseif self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
        return "queen_of_pain/arcana/queenofpain_sonic_wave_alt2"
    end
    return "queenofpain_sonic_wave"
end


function custom_queenofpain_sonic_wave:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonic_wave.vpcf", context )
PrecacheResource( "particle", "particles/qop_sonic_attack.vpcf", context )
PrecacheResource( "particle", "particles/troll_hit.vpcf", context )
PrecacheResource( "particle", "particles/qop_sonic_fire.vpcf", context )
PrecacheResource( "particle", "particles/sf_timer.vpcf", context )
PrecacheResource( "particle", "particles/queenofpain/sonic_stack.vpcf", context )

end




function custom_queenofpain_sonic_wave:GetManaCost(iLevel)

if self:GetCaster():HasModifier("modifier_queenofpain_blood_pact") and self:GetCaster():FindAbilityByName("custom_queenofpain_blood_pact") then 
	return 0
end

local k = 1 
if self:GetCaster():HasModifier("modifier_queen_Sonic_far") then 
	k = (1 + self:GetCaster():GetTalentValue("modifier_queen_Sonic_far", "mana")/100)
end 

return self.BaseClass.GetManaCost(self,iLevel) * k
end 


function custom_queenofpain_sonic_wave:GetHealthCost(level)

if self:GetCaster():HasModifier("modifier_queenofpain_blood_pact") and self:GetCaster():FindAbilityByName("custom_queenofpain_blood_pact") then 
	return self:GetCaster():GetTalentValue("modifier_queen_Scream_legendary", "cost")*self:GetCaster():GetMaxHealth()/100
end

end 

function custom_queenofpain_sonic_wave:GetCastPoint(iLevel)

local bonus = 0

if self:GetCaster():HasModifier('modifier_queen_Sonic_far') then 
	bonus = self:GetCaster():GetTalentValue("modifier_queen_Sonic_far", "cast")
end


return self.BaseClass.GetCastPoint(self) + bonus
end



function custom_queenofpain_sonic_wave:GetIntrinsicModifierName()
return "modifier_custom_sonic_tracker"
end


function custom_queenofpain_sonic_wave:GetCooldown(iLevel)
local upgrade_cooldown = 0	

local base = self.BaseClass.GetCooldown(self, iLevel)
local k = 1
local blue_upgrade = 0

if self:GetCaster():HasModifier("modifier_queen_Sonic_damage") then 
	blue_upgrade = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_damage")]
end

local upgrade_cooldown = self:GetCaster():GetUpgradeStack("modifier_custom_sonic_kills_cd")


return (base - blue_upgrade)*k - upgrade_cooldown*self:GetCaster():GetTalentValue("modifier_queen_Sonic_legendary", "cd")
end



function custom_queenofpain_sonic_wave:OnAbilityPhaseStart()
	if not IsServer() then return end
    local sound = "Hero_QueenOfPain.SonicWave.Precast"
    local particle_name = nil
    if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_1") then
        sound = "Hero_QueenOfPain.SonicWave.Precast.Arcana"
        particle_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_anim_sonic_wave_trace.vpcf"
    elseif self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
        sound = "Hero_QueenOfPain.SonicWave.Precast.Arcana"
        particle_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_anim_sonic_wave_trace_v2.vpcf"
    end
    if particle_name ~= nil then
        self.start_particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    end
	self:GetCaster():EmitSound(sound)
	return true
end

function custom_queenofpain_sonic_wave:OnAbilityPhaseInterrupted()
	if not IsServer() then return end
    local sound = "Hero_QueenOfPain.SonicWave.Precast"
    if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_1") then
        sound = "Hero_QueenOfPain.SonicWave.Precast.Arcana"
    elseif self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
        sound = "Hero_QueenOfPain.SonicWave.Precast.Arcana"
    end
    if self.start_particle ~= nil then
        ParticleManager:DestroyParticle(self.start_particle, true)
        ParticleManager:ReleaseParticleIndex(self.start_particle)
        self.start_particle = nil
    end
	self:GetCaster():StopSound(sound)
end

function custom_queenofpain_sonic_wave:OnSpellStart()
if not IsServer() then return end
local caster = self:GetCaster()
local target_loc = self:GetCursorPosition()
local caster_loc = caster:GetAbsOrigin()

if self.start_particle ~= nil then
    ParticleManager:DestroyParticle(self.start_particle, false)
    ParticleManager:ReleaseParticleIndex(self.start_particle)
    self.start_particle = nil
end

local damage = self:GetSpecialValueFor("damage")
local start_radius = self:GetSpecialValueFor("starting_aoe")
local end_radius = self:GetSpecialValueFor("final_aoe")
local travel_distance = self:GetSpecialValueFor("distance")
local projectile_speed = self:GetSpecialValueFor("speed")

local direction
if target_loc == caster_loc then
	direction = caster:GetForwardVector()
else
	direction = (target_loc - caster_loc):Normalized()
end


local ability = self:GetCaster():FindAbilityByName("custom_queenofpain_scream_of_pain")
if self:GetCaster():HasModifier("modifier_queen_Scream_shield") then 
ability:ProcHeal()
end


if self:GetCaster():HasModifier("modifier_custom_sonic_kills") then 
	damage = damage + self:GetCaster():GetUpgradeStack("modifier_custom_sonic_kills")
end

if self:GetCaster():HasModifier("modifier_queen_Sonic_reduce") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_lifesteal", {duration = self.lifesteal_duration})
end

local sound = "Hero_QueenOfPain.SonicWave"


if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_1") or self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
	caster:EmitSound("Hero_QueenOfPain.SonicWave.ArcanaLayer")
end

caster:EmitSound(sound)

if self:GetCaster():HasModifier("modifier_custom_blink_spell") then 
	self:GetCaster():AddNewModifier(caster, self, "modifier_custom_sonic_heal", {duration = 3})
	self:GetCaster():RemoveModifierByName("modifier_custom_blink_spell")
end

local effect = "particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf"
if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_1") then
    effect = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonic_wave.vpcf"
elseif self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
    effect = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonic_wave_v2.vpcf"
end


projectile =
{
	Ability				= self,
	EffectName			= effect,
	vSpawnOrigin		= caster_loc,
	fDistance			= travel_distance,
	fStartRadius		= start_radius,
	fEndRadius			= end_radius,
	Source				= caster,
	bHasFrontalCone		= true,
	bReplaceExisting	= false,
	iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
	iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	iUnitTargetType		= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	fExpireTime 		= GameRules:GetGameTime() + 10.0,
	bDeleteOnHit		= true,
	vVelocity			= Vector(direction.x,direction.y,0) * projectile_speed,
	bProvidesVision		= false,
	ExtraData			= {damage = damage, x = caster_loc.x, y = caster_loc.y, z = caster_loc.z}
}

ProjectileManager:CreateLinearProjectile(projectile)

if caster:HasModifier("modifier_queen_Sonic_fire") then 
	local end_pos = caster:GetAbsOrigin() + caster:GetForwardVector()*self.fire_length	


	local damage_burn = self.fire_damage_init + self.fire_damage_inc*caster:GetUpgradeStack("modifier_queen_Sonic_fire")
	damage_burn = damage*damage_burn*self.fire_interval


	CreateModifierThinker(caster, self, "modifier_custom_sonic_fire_thinker",
	{duration = self.fire_duration, damage = damage_burn, end_x = end_pos.x, end_y = end_pos.y,end_z = end_pos.z}, 
	caster:GetAbsOrigin(), caster:GetTeamNumber(), false)

end


end

function custom_queenofpain_sonic_wave:OnProjectileHit_ExtraData(target, location, ExtraData)
if not target then return end
if target:GetUnitName() == "npc_teleport" then return end
if target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end

local damage = ExtraData.damage

local stun = 0

if target:HasModifier("modifier_custom_sonic_stack") then 
	local mod = target:FindModifierByName("modifier_custom_sonic_stack")

	damage = damage * (1 + (self:GetCaster():GetTalentValue("modifier_queen_Sonic_taken", "damage")/100)*mod:GetStackCount() )
	
	if mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_queen_Sonic_taken", "max") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = (1 - target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_queen_Sonic_taken", "stun")})
	end

	mod:Destroy()
end

if target:IsRealHero() and self:GetCaster():GetQuest() == "Queen.Quest_8" and not self:GetCaster():QuestCompleted() then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_quest", {duration = self:GetCaster().quest.number})
end

if self:GetCaster():HasModifier("modifier_queen_Sonic_far") then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_generic_break", {duration = (1 - target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_queen_Sonic_far", "duration")})
end 

if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_1") or self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
	target:EmitSound("Hero_QueenOfPain.SonicWave.Arcana.Target")
end

target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_kill", {duration = self:GetCaster():GetTalentValue("modifier_queen_Sonic_legendary", "timer")})

target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_damage", {duration = self:GetSpecialValueFor("knockback_duration"), damage = damage})

target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_heal_knock", 
{
	x = ExtraData.x,
	y = ExtraData.y,
	duration = self:GetSpecialValueFor("knockback_duration"),

})
		

end


function custom_queenofpain_sonic_wave:MakeOrder(target, last_order)
if not IsServer() then return end

local random = -1

repeat random = RandomInt(1, 3)
until random ~= last_order 

if random == 1 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_order_move", {duration = self.order_duration})
end
if random == 2 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_order_attack", {duration = self.order_duration})
end
if random == 3 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_custom_sonic_order_cast", {duration = self.order_duration})
end

	target:EmitSound("QoP.Sonic_order")

end




modifier_custom_sonic_heal = class({})
function modifier_custom_sonic_heal:IsHidden() return true end
function modifier_custom_sonic_heal:IsPurgable() return false end



modifier_custom_sonic_tracker = class({})
function modifier_custom_sonic_tracker:IsHidden() return true end
function modifier_custom_sonic_tracker:IsPurgable() return false end
function modifier_custom_sonic_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_DEATH,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_custom_sonic_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end
if not self:GetParent():HasModifier("modifier_queen_Sonic_cd") then return end
if self:GetParent():HasModifier("modifier_custom_sonic_attack_cd") then return end

params.target:EmitSound("QoP.Sonic_attack")
local scream_pfx = ParticleManager:CreateParticle("particles/qop_sonic_attack.vpcf", PATTACH_ABSORIGIN, params.target)
ParticleManager:SetParticleControl(scream_pfx, 0, params.target:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(scream_pfx)

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), params.target:GetAbsOrigin(), nil, self:GetAbility().attack_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
local damage = self:GetAbility():GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_custom_sonic_kills") then 
	damage = damage + self:GetCaster():GetUpgradeStack("modifier_custom_sonic_kills")
end


damage = damage*self:GetAbility().attack_damage
for _,unit in pairs(units) do 

	ApplyDamage({attacker = self:GetCaster(), victim = unit, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE})
	SendOverheadEventMessage(unit, 4, unit, damage, nil)
end

my_game:GenericHeal(self:GetCaster(), damage*self:GetAbility().attack_heal, self:GetAbility())

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_sonic_attack_cd", {duration = self:GetAbility().attack_cd})
end






function modifier_custom_sonic_tracker:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end

if not self:GetParent():HasModifier("modifier_custom_sonic_heal") then return end
if params.inflictor ~= self:GetAbility() then return end

local heal = params.damage*self:GetAbility().blink_heal

local particle = ParticleManager:CreateParticle( "particles/huskar_leap_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
     ParticleManager:ReleaseParticleIndex( particle )

 self:GetParent():Heal(heal, self:GetParent())
 SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)

end


function modifier_custom_sonic_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if self:GetAbility() == params.ability then return end
if not self:GetParent():HasModifier("modifier_queen_Sonic_taken") then return end


self.caster = self:GetCaster()

Timers:CreateTimer(FrameTime(), function()

	local units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_queen_Sonic_taken", "radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )

	local particle = ParticleManager:CreateParticle("particles/queenofpain/sonic_stack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())

	for _,unit in pairs(units) do 
		unit:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_sonic_stack", {duration = self:GetCaster():GetTalentValue("modifier_queen_Sonic_taken", "duration")})
	end

end)

end


function modifier_custom_sonic_tracker:OnDeath(params)
if not IsServer() then return end
if params.inflictor ~= self:GetAbility() and not params.unit:HasModifier("modifier_custom_sonic_kill") then return end
if params.unit:IsIllusion() then return end


if self:GetParent():HasModifier("modifier_queen_Sonic_legendary") then 

	local max = self:GetCaster():GetTalentValue("modifier_queen_Sonic_legendary", "max")

	local damage = self:GetCaster():GetTalentValue("modifier_queen_Sonic_legendary", "damage_creeps")

	local mod = self:GetParent():FindModifierByName("modifier_custom_sonic_kills")

	if not mod then 
		mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_sonic_kills", {})
	end


	if params.unit:IsValidKill(self:GetParent()) then 

		damage = self:GetCaster():GetTalentValue("modifier_queen_Sonic_legendary", "damage_heroes")

		local mod_cd = self:GetParent():FindModifierByName("modifier_custom_sonic_kills_cd")

		if not mod_cd then 
			mod_cd = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_sonic_kills_cd", {})
		end

		if mod_cd:GetStackCount() < max then 

			mod_cd:IncrementStackCount()

			if mod_cd:GetStackCount() >= max then 

				local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
				ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_peffect)
				self:GetCaster():EmitSound("BS.Thirst_legendary_active")
			end
		end
	end

	mod:SetStackCount(mod:GetStackCount() + damage)

end



end



modifier_custom_sonic_kills = class({})
function modifier_custom_sonic_kills:IsHidden() return false end
function modifier_custom_sonic_kills:IsPurgable() return false end
function modifier_custom_sonic_kills:RemoveOnDeath() return false end
function modifier_custom_sonic_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
}
end




function modifier_custom_sonic_kills:OnTooltip() return self:GetStackCount() end




modifier_custom_sonic_fire_thinker = class({})

function modifier_custom_sonic_fire_thinker:IsHidden() return true end

function modifier_custom_sonic_fire_thinker:IsPurgable() return false end


function modifier_custom_sonic_fire_thinker:OnCreated(table)
if not IsServer() then return end
			
	self.start_pos = self:GetParent():GetAbsOrigin()
	self.end_pos = Vector(table.end_x,table.end_y,table.end_z)
	self.damage = table.damage

	self:GetParent():EmitSound("QoP.Sonic_fire")



	self.pfx = ParticleManager:CreateParticle("particles/qop_sonic_fire.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(self.pfx, 0, self.start_pos)
    ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetAbility().fire_duration, 0, 0))
    ParticleManager:SetParticleControl(self.pfx, 1, self.end_pos)
    ParticleManager:SetParticleControl(self.pfx, 3, self.end_pos)
     ParticleManager:ReleaseParticleIndex(self.pfx)
 	self:AddParticle(self.pfx,false,false,-1,false,false)

self:StartIntervalThink(self:GetAbility().fire_interval)
self:OnIntervalThink()
end

function modifier_custom_sonic_fire_thinker:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("QoP.Sonic_fire")

end


function modifier_custom_sonic_fire_thinker:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInLine(self:GetParent():GetTeamNumber(), self.start_pos,self.end_pos, nil, self:GetAbility().fire_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_NONE)

for _,enemy in ipairs(enemies) do 
	if not enemy:IsMagicImmune() then 
		ApplyDamage({attacker = self:GetAbility():GetCaster(), victim = enemy, ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(enemy, 4, enemy, self.damage, nil)
	end
end

end




modifier_custom_sonic_lifesteal = class({})

function modifier_custom_sonic_lifesteal:IsHidden() return false end
function modifier_custom_sonic_lifesteal:IsPurgable() return false end
function modifier_custom_sonic_lifesteal:GetTexture() return "buffs/sonic_reduce" end
function modifier_custom_sonic_lifesteal:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_custom_sonic_lifesteal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self:GetAbility().lifesteal_bonus[self:GetCaster():GetUpgradeStack("modifier_queen_Sonic_reduce")]
if params.unit:IsCreep() then 
  heal = heal * self:GetAbility().lifesteal_creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), false)

end



modifier_custom_sonic_kills_cd = class({})
function modifier_custom_sonic_kills_cd:IsHidden() return false end
function modifier_custom_sonic_kills_cd:IsPurgable() return false end
function modifier_custom_sonic_kills_cd:RemoveOnDeath() return false end
function modifier_custom_sonic_kills_cd:GetTexture() return "buffs/sonic_cd" end
function modifier_custom_sonic_kills_cd:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,	
	MODIFIER_PROPERTY_TOOLTIP2
}
end



function modifier_custom_sonic_kills_cd:OnCreated()
self.cd = self:GetCaster():GetTalentValue("modifier_queen_Sonic_legendary", "cd")
end

function modifier_custom_sonic_kills_cd:OnTooltip() return self:GetStackCount() end
function modifier_custom_sonic_kills_cd:OnTooltip2() return self:GetStackCount()*self.cd end



modifier_custom_sonic_stack = class({})
function modifier_custom_sonic_stack:IsHidden() return false end
function modifier_custom_sonic_stack:IsPurgable() return false end
function modifier_custom_sonic_stack:GetTexture() return "buffs/sonic_stack" end

function modifier_custom_sonic_stack:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_queen_Sonic_taken", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_queen_Sonic_taken", "damage")

if not IsServer() then return end
self.pfx = ParticleManager:CreateParticle("particles/sf_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.pfx,false, false, -1, false, false)
self:SetStackCount(1)
end

function modifier_custom_sonic_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_custom_sonic_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.pfx then return end

ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))

if self:GetStackCount() >= self.max then 
	ParticleManager:DestroyParticle(self.pfx, true)
	ParticleManager:ReleaseParticleIndex(self.pfx)


	self.particle_trail = ParticleManager:CreateParticle("particles/lc_odd_charge_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.particle_trail, false, false, -1, false, false)

end

end



function modifier_custom_sonic_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_custom_sonic_stack:OnTooltip()
return self.damage*self:GetStackCount()
end



modifier_custom_sonic_attack_cd = class({})
function modifier_custom_sonic_attack_cd:IsHidden() return false end
function modifier_custom_sonic_attack_cd:IsPurgable() return false end
function modifier_custom_sonic_attack_cd:RemoveOnDeath() return false end
function modifier_custom_sonic_attack_cd:IsDebuff() return true end
function modifier_custom_sonic_attack_cd:GetTexture() return "buffs/sonic_cd" end
function modifier_custom_sonic_attack_cd:OnCreated(table)
self.RemoveForDuel = true
end



modifier_custom_sonic_kill = class({})
function modifier_custom_sonic_kill:IsHidden() return true end
function modifier_custom_sonic_kill:IsPurgable() return false end
function modifier_custom_sonic_kill:RemoveOnDeath() return false end



modifier_custom_sonic_quest = class({})
function modifier_custom_sonic_quest:IsHidden() return true end
function modifier_custom_sonic_quest:IsPurgable() return false end
function modifier_custom_sonic_quest:RemoveOnDeath() return false end











modifier_custom_sonic_heal_knock = class({})

function modifier_custom_sonic_heal_knock:IsHidden() return true end
function modifier_custom_sonic_heal_knock:IsPurgable() return false end

function modifier_custom_sonic_heal_knock:OnCreated(params)
if not IsServer() then return end

self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self:GetParent():StartGesture(ACT_DOTA_FLAIL)

self.start_point = Vector(params.x, params.y, 0)

self.knockback_duration   = self:GetRemainingTime()

self.knockback_distance   = self:GetAbility():GetSpecialValueFor("knockback_distance")*(1 - self:GetParent():GetStatusResistance())

self.knockback_speed    = self.knockback_distance / self.knockback_duration

local dir = (self.start_point - self:GetParent():GetAbsOrigin()):Normalized()


self.position = GetGroundPosition(self:GetParent():GetAbsOrigin() + dir*self.knockback_distance, nil)

if self:ApplyHorizontalMotionController() == false then 
self:Destroy()
return
end


end

function modifier_custom_sonic_heal_knock:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end

  local distance = (me:GetOrigin() - self.position):Normalized()
  
  me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

  GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), self.parent:GetHullRadius(), true )
end

function modifier_custom_sonic_heal_knock:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_custom_sonic_heal_knock:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_custom_sonic_heal_knock:OnDestroy()
  if not IsServer() then return end
  self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)
end



modifier_custom_sonic_damage = class({})
function modifier_custom_sonic_damage:IsHidden() return true end
function modifier_custom_sonic_damage:IsPurgable() return false end
function modifier_custom_sonic_damage:OnCreated(table)
if not IsServer() then return end
self.damage = table.damage
self.interval = self:GetAbility():GetSpecialValueFor("tick_rate")
self.duration = self:GetRemainingTime()
self.tick_damage = (self.damage/self.duration)*self.interval
self:StartIntervalThink(self.interval)
if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_1") or self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
    local particle_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonicwave_tgt.vpcf"
    if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
        particle_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_sonicwave_tgt_v2.vpcf"
    end
    local particle_think = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControlEnt(particle_think, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
    ParticleManager:SetParticleControl(particle_think, 2, self:GetCaster():GetAbsOrigin())
    self:AddParticle(particle_think, false, false, -1, false, false)
    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_custom_sonic_damage_arcana_visual", {duration = self:GetDuration()})
end
end 

function modifier_custom_sonic_damage:OnIntervalThink()
if not IsServer() then return end 

ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), ability = self:GetAbility(), damage = self.tick_damage, damage_type = DAMAGE_TYPE_PURE})
end

function modifier_custom_sonic_damage:OnDestroy()
    if not IsServer() then return end
    if self:GetParent():IsAlive() then return end
    if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_1") or self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
        local particle_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_tgt_death.vpcf"
        if self:GetCaster():HasModifier("modifier_queenofpain_arcana_custom_2") then
            particle_name = "particles/econ/items/queen_of_pain/qop_arcana/qop_arcana_v2_tgt_death.vpcf"
        end
        local particle_die = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:ReleaseParticleIndex(particle_die)
    end
end

modifier_custom_sonic_damage_arcana_visual = class({})
function modifier_custom_sonic_damage_arcana_visual:IsHidden() return true end
function modifier_custom_sonic_damage_arcana_visual:IsPurgable() return false end
function modifier_custom_sonic_damage_arcana_visual:IsPurgeException() return false end
function modifier_custom_sonic_damage_arcana_visual:GetStatusEffectName()
    return "particles/status_fx/status_effect_qop_tgt_arcana.vpcf"
end
function modifier_custom_sonic_damage_arcana_visual:StatusEffectPriority()
    return 10
end