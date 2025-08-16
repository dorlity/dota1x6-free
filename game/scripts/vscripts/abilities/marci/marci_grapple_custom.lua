LinkLuaModifier("modifier_marci_dispose_custom_knockback", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier("modifier_marci_dispose_custom_hits", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_hits_slow", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_tracker", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_reduction", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_slow", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_swap", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_attacks", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_attacks_caster", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_armor", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_armor_cast", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_shield", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_marci_dispose_custom_damage", "abilities/marci/marci_grapple_custom", LUA_MODIFIER_MOTION_NONE )





marci_grapple_custom = class({})




function marci_grapple_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_attack_blur_l01.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_attack_blur_r01.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_attack_blur_r02.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_attack_blur_kick01.vpcf", context )


PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_dispose_land_aoe.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_dispose_aoe_damage.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_dispose_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_grapple.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf", context )
PrecacheResource( "particle", "particles/general/generic_armor_reduction.vpcf", context )
PrecacheResource( "particle", "particles/hoodwink/bush_damage.vpcf", context )



end




function marci_grapple_custom:GetIntrinsicModifierName()
	return "modifier_marci_dispose_custom_tracker"
end



function marci_grapple_custom:GetAOERadius()
return self:GetSpecialValueFor("landing_radius")
end



function marci_grapple_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasTalent("modifier_marci_dispose_3") then  
	upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_marci_dispose_3", "cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end





function marci_grapple_custom:GetCastRange(vLocation, hTarget)
local upgrade = 0
if self:GetCaster():HasTalent("modifier_marci_dispose_3") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_marci_dispose_3", "range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end




function marci_grapple_custom:SwapSkills(reset)
if not IsServer() then return end

local caster = self:GetCaster()
local skill_array = 
{
	"marci_grapple_custom",
	"marci_dispose_jump",	
	"marci_dispose_knockback",
	"marci_dispose_hits"
}

for i = 1,#skill_array do 

	local spell = caster:FindAbilityByName(skill_array[i])

	if spell and spell:IsHidden() == false then

		local n = i + 1
		if n > #skill_array or reset then 
			n = 1
			self:SetActivated(true)
			self:UseResources(false, false, false, true)
			caster:RemoveModifierByName("modifier_marci_dispose_custom_swap")
		end

		caster:SwapAbilities(skill_array[i], skill_array[n], false, true)
		break
	end
end

end



function marci_grapple_custom:OnSpellStart(new_target)
if not IsServer() then return end

local caster = self:GetCaster()
local original_target = self:GetCursorTarget()

if caster:HasTalent("modifier_marci_dispose_7") then 
	self:EndCooldown()
	self:SetActivated(false)
end 

if new_target then 
	original_target = new_target
end

if original_target:TriggerSpellAbsorb( self ) then return end

local duration = self:GetSpecialValueFor( "air_duration" )
local height = self:GetSpecialValueFor( "air_height" )
local distance = self:GetSpecialValueFor( "throw_distance_behind" )
local radius = self:GetSpecialValueFor( "landing_radius" )
local stun = self:GetSpecialValueFor( "slow_duration" )
local damage = self:GetSpecialValueFor("impact_damage")

local reduce_duration = self:GetSpecialValueFor("shard_duration")

if caster:HasTalent("modifier_marci_dispose_4") then 
	--original_target:RemoveModifierByName("modifier_marci_dispose_custom_armor")
	--caster:RemoveModifierByName("modifier_marci_dispose_custom_armor")
	original_target:AddNewModifier(caster, self, "modifier_marci_dispose_custom_armor_cast", {duration = caster:GetTalentValue("modifier_marci_dispose_4", "duration")})
end 

if caster:HasTalent("modifier_marci_dispose_1") then 
	original_target:AddNewModifier(caster, self, "modifier_marci_dispose_custom_attacks", {max = caster:GetTalentValue("modifier_marci_dispose_1", "attacks"), damage = caster:GetTalentValue("modifier_marci_dispose_1", "damage") - 100})
end 

local ability = self

local targetpos = caster:GetOrigin() - caster:GetForwardVector() * distance
local targets = caster:FindTargets(radius, original_target:GetOrigin())
	
for _,target in pairs(targets) do 

	local totaldist = (target:GetOrigin() - targetpos):Length2D()
	if target:IsCreep() then 
		totaldist = 0
	end

	if caster:HasShard() and not target:IsDebuffImmune() then 
		target:Purge(true, false, false, false, false)
	end 

	local arc = target:AddNewModifier( caster, ability, "modifier_generic_arc", { target_x = targetpos.x, target_y = targetpos.y, duration = duration, distance = totaldist, height = height, fix_end = false, fix_duration = false, isStun = true, isForward = true, activity = ACT_DOTA_FLAIL, } )
	
	arc:SetEndCallback( function()
	
		if caster:HasShard() then
			target:AddNewModifier( caster, ability, "modifier_marci_dispose_custom_reduction", {duration = reduce_duration})
		end

		if caster:HasTalent("modifier_marci_dispose_5") then
			target:EmitSound("DOTA_Item.SilverEdge.Target")
			target:AddNewModifier(caster, ability, "modifier_generic_break", {duration = stun*(1 - target:GetStatusResistance())})
		end

		target:AddNewModifier( caster, ability, "modifier_marci_dispose_custom_slow", { duration = stun*(1 - target:GetStatusResistance()) } )

		DoDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })

		self:PlayEffects2( target:GetOrigin() )
		self:PlayEffects1( target:GetOrigin(), radius )
		GridNav:DestroyTreesAroundPoint( target:GetOrigin(), radius, false )

	end)

	self:PlayEffects3( target, duration )
	self:PlayEffects4( caster )
end

end



function marci_grapple_custom:PlayEffects1( point, radius )

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_dispose_land_aoe.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle, 0, point )
ParticleManager:SetParticleControl( particle, 1, Vector(radius, 0, 0) )
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex( particle )
EmitSoundOnLocationWithCaster( point, "Hero_Marci.Grapple.Impact", self:GetCaster() )
end

function marci_grapple_custom:PlayEffects2( point )

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_dispose_aoe_damage.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle, 1, point )
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex( particle )
EmitSoundOnLocationWithCaster( point, "Hero_Marci.Grapple.Stun", self:GetCaster() )
end

function marci_grapple_custom:PlayEffects3( target, duration )

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_dispose_debuff.vpcf", PATTACH_POINT_FOLLOW, target )
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






marci_dispose_hits = class({})

function marci_dispose_hits:GetChannelTime()
return self:GetSpecialValueFor("duration") + 0.1
end

function marci_dispose_hits:OnSpellStart()

local caster = self:GetCaster()

local point = self:GetCursorPosition()

local dir = point - caster:GetAbsOrigin()
dir.z = 0

caster:FaceTowards(point)
caster:SetForwardVector(dir:Normalized())

caster:AddNewModifier(caster, self, "modifier_marci_dispose_custom_hits", {duration = self:GetChannelTime()})


end


function marci_dispose_hits:OnChannelFinish(bInterrupted)

self:GetCaster():RemoveModifierByName("modifier_marci_dispose_custom_hits")
end




modifier_marci_dispose_custom_hits = class({})

function modifier_marci_dispose_custom_hits:IsHidden() return true end
function modifier_marci_dispose_custom_hits:IsPurgable() return false end
function modifier_marci_dispose_custom_hits:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.main = self.parent:FindAbilityByName("marci_grapple_custom")
self.distance = self.ability:GetSpecialValueFor("distance")
self.width = self.ability:GetSpecialValueFor("width")
self.max = self.parent:GetTalentValue("modifier_marci_dispose_7", "hits")
self.interval = self.ability:GetSpecialValueFor("duration")/(self.max - 1)

self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")

if not IsServer() then return end
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( particle, 1, self.parent, PATTACH_POINT_FOLLOW, "eye_l", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 2, self.parent, PATTACH_POINT_FOLLOW, "eye_r", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 5, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 6, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
self:AddParticle( particle, false, false, -1, false, false  )

self.main:PlayEffects4( self.parent )

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end



function modifier_marci_dispose_custom_hits:OnIntervalThink()
if not IsServer() then return end

self:SetStackCount(self:GetStackCount() + 1)
self.parent:FadeGesture(ACT_DOTA_ATTACK)
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 1.5)

self.parent:EmitSound("Marci.Dispose_hits_pre")

self.target_abs = self.parent:GetForwardVector()*self.distance + self.parent:GetAbsOrigin()

local k1 = RandomFloat(0.2, 0.9)
local k2 = RandomFloat(0.2, 0.9)

local particle_abs = self.target_abs
particle_abs.z = particle_abs.z + 100

local particle_1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( particle_1, 1, particle_abs)
ParticleManager:DestroyParticle(particle_1, false)
ParticleManager:ReleaseParticleIndex( particle_1 )


particle_abs = self.parent:GetForwardVector()*(self.distance*k1) + self.parent:GetAbsOrigin()
particle_abs.z = particle_abs.z + 100

local particle_2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( particle_2, 1, particle_abs)
ParticleManager:DestroyParticle(particle_2, false)
ParticleManager:ReleaseParticleIndex( particle_2 )


local attack = FindUnitsInLine(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin() , self.target_abs , nil, self.width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE)
local mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_dispose_custom_attacks_caster", {})

for _,enemy in pairs(attack) do 

	self.parent:PerformAttack(enemy, true, true, true, true, false, false, true)
	enemy:AddNewModifier(self.parent, self.ability, "modifier_marci_dispose_custom_hits_slow", {duration = self.slow_duration})

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt( particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )

	enemy:EmitSound("Marci.Dispose_hits")
end

if mod then 
	mod:Destroy()
end 

end


function modifier_marci_dispose_custom_hits:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_marci_dispose_custom_hits:GetActivityTranslationModifiers()
if self:GetStackCount()==self.max then
	return "flurry_pulse_attack"
end

end 




modifier_marci_dispose_custom_hits_slow = class({})
function modifier_marci_dispose_custom_hits_slow:IsHidden() return true end
function modifier_marci_dispose_custom_hits_slow:IsPurgable() return true end
function modifier_marci_dispose_custom_hits_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_marci_dispose_custom_hits_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack
end

function modifier_marci_dispose_custom_hits_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move
end


function modifier_marci_dispose_custom_hits_slow:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.move = self.ability:GetSpecialValueFor("slow")
self.attack = self.ability:GetSpecialValueFor("slow_attack")

if not IsServer() then return end
if not self.parent:IsRealHero() or self.parent:GetQuest() ~= "Marci.Quest_5" or self.parent:QuestCompleted() then return end

self:StartIntervalThink(0.1)
end


function modifier_marci_dispose_custom_hits_slow:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateQuest(0.1)
end







marci_dispose_jump = class({})


function marci_dispose_jump:GetCastRange(vLocation, hTarget)
if IsClient() then 
	return self:GetSpecialValueFor("distance")
end

return 999999
end

function marci_dispose_jump:GetAOERadius()
return self:GetSpecialValueFor("radius")
end


function marci_dispose_jump:OnSpellStart()

local caster = self:GetCaster()

local main = caster:FindAbilityByName("marci_grapple_custom")
if main then 
	main:PlayEffects4( caster )
end

self.radius = self:GetSpecialValueFor("radius")
self.distance = self:GetSpecialValueFor("distance")
self.duration_jump = self:GetSpecialValueFor("duration_jump")
self.max = caster:GetTalentValue("modifier_marci_dispose_7", "jump")

local main = caster:FindAbilityByName("marci_grapple_custom")

local point = self:GetCursorPosition()
if point == caster:GetAbsOrigin() then 
	point = caster:GetAbsOrigin() + caster:GetForwardVector()*10
end

local dir = (point - caster:GetAbsOrigin()):Normalized()

caster:SetForwardVector(dir)
caster:FaceTowards(point)

local dis = math.min(self.distance, (point - caster:GetAbsOrigin()):Length2D())
local speed = self.distance/self.duration_jump

local dur = (dis/speed)

local hei = 60
if dis < 100 then 
	hei = 0
end 

local arc = caster:AddNewModifier( caster, self, "modifier_generic_arc",
	{ 
	dir_x = caster:GetForwardVector().x,
	dir_y = caster:GetForwardVector().y,
	duration = dur,
	distance = dis,
	height = hei,
	fix_end = false,
	isStun = true,
	isForward = true,
	activity = ACT_DOTA_OVERRIDE_ABILITY_2,
})

if not arc then return end
	
arc:SetEndCallback( function( interrupted )

	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2_END, 1)
	local point = caster:GetAbsOrigin()

	local enemies = caster:FindTargets(self.radius, point) 
	local mod = caster:AddNewModifier(caster, self, "modifier_marci_dispose_custom_attacks_caster", {})

	for _,enemy in pairs(enemies) do
		caster:PerformAttack(enemy, true, true, true, true, false, false, true)
	end

	if mod then 
		mod:Destroy()
	end 

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( particle, 0, point )
	ParticleManager:SetParticleControl( particle, 1, Vector(self.radius*1.4,self.radius*1.4,self.radius*1.4) )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_bounce_impact.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point)
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 9, Vector(self.radius, self.radius, self.radius) )
	ParticleManager:SetParticleControl( effect_cast, 10, point )
	ParticleManager:DestroyParticle(effect_cast, false)
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( point, "Hero_Marci.Rebound.Impact", caster )

end)

end








marci_dispose_knockback = class({})



function marci_dispose_knockback:OnSpellStart()

local caster = self:GetCaster()
local main = caster:FindAbilityByName("marci_grapple_custom")
local target = self:GetCursorTarget()

for i = 1,2 do 
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end

target:AddNewModifier(caster, self, "modifier_marci_dispose_custom_knockback", {duration = self:GetSpecialValueFor("duration")})

end



modifier_marci_dispose_custom_knockback = class({})


function modifier_marci_dispose_custom_knockback:IsHidden() return true end

function modifier_marci_dispose_custom_knockback:OnCreated(params)
if not IsServer() then return end

self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self.main 		  = self.caster:FindAbilityByName("marci_grapple_custom")
self.cast_point = self.caster:GetAbsOrigin()

self.parent:StartGesture(ACT_DOTA_FLAIL)
self.tree_stun = false

self.knockback_duration   = self.ability:GetSpecialValueFor("duration")

self.main:PlayEffects3( self.parent, self.knockback_duration )
self.main:PlayEffects4( self.caster )

self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.stun = self.caster:GetTalentValue("modifier_marci_dispose_7", "tree")
self.max = self.caster:GetTalentValue("modifier_marci_dispose_7", "tree_attacks")

self.knockback_distance = self.ability:GetSpecialValueFor("distance")
self.knockback_speed = self.knockback_distance / self.knockback_duration

self.position = GetGroundPosition(Vector(self.cast_point.x, self.cast_point.y, 0), nil)

if self:ApplyHorizontalMotionController() == false then 
  self:Destroy()
  return
end

end

function modifier_marci_dispose_custom_knockback:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

local distance = (me:GetOrigin() - self.position):Normalized()
  
me:SetOrigin( me:GetOrigin() + distance * self.knockback_speed * dt )

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

local buildings = FindUnitsInRadius( self.caster:GetTeamNumber(), self.parent:GetOrigin(), nil, building_radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )

if #buildings>0 then
	self.tree_stun = true
end

if self.tree_stun == true then 
	self:Destroy()
	return
end

end



function modifier_marci_dispose_custom_knockback:DeclareFunctions()
return 
{
  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_marci_dispose_custom_knockback:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end


function modifier_marci_dispose_custom_knockback:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true
}
end

function modifier_marci_dispose_custom_knockback:OnDestroy()
if not IsServer() then return end
self.parent:RemoveHorizontalMotionController( self )
self.parent:FadeGesture(ACT_DOTA_FLAIL)


FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)

if not self.tree_stun then return end

self.main:PlayEffects1(self.parent:GetAbsOrigin(), self.radius )

local mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_marci_dispose_custom_attacks_caster", {})

self.caster:PerformAttack(self.parent, true, true, true, true, false, false, true)

if mod then 
	mod:Destroy()
end 


self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stun*(1 - self.parent:GetStatusResistance())})
self.main:PlayEffects2(self.parent:GetAbsOrigin())

end











modifier_marci_dispose_custom_tracker = class({})
function modifier_marci_dispose_custom_tracker:IsHidden() return true end
function modifier_marci_dispose_custom_tracker:IsPurgable() return false end

function modifier_marci_dispose_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.parent:AddSpellEvent(self)

self.ability = self:GetAbility()

self.armor_duration = self.parent:GetTalentValue("modifier_marci_dispose_4", "armor_duration", true)

self.legendary_skills = 
{
	["marci_grapple_custom"] = true,
	["marci_dispose_hits"] = true,
	["marci_dispose_jump"] = true,
	["marci_dispose_knockback"] = true,
}

self.legendary_duration = self.parent:GetTalentValue("modifier_marci_dispose_7", "duration", true)

self.mana = self.parent:GetTalentValue("modifier_marci_dispose_6", "mana", true)
self.shield_duration = self.parent:GetTalentValue("modifier_marci_dispose_6", "duration", true)

self.damage_duration = self.parent:GetTalentValue("modifier_marci_dispose_2", "duration", true)
end


function modifier_marci_dispose_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end



function modifier_marci_dispose_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end
if params.ability:IsItem() then return end

if self.parent:HasTalent("modifier_marci_dispose_2") then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_dispose_custom_damage", {duration = self.damage_duration})
end 

if self.parent:HasTalent("modifier_marci_dispose_7") and self.legendary_skills[params.ability:GetName()] then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_dispose_custom_swap", {duration = self.legendary_duration})
end 

if self.parent:HasTalent("modifier_marci_dispose_6") then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_dispose_custom_shield", {duration = self.shield_duration})
end 

end


function modifier_marci_dispose_custom_tracker:GetModifierPercentageManacostStacking()
local reduce = 0
if self.parent:HasTalent("modifier_marci_dispose_6") then 
	reduce = self.mana
end
return reduce
end


function modifier_marci_dispose_custom_tracker:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end
if not params.target:HasModifier("modifier_marci_dispose_custom_armor_cast") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_marci_dispose_custom_armor", {duration = self.armor_duration})
params.target:AddNewModifier(self.parent, self.ability, "modifier_marci_dispose_custom_armor", {duration = self.armor_duration})
end













modifier_marci_dispose_custom_slow = class({})

function modifier_marci_dispose_custom_slow:IsHidden() return false end
function modifier_marci_dispose_custom_slow:IsPurgable() 
if not self:GetCaster() or self:GetCaster():IsNull() then return true end
	return not self:GetCaster():HasTalent("modifier_marci_dispose_5") 
end

function modifier_marci_dispose_custom_slow:OnCreated( kv )

self.caster = self:GetCaster()
self.ability = self.caster:FindAbilityByName("marci_grapple_custom")
self.parent = self:GetParent()

if not self.ability then 
	self:Destroy()
	return
end 

self.ms_slow = -self.ability:GetSpecialValueFor( "slow_move" ) + self.caster:GetTalentValue("modifier_marci_dispose_5", "slow")

if not IsServer() then return end 


self.interval = FrameTime()
self:StartIntervalThink(self.interval)
end


function modifier_marci_dispose_custom_slow:OnIntervalThink()
if not IsServer() then return end
if not self.caster or self.caster:IsNull() then return end

if self.parent:IsRealHero() and self.caster:GetQuest() == "Marci.Quest_5" and not self.caster:QuestCompleted() then
	self:GetCaster():UpdateQuest(self.interval)
end

end


function modifier_marci_dispose_custom_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,	
}
end


function modifier_marci_dispose_custom_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_marci_dispose_custom_slow:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf"
end

function modifier_marci_dispose_custom_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_marci_dispose_custom_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_marci_dispose_custom_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end








modifier_marci_dispose_custom_swap = class({})
function modifier_marci_dispose_custom_swap:IsHidden() return true end
function modifier_marci_dispose_custom_swap:IsPurgable() return false end
function modifier_marci_dispose_custom_swap:OnCreated()
if not IsServer() then return end 
self.RemoveForDuel = true

self:GetAbility():SwapSkills()
end 

function modifier_marci_dispose_custom_swap:OnRefresh()
self:OnCreated()
end 


function modifier_marci_dispose_custom_swap:OnDestroy()
if not IsServer() then return end 

if self:GetRemainingTime() <= 0.1 or not self:GetParent():IsAlive() then 
	self:GetAbility():SwapSkills(true)
end 

end



modifier_marci_dispose_custom_reduction = class({})
function modifier_marci_dispose_custom_reduction:IsHidden() return true end
function modifier_marci_dispose_custom_reduction:IsPurgable() return false end
function modifier_marci_dispose_custom_reduction:OnCreated()
self.damage_reduce = self:GetAbility():GetSpecialValueFor("shard_damage")
end 

function modifier_marci_dispose_custom_reduction:GetEffectName()
  return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
end

function modifier_marci_dispose_custom_reduction:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end
function modifier_marci_dispose_custom_reduction:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}

end

function modifier_marci_dispose_custom_reduction:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_marci_dispose_custom_reduction:GetModifierSpellAmplify_Percentage()
return self.damage_reduce
end








modifier_marci_dispose_custom_attacks = class({})
function modifier_marci_dispose_custom_attacks:IsHidden() return true end
function modifier_marci_dispose_custom_attacks:IsPurgable() return false end
function modifier_marci_dispose_custom_attacks:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_marci_dispose_custom_attacks:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.interval = self.caster:GetTalentValue("modifier_marci_dispose_1", "interval", true)

self.max = table.max
self.damage = table.damage

self:SetStackCount(0)
self:StartIntervalThink(self.interval)
end

function modifier_marci_dispose_custom_attacks:OnIntervalThink()
if not IsServer() then return end
if not self.caster or self.caster:IsNull() or not self.caster:IsAlive() then 
	self:Destroy()
	return 
end

local mod = self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_marci_dispose_custom_attacks_caster", {damage = self.damage})

self.pos = self.parent:GetAbsOrigin() + ((self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized())*100
self.caster:PerformAttack(self.parent, true, true, true, true, false, false, true)


for i = 1,2 do 
	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( particle, 0,self.pos )
	ParticleManager:SetParticleControlEnt( particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end

self.parent:EmitSound("Marci.Dispose_hits")
if mod then 
	mod:Destroy()
end

self:IncrementStackCount()
if self:GetStackCount() >= self.max then 
	self:Destroy()
end

end



modifier_marci_dispose_custom_attacks_caster = class({})
function modifier_marci_dispose_custom_attacks_caster:IsHidden() return true end
function modifier_marci_dispose_custom_attacks_caster:IsPurgable() return false end
function modifier_marci_dispose_custom_attacks_caster:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end
function modifier_marci_dispose_custom_attacks_caster:GetModifierDamageOutgoing_Percentage()
return self.damage
end

function modifier_marci_dispose_custom_attacks_caster:OnCreated(table)
if not IsServer() then return end

self.mod = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_no_cleave", {})

self.damage = 0
if table.damage then 
	self.damage = table.damage
end 

end

function modifier_marci_dispose_custom_attacks_caster:OnDestroy()
if not IsServer() then return end 

if self.mod and not self.mod:IsNull() then 
	self.mod:Destroy()
end 

end 






modifier_marci_dispose_custom_armor = class({})
function modifier_marci_dispose_custom_armor:IsHidden() return false end
function modifier_marci_dispose_custom_armor:IsPurgable() return false end
function modifier_marci_dispose_custom_armor:GetTexture() return "buffs/dispose_str" end
function modifier_marci_dispose_custom_armor:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.armor = self.caster:GetTalentValue("modifier_marci_dispose_4", "armor")
self.max = self.caster:GetTalentValue("modifier_marci_dispose_4", "max")

if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then 
	self.armor = self.armor*-1
end 

self:SetStackCount(1)
end 

function modifier_marci_dispose_custom_armor:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

if self:GetStackCount() >= self.max and self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber() then 

	self.parent:EmitSound("Hoodwink.Acorn_armor")
	self.particle_peffect = ParticleManager:CreateParticle("particles/general/generic_armor_reduction.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)	
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self.parent:GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end 

end


function modifier_marci_dispose_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end


function modifier_marci_dispose_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end





modifier_marci_dispose_custom_armor_cast = class({})
function modifier_marci_dispose_custom_armor_cast:IsHidden() return true end
function modifier_marci_dispose_custom_armor_cast:IsPurgable() return false end
function modifier_marci_dispose_custom_armor_cast:OnCreated()
if not IsServer() then return end 

self.particle_peffect = ParticleManager:CreateParticle("particles/hoodwink/bush_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end








modifier_marci_dispose_custom_shield = class({})
function modifier_marci_dispose_custom_shield:IsHidden()  return false end
function modifier_marci_dispose_custom_shield:GetTexture() return "buffs/dispose_combo" end
function modifier_marci_dispose_custom_shield:IsPurgable() return false end

function modifier_marci_dispose_custom_shield:OnCreated(table)

self.parent = self:GetParent()

self.shield_talent = "modifier_marci_dispose_6"
self.shield = self.parent:GetTalentValue("modifier_marci_dispose_6", "shield")/100
self.max = self.parent:GetTalentValue("modifier_marci_dispose_6", "max")

self.add_shield =  self.shield*self.parent:GetMaxHealth()
self.max_shield = self.add_shield*self.max

if not IsServer() then return end

self:GetParent():EmitSound("MK.Mastery_Shield")
self.RemoveForDuel = true
self:AddShield()
end


function modifier_marci_dispose_custom_shield:OnRefresh()
self:AddShield()
end 

function modifier_marci_dispose_custom_shield:AddShield()
if not IsServer() then return end
self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + self.add_shield))
end 


function modifier_marci_dispose_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_marci_dispose_custom_shield:GetModifierIncomingDamageConstant( params )
if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
    	return self:GetStackCount()
    end 
end

if not IsServer() then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end



modifier_marci_dispose_custom_damage = class({})
function modifier_marci_dispose_custom_damage:IsHidden() return false end
function modifier_marci_dispose_custom_damage:IsPurgable() return false end
function modifier_marci_dispose_custom_damage:GetTexture() return "buffs/rebound_range_attacks" end
function modifier_marci_dispose_custom_damage:OnCreated()

self.parent = self:GetParent()
self.damage = self.parent:GetTalentValue("modifier_marci_dispose_2", "damage")
self.regen = self.parent:GetTalentValue("modifier_marci_dispose_2", "regen")
self.max = self.parent:GetTalentValue("modifier_marci_dispose_2", "max")

self:SetStackCount(1)
end


function modifier_marci_dispose_custom_damage:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_marci_dispose_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end


function modifier_marci_dispose_custom_damage:GetModifierConstantHealthRegen()
return self:GetStackCount()*self.regen
end

function modifier_marci_dispose_custom_damage:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()*self.damage
end