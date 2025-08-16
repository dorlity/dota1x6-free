LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_tracker", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_slow", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_proc", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_legendary", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_legendary_active", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_stun", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_reduction", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_root", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_root_cd", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_attack_cd", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_attack_damage", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_shield", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_shield_cd", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_frost_arrows_custom_shield_stun", "abilities/drow_ranger/drow_ranger_frost_arrows_custom", LUA_MODIFIER_MOTION_NONE )

drow_ranger_frost_arrows_custom = class({})

function drow_ranger_frost_arrows_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/drow_ranger/frost_legendary_hit.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/frost_legendary.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/frost_legendary_start.vpcf", context )
PrecacheResource( "particle", "particles/maiden_mark.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", context )
PrecacheResource( "particle", "particles/maiden_frostbite_slow.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/frost_cleave.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/frost_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/frost_crystal.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/frost_crystal_2.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/frost_legendary_stack.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/frost_shield.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/frost_shield_end.vpcf", context )

end



function drow_ranger_frost_arrows_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
    return "drow_ranger_frost_arrow_arcana"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    return "drow_ranger_frost_arrow_arcana_alt1"
end
if self:GetCaster():HasModifier("modifier_drow_eldwurm_head_custom") then
    return "drow_ranger/dragons_touch_ability_icons/drow_ranger_frost_arrows"
end
return "drow_ranger_frost_arrows"
end


function drow_ranger_frost_arrows_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_drow_ranger_frost_arrows_custom_tracker"
end

function drow_ranger_frost_arrows_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasTalent("modifier_drow_frost_7") then 	
	return self:GetCaster():GetTalentValue("modifier_drow_frost_7", "range", true)
end 

return self:GetCaster():Script_GetAttackRange() - self:GetCaster():GetCastRangeBonus()
end

function drow_ranger_frost_arrows_custom:GetManaCost(iLevel)
return self:GetCost()
end


function drow_ranger_frost_arrows_custom:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_drow_frost_7") then 
	return self:GetCaster():GetTalentValue("modifier_drow_frost_7", "cd", true) 
end 

return 0
end

function drow_ranger_frost_arrows_custom:GetCastPoint()
if self:GetCaster():HasTalent("modifier_drow_frost_7") then 
	return self:GetCaster():GetTalentValue("modifier_drow_frost_7", "cast", true)
end 

return 0
end

function drow_ranger_frost_arrows_custom:GetCastAnimation()
if self:GetCaster():HasTalent("modifier_drow_frost_7") then 
	return 0
end 

end



function drow_ranger_frost_arrows_custom:OnAbilityPhaseStart()
if not self:GetCaster():HasTalent("modifier_drow_frost_7") then return end

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 1.9)

return true
end

function drow_ranger_frost_arrows_custom:OnAbilityPhaseInterrupted()
if not self:GetCaster():HasTalent("modifier_drow_frost_7") then return end

self:GetCaster():FadeGesture(ACT_DOTA_ATTACK)
end




function drow_ranger_frost_arrows_custom:GetBehavior()

if self:GetCaster():HasTalent("modifier_drow_frost_7") then 
	return DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_POINT
end 

return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST + DOTA_ABILITY_BEHAVIOR_ATTACK
end



function drow_ranger_frost_arrows_custom:GetProj()
local frost_effect = "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
if self:GetCaster():HasModifier("modifier_drow_ranger_ti9_immortal_weapon_custom") then
  frost_effect = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_frost_arrow.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
    frost_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    frost_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow_v2.vpcf"
end
return frost_effect
end

function drow_ranger_frost_arrows_custom:GetProjUlti()
local frost_ulti_effect = "particles/units/heroes/hero_drow/drow_marksmanship_frost_arrow.vpcf"
if self:GetCaster():HasModifier("modifier_drow_ranger_ti9_immortal_weapon_custom") then
  frost_ulti_effect = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_marksman_frost.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
  frost_ulti_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_frost_arrow.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
  frost_ulti_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_v2_marksmanship_frost_arrow.vpcf"
end
return frost_ulti_effect
end



    
    
    


function drow_ranger_frost_arrows_custom:OnSpellStart()
local caster = self:GetCaster()

if not caster:HasTalent("modifier_drow_frost_7") then return end


local range = caster:GetTalentValue("modifier_drow_frost_7", "range", true)
local speed = caster:GetTalentValue("modifier_drow_frost_7", "speed", true)
local width = caster:GetTalentValue("modifier_drow_frost_7", "width", true)

local origin = caster:GetAbsOrigin()
local vect = self:GetCursorPosition() - origin
local dir = vect:Normalized()
local point = origin + dir*(range + caster:GetCastRangeBonus())


ProjectileManager:CreateLinearProjectile({
	EffectName = "particles/drow_ranger/frost_legendary.vpcf",
	Ability = self,
	vSpawnOrigin = origin,
	fStartRadius = width,
	fEndRadius = width,
	vVelocity = dir * speed,
	fDistance = range + caster:GetCastRangeBonus(),
	Source = caster,
	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
	bProvidesVision = true,
	iVisionTeamNumber = caster:GetTeamNumber(),
	iVisionRadius = width*3,
	ExtraData =   
	{
		active = 1,
	},
})

caster:EmitSound("Drow.Frost_legendary_start")
caster:EmitSound("Drow.Frost_legendary_start2")

local effect_cast = ParticleManager:CreateParticle( "particles/drow_ranger/frost_legendary_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin())
ParticleManager:SetParticleControl( effect_cast, 1, caster:GetOrigin())
ParticleManager:SetParticleControlForward( effect_cast, 1, caster:GetForwardVector())
ParticleManager:ReleaseParticleIndex(effect_cast)

end


function drow_ranger_frost_arrows_custom:OnProjectileHit_ExtraData(hTarget, vLocation, table)
if not hTarget then return end

local caster = self:GetCaster()

if table.active == 1 then  

	local mod = hTarget:FindModifierByName("modifier_drow_ranger_frost_arrows_custom_legendary")

	if not mod then return end

	local stack = mod:GetStackCount()
	local duration = caster:GetTalentValue("modifier_drow_frost_7", "duration", true)

	if caster:HasTalent("modifier_drow_frost_7") then 
		local max = caster:GetTalentValue("modifier_drow_frost_7", "max")
		local stun = (caster:GetTalentValue("modifier_drow_frost_7", "stun")/max)*stack
	    hTarget:AddNewModifier(caster, self, "modifier_drow_ranger_frost_arrows_custom_stun", {duration = stun*(1 - hTarget:GetStatusResistance())})
	end

    hTarget:AddNewModifier(caster, self, "modifier_drow_ranger_frost_arrows_custom_legendary_active", {duration = duration, stack = stack})
	hTarget:EmitSound("Drow.Frost_legendary_hit")

	local effect_cast = ParticleManager:CreateParticle( "particles/drow_ranger/frost_legendary_hit.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(effect_cast)

	mod:Destroy()
else 
	caster:AddNewModifier(caster, self, "modifier_drow_ranger_frost_arrows_custom_attack_damage", {duration = FrameTime()})
	caster:PerformAttack(hTarget, true, true, true, true, false, false, true)
	caster:RemoveModifierByName("modifier_drow_ranger_frost_arrows_custom_attack_damage")
	hTarget:EmitSound("Drow.Frost_proc_target")
end

end



function drow_ranger_frost_arrows_custom:LaunchShard()
if not IsServer() then return end


local caster = self:GetCaster()
local radius = caster:GetTalentValue("modifier_drow_frost_4", "radius")
local targets = caster:GetTalentValue("modifier_drow_frost_4", "targets")
local count = 0
local projectile_speed = 1500

caster:EmitSound("Drow.Frost_proc")

local projectile =
{
	Source 				= caster,
	Ability 			= self,
	iMoveSpeed			= projectile_speed,
	vSourceLoc 			= caster:GetAbsOrigin(),
	bDrawsOnMinimap 	= false,
	bDodgeable 			= true,
	bIsAttack 			= false,
	bVisibleToEnemies 	= true,
	bReplaceExisting 	= false,
	flExpireTime 		= GameRules:GetGameTime() + 20,
	bProvidesVision 	= false,
	ExtraData			= {active = 0}
}

local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST ,false)
  
for _,target in pairs(units) do 

	if RandomInt(1, 2) == 1 then 
		projectile.EffectName = "particles/drow_ranger/frost_crystal_2.vpcf"
	else 
		projectile.EffectName = "particles/drow_ranger/frost_crystal.vpcf"
	end

	projectile.Target = target
	ProjectileManager:CreateTrackingProjectile(projectile)

	count = count + 1
	if count >= targets then 
		break
	end 
end

end 



function drow_ranger_frost_arrows_custom:GetCost()
return self:GetSpecialValueFor("AbilityManaCost") + self:GetCaster():GetTalentValue("modifier_drow_frost_2", "mana")
end


function drow_ranger_frost_arrows_custom:GetDamage(target)
local bonus = 0
local caster = self:GetCaster()
local k = 1

if caster:HasTalent("modifier_drow_frost_1") then 
	local mod = target:FindModifierByName("modifier_drow_ranger_frost_arrows_custom_reduction")
	if mod then 
		bonus = bonus + caster:GetTalentValue("modifier_drow_frost_1", "damage")*mod:GetStackCount()
	end 
end

if target:IsCreep() then
	k = self:GetSpecialValueFor("creeps_damage")
end

return (self:GetSpecialValueFor("damage") + bonus)*k
end



function drow_ranger_frost_arrows_custom:ApplySlow(target, new_duration)

local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("AbilityDuration")

if new_duration then 
	duration = new_duration
end

if caster:HasTalent("modifier_drow_frost_5") then 
	duration = duration + caster:GetTalentValue("modifier_drow_frost_5", "duration")

	if not target:HasModifier("modifier_drow_ranger_frost_arrows_custom_root_cd") then

    target:EmitSound("Hero_Crystal.frostbite")
    target:AddNewModifier(caster, self, "modifier_drow_ranger_frost_arrows_custom_root", {duration = (1 - target:GetStatusResistance())*caster:GetTalentValue("modifier_drow_frost_5", "root")})
    target:AddNewModifier(caster, self, "modifier_drow_ranger_frost_arrows_custom_root_cd", {duration = caster:GetTalentValue("modifier_drow_frost_5", "cd")})
	end
end 

if not target:HasModifier("modifier_drow_ranger_frost_arrows_custom_legendary_active") and caster:HasTalent("modifier_drow_frost_7") then
	target:AddNewModifier(caster, self, "modifier_drow_ranger_frost_arrows_custom_legendary", {duration = caster:GetTalentValue("modifier_drow_frost_7", "stack_duration", true)})
end

if caster:HasTalent("modifier_drow_frost_3") or caster:HasTalent("modifier_drow_frost_1") then 
	target:AddNewModifier(caster, self, "modifier_drow_ranger_frost_arrows_custom_reduction", {duration = caster:GetTalentValue("modifier_drow_frost_3", "duration", true)})
end 

target:AddNewModifier(caster, caster:BkbAbility(self, caster:HasTalent("modifier_drow_frost_5")), "modifier_drow_ranger_frost_arrows_custom_slow", {duration = (1 - target:GetStatusResistance())*duration})
end








modifier_drow_ranger_frost_arrows_custom_tracker = class({})
function modifier_drow_ranger_frost_arrows_custom_tracker:IsHidden() return true end
function modifier_drow_ranger_frost_arrows_custom_tracker:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_tracker:OnCreated(table)
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.ulti_ability = self.parent:FindAbilityByName("drow_ranger_marksmanship_custom")

self.radius = self.caster:GetTalentValue("modifier_drow_frost_1", "radius", true)

self.attack_cd = self.caster:GetTalentValue("modifier_drow_frost_4", "cd", true)

self.shield_health = self.caster:GetTalentValue("modifier_drow_frost_6", "health", true)
self.shield_duration = self.caster:GetTalentValue("modifier_drow_frost_6", "cd", true)

if not IsServer() then return end 

if self.parent:IsRealHero() then 
  	self.parent:AddRecordDestroyEvent(self)
	self.parent:AddAttackRecordEvent_out(self)
	self.parent:AddDamageEvent_inc(self)
	self.parent:AddSpellEvent(self)
	self.parent:AddAttackStartEvent_out(self)
	self.parent:AddOrderEvent(self)
end 

self.records = {}
self.cast = false
end

function modifier_drow_ranger_frost_arrows_custom_tracker:OnRefresh(table)
self:OnCreated()
end



function modifier_drow_ranger_frost_arrows_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_PROJECTILE_NAME,
  	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
  	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end

function modifier_drow_ranger_frost_arrows_custom_tracker:GetModifierPercentageCooldown()
if not self.parent:HasTalent("modifier_drow_frost_4") then return end
return self.parent:GetTalentValue("modifier_drow_frost_4", "cdr")
end


function modifier_drow_ranger_frost_arrows_custom_tracker:GetModifierAttackRangeBonus()
if self.parent:IsRangedAttacker() then return end
return 300
end



function modifier_drow_ranger_frost_arrows_custom_tracker:GetPriority()
return 99999
end

function modifier_drow_ranger_frost_arrows_custom_tracker:RecordDestroyEvent( params )
self.records[params.record] = nil
end


function modifier_drow_ranger_frost_arrows_custom_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_drow_frost_6") then return end
if self.parent:GetHealthPercent() > self.shield_health then return end
if self.parent ~= params.unit then return end
if self.parent:PassivesDisabled() then return end 
if not self.parent:IsAlive() then return end
if self.parent:HasModifier("modifier_drow_ranger_frost_arrows_custom_shield") or self.parent:HasModifier("modifier_drow_ranger_frost_arrows_custom_shield_cd") then return end
if self.parent:HasModifier("modifier_death") then return end 

self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_frost_arrows_custom_shield", {duration = self.shield_duration})
end



function modifier_drow_ranger_frost_arrows_custom_tracker:OrderEvent( params )
if self.parent:HasTalent("modifier_drow_frost_7") then return end 

if params.ability and params.ability==self.ability then 
	self.cast = true
else 
	self.cast = false
end 

end



function modifier_drow_ranger_frost_arrows_custom_tracker:AttackRecordEvent_out(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 

self.parent:RemoveModifierByName("modifier_drow_ranger_frost_arrows_custom_proc")

if not self:ShouldLaunch( params.target ) then return end
self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_frost_arrows_custom_proc", {})
end 




function modifier_drow_ranger_frost_arrows_custom_tracker:AttackStartEvent_out( params )

if params.attacker:HasModifier("modifier_drow_ranger_wave_of_silence_custom_legendary_illusion") and params.target:IsUnit() and params.attacker.owner and params.attacker.owner == self.parent then 
	params.attacker:EmitSound("Hero_DrowRanger.FrostArrows")
end

if params.attacker~=self.parent then return end

if self.parent:HasModifier("modifier_drow_ranger_frost_arrows_custom_proc") then
	self.parent:RemoveModifierByName("modifier_drow_ranger_frost_arrows_custom_proc")

	self.cast = false
	self.ability:UseResources( true, false, false, false )
	self.records[params.record] = true
	self.parent:EmitSound("Hero_DrowRanger.FrostArrows")
end

if not self.parent:HasTalent("modifier_drow_frost_4") then return end
if self.parent:HasModifier("modifier_drow_ranger_frost_arrows_custom_attack_cd") then return end
if params.no_attack_cooldown then return end
if not params.target:IsUnit() then return end
self.ability:LaunchShard()

self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_frost_arrows_custom_attack_cd", {duration = self.attack_cd})
end



function modifier_drow_ranger_frost_arrows_custom_tracker:SpellEvent(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_drow_frost_4") then return end
if params.unit~=self.parent then return end

self.ability:LaunchShard()
end



function modifier_drow_ranger_frost_arrows_custom_tracker:GetModifierProjectileName()
local has_ulti = self.parent:HasModifier("modifier_drow_ranger_marksmanship_custom_proc")
local has_frost = self.parent:HasModifier("modifier_drow_ranger_frost_arrows_custom_proc")

local base = "particles/units/heroes/hero_drow/drow_base_attack.vpcf"
if self:GetCaster():HasModifier("modifier_drow_ranger_ti9_immortal_weapon_custom") then
  base = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_base_attack.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
  base = "particles/econ/items/drow/drow_arcana/drow_arcana_base_attack.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
  base = "particles/econ/items/drow/drow_arcana/drow_arcana_base_attack_v2.vpcf"
end

if has_frost and has_ulti then 
   return self.ability:GetProjUlti()
end 
if has_frost then 
   return self.ability:GetProj()
end
if has_ulti and self.ulti_ability then 
   return self.ulti_ability:GetProj()
end
return base
end


function modifier_drow_ranger_frost_arrows_custom_tracker:ShouldLaunch( target )
if self.parent:IsSilenced() then return false end
if not self.ability:GetAutoCastState() and self.cast == false then return false end
if self.parent:GetMana() < self.ability:GetCost() then return end
if not target:IsUnit() then return end

return true
end

function modifier_drow_ranger_frost_arrows_custom_tracker:GetModifierProcAttack_BonusDamage_Physical( params )
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end 

if params.target:HasModifier("modifier_drow_ranger_frost_arrows_custom_legendary_active") then 
	params.target:EmitSound("Drow.Frost_legendary_active_damage")
end 


local k = 1

if self.parent:HasModifier("modifier_drow_ranger_frost_arrows_custom_attack_damage") then 

	if self.ability:GetAutoCastState() == false then 
		return
	end 

	k = self.parent:GetTalentValue("modifier_drow_frost_4", "damage")/100
else 
	if not self.records[params.record] then 
		return
	end
end 

local target = params.target

self.ability:ApplySlow(params.target)

return self.ability:GetDamage(params.target)*k
end






modifier_drow_ranger_frost_arrows_custom_slow = class({})
function modifier_drow_ranger_frost_arrows_custom_slow:IsHidden() return true end
function modifier_drow_ranger_frost_arrows_custom_slow:IsPurgable() return true end
function modifier_drow_ranger_frost_arrows_custom_slow:GetTexture() return "drow_ranger_frost_arrows" end
function modifier_drow_ranger_frost_arrows_custom_slow:OnCreated()

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.ability = self.caster:FindAbilityByName("drow_ranger_frost_arrows_custom")
if not self.ability then 
	self:Destroy()
	return
end

self.slow = self.ability:GetSpecialValueFor("frost_arrows_movement_speed") + self.caster:GetTalentValue("modifier_drow_frost_2", "slow")

if not IsServer() then return end 

local part = "particles/units/heroes/hero_drow/drow_frost_arrow_debuff.vpcf"
if self.caster:HasModifier("modifier_drow_ranger_arcana_custom") then
	part = "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow_debuff.vpcf"
end
if self.caster:HasModifier("modifier_drow_ranger_arcana_custom_v2") then
	part = "particles/econ/items/drow/drow_arcana/drow_arcana_frost_arrow_debuff_v2.vpcf"
end
self.effect_cast = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN_FOLLOW, self.parent )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

if self.parent:IsRealHero() and self.caster:GetQuest() == "Drow.Quest_5" and not self.caster:QuestCompleted() then
	self.interval = 0.1
	self:StartIntervalThink(self.interval)
end

end

function modifier_drow_ranger_frost_arrows_custom_slow:OnIntervalThink()
if not IsServer() then return end 
self.caster:UpdateQuest(self.interval)
end


function modifier_drow_ranger_frost_arrows_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_drow_ranger_frost_arrows_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_drow_ranger_frost_arrows_custom_slow:GetStatusEffectName()
if not self.caster or self.caster:IsNull() then 
	return "particles/status_fx/status_effect_drow_frost_arrow.vpcf"
end

local effect = "particles/status_fx/status_effect_drow_frost_arrow.vpcf"
if self.caster:HasModifier("modifier_drow_ranger_ti9_immortal_weapon_custom") then
    effect = "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end
if self.caster:HasModifier("modifier_drow_ranger_arcana_custom") then
    effect = "particles/econ/items/drow/drow_arcana/drow_arcana_status_effect_frost_arrow.vpcf"
end
if self.caster:HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    effect = "particles/econ/items/drow/drow_arcana/drow_arcana_status_effect_frost_arrow.vpcf"
end
return effect
end

function modifier_drow_ranger_frost_arrows_custom_slow:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL 
end



modifier_drow_ranger_frost_arrows_custom_proc = class({})
function modifier_drow_ranger_frost_arrows_custom_proc:IsHidden() return true end
function modifier_drow_ranger_frost_arrows_custom_proc:IsPurgable() return false end




modifier_drow_ranger_frost_arrows_custom_legendary = class({})
function modifier_drow_ranger_frost_arrows_custom_legendary:IsHidden() return true end
function modifier_drow_ranger_frost_arrows_custom_legendary:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.max = self.caster:GetTalentValue("modifier_drow_frost_7", "max", true)

if not IsServer() then return end 
self.RemoveForDuel = true
self.effect_cast = ParticleManager:CreateParticle( "particles/drow_ranger/frost_legendary_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end

function modifier_drow_ranger_frost_arrows_custom_legendary:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self.parent:EmitSound("Drow.Frost_legendary_max")
end 

end 


function modifier_drow_ranger_frost_arrows_custom_legendary:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end

if self.effect_cast then
	local k1 = 0
	local k2 = self:GetStackCount()

	if k2 >= 10 then 
	    k1 = 1
	    k2 = self:GetStackCount() - 10
	end

	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( k1, k2, 0 ) )

end

end








modifier_drow_ranger_frost_arrows_custom_legendary_active = class({})
function modifier_drow_ranger_frost_arrows_custom_legendary_active:IsHidden() return false end
function modifier_drow_ranger_frost_arrows_custom_legendary_active:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_legendary_active:GetTexture() return "buffs/frost_legendary" end
function modifier_drow_ranger_frost_arrows_custom_legendary_active:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

local max = self.caster:GetTalentValue("modifier_drow_frost_7", "max", true)
self.damage = self.caster:GetTalentValue("modifier_drow_frost_7", "damage", true)/max
self.heal_reduce = self.caster:GetTalentValue("modifier_drow_frost_7", "heal_reduce", true)/max

if not IsServer() then return end 

self.mark = ParticleManager:CreateParticle( "particles/maiden_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
self:AddParticle(self.mark,false, false, -1, false, false)

self:SetStackCount(table.stack)
end


function modifier_drow_ranger_frost_arrows_custom_legendary_active:GetEffectName()
return "particles/drow_ranger/frost_legendary_active.vpcf"
end

function modifier_drow_ranger_frost_arrows_custom_legendary_active:GetStatusEffectName()
return "particles/econ/items/drow/drow_arcana/drow_arcana_status_effect_frost_arrow.vpcf"
end


function modifier_drow_ranger_frost_arrows_custom_legendary_active:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end


function modifier_drow_ranger_frost_arrows_custom_legendary_active:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end


function modifier_drow_ranger_frost_arrows_custom_legendary_active:GetModifierIncomingDamage_Percentage() 
return self.damage*self:GetStackCount()
end

function modifier_drow_ranger_frost_arrows_custom_legendary_active:GetModifierLifestealRegenAmplify_Percentage()
return self.heal_reduce*self:GetStackCount()
end

function modifier_drow_ranger_frost_arrows_custom_legendary_active:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce*self:GetStackCount()
end

function modifier_drow_ranger_frost_arrows_custom_legendary_active:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end





modifier_drow_ranger_frost_arrows_custom_stun = class({})
function modifier_drow_ranger_frost_arrows_custom_stun:IsHidden() return true end
function modifier_drow_ranger_frost_arrows_custom_stun:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_stun:IsStunDebuff() return true end
function modifier_drow_ranger_frost_arrows_custom_stun:IsPurgeException() return true end


function modifier_drow_ranger_frost_arrows_custom_stun:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_drow_ranger_frost_arrows_custom_stun:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_drow_ranger_frost_arrows_custom_stun:CheckState()
return
{
    [MODIFIER_STATE_FROZEN] = true,
    [MODIFIER_STATE_STUNNED] = true
}
end

function modifier_drow_ranger_frost_arrows_custom_stun:OnCreated()
if not IsServer() then return end

self:GetParent():EmitSound("Drow.Frost_legendary_stun")
end







modifier_drow_ranger_frost_arrows_custom_reduction = class({})
function modifier_drow_ranger_frost_arrows_custom_reduction:IsHidden() return false end
function modifier_drow_ranger_frost_arrows_custom_reduction:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_reduction:GetTexture() return "buffs/frost_stack" end
function modifier_drow_ranger_frost_arrows_custom_reduction:OnCreated()
self.caster = self:GetCaster()
self.max = self.caster:GetTalentValue("modifier_drow_frost_3", "max", true)
self.speed = self.caster:GetTalentValue("modifier_drow_frost_3", "speed")/self.max
self.damage = self.caster:GetTalentValue("modifier_drow_frost_3", "damage")/self.max

self.damage_bonus = self.caster:GetTalentValue("modifier_drow_frost_1", "damage", true)

self.parent = self:GetParent()

if not IsServer() then return end 
self:SetStackCount(1)
end

function modifier_drow_ranger_frost_arrows_custom_reduction:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self.effect_cast = ParticleManager:CreateParticle( "particles/maiden_frostbite_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
	self:AddParticle(self.effect_cast,false, false, -1, false, false)
end 

end

function modifier_drow_ranger_frost_arrows_custom_reduction:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_drow_ranger_frost_arrows_custom_reduction:GetModifierSpellAmplify_Percentage()
if not self.caster:HasTalent("modifier_drow_frost_3") then return 0 end
return self.damage*self:GetStackCount()
end

function modifier_drow_ranger_frost_arrows_custom_reduction:GetModifierAttackSpeedBonus_Constant()
if not self.caster:HasTalent("modifier_drow_frost_3") then return 0 end
return self.speed*self:GetStackCount()
end


function modifier_drow_ranger_frost_arrows_custom_reduction:OnTooltip()
if not self.caster:HasTalent("modifier_drow_frost_1") then return 0 end
return self.damage_bonus*self:GetStackCount()
end







modifier_drow_ranger_frost_arrows_custom_root = class({})
function modifier_drow_ranger_frost_arrows_custom_root:IsHidden() return true end
function modifier_drow_ranger_frost_arrows_custom_root:IsPurgable() return true end
function modifier_drow_ranger_frost_arrows_custom_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end

function modifier_drow_ranger_frost_arrows_custom_root:GetEffectName() return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end
function modifier_drow_ranger_frost_arrows_custom_root:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end





modifier_drow_ranger_frost_arrows_custom_root_cd = class({})
function modifier_drow_ranger_frost_arrows_custom_root_cd:IsHidden() return true end
function modifier_drow_ranger_frost_arrows_custom_root_cd:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_root_cd:RemoveOnDeath() return false end
function modifier_drow_ranger_frost_arrows_custom_root_cd:OnCreated()
self.RemoveForDuel = true
end



modifier_drow_ranger_frost_arrows_custom_attack_cd = class({})
function modifier_drow_ranger_frost_arrows_custom_attack_cd:IsHidden() return false end
function modifier_drow_ranger_frost_arrows_custom_attack_cd:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_attack_cd:GetTexture() return "buffs/frost_cd" end
function modifier_drow_ranger_frost_arrows_custom_attack_cd:IsDebuff() return true end
function modifier_drow_ranger_frost_arrows_custom_attack_cd:RemoveOnDeath() return false end
function modifier_drow_ranger_frost_arrows_custom_attack_cd:OnCreated()
self.RemoveForDuel = true
end


modifier_drow_ranger_frost_arrows_custom_attack_damage = class({})
function modifier_drow_ranger_frost_arrows_custom_attack_damage:IsHidden() return true end
function modifier_drow_ranger_frost_arrows_custom_attack_damage:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_attack_damage:OnCreated()

self.damage = self:GetParent():GetTalentValue("modifier_drow_frost_4", "damage") - 100
end

function modifier_drow_ranger_frost_arrows_custom_attack_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_drow_ranger_frost_arrows_custom_attack_damage:GetModifierDamageOutgoing_Percentage()
return self.damage
end








modifier_drow_ranger_frost_arrows_custom_shield = class({})
function modifier_drow_ranger_frost_arrows_custom_shield:IsHidden() return false end
function modifier_drow_ranger_frost_arrows_custom_shield:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_shield:GetTexture() return "buffs/frost_shield" end
function modifier_drow_ranger_frost_arrows_custom_shield:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.shield_talent = "modifier_drow_frost_6"
self.max_shield = self.parent:GetTalentValue("modifier_drow_frost_6", "shield")*self.parent:GetMaxHealth()/100

if not IsServer() then return end

self.pfx = ParticleManager:CreateParticle("particles/drow_ranger/frost_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.pfx, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), false)
self:AddParticle(self.pfx,false, false, -1, false, false)

self.target = nil
self.parent:EmitSound("Drow.Frost_shield_start")
self:SetStackCount(self.max_shield)
end


function modifier_drow_ranger_frost_arrows_custom_shield:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_drow_ranger_frost_arrows_custom_shield:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() == 0 then return end

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


function modifier_drow_ranger_frost_arrows_custom_shield:OnDestroy()
if not IsServer() then return end 
self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_frost_arrows_custom_shield_cd", {duration = self.parent:GetTalentValue("modifier_drow_frost_6", "cd")})

self.parent:EmitSound("Drow.Frost_shield_end")
if self:GetStackCount() > 0 then return end 

self.parent:EmitSound("Drow.Frost_shield_end2")

local targets = self.parent:FindTargets(self.parent:GetTalentValue("modifier_drow_frost_6", "radius"))
local stun = self.parent:GetTalentValue("modifier_drow_frost_6", "stun")

if self.target and not self.target:IsNull() then
	table.insert(targets, self.target)
end

for _,target in pairs(targets) do 
	if not target:HasModifier("modifier_drow_ranger_frost_arrows_custom_shield_stun") then 
		target:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_frost_arrows_custom_shield_stun", {duration = (1 - target:GetStatusResistance())*stun})
	end
end


local pfx = ParticleManager:CreateParticle("particles/drow_ranger/frost_shield_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( pfx, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl( pfx, 1, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl( pfx, 2, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(pfx)

end


function modifier_drow_ranger_frost_arrows_custom_shield:GetStatusEffectName()
return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function modifier_drow_ranger_frost_arrows_custom_shield:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end




modifier_drow_ranger_frost_arrows_custom_shield_stun = class({})
function modifier_drow_ranger_frost_arrows_custom_shield_stun:IsHidden() return true end
function modifier_drow_ranger_frost_arrows_custom_shield_stun:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_shield_stun:IsStunDebuff() return true end
function modifier_drow_ranger_frost_arrows_custom_shield_stun:IsPurgeException() return true end

function modifier_drow_ranger_frost_arrows_custom_shield_stun:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end
function modifier_drow_ranger_frost_arrows_custom_shield_stun:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end
function modifier_drow_ranger_frost_arrows_custom_shield_stun:CheckState()
return
{
  [MODIFIER_STATE_FROZEN] = true,
  [MODIFIER_STATE_STUNNED] = true
}
end





modifier_drow_ranger_frost_arrows_custom_shield_cd = class({})
function modifier_drow_ranger_frost_arrows_custom_shield_cd:IsHidden() return false end
function modifier_drow_ranger_frost_arrows_custom_shield_cd:IsPurgable() return false end
function modifier_drow_ranger_frost_arrows_custom_shield_cd:RemoveOnDeath() return false end
function modifier_drow_ranger_frost_arrows_custom_shield_cd:IsDebuff() return true end
function modifier_drow_ranger_frost_arrows_custom_shield_cd:GetTexture() return "buffs/frost_shield" end