LinkLuaModifier( "modifier_enigma_black_hole_custom", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_tracker", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_debuff", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_delay", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_legendary", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_legendary_toggle_far", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_legendary_toggle_close", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_legendary_debuff", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_legendary_stack", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_legendary_hit", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_legendary_damage_inc", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_leash", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_auto_cd", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enigma_black_hole_custom_caster_delay", "abilities/enigma/enigma_black_hole_custom", LUA_MODIFIER_MOTION_NONE )


enigma_black_hole_custom = class({})

function enigma_black_hole_custom:CreateTalent()

end


function enigma_black_hole_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_enigma/enigma_blackhole.vpcf", context )
PrecacheResource( "particle", "particles/enigma/blackhole_delay.vpcf", context )
PrecacheResource( "particle", "particles/enigma/black_hole_legendary.vpcf", context )
PrecacheResource( "particle", "particles/enigma/black_hole_legendarye2.vpcf", context )
PrecacheResource( "particle", "particles/enigma/blackhole_stack_max.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_enigma/enigma_gravity_effect.vpcf", context )
PrecacheResource( "particle", "particles/enigma/blackhole_mini.vpcf", context )
PrecacheResource( "particle", "particles/enigma/black_hole_blink_start.vpcf", context )
PrecacheResource( "particle", "particles/enigma/black_hole_blink_end.vpcf", context )
PrecacheResource( "particle", "particles/enigma/blackhole_refresh.vpcf", context )

end


function enigma_black_hole_custom:OnInventoryContentsChanged()
if not self.init_scepter and self:GetCaster():HasScepter() then
	self.init_scepter = true
	self:ToggleAutoCast()
end
	
end

function enigma_black_hole_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_enigma_black_hole_custom_tracker"
end

function enigma_black_hole_custom:GetAOERadius()
return self:GetSpecialValueFor("radius")
end

function enigma_black_hole_custom:GetBehavior()
local caster = self:GetCaster()
local bonus = 0
if caster:HasScepter() then
  bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_POINT + bonus
end


function enigma_black_hole_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_enigma_blackhole_3") then
	bonus = self:GetCaster():GetTalentValue("modifier_enigma_blackhole_3", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function enigma_black_hole_custom:GetCastRange(vLocation, hTarget)
local bonus = 0
if self:GetCaster():HasScepter() then
	bonus = self:GetSpecialValueFor("scepter_range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + bonus
end

function enigma_black_hole_custom:GetCastPoint(iLevel)
return self.BaseClass.GetCastPoint(self)
end

function enigma_black_hole_custom:GetDamage()
local caster = self:GetCaster()
local damage = self:GetSpecialValueFor("damage")
if caster:HasTalent("modifier_enigma_blackhole_1") then
	damage = damage + caster:GetTalentValue("modifier_enigma_blackhole_1", "damage")*caster:GetIntellect(false)/100
end
return damage
end

function enigma_black_hole_custom:GetStunDuratiuon()
return self:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_enigma_blackhole_1", "duration")
end


function enigma_black_hole_custom:ProcDamage(unit)
if not IsServer() then return end
local caster = self:GetCaster()
local damage = caster:GetTalentValue("modifier_enigma_blackhole_4", "damage")*caster:GetIntellect(false)/100

unit:SendNumber(4, damage)
DoDamage({victim = unit, attacker = caster, ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage}, "modifier_enigma_blackhole_4")
end



function enigma_black_hole_custom:OnSpellStart()
local caster = self:GetCaster()
local point = self:GetCursorPosition()
local delay = self:GetSpecialValueFor("delay") + caster:GetTalentValue("modifier_enigma_blackhole_3", "delay")

print(delay)

caster:EmitSound("Enigma.Blackhole_delay_voice")
caster:AddNewModifier(caster, self, "modifier_enigma_black_hole_custom_caster_delay", {duration = delay})
CreateModifierThinker(caster, self, "modifier_enigma_black_hole_custom_delay", {duration = delay}, point, caster:GetTeamNumber(), false)
end



modifier_enigma_black_hole_custom_caster_delay = class({})
function modifier_enigma_black_hole_custom_caster_delay:IsHidden() return true end
function modifier_enigma_black_hole_custom_caster_delay:IsPurgable() return false end



modifier_enigma_black_hole_custom_delay = class({})
function modifier_enigma_black_hole_custom_delay:IsHidden() return false end
function modifier_enigma_black_hole_custom_delay:IsPurgable() return false end
function modifier_enigma_black_hole_custom_delay:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.duration = self.ability:GetStunDuratiuon()
self.radius = self.ability:GetSpecialValueFor("radius")

if not IsServer() then return end
self.auto = 0
local sound = "Enigma.Blackhole_delay"

if table.auto and table.auto == 1 then
	self.auto = 1
	self.radius = self.caster:GetTalentValue("modifier_enigma_blackhole_5", "aoe")
	self.duration = self.caster:GetTalentValue("modifier_enigma_blackhole_5", "auto_duration")
	sound = "Enigma.Blackhole_delay_mini"
end

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), sound, self.caster)

self.effect_cast = ParticleManager:CreateParticle("particles/enigma/blackhole_delay.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius/self:GetRemainingTime() ) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )
self:AddParticle( self.effect_cast, false, false, -1, false, false )
end

function modifier_enigma_black_hole_custom_delay:OnDestroy()
if not IsServer() then return end
if not self.caster or self.caster:IsNull() then return end

if self.auto == 0 and self.caster:HasScepter() and self.ability:GetAutoCastState() and self.caster:IsAlive() then
	self.caster:Teleport(self.parent:GetAbsOrigin(), true, "particles/enigma/black_hole_blink_start.vpcf", "particles/enigma/black_hole_blink_end.vpcf", "Enigma.Blackhole_blink")
	self.caster:Stop()
end

CreateModifierThinker(self.caster, self.ability, "modifier_enigma_black_hole_custom", {duration = self.duration, auto = self.auto}, self.parent:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
end




modifier_enigma_black_hole_custom = class({})
function modifier_enigma_black_hole_custom:IsHidden() return true end
function modifier_enigma_black_hole_custom:IsPurgable() return false end
function modifier_enigma_black_hole_custom:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")

self.hit_hero = false

if not IsServer() then return end

self.auto = 0

local name = "particles/units/heroes/hero_enigma/enigma_blackhole.vpcf"
local radius = self.radius
self.sound = "Hero_Enigma.Black_Hole"
self.stop_sound = "Hero_Enigma.Black_Hole.Stop"

if table.auto and table.auto == 1 then
	self.auto = 1
	self.sound = "Enigma.Blackhole_loop_mini"
	self.stop_sound = "Enigma.Blackhole_stop_mini"
	self.radius = self.caster:GetTalentValue("modifier_enigma_blackhole_5", "aoe")
	name = "particles/enigma/blackhole_mini.vpcf"
	radius = self.radius*0.8
end

self.parent:EmitSound(self.sound)

self.effect_cast = ParticleManager:CreateParticle( name, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetOrigin() + Vector(0, 0, 70) )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(radius, 0, 0) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)
end

function modifier_enigma_black_hole_custom:OnDestroy()
if not IsServer() then return end

if self.caster and not self.caster:IsNull() and self.caster:IsAlive() and self.caster:HasScepter() and self.hit_hero == false and self.auto == 0 then
	self.ability:EndCooldown()
	self.ability:StartCooldown(self.ability:GetSpecialValueFor("scepter_cd"))

	local effect = ParticleManager:CreateParticle("particles/enigma/blackhole_refresh.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
	ParticleManager:SetParticleControlEnt( effect, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(effect)

	self.caster:EmitSound("Enigma.Blackhole_refresh")
end

if not self.parent or self.parent:IsNull() then return end
self.parent:StopSound(self.sound)
self.parent:EmitSound(self.stop_sound)
end

function modifier_enigma_black_hole_custom:RegisterHit(target)
if not IsServer() then return end

if self.hit_hero == false and target:IsRealHero() then
	self.hit_hero = true

	if self.caster:HasTalent("modifier_enigma_blackhole_5") then
		self.caster:CdItems(self.caster:GetTalentValue("modifier_enigma_blackhole_5", "cd_self"))
	end
end

end


function modifier_enigma_black_hole_custom:IsAura() return true end
function modifier_enigma_black_hole_custom:GetAuraDuration() return 0 end
function modifier_enigma_black_hole_custom:GetAuraRadius() return self.radius end
function modifier_enigma_black_hole_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_enigma_black_hole_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_enigma_black_hole_custom:GetModifierAura() return "modifier_enigma_black_hole_custom_debuff" end






modifier_enigma_black_hole_custom_debuff = class({})
function modifier_enigma_black_hole_custom_debuff:IsHidden() return false end
function modifier_enigma_black_hole_custom_debuff:IsPurgable() return false end
function modifier_enigma_black_hole_custom_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_enigma_black_hole_custom_debuff:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()
self.aura_onwer = self:GetAuraOwner()

self.damage_reduce = self.caster:GetTalentValue("modifier_enigma_blackhole_6", "damage_reduce")

self.animation_rate = self.ability:GetSpecialValueFor("animation_rate")
self.ticks = self.ability:GetSpecialValueFor("ticks")
self.max_duration = self.ability:GetStunDuratiuon()

self.interval = 0.05
self.damage_count = 0


self.pull_speed = self.ability:GetSpecialValueFor("pull_speed")*self.interval

if not IsServer() then return end
self.damage_ability = nil

self.center = self.parent:GetAbsOrigin()
if self.aura_onwer and not self.aura_onwer:IsNull() then
	self.center = self.aura_onwer:GetAbsOrigin()

	local mod = self.aura_onwer:FindModifierByName("modifier_enigma_black_hole_custom")
	if mod then
		if mod.auto and mod.auto == 1 then
			self.ticks = 2
			self.max_duration = self.caster:GetTalentValue("modifier_enigma_blackhole_5", "auto_duration")
			self.damage_ability = "modifier_enigma_blackhole_5"
		end
		mod:RegisterHit(self.parent)
	end
end

self.damage_interval = self.max_duration/self.ticks
self.damage = (self.ability:GetDamage()*self.max_duration)/self.ticks

if self.caster:HasTalent("modifier_enigma_blackhole_6") and self.damage_ability == nil  then
	self.parent:GenericParticle("particles/generic_gameplay/generic_break.vpcf", self, true)

	local cd_inc = self.caster:GetTalentValue("modifier_enigma_blackhole_6", "cd_target")
	for _,item in pairs(self.parent:GetAllItems()) do
		local cd = item:GetCooldownTimeRemaining()
		item:EndCooldown()
		item:StartCooldown(cd + cd_inc)
	end
end

local legendary_mod = self.parent:FindModifierByName("modifier_enigma_black_hole_custom_legendary_stack")
if legendary_mod and self.damage_ability == nil then
	self.damage_mod = self.parent:AddNewModifier(self.caster, self.ability, "modifier_enigma_black_hole_custom_legendary_damage_inc", {stack = legendary_mod:GetStackCount()})
	legendary_mod:Destroy()
end

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage = self.damage, damage_type = DAMAGE_TYPE_PURE}

self.parent:StartGestureWithPlaybackRate(ACT_DOTA_FLAIL, self.animation_rate)
self:StartIntervalThink(self.interval)
end


function modifier_enigma_black_hole_custom_debuff:OnIntervalThink()
if not IsServer() then return end

if self.parent:IsRealHero() and self.caster:GetQuest() == "Enigma.Quest_8" and not self.caster:QuestCompleted() then
	self.caster:UpdateQuest(self.interval)
end

self.damage_count = self.damage_count + self.interval
if self.damage_count >= self.damage_interval - 0.05 then
	self.damage_count = 0
	DoDamage(self.damageTable, self.damage_ability)

	if self.caster:HasTalent("modifier_enigma_blackhole_4") then
		self.ability:ProcDamage(self.parent)
	end
end

local vec = self.center - self.parent:GetAbsOrigin()

local angle = self.parent:GetAngles()
local new_angle = RotateOrientation(angle, QAngle(0, 1.5, 0))

self.parent:SetAngles(new_angle[1], new_angle[2], new_angle[3])

if vec:Length2D() <= 10 then return end

self.parent:SetAbsOrigin(self.parent:GetAbsOrigin() + self.pull_speed*vec:Normalized())
end



function modifier_enigma_black_hole_custom_debuff:OnDestroy()
if not IsServer() then return end

if self.damage_mod and not self.damage_mod:IsNull() then
	self.damage_mod:SetDuration(self.caster:GetTalentValue("modifier_enigma_blackhole_7", "linger"), true)
end

FindClearSpaceForUnit(self.parent, self.parent:GetAbsOrigin(), false)
self.parent:FadeGesture(ACT_DOTA_FLAIL)
end



function modifier_enigma_black_hole_custom_debuff:CheckState()
local table_state = 
{
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
}
if self.caster:HasTalent("modifier_enigma_blackhole_6") then
	table_state[MODIFIER_STATE_PASSIVES_DISABLED] = true
end

return table_state
end

function modifier_enigma_black_hole_custom_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_enigma_blackhole_tgt.vpcf"
end

function modifier_enigma_black_hole_custom_debuff:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end


function modifier_enigma_black_hole_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_enigma_black_hole_custom_debuff:GetModifierDamageOutgoing_Percentage()
if not self.caster:HasTalent("modifier_enigma_blackhole_6") then return end
return self.damage_reduce
end

function modifier_enigma_black_hole_custom_debuff:GetModifierSpellAmplify_Percentage()
if not self.caster:HasTalent("modifier_enigma_blackhole_6") then return end
return self.damage_reduce
end








modifier_enigma_black_hole_custom_tracker = class({})
function modifier_enigma_black_hole_custom_tracker:IsHidden() return true end
function modifier_enigma_black_hole_custom_tracker:IsPurgable() return false end
function modifier_enigma_black_hole_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.team = self.parent:GetTeamNumber()
self.thinkers = {}
self.count = self.parent:GetTalentValue("modifier_enigma_blackhole_7", "count", true)

self.dt = 0.03

self.auto_radius = self.parent:GetTalentValue("modifier_enigma_blackhole_5", "radius", true)
self.auto_delay = self.parent:GetTalentValue("modifier_enigma_blackhole_5", "delay", true)

self.hit_radius_min = self.parent:GetTalentValue("modifier_enigma_blackhole_7", "radius_hit_min", true)
self.radius_min = self.parent:GetTalentValue("modifier_enigma_blackhole_7", "radius_min", true)
self.radius_max = self.parent:GetTalentValue("modifier_enigma_blackhole_7", "radius_max", true)
self.radius_speed = self.parent:GetTalentValue("modifier_enigma_blackhole_7", "radius_speed", true)*self.dt
self.current_speed = self.parent:GetTalentValue("modifier_enigma_blackhole_7", "angel_speed", true)*self.dt

self.heal_creeps = self.parent:GetTalentValue("modifier_enigma_blackhole_2", "creeps", true)
self.heal_bonus = self.parent:GetTalentValue("modifier_enigma_blackhole_2", "bonus", true)

self.parent:AddDamageEvent_out(self)

if not IsServer() then return end
self:StartIntervalThink(1)
end


function modifier_enigma_black_hole_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not params.unit:IsUnit() then return end

local attacker = params.attacker
local unit = params.unit

local is_eidolon = attacker.owner and attacker.owner == self.parent and attacker:HasModifier("modifier_enigma_demonic_conversion_custom")

if attacker ~= self.parent and not is_eidolon then return end

if self.parent:HasTalent("modifier_enigma_blackhole_4") and unit:HasModifier("modifier_enigma_black_hole_custom_debuff") and (not params.inflictor or params.inflictor ~= self.ability) then

	self.ability:ProcDamage(unit)
end

if not self.parent:HasTalent("modifier_enigma_blackhole_2") then return end
if not self.parent:CheckLifesteal(params, nil, true) then return end

local heal = params.damage*self.parent:GetTalentValue("modifier_enigma_blackhole_2", "heal")/100
local particle = ""

if unit:HasModifier("modifier_enigma_black_hole_custom_debuff") then
	heal = heal*self.heal_bonus
	particle = nil
end

if unit:IsCreep() then
	heal = heal/self.heal_creeps
end

self.parent:GenericHeal(heal, self.ability, true, particle, "modifier_enigma_blackhole_2")

end


function modifier_enigma_black_hole_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end


function modifier_enigma_black_hole_custom_tracker:GetModifierSpellAmplify_Percentage()
if not self.parent:HasTalent("modifier_enigma_blackhole_4") then return end
return self.parent:GetIntellect(false)/self.parent:GetTalentValue("modifier_enigma_blackhole_4", "int")
end

function modifier_enigma_black_hole_custom_tracker:OnIntervalThink()
if not IsServer() then return end

local dt = 1

if self.parent:HasTalent("modifier_enigma_blackhole_5") and self.parent:IsAlive() and not self.parent:HasModifier("modifier_enigma_black_hole_custom_caster_delay") then

	dt = self.dt

	local mod = self.parent:FindModifierByName("modifier_enigma_black_hole_custom_auto_cd")
	if not mod then
		mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_enigma_black_hole_custom_auto_cd", {})
	end

	if mod:GetStackCount() <= 0 then
		local target = self.parent:RandomTarget(self.auto_radius)
	
		if target and not target:HasModifier("modifier_enigma_black_hole_custom_debuff") and not self.parent:IsInvisible() then
			CreateModifierThinker(self.parent, self.ability, "modifier_enigma_black_hole_custom_delay", {duration = self.auto_delay, auto = 1}, target:GetAbsOrigin(), self.parent:GetTeamNumber(), false)
			mod:StartCd()
		end
	end
end

if self.parent:HasTalent("modifier_enigma_blackhole_7") then

	dt = self.dt

	for i = 1,self.count do

		if not self.parent:IsAlive() or self.parent:IsNull() or self.parent:IsOutOfGame() then
			if self.thinkers[i] then
				if self.thinkers[i].mod then
					self.thinkers[i].mod:Destroy()
				end
				self.thinkers[i] = nil
			end
		else
			if not self.thinkers[i] then
				self.thinkers[i] = {}
				local angel = (math.pi/self.count + 2*math.pi/self.count * i)
				self.thinkers[i].current_angle = angel
				self.thinkers[i].radius = self.radius_min
				self.thinkers[i].thinker = CreateModifierThinker(self.parent, self.ability, "modifier_enigma_black_hole_custom_legendary", {}, self.parent:GetAbsOrigin(), self.parent:GetTeamNumber(), false)
				self.thinkers[i].mod = self.thinkers[i].thinker:FindModifierByName("modifier_enigma_black_hole_custom_legendary")
			end

			local center = self.parent:GetAbsOrigin()

			local speed = self.current_speed
			local radius_speed = self.radius_speed

			if self.parent:HasModifier("modifier_enigma_black_hole_custom_legendary_hit") then
				speed = speed*0.05
				radius_speed = radius_speed*0.05
			end

			local current_angle = self.thinkers[i].current_angle + speed
			if current_angle > 2*math.pi then
				current_angle = current_angle - 2*math.pi
			end


			local radius = self.thinkers[i].radius

			if self.parent:HasModifier("modifier_enigma_black_hole_custom_legendary_toggle_far") and radius < self.radius_max then
				radius = math.min(self.radius_max, radius + radius_speed)
			elseif (self.parent:HasModifier("modifier_enigma_black_hole_custom_legendary_toggle_close") or self.parent:HasTalent("modifier_enigma_conversion_7")) and radius > self.radius_min then
				radius = math.max(self.radius_min, radius - radius_speed)
			end

			local position = self:GetPosition(center, current_angle, radius)
			self.thinkers[i].current_angle = current_angle
			self.thinkers[i].radius = radius

			self.thinkers[i].thinker:SetAbsOrigin(position + Vector(0,0,100))

			AddFOWViewer(self.team, position, 150, 0.1, false)
		end
	end
end

if not self.parent:IsAlive() then
	dt = 1
end

self:StartIntervalThink(dt)
end

function modifier_enigma_black_hole_custom_tracker:GetPosition(center, angel, radius)
return GetGroundPosition(center + Vector( math.cos( angel ), math.sin( angel ), 0 ) * radius, nil)
end




modifier_enigma_black_hole_custom_legendary = class({})
function modifier_enigma_black_hole_custom_legendary:IsHidden() return true end
function modifier_enigma_black_hole_custom_legendary:IsPurgable() return false end
function modifier_enigma_black_hole_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.ability =  self:GetAbility()
self.caster = self:GetCaster()

self.effect_cast = ParticleManager:CreateParticle( "particles/enigma/black_hole_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetOrigin() )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self.parent:EmitSound("Enigma.Blackhole_legendary_loop")

self.hit_radius = self.caster:GetTalentValue("modifier_enigma_blackhole_7", "radius_hit_min")
end 

function modifier_enigma_black_hole_custom_legendary:OnDestroy()
if not IsServer() then return end 
self.parent:StopSound("Enigma.Blackhole_legendary_loop")
UTIL_Remove(self.parent)
end 




function modifier_enigma_black_hole_custom_legendary:IsAura() return true end
function modifier_enigma_black_hole_custom_legendary:GetModifierAura() return "modifier_enigma_black_hole_custom_legendary_debuff" end
function modifier_enigma_black_hole_custom_legendary:GetAuraRadius() return self.hit_radius end
function modifier_enigma_black_hole_custom_legendary:GetAuraDuration() return 0.2 end
function modifier_enigma_black_hole_custom_legendary:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_enigma_black_hole_custom_legendary:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_enigma_black_hole_custom_legendary:GetAuraEntityReject(hEntity) return  end



modifier_enigma_black_hole_custom_legendary_hit = class({})
function modifier_enigma_black_hole_custom_legendary_hit:IsHidden() return true end
function modifier_enigma_black_hole_custom_legendary_hit:IsPurgable() return false end


modifier_enigma_black_hole_custom_legendary_debuff = class({})
function modifier_enigma_black_hole_custom_legendary_debuff:IsHidden() return true end
function modifier_enigma_black_hole_custom_legendary_debuff:IsPurgable() return false end
function modifier_enigma_black_hole_custom_legendary_debuff:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.slow = self.caster:GetTalentValue("modifier_enigma_blackhole_7", "slow")
self.stack_duration = self.caster:GetTalentValue("modifier_enigma_blackhole_7", "stack_duration")

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/enigma/black_hole_legendaryf.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
self:AddParticle( self.particle, false, false, -1, false, false )

if self.parent:IsHero() and self:GetAuraOwner() then
	local mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_enigma_black_hole_custom_legendary_hit", {duration = 0.3})

	local effect_cast = ParticleManager:CreateParticle( "particles/enigma/black_hole_legendarye2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetAuraOwner() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetAuraOwner():GetOrigin() )
	mod:AddParticle(effect_cast,false, false, -1, false, false)

    self.parent:EmitSound("Enigma.Blackhole_legendary_hit")
else
	self.parent:EmitSound("Enigma.Blackhole_legendary_hit_creeps")
end

if not self.parent:HasModifier("modifier_enigma_black_hole_custom_legendary_damage_inc") then
	self.parent:AddNewModifier(self.caster, self.ability, "modifier_enigma_black_hole_custom_legendary_stack", {duration = self.stack_duration})
end
local damage = self.ability:GetDamage()*self.caster:GetTalentValue("modifier_enigma_blackhole_7", "damage")/100
DoDamage({victim = self.parent, ability = self.ability, attacker = self.caster, damage_type = DAMAGE_TYPE_PURE, damage = damage}, "modifier_enigma_blackhole_7")
end

function modifier_enigma_black_hole_custom_legendary_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_enigma_black_hole_custom_legendary_debuff:GetModifierMoveSpeedBonus_Percentage()
if self.parent:IsDebuffImmune() then return end
return self.slow
end

function modifier_enigma_black_hole_custom_legendary_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_enigma_blackhole_tgt.vpcf"
end

function modifier_enigma_black_hole_custom_legendary_debuff:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end




enigma_black_hole_custom_legendary_far = class({})


function enigma_black_hole_custom_legendary_far:OnToggle()
local caster = self:GetCaster()
local close_ability = caster:FindAbilityByName("enigma_black_hole_custom_legendary_close")

if not close_ability then return end

if not self:GetToggleState() then
	caster:RemoveModifierByName("modifier_enigma_black_hole_custom_legendary_toggle_far")
else
	if close_ability:GetToggleState() then
		close_ability:ToggleAbility()
	end
	caster:AddNewModifier(caster, self, "modifier_enigma_black_hole_custom_legendary_toggle_far", {})
end

end



enigma_black_hole_custom_legendary_close = class({})

function enigma_black_hole_custom_legendary_close:CreateTalent()
self:SetHidden(false)
local ability = self:GetCaster():FindAbilityByName("enigma_black_hole_custom_legendary_far")
if ability and not self:GetCaster():HasTalent("modifier_enigma_conversion_7") then
	ability:SetHidden(false)
end

end


function enigma_black_hole_custom_legendary_close:GetAbilityTextureName()
if self:GetCaster():HasTalent("modifier_enigma_conversion_7") then
	if not self:GetCaster():HasModifier("modifier_enigma_black_hole_custom_legendary_toggle_far") then
		return "black_hole_legendary"
	else
		return "black_hole_legendary_toggle"
	end
end
return "black_hole_legendary"
end


function enigma_black_hole_custom_legendary_close:OnToggle()
local caster = self:GetCaster()

if caster:HasTalent("modifier_enigma_conversion_7") then
	local mod = caster:FindModifierByName("modifier_enigma_black_hole_custom_legendary_toggle_far")
	if mod then
		mod:Destroy()
	else
		caster:AddNewModifier(caster, self, "modifier_enigma_black_hole_custom_legendary_toggle_far", {})
	end
	return
end

local far_ability = caster:FindAbilityByName("enigma_black_hole_custom_legendary_far")

if not far_ability then return end

if not self:GetToggleState() then
	caster:RemoveModifierByName("modifier_enigma_black_hole_custom_legendary_toggle_close")
else
	if far_ability:GetToggleState() then
		far_ability:ToggleAbility()
	end
	caster:AddNewModifier(caster, self, "modifier_enigma_black_hole_custom_legendary_toggle_close", {})
end

end


modifier_enigma_black_hole_custom_legendary_toggle_far = class({})
function modifier_enigma_black_hole_custom_legendary_toggle_far:IsHidden() return true end
function modifier_enigma_black_hole_custom_legendary_toggle_far:IsPurgable() return false end
function modifier_enigma_black_hole_custom_legendary_toggle_far:RemoveOnDeath() return false end


modifier_enigma_black_hole_custom_legendary_toggle_close = class({})
function modifier_enigma_black_hole_custom_legendary_toggle_close:IsHidden() return true end
function modifier_enigma_black_hole_custom_legendary_toggle_close:IsPurgable() return false end
function modifier_enigma_black_hole_custom_legendary_toggle_close:RemoveOnDeath() return false end






modifier_enigma_black_hole_custom_legendary_stack = class({})
function modifier_enigma_black_hole_custom_legendary_stack:IsHidden() return false end
function modifier_enigma_black_hole_custom_legendary_stack:IsPurgable() return false end
function modifier_enigma_black_hole_custom_legendary_stack:GetTexture() return "buffs/blackhole_stack" end
function modifier_enigma_black_hole_custom_legendary_stack:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.max = self.caster:GetTalentValue("modifier_enigma_blackhole_7", "max")

if not IsServer() then return end

self.RemoveForDuel = true
if not self.caster:HasTalent("modifier_enigma_malefice_7") then
	self.effect = self.parent:GenericParticle("particles/enigma/malefice_legendary_stack.vpcf", self ,true)
end
self:SetStackCount(1)
end

function modifier_enigma_black_hole_custom_legendary_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end



function modifier_enigma_black_hole_custom_legendary_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.effect then return end
ParticleManager:SetParticleControl(self.effect, 1, Vector(0, self:GetStackCount(), 0))
end



modifier_enigma_black_hole_custom_legendary_damage_inc = class({})
function modifier_enigma_black_hole_custom_legendary_damage_inc:IsHidden() return false end
function modifier_enigma_black_hole_custom_legendary_damage_inc:IsPurgable() return false end
function modifier_enigma_black_hole_custom_legendary_damage_inc:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.damage_inc = self.caster:GetTalentValue("modifier_enigma_blackhole_7", "damage_inc")
if not IsServer() then return end
self.parent:GenericParticle("particles/enigma/blackhole_stack_max.vpcf", self, true)

self:SetStackCount(table.stack)
end

function modifier_enigma_black_hole_custom_legendary_damage_inc:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_enigma_black_hole_custom_legendary_damage_inc:GetModifierIncomingDamage_Percentage()
return self.damage_inc*self:GetStackCount()
end



modifier_enigma_black_hole_custom_leash = class({})
function modifier_enigma_black_hole_custom_leash:IsHidden() return true end
function modifier_enigma_black_hole_custom_leash:IsPurgable() return true end
function modifier_enigma_black_hole_custom_leash:OnCreated()
self.parent = self:GetParent()

if not IsServer() then return end
self.parent:GenericParticle("particles/units/heroes/hero_enigma/enigma_gravity_effect.vpcf", self)
end

function modifier_enigma_black_hole_custom_leash:CheckState()
return
{
	[MODIFIER_STATE_TETHERED] = true
}
end



modifier_enigma_black_hole_custom_auto_cd = class({})
function modifier_enigma_black_hole_custom_auto_cd:IsHidden() return true end
function modifier_enigma_black_hole_custom_auto_cd:IsPurgable() return false end
function modifier_enigma_black_hole_custom_auto_cd:RemoveOnDeath() return false end
function modifier_enigma_black_hole_custom_auto_cd:OnCreated()
self.parent = self:GetParent()
self.cd = self.parent:GetTalentValue("modifier_enigma_blackhole_5", "cd")

if not IsServer() then return end
self:UpdateUI()
end

function modifier_enigma_black_hole_custom_auto_cd:StartCd()
if not IsServer() then return end
self:SetStackCount(self.cd)

self:StartIntervalThink(1)
end

function modifier_enigma_black_hole_custom_auto_cd:OnIntervalThink()
if not IsServer() then return end
self:DecrementStackCount()

if self:GetStackCount() <= 0 then
	self:StartIntervalThink(-1)
end

end

function modifier_enigma_black_hole_custom_auto_cd:OnStackCountChanged()
if not IsServer() then return end
self:UpdateUI()
end



function modifier_enigma_black_hole_custom_auto_cd:UpdateUI()
if not IsServer() then return end

local override = self:GetStackCount()
local active = 0
if self:GetStackCount() == 0 then
	override = ""
	active = 1
end

self.parent:UpdateUIlong({max = self.cd, stack = self.cd - self:GetStackCount(), override_stack = override, no_min = 1, active = active, style = "EnigmaBlack"})
end