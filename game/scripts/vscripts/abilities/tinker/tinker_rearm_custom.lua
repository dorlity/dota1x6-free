LinkLuaModifier( "modifier_tinker_rearm_custom_tracker", "abilities/tinker/tinker_rearm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_rearm_custom", "abilities/tinker/tinker_rearm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_rearm_custom_damage_cd", "abilities/tinker/tinker_rearm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_rearm_custom_damage_cd_creeps", "abilities/tinker/tinker_rearm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_rearm_custom_mana_bonus", "abilities/tinker/tinker_rearm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_rearm_custom_auto_cast", "abilities/tinker/tinker_rearm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_rearm_custom_bkb_cd", "abilities/tinker/tinker_rearm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_rearm_custom_spell_damage", "abilities/tinker/tinker_rearm_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tinker_rearm_custom_quest", "abilities/tinker/tinker_rearm_custom", LUA_MODIFIER_MOTION_NONE )

tinker_rearm_custom = class({})
tinker_rearm_custom.talents = {}

function tinker_rearm_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_rearm.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_missile.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf", context )
end

function tinker_rearm_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() or self:GetCaster():IsCreepHero() then return end
return "modifier_tinker_rearm_custom_tracker"
end

function tinker_rearm_custom:GetAbilityTextureName()
if self.talents.has_bkb == 1 and not self:GetCaster():HasModifier("modifier_tinker_rearm_custom_bkb_cd") then
    return "rearm_bkb"
end
return "tinker_rearm"
end

function tinker_rearm_custom:GetChannelAnimation()
return (self:GetLevel() >= 2) and ACT_DOTA_TINKER_REARM3 or ACT_DOTA_TINKER_REARM2
end

function tinker_rearm_custom:GetChannelTime()
return self.channel_time*(1 + self.talents.channel_inc)
end

function tinker_rearm_custom:GetBehavior()
local bonus = 0
if self.talents.has_bkb == 1 and not self:GetCaster():HasModifier("modifier_tinker_rearm_custom_bkb_cd") then
  bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_CHANNELLED + bonus
end

function tinker_rearm_custom:GetCooldown(iLevel)
return self.BaseClass.GetCooldown(self, iLevel)
end

function tinker_rearm_custom:CheckToggle()
local caster = self:GetCaster()
if caster:HasModifier("modifier_tinker_rearm_custom_bkb_cd") then
    return false
end
return true
end


function tinker_rearm_custom:OnSpellStart()
local caster = self:GetCaster()

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_rearm.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack3", caster:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

caster:EmitSound("Hero_Tinker.Rearm")
local bkb = self.use_bkb and 1 or 0
self.use_bkb = nil
print(self:GetChannelTime())

caster:AddNewModifier(caster, self, "modifier_tinker_rearm_custom", {duration = self:GetChannelTime(), bkb = bkb})
end

function tinker_rearm_custom:OnChannelFinish(interrupted)
local caster = self:GetCaster()

caster:StopSound("Hero_Tinker.Rearm")

if interrupted then
    caster:RemoveModifierByName("modifier_tinker_rearm_custom")
    return
end

local count = 0
for i = 0, caster:GetAbilityCount() - 1 do
    local ability = caster:GetAbilityByIndex(i)
    if ability then
        if ability:GetCooldownTimeRemaining() > 0 then
            count = count + 1
        end
        ability:EndCooldown()
        ability:RefreshCharges()
    end
end

local tp_scroll = caster:FindItemInInventory("item_tpscroll_custom")
if tp_scroll then
	tp_scroll:EndCooldown()
end

if self.talents.has_heal == 1 then
    local heal = caster:GetMaxHealth()*self.talents.rearm_heal*count
    local mana = caster:GetMaxMana()*self.talents.rearm_mana*count
    caster:GenericHeal(heal, self, false, "particles/items3_fx/octarine_core_lifesteal.vpcf", "modifier_tinker_rearm_2")
    caster:GiveMana(mana)
    caster:SendNumber(OVERHEAD_ALERT_MANA_ADD, mana)
end

if self.talents.has_cd == 1 then
    caster:CdItems(self.talents.cd_items)
    local blink_cd = self.talents.cd_items - self.talents.cd_blink
    local blink_name = 
    {
        ["item_blink"] = true,
        ["item_overwhelming_blink"] = true,
        ["item_arcane_blink"] = true,
        ["item_swift_blink"] = true,
    }

    for i = 0, 8 do
        local current_item = caster:GetItemInSlot(i)
        if current_item and blink_name[current_item:GetName()] then  
          local cd = current_item:GetCooldownTimeRemaining()

          current_item:EndCooldown()

          if cd > math.abs(blink_cd) then 
            current_item:StartCooldown(cd - math.abs(blink_cd))
          end
        end
    end

    caster:AddNewModifier(caster, self, "modifier_tinker_rearm_custom_mana_bonus", {duration = self.talents.mana_duration})
end

if self.talents.has_spell == 1 and count > 0 then
    caster:AddNewModifier(caster, self, "modifier_tinker_rearm_custom_spell_damage", {duration = self.talents.spell_duration, stack = count})
end

if caster:HasModifier("modifier_tinker_rearm_custom_quest") and caster:GetQuest() == "Tinker.Quest_8" then
    caster:UpdateQuest(1)
end

caster:RemoveModifierByName("modifier_tinker_rearm_custom_damage_cd")
caster:RemoveModifierByName("modifier_tinker_rearm_custom_damage_cd_creeps")
end



modifier_tinker_rearm_custom = class(mod_hidden)
function modifier_tinker_rearm_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_reduce = self.ability.talents.damage_reduce

if not IsServer() then return end

if table.bkb == 1 then 
    self.parent:EmitSound("Tinker.Rearm_bkb")
    self.bkb_mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {effect = 2})
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_tinker_rearm_custom_bkb_cd", {duration = self.ability.talents.bkb_cd})
elseif self.ability.talents.has_bkb == 1 then
    self.parent:GenericParticle("particles/items2_fx/vindicators_axe_armor.vpcf", self)
end

end

function modifier_tinker_rearm_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_tinker_rearm_custom:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end

function modifier_tinker_rearm_custom:OnDestroy()
if not IsServer() then return end
if not IsValid(self.bkb_mod) then return end
self.bkb_mod:SetDuration(self.ability.talents.bkb_duration, true)
end



modifier_tinker_rearm_custom_tracker = class(mod_hidden)
function modifier_tinker_rearm_custom_tracker:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.ability.channel_time = self.ability:GetSpecialValueFor("AbilityChannelTime")

self.legendary_ability = self.parent:FindAbilityByName("tinker_heat_seeking_missile_custom")

self.ability.talents = 
{
    int_health = 0,

    has_damage = 0,
    damage_int = 0,
    damage_int_type = self.parent:GetTalentValue("modifier_tinker_rearm_1", "damage_type", true),
    damage_cd = self.parent:GetTalentValue("modifier_tinker_rearm_1", "talent_cd", true),

    has_heal = 0,
    rearm_heal = 0,
    rearm_mana = 0,

    has_spell = 0,
    channel_inc = 0,
    spell_inc = 0,
    spell_duration = self.parent:GetTalentValue("modifier_tinker_rearm_3", "duration", true),

    has_cd = 0,
    cd_blink = self.parent:GetTalentValue("modifier_tinker_rearm_4", "cd_blink", true),
    cd_items = self.parent:GetTalentValue("modifier_tinker_rearm_4", "cd_items", true),
    mana_duration = self.parent:GetTalentValue("modifier_tinker_rearm_4", "duration", true),
    mana_bonus = self.parent:GetTalentValue("modifier_tinker_rearm_4", "mana", true),

    has_bkb = 0,
    damage_reduce = 0,
    bkb_duration = self.parent:GetTalentValue("modifier_tinker_hero_8", "duration", true),
    bkb_cd = self.parent:GetTalentValue("modifier_tinker_hero_8", "talent_cd", true),

    legendary_damage = self.parent:GetTalentValue("modifier_tinker_rearm_7", "damage", true)/100,
    legendary_damage_base = self.parent:GetTalentValue("modifier_tinker_rearm_7", "damage_base", true),
    legendary_damage_inc = self.parent:GetTalentValue("modifier_tinker_rearm_7", "damage_inc", true)/100,
    legendary_stun = self.parent:GetTalentValue("modifier_tinker_rearm_7", "stun", true),
    legendary_stack = self.parent:GetTalentValue("modifier_tinker_rearm_7", "stack", true),
    legendary_damage_type = self.parent:GetTalentValue("modifier_tinker_rearm_7", "damage_type", true),
    legendary_cd = self.parent:GetTalentValue("modifier_tinker_rearm_7", "talent_cd", true),
}

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_tinker_rearm_custom_tracker:OnRefresh(table)
self.ability.channel_time = self.ability:GetSpecialValueFor("AbilityChannelTime")
end

function modifier_tinker_rearm_custom_tracker:UpdateTalent(name)

if name == "modifier_tinker_hero_4" or self.parent:HasTalent("modifier_tinker_hero_4") then
    self.PercentInt = self.parent:GetTalentValue("modifier_tinker_hero_4", "int")/100
    self.ability.talents.int_health = self.parent:GetTalentValue("modifier_tinker_hero_4", "health")
    if IsServer() then
        self.parent:CalculateStatBonus(true)
    end
end

if name == "modifier_tinker_rearm_1" or self.parent:HasTalent("modifier_tinker_rearm_1") then
    self.ability.talents.has_damage = 1
    self.ability.talents.damage_int = self.parent:GetTalentValue("modifier_tinker_rearm_1", "damage")/100
    self.parent:AddDamageEvent_out(self, true)
end

if name == "modifier_tinker_rearm_2" or self.parent:HasTalent("modifier_tinker_rearm_2") then
    self.ability.talents.has_heal = 1
    self.ability.talents.rearm_heal = self.parent:GetTalentValue("modifier_tinker_rearm_2", "heal")/100
    self.ability.talents.rearm_mana = self.parent:GetTalentValue("modifier_tinker_rearm_2", "mana")/100
end

if name == "modifier_tinker_rearm_3" or self.parent:HasTalent("modifier_tinker_rearm_3") then
    self.ability.talents.has_spell = 1
    self.ability.talents.channel_inc = self.parent:GetTalentValue("modifier_tinker_rearm_3", "cast")/100
    self.ability.talents.spell_inc = self.parent:GetTalentValue("modifier_tinker_rearm_3", "damage")
end

if name == "modifier_tinker_rearm_4" or self.parent:HasTalent("modifier_tinker_rearm_4") then
    self.ability.talents.has_cd = 1
    self.ability.talents.cd_inc = self.parent:GetTalentValue("modifier_tinker_rearm_4", "cd")
end

if name == "modifier_tinker_hero_8" or self.parent:HasTalent("modifier_tinker_hero_8") then
    self.ability.talents.has_bkb = 1
    self.ability.talents.damage_reduce = self.parent:GetTalentValue("modifier_tinker_hero_8", "damage_reduce")
end

if name == "modifier_tinker_rearm_7" or self.parent:HasTalent("modifier_tinker_rearm_7") then
  self.legendary_ability.talents.talent_cd = self.ability.talents.legendary_cd
  self.legendary_ability.talents.legendary_damage = self.ability.talents.legendary_damage
  self.legendary_ability.talents.legendary_damage_base = self.ability.talents.legendary_damage_base
  self.legendary_ability.talents.legendary_damage_inc = self.ability.talents.legendary_damage_inc
  self.legendary_ability.talents.legendary_stack = self.ability.talents.legendary_stack
  self.legendary_ability.talents.legendary_stun = self.ability.talents.legendary_stun
  self.legendary_ability.talents.legendary_damage_type = self.ability.talents.legendary_damage_type
end

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_tinker_rearm_custom_tracker:AddCustomTransmitterData() 
return self.ability.talents
end

function modifier_tinker_rearm_custom_tracker:HandleCustomTransmitterData(data)
if not self.ability then return end
self.ability.talents = data

if not self.legendary_ability then return end
self.legendary_ability.talents.talent_cd = data.legendary_cd
end

function modifier_tinker_rearm_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if self.ability.talents.has_damage == 0 then return end
if not params.unit:IsUnit() then return end
if self.parent ~= params.attacker then return end
if not self.parent:IsAlive() then return end

local unit = params.unit

local mod_name = "modifier_tinker_rearm_custom_damage_cd_creeps"
if unit:IsHero() then
    mod_name = "modifier_tinker_rearm_custom_damage_cd"
end

if self.parent:HasModifier(mod_name) then return end
if not params.inflictor or params.inflictor:IsItem() then return end
if params.custom_flag == CUSTOM_FLAG_TINKER_REARM then return end

local damage = self.ability.talents.damage_int*self.parent:GetIntellect(false)
local real_damage = DoDamage({attacker = self.parent, victim = unit, damage = damage, ability = self.ability, damage_type = self.ability.talents.damage_int_type, custom_flag = CUSTOM_FLAG_TINKER_REARM}, "modifier_tinker_rearm_1")
unit:SendNumber(4, real_damage)

unit:EmitSound("Tinker.Rearm_damage")

for i = 1,2 do
    local particle = ParticleManager:CreateParticle("particles/tinker/laser_legendary_hit.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, unit)
    ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), true)
    ParticleManager:ReleaseParticleIndex(particle)
end

self.parent:AddNewModifier(self.parent, self.ability, mod_name, {duration = self.ability.talents.damage_cd})
end

function modifier_tinker_rearm_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_BONUS
}
end

function modifier_tinker_rearm_custom_tracker:GetModifierHealthBonus()
return self.parent:GetIntellect(false)*self.ability.talents.int_health
end



tinker_heat_seeking_missile_custom = class({})
tinker_heat_seeking_missile_custom.talents = {}

function tinker_heat_seeking_missile_custom:CreateTalent()
self:SetHidden(false)
self:SetLevel(1)
end

function tinker_heat_seeking_missile_custom:GetCooldown()
return self.talents.talent_cd
end

function tinker_heat_seeking_missile_custom:OnSpellStart()
local caster = self:GetCaster()
local radius = self:GetSpecialValueFor("AbilityCastRange") + caster:GetCastRangeBonus()
local speed = self:GetSpecialValueFor("speed")

local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
local targets = self:GetSpecialValueFor("targets")

local result = {}
for _,hero in pairs(heroes) do
    if #result < targets then
        table.insert(result, hero)
    end
end

if #result < targets then
    local creeps = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
    for _,creep in pairs(creeps) do
        if #result < targets then
            table.insert(result, creep)
        end
    end
end

if #result <= 0 then
    caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile_Dud")

    local attach = caster:ScriptLookupAttachment( "attach_attack3" ) ~=0 and "attach_attack3" or "attach_attack1"
    local point = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment( attach ))

    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_tinker/tinker_missile_dud.vpcf", PATTACH_WORLDORIGIN, caster )
    ParticleManager:SetParticleControl( effect_cast, 0, point )
    ParticleManager:SetParticleControlForward( effect_cast, 0, caster:GetForwardVector() )
    ParticleManager:ReleaseParticleIndex( effect_cast )
    return
end

caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile")

local count = 0
for i = 0, 6 do
    local current_ability = caster:GetAbilityByIndex(i)
    if current_ability and current_ability ~= self and current_ability:GetCooldownTimeRemaining() > 0 then
        count = count + 1
    end
end

local info = 
{
  EffectName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
  Ability = self,
  iMoveSpeed = speed,
  Source = caster,
  bDodgeable = true,
  iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_3, 
  ExtraData = {count = count}
}

for _,target in pairs(result) do
    info.Target = target
    ProjectileManager:CreateTrackingProjectile(info)
end

end

function tinker_heat_seeking_missile_custom:OnProjectileHit_ExtraData(target, vLocation, table)
if not target then return end
local caster = self:GetCaster()
local count = table.count
local damage = self.talents.legendary_damage_base + caster:GetIntellect(false)*self.talents.legendary_damage
damage = damage*(1 + count*self.talents.legendary_damage_inc)

local damage_table = {victim = target, damage = damage, attacker = caster, ability = self, damage_type = self.talents.legendary_damage_type}
local real_damage = DoDamage(damage_table)
target:SendNumber(24, real_damage)

if count >= self.talents.legendary_stack then
    target:AddNewModifier(caster, self, "modifier_stunned", {duration = (1 - target:GetStatusResistance())*self.talents.legendary_stun})
end

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf", PATTACH_POINT_FOLLOW, target)
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

target:EmitSound("Hero_Tinker.Heat-Seeking_Missile.Impact")
end


modifier_tinker_rearm_custom_damage_cd = class(mod_hidden)
modifier_tinker_rearm_custom_damage_cd_creeps = (mod_hidden)

modifier_tinker_rearm_custom_mana_bonus = class(mod_visible)
function modifier_tinker_rearm_custom_mana_bonus:GetTexture() return "buffs/tinker/rearm_4" end
function modifier_tinker_rearm_custom_mana_bonus:OnCreated()
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.mana_bonus = self.ability.talents.mana_bonus
self.parent:AddSpellEvent(self)
end

function modifier_tinker_rearm_custom_mana_bonus:SpellEvent(params)
if not IsServer() then return end
if self.parent ~= params.unit then return end

self:Destroy()
end

function modifier_tinker_rearm_custom_mana_bonus:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
}
end

function modifier_tinker_rearm_custom_mana_bonus:GetModifierPercentageManacostStacking(params)
if not params.ability or params.ability == self.ability then return end
return self.ability.talents.mana_bonus
end


modifier_tinker_rearm_custom_auto_cast = class(mod_hidden)
function modifier_tinker_rearm_custom_auto_cast:RemoveOnDeath() return false end


modifier_tinker_rearm_custom_auto_cast = class(mod_hidden)
function modifier_tinker_rearm_custom_auto_cast:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()
self.ability:ToggleAutoCast()

self.ability.use_bkb = true
self.parent:CastAbilityNoTarget(self.ability, 1)
self:Destroy()
end

modifier_tinker_rearm_custom_bkb_cd = class(mod_cd)
function modifier_tinker_rearm_custom_bkb_cd:GetTexture() return "buffs/tinker/hero_8" end


modifier_tinker_rearm_custom_spell_damage = class(mod_visible)
function modifier_tinker_rearm_custom_spell_damage:GetTexture() return "buffs/tinker/rearm_3" end
function modifier_tinker_rearm_custom_spell_damage:OnCreated(table)
self.ability = self:GetAbility()
self.parent = self:GetParent()

self.duration = self.ability.talents.spell_duration
self.damage = self.ability.talents.spell_inc

if not IsServer() then return end
self:AddStack(table.stack)
end

function modifier_tinker_rearm_custom_spell_damage:OnRefresh(table)
if not IsServer() then return end 
self:AddStack(table.stack)
end 

function modifier_tinker_rearm_custom_spell_damage:AddStack(stack)
if not IsServer() then return end

for i = 1, stack do
    Timers:CreateTimer(self.duration, function() 
        if IsValid(self) then 
            self:DecrementStackCount()
            if self:GetStackCount() <= 0 then 
                self:Destroy()
            end 
        end 
    end)
    self:IncrementStackCount()
end

end 

function modifier_tinker_rearm_custom_spell_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end

function modifier_tinker_rearm_custom_spell_damage:GetModifierSpellAmplify_Percentage()
return self.damage*self:GetStackCount()
end

modifier_tinker_rearm_custom_quest = class(mod_hidden)