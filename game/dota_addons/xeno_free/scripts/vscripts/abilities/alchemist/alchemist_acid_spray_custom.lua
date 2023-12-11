LinkLuaModifier( "modifier_alchemist_acid_spray_custom_thinker", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_thinker_red", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_thinker_purple", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_aura", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_aura_red", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_aura_purple", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_mixing", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_silence_timer", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_silence", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_acid_spray_custom_tracker", "abilities/alchemist/alchemist_acid_spray_custom", LUA_MODIFIER_MOTION_NONE )


alchemist_acid_spray_custom = class({})
alchemist_acid_spray_red_custom = class({})
alchemist_acid_spray_purple_custom = class({})





function alchemist_acid_spray_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_alchemist_acid_spray_custom_tracker"
end 

function alchemist_acid_spray_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_meepo/meepo_ransack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", context )
PrecacheResource( "particle", "particles/alch_spray_red.vpcf", context )
PrecacheResource( "particle", "particles/alch_armor.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf", context )
PrecacheResource( "particle", "particles/alch_root_timer.vpcf", context )
PrecacheResource( "particle", "particles/alch_root.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf", context )

end



function alchemist_acid_spray_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" ) + self:GetCaster():GetTalentValue("modifier_alchemist_spray_6", "radius")
end

function alchemist_acid_spray_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_spray_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_alchemist_spray_1", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end


function alchemist_acid_spray_custom:GetManaCost(level)

local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_spray_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_alchemist_spray_1", "mana")
end

return self.BaseClass.GetManaCost(self,level) + bonus
end


function alchemist_acid_spray_custom:OnSpellStart()
if not IsServer() then return end
local point = self:GetCursorPosition()
self:CreateSpray("modifier_alchemist_acid_spray_custom_thinker", point, self)
end


function alchemist_acid_spray_custom:CreateSpray(name, point, ability)
if not IsServer() then return end
local duration = self:GetSpecialValueFor("duration")

CreateModifierThinker( self:GetCaster(), ability, name, { duration = duration }, point, self:GetCaster():GetTeamNumber(), false )
end




function alchemist_acid_spray_custom:DoDamage(target)
if not IsServer() then return end
local damage = self:GetSpecialValueFor( "damage" )

if self:GetCaster():HasModifier("modifier_alchemist_spray_3") then
	damage = damage + self:GetCaster():GetTalentValue("modifier_alchemist_spray_3", "damage")
end

local damageTable = {victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK }

ApplyDamage( damageTable )
target:EmitSound("Hero_Alchemist.AcidSpray.Damage")

end




function alchemist_acid_spray_red_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" ) + self:GetCaster():GetTalentValue("modifier_alchemist_spray_6", "radius")
end



function alchemist_acid_spray_red_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_spray_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_alchemist_spray_1", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end




function alchemist_acid_spray_red_custom:GetManaCost(level)

local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_spray_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_alchemist_spray_1", "mana")
end

return self.BaseClass.GetManaCost(self,level) + bonus
end



function alchemist_acid_spray_red_custom:OnSpellStart()
if not IsServer() then return end
local ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")
local point = self:GetCursorPosition()

ability:CreateSpray("modifier_alchemist_acid_spray_custom_thinker_red", point, self)
end






function alchemist_acid_spray_purple_custom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" ) + self:GetCaster():GetTalentValue("modifier_alchemist_spray_6", "radius")
end


function alchemist_acid_spray_purple_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_spray_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_alchemist_spray_1", "cd")
end

return self.BaseClass.GetCooldown( self, level ) + bonus
end




function alchemist_acid_spray_purple_custom:GetManaCost(level)

local bonus = 0

if self:GetCaster():HasModifier("modifier_alchemist_spray_1") then
	bonus = self:GetCaster():GetTalentValue("modifier_alchemist_spray_1", "mana")
end

return self.BaseClass.GetManaCost(self,level) + bonus
end







function alchemist_acid_spray_purple_custom:OnSpellStart()
if not IsServer() then return end
local ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")
local point = self:GetCursorPosition()

ability:CreateSpray("modifier_alchemist_acid_spray_custom_thinker_purple", point, self)
end








modifier_alchemist_acid_spray_custom_thinker = class({})

function modifier_alchemist_acid_spray_custom_thinker:OnCreated()
if not IsServer() then return end

self.radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_alchemist_spray_6", "radius")
self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
self:AddParticle( particle, false, false, -1, false, false )

self:GetParent():EmitSound("Hero_Alchemist.AcidSpray")

end



function modifier_alchemist_acid_spray_custom_thinker:IsAura()
	return true
end

function modifier_alchemist_acid_spray_custom_thinker:GetModifierAura()
	return "modifier_alchemist_acid_spray_custom_aura"
end

function modifier_alchemist_acid_spray_custom_thinker:GetAuraRadius()
	return self.radius
end

function modifier_alchemist_acid_spray_custom_thinker:GetAuraDuration()
	return 0.5
end

function modifier_alchemist_acid_spray_custom_thinker:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
end


function modifier_alchemist_acid_spray_custom_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_alchemist_acid_spray_custom_thinker:GetAuraSearchFlags()
	return 0
end

function modifier_alchemist_acid_spray_custom_thinker:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Hero_Alchemist.AcidSpray")
UTIL_Remove( self:GetParent() )
end








modifier_alchemist_acid_spray_custom_thinker_red = class({})

function modifier_alchemist_acid_spray_custom_thinker_red:OnCreated()
if not IsServer() then return end

self.radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_alchemist_spray_6", "radius")

self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")

local particle = ParticleManager:CreateParticle( "particles/alch_spray_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
--ParticleManager:SetParticleControl( particle, 15, Vector( 180, 92, 179 ) )
ParticleManager:SetParticleControl( particle, 15, Vector( 220, 20, 60 ) )
ParticleManager:SetParticleControl( particle, 16, Vector( 1, 0, 0 ) )
self:AddParticle( particle, false, false, -1, false, false )

self:GetParent():EmitSound("Hero_Alchemist.AcidSpray")

end



function modifier_alchemist_acid_spray_custom_thinker_red:IsAura()
	return true
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetModifierAura()
	return "modifier_alchemist_acid_spray_custom_aura_red"
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraRadius()
	return self.radius
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraDuration()
	return 0.5
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
end 

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_alchemist_acid_spray_custom_thinker_red:GetAuraSearchFlags()
	return 0
end

function modifier_alchemist_acid_spray_custom_thinker_red:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Hero_Alchemist.AcidSpray")

UTIL_Remove( self:GetParent() )
end







modifier_alchemist_acid_spray_custom_thinker_purple = class({})

function modifier_alchemist_acid_spray_custom_thinker_purple:OnCreated()
if not IsServer() then return end

self.radius = self:GetAbility():GetSpecialValueFor("radius") + self:GetCaster():GetTalentValue("modifier_alchemist_spray_6", "radius")

self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( particle, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( particle, 1, Vector( self.radius, 1, 1 ) )
ParticleManager:SetParticleControl( particle, 15, Vector( 180, 92, 179 ) )
--ParticleManager:SetParticleControl( particle, 15, Vector( 220, 20, 60 ) )
ParticleManager:SetParticleControl( particle, 16, Vector( 1, 0, 0 ) )
self:AddParticle( particle, false, false, -1, false, false )

self:GetParent():EmitSound("Hero_Alchemist.AcidSpray")

end



function modifier_alchemist_acid_spray_custom_thinker_purple:IsAura()
	return true
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetModifierAura()
	return "modifier_alchemist_acid_spray_custom_aura_purple"
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraRadius()
	return self.radius
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraDuration()
	return 0.5
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_alchemist_acid_spray_custom_thinker_purple:GetAuraSearchFlags()
	return 0
end

function modifier_alchemist_acid_spray_custom_thinker_purple:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("Hero_Alchemist.AcidSpray")
UTIL_Remove( self:GetParent() )
end










modifier_alchemist_acid_spray_custom_aura = class({})


function modifier_alchemist_acid_spray_custom_aura:IsHidden() return self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() end 

function modifier_alchemist_acid_spray_custom_aura:IsPurgable() return false end

function modifier_alchemist_acid_spray_custom_aura:GetTexture() return "alchemist_acid_spray" end

function modifier_alchemist_acid_spray_custom_aura:OnCreated()

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.armor = -self:GetAbility():GetSpecialValueFor( "armor_reduction" ) + self:GetCaster():GetTalentValue("modifier_alchemist_spray_3", "armor")


self.legendary_damage = self:GetCaster():GetTalentValue("modifier_alchemist_spray_legendary", "damage")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_alchemist_spray_2", "heal_reduce")

self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")


self.interval = 1


if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end 

if self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura") and self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_red") and 
	self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_purple") and IsServer() then 

	self:GetParent():EmitSound("Alch.Triple")
end

self.main_ability:DoDamage(self.parent)

self:StartIntervalThink(self.interval)
end




function modifier_alchemist_acid_spray_custom_aura:OnIntervalThink()
if not IsServer() then return end

self.main_ability:DoDamage(self.parent)


if self.caster:GetQuest() == "Alch.Quest_5" and not self.caster:QuestCompleted() and self.parent:IsRealHero() then
	self:GetCaster():UpdateQuest(self.interval)
end

if self.caster:HasModifier("modifier_alchemist_spray_6") and not self.parent:HasModifier("modifier_alchemist_acid_spray_custom_silence")  then 

	self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_alchemist_acid_spray_custom_silence_timer", {duration = self.interval + 0.2})
end 

if self.caster:HasModifier("modifier_alchemist_spray_5") then


	local ability = self.caster:FindAbilityByName("alchemist_corrosive_weaponry_custom")

	if self.caster:HasModifier("modifier_alchemist_spray_5") and ability and ability:GetLevel() > 0 then 
		ability:AddStack(self.parent)
	end 
end


end



function modifier_alchemist_acid_spray_custom_aura:GetEffectName()
if self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber() then
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

end



function modifier_alchemist_acid_spray_custom_aura:DeclareFunctions()
if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
local funcs = {
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
return funcs
end


function modifier_alchemist_acid_spray_custom_aura:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end

return self.heal_reduce
end

function modifier_alchemist_acid_spray_custom_aura:GetModifierHealAmplify_PercentageTarget() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end

return self.heal_reduce
end

function modifier_alchemist_acid_spray_custom_aura:GetModifierHPRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end

return self.heal_reduce
end



function modifier_alchemist_acid_spray_custom_aura:GetModifierPhysicalArmorBonus()
	return self.armor
end


function modifier_alchemist_acid_spray_custom_aura:GetModifierIncomingDamage_Percentage()
if not self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura_red") or 
	not self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura_purple") then return end


	return self.legendary_damage
end







modifier_alchemist_acid_spray_custom_aura_red = class({})

function modifier_alchemist_acid_spray_custom_aura_red:IsHidden() return self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() end 

function modifier_alchemist_acid_spray_custom_aura_red:IsPurgable() return false end

function modifier_alchemist_acid_spray_custom_aura_red:OnCreated()


self.caster = self:GetCaster()
self.parent = self:GetParent()
self.damage_reduce = self:GetCaster():GetTalentValue("modifier_alchemist_spray_legendary", "damage_reduce")


self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_alchemist_spray_2", "heal_reduce")


self.interval = 1

if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end 


if self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura") and self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_red") and 
	self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_purple") and IsServer() then 

	self:GetParent():EmitSound("Alch.Triple")
end


self.main_ability:DoDamage(self.parent)
self:StartIntervalThink(self.interval)
end



function modifier_alchemist_acid_spray_custom_aura_red:OnIntervalThink()
if not IsServer() then return end

self.main_ability:DoDamage(self.parent)

if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura") then return end

if self.caster:HasModifier("modifier_alchemist_spray_6") and not self.parent:HasModifier("modifier_alchemist_acid_spray_custom_silence")  then 
	self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_alchemist_acid_spray_custom_silence_timer", {duration = self.interval + 0.2})
end 


if self.caster:GetQuest() == "Alch.Quest_5" and not self.caster:QuestCompleted() and self.parent:IsRealHero() then
	
	self:GetCaster():UpdateQuest(self.interval)
end


if not self.caster:HasModifier("modifier_alchemist_spray_5") then end

local ability = self.caster:FindAbilityByName("alchemist_corrosive_weaponry_custom")

if self.caster:HasModifier("modifier_alchemist_spray_5") and ability and ability:GetLevel() > 0 then 
	
	ability:AddStack(self.parent)
end 


end




function modifier_alchemist_acid_spray_custom_aura_red:DeclareFunctions()
if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
local funcs = 
{
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
return funcs
end



function modifier_alchemist_acid_spray_custom_aura_red:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura") then return end

return self.heal_reduce
end

function modifier_alchemist_acid_spray_custom_aura_red:GetModifierHealAmplify_PercentageTarget() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura") then return end

return self.heal_reduce
end

function modifier_alchemist_acid_spray_custom_aura_red:GetModifierHPRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura") then return end

return self.heal_reduce
end






function modifier_alchemist_acid_spray_custom_aura_red:GetModifierSpellAmplify_Percentage()
if self.parent:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
  return self.damage_reduce
end



function modifier_alchemist_acid_spray_custom_aura_red:GetModifierDamageOutgoing_Percentage()
if self.parent:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
  return self.damage_reduce
end








modifier_alchemist_acid_spray_custom_aura_purple = class({})


function modifier_alchemist_acid_spray_custom_aura_purple:IsHidden() return self:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() end 

function modifier_alchemist_acid_spray_custom_aura_purple:IsPurgable() return false end
function modifier_alchemist_acid_spray_custom_aura_purple:OnCreated()

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.main_ability = self:GetCaster():FindAbilityByName("alchemist_acid_spray_custom")


self.slow = self:GetCaster():GetTalentValue("modifier_alchemist_spray_legendary", "slow")
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_alchemist_spray_2", "heal_reduce")

self.main_ability = self.caster:FindAbilityByName("alchemist_acid_spray_custom")

self.interval = 1

if self.caster:GetTeamNumber() == self.parent:GetTeamNumber() then return end 

if self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura") and self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_red") and 
	self:GetParent():HasModifier("modifier_alchemist_acid_spray_custom_aura_purple") and IsServer() then 
		self:GetParent():EmitSound("Alch.Triple")
end

self.main_ability:DoDamage(self.parent)
self:StartIntervalThink(self.interval)
end



function modifier_alchemist_acid_spray_custom_aura_purple:OnIntervalThink()
if not IsServer() then return end

self.main_ability:DoDamage(self.parent)



if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura_red") then return end

if self.caster:HasModifier("modifier_alchemist_spray_6") and not self.parent:HasModifier("modifier_alchemist_acid_spray_custom_silence")  then 

	self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_alchemist_acid_spray_custom_silence_timer", {duration = self.interval + 0.2})
end 

if self.caster:GetQuest() == "Alch.Quest_5" and not self.caster:QuestCompleted() and self.parent:IsRealHero() then
	
	self:GetCaster():UpdateQuest(self.interval)
end

if not self.caster:HasModifier("modifier_alchemist_spray_5") then end


local ability = self.caster:FindAbilityByName("alchemist_corrosive_weaponry_custom")

if self.caster:HasModifier("modifier_alchemist_spray_5")	and ability and ability:GetLevel() > 0 then 
	ability:AddStack(self.parent)
end 


end


function modifier_alchemist_acid_spray_custom_aura_purple:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_alchemist_acid_spray_custom_aura_purple:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_alchemist_acid_spray_custom_aura_purple:DeclareFunctions()
if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end


function modifier_alchemist_acid_spray_custom_aura_purple:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura_red") then return end

return self.heal_reduce
end

function modifier_alchemist_acid_spray_custom_aura_purple:GetModifierHealAmplify_PercentageTarget() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura_red") then return end

return self.heal_reduce
end

function modifier_alchemist_acid_spray_custom_aura_purple:GetModifierHPRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_alchemist_spray_2") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura") then return end
if self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura_red") then return end

return self.heal_reduce
end




function modifier_alchemist_acid_spray_custom_aura_purple:GetModifierMoveSpeedBonus_Percentage()
  return self.slow
end













modifier_alchemist_acid_spray_custom_silence_timer = class({})
function modifier_alchemist_acid_spray_custom_silence_timer:IsHidden() return true end
function modifier_alchemist_acid_spray_custom_silence_timer:IsPurgable() return false end
function modifier_alchemist_acid_spray_custom_silence_timer:OnCreated(table)
if not IsServer() then return end

self.max = self:GetCaster():GetTalentValue("modifier_alchemist_spray_6", "timer")
self.silence = self:GetCaster():GetTalentValue("modifier_alchemist_spray_6", "silence")

self:SetStackCount(1)
self.effect_cast = ParticleManager:CreateParticle( "particles/alch_root_timer.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0,self:GetStackCount(), 0 ) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

end


function modifier_alchemist_acid_spray_custom_silence_timer:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()

if self.effect_cast then
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0,self:GetStackCount(), 0 ) )
end 

if self:GetStackCount() >= self.max then 

	self:GetParent():EmitSound("Sniper.Shrapnel_Silence")
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_alchemist_acid_spray_custom_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self.silence})

	self:Destroy()
end 


end





















-- Способность Замешивание для легендарного таланта

alchemist_acid_spray_mixing = class({})

function alchemist_acid_spray_mixing:Spawn()
    if not IsServer() then return end
    if self and not self:IsTrained() then
        self:SetLevel(1)
        self:SetActivated(false)
        self:SetHidden(true) 
    end
end

function alchemist_acid_spray_mixing:GetIntrinsicModifierName()
	return "modifier_alchemist_acid_spray_custom_mixing_visual"
end

function alchemist_acid_spray_mixing:OnSpellStart()
if not IsServer() then return end

self:EndCooldown()
self:GetCaster():StartGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)

self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_alchemist_acid_spray_custom_mixing", { duration = self:GetCaster():GetTalentValue("modifier_alchemist_spray_legendary", "delay") } )
end




modifier_alchemist_acid_spray_custom_mixing = class({})

function modifier_alchemist_acid_spray_custom_mixing:IsHidden()
	return true
end

function modifier_alchemist_acid_spray_custom_mixing:IsPurgable()
	return false
end

function modifier_alchemist_acid_spray_custom_mixing:OnCreated( kv )
if not IsServer() then return end

self.t = -1
self.timer = self:GetCaster():GetTalentValue("modifier_alchemist_spray_legendary", "delay")*2

self:GetParent():EmitSound("Alch.Mix")

local ability_acid = self:GetParent():FindAbilityByName("alchemist_acid_spray_custom")
local ability_acid_red = self:GetParent():FindAbilityByName("alchemist_acid_spray_red_custom")
local ability_acid_purple = self:GetParent():FindAbilityByName("alchemist_acid_spray_purple_custom")

if ability_acid then
	ability_acid:SetActivated(false)
end
if ability_acid_red then
	ability_acid_red:SetActivated(false)
end
if ability_acid_purple then
	ability_acid_purple:SetActivated(false)
end

self:GetAbility():SetActivated(false)
self:GetAbility():StartCooldown(self:GetRemainingTime())
end

function modifier_alchemist_acid_spray_custom_mixing:OnDestroy()
	if not IsServer() then return end
	self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
	self:GetAbility():SetActivated(true)

	self:GetParent():StopSound("Alch.Mix")

	local ability_acid = self:GetParent():FindAbilityByName("alchemist_acid_spray_custom")
	local ability_acid_red = self:GetParent():FindAbilityByName("alchemist_acid_spray_red_custom")
	local ability_acid_purple = self:GetParent():FindAbilityByName("alchemist_acid_spray_purple_custom")


	
	if ability_acid then
		ability_acid:SetActivated(true) 
	end
	if ability_acid_red then
		ability_acid_red:SetActivated(true)
	end
	if ability_acid_purple then
		ability_acid_purple:SetActivated(true)
	end
	


	if not ability_acid:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_acid_spray_custom", "alchemist_acid_spray_red_custom", false, true)
		ability_acid:SetHidden(true)
		ability_acid_red:SetHidden(false)
		return
	end

	if not ability_acid_red:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_acid_spray_red_custom", "alchemist_acid_spray_purple_custom", false, true)
		ability_acid_red:SetHidden(true)
		ability_acid_purple:SetHidden(false)
		return
	end

	if not ability_acid_purple:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_acid_spray_purple_custom", "alchemist_acid_spray_custom", false, true)
		ability_acid_purple:SetHidden(true)
		ability_acid:SetHidden(false)
		return
	end

end




function modifier_alchemist_acid_spray_custom_mixing:OnIntervalThink()
if not IsServer() then return end
self.t = self.t + 1
local caster = self:GetParent()

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
	decimal = 8
else 
	decimal = 1
end

local particleName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end




modifier_alchemist_acid_spray_custom_tracker = class({})
function modifier_alchemist_acid_spray_custom_tracker:IsHidden() return true end
function modifier_alchemist_acid_spray_custom_tracker:IsPurgable() return false end
function modifier_alchemist_acid_spray_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_alchemist_acid_spray_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.heal_creeps = self:GetParent():GetTalentValue("modifier_alchemist_spray_2", "heal_creeps", true)
end 


function modifier_alchemist_acid_spray_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end 
if not params.attacker then return end 
if self.parent  ~= params.attacker then return end 
if not self.parent:HasModifier("modifier_alchemist_spray_2") then return end 
if not self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura") and not self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura_red")
	and not self.parent:HasModifier("modifier_alchemist_acid_spray_custom_aura_purple") then return end 

if not params.unit:IsCreep() and not params.unit:IsHero() then return end 


local heal = params.damage*self.parent:GetTalentValue("modifier_alchemist_spray_2", "heal")/100
if params.unit:IsCreep() then 
	heal = heal/self.heal_creeps
end

self.parent:GenericHeal(heal, self:GetAbility(), true)
end 




modifier_alchemist_acid_spray_custom_silence = class({})

function modifier_alchemist_acid_spray_custom_silence:IsHidden() return true end
function modifier_alchemist_acid_spray_custom_silence:IsPurgable() return true end
function modifier_alchemist_acid_spray_custom_silence:GetTexture() return "silencer_last_word" end


function modifier_alchemist_acid_spray_custom_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true,
}
end


function modifier_alchemist_acid_spray_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end

function modifier_alchemist_acid_spray_custom_silence:ShouldUseOverheadOffset() return true end
function modifier_alchemist_acid_spray_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW endpray_red_custom")
	local ability_acid_purple = self:GetParent():FindAbilityByName("alchemist_acid_spray_purple_custom")

	if ability_acid then
		ability_acid:SetActivated(false)
	end
	if ability_acid_red then
		ability_acid_red:SetActivated(false)
	end
	if ability_acid_purple then
		ability_acid_purple:SetActivated(false)
	end

	self:GetAbility():SetActivated(false)
	self:GetAbility():StartCooldown(self:GetRemainingTime())
end

function modifier_alchemist_acid_spray_custom_mixing:OnDestroy()
	if not IsServer() then return end
	self:GetCaster():FadeGesture(ACT_DOTA_ALCHEMIST_CONCOCTION)
	self:GetAbility():SetActivated(true)

	self:GetParent():StopSound("Alch.Mix")

	local ability_acid = self:GetParent():FindAbilityByName("alchemist_acid_spray_custom")
	local ability_acid_red = self:GetParent():FindAbilityByName("alchemist_acid_spray_red_custom")
	local ability_acid_purple = self:GetParent():FindAbilityByName("alchemist_acid_spray_purple_custom")


	
	if ability_acid then
		ability_acid:SetActivated(true) 
	end
	if ability_acid_red then
		ability_acid_red:SetActivated(true)
	end
	if ability_acid_purple then
		ability_acid_purple:SetActivated(true)
	end
	


	if not ability_acid:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_acid_spray_custom", "alchemist_acid_spray_red_custom", false, true)
		ability_acid:SetHidden(true)
		ability_acid_red:SetHidden(false)
		return
	end

	if not ability_acid_red:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_acid_spray_red_custom", "alchemist_acid_spray_purple_custom", false, true)
		ability_acid_red:SetHidden(true)
		ability_acid_purple:SetHidden(false)
		return
	end

	if not ability_acid_purple:IsHidden() then 
		self:GetParent():SwapAbilities("alchemist_acid_spray_purple_custom", "alchemist_acid_spray_custom", false, true)
		ability_acid_purple:SetHidden(true)
		ability_acid:SetHidden(false)
		return
	end

end




function modifier_alchemist_acid_spray_custom_mixing:OnIntervalThink()
if not IsServer() then return end
self.t = self.t + 1
local caster = self:GetParent()

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
	decimal = 8
else 
	decimal = 1
end

local particleName = "particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end



modifier_alchemist_acid_spray_custom_quest = class({})
function modifier_alchemist_acid_spray_custom_quest:IsHidden() return true end
function modifier_alchemist_acid_spray_custom_quest:IsPurgable() return false end
function modifier_alchemist_acid_spray_custom_quest:OnCreated()
if not IsServer() then return end

self:StartIntervalThink(0.2)
end

function modifier_alchemist_acid_spray_custom_quest:OnIntervalThink()
if not IsServer() then return end
if self:GetCaster():QuestCompleted() then return end

self:GetCaster():UpdateQuest(0.2)
end