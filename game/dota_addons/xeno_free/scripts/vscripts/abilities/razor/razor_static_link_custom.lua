LinkLuaModifier("modifier_razor_static_link_custom", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_target", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_caster", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_attacking", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_legendary", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_legendary_no_damage", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_legendary_swap", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_legendary_target", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_spell", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_slow", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_speed", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_heal", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_perma", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_static_link_custom_leash", "abilities/razor/razor_static_link_custom", LUA_MODIFIER_MOTION_NONE)

razor_static_link_custom = class({})

function razor_static_link_custom:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_razor_head_immortal_custom") then
        return "razor_static_link_alt"
    end
    if self:GetCaster():HasModifier("modifier_razor_head_immortal_custom_golden") then
        return "razor_static_link_alt_gold"
    end
    if self:GetCaster():HasModifier("modifier_razor_arcana_v2_custom") then
        return "razor/arcana/razor_static_link_alt2"
    end
    if self:GetCaster():HasModifier("modifier_razor_arcana_custom") then
        return "razor/arcana/razor_static_link_alt1"
    end
    return "razor_static_link"  
end

function razor_static_link_custom:Precache(context)
    PrecacheResource( "particle", "particles/razor/link_purge.vpcf", context )
    PrecacheResource( "particle", "particles/razor/static_link_beam_custombeam.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", context )
    PrecacheResource( "particle", "particles/razor/link_stun.vpcf", context )
end


function razor_static_link_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasModifier("modifier_razor_link_6") then 
	bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + bonus
end

function razor_static_link_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_razor_link_6") then
	bonus = self:GetCaster():GetTalentValue("modifier_razor_link_6", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end



function razor_static_link_custom:GetCastPoint(iLevel)
local bonus = 0

if self:GetCaster():HasShard() then 
    bonus = self:GetSpecialValueFor("shard_cast")
end

return self.BaseClass.GetCastPoint(self) + bonus
end



function razor_static_link_custom:GetManaCost(level)

if self:GetCaster():HasShard() then 
  return self:GetSpecialValueFor("shard_mana")
end

return self.BaseClass.GetManaCost(self,level) 
end





function razor_static_link_custom:GetCastRange(vLocation, hTarget)
local bonus = 0
if self:GetCaster():HasModifier("modifier_razor_link_2") then 
	bonus = self:GetCaster():GetTalentValue("modifier_razor_link_2", "range")
end

return self:GetSpecialValueFor("AbilityCastRange") + bonus
end

function razor_static_link_custom:OnSpellStart(new_target)

local target = self:GetCursorTarget()

if new_target then 
	target = new_target
end 



local mod = target:FindModifierByName("modifier_backdoor_knock_aura_damage")


if not self:GetCaster():HasModifier("modifier_razor_link_5") or (mod and mod.target and mod.target ~= self:GetCaster())  then 
	if target:TriggerSpellAbsorb(self) then return end
end 

local duration = self:GetSpecialValueFor("drain_length")

self:GetCaster():EmitSound("Ability.static.start")
local mod = self:GetCaster():FindModifierByName("modifier_razor_static_link_custom_perma")

if mod and self:GetCaster():HasModifier("modifier_razor_link_4") and mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_razor_link_4", "max") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_razor_link_4", "duration")
end 

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_razor_static_link_custom", {target = target:entindex(), duration = duration})




end 


modifier_razor_static_link_custom = class({})

function modifier_razor_static_link_custom:IsHidden() return true end
function modifier_razor_static_link_custom:IsPurgable() return false end 

function modifier_razor_static_link_custom:OnCreated(table)

self.status = self:GetCaster():GetTalentValue("modifier_razor_link_5", "status")

if not IsServer() then return end

self.target = EntIndexToHScript(table.target)

if not self.target or self.target:IsNull() then 
	self:Destroy()
	return
end 

self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.legendary = self.caster:FindAbilityByName("razor_static_link_custom_legendary")

if self.caster:HasModifier("modifier_razor_link_7") and self.legendary and self.legendary:IsHidden() then 
	self.caster:SwapAbilities(self.ability:GetName(), self.legendary:GetName(), false, true)
	self.legendary:StartCooldown(1)
end 


self.caster:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_attacking", {target = self.target:entindex()})


self.sound_ability = "Ability.static.loop"
if self:GetCaster():HasModifier("modifier_razor_head_immortal_custom") or self:GetCaster():HasModifier("modifier_razor_head_immortal_custom_golden") then
    self.sound_ability = "Hero_Razor.SeveringCrest.Loop"
end

self.caster:EmitSound(self.sound_ability)
self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

self.total_duration = self.ability:GetSpecialValueFor("drain_length")
self.total_damage = self.ability:GetSpecialValueFor("drain_rate") * self.total_duration

if self.target:IsCreep() then 
	self.total_damage = self.total_damage*(1 + self.ability:GetSpecialValueFor("creeps_damage")/100)
end 

local mod = self:GetCaster():FindModifierByName("modifier_razor_static_link_custom_perma")
if mod and self:GetCaster():HasModifier("modifier_razor_link_4") then 

	self.total_damage = self.total_damage + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_razor_link_4", "damage")

	if mod:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_razor_link_4", "max") then 
		self.total_duration = self.total_duration + self:GetCaster():GetTalentValue("modifier_razor_link_4", "duration")
	end 
end 

self.damage_rate = self.total_damage/self.total_duration

local bonus = 0
if self:GetCaster():HasModifier("modifier_razor_link_2") then 
	bonus = self:GetCaster():GetTalentValue("modifier_razor_link_2", "range")
end

self.sphere = nil

if self.caster:HasModifier("modifier_razor_link_5") then 
	self.sphere = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(self.sphere, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	self:AddParticle( self.sphere, false, false, -1, false, false )
end 

self.max_range = self.ability:GetSpecialValueFor("AbilityCastRange") + bonus +  self:GetCaster():GetCastRangeBonus() + self.ability:GetSpecialValueFor("drain_range_buffer")
self.duration = self.ability:GetSpecialValueFor("drain_duration")
self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")
self.target_damage = self.ability:GetSpecialValueFor("target_damage")/100
self.damage_count = 0 
self.spell_count = 0
self.spell_inc = 0
self.spell_init = 0

self.spell_duration = self:GetCaster():GetTalentValue("modifier_razor_link_1", "duration")

self.interval = 0.03

self.target:RemoveModifierByName("modifier_razor_static_link_custom_target")
self.caster:RemoveModifierByName("modifier_razor_static_link_custom_caster")
self.target:RemoveModifierByName("modifier_razor_static_link_custom_spell")
self.caster:RemoveModifierByName("modifier_razor_static_link_custom_spell")

self.target_mod = self.target:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_target", {})
self.caster_mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_caster", {})


if self.caster:HasModifier("modifier_razor_link_1") then 
	self.target_mod_spell = self.target:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_spell", {})
	self.caster_mod_spell = self.caster:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_spell", {})

	self.spell_init = self.caster:GetTalentValue("modifier_razor_link_1", "damage")

	self.spell_inc = (self.caster:GetTalentValue("modifier_razor_link_1", "damage")/self.total_duration)
end 

if self.caster:HasShard() then 
	self.leash_mod = self.target:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_leash", {duration = (1 - self.target:GetStatusResistance())*self.ability:GetSpecialValueFor("shard_leash")})
end 

self.speed_duration = self.caster:GetTalentValue("modifier_razor_link_2", "duration")
local speed_max = self:GetCaster():GetTalentValue("modifier_razor_link_2", "slow")
self.speed_inc = speed_max/self.total_duration
self.speed_count = 0

if self.caster:HasModifier("modifier_razor_link_2") then 
	self.target_mod_speed = self.target:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_slow", {})
end 

self.heal_duration = self.caster:GetTalentValue("modifier_razor_link_3", "duration")

if self.caster:HasModifier("modifier_razor_link_3") then 
	self.heal_mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_heal", {duration = 99999})
end


local particleFile = "particles/units/heroes/hero_razor/razor_static_link.vpcf"
if self:GetCaster():HasModifier("modifier_razor_head_immortal_custom") then
    particleFile = "particles/econ/items/razor/razor_punctured_crest/razor_static_link_blade.vpcf"
elseif self:GetCaster():HasModifier("modifier_razor_head_immortal_custom_golden") then
    particleFile = "particles/econ/items/razor/razor_punctured_crest_golden/razor_static_link_blade_golden.vpcf"
elseif self:GetCaster():HasModifier("modifier_razor_arcana_custom") then
    particleFile = "particles/econ/items/razor/razor_arcana/razor_arcana_static_link.vpcf"
elseif self:GetCaster():HasModifier("modifier_razor_arcana_v2_custom") then
    particleFile = "particles/econ/items/razor/razor_arcana/razor_arcana_static_link_v2.vpcf"
end


self.particle = ParticleManager:CreateParticle(particleFile, PATTACH_POINT_FOLLOW, self.caster)
ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_static", self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
self:AddParticle( self.particle, false, false, -1, false, false )


if self.caster:HasModifier("modifier_razor_link_6") and self:GetAbility():GetAutoCastState() == true then 
	local dir = ( self.caster:GetAbsOrigin() - self.target:GetAbsOrigin())

	local distance = math.min(self.caster:GetTalentValue("modifier_razor_link_6", "knock_distance_max"), dir:Length2D()*self.caster:GetTalentValue("modifier_razor_link_6", "knock_distance")/100)

	local point = self.target:GetAbsOrigin() + distance*dir:Normalized()
	local duration =  self.caster:GetTalentValue("modifier_razor_link_6", "knock_duration")

	local activity = ACT_DOTA_FLAIL


	self.target:EmitSound("Razor.Link_pull")
	local knockbackProperties =
	{

      target_x = point.x,
      target_y = point.y,
      distance = distance,
      speed = distance/duration,
      height = 0,
      fix_end = true,
      isStun = false,
      activity = activity,

	}
	self.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_generic_arc", knockbackProperties )
end 



self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_razor_static_link_custom:OnIntervalThink()
if not IsServer() then return end

if not self.target or self.target:IsNull() or not self.target:IsAlive() or 
	(self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() > self.max_range then 

	self:Destroy()
	return
end 

AddFOWViewer(self.caster:GetTeamNumber(), self.target:GetAbsOrigin(), self.vision_radius, self.interval*2, true)

self.damage_count = self.damage_count + self.damage_rate*self.interval
self.spell_count = self.spell_count + self.spell_inc*self.interval
self.speed_count = self.speed_count + self.speed_inc*self.interval

if self.target_mod and not self.target_mod:IsNull() then 
	self.target_mod:SetStackCount(self.damage_count*self.target_damage)
end 

if self.caster_mod and not self.caster_mod:IsNull() then 
	self.caster_mod:SetStackCount(self.damage_count)
end 

if self.target_mod_speed and not self.target_mod_speed:IsNull() then 
	self.target_mod_speed:SetStackCount(self.speed_count)
end 

if self.target_mod_spell and not self.target_mod_spell:IsNull() then 
	self.target_mod_spell:SetStackCount(self.spell_init + self.spell_count)
end 

if self.caster_mod_spell and not self.caster_mod_spell:IsNull() then 
	self.caster_mod_spell:SetStackCount(self.spell_init + self.spell_count)
end 

end 


function modifier_razor_static_link_custom:OnDestroy()

if self.target_mod and not self.target_mod:IsNull() then 
	self.target_mod:SetDuration(self.duration, true)
end 

if self.caster_mod and not self.caster_mod:IsNull() then 
	self.caster_mod:SetDuration(self.duration, true)
end 


if self.target_mod_spell and not self.target_mod_spell:IsNull() then 
	self.target_mod_spell:SetDuration(self.spell_duration, true)
end 

if self.caster_mod_spell and not self.caster_mod_spell:IsNull() then 
	self.caster_mod_spell:SetDuration(self.spell_duration, true)
end 

if self.target_mod_speed and not self.target_mod_speed:IsNull() then 
	self.target_mod_speed:SetDuration(self.speed_duration, true)
end 

if self.caster_mod_speed and not self.caster_mod_speed:IsNull() then 
	self.caster_mod_speed:SetDuration(self.speed_duration, true)
end 

if self.leash_mod and not self.leash_mod:IsNull() then 
	self.leash_mod:Destroy()
end 

if self.heal_mod and not self.heal_mod:IsNull() then
	if (self:GetRemainingTime() <= 0.1 or not self.target or self.target:IsNull() or not self.target:IsAlive()) then 
		self.heal_mod:SetDuration(self.heal_duration, true)
	else
		self.heal_mod:Destroy()
	end 
end

if not IsServer() then return end

if (self:GetRemainingTime() <= 0.1 or not self.target or self.target:IsNull() or not self.target:IsAlive()) then 

	if self.caster:GetQuest() == "Razor.Quest_6" and self.target:IsRealHero() then 
		self.caster:UpdateQuest(1)
	end 

	if self.target and not self.target:IsNull() and self.target:IsRealHero() then 
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_perma", {}) 
	end 

end 


if self:GetCaster():HasModifier("modifier_razor_link_6") and self.target and not self.target:IsNull() and self.target:IsAlive() then 

	local dir = ( self.caster:GetAbsOrigin() - self.target:GetAbsOrigin())

	local distance = math.min(self.caster:GetTalentValue("modifier_razor_link_6", "knock_distance_max"), dir:Length2D()*self.caster:GetTalentValue("modifier_razor_link_6", "knock_distance")/100)

	local point = self.target:GetAbsOrigin() + distance*dir:Normalized()
	local duration =  self.caster:GetTalentValue("modifier_razor_link_6", "knock_duration")

	local activity = ACT_DOTA_FLAIL

	if self:GetRemainingTime() <= 0.1 then


		local effect_cast = ParticleManager:CreateParticle( "particles/razor/link_stun.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target )
		ParticleManager:SetParticleControl( effect_cast, 0,  self.target:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, self.target:GetOrigin() )
		ParticleManager:ReleaseParticleIndex(effect_cast)

		self.target:EmitSound("BS.Rupture_fear")
		self.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_nevermore_requiem_fear", {duration  = self.caster:GetTalentValue("modifier_razor_link_6", "stun") * (1 - self.target:GetStatusResistance())})

	end 

	self.target:EmitSound("Razor.Link_pull")
	local knockbackProperties =
	{

      target_x = point.x,
      target_y = point.y,
      distance = distance,
      speed = distance/duration,
      height = 0,
      fix_end = true,
      isStun = false,
      activity = activity,

	}

	if self:GetAbility():GetAutoCastState() == true then 
		self.target:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_generic_arc", knockbackProperties )
	end


end 


self:GetParent():RemoveModifierByName("modifier_razor_static_link_custom_attacking")

self:GetParent():StopSound(self.sound_ability)
self:GetParent():EmitSound("Ability.static.end")

if self:GetParent():HasModifier("modifier_razor_link_7")then 
	local mod = self:GetParent():AddNewModifier(self:GetParent(), self.ability, "modifier_razor_static_link_custom_legendary_swap", {duration = self:GetCaster():GetTalentValue("modifier_razor_link_7", "swap")})

	if not mod then 

		self.legendary = self:GetParent():FindAbilityByName("razor_static_link_custom_legendary")

		if self:GetParent():HasModifier("modifier_razor_link_7") and self.legendary and self.ability:IsHidden() then 
			self:GetParent():SwapAbilities(self.ability:GetName(), self.legendary:GetName(), true, false)
		end 
	end 

end 


end 

function modifier_razor_static_link_custom:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
  	MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	MODIFIER_PROPERTY_ABSORB_SPELL,
	MODIFIER_EVENT_ON_ORDER
}

end

function modifier_razor_static_link_custom:GetModifierStatusResistanceStacking() 
if not self:GetParent():HasModifier("modifier_razor_link_5") then return end 

return self.status
end



function modifier_razor_static_link_custom:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if self.sphere == nil then return end


local particle = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

if self.sphere then 
	ParticleManager:DestroyParticle(self.sphere, false)
	ParticleManager:ReleaseParticleIndex(self.sphere)
	self.sphere = nil
end


return 1 
end



function modifier_razor_static_link_custom:GetOverrideAnimation()
return ACT_DOTA_OVERRIDE_ABILITY_2
end



function modifier_razor_static_link_custom:OnOrder( params )
if params.unit~=self.caster then return end


if 	params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET  then

	if params.target ~= self.target then 
		self.caster:RemoveModifierByName("modifier_razor_static_link_custom_attacking")
	end

	if params.target == self.target then 
		self.caster:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_attacking", {target = self.target:entindex()})
	end 
end 

if params.order_type == DOTA_UNIT_ORDER_STOP or params.order_type == DOTA_UNIT_ORDER_HOLD_POSITION   then 
	--self.caster:RemoveModifierByName("modifier_razor_static_link_custom_attacking")
end 

end



modifier_razor_static_link_custom_attacking = class({})
function modifier_razor_static_link_custom_attacking:IsHidden() return true end
function modifier_razor_static_link_custom_attacking:IsPurgable() return false end 
function modifier_razor_static_link_custom_attacking:OnCreated(table)
if not IsServer() then return end

self.target = EntIndexToHScript(table.target)

if not self.target or self.target:IsNull() then 
	self:Destroy()
	return
end 


self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.attack_count = 0
self.attack_max = 1/self.caster:GetAttacksPerSecond(true)

self.interval = 0.03
self:OnIntervalThink()
self:StartIntervalThink(self.interval)

end 

function modifier_razor_static_link_custom_attacking:OnIntervalThink()
if not IsServer() then return end 

if not self.target or self.target:IsNull() or not self.target:IsAlive()  then 

	self:Destroy()
	return
end 

self.attack_count = self.attack_count + self.interval
self.attack_max = 1/self.caster:GetAttacksPerSecond(true)


local dir = (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin())

if self.attack_count >= self.attack_max --and dir:Length2D() <= self.caster:Script_GetAttackRange()
 and not self.caster:IsStunned() and not self.caster:IsHexed() and not my_game:CheckDisarm(self.caster) and not self.caster:IsChanneling() then 

	self.attack_count = 0

	self.caster:FadeGesture(ACT_DOTA_ATTACK)
	self.caster:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, self.caster:GetDisplayAttackSpeed() / 100)
	self.caster:PerformAttack(self.target, true, true, true, false, true, false, false)
end 

dir.z = 0

if not self.caster:IsCurrentlyHorizontalMotionControlled() and not self.caster:IsCurrentlyVerticalMotionControlled() then
	self.caster:SetForwardVector(dir:Normalized())
	self.caster:FaceTowards(self.target:GetAbsOrigin())

end 

end 

function modifier_razor_static_link_custom_attacking:DeclareFunctions()
	local funcs = {
    	MODIFIER_PROPERTY_DISABLE_TURNING,
	}

	return funcs
end

function modifier_razor_static_link_custom_attacking:GetModifierDisableTurning()
	return 1
end


function modifier_razor_static_link_custom_attacking:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end




modifier_razor_static_link_custom_caster = class({})
function modifier_razor_static_link_custom_caster:IsHidden() return false end 
function modifier_razor_static_link_custom_caster:IsPurgable() return false end
function modifier_razor_static_link_custom_caster:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_razor_static_link_custom_caster:OnCreated()
if not IsServer() then return end
self.RemoveForDuel = true
local particle_name = "particles/units/heroes/hero_razor/razor_static_link_buff.vpcf"
if self:GetCaster():HasModifier("modifier_razor_arcana_custom") then
    particle_name = "particles/econ/items/razor/razor_arcana/razor_arcana_static_link_buff.vpcf"
elseif self:GetCaster():HasModifier("modifier_razor_arcana_v2_custom") then
    particle_name = "particles/econ/items/razor/razor_arcana/razor_arcana_static_link_buff_v2.vpcf"
end
self.particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle( self.particle, false, false, -1, false, false )
end 


function modifier_razor_static_link_custom_caster:OnStackCountChanged(iStackCount)
if not IsServer() then return end 
if not self.particle then return end 

ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetStackCount(), 0, 0))
end 

function modifier_razor_static_link_custom_caster:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end 


function modifier_razor_static_link_custom_caster:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()
end


modifier_razor_static_link_custom_target = class({})
function modifier_razor_static_link_custom_target:IsHidden() return false end 
function modifier_razor_static_link_custom_target:IsPurgable() return false end
function modifier_razor_static_link_custom_target:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_razor_static_link_custom_target:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true
local particle_name = "particles/units/heroes/hero_razor/razor_static_link_debuff.vpcf"
if self:GetCaster():HasModifier("modifier_razor_arcana_custom") then
    particle_name = "particles/econ/items/razor/razor_arcana/razor_arcana_static_link_debuff.vpcf"
elseif self:GetCaster():HasModifier("modifier_razor_arcana_v2_custom") then
    particle_name = "particles/econ/items/razor/razor_arcana/razor_arcana_static_link_debuff_v2.vpcf"
end
self.particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle( self.particle, false, false, -1, false, false )
end 


function modifier_razor_static_link_custom_target:OnStackCountChanged(iStackCount)
if not IsServer() then return end 
if not self.particle then return end 

ParticleManager:SetParticleControl(self.particle, 1, Vector(self:GetStackCount(), 0, 0))
end 

function modifier_razor_static_link_custom_target:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end 


function modifier_razor_static_link_custom_target:GetModifierPreAttack_BonusDamage()
return self:GetStackCount()*-1
end




modifier_razor_static_link_custom_legendary = class({})

function modifier_razor_static_link_custom_legendary:IsHidden() return true end
function modifier_razor_static_link_custom_legendary:IsPurgable() return false end 
function modifier_razor_static_link_custom_legendary:IsDebuff() return false end

function modifier_razor_static_link_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.target = EntIndexToHScript(table.target)

if not self.target or self.target:IsNull() then 
	self:Destroy()
	return
end 

self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.legendary = self:GetCaster():FindAbilityByName("razor_static_link_custom_legendary")


self.caster:EmitSound("Razor.Link_legendary_loop1")
self.caster:EmitSound("Razor.Link_legendary_loop2")
self.caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

self.radius = self:GetCaster():GetTalentValue("modifier_razor_link_7", "radius")
self.max_range = self.ability:GetSpecialValueFor("AbilityCastRange") +  self:GetCaster():GetCastRangeBonus() + self.ability:GetSpecialValueFor("drain_range_buffer")
self.duration = self.ability:GetSpecialValueFor("drain_duration")
self.damage_rate = self.ability:GetSpecialValueFor("drain_rate")
self.vision_radius = self.ability:GetSpecialValueFor("vision_radius")

self.target_mod = self.target:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_legendary_target", {})

local particleFile = "particles/razor/static_link_beam_custombeam.vpcf"
self.particle = ParticleManager:CreateParticle(particleFile, PATTACH_POINT_FOLLOW, self.target)
ParticleManager:SetParticleControlEnt(self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_static", self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
self:AddParticle( self.particle, false, false, -1, false, false )

self.damage = self:GetCaster():GetTalentValue("modifier_razor_link_7","damage")/100
self.interval = 1/(self:GetCaster():GetTalentValue("modifier_razor_link_7", "damage_self")/self:GetCaster():GetTalentValue("modifier_razor_link_7", "duration"))

self.damage_interval = 0.2
self.damage_count = self.damage_interval

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_razor_static_link_custom_legendary:OnIntervalThink()
if not IsServer() then return end

self:IncrementStackCount()

if not self.target or self.target:IsNull() or not self.target:IsAlive() or 
	(self.target:GetAbsOrigin() - self.caster:GetAbsOrigin()):Length2D() > self.max_range then 

	self:Destroy()
	return
end 

AddFOWViewer(self.caster:GetTeamNumber(), self.target:GetAbsOrigin(), self.vision_radius, self.interval*2, true)


local dir = (self.target:GetAbsOrigin() - self.caster:GetAbsOrigin())
dir.z = 0

if not self.caster:IsCurrentlyHorizontalMotionControlled() and not self.caster:IsCurrentlyVerticalMotionControlled() then
	self.caster:SetForwardVector(dir:Normalized())
	self.caster:FaceTowards(self.target:GetAbsOrigin())
end 
self.damage_count = self.damage_count + self.interval

if self.damage_count < self.damage_interval then return end 

self.damage_count = 0

local damage = self.caster:GetAverageTrueAttackDamage(nil)*self.damage*self.damage_interval

ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.target ) )
self.target:EmitSound("Razor.Link_legendary_target")

local targets = self.caster:FindTargets(self.radius, self.target:GetAbsOrigin())

for _,target in pairs(targets) do 
	ApplyDamage({victim = target, attacker = self.caster, damage = damage, ability = self.legendary, damage_type = DAMAGE_TYPE_MAGICAL})
end

end 






function modifier_razor_static_link_custom_legendary:OnDestroy()
if not IsServer() then return end 

if self.target_mod and not self.target_mod:IsNull() then 
	self.target_mod:Destroy()
end 

self.caster:RemoveModifierByName("modifier_razor_static_link_custom_attacking")

self.caster:StopSound("Razor.Link_legendary_loop1")
self.caster:StopSound("Razor.Link_legendary_loop2")
self.caster:EmitSound("Ability.static.end")

local stack = self:GetStackCount()
if self:GetRemainingTime() < 0.1 then 
	stack = 100
end 

self.caster:AddNewModifier(self.caster, self.ability, "modifier_razor_static_link_custom_legendary_no_damage", {duration = self:GetCaster():GetTalentValue("modifier_razor_link_7", "lose_duration"), stack = stack})
end 

function modifier_razor_static_link_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_DISABLE_TURNING,
}

end

function modifier_razor_static_link_custom_legendary:GetModifierDamageOutgoing_Percentage()
if not IsClient() then return end
return self:GetStackCount()*-1
end

function modifier_razor_static_link_custom_legendary:GetOverrideAnimation()
return ACT_DOTA_OVERRIDE_ABILITY_2
end


function modifier_razor_static_link_custom_legendary:GetModifierDisableTurning()
	return 1
end


function modifier_razor_static_link_custom_legendary:CheckState()
return
{
	[MODIFIER_STATE_DISARMED] = true
}
end





modifier_razor_static_link_custom_legendary_no_damage = class({})
function modifier_razor_static_link_custom_legendary_no_damage:IsDebuff() return true end
function modifier_razor_static_link_custom_legendary_no_damage:IsPurgable() return false end
function modifier_razor_static_link_custom_legendary_no_damage:IsHidden() return false end
function modifier_razor_static_link_custom_legendary_no_damage:OnCreated(table)
if not IsServer() then return end 


self.particle = ParticleManager:CreateParticle("particles/econ/items/razor/razor_arcana/razor_arcana_static_link_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle( self.particle, false, false, -1, false, false )
ParticleManager:SetParticleControl(self.particle, 1, Vector(200, 0, 0))

self:SetStackCount(table.stack)
end

function modifier_razor_static_link_custom_legendary_no_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
}

end

function modifier_razor_static_link_custom_legendary_no_damage:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount()*-1
end



razor_static_link_custom_legendary = class({})

function razor_static_link_custom_legendary:GetBehavior()
local bonus = 0
if self:GetCaster():HasModifier("modifier_razor_static_link_custom") then
	bonus = DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + bonus
end



function razor_static_link_custom_legendary:OnSpellStart()

self.ability = self:GetCaster():FindAbilityByName("razor_static_link_custom")

self:GetCaster():RemoveModifierByName("modifier_razor_static_link_custom")

self.caster = self:GetCaster()

self.legendary = self.caster:FindAbilityByName("razor_static_link_custom_legendary")

if self.caster:HasModifier("modifier_razor_link_7") and self.legendary and self.ability:IsHidden() then 
	self.caster:SwapAbilities(self.ability:GetName(), self.legendary:GetName(), true, false)
end 

self:GetCaster():RemoveModifierByName("modifier_razor_static_link_custom_legendary_swap")

if not self.ability then return end

local target = self:GetCursorTarget()

self:GetCaster():EmitSound("Razor.Link_legendary_start1")
self:GetCaster():EmitSound("Razor.Link_legendary_start2")

self:GetCaster():AddNewModifier(self:GetCaster(), self.ability, "modifier_razor_static_link_custom_legendary", {target = target:entindex(), duration = self:GetCaster():GetTalentValue("modifier_razor_link_7", "duration")})
end 





modifier_razor_static_link_custom_legendary_swap = class({})
function modifier_razor_static_link_custom_legendary_swap:IsHidden() return true end
function modifier_razor_static_link_custom_legendary_swap:IsPurgable() return false end
function modifier_razor_static_link_custom_legendary_swap:OnCreated()

self.ability = self:GetAbility()

end 


function modifier_razor_static_link_custom_legendary_swap:OnDestroy()
if not IsServer() then return end 

self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.legendary = self.caster:FindAbilityByName("razor_static_link_custom_legendary")

if self.caster:HasModifier("modifier_razor_link_7") and self.legendary and self.ability:IsHidden() then 
	self.caster:SwapAbilities(self.ability:GetName(), self.legendary:GetName(), true, false)
end 

end 






modifier_razor_static_link_custom_legendary_target = class({})
function modifier_razor_static_link_custom_legendary_target:IsHidden() return true end
function modifier_razor_static_link_custom_legendary_target:IsPurgable() return false end
function modifier_razor_static_link_custom_legendary_target:GetEffectName()
    return "particles/razor/link_purge.vpcf"
end 

function modifier_razor_static_link_custom_legendary_target:GetStatusEffectName()
    return "particles/status_fx/status_effect_nullifier.vpcf"
end 

function modifier_razor_static_link_custom_legendary_target:StatusEffectPriority()
    return 9999999
end 

function modifier_razor_static_link_custom_legendary_target:OnCreated()
if not IsServer() then return end 

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 

function modifier_razor_static_link_custom_legendary_target:OnIntervalThink()
if not IsServer() then return end 
if self:GetParent():IsDebuffImmune() then return end

self:GetParent():Purge(true, false, false, false,false)
end 




modifier_razor_static_link_custom_spell = class({})
function modifier_razor_static_link_custom_spell:IsHidden() return false end
function modifier_razor_static_link_custom_spell:IsPurgable() return false end
function modifier_razor_static_link_custom_spell:GetTexture() return "buffs/link_spell" end
function modifier_razor_static_link_custom_spell:OnCreated()

self.k = 1
if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
	self.k = self.k*-1
end 

end 

function modifier_razor_static_link_custom_spell:DeclareFunctions()
return
{

  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end


function modifier_razor_static_link_custom_spell:GetModifierSpellAmplify_Percentage() 
return self.k*self:GetStackCount()
end



modifier_razor_static_link_custom_slow = class({})

function modifier_razor_static_link_custom_slow:IsHidden() return true end
function modifier_razor_static_link_custom_slow:IsPurgable() return false end
function modifier_razor_static_link_custom_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end


function modifier_razor_static_link_custom_slow:OnCreated()
end 

function modifier_razor_static_link_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_razor_static_link_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*-1
end



modifier_razor_static_link_custom_speed = class({})

function modifier_razor_static_link_custom_speed:IsHidden() return true end
function modifier_razor_static_link_custom_speed:IsPurgable() return false end
function modifier_razor_static_link_custom_speed:GetEffectName()
	return "particles/zuus_speed.vpcf"
end


function modifier_razor_static_link_custom_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_razor_link_2", "speed")
end 

function modifier_razor_static_link_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_razor_static_link_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end





modifier_razor_static_link_custom_heal = class({})
function modifier_razor_static_link_custom_heal:IsHidden() return false end
function modifier_razor_static_link_custom_heal:IsPurgable() return false end
function modifier_razor_static_link_custom_heal:GetTexture() return "buffs/link_heal" end
function modifier_razor_static_link_custom_heal:OnCreated()

self.heal = self:GetCaster():GetTalentValue("modifier_razor_link_3", "heal")/100
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_razor_link_3", "creeps")
end 

function modifier_razor_static_link_custom_heal:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_razor_static_link_custom_heal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal
if params.unit:IsCreep() then 
  heal = heal / self.heal_creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end

modifier_razor_static_link_custom_perma = class({})
function modifier_razor_static_link_custom_perma:IsHidden() return not self:GetParent():HasModifier("modifier_razor_link_4") end
function modifier_razor_static_link_custom_perma:IsPurgable() return false end
function modifier_razor_static_link_custom_perma:RemoveOnDeath() return false end
function modifier_razor_static_link_custom_perma:GetTexture() return "buffs/link_damage" end
function modifier_razor_static_link_custom_perma:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_razor_link_4", "max", true)

if not IsServer() then return end 
self.caster = self:GetParent()
self:SetStackCount(1)
self:Effect()
end 

function modifier_razor_static_link_custom_perma:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
self:Effect()
end 



function modifier_razor_static_link_custom_perma:Effect()
if not IsServer() then return end
if self.caster:HasModifier("modifier_razor_link_4") then 

	self.caster:EmitSound("BS.Thirst_legendary_active")
	local particle_peffect = ParticleManager:CreateParticle("particles/rare_orb_patrol.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
	ParticleManager:SetParticleControl(particle_peffect, 0, self.caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self.caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)

end


end 







function modifier_razor_static_link_custom_perma:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_razor_static_link_custom_perma:OnTooltip()
if not self:GetCaster():HasModifier("modifier_razor_link_4") then return end
return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_razor_link_4", "damage")
end


modifier_razor_static_link_custom_leash = class({})
function modifier_razor_static_link_custom_leash:IsHidden() return true end
function modifier_razor_static_link_custom_leash:IsPurgable() return false end
function modifier_razor_static_link_custom_leash:OnCreated()
if not IsServer() then return end 

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end 


function modifier_razor_static_link_custom_leash:OnIntervalThink()
if not IsServer() then return end 
if not self:GetParent():IsDebuffImmune() then return end

self:Destroy()
end 

function modifier_razor_static_link_custom_leash:CheckState()
return
{
	[MODIFIER_STATE_TETHERED] = true
}
end 