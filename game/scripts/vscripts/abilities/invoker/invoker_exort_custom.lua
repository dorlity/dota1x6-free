LinkLuaModifier( "modifier_invoker_exort_custom_passive", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_exort_custom", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_sun_strike_custom", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_thinker", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_burn", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_burn_count", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forged_spirit_melting_strike_custom_debuff", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forged_spirit_melting_strike_custom_slow", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forged_spirit_melting_strike_custom_tracker", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_forged_spirit_melting_strike_custom_range", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_cataclysm", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_cataclysm_caster", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_cataclysm_stack", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_cataclysm_visual", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_chaos_meteor_custom_cataclysm_forge", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_forged_spirit_custom_tracker", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_sun_strike_custom_fire", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_sun_strike_custom_fire_debuff", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_sun_strike_custom_blind", "abilities/invoker/invoker_exort_custom", LUA_MODIFIER_MOTION_NONE )

invoker_exort_custom = class({})

function invoker_exort_custom:ProcsMagicStick()
    return false
end

function invoker_exort_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_exort_orb.vpcf", context )
end

function invoker_exort_custom:GetIntrinsicModifierName()
    return "modifier_invoker_exort_custom_passive"
end

invoker_exort_custom.modifier_invoker_1 = {2,4,6}

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

function modifier_invoker_exort_custom:IsHidden()
    return false
end

function modifier_invoker_exort_custom:IsDebuff()
    return false
end

function modifier_invoker_exort_custom:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_invoker_exort_custom:IsPurgable()
    return false
end






modifier_invoker_exort_custom_passive = class({})

function modifier_invoker_exort_custom_passive:IsHidden() return true end
function modifier_invoker_exort_custom_passive:IsPurgable() return false end
function modifier_invoker_exort_custom_passive:IsPurgeException() return false end

function modifier_invoker_exort_custom_passive:OnCreated()
self.int = self:GetAbility():GetSpecialValueFor("intelligence_bonus")

if not IsServer() then return end
self:StartIntervalThink(FrameTime())
end

function modifier_invoker_exort_custom_passive:OnIntervalThink()
if not IsServer() then return end
local mod = self:GetCaster():FindAllModifiersByName("modifier_invoker_exort_custom")
self:SetStackCount(#mod)
end


function modifier_invoker_exort_custom_passive:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
}
end

function modifier_invoker_exort_custom_passive:GetModifierBonusStats_Intellect()
return self.int*self:GetAbility():GetLevel()
end














invoker_sun_strike_custom = class({})

function invoker_sun_strike_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf", context )
    PrecacheResource( "particle", "particles/invoker/sun_strike_radius.vpcf", context )
    PrecacheResource( "particle", "particles/invoker/sun_fire.vpcf", context )
end


function invoker_sun_strike_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level ) * (1 - self:GetCaster():GetWexCd()/100)
end


function invoker_sun_strike_custom:GetBehavior()

    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES
end

function invoker_sun_strike_custom:GetAOERadius()
    return self:GetSpecialValueFor( "area_of_effect" ) + self:GetCaster():GetTalentValue("modifier_invoker_exort_5", "radius")
end


function invoker_sun_strike_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_sun_strike_aghanim"
else
    return "invoker_sun_strike"
end

end


function invoker_sun_strike_custom:OnSpellStart(new_point, scepter_cast)
if not IsServer() then return end

local is_legendary = 0
local point
local delay = self:GetSpecialValueFor("delay") + self:GetCaster():GetTalentValue("modifier_invoker_exort_5", "delay")
local vision_distance = self:GetSpecialValueFor("vision_distance")
local vision_duration = self:GetSpecialValueFor("vision_duration")

local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
local use_scepter = 0
local is_scepter = 0

if scepter_cast and scepter_cast == 1 then 
    is_scepter = 1
end 

if not new_point and self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true
    and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then
    use_scepter = 1
    ult:UseScepter()
end 


if new_point then 
    point = new_point

    if is_scepter == 0 then 
        is_legendary = 1
    end 
    EmitSoundOnLocationWithCaster( point, "Hero_Invoker.SunStrike.Charge", self:GetCaster() )
else 
    point = self:GetCursorPosition()
    self:GetCaster():StartGesture(ACT_DOTA_CAST_SUN_STRIKE)
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'generic_sound',  {sound = "Invoker.Sun_strike"})
 
end 


CreateModifierThinker( self:GetCaster(), self, "modifier_invoker_sun_strike_custom", {double = use_scepter, is_scepter = is_scepter, is_legendary = is_legendary, quas = self:GetCaster():GetQuasHeal(), exort = self:GetCaster():GetExortDamage(), duration = delay }, point, self:GetCaster():GetTeamNumber(), false )
AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_distance, vision_duration, false )
end






modifier_invoker_sun_strike_custom = class({})

function modifier_invoker_sun_strike_custom:IsHidden()
    return true
end

function modifier_invoker_sun_strike_custom:IsPurgable()
    return false
end

function modifier_invoker_sun_strike_custom:OnCreated( kv )
if not IsServer() then return end

self.area_of_effect = self:GetAbility():GetSpecialValueFor("area_of_effect")
self.damage = self:GetCaster():GetValueExort(self:GetAbility(), "damage")

self.blind_duration = self:GetCaster():GetTalentValue("modifier_invoker_exort_5", "duration")

self.quas_heal = kv.quas/100
self.exort_damage = kv.exort/100

if self.exort_damage and self.exort_damage > 0 then 
  self.damage = self.damage * (1 + self.exort_damage)
end 

if kv.is_scepter and kv.is_scepter == 1 then 
    self.damage = self.damage*self:GetAbility():GetSpecialValueFor("damage_scepter")/100
end 



self.double = kv.double
self.is_legendary = 0

if kv.is_legendary and kv.is_legendary == 1 and self.double and self.double == 0 then 
    self.is_legendary = 1
end 

local part = "particles/units/heroes/hero_invoker/invoker_sun_strike_team.vpcf"
if self:GetCaster():HasModifier("modifier_invoker_exort_5") then 
    part = "particles/invoker/sun_stike_fast.vpcf"
end 

local effect_cast = ParticleManager:CreateParticleForTeam( part, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( 40, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

  
end

function modifier_invoker_sun_strike_custom:OnDestroy( kv )
if not IsServer() then return end

if self.double and self.double == 1 then 
    self:GetAbility():OnSpellStart(self:GetParent():GetAbsOrigin(), 1)
end     


local damageTable =
{
    attacker = self:GetCaster(),
    damage_type = DAMAGE_TYPE_PURE,
    ability = self:GetAbility(),
}

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.area_of_effect, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )

local heroes_hit = false

for _,enemy in pairs(enemies) do
    damageTable.victim = enemy

    if enemy:IsRealHero() then 
        heroes_hit = true
    end 

    if self:GetCaster():HasModifier("modifier_invoker_exort_5") then 
        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_sun_strike_custom_blind", {duration = self.blind_duration})
    end

    damageTable.damage = self.damage--/#enemies

    if enemy:IsRealHero() then 
        local ability = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
        if ability then 
            ability:AbilityHit()
        end 
    end 

    local real_damage = ApplyDamage(damageTable)

    if self.quas_heal and self.quas_heal > 0 and not enemy:IsIllusion() then

        local heal = real_damage*self.quas_heal
        if enemy:IsCreep() then 
            heal = heal/3
        end 

      self:GetCaster():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
    end
end

if heroes_hit == true and self.is_legendary == 0 then 
    local mod = self:GetCaster():FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")

    local max = self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "sun_stack")/self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "attack_stack")

    if mod then 
        for i = 1, max do
            mod:AddStack()
        end
    end 
end


local part = "particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf"

if self:GetCaster():HasModifier("modifier_invoker_exort_5") then 
    part = "particles/invoker/sun_strike_radius.vpcf"
end

if self:GetCaster():HasModifier("modifier_invoker_exort_2") then 
  CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_invoker_sun_strike_custom_fire", {duration = self:GetCaster():GetTalentValue("modifier_invoker_exort_2", "duration")}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end



local effect_cast = ParticleManager:CreateParticle( part, PATTACH_WORLDORIGIN, self:GetCaster() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.area_of_effect, 0, 0 ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.SunStrike.Ignite", self:GetCaster() )

UTIL_Remove( self:GetParent() )
end








invoker_chaos_meteor_custom = class({})

function invoker_chaos_meteor_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf", context )
end

function invoker_chaos_meteor_custom:GetChannelTime()
if not self:GetCaster():HasModifier("modifier_invoker_exort_7") then return 0 end
return self:GetCastTime() + 0.1
end

function invoker_chaos_meteor_custom:GetBehavior()
if  self:GetCaster():HasModifier("modifier_invoker_exort_7") then 
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_CHANNELLED 
end 

return DOTA_ABILITY_BEHAVIOR_POINT +  DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function invoker_chaos_meteor_custom:GetAOERadius()
if not self:GetCaster():HasModifier("modifier_invoker_exort_7") then return end
return self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "radius")
end


function invoker_chaos_meteor_custom:GetCastTime()
if not self:GetCaster():HasModifier("modifier_invoker_exort_7") then return 0 end

local bonus = 0
if self:GetCaster():HasModifier("modifier_invoker_chaos_meteor_custom_cataclysm_stack") then 
    bonus = self:GetCaster():GetUpgradeStack("modifier_invoker_chaos_meteor_custom_cataclysm_stack")*self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "attack_stack")
end 

return self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "duration") + bonus
end 


function invoker_chaos_meteor_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_chaos_meteor_aghanim"
else
    return "invoker_chaos_meteor"
end

end



function invoker_chaos_meteor_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_invoker_exort_3") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_exort_3", "cd")
end 

return (self.BaseClass.GetCooldown( self, level ) + bonus)*(1 - self:GetCaster():GetWexCd()/100)
end

function invoker_chaos_meteor_custom:OnSpellStart(new_point)
if not IsServer() then return end

local point
local is_legendary = 0


if new_point then 
    point = new_point
    is_legendary = 1
else 
    point = self:GetCursorPosition()

    if self:GetCaster():HasModifier("modifier_invoker_exort_7") then 

        local max_time = self:GetCastTime()
        self.thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_invoker_chaos_meteor_custom_cataclysm", {max = max_time, quas = self:GetCaster():GetQuasHeal(), exort = self:GetCaster():GetExortDamage(),}, point, self:GetCaster():GetTeamNumber(), false )
    else 

        self:GetCaster():StartGesture(ACT_DOTA_CAST_CHAOS_METEOR)
    end 
end 

if point == self:GetCaster():GetAbsOrigin() then
    point = point + self:GetCaster():GetForwardVector()
end


local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
local scepter = 0

if self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true
    and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") and is_legendary == 0 then
    scepter = 1
    ult:UseScepter()
end 



CreateModifierThinker( self:GetCaster(), self, "modifier_invoker_chaos_meteor_custom_thinker", {is_scepter = scepter, is_legendary = is_legendary, quas = self:GetCaster():GetQuasHeal(), exort = self:GetCaster():GetExortDamage(),}, point, self:GetCaster():GetTeamNumber(), false )
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

function modifier_invoker_chaos_meteor_custom_thinker:IsHidden()
    return true
end

function modifier_invoker_chaos_meteor_custom_thinker:OnCreated(kv)
if not IsServer() then return end
self.caster_origin = self:GetCaster():GetOrigin()
self.parent_origin = self:GetParent():GetOrigin()
self.direction = self.parent_origin - self.caster_origin

self.is_scepter = kv.is_scepter
self.scepter_distance = self:GetAbility():GetSpecialValueFor("scepter_distance")

self.is_legendary = kv.is_legendary

if kv.is_legendary == 1 then 
    self.direction = self:GetCaster():GetForwardVector()
    self.caster_origin = self.parent_origin - self.direction*(self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "radius", "true")/2)
end 

self.direction.z = 0
self.direction = self.direction:Normalized()

self.delay = self:GetAbility():GetSpecialValueFor("land_time")
self.radius = self:GetAbility():GetSpecialValueFor("area_of_effect")
self.distance = self:GetCaster():GetValueWex(self:GetAbility(), "travel_distance")
self.speed = self:GetAbility():GetSpecialValueFor("travel_speed")
self.vision = self:GetAbility():GetSpecialValueFor("vision_distance")
self.vision_duration = self:GetAbility():GetSpecialValueFor("end_vision_duration")
self.interval = self:GetAbility():GetSpecialValueFor("damage_interval")
self.duration = self:GetAbility():GetSpecialValueFor("burn_duration")

self.stun = self:GetAbility():GetSpecialValueFor("scepter_stun")

local damage = self:GetCaster():GetValueExort(self:GetAbility(), "main_damage")


if self:GetCaster():HasModifier("modifier_invoker_exort_3") then 
    damage = damage*(1 + self:GetCaster():GetTalentValue("modifier_invoker_exort_3", "damage")/100)
end

self.quas_heal = kv.quas/100
self.exort_damage = kv.exort/100

if self.exort_damage and self.exort_damage > 0 then 
  damage = damage * (1 + self.exort_damage)
end 


self.fallen = false
self.hit_hero = {}

self.damageTable = 
{
    attacker = self:GetCaster(),
    damage = damage,
    damage_type = self:GetAbility():GetAbilityDamageType(),
    ability = self:GetAbility(),
}

self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
self.nMoveStep = 0
self:StartIntervalThink(self.delay)

self:PlayEffects1()
end

function modifier_invoker_chaos_meteor_custom_thinker:OnDestroy()
if not IsServer() then return end


AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.vision, self.vision_duration, false)
StopSoundOn("Hero_Invoker.ChaosMeteor.Loop", self:GetParent())

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
local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false )
for _, enemy in pairs(enemies) do

    if first and first == true and self.is_legendary == 0 and self.is_scepter == 1 then 

        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.stun})

        local distance = self.scepter_distance
        local center = enemy:GetAbsOrigin() - self.direction*10
        local duration = distance/self.speed

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
        enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", knockbackProperties )

    end 


    if enemy:IsRealHero() and not self.hit_hero[enemy] then 
        self.hit_hero[enemy] = true

        local ability = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
        if ability then 
            ability:AbilityHit()
        end 
    end 


    self.damageTable.victim = enemy
    local real_damage =  ApplyDamage(self.damageTable)

    if self.quas_heal and self.quas_heal > 0 and not enemy:IsIllusion() then 

        local heal = real_damage*self.quas_heal
        if enemy:IsCreep() then 
            heal = heal/3
        end 

        self:GetCaster():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
    end

    enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_invoker_chaos_meteor_custom_burn", {exort = self.exort_damage, quas = self.quas_heal, duration = self.duration } )
    enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_invoker_chaos_meteor_custom_burn_count", { duration = self.duration } )
end

end

function modifier_invoker_chaos_meteor_custom_thinker:Move_Burn()
local parent = self:GetParent()
local target = self.direction * self.speed * self.interval
parent:SetOrigin(parent:GetOrigin() + target)
self.nMoveStep = self.nMoveStep+1
self:Burn()

if self.nMoveStep and self.nMoveStep > 20 then
    self:Destroy()
    return
end

if (parent:GetOrigin() - self.parent_origin + target):Length2D() > self.distance then
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
EmitSoundOnLocationWithCaster(self.caster_origin, "Hero_Invoker.ChaosMeteor.Cast", self:GetCaster())
self:GetParent():EmitSound( "Hero_Invoker.ChaosMeteor.Loop")
end

function modifier_invoker_chaos_meteor_custom_thinker:PlayEffects2()
local meteor_projectile = 
{
    Ability = self:GetAbility(),
    EffectName = "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
    vSpawnOrigin = self.parent_origin,
    fDistance = self.distance,
    fStartRadius = self.radius,
    fEndRadius = self.radius,
    Source = self:GetCaster(),
    bHasFrontalCone = false,
    bReplaceExisting = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_NONE,
    iUnitTargetType = DOTA_UNIT_TARGET_NONE,
    bDeleteOnHit = false,
    vVelocity = self.direction * self.speed,
    bProvidesVision = true,
    iVisionRadius = self.vision,
    iVisionTeamNumber = self:GetCaster():GetTeamNumber()
}
self.nLinearProjectile = ProjectileManager:CreateLinearProjectile(meteor_projectile)
EmitSoundOnLocationWithCaster(self.parent_origin, "Hero_Invoker.ChaosMeteor.Impact", self:GetCaster())

end







modifier_invoker_chaos_meteor_custom_burn = class({})


function modifier_invoker_chaos_meteor_custom_burn:IsHidden() return true end
function modifier_invoker_chaos_meteor_custom_burn:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_invoker_chaos_meteor_custom_burn:OnCreated(kv)
if not IsServer() then return end
if not self:GetAbility() or self:GetAbility():IsNull() then return end

local damage = self:GetCaster():GetValueExort(self:GetAbility(), "burn_dps")

if self:GetCaster():HasModifier("modifier_invoker_exort_3") then 
    damage = damage*(1 + self:GetCaster():GetTalentValue("modifier_invoker_exort_3", "damage")/100)
end


self.quas_heal = kv.quas
self.exort_damage = kv.exort

if self.exort_damage and self.exort_damage > 0 then 
  damage = damage * (1 + self.exort_damage)
end 


local delay = 1 - FrameTime()
self.damageTable = {
    victim = self:GetParent(),
    attacker = self:GetCaster(),
    damage = damage,
    damage_type = self:GetAbility():GetAbilityDamageType(),
    ability = self:GetAbility(),
}
self:StartIntervalThink(delay)

end

function modifier_invoker_chaos_meteor_custom_burn:OnIntervalThink()
if not IsServer() then return end
if not self:GetAbility() or self:GetAbility():IsNull() then return end

local real_damage =  ApplyDamage(self.damageTable)

if self.quas_heal and self.quas_heal > 0 and not self:GetParent():IsIllusion() then 

    local heal = real_damage*self.quas_heal
    if self:GetParent():IsCreep() then 
        heal = heal/3
    end 

    self:GetCaster():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
end

self:GetParent():EmitSound("Hero_Invoker.ChaosMeteor.Damage")

end


function modifier_invoker_chaos_meteor_custom_burn:OnDestroy()
if not IsServer() then return end 

local mod = self:GetParent():FindModifierByName("modifier_invoker_chaos_meteor_custom_burn_count")

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
return 99999
end







invoker_forge_spirit_custom = class({})


function invoker_forge_spirit_custom:GetCooldown(level)
local bonus = 0

if self:GetCaster():HasModifier("modifier_invoker_exort_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_exort_6", "cd")
end 

return (self.BaseClass.GetCooldown( self, level ) + bonus)*(1 - self:GetCaster():GetWexCd()/100)
end

function invoker_forge_spirit_custom:GetIntrinsicModifierName()
return "modifier_invoker_forged_spirit_custom_tracker"
end 


function invoker_forge_spirit_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_forge_spirit_aghanim"
else
    return "invoker_forge_spirit"
end

end



function invoker_forge_spirit_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():StartGesture(ACT_DOTA_CAST_FORGE_SPIRIT)

local spirit_count = 1

local invoker_quas_custom = self:GetCaster():FindAbilityByName("invoker_quas_custom")
local invoker_exort_custom = self:GetCaster():FindAbilityByName("invoker_exort_custom")

local quas_level = invoker_quas_custom:GetLevel()
local exort_level = invoker_exort_custom:GetLevel()

if self:GetCaster():HasModifier("modifier_invoker_invoke_6") then 
    quas_level = quas_level + self:GetCaster():GetTalentValue("modifier_invoker_invoke_6", "level")
    exort_level = exort_level + self:GetCaster():GetTalentValue("modifier_invoker_invoke_6", "level")
end 

if invoker_quas_custom and invoker_exort_custom then
    if quas_level > 3 and exort_level > 3 then
        spirit_count = 2
    end
end

local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
local scepter = 0

if self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true
    and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then
    spirit_count = spirit_count + self:GetSpecialValueFor("count_scepter")

    scepter = 1
    ult:UseScepter()
end 


if self.forged_spirits then
    for _, unit in pairs(self.forged_spirits) do
        if unit and not unit:IsNull() and unit:IsAlive() then
            unit:Kill(nil, nil)
        end
    end
end

self.forged_spirits = {}

for i = 1, spirit_count do
    self:SummonSpirit(true, scepter)
end

self:GetCaster():EmitSound("Hero_Invoker.ForgeSpirit")

end





function invoker_forge_spirit_custom:SummonSpirit(active, scepter)
if not IsServer() then return end

local invoker_exort_custom = self:GetCaster():FindAbilityByName("invoker_exort_custom")
local damage = self:GetCaster():GetValueExort(self, "spirit_damage")
local health = self:GetCaster():GetValueQuas(self, "spirit_hp")
local duration = self:GetCaster():GetValueQuas(self, "spirit_duration")
local spirit_armor = self:GetCaster():GetValueExort(self, "spirit_armor")

if not active and self:GetCaster():HasModifier("modifier_invoker_exort_4") then 
    duration = self:GetCaster():GetTalentValue("modifier_invoker_exort_4", "duration")
end 

local forged_spirit = CreateUnitByName("npc_dota_invoker_forged_spirit_custom", self:GetCaster():GetAbsOrigin() + RandomVector(100), false, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
forged_spirit:AddNewModifier(self:GetCaster(), self, "modifier_kill", { duration = duration })
forged_spirit:AddNewModifier(self:GetCaster(), self, "modifier_forged_spirit_melting_strike_custom_range", { duration = duration, scepter = scepter })
    
local ability = forged_spirit:FindAbilityByName("forged_spirit_melting_strike_custom")

if ability and invoker_exort_custom then 
    ability:SetLevel(invoker_exort_custom:GetLevel())

    if self:GetCaster():HasScepter() then 
        ability:SetLevel(ability:GetLevel() + 1)
    end 
end 



forged_spirit.owner = self:GetCaster()

forged_spirit:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
forged_spirit:SetBaseMaxHealth(health)
forged_spirit:SetMaxHealth(health)
forged_spirit:SetHealth(health)
forged_spirit:SetBaseDamageMin(damage)
forged_spirit:SetBaseDamageMax(damage)
forged_spirit:SetPhysicalArmorBaseValue(spirit_armor)
FindClearSpaceForUnit(forged_spirit, forged_spirit:GetOrigin(), false)
forged_spirit:SetAngles(0, 0, 0)
forged_spirit:SetForwardVector(self:GetCaster():GetForwardVector())

if active and active == true then 
    table.insert(self.forged_spirits, forged_spirit)
end 

end





modifier_forged_spirit_melting_strike_custom_range = class({})
function modifier_forged_spirit_melting_strike_custom_range:IsHidden() return true end
function modifier_forged_spirit_melting_strike_custom_range:IsPurgable() return false end

function modifier_forged_spirit_melting_strike_custom_range:OnCreated(kv)
self.range = self:GetCaster():GetValueQuas(self:GetAbility(), "spirit_attack_range")
self.speed = self:GetCaster():GetTalentValue("modifier_invoker_exort_1", "speed")
self.attack = self:GetCaster():GetTalentValue("modifier_invoker_exort_1", "attack")

if IsServer() then 
    self:SetStackCount(kv.scepter)
end 

if self:GetStackCount() == 1 then 
    self.range = self.range + self:GetAbility():GetSpecialValueFor("range_scepter")
end     

end 


function modifier_forged_spirit_melting_strike_custom_range:DeclareFunctions()
return
{
     MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
     MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
     MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
}
end


function modifier_forged_spirit_melting_strike_custom_range:GetModifierMoveSpeedBonus_Constant()
return self.speed
end 


function modifier_forged_spirit_melting_strike_custom_range:GetModifierAttackRangeBonus()
return self.range
end

function modifier_forged_spirit_melting_strike_custom_range:GetModifierAttackSpeedBonus_Constant()
return self.attack
end


 














forged_spirit_melting_strike_custom = class({})


function forged_spirit_melting_strike_custom:GetIntrinsicModifierName()
return "modifier_forged_spirit_melting_strike_custom_tracker"
end






modifier_forged_spirit_melting_strike_custom_tracker = class({})

function modifier_forged_spirit_melting_strike_custom_tracker:IsHidden()
    return true
end

function modifier_forged_spirit_melting_strike_custom_tracker:IsDebuff()
    return false
end

function modifier_forged_spirit_melting_strike_custom_tracker:IsPurgable()
    return false
end

function modifier_forged_spirit_melting_strike_custom_tracker:OnCreated(kv)
self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_forged_spirit_melting_strike_custom_tracker:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end




function modifier_forged_spirit_melting_strike_custom_tracker:OnAttackLanded( params )
if not IsServer() then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.attacker ~= self:GetParent() then return end
if params.target == self:GetParent() then return end
if params.target:GetUnitName() == "npc_teleport" then return end

local caster = self:GetParent().owner

if caster then 

    if params.target:IsHero() and caster:HasModifier("modifier_invoker_exort_7") then 
       -- self:GetParent().owner:AddNewModifier(self:GetParent().owner, nil, "modifier_invoker_chaos_meteor_custom_cataclysm_forge", {duration = caster:GetTalentValue("modifier_invoker_exort_7", "reset")})


        local mod = self:GetParent().owner:FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")

        if mod then 
            mod:AddStack()
        end 
    end


    if caster:HasModifier("modifier_invoker_exort_6") and caster:IsAlive() then 
        caster:GenericHeal(caster:GetMaxHealth()*caster:GetTalentValue("modifier_invoker_exort_6", "heal")/100, self:GetAbility())
    end

    if caster:HasModifier("modifier_invoker_exort_4") and (caster:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= caster:GetTalentValue("modifier_invoker_exort_4", "range") then 
        local ability = caster:FindAbilityByName("invoker_sun_strike_custom")

        if ability then 
            caster:CdAbility(ability, caster:GetTalentValue("modifier_invoker_exort_4", "cd"))
        end 

        ability = caster:FindAbilityByName("invoker_chaos_meteor_custom")

        if ability then 
            caster:CdAbility(ability, caster:GetTalentValue("modifier_invoker_exort_4", "cd"))
        end
    end 

    if caster:HasModifier("modifier_invoker_exort_6") then
        params.target:AddNewModifier(caster, self:GetAbility(), "modifier_forged_spirit_melting_strike_custom_slow", {duration = (1 - params.target:GetStatusResistance())*caster:GetTalentValue("modifier_invoker_exort_6", "duration")})
    end 

end 

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_forged_spirit_melting_strike_custom_debuff", {duration = self.duration })
end


function modifier_forged_spirit_melting_strike_custom_tracker:GetModifierIncomingDamage_Percentage()
local caster = self:GetParent().owner
if not caster then return end 
if not caster:HasModifier("modifier_invoker_exort_6") then return end

return caster:GetTalentValue("modifier_invoker_exort_6", "damage")
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


self.sun_strike = self:GetCaster():FindAbilityByName("invoker_sun_strike_custom")
self.meteor = self:GetCaster():FindAbilityByName("invoker_chaos_meteor_custom")

self.radius = self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "radius")
self.meteor_count = self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "meteor")
self.max =  self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "sun")
self.count = 0


self.interval = table.max/(self.max)


self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_chaos_meteor_custom_cataclysm_caster", {interval = self.interval})
self:StartIntervalThink(self.interval)
end 


function modifier_invoker_chaos_meteor_custom_cataclysm:OnDestroy()
if not IsServer() then return end 

self:GetCaster():RemoveModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_caster")
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
    self:GetCaster():Interrupt()
    return 
end

end 

function modifier_invoker_chaos_meteor_custom_cataclysm:GivePoint(k)
local radius = self.radius
local point = self:GetParent():GetAbsOrigin()

if k == 2 then 
    local dir = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
    point = self:GetParent():GetAbsOrigin() + dir*self.radius*0.6

    radius = self.radius*0.6
end 

return point + RandomVector(RandomInt(radius*0.2, radius))
end 



modifier_invoker_chaos_meteor_custom_cataclysm_caster = class({})
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:IsHidden() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:IsPurgable() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:OnCreated(kv)
if not IsServer() then return end
self:GetCaster():RemoveModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_visual")

self.duration = kv.interval*self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "sun")


if self.duration <= 1.4 then 
    self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_TORNADO, 0.8)
   -- self:StartIntervalThink(0.6)
else 
    self:GetCaster():StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end

end 

function modifier_invoker_chaos_meteor_custom_cataclysm_caster:OnIntervalThink()
if not IsServer() then return end 

self:GetCaster():StartGesture(ACT_DOTA_GENERIC_CHANNEL_1)
self:StartIntervalThink(-1)
end 

function modifier_invoker_chaos_meteor_custom_cataclysm_caster:OnDestroy()
if not IsServer() then return end

self:GetCaster():FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
self:GetCaster():FadeGesture(ACT_DOTA_CAST_TORNADO)
end 



function modifier_invoker_chaos_meteor_custom_cataclysm_caster:GetEffectName() return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf" end
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:GetStatusEffectName()
return "particles/status_fx/status_effect_omnislash.vpcf"
end
function modifier_invoker_chaos_meteor_custom_cataclysm_caster:StatusEffectPriority() return
11111
end


modifier_invoker_chaos_meteor_custom_cataclysm_stack = class({})
function modifier_invoker_chaos_meteor_custom_cataclysm_stack:IsHidden() return true end
function modifier_invoker_chaos_meteor_custom_cataclysm_stack:IsPurgable() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_stack:RemoveOnDeath() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_stack:OnCreated()
if not IsServer() then return end 

self.reset = self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "reset")
self.duration = self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "duration")
self.min_cast = self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "min_cast")
self.attack_stack = self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "attack_stack")

self.max_stack = math.abs((self.duration - self.min_cast)/self.attack_stack)

self:SetStackCount(0)
end 

function modifier_invoker_chaos_meteor_custom_cataclysm_stack:AddStack()
if not IsServer() then return end 
if self:GetCaster():HasModifier("modifier_invoker_chaos_meteor_custom_cataclysm_caster") then return end

self:StartIntervalThink(self.reset)
 
if self:GetStackCount() >= self.max_stack then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max_stack then 
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_chaos_meteor_custom_cataclysm_visual", {})
end 

end 


function modifier_invoker_chaos_meteor_custom_cataclysm_stack:OnIntervalThink()
if not IsServer() then return end 
if self:GetCaster():HasModifier("modifier_invoker_chaos_meteor_custom_cataclysm_caster") then 
    self:StartIntervalThink(-1)
    return
end 

self:SetStackCount(0)
self:StartIntervalThink(-1)
end 


function modifier_invoker_chaos_meteor_custom_cataclysm_stack:OnStackCountChanged()
if not IsServer() then return end 

if self:GetStackCount() < self.max_stack then 
    self:GetParent():RemoveModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_visual")
end 

self.cast = self:GetStackCount()

self.number =  self.duration + self:GetStackCount()*self.attack_stack

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'invoker_meteor_change',  {max = self.max_stack, damage = self.cast, number = self.number})

end 



modifier_invoker_chaos_meteor_custom_cataclysm_visual = class({})
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:IsHidden() return true end
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:IsPurgable() return false end

function modifier_invoker_chaos_meteor_custom_cataclysm_visual:GetEffectName() return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf" end
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:GetStatusEffectName() return "particles/status_fx/status_effect_omnislash.vpcf" end
function modifier_invoker_chaos_meteor_custom_cataclysm_visual:StatusEffectPriority() return 11111 end


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


modifier_invoker_chaos_meteor_custom_cataclysm_forge = class({})
function modifier_invoker_chaos_meteor_custom_cataclysm_forge:IsHidden() return true end
function modifier_invoker_chaos_meteor_custom_cataclysm_forge:IsPurgable() return false end
function modifier_invoker_chaos_meteor_custom_cataclysm_forge:OnCreated()
if not IsServer() then return end 

self.max = self:GetCaster():GetTalentValue("modifier_invoker_exort_7", "attacks")

self:SetStackCount(1)
end 

function modifier_invoker_chaos_meteor_custom_cataclysm_forge:OnRefresh()
if not IsServer() then return end 
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
    local mod = self:GetCaster():FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")

    if mod then 
        mod:AddStack()
    end

    self:Destroy() 
end 

end 





modifier_invoker_forged_spirit_custom_tracker = class({})
function modifier_invoker_forged_spirit_custom_tracker:IsHidden() return true end
function modifier_invoker_forged_spirit_custom_tracker:IsPurgable() return false end
function modifier_invoker_forged_spirit_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end




function modifier_invoker_forged_spirit_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_invoker_exort_4") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if params.ability:GetName() == "invoker_quas_custom" or 
    params.ability:GetName() == "invoker_exort_custom" or 
    params.ability:GetName() == "invoker_wex_custom" or 
    params.ability:GetName() == "invoker_invoke_custom"  then return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_invoker_exort_4", "count") then 
    self:GetAbility():SummonSpirit(false, 0)
    self:SetStackCount(0)
end 

end 




modifier_forged_spirit_melting_strike_custom_slow = class({})
function modifier_forged_spirit_melting_strike_custom_slow:IsHidden() return true end
function modifier_forged_spirit_melting_strike_custom_slow:IsPurgable() return true end
function modifier_forged_spirit_melting_strike_custom_slow:GetTexture() return "buffs/remnant_slow" end

function modifier_forged_spirit_melting_strike_custom_slow:OnCreated(table)
self.slow = self:GetCaster():GetTalentValue("modifier_invoker_exort_6", "slow")

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

self.radius = self:GetCaster():GetTalentValue("modifier_invoker_exort_2", "radius")

if not IsServer() then return end 

self.nFXIndex = ParticleManager:CreateParticle("particles/invoker/sun_fire.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 1, self:GetParent():GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(self.radius*1.2, 0, 0))
ParticleManager:ReleaseParticleIndex(self.nFXIndex)

self:AddParticle(self.nFXIndex,false,false,-1,false,false)

end 

function modifier_invoker_sun_strike_custom_fire:IsAura()
    return true
end

function modifier_invoker_sun_strike_custom_fire:GetModifierAura()
    return "modifier_invoker_sun_strike_custom_fire_debuff"
end

function modifier_invoker_sun_strike_custom_fire:GetAuraRadius()
    return self.radius
end

function modifier_invoker_sun_strike_custom_fire:GetAuraDuration()
    return 1
end

function modifier_invoker_sun_strike_custom_fire:GetAuraSearchTeam()
return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_invoker_sun_strike_custom_fire:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_invoker_sun_strike_custom_fire:GetAuraSearchFlags()
    return 0
end

function modifier_invoker_sun_strike_custom_fire:OnDestroy()
if not IsServer() then return end
UTIL_Remove( self:GetParent() )
end







modifier_invoker_sun_strike_custom_fire_debuff = class({})
function modifier_invoker_sun_strike_custom_fire_debuff:IsHidden() return false end
function modifier_invoker_sun_strike_custom_fire_debuff:IsPurgable() return false end


function modifier_invoker_sun_strike_custom_fire_debuff:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_invoker_exort_2", "slow")
self.interval = 0.5

self.damage = self:GetCaster():GetTalentValue("modifier_invoker_exort_2", "damage")*self.interval

if not IsServer() then return end 

self:StartIntervalThink(self.interval)
end

function modifier_invoker_sun_strike_custom_fire_debuff:OnIntervalThink()
if not IsServer() then return end

local real_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL})
self:GetParent():SendNumber(4, real_damage)

end


function modifier_invoker_sun_strike_custom_fire_debuff:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_invoker_sun_strike_custom_fire_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end










modifier_invoker_sun_strike_custom_blind = class({})

function modifier_invoker_sun_strike_custom_blind:IsPurgable() return true end
function modifier_invoker_sun_strike_custom_blind:IsHidden() return true end
function modifier_invoker_sun_strike_custom_blind:GetEffectName() return "particles/items3_fx/black_powder_blind_debuff.vpcf" end

function modifier_invoker_sun_strike_custom_blind:OnCreated(params)

self.miss_chance = self:GetCaster():GetTalentValue("modifier_invoker_exort_5", "miss")
end


function modifier_invoker_sun_strike_custom_blind:DeclareFunctions()
    local decFuns =
        {
            MODIFIER_PROPERTY_MISS_PERCENTAGE,
        }
        
    return decFuns
end

function modifier_invoker_sun_strike_custom_blind:GetModifierMiss_Percentage()
if self:GetParent():HasModifier('modifier_tower_incoming_speed') then return end
    return self.miss_chance
end
