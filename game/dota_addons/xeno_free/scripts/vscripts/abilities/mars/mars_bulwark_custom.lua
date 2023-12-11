LinkLuaModifier( "modifier_mars_bulwark_custom", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_idle", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_legendary", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_legendary_count", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_legendary_slow", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_legendary_proc", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_absorb_cd", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_face_buff", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_face_cd", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_taunt_aura", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_taunt_buff", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_taunt", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_bulwark_custom_str", "abilities/mars/mars_bulwark_custom", LUA_MODIFIER_MOTION_NONE )





mars_bulwark_custom = class({})



mars_bulwark_custom.active_block = {6,9,12}
mars_bulwark_custom.active_block_side = 0.5




function mars_bulwark_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf', context )
PrecacheResource( "particle", 'particles/qop_linken.vpcf', context )
PrecacheResource( "particle", 'particles/mars_revenge_proc.vpcf', context )
PrecacheResource( "particle", 'particles/mars_revenge_pre.vpcf', context )
PrecacheResource( "particle", 'particles/mars_revenge.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf', context )
PrecacheResource( "particle", 'particles/mars_revenge_proc_hands.vpcf', context )
PrecacheResource( "particle", 'particles/huskar_lowhp.vpc', context )
PrecacheResource( "particle", 'particles/mars_taunt_timer.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_beserkers_call.vpcf', context )
end





function mars_bulwark_custom:OnUpgrade()
if not IsServer() then return end

local ability = self:GetCaster():FindAbilityByName("mars_bulwark")
if ability then 
   ability:SetLevel(self:GetLevel())
   self:GetCaster():RemoveModifierByName("modifier_mars_bulwark")
end

end

function mars_bulwark_custom:OnToggle()
	local toggle = self:GetToggleState()

    if not IsServer() then return end

    local ability = self:GetCaster():FindAbilityByName("mars_bulwark")
    if ability then 
     	self:GetCaster():CastAbilityToggle(ability, 1)
    end

    if toggle then
        self.modifier = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_mars_bulwark_custom_idle", {} )
        --self:GetCaster():AddNewModifier( self:GetCaster(), nil, "modifier_mars_bulwark_active", {} )
      	
    else
        if self.modifier and not self.modifier:IsNull() then
            self.modifier:Destroy()
           -- self:GetCaster():RemoveModifierByName("modifier_mars_bulwark_active")
            self:StartCooldown(0.2)

        end
        self.modifier = nil
    end
end

function mars_bulwark_custom:GetIntrinsicModifierName()
	return "modifier_mars_bulwark_custom"
end

modifier_mars_bulwark_custom = class({})




function modifier_mars_bulwark_custom:IsHidden() return true end

function modifier_mars_bulwark_custom:IsPurgable()
	return false
end

function modifier_mars_bulwark_custom:OnCreated( kv )
	self.reduction_front = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
	self.reduction_side = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" ) / 2
	self.angle_side = self:GetAbility():GetSpecialValueFor( "side_angle" ) / 2
end

function modifier_mars_bulwark_custom:OnRefresh( kv )
	self.reduction_front = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
	self.reduction_side = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" ) / 2
	self.angle_side = self:GetAbility():GetSpecialValueFor( "side_angle" ) / 2
end

function modifier_mars_bulwark_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_RESPAWN
	}

	return funcs
end



function modifier_mars_bulwark_custom:OnAttackLanded(params)
if not IsServer() then return end 

if self:GetParent() ~= params.attacker then return end 
if not params.target:IsHero() then return end 
if params.target:IsCurrentlyHorizontalMotionControlled() or params.target:IsCurrentlyVerticalMotionControlled() then return end
if params.target:GetName() == "npc_teleport" then return end
if not self:GetParent():HasModifier("modifier_mars_scepter_damage") then return end 

local max_dist = self:GetAbility():GetSpecialValueFor("knockback_distance_custom")


local dir = self:GetParent():GetForwardVector()

params.target:AddNewModifier(caster, self, "modifier_generic_knockback",
	{
	  duration = 0.1,
	  distance = max_dist,
	  height = 0,
	  direction_x = dir.x,
	  direction_y = dir.y,
	}
)

end 


function modifier_mars_bulwark_custom:OnRespawn(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
   self:GetCaster():RemoveModifierByName("modifier_mars_bulwark")

end


function modifier_mars_bulwark_custom:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end
if self:GetParent():PassivesDisabled() then return end


local reduction = 0

local facing_direction = self:GetParent():GetAnglesAsVector().y

local attacker_vector = (params.attacker:GetOrigin() - self:GetParent():GetOrigin())

local attacker_direction = VectorToAngles( attacker_vector ).y

local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )

local angle_front = self:GetAbility():GetSpecialValueFor("forward_angle") / 2
local angle_side = self:GetAbility():GetSpecialValueFor("side_angle") / 2

local physical_damage_reduction = self:GetAbility():GetSpecialValueFor("physical_damage_reduction")
local physical_damage_reduction_side = self:GetAbility():GetSpecialValueFor("physical_damage_reduction_side")

if self:GetParent():HasModifier("modifier_mars_bulwark_2") then 
	physical_damage_reduction = physical_damage_reduction + self:GetAbility().active_block[self:GetParent():GetUpgradeStack("modifier_mars_bulwark_2")]
	physical_damage_reduction_side = physical_damage_reduction_side + self:GetAbility().active_block[self:GetParent():GetUpgradeStack("modifier_mars_bulwark_2")]*self:GetAbility().active_block_side
end

if angle_diff < angle_front then
	reduction = physical_damage_reduction


	if (params.attacker:IsHero() or params.attacker:IsCreep()) and not params.inflictor and self:GetParent():HasModifier("modifier_mars_bulwark_3") then 

		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_mars_bulwark_custom_str", {duration = self:GetCaster():GetTalentValue("modifier_mars_bulwark_3", "duration")})
	end 



elseif angle_diff < angle_side then
	reduction = physical_damage_reduction_side
end


if params.inflictor and not self:GetParent():HasModifier("modifier_mars_bulwark_7") then return 0 end

if reduction == 0 then 
	return 0
end

if angle_diff < angle_side then

	if angle_diff < angle_front and params.attacker:IsHero() then

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:ReleaseParticleIndex( particle )

		self:GetParent():EmitSound("Hero_Mars.Shield.Block")
	else 

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:ReleaseParticleIndex( particle )
		self:GetParent():EmitSound("Hero_Mars.Shield.BlockSmall")
	end
end


if params.inflictor then 
	reduction = reduction*self:GetCaster():GetTalentValue("modifier_mars_bulwark_7", "spell")/100
end


SendOverheadEventMessage(self:GetParent(), 8, self:GetParent(), params.damage*(reduction/100), nil)

if self:GetCaster():HasModifier("modifier_mars_bulwark_7") then 

	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_bulwark_custom_legendary_count", {duration = self:GetCaster():GetTalentValue("modifier_mars_bulwark_7", "duration"), stack = params.damage*(reduction/100)})
end

--[[
local mod = self:GetParent():FindModifierByName("modifier_mars_bulwark_custom_legendary")
if mod then 
	mod:AddStack(params.damage*(reduction/100)) 
end
--]]
if self:GetCaster():GetQuest() == "Mars.Quest_7" and params.attacker:IsRealHero() and not self:GetCaster():QuestCompleted() then 
	self:GetCaster():UpdateQuest(math.floor(params.damage*(reduction/100)))
end


return -reduction

end






function modifier_mars_bulwark_custom:GetAuraEntityReject(target)

local facing_direction = self:GetParent():GetAnglesAsVector().y
local attacker_vector = (target:GetOrigin() - self:GetParent():GetOrigin())
local attacker_direction = VectorToAngles( attacker_vector ).y
local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )
local angle_front = self:GetAbility():GetSpecialValueFor("forward_angle") / 2

if angle_diff > angle_front then 
	return true 
end

end

function modifier_mars_bulwark_custom:GetAuraDuration()
	return 0.5
end


function modifier_mars_bulwark_custom:GetAuraRadius()
if self:GetParent():HasModifier("modifier_mars_bulwark_6") then
	return self:GetCaster():GetTalentValue("modifier_mars_bulwark_6", "radius")
else 

	if self:GetParent():HasModifier("modifier_mars_bulwark_1") then
		return self:GetCaster():GetTalentValue("modifier_mars_bulwark_1", "radius")
	end 
end 

end

function modifier_mars_bulwark_custom:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE
end

function modifier_mars_bulwark_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_mars_bulwark_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


function modifier_mars_bulwark_custom:GetModifierAura()
	return "modifier_mars_bulwark_custom_taunt_buff"
end

function modifier_mars_bulwark_custom:IsAura()
if not self:GetParent():HasModifier("modifier_mars_bulwark_6") and not self:GetCaster():HasModifier("modifier_mars_bulwark_1") then return end 

	if self:GetParent():PassivesDisabled() then
		return false
	end

	if self:GetParent():IsInvisible() then return false end 
	if self:GetParent():IsInvulnerable() then return false end 

	return true
end













modifier_mars_bulwark_custom_idle = class({})

function modifier_mars_bulwark_custom_idle:IsPurgable() return true end
function modifier_mars_bulwark_custom_idle:IsHidden() return self:GetParent():HasScepter() end

function modifier_mars_bulwark_custom_idle:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_ABSORB_SPELL,
  		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
end



function modifier_mars_bulwark_custom_idle:GetModifierStatusResistanceStacking() 
local bonus = 0

if self:GetParent():HasModifier("modifier_mars_bulwark_5") then 
	bonus = self.status
end 

return bonus
end


function modifier_mars_bulwark_custom_idle:OnCreated(table)

self.status = self:GetCaster():GetTalentValue("modifier_mars_bulwark_5", "status")

if not IsServer() then return end

end

  






function modifier_mars_bulwark_custom_idle:GetAbsorbSpell(params) 
if not self:GetParent():HasModifier("modifier_mars_bulwark_5") then return end
if self:GetParent():HasModifier("modifier_mars_bulwark_custom_absorb_cd") then return end
if not params.ability or not params.ability:GetCaster() then return end
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if self:GetParent():PassivesDisabled() then return end

local facing_direction = self:GetParent():GetAnglesAsVector().y
local attacker_vector = (params.ability:GetCaster():GetOrigin() - self:GetParent():GetOrigin())
local attacker_direction = VectorToAngles( attacker_vector ).y
local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )
local angle_front = self:GetAbility():GetSpecialValueFor("forward_angle") / 2


if angle_diff > angle_front then return end


local particle = ParticleManager:CreateParticle("particles/qop_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_mars_bulwark_custom_absorb_cd", {duration = self:GetCaster():GetTalentValue("modifier_mars_bulwark_5", "cd")})

return 1 
end




function modifier_mars_bulwark_custom_idle:GetModifierDisableTurning()
	return 1
end

function modifier_mars_bulwark_custom_idle:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
	}
end

function modifier_mars_bulwark_custom_idle:GetModifierMoveSpeedBonus_Percentage()
if self:GetParent():HasScepter() then 
	return 0
end
	return self:GetAbility():GetSpecialValueFor("movespeed_active")
end

function modifier_mars_bulwark_custom_idle:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_mars_bulwark_custom_idle:GetActivityTranslationModifiers()
	return "bulwark"
end



modifier_mars_bulwark_custom_legendary = class({})
function modifier_mars_bulwark_custom_legendary:IsHidden() return true end
function modifier_mars_bulwark_custom_legendary:IsPurgable() return false end
function modifier_mars_bulwark_custom_legendary:RemoveOnDeath() return false end
function modifier_mars_bulwark_custom_legendary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(0)

self.ability = self:GetCaster():FindAbilityByName("mars_revenge_custom")
self.health_max = self:GetCaster():GetTalentValue("modifier_mars_bulwark_7", "health")

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_mars_bulwark_custom_legendary:OnStackCountChanged(iStackCount)
if not IsServer() then return end

end


function modifier_mars_bulwark_custom_legendary:AddStack(inc)
if not IsServer() then return end

self.max = self:GetParent():GetMaxHealth()*self.health_max
self:SetStackCount(math.max(0, self:GetStackCount() + inc))



if self:GetStackCount() >= self.max and not self:GetParent():HasModifier("modifier_mars_bulwark_custom_legendary_proc") then 
	self:GetParent():EmitSound("Mars.Revenge_ready")

	local particle_peffect = ParticleManager:CreateParticle("particles/mars_revenge_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_mars_bulwark_custom_legendary_proc", {})

end

end




function modifier_mars_bulwark_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.ability:SetActivated(self:GetStackCount() ~= 0)

self.max = self:GetParent():GetMaxHealth()*self.health_max


if self:GetStackCount() < self.max then 
	if self:GetParent():HasModifier("modifier_mars_bulwark_custom_legendary_proc") then 
		self:GetParent():RemoveModifierByName('modifier_mars_bulwark_custom_legendary_proc')
	end
end



CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'mars_shield_change',  {max = self.max, damage = self:GetStackCount()})


end


mars_revenge_custom = class({})

function mars_revenge_custom:GetCastAnimation()
return 
end

function mars_revenge_custom:OnAbilityPhaseStart()

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 0.3)
self:GetCaster():EmitSound("Mars.Revenge_pre")

local mod = self:GetCaster():FindModifierByName("modifier_mars_bulwark_custom_legendary")
self.damage = 0

if mod then 
	self.damage = self:GetCaster():GetUpgradeStack("modifier_mars_bulwark_custom_legendary")
end 

local particle_cast = "particles/mars_revenge_pre.vpcf"
self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetSpecialValueFor("radius"), 0, -self:GetSpecialValueFor("radius") ))
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( 0.6, 0.6, 0.6 ) )

return true
end


function mars_revenge_custom:OnAbilityPhaseInterrupted()

self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)

ParticleManager:DestroyParticle(self.effect_cast, true)
ParticleManager:ReleaseParticleIndex(self.effect_cast)
end


function mars_revenge_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_4)

ParticleManager:DestroyParticle(self.effect_cast, true)
ParticleManager:ReleaseParticleIndex(self.effect_cast)


self:GetCaster():EmitSound("Mars.Revenge_end")

local caster = self:GetCaster()
local radius = self:GetSpecialValueFor("radius")
local angle = 80/2

local particle_cast = "particles/mars_revenge.vpcf"
local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector(radius, radius, radius) )
ParticleManager:ReleaseParticleIndex( effect_cast )


local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

for _,mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_mars_bulwark_custom_legendary_count")) do 
	mod:Destroy()
end 



local damage = self.damage

for _,enemy in pairs(enemies) do

  local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"

  local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, enemy )
  ParticleManager:SetParticleControl( effect_cast, 0, enemy:GetOrigin() )
  ParticleManager:SetParticleControl( effect_cast, 1, enemy:GetOrigin() )
  ParticleManager:SetParticleControlForward( effect_cast, 1, (enemy:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized() )
  ParticleManager:ReleaseParticleIndex( effect_cast )

  enemy:AddNewModifier(self:GetCaster(), self, "modifier_mars_bulwark_custom_legendary_slow", {duration = (1 - enemy:GetStatusResistance())*self:GetSpecialValueFor("slow_duration")})

  ApplyDamage({ victim = enemy, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self })
  SendOverheadEventMessage(enemy, 6, enemy, damage, nil)
end



end




modifier_mars_bulwark_custom_legendary_slow = class({})
function modifier_mars_bulwark_custom_legendary_slow:IsHidden() return false end
function modifier_mars_bulwark_custom_legendary_slow:IsPurgable() return true end
function modifier_mars_bulwark_custom_legendary_slow:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_mars_bulwark_custom_legendary_slow:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end





function modifier_mars_bulwark_custom_legendary_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_mars_bulwark_custom_legendary_slow:GetEffectName()
  return "particles/units/heroes/hero_brewmaster/brewmaster_thunder_clap_debuff.vpcf"
end
function modifier_mars_bulwark_custom_legendary_slow:GetStatusEffectName()
  return "particles/status_fx/status_effect_brewmaster_thunder_clap.vpcf"
end


function modifier_mars_bulwark_custom_legendary_slow:StatusEffectPriority()
  return 2
end



modifier_mars_bulwark_custom_legendary_proc = class({})
function modifier_mars_bulwark_custom_legendary_proc:IsHidden() return true end
function modifier_mars_bulwark_custom_legendary_proc:IsPurgable() return false end
function modifier_mars_bulwark_custom_legendary_proc:RemoveOnDeath() return false end
function modifier_mars_bulwark_custom_legendary_proc:GetEffectName() return "particles/mars_revenge_proc_hands.vpcf" end



modifier_mars_bulwark_custom_absorb_cd = class({})
function modifier_mars_bulwark_custom_absorb_cd:IsHidden() return false end
function modifier_mars_bulwark_custom_absorb_cd:IsPurgable() return false end
function modifier_mars_bulwark_custom_absorb_cd:RemoveOnDeath() return false end
function modifier_mars_bulwark_custom_absorb_cd:IsDebuff() return true end
function modifier_mars_bulwark_custom_absorb_cd:GetTexture() return "buffs/bulwark_reflect" end
function modifier_mars_bulwark_custom_absorb_cd:OnCreated()
if not IsServer() then return end
self.RemoveForDuel = true
end


modifier_mars_bulwark_custom_face_buff = class({})
function modifier_mars_bulwark_custom_face_buff:IsHidden() return self:GetStackCount() == 1
end
function modifier_mars_bulwark_custom_face_buff:IsPurgable() return false end
function modifier_mars_bulwark_custom_face_buff:RemoveOnDeath() return false end
function modifier_mars_bulwark_custom_face_buff:GetTexture() return "buffs/bulwark_face" end
function modifier_mars_bulwark_custom_face_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_mars_bulwark_custom_face_buff:GetModifierTotalDamageOutgoing_Percentage()
if self:GetStackCount() == 1 then return end
return self:GetCaster():GetTalentValue("modifier_mars_bulwark_4", "damage")
end



function modifier_mars_bulwark_custom_face_buff:OnCreated(table)

self.timer = self:GetCaster():GetTalentValue("modifier_mars_bulwark_4", "timer")

if not IsServer() then return end

self:SetStackCount(1)
self:StartIntervalThink(self.timer)
end


function modifier_mars_bulwark_custom_face_buff:OnTakeDamage(params)
if not IsServer() then return end
if not params.attacker then return end

if (self:GetStackCount() == 0) and self:GetParent() == params.attacker and (params.unit:IsHero() or params.unit:IsCreep())
	and  bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and not params.unit:IsIllusion() then 

	local heal = self:GetCaster():GetTalentValue("modifier_mars_bulwark_4", "heal")*params.damage/100 

	if params.unit:IsCreep() then 
		heal = heal/self:GetCaster():GetTalentValue("modifier_mars_bulwark_4", "creeps")
	end 

	self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end 



if self:GetParent() ~= params.unit then return end

local facing_direction = self:GetParent():GetAnglesAsVector().y
local attacker_vector = (params.attacker:GetOrigin() - self:GetParent():GetOrigin())
local attacker_direction = VectorToAngles( attacker_vector ).y
local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )
local angle_front = self:GetAbility():GetSpecialValueFor("forward_angle") / 2

local angle_side = self:GetAbility():GetSpecialValueFor("side_angle") / 2



if angle_diff > angle_front and angle_diff > angle_side  then 
	if self:GetStackCount() == 0 then 
		self:SetStackCount(1)
	end
	self:StartIntervalThink(self.timer) 
end 


		



end


function modifier_mars_bulwark_custom_face_buff:OnIntervalThink()
if not IsServer() then return end

if self:GetStackCount() == 0 then 
	self:SetStackCount(1)
else 
	self:SetStackCount(0)
	self:StartIntervalThink(-1)
end

end


function modifier_mars_bulwark_custom_face_buff:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if self:GetStackCount() == 0 then 
	self:GetParent():EmitSound("Huskar.Passive_LowHp")

	self.pfx = ParticleManager:CreateParticle("particles/huskar_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.pfx, false, false, -1, false, false)
else 
	if (self.pfx) then 
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

end



modifier_mars_bulwark_custom_face_cd = class({})
function modifier_mars_bulwark_custom_face_cd:IsHidden() return false end
function modifier_mars_bulwark_custom_face_cd:IsPurgable() return false end






modifier_mars_bulwark_custom_taunt_aura = class({})



function modifier_mars_bulwark_custom_taunt_aura:IsHidden() return true end
function modifier_mars_bulwark_custom_taunt_aura:IsPurgable() return false end
function modifier_mars_bulwark_custom_taunt_aura:IsDebuff() return false end
function modifier_mars_bulwark_custom_taunt_aura:RemoveOnDeath() return false end




modifier_mars_bulwark_custom_taunt_buff = class({})
function modifier_mars_bulwark_custom_taunt_buff:IsHidden() return false end
function modifier_mars_bulwark_custom_taunt_buff:IsPurgable() return false end
function modifier_mars_bulwark_custom_taunt_buff:GetTexture() return "buffs/bulwark_taunt" end
function modifier_mars_bulwark_custom_taunt_buff:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_mars_bulwark_1", "slow")
self.damage = self:GetCaster():GetTalentValue("modifier_mars_bulwark_1", "damage")/100


if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_mars_bulwark_1") then 
	self.particle_peffect = ParticleManager:CreateParticle("particles/roshan_meteor_burn_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())	
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end


self.timer = self:GetCaster():GetTalentValue("modifier_mars_bulwark_6", "timer")

self:SetStackCount(0)
self.count = 0
self.max = 1
self.interval = 0.5
self:StartIntervalThink(self.interval)
end


function modifier_mars_bulwark_custom_taunt_buff:OnIntervalThink()
if not IsServer() then return end

--[[

local victim_angle = self:GetParent():GetAnglesAsVector().y
local origin_difference = self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()

local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)

origin_difference_radian = origin_difference_radian * 180
local attacker_angle = origin_difference_radian / math.pi
attacker_angle = attacker_angle + 180.0
		
local result_angle = attacker_angle - victim_angle
result_angle = math.abs(result_angle)
		
local k = 1
if (result_angle >= 110) and (result_angle <= 260)  then 
--	k = self:GetAbility().taunt_back
end



	
]]--

if self:GetCaster():HasModifier("modifier_mars_bulwark_1") then 

	local damage = self.damage*self:GetCaster():GetAverageTrueAttackDamage(nil)*self.interval

	ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL,  ability = self:GetAbility()})

end
		

self.count = self.count + self.interval

if self.count >= self.max then 
	self.count = 0
else 
	return
end

if not self:GetCaster():HasModifier("modifier_mars_bulwark_6") then return end
if self:GetParent():HasModifier("modifier_mars_bulwark_custom_taunt") then return end 
if self:GetParent():IsCreep() then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.timer then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_mars_bulwark_custom_taunt", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_mars_bulwark_6", "taunt")})
	self:SetStackCount(0)
end


end

function modifier_mars_bulwark_custom_taunt_buff:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then 
	if self.effect_cast then 
		ParticleManager:DestroyParticle(self.effect_cast, false)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
	end 
	return 
end

if self:GetStackCount() == 1 then 
	self.effect_cast = ParticleManager:CreateParticle( "particles/mars_taunt_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
end

if not self.effect_cast then return end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )


end


function modifier_mars_bulwark_custom_taunt_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
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

self:GetParent():EmitSound("Hero_Axe.Berserkers_Call")
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
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
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
self.move = self:GetCaster():GetTalentValue("modifier_mars_bulwark_3", "move")
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
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
}
end


function modifier_mars_bulwark_custom_str:GetModifierBonusStats_Strength()
return self.str*self:GetStackCount()
end


function modifier_mars_bulwark_custom_str:GetModifierMoveSpeedBonus_Percentage()
return self.move*self:GetStackCount()
end


modifier_mars_bulwark_custom_legendary_count = class({})
function modifier_mars_bulwark_custom_legendary_count:IsHidden() return true end
function modifier_mars_bulwark_custom_legendary_count:IsPurgable() return false end
function modifier_mars_bulwark_custom_legendary_count:RemoveOnDeath() return false end
function modifier_mars_bulwark_custom_legendary_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_mars_bulwark_custom_legendary_count:OnCreated(table)
if not IsServer() then return end 

self:SetStackCount(table.stack)
local mod = self:GetParent():FindModifierByName("modifier_mars_bulwark_custom_legendary")

if not mod then return end
mod:AddStack(self:GetStackCount())

end 

function modifier_mars_bulwark_custom_legendary_count:OnDestroy()
if not IsServer() then return end 

local mod = self:GetParent():FindModifierByName("modifier_mars_bulwark_custom_legendary")

if not mod then return end
mod:AddStack(-self:GetStackCount())
end 