LinkLuaModifier("modifier_ember_spirit_flame_guard_custom", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_flame_guard_custom_stack", "abilities/ember_spirit/flame_guard", LUA_MODIFIER_MOTION_NONE)

ember_spirit_flame_guard_custom = class({})

ember_spirit_flame_guard_custom.base_inc = {0.1, 0.15, 0.2}

ember_spirit_flame_guard_custom.armor_init = 3
ember_spirit_flame_guard_custom.armor_inc = 3
ember_spirit_flame_guard_custom.armor_status = {8, 12, 16}

ember_spirit_flame_guard_custom.damage_init = 10
ember_spirit_flame_guard_custom.damage_inc = 10

ember_spirit_flame_guard_custom.stack_interval = 1
ember_spirit_flame_guard_custom.stack_max = 8
ember_spirit_flame_guard_custom.stack_resist = {-4, -6}
ember_spirit_flame_guard_custom.stack_damage = {-2, -3}
ember_spirit_flame_guard_custom.stack_duration = 5


ember_spirit_flame_guard_custom.dispel_heal = 0.15

function ember_spirit_flame_guard_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0	
if self:GetCaster():HasModifier("modifier_ember_guard_6") then 
	upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_ember_guard_6", "cd")
end


return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown 
end



function ember_spirit_flame_guard_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/omniknight/hammer_ti6_immortal/ember_shield_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf", context )

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

self.remaining_health = self:GetAbility():GetSpecialValueFor("absorb_amount")

if self:GetParent():HasModifier("modifier_ember_guard_1") then 
	self.remaining_health = self.remaining_health + self:GetAbility().base_inc[self:GetParent():GetUpgradeStack("modifier_ember_guard_1")]*self:GetParent():GetMaxHealth()
end

self.max_shield = self.remaining_health


if not IsServer() then return end

self.RemoveForDuel = true

self.block_amount = self:GetAbility():GetSpecialValueFor("damage_block")/100

self.effect_radius = self:GetAbility():GetSpecialValueFor("radius")


self.particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle_index, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle_index, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(self.particle_index, 2, Vector(self.effect_radius,0,0))
ParticleManager:SetParticleControl(self.particle_index, 3, Vector(125,0,0))
self:AddParticle(self.particle_index, false, false, -1, false, false ) 



self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
self.damage = self:GetAbility():GetSpecialValueFor("damage_per_second") 


if self:GetParent():HasModifier("modifier_ember_guard_3") then 
	self.damage = self.damage + self:GetAbility().damage_init + self:GetAbility().damage_inc*self:GetParent():GetUpgradeStack("modifier_ember_guard_3")
end

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

	local heal = self:GetAbility().dispel_heal*self:GetParent():GetMaxHealth()
	my_game:GenericHeal(self:GetParent(), heal, self:GetAbility())

	self:GetParent():EmitSound("Ember.Guard_Lowhp")

	local effect_target = ParticleManager:CreateParticle( "particles/econ/items/omniknight/hammer_ti6_immortal/ember_shield_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_target, 1, Vector( 200, 100, 100 ) )
	ParticleManager:ReleaseParticleIndex( effect_target )

	self:GetParent():Purge(false, true, false, true, false)

end

if self:GetParent():HasModifier("modifier_ember_guard_6") and self:GetRemainingTime() > 0.1 then 

	local nearby_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(nearby_enemies) do
		enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self:GetCaster():GetTalentValue("modifier_ember_guard_6", "stun")*(1 - enemy:GetStatusResistance())})
		
		local particle_index = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
		ParticleManager:SetParticleControl(particle_index, 0, enemy:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle_index, 1, enemy:GetAbsOrigin())
		enemy:EmitSound("Hero_OgreMagi.Fireblast.Target")

	end

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
			enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ember_spirit_flame_guard_custom_stack", {duration = self:GetAbility().stack_duration})
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
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
    MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
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
return self:GetAbility().armor_status[self:GetCaster():GetUpgradeStack("modifier_ember_guard_2")]
end

function modifier_ember_spirit_flame_guard_custom:GetModifierPhysicalArmorBonus()
if not self:GetParent():HasModifier("modifier_ember_guard_2") then return end
return self:GetAbility().armor_init + self:GetAbility().armor_inc*self:GetParent():GetUpgradeStack("modifier_ember_guard_2")
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
if not IsServer() then return end
self:SetStackCount(0)

self.count = 0
self.tick_interval = self:GetAbility():GetSpecialValueFor("tick_interval")
end

function modifier_ember_spirit_flame_guard_custom_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().stack_max then return end

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
  MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end


function modifier_ember_spirit_flame_guard_custom_stack:GetModifierTotalDamageOutgoing_Percentage()
return self:GetStackCount()*self:GetAbility().stack_damage[self:GetCaster():GetUpgradeStack("modifier_ember_guard_4")]
end



function modifier_ember_spirit_flame_guard_custom_stack:GetModifierMagicalResistanceBonus()
return self:GetStackCount()*self:GetAbility().stack_resist[self:GetCaster():GetUpgradeStack("modifier_ember_guard_4")]
end




function modifier_ember_spirit_flame_guard_custom_stack:OnStackCountChanged(iStackCount)
if true then return end
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

	local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end



