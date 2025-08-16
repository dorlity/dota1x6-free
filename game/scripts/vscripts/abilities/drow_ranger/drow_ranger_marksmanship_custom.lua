LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_tracker", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_agi_bonus", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_proc", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_proc_armor", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_legendary_field", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_legendary_blink", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_legendary_effect", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_shard", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_knock_cd", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_vision", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_movespeed", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_marksmanship_custom_leash", "abilities/drow_ranger/drow_ranger_marksmanship_custom", LUA_MODIFIER_MOTION_NONE )


drow_ranger_marksmanship_custom = class({})


function drow_ranger_marksmanship_custom:CreateTalent()

local ability = self:GetCaster():FindAbilityByName("drow_ranger_marksmanship_custom_legendary")
if ability then 
	ability:SetHidden(false)
end 

end


function drow_ranger_marksmanship_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_drow/drow_marksmanship.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_drow/drow_marksmanship_start.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/marksman_field.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/marksman_blink_start.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/marksman_blink_end.vpcf", context )
PrecacheResource( "particle", "particles/drow_ranger/shard_effect.vpcf", context )

end


function drow_ranger_marksmanship_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
    return "drow_ranger_marksmanship_arcana"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
    return "drow_ranger_marksmanship_arcana_alt1"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_ti9_immortal_weapon_custom") then
    return "drow_ranger_marksmanship_ti9"
end
if self:GetCaster():HasModifier("modifier_drow_eldwurm_head_custom") then
    return "drow_ranger/dragons_touch_ability_icons/drow_ranger_marksmanship"
end
return "drow_ranger_marksmanship"
end




function drow_ranger_marksmanship_custom:GetIntrinsicModifierName()
return "modifier_drow_ranger_marksmanship_custom_tracker"
end


function drow_ranger_marksmanship_custom:GetCastRange()
local radius = self:GetSpecialValueFor("disable_range")
return radius - self:GetCaster():GetCastRangeBonus()
end


function drow_ranger_marksmanship_custom:GetCooldown(iLevel)
if not self:GetCaster():HasScepter() then return end
return self:GetSpecialValueFor("scepter_cd")
end

function drow_ranger_marksmanship_custom:GetBehavior()
if self:GetCaster():HasScepter() then 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function drow_ranger_marksmanship_custom:GetCastAnimation()
if not self:GetCaster():HasScepter() then return end
return --ACT_DOTA_CAST_ABILITY_3
end


function drow_ranger_marksmanship_custom:GetProj()
local ulti_effect = "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
if self:GetCaster():HasModifier("modifier_drow_ranger_ti9_immortal_weapon_custom") then
  ulti_effect = "particles/econ/items/drow/drow_ti9_immortal/drow_ti9_marksman.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom") then
   ulti_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_attack.vpcf"
end
if self:GetCaster():HasModifier("modifier_drow_ranger_arcana_custom_v2") then
   ulti_effect = "particles/econ/items/drow/drow_arcana/drow_arcana_marksmanship_attack.vpcf"
end
return ulti_effect
end




function drow_ranger_marksmanship_custom:OnSpellStart()
local caster = self:GetCaster()

caster:EmitSound("Drow.Shard_active1")
caster:EmitSound("Drow.Shard_active2")

caster:AddNewModifier(caster, self, "modifier_drow_ranger_marksmanship_custom_shard", {duration = self:GetSpecialValueFor("scepter_duration")})
end




function drow_ranger_marksmanship_custom:GetDamage(target)
return self:GetSpecialValueFor("bonus_damage") + self:GetCaster():GetTalentValue("modifier_drow_marksman_4", "damage")*self:GetCaster():GetAgility()/100
end

function drow_ranger_marksmanship_custom:ApplyArmor(target)
if not IsServer() then return end
local caster = self:GetCaster()

if caster:HasModifier("modifier_drow_ranger_arcana_custom") or caster:HasModifier("modifier_drow_ranger_arcana_custom_v2") then
	local vec = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
	local mark_crit_arcana = ParticleManager:CreateParticle("particles/econ/items/drow/drow_arcana/drow_arcana_crit_or_marksmanship_proc_frost.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt( mark_crit_arcana, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
	ParticleManager:SetParticleControl( mark_crit_arcana, 1, target:GetOrigin())
	ParticleManager:SetParticleControlForward( mark_crit_arcana, 1, -vec )
	ParticleManager:ReleaseParticleIndex( mark_crit_arcana )
end

target:AddNewModifier(caster, self, "modifier_drow_ranger_marksmanship_custom_proc_armor", {duration = FrameTime()})
end


modifier_drow_ranger_marksmanship_custom_tracker = class({})
function modifier_drow_ranger_marksmanship_custom_tracker:IsHidden() return true end
function modifier_drow_ranger_marksmanship_custom_tracker:IsPurgable() return false end
function modifier_drow_ranger_marksmanship_custom_tracker:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.range = self.ability:GetSpecialValueFor("disable_range")
self.damage = self.ability:GetSpecialValueFor("bonus_damage")
self.chance = self.ability:GetSpecialValueFor("chance")

self.legendary_chance = self.parent:GetTalentValue("modifier_drow_marksman_7", "chance", true)
self.legendary_cd_inc = self.parent:GetTalentValue("modifier_drow_marksman_7", "cd_inc", true)
self.legendary_leash = self.parent:GetTalentValue("modifier_drow_marksman_7", "leash", true)

self.heal_creeps = self.parent:GetTalentValue("modifier_drow_marksman_2", "creeps", true)

self.cleave_radius = self.parent:GetTalentValue("modifier_drow_marksman_1", "radius", true)

self.agi_max = self.parent:GetTalentValue("modifier_drow_marksman_4", "max", true)
self.agi_duration = self.parent:GetTalentValue("modifier_drow_marksman_4", "duration", true)

self.range_bonus = self.parent:GetTalentValue("modifier_drow_marksman_5", "range", true)
self.vision_duration = self.parent:GetTalentValue("modifier_drow_marksman_5", "duration", true)
self.speed_duration = self.parent:GetTalentValue("modifier_drow_marksman_5", "speed_duration", true)

self.knock_cd = self.parent:GetTalentValue("modifier_drow_marksman_6", "cd", true)
self.knock_stun = self.parent:GetTalentValue("modifier_drow_marksman_6", "stun", true)
self.knockback_dist = self.parent:GetTalentValue("modifier_drow_marksman_6", "knock_distance", true)

self.shard_heal = self.ability:GetSpecialValueFor("scepter_heal")/100
self.shard_heal_creeps = self.ability:GetSpecialValueFor("scepter_heal_creeps")

self.PercentAgi = 0
self.records = {}
self.leash_table = {}

self.level = self.ability:GetLevel()

if not IsServer() then return end 

if self.parent:IsRealHero() then 
  	self.parent:AddRecordDestroyEvent(self)
 	self.parent:AddAttackRecordEvent_out(self)
	self.parent:AddDamageEvent_out(self)
	self.parent:AddAttackStartEvent_out(self)
end 

end


function modifier_drow_ranger_marksmanship_custom_tracker:OnRefresh(table)
self.range = self.ability:GetSpecialValueFor("disable_range")
self.damage = self.ability:GetSpecialValueFor("bonus_damage")
self.chance = self.ability:GetSpecialValueFor("chance")
end



function modifier_drow_ranger_marksmanship_custom_tracker:CheckState()
if not self.parent:HasModifier("modifier_drow_ranger_marksmanship_custom_proc") then return end 
return
{
	[MODIFIER_STATE_CANNOT_MISS] = true
}
end


function modifier_drow_ranger_marksmanship_custom_tracker:DeclareFunctions()
if not self:GetParent():IsRealHero() then 
	return
	{
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

return
{
	MODIFIER_PROPERTY_PROJECTILE_NAME,
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
  	MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
  	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end



function modifier_drow_ranger_marksmanship_custom_tracker:GetModifierCastRangeBonusStacking()
if not self.parent:HasTalent("modifier_drow_marksman_5") then return end 
return self.range_bonus
end

function modifier_drow_ranger_marksmanship_custom_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_drow_marksman_5") then return end 
return self.range_bonus
end

function modifier_drow_ranger_marksmanship_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end 
if not params.unit:IsUnit() then return end 
if self.parent ~= params.attacker then return end 

if self.parent:HasScepter() and self.parent:HasModifier("modifier_drow_ranger_marksmanship_custom_shard") and self.parent:CheckLifesteal(params) then 
	local heal = self.shard_heal*params.damage
	if params.unit:IsCreep() then 
		heal = heal / self.shard_heal_creeps
	end 
	self.parent:GenericHeal(heal, self.ability, false, "particles/drow_ranger/frost_heal.vpcf", "scepter")
end

if not params.record then return end
if not self.records[params.record] then return end 

if self.parent:HasTalent("modifier_drow_marksman_2") then
	local heal = params.damage*self.parent:GetTalentValue("modifier_drow_marksman_2", "heal")/100
	if params.unit:IsCreep() then 
		heal = heal / self.heal_creeps
	end 

	self.parent:GenericHeal(heal, self.ability, true, "particles/drow_ranger/frost_heal.vpcf", "modifier_drow_marksman_2")
end

if not self.parent:HasTalent("modifier_drow_marksman_1") then return end 

local damage = params.original_damage*self.parent:GetTalentValue("modifier_drow_marksman_1", "cleave")/100
for _,target in pairs(self.parent:FindTargets(self.cleave_radius, params.unit:GetAbsOrigin())) do
	if target ~= params.unit then 
		DoDamage({victim = target, attacker = self.parent, ability = self.ability, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK}, "modifier_drow_marksman_1")
	end 
end 

local particle = ParticleManager:CreateParticle("particles/drow_ranger/frost_cleave.vpcf", PATTACH_WORLDORIGIN, nil)	
ParticleManager:SetParticleControl(particle, 0, params.unit:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle)
end




function modifier_drow_ranger_marksmanship_custom_tracker:AttackRecordEvent_out(params)
if not IsServer() then return end 
if not params.target:IsUnit() then return end 
if self.parent ~= params.attacker then return end 


self.parent:RemoveModifierByName("modifier_drow_ranger_marksmanship_custom_proc")

if not self.parent:HasModifier("modifier_drow_ranger_innate_custom_active") then return end

local chance = self.chance + self.parent:GetTalentValue("modifier_drow_marksman_1", "chance")
if self.parent:HasModifier("modifier_drow_ranger_marksmanship_custom_legendary_effect") then 
	chance = chance + self.legendary_chance
end 

local proc = RollPseudoRandomPercentage(chance,4059,self.parent)

if not proc then return end 
self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_marksmanship_custom_proc", {})
end 




function modifier_drow_ranger_marksmanship_custom_tracker:AttackStartEvent_out(params)
if not IsServer() then return end 
if not params.target:IsUnit() then return end 
if self.parent ~= params.attacker then return end 

local leash_mod = self.parent:FindModifierByName("modifier_drow_ranger_marksmanship_custom_legendary_effect")
if leash_mod and not leash_mod.leashed then
	leash_mod.leashed = true
	self.leash_table[params.record]  = true
end

if not self.parent:HasModifier("modifier_drow_ranger_marksmanship_custom_proc") then return end

self.records[params.record] = true

if self.parent:HasModifier("modifier_drow_ranger_arcana_custom") or self.parent:HasModifier("modifier_drow_ranger_arcana_custom_v2") then 
	self.parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_SPECIAL, self.parent:GetAttackSpeed(true))
end 

if self.parent:HasTalent("modifier_drow_marksman_5") then
	self.parent:RemoveModifierByName("modifier_drow_ranger_marksmanship_custom_movespeed")
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_marksmanship_custom_movespeed", {duration = self.speed_duration})
end

if self.parent:HasTalent("modifier_drow_marksman_7") then 
	local ability = self.parent:FindAbilityByName("drow_ranger_marksmanship_custom_legendary")
	if ability then
		self.parent:CdAbility(ability, self.legendary_cd_inc)
	end
end 

if self.parent:GetQuest() == "Drow.Quest_8" and not self.parent:QuestCompleted() and params.target:IsRealHero() then 
	self.parent:UpdateQuest(1)
end 

self.parent:RemoveModifierByName("modifier_drow_ranger_marksmanship_custom_proc")
end




function modifier_drow_ranger_marksmanship_custom_tracker:GetModifierProcAttack_BonusDamage_Physical( params )
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end

local target = params.target

if self.parent:HasTalent("modifier_drow_marksman_4") and self.parent:HasModifier("modifier_drow_ranger_innate_custom_active") then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_marksmanship_custom_agi_bonus", {duration = self.agi_duration})
end 

if self.leash_table[params.record] then
	target:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_marksmanship_custom_leash", {duration = self.legendary_leash*(1 - target:GetStatusResistance())})
end

if self.parent:HasTalent("modifier_drow_marksman_6") and not target:IsCurrentlyHorizontalMotionControlled() and not target:IsCurrentlyVerticalMotionControlled()
	and not target:IsDebuffImmune() and not target:HasModifier("modifier_drow_ranger_marksmanship_custom_knock_cd") and self.records[params.record] then 

	local dist = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D()
	local knockback_dist = math.max(5, (1 - dist/800)*self.knockback_dist)

	local knockback = 
	{
		should_stun = 1,
		knockback_duration = self.knock_stun,
		duration = self.knock_stun,
		knockback_distance = knockback_dist,
		knockback_height = 0,
		center_x = self.parent:GetAbsOrigin().x,
		center_y = self.parent:GetAbsOrigin().y,
		center_z = self.parent:GetAbsOrigin().z,
	}

	target:EmitSound("Drow.Mark_knock")
	target:AddNewModifier(self.parent, self.ability, "modifier_knockback", knockback)
	target:AddNewModifier(self.parent, self.ability, "modifier_drow_ranger_marksmanship_custom_knock_cd", {duration = self.knock_cd})
end

if self.parent:HasTalent("modifier_drow_marksman_5") and target:IsRealHero() then 
	target:AddNewModifier(self.parent, self, "modifier_drow_ranger_marksmanship_custom_vision", {duration = self.vision_duration})
end

local k = 1

if self.parent:HasModifier("modifier_drow_ranger_frost_arrows_custom_attack_damage") then 
	if not self.parent:HasModifier("modifier_drow_ranger_innate_custom_active") then 
		return 
	end
	if not RollPseudoRandomPercentage(self.chance,4059,self.parent) then 
		return
	end 

	k = self.parent:GetTalentValue("modifier_drow_frost_4", "damage")/100
else 
	if not self.records[params.record] then 
		return
	end
end 

self.ability:ApplyArmor(params.target)
return self.ability:GetDamage(params.target)*k
end


function modifier_drow_ranger_marksmanship_custom_tracker:RecordDestroyEvent( params )
self.records[params.record] = nil
self.leash_table[params.record] = nil
end


function modifier_drow_ranger_marksmanship_custom_tracker:GetModifierProjectileName()
if not self.parent:HasModifier("modifier_drow_ranger_frost_arrows_custom_tracker") and self.parent:HasModifier("modifier_drow_ranger_marksmanship_custom_proc") then  
	return "particles/units/heroes/hero_drow/drow_marksmanship_attack.vpcf"
end

end


modifier_drow_ranger_marksmanship_custom_agi_bonus = class({})
function modifier_drow_ranger_marksmanship_custom_agi_bonus:IsHidden() return false end
function modifier_drow_ranger_marksmanship_custom_agi_bonus:IsPurgable() return false end
function modifier_drow_ranger_marksmanship_custom_agi_bonus:GetTexture() return "buffs/marksman_agi" end
function modifier_drow_ranger_marksmanship_custom_agi_bonus:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_drow_marksman_4", "max")
self.agi = self.parent:GetTalentValue("modifier_drow_marksman_4", "agility")/100

if not IsServer() then return end
self:SetStackCount(1)
self.PercentAgi = self.agi*self:GetStackCount()
end

function modifier_drow_ranger_marksmanship_custom_agi_bonus:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

self.PercentAgi = self.agi*self:GetStackCount()
end

function modifier_drow_ranger_marksmanship_custom_agi_bonus:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_drow_ranger_marksmanship_custom_agi_bonus:OnTooltip()
return self.agi*100*self:GetStackCount()
end

function modifier_drow_ranger_marksmanship_custom_agi_bonus:OnDestroy()
if not IsServer() then return end
self.parent:PercentRefresh()
end



modifier_drow_ranger_marksmanship_custom_proc = class({})
function modifier_drow_ranger_marksmanship_custom_proc:IsHidden() return true end
function modifier_drow_ranger_marksmanship_custom_proc:IsPurgable() return false end



modifier_drow_ranger_marksmanship_custom_proc_armor = class({})
function modifier_drow_ranger_marksmanship_custom_proc_armor:IsHidden() return true end
function modifier_drow_ranger_marksmanship_custom_proc_armor:IsPurgable() return false end
function modifier_drow_ranger_marksmanship_custom_proc_armor:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.armor = self.parent:GetPhysicalArmorBaseValue()*-1
end

function modifier_drow_ranger_marksmanship_custom_proc_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_drow_ranger_marksmanship_custom_proc_armor:GetModifierPhysicalArmorBonus()
return self.armor
end





modifier_drow_ranger_marksmanship_custom_shard = class({})
function modifier_drow_ranger_marksmanship_custom_shard:IsHidden() return false end
function modifier_drow_ranger_marksmanship_custom_shard:IsPurgable() return false end
function modifier_drow_ranger_marksmanship_custom_shard:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end

self.RemoveForDuel = true

self.ground_particle = ParticleManager:CreateParticle("particles/drow_ranger/shard_effect.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt(self.ground_particle, 0, self.parent, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.ground_particle, 5, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(self.ground_particle, false, false, -1, true, false)
end


function modifier_drow_ranger_marksmanship_custom_shard:GetStatusEffectName()
return "particles/econ/items/drow/drow_ti9_immortal/status_effect_drow_ti9_frost_arrow.vpcf"
end

function modifier_drow_ranger_marksmanship_custom_shard:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end




drow_ranger_marksmanship_custom_legendary = class({})


function drow_ranger_marksmanship_custom_legendary:GetCastRange(vLocation, hTarget)
if IsServer() then 
	return 999999
else 
	return self:GetSpecialValueFor("range")
end

end

function drow_ranger_marksmanship_custom_legendary:GetAOERadius()
if not self:GetCaster():HasTalent("modifier_drow_marksman_7") then return end 
return self:GetSpecialValueFor("radius")
end



function drow_ranger_marksmanship_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
if not caster:HasTalent("modifier_drow_marksman_7") then return end


local point = self:GetCursorPosition()
local origin = caster:GetAbsOrigin()
local dir = point - origin
local vec = dir:Normalized()
vec.z = 0

local range = self:GetSpecialValueFor("range")  + caster:GetCastRangeBonus()

if dir:Length2D() >= range then 
	point = origin + vec*range
end 

caster:AddNewModifier(caster, self, "modifier_drow_ranger_marksmanship_custom_legendary_blink", {duration = 0.2, x = point.x, y = point.y})

end






modifier_drow_ranger_marksmanship_custom_legendary_blink = class({})
function modifier_drow_ranger_marksmanship_custom_legendary_blink:IsHidden() return true end
function modifier_drow_ranger_marksmanship_custom_legendary_blink:IsPurgable() return false end
function modifier_drow_ranger_marksmanship_custom_legendary_blink:OnCreated(table)
if not IsServer() then return end 
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.point = GetGroundPosition(Vector(table.x, table.y, 0), nil)
self.parent:NoDraw(self)
self.parent:AddNoDraw()

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Lina.Array_blink", self.parent)

local effect_end = ParticleManager:CreateParticle("particles/drow_ranger/marksman_blink_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect_end, 0, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(effect_end)

ProjectileManager:ProjectileDodge(self.parent)

self.parent:SetAbsOrigin(self.point)
FindClearSpaceForUnit(self.parent, self.point, false)

CreateModifierThinker(self.parent, self.ability, "modifier_drow_ranger_marksmanship_custom_legendary_field", {duration = self.ability:GetSpecialValueFor("duration")}, self.point, self.parent:GetTeamNumber(), false)

end 


function modifier_drow_ranger_marksmanship_custom_legendary_blink:CheckState()
return
{
  [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
  [MODIFIER_STATE_STUNNED] = true
}
end

function modifier_drow_ranger_marksmanship_custom_legendary_blink:OnDestroy()
if not IsServer() then return end 


self.parent:StartGesture(ACT_DOTA_TELEPORT_END)

local effect_end = ParticleManager:CreateParticle("particles/drow_ranger/marksman_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( effect_end, 0, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(effect_end)

self.parent:Stop()
self.parent:RemoveNoDraw()
end 






modifier_drow_ranger_marksmanship_custom_legendary_field = class({})
function modifier_drow_ranger_marksmanship_custom_legendary_field:IsHidden() return true end
function modifier_drow_ranger_marksmanship_custom_legendary_field:IsPurgable() return false end
function modifier_drow_ranger_marksmanship_custom_legendary_field:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")

if not IsServer() then return end

self.parent:EmitSound("Drow.Mark_legendary_lp")
EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Drow.Mark_legendary", self.caster)

local effect_cast = ParticleManager:CreateParticle( "particles/drow_ranger/marksman_field.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self:GetRemainingTime(), 1 ) )
self:AddParticle( effect_cast, false, false, -1, false, false )
end


function modifier_drow_ranger_marksmanship_custom_legendary_field:OnDestroy()
if not IsServer() then return end

self.parent:StopSound("Drow.Mark_legendary_lp")
EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(), "Drow.Mark_legendary_end", self.caster)
end


function modifier_drow_ranger_marksmanship_custom_legendary_field:IsAura() return true end
function modifier_drow_ranger_marksmanship_custom_legendary_field:GetAuraDuration() return 0.1 end
function modifier_drow_ranger_marksmanship_custom_legendary_field:GetAuraRadius() return self.radius end
function modifier_drow_ranger_marksmanship_custom_legendary_field:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_drow_ranger_marksmanship_custom_legendary_field:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_drow_ranger_marksmanship_custom_legendary_field:GetModifierAura() return "modifier_drow_ranger_marksmanship_custom_legendary_effect" end


modifier_drow_ranger_marksmanship_custom_legendary_effect = class({})
function modifier_drow_ranger_marksmanship_custom_legendary_effect:IsHidden() return true end
function modifier_drow_ranger_marksmanship_custom_legendary_effect:IsPurgable() return false end
function modifier_drow_ranger_marksmanship_custom_legendary_effect:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.range = self.caster:GetTalentValue("modifier_drow_marksman_7", "attack_range")
end

function modifier_drow_ranger_marksmanship_custom_legendary_effect:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_drow_ranger_marksmanship_custom_legendary_effect:GetModifierAttackRangeBonus()
return self.range
end




modifier_drow_ranger_marksmanship_custom_knock_cd = class({})
function modifier_drow_ranger_marksmanship_custom_knock_cd:IsHidden() return true end
function modifier_drow_ranger_marksmanship_custom_knock_cd:IsPurgable() return false end




modifier_drow_ranger_marksmanship_custom_vision = class({})
function modifier_drow_ranger_marksmanship_custom_vision:IsHidden() return false end
function modifier_drow_ranger_marksmanship_custom_vision:IsPurgable() return false end
function modifier_drow_ranger_marksmanship_custom_vision:GetTexture() return "buffs/marksman_vision" end
function modifier_drow_ranger_marksmanship_custom_vision:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.team = self.caster:GetTeamNumber()

if not IsServer() then return end
self:OnIntervalThink() 
self:StartIntervalThink(0.2)
end

function modifier_drow_ranger_marksmanship_custom_vision:OnIntervalThink()
if not IsServer() then return end 
AddFOWViewer(self.team, self.parent:GetAbsOrigin(), 10, 0.25, false)
end



modifier_drow_ranger_marksmanship_custom_movespeed = class({})
function modifier_drow_ranger_marksmanship_custom_movespeed:IsHidden() return false end
function modifier_drow_ranger_marksmanship_custom_movespeed:IsPurgable() return false end
function modifier_drow_ranger_marksmanship_custom_movespeed:GetTexture() return "buffs/marksman_vision" end
function modifier_drow_ranger_marksmanship_custom_movespeed:OnCreated()
self.parent = self:GetParent()
self.speed = self.parent:GetTalentValue("modifier_drow_marksman_5", "speed")
if not IsServer() then return end

self.parent:GenericParticle("particles/zuus_speed.vpcf", self)
end

function modifier_drow_ranger_marksmanship_custom_movespeed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_drow_ranger_marksmanship_custom_movespeed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end


modifier_drow_ranger_marksmanship_custom_leash = class({})
function modifier_drow_ranger_marksmanship_custom_leash:IsHidden() return true end
function modifier_drow_ranger_marksmanship_custom_leash:IsPurgable() return true end
function modifier_drow_ranger_marksmanship_custom_leash:CheckState()
return
{
	[MODIFIER_STATE_TETHERED] = true
}
end