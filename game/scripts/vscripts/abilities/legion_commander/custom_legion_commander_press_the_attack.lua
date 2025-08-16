LinkLuaModifier("modifier_press_the_attack_custom_buff", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_root", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_legendary_damage", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_legendary", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_unslow", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_burn_effect", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_burn_aura", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_press_the_attack_custom_tracker", "abilities/legion_commander/custom_legion_commander_press_the_attack", LUA_MODIFIER_MOTION_NONE)



custom_legion_commander_press_the_attack = class({})



function custom_legion_commander_press_the_attack:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_legion_commander_wings_fallen_custom") then
    return "legion_commander/legacy_of_the_fallen_legion/legion_commander_press_the_attack"
end
if self:GetCaster():HasModifier("modifier_legion_commander_wings_fallen_custom_2") then
    return "legion_commander/legacy_of_the_fallen_legion/legion_commander_press_the_attack"
end
return "legion_commander_press_the_attack"
end

function custom_legion_commander_press_the_attack:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_press_the_attack_custom_tracker"
end

function custom_legion_commander_press_the_attack:CreateTalent()
local caster = self:GetCaster()
local mod = caster:FindModifierByName("modifier_press_the_attack_custom_tracker")

if mod then
	mod.PercentStr = caster:GetTalentValue("modifier_legion_press_1", "str")/100
end

end



function custom_legion_commander_press_the_attack:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_press_halo.vpcf", context )
PrecacheResource( "particle", "particles/lc_wave.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf", context )
PrecacheResource( "particle", "particles/lc_root.vpcf", context )
PrecacheResource( "particle", "particles/legion_commander/press_legendary_buff.vpcf", context )
PrecacheResource( "particle", "particles/lc_press_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/fall_2022/radiance_target_fall2022.vpcf", context )
end



function custom_legion_commander_press_the_attack:GetBehavior()
local bonus = 0
local base = DOTA_ABILITY_BEHAVIOR_NO_TARGET
if not IsSoloMode() then 
  base = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end 
if self:GetCaster():HasTalent("modifier_legion_press_6") then 
	bonus = DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end
return base + bonus
end

function custom_legion_commander_press_the_attack:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasTalent("modifier_legion_press_5") then 
	return self:GetCaster():GetTalentValue("modifier_legion_press_5", "radius")
end 

end 


function custom_legion_commander_press_the_attack:GetCooldown(iLevel)
local upgrade_cooldown = 0
if self:GetCaster():HasTalent("modifier_legion_press_3") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_legion_press_3", "cd")
end 
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown
end



function custom_legion_commander_press_the_attack:OnSpellStart()
local caster = self:GetCaster()
local target = caster
if self:GetCursorTarget() then
	target = self:GetCursorTarget()
end

if caster == target then
	caster:SetPoseParameter( "capture_progress_0_to_1", 1 )
	caster:SetPoseParameter( "run_haste_turns", 1 )
end

caster:GenericParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_halo.vpcf")

local before = #target:FindAllModifiers()
target:Purge(false , true, false , true, false)
local after = #target:FindAllModifiers()

if caster:GetQuest() == "Legion.Quest_6" and after < before then 
	caster:UpdateQuest(1)
end

if caster:HasTalent("modifier_legion_press_1") then 
	target:GenericHeal(target:GetMaxHealth()*caster:GetTalentValue("modifier_legion_press_1", "heal")/100, self, nil, nil, "modifier_legion_press_1")
end 


self.duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_legion_press_3", "duration")

target:EmitSound("Hero_LegionCommander.PressTheAttack")

if caster:HasTalent("modifier_legion_press_7") then 
	caster:AddNewModifier(caster, self, "modifier_press_the_attack_custom_legendary", {duration = caster:GetTalentValue("modifier_legion_press_7", "duration")})
end 

target:AddNewModifier(caster, self, "modifier_press_the_attack_custom_buff", {duration = self.duration})

if caster:HasTalent("modifier_legion_press_6") then 
	target:AddNewModifier(caster, self, "modifier_press_the_attack_custom_unslow", {duration = caster:GetTalentValue("modifier_legion_press_6", "duration")})
end 


if not caster:HasTalent("modifier_legion_press_5") then return end

local duration = caster:GetTalentValue("modifier_legion_press_5", "root")
local pull_duration =caster:GetTalentValue("modifier_legion_press_5", "pull_duration")
local pull_distance =caster:GetTalentValue("modifier_legion_press_5", "pull_distance")

local wave_particle = ParticleManager:CreateParticle( "particles/lc_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( wave_particle, 1, target:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(wave_particle)

local enemies = caster:FindTargets(caster:GetTalentValue("modifier_legion_press_5", "radius"), target:GetAbsOrigin())

for _,enemy in pairs(enemies) do 

	local dir = enemy:GetAbsOrigin() - target:GetAbsOrigin()

	local point = target:GetAbsOrigin() + dir:Normalized()*pull_distance
	local distance = (point - enemy:GetAbsOrigin()):Length2D()


	local arc = enemy:AddNewModifier( caster,  self,  "modifier_generic_arc",  
	{
	  target_x = point.x,
	  target_y = point.y,
	  distance = distance,
	  duration = pull_duration,
	  height = 0,
	  fix_end = false,
	  isStun = false,
	  activity = ACT_DOTA_FLAIL,
	})

	if arc then 
  	arc:SetEndCallback(function()
  		if enemy and not enemy:IsNull() then
				enemy:AddNewModifier(caster, self, "modifier_press_the_attack_custom_root", {duration = (1 - enemy:GetStatusResistance())*duration})
				enemy:EmitSound("Lc.Press_Root")
			end
		end)
	end  
end


end




modifier_press_the_attack_custom_buff = class({})

function modifier_press_the_attack_custom_buff:IsHidden() return false end
function modifier_press_the_attack_custom_buff:IsPurgable() return true end
function modifier_press_the_attack_custom_buff:RemoveOnDeath() return true end

function modifier_press_the_attack_custom_buff:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.speed = self.ability:GetSpecialValueFor("movespeed") + self.caster:GetTalentValue("modifier_legion_press_2", "move")
self.regen = self.ability:GetSpecialValueFor("hp_regen")

self.lifesteal = self.caster:GetTalentValue("modifier_legion_press_2", "heal")/100
self.lifesteal_creeps = self.caster:GetTalentValue("modifier_legion_press_2", "heal_creeps", true)

self.damage_burn = self.caster:GetTalentValue("modifier_legion_press_4", "damage")/100
self.damage_heal = self.caster:GetTalentValue("modifier_legion_press_4", "heal")/100
self.bonus = self.caster:GetTalentValue("modifier_legion_press_4", "bonus", true)
self.burn_health = self.caster:GetTalentValue("modifier_legion_press_4", "health", true)
self.burn_interval = self.caster:GetTalentValue("modifier_legion_press_4", "interval", true)
self.aura_radius = self.caster:GetTalentValue("modifier_legion_press_4", "radius", true)

if not IsServer() then return end

self.RemoveForDuel = true
self.ability:EndCd()

self:PlayEffect()
self.parent:AddDamageEvent_out(self)

if not self.parent:HasTalent("modifier_legion_press_4") then return end

self.aura_mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_press_the_attack_custom_burn_aura", {duration = self:GetRemainingTime()})

self.parent:EmitSound("Lc.Press_burn")
self.parent:GenericParticle("particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf", self)

self:OnIntervalThink()
self:StartIntervalThink(self.burn_interval - FrameTime())
end



function modifier_press_the_attack_custom_buff:OnDestroy()
if not IsServer() then return end 

self.ability:StartCd()

if self.parent:HasModifier("modifier_legion_commander_wings_fallen_custom") then
	self.parent:RemoveGesture(ACT_SCRIPT_CUSTOM_0)
end
if self.parent:HasModifier("modifier_legion_commander_wings_fallen_custom_2") then
	self.parent:RemoveGesture(ACT_SCRIPT_CUSTOM_0)
end

self.parent:StopSound("Lc.Press_burn")

if self.aura_mod and not self.aura_mod:IsNull() then 
	self.aura_mod:Destroy()
end 

end



function modifier_press_the_attack_custom_buff:OnRefresh(table)
if not IsServer() then return end 
self:PlayEffect()
end 

function modifier_press_the_attack_custom_buff:PlayEffect()
if not IsServer() then return end
if self.cast then 
    ParticleManager:DestroyParticle(self.cast, true)
    ParticleManager:ReleaseParticleIndex(self.cast)
end 

local particle_name = "particles/units/heroes/hero_legion_commander/legion_commander_press.vpcf"
if self.caster:HasModifier("modifier_legion_commander_wings_fallen_custom") then
    particle_name = "particles/econ/items/legion/legion_fallen/legion_fallen_press_owner.vpcf"
    self.caster:AddActivityModifier("self")
    self.caster:StartGesture(ACT_SCRIPT_CUSTOM_0)
end
if self.caster:HasModifier("modifier_legion_commander_wings_fallen_custom_2") then
    particle_name = "particles/econ/items/legion/legion_fallen/legion_fallen_press_owner_alt.vpcf"
    self.caster:AddActivityModifier("self")
    self.caster:StartGesture(ACT_SCRIPT_CUSTOM_0)
end

self.cast = ParticleManager:CreateParticle( particle_name, PATTACH_CUSTOMORIGIN, self.parent )
ParticleManager:SetParticleControlEnt( self.cast, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.cast, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( self.cast, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true )
self:AddParticle(self.cast,false, false, -1, false, false)
end 




function modifier_press_the_attack_custom_buff:OnIntervalThink()
if not IsServer() then return end
if not self.caster:IsAlive() then return end

local enemies = self.parent:FindTargets(self.aura_radius)

local damage = self.damage_burn*self.parent:GetAverageTrueAttackDamage(nil)
if self.parent:GetHealthPercent() <= self.burn_health then
	damage = damage*self.bonus
end

self:SetStackCount(damage)

for _,enemy in pairs(enemies) do 
	local real_damage = DoDamage({victim = enemy,  damage = damage*self.burn_interval, damage_type = DAMAGE_TYPE_MAGICAL, attacker = self.caster, ability = self.ability}, "modifier_legion_press_4")
end

end



function modifier_press_the_attack_custom_buff:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end


function modifier_press_the_attack_custom_buff:DamageEvent_out(params)
if not IsServer() then return end
if not self.caster:HasTalent("modifier_legion_press_2") then return end
if not self.parent:CheckLifesteal(params) then return end

local heal = self.lifesteal*params.damage

if params.unit:IsCreep() then 
	heal = heal/self.lifesteal_creeps
end

self.parent:GenericHeal(heal, self.ability, true, "", "modifier_legion_press_2")
end


function modifier_press_the_attack_custom_buff:GetActivityTranslationModifiers() 
if self.caster == self.parent then 
	return "press_the_attack" 
end

end

function modifier_press_the_attack_custom_buff:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_press_the_attack_custom_buff:GetModifierConstantHealthRegen()
return self.regen + self:GetStackCount()*self.damage_heal
end






modifier_press_the_attack_custom_root = class({})
function modifier_press_the_attack_custom_root:IsHidden() return true end
function modifier_press_the_attack_custom_root:IsPurgable() return true end
function modifier_press_the_attack_custom_root:GetTexture() return "buffs/press_root" end
function modifier_press_the_attack_custom_root:CheckState() return {[MODIFIER_STATE_ROOTED] = true} end
function modifier_press_the_attack_custom_root:GetEffectName() return "particles/lc_root.vpcf" end







modifier_press_the_attack_custom_legendary = class({})
function modifier_press_the_attack_custom_legendary:IsHidden() return true end
function modifier_press_the_attack_custom_legendary:IsPurgable() return false end
function modifier_press_the_attack_custom_legendary:GetEffectName() return "particles/legion_commander/press_legendary_buff.vpcf" end
function modifier_press_the_attack_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.damage_duration = self.parent:GetTalentValue("modifier_legion_press_7", "damage_duration")
self.damage_reduce = self.parent:GetTalentValue("modifier_legion_press_7", "damage_reduce")/100

self.time = self:GetRemainingTime()

if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(0.03)
end 


function modifier_press_the_attack_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self.parent:UpdateUIshort({time = self:GetRemainingTime(), max_time = self.time, stack = self:GetStackCount(), style = "LegionPress", priority = 1})
end 



function modifier_press_the_attack_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
}
end



function modifier_press_the_attack_custom_legendary:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if self:GetParent() == params.attacker then return end

self:SetStackCount(self:GetStackCount() + params.damage * self.damage_reduce )

return params.damage * self.damage_reduce
end




function modifier_press_the_attack_custom_legendary:OnDestroy()
if not IsServer() then return end

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "LegionPress", priority = 1})

if self:GetStackCount() <= 0 then return end

local damage = self:GetStackCount()
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_press_the_attack_custom_legendary_damage", {damage = damage, duration = self.damage_duration + 2*FrameTime()})

end 




modifier_press_the_attack_custom_legendary_damage = class({})
function modifier_press_the_attack_custom_legendary_damage:IsHidden() return false end
function modifier_press_the_attack_custom_legendary_damage:IsPurgable() return false end
function modifier_press_the_attack_custom_legendary_damage:IsDebuff() return true end
function modifier_press_the_attack_custom_legendary_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_press_the_attack_custom_legendary_damage:OnCreated(table)
if not IsServer() then return end

self.caster = self:GetCaster()
self.damage_duration = self:GetCaster():GetTalentValue("modifier_legion_press_7", "damage_duration")
self.damage_interval = self:GetCaster():GetTalentValue("modifier_legion_press_7", "damage_interval")
self.damage_radius = self:GetCaster():GetTalentValue("modifier_legion_press_7", "damage_radius")
self.damage_creeps = 1 - self:GetCaster():GetTalentValue("modifier_legion_press_7", "damage_creeps")/100


self.RemoveForDuel = true
self.damage = table.damage
self.tick = self.damage/(self.damage_duration + self.damage_interval)

self:OnIntervalThink()
self:StartIntervalThink(self.damage_interval)
end

function modifier_press_the_attack_custom_legendary_damage:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():IsInvulnerable() then 
	self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - self.tick))
end 
--self:GetParent():EmitSound("Lc.Press_legendary") 

self:GetParent():EmitSound("Lc.Press_Heal")
local effect_target = ParticleManager:CreateParticle( "particles/lc_press_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
ParticleManager:ReleaseParticleIndex( effect_target )


local enemies = self.caster:FindTargets(self.damage_radius)

for _,target in pairs(enemies) do 

	local damage = self.tick 
	if target:IsCreep() then 
		damage = damage*self.damage_creeps
	end

	local damageTable = {victim = target,  damage = damage, damage_type = DAMAGE_TYPE_PURE, attacker = self.caster, ability = self:GetAbility()}
	 DoDamage(damageTable, "modifier_legion_press_7")
end

end



modifier_press_the_attack_custom_unslow = class({})
function modifier_press_the_attack_custom_unslow:IsHidden() return true end
function modifier_press_the_attack_custom_unslow:IsPurgable() return false end
function modifier_press_the_attack_custom_unslow:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end
function modifier_press_the_attack_custom_unslow:OnDestroy()
if not IsServer() then return end 
self.parent = self:GetParent()

self.parent:GenericParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf")
self.parent:EmitSound("Lc.Press_Purge")
self.parent:Purge(false, true, false, true, false)
end 



modifier_press_the_attack_custom_burn_effect = class({})

function modifier_press_the_attack_custom_burn_effect:IsHidden() return true end
function modifier_press_the_attack_custom_burn_effect:IsPurgable() return false end



function modifier_press_the_attack_custom_burn_effect:OnCreated()
if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/econ/events/fall_2022/radiance_target_fall2022.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())
self:AddParticle(self.particle,false, false, -1, false, false)

self:StartIntervalThink(0.5)
end

function modifier_press_the_attack_custom_burn_effect:OnIntervalThink()
if not IsServer() then return end 
if not self.particle then return end


ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())
end 





modifier_press_the_attack_custom_burn_aura = class({})
function modifier_press_the_attack_custom_burn_aura:IsPurgable() return true end
function modifier_press_the_attack_custom_burn_aura:IsHidden() return true end
function modifier_press_the_attack_custom_burn_aura:OnCreated()

self.aura_radius = self:GetCaster():GetTalentValue("modifier_legion_press_4", "radius")
end


function modifier_press_the_attack_custom_burn_aura:IsAura() return true end

function modifier_press_the_attack_custom_burn_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_press_the_attack_custom_burn_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_press_the_attack_custom_burn_aura:GetModifierAura()
	return "modifier_press_the_attack_custom_burn_effect"
end

function modifier_press_the_attack_custom_burn_aura:GetAuraRadius()
	return self.aura_radius
end


function modifier_press_the_attack_custom_burn_aura:GetAuraDuration()
return 0
end


modifier_press_the_attack_custom_tracker = class({})
function modifier_press_the_attack_custom_tracker:IsHidden() return true end
function modifier_press_the_attack_custom_tracker:IsPurgable() return false end