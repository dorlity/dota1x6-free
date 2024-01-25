LinkLuaModifier("modifier_searing_chains_custom_debuff", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_tracker", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_speed", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_shield", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)

ember_spirit_searing_chains_custom = class({})



function ember_spirit_searing_chains_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_weapon_blur_both.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_weapon_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_weapon_blur_overhead.vpcf", context )


PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf", context )
PrecacheResource( "particle", "particles/huskar_leap_heal.vpcf", context )

end

function ember_spirit_searing_chains_custom:GetBehavior()
local auto = 0
local stun = 0
if self:GetCaster():HasModifier("modifier_ember_chain_5") then 
	auto = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	stun = DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + auto + stun
end


function ember_spirit_searing_chains_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_ember_chain_1") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_ember_chain_1", 'cd')
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end


function ember_spirit_searing_chains_custom:GetIntrinsicModifierName()
return "modifier_searing_chains_custom_tracker"
end



function ember_spirit_searing_chains_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_ember_chain_5") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_ember_chain_5", "radius")
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function ember_spirit_searing_chains_custom:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_ember_chain_5") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function ember_spirit_searing_chains_custom:GetDamage(target)
local damage = self:GetSpecialValueFor("damage_per_second") + self:GetCaster():GetTalentValue("modifier_ember_chain_2",  "damage_base")

if self:GetCaster():HasModifier("modifier_ember_chain_2") and target then 

	local bonus = target:GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_ember_chain_2", "damage_health")/100

	if target:IsCreep() then 
		bonus = bonus * self:GetCaster():GetTalentValue("modifier_ember_chain_2", "creeps")
	end 

	damage = damage + bonus
end 

return damage
end



function ember_spirit_searing_chains_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()
local caster_loc = caster:GetAbsOrigin()
local targets_count = self:GetSpecialValueFor("unit_count")
local duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_ember_chain_1", "duration")
local radius = self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_ember_chain_5", "radius")

local ability = caster:FindAbilityByName("ember_spirit_fire_remnant_custom")
if ability then 
	ability:AddStack()
end 


if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_searing_chains_custom_shield", {duration = self:GetCaster():GetTalentValue("modifier_ember_chain_6", "duration")})
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
end 

caster:EmitSound("Hero_EmberSpirit.SearingChains.Cast")

local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", PATTACH_ABSORIGIN, caster)
ParticleManager:SetParticleControl(cast_pfx, 0, caster_loc)
ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius, 1, 1))
ParticleManager:ReleaseParticleIndex(cast_pfx)

local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_ANY_ORDER, false)

if self:GetCaster():HasModifier("modifier_ember_chain_5") then 
	targets_count = #nearby_enemies
end

for i = 1, targets_count do
	if nearby_enemies[i] then
		self:ApplySearingChains(nearby_enemies[i], duration)
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

target:AddNewModifier(caster, caster:BkbAbility(ability, self:GetCaster():HasModifier("modifier_ember_chain_5")), "modifier_searing_chains_custom_debuff", {duration = duration * (1 - target:GetStatusResistance())})

local impact_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControl(impact_pfx, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControlEnt(impact_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(impact_pfx)

if self:GetCaster():HasModifier("modifier_ember_chain_5") and (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > pull_distance and self:GetAutoCastState() == true then 

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

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_ember_chain_3", "heal_reduce")
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_ember_chain_3", "damage_reduce")

if not IsServer() then return end

self.ability = self:GetCaster():FindAbilityByName("ember_spirit_searing_chains_custom")
if not self.ability then 
	self:Destroy()
	return
end

if self:GetCaster():HasModifier("modifier_ember_chain_5") then 
	self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
end 

self.tick_interval = self.ability:GetSpecialValueFor("tick_interval")

self:StartIntervalThink(self.tick_interval - FrameTime())
end

function modifier_searing_chains_custom_debuff:OnIntervalThink()
if not IsServer() then return end

ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self.ability, damage = self.ability:GetDamage(self:GetParent())*self.tick_interval, damage_type = DAMAGE_TYPE_MAGICAL})

if self:GetCaster():GetQuest() == "Ember.Quest_5" and not self:GetCaster():QuestCompleted() and self:GetParent():IsRealHero() then 
	self:GetCaster():UpdateQuest(self.tick_interval)
end


end


function modifier_searing_chains_custom_debuff:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}

end



function modifier_searing_chains_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_ember_chain_3") then return end
return self.heal_reduce
end

function modifier_searing_chains_custom_debuff:GetModifierHealAmplify_PercentageTarget() 
if not self:GetCaster():HasModifier("modifier_ember_chain_3") then return end
return self.heal_reduce
end


function modifier_searing_chains_custom_debuff:GetModifierHPRegenAmplify_Percentage()
if not self:GetCaster():HasModifier("modifier_ember_chain_3") then return end
return self.heal_reduce
end


function modifier_searing_chains_custom_debuff:GetModifierSpellAmplify_Percentage()
if not self:GetCaster():HasModifier("modifier_ember_chain_3") then return end
return self.damage_reduce
end

function modifier_searing_chains_custom_debuff:GetModifierDamageOutgoing_Percentage()
if not self:GetCaster():HasModifier("modifier_ember_chain_3") then return end
return self.damage_reduce
end





modifier_searing_chains_custom_tracker = class({})
function modifier_searing_chains_custom_tracker:IsHidden() return true end
function modifier_searing_chains_custom_tracker:IsPurgable() return false end
function modifier_searing_chains_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_ATTACK_RECORD,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end


function modifier_searing_chains_custom_tracker:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_ember_chain_legendary") then return end 

return self.legendary_range
end




function modifier_searing_chains_custom_tracker:OnCreated()

self.legendary_chance = self:GetCaster():GetTalentValue("modifier_ember_chain_legendary", "chance", true)
self.legendary_duration = self:GetCaster():GetTalentValue("modifier_ember_chain_legendary", "duration", true)
self.legendary_damage = self:GetCaster():GetTalentValue("modifier_ember_chain_legendary", "damage", true)/100
self.legendary_range = self:GetCaster():GetTalentValue("modifier_ember_chain_legendary", "range", true)
end


function modifier_searing_chains_custom_tracker:OnAttackRecord(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsMagicImmune() or params.target:IsBuilding() then return end

if not self:GetParent():HasModifier("modifier_ember_chain_legendary") then return end

local random = RollPseudoRandomPercentage(self.legendary_chance,1291,self:GetParent())

if not random then return end

local cast_pfx = ParticleManager:CreateParticle("particles/ember_spirit/chains_proc_legendary.vpcf", PATTACH_ABSORIGIN, self:GetParent())
ParticleManager:SetParticleControl(cast_pfx, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControlForward(cast_pfx, 0, self:GetParent():GetForwardVector())
ParticleManager:ReleaseParticleIndex(cast_pfx)

params.target:EmitSound("Ember.Chains_Proc") 
self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)

self.record = params.record
end 

function modifier_searing_chains_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsMagicImmune() or params.target:IsBuilding() then return end

if self:GetParent():HasModifier("modifier_searing_chains_custom_speed") then 
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
	
	local real_damage = ApplyDamage({victim = params.target, attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetAbility():GetDamage(params.target)*self.legendary_damage, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(params.target, 4, params.target, real_damage, nil)
else
	self:GetAbility():ApplySearingChains(params.target, self.legendary_duration)
end

end





modifier_searing_chains_custom_shield = class({})
function modifier_searing_chains_custom_shield:IsHidden() return true end
function modifier_searing_chains_custom_shield:IsPurgable() return false end
function modifier_searing_chains_custom_shield:OnCreated(table)

self.max_shield = self:GetCaster():GetTalentValue("modifier_ember_chain_6", "shield")*self:GetCaster():GetMaxHealth()/100

if not IsServer() then return end
self:SetStackCount(self.max_shield)

self.effect = ParticleManager:CreateParticle( "particles/items2_fx/vindicators_axe_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle(self.effect,false, false, -1, false, false)
end


function modifier_searing_chains_custom_shield:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_searing_chains_custom_shield:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() == 0 then return end


if IsClient() then 
  if params.report_max then 
  	return self.max_shield
  else 
	  return self:GetStackCount()
	end 
end

if not IsServer() then return end

self:GetParent():EmitSound("Juggernaut.Parry")
local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end








modifier_searing_chains_custom_speed = class({})
function modifier_searing_chains_custom_speed:IsHidden() return false end
function modifier_searing_chains_custom_speed:IsPurgable() return false end
function modifier_searing_chains_custom_speed:GetTexture() return "buffs/Blade_dance_legendary" end

function modifier_searing_chains_custom_speed:GetEffectName()
return "particles/ember_spirit/chains_bkb.vpcf" 
end

function modifier_searing_chains_custom_speed:GetStatusEffectName()
return "particles/status_fx/status_effect_legion_commander_duel.vpcf"
end
function modifier_searing_chains_custom_speed:StatusEffectPriority() 
return 11111
end

function modifier_searing_chains_custom_speed:OnCreated(table)
self.speed = self:GetCaster():GetTalentValue("modifier_ember_chain_4", "speed")
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_ember_chain_4", "creeps") 
self.heal = self:GetCaster():GetTalentValue("modifier_ember_chain_4", "heal")/100

if not IsServer() then return end
self.RemoveForDuel = true
end



function modifier_searing_chains_custom_speed:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_searing_chains_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_searing_chains_custom_speed:GetModifierModelScale()
return 15
end

function modifier_searing_chains_custom_speed:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal

if params.unit:IsCreep() then 
	heal = heal/self.heal_creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true, "")

end
