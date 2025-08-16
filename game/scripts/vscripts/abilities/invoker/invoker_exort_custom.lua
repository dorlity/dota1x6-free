LinkLuaModifier("modifier_invoker_exort_custom_passive", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_exort_custom", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_sun_strike_custom", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_thinker", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_burn", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_burn_count", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_stack", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forged_spirit_melting_strike_custom_debuff", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forged_spirit_melting_strike_custom_slow", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forged_spirit_melting_strike_custom_movespeed", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forged_spirit_melting_strike_custom_range", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_cataclysm", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_cataclysm_caster", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_cataclysm_stack", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_cataclysm_visual", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_forged_spirit_custom_tracker", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_sun_strike_custom_fire", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_sun_strike_custom_fire_debuff", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_sun_strike_custom_blind", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )

invoker_exort_custom = class({})

function invoker_exort_custom:CreateTalent()
local ability = self:GetCaster():FindAbilityByName("invoker_chaos_meteor_custom")
if not ability then return end
self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_invoker_chaos_meteor_custom_cataclysm_stack", {})
end

function invoker_exort_custom:ProcsMagicStick()
return false
end

function invoker_exort_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_invoker_persona_1") or self:GetCaster():HasModifier("modifier_invoker_persona_2") or self:GetCaster():HasModifier("modifier_invoker_persona_3") or self:GetCaster():HasModifier("modifier_invoker_persona_4") or self:GetCaster():HasModifier("modifier_invoker_persona_5") or self:GetCaster():HasModifier("modifier_invoker_persona_6") then
    return "invoker_exort_persona1"
end
if self:GetCaster():HasModifier("modifier_magus_apex_custom") then
    return "invoker/magus_apex/invoker_exort"
end
return "invoker_exort"
end


function invoker_exort_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", context )
PrecacheResource( "particle", "particles/invoker/sun_stike_fast.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", context )
PrecacheResource( "particle", "particles/invoker/sun_strike_radius.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context )
PrecacheResource( "particle", "particles/invoker/sun_fire.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/black_powder_blind_debuff.vpcf", context )
PrecacheResource( "particle", "particles/invoker/meteor_mark.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", context )

PrecacheResource( "model", "models/heroes/invoker/forge_spirit.vmdl", context )
PrecacheResource( "model", "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl", context )
PrecacheResource( "model", "models/items/invoker_kid/continuum_echoes_forge_spirit/continuum_echoes_forge_spirit.vmdl", context )
end



function invoker_exort_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_invoker_exort_custom_passive"
end



function invoker_exort_custom:OnSpellStart()
local caster = self:GetCaster()

caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

local modifier = caster:AddNewModifier(
    caster,
    self,
    "modifier_invoker_exort_custom",
    {  }
)
self.invoke:AddOrb( modifier )
end


function invoker_exort_custom:OnUpgrade()
if not self.invoke then
    local invoke = self:GetCaster():FindAbilityByName( "invoker_invoke_custom" )
    if invoke:GetLevel()<1 then invoke:UpgradeAbility(true) end
    self.invoke = invoke
else
    self.invoke:UpdateOrb("modifier_invoker_exort_custom", self:GetLevel())
end

end


modifier_invoker_exort_custom = class({})
function modifier_invoker_exort_custom:IsHidden() return false end
function modifier_invoker_exort_custom:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_invoker_exort_custom:IsPurgable() return false end


function modifier_invoker_exort_custom:OnCreated( kv )
self.caster = self:GetCaster()
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_invoker_exort_custom:OnRefresh( kv )
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_invoker_exort_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end

function modifier_invoker_exort_custom:GetModifierPreAttack_BonusDamage()
if self.caster:HasShard() then return end
return self.damage
end




modifier_invoker_exort_custom_passive = class({})
function modifier_invoker_exort_custom_passive:IsHidden() return true end
function modifier_invoker_exort_custom_passive:IsPurgable() return false end
function modifier_invoker_exort_custom_passive:IsPurgeException() return false end

function modifier_invoker_exort_custom_passive:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.int = self.ability:GetSpecialValueFor("intelligence_bonus")
self.damage = self.ability:GetSpecialValueFor( "damage" )
self.shard_bonus = self.ability:GetSpecialValueFor("shard_bonus")/100

if not IsServer() then return end
self:StartIntervalThink(FrameTime())
end


function modifier_invoker_exort_custom_passive:OnRefresh()
self.damage = self.ability:GetSpecialValueFor( "damage" )
end


function modifier_invoker_exort_custom_passive:OnIntervalThink()
if not IsServer() then return end
local mod = self.parent:FindAllModifiersByName("modifier_invoker_exort_custom")

if mod then
    self:SetStackCount(#mod)
end

end

function modifier_invoker_exort_custom_passive:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
}
end

function modifier_invoker_exort_custom_passive:GetModifierBonusStats_Intellect()
return self.int*self.ability:GetLevel()
end

function modifier_invoker_exort_custom_passive:GetModifierPreAttack_BonusDamage()
if not self.parent:HasShard() then return end
return 3*self.damage*(1 + self.shard_bonus)
end










invoker_sun_strike_custom = class({})

function invoker_sun_strike_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_invoker_exort_2") then
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_exort_2", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function invoker_sun_strike_custom:GetBehavior()
return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES
end

function invoker_sun_strike_custom:GetAOERadius()
return self:GetSpecialValueFor( "area_of_effect" ) + self:GetCaster():GetTalentValue("modifier_invoker_exort_5", "radius")
end

function invoker_sun_strike_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_magus_apex_custom") then
    return "invoker/magus_apex/invoker_sun_strike"
end
return "invoker_sun_strike"
end


function invoker_sun_strike_custom:OnSpellStart(new_point)

local caster = self:GetCaster()
local is_legendary = 0
local point
local delay = self:GetSpecialValueFor("delay") + caster:GetTalentValue("modifier_invoker_exort_5", "delay")
local vision_distance = self:GetSpecialValueFor("vision_distance")
local vision_duration = self:GetSpecialValueFor("vision_duration")

local ult = caster:FindAbilityByName("invoker_invoke_custom")

if new_point then 
    point = new_point

    is_legendary = 1

    local sound = "Hero_Invoker.SunStrike.Charge"
    if caster:HasModifier("modifier_magus_apex_custom") then
        sound = "Hero_Invoker.SunStrike.Charge.Apex"
    end

    EmitSoundOnLocationWithCaster( point, sound, caster )
else 
    local sound = "Invoker.Sun_strike"
    if caster:HasModifier("modifier_magus_apex_custom") then
        sound = "Invoker.Sun_strike.Apex"
    end
    point = self:GetCursorPosition()
    caster:StartGesture(ACT_DOTA_CAST_SUN_STRIKE)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), "generic_sound",  {sound = sound})
end 

CreateModifierThinker( caster, self, "modifier_invoker_sun_strike_custom", {is_legendary = is_legendary, duration = delay }, point, caster:GetTeamNumber(), false )
AddFOWViewer(caster:GetTeamNumber(), point, vision_distance, vision_duration, false )
end



modifier_invoker_sun_strike_custom = class({})
function modifier_invoker_sun_strike_custom:IsHidden() return true end
function modifier_invoker_sun_strike_custom:IsPurgable() return false end

function modifier_invoker_sun_strike_custom:OnCreated( kv )
if not IsServer() then return end

self.parent = self:GetParent()
self.ability =  self:GetAbility()
self.caster = self:GetCaster()

self.area_of_effect = self.ability:GetSpecialValueFor("area_of_effect") + self.caster:GetTalentValue("modifier_invoker_exort_5", "radius")
self.damage = self.caster:GetValueExort(self.ability, "damage")

self.blind_duration = self.caster:GetTalentValue("modifier_invoker_exort_5", "duration")

self.is_legendary = 0

if kv.is_legendary and kv.is_legendary == 1 then 
    self.is_legendary = 1
end 

local part = "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf"
if self.caster:HasModifier("modifier_magus_apex_custom") then
    part = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf"
end
if self.caster:HasTalent("modifier_invoker_exort_5") then 
    part = "particles/invoker/sun_stike_fast.vpcf"
    if self.caster:HasModifier("modifier_magus_apex_custom") then
        part = "particles/invoker_sunstrike_donate/invoker_sun_strike_team_immortal.vpcf"
    end
end 

local effect_cast = ParticleManager:CreateParticleForTeam( part, PATTACH_WORLDORIGIN, self.caster, self.caster:GetTeamNumber() )
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( 40, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_invoker_sun_strike_custom:OnDestroy( kv )
if not IsServer() then return end 

local damageTable =
{
    attacker = self.caster,
    damage_type = DAMAGE_TYPE_PURE,
    ability = self.ability,
}

local enemies = self.caster:FindTargets(self.area_of_effect, self.parent:GetAbsOrigin()) 
local heroes_hit = false
local invoke_ability = self.caster:FindAbilityByName("invoker_invoke_custom")

for _,enemy in pairs(enemies) do
    damageTable.victim = enemy

    if enemy:IsRealHero() then 
        heroes_hit = true    
    end     

    if invoke_ability then 
        invoke_ability:AbilityHit(enemy)
    end 

    if self.caster:HasTalent("modifier_invoker_exort_5") then 
        enemy:AddNewModifier(self.caster, self.ability, "modifier_invoker_sun_strike_custom_blind", {duration = self.blind_duration})
    end

    damageTable.damage = self.damage
    DoDamage(damageTable)
end

if heroes_hit == true and self.is_legendary == 0 then 
    local mod = self.caster:FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")
    local max = math.ceil(self.caster:GetTalentValue("modifier_invoker_exort_7", "sun_stack")/self.caster:GetTalentValue("modifier_invoker_exort_7", "attack_stack"))

    if mod then 
        for i = 1, max do
            mod:AddStack()
        end
    end 
end

local part = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"
if self.caster:HasModifier("modifier_magus_apex_custom") then
    part = "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf"
end
if self.caster:HasTalent("modifier_invoker_exort_5") then 
    part = "particles/invoker/sun_strike_radius.vpcf"
    if self.caster:HasModifier("modifier_magus_apex_custom") then
        part = "particles/invoker_sunstrike/invoker_sun_strike_immortal_donateexplos.vpcf"
    end
end

if self.caster:HasTalent("modifier_invoker_exort_2") then 
  CreateModifierThinker(self.caster, self.ability, "modifier_invoker_sun_strike_custom_fire", {duration = self.caster:GetTalentValue("modifier_invoker_exort_2", "duration")}, self.parent:GetAbsOrigin(), self.caster:GetTeamNumber(), false)
end


local effect_cast = ParticleManager:CreateParticle( part, PATTACH_WORLDORIGIN, self.caster )
ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.area_of_effect, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

local sound ="Hero_Invoker.SunStrike.Ignite"
if self.caster:HasModifier("modifier_magus_apex_custom") then
    sound = "Hero_Invoker.SunStrike.Ignite.Apex"
end
EmitSoundOnLocationWithCaster( self.parent:GetOrigin(), sound, self.caster )
UTIL_Remove( self.parent )
end








invoker_chaos_meteor_custom = class({})

function invoker_chaos_meteor_custom:GetChannelTime()
if not self:GetCaster():HasTalent("modifier_invoker_exort_7") then return 0 end
return self:GetCastTime() + 0.1
end

function invoker_chaos_meteor_custom:GetBehavior()
if  self:GetCaster():HasTalent("modifier_invoker_exort_7") then 
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_CHANNELLED 
end 
return DOTA_ABILITY_BEHAVIOR_POINT +  DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function invoker_chaos_meteor_custom:GetAOERadius()
if not self:GetCaster():HasTalent("modifier_invoker_exort_7") then return end
return self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "radius")
end

function invoker_chaos_meteor_custom:GetCastTime()
local caster = self:GetCaster()
if not caster:HasTalent("modifier_invoker_exort_7") then return 0 end
local bonus = 0
if caster:HasModifier("modifier_invoker_chaos_meteor_custom_cataclysm_stack") then 
    bonus = caster:GetUpgradeStack("modifier_invoker_chaos_meteor_custom_cataclysm_stack")*caster:GetTalentValue("modifier_invoker_exort_7", "attack_stack")
end 
return caster:GetTalentValue("modifier_invoker_exort_7", "duration") + bonus + FrameTime()*2
end 

function invoker_chaos_meteor_custom:GetAbilityTextureName()
return "invoker_chaos_meteor"
end


function invoker_chaos_meteor_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_invoker_exort_2") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_exort_2", "cd")
end 
return (self.BaseClass.GetCooldown( self, level ) + bonus)
end


function invoker_chaos_meteor_custom:OnSpellStart(new_point)

local caster = self:GetCaster()
local point
local is_legendary = 0

if new_point then 
    point = new_point
    is_legendary = 1
else 
    point = self:GetCursorPosition()

    if caster:HasTalent("modifier_invoker_exort_7") then 

        local max_time = self:GetCastTime()
        self.thinker = CreateModifierThinker( caster, self, "modifier_invoker_chaos_meteor_custom_cataclysm", {max = max_time}, point, caster:GetTeamNumber(), false )
    else 

        caster:StartGesture(ACT_DOTA_CAST_CHAOS_METEOR)
    end 
end 

if point == caster:GetAbsOrigin() then
    point = point + caster:GetForwardVector()
end

CreateModifierThinker( caster, self, "modifier_invoker_chaos_meteor_custom_thinker", {is_legendary = is_legendary}, point, caster:GetTeamNumber(), false )
end



function invoker_chaos_meteor_custom:OnChannelFinish(bInterrupted)
if self.thinker and not self.thinker:IsNull() then 
    self.thinker:Destroy()
end 

local mod = self:GetCaster():FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")

if mod then 
    mod:SetStackCount(0)
end 

end 



modifier_invoker_chaos_meteor_custom_thinker = class({})
function modifier_invoker_chaos_meteor_custom_thinker:IsHidden() return true end

function modifier_invoker_chaos_meteor_custom_thinker:OnCreated(kv)
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.caster_origin = self.caster:GetOrigin()
self.parent_origin = self.parent:GetOrigin()
self.direction = self.parent_origin - self.caster_origin

self.scepter_distance = self.ability:GetSpecialValueFor("scepter_distance")

self.is_legendary = kv.is_legendary

if kv.is_legendary == 1 then 
    self.direction = self.caster:GetForwardVector()
    self.caster_origin = self.parent_origin - self.direction*(self.caster:GetTalentValue("modifier_invoker_exort_7", "radius", "true")/2)
end 

self.direction.z = 0
self.direction = self.direction:Normalized()

self.delay = self.ability:GetSpecialValueFor("land_time")
self.radius = self.ability:GetSpecialValueFor("area_of_effect")
self.distance = self.caster:GetValueWex(self.ability, "travel_distance")
self.speed = self.ability:GetSpecialValueFor("travel_speed")
self.vision = self.ability:GetSpecialValueFor("vision_distance")
self.vision_duration = self.ability:GetSpecialValueFor("end_vision_duration")
self.interval = self.ability:GetSpecialValueFor("damage_interval")
self.duration = self.ability:GetSpecialValueFor("burn_duration")

self.stun = self.ability:GetSpecialValueFor("scepter_stun")
self.damage = self.caster:GetValueExort(self.ability, "main_damage")

self.fallen = false
self.hit_hero = {}

self.damageTable = 
{
    attacker = self.caster,
    damage = self.damage,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability,
}

self.parent:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
self.nMoveStep = 0
self:StartIntervalThink(self.delay)
self:PlayEffects1()
end


function modifier_invoker_chaos_meteor_custom_thinker:OnDestroy()
if not IsServer() then return end

AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetOrigin(), self.vision, self.vision_duration, false)
StopSoundOn("Hero_Invoker.ChaosMeteor.Loop", self.parent)

if self.nLinearProjectile then
    ProjectileManager:DestroyLinearProjectile(self.nLinearProjectile)
end

end

function modifier_invoker_chaos_meteor_custom_thinker:OnIntervalThink()

if not self.fallen then
    self.fallen = true
    self:StartIntervalThink(self.interval)
    self:Burn(true)
    self:PlayEffects2()
else
    self:Move_Burn()
end

end


function modifier_invoker_chaos_meteor_custom_thinker:Burn(first)
if not IsServer() then return end

for _, enemy in pairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())) do

    local mod  = enemy:FindModifierByName("modifier_invoker_chaos_meteor_custom_stack")
    local damage = self.damage
    if mod then
        damage = damage*(1 + mod:GetStackCount()*mod.damage)

        if self.is_legendary == 0 and mod:GetStackCount() >= mod.max and not self.hit_hero[enemy] then 

            local duration = mod.stun*(1 - enemy:GetStatusResistance())
            enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = duration})

            local distance = duration*(self.speed * 0.75)
            local center = enemy:GetAbsOrigin() - self.direction*10

            local knockbackProperties =
            {
              center_x = center.x,
              center_y = center.y,
              center_z = center.z,
              duration = duration,
              knockback_duration = duration,
              knockback_distance = distance,
              knockback_height = 0,
              should_stun = 0
            }
            enemy:AddNewModifier( self.caster, self.ability, "modifier_knockback", knockbackProperties )

        end 
    end

    self.damageTable.victim = enemy
    self.damageTable.damage = damage

    if not self.hit_hero[enemy] then 
        self.hit_hero[enemy] = true

        local ability = self.caster:FindAbilityByName("invoker_invoke_custom")
        if ability then 
            ability:AbilityHit(enemy)
        end 
    end 

    DoDamage(self.damageTable)
    enemy:AddNewModifier( self.caster, self.ability, "modifier_invoker_chaos_meteor_custom_burn", {duration = self.duration } )
    enemy:AddNewModifier( self.caster, self.ability, "modifier_invoker_chaos_meteor_custom_burn_count", { duration = self.duration } )
end

end

function modifier_invoker_chaos_meteor_custom_thinker:Move_Burn()
 
local target = self.direction * self.speed * self.interval
self.parent:SetOrigin(self.parent:GetOrigin() + target)
self.nMoveStep = self.nMoveStep+1
self:Burn()

if self.nMoveStep and self.nMoveStep > 20 then
    self:Destroy()
    return
end

if (self.parent:GetOrigin() - self.parent_origin + target):Length2D() > self.distance then
    self:Destroy()
    return
end

end

function modifier_invoker_chaos_meteor_custom_thinker:PlayEffects1()
local height = 1500
local height_target = -0
local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect_cast, 0, self.caster_origin + Vector(0, 0, height))
ParticleManager:SetParticleControl(effect_cast, 1, self.parent_origin + Vector(0, 0, height_target))
ParticleManager:SetParticleControl(effect_cast, 2, Vector(self.delay, 0, 0))
ParticleManager:ReleaseParticleIndex(effect_cast)
EmitSoundOnLocationWithCaster(self.caster_origin, "Hero_Invoker.ChaosMeteor.Cast", self.caster)
self.parent:EmitSound( "Hero_Invoker.ChaosMeteor.Loop")
end

function modifier_invoker_chaos_meteor_custom_thinker:PlayEffects2()
local meteor_projectile = 
{
    Ability = self.ability,
    EffectName = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
    vSpawnOrigin = self.parent_origin,
    fDistance = self.distance,
    fStartRadius = self.radius,
    fEndRadius = self.radius,
    Source = self.caster,
    bHasFrontalCone = false,
    bReplaceExisting = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
    iUnitTargetType = DOTA_UNIT_TARGET_NONE,
    bDeleteOnHit = false,
    vVelocity = self.direction * self.speed,
    bProvidesVision = true,
    iVisionRadius = self.vision,
    iVisionTeamNumber = self.caster:GetTeamNumber()
}
self.nLinearProjectile = ProjectileManager:CreateLinearProjectile(meteor_projectile)
EmitSoundOnLocationWithCaster(self.parent_origin, "Hero_Invoker.ChaosMeteor.Impact", self.caster)

end







modifier_invoker_chaos_meteor_custom_burn = class({})
function modifier_invoker_chaos_meteor_custom_burn:IsHidden() return true end
function modifier_invoker_chaos_meteor_custom_burn:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_invoker_chaos_meteor_custom_burn:OnCreated(kv)
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not self.ability or self.ability:IsNull() then return end
self.damage = self.caster:GetValueExort(self.ability, "burn_dps")

local delay = 1 - FrameTime()
self.damageTable = 
{
    victim = self.parent,
    attacker = self.caster,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability,
}
self:StartIntervalThink(delay)

end

function modifier_invoker_chaos_meteor_custom_burn:OnIntervalThink()
if not IsServer() then return end
if not self.ability or self.ability:IsNull() then return end


local mod  = self.parent:FindModifierByName("modifier_invoker_chaos_meteor_custom_stack")
local damage = self.damage
if mod then
    damage = damage * (1 + mod:GetStackCount()*mod.damage)
end
self.damageTable.damage = damage

DoDamage(self.damageTable)
self.parent:EmitSound("Hero_Invoker.ChaosMeteor.Damage")
end

function modifier_invoker_chaos_meteor_custom_burn:OnDestroy()
if not IsServer() then return end 

local mod = self.parent:FindModifierByName("modifier_invoker_chaos_meteor_custom_burn_count")

if mod then 
    mod:DecrementStackCount()
    if mod:GetStackCount() < 1 then 
        mod:Destroy()
    end
end 

end 


modifier_invoker_chaos_meteor_custom_burn_count = class({})
function modifier_invoker_chaos_meteor_custom_burn_count:IsHidden() return false end
function modifier_invoker_chaos_meteor_custom_burn_count:IsPurgable() return false end
function modifier_invoker_chaos_meteor_custom_burn_count:OnCreated()
if not IsServer() then return end 
self:SetStackCount(1)
end 

function modifier_invoker_chaos_meteor_custom_burn_count:OnRefresh(table)
if not IsServer() then return end 
self:IncrementStackCount()
end 

function modifier_invoker_chaos_meteor_custom_burn_count:GetEffectName()
return "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf"
end

function modifier_invoker_chaos_meteor_custom_burn_count:GetStatusEffectName()
return "particles/status_fx/status_effect_burn.vpcf"
end

function modifier_invoker_chaos_meteor_custom_burn_count:StatusEffectPriority()
return MODIFIER_PRIORITY_NORMAL  
end








invoker_forge_spirit_custom = class({})


function invoker_forge_spirit_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_invoker_exort_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_exort_6", "cd")
end 
return (self.BaseClass.GetCooldown( self, level ) + bonus)
end

function invoker_forge_spirit_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_invoker_forged_spirit_custom_tracker"
end 


function invoker_forge_spirit_custom:GetAbilityTextureName()
local bonus = ""
local caster = self:GetCaster()

if caster:HasScepter() and not caster:HasModifier("modifier_invoker_invoke_custom_scepter_cd") and caster:FindAbilityByName("invoker_invoke_custom") then 
    bonus = "_aghanim"
end

if caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_2") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6") then
    return "invoker_forge_spirit_persona1"..bonus
end
return "invoker_forge_spirit"..bonus

end

invoker_forge_spirit_custom.forged_spirits = {}

function invoker_forge_spirit_custom:OnSpellStart()
if not IsServer() then return end

local caster = self:GetCaster()

caster:StartGesture(ACT_DOTA_CAST_FORGE_SPIRIT)

local spirit_count = 1

local invoker_quas_custom = caster:FindAbilityByName("invoker_quas_custom")
local invoker_exort_custom = caster:FindAbilityByName("invoker_exort_custom")

if not invoker_quas_custom or not invoker_exort_custom then return end

local quas_level = invoker_quas_custom:GetLevel()
local exort_level = invoker_exort_custom:GetLevel()

if caster:HasTalent("modifier_invoker_invoke_6") then 
    quas_level = quas_level + caster:GetTalentValue("modifier_invoker_invoke_6", "level")
    exort_level = exort_level + caster:GetTalentValue("modifier_invoker_invoke_6", "level")
end 

if quas_level > 3 and exort_level > 3 then
    spirit_count = 2
end

local ult = caster:FindAbilityByName("invoker_invoke_custom")
local scepter = 0

if caster:HasScepter() and ult and not caster:HasModifier("modifier_invoker_invoke_custom_scepter_cd") then
    spirit_count = spirit_count + self:GetSpecialValueFor("count_scepter")
    scepter = 1
    ult:UseScepter()
end 

for _, unit in pairs(self.forged_spirits) do
    if unit and not unit:IsNull() and unit:IsAlive() then
        unit:Kill(nil, nil)
    end
end

self.forged_spirits = {}

for i = 1, spirit_count do
    self:SummonSpirit(true, scepter)
end

if scepter == 1 then
    for _, unit in pairs(self.forged_spirits) do
        if unit and not unit:IsNull() and unit:IsAlive() then
            local ability = caster:FindAbilityByName("invoker_alacrity_custom")
            if ability then
                ability:ApplyEffect(unit)
            end
            break
        end
    end
end


caster:EmitSound("Hero_Invoker.ForgeSpirit")
end





function invoker_forge_spirit_custom:SummonSpirit(active, scepter)
if not IsServer() then return end

local caster = self:GetCaster()
local invoker_exort_custom = caster:FindAbilityByName("invoker_exort_custom")
local damage = caster:GetValueExort(self, "spirit_damage")
local health = caster:GetValueQuas(self, "spirit_hp")
local duration = caster:GetValueQuas(self, "spirit_duration")
local spirit_armor = caster:GetValueExort(self, "spirit_armor")

if not active and caster:HasTalent("modifier_invoker_exort_6") then 
    duration = caster:GetTalentValue("modifier_invoker_exort_6", "duration")
end 

local forged_spirit = CreateUnitByName("npc_dota_invoker_forged_spirit_custom", caster:GetAbsOrigin() + RandomVector(100), false, caster, caster, caster:GetTeamNumber())
forged_spirit:AddNewModifier(caster, self, "modifier_kill", { duration = duration })
forged_spirit:AddNewModifier(caster, self, "modifier_forged_spirit_melting_strike_custom_range", { scepter = scepter })

local forge_model = "models/heroes/invoker/forge_spirit.vmdl"
if caster:HasModifier("modifier_invoker_forge_1") then
    forge_model = "models/items/invoker/forge_spirit/covenant_of_the_depths_deep_forged/covenant_of_the_depths_deep_forged.vmdl"
end
if caster:HasModifier("modifier_invoker_forge_2") then
    forge_model = "models/items/invoker/forge_spirit/infernus/infernus.vmdl"
end
if caster:HasModifier("modifier_invoker_forge_3") then
    forge_model = "models/items/invoker/forge_spirit/esl_relics_forge_spirit/esl_relics_forge_spirit.vmdl"
end
if caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_2") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6") then
    forge_model = "models/heroes/invoker_kid/invoker_kid_trainer_dragon.vmdl"
    forged_spirit:SetRangedProjectileName("particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf")
end
if caster:HasModifier("modifier_invoker_persona_5") then
    forge_model = "models/items/invoker_kid/continuum_echoes_forge_spirit/continuum_echoes_forge_spirit.vmdl"
    forged_spirit:SetRangedProjectileName("particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf")
end
if caster:HasModifier("modifier_invoker_persona_6") then
    forge_model = "models/items/invoker_kid/the_little_thief_of_kazim_forge_spirit_red/the_little_thief_of_kazim_forge_spirit_red.vmdl"
    forged_spirit:SetRangedProjectileName("particles/units/heroes/hero_invoker_kid/invoker_kid_forged_spirit_projectile.vpcf")
end

forged_spirit:SetOriginalModel(forge_model)
forged_spirit:SetModel(forge_model)


local ability = forged_spirit:FindAbilityByName("forged_spirit_melting_strike_custom")

if ability and invoker_exort_custom then 
    ability:SetLevel(invoker_exort_custom:GetLevel())

    if caster:HasTalent("modifier_invoker_invoke_6") then 
        ability:SetLevel(ability:GetLevel() + 1)
    end 
end 

forged_spirit.owner = caster

forged_spirit:SetControllableByPlayer(caster:GetPlayerID(), true)
forged_spirit:SetBaseMaxHealth(health)
forged_spirit:SetMaxHealth(health)
forged_spirit:SetHealth(health)
forged_spirit:SetBaseDamageMin(damage)
forged_spirit:SetBaseDamageMax(damage)

forged_spirit:SetPhysicalArmorBaseValue(spirit_armor)
FindClearSpaceForUnit(forged_spirit, forged_spirit:GetOrigin(), false)
forged_spirit:SetAngles(0, 0, 0)
forged_spirit:SetForwardVector(caster:GetForwardVector())

if active and active == true then 
    self.forged_spirits[#self.forged_spirits + 1] = forged_spirit
end 

end


forged_spirit_melting_strike_custom = class({})




modifier_forged_spirit_melting_strike_custom_range = class({})
function modifier_forged_spirit_melting_strike_custom_range:IsHidden() return true end
function modifier_forged_spirit_melting_strike_custom_range:IsPurgable() return false end

function modifier_forged_spirit_melting_strike_custom_range:OnCreated(kv)

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.parent:AddDeathEvent(self)

self.ability = self:GetAbility()

self.movespeed_bonus = self.caster:GetValueExort(self.ability, "spirit_movespeed")

self.range = self.caster:GetValueQuas(self:GetAbility(), "spirit_attack_range")

self.incoming = self.caster:GetTalentValue("modifier_invoker_exort_1", "incoming")

self.armor_bonus = self.caster:GetTalentValue("modifier_invoker_wex_3", "armor")

self.stun_duration = self.caster:GetTalentValue("modifier_invoker_exort_6", "stun", true)

if IsServer() then 
    self:SetStackCount(kv.scepter)
end 
if self:GetStackCount() == 1 then 
    self.range = self.range + self:GetAbility():GetSpecialValueFor("range_scepter")
end  

if not IsServer() then return end

local mod = self.caster:FindModifierByName("modifier_invoker_forged_spirit_custom_tracker")
if mod then
    mod:IncrementStackCount()
end

if self.caster:HasModifier("modifier_invoker_forge_3") then
    self.parent:GenericParticle("particles/econ/items/invoker/glorious_inspiration/invoker_forge_spirit_ambient_esl.vpcf", self)
end
if self.caster:HasModifier("modifier_invoker_persona_1") or self.caster:HasModifier("modifier_invoker_persona_2") or self.caster:HasModifier("modifier_invoker_persona_3") or self.caster:HasModifier("modifier_invoker_persona_4") or self.caster:HasModifier("modifier_invoker_persona_5") or self.caster:HasModifier("modifier_invoker_persona_6") then
    self.parent:GenericParticle("particles/units/heroes/hero_invoker_kid/invoker_kid_forge_spirit_ambient.vpcf", self)
end

end 

function modifier_forged_spirit_melting_strike_custom_range:OnDestroy()
if not IsServer() then return end
local mod = self.caster:FindModifierByName("modifier_invoker_forged_spirit_custom_tracker")
if mod then
    mod:DecrementStackCount()
end

end

function modifier_forged_spirit_melting_strike_custom_range:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}
end

function modifier_forged_spirit_melting_strike_custom_range:GetModifierMoveSpeedBonus_Constant()
return self.movespeed_bonus
end


function modifier_forged_spirit_melting_strike_custom_range:GetModifierPhysicalArmorBonus()
if not self.caster:HasModifier("modifier_invoker_emp_custom_armor") then return end
return self.armor_bonus
end



function modifier_forged_spirit_melting_strike_custom_range:DeathEvent(params)
if not IsServer() then return end
if not self.caster:HasTalent("modifier_invoker_exort_6") then return end
if self.parent ~= params.unit then return end
local attacker = params.attacker

if not attacker or not attacker:IsUnit() then return end
if attacker:GetTeamNumber() == self.parent:GetTeamNumber() then return end
if (attacker:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() > 1000 then return end    
if not attacker:IsAlive() then return end

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ogre_magi/ogre_magi_fireblast.vpcf", PATTACH_ABSORIGIN_FOLLOW, attacker)
ParticleManager:SetParticleControlEnt( particle, 0, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( particle, 1, attacker:GetOrigin() )
ParticleManager:ReleaseParticleIndex( particle )

attacker:EmitSound("Invoker.Forge_stun")
attacker:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = (1 - attacker:GetStatusResistance())*self.stun_duration})
end

function modifier_forged_spirit_melting_strike_custom_range:GetModifierAttackRangeBonus()
return self.range
end

function modifier_forged_spirit_melting_strike_custom_range:GetModifierIncomingDamage_Percentage()
if not self.caster:HasTalent("modifier_invoker_exort_1") then return end
return self.incoming
end 







modifier_forged_spirit_melting_strike_custom_debuff = class({})
function modifier_forged_spirit_melting_strike_custom_debuff:IsPurgable() return false end
function modifier_forged_spirit_melting_strike_custom_debuff:OnCreated()

self.armor = self:GetAbility():GetSpecialValueFor("armor_removed")*-1
self.max = self:GetAbility():GetSpecialValueFor("max_armor_removed")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_forged_spirit_melting_strike_custom_debuff:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_forged_spirit_melting_strike_custom_debuff:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_forged_spirit_melting_strike_custom_debuff:GetModifierPhysicalArmorBonus()
return self.armor * self:GetStackCount()
end




modifier_invoker_chaos_meteor_custom_cataclysm = class({})
function modifier_invoker_chaos_meteor_custom_cataclysm:IsHidden() return true end
function modifier_invoker_chaos_meteor_custom_cataclysm:IsPurgable() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm:OnCreated(table)
if not IsServer() then return end 

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.sun_strike = self.caster:FindAbilityByName("invoker_sun_strike_custom")
self.meteor = self.caster:FindAbilityByName("invoker_chaos_meteor_custom")

self.radius = self.caster:GetTalentValue("modifier_invoker_exort_7", "radius")
self.meteor_count = self.caster:GetTalentValue("modifier_invoker_exort_7", "meteor")
self.max =  self.caster:GetTalentValue("modifier_invoker_exort_7", "sun")
self.count = 0

self.interval = table.max/(self.max)

self.caster:AddNewModifier(self.caster, self.ability, "modifier_invoker_chaos_meteor_custom_cataclysm_caster", {interval = self.interval})
self:StartIntervalThink(self.interval)
end 


function modifier_invoker_chaos_meteor_custom_cataclysm:OnDestroy()
if not IsServer() then return end 

self.caster:RemoveModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_caster")
end 

function modifier_invoker_chaos_meteor_custom_cataclysm:OnIntervalThink()
if not IsServer() then return end 
if self.count >= self.max then return end

self.count = self.count + 1

if self.sun_strike then 
    self.sun_strike:OnSpellStart(self:GivePoint(1))
end 

if self.count % self.meteor_count == 0 then 
    if self.meteor then
        self.meteor:OnSpellStart(self:GivePoint(2))
    end 
end 

if self.count >= self.max then 
    self.caster:Interrupt()
    return 
end

end 

function modifier_invoker_chaos_meteor_custom_cataclysm:GivePoint(k)
local radius = self.radius
local point = self.parent:GetAbsOrigin()

if k == 2 then 
    local dir = (self.caster:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
    point = self.parent:GetAbsOrigin() + dir*self.radius*0.6

    radius = self.radius*0.6
end 

return point + RandomVector(RandomInt(radius*0.2, radius))
end 






modifier_invoker_chaos_meteor_custom_cataclysm_caster = class({})
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:IsHidden() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:IsPurgable() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:GetEffectName() return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf" end
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:GetStatusEffectName() return "particles/status_fx/status_effect_omnislash.vpcf" end
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA end

function modifier_invoker_chaos_meteor_custom_cataclysm_caster:OnCreated(kv)
if not IsServer() then return end

self.caster = self:GetCaster()
self.caster:RemoveModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_visual")

self.duration = kv.interval*self.caster:GetTalentValue("modifier_invoker_exort_7", "sun")


if self.duration <= 1.4 then 
    self.caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_TORNADO, 0.8)
else 
    self.caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end

end 

function modifier_invoker_chaos_meteor_custom_cataclysm_caster:OnIntervalThink()
if not IsServer() then return end 

self.caster:StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
self:StartIntervalThink(-1)
end 

function modifier_invoker_chaos_meteor_custom_cataclysm_caster:OnDestroy()
if not IsServer() then return end

self.caster:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
self.caster:FadeGesture(ACT_DOTA_CAST_TORNADO)
end 






modifier_invoker_chaos_meteor_custom_cataclysm_stack = class({})
function modifier_invoker_chaos_meteor_custom_cataclysm_stack:IsHidden() return true end
function modifier_invoker_chaos_meteor_custom_cataclysm_stack:IsPurgable() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_stack:RemoveOnDeath() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_stack:OnCreated()
if not IsServer() then return end 

self.parent = self:GetParent()
self.reset = self.parent:GetTalentValue("modifier_invoker_exort_7", "reset")
self.duration = self.parent:GetTalentValue("modifier_invoker_exort_7", "duration")
self.min_cast = self.parent:GetTalentValue("modifier_invoker_exort_7", "min_cast")
self.attack_stack = self.parent:GetTalentValue("modifier_invoker_exort_7", "attack_stack")

self.max_stack = math.abs((self.duration - self.min_cast)/self.attack_stack)

self:SetStackCount(0)
end 

function modifier_invoker_chaos_meteor_custom_cataclysm_stack:AddStack()
if not IsServer() then return end 
if self.parent:HasModifier("modifier_invoker_chaos_meteor_custom_cataclysm_caster") then return end

self:StartIntervalThink(self.reset)
 
if self:GetStackCount() >= self.max_stack then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max_stack then 
    self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_invoker_chaos_meteor_custom_cataclysm_visual", {})
end 

end 

function modifier_invoker_chaos_meteor_custom_cataclysm_stack:OnIntervalThink()
if not IsServer() then return end 
if self.parent:HasModifier("modifier_invoker_chaos_meteor_custom_cataclysm_caster") then 
    self:StartIntervalThink(-1)
    return
end 

self:SetStackCount(0)
self:StartIntervalThink(-1)
end 


function modifier_invoker_chaos_meteor_custom_cataclysm_stack:OnStackCountChanged()
if not IsServer() then return end 

if self:GetStackCount() < self.max_stack then 
    self.parent:RemoveModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_visual")
end 

self.cast = self:GetStackCount()

self.number =  self.duration + self:GetStackCount()*self.attack_stack

self.parent:UpdateUIlong({max = self.max_stack, stack = self.cast, override_stack = self.number, use_zero = 1, style = "InvokerExort"})
end 




modifier_invoker_chaos_meteor_custom_cataclysm_visual = class({})
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:IsHidden() return true end
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:IsPurgable() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:GetEffectName() return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf" end
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:GetStatusEffectName() return "particles/status_fx/status_effect_omnislash.vpcf" end
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:StatusEffectPriority() return MODIFIER_PRIORITY_ULTRA end
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:OnCreated()
if not IsServer() then return end 
self:GetParent():EmitSound("Invoker.Exort_legendary")
end 

function modifier_invoker_chaos_meteor_custom_cataclysm_visual:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_invoker_chaos_meteor_custom_cataclysm_visual:GetModifierModelScale()
return 15
end





modifier_invoker_forged_spirit_custom_tracker = class({})
function modifier_invoker_forged_spirit_custom_tracker:IsHidden() return self:GetStackCount() <= 0 or not self:GetParent():HasTalent("modifier_invoker_exort_3") end
function modifier_invoker_forged_spirit_custom_tracker:IsPurgable() return false end
function modifier_invoker_forged_spirit_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.speed_duration = self.parent:GetTalentValue("modifier_invoker_wex_4", "speed_duration", true)

self.spell_count = self.parent:GetTalentValue("modifier_invoker_exort_6", "count", true)

self.slow_duration = self.parent:GetTalentValue("modifier_invoker_exort_3", "duration", true)

self.stack_duration = self.parent:GetTalentValue("modifier_invoker_exort_4", "duration", true)

if not IsServer() then return end
self.count = 0

self.parent:AddSpellEvent(self)
self.parent:AddAttackEvent_out(self)
end 


function modifier_invoker_forged_spirit_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}
end

function modifier_invoker_forged_spirit_custom_tracker:GetModifierMoveSpeedBonus_Constant()
if not self.parent:HasTalent("modifier_invoker_exort_3") then return end
if self:GetStackCount() <= 0 then return end

return self.parent:GetTalentValue("modifier_invoker_exort_3", "speed")
end


function modifier_invoker_forged_spirit_custom_tracker:SpellEvent( params )
if not IsServer() then return end
if params.unit~=self.parent then return end
if params.ability:IsItem() then return end

if self.parent:HasTalent("modifier_invoker_wex_4") then 
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_invoker_alacrity_custom_speed", {duration = self.speed_duration})
end 

if not self.parent:HasTalent("modifier_invoker_exort_6") then return end

self.count = self.count + 1

if self.count >= self.spell_count then 
    self.ability:SummonSpirit(false, 0)
    self.count = 0
end 

end 


function modifier_invoker_forged_spirit_custom_tracker:AttackEvent_out( params )
if not IsServer() then return end 
if not params.target:IsUnit() then return end

local attacker = params.attacker
local ability = attacker:FindAbilityByName("forged_spirit_melting_strike_custom")
local is_forge = ability and attacker.owner and attacker.owner == self.parent


if is_forge then
    params.target:AddNewModifier(attacker, ability, "modifier_forged_spirit_melting_strike_custom_debuff", {duration = ability:GetSpecialValueFor("duration") })

    if params.target:IsHero() and self.parent:HasTalent("modifier_invoker_exort_7") then 
       local mod = self.parent:FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")
        if mod then 
            mod:AddStack()
        end 
    end

    if self.parent:HasTalent("modifier_invoker_exort_1") and self.parent:IsAlive() then 
        self.parent:GenericHeal(self.parent:GetMaxHealth()*self.parent:GetTalentValue("modifier_invoker_exort_1", "heal")/100, self.ability, true, nil, "modifier_invoker_exort_1")
    end
end

if self.parent == attacker or is_forge then

    if self.parent:HasTalent("modifier_invoker_exort_3") then
        params.target:AddNewModifier(self.parent, self.ability, "modifier_forged_spirit_melting_strike_custom_slow", {duration = self.slow_duration})
    end 

    if self.parent:HasTalent("modifier_invoker_exort_4") then
        params.target:AddNewModifier(self.parent, self.ability, "modifier_invoker_chaos_meteor_custom_stack", {duration = self.stack_duration})
    end
end

end

modifier_invoker_chaos_meteor_custom_stack = class({})
function modifier_invoker_chaos_meteor_custom_stack:IsHidden() return false end
function modifier_invoker_chaos_meteor_custom_stack:IsPurgable() return false end
function modifier_invoker_chaos_meteor_custom_stack:GetTexture() return "buffs/forge_meteor" end
function modifier_invoker_chaos_meteor_custom_stack:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.max = self.caster:GetTalentValue("modifier_invoker_exort_4", "max")
self.damage = self.caster:GetTalentValue("modifier_invoker_exort_4", "damage")/100
self.stun = self.caster:GetTalentValue("modifier_invoker_exort_4", "stun")

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_invoker_chaos_meteor_custom_stack:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then
    self.parent:GenericParticle("particles/invoker/meteor_mark.vpcf", self, true)
    self.parent:EmitSound("Invoker.Meteor_stack_max")
end

end








modifier_forged_spirit_melting_strike_custom_slow = class({})
function modifier_forged_spirit_melting_strike_custom_slow:IsHidden() return true end
function modifier_forged_spirit_melting_strike_custom_slow:IsPurgable() return true end

function modifier_forged_spirit_melting_strike_custom_slow:OnCreated(table)
self.slow = self:GetCaster():GetTalentValue("modifier_invoker_exort_3", "slow")

if not IsServer() then return end
local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(iParticleID, true, false, -1, false, false)
end

function modifier_forged_spirit_melting_strike_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}

end

function modifier_forged_spirit_melting_strike_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end






modifier_invoker_sun_strike_custom_fire = class({})
function modifier_invoker_sun_strike_custom_fire:IsHidden() return true end
function modifier_invoker_sun_strike_custom_fire:IsPurgable() return false end
function modifier_invoker_sun_strike_custom_fire:OnCreated()

self.parent = self:GetParent()
self.radius = self:GetCaster():GetTalentValue("modifier_invoker_exort_2", "radius")

if not IsServer() then return end 
self.nFXIndex = ParticleManager:CreateParticle("particles/invoker/sun_fire.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.nFXIndex, 0, self.parent:GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 1, self.parent:GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(self.radius*1.2, 0, 0))
ParticleManager:ReleaseParticleIndex(self.nFXIndex)
self:AddParticle(self.nFXIndex,false,false,-1,false,false)
end 

function modifier_invoker_sun_strike_custom_fire:IsAura() return true end
function modifier_invoker_sun_strike_custom_fire:GetModifierAura() return "modifier_invoker_sun_strike_custom_fire_debuff" end
function modifier_invoker_sun_strike_custom_fire:GetAuraRadius() return self.radius end
function modifier_invoker_sun_strike_custom_fire:GetAuraDuration() return 1 end
function modifier_invoker_sun_strike_custom_fire:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_invoker_sun_strike_custom_fire:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_invoker_sun_strike_custom_fire:OnDestroy()
if not IsServer() then return end
UTIL_Remove( self.parent )
end


modifier_invoker_sun_strike_custom_fire_debuff = class({})
function modifier_invoker_sun_strike_custom_fire_debuff:IsHidden() return true end
function modifier_invoker_sun_strike_custom_fire_debuff:IsPurgable() return false end
function modifier_invoker_sun_strike_custom_fire_debuff:OnCreated(table)

self.interval = 0.5
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.damage = self.caster:GetTalentValue("modifier_invoker_exort_2", "damage")*self.interval

if not IsServer() then return end 
self.damageTable = {victim = self.parent, attacker = self.caster, ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL}
self:StartIntervalThink(self.interval)
end

function modifier_invoker_sun_strike_custom_fire_debuff:OnIntervalThink()
if not IsServer() then return end

local real_damage = DoDamage(self.damageTable, "modifier_invoker_exort_2")
self.parent:SendNumber(4, real_damage)
end







modifier_invoker_sun_strike_custom_blind = class({})
function modifier_invoker_sun_strike_custom_blind:IsPurgable() return true end
function modifier_invoker_sun_strike_custom_blind:IsHidden() return true end
function modifier_invoker_sun_strike_custom_blind:GetEffectName() return "particles/items3_fx/black_powder_blind_debuff.vpcf" end
function modifier_invoker_sun_strike_custom_blind:OnCreated(params)

self.parent = self:GetParent()
self.caster = self:GetCaster()

self.slow = self.caster:GetTalentValue("modifier_invoker_exort_5", "slow")
self.miss_chance = self.caster:GetTalentValue("modifier_invoker_exort_5", "miss")
end

function modifier_invoker_sun_strike_custom_blind:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MISS_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_invoker_sun_strike_custom_blind:GetModifierMiss_Percentage()
if self.parent:HasModifier("modifier_tower_incoming_speed") then return end
return self.miss_chance
end

function modifier_invoker_sun_strike_custom_blind:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end