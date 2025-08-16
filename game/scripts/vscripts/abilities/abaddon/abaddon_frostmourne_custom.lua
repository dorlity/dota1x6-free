LinkLuaModifier( "modifier_abaddon_frostmourne_custom", "abilities/abaddon/abaddon_frostmourne_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_custom_count", "abilities/abaddon/abaddon_frostmourne_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_custom_curse", "abilities/abaddon/abaddon_frostmourne_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_custom_buff", "abilities/abaddon/abaddon_frostmourne_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_custom_legendary", "abilities/abaddon/abaddon_frostmourne_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_custom_legendary_stats", "abilities/abaddon/abaddon_frostmourne_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_custom_illusion", "abilities/abaddon/abaddon_frostmourne_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_custom_illusion_count", "abilities/abaddon/abaddon_frostmourne_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_abaddon_frostmourne_custom_silence_slow", "abilities/abaddon/abaddon_frostmourne_custom", LUA_MODIFIER_MOTION_NONE )




abaddon_frostmourne_custom = class({})

function abaddon_frostmourne_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_abaddon_alliance_weapon_custom") then
    return "abaddon_frostmourne_alliance"
end
return "abaddon_frostmourne"
end

function abaddon_frostmourne_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/abaddon/curse_legendary.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/curse_proc.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/curse_cleave.vpcf" , context )
PrecacheResource( "particle", "particles/abaddon/curse_legendary_active_attack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_frost_slow.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_frost.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_abaddon_frostmourne.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_silence.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_frost_buff.vpcf" , context )
PrecacheResource( "particle", "particles/abaddon/curse_legendary_active.vpcf", context )
PrecacheResource( "particle", "particles/abaddon/curse_legendary_active_circle.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_dark_seer_illusion.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf", context )
end



function abaddon_frostmourne_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end 
return "modifier_abaddon_frostmourne_custom"
end


function abaddon_frostmourne_custom:GetCooldown(iLevel)
if not self:GetCaster():HasTalent("modifier_abaddon_curse_7") then return end 
return self:GetCaster():GetTalentValue("modifier_abaddon_curse_7", "talent_cd")
end 

function abaddon_frostmourne_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_abaddon_curse_7") then 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function abaddon_frostmourne_custom:GetAbilityTargetFlags()
if self:GetCaster():HasTalent("modifier_abaddon_hero_7") then 
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
  return DOTA_UNIT_TARGET_FLAG_NONE
end

end


function abaddon_frostmourne_custom:ProcIllusion(target)
local caster = self:GetCaster()
if not caster:HasTalent("modifier_abaddon_curse_3") then return end

target:EmitSound("Hero_Abaddon.Curse.Proc")

local duration = caster:GetTalentValue("modifier_abaddon_curse_3", "duration")
local damage = caster:GetTalentValue("modifier_abaddon_curse_3", "damage") - 100
local illusion = CreateIllusions( caster, caster, {duration=duration, outgoing_damage=damage,incoming_damage=0}, 1, 0, false, true)  

for _,illusion in pairs(illusion) do
	for _,mod in pairs(caster:FindAllModifiers()) do
	    if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
	        illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
	    end
	end
	illusion.owner = caster
	FindClearSpaceForUnit(illusion, target:GetAbsOrigin() + RandomVector(200), false)
	illusion:AddNewModifier(caster, self, "modifier_abaddon_frostmourne_custom_illusion", {target = target:entindex()})
end

end




function abaddon_frostmourne_custom:OnSpellStart()
local caster = self:GetCaster()
if not caster:HasTalent("modifier_abaddon_curse_7") then return end

local effect = ParticleManager:CreateParticle("particles/abaddon/curse_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:ReleaseParticleIndex(effect)

caster:EmitSound("Abaddon.Curse_legendary1")
caster:EmitSound("Abaddon.Curse_legendary2")
caster:EmitSound("Abaddon.Curse_legendary3")

caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
caster:AddNewModifier(caster, self, "modifier_abaddon_frostmourne_custom_legendary", {duration = caster:GetTalentValue("modifier_abaddon_curse_7", "duration")})
end 






modifier_abaddon_frostmourne_custom = class({})
function modifier_abaddon_frostmourne_custom:IsHidden() return true end
function modifier_abaddon_frostmourne_custom:IsPurgable() return false end
function modifier_abaddon_frostmourne_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

if self.parent:IsRealHero() then 
	self.parent:AddAttackEvent_out(self, true)
end

self.buff_duration = self.ability:GetSpecialValueFor("slow_duration")


self.legendary_duration  = self.parent:GetTalentValue("modifier_abaddon_curse_7", "stack_duration", true)
self.legendary_duration_creeps = self.parent:GetTalentValue("modifier_abaddon_curse_7", "duration_creeps", true)

self.illusion_max = self.parent:GetTalentValue("modifier_abaddon_curse_3", "max", true)
self.illusion_effect = self.parent:GetTalentValue("modifier_abaddon_curse_3", "effect_duration", true)
self.heal_creeps = self.parent:GetTalentValue("modifier_abaddon_curse_3", "creeps", true)
self.heal = self.parent:GetTalentValue("modifier_abaddon_curse_3", "heal", true)

self.silence_duration = self.parent:GetTalentValue("modifier_abaddon_curse_4", "effect_duration", true)

self.cleave_damage = self.parent:GetTalentValue("modifier_abaddon_curse_2", "cleave")/100
self.range_bonus = self.parent:GetTalentValue("modifier_abaddon_curse_2", "range")

if not IsServer() then return end

self.player = PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID())
self:SetStackCount(0)

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end 


function modifier_abaddon_frostmourne_custom:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_abaddon_curse_2" or self.parent:HasTalent("modifier_abaddon_curse_2") then 
	self.cleave_damage = self.parent:GetTalentValue("modifier_abaddon_curse_2", "cleave")/100
	self.range_bonus = self.parent:GetTalentValue("modifier_abaddon_curse_2", "range")
end

if name == "modifier_abaddon_curse_3" or self.parent:HasTalent("modifier_abaddon_curse_3") then
	self.parent:AddDamageEvent_out(self, true)
end

if name == "modifier_abaddon_curse_7" or self.parent:HasTalent("modifier_abaddon_curse_7") then
	self:StartIntervalThink(0.2)
end

self:SendBuffRefreshToClients()
end

function modifier_abaddon_frostmourne_custom:AddCustomTransmitterData() 
return 
{
	range_bonus = self.range_bonus
} 
end

function modifier_abaddon_frostmourne_custom:HandleCustomTransmitterData(data)
self.range_bonus = data.range_bonus
end

function modifier_abaddon_frostmourne_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end

function modifier_abaddon_frostmourne_custom:GetModifierAttackRangeBonus()
return self.range_bonus
end

function modifier_abaddon_frostmourne_custom:OnIntervalThink()
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_abaddon_curse_7") then return end 

local stack = 0
local max_timer = 1
local timer = 0
local phase = 0

local mod = self.parent:FindModifierByName("modifier_abaddon_frostmourne_custom_legendary_stats")
local active_mod = self.parent:FindModifierByName("modifier_abaddon_frostmourne_custom_legendary")

if mod then
	timer = mod:GetRemainingTime() 
	max_timer = mod.max_timer
	stack = mod:GetStackCount()
end

if active_mod then 
	phase = 1
	timer = active_mod:GetRemainingTime()
	max_timer = active_mod.max_timer
	stack = stack*active_mod.stats_bonus
end 

self.parent:UpdateUIlong({override_stack = stack, max = max_timer, stack = timer, style = "AbaddonCurse", no_min = true, active = phase})
end 


function modifier_abaddon_frostmourne_custom:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_abaddon_curse_3") then return end
if not params.attacker:HasModifier("modifier_abaddon_frostmourne_custom_illusion") then return end
if not params.unit:IsUnit() then return end
if params.attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end

local heal = params.damage*self.heal/100
if params.unit:IsCreep() then 
	heal = heal/self.heal_creeps
end
self.parent:GenericHeal(heal, self.ability, false, nil, "modifier_abaddon_curse_3")
end


function modifier_abaddon_frostmourne_custom:AttackEvent_out(params)
if not IsServer() then return end 
if not params.target:IsUnit() then return end 
local attacker = params.attacker
local target = params.target

if attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end

if (self.parent == attacker or (attacker.owner and attacker:IsIllusion() and attacker.owner == self.parent)) and not attacker:PassivesDisabled() then 
	target:AddNewModifier(self.parent, self.parent:BkbAbility(self.ability, self.parent:HasTalent("modifier_abaddon_hero_7")), "modifier_abaddon_frostmourne_custom_curse", {duration = self.buff_duration})
end

local illusion_mod = attacker:FindModifierByName("modifier_abaddon_frostmourne_custom_illusion")
if illusion_mod and illusion_mod.attack_count then
	illusion_mod.attack_count = illusion_mod.attack_count - 1
	if illusion_mod.attack_count == 0 then
		illusion_mod:SetDuration(0.2, false)
	end
end

if self.parent ~= attacker then return end 

if self.parent:HasTalent("modifier_abaddon_curse_2") then 
	DoCleaveAttack( self.parent, target, self.ability, self.cleave_damage*params.damage, 150, 360, 650, "particles/abaddon/curse_cleave.vpcf" )
end 

if self.parent:HasTalent("modifier_abaddon_curse_4") and not self.parent:PassivesDisabled() and not target:HasModifier("modifier_abaddon_frostmourne_custom_silence_slow") then 
	target:AddNewModifier(self.parent, self.ability, "modifier_abaddon_frostmourne_custom_count", {duration = self.silence_duration})
end

if self.parent:HasTalent("modifier_abaddon_curse_3") and not self.parent:PassivesDisabled() then 
	target:AddNewModifier(self.parent, self.ability, "modifier_abaddon_frostmourne_custom_illusion_count", {duration = self.illusion_effect})
end

if self.parent:HasTalent("modifier_abaddon_curse_7") then
	if self.parent:HasModifier("modifier_abaddon_frostmourne_custom_legendary") then 
		local effect_cast = ParticleManager:CreateParticle( "particles/abaddon/curse_legendary_active_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
		ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() + Vector( 0, 0, 64 ) )
		ParticleManager:SetParticleControlForward( effect_cast, 3, (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized() )
		ParticleManager:ReleaseParticleIndex( effect_cast )
		target:EmitSound("Abaddon.Curse_legendary_attack")
	end

	local duration = self.legendary_duration 
	if target:IsCreep() then 
		duration = self.legendary_duration_creeps
	else 
		target:AddNewModifier(self.parent, self.parent:BkbAbility(nil, true), "modifier_abaddon_frostmourne_custom_legendary_stats", {duration = duration})
	end
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_abaddon_frostmourne_custom_legendary_stats", {duration = duration})
end


end






modifier_abaddon_frostmourne_custom_curse = class({})
function modifier_abaddon_frostmourne_custom_curse:IsHidden() return false end
function modifier_abaddon_frostmourne_custom_curse:IsPurgable() return true end
function modifier_abaddon_frostmourne_custom_curse:GetTexture() return "abaddon_frostmourne" end
function modifier_abaddon_frostmourne_custom_curse:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self.caster:FindAbilityByName("abaddon_frostmourne_custom")

if not self.ability then 
	self:Destroy()
	return
end

self.max = self.caster:GetTalentValue("modifier_abaddon_curse_1", "max", true)

self.slow = self.ability:GetSpecialValueFor("curse_slow")*-1 + self.caster:GetTalentValue("modifier_abaddon_hero_7", "speed")
self.interval = self.ability:GetSpecialValueFor("curse_interval")
self.damage = self.ability:GetSpecialValueFor("curse_dps")
self.buff_duration = self.ability:GetSpecialValueFor("slow_duration")

self.damage_inc = self.caster:GetTalentValue("modifier_abaddon_curse_1", "damage")

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

if not IsServer() then return end
self.parent:AddAttackEvent_inc(self, true)

self.parent:EmitSound("Hero_Abaddon.Curse.Proc")
self:StartIntervalThink(self.interval)
end

function modifier_abaddon_frostmourne_custom_curse:AttackEvent_inc(params)
if not IsServer() then return end
if params.target ~= self.parent then return end
if params.attacker:GetTeamNumber() ~= self.caster:GetTeamNumber() then return end
if not params.attacker:IsUnit() then return end

params.attacker:AddNewModifier(self.caster, self.ability, "modifier_abaddon_frostmourne_custom_buff", {duration = self.buff_duration, stack = self:GetStackCount()})

if params.attacker ~= self.caster then return end
if not self.caster:HasTalent("modifier_abaddon_curse_1") then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_abaddon_frostmourne_custom_curse:OnIntervalThink()
if not IsServer() then return end 

local damage = self.damage
if self:GetStackCount() > 0 and self.caster:HasTalent("modifier_abaddon_curse_1") then
	damage = self.damage_inc*self:GetStackCount() + damage
end

damage = damage*self.interval

if self.caster:GetQuest() == "Abaddon.Quest_7" and not self.caster:QuestCompleted() and self.parent:IsRealHero() then 
	self.caster:UpdateQuest(self.interval)
end

self.damageTable.damage = damage
DoDamage(self.damageTable)
end 


function modifier_abaddon_frostmourne_custom_curse:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_abaddon_frostmourne_custom_curse:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_abaddon_frostmourne_custom_curse:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
function modifier_abaddon_frostmourne_custom_curse:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_abaddon_frostmourne_custom_curse:GetStatusEffectName() return "particles/status_fx/status_effect_abaddon_frostmourne.vpcf" end
function modifier_abaddon_frostmourne_custom_curse:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL end





modifier_abaddon_frostmourne_custom_count = class(mod_hidden)
function modifier_abaddon_frostmourne_custom_count:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.max = self.caster:GetTalentValue("modifier_abaddon_curse_4", "max")
self:SetStackCount(1)
end 

function modifier_abaddon_frostmourne_custom_count:OnRefresh(table)
if not IsServer() then return end 
self:IncrementStackCount()

if self:GetStackCount() < self.max then return end

self.parent:EmitSound("Sf.Raze_Silence")
self.parent:AddNewModifier(self.caster, self.ability, "modifier_abaddon_frostmourne_custom_silence_slow", {duration = self.caster:GetTalentValue("modifier_abaddon_curse_4", "duration")*(1 - self.parent:GetStatusResistance())})
self:Destroy()
end 

function modifier_abaddon_frostmourne_custom_count:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if not self.pfx then
    self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
	self:AddParticle( self.pfx, false, false, -1, false, false )
end

ParticleManager:SetParticleControl(self.pfx, 1, Vector(0, self:GetStackCount(), 0))
end




modifier_abaddon_frostmourne_custom_illusion_count = class({})
function modifier_abaddon_frostmourne_custom_illusion_count:IsHidden() return true end
function modifier_abaddon_frostmourne_custom_illusion_count:IsPurgable() return false end
function modifier_abaddon_frostmourne_custom_illusion_count:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.caster:GetTalentValue("modifier_abaddon_curse_3", "max")
self:SetStackCount(1)
end 

function modifier_abaddon_frostmourne_custom_illusion_count:OnRefresh(table)
if not IsServer() then return end 
self:IncrementStackCount()

if self:GetStackCount() < self.max then return end

self.ability:ProcIllusion(self.parent)
self:Destroy()
end 



modifier_abaddon_frostmourne_custom_buff = class({})
function modifier_abaddon_frostmourne_custom_buff:IsHidden() return false end
function modifier_abaddon_frostmourne_custom_buff:IsPurgable() return false end
function modifier_abaddon_frostmourne_custom_buff:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.speed = self.ability:GetSpecialValueFor("curse_attack_speed")
self.speed_bonus = self.caster:GetTalentValue("modifier_abaddon_curse_1", "speed")

self.move_bonus = self.caster:GetTalentValue("modifier_abaddon_hero_7", "speed")*-1

if not IsServer() then return end
self:SetStackCount(table.stack)
end

function modifier_abaddon_frostmourne_custom_buff:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(table.stack)
end

function modifier_abaddon_frostmourne_custom_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_abaddon_frostmourne_custom_buff:GetModifierAttackSpeedBonus_Constant()
return self.speed + self:GetStackCount()*self.speed_bonus
end

function modifier_abaddon_frostmourne_custom_buff:GetModifierMoveSpeedBonus_Percentage()
return self.move_bonus
end

function modifier_abaddon_frostmourne_custom_buff:GetEffectName() 
return "particles/units/heroes/hero_abaddon/abaddon_frost_buff.vpcf" 
end

function modifier_abaddon_frostmourne_custom_buff:GetEffectAttachType() 
return PATTACH_ABSORIGIN_FOLLOW 
end










modifier_abaddon_frostmourne_custom_legendary = class({})
function modifier_abaddon_frostmourne_custom_legendary:IsHidden() return true end
function modifier_abaddon_frostmourne_custom_legendary:IsPurgable() return false end
function modifier_abaddon_frostmourne_custom_legendary:OnCreated()
self.RemoveForDuel = true

self.ability = self:GetAbility()
self.parent = self:GetParent()
self.stats_bonus = self.parent:GetTalentValue("modifier_abaddon_curse_7", "bonus")

if not IsServer() then return end 
self.pfx = ParticleManager:CreateParticle("particles/abaddon/curse_legendary_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.pfx, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.pfx, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.pfx, 4, self.parent, PATTACH_OVERHEAD_FOLLOW, nil, self.parent:GetAbsOrigin(), true)
self:AddParticle(self.pfx, false, false, -1, false, false)

self.pfx2 = ParticleManager:CreateParticle("particles/abaddon/curse_legendary_active_circle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl( self.pfx2, 3, self.parent:GetOrigin())
self:AddParticle(self.pfx2, false, false, -1, false, false)

self.max_timer = self:GetRemainingTime()

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end 

function modifier_abaddon_frostmourne_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE,
}
end

function modifier_abaddon_frostmourne_custom_legendary:GetModifierModelScale()
return 25
end






modifier_abaddon_frostmourne_custom_legendary_stats = class({})
function modifier_abaddon_frostmourne_custom_legendary_stats:IsHidden() return not self.is_enemy end
function modifier_abaddon_frostmourne_custom_legendary_stats:IsPurgable() return false end
function modifier_abaddon_frostmourne_custom_legendary_stats:GetTexture() return "buffs/sunder_speed" end
function modifier_abaddon_frostmourne_custom_legendary_stats:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.stats = self.caster:GetTalentValue("modifier_abaddon_curse_7", "stats")
self.stats_bonus = self.caster:GetTalentValue("modifier_abaddon_curse_7", "bonus")

self.is_enemy = self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber()

if self.is_enemy then 
	self.stats = self.stats*-1
end 

if not IsServer() then return end 
self.RemoveForDuel = true
self:AddStack(table.duration)
end

function modifier_abaddon_frostmourne_custom_legendary_stats:OnRefresh(table)
if not IsServer() then return end 
self:AddStack(table.duration)
end 


function modifier_abaddon_frostmourne_custom_legendary_stats:AddStack(duration)
if not IsServer() then return end

self.max_timer = self:GetRemainingTime()

Timers:CreateTimer(duration, function() 
	if self and not self:IsNull() then 
		self:DecrementStackCount()
		if self:GetStackCount() <= 0 then 
			self:Destroy()
		end 
	end 
end)

self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end 

function modifier_abaddon_frostmourne_custom_legendary_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end


function modifier_abaddon_frostmourne_custom_legendary_stats:GetModifierBonusStats_Agility()
local bonus = self.stats*self:GetStackCount()
if self.caster:HasModifier("modifier_abaddon_frostmourne_custom_legendary") and not self.is_enemy then 
	bonus = bonus*self.stats_bonus
end 
return bonus
end

function modifier_abaddon_frostmourne_custom_legendary_stats:GetModifierBonusStats_Strength()
local bonus = self.stats*self:GetStackCount()
if self.caster:HasModifier("modifier_abaddon_frostmourne_custom_legendary") and not self.is_enemy then 
	bonus = bonus*self.stats_bonus
end 
return bonus
end

function modifier_abaddon_frostmourne_custom_legendary_stats:GetModifierBonusStats_Intellect()
local bonus = self.stats*self:GetStackCount()
if self.caster:HasModifier("modifier_abaddon_frostmourne_custom_legendary") and not self.is_enemy then 
	bonus = bonus*self.stats_bonus
end 
return bonus
end









modifier_abaddon_frostmourne_custom_illusion = class({})
function modifier_abaddon_frostmourne_custom_illusion:IsHidden() return true end
function modifier_abaddon_frostmourne_custom_illusion:IsPurgable() return false end
function modifier_abaddon_frostmourne_custom_illusion:OnCreated(params)
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.stats = self.caster:GetTalentValue("modifier_abaddon_curse_7", "stats")
self.stats_bonus = self.caster:GetTalentValue("modifier_abaddon_curse_7", "bonus")

self.attacks = self.caster:GetTalentValue("modifier_abaddon_curse_3", "attacks")
self.range = self.caster:GetTalentValue("modifier_abaddon_curse_2", "range")

if not IsServer() then return end

self.attack_count = self.attacks

self.target = EntIndexToHScript(params.target)
self:OnIntervalThink()
self:StartIntervalThink(0.2)
end 

function modifier_abaddon_frostmourne_custom_illusion:OnIntervalThink()
if not IsServer() then return end

local mod = self.caster:FindModifierByName("modifier_abaddon_frostmourne_custom_legendary_stats")
if mod then 
	self:SetStackCount(mod:GetStackCount())
end 

if self.caster:HasModifier("modifier_abaddon_frostmourne_custom_legendary") and not self.pfx2 then 
	self.pfx2 = ParticleManager:CreateParticle("particles/abaddon/curse_legendary_active_circle.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl( self.pfx2, 3, self.parent:GetOrigin())
	self:AddParticle(self.pfx2, false, false, -1, false, false)
end 

if not self.caster:HasModifier("modifier_abaddon_frostmourne_custom_legendary") and self.pfx2 then 
	ParticleManager:DestroyParticle(self.pfx2, false)
	ParticleManager:ReleaseParticleIndex(self.pfx2)
	self.pfx2 = nil
end

if self.target and not self.target:IsNull() and self.target:IsAlive() then
	if self.parent:GetForceAttackTarget() == nil then  
		self.parent:SetForceAttackTarget(self.target)
	end
else 
	if self.parent:GetForceAttackTarget() then
		self.parent:SetForceAttackTarget(nil)
		self.parent:MoveToPositionAggressive(self.parent:GetAbsOrigin())
	end
end 

end 

function modifier_abaddon_frostmourne_custom_illusion:OnDestroy()
if not IsServer() then return end
self.parent:Kill(nil, nil)
end

function modifier_abaddon_frostmourne_custom_illusion:CheckState()
return
{
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_INVULNERABLE] = true
}
end

function modifier_abaddon_frostmourne_custom_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_dark_seer_illusion.vpcf" end
function modifier_abaddon_frostmourne_custom_illusion:StatusEffectPriority() return MODIFIER_PRIORITY_ILLUSION end
function modifier_abaddon_frostmourne_custom_illusion:GetEffectName() return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf" end
function modifier_abaddon_frostmourne_custom_illusion:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_abaddon_frostmourne_custom_illusion:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_abaddon_frostmourne_custom_illusion:GetModifierAttackRangeBonus()
return self.range
end

function modifier_abaddon_frostmourne_custom_illusion:GetModifierMoveSpeed_Absolute()
return 550
end

function modifier_abaddon_frostmourne_custom_illusion:GetModifierModelScale()
return 20
end

function modifier_abaddon_frostmourne_custom_illusion:GetModifierBonusStats_Agility()
local bonus = self.stats*self:GetStackCount()
if self.caster:HasModifier("modifier_abaddon_frostmourne_custom_legendary") then 
	bonus = bonus*self.stats_bonus
end 
return bonus
end

function modifier_abaddon_frostmourne_custom_illusion:GetModifierBonusStats_Strength()
local bonus = self.stats*self:GetStackCount()
if self.caster:HasModifier("modifier_abaddon_frostmourne_custom_legendary") then 
	bonus = bonus*self.stats_bonus
end 
return bonus
end

function modifier_abaddon_frostmourne_custom_illusion:GetModifierBonusStats_Intellect()
local bonus = self.stats*self:GetStackCount()
if self.caster:HasModifier("modifier_abaddon_frostmourne_custom_legendary") then 
	bonus = bonus*self.stats_bonus
end 
return bonus
end

modifier_abaddon_frostmourne_custom_silence_slow = class({})
function modifier_abaddon_frostmourne_custom_silence_slow:IsHidden() return true end
function modifier_abaddon_frostmourne_custom_silence_slow:IsPurgable() return true end
function modifier_abaddon_frostmourne_custom_silence_slow:OnCreated()
self.attack_slow = self:GetCaster():GetTalentValue("modifier_abaddon_curse_4", "attack_slow")
if not IsServer() then return end 
self:GetParent():GenericParticle("particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff.vpcf", self)
end

function modifier_abaddon_frostmourne_custom_silence_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_abaddon_frostmourne_custom_silence_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack_slow
end

function modifier_abaddon_frostmourne_custom_silence_slow:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end

function modifier_abaddon_frostmourne_custom_silence_slow:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_abaddon_frostmourne_custom_silence_slow:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end





