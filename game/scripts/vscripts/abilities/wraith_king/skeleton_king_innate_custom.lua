LinkLuaModifier( "modifier_skeleton_king_innate_custom", "abilities/wraith_king/skeleton_king_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_innate_custom_ghost", "abilities/wraith_king/skeleton_king_innate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_innate_custom_cd", "abilities/wraith_king/skeleton_king_innate_custom", LUA_MODIFIER_MOTION_NONE )




skeleton_king_innate_custom = class({})


function skeleton_king_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/wraith_king_curse_overhead.vpcf", context )
PrecacheResource( "particle","particles/wraith_king_custom/wraith_king_ambient_custom.vpcf", context )

PrecacheResource( "soundfile", "soundevents/vo_custom/skeleton_king_vo_custom.vsndevts", context ) 
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_skeleton_king.vsndevts", context )
end


function skeleton_king_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_skeleton_king_innate_custom"
end

modifier_skeleton_king_innate_custom = class({})
function modifier_skeleton_king_innate_custom:IsHidden() return true end
function modifier_skeleton_king_innate_custom:IsPurgable() return false end
function modifier_skeleton_king_innate_custom:RemoveOnDeath() return false end
function modifier_skeleton_king_innate_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:AddDamageEvent_out(self, true)
self.parent:AddDamageEvent_inc(self, true)

self.heal = self.ability:GetSpecialValueFor("heal")/100
self.creeps = 1 - self.ability:GetSpecialValueFor("creeps")/100
self.duration = self.ability:GetSpecialValueFor("duration")

self.scepter_duration = self.ability:GetSpecialValueFor("scepter_duration")

self.more_heal = 0

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_skeleton_king_innate_custom:OnRefresh(table)
self:OnCreated()
end


function modifier_skeleton_king_innate_custom:UpdateTalent(name)
self.range_bonus = self.parent:GetTalentValue("modifier_skeleton_hero_1", "range")

self.more_heal = self.parent:GetTalentValue("modifier_skeleton_hero_3", "heal")/100
if not IsServer() then return end
self:SendBuffRefreshToClients()
end


function modifier_skeleton_king_innate_custom:AddCustomTransmitterData() 
return 
{
    range_bonus = self.range_bonus,
} 
end

function modifier_skeleton_king_innate_custom:HandleCustomTransmitterData(data)
self.range_bonus = data.range_bonus
end


function modifier_skeleton_king_innate_custom:DamageEvent_inc(params)
if not IsServer() then return end

if self.parent == params.unit and not self.parent:HasModifier("modifier_death") and self.parent:GetHealth() <= 5 and not self.parent:HasModifier("modifier_skeleton_king_innate_custom_ghost")
	and not self.parent:HasModifier("modifier_skeleton_king_innate_custom_cd") and params.attacker and not params.attacker:IsNull() then

	local duration = self.duration
	if self.parent:HasScepter() then
		duration = duration + self.scepter_duration
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {effect = 2, duration = duration, magic_damage = 0})
	end

	self.parent:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_innate_custom_ghost", {duration = duration, attacker = params.attacker:entindex()})
end

end


function modifier_skeleton_king_innate_custom:DamageEvent_out(params)
if not IsServer() then return end
if self.parent == params.unit then return end
if not params.unit:IsUnit() then return end
if self.parent:PassivesDisabled() then return end
if params.unit:IsIllusion() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local attacker = params.attacker

local is_skelet = false

if attacker.owner and attacker.owner == self.parent and attacker:HasModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai") then 
	is_skelet = true
end

if is_skelet == false and attacker ~= self.parent then return end

local base_heal = self.heal
local more_heal = self.more_heal

if params.unit:IsCreep() then 
	base_heal = base_heal*self.creeps
	more_heal = more_heal*self.creeps
end

if is_skelet == true then 
	self:DoHeal(attacker, (base_heal + more_heal)*params.damage)
	if self.parent:HasTalent("modifier_skeleton_hero_3") then 
		self:DoHeal(self.parent, params.damage*more_heal)
	end 
else 
	local heal = 0 

	if params.inflictor == nil then 
		heal = (base_heal + more_heal)*params.damage 
	else 
		heal = (more_heal)*params.damage 
	end 
	self:DoHeal(attacker, heal)
end 

end 


function modifier_skeleton_king_innate_custom:DoHeal(unit, heal)
if not IsServer() then return end
if not heal then return end
if heal < 1 then return end

unit:GenericHeal(heal, self.ability, true, "")

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
ParticleManager:SetParticleControlEnt(effect_cast, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex( effect_cast )
end 


function modifier_skeleton_king_innate_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MIN_HEALTH,
  	MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
}
end


function modifier_skeleton_king_innate_custom:GetModifierCastRangeBonusStacking()
return self.range_bonus
end


function modifier_skeleton_king_innate_custom:GetMinHealth()
if not self.parent:IsAlive() then return end
if self.parent:LethalDisabled() then return end
if self.parent:HasModifier("modifier_skeleton_king_innate_custom_cd") then return end
return 1
end


modifier_skeleton_king_innate_custom_ghost = class({})
function modifier_skeleton_king_innate_custom_ghost:IsHidden() return false end
function modifier_skeleton_king_innate_custom_ghost:IsPurgable() return false end
function modifier_skeleton_king_innate_custom_ghost:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.speed = self.ability:GetSpecialValueFor("speed")
self.move = self.ability:GetSpecialValueFor("move")

self.scepter_damage = self.ability:GetSpecialValueFor("scepter_damage")
self.scepter_move = self.ability:GetSpecialValueFor("scepter_move")

if not IsServer() then return end 
self.RemoveForDuel = true
self.parent:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")

if table.attacker then 
	self.attacker = EntIndexToHScript(table.attacker)
end
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
self:AddParticle(effect_cast, false, false, -1, false, false) 

self:StartIntervalThink(self:GetRemainingTime() - 3)
end

function modifier_skeleton_king_innate_custom_ghost:OnIntervalThink()
if not IsServer() then return end
self.parent:GenericParticle("particles/units/heroes/hero_skeletonking/wraith_king_curse_overhead.vpcf", self, true)
self:StartIntervalThink(-1)
end


function modifier_skeleton_king_innate_custom_ghost:OnDestroy()
if not IsServer() then return end 
if self:GetRemainingTime() > 0.1 then return end 

self.parent:AddNewModifier(self.parent, nil, "modifier_skeleton_king_innate_custom_cd", {duration = 0.1})
self.parent:Kill(self.ability, self.attacker)
end


function modifier_skeleton_king_innate_custom_ghost:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_DISABLE_HEALING,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_skeleton_king_innate_custom_ghost:GetModifierDamageOutgoing_Percentage()
if not self.parent:HasScepter() then return end
return self.scepter_damage
end

function modifier_skeleton_king_innate_custom_ghost:GetModifierSpellAmplify_Percentage()
if not self.parent:HasScepter() then return end
return self.scepter_damage
end

function modifier_skeleton_king_innate_custom_ghost:GetModifierMoveSpeed_Absolute()
if not self.parent:HasScepter() then return end
return self.scepter_move
end

function modifier_skeleton_king_innate_custom_ghost:GetModifierModelScale()
return 25
end

function modifier_skeleton_king_innate_custom_ghost:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_skeleton_king_innate_custom_ghost:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_skeleton_king_innate_custom_ghost:GetDisableHealing()
return 1
end

function modifier_skeleton_king_innate_custom_ghost:GetStatusEffectName()
return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end

function modifier_skeleton_king_innate_custom_ghost:StatusEffectPriority()
return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_skeleton_king_innate_custom_ghost:CheckState()
return
{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
}
end




modifier_skeleton_king_innate_custom_cd = class({})
function modifier_skeleton_king_innate_custom_cd:IsHidden() return true end
function modifier_skeleton_king_innate_custom_cd:IsPurgable() return false end