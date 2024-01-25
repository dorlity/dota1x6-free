LinkLuaModifier( "modifier_ogre_magi_ignite_custom", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_custom_count", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_tracker", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire_stack", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire_resist", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire_attacks", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_fire_healing", "abilities/ogre_magi/ogre_magi_ignite", LUA_MODIFIER_MOTION_NONE )

ogre_magi_ignite_custom = class({})

ogre_magi_ignite_custom.damage_bonus = {20,30,40}

ogre_magi_ignite_custom.armor_armor = {-0.5, -1, -1.5}
ogre_magi_ignite_custom.armor_magic = {-2, -3, -4}
ogre_magi_ignite_custom.armor_max = 8
ogre_magi_ignite_custom.armor_duration = 3

ogre_magi_ignite_custom.attack_tick_interval = 0.05
ogre_magi_ignite_custom.attack_tick_max = {4,8}
ogre_magi_ignite_custom.attack_tick_slow = -5

ogre_magi_ignite_custom.legendary_chance = 25

ogre_magi_ignite_custom.stun_duration = 1.5
ogre_magi_ignite_custom.burn_duration = 2

ogre_magi_ignite_custom.tick_range = 60
ogre_magi_ignite_custom.tick_heal_max = 8
ogre_magi_ignite_custom.tick_heal = -5
ogre_magi_ignite_custom.tick_cd = 1

ogre_magi_ignite_custom.heal_chance = {30, 45, 60}
ogre_magi_ignite_custom.heal_heal = 0.02
ogre_magi_ignite_custom.heal_heal_creeps = 0.33




function ogre_magi_ignite_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf', context )
PrecacheResource( "particle", 'particles/orange_heal.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf', context )
PrecacheResource( "particle", 'particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff_explosion.vpcf', context )

end



function ogre_magi_ignite_custom:GetAOERadius()
	return self:GetSpecialValueFor( "aoe_radius" )
end



function ogre_magi_ignite_custom:GetIntrinsicModifierName()
return "modifier_ogre_magi_ignite_tracker"
end

function ogre_magi_ignite_custom:OnSpellStart(new_target)
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if new_target ~= nil then 
		target = new_target
	end

	local silence = false

	if self:GetCaster():HasModifier("modifier_ogre_magi_bloodlust_custom_legendary_5") then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_bloodlust_custom")
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_bloodlust_custom_legendary_resist", {duration = ability.legendary_resist_duration})
	end

	if self:GetCaster():HasModifier("modifier_ogremagi_multi_2") then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_ogre_magi_multicast_custom_spell_count", {duration = ability.spell_duration[self:GetCaster():GetUpgradeStack("modifier_ogremagi_multi_2")]})
	end


	if self:GetCaster():HasModifier("modifier_ogremagi_multi_5") then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")

		if RollPseudoRandomPercentage(ability.proc_chance, 526, self:GetCaster()) then 
			silence = true
		end

	end

	local info = {
		Target = target,
		Source = self:GetCaster(),
		Ability = self,	
		EffectName = "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf",
		iMoveSpeed = self:GetSpecialValueFor( "projectile_speed" ),
		bDodgeable = true,
		ExtraData = {silence = silence}
	}

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("aoe_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	
	for _,enemy in pairs(enemies) do 
		info.Target = enemy
		ProjectileManager:CreateTrackingProjectile(info)
	end


	self:GetCaster():EmitSound("Hero_OgreMagi.Ignite.Cast")


end

function ogre_magi_ignite_custom:OnProjectileHit_ExtraData( target, location, data)
if not target then return end
if target:TriggerSpellAbsorb( self ) then return end
if target:IsMagicImmune() then return end

	local duration = self:GetSpecialValueFor( "duration" )

	if self:GetCaster():HasModifier("modifier_ogremagi_ignite_5") then 
		duration = duration + self.burn_duration
	end



	if self:GetCaster():HasModifier("modifier_ogremagi_ignite_7") then 

		target:AddNewModifier( self:GetCaster(), self, "modifier_ogre_magi_ignite_custom", { duration = duration } )
		target:AddNewModifier( self:GetCaster(), self, "modifier_ogre_magi_ignite_custom_count", { duration = duration } )
	else 
		if target:HasModifier("modifier_ogre_magi_ignite_custom") then
			local mod = target:FindModifierByName("modifier_ogre_magi_ignite_custom")
			if mod then
				mod:SetDuration(mod:GetRemainingTime() + duration, true)
			end
		else
			target:AddNewModifier( self:GetCaster(), self, "modifier_ogre_magi_ignite_custom", { duration = duration } )
		end

	end

	if data.silence == 1 then 
		local ability = self:GetCaster():FindAbilityByName("ogre_magi_multicast_custom")
		if ability then 
			target:EmitSound("Sf.Raze_Silence")
			target:AddNewModifier(self:GetCaster(), self, "modifier_ogre_magi_multicast_custom_proc_silence", {duration = (1 - target:GetStatusResistance())*ability.proc_silence})
		end
	end


	self:GetCaster():EmitSound("Hero_OgreMagi.Ignite.Target")




end







modifier_ogre_magi_ignite_custom = class({})

function modifier_ogre_magi_ignite_custom:IsPurgable() return true end

function modifier_ogre_magi_ignite_custom:GetAttributes()
if self:GetCaster():HasModifier("modifier_ogremagi_ignite_7") then 
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
	return
end

function modifier_ogre_magi_ignite_custom:IsHidden()
	return self:GetCaster():HasModifier("modifier_ogremagi_ignite_7")
end

function modifier_ogre_magi_ignite_custom:OnCreated( kv )
if not self:GetAbility() then 
	self:Destroy()
	return
end

	self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed_pct" )
	self.damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	self.ability = self:GetAbility()


	if not IsServer() then return end

	local damage = self.damage
	if self:GetCaster():HasModifier("modifier_ogremagi_ignite_1") then 
		damage = damage + self.ability.damage_bonus[self:GetCaster():GetUpgradeStack("modifier_ogremagi_ignite_1")]
	end


	self.damageTable = { victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = self.ability:GetAbilityDamageType(), ability = self.ability, }
	
	self.max_armor = self.ability.armor_max

	local tick = 1


	self:StartIntervalThink( tick )
end

function modifier_ogre_magi_ignite_custom:OnRefresh( kv )	
	self:OnCreated(kv)
end

function modifier_ogre_magi_ignite_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end




function modifier_ogre_magi_ignite_custom:GetModifierMoveSpeedBonus_Percentage()
if self:GetCaster():HasModifier("modifier_ogremagi_ignite_7") then return end
local bonus = 0
if self:GetParent():HasModifier("modifier_ogre_magi_ignite_fire_attacks") then 
	bonus = self:GetAbility().attack_tick_slow*self:GetParent():GetModifierStackCount("modifier_ogre_magi_ignite_fire_attacks", self:GetCaster())
end
	return self.slow + bonus
end





function modifier_ogre_magi_ignite_custom:OnIntervalThink()



if not IsServer() then return end


local tick = 1

local mod = self:GetParent():FindModifierByName("modifier_ogre_magi_ignite_fire_attacks")

if mod and self:GetAbility() and not self:GetAbility():IsNull() then 
	tick = tick - self:GetAbility().attack_tick_interval*mod:GetStackCount()
end

if self:GetCaster():HasModifier("modifier_ogremagi_ignite_6")  then 
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_ignite_fire_healing", {})
end

if self:GetCaster():HasModifier("modifier_ogremagi_ignite_3") then 

	if RollPseudoRandomPercentage(self:GetAbility().heal_chance[self:GetCaster():GetUpgradeStack("modifier_ogremagi_ignite_3")], 84, self:GetCaster()) then


		local k = self:GetAbility().heal_heal
		if self:GetParent():IsCreep() then 
			k = k*self:GetAbility().heal_heal_creeps
		end

		local heal = k*self:GetCaster():GetMaxHealth()

		self:GetCaster():GenericHeal(heal, self:GetAbility())

		self:GetCaster():EmitSound("WK.skelet_heal")


	end 
end

if self:GetParent():HasModifier("modifier_ogre_magi_ignite_fire_attacks") and self:GetAbility() and not self:GetAbility():IsNull() then 

	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )

	if self:GetCaster():HasModifier("modifier_ogremagi_ignite_1") then 
		damage = damage + self:GetAbility().damage_bonus[self:GetCaster():GetUpgradeStack("modifier_ogremagi_ignite_1")]
	end

	local damageTable = self.damageTable
	damageTable.damage = damage
	ApplyDamage( damageTable )
else 

	ApplyDamage( self.damageTable )

end 

self:GetParent():EmitSound("Hero_OgreMagi.Ignite.Damage")

if self:GetCaster():HasModifier("modifier_ogremagi_ignite_2") and self.ability and not self.ability:IsNull() then 
	self:GetParent():AddNewModifier(self:GetCaster(), self.ability, "modifier_ogre_magi_ignite_fire_resist", {duration = self.ability.armor_duration})
end



self:StartIntervalThink(tick)

end




function modifier_ogre_magi_ignite_custom:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_ignite_debuff.vpcf"
end

function modifier_ogre_magi_ignite_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_ogre_magi_ignite_custom:OnDestroy()
if not IsServer() then return end

if self:GetRemainingTime() > 0.2 and self:GetCaster():HasModifier("modifier_ogremagi_ignite_5") then 


	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	self:GetParent():EmitSound("Hero_OgreMagi.Fireblast.Target")

	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().stun_duration})
end

if self:GetCaster():HasModifier("modifier_ogremagi_ignite_7") then 
	local mod = self:GetParent():FindModifierByName("modifier_ogre_magi_ignite_custom_count")
	if mod then 
		mod:DecrementStackCount()
		if mod:GetStackCount() == 0 then 
			mod:Destroy()
		end
	end

else 
	self:GetParent():RemoveModifierByName("modifier_ogre_magi_ignite_fire_attacks")
	self:GetParent():RemoveModifierByName("modifier_ogre_magi_ignite_fire_healing")
end


end







modifier_ogre_magi_ignite_tracker = class({})
function modifier_ogre_magi_ignite_tracker:IsHidden() return true end
function modifier_ogre_magi_ignite_tracker:IsPurgable() return false end

function modifier_ogre_magi_ignite_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end


function modifier_ogre_magi_ignite_tracker:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_ogremagi_ignite_6") then return end 

return self:GetAbility().tick_range
end 

function modifier_ogre_magi_ignite_tracker:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetCaster() then return end
if params.target:IsBuilding() then return end


if self:GetCaster():HasModifier("modifier_ogremagi_ignite_6") then 
	local cd = self:GetAbility():GetCooldownTimeRemaining()
	if cd > 0 then 
		self:GetAbility():EndCooldown()
		cd = cd - self:GetAbility().tick_cd
		self:GetAbility():StartCooldown(cd)
	end

end


if self:GetCaster():HasModifier("modifier_ogremagi_ignite_7") and (params.target:IsHero() or params.target:IsCreep()) and params.target:IsAlive() then 

	if RollPseudoRandomPercentage(self:GetAbility().legendary_chance, 89, self:GetCaster()) then
		self:GetAbility():OnSpellStart(params.target)
	end
end






if not params.target:HasModifier("modifier_ogre_magi_ignite_custom") then return end
if not self:GetCaster():HasModifier("modifier_ogremagi_ignite_4") then return end

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ogre_magi_ignite_fire_attacks", {})
end





modifier_ogre_magi_ignite_custom_count = class({})
function modifier_ogre_magi_ignite_custom_count:IsHidden() return false end
function modifier_ogre_magi_ignite_custom_count:IsPurgable() return true end
function modifier_ogre_magi_ignite_custom_count:OnCreated(table)

self.slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed_pct" )
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_ogre_magi_ignite_custom_count:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount() + 1)
end

function modifier_ogre_magi_ignite_custom_count:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_ogre_magi_ignite_custom_count:GetModifierMoveSpeedBonus_Percentage()

local bonus = 0
if self:GetParent():HasModifier("modifier_ogre_magi_ignite_fire_attacks") then 
	bonus = self:GetAbility().attack_tick_slow*self:GetParent():GetModifierStackCount("modifier_ogre_magi_ignite_fire_attacks", self:GetCaster())
end
	return self.slow + bonus
end

function modifier_ogre_magi_ignite_custom_count:OnDestroy()
if not IsServer() then return end

self:GetParent():RemoveModifierByName("modifier_ogre_magi_ignite_fire_healing")
self:GetParent():RemoveModifierByName("modifier_ogre_magi_ignite_fire_attacks")
end



modifier_ogre_magi_ignite_fire_resist = class({})
function modifier_ogre_magi_ignite_fire_resist:IsHidden() return false end
function modifier_ogre_magi_ignite_fire_resist:IsPurgable() return false end
function modifier_ogre_magi_ignite_fire_resist:GetTexture() return "buffs/ignite_armor" end
function modifier_ogre_magi_ignite_fire_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end


function modifier_ogre_magi_ignite_fire_resist:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_ogre_magi_ignite_fire_resist:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().armor_max then return end
self:IncrementStackCount()
end



function modifier_ogre_magi_ignite_fire_resist:GetModifierPhysicalArmorBonus()
local bonus = 0
if self:GetCaster():HasModifier("modifier_ogremagi_ignite_2") then 
	bonus = self:GetStackCount()*self:GetAbility().armor_armor[self:GetCaster():GetUpgradeStack("modifier_ogremagi_ignite_2")]
end

	return bonus
end

function modifier_ogre_magi_ignite_fire_resist:GetModifierMagicalResistanceBonus()
local bonus = 0
if self:GetCaster():HasModifier("modifier_ogremagi_ignite_2") then 
	bonus = self:GetStackCount()*self:GetAbility().armor_magic[self:GetCaster():GetUpgradeStack("modifier_ogremagi_ignite_2")]
end

	return bonus
end



modifier_ogre_magi_ignite_fire_attacks = class({})
function modifier_ogre_magi_ignite_fire_attacks:IsHidden() return false end
function modifier_ogre_magi_ignite_fire_attacks:IsPurgable() return false end
function modifier_ogre_magi_ignite_fire_attacks:GetTexture() return "buffs/ignite_tick" end


function modifier_ogre_magi_ignite_fire_attacks:OnCreated(table)
if not IsServer() then return end
self:AddStack()
end

function modifier_ogre_magi_ignite_fire_attacks:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().attack_tick_max[self:GetCaster():GetUpgradeStack("modifier_ogremagi_ignite_4")] then return end
self:AddStack()

end

function modifier_ogre_magi_ignite_fire_attacks:AddStack()
if not IsServer() then return end


local particle = ParticleManager:CreateParticle("particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_ignite_debuff_explosion.vpcf", PATTACH_POINT, self:GetParent())
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )

self:GetParent():EmitSound("Ogre.Ignite_hit")
self:IncrementStackCount()
end


function modifier_ogre_magi_ignite_fire_attacks:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2
}
end


function modifier_ogre_magi_ignite_fire_attacks:OnTooltip()
return self:GetStackCount()*self:GetAbility().attack_tick_interval
end 


function modifier_ogre_magi_ignite_fire_attacks:OnTooltip2()
return self:GetStackCount()*self:GetAbility().attack_tick_slow
end





modifier_ogre_magi_ignite_fire_healing = class({})
function modifier_ogre_magi_ignite_fire_healing:IsHidden() return false end
function modifier_ogre_magi_ignite_fire_healing:IsPurgable() return false end
function modifier_ogre_magi_ignite_fire_healing:GetTexture() return "buffs/ignite_speed" end


function modifier_ogre_magi_ignite_fire_healing:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_ogre_magi_ignite_fire_healing:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().tick_heal_max then return end

self:IncrementStackCount()
end


function modifier_ogre_magi_ignite_fire_healing:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end



function modifier_ogre_magi_ignite_fire_healing:GetModifierLifestealRegenAmplify_Percentage() 

return self:GetAbility().tick_heal*self:GetStackCount()
end

function modifier_ogre_magi_ignite_fire_healing:GetModifierHealAmplify_PercentageTarget()

return self:GetAbility().tick_heal*self:GetStackCount()
end

function modifier_ogre_magi_ignite_fire_healing:GetModifierHPRegenAmplify_Percentage() 

return self:GetAbility().tick_heal*self:GetStackCount()
end
