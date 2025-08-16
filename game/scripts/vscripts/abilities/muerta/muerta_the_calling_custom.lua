LinkLuaModifier( "modifier_muerta_the_calling_custom", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_thinker", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_muerta_the_calling_custom_debuff", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_muerta_the_calling_custom_damage", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_muerta_the_calling_caster", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_root", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_root_cd", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_scepter", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_tracker", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_heal_reduce", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_resist", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muerta_the_calling_custom_tower_damage", "abilities/muerta/muerta_the_calling_custom", LUA_MODIFIER_MOTION_NONE )


muerta_the_calling_custom = class({})


function muerta_the_calling_custom:CreateTalent(name)

local caster = self:GetCaster()

if not caster:FindAbilityByName("muerta_the_calling_custom_legendary") then return end
caster:FindAbilityByName("muerta_the_calling_custom_legendary"):SetHidden(false)
end



function muerta_the_calling_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/econ/events/ti7/blink_dagger_start_ti7.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_calling_impact.vpcf", context )
PrecacheResource( "particle", "particles/muerta/calling_aoe.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_calling_aoe.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_calling.vpcf", context )
PrecacheResource( "particle", "particles/items_fx/force_staff.vpcf", context )
PrecacheResource( "particle", "particles/muerta/calling_silence.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_calling_target.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_calling_debuff_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/muerta/calling_hero.vpcf", context )
PrecacheResource( "particle", "particles/muerta_calling_caster_start_2.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_calling_caster_end.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_calling_caster_start.vpcf", context )
PrecacheResource( "particle", "particles/muerta/calling_root.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_calling_caster_start.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/ti7/blink_dagger_end_ti7.vpcf", context )
PrecacheResource( "particle", "particles/muerta/muerta_calling_caster_end.vpcf", context )
PrecacheResource( "particle", "particles/muerta/resist_stackb.vpcf", context )

end

function muerta_the_calling_custom:OnInventoryContentsChanged()
if self:GetCaster():HasScepter() and not self.scepter_init then
	self.scepter_init = true
	self:ToggleAutoCast()
end

end 



function muerta_the_calling_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_muerta_the_calling_custom_tracker"
end


function muerta_the_calling_custom:GetBehavior()
if self:GetCaster():HasScepter() then 
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
else 
	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end

end 




function muerta_the_calling_custom:GetCastRange(location, target)
local bonus = 0 
if self:GetCaster():HasScepter() then 
	bonus = self:GetSpecialValueFor("scepter_range")
end 
return self.BaseClass.GetCastRange(self, location, target) + bonus
end


function muerta_the_calling_custom:GetAOERadius()
if self:GetCaster():HasTalent("modifier_muerta_calling_7") then 
	return self:GetCaster():GetTalentValue("modifier_muerta_calling_7", "big_radius")
end
return
end



function muerta_the_calling_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasScepter() then  
  upgrade_cooldown = self:GetSpecialValueFor("scepter_cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end



function muerta_the_calling_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()

local point = self:GetCursorPosition()
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_muerta_calling_5", "duration")

local radius = self:GetSpecialValueFor( "radius" )

if caster:HasScepter() and self:GetAutoCastState() == true then 
	local old_pos = caster:GetAbsOrigin() 
	caster:EmitSound("Muerta.Calling_scepter_start")
	caster:AddNewModifier(caster, self, "modifier_muerta_the_calling_custom_scepter", {duration = 0.1})
	local effect = ParticleManager:CreateParticle("particles/econ/events/ti7/blink_dagger_start_ti7.vpcf", PATTACH_WORLDORIGIN, nil)

	ParticleManager:SetParticleControl(effect, 0, old_pos)
	ProjectileManager:ProjectileDodge( caster )
	caster:SetAbsOrigin(point)
	FindClearSpaceForUnit(caster, point, false)
end


caster:AddNewModifier(caster, self, 'modifier_muerta_the_calling_custom_tower_damage', {duration = duration})

caster.calling_thinker = CreateModifierThinker( caster, self, "modifier_muerta_the_calling_custom", { duration = duration }, point, caster:GetTeamNumber(), false )

if caster:HasTalent("modifier_muerta_calling_7") then 
	radius = caster:GetTalentValue("modifier_muerta_calling_7", "big_radius")
end


EmitSoundOnLocationWithCaster(point, "Hero_Muerta.Revenants.Cast", caster)
end




function muerta_the_calling_custom:ProcRoot(target)
if not IsServer() then return end
local caster = self:GetCaster()

if not caster:HasTalent("modifier_muerta_calling_5") then return end
if target:GetTeamNumber() == caster:GetTeamNumber() then return end
if target:HasModifier("modifier_muerta_dead_shot_custom_legendary_target") or target:HasModifier("modifier_muerta_dead_shot_custom_fear") then return end

target:AddNewModifier(caster, self, "modifier_muerta_the_calling_custom_root", {duration = caster:GetTalentValue("modifier_muerta_calling_5", "root")*(1 - target:GetStatusResistance())})
target:AddNewModifier(caster, self, "modifier_muerta_the_calling_custom_root_cd", {duration = caster:GetTalentValue("modifier_muerta_calling_5", "cd") - FrameTime()*2})
end


function muerta_the_calling_custom:GetDamage()
return self:GetSpecialValueFor("damage") + self:GetCaster():GetTalentValue("modifier_muerta_calling_1", "damage")
end



function muerta_the_calling_custom:DealDamage(target, mini)
if not IsServer() then return end

local caster = self:GetCaster()
local damage = self:GetDamage()
local duration = self:GetSpecialValueFor("silence_duration")

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_calling_impact.vpcf", PATTACH_CUSTOMORIGIN, target)
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

local ability_damage = nil

if mini then 
	ability_damage = "modifier_muerta_calling_6"
	duration = caster:GetTalentValue("modifier_muerta_calling_6", "silence")
else 
	if target:IsCreep() then 
		duration = self:GetSpecialValueFor("silence_creeps")
	end
end 

if caster:HasTalent("modifier_muerta_calling_1") then 
	target:AddNewModifier(caster, self, "modifier_muerta_the_calling_custom_heal_reduce", {duration = caster:GetTalentValue("modifier_muerta_calling_1", "duration")})
end 

if caster:HasTalent("modifier_muerta_calling_4") then 
	target:AddNewModifier(caster, self, "modifier_muerta_the_calling_custom_resist", {duration = caster:GetTalentValue("modifier_muerta_calling_4", "duration")})
end 

DoDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self}, ability_damage)

target:AddNewModifier(caster, self, "modifier_generic_silence", {duration = duration * (1-target:GetStatusResistance())})

local sound_cast = "Hero_Muerta.Revenants.Damage.Hero"
if not target:IsHero() then
	sound_cast = "Hero_Muerta.Revenants.Damage.Creep"
end

target:EmitSound(sound_cast)
target:EmitSound("Hero_Muerta.Revenants.Silence")
end







modifier_muerta_the_calling_custom = class({})

function modifier_muerta_the_calling_custom:IsHidden() return true end
function modifier_muerta_the_calling_custom:IsPurgable() return false end

function modifier_muerta_the_calling_custom:OnCreated()
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.ability:SetActivated(false)
self.ability:EndCooldown()


if self.caster:HasTalent("modifier_muerta_calling_6") then 

	local ability = self.ability
	local ability_target = self.caster:FindAbilityByName("muerta_the_calling_custom_target")


	if ability_target then 

		if ability_target:IsHidden() then 
			self.caster:SwapAbilities(ability:GetName(), ability_target:GetName(), false, true)
		end

	end
end

self.center = self.parent:GetAbsOrigin()

self.parent:EmitSound("Hero_Muerta.Revenants")
self.parent:EmitSound("Hero_Muerta.Revenants.Layer")

self.hit_radius = self.ability:GetSpecialValueFor( "hit_radius" )
self.radius = self.ability:GetSpecialValueFor( "radius" )
self.accel = self.ability:GetSpecialValueFor( "acceleration" )
self.init_speed = self.ability:GetSpecialValueFor( "speed_initial" )
self.max_speed = self.ability:GetSpecialValueFor( "speed_max" )

self.aura_radius = self.radius

self.radius_2 = 0

if self.caster:HasTalent("modifier_muerta_calling_7") then 

	self.radius_2 = self.caster:GetTalentValue("modifier_muerta_calling_7", "big_radius")
	self.radius = self.caster:GetTalentValue("modifier_muerta_calling_7", "small_radius")
	self.num_revenants_2 = self.caster:GetTalentValue("modifier_muerta_calling_7", "count")
	self.aura_radius = self.radius_2

	local particle = ParticleManager:CreateParticle("particles/muerta/calling_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(self.radius_2, self.radius_2, self.radius_2))
	ParticleManager:SetParticleControl(particle, 2, Vector(self:GetDuration(), self:GetDuration(), self:GetDuration()))
	self:AddParticle(particle, false, false, -1, false, false)
else 

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_calling_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, self.radius, self.radius))
	ParticleManager:SetParticleControl(particle, 2, Vector(self:GetDuration(), self:GetDuration(), self:GetDuration()))
	self:AddParticle(particle, false, false, -1, false, false)
end


self.wisps = {}
self.wisps_data = {}
self.num_revenants = 4


for i = 1,self.num_revenants do

	local origin = self.parent:GetAbsOrigin()
	local angel = (math.pi/2 + 2*math.pi/self.num_revenants * i)
	local abs = GetGroundPosition(origin + Vector( math.cos( angel), math.sin( angel ), 0 ) * (self.radius - self.hit_radius), nil)
	abs.z = abs.z + 100

	self.wisps[i] = CreateUnitByName( "npc_dota_companion", abs, true, self.caster, self.caster:GetOwner(), self.caster:GetTeamNumber())
	self.wisps[i]:AddNewModifier(self.caster, self.ability, "modifier_muerta_the_calling_custom_thinker", {})
	self.wisps_data[i] = {}

	self.wisps_data[i].radius = self.radius
	self.wisps_data[i].angel = angel
	self.wisps_data[i].speed_k = 1
	self.wisps_data[i].speed = self.init_speed

end

if self.caster:HasTalent("modifier_muerta_calling_7") then 

	local number = #self.wisps
	local count = 0

	for i =  number + 1,number + self.num_revenants_2 do

		count = count + 1
		local origin = self.parent:GetAbsOrigin()
		local angel = (math.pi/2 + 2*math.pi/self.num_revenants_2 * count)
		local abs = GetGroundPosition(origin + Vector( math.cos( angel), math.sin( angel ), 0 ) * (self.radius_2 - self.hit_radius), nil)
		abs.z = abs.z + 100

		self.wisps[i] = CreateUnitByName( "npc_dota_companion", abs, true, self.caster, self.caster:GetOwner(), self.caster:GetTeamNumber())
		self.wisps[i]:AddNewModifier(self.caster, self.ability, "modifier_muerta_the_calling_custom_thinker", {})

		self.wisps_data[i] = {}

		self.wisps_data[i].radius = self.radius_2
		self.wisps_data[i].angel = angel
		self.wisps_data[i].speed_k = -1
		self.wisps_data[i].speed = self.init_speed
	end
end


self.dt = 0.01

self:OnIntervalThink()
self:StartIntervalThink(self.dt)
end

function modifier_muerta_the_calling_custom:OnIntervalThink()
if not IsServer() then return end

for i = 1, #self.wisps do
	if self.wisps[i] and not self.wisps[i]:IsNull() and self.wisps_data[i] then
		local current_angle = self.wisps_data[i].angel
		local radius = self.wisps_data[i].radius
		local speed_k = self.wisps_data[i].speed_k
		local current_speed = self.wisps_data[i].speed

		current_speed = math.min( current_speed + self.accel * self.dt, self.max_speed )

		if self.caster:HasModifier("modifier_muerta_the_calling_caster") and self.caster:HasModifier("modifier_muerta_the_calling_custom_debuff") then 
			current_speed = current_speed*(self.caster:GetTalentValue("modifier_muerta_calling_7", "speed")/100 + 1)
		end

		current_angle = current_angle + current_speed * self.dt * speed_k
		
		if current_angle > 2*math.pi then
			current_angle = current_angle - 2*math.pi
		end

		local position = self:GetPosition(current_angle, radius - self.hit_radius)

		self.wisps[i]:SetAbsOrigin(position)

		self.wisps_data[i].angel = current_angle
		self.wisps_data[i].speed = current_speed
	end
end

end


function modifier_muerta_the_calling_custom:GetPosition(current_angle, distance)
local abs = GetGroundPosition(self.center + Vector( math.cos( current_angle ), math.sin( current_angle ), 0 ) * distance, nil)
abs.z = abs.z + 100

return abs
end



function modifier_muerta_the_calling_custom:OnDestroy()
if not IsServer() then return end

self.caster.calling_thinker = nil

self.ability:SetActivated(true)
self.ability:UseResources(false, false, false, true)

if self.caster:HasTalent("modifier_muerta_calling_6") then 

	local ability = self.ability
	local ability_target = self.caster:FindAbilityByName("muerta_the_calling_custom_target")

	if ability then 
		if ability:IsHidden() then 
			self.caster:SwapAbilities(ability:GetName(), ability_target:GetName(), true, false)
		end
	end
end

self.parent:StopSound("Hero_Muerta.Revenants")

for i = 1,#self.wisps do 
	if self.wisps[i] and not self.wisps[i]:IsNull() then 
		UTIL_Remove(self.wisps[i])
	end
end

end



function modifier_muerta_the_calling_custom:IsAura()
    return true
end

function modifier_muerta_the_calling_custom:GetModifierAura()
    return "modifier_muerta_the_calling_custom_debuff"
end

function modifier_muerta_the_calling_custom:GetAuraRadius()
    return self.aura_radius
end

function modifier_muerta_the_calling_custom:GetAuraDuration()
    return 0.1
end

function modifier_muerta_the_calling_custom:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_muerta_the_calling_custom:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_muerta_the_calling_custom:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end


function modifier_muerta_the_calling_custom:GetAuraEntityReject(hEntity)

if self.parent:GetTeamNumber() == hEntity:GetTeamNumber() and self.caster ~= hEntity then 
	return true
end

if (hEntity:IsInvulnerable() or hEntity:IsOutOfGame()) and self.caster ~= hEntity then 
	return true
end

end





modifier_muerta_the_calling_custom_thinker = class({})

function modifier_muerta_the_calling_custom_thinker:IsHidden() return true end
function modifier_muerta_the_calling_custom_thinker:IsPurgable() return false end
function modifier_muerta_the_calling_custom_thinker:RemoveOnDeath() return false end

function modifier_muerta_the_calling_custom_thinker:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.ability =  self:GetAbility()
self.caster = self:GetCaster()

self.parent:SetDayTimeVisionRange(400)
self.parent:SetNightTimeVisionRange(400)

self.target_point = nil
self.hit_radius = self.ability:GetSpecialValueFor( "hit_radius" )

self.damage_dealt = false

local particle_name = "particles/units/heroes/hero_muerta/muerta_calling.vpcf"
local time = 0

if table.target_speed then 
	self:SetStackCount(1)

	self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + Vector(0,0,100))

	self.target_speed = table.target_speed
	self.target_point = GetGroundPosition(Vector(table.x, table.y, 0), nil) + Vector(0,0,100)

	self.target_distance = (self.target_point - self.parent:GetAbsOrigin()):Length2D()

	self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	self:AddParticle(self.pfx, false, false, -1, false, false)

	time = self.target_distance/self.target_speed

	particle_name = "particles/muerta/calling_silence.vpcf"

	self.dt = 0.01
	self:StartIntervalThink(self.dt)
end

self.particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControl(self.particle, 1, Vector(120, 120, 120))
ParticleManager:SetParticleControl(self.particle, 5, Vector(time, 0, 0))
self:AddParticle(self.particle, false, false, -1, false, false)
end




function modifier_muerta_the_calling_custom_thinker:OnIntervalThink()
if not IsServer() then return end
if not self.parent or self.parent:IsNull() then return end

if (self.target_point - self.parent:GetAbsOrigin()):Length2D() <= 10 and self.damage_dealt == false then 

	self.damage_dealt = true

	self.parent:EmitSound("Muerta.Calling_target_end")
	self.parent:EmitSound("Hero_Muerta.Revenants.Damage.Hero")

	local knock = self.caster:GetTalentValue("modifier_muerta_calling_6", "knock")
	local aoe = self.caster:GetTalentValue("modifier_muerta_calling_6", "aoe")

	local effect_cast = ParticleManager:CreateParticle( "particles/muerta/muerta_calling_target.vpcf", PATTACH_WORLDORIGIN,  nil)
	ParticleManager:SetParticleControl( effect_cast, 0, GetGroundPosition(self.parent:GetAbsOrigin(), nil) )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( aoe/2 , 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local units = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

	for _,unit in pairs(units) do 

		local dir = (unit:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
		local point = self.parent:GetAbsOrigin() + dir*knock

		local distance = (point - unit:GetAbsOrigin()):Length2D()

		distance = math.max(knock, distance)
		point = point + dir*distance

		unit:AddNewModifier( self.caster, self.ability,  "modifier_generic_arc",  
		{
		  target_x = point.x,
		  target_y = point.y,
		  distance = distance,
		  duration = 0.2,
		  height = 50,
		  fix_end = false,
		  isStun = false,
		  activity = ACT_DOTA_FLAIL,
		})

		self.ability:DealDamage(unit, true)
	end

	self:Destroy()
	UTIL_Remove(self.parent)
	return
end

self.target_angel = (self.target_point - self.parent:GetAbsOrigin()):Normalized()

local pos = self.parent:GetAbsOrigin()
local pos_p = self.target_angel * self.target_speed * self.dt
local next_pos = pos + pos_p

self.parent:SetAbsOrigin(next_pos)
end


function modifier_muerta_the_calling_custom_thinker:CheckState()
return 
{
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
}
end

function modifier_muerta_the_calling_custom_thinker:OnDestroy()
if not IsServer() then return end
end

function modifier_muerta_the_calling_custom_thinker:IsAura()
if self:GetStackCount() == 1 then return end
return true
end

function modifier_muerta_the_calling_custom_thinker:GetModifierAura()
return "modifier_muerta_the_calling_custom_damage"
end

function modifier_muerta_the_calling_custom_thinker:GetAuraRadius()
return self.hit_radius
end

function modifier_muerta_the_calling_custom_thinker:GetAuraDuration()
return 0
end

function modifier_muerta_the_calling_custom_thinker:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_muerta_the_calling_custom_thinker:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end







modifier_muerta_the_calling_custom_damage = class({})

function modifier_muerta_the_calling_custom_damage:IsHidden() return true end
function modifier_muerta_the_calling_custom_damage:OnCreated()
if not IsServer() then return end
self:GetAbility():DealDamage(self:GetParent())
end






modifier_muerta_the_calling_custom_debuff = class({})

function modifier_muerta_the_calling_custom_debuff:IsHidden() return self.is_ally end
function modifier_muerta_the_calling_custom_debuff:IsPurgable() return false end

function modifier_muerta_the_calling_custom_debuff:GetEffectName()
if self.is_ally then return end
return "particles/units/heroes/hero_muerta/muerta_calling_debuff_slow.vpcf"
end

function modifier_muerta_the_calling_custom_debuff:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.is_ally = self.parent:GetTeamNumber() == self.caster:GetTeamNumber()

self.damage_reduce = self.caster:GetTalentValue("modifier_muerta_calling_3", "damage_reduce")
self.regen = self.caster:GetTalentValue("modifier_muerta_calling_3", "regen")

self.damage_interval = self.caster:GetTalentValue("modifier_muerta_calling_4", "interval", true)
self.resist_duration = self.caster:GetTalentValue("modifier_muerta_calling_4", "duration", true)
self.creeps = self.caster:GetTalentValue("modifier_muerta_calling_4", "creeps", true)
self.burn_damage = self.damage_interval*self.caster:GetTalentValue("modifier_muerta_calling_4", "burn_damage")

self.move_slow = self.ability:GetSpecialValueFor("aura_movespeed_slow") + self.caster:GetTalentValue("modifier_muerta_calling_2", "slow")
self.attack_slow = self.caster:GetTalentValue("modifier_muerta_calling_2", "attack")

if not IsServer() then return end

if self.parent == self.caster and self.caster:HasTalent("modifier_muerta_calling_3") then 
	self.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	self:AddParticle(self.particle2, false, false, -1, false, false)
end

if not self.parent:HasModifier("modifier_muerta_the_calling_custom_root_cd") then 
	self.ability:ProcRoot(self.parent)
end

self.count = self.damage_interval
self.interval = 0.1
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end



function modifier_muerta_the_calling_custom_debuff:OnIntervalThink()
if not IsServer() then return end
if self.is_ally then return end

self.count = self.count + self.interval

if self.caster:GetQuest() == "Muerta.Quest_6" and self.caster:QuestCompleted() == false and self.parent:IsRealHero() then 
	self.caster:UpdateQuest(self.interval)
end

if not self.parent:HasModifier("modifier_muerta_the_calling_custom_root_cd") then 
	self.ability:ProcRoot(self.parent)
end

if not self.caster:HasTalent("modifier_muerta_calling_4") then return end
if self.count < self.damage_interval then return end

self.count = 0

local damage = self.burn_damage*self.parent:GetMaxHealth()/100
if self.parent:IsCreep() then 
	damage = damage/self.creeps
end 

self.parent:AddNewModifier(self.caster, self.ability, "modifier_muerta_the_calling_custom_resist", {duration = self.resist_duration})

DoDamage({victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage}, "modifier_muerta_calling_4")
end


function modifier_muerta_the_calling_custom_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
}
end


function modifier_muerta_the_calling_custom_debuff:GetModifierIncomingDamage_Percentage()
if not self.caster:HasTalent("modifier_muerta_calling_3") or self.caster ~= self.parent then return end
return self.damage_reduce
end

function modifier_muerta_the_calling_custom_debuff:GetModifierHealthRegenPercentage()
if not self.caster:HasTalent("modifier_muerta_calling_3") or self.caster ~= self.parent then return end
return self.regen
end

function modifier_muerta_the_calling_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
if self.is_ally then return end
return self.move_slow
end

function modifier_muerta_the_calling_custom_debuff:GetModifierAttackSpeedBonus_Constant()
if self.is_ally then return end
return self.attack_slow
end











modifier_muerta_the_calling_caster = class({})

function modifier_muerta_the_calling_caster:IsHidden() return false end
function modifier_muerta_the_calling_caster:IsPurgable() return false end
function modifier_muerta_the_calling_caster:GetTexture() return "buffs/calling_legendary" end

function modifier_muerta_the_calling_caster:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.self_move = self.caster:GetTalentValue("modifier_muerta_calling_7", "speed")
self.damage_aoe = self.ability:GetSpecialValueFor("hit_radius")

if not IsServer() then return end

self.caster:EmitSound("Muerta.Calling_caster_start")

for i = 0,self.parent:GetAbilityCount() do
	local a = self.parent:GetAbilityByIndex(i)

	if not a or a:GetName() == "ability_capture" then break end

	if a:GetName() ~= "muerta_the_calling_custom" and a:GetName() ~= "muerta_the_calling_custom_legendary" and a:GetName() ~= "muerta_the_calling_custom_target" then 
		a:SetActivated(false)
	end		
end

self.caster:StartGesture(ACT_DOTA_SPAWN)
self.caster:SetModelScale(1.5)

self.particle = ParticleManager:CreateParticle("particles/muerta/calling_hero.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControl(self.particle, 1, Vector(120, 120, 120))
self:AddParticle(self.particle, false, false, -1, false, false)

local particle = ParticleManager:CreateParticle( "particles/muerta_calling_caster_start_2.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )

self.targets = {}

self:StartIntervalThink(0.1)
end


function modifier_muerta_the_calling_caster:OnIntervalThink()
if not IsServer() then return end

local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, self.damage_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

for _,enemy in pairs(enemies) do 
	if not self.targets[enemy:entindex()] then
		self.targets[enemy:entindex()] = true 
		self.ability:DealDamage(enemy)
	end
end

end


function modifier_muerta_the_calling_caster:OnDestroy()
if not IsServer() then return end

for i = 0,self.parent:GetAbilityCount() do
	local a = self.parent:GetAbilityByIndex(i)

	if not a or a:GetName() == "ability_capture" then break end

	if a:GetName() ~= "muerta_the_calling_custom" and a:GetName() ~= "muerta_the_calling_custom_legendary" and a:GetName() ~= "muerta_the_calling_custom_target" then 
		a:SetActivated(true)
	end		
end

self.caster:EmitSound("Muerta.Calling_caster_end")

local particle = ParticleManager:CreateParticle( "particles/muerta/muerta_calling_caster_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
ParticleManager:SetParticleControl(particle, 0, self.caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )


self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
self.caster:FadeGesture(ACT_DOTA_SPAWN)
self.caster:FadeGesture(ACT_DOTA_RUN)
self.caster:SetModelScale(1)
FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), true)

if self.parent:FindAbilityByName("muerta_the_calling_custom_legendary") then 

	self.parent:FindAbilityByName("muerta_the_calling_custom_legendary"):UseResources(false, false, false, true)
end

end



function modifier_muerta_the_calling_caster:CheckState()
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_MUTED] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,

    }
end


function modifier_muerta_the_calling_caster:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_CHANGE,
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_VISUAL_Z_DELTA
}

end

function modifier_muerta_the_calling_caster:GetEffectName()
	return "particles/muerta/muerta_calling_caster_start.vpcf"
end

function modifier_muerta_the_calling_caster:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_muerta_the_calling_caster:GetModifierMoveSpeedBonus_Percentage()
if not self.parent:HasModifier("modifier_muerta_the_calling_custom_debuff") then return end
return self.self_move
end


function modifier_muerta_the_calling_caster:GetModifierModelChange()
return "models/heroes/muerta/muerta_summon_model.vmdl"
end

function modifier_muerta_the_calling_caster:GetVisualZDelta()
return 100
end

function modifier_muerta_the_calling_caster:GetOverrideAnimation()
return ACT_DOTA_RUN
end












muerta_the_calling_custom_legendary = class({})

function muerta_the_calling_custom_legendary:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()

local ability = caster:FindAbilityByName("muerta_the_calling_custom")
local duration = caster:GetTalentValue("modifier_muerta_calling_7", "duration")

if caster:HasModifier("modifier_muerta_the_calling_caster") then 
	caster:RemoveModifierByName("modifier_muerta_the_calling_caster")
else 
	self:EndCooldown()
	self:StartCooldown(0.5)
	caster:AddNewModifier(caster, ability, "modifier_muerta_the_calling_caster", {duration = duration})
end

end






muerta_the_calling_custom_target = class({})

function muerta_the_calling_custom_target:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_muerta_calling_6") then 
	return self:GetCaster():GetTalentValue("modifier_muerta_calling_6", "cd")
end
return 1
end

function muerta_the_calling_custom_target:GetAOERadius()
return self:GetCaster():GetTalentValue("modifier_muerta_calling_6", "aoe")
end

function muerta_the_calling_custom_target:GetCastRange(vLocation, hTarget)
return self:GetCaster():GetTalentValue("modifier_muerta_calling_6", "cast")
end

function muerta_the_calling_custom_target:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()
local point = self:GetCursorPosition()
local main_ability = caster:FindAbilityByName("muerta_the_calling_custom")
local range = self:GetCaster():GetTalentValue("modifier_muerta_calling_6", "cast") + caster:GetCastRangeBonus()
local speed = self:GetCaster():GetTalentValue("modifier_muerta_calling_6", "speed")

if not main_ability then return end
if not caster.calling_thinker or caster.calling_thinker:IsNull() then return end

local dis = (point - caster:GetAbsOrigin()):Length2D()

if dis > range then 
	point = (point - caster:GetAbsOrigin()):Normalized()*range + caster:GetAbsOrigin()
end


local unit = CreateUnitByName( "npc_dota_companion", caster.calling_thinker:GetAbsOrigin() + Vector(0,0,100), true, caster,  caster:GetOwner(), caster:GetTeamNumber())
local mod = unit:AddNewModifier(caster, main_ability, "modifier_muerta_the_calling_custom_thinker", {target_speed = speed, x = point.x, y = point.y})

unit:EmitSound("Muerta.Calling_target_start")
end






modifier_muerta_the_calling_custom_root = class({})

function modifier_muerta_the_calling_custom_root:IsHidden() return true end
function modifier_muerta_the_calling_custom_root:IsPurgable() return true end
function modifier_muerta_the_calling_custom_root:OnCreated(table)
if not IsServer() then return end

self:GetParent():EmitSound("Muerta.Calling_root")
end

function modifier_muerta_the_calling_custom_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end

function modifier_muerta_the_calling_custom_root:GetEffectName()
return "particles/muerta/calling_root.vpcf"
end

function modifier_muerta_the_calling_custom_root:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end



modifier_muerta_the_calling_custom_root_cd = class({})
function modifier_muerta_the_calling_custom_root_cd:IsHidden() return true end
function modifier_muerta_the_calling_custom_root_cd:IsPurgable() return false end

function modifier_muerta_the_calling_custom_root_cd:OnDestroy()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_muerta_the_calling_custom_debuff") then return end

self:GetAbility():ProcRoot(self:GetParent())
end







modifier_muerta_the_calling_custom_scepter = class({})
function modifier_muerta_the_calling_custom_scepter:IsHidden() return true end
function modifier_muerta_the_calling_custom_scepter:IsPurgable() return false end 

function modifier_muerta_the_calling_custom_scepter:GetEffectName()
return "particles/muerta/muerta_calling_caster_start.vpcf"
end

function modifier_muerta_the_calling_custom_scepter:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_muerta_the_calling_custom_scepter:OnCreated()
if not IsServer() then return end 
self.parent = self:GetParent()
self.parent:NoDraw(self)
self:GetParent():AddNoDraw()
end 


function modifier_muerta_the_calling_custom_scepter:OnDestroy()
if not IsServer() then return end 

self:GetParent():RemoveNoDraw()

local effect = ParticleManager:CreateParticle("particles/econ/events/ti7/blink_dagger_end_ti7.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self:GetParent():GetAbsOrigin())

self:GetParent():EmitSound("Muerta.Calling_scepter_end")

local particle = ParticleManager:CreateParticle( "particles/muerta/muerta_calling_caster_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )

end 


function modifier_muerta_the_calling_custom_scepter:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true
}
end 




modifier_muerta_the_calling_custom_tracker = class({})
function modifier_muerta_the_calling_custom_tracker:IsHidden() return true end
function modifier_muerta_the_calling_custom_tracker:IsPurgable() return false end
function modifier_muerta_the_calling_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.parent:AddAttackEvent_out(self)


self.cd_inc = self.parent:GetTalentValue("modifier_muerta_calling_7", "cd_inc", true)
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "ability_muerta_call",  {})
end

function modifier_muerta_the_calling_custom_tracker:OnRefresh()
self:OnCreated()
end


function modifier_muerta_the_calling_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_muerta_calling_7") then return end 
if not self.parent:HasModifier("modifier_muerta_the_calling_custom_debuff") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end 

local ability = self.parent:FindAbilityByName("muerta_the_calling_custom_legendary")

if not ability then return end 
self.parent:CdAbility(ability, self.cd_inc)
end



modifier_muerta_the_calling_custom_heal_reduce = class({})
function modifier_muerta_the_calling_custom_heal_reduce:IsHidden() return true end
function modifier_muerta_the_calling_custom_heal_reduce:IsPurgable() return false end
function modifier_muerta_the_calling_custom_heal_reduce:OnCreated()
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_muerta_calling_1", "heal_reduce")
end

function modifier_muerta_the_calling_custom_heal_reduce:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end


function modifier_muerta_the_calling_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_muerta_the_calling_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end

function modifier_muerta_the_calling_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end






modifier_muerta_the_calling_custom_resist = class({})
function modifier_muerta_the_calling_custom_resist:IsHidden() return false end
function modifier_muerta_the_calling_custom_resist:IsPurgable() return false end
function modifier_muerta_the_calling_custom_resist:GetTexture() return "buffs/calling_resist" end
function modifier_muerta_the_calling_custom_resist:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.resist = self.caster:GetTalentValue("modifier_muerta_calling_4", "resist")

if not IsServer() then return end 
self:SetStackCount(1)
end


function modifier_muerta_the_calling_custom_resist:OnRefresh(table)
if not IsServer() then return end 
self:IncrementStackCount()

if self:GetStackCount() == 8 then 
	self.parent:EmitSound("Item.StarEmblem.Enemy")
	self.particle_peffect = ParticleManager:CreateParticle("particles/muerta/resist_stackb.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)   
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end 

end 


function modifier_muerta_the_calling_custom_resist:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end


function modifier_muerta_the_calling_custom_resist:GetModifierMagicalResistanceBonus() 
return self.resist*self:GetStackCount()
end


modifier_muerta_the_calling_custom_tower_damage = class({})
function modifier_muerta_the_calling_custom_tower_damage:IsHidden() return true end
function modifier_muerta_the_calling_custom_tower_damage:IsPurgable() return false end