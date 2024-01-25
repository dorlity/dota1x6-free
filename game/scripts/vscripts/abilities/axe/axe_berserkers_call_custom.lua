LinkLuaModifier( "modifier_axe_berserkers_call_custom_buff", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_debuff", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_tracker", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_auto_cd", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_speed", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_slow", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_legendary", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_heal", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_custom_armor", "abilities/axe/axe_berserkers_call_custom", LUA_MODIFIER_MOTION_NONE )

axe_berserkers_call_custom = class({})









function axe_berserkers_call_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_attack_blur_counterhelix.vpcf", context )
    
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", context )
PrecacheResource( "particle", "particles/axe_aggro.vpcf", context )
PrecacheResource( "particle", "particles/star_shield.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context )
PrecacheResource( "particle", "particles/qop_linken.vpcf", context )
PrecacheResource( "particle", "particles/axe_slow.vpcf", context )

end





function axe_berserkers_call_custom:GetIntrinsicModifierName()
return "modifier_axe_berserkers_call_custom_tracker"
end

function axe_berserkers_call_custom:OnAbilityPhaseInterrupted()
	self:GetCaster():StopSound("Hero_Axe.BerserkersCall.Start")
end

function axe_berserkers_call_custom:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Axe.BerserkersCall.Start")
	return true
end

function axe_berserkers_call_custom:GetCastPoint()
local bonus = 0

if self:GetCaster():HasModifier("modifier_axe_call_5") then 
	bonus = self:GetCaster():GetTalentValue("modifier_axe_call_5", "cast")
end

	return self:GetSpecialValueFor("AbilityCastPoint") + bonus
end





function axe_berserkers_call_custom:GetCooldown(level)
	if self:GetCaster():HasScepter() then
		return self.BaseClass.GetCooldown( self, level ) - self:GetSpecialValueFor("scepter_cd")
	end
    return self.BaseClass.GetCooldown( self, level )
end

function axe_berserkers_call_custom:OnSpellStart()
if not IsServer() then return end

duration = self:GetSpecialValueFor("duration")

if self:GetCaster():HasModifier("modifier_axe_call_legendary") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_axe_call_legendary", "duration")*(1 - self:GetCaster():GetHealthPercent()/100)
end

if self:GetCaster():HasModifier("modifier_axe_call_2") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_axe_berserkers_call_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_axe_call_2", "duration")})
end 

self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_axe_berserkers_call_custom_buff", { duration = duration } )
self:GetCaster():EmitSound("Hero_Axe.Berserkers_Call")
local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_axe/axe_beserkers_call_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt( effect_cast, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_mouth", Vector(0,0,0), true )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:EndCooldown()
self:SetActivated(false)
end














modifier_axe_berserkers_call_custom_buff = class({})

function modifier_axe_berserkers_call_custom_buff:IsPurgable()
	return false
end

function modifier_axe_berserkers_call_custom_buff:OnCreated( kv )
self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )

self.damage_reduce = self:GetCaster():GetTalentValue("modifier_axe_call_5", "damage_reduce")
self.status = self:GetCaster():GetTalentValue("modifier_axe_call_5", "status")

self.armor_duration = self:GetCaster():GetTalentValue("modifier_axe_call_1", "duration")

self.attack_speed = self:GetCaster():GetTalentValue("modifier_axe_call_3", "speed")

self.legendary_speed = self:GetCaster():GetTalentValue("modifier_axe_call_legendary", "speed")

self.after_damage = self:GetCaster():GetTalentValue("modifier_axe_call_4", "damage")/100
self.after_heal = self:GetCaster():GetTalentValue("modifier_axe_call_4", "heal")/100

self.return_damage = self:GetCaster():GetTalentValue("modifier_axe_call_1", "damage_return")/100

if not IsServer() then return end

self.targets = {}

self.time = self:GetRemainingTime()

self.first = true
self:Taunt()

if self:GetCaster():HasModifier("modifier_axe_call_legendary") then 
	self.particle_ally_fx = ParticleManager:CreateParticle("particles/axe_aggro.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
    self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

	self.particle_ally = ParticleManager:CreateParticle("particles/star_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(self.particle_ally, 0, self:GetParent():GetAbsOrigin())
    self:AddParticle(self.particle_ally, false, false, -1, false, false) 

end	

if self:GetCaster():HasModifier("modifier_axe_call_5") then 

	local particle = ParticleManager:CreateParticle( "particles/items4_fx/ascetic_cap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle( particle, false, false, -1, false, false  )
end

self:StartIntervalThink(FrameTime())
end




function modifier_axe_berserkers_call_custom_buff:Taunt()
if not IsServer() then return end

local radius = self:GetAbility():GetSpecialValueFor("radius")
local duration = self:GetRemainingTime()
local ability_hunger = self:GetCaster():FindAbilityByName("axe_battle_hunger_custom")
	

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
	
for _,enemy in pairs(enemies) do

	if not self.targets[enemy] and not enemy:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 

		enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_axe_berserkers_call_custom_debuff", { duration = duration*(1 - enemy:GetStatusResistance()) } )
			
		if self:GetCaster():HasModifier("modifier_axe_call_1") then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_berserkers_call_custom_armor", {duration = self.armor_duration})
		end 

		if self:GetCaster():HasModifier("modifier_axe_call_3") then 
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_axe_berserkers_call_custom_speed", {duration = duration*(1 - enemy:GetStatusResistance())})
		end

		if self:GetCaster():HasScepter() and ability_hunger then
			ability_hunger:OnSpellStart(enemy)
		end

		if self.first == false then 
			enemy:EmitSound("Hero_Axe.Berserkers_Call")
		end

		self.targets[enemy] = true
	end

end

self.first = false
end




function modifier_axe_berserkers_call_custom_buff:OnIntervalThink()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_axe_call_legendary") then 
	self:Taunt()
end


if self:GetCaster():HasModifier("modifier_axe_call_4") then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'axe_call_change',  {hide = 0, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})
end

end 










function modifier_axe_berserkers_call_custom_buff:OnRefresh( kv )
	self:OnCreated()
end

function modifier_axe_berserkers_call_custom_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
 	MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}

	return funcs
end



function modifier_axe_berserkers_call_custom_buff:GetActivityTranslationModifiers()
if self:GetParent():HasModifier("modifier_axe_call_legendary") then 
    return "haste"
end

end





function modifier_axe_berserkers_call_custom_buff:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
if self:GetCaster():HasModifier("modifier_axe_call_3") then 
	bonus = self.attack_speed
end
	return bonus
end


function modifier_axe_berserkers_call_custom_buff:GetModifierStatusResistanceStacking()
local bonus = 0
if self:GetCaster():HasModifier("modifier_axe_call_5") then 
	bonus = self.status
end
	return bonus
end

function modifier_axe_berserkers_call_custom_buff:GetModifierIncomingDamage_Percentage()
local bonus = 0
if self:GetCaster():HasModifier("modifier_axe_call_5") then 
	bonus = self.damage_reduce
end
	return bonus
end



function modifier_axe_berserkers_call_custom_buff:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if self:GetCaster():HasModifier("modifier_axe_call_legendary") then 
	bonus = self.legendary_speed
end
	return bonus
end


function modifier_axe_berserkers_call_custom_buff:GetModifierPhysicalArmorBonus()
	return self.armor
end



function modifier_axe_berserkers_call_custom_buff:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf"
end

function modifier_axe_berserkers_call_custom_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_axe_berserkers_call_custom_buff:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end

if self:GetParent():HasModifier("modifier_axe_call_4") then 
	local damage = self.after_damage*params.original_damage
	self:SetStackCount(self:GetStackCount() + damage)
end




if not self:GetParent():HasModifier("modifier_axe_call_1") then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local target = params.attacker
local damage_return = self.return_damage

ApplyDamage({victim = target, attacker = self:GetParent(), damage = params.original_damage*damage_return, damage_type = params.damage_type,  damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_REFLECTION, ability = self:GetAbility()})

end


function modifier_axe_berserkers_call_custom_buff:OnDestroy()
if not IsServer() then return end

self:GetAbility():SetActivated(true)
self:GetAbility():UseResources(false, false, false, true)

if self:GetCaster():HasModifier("modifier_axe_call_4") then 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'axe_call_change',  {hide = 1, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})
end


if self:GetStackCount() == 0 then return end

local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 2, Vector(self:GetAbility():GetSpecialValueFor("radius"),self:GetAbility():GetSpecialValueFor("radius"),self:GetAbility():GetSpecialValueFor("radius")) )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetCaster():EmitSound("Axe.Call_damage")

self:GetCaster():GenericHeal(self:GetStackCount()*self.after_heal, self:GetAbility())


local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
	
for _,enemy in pairs(enemies) do
	ApplyDamage({victim = enemy, attacker = self:GetCaster(), ability = self:GetAbility(), damage = self:GetStackCount(), damage_type = DAMAGE_TYPE_PHYSICAL})
		
end


end














modifier_axe_berserkers_call_custom_debuff = class({})

function modifier_axe_berserkers_call_custom_debuff:IsPurgable()
	return false
end

function modifier_axe_berserkers_call_custom_debuff:OnCreated( kv )
	if not IsServer() then return end

	if self:GetParent():IsHero() or self:GetParent().owner ~= nil then 

		self:GetParent():SetForceAttackTarget( self:GetCaster() )
		self:GetParent():MoveToTargetToAttack( self:GetCaster() )
	end

	self:StartIntervalThink(FrameTime())
end

function modifier_axe_berserkers_call_custom_debuff:OnIntervalThink()
	if not IsServer() then return end
	if not self:GetCaster():IsAlive() then
		self:Destroy()
	end
end

function modifier_axe_berserkers_call_custom_debuff:OnDestroy()
	if not IsServer() then return end

	if self:GetParent():IsHero() or self:GetParent().owner ~= nil then 
		self:GetParent():SetForceAttackTarget( nil )
	end

end

function modifier_axe_berserkers_call_custom_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_TAUNTED] = true,
	}

	return state
end

function modifier_axe_berserkers_call_custom_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end





modifier_axe_berserkers_call_custom_tracker = class({})
function modifier_axe_berserkers_call_custom_tracker:IsHidden() return true end
function modifier_axe_berserkers_call_custom_tracker:IsPurgable() return false end
function modifier_axe_berserkers_call_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ABSORB_SPELL
}
end


function modifier_axe_berserkers_call_custom_tracker:OnCreated()
self.auto_cd = self:GetCaster():GetTalentValue("modifier_axe_call_6", "cd", true)
self.auto_duration = self:GetCaster():GetTalentValue("modifier_axe_call_6", "duration", true)
end 

function modifier_axe_berserkers_call_custom_tracker:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_axe_call_6") then return end
if not params.ability then return end
if not params.ability:GetCaster() then return end
if params.ability:GetCaster() == self:GetParent() then return end
if params.ability:GetCaster():HasModifier("modifier_axe_berserkers_call_custom_auto_cd") then return end


local particle = ParticleManager:CreateParticle("particles/qop_linken.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("Hero_Axe.Berserkers_Call")
self:GetCaster():EmitSound("Hero_Axe.BerserkersCall.Start")
self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")


params.ability:GetCaster():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_axe_berserkers_call_custom_debuff", { duration = self.auto_duration*(1 - params.ability:GetCaster():GetStatusResistance()) } )
params.ability:GetCaster():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_axe_berserkers_call_custom_auto_cd", {duration = self.auto_cd})	
end


modifier_axe_berserkers_call_custom_auto_cd = class({})
function modifier_axe_berserkers_call_custom_auto_cd:IsHidden() return true end
function modifier_axe_berserkers_call_custom_auto_cd:IsPurgable() return false end
function modifier_axe_berserkers_call_custom_auto_cd:IsDebuff() return true end
function modifier_axe_berserkers_call_custom_auto_cd:RemoveOnDeath() return true end
function modifier_axe_berserkers_call_custom_auto_cd:OnCreated(table)
self.RemoveForDuel = true
end

modifier_axe_berserkers_call_custom_speed = class({})
function modifier_axe_berserkers_call_custom_speed:IsHidden() return false end
function modifier_axe_berserkers_call_custom_speed:IsPurgable() return false end
function modifier_axe_berserkers_call_custom_speed:IsDebuff() return false end
function modifier_axe_berserkers_call_custom_speed:GetTexture() return "buffs/call_speed" end
function modifier_axe_berserkers_call_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end
function modifier_axe_berserkers_call_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.attack_speed
end


function modifier_axe_berserkers_call_custom_speed:OnCreated()
self.attack_speed = self:GetCaster():GetTalentValue("modifier_axe_call_3", "speed")
end 


modifier_axe_berserkers_call_custom_slow = class({})
function modifier_axe_berserkers_call_custom_slow:IsHidden() return false end
function modifier_axe_berserkers_call_custom_slow:IsPurgable() return true end
function modifier_axe_berserkers_call_custom_slow:GetEffectName()
return "particles/axe_slow.vpcf"
end
function modifier_axe_berserkers_call_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_axe_berserkers_call_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().aoe_slow
end





modifier_axe_berserkers_call_custom_heal = class({})
function modifier_axe_berserkers_call_custom_heal:IsHidden() return false end
function modifier_axe_berserkers_call_custom_heal:IsPurgable() return false end
function modifier_axe_berserkers_call_custom_heal:GetTexture() return "buffs/bloodlust_damage" end
function modifier_axe_berserkers_call_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_axe_berserkers_call_custom_heal:GetModifierHealthRegenPercentage()
    return self.heal
end


function modifier_axe_berserkers_call_custom_heal:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_axe_berserkers_call_custom_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_axe_berserkers_call_custom_heal:OnCreated()

self.heal = self:GetCaster():GetTalentValue("modifier_axe_call_2", "heal")/self:GetCaster():GetTalentValue("modifier_axe_call_2", "duration")
end 


modifier_axe_berserkers_call_custom_armor = class({})
function modifier_axe_berserkers_call_custom_armor:IsHidden() return true end
function modifier_axe_berserkers_call_custom_armor:IsPurgable() return false end
function modifier_axe_berserkers_call_custom_armor:OnCreated()
self.armor = self:GetCaster():GetTalentValue("modifier_axe_call_1", "armor")
end 

function modifier_axe_berserkers_call_custom_armor:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_axe_berserkers_call_custom_armor:GetModifierPhysicalArmorBonus()
return self.armor
end