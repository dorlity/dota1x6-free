LinkLuaModifier( "modifier_sven_gods_strength_custom", "abilities/sven/sven_gods_strength_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_custom_root", "abilities/sven/sven_gods_strength_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_custom_tracker", "abilities/sven/sven_gods_strength_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_custom_crit", "abilities/sven/sven_gods_strength_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_custom_crit_anim", "abilities/sven/sven_gods_strength_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_custom_crit_anim2", "abilities/sven/sven_gods_strength_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_custom_proc_cd", "abilities/sven/sven_gods_strength_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_gods_strength_custom_damage", "abilities/sven/sven_gods_strength_custom", LUA_MODIFIER_MOTION_NONE )




sven_gods_strength_custom = class({})







function sven_gods_strength_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", context )
PrecacheResource( "particle", "particles/sven_wave.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_gods_strength.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/hook_root.vpcf", context )
PrecacheResource( "particle", "particles/sven_rage.vpcf", context )
PrecacheResource( "particle", "particles/mars_shield_legendary.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/sven_god_normal_cleave.vpcf", context )
PrecacheResource( "particle", "particles/sven_god_cleave.vpcf", context )
PrecacheResource( "particle", "particles/sven_god_cleave_2.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf", context )
PrecacheResource( "particle", "particles/sven_wave_god_damage.vpcf", context )

end



function sven_gods_strength_custom:GetCastPoint(iLevel)
if self:GetCaster():HasModifier('modifier_sven_god_5') then 
    return self.BaseClass.GetCastPoint(self) + self:GetCaster():GetTalentValue('modifier_sven_god_5', "cast")
end

return self.BaseClass.GetCastPoint(self)
end




function sven_gods_strength_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_sven_god_5") then 
	return  DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING-- + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end




function sven_gods_strength_custom:GetCooldown(iLevel)

local bonus = 0

if self:GetCaster():HasModifier("modifier_sven_god_3") then
	bonus = self:GetCaster():GetTalentValue("modifier_sven_god_3", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel) + bonus
end


function sven_gods_strength_custom:GetIntrinsicModifierName()
return "modifier_sven_gods_strength_custom_tracker"
end




function sven_gods_strength_custom:OnSpellStart()
if not IsServer() then return end

local gods_strength_duration = self:GetSpecialValueFor( "gods_strength_duration" ) + self:GetCaster():GetTalentValue("modifier_sven_god_3", "duration")

local bkb_duration = self:GetCaster():GetTalentValue("modifier_sven_god_5", "bkb")
local root = self:GetCaster():GetTalentValue("modifier_sven_god_5", "root")
local radius = self:GetCaster():GetTalentValue("modifier_sven_god_5", "radius")


local mod = self:GetCaster():FindModifierByName("modifier_sven_gods_strength_custom")
local dota_mod = self:GetCaster():FindModifierByName("modifier_sven_gods_strength")

local proc_duration =  self:GetCaster():GetTalentValue("modifier_sven_god_6", "duration")

if mod then 
	mod:SetDuration(math.min(gods_strength_duration + proc_duration, mod:GetRemainingTime() + gods_strength_duration), true)

	if dota_mod then 
		dota_mod:SetDuration(math.min(gods_strength_duration + proc_duration, dota_mod:GetRemainingTime() + gods_strength_duration), true)
	end 

else 
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_strength_custom", { duration = gods_strength_duration }  )
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_sven_gods_strength", { duration = gods_strength_duration }  )
end


local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetCaster():GetOrigin(), true )
	
ParticleManager:ReleaseParticleIndex( nFXIndex )

self:GetCaster():EmitSound("Hero_Sven.GodsStrength")

if self:GetCaster():GetName() == "npc_dota_hero_sven" then
	self:GetCaster():EmitSound("sven_sven_ability_godstrength_0"..RandomInt(1, 2))
end

if self:GetCaster():HasModifier("modifier_sven_god_5") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_debuff_immune", {duration = bkb_duration, effect = 1})


	local wave_particle = ParticleManager:CreateParticle( "particles/sven_wave.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( wave_particle, 1, self:GetCaster():GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(wave_particle)

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
	
	for _,target in ipairs(enemies) do 
		if target:GetUnitName() ~= "npc_teleport" then 
			target:AddNewModifier(self:GetCaster(), self, "modifier_sven_gods_strength_custom_root", {duration = (1 - target:GetStatusResistance())*root})
			target:EmitSound("Lc.Press_Root")
		end
	end

end



end





modifier_sven_gods_strength_custom = class({})

function modifier_sven_gods_strength_custom:IsPurgable()
	return false
end

function modifier_sven_gods_strength_custom:IsHidden() return true end

function modifier_sven_gods_strength_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_gods_strength.vpcf"
end


function modifier_sven_gods_strength_custom:StatusEffectPriority()
	return 99999
end


function modifier_sven_gods_strength_custom:GetHeroEffectName()
	return "particles/units/heroes/hero_sven/sven_gods_strength_hero_effect.vpcf"
end


function modifier_sven_gods_strength_custom:HeroEffectPriority()
	return 99999
end





function modifier_sven_gods_strength_custom:OnCreated( kv )
self.gods_strength_damage = self:GetAbility():GetSpecialValueFor( "damage" )


self.regen = self:GetCaster():GetTalentValue("modifier_sven_god_2", "heal")
self.move = self:GetCaster():GetTalentValue("modifier_sven_god_2", "move")

self.stack_max = self:GetCaster():GetTalentValue("modifier_sven_god_4", "max")
self.str_bonus = self:GetCaster():GetTalentValue("modifier_sven_god_4", "str")
self.speed = self:GetCaster():GetTalentValue("modifier_sven_god_4", "speed")/100

if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_sven_gods_strength_custom_damage")
if mod then 
	mod:SetDuration(9999, true)
end 

self.RemoveForDuel = true
--[[local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_sven/sven_spell_gods_strength_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon" , self:GetParent():GetOrigin(), true )
ParticleManager:SetParticleControlEnt( nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head" , self:GetParent():GetOrigin(), true )
self:AddParticle( nFXIndex, false, false, -1, false, true )
]]--
self:GetParent():CalculateStatBonus(true)

end










function modifier_sven_gods_strength_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end


function modifier_sven_gods_strength_custom:GetModifierMoveSpeedBonus_Constant()
 return	self.move
end


function modifier_sven_gods_strength_custom:GetModifierBonusStats_Strength()
if not self:GetParent():HasModifier("modifier_sven_god_4") then return end
return	self.str_bonus*self:GetStackCount() 
end




function modifier_sven_gods_strength_custom:GetModifierBaseDamageOutgoing_Percentage()
	return self.gods_strength_damage
end

function modifier_sven_gods_strength_custom:GetModifierAttackSpeedBonus_Constant()
if not self:GetParent():HasModifier("modifier_sven_god_4") then return end
	return self:GetParent():GetStrength()*self.speed
end




function modifier_sven_gods_strength_custom:GetModifierHealthRegenPercentage()
if not self:GetParent():HasModifier("modifier_sven_god_2") then return end

return self.regen
end


function modifier_sven_gods_strength_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self:GetParent():EmitSound("Hero_Sven.Layer.GodsStrength")

if not self:GetParent():HasModifier("modifier_sven_god_4") then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if self:GetStackCount() >= self.stack_max then return end

self:IncrementStackCount()

local mod = self:GetParent():FindModifierByName("modifier_sven_gods_strength")

if mod then 
	mod:IncrementStackCount()
end 

self:GetParent():CalculateStatBonus(true)
end



function modifier_sven_gods_strength_custom:OnTakeDamage(params)
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_sven_god_2") then return end
if self:GetParent() ~= params.attacker then return end
if params.inflictor then return end
if not params.unit then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end

local heal = self:GetAbility().heal_inc[self:GetParent():GetUpgradeStack("modifier_sven_god_2")]*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility())

end


function modifier_sven_gods_strength_custom:OnDestroy()
if not IsServer() then return end 

local mod = self:GetParent():FindModifierByName("modifier_sven_gods_strength_custom_damage")
if mod then 
	mod:SetDuration(self:GetCaster():GetTalentValue("modifier_sven_god_1", "duration"), true)
end 

end 




 

modifier_sven_gods_strength_custom_root = class({})
function modifier_sven_gods_strength_custom_root:IsHidden() return false end
function modifier_sven_gods_strength_custom_root:IsPurgable() return true end
function modifier_sven_gods_strength_custom_root:GetTexture() return "buffs/hook_root" end


function modifier_sven_gods_strength_custom_root:CheckState()
return
{
    [MODIFIER_STATE_ROOTED] = true
}
end




function modifier_sven_gods_strength_custom_root:OnCreated(table)
if not IsServer() then return end

local parent = self:GetParent()

self.nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/hook_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
ParticleManager:SetParticleControl( self.nFXIndex, 0, parent:GetAbsOrigin() )
self:AddParticle(self.nFXIndex, false, false, -1, false, false)

end




modifier_sven_gods_strength_custom_tracker = class({})
function modifier_sven_gods_strength_custom_tracker:IsHidden() return true end
function modifier_sven_gods_strength_custom_tracker:IsPurgable() return false end
function modifier_sven_gods_strength_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_MODEL_SCALE,
   -- MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}

end



function modifier_sven_gods_strength_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end

if not self:GetParent():HasModifier("modifier_sven_god_6") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:GetName() == "sven_great_cleave_custom" then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if not RollPseudoRandomPercentage(self:GetAbility().proc_chance_cast ,328,self:GetParent()) then return end

self:ProcUlt()

end




function modifier_sven_gods_strength_custom_tracker:GetModifierModelScale()
if self:GetStackCount() < self:GetCaster():GetTalentValue("modifier_sven_god_7", "max", true) then return end

return 20
end



function modifier_sven_gods_strength_custom_tracker:OnCreated(table)
if not IsServer() then return end
self.active = 0
self.damage_count = 0
self.max = false

self:StartIntervalThink(1)
end




function modifier_sven_gods_strength_custom_tracker:OnTakeDamage( params )
if not IsServer() then return end


if self:GetParent() == params.unit and not self:GetParent():PassivesDisabled() and not self:GetParent():HasModifier("modifier_death") and self:GetParent():HasModifier("modifier_sven_god_6")
	and self:GetParent():GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_sven_god_6", "health") and not self:GetParent():HasModifier("modifier_sven_gods_strength_custom_proc_cd") then 

	self:GetParent():Purge(false, true, false, true, false)

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sven_gods_strength_custom_proc_cd", {duration = self:GetCaster():GetTalentValue("modifier_sven_god_6", "cd")})
	self:ProcUlt()
end




if not self:GetParent():HasModifier("modifier_sven_god_7") then return end

local health = self:GetCaster():GetTalentValue("modifier_sven_god_7", "health")
local range = self:GetCaster():GetTalentValue("modifier_sven_god_7", "range")
local delay = self:GetCaster():GetTalentValue("modifier_sven_god_7", "delay")


if (self:GetParent() == params.unit or self:GetParent() == params.attacker) and

	(self:GetParent():GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() < range and 
	(not params.inflictor or not params.inflictor:IsItem()) and
	(not params.unit:IsBuilding() and not params.attacker:IsBuilding()) then 

	self:StartIntervalThink(delay)
end


if params.unit ~= self:GetParent() then return end

local damage = params.damage

while damage > 0 do 
	self.damage_count = damage + self.damage_count


	if self.damage_count < health then 
	    damage = 0
    else 
	    damage = self.damage_count - health
	    self.damage_count = 0

		self:AddLegendaryStack(0)
		self:StartIntervalThink(delay)
	end
end


end





function modifier_sven_gods_strength_custom_tracker:AddLegendaryStack(active)
if not IsServer() then return end

self:StartIntervalThink(self:GetCaster():GetTalentValue("modifier_sven_god_7", "delay"))

if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_sven_god_7", "max") then return end
self:IncrementStackCount()

if self:GetParent():HasModifier("modifier_sven_gods_strength_custom") and active == 0 then 
	--self:AddLegendaryStack(1)
end

end





function modifier_sven_gods_strength_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_sven_god_7") then 
	return	
else 
	if self.active == 0 then 
		self.active = 1 
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'sven_rage_change',  {max = self:GetCaster():GetTalentValue("modifier_sven_god_7", "max"), current = self:GetStackCount()})

	end
end


self.damage_count = 0
if self:GetStackCount() == 0 then return end

self:DecrementStackCount()

self:StartIntervalThink(0.2)
end




function modifier_sven_gods_strength_custom_tracker:OnStackCountChanged(iStackCount)
if not IsServer() then return end

local ability = self:GetParent():FindAbilityByName("sven_gods_strength_custom_legendary")

if ability then 
	if self:GetStackCount() > 0 then 
		ability:SetActivated(true)
	else 
		ability:SetActivated(false)
	end
end

local max_stack = self:GetCaster():GetTalentValue("modifier_sven_god_7", "max")


if self:GetStackCount() > 0 then 

	if not self.particle then 
		self.particle = ParticleManager:CreateParticle("particles/sven_rage.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(self.particle, false, false, -1, false, false)
	end

	local max = max_stack/2
	local s = math.floor(self:GetStackCount()/2)


	for i = 1,max do 
	
		if i <= s then 
			ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))	
		else 
			ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))	
		end
	end


else 
	if self.particle then 
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end

end

if self:GetStackCount() >= max_stack and self.max == false then 
	self.max = true 

	self:GetParent():EmitSound("Sven.God_legendary_active")


	self.effect_cast = ParticleManager:CreateParticle( "particles/mars_shield_legendary.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControlEnt( self.effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.effect_cast, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_shield", self:GetParent():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.effect_cast, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_weapon", self:GetParent():GetAbsOrigin(), true )
	self:AddParticle(self.effect_cast,false, false, -1, false, false)
end


if self:GetStackCount() < max_stack and self.max == true then 
	self.max = false
	
	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
end


CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'sven_rage_change',  {max = max_stack, current = self:GetStackCount()})
end




function modifier_sven_gods_strength_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

if self:GetParent():HasModifier("modifier_sven_god_7") and not self:GetParent():HasModifier("modifier_sven_gods_strength_custom_crit") then 
	self:AddLegendaryStack(0)
end

if self:GetParent():HasModifier("modifier_sven_god_1") then 

	local duration = self:GetCaster():GetTalentValue("modifier_sven_god_1", "duration")

	if self:GetCaster():HasModifier("modifier_sven_gods_strength_custom") then 
		duration = 9999
	end

	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sven_gods_strength_custom_damage", {duration = duration})
end 


if true then return end
if not self:GetParent():HasModifier("modifier_sven_god_6") then return end
--if self:GetParent():HasModifier("modifier_sven_gods_strength_custom_crit") then return end
if not params.target:IsRealHero() and not params.target:IsIllusion() then return end
if not RollPseudoRandomPercentage(self:GetAbility().proc_chance_attack ,321,self:GetParent()) then return end

self:ProcUlt()

end



function modifier_sven_gods_strength_custom_tracker:ProcUlt()
if not IsServer() then return end

self:GetParent():EmitSound("Sven.God_proc")
self:GetParent():EmitSound("Sven.God_proc2")
local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)


local mod = self:GetParent():FindModifierByName("modifier_sven_gods_strength_custom")
local dota_mod = self:GetParent():FindModifierByName("modifier_sven_gods_strength")

local duration = self:GetCaster():GetTalentValue("modifier_sven_god_6", "duration")

local max_duration = self:GetAbility():GetSpecialValueFor("gods_strength_duration") + self:GetCaster():GetTalentValue("modifier_sven_god_3", "duration")


if mod then 
	mod:SetDuration(math.min(max_duration + duration, mod:GetRemainingTime() +duration), true)

	if dota_mod then 

		dota_mod:SetDuration(math.min(max_duration + duration, dota_mod:GetRemainingTime() +duration), true)
	end 

else 
	self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_sven_gods_strength_custom", { duration = duration }  )
	self:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_sven_gods_strength", { duration = duration }  )


end

end





sven_gods_strength_custom_legendary = class({})


function sven_gods_strength_custom_legendary:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_gods_strength_custom_crit_anim", {})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_gods_strength_custom_crit_anim2", {})
self:GetCaster():StartGesture(ACT_DOTA_ATTACK)

self:GetCaster():EmitSound("Sven.Cleave_wave_pre")
self:GetCaster():EmitSound("Sven.God_crit_cast")
return true
end



function sven_gods_strength_custom_legendary:OnAbilityPhaseInterrupted()
if not IsServer() then return end

self:GetCaster():RemoveModifierByName("modifier_sven_gods_strength_custom_crit_anim")
self:GetCaster():RemoveModifierByName("modifier_sven_gods_strength_custom_crit_anim2")

self:GetCaster():FadeGesture(ACT_DOTA_ATTACK)

end




function sven_gods_strength_custom_legendary:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Sven.Cleave_wave_cast")
self:GetCaster():EmitSound("Sven.God_crit_ground")

self:GetCaster():EmitSound("Sven.God_legendary_active_voice")

self:GetCaster():RemoveModifierByName("modifier_sven_gods_strength_custom_crit_anim")
self:GetCaster():RemoveModifierByName("modifier_sven_gods_strength_custom_crit_anim2")

--self:GetCaster():FadeGesture(ACT_DOTA_ATTACK)

local ability = self:GetCaster():FindAbilityByName("sven_gods_strength_custom")
if not ability or ability:GetLevel() < 1 then return end

local mod = self:GetCaster():FindModifierByName("modifier_sven_gods_strength_custom_tracker")
if not mod then return end

local max_stack = self:GetCaster():GetTalentValue("modifier_sven_god_7", "max")

local rage = mod:GetStackCount()

local fxRange = 400
local direction = self:GetCaster():GetForwardVector()

local fxPoint = self:GetCaster():GetAbsOrigin() + (direction * fxRange)

local part = "particles/sven_god_normal_cleave.vpcf"

if rage >= max_stack then 

	self:GetCaster():EmitSound("Sven.God_crit_ground_max")

	part = "particles/sven_god_cleave.vpcf"

	local particleName = "particles/sven_god_cleave_2.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, fxPoint)


end

local fxIndex = ParticleManager:CreateParticle(part, PATTACH_CUSTOMORIGIN,  self:GetCaster() )
ParticleManager:SetParticleControl(fxIndex, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:SetParticleControlForward(fxIndex, 0, direction)


local caster = self:GetCaster()


local radius = 450
local angle = 50

local stun = self:GetCaster():GetTalentValue("modifier_sven_god_7", "stun")
local crit = (self:GetCaster():GetTalentValue("modifier_sven_god_7", "damage") - 100)/max_stack

local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

local origin = caster:GetOrigin()
local cast_direction =  self:GetCaster():GetForwardVector()
cast_direction.z = 0

local cast_angle = VectorToAngles( cast_direction ).y

local mod_crit = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_gods_strength_custom_crit", {crit = crit*rage, duration = FrameTime()*2})
local mod_cleave = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_no_cleave", {duration = FrameTime()*2})



for _,enemy in pairs(enemies) do

    if enemy:GetUnitName() ~= "npc_teleport" and enemy:GetUnitName() ~= "modifier_monkey_king_wukongs_command_custom_soldier" then  

      local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
      local enemy_angle = VectorToAngles( enemy_direction ).y
      local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
      if angle_diff<=angle then
     
     	if  rage >= max_stack then 
      		enemy:AddNewModifier(self:GetCaster(), self, "modifier_bashed", {duration = stun*(1 - enemy:GetStatusResistance())})
      	end 
        caster:PerformAttack(enemy, true, true, true, true, true, false, true )

		local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"

		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, enemy )
		ParticleManager:SetParticleControl( effect_cast, 0, enemy:GetOrigin() )
		ParticleManager:SetParticleControl( effect_cast, 1, enemy:GetOrigin() )
		ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
		ParticleManager:ReleaseParticleIndex( effect_cast )



		local particle = ParticleManager:CreateParticle( "particles/sven_wave_god_damage.vpcf", PATTACH_POINT_FOLLOW, enemy )
		ParticleManager:SetParticleControlEnt( particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
		ParticleManager:ReleaseParticleIndex( particle )
		
		enemy:EmitSound("Sven.Cry_shield_damage")

      end
    end
end

self:GetCaster():RemoveModifierByName("modifier_sven_gods_strength_custom_crit")
self:GetCaster():RemoveModifierByName("modifier_no_cleave")

mod:SetStackCount(0)

end



modifier_sven_gods_strength_custom_crit = class({})
function modifier_sven_gods_strength_custom_crit:IsHidden() return true end
function modifier_sven_gods_strength_custom_crit:IsPurgable() return false end
function modifier_sven_gods_strength_custom_crit:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
}
end

function modifier_sven_gods_strength_custom_crit:OnCreated(table)
if not IsServer() then return end

self.crit = table.crit + 100
end


function modifier_sven_gods_strength_custom_crit:GetCritDamage() 
return self.crit
end

function modifier_sven_gods_strength_custom_crit:GetModifierPreAttack_CriticalStrike()
return self.crit
end



modifier_sven_gods_strength_custom_crit_anim = class({})
function modifier_sven_gods_strength_custom_crit_anim:IsHidden() return true end
function modifier_sven_gods_strength_custom_crit_anim:IsPurgable() return false end
function modifier_sven_gods_strength_custom_crit_anim:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_sven_gods_strength_custom_crit_anim:GetActivityTranslationModifiers()
return "sven_warcry"
end


modifier_sven_gods_strength_custom_crit_anim2 = class({})
function modifier_sven_gods_strength_custom_crit_anim2:IsHidden() return true end
function modifier_sven_gods_strength_custom_crit_anim2:IsPurgable() return false end
function modifier_sven_gods_strength_custom_crit_anim2:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end

function modifier_sven_gods_strength_custom_crit_anim2:GetActivityTranslationModifiers()
return "sven_shield"
end





modifier_sven_gods_strength_custom_proc_cd = class({})
function modifier_sven_gods_strength_custom_proc_cd:IsHidden() return false end
function modifier_sven_gods_strength_custom_proc_cd:IsPurgable() return false end 
function modifier_sven_gods_strength_custom_proc_cd:RemoveOnDeath() return false end
function modifier_sven_gods_strength_custom_proc_cd:OnCreated(table)

self.RemoveForDuel = true 
end
function modifier_sven_gods_strength_custom_proc_cd:IsDebuff() return true end
function modifier_sven_gods_strength_custom_proc_cd:GetTexture() return "buffs/god_proc" end



modifier_sven_gods_strength_custom_damage = class({})
function modifier_sven_gods_strength_custom_damage:IsHidden() return false end
function modifier_sven_gods_strength_custom_damage:IsPurgable() return false end
function modifier_sven_gods_strength_custom_damage:GetTexture() return "buffs/spear_str" end
function modifier_sven_gods_strength_custom_damage:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_sven_god_1", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_sven_god_1", "damage")
self.bonus = self:GetCaster():GetTalentValue("modifier_sven_god_1", 'bonus')

if not IsServer() then return end 

self:SetStackCount(1)
end 
function modifier_sven_gods_strength_custom_damage:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end



function modifier_sven_gods_strength_custom_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_sven_gods_strength_custom_damage:GetModifierModelScale()
return self:GetStackCount()*2
end



function modifier_sven_gods_strength_custom_damage:GetModifierBaseDamageOutgoing_Percentage()
local bonus = 1
if self:GetParent():HasModifier("modifier_sven_gods_strength_custom") then 
	bonus = self.bonus
end 

return (self:GetStackCount()*self.damage)*bonus
end