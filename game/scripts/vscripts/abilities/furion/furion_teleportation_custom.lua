LinkLuaModifier("modifier_furion_teleportation_custom", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_damage", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_tracker", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_legendary_cast", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_legendary", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_legendary_damage", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_shield", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_attack", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_slow", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_double_effect", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_damage_reduce", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_teleportation_custom_knock_cd", "abilities/furion/furion_teleportation_custom", LUA_MODIFIER_MOTION_NONE)


furion_teleportation_custom = class({})
		

function furion_teleportation_custom:CreateTalent()
self:ToggleAutoCast()
end


function furion_teleportation_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/nature_prophet/teleport_knock.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/sprout_hit.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/furion_teleport_start_fast.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/furion_teleport_fast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_furion/furion_arboreal_might_buff.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/furion_teleport_statuc.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/teleport_damage.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/teleport_damage_aoe.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/furion_teleport_start_fast.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/teleport_resist.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/double_attack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
PrecacheResource( "particle", "particles/nature_prophet/teleport_armor.vpcf", context )


end


function furion_teleportation_custom:GetIntrinsicModifierName()
return "modifier_furion_teleportation_custom_tracker"
end

function furion_teleportation_custom:GetManaCost(level)
if self:GetCaster():HasTalent("modifier_furion_teleport_7") then
	return 0
end
return self.BaseClass.GetManaCost(self,level)
end

function furion_teleportation_custom:GetCooldown(iLevel)
local k = 1
if self:GetCaster():HasTalent("modifier_furion_teleport_3") then 
	k = k + self:GetCaster():GetTalentValue("modifier_furion_teleport_3", "cd")/100
end 
return self.BaseClass.GetCooldown(self, iLevel)*k
end

function furion_teleportation_custom:GetBehavior()
local auto = 0
if self:GetCaster():HasTalent("modifier_furion_teleport_7") then
  auto = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + auto
end

function furion_teleportation_custom:GetCastAnimation()
if self:GetCaster():HasModifier("modifier_furion_teleportation_custom_legendary_cast") then 
	return ACT_DOTA_CAST_ABILITY_6
end 
	return ACT_DOTA_CAST_ABILITY_2
end

function furion_teleportation_custom:GetCastPoint()
local k = 1
local caster = self:GetCaster()

if caster:HasModifier("modifier_slark_essence_shift_custom_legendary_steal") then
	k = 0.35
end
if caster:HasTalent("modifier_furion_teleport_3") then 
	k = k + caster:GetTalentValue("modifier_furion_teleport_3", "cast")/100
end 
if caster:HasModifier("modifier_furion_teleportation_custom_legendary_cast") then 
	return caster:GetTalentValue("modifier_furion_teleport_7", "cast")*k
end 
return self:GetSpecialValueFor("AbilityCastPoint")*k
end

function furion_teleportation_custom:GetCastRange(vLocation, hTarget)
local caster = self:GetCaster()

if (caster:HasTalent("modifier_furion_teleport_7") and IsClient()) or caster:HasModifier("modifier_the_hunt_custom_hero") then 
	return caster:GetTalentValue("modifier_furion_teleport_7", "range", true)
end 

if IsClient() then return end
return 999999
end 

function furion_teleportation_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()
self.targetPoint = self:GetCursorPosition()

caster:AddNewModifier(caster, self, "modifier_furion_teleportation_custom", {x = self.targetPoint.x, y = self.targetPoint.y, duration = self:GetCastPoint()})
return true
end

function furion_teleportation_custom:OnAbilityPhaseInterrupted()
self:GetCaster():RemoveModifierByName("modifier_furion_teleportation_custom")
end

function furion_teleportation_custom:ProcStun()

local caster = self:GetCaster()
local ability = self
local radius = caster:GetTalentValue("modifier_furion_teleport_5", "radius")
local stun = caster:GetTalentValue("modifier_furion_teleport_5", "stun")

caster:EmitSound("Furion.Teleport_cast")
caster:EmitSound("Furion.Teleport_cast2")

local particle_knock = ParticleManager:CreateParticle("particles/nature_prophet/teleport_knock.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle_knock, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_knock, 2, Vector(radius, 0, 0))
ParticleManager:ReleaseParticleIndex(particle_knock)

for _,target in pairs(self:GetCaster():FindTargets(radius)) do 

	local dir = (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()
	local point = self:GetCaster():GetAbsOrigin() + dir*radius

	local distance = (point - target:GetAbsOrigin()):Length2D()

	distance = math.max(50, distance)
	point = target:GetAbsOrigin() + dir*distance

	local hit_effect = ParticleManager:CreateParticle("particles/nature_prophet/sprout_hit.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), false) 
	ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT, "attach_hitloc", target:GetAbsOrigin(), false) 
	ParticleManager:ReleaseParticleIndex(hit_effect)

	local arc = target:AddNewModifier( caster, ability,  "modifier_generic_arc",  
	{
	  target_x = point.x,
	  target_y = point.y,
	  distance = distance,
	  duration = 0.25,
	  height = 0,
	  fix_end = false,
	  isStun = true,
	  activity = ACT_DOTA_FLAIL,
	})

	if arc and not arc:IsNull() then 

		arc:SetEndCallback(function()
			if target and not target:IsNull() then 
				target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun*(1 - target:GetStatusResistance())})
			end
		end)
	end 

end 

end




function furion_teleportation_custom:OnSpellStart()

local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("buff_duration")

if caster:HasTalent("modifier_furion_teleport_7") and caster:HasModifier("modifier_furion_teleportation_custom_legendary_cast") then 
	caster:RemoveModifierByName("modifier_furion_teleportation_custom_legendary")
	caster:AddNewModifier(caster, self, "modifier_furion_teleportation_custom_legendary", {duration = caster:GetTalentValue("modifier_furion_teleport_7", "timer")})
else 
	caster:AddNewModifier(caster, self, "modifier_can_not_push", {duration = self:GetSpecialValueFor("tower_duration")})
end

caster:RemoveModifierByName("modifier_furion_teleportation_custom_shield")
caster:AddNewModifier(caster, self, "modifier_furion_teleportation_custom_shield", {duration = duration})

EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Furion.Teleport_Disappear", caster)

FindClearSpaceForUnit(caster, self.targetPoint, true)
ProjectileManager:ProjectileDodge(caster)

EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Hero_Furion.Teleport_Appear", caster)

end





modifier_furion_teleportation_custom = class({})
function modifier_furion_teleportation_custom:IsHidden() return false end
function modifier_furion_teleportation_custom:IsPurgable() return false end

function modifier_furion_teleportation_custom:OnCreated(table)
if not IsServer() then return end
 
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.point = GetGroundPosition(Vector(table.x, table.y , 0), nil)

self.teleport_center = CreateUnitByName("npc_dota_companion", self.point, false, nil, nil, 0)
self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_phased", {})
self.teleport_center:AddNewModifier(self.teleport_center, nil, "modifier_invulnerable", {})
self.teleport_center:SetAbsOrigin(self.point)

self.proced = false

if self.caster:HasTalent("modifier_furion_teleport_5") and not self.caster:HasModifier("modifier_furion_teleportation_custom_knock_cd") then 
	self.proced = true
	self.ability:ProcStun()
end

self.particle_fx = ParticleManager:CreateParticle("particles/nature_prophet/furion_teleport_start_fast.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.particle_fx, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle_fx, 2, Vector(0, 0, 0))
ParticleManager:SetParticleControl(self.particle_fx, 3, Vector(self:GetRemainingTime(), 0, 0))
self:AddParticle( self.particle_fx, false, false, -1, false, false )


self.end_particle_fx = ParticleManager:CreateParticle("particles/nature_prophet/furion_teleport_fast.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.end_particle_fx, 1, self.point)
ParticleManager:SetParticleControl(self.end_particle_fx, 2, Vector(0, 0, 0))
ParticleManager:SetParticleControl(self.end_particle_fx, 3, Vector(self:GetRemainingTime(), 0, 0))
self:AddParticle( self.end_particle_fx, false, false, -1, false, false )

self.vision_radius = 10

AddFOWViewer(self:GetCaster():GetTeamNumber(), self.point, self.vision_radius, 0.2, false)
self.sound = false

self:StartIntervalThink(0.1)
end 




function modifier_furion_teleportation_custom:OnIntervalThink()
if not IsServer() then return end 

AddFOWViewer(self:GetCaster():GetTeamNumber(), self.point, self.vision_radius, 0.2, false)

if self.sound == false then 
	self.sound = true 

	self:GetCaster():EmitSound("Hero_Furion.Teleport_Grow")

	if self.teleport_center and not self.teleport_center:IsNull() then
		self.teleport_center:EmitSound("Hero_Furion.Teleport_Grow")
	end 
end 

end 




function modifier_furion_teleportation_custom:OnDestroy()
if not IsServer() then return end


if self.teleport_center and not self.teleport_center:IsNull() then 
	self.teleport_center:StopSound("Hero_Furion.Teleport_Grow")
	UTIL_Remove(self.teleport_center)
end

if self:GetRemainingTime() < 0.03 then 

	if self.particle_fx then
		ParticleManager:SetParticleControl(self.particle_fx, 2, Vector(1, 0, 0))
	end

	if self.end_particle_fx then
		ParticleManager:SetParticleControl(self.end_particle_fx, 2, Vector(1, 0, 0))
	end
else

	if self.proced == true then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_furion_teleportation_custom_knock_cd", {duration = self:GetCaster():GetTalentValue("modifier_furion_teleport_5", "cd_stun")})
	end 
end  

self:GetCaster():Stop()
self:GetCaster():StopSound("Hero_Furion.Teleport_Grow")
end 





modifier_furion_teleportation_custom_damage = class({})
function modifier_furion_teleportation_custom_damage:IsHidden() return false end
function modifier_furion_teleportation_custom_damage:IsPurgable() return false end
function modifier_furion_teleportation_custom_damage:GetTexture() return "buffs/teleport_double" end
function modifier_furion_teleportation_custom_damage:OnCreated()
self:SetStackCount(self:GetCaster():GetTalentValue("modifier_furion_teleport_4", "attacks"))
end 

function modifier_furion_teleportation_custom_damage:GetEffectName()
return "particles/units/heroes/hero_furion/furion_arboreal_might_buff.vpcf"
end






modifier_furion_teleportation_custom_tracker = class({})
function modifier_furion_teleportation_custom_tracker:IsHidden() return true end
function modifier_furion_teleportation_custom_tracker:IsPurgable() return false end


function modifier_furion_teleportation_custom_tracker:OnCreated()
self.parent = self:GetParent()

self.legendary_cd = self.parent:GetTalentValue("modifier_furion_teleport_7", "cd", true)
self.legendary_dist = self.parent:GetTalentValue("modifier_furion_teleport_7", "range", true)
self.legendary_damage = self.parent:GetTalentValue("modifier_furion_teleport_7", "damage", true)/100
self.legendary_creeps = self.parent:GetTalentValue("modifier_furion_teleport_7", "creeps", true)
self.legendary_ulti = self.parent:GetTalentValue("modifier_furion_teleport_7", "creeps_ulti", true)

self.attack_delay = self.parent:GetTalentValue("modifier_furion_teleport_4", "delay", true)
self.slow_duration = self.parent:GetTalentValue("modifier_furion_teleport_4", "duration", true)
self.double_duration = self.parent:GetTalentValue("modifier_furion_teleport_4", "effect_duration", true)

if self.parent:IsRealHero() then 
	self.parent:AddRecordDestroyEvent(self)
	self.parent:AddDamageEvent_out(self)
  self.parent:AddSpellEvent(self)
  self.parent:AddAttackStartEvent_out(self)
  self.parent:AddOrderEvent(self)
end

self.records = {}
end

function modifier_furion_teleportation_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}
end

function modifier_furion_teleportation_custom_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_furion_teleport_4") then return end
return self.parent:GetTalentValue("modifier_furion_teleport_4", "range")
end

function modifier_furion_teleportation_custom_tracker:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_furion_teleport_3") then return end
return self.parent:GetTalentValue("modifier_furion_teleport_3", "move")
end





function modifier_furion_teleportation_custom_tracker:OrderEvent(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_furion_teleport_7") then return end
if params.order_type ~= DOTA_UNIT_ORDER_CAST_POSITION then return end
if not params.ability then return end
if params.ability ~= self:GetAbility() then return end 

local dist = (params.pos - self.parent:GetAbsOrigin()):Length2D()

if dist <= self.legendary_dist + self.parent:GetCastRangeBonus() then 
	self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_furion_teleportation_custom_legendary_cast", {})
else 
	self.parent:RemoveModifierByName("modifier_furion_teleportation_custom_legendary_cast")
end 

end 


function modifier_furion_teleportation_custom_tracker:AttackStartEvent_out(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end 

if self.parent:HasModifier("modifier_furion_teleportation_custom_double_effect") then 
	self.records[params.record] = true
end 

local mod = self.parent:FindModifierByName("modifier_furion_teleportation_custom_damage")
if not self.parent:HasTalent("modifier_furion_teleport_4") then return end
if not mod then return end
if params.no_attack_cooldown then return end 

mod:DecrementStackCount()
if mod:GetStackCount() == 0 then 
	mod:Destroy()
end

self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_furion_teleportation_custom_attack", {target = params.target:entindex(), duration = self.attack_delay})
end 


function modifier_furion_teleportation_custom_tracker:RecordDestroyEvent(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 

if self.records[params.record] then 
	self.records[params.record] = nil
end 

end

function modifier_furion_teleportation_custom_tracker:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end 

if self.records[params.record] then 
	params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_furion_teleportation_custom_slow", {duration = (1 - params.target:GetStatusResistance())*self.slow_duration})
end 

end


function modifier_furion_teleportation_custom_tracker:SpellEvent(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_furion_teleport_4") then return end
if params.unit ~= self.parent then return end
if params.ability:IsItem() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_furion_teleportation_custom_damage", {duration = self.double_duration})
end




function modifier_furion_teleportation_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end 
if not params.attacker then return end 
if params.unit:IsIllusion() then return end
if params.damage < 0 then return end

local attacker = params.attacker
if attacker.owner then 
	attacker = attacker.owner
end 

if self.parent ~= attacker then return end 
if not params.unit:IsUnit() then return end

local shield = self.parent:FindModifierByName("modifier_furion_teleportation_custom_shield")

if shield and self.parent:HasTalent("modifier_furion_teleport_2") and (attacker:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() < 1500 then 
	local shield_k = shield.heal
	if params.unit:IsCreep() then 
	  shield_k = shield_k/shield.heal_creeps
	end 
	shield:SetStackCount(math.min(shield.max_shield, shield:GetStackCount() + shield_k*params.damage))
end


local mod = self.parent:FindModifierByName("modifier_furion_teleportation_custom_legendary")
if not mod then return end

local ability = self.parent:FindAbilityByName("furion_wrath_of_nature_custom")

local damage = params.damage*self.legendary_damage
if params.unit:IsCreep() then 

	if ability and params.inflictor and params.inflictor == ability then 
		damage = damage/self.legendary_ulti
	else 
		damage = damage / self.legendary_creeps
	end 
end 

mod:SetStackCount(mod:GetStackCount() + damage)
end 




modifier_furion_teleportation_custom_legendary_cast = class({})
function modifier_furion_teleportation_custom_legendary_cast:IsHidden() return true end
function modifier_furion_teleportation_custom_legendary_cast:IsPurgable() return false end





modifier_furion_teleportation_custom_legendary = class({})
function modifier_furion_teleportation_custom_legendary:IsHidden() return true end
function modifier_furion_teleportation_custom_legendary:IsPurgable() return false end
function modifier_furion_teleportation_custom_legendary:OnCreated()

self.parent = self:GetParent()

self.interval = 0.03
if not IsServer() then return end 

self.point = self:GetParent():GetAbsOrigin()

self.time = self:GetRemainingTime()

self.static_fx = ParticleManager:CreateParticle("particles/nature_prophet/furion_teleport_statuc.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.static_fx, 0, self.point)
ParticleManager:SetParticleControl(self.static_fx, 1, self.point)
ParticleManager:SetParticleControl(self.static_fx, 2, Vector(0, 0, 0))
ParticleManager:SetParticleControl(self.static_fx, 3, Vector(self:GetRemainingTime(), 0, 0))
self:AddParticle( self.static_fx, false, false, -1, false, false )

self.radius = self:GetCaster():GetTalentValue("modifier_furion_teleport_7", "radius")

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 



function modifier_furion_teleportation_custom_legendary:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self.parent:GetTeamNumber(), self.point, 300, self.interval*2, false)

self.parent:UpdateUIshort({max_time = self.time, time = self:GetRemainingTime(), stack = self:GetStackCount(), style = "FurionTeleport", priority = 1})

local remaining = self:GetRemainingTime()
local seconds = math.ceil( remaining )
local isHalf = (seconds-remaining)>=0.5

if isHalf then 
	seconds = seconds-1 
end

if self.half~=isHalf then
	self.half = isHalf
	local mid = 1

	if isHalf then 
		mid = 8 
	end

	local len = 2

	if seconds<1 then
		len = 1 
		if not isHalf then 
			return 
		end 
	end

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, seconds, mid ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( len, 0, 0 ) )
end

end



function modifier_furion_teleportation_custom_legendary:OnDestroy()
if not IsServer() then return end 

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "FurionTeleport", priority = 1})

if self:GetRemainingTime() > 0.1 then return end

if self:GetStackCount() ~= 0 then 

	EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Hero_Furion.CurseOfTheForest.Cast", self.parent)
	AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), self.radius, 3, false)

	for _, enemy in pairs(FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)) do

		enemy:AddNewModifier(self.parent, self:GetAbility(), "modifier_furion_teleportation_custom_legendary_damage", {duration = 0.15, damage = self:GetStackCount()})

		local wrath_particle = ParticleManager:CreateParticle("particles/nature_prophet/teleport_damage.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControlEnt(wrath_particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(wrath_particle, 1, self.parent:GetAbsOrigin() + Vector(0,0,100))
		ParticleManager:SetParticleControlEnt(wrath_particle, 4, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(wrath_particle)
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/nature_prophet/teleport_damage_aoe.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

if self:GetAbility():GetAutoCastState() == false then return end  

self.particle_fx = ParticleManager:CreateParticle("particles/nature_prophet/furion_teleport_start_fast.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.particle_fx, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle_fx, 2, Vector(1, 0, 0))
ParticleManager:SetParticleControl(self.particle_fx, 3, Vector(self:GetRemainingTime(), 0, 0))
ParticleManager:DestroyParticle(self.particle_fx, false)
ParticleManager:ReleaseParticleIndex(self.particle_fx)

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Hero_Furion.Teleport_Disappear", self.parent)


FindClearSpaceForUnit(self.parent, self.point, true)

ParticleManager:SetParticleControl(self.static_fx , 2, Vector(1, 0, 0))

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Hero_Furion.Teleport_Appear", self.parent)
end 



modifier_furion_teleportation_custom_legendary_damage = class({})
function modifier_furion_teleportation_custom_legendary_damage:IsHidden() return true end
function modifier_furion_teleportation_custom_legendary_damage:IsPurgable() return false end
function modifier_furion_teleportation_custom_legendary_damage:OnCreated(table)
if not IsServer() then return end 

self.damage = table.damage
end 


function modifier_furion_teleportation_custom_legendary_damage:OnDestroy()
if not IsServer() then return end 
if not self:GetParent() or self:GetParent():IsNull() or not self:GetParent():IsAlive() then return end
local damageTable = {victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()}

local real_damage = DoDamage(damageTable, "modifier_furion_teleport_7")
self:GetParent():SendNumber(6, real_damage)

if self:GetParent():IsCreep() then 
	self:GetParent():EmitSound("Furion.Teleport_damage_creeps")
else 
	self:GetParent():EmitSound("Furion.Teleport_damage")
end 

end





modifier_furion_teleportation_custom_shield = class({})
function modifier_furion_teleportation_custom_shield:IsHidden() return false end
function modifier_furion_teleportation_custom_shield:IsPurgable() return false end
function modifier_furion_teleportation_custom_shield:OnCreated(table)

self.ability = self:GetAbility()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.max_shield = self.ability:GetSpecialValueFor("shield") + self.caster:GetTalentValue("modifier_furion_teleport_2", "shield")*self:GetCaster():GetIntellect(true)
self.status = self.caster:GetTalentValue("modifier_furion_teleport_6", "status")

if not IsServer() then return end

self.heal = self.caster:GetTalentValue("modifier_furion_teleport_2", "heal")/100
self.heal_creeps = self.caster:GetTalentValue("modifier_furion_teleport_2", "creeps", true)


self.RemoveForDuel = true
self:SetStackCount(self.max_shield)
end


function modifier_furion_teleportation_custom_shield:OnIntervalThink()
self:OnCreated()
self:StartIntervalThink(-1)
end 

function modifier_furion_teleportation_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,

}
end

function modifier_furion_teleportation_custom_shield:GetEffectName()
return "particles/nature_prophet/teleport_resist.vpcf"
end

function modifier_furion_teleportation_custom_shield:GetModifierStatusResistanceStacking() 
if not self.caster:HasTalent("modifier_furion_teleport_6") then return end
return self.status
end

function modifier_furion_teleportation_custom_shield:OnDestroy()
if not IsServer() then return end

if self.caster:HasTalent("modifier_furion_teleport_5") then 
	self.ability:ProcStun()
end

if self.caster:HasTalent("modifier_furion_teleport_6") then 
	self.caster:AddNewModifier(self.caster, self.ability, "modifier_furion_teleportation_custom_damage_reduce", {duration = self.caster:GetTalentValue("modifier_furion_teleport_6", "duration")})
end

end



function modifier_furion_teleportation_custom_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
      return self:GetStackCount()
    end 
end

if not IsServer() then return end
if self.caster == params.attacker then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end












modifier_furion_teleportation_custom_attack = class({})
function modifier_furion_teleportation_custom_attack:IsHidden() return true end
function modifier_furion_teleportation_custom_attack:IsPurgable() return false end
function modifier_furion_teleportation_custom_attack:RemoveOnDeath() return false end
function modifier_furion_teleportation_custom_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_furion_teleportation_custom_attack:OnCreated(table)
if not IsServer() then return end 
self.target = EntIndexToHScript(table.target)
end 

function modifier_furion_teleportation_custom_attack:OnDestroy()
if not IsServer() then return end
if not self.target then return end
if self.target:IsNull() then return end 

self:GetCaster():EmitSound("Furion.Teleport_double")
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_furion_teleportation_custom_double_effect", {duration = FrameTime()})
self:GetCaster():PerformAttack(self.target, true, true, true, true, true, false, false)
self:GetCaster():RemoveModifierByName("modifier_furion_teleportation_custom_double_effect")
end 







modifier_furion_teleportation_custom_slow = class({})
function modifier_furion_teleportation_custom_slow:IsHidden() return false end
function modifier_furion_teleportation_custom_slow:IsPurgable() return true end
function modifier_furion_teleportation_custom_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_furion_teleport_4", "slow")
if not IsServer() then return end 

self.particle_peffect = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

self:GetParent():EmitSound("Furion.Teleport_slow")
end 

function modifier_furion_teleportation_custom_slow:OnRefresh(table)
if not IsServer() then return end 
self:GetParent():EmitSound("Furion.Teleport_slow")
end 

function modifier_furion_teleportation_custom_slow:DeclareFunctions()
local funcs = {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}

return funcs
end

function modifier_furion_teleportation_custom_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end



modifier_furion_teleportation_custom_double_effect = class({})
function modifier_furion_teleportation_custom_double_effect:IsHidden() return true end
function modifier_furion_teleportation_custom_double_effect:IsPurgable() return false end
function modifier_furion_teleportation_custom_double_effect:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROJECTILE_NAME
}
end

function modifier_furion_teleportation_custom_double_effect:GetModifierProjectileName()
    return "particles/nature_prophet/double_attack.vpcf"
end


function modifier_furion_teleportation_custom_double_effect:GetPriority()
return 9999999
end










modifier_furion_teleportation_custom_damage_reduce = class({})
function modifier_furion_teleportation_custom_damage_reduce:IsHidden() return true end
function modifier_furion_teleportation_custom_damage_reduce:IsPurgable() return false end
function modifier_furion_teleportation_custom_damage_reduce:OnCreated()

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_furion_teleport_6", "damage_reduce")
self.heal = self:GetCaster():GetTalentValue("modifier_furion_teleport_6", "heal")/self:GetRemainingTime()

if not IsServer() then return end 

self:GetCaster():EmitSound("Furion.Teleport_heal")
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( particle )

self.effect = ParticleManager:CreateParticle( "particles/nature_prophet/teleport_armor.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt(self.effect, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
ParticleManager:SetParticleControlEnt(self.effect, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
self:AddParticle(self.effect,false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(1)
end


function modifier_furion_teleportation_custom_damage_reduce:OnIntervalThink()
if not IsServer() then return end 
self:GetCaster():SendNumber(10, self.heal*self:GetCaster():GetMaxHealth()/100)
end 

function modifier_furion_teleportation_custom_damage_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end


function modifier_furion_teleportation_custom_damage_reduce:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end

function modifier_furion_teleportation_custom_damage_reduce:GetModifierHealthRegenPercentage()
return self.heal
end









modifier_furion_teleportation_custom_knock_cd = class({})
function modifier_furion_teleportation_custom_knock_cd:IsHidden() return false end
function modifier_furion_teleportation_custom_knock_cd:IsPurgable() return false end
function modifier_furion_teleportation_custom_knock_cd:GetTexture() return "buffs/teleport_knock" end
function modifier_furion_teleportation_custom_knock_cd:IsDebuff() return true end
function modifier_furion_teleportation_custom_knock_cd:RemoveOnDeath() return false end
function modifier_furion_teleportation_custom_knock_cd:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true
end