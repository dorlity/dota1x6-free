LinkLuaModifier( "modifier_centaur_innate_custom", "abilities/centaur/centaur_innate_custom", LUA_MODIFIER_MOTION_NONE )


centaur_innate_custom = class({})

function centaur_innate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_centaur_innate_custom"
end

function centaur_innate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "soundfile", "soundevents/npc_dota_hero_centaur.vsndevts", context )
dota1x6:PrecacheShopItems("npc_dota_hero_centaur", context)
end


modifier_centaur_innate_custom = class({})
function modifier_centaur_innate_custom:IsHidden() return false end
function modifier_centaur_innate_custom:IsPurgable() return false end
function modifier_centaur_innate_custom:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.timer = self.ability:GetSpecialValueFor("upgrade_rate")
self.scepter_timer = self.ability:GetSpecialValueFor("scepter_rate")
self.str = self.ability:GetSpecialValueFor("str")
self.range_bonus = self.ability:GetSpecialValueFor("attack_range")

self.scepter_move = self.ability:GetSpecialValueFor("scepter_move")/100
self.scepter_move_max = self.ability:GetSpecialValueFor("scepter_move_max")

self.init = false

if not IsServer() then return end
self:StartIntervalThink(0.1)
end

function modifier_centaur_innate_custom:OnIntervalThink()
if not IsServer() then return end
if GameRules:GetDOTATime(false, false) <= 0 then
	self.init = false
	self:StartIntervalThink(0.1)
	return
end

if self.init == true then
	self:IncrementStackCount()
	self.parent:CalculateStatBonus(true)
end

self.init = true
local timer = self.timer
if self.parent:HasScepter() then
	timer = self.scepter_timer
end

self:StartIntervalThink(timer)
end

function modifier_centaur_innate_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_MAX,
	MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE 
}
end

function modifier_centaur_innate_custom:GetModifierAttackRangeBonus()
return self.range_bonus
end

function modifier_centaur_innate_custom:GetModifierBonusStats_Strength()
return self:GetStackCount()*self.str
end

function modifier_centaur_innate_custom:GetModifierMoveSpeedBonus_Special_Boots()
if not self.parent:HasScepter() then return end
return self.scepter_move*self.parent:GetStrength()
end

function modifier_centaur_innate_custom:GetModifierMoveSpeed_Max( params )
if not self.parent:HasScepter() then return end
if self.parent:HasModifier("modifier_centaur_stampede_custom") then
  return 999999
end
return self.scepter_move_max
end

function modifier_centaur_innate_custom:GetModifierMoveSpeed_Limit( params )
if not self.parent:HasScepter() then return end
if self.parent:HasModifier("modifier_centaur_stampede_custom") then
  return 999999
end
return self.scepter_move_max
end

function modifier_centaur_innate_custom:GetModifierIgnoreMovespeedLimit( params )
if not self.parent:HasScepter() then return end
return 1
end