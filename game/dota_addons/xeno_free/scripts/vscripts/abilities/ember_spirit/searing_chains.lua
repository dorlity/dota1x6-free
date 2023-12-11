LinkLuaModifier("modifier_searing_chains_custom_debuff", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_speed", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_searing_chains_custom_tracker", "abilities/ember_spirit/searing_chains", LUA_MODIFIER_MOTION_NONE)

ember_spirit_searing_chains_custom = class({})


ember_spirit_searing_chains_custom.speed_attack_init = 20
ember_spirit_searing_chains_custom.speed_attack_inc = 20
ember_spirit_searing_chains_custom.speed_move_init = 5
ember_spirit_searing_chains_custom.speed_move_inc = 5
ember_spirit_searing_chains_custom.speed_duration = 3

ember_spirit_searing_chains_custom.legendary_chance = 35
ember_spirit_searing_chains_custom.legendary_duration = 2
ember_spirit_searing_chains_custom.legendary_stun = 0.5






function ember_spirit_searing_chains_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_weapon_blur_both.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_weapon_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_weapon_blur_overhead.vpcf", context )


PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_debuff.vpcf", context )
PrecacheResource( "particle", "particles/huskar_leap_heal.vpcf", context )

end



function ember_spirit_searing_chains_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_ember_chain_6") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_ember_chain_6", 'cd')
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
if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end



function ember_spirit_searing_chains_custom:OnSpellStart()
if not IsServer() then return end

	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	local targets_count = self:GetSpecialValueFor("unit_count")
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")
	local ability = caster:FindAbilityByName("ember_spirit_fire_remnant_custom")
	if ability then 
		ability:AddStack()
	end 



	if self:GetCaster():HasModifier("modifier_ember_chain_1") then 
		duration = duration + self:GetCaster():GetTalentValue("modifier_ember_chain_1", "duration")
	end


	if self:GetCaster():HasModifier("modifier_ember_chain_5") then 
  		radius = radius + self:GetCaster():GetTalentValue("modifier_ember_chain_5", "radius")
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
			self:ApplySearingChains( nearby_enemies[i], duration)
		end
	end


end

function ember_spirit_searing_chains_custom:ApplySearingChains(target, duration)
if not IsServer() then return end

	local caster = self:GetCaster()
	local ability = self

	if caster:HasModifier("modifier_ember_chain_2") then 
		caster:AddNewModifier(caster, ability, "modifier_searing_chains_custom_speed", {duration = ability.speed_duration})
	end



	target:EmitSound("Hero_EmberSpirit.SearingChains.Target")
	local point = target:GetAbsOrigin()
	point.z = point.z + 100


	local pull_distance = self:GetCaster():GetTalentValue("modifier_ember_chain_5", "distance")

	target:AddNewModifier(caster, caster:BkbAbility(ability, self:GetCaster():HasModifier("modifier_ember_chain_6")), "modifier_searing_chains_custom_debuff", {duration = duration * (1 - target:GetStatusResistance())})

	local impact_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_searing_chains_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(impact_pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(impact_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(impact_pfx)

	if self:GetCaster():HasModifier("modifier_ember_chain_5") and (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > pull_distance then 

		local dir = (self:GetCaster():GetAbsOrigin() -  target:GetAbsOrigin()):Normalized()
		local point = self:GetCaster():GetAbsOrigin() - dir*pull_distance

		local distance = (point - target:GetAbsOrigin()):Length2D()

		distance = math.max(100, distance)
		point = target:GetAbsOrigin() + dir*distance

  	target:AddNewModifier( self:GetCaster(),  caster:BkbAbility(ability, self:GetCaster():HasModifier("modifier_ember_chain_6")),  "modifier_generic_arc",  
		{
		  target_x = point.x,
		  target_y = point.y,
		  distance = distance,
		  duration = self:GetCaster():GetTalentValue("modifier_ember_chain_5", "duration"),
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

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_ember_chain_6", "heal_reduce")
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_ember_chain_6", "damage_reduce")

self.speed_reduce = self:GetCaster():GetTalentValue("modifier_ember_chain_1", "speed")

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
self.damage =  (self.ability:GetSpecialValueFor("damage_per_second") + self:GetCaster():GetTalentValue("modifier_ember_chain_3", "damage"))*self.tick_interval

self:StartIntervalThink(0.1)
self.count = 0

end

function modifier_searing_chains_custom_debuff:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + 0.1 

if self.count >= self.tick_interval then 
	ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self.ability, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
	self.count = 0
end

if self:GetCaster():GetQuest() == "Ember.Quest_5" and not self:GetCaster():QuestCompleted() and self:GetParent():IsRealHero() then 
	self:GetCaster():UpdateQuest(0.1)
end


end


function modifier_searing_chains_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}

end

function modifier_searing_chains_custom_debuff:GetModifierAttackSpeedBonus_Constant()
if self:GetCaster():HasModifier("modifier_ember_chain_1") then 
	return self.speed_reduce
else 
	return
end

end


function modifier_searing_chains_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	return self.heal_reduce
else 
	return
end

end

function modifier_searing_chains_custom_debuff:GetModifierHealAmplify_PercentageTarget() 
if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	return self.heal_reduce
else 
	return
end

end

function modifier_searing_chains_custom_debuff:GetModifierHPRegenAmplify_Percentage()
if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	return self.heal_reduce
else 
	return
end

end

function modifier_searing_chains_custom_debuff:GetModifierTotalDamageOutgoing_Percentage()
if self:GetCaster():HasModifier("modifier_ember_chain_6") then 
	return self.damage_reduce
else 
	return
end

end


modifier_searing_chains_custom_speed = class({})
function modifier_searing_chains_custom_speed:IsHidden() return false end
function modifier_searing_chains_custom_speed:IsPurgable() return true end
function modifier_searing_chains_custom_speed:GetTexture() return "buffs/chains_speed" end
function modifier_searing_chains_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_searing_chains_custom_speed:GetModifierAttackSpeedBonus_Constant()
return
self:GetAbility().speed_attack_init + self:GetAbility().speed_attack_inc*self:GetCaster():GetUpgradeStack("modifier_ember_chain_2")
end

function modifier_searing_chains_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return
self:GetAbility().speed_move_init + self:GetAbility().speed_move_inc*self:GetCaster():GetUpgradeStack("modifier_ember_chain_2")
end


modifier_searing_chains_custom_tracker = class({})
function modifier_searing_chains_custom_tracker:IsHidden() return true end
function modifier_searing_chains_custom_tracker:IsPurgable() return false end
function modifier_searing_chains_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_searing_chains_custom_tracker:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_ember_chain_5") then return end 

return self:GetCaster():GetTalentValue("modifier_ember_chain_5", "range")
end


function modifier_searing_chains_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_ember_chain_3") then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self:GetCaster():GetTalentValue("modifier_ember_chain_3", "heal")/100

if params.unit:IsCreep() then 
	heal = heal/self:GetCaster():GetTalentValue("modifier_ember_chain_3", "creeps")
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end






function modifier_searing_chains_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsMagicImmune() or params.target:IsBuilding() then return end

if self:GetCaster():HasModifier("modifier_ember_chain_4") then

	local chance = self:GetCaster():GetTalentValue("modifier_ember_chain_4", "chance")

	if params.target:HasModifier("modifier_searing_chains_custom_debuff") then 
		chance = chance*self:GetCaster():GetTalentValue("modifier_ember_chain_4", "bonus")
	end 

  if RollPseudoRandomPercentage(chance,1251,self:GetParent()) then

		local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, params.target)
		ParticleManager:SetParticleControlEnt(hit_effect, 0, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
		ParticleManager:SetParticleControlEnt(hit_effect, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false) 
		ParticleManager:ReleaseParticleIndex(hit_effect)


		params.target:EmitSound("Ember.Chains_Proc")

		local damage = params.target:GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_ember_chain_4", "damage")/100

		if params.target:IsCreep() then 
			damage = damage/self:GetCaster():GetTalentValue("modifier_ember_chain_4", "creeps")
		end 

		local real_damage = ApplyDamage({victim = params.target, attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(params.target, 4, params.target, real_damage, nil)
	end 


end



if not self:GetParent():HasModifier("modifier_ember_chain_legendary") then return end

local random = RollPseudoRandomPercentage(self:GetAbility().legendary_chance,121,self:GetParent())


if not random then return end

self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)

if params.target:HasModifier("modifier_searing_chains_custom_debuff") then 
	params.target:EmitSound("Ember.Chains_Stun")   
	params.target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self:GetAbility(), self:GetCaster():HasModifier("modifier_ember_chain_6")), "modifier_stunned", {duration = self:GetAbility().legendary_stun*(1 - params.target:GetStatusResistance())})
	
else

	self:GetAbility():ApplySearingChains(params.target, self:GetAbility().legendary_duration)

end

end


