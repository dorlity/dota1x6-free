LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_debuff", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_blood", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_blood_count", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_hits", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_move", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_heal", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_sound", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hoodwink_sharpshooter_custom_legendary", "abilities/hoodwink/hoodwink_sharpshooter_custom", LUA_MODIFIER_MOTION_NONE )




hoodwink_sharpshooter_custom = class({})


function hoodwink_sharpshooter_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf", context )
PrecacheResource( "particle", "particles/max_charge_hoodwink.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_debuff.vpcf", context )

end




function hoodwink_sharpshooter_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_hoodwink_sharp_2") then
	bonus = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_2", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end




function hoodwink_sharpshooter_custom:OnSpellStart()
local point = self:GetCursorPosition()
local duration = self:GetSpecialValueFor( "misfire_time" )
self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom", { duration = duration, x = point.x, y = point.y, } )
end


function hoodwink_sharpshooter_custom:OnProjectileThink_ExtraData( location, ExtraData )
local sound = EntIndexToHScript( ExtraData.sound )
if not sound or sound:IsNull() then return end
sound:SetOrigin( location )
end

function hoodwink_sharpshooter_custom:OnProjectileHit_ExtraData( target, location, ExtraData )
local sound = EntIndexToHScript( ExtraData.sound )

if sound and not sound:IsNull() then 
	sound:StopSound("Hero_Hoodwink.Sharpshooter.Projectile")
	UTIL_Remove( sound )
end

if not target then 
	return false 
end


if not self:GetCaster():TargetLockedOnBase(target) then 
	target:AddNewModifier( self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_hoodwink_sharp_6")) , "modifier_hoodwink_sharpshooter_custom_debuff", { duration = ExtraData.duration*(1 - target:GetStatusResistance()), x = ExtraData.x, y = ExtraData.y } )
end 


local damage = ExtraData.damage
local mod = target:FindModifierByName("modifier_hoodwink_sharpshooter_custom_legendary")

if mod then 
	damage = damage*(1 + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_legendary", "damage_inc")/100)
end 

local damageTable = { victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self, damage_flags = DOTA_DAMAGE_FLAG_NONE }
local real = ApplyDamage(damageTable)


if ExtraData.pct >= 1 and target:IsRealHero() and ExtraData.isIllusion == 0 and self:GetCaster():GetQuest() == "Hoodwink.Quest_8" then 
	self:GetCaster():UpdateQuest(1)
end

if ExtraData.isIllusion == 1 then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_legendary", "damage_duration")})
end 

if ExtraData.pct >= 1 and target:IsValidKill(self:GetCaster()) and ExtraData.isIllusion == 0  then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_hits", {})
end

if self:GetCaster():HasModifier("modifier_hoodwink_sharp_3") then 

	local damage = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_3",  "damage")*damage/100
	target:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_blood", {damage = damage})
	target:AddNewModifier(self:GetCaster(), self, "modifier_hoodwink_sharpshooter_custom_blood_count", {})
end

SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, real, self:GetCaster():GetPlayerOwner() )

AddFOWViewer( self:GetCaster():GetTeamNumber(), target:GetOrigin(), 300, 4, false)

local direction = Vector( ExtraData.x, ExtraData.y, 0 ):Normalized()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )
target:EmitSound("Hero_Hoodwink.Sharpshooter.Target")

end






hoodwink_sharpshooter_release_custom = class({})

function hoodwink_sharpshooter_release_custom:OnSpellStart()
local mod = self:GetCaster():FindModifierByName( "modifier_hoodwink_sharpshooter_custom" )
if not mod then return end
mod:Destroy()
end





modifier_hoodwink_sharpshooter_custom = class({})

function modifier_hoodwink_sharpshooter_custom:IsPurgable() return false end

function modifier_hoodwink_sharpshooter_custom:OnCreated( kv )
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.team = self.parent:GetTeamNumber()
self.charge = self:GetAbility():GetSpecialValueFor( "max_charge_time" )
self.base = self:GetAbility():GetSpecialValueFor( "base_power" )

self.damage = self:GetAbility():GetSpecialValueFor( "max_damage" )

if self:GetCaster():HasModifier("modifier_hoodwink_sharpshooter_custom_hits") and self:GetCaster():HasModifier("modifier_hoodwink_sharp_4") then 
	self.damage = self.damage + self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_4", "damage")*self:GetCaster():GetUpgradeStack("modifier_hoodwink_sharpshooter_custom_hits")
end

self.duration = self:GetAbility():GetSpecialValueFor( "max_slow_debuff_duration" )
self.turn_rate = self:GetAbility():GetSpecialValueFor( "turn_rate" )

if self.parent:IsIllusion() then 
	self.turn_rate = self.turn_rate * (1 + self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_legendary", "turn_bonus")/100)
end 

self.scepter_count = self:GetAbility():GetSpecialValueFor("scepter_acorn_count")
self.scepter_radius = self:GetAbility():GetSpecialValueFor("scepter_acorn_radius")
self.scepter_stun = self:GetAbility():GetSpecialValueFor("scepter_bushwhack")

self.recoil_distance = self:GetAbility():GetSpecialValueFor( "recoil_distance" )
self.recoil_duration = self:GetAbility():GetSpecialValueFor( "recoil_duration" )
self.recoil_height = self:GetAbility():GetSpecialValueFor( "recoil_height" )

self.legendary_damage = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_legendary", "damage")/100
self.legendary_duration = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_legendary", "duration")
self.legendary_vision = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_legendary", "vision")

self.interval = 0.03

self.cd_items = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_5", "cd")

self.projectile_speed = self:GetAbility():GetSpecialValueFor( "arrow_speed" )

if self:GetCaster():HasModifier("modifier_hoodwink_sharp_6") then
	self.projectile_speed = self.projectile_speed*(1 + self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_6", "speed") /100)
end

if self:GetCaster():HasModifier("modifier_hoodwink_sharp_2") then
	self.charge = self.charge*(1 + self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_2", "cast") /100)
end


self:StartIntervalThink( self.interval)
if not IsServer() then return end

self.scepter_targets = {}

self.RemoveForDuel = true

if self:GetCaster():HasScepter()  then 
	self.recoil_distance = self.recoil_distance + self:GetAbility():GetSpecialValueFor("scepter_range")
	self.recoil_height = self:GetAbility():GetSpecialValueFor("scepter_height")
end

if self:GetCaster():HasModifier("modifier_hoodwink_sharp_5") then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_debuff_immune", {effect = 1, duration =  self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_5", "bkb")})
end


self.projectile_range = self:GetAbility():GetSpecialValueFor( "arrow_range" )
self.projectile_width = self:GetAbility():GetSpecialValueFor( "arrow_width" )
local projectile_vision = self:GetAbility():GetSpecialValueFor( "arrow_vision" )
local vec = Vector( kv.x, kv.y, 0 )
self:SetDirection( vec )
self.current_dir = self.target_dir
self.face_target = true
self.parent:SetForwardVector( self.current_dir )

self.max_charge = false

self.turn_speed = self.interval*self.turn_rate

self.info = 
{
	Source = self.caster,
	Ability = self:GetAbility(),
	bDeleteOnHit = false,
	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_projectile.vpcf",
	fDistance = self.projectile_range,
	fStartRadius = self.projectile_width,
	fEndRadius = self.projectile_width,
	bHasFrontalCone = false,
	bReplaceExisting = false,
	bProvidesVision = true,
	bVisibleToEnemies = true,
	iVisionRadius = projectile_vision,
	iVisionTeamNumber = self.parent:GetTeamNumber(),
}


self.parent:SwapAbilities( "hoodwink_sharpshooter_custom", "hoodwink_sharpshooter_release_custom", false, true )

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( effect_cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
self:AddParticle( effect_cast, false, false, -1, false, false )

EmitSoundOn("Hero_Hoodwink.Sharpshooter.Channel", self.parent)
end









function modifier_hoodwink_sharpshooter_custom:Shoot(new_pct)
if not IsServer() then return end

local direction = self.current_dir
local pct

if new_pct == nil then 
	pct = math.min(1, (math.min( self:GetElapsedTime(), self.charge )/self.charge + self.base))
else 
	pct = new_pct
end

local info = self.info

if self.charged == true and self:GetCaster():HasModifier("modifier_hoodwink_sharp_5") and self:GetCaster() == self:GetParent() then 
	self:GetCaster():CdItems(self.cd_items)

	local particle = ParticleManager:CreateParticle("particles/items2_fx/refresher.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
	ParticleManager:SetParticleControlEnt( particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(particle)
end

if self:GetCaster():HasModifier("modifier_hoodwink_sharp_1") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_hoodwink_sharpshooter_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_1", "duration")})
end 

self.info.vSpawnOrigin = self.parent:GetOrigin()
self.info.vVelocity = direction * self.projectile_speed

local sound = CreateModifierThinker( self.parent, self, "modifier_hoodwink_sharpshooter_custom_sound", {}, self.parent:GetOrigin(), self.team, false )
sound:EmitSound("Hero_Hoodwink.Sharpshooter.Projectile")


local duration = self.duration * pct
local damage = self.damage * pct

if self.parent:IsIllusion() then
	damage = self.damage * self.legendary_damage
	duration = self.legendary_duration
end 

self.info.ExtraData = {isIllusion = self:GetParent():IsIllusion(), damage = damage, pct = pct, duration = duration, x = direction.x, y = direction.y, sound = sound:entindex(), }

ProjectileManager:CreateLinearProjectile( info )
end




function modifier_hoodwink_sharpshooter_custom:OnDestroy()
if not IsServer() then return end

StopSoundOn("Hero_Hoodwink.Sharpshooter.Channel",self.parent)

if self:GetParent():IsIllusion() and not self:GetParent():IsAlive() then
	return 
end

local direction = self.current_dir

self:Shoot()

local bump_point = self.parent:GetAbsOrigin() + direction * self.recoil_distance

local mod = self.parent:AddNewModifier(
	self.parent, 
	self:GetAbility(), 
	"modifier_knockback",
	{
		duration = self.recoil_duration,
		knockback_height = self.recoil_height,
		knockback_distance = self.recoil_distance,
		knockback_duration = self.recoil_duration,
		center_x = bump_point.x,
		center_y = bump_point.y,
		center_z = bump_point.z,
	} 
)

if self.caster:HasScepter() and self.caster == self.parent then 
	local ability = self.caster:FindAbilityByName("hoodwink_acorn_shot_custom")

	if ability and ability:GetLevel() > 0 then 
		self.caster:AddNewModifier(self.caster, ability, "modifier_hoodwink_acorn_shot_custom_scepter", {stack = self.scepter_count, radius = self.scepter_radius, duration = self.recoil_duration})
		AddFOWViewer(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), self.projectile_range, self.recoil_duration*1.2, false)
	end
end 


self.parent:SwapAbilities( "hoodwink_sharpshooter_release_custom", "hoodwink_sharpshooter_custom", false, true )

if mod then
	local effect_cast = ParticleManager:CreateParticle( "particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	mod:AddParticle( effect_cast, false, false, -1, false, false )
end

self.parent:StopSound("Hero_Hoodwink.Sharpshooter.Cast")
self.parent:EmitSound("Hero_Hoodwink.Sharpshooter.Cast")
	
if self.parent:HasModifier("modifier_hoodwink_decoy_custom_illusion") then 
	self.parent:FindModifierByName("modifier_hoodwink_decoy_custom_illusion"):SetEnd()
end 

end


function modifier_hoodwink_sharpshooter_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}

	return funcs
end




function modifier_hoodwink_sharpshooter_custom:OnAttackLanded(params)
if not IsServer() then return end 
if not self.caster:HasScepter() then return end
if self.parent ~= params.target then return end
if not params.attacker:IsHero() then return end
--if self.parent:IsIllusion() then return end

local ability = self.caster:FindAbilityByName("hoodwink_bushwhack_custom")
if not ability or ability:GetLevel() < 0 then return end
local target = params.attacker

if target:IsInvulnerable() then return end
if self.scepter_targets[params.attacker] then return end

self.scepter_targets[params.attacker] = true

local tree = CreateTempTreeWithModel( target:GetAbsOrigin(), 5, "models/heroes/hoodwink/hoodwink_tree_model.vmdl" )

if not tree then return end

tree:SetSequence("hoodwink_tree_spawn")
tree:SetSequence("hoodwink_tree_idle")
AddFOWViewer(self.caster:GetTeamNumber(), tree:GetAbsOrigin(), 800, 5, true)

local bkb_enemies = FindUnitsInRadius( self.caster:GetTeamNumber(), tree:GetAbsOrigin(), nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )

for _,enemy in pairs(bkb_enemies) do
	if enemy:GetUnitName() ~= "npc_teleport" then 
		FindClearSpaceForUnit(enemy, enemy:GetAbsOrigin(), true)
	end
end

ability:Cast(tree:GetAbsOrigin(), self.parent:GetAbsOrigin(), self.scepter_stun)

end 





function modifier_hoodwink_sharpshooter_custom:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_6
end

function modifier_hoodwink_sharpshooter_custom:OnOrder( params )
if self:GetParent():IsIllusion() then return end
if params.unit~=self:GetParent() then return end

if params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION
then
	self:SetDirection( params.new_pos )
elseif 
	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
	params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
then
	self:SetDirection( params.target:GetOrigin() )
end

end

function modifier_hoodwink_sharpshooter_custom:IllusionScepterDirection( target )
	self:SetDirection( target:GetOrigin() )
end

function modifier_hoodwink_sharpshooter_custom:GetModifierMoveSpeed_Limit()
	return 0.1
end

function modifier_hoodwink_sharpshooter_custom:GetModifierTurnRate_Percentage()
	return -self.turn_rate
end

function modifier_hoodwink_sharpshooter_custom:GetModifierDisableTurning()
	return 1
end

function modifier_hoodwink_sharpshooter_custom:CheckState()
local state = {}
	state =
	{ 
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end

function modifier_hoodwink_sharpshooter_custom:OnIntervalThink()
if not IsServer() then self:UpdateStack() return end

self:TurnLogic()
local startpos = self.parent:GetOrigin()
local visions = self.projectile_range/self.projectile_width
local delta = self.parent:GetForwardVector() * self.projectile_width

local vision_radius = self.projectile_range
if self.parent:IsIllusion() then 
	--vision_radius = self.legendary_vision
end 

AddFOWViewer( self:GetCaster():GetTeamNumber(), self.parent:GetOrigin(), vision_radius, 0.1, false)


local k = (1 - self.base)



if not self.charged and self:GetElapsedTime()>self.charge*k then

	if self:GetParent():HasModifier("modifier_hoodwink_sharp_5") and self:GetCaster() == self:GetParent()  then 

		self:GetParent():EmitSound("Hoodwink.Sharp_max")

		local particle_peffect = ParticleManager:CreateParticle("particles/general/patrol_refresh.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_peffect)
	end 

	self.charged = true
	self.parent:EmitSound("Hero_Hoodwink.Sharpshooter.MaxCharge")
end

local remaining = self:GetRemainingTime()
local seconds = math.ceil( remaining )
local isHalf = (seconds-remaining)>0.5
if isHalf then seconds = seconds-1 end
if self.half~=isHalf then
	self.half = isHalf
	local mid = 1
	if isHalf then mid = 8 end
	local len = 2
	if seconds<1 then len = 1 if not isHalf then return end end
	local effect_cast = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent, self.parent:GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 1, seconds, mid ) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( len, 0, 0 ) )
end

end



function modifier_hoodwink_sharpshooter_custom:SetDirection( vec )
if not self.parent or self.parent:IsNull() then return end

if vec.x == self.parent:GetAbsOrigin().x and vec.y == self.parent:GetAbsOrigin().y then 
	vec = self.parent:GetAbsOrigin() + 100*self.parent:GetForwardVector()
end

self.target_dir = ((vec-self.parent:GetOrigin())*Vector(1,1,0)):Normalized()
self.face_target = false
end



function modifier_hoodwink_sharpshooter_custom:TurnLogic()
if not self.parent or self.parent:IsNull() then return end
if self.face_target then return end

local current_angle = VectorToAngles( self.current_dir ).y
local target_angle = VectorToAngles( self.target_dir ).y
local angle_diff = AngleDiff( current_angle, target_angle )
local sign = -1
if angle_diff<0 then sign = 1 end
if math.abs( angle_diff )<1.1*self.turn_speed then
	self.current_dir = self.target_dir
	self.face_target = true
else
	self.current_dir = RotatePosition( Vector(0,0,0), QAngle(0, sign*self.turn_speed, 0), self.current_dir )
end
local a = self.parent:IsCurrentlyHorizontalMotionControlled()
local b = self.parent:IsCurrentlyVerticalMotionControlled()
if not (a or b) then
	self.parent:SetForwardVector( self.current_dir )
end

end

function modifier_hoodwink_sharpshooter_custom:UpdateStack()

local max = 1 
local full_time = self.charge*(1 - self.base)
local pct = math.min(max, self:GetElapsedTime()/full_time)

pct = math.floor( pct*100 )
self:SetStackCount( pct )
end




function modifier_hoodwink_sharpshooter_custom:UpdateEffect()
local startpos = self.parent:GetAbsOrigin()
local endpos = startpos + self.current_dir * self.projectile_range
ParticleManager:SetParticleControl( self.effect_cast, 0, startpos )
ParticleManager:SetParticleControl( self.effect_cast, 1, endpos )
end










modifier_hoodwink_sharpshooter_custom_debuff = class({})


function modifier_hoodwink_sharpshooter_custom_debuff:GetTexture() return "hoodwink_sharpshooter" end

function modifier_hoodwink_sharpshooter_custom_debuff:IsPurgable()
return not self:GetCaster():HasModifier("modifier_hoodwink_sharp_6")
end

function modifier_hoodwink_sharpshooter_custom_debuff:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetCaster():FindAbilityByName("hoodwink_sharpshooter_custom")

self.slow = -self.ability:GetSpecialValueFor( "slow_move_pct" )

--self.attack = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_6", "speed")

if not IsServer() then return end
local direction = Vector( kv.x, kv.y, 0 ):Normalized()
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_hoodwink/hoodwink_sharpshooter_debuff.vpcf", PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
self:AddParticle( effect_cast, false, false, -1, false, false )
end

function modifier_hoodwink_sharpshooter_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	--	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierAttackSpeedBonus_Constant()
--	return self.attack
end


function modifier_hoodwink_sharpshooter_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_hoodwink_sharpshooter_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}

	return state
end









modifier_hoodwink_sharpshooter_custom_blood = class({})
function modifier_hoodwink_sharpshooter_custom_blood:IsHidden() return true end
function modifier_hoodwink_sharpshooter_custom_blood:IsPurgable() return false end
function modifier_hoodwink_sharpshooter_custom_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_hoodwink_sharpshooter_custom_blood:OnCreated(table)
if not IsServer() then return end

self.damage = table.damage


self.interval = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_3", "interval")
self.duration = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_3", "duration")/self.interval

self.tick = (self.damage/self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_3", "duration"))*self.interval


self.damageTable = 
{
  victim      = self:GetParent(),
  damage      = self.tick,
  damage_type   = DAMAGE_TYPE_MAGICAL,
  damage_flags  = DOTA_DAMAGE_FLAG_NONE,
  attacker    = self:GetCaster(),
  ability     = self:GetAbility()
}
     

self:StartIntervalThink(self.interval)
end


function modifier_hoodwink_sharpshooter_custom_blood:OnIntervalThink()
if not IsServer() then return end
ApplyDamage(self.damageTable)
     
self:IncrementStackCount()
if self:GetStackCount() >= self.duration then 
	self:Destroy()
end 

end


function modifier_hoodwink_sharpshooter_custom_blood:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_hoodwink_sharpshooter_custom_blood_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end



modifier_hoodwink_sharpshooter_custom_blood_count = class({})
function modifier_hoodwink_sharpshooter_custom_blood_count:IsHidden() return false end
function modifier_hoodwink_sharpshooter_custom_blood_count:IsPurgable() return false end
function modifier_hoodwink_sharpshooter_custom_blood_count:GetTexture() return "buffs/sharp_blood" end
function modifier_hoodwink_sharpshooter_custom_blood_count:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end
function modifier_hoodwink_sharpshooter_custom_blood_count:OnCreated(table)

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_3", "heal_reduce")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_hoodwink_sharpshooter_custom_blood_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_hoodwink_sharpshooter_custom_blood_count:DeclareFunctions()
return
{
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
 	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
 	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_hoodwink_sharpshooter_custom_blood_count:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_hoodwink_sharpshooter_custom_blood_count:GetModifierHealAmplify_PercentageTarget() 
return self.heal_reduce
end


function modifier_hoodwink_sharpshooter_custom_blood_count:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end






modifier_hoodwink_sharpshooter_custom_hits = class({})
function modifier_hoodwink_sharpshooter_custom_hits:IsHidden() return not self:GetCaster():HasModifier("modifier_hoodwink_sharp_4") end
function modifier_hoodwink_sharpshooter_custom_hits:IsPurgable() return false end
function modifier_hoodwink_sharpshooter_custom_hits:RemoveOnDeath() return false end
function modifier_hoodwink_sharpshooter_custom_hits:GetTexture() return "buffs/sharp_hits" end
function modifier_hoodwink_sharpshooter_custom_hits:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_4", "max", true)

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(0.5)
end

function modifier_hoodwink_sharpshooter_custom_hits:OnIntervalThink()
if not IsServer() then return end 
if self:GetStackCount() < self.max then return end
if not self:GetCaster():HasModifier("modifier_hoodwink_sharp_4") then return end

local particle_peffect = ParticleManager:CreateParticle("particles/general/patrol_refresh.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self:GetCaster():EmitSound("BS.Thirst_legendary_active")
self:StartIntervalThink(-1)
end 

function modifier_hoodwink_sharpshooter_custom_hits:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

end


function modifier_hoodwink_sharpshooter_custom_hits:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP2
}

end
function modifier_hoodwink_sharpshooter_custom_hits:OnTooltip()
return self:GetStackCount()
end

function modifier_hoodwink_sharpshooter_custom_hits:OnTooltip2()
	return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_4", "damage")
end


function modifier_hoodwink_sharpshooter_custom_hits:GetModifierPercentageCooldown() 
if not self:GetCaster():HasModifier("modifier_hoodwink_sharp_4") then return end
if self:GetStackCount() < self.max then return end
return self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_4", "cdr")
end









modifier_hoodwink_sharpshooter_custom_heal = class({})
function modifier_hoodwink_sharpshooter_custom_heal:IsHidden() return false end
function modifier_hoodwink_sharpshooter_custom_heal:IsPurgable() return false end
function modifier_hoodwink_sharpshooter_custom_heal:GetTexture() return "buffs/Crit_blood" end


function modifier_hoodwink_sharpshooter_custom_heal:OnCreated()
self.heal = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_1", "heal")
self.creeps = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_1", "creeps")
end 

function modifier_hoodwink_sharpshooter_custom_heal:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
}
end


function modifier_hoodwink_sharpshooter_custom_heal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end

local heal = self.heal/100
if params.unit:IsCreep() then 
  heal = heal / self.creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end







modifier_hoodwink_sharpshooter_custom_sound = class({})
function modifier_hoodwink_sharpshooter_custom_sound:IsHidden() return true end
function modifier_hoodwink_sharpshooter_custom_sound:IsPurgable() return false end



modifier_hoodwink_sharpshooter_custom_legendary = class({})
function modifier_hoodwink_sharpshooter_custom_legendary:IsHidden() return false end
function modifier_hoodwink_sharpshooter_custom_legendary:IsPurgable() return false end
function modifier_hoodwink_sharpshooter_custom_legendary:GetTexture() return "buffs/odds_fow" end
function modifier_hoodwink_sharpshooter_custom_legendary:OnCreated()
if not IsServer() then return end 
self.effect_cast = ParticleManager:CreateParticle( "particles/hoodwink/legendary_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self.RemoveForDuel = true

self.max = self:GetCaster():GetTalentValue("modifier_hoodwink_sharp_legendary", "max")
self:SetStackCount(1)
end

function modifier_hoodwink_sharpshooter_custom_legendary:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()
end 


function modifier_hoodwink_sharpshooter_custom_legendary:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end

if self.effect_cast then 
   ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end


end

