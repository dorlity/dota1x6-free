LinkLuaModifier( "modifier_axe_culling_blade_custom", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_tracker", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_attack_kill", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_execute", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_kills", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_aegis", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_no_bonus", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_lowhp", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_slow", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_culling_blade_custom_slow_lendary", "abilities/axe/axe_culling_blade_custom", LUA_MODIFIER_MOTION_NONE )

axe_culling_blade_custom = class({})

axe_culling_blade_custom.lowhp_radius = 500
axe_culling_blade_custom.lowhp_health = 50
axe_culling_blade_custom.lowhp_attack = {30, 45, 60}
axe_culling_blade_custom.lowhp_move = {10, 15, 20}


axe_culling_blade_custom.execute_max = 6
axe_culling_blade_custom.execute_duration = 6
axe_culling_blade_custom.execute_damage = {0.4, 0.6}

axe_culling_blade_custom.kills_spell_damage = 4
axe_culling_blade_custom.kills_spell_damage_max = 8
axe_culling_blade_custom.kills_spell_heal = 0.2
axe_culling_blade_custom.kills_spell_heal_creeps = 0.25


axe_culling_blade_custom.reduce_heal = -5
axe_culling_blade_custom.reduce_move = -5
axe_culling_blade_custom.reduce_max = 6
axe_culling_blade_custom.reduce_duration = 3


axe_culling_blade_custom.heal_health = 50
axe_culling_blade_custom.heal_range = 500
axe_culling_blade_custom.heal_amount = {1, 1.5, 2}


axe_culling_blade_custom.damage = {0.03, 0.05, 0.07}

axe_culling_blade_custom_legendary = class({})


axe_culling_blade_custom_legendary.save_mods = 
{
	[""] = true,
}



function axe_culling_blade_custom_legendary:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_culling_blade.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf", context )
PrecacheResource( "particle", "particles/axe_culling_stack.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_start.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_overwhelming_end.vpcf", context )
PrecacheResource( "particle", "particles/axe_execute.vpcf", context )
PrecacheResource( "particle", "particles/axe_exe.vpcf", context )
PrecacheResource( "particle", "particles/brist_lowhp_.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf", context )
PrecacheResource( "particle", "particles/axe_slow.vpcf", context )

end







function axe_culling_blade_custom:GetManaCost(level)
if self:GetCaster():HasModifier("modifier_axe_culling_blade_custom_execute") then 
return 0
end

return self.BaseClass.GetManaCost(self,level) 
end


function axe_culling_blade_custom:GetIntrinsicModifierName()
return "modifier_axe_culling_blade_custom_tracker"
end




function axe_culling_blade_custom:OnSpellStart(new_target)
	if not IsServer() then return end
	local target = self:GetCursorTarget()

	if new_target then 
		target = new_target
	end



	local mod_ex = self:GetCaster():FindModifierByName("modifier_axe_culling_blade_custom_execute")

	local k = 1

	local damage = self:GetSpecialValueFor("damage")


	if self:GetCaster():HasModifier("modifier_axe_culling_3") then 
		damage = damage + self.damage[self:GetCaster():GetUpgradeStack("modifier_axe_culling_3")]*target:GetMaxHealth()
	end


	if not target:HasModifier("modifier_custom_juggernaut_healing_ward_reduction_aura") then 

		kill_mod = target:AddNewModifier(target, nil, "modifier_death", {})
		kill_mod_2 = target:AddNewModifier(target, nil, "modifier_axe_culling_blade_custom_aegis", {})
	end

	if target:GetHealth() > damage or target:HasModifier("modifier_custom_juggernaut_healing_ward_reduction_aura") then 

		if mod_ex then 
			damage = damage*self.execute_damage[self:GetCaster():GetUpgradeStack("modifier_axe_culling_4")]
		end

		ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self, })	
	else 
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_culling_blade_custom_no_bonus", {})
		self:CullingBladeKill(target, true)
		target:Kill(self, self:GetCaster())
		self:GetCaster():RemoveModifierByName("modifier_axe_culling_blade_custom_no_bonus")
	end

	if not target:HasModifier("modifier_custom_juggernaut_healing_ward_reduction_aura") then 
		kill_mod:Destroy()
		kill_mod_2:Destroy()
	end
	
		

	if mod_ex  then 
		mod_ex:Destroy()
		self:EndCooldown()
	end	

end





function axe_culling_blade_custom:CullingBladeKill(target, success)
if not IsServer() then return end


local direction = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

local particle_cast = ""
local sound_cast = ""

if success then
	particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf"
	sound_cast = "Hero_Axe.Culling_Blade_Success"
else
	particle_cast = "particles/units/heroes/hero_axe/axe_culling_blade.vpcf"
	sound_cast = "Hero_Axe.Culling_Blade_Fail"
end

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )
target:EmitSound(sound_cast)


local duration = self:GetSpecialValueFor("speed_duration")


if success then

	self:EndCooldown()

	if target:IsValidKill(self:GetCaster()) then 

		if self:GetCaster():GetQuest() == "Axe.Quest_8" then 
			self:GetCaster():UpdateQuest(1)
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_culling_blade_custom_kills", {})
	end

	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_axe_culling_blade_custom", { duration = duration } )

end





end







modifier_axe_culling_blade_custom = class({})

function modifier_axe_culling_blade_custom:IsPurgable()
	return true
end

function modifier_axe_culling_blade_custom:OnCreated( kv )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "atk_speed_bonus" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end

function modifier_axe_culling_blade_custom:OnRefresh( kv )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "atk_speed_bonus" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end

function modifier_axe_culling_blade_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_axe_culling_blade_custom:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_bonus
end

function modifier_axe_culling_blade_custom:GetModifierAttackSpeedBonus_Constant()
	return self.as_bonus 
end

function modifier_axe_culling_blade_custom:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
end

function modifier_axe_culling_blade_custom:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_axe_culling_blade_custom_tracker = class({})
function modifier_axe_culling_blade_custom_tracker:IsHidden() return true end
function modifier_axe_culling_blade_custom_tracker:IsPurgable() return false end
function modifier_axe_culling_blade_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_axe_culling_blade_custom_tracker:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(1)
end



function modifier_axe_culling_blade_custom_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_axe_culling_1") and not self:GetParent():HasModifier("modifier_axe_culling_2") then return end

local units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility().lowhp_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 0, false )
local buff = false

for _,unit in pairs(units) do
	if unit:GetHealthPercent() <= self:GetAbility().lowhp_health then 
		buff = true
		break
	end
end

if buff == true and not self:GetParent():HasModifier("modifier_axe_culling_blade_custom_lowhp") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_axe_culling_blade_custom_lowhp", {})
end

if buff == false and self:GetParent():HasModifier("modifier_axe_culling_blade_custom_lowhp") then 
	self:GetParent():RemoveModifierByName("modifier_axe_culling_blade_custom_lowhp")
end

self:StartIntervalThink(0.2)
end


function modifier_axe_culling_blade_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end


if not params.inflictor then return end
if params.inflictor ~= self:GetAbility() and 
params.inflictor ~= self:GetParent():FindAbilityByName("axe_culling_blade_custom_legendary") then return end
if self:GetCaster():HasModifier("modifier_axe_culling_blade_custom_no_bonus") then return end

local success = false
local target = params.unit


if target:GetHealth()<=1 and not target:HasModifier("modifier_custom_juggernaut_healing_ward_reduction_aura") then 
	success = true
end
self:GetAbility():CullingBladeKill(target, success)

end


function modifier_axe_culling_blade_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

if self:GetParent():HasModifier("modifier_axe_culling_5") then
	params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_axe_culling_blade_custom_slow", {duration = self:GetAbility().reduce_duration})
end


if not self:GetParent():HasModifier("modifier_axe_culling_4") then return end
if self:GetParent():HasModifier("modifier_axe_culling_blade_custom_execute") then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_axe_culling_blade_custom_attack_kill", {duration = self:GetAbility().execute_duration})

end

modifier_axe_culling_blade_custom_attack_kill = class({})
function modifier_axe_culling_blade_custom_attack_kill:IsHidden() return false end
function modifier_axe_culling_blade_custom_attack_kill:IsPurgable() return false end
function modifier_axe_culling_blade_custom_attack_kill:GetTexture() return "buffs/culling_attack" end


function modifier_axe_culling_blade_custom_attack_kill:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self:SetStackCount(1)
end

function modifier_axe_culling_blade_custom_attack_kill:OnRefresh(table)
if not IsServer() then return end

if self:GetStackCount() >= self:GetAbility().execute_max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().execute_max then 
    self:GetCaster():EmitSound("Axe.Culling_execute")
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_culling_blade_custom_execute", {duration = self:GetAbility().execute_duration})
	self:Destroy()
end

end



function modifier_axe_culling_blade_custom_attack_kill:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

    local particle_cast = "particles/axe_culling_stack.vpcf"

    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

    self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end





function axe_culling_blade_custom_legendary:OnAbilityPhaseStart()
if not IsServer() then return end

--if self:GetCursorTarget():GetHealthPercent() < self:GetSpecialValueFor("health") then 
--CustomGameEventManager:Send_ServerToPlayer(1PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "culling_health"})

--return false
--end

return true
end

function axe_culling_blade_custom_legendary:OnSpellStart()
if not IsServer() then return end

if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end

local ability = self:GetCaster():FindAbilityByName("axe_culling_blade_custom")

if ability then 

	local duration = ability:GetSpecialValueFor("speed_duration")


	self:GetCaster():AddNewModifier( self:GetCaster(), ability, "modifier_axe_culling_blade_custom", { duration = duration } )

end



local target =  self:GetCursorTarget()
local direction = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

local old_pos = self:GetCaster():GetAbsOrigin()
    

local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, old_pos)

FindClearSpaceForUnit(self:GetCaster(), self:GetCursorTarget():GetAbsOrigin(), true)
ProjectileManager:ProjectileDodge(self:GetCaster())

effect = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())

local damage = self:GetCursorTarget():GetMaxHealth()*self:GetSpecialValueFor("damage")/100

if target:IsCreep() then 
	damage = damage/3
end

ApplyDamage({ victim = self:GetCursorTarget(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self, })

if not target:IsMagicImmune() then 
	target:AddNewModifier(self:GetCaster(), self, "modifier_axe_culling_blade_custom_slow_lendary", {duration = 0.5})
end


local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_culling_blade_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:SetParticleControl( effect_cast, 4, target:GetOrigin() )
ParticleManager:SetParticleControlForward( effect_cast, 3, direction )
ParticleManager:SetParticleControlForward( effect_cast, 4, direction )
ParticleManager:ReleaseParticleIndex( effect_cast )
target:EmitSound("Hero_Axe.Culling_Blade_Success")

if target:GetHealthPercent() > self:GetSpecialValueFor("health") then 
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cd_low"))
end

end



modifier_axe_culling_blade_custom_execute = class({})
function modifier_axe_culling_blade_custom_execute:IsHidden() return false end
function modifier_axe_culling_blade_custom_execute:IsPurgable() return false end
function modifier_axe_culling_blade_custom_execute:GetTexture() return "buffs/culling_execute" end

function modifier_axe_culling_blade_custom_execute:GetEffectName()  
return "particles/axe_execute.vpcf"
end

function modifier_axe_culling_blade_custom_execute:OnCreated()
if not IsServer() then return end
self.particle_peffect = ParticleManager:CreateParticle("particles/axe_exe.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())	
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
end

function modifier_axe_culling_blade_custom_execute:OnDestroy()
if not IsServer() then return end
if not self.particle_peffect then return end

ParticleManager:DestroyParticle(self.particle_peffect, false)
   ParticleManager:ReleaseParticleIndex(self.particle_peffect)
end







modifier_axe_culling_blade_custom_kills = class({})
function modifier_axe_culling_blade_custom_kills:IsHidden() return false end
function modifier_axe_culling_blade_custom_kills:IsPurgable() return false end
function modifier_axe_culling_blade_custom_kills:GetTexture() return "buffs/culling_kills" end
function modifier_axe_culling_blade_custom_kills:RemoveOnDeath() return false end
function modifier_axe_culling_blade_custom_kills:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_TOOLTIP2
}
end


function modifier_axe_culling_blade_custom_kills:OnTooltip2()
if not self:GetCaster():HasModifier("modifier_axe_culling_6") then return end
if self:GetStackCount() < self:GetAbility().kills_spell_damage_max then return end

return self:GetAbility().kills_spell_heal*100
end


function modifier_axe_culling_blade_custom_kills:OnTakeDamage( params )
if not self:GetCaster():HasModifier("modifier_axe_culling_6") then return end
if self:GetStackCount() < self:GetAbility().kills_spell_damage_max then return end
if self:GetParent() == params.unit and self:GetParent():IsIllusion() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

if self:GetParent() ~= params.attacker then return end
if not params.inflictor then return end
if params.unit:IsBuilding() or params.unit:IsIllusion() then return end

local heal = params.damage*self:GetAbility().kills_spell_heal

if params.unit:IsCreep() then 
	heal = heal*self:GetAbility().kills_spell_heal_creeps
end


self:GetParent():Heal(heal, self:GetAbility())

local particle = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )


end




function modifier_axe_culling_blade_custom_kills:GetModifierSpellAmplify_Percentage()
if not self:GetCaster():HasModifier("modifier_axe_culling_6") then
	return 0
end

local stack = math.min(self:GetStackCount(), self:GetAbility().kills_spell_damage_max)

return stack*self:GetAbility().kills_spell_damage
end

function modifier_axe_culling_blade_custom_kills:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_axe_culling_blade_custom_kills:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor("armor_bonus")*self:GetStackCount()
end


function modifier_axe_culling_blade_custom_kills:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() == self:GetAbility().kills_spell_damage_max then 

	local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_peffect)
	self:GetCaster():EmitSound("BS.Thirst_legendary_active")

end

end
function modifier_axe_culling_blade_custom_kills:OnTooltip()
return self:GetStackCount()
end

modifier_axe_culling_blade_custom_aegis = class({})
function modifier_axe_culling_blade_custom_aegis:IsHidden() return true end
function modifier_axe_culling_blade_custom_aegis:IsPurgable() return false end



modifier_axe_culling_blade_custom_no_bonus = class({})
function modifier_axe_culling_blade_custom_no_bonus:IsHidden() return true end
function modifier_axe_culling_blade_custom_no_bonus:IsPurgable() return false end








modifier_axe_culling_blade_custom_lowhp = class({})

function modifier_axe_culling_blade_custom_lowhp:IsPurgable()
	return true
end

function modifier_axe_culling_blade_custom_lowhp:OnCreated( kv )



if self:GetCaster():HasModifier("modifier_axe_culling_1") then
	self.as_bonus = self:GetAbility().lowhp_attack[self:GetCaster():GetUpgradeStack("modifier_axe_culling_1")]
	self.ms_bonus = self:GetAbility().lowhp_move[self:GetCaster():GetUpgradeStack("modifier_axe_culling_1")]
end

if self:GetCaster():HasModifier("modifier_axe_culling_2") then
	self.heal = self:GetAbility().heal_amount[self:GetCaster():GetUpgradeStack("modifier_axe_culling_2")]
end

end


function modifier_axe_culling_blade_custom_lowhp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}

	return funcs
end


function modifier_axe_culling_blade_custom_lowhp:GetTexture() return
	"buffs/culling_lowhp"
end

function modifier_axe_culling_blade_custom_lowhp:GetModifierMoveSpeedBonus_Percentage()
if not self:GetCaster():HasModifier("modifier_axe_culling_1") then return end
	return self.ms_bonus
end

function modifier_axe_culling_blade_custom_lowhp:GetModifierAttackSpeedBonus_Constant()
if not self:GetCaster():HasModifier("modifier_axe_culling_1") then return end
	return self.as_bonus 
end


function modifier_axe_culling_blade_custom_lowhp:GetModifierHealthRegenPercentage()
if not self:GetCaster():HasModifier("modifier_axe_culling_2") then return end
	return self.heal
end



function modifier_axe_culling_blade_custom_lowhp:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
end

function modifier_axe_culling_blade_custom_lowhp:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end




modifier_axe_culling_blade_custom_slow = class({})
function modifier_axe_culling_blade_custom_slow:IsHidden() return false end
function modifier_axe_culling_blade_custom_slow:IsPurgable() return false end
function modifier_axe_culling_blade_custom_slow:GetTexture() return "buffs/culling_execute" end
function modifier_axe_culling_blade_custom_slow:GetEffectName() return "particles/items2_fx/sange_maim.vpcf" end
function modifier_axe_culling_blade_custom_slow:OnCreated(table)

self.heal = self:GetAbility().reduce_heal
self.slow = self:GetAbility().reduce_move

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_axe_culling_blade_custom_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >=  self:GetAbility().reduce_max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().reduce_max then 

	self:GetParent():EmitSound("DOTA_Item.Maim")

    self.effect_cast = ParticleManager:CreateParticle( "particles/axe_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

    self:AddParticle(self.effect_cast,false, false, -1, false, false)
end

end


function modifier_axe_culling_blade_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end


function modifier_axe_culling_blade_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self.slow
end

function modifier_axe_culling_blade_custom_slow:GetModifierLifestealRegenAmplify_Percentage()
	return self:GetStackCount()*self.heal
end

function modifier_axe_culling_blade_custom_slow:GetModifierHealAmplify_PercentageTarget()
	return self:GetStackCount()*self.heal
end

function modifier_axe_culling_blade_custom_slow:GetModifierHPRegenAmplify_Percentage()
	return self:GetStackCount()*self.heal
end


modifier_axe_culling_blade_custom_slow_lendary = class({})
function modifier_axe_culling_blade_custom_slow_lendary:IsHidden() return true end
function modifier_axe_culling_blade_custom_slow_lendary:IsPurgable() return true end
function modifier_axe_culling_blade_custom_slow_lendary:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_axe_culling_blade_custom_slow_lendary:GetModifierMoveSpeedBonus_Percentage()
return -100
end