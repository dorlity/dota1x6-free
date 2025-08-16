LinkLuaModifier( "modifier_life_stealer_unfettered_custom", "abilities/life_stealer/life_stealer_unfettered_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_unfettered_custom_rooted", "abilities/life_stealer/life_stealer_unfettered_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_life_stealer_unfettered_custom_tracker", "abilities/life_stealer/life_stealer_unfettered_custom", LUA_MODIFIER_MOTION_NONE )


life_stealer_unfettered_custom = class({})


function life_stealer_unfettered_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/queen_of_pain/blink_root.vpcf", context )
PrecacheResource( "particle", "particles/slark/pounce_legendary_ui.vpcf", context )
end

function life_stealer_unfettered_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsCreepHero() then return end
return "modifier_life_stealer_unfettered_custom_tracker"
end

function life_stealer_unfettered_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
local min_dist = self:GetSpecialValueFor("min_dist")
if (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= min_dist then
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetId()), "CreateIngameErrorMessage", {message = "#close_dist"})
	return false
end
return true
end

function life_stealer_unfettered_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end

caster:EmitSound("Lifestealer.Shard_cast")
caster:EmitSound("Lifestealer.Shard_cast2")
caster:AddNewModifier(caster, self, "modifier_life_stealer_unfettered_custom", {target = target:entindex()})
end



modifier_life_stealer_unfettered_custom = class(mod_hidden)
function modifier_life_stealer_unfettered_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.speed = self.ability:GetSpecialValueFor("speed")
self.root = self.ability:GetSpecialValueFor("root")

if not IsServer() then return end
self.target = EntIndexToHScript(table.target)
self.parent:GenericParticle("particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf", self)

if self.parent:HasModifier("modifier_life_stealer_infest_custom_legendary_creep") then
	self.parent:StartGestureWithPlaybackRate(ACT_DOTA_RUN, 2)
end

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_life_stealer_unfettered_custom:GetStatusEffectName()
return "particles/econ/items/invoker/invoker_ti7/status_effect_alacrity_ti7.vpcf"
end

function modifier_life_stealer_unfettered_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_life_stealer_unfettered_custom:OnIntervalThink()
if not IsServer() then return end

if not self.target or self.target:IsNull() or not self.target:IsAlive() then
	self:Destroy()
	return
end

self.parent:MoveToPositionAggressive(self.target:GetAbsOrigin())
self.parent:MoveToPosition(self.target:GetAbsOrigin())

if self.parent:IsHexed() or self.parent:IsStunned() or self.parent:IsFeared() or self.parent:IsRooted() or self.parent:IsInvulnerable()
	or self.parent:IsCurrentlyHorizontalMotionControlled() or self.parent:IsCurrentlyVerticalMotionControlled() then
	self:Destroy()
	return
end

local length = (self.parent:GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D()

if length > 2000 then
	self:Destroy()
	return
end

if length <= 200 then
	self.parent:MoveToTargetToAttack(self.target)
	self.proc_root = true
	self:Destroy()
	return
end

end

function modifier_life_stealer_unfettered_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
}
end

function modifier_life_stealer_unfettered_custom:GetModifierPercentageCasttime()
return 100
end

function modifier_life_stealer_unfettered_custom:GetModifierIgnoreCastAngle()
return 1
end

function modifier_life_stealer_unfettered_custom:GetModifierMoveSpeed_Absolute()
return self.speed
end

function modifier_life_stealer_unfettered_custom:GetActivityTranslationModifiers()
return "haste"
end

function modifier_life_stealer_unfettered_custom:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
}
end

function modifier_life_stealer_unfettered_custom:OnDestroy()
if not IsServer() then return end
self.parent:RemoveGesture(ACT_DOTA_RUN)

if not self.target or self.target:IsNull() or not self.target:IsAlive() then return end
if not self.proc_root then return end

self.target:EmitSound("Lifestealer.Shard_target")
self.target:AddNewModifier(self.parent, self.ability, "modifier_life_stealer_unfettered_custom_rooted", {duration = self.root*(1 - self.target:GetStatusResistance())})
end




modifier_life_stealer_unfettered_custom_rooted = class(mod_hidden)
function modifier_life_stealer_unfettered_custom_rooted:IsPurgable() return true end
function modifier_life_stealer_unfettered_custom_rooted:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:GenericParticle("particles/items2_fx/sange_maim.vpcf", self)
self.parent:GenericParticle("particles/queen_of_pain/blink_root.vpcf", self)
end

function modifier_life_stealer_unfettered_custom_rooted:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end

function modifier_life_stealer_unfettered_custom_rooted:GetStatusEffectName()
return "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf"
end

function modifier_life_stealer_unfettered_custom_rooted:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH
end




modifier_life_stealer_unfettered_custom_tracker = class(mod_hidden)
function modifier_life_stealer_unfettered_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "ability_lifestealer_unfettered",  {})
end


function modifier_life_stealer_unfettered_custom_tracker:OnRefresh()
self:OnCreated()
end
