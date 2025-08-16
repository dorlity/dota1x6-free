LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_thinker", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_legendary_thinker", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_legendary_stack", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_slow", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_legendary", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_fear_count", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_fear_cd", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_tracker", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_str", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_move", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_warden_spark_wraith_custom_root", "abilities/arc_warden/arc_warden_spark_wraith_custom", LUA_MODIFIER_MOTION_NONE )


arc_warden_spark_wraith_custom = class({})


function arc_warden_spark_wraith_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_wraith_cast.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_heall.vpcf", context )
PrecacheResource( "particle", "particles/puck_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_hero.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_tempest.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/fall_2021/phase_boots_fall_2021_lvl2.vpcf", context )
PrecacheResource( "particle", "particles/zuus_speed.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", context )
PrecacheResource( "particle", "particles/blue_zone.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_fear_stack.vpcf", context )
PrecacheResource( "particle", "particles/arc_warden/spark_stacks.vpcf", context )
end

function arc_warden_spark_wraith_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_arc_warden_spark_wraith_custom_tracker"
end

function arc_warden_spark_wraith_custom:GetAOERadius()
return self:GetSpecialValueFor("radius")
end

function arc_warden_spark_wraith_custom:GetCastPoint(iLevel)
local bonus = self:GetCaster():HasTalent("modifier_arc_warden_spark_4") and self:GetCaster():GetTalentValue("modifier_arc_warden_spark_4", "cast") or 0
return self.BaseClass.GetCastPoint(self) + bonus
end

function arc_warden_spark_wraith_custom:GetCooldown(level)
local bonus = self:GetCaster():HasTalent("modifier_arc_warden_spark_2") and self:GetCaster():GetTalentValue("modifier_arc_warden_spark_2", "cd") or 0
return self.BaseClass.GetCooldown(self, level)  + bonus
end

function arc_warden_spark_wraith_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_arc_warden_ti9_immortal_shoulders") then
    return "arc_warden/ti9_immortal_shoulders/arc_warden_spark_wraith_immortal"
end
if self:GetCaster():HasModifier("modifier_arc_warden_tempest_double") then
	return "arc_warden_spark_wraith_tempest"
end
return "arc_warden_spark_wraith"
end

function arc_warden_spark_wraith_custom:GetDamage()
local caster = self:GetCaster()
return self:GetSpecialValueFor("spark_damage_base") + caster:GetTalentValue("modifier_arc_warden_spark_1", "damage")*caster:GetIntellect(false)/100
end

function arc_warden_spark_wraith_custom:OnAbilityPhaseStart()
self:GetCaster():EmitSound("Hero_ArcWarden.SparkWraith.Cast")
return true
end



function arc_warden_spark_wraith_custom:OnSpellStart()
local caster = self:GetCaster()
local cast_point = self:GetCursorPosition()

local particle = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_cast.vpcf"
if caster:HasModifier("modifier_arc_warden_ti9_immortal_shoulders") then
	particle = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_cast.vpcf"
end

local cast_particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControl(cast_particle, 1, caster:GetAbsOrigin() + caster:GetForwardVector()*110)
ParticleManager:ReleaseParticleIndex(cast_particle)

if caster:IsTempestDouble() then
	caster:MoveToPositionAggressive(caster:GetAbsOrigin())
end 

EmitSoundOnLocationWithCaster(cast_point, "Hero_ArcWarden.SparkWraith.Appear", caster)

local duration = self:GetSpecialValueFor("duration")
local tower_radius =  self:GetSpecialValueFor("tower_radius")

for _,tower in pairs(towers) do 
	if (tower:GetAbsOrigin() - cast_point):Length2D() <= tower_radius then 
		duration = self:GetSpecialValueFor("tower_duration")
	end 	
end 

CreateModifierThinker(caster, self, "modifier_arc_warden_spark_wraith_custom_thinker", {duration = duration}, cast_point + Vector(0, 0, 10), caster:GetTeamNumber(), false)
end 


function arc_warden_spark_wraith_custom:ProcHeal(damage, target, not_main)
if not IsServer() then return end
local caster = self:GetCaster()

local heal = damage*caster:GetTalentValue("modifier_arc_warden_spark_3", "heal")/100
heal = target:IsCreep() and heal/caster:GetTalentValue("modifier_arc_warden_spark_3", "heal_creeps", true) or heal

caster:GenericHeal(heal, self, false, not_main and "" or "particles/arc_warden/spark_heall.vpcf", "modifier_arc_warden_spark_3")
local heal_target = caster:GetTempest()
if heal_target then
	heal_target:GenericHeal(heal, self, false, not_main and "" or "particles/arc_warden/spark_heall.vpcf", "modifier_arc_warden_spark_3")
end

end


function arc_warden_spark_wraith_custom:DealDamage(target, not_main, damage_ability)
if not IsServer() then return end 
local caster = self:GetCaster() 
local damage = self:GetDamage()
local slow_duration =  self:GetSpecialValueFor("ministun_duration") + caster:GetTalentValue("modifier_arc_warden_hero_7", "slow")

local k = 1
if not_main then 
	k = self:GetSpecialValueFor("damage_near")/100
else 
	if caster:HasTalent("modifier_arc_warden_hero_7") and not target:HasModifier("modifier_arc_warden_spark_wraith_custom_fear_cd") and not target:IsDebuffImmune() then 
		target:AddNewModifier(caster, self, "modifier_arc_warden_spark_wraith_custom_fear_count", {duration = caster:GetTalentValue("modifier_arc_warden_hero_7", "duration")})
	end 
end  

local hero = caster
if hero:IsTempestDouble() and hero.owner then 
	hero = hero.owner
end
if hero:GetQuest() == "Arc.Quest_7" and target:IsRealHero() and not hero:QuestCompleted() then 
	hero:UpdateQuest(1)
end

target:EmitSound("Hero_ArcWarden.SparkWraith.Damage")

local real_damage = DoDamage({victim = target, damage = damage*k, damage_type = DAMAGE_TYPE_MAGICAL, attacker = caster, ability = self}, damage_ability)
if caster:HasTalent("modifier_arc_warden_spark_3") then
	self:ProcHeal(real_damage, target, not_main)
end

target:AddNewModifier(caster, self, "modifier_arc_warden_spark_wraith_custom_slow", {duration = slow_duration * (1 - target:GetStatusResistance())})
end 



function arc_warden_spark_wraith_custom:LaunchSpark(target, source, damage_ability)
if not IsServer() then return end 

local caster = self:GetCaster()
local speed = self:GetSpecialValueFor("wraith_speed_base")
local wraith_vision_radius = self:GetSpecialValueFor("wraith_vision_radius")
local origin = source:GetAbsOrigin()

if caster:HasTalent("modifier_arc_warden_spark_4") and damage_ability ~= "Scepter" then 
	local cd_items = caster:GetTalentValue("modifier_arc_warden_spark_4", "cd_items")
	local speed_duration = caster:GetTalentValue("modifier_arc_warden_spark_4", "duration")

	caster:CdItems(cd_items)
	caster:RemoveModifierByName("modifier_arc_warden_spark_wraith_custom_move")
	caster:AddNewModifier(caster, self, "modifier_arc_warden_spark_wraith_custom_move", {duration = speed_duration})

	local cd_target = caster:GetTempest()
	if cd_target then
		cd_target:CdItems(cd_items)
		cd_target:RemoveModifierByName("modifier_arc_warden_spark_wraith_custom_move")
		cd_target:AddNewModifier(caster, self, "modifier_arc_warden_spark_wraith_custom_move", {duration = speed_duration})
	end
end 

if damage_ability == "modifier_arc_warden_spark_3" then
	speed = speed*1.5
end

local root = 0
if damage_ability == "Scepter" then
	local tempest = caster:FindAbilityByName("arc_warden_tempest_double_custom")
	if tempest and tempest:IsTrained() then
		root = tempest:GetSpecialValueFor("scepter_root")
		speed = speed*(1 + tempest:GetSpecialValueFor("scepter_speed_bonus")/100)
	end
end


source:EmitSound("Hero_ArcWarden.SparkWraith.Activate")

local proj_pfx = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf"
if caster:HasModifier("modifier_arc_warden_ti9_immortal_shoulders") then
    proj_pfx = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_prj.vpcf"
end

ProjectileManager:CreateTrackingProjectile(
{
	EffectName			= proj_pfx,
	Ability				= self,
	Source				= source,
	vSourceLoc			= origin,
	Target				= target,
	iMoveSpeed			= speed,
	bDodgeable			= false,
	bVisibleToEnemies	= true,
	bProvidesVision		= true,
	iVisionRadius		= wraith_vision_radius,
	iVisionTeamNumber	= caster:GetTeamNumber(),
	ExtraData = 
	{
		damage_ability = damage_ability,
		root = root,
	},
})
end 


function arc_warden_spark_wraith_custom:OnProjectileHit_ExtraData(target, location, ExtraData)
if not target then return end

local caster = self:GetCaster()
local damage_ability = ExtraData.damage_ability
local damage_radius = self:GetSpecialValueFor("damage_radius")

AddFOWViewer(caster:GetTeamNumber(), location, self:GetSpecialValueFor("wraith_vision_radius"), self:GetSpecialValueFor("wraith_vision_duration"), true)

if caster:HasTalent("modifier_arc_warden_spark_7") and target:IsRealHero() then
	local mod_owner = caster.owner and caster.owner or caster
	local ability = mod_owner:FindAbilityByName("arc_warden_spark_wraith_custom_legendary")
	if ability and ability:GetCooldownTimeRemaining() <= 0 then
		mod_owner:AddNewModifier(mod_owner, self, "modifier_arc_warden_spark_wraith_custom_legendary_stack", {duration = caster:GetTalentValue("modifier_arc_warden_spark_7", "duration")})
	end
end

if ExtraData.root ~= 0 then
	target:AddNewModifier(caster, self, "modifier_arc_warden_spark_wraith_custom_root", {duration = (1 - target:GetStatusResistance())*ExtraData.root})
end

for _,unit in pairs(caster:FindTargets(damage_radius, target:GetAbsOrigin())) do 
	self:DealDamage(unit, unit ~= target, damage_ability)
end

return true
end



modifier_arc_warden_spark_wraith_custom_thinker = class(mod_hidden)
function modifier_arc_warden_spark_wraith_custom_thinker:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.radius	= self.ability:GetSpecialValueFor("radius")
self.activation_delay = self.ability:GetSpecialValueFor("base_activation_delay")*(1 + self.caster:GetTalentValue("modifier_arc_warden_spark_2", "delay")/100)
self.think_interval	= self.ability:GetSpecialValueFor("think_interval")
self.wraith_vision_radius = self.ability:GetSpecialValueFor("wraith_vision_radius")

if not IsServer() then return end

self.parent:EmitSound("Hero_ArcWarden.SparkWraith.Loop")

local particle_name = "particles/arc_warden/spark_hero.vpcf"
if self.caster:HasModifier("modifier_arc_warden_ti9_immortal_shoulders") then
   particle_name = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith.vpcf"
end

self.wraith_particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.wraith_particle, 1, Vector(self.radius, 1, 1))
self:AddParticle(self.wraith_particle, false, false, -1, false, false)

self.origin = self.parent:GetAbsOrigin()

AddFOWViewer(self.caster:GetTeamNumber(), self.origin, self.wraith_vision_radius, self.activation_delay, false)
self:StartIntervalThink(self.activation_delay)
end

function modifier_arc_warden_spark_wraith_custom_thinker:OnIntervalThink()
if not IsServer() then return end 

AddFOWViewer(self.caster:GetTeamNumber(), self.origin, self.wraith_vision_radius, self.think_interval, false)

for _, enemy in pairs(self.caster:FindTargets(self.radius, self.origin)) do
	self.ability:LaunchSpark(enemy, self.parent)
	self:Destroy()
	return
end

self:StartIntervalThink(self.think_interval)
end

function modifier_arc_warden_spark_wraith_custom_thinker:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Hero_ArcWarden.SparkWraith.Loop")
end



modifier_arc_warden_spark_wraith_custom_slow = class({})
function modifier_arc_warden_spark_wraith_custom_slow:OnCreated()
self.move_speed_slow_pct	= self:GetAbility():GetSpecialValueFor("move_speed_slow_pct")
end

function modifier_arc_warden_spark_wraith_custom_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_arc_warden_spark_wraith_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move_speed_slow_pct
end


modifier_arc_warden_spark_wraith_custom_move = class(mod_visible)
function modifier_arc_warden_spark_wraith_custom_move:GetTexture() return "buffs/arc_warden/spark_4" end
function modifier_arc_warden_spark_wraith_custom_move:OnCreated()
self.parent = self:GetParent()
self.move = self.parent:GetTalentValue("modifier_arc_warden_spark_4", "move")
if not IsServer() then return end
self.parent:GenericParticle("particles/zuus_speed.vpcf", self)
end

function modifier_arc_warden_spark_wraith_custom_move:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_arc_warden_spark_wraith_custom_move:GetModifierMoveSpeedBonus_Percentage()
return self.move
end




modifier_arc_warden_spark_wraith_custom_tracker = class(mod_hidden)
function modifier_arc_warden_spark_wraith_custom_tracker:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.has_legendary = self.parent:HasTalent("modifier_arc_warden_spark_7")
self.legendary_max = self.parent:GetTalentValue("modifier_arc_warden_spark_7", "max", true)
self.visual_max = 5

self.has_auto = self.parent:HasTalent("modifier_arc_warden_spark_3")
self.auto_chance = self.parent:GetTalentValue("modifier_arc_warden_spark_3", "chance")
self.auto_radius = self.parent:GetTalentValue("modifier_arc_warden_spark_3", "radius", true)

self.has_str = self.parent:HasTalent("modifier_arc_warden_hero_3")
self.mana_reduce = self.parent:GetTalentValue("modifier_arc_warden_hero_3", "mana")
self.str_duration = self.parent:GetTalentValue("modifier_arc_warden_hero_3", "duration", true)

self.cdr_bonus = self.parent:GetTalentValue("modifier_arc_warden_hero_4", "cdr")

if not IsServer() then return end
self.legendary_ability = self.parent:FindAbilityByName("arc_warden_spark_wraith_custom_legendary")

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end


function modifier_arc_warden_spark_wraith_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_arc_warden_spark_7" or self.parent:HasTalent("modifier_arc_warden_spark_7") then
	self.has_legendary = true
	self:UpdateUI()
end

if name == "modifier_arc_warden_hero_3" or self.parent:HasTalent("modifier_arc_warden_hero_3") then
	self.has_str = true
	self.mana_reduce = self.parent:GetTalentValue("modifier_arc_warden_hero_3", "mana")
	self.parent:AddSpellEvent(self, true)
end

if name == "modifier_arc_warden_hero_4" or self.parent:HasTalent("modifier_arc_warden_hero_4") then
	self.cdr_bonus = self.parent:GetTalentValue("modifier_arc_warden_hero_4", "cdr")
end

if name == "modifier_arc_warden_spark_3" or self.parent:HasTalent("modifier_arc_warden_spark_3") then
	self.has_auto = true
	self.auto_chance = self.parent:GetTalentValue("modifier_arc_warden_spark_3", "chance")
	self.parent:AddSpellEvent(self, true)
end

self:SendBuffRefreshToClients()
end

function modifier_arc_warden_spark_wraith_custom_tracker:AddCustomTransmitterData() 
return 
{
  mana_reduce = self.mana_reduce,
  cdr_bonus = self.cdr_bonus
} 
end

function modifier_arc_warden_spark_wraith_custom_tracker:HandleCustomTransmitterData(data)
self.mana_reduce = data.mana_reduce
self.cdr_bonus = data.cdr_bonus
end

function modifier_arc_warden_spark_wraith_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end

function modifier_arc_warden_spark_wraith_custom_tracker:GetModifierPercentageManacostStacking()
return self.mana_reduce
end

function modifier_arc_warden_spark_wraith_custom_tracker:GetModifierPercentageCooldown()
return self.cdr_bonus 
end

function modifier_arc_warden_spark_wraith_custom_tracker:SpellEvent(params)
if not IsServer() then return end
local unit = params.unit

if not unit:IsRealHero() then return end
if unit ~= self.parent then return end

if self.has_auto and RollPseudoRandomPercentage(self.auto_chance, 839, self.parent) then
	local target = params.target
	if not target or target:GetTeamNumber() == self.parent:GetTeamNumber() then
		target = self.parent:RandomTarget(self.auto_radius)
	end
	if target then
		local ability = self.parent:FindAbilityByName(self.ability:GetName())
		if ability then
			ability:LaunchSpark(target, self.parent, "modifier_arc_warden_spark_3")
		end
	end
end

if not self.has_str then return end
if params.ability:IsItem() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_spark_wraith_custom_str", {duration = self.str_duration})
local str_target = self.parent:GetTempest()
if str_target then
	str_target:AddNewModifier(self.parent, self.ability, "modifier_arc_warden_spark_wraith_custom_str", {duration = self.str_duration})
end

end

function modifier_arc_warden_spark_wraith_custom_tracker:UpdateUI()
if not IsServer() then return end
if not self.has_legendary then return end
if self.parent:IsTempestDouble() then return end

local stack = 0
local override = nil
local interval = -1
local mod = self.parent:FindModifierByName("modifier_arc_warden_spark_wraith_custom_legendary_stack")

if mod then
	stack = mod:GetStackCount()
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
else
	if not self.particle then
		self.particle = self.parent:GenericParticle("particles/arc_warden/spark_stacks.vpcf", self, true)
		for i = 1,self.visual_max do 
			ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
		end
	end
end

if self.legendary_ability and self.legendary_ability:GetCooldownTimeRemaining() > 0 then
	override = self.legendary_ability:GetCooldownTimeRemaining()
	interval = 1
end

self.parent:UpdateUIlong({stack = stack, max = self.legendary_max, override_stack = override, style = "ArcSparks"})
self:StartIntervalThink(interval)
end

function modifier_arc_warden_spark_wraith_custom_tracker:OnIntervalThink()
if not IsServer() then return end
self:UpdateUI()
end






arc_warden_spark_wraith_custom_legendary = class({})
function arc_warden_spark_wraith_custom_legendary:CreateTalent()
self:SetHidden(false)
self:SetLevel(1)
end

function arc_warden_spark_wraith_custom_legendary:GetChannelTime()
return self:GetCaster():GetTalentValue("modifier_arc_warden_spark_7", "cast")
end 

function arc_warden_spark_wraith_custom_legendary:GetAOERadius()
return self:GetSpecialValueFor("aoe_radius")
end

function arc_warden_spark_wraith_custom_legendary:GetCooldown(iLevel)
return self:GetCaster():GetTalentValue("modifier_arc_warden_spark_7", "talent_cd")
end

function arc_warden_spark_wraith_custom_legendary:OnAbilityPhaseStart()
local caster = self:GetCaster()

local caster_owner = caster.owner and caster.owner or caster
local mod = caster_owner:FindModifierByName("modifier_arc_warden_spark_wraith_custom_legendary_stack")
if not mod or mod:GetStackCount() <= 0 then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetId()), "CreateIngameErrorMessage", {message = "#arc_no_charges"})
	return false
end

caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 1.3)
return true
end 

function arc_warden_spark_wraith_custom_legendary:OnAbilityPhaseInterrupted()
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_3)
end 


function arc_warden_spark_wraith_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
local tempest = caster:GetTempest()
if tempest then
	local ability = tempest:FindAbilityByName(self:GetName())
	if ability then
		ability:StartCd()
	end
end

local caster_owner = caster.owner and caster.owner or caster
local mod = caster_owner:FindModifierByName("modifier_arc_warden_spark_wraith_custom_legendary_stack")
if not mod or mod:GetStackCount() <= 0 then return end

local stack = mod:GetStackCount()
mod:Destroy()
caster:AddNewModifier(caster, self, "modifier_arc_warden_spark_wraith_custom_legendary", {stack = stack, target = target:entindex()})
end 

function arc_warden_spark_wraith_custom_legendary:OnChannelFinish(bInterrupted)
self:GetCaster():RemoveModifierByName("modifier_arc_warden_spark_wraith_custom_legendary")
end 




modifier_arc_warden_spark_wraith_custom_legendary = class(mod_hidden)
function modifier_arc_warden_spark_wraith_custom_legendary:OnCreated(table)
if not IsServer() then return end 

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.target = EntIndexToHScript(table.target)

self.particle_ally_fx = ParticleManager:CreateParticle("particles/arc_warden/spark_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self.parent:GetAbsOrigin())
self:AddParticle(self.particle_ally_fx, false, false, -1, false, false)  

self.main_ability = self.parent:FindAbilityByName("arc_warden_spark_wraith_custom")

if not self.main_ability then
	self:Destroy()
	return
end

self.ticks = self.ability:GetSpecialValueFor("ticks")
self.damage_k = self.parent:GetTalentValue("modifier_arc_warden_spark_7", "damage")/100

self.has_heal = self.parent:HasTalent("modifier_arc_warden_spark_3")

self.damage = self.main_ability:GetDamage()*table.stack*self.damage_k / self.ticks
self.damage_table = {victim = self.target, damage = self.damage, attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

self.interval = 0.05
self.count = 0.05
self.launch_part = false
self.launch_anim = false

self.visual_timer = 0.2
self.visual_count = 0

self.radius = self.ability:GetSpecialValueFor("aoe_radius")
self.effect_cast = ParticleManager:CreateParticle("particles/blue_zone.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target)
ParticleManager:SetParticleControl( self.effect_cast, 0, self.target:GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, 0 ) )
self:AddParticle(self.effect_cast, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end 


function modifier_arc_warden_spark_wraith_custom_legendary:OnIntervalThink()
if not IsServer() then return end 
if not IsValid(self.target) or not self.target:IsAlive() then
	self:Destroy()
	return
end

self.count = self.count + self.interval
self.visual_count = self.visual_count + self.interval

if self.visual_count >= self.visual_timer then
	self.visual_count = 0

	local origin = self.target:GetAbsOrigin() + RandomVector(RandomInt(150, 300))
	CreateModifierThinker(self.parent, self.ability, "modifier_arc_warden_spark_wraith_custom_legendary_thinker", {target = self.target:entindex(), duration = 3}, origin, self.parent:GetTeamNumber(), false)
end

if self.count >= 0.1 and self.launch_part == false then
	self.launch_part = true

	self.target:EmitSound("Arc.Spark_legendary")
	self.target:EmitSound("Arc.Spark_legendary2")

	for _,target in pairs(self.parent:FindTargets(self.radius, self.target:GetAbsOrigin())) do
		self.damage_table.victim = target
		local real_damage = DoDamage(self.damage_table)
		if target == self.target then
			self.target:SendNumber(24, real_damage)
		end
		if self.has_heal and self.main_ability then
			self.main_ability:ProcHeal(real_damage, target, target ~= self.target)
		end
	end

	for i = 1,3 do
		local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(cast_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(cast_particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(cast_particle)
	end

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)

	local target_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_tempest_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target )
	ParticleManager:SetParticleControlEnt(target_particle, 0, self.target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(target_particle)

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_wraith_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self.parent)
	ParticleManager:SetParticleControlEnt(cast_particle, 1,  self.parent, PATTACH_POINT_FOLLOW, "attach_attack1",  self.parent:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)
end 

if self.count >= 0.55 and self.launch_anim == false then
	self.launch_anim = true 
	self.parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 1.1)
end 

if self.count >= 0.85 then 
	self.count = 0
	self.launch_part = false
	self.launch_anim = false
end 

end

function modifier_arc_warden_spark_wraith_custom_legendary:OnDestroy()
if not IsServer() then return end 
self.parent:Stop()
end 







modifier_arc_warden_spark_wraith_custom_str = class(mod_visible)
function modifier_arc_warden_spark_wraith_custom_str:GetTexture() return "buffs/arc_warden/hero_3" end
function modifier_arc_warden_spark_wraith_custom_str:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.str = self.parent:GetTalentValue("modifier_arc_warden_hero_3", "str")
self.max = self.parent:GetTalentValue("modifier_arc_warden_hero_3", "max")
if not IsServer() then return end
self.StackOnIllusion = true
self:SetStackCount(1)
self.parent:CalculateStatBonus(true)
end

function modifier_arc_warden_spark_wraith_custom_str:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end

function modifier_arc_warden_spark_wraith_custom_str:OnDestroy()
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_arc_warden_spark_wraith_custom_str:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end

function modifier_arc_warden_spark_wraith_custom_str:GetModifierBonusStats_Strength()
return self.str*self:GetStackCount()
end


modifier_arc_warden_spark_wraith_custom_legendary_thinker = class(mod_hidden)
function modifier_arc_warden_spark_wraith_custom_legendary_thinker:OnCreated(table)
if not IsServer() then return end
self.target = EntIndexToHScript(table.target)
self.ability = self:GetAbility()
self.parent = self:GetParent()
local proj_pfx = "particles/units/heroes/hero_arc_warden/arc_warden_wraith_prj.vpcf"
if self:GetCaster():HasModifier("modifier_arc_warden_ti9_immortal_shoulders") then
    proj_pfx = "particles/econ/items/arc_warden/arc_warden_ti9_immortal/arc_warden_ti9_wraith_prj.vpcf"
end
ProjectileManager:CreateTrackingProjectile(
{
	EffectName			= proj_pfx,
	Ability				= self.ability,
	Source				= self.parent,
	vSourceLoc			= self.parent:GetAbsOrigin(),
	Target				= self.target,
	iMoveSpeed			= 900,
	bDodgeable			= false,
	bVisibleToEnemies	= true,
	bProvidesVision		= false,
})

EmitSoundOnLocationWithCaster(self.parent:GetAbsOrigin(),"Hero_ArcWarden.SparkWraith.Activate", self:GetCaster())
end





modifier_arc_warden_spark_wraith_custom_legendary_stack = class(mod_hidden)
function modifier_arc_warden_spark_wraith_custom_legendary_stack:RemoveOnDeath() return false end
function modifier_arc_warden_spark_wraith_custom_legendary_stack:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.parent:GetTalentValue("modifier_arc_warden_spark_7", "max")
self.radius = self.parent:GetTalentValue("modifier_arc_warden_spark_7", "radius")
self.duration = self.parent:GetTalentValue("modifier_arc_warden_spark_7", "duration")
if not IsServer() then return end
self.mod = self.parent:FindModifierByName("modifier_arc_warden_spark_wraith_custom_tracker")

self.visual_max = 5
self.particle = self.parent:GenericParticle("particles/arc_warden/spark_stacks.vpcf", self, true)

self:SetStackCount(1)
self:StartIntervalThink(0.2)
end

function modifier_arc_warden_spark_wraith_custom_legendary_stack:OnIntervalThink()
if not IsServer() then return end
local targets = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

if #targets > 0 then
	self:SetDuration(self.duration, true)
end

end

function modifier_arc_warden_spark_wraith_custom_legendary_stack:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_arc_warden_spark_wraith_custom_legendary_stack:OnStackCountChanged()
if not IsServer() then return end

if self.mod then
	self.mod:UpdateUI()
end

if not self.particle then return end

for i = 1,self.visual_max do 
	if i <= math.floor(self:GetStackCount()/(self.max/self.visual_max)) then 
		ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
	else 
		ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
	end
end

end

function modifier_arc_warden_spark_wraith_custom_legendary_stack:OnDestroy()
if not IsServer() then return end
if not self.mod then return end
self.mod:UpdateUI()
end





modifier_arc_warden_spark_wraith_custom_fear_count = class(mod_hidden)
function modifier_arc_warden_spark_wraith_custom_fear_count:OnCreated()
if not IsServer() then return end 
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()
self.max = self.caster:GetTalentValue("modifier_arc_warden_hero_7", "max")
self.fear = self.caster:GetTalentValue("modifier_arc_warden_hero_7", "fear")
self.cd = self.caster:GetTalentValue("modifier_arc_warden_hero_7", "talent_cd")

self.effect_cast = self.parent:GenericParticle("particles/arc_warden/spark_fear_stack.vpcf", self, true)
self:SetStackCount(1)
end 

function modifier_arc_warden_spark_wraith_custom_fear_count:OnRefresh(table)
if not IsServer() then return end 

self:IncrementStackCount()

if self:GetStackCount() < self.max then return end

self.parent:EmitSound("BS.Rupture_fear")
self.parent:AddNewModifier(self.caster, self.ability, "modifier_nevermore_requiem_fear", {duration = self.fear*(1 - self.parent:GetStatusResistance())})
self.parent:AddNewModifier(self.caster, self.ability, "modifier_arc_warden_spark_wraith_custom_fear_cd", {duration = self.cd})
self:Destroy()
end 

function modifier_arc_warden_spark_wraith_custom_fear_count:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then return end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end

modifier_arc_warden_spark_wraith_custom_fear_cd = class(mod_hidden)
function modifier_arc_warden_spark_wraith_custom_fear_cd:RemoveOnDeath() return false end





modifier_arc_warden_spark_wraith_custom_root = class({})
function modifier_arc_warden_spark_wraith_custom_root:IsHidden() return true end
function modifier_arc_warden_spark_wraith_custom_root:IsPurgable() return true end
function modifier_arc_warden_spark_wraith_custom_root:CheckState()
return
{
  [MODIFIER_STATE_ROOTED] = true
}
end
function modifier_arc_warden_spark_wraith_custom_root:GetEffectName() return "particles/items3_fx/gleipnir_root.vpcf" end
function modifier_arc_warden_spark_wraith_custom_root:OnCreated()
if not IsServer() then return end
self:GetParent():EmitSound("Arc.Spark_root")
end