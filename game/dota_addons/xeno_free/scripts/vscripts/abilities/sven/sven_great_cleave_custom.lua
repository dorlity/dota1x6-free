LinkLuaModifier( "modifier_sven_great_cleave_custom", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_slow", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_speed", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_armor", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_legendary_slow", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_legendary", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_combat_stacks", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_combat_timer", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_parry", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_parry_cd", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_parry_cd", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_healing", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sven_great_cleave_custom_healing_move", "abilities/sven/sven_great_cleave_custom", LUA_MODIFIER_MOTION_NONE )



sven_great_cleave_custom = class({})

sven_great_cleave_custom.range_bonus = {40, 60, 80}
sven_great_cleave_custom.range_slow = {-15, -20, -25}
sven_great_cleave_custom.range_slow_duration = 2
sven_great_cleave_custom.range_slow_chance = 30

sven_great_cleave_custom.cleave_bonus = {10, 20, 30}
sven_great_cleave_custom.cleave_armor = {-2, -4, -6}

sven_great_cleave_custom.speed_bonus = {4, 6, 8}
sven_great_cleave_custom.speed_max = 8
sven_great_cleave_custom.speed_duration = 4


sven_great_cleave_custom.stack_max = {15, 30}
sven_great_cleave_custom.stack_range = 700
sven_great_cleave_custom.stack_speed = {30, 60}
sven_great_cleave_custom.stack_damage = 2
sven_great_cleave_custom.stack_timer = 3

sven_great_cleave_custom.parry_reduce = -30
sven_great_cleave_custom.parry_cd = 15
sven_great_cleave_custom.parry_cd_inc = 9
sven_great_cleave_custom.parry_duration = 2
sven_great_cleave_custom.parry_heal = 6





function sven_great_cleave_custom:Precache(context)

PrecacheResource( "particle", "particles/sven_wave_normal.vpcf", context )
PrecacheResource( "particle", "particles/sven_wave_cast.vpcf", context )
PrecacheResource( "particle", "particles/sven_wave_god.vpcf", context )
PrecacheResource( "particle", "particles/sven_wave_cast_god.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf", context )
PrecacheResource( "particle", "particles/sven_wave_god_damage.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context )
PrecacheResource( "particle", "particles/lc_odd_proc_.vpcf", context )
PrecacheResource( "particle", "particles/jugg_parry.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf", context )

end







function sven_great_cleave_custom:GetIntrinsicModifierName()
return "modifier_sven_great_cleave_custom"
end


function sven_great_cleave_custom:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasModifier("modifier_sven_cleave_7") then 
    if IsClient() then 
        return self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "distance") - self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "width")
    else 
        return 999999
    end
end

return 
end

function sven_great_cleave_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_sven_cleave_7") then 
    return DOTA_ABILITY_BEHAVIOR_POINT
end

return DOTA_ABILITY_BEHAVIOR_PASSIVE
end



function sven_great_cleave_custom:GetCooldown(iLevel)
if not self:GetCaster():HasModifier("modifier_sven_cleave_7") then return end

local cd_max = self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "cd_max")
local cd_min = self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "cd_min")
local cd_inc = cd_max - cd_min

return cd_max - cd_inc*(math.min(1, self:GetCaster():GetUpgradeStack("modifier_sven_great_cleave_custom")/626))
end



function sven_great_cleave_custom:OnAbilityPhaseStart()

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK, 1.3)

self:GetCaster():EmitSound("Sven.Cleave_wave_pre")
return true
end

function sven_great_cleave_custom:OnAbilityPhaseInterrupted()

self:GetCaster():FadeGesture(ACT_DOTA_ATTACK)
end


function sven_great_cleave_custom:OnSpellStart()
if not IsServer() then return end

--self:GetCaster():FadeGesture(ACT_DOTA_ATTACK)

self:GetCaster():EmitSound("Sven.Cleave_wave_cast")

local point = self:GetCursorPosition()
local caster = self:GetCaster()

local part = "particles/sven_wave_normal.vpcf"
local part_cast = "particles/sven_wave_cast.vpcf"

if self:GetCaster():HasModifier("modifier_sven_gods_strength_custom") then 
    part = "particles/sven_wave_god.vpcf"
    part_cast = "particles/sven_wave_cast_god.vpcf"
end


local clown03_effect = ParticleManager:CreateParticle(part_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(clown03_effect, 0, self:GetCaster():GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex(clown03_effect)

local width = self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "width")
local speed = self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "speed")

ProjectileManager:CreateLinearProjectile({
        EffectName = part,
        Ability = self,
        vSpawnOrigin = caster:GetAbsOrigin(),
        fStartRadius = width,
        fEndRadius = width,
        vVelocity = (point - caster:GetAbsOrigin()):Normalized() * speed,
        fDistance = self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "distance") - width,
        Source = caster,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
        bProvidesVision = true,
        iVisionTeamNumber = caster:GetTeamNumber(),
        iVisionRadius = width,
        ExtraData = {x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y, z = self:GetAbsOrigin().z}
    })


self:GetCaster():EmitSound("Sven.Cleave_wave")
end

function sven_great_cleave_custom:OnProjectileHit_ExtraData(target, location, table)
if not IsServer() then return end
if not target then return end

local point_start = Vector(table.x, table.y, table.z)
local point_end = target:GetAbsOrigin()

local distance = (point_end - point_start):Length2D()
local k = math.max(0, math.min(1, distance/(self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "distance")*0.9) ))



target:AddNewModifier(self:GetCaster(), self, "modifier_sven_great_cleave_custom_legendary_slow", {duration = self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "duration") *(1 - target:GetStatusResistance())})


local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sven_great_cleave_custom_legendary", {k = k, duration = FrameTime()})
local no_cleave = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_no_cleave", {duration = FrameTime()})


self:GetCaster():PerformAttack(target, false, true, true, true, false, false, true)

if mod then 
    mod:Destroy()
end

if no_cleave then 
    no_cleave:Destroy()
end


local part = "particles/econ/items/zeus/zeus_immortal_2021/zeus_immortal_2021_static_field.vpcf"

if self:GetCaster():HasModifier("modifier_sven_gods_strength_custom") then 
    part = "particles/sven_wave_god_damage.vpcf"
end

local particle = ParticleManager:CreateParticle( part, PATTACH_POINT_FOLLOW, target )
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:ReleaseParticleIndex( particle )

target:EmitSound("Sven.Cry_shield_damage")

end








modifier_sven_great_cleave_custom = class({})


function modifier_sven_great_cleave_custom:IsHidden()
    return true
end


function modifier_sven_great_cleave_custom:OnCreated( kv )
    self.great_cleave_damage = self:GetAbility():GetSpecialValueFor( "great_cleave_damage" )
    self.great_cleave_start = self:GetAbility():GetSpecialValueFor( "cleave_starting_width" )
    self.great_cleave_end = self:GetAbility():GetSpecialValueFor( "cleave_ending_width" )
    self.great_cleave_distance = self:GetAbility():GetSpecialValueFor( "cleave_distance" )

    if not IsServer() then return end

    self:StartIntervalThink(1)

end


function modifier_sven_great_cleave_custom:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_sven_cleave_7") and not  self:GetParent():HasModifier("modifier_sven_cleave_5") then return end

self:SetStackCount(self:GetParent():GetDisplayAttackSpeed())

self:StartIntervalThink(0.1)
end



function modifier_sven_great_cleave_custom:OnRefresh( kv )
self:OnCreated(table)
end


function modifier_sven_great_cleave_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

    return funcs
end


function modifier_sven_great_cleave_custom:GetModifierBonusStats_Strength()
return self:GetAbility():GetSpecialValueFor("bonus_strength")
end


function modifier_sven_great_cleave_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent():IsIllusion() then return end
if params.attacker == params.unit then return end

if self:GetParent():HasModifier("modifier_sven_cleave_6") and
 params.attacker == self:GetParent() and (params.unit:IsCreep() or params.unit:IsHero())
 and params.unit:GetHealthPercent() <= self:GetCaster():GetTalentValue("modifier_sven_cleave_6", "health")
 and not params.inflictor then 

    local duration = self:GetCaster():GetTalentValue("modifier_sven_cleave_6", "duration")

    params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sven_great_cleave_custom_healing", {duration = duration})
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sven_great_cleave_custom_healing_move", {duration = duration})

end


if not self:GetParent():HasModifier("modifier_sven_cleave_4") then return end
if (params.attacker:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() >= self:GetAbility().stack_range then return end

local mod = self:GetParent():FindModifierByName("modifier_sven_great_cleave_custom_combat_stacks")

if mod and mod:GetStackCount() >= self:GetAbility().stack_max[self:GetCaster():GetUpgradeStack("modifier_sven_cleave_4")] then 
    return
end

local combat = false
if self:GetParent() == params.attacker and params.unit:IsRealHero() and not params.unit:IsCreep() then 
    combat = true
end


if self:GetParent() == params.unit and params.attacker:IsRealHero() and not params.attacker:IsCreep() then 
    combat = true
end


if combat == false then return end

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sven_great_cleave_custom_combat_timer", {duration = 1.1})
end








function modifier_sven_great_cleave_custom:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_sven_cleave_1") then return end

return self:GetAbility().range_bonus[self:GetParent():GetUpgradeStack("modifier_sven_cleave_1")]
end



function modifier_sven_great_cleave_custom:OnAttackLanded( params )
if not IsServer() then return end
if self:GetParent():IsIllusion() then return end
if self:GetParent():PassivesDisabled() then return end

if self:GetParent():HasModifier("modifier_sven_cleave_5") and self:GetParent() == params.target and (params.attacker:IsCreep() or params.attacker:IsHero())
    and not self:GetParent():HasModifier("modifier_sven_great_cleave_custom_parry_cd") then 

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sven_great_cleave_custom_parry", {duration = self:GetAbility().parry_duration})

    print(math.min(1, self:GetCaster():GetUpgradeStack("modifier_sven_great_cleave_custom")/626))
    print( self:GetCaster():GetUpgradeStack("modifier_sven_great_cleave_custom")/626)

    local cd = self:GetAbility().parry_cd - self:GetAbility().parry_cd_inc*(math.min(1, self:GetCaster():GetUpgradeStack("modifier_sven_great_cleave_custom")/626))

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sven_great_cleave_custom_parry_cd", {duration = cd})
end


if params.attacker ~= self:GetParent() then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

local damage = self.great_cleave_damage

if self:GetParent():HasModifier("modifier_sven_cleave_2") then 
    damage = damage + self:GetAbility().cleave_bonus[self:GetParent():GetUpgradeStack("modifier_sven_cleave_2")]

    params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sven_great_cleave_custom_armor", {duration = 1})
end

local cleaveDamage = ( damage * params.damage ) / 100.0

params.target:EmitSound("Hero_Sven.GreatCleave")

if not self:GetParent():HasModifier("modifier_no_cleave") then 
    DoCleaveAttack( self:GetParent(), params.target, self:GetAbility(), cleaveDamage, self.great_cleave_start, self.great_cleave_end, self.great_cleave_distance, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
end


if self:GetParent():HasModifier("modifier_sven_cleave_3") then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sven_great_cleave_custom_speed", {duration = self:GetAbility().speed_duration})
end


if not self:GetParent():HasModifier("modifier_sven_cleave_1") then return end
if not RollPseudoRandomPercentage(self:GetAbility().range_slow_chance ,222,self:GetParent()) then return end

params.target:EmitSound("DOTA_Item.Maim")
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sven_great_cleave_custom_slow", {duration = self:GetAbility().range_slow_duration*(1 - params.target:GetStatusResistance())})

end









modifier_sven_great_cleave_custom_slow = class({})
function modifier_sven_great_cleave_custom_slow:IsHidden() return false end
function modifier_sven_great_cleave_custom_slow:IsPurgable() return true end
function modifier_sven_great_cleave_custom_slow:GetTexture() return "buffs/cleave_slow" end
function modifier_sven_great_cleave_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_sven_great_cleave_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().range_slow[self:GetCaster():GetUpgradeStack("modifier_sven_cleave_1")]
end

function modifier_sven_great_cleave_custom_slow:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end


function modifier_sven_great_cleave_custom_slow:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end



modifier_sven_great_cleave_custom_speed = class({})
function modifier_sven_great_cleave_custom_speed:IsHidden() return false end
function modifier_sven_great_cleave_custom_speed:IsPurgable() return false end
function modifier_sven_great_cleave_custom_speed:GetTexture() return "buffs/cleave_speed" end
function modifier_sven_great_cleave_custom_speed:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_sven_great_cleave_custom_speed:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().speed_max then return end

self:IncrementStackCount()
end


function modifier_sven_great_cleave_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_sven_great_cleave_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetStackCount()*self:GetAbility().speed_bonus[self:GetParent():GetUpgradeStack("modifier_sven_cleave_3")]
end


modifier_sven_great_cleave_custom_armor = class({})
function modifier_sven_great_cleave_custom_armor:IsHidden() return true end
function modifier_sven_great_cleave_custom_armor:IsPurgable() return false end
function modifier_sven_great_cleave_custom_armor:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_sven_great_cleave_custom_armor:GetModifierPhysicalArmorBonus()
return self:GetAbility().cleave_armor[self:GetCaster():GetUpgradeStack("modifier_sven_cleave_2")]
end







modifier_sven_great_cleave_custom_legendary_slow = class({})
function modifier_sven_great_cleave_custom_legendary_slow:IsHidden() return true end
function modifier_sven_great_cleave_custom_legendary_slow:IsPurgable() return true end
function modifier_sven_great_cleave_custom_legendary_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_sven_great_cleave_custom_legendary_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_sven_great_cleave_custom_legendary_slow:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end


function modifier_sven_great_cleave_custom_legendary_slow:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_sven_great_cleave_custom_legendary_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "slow")
end 

modifier_sven_great_cleave_custom_legendary = class({})
function modifier_sven_great_cleave_custom_legendary:IsHidden() return true end
function modifier_sven_great_cleave_custom_legendary:IsPurgable() return false end

function modifier_sven_great_cleave_custom_legendary:OnCreated(table)
if not IsServer() then return end 
local damage_min = self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "damage_min") - 100

local damage_max = self:GetCaster():GetTalentValue("modifier_sven_cleave_7", "damage_max") - 100 - damage_min

self.damage = damage_min + table.k*damage_max
end

function modifier_sven_great_cleave_custom_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_sven_great_cleave_custom_legendary:GetModifierDamageOutgoing_Percentage()
return self.damage
end



modifier_sven_great_cleave_custom_combat_stacks = class({})
function modifier_sven_great_cleave_custom_combat_stacks:IsHidden() return self:GetStackCount() < 1
end
function modifier_sven_great_cleave_custom_combat_stacks:IsPurgable() return false end
function modifier_sven_great_cleave_custom_combat_stacks:RemoveOnDeath() return false end
function modifier_sven_great_cleave_custom_combat_stacks:GetTexture() return "buffs/cleave_stack" end

function modifier_sven_great_cleave_custom_combat_stacks:OnCreated(table)
if not IsServer() then return end

self.stack = 0

end


function modifier_sven_great_cleave_custom_combat_stacks:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_sven_great_cleave_custom_combat_stacks:GetModifierBaseAttack_BonusDamage()
return self:GetStackCount()*self:GetAbility().stack_damage
end

function modifier_sven_great_cleave_custom_combat_stacks:GetModifierAttackSpeedBonus_Constant()
if self:GetStackCount() >= self:GetAbility().stack_max[1] then 
    if self:GetStackCount() >= self:GetAbility().stack_max[2] then 
        return self:GetAbility().stack_speed[2]
    else 
        return self:GetAbility().stack_speed[1]
    end 
end
return
end

modifier_sven_great_cleave_custom_combat_timer = class({})
function modifier_sven_great_cleave_custom_combat_timer:IsHidden() return true end
function modifier_sven_great_cleave_custom_combat_timer:IsPurgable() return false end
function modifier_sven_great_cleave_custom_combat_timer:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(1)
end

function modifier_sven_great_cleave_custom_combat_timer:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sven_great_cleave_custom_combat_stacks", {})

if mod:GetStackCount() >= self:GetAbility().stack_max[self:GetCaster():GetUpgradeStack("modifier_sven_cleave_4")] then return end

if mod.stack then 
    mod.stack = mod.stack + 1

    if mod.stack >= self:GetAbility().stack_timer then 
        mod.stack = 0
        mod:IncrementStackCount()
        if mod:GetStackCount() == self:GetAbility().stack_max[1] or mod:GetStackCount() == self:GetAbility().stack_max[2] then 
            
            local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
            ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
            ParticleManager:ReleaseParticleIndex(particle_peffect)
            self:GetCaster():EmitSound("BS.Thirst_legendary_active")
        end
    end
end


end




modifier_sven_great_cleave_custom_parry = class({})
function modifier_sven_great_cleave_custom_parry:IsHidden() return false end
function modifier_sven_great_cleave_custom_parry:IsPurgable() return false end
function modifier_sven_great_cleave_custom_parry:GetTexture() return "buffs/cleave_parry" end
function modifier_sven_great_cleave_custom_parry:OnCreated(table)

self.heal = (self:GetParent():GetMaxHealth()*self:GetAbility().parry_heal/100)/self:GetAbility().parry_duration

if not IsServer() then return end

self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "LC.Courage_armor"
self.buff_particles = {}

self:GetParent():EmitSound("Sven.Cleave_parry")


self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)

self:OnIntervalThink()
self:StartIntervalThink(0.95)
end

function modifier_sven_great_cleave_custom_parry:OnIntervalThink()
if not IsServer() then return end
local target = self:GetParent()

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
ParticleManager:ReleaseParticleIndex( particle )


SendOverheadEventMessage(target, 10, target, self.heal, nil)
end


function modifier_sven_great_cleave_custom_parry:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}

end


function modifier_sven_great_cleave_custom_parry:GetModifierHealthRegenPercentage()
return self:GetAbility().parry_heal/self:GetAbility().parry_duration
end

function modifier_sven_great_cleave_custom_parry:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end
if params.inflictor then return end

self:GetParent():EmitSound("Juggernaut.Parry")
local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )

return self:GetAbility().parry_reduce
end



modifier_sven_great_cleave_custom_parry_cd = class({})
function modifier_sven_great_cleave_custom_parry_cd:IsHidden() return false end
function modifier_sven_great_cleave_custom_parry_cd:IsPurgable() return false end
function modifier_sven_great_cleave_custom_parry_cd:GetTexture() return "buffs/cleave_parry" end
function modifier_sven_great_cleave_custom_parry_cd:IsDebuff() return true end
function modifier_sven_great_cleave_custom_parry_cd:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true

end

function modifier_sven_great_cleave_custom_parry_cd:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_sven_great_cleave_custom_parry_cd:OnTooltip()
return self:GetAbility().parry_cd - self:GetAbility().parry_cd_inc*(math.min(1, self:GetCaster():GetUpgradeStack("modifier_sven_great_cleave_custom")/626))
end








modifier_sven_great_cleave_custom_healing = class({})
function modifier_sven_great_cleave_custom_healing:IsHidden() return false end
function modifier_sven_great_cleave_custom_healing:IsPurgable() return true end
function modifier_sven_great_cleave_custom_healing:GetTexture() return "buffs/cleave_healing" end
function modifier_sven_great_cleave_custom_healing:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
  MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_sven_great_cleave_custom_healing:OnCreated()
self.heal_reduce = self:GetCaster():GetTalentValue("modifier_sven_cleave_6", "heal_reduce")
end


function modifier_sven_great_cleave_custom_healing:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce 
end

function modifier_sven_great_cleave_custom_healing:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce 
end

function modifier_sven_great_cleave_custom_healing:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce 
end



modifier_sven_great_cleave_custom_healing_move = class({})
function modifier_sven_great_cleave_custom_healing_move:IsHidden() return false end
function modifier_sven_great_cleave_custom_healing_move:IsPurgable() return false end
function modifier_sven_great_cleave_custom_healing_move:GetTexture() return "buffs/cleave_healing" end
function modifier_sven_great_cleave_custom_healing_move:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_sven_great_cleave_custom_healing_move:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_sven_cleave_6", "speed")
end


function modifier_sven_great_cleave_custom_healing_move:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_sven_great_cleave_custom_healing_move:GetEffectName()
    return "particles/units/heroes/hero_axe/axe_cullingblade_sprint.vpcf"
end

function modifier_sven_great_cleave_custom_healing_move:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

