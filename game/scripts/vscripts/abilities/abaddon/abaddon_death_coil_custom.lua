LinkLuaModifier( "modifier_abaddon_death_coil_custom_legendary_unit", "abilities/abaddon/abaddon_death_coil_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_death_coil_custom_double_proc", "abilities/abaddon/abaddon_death_coil_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_death_coil_custom_cd", "abilities/abaddon/abaddon_death_coil_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_death_coil_custom_buff", "abilities/abaddon/abaddon_death_coil_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_death_coil_custom_tracker", "abilities/abaddon/abaddon_death_coil_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_death_coil_custom_leash", "abilities/abaddon/abaddon_death_coil_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_death_coil_custom_count", "abilities/abaddon/abaddon_death_coil_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_death_coil_custom_cdr", "abilities/abaddon/abaddon_death_coil_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_death_coil_custom_shard_proc", "abilities/abaddon/abaddon_death_coil_custom", LUA_MODIFIER_MOTION_NONE )


abaddon_death_coil_custom = class({})
abaddon_death_coil_custom.thinkers = {}

function abaddon_death_coil_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_abaddon_alliance_weapon_custom") then
  return "abaddon_death_coil_alliance"
end
return "abaddon_death_coil"
end

function abaddon_death_coil_custom:CreateTalent(name)
self:ToggleAutoCast()
end

function abaddon_death_coil_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_death_coil_abaddon.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_legendary_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_mist_coil_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_legendary_area.vpcf", context )
PrecacheResource( "particle", "particles/shrine/capture_point_ring_clock_overthrow.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_legendary_casti.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_proje.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_proj.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_legendary_cast.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_leash.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_speed.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/coil_cdr.vpcf", context )
end

function abaddon_death_coil_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_abaddon_death_coil_custom_tracker"
end

function abaddon_death_coil_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasTalent("modifier_abaddon_hero_5") then 
	bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE + bonus
end


function abaddon_death_coil_custom:CastFilterResultTarget(target)
local caster = self:GetCaster()
local team = DOTA_UNIT_TARGET_TEAM_ENEMY
if not IsSoloMode() then
	team = DOTA_UNIT_TARGET_TEAM_BOTH
end
if target == caster then
	return UF_FAIL_CUSTOM
end
return UnitFilter(target, team, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, caster:GetTeamNumber())
end

function abaddon_death_coil_custom:GetCustomCastErrorTarget( hTarget )
return "#dota_hud_error_cant_cast_on_self"
end

function abaddon_death_coil_custom:GetCastPoint()
local bonus = 0
if self:GetCaster():HasTalent("modifier_abaddon_mist_4") then 
  bonus = self:GetCaster():GetTalentValue("modifier_abaddon_mist_4", "cast")
end
return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end

function abaddon_death_coil_custom:GetManaCost(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_abaddon_mist_2") then  
  bonus = self:GetCaster():GetTalentValue("modifier_abaddon_mist_2", "mana")
end
return self.BaseClass.GetManaCost(self,level) + bonus
end

function abaddon_death_coil_custom:GetCooldown(level)
local bonus = 0
local caster = self:GetCaster()
if caster:HasScepter() and caster:HasModifier("modifier_abaddon_borrowed_time_custom") then
	return self:GetSpecialValueFor("scepter_cd")
end
if caster:HasTalent("modifier_abaddon_mist_2") then
	bonus = caster:GetTalentValue("modifier_abaddon_mist_2", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end


function abaddon_death_coil_custom:GetAOERadius()
return self:GetSpecialValueFor("effect_radius")
end

function abaddon_death_coil_custom:GetSelfDamage()
local self_damage = self:GetSpecialValueFor("self_damage")/100
local damage = self:GetSpecialValueFor("target_damage")
return damage*self_damage
end


function abaddon_death_coil_custom:GetHealthCost(level)
if IsServer() then return end
return self:GetSelfDamage()
end 


function abaddon_death_coil_custom:GetProjectile()
return self:GetCaster():HasModifier("modifier_abaddon_alliance_weapon_custom") and "particles/econ/items/abaddon/abaddon_alliance/abaddon_death_coil_alliance.vpcf" or "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"
end



function abaddon_death_coil_custom:OnSpellStart(new_target)
local target = self:GetCursorTarget()
local caster = self:GetCaster()

if new_target then 
	target = new_target
end

local self_damage = self:GetSpecialValueFor("self_damage")/100
local damage = self:GetSpecialValueFor("target_damage")
local radius = self:GetSpecialValueFor("effect_radius")

local projectile_speed = self:GetSpecialValueFor("missile_speed")
local projectile_name = self:GetProjectile()

if not new_target then

	if caster:HasTalent("modifier_abaddon_hero_1") then 
		caster:AddNewModifier(caster, self, "modifier_abaddon_death_coil_custom_buff", {duration = caster:GetTalentValue("modifier_abaddon_hero_1", "duration", true)})
	end 

	if caster:HasTalent("modifier_abaddon_mist_4") and not caster:HasModifier("modifier_abaddon_death_coil_custom_cdr") then 
		caster:AddNewModifier(caster, self, "modifier_abaddon_death_coil_custom_count", {duration = caster:GetTalentValue("modifier_abaddon_mist_4", "count_duration")})
	end 

	local damageTable = {victim = caster, attacker = caster, damage = self:GetSelfDamage(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS, ability = self, }
	DoDamage(damageTable)
end

local double = 0
if new_target and caster:HasTalent("modifier_abaddon_mist_3") then 
	double = 1
end

local pull = 0

local info = {
	Source = caster,
	Ability = self,	
	
	EffectName = projectile_name,
	iMoveSpeed = projectile_speed,
	bDodgeable = true, 
}

local targets = caster:FindTargets(radius, target:GetAbsOrigin())
table.insert(targets, target)

local hits = {}

for _,enemy in pairs(targets) do 
	if not hits[enemy] then
		hits[enemy] = true
		info.Target = enemy

		local dodge = true
		if enemy == target then 
			local pull = 0
		  if caster:HasTalent("modifier_abaddon_hero_5") and self:GetAutoCastState() and not target:HasModifier("modifier_abaddon_death_coil_custom_cd") then
				target:AddNewModifier(caster, self, "modifier_abaddon_death_coil_custom_cd", {duration = caster:GetTalentValue("modifier_abaddon_hero_5", "cd")})
		  	pull = 1
		  	dodge = false
		  end
			info.ExtraData = {main = 1, double = double, pull = pull}
		else 
			info.ExtraData = {main = 0, double = double}
		end 

		info.bDodgeable = dodge
		ProjectileManager:CreateTrackingProjectile(info)
	end
end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_death_coil_abaddon.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:ReleaseParticleIndex( effect_cast )
caster:EmitSound("Hero_Abaddon.DeathCoil.Cast")
end 



function abaddon_death_coil_custom:OnProjectileHit_ExtraData(target, location, table)
if not target then return end

local caster = self:GetCaster()
local is_enemy = caster:GetTeamNumber() ~= target:GetTeamNumber()

if is_enemy then
	if target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then return end
end

if caster:HasShard() and is_enemy then 

	caster:AddNewModifier(caster, self, "modifier_abaddon_death_coil_custom_shard_proc", {main = table.main, double = table.double})
	caster:PerformAttack(target, true, true, true, true, false, false, true)
	caster:RemoveModifierByName("modifier_abaddon_death_coil_custom_shard_proc")
end 

local ability = nil
local damage_k = 1

if table.heal and table.heal == 1 then 
	ability = "modifier_abaddon_mist_7"
	damage_k = caster:GetTalentValue("modifier_abaddon_mist_7", "damage")/100
end 

if table.double and table.double == 1 then
	ability = "modifier_abaddon_mist_3" 
end 

local target_damage = self:GetSpecialValueFor("target_damage") + caster:GetAverageTrueAttackDamage(nil)*caster:GetTalentValue("modifier_abaddon_mist_1", "damage")/100

if is_enemy then
	real_damage = DoDamage({ victim = target, attacker = caster, damage = target_damage*damage_k, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, }, ability)
else
	target:GenericHeal(target_damage, self)
end

if table.heal and table.heal == 1 and real_damage then 
	local heal = caster:GetTalentValue("modifier_abaddon_mist_7", "heal")/100
	caster:GenericHeal(real_damage*heal, self, true, "particles/abaddon/coil_legendary_heal.vpcf", "modifier_abaddon_mist_7")
end 

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_mist_coil_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex( effect_cast )

target:EmitSound("Hero_Abaddon.DeathCoil.Target")

if table.pull and table.pull == 1 and is_enemy then 

	target:AddNewModifier(caster, self, "modifier_abaddon_death_coil_custom_leash", {duration = caster:GetTalentValue("modifier_abaddon_hero_5", "leash")*(1 - target:GetStatusResistance())})

	local dir = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
	local point = caster:GetAbsOrigin() - dir*50
	local distance = (point - target:GetAbsOrigin()):Length2D()
	local max_dist = caster:GetTalentValue("modifier_abaddon_hero_5", "max_dist")

	distance = math.min(max_dist, math.max(40, distance))
	point = target:GetAbsOrigin() + dir*distance

	local mod = target:AddNewModifier( caster, self,  "modifier_generic_arc",  
	{
	  target_x = point.x,
	  target_y = point.y,
	  distance = distance,
	  duration = 0.3,
	  height = 0,
	  fix_end = false,
	  isStun = false,
	  activity = ACT_DOTA_FLAIL,
	})

	if mod then 
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		mod:AddParticle(self.particle, false, false, -1, false, false) 
	end 
end

if not caster:HasTalent("modifier_abaddon_mist_7") then return end
if not table.main or table.main == 0 then return end
if not is_enemy then return end

local range = caster:GetTalentValue("modifier_abaddon_mist_7", "range")
local vec
local point
local count = 0

repeat 
	vec = RandomVector(range)
	count = count + 1
    point = GetGroundPosition((target:GetAbsOrigin() + vec), nil)
until (self:CheckPos(point) or count >= 20)


local unit = CreateUnitByName("npc_dota_templar_assassin_psionic_trap", point, false, nil, nil, caster:GetTeamNumber())
unit:AddNewModifier(caster, self, "modifier_abaddon_death_coil_custom_legendary_unit", {target = target:entindex()})


local projectile_speed = self:GetSpecialValueFor("missile_speed")
local projectile_name = self:GetProjectile()

local info = {
	Source = target,
	Ability = self,	
  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
	
	EffectName = projectile_name,
	iMoveSpeed = projectile_speed,
	bDodgeable = true, 
	Target = unit,
}

target:EmitSound("Hero_Abaddon.DeathCoil.Cast")
ProjectileManager:CreateTrackingProjectile(info)
end




function abaddon_death_coil_custom:CheckPos(point)
if not IsServer() then return end

local radius = self:GetCaster():GetTalentValue("modifier_abaddon_mist_7", "radius") + 100

for _,index in pairs(self.thinkers) do 
	local unit = EntIndexToHScript(index)
	if unit and not unit:IsNull() then
		if (unit:GetAbsOrigin() - point):Length2D() <= radius then 
			return false
		end
	end
end 

return true
end






modifier_abaddon_death_coil_custom_legendary_unit = class({})
function modifier_abaddon_death_coil_custom_legendary_unit:IsHidden() return true end
function modifier_abaddon_death_coil_custom_legendary_unit:IsPurgable() return false end
function modifier_abaddon_death_coil_custom_legendary_unit:CheckState()
return
{
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true
}

end


function modifier_abaddon_death_coil_custom_legendary_unit:OnCreated(params)
if not IsServer() then return end 

self.parent = self:GetParent()
self.point = self.parent:GetAbsOrigin()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.target = EntIndexToHScript(params.target)
self.launch = false

self.parent:EmitSound("Abaddon.Mist_legendary_loop")

table.insert(self.ability.thinkers, self.parent:entindex())

self.parent:AddNoDraw()
self.duration = self.caster:GetTalentValue("modifier_abaddon_mist_7", "duration")
self.radius = self.caster:GetTalentValue("modifier_abaddon_mist_7", "radius")
self.max_timer = self.caster:GetTalentValue("modifier_abaddon_mist_7", "timer")
self.timer = 0

local range = self.caster:GetTalentValue("modifier_abaddon_mist_7", "range")
local speed = self.ability:GetSpecialValueFor("missile_speed")
local time = range/speed
self.flight = true

self.interval = FrameTime()

self:StartIntervalThink(time)
end


function modifier_abaddon_death_coil_custom_legendary_unit:OnIntervalThink()
if not IsServer() then return end 

if self.flight == true then 
	self.flight = false

	self:SetDuration(self.duration, true)
	self.parent:EmitSound("Abaddon.Mist_legendary_start")

	self.particle = ParticleManager:CreateParticle("particles/abaddon/coil_legendary_area.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.particle, 0, self.point)
	self:AddParticle(self.particle, false, false, -1, false, false) 
	self:StartIntervalThink(FrameTime())
	return
end 

if not self.target or self.target:IsNull() or (not self.target:IsAlive() and not self.target:IsReincarnating()) then 
	self:Destroy()
	return 
end

AddFOWViewer(self.target:GetTeamNumber(), self.point, self.radius, 0.1, false)

self:UpdateParticle()

if (self.target:GetAbsOrigin() - self.point):Length2D() > self.radius then

	self.timer = 0
else 
	self.timer = self.timer + self.interval
	if self.timer >= self.max_timer then 
		self:Destroy()
		return
	end 
end 

end 


function modifier_abaddon_death_coil_custom_legendary_unit:UpdateParticle()
if not IsServer() then return end 

if self.timer == 0 and self.part_particle then 
	ParticleManager:DestroyParticle(self.part_particle, true)
	ParticleManager:ReleaseParticleIndex(self.part_particle)
	self.part_particle = nil
	return
end 


if self.timer > 0 and not self.part_particle then 
	self.part_particle = ParticleManager:CreateParticle("particles/shrine/capture_point_ring_clock_overthrow.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(self.part_particle, 0, self.point + Vector(0,0,20))
	ParticleManager:SetParticleControl(self.part_particle, 11, Vector(0, 0, 1))
	self:AddParticle(self.part_particle, false, false, -1, false, false) 
end 

if not self.part_particle then return end

ParticleManager:SetParticleControl(self.part_particle, 3, Vector(119,234,241))
ParticleManager:SetParticleControl(self.part_particle, 9, Vector(self.radius*1.3, 0, 0))
ParticleManager:SetParticleControl(self.part_particle, 17, Vector(self.timer/self.max_timer, 0, 0))
end






function modifier_abaddon_death_coil_custom_legendary_unit:OnDestroy()
if not IsServer() then return end 

EmitSoundOnLocationWithCaster(self.point, "Abaddon.Mist_legendary_end", self.caster)
self.parent:StopSound("Abaddon.Mist_legendary_loop")


local ground = ParticleManager:CreateParticle("particles/abaddon/coil_legendary_casti.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(ground, 0, self.point)
ParticleManager:ReleaseParticleIndex(ground)

if self.launch == true and self.target and not self.target:IsNull() and self.target:IsAlive() then 

	local projectile_speed = self.ability:GetSpecialValueFor("missile_speed")

	local particle = ParticleManager:CreateParticle("particles/abaddon/coil_proje.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, self.point)
	ParticleManager:SetParticleControl(particle, 1, self.point)
	ParticleManager:ReleaseParticleIndex(particle)

	local projectile_name = self.ability:GetProjectile()

	local info = {
		Source = self.parent,
		Ability = self.ability,	
  	iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed*1.3,
		bDodgeable = false, 
		Target = self.target,
		ExtraData = {heal = 1}
	}

	self.parent:EmitSound("Hero_Abaddon.DeathCoil.Cast")
	ProjectileManager:CreateTrackingProjectile(info)
end 


for i,index in pairs(self.ability.thinkers) do 
	if index == self.parent:entindex() then 
		table.remove(self.ability.thinkers, i)
		break
	end 
end 

UTIL_Remove(self:GetParent())
end






abaddon_death_coil_custom_legendary = class({})

function abaddon_death_coil_custom_legendary:CreateTalent(name)
self:SetHidden(false)
end

function abaddon_death_coil_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_abaddon_mist_7", "talent_cd")
end


function abaddon_death_coil_custom_legendary:OnSpellStart()

local caster = self:GetCaster()
local main_ability = caster:FindAbilityByName("abaddon_death_coil_custom")

if not main_ability then return end 

caster:EmitSound("Abaddon.Mist_legendary")
caster:EmitSound("Abaddon.Mist_legendary2")

local particle = ParticleManager:CreateParticle("particles/abaddon/coil_legendary_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(particle)

local units = {}

for _,index in pairs(main_ability.thinkers) do 
	local unit = EntIndexToHScript(index)
	if unit then 
		units[#units + 1] = unit
	end
end 

if #units == 0 then return end 

for i = 1,#units do 
	local mod = units[i]:FindModifierByName("modifier_abaddon_death_coil_custom_legendary_unit")

	if mod then
		mod.launch = true
		mod:Destroy()
	end
end 

end



modifier_abaddon_death_coil_custom_double_proc = class(mod_hidden)
function modifier_abaddon_death_coil_custom_double_proc:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_abaddon_death_coil_custom_double_proc:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end 

self.target = EntIndexToHScript(table.target)
end

function modifier_abaddon_death_coil_custom_double_proc:OnDestroy()
if not IsServer() then return end 
if not self.target or self.target:IsNull() then return end 

self.ability:OnSpellStart(self.target)
end 




modifier_abaddon_death_coil_custom_buff = class(mod_visible)
function modifier_abaddon_death_coil_custom_buff:OnCreated()
self.parent = self:GetParent()

self.move = self.parent:GetTalentValue("modifier_abaddon_hero_1", "move")
self.regen = self.parent:GetTalentValue("modifier_abaddon_hero_1", "heal")
self.max = self.parent:GetTalentValue("modifier_abaddon_hero_1", "max")
self:SetStackCount(1)
end

function modifier_abaddon_death_coil_custom_buff:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end

function modifier_abaddon_death_coil_custom_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,

}
end

function modifier_abaddon_death_coil_custom_buff:GetModifierConstantHealthRegen()
return self:GetStackCount()*self.regen
end

function modifier_abaddon_death_coil_custom_buff:GetModifierMoveSpeedBonus_Constant()
return self:GetStackCount()*self.move
end




modifier_abaddon_death_coil_custom_tracker = class(mod_hidden)
function modifier_abaddon_death_coil_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.double_radius = self.parent:GetTalentValue("modifier_abaddon_mist_3", "radius", true)
self.auto_delay = self.parent:GetTalentValue("modifier_abaddon_mist_3", "delay", true)
self.double_chance = self.parent:GetTalentValue("modifier_abaddon_mist_3", "chance")
self.spell_damage = self.parent:GetTalentValue("modifier_abaddon_mist_3", "spell")

self.range = self.parent:GetTalentValue("modifier_abaddon_hero_5", "range", true)

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_abaddon_death_coil_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_abaddon_mist_3" or self.parent:HasTalent("modifier_abaddon_mist_3") then
	self.parent:AddSpellEvent(self, true)
	self.double_chance = self.parent:GetTalentValue("modifier_abaddon_mist_3", "chance")
	self.spell_damage = self.parent:GetTalentValue("modifier_abaddon_mist_3", "spell")
end

self:SendBuffRefreshToClients()
end

function modifier_abaddon_death_coil_custom_tracker:AddCustomTransmitterData() 
return 
{
  spell_damage = self.spell_damage,
} 
end

function modifier_abaddon_death_coil_custom_tracker:HandleCustomTransmitterData(data)
self.spell_damage = data.spell_damage
end

function modifier_abaddon_death_coil_custom_tracker:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_abaddon_death_coil_custom_tracker:GetModifierSpellAmplify_Percentage()
return self.spell_damage
end

function modifier_abaddon_death_coil_custom_tracker:GetModifierCastRangeBonusStacking()
if not self.parent:HasTalent("modifier_abaddon_hero_5") then return end 
return self.range
end

function modifier_abaddon_death_coil_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if not self.parent:HasTalent("modifier_abaddon_mist_3") then return end
if params.unit~=self.parent then return end
if not RollPseudoRandomPercentage(self.double_chance, 1193, self.parent) then return end

local radius = self.double_radius + self.parent:GetCastRangeBonus()
local target = self.parent:RandomTarget(radius)

if target then
	if params.ability == self.ability then  
	  self.parent:AddNewModifier(self.parent, self.ability, "modifier_abaddon_death_coil_custom_double_proc", {target = target:entindex(), duration = self.auto_delay})
	else 
	  self.ability:OnSpellStart(target)
	end 
end 

end



modifier_abaddon_death_coil_custom_leash = class({})
function modifier_abaddon_death_coil_custom_leash:IsHidden() return true end
function modifier_abaddon_death_coil_custom_leash:IsPurgable() return true end
function modifier_abaddon_death_coil_custom_leash:CheckState()
return
{
	[MODIFIER_STATE_TETHERED] = true
}
end
function modifier_abaddon_death_coil_custom_leash:GetEffectName()
return "particles/abaddon/coil_leash.vpcf"
end


modifier_abaddon_death_coil_custom_count = class(mod_visible)
function modifier_abaddon_death_coil_custom_count:GetTexture() return "buffs/mist_cdr" end
function modifier_abaddon_death_coil_custom_count:OnCreated()
self.parent = self:GetParent()
self.count = self.parent:GetTalentValue("modifier_abaddon_mist_4", "count")
self:SetStackCount(1)
end

function modifier_abaddon_death_coil_custom_count:OnRefresh()
if not IsServer() then return end 

self:IncrementStackCount()

if self:GetStackCount() < self.count then return end 
self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_abaddon_death_coil_custom_cdr", {duration = self.parent:GetTalentValue("modifier_abaddon_mist_4", "duration")})
self:Destroy()
end



modifier_abaddon_death_coil_custom_cdr = class(mod_visible)
function modifier_abaddon_death_coil_custom_cdr:GetTexture() return "buffs/mist_cdr" end
function modifier_abaddon_death_coil_custom_cdr:OnCreated()
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_abaddon_mist_4", "speed")

if not IsServer() then return end
self.parent:EmitSound("Abaddon.Mist_cdr")

self.parent:CdItems(self.parent:GetTalentValue("modifier_abaddon_mist_4", "cd_items"))

self.parent:GenericParticle("particles/abaddon/coil_speed.vpcf", self)
self.parent:GenericParticle("particles/abaddon/coil_cdr.vpcf")
end 

function modifier_abaddon_death_coil_custom_cdr:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_abaddon_death_coil_custom_cdr:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end



modifier_abaddon_death_coil_custom_shard_proc = class(mod_hidden)
function modifier_abaddon_death_coil_custom_shard_proc:OnCreated(table)
if not IsServer() then return end 
self.damage = self:GetAbility():GetSpecialValueFor("shard_damage") - 100
end 

function modifier_abaddon_death_coil_custom_shard_proc:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_abaddon_death_coil_custom_shard_proc:GetModifierDamageOutgoing_Percentage()
return self.damage
end



modifier_abaddon_death_coil_custom_cd = class(mod_hidden)