LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_target", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_caster", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_armor", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_crit", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_legendary", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_evasion", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_slow", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_tracker", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_damage", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_absorb", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)

ember_spirit_sleight_of_fist_custom = class({})

ember_spirit_sleight_of_fist_custom.cleave_init = 0
ember_spirit_sleight_of_fist_custom.cleave_inc = 0.2
ember_spirit_sleight_of_fist_custom.cleave_slow = {-15, -20, -25}
ember_spirit_sleight_of_fist_custom.cleave_slow_duration = 2

ember_spirit_sleight_of_fist_custom.armor_reduction = 0.3
ember_spirit_sleight_of_fist_custom.armor_heal = 0.3
ember_spirit_sleight_of_fist_custom.armor_creeps = 0.33



ember_spirit_sleight_of_fist_custom.crit_init = 110
ember_spirit_sleight_of_fist_custom.crit_inc = 30

ember_spirit_sleight_of_fist_custom.attack_distance = 300
ember_spirit_sleight_of_fist_custom.attack_cd = {0.2, 0.3}
ember_spirit_sleight_of_fist_custom.attack_damage = {8, 16}
ember_spirit_sleight_of_fist_custom.attack_max = 5
ember_spirit_sleight_of_fist_custom.attack_damage_duration = 10

ember_spirit_sleight_of_fist_custom.legendary_duration = 12
ember_spirit_sleight_of_fist_custom.legendary_max = 3

ember_spirit_sleight_of_fist_custom.evasion_chance = {30, 45, 60}
ember_spirit_sleight_of_fist_custom.evasion_move = {10, 15, 20}
ember_spirit_sleight_of_fist_custom.evasion_duration = 2.5

ember_spirit_sleight_of_fist_custom.absorb_duration = 1.5
ember_spirit_sleight_of_fist_custom.absorb_damage = -20



function ember_spirit_sleight_of_fist_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", context )
PrecacheResource( "particle", "particles/ember_cleave.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_drow/fist_count.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_pangolier_shield.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
PrecacheResource( "particle", "particles/ember_linken.vpcf", context )
PrecacheResource( "particle", "particles/ember_linken_proc.vpcf", context )

end




function ember_spirit_sleight_of_fist_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end



function ember_spirit_sleight_of_fist_custom:GetIntrinsicModifierName()
return "modifier_ember_spirit_sleight_of_fist_tracker"
end

function ember_spirit_sleight_of_fist_custom:OnOwnerDied()
	if not self:IsActivated() then
		self:SetActivated(true)
	end
end




function ember_spirit_sleight_of_fist_custom:OnSpellStart()

local caster = self:GetCaster()


local ability = caster:FindAbilityByName("ember_spirit_fire_remnant_custom")
if ability then 
	ability:AddStack()
end 

local target_loc = self:GetCursorPosition()
local effect_radius = self:GetSpecialValueFor("radius")

caster:EmitSound("Hero_EmberSpirit.SleightOfFist.Cast")
local cast_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
ParticleManager:SetParticleControl(cast_pfx, 1, Vector(effect_radius, 1, 1))
ParticleManager:ReleaseParticleIndex(cast_pfx)

local count = 0 

local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_loc, nil, effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

for _,enemy in pairs(nearby_enemies) do
	if enemy:GetUnitName() ~= "npc_teleport" and not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
		count = count + 1
	end
end


if count >= 1 then
	self:EndCooldown()
	self:SetActivated(false)

	caster:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_custom_caster", {x = target_loc.x, y = target_loc.y})
end 

end 






modifier_ember_spirit_sleight_of_fist_custom_caster = class({})

function modifier_ember_spirit_sleight_of_fist_custom_caster:IsPurgable() return false end

function modifier_ember_spirit_sleight_of_fist_custom_caster:OnCreated(table)
self.damage = 0

if self:GetParent():HasModifier("modifier_ember_fist_4") then 
	self.damage = self:GetCaster():GetUpgradeStack("modifier_ember_spirit_sleight_of_fist_damage")*self:GetAbility().attack_damage[self:GetCaster():GetUpgradeStack("modifier_ember_fist_4")]
end

self.attack_interval = self:GetAbility():GetSpecialValueFor("attack_interval")
self.effect_radius = self:GetAbility():GetSpecialValueFor("radius")
self.caster = self:GetCaster()
self.caster_loc = self.caster:GetAbsOrigin()
self.sleight_targets = {}
self.previous_position = self.caster_loc

self.current_count = 1
self.hit_array = {}

if not IsServer() then return end


self.disarmed = self:GetCaster():IsDisarmed()

local target_loc = GetGroundPosition(Vector(table.x, table.y, 0), nil)

self.original_direction = (self.caster_loc - target_loc):Normalized()

local nearby_enemies = FindUnitsInRadius(self.caster:GetTeamNumber(), target_loc, nil, self.effect_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

for _,enemy in pairs(nearby_enemies) do
	if enemy:GetUnitName() ~= "npc_teleport" and not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 

		local mod = enemy:FindModifierByName("modifier_ember_spirit_sleight_of_fist_custom_legendary")

		self.sleight_targets[#self.sleight_targets + 1] = enemy:GetEntityIndex()

		if mod then 
			for i = 1,mod:GetStackCount() do
				self.sleight_targets[#self.sleight_targets + 1] = enemy:GetEntityIndex()
			end
		end

		enemy:AddNewModifier(self.caster, self, "modifier_ember_spirit_sleight_of_fist_custom_target", {duration = (#self.sleight_targets - 1) * self.attack_interval})
	end
end


if self.caster:HasModifier("modifier_ember_fist_3") then 
	self.crit_mod = self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_custom_crit", {})
end

self.current_target = EntIndexToHScript(self.sleight_targets[self.current_count])

self.ended = false

self.RemoveForDuel = true

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_CUSTOMORIGIN, nil)
ParticleManager:SetParticleControl(self.particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_CUSTOMORIGIN_FOLLOW, nil, self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlForward(self.particle, 1, self:GetParent():GetForwardVector())
self:AddParticle(self.particle, false, false, -1, false, false)
		
self.NoDraw = true
self:GetParent():AddNoDraw()
self:GetAbility():SetActivated(false)


self:OnIntervalThink()
self:StartIntervalThink(self.attack_interval)
end


function modifier_ember_spirit_sleight_of_fist_custom_caster:IsValidTarget(target)

return target and not target:IsNull() and target:IsAlive() and (not target:IsInvisible() or self.caster:CanEntityBeSeenByMyTeam(target))
end 



function modifier_ember_spirit_sleight_of_fist_custom_caster:OnIntervalThink()
if not IsServer() then return end 

if self.ended == true then 

	local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(trail_pfx, 0, self.caster_loc)
	ParticleManager:SetParticleControl(trail_pfx, 1, self.caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(trail_pfx) 
	FindClearSpaceForUnit(self.caster, self.caster_loc, true)

	for _, target in pairs(self.sleight_targets) do
		local unit = EntIndexToHScript(target)
		if unit and not unit:IsNull() then 
			unit:RemoveModifierByName("modifier_ember_spirit_sleight_of_fist_custom_target")
		end
	end


	if self.caster:HasModifier("modifier_ember_fist_6") then 
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_absorb", {duration = self:GetAbility().absorb_duration})
	end

	if self.caster:HasModifier("modifier_ember_fist_2") then 
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_evasion", {duration = self:GetAbility().evasion_duration})
	end

	self:Destroy()
	return
end 


if self:IsValidTarget(self.current_target) then
	self.caster:EmitSound("Hero_EmberSpirit.SleightOfFist.Damage")

	local slash_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.urrent_target)
	ParticleManager:SetParticleControl(slash_pfx, 0, self.current_target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(slash_pfx)

	local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(trail_pfx, 0, self.current_target:GetAbsOrigin())
	ParticleManager:SetParticleControl(trail_pfx, 1, self.previous_position)
	ParticleManager:ReleaseParticleIndex(trail_pfx)
	
	self.caster:SetAbsOrigin(self.current_target:GetAbsOrigin() + self.original_direction * 64)


	if not self.disarmed then 

		if not self.hit_array[self.current_target:entindex()] and self.caster:HasModifier("modifier_ember_fist_legendary") then 
			self.current_target:AddNewModifier(self.caster, self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_custom_legendary", {duration = self:GetAbility().legendary_duration})
		end

		self.hit_array[self.current_target:entindex()] = true
		self.caster:PerformAttack(self.current_target, true, true, true, false, false, false, false)
	end

	if self.crit_mod and not self.crit_mod:IsNull() then 
		self.crit_mod:Destroy()
	end 
end

self.current_count = self.current_count + 1

if self.current_count > #self.sleight_targets then 
	self.ended = true
	self:StartIntervalThink(self.attack_interval + FrameTime())
	return
end 


if self.current_target and not self.current_target:IsNull() then 
	self.previous_position = self.current_target:GetAbsOrigin()
end

self.current_target = EntIndexToHScript(self.sleight_targets[self.current_count])
			
if self:IsValidTarget(self.current_target) then
	self:StartIntervalThink(self.attack_interval)
else
	self:StartIntervalThink(0)
end

end 



function modifier_ember_spirit_sleight_of_fist_custom_caster:OnDestroy()
if not IsServer() then return end

self:GetParent():RemoveNoDraw()
self:GetAbility():SetActivated(true)

self:GetAbility():UseResources(false, false, false, true)
self:GetParent():RemoveModifierByName("modifier_ember_spirit_sleight_of_fist_damage")

end

function modifier_ember_spirit_sleight_of_fist_custom_caster:CheckState()
if not IsServer() then return end

local state = {}

if self:GetParent():HasModifier("modifier_ember_fist_5") then 
 	state = {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_CANNOT_MISS] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_DISARMED] = true
		}
else 
 	state = {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_DISARMED] = true
		}

end
		return state
end

function modifier_ember_spirit_sleight_of_fist_custom_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    	MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end


function modifier_ember_spirit_sleight_of_fist_custom_caster:GetModifierProcAttack_Feedback(params)
if not IsServer() then return end

if self:GetParent():HasModifier("modifier_ember_fist_5") then 
	local mod = params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_custom_armor", {duration = 0.1})
end

end



function modifier_ember_spirit_sleight_of_fist_custom_caster:GetModifierPreAttack_BonusDamage(keys)

local bonus = self.damage

if IsClient() then 
	return bonus
end

if keys.target and keys.target:IsHero() then
	return self:GetAbility():GetSpecialValueFor("bonus_hero_damage") + bonus
end

return bonus

end

function modifier_ember_spirit_sleight_of_fist_custom_caster:GetModifierIgnoreCastAngle()
	return 1
end

function modifier_ember_spirit_sleight_of_fist_custom_caster:OnAttackLanded( params )
if not self:GetParent():HasModifier("modifier_ember_fist_1") then return end
if self:GetParent() ~= params.attacker then return end 

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_slow", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility().cleave_slow_duration})

local k = self:GetAbility().cleave_init + self:GetAbility().cleave_inc*self:GetParent():GetUpgradeStack("modifier_ember_fist_1")

DoCleaveAttack(self:GetParent(), params.target, nil, params.damage * k  , 150, 360, 650, "particles/ember_cleave.vpcf")

end




























modifier_ember_spirit_sleight_of_fist_custom_target = class({})

function modifier_ember_spirit_sleight_of_fist_custom_target:IsDebuff() return true end
function modifier_ember_spirit_sleight_of_fist_custom_target:IsHidden() return true end
function modifier_ember_spirit_sleight_of_fist_custom_target:IsPurgable() return false end

function modifier_ember_spirit_sleight_of_fist_custom_target:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf"
end

function modifier_ember_spirit_sleight_of_fist_custom_target:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end





modifier_ember_spirit_sleight_of_fist_custom_armor = class({})
function modifier_ember_spirit_sleight_of_fist_custom_armor:IsHidden() return true end
function modifier_ember_spirit_sleight_of_fist_custom_armor:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_custom_armor:OnCreated(table)
self.armor = -1*self:GetParent():GetPhysicalArmorValue(false)*(self:GetAbility().armor_reduction)
end

function modifier_ember_spirit_sleight_of_fist_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}

end
function modifier_ember_spirit_sleight_of_fist_custom_armor:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_ember_spirit_sleight_of_fist_custom_armor:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if params.inflictor then return end 


local heal = params.damage*self:GetAbility().armor_heal

if params.unit:IsCreep() or params.unit:IsIllusion() then 
	heal = heal*self:GetAbility().armor_creeps
end 


self:GetCaster():GenericHeal(heal, self:GetAbility(), true)

self:Destroy()

end



modifier_ember_spirit_sleight_of_fist_custom_crit = class({})
function modifier_ember_spirit_sleight_of_fist_custom_crit:IsHidden() return false end
function modifier_ember_spirit_sleight_of_fist_custom_crit:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_custom_crit:GetCritDamage() return
self:GetAbility().crit_init + self:GetAbility().crit_inc*self:GetParent():GetUpgradeStack("modifier_ember_fist_3")
end

function modifier_ember_spirit_sleight_of_fist_custom_crit:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
}
end

function modifier_ember_spirit_sleight_of_fist_custom_crit:GetModifierPreAttack_CriticalStrike( params )
return self:GetAbility().crit_init + self:GetAbility().crit_inc*self:GetParent():GetUpgradeStack("modifier_ember_fist_3")
end



modifier_ember_spirit_sleight_of_fist_custom_legendary = class({})

function modifier_ember_spirit_sleight_of_fist_custom_legendary:IsHidden() return false end
function modifier_ember_spirit_sleight_of_fist_custom_legendary:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnCreated(table)
if not IsServer() then return end

local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end

function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() < self:GetAbility().legendary_max then 
	self:IncrementStackCount()
else 
	self:Destroy()
end

end


function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then return end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end


function modifier_ember_spirit_sleight_of_fist_custom_legendary:RemoveOnDeath() return true end

function modifier_ember_spirit_sleight_of_fist_custom_legendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}

end

function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnTooltip()
return self:GetStackCount()
end



modifier_ember_spirit_sleight_of_fist_evasion = class({})
function modifier_ember_spirit_sleight_of_fist_evasion:IsHidden() return false end
function modifier_ember_spirit_sleight_of_fist_evasion:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_evasion:GetStatusEffectName() return "particles/status_fx/status_effect_pangolier_shield.vpcf" end


function modifier_ember_spirit_sleight_of_fist_evasion:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end
function modifier_ember_spirit_sleight_of_fist_evasion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ember_spirit_sleight_of_fist_evasion:StatusEffectPriority()
    return 10010
end


function modifier_ember_spirit_sleight_of_fist_evasion:GetTexture() return "buffs/Blade_dance_legendary" end
function modifier_ember_spirit_sleight_of_fist_evasion:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_EVASION_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_ember_spirit_sleight_of_fist_evasion:GetModifierEvasion_Constant()
return self:GetAbility().evasion_chance[self:GetCaster():GetUpgradeStack("modifier_ember_fist_2")]
end

function modifier_ember_spirit_sleight_of_fist_evasion:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().evasion_move[self:GetCaster():GetUpgradeStack("modifier_ember_fist_2")]
end






modifier_ember_spirit_sleight_of_fist_slow = class({})

function modifier_ember_spirit_sleight_of_fist_slow:IsHidden()
	return false
end

function modifier_ember_spirit_sleight_of_fist_slow:IsDebuff()
	return true
end

function modifier_ember_spirit_sleight_of_fist_slow:IsPurgable()
	return true
end



function modifier_ember_spirit_sleight_of_fist_slow:DeclareFunctions()
return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,	
}
end




function modifier_ember_spirit_sleight_of_fist_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility().cleave_slow[self:GetCaster():GetUpgradeStack("modifier_ember_fist_1")]
end

function modifier_ember_spirit_sleight_of_fist_slow:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_bounce_impact_debuff.vpcf"
end

function modifier_ember_spirit_sleight_of_fist_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_ember_spirit_sleight_of_fist_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_ember_spirit_sleight_of_fist_slow:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end




modifier_ember_spirit_sleight_of_fist_tracker = class({})
function modifier_ember_spirit_sleight_of_fist_tracker:IsHidden() return true end
function modifier_ember_spirit_sleight_of_fist_tracker:IsPurgable() return false end

function modifier_ember_spirit_sleight_of_fist_tracker:OnCreated(table)
if not IsServer() then return end

self.pos = self:GetParent():GetAbsOrigin()
self.distance = 0

self:StartIntervalThink(1)
end

function modifier_ember_spirit_sleight_of_fist_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_ember_spirit_sleight_of_fist_tracker:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_ember_spirit_sleight_of_fist_custom_caster") then return end

local pass = (self:GetParent():GetAbsOrigin() - self.pos):Length2D()

self.pos = self:GetParent():GetAbsOrigin()

if not self:GetParent():HasModifier("modifier_ember_fist_4") then return end


while pass > 0 do 
	self.distance = self.distance + pass



    if self.distance < self:GetAbility().attack_distance then 
    	pass = 0
    else 
    	pass =  self.distance - self:GetAbility().attack_distance
    	self.distance = 0


    	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_damage", {duration = self:GetAbility().attack_damage_duration})

		local cd = self:GetAbility():GetCooldownTimeRemaining()
		if cd > 0 then 
			self:GetAbility():EndCooldown()
			self:GetAbility():StartCooldown(cd - self:GetAbility().attack_cd[self:GetCaster():GetUpgradeStack("modifier_ember_fist_4")])
	 	end
    end
end


self:StartIntervalThink(0.1)
end


modifier_ember_spirit_sleight_of_fist_damage = class({})
function modifier_ember_spirit_sleight_of_fist_damage:IsHidden() return false end
function modifier_ember_spirit_sleight_of_fist_damage:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_damage:GetTexture() return "buffs/fist_damage" end
function modifier_ember_spirit_sleight_of_fist_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_ember_spirit_sleight_of_fist_damage:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().attack_max then return end

self:IncrementStackCount()
end


function modifier_ember_spirit_sleight_of_fist_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_ember_spirit_sleight_of_fist_damage:OnTooltip()
return self:GetAbility().attack_damage[self:GetCaster():GetUpgradeStack("modifier_ember_fist_4")]*self:GetStackCount()
end









modifier_ember_spirit_sleight_of_fist_absorb = class({})
function modifier_ember_spirit_sleight_of_fist_absorb:IsHidden() return true end
function modifier_ember_spirit_sleight_of_fist_absorb:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_absorb:GetTexture() return "buffs/fist_evasion" end

function modifier_ember_spirit_sleight_of_fist_absorb:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/ember_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)


end



function modifier_ember_spirit_sleight_of_fist_absorb:DeclareFunctions()
return
{
MODIFIER_PROPERTY_ABSORB_SPELL,
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_ember_spirit_sleight_of_fist_absorb:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

local particle = ParticleManager:CreateParticle("particles/ember_linken_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

return 1 
end



function modifier_ember_spirit_sleight_of_fist_absorb:GetModifierIncomingDamage_Percentage()
return self:GetAbility().absorb_damage
end
