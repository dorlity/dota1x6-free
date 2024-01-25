LinkLuaModifier("modifier_ember_spirit_flame_guard_custom", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_flame_guard_custom_stack", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_flame_guard_custom_stun", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)

ember_spirit_flame_guard_custom = class({})




function ember_spirit_flame_guard_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0	
if self:GetCaster():HasModifier("modifier_ember_guard_3") then 
	upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_ember_guard_3", "cd")
end


return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown 
end



function ember_spirit_flame_guard_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/omniknight/hammer_ti6_immortal/ember_shield_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", context )

end



function ember_spirit_flame_guard_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_ember_guard_6", "radius")
end



function ember_spirit_flame_guard_custom:OnSpellStart()
if not IsServer() then return end
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration")


local ability = caster:FindAbilityByName("ember_spirit_fire_remnant_custom")
if ability then 
	ability:AddStack()
end 

self:EndCooldown()
self:SetActivated(false)
	
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
return not self:GetParent():HasModifier("modifier_ember_guard_legendary")
end



function modifier_ember_spirit_flame_guard_custom:OnCreated(keys)

self.remaining_health = self:GetAbility():GetSpecialValueFor("absorb_amount") + self:GetCaster():GetTalentValue("modifier_ember_guard_1", "shield")*self:GetCaster():GetMaxHealth()/100

self.armor = self:GetCaster():GetTalentValue("modifier_ember_guard_2", "armor")
self.status = self:GetCaster():GetTalentValue("modifier_ember_guard_2", "status")

self.resist_duration = self:GetCaster():GetTalentValue("modifier_ember_guard_4", "duration")

self.dispel_heal = self:GetCaster():GetTalentValue("modifier_ember_guard_5", "heal", true)/100
self.regen = self:GetCaster():GetTalentValue("modifier_ember_guard_5", "regen", true)

self.stun = self:GetCaster():GetTalentValue("modifier_ember_guard_6", "stun", true)
self.stun_timer = self:GetCaster():GetTalentValue("modifier_ember_guard_6", "timer", true)

self.max_shield = self.remaining_health
if not IsServer() then return end

self.stun_targets = {}

self.RemoveForDuel = true

self.block_amount = self:GetAbility():GetSpecialValueFor("damage_block")/100

self.effect_radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_ember_guard_6", "radius")

self.particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle_index, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle_index, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(self.particle_index, 2, Vector(self.effect_radius,0,0))
ParticleManager:SetParticleControl(self.particle_index, 3, Vector(125,0,0))
self:AddParticle(self.particle_index, false, false, -1, false, false ) 


self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
self.damage = self:GetAbility():GetSpecialValueFor("damage_per_second") + self:GetCaster():GetTalentValue("modifier_ember_guard_3", "damage")
self.damage = self.damage*self.tick_interval

self.legendary_damage = 0

self.legendary_k = self:GetCaster():GetTalentValue("modifier_ember_guard_legendary", "damage")/100
self.legendary_k_shield = self:GetCaster():GetTalentValue("modifier_ember_guard_legendary", "shield")/100
self.legendary_creeps = self:GetCaster():GetTalentValue("modifier_ember_guard_legendary", "creeps")
self.legendary_block = self:GetCaster():GetTalentValue("modifier_ember_guard_legendary", "block")/100
self.max_time = self:GetRemainingTime()

if self:GetParent():HasModifier("modifier_ember_guard_legendary") then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'ember_shield_change',  {hide = 0, max_time = self.max_time, time = self:GetRemainingTime(), damage = self.legendary_damage})
end 

self:SetStackCount(self.remaining_health)
self:StartIntervalThink(self.tick_interval)
self:GetParent():EmitSound("Hero_EmberSpirit.FlameGuard.Loop")

end

function modifier_ember_spirit_flame_guard_custom:OnDestroy()
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_ember_guard_legendary") then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'ember_shield_change',  {hide = 1, max_time = self.max_time, time = self:GetRemainingTime(), damage = self.legendary_damage})
end

self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)

self:GetParent():StopSound("Hero_EmberSpirit.FlameGuard.Loop")

if self:GetParent():HasModifier("modifier_ember_guard_5") and self:GetParent():IsAlive() then 

	self:GetParent():GenericHeal(self:GetParent():GetMaxHealth()*self.dispel_heal, self:GetAbility())

	self:GetParent():EmitSound("Ember.Guard_Lowhp")

	local effect_target = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/ember_shield_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
	ParticleManager:ReleaseParticleIndex( effect_target )

	self:GetParent():Purge(false, true, false, true, false)
end


end



function modifier_ember_spirit_flame_guard_custom:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_ember_guard_legendary") then

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'ember_shield_change',  {hide = 0, max_time = self.max_time, time = self:GetRemainingTime(), damage = self.legendary_damage})
end

if self.remaining_health <= 0 or self:GetStackCount() <= 0 then
	self:Destroy()
else
	local nearby_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(nearby_enemies) do

		local damage = self.damage

		if self:GetParent():HasModifier("modifier_ember_guard_legendary") then 
			damage = damage + self.legendary_damage*self.tick_interval
		end

		if self:GetParent():HasModifier("modifier_ember_guard_4") then
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ember_spirit_flame_guard_custom_stack", {duration = self.resist_duration})
		end

		if self:GetParent():HasModifier("modifier_ember_guard_6") and not self.stun_targets[enemy] then 
			local mod = enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ember_spirit_flame_guard_custom_stun", {duration = self.tick_interval*2})
			if mod and mod:GetStackCount() >= self.stun_timer / self.tick_interval then 
				mod:Destroy()
				self.stun_targets[enemy] = true

				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.stun*(1 - enemy:GetStatusResistance())})
				
				local particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(particle_index, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_index, 1, enemy:GetAbsOrigin())
				enemy:EmitSound("Hero_OgreMagi.Fireblast.Target")
			end 

		end 

		ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
end

end

function modifier_ember_spirit_flame_guard_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MIN_HEALTH,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end



function modifier_ember_spirit_flame_guard_custom:GetModifierHealthRegenPercentage()
if not self:GetParent():HasModifier("modifier_ember_guard_5") then return end
return self.regen
end

function modifier_ember_spirit_flame_guard_custom:OnTakeDamage(params)
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_ember_guard_legendary") then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
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
if not self:GetParent():HasModifier("modifier_ember_guard_2") then return end
return self.status
end

function modifier_ember_spirit_flame_guard_custom:GetModifierPhysicalArmorBonus()
if not self:GetParent():HasModifier("modifier_ember_guard_2") then return end
return self.armor
end



function modifier_ember_spirit_flame_guard_custom:GetModifierIncomingSpellDamageConstant(params)
if self:GetParent():HasModifier("modifier_ember_guard_legendary") then return end

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
		return self:GetStackCount()
	end 
end


if self:GetStackCount() == 0 then return end

if not IsServer() then return end 

local block = self.block_amount

local blocked_damage = params.damage*block

if self:GetStackCount() > blocked_damage then
    self:SetStackCount(self:GetStackCount() - blocked_damage)

	if self:GetParent():GetQuest() == "Ember.Quest_7" and params.attacker:IsRealHero() then 
		self:GetParent():UpdateQuest(blocked_damage)
	end

    local i = blocked_damage
    return -i
else
    local i = self:GetStackCount()

    if self:GetParent():GetQuest() == "Ember.Quest_7" and params.attacker:IsRealHero() then 
		self:GetParent():UpdateQuest(i)
	end


    self:Destroy()
    return -i
end


end



function modifier_ember_spirit_flame_guard_custom:GetModifierIncomingDamageConstant(params)
if not self:GetParent():HasModifier("modifier_ember_guard_legendary") then return end

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
		return self:GetStackCount()
	end 
end

if self:GetStackCount() == 0 then return end
if not IsServer() then return end 

local block = self.legendary_block

local blocked_damage = params.damage*block

if self:GetStackCount() > blocked_damage then
    self:SetStackCount(self:GetStackCount() - blocked_damage)

	if self:GetParent():GetQuest() == "Ember.Quest_7" and params.attacker:IsRealHero() then 
		self:GetParent():UpdateQuest(blocked_damage)
	end

    local i = blocked_damage
    return -i
else
    local i = self:GetStackCount()

    if self:GetParent():GetQuest() == "Ember.Quest_7" and params.attacker:IsRealHero() then 
		self:GetParent():UpdateQuest(i)
	end


    self:Destroy()
    return -i
end



end






modifier_ember_spirit_flame_guard_custom_stack = class({})
function modifier_ember_spirit_flame_guard_custom_stack:IsHidden() return false end
function modifier_ember_spirit_flame_guard_custom_stack:IsPurgable() return false end
function modifier_ember_spirit_flame_guard_custom_stack:OnCreated(table)

self.resist = self:GetCaster():GetTalentValue("modifier_ember_guard_4", "resist")
self.damage = self:GetCaster():GetTalentValue("modifier_ember_guard_4", "damage")
self.max = self:GetCaster():GetTalentValue("modifier_ember_guard_4", "max")

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