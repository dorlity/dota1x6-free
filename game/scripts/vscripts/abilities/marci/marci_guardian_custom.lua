LinkLuaModifier( "modifier_marci_guardian_custom", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_guardian_custom_bkb", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_guardian_custom_speed", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_guardian_custom_slow", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_marci_guardian_custom_cd", "abilities/marci/marci_guardian_custom", LUA_MODIFIER_MOTION_NONE )

marci_guardian_custom = class({})

marci_guardian_custom.attack_speed = {10, 15, 20}
marci_guardian_custom.attack_speed_max = 6





marci_guardian_custom.slow_move = -5
marci_guardian_custom.slow_armor = -1
marci_guardian_custom.slow_max = {8,15}
marci_guardian_custom.slow_duration = 4



function marci_guardian_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_marci_sidekick.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf', context )

end




function marci_guardian_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_marci_sidekick_3") then  
	upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_marci_sidekick_3", "cd")
end 

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end






function marci_guardian_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor( "buff_duration" )

local ally = nil


if self:GetCaster():HasModifier("modifier_marci_sidekick_5") then 
	duration = duration + self:GetCaster():GetTalentValue("modifier_marci_sidekick_5", "duration")
end 

local friends = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false)

for _,friend in pairs(friends) do 
	if friend.MacriSummon then 

		friend:AddNewModifier( caster, self, "modifier_marci_guardian_custom", { duration = duration } )
		ally = friend:entindex()
	end
end	

caster:AddNewModifier( caster, self, "modifier_marci_guardian_custom", { ally = ally, duration = duration } )

if self:GetCaster():HasScepter() and self:GetCaster():HasModifier("modifier_marci_unleash_custom") then
	local ability = self:GetCaster():FindAbilityByName("marci_unleash_custom")
	ability:Pulse(self:GetCaster():GetAbsOrigin(), nil)
end

end

modifier_marci_guardian_custom = class({})

function modifier_marci_guardian_custom:IsPurgable()
	return true
end

function modifier_marci_guardian_custom:OnCreated( kv )
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.lifesteal = self:GetAbility():GetSpecialValueFor( "lifesteal_pct" )/100

self.ally = nil 

if self:GetParent() ~= self:GetCaster() then 
	self.ally = self:GetCaster()
else 
	if kv.ally then 
		self.ally = EntIndexToHScript(kv.ally)
	end 
end 

self.base_damage = 0 

if self:GetCaster():HasModifier("modifier_marci_sidekick_3") then 
	self.base_damage = self:GetCaster():GetTalentValue("modifier_marci_sidekick_3", "damage")
end 


self.cleave = self:GetAbility():GetSpecialValueFor("cleave_damage")
self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )

if not IsServer() then return end

if self.caster:HasModifier("modifier_marci_sidekick_2") then 
	self.lifesteal = self.lifesteal + self:GetCaster():GetTalentValue("modifier_marci_sidekick_2", "heal")/100

	local heal = self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_marci_sidekick_2", "cast_heal")/100

	self:GetParent():GenericHeal(heal, self:GetAbility())

end

if self.caster:HasModifier("modifier_marci_sidekick_6")then 
	self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_marci_guardian_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_marci_sidekick_6", "duration")})
end

self:PlayEffects1()

end

function modifier_marci_guardian_custom:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_guardian_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MIN_HEALTH,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function modifier_marci_guardian_custom:GetModifierBaseDamageOutgoing_Percentage()

return self.base_damage
end

function modifier_marci_guardian_custom:GetModifierPhysicalArmorBonus()
return self.armor
end


function modifier_marci_guardian_custom:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= self:GetCaster() then return end
if params.attacker ~= self:GetParent() then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end
params.target:EmitSound("Hero_Sven.GreatCleave")

DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), self.cleave*params.damage/100, 150, 360, 500, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )

end

function modifier_marci_guardian_custom:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
if params.target:GetTeamNumber()==self.parent:GetTeamNumber() then return end
if params.target:IsBuilding() or params.target:IsOther() then return end
	self.attack_record = params.record

if self:GetCaster():HasModifier("modifier_marci_sidekick_4") then 
	params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_marci_guardian_custom_slow", {duration = self:GetAbility().slow_duration})
end


end


function modifier_marci_guardian_custom:GetMinHealth()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if self:GetParent():HasModifier("modifier_death") then return end
if not self:GetCaster():HasModifier("modifier_marci_sidekick_5") then return end
if self:GetParent():HasModifier("modifier_marci_guardian_custom_cd") then return end

return 1
end

function modifier_marci_guardian_custom:OnTakeDamage( params )
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_marci_sidekick_5") and 
	not self:GetParent():HasModifier("modifier_marci_guardian_custom_cd") and 
	self:GetParent() == params.unit and 
	self:GetParent():GetHealth() <= 1 and
	not self:GetParent():HasModifier("modifier_death") then 


	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_marci_guardian_custom_cd", {duration = self:GetCaster():GetTalentValue("modifier_marci_sidekick_5", "cd")})


	local heal = self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_marci_sidekick_5", "heal")/100



	self:GetParent():GenericHeal(heal, self:GetAbility())

	self:GetParent():EmitSound("Marci.Sidekick_heal")

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	
	ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )



end


if self.attack_record ~= params.record then return end
local heal = params.damage * self.lifesteal


if self:GetCaster():GetQuest() == "Marci.Quest_7" and params.unit:IsRealHero() and not self:GetCaster():QuestCompleted() then 
	self:GetCaster():UpdateQuest(math.min(heal, self:GetParent():GetMaxHealth() - self:GetParent():GetHealth() ) )
end

local target = self.parent

if self.ally and not self.ally:IsNull() and self.ally:IsAlive() then 
	target = self.ally
end 

target:GenericHeal( heal, self.ability, true)

if self:GetCaster():HasModifier("modifier_marci_sidekick_1") and self:GetStackCount() < self:GetAbility().attack_speed_max then 
	self:IncrementStackCount()
end


end



function modifier_marci_guardian_custom:GetModifierAttackSpeedBonus_Constant()
if not self:GetCaster():HasModifier("modifier_marci_sidekick_1") then return end
 return self:GetStackCount()*self:GetAbility().attack_speed[self:GetCaster():GetUpgradeStack("modifier_marci_sidekick_1")]
end


function modifier_marci_guardian_custom:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function modifier_marci_guardian_custom:ShouldUseOverheadOffset()
	return true
end

function modifier_marci_guardian_custom:GetStatusEffectName()
	return "particles/status_fx/status_effect_marci_sidekick.vpcf"
end

function modifier_marci_guardian_custom:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end



function modifier_marci_guardian_custom:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_self_buff.vpcf"
	if self.parent~=self.caster then
		particle_cast = "particles/units/heroes/hero_marci/marci_sidekick_buff.vpcf"
	end

	local particle = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( particle, 1, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( particle, 2, self.parent:GetOrigin() )
	self:AddParticle( particle, false, false, 1, false, true )

	self.parent:EmitSound("Hero_Marci.Guardian.Applied")
end



modifier_marci_guardian_custom_bkb = class({})
function modifier_marci_guardian_custom_bkb:IsHidden() return true end
function modifier_marci_guardian_custom_bkb:IsPurgable() return false end 
function modifier_marci_guardian_custom_bkb:GetEffectName() return "particles/items_fx/black_king_bar_avatar.vpcf" end
function modifier_marci_guardian_custom_bkb:CheckState() return {[MODIFIER_STATE_MAGIC_IMMUNE] = true} end




modifier_marci_guardian_custom_speed = class({})

function modifier_marci_guardian_custom_speed:IsHidden()
	return true
end

function modifier_marci_guardian_custom_speed:IsDebuff()
	return false
end

function modifier_marci_guardian_custom_speed:IsPurgable()
	return true
end

function modifier_marci_guardian_custom_speed:OnCreated( kv )
self.speed = self:GetCaster():GetTalentValue("modifier_marci_sidekick_6", "speed")

if not IsServer() then return end
	self:GetParent():Purge(false, true, false, false, false)
	self:GetParent():EmitSound("Hero_Marci.Rebound.Ally")
end

function modifier_marci_guardian_custom_speed:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_marci_guardian_custom_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end

function modifier_marci_guardian_custom_speed:GetModifierMoveSpeed_Absolute()
	return self.speed
end


function modifier_marci_guardian_custom_speed:GetActivityTranslationModifiers()
return "haste"
end

function modifier_marci_guardian_custom_speed:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end

function modifier_marci_guardian_custom_speed:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



modifier_marci_guardian_custom_slow = class({})
function modifier_marci_guardian_custom_slow:IsHidden() return false end
function modifier_marci_guardian_custom_slow:IsPurgable() return true end
function modifier_marci_guardian_custom_slow:GetTexture() return "buffs/sidekick_armor" end
function modifier_marci_guardian_custom_slow:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_marci_guardian_custom_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().slow_max[self:GetCaster():GetUpgradeStack("modifier_marci_sidekick_4")] then return end
self:IncrementStackCount()

end


function modifier_marci_guardian_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_marci_guardian_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_move*self:GetStackCount()
end


function modifier_marci_guardian_custom_slow:GetModifierPhysicalArmorBonus()
return self:GetAbility().slow_armor*self:GetStackCount()
end



modifier_marci_guardian_custom_cd = class({})
function modifier_marci_guardian_custom_cd:IsHidden() return false end
function modifier_marci_guardian_custom_cd:IsPurgable() return false end
function modifier_marci_guardian_custom_cd:RemoveOnDeath() return false end
function modifier_marci_guardian_custom_cd:IsDebuff() return true end
function modifier_marci_guardian_custom_cd:OnCreated()
self.RemoveForDuel = true
end