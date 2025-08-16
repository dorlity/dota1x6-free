LinkLuaModifier("modifier_slark_shadow_dance_custom", "abilities/slark/slark_shadow_dance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_shadow_dance_custom_effect", "abilities/slark/slark_shadow_dance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_shadow_dance_custom_dummy", "abilities/slark/slark_shadow_dance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_shadow_dance_custom_legendary", "abilities/slark/slark_shadow_dance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_shadow_dance_custom_tracker", "abilities/slark/slark_shadow_dance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_slark_shadow_dance_custom_burn", "abilities/slark/slark_shadow_dance_custom", LUA_MODIFIER_MOTION_NONE)


slark_shadow_dance_custom = class({})


function slark_shadow_dance_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", context )
PrecacheResource( "particle","particles/slark/dance_legendary.vpcf", context )
PrecacheResource( "particle","particles/slark/dance_burn.vpcf", context )
PrecacheResource( "particle","particles/slark/dance_lifesteal.vpcf", context )
PrecacheResource( "particle","particles/void_spirit/void_mark_hit.vpcf", context )
end


function slark_shadow_dance_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_slark_shadow_dance_custom_tracker"
end

function slark_shadow_dance_custom:GetCooldown(iLevel)
local bonus = 0 
if self:GetCaster():HasTalent("modifier_slark_dance_3") then 
	bonus = self:GetCaster():GetTalentValue("modifier_slark_dance_3", "cd")
end
return (self.BaseClass.GetCooldown(self, iLevel) + bonus)
end

function slark_shadow_dance_custom:GetManaCost(level)
if self:GetCaster():HasTalent("modifier_slark_dance_6") then 
  return 0 
end 
return self.BaseClass.GetManaCost(self,level)
end

function slark_shadow_dance_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_slark_dance_3", "duration")

caster:RemoveModifierByName("modifier_slark_innate_custom_creeps")
caster:AddNewModifier(caster, self, "modifier_slark_shadow_dance_custom", {duration = duration})
end



modifier_slark_shadow_dance_custom = class({})
function modifier_slark_shadow_dance_custom:IsHidden() return false end
function modifier_slark_shadow_dance_custom:IsPurgable() return false end

function modifier_slark_shadow_dance_custom:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end
self.parent:EmitSound("Hero_Slark.ShadowDance")

self.ability:EndCd()

if self.parent:GetAttackTarget() ~= nil then
	self.parent:MoveToTargetToAttack(self.parent:GetAttackTarget())
end

self.cd_stack = 0

self.dummy = CreateUnitByName("npc_dota_companion", self.parent:GetAbsOrigin(), false, nil, nil, self.parent:GetTeamNumber())
self.dummy:AddNewModifier(self.dummy, self.ability, "modifier_slark_shadow_dance_custom_dummy", {})

local effect_cast = ParticleManager:CreateParticleForTeam( "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetTeamNumber() )
ParticleManager:SetParticleControlEnt( effect_cast, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( effect_cast, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_eyeR", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( effect_cast, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_eyeL", Vector(0,0,0), true )
self:AddParticle( effect_cast, false, false, -1, false, false )

self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.dummy  )
ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self.dummy, PATTACH_ABSORIGIN_FOLLOW, nil, self.dummy:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.effect_cast, 1, self.dummy, PATTACH_ABSORIGIN_FOLLOW, nil, self.dummy:GetAbsOrigin(), true )
self:AddParticle( self.effect_cast, false, false, -1, false,  false )

self:StartIntervalThink(0.01)
end


function modifier_slark_shadow_dance_custom:OnDestroy( kv )
if not IsServer() then return end
if self.dummy and not self.dummy:IsNull() then
	UTIL_Remove(self.dummy)
end

self.ability:StartCd()

if self.cd_stack <= 0 then return end

local cd = self.cd_stack*self.ability:GetEffectiveCooldown(self.ability:GetLevel())*self.parent:GetTalentValue("modifier_slark_dance_7", "cd_inc", true)/100
self.parent:CdAbility(self.ability, cd)
end

function modifier_slark_shadow_dance_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
}
end

function modifier_slark_shadow_dance_custom:GetModifierInvisibilityLevel()
return 1
end

function modifier_slark_shadow_dance_custom:GetActivityTranslationModifiers()
return "shadow_dance"
end

function modifier_slark_shadow_dance_custom:GetPriority()
return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_slark_shadow_dance_custom:CheckState()
return 
{
	[MODIFIER_STATE_INVISIBLE] = true,
	[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
}
end


function modifier_slark_shadow_dance_custom:OnIntervalThink()
if not IsServer() then return end

if self.dummy and not self.dummy:IsNull() then
	self.dummy:SetForwardVector(self.parent:GetForwardVector())
	self.dummy:FaceTowards(self.parent:GetAbsOrigin() + self.parent:GetForwardVector()*10)
	self.dummy:SetAbsOrigin(self.parent:GetAbsOrigin())
end

end

function modifier_slark_shadow_dance_custom:GetStatusEffectName()
return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

function modifier_slark_shadow_dance_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_slark_shadow_dance_custom:IsAura() return true end
function modifier_slark_shadow_dance_custom:GetAuraDuration() return 0 end
function modifier_slark_shadow_dance_custom:GetAuraRadius() return 200 end
function modifier_slark_shadow_dance_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_slark_shadow_dance_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_slark_shadow_dance_custom:GetModifierAura() return "modifier_slark_shadow_dance_custom_effect" end
function modifier_slark_shadow_dance_custom:GetAuraEntityReject(hEntity)
return hEntity ~= self.parent
end



modifier_slark_shadow_dance_custom_dummy = class({})
function modifier_slark_shadow_dance_custom_dummy:IsHidden() return true end
function modifier_slark_shadow_dance_custom_dummy:IsPurgable() return false end
function modifier_slark_shadow_dance_custom_dummy:CheckState()
return 
{
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
}
end





modifier_slark_shadow_dance_custom_tracker = class({})
function modifier_slark_shadow_dance_custom_tracker:IsHidden() return true end
function modifier_slark_shadow_dance_custom_tracker:IsPurgable() return false end
function modifier_slark_shadow_dance_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.legendary_cd = self.parent:GetTalentValue("modifier_slark_dance_7", "cd_inc", true)/100

self.burn_duration = self.parent:GetTalentValue("modifier_slark_dance_4", "duration", true)

self.speed_bonus = self.parent:GetTalentValue("modifier_slark_dance_1", "bonus", true)

self.max_move = self.parent:GetTalentValue("modifier_slark_dance_5", "speed_limit", true)

self.cdr = self.parent:GetTalentValue("modifier_slark_dance_6", "cdr", true)

self.parent:AddAttackEvent_out(self)
end

function modifier_slark_shadow_dance_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

if self.parent:HasTalent("modifier_slark_dance_4") then
	params.target:AddNewModifier(self.parent, self.ability, "modifier_slark_shadow_dance_custom_burn", {duration = self.burn_duration})
end

if not self.parent:HasModifier("modifier_slark_shadow_dance_custom_effect") then return end

local ulti = self.parent:FindModifierByName("modifier_slark_shadow_dance_custom")

if self.parent:HasTalent("modifier_slark_dance_5") then

	local unit = self.parent
	if ulti and ulti.dummy then
		unit = ulti.dummy
	end

	for i = 1,2 do
		local particle = ParticleManager:CreateParticle( "particles/void_spirit/void_mark_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW,  unit )
		ParticleManager:SetParticleControlEnt( particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
		ParticleManager:DestroyParticle(particle, false)
		ParticleManager:ReleaseParticleIndex( particle )
	end 
end

if not self.parent:HasTalent("modifier_slark_dance_7") then return end

if ulti then
	ulti.cd_stack = ulti.cd_stack + 1
	return
end

local cd = self.ability:GetEffectiveCooldown(self.ability:GetLevel())*self.legendary_cd
self.parent:CdAbility(self.ability, cd)
end

function modifier_slark_shadow_dance_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_LIMIT,
  MODIFIER_PROPERTY_MOVESPEED_MAX,
  MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
  MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_slark_shadow_dance_custom_tracker:GetModifierPercentageCooldown() 
if not self.parent:HasTalent("modifier_slark_dance_6") then return end
return self.cdr
end
function modifier_slark_shadow_dance_custom_tracker:GetModifierIgnoreMovespeedLimit()
if not self.parent:HasTalent("modifier_slark_dance_5") then return 0 end
return 1
end

function modifier_slark_shadow_dance_custom_tracker:GetModifierMoveSpeed_Max()
if not self.parent:HasTalent("modifier_slark_dance_5") then return end
return self.max_move
end

function modifier_slark_shadow_dance_custom_tracker:GetModifierMoveSpeed_Limit()
if not self.parent:HasTalent("modifier_slark_dance_5") then return end
return self.max_move
end

function modifier_slark_shadow_dance_custom_tracker:GetModifierAttackSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_slark_dance_1") then return end
local bonus = self.parent:GetTalentValue("modifier_slark_dance_1", "attack")
if self.parent:HasModifier("modifier_slark_shadow_dance_custom_effect") then
	bonus = self.speed_bonus*bonus
end
return bonus
end

function modifier_slark_shadow_dance_custom_tracker:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_slark_dance_1") then return end
local bonus = self.parent:GetTalentValue("modifier_slark_dance_1", "move")
if self.parent:HasModifier("modifier_slark_shadow_dance_custom_effect") then
	bonus = self.speed_bonus*bonus
end
return bonus
end

function modifier_slark_shadow_dance_custom_tracker:GetModifierMagicalResistanceBonus()
if not self.parent:HasTalent("modifier_slark_dance_2") then return end
return self.parent:GetTalentValue("modifier_slark_dance_2", "magic")
end







slark_shadow_dance_custom_legendary = class({})

function slark_shadow_dance_custom_legendary:CreateTalent()
self:SetHidden(false)
end

function slark_shadow_dance_custom_legendary:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("radius")
end

function slark_shadow_dance_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_slark_dance_7", "cd")
end

function slark_shadow_dance_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local point = caster:GetAbsOrigin()
local duration = caster:GetTalentValue("modifier_slark_dance_7", "duration")

CreateModifierThinker(caster, self, "modifier_slark_shadow_dance_custom_legendary", {duration = duration}, point, caster:GetTeamNumber(), false)
end

modifier_slark_shadow_dance_custom_legendary = class({})
function modifier_slark_shadow_dance_custom_legendary:IsHidden() return true end
function modifier_slark_shadow_dance_custom_legendary:IsPurgable() return false end
function modifier_slark_shadow_dance_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.point = self.parent:GetAbsOrigin()
self.radius = self.ability:GetSpecialValueFor("radius")

if not IsServer() then return end
self.ability:EndCd()

self.parent:EmitSound("Slark.Dance_legendary1")
self.parent:EmitSound("Slark.Dance_legendary2")

local particle = ParticleManager:CreateParticle("particles/slark/dance_legendary.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, self.point)
ParticleManager:SetParticleControl(particle, 1, self.point)
ParticleManager:SetParticleControl(particle, 2, self.point)
ParticleManager:SetParticleControl(particle, 3, self.point)
ParticleManager:SetParticleControl(particle, 4, Vector(self.radius, self:GetRemainingTime(), 0))
self:AddParticle(particle, false, false, -1, false, false)
end

function modifier_slark_shadow_dance_custom_legendary:OnDestroy()
if not IsServer() then return end
self.ability:StartCd()
end

function modifier_slark_shadow_dance_custom_legendary:IsAura() return true end
function modifier_slark_shadow_dance_custom_legendary:GetAuraDuration() return 0 end
function modifier_slark_shadow_dance_custom_legendary:GetAuraRadius() return self.radius end
function modifier_slark_shadow_dance_custom_legendary:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_slark_shadow_dance_custom_legendary:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_slark_shadow_dance_custom_legendary:GetModifierAura() return "modifier_slark_shadow_dance_custom_effect" end
function modifier_slark_shadow_dance_custom_legendary:GetAuraEntityReject(hEntity)
return hEntity ~= self.caster
end





modifier_slark_shadow_dance_custom_effect = class({})
function modifier_slark_shadow_dance_custom_effect:IsHidden() return self:GetCaster():HasModifier("modifier_slark_shadow_dance_custom") end
function modifier_slark_shadow_dance_custom_effect:IsPurgable() return false end
function modifier_slark_shadow_dance_custom_effect:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.bva = self.parent:GetTalentValue("modifier_slark_dance_7", "bva", true)

self.status = self.parent:GetTalentValue("modifier_slark_dance_5", "status", true)
self.legendary_status = self.parent:GetTalentValue("modifier_slark_dance_5", "legendary_status", true)

self.range = self.parent:GetTalentValue("modifier_slark_dance_5", "range", true)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_slark_dance_6") then return end

local cd_items = self.parent:GetTalentValue("modifier_slark_dance_6", "cd_items")

for i = 0, 8 do
    local current_item = self.parent:GetItemInSlot(i)
    if current_item and not NoCdItems[current_item:GetName()] then  
		local cooldown_mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_cooldown_speed", {ability = current_item:entindex(), is_item = true, cd_inc = cd_items})
		local name = self:GetName()
		cooldown_mod:SetEndRule(function()
			return self.parent:HasModifier(name)
		end)
    end
end

end

function modifier_slark_shadow_dance_custom_effect:GetStatusEffectName()
return "particles/status_fx/status_effect_void_spirit_pulse_buff.vpcf"
end

function modifier_slark_shadow_dance_custom_effect:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA  
end

function modifier_slark_shadow_dance_custom_effect:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
  	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_slark_shadow_dance_custom_effect:GetActivityTranslationModifiers()
return "shadow_dance"
end

function modifier_slark_shadow_dance_custom_effect:GetModifierBaseAttackTimeConstant()
if not self.parent:HasTalent("modifier_slark_dance_7") then return end
return self.bva
end

function modifier_slark_shadow_dance_custom_effect:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_slark_dance_5") then return end
return self.range
end

function modifier_slark_shadow_dance_custom_effect:GetModifierStatusResistanceStacking() 
if not self.parent:HasTalent("modifier_slark_dance_5") then return end
if self.parent:HasModifier("modifier_slark_shadow_dance_custom") then
	return self.status
end
return self.legendary_status
end



modifier_slark_shadow_dance_custom_burn = class({})
function modifier_slark_shadow_dance_custom_burn:IsHidden() return false end
function modifier_slark_shadow_dance_custom_burn:IsPurgable() return false end
function modifier_slark_shadow_dance_custom_burn:GetTexture() return "buffs/dance_burn" end

function modifier_slark_shadow_dance_custom_burn:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.duration = self.caster:GetTalentValue("modifier_slark_dance_4", "duration")
self.interval = self.caster:GetTalentValue("modifier_slark_dance_4", "interval")
self.damage = (self.caster:GetTalentValue("modifier_slark_dance_4", "damage")*self.interval)/self.duration
self.bonus = 1 + self.caster:GetTalentValue("modifier_slark_dance_4", "bonus")/100
self.heal = self.caster:GetTalentValue("modifier_slark_dance_4", "heal")/100

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

if not IsServer() then return end
self.RemoveForDuel = true
self:AddStack()

self:StartIntervalThink(self.interval)
end

function modifier_slark_shadow_dance_custom_burn:AddStack()
if not IsServer() then return end

Timers:CreateTimer(self.duration, function() 
  if self and not self:IsNull() then 
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then 
      self:Destroy()
    end 
  end 
end)

self:IncrementStackCount()
end 

function modifier_slark_shadow_dance_custom_burn:OnRefresh(table)
if not IsServer() then return end
self:AddStack()
end


function modifier_slark_shadow_dance_custom_burn:OnIntervalThink()
if not IsServer() then return end

local damage = self.damage*self:GetStackCount()
local particle = ""

if self.caster:HasModifier("modifier_slark_shadow_dance_custom_effect") then
	damage = damage*self.bonus
	particle = "particles/slark/dance_lifesteal.vpcf"
	if not self.particle then
		self.particle = self.parent:GenericParticle("particles/slark/dance_burn.vpcf", self)
	end
elseif self.particle then
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
	self.particle = nil
end

self.damageTable.damage = damage

local real_damage = DoDamage(self.damageTable, "modifier_slark_dance_4")
self.caster:GenericHeal(real_damage*self.heal, self.ability, true, particle, "modifier_slark_dance_4")
end

