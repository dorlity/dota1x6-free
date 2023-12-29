LinkLuaModifier( "modifier_axe_counter_helix_custom", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_shard_debuff", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_legendary", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_cd", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_attack", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_attack_count", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_slow", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_armor_count", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_count", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_count_self", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_attack_speed", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_root_cd", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_root", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )



axe_counter_helix_custom = class({})








function axe_counter_helix_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_counterhelix.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", context )
PrecacheResource( "particle", "particles/axe_spin.vpcf", context )

end

function axe_counter_helix_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor( "radius" ) + self:GetCaster():GetTalentValue("modifier_axe_helix_6", "radius")
end


function axe_counter_helix_custom:GetIntrinsicModifierName()
	return "modifier_axe_counter_helix_custom"
end

function axe_counter_helix_custom:GetCooldown(level)
	if self:GetCaster():HasModifier("modifier_axe_helix_legendary") then 
		return self:GetCaster():GetTalentValue("modifier_axe_helix_legendary", "cd")
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

for _,mod_c in pairs(self:GetCaster():FindAllModifiersByName("modifier_axe_counter_helix_custom_attack")) do
	mod_c:Destroy()
end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_legendary", { })

end

function axe_counter_helix_custom:Spin(k_damage, use_cd)
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_3)
self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_3)

local radius = self:GetSpecialValueFor( "radius" ) + self:GetCaster():GetTalentValue("modifier_axe_helix_6", "radius")
local damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetTalentValue("modifier_axe_helix_1", "damage")



if self:GetCaster():HasModifier("modifier_axe_helix_5") then 

	local heal = self:GetCaster():GetTalentValue("modifier_axe_helix_5", "heal")

	if self:GetCaster():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_axe_helix_5", "health") then 
		heal = heal + self:GetCaster():GetTalentValue("modifier_axe_helix_5", "bonus")
	end 

	self:GetCaster():GenericHeal(heal*self:GetCaster():GetMaxHealth()/100, self)

end


local illusion = 1
if self:GetCaster():IsIllusion() then 
	illusion = self:GetSpecialValueFor("damage_illusions")
end



local armor_duration = self:GetCaster():GetTalentValue("modifier_axe_helix_3", "duration")

local damageTable = { attacker = self:GetCaster(), damage = damage*k_damage/illusion, damage_type = DAMAGE_TYPE_PURE, ability = self, damage_flags = DOTA_DAMAGE_FLAG_NONE, }

if self:GetCaster():HasModifier("modifier_axe_helix_3") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_armor_count", {duration = armor_duration})
end

if self:GetCaster():HasModifier("modifier_axe_helix_4") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_attack_speed", {duration = self:GetCaster():GetTalentValue("modifier_axe_helix_4", "duration")})
end

local slow_duration = self:GetCaster():GetTalentValue("modifier_axe_helix_2", "duration")

local pull_duration = self:GetCaster():GetTalentValue("modifier_axe_helix_6", "pull_duration")
local root_cd = self:GetCaster():GetTalentValue("modifier_axe_helix_6", "cd")
local root_duration = self:GetCaster():GetTalentValue("modifier_axe_helix_6", "root")

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
for _,enemy in pairs(enemies) do
	damageTable.victim = enemy
	ApplyDamage( damageTable )

	if self:GetCaster():HasModifier("modifier_axe_helix_6") and not enemy:HasModifier("modifier_axe_counter_helix_custom_root_cd") then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_root_cd", {duration = root_cd})

		local dir = (self:GetCaster():GetAbsOrigin() - enemy:GetAbsOrigin()):Normalized()
		local point = self:GetCaster():GetAbsOrigin() - dir*50
		local distance = (point - enemy:GetAbsOrigin()):Length2D()

		distance = math.max(50, distance)
		point = enemy:GetAbsOrigin() + dir*distance

		local mod = enemy:AddNewModifier( self:GetCaster(),  self,  "modifier_generic_arc",  
		{
		  target_x = point.x,
		  target_y = point.y,
		  distance = distance,
		  duration = pull_duration,
		  height = 0,
		  fix_end = false,
		  isStun = true,
		  activity = ACT_DOTA_FLAIL,
		})


		if mod then 
			mod:SetEndCallback(function()
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_root", {duration = (1 - enemy:GetStatusResistance())*root_duration})
			end)

		end

	end 

	if self:GetCaster():HasModifier("modifier_axe_helix_2") then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_slow", {duration = slow_duration*(1 - enemy:GetStatusResistance())})
	end

	if self:GetCaster():HasShard() then
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_axe_counter_helix_custom_shard_debuff", {duration = self:GetSpecialValueFor("shard_duration") })
	end
end

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_counterhelix.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( effect_cast )


self:GetCaster():EmitSound("Hero_Axe.CounterHelix")

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
	return self:GetParent():GetHealthPercent() > self:GetCaster():GetTalentValue("modifier_axe_helix_5", "health")
end


function modifier_axe_counter_helix_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_axe_counter_helix_custom:OnCreated()

self.legendary_count = self:GetCaster():GetTalentValue("modifier_axe_helix_legendary", "count", true)
self.legendary_timer = self:GetCaster():GetTalentValue("modifier_axe_helix_legendary", "timer", true)
end 

function modifier_axe_counter_helix_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_axe_helix_2") then return end

return self:GetCaster():GetTalentValue("modifier_axe_helix_2", "range")
end

function modifier_axe_counter_helix_custom:GetModifierPhysicalArmorBonus()
if not self:GetParent():HasModifier("modifier_axe_helix_3") then return end
local bonus = self:GetCaster():GetTalentValue("modifier_axe_helix_3", "armor")

if self:GetCaster():HasModifier("modifier_axe_counter_helix_custom_armor_count") then 
 	bonus = bonus*(self:GetCaster():GetUpgradeStack("modifier_axe_counter_helix_custom_armor_count") + 1)
end

return bonus
end


function modifier_axe_counter_helix_custom:GetModifierMoveSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_axe_helix_3") then return end
local bonus = self:GetCaster():GetTalentValue("modifier_axe_helix_3", "move")

if self:GetCaster():HasModifier("modifier_axe_counter_helix_custom_armor_count") then 
 	bonus = bonus*(self:GetCaster():GetUpgradeStack("modifier_axe_counter_helix_custom_armor_count") + 1)
end

return bonus
end






function modifier_axe_counter_helix_custom:OnAttackLanded( params )
if not IsServer() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end 
if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end

if self:GetCaster() == params.attacker and self:GetParent():HasModifier("modifier_axe_helix_legendary") then 

	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_counter_helix_custom_attack_count", {duration = self.legendary_timer})

	local mod = self:GetCaster():FindModifierByName("modifier_axe_counter_helix_custom_attack_count")

	if mod and mod:GetStackCount() > self.legendary_count then 

		for _,all_counts in ipairs(self:GetCaster():FindAllModifiersByName("modifier_axe_counter_helix_custom_attack")) do 
	     	 all_counts:Destroy()
	      	break
	    end
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_counter_helix_custom_attack", {duration = self.legendary_timer})
end


if self:GetCaster():PassivesDisabled() then return end
if self:GetParent():HasModifier("modifier_axe_helix_legendary") and self:GetParent():HasModifier("modifier_axe_counter_helix_custom_cd") then return end
if not self:GetParent():HasModifier("modifier_axe_helix_legendary") and not self:GetAbility():IsFullyCastable() then return end
if self:GetParent():HasModifier("modifier_axe_counter_helix_custom_legendary") then return end

local name = 0

if self:GetParent() == params.target then 
	name = "modifier_axe_counter_helix_custom_count"
end

if self:GetParent() == params.attacker and self:GetParent():HasModifier("modifier_axe_helix_4") then 
	name = "modifier_axe_counter_helix_custom_count_self"
end

if name == 0 then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), name, {})

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
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_axe_counter_helix_custom_shard_debuff:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount() * self.damage_reduction
end

function modifier_axe_counter_helix_custom_shard_debuff:GetModifierSpellAmplify_Percentage()
return self:GetStackCount() * self.damage_reduction
end


modifier_axe_counter_helix_custom_legendary = class({})
function modifier_axe_counter_helix_custom_legendary:IsHidden() return false end
function modifier_axe_counter_helix_custom_legendary:IsPurgable() return false end

function modifier_axe_counter_helix_custom_legendary:OnCreated(table)

self.resist = self:GetCaster():GetTalentValue("modifier_axe_helix_legendary", "status")
self.count = self:GetCaster():GetTalentValue("modifier_axe_helix_legendary", "max")

if not IsServer() then return end
self.RemoveForDuel = true

local particle = ParticleManager:CreateParticle( "particles/items4_fx/ascetic_cap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle( particle, false, false, -1, false, false  )


self:OnIntervalThink()
self:StartIntervalThink(self:GetCaster():GetTalentValue("modifier_axe_helix_legendary", "interval"))
end

function modifier_axe_counter_helix_custom_legendary:OnIntervalThink()
if not IsServer() then return end
local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetAbility():Spin(1, 0)

self:IncrementStackCount()
if self:GetStackCount() >= self.count then 
	self:Destroy()
	return
end 

end

function modifier_axe_counter_helix_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end

function modifier_axe_counter_helix_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_axe_counter_helix_custom_legendary:GetModifierStatusResistanceStacking()
return self.resist
end


function modifier_axe_counter_helix_custom_legendary:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end



function modifier_axe_counter_helix_custom_legendary:StatusEffectPriority()
	return 9999999
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

	if mod:GetStackCount() < self:GetCaster():GetTalentValue("modifier_axe_helix_legendary", "count") then 
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

self.max = self:GetCaster():GetTalentValue("modifier_axe_helix_legendary", "count")

self:SetStackCount(1)

end

function modifier_axe_counter_helix_custom_attack_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() == self.max then 
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
function modifier_axe_counter_helix_custom_slow:IsHidden() return true end
function modifier_axe_counter_helix_custom_slow:IsPurgable() return true end
function modifier_axe_counter_helix_custom_slow:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_axe_helix_2", "slow")

if not IsServer() then return end
self:GetParent():EmitSound("DOTA_Item.Maim")
end


function modifier_axe_counter_helix_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_axe_counter_helix_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_axe_counter_helix_custom_slow:GetEffectName()
	return "particles/items2_fx/sange_maim.vpcf"
end








modifier_axe_counter_helix_custom_armor_count = class({})
function modifier_axe_counter_helix_custom_armor_count:IsHidden() return false end
function modifier_axe_counter_helix_custom_armor_count:IsPurgable() return false end
function modifier_axe_counter_helix_custom_armor_count:GetTexture() return "buffs/helix_armor" end
function modifier_axe_counter_helix_custom_armor_count:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_axe_helix_3", "max")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_armor_count:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()
end



modifier_axe_counter_helix_custom_count = class({})
function modifier_axe_counter_helix_custom_count:IsHidden() return false end
function modifier_axe_counter_helix_custom_count:IsPurgable() return false end
function modifier_axe_counter_helix_custom_count:OnCreated(table)
if not IsServer() then return end

self.low_health = self:GetCaster():GetTalentValue("modifier_axe_helix_5", "health")
self.low_count = self:GetCaster():GetTalentValue("modifier_axe_helix_5", "count")

self.max = self:GetAbility():GetSpecialValueFor("trigger_attacks")

if self:GetParent():HasModifier("modifier_axe_helix_5") and self:GetParent():GetHealthPercent() <= self.low_health then 
	self.max = self.max + self.low_count
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

self.max = self:GetCaster():GetTalentValue("modifier_axe_helix_4", "count")

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

self.max = self:GetCaster():GetTalentValue("modifier_axe_helix_4", "max")
self.speed = self:GetCaster():GetTalentValue("modifier_axe_helix_4", "speed")

if not IsServer() then return end

self:SetStackCount(1)
end
function modifier_axe_counter_helix_custom_attack_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_axe_counter_helix_custom_attack_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_axe_counter_helix_custom_attack_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self.speed
end


modifier_axe_counter_helix_custom_root_cd = class({})
function modifier_axe_counter_helix_custom_root_cd:IsHidden() return true end
function modifier_axe_counter_helix_custom_root_cd:IsPurgable() return false end
function modifier_axe_counter_helix_custom_root_cd:RemoveOnDeath() return false end



modifier_axe_counter_helix_custom_root = class({})
function modifier_axe_counter_helix_custom_root:IsHidden() return true end
function modifier_axe_counter_helix_custom_root:IsPurgable() return true end

function modifier_axe_counter_helix_custom_root:CheckState()
return
{
    [MODIFIER_STATE_ROOTED] = true
}
end



function modifier_axe_counter_helix_custom_root:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Pudge.Hook_Root")

local parent = self:GetParent()

self.nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/hook_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
ParticleManager:SetParticleControl( self.nFXIndex, 0, parent:GetAbsOrigin() )
self:AddParticle(self.nFXIndex, false, false, -1, false, false)

end
