LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_debuff", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_illusion", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_damage", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_leash", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_stun", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_hellfire_blast_custom_tracker", "abilities/wraith_king/skeleton_king_hellfire_blast.lua", LUA_MODIFIER_MOTION_NONE )

skeleton_king_hellfire_blast_custom = class({})

function skeleton_king_hellfire_blast_custom:CreateTalent()
self:ToggleAutoCast()
end


function skeleton_king_hellfire_blast_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeleton_king_weapon_blur_critical.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeleton_king_weapon_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/skeleton_king_weapon_blur_reverse.vpcf", context )

PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_explosion.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_warmup.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf", context )
PrecacheResource( "particle","particles/items4_fx/spirit_vessel_damage.vpcf", context )
PrecacheResource( "particle","particles/wk_haste.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_wraithking_ghosts.vpcf", context )
PrecacheResource( "particle","particles/jugg_ward_damage.vpcf", context )
PrecacheResource( "particle","particles/wk_stun_legen.vpcf", context )
PrecacheResource( "particle","particles/wraith_king/blast_radius.vpcf", context )
PrecacheResource( "particle","particles/wraith_king/blast_delay_damage.vpcf", context )
PrecacheResource( "particle","particles/wraith_king/blast_delay_damage_2.vpcf", context )
PrecacheResource( "particle","particles/nature_prophet/sprout_treant_death.vpcf", context )

PrecacheResource( "particle","particles/wraith_king_custom/wraith_king_ambient_custom.vpcf", context )

dota1x6:PrecacheShopItems("npc_dota_hero_skeleton_king", context)
end


function skeleton_king_hellfire_blast_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_wraith_king_blistering_shade_custom") then
    return "skeleton_king/blistering_shade/skeleton_king_hellfire_blast"
end
if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") then
    return "skeleton_king/arcana/skeleton_king_hellfire_blast_arcana"
end
if self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
    return "skeleton_king/arcana/skeleton_king_hellfire_blast_arcana_alt"
end
return "skeleton_king_hellfire_blast"
end


function skeleton_king_hellfire_blast_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_skeleton_king_hellfire_blast_custom_tracker"
end

function skeleton_king_hellfire_blast_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasTalent("modifier_skeleton_blast_4") then
    bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + bonus
end


function skeleton_king_hellfire_blast_custom:GetCastPoint(iLevel)
local bonus = 0
if self:GetCaster():HasTalent("modifier_skeleton_blast_2") then 
    bonus = self:GetCaster():GetTalentValue("modifier_skeleton_blast_2", "cast")
end
return self.BaseClass.GetCastPoint(self) + bonus
end


function skeleton_king_hellfire_blast_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_skeleton_blast_2") then 
    bonus = self:GetCaster():GetTalentValue("modifier_skeleton_blast_2", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end


function skeleton_king_hellfire_blast_custom:OnAbilityPhaseStart()
local caster = self:GetCaster()
local part_name = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_warmup.vpcf"
if caster:HasModifier("modifier_wraith_king_blistering_shade_custom") then
    part_name = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_warmup.vpcf"
end
local particle = ParticleManager:CreateParticle(part_name, PATTACH_CUSTOMORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)
return true
end


function skeleton_king_hellfire_blast_custom:OnSpellStart(new_target, new_source)
local caster = self:GetCaster()
local target = self:GetCursorTarget()

local speed = self:GetSpecialValueFor("blast_speed")

if new_target ~= nil then 
    target = new_target
end

local source_loc = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
local source = caster
if new_source then
    speed = speed*1.7
    source = new_source
    source_loc = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION 
end

local proj_name = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast.vpcf"
if caster:HasModifier("modifier_wraith_king_blistering_shade_custom") then
    proj_name = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast.vpcf"
elseif caster:HasModifier("modifier_wraith_king_arcana_custom_v1") then
    proj_name = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast.vpcf"
elseif caster:HasModifier("modifier_wraith_king_arcana_custom_v2") then
    proj_name = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_style2.vpcf"
end

local info = 
{
    EffectName = proj_name,
    Ability = self,
    iMoveSpeed = speed,
    Source = source,
    Target = target,
    bDodgeable = not caster:HasTalent("modifier_skeleton_blast_4"), 
    iSourceAttachment = source_loc,
    ExtraData = {source = source:entindex()}
}
ProjectileManager:CreateTrackingProjectile( info )
source:EmitSound("Hero_SkeletonKing.Hellfire_Blast")
end



function skeleton_king_hellfire_blast_custom:OnProjectileHit_ExtraData( target, vLocation, table)
if not IsServer() then return end
if not target then return end

local caster = self:GetCaster()

local source = EntIndexToHScript(table.source)
source = (source and not source:IsNull()) and source or caster

if source == caster then
    if target:TriggerSpellAbsorb( self ) then return end
end

local stun_duration = self:GetSpecialValueFor( "blast_stun_duration" ) + caster:GetTalentValue("modifier_skeleton_hero_1", "stun")
local stun_damage = self:GetAbilityDamage() + caster:GetTalentValue("modifier_skeleton_blast_1", "damage")*caster:GetAverageTrueAttackDamage(nil)/100

if caster:HasTalent("modifier_skeleton_blast_4") and self:GetAutoCastState() and not target:HasModifier("modifier_skeleton_king_hellfire_blast_custom_illusion") then 
    local dir = (source:GetAbsOrigin() - target:GetAbsOrigin()):Normalized()
    local point = source:GetAbsOrigin() - dir*50
    local distance = (point - target:GetAbsOrigin()):Length2D()
    local max_dist = caster:GetTalentValue("modifier_skeleton_blast_4", "max_dist")
    local duration = caster:GetTalentValue("modifier_skeleton_blast_4", "duration")

    distance = math.min(max_dist, math.max(40, distance))
    point = target:GetAbsOrigin() + dir*distance

    local mod = target:AddNewModifier( caster, self,  "modifier_generic_arc",  
    {
      target_x = point.x,
      target_y = point.y,
      distance = distance,
      duration = duration,
      height = 0,
      fix_end = false,
      isStun = false,
      activity = ACT_DOTA_FLAIL,
    })

    if mod then 
        target:GenericParticle("particles/muerta/muerta_attack_slow.vpcf", mod)
    end 
end


target:AddNewModifier(caster, self, "modifier_skeleton_king_hellfire_blast_custom_stun", {duration = stun_duration * (1 - target:GetStatusResistance())})

if caster:HasTalent("modifier_skeleton_blast_3") then 
    target:AddNewModifier( caster, self, "modifier_skeleton_king_hellfire_blast_custom_damage", { duration = caster:GetTalentValue("modifier_skeleton_blast_3", "duration")} )
end 

local damage = {victim = target, attacker = caster, damage = stun_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self}
DoDamage( damage )

target:EmitSound("Hero_SkeletonKing.Hellfire_BlastImpact")

local mod = target:FindModifierByName("modifier_skeleton_king_hellfire_blast_custom_illusion")
if mod and mod.target and not mod.target:IsNull() and mod.target:IsAlive() and not mod.target:IsInvulnerable() then 
    self:OnSpellStart(mod.target, target)
end

end






modifier_skeleton_king_hellfire_blast_custom_damage = class({})
function modifier_skeleton_king_hellfire_blast_custom_damage:IsHidden() return true end
function modifier_skeleton_king_hellfire_blast_custom_damage:IsPurgable() return false end
function modifier_skeleton_king_hellfire_blast_custom_damage:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.damage = self.caster:GetTalentValue("modifier_skeleton_blast_3", "damage")/100
self.radius = self.caster:GetTalentValue("modifier_skeleton_blast_3", "radius")
self.max_time = self.caster:GetTalentValue("modifier_skeleton_blast_3", "duration")
self.damage_type = self.caster:GetTalentValue("modifier_skeleton_blast_3", "damage_type")

self.parent:AddDamageEvent_inc(self, true)

if not IsServer() then return end

self.radius_visual = ParticleManager:CreateParticle("particles/wraith_king/blast_radius.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.radius_visual, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.radius_visual, 1, Vector(self.radius, 0, 0))
self:AddParticle(self.radius_visual, false, false, -1, false, false)

if self.parent:HasModifier("modifier_skeleton_king_hellfire_blast_custom_illusion") then return end

self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_skeleton_king_hellfire_blast_custom_damage:OnIntervalThink()
if not IsServer() then return end

self.caster:UpdateUIshort({max_time = self.max_time, time = self:GetRemainingTime(), stack = self:GetStackCount(), style = "WraithBlast"})
end


function modifier_skeleton_king_hellfire_blast_custom_damage:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end
if self.ended then return end

local attacker = params.attacker
if attacker.owner then
    attacker = attacker.owner
end

if self.caster ~= attacker then return end

self:SetStackCount(self:GetStackCount() + params.damage*self.damage)
end


function modifier_skeleton_king_hellfire_blast_custom_damage:OnDestroy()
if not IsServer() then return end

self.ended = true

if not self.parent:HasModifier("modifier_skeleton_king_hellfire_blast_custom_illusion") then
    self.caster:UpdateUIshort({hide = 1, hide_full = 1, style = "WraithBlast"})
end

if self:GetStackCount() <= 0 then return end

self.parent:EmitSound("WK.Stun_blast")
self.parent:EmitSound("WK.Stun_blast2")

local particle = ParticleManager:CreateParticle("particles/wraith_king/blast_delay_damage.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(self.radius, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

local damageTable = {attacker = self.caster, damage = self:GetStackCount(), ability = self.ability, damage_type = self.damage_type}

for _,unit in pairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())) do
    unit:GenericParticle("particles/wraith_king/blast_delay_damage_2.vpcf")
    damageTable.victim = unit
    local real_damage = DoDamage(damageTable, "modifier_skeleton_blast_3")
    unit:SendNumber(6, real_damage)
end

if self.caster:IsAlive() then
    self.caster:GenericHeal(self:GetStackCount(), self.ability, nil, nil, "modifier_skeleton_blast_3")
end

end






skeleton_king_hellfire_blast_custom_legendary = class({})

function skeleton_king_hellfire_blast_custom_legendary:CreateTalent()
self:SetHidden(false)
end

function skeleton_king_hellfire_blast_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_skeleton_blast_legendary", "talent_cd")
end

function skeleton_king_hellfire_blast_custom_legendary:OnAbilityPhaseStart()
local caster = self:GetCaster()

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_warmup.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)
return true
end

function skeleton_king_hellfire_blast_custom_legendary:OnSpellStart(new_target)

local caster = self:GetCaster()
local target = self:GetCursorTarget()

if not target:IsHero() then return end

caster:EmitSound("WK.Stun_legendary")
caster:EmitSound("WK.Stun_legendary2")

local duration = caster:GetTalentValue("modifier_skeleton_blast_legendary", "duration")

local illusion_self = CreateIllusions(target, target, {
    outgoing_damage = 0,
    incoming_damage = 0,
    duration    = duration 
}, 1, 0, false, false)

for _,illusion in pairs(illusion_self) do

    illusion:SetHealth(illusion:GetMaxHealth())
    illusion.owner = target

    illusion:AddNewModifier(illusion, self, "modifier_skeleton_king_hellfire_blast_custom_illusion", {duration = duration, caster = caster:entindex(), target = target:entindex()})
    illusion:AddNewModifier(illusion, self, "modifier_chaos_knight_phantasm_illusion", {})
    illusion:SetOrigin(caster:GetAbsOrigin() + caster:GetForwardVector()*200)

    local particle = ParticleManager:CreateParticle("particles/wk_stun_legen.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, target)
    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, illusion, PATTACH_POINT_FOLLOW, "attach_hitloc", illusion:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
end


end





modifier_skeleton_king_hellfire_blast_custom_illusion = class({})
function modifier_skeleton_king_hellfire_blast_custom_illusion:IsHidden() return true end
function modifier_skeleton_king_hellfire_blast_custom_illusion:IsPurgable() return false end
function modifier_skeleton_king_hellfire_blast_custom_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_wraithking_ghosts.vpcf" end
function modifier_skeleton_king_hellfire_blast_custom_illusion:StatusEffectPriority() return MODIFIER_PRIORITY_ILLUSION end
function modifier_skeleton_king_hellfire_blast_custom_illusion:CheckState()
return
{
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
}
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = EntIndexToHScript(table.caster)
self.target = EntIndexToHScript(table.target)
self.ability = self:GetAbility()

self.damage = self.caster:GetTalentValue("modifier_skeleton_blast_legendary", "damage")/100

self.parent:AddDamageEvent_inc(self, true)

self.damageTable = {victim = self.target, attacker = self.caster, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability}

self.parent:StartGesture(ACT_DOTA_DISABLED)

self.interval = 0.2
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_skeleton_king_hellfire_blast_custom_illusion:OnIntervalThink()
if not IsServer() then return end
if not self.target or self.target:IsNull() or not self.target:IsAlive() then return end

AddFOWViewer(self.caster:GetTeamNumber(), self.target:GetAbsOrigin(), 10, self.interval + 0.1, false)
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    MODIFIER_PROPERTY_MODEL_SCALE,
}
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:GetOverrideAnimation()
return ACT_DOTA_DISABLED
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:GetModifierModelScale() 
return 20 
end


function modifier_skeleton_king_hellfire_blast_custom_illusion:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end

local attacker = params.attacker

if attacker ~= self.caster and (not attacker.owner or attacker.owner ~= self.caster) then return end
if not self.target or self.target:IsNull() or not self.target:IsAlive() then return end
if params.original_damage < 0 then return end

self.target:EmitSound("WK.Stun_legendary_damage")

self.damageTable.damage = params.original_damage*self.damage
DoDamage( self.damageTable )

local particle = ParticleManager:CreateParticle("particles/jugg_ward_damage.vpcf", PATTACH_POINT_FOLLOW, self.parent)
ParticleManager:SetParticleControlEnt(particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, self.target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.target:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 2, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)
end

function modifier_skeleton_king_hellfire_blast_custom_illusion:OnDestroy()
if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/nature_prophet/sprout_treant_death.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( particle, 0, self.parent:GetAbsOrigin() + Vector(0,0,40) )
ParticleManager:ReleaseParticleIndex( particle )

self.parent:GenericParticle()
end




modifier_skeleton_king_hellfire_blast_custom_stun = class({})
function modifier_skeleton_king_hellfire_blast_custom_stun:IsHidden() return true end
function modifier_skeleton_king_hellfire_blast_custom_stun:IsStunDebuff() return true end
function modifier_skeleton_king_hellfire_blast_custom_stun:IsPurgeException() return true end
function modifier_skeleton_king_hellfire_blast_custom_stun:GetEffectName() return "particles/generic_gameplay/generic_stunned.vpcf" end
function modifier_skeleton_king_hellfire_blast_custom_stun:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_skeleton_king_hellfire_blast_custom_stun:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_skeleton_king_hellfire_blast_custom_stun:GetOverrideAnimation()
return ACT_DOTA_DISABLED
end


function modifier_skeleton_king_hellfire_blast_custom_stun:CheckState()
return
{
    [MODIFIER_STATE_STUNNED] = true
}
end

function modifier_skeleton_king_hellfire_blast_custom_stun:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if not IsServer() then return end

self.slow_duration = self.ability:GetSpecialValueFor( "blast_dot_duration" )
end



function modifier_skeleton_king_hellfire_blast_custom_stun:OnDestroy()
if not IsServer() then return end
self.parent:AddNewModifier(self.caster, self.ability, "modifier_skeleton_king_hellfire_blast_custom_debuff", {duration = self.slow_duration})

if self.caster:HasTalent("modifier_skeleton_blast_4") then
    self.parent:AddNewModifier(self.caster, self.ability, "modifier_skeleton_king_hellfire_blast_custom_leash", {duration = self.caster:GetTalentValue("modifier_skeleton_blast_4", "leash")})
end

end




modifier_skeleton_king_hellfire_blast_custom_debuff = class({})
function modifier_skeleton_king_hellfire_blast_custom_debuff:IsPurgable() return true end
function modifier_skeleton_king_hellfire_blast_custom_debuff:IsHidden() return false end
function modifier_skeleton_king_hellfire_blast_custom_debuff:OnCreated( kv )
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.per_damage = self.ability:GetSpecialValueFor( "blast_dot_damage" )
self.move_slow = self.ability:GetSpecialValueFor( "blast_slow" ) + self.caster:GetTalentValue("modifier_skeleton_hero_5", "slow")
self.count = self.ability:GetSpecialValueFor( "blast_dot_duration" )
self.reduce = self.caster:GetTalentValue("modifier_skeleton_hero_5", "heal_reduce")

if not IsServer() then return end

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage = self.per_damage, damage_type = DAMAGE_TYPE_MAGICAL}

local particle_name_debuff = "particles/units/heroes/hero_skeletonking/skeletonking_hellfireblast_debuff.vpcf"
if self:GetCaster():HasModifier("modifier_wraith_king_blistering_shade_custom") then
    particle_name_debuff = "particles/econ/items/wraith_king/wraith_king_ti6_bracer/wraith_king_ti6_hellfireblast_debuff.vpcf"
elseif self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v1") then
    particle_name_debuff = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_debuff.vpcf"
elseif self:GetCaster():HasModifier("modifier_wraith_king_arcana_custom_v2") then
    particle_name_debuff = "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_wraithfireblast_debuff_style2.vpcf"
end
self.parent:GenericParticle(particle_name_debuff, self)


self.interval = 1
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierLifestealRegenAmplify_Percentage() 
return self.reduce
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierHealAmplify_PercentageTarget() 
return self.reduce
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierHPRegenAmplify_Percentage() 
return self.reduce
end

function modifier_skeleton_king_hellfire_blast_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.move_slow
end


function modifier_skeleton_king_hellfire_blast_custom_debuff:OnIntervalThink()
if not IsServer() then return end
if self.count < 1 and not self.caster:HasTalent("modifier_skeleton_hero_5") then return end 

self.count = self.count - 1
DoDamage( self.damageTable )
end








modifier_skeleton_king_hellfire_blast_custom_leash = class({})
function modifier_skeleton_king_hellfire_blast_custom_leash:IsHidden() return true end
function modifier_skeleton_king_hellfire_blast_custom_leash:IsPurgable() return true end
function modifier_skeleton_king_hellfire_blast_custom_leash:CheckState()
return
{
    [MODIFIER_STATE_TETHERED] = true
}
end
function modifier_skeleton_king_hellfire_blast_custom_leash:GetEffectName()
return "particles/muerta/muerta_attack_slow.vpcf"
end




modifier_skeleton_king_hellfire_blast_custom_tracker = class(mod_hidden)
function modifier_skeleton_king_hellfire_blast_custom_tracker:OnCreated()
self.parent = self:GetParent()

self.ability = self:GetAbility()
self.slow_duration = self.ability:GetSpecialValueFor("blast_dot_duration")
if not IsServer() then return end
self:UpdateTalent()
end

function modifier_skeleton_king_hellfire_blast_custom_tracker:UpdateTalent()
if not IsServer() then return end

if name == "modifier_skeleton_hero_5" or self.parent:HasTalent("modifier_skeleton_hero_5") then
    self.parent:AddAttackEvent_out(self, true)
end

end


function modifier_skeleton_king_hellfire_blast_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if not params.target:IsUnit() then return end

local attacker = params.attacker

if attacker ~= self.parent and (not attacker.owner or attacker.owner ~= self.parent or not attacker:HasModifier("modifier_skeleton_king_vampiric_aura_custom_skeleton_ai")) then return end

params.target:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_hellfire_blast_custom_debuff", {duration = self.slow_duration})

local mod = params.target:FindModifierByName("modifier_skeleton_king_hellfire_blast_custom_illusion")
if not mod or not mod.target or mod.target:IsNull() or not mod.target:IsAlive() then return end

mod.target:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_hellfire_blast_custom_debuff", {duration = self.slow_duration})
end