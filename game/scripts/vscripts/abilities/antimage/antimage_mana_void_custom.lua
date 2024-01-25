LinkLuaModifier( "modifier_antimage_mana_void_custom_legendary", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_slow", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_tracker", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_int", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_cast_cd", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_aura", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_aura_effect", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_mana_void_custom_speed", "abilities/antimage/antimage_mana_void_custom", LUA_MODIFIER_MOTION_NONE )

antimage_mana_void_custom = class({})



function antimage_mana_void_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_antimage/antimage_manavoid.vpcf', context )
PrecacheResource( "particle", 'particles/void_astral_slow.vpcf', context )
PrecacheResource( "particle", 'particles/am_void_cd.vpcf', context )
PrecacheResource( "particle", 'particles/am_mana_stack.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf', context )
PrecacheResource( "particle", 'particles/am_cast.vpcf', context )
PrecacheResource( "particle", 'particles/am_mana_mark.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf', context )
PrecacheResource( "particle", 'particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf', context )

end




function antimage_mana_void_custom:GetIntrinsicModifierName()
	return "modifier_antimage_mana_void_custom_tracker"
end



function antimage_mana_void_custom:GetAOERadius()
	return self:GetSpecialValueFor( "mana_void_aoe_radius" )
end


function antimage_mana_void_custom:GetCooldown(iLevel)

local bonus = 0

if self:GetCaster():HasModifier("modifier_antimage_void_1") then  
  bonus = self:GetCaster():GetTalentValue("modifier_antimage_void_1", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) + bonus
 
end


function antimage_mana_void_custom:GetCastRange(location, target)
local bonus = 0

if self:GetCaster():HasModifier("modifier_antimage_void_6") then 
	bonus = self:GetCaster():GetTalentValue("modifier_antimage_void_6", "range")
end

	return self.BaseClass.GetCastRange(self, location, target) + bonus
end


function antimage_mana_void_custom:OnAbilityPhaseStart( kv )
	self.target = self:GetCursorTarget()
	self.target:EmitSound("Hero_Antimage.ManaVoidCast")
	return true
end

function antimage_mana_void_custom:OnAbilityPhaseInterrupted()
	self.target:StopSound("Hero_Antimage.ManaVoidCast")
end

function antimage_mana_void_custom:OnSpellStart(new_target)
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if new_target then 
	target = new_target
end

if target:TriggerSpellAbsorb( self ) then return end


local mana_void_damage_per_mana = self:GetSpecialValueFor("mana_void_damage_per_mana")
local radius = self:GetSpecialValueFor( "mana_void_aoe_radius" )


if target:IsRealHero() and caster:GetQuest() == "Anti.Quest_8" and target:GetManaPercent() <= caster.quest.number and not caster:QuestCompleted() then 
	caster:UpdateQuest(1)
end


self:DealDamage(target, mana_void_damage_per_mana, radius)


if target:IsCreep() then 
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("creep_cd"))
end

end



function antimage_mana_void_custom:DealDamage(target, damage, radius)
if not IsServer() then return end

local mana_damage = (target:GetMaxMana() - target:GetMana()) * damage

if self:GetCaster():HasModifier("modifier_antimage_void_1") then 
	mana_damage = mana_damage + self:GetCaster():GetTalentValue("modifier_antimage_void_1", "damage")*target:GetMaxMana()/100
end 


local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )

target:EmitSound("Hero_Antimage.ManaVoid")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_manavoid.vpcf", PATTACH_POINT_FOLLOW, target )
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, Vector( radius, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( particle )

local k = 1
if self:GetCaster():IsIllusion() and self:GetCaster().am_scepter then 
	local ability = self:GetCaster():FindAbilityByName("antimage_mana_overload_custom")
	k = ability:GetSpecialValueFor("ulti_damage")/100
end

local mana_void_ministun = self:GetSpecialValueFor("mana_void_ministun")

local slow_duration = self:GetCaster():GetTalentValue("modifier_antimage_void_6", "duration")

for _,enemy in pairs(enemies) do

	ApplyDamage({ victim = enemy, attacker = self:GetCaster(), damage = mana_damage*k, damage_type = DAMAGE_TYPE_MAGICAL, ability = self, })

	if self:GetCaster():HasModifier("modifier_antimage_void_6") then 
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_void_custom_slow", {duration = (1 - enemy:GetStatusResistance())*slow_duration})
	end
	enemy:AddNewModifier( caster, self, "modifier_stunned", { duration = mana_void_ministun } )
	

end



end







modifier_antimage_mana_void_custom_slow = class({})

function modifier_antimage_mana_void_custom_slow:IsPurgable() return false end

function modifier_antimage_mana_void_custom_slow:IsHidden() return false end 
function modifier_antimage_mana_void_custom_slow:IsDebuff() return true end
function modifier_antimage_mana_void_custom_slow:GetTexture() return "buffs/manavoid_slow" end

function modifier_antimage_mana_void_custom_slow:GetEffectName() return "particles/items4_fx/nullifier_mute_debuff.vpcf" end

function modifier_antimage_mana_void_custom_slow:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end
function modifier_antimage_mana_void_custom_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_nullifier.vpcf"
end 

function modifier_antimage_mana_void_custom_slow:StatusEffectPriority()
    return 9999999
end 

function modifier_antimage_mana_void_custom_slow:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_antimage_void_6", "slow")

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/items4_fx/nullifier_mute.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 

function modifier_antimage_mana_void_custom_slow:OnIntervalThink()
if not IsServer() then return end 
if self:GetParent():IsDebuffImmune() then return end

self:GetParent():Purge(true, false, false, false,false)
end 

function modifier_antimage_mana_void_custom_slow:GetModifierMoveSpeedBonus_Percentage() 
return self.slow
end









modifier_antimage_mana_void_custom_tracker = class({})
function modifier_antimage_mana_void_custom_tracker:IsHidden() return true end
function modifier_antimage_mana_void_custom_tracker:IsPurgable() return false end
function modifier_antimage_mana_void_custom_tracker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_antimage_mana_void_custom_tracker:OnCreated()

self.cast_radius = self:GetCaster():GetTalentValue("modifier_antimage_void_5", "radius", true)
self.cast_cd = self:GetCaster():GetTalentValue("modifier_antimage_void_5", "cd", true)
self.cast_stun = self:GetCaster():GetTalentValue("modifier_antimage_void_5", "stun", true)
self.cast_heal = self:GetCaster():GetTalentValue("modifier_antimage_void_5", "heal", true)/100

self.speed_duration = self:GetCaster():GetTalentValue("modifier_antimage_void_3", "duration", true)

self.mana_duration = self:GetCaster():GetTalentValue("modifier_antimage_void_4", "duration", true)
end 


function modifier_antimage_mana_void_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_antimage_void_4") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.target:GetMaxMana() == 0 then return end

local mana = params.target:GetMana()
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_void_custom_int", {duration = self.mana_duration})

params.target:SetMana(mana)

end

function modifier_antimage_mana_void_custom_tracker:GetModifierPreAttack_BonusDamage()
if not self:GetParent():HasModifier("modifier_antimage_void_4") then return end

return self:GetCaster():GetMaxMana()*self:GetCaster():GetTalentValue("modifier_antimage_void_4", "damage")/100
end 



function modifier_antimage_mana_void_custom_tracker:OnAbilityFullyCast(keys)
if not keys.ability then return end 
if keys.unit:GetTeamNumber() == self:GetCaster():GetTeamNumber() then return end
if keys.ability:IsItem() or UnvalidAbilities[keys.ability:GetName()] then return end
if keys.unit:IsMagicImmune() then return end
if (keys.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.cast_radius then return end
if not self:GetParent():IsAlive() then return end

if self:GetParent():HasModifier("modifier_antimage_void_3") then 
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_void_custom_speed", {duration = self.speed_duration})
end 


if not self:GetParent():HasModifier("modifier_antimage_void_5") then return end
if keys.unit:HasModifier("modifier_antimage_mana_void_custom_cast_cd") then return end

local unit = keys.unit

self:GetParent():EmitSound("Antimage.Void_stun")

local heal = unit:GetMaxMana()*self.cast_heal
my_game:GenericHeal(self:GetCaster(), heal, self:GetAbility())
          
local zap_pfx = ParticleManager:CreateParticle("particles/am_void_cd.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(zap_pfx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(zap_pfx, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(zap_pfx)


unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = self.cast_stun})
unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_antimage_mana_void_custom_cast_cd", {duration = self.cast_cd})
end



modifier_antimage_mana_void_custom_int = class({})
function modifier_antimage_mana_void_custom_int:IsHidden() return false end
function modifier_antimage_mana_void_custom_int:IsPurgable() return false end
function modifier_antimage_mana_void_custom_int:GetTexture() return "buffs/manavoid_int" end


function modifier_antimage_mana_void_custom_int:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_antimage_void_4", "max")
self.stack = self:GetCaster():GetTalentValue("modifier_antimage_void_4", "mana")/100


if not IsServer() then return end


self:SetStackCount(1)
self.RemoveForDuel = true 
end

function modifier_antimage_mana_void_custom_int:OnRefresh(table)
if not IsServer() then return end

if self:GetParent():IsHero() then 
 	self:GetParent():CalculateStatBonus(true)
end


if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_antimage_mana_void_custom_int:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MANA_BONUS,
}
end


function modifier_antimage_mana_void_custom_int:GetModifierManaBonus()
return self:GetStackCount()*self:GetCaster():GetMaxMana()*self.stack
end 



function modifier_antimage_mana_void_custom_int:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if self:GetStackCount() == 1 then 

	local particle_cast = "particles/am_mana_stack.vpcf"

	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

	self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 
  if self.effect_cast then 
  	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
  end
end

end











antimage_spell_seal_custom = class({})



function antimage_spell_seal_custom:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_antimage_void_7", "cd")
end

function antimage_spell_seal_custom:OnAbilityPhaseStart()
if not IsServer() then return end
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_break_custom_anim", {})

return true
end


function antimage_spell_seal_custom:OnAbilityPhaseInterrupted()
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_antimage_mana_break_custom_anim")
end






function antimage_spell_seal_custom:OnSpellStart()
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_antimage_mana_break_custom_anim")

local target = self:GetCursorTarget()
local caster = self:GetCaster()

local leakCast = ParticleManager:CreateParticle("particles/am_cast.vpcf", PATTACH_POINT_FOLLOW, target)
ParticleManager:SetParticleControlEnt(leakCast, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
ParticleManager:SetParticleControlEnt(leakCast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(leakCast)


target:AddNewModifier(self:GetCaster(), self, "modifier_antimage_mana_void_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_antimage_void_7", "duration")})

end


modifier_antimage_mana_void_custom_legendary = class({})


function modifier_antimage_mana_void_custom_legendary:IsHidden() return false end
function modifier_antimage_mana_void_custom_legendary:IsPurgable() return false end
function modifier_antimage_mana_void_custom_legendary:GetEffectName() return "particles/am_mana_mark.vpcf" end
function modifier_antimage_mana_void_custom_legendary:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_antimage_mana_void_custom_legendary:OnCreated(table)
if not IsServer() then return end
self.mana = self:GetCaster():GetTalentValue("modifier_antimage_void_7", "mana")/100

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, false)

end




function modifier_antimage_mana_void_custom_legendary:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end


function modifier_antimage_mana_void_custom_legendary:OnAbilityExecuted( params )
if not IsServer() then return end
if params.unit~=self:GetParent() then return end
if not params.ability:ProcsMagicStick() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end

self:GetParent():EmitSound("Hero_Antimage.ManaVoid")

local particle = ParticleManager:CreateParticle( "particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, Vector( 350, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( particle )

local damage = self:GetParent():GetMaxMana()*self.mana

self:GetParent():Script_ReduceMana(damage, self:GetAbility()) 

ApplyDamage({ victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility(), })

self:GetCaster():GenericHeal(damage, self:GetAbility())

SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), damage, nil)


end



modifier_antimage_mana_void_custom_cast_cd = class({})
function modifier_antimage_mana_void_custom_cast_cd:IsHidden() return true end
function modifier_antimage_mana_void_custom_cast_cd:IsPurgable() return false end
function modifier_antimage_mana_void_custom_cast_cd:OnCreated(table)
self.RemoveForDuel = true
end











modifier_antimage_mana_void_custom_aura = class({})

function modifier_antimage_mana_void_custom_aura:IsHidden() return true end
function modifier_antimage_mana_void_custom_aura:IsPurgable() return false end
function modifier_antimage_mana_void_custom_aura:RemoveOnDeath() return false end


function modifier_antimage_mana_void_custom_aura:OnCreated()
self.radius = self:GetCaster():GetTalentValue("modifier_antimage_void_2", "radius", true)
end 

function modifier_antimage_mana_void_custom_aura:GetAuraRadius()
    return self.radius
end

function modifier_antimage_mana_void_custom_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_antimage_mana_void_custom_aura:GetAuraSearchType() 
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_antimage_mana_void_custom_aura:GetModifierAura()
    return "modifier_antimage_mana_void_custom_aura_effect"
end

function modifier_antimage_mana_void_custom_aura:IsAura()
    return true
end







modifier_antimage_mana_void_custom_aura_effect = class({})
function modifier_antimage_mana_void_custom_aura_effect:IsHidden() return false end
function modifier_antimage_mana_void_custom_aura_effect:IsPurgable() return false end
function modifier_antimage_mana_void_custom_aura_effect:GetTexture() return "buffs/counterspell_slow" end

function modifier_antimage_mana_void_custom_aura_effect:OnCreated(table)

self.parent = self:GetParent()

self.mana = self:GetCaster():GetTalentValue("modifier_antimage_void_2", "mana")/100
self.interval = self:GetCaster():GetTalentValue("modifier_antimage_void_2", "interval")
self.PercentStr = self:GetCaster():GetTalentValue("modifier_antimage_void_2", "str")/100

if not IsServer() then return end
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_antimage_mana_void_custom_aura_effect:OnIntervalThink()
if not IsServer() then return end

self.parent:Script_ReduceMana(self.parent:GetMaxMana()*self.mana*self.interval, self:GetAbility()) 
end 



function modifier_antimage_mana_void_custom_aura_effect:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_antimage_mana_void_custom_aura_effect:GetModifierIncomingDamage_Percentage()
if not self:GetParent():IsCreep() then return end 

return self.PercentStr*-100
end 

modifier_antimage_mana_void_custom_speed = class({})
function modifier_antimage_mana_void_custom_speed:IsHidden() return false end
function modifier_antimage_mana_void_custom_speed:IsPurgable() return false end
function modifier_antimage_mana_void_custom_speed:GetTexture() return "buffs/void_speed" end
function modifier_antimage_mana_void_custom_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_antimage_void_3", "speed")
self.max = self:GetCaster():GetTalentValue("modifier_antimage_void_3", "max")

if not IsServer() then return end 

self:SetStackCount(1)
end 

function modifier_antimage_mana_void_custom_speed:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end 


function modifier_antimage_mana_void_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_antimage_mana_void_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self.speed
end