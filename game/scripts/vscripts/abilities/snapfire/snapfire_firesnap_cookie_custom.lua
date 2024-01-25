LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_attacks", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_heal", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_speed", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_tracker", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_cookie", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_bombs", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_bomb_cookie", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_bomb_slow", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_damage", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_lowhp_cd", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_lowhp_visual", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_lowhp_reduce", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_legendary_cd", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_firesnap_cookie_custom_legendary_tracker", "abilities/snapfire/snapfire_firesnap_cookie_custom", LUA_MODIFIER_MOTION_NONE )



snapfire_firesnap_cookie_custom = class({})

snapfire_firesnap_cookie_custom.attack_range = 800
snapfire_firesnap_cookie_custom.attack_interval = 0.15
snapfire_firesnap_cookie_custom.attack_max = 3
snapfire_firesnap_cookie_custom.attack_damage = {-70, -55, -40}


snapfire_firesnap_cookie_custom.speed_attack = {50, 75, 100}
snapfire_firesnap_cookie_custom.speed_move = {10, 15, 20}
snapfire_firesnap_cookie_custom.speed_duration = 4

snapfire_firesnap_cookie_custom.damage_inc = {6, 9, 12}
snapfire_firesnap_cookie_custom.damage_inc_duration = 5

snapfire_firesnap_cookie_custom.cd_inc = -3

snapfire_firesnap_cookie_custom.lowhp_health = 30
snapfire_firesnap_cookie_custom.lowhp_cd = 30
snapfire_firesnap_cookie_custom.lowhp_radius = 500
snapfire_firesnap_cookie_custom.lowhp_reduce = -50
snapfire_firesnap_cookie_custom.lowhp_reduce_duration = 4
snapfire_firesnap_cookie_custom.lowhp_knockback = 400





function snapfire_firesnap_cookie_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_selfcast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf", context )
PrecacheResource( "particle", "particles/sf_refresh_a.vpcf", context )
PrecacheResource( "particle", "particles/cleance_blade.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf", context )
PrecacheResource( "particle", "particles/alch_stun_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/black_powder_bag.vpcf", context )
PrecacheResource( "particle", "particles/zeus_resist_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_huskar_lifebreak.vpcf", context )

end






function snapfire_firesnap_cookie_custom:GetCastPoint()
if self:GetCaster():HasModifier("modifier_snapfire_cookie_5") then 
	return 0
end
	return self:GetSpecialValueFor("AbilityCastPoint")
end



function snapfire_firesnap_cookie_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_snapfire_cookie_5") then 
  upgrade_cooldown = self.cd_inc
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end






function snapfire_firesnap_cookie_custom:OnAbilityPhaseStart()
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_selfcast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( particle )
	return true
end


function snapfire_firesnap_cookie_custom:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_snapfire_cookie_7") then
    return self:GetCaster():GetTalentValue("modifier_snapfire_cookie_7", "mana")
end

return self.BaseClass.GetManaCost(self, iLevel)
end



function snapfire_firesnap_cookie_custom:GetIntrinsicModifierName()
return "modifier_snapfire_firesnap_cookie_custom_tracker"
end



function snapfire_firesnap_cookie_custom:GetCastRange(vLocation, hTarget)

if IsServer() then 
	return 999999
else 

	if self:GetCaster():HasShard() then 
		return self:GetSpecialValueFor("shard_distance")
	else 
		return self:GetSpecialValueFor( "jump_horizontal_distance" ) 
	end

end

end

function snapfire_firesnap_cookie_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():EmitSound("Hero_Snapfire.FeedCookie.Cast")

	local duration = self:GetSpecialValueFor( "jump_duration" )
	local height = self:GetSpecialValueFor( "jump_height" )
	local distance = self:GetSpecialValueFor( "jump_horizontal_distance" )
	local impact_stun_duration = self:GetSpecialValueFor( "impact_stun_duration" )
	local impact_damage = self:GetSpecialValueFor( "impact_damage" )
	local impact_radius = self:GetSpecialValueFor( "impact_radius" )

	local speed = distance/duration


  	self.scatter_ability = self:GetCaster():FindAbilityByName("snapfire_scatterblast_custom")
	local ulti = self:GetCaster():FindAbilityByName("snapfire_mortimer_kisses_custom")



	if self:GetCaster():HasModifier("modifier_snapfire_cookie_3") then 
		my_game:GenericHeal(self:GetCaster(), self:GetCaster():GetTalentValue("modifier_snapfire_cookie_3", "heal"), self)

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_snapfire_firesnap_cookie_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_3", "duration")})
	end


	if self:GetCaster():HasShard() then 
		height = self:GetSpecialValueFor("shard_height")
		distance = self:GetSpecialValueFor("shard_distance")

	end

	local point = self:GetCaster():GetCursorPosition()

	if point == self:GetCaster():GetAbsOrigin() then 
		point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*10
	end

	local vec = point - self:GetCaster():GetAbsOrigin()

	vec.z = 0

	local dir = vec:Normalized()



	self:GetCaster():SetForwardVector(dir)
	self:GetCaster():FaceTowards(self:GetCaster():GetAbsOrigin() + dir*10)

	local max_dist = distance

	distance = math.min(max_dist, math.max(200, vec:Length2D()))
	height = distance*0.55


	if ulti and ulti:GetLevel() > 0 and self:GetCaster():HasShard() then 
		ulti:LauchBall(self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*distance, 0.7, self:GetSpecialValueFor("shard_damage")/100)
	end

	duration = distance/speed


	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( particle )
	local particle_buff = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	self:GetCaster():EmitSound("Hero_Snapfire.FeedCookie.Consume")

	local knockback = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_snapfire_firesnap_cookie_custom", { distance = distance, height = height, duration = duration, direction_x = self:GetCaster():GetForwardVector().x, direction_y = self:GetCaster():GetForwardVector().y, IsStun = true } )

	local callback = function()

		if self:GetCaster():HasModifier("modifier_snapfire_scatter_7") and self.scatter_ability and self.scatter_ability:GetLevel() > 0 and self.scatter_ability:GetCooldownTimeRemaining() > 0 then 

			local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
		   	ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
		   	ParticleManager:ReleaseParticleIndex(particle)

		    self:GetCaster():EmitSound("Hero_Rattletrap.Overclock.Cast")

			self.scatter_ability:EndCooldown()
		end

		if self:GetCaster():HasModifier("modifier_snapfire_cookie_4") then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_snapfire_firesnap_cookie_custom_bombs", {})
		end

		if self:GetCaster():HasModifier("modifier_snapfire_cookie_2") then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_snapfire_firesnap_cookie_custom_speed", {duration = self.speed_duration})
		end

		local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
		
		if #enemies > 0 and self:GetCaster():HasModifier("modifier_snapfire_cookie_5") then 
			self:GetCaster():EmitSound("Brewmaster_Storm.DispelMagic")
		end

		for _,enemy in pairs(enemies) do

			if self:GetCaster():HasModifier("modifier_snapfire_cookie_1") then 
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_snapfire_firesnap_cookie_custom_damage", {duration = self.damage_inc_duration})
			end

			if enemy:IsRealHero() and self:GetCaster():GetQuest() == "Snapfire.Quest_6" and not self:GetCaster():QuestCompleted() then 
 				self:GetCaster():UpdateQuest(1)
			end


			if self:GetCaster():HasModifier("modifier_snapfire_cookie_5") then 
				enemy:Purge(true, false, false, false, false)

				local effect_cast = ParticleManager:CreateParticle( "particles/cleance_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW,  enemy)
				ParticleManager:SetParticleControl( effect_cast, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl( effect_cast, 1, Vector(170,0,0) )
				ParticleManager:ReleaseParticleIndex( effect_cast )
			end

			ApplyDamage({ attacker = self:GetCaster(), victim = enemy, damage = impact_damage, damage_type = self:GetAbilityDamageType(), ability = self })
			enemy:AddNewModifier( self:GetCaster(), self, "modifier_stunned", { duration = (1 - enemy:GetStatusResistance())* impact_stun_duration } )
		end

		GridNav:DestroyTreesAroundPoint( self:GetCaster():GetOrigin(), impact_radius, true )

		ParticleManager:DestroyParticle( particle_buff, false )
		ParticleManager:ReleaseParticleIndex( particle_buff )

		local land_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( land_particle, 0, GetGroundPosition(self:GetCaster():GetOrigin(), nil) )
		ParticleManager:SetParticleControl( land_particle, 1, Vector( impact_radius, impact_radius, impact_radius ) )
		ParticleManager:ReleaseParticleIndex( land_particle )

		self:GetCaster():EmitSound("Hero_Snapfire.FeedCookie.Impact")
	end

	knockback:SetEndCallback( callback )
end


function snapfire_firesnap_cookie_custom:OnProjectileHit( target, location )
if not IsServer() then return end
if not target then return end
if not target:IsCreep() and not target:IsHero() then return end

local vec = (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin())

local dir = vec:Normalized()
local point = target:GetAbsOrigin() + dir*self.lowhp_knockback

local distance = 400
local speed = 1000
local height = 180


local arc = target:AddNewModifier(caster, self, "modifier_generic_arc",
{
    target_x = point.x,
    target_y = point.y,
    distance = distance,
    speed = speed,
    height = height,
    fix_end = false,
    isStun = true,
    activity = ACT_DOTA_FLAIL,

})


local impact_radius = self:GetSpecialValueFor( "impact_radius" )

local callback = function()

	if target and not target:IsNull() then 

		local land_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_landing.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( land_particle, 0, GetGroundPosition(target:GetOrigin(), nil) )
		ParticleManager:SetParticleControl( land_particle, 1, Vector( impact_radius, impact_radius, impact_radius ) )
		ParticleManager:ReleaseParticleIndex( land_particle )
		target:EmitSound("Hero_Snapfire.FeedCookie.Impact")

		target:AddNewModifier(self:GetCaster(), self, "modifier_snapfire_firesnap_cookie_custom_lowhp_reduce", {duration = self.lowhp_reduce_duration})
	end
end

if arc and target and not target:IsNull() then 

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_cookie_receive.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )

	arc:AddParticle(particle, false, false, -1, false, false) 
	arc:SetEndCallback( callback )
end

end





modifier_snapfire_firesnap_cookie_custom = class({})

function modifier_snapfire_firesnap_cookie_custom:IsHidden()
	return true
end

function modifier_snapfire_firesnap_cookie_custom:IsPurgable()
	return false
end

function modifier_snapfire_firesnap_cookie_custom:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_snapfire_firesnap_cookie_custom:OnCreated( kv )
	if IsServer() then
		self.distance = kv.distance or 0
		self.height = kv.height or -1
		self.duration = kv.duration or 0
		if kv.direction_x and kv.direction_y then
			self.direction = Vector(kv.direction_x,kv.direction_y,0):Normalized()
		else
			self.direction = -(self:GetParent():GetForwardVector())
		end
		self.tree = kv.tree_destroy_radius or self:GetParent():GetHullRadius()
		if kv.IsStun then self.stun = kv.IsStun==1 else self.stun = false end
		if kv.IsFlail then self.flail = kv.IsFlail==1 else self.flail = true end
		if self.duration == 0 then
			self:Destroy()
			return
		end
		self.parent = self:GetParent()
		self.origin = self.parent:GetOrigin()
		self.hVelocity = self.distance/self.duration
		local half_duration = self.duration/2
		self.gravity = 2*self.height/(half_duration*half_duration)
		self.vVelocity = self.gravity*half_duration
		if self.distance>0 then
			if self:ApplyHorizontalMotionController() == false then 
				self:Destroy()
				return
			end
		end
		if self.height>=0 then
			if self:ApplyVerticalMotionController() == false then 
				self:Destroy()
				return
			end
		end
		if self.flail then
			self:SetStackCount( 1 )
		elseif self.stun then
			self:SetStackCount( 2 )
		end
	else
		self.anim = self:GetStackCount()
		self:SetStackCount( 0 )
	end
end

function modifier_snapfire_firesnap_cookie_custom:OnDestroy( kv )
	if not IsServer() then return end

	if not self.interrupted then
		if self.tree>0 then
			GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.tree, true )
		end
	end

	if self.EndCallback then
		self.EndCallback( self.interrupted )
	end

	self:GetParent():InterruptMotionControllers( true )
end

function modifier_snapfire_firesnap_cookie_custom:SetEndCallback( func ) 
	self.EndCallback = func
end

function modifier_snapfire_firesnap_cookie_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_snapfire_firesnap_cookie_custom:GetOverrideAnimation( params )
return ACT_DOTA_OVERRIDE_ABILITY_2
end

function modifier_snapfire_firesnap_cookie_custom:CheckState()
	local state = 
	{
		[MODIFIER_STATE_STUNNED] = self.stun,
	}
	return state
end

function modifier_snapfire_firesnap_cookie_custom:UpdateHorizontalMotion( me, dt )
	local parent = self:GetParent()
	local target = self.direction*self.distance*(dt/self.duration)
	parent:SetOrigin( parent:GetOrigin() + target )
end

function modifier_snapfire_firesnap_cookie_custom:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end

function modifier_snapfire_firesnap_cookie_custom:UpdateVerticalMotion( me, dt )
    local time = dt/self.duration


    if self:GetElapsedTime()/self.duration >= 0.8 and not self.anim_end then 
        self.anim_end = true
        self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END, 1.4)
    end


    local new_pos = self.parent:GetOrigin() + Vector( 0, 0, self.vVelocity*dt )
    new_pos.z = math.max( new_pos.z, GetGroundHeight( self.parent:GetOrigin(), self.parent ) )
    self.parent:SetOrigin( new_pos )
    
    self.vVelocity = self.vVelocity - self.gravity*dt
end

function modifier_snapfire_firesnap_cookie_custom:OnVerticalMotionInterrupted()
	if IsServer() then
		self.interrupted = true
		self:Destroy()
	end
end

function modifier_snapfire_firesnap_cookie_custom:GetEffectName()
	if not IsServer() then return end
	if self.stun then
		return "particles/generic_gameplay/generic_stunned.vpcf"
	end
end

function modifier_snapfire_firesnap_cookie_custom:GetEffectAttachType()
	if not IsServer() then return end
	return PATTACH_OVERHEAD_FOLLOW
end



modifier_snapfire_firesnap_cookie_custom_attacks = class({})
function modifier_snapfire_firesnap_cookie_custom_attacks:IsHidden() return true end
function modifier_snapfire_firesnap_cookie_custom_attacks:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_attacks:OnCreated(table)
if not IsServer() then return end

self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility().attack_interval)
end

function modifier_snapfire_firesnap_cookie_custom_attacks:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then 
	self:Destroy()
end


local units_heroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(),  self:GetParent():GetAbsOrigin(),  nil, self:GetAbility().attack_range,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  FIND_CLOSEST,  false )
local units_creeps = FindUnitsInRadius( self:GetParent():GetTeamNumber(),  self:GetParent():GetAbsOrigin(),  nil, self:GetAbility().attack_range,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  FIND_CLOSEST,  false )
                
local units = units_heroes

if #units == 0 then 
    units = units_creeps
end

if #units > 0 then 
    local unit = units[1]
    self:GetParent():PerformAttack(unit, true, true, true, false, true, false, true)
end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().attack_max then 
	self:Destroy()
end

end


function modifier_snapfire_firesnap_cookie_custom_attacks:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}

end



function modifier_snapfire_firesnap_cookie_custom_attacks:GetModifierDamageOutgoing_Percentage()
return self:GetAbility().attack_damage[self:GetCaster():GetUpgradeStack("modifier_snapfire_cookie_1")]
end



modifier_snapfire_firesnap_cookie_custom_heal = class({})
function modifier_snapfire_firesnap_cookie_custom_heal:IsHidden() return false end
function modifier_snapfire_firesnap_cookie_custom_heal:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_heal:GetTexture() return "buffs/cookie_heal" end
function modifier_snapfire_firesnap_cookie_custom_heal:OnCreated()

self.heal = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_3", "heal")/self:GetRemainingTime()
if not IsServer() then return end


self:StartIntervalThink(1)
end


function modifier_snapfire_firesnap_cookie_custom_heal:OnIntervalThink()
if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal, nil)
end


function modifier_snapfire_firesnap_cookie_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}

end


function modifier_snapfire_firesnap_cookie_custom_heal:GetModifierConstantHealthRegen()
return self.heal
end











modifier_snapfire_firesnap_cookie_custom_speed = class({})

function modifier_snapfire_firesnap_cookie_custom_speed:IsHidden()
	return false
end


function modifier_snapfire_firesnap_cookie_custom_speed:GetTexture()
return "buffs/chains_speed"
end

function modifier_snapfire_firesnap_cookie_custom_speed:IsPurgable()
	return true
end

function modifier_snapfire_firesnap_cookie_custom_speed:OnCreated( kv )
self.ms_bonus = self:GetAbility().speed_move[self:GetCaster():GetUpgradeStack("modifier_snapfire_cookie_2")]
self.as_bonus = self:GetAbility().speed_attack[self:GetCaster():GetUpgradeStack("modifier_snapfire_cookie_2")]
end




function modifier_snapfire_firesnap_cookie_custom_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_snapfire_firesnap_cookie_custom_speed:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end
function modifier_snapfire_firesnap_cookie_custom_speed:GetModifierAttackSpeedBonus_Constant()
	return self.as_bonus
end


function modifier_snapfire_firesnap_cookie_custom_speed:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end

function modifier_snapfire_firesnap_cookie_custom_speed:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end






modifier_snapfire_firesnap_cookie_custom_tracker = class({})
function modifier_snapfire_firesnap_cookie_custom_tracker:IsHidden() return true end
function modifier_snapfire_firesnap_cookie_custom_tracker:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_snapfire_firesnap_cookie_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_snapfire_cookie_6") then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent():GetHealthPercent() > self:GetAbility().lowhp_health then return end
if self:GetParent():HasModifier("modifier_snapfire_firesnap_cookie_custom_lowhp_cd") then return end
if self:GetParent():PassivesDisabled() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_snapfire_firesnap_cookie_custom_lowhp_cd", {duration = self:GetAbility().lowhp_cd})

self:GetParent():EmitSound("Snapfire.cookie_lowhp")
self:GetParent():EmitSound("Snapfire.cookie_lowhp2")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )

local qangle_rotation_rate = 60

local line_position = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector() * 400

local speed = 1300

local info = {
	Source = self:GetCaster(),
	Ability = self:GetAbility(),    
	        
	EffectName ="particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf",
	iMoveSpeed = speed,
	bDodgeable = false,                           -- Optional
	    
	vSourceLoc = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),                -- Optional (HOW)
	        
	bDrawsOnMinimap = false,                          -- Optional
	bVisibleToEnemies = true,                         -- Optional
	bProvidesVision = true,                           -- Optional
	iVisionRadius = 200,                              -- Optional
	iVisionTeamNumber = self:GetCaster():GetTeamNumber()       
}

for i = 1, 6 do

	local qangle = QAngle(0, qangle_rotation_rate, 0)
	line_position = RotatePosition(self:GetCaster():GetAbsOrigin() , qangle, line_position)

	local distance = (line_position - self:GetCaster():GetAbsOrigin()):Length2D()

	local thinker = CreateModifierThinker( self:GetCaster(),  self:GetAbility(),  "modifier_snapfire_firesnap_cookie_custom_lowhp_visual",   { duration = distance/speed}, line_position, self:GetCaster():GetTeamNumber(),  false )

	local info = {
	    Target = thinker,
	    Source = self:GetCaster(),
	    Ability = self:GetAbility(),    
	        
	    EffectName ="particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf",
	    iMoveSpeed = speed,
	    bDodgeable = false,                           -- Optional
	    
	    vSourceLoc = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),                -- Optional (HOW)
	        
	    bDrawsOnMinimap = false,                          -- Optional
	    bVisibleToEnemies = true,                         -- Optional
	    bProvidesVision = true,                           -- Optional
	    iVisionRadius = 200,                              -- Optional
	    iVisionTeamNumber = self:GetCaster():GetTeamNumber()       
	}


	ProjectileManager:CreateTrackingProjectile(info)
end

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().lowhp_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

for _,enemy in pairs(enemies) do 

	local info = {
	    Target = enemy,
	    Source = self:GetCaster(),
	    Ability = self:GetAbility(),    
	        
	    EffectName ="particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf",
	    iMoveSpeed = speed,
	    bDodgeable = false,                           -- Optional
	    
	    vSourceLoc = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),                -- Optional (HOW)
	        
	    bDrawsOnMinimap = false,                          -- Optional
	    bVisibleToEnemies = true,                         -- Optional
	    bProvidesVision = true,                           -- Optional
	    iVisionRadius = 200,                              -- Optional
	    iVisionTeamNumber = self:GetCaster():GetTeamNumber()       
	}


	ProjectileManager:CreateTrackingProjectile(info)
end


end




modifier_snapfire_firesnap_cookie_custom_cookie = class({})
function modifier_snapfire_firesnap_cookie_custom_cookie:IsHidden() return true end
function modifier_snapfire_firesnap_cookie_custom_cookie:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_cookie:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
}
end

function modifier_snapfire_firesnap_cookie_custom_cookie:OnCreated(table)
if not IsServer() then return end

self.particle_ally_fx = ParticleManager:CreateParticleForTeam("particles/alch_stun_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent(), self:GetParent():GetTeamNumber())
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

self.start = true 
self:GetParent():AddNoDraw()

self.radius = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_7", "radius")

self:StartIntervalThink(table.interval)

end


function modifier_snapfire_firesnap_cookie_custom_cookie:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end

if self.start == true then 
	self.start = false
	self:GetParent():RemoveNoDraw()
end


AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 200, 0.2, false)

if (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.radius 
  and self:GetCaster():IsAlive() and not self:GetCaster():HasModifier("modifier_snapfire_firesnap_cookie_custom") then 

	local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
   	ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
   	ParticleManager:ReleaseParticleIndex(particle)

   	self:GetAbility():EndCooldown()

    self:GetCaster():EmitSound("Snapfire.Cookie_legendary_activate")
    self:GetCaster():EmitSound("Hero_Rattletrap.Overclock.Cast")	
  	self:Destroy()
end

self:StartIntervalThink(FrameTime())
end


function modifier_snapfire_firesnap_cookie_custom_cookie:OnDestroy()
if not IsServer() then return end

  local part = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_WORLDORIGIN, nil)
  ParticleManager:SetParticleControl(part, 0, self:GetParent():GetAbsOrigin())
  self:GetParent():EmitSound("Hero_MonkeyKing.Transform.On")


  UTIL_Remove(self:GetParent())
end





modifier_snapfire_firesnap_cookie_custom_bombs = class({})
function modifier_snapfire_firesnap_cookie_custom_bombs:IsHidden() return true end
function modifier_snapfire_firesnap_cookie_custom_bombs:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_bombs:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_snapfire_firesnap_cookie_custom_bombs:OnCreated(table)
if not IsServer() then return end

self.RemoveForDuel = true

self.quartal = 0

self.count = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_4", "count")
self.distance = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_4", "distance")
self.interval = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_4", "interval")

self:SetStackCount(self.count)

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_snapfire_firesnap_cookie_custom_bombs:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():IsAlive() then 
	self:Destroy()
	return 
end

self.quartal = self.quartal+1
if self.quartal>3 then self.quartal = 0 end
local a = 90 + self.quartal*90
local r = self.distance
local point = Vector( math.cos(a), math.sin(a), 0 ):Normalized() * r
point = self:GetCaster():GetOrigin() + point


local target = self:GetParent()

local cookie = CreateUnitByName("npc_snapfire_cookie", point, true, nil, nil, self:GetCaster():GetTeamNumber())

local vector = point - target:GetAbsOrigin()
local direction = vector:Normalized()
local distance = vector:Length2D()

local speed = 1200


local info = {
    Target = cookie,
    Source = target,
    Ability = self:GetAbility(),    
        
    EffectName ="particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf",
    iMoveSpeed = speed,
    bDodgeable = false,                           -- Optional
    
    vSourceLoc = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),                -- Optional (HOW)
        
    bDrawsOnMinimap = false,                          -- Optional
    bVisibleToEnemies = true,                         -- Optional
    bProvidesVision = true,                           -- Optional
    iVisionRadius = 200,                              -- Optional
    iVisionTeamNumber = self:GetCaster():GetTeamNumber()       
}

--target:EmitSound("Snapfire.Cookie_legendary")
target:EmitSound("Snapfire.Bombs_activate")

ProjectileManager:CreateTrackingProjectile(info)

cookie:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_snapfire_firesnap_cookie_custom_bomb_cookie", {interval = distance/speed})


self:DecrementStackCount()

if self:GetStackCount() == 0 then 
	self:Destroy()
end
	
end






modifier_snapfire_firesnap_cookie_custom_bomb_cookie = class({})
function modifier_snapfire_firesnap_cookie_custom_bomb_cookie:IsHidden() return true end
function modifier_snapfire_firesnap_cookie_custom_bomb_cookie:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_bomb_cookie:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
}
end

function modifier_snapfire_firesnap_cookie_custom_bomb_cookie:OnCreated(table)
if not IsServer() then return end

self.start = true 
self:GetParent():AddNoDraw()

self:StartIntervalThink(table.interval)

self.aoe = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_4", "radius")
self.bomb_timer = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_4", "timer")
self.damage = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_4", "damage")/100
self.damage_creeps = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_4", "damage_creeps")
self.duration = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_4", "duration")

self.timer = self.bomb_timer*2
self.t = 0
end


function modifier_snapfire_firesnap_cookie_custom_bomb_cookie:OnIntervalThink()
if not IsServer() then return end
if not self:GetCaster() then return end


self:GetParent():SetRenderColor(255, 255 * (self.bomb_timer - self:GetElapsedTime() / self.bomb_timer ), 255 * (self.bomb_timer - self:GetElapsedTime() / self.bomb_timer ))

if self.start == true then 
	self.start = false
	self:GetParent():RemoveNoDraw()
end


if self.t == self.timer then 
	self:Destroy()
end


local caster = self:GetParent()


local number = (self.timer-self.t)/2 
local int = 0
int = number

if number % 1 ~= 0 then 
    int = number - 0.5  
end

local digits = math.floor(math.log10(number)) + 2
local decimal = number % 1

if decimal == 0.5 then
    decimal = 8
else 
    decimal = 1
end

local particleName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)


self.t = self.t + 1

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 200, 0.5, false)


self:StartIntervalThink(0.5)
end


function modifier_snapfire_firesnap_cookie_custom_bomb_cookie:OnDestroy()
if not IsServer() then return end


local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
for _,enemy in pairs(enemies) do

	local damage = self.damage*enemy:GetMaxHealth()

	if enemy:IsCreep() then 
		damage = damage*self.damage_creeps
	end

	local real_damage = ApplyDamage({ attacker = self:GetCaster(), victim = enemy, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility() })

	SendOverheadEventMessage(enemy, 4, enemy, real_damage, nil)

	enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_snapfire_firesnap_cookie_custom_bomb_slow", { duration = (1 - enemy:GetStatusResistance())*self.duration} )
end

self:GetParent():EmitSound("Snapfire.Shredder_silence")
local effect_cast = ParticleManager:CreateParticle( "particles/items3_fx/black_powder_bag.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0,  self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 5, self:GetParent():GetOrigin() )
ParticleManager:ReleaseParticleIndex(effect_cast)

UTIL_Remove(self:GetParent())
end





modifier_snapfire_firesnap_cookie_custom_bomb_slow = class({})
function modifier_snapfire_firesnap_cookie_custom_bomb_slow:IsHidden() return true end
function modifier_snapfire_firesnap_cookie_custom_bomb_slow:IsPurgable() return true end

function modifier_snapfire_firesnap_cookie_custom_bomb_slow:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_4", "slow")
end

function modifier_snapfire_firesnap_cookie_custom_bomb_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_snapfire_firesnap_cookie_custom_bomb_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end




modifier_snapfire_firesnap_cookie_custom_damage = class({})
function modifier_snapfire_firesnap_cookie_custom_damage:IsHidden() return false end
function modifier_snapfire_firesnap_cookie_custom_damage:IsPurgable() return true end
function modifier_snapfire_firesnap_cookie_custom_damage:GetTexture() return "buffs/cookie_damage" end
function modifier_snapfire_firesnap_cookie_custom_damage:OnCreated(table)
if not IsServer() then return end
  self.particle_peffect = ParticleManager:CreateParticle("particles/zeus_resist_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
  ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
  self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end



function modifier_snapfire_firesnap_cookie_custom_damage:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_snapfire_firesnap_cookie_custom_damage:GetModifierIncomingDamage_Percentage()
return self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_snapfire_cookie_1")]
end








modifier_snapfire_firesnap_cookie_custom_lowhp_visual = class({})
function modifier_snapfire_firesnap_cookie_custom_lowhp_visual:IsHidden() return true end
function modifier_snapfire_firesnap_cookie_custom_lowhp_visual:IsPurgable() return false end



modifier_snapfire_firesnap_cookie_custom_lowhp_reduce = class({})
function modifier_snapfire_firesnap_cookie_custom_lowhp_reduce:IsHidden() return false end
function modifier_snapfire_firesnap_cookie_custom_lowhp_reduce:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_lowhp_reduce:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_snapfire_firesnap_cookie_custom_lowhp_reduce:GetModifierTotalDamageOutgoing_Percentage()
return self:GetAbility().lowhp_reduce
end

function modifier_snapfire_firesnap_cookie_custom_lowhp_reduce:GetEffectName()
return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end


function modifier_snapfire_firesnap_cookie_custom_lowhp_reduce:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end


function modifier_snapfire_firesnap_cookie_custom_lowhp_reduce:GetStatusEffectName()
  return "particles/status_fx/status_effect_huskar_lifebreak.vpcf"
end

function modifier_snapfire_firesnap_cookie_custom_lowhp_reduce:StatusEffectPriority()
  return 99999
end




modifier_snapfire_firesnap_cookie_custom_lowhp_cd = class({})
function modifier_snapfire_firesnap_cookie_custom_lowhp_cd:IsHidden() return false end
function modifier_snapfire_firesnap_cookie_custom_lowhp_cd:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_lowhp_cd:RemoveOnDeath() return false end
function modifier_snapfire_firesnap_cookie_custom_lowhp_cd:IsDebuff() return true end
function modifier_snapfire_firesnap_cookie_custom_lowhp_cd:GetTexture() return "buffs/fireblast_lowhp" end
function modifier_snapfire_firesnap_cookie_custom_lowhp_cd:OnCreated(table)
self.RemoveForDuel = true 
end




modifier_snapfire_firesnap_cookie_custom_legendary_cd = class({})
function modifier_snapfire_firesnap_cookie_custom_legendary_cd:IsHidden() return true end
function modifier_snapfire_firesnap_cookie_custom_legendary_cd:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_legendary_cd:OnCreated(table)
if not IsServer() then return end

self.max = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_7", "max")

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_snapfire_firesnap_cookie_custom_legendary_cd:OnIntervalThink()
if not IsServer() then return end


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'snapfire_cookie_change',  { max = self.max, current = self:GetRemainingTime(), active = 0})

end

function modifier_snapfire_firesnap_cookie_custom_legendary_cd:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'snapfire_cookie_change',  { max = self.max, current = 0, active = 1})

end




modifier_snapfire_firesnap_cookie_custom_legendary_tracker = class({})
function modifier_snapfire_firesnap_cookie_custom_legendary_tracker:IsHidden() return true end
function modifier_snapfire_firesnap_cookie_custom_legendary_tracker:IsPurgable() return false end
function modifier_snapfire_firesnap_cookie_custom_legendary_tracker:RemoveOnDeath() return false end
function modifier_snapfire_firesnap_cookie_custom_legendary_tracker:OnCreated(table)
if not IsServer() then return end

self.max = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_7", "max")
self.cd = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_7", "cd")
self.timer = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_7", "timer")
self.distance = self:GetCaster():GetTalentValue("modifier_snapfire_cookie_7", "distance")


self:SetStackCount(0)
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'snapfire_cookie_change',  { max = self.max, current = 0, active = 1})

end


function modifier_snapfire_firesnap_cookie_custom_legendary_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_snapfire_firesnap_cookie_custom_legendary_tracker:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if self:GetParent():HasModifier("modifier_snapfire_firesnap_cookie_custom_legendary_cd") then return end

self:IncrementStackCount()

self:StartIntervalThink(self.timer)

if self:GetStackCount() >= self.max then 
	self:SetStackCount(0)

	local target = params.target

	local point = target:GetAbsOrigin() + RandomVector(self.distance)

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_snapfire_firesnap_cookie_custom_legendary_cd", {duration = self.cd})

	local cookie = CreateUnitByName("npc_snapfire_cookie", point, true, nil, nil, self:GetCaster():GetTeamNumber())

	local vector = point - target:GetAbsOrigin()
	local direction = vector:Normalized()
	local distance = vector:Length2D()

	local speed = 1200


	local info = {
	    Target = cookie,
	    Source = target,
	    Ability = nil,    
	        
	    EffectName ="particles/units/heroes/hero_snapfire/hero_snapfire_cookie_projectile.vpcf",
	    iMoveSpeed = speed,
	    bDodgeable = false,                           -- Optional
	    
	    vSourceLoc = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_hitloc")),                -- Optional (HOW)
	        
	    bDrawsOnMinimap = false,                          -- Optional
	    bVisibleToEnemies = true,                         -- Optional
	    bProvidesVision = true,                           -- Optional
	    iVisionRadius = 200,                              -- Optional
	    iVisionTeamNumber = self:GetCaster():GetTeamNumber()       
	}

	target:EmitSound("Snapfire.Cookie_legendary")
	target:EmitSound("Snapfire.Cookie_legendary_proc")

	ProjectileManager:CreateTrackingProjectile(info)

	cookie:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_snapfire_firesnap_cookie_custom_cookie", {duration = 12, interval = distance/speed})


end

end


function modifier_snapfire_firesnap_cookie_custom_legendary_tracker:OnIntervalThink()
if not IsServer() then return end
if self:GetStackCount() == 0 then return end

self:DecrementStackCount()

self:StartIntervalThink(0.2)
end



function modifier_snapfire_firesnap_cookie_custom_legendary_tracker:OnStackCountChanged(iStackCount)
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'snapfire_cookie_change',  { max = self.max, current = self:GetStackCount(), active = 1})

end