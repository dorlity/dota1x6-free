LinkLuaModifier("modifier_skeleton_king_reincarnation_custom", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_slow", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_aura_damage", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_legendary", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_legendary_target", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_aura_str", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_perma", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_crit", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_scepter", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)


skeleton_king_reincarnation_custom = class({})


function skeleton_king_reincarnation_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle","particles/sand_king/sand_pull.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", context )
PrecacheResource( "particle","particles/wraith_king_custom/wraith_king_tombstone_default.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", context )
PrecacheResource( "particle","particles/wk_burn.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_wraithking_ghosts.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf", context )
PrecacheResource( "particle","particles/muerta/muerta_calling_caster_end.vpcf", context )
PrecacheResource( "particle","particles/wraith_king/ult_legendary_damage.vpcf", context )
PrecacheResource( "particle","particles/troll_warlord/rage_unslow.vpcf", context )
PrecacheResource( "particle","particles/muerta/dead_refresh.vpcf", context )
PrecacheResource( "particle","particles/muerta/muerta_attack_slow.vpcf", context )

end



function skeleton_king_reincarnation_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") then
    return "skeleton_king/arcana/skeleton_king_reincarnation_arcana"
end
if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
    return "skeleton_king/arcana/skeleton_king_reincarnation_arcana_alt"
end
return "skeleton_king_reincarnation"
end


function skeleton_king_reincarnation_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_skeleton_king_reincarnation_custom"
end

function skeleton_king_reincarnation_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level )
end


function skeleton_king_reincarnation_custom:GetBehavior()
if self:GetCaster():HasScepter() then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end



function skeleton_king_reincarnation_custom:GetManaCost(level)
if self:GetCaster():HasShard()  then
    return 0
end
return self.BaseClass.GetManaCost(self, level)
end

function skeleton_king_reincarnation_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("slow_radius") - self:GetCaster():GetCastRangeBonus()
end


function skeleton_king_reincarnation_custom:OnSpellStart()
local caster = self:GetCaster()
caster:Purge(false, true, false, true, false)
self:RefundManaCost()
caster:AddNewModifier(caster, self, "modifier_skeleton_king_reincarnation_custom_scepter", {duration = 6})
caster:Kill(nil, caster)
end


function skeleton_king_reincarnation_custom:ReincarnationStart( params, modifier )
local caster = self:GetCaster()
local reincarnate = params.reincarnate

if not reincarnate then
    modifier.reincarnation_death = false   
    return
end

modifier.reincarnation_death = true
caster.reincarnate_res = true

local attacker = params.attacker
if attacker and players[attacker:GetId()] then
    caster:AddNewModifier(caster, self, "modifier_skeleton_king_reincarnation_custom_perma", {})
    if caster:GetQuest() == "Wraith.Quest_8" then
        caster:UpdateQuest(1)
    end
end

if caster:HasTalent("modifier_skeleton_reincarnation_4") then
    local cd = caster:GetTalentValue("modifier_skeleton_reincarnation_4", "cd")
    caster:CdItems(cd)
    for i = 0, 20 do
        local current_ability = caster:GetAbilityByIndex(i)
        if current_ability then
            caster:CdAbility(current_ability, cd)
        else
            break
        end
    end
end

caster:RemoveModifierByName("modifier_skeleton_king_reincarnation_custom_scepter")

self:UseResources(true, false, false, true)
local slow_duration = self:GetSpecialValueFor("slow_duration")
local slow_radius = self:GetSpecialValueFor("slow_radius")

local reincarnation_time = self:GetSpecialValueFor("reincarnate_time")
local silence_duration = caster:GetTalentValue("modifier_skeleton_hero_8", "silence")
local pull_duration = caster:GetTalentValue("modifier_skeleton_hero_8", "duration")
local max_distance = caster:GetTalentValue("modifier_skeleton_hero_8", "distance")

if caster:HasTalent("modifier_skeleton_hero_8") then 
    reincarnation_time =  reincarnation_time + caster:GetTalentValue("modifier_skeleton_hero_8", "delay")
    local effect_cast = ParticleManager:CreateParticle( "particles/sand_king/sand_pull.vpcf", PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( slow_radius, slow_radius, slow_radius ) )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end

for _, target in pairs(caster:FindTargets(slow_radius)) do
    target:AddNewModifier(caster, self, "modifier_skeleton_king_reincarnation_custom_slow", {duration = slow_duration})

    if caster:HasTalent("modifier_skeleton_hero_8") then 
        target:AddNewModifier(caster, caster:BkbAbility(self, true), "modifier_generic_silence", {duration = (1 - target:GetStatusResistance())*silence_duration})

        local dir = (caster:GetAbsOrigin() -  target:GetAbsOrigin()):Normalized()
        local point = caster:GetAbsOrigin() - dir*100

        local distance = (point - target:GetAbsOrigin()):Length2D()

        distance = math.min(max_distance,  math.max(100, distance))
        point = target:GetAbsOrigin() + dir*distance

        target:AddNewModifier( caster, caster:BkbAbility(self, true),  "modifier_generic_arc",  
        {
          target_x = point.x,
          target_y = point.y,
          distance = distance,
          duration = pull_duration,
          height = 0,
          fix_end = false,
          isStun = false,
          activity = ACT_DOTA_FLAIL,
        })
    end
end

local particle_name = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
local tomb_effect = "particles/wraith_king_custom/wraith_king_tombstone_default.vpcf"
local sound_reinc = "Hero_SkeletonKing.Reincarnate"

if caster:HasModifier("modifier_wraith_king_arcana_custom_v1") or caster:HasModifier("modifier_wraith_king_arcana_custom_v2") then
    tomb_effect = "particles/wraith_king_custom/wk_arc_reincarn_tombstone.vpcf"
    sound_reinc = "Hero_SkeletonKing.Reincarnate.Arcana"
end

if caster:HasModifier("modifier_wraith_king_arcana_custom_v1") then
    particle_name = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn.vpcf"
elseif caster:HasModifier("modifier_wraith_king_arcana_custom_v2") then
    particle_name = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_reincarn_style2.vpcf"
end

local particle_tombstone = ParticleManager:CreateParticle(tomb_effect, PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleAlwaysSimulate(particle_tombstone)
ParticleManager:SetParticleControl(particle_tombstone, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_tombstone, 2, Vector(reincarnation_time, 0, 0))
ParticleManager:ReleaseParticleIndex(particle_tombstone)

local particle = ParticleManager:CreateParticle(particle_name, PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleAlwaysSimulate(particle)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(reincarnation_time, 0, 0))
ParticleManager:SetParticleControl(particle, 11, Vector(200, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

caster:EmitSound(sound_reinc)

if GameRules:IsDaytime() then
    AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), 1800, reincarnation_time, true)
else
    AddFOWViewer(caster:GetTeamNumber(), caster:GetAbsOrigin(), 800, reincarnation_time, true)
end

end







modifier_skeleton_king_reincarnation_custom = class({})
function modifier_skeleton_king_reincarnation_custom:RemoveOnDeath() return false end
function modifier_skeleton_king_reincarnation_custom:IsHidden() return not self:GetParent():HasTalent("modifier_skeleton_reincarnation_1") end
function modifier_skeleton_king_reincarnation_custom:GetTexture() return "buffs/reincarnation_aura" end
function modifier_skeleton_king_reincarnation_custom:IsPurgable() return false end

function modifier_skeleton_king_reincarnation_custom:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetParent()
self.ability = self:GetAbility()

self.parent:AddDeathEvent(self)
self.parent:AddRespawnEvent(self)

self.respawn_timer = self.ability:GetSpecialValueFor("reincarnate_time")

self.burn_creeps = self.parent:GetTalentValue("modifier_skeleton_reincarnation_1", "creeps", true)
self.radius = self.parent:GetTalentValue("modifier_skeleton_reincarnation_1", "radius", true)

self.str_duration = self.parent:GetTalentValue("modifier_skeleton_reincarnation_3", "duration", true)

self.speed_bonus = self.parent:GetTalentValue("modifier_skeleton_hero_4", "bonus", true)
self.attack_speed = 0
self.move_speed = 0

self.damage_reduce_bonus = self.parent:GetTalentValue("modifier_skeleton_reincarnation_2", "bonus", true)
self.damage_reduce_health = self.parent:GetTalentValue("modifier_skeleton_reincarnation_2", "health", true)

self.shield_duration = self.parent:GetTalentValue("modifier_skeleton_hero_6", "duration", true)
self.shield_max = self.parent:GetTalentValue("modifier_skeleton_hero_6", "max", true)

self.is_cd = false

self.shard_duration = self.ability:GetSpecialValueFor("shard_duration")

if not IsServer() then return end
self.caster.reincarnate_res = false

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()

self:StartIntervalThink(1)
end


function modifier_skeleton_king_reincarnation_custom:UpdateTalent(name)

self.burn_damage = self.parent:GetTalentValue("modifier_skeleton_reincarnation_1", "damage")/100

self.attack_speed = self.parent:GetTalentValue("modifier_skeleton_hero_4", "attack")
self.move_speed = self.parent:GetTalentValue("modifier_skeleton_hero_4", "move")

self.damage_reduce = self.parent:GetTalentValue("modifier_skeleton_reincarnation_2", "damage_reduce")

if not IsServer() then return end
self:SendBuffRefreshToClients()
end


function modifier_skeleton_king_reincarnation_custom:OnIntervalThink()
if not IsServer() then return end

if not self.parent:HasModifier("modifier_skeleton_king_reincarnation_custom_perma") then
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_reincarnation_custom_perma", {})
end

if self.parent:HasTalent("modifier_skeleton_reincarnation_2") then
    if self.parent:IsAlive() and self.parent:GetHealthPercent() <= self.damage_reduce_health and not self.lowhp_effect and not self.parent:PassivesDisabled() then
        self.lowhp_effect = self.parent:GenericParticle("particles/troll_warlord/rage_unslow.vpcf", self)
    end

    if (not self.parent:IsAlive() or self.parent:GetHealthPercent() > self.damage_reduce_health or self.parent:PassivesDisabled()) and self.lowhp_effect then
        ParticleManager:Delete(self.lowhp_effect, 1)
        self.lowhp_effect = nil
    end
end

local is_cd = self.ability:GetCooldownTimeRemaining() > 0 and 1 or 0
if is_cd ~= self.is_cd then
    self.is_cd = is_cd
    self:SendBuffRefreshToClients()
end

if self.parent:HasTalent("modifier_skeleton_reincarnation_3") and (self.parent:IsAlive() or self.parent:IsReincarnating()) then
    local units = self.parent:FindTargets(self.radius)
    if #units > 0 then
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_reincarnation_custom_aura_str", {duration = self.str_duration})
    end
end

end


function modifier_skeleton_king_reincarnation_custom:AddCustomTransmitterData() 
return 
{
    burn_damage = self.burn_damage,
    is_cd = self.is_cd,
    move_speed = self.move_speed,
    attack_speed = self.attack_speed
} 
end

function modifier_skeleton_king_reincarnation_custom:HandleCustomTransmitterData(data)
self.burn_damage = data.burn_damage
self.is_cd = data.is_cd
self.attack_speed = data.attack_speed
self.move_speed = data.move_speed
end




function modifier_skeleton_king_reincarnation_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_REINCARNATION,    
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_TOOLTIP2,    
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,  
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,                     
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,                
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_skeleton_king_reincarnation_custom:OnTooltip()
return self.burn_damage*self.parent:GetHealth()
end

function modifier_skeleton_king_reincarnation_custom:OnTooltip2()
return self.burn_creeps
end

function modifier_skeleton_king_reincarnation_custom:GetModifierIncomingDamage_Percentage()
if self.parent:PassivesDisabled() then return end
local bonus = self.damage_reduce
if self.parent:GetHealthPercent() <= self.damage_reduce_health then
    bonus = bonus*self.damage_reduce_bonus
end
return bonus
end

function modifier_skeleton_king_reincarnation_custom:GetModifierAttackSpeedBonus_Constant()
local bonus = self.attack_speed
if self.is_cd == 1 then
    bonus = bonus*self.speed_bonus
end
return bonus
end

function modifier_skeleton_king_reincarnation_custom:GetModifierMoveSpeedBonus_Constant()
local bonus = self.move_speed
if self.is_cd == 1 then
    bonus = bonus*self.speed_bonus
end
return bonus
end


function modifier_skeleton_king_reincarnation_custom:RespawnEvent(params)
if not IsServer() then return end
if params.unit ~= self.parent then return end

self.reincarnation_death = false

if self.parent.reincarnate_res == false then return end

self.parent.reincarnate_res = false

if self.parent:HasShard() then 
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_reincarnation_custom_crit", {duration = self.shard_duration})
end

if self.parent:HasTalent("modifier_skeleton_hero_6") then 
    for i = 1,self.shield_max do
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_vampiric_aura_custom_shield", {duration = self.shield_duration})
    end
end


end

function modifier_skeleton_king_reincarnation_custom:ReincarnateTime()
if not IsServer() then return end
if self.parent:IsRealHero() and (not self.parent:HasModifier("modifier_death") or self.parent:HasModifier("modifier_axe_culling_blade_custom_aegis")) and self.ability:IsFullyCastable() then
    return self.respawn_timer + self.parent:GetTalentValue("modifier_skeleton_hero_8", "delay")
end
return nil
end

function modifier_skeleton_king_reincarnation_custom:GetActivityTranslationModifiers()
if self.reincarnation_death then return "reincarnate" end
return nil
end

function modifier_skeleton_king_reincarnation_custom:DeathEvent(params)
if not IsServer() then return end
local unit = params.unit
local reincarnate = params.reincarnate
if self.parent ~= unit then return end
if not self.ability:IsFullyCastable() then return end

self.ability:ReincarnationStart( params, self )
end




function modifier_skeleton_king_reincarnation_custom:GetAuraRadius() return self.radius end
function modifier_skeleton_king_reincarnation_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_skeleton_king_reincarnation_custom:GetAuraSearchType()  return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO end
function modifier_skeleton_king_reincarnation_custom:GetModifierAura() return "modifier_skeleton_king_reincarnation_custom_aura_damage" end
function modifier_skeleton_king_reincarnation_custom:IsAura() 
return self.parent:HasTalent("modifier_skeleton_reincarnation_1") or self.parent:HasTalent("modifier_skeleton_reincarnation_3") 
end





modifier_skeleton_king_reincarnation_custom_aura_damage = class({})
function modifier_skeleton_king_reincarnation_custom_aura_damage:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_aura_damage:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_aura_damage:GetTexture() return "buffs/reincarnation_aura" end
function modifier_skeleton_king_reincarnation_custom_aura_damage:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.slow = self.caster:GetTalentValue("modifier_skeleton_reincarnation_3", "slow")

if not IsServer() then return end

if self.caster:HasTalent("modifier_skeleton_reincarnation_3") then
    self.parent:GenericParticle("particles/muerta/muerta_attack_slow.vpcf", self)
end

if not self.caster:HasTalent("modifier_skeleton_reincarnation_1") then return end

self.parent:GenericParticle("particles/wk_burn.vpcf", self)
self.interval = self.caster:GetTalentValue("modifier_skeleton_reincarnation_1", "interval")
self.damage = (self.caster:GetTalentValue("modifier_skeleton_reincarnation_1", "damage")/100)*self.interval
self.creeps = self.caster:GetTalentValue("modifier_skeleton_reincarnation_1", "creeps")

if self.parent:IsCreep() then 
    self.damage = self.damage/self.creeps
end
self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = self.caster:GetTalentValue("modifier_skeleton_reincarnation_1", "damage_type")}

self:StartIntervalThink(self.interval)
end

function modifier_skeleton_king_reincarnation_custom_aura_damage:OnIntervalThink()
if not IsServer() then return end
self.damageTable.damage = (self.caster:GetHealth())*self.damage
DoDamage(self.damageTable, "modifier_skeleton_reincarnation_1")
end


function modifier_skeleton_king_reincarnation_custom_aura_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_skeleton_king_reincarnation_custom_aura_damage:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end





modifier_skeleton_king_reincarnation_custom_slow = class({})
function modifier_skeleton_king_reincarnation_custom_slow:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_slow:IsPurgable() return not self.caster:HasShard() end
function modifier_skeleton_king_reincarnation_custom_slow:OnCreated()    
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.move_slow = self.ability:GetSpecialValueFor("movespeed")
self.attack_slow = self.ability:GetSpecialValueFor("attackslow")

if not IsServer() then return end

local particle_debuff_name = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf"
if self.caster:HasModifier("modifier_wraith_king_arcana_custom_v1") or self.caster:HasModifier("modifier_wraith_king_arcana_custom_v2") then
    particle_debuff_name = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_slow_debuff.vpcf"
end
self.parent:GenericParticle(particle_debuff_name, self)

if not self.caster:HasTalent("modifier_skeleton_hero_8") then return end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster)
ParticleManager:SetParticleControlEnt( self.particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)  

self:StartIntervalThink(self.caster:GetTalentValue("modifier_skeleton_hero_8", "duration") + 0.4)
end

function modifier_skeleton_king_reincarnation_custom_slow:OnIntervalThink()
if not IsServer() then return end
if not self.particle then return end
ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)
self.particle = nil
end


function modifier_skeleton_king_reincarnation_custom_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_skeleton_king_reincarnation_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move_slow
end

function modifier_skeleton_king_reincarnation_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self.attack_slow
end






skeleton_king_reincarnation_custom_legendary = class({})

function skeleton_king_reincarnation_custom_legendary:CreateTalent()
self:SetHidden(false)
end

function skeleton_king_reincarnation_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_legendary", "talent_cd")
end

function skeleton_king_reincarnation_custom_legendary:OnSpellStart()
local caster = self:GetCaster()
caster:AddNewModifier(caster, self, "modifier_skeleton_king_reincarnation_custom_legendary", {duration = caster:GetTalentValue("modifier_skeleton_reincarnation_legendary", "duration")})
end




modifier_skeleton_king_reincarnation_custom_legendary = class({})
function modifier_skeleton_king_reincarnation_custom_legendary:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_legendary:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_wraithking_ghosts.vpcf" end
function modifier_skeleton_king_reincarnation_custom_legendary:StatusEffectPriority() return MODIFIER_PRIORITY_SUPER_ULTRA  end
function modifier_skeleton_king_reincarnation_custom_legendary:GetEffectName() return "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf" end
function modifier_skeleton_king_reincarnation_custom_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MODEL_SCALE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
}
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierHealthRegenPercentage()
return self.heal
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierModelScale()
return 30
end


function modifier_skeleton_king_reincarnation_custom_legendary:OnCreated(table)

self.ability = self:GetAbility()
self.parent = self:GetParent()

self.cd_inc = self.parent:GetTalentValue("modifier_skeleton_reincarnation_legendary", "cd_inc")/100
self.heal = self.parent:GetTalentValue("modifier_skeleton_reincarnation_legendary", "heal")/self:GetRemainingTime()
self.move = self.ability:GetSpecialValueFor("move")
self.radius = self.ability:GetSpecialValueFor("radius")
self.interval = self.ability:GetSpecialValueFor("interval")

if not IsServer() then return end
self.ability:EndCd()
self.ulti_ability = self.parent:FindAbilityByName("skeleton_king_reincarnation_custom")

self.RemoveForDuel = true
self.parent:EmitSound("WK.Ult_legendary_start")

self.damageTable = {attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_PURE}

self.cd_ulti = true

self:OnIntervalThink()
self:StartIntervalThink(self.interval - FrameTime())
end


function modifier_skeleton_king_reincarnation_custom_legendary:OnIntervalThink()
if not IsServer() then return end 

local hit_hero = false

for _,unit in pairs(self.parent:FindTargets(self.radius)) do
    local damage = self.heal*self.parent:GetMaxHealth()*self.interval/100
    self.damageTable.damage = damage
    self.damageTable.victim = unit
    DoDamage(self.damageTable)

    if unit:IsRealHero() then
        hit_hero = true
    end
end

if not hit_hero then
    self.cd_ulti = false
    return
end

if self.ulti_ability and self.ulti_ability:GetCooldownTimeRemaining() > 0 then
    local cd = self.ulti_ability:GetEffectiveCooldown(self.ulti_ability:GetLevel())*self.cd_inc
    self.parent:CdAbility(self.ulti_ability, cd)
end

end 

function modifier_skeleton_king_reincarnation_custom_legendary:OnDestroy()
if not IsServer() then return end

self.ability:StartCd()
self.parent:EmitSound("WK.Ult_end")
self.parent:GenericParticle("particles/muerta/muerta_calling_caster_end.vpcf")

if self.cd_ulti == false then return end

self.parent:EmitSound("WK.Ult_refresh")

local particle = ParticleManager:CreateParticle("particles/muerta/dead_refresh.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)
end




function modifier_skeleton_king_reincarnation_custom_legendary:CheckState()
return
{
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_UNSLOWABLE] = true,
}
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraDuration() return 0 end
function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraRadius() return self.radius end
function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierAura() return "modifier_skeleton_king_reincarnation_custom_legendary_target" end
function modifier_skeleton_king_reincarnation_custom_legendary:IsAura() return true end




modifier_skeleton_king_reincarnation_custom_legendary_target = class({})
function modifier_skeleton_king_reincarnation_custom_legendary_target:IsHidden() return true end
function modifier_skeleton_king_reincarnation_custom_legendary_target:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_legendary_target:OnCreated()
if not IsServer() then return end
self.caster = self:GetCaster()
self.parent = self:GetParent()

local mod = self.caster:FindModifierByName("modifier_skeleton_king_reincarnation_custom_legendary")
if not mod then return end

local particle = ParticleManager:CreateParticle("particles/wraith_king/ult_legendary_damage.vpcf", PATTACH_CUSTOMORIGIN, self.caster)
ParticleManager:SetParticleControlEnt(particle, 0, self.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", self.caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(particle, 5, Vector(mod:GetRemainingTime(), 0, 0))
self:AddParticle(particle, false, false, -1, false, false)    
end





modifier_skeleton_king_reincarnation_custom_aura_str = class(mod_visible)
function modifier_skeleton_king_reincarnation_custom_aura_str:GetTexture() return "buffs/bloodlust_str" end
function modifier_skeleton_king_reincarnation_custom_aura_str:RemoveOnDeath() return false end
function modifier_skeleton_king_reincarnation_custom_aura_str:OnCreated()
self.parent = self:GetParent()

self.max = self.parent:GetTalentValue("modifier_skeleton_reincarnation_3", "max")
self.str = self.parent:GetTalentValue("modifier_skeleton_reincarnation_3", "str")
self:SetStackCount(1)
end

function modifier_skeleton_king_reincarnation_custom_aura_str:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end


function modifier_skeleton_king_reincarnation_custom_aura_str:OnStackCountChanged(iStackCount)
if not IsServer() then return end
self.parent:CalculateStatBonus(true)
end

function modifier_skeleton_king_reincarnation_custom_aura_str:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end

function modifier_skeleton_king_reincarnation_custom_aura_str:GetModifierBonusStats_Strength()
return self.str*self:GetStackCount()
end




modifier_skeleton_king_reincarnation_custom_perma = class({})
function modifier_skeleton_king_reincarnation_custom_perma:IsHidden() return not self:GetCaster():HasTalent("modifier_skeleton_reincarnation_4") or self:GetStackCount() == 0 or self:GetStackCount() >= self.max end
function modifier_skeleton_king_reincarnation_custom_perma:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_perma:RemoveOnDeath() return false end
function modifier_skeleton_king_reincarnation_custom_perma:GetTexture() return "buffs/flare_perma" end
function modifier_skeleton_king_reincarnation_custom_perma:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_skeleton_reincarnation_4", "max", true)
self.cdr = self.parent:GetTalentValue("modifier_skeleton_reincarnation_4", "cdr", true)

if not IsServer() then return end
self:StartIntervalThink(0.5)
end

function modifier_skeleton_king_reincarnation_custom_perma:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end

function modifier_skeleton_king_reincarnation_custom_perma:OnIntervalThink()
if not IsServer() then return end 
if self:GetStackCount() < self.max then return end
if not self.parent:HasTalent("modifier_skeleton_reincarnation_4") then return end

local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(particle_peffect, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self.parent:GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self.parent:EmitSound("BS.Thirst_legendary_active")
self:StartIntervalThink(-1)
end 


function modifier_skeleton_king_reincarnation_custom_perma:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end


function modifier_skeleton_king_reincarnation_custom_perma:GetModifierPercentageCooldown() 
if not self.parent:HasTalent("modifier_skeleton_reincarnation_4") then return end
return self:GetStackCount()*self.cdr
end

modifier_skeleton_king_reincarnation_custom_crit = class(mod_visible)
function modifier_skeleton_king_reincarnation_custom_crit:GetTexture() return "skeleton_king_mortal_strike" end




modifier_skeleton_king_reincarnation_custom_scepter = class(mod_hidden)
function modifier_skeleton_king_reincarnation_custom_scepter:OnCreated()
self.ability = self:GetAbility()
if not IsServer() then return end
self.RemoveForDuel = true
self.ability:EndCd()
end

function modifier_skeleton_king_reincarnation_custom_scepter:OnDestroy()
if not IsServer() then return end
self.ability:StartCd()
end