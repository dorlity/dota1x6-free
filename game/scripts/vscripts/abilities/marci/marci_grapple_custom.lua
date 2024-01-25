LinkLuaModifier("modifier_marci_grapple_custom", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier("modifier_marci_dispose_knockback", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier("modifier_marci_dispose_hits", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_hits_slow", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_jump_slow", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_tracker", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_cast_attack", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_reduction", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_str", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_heal_count", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_slow", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_disarm", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )





marci_grapple_custom = class({})
marci_dispose_knockback = class({})
marci_dispose_hits = class({})
marci_dispose_jump = class({})


marci_grapple_custom.legendary_cd = 1


marci_grapple_custom.slow_move = {-10, -15, -20}
marci_grapple_custom.slow_duration = {1, 1.5, 2}



marci_grapple_custom.heal_chance = {30, 50}
marci_grapple_custom.heal_health = 0.05
marci_grapple_custom.heal_damage = 1
marci_grapple_custom.heal_radius = 300




function marci_grapple_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_attack_blur_l01.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_attack_blur_r01.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_attack_blur_r02.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_attack_blur_kick01.vpcf', context )



PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_dispose_land_aoe.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_dispose_aoe_damage.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_dispose_debuff.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_grapple.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_buff.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_attack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_monkey_king_spring_slow.vpcf', context )
PrecacheResource( "particle", 'particles/marci_heal.vpcf', context )
PrecacheResource( "particle", 'particles/marci_wave.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_snapfire_slow.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf', context )

end




function marci_grapple_custom:GetIntrinsicModifierName()
	return "modifier_marci_dispose_tracker"
end





function marci_grapple_custom:GetAOERadius()
	return self:GetSpecialValueFor("landing_radius")
end



function marci_grapple_custom:GetDisposeDamage(damage_k)
if not IsServer() then return end

local damage = self:GetSpecialValueFor("impact_damage")

if self:GetCaster():HasModifier("modifier_marci_dispose_1") then 
	damage = damage + self:GetCaster():GetStrength()*self:GetCaster():GetTalentValue("modifier_marci_dispose_1", "damage")/100
end

return damage*(damage_k/100)

end


function marci_grapple_custom:StartSkillsCD(name)
if not IsServer() then return end
if true then return end

local skill_array = {}
skill_array[1] = self:GetCaster():FindAbilityByName("marci_grapple_custom")
skill_array[2] = self:GetCaster():FindAbilityByName("marci_dispose_hits")
skill_array[3] = self:GetCaster():FindAbilityByName("marci_dispose_jump")
skill_array[4] = self:GetCaster():FindAbilityByName("marci_dispose_knockback")

for i = 1,#skill_array do 

	if skill_array[i]:GetName() ~= name then 

		local cd = skill_array[i]:GetCooldownTimeRemaining()
		if cd < self.legendary_cd then 
			skill_array[i]:EndCooldown()
			skill_array[i]:StartCooldown(self.legendary_cd)
		end
	end
end



end

function marci_grapple_custom:GetCastRange(vLocation, hTarget)
local upgrade = 0

if self:GetCaster():HasShard() then 
  upgrade = self:GetSpecialValueFor("shard_range")
end

 return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end








function marci_grapple_custom:OnSpellStart(new_target)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local original_target = self:GetCursorTarget()

	if new_target then 
		original_target = new_target
	end

	self:StartSkillsCD(self:GetName())

	if original_target:TriggerSpellAbsorb( self ) then return end

	local duration = self:GetSpecialValueFor( "air_duration" )
	local height = self:GetSpecialValueFor( "air_height" )
	local distance = self:GetSpecialValueFor( "throw_distance_behind" )
	local radius = self:GetSpecialValueFor( "landing_radius" )
	local stun = self:GetSpecialValueFor( "slow_duration" )

	if self:GetCaster():HasModifier("modifier_marci_dispose_2") then 
		stun = stun + self.slow_duration[self:GetCaster():GetUpgradeStack("modifier_marci_dispose_2")]
	end


	if self:GetCaster():HasModifier("modifier_marci_dispose_5") then 
		self:GetCaster():RemoveModifierByName("modifier_marci_dispose_str")
		original_target:RemoveModifierByName("modifier_marci_dispose_str")

		local str = self:GetCaster():GetStrength()*self:GetCaster():GetTalentValue("modifier_marci_dispose_5", "str")/100
		local str_duration = self:GetCaster():GetTalentValue("modifier_marci_dispose_5", "duration")

		if original_target:IsHero() then 
			str = original_target:GetStrength()*self:GetCaster():GetTalentValue("modifier_marci_dispose_5", "str")/100
			local mod = original_target:AddNewModifier(self:GetCaster(), self, "modifier_marci_dispose_str", {duration = str_duration})
			
			mod:SetStackCount(str)
			original_target:CalculateStatBonus(true)
		end

		local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_marci_dispose_str", {duration = str_duration})
			
		mod:SetStackCount(str)
		self:GetCaster():CalculateStatBonus(true)
	end

	local targetpos = caster:GetOrigin() - caster:GetForwardVector() * distance


	local targets = FindUnitsInRadius( caster:GetTeamNumber(), original_target:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		
	for _,target in pairs(targets) do 

		local totaldist = (target:GetOrigin() - targetpos):Length2D()
		if target:IsCreep() then 
			totaldist = 0
		end

		local arc = target:AddNewModifier( caster, self, "modifier_marci_grapple_custom", { target_x = targetpos.x, target_y = targetpos.y, duration = duration, distance = totaldist, height = height, fix_end = false, fix_duration = false, isStun = true, isForward = true, activity = ACT_DOTA_FLAIL, } )
		

		arc:SetEndCallback( function()
		
			local damageTable = {victim = target, attacker = caster, damage = self:GetDisposeDamage(100), damage_type = DAMAGE_TYPE_MAGICAL, ability = self }

			target:AddNewModifier( caster, self, "modifier_marci_dispose_slow", { duration = stun*(1 - target:GetStatusResistance()) } )

			if caster:HasShard() then 
				target:AddNewModifier(caster, self, "modifier_stunned", {duration = (1 - target:GetStatusResistance())*self:GetSpecialValueFor("shard_stun")})
			end

			ApplyDamage(damageTable)

			self:PlayEffects2( target:GetOrigin() )
		

			GridNav:DestroyTreesAroundPoint( target:GetOrigin(), radius, false )

			local allied = target:GetTeamNumber()==caster:GetTeamNumber()
			self:PlayEffects1( target:GetOrigin(), radius, allied )



			if self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_marci_unleash_custom") and target == original_target then
				local ability = self:GetCaster():FindAbilityByName("marci_unleash_custom")
				ability:Pulse(target:GetAbsOrigin(), nil)
			end
		end)

		self:PlayEffects3( caster, target, duration )
		self:PlayEffects4( caster )
	end
end

function marci_grapple_custom:PlayEffects1( point, radius, allied )
	local sound_cast = "Hero_Marci.Grapple.Impact"
	if allied then
		sound_cast = "Hero_Marci.Grapple.Impact.Ally"
	end
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_dispose_land_aoe.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, point )
	ParticleManager:SetParticleControl( particle, 1, Vector(radius, 0, 0) )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

function marci_grapple_custom:PlayEffects2( point )
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_dispose_aoe_damage.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 1, point )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
	EmitSoundOnLocationWithCaster( point, "Hero_Marci.Grapple.Stun", self:GetCaster() )
end

function marci_grapple_custom:PlayEffects3( caster, target, duration )
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_dispose_debuff.vpcf", PATTACH_POINT_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( particle, 5, Vector( duration, 0, 0 ) )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
	target:EmitSound("Hero_Marci.Grapple.Target")
end

function marci_grapple_custom:PlayEffects4( caster )
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_grapple.vpcf", PATTACH_POINT_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
	caster:EmitSound("Hero_Marci.Grapple.Cast")
end


modifier_marci_grapple_custom = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_marci_grapple_custom:IsHidden()
	return true
end

function modifier_marci_grapple_custom:IsDebuff()
	return false
end

function modifier_marci_grapple_custom:IsStunDebuff()
	return false
end

function modifier_marci_grapple_custom:IsPurgable()
	return true
end

function modifier_marci_grapple_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_marci_grapple_custom:OnCreated( kv )
	if not IsServer() then return end
	self.interrupted = false
	self:SetJumpParameters( kv )
	self:Jump()
end

function modifier_marci_grapple_custom:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_grapple_custom:OnRemoved()
end

function modifier_marci_grapple_custom:OnDestroy()
	if not IsServer() then return end

	-- preserve height
	local pos = self:GetParent():GetOrigin()

	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )

	-- preserve height if has end offset
	if self.end_offset~=0 then
		self:GetParent():SetOrigin( pos )
	end

	if self.endCallback then
		self.endCallback( self.interrupted )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_marci_grapple_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
	if self:GetStackCount()>0 then
		table.insert( funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION )
	end

	return funcs
end

function modifier_marci_grapple_custom:GetModifierDisableTurning()
	if not self.isForward then return end
	return 1
end
function modifier_marci_grapple_custom:GetOverrideAnimation()
	return self:GetStackCount()
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_marci_grapple_custom:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.isStun or false,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = self.isRestricted or false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_marci_grapple_custom:UpdateHorizontalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end

	-- set relative position
	local pos = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( pos )
end

function modifier_marci_grapple_custom:UpdateVerticalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end

	local pos = me:GetOrigin()
	local time = self:GetElapsedTime()

	-- set relative position
	local height = pos.z
	local speed = self:GetVerticalSpeed( time )
	pos.z = height + speed * dt
	me:SetOrigin( pos )

	if not self.fix_duration then
		local ground = GetGroundHeight( pos, me ) + self.end_offset
		if pos.z <= ground then

			-- below ground, set height as ground then destroy
			pos.z = ground
			me:SetOrigin( pos )
			self:Destroy()
		end
	end
end

function modifier_marci_grapple_custom:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_marci_grapple_custom:OnVerticalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Motion Helper
function modifier_marci_grapple_custom:SetJumpParameters( kv )
	self.parent = self:GetParent()

	-- load types
	self.fix_end = true
	self.fix_duration = true
	self.fix_height = true
	if kv.fix_end then
		self.fix_end = kv.fix_end==1
	end
	if kv.fix_duration then
		self.fix_duration = kv.fix_duration==1
	end
	if kv.fix_height then
		self.fix_height = kv.fix_height==1
	end

	-- load other types
	self.isStun = kv.isStun==1
	self.isRestricted = kv.isRestricted==1
	self.isForward = kv.isForward==1
	self.activity = kv.activity or 0
	self:SetStackCount( self.activity )

	-- load direction
	if kv.target_x and kv.target_y then
		local origin = self.parent:GetOrigin()
		local dir = Vector( kv.target_x, kv.target_y, 0 ) - origin
		dir.z = 0
		dir = dir:Normalized()
		self.direction = dir
	end
	if kv.dir_x and kv.dir_y then
		self.direction = Vector( kv.dir_x, kv.dir_y, 0 ):Normalized()
	end
	if not self.direction then
		self.direction = self.parent:GetForwardVector()
	end

	-- load horizontal data
	self.duration = kv.duration
	self.distance = kv.distance
	self.speed = kv.speed
	if not self.duration then
		self.duration = self.distance/self.speed
	end
	if not self.distance then
		self.speed = self.speed or 0
		self.distance = self.speed*self.duration
	end
	if not self.speed then
		self.distance = self.distance or 0
		self.speed = self.distance/self.duration
	end

	-- load vertical data
	self.height = kv.height or 0
	self.start_offset = kv.start_offset or 0
	self.end_offset = kv.end_offset or 0

	-- calculate height positions
	local pos_start = self.parent:GetOrigin()
	local pos_end = pos_start + self.direction * self.distance
	local height_start = GetGroundHeight( pos_start, self.parent ) + self.start_offset
	local height_end = GetGroundHeight( pos_end, self.parent ) + self.end_offset
	local height_max

	-- determine jumping height if not fixed
	if not self.fix_height then
	
		-- ideal height is proportional to max distance
		self.height = math.min( self.height, self.distance/4 )
	end

	-- determine height max
	if self.fix_end then
		height_end = height_start
		height_max = height_start + self.height
	else
		-- calculate height
		local tempmin, tempmax = height_start, height_end
		if tempmin>tempmax then
			tempmin,tempmax = tempmax, tempmin
		end
		local delta = (tempmax-tempmin)*2/3

		height_max = tempmin + delta + self.height
	end

	-- set duration
	if not self.fix_duration then
		self:SetDuration( -1, false )
	else
		self:SetDuration( self.duration, true )
	end

	-- calculate arc
	self:InitVerticalArc( height_start, height_max, height_end, self.duration )
end

function modifier_marci_grapple_custom:Jump()
	-- apply horizontal motion
	if self.distance>0 then
		if not self:ApplyHorizontalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end

	-- apply vertical motion
	if self.height>0 then
		if not self:ApplyVerticalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end
end

function modifier_marci_grapple_custom:InitVerticalArc( height_start, height_max, height_end, duration )
	local height_end = height_end - height_start
	local height_max = height_max - height_start

	-- fail-safe1: height_max cannot be smaller than height delta
	if height_max<height_end then
		height_max = height_end+0.01
	end

	-- fail-safe2: height-max must be positive
	if height_max<=0 then
		height_max = 0.01
	end

	-- math magic
	local duration_end = ( 1 + math.sqrt( 1 - height_end/height_max ) )/2
	self.const1 = 4*height_max*duration_end/duration
	self.const2 = 4*height_max*duration_end*duration_end/(duration*duration)
end

function modifier_marci_grapple_custom:GetVerticalPos( time )
	return self.const1*time - self.const2*time*time
end

function modifier_marci_grapple_custom:GetVerticalSpeed( time )
	return self.const1 - 2*self.const2*time
end

function modifier_marci_grapple_custom:SetEndCallback( func )
	self.endCallback = func
end









function marci_dispose_hits:GetChannelTime()
return self:GetSpecialValueFor("duration")
end


function marci_dispose_hits:OnSpellStart()
if not IsServer() then return end
local main = self:GetCaster():FindAbilityByName("marci_grapple_custom")
main:StartSkillsCD(self:GetName())


local point = self:GetCursorPosition()

local dir = point - self:GetCaster():GetAbsOrigin()

dir.z = 0

self:GetCaster():FaceTowards(point)
self:GetCaster():SetForwardVector(dir:Normalized())


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_marci_dispose_hits", {duration = self:GetSpecialValueFor("duration")})


if self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_marci_unleash_custom") then
	local ability = self:GetCaster():FindAbilityByName("marci_unleash_custom")
	ability:Pulse(self:GetCaster():GetAbsOrigin(), nil)
end
end


function marci_dispose_hits:OnChannelFinish(bInterrupted)
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_marci_dispose_hits")

end

modifier_marci_dispose_hits = class({})

function modifier_marci_dispose_hits:IsHidden() return true end
function modifier_marci_dispose_hits:IsPurgable() return false end
function modifier_marci_dispose_hits:OnCreated(table)
if not IsServer() then return end

self.main = self:GetParent():FindAbilityByName("marci_grapple_custom")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.distance = self:GetAbility():GetSpecialValueFor("distance")
self.width = self:GetAbility():GetSpecialValueFor("width")
self.interval = self:GetAbility():GetSpecialValueFor("interval")
self.slow_duration = self:GetAbility():GetSpecialValueFor("slow_duration")

local main = self:GetCaster():FindAbilityByName("marci_grapple_custom")

if self:GetCaster():HasShard() and main then 
  self.distance = self.distance + main:GetSpecialValueFor("shard_range")
end


local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "eye_l", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "eye_r", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 6, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
self:AddParticle( particle, false, false, -1, false, false  )


 self.main:PlayEffects4( self:GetCaster() )


self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end



function modifier_marci_dispose_hits:OnIntervalThink()
if not IsServer() then return end
self:SetStackCount(self:GetStackCount() + 1)
self:GetParent():FadeGesture(ACT_DOTA_ATTACK)
self:GetParent():StartGesture(ACT_DOTA_ATTACK)

self:GetParent():EmitSound("Marci.Dispose_hits_pre")

self.target_abs = self:GetParent():GetForwardVector()*self.distance + self:GetParent():GetAbsOrigin()

local k1 = RandomFloat(0.2, 0.9)
local k2 = RandomFloat(0.2, 0.9)

local particle_abs = self.target_abs
particle_abs.z = particle_abs.z + 100

local particle_1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( particle_1, 1, particle_abs)
ParticleManager:DestroyParticle(particle_1, false)
ParticleManager:ReleaseParticleIndex( particle_1 )


particle_abs = self:GetParent():GetForwardVector()*(self.distance*k1) + self:GetParent():GetAbsOrigin()
particle_abs.z = particle_abs.z + 100


local particle_2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( particle_2, 1, particle_abs)
ParticleManager:DestroyParticle(particle_2, false)
ParticleManager:ReleaseParticleIndex( particle_2 )


particle_abs = self:GetParent():GetForwardVector()*(self.distance*k2) + self:GetParent():GetAbsOrigin()
particle_abs.z = particle_abs.z + 100


--local particle_3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
--ParticleManager:SetParticleControl( particle_3, 1, particle_abs)
--ParticleManager:ReleaseParticleIndex( particle_3 )


local damageTable = { attacker = self:GetCaster(), damage = self.main:GetDisposeDamage(self.damage), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() }
local attack = FindUnitsInLine(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin() , self.target_abs , nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)

for _,enemy in pairs(attack) do 
	damageTable.victim = enemy
	ApplyDamage(damageTable)

	enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_marci_dispose_hits_slow", {duration = self.slow_duration})

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )

	enemy:EmitSound("Marci.Dispose_hits")
end


end



modifier_marci_dispose_hits_slow = class({})
function modifier_marci_dispose_hits_slow:IsHidden() return false end
function modifier_marci_dispose_hits_slow:IsPurgable() return false end
function modifier_marci_dispose_hits_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end




function modifier_marci_dispose_hits_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack
end


function modifier_marci_dispose_hits_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move
end


function modifier_marci_dispose_hits_slow:OnCreated(table)
self.move = self:GetAbility():GetSpecialValueFor("slow")
self.attack = self:GetAbility():GetSpecialValueFor("slow_attack")

if not IsServer() then return end
if not self:GetParent():IsRealHero() or self:GetCaster():GetQuest() ~= "Marci.Quest_5" or self:GetCaster():QuestCompleted() then return end

self:StartIntervalThink(0.1)
end


function modifier_marci_dispose_hits_slow:OnIntervalThink()
if not IsServer() then return end

self:GetCaster():UpdateQuest(0.1)
end










function marci_dispose_jump:GetCastRange(vLocation, hTarget)
if IsClient() then 

	local main = self:GetCaster():FindAbilityByName("marci_grapple_custom")

	if self:GetCaster():HasShard() and main then 
	  return self:GetSpecialValueFor("distance") + main:GetSpecialValueFor("shard_range")
	end


	return self:GetSpecialValueFor("distance")
end
return 999999
end

function marci_dispose_jump:OnSpellStart()
if not IsServer() then return end

local main = self:GetCaster():FindAbilityByName("marci_grapple_custom")
main:StartSkillsCD(self:GetName())

main:PlayEffects4( self:GetCaster() )

self.radius = self:GetSpecialValueFor("radius")
self.distance = self:GetSpecialValueFor("distance")
self.duration_jump = self:GetSpecialValueFor("duration_jump")
self.damage = self:GetSpecialValueFor("damage")


local main = self:GetCaster():FindAbilityByName("marci_grapple_custom")

if self:GetCaster():HasShard() and main then 
  self.distance = self.distance + main:GetSpecialValueFor("shard_range")
end



local point = self:GetCursorPosition()
if point == self:GetCaster():GetAbsOrigin() then 
	point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*10
end

local dir = (point - self:GetCaster():GetAbsOrigin()):Normalized()

self:GetCaster():SetForwardVector(dir)
self:GetCaster():FaceTowards(point)

local dis = math.min(self.distance, (point - self:GetCaster():GetAbsOrigin()):Length2D())
local speed = self.distance/self.duration_jump

local dur = (dis/speed)

local hei = 60
if dis < 100 then 
	hei = 0
end 

local arc = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_generic_arc_marci",
	{ 
	dir_x = self:GetCaster():GetForwardVector().x,
	dir_y = self:GetCaster():GetForwardVector().y,
	duration = dur,
	distance = dis,
	height = hei,
	fix_end = false,
	isStun = true,
	isForward = true,
	activity = ACT_DOTA_OVERRIDE_ABILITY_2,
})
	
arc:SetEndCallback( function( interrupted )

	self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END,1)

	self.target = self:GetCaster():GetAbsOrigin()

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.target, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		
	local damageTable = { attacker = self:GetCaster(), damage = main:GetDisposeDamage(self.damage), damage_type = DAMAGE_TYPE_MAGICAL, ability = self, }
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun")*(1 - enemy:GetStatusResistance())})
	end



	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, self.target )
	ParticleManager:SetParticleControl( particle, 1, Vector(self.radius*1.4,self.radius*1.4,self.radius*1.4) )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.target )
	ParticleManager:SetParticleControl( effect_cast, 1, self.target )
	ParticleManager:SetParticleControl( effect_cast, 9, Vector(self.radius, self.radius, self.radius) )
	ParticleManager:SetParticleControl( effect_cast, 10, self.target )
	ParticleManager:DestroyParticle(effect_cast, false)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( self.target, "Hero_Marci.Rebound.Impact", self:GetCaster() )


	if self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_marci_unleash_custom") then
		local ability = self:GetCaster():FindAbilityByName("marci_unleash_custom")
		ability:Pulse(self:GetCaster():GetAbsOrigin(), nil)
	end
end)


end



	
modifier_marci_dispose_jump_slow = class({})
function modifier_marci_dispose_jump_slow:IsHidden() return false end
function modifier_marci_dispose_jump_slow:IsPurgable() return true end

function modifier_marci_dispose_jump_slow:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf"
end

function modifier_marci_dispose_jump_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_marci_dispose_jump_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_monkey_king_spring_slow.vpcf"
end

function modifier_marci_dispose_jump_slow:StatusEffectPriority()
	return 11111
end


function modifier_marci_dispose_jump_slow:OnCreated(table)
self.incoming_damage = self:GetAbility():GetSpecialValueFor("incoming_dmg")

end

function modifier_marci_dispose_jump_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
}
end




function modifier_marci_dispose_jump_slow:GetModifierIncomingDamage_Percentage()
return self.incoming_damage
end






function marci_dispose_knockback:GetCastRange(vLocation, hTarget)
local upgrade = 0


local main = self:GetCaster():FindAbilityByName("marci_grapple_custom")

if self:GetCaster():HasShard() and main then 
  upgrade = main:GetSpecialValueFor("shard_range")
end

 return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function marci_dispose_knockback:OnSpellStart()
if not IsServer() then return end
local main = self:GetCaster():FindAbilityByName("marci_grapple_custom")
main:StartSkillsCD(self:GetName())

local target = self:GetCursorTarget()


for i = 1,2 do 
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end

local duration = self:GetSpecialValueFor("duration")*(1 - target:GetStatusResistance())

target:AddNewModifier(self:GetCaster(), self, "modifier_marci_dispose_knockback", {duration = duration,  x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y})
	

local damageTable = {victim = target, attacker = self:GetCaster(), damage = main:GetDisposeDamage(self:GetSpecialValueFor("init_damage")), damage_type = DAMAGE_TYPE_MAGICAL, ability = self }
ApplyDamage(damageTable)


if self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_marci_unleash_custom") then
	local ability = self:GetCaster():FindAbilityByName("marci_unleash_custom")
	ability:Pulse(target:GetAbsOrigin(), nil)
end


end







modifier_marci_dispose_knockback = class({})


function modifier_marci_dispose_knockback:IsHidden() return true end

function modifier_marci_dispose_knockback:OnCreated(params)
  if not IsServer() then return end
  
  self.ability        = self:GetAbility()
  self.caster         = self:GetCaster()
  self.parent         = self:GetParent()
  self.main 		  = self:GetCaster():FindAbilityByName("marci_grapple_custom")

  self:GetParent():StartGesture(ACT_DOTA_FLAIL)
  self.tree_stun = false

  self.knockback_duration   = self.ability:GetSpecialValueFor("duration")

  self.main:PlayEffects3( self:GetCaster(), self.parent, self.knockback_duration )
  self.main:PlayEffects4( self:GetCaster() )
  self.radius = self:GetAbility():GetSpecialValueFor("radius")

  self.distance = self.ability:GetSpecialValueFor("distance")
  self.min_distance = self.ability:GetSpecialValueFor("min_distance")
  self.stun= self.ability:GetSpecialValueFor("stun")


  self.knockback_distance   = math.max((self.distance  + self.min_distance)  - (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D(), self.min_distance)
  
  self.knockback_speed    = self.knockback_distance / self.knockback_duration
  
  self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)
  
  if self:ApplyHorizontalMotionController() == false then 
    self:Destroy()
    return
  end
end

function modifier_marci_dispose_knockback:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

local distance = (me:GetOrigin() - self.position):Normalized()
  
me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )



if self:GetParent():IsCreep() then 
	self.tree_stun = true
end


local tree_radius = 120
local wall_radius = 50
local building_radius = 30

local thinkers = Entities:FindAllByClassnameWithin( "npc_dota_thinker", self.parent:GetOrigin(), wall_radius )
for _,thinker in pairs(thinkers) do
	if thinker:IsPhantomBlocker() then
		self.tree_stun = true
	end
end

local base_loc = GetGroundPosition( self.parent:GetOrigin(), self.parent )
local search_loc = GetGroundPosition( base_loc + distance*(wall_radius), self.parent )


if search_loc.z-base_loc.z>10 and (not GridNav:IsTraversable( search_loc )) then
	self.tree_stun = true
end

if GridNav:IsNearbyTree( self.parent:GetOrigin(), tree_radius, false) then
	self.tree_stun = true
end

local buildings = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self.parent:GetOrigin(), nil, building_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

if #buildings>0 then
	self.tree_stun = true
end



if self.tree_stun == true then 
	self:Destroy()
	return
end

end




function modifier_marci_dispose_knockback:DeclareFunctions()
  local decFuncs = {
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return decFuncs
end

function modifier_marci_dispose_knockback:GetOverrideAnimation()
   return ACT_DOTA_FLAIL
end


function modifier_marci_dispose_knockback:CheckState()
  return
   {
   	[MODIFIER_STATE_STUNNED] = true
   }
end

function modifier_marci_dispose_knockback:OnDestroy()
  if not IsServer() then return end
 self.parent:RemoveHorizontalMotionController( self )
  self:GetParent():FadeGesture(ACT_DOTA_FLAIL)

if self.tree_stun then 

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	local damageTable = { attacker = self:GetCaster(), damage = self.main:GetDisposeDamage(self:GetAbility():GetSpecialValueFor("tree_damage")), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() }
	
	self.main:PlayEffects1(self:GetParent():GetAbsOrigin(), self.radius, false )

	for _,enemy in pairs(enemies) do

		damageTable.victim = enemy

		enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun*(1 - enemy:GetStatusResistance())})

	 	self.main:PlayEffects2(enemy:GetAbsOrigin())


		ApplyDamage(damageTable)
	end
end

end







marci_dispose_swap = class({})


function marci_dispose_swap:OnSpellStart()
if not IsServer() then return end
--self:EndCooldown()
--self:StartCooldown(1)


EmitSoundOnEntityForPlayer("Marci.Dispose_swap", self:GetCaster(), self:GetCaster():GetPlayerOwnerID())

local skill_array = {}
skill_array[1] = self:GetCaster():FindAbilityByName("marci_grapple_custom")
skill_array[2] = self:GetCaster():FindAbilityByName("marci_dispose_jump")
skill_array[3] = self:GetCaster():FindAbilityByName("marci_dispose_knockback")
skill_array[4] = self:GetCaster():FindAbilityByName("marci_dispose_hits")

for i = 1,#skill_array do 
	if skill_array[i]:IsHidden() == false then

		local n = i + 1
		if n > #skill_array then 
			n = 1
		end

		self:GetCaster():SwapAbilities(skill_array[i]:GetName(), skill_array[n]:GetName(), false, true)
		break
	end
end


end


modifier_marci_dispose_tracker = class({})
function modifier_marci_dispose_tracker:IsHidden() return true end
function modifier_marci_dispose_tracker:IsPurgable() return false end

function modifier_marci_dispose_tracker:OnCreated(table)
if not IsServer() then return end
self.skill_table = {
	["marci_grapple_custom"] = true,
	["marci_companion_run_custom"] = true,
	["marci_guardian_custom"] = true,
	["marci_unleash_custom"] = true,
	["marci_dispose_hits"] = true,
	["marci_dispose_jump"] = true,
	["marci_dispose_knockback"] = true,
}

end



function modifier_marci_dispose_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE
}
end



function modifier_marci_dispose_tracker:GetModifierPercentageManacost()
local reduce = 0

if self:GetCaster():HasModifier("modifier_marci_dispose_6") then 
	reduce = self:GetCaster():GetTalentValue("modifier_marci_dispose_6", "mana")
end

return reduce
end




function modifier_marci_dispose_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.target:IsMagicImmune() then return end
if not self:GetParent():HasModifier("modifier_marci_dispose_3") then return end

local chance = self:GetCaster():GetTalentValue("modifier_marci_dispose_3", "chance")

local random = RollPseudoRandomPercentage(chance,101,self:GetParent())
if not random then return end

local damageTable = {victim = params.target, attacker = self:GetParent(), damage = self:GetAbility():GetDisposeDamage(self:GetCaster():GetTalentValue("modifier_marci_dispose_3", "damage")), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() }
ApplyDamage(damageTable)
params.target:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_marci_dispose_slow", { duration = self:GetCaster():GetTalentValue("modifier_marci_dispose_3", "duration")*(1 - params.target:GetStatusResistance()) } )

		
self:GetAbility():PlayEffects1( params.target:GetOrigin(), 150, false )


end





function modifier_marci_dispose_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if not self.skill_table[params.ability:GetName()] then return end

if self:GetParent():HasModifier("modifier_marci_dispose_6") then
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_marci_dispose_cast_attack", {duration = self:GetCaster():GetTalentValue("modifier_marci_dispose_6", "duration")})
end

if self:GetParent():HasModifier("modifier_marci_dispose_4") then 

	local chance = self:GetAbility().heal_chance[self:GetCaster():GetUpgradeStack("modifier_marci_dispose_4")]


	if RollPseudoRandomPercentage(chance,27,self:GetParent()) then 

		local heal = self:GetParent():GetMaxHealth()*self:GetAbility().heal_health

		self:GetParent():Heal(heal, self:GetAbility())
		SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), heal, nil)
		self:GetParent():EmitSound("Marci.Dispose_heal")

		local particle = ParticleManager:CreateParticle( "particles/marci_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )
		ParticleManager:DestroyParticle(particle, false)
		ParticleManager:ReleaseParticleIndex( particle )

		local wave_particle = ParticleManager:CreateParticle( "particles/marci_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:SetParticleControl( wave_particle, 1, self:GetCaster():GetAbsOrigin() )
		ParticleManager:DestroyParticle(wave_particle, false)
		ParticleManager:ReleaseParticleIndex(wave_particle)

		local damageTable = {attacker = self:GetParent(), damage = heal, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() }


		local targets = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().heal_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
		for _,target in pairs(targets) do 
			damageTable.victim = target
			ApplyDamage(damageTable)
			SendOverheadEventMessage(target, 4, target, heal, nil)
		end

	end

end




end



modifier_marci_dispose_cast_attack = class({})
function modifier_marci_dispose_cast_attack:IsHidden() return false end
function modifier_marci_dispose_cast_attack:IsPurgable() return false end
function modifier_marci_dispose_cast_attack:GetTexture() return "buffs/dispose_combo" end
function modifier_marci_dispose_cast_attack:OnCreated(table)


self.move = self:GetCaster():GetTalentValue("modifier_marci_dispose_6", "move")
self.status = self:GetCaster():GetTalentValue("modifier_marci_dispose_6", "status")
if not IsServer() then return end
	local particle = ParticleManager:CreateParticle( "particles/items4_fx/ascetic_cap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle( particle, false, false, -1, false, false  )
end








function modifier_marci_dispose_cast_attack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end



function modifier_marci_dispose_cast_attack:GetModifierStatusResistanceStacking()
return self.status
end

function modifier_marci_dispose_cast_attack:GetModifierMoveSpeedBonus_Percentage()
return self.move
end





modifier_marci_dispose_str = class({})
function modifier_marci_dispose_str:IsHidden() return false end
function modifier_marci_dispose_str:IsPurgable() return false end
function modifier_marci_dispose_str:GetTexture() return "buffs/dispose_str" end
function modifier_marci_dispose_str:OnCreated(table)

self.k = 1
if self:GetCaster() ~= self:GetParent() then 
	self.k = -1
end

if not IsServer() then return end
self.RemoveForDuel = true

end

function modifier_marci_dispose_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end


function modifier_marci_dispose_str:GetModifierBonusStats_Strength()
return self.k*self:GetStackCount()
end










modifier_marci_companion_run_custom_buff = class({})

function modifier_marci_companion_run_custom_buff:IsHidden()
	return false
end

function modifier_marci_companion_run_custom_buff:IsDebuff()
	return false
end

function modifier_marci_companion_run_custom_buff:IsPurgable()
	return true
end

function modifier_marci_companion_run_custom_buff:OnCreated( kv )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "ally_movespeed_pct" )
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Marci.Rebound.Ally")
end

function modifier_marci_companion_run_custom_buff:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_companion_run_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_marci_companion_run_custom_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

function modifier_marci_companion_run_custom_buff:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end
function modifier_marci_companion_run_custom_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_marci_dispose_slow = class({})

function modifier_marci_dispose_slow:IsHidden()
	return false
end

function modifier_marci_dispose_slow:IsDebuff()
	return true
end

function modifier_marci_dispose_slow:IsPurgable()
	return true
end

function modifier_marci_dispose_slow:OnCreated( kv )
self.ms_slow = -self:GetAbility():GetSpecialValueFor( "slow_move" )
if self:GetCaster():HasModifier("modifier_marci_dispose_2") then 
	self.ms_slow = self.ms_slow + self:GetAbility().slow_move[self:GetCaster():GetUpgradeStack("modifier_marci_dispose_2")]
end

if not IsServer() then return end
if not self:GetParent():IsRealHero() or self:GetCaster():GetQuest() ~= "Marci.Quest_5" or self:GetCaster():QuestCompleted() then return end

self:StartIntervalThink(0.1)
end


function modifier_marci_dispose_slow:OnIntervalThink()
if not IsServer() then return end

self:GetCaster():UpdateQuest(0.1)
end




function modifier_marci_dispose_slow:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_dispose_slow:DeclareFunctions()
return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,	
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
}
end






function modifier_marci_dispose_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_marci_dispose_slow:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf"
end

function modifier_marci_dispose_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_marci_dispose_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_marci_dispose_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end



modifier_marci_dispose_disarm = class({})
function modifier_marci_dispose_disarm:IsHidden() return true end
function modifier_marci_dispose_disarm:IsPurgable() return true end

function modifier_marci_dispose_disarm:GetEffectName()
  return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
end

function modifier_marci_dispose_disarm:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end

function modifier_marci_dispose_disarm:CheckState()
  return {[MODIFIER_STATE_DISARMED] = true}
end