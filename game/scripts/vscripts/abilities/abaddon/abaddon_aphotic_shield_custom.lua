LinkLuaModifier( "modifier_abaddon_aphotic_shield_custom", "abilities/abaddon/abaddon_aphotic_shield_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_aphotic_shield_custom_legendary_effect", "abilities/abaddon/abaddon_aphotic_shield_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_aphotic_shield_custom_blink", "abilities/abaddon/abaddon_aphotic_shield_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_aphotic_shield_custom_tracker", "abilities/abaddon/abaddon_aphotic_shield_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_aphotic_shield_custom_immune", "abilities/abaddon/abaddon_aphotic_shield_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_aphotic_shield_custom_str_stack", "abilities/abaddon/abaddon_aphotic_shield_custom", LUA_MODIFIER_MOTION_NONE )

abaddon_aphotic_shield_custom = class({})


function abaddon_aphotic_shield_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_abaddon_alliance_weapon_custom") then
    return "abaddon_aphotic_shield_alliance"
end
return "abaddon_aphotic_shield"
end

function abaddon_aphotic_shield_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/shield_stun.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/shield_legendary.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/shield_legendary_target.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/shield_blink.vpcf", context )
PrecacheResource( "particle", "particles/maiden_shield_active.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/shield_immune.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/shield_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_burning_shield.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/shield_legendary_immune.vpcf", context )
end


function abaddon_aphotic_shield_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_abaddon_aphotic_shield_custom_tracker"
end

function abaddon_aphotic_shield_custom:GetCastRange()
return self:GetSpecialValueFor("radius")
end

function abaddon_aphotic_shield_custom:GetBehavior()
local bonus = 0
local base = DOTA_ABILITY_BEHAVIOR_NO_TARGET
if not IsSoloMode() then 
  base = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end 
if self:GetCaster():HasTalent("modifier_abaddon_hero_6") then 
	bonus = DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 
return base + bonus
end

function abaddon_aphotic_shield_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level )
end

function abaddon_aphotic_shield_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level)
end


function abaddon_aphotic_shield_custom:OnSpellStart()

local caster = self:GetCaster()
local target = caster
if self:GetCursorTarget() then
	target = self:GetCursorTarget()
end

local duration = self:GetSpecialValueFor( "duration" )

if caster:HasTalent("modifier_abaddon_hero_6") then 
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
end 

target:AddNewModifier(caster, self, "modifier_abaddon_aphotic_shield_custom", {duration = duration} )
target:Purge( false, true, false, true, true)
end




modifier_abaddon_aphotic_shield_custom = class({})
function modifier_abaddon_aphotic_shield_custom:IsHidden() return false end
function modifier_abaddon_aphotic_shield_custom:IsPurgable() return false end
function modifier_abaddon_aphotic_shield_custom:OnCreated( kv )
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.barrier = self.ability:GetSpecialValueFor( "damage_absorb" ) + self.caster:GetTalentValue("modifier_abaddon_aphotic_1", "shield")*self.parent:GetMaxHealth()/100
self.radius = self.ability:GetSpecialValueFor( "radius" )

self.damage = self.barrier

self.max_shield = self.barrier
self:SetStackCount(self.max_shield)

self.size = 90

if not IsServer() then return end

self.RemoveForDuel = true

if (self.parent:HasTalent("modifier_abaddon_aphotic_7") or self.parent:HasTalent("modifier_abaddon_hero_6")) and not self.ability:IsHidden() then 
	self.parent:SwapAbilities(self.ability:GetName(), "abaddon_aphotic_shield_custom_legendary", false, true)
	self.parent:FindAbilityByName("abaddon_aphotic_shield_custom_legendary"):StartCooldown(0.2)
end 

self.max_timer = self:GetRemainingTime()

self.legendary_radius = self.caster:GetTalentValue("modifier_abaddon_aphotic_7", "radius", true)
self.legendary_stack = self.caster:GetTalentValue("modifier_abaddon_aphotic_7", "damage", true)
self.legendary_damage_inc = self.caster:GetTalentValue("modifier_abaddon_aphotic_7", "damage_inc", true)
self.legendary_damage_max = self.caster:GetTalentValue("modifier_abaddon_aphotic_7", "damage_max", true)
self.damage_interval = self.caster:GetTalentValue("modifier_abaddon_aphotic_7", "interval", true)

self.stun_duration = self.caster:GetTalentValue("modifier_abaddon_aphotic_4", "stun")

self.ability:EndCd()

self.parent:EmitSound("Hero_Abaddon.AphoticShield.Cast")
self.parent:EmitSound("Hero_Abaddon.AphoticShield.Loop")

self.damageTable = {attacker = self.caster, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability, }

self:PlayEffects()

if not self.parent:HasTalent("modifier_abaddon_aphotic_7") and not self.parent:HasTalent("modifier_abaddon_aphotic_3") then return end

if self.parent:HasTalent("modifier_abaddon_aphotic_7") then

	self.player = PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID())

	local effect_cast = ParticleManager:CreateParticle( "particles/abaddon/shield_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetAbsOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector(self.legendary_radius, self.legendary_radius, self.legendary_radius) )
	self:AddParticle( effect_cast, false, false, -1, false, false )


	self.parent:EmitSound("Abaddon.Shield_legendary_start")
	self.parent:EmitSound("Abaddon.Shield_legendary_start2")
	self.parent:EmitSound("Abaddon.Shield_legendary_loop")

end

self.count = self.damage_interval
self.stack_count = 0
self.interval = 0.1

self.str_duration = self.parent:GetTalentValue("modifier_abaddon_aphotic_3", "duration", true)

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_abaddon_aphotic_shield_custom:OnIntervalThink()
if not IsServer() then return end 

local targets = self.parent:FindTargets(self.legendary_radius)

if self.parent:HasTalent("modifier_abaddon_aphotic_7") then
	self.count = self.count + self.interval
	if self.count >= self.damage_interval - FrameTime() then
		self.count = 0 
		local real_damage = (self.legendary_stack*self.parent:GetMaxHealth()/100)*self.damage_interval

		for _,target in pairs(targets) do
			local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_burning_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
			ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
			ParticleManager:SetParticleControlEnt(hit_effect, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), false) 
			ParticleManager:ReleaseParticleIndex(hit_effect)
			DoDamage({victim = target, attacker = self.parent, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability, damage = real_damage}, "modifier_abaddon_aphotic_7")
		end
	end
	self.parent:UpdateUIshort({time = self:GetRemainingTime(), max_time = self.max_timer, stack = self.legendary_stack.."%", active = self.ability:IsHidden() and 0 or 1, style = "AbaddonShield"})
end

if #targets > 0 then
	self.stack_count = self.stack_count + self.interval
end

if self.stack_count > 0.98 then
	self.stack_count = 0

	if self.parent:HasTalent("modifier_abaddon_aphotic_3") then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_abaddon_aphotic_shield_custom_str_stack", {duration = self.str_duration})
	end

	if self.parent:HasTalent("modifier_abaddon_aphotic_7") and self.legendary_stack < self.legendary_damage_max then
		self.legendary_stack = self.legendary_stack + self.legendary_damage_inc
	end
end

end



function modifier_abaddon_aphotic_shield_custom:OnDestroy()
if not IsServer() then return end

if self.parent:HasTalent("modifier_abaddon_aphotic_7") then
	self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "AbaddonShield"})
	self.parent:StopSound("Abaddon.Shield_legendary_loop")
	self.parent:StopSound("Abaddon.Shield_legendary_start2")
end

if (self.parent:HasTalent("modifier_abaddon_aphotic_7") or self.parent:HasTalent("modifier_abaddon_hero_6")) and self.ability:IsHidden() then 
	self.parent:SwapAbilities(self.ability:GetName(), "abaddon_aphotic_shield_custom_legendary", true, false)
end 

self.ability:StartCd()

for _,enemy in pairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())) do

	if self.caster:HasTalent("modifier_abaddon_aphotic_4") then 
		local hit_effect = ParticleManager:CreateParticle("particles/abaddon/shield_stun.vpcf", PATTACH_CUSTOMORIGIN, enemy)
		ParticleManager:SetParticleControlEnt(hit_effect, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
		ParticleManager:SetParticleControlEnt(hit_effect, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
		ParticleManager:ReleaseParticleIndex(hit_effect)
		enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.stun_duration})
	end
	self.damageTable.damage = self.damage
	self.damageTable.victim = enemy
	DoDamage( self.damageTable )
end

self.parent:StopSound("Hero_Abaddon.AphoticShield.Loop")
self.parent:EmitSound("Hero_Abaddon.AphoticShield.Destroy")
end


function modifier_abaddon_aphotic_shield_custom:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_abaddon_aphotic_shield_custom:GetModifierIncomingDamageConstant( params )

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end

local attacker = params.attacker
local damage = params.damage

self:PlayEffects2()

local blocked_damage = math.min(damage, self:GetStackCount()) 
self.parent:AddShieldInfo({shield_mod = self, healing = blocked_damage, healing_type = "shield"})

if not self.parent:HasModifier("modifier_abaddon_aphotic_shield_custom_immune") then 
	self:SetStackCount(self:GetStackCount() - blocked_damage)
else
	blocked_damage = damage
	self.parent:EmitSound("Abaddon.Shield_immune_damage")
end

if self.caster:GetQuest() == "Abaddon.Quest_6" and not self.caster:QuestCompleted() and params.attacker:IsRealHero() then 
	self.caster:UpdateQuest(blocked_damage)
end

if self:GetStackCount() <= 0 then
	self:Destroy()
end

return -blocked_damage
end


function modifier_abaddon_aphotic_shield_custom:PlayEffects()

local particle_name = "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf"
if self:GetCaster():HasModifier("modifier_abaddon_alliance_weapon_custom") then
  particle_name = "particles/econ/items/abaddon/abaddon_alliance/abaddon_aphotic_shield_alliance.vpcf"
end

self.effect_cast = ParticleManager:CreateParticle( particle_name, PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(self.size,self.size,self.size) )
self:AddParticle( self.effect_cast, false, false, -1, false, false )
end


function modifier_abaddon_aphotic_shield_custom:PlayEffects2()
local size = self.size*0.75
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf", PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(size,size,size) )
ParticleManager:ReleaseParticleIndex( effect_cast )
end


function modifier_abaddon_aphotic_shield_custom:IsAura() return self.parent:HasTalent("modifier_abaddon_aphotic_7") end
function modifier_abaddon_aphotic_shield_custom:GetAuraDuration() return 0.1 end
function modifier_abaddon_aphotic_shield_custom:GetAuraRadius() return self.legendary_radius end
function modifier_abaddon_aphotic_shield_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_abaddon_aphotic_shield_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_abaddon_aphotic_shield_custom:GetModifierAura() return "modifier_abaddon_aphotic_shield_custom_legendary_effect" end







abaddon_aphotic_shield_custom_legendary = class({})


function abaddon_aphotic_shield_custom_legendary:GetCastRange(vLocation, hTarget)
local caster = self:GetCaster()
if not caster:HasTalent("modifier_abaddon_hero_6") then return 0 end

if IsClient() then 
	return caster:GetTalentValue("modifier_abaddon_hero_6", "range")
else 
	return 999999
end 

end 

function abaddon_aphotic_shield_custom_legendary:GetAOERadius()
if self:GetCaster():HasTalent("modifier_abaddon_hero_6") then 
	return self:GetCaster():GetTalentValue("modifier_abaddon_hero_6", "radius")
end 
return 
end



function abaddon_aphotic_shield_custom_legendary:GetBehavior()

local root = 0
local caster = self:GetCaster()

if self:GetCaster():HasTalent("modifier_abaddon_hero_6") then 
	if not caster:HasTalent("modifier_abaddon_aphotic_7") then
		root = DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	end

	return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_AOE + root
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end



function abaddon_aphotic_shield_custom_legendary:OnSpellStart()
local caster = self:GetCaster()

if not self:IsHidden() then 
	caster:SwapAbilities(self:GetName(), "abaddon_aphotic_shield_custom", false, true)
end 

if caster:HasTalent("modifier_abaddon_hero_6") and not caster:IsRooted() and not caster:IsLeashed() then 
	local range = caster:GetTalentValue("modifier_abaddon_hero_6", "range") + caster:GetCastRangeBonus()
	local point = self:GetCursorPosition()

	if point == caster:GetAbsOrigin() then 
		point = caster:GetAbsOrigin() + caster:GetForwardVector()*10
	end

	local dir = (point - caster:GetAbsOrigin()):Normalized()

	if (point - caster:GetAbsOrigin()):Length2D() > range then 
		point = caster:GetAbsOrigin() + dir*range
	end 

	dir.z = 0

	caster:FaceTowards(point)
	caster:SetForwardVector(dir)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Abaddon.Shield_blink_start", caster)
	EmitSoundOnLocationWithCaster(caster:GetAbsOrigin(), "Abaddon.Shield_blink_start2", caster)
	EmitSoundOnLocationWithCaster(point, "Abaddon.Shield_blink_end1", caster)
	caster:AddNewModifier(caster, self, "modifier_abaddon_aphotic_shield_custom_blink", {x = point.x, y = point.y, duration = caster:GetTalentValue("modifier_abaddon_hero_6", "duration")})
	return
end 

caster:AddNewModifier(caster, self, "modifier_abaddon_aphotic_shield_custom_immune", {duration = caster:GetTalentValue("modifier_abaddon_aphotic_7", "duration")})
end 





modifier_abaddon_aphotic_shield_custom_legendary_effect = class(mod_hidden)
function modifier_abaddon_aphotic_shield_custom_legendary_effect:GetStatusEffectName()
return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function modifier_abaddon_aphotic_shield_custom_legendary_effect:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_abaddon_aphotic_shield_custom_legendary_effect:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.slow = self.caster:GetTalentValue("modifier_abaddon_aphotic_7", "slow")
if not IsServer() then return end 

self.pfx = ParticleManager:CreateParticle("particles/abaddon/shield_legendary_target.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.pfx, 0, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControlEnt(self.pfx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
self:AddParticle(self.pfx, false, false, -1, false, false)	
end

function modifier_abaddon_aphotic_shield_custom_legendary_effect:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_abaddon_aphotic_shield_custom_legendary_effect:GetModifierMoveSpeedBonus_Percentage()
if not self.caster:HasModifier("modifier_abaddon_aphotic_shield_custom_immune") then return end
return self.slow
end




modifier_abaddon_aphotic_shield_custom_blink = class(mod_hidden)
function modifier_abaddon_aphotic_shield_custom_blink:OnCreated(params)

self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end 
self.point = GetGroundPosition(Vector(params.x, params.y, 0), nil)

self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_4)

local effect_cast = ParticleManager:CreateParticle("particles/abaddon/shield_blink.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect_cast, 0, self.point + Vector(0,0,100))
ParticleManager:SetParticleControl(effect_cast, 1, self.parent:GetAbsOrigin() + Vector(0,0,100))
ParticleManager:SetParticleControl(effect_cast, 2, self.point)
ParticleManager:ReleaseParticleIndex(effect_cast)

self.parent:NoDraw(self)
self.parent:AddNoDraw()
end 

function modifier_abaddon_aphotic_shield_custom_blink:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true
}
end

function modifier_abaddon_aphotic_shield_custom_blink:OnDestroy()
if not IsServer() then return end 

self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_4)

FindClearSpaceForUnit(self.parent, self.point, true)
self.parent:RemoveNoDraw()
self.parent:Stop()

if self.parent:HasTalent("modifier_abaddon_aphotic_7") then 
	self.parent:AddNewModifier(self.parent, self, "modifier_abaddon_aphotic_shield_custom_immune", {duration = self.parent:GetTalentValue("modifier_abaddon_aphotic_7", "duration")})
else 
	EmitSoundOnLocationWithCaster( self.point, "Abaddon.Shield_blink_end2", self.parent)
end

end 





modifier_abaddon_aphotic_shield_custom_tracker = class(mod_hidden)
function modifier_abaddon_aphotic_shield_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.PercentStr = self.parent:GetTalentValue("modifier_abaddon_aphotic_3", "str_passive")/100

self.cd_inc = self.parent:GetTalentValue("modifier_abaddon_aphotic_4", "cd_inc", true)

self.heal = self.parent:GetTalentValue("modifier_abaddon_aphotic_2", "heal")
self.heal_creeps = self.parent:GetTalentValue("modifier_abaddon_aphotic_2", "creeps", true)

self.armor_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_2", "armor")
self.status_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_2", "status")
self.shield_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_2", "bonus", true)

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_abaddon_aphotic_shield_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_abaddon_hero_2" or self.parent:HasTalent("modifier_abaddon_hero_2") then
	self.armor_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_2", "armor")
	self.status_bonus = self.parent:GetTalentValue("modifier_abaddon_hero_2", "status")
end

if name == "modifier_abaddon_aphotic_4" or self.parent:HasTalent("modifier_abaddon_aphotic_4") then
	self.parent:AddAttackEvent_out(self, true)
end
 
if name == "modifier_abaddon_aphotic_2" or self.parent:HasTalent("modifier_abaddon_aphotic_2") then
	self.parent:AddDamageEvent_out(self, true)
	self.heal = self.parent:GetTalentValue("modifier_abaddon_aphotic_2", "heal")
end
 
if name == "modifier_abaddon_aphotic_3" or self.parent:HasTalent("modifier_abaddon_aphotic_3") then
	self.PercentStr = self.parent:GetTalentValue("modifier_abaddon_aphotic_3", "str_passive")/100
end

self:SendBuffRefreshToClients()
end


function modifier_abaddon_aphotic_shield_custom_tracker:AddCustomTransmitterData() 
return 
{
  status_bonus = self.status_bonus,
  armor_bonus = self.armor_bonus,
} 
end

function modifier_abaddon_aphotic_shield_custom_tracker:HandleCustomTransmitterData(data)
self.status_bonus = data.status_bonus
self.armor_bonus = data.armor_bonus
end



function modifier_abaddon_aphotic_shield_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_abaddon_aphotic_2") then return end
if not self.parent:CheckLifesteal(params) then return end

local heal = params.damage*self.heal/100
heal = params.unit:IsCreep() and heal/self.heal_creeps or heal

self.parent:GenericHeal(heal, self.ability, true, "", "modifier_abaddon_aphotic_2")
local mod = self.parent:FindModifierByName("modifier_abaddon_aphotic_shield_custom")
if mod and mod.max_shield then
	mod:SetStackCount(math.min(mod.max_shield, mod:GetStackCount() + heal))
end

end


function modifier_abaddon_aphotic_shield_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_abaddon_aphotic_4") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
if not self.ability:IsActivated() then return end

self.parent:CdAbility(self.ability, self.cd_inc)
end


function modifier_abaddon_aphotic_shield_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end

function modifier_abaddon_aphotic_shield_custom_tracker:GetModifierStatusResistanceStacking() 
return self.parent:HasModifier("modifier_abaddon_aphotic_shield_custom") and self.shield_bonus*self.status_bonus or self.status_bonus
end

function modifier_abaddon_aphotic_shield_custom_tracker:GetModifierPhysicalArmorBonus()
return self.parent:HasModifier("modifier_abaddon_aphotic_shield_custom") and self.shield_bonus*self.armor_bonus or self.armor_bonus
end



modifier_abaddon_aphotic_shield_custom_immune = class(mod_hidden)
function modifier_abaddon_aphotic_shield_custom_immune:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()

local size = 135
self.legendary_effect = ParticleManager:CreateParticle( "particles/abaddon/shield_legendary_immune.vpcf", PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( self.legendary_effect, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( self.legendary_effect, 1, Vector(size, size, size) )
self:AddParticle( self.legendary_effect, false, false, -1, false, false )

self.parent:EmitSound("Abaddon.Shield_immune")
end


function modifier_abaddon_aphotic_shield_custom_immune:OnDestroy()
if not IsServer() then return end 

local mod = self.parent:FindModifierByName("modifier_abaddon_aphotic_shield_custom")

if mod and mod:GetStackCount() <= 0 then 
	mod:Destroy()
end 

end 

function modifier_abaddon_aphotic_shield_custom_immune:GetEffectName()
return "particles/abaddon/shield_immune.vpcf"
end
function modifier_abaddon_aphotic_shield_custom_immune:GetStatusEffectName()
return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function modifier_abaddon_aphotic_shield_custom_immune:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end





modifier_abaddon_aphotic_shield_custom_str_stack = class(mod_visible)
function modifier_abaddon_aphotic_shield_custom_str_stack:GetTexture() return "buffs/aphotic_stack" end
function modifier_abaddon_aphotic_shield_custom_str_stack:OnCreated()

self.parent = self:GetParent()

self.str = self.parent:GetTalentValue("modifier_abaddon_aphotic_3", "str")
self.max = self.parent:GetTalentValue("modifier_abaddon_aphotic_3", "max")
if not IsServer() then return end
self:SetStackCount(1)
self.parent:CalculateStatBonus(true)
end 

function modifier_abaddon_aphotic_shield_custom_str_stack:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self.parent:EmitSound("Abaddon.Shield_buff")
	self.particle = ParticleManager:CreateParticle( "particles/abaddon/shield_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( self.particle, 0, self.parent:GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.particle, 1, self.parent:GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.particle, 2, self.parent:GetAbsOrigin() )
	self:AddParticle(self.particle, false, false, 0, true, false)
end

self.parent:CalculateStatBonus(true)
end 

function modifier_abaddon_aphotic_shield_custom_str_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_abaddon_aphotic_shield_custom_str_stack:GetModifierBonusStats_Strength()
return self:GetStackCount()*self.str
end

function modifier_abaddon_aphotic_shield_custom_str_stack:GetModifierModelScale()
return self:GetStackCount()*4
end


