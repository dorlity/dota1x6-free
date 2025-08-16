LinkLuaModifier( "modifier_axe_counter_helix_custom", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_shard_debuff", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_legendary", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_cd", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_count", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_damage", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_attack_speed", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_legendary_active", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_stun_cd", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_shield", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_counter_helix_custom_shield_cd", "abilities/axe/axe_counter_helix_custom", LUA_MODIFIER_MOTION_NONE )


axe_counter_helix_custom = class({})


function axe_counter_helix_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_counterhelix.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/ascetic_cap.vpcf", context )
PrecacheResource( "particle", "particles/axe_spin.vpcf", context )
PrecacheResource( "particle", "particles/items2_fx/sange_maim.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/hook_root.vpcf", context )
PrecacheResource( "particle", "particles/axe/axe_charge.vpcf", context )
PrecacheResource( "particle", "particles/axe/helix_legendary_effect.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_onslaught_impact.vpcf", context )
PrecacheResource( "particle", "particles/axe/helix_shield.vpcf", context )

PrecacheResource( "particle", "particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf", context )
end

function axe_counter_helix_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_axe_persona_custom") then
    return "axe_counter_helix_unleashed"
end
return "axe_counter_helix"
end

function axe_counter_helix_custom:GetIntrinsicModifierName()
return "modifier_axe_counter_helix_custom"
end

function axe_counter_helix_custom:GetCooldown(level)
local caster = self:GetCaster()
if caster:HasTalent("modifier_axe_helix_legendary") then 
	return caster:GetTalentValue("modifier_axe_helix_legendary", "talent_cd")
end
if caster:HasScepter() then 
	return 0
end
return self.BaseClass.GetCooldown( self, level )
end


function axe_counter_helix_custom:GetBehavior()
return self:GetCaster():HasTalent("modifier_axe_helix_legendary") and DOTA_ABILITY_BEHAVIOR_NO_TARGET or DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function axe_counter_helix_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = caster:GetTalentValue("modifier_axe_helix_legendary", "duration")

caster:AddNewModifier(caster, self, "modifier_axe_counter_helix_custom_legendary", {duration = duration})
end



function axe_counter_helix_custom:Spin(use_cd, ability)
if not IsServer() then return end

local caster = self:GetCaster()
local anim_k = ability == "modifier_axe_helix_legendary" and 1.2 or 1

if ability ~= "modifier_axe_helix_legendary" then
	caster:FadeGesture(ACT_DOTA_CAST_ABILITY_3)
end

caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, anim_k)

local radius = self:GetSpecialValueFor( "radius" ) + caster:GetTalentValue("modifier_axe_helix_2", "radius")
local damage = self:GetSpecialValueFor("damage")
local scepter_duration = self:GetSpecialValueFor("scepter_duration")

local mod = caster:FindModifierByName("modifier_axe_counter_helix_custom_damage")
if mod then
	damage = damage + mod:GetStackCount()*caster:GetTalentValue("modifier_axe_helix_3", "damage")
end

local shield_cd = caster:FindModifierByName("modifier_axe_counter_helix_custom_shield_cd")
if shield_cd then
	shield_cd:ReduceCd()
end

local damage_ability = nil
if ability then 
	damage_ability = ability
end 

if caster:HasTalent("modifier_axe_helix_3") then 
	local heal = caster:GetTalentValue("modifier_axe_helix_3", "heal")*damage/100
	caster:GenericHeal(heal, self, nil, nil, "modifier_axe_helix_3")
end

local damageTable = {attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self}

if caster:HasTalent("modifier_axe_helix_1") or caster:HasTalent("modifier_axe_hero_3") then 
	caster:AddNewModifier(caster, self, "modifier_axe_counter_helix_custom_attack_speed", {duration = caster:GetTalentValue("modifier_axe_helix_1", "duration", true)})
end

local hit_type = 0
local proc_stun = false
local stun_duration = caster:GetTalentValue("modifier_axe_helix_4", "stun")
if caster:HasTalent("modifier_axe_helix_4") and not caster:HasBasher() and not caster:HasModifier("modifier_axe_counter_helix_custom_stun_cd") then
	proc_stun = RollPseudoRandomPercentage(caster:GetTalentValue("modifier_axe_helix_4", "chance"), 1969, caster)
	if proc_stun then
		caster:AddNewModifier(caster, self, "modifier_axe_counter_helix_custom_stun_cd", {duration = caster:GetTalentValue("modifier_axe_helix_4", "talent_cd")})
	end
end

for _,enemy in pairs(caster:FindTargets(radius)) do
	damageTable.victim = enemy
	DoDamage( damageTable, damage_ability )

	if hit_type == 0 then
		hit_type = 1
	end
	if enemy:IsRealHero() then
		hit_type = 2
	end

	if proc_stun then
		enemy:EmitSound("DOTA_Item.SkullBasher")
		local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, enemy)
		ParticleManager:SetParticleControlEnt(hit_effect, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
		ParticleManager:SetParticleControlEnt(hit_effect, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), false) 
		ParticleManager:Delete(hit_effect, 1)
		enemy:AddNewModifier(caster, self, "modifier_bashed", {duration = (1 - enemy:GetStatusResistance())*stun_duration})
	end

	if caster:HasScepter() then
		enemy:AddNewModifier(caster, self, "modifier_axe_counter_helix_custom_shard_debuff", {duration = scepter_duration })
	end
end

if caster:HasTalent("modifier_axe_helix_3") and hit_type > 0 then 
	local duration = hit_type == 2 and caster:GetTalentValue("modifier_axe_helix_3", "duration") or caster:GetTalentValue("modifier_axe_helix_3", "duration_creeps")
	caster:AddNewModifier(caster, self, "modifier_axe_counter_helix_custom_damage", {duration = duration})
end

local sound = "Hero_Axe.CounterHelix"
local particle_name = "particles/units/heroes/hero_axe/axe_counterhelix.vpcf"
if caster:HasModifier("modifier_blood_chaser_axe_custom") or proc_stun then
    sound = "Hero_Axe.CounterHelix_Blood_Chaser"
    particle_name = "particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf"
end
if caster:HasModifier("modifier_axe_persona_custom") then
    particle_name = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_attack_blur_counterhelix.vpcf"
end
caster:GenericParticle(particle_name)
caster:EmitSound(sound)

if use_cd == 1 and not caster:HasScepter() then 
	if caster:HasTalent("modifier_axe_helix_legendary") then 
		caster:AddNewModifier(caster, self, "modifier_axe_counter_helix_custom_cd", {duration = self:GetSpecialValueFor("cooldown")*caster:GetCooldownReduction()})
	else 
		self:UseResources( false, false, false, true )
	end
end

end




modifier_axe_counter_helix_custom = class(mod_hidden)
function modifier_axe_counter_helix_custom:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:AddAttackEvent_out(self, true)
self.parent:AddAttackEvent_inc(self, true)

self.attack_range = self.parent:GetTalentValue("modifier_axe_helix_2", "attack_range")

self.has_shield = self.parent:HasTalent("modifier_axe_hero_7")
self.shield_duration = self.parent:GetTalentValue("modifier_axe_hero_7", "duration", true)
self.shield_health = self.parent:GetTalentValue("modifier_axe_hero_7", "health", true)

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end 


function modifier_axe_counter_helix_custom:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_axe_helix_2" or self.parent:HasTalent("modifier_axe_helix_2") then
	self.attack_range = self.parent:GetTalentValue("modifier_axe_helix_2", "attack_range")
end

if name == "modifier_axe_hero_7" or self.parent:HasTalent("modifier_axe_hero_7") then
	self.has_shield = true
	self.parent:AddDamageEvent_inc(self, true)
end

self:SendBuffRefreshToClients()
end

function modifier_axe_counter_helix_custom:AddCustomTransmitterData() 
return 
{
  attack_range = self.attack_range,
} 
end

function modifier_axe_counter_helix_custom:HandleCustomTransmitterData(data)
self.attack_range = data.attack_range
end

function modifier_axe_counter_helix_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
}
end

function modifier_axe_counter_helix_custom:GetModifierAttackRangeBonus()
return self.attack_range
end


function modifier_axe_counter_helix_custom:DamageEvent_inc(params)
if not IsServer() then return end
if not self.has_shield then return end
if self.parent ~= params.unit then return end
if self.parent:PassivesDisabled() then return end
if self.parent:GetHealthPercent() > self.shield_health then return end
if self.parent:HasModifier("modifier_death") then return end
if self.parent:HasModifier("modifier_axe_counter_helix_custom_shield_cd") then return end

self.parent:Purge(false, true, false, false, false)
self.parent:RemoveModifierByName("modifier_axe_counter_helix_custom_shield")
self.parent:AddNewModifier(self.parent, self.ability, "modifier_axe_counter_helix_custom_shield", {duration = self.shield_duration})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_axe_counter_helix_custom_shield_cd", {})
end

function modifier_axe_counter_helix_custom:AttackEvent_out(params)
if not IsServer() then return end
if not params.target:IsUnit() then return end 
if self.parent ~= params.attacker then return end

local mod = self.parent:FindModifierByName("modifier_axe_counter_helix_custom_legendary")
if mod then 
	mod:IncrementStackCount()
end

if not self.parent:HasScepter() then return end
self:CheckStack()
end

function modifier_axe_counter_helix_custom:AttackEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.target then return end
if params.attacker:GetTeamNumber()==params.target:GetTeamNumber() then return end
self:CheckStack()
end


function modifier_axe_counter_helix_custom:CheckStack()
if not IsServer() then return end
if self.parent:PassivesDisabled() then return end
if self.parent:HasModifier("modifier_axe_counter_helix_custom_legendary_active") then return end

if self.parent:HasTalent("modifier_axe_helix_legendary") then
	if self.parent:HasModifier("modifier_axe_counter_helix_custom_cd") then return end
else
	if not self.ability:IsFullyCastable() then return end
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_axe_counter_helix_custom_count", {})
end


function modifier_axe_counter_helix_custom:OnDestroy()
if not IsServer() then return end
self.parent:RemoveModifierByName("modifier_axe_counter_helix_custom_count")
end



modifier_axe_counter_helix_custom_count = class(mod_visible)
function modifier_axe_counter_helix_custom_count:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.ability:GetSpecialValueFor("trigger_attacks") + self.parent:GetTalentValue("modifier_axe_helix_4", "count")
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_count:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()

if self:GetStackCount() < self.max then return end
self.ability:Spin(1)
self:Destroy()
end






modifier_axe_counter_helix_custom_shard_debuff = class({})
function modifier_axe_counter_helix_custom_shard_debuff:IsPurgable() return true end

function modifier_axe_counter_helix_custom_shard_debuff:OnCreated()
self.damage_reduction = self:GetAbility():GetSpecialValueFor("scepter_damage")
self.max = self:GetAbility():GetSpecialValueFor("scepter_max")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_shard_debuff:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_axe_counter_helix_custom_shard_debuff:DeclareFunctions() 
return 
{
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




modifier_axe_counter_helix_custom_legendary = class(mod_hidden)
function modifier_axe_counter_helix_custom_legendary:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.max_time = self.parent:GetTalentValue("modifier_axe_helix_legendary", "duration")

self.speed = self.parent:GetTalentValue("modifier_axe_helix_legendary", "speed")
if not IsServer() then return end
self.parent:GenericParticle("particles/axe/helix_legendary_effect.vpcf", self, true)
self.parent:GenericParticle("particles/axe/calling_legendary_cast.vpcf")
self.parent:EmitSound("Axe.Helix_legendary1")
self.parent:EmitSound("Axe.Helix_legendary2")

self.RemoveForDuel = true
self:OnIntervalThink()
self:StartIntervalThink(0.1)
end

function modifier_axe_counter_helix_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIshort({max_time = self.max_time, time = self:GetElapsedTime(), stack = self:GetStackCount(), style = "AxeHelix"})
end

function modifier_axe_counter_helix_custom_legendary:GetStatusEffectName()
return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_axe_counter_helix_custom_legendary:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end

function modifier_axe_counter_helix_custom_legendary:OnDestroy()
if not IsServer() then return end

if not self.parent:IsAlive() or self:GetStackCount() <= 0 then
	self.parent:UpdateUIshort({hide = 1, style = "AxeHelix"})
	return 
end

self.parent:Purge(false, true, false, true, false)
self.parent:AddNewModifier(self.parent, self.ability, "modifier_axe_counter_helix_custom_legendary_active", {stack = self:GetStackCount()})
end

function modifier_axe_counter_helix_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_axe_counter_helix_custom_legendary:GetModifierModelScale()
return 20
end

function modifier_axe_counter_helix_custom_legendary:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

modifier_axe_counter_helix_custom_legendary_active = class(mod_hidden)
function modifier_axe_counter_helix_custom_legendary_active:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end
self:SetStackCount(table.stack)

self.interval = self.parent:GetTalentValue("modifier_axe_helix_legendary", "interval")
self.bkb = self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {})

self.max_stack = table.stack

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_axe_counter_helix_custom_legendary_active:OnIntervalThink()
if not IsServer() then return end
self.parent:GenericParticle("particles/econ/items/axe/axe_weapon_bloodchaser/axe_attack_blur_counterhelix_bloodchaser.vpcf")
self.ability:Spin(0, "modifier_axe_helix_legendary")

self:DecrementStackCount()
self.parent:UpdateUIshort({max_time = self.max_stack, time = self:GetStackCount(), stack = self:GetStackCount(), priority = 1, style = "AxeHelix"})

if self:GetStackCount() <= 0 then
	self:Destroy()
end

end

function modifier_axe_counter_helix_custom_legendary_active:OnDestroy()
if not IsServer() then return end
self.parent:UpdateUIshort({hide = 1, priority = 1, style = "AxeHelix"})

if not IsValid(self.bkb) then return end
self.bkb:Destroy()
end

function modifier_axe_counter_helix_custom_legendary_active:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true,
}
end

function modifier_axe_counter_helix_custom_legendary_active:GetStatusEffectName()
return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function modifier_axe_counter_helix_custom_legendary_active:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end

function modifier_axe_counter_helix_custom_legendary_active:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_axe_counter_helix_custom_legendary_active:GetModifierModelScale()
return 20
end




modifier_axe_counter_helix_custom_attack_speed = class(mod_visible)
function modifier_axe_counter_helix_custom_attack_speed:GetTexture() return "buffs/axe/helix_1" end
function modifier_axe_counter_helix_custom_attack_speed:OnCreated(table)
self.parent = self:GetParent()

self.max = self.parent:GetTalentValue("modifier_axe_helix_1", "max", true)
self.speed = self.parent:GetTalentValue("modifier_axe_helix_1", "speed")/self.max
self.armor = self.parent:GetTalentValue("modifier_axe_hero_3", "armor")/self.max
self.magic = self.parent:GetTalentValue("modifier_axe_hero_3", "magic")/self.max

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
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_axe_counter_helix_custom_attack_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self.speed
end

function modifier_axe_counter_helix_custom_attack_speed:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end

function modifier_axe_counter_helix_custom_attack_speed:GetModifierMagicalResistanceBonus()
return self:GetStackCount()*self.magic
end



modifier_axe_counter_helix_custom_damage = class(mod_visible)
function modifier_axe_counter_helix_custom_damage:GetTexture() return "buffs/axe/helix_3" end
function modifier_axe_counter_helix_custom_damage:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.parent:GetTalentValue("modifier_axe_helix_3", "max")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_axe_counter_helix_custom_damage:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end





modifier_axe_counter_helix_custom_shield = class(mod_hidden)
function modifier_axe_counter_helix_custom_shield:GetEffectName() return "particles/axe/helix_shield.vpcf" end
function modifier_axe_counter_helix_custom_shield:OnCreated(table)
self.RemoveForDuel = true
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max_shield = self.parent:GetTalentValue("modifier_axe_hero_7", "shield")*self.parent:GetMaxHealth()/100

if not IsServer() then return end
self.shield_talent = "modifier_axe_hero_7"
self:SetStackCount(self.max_shield )
self.parent:EmitSound("Axe.Helix_shield")
end

function modifier_axe_counter_helix_custom_shield:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_axe_counter_helix_custom_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
  if params.report_max then 
    return self.max_shield
  else 
      return self:GetStackCount()
    end 
end

if not IsServer() then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end


modifier_axe_counter_helix_custom_shield_cd = class(mod_cd)
function modifier_axe_counter_helix_custom_shield_cd:GetTexture() return "buffs/axe/hero_7" end
function modifier_axe_counter_helix_custom_shield_cd:OnCreated()
self.parent = self:GetParent()
self.RemoveForDuel = true

if not IsServer() then return end
self:SetStackCount(self.parent:GetTalentValue("modifier_axe_hero_7", "talent_cd"))
self:StartIntervalThink(1)
end

function modifier_axe_counter_helix_custom_shield_cd:OnIntervalThink()
if not IsServer() then return end
self:ReduceCd()
end

function modifier_axe_counter_helix_custom_shield_cd:ReduceCd() 
if not IsServer() then return end

self:DecrementStackCount()
if self:GetStackCount() <= 0 then
	self:Destroy()
end

end



modifier_axe_counter_helix_custom_stun_cd = class(mod_hidden)

modifier_axe_counter_helix_custom_cd = class(mod_hidden)
function modifier_axe_counter_helix_custom_cd:IsDebuff() return true end
