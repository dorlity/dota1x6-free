LinkLuaModifier( "modifier_tower_incoming_speed", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_damage", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_damage_cd", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_damage_visual", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_vision", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_no_heal", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_no_spells", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_push_reduce", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_timer", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_incoming_duel_soon", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_damage_check", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tower_alert_cd", "modifiers/modifier_tower_incoming", LUA_MODIFIER_MOTION_NONE )


modifier_tower_incoming = class({})

modifier_tower_incoming.skills = 
{
	"ember_spirit_activate_fire_remnant_custom",
	"alchemist_acid_spray_mixing",
	"custom_puck_ethereal_jaunt"
	
}


function modifier_tower_incoming:IsHidden() return true end
function modifier_tower_incoming:IsPurgable() return false end

function modifier_tower_incoming:OnCreated()
if not IsServer() then return end

self.state = 0
self:StartIntervalThink(0.2)

end 




function modifier_tower_incoming:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end
if not self:GetParent() then return end
if not towers[self:GetParent():GetTeamNumber()] then return end 
if GameRules:GetDOTATime(false, false) < push_timer then return end
if players[self:GetParent():GetTeamNumber()] and players[self:GetParent():GetTeamNumber()]:HasModifier("modifier_target") then return end


local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), towers[self:GetParent():GetTeamNumber()]:GetAbsOrigin() , nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE  + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_CLOSEST, false)

if #enemies > 0 then 

	if self.state == 0 then 
		self.state = 1
   		self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_tower_incoming_timer", {duration = 2})
   	end 

   	if self.state == 1 and not self:GetParent():HasModifier("modifier_tower_incoming_timer") then 
   		self.state = 2
   	end

else 
	self.state = 0

	if self:GetParent():HasModifier("modifier_tower_incoming_timer") then 
		self:GetParent():RemoveModifierByName("modifier_tower_incoming_timer")
	end
end


end






function modifier_tower_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
 	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end



function modifier_tower_incoming:GetAbsoluteNoDamagePhysical(params)
if not IsServer() then return end
local player = players[self:GetParent():GetTeamNumber()]

if player and duel_data[player.duel_data] and 
	duel_data[player.duel_data].stage ~= 1 and duel_data[player.duel_data].finished == 0 then 

		return 1
end 

if params.attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 
	return 1 
end 

end


function modifier_tower_incoming:GetAbsoluteNoDamageMagical(params)
if not IsServer() then return end
local player = players[self:GetParent():GetTeamNumber()]

if player and duel_data[player.duel_data] and 
	duel_data[player.duel_data].stage ~= 1 and duel_data[player.duel_data].finished == 0 then 

		return 1
end 

if params.attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 
	return 1 
end 

end


function modifier_tower_incoming:GetAbsoluteNoDamagePure(params)
if not IsServer() then return end

local player = players[self:GetParent():GetTeamNumber()]

if player and duel_data[player.duel_data] and 
	duel_data[player.duel_data].stage ~= 1 and duel_data[player.duel_data].finished == 0 then 

		return 1
end 



local tower = towers[self:GetParent():GetTeamNumber()]
local attacker = params.attacker

if not attacker then return end

if (tower and (tower:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D() > 900)  or not attacker:IsAlive() then 
	self:PlayEffect()
	return 1
end

if attacker:IsInvulnerable() or attacker:IsOutOfGame() then 
	self:PlayEffect()
	return 1
end

if self.state ~= 2 and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 
	self:PlayEffect()
	return 1
end

if not attacker:HasModifier("modifier_tower_incoming_damage") then 

	return 1
end 


return 0 
end



function modifier_tower_incoming:PlayEffect()
if not IsServer() then return end 

self:GetParent():EmitSound("Huskar.Disarm_Str")
self.effect_cast = ParticleManager:CreateParticle("particles/items_fx/backdoor_protection.vpcf", PATTACH_ABSORIGIN, self:GetParent())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 200, 0, 0) )
ParticleManager:ReleaseParticleIndex(self.effect_cast)

end 

function modifier_tower_incoming:CheckState()
if my_game:FinalDuel() == true then 
	return
	{
		[MODIFIER_STATE_INVULNERABLE] = true
	}
end 

end 




function modifier_tower_incoming:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if not params.attacker:IsHero() then return end
if params.no_attack_cooldown and not params.attacker:HasModifier("modifier_alchemist_rage_legendary") then return end

local player = players[self:GetParent():GetTeamNumber()]
if not player then return end 

params.attacker:AddNewModifier(params.attacker, nil, "modifier_tower_incoming_speed", {duration = 1.1})


if players[self:GetParent():GetTeamNumber()] and players[self:GetParent():GetTeamNumber()]:HasModifier("modifier_target") then 
	self:PlayEffect()
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.attacker:GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#push_target"})
	return
end

if duel_data[player.duel_data] and duel_data[player.duel_data].stage ~= 1 and duel_data[player.duel_data].finished == 0 then 
	self:PlayEffect()
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.attacker:GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#push_duel"})
	return
end 


if towers[params.attacker:GetTeamNumber()] then 
	local mod = towers[params.attacker:GetTeamNumber()]:FindModifierByName("modifier_tower_incoming_duel_soon")

	if mod and mod:GetRemainingTime() <= duel_push_time then 

		self:PlayEffect()
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.attacker:GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#push_duel_soon"})
		return
	end 
end 


if GameRules:GetDOTATime(false, false) < push_timer then 
	self:PlayEffect()
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.attacker:GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#push_timer"})
	return
end

if not params.attacker:IsRealHero() then return end
if params.attacker:IsTempestDouble() then return end
if params.attacker:HasModifier("modifier_mars_scepter_damage") then return end
if params.attacker:HasModifier("modifier_skeleton_king_reincarnation_custom_legendary") then return end
if params.attacker:HasModifier("modifier_patrol_warp_amulet_building") then return end
if params.attacker:HasModifier("modifier_custom_juggernaut_blade_fury") then return end

local mod = params.attacker:FindModifierByName("modifier_crystal_maiden_crystal_nova_legendary_aura")
if mod and mod:GetCaster() == params.attacker then 
	return
end


params.attacker:AddNewModifier(params.attacker, nil, "modifier_tower_incoming_damage", {})

local damage = self:GetParent():GetMaxHealth()*0.1

if self:GetParent():GetUnitName() == "npc_towerradiant" or self:GetParent():GetUnitName() == "npc_towerdire" then 
	damage = self:GetParent():GetMaxHealth()*0.04
end
local k = 1

local mod = self:GetParent():FindModifierByName("modifier_filler_armor")

if self:GetParent():HasModifier("modifier_razor_tower_custom") then 
	k = k + 0.2
end

if self:GetParent():HasModifier("modifier_item_patrol_fortifier") then 
	k = k - 0.3
end
	
local push_mod = self:GetParent():FindModifierByName("modifier_tower_incoming_push_reduce")
if push_mod then 

	local reason = 1

	if push_mod.death and push_mod.death == 1 then 
		reason = 2
	end

	local should_reduce = false

	if (push_mod.heroes and #push_mod.heroes > 0) then 


		should_reduce = true
		for _,hero in pairs(push_mod.heroes) do 
			if hero == params.attacker then 
				should_reduce = false
			end 
		end

	else 
		if (push_mod.hero and push_mod.hero ~= params.attacker) or not push_mod.hero then 
			should_reduce = true
		end
	end 

	if should_reduce == true then 


		if not params.attacker:HasModifier("modifier_tower_alert_cd") then 

			params.attacker:AddNewModifier(params.attacker, nil, "modifier_tower_alert_cd", {duration = 20})
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.attacker:GetPlayerOwnerID()), 'BackdoorAlert',  {reason = reason})
		end 

		k = k - 0.7
	end 

	if players[self:GetParent():GetTeamNumber()] then 
		AddFOWViewer(params.attacker:GetTeamNumber(), players[self:GetParent():GetTeamNumber()]:GetAbsOrigin(), 800, 3, false)
	end
end

local common_damage = 0.08
if params.attacker:HasModifier("modifier_up_graypoints") then 
	common_damage = 0.08*(1 + 0.25)
end

if params.attacker:HasModifier("modifier_up_towerdamage") then 
	k = k + common_damage*params.attacker:FindModifierByName("modifier_up_towerdamage"):GetStackCount()
end

if mod then 
	k =  k - 0.2*mod:GetStackCount()
	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_tower_incoming_damage_visual", {duration = 3})
else 
	self:GetParent():RemoveModifierByName("modifier_tower_incoming_damage_visual")
end

if params.attacker:HasModifier("modifier_item_the_leveller") then 
	k = k + 0.1
end

if k <= 0 then 
	k = 0
	self:PlayEffect()
end


damage = damage*k



if towers[self:GetParent():GetTeamNumber()] 
	and self.state == 2
	and not towers[self:GetParent():GetTeamNumber()]:HasModifier("modifier_backdoor_knock_aura") 
	and params.attacker 
	and params.attacker:IsRealHero()
	and self:GetParent():GetTeamNumber() ~= params.attacker:GetTeamNumber() 
	and not params.attacker:HasModifier("modifier_target")  then 
	
		towers[self:GetParent():GetTeamNumber()]:AddNewModifier(towers[self:GetParent():GetTeamNumber()], nil, "modifier_backdoor_knock_aura", {target = params.attacker:entindex()})
end

if towers[self:GetParent():GetTeamNumber()] and self.state == 2 then 
	local fort = towers[self:GetParent():GetTeamNumber()]:FindModifierByName("modifier_item_patrol_fortifier_tower")

	if fort then 
		fort:Activate()
	end 

end 


if not self:GetParent():HasModifier("modifier_tower_incoming_damage_cd") then 

	local damageTable = 
	{
		victim = self:GetParent(),
		attacker = params.attacker,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = nil,
		damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}

	ApplyDamage(damageTable)

	if params.attacker:IsRealHero() and params.attacker:GetQuest() == "General.Quest_14" then 
		params.attacker:UpdateQuest(damage)
	end

	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_tower_incoming_no_heal", {duration = 3})


	if towers[params.attacker:GetTeamNumber()] and players[self:GetParent():GetTeamNumber()] then 
		my_game:ActivatePushReduce(params.attacker:GetTeamNumber(), self:GetParent():GetTeamNumber())
	end

	for _,name in pairs(self.skills) do 	
		local ability = params.attacker:FindAbilityByName(name)


		if ability and ability:GetSpecialValueFor("tower_attack_cd") then 
			local cd = ability:GetCooldownTimeRemaining()

			if cd < ability:GetSpecialValueFor("tower_attack_cd") then 
				ability:StartCooldown(ability:GetSpecialValueFor("tower_attack_cd"))
			end
		end

	end

	self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_tower_incoming_damage_cd", {duration = 0.5})
end

params.attacker:RemoveModifierByName("modifier_tower_incoming_damage")

end



modifier_tower_incoming_damage = class({})
function modifier_tower_incoming_damage:IsHidden() return true end
function modifier_tower_incoming_damage:IsPurgable() return false end



modifier_tower_incoming_speed = class({})
function modifier_tower_incoming_speed:IsHidden() return false end
function modifier_tower_incoming_speed:IsDebuff() return true end
function modifier_tower_incoming_speed:IsPurgable() return false end
function modifier_tower_incoming_speed:GetTexture() return "backdoor_protection" end


function modifier_tower_incoming_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_tower_incoming_speed:GetModifierFixedAttackRate()
return 0.8
end

function modifier_tower_incoming_speed:OnTooltip()
return 10
end

function modifier_tower_incoming_speed:OnTooltip2()
return 4
end


function modifier_tower_incoming_speed:CheckState()
return
{
	--[MODIFIER_STATE_CANNOT_MISS] = true
}
end


modifier_tower_incoming_damage_cd = class({})
function modifier_tower_incoming_damage_cd:IsHidden() return true end
function modifier_tower_incoming_damage_cd:IsPurgable() return false end


modifier_tower_incoming_damage_visual = class({})
function modifier_tower_incoming_damage_visual:IsHidden() return true end
function modifier_tower_incoming_damage_visual:IsPurgable() return false end
function modifier_tower_incoming_damage_visual:OnCreated(table)
if not IsServer() then return end

  --[[
self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "Hero_Pangolier.TailThump.Shield"
self.buff_particles = {}

self:GetCaster():EmitSound( self.sound)

local abs = self:GetCaster():GetAbsOrigin()
abs.z = abs.z + 80

self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.buff_particles[1], 1, abs) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.buff_particles[2], 1, abs) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(self.buff_particles[3], 1, abs) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)]]
end


modifier_tower_incoming_vision = class({})
function modifier_tower_incoming_vision:IsHidden() return true end
function modifier_tower_incoming_vision:IsPurgable() return false end
function modifier_tower_incoming_vision:RemoveOnDeath() return false end
function modifier_tower_incoming_vision:OnCreated(table)
if not IsServer() then return end
local team = table.team
self.tower = towers[team]

self:StartIntervalThink(0.5)
end

function modifier_tower_incoming_vision:OnIntervalThink()
if not IsServer() then return end
if self.tower == nil then
	self:Destroy()
	return
end

AddFOWViewer(self:GetParent():GetTeamNumber(), self.tower:GetAbsOrigin(), 1000, 0.5, false)
end


modifier_tower_incoming_no_heal = class({})
function modifier_tower_incoming_no_heal:IsHidden() return true end
function modifier_tower_incoming_no_heal:IsPurgable() return false end



modifier_tower_incoming_no_spells = class({})
function modifier_tower_incoming_no_spells:IsHidden() return false end
function modifier_tower_incoming_no_spells:IsPurgable() return false end
function modifier_tower_incoming_no_spells:OnCreated(table)
if not IsServer() then return end

for _,name in pairs(self.skills) do 

	local ability = self:GetParent():FindAbilityByName(name)


	if ability then 
		local cd = ability:GetCooldownTimeRemaining()

		if cd < self:GetRemainingTime() then 
			ability:StartCooldown(self:GetRemainingTime())
		end
	end
end


end

function modifier_tower_incoming_no_spells:OnRefresh(table)
self:OnCreated()
end



modifier_tower_incoming_push_reduce = class({})
function modifier_tower_incoming_push_reduce:IsHidden() return false end
function modifier_tower_incoming_push_reduce:IsPurgable() return false end
function modifier_tower_incoming_push_reduce:GetTexture() return "shrine_aura" end
function modifier_tower_incoming_push_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_tower_incoming_push_reduce:OnTooltip()
	return -70

end


function modifier_tower_incoming_push_reduce:OnCreated(table)
if not  IsServer() then return end 

local team = nil 
self.hero = nil 

self.heroes = {}

self.death = table.death

if table.hero then 
	self.hero = EntIndexToHScript(table.hero)
end



self.init = false

self:StartIntervalThink(0.1)

end 


function modifier_tower_incoming_push_reduce:OnIntervalThink()
if not IsServer() then return end 

if self.init == false then 
	self.init = true
	
	for i = 1,11 do

		local show = true

		if (self.hero and self.hero:GetTeamNumber() == i) or not players[i] then 
			show = false
		end

		if #self.heroes > 0 then 

			for _,hero in pairs(self.heroes) do 
				if hero:GetTeamNumber() == i or not players[i] then 
					show = false
				end 
			end 	

		end 

		if show == true then 
			self.effect = ParticleManager:CreateParticleForTeam( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), i )
			self:AddParticle(self.effect,false, false, -1, false, false)
		end

	end

end 



if self.death ~= 1 then return end 

if not players[self:GetParent():GetTeamNumber()] or players[self:GetParent():GetTeamNumber()]:IsAlive() then 
	self:Destroy()
else 
	self:SetDuration(9999999, true)
end 

end 










modifier_tower_incoming_timer = class({})
function modifier_tower_incoming_timer:IsHidden() return true end
function modifier_tower_incoming_timer:IsPurgable() return false end

function modifier_tower_incoming_timer:OnCreated(table)
if not IsServer() then return end
  self.t = -1
  self.timer = 2*2 
  self:StartIntervalThink(0.5)
  self:OnIntervalThink()
end


function modifier_tower_incoming_timer:OnIntervalThink()
if not IsServer() then return end
self.t = self.t + 1

local caster = self:GetParent()

local number = (self.timer-self.t)/2 
local int = 0
int = number

if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
    decimal = 8
else 
    decimal = 1
end

local teleport = teleports[self:GetParent():GetTeamNumber()]

if not teleport then return end 

local particleName = "particles/huskar_timer.vpcf"

if teleport:GetName() == "3" or teleport:GetName() == "8" or teleport:GetName() == "9" then 
	particleName = "particles/lina_timer.vpcf"
end

local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end



modifier_tower_incoming_duel_soon = class({})
function modifier_tower_incoming_duel_soon:IsHidden() return false end
function modifier_tower_incoming_duel_soon:IsPurgable() return false end
function modifier_tower_incoming_duel_soon:RemoveOnDeath() return false end







modifier_tower_damage_check = class({})
function modifier_tower_damage_check:IsHidden() return false end 
function modifier_tower_damage_check:IsPurgable() return false end 
function modifier_tower_damage_check:RemoveOnDeath() return false end 
function modifier_tower_damage_check:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_tower_damage_check:GetTexture() return self:GetCaster():GetUnitName() end 



modifier_tower_alert_cd = class({})
function modifier_tower_alert_cd:IsHidden() return true end
function modifier_tower_alert_cd:IsPurgable() return false end
function modifier_tower_alert_cd:RemoveOnDeath() return false end