LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom_tracker", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom_legendary_stack", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom_perma", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom_slow", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom_regen", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom_haste", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom_heal_reduce", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom_silence", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_march_of_the_machines_custom_silence_cd", "abilities/tinker/tinker_march_of_the_machines_custom", LUA_MODIFIER_MOTION_NONE )

tinker_march_of_the_machines_custom = class({})
tinker_march_of_the_machines_custom.talents = {}

function tinker_march_of_the_machines_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_motm.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_machine.vpcf", context )
PrecacheResource( "particle", "particles/tinker/march_legendary_stack.vpcf", context )
PrecacheResource( "particle", "particles/tinker/march_legendary_robot.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
PrecacheResource( "particle", "particles/tinker/scepter_proc.vpcf", context )
PrecacheResource( "particle", "particles/econ/events/ti10/phase_boots_ti10.vpcf", context )
PrecacheResource( "particle", "amir4an/particles/heroes/tinker/amir4an_1x6/amir4an_1x6_tinker_march_ambient.vpcf", context )
end

function tinker_march_of_the_machines_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_tinker_roller_mawster_custom") then
    return "tinker/rollermawster/tinker_march_of_the_machines_1"
end
return "tinker_march_of_the_machines"
end

function tinker_march_of_the_machines_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsCreepHero() then return end
return "modifier_tinker_march_of_the_machines_custom_tracker"
end

function tinker_march_of_the_machines_custom:GetBehavior()
local bonus = self.talents.has_legendary == 1 and DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING or 0
return bonus + DOTA_ABILITY_BEHAVIOR_POINT
end

function tinker_march_of_the_machines_custom:GetCastRange(vLocation, hTarget)
if self.talents.has_legendary == 1 then
    return self.talents.legendary_range
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function tinker_march_of_the_machines_custom:GetCastPoint(iLevel)
return self.BaseClass.GetCastPoint(self) + self.talents.cast_inc
end

function tinker_march_of_the_machines_custom:OnVectorCastStart(vStartLocation, vDirection)
if self.talents.has_legendary == 0 then return end
self:Cast(vStartLocation, vDirection)
end

function tinker_march_of_the_machines_custom:OnSpellStart()
if self.talents.has_legendary == 1 then return end
self:Cast(self:GetCursorPosition())
end

function tinker_march_of_the_machines_custom:Cast(cast_point, dir)
local caster = self:GetCaster()
local point = cast_point

if caster:GetAbsOrigin() == point then
    point = caster:GetAbsOrigin() + caster:GetForwardVector()*15
end

local direction = (point - caster:GetOrigin()):Normalized()
if dir then
    direction = dir
end
direction.z = 0

local duration = self.duration + self.talents.duration_inc

if self.talents.has_legendary == 0 then
    point = point - direction * self.distance/2
else
    self.radius = self.talents.legendary_width
    point = point - direction*200
    AddFOWViewer(caster:GetTeamNumber(), point, self.radius*2, duration, false)
end

local particle_name = "particles/units/heroes/hero_tinker/tinker_motm.vpcf"
local sound_name = "Hero_Tinker.March_of_the_Machines.Cast"
if caster:HasModifier("modifier_tinker_roller_mawster_custom") then
    particle_name = "particles/econ/items/tinker/tinker_motm_rollermaw/tinker_rollermaw_motm.vpcf"
    sound_name = "Hero_Tinker.March_of_the_Machines.Cast.Rollermawster"
end

local particle = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetOrigin(),  true)
ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_ABSORIGIN, nil, caster:GetOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

EmitSoundOnLocationForAllies(caster:GetOrigin(), sound_name, caster)

local use_legendary = 0
local legendary_mod = caster:FindModifierByName("modifier_tinker_march_of_the_machines_custom_legendary_stack")
if legendary_mod and legendary_mod:GetStackCount() >= self.talents.legendary_max then
    legendary_mod:Destroy()
    use_legendary = 1
end

local scepter_mod = caster:FindModifierByName("modifier_tinker_innate_custom_scepter")
if scepter_mod then
    scepter_mod:Proc()
    self:EndCooldown()
    self:StartCooldown(0.2)
end

caster:AddNewModifier(caster, self, "modifier_can_not_push", {duration = duration})
CreateModifierThinker(caster, self, "modifier_tinker_march_of_the_machines_custom", {x = direction.x, y = direction.y, legendary = use_legendary, duration = duration}, GetGroundPosition(point, nil), caster:GetTeamNumber(), false)
end


function tinker_march_of_the_machines_custom:OnProjectileHit_ExtraData(target, location, extraData)
if not target then return true end

local caster = self:GetCaster()

if target == caster then
    if self.talents.has_regen == 1 then
        caster:AddNewModifier(caster, self, "modifier_tinker_march_of_the_machines_custom_regen", {duration = self.talents.regen_duration})
    end
    if self.talents.has_haste == 1 then
        caster:AddNewModifier(caster, self, "modifier_tinker_march_of_the_machines_custom_haste", {duration = self.talents.haste_duration})
    end
    return false
end

if target:GetTeamNumber() == caster:GetTeamNumber() then return false end

local damage = self.damage
local radius = self.splash_radius
local damage_ability = nil

local perma_mod = caster:FindModifierByName("modifier_tinker_march_of_the_machines_custom_perma")
if perma_mod and self.talents.has_perma == 1 then
    damage = damage + perma_mod:GetStackCount()*self.talents.perma_damage
end

if extraData.is_legendary == 1 then
    radius = self.talents.legendary_damage_radius
    damage = damage*self.talents.legendary_damage
    damage_ability = "modifier_tinker_march_7"

    EmitSoundOnLocationWithCaster(location, "Tinker.March_legendary_explosion", caster)
    EmitSoundOnLocationWithCaster(location, "Tinker.March_legendary_explosion2", caster)

    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( nFXIndex, 0, location )
    ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.0, 1.0, radius ) )
    ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, 1.0, radius ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex )
end

if extraData.is_auto and extraData.is_auto == 1 then
    damage_ability = "modifier_tinker_march_3"
end

local damageTable = {attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self}
local enemies = caster:FindTargets(radius, location)
for _, enemy in ipairs(enemies) do
    damageTable.victim = enemy
    if enemy:IsRealHero() then
        caster:AddNewModifier(caster, self, "modifier_tinker_march_of_the_machines_custom_perma", {})
        if self.talents.has_legendary == 1 then
            caster:AddNewModifier(caster, self, "modifier_tinker_march_of_the_machines_custom_legendary_stack", {duration = self.talents.legendary_duration})
        end
        if caster:GetQuest() == "Tinker.Quest_6" and not caster:QuestCompleted() then
            caster:UpdateQuest(1)
        end
    end
    if self.talents.has_slow == 1 then
        if not enemy:HasModifier("modifier_tinker_march_of_the_machines_custom_silence_cd") and not enemy:IsDebuffImmune() then
            enemy:EmitSound("SF.Raze_silence")
            enemy:AddNewModifier(caster, self, "modifier_tinker_march_of_the_machines_custom_silence", {duration = (1 - enemy:GetStatusResistance())*self.talents.slow_silence})
            enemy:AddNewModifier(caster, self, "modifier_tinker_march_of_the_machines_custom_silence_cd", {duration = self.talents.slow_cd})
        end
        enemy:AddNewModifier(caster, self, "modifier_tinker_march_of_the_machines_custom_slow", {duration = self.talents.slow_duration})
    end
    if self.talents.has_auto == 1 then
        enemy:AddNewModifier(caster, self, "modifier_tinker_march_of_the_machines_custom_heal_reduce", {duration = self.talents.heal_reduce_duration})
    end
    if extraData.is_legendary == 1 then
        enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self.talents.legendary_stun})
    end
    DoDamage(damageTable, damage_ability)
end

return true
end



modifier_tinker_march_of_the_machines_custom = class(mod_hidden)
function modifier_tinker_march_of_the_machines_custom:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not IsServer() then return end

self.use_legendary = table.legendary
self.is_auto = (table.is_auto and table.is_auto == 1) and 1 or 0
self.auto_count = 0

local speed = self.ability.speed*(1 + self.ability.talents.speed_inc)
local interval = 1/self.ability.machines_per_sec
self.collision_radius = self.ability.collision_radius 
self.spawn_radius = self.ability.radius

if self.is_auto == 1 then
    self.spawn_radius = 35
    interval = self.ability.talents.auto_interval
    speed = self.ability.speed*self.ability.talents.auto_speed
end

local direction = Vector(table.x, table.y, 0)

self.parent:SetForwardVector(direction)
self.centerSpawn = self.parent:GetOrigin()
self.centerVector = self.parent:GetLeftVector()

local team = DOTA_UNIT_TARGET_TEAM_ENEMY
if self.ability.talents.has_regen == 1 or self.ability.talents.has_haste == 1 then
    team = DOTA_UNIT_TARGET_TEAM_BOTH
end

self.projectileInfo = 
{
    Source = self.caster,
    Ability = self.ability,
    iUnitTargetTeam = team,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    fDistance = self.ability.distance,
    vVelocity = direction * speed,
    ExtraData = {}
}

self.effect_name = "particles/units/heroes/hero_tinker/tinker_machine.vpcf"
if self.caster:HasModifier("modifier_tinker_roller_mawster_custom") then
    self.effect_name = "particles/econ/items/tinker/tinker_motm_rollermaw/tinker_rollermaw.vpcf"
end

self:OnIntervalThink()
self:StartIntervalThink(interval)

self.parent:EmitSound("Hero_Tinker.March_of_the_Machines")
end

function modifier_tinker_march_of_the_machines_custom:OnIntervalThink()
if not IsServer() then return end
local spawn = self.centerSpawn + self.centerVector * RandomInt(-self.spawn_radius, self.spawn_radius)
local effect_name = self.effect_name

local data = {}
data.is_legendary = 0

local width = self.collision_radius

if self.use_legendary == 1 then
    self.use_legendary = 0
    data.is_legendary = 1
    effect_name = "amir4an/particles/heroes/tinker/amir4an_1x6/amir4an_1x6_tinker_march_ambient.vpcf"
    spawn = self.centerSpawn + self.centerVector
    width = self.ability.talents.legendary_hit_radius
    EmitSoundOnLocationWithCaster(spawn, "Tinker.March_legendary_start", self.caster)
end

if self.is_auto == 1 then
    self.auto_count = self.auto_count + 1
    data.is_auto = 1
end

self.projectileInfo.fStartRadius = width
self.projectileInfo.fEndRadius = width
self.projectileInfo.ExtraData = data
self.projectileInfo.vSpawnOrigin = spawn
self.projectileInfo.EffectName = effect_name
ProjectileManager:CreateLinearProjectile(self.projectileInfo)

if self.is_auto == 1 and self.auto_count >= self.ability.talents.auto_count then
    self:Destroy()
    return
end

end

function modifier_tinker_march_of_the_machines_custom:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Hero_Tinker.March_of_the_Machines")
UTIL_Remove(self.parent)
end

function modifier_tinker_march_of_the_machines_custom:CheckState()
return
{
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end


modifier_tinker_march_of_the_machines_custom_tracker = class(mod_hidden)
function modifier_tinker_march_of_the_machines_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.visual_max = 5

self.ability.damage = self.ability:GetSpecialValueFor("damage")
self.ability.duration = self.ability:GetSpecialValueFor("duration")
self.ability.radius = self.ability:GetSpecialValueFor("radius")
self.ability.splash_radius = self.ability:GetSpecialValueFor("splash_radius")
self.ability.distance = self.ability:GetSpecialValueFor("distance")
self.ability.speed = self.ability:GetSpecialValueFor("speed")
self.ability.machines_per_sec = self.ability:GetSpecialValueFor("machines_per_sec")
self.ability.collision_radius = self.ability:GetSpecialValueFor("collision_radius")

self.ability.talents =
{
    has_regen = 0,
    regen_max = self.parent:GetTalentValue("modifier_tinker_hero_2", "max", true),
    regen_duration = self.parent:GetTalentValue("modifier_tinker_hero_2", "duration", true),
    regen_health = 0,
    regen_armor = 0,

    has_perma = 0,
    perma_damage = 0,
    perma_max = self.parent:GetTalentValue("modifier_tinker_march_1", "max", true),

    duration_inc = 0,
    speed_inc = 0,

    has_auto = 0,
    auto_count = 0,
    heal_reduce = 0,
    auto_range = self.parent:GetTalentValue("modifier_tinker_march_3", "range", true),
    auto_interval = self.parent:GetTalentValue("modifier_tinker_march_3", "interval", true),
    auto_speed = self.parent:GetTalentValue("modifier_tinker_march_3", "speed", true),
    heal_reduce_max = self.parent:GetTalentValue("modifier_tinker_march_3", "max", true),
    heal_reduce_duration = self.parent:GetTalentValue("modifier_tinker_march_3", "duration", true),

    has_slow = 0,
    slow_duration = self.parent:GetTalentValue("modifier_tinker_march_4", "duration", true),
    slow_move = self.parent:GetTalentValue("modifier_tinker_march_4", "slow", true),
    slow_bonus = self.parent:GetTalentValue("modifier_tinker_march_4", "bonus", true),
    slow_silence = self.parent:GetTalentValue("modifier_tinker_march_4", "silence", true),
    slow_cd = self.parent:GetTalentValue("modifier_tinker_march_4", "cd", true),

    has_haste = 0,
    cast_inc = 0,
    haste_duration = self.parent:GetTalentValue("modifier_tinker_hero_6", "duration", true),
    haste_speed = self.parent:GetTalentValue("modifier_tinker_hero_6", "speed", true),

    has_legendary = 0,
    legendary_range = self.parent:GetTalentValue("modifier_tinker_march_7", "range", true),
    legendary_width = self.parent:GetTalentValue("modifier_tinker_march_7", "width", true),
    legendary_radius = self.parent:GetTalentValue("modifier_tinker_march_7", "radius", true),
    legendary_max = self.parent:GetTalentValue("modifier_tinker_march_7", "max", true),
    legendary_duration = self.parent:GetTalentValue("modifier_tinker_march_7", "duration", true),
    legendary_damage = self.parent:GetTalentValue("modifier_tinker_march_7", "damage", true),
    legendary_stun = self.parent:GetTalentValue("modifier_tinker_march_7", "stun", true),
    legendary_damage_radius = self.parent:GetTalentValue("modifier_tinker_march_7", "damage_radius", true),
    legendary_hit_radius = self.parent:GetTalentValue("modifier_tinker_march_7", "hit_radius", true),
}

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_tinker_march_of_the_machines_custom_tracker:OnRefresh()
self.ability.damage = self.ability:GetSpecialValueFor("damage")
end


function modifier_tinker_march_of_the_machines_custom_tracker:UpdateTalent(name)

if name == "modifier_tinker_hero_2" or self.parent:HasTalent("modifier_tinker_hero_2") then
    self.ability.talents.has_regen = 1
    self.ability.talents.regen_health = self.parent:GetTalentValue("modifier_tinker_hero_2", "health")/self.ability.talents.regen_max
    self.ability.talents.regen_armor = self.parent:GetTalentValue("modifier_tinker_hero_2", "armor")/self.ability.talents.regen_max
end

if name == "modifier_tinker_hero_6" or self.parent:HasTalent("modifier_tinker_hero_6") then
    self.ability.talents.has_haste = 1
    self.ability.talents.cast_inc = self.parent:GetTalentValue("modifier_tinker_hero_6", "cast")
end

if name == "modifier_tinker_march_1" or self.parent:HasTalent("modifier_tinker_march_1") then
    self.ability.talents.has_perma = 1
    self.ability.talents.perma_damage = self.parent:GetTalentValue("modifier_tinker_march_1", "damage")/self.ability.talents.perma_max
end

if name == "modifier_tinker_march_2" or self.parent:HasTalent("modifier_tinker_march_2") then
    self.ability.talents.duration_inc = self.parent:GetTalentValue("modifier_tinker_march_2", "duration")
    self.ability.talents.speed_inc = self.parent:GetTalentValue("modifier_tinker_march_2", "speed")/100
end

if name == "modifier_tinker_march_3" or self.parent:HasTalent("modifier_tinker_march_3") then
    self.ability.talents.has_auto = 1
    self.ability.talents.auto_count = self.parent:GetTalentValue("modifier_tinker_march_3", "count")
    self.ability.talents.heal_reduce = self.parent:GetTalentValue("modifier_tinker_march_3", "heal_reduce")/self.ability.talents.heal_reduce_max
    self.parent:AddSpellEvent(self, true)
end

if name == "modifier_tinker_march_4" or self.parent:HasTalent("modifier_tinker_march_4") then
    self.ability.talents.has_slow = 1
end

if name == "modifier_tinker_march_7" or self.parent:HasTalent("modifier_tinker_march_7") then
    self.ability.talents.has_legendary = 1
    if IsServer() then
        self.ability:UpdateVectorValues()
        self:UpdateUI()
    end
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_tinker_march_of_the_machines_custom_tracker:AddCustomTransmitterData() 
return self.ability.talents
end

function modifier_tinker_march_of_the_machines_custom_tracker:HandleCustomTransmitterData(data)
if not self.ability then return end
self.ability.talents = data
end

function modifier_tinker_march_of_the_machines_custom_tracker:UpdateUI()
if not IsServer() then return end

local stack = 0
local active = 0
local max = self.ability.talents.legendary_max

local mod = self.parent:FindModifierByName("modifier_tinker_march_of_the_machines_custom_legendary_stack")

if mod then
  stack = mod:GetStackCount()
  if mod:GetStackCount() >= self.ability.talents.legendary_max then
    active = 1
  end
  if self.particle then
    ParticleManager:DestroyParticle(self.particle, true)
    ParticleManager:ReleaseParticleIndex(self.particle)
    self.particle = nil
  end
else
  if not self.particle then
    self.particle = self.parent:GenericParticle("particles/tinker/march_legendary_stack.vpcf", self, true)
    for i = 1,self.visual_max do 
      ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
    end
  end
end

self.parent:UpdateUIlong({stack = stack, max = max, active = active, style = "TinkerMarch"})
end

function modifier_tinker_march_of_the_machines_custom_tracker:SpellEvent(params)
if not IsServer() then return end
if self.ability.talents.has_auto == 0 then return end
if self.parent ~= params.unit then return end
if params.ability:IsItem() then return end

local direction = self.parent:GetForwardVector()
local target = self.parent:RandomTarget(self.ability.talents.auto_range)
if target then
    direction = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
end

CreateModifierThinker(self.parent, self.ability, "modifier_tinker_march_of_the_machines_custom", {x = direction.x, y = direction.y, legendary = 0, is_auto = 1, duration = 1}, self.parent:GetAbsOrigin(), self.parent:GetTeamNumber(), false)
end


modifier_tinker_march_of_the_machines_custom_legendary_stack = class(mod_hidden)
function modifier_tinker_march_of_the_machines_custom_legendary_stack:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.max = self.ability.talents.legendary_max
self.radius = self.ability.talents.legendary_radius
self.duration = self.ability.talents.legendary_duration

if not IsServer() then return end
self.RemoveForDuel = true
self.mod = self.parent:FindModifierByName("modifier_tinker_march_of_the_machines_custom_tracker")

self.visual_max = 5
self.particle = self.parent:GenericParticle("particles/tinker/march_legendary_stack.vpcf", self, true)

self:SetStackCount(1)
self:StartIntervalThink(0.3)
end

function modifier_tinker_march_of_the_machines_custom_legendary_stack:OnIntervalThink()
if not IsServer() then return end
local targets = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )

if #targets > 0 then
  self:SetDuration(self.duration, true)
end

end

function modifier_tinker_march_of_the_machines_custom_legendary_stack:OnRefresh(params)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_tinker_march_of_the_machines_custom_legendary_stack:OnStackCountChanged()
if not IsServer() then return end

if self.mod then
  self.mod:UpdateUI()
end

if not self.particle then return end

for i = 1,self.visual_max do 
  if i <= math.floor(self:GetStackCount()/(self.max/self.visual_max)) then 
    ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0)) 
  else 
    ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0)) 
  end
end

end

function modifier_tinker_march_of_the_machines_custom_legendary_stack:OnDestroy()
if not IsServer() then return end
if not self.mod then return end
self.mod:UpdateUI()
end


modifier_tinker_march_of_the_machines_custom_perma = class({})
function modifier_tinker_march_of_the_machines_custom_perma:IsHidden() return self.ability.talents.has_perma == 0 or self:GetStackCount() >= self.ability.talents.perma_max end
function modifier_tinker_march_of_the_machines_custom_perma:IsPurgable() return false end
function modifier_tinker_march_of_the_machines_custom_perma:RemoveOnDeath() return false end
function modifier_tinker_march_of_the_machines_custom_perma:GetTexture() return "buffs/tinker/march_1" end
function modifier_tinker_march_of_the_machines_custom_perma:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(1)
end

function modifier_tinker_march_of_the_machines_custom_perma:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.ability.talents.perma_max then return end 
self:IncrementStackCount()
end

function modifier_tinker_march_of_the_machines_custom_perma:OnIntervalThink()
if not IsServer() then return end 
if self.ability.talents.has_perma == 0 then return end
if self:GetStackCount() < self.ability.talents.perma_max then return end

self.parent:GenericParticle("particles/tinker/scepter_proc.vpcf")

self.parent:EmitSound("BS.Thirst_legendary_active")
self:StartIntervalThink(-1)
end 

function modifier_tinker_march_of_the_machines_custom_perma:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_tinker_march_of_the_machines_custom_perma:OnTooltip() 
return self.ability.talents.perma_damage*self:GetStackCount()
end


modifier_tinker_march_of_the_machines_custom_regen = class(mod_visible)
function modifier_tinker_march_of_the_machines_custom_regen:GetTexture() return "buffs/tinker/hero_2" end
function modifier_tinker_march_of_the_machines_custom_regen:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.health = self.ability.talents.regen_health
self.armor = self.ability.talents.regen_armor
self.max = self.ability.talents.regen_max

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_tinker_march_of_the_machines_custom_regen:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
if self:GetStackCount() >= self.max then
    self.parent:GenericParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", self)
end

end

function modifier_tinker_march_of_the_machines_custom_regen:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end

function modifier_tinker_march_of_the_machines_custom_regen:GetModifierConstantHealthRegen()
return self.health*self:GetStackCount()
end

function modifier_tinker_march_of_the_machines_custom_regen:GetModifierPhysicalArmorBonus()
return self.armor*self:GetStackCount()
end

modifier_tinker_march_of_the_machines_custom_slow = class(mod_hidden)
function modifier_tinker_march_of_the_machines_custom_slow:IsPurgable() return true end
function modifier_tinker_march_of_the_machines_custom_slow:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.slow = self.ability.talents.slow_move
self.bonus = self.ability.talents.slow_bonus

if not IsServer() then return end
self.parent:GenericParticle("particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", self)
end

function modifier_tinker_march_of_the_machines_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_tinker_march_of_the_machines_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.parent:HasModifier("modifier_tinker_march_of_the_machines_custom_silence") and self.slow*self.bonus or self.slow
end

modifier_tinker_march_of_the_machines_custom_heal_reduce = class(mod_visible)
function modifier_tinker_march_of_the_machines_custom_heal_reduce:GetTexture() return "buffs/tinker/march_3" end
function modifier_tinker_march_of_the_machines_custom_heal_reduce:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.max = self.ability.talents.heal_reduce_max
self.heal_reduce = self.ability.talents.heal_reduce

if not IsServer() then return end
self:SetStackCount(1)
self.RemoveForDuel = true
end

function modifier_tinker_march_of_the_machines_custom_heal_reduce:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
    self.parent:GenericParticle("particles/items4_fx/spirit_vessel_damage.vpcf", self)
end

end

function modifier_tinker_march_of_the_machines_custom_heal_reduce:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end

function modifier_tinker_march_of_the_machines_custom_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_tinker_march_of_the_machines_custom_heal_reduce:GetModifierHealAmplify_PercentageTarget() 
return self.heal_reduce*self:GetStackCount()
end

function modifier_tinker_march_of_the_machines_custom_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce*self:GetStackCount()
end


modifier_tinker_march_of_the_machines_custom_haste = class(mod_visible)
function modifier_tinker_march_of_the_machines_custom_haste:GetTexture() return "buffs/tinker/hero_6" end
function modifier_tinker_march_of_the_machines_custom_haste:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.speed = self.ability.talents.haste_speed
if not IsServer() then return end
--self.parent:EmitSound("Tinker.March_haste")
self:OnIntervalThink()
self:StartIntervalThink(2)
end

function modifier_tinker_march_of_the_machines_custom_haste:OnIntervalThink()
if not IsServer() then return end
if self.particle then
    ParticleManager:Delete(self.particle)
    self.particle = nil
end
self.particle = self.parent:GenericParticle("particles/econ/events/ti10/phase_boots_ti10.vpcf", self)
end

function modifier_tinker_march_of_the_machines_custom_haste:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_tinker_march_of_the_machines_custom_haste:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_tinker_march_of_the_machines_custom_haste:CheckState()
return
{
    [MODIFIER_STATE_UNSLOWABLE] = true
}
end


modifier_tinker_march_of_the_machines_custom_silence_cd = class(mod_hidden)
function modifier_tinker_march_of_the_machines_custom_silence_cd:RemoveOnDeath() return false end
function modifier_tinker_march_of_the_machines_custom_silence_cd:OnCreated()
self.RemoveForDuel = true
end


modifier_tinker_march_of_the_machines_custom_silence = class(mod_hidden)
function modifier_tinker_march_of_the_machines_custom_silence:IsPurgable() return true end
function modifier_tinker_march_of_the_machines_custom_silence:CheckState()
return
{
    [MODIFIER_STATE_SILENCED] = true,
}
end
function modifier_tinker_march_of_the_machines_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_tinker_march_of_the_machines_custom_silence:ShouldUseOverheadOffset() return true end
function modifier_tinker_march_of_the_machines_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end