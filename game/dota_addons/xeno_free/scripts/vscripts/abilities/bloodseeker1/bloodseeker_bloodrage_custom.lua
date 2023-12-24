LinkLuaModifier("modifier_bloodseeker_bloodrage_custom", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_tracker", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_blood", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_blood_count", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_taunt", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_shield", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_shield_count", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_shield_cd", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_slow", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)

bloodseeker_bloodrage_custom = class({})




bloodseeker_bloodrage_custom.damage_heal = {0.06 ,0.09, 0.12}
bloodseeker_bloodrage_custom.damage_creeps = 0.33




function bloodseeker_bloodrage_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_centaur/centaur_shard_buff_strength_counter_stack.vpcf', context )
PrecacheResource( "particle", 'particles/bloodrage_stack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf', context )
PrecacheResource( "particle", 'particles/sf_lifesteal.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_drow/bloodrage_blood.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_beserkers_call.vpcf', context )
PrecacheResource( "particle", 'particles/bloodrage_reduction.vpcf', context )
PrecacheResource( "particle", 'particles/bloodseeker/rage_count.vpcf', context )
PrecacheResource( "particle", "particles/bloodseeker/bloodrage_stack_main.vpcf", context )

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





function bloodseeker_bloodrage_custom:Taunt()

local radius = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "radius")

local enemy_heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
local enemy_creeps = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
local array = enemy_creeps

if #enemy_heroes > 0 then 
	array = enemy_heroes
end

local target = nil

for _,enemy in pairs(array) do 
	if enemy:GetUnitName() ~= "npc_teleport" and not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
		target = enemy:entindex()
		break
	end
end


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_bloodrage_taunt", {target = target, duration = (1 - self:GetCaster():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "taunt")})	
end


function bloodseeker_bloodrage_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrage_7") then 
 return self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "cd")
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
  	self:Activate()
  end
end 

end

function bloodseeker_bloodrage_custom:OnSpellStart()
self:Activate()
end


function bloodseeker_bloodrage_custom:Activate()

local duration = self:GetSpecialValueFor("duration")

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrage_7") then 
	duration = nil
end 

self:GetCaster():EmitSound("hero_bloodseeker.bloodRage")
self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_1)
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bloodseeker_bloodrage_custom", {duration = duration})
end




function bloodseeker_bloodrage_custom:GetIntrinsicModifierName()
return "modifier_bloodseeker_bloodrage_tracker"
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
self.shard_damage = self:GetAbility():GetSpecialValueFor("shard_damage")

self.legendary_max_timer = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "max_timer", true)
self.legendary_max = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "max", true)
self.legendary_interval = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "interval", true)
self.legendary_rage_fill = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "rage_fill", true)
self.legendary_rage_decay = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "rage_decay", true)
self.legendary_speed = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "speed", true)/self.legendary_max
self.legendary_damage = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_7", "damage", true)/self.legendary_max
self.rage = 0
self.legendary_max_rage = 100
self.legendary_max_rage_visual = 6

self.legendary_interval = self.legendary_max_timer/self.legendary_max

self.bonus_speed = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_2", "speed")
self.bonus_damage = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_2", "damage")

self.lowhp_health = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_6", "health", true)
self.lowhp_heal = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_6", "heal", true)
self.lowhp_damage = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_6", "damage_reduce", true)

self.legendary_count = 0
self.damage_count = 0

self.parent = self:GetParent()

if not IsServer() then return end
self.self_k = 0
self.reduce_k = 0

self.interval = 0.5
self.damage_interval = 0.5

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrage_7") then 
	self.interval = 0.03


	self.particle = ParticleManager:CreateParticle("particles/bloodseeker/rage_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.particle, false, false, -1, false, false)
end 

if self:GetCaster():HasModifier("modifier_bloodseeker_bloodrage_6") then 
	self.interval = 0.03
end 


self:StartIntervalThink(self.interval)
end

function modifier_bloodseeker_bloodrage_custom:OnRefresh( kv )
self:OnCreated(table)
end

function modifier_bloodseeker_bloodrage_custom:OnIntervalThink()
if not IsServer() then return end



if self.parent:HasModifier("modifier_bloodseeker_bloodrage_7") then 

	self.rage = self.rage + self.legendary_rage_fill*self.interval

	if self.particle then 

		local stack = math.floor(self.rage/(self.legendary_max_rage/self.legendary_max_rage_visual))


		for i = 1,self.legendary_max_rage_visual do 

			if i <= stack then 
				ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
			else 
				ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
			end
		end	
	end


	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'bloodseeker_rage_change',  {hide = 0, rage = self.rage, stack = self:GetStackCount(), max = self.legendary_max_rage})				
			
	if self.rage >= self.legendary_max_rage then 
		self:GetAbility():Taunt()
		self:GetAbility():ToggleAbility()
		return
	end 


	self.legendary_count = self.legendary_count + self.interval

	if self.legendary_count >= self.legendary_interval then 

		self.legendary_count = 0
		
		if self:GetStackCount() < self.legendary_max then 

			self:IncrementStackCount()

			if self:GetStackCount() >= self.legendary_max then 
				if RollPercentage(50) then 
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "bloodseeker_blod_ability_blodrage_01"})
				else
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "bloodseeker_blod_ability_blodbath_0"..math.random(1,2)})				
				end
			end
		end
	end
end

self.damage_count = self.damage_count + self.interval


if self.parent:HasModifier("modifier_bloodseeker_bloodrage_6") then 

	if self.parent:GetHealthPercent() <= self.lowhp_health and not self.lowhp_particle then 

		self.lowhp_particle = ParticleManager:CreateParticle( "particles/bloodrage_reduction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
		self:AddParticle(self.lowhp_particle,false, false, -1, false, false)

		self.parent:EmitSound("BS.Bloodrage_reduction")

	end 

	if self.parent:GetHealthPercent() > self.lowhp_health and self.lowhp_particle then 
		ParticleManager:DestroyParticle(self.lowhp_particle, true)
		ParticleManager:ReleaseParticleIndex(self.lowhp_particle)

		self.lowhp_particle = nil
	end 


end 



if self.damage_count < self.damage_interval then return end
self.damage_count = 0


if self.parent:IsInvulnerable() then return end
if self.parent:GetHealth() <= 1 then return end
if self.parent:HasModifier("modifier_bloodseeker_bloodrage_6") and self.parent:GetHealthPercent() < self.lowhp_health then 

	self.parent:SendNumber(10, (self.parent:GetMaxHealth()*self.lowhp_heal/100)*self.damage_interval)
	return 
end

local self_damage = self.parent:GetMaxHealth() * (self.damage_pct  * self.damage_interval) / 100

ApplyDamage({attacker = self:GetCaster(), victim = self.parent, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), damage = self_damage, damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK})


end

function modifier_bloodseeker_bloodrage_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_bloodseeker_bloodrage_custom:OnTooltip()
return (self.damage_pct)
end


function modifier_bloodseeker_bloodrage_custom:GetModifierHealthRegenPercentage()
if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_6") and self:GetParent():GetHealthPercent() < self.lowhp_health then 
	return self.lowhp_heal
end

end



function modifier_bloodseeker_bloodrage_custom:GetModifierIncomingDamage_Percentage()
if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_6") and self:GetParent():GetHealthPercent() < self.lowhp_health then 
	return self.lowhp_damage
end

end


function modifier_bloodseeker_bloodrage_custom:GetModifierSpellAmplify_Percentage()
local bonus = 0

if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_2") then 
	bonus = self.bonus_damage
end

if self:GetStackCount() > 0 then 
	bonus = bonus + self:GetStackCount()*self.legendary_damage
end 

return self.spell_amp + bonus
end

function modifier_bloodseeker_bloodrage_custom:GetModifierAttackSpeedBonus_Constant()
local bonus = 0

if self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_2") then 
	bonus = self.bonus_speed
end 


if self:GetStackCount() > 0 then 
	bonus = bonus + self:GetStackCount()*self.legendary_speed
end 

return self.attack_speed + bonus
end



function modifier_bloodseeker_bloodrage_custom:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf"
end

function modifier_bloodseeker_bloodrage_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



function modifier_bloodseeker_bloodrage_custom:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'bloodseeker_rage_change',  {hide = 1, rage = 0, stack = self:GetStackCount(), max = self.legendary_max_rage})				
				
self:GetParent():RemoveModifierByName("modifier_bloodseeker_bloodrage_shield_count")
end








modifier_bloodseeker_bloodrage_tracker = class({})
function modifier_bloodseeker_bloodrage_tracker:IsHidden() 
return true
end

function modifier_bloodseeker_bloodrage_tracker:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_tracker:GetTexture() return "buffs/bloodrage_lowhp" end

function modifier_bloodseeker_bloodrage_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED

}
end


function modifier_bloodseeker_bloodrage_tracker:OnCreated()

self.parent = self:GetParent()
self.blood_duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_4", "duration", true)

self.slow_duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_3", "duration", true)

self.shield_duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_5", "duration", true)
end 


function modifier_bloodseeker_bloodrage_tracker:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_bloodseeker_bloodrage_3") then return end 

return self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_3", "range")
end


function modifier_bloodseeker_bloodrage_tracker:OnAttackLanded(params)
if not IsServer() then return end

local mod = self.parent:FindModifierByName("modifier_bloodseeker_bloodrage_custom")
if self.parent ~= params.attacker then return end
if params.target == self.parent then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

if mod and self.parent:HasModifier("modifier_bloodseeker_bloodrage_7") then 
	mod.rage = math.max(0, mod.rage + mod.legendary_rage_decay)
end 

if self.parent:HasModifier("modifier_bloodseeker_bloodrage_4") then 
	params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_bloodseeker_bloodrage_blood", {duration = self.blood_duration})
	params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_bloodseeker_bloodrage_blood_count", {duration = self.blood_duration})
end 

if mod and self.parent:HasModifier("modifier_bloodseeker_bloodrage_3") then 
	params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_bloodseeker_bloodrage_slow", {duration = self.slow_duration})
end 

if mod and self.parent:HasModifier("modifier_bloodseeker_bloodrage_5") and not self.parent:HasModifier('modifier_bloodseeker_bloodrage_shield_cd')
	and not self.parent:HasModifier("modifier_bloodseeker_bloodrage_shield") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bloodseeker_bloodrage_shield_count", {duration = self.shield_duration})
end

if mod and  self:GetParent():HasShard() then 

	local bonus_pure_damage =  mod.shard_damage

	self.parent:GenericHeal(bonus_pure_damage, self:GetAbility(), true)

	ApplyDamage({attacker = self.parent, victim = params.target, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), damage = bonus_pure_damage })
end

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
function modifier_bloodseeker_bloodrage_blood:IsHidden() return true end
function modifier_bloodseeker_bloodrage_blood:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_blood:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_bloodseeker_bloodrage_blood:OnCreated(table)
if not IsServer() then return end

end

function modifier_bloodseeker_bloodrage_blood:OnDestroy()
if not IsServer() then return end 

local mod = self:GetParent():FindModifierByName("modifier_bloodseeker_bloodrage_blood_count")
if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() < 1 then 
		mod:Destroy()
	end 
end 

end 



modifier_bloodseeker_bloodrage_blood_count = class({})
function modifier_bloodseeker_bloodrage_blood_count:IsHidden() return false end
function modifier_bloodseeker_bloodrage_blood_count:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_blood_count:GetTexture() return "buffs/bloodrage_blood" end
function modifier_bloodseeker_bloodrage_blood_count:OnCreated(table)
if not IsServer() then return end

self.interval = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_4", "interval")
self.damage = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_4", "damage")*self.interval
self.heal = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_4", "heal")/100

self.table ={attacker = self:GetCaster(), victim = self:GetParent(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), }

self.effect_cast = ParticleManager:CreateParticle( "particles/bloodseeker/bloodrage_stack_main.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)

for i = 1,2 do 
	local particles = ParticleManager:CreateParticle("particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(particles, false, false, -1, false, false)
end

self:StartIntervalThink(self.interval)
end


function modifier_bloodseeker_bloodrage_blood_count:OnIntervalThink()
if not IsServer() then return end 

self.table.damage = self.damage*self:GetStackCount()
local damage = ApplyDamage(self.table)

self:GetCaster():GenericHeal(damage*self.heal, self:GetAbility(), true, "")

end 


function modifier_bloodseeker_bloodrage_blood_count:OnRefresh()
if not IsServer() then return end

self:IncrementStackCount()
end 


function modifier_bloodseeker_bloodrage_blood_count:OnStackCountChanged(iStackCount)
if not self.effect_cast then return end

local k1 = 0
local k2 = self:GetStackCount()

if k2 >= 10 then 
    k1 = 1
    k2 = self:GetStackCount() - 10
end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( k1, k2, 0 ) )


end























modifier_bloodseeker_bloodrage_taunt = class({})
function modifier_bloodseeker_bloodrage_taunt:IsHidden() return true end
function modifier_bloodseeker_bloodrage_taunt:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_taunt:IsDebuff() return true end
function modifier_bloodseeker_bloodrage_taunt:GetTexture() return "buffs/trance_slow" end


function modifier_bloodseeker_bloodrage_taunt:OnCreated(table)
if not IsServer() then return end

if table.target then 
	self.target = EntIndexToHScript(table.target)
	self:GetParent():SetForceAttackTarget(self.target)
	self:GetParent():MoveToTargetToAttack(self.target)
end

self:GetParent():EmitSound("BS.Bloodrage_taunt")
end

function modifier_bloodseeker_bloodrage_taunt:OnDeath(params)
if not IsServer() then return end
if not self.target then return end
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
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_bloodseeker_bloodrage_taunt:GetActivityTranslationModifiers()
	return "thirst"
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

self.shield_duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_5", "duration", true)
self.cd = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_5", "cd", true)
self.max = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_5", "max", true)

self:SetStackCount(1)
end

function modifier_bloodseeker_bloodrage_shield_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility() , "modifier_bloodseeker_bloodrage_shield_cd", {duration = self.cd})
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility() , "modifier_bloodseeker_bloodrage_shield", {duration = self.shield_duration})
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

self.max_shield = self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_5", "health")/100


self.status = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_5", "status")

if not IsServer() then return end
self:SetStackCount(self.max_shield )
self:GetParent():EmitSound("BS.Bloodrage_shield")
end




function modifier_bloodseeker_bloodrage_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}

end

function modifier_bloodseeker_bloodrage_shield:GetModifierStatusResistanceStacking() 
	return self.status
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




modifier_bloodseeker_bloodrage_slow = class({})
function modifier_bloodseeker_bloodrage_slow:IsHidden() return false end
function modifier_bloodseeker_bloodrage_slow:IsPurgable() return true end
function modifier_bloodseeker_bloodrage_slow:GetTexture() return "buffs/bloodrage_slow" end
function modifier_bloodseeker_bloodrage_slow:OnCreated()

self.move = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_3", "move")
self.attack = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_3", "attack")
self.max = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_3", "max")

self:SetStackCount(1)
end 


function modifier_bloodseeker_bloodrage_slow:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self:GetParent():EmitSound("DOTA_Item.Maim")
end 

end 


function modifier_bloodseeker_bloodrage_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_bloodseeker_bloodrage_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move*self:GetStackCount()
end

function modifier_bloodseeker_bloodrage_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack*self:GetStackCount()
end