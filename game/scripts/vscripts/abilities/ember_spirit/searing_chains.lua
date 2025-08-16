LinkLuaModifier("modifier_searing_chains_custom_debuff", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_tracker", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_speed", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_speed_stack", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_shield", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_damage_reduce", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_disarm", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)

ember_spirit_searing_chains_custom = class({})

function ember_spirit_searing_chains_custom:CreateTalent(name)

if name == "modifier_ember_chain_5" then
	self:ToggleAutoCast()
end

if name == "modifier_ember_chain_4" then
	self:UpdateParticle()
end

end

function ember_spirit_searing_chains_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_weapon_blur_both.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_weapon_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_weapon_blur_overhead.vpcf", context )


PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/ember_spirit/chains_proc_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/vindicators_axe_armor.vpcf", context )
PrecacheResource( "particle", "particles/jugg_parry.vpcf", context )
PrecacheResource( "particle", "particles/ember_spirit/chains_bkb.vpcf", context ) 
PrecacheResource( "particle", "particles/status_fx/status_effect_legion_commander_duel.vpcf", context )
PrecacheResource( "particle", "particles/ember_spirit/chains_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf", context )
end



function ember_spirit_searing_chains_custom:GetBehavior()
local auto = 0
local stun = 0
if self:GetCaster():HasTalent("modifier_ember_chain_5") then 
	auto = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

if self:GetCaster():HasTalent("modifier_ember_chain_6") then 
	stun = DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + auto + stun
end

function ember_spirit_searing_chains_custom:UpdateParticle()
local mod = self:GetCaster():FindModifierByName("modifier_searing_chains_custom_tracker")
if mod then
	mod:UpdateParticle()
end

end

function ember_spirit_searing_chains_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasTalent("modifier_ember_chain_1") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_ember_chain_1", "cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end

function ember_spirit_searing_chains_custom:GetManaCost(level)
if self:GetCaster():HasTalent("modifier_ember_chain_6") then  
  return 0
end
return self.BaseClass.GetManaCost(self,level) 
end


function ember_spirit_searing_chains_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_searing_chains_custom_tracker"
end


function ember_spirit_searing_chains_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasTalent("modifier_ember_chain_5") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_ember_chain_5", "radius")
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function ember_spirit_searing_chains_custom:GetAbilityTargetFlags()
if self:GetCaster():HasTalent("modifier_ember_chain_5") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function ember_spirit_searing_chains_custom:GetDamage(target)
local caster = self:GetCaster()
local damage = self:GetSpecialValueFor("damage_per_second") + caster:GetTalentValue("modifier_ember_chain_2", "damage")

return damage
end



function ember_spirit_searing_chains_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()
local caster_loc = caster:GetAbsOrigin()
local targets_count = self:GetSpecialValueFor("unit_count")
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_ember_chain_1", "duration")
local radius = self:GetSpecialValueFor("radius") + caster:GetTalentValue("modifier_ember_chain_5", "radius")

local ability = caster:FindAbilityByName("ember_spirit_fire_remnant_custom")
if ability then 
	ability:AddStack(true)
end 


if caster:HasTalent("modifier_ember_chain_2") or caster:HasTalent("modifier_ember_chain_4") then

	local stack = 0
	local mod = caster:FindModifierByName("modifier_searing_chains_custom_speed_stack")
	if mod then
		stack = mod:GetStackCount()
		mod:Destroy()
	end

	caster:AddNewModifier(caster, self, "modifier_searing_chains_custom_speed", {duration = caster:GetTalentValue("modifier_ember_chain_2", "duration", true), stack = stack})
end

if caster:HasTalent("modifier_ember_chain_6") then 
	--caster:AddNewModifier(caster, self, "modifier_searing_chains_custom_shield", {duration = caster:GetTalentValue("modifier_ember_chain_6", "duration")})
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
end 

caster:EmitSound("Hero_EmberSpirit.SearingChains.Cast")

local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl(cast_pfx, 0, caster_loc)
ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius, 1, 1))
ParticleManager:ReleaseParticleIndex(cast_pfx)

local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

if caster:HasTalent("modifier_ember_chain_5") then 
	targets_count = #nearby_enemies
end

local damage_duration = caster:GetTalentValue("modifier_ember_chain_3", "duration")
local disarm_duration = caster:GetTalentValue("modifier_ember_chain_6", "disarm")

for i = 1, targets_count do
	if nearby_enemies[i] then

		if caster:HasTalent("modifier_ember_chain_3") then 
			nearby_enemies[i]:AddNewModifier(caster, self, "modifier_searing_chains_custom_damage_reduce", {duration = damage_duration})
		end

		self:ApplySearingChains(nearby_enemies[i], duration)

		if caster:HasTalent("modifier_ember_chain_6") then
			nearby_enemies[i]:AddNewModifier(caster, self, "modifier_searing_chains_custom_disarm", {duration = (1 - nearby_enemies[i]:GetStatusResistance())*disarm_duration})
		end
	end
end

end



function ember_spirit_searing_chains_custom:ApplySearingChains(target, duration)
if not IsServer() then return end

local caster = self:GetCaster()
local ability = self


target:EmitSound("Hero_EmberSpirit.SearingChains.Target")
local point = target:GetAbsOrigin()
point.z = point.z + 100

local pull_distance = self:GetCaster():GetTalentValue("modifier_ember_chain_5", "distance")
local pull_duration = self:GetCaster():GetTalentValue("modifier_ember_chain_5", "duration")

target:AddNewModifier(caster, caster:BkbAbility(ability, self:GetCaster():HasTalent("modifier_ember_chain_5")), "modifier_searing_chains_custom_debuff", {duration = duration * (1 - target:GetStatusResistance())})

local impact_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControl(impact_pfx, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(impact_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(impact_pfx)

if self:GetCaster():HasTalent("modifier_ember_chain_5") and (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > pull_distance and self:GetAutoCastState() == true then 

	local dir = (self:GetCaster():GetAbsOrigin() -  target:GetAbsOrigin()):Normalized()
	local point = self:GetCaster():GetAbsOrigin() - dir*pull_distance

	local distance = (point - target:GetAbsOrigin()):Length2D()

	distance = math.max(100, distance)
	point = target:GetAbsOrigin() + dir*distance

	target:AddNewModifier( self:GetCaster(),  caster:BkbAbility(ability, true),  "modifier_generic_arc",  
	{
	  target_x = point.x,
	  target_y = point.y,
	  distance = distance,
	  duration = pull_duration,
	  height = 0,
	  fix_end = false,
	  isStun = false,
	  activity = ACT_DOTA_FLAIL,
	})

end 

end

modifier_searing_chains_custom_debuff = class({})

function modifier_searing_chains_custom_debuff:IsDebuff() return true end
function modifier_searing_chains_custom_debuff:IsHidden() return false end
function modifier_searing_chains_custom_debuff:IsPurgable() return true end
function modifier_searing_chains_custom_debuff:GetTexture() return "ember_spirit_searing_chains" end

function modifier_searing_chains_custom_debuff:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf"
end

function modifier_searing_chains_custom_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_searing_chains_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}

	return state
end

function modifier_searing_chains_custom_debuff:OnCreated(keys)
if not IsServer() then return end

self.ability = self:GetCaster():FindAbilityByName("ember_spirit_searing_chains_custom")
if not self.ability then 
	self:Destroy()
	return
end

if self:GetCaster():HasTalent("modifier_ember_chain_5") then 
	self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
end 

self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")

self:StartIntervalThink(self.tick_interval - FrameTime())
end

function modifier_searing_chains_custom_debuff:OnIntervalThink()
if not IsServer() then return end

DoDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self.ability, damage = self.ability:GetDamage(self:GetParent())*self.tick_interval, damage_type = DAMAGE_TYPE_MAGICAL})

if self:GetCaster():GetQuest() == "Ember.Quest_5" and not self:GetCaster():QuestCompleted() and self:GetParent():IsRealHero() then 
	self:GetCaster():UpdateQuest(self.tick_interval)
end


end






modifier_searing_chains_custom_tracker = class({})
function modifier_searing_chains_custom_tracker:IsHidden() return true end
function modifier_searing_chains_custom_tracker:IsPurgable() return false end
function modifier_searing_chains_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end


function modifier_searing_chains_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()


self.parent:AddAttackCreateEvent(self)
self.parent:AddAttackEvent_out(self)

self.legendary_chance = self.parent:GetTalentValue("modifier_ember_chain_legendary", "chance", true)
self.legendary_duration = self.parent:GetTalentValue("modifier_ember_chain_legendary", "duration", true)
self.legendary_damage = self.parent:GetTalentValue("modifier_ember_chain_legendary", "damage", true)/100
self.legendary_range = self.parent:GetTalentValue("modifier_ember_chain_legendary", "range", true)

self.stack_max = self.parent:GetTalentValue("modifier_ember_chain_4", "max", true)
end


function modifier_searing_chains_custom_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_ember_chain_legendary") then return end 
return self.legendary_range
end

function modifier_searing_chains_custom_tracker:AttackCreateEvent(params)
if not IsServer() then return end
if not self.parent:IsRealHero() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end
if not self.parent:HasTalent("modifier_ember_chain_legendary") then return end

local random = RollPseudoRandomPercentage(self.legendary_chance,1291,self.parent)

if not random then return end

local cast_pfx = ParticleManager:CreateParticle("particles/ember_spirit/chains_proc_legendary.vpcf", PATTACH_ABSORIGIN, self.parent)
ParticleManager:SetParticleControl(cast_pfx, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControlForward(cast_pfx, 0, self.parent:GetForwardVector())
ParticleManager:ReleaseParticleIndex(cast_pfx)

params.target:EmitSound("Ember.Chains_Proc") 
self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)

self.record = params.record
end 

function modifier_searing_chains_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not self.parent:IsRealHero() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

if self.parent:HasModifier("modifier_searing_chains_custom_speed") and self.parent:HasTalent("modifier_ember_chain_4") then 
	local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, params.target)
	ParticleManager:SetParticleControlEnt(hit_effect, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
	ParticleManager:SetParticleControlEnt(hit_effect, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
	ParticleManager:ReleaseParticleIndex(hit_effect)
end 

if not self.record or params.record ~= self.record then return end
if params.target:HasModifier("modifier_searing_chains_custom_debuff") then 
	params.target:EmitSound("Ember.Chains_Stun")  

	local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, params.target)
	ParticleManager:SetParticleControlEnt(hit_effect, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
	ParticleManager:SetParticleControlEnt(hit_effect, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
	ParticleManager:ReleaseParticleIndex(hit_effect)
	
	local real_damage = DoDamage({victim = params.target, attacker = self.parent, ability = self:GetAbility(), damage = self:GetAbility():GetDamage(params.target)*self.legendary_damage, damage_type = DAMAGE_TYPE_MAGICAL}, "modifier_ember_chain_legendary")
	SendOverheadEventMessage(params.target, 4, params.target, real_damage, nil)
else
	self:GetAbility():ApplySearingChains(params.target, self.legendary_duration)
end

end

function modifier_searing_chains_custom_tracker:UpdateParticle()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_ember_chain_4") then return end

if self.parent:HasModifier("modifier_searing_chains_custom_speed_stack") then
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
else
	if not self.particle then
		self.particle = self.parent:GenericParticle("particles/ember_spirit/chains_stack.vpcf", self, true)
		for i = 1,self.stack_max do 
			ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
		end	
	end
end

end





modifier_searing_chains_custom_speed = class({})
function modifier_searing_chains_custom_speed:IsHidden() return false end
function modifier_searing_chains_custom_speed:IsPurgable() return false end
function modifier_searing_chains_custom_speed:GetTexture() return "buffs/Blade_dance_legendary" end

function modifier_searing_chains_custom_speed:GetStatusEffectName()
if not self.parent:HasTalent("modifier_ember_chain_4") then return end
return "particles/status_fx/status_effect_legion_commander_duel.vpcf"
end
function modifier_searing_chains_custom_speed:StatusEffectPriority() 
return MODIFIER_PRIORITY_ULTRA 
end

function modifier_searing_chains_custom_speed:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.parent:AddDamageEvent_out(self)

self.max = self.parent:GetTalentValue("modifier_ember_chain_4", "max", true)
self.agility = self.parent:GetTalentValue("modifier_ember_chain_4", "agility")/self.max
self.heal_creeps = self.parent:GetTalentValue("modifier_ember_chain_4", "creeps", true) 
self.heal = (self.parent:GetTalentValue("modifier_ember_chain_4", "heal")/100)/self.max

self.speed = self.parent:GetTalentValue("modifier_ember_chain_2", "speed")
if not IsServer() then return end

if table.stack then
	self:SetStackCount(table.stack)
end

if self.parent:HasTalent("modifier_ember_chain_4") and self:GetStackCount() > 0 then
	self.parent:EmitSound("Ember.Chain_speed")
	self.parent:GenericParticle("particles/ember_spirit/chains_bkb.vpcf", self)
end

self.PercentAgi = (self.agility/100)*self:GetStackCount()
self.RemoveForDuel = true
end



function modifier_searing_chains_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MODEL_SCALE,
  MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_searing_chains_custom_speed:OnTooltip()
if not self.parent:HasTalent("modifier_ember_chain_4") then return end
return self.heal*self:GetStackCount()*100
end

function modifier_searing_chains_custom_speed:GetModifierAttackSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_ember_chain_2") then return end
return self.speed
end


function modifier_searing_chains_custom_speed:GetModifierModelScale()
if self:GetStackCount() <= 0 then return end
return 15
end

function modifier_searing_chains_custom_speed:DamageEvent_out(params)
if not IsServer() then return end
if self:GetStackCount() <= 0 then return end
if not self.parent:CheckLifesteal(params) then return end

local heal = self.heal*self:GetStackCount()

if params.unit:IsCreep() then 
	heal = heal/self.heal_creeps
end

heal = heal*params.damage

self.parent:GenericHeal(heal, self.ability, true, "", "modifier_ember_chain_4")

end




modifier_searing_chains_custom_damage_reduce = class({})
function modifier_searing_chains_custom_damage_reduce:IsHidden() return false end
function modifier_searing_chains_custom_damage_reduce:IsPurgable() return false end
function modifier_searing_chains_custom_damage_reduce:GetTexture() return "buffs/raze_burn" end


function modifier_searing_chains_custom_damage_reduce:OnCreated()

self.caster = self:GetCaster()

self.heal_reduce = self.caster:GetTalentValue("modifier_ember_chain_3", "heal_reduce")
self.damage_reduce = self.caster:GetTalentValue("modifier_ember_chain_3", "damage_reduce")
end 

function modifier_searing_chains_custom_damage_reduce:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_searing_chains_custom_damage_reduce:GetModifierLifestealRegenAmplify_Percentage() 
if not self.caster:HasTalent("modifier_ember_chain_3") then return end
return self.heal_reduce
end

function modifier_searing_chains_custom_damage_reduce:GetModifierHealAmplify_PercentageTarget() 
if not self.caster:HasTalent("modifier_ember_chain_3") then return end
return self.heal_reduce
end

function modifier_searing_chains_custom_damage_reduce:GetModifierHPRegenAmplify_Percentage()
if not self.caster:HasTalent("modifier_ember_chain_3") then return end
return self.heal_reduce
end

function modifier_searing_chains_custom_damage_reduce:GetModifierSpellAmplify_Percentage()
if not self.caster:HasTalent("modifier_ember_chain_3") then return end
return self.damage_reduce
end

function modifier_searing_chains_custom_damage_reduce:GetModifierDamageOutgoing_Percentage()
if not self.caster:HasTalent("modifier_ember_chain_3") then return end
return self.damage_reduce
end


modifier_searing_chains_custom_speed_stack = class({})
function modifier_searing_chains_custom_speed_stack:IsHidden() return false end
function modifier_searing_chains_custom_speed_stack:IsPurgable() return false end
function modifier_searing_chains_custom_speed_stack:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.parent:GetTalentValue("modifier_ember_chain_4", "max")

if not IsServer() then return end
self.ability:UpdateParticle()
self.particle = self.parent:GenericParticle("particles/ember_spirit/chains_stack.vpcf", self, true)
self:SetStackCount(1)
end

function modifier_searing_chains_custom_speed_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end


function modifier_searing_chains_custom_speed_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.particle then return end

for i = 1,self.max do 
	if i <= self:GetStackCount() then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end	

end


function modifier_searing_chains_custom_speed_stack:OnDestroy()
if not IsServer() then return end
self.ability:UpdateParticle()
end




modifier_searing_chains_custom_disarm = class({})
function modifier_searing_chains_custom_disarm:IsHidden() return true end
function modifier_searing_chains_custom_disarm:IsPurgable() return true end
function modifier_searing_chains_custom_disarm:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end

function modifier_searing_chains_custom_disarm:GetPriority()
return 999999
end

function modifier_searing_chains_custom_disarm:GetEffectName()
return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
end

function modifier_searing_chains_custom_disarm:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end