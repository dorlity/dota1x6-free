LinkLuaModifier("modifier_slark_pounce_custom_arc", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_leash", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_legendary_fish", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_attacks", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_attacks_damage", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_armor_field", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_armor_effect", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_armor_aura", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_shield", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_silence", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_scepter", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_pounce_custom_scepter_speed", "abilities/slark/slark_pounce_custom", LUA_MODIFIER_MOTION_NONE)


slark_pounce_custom = class({})


function slark_pounce_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_pounce_start.vpcf", context )
PrecacheResource( "particle","particles/slark/pounce_ground.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_pounce_leash.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_pounce_trail.vpcf", context )
PrecacheResource( "particle","particles/slark/pounce_legendary_refresh.vpcf", context )
PrecacheResource( "particle","particles/slark/pounce_legendary_water.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_shard_fish_bait.vpcf", context )
PrecacheResource( "particle","particles/econ/items/lion/fish_stick/fish_stick_splash.vpcf", context )
PrecacheResource( "particle","particles/slark/pounce_legendary_cast.vpcf", context )
PrecacheResource( "particle","particles/slark/pounce_armora.vpcf", context )
PrecacheResource( "particle","particles/slark/pounce_slow.vpcf", context )
PrecacheResource( "particle","particles/items4_fx/nullifier_mute.vpcf", context )

PrecacheUnitByNameSync("npc_dota_slark_fish_legendary", context, -1)

end


function slark_pounce_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_slark_pounce_custom_scepter") then
  return "pounce_scepter"
end
return "slark_pounce"
end



function slark_pounce_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("pounce_distance")*(1 + self:GetCaster():GetTalentValue("modifier_slark_pounce_3", "range")/100) - self:GetCaster():GetCastRangeBonus()
end

function slark_pounce_custom:GetManaCost(level)
if self:GetCaster():HasScepter() then 
  return 0 
end 
return self.BaseClass.GetManaCost(self,level)
end

function slark_pounce_custom:GetCooldown(iLevel)
local bonus = 0 
if self:GetCaster():HasTalent("modifier_slark_pounce_3") then 
	bonus = self:GetCaster():GetTalentValue("modifier_slark_pounce_3", "cd")
end
return (self.BaseClass.GetCooldown(self, iLevel) + bonus)
end

function slark_pounce_custom:ProcEffects(target, main)
local caster = self:GetCaster()

if caster:HasTalent("modifier_slark_pounce_1") and main then
	target:AddNewModifier(caster, self, "modifier_slark_pounce_custom_attacks", {duration = 3})
end

if caster:HasTalent("modifier_slark_pounce_7") then
	local damage = caster:GetAverageTrueAttackDamage(nil)*caster:GetTalentValue("modifier_slark_pounce_7", "damage")/100
	DoDamage({victim = target, attacker = caster, ability = self, damage_type = DAMAGE_TYPE_PHYSICAL, damage = damage}, "modifier_slark_pounce_7")
end

end


function slark_pounce_custom:ApplyEffect(target, point, radius, main)
local caster = self:GetCaster()
local leash_duration = self:GetSpecialValueFor( "leash_duration" ) + self:GetCaster():GetTalentValue("modifier_slark_pounce_2", "duration")

if not main or main == 0 then
	leash_duration = leash_duration*caster:GetTalentValue("modifier_slark_pounce_7", "leash")/100
end

if target:IsCreep() then
	for _,creep in pairs(caster:FindTargets(caster:GetTalentValue("modifier_slark_pounce_7", "creep_radius", true), target:GetAbsOrigin())) do
		self:ProcEffects(creep, target == creep)
	end
else
	self:ProcEffects(target, true)
end

if caster:HasTalent("modifier_slark_pounce_6") then
	target:AddNewModifier(caster, self, "modifier_slark_pounce_custom_silence", {duration = (1 - target:GetStatusResistance())*caster:GetTalentValue("modifier_slark_pounce_6", "silence")})
end

if caster:HasTalent("modifier_slark_pounce_5") and main == 1 then
	caster:RemoveModifierByName("modifier_slark_pounce_custom_shield")
	caster:AddNewModifier(caster, self, "modifier_slark_pounce_custom_shield", {duration = caster:GetTalentValue("modifier_slark_pounce_5", "duration")})
end

target:RemoveModifierByName("modifier_slark_pounce_custom_leash")
target:AddNewModifier( caster, caster:BkbAbility(self, caster:HasScepter()), "modifier_slark_pounce_custom_leash", {main = main, radius = radius, x = point.x, y = point.y, duration = leash_duration*(1 - target:GetStatusResistance())})
target:EmitSound("Hero_Slark.Pounce.Impact")
end


function slark_pounce_custom:OnSpellStart()
local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_slark_pounce_custom_scepter")
local no_target = 0

if mod then
	no_target = 1
	mod:Destroy()
end

caster:AddNewModifier(caster, self, "modifier_slark_pounce_custom_arc", {no_target = no_target})
end




modifier_slark_pounce_custom_arc = class({})
function modifier_slark_pounce_custom_arc:IsHidden() return true end
function modifier_slark_pounce_custom_arc:IsPurgable() return false end
function modifier_slark_pounce_custom_arc:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetAbility()

local speed = self.ability:GetSpecialValueFor( "pounce_speed" )*(1 + self.parent:GetTalentValue("modifier_slark_pounce_3", "range")/100)
local distance = self.ability:GetSpecialValueFor( "pounce_distance" )*(1 + self.parent:GetTalentValue("modifier_slark_pounce_3", "range")/100)

self.radius = self.ability:GetSpecialValueFor( "pounce_radius" )
self.leash_radius = self.ability:GetSpecialValueFor( "leash_radius" )
self.scepter_duration = self.ability:GetSpecialValueFor("scepter_duration")

local duration = distance/speed
local height = 160

self.hit = false

if not IsServer() then return end

self.no_target = kv.no_target

if self.no_target == 0 and self.parent:HasScepter() then
	self.ability:EndCooldown()
	self.ability:StartCooldown(duration + 0.1)
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_pounce_custom_scepter", {duration = self.scepter_duration})
end

if self.parent:HasTalent("modifier_slark_pounce_5") then
	ProjectileManager:ProjectileDodge(self.parent)
	self.bkb_mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {})
end

self.parent:EmitSound("Hero_Slark.Pounce.Cast")
self.parent:StartGesture(ACT_DOTA_SLARK_POUNCE)

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_pounce_start.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(effect_cast)

local point = self.parent:GetAbsOrigin() + self.parent:GetForwardVector()*distance

self.arc = self.parent:AddNewModifier( self.parent, self.ability,  "modifier_generic_arc",
{
  target_x = point.x,
  target_y = point.y,
  distance = distance,
  speed = speed,
  height = height,
  fix_end = false,
  isStun = false,
})

self.arc:SetEndCallback(function()
	if self and not self:IsNull() then 
		self.arc = nil
		self:Destroy()
	end
end)

self:SetDuration( duration, true )
self.interval = FrameTime()

self:StartIntervalThink( self.interval )
self:OnIntervalThink()
end


function modifier_slark_pounce_custom_arc:OnDestroy()
if not IsServer() then return end
GridNav:DestroyTreesAroundPoint( self.parent:GetOrigin(), 100, false )

if self.bkb_mod and not self.bkb_mod:IsNull() then
	self.bkb_mod:Destroy()
end

if self.parent:HasShard() then
	local mod = self.parent:FindModifierByName("modifier_slark_innate_custom")
	if mod then
		mod:ApplyEffect()
	end
end

if self.hit == false then
	if self.parent:HasTalent("modifier_slark_pounce_7") then

		local effect = ParticleManager:CreateParticle("particles/slark/pounce_legendary_refresh.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt( effect, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex(effect)

		self.parent:EmitSound("Slark.Pounce_legendary_refresh")

		local ability = self.parent:FindAbilityByName("slark_pounce_custom_legendary")
		if ability and self.parent:HasTalent("modifier_slark_pounce_7") then
			ability:AddCharge(self.parent:GetTalentValue("modifier_slark_pounce_7", "charge_return"))
		end
	end
else
	if self.parent:HasScepter() then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_slark_pounce_custom_scepter_speed", {duration = self.scepter_duration})
	end
end

if self.arc and not self.arc:IsNull() then
	self.arc:Destroy()
end

end


function modifier_slark_pounce_custom_arc:CheckState()
return 
{
	[MODIFIER_STATE_DISARMED] = true,
}
end


function modifier_slark_pounce_custom_arc:OnIntervalThink()
if self.hit == true then return end
if self.no_target == 1 then return end

local targets = self.parent:FindTargets(self.radius)

local target
for _,enemy in pairs(targets) do
	if enemy:IsRealHero() then
		target = enemy
		break
	end
end

if not target then return end

self.hit = true

self.ability:ApplyEffect(target, self.parent:GetAbsOrigin(), self.leash_radius, 1)
self.parent:MoveToTargetToAttack(target)
self:Destroy()
end


function modifier_slark_pounce_custom_arc:GetEffectName()
return "particles/units/heroes/hero_slark/slark_pounce_trail.vpcf"
end

function modifier_slark_pounce_custom_arc:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end





modifier_slark_pounce_custom_leash = class({})
function modifier_slark_pounce_custom_leash:IsHidden() return false end
function modifier_slark_pounce_custom_leash:IsPurgable() return false end
function modifier_slark_pounce_custom_leash:GetTexture() return "slark_pounce" end
function modifier_slark_pounce_custom_leash:OnCreated( table )
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.attack_speed = self.caster:GetTalentValue("modifier_slark_pounce_2", "speed")

if not IsServer() then return end

self.center =  GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.radius = table.radius
self.real_radius = self.radius

if table.main == 1 and self.caster:HasTalent("modifier_slark_pounce_6") then
	self.real_radius = self.real_radius + self.caster:GetTalentValue("modifier_slark_pounce_6", "range")
end

self.max_speed = 550
self.min_speed = 0.1
self.max_min = self.max_speed-self.min_speed
self.half_width = 50

self.parent:EmitSound("Hero_Slark.Pounce.Leash")

AddFOWViewer(self.caster:GetTeamNumber(), self.center, 500, self:GetRemainingTime(), false)

if not self.caster:HasTalent("modifier_slark_pounce_4") then
	local effect_cast = ParticleManager:CreateParticle( "particles/slark/pounce_ground.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.center )
	ParticleManager:SetParticleControl( effect_cast, 3, self.center )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( self.radius, self:GetRemainingTime(), 0 ) )
	self:AddParticle( effect_cast, false, false, -1, false, false )
else
	local duration = self:GetRemainingTime() + self.caster:GetTalentValue("modifier_slark_pounce_4", "linger")
	CreateModifierThinker(self.caster, self.caster:BkbAbility(self.ability, self.caster:HasScepter()) , "modifier_slark_pounce_custom_armor_field", {radius = self.radius, duration = duration }, self.center, self.caster:GetTeamNumber(), false)
end

local leash_effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_pounce_leash.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( leash_effect, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControl( leash_effect, 3, self.center )
self:AddParticle( leash_effect, false, false, -1, false, false)

if self.caster:GetQuest() ~= "Slark.Quest_6" then return end
if not self.parent:IsRealHero() then return end
if self.caster:QuestCompleted() then return end

self:StartIntervalThink(0.1)
end

function modifier_slark_pounce_custom_leash:OnIntervalThink()
if not IsServer() then return end
self.caster:UpdateQuest(0.1)
end

function modifier_slark_pounce_custom_leash:OnDestroy()
if not IsServer() then return end

self.parent:StopSound("Hero_Slark.Pounce.Leash")
self.parent:EmitSound("Hero_Slark.Pounce.End")
end


function modifier_slark_pounce_custom_leash:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_slark_pounce_custom_leash:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_slark_pounce_custom_leash:DeclareFunctions()
return  
{
	MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_slark_pounce_custom_leash:GetModifierAttackSpeedBonus_Constant()
if not self.caster:HasTalent("modifier_slark_pounce_2") then return end
return self.attack_speed
end

function modifier_slark_pounce_custom_leash:GetModifierMoveSpeed_Limit( params )
if not IsServer() then return end

local parent_vector = self.parent:GetOrigin()-self.center
local parent_direction = parent_vector:Normalized()
local actual_distance = parent_vector:Length2D()
local wall_distance =  self.real_radius-actual_distance

if wall_distance<(-self.half_width) then
	self:Destroy()
	return 0
end

local parent_angle = VectorToAngles(parent_direction).y
local unit_angle = self.parent:GetAnglesAsVector().y
local wall_angle = math.abs( AngleDiff( parent_angle, unit_angle ) )

local limit = 0
if wall_angle<=90 then
	if wall_distance<0 then
		limit = self.min_speed
	else
		limit = (wall_distance/self.half_width)*self.max_min + self.min_speed
	end
end

return limit
end


function modifier_slark_pounce_custom_leash:CheckState()
return 
{
	[MODIFIER_STATE_TETHERED] = true,
}
end




slark_pounce_custom_legendary = class({})
function slark_pounce_custom_legendary:CreateTalent()
self:SetHidden(false)
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "ability_slark_pounce_legendary",  {})
end

function slark_pounce_custom_legendary:GetCastRange()
return self:GetSpecialValueFor("range")
end

function slark_pounce_custom_legendary:GetAbilityChargeRestoreTime(level)
return self:GetSpecialValueFor("cd")
end

function slark_pounce_custom_legendary:GetAOERadius()
return self:GetSpecialValueFor("radius")
end

function slark_pounce_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local point = self:GetCursorPosition()
if point == caster:GetAbsOrigin() then
	point = caster:GetAbsOrigin() + caster:GetForwardVector()*10
end

local dir = point - caster:GetAbsOrigin()
dir.z = 0

local abs = caster:GetAbsOrigin() + dir:Normalized()*85
local min_dist = self:GetSpecialValueFor("min_dist")

if dir:Length() < min_dist then
	point = caster:GetAbsOrigin() + dir:Normalized()*min_dist
end

local fish = CreateUnitByName("npc_dota_slark_fish_legendary", abs, false, caster, caster, caster:GetTeamNumber())
caster:EmitSound("Slark.Pounce_legendary_cast")
fish:EmitSound("Slark.Pounce_legendary_fish")
fish:AddNewModifier(caster, self, "modifier_slark_pounce_custom_legendary_fish", {x = point.x, y = point.y})

local effect_point = abs + Vector(0, 0, 75)

local effect_cast = ParticleManager:CreateParticle( "particles/slark/pounce_legendary_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControl(effect_cast, 3, effect_point)
ParticleManager:SetParticleControlForward( effect_cast, 3, caster:GetForwardVector() )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex(effect_cast)


fish:FaceTowards(point)
fish:SetForwardVector(dir:Normalized())
end



modifier_slark_pounce_custom_legendary_fish = class({})
function modifier_slark_pounce_custom_legendary_fish:IsHidden() return true end
function modifier_slark_pounce_custom_legendary_fish:IsPurgable() return false end
function modifier_slark_pounce_custom_legendary_fish:RemoveOnDeath() return false end
function modifier_slark_pounce_custom_legendary_fish:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

if not IsServer() then return end

self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.dist = (self.parent:GetAbsOrigin() - self.point):Length2D()
self.speed = self.ability:GetSpecialValueFor("speed")
self.radius = self.ability:GetSpecialValueFor("radius")
self.leash_radius = self.ability:GetSpecialValueFor("leash_radius")
self.duration = self.ability:GetSpecialValueFor("duration")
self.tower_duration = self.ability:GetSpecialValueFor("tower_duration")

self.pounce = self.caster:FindAbilityByName("slark_pounce_custom")

self.time = self.dist/self.speed

self.parent:FadeGesture(ACT_DOTA_SPAWN)
self.parent:StartGesture(ACT_DOTA_RUN)

self.stage = 0

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end


function modifier_slark_pounce_custom_legendary_fish:OnIntervalThink()
if not IsServer() then return end

local point = self.parent:GetAbsOrigin()

if self.stage == 0 then
	if (point - self.point):Length2D() <= 30 or self:GetElapsedTime() >= (self.time + 1) then
		self.stage = 1
		self.parent:Stop()

		local duration = self.duration

		if self.parent:NearTower() then
			duration = self.tower_duration
		end

		self:SetDuration(duration, true)
		self.parent:FadeGesture(ACT_DOTA_RUN)
		self.parent:StartGesture(ACT_DOTA_SPAWN)
		self.parent:EmitSound("Slark.Pounce_legendary_fish_end")
		--self.parent:EmitSound("Slark.Pounce_legendary_fish_loop")

		local effect_cast1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast1, 0, self.parent:GetAbsOrigin() )
		ParticleManager:SetParticleControl( effect_cast1, 3, self.parent:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(effect_cast1)

		local effect_cast = ParticleManager:CreateParticle( "particles/slark/pounce_legendary_water.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector(self.radius, 0, 0))
		self:AddParticle( effect_cast, false, false, -1, false, false )
	else
		self.parent:MoveToPosition(self.point)
	end
elseif self.stage == 1 then
	local targets = self.caster:FindTargets(self.radius, point)

	if #targets > 0 and self.pounce and self.pounce:IsTrained() then
		self.parent:EmitSound("Slark.Pounce_legendary_fish_hit")

		local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_tidehunter/tidehunter_gush_splash.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 3, self.parent:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex(effect_cast)

		self.pounce:ApplyEffect(targets[1], point, self.leash_radius, 0)
		self.stage = 2
		self:Destroy()
	end
end

end


function modifier_slark_pounce_custom_legendary_fish:OnDestroy()
if not IsServer() then return end
self.parent:EmitSound("Slark.Pounce_legendary_fish_destroy")
--self.parent:StopSound("Slark.Pounce_legendary_fish_loop")
self.parent:Kill(nil, nil)
end



function modifier_slark_pounce_custom_legendary_fish:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = self.stage ~= 0,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true
}
end


function modifier_slark_pounce_custom_legendary_fish:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
}
end

function modifier_slark_pounce_custom_legendary_fish:GetModifierMoveSpeed_Absolute()
return self.speed
end

function modifier_slark_pounce_custom_legendary_fish:GetActivityTranslationModifiers()
return "haste"
end


modifier_slark_pounce_custom_attacks = class({})
function modifier_slark_pounce_custom_attacks:IsHidden() return true end
function modifier_slark_pounce_custom_attacks:IsPurgable() return false end
function modifier_slark_pounce_custom_attacks:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_slark_pounce_custom_attacks:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.interval = self.caster:GetTalentValue("modifier_slark_pounce_1", "interval")
self.attacks = self.caster:GetTalentValue("modifier_slark_pounce_1", "attacks")

self:StartIntervalThink(self.interval)
end

function modifier_slark_pounce_custom_attacks:OnIntervalThink()
if not IsServer() then return end
self.caster:AddNewModifier(self.caster, self.ability, "modifier_slark_pounce_custom_attacks_damage", {duration = FrameTime()})
self.caster:PerformAttack(self.parent, true, true, true, true, false, false, true)
self.parent:EmitSound("Hero_Slark.Attack")
self.caster:RemoveModifierByName("modifier_slark_pounce_custom_attacks_damage")

self:IncrementStackCount()
if self:GetStackCount() >= self.attacks then
	self:Destroy()
end

end

modifier_slark_pounce_custom_attacks_damage = class({})
function modifier_slark_pounce_custom_attacks_damage:IsHidden() return true end
function modifier_slark_pounce_custom_attacks_damage:IsPurgable() return false end
function modifier_slark_pounce_custom_attacks_damage:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_slark_pounce_1", "damage") - 100
end

function modifier_slark_pounce_custom_attacks_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
}
end

function modifier_slark_pounce_custom_attacks_damage:GetModifierDamageOutgoing_Percentage()
return self.damage
end




modifier_slark_pounce_custom_armor_field = class({})
function modifier_slark_pounce_custom_armor_field:IsHidden() return true end
function modifier_slark_pounce_custom_armor_field:IsPurgable() return false end
function modifier_slark_pounce_custom_armor_field:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.center = self.parent:GetAbsOrigin()

if not IsServer() then return end

self.radius = table.radius

local effect_cast = ParticleManager:CreateParticle( "particles/slark/pounce_ground.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, self.center )
ParticleManager:SetParticleControl( effect_cast, 3, self.center )
ParticleManager:SetParticleControl( effect_cast, 4, Vector( self.radius, self:GetRemainingTime(), 0 ) )
self:AddParticle( effect_cast, false, false, -1, false, false )
end

function modifier_slark_pounce_custom_armor_field:IsAura() return true end
function modifier_slark_pounce_custom_armor_field:GetAuraDuration() return 0.1 end
function modifier_slark_pounce_custom_armor_field:GetAuraRadius() return self.radius end
function modifier_slark_pounce_custom_armor_field:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_slark_pounce_custom_armor_field:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_slark_pounce_custom_armor_field:GetModifierAura() return "modifier_slark_pounce_custom_armor_aura" end


modifier_slark_pounce_custom_armor_aura = class({})
function modifier_slark_pounce_custom_armor_aura:IsHidden() return true end
function modifier_slark_pounce_custom_armor_aura:IsPurgable() return false end
function modifier_slark_pounce_custom_armor_aura:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.effect_duration = self.caster:GetTalentValue("modifier_slark_pounce_4", "duration")
if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(0.2)
end

function modifier_slark_pounce_custom_armor_aura:OnIntervalThink()
if not IsServer() then return end

self.parent:AddNewModifier(self.caster, self.ability, "modifier_slark_pounce_custom_armor_effect", {duration = self.effect_duration})
end


modifier_slark_pounce_custom_armor_effect = class({})
function modifier_slark_pounce_custom_armor_effect:IsHidden() return false end
function modifier_slark_pounce_custom_armor_effect:IsPurgable() return false end
function modifier_slark_pounce_custom_armor_effect:GetTexture() return "buffs/pounce_armor" end
function modifier_slark_pounce_custom_armor_effect:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.max = self.caster:GetTalentValue("modifier_slark_pounce_4", "max")
self.slow = self.caster:GetTalentValue("modifier_slark_pounce_4", "slow")
self.armor = self.caster:GetTalentValue("modifier_slark_pounce_4", "armor")

if not IsServer() then return end
self:StartIntervalThink(0.98)
end

function modifier_slark_pounce_custom_armor_effect:OnIntervalThink()
if not IsServer() then return end

if self.parent:HasModifier("modifier_slark_pounce_custom_armor_aura") and self:GetStackCount() < self.max then
	self:IncrementStackCount()
	if self:GetStackCount() >= self.max then
		self.parent:EmitSound("Slark.Pounce_armor")
		self.parent:GenericParticle("particles/slark/pounce_armora.vpcf", self, true)
		self.parent:GenericParticle("particles/slark/pounce_slow.vpcf", self)
	end
end

end

function modifier_slark_pounce_custom_armor_effect:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_slark_pounce_custom_armor_effect:GetModifierPhysicalArmorBonus()
return self.armor*self:GetStackCount()
end

function modifier_slark_pounce_custom_armor_effect:GetModifierMoveSpeedBonus_Percentage()
return self.slow*self:GetStackCount()
end






modifier_slark_pounce_custom_shield = class({})
function modifier_slark_pounce_custom_shield:IsHidden() return true end
function modifier_slark_pounce_custom_shield:IsPurgable() return false end
function modifier_slark_pounce_custom_shield:OnCreated(table)
self.parent = self:GetParent()

self.shield_talent = "modifier_slark_pounce_5"
self.max_shield = self.parent:GetTalentValue("modifier_slark_pounce_5", "shield")*self.parent:GetMaxHealth()/100

if not IsServer() then return end
self.RemoveForDuel = true
self.parent:GenericParticle("particles/slark/pact_damage.vpcf", self)
self:SetStackCount(self.max_shield)
end

function modifier_slark_pounce_custom_shield:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_slark_pounce_custom_shield:GetModifierIncomingDamageConstant( params )

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




modifier_slark_pounce_custom_silence = class({})
function modifier_slark_pounce_custom_silence:IsHidden() return true end
function modifier_slark_pounce_custom_silence:IsPurgable() return true end
function modifier_slark_pounce_custom_silence:GetEffectName()
return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end 

function modifier_slark_pounce_custom_silence:GetStatusEffectName()
return "particles/status_fx/status_effect_nullifier.vpcf"
end 

function modifier_slark_pounce_custom_silence:StatusEffectPriority()
return MODIFIER_PRIORITY_SUPER_ULTRA 
end 

function modifier_slark_pounce_custom_silence:OnCreated()
self.parent = self:GetParent()
if not IsServer() then return end 
self.parent:EmitSound("Slark.Pounce_silence")
self.parent:GenericParticle("particles/items4_fx/nullifier_mute.vpcf", self, true)

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 

function modifier_slark_pounce_custom_silence:OnIntervalThink()
if not IsServer() then return end 
if self.parent:IsDebuffImmune() then return end
self.parent:Purge(true, false, false, false,false)
end 


function modifier_slark_pounce_custom_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end


modifier_slark_pounce_custom_scepter = class({})
function modifier_slark_pounce_custom_scepter:IsHidden() return false end
function modifier_slark_pounce_custom_scepter:IsPurgable() return false end
function modifier_slark_pounce_custom_scepter:OnDestroy()
if not IsServer() then return end

local ability = self:GetAbility()
local cd = ability:GetCooldown(ability:GetLevel()) - self:GetElapsedTime()

ability:EndCooldown()
ability:StartCooldown(cd)
end


modifier_slark_pounce_custom_scepter_speed = class({})
function modifier_slark_pounce_custom_scepter_speed:IsHidden() return true end
function modifier_slark_pounce_custom_scepter_speed:IsPurgable() return false end
function modifier_slark_pounce_custom_scepter_speed:OnCreated()
self.speed = self:GetAbility():GetSpecialValueFor("scepter_speed")
end

function modifier_slark_pounce_custom_scepter_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_slark_pounce_custom_scepter_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end