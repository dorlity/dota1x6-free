LinkLuaModifier("modifier_razor_plasma_field_custom", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_plasma_field_custom_slow", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_plasma_field_custom_slow_speed", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_plasma_field_custom_damage_cd", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_plasma_field_custom_stop", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_plasma_field_custom_legendary", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_plasma_field_custom_legendary_anim", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_plasma_field_custom_knock", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_razor_plasma_field_custom_damage", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_plasma_field_custom_speed", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_plasma_field_custom_shield", "abilities/razor/razor_plasma_field_custom", LUA_MODIFIER_MOTION_NONE)



razor_plasma_field_custom = class({})


function razor_plasma_field_custom:Precache(context)

my_game:PrecacheShopItems("npc_dota_hero_razor", context)
end



function razor_plasma_field_custom:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_razor_arcana_v2_custom") then
        return "razor/arcana/razor_plasma_field_alt2"
    end
    if self:GetCaster():HasModifier("modifier_razor_arcana_custom") then
        return "razor/arcana/razor_plasma_field_alt1"
    end
    if self:GetCaster():HasModifier("modifier_razor_weapon_last_custom") then
        return "razor/severing_lash/razor_plasma_field"
    end
    return "razor_plasma_field"  
end

function razor_plasma_field_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_razor_plasma_3") then
	bonus = self:GetCaster():GetTalentValue("modifier_razor_plasma_3", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end



function razor_plasma_field_custom:GetManaCost(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_razor_plasma_3") then
	bonus = self:GetCaster():GetTalentValue("modifier_razor_plasma_3", "mana")
end

return self.BaseClass.GetManaCost(self, level) + bonus

end


function razor_plasma_field_custom:GetCastRange(vLocation, hTarget)
local radius = self:GetSpecialValueFor("radius")

if self:GetCaster():HasModifier("modifier_razor_plasma_1") then 
	radius = radius + self:GetCaster():GetTalentValue("modifier_razor_plasma_1", "radius")
end 

return radius
end 


function razor_plasma_field_custom:OnSpellStart()

if self:GetCaster():HasModifier("modifier_razor_plasma_4") then 
	if self:GetCaster():HasAbility("razor_plasma_field_custom_stop") and self:GetCaster():FindAbilityByName("razor_plasma_field_custom_stop"):IsHidden() then 
		self:GetCaster():SwapAbilities(self:GetName(), "razor_plasma_field_custom_stop",  false, true)

		self:GetCaster():FindAbilityByName("razor_plasma_field_custom_stop"):StartCooldown(0.3)
	end 
end 


if self:GetCaster():HasModifier("modifier_razor_plasma_5") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_razor_plasma_field_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_razor_plasma_5", "duration")})
end 

--self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_razor_plasma_field_custom", {})
end 





modifier_razor_plasma_field_custom = class({})

function modifier_razor_plasma_field_custom:IsHidden()
	return true
end

function modifier_razor_plasma_field_custom:IsPurgable()
	return false
end

function modifier_razor_plasma_field_custom:RemoveOnDeath()
	return false
end

function modifier_razor_plasma_field_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_razor_plasma_field_custom:OnCreated( kv )
if not IsServer() then return end

self.is_thinker = not self:GetParent():IsRealHero()


self.start_radius = 0
self.current_radius = 0
self.width = 80

self.prev_radius = self.start_radius

self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.speed = self:GetAbility():GetSpecialValueFor("speed")

self.total_duration = self.radius/self.speed

if self:GetCaster():HasModifier("modifier_razor_plasma_1") then 
	self.radius = self.radius + self:GetCaster():GetTalentValue("modifier_razor_plasma_1", "radius")
	self.speed = self.radius/self.total_duration
end 

self.end_radius = self.radius + self.width

self.max_radius = self.end_radius


self.min_damage = self:GetAbility():GetSpecialValueFor("damage_min")
self.max_damage = self:GetAbility():GetSpecialValueFor("damage_max") + self:GetCaster():GetIntellect()*self:GetCaster():GetTalentValue("modifier_razor_plasma_1", "damage")/100
self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration") + self:GetCaster():GetTalentValue("modifier_razor_plasma_2", "duration")
self.slow_max = self:GetAbility():GetSpecialValueFor("slow_max")
self.slow_min = self:GetAbility():GetSpecialValueFor("slow_min") + self:GetCaster():GetTalentValue("modifier_razor_plasma_6", "slow")

if kv.more_damage then 
	self.min_damage = self.min_damage * (1 + kv.more_damage)
	self.max_damage = self.max_damage * (1 + kv.more_damage)
end 


local particle = "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"

if self:GetCaster():HasModifier("modifier_razor_arcana_custom") then
    particle = "particles/razor/razor_arcana_plasma.vpcf"
elseif self:GetCaster():HasModifier("modifier_razor_arcana_v2_custom") then
    particle = "particles/razor/razor_arcana_plasma_green.vpcf"
elseif self:GetCaster():HasModifier("modifier_razor_weapon_last_custom") then
    particle = "particles/razor/razor_plasmafield_ti6.vpcf"
end



local sound = "Ability.PlasmaField"
if self:GetCaster():HasModifier("modifier_razor_weapon_last_custom") then
    sound = "Hero_Razor.PlasmaField.SeveringLash"
end
--[[

particles/razor/razor_arcana_plasma_green.vpcf

]]
if self.is_thinker == true then 
	self.speed = self.speed*1.5
	sound = "Razor.Legendary_start"
	particle = "particles/econ/items/razor/razor_ti6/razor_plasmafield_ti6.vpcf"
end 


self.effect_cast = ParticleManager:CreateParticle( particle, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(self.effect_cast , 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.speed, self.max_radius, 1 ) )
self:AddParticle( self.effect_cast, false, false, -1, false, false )


self.damage_duration = self:GetCaster():GetTalentValue("modifier_razor_plasma_4", "duration_reduce")
self.damage_interval = self:GetCaster():GetTalentValue("modifier_razor_plasma_4", "interval")

self.silence_duration = self:GetCaster():GetTalentValue("modifier_razor_plasma_6", "silence")

self:GetParent():EmitSound( sound )

local type = DAMAGE_TYPE_MAGICAL


self.damageTable = {attacker = self:GetCaster(), ability = self:GetAbility(), damage_type = type}

self.outward = true
self.targets = {}
self.silence_targets = {}

self.interval = 0.01
self.count = 0
self.prev_speed = 0

self:StartIntervalThink( self.interval )
self:OnIntervalThink()
end


function modifier_razor_plasma_field_custom:Stop()
if not IsServer() then return end

self:GetParent():StopSound("Ability.PlasmaField")
if self:GetCaster():HasModifier("modifier_razor_weapon_last_custom") then
    self:GetParent():StopSound("Hero_Razor.PlasmaField.SeveringLash")
end

local prev = self.speed
self.speed = self.prev_speed
self.prev_speed = prev

local k = 1 

if self.speed < 0 then 
	k = -1
end 

if self.effect_cast then 	
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(math.abs(self.speed), self.max_radius, k ) )
end 

end 



function modifier_razor_plasma_field_custom:OnDestroy()
if not IsServer() then return end


AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, 2, false)

self:GetParent():StopSound("Razor.Plasma_start")

if self.is_thinker == false and self:GetCaster():HasAbility("razor_plasma_field_custom_stop") and not self:GetCaster():FindAbilityByName("razor_plasma_field_custom_stop"):IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetAbility():GetName(), "razor_plasma_field_custom_stop",  true, false)
end 

end



function modifier_razor_plasma_field_custom:ChangeDir()

if self.effect_cast then 	
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.speed, self.max_radius, -1 ) )
end 

self.outward = not self.outward

self.speed = self.speed*-1

if self.outward == true then 
	self.end_radius = self.radius + self.width
	self.start_radius = 0
else 
	self.end_radius = 0
	self.start_radius = self.radius + self.width
end 

self.current_radius = self.current_radius - self.speed*self.interval
self.targets = {}

end 




function modifier_razor_plasma_field_custom:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, self.interval, false)

if self.effect_cast then 
	ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin() )
end 

self.current_radius =   math.max(0, self.current_radius + self.speed * self.interval)

local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.current_radius + self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0 , 0, false )

for _,target in pairs(targets) do

	local distance = (target:GetOrigin()-self:GetParent():GetOrigin()):Length2D()
	local real_radius = self.current_radius

	if (not self.targets[target] or (self.speed == 0 and not target:HasModifier("modifier_razor_plasma_field_custom_damage_cd"))) 
		and distance>(real_radius -self.width*2) and (not target:HasModifier("modifier_razor_plasma_field_custom_knock") or self.is_thinker == false) then

		self.targets[target] = true

		local k = distance/self.radius
		self.damageTable.victim = target
		self.damageTable.damage = math.max(self.min_damage, math.min(self.max_damage, self.min_damage + (self.max_damage - self.min_damage)*k))
		
		local slow = math.max(self.slow_min, math.min(self.slow_max, self.slow_min + (self.slow_max - self.slow_min)*k))

		target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_razor_plasma_field_custom_slow", {slow = slow, duration = self.slow_duration*(1 - target:GetStatusResistance())})

		if self:GetCaster():HasModifier("modifier_razor_plasma_2") then 
			target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_razor_plasma_field_custom_slow_speed", {duration = self.slow_duration*(1 - target:GetStatusResistance())})
		end 

		target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_razor_plasma_field_custom_damage_cd", {duration = self.damage_interval})
	
		ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, target ) )
		ApplyDamage(self.damageTable)

		if self:GetCaster():GetQuest() == "Razor.Quest_5" and target:IsRealHero() and self:GetCaster().quest.number and distance >= self:GetCaster().quest.number then 
			self:GetCaster():UpdateQuest(1)
		end 

		if self:GetCaster():HasModifier("modifier_razor_plasma_4") then 
			target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_razor_plasma_field_custom_damage", {duration = self.damage_duration})
		end 

		if self:GetCaster():HasModifier("modifier_razor_plasma_6") and not self.silence_targets[target] then 
			target:EmitSound("SF.Raze_silence")
			self.silence_targets[target] = true
			target:Purge(true, false, false, false, false)

			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
			ParticleManager:ReleaseParticleIndex(particle)

			target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_silence", {duration = (1 - target:GetStatusResistance())*self.silence_duration})
		end 

		target:EmitSound( "Ability.PlasmaFieldImpact" )
	end
end


if self.outward and self.current_radius>self.end_radius then

	if self.is_thinker == true then 
--		self:Destroy()
	--	return
	end 

	self:ChangeDir()
end


if not self.outward and self.current_radius<=self.end_radius then
	self:Destroy()
	return
end 


end 




modifier_razor_plasma_field_custom_slow = class({})
function modifier_razor_plasma_field_custom_slow:IsHidden() return false end
function modifier_razor_plasma_field_custom_slow:IsPurgable() return true end
function modifier_razor_plasma_field_custom_slow:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_razor_plasma_field_custom_slow:OnCreated(table)
if not IsServer() then return end 
self:SetStackCount(table.slow)

end 

function modifier_razor_plasma_field_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_razor_plasma_field_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*-1
end


modifier_razor_plasma_field_custom_slow_speed = class({})
function modifier_razor_plasma_field_custom_slow_speed:IsHidden() return true end
function modifier_razor_plasma_field_custom_slow_speed:IsPurgable() return true end
function modifier_razor_plasma_field_custom_slow_speed:OnCreated(table)
self.slow = self:GetCaster():GetTalentValue("modifier_razor_plasma_2", 'speed')
end 

function modifier_razor_plasma_field_custom_slow_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_razor_plasma_field_custom_slow_speed:GetModifierAttackSpeedBonus_Constant()
return self.slow
end









modifier_razor_plasma_field_custom_damage_cd = class({})
function modifier_razor_plasma_field_custom_damage_cd:IsHidden() return true end
function modifier_razor_plasma_field_custom_damage_cd:IsPurgable() return false end





razor_plasma_field_custom_stop = class({})


function razor_plasma_field_custom_stop:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_razor_arcana_v2_custom") then
        return "razor/arcana/razor_plasma_field_alt2"
    end
    if self:GetCaster():HasModifier("modifier_razor_arcana_custom") then
        return "razor/arcana/razor_plasma_field_alt1"
    end
    if self:GetCaster():HasModifier("modifier_razor_weapon_last_custom") then
        return "razor/severing_lash/razor_plasma_field"
    end
    return "razor_plasma_field"  
end


function razor_plasma_field_custom_stop:OnSpellStart()

if self:GetCaster():HasModifier("modifier_razor_plasma_field_custom_stop") then 
	self:GetCaster():RemoveModifierByName("modifier_razor_plasma_field_custom_stop")
	return
end

local duration = self:GetCaster():GetTalentValue("modifier_razor_plasma_4", "stop")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_razor_plasma_field_custom_stop", {duration = duration})

self:EndCooldown()
self:StartCooldown(0.3)
end


modifier_razor_plasma_field_custom_stop = class({})
function modifier_razor_plasma_field_custom_stop:IsHidden() return false end
function modifier_razor_plasma_field_custom_stop:IsPurgable() return false end
function modifier_razor_plasma_field_custom_stop:OnCreated()
if not IsServer() then return end 

self.ability = self:GetParent():FindAbilityByName("razor_plasma_field_custom")
if not self.ability then 
	self:Destroy()
	return
end 

--self:GetAbility():SetActivated(false)

self.cd = self.ability:GetCooldownTimeRemaining()

self:GetParent():EmitSound("Razor.Plasma_stop")
self:GetParent():EmitSound("Razor.Plasma_stop_loop")

local mod = self:GetCaster():FindModifierByName("modifier_razor_plasma_field_custom")

if mod then 
	mod:Stop()
	return
end 

end 

function modifier_razor_plasma_field_custom_stop:OnDestroy()
if not IsServer() then return end 

--self:GetAbility():SetActivated(true)

if self.ability and self.ability:IsHidden() then 
	self:GetCaster():SwapAbilities(self:GetAbility():GetName(), "razor_plasma_field_custom",  false, true)

	self.ability:EndCooldown()
	self.ability:StartCooldown(self.cd)
end 


self:GetParent():EmitSound("Razor.Plasma_start")
self:GetParent():StopSound("Razor.Plasma_stop_loop")
local mod = self:GetCaster():FindModifierByName("modifier_razor_plasma_field_custom")

if mod then 
	mod:Stop()
	return
end 

end 



razor_plasma_field_custom_clone = class({})

function razor_plasma_field_custom_clone:GetBehavior()
local bonus = 0
if self:GetCaster():HasModifier("modifier_razor_static_link_custom") or self:GetCaster():HasModifier("modifier_razor_static_link_custom_legendary") then
	bonus = DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + bonus
end


function razor_plasma_field_custom_clone:GetCooldown(level)
return self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "cd")
end 




function razor_plasma_field_custom_clone:OnSpellStart()

local caster = self:GetCaster()
local point = self:GetCursorPosition()
local delay = self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "delay")


caster:EmitSound("Razor.Legendary_cast")

local illusion_self = CreateIllusions(self:GetCaster(), self:GetCaster(), {
	outgoing_damage = 0,
	incoming_damage = self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "incoming") - 100,
	duration    = delay + 1  
}, 1, 0, false, false)

for _,illusion in pairs(illusion_self) do

	illusion:SetHealth(illusion:GetMaxHealth())

  illusion.owner = caster

  illusion:AddNewModifier(self:GetCaster(), self, "modifier_razor_plasma_field_custom_legendary",  {duration = delay})
  illusion:AddNewModifier(self:GetCaster(), self, "modifier_chaos_knight_phantasm_illusion", {})
  illusion:SetOrigin(GetGroundPosition(point, nil))

  illusion:EmitSound("Razor.Legendary_cast_voice")

  point.z = point.z + 150

	cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(cast_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(cast_particle, 1, point)
	ParticleManager:SetParticleControlEnt(cast_particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)

end


end






modifier_razor_plasma_field_custom_legendary = class({})
function modifier_razor_plasma_field_custom_legendary:IsHidden() return false end
function modifier_razor_plasma_field_custom_legendary:IsPurgable() return false end

function modifier_razor_plasma_field_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_monkey_king_fur_army.vpcf" end


function modifier_razor_plasma_field_custom_legendary:StatusEffectPriority()
    return 10010
end
function modifier_razor_plasma_field_custom_legendary:OnDestroy()
if not IsServer() then return end

self:GetParent():StopSound("Razor.Legendary_loop")

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", PATTACH_WORLDORIGIN, nil)

local z_pos = 3000
local target_point = self:GetParent():GetAbsOrigin()

self:GetParent():EmitSound("Razor.Legendary_end1")
self:GetParent():EmitSound("Razor.Legendary_end2")

ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, z_pos))
ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, target_point.z))
ParticleManager:ReleaseParticleIndex(particle)

ParticleManager:SetParticleControl(particle2, 0, Vector(target_point.x, target_point.y, z_pos))
ParticleManager:SetParticleControl(particle2, 1, Vector(target_point.x, target_point.y, target_point.z))
ParticleManager:ReleaseParticleIndex(particle2)

local particle_explode_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle_explode_fx, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_explode_fx, 1, Vector(self.radius, 1, 1))
ParticleManager:SetParticleControl(particle_explode_fx, 3, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_explode_fx)

local knock_duration = self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "knock_duration")

self.ability = self:GetCaster():FindAbilityByName("razor_plasma_field_custom")

if self.ability and self:GetParent():GetHealth() > 1 then 

	local targets = self:GetCaster():FindTargets(600, self:GetParent():GetAbsOrigin())

	for _,target in pairs(targets) do 
		if target:IsHero() then 
			target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_razor_plasma_field_custom_knock", {duration = knock_duration, x = self:GetParent():GetAbsOrigin().x, y = self:GetParent():GetAbsOrigin().y})
		end
	end 

	local damage = self.damage*math.min(1, (self:GetParent():GetHealth()/self:GetParent():GetMaxHealth()))

	CreateModifierThinker(self:GetCaster(), self.ability, "modifier_razor_plasma_field_custom", {more_damage = damage}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
	  
end 

self:GetParent():Kill(nil, nil) 
end

function modifier_razor_plasma_field_custom_legendary:OnCreated(table)
if not IsServer() then return end

self:GetParent():StartGesture(ACT_DOTA_TELEPORT)

self.max_time = self:GetRemainingTime()
self.damage = self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "damage")/100

self.radius = self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "radius")

self:GetParent():EmitSound("Razor.Legendary_loop")
self:GetParent():EmitSound("Razor.Legendary_spawn1")
self:GetParent():EmitSound("Razor.Legendary_spawn2")

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_razor_plasma_field_custom_legendary_anim", {duration = self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "delay")})
self.count = 0
self:StartIntervalThink(0.2)
end



function modifier_razor_plasma_field_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

local targets = self:GetCaster():FindTargets(1000, self:GetParent():GetAbsOrigin())

for _,target in pairs(targets) do 
	if target:IsRealHero() then 
		AddFOWViewer(target:GetTeamNumber(), self:GetParent():GetAbsOrigin(), 100, 0.2, false)
	end 
end 

local caster = self:GetParent()

local point = caster:GetAbsOrigin() + RandomVector(RandomInt(100, 300))

cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(cast_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(cast_particle, 1, point)
ParticleManager:SetParticleControlEnt(cast_particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(cast_particle)

self.count = self.count + 1

if self.count >= 3 then 
	self.count = 0 
	self:GetParent():EmitSound("Razor.Legendary_bolt")
end 

end 



function modifier_razor_plasma_field_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end


function modifier_razor_plasma_field_custom_legendary:GetOverrideAnimation()
return ACT_DOTA_TELEPORT
end

function modifier_razor_plasma_field_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
}
end


modifier_razor_plasma_field_custom_legendary_anim = class({})

function modifier_razor_plasma_field_custom_legendary_anim:IsHidden() return true end 
function modifier_razor_plasma_field_custom_legendary_anim:IsPurgable() return false end
function modifier_razor_plasma_field_custom_legendary_anim:OnCreated(table)
if not IsServer() then return end
self.t = -1
self.timer = self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "delay")*2

self:StartIntervalThink(0.5)
self:OnIntervalThink()
end


function modifier_razor_plasma_field_custom_legendary_anim:OnIntervalThink()
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

local particleName = "particles/huskar_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end









modifier_razor_plasma_field_custom_knock = class({})

function modifier_razor_plasma_field_custom_knock:IsHidden() return true end

function modifier_razor_plasma_field_custom_knock:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()

  ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) )
		
  self.knockback_duration   = params.duration

  local center = GetGroundPosition(Vector(params.x, params.y, 0), nil)

  self.dir = (self.parent:GetAbsOrigin() - center):Normalized()

  local point = center + self.dir * self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "knock_distance")

  self.knockback_distance = math.max(self:GetCaster():GetTalentValue("modifier_razor_plasma_7", "knock_distance_min"), (self.parent:GetAbsOrigin() - point):Length2D())
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end


function modifier_razor_plasma_field_custom_knock:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true
}
end

function modifier_razor_plasma_field_custom_knock:UpdateHorizontalMotion( me, dt )
  if not IsServer() then return end  
  me:SetOrigin( me:GetOrigin() +  self.dir * self.knockback_speed * dt )
end

function modifier_razor_plasma_field_custom_knock:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_razor_plasma_field_custom_knock:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_razor_plasma_field_custom_knock:OnDestroy()
 if not IsServer() then return end
  self.parent:RemoveHorizontalMotionController( self )
end




modifier_razor_plasma_field_custom_damage = class({})
function modifier_razor_plasma_field_custom_damage:IsHidden() return false end
function modifier_razor_plasma_field_custom_damage:IsPurgable() return false end
function modifier_razor_plasma_field_custom_damage:GetTexture() return "buffs/plasma_damage" end
function modifier_razor_plasma_field_custom_damage:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_razor_plasma_4", "max")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_razor_plasma_4", "heal_reduce")

if not IsServer() then return end 

self:SetStackCount(1)
end 

function modifier_razor_plasma_field_custom_damage:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 


self:IncrementStackCount()
end

function modifier_razor_plasma_field_custom_damage:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
 	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end


function modifier_razor_plasma_field_custom_damage:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_razor_plasma_field_custom_damage:GetModifierHealAmplify_PercentageTarget() 
return self.heal_reduce*self:GetStackCount()
end
function modifier_razor_plasma_field_custom_damage:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end



modifier_razor_plasma_field_custom_speed = class({})
function modifier_razor_plasma_field_custom_speed:IsHidden() return true end
function modifier_razor_plasma_field_custom_speed:IsPurgable() return false end
function modifier_razor_plasma_field_custom_speed:GetEffectName()
	return "particles/items_fx/force_staff.vpcf"
end 

function modifier_razor_plasma_field_custom_speed:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_razor_plasma_field_custom_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_razor_plasma_5", "speed")
self.shield_duration = self:GetCaster():GetTalentValue("modifier_razor_plasma_5", "shield_duration")

if not IsServer() then return end 

local effect_cast = ParticleManager:CreateParticle( "particles/zuus_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
self:AddParticle( effect_cast, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(self:GetCaster():GetTalentValue("modifier_razor_plasma_5", "interval") - 0.01)
end

function modifier_razor_plasma_field_custom_speed:OnIntervalThink()
if not IsServer() then return end 
if not self:GetParent():IsMoving() then return end 

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_razor_plasma_field_custom_shield", {duration = self.shield_duration})
end 


function modifier_razor_plasma_field_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_razor_plasma_field_custom_speed:GetModifierMoveSpeedBonus_Percentage()
	return self.speed
end


function modifier_razor_plasma_field_custom_speed:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end








modifier_razor_plasma_field_custom_shield = class({})
function modifier_razor_plasma_field_custom_shield:IsHidden() return false end
function modifier_razor_plasma_field_custom_shield:IsPurgable() return false end
function modifier_razor_plasma_field_custom_shield:GetTexture() return "buffs/laguna_shield" end


function modifier_razor_plasma_field_custom_shield:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_razor_plasma_field_custom_shield:StatusEffectPriority() return 11111 end

function modifier_razor_plasma_field_custom_shield:OnCreated(table)

self.max_shield = self:GetCaster():GetTalentValue("modifier_razor_plasma_5", "shield")*self:GetParent():GetMaxHealth()/100
self.add_shiled = self.max_shield/(self:GetCaster():GetTalentValue("modifier_razor_plasma_5", "duration")/self:GetCaster():GetTalentValue("modifier_razor_plasma_5", "interval"))

if not IsServer() then return end
self:AddStack()

self.RemoveForDuel = true

local shield_size = self:GetParent():GetModelRadius() 

local particle = ParticleManager:CreateParticle("particles/zuus_shield_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
local common_vector = Vector(shield_size,0,shield_size)
ParticleManager:SetParticleControl(particle, 1, common_vector)
ParticleManager:SetParticleControl(particle, 2, common_vector)
ParticleManager:SetParticleControl(particle, 4, common_vector)

ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(particle, false, false, -1, false, false)

self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")

end


function modifier_razor_plasma_field_custom_shield:OnRefresh()
if not IsServer() then return end 

self:AddStack()
end 

function modifier_razor_plasma_field_custom_shield:AddStack()
if not IsServer() then return end 

self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + self.add_shiled))
end 



function modifier_razor_plasma_field_custom_shield:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("DOTA_Item.Mjollnir.Loop")
self:GetParent():EmitSound("DOTA_Item.Mjollnir.DeActivate")
end



function modifier_razor_plasma_field_custom_shield:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}

end





function modifier_razor_plasma_field_custom_shield:GetModifierIncomingDamageConstant( params )

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


