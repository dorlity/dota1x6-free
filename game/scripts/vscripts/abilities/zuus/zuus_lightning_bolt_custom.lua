LinkLuaModifier("modifier_zuus_lightning_bolt_custom_magic", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_tracker", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_item_stack", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_legendary", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_legendary_stack_count", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_root", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_root_cd", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)

zuus_lightning_bolt_custom = class({})


function zuus_lightning_bolt_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_zuus_lightning_weapon_custom") then
    return "zuus_lightning_bolt_immortal"
end 
return "zuus_lightning_bolt"
end


function zuus_lightning_bolt_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_arc_lightning_impact.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zeus/zeus_cloud.vpcf", context )
PrecacheResource( "particle","particles/zuus_attack_stack.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_zuus/zuus_lightning_bolt_aoe.vpcf", context )
PrecacheResource( "particle","particles/zeus/bolt_disarm.vpcf", context )
end


function zuus_lightning_bolt_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_zuus_lightning_bolt_custom_tracker"
end


function zuus_lightning_bolt_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()
local sound = "Hero_Zuus.LightningBolt.Cast"
if caster:HasModifier("modifier_zuus_lightning_weapon_custom") then
    sound = "Hero_Zuus.LightningBolt.Cast.Righteous"
end
caster:EmitSound(sound)
return true
end

function zuus_lightning_bolt_custom:GetCooldown(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_zuus_bolt_1") then 
  bonus = self:GetCaster():GetTalentValue("modifier_zuus_bolt_1", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function zuus_lightning_bolt_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
local point = target and target:GetAbsOrigin() or self:GetCursorPosition()
self:CastLightningBolt(point, false)
end



function zuus_lightning_bolt_custom:CastLightningBolt(point, nimbus, aoe)
if not IsServer() then return end
local caster = self:GetCaster()
local spread_aoe = self:GetSpecialValueFor("spread_aoe")
local true_sight_radius = self:GetSpecialValueFor("true_sight_radius")
local sight_duration = self:GetSpecialValueFor("sight_duration")
local stun_duration = self:GetSpecialValueFor("stun_duration") + caster:GetTalentValue("modifier_zuus_hero_1", "stun")
local damage = self:GetSpecialValueFor("damage")

local root_duration = caster:GetTalentValue("modifier_zuus_bolt_4", "root")
local root_cd = caster:GetTalentValue("modifier_zuus_bolt_4", "talent_cd")

local legendary_damage = caster:GetTalentValue("modifier_zuus_bolt_7", "damage_inc", true)/100

local damage_ability = aoe and "modifier_zuus_bolt_3" or nil
local z_pos = 3000

local target_point = point
local target = not aoe and caster:RandomTarget(spread_aoe, target_point, 0) or nil
local targets = aoe and caster:FindTargets(spread_aoe, target_point) or {}

if target then
	table.insert(targets, target)
	target_point = target:GetAbsOrigin()
end

local sound = "Hero_Zuus.LightningBolt"
if caster:HasModifier("modifier_zuus_lightning_weapon_custom") then
    sound = "Hero_Zuus.LightningBolt.Righteous"
end
AddFOWViewer(caster:GetTeamNumber(), target_point, true_sight_radius, sight_duration, false)


if not nimbus and target then
	if target:TriggerSpellAbsorb(self) then return end
end

if nimbus then
	if target then
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, nimbus)
		ParticleManager:SetParticleControl(particle, 0, nimbus:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(particle)	

		EmitSoundOnLocationWithCaster(target_point, sound, nimbus)
	end
else
    if caster:HasModifier("modifier_zuus_lightning_weapon_custom") then
        local particle = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_immortal_lightning.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, z_pos))
        ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, target_point.z))
        ParticleManager:SetParticleControl(particle, 3, Vector(target_point.x, target_point.y, target_point.z))
        ParticleManager:ReleaseParticleIndex(particle)

        local particle3 = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lb_cfx_il.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(particle3, 0, Vector(target_point.x, target_point.y, target_point.z))
        ParticleManager:ReleaseParticleIndex(particle3)
    else
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, z_pos))
        ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, target_point.z))
        ParticleManager:ReleaseParticleIndex(particle)
    end

    local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle2, 0, Vector(target_point.x, target_point.y, z_pos))
    ParticleManager:SetParticleControl(particle2, 1, Vector(target_point.x, target_point.y, target_point.z))
    ParticleManager:ReleaseParticleIndex(particle2)

	EmitSoundOnLocationWithCaster(target_point, sound, caster)
end


if caster:HasTalent("modifier_zuus_bolt_3") then 
	caster:CdItems(caster:GetTalentValue("modifier_zuus_bolt_3", "cd_items"))
end
if aoe then
	damage = damage * caster:GetTalentValue("modifier_zuus_bolt_3", "damage")/100
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, target_point)
    ParticleManager:SetParticleControl(particle, 1, Vector(spread_aoe, 0, 0))
    ParticleManager:ReleaseParticleIndex(particle)
end

local hit = false
local mod = caster:FindModifierByName("modifier_zuus_heavenly_jump_custom_passive")

for _,unit in pairs(targets) do

	if mod then
		if not hit then
			hit = true
			mod:LegendaryStack(unit:IsRealHero())
		end
		mod:PassiveProc(unit)
	end

	unit:GenericParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_impact.vpcf")
	unit:AddNewModifier(caster, self, "modifier_generic_vision", {duration = sight_duration})
	unit:AddNewModifier(caster, self, "modifier_truesight", {duration = sight_duration})

	local legendary_mod = unit:FindModifierByName("modifier_zuus_lightning_bolt_custom_legendary_stack_count")
	local legendary_stack = legendary_mod and legendary_mod:GetStackCount() or 0

	local creeps_k = 1
	if unit:IsCreep() then 
		creeps_k = self:GetSpecialValueFor("creeps_damage")
	end 

	local static = caster:FindModifierByName("modifier_zuus_innate_custom") 
	if static then 
		static:DealDamage(unit)
	end

	local damage = damage*(1 + legendary_stack*legendary_damage) *creeps_k

	if caster:HasTalent("modifier_zuus_bolt_2") then 
		unit:AddNewModifier(caster, self, "modifier_zuus_lightning_bolt_custom_magic", {duration = caster:GetTalentValue("modifier_zuus_bolt_2", "duration")})
	end
	local stun = (1 - unit:GetStatusResistance())*stun_duration
	unit:AddNewModifier(caster, self, "modifier_stunned", {duration = stun})

	if caster:HasTalent("modifier_zuus_bolt_4") and not unit:HasModifier("modifier_zuus_lightning_bolt_custom_root_cd") and not unit:IsDebuffImmune() then
		unit:AddNewModifier(caster, self, "modifier_zuus_lightning_bolt_custom_root", {duration = stun + (1 - unit:GetStatusResistance())*root_duration})
		unit:AddNewModifier(caster, self, "modifier_zuus_lightning_bolt_custom_root_cd", {duration = root_cd})
	end

	local real_damage = DoDamage({attacker = caster, ability = self, damage_type = DAMAGE_TYPE_MAGICAL, damage = damage, victim = unit}, damage_ability)
	if legendary_stack >= 6 then
		unit:SendNumber(24, real_damage)
	end

end

end



modifier_zuus_lightning_bolt_custom_magic = class({})
function modifier_zuus_lightning_bolt_custom_magic:IsHidden() return false end
function modifier_zuus_lightning_bolt_custom_magic:IsPurgable() return false end
function modifier_zuus_lightning_bolt_custom_magic:GetTexture() return "buffs/remnant_lowhp" end
function modifier_zuus_lightning_bolt_custom_magic:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_zuus_bolt_2", "max")
self.magic = self.caster:GetTalentValue("modifier_zuus_bolt_2", "magic")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_zuus_lightning_bolt_custom_magic:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_zuus_lightning_bolt_custom_magic:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_zuus_lightning_bolt_custom_magic:GetModifierMagicalResistanceBonus()
return self:GetStackCount()*self.magic
end




modifier_zuus_lightning_bolt_custom_tracker = class({})
function modifier_zuus_lightning_bolt_custom_tracker:IsHidden() return true end
function modifier_zuus_lightning_bolt_custom_tracker:IsPurgable() return false end
function modifier_zuus_lightning_bolt_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.items_duration = self.parent:GetTalentValue("modifier_zuus_bolt_3", "duration", true)
self.items_delay = self.parent:GetTalentValue("modifier_zuus_bolt_3", "delay", true)
self:UpdateTalent()
end 


function modifier_zuus_lightning_bolt_custom_tracker:UpdateTalent(name)

if name == "modifier_zuus_bolt_3" or self.parent:HasTalent("modifier_zuus_bolt_3") then
	self.parent:AddSpellEvent(self, true)
end

end

function modifier_zuus_lightning_bolt_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if not self.parent:HasTalent("modifier_zuus_bolt_3") then return end
if params.unit ~= self.parent then return end

local index = nil
local delay = nil
if params.target then
	index = params.target:entindex()
end
if params.ability == self.ability then
	delay = self.items_delay
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_zuus_lightning_bolt_custom_item_stack", {target = index, delay = delay, duration = self.items_duration})
end




modifier_zuus_lightning_bolt_custom_item_stack = class(mod_visible)
function modifier_zuus_lightning_bolt_custom_item_stack:GetTexture() return "buffs/bolt_items" end
function modifier_zuus_lightning_bolt_custom_item_stack:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.max = self.parent:GetTalentValue("modifier_zuus_bolt_3", "count")
self.radius = self.parent:GetTalentValue("modifier_zuus_bolt_3", "radius")

self.RemoveForDuel = true

self:SetStackCount(1)
end

function modifier_zuus_lightning_bolt_custom_item_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() < self.max then return end

self.target = table.target and EntIndexToHScript(table.target) or nil
local delay = table.delay and table.delay or 0

self:StartIntervalThink(delay)
end


function modifier_zuus_lightning_bolt_custom_item_stack:OnIntervalThink()
if not IsServer() then return end

local point = nil
if not self.target or self.target:IsNull() then
	self.target = self.parent:RandomTarget(self.radius)
end
if self.target then
	point = self.target:GetAbsOrigin()
else
	point = self.parent:GetAbsOrigin() + RandomVector(350)
end

self.ability:CastLightningBolt(point, false, true)
self:Destroy()
end



zuus_stormkeeper_custom = class({})

function zuus_stormkeeper_custom:CreateTalent()
self:SetHidden(false)
end

function zuus_stormkeeper_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe")
end

function zuus_stormkeeper_custom:GetChannelTime()
return self:GetSpecialValueFor("AbilityChannelTime")
end

function zuus_stormkeeper_custom:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_zuus_bolt_7", "talent_cd")
end

function zuus_stormkeeper_custom:OnSpellStart()
local caster = self:GetCaster()
local point = self:GetCursorPosition()
caster:AddNewModifier(caster, self, "modifier_zuus_lightning_bolt_custom_legendary", {x = point.x, y = point.y})
end


function zuus_stormkeeper_custom:OnChannelFinish( bInterrupted )
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_zuus_lightning_bolt_custom_legendary")
end




modifier_zuus_lightning_bolt_custom_legendary = class(mod_hidden)
function modifier_zuus_lightning_bolt_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.parent:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
self.radius = self.ability:GetSpecialValueFor("aoe")
self.max = self.parent:GetTalentValue("modifier_zuus_bolt_7", "max")
self.damage = self.parent:GetTalentValue("modifier_zuus_bolt_7", "damage")
self.stun = self.parent:GetTalentValue("modifier_zuus_bolt_7", "stun")

self.channel = self.ability:GetSpecialValueFor("AbilityChannelTime")
self.duration = self.ability:GetSpecialValueFor("duration")

self:SetStackCount(self.max)
self.target_point = GetGroundPosition(Vector(table.x, table.y, 0), nil)

self.damageTable = {attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage}

AddFOWViewer(self.parent:GetTeamNumber(), self.target_point, self.radius, self.channel, false)

self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, self.target_point)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

self.interval = self.channel/(self.max - 1) - FrameTime()

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_zuus_lightning_bolt_custom_legendary:OnIntervalThink()
if not IsServer() then return end

local units = self.parent:FindTargets(self.radius, self.target_point)

if #units == 0 then 
	local target_point = self.target_point + RandomVector(RandomInt(1, self.radius))

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack"..RandomInt(1, 2), self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, target_point)
	ParticleManager:ReleaseParticleIndex(particle)
else 
	for _,unit in pairs(units) do 
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack"..RandomInt(1, 2), self.parent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(particle)
		
		unit:AddNewModifier(self.parent, self.ability, "modifier_zuus_lightning_bolt_custom_legendary_stack_count", {duration = self.duration})
		unit:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = self.stun})

		self.damageTable.victim = unit
		DoDamage(self.damageTable)
	end
end

EmitSoundOnLocationWithCaster(self.target_point, "Hero_Zuus.LightningBolt", self.parent)

self:DecrementStackCount()
if self:GetStackCount() == 0 then 
	self:Destroy()
end

end


function modifier_zuus_lightning_bolt_custom_legendary:OnDestroy()
if not IsServer() then return end
self.parent:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end



modifier_zuus_lightning_bolt_custom_legendary_stack_count = class(mod_visible)
function modifier_zuus_lightning_bolt_custom_legendary_stack_count:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.damage = self.caster:GetTalentValue("modifier_zuus_bolt_7", "damage_inc")

if not IsServer() then return end
self.duration = self:GetRemainingTime()
self.RemoveForDuel = true
self.particle = self.parent:GenericParticle("particles/zuus_attack_stack.vpcf", self, true)
self:AddStack()
end


function modifier_zuus_lightning_bolt_custom_legendary_stack_count:OnRefresh()
if not IsServer() then return end
self:AddStack()
end

function modifier_zuus_lightning_bolt_custom_legendary_stack_count:AddStack()
if not IsServer() then return end

Timers:CreateTimer(self.duration, function() 
  if self and not self:IsNull() then 
    self:DecrementStackCount()
    if self:GetStackCount() <= 0 then 
      self:Destroy()
    end 
  end 
end)

self:IncrementStackCount()
end


function modifier_zuus_lightning_bolt_custom_legendary_stack_count:OnStackCountChanged(iStackCount)
if not self.particle then return end
ParticleManager:SetParticleControl( self.particle, 1, Vector( 0, self:GetStackCount(), 0 ) )
end


function modifier_zuus_lightning_bolt_custom_legendary_stack_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_zuus_lightning_bolt_custom_legendary_stack_count:OnTooltip()
return self.damage*self:GetStackCount()
end





modifier_zuus_lightning_bolt_custom_root_cd = class(mod_hidden)
function modifier_zuus_lightning_bolt_custom_root_cd:RemoveOnDeath() return false end
function modifier_zuus_lightning_bolt_custom_root_cd:OnCreated()
self.RemoveForDuel = true
end



modifier_zuus_lightning_bolt_custom_root = class({})
function modifier_zuus_lightning_bolt_custom_root:IsHidden() return true end
function modifier_zuus_lightning_bolt_custom_root:IsPurgable() return true end
function modifier_zuus_lightning_bolt_custom_root:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_DISARMED] = true
}
end
function modifier_zuus_lightning_bolt_custom_root:GetEffectName() return "particles/items3_fx/gleipnir_root.vpcf" end
function modifier_zuus_lightning_bolt_custom_root:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.parent:GenericParticle("particles/zeus/bolt_disarm.vpcf", self, true)
end
