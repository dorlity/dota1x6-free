LinkLuaModifier("modifier_troll_warlord_battle_trance_custom", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_debuff", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_tracker", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_slow", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_aura", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_effect", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_warlord_battle_trance_custom_cd", "abilities/troll_warlord/troll_warlord_battle_trance_custom", LUA_MODIFIER_MOTION_NONE)





troll_warlord_battle_trance_custom = class({})





function troll_warlord_battle_trance_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_troll_warlord_battletrance.vpcf", context )
PrecacheResource( "particle", "particles/qop_linken_buff.vpcf", context )
PrecacheResource( "particle", "particles/qop_linken.vpcf", context )

end





function troll_warlord_battle_trance_custom:GetIntrinsicModifierName()
return "modifier_troll_warlord_battle_trance_custom_tracker"
end

function troll_warlord_battle_trance_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_troll_trance_legendary") then 
	return self:GetCaster():GetTalentValue("modifier_troll_trance_legendary", "range")
end 
 return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end





function troll_warlord_battle_trance_custom:GetCooldown(iLevel)

local k = 0
if self:GetCaster():HasModifier("modifier_troll_trance_6") then 
	k = self:GetCaster():GetTalentValue("modifier_troll_trance_6", "cd")
end


 return self.BaseClass.GetCooldown(self, iLevel) + k
 
end



function troll_warlord_battle_trance_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_troll_trance_legendary") then
    return  DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end
 return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end



function troll_warlord_battle_trance_custom:OnSpellStart()
	if not IsServer() then return end


	local target = nil
	if self:GetCursorTarget() ~= nil then 
		target = self:GetCursorTarget()
	end

	local trance_duration	= self:GetSpecialValueFor("trance_duration") + self:GetCaster():GetTalentValue("modifier_troll_trance_1", "duration")


	if target ~= self:GetCaster() and target ~= nil then 
		trance_duration = trance_duration*self:GetCaster():GetTalentValue("modifier_troll_trance_legendary", "duration")/100
		self:GetCaster():CdAbility(self, self:GetCooldownTimeRemaining()*self:GetCaster():GetTalentValue("modifier_troll_trance_legendary", "cd")/100)
	end

	self:GetCaster():EmitSound("Hero_TrollWarlord.BattleTrance.Cast")

	if target == nil or target == self:GetCaster() then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_battle_trance_custom", {duration = trance_duration})
		self:GetCaster():Purge(false, true, false, false, false)
	else
		if not target:TriggerSpellAbsorb(self) then 

			target:AddNewModifier(self:GetCaster(), self, "modifier_troll_warlord_battle_trance_custom", {duration = trance_duration})
		end
	end


	local cast_pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(cast_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc" , self:GetCaster():GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex(cast_pfx)
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)

end

modifier_troll_warlord_battle_trance_custom = class({})

function modifier_troll_warlord_battle_trance_custom:IsPurgable()	return false end

function modifier_troll_warlord_battle_trance_custom:GetEffectName()
	return "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf"
end



function modifier_troll_warlord_battle_trance_custom:OnCreated()
self.ability	= self:GetAbility()
self.caster		= self:GetParent()
self.parent		= self:GetParent()
self.lifesteal		= self.ability:GetSpecialValueFor("lifesteal") / 100
self.attack_speed	= self.ability:GetSpecialValueFor("attack_speed")
self.movement_speed	= self.ability:GetSpecialValueFor("movement_speed")
self.range			= self.ability:GetSpecialValueFor("range")

self.heal = self:GetCaster():GetTalentValue("modifier_troll_trance_3", "heal")/100

if not IsServer() then return end

self.block = false

if self:GetCaster():HasModifier("modifier_troll_trance_6") and self:GetParent() == self:GetCaster() then 

	self.block = true
	self.particle = ParticleManager:CreateParticle("particles/qop_linken_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle(self.particle, false, false, -1, false, true)
end 


self.target = nil
self.RemoveForDuel = true
self:OnIntervalThink()
self:StartIntervalThink(0.1)
end





function modifier_troll_warlord_battle_trance_custom:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if self:GetParent() ~= self:GetCaster() then return end
if self.block == false then return end 

self.block = false

local particle = ParticleManager:CreateParticle("particles/qop_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

if self.particle then 
	ParticleManager:DestroyParticle(self.particle, false)
	ParticleManager:ReleaseParticleIndex(self.particle)
end

return 1 
end







function modifier_troll_warlord_battle_trance_custom:IsValidTarget(target)
if not IsServer() then return end 

if target and not target:IsNull() and not target:IsAttackImmune() and target:IsAlive() and not target:IsInvulnerable() and self.caster:CanEntityBeSeenByMyTeam(target)
  and target:GetUnitName() ~= "npc_teleport" and not target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") and (target:IsHero() or target:IsCreep())
  and (target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() <= 1500 then 

	return true
end 

return false
end 


function modifier_troll_warlord_battle_trance_custom:SetTarget(target)
if not IsServer() then return end 
if not self:IsValidTarget(target) then return end 

if self.target and self.target ~= target then 
	self.target:RemoveModifierByName("modifier_troll_warlord_battle_trance_custom_debuff")
end 

self.target = target
self.target:AddNewModifier(self.caster, self.ability, "modifier_troll_warlord_battle_trance_custom_debuff", {})

self:GetParent():MoveToTargetToAttack(self.target)
end


function modifier_troll_warlord_battle_trance_custom:OnIntervalThink()
if not IsServer() then return end
if self:GetParent() == self:GetCaster() and self:GetCaster():HasModifier("modifier_troll_trance_6") then return end


local hero_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)
local non_hero_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), self.caster:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_CLOSEST, false)

if not self:IsValidTarget(self.target) then

	if self.target and not self.target:IsNull() then 
		self.target:RemoveModifierByName("modifier_troll_warlord_battle_trance_custom_debuff")
	end 

	self.target = nil
end 


if #hero_enemies > 0 and (not self:IsValidTarget(self.target) or self.target:IsCreep()) then 

	for _,hero in pairs(hero_enemies) do 
		self:SetTarget(hero)

		if self.target then 
			break
		end 
	end 

end 


if self.target == nil and #non_hero_enemies > 0 then 

	for _,creep in pairs(non_hero_enemies) do 
		self:SetTarget(creep)

		if self.target then 
			break
		end 
	end 

end 

if self.target == nil then 
	self:GetParent():SetForceAttackTarget(nil)
else 
	self:GetParent():MoveToTargetToAttack(self.target)
end

end




function modifier_troll_warlord_battle_trance_custom:OnDestroy()
	if not IsServer() then return end

	if self.target and not self.target:IsNull() then
		self.target:RemoveModifierByName("modifier_troll_warlord_battle_trance_custom_debuff")
	end	

	if not self:GetParent():HasModifier("modifier_troll_trance_6") then 
		self:GetParent():SetForceAttackTarget(nil)
	end
end

function modifier_troll_warlord_battle_trance_custom:GetPriority()
	return 10
end

function modifier_troll_warlord_battle_trance_custom:CheckState()
if self:GetParent() == self:GetCaster() then 

	if self:GetCaster():HasModifier("modifier_troll_trance_6") then 
		return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	else 
		if self.target == nil then return { [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end

		return {[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true, [MODIFIER_STATE_NO_UNIT_COLLISION] = true}
	end
else 
	if self.target == nil then return {[MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true  , [MODIFIER_STATE_NO_UNIT_COLLISION] = true} end
	return {[MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true, [MODIFIER_STATE_MUTED] = true, [MODIFIER_STATE_SILENCED] = true  , [MODIFIER_STATE_NO_UNIT_COLLISION] = true }
end

end

function modifier_troll_warlord_battle_trance_custom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_ABSORB_SPELL
	}
end


function modifier_troll_warlord_battle_trance_custom:GetModifierConstantHealthRegen()
if self:GetParent() ~= self:GetCaster() then return end 
if not self:GetParent():HasModifier("modifier_troll_trance_3") then return end
return (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())*self.heal
end 


function modifier_troll_warlord_battle_trance_custom:OnAttackStart(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	self.target = params.target
end

function modifier_troll_warlord_battle_trance_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_troll_warlord_battletrance.vpcf"
end

function modifier_troll_warlord_battle_trance_custom:StatusEffectPriority()
	return 10
end

function modifier_troll_warlord_battle_trance_custom:OnTakeDamage(params)
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.unit then return end
	if self:GetParent() ~= self:GetCaster() then return end
	if params.unit:IsBuilding() then return end
	if params.unit:IsIllusion() then return end
	if params.inflictor == nil then 
		local heal = params.damage*self.lifesteal
		
		my_game:GenericHeal(self:GetParent(), heal, self:GetAbility())
	end
end 

function modifier_troll_warlord_battle_trance_custom:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed
end

function modifier_troll_warlord_battle_trance_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.movement_speed
end

function modifier_troll_warlord_battle_trance_custom:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_troll_warlord_battle_trance_custom:GetMinHealth()
if self:GetParent():HasModifier("modifier_death") then return end
	return 1
end

modifier_troll_warlord_battle_trance_custom_debuff = class({})

function modifier_troll_warlord_battle_trance_custom_debuff:IsHidden()		return true end
function modifier_troll_warlord_battle_trance_custom_debuff:IgnoreTenacity()	return false end
function modifier_troll_warlord_battle_trance_custom_debuff:GetPriority()		return MODIFIER_PRIORITY_ULTRA end

function modifier_troll_warlord_battle_trance_custom_debuff:OnCreated()
	if not IsServer() then return end
	self:StartIntervalThink(FrameTime())
end

function modifier_troll_warlord_battle_trance_custom_debuff:OnIntervalThink()
	if not IsServer() then return end
	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 50, FrameTime(), true)
end





modifier_troll_warlord_battle_trance_custom_tracker = class({})
function modifier_troll_warlord_battle_trance_custom_tracker:IsHidden() return not self:GetParent():HasModifier("modifier_troll_trance_2") 
end
function modifier_troll_warlord_battle_trance_custom_tracker:IsPurgable() return false end
function modifier_troll_warlord_battle_trance_custom_tracker:GetTexture() return "buffs/trance_damage" end
function modifier_troll_warlord_battle_trance_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MIN_HEALTH,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_troll_warlord_battle_trance_custom_tracker:GetModifierTotalDamageOutgoing_Percentage()

local damage = self:GetCaster():GetTalentValue("modifier_troll_trance_2", "damage")
local k = 1 - self:GetParent():GetHealth()/self:GetParent():GetMaxHealth()

return damage * k
end


function modifier_troll_warlord_battle_trance_custom_tracker:GetMinHealth()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if self:GetParent():PassivesDisabled() then return end
if not self:GetParent():HasModifier("modifier_troll_trance_5") then return end
if self:GetParent():HasModifier("modifier_troll_warlord_battle_trance_custom_cd") then return end 

return 1
end

function modifier_troll_warlord_battle_trance_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end
if self:GetParent() ~= params.unit then return end
if not self:GetParent():HasModifier("modifier_troll_trance_5") then return end
if self:GetParent():GetHealth() > 1 then return end
if self:GetParent():HasModifier("modifier_troll_warlord_battle_trance_custom_cd") then return end 
if self:GetParent():HasModifier("modifier_troll_warlord_battle_trance_custom") then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_battle_trance_custom_cd", {duration = self:GetCaster():GetTalentValue("modifier_troll_trance_5", "cd")})

self:GetCaster():EmitSound("Hero_TrollWarlord.BattleTrance.Cast")

self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_battle_trance_custom", {duration = self:GetCaster():GetTalentValue("modifier_troll_trance_5", "duration")})
self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_troll_warlord_battle_trance_custom_effect", {duration = self:GetCaster():GetTalentValue("modifier_troll_trance_5", "duration")})
end






function modifier_troll_warlord_battle_trance_custom_tracker:GetAuraDuration()
	return 0.5
end


function modifier_troll_warlord_battle_trance_custom_tracker:GetAuraRadius()
if self:GetParent():HasModifier("modifier_troll_trance_4") then
	return self:GetCaster():GetTalentValue("modifier_troll_trance_4", "radius")
end

end

function modifier_troll_warlord_battle_trance_custom_tracker:GetAuraSearchFlags()
	return 0
end

function modifier_troll_warlord_battle_trance_custom_tracker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_troll_warlord_battle_trance_custom_tracker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


function modifier_troll_warlord_battle_trance_custom_tracker:GetModifierAura()
	return "modifier_troll_warlord_battle_trance_custom_aura"
end

function modifier_troll_warlord_battle_trance_custom_tracker:IsAura()
	return self:GetParent():HasModifier("modifier_troll_trance_4")
end



















modifier_troll_warlord_battle_trance_custom_aura = class({})
function modifier_troll_warlord_battle_trance_custom_aura:IsHidden() return false end
function modifier_troll_warlord_battle_trance_custom_aura:IsPurgable() return false end
function modifier_troll_warlord_battle_trance_custom_aura:GetTexture() return "buffs/trance_slow" end


function modifier_troll_warlord_battle_trance_custom_aura:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_troll_trance_4", "slow")

self.interval = self:GetCaster():GetTalentValue("modifier_troll_trance_4", "interval")
self.damage = self:GetCaster():GetTalentValue("modifier_troll_trance_4", "damage")/100

if not IsServer() then return end 

self.particle_peffect = ParticleManager:CreateParticle("particles/roshan_meteor_burn_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

self:StartIntervalThink(self.interval)

end

function modifier_troll_warlord_battle_trance_custom_aura:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_troll_warlord_battle_trance_custom_aura:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end


function modifier_troll_warlord_battle_trance_custom_aura:OnIntervalThink()
if not IsServer() then return end 


local damage = self.damage*(self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth()) *self.interval
if damage < 1 then return end

ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL})

end





modifier_troll_warlord_battle_trance_custom_cd = class({})
function modifier_troll_warlord_battle_trance_custom_cd:IsHidden() return false end
function modifier_troll_warlord_battle_trance_custom_cd:IsPurgable() return false end
function modifier_troll_warlord_battle_trance_custom_cd:RemoveOnDeath() return false end
function modifier_troll_warlord_battle_trance_custom_cd:IsDebuff() return true end
function modifier_troll_warlord_battle_trance_custom_cd:GetTexture() return "buffs/trance_cd" end
function modifier_troll_warlord_battle_trance_custom_cd:OnCreated(table)
self.RemoveForDuel = true 
end

modifier_troll_warlord_battle_trance_custom_effect = class({})
function modifier_troll_warlord_battle_trance_custom_effect:IsHidden() return true end
function modifier_troll_warlord_battle_trance_custom_effect:IsPurgable() return false end
function modifier_troll_warlord_battle_trance_custom_effect:GetEffectName() return "particles/huskar_grave.vpcf" end