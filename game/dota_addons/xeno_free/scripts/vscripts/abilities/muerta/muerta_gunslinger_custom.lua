LinkLuaModifier("modifier_muerta_gunslinger_custom", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_custom_dig_area", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_custom_dig_bounty", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_creep_gospawn", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_creep", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_custom_speed", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_custom_active", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_muerta_gunslinger_custom_active_buff", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_custom_slow", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_custom_evasion", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_custom_illusion", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_custom_incoming", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_custom_incoming_cd", "abilities/muerta/muerta_gunslinger_custom", LUA_MODIFIER_MOTION_NONE)





muerta_gunslinger_custom = class({})

muerta_gunslinger_custom.chance_inc = {6, 9, 12}

muerta_gunslinger_custom.passive_k = 2
muerta_gunslinger_custom.passive_evasion = {8, 12, 16}
muerta_gunslinger_custom.passive_move = {8, 12, 16}
muerta_gunslinger_custom.passive_duration = 2

muerta_gunslinger_custom.speed_attack = {6, 9, 12}
muerta_gunslinger_custom.speed_max = 5
muerta_gunslinger_custom.speed_duration = 5

muerta_gunslinger_custom.active_range = 300
muerta_gunslinger_custom.active_duration = 0.25
muerta_gunslinger_custom.active_buff_duration = 6
muerta_gunslinger_custom.active_attacks = {2, 3}
muerta_gunslinger_custom.active_cd = {14, 10}

muerta_gunslinger_custom.slow_attack = -6
muerta_gunslinger_custom.slow_move = -4
muerta_gunslinger_custom.slow_max = 10
muerta_gunslinger_custom.slow_duration = 3
muerta_gunslinger_custom.slow_range = 60

muerta_gunslinger_custom.lowhp_duration = 5
muerta_gunslinger_custom.lowhp_health = 30
muerta_gunslinger_custom.lowhp_heal = 0.02
muerta_gunslinger_custom.lowhp_illusion_damage = 20
muerta_gunslinger_custom.lowhp_illusion_health = 300
muerta_gunslinger_custom.lowhp_incoming = -30
muerta_gunslinger_custom.lowhp_cd = 40



function muerta_gunslinger_custom:Precache(context)

    
PrecacheResource( "particle", "particles/muerta_dig_ground.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_gun_active.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_attack_slow.vpcf", context )
PrecacheResource( "particle", "particles/muerta/gun_evasion.vpcf", context )
PrecacheResource( "particle", "particles/blur_absorb.vpcf", context )

end



function muerta_gunslinger_custom:GetIntrinsicModifierName()
	return "modifier_muerta_gunslinger_custom"
end


function muerta_gunslinger_custom:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_muerta_gun_4") then 
	return self.active_cd[self:GetCaster():GetUpgradeStack("modifier_muerta_gun_4")]
end

return
end



function muerta_gunslinger_custom:GetBehavior()

if self:GetCaster():HasModifier("modifier_muerta_gun_4") then 
	return DOTA_ABILITY_BEHAVIOR_POINT
end

return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function muerta_gunslinger_custom:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasModifier("modifier_muerta_gun_4") then 
	if IsClient() then 
		return self.active_range
	else 
		return 99999
	end
end

return 
end


function muerta_gunslinger_custom:OnSpellStart()
if not IsServer() then return end

if test then 


 	my_game:TestQuest(self:GetCaster())
end

self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_3)

local point = self:GetCaster():GetCursorPosition()
if point == self:GetCaster():GetAbsOrigin() then 
    point = self:GetCaster():GetForwardVector()*10 + self:GetCaster():GetAbsOrigin()
end

local dir = (point - self:GetCaster():GetAbsOrigin()):Normalized()

self:GetCaster():SetForwardVector(dir)
self:GetCaster():FaceTowards(point)


self:GetCaster():EmitSound("Muerta.Gun_active")
self:GetCaster():EmitSound("Muerta.Gun_active2")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_muerta_gunslinger_custom_active", {x = point.x, y = point.y, z = point.z, duration = self.active_duration})


end



modifier_muerta_gunslinger_custom = class({})

function modifier_muerta_gunslinger_custom:IsHidden() return true end
function modifier_muerta_gunslinger_custom:IsPurgable() return false end

function modifier_muerta_gunslinger_custom:OnCreated()
	if not IsServer() then return end
	self.double_attack = false
	self.proj = false
end

function modifier_muerta_gunslinger_custom:OnRefresh()
	if not IsServer() then return end
	self.double_shot_chance = self:GetAbility():GetSpecialValueFor("double_shot_chance_custom")
end

function modifier_muerta_gunslinger_custom:DeclareFunctions()
	return 
	{
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PROJECTILE_NAME
	}
end


function modifier_muerta_gunslinger_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_muerta_gun_6") then return end
if self:GetParent():HasModifier("modifier_muerta_gunslinger_custom_incoming_cd") then return end
if self:GetParent():IsIllusion() then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().lowhp_health then return end
if self:GetParent() ~= params.unit then return end

self:GetParent():EmitSound("Muerta.Gun_lowhp")

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_gunslinger_custom_incoming_cd", {duration = self:GetAbility().lowhp_cd})

local caster = self:GetParent()
local damage = 100 - (self:GetAbility().lowhp_illusion_damage)
local incoming = (self:GetAbility().lowhp_illusion_health)
local target = nil

if params.attacker then 
	target = params.attacker:entindex()
end

local point = self:GetParent():GetAbsOrigin() + RandomVector(250)


local illusion = CreateIllusions( caster, caster, {duration = self:GetAbility().lowhp_duration, outgoing_damage = -damage ,incoming_damage = incoming}, 1, 1, false, true )
for _,i in pairs(illusion) do

	i:SetAbsOrigin(point)
	FindClearSpaceForUnit(i, point, true)

	i:SetHealth(i:GetMaxHealth())

	i.owner = caster

	for _,mod in pairs(caster:FindAllModifiers()) do
	  if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
	      i:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
	  end
	end

	i:AddNewModifier(caster, self:GetAbility(), "modifier_muerta_gunslinger_custom_illusion", {target = target, hero = self:GetParent():entindex(), duration = self:GetAbility().lowhp_duration } )
end

end






function modifier_muerta_gunslinger_custom:GetModifierMoveSpeedBonus_Percentage()
if not self:GetParent():HasModifier("modifier_muerta_gun_2") then return end

local k = 1
if self:GetParent():HasModifier("modifier_muerta_gunslinger_custom_evasion") then 
	k = self:GetAbility().passive_k
end

return self:GetAbility().passive_move[self:GetCaster():GetUpgradeStack("modifier_muerta_gun_2")]*k
end


function modifier_muerta_gunslinger_custom:GetModifierEvasion_Constant()
if not self:GetParent():HasModifier("modifier_muerta_gun_2") then return end

local k = 1
if self:GetParent():HasModifier("modifier_muerta_gunslinger_custom_evasion") then 
	k = self:GetAbility().passive_k
end

return self:GetAbility().passive_evasion[self:GetCaster():GetUpgradeStack("modifier_muerta_gun_2")]*k
end



function modifier_muerta_gunslinger_custom:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.target == self:GetParent() then return end


if params.no_attack_cooldown then


end

if not self:GetParent():HasModifier("modifier_muerta_gun_5") then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_gunslinger_custom_slow", {duration = self:GetAbility().slow_duration})
end

function modifier_muerta_gunslinger_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_muerta_gun_5") then return end

return self:GetAbility().slow_range
end




function modifier_muerta_gunslinger_custom:OnAttackStart(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.target == self:GetParent() then return end
if params.no_attack_cooldown then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:GetParent():RemoveModifierByName("modifier_muerta_gunslinger")

self.double_attack = false

local chance =  self:GetAbility():GetSpecialValueFor("double_shot_chance_custom")

if self:GetParent():HasModifier("modifier_muerta_gun_1") then 
	chance = chance + self:GetAbility().chance_inc[self:GetParent():GetUpgradeStack("modifier_muerta_gun_1")]
end

local proc = false
local mod = self:GetParent():FindModifierByName("modifier_muerta_gunslinger_custom_active_buff")

if mod then 
	proc = true
else 
	if RollPseudoRandomPercentage(chance, 832,self:GetCaster()) then 
		proc = true
	end
end


if proc == true then

	local ult = self:GetParent():FindAbilityByName("muerta_pierce_the_veil_custom")
	if ult and ult:GetLevel() > 0 and self:GetParent():HasModifier("modifier_muerta_veil_7") then 
		--ult:LegendaryProc(3)
	end

	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_muerta_gunslinger", {})
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_gunslinger.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(particle)
	self.double_attack = true
end

end



function modifier_muerta_gunslinger_custom:OnAttack(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if params.target == self:GetParent() then return end
if self:GetParent():PassivesDisabled() then return end
if params.no_attack_cooldown then return end


self:GetParent():RemoveModifierByName("modifier_muerta_gunslinger")

if not self.double_attack then return end

self:GetParent():EmitSound("Hero_Muerta.Attack.DoubleShot")

self.proj = true

Timers:CreateTimer(0.1, function()
	self.proj = false
end)

local mod = self:GetParent():FindModifierByName("modifier_muerta_gunslinger_custom_active_buff")

if mod then 
	mod:DecrementStackCount()

	if mod:GetStackCount() <= 0 then 
		mod:Destroy()
	end
end

if self:GetParent():HasModifier("modifier_muerta_gun_2") then 	
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_gunslinger_custom_evasion", {duration = self:GetAbility().passive_duration})

end

if self:GetParent():HasModifier("modifier_muerta_gun_3") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_gunslinger_custom_speed", {duration = self:GetAbility().speed_duration})
end


if true then return end

local heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetCaster():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("target_search_bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false)
local creeps = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, self:GetCaster():Script_GetAttackRange() + self:GetAbility():GetSpecialValueFor("target_search_bonus_range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 0, false)

for i = #heroes, 1, -1 do
    if heroes[i] ~= nil and (heroes[i] == params.target) then
        table.remove(heroes, i)
    end
end

for i = #creeps, 1, -1 do
    if creeps[i] ~= nil and (creeps[i] == params.target) then
        table.remove(creeps, i)
    end
end

local heroes_has = false
local creep_has = false

if #heroes > 0 then
	heroes_has = true
end

if #creeps > 0 then
	creep_has = true
end

if heroes_has then
	self:AttackTarget(heroes[1])
elseif creep_has then
	self:AttackTarget(creeps[1])
else
	
	self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, self:GetParent():GetAttackSpeed())

	Timers:CreateTimer(0.1, function()
		if params.target and not params.target:IsNull() and params.target:IsAlive() then 
			self:AttackTarget(params.target)
		end
	end)
end
self.double_attack = false

end

function modifier_muerta_gunslinger_custom:AttackTarget(target)
	if not IsServer() then return end
	self.proj = true
	self:GetCaster():PerformAttack(target, true, true, true, false, true, false, false)
	self.proj = false
end

function modifier_muerta_gunslinger_custom:GetModifierProjectileName()
	if not IsServer() then return end

	if self:GetParent():HasModifier( "modifier_muerta_pierce_the_veil_custom" ) then
		if not self.proj then
			return "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf"
		else
			return "particles/units/heroes/hero_muerta/muerta_ultimate_projectile_alternate.vpcf"
		end
	else
		if self.proj then
			return "particles/units/heroes/hero_muerta/muerta_base_attack_alt.vpcf"
		end
	end
end







modifier_muerta_gunslinger_custom_dig_area = class({})
function modifier_muerta_gunslinger_custom_dig_area:IsHidden() return true end
function modifier_muerta_gunslinger_custom_dig_area:IsPurgable() return false end
function modifier_muerta_gunslinger_custom_dig_area:OnCreated(table)
if not IsServer() then return end




self.icon = CreateUnitByName("npc_muerta_dig_icon", self:GetParent():GetAbsOrigin(), false, nil, nil, self:GetCaster():GetTeamNumber())
self.icon:AddNewModifier(self:GetCaster(), nil, "modifier_unselect", {}) 

local particle_cast = "particles/muerta_dig_ground.vpcf"

local parent = self:GetParent()

-- Create Particle
local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber() )
ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( 550, 1, 1 ) )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( 999999, 0, 0 ) )


self:AddParticle(effect_cast, false, false, -1, false, false)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'muerta_quest_alert',  {type = 1})

self:StartIntervalThink(0.2)
end


function modifier_muerta_gunslinger_custom_dig_area:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 800, 0.2, false)

end


function modifier_muerta_gunslinger_custom_dig_area:OnDestroy()
if not IsServer() then return end

if self.icon and not self.icon:IsNull() then
	UTIL_Remove(self.icon)
end

UTIL_Remove(self:GetParent())
end


function modifier_muerta_gunslinger_custom_dig_area:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
}
end








modifier_muerta_gunslinger_custom_dig_bounty = class({})
function modifier_muerta_gunslinger_custom_dig_bounty:IsHidden() return true end
function modifier_muerta_gunslinger_custom_dig_bounty:IsPurgable() return false end

function modifier_muerta_gunslinger_custom_dig_bounty:OnCreated(table)
if not IsServer() then return end

self.area = EntIndexToHScript(table.area)

end

function modifier_muerta_gunslinger_custom_dig_bounty:OnDestroy()
if not IsServer() then return end

UTIL_Remove(self:GetParent())
end



function modifier_muerta_gunslinger_custom_dig_bounty:Complete()
if not IsServer() then return end
if not self.area then return end
if self.area:IsNull() then return end


self.area:RemoveModifierByName("modifier_muerta_gunslinger_custom_dig_area")
self:Destroy()

end


function modifier_muerta_gunslinger_custom_dig_bounty:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
}
end







modifier_muerta_creep = class({})


function modifier_muerta_creep:IsHidden() return true end
function modifier_muerta_creep:IsPurgable() return false end
function modifier_muerta_creep:RemoveOnDeath() return false end


function modifier_muerta_creep:GetStatusEffectName()
    return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end
function modifier_muerta_creep:StatusEffectPriority()
 return 99999 
end



function modifier_muerta_creep:CheckState()
return
{
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,

}
end


function modifier_muerta_creep:OnDestroy()
if not IsServer() then return end

if self.icon and not self.icon:IsNull() then
	UTIL_Remove(self.icon)
end

end


function modifier_muerta_creep:OnCreated(table)
if not IsServer() then return end


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'muerta_quest_alert',  {type = 4})

self.icon = CreateUnitByName("npc_muerta_creep_icon", self:GetParent():GetAbsOrigin(), false, nil, nil, self:GetCaster():GetTeamNumber())
self.icon:AddNewModifier(self:GetCaster(), nil, "modifier_unselect", {}) 



self.health = self:GetParent():GetBaseMaxHealth()
self.damage = self:GetParent():GetBaseDamageMin()
self.speed = 0

self.change_health = 0
self.change_damage = 0


for i = 2, my_game.current_wave do

	self.up_health = 1.30
	self.up_damage = 1.23

	if i >= 10 then self.up_damage = 1.18 self.up_health = 1.21 self.speed = 20 end 
	if i >= 15 then self.up_damage = 1.17 self.up_health = 1.20  self.speed = 40  end 
	if i >= 20 then self.up_damage = 1.18 self.up_health = 1.23  self.speed = 80  end 

	self.health = self.health*self.up_health
	self.damage = self.damage*self.up_damage

end

self.health = self.health*1.2
self.damage = self.damage*1.2


self.change_health = self.health - self:GetParent():GetBaseMaxHealth()
self.change_damage = self.damage - self:GetParent():GetBaseDamageMin()

self:StartIntervalThink(0.2)

self:SetHasCustomTransmitterData(true)
end



function modifier_muerta_creep:DeclareFunctions()
   return   {
    MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_DEATH
  }

end

function modifier_muerta_creep:OnDeath(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

self:GetParent():EmitSound("Muerta.Quest_ghost_death")
end




function modifier_muerta_creep:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 600, 0.2, false)
end



function modifier_muerta_creep:AddCustomTransmitterData() return 
{
armor = self.armor,
speed = self.speed
} 
end

function modifier_muerta_creep:HandleCustomTransmitterData(data)
self.armor = data.armor
self.speed = data.speed
end

function modifier_muerta_creep:GetModifierAttackSpeedBonus_Constant()
return self.speed
end



function modifier_muerta_creep:GetModifierBaseAttack_BonusDamage()
return self.change_damage
end


function modifier_muerta_creep:GetModifierExtraHealthBonus()
return self.change_health
end




function modifier_muerta_creep:GetEffectName()
	return "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf"
end

function modifier_muerta_creep:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end







modifier_muerta_creep_gospawn = class({})
function modifier_muerta_creep_gospawn:IsHidden() return true end
function modifier_muerta_creep_gospawn:IsPurgable() return false end
function modifier_muerta_creep_gospawn:OnCreated(table)
if not IsServer() then return end

--self:GetParent():SetHealth(self:GetParent():GetMaxHealth())

end

function modifier_muerta_creep_gospawn:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
  	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end


function modifier_muerta_creep_gospawn:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_muerta_creep_gospawn:GetModifierMoveSpeedBonus_Percentage()
return 50
end






modifier_muerta_gunslinger_custom_speed = class({})
function modifier_muerta_gunslinger_custom_speed:IsHidden() return false end
function modifier_muerta_gunslinger_custom_speed:IsPurgable() return false end
function modifier_muerta_gunslinger_custom_speed:GetTexture() return "buffs/strike_armor" end

function modifier_muerta_gunslinger_custom_speed:OnCreated(table)

self.speed = self:GetAbility().speed_attack[self:GetCaster():GetUpgradeStack("modifier_muerta_gun_3")]
self.max = self:GetAbility().speed_max
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_muerta_gunslinger_custom_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

end

function modifier_muerta_gunslinger_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end



function modifier_muerta_gunslinger_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed*self:GetStackCount()
end







modifier_muerta_gunslinger_custom_active = class({})

function modifier_muerta_gunslinger_custom_active:IsDebuff() return false end
function modifier_muerta_gunslinger_custom_active:IsHidden() return true end
function modifier_muerta_gunslinger_custom_active:IsPurgable() return true end

function modifier_muerta_gunslinger_custom_active:OnCreated(kv)
    if not IsServer() then return end
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_FLAIL)

    self.point = Vector(kv.x, kv.y, kv.z)


    self.angle = self:GetParent():GetForwardVector():Normalized()--(self.point - self:GetParent():GetAbsOrigin()):Normalized() 

    self.distance = self:GetAbility().active_range / ( self:GetDuration() / FrameTime())

    self.targets = {}

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_muerta_gunslinger_custom_active:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_muerta_gunslinger_custom_active:GetActivityTranslationModifiers()
    return "forcestaff_friendly"
end


function modifier_muerta_gunslinger_custom_active:GetModifierDisableTurning() return 1 end

function modifier_muerta_gunslinger_custom_active:GetEffectName() return "particles/muerta/muerta_gun_active.vpcf" end
function modifier_muerta_gunslinger_custom_active:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_muerta_gunslinger_custom_active:StatusEffectPriority() return 100 end

function modifier_muerta_gunslinger_custom_active:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)

    self:GetParent():RemoveGesture(ACT_DOTA_FLAIL)
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_3)
    self:GetParent():StartGesture(ACT_DOTA_FORCESTAFF_END)

    self:GetParent():Stop()

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_muerta_gunslinger_custom_active_buff", {duration = self:GetAbility().active_buff_duration})

    local dir = self:GetParent():GetForwardVector()
    dir.z = 0
    self:GetParent():SetForwardVector(dir)
    self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

end


function modifier_muerta_gunslinger_custom_active:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local pos = self:GetParent():GetAbsOrigin()
    GridNav:DestroyTreesAroundPoint(pos, 80, false)
    local pos_p = self.angle * self.distance
    local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
    self:GetParent():SetAbsOrigin(next_pos)


end

function modifier_muerta_gunslinger_custom_active:OnHorizontalMotionInterrupted()
    self:Destroy()
end







modifier_muerta_gunslinger_custom_active_buff = class({})
function modifier_muerta_gunslinger_custom_active_buff:IsHidden() return false end
function modifier_muerta_gunslinger_custom_active_buff:IsPurgable() return false end
function modifier_muerta_gunslinger_custom_active_buff:GetTexture() return "buffs/aim_speed" end
function modifier_muerta_gunslinger_custom_active_buff:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(self:GetAbility().active_attacks[self:GetCaster():GetUpgradeStack("modifier_muerta_gun_4")])
end

function modifier_muerta_gunslinger_custom_active_buff:OnRefresh(table)
if not IsServer() then return end

self:SetStackCount(self:GetAbility().active_attacks[self:GetCaster():GetUpgradeStack("modifier_muerta_gun_4")])
end





modifier_muerta_gunslinger_custom_slow = class({})
function modifier_muerta_gunslinger_custom_slow:IsHidden() return false end
function modifier_muerta_gunslinger_custom_slow:IsPurgable() return true end
function modifier_muerta_gunslinger_custom_slow:GetTexture() return "buffs/gun_slow" end

function modifier_muerta_gunslinger_custom_slow:OnCreated(table)

self.speed = self:GetAbility().slow_attack
self.move = self:GetAbility().slow_move
self.max = self:GetAbility().slow_max
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_muerta_gunslinger_custom_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() == self.max/2 or self:GetStackCount() == self.max then 

	local effect_cast = ParticleManager:CreateParticle( "particles/muerta/muerta_attack_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(effect_cast, false, false, -1, false, false)
	
end



end

function modifier_muerta_gunslinger_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_muerta_gunslinger_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move*self:GetStackCount()
end


function modifier_muerta_gunslinger_custom_slow:GetModifierAttackSpeedBonus_Constant()
if self:GetParent():GetUnitName() == "npc_muerta_ogre"
or self:GetParent():GetUnitName() ==  "npc_muerta_satyr"
or self:GetParent():GetUnitName() ==  "npc_muerta_ursa"
or self:GetParent():GetUnitName() ==  "npc_muerta_centaur" then return end

return self.speed*self:GetStackCount()
end





modifier_muerta_gunslinger_custom_evasion = class({})
function modifier_muerta_gunslinger_custom_evasion:IsHidden() return false end
function modifier_muerta_gunslinger_custom_evasion:IsPurgable() return false end
function modifier_muerta_gunslinger_custom_evasion:GetTexture() return "buffs/blast_speed" end

function modifier_muerta_gunslinger_custom_evasion:GetEffectName() 
  return "particles/muerta/gun_evasion.vpcf"
end

function modifier_muerta_gunslinger_custom_evasion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end








modifier_muerta_gunslinger_custom_illusion = class({})
function modifier_muerta_gunslinger_custom_illusion:IsHidden() return true end
function modifier_muerta_gunslinger_custom_illusion:IsPurgable() return false end


function modifier_muerta_gunslinger_custom_illusion:GetStatusEffectName()
    return "particles/status_fx/status_effect_muerta_parting_shot.vpcf"
end
function modifier_muerta_gunslinger_custom_illusion:StatusEffectPriority()
 return 9999999
end


function modifier_muerta_gunslinger_custom_illusion:GetEffectName()
	return "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf"
end

function modifier_muerta_gunslinger_custom_illusion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




function modifier_muerta_gunslinger_custom_illusion:OnCreated(table)
if not IsServer() then return end

if table.hero then 
	self.hero = EntIndexToHScript(table.hero)
	self.mod = self.hero:AddNewModifier(self.hero, self:GetAbility(), "modifier_muerta_gunslinger_custom_incoming", {})
end

if table.target then 
	self.target = EntIndexToHScript(table.target)

	if (self:GetParent():GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() < 1500 then 

		self:GetParent():SetForceAttackTarget(self.target)
	end


end

self.particle_ally_fx = ParticleManager:CreateParticle("particles/blur_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hero)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.hero, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hero:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

self:StartIntervalThink(0.1)
end


function modifier_muerta_gunslinger_custom_illusion:OnIntervalThink()
if not IsServer() then return end
if self.target == nil or self.target:IsNull() or not self.target:IsAlive() then 
	self.target = nil
	self:GetParent():SetForceAttackTarget(nil)
end

end


function modifier_muerta_gunslinger_custom_illusion:OnDestroy()
if not IsServer() then return end 

if self.mod and not self.mod:IsNull() then 
	self.mod:Destroy()
end

end




function modifier_muerta_gunslinger_custom_illusion:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_muerta_gunslinger_custom_illusion:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not self.hero then return end
if self.hero:IsNull() then return end
if not self.hero:IsAlive() then return end


self.hero:GenericHeal(self.hero:GetMaxHealth()*self:GetAbility().lowhp_heal, self:GetAbility())

end



function modifier_muerta_gunslinger_custom_illusion:CheckState()
return
{
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
}
end


modifier_muerta_gunslinger_custom_incoming = class({})
function modifier_muerta_gunslinger_custom_incoming:IsHidden() return true end
function modifier_muerta_gunslinger_custom_incoming:IsPurgable() return false end
function modifier_muerta_gunslinger_custom_incoming:GetTexture() return "buffs/gun_lowhp" end
function modifier_muerta_gunslinger_custom_incoming:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_muerta_gunslinger_custom_incoming:OnCreated(table)
if not IsServer() then return end


self.particle_ally_fx = ParticleManager:CreateParticle("particles/blur_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)


end

function modifier_muerta_gunslinger_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_muerta_gunslinger_custom_incoming:GetModifierIncomingDamage_Percentage()
return self:GetAbility().lowhp_incoming
end



modifier_muerta_gunslinger_custom_incoming_cd = class({})
function modifier_muerta_gunslinger_custom_incoming_cd:IsHidden() return false end
function modifier_muerta_gunslinger_custom_incoming_cd:IsPurgable() return false end
function modifier_muerta_gunslinger_custom_incoming_cd:RemoveOnDeath() return false end
function modifier_muerta_gunslinger_custom_incoming_cd:IsDebuff() return true end
function modifier_muerta_gunslinger_custom_incoming_cd:GetTexture() return "buffs/gun_lowhp" end
function modifier_muerta_gunslinger_custom_incoming_cd:OnCreated(table)
self.RemoveForDuel = true
end