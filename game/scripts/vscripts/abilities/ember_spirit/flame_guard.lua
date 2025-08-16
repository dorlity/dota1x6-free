LinkLuaModifier("modifier_ember_spirit_flame_guard_custom", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_flame_guard_custom_stack", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_flame_guard_custom_stun", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_flame_guard_tracker", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)

ember_spirit_flame_guard_custom = class({})




function ember_spirit_flame_guard_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0	
if self:GetCaster():HasTalent("modifier_ember_guard_3") then 
	upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_ember_guard_3", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown 
end

function ember_spirit_flame_guard_custom:CreateTalent()
local caster = self:GetCaster()

local mod = caster:FindModifierByName("modifier_ember_spirit_flame_guard_tracker")
if mod then
	mod.PercentStr = caster:GetTalentValue("modifier_ember_guard_1", "str")/100
end

end



function ember_spirit_flame_guard_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/omniknight/hammer_ti6_immortal/ember_shield_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context )
PrecacheResource( "particle", "particles/snapfire_scatter_stack.vpcf", context )
end



function ember_spirit_flame_guard_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_ember_spirit_flame_guard_tracker"
end


function ember_spirit_flame_guard_custom:GetCastRange(vLocation, hTarget)
local caster = self:GetCaster()
local radius = self:GetSpecialValueFor("radius")
if caster:HasTalent("modifier_ember_guard_6") then 
	radius = radius + caster:GetTalentValue("modifier_ember_guard_6", "radius")
end
return radius - caster:GetCastRangeBonus()
end



function ember_spirit_flame_guard_custom:OnSpellStart()
if not IsServer() then return end
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration")

local ability = caster:FindAbilityByName("ember_spirit_fire_remnant_custom")
if ability then 
	ability:AddStack()
end 
	
caster:EmitSound("Hero_EmberSpirit.FlameGuard.Cast")

if caster:FindModifierByName("modifier_ember_spirit_flame_guard_custom") then
	caster:FindModifierByName("modifier_ember_spirit_flame_guard_custom"):Destroy()
end
caster:AddNewModifier(caster, self, "modifier_ember_spirit_flame_guard_custom", {duration = duration})
end

modifier_ember_spirit_flame_guard_custom = class({})

function modifier_ember_spirit_flame_guard_custom:IsDebuff() return false end
function modifier_ember_spirit_flame_guard_custom:IsHidden() return false end
function modifier_ember_spirit_flame_guard_custom:IsPurgable() 
return not self:GetParent():HasTalent("modifier_ember_guard_legendary")
end



function modifier_ember_spirit_flame_guard_custom:OnCreated(keys)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.remaining_health = self.ability:GetSpecialValueFor("absorb_amount") + self.parent:GetTalentValue("modifier_ember_guard_1", "shield")*self.parent:GetMaxHealth()/100

self.interval = self.ability:GetSpecialValueFor("tick_interval")
self.active_radius = self.ability:GetSpecialValueFor("radius") + self.parent:GetTalentValue("modifier_ember_guard_6", "radius")
self.damage_active = self.ability:GetSpecialValueFor("damage_per_second") + self.parent:GetTalentValue("modifier_ember_guard_3", "damage")

self.stun = self.parent:GetTalentValue("modifier_ember_guard_6", "stun", true)
self.stun_timer = self.parent:GetTalentValue("modifier_ember_guard_6", "timer", true)

self.resist_duration = self.parent:GetTalentValue("modifier_ember_guard_4", "duration", true)

self.armor = self.parent:GetTalentValue("modifier_ember_guard_2", "armor")
self.status = self.parent:GetTalentValue("modifier_ember_guard_2", "status")

self.dispel_heal = self.parent:GetTalentValue("modifier_ember_guard_5", "heal", true)/100
self.regen = self.parent:GetTalentValue("modifier_ember_guard_5", "regen", true)

self.max_shield = self.remaining_health
if not IsServer() then return end

self.particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(self.particle_index, 0, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle_index, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(self.particle_index, 2, Vector(self.active_radius,0,0))
ParticleManager:SetParticleControl(self.particle_index, 3, Vector(140,0,0))
self:AddParticle(self.particle_index, false, false, -1, false, false ) 

self.ability:EndCd()
self.parent:AddDamageEvent_out(self)
self.stun_targets = {}

self.RemoveForDuel = true

self.block_amount = self.ability:GetSpecialValueFor("damage_block")/100

self.legendary_damage = 0

self.legendary_k = self.parent:GetTalentValue("modifier_ember_guard_legendary", "damage", true)/100
self.legendary_k_shield = self.parent:GetTalentValue("modifier_ember_guard_legendary", "shield", true)/100
self.legendary_creeps = self.parent:GetTalentValue("modifier_ember_guard_legendary", "creeps", true)
self.legendary_block = self.parent:GetTalentValue("modifier_ember_guard_legendary", "block", true)/100
self.max_time = self:GetRemainingTime()

self:SetStackCount(self.remaining_health)
self.parent:EmitSound("Hero_EmberSpirit.FlameGuard.Loop")

self:StartIntervalThink(self.interval)
end

function modifier_ember_spirit_flame_guard_custom:OnRefresh()
if not IsServer() then return end
self:OnCreated()
end


function modifier_ember_spirit_flame_guard_custom:OnIntervalThink()
if not IsServer() then return end

if self.parent:HasTalent("modifier_ember_guard_legendary") then
	self.parent:UpdateUIshort({time = self:GetRemainingTime(), max_time = self.max_time, stack = "+"..tostring(math.floor(self.legendary_damage)), style = "EmberGuard"})
end

local damage = (self.damage_active + self.legendary_damage)*self.interval

for _, enemy in pairs(self.parent:FindTargets(self.active_radius)) do

	if self.parent:HasTalent("modifier_ember_guard_4") then
		enemy:AddNewModifier(self.parent, self.ability, "modifier_ember_spirit_flame_guard_custom_stack", {duration = self.resist_duration})
	end

	if self.parent:HasTalent("modifier_ember_guard_6") and not self.stun_targets[enemy] then 

		local stun_mod = enemy:AddNewModifier(self.parent, self.ability, "modifier_ember_spirit_flame_guard_custom_stun", {duration = self.interval*2})
		if stun_mod and stun_mod:GetStackCount() >= self.stun_timer / self.interval then 
			stun_mod:Destroy()
			self.stun_targets[enemy] = true

			enemy:AddNewModifier(self.parent, self.ability, "modifier_stunned", {duration = self.stun*(1 - enemy:GetStatusResistance())})
			
			local particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:SetParticleControl(particle_index, 0, enemy:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle_index, 1, enemy:GetAbsOrigin())
			enemy:EmitSound("Hero_OgreMagi.Fireblast.Target")
		end 
	end 
	DoDamage({victim = enemy, attacker = self.parent, ability = self.ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end

end





function modifier_ember_spirit_flame_guard_custom:OnDestroy()
if not IsServer() then return end

self.parent:UpdateUIshort({hide = 1, hide_full = 1, style = "EmberGuard"})

self.ability:StartCd()

self.ability:SetActivated(true)
self.ability:UseResources(false, false, false, true)

self.parent:StopSound("Hero_EmberSpirit.FlameGuard.Loop")

if self.parent:HasTalent("modifier_ember_guard_5") and self.parent:IsAlive() then 

	self.parent:GenericHeal(self.parent:GetMaxHealth()*self.dispel_heal, self.ability, nil, nil, "modifier_ember_guard_5")
	self.parent:EmitSound("Ember.Guard_Lowhp")

	local effect_target = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/ember_shield_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
	ParticleManager:ReleaseParticleIndex( effect_target )

	self.parent:Purge(false, true, false, true, false)
end

end


function modifier_ember_spirit_flame_guard_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end


function modifier_ember_spirit_flame_guard_custom:GetModifierHealthRegenPercentage()
if not self.parent:HasTalent("modifier_ember_guard_5") then return end
return self.regen
end

function modifier_ember_spirit_flame_guard_custom:DamageEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_ember_guard_legendary") then return end 
if self.parent ~= params.attacker then return end 
if not params.unit:IsUnit() then return end
if params.unit:IsIllusion() then return end 

local k = self.legendary_k
local shield_k = self.legendary_k_shield

if params.unit:IsCreep() then 
	shield_k = shield_k/self.legendary_creeps
	k = k/self.legendary_creeps
end 

self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + shield_k*params.damage))

self.legendary_damage = self.legendary_damage + params.damage*k
end 


function modifier_ember_spirit_flame_guard_custom:GetModifierStatusResistanceStacking() 
if not self.parent:HasTalent("modifier_ember_guard_2") then return end
return self.status
end

function modifier_ember_spirit_flame_guard_custom:GetModifierPhysicalArmorBonus()
if not self.parent:HasTalent("modifier_ember_guard_2") then return end
return self.armor
end



function modifier_ember_spirit_flame_guard_custom:GetModifierIncomingSpellDamageConstant(params)
if self.parent:HasTalent("modifier_ember_guard_legendary") then return end

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
		return self:GetStackCount()
	end 
end

if self:GetStackCount() == 0 then return end
if not IsServer() then return end 

local damage = math.min(params.damage*self.block_amount, self:GetStackCount())

if self.parent:GetQuest() == "Ember.Quest_7" and params.attacker:IsRealHero() then 
	self.parent:UpdateQuest(damage)
end

self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end




function modifier_ember_spirit_flame_guard_custom:GetModifierIncomingDamageConstant(params)
if not self.parent:HasTalent("modifier_ember_guard_legendary") then return end

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
		return self:GetStackCount()
	end 
end

if self:GetStackCount() == 0 then return end
if not IsServer() then return end 

local damage = math.min(params.damage*self.legendary_block, self:GetStackCount())

if self.parent:GetQuest() == "Ember.Quest_7" and params.attacker:IsRealHero() then 
	self.parent:UpdateQuest(damage)
end

self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end







modifier_ember_spirit_flame_guard_tracker = class({})
function modifier_ember_spirit_flame_guard_tracker:IsHidden() return true end
function modifier_ember_spirit_flame_guard_tracker:IsPurgable() return false end
function modifier_ember_spirit_flame_guard_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

end









modifier_ember_spirit_flame_guard_custom_stack = class({})
function modifier_ember_spirit_flame_guard_custom_stack:IsHidden() return false end
function modifier_ember_spirit_flame_guard_custom_stack:IsPurgable() return false end
function modifier_ember_spirit_flame_guard_custom_stack:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.max = self.caster:GetTalentValue("modifier_ember_guard_4", "max", true)
self.resist = self.caster:GetTalentValue("modifier_ember_guard_4", "resist")/self.max
self.damage = self.caster:GetTalentValue("modifier_ember_guard_4", "damage")/self.max

if not IsServer() then return end
self:SetStackCount(0)

self.count = 0
self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
end

function modifier_ember_spirit_flame_guard_custom_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self.count = self.count + self.tick_interval

if self.count >= 1 then 
	self.count = 0
	self:IncrementStackCount()
end 

if self:GetStackCount() >= self.max then 
	self.parent:EmitSound("Hoodwink.Acorn_armor")
	self.parent:GenericParticle("particles/general/generic_armor_reduction.vpcf", self, true)
end

end


function modifier_ember_spirit_flame_guard_custom_stack:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
  MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_ember_spirit_flame_guard_custom_stack:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*self.damage
end


function modifier_ember_spirit_flame_guard_custom_stack:GetModifierDamageOutgoing_Percentage()
return self:GetStackCount()*self.damage
end


function modifier_ember_spirit_flame_guard_custom_stack:GetModifierMagicalResistanceBonus()
return self:GetStackCount()*self.resist
end





modifier_ember_spirit_flame_guard_custom_stun = class({})
function modifier_ember_spirit_flame_guard_custom_stun:IsHidden() return true end
function modifier_ember_spirit_flame_guard_custom_stun:IsPurgable() return false end
function modifier_ember_spirit_flame_guard_custom_stun:OnCreated(table)
if not IsServer() then return end
self.tick = self:GetAbility():GetSpecialValueFor("tick_interval")
self:SetStackCount(0)
end

function modifier_ember_spirit_flame_guard_custom_stun:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end




function modifier_ember_spirit_flame_guard_custom_stun:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_ember_spirit_sleight_of_fist_custom_legendary") then 

	if self.effect_cast then 
		ParticleManager:DestroyParticle(self.effect_cast, true)
		ParticleManager:ReleaseParticleIndex(self.effect_cast)
		self.effect_cast = nil
	end 

	return
end 

local stack = math.floor(self:GetStackCount()*self.tick)

if stack == 0 then return end

if not self.effect_cast then
	self.effect_cast = ParticleManager:CreateParticle( "particles/snapfire_scatter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	self:AddParticle(self.effect_cast,false, false, -1, false, false)
end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, stack, 0 ) )

end