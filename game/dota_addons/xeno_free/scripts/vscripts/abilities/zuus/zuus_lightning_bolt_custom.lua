LinkLuaModifier("modifier_zuus_lightning_bolt_custom_true_sight", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_dummy", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_magic", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_aoe_thinker", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_tracker", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_item_stack", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_legendary", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_legendary_stack", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_legendary_stack_count", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zuus_lightning_bolt_custom_legendary_stack_visual", "abilities/zuus/zuus_lightning_bolt_custom" , LUA_MODIFIER_MOTION_NONE)

zuus_lightning_bolt_custom = class({})

zuus_lightning_bolt_custom.stun_range = {100, 150, 200}
zuus_lightning_bolt_custom.stun_duration = {0.2, 0.3, 0.4}

zuus_lightning_bolt_custom.resist_magic = {-4, -6, -8}
zuus_lightning_bolt_custom.resist_max = 4
zuus_lightning_bolt_custom.resist_duration = 8

zuus_lightning_bolt_custom.cd_reduction = {-1, -1.5, -2}


zuus_lightning_bolt_custom.aoe_radius = 220
zuus_lightning_bolt_custom.aoe_delay = 1.5
zuus_lightning_bolt_custom.aoe_damage = {0.5, 0.8}
zuus_lightning_bolt_custom.aoe_stun = {0.2, 0.4}

zuus_lightning_bolt_custom.near_heal = 0.3
zuus_lightning_bolt_custom.near_creeps = 0.33
zuus_lightning_bolt_custom.near_range = 325
zuus_lightning_bolt_custom.near_move = 40
zuus_lightning_bolt_custom.near_duration = 3

zuus_lightning_bolt_custom.item_cd = 1.2
zuus_lightning_bolt_custom.cd_range = 900
zuus_lightning_bolt_custom.cd_max = 3


zuus_lightning_bolt_custom.bad_items = 
{
	["item_soul_ring"] = true,
	["item_bracer_custom"] = true,
	["item_wraith_band_custom"] = true,
	["item_null_talisman_custom"] = true,
	["item_power_treads"] = true,
	["item_phase_boots"] = true,
	["item_branches"] = true,
	["item_quelling_blade"] = true,
	["item_radiance_custom"] = true,
	["item_bfury"] = true,
	["item_vambrace"] = true,
	["item_flicker"] = true,	
	["item_havoc_hammer"] = true,
}


function zuus_lightning_bolt_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_zuus/zuus_arc_lightning_impact.vpcf', context )
PrecacheResource( "particle", 'particles/zeus_resist_stack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_zeus/zeus_cloud.vpcf', context )
PrecacheResource( "particle", 'particles/econ/items/omniknight/hammer_ti6_immortal/zeus_heal_bolt.vpcf', context )
PrecacheResource( "particle", 'particles/zuus_speed.vpcf', context )
PrecacheResource( "particle", 'particles/zuus_attack_stack.vpcf', context )

end






function zuus_lightning_bolt_custom:GetIntrinsicModifierName()
return "modifier_zuus_lightning_bolt_custom_tracker"
end

function zuus_lightning_bolt_custom:GetAOERadius()
if self:GetCaster():HasModifier("modifier_zuus_bolt_5") then 
	return self.near_range
end
	return 0
end



function zuus_lightning_bolt_custom:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.LightningBolt.Cast")
	return true
end

function zuus_lightning_bolt_custom:GetCooldown(iLevel)

local bonus = 0
if self:GetCaster():HasModifier("modifier_zuus_bolt_3") then 
  bonus = self.cd_reduction[self:GetCaster():GetUpgradeStack("modifier_zuus_bolt_3")]
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end


function zuus_lightning_bolt_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_zuus_bolt_1") then 
  upgrade = self.stun_range[self:GetCaster():GetUpgradeStack("modifier_zuus_bolt_1")]
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function zuus_lightning_bolt_custom:OnSpellStart(new_target)
	if not IsServer() then return end
	local target = self:GetCursorTarget()
	if new_target then 
		target = new_target
	end

	local point = self:GetCursorPosition()

	self:CastLightningBolt(self:GetCaster(), target, point, false, false, false, false)
end

function zuus_lightning_bolt_custom:CastLightningBolt(caster, target, target_point, not_cast, nimbus, hand, delayed)
if not IsServer() then return end

local spread_aoe 			= self:GetSpecialValueFor("spread_aoe")
local true_sight_radius 	= self:GetSpecialValueFor("true_sight_radius")
local sight_radius_day  	= self:GetSpecialValueFor("sight_radius_day")
local sight_radius_night  	= self:GetSpecialValueFor("sight_radius_night")
local sight_duration 		= self:GetSpecialValueFor("sight_duration")
local stun_duration 		= 0.35


local z_pos 				= 3000

if nimbus then
	nimbus:EmitSound("Hero_Zuus.LightningBolt")
end

AddFOWViewer(caster:GetTeam(), target_point, true_sight_radius, sight_duration, false)

if target ~= nil then
	target_point = target:GetAbsOrigin()
	if target == caster then
		z_pos = 2050
	end
end

if target == nil then

	local nearby_enemy_units = FindUnitsInRadius( caster:GetTeamNumber(),  target_point,  nil,  spread_aoe,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_NONE,  FIND_CLOSEST,  false )
	
	for i,unit in pairs(nearby_enemy_units) do
			target = unit
			break
	end

end


if target == nil then
	local nearby_enemy_units = FindUnitsInRadius( caster:GetTeamNumber(),  target_point,  nil,  spread_aoe,  DOTA_UNIT_TARGET_TEAM_ENEMY,  self:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	for i,unit in pairs(nearby_enemy_units) do
		target = unit
		break
	end
end


if self:GetCaster():HasModifier("modifier_zuus_jump_4") and not_cast == false and target ~= nil then 
	local ability = self:GetCaster():FindAbilityByName("zuus_heavenly_jump_custom")

	if ability and ability:GetLevel() > 0 then 
		self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_zuus_heavenly_jump_custom_attack_speed", {duration = ability.speed_duration})
	end
end


if not nimbus and target then
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(self) then
			return nil
		end
	end
end


if nimbus then
	if target then
		local nimbus_point = nimbus:GetAbsOrigin()
		local target_point = target:GetAbsOrigin()


		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, nimbus)
		ParticleManager:SetParticleControl(particle, 0, nimbus:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		EmitSoundOnLocationWithCaster(target_point, "Hero_Zuus.LightningBolt", nimbus)
	end
else

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, nil)
	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt_glow_fx.vpcf", PATTACH_WORLDORIGIN, nil)
		
	if target and not target:IsMagicImmune() then 
		target_point = target:GetAbsOrigin()
	end

	ParticleManager:SetParticleControl(particle, 0, Vector(target_point.x, target_point.y, z_pos))
	ParticleManager:SetParticleControl(particle, 1, Vector(target_point.x, target_point.y, target_point.z))
	ParticleManager:ReleaseParticleIndex(particle)

	ParticleManager:SetParticleControl(particle2, 0, Vector(target_point.x, target_point.y, z_pos))
	ParticleManager:SetParticleControl(particle2, 1, Vector(target_point.x, target_point.y, target_point.z))
	ParticleManager:ReleaseParticleIndex(particle2)


	if self:GetCaster():HasModifier("modifier_zuus_bolt_1") then 
		stun_duration = stun_duration + self.stun_duration[self:GetCaster():GetUpgradeStack("modifier_zuus_bolt_1")]
	end

	if self:GetCaster():HasModifier("modifier_zuus_bolt_4") and not_cast == false then 
		CreateModifierThinker(self:GetCaster(), self, "modifier_zuus_lightning_bolt_custom_aoe_thinker", {duration = self.aoe_delay, radius = self.aoe_radius}, target_point, self:GetCaster():GetTeamNumber(), false)
	end

	EmitSoundOnLocationWithCaster(target_point, "Hero_Zuus.LightningBolt", caster)

end

AddFOWViewer(self:GetCaster():GetTeamNumber(), target_point, sight_radius_day, sight_duration, false)

if target ~= nil and target:GetTeam() ~= caster:GetTeam() then


	local ifx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_impact.vpcf",PATTACH_ABSORIGIN_FOLLOW,target)
	ParticleManager:SetParticleControlEnt(ifx,1,target,PATTACH_ABSORIGIN_FOLLOW,nil,target:GetAbsOrigin(),true)
	ParticleManager:ReleaseParticleIndex(ifx)

	target:AddNewModifier(caster, self, "modifier_zuus_lightning_bolt_custom_true_sight", {duration = sight_duration})
	--target:AddNewModifier(caster, self, "modifier_item_dustofappearance", {duration = sight_duration})

	local k = 1
	if delayed == true then 
		k = self.aoe_damage[self:GetCaster():GetUpgradeStack("modifier_zuus_bolt_4")]
		stun_duration = self.aoe_stun[self:GetCaster():GetUpgradeStack("modifier_zuus_bolt_4")]
	end


	if hand == true then 
		stun_duration = 0.1
	else 
		if self:GetCaster():HasModifier("modifier_zuus_bolt_7") then 
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_lightning_bolt_custom_legendary_stack", {})
		end
	end

	local damage = self:GetSpecialValueFor("damage")*k


	local legendary_mod = target:FindModifierByName("modifier_zuus_lightning_bolt_custom_legendary_stack_count")
	if legendary_mod and caster:HasAbility("zuus_stormkeeper_custom") then 
		damage = damage*(1 +  legendary_mod:GetStackCount()*caster:FindAbilityByName("zuus_stormkeeper_custom"):GetSpecialValueFor("damage_inc")/100)
	end

	local creeps_k = 1
	if target:IsCreep() then 
		creeps_k = self:GetSpecialValueFor("creeps_damage")
	end 

	
	target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration * (1 - target:GetStatusResistance())})
	ApplyDamage({attacker = caster, ability = self, damage_type = self:GetAbilityDamageType(), damage = damage*creeps_k, victim = target})

	if self:GetCaster():HasModifier("modifier_zuus_bolt_2") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_zuus_lightning_bolt_custom_magic", {duration = self.resist_duration})
	end

	if self:GetCaster():HasModifier("modifier_zuus_bolt_6") then 
		for i = 0, 8 do
	        local current_item = self:GetCaster():GetItemInSlot(i)
	  

	        if current_item and not NoCdItems[current_item:GetName()] then  
	          local cd = current_item:GetCooldownTimeRemaining()
	          current_item:EndCooldown()
	          if cd > self.item_cd then 
	            current_item:StartCooldown(cd - self.item_cd)
	          end
	 
	        end
	    end

	end


end

end



modifier_zuus_lightning_bolt_custom_true_sight = class({})


function modifier_zuus_lightning_bolt_custom_true_sight:IsHidden() return true end
function modifier_zuus_lightning_bolt_custom_true_sight:IsPurgable() return false end
function modifier_zuus_lightning_bolt_custom_true_sight:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.1)
--self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_truesight", {duration = self:GetRemainingTime()})
end

function modifier_zuus_lightning_bolt_custom_true_sight:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end

function modifier_zuus_lightning_bolt_custom_true_sight:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, 0.2, false)
end





modifier_zuus_lightning_bolt_custom_magic = class({})
function modifier_zuus_lightning_bolt_custom_magic:IsHidden() return false end
function modifier_zuus_lightning_bolt_custom_magic:IsPurgable() return true end
function modifier_zuus_lightning_bolt_custom_magic:GetTexture() return "buffs/remnant_lowhp" end
function modifier_zuus_lightning_bolt_custom_magic:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_zuus_lightning_bolt_custom_magic:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().resist_max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().resist_max then 

	self.particle_peffect = ParticleManager:CreateParticle("particles/zeus_resist_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
	ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
	self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

end

function modifier_zuus_lightning_bolt_custom_magic:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
}
end

function modifier_zuus_lightning_bolt_custom_magic:GetModifierMagicalResistanceBonus()
return self:GetStackCount()*self:GetAbility().resist_magic[self:GetCaster():GetUpgradeStack("modifier_zuus_bolt_2")]
end


modifier_zuus_lightning_bolt_custom_aoe_thinker = class({})
function modifier_zuus_lightning_bolt_custom_aoe_thinker:IsHidden() return true end
function modifier_zuus_lightning_bolt_custom_aoe_thinker:IsPurgable() return false end
function modifier_zuus_lightning_bolt_custom_aoe_thinker:OnCreated(table)
if not IsServer() then return end

	local target_point = self:GetParent():GetAbsOrigin()
	self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, Vector(target_point.x, target_point.y, 350))
	ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self:GetAbility().aoe_radius, 0, 0))
	ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, Vector(target_point.x, target_point.y, target_point.z + 350))	
	self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

end

function modifier_zuus_lightning_bolt_custom_aoe_thinker:OnDestroy()
if not IsServer() then return end

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),  self:GetParent():GetAbsOrigin(),  nil,  self:GetAbility().aoe_radius,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  0,  FIND_CLOSEST,  false )

for _,unit in pairs(units) do 
	self:GetAbility():CastLightningBolt(self:GetCaster(), unit, unit:GetAbsOrigin(), true, false, false, true)
end

if #units == 0 then 
	EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Zuus.LightningBolt", self:GetCaster())
end

end



modifier_zuus_lightning_bolt_custom_tracker = class({})
function modifier_zuus_lightning_bolt_custom_tracker:IsHidden() return true end
function modifier_zuus_lightning_bolt_custom_tracker:IsPurgable() return false end
function modifier_zuus_lightning_bolt_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end

function modifier_zuus_lightning_bolt_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if not params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end
if params.ability:GetCurrentCharges() > 0 then return end
if not self:GetParent():HasModifier("modifier_zuus_bolt_6") then return end



self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_zuus_lightning_bolt_custom_item_stack", {})

end


function modifier_zuus_lightning_bolt_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.inflictor then return end
if not self:GetParent():HasModifier("modifier_zuus_bolt_5") then return end
if params.inflictor ~= self:GetAbility() then return end

local heal = params.damage*self:GetAbility().near_heal
if params.unit:IsCreep() then 
	heal = self:GetAbility().near_creeps*heal
end



my_game:GenericHeal(self:GetCaster(), heal, self:GetAbility())


if (self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() > self:GetAbility().near_range then return end

self:GetParent():EmitSound("Zuus.Bolt_heal")

local effect_target = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/zeus_heal_bolt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
ParticleManager:ReleaseParticleIndex( effect_target )

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_movespeed", {movespeed = self:GetAbility().near_move, duration = self:GetAbility().near_duration, effect = "particles/zuus_speed.vpcf"})

end

modifier_zuus_lightning_bolt_custom_item_stack = class({})
function modifier_zuus_lightning_bolt_custom_item_stack:IsHidden() return false end
function modifier_zuus_lightning_bolt_custom_item_stack:IsPurgable() return false end
function modifier_zuus_lightning_bolt_custom_item_stack:RemoveOnDeath() return false end
function modifier_zuus_lightning_bolt_custom_item_stack:GetTexture() return "buffs/bolt_items" end
function modifier_zuus_lightning_bolt_custom_item_stack:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_zuus_lightning_bolt_custom_item_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().cd_max then 
	local units_heroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(),  self:GetParent():GetAbsOrigin(),  nil, self:GetAbility().cd_range,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,  FIND_CLOSEST,  false )
	local units_creeps = FindUnitsInRadius( self:GetParent():GetTeamNumber(),  self:GetParent():GetAbsOrigin(),  nil, self:GetAbility().cd_range,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,  FIND_CLOSEST,  false )
				
	local units = units_heroes

	if #units == 0 then 
		units = units_creeps
	end

	if #units > 0 then 
		local unit = units[1]
		self:GetAbility():CastLightningBolt(self:GetCaster(), unit, unit:GetAbsOrigin(), true, false, false, false)
	end

	self:Destroy()
end

end

function modifier_zuus_lightning_bolt_custom_item_stack:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_zuus_lightning_bolt_custom_item_stack:OnTooltip()
 return self:GetAbility().cd_max
end













zuus_stormkeeper_custom = class({})

function zuus_stormkeeper_custom:GetAOERadius()
return self:GetSpecialValueFor("aoe")
end

--function zuus_stormkeeper_custom:GetChannelTime()
--if not IsServer() then return end
--local mod = self:GetCaster():FindModifierByName("modifier_zuus_lightning_bolt_custom_legendary_stack")
--if mod then 
	--return self:GetSpecialValueFor("cast_delay")*mod:GetStackCount() + FrameTime()*3
--end
--return
--end




function zuus_stormkeeper_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("cast_range")
end


function zuus_stormkeeper_custom:OnSpellStart()
if not IsServer() then return end

local point = self:GetCursorPosition()

local mod_cast = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_zuus_lightning_bolt_custom_legendary", {x = point.x, y = point.y, z = point.z, stack = self:GetSpecialValueFor("strikes")})

end


function zuus_stormkeeper_custom:OnChannelFinish( bInterrupted )
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_zuus_lightning_bolt_custom_legendary")
end






modifier_zuus_lightning_bolt_custom_legendary = class({})
function modifier_zuus_lightning_bolt_custom_legendary:IsHidden() return false end
function modifier_zuus_lightning_bolt_custom_legendary:IsPurgable() return false end


function modifier_zuus_lightning_bolt_custom_legendary:OnDestroy()
if not IsServer() then return end
self:GetCaster():FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
self:GetCaster():RemoveModifierByName("modifier_zuus_lightning_bolt_custom_legendary_stack")
end

function modifier_zuus_lightning_bolt_custom_legendary:OnCreated(table)
if not IsServer() then return end
self:GetCaster():StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)

self:SetStackCount(table.stack)
self.target_point = Vector(table.x, table.y, table.z)


AddFOWViewer(self:GetParent():GetTeamNumber(), self.target_point, self:GetAbility():GetSpecialValueFor("aoe"), 3, false)

self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, self.target_point)
ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self:GetAbility():GetSpecialValueFor("aoe"), 0, 0))
self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("cast_delay"))
end







function modifier_zuus_lightning_bolt_custom_legendary:OnIntervalThink()
if not IsServer() then return end


local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),  self.target_point,  nil,  self:GetAbility():GetSpecialValueFor("aoe"),  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,  0,  FIND_CLOSEST,  false )

local target_point = self.target_point

if #units == 0 then 
	target_point = self.target_point + RandomVector(RandomInt(1, self:GetAbility():GetSpecialValueFor("aoe")))

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

	local n = RandomInt(1, 2)

	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack"..n, self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, target_point)

else 


	for _,unit in pairs(units) do 
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		local n = RandomInt(1, 2)
		ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack"..n, self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
		
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_zuus_lightning_bolt_custom_legendary_stack", {duration = self:GetAbility():GetSpecialValueFor("duration")})
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_zuus_lightning_bolt_custom_legendary_stack_count", {duration = self:GetAbility():GetSpecialValueFor("duration")})
		unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("stun") * (1 - unit:GetStatusResistance())})
		ApplyDamage({attacker = self:GetCaster(), ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL, damage = self:GetAbility():GetSpecialValueFor("damage"), victim = unit})
	


	end
end





EmitSoundOnLocationWithCaster(target_point, "Hero_Zuus.LightningBolt", self:GetParent())

self:DecrementStackCount()
if self:GetStackCount() == 0 then 
	self:Destroy()
end

end




modifier_zuus_lightning_bolt_custom_legendary_stack_count = class({})
function modifier_zuus_lightning_bolt_custom_legendary_stack_count:IsHidden() return false end
function modifier_zuus_lightning_bolt_custom_legendary_stack_count:IsPurgable() return false end
function modifier_zuus_lightning_bolt_custom_legendary_stack_count:OnCreated(table)
self.damage = self:GetAbility():GetSpecialValueFor("damage_inc")
if not IsServer() then return end
self.RemoveForDuel = true

local particle_cast = "particles/zuus_attack_stack.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )

self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)

end


function modifier_zuus_lightning_bolt_custom_legendary_stack_count:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end


function modifier_zuus_lightning_bolt_custom_legendary_stack_count:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end

if self.effect_cast then 
   ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end


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


modifier_zuus_lightning_bolt_custom_legendary_stack = class({})
function modifier_zuus_lightning_bolt_custom_legendary_stack:IsHidden() return true end
function modifier_zuus_lightning_bolt_custom_legendary_stack:IsPurgable() return false end
function modifier_zuus_lightning_bolt_custom_legendary_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_zuus_lightning_bolt_custom_legendary_stack:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
end

function modifier_zuus_lightning_bolt_custom_legendary_stack:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_zuus_lightning_bolt_custom_legendary_stack_count")

if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end




