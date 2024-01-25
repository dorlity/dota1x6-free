LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_target", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_caster", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_crit", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_legendary", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_evasion", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_slow", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_tracker", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_damage", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_sleight_of_fist_custom_unslow", "abilities/ember_spirit/sleight_of_fist", LUA_MODIFIER_MOTION_NONE)

ember_spirit_sleight_of_fist_custom = class({})





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
PrecacheResource( "particle", "particles/ember_spirit/fist_resist.vpcf", context )

end


function ember_spirit_sleight_of_fist_custom:GetManaCost(level)

if self:GetCaster():HasModifier("modifier_ember_fist_6") then  
  return self:GetCaster():GetTalentValue("modifier_ember_fist_6", "mana")
end

return self.BaseClass.GetManaCost(self,level) 
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


function ember_spirit_sleight_of_fist_custom:MakeAttack(target, is_scepter)

local caster = self:GetCaster()
local mod = nil

if is_scepter then 
	mod = caster:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_custom_damage", {scepter = is_scepter})
end

target:EmitSound("Hero_EmberSpirit.SleightOfFist.Damage")

local particle = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

caster:PerformAttack(target, true, true, true, false, false, false, caster:HasScepter())

if caster:HasModifier("modifier_ember_fist_4") then 
	local damage = caster:GetTalentValue("modifier_ember_fist_4", "damage")*(target:GetMaxHealth() - target:GetHealth())/100
	if target:IsCreep() then 
		damage = damage / caster:GetTalentValue("modifier_ember_fist_4", "creeps")
	end 

	local real_damage = ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
	target:SendNumber(6, real_damage)

	caster:GenericHeal(real_damage*caster:GetTalentValue("modifier_ember_fist_4", "heal")/100, self, true)
end 



if caster:HasModifier("modifier_ember_fist_3") then 
	target:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_slow", {duration = (1 - target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_ember_fist_3", "duration")})
end

if mod and not mod:IsNull() then 
	mod:Destroy()
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

	if caster:HasModifier("modifier_ember_fist_5") then 
		caster:CdItems(caster:GetTalentValue("modifier_ember_fist_5", "cd_items"))
	end

	local disarmed = 0

	if caster:IsDisarmed() then 
		disarmed = 1
	end 
	caster:AddNewModifier(caster, self, "modifier_ember_spirit_sleight_of_fist_custom_caster", {x = target_loc.x, y = target_loc.y, disarmed = disarmed})
end 

end 






modifier_ember_spirit_sleight_of_fist_custom_caster = class({})

function modifier_ember_spirit_sleight_of_fist_custom_caster:IsPurgable() return false end

function modifier_ember_spirit_sleight_of_fist_custom_caster:OnCreated(table)


self.attack_interval = self:GetAbility():GetSpecialValueFor("attack_interval")
self.effect_radius = self:GetAbility():GetSpecialValueFor("radius")
self.caster = self:GetCaster()
self.caster_loc = self.caster:GetAbsOrigin()
self.sleight_targets = {}
self.previous_position = self.caster_loc

self.current_count = 1
self.hit_array = {}

self.evasion_duration = self:GetCaster():GetTalentValue("modifier_ember_fist_2", "duration")

self.legendary_duration = self:GetCaster():GetTalentValue("modifier_ember_fist_legendary", "duration", true)

if not IsServer() then return end

self.damage_mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_custom_damage", {})

self.disarmed = table.disarmed

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
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_custom_unslow", {duration = self.caster:GetTalentValue("modifier_ember_fist_6", "duration")})
	end


	if self.caster:HasModifier("modifier_ember_fist_2") then 
		self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_evasion", {duration = self.evasion_duration})
	end

	self:Destroy()
	return
end 


if self:IsValidTarget(self.current_target) then

	local trail_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(trail_pfx, 0, self.current_target:GetAbsOrigin())
	ParticleManager:SetParticleControl(trail_pfx, 1, self.previous_position)
	ParticleManager:ReleaseParticleIndex(trail_pfx)
	
	self.caster:SetAbsOrigin(self.current_target:GetAbsOrigin() + self.original_direction * 64)


	if self.disarmed == 0 then 

		if not self.hit_array[self.current_target:entindex()] and self.caster:HasModifier("modifier_ember_fist_legendary") then 
			self.current_target:AddNewModifier(self.caster, self:GetAbility(), "modifier_ember_spirit_sleight_of_fist_custom_legendary", {duration = self.legendary_duration})
		end

		self:GetAbility():MakeAttack(self.current_target)
		self.hit_array[self.current_target:entindex()] = true
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

if self.damage_mod and not self.damage_mod:IsNull() then
	self.damage_mod:Destroy()
end

self:GetParent():RemoveNoDraw()
self:GetAbility():SetActivated(true)

self:GetAbility():UseResources(false, false, false, true)

end

function modifier_ember_spirit_sleight_of_fist_custom_caster:CheckState()
return 
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_DISARMED] = true
}
end



function modifier_ember_spirit_sleight_of_fist_custom_caster:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	}

	return funcs
end



function modifier_ember_spirit_sleight_of_fist_custom_caster:GetModifierIgnoreCastAngle()
	return 1
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









modifier_ember_spirit_sleight_of_fist_custom_legendary = class({})

function modifier_ember_spirit_sleight_of_fist_custom_legendary:IsHidden() return false end
function modifier_ember_spirit_sleight_of_fist_custom_legendary:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnCreated(table)
if not IsServer() then return end

self.max = self:GetCaster():GetTalentValue("modifier_ember_fist_legendary", "max")

local particle_cast = "particles/units/heroes/hero_marci/marci_unleash_stack.vpcf"

self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end

function modifier_ember_spirit_sleight_of_fist_custom_legendary:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() < self.max then 
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
function modifier_ember_spirit_sleight_of_fist_evasion:IsHidden() return true end
function modifier_ember_spirit_sleight_of_fist_evasion:IsPurgable() return false end

function modifier_ember_spirit_sleight_of_fist_evasion:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end
function modifier_ember_spirit_sleight_of_fist_evasion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end









modifier_ember_spirit_sleight_of_fist_slow = class({})

function modifier_ember_spirit_sleight_of_fist_slow:IsHidden()
	return true
end

function modifier_ember_spirit_sleight_of_fist_slow:IsPurgable()
	return true
end



function modifier_ember_spirit_sleight_of_fist_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end



function modifier_ember_spirit_sleight_of_fist_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_ember_fist_3", "slow")
self.attack = self:GetCaster():GetTalentValue("modifier_ember_fist_3", "attack")
end


function modifier_ember_spirit_sleight_of_fist_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow 
end

function modifier_ember_spirit_sleight_of_fist_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack 
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

self.caster = self:GetCaster()

self.bonus_move = self:GetCaster():GetTalentValue("modifier_ember_fist_2", "bonus", true)

self.cd_distance = self:GetCaster():GetTalentValue("modifier_ember_fist_5", "distance", true)
self.cd_inc = self:GetCaster():GetTalentValue("modifier_ember_fist_5", "cd", true)

self.crit_chance = self:GetCaster():GetTalentValue("modifier_ember_fist_1", "chance", true)

self.pos = self:GetParent():GetAbsOrigin()
self.distance = 0

if not IsServer() then return end
self:StartIntervalThink(1)
end

function modifier_ember_spirit_sleight_of_fist_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
   	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
}
end

function modifier_ember_spirit_sleight_of_fist_tracker:GetModifierDamageOutgoing_Percentage()
if not self:GetParent():HasModifier("modifier_ember_fist_2") then return end 

local bonus = 1
if self:GetParent():HasModifier("modifier_ember_spirit_sleight_of_fist_evasion") or self:GetParent():HasModifier("modifier_ember_spirit_sleight_of_fist_custom_caster") then 
	bonus = self.bonus_move
end 

return self:GetCaster():GetTalentValue("modifier_ember_fist_2", "damage")*bonus
end

function modifier_ember_spirit_sleight_of_fist_tracker:GetModifierMoveSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_ember_fist_2") then return end 

local bonus = 1
if self:GetParent():HasModifier("modifier_ember_spirit_sleight_of_fist_evasion") then 
	bonus = self.bonus_move
end 

return self:GetCaster():GetTalentValue("modifier_ember_fist_2", "move")*bonus
end



function modifier_ember_spirit_sleight_of_fist_tracker:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_ember_fist_1") then return end
if not RollPseudoRandomPercentage(self.crit_chance,1352,self:GetParent()) then return end

self.record = params.record

return self.caster:GetTalentValue("modifier_ember_fist_1", "damage") 
end




function modifier_ember_spirit_sleight_of_fist_tracker:OnAttackLanded( params )
if not self:GetParent():HasModifier("modifier_ember_fist_1") then return end
if self.caster ~= params.attacker then return end 

if self.record and self.record == params.record then 
	params.target:EmitSound("DOTA_Item.Daedelus.Crit")
end 

DoCleaveAttack(self:GetParent(), params.target, nil, params.damage * self.caster:GetTalentValue("modifier_ember_fist_1", "cleave")/100 , 150, 360, 650, "particles/ember_cleave.vpcf")

end





function modifier_ember_spirit_sleight_of_fist_tracker:OnIntervalThink()
if not IsServer() then return end
if self.caster:HasModifier("modifier_ember_spirit_sleight_of_fist_custom_caster") then return end

local pass = (self.caster:GetAbsOrigin() - self.pos):Length2D()

self.pos = self.caster:GetAbsOrigin()

if not self.caster:HasModifier("modifier_ember_fist_5") then return end


while pass > 0 do 
	self.distance = self.distance + pass


    if self.distance < self.cd_distance then 
    	pass = 0
    else 
    	pass =  self.distance - self.cd_distance
    	self.distance = 0
    	self.caster:CdAbility(self:GetAbility(), self.cd_inc)
    end
end


self:StartIntervalThink(0.1)
end























modifier_ember_spirit_sleight_of_fist_custom_damage = class({})
function modifier_ember_spirit_sleight_of_fist_custom_damage:IsHidden() return true end
function modifier_ember_spirit_sleight_of_fist_custom_damage:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_custom_damage:OnCreated(table)
if not IsServer() then return end 

self.damage = self:GetAbility():GetSpecialValueFor("bonus_hero_damage")


if table.scepter then 
	self.damage = table.scepter
end 

end

function modifier_ember_spirit_sleight_of_fist_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
}
end


function modifier_ember_spirit_sleight_of_fist_custom_damage:GetModifierPreAttack_BonusDamage(params)
if not IsServer() then return end

if params.target and params.target:IsHero() then
	return self.damage
end

end






modifier_ember_spirit_sleight_of_fist_custom_unslow = class({})
function modifier_ember_spirit_sleight_of_fist_custom_unslow:IsHidden() return true end
function modifier_ember_spirit_sleight_of_fist_custom_unslow:IsPurgable() return false end
function modifier_ember_spirit_sleight_of_fist_custom_unslow:CheckState()
return
{
	[MODIFIER_STATE_UNSLOWABLE] = true
}
end

function modifier_ember_spirit_sleight_of_fist_custom_unslow:GetEffectName()
	return "particles/ember_spirit/fist_resist.vpcf"
end
function modifier_ember_spirit_sleight_of_fist_custom_unslow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_ember_spirit_sleight_of_fist_custom_unslow:OnCreated()

self.status = self:GetCaster():GetTalentValue("modifier_ember_fist_6", "status")
end

function modifier_ember_spirit_sleight_of_fist_custom_unslow:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end


function modifier_ember_spirit_sleight_of_fist_custom_unslow:GetModifierStatusResistanceStacking() 
return self.status
end