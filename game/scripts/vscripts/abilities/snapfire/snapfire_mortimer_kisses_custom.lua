LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_thinker", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_debuff", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_tracker", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_napalm", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_legendary", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_stun_check", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_gobble", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_gobble_caster", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_gobble_slow", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_mortimer_kisses_custom_scatter", "abilities/snapfire/snapfire_mortimer_kisses_custom", LUA_MODIFIER_MOTION_NONE )


snapfire_mortimer_kisses_custom = class({})


snapfire_mortimer_kisses_custom.max_inc = {2, 3, 4}









function snapfire_mortimer_kisses_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf", context )
PrecacheResource( "particle", "particles/hero_snapfire_ultimate_linger_longer.vpcf", context )
PrecacheResource( "particle", "particles/alch_stun_legendary.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_burn_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_magma.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_stickynapalm.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_batrider/batrider_stickynapalm_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/snapfire_flaming_creep.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_life_stealer/life_stealer_infested_unit_icon.vpcf", context )

end







function snapfire_mortimer_kisses_custom:GetIntrinsicModifierName()
return "modifier_snapfire_mortimer_kisses_custom_tracker"
end


function snapfire_mortimer_kisses_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0
if self:GetCaster():HasModifier("modifier_snapfire_kisses_1") then 
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_1", "cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end





function snapfire_mortimer_kisses_custom:GetAOERadius()
    return self:GetSpecialValueFor( "impact_radius" )
end


function snapfire_mortimer_kisses_custom:OnSpellStart()

local caster = self:GetCaster()
local point = self:GetCursorPosition()

if point == self:GetCaster():GetAbsOrigin() then 
    point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*10
end


local duration = self:GetDuration()

if self:GetCaster():HasModifier("modifier_snapfire_kisses_5") then 
    self:GetCaster():EmitSound("Snapfire.Kisses_bkb")
    self:GetCaster():Purge(false, true, false, false, false)
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_debuff_immune", {effect = 1, duration = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_5", "bkb")})
end


caster:AddNewModifier( caster, self, "modifier_snapfire_mortimer_kisses_custom", { duration = duration, pos_x = point.x,  pos_y = point.y, } )
end




function snapfire_mortimer_kisses_custom:LauchBall(location, speed, damage_k)
if not IsServer() then return end
local min_range = 0--self:GetSpecialValueFor( "min_range" )
local max_range = self:GetCastRange( Vector(0,0,0), nil )
local range = max_range-min_range
    
local min_travel = 0.2-- self:GetSpecialValueFor( "min_lob_travel_time" )
local max_travel = self:GetSpecialValueFor( "max_lob_travel_time" )
local travel_range = max_travel-min_travel
    
local k = 1
if speed then 
    k = speed
end

local damage = 1 

if damage_k then 
    damage = damage_k
end 

local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )*k
local projectile_vision = self:GetSpecialValueFor( "projectile_vision" )

local projectile_name = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf"
local projectile_start_radius = 0
local projectile_end_radius = 0

 self.info = 
 {
    Source = self:GetCaster(),
    Ability = self,    
        
    EffectName = projectile_name,
    iMoveSpeed = projectile_speed,
    bDodgeable = false,                           -- Optional
    
    vSourceLoc = self:GetCaster():GetOrigin(),                -- Optional (HOW)
        
    bDrawsOnMinimap = false,                          -- Optional
    bVisibleToEnemies = true,                         -- Optional
    bProvidesVision = true,                           -- Optional
    iVisionRadius = projectile_vision,                              -- Optional
    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),        -- Optional
    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_3, 
    ExtraData = 
    {
        damage = damage
    }

}

local origin = self:GetCaster():GetOrigin()
local vec = location-origin
local direction = vec
direction.z = 0
direction = direction:Normalized()

if vec:Length2D()<min_range then
    vec = direction * min_range
elseif vec:Length2D()>max_range then
     vec = direction * max_range
end

local target = GetGroundPosition( origin + vec, nil )
local vector = vec
local travel_time = (vec:Length2D()-min_range)/range * travel_range + min_travel

local thinker = CreateModifierThinker( self:GetCaster(), self,  "modifier_snapfire_mortimer_kisses_custom_thinker",   { travel_time = travel_time }, target, self:GetCaster():GetTeamNumber(),  false )


self.info.iMoveSpeed = (vector:Length2D()/travel_time)*k
self.info.Target = thinker

ProjectileManager:CreateTrackingProjectile( self.info )

AddFOWViewer( self:GetCaster():GetTeamNumber(), thinker:GetOrigin(), 100, 1, false )

local sound_cast = "Hero_Snapfire.MortimerBlob.Launch"
self:GetCaster():EmitSound(sound_cast)


end 



function snapfire_mortimer_kisses_custom:NapalmStack(point)
if not IsServer() then return end

local radius = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_4", "radius")
local duration = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_4", "duration")

EmitSoundOnLocationWithCaster(point, "Hero_Batrider.StickyNapalm.Impact", self:GetCaster())

local napalm_impact_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_stickynapalm_impact.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(napalm_impact_particle, 0, point)
ParticleManager:SetParticleControl(napalm_impact_particle, 1, Vector(radius, 0, 0))
ParticleManager:SetParticleControl(napalm_impact_particle, 2, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(napalm_impact_particle)

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), point,  nil,  radius, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0,  0,  false   )

for _,enemy in pairs(enemies) do
    enemy:AddNewModifier(self:GetCaster(), self, "modifier_snapfire_mortimer_kisses_custom_napalm", {duration = duration})
end

end



function snapfire_mortimer_kisses_custom:OnProjectileHit_ExtraData(target, location, extraData)
if not target then return end


local k = 1
if extraData.damage then 
    k = extraData.damage
end

local damage = self:GetSpecialValueFor( "damage_per_impact" )*k
local duration = self:GetSpecialValueFor( "burn_ground_duration" )
local impact_radius = self:GetSpecialValueFor( "impact_radius" )
local vision = self:GetSpecialValueFor( "projectile_vision" )
 
if self:GetCaster():HasModifier("modifier_snapfire_kisses_6") then 
    duration = duration + self:GetCaster():GetTalentValue("modifier_snapfire_kisses_6", "duration")
end


local damageTable = {  attacker = self:GetCaster(),  damage = damage,  damage_type = self:GetAbilityDamageType(), ability = self,  }

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), location,  nil,  impact_radius, DOTA_UNIT_TARGET_TEAM_ENEMY,   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0,  0,  false   )

for _,enemy in pairs(enemies) do
    damageTable.victim = enemy
    ApplyDamage(damageTable)
end

target:AddNewModifier(  self:GetCaster(), self,  "modifier_snapfire_mortimer_kisses_custom_thinker",   { duration = duration,  slow = 1, }  )


AddFOWViewer( self:GetCaster():GetTeamNumber(), location, vision, duration, false )

self:PlayEffects( target:GetOrigin() )
end

--------------------------------------------------------------------------------
function snapfire_mortimer_kisses_custom:PlayEffects( loc ) 

local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf"
local particle_cast2 = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf"

if self:GetCaster():HasModifier("modifier_snapfire_kisses_6") then 
    particle_cast2 = "particles/hero_snapfire_ultimate_linger_longer.vpcf"
end

local sound_cast = "Hero_Snapfire.MortimerBlob.Impact"
 
local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 3, loc )
ParticleManager:ReleaseParticleIndex( effect_cast )

local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( effect_cast, 0, loc )
ParticleManager:SetParticleControl( effect_cast, 1, loc )
ParticleManager:ReleaseParticleIndex( effect_cast )
 
local sound_location = "Hero_Snapfire.MortimerBlob.Impact"
EmitSoundOnLocationWithCaster( loc, sound_location, self:GetCaster() )
end




modifier_snapfire_mortimer_kisses_custom = class({})



function modifier_snapfire_mortimer_kisses_custom:IsHidden()
    return false
end

function modifier_snapfire_mortimer_kisses_custom:IsDebuff()
    return false
end

function modifier_snapfire_mortimer_kisses_custom:IsStunDebuff()
    return false
end

function modifier_snapfire_mortimer_kisses_custom:IsPurgable()
    return false
end



function modifier_snapfire_mortimer_kisses_custom:OnCreated( kv )

    self.regen = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_3", "regen")

    self.min_range = self:GetAbility():GetSpecialValueFor( "min_range" )
    self.max_range = self:GetAbility():GetCastRange( Vector(0,0,0), nil )
    self.range = self.max_range-self.min_range
    
    self.min_travel = self:GetAbility():GetSpecialValueFor( "min_lob_travel_time" )
    self.max_travel = self:GetAbility():GetSpecialValueFor( "max_lob_travel_time" )
    self.travel_range = self.max_travel-self.min_travel
    
    self.projectile_speed = self:GetAbility():GetSpecialValueFor( "projectile_speed" )
    local projectile_vision = self:GetAbility():GetSpecialValueFor( "projectile_vision" )
    
    self.turn_rate = self:GetAbility():GetSpecialValueFor( "turn_rate" )

    self.damage_reduce = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_5", "damage_reduce")

    if not IsServer() then return end

    if self:GetParent():HasModifier("modifier_snapfire_scatter_7") then 
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_snapfire_mortimer_kisses_custom_scatter", {})
    end

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_snapfire_mortimer_kisses_custom_stun_check", {})

    self.RemoveForDuel = true
    self.max_base = self:GetAbility():GetSpecialValueFor( "projectile_count" )

    self.max_bonus = 0
    if self:GetCaster():HasModifier("modifier_snapfire_kisses_2") then 
        self.max_bonus = self:GetAbility().max_inc[self:GetCaster():GetUpgradeStack("modifier_snapfire_kisses_2")]
    end

    if self:GetParent():HasModifier("modifier_snapfire_kisses_5") then 

        self.particle_ally_fx = ParticleManager:CreateParticle("particles/alch_stun_legendary.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.particle_ally_fx, 0, self:GetParent():GetAbsOrigin())
        self:AddParticle(self.particle_ally_fx, false, false, -1, false, false) 

        self.effect_cast = ParticleManager:CreateParticle("particles/items3_fx/star_emblem_friend_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        self:AddParticle(self.effect_cast , false, false, -1, false, false) 
    end


    local interval = self:GetAbility():GetDuration()/(self.max_base + self.max_bonus) + 0.01

    self:SetValidTarget( Vector( kv.pos_x, kv.pos_y, 0 ) )
    local projectile_name = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf"
    local projectile_start_radius = 0
    local projectile_end_radius = 0



    -- precache projectile
    self.info = {
        -- Target = target,
        Source = self:GetCaster(),
        Ability = self:GetAbility(),    
        
        EffectName = projectile_name,
        iMoveSpeed = self.projectile_speed,
        bDodgeable = false,                           -- Optional
    
        vSourceLoc = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_mouth")),                -- Optional (HOW)
        
        bDrawsOnMinimap = false,                          -- Optional
        bVisibleToEnemies = true,                         -- Optional
        bProvidesVision = true,                           -- Optional
        iVisionRadius = projectile_vision,                              -- Optional
        iVisionTeamNumber = self:GetCaster():GetTeamNumber()  ,

        ExtraData = 
        {
            damage = 1
        }     
    }

    -- Start interval
    self:StartIntervalThink( interval )
    self:OnIntervalThink()
end

function modifier_snapfire_mortimer_kisses_custom:OnRefresh( kv )
    
end

function modifier_snapfire_mortimer_kisses_custom:OnRemoved()
end

function modifier_snapfire_mortimer_kisses_custom:OnDestroy()
if not IsServer() then return end

self:GetParent():RemoveModifierByName("modifier_snapfire_mortimer_kisses_custom_scatter")
self:GetParent():RemoveModifierByName("modifier_snapfire_mortimer_kisses_custom_stun_check")
self:GetCaster():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_4)
end


function modifier_snapfire_mortimer_kisses_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ORDER,

        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }

    return funcs
end


function modifier_snapfire_mortimer_kisses_custom:GetModifierHealthRegenPercentage()
return self.regen
end

function modifier_snapfire_mortimer_kisses_custom:OnOrder( params )
    if params.unit~=self:GetParent() then return end

    -- right click, switch position
    if  params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION or
        params.order_type==DOTA_UNIT_ORDER_ATTACK_MOVE then 
        self:SetValidTarget( params.new_pos )
    elseif 
        params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
        params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
    then
        self:SetValidTarget( params.target:GetOrigin() )

    -- stop or hold
    elseif 
        params.order_type==DOTA_UNIT_ORDER_STOP or
        params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION or
        params.order_type==DOTA_UNIT_ORDER_CAST_POSITION or
        params.order_type==DOTA_UNIT_ORDER_CAST_TARGET or
        params.order_type==DOTA_UNIT_ORDER_CAST_NO_TARGET 
    then

        self:Destroy()
    end
end


function modifier_snapfire_mortimer_kisses_custom:GetModifierIncomingDamage_Percentage()
if not self:GetParent():HasModifier("modifier_snapfire_kisses_5") then return end

return self.damage_reduce
end


function modifier_snapfire_mortimer_kisses_custom:GetModifierMoveSpeed_Limit()
    return 0.1
end

function modifier_snapfire_mortimer_kisses_custom:GetModifierTurnRate_Percentage()
    return -150
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_snapfire_mortimer_kisses_custom:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    }

    return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_snapfire_mortimer_kisses_custom:OnIntervalThink()

local thinker = CreateModifierThinker( self:GetParent(), self:GetAbility(),  "modifier_snapfire_mortimer_kisses_custom_thinker",   { travel_time = self.travel_time },  self.target, self:GetParent():GetTeamNumber(),  false )



self.info.iMoveSpeed = self.vector:Length2D()/self.travel_time
self.info.Target = thinker

ProjectileManager:CreateTrackingProjectile( self.info )

AddFOWViewer( self:GetParent():GetTeamNumber(), thinker:GetOrigin(), 100, 1, false )

local k = (self.max_bonus + self.max_base) / self.max_base

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_4, k)

local sound_cast = "Hero_Snapfire.MortimerBlob.Launch"
EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Helper
function modifier_snapfire_mortimer_kisses_custom:SetValidTarget( location )
    local origin = self:GetParent():GetOrigin()
    local vec = location-origin
    local direction = vec
    direction.z = 0
    direction = direction:Normalized()

    if vec:Length2D()<self.min_range then
        vec = direction * self.min_range
    elseif vec:Length2D()>self.max_range then
        vec = direction * self.max_range
    end

    self.target = GetGroundPosition( origin + vec, nil )
    self.vector = vec
    self.travel_time = (vec:Length2D()-self.min_range)/self.range * self.travel_range + self.min_travel
end




modifier_snapfire_mortimer_kisses_custom_debuff = class({})



function modifier_snapfire_mortimer_kisses_custom_debuff:IsHidden()
    return false
end

function modifier_snapfire_mortimer_kisses_custom_debuff:IsDebuff()
    return true
end

function modifier_snapfire_mortimer_kisses_custom_debuff:IsStunDebuff()
    return false
end

function modifier_snapfire_mortimer_kisses_custom_debuff:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_snapfire_mortimer_kisses_custom_debuff:OnCreated( kv )

self.turn = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_6", "turn_slow")

self.ability = self:GetAbility()

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_6", "heal_reduce")

self.epic_damage = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_4", "damage")

self.slow = -self.ability:GetSpecialValueFor( "move_slow_pct" )
self.dps = self.ability:GetSpecialValueFor( "burn_damage" )
self.interval = self.ability:GetSpecialValueFor( "burn_interval" )

if not IsServer() then return end


self.damageTable = {
    victim = self:GetParent(),
    attacker = self:GetCaster(),
    damage = self.dps*self.interval,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability, --Optional.
}

-- Start interval
self:StartIntervalThink( self.interval )
self:OnIntervalThink()
end

function modifier_snapfire_mortimer_kisses_custom_debuff:OnRefresh( kv )
    
end

function modifier_snapfire_mortimer_kisses_custom_debuff:OnRemoved()
end

function modifier_snapfire_mortimer_kisses_custom_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_snapfire_mortimer_kisses_custom_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE
    }

    return funcs
end

function modifier_snapfire_mortimer_kisses_custom_debuff:GetModifierTurnRate_Percentage()
if not self:GetCaster():HasModifier("modifier_snapfire_kisses_6") then return end
    return self.turn
end

function modifier_snapfire_mortimer_kisses_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

function modifier_snapfire_mortimer_kisses_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_snapfire_kisses_6") then return end
return self.heal_reduce
end

function modifier_snapfire_mortimer_kisses_custom_debuff:GetModifierHealAmplify_PercentageTarget() 
if not self:GetCaster():HasModifier("modifier_snapfire_kisses_6") then return end
return self.heal_reduce
end

function modifier_snapfire_mortimer_kisses_custom_debuff:GetModifierHPRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_snapfire_kisses_6") then return end
return self.heal_reduce
end




--------------------------------------------------------------------------------
-- Interval Effects
function modifier_snapfire_mortimer_kisses_custom_debuff:OnIntervalThink()
if not IsServer() then return end


local damage = self.dps

local mod = self:GetParent():FindModifierByName("modifier_snapfire_mortimer_kisses_custom_napalm")
if mod then 
    damage = damage + self.epic_damage*mod:GetStackCount()
end

damage = damage*self.interval

self.damageTable.damage = damage

SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), damage, nil)
ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_snapfire_mortimer_kisses_custom_debuff:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_burn_debuff.vpcf"
end

function modifier_snapfire_mortimer_kisses_custom_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_snapfire_mortimer_kisses_custom_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_magma.vpcf"
end

function modifier_snapfire_mortimer_kisses_custom_debuff:StatusEffectPriority()
    return 101
end
















modifier_snapfire_mortimer_kisses_custom_thinker = class({})


function modifier_snapfire_mortimer_kisses_custom_thinker:OnCreated( kv )

self.ability = self:GetCaster():FindAbilityByName("snapfire_mortimer_kisses_custom")
if not self.ability then 
    self:Destroy()
    return
end 

self.max_travel = self.ability:GetSpecialValueFor( "max_lob_travel_time" )
self.radius = self.ability:GetSpecialValueFor( "impact_radius" )
self.linger = self.ability:GetSpecialValueFor( "burn_linger_duration" )

if not IsServer() then return end

self.start = false

self:PlayEffects( kv.travel_time )
end

function modifier_snapfire_mortimer_kisses_custom_thinker:OnRefresh( kv )

self.ability = self:GetCaster():FindAbilityByName("snapfire_mortimer_kisses_custom")
if not self.ability then 
    self:Destroy()
    return
end 

self.max_travel = self.ability:GetSpecialValueFor( "max_lob_travel_time" )
self.radius = self.ability:GetSpecialValueFor( "impact_radius" )
self.linger = self.ability:GetSpecialValueFor( "burn_linger_duration" )

if not IsServer() then return end

self.start = true

self:StopEffects()
end


function modifier_snapfire_mortimer_kisses_custom_thinker:OnDestroy()
if not IsServer() then return end
    UTIL_Remove( self:GetParent() )
end



function modifier_snapfire_mortimer_kisses_custom_thinker:IsAura()
    return self.start
end

function modifier_snapfire_mortimer_kisses_custom_thinker:GetModifierAura()
    return "modifier_snapfire_mortimer_kisses_custom_debuff"
end

function modifier_snapfire_mortimer_kisses_custom_thinker:GetAuraRadius()
    return self.radius
end

function modifier_snapfire_mortimer_kisses_custom_thinker:GetAuraDuration()
    return self.linger
end

function modifier_snapfire_mortimer_kisses_custom_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_snapfire_mortimer_kisses_custom_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end




function modifier_snapfire_mortimer_kisses_custom_thinker:PlayEffects( time )

local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"


self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius*(self.max_travel/time) ) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( time, 0, 0 ) )
end

function modifier_snapfire_mortimer_kisses_custom_thinker:StopEffects()
    ParticleManager:DestroyParticle( self.effect_cast, true )
    ParticleManager:ReleaseParticleIndex( self.effect_cast )
end




modifier_snapfire_mortimer_kisses_custom_tracker = class({})
function modifier_snapfire_mortimer_kisses_custom_tracker:IsHidden() return true end
function modifier_snapfire_mortimer_kisses_custom_tracker:IsPurgable() return false end
function modifier_snapfire_mortimer_kisses_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}
end

function modifier_snapfire_mortimer_kisses_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_snapfire_kisses_3") then return end
if not params.attacker then return end
if self:GetCaster() ~= params.attacker then return end
if not params.inflictor then return end
if params.inflictor ~= self:GetAbility() then return end
if params.unit:IsIllusion() then return end

local heal = params.damage*self:GetCaster():GetTalentValue("modifier_snapfire_kisses_3", "heal")/100

if params.unit:IsCreep() then 
    heal =  heal*self:GetCaster():GetTalentValue("modifier_snapfire_kisses_3", "heal_creeps")
end

self:GetCaster():GenericHeal(heal, self:GetAbility(), true)


end


function modifier_snapfire_mortimer_kisses_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_snapfire_kisses_4") then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_snapfire_kisses_4", "attack") then 
    self:SetStackCount(0)
    self:GetAbility():NapalmStack(params.target:GetAbsOrigin())
end


end


function modifier_snapfire_mortimer_kisses_custom_tracker:OnAbilityExecuted( params )
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_snapfire_kisses_4") then return end
if params.unit~=self:GetParent() then return end
if not params.ability then return end
if params.ability:IsItem() or params.ability:IsToggle() then return end
if UnvalidAbilities[params.ability:GetName()] then return end
if UnvalidItems[params.ability:GetName()] then return end

local range = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_4", "range")

local units_heroes = FindUnitsInRadius( self:GetParent():GetTeamNumber(),  self:GetParent():GetAbsOrigin(),  nil, range,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,  FIND_CLOSEST,  false )
local units_creeps = FindUnitsInRadius( self:GetParent():GetTeamNumber(),  self:GetParent():GetAbsOrigin(),  nil, range,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,  FIND_CLOSEST,  false )
                
local units = units_heroes

if #units == 0 then 
    units = units_creeps
end

if #units > 0 then 
    local unit = units[1]
    self:GetAbility():NapalmStack(unit:GetAbsOrigin())
end


end












modifier_snapfire_mortimer_kisses_custom_napalm = class({})
function modifier_snapfire_mortimer_kisses_custom_napalm:IsHidden() return false end
function modifier_snapfire_mortimer_kisses_custom_napalm:IsPurgable() return false end
function modifier_snapfire_mortimer_kisses_custom_napalm:GetTexture() return "batrider_sticky_napalm" end
function modifier_snapfire_mortimer_kisses_custom_napalm:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_4", "slow")
self.damage = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_4", "damage")
self.max = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_4", "max")

if not IsServer() then return end
self:SetStackCount(1)

self.RemoveForDuel = true
end

function modifier_snapfire_mortimer_kisses_custom_napalm:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end


function modifier_snapfire_mortimer_kisses_custom_napalm:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_snapfire_mortimer_kisses_custom_napalm:GetModifierMoveSpeedBonus_Percentage()
return self:GetStackCount()*self.slow
end


function modifier_snapfire_mortimer_kisses_custom_napalm:OnTooltip()
return self:GetStackCount()*self.damage
end


function modifier_snapfire_mortimer_kisses_custom_napalm:GetEffectName()
    return "particles/units/heroes/hero_batrider/batrider_stickynapalm_debuff.vpcf"
end

function modifier_snapfire_mortimer_kisses_custom_napalm:GetStatusEffectName()
    return "particles/status_fx/status_effect_stickynapalm.vpcf"
end

function modifier_snapfire_mortimer_kisses_custom_napalm:StatusEffectPriority()
    return 100
end


function modifier_snapfire_mortimer_kisses_custom_napalm:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if self:GetStackCount() == 1 then 

    local particle_cast = "particles/units/heroes/hero_batrider/batrider_stickynapalm_stack.vpcf"

    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

    self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 
  if self.effect_cast then 

    local k1 = 0
    local k2 = self:GetStackCount()

    if k2 >= 10 then 
        k1 = 1
        k2 = self:GetStackCount() - 10
    end

    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( k1, k2, 0 ) )
  end
end

end



snapfire_mortimer_kisses_custom_legendary = class({})


function snapfire_mortimer_kisses_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_snapfire_kisses_7", "cd")
end


function snapfire_mortimer_kisses_custom_legendary:OnSpellStart()
if not IsServer() then return end

local unit = CreateUnitByName("npc_snapfire_firetoad", self:GetCursorPosition(), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())



unit.owner = self:GetCaster()
unit:EmitSound("Marci.Sidekick_summon")



local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )

unit:AddNewModifier(self:GetCaster(), self, "modifier_snapfire_mortimer_kisses_custom_legendary", {})

end


modifier_snapfire_mortimer_kisses_custom_legendary = class({})
function modifier_snapfire_mortimer_kisses_custom_legendary:IsHidden() return true end
function modifier_snapfire_mortimer_kisses_custom_legendary:IsPurgable() return false end
function modifier_snapfire_mortimer_kisses_custom_legendary:OnCreated(table)
if not IsServer() then return end

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_snapfire_mortimer_kisses_custom_stun_check", {})

self.main_ability = self:GetCaster():FindAbilityByName("snapfire_mortimer_kisses_custom")

self.delay = self:GetAbility():GetSpecialValueFor("delay")
self.interval = self:GetAbility():GetSpecialValueFor("interval")

self.min_range = self.main_ability:GetSpecialValueFor( "min_range" )
self.max_range = self.main_ability:GetCastRange( Vector(0,0,0), nil )

self.range = self.max_range-self.min_range

self.change_health = self:GetAbility():GetSpecialValueFor("health") - 100

self.min_travel = self.main_ability:GetSpecialValueFor( "min_lob_travel_time" )
self.max_travel = self.main_ability:GetSpecialValueFor( "max_lob_travel_time" )
self.travel_range = self.max_travel-self.min_travel

self:SetStackCount(0)

self.cast_slow = self:GetAbility():GetSpecialValueFor("cast_slow")

local bonus = 0
if self:GetCaster():HasModifier("modifier_snapfire_kisses_2") then 
    bonus = self.main_ability.max_inc[self:GetCaster():GetUpgradeStack("modifier_snapfire_kisses_2")]
end

self.max = math.floor( (self.main_ability:GetSpecialValueFor("projectile_count") +  bonus)*(self:GetCaster():GetTalentValue("modifier_snapfire_kisses_7", "count")/100))



self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, self.cast_slow)
self.start = true
self.end_cast  = false

self:StartIntervalThink(self.delay/self.cast_slow)

local projectile_name = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf"

self.projectile_speed = self.main_ability:GetSpecialValueFor( "projectile_speed" )
local projectile_vision = self.main_ability:GetSpecialValueFor( "projectile_vision" )

self.info = {
        -- Target = target,
        Source = self:GetParent(),
        Ability = self.main_ability,    
        
        EffectName = projectile_name,
        iMoveSpeed = self.projectile_speed,
        bDodgeable = false,                           -- Optional
    
        vSourceLoc = self:GetParent():GetOrigin(),                -- Optional (HOW)
        
        bDrawsOnMinimap = false,                          -- Optional
        bVisibleToEnemies = true,                         -- Optional
        bProvidesVision = true,                           -- Optional
        iVisionRadius = projectile_vision,                              -- Optional
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),   
        ExtraData = 
        {
            damage = self:GetCaster():GetTalentValue("modifier_snapfire_kisses_7", "damage")/100
        }
    }


end


function modifier_snapfire_mortimer_kisses_custom_legendary:DeclareFunctions()
    local funcs = {

        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }

    return funcs
end


function modifier_snapfire_mortimer_kisses_custom_legendary:GetModifierExtraHealthBonus()
return self.change_health
end




function modifier_snapfire_mortimer_kisses_custom_legendary:GetModifierTurnRate_Percentage()
return -150
end


function modifier_snapfire_mortimer_kisses_custom_legendary:OnIntervalThink()
if not IsServer() then return end

if self.end_cast == true then
    self:Destroy()
    return
end

if self.start == true then 
    self.start = false
else
    self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_4, self.cast_slow)
end

local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE

local units_heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(),  nil,  self.max_range, DOTA_UNIT_TARGET_TEAM_ENEMY,   DOTA_UNIT_TARGET_HERO, flags + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,  FIND_CLOSEST,  false   )
local units_creeps = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(),  nil,  self.max_range, DOTA_UNIT_TARGET_TEAM_ENEMY,   DOTA_UNIT_TARGET_BASIC, flags,  FIND_CLOSEST,  false   )



local abs = self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector()*RandomInt(400, 1500)
             
local units = units_heroes

if #units == 0 then 
    units = units_creeps
end

if #units > 0 then 
    abs = units[1]:GetAbsOrigin()
end

self:GetParent():MoveToPosition(abs)

local origin = self:GetParent():GetOrigin()
local vec = abs-origin
local direction = vec
direction.z = 0
direction = direction:Normalized()

if vec:Length2D()<self.min_range then
    vec = direction * self.min_range
elseif vec:Length2D()>self.max_range then
    vec = direction * self.max_range
end

self.target = GetGroundPosition( origin + vec, nil )
self.vector = vec

self.travel_time = (vec:Length2D()-self.min_range)/self.range * self.travel_range + self.min_travel

local thinker = CreateModifierThinker( self:GetCaster(),  self.main_ability,  "modifier_snapfire_mortimer_kisses_custom_thinker",   { travel_time = self.travel_time },  self.target, self:GetCaster():GetTeamNumber(),  false )


self.info.iMoveSpeed = self.vector:Length2D()/self.travel_time
self.info.Target = thinker

ProjectileManager:CreateTrackingProjectile( self.info )

AddFOWViewer( self:GetCaster():GetTeamNumber(), thinker:GetOrigin(), 100, 1, false )


self:GetParent():EmitSound("Hero_Snapfire.MortimerBlob.Launch")


self:IncrementStackCount()

if self:GetStackCount() >= self.max then
    self.end_cast = true  
end

self:StartIntervalThink(self.interval/self.cast_slow)
end


function modifier_snapfire_mortimer_kisses_custom_legendary:OnDestroy()
if not IsServer() then return end
if self:GetParent():IsAlive() then 
    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex( particle )

    self:GetParent():EmitSound("Marci.Sidekick_summon")

    UTIL_Remove(self:GetParent())
end

end



function modifier_snapfire_mortimer_kisses_custom_legendary:CheckState()
return
{
    [MODIFIER_STATE_ROOTED] = true,
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true
}

end



modifier_snapfire_mortimer_kisses_custom_stun_check = class({})
function modifier_snapfire_mortimer_kisses_custom_stun_check:IsHidden() return true end
function modifier_snapfire_mortimer_kisses_custom_stun_check:IsPurgable() return false end
function modifier_snapfire_mortimer_kisses_custom_stun_check:OnCreated(table)
if not IsServer() then return end

self:StartIntervalThink(FrameTime())
end

function modifier_snapfire_mortimer_kisses_custom_stun_check:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():IsStunned() or self:GetParent():IsHexed() or self:GetParent():IsSilenced() or self:GetParent():GetForceAttackTarget() ~= nil then 
    self:GetParent():RemoveModifierByName("modifier_snapfire_mortimer_kisses_custom")
    self:GetParent():RemoveModifierByName("modifier_snapfire_mortimer_kisses_custom_legendary")
    self:Destroy()
end

end







snapfire_gobble_up_custom = class({})



function snapfire_gobble_up_custom:GetCastRange(vLocation, hTarget)

if not self:GetCaster():HasModifier("modifier_snapfire_mortimer_kisses_custom_gobble_caster") then 
    return self:GetSpecialValueFor("cast_range_eat")
else
    if IsClient() then 
        return self:GetSpecialValueFor("cast_range_spit")
    else 
        return 999999
    end

end

end


function snapfire_gobble_up_custom:GetCastAnimation()
    
if not self:GetCaster():HasModifier("modifier_snapfire_mortimer_kisses_custom_gobble_caster") then 
    return ACT_DOTA_CAST_ABILITY_1
else
    return ACT_DOTA_CAST_ABILITY_4
end

end



function snapfire_gobble_up_custom:GetBehavior()

if not self:GetCaster():HasModifier("modifier_snapfire_mortimer_kisses_custom_gobble_caster") then 
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
else
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE
end

end


function snapfire_gobble_up_custom:GetManaCost(iLevel)

if not self:GetCaster():HasModifier("modifier_snapfire_mortimer_kisses_custom_gobble_caster") then 
    return 50
else
    return 0
end

end


function snapfire_gobble_up_custom:CastFilterResultTarget(target)
  if IsServer() then
    local caster = self:GetCaster()

    if target:GetTeamNumber() == DOTA_TEAM_CUSTOM_5 then
      return UF_FAIL_OTHER
    end


    return UnitFilter( target, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), self:GetCaster():GetTeamNumber() )
  end
end




function snapfire_gobble_up_custom:OnSpellStart()
if not IsServer() then return end


local caster = self:GetCaster()


if not self:GetCaster():HasModifier("modifier_snapfire_mortimer_kisses_custom_gobble_caster") then 

    local target = self:GetCursorTarget()

    if not target then 
        self:EndCooldown()
        return
    end

    if target:TriggerSpellReflect(self) then 
        return
    end

    if target:TriggerSpellAbsorb(self) then 
        return
    end


    if caster:HasModifier("modifier_snapfire_mortimer_kisses_custom_gobble") then 
        return
    end

    caster:EmitSound("Hero_Snapfire.GobbleUp.Cast")


    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_devour.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)

    target:AddNewModifier(self:GetCaster(), self, "modifier_snapfire_mortimer_kisses_custom_gobble", {duration = self:GetSpecialValueFor("duration")})
    caster:AddNewModifier(self:GetCaster(), self, "modifier_snapfire_mortimer_kisses_custom_gobble_caster", {target = target:entindex(), duration = self:GetSpecialValueFor("duration")})

    self:EndCooldown()
    self:StartCooldown(0.5)

else 

    local main_ability = self:GetCaster():FindAbilityByName("snapfire_mortimer_kisses_custom")

    local point = self:GetCursorPosition()

    if point == caster:GetAbsOrigin() then 
        point = caster:GetAbsOrigin() + caster:GetForwardVector()*10
    end




    local distance = self:GetSpecialValueFor("cast_range_spit")
    local dir = (point - self:GetCaster():GetAbsOrigin())

    local point = self:GetCaster():GetAbsOrigin() + dir:Normalized()*distance


    local speed = self:GetSpecialValueFor("speed")

    local height = 150  

    if main_ability and main_ability:GetLevel() > 0 then 
        main_ability:LauchBall(caster:GetAbsOrigin() + caster:GetForwardVector()*distance)
    end

    local mod = caster:FindModifierByName("modifier_snapfire_mortimer_kisses_custom_gobble_caster")

    if mod then 
        if mod.target and not mod.target:IsNull() and mod.target:HasModifier("modifier_snapfire_mortimer_kisses_custom_gobble") then 

            local target = mod.target

            target:EmitSound("Hero_Snapfire.SpitOut.Projectile")

            mod.target:RemoveModifierByName("modifier_snapfire_mortimer_kisses_custom_gobble")

            FindClearSpaceForUnit(mod.target, self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*5, false)


            local arc = target:AddNewModifier(caster, self, "modifier_generic_arc",
            {
                target_x = point.x,
                target_y = point.y,
                distance = distance,
                speed = speed,
                height = height,
                fix_end = false,
                isStun = true,
                activity = ACT_DOTA_FLAIL,


            })

            if arc then 

                local particle_cast = "particles/units/heroes/hero_snapfire/snapfire_flaming_creep.vpcf"
                local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
                ParticleManager:SetParticleControlEnt( effect_cast, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
                ParticleManager:SetParticleControlEnt( effect_cast, 5, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
                arc:AddParticle(  effect_cast,  false,   false,   -1, false,  false  )


                arc:SetEndCallback(function()

                    GridNav:DestroyTreesAroundPoint( target:GetAbsOrigin(), 400, true )

                    target:AddNewModifier(target, nil, "modifier_generic_passing", {duration = 3})
                    target:AddNewModifier(caster, self, "modifier_snapfire_mortimer_kisses_custom_gobble_slow", {duration = (1 - target:GetStatusResistance())*self:GetSpecialValueFor("move_slow_duration")})
                end)
            end

        end
        mod:Destroy()
    end


end


end




modifier_snapfire_mortimer_kisses_custom_gobble = class({})
function modifier_snapfire_mortimer_kisses_custom_gobble:IsHidden() return false end
function modifier_snapfire_mortimer_kisses_custom_gobble:IsPurgable() return false end
function modifier_snapfire_mortimer_kisses_custom_gobble:CheckState()
return
{
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_SILENCED] = true,
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_MUTED] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_UNSELECTABLE] = true,
}
end




function modifier_snapfire_mortimer_kisses_custom_gobble:OnCreated()
if not IsServer() then return end

self.NoDraw = true

self:GetParent():AddNoDraw()
self.caster = self:GetCaster()
self.range = self:GetAbility():GetSpecialValueFor("cast_range_eat")

self.RemoveForDuel = true

self:StartIntervalThink(FrameTime())
end

function modifier_snapfire_mortimer_kisses_custom_gobble:OnIntervalThink()
if not IsServer() then return end

if not self.caster or self.caster:IsNull() or not self.caster:IsAlive() then
    self:Destroy()
    return
end

if not self:GetParent() or self:GetParent():IsNull() or not self:GetParent():IsAlive() then
    self:Destroy()
    return
end


self:GetParent():SetAbsOrigin(self.caster:GetAbsOrigin())

end

function modifier_snapfire_mortimer_kisses_custom_gobble:OnDestroy()
if not IsServer() then return end

self:GetCaster():RemoveModifierByName("modifier_snapfire_mortimer_kisses_custom_gobble_caster")

if not self:GetParent() or self:GetParent():IsNull()  then return end

self:GetParent():RemoveNoDraw()

local abs = self:GetParent():GetAbsOrigin()

if self.caster then 
    abs = self.caster:GetAbsOrigin() + self.caster:GetForwardVector()*self.range
end

FindClearSpaceForUnit(self:GetParent(), abs, true)

self:GetParent():EmitSound("Hero_Snapfire.MortimerGrunt")

self:GetAbility():UseResources(false, false, false, true)

end


modifier_snapfire_mortimer_kisses_custom_gobble_caster = class({})
function modifier_snapfire_mortimer_kisses_custom_gobble_caster:IsHidden() return false end
function modifier_snapfire_mortimer_kisses_custom_gobble_caster:IsPurgable() return false end
function modifier_snapfire_mortimer_kisses_custom_gobble_caster:OnCreated(table)
if not IsServer() then return end

self.RemoveForDuel = true

self.target = EntIndexToHScript(table.target)

end

function modifier_snapfire_mortimer_kisses_custom_gobble_caster:GetEffectName()
return "particles/units/heroes/hero_life_stealer/life_stealer_infested_unit_icon.vpcf"
end


function modifier_snapfire_mortimer_kisses_custom_gobble_caster:GetEffectAttachType()
return PATTACH_OVERHEAD_FOLLOW
end


function modifier_snapfire_mortimer_kisses_custom_gobble_caster:OnDestroy()
if not IsServer() then return end 

if self.target and not self.target:IsNull() then 
    self.target:RemoveModifierByName("modifier_snapfire_mortimer_kisses_custom_gobble")
end 

end 





modifier_snapfire_mortimer_kisses_custom_gobble_slow = class({})
function modifier_snapfire_mortimer_kisses_custom_gobble_slow:IsHidden() return false end
function modifier_snapfire_mortimer_kisses_custom_gobble_slow:IsPurgable() return true end

function modifier_snapfire_mortimer_kisses_custom_gobble_slow:OnCreated(table)

self.slow = self:GetAbility():GetSpecialValueFor("move_slow")
end

function modifier_snapfire_mortimer_kisses_custom_gobble_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_snapfire_mortimer_kisses_custom_gobble_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end



modifier_snapfire_mortimer_kisses_custom_scatter = class({})
function modifier_snapfire_mortimer_kisses_custom_scatter:IsHidden() return true end
function modifier_snapfire_mortimer_kisses_custom_scatter:IsPurgable() return false end
function modifier_snapfire_mortimer_kisses_custom_scatter:OnCreated(table)
if not IsServer() then return end

self.timer = self:GetCaster():GetTalentValue("modifier_snapfire_scatter_7", "interval")

self.ability = self:GetParent():FindAbilityByName("snapfire_scatterblast_custom")

if not self.ability or self.ability:GetLevel() == 0 then 
    self:Destroy()
    return
end

self:StartIntervalThink(1)
end


function modifier_snapfire_mortimer_kisses_custom_scatter:OnIntervalThink()
if not IsServer() then return end

local abs = self:GetCaster():GetForwardVector()*10 + self:GetCaster():GetAbsOrigin()

self.ability:OnSpellStart(abs, 1 )

self:StartIntervalThink(self.timer - FrameTime())
end