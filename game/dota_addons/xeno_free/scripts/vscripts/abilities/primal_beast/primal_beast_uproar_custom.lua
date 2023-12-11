LinkLuaModifier( "modifier_primal_beast_uproar_custom", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_buff", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_debuff", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_speed", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_legendary", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_bkb", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_root", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_proc", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_taunt", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_taunt_cd", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primal_beast_uproar_custom_taunt_heal", "abilities/primal_beast/primal_beast_uproar_custom", LUA_MODIFIER_MOTION_NONE )

primal_beast_uproar_custom = class({})



primal_beast_uproar_custom.stats_damage = {6,9,12}
primal_beast_uproar_custom.stats_speed = {2,3,4}

primal_beast_uproar_custom.taunt_health = 30
primal_beast_uproar_custom.taunt_cd = 30
primal_beast_uproar_custom.taunt_radius = 600
primal_beast_uproar_custom.taunt_duration = 2
primal_beast_uproar_custom.taunt_heal = 15


primal_beast_uproar_custom.proc_speed = 300
primal_beast_uproar_custom.proc_bonus = {1, 2}
primal_beast_uproar_custom.proc_crit = {130, 180}
primal_beast_uproar_custom.proc_duration = 7
primal_beast_uproar_custom.proc_max = 3
primal_beast_uproar_custom.proc_health = 0.25

primal_beast_uproar_custom.cast_heal = {0.015, 0.02, 0.025}

primal_beast_blood_frenzy_custom = class({})




function primal_beast_uproar_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_meepo/meepo_ransack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_roar_aoe.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_roar.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_uproar_magic_resist.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_legion_commander_duel.vpcf', context )
PrecacheResource( "particle", 'particles/beast_grave.vpcf', context )
PrecacheResource( "particle", 'particles/beast_hands.vpcf', context )
PrecacheResource( "particle", 'particles/beast_root.vpcf', context )
PrecacheResource( "particle", 'particles/beast_proc.vpcf', context )
PrecacheResource( "particle", 'particles/beast_blood.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_bloodrage.vpcf', context )

end




function primal_beast_uproar_custom:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function primal_beast_uproar_custom:GetAbilityTextureName(  )
	local stack = self:GetCaster():GetModifierStackCount( "modifier_primal_beast_uproar_custom", self:GetCaster() )
	if stack==0 then
		return "primal_beast_uproar_none"
	elseif stack == self:GetSpecialValueFor("stack_limit") then
		return "primal_beast_uproar_max"
	else
		return "primal_beast_uproar_mid"
	end
end

function primal_beast_uproar_custom:IsRefreshable()
	return false
end

function primal_beast_uproar_custom:GetIntrinsicModifierName()
	return "modifier_primal_beast_uproar_custom"
end

function primal_beast_uproar_custom:CastFilterResult()
	if self:GetCaster():GetModifierStackCount( "modifier_primal_beast_uproar_custom", self:GetCaster() ) < 1 then
		return UF_FAIL_CUSTOM
	end
	if self:GetCaster():HasModifier("modifier_primal_beast_uproar_custom_buff") then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function primal_beast_uproar_custom:GetCustomCastError( hTarget )
	if self:GetCaster():GetModifierStackCount( "modifier_primal_beast_uproar_custom", self:GetCaster() ) < 1 then
		return "#dota_hud_error_no_uproar_stacks"
	end
	if self:GetCaster():HasModifier("modifier_primal_beast_uproar_custom_buff") then
		return "#dota_hud_error_already_roared"
	end
	return ""
end








function primal_beast_uproar_custom:OnSpellStart()
	if not IsServer() then return end

	local duration = self:GetSpecialValueFor( "roar_duration" )
	local radius = self:GetSpecialValueFor( "radius" )
	local slow = self:GetSpecialValueFor( "slow_duration" )


	local stack = 0
	local modifier = self:GetCaster():FindModifierByName( "modifier_primal_beast_uproar_custom" )
	if modifier then
		stack = modifier:GetStackCount()
		modifier:ResetStack()
	end

	if self:GetCaster():HasModifier("modifier_primal_beast_uproar_2") then 

		local heal = self.cast_heal[self:GetCaster():GetUpgradeStack("modifier_primal_beast_uproar_2")] *stack*self:GetCaster():GetMaxHealth()


		self:GetCaster():Heal(heal, self:GetCaster())
		SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)

		local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
		ParticleManager:ReleaseParticleIndex( particle )
	end


	if self:GetCaster():HasModifier("modifier_primal_beast_uproar_4") then 

		duration = duration + self.proc_bonus[self:GetCaster():GetUpgradeStack("modifier_primal_beast_uproar_4")]
	--	self:GetCaster():Purge(false, true, false, false, false)
	--	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_uproar_custom_bkb", {duration = self.bkb_duration})
	end

	if self:GetCaster():HasModifier("modifier_primal_beast_uproar_1") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_uproar_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_1", "duration")})
	end

	local ult = self:GetCaster():FindAbilityByName("primal_beast_pulverize_custom")
	if ult and stack == self:GetCaster():GetTalentValue("modifier_primal_beast_pulverize_7", "uproar") and self:GetCaster():HasModifier("modifier_primal_beast_pulverize_7") then 
		ult:AddLegendaryStack()
	end 

	local frenzy = self:GetCaster():FindAbilityByName("primal_beast_blood_frenzy_custom")
	if frenzy and frenzy:GetCooldownTimeRemaining() < duration then
		--frenzy:StartCooldown(duration)
	end

	self:StartCooldown(duration)
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_uproar_custom_buff", { duration = duration, stack = stack } )

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

	for _,enemy in pairs(enemies) do
		if self:GetCaster():HasModifier("modifier_primal_beast_uproar_5") then 
			enemy:EmitSound("PBeast.Uproar_root")
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_uproar_custom_root", {duration = self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_5", "root")*(1 - enemy:GetStatusResistance()), stack = stack })
		else 
			enemy:AddNewModifier( self:GetCaster(), self, "modifier_primal_beast_uproar_custom_debuff", { duration = slow*(1 - enemy:GetStatusResistance()), stack = stack } )
		end
	end

	self:PlayEffects( radius )
	self:PlayEffects2()
end

function primal_beast_uproar_custom:PlayEffects( radius )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_roar_aoe.vpcf", PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	self:GetCaster():EmitSound("Hero_PrimalBeast.Uproar.Cast")
end

function primal_beast_uproar_custom:PlayEffects2()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_roar.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_jaw_fx", Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end


modifier_primal_beast_uproar_custom = class({})

function modifier_primal_beast_uproar_custom:IsHidden()
	return self:GetStackCount() < 1
end

function modifier_primal_beast_uproar_custom:IsPurgable()
	return false
end

function modifier_primal_beast_uproar_custom:RemoveOnDeath()
	return false
end

function modifier_primal_beast_uproar_custom:DestroyOnExpire()
	return false
end

function modifier_primal_beast_uproar_custom:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	if not IsServer() then return end
	self.damage_count = 0
	self.damage_attack_count = 0

	self.damage_limit = self:GetAbility():GetSpecialValueFor( "damage_limit" )
	self.stack_limit = self:GetAbility():GetSpecialValueFor( "stack_limit" )
	self.duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )
end

function modifier_primal_beast_uproar_custom:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	if not IsServer() then return end
	self.damage_limit = self:GetAbility():GetSpecialValueFor( "damage_limit" )
	self.stack_limit = self:GetAbility():GetSpecialValueFor( "stack_limit" )
	self.duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )	
end

function modifier_primal_beast_uproar_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

function modifier_primal_beast_uproar_custom:OnTakeDamage( params )
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end
local damage = params.damage


if self:GetParent():HasModifier("modifier_primal_beast_uproar_6") then 

	if self:GetParent():GetHealthPercent() < self:GetAbility().taunt_health and 
		not self:GetParent():PassivesDisabled() and 
		not self:GetParent():HasModifier("modifier_primal_beast_uproar_custom_taunt_cd") then 

		self:GetAbility():PlayEffects(self:GetAbility().taunt_radius)

		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_primal_beast_uproar_custom_taunt_heal", {duration = self:GetAbility().taunt_duration})
		
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_primal_beast_uproar_custom_taunt_cd", {duration = self:GetAbility().taunt_cd})
		
		local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().taunt_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

		for _,enemy in pairs(enemies) do 
			if enemy:GetUnitName() ~= "npc_teleport" then
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_primal_beast_uproar_custom_taunt", {duration = (1 - enemy:GetStatusResistance())*self:GetAbility().taunt_duration})
			end
		end
	
	end

end



if self:GetParent():HasModifier("modifier_primal_beast_uproar_4") and not self:GetParent():HasModifier("modifier_primal_beast_uproar_custom_proc") then 

	local max = self:GetParent():GetMaxHealth()*self:GetAbility().proc_health 

	self.damage_attack_count = self.damage_attack_count + damage
	if self.damage_attack_count >= max then 
		self.damage_attack_count = 0
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_primal_beast_uproar_custom_proc", {duration = self:GetAbility().proc_duration})
	end
end


if self:GetParent():HasModifier( "modifier_primal_beast_uproar_custom_buff" ) and not self:GetParent():HasModifier("modifier_primal_beast_uproar_custom_legendary")  then return end


local max = self.damage_limit

local stack_limit = self.stack_limit
	

if self:GetParent():HasModifier("modifier_primal_beast_uproar_custom_legendary") then 
	stack_limit = 99999
end



while damage > 0 do 
	self.damage_count = damage + self.damage_count

	if self.damage_count < max then 
	    damage = 0
    else 
	    damage =  self.damage_count - max
	    self.damage_count = 0

		if self:GetStackCount() < stack_limit then
			self:IncrementStackCount()
			if self:GetStackCount() == self.stack_limit then
				self:GetParent():EmitSound("Hero_PrimalBeast.Uproar.MaxStacks")
			end
		end

		self:SetDuration( self.duration, true )
		self:StartIntervalThink(self.duration)
	end
end




end

function modifier_primal_beast_uproar_custom:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function modifier_primal_beast_uproar_custom:OnIntervalThink()
	self:ResetStack()
end

function modifier_primal_beast_uproar_custom:ResetStack()
	self:SetStackCount(0)
end

modifier_primal_beast_uproar_custom_buff = class({})

function modifier_primal_beast_uproar_custom_buff:IsPurgable()
	return false
end

function modifier_primal_beast_uproar_custom_buff:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_per_stack" )
	self.armor = self:GetAbility():GetSpecialValueFor( "roared_bonus_armor" )
	if not IsServer() then return end
	self:SetStackCount(self:GetStackCount() + kv.stack)
	self:PlayEffects()
end


function modifier_primal_beast_uproar_custom_buff:OnRefresh( kv )
	self:OnCreated(kv)
end

function modifier_primal_beast_uproar_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}

	return funcs
end

function modifier_primal_beast_uproar_custom_buff:GetModifierPreAttack_BonusDamage()
local bonus = self.damage
if self:GetParent():HasModifier("modifier_primal_beast_uproar_3") then 
	bonus = bonus + self:GetAbility().stats_damage[self:GetParent():GetUpgradeStack("modifier_primal_beast_uproar_3")]
end 
	return bonus * self:GetStackCount()
end



function modifier_primal_beast_uproar_custom_buff:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if self:GetParent():HasModifier("modifier_primal_beast_uproar_3") then 
	bonus = self:GetAbility().stats_speed[self:GetParent():GetUpgradeStack("modifier_primal_beast_uproar_3")]
end 
	return bonus * self:GetStackCount()
end



function modifier_primal_beast_uproar_custom_buff:GetModifierPhysicalArmorBonus()
	return self.armor * self:GetStackCount()
end

function modifier_primal_beast_uproar_custom_buff:PlayEffects()
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_primal_beast/primal_beast_uproar_magic_resist.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt( effect_cast, 2, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	self:AddParticle( effect_cast, false, false, -1, false, false )
end

modifier_primal_beast_uproar_custom_debuff = class({})

function modifier_primal_beast_uproar_custom_debuff:IsPurgable()
	return true
end

function modifier_primal_beast_uproar_custom_debuff:GetTexture()
	return "primal_beast_uproar"
end

function modifier_primal_beast_uproar_custom_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" ) + self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_5", "slow")
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end

function modifier_primal_beast_uproar_custom_debuff:OnRefresh( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" ) + self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_5", "slow")
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end

function modifier_primal_beast_uproar_custom_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_primal_beast_uproar_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.slow * self:GetStackCount()
end

function modifier_primal_beast_uproar_custom_debuff:GetStatusEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf"
end

function modifier_primal_beast_uproar_custom_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end


modifier_primal_beast_uproar_custom_speed = class({})
function modifier_primal_beast_uproar_custom_speed:IsHidden() return false end
function modifier_primal_beast_uproar_custom_speed:IsPurgable() return false end
function modifier_primal_beast_uproar_custom_speed:GetTexture() return "buffs/uproar_speed" end
function modifier_primal_beast_uproar_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_primal_beast_uproar_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_primal_beast_uproar_custom_speed:GetModifierAttackRangeBonus()
return self.range
end


function modifier_primal_beast_uproar_custom_speed:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self:SetDuration(self.duration, true)

end



function modifier_primal_beast_uproar_custom_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_1", "speed")
self.range = self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_1", "range")
self.duration = self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_1", "duration")

end 








function primal_beast_blood_frenzy_custom:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_7", "cd")
end



function primal_beast_blood_frenzy_custom:OnSpellStart()
if not IsServer() then return end 

self:GetCaster():EmitSound("PBeast.Uproar_legendary")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_primal_beast_uproar_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_7", "duration")})
end




modifier_primal_beast_uproar_custom_legendary = class({})

function modifier_primal_beast_uproar_custom_legendary:IsHidden() return false end
function modifier_primal_beast_uproar_custom_legendary:IsPurgable() return false end

function modifier_primal_beast_uproar_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_legion_commander_duel.vpcf"
end

function modifier_primal_beast_uproar_custom_legendary:StatusEffectPriority()
return 111111
end


function modifier_primal_beast_uproar_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MIN_HEALTH
}
end

function modifier_primal_beast_uproar_custom_legendary:GetMinHealth()
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_death") then return end
return 1
end

function modifier_primal_beast_uproar_custom_legendary:CheckState()
return
{
	--[MODIFIER_STATE_STUNNED] = true,
	--[MODIFIER_STATE_SILENCED] = true,
	--[MODIFIER_STATE_MUTED] = true,

}
end


function modifier_primal_beast_uproar_custom_legendary:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

local roar = self:GetCaster():FindAbilityByName("primal_beast_uproar_custom")
local modifier = self:GetCaster():FindModifierByName( "modifier_primal_beast_uproar_custom" )
if roar and modifier and modifier:GetStackCount() > 0 then 
	roar:OnSpellStart()
end

--self:GetCaster():FadeGesture(ACT_DOTA_VICTORY)
end

function modifier_primal_beast_uproar_custom_legendary:GetEffectName() return "particles/beast_grave.vpcf" end

function modifier_primal_beast_uproar_custom_legendary:OnCreated(table)
if not IsServer() then return end


local effect_cast = ParticleManager:CreateParticle( "particles/beast_hands.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( effect_cast, 2, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
self:AddParticle( effect_cast, false, false, -1, false, false )

--self:GetCaster():StartGesture(ACT_DOTA_VICTORY)
self:GetCaster():EmitSound("Hero_PrimalBeast.Uproar.Cast")
end


modifier_primal_beast_uproar_custom_bkb = class({})
function modifier_primal_beast_uproar_custom_bkb:IsHidden() return false end
function modifier_primal_beast_uproar_custom_bkb:IsPurgable() return false end
function modifier_primal_beast_uproar_custom_bkb:GetTexture() return "buffs/uproar_bkb" end
function modifier_primal_beast_uproar_custom_bkb:CheckState()
return
{
	[MODIFIER_STATE_MAGIC_IMMUNE] = true
}
end
function modifier_primal_beast_uproar_custom_bkb:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end


modifier_primal_beast_uproar_custom_root = class({})
function modifier_primal_beast_uproar_custom_root:IsHidden() return false end
function modifier_primal_beast_uproar_custom_root:IsPurgable() return true end
function modifier_primal_beast_uproar_custom_root:OnCreated(table)
if not IsServer() then return end
self.stack = table.stack

end

function modifier_primal_beast_uproar_custom_root:OnDestroy()
if not IsServer() then return end

local duration = (self:GetAbility():GetSpecialValueFor("slow_duration") + self:GetCaster():GetTalentValue("modifier_primal_beast_uproar_5", "duration"))*(1 - self:GetParent():GetStatusResistance())

self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_primal_beast_uproar_custom_debuff", { duration = duration, stack = self.stack } )
end

function modifier_primal_beast_uproar_custom_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end

function modifier_primal_beast_uproar_custom_root:GetEffectName()
return "particles/beast_root.vpcf"
end






modifier_primal_beast_uproar_custom_proc = class({})
function modifier_primal_beast_uproar_custom_proc:IsHidden() return false end
function modifier_primal_beast_uproar_custom_proc:IsPurgable() return false end
function modifier_primal_beast_uproar_custom_proc:GetTexture() return "buffs/spray_slow" end
function modifier_primal_beast_uproar_custom_proc:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(self:GetAbility().proc_max)

self:GetParent():EmitSound("PBeast.Uproar_proc")
local particle = ParticleManager:CreateParticle("particles/beast_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_primal_beast_uproar_custom_proc:OnRefresh(table)
self:OnCreated(table)
end

function modifier_primal_beast_uproar_custom_proc:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_primal_beast_uproar_custom_proc:GetModifierAttackSpeedBonus_Constant()
	return self:GetAbility().proc_speed
end


function modifier_primal_beast_uproar_custom_proc:GetModifierPreAttack_CriticalStrike()
	return self:GetAbility().proc_crit[self:GetParent():GetUpgradeStack("modifier_primal_beast_uproar_4")]
end

function modifier_primal_beast_uproar_custom_proc:GetCritDamage()
	return self:GetAbility().proc_crit[self:GetParent():GetUpgradeStack("modifier_primal_beast_uproar_4")]

end

function modifier_primal_beast_uproar_custom_proc:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self:DecrementStackCount()
params.target:EmitSound("PBeast.Uproar_proc_attack")
if self:GetStackCount() == 0 then 
	self:Destroy()
end

end


function modifier_primal_beast_uproar_custom_proc:GetEffectName()
return "particles/beast_blood.vpcf"
end

function modifier_primal_beast_uproar_custom_proc:GetStatusEffectName()
return "particles/status_fx/status_effect_bloodrage.vpcf"
end


function modifier_primal_beast_uproar_custom_proc:StatusEffectPriority()
return 10000
end









modifier_primal_beast_uproar_custom_taunt = class({})

function modifier_primal_beast_uproar_custom_taunt:IsPurgable()
  return false
end
function modifier_primal_beast_uproar_custom_taunt:IsHidden()
  return true
end

function modifier_primal_beast_uproar_custom_taunt:OnCreated( kv )
if not IsServer() then return end
if self:GetParent():IsCreep() then return end

self:GetParent():SetForceAttackTarget( self:GetCaster() )
self:GetParent():MoveToTargetToAttack( self:GetCaster() )

self:GetParent():EmitSound("Hero_Axe.Berserkers_Call")
self:StartIntervalThink(FrameTime())
end

function modifier_primal_beast_uproar_custom_taunt:OnIntervalThink()
  if not IsServer() then return end
  if not self:GetCaster():IsAlive() then
    self:Destroy()
  end
end

function modifier_primal_beast_uproar_custom_taunt:OnDestroy()
if not IsServer() then return end

self:GetParent():SetForceAttackTarget( nil )
  
end

function modifier_primal_beast_uproar_custom_taunt:CheckState()
  local state = {
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_TAUNTED] = true,
  }

  return state
end

function modifier_primal_beast_uproar_custom_taunt:GetStatusEffectName()
  return "particles/status_fx/status_effect_beserkers_call.vpcf"
end






modifier_primal_beast_uproar_custom_taunt_cd = class({})
function modifier_primal_beast_uproar_custom_taunt_cd:IsHidden() return false end
function modifier_primal_beast_uproar_custom_taunt_cd:IsPurgable() return false end
function modifier_primal_beast_uproar_custom_taunt_cd:IsDebuff() return true end
function modifier_primal_beast_uproar_custom_taunt_cd:RemoveOnDeath() return false end
function modifier_primal_beast_uproar_custom_taunt_cd:GetTexture() return "buffs/uproar_bkb" end
function modifier_primal_beast_uproar_custom_taunt_cd:OnCreated(table)
self.RemoveForDuel = true
end

modifier_primal_beast_uproar_custom_taunt_heal = class({})
function modifier_primal_beast_uproar_custom_taunt_heal:IsHidden() return true end
function modifier_primal_beast_uproar_custom_taunt_heal:IsPurgable() return false end
function modifier_primal_beast_uproar_custom_taunt_heal:OnCreated()
self.heal = self:GetAbility().taunt_heal/self:GetRemainingTime()
end

function modifier_primal_beast_uproar_custom_taunt_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_primal_beast_uproar_custom_taunt_heal:GetModifierHealthRegenPercentage()
return self.heal
end