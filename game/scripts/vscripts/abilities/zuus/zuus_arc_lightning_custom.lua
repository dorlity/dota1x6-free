LinkLuaModifier("modifier_zuus_arc_lightning_custom", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_tracker", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_speed", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_custom_legendary", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_custom_legendary_cast", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_custom_health", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_custom_heal_reduce", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_arc_lightning_custom_cd", "abilities/zuus/zuus_arc_lightning_custom" , LUA_MODIFIER_MOTION_NONE)



zuus_arc_lightning_custom = class({})



function zuus_arc_lightning_custom:GetAbilityTextureName()
local name = "zuus_arc_lightning"
local caster = self:GetCaster()
if caster:HasModifier("modifier_zuus_ti8_arms_custom") then
    name = "zeus/ti8_immortal_arms/zeus_arc_lightning_immortal"
end 
return name
end



function zuus_arc_lightning_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_zuus/z_w.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", context )
PrecacheResource( "particle","particles/zuus_linken.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_shard.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf", context )
PrecacheResource( "particle","particles/zuus_speed.vpcf", context )
PrecacheResource( "particle","particles/zeus_magic_attack.vpcf", context )
PrecacheResource( "particle","particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_end.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_vengeful/vengeful_swap_buff_overhead.vpcf", context )
PrecacheResource( "particle","particles/zeus/arc_legendary_radius.vpcf", context )
PrecacheResource( "particle","particles/zuus_shield_wrath.vpcf", context )
PrecacheResource( "particle","particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc.vpcf", context )
PrecacheResource( "particle","particles/zeus/arc_legendary_active.vpcf", context )
PrecacheResource( "particle","particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", context )

dota1x6:PrecacheShopItems("npc_dota_hero_zuus", context)
end

function zuus_arc_lightning_custom:GetCooldown(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_zuus_arc_3") then 
  bonus = self:GetCaster():GetTalentValue("modifier_zuus_arc_3", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function zuus_arc_lightning_custom:GetCastPoint(iLevel)
local bonus = 0
local caster = self:GetCaster()
if caster:HasTalent("modifier_zuus_arc_4") then 
    bonus = caster:GetTalentValue("modifier_zuus_arc_4", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function zuus_arc_lightning_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_zuus_arc_lightning_tracker"
end

function zuus_arc_lightning_custom:GetBehavior()
local bonus = 0
local caster = self:GetCaster()
if caster:HasTalent("modifier_zuus_arc_7") then
	bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + bonus
end


function zuus_arc_lightning_custom:CheckToggle()
local caster = self:GetCaster()

local shield = caster:FindModifierByName("modifier_zuus_arc_lightning_custom_legendary")
if not shield or shield:GetStackCount() == 0 then
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer( caster:GetPlayerOwnerID() ), "CreateIngameErrorMessage", {message = "#dota_hud_error_no_charges"})
    return false
end

return true
end


function zuus_arc_lightning_custom:DoDamage(target, new_damage_ability)
local caster = self:GetCaster()
local arc_damage	= self:GetSpecialValueFor("arc_damage") + caster:GetTalentValue("modifier_zuus_arc_1", "damage")*caster:GetMaxHealth()/100
local damage_ability = new_damage_ability and new_damage_ability or nil

arc_damage = (new_damage_ability and new_damage_ability == "modifier_zuus_arc_7") and arc_damage*caster:GetTalentValue("modifier_zuus_arc_7", "damage")/100 or arc_damage

print(arc_damage)

if caster:HasTalent("modifier_zuus_hero_3") then 
	target:AddNewModifier(caster, self, "modifier_zuus_arc_lightning_speed", {duration = caster:GetTalentValue("modifier_zuus_hero_3", "duration")})
end

if caster:HasTalent("modifier_zuus_arc_4") then
	target:AddNewModifier(caster, self, "modifier_zuus_arc_lightning_custom_heal_reduce", {duration = caster:GetTalentValue("modifier_zuus_arc_4", "duration")})
end

local static = caster:FindModifierByName("modifier_zuus_innate_custom") 
if static then 
	static:DealDamage(target)
end

DoDamage({attacker = caster, ability = self, victim = target, damage_type = DAMAGE_TYPE_MAGICAL, damage = arc_damage}, damage_ability)
target:EmitSound("Hero_Zuus.ArcLightning.Target")

local mod = caster:FindModifierByName("modifier_zuus_heavenly_jump_custom_passive")
if mod then
	mod:PassiveProc(target)
end

end


function zuus_arc_lightning_custom:OnSpellStart(new_target)

local caster = self:GetCaster()

local target = self:GetCursorTarget()
if new_target then 
	target = new_target
end

if target:TriggerSpellAbsorb(self) then return end

if caster:GetQuest() == "Zuus.Quest_5" and target:IsRealHero() and not caster:QuestCompleted() and (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= caster.quest.number then 
	caster:UpdateQuest(1)
end

local mod = caster:FindModifierByName("modifier_zuus_heavenly_jump_custom_passive")
if mod then
	mod:LegendaryStack(target:IsRealHero())
end

caster:EmitSound("Hero_Zuus.ArcLightning.Cast")
local head_name_part = "particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf"
if caster:HasModifier("modifier_zuus_ti8_arms_custom") then
    head_name_part = "particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc_head.vpcf"
end
local head_particle = ParticleManager:CreateParticle(head_name_part, PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(head_particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(head_particle)

local damage_ability = new_target and "modifier_zuus_arc_2" or nil

caster:AddNewModifier(caster, self, "modifier_zuus_arc_lightning_custom", {target = target:entindex(), damage_ability = damage_ability})
end





modifier_zuus_arc_lightning_custom = class(mod_hidden)
function modifier_zuus_arc_lightning_custom:RemoveOnDeath()	return false end
function modifier_zuus_arc_lightning_custom:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_zuus_arc_lightning_custom:OnCreated(params)
if not IsServer() then return end

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.total_damage = 1

self.radius	= self.ability:GetSpecialValueFor("radius")
self.jump_count	= self.ability:GetSpecialValueFor("jump_count")
self.jump_delay	= self.ability:GetSpecialValueFor("jump_delay")
self.current_unit = EntIndexToHScript(params.target)
self.damage_ability = params.damage_ability
self.units_affected	= {}
self.max_per_target = 1
self.unit_counter = 0


self.team = DOTA_UNIT_TARGET_TEAM_ENEMY

if self.parent:HasTalent("modifier_zuus_arc_3") or self.parent:HasTalent("modifier_zuus_arc_7") then 
	self.team = DOTA_UNIT_TARGET_TEAM_BOTH
end

self.health_duration = self.parent:GetTalentValue("modifier_zuus_arc_3", "duration")

self.legendary_duration = self.parent:GetTalentValue("modifier_zuus_arc_7", "duration")

self.ligth_particle = "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf"
if self.parent:HasModifier("modifier_zuus_ti8_arms_custom") then
    self.ligth_particle = "particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc.vpcf"
end

if self.parent:HasTalent("modifier_zuus_hero_3") then 
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_arc_lightning_speed", {duration = self.parent:GetTalentValue("modifier_zuus_hero_3", "duration")})
end

if not self.current_unit or self.current_unit:IsNull() then return end

self.units_affected[self.current_unit]	= 1

self.ability:DoDamage(self.current_unit, self.damage_ability)
self:StartIntervalThink(self.jump_delay)
end




function modifier_zuus_arc_lightning_custom:OnIntervalThink()
self.zapped = false

for _, enemy in pairs(FindUnitsInRadius(self.parent:GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.radius, self.team, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
	
	if (not self.units_affected[enemy] or self.units_affected[enemy] < self.max_per_target) 
		and enemy ~= self.current_unit and enemy:IsUnit() and (enemy:GetTeamNumber() ~= self.parent:GetTeamNumber() or enemy == self.parent) then
	
		local lightning_particle = ParticleManager:CreateParticle(self.ligth_particle, PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
		ParticleManager:SetParticleControlEnt(lightning_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(lightning_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(lightning_particle)
		enemy:EmitSound("Hero_Zuus.ArcLightning.Target")
	
		self.unit_counter = self.unit_counter + 1
		self.current_unit = enemy
		self.zapped	= true
		
		if self.units_affected[self.current_unit] then
			self.units_affected[self.current_unit]	= self.units_affected[self.current_unit] + 1
		else
			self.units_affected[self.current_unit]	= 1
		end
		
		if enemy ~= self.parent then 
			self.ability:DoDamage(enemy, self.damage_ability)
		else 
			if self.parent:HasTalent("modifier_zuus_arc_7") then
				self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_arc_lightning_custom_legendary", {duration = self.legendary_duration})
			end
			if self.parent:HasTalent("modifier_zuus_arc_3") then
				self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_arc_lightning_custom_health", {duration = self.health_duration})
			end
		end

		break
	end
end

if (self.unit_counter >= self.jump_count and self.jump_count > 0) or not self.zapped then
	self:StartIntervalThink(-1)
	self:Destroy()
end

end




modifier_zuus_arc_lightning_tracker = class(mod_hidden)
function modifier_zuus_arc_lightning_tracker:DeclareFunctions()
return
{
  	MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end

function modifier_zuus_arc_lightning_tracker:GetModifierPercentageManacostStacking()
return self.mana_bonus
end

function modifier_zuus_arc_lightning_tracker:GetModifierCastRangeBonusStacking()
return self.range_bonus
end


function modifier_zuus_arc_lightning_tracker:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.range_bonus = self.parent:GetTalentValue("modifier_zuus_hero_4", "range")
self.mana_bonus = self.parent:GetTalentValue("modifier_zuus_hero_4", "mana")

self.auto_cd = self.parent:GetTalentValue("modifier_zuus_arc_2", "talent_cd")
self.auto_heal = self.parent:GetTalentValue("modifier_zuus_arc_2", "heal", true)/100

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_zuus_arc_lightning_tracker:UpdateTalent(name)

if name == "modifier_zuus_arc_2" or self.parent:HasTalent("modifier_zuus_arc_2") then
	self.parent:AddDamageEvent_inc(self, true)
	self.auto_cd = self.parent:GetTalentValue("modifier_zuus_arc_2", "talent_cd")
end

if name == "modifier_zuus_hero_4" or self.parent:HasTalent("modifier_zuus_hero_4") then
	self.range_bonus = self.parent:GetTalentValue("modifier_zuus_hero_4", "range")
	self.mana_bonus = self.parent:GetTalentValue("modifier_zuus_hero_4", "mana")
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end


function modifier_zuus_arc_lightning_tracker:AddCustomTransmitterData() 
return 
{
    mana_bonus = self.mana_bonus,
    range_bonus = self.range_bonus
} 
end

function modifier_zuus_arc_lightning_tracker:HandleCustomTransmitterData(data)
self.mana_bonus = data.mana_bonus
self.range_bonus = data.range_bonus
end



function modifier_zuus_arc_lightning_tracker:DamageEvent_inc(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_zuus_arc_2") then return end
if self.parent ~= params.unit then return end
if not params.attacker:IsUnit() then return end
if self.parent:HasModifier("modifier_zuus_arc_lightning_custom_cd") then return end
if not self.parent:IsAlive() then return end
if params.inflictor then return end

self.ability:OnSpellStart(params.attacker)
self.parent:GenericHeal(self.parent:GetMaxHealth()*self.auto_heal, self.ability, nil, nil, "modifier_zuus_arc_2")
self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_arc_lightning_custom_cd", {duration = self.auto_cd})
end





modifier_zuus_arc_lightning_speed = class(mod_visible)
function modifier_zuus_arc_lightning_speed:IsPurgable() return true end
function modifier_zuus_arc_lightning_speed:GetTexture() return "buffs/arc_speed" end
function modifier_zuus_arc_lightning_speed:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.is_enemy = self.parent:GetTeamNumber() ~= self.caster:GetTeamNumber()

self.max = self.caster:GetTalentValue("modifier_zuus_hero_3", "max")
self.speed = self.caster:GetTalentValue("modifier_zuus_hero_3", "move")
if self.is_enemy then
	self.speed = self.caster:GetTalentValue("modifier_zuus_hero_3", "slow")
end

if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_zuus_arc_lightning_speed:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max and self.is_enemy then
	self.parent:GenericParticle("particles/units/heroes/hero_zuus/zuus_shard_slow.vpcf", self)
end

end


function modifier_zuus_arc_lightning_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_zuus_arc_lightning_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed*self:GetStackCount()
end








modifier_zuus_arc_lightning_custom_legendary = class(mod_hidden)
function modifier_zuus_arc_lightning_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_mjollnir_shield.vpcf" end
function modifier_zuus_arc_lightning_custom_legendary:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH end
function modifier_zuus_arc_lightning_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.radius = self.ability:GetSpecialValueFor("radius")

if not IsServer() then return end

self.active = false

self.interval = self.parent:GetTalentValue("modifier_zuus_arc_7", "interval")
self.heal = self.parent:GetTalentValue("modifier_zuus_arc_7", "heal")/100

self.RemoveForDuel = true

local shield_size = self.parent:GetModelRadius()
local common_vector = Vector(shield_size, 0, shield_size)

local particle = ParticleManager:CreateParticle("particles/zuus_shield_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(particle, 1, common_vector)
ParticleManager:SetParticleControl(particle, 2, common_vector)
ParticleManager:SetParticleControl(particle, 4, common_vector)
self:AddParticle(particle, false, false, -1, false, false)

self.effect = ParticleManager:CreateParticleForPlayer( "particles/zeus/arc_legendary_radius.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, PlayerResource:GetPlayer(self.parent:GetId()))
ParticleManager:SetParticleControl( self.effect, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl( self.effect, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.effect , false, false, -1, false, false ) 

self.parent:EmitSound("DOTA_Item.Mjollnir.Loop")

self.max_time = self:GetRemainingTime()

self.max = self.parent:GetTalentValue("modifier_zuus_arc_7", "max")
self:SetStackCount(1)
self:OnIntervalThink()
self:StartIntervalThink(0.15)
end 


function modifier_zuus_arc_lightning_custom_legendary:OnRefresh()
if not IsServer() then return end
if self.active == true then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end


function modifier_zuus_arc_lightning_custom_legendary:OnIntervalThink()
if not IsServer() then return end

if self.active then
	max_time = self.max
	time = self:GetStackCount()
	active = 1

	self.parent:GenericHeal(self.parent:GetMaxHealth()*self.heal, self.ability, false, "", "modifier_zuus_arc_7")
	self.parent:EmitSound("Hero_Zuus.ArcLightning.Cast")
	self.parent:GenericParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf")

	for _,unit in pairs(self.parent:FindTargets(self.radius)) do
		self.ability:DoDamage(unit, "modifier_zuus_arc_7")

		local lightning_particle = ParticleManager:CreateParticle("particles/econ/items/zeus/zeus_ti8_immortal_arms/zeus_ti8_immortal_arc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(lightning_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(lightning_particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(lightning_particle)

		unit:GenericParticle("particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf")
		unit:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
	end
	for i = 1,4 do
		local point = self.parent:GetAbsOrigin() + RandomVector(RandomInt(100, self.radius))
		local lightning_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:SetParticleControlEnt(lightning_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(lightning_particle, 1, point)
		ParticleManager:ReleaseParticleIndex(lightning_particle)
	end

	self:DecrementStackCount()
	if self:GetStackCount() <= 0 then
		self:Destroy()
		return
	else
		self:StartIntervalThink(self.interval)
	end
else
	self.parent:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = self:GetStackCount(), active = self:GetStackCount() >= self.max and 1 or 0, style = "ZeusArc"})
end

end


function modifier_zuus_arc_lightning_custom_legendary:Activate()
if not IsServer() then return end
self.active = true

self.parent:EmitSound("Zuus.Arc_legendary_start")
self.parent:EmitSound("Zuus.Arc_legendary_start2")

local line_position = self.parent:GetAbsOrigin() + self.parent:GetForwardVector() * self.radius * 0.85
local max = 5

for i = 1, max do
	local qangle = QAngle(0, 360/(max - 1) + RandomInt(-25, 25), 0)
	line_position = RotatePosition(self.parent:GetAbsOrigin(), qangle, line_position)

	if i >= max then
		line_position = self.parent:GetAbsOrigin()
	end

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle, 0, Vector(line_position.x, line_position.y, 3000))
	ParticleManager:SetParticleControl(particle, 1, Vector(line_position.x, line_position.y, line_position.z))
	ParticleManager:ReleaseParticleIndex(particle)
end


self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/zeus/arc_legendary_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "ZeusArc"})
self:OnIntervalThink()
end



function modifier_zuus_arc_lightning_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MODEL_SCALE
}
end


function modifier_zuus_arc_lightning_custom_legendary:GetModifierModelScale()
return self:GetStackCount()*5
end

function modifier_zuus_arc_lightning_custom_legendary:OnDestroy()
if not IsServer() then return end

if self.active then
	self.parent:EmitSound("Zuus.Arc_legendary_end")
end

self.parent:StopSound("DOTA_Item.Mjollnir.Loop")
self.parent:EmitSound("DOTA_Item.Mjollnir.DeActivate")
self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "ZeusArc"})
end





modifier_zuus_arc_lightning_custom_legendary_cast = class(mod_hidden)
function modifier_zuus_arc_lightning_custom_legendary_cast:RemoveOnDeath() return false end
function modifier_zuus_arc_lightning_custom_legendary_cast:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end

local shield = self.parent:FindModifierByName("modifier_zuus_arc_lightning_custom_legendary")
if shield then
	shield:Activate()
	self.ability:EndCooldown()
	self.ability:StartCooldown(self.parent:GetTalentValue("modifier_zuus_arc_7", "cd"))
end

self.ability:ToggleAutoCast()
self:Destroy()
end





modifier_zuus_arc_lightning_custom_health = class(mod_visible)
function modifier_zuus_arc_lightning_custom_health:GetTexture() return "buffs/pounce_armor" end
function modifier_zuus_arc_lightning_custom_health:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_zuus_arc_3", "max")
self.health = self.parent:GetTalentValue("modifier_zuus_arc_3", "health")

self:SetStackCount(1)
end

function modifier_zuus_arc_lightning_custom_health:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end


function modifier_zuus_arc_lightning_custom_health:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
}
end


function modifier_zuus_arc_lightning_custom_health:GetModifierExtraHealthPercentage()
return self.health*self:GetStackCount()
end






modifier_zuus_arc_lightning_custom_heal_reduce = class(mod_visible)
function modifier_zuus_arc_lightning_custom_heal_reduce:GetTexture() return "buffs/arc_damage" end
function modifier_zuus_arc_lightning_custom_heal_reduce:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.heal_reduce = self.caster:GetTalentValue("modifier_zuus_arc_4", "heal_reduce")
self.damage_reduce = self.caster:GetTalentValue("modifier_zuus_arc_4", "damage_reduce")
self.max = self.caster:GetTalentValue("modifier_zuus_arc_4", "max")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_zuus_arc_lightning_custom_heal_reduce:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() < self.max then return end
self.parent:GenericParticle("particles/items4_fx/spirit_vessel_damage.vpcf", self)
end

function modifier_zuus_arc_lightning_custom_heal_reduce:DeclareFunctions()
return
{

    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_zuus_arc_lightning_custom_heal_reduce:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount()*self.damage_reduce
end
function modifier_zuus_arc_lightning_custom_heal_reduce:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*self.damage_reduce
end
function modifier_zuus_arc_lightning_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self:GetStackCount()*self.heal_reduce
end
function modifier_zuus_arc_lightning_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget() 
return self:GetStackCount()*self.heal_reduce
end
function modifier_zuus_arc_lightning_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage()
return self:GetStackCount()*self.heal_reduce
end





modifier_zuus_arc_lightning_custom_cd = class(mod_cd)
function modifier_zuus_arc_lightning_custom_cd:GetTexture() return "buffs/storm_damage" end
