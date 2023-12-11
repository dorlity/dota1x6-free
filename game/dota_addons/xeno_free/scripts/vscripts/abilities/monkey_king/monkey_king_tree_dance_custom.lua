LinkLuaModifier( "modifier_monkey_king_tree_dance_custom_jump", "abilities/monkey_king/monkey_king_tree_dance_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_monkey_king_tree_dance_custom", "abilities/monkey_king/monkey_king_tree_dance_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_monkey_king_tree_dance_custom_cooldown", "abilities/monkey_king/monkey_king_tree_dance_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_monkey_king_tree_dance_shield", "abilities/monkey_king/monkey_king_tree_dance_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_monkey_king_tree_dance_vision", "abilities/monkey_king/monkey_king_tree_dance_custom", LUA_MODIFIER_MOTION_NONE )

monkey_king_tree_dance_custom = class({})






function monkey_king_tree_dance_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf', context )

end


function monkey_king_tree_dance_custom:GetCastRange(location, target)

local bonus = 0

if self:GetCaster():HasModifier("modifier_monkey_king_tree_3") then
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_3", "range")
end
return (self:GetSpecialValueFor( "perched_jump_distance" ) + bonus)
end



function monkey_king_tree_dance_custom:GetIntrinsicModifierName()
	return "modifier_monkey_king_tree_dance_custom_cooldown"
end




function monkey_king_tree_dance_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_monkey_king_tree_3") then 
  bonus = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_3", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end




function monkey_king_tree_dance_custom:OnSpellStart()
if not IsServer() then return end

local tree = self:GetCursorTarget()
if not self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") then 
	self.ability = self:GetCaster():FindAbilityByName("monkey_king_primal_spring_custom")
	self.ability:SetActivated(true)
end

local speed = self:GetSpecialValueFor( "leap_speed" ) + 200
local perched_spot_height = 256
local distance = (tree:GetOrigin()-self:GetCaster():GetOrigin()):Length2D()
local duration = distance / speed

local perch = 0

if self:GetCaster():HasModifier("modifier_monkey_king_tree_dance_custom") then
	perch = 1
end

local modifier = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_monkey_king_tree_dance_custom_jump", { target_x = tree:GetOrigin().x, target_y = tree:GetOrigin().y, distance = distance, speed = speed, height = perched_spot_height, fix_end = false, fix_height = false, isStun = true, activity = ACT_DOTA_MK_TREE_SOAR, start_offset = perched_spot_height*perch, end_offset = perched_spot_height } )

if modifier then
	modifier:SetEndCallback(function()
		if tree and not tree:IsNull() then 
			self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_monkey_king_tree_dance_custom", { tree = tree:entindex() } )
		else 
			FindClearSpaceForUnit(self:GetCaster(), self:GetCaster():GetAbsOrigin(), false)
		end
	end)

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	modifier:AddParticle( particle, false, false, -1, false, false )
	self:GetCaster():EmitSound("Hero_MonkeyKing.TreeJump.Cast")
end

self:StartCooldown(duration + self:GetCooldown(self:GetLevel()))

end

modifier_monkey_king_tree_dance_custom_cooldown = class({})

function modifier_monkey_king_tree_dance_custom_cooldown:IsHidden() return true end
function modifier_monkey_king_tree_dance_custom_cooldown:IsPurgable() return false end
function modifier_monkey_king_tree_dance_custom_cooldown:RemoveOnDeath() return false end

function modifier_monkey_king_tree_dance_custom_cooldown:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_monkey_king_tree_dance_custom_cooldown:OnTakeDamage( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if params.unit:HasModifier( "modifier_monkey_king_tree_dance_custom" ) then return end
if not params.attacker then return end
if not params.attacker:IsHero() and not params.attacker:IsBuilding() then return end
if params.damage < 3 then return end

local cooldown = self:GetAbility():GetSpecialValueFor("jump_damage_cooldown")
if self:GetParent():HasModifier("modifier_monkey_king_tree_5") then 
	cooldown = cooldown + self:GetCaster():GetTalentValue("modifier_monkey_king_tree_5", "cd")
end

self:GetAbility():StartCooldown( cooldown )
end

modifier_monkey_king_tree_dance_custom = class({})

function modifier_monkey_king_tree_dance_custom:IsHidden()
	return true
end

function modifier_monkey_king_tree_dance_custom:IsPurgable()
	return false
end

function modifier_monkey_king_tree_dance_custom:OnCreated( kv )
	self.perched_spot_height = 256
	self.perched_day_vision = self:GetAbility():GetSpecialValueFor( "perched_day_vision" )
	self.perched_night_vision = self:GetAbility():GetSpecialValueFor( "perched_night_vision" )
	self.unperched_stunned_duration = self:GetAbility():GetSpecialValueFor( "unperched_stunned_duration" )

	if self:GetCaster():HasModifier("modifier_monkey_king_tree_5") then 
		self.perched_night_vision = self.perched_night_vision + self:GetCaster():GetTalentValue("modifier_monkey_king_tree_5", "vision")
		self.perched_day_vision = self.perched_day_vision + self:GetCaster():GetTalentValue("modifier_monkey_king_tree_5", "vision")
	end 

	if not IsServer() then return end

	if self:GetParent():HasModifier("modifier_monkey_king_tree_5") then 
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_tree_dance_shield", {})
	end

	self.ability = self:GetParent():FindAbilityByName("monkey_king_primal_spring_custom")
	self.ability:SetActivated(true)

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_monkey_king_tree_dance_hidden", {})

	self.tree = EntIndexToHScript( kv.tree )
	self.origin = self.tree:GetOrigin()

	if not self:ApplyHorizontalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	if not self:ApplyVerticalMotionController() then
		self.interrupted = true
		self:Destroy()
	end

	self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()

	self:GetParent():EmitSound("Hero_MonkeyKing.TreeJump.Tree")
end

function modifier_monkey_king_tree_dance_custom:OnDestroy()
if not IsServer() then return end

local pos = self:GetParent():GetOrigin()
self.ability:SetActivated(self.ability:CanBeCast())

self:GetParent():RemoveModifierByName("modifier_monkey_king_tree_dance_hidden")
self:GetParent():RemoveHorizontalMotionController( self )
self:GetParent():RemoveVerticalMotionController( self )

if not self.unperched then
	self:GetParent():SetOrigin( pos )
end

end

function modifier_monkey_king_tree_dance_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
	}

	return funcs
end




function modifier_monkey_king_tree_dance_custom:GetActivityTranslationModifiers()
    return "perch"
end

function modifier_monkey_king_tree_dance_custom:OnOrder( params )
	if params.unit ~= self:GetParent() then return end

	if params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET then
		
		if not self:GetAbility():IsCooldownReady() then
			local order = {
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_STOP,
			}
			ExecuteOrderFromTable( order )
			return
		end

		local pos = params.new_pos

		if params.target then pos = params.target:GetOrigin() end

		local direction = (pos-self:GetParent():GetOrigin())
		direction.z = 0
		direction = direction:Normalized()

		self:GetParent():SetForwardVector( direction )

		local modifier = self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_monkey_king_tree_dance_custom_jump", { dir_x = direction.x, activity = ACT_DOTA_MK_STRIKE_END, dir_y = direction.y, distance = 150, speed = 550, height = 1, start_offset = self.perched_spot_height, fix_end = false, isForward = true } )
		
		local parent = self:GetParent()

		if modifier then
			modifier:SetEndCallback(function()
				FindClearSpaceForUnit( parent, parent:GetOrigin(), true )
			end)

			local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_monkey_king/monkey_king_jump_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
			modifier:AddParticle( particle, false, false, -1, false, false )
		end

		self:GetAbility():UseResources(false, false, false, true)

		self:Destroy()
	end
end

function modifier_monkey_king_tree_dance_custom:GetFixedDayVision()
	return self.perched_day_vision
end

function modifier_monkey_king_tree_dance_custom:GetFixedNightVision()
	return self.perched_night_vision
end

function modifier_monkey_king_tree_dance_custom:CheckState()
	local state = 
	{
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FORCED_FLYING_VISION] = true,
		--[MODIFIER_STATE_FLYING] = true,
	}
	return state
end

function modifier_monkey_king_tree_dance_custom:OnIntervalThink()
	if not IsServer() then return end
	if not self.tree.IsStanding then
		if self.tree:IsNull() then
			self:Destroy()
		end
		return
	end
	if self.tree:IsStanding() then return end
	local mod = self:GetParent():AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = self.unperched_stunned_duration } )
	self.unperched = true
	self:Destroy()
end

function modifier_monkey_king_tree_dance_custom:UpdateHorizontalMotion( me, dt )
	me:SetOrigin( self.origin )
end

function modifier_monkey_king_tree_dance_custom:UpdateVerticalMotion( me, dt )
	if not self.tree.IsStanding then
		if self.tree:IsNull() then
			self:Destroy()
		end
		return
	end
	local pos = self.tree:GetOrigin()
	pos.z = pos.z + self.perched_spot_height
	me:SetOrigin( pos )
end

function modifier_monkey_king_tree_dance_custom:OnVerticalMotionInterrupted()
	self:Destroy()
end

function modifier_monkey_king_tree_dance_custom:OnHorizontalMotionInterrupted()
	self:Destroy()
end




function modifier_monkey_king_tree_dance_custom:GetAuraRadius()
  return 250
end

function modifier_monkey_king_tree_dance_custom:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_monkey_king_tree_dance_custom:GetAuraSearchType() 
  return DOTA_UNIT_TARGET_HERO
end


function modifier_monkey_king_tree_dance_custom:GetAuraSearchFlags()
return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES +  DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD +  DOTA_UNIT_TARGET_FLAG_INVULNERABLE +  DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end


function modifier_monkey_king_tree_dance_custom:GetModifierAura()
  return "modifier_monkey_king_tree_dance_vision"
end

function modifier_monkey_king_tree_dance_custom:IsAura()
  return self:GetParent():IsOnDuel()
end















modifier_monkey_king_tree_dance_custom_jump = class({})

function modifier_monkey_king_tree_dance_custom_jump:IsHidden()
	return true
end

function modifier_monkey_king_tree_dance_custom_jump:IsPurgable()
	return true
end

function modifier_monkey_king_tree_dance_custom_jump:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_monkey_king_tree_dance_custom_jump:OnCreated( kv )
	if not IsServer() then return end
	self.interrupted = false
	self:SetJumpParameters( kv )
	self:Jump()
end

function modifier_monkey_king_tree_dance_custom_jump:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_monkey_king_tree_dance_custom_jump:OnDestroy()
	if not IsServer() then return end

	local pos = self:GetParent():GetOrigin()

	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():RemoveVerticalMotionController( self )

	if self.end_offset~=0 then
		self:GetParent():SetOrigin( pos )
	end

	if self.endCallback then
		self.endCallback( self.interrupted )
	end
end

function modifier_monkey_king_tree_dance_custom_jump:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
	if self:GetStackCount()>0 then
		table.insert( funcs, MODIFIER_PROPERTY_OVERRIDE_ANIMATION )
	end

	return funcs
end






function modifier_monkey_king_tree_dance_custom_jump:GetModifierDisableTurning()
	if not self.isForward then return end
	return 1
end

function modifier_monkey_king_tree_dance_custom_jump:GetOverrideAnimation()
	return self:GetStackCount()
end

function modifier_monkey_king_tree_dance_custom_jump:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.isStun or false,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = self.isRestricted or false,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

function modifier_monkey_king_tree_dance_custom_jump:UpdateHorizontalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end
	local pos = me:GetOrigin() + self.direction * self.speed * dt
	me:SetOrigin( pos )
end

function modifier_monkey_king_tree_dance_custom_jump:UpdateVerticalMotion( me, dt )
	if self.fix_duration and self:GetElapsedTime()>=self.duration then return end
	local pos = me:GetOrigin()
	local time = self:GetElapsedTime()
	local height = pos.z
	local speed = self:GetVerticalSpeed( time )
	pos.z = height + speed * dt
	me:SetOrigin( pos )

	if not self.fix_duration then
		local ground = GetGroundHeight( pos, me ) + self.end_offset
		if pos.z <= ground then
			pos.z = ground
			me:SetOrigin( pos )
			self:Destroy()
		end
	end
end

function modifier_monkey_king_tree_dance_custom_jump:OnHorizontalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_monkey_king_tree_dance_custom_jump:OnVerticalMotionInterrupted()
	self.interrupted = true
	self:Destroy()
end

function modifier_monkey_king_tree_dance_custom_jump:SetJumpParameters( kv )
	self.parent = self:GetParent()
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

	self.isStun = kv.isStun==1
	self.isRestricted = kv.isRestricted==1
	self.isForward = kv.isForward==1
	self.activity = kv.activity or 0
	self:SetStackCount( self.activity )

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

	self.height = kv.height or 0
	self.start_offset = kv.start_offset or 0
	self.end_offset = kv.end_offset or 0

	local pos_start = self.parent:GetOrigin()
	local pos_end = pos_start + self.direction * self.distance
	local height_start = GetGroundHeight( pos_start, self.parent ) + self.start_offset
	local height_end = GetGroundHeight( pos_end, self.parent ) + self.end_offset
	local height_max

	if not self.fix_height then
		self.height = math.min( self.height, self.distance/4 )
	end
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
	if not self.fix_duration then
		self:SetDuration( -1, false )
	else
		self:SetDuration( self.duration, true )
	end
	self:InitVerticalArc( height_start, height_max, height_end, self.duration )
end

function modifier_monkey_king_tree_dance_custom_jump:Jump()
	if self.distance>0 then
		if not self:ApplyHorizontalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end
	if self.height>0 then
		if not self:ApplyVerticalMotionController() then
			self.interrupted = true
			self:Destroy()
		end
	end
end

function modifier_monkey_king_tree_dance_custom_jump:InitVerticalArc( height_start, height_max, height_end, duration )
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

function modifier_monkey_king_tree_dance_custom_jump:GetVerticalPos( time )
	return self.const1*time - self.const2*time*time
end

function modifier_monkey_king_tree_dance_custom_jump:GetVerticalSpeed( time )
	return self.const1 - 2*self.const2*time
end

function modifier_monkey_king_tree_dance_custom_jump:SetEndCallback( func )
	self.endCallback = func
end











modifier_monkey_king_tree_dance_shield = class({})
function modifier_monkey_king_tree_dance_shield:IsHidden() return false end
function modifier_monkey_king_tree_dance_shield:IsPurgable() return false end
function modifier_monkey_king_tree_dance_shield:GetStatusEffectName() return "particles/status_fx/status_effect_shredder_whirl.vpcf" end
function modifier_monkey_king_tree_dance_shield:StatusEffectPriority() return 111111 end
function modifier_monkey_king_tree_dance_shield:GetTexture() return "buffs/leap_shield" end
function modifier_monkey_king_tree_dance_shield:OnCreated(table)

self.shield_max = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_5", "shield")/100
self.shield_duration = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_5", "shield_duration")

self.max_shield = self:GetParent():GetMaxHealth()*self.shield_max


self.regen = self:GetCaster():GetTalentValue("modifier_monkey_king_tree_5", "regen")
if not IsServer() then return end

self.RemoveForDuel = true

self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "Hero_Pangolier.TailThump.Shield"
self.buff_particles = {}
self.part = true
self:GetCaster():EmitSound( self.sound)


self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)


self.sound = true

self.interval = 0.1


self:OnIntervalThink()
self:StartIntervalThink(self.interval)

end





function modifier_monkey_king_tree_dance_shield:OnIntervalThink()
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_monkey_king_tree_dance_custom") and not self:GetParent():HasModifier("modifier_monkey_king_tree_dance_custom_jump") then return end

local shield_interval = (self.max_shield/self.shield_duration)*self.interval

self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + shield_interval))

end 



function modifier_monkey_king_tree_dance_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
  if params.report_max then 
  	return self.max_shield
  else 
  	return self:GetStackCount()
  end 
end

if not params then return end
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


function modifier_monkey_king_tree_dance_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end


function modifier_monkey_king_tree_dance_shield:GetModifierHealthRegenPercentage()
--return self.regen
end




modifier_monkey_king_tree_dance_vision = class({})
function modifier_monkey_king_tree_dance_vision:IsHidden() return false end
function modifier_monkey_king_tree_dance_vision:IsPurgable() return false end
function modifier_monkey_king_tree_dance_vision:CheckState()
return
{
	[MODIFIER_STATE_FORCED_FLYING_VISION] = true
}
end