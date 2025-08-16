LinkLuaModifier("modifier_custom_juggernaut_blade_fury", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_thinker", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_fly", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_pause", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_legendary_fly_back", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_anim", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_tracker", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_mini", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_slow", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_damage", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_aura", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_damage_status", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_juggernaut_blade_fury_damage_reduce", "abilities/juggernaut/custom_juggernaut_blade_fury.lua", LUA_MODIFIER_MOTION_NONE)






custom_juggernaut_blade_fury = class({})



function custom_juggernaut_blade_fury:CreateTalent()

self:GetCaster():FindAbilityByName("custom_juggernaut_whirling_blade_custom"):SetHidden(false)
end



function custom_juggernaut_blade_fury:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf", context )
PrecacheResource( "particle", "particles/jugg_small_fury.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context )
PrecacheResource( "particle", "particles/sf_refresh_a.vpcf", context )
PrecacheResource( "particle", "particles/hoodwink/bush_damage.vpcf", context )
PrecacheResource( "particle", "particles/juggernaut/bladefury_stack.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_charge_mark.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/vindicators_axe_armor.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_minotaur_horn.vpcf", context )

dota1x6:PrecacheShopItems("npc_dota_hero_juggernaut", context)
end



function custom_juggernaut_blade_fury:GetAbilityTextureName()
  if self:GetCaster():HasModifier("modifier_juggernaut_edge_of_the_lost_crimson") then
      return "juggernaut/ti8_immortal_weapon/juggernaut_blade_fury_immortal_crimson"
  end
  if self:GetCaster():HasModifier("modifier_juggernaut_edge_of_the_lost_gold") then
      return "juggernaut/ti8_immortal_weapon/juggernaut_blade_fury_immortal_gold"
  end
  if self:GetCaster():HasModifier("modifier_juggernaut_edge_of_the_lost") then
      return "juggernaut/ti8_immortal_weapon/juggernaut_blade_fury_immortal"
  end
  if self:GetCaster():HasModifier("modifier_juggernaut_bladekeeper_weapon") then
      return "juggernaut/bladekeeper/juggernaut_blade_fury"
  end
  if self:GetCaster():HasModifier("modifier_juggernaut_arcana") or self:GetCaster():HasModifier("modifier_juggernaut_arcana_v2") then
      return "juggernaut_blade_fury_arcana"
  end
  return "juggernaut_blade_fury"
end



function custom_juggernaut_blade_fury:GetCastRange(vLocation, hTarget)
local radius = self:GetSpecialValueFor("blade_fury_radius") + self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_5", "radius")
return radius
end

function custom_juggernaut_blade_fury:GetIntrinsicModifierName()
return "modifier_custom_juggernaut_blade_fury_tracker"
end

function custom_juggernaut_blade_fury:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasShard() then 
	upgrade_cooldown = self:GetSpecialValueFor("shard_cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end




function custom_juggernaut_blade_fury:BladeFury_DealDamage(point, radius, ability, is_shard)
if not IsServer() then return end

local caster = self:GetCaster()
local damage_ability = is_shard
local interval = self:GetSpecialValueFor("interval")
local base_damage = (self:GetSpecialValueFor("blade_fury_damage") + caster:GetTalentValue("modifier_juggernaut_bladefury_1", "damage"))*interval

local slow_duration = caster:GetTalentValue("modifier_juggernaut_bladefury_3", "duration")

for _,target in pairs(caster:FindTargets(radius, point)) do

  local real_damage = DoDamage({victim = target, attacker = caster, damage = base_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability}, is_shard)

  if caster:HasTalent("modifier_juggernaut_bladefury_3") then 
  	target:AddNewModifier(caster, self, "modifier_custom_juggernaut_blade_fury_slow", {duration = slow_duration})
  end

  local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_juggernaut/juggernaut_blade_fury_tgt.vpcf", PATTACH_CUSTOMORIGIN, target)
  ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
  ParticleManager:ReleaseParticleIndex(particle)

  target:EmitSound("Hero_Juggernaut.BladeFury.Impact")
end

end


 


function custom_juggernaut_blade_fury:OnSpellStart()
self.duration = self:GetSpecialValueFor("duration")

if not IsServer() then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_debuff_immune", {magic_damage = self:GetSpecialValueFor("magic_resist"), duration = self.duration})

if self:GetCaster():HasModifier("modifier_custom_juggernaut_blade_fury") then 
    self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_fury")
end


local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_fury_tracker")
if mod and mod.active_thinkers then 
	for data,_ in pairs(mod.active_thinkers) do 
		if data and not data:IsNull() then 

			if data:HasModifier("modifier_custom_juggernaut_blade_fury_legendary_fly") then 
				data:RemoveModifierByName("modifier_custom_juggernaut_blade_fury_legendary_fly")
			end 

			if data:HasModifier("modifier_custom_juggernaut_blade_fury_legendary_pause") then 
				data:RemoveModifierByName("modifier_custom_juggernaut_blade_fury_legendary_pause")
			end 
		end
	end 
end 


self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury", {duration = self.duration, anim = 1})
self:GetCaster():Purge(false, true, false, false, false)

end







modifier_custom_juggernaut_blade_fury = class({})

function modifier_custom_juggernaut_blade_fury:IsPurgable() return false end

function modifier_custom_juggernaut_blade_fury:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
}  
end


function modifier_custom_juggernaut_blade_fury:GetModifierProcAttack_BonusDamage_Physical( params ) 
return -params.damage
end


function modifier_custom_juggernaut_blade_fury:OnCreated(table)
self.RemoveForDuel = true

self.damage = self:GetAbility():GetSpecialValueFor("blade_fury_damage_per_tick")
self.radius = self:GetAbility():GetSpecialValueFor("blade_fury_radius") + self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_5", "radius")

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.tick = self.ability:GetSpecialValueFor("interval")
self.count = self:GetAbility():GetSpecialValueFor("shard_interval")

self:PlayEffects()
   
self.silence_targets = {}

if not IsServer() then return end

self.pull_distance = self.caster:GetTalentValue("modifier_juggernaut_bladefury_5", "distance", true)
self.pull_duration = self.caster:GetTalentValue("modifier_juggernaut_bladefury_5", "duration", true)

self.damage_ability = self:GetAbility()

if self.parent:HasModifier("modifier_custom_juggernaut_blade_fury_legendary_thinker") and self.caster:HasAbility("custom_juggernaut_whirling_blade_custom") then 
	self.damage_ability = self.caster:FindAbilityByName("custom_juggernaut_whirling_blade_custom")
end 


if self.parent:IsHero() then 

	if self.caster:HasTalent("modifier_juggernaut_bladefury_6") then 
		self.mod = self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_juggernaut_blade_fury_damage_reduce", {})
	end 

	self.omni = self.caster:FindAbilityByName("custom_juggernaut_omnislash")
	self.swift = self.caster:FindAbilityByName("custom_juggernaut_swift_slash")

	if self.omni then 
		self.omni:SetActivated(false)
	end

	if self.swift then 
		self.swift:SetActivated(false)
	end
end

self:OnIntervalThink()
self:StartIntervalThink(self.tick)
end



function modifier_custom_juggernaut_blade_fury:OnIntervalThink()
if not IsServer() then return end

local targets = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

if self.caster:HasTalent("modifier_juggernaut_bladefury_5") and self.parent:IsHero() then 
	for _,target in pairs(targets) do 

		if not self.silence_targets[target] then 
			self.silence_targets[target] = true
	        target:AddNewModifier(self.caster, self:GetAbility(), "modifier_generic_silence", {duration = (1 - target:GetStatusResistance())*self:GetRemainingTime()})  
	        target:EmitSound("Juggernaut.Fury_silence")

			if (self.caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > self.pull_distance then 

				local dir = (self.caster:GetAbsOrigin() -  target:GetAbsOrigin()):Normalized()
				local point = self.caster:GetAbsOrigin() - dir*self.pull_distance

				local distance = (point - target:GetAbsOrigin()):Length2D()

				distance = math.max(100, distance)
				point = target:GetAbsOrigin() + dir*distance

				target:AddNewModifier( self.caster, self:GetAbility(),  "modifier_generic_arc",  
				{
				  target_x = point.x,
				  target_y = point.y,
				  distance = distance,
				  duration = self.pull_duration,
				  height = 0,
				  fix_end = false,
				  isStun = false,
				  activity = ACT_DOTA_FLAIL,
				})

			end 

	    end 
	end 
end 

self:GetAbility():BladeFury_DealDamage(self.parent:GetAbsOrigin(), self.radius, self.damage_ability)
self:StartIntervalThink(self.tick)
end




function modifier_custom_juggernaut_blade_fury:OnDestroy( kv )
if not IsServer() then return end

if self.mod and not self.mod:IsNull() then 
	self.mod:SetDuration(self.caster:GetTalentValue("modifier_juggernaut_bladefury_6", "duration"), true)
end 

if self.parent:IsHero() then 
	self.parent:Purge(false, true, false, true, false)
end

if not self.parent:HasModifier("modifier_custom_juggernaut_blade_fury_mini") then 
	self.parent:StopSound("Hero_Juggernaut.BladeFuryStart" )
end
self.parent:EmitSound("Hero_Juggernaut.BladeFuryStop")

self.parent:RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_1)

if self.parent:IsHero() then 
	self.omni = self.caster:FindAbilityByName("custom_juggernaut_omnislash")
	self.swift = self.caster:FindAbilityByName("custom_juggernaut_swift_slash")

	if self.omni then 
		self.omni:SetActivated(true)
	end

	if self.swift then 
		self.swift:SetActivated(true)
	end
end


end


function modifier_custom_juggernaut_blade_fury:IsAura()
return self.caster:HasTalent("modifier_juggernaut_bladefury_4")
end

function modifier_custom_juggernaut_blade_fury:GetModifierAura()
return "modifier_custom_juggernaut_blade_fury_aura"
end

function modifier_custom_juggernaut_blade_fury:GetAuraRadius()
return self.radius
end

function modifier_custom_juggernaut_blade_fury:GetAuraDuration()
return 0
end

function modifier_custom_juggernaut_blade_fury:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_juggernaut_blade_fury:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end









function modifier_custom_juggernaut_blade_fury:PlayEffects()
if not IsServer() then return end

local particle_cast = "particles/units/heroes/hero_juggernaut/juggernaut_blade_fury.vpcf"


if self.caster:HasModifier("modifier_juggernaut_edge_of_the_lost_crimson") then
    particle_cast = "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_crimson_blade_fury_abyssal.vpcf"
elseif self.caster:HasModifier("modifier_juggernaut_edge_of_the_lost_gold") then
    particle_cast = "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal_golden.vpcf"
elseif self.caster:HasModifier("modifier_juggernaut_edge_of_the_lost") then
    particle_cast = "particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal.vpcf"
elseif self.caster:HasModifier("modifier_juggernaut_bladekeeper_weapon") then
    particle_cast = "particles/econ/items/juggernaut/bladekeeper_bladefury/_dc_juggernaut_blade_fury.vpcf"
elseif self.caster:HasModifier("modifier_juggernaut_jade") then
    particle_cast = "particles/econ/items/juggernaut/jugg_sword_jade/juggernaut_blade_fury_jade.vpcf"
elseif self.caster:HasModifier("modifier_juggernaut_bladeform") then
    particle_cast = "particles/econ/items/juggernaut/armor_of_the_favorite/juggernaut_blade_fury_favoriteblade.vpcf"
elseif self.caster:HasModifier("modifier_juggernaut_kantusa") then
    particle_cast = "particles/econ/items/juggernaut/jugg_sword_script/juggernaut_blade_fury_script_new.vpcf"
elseif self.caster:HasModifier("modifier_juggernaut_dragonsword") then
    particle_cast = "particles/econ/items/juggernaut/jugg_sword_dragon/juggernaut_blade_fury_dragon.vpcf"
end

if self.parent:HasModifier("modifier_custom_juggernaut_blade_fury_legendary_thinker") then 
	local  particle_cast = "particles/jugg_small_fury.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius/1.6, 0, 0 ) )
	self:AddParticle(effect_cast,false,false,-1,false,false)
end

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius*1.2, 0, 0 ) )



local particle_cast_2 = nil
local effect_cast_2

if self.caster:HasModifier("modifier_juggernaut_arcana") then
    particle_cast_2 = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_blade_fury.vpcf"
end 

if self.caster:HasModifier("modifier_juggernaut_arcana_v2") then
    particle_cast_2 = "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_blade_fury.vpcf"
end 


if particle_cast_2 ~= nil then 
	effect_cast_2 = ParticleManager:CreateParticle( particle_cast_2, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast_2, 5, Vector( self.radius, 0, 0 ) )
end 

self:AddParticle(effect_cast,false,false,-1,false,false)

if effect_cast_2 then 
	self:AddParticle(effect_cast_2,false,false,-1,false,false)
end 

if self.parent:IsHero() then 
	self.parent:EmitSound("Hero_Juggernaut.BladeFuryStart")
end


end














modifier_custom_juggernaut_blade_fury_mini = class({})

function modifier_custom_juggernaut_blade_fury_mini:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_mini:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_mini:GetTexture() return "buffs/bladefury_agility" end

function modifier_custom_juggernaut_blade_fury_mini:OnCreated(table)
self.RemoveForDuel = true

self.caster = self:GetCaster()
if not IsServer() then return end

self.ability = self:GetAbility()
self.radius = self:GetAbility():GetSpecialValueFor("shard_radius")

local effect_cast = ParticleManager:CreateParticle( "particles/jugg_small_fury.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 5, Vector( self.radius/1.3, 0, 0 ) )

self:AddParticle(effect_cast,false,false,-1,false,false)
self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")

self.tick = self.ability:GetSpecialValueFor("interval")
self:OnIntervalThink()
self:StartIntervalThink(self.tick)
end



function modifier_custom_juggernaut_blade_fury_mini:OnIntervalThink()
self:GetAbility():BladeFury_DealDamage(self:GetParent():GetAbsOrigin(), self.radius, self:GetAbility(), "shard")
end


function modifier_custom_juggernaut_blade_fury_mini:OnDestroy( kv )
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") then 
	self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart" )
end

self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStop")
end



function modifier_custom_juggernaut_blade_fury_mini:IsAura()
return self.caster:HasTalent("modifier_juggernaut_bladefury_4")
end

function modifier_custom_juggernaut_blade_fury_mini:GetModifierAura()
return "modifier_custom_juggernaut_blade_fury_aura"
end

function modifier_custom_juggernaut_blade_fury_mini:GetAuraRadius()
return self.radius
end

function modifier_custom_juggernaut_blade_fury_mini:GetAuraDuration()
return 0
end

function modifier_custom_juggernaut_blade_fury_mini:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_custom_juggernaut_blade_fury_mini:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end









modifier_custom_juggernaut_blade_fury_slow = class({})
function modifier_custom_juggernaut_blade_fury_slow:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_slow:IsPurgable() return true end
function modifier_custom_juggernaut_blade_fury_slow:GetTexture() return "buffs/Blade_fury_slow" end


function modifier_custom_juggernaut_blade_fury_slow:OnCreated(table)

self.slow_move = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_3", "move")
self.slow_attack = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_3", "attack")

if not IsServer() then return end

local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(iParticleID, true, false, -1, false, false)

end




function modifier_custom_juggernaut_blade_fury_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

end

function modifier_custom_juggernaut_blade_fury_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow_move
end

function modifier_custom_juggernaut_blade_fury_slow:GetModifierAttackSpeedBonus_Constant()
return self.slow_attack
end


















modifier_custom_juggernaut_blade_fury_tracker = class({})
function modifier_custom_juggernaut_blade_fury_tracker:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_tracker:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}

end


function modifier_custom_juggernaut_blade_fury_tracker:OnCreated()

self.caster = self:GetCaster()

if self.caster:IsRealHero() then 
	self.caster:AddDamageEvent_out(self)
	self.caster:AddAttackEvent_out(self)
end
self.ability = self:GetAbility()

self.heal_creeps = self.caster:GetTalentValue("modifier_juggernaut_bladefury_1", "creeps", true)
self.bonus = self.caster:GetTalentValue("modifier_juggernaut_bladefury_2", "bonus", true)

self.shard_chance = self:GetAbility():GetSpecialValueFor("shard_chance")
self.shard_duration = self:GetAbility():GetSpecialValueFor("shard_duration") + FrameTime()

if not IsServer() then return end
self.active_thinkers = {}
end

function modifier_custom_juggernaut_blade_fury_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.caster:HasTalent("modifier_juggernaut_bladefury_1") then return end
if params.unit == self:GetParent() then return end
if params.attacker ~= self:GetParent() then return end
if params.inflictor == nil then return end
if not params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end

local heal = params.damage*self.caster:GetTalentValue("modifier_juggernaut_bladefury_1", "heal")/100

if params.unit:IsCreep() then 
	heal = heal / self.heal_creeps
end

self.caster:GenericHeal(heal, self.ability, true, "particles/items3_fx/octarine_core_lifesteal.vpcf", "modifier_juggernaut_bladefury_1")
end







function modifier_custom_juggernaut_blade_fury_tracker:GetModifierAttackSpeedBonus_Constant()
if not self.caster:HasTalent("modifier_juggernaut_bladefury_2") then return end 

local k = 1 
if self.caster:HasModifier("modifier_custom_juggernaut_blade_fury") then 
	k = self.bonus
end 

return self.caster:GetTalentValue("modifier_juggernaut_bladefury_2", "attack")*k
end


function modifier_custom_juggernaut_blade_fury_tracker:GetModifierMoveSpeedBonus_Constant()
if not self.caster:HasTalent("modifier_juggernaut_bladefury_2") then return end 

local k = 1 
if self.caster:HasModifier("modifier_custom_juggernaut_blade_fury") then 
	k = self.bonus
end 

return self.caster:GetTalentValue("modifier_juggernaut_bladefury_2", "move")*k
end




function modifier_custom_juggernaut_blade_fury_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.caster:IsIllusion() then return end
if self.caster ~= params.attacker then return end
if not self.caster:HasShard() then return end 
if not params.target:IsUnit() then return end 
if self.caster:HasModifier("modifier_custom_juggernaut_blade_fury_mini") then return end
if self.caster:HasModifier("modifier_custom_juggernaut_blade_fury") then return end


if RollPseudoRandomPercentage(self.shard_chance,194,self.caster) then 
	self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_juggernaut_blade_fury_mini", {duration = self.shard_duration })
end

end


















custom_juggernaut_whirling_blade_custom = class({})



function custom_juggernaut_whirling_blade_custom:GetCooldown(iLevel)

return self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_7", "cd")
end


function custom_juggernaut_whirling_blade_custom:GetAOERadius()
local radius = self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury"):GetSpecialValueFor("blade_fury_radius") + self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_5", "radius")

return radius
end



function custom_juggernaut_whirling_blade_custom:OnAbilityPhaseStart( )
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_anim", {})
self:GetCaster():StartGesture(ACT_DOTA_ATTACK_EVENT)
return true 
end





function custom_juggernaut_whirling_blade_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_fury")

self:GetCaster():RemoveModifierByName("modifier_custom_juggernaut_blade_fury_anim")
self:GetCaster():EmitSound("Juggernaut.Whirling_start")
local target = self:GetCursorPosition()

local thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_custom_juggernaut_blade_fury_legendary_thinker", {x = target.x, y = target.y }, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )

thinker:AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury"), "modifier_custom_juggernaut_blade_fury", {})

local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_fury_tracker")
if mod and mod.active_thinkers then 
   mod.active_thinkers[thinker] = true
end 


end


modifier_custom_juggernaut_blade_fury_legendary_thinker = class({})
function modifier_custom_juggernaut_blade_fury_legendary_thinker:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_legendary_thinker:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_legendary_thinker:OnCreated(table)
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("custom_juggernaut_blade_fury")

self.damage_count = 0 

self.radius = ability:GetSpecialValueFor("blade_fury_radius") + self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_5", "radius")

self.refresh = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_7", "refresh")

local point = Vector(table.x, table.y, self:GetParent():GetAbsOrigin().z)

local speed = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_7", "speed")

local distance = (point - self:GetParent():GetAbsOrigin()):Length2D()
local duration = distance/speed

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_legendary_fly", { x = table.x, y = table.y, duration = duration})

self.interval = 0.1
self.proced = false

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
self.sound = false
end


function modifier_custom_juggernaut_blade_fury_legendary_thinker:OnIntervalThink()
if not IsServer() then return end

if self.proced == false then 
	for _,target in pairs(self:GetCaster():FindTargets(self.radius, self:GetParent():GetAbsOrigin())) do 

		if target:IsHero() then 
			self.damage_count = self.damage_count + self.interval

			if self.damage_count >= self.refresh then 
				self.proced = true
				self:GetAbility():EndCooldown()

				local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
				ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex(particle)

				self:GetCaster():EmitSound("Hero_Rattletrap.Overclock.Cast")
			end 

			break
		end 
	end
end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.radius, 0.1, false)

if self.sound == false then 	
	self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
	self.sound = true
end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() then 
	self:Destroy()
end

end


function modifier_custom_juggernaut_blade_fury_legendary_thinker:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart")
self:GetCaster():EmitSound("Hero_Juggernaut.BladeFuryStop")

local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_fury_tracker")
if mod and mod.active_thinkers and mod.active_thinkers[self:GetParent()] then 
	mod.active_thinkers[self:GetParent()] = nil
end 

self:GetParent():RemoveModifierByName("modifier_custom_juggernaut_blade_fury")
end




modifier_custom_juggernaut_blade_fury_legendary_fly = class({})

function modifier_custom_juggernaut_blade_fury_legendary_fly:IsHidden() return true end

function modifier_custom_juggernaut_blade_fury_legendary_fly:OnCreated(params)
if not IsServer() then return end


self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()

self.knockback_speed = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_7", "speed")
self.interval = 0.05

self.position = GetGroundPosition(Vector(params.x, params.y, 0), nil)

self.direction = (self.position - self:GetParent():GetAbsOrigin()):Normalized()

self:StartIntervalThink(self.interval)
end




function modifier_custom_juggernaut_blade_fury_legendary_fly:OnIntervalThink()
if not IsServer() then return end

self:GetParent():SetOrigin( self:GetParent():GetAbsOrigin() + self.direction*self.interval*self.knockback_speed )
end


function modifier_custom_juggernaut_blade_fury_legendary_fly:OnDestroy()
if not IsServer() then return end
self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_legendary_pause", {duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_7", "duration")})
end





modifier_custom_juggernaut_blade_fury_legendary_pause = class({})
function modifier_custom_juggernaut_blade_fury_legendary_pause:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_legendary_pause:OnDestroy()
if not IsServer() then return end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() then 
	return
end

local point = self:GetCaster():GetAbsOrigin()

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_legendary_fly_back", {})
end







modifier_custom_juggernaut_blade_fury_legendary_fly_back = class({})

function modifier_custom_juggernaut_blade_fury_legendary_fly_back:IsHidden() return true end

function modifier_custom_juggernaut_blade_fury_legendary_fly_back:OnCreated(params)
if not IsServer() then return end

self:GetParent():EmitSound("Juggernaut.Whirling_start")
self.ability        = self:GetAbility()
self.caster         = self:GetCaster()
self.parent         = self:GetParent()
self.start = params.start

self.knockback_speed = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_7", "speed")
self.interval = 0.05


self:StartIntervalThink(self.interval)
end

function modifier_custom_juggernaut_blade_fury_legendary_fly_back:OnIntervalThink()
if not IsServer() then return end

if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() then 
	return
end

self.direction = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
 
self:GetParent():SetOrigin( self:GetParent():GetAbsOrigin() + self.direction*self.interval*self.knockback_speed )

if  (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 50 then 
	self:Destroy()
end

end


function modifier_custom_juggernaut_blade_fury_legendary_fly_back:OnDestroy()
if not IsServer() then return end
self:GetParent():FindModifierByName("modifier_custom_juggernaut_blade_fury_legendary_thinker"):Destroy()

end



modifier_custom_juggernaut_blade_fury_anim = class({})
function modifier_custom_juggernaut_blade_fury_anim:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_anim:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_anim:DeclareFunctions() return { MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS } end
function modifier_custom_juggernaut_blade_fury_anim:GetActivityTranslationModifiers() return "ti8" end

function modifier_custom_juggernaut_blade_fury_anim:OnAbilityPhaseInterrupted()


self:GetCaster():FadeGesture(ACT_DOTA_ATTACK_EVENT)
local mod = self:GetCaster():FindModifierByName("modifier_custom_juggernaut_blade_fury_anim")
if mod then mod:Destroy() end
end



modifier_custom_juggernaut_blade_fury_aura = class({})
function modifier_custom_juggernaut_blade_fury_aura:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_aura:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_aura:OnCreated()
if not IsServer() then return end

self.damage_duration = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_4", "duration")

self.caster = self:GetCaster()
self.interval = 0.1

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 

function modifier_custom_juggernaut_blade_fury_aura:OnIntervalThink()
if not IsServer() then return end

self:GetParent():AddNewModifier(self.caster, self:GetAbility(), "modifier_custom_juggernaut_blade_fury_damage", {duration = self.damage_duration, count = self.interval})
end 



modifier_custom_juggernaut_blade_fury_damage = class({})
function modifier_custom_juggernaut_blade_fury_damage:IsHidden() return false end
function modifier_custom_juggernaut_blade_fury_damage:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_damage:GetTexture() return "buffs/Blade_fury_slow" end


function modifier_custom_juggernaut_blade_fury_damage:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_4", "max", true)
self.magic = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_4", "magic")/self.max
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_4", "heal_reduce")/self.max

if not IsServer() then return end 
self.count = 0
end




function modifier_custom_juggernaut_blade_fury_damage:OnRefresh(table)
if not IsServer() then return end 

self.count = self.count + table.count

if self.count < 1 then return end

self.count = 0

if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self:GetParent():EmitSound("Juggernaut.BladeFury_heal_reduce")

	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_juggernaut_blade_fury_damage_status", {})
	self.particle_peffect = ParticleManager:CreateParticle("particles/hoodwink/bush_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

end 



function modifier_custom_juggernaut_blade_fury_damage:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end

if not self.effect_cast then 
	self.effect_cast = ParticleManager:CreateParticle( "particles/juggernaut/bladefury_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect_cast,false, false, -1, false, false)
end 

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

if self:GetStackCount() >= self.max then 
	ParticleManager:DestroyParticle(self.effect_cast, true)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)


	self.particle_trail = ParticleManager:CreateParticle("particles/lc_odd_charge_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.particle_trail, false, false, -1, false, false)
end 

end



function modifier_custom_juggernaut_blade_fury_damage:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveModifierByName("modifier_custom_juggernaut_blade_fury_damage_status")
end

function modifier_custom_juggernaut_blade_fury_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
 	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
 	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}

end

function modifier_custom_juggernaut_blade_fury_damage:GetModifierMagicalResistanceBonus()
return self.magic*self:GetStackCount()
end

function modifier_custom_juggernaut_blade_fury_damage:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_custom_juggernaut_blade_fury_damage:GetModifierHealAmplify_PercentageTarget() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_custom_juggernaut_blade_fury_damage:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end










modifier_custom_juggernaut_blade_fury_damage_status = class({})
function modifier_custom_juggernaut_blade_fury_damage_status:IsHidden() return true end
function modifier_custom_juggernaut_blade_fury_damage_status:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_damage_status:GetStatusEffectName()
return "particles/status_fx/status_effect_rupture.vpcf"
end

function modifier_custom_juggernaut_blade_fury_damage_status:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH
end





modifier_custom_juggernaut_blade_fury_damage_reduce = class({})
function modifier_custom_juggernaut_blade_fury_damage_reduce:IsHidden() return false end
function modifier_custom_juggernaut_blade_fury_damage_reduce:IsPurgable() return false end
function modifier_custom_juggernaut_blade_fury_damage_reduce:GetTexture() return "buffs/Blade_fury_shield" end
function modifier_custom_juggernaut_blade_fury_damage_reduce:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_6", "damage_reduce")
self.status = self:GetCaster():GetTalentValue("modifier_juggernaut_bladefury_6", "status")

if not IsServer() then return end 

self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.effect,false, false, -1, false, false)

end

function modifier_custom_juggernaut_blade_fury_damage_reduce:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_custom_juggernaut_blade_fury_damage_reduce:GetModifierIncomingDamage_Percentage()
return self.damage
end

function modifier_custom_juggernaut_blade_fury_damage_reduce:GetModifierStatusResistanceStacking() 
return self.status
end
function modifier_custom_juggernaut_blade_fury_damage_reduce:GetStatusEffectName()
return "particles/status_fx/status_effect_minotaur_horn.vpcf"
end

function modifier_custom_juggernaut_blade_fury_damage_reduce:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH
end


