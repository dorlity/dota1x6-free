LinkLuaModifier( "modifier_axe_culling_blade_custom", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_tracker", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_attack_stack", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_aegis", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_slow_legendary", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_target_mod", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_status", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_legendary_attacks", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_slow", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_aura", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_root", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_root_cd", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )

axe_culling_blade_custom = class({})

function axe_culling_blade_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_culling_blade.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf", context )
PrecacheResource( "particle", "particles/wk_stack.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_charge_mark.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_start.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_end.vpcf", context )
PrecacheResource( "particle", "particles/axe_execute.vpcf", context )
PrecacheResource( "particle", "particles/axe_exe.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/ascetic_cap.vpcf", context )
end

function axe_culling_blade_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_axe_persona_custom") then
    return "axe_culling_blade_unleashed"
end
return "axe_culling_blade"
end

function axe_culling_blade_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_axe_culling_blade_custom_tracker"
end

axe_culling_blade_custom.mods = 
{
	"modifier_custom_juggernaut_healing_ward_reduction_aura",
	"modifier_tormentor_custom",
	"modifier_bane_nightmare_custom_legendary",
}

function axe_culling_blade_custom:InvalidMods(target)
for _,mod in pairs(self.mods) do
	if target:HasModifier(mod) then
		return true
	end
end
return false
end

--[[
function axe_culling_blade_custom:GetCastPoint()
local bonus = self:GetCaster():HasTalent("modifier_axe_hero_8") and self:GetCaster():GetTalentValue("modifier_axe_hero_8", "cast") or 0
return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end]]

function axe_culling_blade_custom:OnAbilityPhaseStart()
local k = 1
if false and self:GetCaster():HasTalent("modifier_axe_hero_8") then 
	k = 1.5
end 
self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, k)
return true
end 

function axe_culling_blade_custom:OnAbilityPhaseInterrupted()
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_4)
end


function axe_culling_blade_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

local damage_mod = target:FindModifierByName("modifier_axe_culling_blade_custom_attack_stack")
local damage = self:GetSpecialValueFor("damage")

if damage_mod then 
	damage = damage + damage_mod:GetStackCount()*caster:GetTalentValue("modifier_axe_culling_3", "damage_stack")*caster:GetAverageTrueAttackDamage(nil)/100
	damage_mod:Destroy()
end 

if not self:InvalidMods(target) then 
	kill_mod = target:AddNewModifier(target, nil, "modifier_death", {})
	kill_mod_2 = target:AddNewModifier(target, nil, "modifier_axe_culling_blade_custom_aegis", {})
end

if target:GetHealth() > damage or self:InvalidMods(target) then 
	DoDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self, custom_flag = CUSTOM_FLAG_AXE_CULLING_BLADE})	
else 
	self:CullingBladeKill(target, true, true)
	target:Kill(self, caster)
end

if not self:InvalidMods(target) then 
	kill_mod:Destroy()
	kill_mod_2:Destroy()
end

end



function axe_culling_blade_custom:CullingBladeKill(target, success, effect)
if not IsServer() then return end
local caster = self:GetCaster()
local direction = (target:GetOrigin()-caster:GetOrigin()):Normalized()

local particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade.vpcf"
local sound_cast = "Hero_Axe.Culling_Blade_Fail"

if success then
	particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
    if caster:HasModifier("modifier_axe_persona_custom") then
        particle_cast = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_kill.vpcf"
    end
	sound_cast = "Hero_Axe.Culling_Blade_Success"
end

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )
target:EmitSound(sound_cast)

local duration = self:GetSpecialValueFor("speed_duration")
if not success then return end

self:EndCooldown()

if caster:HasModifier("modifier_axe_persona_custom") then
	caster:EmitSound("Hero_Axe.JungleWeapon.Dunk")
end

if not target:IsValidKill(caster) then return end

if caster:GetQuest() == "Axe.Quest_8" then 
	caster:UpdateQuest(1)
end
local mod = caster:FindModifierByName("modifier_axe_coat_of_blood_custom")
if mod then 
	mod:AddStack()
end
caster:AddNewModifier( caster, self, "modifier_axe_culling_blade_custom", { duration = duration })
end




modifier_axe_culling_blade_custom = class(mod_visible)
function modifier_axe_culling_blade_custom:OnCreated( kv )
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.armor_bonus = self.ability:GetSpecialValueFor( "armor_buff" )
self.ms_bonus = self.ability:GetSpecialValueFor( "speed_bonus" )

if not IsServer() then return end
local particle_name = "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
if self.caster:HasModifier("modifier_axe_persona_custom") and self.parent == self.caster then
    particle_name = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_sprint.vpcf"
    local bonus_particle_buff = ParticleManager:CreateParticle("particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_cullingblade_sprint_axe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
    ParticleManager:SetParticleControlEnt(bonus_particle_buff, 2, self.caster, PATTACH_ABSORIGIN_FOLLOW, "attach_eye_l", self.caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(bonus_particle_buff, 3, self.caster, PATTACH_ABSORIGIN_FOLLOW, "attach_eye_r", self.caster:GetAbsOrigin(), true)
    self:AddParticle(bonus_particle_buff, false, false, -1, false, false)
end

self.parent:GenericParticle(particle_name, self)
end

function modifier_axe_culling_blade_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_axe_culling_blade_custom:GetModifierMoveSpeedBonus_Percentage()
return self.ms_bonus
end

function modifier_axe_culling_blade_custom:GetModifierPhysicalArmorBonus()
return self.armor_bonus
end


modifier_axe_culling_blade_custom_tracker = class(mod_hidden)
function modifier_axe_culling_blade_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.has_slow = self.parent:HasTalent("modifier_axe_culling_1")
self.slow_chance = self.parent:GetTalentValue("modifier_axe_culling_1", "chance", true)

self.has_stack = self.parent:HasTalent("modifier_axe_culling_3")
self.stack_duration = self.parent:GetTalentValue("modifier_axe_culling_3", "duration", true)
self.damage_bonus = self.parent:GetTalentValue("modifier_axe_culling_3", "damage")

self.has_heal = self.parent:HasTalent("modifier_axe_culling_2")
self.heal_target = self.parent:GetTalentValue("modifier_axe_culling_2", "heal")/100
self.heal_health = self.parent:GetTalentValue("modifier_axe_culling_2", "health", true)
self.heal_bonus = self.parent:GetTalentValue("modifier_axe_culling_2", "bonus", true)

self.has_aura = self.parent:HasTalent("modifier_axe_hero_4")
self.aura_radius = self.parent:GetTalentValue("modifier_axe_hero_4", "radius", true)
self.PercentStr = self.parent:GetTalentValue("modifier_axe_hero_4", "str")/100

self.has_root = self.parent:HasTalent("modifier_axe_culling_4")
self.root_duration = self.parent:GetTalentValue("modifier_axe_culling_4", "root", true)
self.root_health = self.parent:GetTalentValue("modifier_axe_culling_4", "health", true)
self.root_cd = self.parent:GetTalentValue("modifier_axe_culling_4", "talent_cd", true)

if not IsServer() then return end
self.parent:AddDamageEvent_out(self, true)

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_axe_culling_blade_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_axe_culling_1" or self.parent:HasTalent("modifier_axe_culling_1") then
	self.has_slow = true
	self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_axe_hero_4" or self.parent:HasTalent("modifier_axe_hero_4") then
	self.has_aura = true
	self.PercentStr = self.parent:GetTalentValue("modifier_axe_hero_4", "str")/100
end

if name == "modifier_axe_culling_2" or self.parent:HasTalent("modifier_axe_culling_2") then
	self.has_heal = true
	self.heal_target = self.parent:GetTalentValue("modifier_axe_culling_2", "heal")/100
	self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_axe_culling_3" or self.parent:HasTalent("modifier_axe_culling_3") then
	self.has_stack = true
	self.damage_bonus = self.parent:GetTalentValue("modifier_axe_culling_3", "damage")
	self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_axe_culling_4" or self.parent:HasTalent("modifier_axe_culling_4") then
	self.has_root = true
	self.parent:AddAttackEvent_out(self, true)
end

self:SendBuffRefreshToClients()
end

function modifier_axe_culling_blade_custom_tracker:AddCustomTransmitterData() 
return 
{
  damage_bonus = self.damage_bonus
} 
end

function modifier_axe_culling_blade_custom_tracker:HandleCustomTransmitterData(data)
self.damage_bonus = data.damage_bonus
end

function modifier_axe_culling_blade_custom_tracker:DeclareFunctions()
return
{
  	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
}
end

function modifier_axe_culling_blade_custom_tracker:GetModifierDamageOutgoing_Percentage()
return self.damage_bonus
end

function modifier_axe_culling_blade_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

local target = params.target
if not target:IsUnit() then return end

if self.has_slow then
	if RollPseudoRandomPercentage(self.slow_chance, 1971, self.parent) then
		target:AddNewModifier(self.parent, self.ability, "modifier_axe_culling_blade_custom_slow", {})
	end
end

if self.has_stack then
	target:AddNewModifier(self.parent, self.ability, "modifier_axe_culling_blade_custom_attack_stack", {duration = self.stack_duration})

	if not self.parent:HasTalent("modifier_axe_call_legendary") then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_axe_culling_blade_custom_target_mod", {target = target:entindex()})
	end
end

if self.has_heal then
	local heal = target:GetHealth()*self.heal_target
	heal = self.parent:GetHealthPercent() <= self.heal_health and heal*self.heal_bonus or heal
	self.parent:GenericHeal(heal, self.ability, true, nil, "modifier_axe_culling_2")
end

if self.has_root and target:GetHealthPercent() <= self.root_health and not target:HasModifier("modifier_axe_culling_blade_custom_root_cd") and not target:IsDebuffImmune() and target:IsHero() then
	target:AddNewModifier(self.parent, self.ability, "modifier_axe_culling_blade_custom_root_cd", {duration = self.root_cd})
	target:AddNewModifier(self.parent, self.ability, "modifier_axe_culling_blade_custom_root", {duration = self.root_duration*(1 - target:GetStatusResistance())})
end

end

function modifier_axe_culling_blade_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if params.custom_flag ~= CUSTOM_FLAG_AXE_CULLING_BLADE then return end

local target = params.unit
local success = false
if target:GetHealth()<=1 and not self.ability:InvalidMods(target) then 
	success = true
end
self.ability:CullingBladeKill(target, success, true)
end

function modifier_axe_culling_blade_custom_tracker:IsAura() return self.has_aura or self.has_root end
function modifier_axe_culling_blade_custom_tracker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_axe_culling_blade_custom_tracker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_axe_culling_blade_custom_tracker:GetModifierAura() return "modifier_axe_culling_blade_custom_aura" end
function modifier_axe_culling_blade_custom_tracker:GetAuraRadius() return self.aura_radius end
function modifier_axe_culling_blade_custom_tracker:GetAuraDuration() return 0.1 end

modifier_axe_culling_blade_custom_attack_stack = class(mod_hidden)
function modifier_axe_culling_blade_custom_attack_stack:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_axe_culling_3", "max")

if not IsServer() then return end
self.RemoveForDuel = true
self.effect_cast = self.parent:GenericParticle("particles/wk_stack.vpcf", self, true)

self:SetStackCount(1)
end

function modifier_axe_culling_blade_custom_attack_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max  then return end
self:IncrementStackCount()
end

function modifier_axe_culling_blade_custom_attack_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if self:GetStackCount() < self.max then 
	if self.effect_cast then
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
	end
else 
	if self.effect_cast then 
		ParticleManager:DestroyParticle(self.effect_cast, true)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		self.effect_cast = nil
	end 
	self.effect_mark = self.parent:GenericParticle("particles/lc_odd_charge_mark.vpcf", self, true)
end 

end


modifier_axe_culling_blade_custom_target_mod = class(mod_hidden)
function modifier_axe_culling_blade_custom_target_mod:OnCreated(params)
if not IsServer() then return end 
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage = self.ability:GetSpecialValueFor("damage")
self.target = EntIndexToHScript(params.target)
self.damage_bonus = self.parent:GetTalentValue("modifier_axe_culling_3", "damage_stack")/100

self:OnIntervalThink()
self:StartIntervalThink(0.5)
end 

function modifier_axe_culling_blade_custom_target_mod:OnRefresh(params)
if not IsServer() then return end 
self.target = EntIndexToHScript(params.target)
self:OnIntervalThink()
end 

function modifier_axe_culling_blade_custom_target_mod:OnIntervalThink()
if not IsServer() then return end
if not IsValid(self.target) or not self.target:HasModifier("modifier_axe_culling_blade_custom_attack_stack") or self.parent:HasTalent("modifier_axe_call_legendary") then
	self:Destroy()
	return
end
local mod = self.target:FindModifierByName("modifier_axe_culling_blade_custom_attack_stack")

local damage = self.damage + mod:GetStackCount()*self.damage_bonus*self.parent:GetAverageTrueAttackDamage(nil)
self.parent:UpdateUIlong({override_stack = math.floor(damage*(1 + self.parent:GetSpellAmplification(false))), no_min = 1, style = "AxeCulling"})
end

function modifier_axe_culling_blade_custom_target_mod:OnDestroy()
if not IsServer() then return end
self.parent:UpdateUIlong({override_stack = 0, no_min = 1, style = "AxeCulling"})
end







axe_culling_blade_custom_legendary = class({})

function axe_culling_blade_custom_legendary:CreateTalent()
self:SetHidden(false)
self:SetLevel(1)
end

function axe_culling_blade_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_axe_culling_legendary", "talent_cd")
end

function axe_culling_blade_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local target =  self:GetCursorTarget()
if target:TriggerSpellAbsorb(self) then return end

if target:GetHealthPercent() > caster:GetTalentValue("modifier_axe_culling_legendary", "health") then 
	self:EndCooldown()
	self:StartCooldown(caster:GetTalentValue("modifier_axe_culling_legendary", "cd_low"))
end

local direction = (target:GetOrigin()-caster:GetOrigin()):Normalized()

local old_pos = caster:GetAbsOrigin()
    
local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, old_pos)
ParticleManager:ReleaseParticleIndex( effect )

FindClearSpaceForUnit(caster, self:GetCursorTarget():GetAbsOrigin(), true)
ProjectileManager:ProjectileDodge(caster)

effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, caster:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( effect )

target:AddNewModifier(caster, self, "modifier_axe_culling_blade_custom_slow_legendary", {})

local particle_name = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
if caster:HasModifier("modifier_axe_persona_custom") then
    particle_name = "particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_kill.vpcf"
end
local effect_cast = ParticleManager:CreateParticle( particle_name, PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )
target:EmitSound("Axe.Culling_legendary")
target:EmitSound("Axe.Culling_legendary2")
end



modifier_axe_culling_blade_custom_aegis = class({})
function modifier_axe_culling_blade_custom_aegis:IsHidden() return true end
function modifier_axe_culling_blade_custom_aegis:IsPurgable() return false end



modifier_axe_culling_blade_custom_slow_legendary = class(mod_hidden)
function modifier_axe_culling_blade_custom_slow_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_axe_culling_blade_custom_slow_legendary:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_axe_culling_blade_custom_slow_legendary:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.slow = -100

if not IsServer() then return end
self:SetStackCount(self.caster:GetTalentValue("modifier_axe_culling_legendary", "attacks"))
self.interval = 0.25
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_axe_culling_blade_custom_slow_legendary:OnIntervalThink()
if not IsServer() then return end

self.caster:AddNewModifier(self.caster, self.ability, "modifier_axe_culling_blade_custom_legendary_attacks", {})
self.caster:PerformAttack(self.parent, true, true, true, true, false, false, true)
self.caster:RemoveModifierByName("modifier_axe_culling_blade_custom_legendary_attacks")
self:DecrementStackCount()
if self:GetStackCount() <= 0 then
	self:Destroy()
end

end



modifier_axe_culling_blade_custom_slow = class(mod_hidden)
function modifier_axe_culling_blade_custom_slow:IsPurgable() return true end
function modifier_axe_culling_blade_custom_slow:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.max = self.caster:GetTalentValue("modifier_axe_culling_1", "duration")
self.slow = self.caster:GetTalentValue("modifier_axe_culling_1", "slow")
self.interval = self.caster:GetTalentValue("modifier_axe_culling_1", "interval")
self.damage = self.caster:GetTalentValue("modifier_axe_culling_1", "damage")*self.interval

if not IsServer() then return end
self.parent:EmitSound("DOTA_Item.Maim")
self.parent:GenericParticle("particles/items2_fx/sange_maim.vpcf", self)

self.damageTable = {victim = self.parent, attacker = self.caster, damage_type = self.caster:GetTalentValue("modifier_axe_culling_1", "damage_type"), ability = self.ability}
self:SetStackCount(self.max)
self:StartIntervalThink(self.interval)
end

function modifier_axe_culling_blade_custom_slow:OnRefresh()
if not IsServer() then return end
self.parent:EmitSound("DOTA_Item.Maim")
self:SetStackCount(self.max)
end

function modifier_axe_culling_blade_custom_slow:OnIntervalThink()
if not IsServer() then return end
self.damageTable.damage = self.damage*self.caster:GetAverageTrueAttackDamage(nil)/100
DoDamage(self.damageTable, "modifier_axe_culling_1")

self:DecrementStackCount()
if self:GetStackCount() <= 0 then 
	self:Destroy()
end

end

function modifier_axe_culling_blade_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_axe_culling_blade_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


modifier_axe_culling_blade_custom_aura = class(mod_hidden)
function modifier_axe_culling_blade_custom_aura:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

if not IsServer() then return end

if self.caster:HasTalent("modifier_axe_hero_4") then
	self.PercentStr = self.caster:GetTalentValue("modifier_axe_hero_4", "str_reduce")/100
end

if self.caster:HasTalent("modifier_axe_culling_4") then
	self.interval = 0.3
	self.root_health = self.caster:GetTalentValue("modifier_axe_culling_4", "health")
	self:StartIntervalThink(self.interval)
end

end

function modifier_axe_culling_blade_custom_aura:OnIntervalThink()
if not IsServer() then return end
if not self.caster:IsAlive() then return end
if self.parent:GetHealthPercent() > self.root_health then return end

self.caster:AddNewModifier(self.caster, self.ability, "modifier_axe_culling_blade_custom_status", {duration = self.interval*2})
end

function modifier_axe_culling_blade_custom_aura:OnDestroy()
if not IsServer() then return end
if not self.caster:HasTalent("modifier_axe_hero_4") then return end
self.parent:PercentRefresh()
end



modifier_axe_culling_blade_custom_status = class(mod_hidden)
function modifier_axe_culling_blade_custom_status:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_axe_culling_blade_custom_status:GetModifierStatusResistanceStacking()
return self.status
end

function modifier_axe_culling_blade_custom_status:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_axe_culling_blade_custom_status:GetActivityTranslationModifiers()
return "chase"
end

function modifier_axe_culling_blade_custom_status:OnCreated()
self.parent = self:GetParent()

self.status = self.parent:GetTalentValue("modifier_axe_culling_4", "status")
self.move = self.parent:GetTalentValue("modifier_axe_culling_4", "move")

if not IsServer() then return end
self.parent:GenericParticle("particles/items4_fx/ascetic_cap.vpcf", self)
end



modifier_axe_culling_blade_custom_root = class({})
function modifier_axe_culling_blade_custom_root:IsHidden() return true end
function modifier_axe_culling_blade_custom_root:IsPurgable() return true end
function modifier_axe_culling_blade_custom_root:CheckState()
return
{
    [MODIFIER_STATE_ROOTED] = true
}
end

function modifier_axe_culling_blade_custom_root:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:EmitSound("Pudge.Hook_Root")
self.parent:GenericParticle("particles/items3_fx/hook_root.vpcf", self)
end

modifier_axe_culling_blade_custom_root_cd = class(mod_hidden)
function modifier_axe_culling_blade_custom_root_cd:OnCreated()
self.RemoveForDuel = true
end


modifier_axe_culling_blade_custom_legendary_attacks = class(mod_hidden)
function modifier_axe_culling_blade_custom_legendary_attacks:OnCreated()
self.damage = self:GetParent():GetTalentValue("modifier_axe_culling_legendary", "damage") - 100
end

function modifier_axe_culling_blade_custom_legendary_attacks:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_axe_culling_blade_custom_legendary_attacks:GetModifierDamageOutgoing_Percentage()
return self.damage
end