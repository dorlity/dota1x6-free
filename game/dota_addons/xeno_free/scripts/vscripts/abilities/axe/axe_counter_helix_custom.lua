LinkLuaModifier( "modifier_axe_counter_helix_custom", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_shard_debuff", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_legendary", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_cd", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_attack", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_attack_count", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_slow", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_crit", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_armor", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_armor_count", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_count", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_count_self", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_attack_speed", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )



axe_counter_helix_custom = class({})


axe_counter_helix_custom.legendary_interval = 0.3
axe_counter_helix_custom.legendary_damage = 1
axe_counter_helix_custom.legendary_resist = 70
axe_counter_helix_custom.legendary_cd = 5
axe_counter_helix_custom.legendary_attack_count = 4
axe_counter_helix_custom.legendary_attack_max = 4
axe_counter_helix_custom.legendary_helix_count = 3

axe_counter_helix_custom.armor = {1,1.5,2}
axe_counter_helix_custom.armor_move = {1,1.5,2}
axe_counter_helix_custom.armor_duration = 10

axe_counter_helix_custom.range_helix = {60, 90, 120}
axe_counter_helix_custom.range_attack = {40, 60, 80}

axe_counter_helix_custom.damage = {30,45,60}

axe_counter_helix_custom.heal = 0.02
axe_counter_helix_custom.heal_health = 40
axe_counter_helix_custom.heal_count = 1


axe_counter_helix_custom.stun_count = 5
axe_counter_helix_custom.stun_stun = 0.8

axe_counter_helix_custom.attack_slow = -8
axe_counter_helix_custom.attack_slow_max = 5
axe_counter_helix_custom.attack_slow_duration = 4


axe_counter_helix_custom.self_count = {6, 4}
axe_counter_helix_custom.self_speed = {10, 16}
axe_counter_helix_custom.self_speed_duration = 5
axe_counter_helix_custom.self_speed_max = 5



function axe_counter_helix_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_counterhelix.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", context )
PrecacheResource( "particle", "particles/axe_spin.vpcf", context )

end




function axe_counter_helix_custom:GetIntrinsicModifierName()
	return "modifier_axe_counter_helix_custom"
end

function axe_counter_helix_custom:GetCooldown(level)
	if self:GetCaster():HasModifier("modifier_axe_helix_legendary") then 
		return self.legendary_cd
	end
    return self.BaseClass.GetCooldown( self, level )
end


function axe_counter_helix_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_axe_helix_legendary") then
    return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
  end
 return DOTA_ABILITY_BEHAVIOR_PASSIVE
end



function axe_counter_helix_custom:OnSpellStart()
if not IsServer() then return end

local duration = 0

duration = (self.legendary_helix_count - 1)*self.legendary_interval + FrameTime()

for _,mod_c in pairs(self:GetCaster():FindAllModifiersByName("modifier_axe_counter_helix_custom_attack")) do
	mod_c:Destroy()
end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_legendary", {duration = duration })

end

function axe_counter_helix_custom:Spin(k_damage, use_cd)
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_3)
self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)

local radius = self:GetSpecialValueFor( "radius" )
local damage = self:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_axe_helix_2") then 
	radius = radius + self.range_helix[self:GetCaster():GetUpgradeStack("modifier_axe_helix_2")]
end


if self:GetCaster():HasModifier("modifier_axe_helix_5") then 

	local heal = self.heal*self:GetCaster():GetMaxHealth()

	self:GetCaster():GenericHeal(heal, self)

end

if self:GetCaster():HasModifier("modifier_axe_helix_1") then 
	damage = damage + self.damage[self:GetCaster():GetUpgradeStack("modifier_axe_helix_1")]
end

local illusion = 1
if self:GetCaster():IsIllusion() then 
	illusion = self:GetSpecialValueFor("damage_illusions")
end


local attack = false 
if self:GetCaster():HasModifier("modifier_axe_helix_6") then 

	local mod = self:GetCaster():FindModifierByName("modifier_axe_counter_helix_custom_crit")

	if mod and mod:GetStackCount() == self.stun_count - 1 then 
		attack = true
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_crit", {})
end



local damageTable = { attacker = self:GetCaster(), damage = damage*k_damage/illusion, damage_type = DAMAGE_TYPE_PURE, ability = self, damage_flags = DOTA_DAMAGE_FLAG_NONE, }

if self:GetCaster():HasModifier("modifier_axe_helix_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_armor", {duration = self.armor_duration})
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_armor_count", {duration = self.armor_duration})
end

if self:GetCaster():HasModifier("modifier_axe_helix_4") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_attack_speed", {duration = self.self_speed_duration})
end


local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
for _,enemy in pairs(enemies) do
	damageTable.victim = enemy
	ApplyDamage( damageTable )


	if attack == true then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.stun_stun})
		enemy:EmitSound("BB.Goo_stun")
	end

	if self:GetCaster():HasModifier("modifier_axe_helix_6") then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_slow", {duration = self.attack_slow_duration*(1 - enemy:GetStatusResistance())})
	end

	if self:GetCaster():HasShard() then
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_shard_debuff", {duration = self:GetSpecialValueFor("shard_duration") })
	end
end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( effect_cast )



if attack == false then 
	self:GetCaster():EmitSound("Hero_Axe.CounterHelix")
else 
	self:GetCaster():EmitSound("Hero_Axe.CounterHelix_Blood_Chaser")
end

if use_cd == 1 and not self:GetCaster():HasShard() then 

	if self:GetCaster():HasModifier("modifier_axe_helix_legendary") then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_cd", {duration = self:GetSpecialValueFor("cooldown")*self:GetCaster():GetCooldownReduction()})
	else 
		self:UseResources( false, false, false, true )
	end
end



end










modifier_axe_counter_helix_custom = class({})

function modifier_axe_counter_helix_custom:IsPurgable()
	return false
end

function modifier_axe_counter_helix_custom:GetTexture()
	return "buffs/helix_heal"
end


function modifier_axe_counter_helix_custom:IsHidden() 
if not self:GetParent():HasModifier("modifier_axe_helix_5") then return true end
	return self:GetParent():GetHealthPercent() > self:GetAbility().heal_health
end


function modifier_axe_counter_helix_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}

	return funcs
end


function modifier_axe_counter_helix_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_axe_helix_2") then return end

return self:GetAbility().range_attack[self:GetCaster():GetUpgradeStack("modifier_axe_helix_2")]
end


function modifier_axe_counter_helix_custom:OnAttackLanded( params )
if not IsServer() then return end

if self:GetCaster() == params.attacker and self:GetParent():HasModifier("modifier_axe_helix_legendary") then 

	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_counter_helix_custom_attack_count", {duration = self:GetAbility().legendary_attack_count})



	local mod = self:GetCaster():FindModifierByName("modifier_axe_counter_helix_custom_attack_count")

	if mod and mod:GetStackCount() > self:GetAbility().legendary_attack_max then 

		for _,all_counts in ipairs(self:GetCaster():FindAllModifiersByName("modifier_axe_counter_helix_custom_attack")) do 
	     	 all_counts:Destroy()
	      	break
	    end
	end



	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_counter_helix_custom_attack", {duration = self:GetAbility().legendary_attack_count})
end


if self:GetCaster():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_axe_helix_legendary") and self:GetParent():HasModifier("modifier_axe_counter_helix_custom_cd") then return end
if not self:GetParent():HasModifier("modifier_axe_helix_legendary") and not self:GetAbility():IsFullyCastable() then return end
if self:GetParent():HasModifier("modifier_axe_counter_helix_custom_legendary") then return end
if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end

local name = 0

if self:GetParent() == params.target then 
	name = "modifier_axe_counter_helix_custom_count"
end

if self:GetParent() == params.attacker and self:GetParent():HasModifier("modifier_axe_helix_4") then 
	name = "modifier_axe_counter_helix_custom_count_self"
end

if name == 0 then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), name, {duration = self:GetAbility():GetSpecialValueFor("trigger_duration")})

end




modifier_axe_counter_helix_custom_shard_debuff = class({})

function modifier_axe_counter_helix_custom_shard_debuff:IsPurgable() return true end

function modifier_axe_counter_helix_custom_shard_debuff:OnCreated()
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("shard_damage")
if not IsServer() then return end
	self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_shard_debuff:OnRefresh()
if not IsServer() then return end

	if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("shard_max") then
		self:IncrementStackCount()
	end

end

function modifier_axe_counter_helix_custom_shard_debuff:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_axe_counter_helix_custom_shard_debuff:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount() * self.damage_reduction

end


modifier_axe_counter_helix_custom_legendary = class({})
function modifier_axe_counter_helix_custom_legendary:IsHidden() return false end
function modifier_axe_counter_helix_custom_legendary:IsPurgable() return false end

function modifier_axe_counter_helix_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true




self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility().legendary_interval)
end

function modifier_axe_counter_helix_custom_legendary:OnIntervalThink()
if not IsServer() then return end
local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( effect_cast )



	self:GetAbility():Spin(self:GetAbility().legendary_damage, 0)
end

function modifier_axe_counter_helix_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end

function modifier_axe_counter_helix_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_axe_counter_helix_custom_legendary:GetModifierStatusResistanceStacking()
return self:GetAbility().legendary_resist
end

modifier_axe_counter_helix_custom_cd = class({})
function modifier_axe_counter_helix_custom_cd:IsHidden() return true end
function modifier_axe_counter_helix_custom_cd:IsPurgable() return false end
function modifier_axe_counter_helix_custom_cd:IsDebuff() return true end





modifier_axe_counter_helix_custom_attack = class({})
function modifier_axe_counter_helix_custom_attack:IsHidden() return true end
function modifier_axe_counter_helix_custom_attack:IsPurgable() return false end
function modifier_axe_counter_helix_custom_attack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_axe_counter_helix_custom_attack:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_axe_counter_helix_custom_attack_count")
if mod then 
	mod:DecrementStackCount()

	if mod:GetStackCount() < self:GetAbility().legendary_attack_max then 
		self:GetAbility():SetActivated(false)
	end

	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end


end

modifier_axe_counter_helix_custom_attack_count = class({})
function modifier_axe_counter_helix_custom_attack_count:IsHidden() return true end
function modifier_axe_counter_helix_custom_attack_count:IsPurgable() return false end
function modifier_axe_counter_helix_custom_attack_count:GetTexture() return "buffs/helix_attack" end
function modifier_axe_counter_helix_custom_attack_count:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/axe_spin.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)


self:SetStackCount(1)

end

function modifier_axe_counter_helix_custom_attack_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().legendary_attack_max then 
	self:GetAbility():SetActivated(true)
end



end





function modifier_axe_counter_helix_custom_attack_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_axe_counter_helix_custom_attack_count:OnTooltip() return self:GetStackCount() end

function modifier_axe_counter_helix_custom_attack_count:OnDestroy()
if not IsServer() then return end
self:GetAbility():SetActivated(false)
end

function modifier_axe_counter_helix_custom_attack_count:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.particle then return end

local max = 6
local stack = math.min(math.floor(self:GetStackCount()), max)


for i = 1,max do 
	
	if i <= stack then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end











modifier_axe_counter_helix_custom_slow = class({})
function modifier_axe_counter_helix_custom_slow:IsHidden() return false end
function modifier_axe_counter_helix_custom_slow:IsPurgable() return true end
function modifier_axe_counter_helix_custom_slow:GetTexture() return "buffs/helix_attack" end
function modifier_axe_counter_helix_custom_slow:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().attack_slow_max then return end
self:IncrementStackCount()
end

function modifier_axe_counter_helix_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_axe_counter_helix_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().attack_slow*self:GetStackCount()
end




modifier_axe_counter_helix_custom_crit = class({})
function modifier_axe_counter_helix_custom_crit:IsHidden() return true end
function modifier_axe_counter_helix_custom_crit:IsPurgable() return true end
function modifier_axe_counter_helix_custom_crit:GetTexture() return "buffs/helix_speed" end




function modifier_axe_counter_helix_custom_crit:OnCreated()
if not IsServer() then return end
self.RemoveForDuel = true 
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_crit:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().stun_count then 
	self:Destroy()
end


end




modifier_axe_counter_helix_custom_armor = class({})
function modifier_axe_counter_helix_custom_armor:IsHidden() return true end
function modifier_axe_counter_helix_custom_armor:IsPurgable() return false end
function modifier_axe_counter_helix_custom_armor:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_axe_counter_helix_custom_armor:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end

function modifier_axe_counter_helix_custom_armor:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_axe_counter_helix_custom_armor_count")

if mod then 
  mod:DecrementStackCount()
  if mod:GetStackCount() == 0 then 
    mod:Destroy()
  end
end


end

modifier_axe_counter_helix_custom_armor_count = class({})
function modifier_axe_counter_helix_custom_armor_count:IsHidden() return false end
function modifier_axe_counter_helix_custom_armor_count:IsPurgable() return false end
function modifier_axe_counter_helix_custom_armor_count:GetTexture() return "buffs/helix_armor" end
function modifier_axe_counter_helix_custom_armor_count:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_armor_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_axe_counter_helix_custom_armor_count:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end

function modifier_axe_counter_helix_custom_armor_count:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*(self:GetAbility().armor[self:GetCaster():GetUpgradeStack("modifier_axe_helix_3")])
end

function modifier_axe_counter_helix_custom_armor_count:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*(self:GetAbility().armor_move[self:GetCaster():GetUpgradeStack("modifier_axe_helix_3")])
end




modifier_axe_counter_helix_custom_count = class({})
function modifier_axe_counter_helix_custom_count:IsHidden() return false end
function modifier_axe_counter_helix_custom_count:IsPurgable() return false end
function modifier_axe_counter_helix_custom_count:OnCreated(table)
if not IsServer() then return end

self.max = self:GetAbility():GetSpecialValueFor("trigger_attacks")

if self:GetParent():HasModifier("modifier_axe_helix_5") and self:GetParent():GetHealthPercent() <= self:GetAbility().heal_health then 
	self.max = self.max - self:GetAbility().heal_count
end

self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_count:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then
	self:GetAbility():Spin(1, 1)
	self:Destroy()
end

end


modifier_axe_counter_helix_custom_count_self = class({})
function modifier_axe_counter_helix_custom_count_self:IsHidden() return true end
function modifier_axe_counter_helix_custom_count_self:IsPurgable() return false end
function modifier_axe_counter_helix_custom_count_self:OnCreated(table)
if not IsServer() then return end

self.max = self:GetAbility().self_count[self:GetCaster():GetUpgradeStack("modifier_axe_helix_4")]

self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_count_self:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then
	self:GetAbility():Spin(1, 1)
	self:Destroy()
end

end



modifier_axe_counter_helix_custom_attack_speed = class({})
function modifier_axe_counter_helix_custom_attack_speed:IsHidden() return false end
function modifier_axe_counter_helix_custom_attack_speed:IsPurgable() return false end
function modifier_axe_counter_helix_custom_attack_speed:GetTexture() return "buffs/helix_speed" end
function modifier_axe_counter_helix_custom_attack_speed:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end
function modifier_axe_counter_helix_custom_attack_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().self_speed_max then return end

self:IncrementStackCount()
end

function modifier_axe_counter_helix_custom_attack_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_axe_counter_helix_custom_attack_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self:GetAbility().self_speed[self:GetCaster():GetUpgradeStack("modifier_axe_helix_4")]
end