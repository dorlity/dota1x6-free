modifier_tormentor_custom = class({})


function modifier_tormentor_custom:IsHidden() return true end
function modifier_tormentor_custom:IsPurgable() return false end
function modifier_tormentor_custom:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

local base = 3950
local inc = 1.14

for i = 8,dota1x6.current_wave do
	if i >= 10 then 
		inc = 1.10
	end 
	base = base*inc
end

if not IsSoloMode() then
  base = base*tormentor_team_health
end

self.max_shield = base
self.shield = self.max_shield

self:SetHasCustomTransmitterData(true)
self.parent:SetNeverMoveToClearSpace(true)

self.reflect_ability = self.parent:FindAbilityByName("patrol_tormentor_reflect_custom")
self.shield_ability = self.parent:FindAbilityByName("patrol_tormentor_shield_custom")

self.mark_team = nil
self.origin = self.parent:GetAbsOrigin()

if not self.reflect_ability or not self.shield_ability then 
	self:Destroy()
	return
end

self.damageTable = {attacker = self.parent, ability = self.reflect_ability, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION}
self.radius = self.reflect_ability:GetSpecialValueFor("radius")
self.damage = self.reflect_ability:GetSpecialValueFor("damage")/100
self.marked_damage = self.reflect_ability:GetSpecialValueFor("marked_damage")/100

self.shield_regen = self.shield_ability:GetSpecialValueFor("regen")/100
self.stun_cd = self.shield_ability:GetSpecialValueFor("stun_cd")
self.stun_shield = self.shield_ability:GetSpecialValueFor("stun_shield")/100
self.wave_duration = self.shield_ability:GetSpecialValueFor("wave_duration") + 0.1
self.death_heal = self.shield_ability:GetSpecialValueFor("death_heal")/100

self.shield_effect = "particles/neutral_fx/miniboss_shield.vpcf"
self.reflect_effect = "particles/neutral_fx/miniboss_damage_reflect.vpcf"
self.impact_effect = "particles/neutral_fx/miniboss_damage_impact.vpcf"
self.wave_effect = "particles/tormentor/stun_wave.vpcf"

self.side = table.side

if self.side == 1 then
	self.shield_effect = "particles/neutral_fx/miniboss_shield_dire.vpcf"
	self.reflect_effect = "particles/neutral_fx/miniboss_damage_reflect_dire.vpcf"
	self.impact_effect = "particles/neutral_fx/miniboss_dire_damage_impact.vpcf"
	self.wave_effect = "particles/tormentor/stun_wave_dire.vpcf"

	self.parent:SetMaterialGroup("1")
end

self.particle = ParticleManager:CreateParticle(self.shield_effect, PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, true, false)

self.health_mod = nil
self.health_unit = EntIndexToHScript(table.health_unit)

if not self.health_unit or self.health_unit:IsNull() then
	self:Destroy()
	return
end

self.parent:EmitSound("Miniboss.Tormenter.Spawn")
self.parent:StartGesture(ACT_DOTA_SPAWN)

self:UpdateHealth()

self.interval = 0.1

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_tormentor_custom:OnIntervalThink()
if not IsServer() then return end

for id,player in pairs(players) do
	AddFOWViewer(player:GetTeamNumber(), self.origin, self.radius, self.interval, false)
end


if self.health_unit and not self.health_unit:IsNull() then
	self.health_unit:SetAbsOrigin(self.parent:GetAbsOrigin())
end

if self.mark_team then
	local allow = false
	local ids = dota1x6:FindPlayers(self.mark_team)
	if ids then
		for _,id in pairs(ids) do
			local player = players[id]
			if player then
				local dist = (player:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()
				if dist <= self.radius and (player:IsAlive() or player:IsReincarnating()) then
					allow = true
					if not player:HasModifier("modifier_tormentor_custom_mark") then
						player:AddNewModifier(player, nil, "modifier_tormentor_custom_mark", {side = self.side})
					end
				else
					player:RemoveModifierByName("modifier_tormentor_custom_mark")
				end
			end
		end
	end

	if not allow then
		self.mark_team = nil
	end
end

if not self.mark_team then
	if self.shield < self.max_shield then
		local regen = self.max_shield*self.shield_regen*self.interval
		self.shield = math.min(self.max_shield, self.shield + regen)
		self:UpdateHealth()
	end
end


if self.shield <= self.max_shield*self.stun_shield and not self.parent:HasModifier("modifier_tormentor_custom_stun_cd") then

	local wave = false

	for _,player in pairs(players) do
		if (player:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.radius and (not self.mark_team or self.mark_team ~= player:GetTeamNumber()) then
			wave = true
			break
		end
	end
	if wave then
		self.parent:AddNewModifier(self.parent, self.shield_ability, "modifier_tormentor_custom_stun_cd", {duration = self.stun_cd})
		self.parent:AddNewModifier(self.parent, self.shield_ability, "modifier_tormentor_custom_stun_wave", {team = self.mark_team, side = self.side, duration = self.wave_duration})
		self.parent:GenericParticle(self.wave_effect)
		self.parent:EmitSound("Tormentor.Stun_wave")
	end
end

if self.parent:GetAbsOrigin() == self.origin then return end
self.parent:SetAbsOrigin(self.origin)
end


function modifier_tormentor_custom:DeathEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end

local attacker_table = players[params.attacker:GetId()]

if not attacker_table then return end

local attacker_id = attacker_table:GetId()
local team = attacker_table:GetTeamNumber()
local low_net = PlayerResource:GetNetWorth(attacker_id)
local low_id  = attacker_id
local ids = dota1x6:FindPlayers(team)
local shard_hero = -1

if ids then
	for _,id in pairs(ids) do
		local player = players[id]
		local net = PlayerResource:GetNetWorth(id)
		if net < low_net and player and not player:HasShard() then
			low_net = net
			low_id = id
		end
	end
end

local low_player = players[low_id]
if low_player and not low_player:HasShard() then
	shard_hero = low_player:GetUnitName()
	self:GiveItem("item_aghanims_shard", low_player)
elseif ids then
	local gold = tormentor_gold/#ids
	for _,id in pairs(ids) do
		local player = players[id]
		if player then
			player:ModifyGold(gold, true, DOTA_ModifyGold_CreepKill)
			player:SendNumber(0, gold)
		end
	end
end

if self.mark_team then

	local ids = dota1x6:FindPlayers(self.mark_team)
	if ids then
		for _,id in pairs(ids) do
			local player = players[id]
			if player and player:IsAlive() and (player:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= self.radius then
				local heal = (player:GetMaxHealth() - player:GetHealth())*self.death_heal
				player:GenericHeal(heal, self.shield_ability)
			end
		end
	end
end

attacker_table:GenericParticle("particles/general/patrol_refresh.vpcf")
self:GiveItem("item_patrol_vision", attacker_table)
CustomGameEventManager:Send_ServerToAllClients("mini_alert_event",  {hero_1 = attacker_table:GetUnitName(), hero_2 = shard_hero, event_type = "tormentor"})
end


function modifier_tormentor_custom:GiveItem(name, attacker)
if not IsServer() then return end

local item = CreateItem(name, attacker, attacker)

if attacker:GetNumItemsInInventory() < 10 then
  attacker:AddItem(item)
else
  CreateItemOnPositionSync(GetGroundPosition(attacker:GetAbsOrigin(), attacker), item)
end

end


function modifier_tormentor_custom:OnDestroy()
if not IsServer() then return end

if self.health_unit and not self.health_unit:IsNull() then
	UTIL_Remove(self.health_unit)
end

if not self.mark_team then return end

local ids = dota1x6:FindPlayers(self.mark_team)
if not ids then return end

for _,id in pairs(ids) do
	local player = players[id]
	if player then
		player:RemoveModifierByName("modifier_tormentor_custom_mark")
	end
end

end


function modifier_tormentor_custom:DamageEvent(params)
if not IsServer() then return end 
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local damage = params.original_damage

if damage <= 0 then return end

local attacker = params.attacker

local attacker_table = players[attacker:GetId()]
if attacker_table then

	if towers[attacker:GetTeamNumber()] then 
		dota1x6:ActivatePushReduce(attacker:GetTeamNumber())
	end

	local hero = attacker_table

	if not self.mark_team and not hero:IsNull() and hero:IsAlive() then
		self.mark_team = hero:GetTeamNumber()
	end
end

self.parent:GenericParticle(self.impact_effect)
self.parent:EmitSound("Miniboss.Tormenter.Target")
self.parent:StartGesture(ACT_DOTA_FLINCH)

for _,target in pairs(self.parent:FindTargets(self.radius)) do

	local pfx = ParticleManager:CreateParticle(self.reflect_effect, PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(pfx)

	local reflect_damage = self.damage*damage

	if self.mark_team and target:GetTeamNumber() == self.mark_team then
		reflect_damage = self.marked_damage*damage
	end

	self.damageTable.damage = reflect_damage
	self.damageTable.victim = target

	target:EmitSound("Miniboss.Tormenter.Reflect")
	DoDamage(self.damageTable)
end

end

function modifier_tormentor_custom:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true, 
}
end

function modifier_tormentor_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
}
end

function modifier_tormentor_custom:GetOverrideAnimation()
return ACT_DOTA_IDLE
end

function modifier_tormentor_custom:GetModifierIncomingDamageConstant( params )

if IsClient() then 
  if params.report_max then 
      return self.max_shield
  else  
      return self.shield
  end 
end

if not IsServer() then return end

if (params.attacker:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > self.radius or not params.attacker:IsAlive() then 

	self.parent:EmitSound("UI.Immune_attack")
	self.effect_cast = ParticleManager:CreateParticle("particles/items_fx/backdoor_protection.vpcf", PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 300, 0, 0) )
	ParticleManager:ReleaseParticleIndex(self.effect_cast)

	return -params.damage
end

self:DamageEvent(params)

if self.shield > params.damage then
	self.shield = self.shield - params.damage

	self:UpdateHealth()
	local i = params.damage
	return -i
else
	local i = self.shield
	self.shield = 0
	self:UpdateHealth()
	return -i
end

end

function modifier_tormentor_custom:AddCustomTransmitterData()
return 
{
	shield = self.shield,
	max_shield = self.max_shield
}
end

function modifier_tormentor_custom:HandleCustomTransmitterData(data)
self.shield = data.shield
self.max_shield = data.max_shield
end

function modifier_tormentor_custom:UpdateHealth()
if not IsServer() then return end
if not self.health_unit or self.health_unit:IsNull() then return end

if not self.health_mod then
	self.health_mod = self.health_unit:FindModifierByName("modifier_tormentor_custom_health")
end

if not self.health_mod or self.health_mod:IsNull() then return end

self:SendBuffRefreshToClients()
self.health_mod:UpdateHealth(self.shield, self.max_shield)
end





modifier_tormentor_custom_mark = class({})
function modifier_tormentor_custom_mark:IsHidden() return false end
function modifier_tormentor_custom_mark:IsPurgable() return false end
function modifier_tormentor_custom_mark:RemoveOnDeath() return false end
function modifier_tormentor_custom_mark:GetTexture() return "miniboss_reflect" end
function modifier_tormentor_custom_mark:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()

local name = "particles/tormentor/tormentor_mark.vpcf"
if table.side == 1 then
	name = "particles/tormentor/tormentor_mark_dire.vpcf"
end

self.particle = ParticleManager:CreateParticle(name, PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_OVERHEAD_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, true, false)
end




modifier_tormentor_custom_health = class({})
function modifier_tormentor_custom_health:IsHidden() return true end
function modifier_tormentor_custom_health:IsPurgable() return false end
function modifier_tormentor_custom_health:RemoveOnDeath() return false end
function modifier_tormentor_custom_health:OnCreated(table)

self.parent = self:GetParent()
self.max_shield = 1
self.shield = self.max_shield
if not IsServer() then return end

self:SetHasCustomTransmitterData(true)
end

function modifier_tormentor_custom_health:UpdateHealth(new_shield, max_shield)
if not IsServer() then return end
self.max_shield = max_shield
self.shield = new_shield
self:SendBuffRefreshToClients()
end

function modifier_tormentor_custom_health:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_tormentor_custom_health:AddCustomTransmitterData()
return 
{
	shield = self.shield,
	max_shield = self.max_shield
}
end

function modifier_tormentor_custom_health:HandleCustomTransmitterData(data)
self.shield = data.shield
self.max_shield = data.max_shield
end

function modifier_tormentor_custom_health:GetModifierIncomingDamageConstant( params )
if not IsClient() then return end

if params.report_max then 
    return self.max_shield
else  
    return self.shield
end 

end



function modifier_tormentor_custom_health:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true, 
}
end


modifier_tormentor_custom_stun_cd = class({})
function modifier_tormentor_custom_stun_cd:IsHidden() return false end
function modifier_tormentor_custom_stun_cd:IsPurgable() return false end
function modifier_tormentor_custom_stun_cd:RemoveOnDeath() return false end
function modifier_tormentor_custom_stun_cd:IsDebuff() return true end


modifier_tormentor_custom_stun_wave = class({})
function modifier_tormentor_custom_stun_wave:IsHidden() return true end
function modifier_tormentor_custom_stun_wave:IsPurgable() return false end
function modifier_tormentor_custom_stun_wave:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end

self.side = table.side
self.mark_team = nil

if table.team ~= 0 then
	self.mark_team = table.team
end

self.reflect_effect = "particles/tormentor/stun_target.vpcf"
self.electro_effect = "particles/tormentor/stun_wave_electro.vpcf"

if self.side == 1 then
	self.reflect_effect = "particles/tormentor/stun_target_dire.vpcf"
	self.electro_effect = "particles/tormentor/stun_wave_electro_dire.vpcf"
end

self.parent:GenericParticle(self.electro_effect)

self.radius = self.ability:GetSpecialValueFor("radius")
self.wave_duration = self.ability:GetSpecialValueFor("wave_duration")
self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
self.targets_hit = {}
self.current_radius = 0
self.interval = 0.05

self.radius_inc = (self.radius/self.wave_duration)*self.interval
self:StartIntervalThink(self.interval)
end

function modifier_tormentor_custom_stun_wave:OnIntervalThink()
if not IsServer() then return end

self.current_radius = self.current_radius + self.radius_inc

if self.current_radius > self.radius then
	self:Destroy()
	return
end

for _,target in pairs(self.parent:FindTargets(self.current_radius)) do
	if not self.targets_hit[target:entindex()] and (not self.mark_team or self.mark_team ~= target:GetTeamNumber()) then
		self.targets_hit[target:entindex()] = true

		local pfx = ParticleManager:CreateParticle(self.reflect_effect, PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControl(pfx, 0, self.parent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(pfx)

		target:EmitSound("Tormentor.Stun_target")
		target:AddNewModifier(self.parent, self.ability, "modifier_tormentor_custom_stun", {duration = self.stun_duration})
	end
end

end



modifier_tormentor_custom_stun = class({})
function modifier_tormentor_custom_stun:IsHidden() return true end
function modifier_tormentor_custom_stun:IsPurgable() return false end
function modifier_tormentor_custom_stun:IsStunDebuff() return true end
function modifier_tormentor_custom_stun:IsPurgeException() return true end
function modifier_tormentor_custom_stun:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH  end
function modifier_tormentor_custom_stun:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_tormentor_custom_stun:CheckState()
return
{
    [MODIFIER_STATE_FROZEN] = true,
    [MODIFIER_STATE_STUNNED] = true
}
end
