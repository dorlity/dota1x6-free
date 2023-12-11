LinkLuaModifier("modifier_bloodseeker_bloodrage_custom", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_tracker", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_blood", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_taunt", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_incoming", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_shield", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_shield_count", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_shield_cd", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)


bloodseeker_bloodrage_custom = class({})

bloodseeker_bloodrage_custom.legendary_self_damage = 0.3
bloodseeker_bloodrage_custom.legendary_max = 10
bloodseeker_bloodrage_custom.legendary_max_damage = 10
bloodseeker_bloodrage_custom.legendary_damage = 2
bloodseeker_bloodrage_custom.legendary_speed = 20
bloodseeker_bloodrage_custom.legendary_taunt = 2
bloodseeker_bloodrage_custom.legendary_taunt_cd = 5
bloodseeker_bloodrage_custom.legendary_taunt_cd_max = 8
bloodseeker_bloodrage_custom.legendary_taunt_radius = 900
bloodseeker_bloodrage_custom.legendary_interval = 1

bloodseeker_bloodrage_custom.lowhp_health = 30
bloodseeker_bloodrage_custom.lowhp_regen = 1.5

bloodseeker_bloodrage_custom.blood_duration = 5
bloodseeker_bloodrage_custom.blood_damage = 70
bloodseeker_bloodrage_custom.blood_max = {5 , 8}
bloodseeker_bloodrage_custom.blood_heal = 1
bloodseeker_bloodrage_custom.blood_interval = 1

bloodseeker_bloodrage_custom.damage_heal = {0.06 ,0.09, 0.12}
bloodseeker_bloodrage_custom.damage_creeps = 0.33

bloodseeker_bloodrage_custom.bonus_speed = {20,30,40}
bloodseeker_bloodrage_custom.bonus_amp = {4,6,8}

bloodseeker_bloodrage_custom.shield_health = 0.15
bloodseeker_bloodrage_custom.shield_max = 8
bloodseeker_bloodrage_custom.shield_duration = 10
bloodseeker_bloodrage_custom.shield_cd = 8
bloodseeker_bloodrage_custom.shield_attack_duration = 8
bloodseeker_bloodrage_custom.shield_status = 25

bloodseeker_bloodrage_custom.reduce_delay = 4
bloodseeker_bloodrage_custom.reduce_damage = {-6, -9, -12}
bloodseeker_bloodrage_custom.reduce_move = {20, 30, 40}



function bloodseeker_bloodrage_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf', context )
PrecacheResource( "particle", 'particles/bloodrage_stack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf', context )
PrecacheResource( "particle", 'particles/sf_lifesteal.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_drow/bloodrage_blood.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_beserkers_call.vpcf', context )
PrecacheResource( "particle", 'particles/bloodrage_reduction.vpcf', context )

end



function bloodseeker_bloodrage_custom:GetBehavior()
  if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrage_7") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_TOGGLE end
 return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE 
end



function bloodseeker_bloodrage_custom:GetManaCost(level)

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrage_7") then  
  return 0
end

return self.BaseClass.GetManaCost(self,level) 
end







function bloodseeker_bloodrage_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrage_7") then 
 return 1
end


 return self.BaseClass.GetCooldown(self, iLevel)
 
end





function bloodseeker_bloodrage_custom:OnToggle()

local caster = self:GetCaster()
local modifier = caster:FindModifierByName( "modifier_bloodseeker_bloodrage_custom" )

if modifier then
   modifier:Destroy()
   self:UseResources(false, false, false, true)
end

if self:GetToggleState() then
  if not modifier then
	self:GetCaster():EmitSound("hero_bloodseeker.bloodRage")
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_bloodrage_custom", {})
    
 end

end 



end



function bloodseeker_bloodrage_custom:GetIntrinsicModifierName()
return "modifier_bloodseeker_bloodrage_tracker"
end


function bloodseeker_bloodrage_custom:OnSpellStart()
	if not IsServer() then return end
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():EmitSound("hero_bloodseeker.bloodRage")
	self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_bloodrage_custom", {duration = duration})
end

modifier_bloodseeker_bloodrage_custom = class({})

function modifier_bloodseeker_bloodrage_custom:IsHidden()
	return false
end

function modifier_bloodseeker_bloodrage_custom:IsPurgable()
	return not self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_7")
end

function modifier_bloodseeker_bloodrage_custom:OnCreated( kv )
self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
self.spell_amp = self:GetAbility():GetSpecialValueFor( "spell_amp" )
self.damage_pct = self:GetAbility():GetSpecialValueFor("damage_pct")
self.shard_max_health_dmg_pct = self:GetAbility():GetSpecialValueFor("shard_max_health_dmg_pct")

if not IsServer() then return end
self.self_k = 0
self.reduce_k = 0


self:StartIntervalThink(0.5)
end

function modifier_bloodseeker_bloodrage_custom:OnRefresh( kv )
self:OnCreated(table)
end

function modifier_bloodseeker_bloodrage_custom:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_incoming") and self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_3") then 
	self.reduce_k = self.reduce_k + 1
	if self.reduce_k >= self:GetAbility().reduce_delay/0.5 then 
		self.reduce_k = 0
		self:GetParent():EmitSound("BS.Bloodrage_reduction")
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_bloodrage_incoming", {})
	end
end

if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_7") then 

	self.self_k = self.self_k + 1 

	if self:GetStackCount() < self:GetAbility().legendary_max then 

		if self.self_k >= self:GetAbility().legendary_interval/0.5 then 
			self.self_k = 0
			self:IncrementStackCount()
			if self:GetStackCount() == self:GetAbility().legendary_max then 
				self.taunt_cd = 0

				if RollPercentage(50) then 
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "bloodseeker_blod_ability_blodrage_01"})
				else
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "bloodseeker_blod_ability_blodbath_0"..math.random(1,2)})
				
				end
			end
		end

	else 
		if self.self_k >= self.taunt_cd/0.5 and self:GetParent():GetForceAttackTarget() == nil then 

			local enemy_heroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().legendary_taunt_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			local enemy_creeps = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self:GetAbility().legendary_taunt_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
			local array = enemy_creeps


			if #enemy_heroes > 0 then 
				array = enemy_heroes
			end


			for _,enemy in pairs(array) do 
				if enemy:GetUnitName() ~= "npc_teleport" and not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
					self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_bloodrage_taunt", {target = enemy:entindex(), duration = self:GetAbility().legendary_taunt})
					
					self.taunt_cd = RandomInt(self:GetAbility().legendary_taunt_cd, self:GetAbility().legendary_taunt_cd_max)
					self.self_k = 0
					break
				end
			end
		end
	end

end

if self:GetParent():IsInvulnerable() then return end
if self:GetParent():GetHealth() <= 1 then return end
if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_6") and self:GetParent():GetHealthPercent() < self:GetAbility().lowhp_health then 

	SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(), self:GetParent():GetMaxHealth()*0.005*self:GetAbility().lowhp_regen, nil)
	return 
end

local self_damage = self:GetParent():GetMaxHealth() * ((self.damage_pct + self:GetStackCount()*self:GetAbility().legendary_self_damage) * 0.5 / 100)

ApplyDamage({attacker = self:GetCaster(), victim = self:GetParent(), damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), damage = self_damage, damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})


end

function modifier_bloodseeker_bloodrage_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_bloodseeker_bloodrage_custom:OnTooltip()
return (self.damage_pct + self:GetStackCount()*self:GetAbility().legendary_self_damage)
end




function modifier_bloodseeker_bloodrage_custom:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if self:GetStackCount() == 1 then 
    self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
end

ParticleManager:SetParticleControl(self.pfx, 2, Vector(self:GetStackCount(), 0 , 0))
ParticleManager:SetParticleControlEnt(self.pfx, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
self:AddParticle(self.pfx, false, false, -1, false, false)

if self:GetStackCount() == self:GetAbility().legendary_max then 
	ParticleManager:DestroyParticle(self.pfx, false)
	ParticleManager:ReleaseParticleIndex(self.pfx)

    self.pfx_2 = ParticleManager:CreateParticle("particles/bloodrage_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(self.pfx_2, 3, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, nil , self:GetParent():GetAbsOrigin(), true )
	self:AddParticle(self.pfx_2, false, false, -1, false, false)

	
end

end








function modifier_bloodseeker_bloodrage_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target == self:GetParent() then return end
if params.target:IsBuilding() then return end


if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_5") and not self:GetParent():HasModifier('modifier_bloodseeker_bloodrage_shield_cd') then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_bloodrage_shield_count", {duration = self:GetAbility().shield_attack_duration})
end

if self:GetParent():HasShard() then 

	local bonus_pure_damage = params.target:GetMaxHealth() * self.shard_max_health_dmg_pct / 100

	if params.target:IsCreep() and bonus_pure_damage > self:GetAbility():GetSpecialValueFor("shard_max_creeps") then 
		bonus_pure_damage = self:GetAbility():GetSpecialValueFor("shard_max_creeps")
	end

	self:GetParent():Heal(bonus_pure_damage, self:GetAbility())
	SendOverheadEventMessage(self:GetParent(), OVERHEAD_ALERT_HEAL, self:GetParent(), bonus_pure_damage, nil)


	ApplyDamage({attacker = self:GetParent(), victim = params.target, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), damage = bonus_pure_damage })
end


if not self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_4") then return end
if params.target:IsMagicImmune() then return end

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_bloodrage_blood", {duration = self:GetAbility().blood_duration})

end

function modifier_bloodseeker_bloodrage_custom:GetModifierHealthRegenPercentage()
if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_6") and self:GetParent():GetHealthPercent() < self:GetAbility().lowhp_health then 
	return self:GetAbility().lowhp_regen
end

end

function modifier_bloodseeker_bloodrage_custom:GetModifierSpellAmplify_Percentage()
local bonus = 0
if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_2") then 
	bonus = self:GetAbility().bonus_amp[self:GetParent():GetUpgradeStack("modifier_bloodseeker_bloodrage_2")]
end
	return self.spell_amp + bonus
end

function modifier_bloodseeker_bloodrage_custom:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_2") then 
	bonus = self:GetAbility().bonus_speed[self:GetParent():GetUpgradeStack("modifier_bloodseeker_bloodrage_2")]
end 
	return self.attack_speed + bonus
end







function modifier_bloodseeker_bloodrage_custom:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf"
end

function modifier_bloodseeker_bloodrage_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_bloodseeker_bloodrage_custom:GetModifierTotalDamageOutgoing_Percentage()
local bonus = 0
if self:GetStackCount() == self:GetAbility().legendary_max then 
	bonus = self:GetAbility().legendary_max_damage
end
return self:GetStackCount()*self:GetAbility().legendary_damage + bonus
end


function modifier_bloodseeker_bloodrage_custom:OnDestroy()
if not IsServer() then return end
self:GetParent():RemoveModifierByName("modifier_bloodseeker_bloodrage_shield_count")
self:GetParent():RemoveModifierByName("modifier_bloodseeker_bloodrage_incoming")
end








modifier_bloodseeker_bloodrage_tracker = class({})
function modifier_bloodseeker_bloodrage_tracker:IsHidden() 
return not self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_6") or self:GetParent():GetHealthPercent() > self:GetAbility().lowhp_health or 
not self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_custom")
end

function modifier_bloodseeker_bloodrage_tracker:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_tracker:GetTexture() return "buffs/bloodrage_lowhp" end

function modifier_bloodseeker_bloodrage_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_EVENT_ON_TAKEDAMAGE,

}
end
function modifier_bloodseeker_bloodrage_tracker:OnTooltip()
return self:GetAbility().lowhp_regen
end





function modifier_bloodseeker_bloodrage_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end


if params.unit:IsBuilding() then return end
if not self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_1") then return end
if not self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_custom") then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end


local heal = params.damage*self:GetAbility().damage_heal[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrage_1")]

if params.unit:IsCreep() then 
	heal = heal*self:GetAbility().damage_creeps
end
self:GetParent():Heal(heal, self:GetAbility())

local particle = ParticleManager:CreateParticle( "particles/sf_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:ReleaseParticleIndex( particle )
end




modifier_bloodseeker_bloodrage_blood = class({})
function modifier_bloodseeker_bloodrage_blood:IsHidden() return false end
function modifier_bloodseeker_bloodrage_blood:IsPurgable() return true end
function modifier_bloodseeker_bloodrage_blood:GetTexture() return "buffs/bloodrage_blood" end
function modifier_bloodseeker_bloodrage_blood:OnCreated(table)
self.damage = self:GetAbility().blood_damage/self:GetRemainingTime()
if not IsServer() then return end
self:SetStackCount(1)

self.table ={attacker = self:GetCaster(), victim = self:GetParent(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), }

self.particles = {}



self.particles[1] = ParticleManager:CreateParticle("particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particles[1], false, false, -1, false, false)


self:StartIntervalThink(self:GetAbility().blood_interval)
end

function modifier_bloodseeker_bloodrage_blood:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().blood_max[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrage_4")] then return end

self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().blood_max[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrage_4")] then 

	self:GetParent():EmitSound("BS.Bloodrage_blood")
	self.particles[2] = ParticleManager:CreateParticle("particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.particles[2], false, false, -1, false, false)

	self.particles[3] = ParticleManager:CreateParticle("particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(self.particles[3], false, false, -1, false, false)
end

end



function modifier_bloodseeker_bloodrage_blood:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if self:GetStackCount() == 1 then

	local particle_cast = "particles/units/heroes/hero_drow/bloodrage_blood.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end




function modifier_bloodseeker_bloodrage_blood:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_bloodseeker_bloodrage_blood:OnTooltip()
return self.damage*self:GetStackCount()
end


function modifier_bloodseeker_bloodrage_blood:OnIntervalThink()
if not IsServer() then return end
self.table.damage = self.damage*self:GetStackCount()



local damage = ApplyDamage(self.table)
SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage*self:GetStackCount(), nil)
	
self:GetCaster():GenericHeal(damage*self:GetAbility().blood_heal, self:GetAbility())


end


modifier_bloodseeker_bloodrage_taunt = class({})
function modifier_bloodseeker_bloodrage_taunt:IsHidden() return false end
function modifier_bloodseeker_bloodrage_taunt:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_taunt:IsDebuff() return true end
function modifier_bloodseeker_bloodrage_taunt:GetTexture() return "buffs/trance_slow" end


function modifier_bloodseeker_bloodrage_taunt:OnCreated(table)
if not IsServer() then return end
self.target = EntIndexToHScript(table.target)
self:GetParent():SetForceAttackTarget(self.target)
self:GetParent():MoveToTargetToAttack(self.target)
self:GetParent():EmitSound("BS.Bloodrage_taunt")
end

function modifier_bloodseeker_bloodrage_taunt:OnDeath(params)
if not IsServer() then return end
if self.target ~= params.unit then return end

self:Destroy()
end

function modifier_bloodseeker_bloodrage_taunt:CheckState()
return
{
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_TAUNTED] = true, 
    [MODIFIER_STATE_SILENCED] = true
}
end


function modifier_bloodseeker_bloodrage_taunt:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_bloodseeker_bloodrage_taunt:GetActivityTranslationModifiers()
	return "thirst"
end

function modifier_bloodseeker_bloodrage_taunt:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().legendary_speed
end


function modifier_bloodseeker_bloodrage_taunt:OnDestroy()
if not IsServer() then return end
self:GetParent():SetForceAttackTarget(nil)
end


function modifier_bloodseeker_bloodrage_taunt:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end


function modifier_bloodseeker_bloodrage_taunt:StatusEffectPriority()
	return 99999
end






modifier_bloodseeker_bloodrage_incoming = class({})
function modifier_bloodseeker_bloodrage_incoming:IsHidden() return false end
function modifier_bloodseeker_bloodrage_incoming:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_incoming:GetTexture() return "buffs/bloodrage_incoming" end
function modifier_bloodseeker_bloodrage_incoming:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end

function modifier_bloodseeker_bloodrage_incoming:GetModifierMoveSpeedBonus_Constant()
return self:GetAbility().reduce_move[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrage_3")]
end

function modifier_bloodseeker_bloodrage_incoming:GetModifierIncomingDamage_Percentage()
return self:GetAbility().reduce_damage[self:GetCaster():GetUpgradeStack("modifier_bloodseeker_bloodrage_3")]
end


function modifier_bloodseeker_bloodrage_incoming:OnCreated(table)
if not IsServer() then return end
self.pfx = ParticleManager:CreateParticle("particles/bloodrage_reduction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.pfx, false, false, -1, false, false)

end


modifier_bloodseeker_bloodrage_shield_cd = class({})
function modifier_bloodseeker_bloodrage_shield_cd:IsHidden() return false end
function modifier_bloodseeker_bloodrage_shield_cd:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_shield_cd:RemoveOnDeath() return false end
function modifier_bloodseeker_bloodrage_shield_cd:IsDebuff() return true end
function modifier_bloodseeker_bloodrage_shield_cd:GetTexture() return "buffs/berserker_active" end
function modifier_bloodseeker_bloodrage_shield_cd:OnCreated(table)
self.RemoveForDuel = true
end






modifier_bloodseeker_bloodrage_shield_count = class({})
function modifier_bloodseeker_bloodrage_shield_count:IsHidden() return false end
function modifier_bloodseeker_bloodrage_shield_count:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_shield_count:GetTexture() return "buffs/berserker_active" end


function modifier_bloodseeker_bloodrage_shield_count:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_bloodseeker_bloodrage_shield_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().shield_max then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility() , "modifier_bloodseeker_bloodrage_shield_cd", {duration = self:GetAbility().shield_cd})
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility() , "modifier_bloodseeker_bloodrage_shield", {duration = self:GetAbility().shield_duration})
	self:Destroy()
end

end



modifier_bloodseeker_bloodrage_shield = class({})
function modifier_bloodseeker_bloodrage_shield:IsHidden() return false end
function modifier_bloodseeker_bloodrage_shield:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_shield:GetTexture() return "buffs/berserker_active" end


function modifier_bloodseeker_bloodrage_shield:GetEffectName() return 
"particles/bloodseeker/bloodrage_shield.vpcf"
end



function modifier_bloodseeker_bloodrage_shield:OnCreated(table)
self.RemoveForDuel = true

self:AddShield()
end


function modifier_bloodseeker_bloodrage_shield:AddShield()


self.max_shield = self:GetParent():GetMaxHealth()*self:GetAbility().shield_health


self:SetStackCount(self.max_shield )

if not IsServer() then return end
self:GetParent():EmitSound("BS.Bloodrage_shield")
end

function modifier_bloodseeker_bloodrage_shield:OnRefresh(table)

self:AddShield()
end



function modifier_bloodseeker_bloodrage_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}

end

function modifier_bloodseeker_bloodrage_shield:GetModifierStatusResistanceStacking() 
	return self:GetAbility().shield_status
end





function modifier_bloodseeker_bloodrage_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end
if params.inflictor and params.inflictor == self:GetAbility() then 
	return
end

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


