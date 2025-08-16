LinkLuaModifier( "modifier_marci_unleash_custom", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_animation", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_fury", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_debuff", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_recovery", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_tracker", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_rage", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_unleash_custom_combo", "abilities/marci/marci_unleash_custom", LUA_MODIFIER_MOTION_NONE )

marci_unleash_custom = class({})


function marci_unleash_custom:CreateTalent()

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_marci_unleash_custom_rage", {})
end


function marci_unleash_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", context )
PrecacheResource( "particle", "particles/marci_rage_proc.vpcf", context )
PrecacheResource( "particle", "particles/marci_count.vpcf", context )

end


function marci_unleash_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_marci_unleash_custom_tracker"
end



function marci_unleash_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasTalent("modifier_marci_unleash_2") then  
	upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_marci_unleash_2", "cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end


function marci_unleash_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasTalent("modifier_marci_unleash_5") then
  bonus = DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + bonus
end




function marci_unleash_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor( "duration" )

if caster:HasTalent("modifier_marci_unleash_5") then 
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	caster:AddNewModifier(caster, self, "modifier_generic_debuff_immune", {effect = 1, duration = caster:GetTalentValue("modifier_marci_unleash_5", "bkb")})
end

caster:AddNewModifier( caster, self, "modifier_marci_unleash_custom", {duration = duration } )
end



function marci_unleash_custom:Pulse( center, ability )

local damage_ability = ability
local caster = self:GetCaster()
local radius = self:GetSpecialValueFor( "pulse_radius" )
local damage = self:GetSpecialValueFor( "pulse_damage" )
local damage_inc = caster:GetTalentValue("modifier_marci_unleash_4", "damage_inc")
local damage_duration = caster:GetTalentValue("modifier_marci_unleash_4", "duration")

local silence = self:GetSpecialValueFor("scepter_silence")

local enemies = caster:FindTargets(radius, center)
local damageTable = { attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, }
local use_silence = false

local unleash_mod = caster:FindModifierByName("modifier_marci_unleash_custom")
if unleash_mod and caster:HasScepter() then
	unleash_mod.silence_count = unleash_mod.silence_count + 1
	if unleash_mod.silence_count >= self:GetSpecialValueFor("scepter_count") then
		unleash_mod.silence_count = 0
		use_silence = true
	end
end

for _,enemy in pairs(enemies) do

	local final_damage = damage

	if enemy:HasModifier("modifier_marci_unleash_custom_combo") then 
		final_damage = final_damage + enemy:FindModifierByName("modifier_marci_unleash_custom_combo"):GetStackCount()*damage_inc
	end

	if caster:HasTalent("modifier_marci_unleash_4") then 
		enemy:AddNewModifier(caster, self, "modifier_marci_unleash_custom_combo", {duration = damage_duration})
	end

	if use_silence then 
		enemy:AddNewModifier( caster, self, "modifier_generic_silence", { duration = silence*(1 - enemy:GetStatusResistance()) } )
	end

	damageTable.victim = enemy
	damageTable.damage = final_damage
	DoDamage(damageTable, damage_ability)
end


local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( particle, 0, center )
ParticleManager:SetParticleControl( particle, 1, Vector(radius,radius,radius))
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex( particle )
EmitSoundOnLocationWithCaster( center, "Hero_Marci.Unleash.Pulse", caster )
end






modifier_marci_unleash_custom = class({})

function modifier_marci_unleash_custom:IsPurgable() return false end

function modifier_marci_unleash_custom:OnCreated( kv )

self.ability = self:GetAbility()
self.parent = self:GetParent()
self.bonus_ms = self.ability:GetSpecialValueFor( "bonus_movespeed" )
self.max_time = self:GetRemainingTime()
self.proced = false

self.silence_count = 0
if not IsServer() then return end

self.RemoveForDuel = true

self.ability:EndCooldown()
self.ability:SetActivated(false)

local mod = self.parent:FindModifierByName("modifier_marci_unleash_custom_rage")
if mod then 
	mod:AddRage(0)
end 


local fury = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom_fury", self.parent )
if fury then
	fury:ForceDestroy()
end

self.parent:AddNewModifier( self.parent, self.ability, "modifier_marci_unleash_custom_fury", {mini = 0} )

self:PlayEffects()

self.hammer = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
if self.hammer then
	self.hammer:AddEffects( EF_NODRAW )
end

end

function modifier_marci_unleash_custom:OnRefresh( kv )	
if not IsServer() then return end
self.mini = kv.mini
self:PlayEffects()
end


function modifier_marci_unleash_custom:OnDestroy()
if not IsServer() then return end

self.ability:SetActivated(true)
self.ability:UseResources(false, false, false, true)

local fury = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom_fury", self.parent )
if fury then
	fury:ForceDestroy()
end

local mod = self.parent:FindModifierByName("modifier_marci_unleash_custom_rage")
if mod then 
	mod:AddRage(0)
end 

local recovery = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom_recovery", self.parent )
if recovery then
	recovery:ForceDestroy()
end

if self.hammer then
	self.hammer:RemoveEffects( EF_NODRAW )	
end

end


function modifier_marci_unleash_custom:DeclareFunctions()
return  
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
}
end



function modifier_marci_unleash_custom:GetModifierMoveSpeedBonus_Percentage()
return self.bonus_ms
end

function modifier_marci_unleash_custom:GetActivityTranslationModifiers()
return "no_hammer"
end

function modifier_marci_unleash_custom:PlayEffects()
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:DestroyParticle(particle, false )
ParticleManager:ReleaseParticleIndex( particle )
self.parent:EmitSound("Hero_Marci.Unleash.Cast")
end





modifier_marci_unleash_custom_animation = class({})
function modifier_marci_unleash_custom_animation:IsHidden() return true end
function modifier_marci_unleash_custom_animation:IsPurgable() return false end
function modifier_marci_unleash_custom_animation:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
}
end

function modifier_marci_unleash_custom_animation:GetActivityTranslationModifiers()
if self:GetParent():HasModifier("modifier_marci_dispose_custom_hits") then return end
return "unleash"
end





modifier_marci_unleash_custom_debuff = class({})
function modifier_marci_unleash_custom_debuff:IsHidden() return false end
function modifier_marci_unleash_custom_debuff:IsPurgable() return true end
function modifier_marci_unleash_custom_debuff:OnCreated( kv )

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.as_slow = -self.ability:GetSpecialValueFor( "pulse_attack_slow_pct" ) + self.caster:GetTalentValue("modifier_marci_unleash_1", "speed")
self.ms_slow = -self.ability:GetSpecialValueFor( "pulse_move_slow_pct" )
end

function modifier_marci_unleash_custom_debuff:OnRefresh( kv )
self:OnCreated( kv )
end

function modifier_marci_unleash_custom_debuff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_marci_unleash_custom_debuff:GetModifierAttackSpeedBonus_Constant()
if self.parent:IsCreep() then return end
return self.as_slow
end

function modifier_marci_unleash_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.ms_slow
end

function modifier_marci_unleash_custom_debuff:GetEffectName()
return "particles/units/heroes/hero_marci/marci_unleash_pulse_debuff.vpcf"
end

function modifier_marci_unleash_custom_debuff:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_marci_unleash_custom_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_marci_unleash_custom_debuff:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL
end









modifier_marci_unleash_custom_recovery = class({})
function modifier_marci_unleash_custom_recovery:IsHidden() return false end
function modifier_marci_unleash_custom_recovery:IsDebuff() return true end
function modifier_marci_unleash_custom_recovery:IsPurgable() return false end

function modifier_marci_unleash_custom_recovery:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.rate = self:GetAbility():GetSpecialValueFor( "recovery_fixed_attack_rate" )
if not IsServer() then return end
self.success = kv.success==1
end

function modifier_marci_unleash_custom_recovery:OnRefresh( kv )
if not IsServer() then return end
self:OnCreated( kv )
end

function modifier_marci_unleash_custom_recovery:OnDestroy()
if not IsServer() then return end

local main = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom", self.parent )

if not main then return end
if self.forced then return end

self.parent:AddNewModifier( self.parent, self.ability, "modifier_marci_unleash_custom_fury", {mini = 0} )
end

function modifier_marci_unleash_custom_recovery:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
}
end

function modifier_marci_unleash_custom_recovery:GetModifierFixedAttackRate( params )
return self.rate
end

function modifier_marci_unleash_custom_recovery:ForceDestroy()
self.forced = true
self:Destroy()
end





modifier_marci_unleash_custom_fury = class({})
function modifier_marci_unleash_custom_fury:IsHidden() return false end
function modifier_marci_unleash_custom_fury:IsPurgable() return false end
function modifier_marci_unleash_custom_fury:OnCreated( kv )
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.parent:AddAttackStartEvent_out(self)

self.bonus_as = self.ability:GetSpecialValueFor( "flurry_bonus_attack_speed" )
self.recovery = self.ability:GetSpecialValueFor( "time_between_flurries" ) + self.parent:GetTalentValue("modifier_marci_unleash_1", "delay")
self.charges = self.ability:GetSpecialValueFor( "charges_per_flurry" )
self.timer = self.ability:GetSpecialValueFor( "max_time_window_per_hit" )

self.duration = self.ability:GetSpecialValueFor( "pulse_debuff_duration" )

self.cd_items = self.parent:GetTalentValue("modifier_marci_unleash_6", "cd")
self.cd_heal = self.parent:GetTalentValue("modifier_marci_unleash_6", "heal")/100

self.damage_reduction = self.ability:GetSpecialValueFor( "damage_reduction" ) + self.parent:GetTalentValue("modifier_marci_unleash_2", "damage")
if not IsServer() then return end
self.mini = kv.mini
self.counter = self.charges
self:SetStackCount( self.counter )
self.success = 0

self.animation = self.parent:AddNewModifier( self.parent, self.ability, "modifier_marci_unleash_custom_animation", {} )
self:PlayEffects1()
self:PlayEffects2( self.parent, self.counter )
end

function modifier_marci_unleash_custom_fury:OnRefresh()
if not IsServer() then return end
self:SetStackCount( self.counter )
end 

function modifier_marci_unleash_custom_fury:OnDestroy()
if not IsServer() then return end

if not self.animation:IsNull() then
	self.animation:Destroy()
end

local main = self.parent:FindModifierByNameAndCaster( "modifier_marci_unleash_custom", self.parent )
if not main then return end

if self.forced then return end

if self.mini == 1 then 
	self.parent:RemoveModifierByName("modifier_marci_unleash_custom")
	return
end

self.parent:AddNewModifier( self.parent, self.ability, "modifier_marci_unleash_custom_recovery", { duration = self.recovery, success = self.success, } )
end

function modifier_marci_unleash_custom_fury:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
}
end


function modifier_marci_unleash_custom_fury:GetModifierDamageOutgoing_Percentage()
if self.parent:HasModifier("modifier_marci_dispose_custom_attacks_caster") then return end
return self.damage_reduction
end


function modifier_marci_unleash_custom_fury:GetModifierAttackSpeed_Limit()
return 1
end

function modifier_marci_unleash_custom_fury:AttackStartEvent_out(params)
if self.parent ~= params.attacker then return end
if self.parent:HasModifier("modifier_marci_dispose_custom_attacks_caster") then return end

if self.mini == 0 then 
	self:StartIntervalThink( self.timer )
end

self.counter = self.counter - 1
self:SetStackCount( self.counter )

self:EditEffects2( self.counter )
self:PlayEffects3( self.parent, params.target )

if self.counter<=0 then
	self.success = 1

	if params.target:IsRealHero() and self.parent:GetQuest() == "Marci.Quest_8" and not self.parent:QuestCompleted() then 
		self.parent:UpdateQuest(1)
	end

	self.ability:Pulse( params.target:GetOrigin() )

	if self.parent:HasTalent("modifier_marci_unleash_6") then 
		self.parent:GenericHeal((self.parent:GetMaxHealth() - self.parent:GetHealth())*self.cd_heal, self.ability, nil, nil, "modifier_marci_unleash_6")
		self.parent:CdItems(self.cd_items)
	end 

	self:Destroy()
end

end


function modifier_marci_unleash_custom_fury:GetModifierAttackSpeedBonus_Constant()
return self.bonus_as
end

function modifier_marci_unleash_custom_fury:GetActivityTranslationModifiers()
if self.parent:HasModifier("modifier_marci_dispose_custom_hits") then return end
if self:GetStackCount()==1 then
	return "flurry_pulse_attack"
end

if self:GetStackCount()%2==0 then
	return "flurry_attack_b"
end

return "flurry_attack_a"
end

function modifier_marci_unleash_custom_fury:OnIntervalThink()
self:Destroy()
end


function modifier_marci_unleash_custom_fury:ForceDestroy()
self.forced = true
self:Destroy()
end

function modifier_marci_unleash_custom_fury:ShouldUseOverheadOffset()
return true
end

function modifier_marci_unleash_custom_fury:PlayEffects1()
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_buff.vpcf", PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( particle, 1, self.parent, PATTACH_POINT_FOLLOW, "eye_l", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 2, self.parent, PATTACH_POINT_FOLLOW, "eye_r", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 3, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 4, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 5, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true )
ParticleManager:SetParticleControlEnt( particle, 6, self.parent, PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true )
self:AddParticle( particle, false, false, -1, false, false  )

self.parent:EmitSound("Hero_Marci.Unleash.Charged")
EmitSoundOnClient( "Hero_Marci.Unleash.Charged.2D", self.parent:GetPlayerOwner() )
end



function modifier_marci_unleash_custom_fury:PlayEffects2( caster, counter )
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
ParticleManager:SetParticleControl( particle, 1, Vector( 0, counter, 0 ) )
self:AddParticle( particle, false, false, 1, false, true )
self.particle = particle
end


function modifier_marci_unleash_custom_fury:EditEffects2( counter )
ParticleManager:SetParticleControl( self.particle, 1, Vector( 0, counter, 0 ) )
end


function modifier_marci_unleash_custom_fury:PlayEffects3( caster, target )
local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:DestroyParticle(particle, false)
ParticleManager:ReleaseParticleIndex( particle )
end





modifier_marci_unleash_custom_tracker = class({})
function modifier_marci_unleash_custom_tracker:IsHidden() return true end
function modifier_marci_unleash_custom_tracker:IsPurgable() return false end
function modifier_marci_unleash_custom_tracker:OnCreated()
self.ability = self:GetAbility()

self.parent = self:GetParent()

self.bonus = self.parent:GetTalentValue("modifier_marci_unleash_3", "bonus", true)

self.range_bonus = self.parent:GetTalentValue("modifier_marci_unleash_6", "range", true)

self.parent:AddAttackEvent_out(self)
self.parent:AddSpellEvent(self)

self.skill_rage = self.parent:GetTalentValue("modifier_marci_unleash_7", "spell", true)
end


function modifier_marci_unleash_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}

end

function modifier_marci_unleash_custom_tracker:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_marci_unleash_3") then return end 

local speed = self.parent:GetTalentValue("modifier_marci_unleash_3", "speed")
if self.parent:HasModifier("modifier_marci_unleash_custom") then
	speed = speed*self.bonus
end 
return speed
end

function modifier_marci_unleash_custom_tracker:GetModifierStatusResistanceStacking()
if not self.parent:HasTalent("modifier_marci_unleash_3") then return end 

local status = self.parent:GetTalentValue("modifier_marci_unleash_3", "status")
if self.parent:HasModifier("modifier_marci_unleash_custom") then
	status = status*self.bonus
end 
return status
end


function modifier_marci_unleash_custom_tracker:GetModifierAttackRangeBonus()
if not self.parent:HasTalent("modifier_marci_unleash_6") then return end 
if not self.parent:HasModifier("modifier_marci_unleash_custom") and not self.parent:HasModifier("modifier_marci_unleash_custom_fury") then return end
return self.range_bonus
end

function modifier_marci_unleash_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasModifier("modifier_marci_unleash_custom_rage") and not self.parent:HasModifier("modifier_marci_unleash_custom_fury") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local rage = self.parent:FindModifierByName("modifier_marci_unleash_custom_rage")
local fury = self.parent:FindModifierByName("modifier_marci_unleash_custom_fury")

if rage then 
	rage:AddRage(rage.attack_rage)
end 

if fury then 
	params.target:AddNewModifier( self.parent, self.ability, "modifier_marci_unleash_custom_debuff", { duration = (1 - params.target:GetStatusResistance())*fury.duration } )
end 

end 

function modifier_marci_unleash_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end
if params.ability:IsItem() then return end

local mod = self.parent:FindModifierByName("modifier_marci_unleash_custom_rage")

if mod then 
	mod:AddRage(self.skill_rage)
end 

if not self.parent:HasScepter() then return end
--if not self.parent:HasModifier("modifier_marci_unleash_custom") then return end

self.ability:Pulse(self.parent:GetAbsOrigin())
end




modifier_marci_unleash_custom_rage = class({})
function modifier_marci_unleash_custom_rage:IsHidden() return true end
function modifier_marci_unleash_custom_rage:IsPurgable() return false end
function modifier_marci_unleash_custom_rage:RemoveOnDeath() return false end
function modifier_marci_unleash_custom_rage:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.parent:GetTalentValue("modifier_marci_unleash_7", "max", true)
self.timer = self.parent:GetTalentValue("modifier_marci_unleash_7", "timer", true)
self.attack_rage = self.parent:GetTalentValue("modifier_marci_unleash_7", "attack", true)
self.legendary_duration = self.parent:GetTalentValue("modifier_marci_unleash_7", "duration", true)
self.duration_add = self.parent:GetTalentValue("modifier_marci_unleash_7", "duration_add", true)

if not IsServer() then return end
self:SetStackCount(0)

self.interval = 0.3
self.damage_timer = self.timer

self:UpdateJS()
self:StartIntervalThink(self.interval)
end


function modifier_marci_unleash_custom_rage:AddRage(count)
if not IsServer() then return end

if count > 0 then 
	self.damage_timer = self.timer
end

self:SetStackCount(math.max(0, self:GetStackCount() + count))

if self:GetStackCount() >= self.max then 
	self:SetStackCount(0)

	self.parent:EmitSound("Marci.Unleash_rage")

	local mod = self.parent:FindModifierByName("modifier_marci_unleash_custom")
	if mod then 
		mod:SetDuration(mod:GetRemainingTime() + self.duration_add, true)
	else 
		self.parent:AddNewModifier( self.parent, self.ability, "modifier_marci_unleash_custom_fury", {duration = self.legendary_duration, mini = 1} )
	end

	local particle_peffect = ParticleManager:CreateParticle("particles/marci_rage_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControl(particle_peffect, 0, self.parent:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self.parent:GetAbsOrigin())
	ParticleManager:DestroyParticle(particle_peffect, false)
	ParticleManager:ReleaseParticleIndex(particle_peffect)
end

self:UpdateJS()
end


function modifier_marci_unleash_custom_rage:UpdateJS()
if not IsServer() then return end

local active = 0
local max = self.max
local mod = self.parent:FindModifierByName("modifier_marci_unleash_custom")

if mod then 
	active = 1
end

self.parent:UpdateUIlong({active = active, max = max, stack = self:GetStackCount(), no_min = 1, style = "MarciUnleash"})
end 



function modifier_marci_unleash_custom_rage:OnIntervalThink()
if not IsServer() then return end

if self.damage_timer > 0 then 
	self.damage_timer = self.damage_timer - self.interval
end 

if self.damage_timer <= 0 then 
	self.damage_timer = 0
	self:AddRage(-1)
end 

end












modifier_marci_unleash_custom_combo = class({})
function modifier_marci_unleash_custom_combo:IsHidden() return false end
function modifier_marci_unleash_custom_combo:IsPurgable() return false end
function modifier_marci_unleash_custom_combo:GetTexture() return "buffs/unleash_combo" end
function modifier_marci_unleash_custom_combo:OnCreated(table)

self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.max = self.caster:GetTalentValue("modifier_marci_unleash_4", "max")
self.damage = self.caster:GetTalentValue("modifier_marci_unleash_4", "damage_inc")
self.slow = self.caster:GetTalentValue("modifier_marci_unleash_4", "slow")

if not IsServer() then return end

self.effect_cast = ParticleManager:CreateParticle( "particles/marci_count.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
self.RemoveForDuel = true
end

function modifier_marci_unleash_custom_combo:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_marci_unleash_custom_combo:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_marci_unleash_custom_combo:GetModifierMoveSpeedBonus_Percentage()
return self.slow*self:GetStackCount()
end

function modifier_marci_unleash_custom_combo:OnTooltip()
return self.damage*self:GetStackCount()
end


function modifier_marci_unleash_custom_combo:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end 
if not self.effect_cast then return end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end



