LinkLuaModifier("modifier_custom_terrorblade_sunder_legendary", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_incoming", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_tracker", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_stats", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_stats_self", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_lifesteal", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_rooted", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_damage", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_slow", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_sunder_cd", "abilities/terrorblade/custom_terrorblade_sunder", LUA_MODIFIER_MOTION_NONE)

custom_terrorblade_sunder = class({})

custom_terrorblade_sunder.lifesteal_inc = {0.3, 0.4, 0.5}
custom_terrorblade_sunder.lifesteal_duration = 5

custom_terrorblade_sunder.cd_inc = {-6, -10, -14}

custom_terrorblade_sunder.stun_range = 250
custom_terrorblade_sunder.stun_stun = 2.5 	

custom_terrorblade_sunder.legendary_interval = 1
custom_terrorblade_sunder.legendary_heal = 0.20
custom_terrorblade_sunder.legendary_duration = 3.1
custom_terrorblade_sunder.legendary_cd = 25


custom_terrorblade_sunder.damage_duration = 4
custom_terrorblade_sunder.damage_total = {0.1, 0.15, 0.2}
custom_terrorblade_sunder.damage_interval = 1




function custom_terrorblade_sunder:GetManaCost(level)


if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then 
	return 0
end

return self.BaseClass.GetManaCost(self,level)
end




function custom_terrorblade_sunder:GetCastPoint()
if self:GetCaster():HasModifier("modifier_terror_sunder_heal") then 
    return self.BaseClass.GetCastPoint(self) + self:GetCaster():GetTalentValue("modifier_terror_sunder_heal", "cast")
else 
    return self.BaseClass.GetCastPoint(self)
end

end


function custom_terrorblade_sunder:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/spring_2021/blink_dagger_spring_2021_start_lvl2.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/spring_2021/blink_dagger_spring_2021_end.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/gleipnir_root.vpcf", context )

end



function custom_terrorblade_sunder:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_custom_terrorblade_sunder_tracker"
end


function custom_terrorblade_sunder:GetCastRange(vLocation, hTarget)
local upgrade = self.stun_range*self:GetCaster():GetUpgradeStack("modifier_terror_sunder_swap")
 return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function custom_terrorblade_sunder:GetCooldown(iLevel)

local bonus = 0

if self:GetCaster():HasModifier("modifier_terror_sunder_amplify") then
	bonus = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_terror_sunder_amplify")]
end

return self.BaseClass.GetCooldown(self, iLevel) + bonus
end




function custom_terrorblade_sunder:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_terror_sunder_swap") then 
  return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
  return DOTA_UNIT_TARGET_FLAG_NONE
end

end




function custom_terrorblade_sunder:GetBehavior()

if self:GetCaster():HasModifier("modifier_terror_sunder_stats") then 
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK
end



function custom_terrorblade_sunder:CastFilterResultTarget(target)
	if target == self:GetCaster() then
		return UF_FAIL_CUSTOM
	end

	if target ~= nil and target:HasModifier("modifier_generic_debuff_immune") and not self:GetCaster():HasModifier("modifier_terror_sunder_swap") then
		return UF_FAIL_MAGIC_IMMUNE_ENEMY
	end

	if self:GetCaster():HasModifier("modifier_terror_sunder_legendary") then 
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, self:GetCaster():GetTeamNumber())
	else
		return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP, self:GetCaster():GetTeamNumber())
	end
end

function custom_terrorblade_sunder:GetCustomCastErrorTarget(target)
	if target == self:GetCaster() then
		return "#dota_hud_error_cant_cast_on_self"
	end
end

function custom_terrorblade_sunder:PlayEffect(target)
if not IsServer() then return end
self:GetCaster():EmitSound("Hero_Terrorblade.Sunder.Cast")
target:EmitSound("Hero_Terrorblade.Sunder.Target")


local effect_name = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"

if self:GetCaster() ~= nil and self:GetCaster():IsHero() then
local children = self:GetCaster():GetChildren()
	for k,child in pairs(children) do

	    if child:GetClassname() == "dota_item_wearable" then
	        if child:GetModelName() == "models/items/terrorblade/terrorblade_ti8_immortal_back/terrorblade_ti8_immortal_back.vmdl" then
	            effect_name = "particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8.vpcf"
	            break
	        end
	    end
	end
end 


local sunder_particle_1 = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(sunder_particle_1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(sunder_particle_1, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(sunder_particle_1, 2, target:GetAbsOrigin())
ParticleManager:SetParticleControl(sunder_particle_1, 15, Vector(0,152,255))
ParticleManager:SetParticleControl(sunder_particle_1, 16, Vector(1,0,0))
ParticleManager:ReleaseParticleIndex(sunder_particle_1)

local sunder_particle_2 = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(sunder_particle_2, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(sunder_particle_2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(sunder_particle_2, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControl(sunder_particle_2, 15, Vector(0,152,255))
ParticleManager:SetParticleControl(sunder_particle_2, 16, Vector(1,0,0))
ParticleManager:ReleaseParticleIndex(sunder_particle_2)

end

function custom_terrorblade_sunder:OnSpellStart(new_target)
if not IsServer() then return end

local target = self:GetCursorTarget()
if new_target then 
	target = new_target
end

if target:TriggerSpellAbsorb(self) then return end


	if self:GetCaster():HasModifier("modifier_terror_sunder_legendary") and target ~= nil then 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_legendary", {duration = self.legendary_duration, target = target:entindex()})
	else 
		local caster_health_percent	= self:GetCaster():GetHealthPercent()
		local target_health_percent	= target:GetHealthPercent()

		local current_health = self:GetCaster():GetHealth()

		self:PlayEffect(target)

		self:GetCaster():SetHealth(self:GetCaster():GetMaxHealth() * math.max(target_health_percent, self:GetSpecialValueFor("hit_point_minimum_pct")) * 0.01)
		
		if self:GetCaster():GetHealth() > current_health and self:GetCaster():GetQuest() == "Terr.Quest_8" and not self:GetCaster():QuestCompleted() and target:IsRealHero() and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
			self:GetCaster():UpdateQuest(self:GetCaster():GetHealth() - current_health)
		end

		target:SetHealth(target:GetMaxHealth() * math.max(caster_health_percent, self:GetSpecialValueFor("hit_point_minimum_pct")) * 0.01)

	end


	if  self:GetCaster():HasModifier("modifier_terror_sunder_damage") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_lifesteal", {duration = self.lifesteal_duration})
	end



	if self:GetCaster():HasModifier("modifier_terror_sunder_heal") then 

		self:GetCaster():RemoveModifierByName("modifier_custom_terrorblade_sunder_stats_self")
		target:RemoveModifierByName("modifier_custom_terrorblade_sunder_stats")

		local stats_target = target
		if stats_target:IsCreep() then 
			stats_target = self:GetCaster()
		end

		stats_target:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_stats", {duration = self:GetCaster():GetTalentValue("modifier_terror_sunder_heal", "duration")})  
	end



	if self:GetCaster():HasModifier("modifier_terror_sunder_swap") and target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
		target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self,true), "modifier_custom_terrorblade_sunder_rooted", {duration = (1 - target:GetStatusResistance())*self.stun_stun})
	end

	if self:GetCaster():HasModifier("modifier_terror_sunder_cd") then 
		target:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_sunder_damage", {duration = self.damage_duration})
	end


	if false then 
		self:PlayEffect(target)
		local abs = target:GetAbsOrigin()
		target:ForceKill(false)
		self:EndCooldown()
		self:GetCaster():Purge(false, true, false, false, false)

		

		local particle_2 = ParticleManager:CreateParticle("particles/econ/events/spring_2021/blink_dagger_spring_2021_start_lvl2.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_2, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_2)

		local point_1 = abs + Vector(0,0,150)
		local point_2 = self:GetAbsOrigin() + Vector(0,0,150)
		local sunder_particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(sunder_particle_2, 0, point_1)
		ParticleManager:SetParticleControl(sunder_particle_2, 1, point_2)
		ParticleManager:SetParticleControl(sunder_particle_2, 61, Vector(1,0,0))
		ParticleManager:SetParticleControl(sunder_particle_2, 60, Vector(0,242,255))
		ParticleManager:ReleaseParticleIndex(sunder_particle_2)

		FindClearSpaceForUnit(self:GetCaster(), abs, false)


		local particle_3 = ParticleManager:CreateParticle("particles/econ/events/spring_2021/blink_dagger_spring_2021_end.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particle_3, 0, self:GetCaster():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle_3)
		

	end
		


end





modifier_custom_terrorblade_sunder_legendary = class({})
function modifier_custom_terrorblade_sunder_legendary:IsHidden() return true end
function modifier_custom_terrorblade_sunder_legendary:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_legendary:OnCreated(table)

if table.target then 
	self.target = EntIndexToHScript(table.target)
end

if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(self:GetAbility().legendary_interval)

end

function modifier_custom_terrorblade_sunder_legendary:OnIntervalThink()
if not IsServer() then return end
if not self.target then return end
if not self.target:IsAlive() then 
	self:Destroy()
	return
end

local current_health = self:GetCaster():GetHealth()

local heal = (self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())*self:GetAbility().legendary_heal

self:GetCaster():SetHealth(self:GetCaster():GetHealth() + heal)

if self:GetCaster():GetHealth() > current_health and self:GetCaster():GetQuest() == "Terr.Quest_8" and not self:GetCaster():QuestCompleted() and self.target:IsRealHero() and self.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then 
	self:GetCaster():UpdateQuest(self:GetCaster():GetHealth() - current_health)
end


SendOverheadEventMessage(self:GetCaster(), 10, self:GetCaster(), heal, nil)
local damageTable = {
    victim      = self.target,
    damage      = heal,
    damage_type   = DAMAGE_TYPE_PURE,
    damage_flags  = DOTA_DAMAGE_FLAG_NONE,
    attacker    = self:GetCaster(),
    ability     = self:GetAbility()
 }
    
ApplyDamage(damageTable)


self:GetAbility():PlayEffect(self.target)
end





modifier_custom_terrorblade_sunder_incoming = class({})
function modifier_custom_terrorblade_sunder_incoming:IsHidden() return false end
function modifier_custom_terrorblade_sunder_incoming:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_incoming:GetTexture() return "buffs/sunder_amplify" end
function modifier_custom_terrorblade_sunder_incoming:DeclareFunctions()
return
{
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}

end

function modifier_custom_terrorblade_sunder_incoming:GetModifierIncomingDamage_Percentage() return 
self:GetAbility().amplify_init + self:GetAbility().amplify_inc*self:GetCaster():GetUpgradeStack("modifier_terror_sunder_amplify")
end




modifier_custom_terrorblade_sunder_tracker = class({})
function modifier_custom_terrorblade_sunder_tracker:IsHidden() return true end
function modifier_custom_terrorblade_sunder_tracker:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_tracker:RemoveOnDeath() return false end
function modifier_custom_terrorblade_sunder_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK,
	MODIFIER_EVENT_ON_ATTACK_START,
	MODIFIER_EVENT_ON_ATTACK_LANDED

}

end



function modifier_custom_terrorblade_sunder_tracker:OnAttack(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_terror_sunder_stats") then return end
if self:GetAbility():GetAutoCastState() == false then return end
if params.attacker ~= self:GetParent() then return end
if self:GetParent():HasModifier("modifier_custom_terrorblade_sunder_cd") then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end


self.record = nil

self.record = params.record
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_terrorblade_sunder_cd", {duration = self:GetCaster():GetTalentValue("modifier_terror_sunder_stats", "cd")})

end



function modifier_custom_terrorblade_sunder_tracker:OnAttackStart(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end


end

function modifier_custom_terrorblade_sunder_tracker:OnAttackLanded(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if not self.record then return end
if self.record ~= params.record then return end

local effect_name = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"
local target = params.target


local sunder_particle_1 = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(sunder_particle_1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(sunder_particle_1, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(sunder_particle_1, 2, target:GetAbsOrigin())
ParticleManager:SetParticleControl(sunder_particle_1, 15, Vector(191, 100, 255))
ParticleManager:SetParticleControl(sunder_particle_1, 16, Vector(1,0,0))
ParticleManager:ReleaseParticleIndex(sunder_particle_1)



self.damage = self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_terror_sunder_stats", "cost")/100
self:GetParent():SetHealth(math.max(1, self:GetParent():GetHealth() - self.damage))


local damage = self.damage


local damageTable = {
    victim      = params.target,
    damage      = damage,
    damage_type   = DAMAGE_TYPE_PURE,
    damage_flags  = DOTA_DAMAGE_FLAG_NONE,
    attacker    = self:GetCaster(),
    ability     = self:GetAbility()
 }
    
local damage = ApplyDamage(damageTable)

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_sunder_slow", {duration = (1 - params.target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_terror_sunder_stats", "duration")} )


local particle = ParticleManager:CreateParticle("particles/items_fx/phylactery_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

local particle_2 = ParticleManager:CreateParticle("particles/items_fx/phylactery.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle_2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle_2, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle_2)

SendOverheadEventMessage( params.target, 4, params.target, damage, nil)

params.target:EmitSound("TB.Sunder_attack")

end



modifier_custom_terrorblade_sunder_stats = class({})
function modifier_custom_terrorblade_sunder_stats:IsHidden() return false end
function modifier_custom_terrorblade_sunder_stats:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_stats:GetTexture() return "buffs/sunder_heal" end


function modifier_custom_terrorblade_sunder_stats:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(self:GetCaster():GetTalentValue("modifier_terror_sunder_heal", "stats_init"))

self.max = self:GetCaster():GetTalentValue("modifier_terror_sunder_heal", "stats_init") + self:GetCaster():GetTalentValue("modifier_terror_sunder_heal", "max")


if self:GetParent() ~= self:GetCaster() then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_terrorblade_sunder_stats_self", {duration = self:GetRemainingTime()})
end

self.strength   = 0
self.agility  = 0

self:OnIntervalThink()
self:StartIntervalThink(0.1)

end



function modifier_custom_terrorblade_sunder_stats:OnIntervalThink()
if not IsServer() then return end


self.strength   = 0
self.strength   = self:GetParent():GetStrength() * self:GetStackCount() * 0.01

self.agility  = 0
self.agility   = self:GetParent():GetAgility() * self:GetStackCount() * 0.01

self:GetParent():CalculateStatBonus(true)

if self:GetParent() == self:GetCaster() then return end


local mod = self:GetCaster():FindModifierByName("modifier_custom_terrorblade_sunder_stats_self")
if mod then 
	mod.strength = self.strength
	mod.agility = self.agility

	mod:SetStackCount(self.strength)

	self:GetCaster():CalculateStatBonus(true)
end

end


function modifier_custom_terrorblade_sunder_stats:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_custom_terrorblade_sunder_stats:OnAttackLanded(params)
if not IsServer() then return end
if self:GetCaster() ~= params.attacker then return end
if self:GetParent() ~= self:GetCaster() and self:GetParent() ~= params.target then return end


if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end



function modifier_custom_terrorblade_sunder_stats:GetModifierBonusStats_Strength()
local k = 1
if self:GetParent() ~= self:GetCaster() then 
	k = -1
end

	return k* self.strength
end

function modifier_custom_terrorblade_sunder_stats:GetModifierBonusStats_Agility()
local k = 1
if self:GetParent() ~= self:GetCaster() then 
	k = -1
end

	return k* self.agility
end



modifier_custom_terrorblade_sunder_stats_self = class({})
function modifier_custom_terrorblade_sunder_stats_self:IsHidden() return false end
function modifier_custom_terrorblade_sunder_stats_self:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_stats_self:GetTexture() return "buffs/sunder_heal" end


function modifier_custom_terrorblade_sunder_stats_self:OnCreated(table)
if not IsServer() then return end
self.strength = 0
self.agility = 0
end




function modifier_custom_terrorblade_sunder_stats_self:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
}
end



function modifier_custom_terrorblade_sunder_stats_self:GetModifierBonusStats_Strength()
	return self.strength
end

function modifier_custom_terrorblade_sunder_stats_self:GetModifierBonusStats_Agility()
	return  self.agility
end










modifier_custom_terrorblade_sunder_lifesteal = class({})
function modifier_custom_terrorblade_sunder_lifesteal:IsHidden() return false end
function modifier_custom_terrorblade_sunder_lifesteal:IsPurgable() return true end
function modifier_custom_terrorblade_sunder_lifesteal:GetTexture() return "buffs/sunder_speed" end


function modifier_custom_terrorblade_sunder_lifesteal:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_TOOLTIP
}
end
function modifier_custom_terrorblade_sunder_lifesteal:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

local attacker = params.attacker

if attacker.owner then 
	attacker = attacker.owner
end

if attacker ~= self:GetCaster() then return end

local heal = (self:GetAbility().lifesteal_inc[self:GetCaster():GetUpgradeStack("modifier_terror_sunder_damage")])*params.damage


self:GetCaster():GenericHeal(heal, self:GetAbility(), true)


end



function modifier_custom_terrorblade_sunder_lifesteal:OnTooltip()
return (self:GetAbility().lifesteal_inc[self:GetCaster():GetUpgradeStack("modifier_terror_sunder_damage")])*100
end

modifier_custom_terrorblade_sunder_rooted = class({})
function modifier_custom_terrorblade_sunder_rooted:IsHidden() return true end
function modifier_custom_terrorblade_sunder_rooted:IsPurgable() return true end
function modifier_custom_terrorblade_sunder_rooted:CheckState()
return
{
	[MODIFIER_STATE_ROOTED] = true
}
end
function modifier_custom_terrorblade_sunder_rooted:GetEffectName() return "particles/items3_fx/gleipnir_root.vpcf" end




modifier_custom_terrorblade_sunder_damage = class({})
function modifier_custom_terrorblade_sunder_damage:IsHidden() return false end
function modifier_custom_terrorblade_sunder_damage:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_damage:GetTexture() return "buffs/sunder_damage" end

function modifier_custom_terrorblade_sunder_damage:OnCreated(table)
if not IsServer() then return end

self.tick = (self:GetAbility().damage_total[self:GetCaster():GetUpgradeStack("modifier_terror_sunder_cd")]/self:GetAbility().damage_duration)*self:GetCaster():GetMaxHealth()



self:StartIntervalThink(self:GetAbility().damage_interval)
end

function modifier_custom_terrorblade_sunder_damage:OnIntervalThink()
if not IsServer() then return end

local heal = self.tick


local damageTable = {
    victim      = self:GetParent(),
    damage      = heal,
    damage_type   = DAMAGE_TYPE_PURE,
    damage_flags  = DOTA_DAMAGE_FLAG_NONE,
    attacker    = self:GetCaster(),
    ability     = self:GetAbility()
 }
    
local damage = ApplyDamage(damageTable)


SendOverheadEventMessage( self:GetParent(), 4, self:GetParent(), damage, nil)

end





modifier_custom_terrorblade_sunder_slow = class({})
function modifier_custom_terrorblade_sunder_slow:IsHidden() return false end
function modifier_custom_terrorblade_sunder_slow:IsPurgable() return true end
function modifier_custom_terrorblade_sunder_slow:GetTexture() return "buffs/sunder_stats" end
function modifier_custom_terrorblade_sunder_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end

function modifier_custom_terrorblade_sunder_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_terrorblade_sunder_slow:GetModifierMoveSpeedBonus_Percentage() return
self.slow

end
function modifier_custom_terrorblade_sunder_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_terror_sunder_stats", "slow")
end


modifier_custom_terrorblade_sunder_cd = class({})
function modifier_custom_terrorblade_sunder_cd:IsHidden() return false end
function modifier_custom_terrorblade_sunder_cd:IsPurgable() return false end
function modifier_custom_terrorblade_sunder_cd:RemoveOnDeath() return false end
function modifier_custom_terrorblade_sunder_cd:IsDebuff() return true end
function modifier_custom_terrorblade_sunder_cd:GetTexture() return "buffs/sunder_stats" end
function modifier_custom_terrorblade_sunder_cd:OnCreated(table)
self.RemoveForDuel = true
end