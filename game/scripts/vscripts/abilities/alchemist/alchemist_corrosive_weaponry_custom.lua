LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom_debuff", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom_legendary", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom_legendary_slow", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom_legendary_str", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom_silence_cd", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom_str_cd", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_corrosive_weaponry_custom_speed", "abilities/alchemist/alchemist_corrosive_weaponry_custom", LUA_MODIFIER_MOTION_NONE )

alchemist_corrosive_weaponry_custom = class({})

function alchemist_corrosive_weaponry_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", context )
PrecacheResource( "particle", "particles/general/generic_armor_reduction.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_corrosive_weaponry.vpcf", context )
PrecacheResource( "particle", "particles/alchemist/weapon_legendary.vpcf", context )
PrecacheResource( "particle", "particles/alchemist/weapon_legendary_proj.vpcf", context )

PrecacheResource( "particle","particles/status_fx/status_effect_poison_venomancer.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf", context )
PrecacheResource( "particle","particles/sand_king/finale_legendary.vpcf", context )
PrecacheResource( "particle","particles/sand_king/finale_legendary_poison.vpcf", context )

end


function alchemist_corrosive_weaponry_custom:CastFilterResultTarget(target)
local caster = self:GetCaster()
local team = DOTA_UNIT_TARGET_TEAM_ENEMY
if target:IsCreep() and not target:IsConsideredHero() then
	return UF_FAIL_CREEP
end
return UnitFilter(target, team, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, caster:GetTeamNumber())
end


function alchemist_corrosive_weaponry_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_alchemist_corrosive_weaponry_custom"
end

function alchemist_corrosive_weaponry_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_alchemist_greed_legendary") then
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function alchemist_corrosive_weaponry_custom:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_alchemist_greed_legendary") then
	return self:GetCaster():GetTalentValue("modifier_alchemist_greed_legendary", "cd")
end
return 0
end

function alchemist_corrosive_weaponry_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasTalent("modifier_alchemist_greed_legendary") then
	return self:GetCaster():GetTalentValue("modifier_alchemist_greed_legendary", "range")
end
return 0
end


function alchemist_corrosive_weaponry_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

caster:EmitSound("Alchemist.Weapon_proj_cast")
caster:EmitSound("Alchemist.Weapon_proj_cast2")
caster:EmitSound("Alchemist.Weapon_proj_cast_vo")
local info = 
{
   Target = target,
   Source = caster,
   Ability = self, 
   EffectName = "particles/alchemist/weapon_legendary_proj.vpcf",
   iMoveSpeed = 1200,
   bReplaceExisting = false,                         
   bProvidesVision = true,  
   bDodgeable = false,                         
   iVisionRadius = 30,        
   iSourceAttachment = caster:ScriptLookupAttachment("attach_attack3"),
   iVisionTeamNumber = caster:GetTeamNumber()      
}
ProjectileManager:CreateTrackingProjectile(info)

end


function alchemist_corrosive_weaponry_custom:OnProjectileHitHandle(target, vLocation, iProjectileHandle)
if not IsServer() then return end
if not target then return end

local caster = self:GetCaster()
target:EmitSound("Alchemist.Weapon_proj_hit")
target:EmitSound("Alchemist.Weapon_proj_hit2")

caster:RemoveModifierByName("modifier_alchemist_corrosive_weaponry_custom_legendary_str")
target:RemoveModifierByName("modifier_alchemist_corrosive_weaponry_custom_legendary_str")

target:AddNewModifier(caster, caster:BkbAbility(self, true), "modifier_alchemist_corrosive_weaponry_custom_legendary_slow", {duration = caster:GetTalentValue("modifier_alchemist_greed_legendary", "slow_duration")})
target:AddNewModifier(caster, self, "modifier_alchemist_corrosive_weaponry_custom_legendary", {duration = caster:GetTalentValue("modifier_alchemist_greed_legendary", "duration")})
end



function alchemist_corrosive_weaponry_custom:AddStack(target, count)
if not IsServer() then return end
if not self:IsTrained() then return end

local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("debuff_duration")

if not caster:PassivesDisabled() then
	for i = 1,count do
		target:AddNewModifier(caster, self, "modifier_alchemist_corrosive_weaponry_custom_debuff", {duration = duration})
	end
end

end



modifier_alchemist_corrosive_weaponry_custom = class(mod_hidden)
function modifier_alchemist_corrosive_weaponry_custom:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.attack_stack = self.ability:GetSpecialValueFor("attack_stack")

self.speed_duration = self.parent:GetTalentValue("modifier_alchemist_greed_3", "speed_duration", true)
	self.status_bonus = self.parent:GetTalentValue("modifier_alchemist_greed_3", "status")

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self.parent:AddAttackEvent_out(self, true)

self:UpdateTalent()
end


function modifier_alchemist_corrosive_weaponry_custom:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_alchemist_greed_3" or self.parent:HasTalent("modifier_alchemist_greed_3") then
	self.parent:AddAttackRecordEvent_out(self)
	self.status_bonus = self.parent:GetTalentValue("modifier_alchemist_greed_3", "status")
end

self:SendBuffRefreshToClients()
end


function modifier_alchemist_corrosive_weaponry_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end

function modifier_alchemist_corrosive_weaponry_custom:GetModifierStatusResistanceStacking()
return self.status_bonus
end


function modifier_alchemist_corrosive_weaponry_custom:AddCustomTransmitterData() 
return 
{
  status_bonus = self.status_bonus,
} 
end

function modifier_alchemist_corrosive_weaponry_custom:HandleCustomTransmitterData(data)
self.status_bonus = data.status_bonus
end


function modifier_alchemist_corrosive_weaponry_custom:AttackRecordEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_alchemist_greed_3") then return end
if self.parent ~= params.attacker then return end

local mod = params.target:FindModifierByName("modifier_alchemist_corrosive_weaponry_custom_debuff")
local stack = mod and mod:GetStackCount() or 0

self.parent:AddNewModifier(self.parent, self.ability, "modifier_alchemist_corrosive_weaponry_custom_speed", {duration = self.speed_duration, stack = stack})
end


function modifier_alchemist_corrosive_weaponry_custom:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

self.ability:AddStack(params.target, self.attack_stack)
end





modifier_alchemist_corrosive_weaponry_custom_debuff = class({})
function modifier_alchemist_corrosive_weaponry_custom_debuff:IsHidden() return false end
function modifier_alchemist_corrosive_weaponry_custom_debuff:IsPurgable() return not self.caster:HasTalent("modifier_alchemist_greed_4") end
function modifier_alchemist_corrosive_weaponry_custom_debuff:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.max = self.ability:GetSpecialValueFor("max_stacks")
self.slow = (self.ability:GetSpecialValueFor("max_slow") + self.caster:GetTalentValue("modifier_alchemist_greed_2", "move_slow"))/self.max
self.attack_slow = self.ability:GetSpecialValueFor("attack_slow")/self.max
self.spell_reduce = self.caster:GetTalentValue("modifier_alchemist_greed_2", "spell_reduce")/self.max

self.silence_cd = self.caster:GetTalentValue("modifier_alchemist_greed_4", "cd", true)
self.silence_duration = self.caster:GetTalentValue("modifier_alchemist_greed_4", "silence", true)

if not IsServer() then return end
self:SetStackCount(1)

if not self.caster:HasTalent("modifier_alchemist_greed_1") then return end
self.interval = self.caster:GetTalentValue("modifier_alchemist_greed_1", "interval")
self.damage = self.caster:GetTalentValue("modifier_alchemist_greed_1", "damage")*self.interval

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}
self:StartIntervalThink(self.interval)
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:OnRefresh(table)
if not IsServer() then return end

if self:GetStackCount() < self.max then 
	self:IncrementStackCount()
end

if self:GetStackCount() < self.max then return end
if not self.caster:HasTalent("modifier_alchemist_greed_4") then return end
if self.parent:HasModifier("modifier_alchemist_corrosive_weaponry_custom_silence_cd") then return end
if self.parent:IsDebuffImmune() then return end

self.parent:GenericParticle("particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf")
self.parent:EmitSound("Sf.Raze_Silence")
self.parent:AddNewModifier(self.caster, self.ability, "modifier_alchemist_corrosive_weaponry_custom_silence_cd", {duration = self.silence_cd})
self.parent:AddNewModifier(self.caster, self.ability, "modifier_generic_silence", {duration = (1 - self.parent:GetStatusResistance())*self.silence_duration})
end


function modifier_alchemist_corrosive_weaponry_custom_debuff:OnIntervalThink()
if not IsServer() then return end
self.damageTable.damage = self.damage*self:GetStackCount()
DoDamage(self.damageTable, "modifier_alchemist_greed_1")
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierAttackSpeedBonus_Constant()
return self.attack_slow*self:GetStackCount()
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.slow*self:GetStackCount()
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetModifierSpellAmplify_Percentage()
return self.spell_reduce*self:GetStackCount()
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetEffectName()
return "particles/units/heroes/hero_alchemist/alchemist_corrosive_weaponry.vpcf"
end

function modifier_alchemist_corrosive_weaponry_custom_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_alchemist_corrosive_weaponry.vpcf"

end
function modifier_alchemist_corrosive_weaponry_custom_debuff:StatusEffectPriority()
return MODIFIER_PRIORITY_LOW  
end




modifier_alchemist_corrosive_weaponry_custom_legendary = class(mod_hidden)
function modifier_alchemist_corrosive_weaponry_custom_legendary:GetEffectName() return "particles/sand_king/finale_legendary_poison.vpcf" end
function modifier_alchemist_corrosive_weaponry_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_poison_venomancer.vpcf" end
function modifier_alchemist_corrosive_weaponry_custom_legendary:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA  end

function modifier_alchemist_corrosive_weaponry_custom_legendary:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.ability:EndCd()

self.RemoveForDuel = true
self.parent:AddDamageEvent_inc(self)

self.parent:EmitSound("Alchemist.Weapon_legerndary_loop")

self.time = self.caster:GetTalentValue("modifier_alchemist_greed_legendary", "duration")
self.str_linger = self.caster:GetTalentValue("modifier_alchemist_greed_legendary", "linger")
self.str_cd = self.caster:GetTalentValue("modifier_alchemist_greed_legendary", "str_cd")

self.parent:GenericParticle("particles/units/heroes/hero_venomancer/venomancer_venomous_gale_impact.vpcf")

self.particle = ParticleManager:CreateParticle("particles/sand_king/finale_legendary.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
ParticleManager:SetParticleControl( self.particle, 1, Vector(self.time, self.time, self.time) )
ParticleManager:SetParticleControlEnt( self.particle, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end 

function modifier_alchemist_corrosive_weaponry_custom_legendary:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if self.caster ~= params.attacker then return end


if params.inflictor then
	if self.parent:HasModifier("modifier_alchemist_corrosive_weaponry_custom_str_cd") then 
		return 
	end
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_alchemist_corrosive_weaponry_custom_str_cd", {duration = self.str_cd})
end

self.caster:AddNewModifier(self.caster, self.caster:BkbAbility(self, true), "modifier_alchemist_corrosive_weaponry_custom_legendary_str", {duration = self.str_linger})
if self.parent:IsRealHero() then
	self.parent:AddNewModifier(self.caster, self.caster:BkbAbility(self, true), "modifier_alchemist_corrosive_weaponry_custom_legendary_str", {duration = self.str_linger})
end
self.parent:EmitSound("Alchemist.Weapon_legerndary_attack")
end


function modifier_alchemist_corrosive_weaponry_custom_legendary:OnIntervalThink()
if not IsServer() then return end 
local mod = self.parent:FindModifierByName("modifier_alchemist_corrosive_weaponry_custom_legendary_str")
if not mod then
	mod = self.caster:FindModifierByName("modifier_alchemist_corrosive_weaponry_custom_legendary_str")
end
local stack = mod and mod:GetStackCount() or 0

self.caster:UpdateUIshort({max_time = self.time, time = self:GetRemainingTime(), stack = stack, priority = 1, style = "AlchemistWeapon"})
end 


function modifier_alchemist_corrosive_weaponry_custom_legendary:OnDestroy()
if not IsServer() then return end 
self.ability:StartCd()

self.caster:UpdateUIshort({hide = 1, hide_full = 1, style = "AlchemistWeapon"})
self.parent:StopSound("Alchemist.Weapon_legerndary_loop")
end 




modifier_alchemist_corrosive_weaponry_custom_legendary_slow = class(mod_hidden)
function modifier_alchemist_corrosive_weaponry_custom_legendary_slow:OnCreated()
self.slow = -100
end

function modifier_alchemist_corrosive_weaponry_custom_legendary_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_alchemist_corrosive_weaponry_custom_legendary_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


modifier_alchemist_corrosive_weaponry_custom_legendary_str = class(mod_visible)
function modifier_alchemist_corrosive_weaponry_custom_legendary_str:GetTexture() return "buffs/alchemist/corrosive_legendary" end
function modifier_alchemist_corrosive_weaponry_custom_legendary_str:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.str = self.caster:GetTalentValue("modifier_alchemist_greed_legendary", "str")
if self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber() then
	self.str = self.str*-1
end

if not IsServer() then return end
self:SetStackCount(1)
self.parent:CalculateStatBonus(true)
end

function modifier_alchemist_corrosive_weaponry_custom_legendary_str:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end


function modifier_alchemist_corrosive_weaponry_custom_legendary_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end

function modifier_alchemist_corrosive_weaponry_custom_legendary_str:GetModifierBonusStats_Strength()
return self.str*self:GetStackCount()
end

function modifier_alchemist_corrosive_weaponry_custom_legendary_str:GetEffectName()
return "particles/units/heroes/hero_alchemist/alchemist_corrosive_weaponry.vpcf"
end

function modifier_alchemist_corrosive_weaponry_custom_legendary_str:GetStatusEffectName()
return "particles/status_fx/status_effect_alchemist_corrosive_weaponry.vpcf"

end
function modifier_alchemist_corrosive_weaponry_custom_legendary_str:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH  
end



modifier_alchemist_corrosive_weaponry_custom_silence_cd = class(mod_hidden)
modifier_alchemist_corrosive_weaponry_custom_str_cd = class(mod_hidden)


modifier_alchemist_corrosive_weaponry_custom_speed = class(mod_visible)
function modifier_alchemist_corrosive_weaponry_custom_speed:GetTexture() return "buffs/alchemist/greed_3" end
function modifier_alchemist_corrosive_weaponry_custom_speed:OnCreated(table)
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_alchemist_greed_3", "speed")

if not IsServer() then return end
self:SetStackCount(table.stack)
end

function modifier_alchemist_corrosive_weaponry_custom_speed:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(table.stack)
end

function modifier_alchemist_corrosive_weaponry_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_alchemist_corrosive_weaponry_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self.speed
end