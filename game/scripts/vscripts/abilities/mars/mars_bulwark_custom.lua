LinkLuaModifier( "modifier_mars_bulwark_custom", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_idle", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_face_buff", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_face_cd", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_taunt_buff", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_taunt", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_str", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_leash", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_soldier", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_soldier_cd", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_lowhp", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )





mars_bulwark_custom = class({})




function mars_bulwark_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/mars/bulwark_legendary_attack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf", context )
PrecacheResource( "particle", "particles/mars_revenge_proc.vpcf", context )
PrecacheResource( "particle", "particles/mars_revenge_proc_hands.vpcf", context )
PrecacheResource( "particle", "particles/huskar_lowhp.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/sange_maim.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf", context )
end


function mars_bulwark_custom:CreateTalent(name)
if not IsServer() then return end 

if name == "modifier_mars_bulwark_4" then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_mars_bulwark_custom_soldier_cd", {})
end 

end 




function mars_bulwark_custom:GetIntrinsicModifierName()
	return "modifier_mars_bulwark_custom"
end


function mars_bulwark_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_mars_bulwark_custom_idle") then 
    return "mars_bulwark_stop"
end 

return "mars_bulwark"
end 


function mars_bulwark_custom:GetCooldown(iLevel)
if self:GetCaster():HasTalent("modifier_mars_bulwark_7") then
	return self:GetCaster():GetTalentValue("modifier_mars_bulwark_7", "cd")
end

return
end



function mars_bulwark_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_mars_bulwark_7") then 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 

return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function mars_bulwark_custom:OnUpgrade()
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("mars_bulwark")
if ability then 
   ability:SetLevel(self:GetLevel())
   self:GetCaster():RemoveModifierByName("modifier_mars_bulwark")
end

end




function mars_bulwark_custom:CheckAngle(target)

local result = 0
local caster = self:GetCaster()
local facing_direction = caster:GetAnglesAsVector().y
local attacker_vector = (target:GetOrigin() - caster:GetOrigin())
local attacker_direction = VectorToAngles( attacker_vector ).y
local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )
local angle_front = self:GetSpecialValueFor("forward_angle") / 2
local angle_side = self:GetSpecialValueFor("side_angle") / 2



if angle_diff < angle_front then
	result = 1
elseif angle_diff < angle_side then
	result = 2
end

return result
end


function mars_bulwark_custom:GetReduction(params)

local caster = self:GetCaster()
local result = self:CheckAngle(params.attacker)
local break_effect = 1

if caster:HasModifier("modifier_mars_bulwark_custom_lowhp") then 
	result = 1

	if caster:PassivesDisabled() then
		break_effect = caster:GetTalentValue("modifier_mars_bulwark_5", "break_effect")/100
	end 
else 
	if caster:PassivesDisabled() then return 0 end
end 

local reduction = self:GetSpecialValueFor("physical_damage_reduction")*-1
local reduction_side = self:GetSpecialValueFor("physical_damage_reduction_side")*-1
local k = reduction_side/reduction

reduction = reduction + caster:GetTalentValue("modifier_mars_bulwark_2", "damage_reduce")
local spell = caster:GetTalentValue("modifier_mars_bulwark_2", "spell_damage")


if result == 0 then return 0 end


if params.inflictor then 

	if not caster:HasTalent("modifier_mars_bulwark_2") then 
		return 0 
	end

	if result == 1 then 
		return spell*break_effect
	elseif result == 2 then
		return spell*k
	end
end

if result == 1 then 
	return reduction*break_effect
elseif result == 2 then
	return reduction*k
end

end




function mars_bulwark_custom:OnSpellStart()
local caster = self:GetCaster()

local mod = caster:FindModifierByName("modifier_mars_bulwark_custom_idle")

if mod then 
	mod:Destroy()
	return
end 

self.modifier = caster:AddNewModifier( caster, self, "modifier_mars_bulwark_custom_idle", {} )

self:EndCooldown()
self:StartCooldown(0.2)
end





modifier_mars_bulwark_custom_idle = class({})

function modifier_mars_bulwark_custom_idle:IsPurgable() return false end
function modifier_mars_bulwark_custom_idle:IsHidden() return true end

function modifier_mars_bulwark_custom_idle:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_IS_SCEPTER 
}
end

function modifier_mars_bulwark_custom_idle:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
end


function modifier_mars_bulwark_custom_idle:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.shield_talent = "modifier_mars_bulwark_7"
self.max_shield = self.parent:GetTalentValue("modifier_mars_bulwark_7", "shield")*self.parent:GetMaxHealth()/100
self.damage_bonus = self.parent:GetTalentValue("modifier_mars_bulwark_7", "damage") - 100

if not IsServer() then return end

self:SetStackCount(self.max_shield)

self.RemoveForDuel = true

local ability = self.parent:FindAbilityByName("mars_bulwark")
if ability then 
 	self.parent:CastAbilityToggle(ability, 1)
end

end

  

function modifier_mars_bulwark_custom_idle:OnDestroy()
if not IsServer() then return end

self.ability:UseResources(false, false, false, true)

local ability = self.parent:FindAbilityByName("mars_bulwark")
if ability then 
 	self.parent:CastAbilityToggle(ability, 1)
end

end



function modifier_mars_bulwark_custom_idle:GetModifierIncomingDamageConstant( params )

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
     	return self:GetStackCount()
    end 
end

if not IsServer() then return end

local k = (1 + self.ability:GetReduction(params)/100)

local damage = math.min(params.damage, self:GetStackCount())
local real_damage = math.min(params.damage*k, self:GetStackCount())

self.parent:AddShieldInfo({shield_mod = self, healing = real_damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - real_damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end
return -damage
end






function modifier_mars_bulwark_custom_idle:GetModifierDamageOutgoing_Percentage()
if not self.parent:HasModifier("modifier_mars_scepter_damage") then return end 
	return self.damage_bonus
end



function modifier_mars_bulwark_custom_idle:GetModifierScepter() return 1 end















modifier_mars_bulwark_custom = class({})


function modifier_mars_bulwark_custom:IsHidden() return true end
function modifier_mars_bulwark_custom:IsPurgable() return false end

function modifier_mars_bulwark_custom:OnCreated( kv )

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:AddDamageEvent_out(self)
self.parent:AddAttackEvent_out(self)
self.parent:AddRespawnEvent(self)

self.damage_timer = self.parent:GetTalentValue("modifier_mars_bulwark_1", "timer", true)

self.legendary_duration = self.parent:GetTalentValue("modifier_mars_bulwark_7", "duration", true)

self.str_duration = self.parent:GetTalentValue("modifier_mars_bulwark_3", "duration", true)

self.taunt_radius = self.parent:GetTalentValue("modifier_mars_bulwark_6", "radius", true)

self.lowhp_health = self.parent:GetTalentValue("modifier_mars_bulwark_5", "health", true)

self.soldier_duration = self.parent:GetTalentValue("modifier_mars_bulwark_4", "duration", true)
self.soldier_count = self.parent:GetTalentValue("modifier_mars_bulwark_4", "count", true)
self.soldier_cd = self.parent:GetTalentValue("modifier_mars_bulwark_4", "cd", true)
self.soldier_heal = self.parent:GetTalentValue("modifier_mars_bulwark_4", "heal", true)/100
self.damage_count = 0

if not IsServer() then return end 
self:StartIntervalThink(1)
end


function modifier_mars_bulwark_custom:DeclareFunctions()
local funcs = {
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
}

return funcs
end



function modifier_mars_bulwark_custom:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasTalent("modifier_mars_bulwark_1") and not self.parent:HasTalent("modifier_mars_bulwark_5") then return end

if self.parent:HasTalent("modifier_mars_bulwark_5") then

	if self.parent:GetHealthPercent() <= self.lowhp_health and not self.parent:HasModifier("modifier_mars_bulwark_custom_lowhp") then 
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_mars_bulwark_custom_lowhp", {})
	end

	if self.parent:GetHealthPercent() > self.lowhp_health and self.parent:HasModifier("modifier_mars_bulwark_custom_lowhp") then 
		self.parent:RemoveModifierByName("modifier_mars_bulwark_custom_lowhp")
	end
end 


if not self.parent:HasTalent("modifier_mars_bulwark_1") then return end
if self.parent:HasModifier("modifier_mars_bulwark_custom_face_cd") then return end 
if self.parent:HasModifier("modifier_mars_bulwark_custom_face_buff") then return end 

self.parent:AddNewModifier(self.parent, self.ability, "modifier_mars_bulwark_custom_face_buff", {})

self:StartIntervalThink(0.1)
end


function modifier_mars_bulwark_custom:DamageEvent_out(params)
if not IsServer() then return end 
if not params.unit:IsUnit() then return end 

if params.attacker:HasModifier("modifier_mars_bulwark_custom_soldier") then 
	self.parent:GenericHeal(params.damage*self.soldier_heal, self.ability, true, nil, "modifier_mars_bulwark_4")
end 

end 



function modifier_mars_bulwark_custom:AttackEvent_out(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() then return end

if self.parent:HasTalent("modifier_mars_bulwark_4") then 

	local mod = self.parent:FindModifierByName("modifier_mars_bulwark_custom_soldier_cd")
	if mod and mod:GetStackCount() <= 0 then 

		mod:SetStackCount(self.soldier_cd)
		local unit = CreateUnitByName( "mars_arena_soldier", params.target:GetAbsOrigin() + RandomVector(150), true, self.parent, self.parent, self.parent:GetTeamNumber() )
		unit.owner = self.parent
		unit:SetForceAttackTarget(params.target)
		
		Timers:CreateTimer(0.2, function()
			if unit and not unit:IsNull() then 
				unit:SetForceAttackTarget(nil)
			end
		end)

		unit:AddNewModifier(self.parent, self.ability, "modifier_mars_bulwark_custom_soldier", {})
		unit:AddNewModifier(self.parent, self.ability, "modifier_kill", {duration = self.soldier_duration})
		unit:EmitSound("Mars.Soldier_spawn")
	end
end 


if not self.parent:HasModifier("modifier_mars_scepter_damage") then return end 

local abs = params.target:GetAbsOrigin() - self.parent:GetForwardVector()*150

local particle = ParticleManager:CreateParticle( "particles/mars/bulwark_legendary_attack.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl(particle, 0, abs)
ParticleManager:SetParticleControlForward(particle, 0, self.parent:GetForwardVector())
ParticleManager:ReleaseParticleIndex( particle )

params.target:AddNewModifier(self.parent, self.ability, "modifier_mars_bulwark_custom_leash", {duration = self.legendary_duration})
end 




function modifier_mars_bulwark_custom:RespawnEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
self:GetCaster():RemoveModifierByName("modifier_mars_bulwark")

end




function modifier_mars_bulwark_custom:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end


local target = params.attacker
local attacker = params.attacker
local result = self.ability:CheckAngle(target)
local reduction = self.ability:GetReduction(params)

local lowhp_mod = self.parent:FindModifierByName("modifier_mars_bulwark_custom_lowhp")
local mod = self.parent:FindModifierByName("modifier_mars_bulwark_custom_soldier_cd")

if self.parent:HasTalent("modifier_mars_bulwark_4") and mod and mod:GetStackCount() > 0 then 

	self.damage_count = self.damage_count + params.original_damage

	if self.damage_count >= self.soldier_count then 
	  local delta = math.floor(self.damage_count/self.soldier_count)
	  mod:SetStackCount(math.max(0, mod:GetStackCount() - delta))

	  self.damage_count = self.damage_count - delta*self.soldier_count
	end 
end 


if result == 0 and self.parent:HasTalent("modifier_mars_bulwark_1") then 
	self.parent:RemoveModifierByName("modifier_mars_bulwark_custom_face_buff")
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_mars_bulwark_custom_face_cd", {duration = self.damage_timer})
end 

if result == 1 then
	if (params.attacker:IsHero() or params.attacker:IsCreep()) and self.parent:HasTalent("modifier_mars_bulwark_3") then 
		self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_mars_bulwark_custom_str", {duration = self.str_duration})
	end 
end

if self.parent:PassivesDisabled() and not lowhp_mod then return end
if params.inflictor and not self.parent:HasTalent("modifier_mars_bulwark_2") then return 0 end

if result == 1 or result == 2 or lowhp_mod then
	local sound = "Hero_Mars.Shield.Block"
	local effect = "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"

	if result == 2 or attacker:IsCreep() then
		sound = "Hero_Mars.Shield.BlockSmall"
		effect = "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf"
	end

	self.parent:EmitSound(sound)
	self.parent:GenericParticle(effect)
	self.parent:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
else
	return
end

SendOverheadEventMessage(self.parent, 8, self.parent, params.damage*(reduction/100), nil)

if self:GetCaster():GetQuest() == "Mars.Quest_7" and params.attacker:IsRealHero() and not self:GetCaster():QuestCompleted() then 
	self:GetCaster():UpdateQuest(math.floor(params.damage*(-1*reduction/100)))
end

return reduction
end




function modifier_mars_bulwark_custom:GetAuraEntityReject(target)
return self.ability:CheckAngle(target) ~= 1 
end


function modifier_mars_bulwark_custom:GetAuraDuration()
return 0.5
end

function modifier_mars_bulwark_custom:GetAuraRadius()
if self.parent:HasTalent("modifier_mars_bulwark_6") then
	return self.taunt_radius
end 

end

function modifier_mars_bulwark_custom:GetAuraSearchFlags()
return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
end

function modifier_mars_bulwark_custom:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_mars_bulwark_custom:GetAuraSearchType()
return DOTA_UNIT_TARGET_HERO
end


function modifier_mars_bulwark_custom:GetModifierAura()
return "modifier_mars_bulwark_custom_taunt_buff"
end


function modifier_mars_bulwark_custom:IsAura()
if not self.parent:HasTalent("modifier_mars_bulwark_6") then return end 
if self.parent:IsInvisible() then return false end 
if self.parent:IsInvulnerable() then return false end 

return true
end








modifier_mars_bulwark_custom_face_buff = class({})
function modifier_mars_bulwark_custom_face_buff:IsHidden() return false end
function modifier_mars_bulwark_custom_face_buff:IsPurgable() return false end
function modifier_mars_bulwark_custom_face_buff:GetTexture() return "buffs/bulwark_face" end
function modifier_mars_bulwark_custom_face_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_mars_bulwark_custom_face_buff:GetModifierDamageOutgoing_Percentage()
return self.damage
end

function modifier_mars_bulwark_custom_face_buff:GetModifierSpellAmplify_Percentage()
return self.damage
end

function modifier_mars_bulwark_custom_face_buff:GetModifierMoveSpeedBonus_Constant()
return self.move
end


function modifier_mars_bulwark_custom_face_buff:OnCreated(table)

self.parent = self:GetParent()
self.damage = self:GetCaster():GetTalentValue("modifier_mars_bulwark_1", "damage")
self.move = self:GetCaster():GetTalentValue("modifier_mars_bulwark_1", "move")

if not IsServer() then return end

self.parent:EmitSound("Huskar.Passive_LowHp")

self.pfx = ParticleManager:CreateParticle("particles/huskar_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
self:AddParticle(self.pfx, false, false, -1, false, false)
end



modifier_mars_bulwark_custom_face_cd = class({})
function modifier_mars_bulwark_custom_face_cd:IsHidden() return false end
function modifier_mars_bulwark_custom_face_cd:IsPurgable() return false end
function modifier_mars_bulwark_custom_face_cd:RemoveOnDeath() return false end
function modifier_mars_bulwark_custom_face_cd:GetTexture() return "buffs/bulwark_face" end
function modifier_mars_bulwark_custom_face_cd:IsDebuff() return true end








modifier_mars_bulwark_custom_taunt_buff = class({})
function modifier_mars_bulwark_custom_taunt_buff:IsHidden() return false end
function modifier_mars_bulwark_custom_taunt_buff:IsPurgable() return false end
function modifier_mars_bulwark_custom_taunt_buff:GetTexture() return "buffs/bulwark_taunt" end
function modifier_mars_bulwark_custom_taunt_buff:OnCreated(table)

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.timer = self.caster:GetTalentValue("modifier_mars_bulwark_6", "timer")
self.taunt = self.caster:GetTalentValue("modifier_mars_bulwark_6", "taunt")
self.slow = self.caster:GetTalentValue("modifier_mars_bulwark_6", "slow")

if not IsServer() then return end
self:SetStackCount(0)
self:StartIntervalThink(1)
end


function modifier_mars_bulwark_custom_taunt_buff:OnIntervalThink()
if not IsServer() then return end
if self.parent:HasModifier("modifier_mars_bulwark_custom_taunt") then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.timer then 
	self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_mars_bulwark_custom_taunt", {duration = (1 - self.parent:GetStatusResistance())*self.taunt})
	self:SetStackCount(0)
end

end


function modifier_mars_bulwark_custom_taunt_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_mars_bulwark_custom_taunt_buff:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end





modifier_mars_bulwark_custom_taunt = class({})

function modifier_mars_bulwark_custom_taunt:IsPurgable()
	return false
end
function modifier_mars_bulwark_custom_taunt:IsHidden()
	return true
end

function modifier_mars_bulwark_custom_taunt:OnCreated( kv )
if not IsServer() then return end

self:GetParent():SetForceAttackTarget( self:GetCaster() )
self:GetParent():MoveToTargetToAttack( self:GetCaster() )

self:GetParent():EmitSound("UI.Generic_taunt")
self:StartIntervalThink(FrameTime())
end

function modifier_mars_bulwark_custom_taunt:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetCaster():IsAlive() then
		self:Destroy()
	end
end

function modifier_mars_bulwark_custom_taunt:OnDestroy()
if not IsServer() then return end

self:GetParent():SetForceAttackTarget( nil )
	
end

function modifier_mars_bulwark_custom_taunt:CheckState()
	local state = {
		[MODIFIER_STATE_TAUNTED] = true,
	}

	return state
end

function modifier_mars_bulwark_custom_taunt:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end






modifier_mars_bulwark_custom_str = class({})
function modifier_mars_bulwark_custom_str:IsHidden() return false end
function modifier_mars_bulwark_custom_str:IsPurgable() return false end
function modifier_mars_bulwark_custom_str:GetTexture() return "buffs/bulwark_str" end
function modifier_mars_bulwark_custom_str:OnCreated()
self.str = self:GetCaster():GetTalentValue("modifier_mars_bulwark_3", "str")
self.agi = self:GetCaster():GetTalentValue("modifier_mars_bulwark_3", "agi")
self.max = self:GetCaster():GetTalentValue("modifier_mars_bulwark_3", "max")

if not IsServer() then return end 

self:SetStackCount(1)

self:GetCaster():CalculateStatBonus(true)
end 

function modifier_mars_bulwark_custom_str:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()

self:GetCaster():CalculateStatBonus(true)

end 
function modifier_mars_bulwark_custom_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end


function modifier_mars_bulwark_custom_str:GetModifierBonusStats_Strength()
return self.str*self:GetStackCount()
end


function modifier_mars_bulwark_custom_str:GetModifierBonusStats_Agility()
return self.agi*self:GetStackCount()
end










modifier_mars_bulwark_custom_leash = class({})
function modifier_mars_bulwark_custom_leash:IsHidden() return true end
function modifier_mars_bulwark_custom_leash:IsPurgable() return true end
function modifier_mars_bulwark_custom_leash:OnCreated()
self.caster = self:GetCaster()
self.slow = self.caster:GetTalentValue("modifier_mars_bulwark_7", "slow")

if not IsServer() then return end 

for i = 1,2 do 
	local particles = ParticleManager:CreateParticle("particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(particles, false, false, -1, false, false)
end

end

function modifier_mars_bulwark_custom_leash:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_mars_bulwark_custom_leash:CheckState()
return
{
	[MODIFIER_STATE_TETHERED] = true
}
end

function modifier_mars_bulwark_custom_leash:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_mars_bulwark_custom_leash:GetEffectName()
return "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf"
end

function modifier_mars_bulwark_custom_leash:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_mars_bulwark_custom_leash:GetStatusEffectName()
return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_mars_bulwark_custom_leash:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL
end












modifier_mars_bulwark_custom_soldier = class({})
function modifier_mars_bulwark_custom_soldier:IsHidden() return false end
function modifier_mars_bulwark_custom_soldier:IsPurgable() return false end

function modifier_mars_bulwark_custom_soldier:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}
end


function modifier_mars_bulwark_custom_soldier:OnCreated(table)

self.caster = self:GetCaster()
self.damage_k = self:GetCaster():GetTalentValue("modifier_mars_bulwark_4", "damage")/100
self.damage = 0
self.speed = self:GetCaster():GetTalentValue("modifier_mars_bulwark_4", "interval")

if not IsServer() then return end

self:OnIntervalThink()
self:StartIntervalThink(0.2)
end


function modifier_mars_bulwark_custom_soldier:OnIntervalThink()
if not IsServer() then return end
if not self.caster or self.caster:IsNull() then return end

self.damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*self.damage_k
end

function modifier_mars_bulwark_custom_soldier:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_FIXED_ATTACK_RATE
}
end

function modifier_mars_bulwark_custom_soldier:GetModifierPreAttack_BonusDamage()
return self.damage
end


function modifier_mars_bulwark_custom_soldier:GetModifierFixedAttackRate()
return self.speed
end







modifier_mars_bulwark_custom_soldier_cd = class({})
function modifier_mars_bulwark_custom_soldier_cd:IsHidden() return true end
function modifier_mars_bulwark_custom_soldier_cd:IsPurgable() return false end
function modifier_mars_bulwark_custom_soldier_cd:IsDebuff() return true end
function modifier_mars_bulwark_custom_soldier_cd:RemoveOnDeath() return false end
function modifier_mars_bulwark_custom_soldier_cd:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.parent:GetTalentValue("modifier_mars_bulwark_4", "cd")
self:SetStackCount(0)

self:StartIntervalThink(FrameTime())
end


function modifier_mars_bulwark_custom_soldier_cd:OnIntervalThink()
if not IsServer() then return end 

if self:GetStackCount() > 0 then 
  self:DecrementStackCount()
end


end 


function modifier_mars_bulwark_custom_soldier_cd:OnStackCountChanged(iStackCount)
if not IsServer() then return end 

local stack = self.max - self:GetStackCount()
self.parent:UpdateUIlong({max = self.max, stack = stack, style = "MarsBulwark", override_stack = self:GetStackCount(), hide_number = stack >= self.max, no_min = true})

if self:GetStackCount() <= 0 then 
  self:StartIntervalThink(FrameTime())
else 
  self:StartIntervalThink(1)
end 

end






modifier_mars_bulwark_custom_lowhp = class({})
function modifier_mars_bulwark_custom_lowhp:IsHidden() return true end
function modifier_mars_bulwark_custom_lowhp:IsPurgable() return false end
function modifier_mars_bulwark_custom_lowhp:OnCreated()
self.parent = self:GetParent()
self.heal = self.parent:GetTalentValue("modifier_mars_bulwark_5", "heal")

if not IsServer() then return end 


self.buff_particles = {}
self.parent:EmitSound("UI.Generic_shield")

self.buff_particles[1] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)

end

function modifier_mars_bulwark_custom_lowhp:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_mars_bulwark_custom_lowhp:GetModifierHealthRegenPercentage()
return self.heal
end