LinkLuaModifier( "modifier_tinker_laser_custom_tracker", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_laser_custom_blind", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_laser_custom_legendary", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_laser_custom_legendary_caster", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_laser_custom_slow", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_laser_custom_damage_inc", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_laser_custom_stun_stack", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_laser_custom_disarm", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_laser_custom_vision", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_laser_custom_root", "abilities/tinker/tinker_laser_custom", LUA_MODIFIER_MOTION_NONE )

tinker_laser_custom = class({})
tinker_laser_custom.talents = {}

function tinker_laser_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_laser.vpcf", context )
PrecacheResource( "particle", "particles/tinker/laser_legendary_radius.vpcf", context )
PrecacheResource( "particle", "amir4an/particles/heroes/tinker/amir4an_1x6/amir4an_1x6_tinker_laser.vpcf", context )
PrecacheResource( "particle", "particles/tinker/laser_legendary_hit.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
PrecacheResource( "particle", "particles/tinker/laser_stun.vpcf", context )
PrecacheResource( "particle", "particles/laser/stun_stack.vpcf", context )
PrecacheResource( "particle", "particles/tinker/laser_legendary_red.vpcf", context )
end

function tinker_laser_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_tinker_ti10_immortal_laser_custom") then
    return "tinker/tinker_ti10_immortal_ability_icons/tinker_laser_ti10"
end
return "tinker_laser"
end

function tinker_laser_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsCreepHero() then return end
return "modifier_tinker_laser_custom_tracker"
end

function tinker_laser_custom:GetAOERadius()
return self.aoe_radius
end

function tinker_laser_custom:GetBehavior()
local base = self.talents.has_legendary == 1 and DOTA_ABILITY_BEHAVIOR_POINT or DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
return base + DOTA_ABILITY_BEHAVIOR_AOE
end

function tinker_laser_custom:GetCastPoint(iLevel)
return self.BaseClass.GetCastPoint(self) + self.talents.cast_inc
end

function tinker_laser_custom:GetCooldown(iLevel)
return self.BaseClass.GetCooldown(self, iLevel) + self.talents.cd_inc
end

function tinker_laser_custom:GetCastRange(vLocation, hTarget)
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function tinker_laser_custom:GetDamage(target)
local result = self.laser_damage
if target and self.talents.has_damage_inc == 1 then
    if target:IsCreep() then
        result = result + self.talents.damage_creeps
    else
        result = result + target:GetMaxHealth()*self.talents.damage_inc
    end
end
return result
end

function tinker_laser_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()
if caster.items_data_custom and caster.items_data_custom["weapon"] then
    caster.items_data_custom["weapon"]:StartGesture(ACT_DOTA_CAST_ABILITY_1)
end
if caster.other_model_backup and caster.other_model_backup["weapon"] then
    caster.other_model_backup["weapon"]:StartGesture(ACT_DOTA_CAST_ABILITY_1)
end
return true
end

function tinker_laser_custom:OnAbilityPhaseInterrupted()
local caster = self:GetCaster()
if caster.items_data_custom and caster.items_data_custom["weapon"] then
    caster.items_data_custom["weapon"]:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
end
if caster.other_model_backup and caster.other_model_backup["weapon"] then
    caster.other_model_backup["weapon"]:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
end

end

function tinker_laser_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
local point

if self.talents.has_legendary == 1 then
    point = self:GetCursorPosition()
    caster:AddNewModifier(caster, self, "modifier_tinker_laser_custom_legendary_caster", {duration = self.talents.legendary_duration})
    target = CreateModifierThinker(caster, self, "modifier_tinker_laser_custom_legendary", {duration = self.talents.legendary_duration}, point, caster:GetTeamNumber(), false)
else
    if target:TriggerSpellAbsorb(self) then return end
    point = target:GetAbsOrigin()
end

local attachment = (caster:ScriptLookupAttachment("attach_attack2") ~= 0 and self.talents.has_legendary == 0) and "attach_attack2" or "attach_attack1"
local radius = self.aoe_radius
local mod_name = self.talents.has_disarm == 1 and "modifier_tinker_laser_custom_disarm" or "modifier_tinker_laser_custom_blind"
local duration = self.talents.has_disarm == 1 and self.talents.disarm_duration or self.blind_duration
local root_duration = false

local scepter_mod = caster:FindModifierByName("modifier_tinker_innate_custom_scepter")
if scepter_mod then
    scepter_mod:Proc()
    root_duration = scepter_mod.root_duration
end

local particle_name = "particles/units/heroes/hero_tinker/tinker_laser.vpcf"
local sound_start = "Hero_Tinker.Laser"
local sound_impact = "Hero_Tinker.LaserImpact"
if caster:HasModifier("modifier_tinker_ti10_immortal_laser_custom") then
    particle_name = "particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf"
end

local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
if self.talents.has_legendary == 1 then
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetAbsOrigin(), true)
else
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
end
ParticleManager:SetParticleControlEnt(particle, 9, caster, PATTACH_POINT_FOLLOW, attachment, Vector(0, 0, 0), true)
ParticleManager:ReleaseParticleIndex(particle)

caster:EmitSound(sound_start)
target:EmitSound(sound_impact)

local damageTable = {attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self }

for _,enemy in pairs(caster:FindTargets(radius, point)) do
    damageTable.damage = self:GetDamage(enemy)
    damageTable.victim = enemy
    enemy:AddNewModifier(caster, self, mod_name, {duration = (1 - enemy:GetStatusResistance()) * duration})

    if self.talents.has_disarm == 1 then
        enemy:AddNewModifier(caster, self, "modifier_tinker_laser_custom_vision", {duration = self.talents.disarm_vision})
    end

    if root_duration then
        enemy:AddNewModifier(caster, self, "modifier_tinker_laser_custom_root", {duration = (1 - enemy:GetStatusResistance())*root_duration})
    end

    if self.talents.has_slow == 1 then
        enemy:AddNewModifier(caster, self, "modifier_tinker_laser_custom_slow", {duration = self.talents.slow_duration})
    end

    DoDamage(damageTable)

    if self.talents.has_damage_stack == 1 then
        enemy:AddNewModifier(caster, self, "modifier_tinker_laser_custom_damage_inc", {duration = self.talents.damage_duration})
    end

    if self.talents.has_stun == 1 and not enemy:IsDebuffImmune() then
        enemy:AddNewModifier(caster, self, "modifier_tinker_laser_custom_stun_stack", {duration = self.talents.stun_duration})
    end
end

end

function tinker_laser_custom:GetCursor(point)
if not IsServer() then return end
if not IsValid(self.legendary_thinker) then return end

local mod = self.legendary_thinker:FindModifierByName("modifier_tinker_laser_custom_legendary")
if not mod then return end
mod:NewPos(point)
end



modifier_tinker_laser_custom_blind = class({})
function modifier_tinker_laser_custom_blind:IsHidden() return false end
function modifier_tinker_laser_custom_blind:IsPurgable() return true end
function modifier_tinker_laser_custom_blind:OnCreated(params)
self.ability = self:GetAbility()
self.miss_chance = self:GetParent():IsCreep() and self.ability.miss_rate_creeps or self.ability.miss_rate
end

function modifier_tinker_laser_custom_blind:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MISS_PERCENTAGE,
}
end

function modifier_tinker_laser_custom_blind:GetModifierMiss_Percentage(params)
if params.target and params.target:IsBuilding() then return end
return self.miss_chance
end



modifier_tinker_laser_custom_tracker = class(mod_hidden)
function modifier_tinker_laser_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.ability.blind_duration = self.ability:GetSpecialValueFor("duration")
self.ability.laser_damage = self.ability:GetSpecialValueFor("laser_damage")
self.ability.aoe_radius = self.ability:GetSpecialValueFor("radius")
self.ability.miss_rate = self.ability:GetSpecialValueFor("miss_rate")
self.ability.miss_rate_creeps = self.ability:GetSpecialValueFor("miss_rate_creeps")

self.ability.talents =
{
    cast_bonus = 0,
    mana_bonus = 0,

    has_damage_inc = 0,
    damage_inc = 0,
    damage_creeps = 0,

    has_slow = 0,
    slow = 0,
    damage_reduce = 0,
    slow_duration = self.parent:GetTalentValue("modifier_tinker_laser_2", "duration", true),

    has_damage_stack = 0,
    heal = 0,
    heal_creeps = self.parent:GetTalentValue("modifier_tinker_laser_3", "heal_creeps", true),
    damage_stack = 0,
    damage_max = self.parent:GetTalentValue("modifier_tinker_laser_3", "max", true),
    damage_duration = self.parent:GetTalentValue("modifier_tinker_laser_3", "duration", true),

    has_stun = 0,
    cd_inc = 0,
    cast_inc = 0,
    stun = self.parent:GetTalentValue("modifier_tinker_laser_4", "stun", true),
    stun_max = self.parent:GetTalentValue("modifier_tinker_laser_4", "max", true),
    stun_duration = self.parent:GetTalentValue("modifier_tinker_laser_4", "duration", true),

    has_disarm = 0,
    disarm_duration = self.parent:GetTalentValue("modifier_tinker_hero_5", "disarm", true),
    disarm_health = self.parent:GetTalentValue("modifier_tinker_hero_5", "health", true),
    disarm_vision = self.parent:GetTalentValue("modifier_tinker_hero_5", "duration", true),

    has_legendary = 0,
    legendary_duration = self.parent:GetTalentValue("modifier_tinker_laser_7", "duration", true),
    legendary_interval = self.parent:GetTalentValue("modifier_tinker_laser_7", "interval", true),
    legendary_damage_min = self.parent:GetTalentValue("modifier_tinker_laser_7", "damage_min", true),
    legendary_damage_max = self.parent:GetTalentValue("modifier_tinker_laser_7", "damage_max", true),
    legendary_radius = self.parent:GetTalentValue("modifier_tinker_laser_7", "radius", true),
    legendary_speed = self.parent:GetTalentValue("modifier_tinker_laser_7", "speed", true),
    legendary_range = self.parent:GetTalentValue("modifier_tinker_laser_7", "range", true),
}

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_tinker_laser_custom_tracker:OnRefresh(table)
self.ability.laser_damage = self.ability:GetSpecialValueFor("laser_damage")
self.ability.blind_duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_tinker_laser_custom_tracker:UpdateTalent(name)

if name == "modifier_tinker_hero_1" or self.parent:HasTalent("modifier_tinker_hero_1") then
    self.ability.talents.cast_bonus = self.parent:GetTalentValue("modifier_tinker_hero_1", "range")
    self.ability.talents.mana_bonus = self.parent:GetTalentValue("modifier_tinker_hero_1", "mana")
end

if name == "modifier_tinker_laser_1" or self.parent:HasTalent("modifier_tinker_laser_1") then
    self.ability.talents.has_damage_inc = 1
    self.ability.talents.damage_inc = self.parent:GetTalentValue("modifier_tinker_laser_1", "damage")/100
    self.ability.talents.damage_creeps = self.parent:GetTalentValue("modifier_tinker_laser_1", "creeps")
end

if name == "modifier_tinker_laser_2" or self.parent:HasTalent("modifier_tinker_laser_2") then
    self.ability.talents.has_slow = 1
    self.ability.talents.slow = self.parent:GetTalentValue("modifier_tinker_laser_2", "slow")
    self.ability.talents.damage_reduce = self.parent:GetTalentValue("modifier_tinker_laser_2", "damage_reduce")
end

if name == "modifier_tinker_laser_3" or self.parent:HasTalent("modifier_tinker_laser_3") then
    self.ability.talents.has_damage_stack = 1
    self.ability.talents.damage_stack = self.parent:GetTalentValue("modifier_tinker_laser_3", "damage")
    self.ability.talents.heal = self.parent:GetTalentValue("modifier_tinker_laser_3", "heal")/100
    self.parent:AddDamageEvent_out(self, true)
end

if name == "modifier_tinker_laser_4" or self.parent:HasTalent("modifier_tinker_laser_4") then
    self.ability.talents.has_stun = 1
    self.ability.talents.cd_inc = self.parent:GetTalentValue("modifier_tinker_laser_4", "cd")
    self.ability.talents.cast_inc = self.parent:GetTalentValue("modifier_tinker_laser_4", "cast")
end

if name == "modifier_tinker_hero_5" or self.parent:HasTalent("modifier_tinker_hero_5") then
    self.ability.talents.has_disarm = 1
end

if name == "modifier_tinker_laser_7" or self.parent:HasTalent("modifier_tinker_laser_7") then
    self.ability.talents.has_legendary = 1
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_tinker_laser_custom_tracker:AddCustomTransmitterData() 
return self.ability.talents
end

function modifier_tinker_laser_custom_tracker:HandleCustomTransmitterData(data)
if not self.ability then return end
self.ability.talents = data
end

function modifier_tinker_laser_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end

function modifier_tinker_laser_custom_tracker:GetModifierCastRangeBonusStacking()
return self.ability.talents.cast_bonus
end

function modifier_tinker_laser_custom_tracker:GetModifierPercentageManacostStacking()
return self.ability.talents.mana_bonus
end

function modifier_tinker_laser_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if self.ability.talents.has_damage_stack == 0 then return end
if not self.parent:CheckLifesteal(params, 1) then return end

local heal = params.damage*self.ability.talents.heal
if params.unit:IsCreep() then
    heal = heal/self.ability.talents.heal_creeps
end

self.parent:GenericHeal(heal, self.ability, true, "particles/items3_fx/octarine_core_lifesteal.vpcf", "modifier_tinker_laser_3")
end



modifier_tinker_laser_custom_legendary = class(mod_hidden)
function modifier_tinker_laser_custom_legendary:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.range = self.ability.talents.legendary_range + self.caster:GetCastRangeBonus()
self.min_range = 150

self.radius = self.ability.talents.legendary_radius
self.damage_min = self.ability.talents.legendary_damage_min
self.damage_max = self.ability.talents.legendary_damage_max
self.duration = self.ability.talents.legendary_duration

if not IsServer() then return end
self.parent:EmitSound("Tinker.Laser_legendary_cast2")

self.ability.legendary_thinker = self.parent
self.player = PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID())
self.new_pos = self.parent:GetAbsOrigin()

self.attachment = "attach_attack1"
self.attachment_id = self.caster:ScriptLookupAttachment(self.attachment)

self.damage_interval = self.ability.talents.legendary_interval
self.speed = self.ability.talents.legendary_speed

self.interavl = 0.03

self.damage_count = 0

self.damage_stack = self.damage_min
self.damageTable = {attacker = self.caster, ability = self.ability, damage_type = DAMAGE_TYPE_PURE}

local particle_name = self.caster:HasModifier("modifier_tinker_ti10_immortal_laser_custom") and "particles/tinker/laser_legendary_red.vpcf" or "amir4an/particles/heroes/tinker/amir4an_1x6/amir4an_1x6_tinker_laser.vpcf"
local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, self.caster)
ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
ParticleManager:SetParticleControlEnt(particle, 9, self.caster, PATTACH_POINT_FOLLOW, self.attachment, Vector(0, 0, 0), true)
self:AddParticle(particle, false, false, -1, false, false)

self:OnIntervalThink()
self:StartIntervalThink(self.interavl)
end

function modifier_tinker_laser_custom_legendary:OnIntervalThink()
if not IsServer() then return end
if not self.caster:IsAlive() or not self.caster:HasModifier("modifier_tinker_laser_custom_legendary_caster") then
    self:Destroy()
    return
end

if self.caster:IsStunned() or self.caster:IsHexed() or self.caster:GetForceAttackTarget() ~= nil or self.caster:IsFeared() then 
    return
end

CustomGameEventManager:Send_ServerToPlayer(self.player, "get_cursor_position", {ability = "tinker_laser_custom"}) 

self.damage_stack = self.damage_min + (self.damage_max - self.damage_min)*(self:GetElapsedTime()/self.duration)
self.caster:UpdateUIshort({max_time = self.duration, time = self:GetElapsedTime(), stack = math.floor(self.damage_stack).."%", priority = 1, style = "TinkerLaser"})

local vec = self.new_pos - self.parent:GetAbsOrigin()
if vec:Length2D() > 25 then
    local new_point = GetGroundPosition((self.parent:GetAbsOrigin() + vec:Normalized()*self.speed*self.interavl), nil)
    self.parent:SetAbsOrigin(new_point)

    local dir = (new_point - self.caster:GetAbsOrigin()):Normalized()
    dir.z = 0

    self.caster:FaceTowards(new_point)
    self.caster:SetForwardVector(dir)
end

self.damage_count = self.damage_count + self.interavl

if self.damage_count >= self.damage_interval then
    self.damage_count = 0

    local enemies = FindUnitsInLine(self.caster:GetTeamNumber(), self.caster:GetAttachmentOrigin(self.attachment_id), self.parent:GetAbsOrigin(), self.caster, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)
    for _,enemy in pairs(enemies) do
        self.damageTable.victim = enemy
        self.damageTable.damage = self.ability:GetDamage(enemy)*self.damage_stack*self.damage_interval/100

        local particle = ParticleManager:CreateParticle("particles/tinker/laser_legendary_hit.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, enemy)
        ParticleManager:SetParticleControlEnt(particle, 0, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
        ParticleManager:ReleaseParticleIndex(particle)

        enemy:EmitSound("Tinker.Laser_legendary_hit")
        self.caster:AddNewModifier(enemy, nil, "modifier_generic_vision", {duration = self.damage_interval*3})
        DoDamage(self.damageTable, "modifier_tinker_laser_7")

        if self.ability.talents.has_slow == 1 then
            enemy:AddNewModifier(self.caster, self.ability, "modifier_tinker_laser_custom_slow", {duration = self.ability.talents.slow_duration})
        end
    end
end

end

function modifier_tinker_laser_custom_legendary:NewPos(point)
if not IsServer() then return end
local new_point = point
local vec = point - self.caster:GetAbsOrigin()
if vec:Length2D() >= self.range then
    new_point = self.caster:GetAbsOrigin() + vec:Normalized()*self.range
elseif vec:Length2D() < self.min_range then
    new_point = self.caster:GetAbsOrigin() + vec:Normalized()*self.min_range
end

self.new_pos = GetGroundPosition(new_point, nil)
end

function modifier_tinker_laser_custom_legendary:OnDestroy()
if not IsServer() then return end
self.ability.legendary_thinker = nil
self.caster:RemoveModifierByName("modifier_tinker_laser_custom_legendary_caster")

self.parent:StopSound("Tinker.Laser_legendary_cast2")
self.caster:UpdateUIshort({hide = 1, priority = 1, style = "TinkerLaser"})
end


modifier_tinker_laser_custom_legendary_caster = class(mod_hidden)
function modifier_tinker_laser_custom_legendary_caster:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.range = self.ability.talents.legendary_range + self.parent:GetCastRangeBonus()
if not IsServer() then return end
self.parent:EmitSound("Tinker.Laser_legendary_cast")
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_GENERIC_CHANNEL_1, 0.75)

self.parent:AddOrderEvent(self)
AddFOWViewer(self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), self.range, self:GetRemainingTime(), false)

self.radius_visual = ParticleManager:CreateParticleForPlayer("particles/tinker/laser_legendary_radius.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.parent:GetPlayerOwner())
ParticleManager:SetParticleControl(self.radius_visual, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.radius_visual, 1, Vector(self.range, 0, 0))
self:AddParticle(self.radius_visual, false, false, -1, false, false)
end

function modifier_tinker_laser_custom_legendary_caster:CheckState()
return
{
    [MODIFIER_STATE_SILENCED] = true,
    [MODIFIER_STATE_DISARMED] = true
}
end

function modifier_tinker_laser_custom_legendary_caster:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_DISABLE_TURNING,
    MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
    MODIFIER_PROPERTY_MOVESPEED_LIMIT
}
end

function modifier_tinker_laser_custom_legendary_caster:GetModifierDisableTurning()
return 1
end

function modifier_tinker_laser_custom_legendary_caster:GetModifierIgnoreCastAngle()
return 1
end

function modifier_tinker_laser_custom_legendary_caster:GetModifierMoveSpeed_Limit()
return 0.1
end

function modifier_tinker_laser_custom_legendary_caster:OrderEvent(params)
if not IsServer() then return end
if params.order_type ~= DOTA_UNIT_ORDER_STOP and params.order_type ~= DOTA_UNIT_ORDER_HOLD_POSITION then return end
self:Destroy()
end


function modifier_tinker_laser_custom_legendary_caster:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Tinker.Laser_legendary_cast")
self.parent:FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end


modifier_tinker_laser_custom_slow = class(mod_hidden)
function modifier_tinker_laser_custom_slow:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.damage_reduce = self.ability.talents.damage_reduce
self.slow  = self.ability.talents.slow
if not IsServer() then return end
self.parent:GenericParticle("particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", self)
end

function modifier_tinker_laser_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_tinker_laser_custom_slow:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end

function modifier_tinker_laser_custom_slow:GetModifierSpellAmplify_Percentage()
return self.damage_reduce
end

function modifier_tinker_laser_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


modifier_tinker_laser_custom_damage_inc = class(mod_visible)
function modifier_tinker_laser_custom_damage_inc:GetTexture() return "buffs/tinker/laser_3" end
function modifier_tinker_laser_custom_damage_inc:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.max = self.ability.talents.damage_max
self.damage = self.ability.talents.damage_stack

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_tinker_laser_custom_damage_inc:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end


function modifier_tinker_laser_custom_damage_inc:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_tinker_laser_custom_damage_inc:GetModifierIncomingDamage_Percentage(params)
return self:GetStackCount()*self.damage
end



modifier_tinker_laser_custom_stun_stack = class(mod_hidden)
function modifier_tinker_laser_custom_stun_stack:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.max = self.ability.talents.stun_max
self.stun = self.ability.talents.stun

if not IsServer() then return end
self.particle = self.parent:GenericParticle("particles/laser/stun_stack.vpcf", self, true)

self:SetStackCount(1)
end

function modifier_tinker_laser_custom_stun_stack:OnRefresh()
if not IsServer() then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
    local mod = self.parent:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = (1 - self.parent:GetStatusResistance())*self.stun})
    self.parent:EmitSound("Tinker.Laser_stun")
    if mod then
        self.parent:GenericParticle("particles/tinker/laser_stun.vpcf", mod)
    end
    self:Destroy()
end

end

function modifier_tinker_laser_custom_stun_stack:OnStackCountChanged(iStackCount)
if not self.particle then return end
ParticleManager:SetParticleControl( self.particle, 1, Vector( 0, self:GetStackCount(), 0 ) )
end

modifier_tinker_laser_custom_disarm = class(mod_hidden)
function modifier_tinker_laser_custom_disarm:IsPurgable() return true end
function modifier_tinker_laser_custom_disarm:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.particle = self.parent:GenericParticle("particles/zeus/bolt_disarm.vpcf", self, true)
end

function modifier_tinker_laser_custom_disarm:CheckState()
return
{
    [MODIFIER_STATE_DISARMED] = true
}
end


modifier_tinker_laser_custom_vision = class(mod_visible)
function modifier_tinker_laser_custom_vision:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.health = self.ability.talents.disarm_health
if not IsServer() then return end
if not self.parent:IsHero() then return end

self.interval = 0.2
self:StartIntervalThink(self.interval)
end

function modifier_tinker_laser_custom_vision:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer(self.caster:GetTeamNumber(), self.parent:GetAbsOrigin(), 10, self.interval*2, false)
end

function modifier_tinker_laser_custom_vision:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
}
end

function modifier_tinker_laser_custom_vision:GetModifierExtraHealthPercentage()
return self.health
end

modifier_tinker_laser_custom_root = class(mod_hidden)
function modifier_tinker_laser_custom_root:IsPurgable() return true end
function modifier_tinker_laser_custom_root:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.particle = self.parent:GenericParticle("particles/tinker/laser_stun.vpcf", self)
end

function modifier_tinker_laser_custom_root:CheckState()
return
{
    [MODIFIER_STATE_ROOTED] = true
}
end