LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skelet_reincarnation", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_stats", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_wraith_king_skeleton_ghost_slow_mod", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_wraith_king_skeleton_ghost_slow", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_path", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_shield", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_buff", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_skelet_buff", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_totem", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_totem_aura", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )



skeleton_king_vampiric_aura_custom = class({})

skeleton_king_vampiric_aura_custom.skelet_count = 0


function skeleton_king_vampiric_aura_custom:CreateTalent()
local caster = self:GetCaster()
caster:AddNewModifier(caster, self, "modifier_skeleton_king_vampiric_aura_custom_buff", {})
end

function skeleton_king_vampiric_aura_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle","particles/neutral_fx/skeleton_spawn.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", context )
PrecacheResource( "particle","particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_drow_frost_arrow.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_shield_rune.vpcf", context )
PrecacheResource( "particle","particles/wk_shield.vpcf", context )
PrecacheResource( "particle","particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_hands_glow.vpcf", context )
PrecacheResource( "particle","particles/items5_fx/wraith_pact_ambient.vpcf", context )
PrecacheResource( "particle","particles/items5_fx/wraith_pact_pulses_target.vpcf", context )
PrecacheResource( "particle","particles/centaur/return_legendary_pulses.vpcf", context )
PrecacheResource( "particle","particles/wraith_king/totem_dispell.vpcf", context )

PrecacheUnitByNameSync("npc_dota_wraith_king_skeleton_totem_custom", context, -1)
PrecacheUnitByNameSync("npc_dota_wraith_king_skeleton_ghost_custom", context, -1)
PrecacheUnitByNameSync("npc_dota_wraith_king_skeleton_warrior_custom", context, -1)
end




function skeleton_king_vampiric_aura_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_wraith_king_custom_frostivus_weapon") then
    return "skeleton_king_bone_guard_frostivus"
end
if self:GetCaster():HasModifier("modifier_wraith_king_custom_frostivus_weapon") then
    return "skeleton_king_bone_guard_frostivus"
end
if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") then
    return "skeleton_king/arcana/skeleton_king_bone_guard_arcana"
end
if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
    return "skeleton_king/arcana/skeleton_king_bone_guard_arcana_alt"
end
return "skeleton_king_bone_guard"
end






function skeleton_king_vampiric_aura_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_skeleton_king_vampiric_aura_custom"
end



function skeleton_king_vampiric_aura_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_skeleton_king_vampiric_aura_custom")
if mod and mod:GetStackCount() <= 0 and not caster:HasTalent("modifier_skeleton_vampiric_4") then
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer( caster:GetPlayerOwnerID() ), "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
    return false
end
return true
end




function skeleton_king_vampiric_aura_custom:OnSpellStart()
local caster = self:GetCaster()

local modifier = caster:FindModifierByName("modifier_skeleton_king_vampiric_aura_custom")
if not modifier then return end

local charges = modifier:GetStackCount()

if caster:HasTalent("modifier_skeleton_vampiric_4") then

	local totem = CreateUnitByName( "npc_dota_wraith_king_skeleton_totem_custom", caster:GetAbsOrigin() + RandomVector(150), true, caster, caster, caster:GetTeamNumber() )
	totem.owner = caster
	totem:SetOwner( caster )
	totem:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("skeleton_duration")})
	totem:AddNewModifier(caster, self, "modifier_skeleton_king_vampiric_aura_custom_totem", {})	
end

if charges <= 0 then return end
local delay = self:GetSpecialValueFor("spawn_interval")

caster:EmitSound("Hero_SkeletonKing.MortalStrike.Cast")

if caster:GetQuest() == "Wraith.Quest_6" and not caster:QuestCompleted() then 
	caster:UpdateQuest(charges)
end

for i = 1,charges do
	caster:AddNewModifier(caster, self, "modifier_skeleton_king_vampiric_aura_stats", {})
end


for i = 0,charges - 1 do
	Timers:CreateTimer(delay * i, function ()
		self:CreateSkeleton(caster:GetOrigin()+RandomVector(300), nil, nil, true)
	end)
end

if test then return end
modifier:SetStackCount( 0 )
end





function skeleton_king_vampiric_aura_custom:CreateSkeleton(origin, target, duration_custom, reincarnation, legendary_spawn, new_name)
if not IsServer() then return end
local caster = self:GetCaster()
if not caster or not players[caster:GetId()] then return end

local name =  "npc_dota_wraith_king_skeleton_warrior_custom"
local is_ghost = false

if caster:HasTalent("modifier_skeleton_vampiric_legendary") and not new_name then 
	self.skelet_count = self.skelet_count + 1

	if self.skelet_count >= caster:GetTalentValue("modifier_skeleton_vampiric_legendary", "count") then 
		self.skelet_count = 0
		is_ghost = true
		name = "npc_dota_wraith_king_skeleton_ghost_custom"

		if legendary_spawn and target then 
			local vec = caster:GetAbsOrigin() - target:GetAbsOrigin()
			origin = target:GetAbsOrigin() + vec:Normalized()*400
		end
	else 
		if legendary_spawn then 
			origin = origin + RandomVector(120)
		end
	end
end 

if new_name then
	name = new_name
end

local duration = self:GetSpecialValueFor("skeleton_duration")
if duration_custom then
	duration = duration_custom
end

local spawn_particle = "particles/neutral_fx/skeleton_spawn.vpcf"
if caster:HasModifier("modifier_wraith_king_arcana_custom_v1") or caster:HasModifier("modifier_wraith_king_arcana_custom_v2") then
    spawn_particle = "particles/wk_arc_minion_ambient.vpcf"
end

local skelet = CreateUnitByName( name, origin, true, caster, caster, caster:GetTeamNumber() )

skelet.owner = caster
skelet.skelet = true
skelet:GenericParticle(spawn_particle)
skelet:SetOwner( caster )

if name == "npc_dota_wraith_king_skeleton_warrior_custom" then
    if caster:HasModifier("modifier_wraith_king_custom_frostivus_weapon") then
        skelet:SetModel("models/items/wraith_king/frostivus_wraith_king/frostivus_wraith_king_skeleton.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/frostivus_wraith_king/frostivus_wraith_king_skeleton.vmdl")
    elseif caster:HasModifier("modifier_wraith_king_ti_8_weapon") then
        skelet:SetModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl")
    elseif caster:HasModifier("modifier_wraith_king_ti_8_weapon_crimson") then
        skelet:SetModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_crimson.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_crimson.vmdl")
    elseif caster:HasModifier("modifier_wraith_king_arcana_custom_v1") then
        skelet:SetModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
    elseif caster:HasModifier("modifier_wraith_king_arcana_custom_v2") then
        skelet:SetModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
    end
end

local modifier_kill_skelet = skelet:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
local modifier = skelet:AddNewModifier(caster, self, "modifier_skeleton_king_vampiric_aura_custom_skeleton_ai", {legendary = legendary_spawn, target = target_enemy})
skelet.is_wk_skelet = true

if caster:HasModifier("modifier_wraith_king_ti_8_weapon") then
	skelet:GenericParticle("particles/econ/items/wraith_king/wraith_king_ti8/wk_ti8_creep_ambient.vpcf", modifier_kill_skelet)
elseif caster:HasModifier("modifier_wraith_king_ti_8_weapon_crimson") then
	skelet:GenericParticle("particles/econ/items/wraith_king/wraith_king_ti8/wk_ti8_creep_crimson_ambient.vpcf", modifier_kill_skelet)
end

if is_ghost then
	skelet:AddNewModifier(skelet, self, "modifier_wraith_king_skeleton_ghost_slow", {})
end
if not legendary_spawn then 
	skelet:AddNewModifier(caster, self, "modifier_skeleton_king_vampiric_aura_custom_path", {duration = 2})
end 
if reincarnation then
	skelet:AddNewModifier(caster, self, "modifier_skelet_reincarnation", {duration = duration})
end

local target_enemy = nil
if target then 
	target_enemy = target:entindex()
end

skelet:EmitSound("n_creep_Skeleton.Spawn")
skelet:EmitSound("n_creep_TrollWarlord.RaiseDead")
end







modifier_skeleton_king_vampiric_aura_custom = class({})
function modifier_skeleton_king_vampiric_aura_custom:IsHidden() return self:GetStackCount() == 0 end
function modifier_skeleton_king_vampiric_aura_custom:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_custom:OnCreated(params)
self:SetStackCount(0)
self.creeps_killed = 0
self.creeps_killed_to_charge = 2
self.attack_count = 0

self.ability = self:GetAbility()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.parent:AddDeathEvent(self, true)

self.max = self.ability:GetSpecialValueFor("max_skeleton_charges")
self.kill_radius = self.ability:GetSpecialValueFor("kill_radius")
self.respawn_delay = self.ability:GetSpecialValueFor("respawn_delay")

self.legendary_max = self.caster:GetTalentValue("modifier_skeleton_vampiric_legendary", "attacks", true)
self.legendary_duration = self.caster:GetTalentValue("modifier_skeleton_vampiric_legendary", "duration", true)
self.slow_duration = self.caster:GetTalentValue("modifier_skeleton_vampiric_legendary", "slow_duration", true)

self.buff_radius = self.caster:GetTalentValue("modifier_skeleton_vampiric_2", "radius", true)
self.buff_duration = self.caster:GetTalentValue("modifier_skeleton_vampiric_3", "duration", true)

self.shield_duration = self.caster:GetTalentValue("modifier_skeleton_hero_6", "duration", true)

self:UpdateTalent()
end

function modifier_skeleton_king_vampiric_aura_custom:OnRefresh()
self.max = self.ability:GetSpecialValueFor("max_skeleton_charges")
end


function modifier_skeleton_king_vampiric_aura_custom:UpdateTalent(name)

if self.parent:HasTalent("modifier_skeleton_vampiric_legendary") or name == "modifier_skeleton_vampiric_legendary" then
	self.parent:AddAttackEvent_out(self, true)
end

if self.parent:HasTalent("modifier_skeleton_vampiric_3") or name == "modifier_skeleton_vampiric_3" then
	self.parent:AddAttackEvent_out(self, true)
end

end



function modifier_skeleton_king_vampiric_aura_custom:AttackEvent_out(params)
if not IsServer() then return end
if not params.target:IsUnit() then return end 

local attacker = params.attacker

if self.parent:HasTalent("modifier_skeleton_vampiric_3") and self.parent == attacker then
	local units = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.buff_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
	for _,unit in pairs(units) do
		if unit:HasModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai") then
			unit:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_vampiric_aura_custom_skelet_buff", {duration = self.buff_duration})
		end
	end
end


if not self.parent:HasTalent("modifier_skeleton_vampiric_legendary") then return end

if attacker:HasModifier("modifier_wraith_king_skeleton_ghost_slow") then 
	params.target:AddNewModifier(self.parent, self.ability, "modifier_wraith_king_skeleton_ghost_slow_mod", {duration = self.slow_duration})
end 

if attacker == self.parent then
	self.attack_count = self.attack_count + 1
	if self.attack_count >= self.legendary_max then
		self.attack_count = 0
		self.ability:CreateSkeleton(self.parent:GetAbsOrigin(), params.target, self.legendary_duration, false, true)
	end
end

end



function modifier_skeleton_king_vampiric_aura_custom:DeathEvent(params)
if not IsServer() then return end
local attacker = params.attacker
local unit = params.unit

if self.parent:GetTeamNumber() ~= unit:GetTeamNumber() then

	local give_charge = false

	if self.parent == params.attacker then 
		give_charge = true 
	elseif attacker.owner and attacker.owner == self.parent and (self.parent:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D() <= self.kill_radius then 
		give_charge = true
	end

	if give_charge == false then return end
	if self:GetStackCount() >= self.max then return end

	if unit:IsValidKill(self.parent) then
		self:SetStackCount(self.max)
		self.creeps_killed = 0
		return
	end

	self.creeps_killed = self.creeps_killed + 1

	if self.creeps_killed >= self.creeps_killed_to_charge then
		self.creeps_killed = 0
		self:IncrementStackCount()
	end
elseif unit.is_wk_skelet and unit.owner and unit.owner == self.parent then

	if unit:HasModifier("modifier_skelet_reincarnation") then

		local modifier_kill = unit:FindModifierByName("modifier_skelet_reincarnation")
		local duration = modifier_kill:GetRemainingTime()
		local name = unit:GetUnitName()
	 	local point = unit:GetAbsOrigin()
	 	modifier_kill:Destroy()

		Timers:CreateTimer(self.respawn_delay, function()
			if self.parent and not self.parent:IsNull() and players[self.parent:GetId()] then 
				self.ability:CreateSkeleton(point, nil, duration, false, false, name)
			end
		end)

	end

	if self.parent:HasTalent("modifier_skeleton_hero_6") and (unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.buff_radius then 
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_vampiric_aura_custom_shield", {duration = self.shield_duration})
	end
end

end 







modifier_skeleton_king_vampiric_aura_custom_skeleton_ai = class(mod_hidden)
function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not IsServer() then return end

self.death_damage = self.ability:GetSpecialValueFor("death_damage")
self.death_radius = self.ability:GetSpecialValueFor("death_radius")

self.damageTable = {attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

self.base_health = self.ability:GetSpecialValueFor("health")
self.base_armor = self.ability:GetSpecialValueFor("armor")
self.base_damage = self.ability:GetSpecialValueFor("damage")
self.move_speed = self.ability:GetSpecialValueFor("move_speed")

local mod = self.caster:FindModifierByName("modifier_skeleton_king_vampiric_aura_stats")
if mod and self.caster:HasTalent("modifier_skeleton_vampiric_1") then
	self.base_health = self.base_health + (mod:GetStackCount()/mod.max)*mod.health
	self.base_damage = self.base_damage + (mod:GetStackCount()/mod.max)*mod.damage
end

self.parent:SetPhysicalArmorBaseValue(self.base_armor)
self.parent:SetBaseDamageMin(self.base_damage)
self.parent:SetBaseDamageMax(self.base_damage)
self.parent:SetBaseMaxHealth(self.base_health)
self.parent:SetBaseMoveSpeed(self.move_speed)
self.parent:SetHealth(self.parent:GetMaxHealth())

self.vec = RandomVector(200)
self.radius = 1200
self.target = nil

if table.target ~= nil then 
	self:SetTarget(EntIndexToHScript(table.target))
end

self:OnIntervalThink()
self:StartIntervalThink(0.3)
end


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:IsValidTarget(target)
if not IsServer() then return end 

if not target or target:IsNull() or not target:IsAlive() or not target:IsUnit() or target:IsCourier() or 
 ((target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.radius) or target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
	return false 
end

return true
end 


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:SetTarget(target)
if not IsServer() then return end
if not self:IsValidTarget(target) then return end
if self.target == target then return end


self.target = target
self.parent:MoveToPositionAggressive(self.target:GetAbsOrigin())
self.parent:SetForceAttackTarget(self.target)

end 


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:CheckState()
if self.ability:GetAutoCastState() == false then return end
return
{
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:MoveToCaster()
if not IsServer() then return end

self.target = nil
self.parent:SetForceAttackTarget(nil)

local point = self.caster:GetAbsOrigin() + self.vec

if (point - self.parent:GetAbsOrigin()):Length2D() > 50 then 
	self.parent:MoveToPosition(self.caster:GetAbsOrigin() + self.vec)
end

end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnDestroy()
if not IsServer() then return end

local damage = self.death_damage
self.damageTable.damage = damage

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self.parent:EmitSound("WK.skelet_expolsion")

for _,enemy in pairs(self.parent:FindTargets(self.death_radius, self.parent:GetAbsOrigin())) do 
	self.damageTable.victim = enemy
    DoDamage( self.damageTable )
end

end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsAlive() then 
	self:StartIntervalThink(-1)
	return 
end

if self.ability:GetAutoCastState() == true then 
	self:MoveToCaster()
	return
end

if self.parent:GetAggroTarget() then
    self.target = self.parent:GetAggroTarget()
end

local heroes = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
local creeps = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

if self:IsValidTarget(self.target) and self.target:IsHero() then 
    self:SetTarget(self.target)
    return
end 

if (not self:IsValidTarget(self.target) or not self.target:IsHero()) and #heroes > 0  then
	for _,hero in pairs(heroes) do
		if self:IsValidTarget(hero) then 
			self:SetTarget(hero)
        	break
		end
	end 
end

if not self:IsValidTarget(self.target) and #creeps > 0 then 
	for _,creep in pairs(creeps) do
		if self:IsValidTarget(creep) then 
			self:SetTarget(creep)
        	break
		end
	end
end 

if not self:IsValidTarget(self.target) then 
	self:MoveToCaster()
end

end






modifier_skelet_reincarnation = class(mod_hidden)
function modifier_skelet_reincarnation:RemoveOnDeath() return false end




modifier_skeleton_king_vampiric_aura_stats = class({})
function modifier_skeleton_king_vampiric_aura_stats:IsHidden() return not self:GetParent():HasTalent("modifier_skeleton_vampiric_1") or self:GetStackCount() >= self.max end
function modifier_skeleton_king_vampiric_aura_stats:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_stats:RemoveOnDeath() return false end
function modifier_skeleton_king_vampiric_aura_stats:GetTexture() return "buffs/skelet_buff" end

function modifier_skeleton_king_vampiric_aura_stats:OnCreated(table)

self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_skeleton_vampiric_1", "max", true)

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(1)

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_skeleton_king_vampiric_aura_stats:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_skeleton_king_vampiric_aura_stats:UpdateTalent()
self.damage = self.parent:GetTalentValue("modifier_skeleton_vampiric_1", "damage")
self.health = self.parent:GetTalentValue("modifier_skeleton_vampiric_1", "health")
self:SendBuffRefreshToClients()
end


function modifier_skeleton_king_vampiric_aura_stats:AddCustomTransmitterData() 
return 
{
	health = self.health,
	damage = self.damage
} 
end

function modifier_skeleton_king_vampiric_aura_stats:HandleCustomTransmitterData(data)
self.health = data.health
self.damage = data.damage
end

function modifier_skeleton_king_vampiric_aura_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_skeleton_king_vampiric_aura_stats:OnTooltip()
return (self:GetStackCount()/self.max)*self.damage
end
function modifier_skeleton_king_vampiric_aura_stats:OnTooltip2()
return (self:GetStackCount()/self.max)*self.health
end
 

function modifier_skeleton_king_vampiric_aura_stats:OnIntervalThink()
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_skeleton_vampiric_1") or self:GetStackCount() < self.max then return end
self.parent:GenericParticle("particles/lc_odd_proc_.vpcf")
self.parent:EmitSound("BS.Thirst_legendary_active")
self:StartIntervalThink(-1)
end 




modifier_wraith_king_skeleton_ghost_slow = class(mod_hidden)
function modifier_wraith_king_skeleton_ghost_slow:RemoveOnDeath() return false end
function modifier_wraith_king_skeleton_ghost_slow:CheckState()
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end



modifier_wraith_king_skeleton_ghost_slow_mod = class({})
function modifier_wraith_king_skeleton_ghost_slow_mod:IsHidden() return true end
function modifier_wraith_king_skeleton_ghost_slow_mod:IsPurgable() return true end
function modifier_wraith_king_skeleton_ghost_slow_mod:GetStatusEffectName() return "particles/status_fx/status_effect_drow_frost_arrow.vpcf" end
function modifier_wraith_king_skeleton_ghost_slow_mod:OnCreated(table)
self.slow = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "slow")
end

function modifier_wraith_king_skeleton_ghost_slow_mod:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end
function modifier_wraith_king_skeleton_ghost_slow_mod:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


modifier_skeleton_king_vampiric_aura_custom_path = class({})
function modifier_skeleton_king_vampiric_aura_custom_path:IsHidden() return true end
function modifier_skeleton_king_vampiric_aura_custom_path:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_custom_path:CheckState()
return
{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
}
end



modifier_skeleton_king_vampiric_aura_custom_shield = class({})
function modifier_skeleton_king_vampiric_aura_custom_shield:IsHidden() return false end
function modifier_skeleton_king_vampiric_aura_custom_shield:GetTexture() return "buffs/reincarnation_shield" end
function modifier_skeleton_king_vampiric_aura_custom_shield:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_custom_shield:OnCreated(table)

self.parent = self:GetParent()

self.shield_talent = "modifier_skeleton_hero_6"
self.shield = self.parent:GetTalentValue("modifier_skeleton_hero_6", "shield")/100
self.max = self.parent:GetTalentValue("modifier_skeleton_hero_6", "max")

self.add_shield =  self.shield*self.parent:GetMaxHealth()
self.max_shield = self.add_shield*self.max

if not IsServer() then return end

local shield_size = self.parent:GetModelRadius() * 0.8
local common_vector = Vector(shield_size,0,shield_size)

self.parent:EmitSound("WK.Skelet_shield")
self.RemoveForDuel = true

local particle = ParticleManager:CreateParticle("particles/wk_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle, 1, common_vector)
ParticleManager:SetParticleControl(particle, 2, common_vector)
ParticleManager:SetParticleControl(particle, 4, common_vector)
ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)

self:AddShield()
end

function modifier_skeleton_king_vampiric_aura_custom_shield:OnRefresh()
self:AddShield()
end 

function modifier_skeleton_king_vampiric_aura_custom_shield:AddShield()
if not IsServer() then return end
self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + self.add_shield))
end 

function modifier_skeleton_king_vampiric_aura_custom_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_skeleton_king_vampiric_aura_custom_shield:GetModifierIncomingDamageConstant( params )
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







modifier_skeleton_king_vampiric_aura_custom_buff = class(mod_visible)
function modifier_skeleton_king_vampiric_aura_custom_buff:RemoveOnDeath() return false end
function modifier_skeleton_king_vampiric_aura_custom_buff:GetTexture() return "buffs/darklord_health" end
function modifier_skeleton_king_vampiric_aura_custom_buff:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.parent:GetTalentValue("modifier_skeleton_vampiric_2", "radius", true)
self.max = self.parent:GetTalentValue("modifier_skeleton_vampiric_2", "max", true)

self.speed = self.parent:GetTalentValue("modifier_skeleton_vampiric_3", "speed")
self.move = self.parent:GetTalentValue("modifier_skeleton_vampiric_2", "move")
self.status = self.parent:GetTalentValue("modifier_skeleton_vampiric_2", "status")

self:StartIntervalThink(0.5)
end

function modifier_skeleton_king_vampiric_aura_custom_buff:OnRefresh()
self.speed = self.parent:GetTalentValue("modifier_skeleton_vampiric_3", "speed")
self.move = self.parent:GetTalentValue("modifier_skeleton_vampiric_2", "move")
self.status = self.parent:GetTalentValue("modifier_skeleton_vampiric_2", "status")
end


function modifier_skeleton_king_vampiric_aura_custom_buff:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsAlive() then return end

local stack = 0
local units = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
for _,unit in pairs(units) do
	if unit:HasModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai") then
		stack = stack + 1
		if stack >= self.max then
			break
		end
	end
end

if stack == self:GetStackCount() then return end

if self.parent:HasTalent("modifier_skeleton_vampiric_3") then
	if stack >= self.max and not self.effect_impact then
		self.effect_impact = self.parent:GenericParticle("particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_hands_glow.vpcf", self)
		self.parent:EmitSound("WK.Skelet_buff")
	end

	if stack < self.max and self.effect_impact  then
		ParticleManager:Delete(self.effect_impact, 1)
		self.effect_impact = nil
	end 
end

self:SetStackCount(stack)
end


function modifier_skeleton_king_vampiric_aura_custom_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_skeleton_king_vampiric_aura_custom_buff:GetModifierModelScale()
if self.speed == 0 then return end
if self:GetStackCount() < self.max then return end
return 15
end

function modifier_skeleton_king_vampiric_aura_custom_buff:GetModifierStatusResistanceStacking() 
return self:GetStackCount()*self.status
end

function modifier_skeleton_king_vampiric_aura_custom_buff:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self.move
end

function modifier_skeleton_king_vampiric_aura_custom_buff:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self.speed
end



modifier_skeleton_king_vampiric_aura_custom_skelet_buff = class(mod_hidden)
function modifier_skeleton_king_vampiric_aura_custom_skelet_buff:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_skeleton_vampiric_3", "skelet_max", true)
self.speed = self.caster:GetTalentValue("modifier_skeleton_vampiric_3", "skelet_speed")

self:SetStackCount(1)
end

function modifier_skeleton_king_vampiric_aura_custom_skelet_buff:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() < self.max then return end

self.effect_impact = ParticleManager:CreateParticle( "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_hands_glow.vpcf", PATTACH_CUSTOMORIGIN, self.parent )
ParticleManager:SetParticleControlEnt(self.effect_impact, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", self.parent:GetAbsOrigin(), true)
self:AddParticle(self.effect_impact, false, false, -1, false, false)
self.parent:EmitSound("WK.Skelet_buff")
end


function modifier_skeleton_king_vampiric_aura_custom_skelet_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_skeleton_king_vampiric_aura_custom_skelet_buff:GetModifierModelScale()
if self:GetStackCount() < self.max then return end
return 15
end

function modifier_skeleton_king_vampiric_aura_custom_skelet_buff:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self.speed
end



modifier_skeleton_king_vampiric_aura_custom_totem = class(mod_hidden)
function modifier_skeleton_king_vampiric_aura_custom_totem:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.radius = self.caster:GetTalentValue("modifier_skeleton_vampiric_4", "radius")

if not IsServer() then return end

self.base_armor = self.ability:GetSpecialValueFor("armor")
self.move_speed = self.ability:GetSpecialValueFor("move_speed")
self.health = self.caster:GetMaxHealth()*self.caster:GetTalentValue("modifier_skeleton_vampiric_4", "health")/100

self.parent:SetBaseMaxHealth(self.health)
self.parent:SetHealth(self.health)
self.parent:SetPhysicalArmorBaseValue(self.base_armor)
self.parent:SetBaseMoveSpeed(self.move_speed)

local particle = ParticleManager:CreateParticle("particles/items5_fx/wraith_pact_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, 1 ,1))
self:AddParticle(particle, false, false, -1, false, false)

self.dispel = self.caster:GetTalentValue("modifier_skeleton_vampiric_4", "dispel")

self.interval = 0.25
self.count = self.dispel

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_skeleton_king_vampiric_aura_custom_totem:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end


function modifier_skeleton_king_vampiric_aura_custom_totem:OnIntervalThink()
if not IsServer() then return end
if not self.parent:IsAlive() then return end

local point = self.caster:GetAbsOrigin() - self.caster:GetForwardVector()*150

if (point - self.parent:GetAbsOrigin()):Length2D() > 50 then 
	self.parent:MoveToPosition(point)
end


self.count = self.count + self.interval
if self.count < self.dispel - FrameTime() then return end

self.parent:EmitSound("WK.Totem_purge")
self.parent:EmitSound("WK.Totem_spawn")
self.count = 0

local effect_cast = ParticleManager:CreateParticle( "particles/centaur/return_legendary_pulses.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, point, true )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius,self.radius,self.radius))
ParticleManager:SetParticleControlEnt( effect_cast, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_skull", point, true )
ParticleManager:ReleaseParticleIndex( effect_cast )

local units = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false )
for _,unit in pairs(units) do
	unit:Purge(false, true, false, true, false)
	if unit:IsRealHero() then
		local effect_dispel = ParticleManager:CreateParticle( "particles/wraith_king/totem_dispell.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
		ParticleManager:SetParticleControl( effect_dispel, 0, unit:GetAbsOrigin())
		ParticleManager:SetParticleControl( effect_dispel, 1, Vector(200, 200, 200))
		ParticleManager:ReleaseParticleIndex( effect_dispel )
	end

end

end

function modifier_skeleton_king_vampiric_aura_custom_totem:GetAuraRadius() return self.radius end
function modifier_skeleton_king_vampiric_aura_custom_totem:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_skeleton_king_vampiric_aura_custom_totem:GetAuraSearchType()  return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_skeleton_king_vampiric_aura_custom_totem:GetModifierAura() return "modifier_skeleton_king_vampiric_aura_custom_totem_aura" end
function modifier_skeleton_king_vampiric_aura_custom_totem:IsAura() return true end



modifier_skeleton_king_vampiric_aura_custom_totem_aura = class(mod_hidden)
function modifier_skeleton_king_vampiric_aura_custom_totem_aura:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.damage_reduce = self.caster:GetTalentValue("modifier_skeleton_vampiric_4", "damage_reduce")
end

function modifier_skeleton_king_vampiric_aura_custom_totem_aura:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end

function modifier_skeleton_king_vampiric_aura_custom_totem_aura:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end

