LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_thinker", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_debuff", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_trap", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_slow", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_damage", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_vision", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_tracker", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_damage_status", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_damage_bonus", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_bushwhack_custom_heal", "abilities/hoodwink/hoodwink_bushwhack_custom", LUA_MODIFIER_MOTION_NONE )


hoodwink_bushwhack_custom = class({})






hoodwink_bushwhack_custom.active_traps = {}
hoodwink_bushwhack_custom.trap_index = 0


function hoodwink_bushwhack_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_projectile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_target.vpcf", context )
PrecacheResource( "particle", "particles/tree_fx/tree_simple_explosion.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_treant/treant_eyesintheforest.vpcf", context )
PrecacheResource( "particle", "particles/hoodwink_bush_damage.vpcf", context )
PrecacheResource( "particle", "particles/pa_vendetta.vpcf", context )
PrecacheResource( "particle", "particles/hoodwink/poison_stack.vpcf", context )

end





function hoodwink_bushwhack_custom:GetIntrinsicModifierName()
return "modifier_hoodwink_bushwhack_custom_tracker"
end


function hoodwink_bushwhack_custom:GetAOERadius()
	return self:GetSpecialValueFor( "trap_radius" )
end

function hoodwink_bushwhack_custom:GetCastPoint()
local bonus = 0

if self:GetCaster():HasModifier("modifier_hoodwink_bush_6") then 
	return 0
end

return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end



function hoodwink_bushwhack_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_hoodwink_bush_1") then 
	upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_1", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end



function hoodwink_bushwhack_custom:GetManaCost(level)

local bonus = 0

if self:GetCaster():HasModifier("modifier_hoodwink_bush_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_1", "mana")
end

return self.BaseClass.GetManaCost(self,level) + bonus
end







function hoodwink_bushwhack_custom:Cast(point, origin, new_duration)

local caster = self:GetCaster()
local projectile_speed = self:GetSpecialValueFor( "projectile_speed" ) * (1 + self:GetCaster():GetTalentValue("modifier_hoodwink_bush_6", "speed")/100)
local delay = (point-origin):Length2D()/projectile_speed
local stun = self:GetSpecialValueFor( "debuff_duration" ) + self:GetCaster():GetTalentValue("modifier_hoodwink_bush_5", "stun")

if new_duration then 
	stun = new_duration
end 

local target = CreateModifierThinker( caster, self, "modifier_hoodwink_bushwhack_custom_thinker", {x = origin.x, y = origin.y, duration = delay, stun = stun}, point, caster:GetTeamNumber(), false )
end


function hoodwink_bushwhack_custom:OnSpellStart()
if not IsServer() then return end
local caster = self:GetCaster()
local point = self:GetCursorPosition()

self:Cast(point, caster:GetAbsOrigin())
end




modifier_hoodwink_bushwhack_custom_thinker = class({})

function modifier_hoodwink_bushwhack_custom_thinker:IsHidden()
	return false
end

function modifier_hoodwink_bushwhack_custom_thinker:IsPurgable()
	return true
end

function modifier_hoodwink_bushwhack_custom_thinker:OnCreated( kv )
if not IsServer() then return end
self.origin = GetGroundPosition(Vector(kv.x, kv.y, 0), nil)

self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.duration = kv.stun
self.speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" ) * (1 + self:GetCaster():GetTalentValue("modifier_hoodwink_bush_6", "speed")/100)
self.radius = self:GetAbility():GetSpecialValueFor( "trap_radius" )
self.location = self:GetParent():GetOrigin()

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_projectile.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
ParticleManager:SetParticleControl( particle, 0, self.origin )
ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( particle, 2, Vector( self.speed, 0, 0 ) )
self:AddParticle( particle, false, false, -1, false, false )
self.caster:EmitSound("Hero_Hoodwink.Bushwhack.Cast")
end

function modifier_hoodwink_bushwhack_custom_thinker:OnDestroy()
if not IsServer() then return end
AddFOWViewer( self.caster:GetTeamNumber(), self.location, self.radius, self.duration, false )


if self:GetCaster():HasModifier("modifier_hoodwink_bush_legendary") then
	local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
	local trees = GridNav:GetAllTreesAroundPoint( self.location, self.radius, false )
	if #trees>0 and #enemies<1 then

		local origin = self.location
		local mytree = trees[1]
		local mytreedist = (trees[1]:GetOrigin()-origin):Length2D()
		for _,tree in pairs(trees) do
			local treedist = (tree:GetOrigin()-origin):Length2D()
			if treedist<mytreedist then
				mytree = tree
				mytreedist = treedist
			end
		end

		local tree = CreateUnitByName("npc_dota_treant_eyes", mytree:GetAbsOrigin(), false, self.caster, self.caster, self.caster:GetTeamNumber())

		self:GetAbility().trap_index = self:GetAbility().trap_index + 1

		self:GetAbility().active_traps[self:GetAbility().trap_index] = tree:AddNewModifier(self.caster, self.ability, "modifier_hoodwink_bushwhack_custom_trap", {index = self:GetAbility().trap_index, radius = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_legendary", "radius"), target = mytree:entindex()})

		local count = 0

		for i,trap in pairs(self:GetAbility().active_traps) do 
			count = count + 1
		end 

		if count > self:GetCaster():GetTalentValue("modifier_hoodwink_bush_legendary", "max") then 
			for i = 1,self:GetAbility().trap_index do 
				if self:GetAbility().active_traps[i] and not self:GetAbility().active_traps[i]:IsNull() then
					self:GetAbility().active_traps[i]:Destroy()
					break
				end 
			end 
		end 

		self.caster:StopSound("Hero_Hoodwink.Bushwhack.Cast")
		self:GetParent():EmitSound("Hero_Hoodwink.Bushwhack.Impact")
		return
	end
end


local enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), self.location, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )
if #enemies<1 then
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, self.location )
	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( particle )

	self.caster:StopSound("Hero_Hoodwink.Bushwhack.Cast")
	self:GetParent():EmitSound("Hero_Hoodwink.Bushwhack.Impact")
	return
end

local trees = GridNav:GetAllTreesAroundPoint( self.location, self.radius, false )
if #trees<1 then
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_fail.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, self.location )
	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( particle )

	self.caster:StopSound("Hero_Hoodwink.Bushwhack.Cast")
	self:GetParent():EmitSound("Hero_Hoodwink.Bushwhack.Impact")
	return
end


self.caster:StopSound("Hero_Hoodwink.Bushwhack.Cast")

for _,enemy in pairs(enemies) do
	local origin = enemy:GetOrigin()
	local mytree = trees[1]
	local mytreedist = (trees[1]:GetOrigin()-origin):Length2D()
	for _,tree in pairs(trees) do
		local treedist = (tree:GetOrigin()-origin):Length2D()
		if treedist<mytreedist then
			mytree = tree
			mytreedist = treedist
		end
	end
	enemy:AddNewModifier( self.caster, self.ability, "modifier_hoodwink_bushwhack_custom_debuff", { duration = self.duration*(1 - enemy:GetStatusResistance()), damage = 1, tree = mytree:entindex(), }  )
end

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle, 0, self.location )
ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( particle )
self.caster:EmitSound("Hero_Hoodwink.Bushwhack.Impact")

UTIL_Remove( self:GetParent() )
end





modifier_hoodwink_bushwhack_custom_debuff = class({})

function modifier_hoodwink_bushwhack_custom_debuff:IsPurgeException() return true end
function modifier_hoodwink_bushwhack_custom_debuff:IsStunDebuff() return true end

function modifier_hoodwink_bushwhack_custom_debuff:OnCreated( kv )
self.parent = self:GetParent()
self.height = self:GetAbility():GetSpecialValueFor( "visual_height" )
self.rate = self:GetAbility():GetSpecialValueFor( "animation_rate" )
self.duration = self:GetRemainingTime()
self.distance = 150
self.speed = 900
self.interval = 0.2
self.tick_count = math.floor(self.duration / self.interval)
self.allow_damage = kv.damage

self.damage = self:GetAbility():GetSpecialValueFor( "total_damage" ) + self:GetCaster():GetTalentValue("modifier_hoodwink_bush_2", "damage")
self.damage = self.damage / self.tick_count

if not IsServer() then return end

self.damage_duration = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_4", "duration", true)
self.damage_stack = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_4", "stack", true)

self.init = false

if self:GetCaster():HasModifier("modifier_hoodwink_bush_2") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_damage_bonus", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_2", "duration")})
end 

if self:GetCaster():HasModifier("modifier_hoodwink_bush_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_3", "duration")})
end 

if self:GetCaster():HasModifier("modifier_hoodwink_bush_6") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_vision", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_6", "vision")})
end

self.tree = EntIndexToHScript( kv.tree )
self.tree_origin = self.tree:GetOrigin()
if not self:ApplyHorizontalMotionController() then
	return
end
self:StartIntervalThink( self.interval )

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( particle, 15, self.tree_origin )
self:AddParticle( particle, false, false, -1, false, false )
self.parent:EmitSound("Hero_Hoodwink.Bushwhack.Target")
end

function modifier_hoodwink_bushwhack_custom_debuff:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end


function modifier_hoodwink_bushwhack_custom_debuff:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveHorizontalMotionController( self )


if self:GetCaster():HasModifier("modifier_hoodwink_bush_5") then 
	self:GetParent():EmitSound("Hoodwink.Bush_silence")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_slow", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_hoodwink_bush_5", "silence")})
end

end

function modifier_hoodwink_bushwhack_custom_debuff:DeclareFunctions()
local funcs = {
	MODIFIER_PROPERTY_FIXED_DAY_VISION,
	MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	MODIFIER_PROPERTY_VISUAL_Z_DELTA,
	MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
	MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER,
}

return funcs
end

function modifier_hoodwink_bushwhack_custom_debuff:GetBonusVisionPercentage() 
return  -100  
end

function modifier_hoodwink_bushwhack_custom_debuff:GetModifierNoVisionOfAttacker() 
return  1  
end 

function modifier_hoodwink_bushwhack_custom_debuff:GetFixedDayVision()
return 0
end

function modifier_hoodwink_bushwhack_custom_debuff:GetFixedNightVision()
return 0
end

function modifier_hoodwink_bushwhack_custom_debuff:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end

function modifier_hoodwink_bushwhack_custom_debuff:GetOverrideAnimationRate()
return self.rate
end

function modifier_hoodwink_bushwhack_custom_debuff:GetVisualZDelta()
return self.height
end

function modifier_hoodwink_bushwhack_custom_debuff:CheckState()
local state = {
	[MODIFIER_STATE_STUNNED] = true,
}

return state
end



function modifier_hoodwink_bushwhack_custom_debuff:OnIntervalThink()
if not self.tree.IsStanding then
	if self.tree:IsNull() then
		self:Destroy()
	end
elseif not self.tree:IsStanding() then
	self:Destroy()
end

if self:GetCaster():GetQuest() == "Hoodwink.Quest_6" and self:GetParent():IsRealHero() then 
	self:GetCaster():UpdateQuest(self.interval)
end


if self.init == false then 
	self.init = true

	if self:GetCaster():HasModifier("modifier_hoodwink_bush_4") then
		for i = 1,self.damage_stack do 
			self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_damage", {duration = self.damage_duration})
		end
	end
end


if (self.allow_damage == 0) then return end
ApplyDamage( { victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = self:GetAbility():GetAbilityDamageType(), ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE, } )
end

function modifier_hoodwink_bushwhack_custom_debuff:UpdateHorizontalMotion( me, dt )
	local origin = me:GetOrigin()
	local dir = self.tree_origin-origin
	local dist = dir:Length2D()
	dir.z = 0
	dir = dir:Normalized()

	if dist<self.distance then
		self:GetParent():RemoveHorizontalMotionController( self )
		local particle = ParticleManager:CreateParticle( "particles/tree_fx/tree_simple_explosion.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( particle, 0, self.parent:GetOrigin() )
		ParticleManager:ReleaseParticleIndex( particle )
		return
	end

	local target = dir * self.speed*dt
	me:SetOrigin( origin + target )
end

function modifier_hoodwink_bushwhack_custom_debuff:OnHorizontalMotionInterrupted()
	self:GetParent():RemoveHorizontalMotionController( self )
end







modifier_hoodwink_bushwhack_custom_trap = class({})

function modifier_hoodwink_bushwhack_custom_trap:OnCreated(params)
if not IsServer() then return end
local parent = self:GetParent()
if parent:IsNull() then return end
self.radius = params.radius or 0
self.target = params.target or -1

self.index = params.index

parent:SetDayTimeVisionRange(self.radius)
parent:SetNightTimeVisionRange(self.radius)
self.particle = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_treant/treant_eyesintheforest.vpcf", PATTACH_WORLDORIGIN, parent, self:GetParent():GetTeamNumber())
ParticleManager:SetParticleControl(self.particle, 0, GetGroundPosition(parent:GetAbsOrigin(), nil))
ParticleManager:SetParticleControl(self.particle, 1, Vector(self.radius,self.radius,self.radius))
self:AddParticle(self.particle, false, false, -1, false, false)
self.team_particles = {}

self.vision = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_legendary", "vision")

self.caster = self:GetCaster()

self.interval = 0.1
self.count = 0
self.max_count = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_legendary", "timer")
self.active = false

self.stun = self:GetAbility():GetSpecialValueFor("debuff_duration") + self:GetCaster():GetTalentValue("modifier_hoodwink_bush_5", "stun")

self:StartIntervalThink(self.interval)
end

function modifier_hoodwink_bushwhack_custom_trap:OnDestroy()
if not IsServer() then return end
for id, particle in pairs(self.team_particles) do
	ParticleManager:DestroyParticle(particle, true)
end

self:GetAbility().active_traps[self.index] = nil

self:GetParent():Destroy()
end

function modifier_hoodwink_bushwhack_custom_trap:OnIntervalThink()
local parent = self:GetParent()
local tree = EntIndexToHScript(self.target)

if not tree then
    self:Destroy()
    if not parent:IsNull() then 
    	parent:ForceKill(false) 
    end

    return 
end

if (tree:IsNull() or parent:IsNull()) then return end

if tree:IsNull() then
    self:Destroy()
    parent:ForceKill(false)
    return
else
	ParticleManager:SetParticleControl(self.particle, 0, GetGroundPosition(parent:GetAbsOrigin(), nil))
    AddFOWViewer(parent:GetTeamNumber(), parent:GetAbsOrigin(), self.vision, self.interval*2, false)
end

for _, mod in pairs(parent:FindAllModifiersByName("modifier_truesight")) do
	if mod and mod:GetCaster() then
		if not self.team_particles[mod:GetCaster():GetTeamNumber()] then
			self.team_particles[mod:GetCaster():GetTeamNumber()] = ParticleManager:CreateParticleForTeam("particles/units/heroes/hero_treant/treant_eyesintheforest.vpcf", PATTACH_WORLDORIGIN, parent, mod:GetCaster():GetTeamNumber())
			ParticleManager:SetParticleControl(self.team_particles[mod:GetCaster():GetTeamNumber()], 0, GetGroundPosition(parent:GetAbsOrigin(), nil))
			ParticleManager:SetParticleControl(self.team_particles[mod:GetCaster():GetTeamNumber()], 1, Vector(self.radius,self.radius,self.radius))
		end
	end
end

for id, particle in pairs(self.team_particles) do
	local delete_particle = true
	for _, mod in pairs(parent:FindAllModifiersByName("modifier_truesight")) do
		if mod and mod:GetCaster() then
			if id == mod:GetCaster():GetTeamNumber() then
				delete_particle = false
			end
		end
	end
	if delete_particle then
		ParticleManager:DestroyParticle(particle, true)
		self.team_particles[id] = nil
	end
end

self.count = self.count + self.interval
if self.count >= self.max_count and self.active == false then 
	self.count = 0
	self.active = true

	if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
		self:GetAbility():EndCooldown()

		local particle = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
		ParticleManager:SetParticleControlEnt( particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex(particle)
		self:GetCaster():EmitSound("Sniper.Shrapnel_legendary")
	end
end 

local enemies = FindUnitsInRadius( parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, 0, false )

for _,enemy in pairs(enemies) do
	enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_debuff", { duration = self.stun*(1 - enemy:GetStatusResistance()), tree = tree:entindex(), }  )
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_bushwhack.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, GetGroundPosition(parent:GetAbsOrigin(), nil) )
	ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( particle )
	parent:EmitSound("Hero_Hoodwink.Bushwhack.Impact")
	UTIL_Remove( parent )
	break
end

end

function modifier_hoodwink_bushwhack_custom_trap:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end






modifier_hoodwink_bushwhack_custom_slow = class({})
function modifier_hoodwink_bushwhack_custom_slow:IsHidden() return false end
function modifier_hoodwink_bushwhack_custom_slow:IsPurgable() return true end
function modifier_hoodwink_bushwhack_custom_slow:GetTexture() return "buffs/bush_slow" end
function modifier_hoodwink_bushwhack_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_hoodwink_bushwhack_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end 

function modifier_hoodwink_bushwhack_custom_slow:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf"
end

function modifier_hoodwink_bushwhack_custom_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_hoodwink_bushwhack_custom_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_hoodwink_bushwhack_custom_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end


function modifier_hoodwink_bushwhack_custom_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_5", "slow")

if not IsServer() then return end 

self.particle_peffect = ParticleManager:CreateParticle("particles/generic_gameplay/generic_silenced.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end


function modifier_hoodwink_bushwhack_custom_slow:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
}
end








modifier_hoodwink_bushwhack_custom_damage = class({})
function modifier_hoodwink_bushwhack_custom_damage:IsHidden() return false end
function modifier_hoodwink_bushwhack_custom_damage:IsPurgable() return false end
function modifier_hoodwink_bushwhack_custom_damage:GetTexture() return "buffs/bush_damage" end
function modifier_hoodwink_bushwhack_custom_damage:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_4", "damage")
self.max = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_4", "max")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_4", "heal_reduce")
self.interval = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_4", "interval")

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

if not IsServer() then return end

for i = 1,2 do 
	local effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(effect,false, false, -1, false, false) 
end 

self:SetStackCount(1)
self:UpdateEffect()
self:GetParent():EmitSound("Hoodwink.Poison")
self:StartIntervalThink(self.interval)
end

function modifier_hoodwink_bushwhack_custom_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

self:GetParent():EmitSound("Hoodwink.Poison")
if self:GetStackCount() == self.max then 
	self:GetParent():EmitSound("Hoodwink.Poison_max")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_bushwhack_custom_damage_status", {})
end 

self:UpdateEffect()
end


function modifier_hoodwink_bushwhack_custom_damage:OnIntervalThink()
if not IsServer() then return end 

self.damageTable.damage = self:GetStackCount()*self.damage*self.interval
ApplyDamage(self.damageTable)


if self:GetParent():HasModifier("modifier_hoodwink_sharpshooter_custom_legendary") and self.effect_cast then
	ParticleManager:DestroyParticle(self.effect_cast, true)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	self.effect_cast = nil
end

if not self.effect_cast and not self:GetParent():HasModifier("modifier_hoodwink_sharpshooter_custom_legendary") then 
	self:UpdateEffect()
end 

end 

function modifier_hoodwink_bushwhack_custom_damage:OnDestroy()
if not IsServer() then return end 
self:GetParent():RemoveModifierByName("modifier_hoodwink_bushwhack_custom_damage_status")
end




function modifier_hoodwink_bushwhack_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
   	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_hoodwink_bushwhack_custom_damage:GetModifierLifestealRegenAmplify_Percentage() 
return self:GetStackCount()*self.heal_reduce 
end

function modifier_hoodwink_bushwhack_custom_damage:GetModifierHealAmplify_PercentageTarget() 
return self:GetStackCount()*self.heal_reduce 
end

function modifier_hoodwink_bushwhack_custom_damage:GetModifierHPRegenAmplify_Percentage() 
return self:GetStackCount()*self.heal_reduce 
end

function modifier_hoodwink_bushwhack_custom_damage:OnTooltip()
return self:GetStackCount()*self.damage
end


function modifier_hoodwink_bushwhack_custom_damage:UpdateEffect()
if not IsServer() then return end 
if self:GetParent():HasModifier("modifier_hoodwink_sharpshooter_custom_legendary") then return end

if not self.effect_cast then 
	self.effect_cast = ParticleManager:CreateParticle( "particles/hoodwink/poison_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect_cast,false, false, -1, false, false) 
end

local k1 = 0
local k2 = self:GetStackCount()

if k2 >= 10 then 
    k1 = 1
    k2 = self:GetStackCount() - 10
end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( k1, k2, 0 ) )


end






modifier_hoodwink_bushwhack_custom_vision = class({})
function modifier_hoodwink_bushwhack_custom_vision:IsHidden() return false end
function modifier_hoodwink_bushwhack_custom_vision:IsPurgable() return false end
function modifier_hoodwink_bushwhack_custom_vision:GetTexture() return "buffs/bush_vision" end
function modifier_hoodwink_bushwhack_custom_vision:OnCreated(table)

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_6", "damage_reduce")
self.max = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_6", "max")

if not IsServer() then return end
self.RemoveForDuel = true
self.parent = self:GetParent()
self.caster = self:GetCaster()

self:SetStackCount(1)

if self.parent:IsHero() then 
	self.particle_trail_fx = ParticleManager:CreateParticleForTeam("particles/pa_vendetta.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster:GetTeamNumber())
	self:AddParticle(self.particle_trail_fx, false, false, -1, false, false)
end

self:StartIntervalThink(0.2)
end

function modifier_hoodwink_bushwhack_custom_vision:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer( self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 10, 0.3, false )
end


function modifier_hoodwink_bushwhack_custom_vision:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end


function modifier_hoodwink_bushwhack_custom_vision:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_hoodwink_bushwhack_custom_vision:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*self.damage_reduce
end


function modifier_hoodwink_bushwhack_custom_vision:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount()*self.damage_reduce
end





modifier_hoodwink_bushwhack_custom_tracker = class({})
function modifier_hoodwink_bushwhack_custom_tracker:IsHidden() return true end
function modifier_hoodwink_bushwhack_custom_tracker:IsPurgable() return false end
function modifier_hoodwink_bushwhack_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.damage_duration = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_4", "duration", true)
end

function modifier_hoodwink_bushwhack_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_hoodwink_bushwhack_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end 
if not self.parent:HasModifier("modifier_hoodwink_bush_4") then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end 

params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_hoodwink_bushwhack_custom_damage", {duration = self.damage_duration})
end






modifier_hoodwink_bushwhack_custom_damage_status = class({})
function modifier_hoodwink_bushwhack_custom_damage_status:IsHidden() return true end
function modifier_hoodwink_bushwhack_custom_damage_status:IsPurgable() return false end
function modifier_hoodwink_bushwhack_custom_damage_status:GetStatusEffectName()
return "particles/status_fx/status_effect_poison_venomancer.vpcf"
end

function modifier_hoodwink_bushwhack_custom_damage_status:StatusEffectPriority()
return 9999999
end



modifier_hoodwink_bushwhack_custom_damage_bonus = class({})
function modifier_hoodwink_bushwhack_custom_damage_bonus:IsHidden() return true end
function modifier_hoodwink_bushwhack_custom_damage_bonus:IsPurgable() return false end
function modifier_hoodwink_bushwhack_custom_damage_bonus:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_2", "damage_inc")

if not IsServer() then return end 

self.particle_peffect = ParticleManager:CreateParticle("particles/hoodwink/bush_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end

function modifier_hoodwink_bushwhack_custom_damage_bonus:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_hoodwink_bushwhack_custom_damage_bonus:GetModifierIncomingDamage_Percentage()
return self.damage
end






modifier_hoodwink_bushwhack_custom_heal = class({})
function modifier_hoodwink_bushwhack_custom_heal:IsHidden() return false end
function modifier_hoodwink_bushwhack_custom_heal:IsPurgable() return false end
function modifier_hoodwink_bushwhack_custom_heal:GetTexture() return "buffs/hoodwink_heal" end
function modifier_hoodwink_bushwhack_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_hoodwink_bushwhack_custom_heal:GetModifierHealthRegenPercentage()
    return self.heal
end


function modifier_hoodwink_bushwhack_custom_heal:GetModifierMoveSpeedBonus_Percentage()
    return self.move
end


function modifier_hoodwink_bushwhack_custom_heal:OnCreated()
self.heal = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_3", "heal")/self:GetCaster():GetTalentValue("modifier_hoodwink_bush_3", "duration")
self.move = self:GetCaster():GetTalentValue("modifier_hoodwink_bush_3", "move")
end 

function modifier_hoodwink_bushwhack_custom_heal:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_hoodwink_bushwhack_custom_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


