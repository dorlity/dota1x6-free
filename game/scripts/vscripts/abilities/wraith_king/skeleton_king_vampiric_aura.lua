LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skelet_reincarnation", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_damage", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_stats", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_wraith_king_skeleton_ghost_slow_mod", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_wraith_king_skeleton_ghost_slow", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_path", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_armor", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_buff", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_vampiric_aura_custom_shield", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )



skeleton_king_vampiric_aura_custom = class({})

skeleton_king_vampiric_aura_custom.delay_reincarnation = 3





wraith_king_skeleton_ghost_slow = class({})



skeleton_king_vampiric_aura_custom.skelet_count = 0



function skeleton_king_vampiric_aura_custom:Precache(context)

    
PrecacheResource( "particle", "particles/neutral_fx/skeleton_spawn.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_drow_frost_arrow.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_buff_hands_glow.vpcf", context )

end

function skeleton_king_vampiric_aura_custom:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_wraith_king_custom_frostivus_weapon") then
        return "skeleton_king_vampiric_aura_frostivus"
    end
    if self:GetCaster():HasModifier("modifier_wraith_king_custom_frostivus_weapon") then
        return "skeleton_king_vampiric_aura_frostivus"
    end
    if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") then
        return "skeleton_king/arcana/skeleton_king_vampiric_aura_arcana"
    end
    if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
        return "skeleton_king/arcana/skeleton_king_vampiric_aura_arcana_alt"
    end
    return "skeleton_king_vampiric_aura"
end





function wraith_king_skeleton_ghost_slow:GetIntrinsicModifierName()
return "modifier_wraith_king_skeleton_ghost_slow"
end



function skeleton_king_vampiric_aura_custom:GetIntrinsicModifierName()
	return "modifier_skeleton_king_vampiric_aura_custom"
end

function skeleton_king_vampiric_aura_custom:OnAbilityPhaseStart()
    local mod = self:GetCaster():FindModifierByName("modifier_skeleton_king_vampiric_aura_custom")
    if mod then
        if mod:GetStackCount() <= 0 then
            local player = PlayerResource:GetPlayer( self:GetCaster():GetPlayerOwnerID() )
            CustomGameEventManager:Send_ServerToPlayer(player, "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
            return false
        end
    end
    return true
end

function skeleton_king_vampiric_aura_custom:OnSpellStart()

local modifier = self:GetCaster():FindModifierByName("modifier_skeleton_king_vampiric_aura_custom")
if modifier == nil then return end
local charges = modifier:GetStackCount()
local delay = self:GetSpecialValueFor("spawn_interval")


self:GetCaster():EmitSound("Hero_SkeletonKing.MortalStrike.Cast")

if self:GetCaster():GetQuest() == "Wraith.Quest_6" and not self:GetCaster():QuestCompleted() then 
	self:GetCaster():UpdateQuest(charges)
end



local mod = self:GetCaster():FindModifierByName("modifier_skeleton_king_vampiric_aura_stats")
if not mod then 
	mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_stats", {})
end

if mod then 
	mod:SetStackCount(mod:GetStackCount() + charges)
end


for i=0,charges - 1 do
	Timers:CreateTimer(delay * i, function ()
		self:CreateSkeleton(self:GetCaster():GetOrigin()+RandomVector(300), nil, nil, true)
	end)
end

if test then return end

modifier:SetStackCount( 0 )

end






function skeleton_king_vampiric_aura_custom:CreateSkeleton(origin, target, duration_custom, reincarnation, legendary_spawn, new_name)
if not IsServer() then return end
if self:GetCaster() == nil or players[self:GetCaster():GetTeamNumber()] == nil then return end



local name =  "npc_dota_wraith_king_skeleton_warrior_custom"


if self:GetCaster():HasModifier("modifier_skeleton_vampiric_legendary") and not new_name then 
	self.skelet_count = self.skelet_count + 1

	if self.skelet_count >= self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "count") then 
		self.skelet_count = 0
		name = "npc_dota_wraith_king_skeleton_ghost_custom"

		if legendary_spawn then 
			local vec = self:GetCaster():GetAbsOrigin() - origin

			origin = origin + vec:Normalized()*300
		end
	else 
		if legendary_spawn then 
			origin = origin + RandomVector(150)
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
if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") or self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
    spawn_particle = "particles/wk_arc_minion_ambient.vpcf"
end

local skelet = CreateUnitByName( name, origin, true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber() )
ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( spawn_particle, PATTACH_ABSORIGIN, skelet ) )
skelet:SetOwner( self:GetCaster() )

if name == "npc_dota_wraith_king_skeleton_warrior_custom" then
    if self:GetCaster():HasModifier("modifier_wraith_king_custom_frostivus_weapon") then
        skelet:SetModel("models/items/wraith_king/frostivus_wraith_king/frostivus_wraith_king_skeleton.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/frostivus_wraith_king/frostivus_wraith_king_skeleton.vmdl")
    elseif self:GetCaster():HasModifier("modifier_wraith_king_ti_8_weapon") then
        skelet:SetModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep.vmdl")
    elseif self:GetCaster():HasModifier("modifier_wraith_king_ti_8_weapon_crimson") then
        skelet:SetModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_crimson.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/wk_ti8_creep/wk_ti8_creep_crimson.vmdl")
    elseif self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") then
        skelet:SetModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
    elseif self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
        skelet:SetModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
        skelet:SetOriginalModel("models/items/wraith_king/arcana/wk_arcana_skeleton.vmdl")
    end
end

if self:GetCaster():HasModifier("modifier_skeleton_vampiric_legendary") then 
	--skelet:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)
end

local modifier_kill_skelet = skelet:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = duration})
if self:GetCaster():HasModifier("modifier_wraith_king_ti_8_weapon") then
    local skelet_particle = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_ti8/wk_ti8_creep_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, skelet)
    modifier_kill_skelet:AddParticle(skelet_particle, false, false, -1, false, false)
elseif self:GetCaster():HasModifier("modifier_wraith_king_ti_8_weapon_crimson") then
    local skelet_particle = ParticleManager:CreateParticle("particles/econ/items/wraith_king/wraith_king_ti8/wk_ti8_creep_crimson_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, skelet)
    modifier_kill_skelet:AddParticle(skelet_particle, false, false, -1, false, false)
end


local target_enemy = nil
if target then 
	target_enemy = target:entindex()
end

local modifier = skelet:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_custom_skeleton_ai", {legendary = legendary_spawn, target = target_enemy})

if reincarnation then
	skelet:AddNewModifier(self:GetCaster(), self, "modifier_skelet_reincarnation", {})
end
skelet.owner = self:GetCaster()
skelet.skelet = true

if not legendary_spawn then 
	skelet:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_custom_path", {duration = self:GetSpecialValueFor("damage_duration")})
end 

--skelet:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_vampiric_aura_custom", {})
skelet:EmitSound("n_creep_Skeleton.Spawn")
skelet:EmitSound("n_creep_TrollWarlord.RaiseDead")
if not target then return end
if not modifier then return end
modifier.target = target


end



modifier_skeleton_king_vampiric_aura_custom = class({})

function modifier_skeleton_king_vampiric_aura_custom:IsHidden() return self:GetStackCount() == 0 end
function modifier_skeleton_king_vampiric_aura_custom:IsPurgable() return false end

function modifier_skeleton_king_vampiric_aura_custom:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end


function modifier_skeleton_king_vampiric_aura_custom:OnAttackLanded(params)
if not IsServer() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end 

local attacker = params.attacker

if attacker:HasModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai") and self:GetCaster():HasModifier("modifier_skeleton_vampiric_2") then 
	params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_skeleton_king_vampiric_aura_armor", {duration = self.armor_duration})
end 


if attacker:HasModifier("modifier_wraith_king_skeleton_ghost_slow") then 
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_wraith_king_skeleton_ghost_slow_mod", {duration = self.slow_duration})
end 

end





function modifier_skeleton_king_vampiric_aura_custom:OnCreated(params)
self:SetStackCount(0)
self.creeps_killed = 0
self.creeps_killed_to_charge = 2


self.armor_duration = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_2", "duration", true)
self.slow_duration = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "slow_duration", true)

self.radius = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_3", "radius", true)
end

function modifier_skeleton_king_vampiric_aura_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() == params.unit then return end
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local attacker = params.attacker

local is_skelet = false

if attacker.owner and attacker.owner == self:GetCaster() then 
	is_skelet = true
end

if is_skelet == false and attacker ~= self:GetCaster() then return end


local base_heal = self:GetAbility():GetSpecialValueFor("vampiric_aura") / 100
local more_heal = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_1", "heal")/100

if params.unit:IsCreep() then 
	base_heal = base_heal*(1 - self:GetAbility():GetSpecialValueFor("creeps_heal")/100)
	more_heal = more_heal*(1 - self:GetAbility():GetSpecialValueFor("creeps_heal")/100)
end


if is_skelet == true then 
	self:DoHeal(attacker, base_heal*params.damage)

	if self:GetParent():HasModifier("modifier_skeleton_vampiric_1") then 
		self:DoHeal(self:GetParent(), params.damage*more_heal)
	end 

else 
	
	local heal = 0 

	if params.inflictor == nil then 
		heal = (base_heal + more_heal)*params.damage 
	else 
		heal = (more_heal)*params.damage 
	end 
	self:DoHeal(attacker, heal)

end 

self:DoHeal(self:GetParent(), heal)

end 



function modifier_skeleton_king_vampiric_aura_custom:DoHeal(unit, heal)
if not IsServer() then return end
if not heal then return end
if heal < 1 then return end


unit:GenericHeal(heal, self:GetAbility(), true, "")


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
ParticleManager:SetParticleControlEnt(effect_cast, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex( effect_cast )

end 


function modifier_skeleton_king_vampiric_aura_custom:OnDeath(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if self:GetParent():GetTeamNumber() == params.unit:GetTeamNumber() then return end

local give_charge = false
local radius = self:GetAbility():GetSpecialValueFor("kill_radius")

if self:GetParent() == params.attacker then 
	give_charge = true 
end

if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() 
	and params.attacker.owner == self:GetParent() and (self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()):Length2D() <= radius then 
	give_charge = true
end


if give_charge == false then return end


	local max = self:GetAbility():GetSpecialValueFor("max_skeleton_charges")



	if self:GetStackCount() >= max then return end

	self.creeps_killed = self.creeps_killed + 1
	if self.creeps_killed >= self.creeps_killed_to_charge then
		self.creeps_killed = 0
		self:IncrementStackCount()
	end
end 





function modifier_skeleton_king_vampiric_aura_custom:GetAuraEntityReject(target)
if target ~= self:GetParent() and not target.skelet then return true end

return false
end

function modifier_skeleton_king_vampiric_aura_custom:GetAuraDuration()
	return 0
end


function modifier_skeleton_king_vampiric_aura_custom:GetAuraRadius()
return self.radius
end

function modifier_skeleton_king_vampiric_aura_custom:GetAuraSearchFlags()
	return 0
end

function modifier_skeleton_king_vampiric_aura_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_skeleton_king_vampiric_aura_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


function modifier_skeleton_king_vampiric_aura_custom:GetModifierAura()
	return "modifier_skeleton_king_vampiric_aura_custom_buff"
end

function modifier_skeleton_king_vampiric_aura_custom:IsAura()
return self:GetParent():IsRealHero() and (self:GetParent():HasModifier("modifier_skeleton_vampiric_3") or self:GetParent():HasModifier("modifier_skeleton_vampiric_6"))
end




modifier_skeleton_king_vampiric_aura_custom_skeleton_ai = class({})

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:IsHidden() return true end
function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:IsPurgable() return false end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnCreated(table)

self.armor = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_2", "self_armor")

self.speed = 0

self.blast_damage = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_5", "damage")
self.blast_radius = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_5", "radius")
self.blast_damage_duration = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_5", "duration")

self.shield_duration = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_6", "duration")
self.shield_radius = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_3", "radius", true)


if self:GetCaster():HasModifier("modifier_skeleton_vampiric_4") and self:GetCaster():GetUpgradeStack("modifier_skeleton_king_vampiric_aura_stats") >= self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_4", "stack") then 
	self.speed = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_4", "speed")
end 


if not IsServer() then return end

self.vec = RandomVector(200)
self.radius = 1200

if self:GetCaster():HasModifier("modifier_skeleton_vampiric_4") and self:GetCaster():HasModifier("modifier_skeleton_king_vampiric_aura_stats") then 
	local mod =  self:GetCaster():FindModifierByName("modifier_skeleton_king_vampiric_aura_stats")

	local k = 1
	if table.legendary and table.legendary == 1 then 
		k = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "stats")/100
	end 

	local health = self:GetParent():GetMaxHealth() + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_4", "health")
	local damage = self:GetParent():GetBaseDamageMax() + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_4", "damage")
	self:GetParent():SetBaseMaxHealth(health*k)
	self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
	self:GetParent():SetBaseDamageMin(damage*k)
	self:GetParent():SetBaseDamageMax(damage*k)


else 

	if table.legendary and table.legendary == 1 then 

		local health = self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "stats")/100
		local damage = self:GetParent():GetBaseDamageMax()*self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "stats")/100

		self:GetParent():SetBaseMaxHealth(health)
		self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
		self:GetParent():SetBaseDamageMin(damage)
		self:GetParent():SetBaseDamageMax(damage)
	end 
end

self.target = nil


if table.target ~= nil then 
	self:SetTarget(EntIndexToHScript(table.target))
end


self:OnIntervalThink()
self:StartIntervalThink(0.3)
end

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end




function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:GetModifierPhysicalArmorBonus()
return self.armor
end


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnDeath(params)
if not IsServer() then return end
if not params.attacker then return end 
if params.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if params.unit ~= self:GetParent() then return end 

if self:GetCaster():HasModifier("modifier_skeleton_vampiric_6") and (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.shield_radius then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_skeleton_king_vampiric_aura_custom_shield", {duration = self.shield_duration})
end


if not self:GetCaster():HasModifier("modifier_skeleton_vampiric_5") then return end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound("WK.skelet_expolsion")

local damage = self.blast_damage

local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.blast_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
for _,enemy in pairs(enemies) do 

	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_skeleton_king_vampiric_aura_damage", {duration = self.blast_damage_duration})
    
    local damage = {
        victim = enemy,
        attacker = self:GetCaster(),
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE,
        ability = self:GetAbility()
    }
    ApplyDamage( damage )
end

end



function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:IsValidTarget(target)
if not IsServer() then return end 


if not target or target:IsNull() or not target:IsAlive() or 
 ((target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.radius) or (not target:IsHero() and not target:IsCreep())
or target:IsCourier() or target:GetUnitName() == "npc_teleport" or target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 


	return false 
end


return true
end 

function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:SetTarget(target)
if not IsServer() then return end
if not self:IsValidTarget(target) then return end
if self.target == target then return end


self.target = target
self:GetParent():MoveToPositionAggressive(self.target:GetAbsOrigin())
self:GetParent():SetForceAttackTarget(self.target)

end 


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = self:GetAbility():GetAutoCastState(),
	[MODIFIER_STATE_NO_UNIT_COLLISION] = self:GetAbility():GetAutoCastState()
}
end


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:MoveToCaster()
if not IsServer() then return end

self.target = nil
self:GetParent():SetForceAttackTarget(nil)

local point = self:GetCaster():GetAbsOrigin() + self.vec

if (point - self:GetParent():GetAbsOrigin()):Length2D() > 50 then 
	self:GetParent():MoveToPosition(self:GetCaster():GetAbsOrigin() + self.vec)
end

end


function modifier_skeleton_king_vampiric_aura_custom_skeleton_ai:OnIntervalThink()
if not IsServer() then return end

if self:GetAbility():GetAutoCastState() == true then 
	self:MoveToCaster()
	return
end

if self:GetParent():GetAggroTarget() then
    self.target = self:GetParent():GetAggroTarget()
end

if self:IsValidTarget(self.target) then
    self:SetTarget(self.target)
    return
else 

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )

	for _,enemy in pairs(enemies) do
		if self:IsValidTarget(enemy) then 
			self:SetTarget(enemy)
        	break
		end
	end
end 

if not self:IsValidTarget(self.target) then 
	self:MoveToCaster()
end


end















modifier_skelet_reincarnation = class({})

function modifier_skelet_reincarnation:IsHidden()
    return true
end

function modifier_skelet_reincarnation:RemoveOnDeath()
    return true
end

function modifier_skelet_reincarnation:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH,
    }

    return funcs
end

function modifier_skelet_reincarnation:OnDeath( params )
    if not IsServer() then return end
    if params.attacker == nil then return end
    if params.unit ~= self:GetParent() then return end
    if params.attacker == self:GetParent() then return end
 	local point = self:GetParent():GetAbsOrigin()
  	local team = self:GetParent():GetTeamNumber()
  	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local duration = 0
	local modifier_kill = self:GetParent():FindModifierByName("modifier_kill")
	local delay_reincarnation = ability.delay_reincarnation

	if modifier_kill then
		duration = modifier_kill:GetRemainingTime()
	end
	local name = self:GetParent():GetUnitName()
	Timers:CreateTimer(ability.delay_reincarnation, function()
		if caster ~= nil and not caster:IsNull() and players[caster:GetTeamNumber()] ~= nil then 
			ability:CreateSkeleton(point, nil, duration, false, false, name)
		end
	end)
end



modifier_skeleton_king_vampiric_aura_stats = class({})
function modifier_skeleton_king_vampiric_aura_stats:IsHidden() return not self:GetParent():HasModifier("modifier_skeleton_vampiric_4") end
function modifier_skeleton_king_vampiric_aura_stats:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_stats:RemoveOnDeath() return false end

function modifier_skeleton_king_vampiric_aura_stats:GetTexture() return "buffs/skelet_buff" end
function modifier_skeleton_king_vampiric_aura_stats:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_4", "stack", true)

if not IsServer() then return end
self:SetStackCount(0)

self:StartIntervalThink(1)
end

function modifier_skeleton_king_vampiric_aura_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_skeleton_king_vampiric_aura_stats:OnTooltip()
return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_4", "damage")
end
function modifier_skeleton_king_vampiric_aura_stats:OnTooltip2()
return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_4", "health")
end
 


function modifier_skeleton_king_vampiric_aura_stats:OnIntervalThink()
if not IsServer() then return end 
if self:GetCaster():HasModifier("modifier_skeleton_vampiric_4") and self:GetStackCount() >= self.max then 

    local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_peffect)
    self:GetCaster():EmitSound("BS.Thirst_legendary_active")

	self:StartIntervalThink(-1)
end 

end 









modifier_wraith_king_skeleton_ghost_slow = class({})
function modifier_wraith_king_skeleton_ghost_slow:IsHidden() return true end
function modifier_wraith_king_skeleton_ghost_slow:IsPurgable() return false end


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

function modifier_skeleton_king_vampiric_aura_custom_path:GetEffectName()
	return "particles/generic_gameplay/rune_shield_owner_glow.vpcf"
end


function modifier_skeleton_king_vampiric_aura_custom_path:GetStatusEffectName()
	return "particles/status_fx/status_effect_shield_rune.vpcf"
end

function modifier_skeleton_king_vampiric_aura_custom_path:StatusEffectPriority()
	return 9999999
end

function modifier_skeleton_king_vampiric_aura_custom_path:OnCreated()

self.damage = self:GetAbility():GetSpecialValueFor("damage_reduce")
end

function modifier_skeleton_king_vampiric_aura_custom_path:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end
function modifier_skeleton_king_vampiric_aura_custom_path:GetModifierIncomingDamage_Percentage()
return self.damage
end


modifier_skeleton_king_vampiric_aura_armor = class({})
function modifier_skeleton_king_vampiric_aura_armor:IsHidden() return false end
function modifier_skeleton_king_vampiric_aura_armor:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_armor:GetTexture() return "buffs/vampiric_armor" end
function modifier_skeleton_king_vampiric_aura_armor:OnCreated()
self.armor = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_2", "armor")
self.max = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_2", "max")

if not IsServer() then return end 

self:SetStackCount(1)
end

function modifier_skeleton_king_vampiric_aura_armor:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end


self:IncrementStackCount()
end 


function modifier_skeleton_king_vampiric_aura_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_skeleton_king_vampiric_aura_armor:GetModifierPhysicalArmorBonus()
return self.armor*self:GetStackCount()
end


modifier_skeleton_king_vampiric_aura_damage = class({})
function modifier_skeleton_king_vampiric_aura_damage:IsHidden() return false end
function modifier_skeleton_king_vampiric_aura_damage:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_damage:GetTexture() return "buffs/vampiric_slow" end

function modifier_skeleton_king_vampiric_aura_damage:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_5", "damage_inc")
self.max = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_5", "max")

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_skeleton_king_vampiric_aura_damage:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end 

function modifier_skeleton_king_vampiric_aura_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_skeleton_king_vampiric_aura_damage:GetModifierIncomingDamage_Percentage()
return self:GetStackCount()*self.damage
end



function modifier_skeleton_king_vampiric_aura_damage:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if self:GetStackCount() == 1 then 
    self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
end

ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetStackCount(), 0 , 0))
ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
self:AddParticle(self.pfx, false, false, -1, false, false)

end




modifier_skeleton_king_vampiric_aura_custom_buff = class({})
function modifier_skeleton_king_vampiric_aura_custom_buff:IsHidden() return false end
function modifier_skeleton_king_vampiric_aura_custom_buff:IsPurgable() return false end
function modifier_skeleton_king_vampiric_aura_custom_buff:GetTexture() return "buffs/darklord_health" end
function modifier_skeleton_king_vampiric_aura_custom_buff:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_6", "damage", true)


if not IsServer() then return end 
self.caster = self:GetCaster()
self.parent = self:GetParent()



self.max = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_3", "max", true)
self.radius = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_3", "radius", true)

self:StartIntervalThink(0.2)
end 

function modifier_skeleton_king_vampiric_aura_custom_buff:OnIntervalThink()
if not IsServer() then return end 


if self.parent.skelet and self.caster ~= self.parent then 

	local mod = self.caster:FindModifierByName(self:GetName())

	if mod then 
		self:SetStackCount(mod:GetStackCount())
	end 
else

	local all_skeletons = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false )
    	
    local count = 0
    for _,unit in pairs(all_skeletons) do 
    	if unit.skelet and unit:HasModifier(self:GetName()) then 
    		count = count + 1
    	end 
    end 

    self:SetStackCount(math.min(self.max, count))
end


end 


function modifier_skeleton_king_vampiric_aura_custom_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end

function modifier_skeleton_king_vampiric_aura_custom_buff:GetModifierStatusResistanceStacking() 
    return self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_3", "status")*self:GetStackCount()
end

function modifier_skeleton_king_vampiric_aura_custom_buff:GetModifierMoveSpeedBonus_Percentage()
    return self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_3", "move")*self:GetStackCount()
end

function modifier_skeleton_king_vampiric_aura_custom_buff:GetModifierIncomingDamage_Percentage()
if self:GetParent() ~= self:GetCaster() then return end
if not self:GetParent():HasModifier("modifier_skeleton_vampiric_6") then return end 

    return self.damage*self:GetStackCount()
end











modifier_skeleton_king_vampiric_aura_custom_shield = class({})
function modifier_skeleton_king_vampiric_aura_custom_shield:IsHidden() 
    return false
end
function modifier_skeleton_king_vampiric_aura_custom_shield:GetTexture() return "buffs/reincarnation_shield" end
function modifier_skeleton_king_vampiric_aura_custom_shield:IsPurgable() return false end

function modifier_skeleton_king_vampiric_aura_custom_shield:OnCreated(table)

self.shield = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_6", "shield")/100
self.max = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_6", "max")

self.add_shield =  self.shield*self:GetParent():GetMaxHealth()
self.max_shield = self.add_shield*self.max

if not IsServer() then return end

local shield_size = self:GetParent():GetModelRadius() * 0.9

self:GetParent():EmitSound("MK.Mastery_Shield")

self.RemoveForDuel = true

local particle = ParticleManager:CreateParticle("particles/wk_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
local common_vector = Vector(shield_size,0,shield_size)
ParticleManager:SetParticleControl(particle, 1, common_vector)
ParticleManager:SetParticleControl(particle, 2, common_vector)
ParticleManager:SetParticleControl(particle, 4, common_vector)
ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))

ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
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

