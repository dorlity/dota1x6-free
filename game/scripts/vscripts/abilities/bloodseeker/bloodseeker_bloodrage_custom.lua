LinkLuaModifier("modifier_bloodseeker_bloodrage_custom", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_tracker", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_blood", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_blood_count", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_taunt", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_slow", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_charge", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_charge_cd", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bloodseeker_bloodrage_charge_root", "abilities/bloodseeker/bloodseeker_bloodrage_custom", LUA_MODIFIER_MOTION_NONE)

bloodseeker_bloodrage_custom = class({})


function bloodseeker_bloodrage_custom:CreateTalent()

self:GetCaster():RemoveModifierByName("modifier_bloodseeker_bloodrage_custom")
end



function bloodseeker_bloodrage_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/bloodseeker/rage_count.vpcf", context )
PrecacheResource( "particle", "particles/bloodseeker/thirst_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf", context )
PrecacheResource( "particle", "particles/bloodseeker/bloodrage_stack_main.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/sange_maim.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/bloodrage_reduction.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf", context )
PrecacheResource( "particle", "particles/bs_root.vpcf", context )
end



function bloodseeker_bloodrage_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_bloodseeker_bloodrage_7") then
  return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL
end



function bloodseeker_bloodrage_custom:GetManaCost(level)
if self:GetCaster():HasTalent("modifier_bloodseeker_bloodrage_7") then  
  return 0
end
return self.BaseClass.GetManaCost(self,level) 
end


function bloodseeker_bloodrage_custom:Taunt()
local caster = self:GetCaster()
local radius = caster:GetTalentValue("modifier_bloodseeker_bloodrage_7", "radius")

local enemy_heroes = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
local enemy_creeps = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
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

caster:AddNewModifier(caster, self, "modifier_bloodseeker_bloodrage_taunt", {target = target, duration = (1 - caster:GetStatusResistance())*caster:GetTalentValue("modifier_bloodseeker_bloodrage_7", "taunt")})	
end


function bloodseeker_bloodrage_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasTalent("modifier_bloodseeker_bloodrage_7") then 
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

local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration")

if caster:HasTalent("modifier_bloodseeker_bloodrage_7") then 
	duration = nil
end 
local slark_mod = caster:FindModifierByName("modifier_slark_essence_shift_custom_legendary_steal")
if slark_mod then
  duration = slark_mod:GetRemainingTime()
end

caster:EmitSound("hero_bloodseeker.bloodRage")

if not caster:IsStunned() then 
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
end

caster:AddNewModifier(caster, self, "modifier_bloodseeker_bloodrage_custom", {duration = duration})
end


function bloodseeker_bloodrage_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_bloodseeker_bloodrage_tracker"
end



modifier_bloodseeker_bloodrage_custom = class({})

function modifier_bloodseeker_bloodrage_custom:IsHidden()
	return false
end

function modifier_bloodseeker_bloodrage_custom:IsPurgable()
	return not self:GetParent():HasTalent("modifier_bloodseeker_bloodrage_7")
end

function modifier_bloodseeker_bloodrage_custom:OnCreated( kv )

self.parent = self:GetParent()
self.parent:AddAttackRecordEvent_out(self)

self.ability = self:GetAbility()

self.attack_speed = self.ability:GetSpecialValueFor( "attack_speed" ) + self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_2", "speed")
self.spell_amp = self.ability:GetSpecialValueFor( "spell_amp" ) + self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_2", "damage")
self.damage_pct = self.ability:GetSpecialValueFor("damage_pct")
self.shard_damage = self.ability:GetSpecialValueFor("shard_damage")

self.legendary_max_timer = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_7", "max_timer", true)
self.legendary_max = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_7", "max", true)
self.legendary_interval = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_7", "interval", true)
self.legendary_rage_fill = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_7", "rage_fill", true)
self.legendary_rage_decay = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_7", "rage_decay", true)
self.legendary_bonus = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_7", "bonus", true)/self.legendary_max

self.charge_range = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_5", "range", true)
self.charge_duration = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_5", "duration", true)
self.charge_cd = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_5", "cd", true)
 
self.rage = 0
self.legendary_max_rage = 100
self.legendary_max_rage_visual = 6

self.legendary_interval = self.legendary_max_timer/self.legendary_max

self.lowhp_health = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_6", "health", true)
self.lowhp_heal = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_6", "heal", true)
self.lowhp_damage_reduce = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_6", "damage_reduce", true)

if self.parent:HasTalent("modifier_bloodseeker_bloodrage_6") then
	self.damage_pct = self.damage_pct*(1 + self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_6", "health_cost")/100)
end

self.legendary_count = 0
self.damage_count = 0

if not IsServer() then return end
self.self_k = 0
self.reduce_k = 0

self.interval = 0.5
self.damage_interval = 0.5

if self.parent:HasTalent("modifier_bloodseeker_bloodrage_7") then 
	self.interval = 0.03

	self.particle = ParticleManager:CreateParticle("particles/bloodseeker/rage_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	self:AddParticle(self.particle, false, false, -1, false, false)
end 

if self.parent:HasTalent("modifier_bloodseeker_bloodrage_6") then 
	self.interval = 0.03
end 

self:StartIntervalThink(self.interval)
end

function modifier_bloodseeker_bloodrage_custom:OnRefresh( kv )
self:OnCreated(table)
end

function modifier_bloodseeker_bloodrage_custom:OnIntervalThink()
if not IsServer() then return end

if self.parent:HasTalent("modifier_bloodseeker_bloodrage_7") then 

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

	self.parent:UpdateUIshort({stack_icon = self:GetStackCount(), time = self.rage, max_time = self.legendary_max_rage, style = "BloodseekerRage", priority = 1})

	if self.rage >= self.legendary_max_rage then 
		self.ability:Taunt()
		self.ability:ToggleAbility()
		return
	end 


	self.legendary_count = self.legendary_count + self.interval

	if self.legendary_count >= self.legendary_interval then 

		self.legendary_count = 0
		
		if self:GetStackCount() < self.legendary_max then 

			self:IncrementStackCount()

			if self:GetStackCount() >= self.legendary_max then 
				if RollPercentage(50) then 
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "generic_sound",  {sound = "bloodseeker_blod_ability_blodrage_01"})
				else
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "generic_sound",  {sound = "bloodseeker_blod_ability_blodbath_0"..math.random(1,2)})				
				end
			end
		end
	end
end

self.damage_count = self.damage_count + self.interval


if self.parent:HasTalent("modifier_bloodseeker_bloodrage_6") then 

	if self.parent:GetHealthPercent() <= self.lowhp_health and not self.lowhp_particle then 
		self.lowhp_particle = self.parent:GenericParticle("particles/bloodrage_reduction.vpcf", self)
		self.parent:EmitSound("BS.Bloodrage_bva")
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
if self.parent:HasTalent("modifier_bloodseeker_bloodrage_6") and self.parent:GetHealthPercent() < self.lowhp_health then 

	self.parent:SendNumber(10, (self.parent:GetMaxHealth()*self.lowhp_heal/100)*self.damage_interval)
	return 
end

local self_damage = self.parent:GetMaxHealth() * (self.damage_pct  * self.damage_interval) / 100

DoDamage({attacker = self.parent, victim = self.parent, damage_type = DAMAGE_TYPE_PURE, ability = self.ability, damage = self_damage, damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_BYPASSES_PHYSICAL_BLOCK})
end


function modifier_bloodseeker_bloodrage_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end

function modifier_bloodseeker_bloodrage_custom:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_bloodseeker_bloodrage_5") then return end
if self.parent:HasModifier("modifier_bloodseeker_bloodrage_charge_cd") then return end
return self.charge_range
end

function modifier_bloodseeker_bloodrage_custom:GetModifierHealthRegenPercentage()
if self.parent:HasTalent("modifier_bloodseeker_bloodrage_6") and self.parent:GetHealthPercent() < self.lowhp_health then 
	return self.lowhp_heal
end

end

function modifier_bloodseeker_bloodrage_custom:GetModifierIncomingDamage_Percentage()
if self.parent:HasTalent("modifier_bloodseeker_bloodrage_6") and self.parent:GetHealthPercent() < self.lowhp_health then 
	return self.lowhp_damage_reduce
end

end

function modifier_bloodseeker_bloodrage_custom:GetModifierSpellAmplify_Percentage()
local bonus = self.spell_amp
if self:GetStackCount() > 0 then 
	bonus = bonus*(1 + self:GetStackCount()*self.legendary_bonus/100)
end 
return bonus
end

function modifier_bloodseeker_bloodrage_custom:GetModifierAttackSpeedBonus_Constant()
local bonus = self.attack_speed
if self:GetStackCount() > 0 then 
	bonus = bonus*(1 + self:GetStackCount()*self.legendary_bonus/100)
end 
return bonus
end

function modifier_bloodseeker_bloodrage_custom:GetEffectName()
return "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf"
end

function modifier_bloodseeker_bloodrage_custom:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_bloodseeker_bloodrage_custom:OnDestroy()
if not IsServer() then return end
self.parent:UpdateUIshort({hide = 1, style = "BloodseekerRage", priority = 1})
end

function modifier_bloodseeker_bloodrage_custom:AttackRecordEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_bloodseeker_bloodrage_5") then return end
if self.parent:HasModifier("modifier_bloodseeker_bloodrage_charge_cd") then return end
if self.parent:GetForceAttackTarget() then return end
if self.parent ~= params.attacker then return end 
if not params.target:IsUnit() and not params.target:IsBuilding() then return end
self.parent:Stop()
self.parent:EmitSound("BS.Bloodrite_charge1")
self.parent:EmitSound("BS.Bloodrite_charge2")
self.parent:AddNewModifier(self.parent, self.ability, "modifier_bloodseeker_bloodrage_charge", {duration = self.charge_duration, target = params.target:entindex()})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_bloodseeker_bloodrage_charge_cd", {duration = self.charge_cd})
end


modifier_bloodseeker_bloodrage_charge_cd = class({})
function modifier_bloodseeker_bloodrage_charge_cd:IsHidden() return false end
function modifier_bloodseeker_bloodrage_charge_cd:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_charge_cd:IsDebuff() return true end
function modifier_bloodseeker_bloodrage_charge_cd:RemoveOnDeath() return false end
function modifier_bloodseeker_bloodrage_charge_cd:GetTexture() return "buffs/berserker_active" end
function modifier_bloodseeker_bloodrage_charge_cd:OnCreated()
self.RemoveForDuel = true
end


modifier_bloodseeker_bloodrage_charge = class({})

function modifier_bloodseeker_bloodrage_charge:IsHidden() return true end
function modifier_bloodseeker_bloodrage_charge:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_charge:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.root = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_5", "root")
self.speed = self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_5", "speed")

if not IsServer() then return end
self.target = EntIndexToHScript(table.target)

--self.parent:MoveToTargetToAttack(self.target)
--self.parent:SetForceAttackTarget(self.target)

self.parent:GenericParticle("particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf", self)

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_bloodseeker_bloodrage_charge:GetStatusEffectName()
return "particles/econ/items/invoker/invoker_ti7/status_effect_alacrity_ti7.vpcf"
end

function modifier_bloodseeker_bloodrage_charge:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end

function modifier_bloodseeker_bloodrage_charge:OnIntervalThink()
if not IsServer() then return end

if not self.target or self.target:IsNull() or not self.target:IsAlive() then
	self:Destroy()
	return
end

self.parent:MoveToPositionAggressive(self.target:GetAbsOrigin())
self.parent:MoveToPosition(self.target:GetAbsOrigin())


if self.parent:IsHexed() or self.parent:IsStunned() or self.parent:IsFeared() or self.parent:IsInvulnerable() then
	self:Destroy()
	return
end

local length = (self.parent:GetAbsOrigin() - self.target:GetAbsOrigin()):Length2D()

if length > 2000 then
	self:Destroy()
	return
end

if length <= 200 then
	self.parent:MoveToTargetToAttack(self.target)
	self.proc_root = true
	self:Destroy()
	return
end

end

function modifier_bloodseeker_bloodrage_charge:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
}
end

function modifier_bloodseeker_bloodrage_charge:GetModifierMoveSpeed_Absolute()
return self.speed
end

function modifier_bloodseeker_bloodrage_charge:GetActivityTranslationModifiers()
return "thirst"
end

function modifier_bloodseeker_bloodrage_charge:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
--	[MODIFIER_STATE_MUTED] = true
}
end

function modifier_bloodseeker_bloodrage_charge:OnDestroy()
if not IsServer() then return end

if self.proc_root then
	self.target:AddNewModifier(self.parent, self.ability, "modifier_bloodseeker_bloodrage_charge_root", {duration = (1 - self.target:GetStatusResistance())*self.root})
end

end



modifier_bloodseeker_bloodrage_charge_root = class({})
function modifier_bloodseeker_bloodrage_charge_root:IsHidden() return true end
function modifier_bloodseeker_bloodrage_charge_root:IsPurgable() return true end
function modifier_bloodseeker_bloodrage_charge_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end
function modifier_bloodseeker_bloodrage_charge_root:OnCreated()
self.parent = self:GetParent()
if not IsServer() then return end
self.parent:EmitSound("BS.Bloodrite_root")
self.parent:GenericParticle("particles/bs_root.vpcf", self)
end





modifier_bloodseeker_bloodrage_tracker = class({})
function modifier_bloodseeker_bloodrage_tracker:IsHidden() return true end
function modifier_bloodseeker_bloodrage_tracker:IsPurgable() return false end
function modifier_bloodseeker_bloodrage_tracker:GetTexture() return "buffs/bloodrage_lowhp" end
function modifier_bloodseeker_bloodrage_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
}
end

function modifier_bloodseeker_bloodrage_tracker:OnCreated()
self.parent = self:GetParent()

self.parent:AddAttackEvent_out(self)

self.blood_duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_4", "duration", true)
self.slow_duration = self:GetCaster():GetTalentValue("modifier_bloodseeker_bloodrage_3", "duration", true)
end 


function modifier_bloodseeker_bloodrage_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_bloodseeker_bloodrage_1") then return end 
return self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_1", "range")
end


function modifier_bloodseeker_bloodrage_tracker:AttackEvent_out(params)
if not IsServer() then return end

local mod = self.parent:FindModifierByName("modifier_bloodseeker_bloodrage_custom")
if self.parent ~= params.attacker then return end
if params.target == self.parent then return end
if not params.target:IsUnit() then return end

if mod and self.parent:HasTalent("modifier_bloodseeker_bloodrage_7") then 
	mod.rage = math.max(0, mod.rage + mod.legendary_rage_decay)
end 

if self.parent:HasTalent("modifier_bloodseeker_bloodrage_4") then 
	params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_bloodseeker_bloodrage_blood", {duration = self.blood_duration})
	params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_bloodseeker_bloodrage_blood_count", {duration = self.blood_duration})
end 

if mod and self.parent:HasTalent("modifier_bloodseeker_bloodrage_3") then 
	params.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_bloodseeker_bloodrage_slow", {duration = self.slow_duration})
end 

if mod and self.parent:HasTalent("modifier_bloodseeker_bloodrage_1") then 
	DoCleaveAttack( self.parent, params.target, self.ability, self.parent:GetTalentValue("modifier_bloodseeker_bloodrage_1", "cleave")*params.damage/100, 150, 360, 650, "particles/bloodseeker/thirst_cleave.vpcf" )
end  

if mod and  self:GetParent():HasShard() then 

	local bonus_pure_damage =  mod.shard_damage

	self.parent:GenericHeal(bonus_pure_damage, self:GetAbility(), true, nil, "shard")

	DoDamage({attacker = self.parent, victim = params.target, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), damage = bonus_pure_damage }, "shard")
end

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

--self.effect_cast = ParticleManager:CreateParticle( "particles/bloodseeker/bloodrage_stack_main.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
--self:AddParticle(self.effect_cast,false, false, -1, false, false)

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
local damage = DoDamage(self.table, "modifier_bloodseeker_bloodrage_4")

self:GetCaster():GenericHeal(damage*self.heal, self:GetAbility(), true, "", "modifier_bloodseeker_bloodrage_4")

end 


function modifier_bloodseeker_bloodrage_blood_count:OnRefresh()
if not IsServer() then return end

self:IncrementStackCount()
end 


function modifier_bloodseeker_bloodrage_blood_count:OnStackCountChanged(iStackCount)
if true then return end
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
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

if table.target then 
	self.target = EntIndexToHScript(table.target)
	self:GetParent():SetForceAttackTarget(self.target)
	self:GetParent():MoveToTargetToAttack(self.target)
end

self:GetParent():EmitSound("BS.Bloodrage_taunt")
end

function modifier_bloodseeker_bloodrage_taunt:DeathEvent(params)
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
return MODIFIER_PRIORITY_ULTRA 
end




modifier_bloodseeker_bloodrage_slow = class({})
function modifier_bloodseeker_bloodrage_slow:IsHidden() return false end
function modifier_bloodseeker_bloodrage_slow:IsPurgable() return true end
function modifier_bloodseeker_bloodrage_slow:GetTexture() return "buffs/bloodrage_slow" end
function modifier_bloodseeker_bloodrage_slow:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.max = self.caster:GetTalentValue("modifier_bloodseeker_bloodrage_3", "max")
self.move = self.caster:GetTalentValue("modifier_bloodseeker_bloodrage_3", "move")/self.max
self.attack = self.caster:GetTalentValue("modifier_bloodseeker_bloodrage_3", "attack")/self.max
self:SetStackCount(1)
end 

function modifier_bloodseeker_bloodrage_slow:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self.parent :EmitSound("DOTA_Item.Maim")
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


