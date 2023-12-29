LinkLuaModifier("modifier_bloodseeker_blood_mist_custom", "abilities/bloodseeker/bloodseeker_blood_mist_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_bloodseeker_blood_mist_custom_slow", "abilities/bloodseeker/bloodseeker_blood_mist_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_bloodseeker_blood_mist_custom_shield", "abilities/bloodseeker/bloodseeker_blood_mist_custom", LUA_MODIFIER_MOTION_NONE )

bloodseeker_blood_mist_custom = class({})



function bloodseeker_blood_mist_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_spray_initial.vpcf', context )

end



function bloodseeker_blood_mist_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then
        self:SetHidden(false)
        if not self:IsTrained() then
        	self:SetLevel(1)
        end
    else
        self:SetHidden(true)
    end
end

function bloodseeker_blood_mist_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end

function bloodseeker_blood_mist_custom:OnToggle()
    local caster = self:GetCaster()
    local toggle = self:GetToggleState()
    
    if not IsServer() then return end
    if toggle then
   		caster:EmitSound("Hero_Boodseeker.Bloodmist")
        self.modifier = caster:AddNewModifier( caster, self, "modifier_bloodseeker_blood_mist_custom", {} )
        self:UseResources(false, false, false, true)
        caster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
    else
        if self.modifier and not self.modifier:IsNull() then
            self.modifier:Destroy()
        end
        caster:StopSound("Hero_Boodseeker.Bloodmist")
        self.modifier = nil
    end
end

modifier_bloodseeker_blood_mist_custom = class({})

function modifier_bloodseeker_blood_mist_custom:IsHidden() return false end
function modifier_bloodseeker_blood_mist_custom:IsPurgable() return false end
function modifier_bloodseeker_blood_mist_custom:IsPurgeException() return false end

function modifier_bloodseeker_blood_mist_custom:OnCreated()

self.hp_cost_per_second = self:GetAbility():GetSpecialValueFor("hp_cost_per_second")/100
self.damage = self:GetAbility():GetSpecialValueFor("damage_per_second")/100
self.damage_creeps = self:GetAbility():GetSpecialValueFor("creeps_damage")
self.radius = self:GetAbility():GetSpecialValueFor("radius")

self.shield_max = self:GetAbility():GetSpecialValueFor("attacks")
self.shield_duration = self:GetAbility():GetSpecialValueFor("shield_duration")

if not IsServer() then return end
self.self_table = {attacker = self:GetParent(), victim = self:GetParent(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL}
self.target_table = {attacker = self:GetParent(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()}


self.parent = self:GetParent()

self.interval = 0.3

self:StartIntervalThink(self.interval)
local radius = self:GetAbility():GetSpecialValueFor("radius")
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))
self:AddParticle(particle, false, false, -1, false, false)

local particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_scepter_blood_mist_spray_initial.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_2, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(particle_2, false, false, -1, false, false)
end

function modifier_bloodseeker_blood_mist_custom:OnIntervalThink()
if not IsServer() then return end

if not self:GetParent():HasScepter() then
    self:GetAbility():EndCooldown()
    self:GetAbility():ToggleAbility()
    return
end


self:SelfDamage()
self:EnemyDamage()
end

function modifier_bloodseeker_blood_mist_custom:SelfDamage()
if not IsServer() then return end
if self.parent:IsInvulnerable() then return end
if self.parent:IsMagicImmune() then return end
if self.parent:GetHealth() <= 1 then return end

self.self_table.damage = self.parent:GetMaxHealth() * self.hp_cost_per_second * self.interval
ApplyDamage(self.self_table)
end


function modifier_bloodseeker_blood_mist_custom:EnemyDamage()
if not IsServer() then return end

local targets = self.parent:FindTargets(self.radius)

for _, target in pairs(targets) do

	self.target_table.damage = target:GetMaxHealth() * self.damage * self.interval
	self.target_table.victim = target

	if target:IsCreep() then 
		self.target_table.damage = self.damage_creeps * self.interval
	end

    ApplyDamage(self.target_table)
end

end

function modifier_bloodseeker_blood_mist_custom:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_bloodseeker_blood_mist_custom:OnAttackLanded(params)
if not IsServer() then return end 
if self.parent ~= params.attacker then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end
if self.parent:HasModifier("modifier_bloodseeker_blood_mist_custom_shield") then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.shield_max then 
	self:SetStackCount(0)
	self.parent:AddNewModifier(self.parent, self:GetAbility() , "modifier_bloodseeker_blood_mist_custom_shield", {duration = self.shield_duration})
end 

end 


function modifier_bloodseeker_blood_mist_custom:GetAuraRadius()
	return self.radius
end

function modifier_bloodseeker_blood_mist_custom:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_bloodseeker_blood_mist_custom:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_bloodseeker_blood_mist_custom:GetAuraDuration()
	return 0.5
end

function modifier_bloodseeker_blood_mist_custom:GetModifierAura()
	return "modifier_bloodseeker_blood_mist_custom_slow"
end

function modifier_bloodseeker_blood_mist_custom:IsAura()
	return true
end





modifier_bloodseeker_blood_mist_custom_slow = class({})

function modifier_bloodseeker_blood_mist_custom_slow:IsPurgable() return false end

function modifier_bloodseeker_blood_mist_custom_slow:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_bloodseeker_blood_mist_custom_slow:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end


function modifier_bloodseeker_blood_mist_custom_slow:OnCreated()
self.slow = self:GetAbility():GetSpecialValueFor( "movement_slow" ) * -1
end

function modifier_bloodseeker_blood_mist_custom_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf"
end


function modifier_bloodseeker_blood_mist_custom_slow:StatusEffectPriority()
return 10000
end







modifier_bloodseeker_blood_mist_custom_shield = class({})
function modifier_bloodseeker_blood_mist_custom_shield:IsHidden() return false end
function modifier_bloodseeker_blood_mist_custom_shield:IsPurgable() return false end
function modifier_bloodseeker_blood_mist_custom_shield:GetTexture() return "buffs/berserker_active" end


function modifier_bloodseeker_blood_mist_custom_shield:GetEffectName() return 
"particles/bloodseeker/bloodrage_shield.vpcf"
end



function modifier_bloodseeker_blood_mist_custom_shield:OnCreated(table)
self.RemoveForDuel = true

self.max_shield = self:GetAbility():GetSpecialValueFor("shield")*self:GetParent():GetMaxHealth()/100


if not IsServer() then return end
self:SetStackCount(self.max_shield )
self:GetParent():EmitSound("BS.Bloodrage_shield")
end




function modifier_bloodseeker_blood_mist_custom_shield:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}

end



function modifier_bloodseeker_blood_mist_custom_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
	if params.report_max then 
		return self.max_shield
	else 
     	return self:GetStackCount()
    end 
end

if not IsServer() then return end

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()
    return -i
end

end
