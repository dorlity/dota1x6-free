LinkLuaModifier( "modifier_generic_arc", "modifiers/generic/modifier_generic_arc", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_buff", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_debuff", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_move_speed", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_move_heal", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_move_passive", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_legendary", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_attack_speed", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_attack_speed_effect", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_attack_speed_effect", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_illusion", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_heavenly_jump_custom_quest", "abilities/zuus/zuus_heavenly_jump_custom" , LUA_MODIFIER_MOTION_NONE)


zuus_heavenly_jump_custom = class({})

zuus_heavenly_jump_custom.distance_range = {100, 150, 200}
zuus_heavenly_jump_custom.distance_speed = {10, 15, 20}
zuus_heavenly_jump_custom.distance_speed_duration = 3

zuus_heavenly_jump_custom.damage_targets = {1, 2, 3}
zuus_heavenly_jump_custom.damage_bonus = {0.2, 0.3, 0.4}

zuus_heavenly_jump_custom.heal_duration = 4
zuus_heavenly_jump_custom.heal_amount = {10, 15, 20}

zuus_heavenly_jump_custom.legendary_bva = 1.5
zuus_heavenly_jump_custom.legendary_attacks = 4
zuus_heavenly_jump_custom.legendary_duration = 10
zuus_heavenly_jump_custom.legendary_slow = 0.5

zuus_heavenly_jump_custom.speed_attack = {12, 20}
zuus_heavenly_jump_custom.speed_max = 8
zuus_heavenly_jump_custom.speed_duration = 5
zuus_heavenly_jump_custom.speed_max_cdr = {10, 15}

zuus_heavenly_jump_custom.illusion_radius = 400
zuus_heavenly_jump_custom.illusion_silence = 2
zuus_heavenly_jump_custom.illusion_duration = 2.5

zuus_heavenly_jump_custom.cd_reduction = -2
zuus_heavenly_jump_custom.cd_slow = 0.4


zuus_heavenly_jump_custom_legendary = class({})

function zuus_heavenly_jump_custom_legendary:OnSpellStart()
if not IsServer() then return end
self:GetCaster():FindAbilityByName("zuus_heavenly_jump_custom"):Jump()

end

zuus_heavenly_jump_custom_legendary_2 = class({})

function zuus_heavenly_jump_custom_legendary_2:OnSpellStart()
if not IsServer() then return end
self:GetCaster():FindAbilityByName("zuus_heavenly_jump_custom"):Jump()

end



function zuus_heavenly_jump_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/zuus_shard.vpcf', context )
PrecacheResource( "particle", 'particles/zuus_glow.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf', context )
PrecacheResource( "particle", 'particles/zuus_speed.vpcf', context )
PrecacheResource( "particle", 'particles/zuus_heal.vpcf', context )
PrecacheResource( "particle", 'particles/zuus_jump_count.vpcf', context )
PrecacheResource( "particle", 'particles/zuus_speed_max.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_mjollnir_shield.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf', context )
PrecacheResource( "particle", 'particles/huskar_timer.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf', context )

end



function zuus_heavenly_jump_custom:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_zuus_jump_5") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function zuus_heavenly_jump_custom_legendary:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_zuus_jump_5") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function zuus_heavenly_jump_custom_legendary_2:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_zuus_jump_5") then 
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
	return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function zuus_heavenly_jump_custom:GetAOERadius()
return self:GetSpecialValueFor("range")
end


function zuus_heavenly_jump_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_zuus_jump_5") then 
  bonus = self.cd_reduction
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end


function zuus_heavenly_jump_custom:GetIntrinsicModifierName()
return "modifier_zuus_heavenly_jump_custom_move_passive"
end


function zuus_heavenly_jump_custom:Jump()
if not IsServer() then return end

	local height = self:GetSpecialValueFor("hop_height")
	local distance = self:GetSpecialValueFor("hop_distance")

	self:GetCaster():EmitSound("Hero_Zuus.StaticField")

	if self:GetCaster():HasModifier("modifier_zuus_jump_1") then 
		distance = distance + self.distance_range[self:GetCaster():GetUpgradeStack("modifier_zuus_jump_1")]
	end

	local hop_duration = self:GetSpecialValueFor("hop_duration")
	local range = self:GetSpecialValueFor("range")



	local direction = self:GetCaster():GetForwardVector()


	AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), 900, 3, false)


	if self:GetCaster():HasModifier("modifier_zuus_jump_6") then 

	  	local illusion_self = CreateIllusions(self:GetCaster(), self:GetCaster(), {
	    outgoing_damage = 0,
	    duration    = self.illusion_duration
	    }, 1, 0, false, false)

	    local point = self:GetCaster():GetAbsOrigin()
	    for _,illusion in pairs(illusion_self) do

	      illusion.owner = caster

	      illusion:AddNewModifier(self:GetCaster(), self, "modifier_zuus_heavenly_jump_custom_illusion",  {duration = self.illusion_duration})
	      illusion:SetOrigin(GetGroundPosition(point, nil))

	    end
	end

	local arc = self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_generic_arc",{ dir_x = direction.x,dir_y = direction.y,duration = hop_duration,distance = distance,height = height,fix_end = false,isStun = true,isForward = true,activity = ACT_DOTA_CAST_ABILITY_3,})


	if arc then 
 		arc:SetEndCallback(function()

 			if self:GetCaster():HasModifier("modifier_zuus_jump_1") then 
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_heavenly_jump_custom_move_speed", {duration = self.distance_speed_duration})
			end

			if self:GetCaster():HasModifier("modifier_zuus_jump_3") then 
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_heavenly_jump_custom_move_heal", {duration = self.heal_duration})
			end

			if self:GetCaster():HasModifier("modifier_zuus_jump_7") then 
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_heavenly_jump_custom_legendary", {duration = self.legendary_duration})
			end

			if self:GetCaster():GetQuest() == "Zuus.Quest_7" and not self:GetCaster():QuestCompleted() then 
				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_heavenly_jump_custom_quest", {duration = self:GetCaster().quest.number})
			end

		end)
	end

	local flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS
	if self:GetCaster():HasModifier("modifier_zuus_jump_5") then 
		flags = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end

	local units = {}
	local units_heroes = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO , flags, FIND_CLOSEST, false)
	local units_creeps = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC ,  flags, FIND_CLOSEST, false)
		

	if #units_heroes > 0 then 
		for i = 1, #units_heroes do 
			units[#units + 1] = units_heroes[i]
		end
	end
	if #units_creeps > 0 then 
		for i = 1, #units_creeps do 
			units[#units + 1] = units_creeps[i]
		end
	end

	if #units == 0 then return end

	local max_targets = 1
	if self:GetCaster():HasModifier("modifier_zuus_jump_2") then 
		max_targets = max_targets + self.damage_targets[self:GetCaster():GetUpgradeStack("modifier_zuus_jump_2")]
	end

	max_targets = math.min(max_targets, #units)

	if self:GetCaster():HasModifier("modifier_zuus_jump_4") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_heavenly_jump_custom_attack_speed", {duration = self.speed_duration})
	end

	for i = 1,max_targets do 
		self:DealDamage(units[i], false, false)
	end
end



function zuus_heavenly_jump_custom:DealDamage(target, no_effect, not_cast, new_slow)
if not IsServer() then return end

local damage = self:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_zuus_jump_2") then 
	damage = damage + self:GetCaster():GetAverageTrueAttackDamage(nil)*self.damage_bonus[self:GetCaster():GetUpgradeStack("modifier_zuus_jump_2")]
end

local duration = self:GetSpecialValueFor("duration")
if self:GetCaster():HasModifier("modifier_zuus_jump_5") then 
	duration = duration + self.cd_slow
end

if new_slow then 
	duration = new_slow
end


target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_zuus_jump_5")), "modifier_zuus_heavenly_jump_custom_debuff", {duration = duration})
ApplyDamage({ victim = target, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, damage_flags = DOTA_DAMAGE_FLAG_NONE, attacker = self:GetCaster(), ability = self })
target:EmitSound("Hero_Zuus.ArcLightning.Target")

if no_effect then return end

local thunder = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_shard.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(thunder, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(thunder, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)

local self_particle = ParticleManager:CreateParticle("particles/zuus_glow.vpcf", PATTACH_POINT, self:GetCaster())
ParticleManager:SetParticleControlEnt(self_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self_particle, 2, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)


	
end


function zuus_heavenly_jump_custom:OnSpellStart()
if not IsServer() then return end
	self:Jump()
end



modifier_zuus_heavenly_jump_custom_debuff = class({})

function modifier_zuus_heavenly_jump_custom_debuff:OnCreated()
local ability = self:GetCaster():FindAbilityByName("zuus_heavenly_jump_custom")
if not ability then return end

self.move_slow = ability:GetSpecialValueFor("move_slow") * -1
self.aspd_slow = ability:GetSpecialValueFor("aspd_slow") * -1
end



function modifier_zuus_heavenly_jump_custom_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

function modifier_zuus_heavenly_jump_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow
end

function modifier_zuus_heavenly_jump_custom_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.aspd_slow
end


--particles/units/heroes/hero_zuus/zuus_shard.vpcf

function modifier_zuus_heavenly_jump_custom_debuff:GetEffectName() return "particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf" end

function modifier_zuus_heavenly_jump_custom_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


modifier_zuus_heavenly_jump_custom_move_speed = class({})

function modifier_zuus_heavenly_jump_custom_move_speed:IsHidden() return false end
function modifier_zuus_heavenly_jump_custom_move_speed:IsPurgable() return true end
function modifier_zuus_heavenly_jump_custom_move_speed:GetTexture() return "buffs/jump_move" end

function modifier_zuus_heavenly_jump_custom_move_speed:OnCreated(table)
if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/zuus_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
self:AddParticle( effect_cast, false, false, -1, false, false)
end





function modifier_zuus_heavenly_jump_custom_move_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_zuus_heavenly_jump_custom_move_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().distance_speed[self:GetCaster():GetUpgradeStack("modifier_zuus_jump_1")]
end






modifier_zuus_heavenly_jump_custom_move_heal = class({})
function modifier_zuus_heavenly_jump_custom_move_heal:IsHidden() return false end
function modifier_zuus_heavenly_jump_custom_move_heal:IsPurgable() return true end
function modifier_zuus_heavenly_jump_custom_move_heal:GetTexture() return "buffs/jump_heal" end

function modifier_zuus_heavenly_jump_custom_move_heal:OnCreated(table)
self.heal = self:GetAbility().heal_amount[self:GetParent():GetUpgradeStack("modifier_zuus_jump_3")]/self:GetRemainingTime()
if not IsServer() then return end

self:StartIntervalThink(1)
end

function modifier_zuus_heavenly_jump_custom_move_heal:OnIntervalThink()
if not IsServer() then return end
local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal*self:GetParent():GetMaxHealth()/100, nil)
end


function modifier_zuus_heavenly_jump_custom_move_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end
function modifier_zuus_heavenly_jump_custom_move_heal:GetModifierHealthRegenPercentage()
return self.heal
end

function modifier_zuus_heavenly_jump_custom_move_heal:GetEffectName() return "particles/zuus_heal.vpcf" end

function modifier_zuus_heavenly_jump_custom_move_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end





modifier_zuus_heavenly_jump_custom_move_passive = class({})
function modifier_zuus_heavenly_jump_custom_move_passive:IsHidden() return true end
function modifier_zuus_heavenly_jump_custom_move_passive:IsPurgable() return false end
function modifier_zuus_heavenly_jump_custom_move_passive:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
}
end

function modifier_zuus_heavenly_jump_custom_move_passive:GetModifierBaseAttackTimeConstant()
if not self:GetParent():HasModifier("modifier_zuus_jump_7") then return end
return self:GetAbility().legendary_bva
end


modifier_zuus_heavenly_jump_custom_legendary = class({})
function modifier_zuus_heavenly_jump_custom_legendary:IsHidden() return false end
function modifier_zuus_heavenly_jump_custom_legendary:IsPurgable() return false end

function modifier_zuus_heavenly_jump_custom_legendary:OnCreated(table)
if not IsServer() then return end

local name = "particles/zuus_jump_count.vpcf"
self.particle = ParticleManager:CreateParticle(name, PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)


self:SetStackCount(self:GetAbility().legendary_attacks)
end


function modifier_zuus_heavenly_jump_custom_legendary:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetAbility().legendary_attacks)
end


function modifier_zuus_heavenly_jump_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_zuus_heavenly_jump_custom_legendary:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.target:IsMagicImmune() then return end

self:GetAbility():DealDamage(params.target, false, true, self:GetAbility().legendary_slow)
self:DecrementStackCount()

if self:GetStackCount() == 0 then 
	self:Destroy()
end

end


function modifier_zuus_heavenly_jump_custom_legendary:OnTooltip()
return self:GetStackCount()
end




function modifier_zuus_heavenly_jump_custom_legendary:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.particle then return end

for i = 1,self:GetAbility().legendary_attacks do 
    
    if i <= self:GetStackCount() then 
        ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))   
    else 
        ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))   
    end
end

end








modifier_zuus_heavenly_jump_custom_attack_speed = class({})
function modifier_zuus_heavenly_jump_custom_attack_speed:IsHidden() return false end
function modifier_zuus_heavenly_jump_custom_attack_speed:IsPurgable() return false end 
function modifier_zuus_heavenly_jump_custom_attack_speed:GetTexture() return "buffs/jump_speed" end


function modifier_zuus_heavenly_jump_custom_attack_speed:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_zuus_heavenly_jump_custom_attack_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().speed_max then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().speed_max then 
	

	self:GetParent():EmitSound("Zuus.Jump_speed")
	local effect_cast = ParticleManager:CreateParticle( "particles/zuus_speed_max.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
	self:AddParticle( effect_cast, false, false, -1, false, false)


	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_zuus_heavenly_jump_custom_attack_speed_effect", {})
	
end


end


function modifier_zuus_heavenly_jump_custom_attack_speed:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveModifierByName("modifier_zuus_heavenly_jump_custom_attack_speed_effect")
end



function modifier_zuus_heavenly_jump_custom_attack_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
}
end 

function modifier_zuus_heavenly_jump_custom_attack_speed:GetModifierPercentageCooldown() 
if self:GetStackCount() < self:GetAbility().speed_max then return end
	return self:GetAbility().speed_max_cdr[self:GetCaster():GetUpgradeStack("modifier_zuus_jump_4")]
end
   
function modifier_zuus_heavenly_jump_custom_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility().speed_attack[self:GetCaster():GetUpgradeStack("modifier_zuus_jump_4")]*self:GetStackCount()
end

modifier_zuus_heavenly_jump_custom_attack_speed_effect = class({})
function modifier_zuus_heavenly_jump_custom_attack_speed_effect:IsHidden() return true end
function modifier_zuus_heavenly_jump_custom_attack_speed_effect:IsPurgable() return false end
function modifier_zuus_heavenly_jump_custom_attack_speed_effect:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_zuus_heavenly_jump_custom_attack_speed_effect:StatusEffectPriority() return 11111 end



modifier_zuus_heavenly_jump_custom_illusion = class({})
function modifier_zuus_heavenly_jump_custom_illusion:IsHidden() return true end
function modifier_zuus_heavenly_jump_custom_illusion:IsPurgable() return false end
function modifier_zuus_heavenly_jump_custom_illusion:CheckState()
return
{
  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
  [MODIFIER_STATE_NO_HEALTH_BAR] = true,
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_INVULNERABLE] = true,
  [MODIFIER_STATE_UNTARGETABLE] = true,
  [MODIFIER_STATE_UNSELECTABLE] = true,
  [MODIFIER_STATE_OUT_OF_GAME] = true,
}
end

function modifier_zuus_heavenly_jump_custom_illusion:OnCreated(table)
if not IsServer() then return end
self:GetParent():StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)

local particle_cast = "particles/units/heroes/hero_stormspirit/stormspirit_static_remnant.vpcf"
local sound_cast = "Hero_StormSpirit.StaticRemnantPlant"

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )

self:AddParticle( effect_cast, false, false, -1, false, false)
self:GetParent():EmitSound(sound_cast)

self.t = -1
self.timer = self:GetRemainingTime()*2 
self:StartIntervalThink(0.5)
self:OnIntervalThink()
end


function modifier_zuus_heavenly_jump_custom_illusion:OnIntervalThink()
if not IsServer() then return end
  self.t = self.t + 1
  local caster = self:GetParent()

        local number = (self.timer-self.t)/2 
        local int = 0
        int = number
       if number % 1 ~= 0 then int = number - 0.5  end

        local digits = math.floor(math.log10(number)) + 2

        local decimal = number % 1

        if decimal == 0.5 then
            decimal = 8
        else 
            decimal = 1
        end

local particleName = "particles/huskar_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end



function modifier_zuus_heavenly_jump_custom_illusion:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}

end
function modifier_zuus_heavenly_jump_custom_illusion:GetOverrideAnimation()
return ACT_DOTA_GENERIC_CHANNEL_1
end
function modifier_zuus_heavenly_jump_custom_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_zuus_heavenly_jump_custom_illusion:StatusEffectPriority() return 11111 end


function modifier_zuus_heavenly_jump_custom_illusion:OnDestroy()
if not IsServer() then return end

local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().illusion_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , 0, FIND_CLOSEST, false)
	

local particle_explode_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_stasis_trap_explode.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle_explode_fx, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_explode_fx, 1, Vector(self:GetAbility().illusion_radius, 1, 1))
ParticleManager:SetParticleControl(particle_explode_fx, 3, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_explode_fx)

self:GetParent():EmitSound("Zuus.Jump_illusion")

for _,unit in pairs(units) do 

	self:GetAbility():DealDamage(unit, true, true)

	unit:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self:GetAbility(), self:GetCaster():HasModifier("modifier_zuus_jump_5")), "modifier_generic_silence", {duration = (1 - unit:GetStatusResistance())*self:GetAbility().illusion_silence})
end

end



modifier_zuus_heavenly_jump_custom_quest = class({})
function modifier_zuus_heavenly_jump_custom_quest:IsHidden() return true end
function modifier_zuus_heavenly_jump_custom_quest:IsPurgable() return false end