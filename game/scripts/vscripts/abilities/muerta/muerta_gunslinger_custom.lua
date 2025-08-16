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


function muerta_gunslinger_custom:CreateTalent()

local caster = self:GetCaster()

caster:EmitSound("Muerta.Quest_item2")

if dota1x6.current_wave < upgrade_orange then 

	dota1x6:MuertaQuestPhase(caster)
	local item = CreateItem("item_muerta_shovel_custom", caster, caster)
	caster:AddItem(item)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), "muerta_quest_panel",  { max = 0, stack = 0, stage = 1})
else 
	local item = CreateItem("item_muerta_mercy_and_grace_custom", caster, caster)
	caster:AddItem(item)	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), "muerta_quest_panel",  { max = 0, stack = 0, stage = 3})
end


end



function muerta_gunslinger_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end


PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_gunslinger.vpcf", context )
PrecacheResource( "particle", "particles/muerta/magic_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_projectile_alternate.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_base_attack_alt.vpcf", context )
PrecacheResource( "particle", "particles/muerta_dig_ground.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_wraithking_ghosts.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/force_staff.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_gun_active.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_forcestaff.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_attack_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_muerta_parting_shot.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf", context )
PrecacheResource( "particle", "particles/blur_absorb.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", context )
PrecacheResource( "particle", "particles/blur_absorb.vpcf", context )
PrecacheResource( "particle", "particles/muerta/gun_evasion.vpcf", context )

PrecacheResource( "particle","particles/econ/events/ti9/shovel_dig.vpcf", context )
PrecacheResource( "particle","particles/econ/events/ti9/shovel_smoke_cloud.vpcf", context ) 
PrecacheResource( "particle","particles/heroes/muerta/muerta_quest_kill.vpcf", context )
PrecacheResource( "particle","particles/econ/events/ti9/muerta_dig_treasure.vpcf", context ) 
PrecacheResource( "particle","particles/muerta_dig_drop.vpcf", context )
PrecacheResource( "particle","particles/muerta/muerta_quest_item.vpcf", context )
PrecacheResource( "particle","particles/econ/events/ti9/shovel_revealed_nothing.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", context )

PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", context )

PrecacheResource( "particle","particles/units/heroes/hero_muerta/muerta_ultimate_projectile_alternate.vpcf", context )
PrecacheResource( "particle","particles/muerta_item_active.vpcf", context )
PrecacheResource( "particle","particles/muerta_item_heal.vpcf", context )
end



function muerta_gunslinger_custom:GetIntrinsicModifierName()
	return "modifier_muerta_gunslinger_custom"
end


function muerta_gunslinger_custom:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_muerta_gun_5") then 
	return self:GetCaster():GetTalentValue("modifier_muerta_gun_5", "cd")
end
return
end



function muerta_gunslinger_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_muerta_gun_5") then 
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function muerta_gunslinger_custom:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasTalent("modifier_muerta_gun_5") then 
	if IsClient() then 
		return self:GetCaster():GetTalentValue("modifier_muerta_gun_5", "range")
	else 
		return 99999
	end
end

return 
end


function muerta_gunslinger_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()

if test then 
 	dota1x6:TestQuest(caster)
end

caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_3)

local point = caster:GetCursorPosition()
if point == caster:GetAbsOrigin() then 
    point = caster:GetForwardVector()*10 + caster:GetAbsOrigin()
end

local dir = (point - caster:GetAbsOrigin()):Normalized()

caster:SetForwardVector(dir)
caster:FaceTowards(point)


caster:EmitSound("Muerta.Gun_active")
caster:EmitSound("Muerta.Gun_active2")
caster:AddNewModifier(caster, self, "modifier_muerta_gunslinger_custom_active", {x = point.x, y = point.y, z = point.z, duration = caster:GetTalentValue("modifier_muerta_gun_5", "charge_duration")})
end



modifier_muerta_gunslinger_custom = class({})

function modifier_muerta_gunslinger_custom:IsHidden() return true end
function modifier_muerta_gunslinger_custom:IsPurgable() return false end

function modifier_muerta_gunslinger_custom:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_aoe = self.parent:GetTalentValue("modifier_muerta_gun_1", "aoe", true)

self.speed_k = self.parent:GetTalentValue("modifier_muerta_gun_2", "bonus", true)
self.speed_duration = self.parent:GetTalentValue("modifier_muerta_gun_2", "duration", true)

self.attack_duration = self.parent:GetTalentValue("modifier_muerta_gun_4", "duration", true)
self.chance_bonus = self.parent:GetTalentValue("modifier_muerta_gun_4", "bonus", true)

self.low_health = self.parent:GetTalentValue("modifier_muerta_gun_6", "health", true)
self.low_duration = self.parent:GetTalentValue("modifier_muerta_gun_6", "duration", true)
self.low_damage = self.parent:GetTalentValue("modifier_muerta_gun_6", "damage", true)
self.low_incoming = self.parent:GetTalentValue("modifier_muerta_gun_6", "incoming", true)
self.low_cd = self.parent:GetTalentValue("modifier_muerta_gun_6", "cd", true)
self.low_heal = self.parent:GetTalentValue("modifier_muerta_gun_6", "heal", true)/100

self.slow_duration = self.parent:GetTalentValue("modifier_muerta_gun_3", "duration", true)

self.count = 0
self.records = {}

if not IsServer() then return end

if self.parent:IsRealHero() then
	self.parent:AddRecordDestroyEvent(self)
	self.parent:AddAttackRecordEvent_out(self)
	self.parent:AddDamageEvent_inc(self)
	self.parent:AddAttackEvent_out(self)
	self.parent:AddAttackStartEvent_out(self)
end

self.double_shot_chance  = self.ability:GetSpecialValueFor("double_shot_chance_custom")

self.double_attack = false
self.proj = false
end


function modifier_muerta_gunslinger_custom:OnRefresh()
if not IsServer() then return end

self.double_shot_chance  = self.ability:GetSpecialValueFor("double_shot_chance_custom")
end 


function modifier_muerta_gunslinger_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_PROJECTILE_NAME
}
end



function modifier_muerta_gunslinger_custom:AttackRecordEvent_out(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if params.attacker ~= self.parent then return end
if params.target == self.parent then return end
if params.no_attack_cooldown then return end
if not params.target:IsUnit() then return end

self.parent:RemoveModifierByName("modifier_muerta_gunslinger")

self.double_attack = false

local chance = self.double_shot_chance + self.parent:GetTalentValue("modifier_muerta_gun_1", "chance")

if self.parent:HasTalent("modifier_muerta_gun_4") and params.target:GetHealthPercent() <= self.parent:GetTalentValue("modifier_muerta_gun_4", "health") then 
	chance = chance + self.chance_bonus
end 

if not RollPseudoRandomPercentage(chance, 832,self.parent) then return end 

self.parent:AddNewModifier(self:GetCaster(), self.ability, "modifier_muerta_gunslinger", {})
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_gunslinger.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:ReleaseParticleIndex(particle)
self.double_attack = true
end



function modifier_muerta_gunslinger_custom:AttackStartEvent_out(params)
if not IsServer() then return end
if params.attacker ~= self.parent then return end
if params.target == self.parent then return end
if self.parent:PassivesDisabled() then return end
if not self.double_attack then return end
if params.no_attack_cooldown then return end 

if self.parent:HasModifier("modifier_muerta_gunslinger") then 
	self.records[params.record] = true
end 

self.parent:RemoveModifierByName("modifier_muerta_gunslinger")

self.parent:EmitSound("Hero_Muerta.Attack.DoubleShot")

self.proj = true

Timers:CreateTimer(0.1, function()
	self.proj = false
end)

if self.parent:HasTalent("modifier_muerta_gun_2") then 	
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_muerta_gunslinger_custom_evasion", {duration = self.speed_duration})
end

if self.parent:HasTalent("modifier_muerta_gun_4") then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_muerta_gunslinger_custom_speed", {duration = self.attack_duration})
end

end


function modifier_muerta_gunslinger_custom:RecordDestroyEvent(params)
if not IsServer() then return end 
if not self.records[params.record] then return end 
self.records[params.record] = nil
end 


function modifier_muerta_gunslinger_custom:AttackEvent_out(params)
if not IsServer() then return end 
if self.parent:GetTeamNumber() ~= params.attacker:GetTeamNumber() then return end

local proc = false
if self.records[params.record] then 
	proc = true
end

if not params.target:IsUnit() then return end

local attacker = params.attacker
local target = params.target

if attacker:IsIllusion() and attacker.owner and attacker.owner == self.parent and self.parent:HasTalent("modifier_muerta_gun_6") then 

	local mod = attacker:FindModifierByName("modifier_muerta_gunslinger_custom_illusion")

	if mod and mod.hero and not mod.hero:IsNull() and mod.hero:IsAlive() then 
		mod.hero:GenericHeal(mod.hero:GetMaxHealth()*self.low_heal, self.ability, nil, nil, "modifier_muerta_gun_6")
	end
end

if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end

if self.parent:HasTalent("modifier_muerta_gun_3") and RollPseudoRandomPercentage(self.parent:GetTalentValue("modifier_muerta_gun_3", "chance"), 8302,self.parent) then 
	params.target:AddNewModifier(self.parent, self.ability, "modifier_muerta_gunslinger_custom_slow", {duration = self.slow_duration*(1 - params.target:GetStatusResistance())})
end 

if not proc then return end 

if self.parent:HasTalent("modifier_muerta_gun_1") then

	local particle = ParticleManager:CreateParticle("particles/muerta/magic_hit.vpcf", PATTACH_WORLDORIGIN, nil)	
	ParticleManager:SetParticleControl(particle, 0, params.target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)

	local damage = self.parent:GetTalentValue("modifier_muerta_gun_1", "damage")

	for _,unit in pairs(self.parent:FindTargets(self.damage_aoe, params.target:GetAbsOrigin())) do 
		DoDamage({victim = unit, attacker = self.parent, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability}, "modifier_muerta_gun_1")
	end
end

end 



function modifier_muerta_gunslinger_custom:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if not self.parent:HasTalent("modifier_muerta_gun_6") then return end
if self.parent ~= params.unit then return end
if self.parent:HasModifier("modifier_death") then return end
if self.parent:HasModifier("modifier_muerta_gunslinger_custom_incoming_cd") then return end
if self.parent:IsIllusion() then return end
if self.parent:GetHealthPercent() > self.low_health then return end

self.parent:EmitSound("Muerta.Gun_lowhp")

self.parent:AddNewModifier(self.parent, self.ability, "modifier_muerta_gunslinger_custom_incoming_cd", {duration = self.low_cd})

local damage = 100 - self.low_damage
local incoming = self.low_incoming - 100
local target = nil

if params.attacker then 
	target = params.attacker:entindex()
end

local point = self.parent:GetAbsOrigin() + RandomVector(250)

local illusions = CreateIllusions( self.parent, self.parent, {duration = self.low_duration, outgoing_damage = -damage ,incoming_damage = incoming}, 1, 1, false, true )
for _,illusion in pairs(illusions) do

	illusion:SetAbsOrigin(point)
	FindClearSpaceForUnit(illusion, point, true)

	illusion:SetHealth(illusion:GetMaxHealth())

	illusion.owner = self.parent

	for _,mod in pairs(self.parent:FindAllModifiers()) do
	  if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
	      illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
	  end
	end

	illusion:AddNewModifier(self.parent, self.ability, "modifier_muerta_gunslinger_custom_illusion", {target = target, hero = self.parent:entindex(), duration = self.low_duration } )
end

end






function modifier_muerta_gunslinger_custom:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_muerta_gun_2") then return end
local k = 1
if self.parent:HasModifier("modifier_muerta_gunslinger_custom_evasion") then 
	k = self.speed_k
end
return self.parent:GetTalentValue("modifier_muerta_gun_2", "move")*k
end


function modifier_muerta_gunslinger_custom:GetModifierPhysicalArmorBonus()
if not self.parent:HasTalent("modifier_muerta_gun_2") then return end
local k = 1
if self.parent:HasModifier("modifier_muerta_gunslinger_custom_evasion") then 
	k = self.speed_k
end
return self.parent:GetTalentValue("modifier_muerta_gun_2", "armor")*k
end


function modifier_muerta_gunslinger_custom:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_muerta_gun_3") then return end
return self.parent:GetTalentValue("modifier_muerta_gun_3", "range")
end




function modifier_muerta_gunslinger_custom:GetModifierProjectileName()
if not IsServer() then return end

if self.parent:HasModifier("modifier_muerta_pierce_the_veil_custom_attack") then
	return "particles/units/heroes/hero_muerta/muerta_ultimate_projectile_alternate.vpcf"
end


if self.parent:HasModifier( "modifier_muerta_pierce_the_veil_custom" ) then
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


function modifier_muerta_gunslinger_custom:OnDestroy()
if not IsServer() then return end
self.parent:RemoveModifierByName("modifier_muerta_gunslinger")
end





modifier_muerta_gunslinger_custom_dig_area = class({})
function modifier_muerta_gunslinger_custom_dig_area:IsHidden() return true end
function modifier_muerta_gunslinger_custom_dig_area:IsPurgable() return false end
function modifier_muerta_gunslinger_custom_dig_area:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.icon = CreateUnitByName("npc_muerta_dig_icon", self.parent:GetAbsOrigin(), false, nil, nil, self.caster:GetTeamNumber())
self.icon:AddNewModifier(self.caster, nil, "modifier_unselect", {}) 



local effect_cast = ParticleManager:CreateParticleForTeam( "particles/muerta_dig_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster:GetTeamNumber() )
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( 550, 1, 1 ) )
ParticleManager:SetParticleControl( effect_cast, 2, Vector( 999999, 0, 0 ) )


self:AddParticle(effect_cast, false, false, -1, false, false)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID()), "muerta_quest_alert",  {type = 1})

self:StartIntervalThink(0.2)
end


function modifier_muerta_gunslinger_custom_dig_area:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 800, 0.2, false)

end


function modifier_muerta_gunslinger_custom_dig_area:OnDestroy()
if not IsServer() then return end

if self.icon and not self.icon:IsNull() then
	UTIL_Remove(self.icon)
end

UTIL_Remove(self.parent)
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
return MODIFIER_PRIORITY_ILLUSION 
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


self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.caster = self:GetCaster()

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID()), "muerta_quest_alert",  {type = 4})

self.icon = CreateUnitByName("npc_muerta_creep_icon", self.parent:GetAbsOrigin(), false, nil, nil, self.caster:GetTeamNumber())
self.icon:AddNewModifier(self.caster, nil, "modifier_unselect", {}) 

self.health = self.parent:GetBaseMaxHealth()
self.damage = self.parent:GetBaseDamageMin()
self.speed = 0

self.change_health = 0
self.change_damage = 0


for i = 2, dota1x6.current_wave do

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

self.change_health = self.health - self.parent:GetBaseMaxHealth()
self.change_damage = self.damage - self.parent:GetBaseDamageMin()

self:StartIntervalThink(0.2)
self:SetHasCustomTransmitterData(true)
end


function modifier_muerta_creep:DeclareFunctions()
return   
{
	MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_muerta_creep:DeathEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end

self.parent:EmitSound("Muerta.Quest_ghost_death")
end

function modifier_muerta_creep:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 600, 0.2, false)
end

function modifier_muerta_creep:AddCustomTransmitterData() 
return 
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
self.parent = self:GetParent()

self.speed = self.parent:GetTalentValue("modifier_muerta_gun_4", "speed")
self.max = self.parent:GetTalentValue("modifier_muerta_gun_4", "max")

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

function modifier_muerta_gunslinger_custom_active:IsHidden() return true end
function modifier_muerta_gunslinger_custom_active:IsPurgable() return true end

function modifier_muerta_gunslinger_custom_active:OnCreated(kv)
if not IsServer() then return end

self.parent = self:GetParent()

ProjectileManager:ProjectileDodge(self.parent)

self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle(self.pfx, false, false, -1, false, false)

self.parent:StartGesture(ACT_DOTA_FLAIL)
self.point = Vector(kv.x, kv.y, kv.z)
self.angle = self.parent:GetForwardVector():Normalized()
self.distance = self.parent:GetTalentValue("modifier_muerta_gun_5", "range") / ( self:GetDuration() / FrameTime())

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
function modifier_muerta_gunslinger_custom_active:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end

function modifier_muerta_gunslinger_custom_active:OnDestroy()
if not IsServer() then return end
self.parent:InterruptMotionControllers( true )

self.parent:RemoveGesture(ACT_DOTA_FLAIL)
self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_3)
self.parent:StartGesture(ACT_DOTA_FORCESTAFF_END)

self.parent:Stop()

self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_muerta_gunslinger_custom_active_buff", {duration = self.parent:GetTalentValue("modifier_muerta_gun_5", "duration")})

local dir = self.parent:GetForwardVector()
dir.z = 0
self.parent:SetForwardVector(dir)
self.parent:FaceTowards(self.parent:GetAbsOrigin() + dir*10)

ResolveNPCPositions(self.parent:GetAbsOrigin(), 128)
end


function modifier_muerta_gunslinger_custom_active:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

local pos = self.parent:GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(pos, 80, false)
local pos_p = self.angle * self.distance
local next_pos = GetGroundPosition(pos + pos_p,self.parent)
self.parent:SetAbsOrigin(next_pos)
end

function modifier_muerta_gunslinger_custom_active:OnHorizontalMotionInterrupted()
self:Destroy()
end










modifier_muerta_gunslinger_custom_slow = class({})
function modifier_muerta_gunslinger_custom_slow:IsHidden() return true end
function modifier_muerta_gunslinger_custom_slow:IsPurgable() return true end
function modifier_muerta_gunslinger_custom_slow:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.speed = self.caster:GetTalentValue("modifier_muerta_gun_3", "attack")
self.move = self.caster:GetTalentValue("modifier_muerta_gun_3", "move")
if not IsServer() then return end

self.parent:EmitSound("Muerta.Gun_slow")

local effect_cast = ParticleManager:CreateParticle( "particles/muerta/muerta_attack_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(effect_cast, false, false, -1, false, false)

end



function modifier_muerta_gunslinger_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_muerta_gunslinger_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_muerta_gunslinger_custom_slow:GetModifierAttackSpeedBonus_Constant()
if self:GetParent():GetUnitName() == "npc_muerta_ogre"
or self:GetParent():GetUnitName() ==  "npc_muerta_satyr"
or self:GetParent():GetUnitName() ==  "npc_muerta_ursa"
or self:GetParent():GetUnitName() ==  "npc_muerta_centaur" then return end

return self.speed
end

function modifier_muerta_gunslinger_custom_slow:GetEffectName()
return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end


function modifier_muerta_gunslinger_custom_slow:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end




modifier_muerta_gunslinger_custom_evasion = class({})
function modifier_muerta_gunslinger_custom_evasion:IsHidden() return true end
function modifier_muerta_gunslinger_custom_evasion:IsPurgable() return false end







modifier_muerta_gunslinger_custom_illusion = class({})
function modifier_muerta_gunslinger_custom_illusion:IsHidden() return true end
function modifier_muerta_gunslinger_custom_illusion:IsPurgable() return false end

function modifier_muerta_gunslinger_custom_illusion:GetStatusEffectName()
return "particles/status_fx/status_effect_muerta_parting_shot.vpcf"
end
function modifier_muerta_gunslinger_custom_illusion:StatusEffectPriority()
return MODIFIER_PRIORITY_ILLUSION
end

function modifier_muerta_gunslinger_custom_illusion:GetEffectName()
return "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf"
end

function modifier_muerta_gunslinger_custom_illusion:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_muerta_gunslinger_custom_illusion:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.ability = self:GetAbility()

if table.hero then 
	self.hero = EntIndexToHScript(table.hero)
	self.mod = self.hero:AddNewModifier(self.hero, self.ability, "modifier_muerta_gunslinger_custom_incoming", {})
end

if table.target then 
	self.target = EntIndexToHScript(table.target)

	if (self.parent:GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D() < 1500 then 
		self.parent:SetForceAttackTarget(self.target)
	end
end

self.particle_ally_fx = ParticleManager:CreateParticle("particles/blur_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hero)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.hero, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hero:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

self:StartIntervalThink(0.1)
end


function modifier_muerta_gunslinger_custom_illusion:OnIntervalThink()
if not IsServer() then return end

if self.target == nil or self.target:IsNull() or not self.target:IsAlive() then 
	self.target = nil
	self.parent:SetForceAttackTarget(nil)
end

end


function modifier_muerta_gunslinger_custom_illusion:OnDestroy()
if not IsServer() then return end 

if self.mod and not self.mod:IsNull() then 
	self.mod:Destroy()
end

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
self.parent = self:GetParent()
self.damage_reduce = self.parent:GetTalentValue("modifier_muerta_gun_6", "damage_reduce")

self.particle_ally_fx = ParticleManager:CreateParticle("particles/blur_absorb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)
end

function modifier_muerta_gunslinger_custom_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_muerta_gunslinger_custom_incoming:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
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





modifier_muerta_gunslinger_custom_active_buff = class({})
function modifier_muerta_gunslinger_custom_active_buff:IsHidden() return true end
function modifier_muerta_gunslinger_custom_active_buff:IsPurgable() return false end

function modifier_muerta_gunslinger_custom_active_buff:GetEffectName() 
return "particles/muerta/gun_evasion.vpcf"
end



function modifier_muerta_gunslinger_custom_active_buff:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end