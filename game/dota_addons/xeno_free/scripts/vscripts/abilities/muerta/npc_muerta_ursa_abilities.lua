LinkLuaModifier("modifier_npc_muerta_ursa_speed", "abilities/muerta/npc_muerta_ursa_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc_muerta_ursa_passive", "abilities/muerta/npc_muerta_ursa_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc_muerta_ursa_debuff", "abilities/muerta/npc_muerta_ursa_abilities", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_npc_muerta_ursa_slow", "abilities/muerta/npc_muerta_ursa_abilities", LUA_MODIFIER_MOTION_NONE)


npc_muerta_ursa_speed = class({})



function npc_muerta_ursa_speed:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()
local sound_cast = "Hero_Ursa.Overpower"

self:GetCaster():EmitSound(sound_cast)

caster:StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)


caster:AddNewModifier(caster, self, "modifier_npc_muerta_ursa_speed", {duration = self:GetSpecialValueFor("duration")})

end


modifier_npc_muerta_ursa_speed = class({})

function modifier_npc_muerta_ursa_speed:IsHidden() return true end
function modifier_npc_muerta_ursa_speed:IsPurgable() return true end
function modifier_npc_muerta_ursa_speed:OnCreated(table)

self.move = self:GetAbility():GetSpecialValueFor("move")
self.speed = self:GetAbility():GetSpecialValueFor("speed")

if not IsServer() then return end

self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.ursa_overpower_buff_particle = "particles/units/heroes/hero_ursa/ursa_overpower_buff.vpcf"

local ursa_overpower_buff_particle_fx = ParticleManager:CreateParticle(self.ursa_overpower_buff_particle, PATTACH_CUSTOMORIGIN, self.caster)
--ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_head", self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 1, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 2, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(ursa_overpower_buff_particle_fx, 3, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
self:AddParticle(ursa_overpower_buff_particle_fx, false, false, -1, false, false)

self:SetStackCount(self:GetAbility():GetSpecialValueFor("attacks"))
end

function modifier_npc_muerta_ursa_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_EVENT_ON_ATTACK
}
end


function modifier_npc_muerta_ursa_speed:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_npc_muerta_ursa_speed:GetModifierAttackSpeedBonus_Constant()
if self:GetStackCount() == 0 then return end

return self.speed
end


function modifier_npc_muerta_ursa_speed:OnAttack(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if self:GetStackCount() == 0 then return end

self:DecrementStackCount()
end










npc_muerta_ursa_passive = class({})
function npc_muerta_ursa_passive:GetIntrinsicModifierName()
return "modifier_npc_muerta_ursa_passive"
end


modifier_npc_muerta_ursa_passive = class({})
function modifier_npc_muerta_ursa_passive:IsHidden() return true end
function modifier_npc_muerta_ursa_passive:IsPurgable() return false end
function modifier_npc_muerta_ursa_passive:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
}
end

function modifier_npc_muerta_ursa_passive:GetModifierProcAttack_BonusDamage_Physical(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end


local swipes_particle = "particles/units/heroes/hero_ursa/ursa_fury_swipes.vpcf"

local swipes_particle_fx = ParticleManager:CreateParticle(swipes_particle, PATTACH_ABSORIGIN, params.target)
ParticleManager:SetParticleControl(swipes_particle_fx, 0, params.target:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(swipes_particle_fx)

local mod = params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_npc_muerta_ursa_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
local damage = 0

if mod then 
	damage = mod:GetStackCount()*self:GetParent():GetAverageTrueAttackDamage(nil)*self:GetAbility():GetSpecialValueFor("damage")/100
end

return damage
end


modifier_npc_muerta_ursa_debuff = class({})
function modifier_npc_muerta_ursa_debuff:IsHidden() return false end
function modifier_npc_muerta_ursa_debuff:IsPurgable() return false end
function modifier_npc_muerta_ursa_debuff:GetTexture() return "ursa_overpower" end
function modifier_npc_muerta_ursa_debuff:OnCreated(table)
self.damage = self:GetAbility():GetSpecialValueFor("damage")

if not IsServer() then return end
self:SetStackCount(1)
end


function modifier_npc_muerta_ursa_debuff:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_npc_muerta_ursa_debuff:GetEffectName()
	return "particles/units/heroes/hero_ursa/ursa_fury_swipes_debuff.vpcf"
end

function modifier_npc_muerta_ursa_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_npc_muerta_ursa_debuff:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_npc_muerta_ursa_debuff:OnTooltip()
return self:GetStackCount()*self.damage
end








npc_muerta_ursa_clap = class({})


function npc_muerta_ursa_clap:OnAbilityPhaseStart()
    self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
    self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.7)
      
    self.radius = self:GetSpecialValueFor("radius")  
    
	self:GetCaster():EmitSound("n_creep_Ursa.Clap")
    local particle_cast = "particles/red_zone.vpcf"
    self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetOrigin() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
    ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( 1, 0, 0 ) )

    return true
end 



function npc_muerta_ursa_clap:OnAbilityPhaseInterrupted()

ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:DestroyParticle(self.effect_cast, true)
self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
end



function npc_muerta_ursa_clap:OnSpellStart()
if not IsServer() then return end

ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:DestroyParticle(self.effect_cast, true)

self.aoe = self:GetSpecialValueFor("radius")

self:GetCaster():EmitSound("Hero_Ursa.Earthshock")

local trail_pfx = ParticleManager:CreateParticle("particles/neutral_fx/ursa_thunderclap.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
ParticleManager:SetParticleControl(trail_pfx, 1, Vector(self.aoe , 0 , 0 ) )
ParticleManager:ReleaseParticleIndex(trail_pfx)    

local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self.aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
    
local passive = self:GetCaster():FindAbilityByName("npc_muerta_ursa_passive")

for _,target in pairs(targets) do 

	if passive then 
		for i = 1,self:GetSpecialValueFor("stacks") do
			target:AddNewModifier(self:GetCaster(), passive, "modifier_npc_muerta_ursa_debuff", {duration = passive:GetSpecialValueFor("duration")})
		end
	end

	target:AddNewModifier(self:GetCaster(), self, "modifier_npc_muerta_ursa_slow", {duration = (1 - target:GetStatusResistance())*self:GetSpecialValueFor("duration")})
end

end


modifier_npc_muerta_ursa_slow = class({})
function modifier_npc_muerta_ursa_slow:IsHidden() return false end
function modifier_npc_muerta_ursa_slow:IsPurgable() return true end

function modifier_npc_muerta_ursa_slow:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("slow")
end

function modifier_npc_muerta_ursa_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_npc_muerta_ursa_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_npc_muerta_ursa_slow:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_npc_muerta_ursa_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_npc_muerta_ursa_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_npc_muerta_ursa_slow:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end

