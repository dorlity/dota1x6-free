LinkLuaModifier( "modifier_antimage_counterspell_custom", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_active", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_legendary_damage", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_heal", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_burn_damage", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_shield", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_shard_shield", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_antimage_counterspell_custom_slow", "abilities/antimage/antimage_counterspell_custom", LUA_MODIFIER_MOTION_NONE )

antimage_counterspell_custom = class({})

function antimage_counterspell_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/am_spell_damage.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", context )
PrecacheResource( "particle", "particles/am_lightning.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_counter.vpcf", context )
PrecacheResource( "particle", "particles/am_lightning.vpcf", context )
PrecacheResource( "particle", "particles/am_no_mana.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/zeus_resist_stack.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf", context )
PrecacheResource( "particle", "particles/am_spell_damage.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/antimage/counter_lowhp.vpcf", context )
PrecacheResource( "particle", "particles/enigma/summon_perma.vpcf", context )
PrecacheResource( "particle", "particles/bane/brain_shield.vpcf", context )

end

function antimage_counterspell_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_antimage_counterspell_custom"
end

function antimage_counterspell_custom:GetCooldown(iLevel)
return self.BaseClass.GetCooldown(self, iLevel)
end

function antimage_counterspell_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level)
end

function antimage_counterspell_custom:ShardMana(mana)
if not IsServer() then return end
if not self:IsTrained() then return end

local caster = self:GetCaster()
if caster.owner and caster.owner:HasAbility(self:GetName()) then
    caster.owner:FindAbilityByName(self:GetName()):ShardMana(mana)
    return
end

local shard_mana = mana*self:GetSpecialValueFor("shard_mana")/100
local over_mana = shard_mana - math.min(shard_mana, caster:GetMaxMana() - caster:GetMana())

caster:GiveMana(shard_mana)

if over_mana <= 0 then return end
caster:AddNewModifier(caster, self, "modifier_antimage_counterspell_custom_shard_shield", {shield = over_mana, duration = self:GetSpecialValueFor("shard_duration")})
end



function antimage_counterspell_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_antimage_counter_4", "duration")

if test then
end

if test and false then
    local heroes = 
    {
        "npc_dota_hero_legion_commander",
        "npc_dota_hero_axe",
        "npc_dota_hero_alchemist",
        "npc_dota_hero_pudge",
        "npc_dota_hero_primal_beast",
        "npc_dota_hero_morphling",
        "npc_dota_hero_centaur",
        "npc_dota_hero_huskar",
        "npc_dota_hero_sven",   
        "npc_dota_hero_mars",
        "npc_dota_hero_bristleback"
    }


    local teams = 
    {
        [1] = 1,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
    }

    local count = 1

    for _,hero in pairs(heroes) do
        local data = {}
        data.value = hero

        if teams[count] >= 2 then
            count = count + 1
        end
        data.spawn_for_team = count

        teams[count] = teams[count] + 1
        data.PlayerID = caster:GetId()

        DeepPrintTable(data)
        test_mode:AddHero(data, true)

    end
end

if caster.antimage_illusions then
    for illusion,_ in pairs(caster.antimage_illusions) do
        illusion:EmitSound("Hero_Antimage.Counterspell.Cast")
        illusion:AddNewModifier(caster, self, "modifier_antimage_counterspell_custom_active", {duration = duration})
    end
end

caster:EmitSound("Hero_Antimage.Counterspell.Cast")
caster:AddNewModifier(caster, self, "modifier_antimage_counterspell_custom_active", {duration = duration})

if caster:HasTalent("modifier_antimage_counter_7") or caster:HasTalent("modifier_antimage_counter_3") then
    caster:AddNewModifier(caster, self, "modifier_antimage_counterspell_custom_shield", {duration = duration})
end

end






modifier_antimage_counterspell_custom_active = class(mod_visible)
function modifier_antimage_counterspell_custom_active:OnCreated()
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.damage_reduce = 0
if self.parent:IsIllusion() then
    local illusion_ability = self.caster:FindAbilityByName("antimage_mana_overload_custom")
    if illusion_ability then
        self.damage_reduce = illusion_ability:GetSpecialValueFor("damage_reduce")
    end
end

if not IsServer() then return end

self.ignore_spells = 
{
    ["custom_pudge_dismember"] = true,
    ["morphling_replicate_custom"] = true,
}

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_counter.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:SetParticleControl(particle, 1, Vector(100,0,0))
self:AddParticle(particle, false, false, -1, false, false)

if self.caster ~= self.parent then return end
self.ability:EndCd()
end


function modifier_antimage_counterspell_custom_active:OnDestroy()
if not IsServer() then return end

if self.caster == self.parent then
    self.ability:StartCd()
end

if self.parent:HasTalent("modifier_antimage_counter_4") then
    self.parent:Purge(false, true, false, true, false)
    self.parent:GenericParticle("particles/units/heroes/hero_brewmaster/brewmaster_dispel_magic.vpcf")
end

end


function modifier_antimage_counterspell_custom_active:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_REFLECT_SPELL,
    MODIFIER_PROPERTY_ABSORB_SPELL,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_antimage_counterspell_custom_active:GetModifierIncomingDamage_Percentage()
if not self.parent:IsIllusion() then return end
return self.damage_reduce
end


function modifier_antimage_counterspell_custom_active:GetAbsorbSpell( params )
if not IsServer() then return end
if not params.ability:GetCaster() then return end 
if params.ability:GetCaster():GetTeamNumber() == self.parent:GetTeamNumber() then return end 

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )
self.parent:EmitSound("Hero_Antimage.SpellShield.Reflect")

return 1
end


function modifier_antimage_counterspell_custom_active:GetReflectSpell( params )
if not IsServer() then return end
if not params.ability:GetCaster() then return end 

local target = params.ability:GetCaster()
local reflected_spell_name = params.ability:GetAbilityName()

if target:GetTeamNumber() == self.parent:GetTeamNumber() then return end 

if target:IsCreep() or self.ability:IsStolen() or self.parent:IsIllusion() then 
    self.parent:EmitSound("Hero_Antimage.Counterspell.Target")
    return 
end

target:EmitSound("Hero_Antimage.Counterspell.Target")

if target:IsRealHero() then
    if self.parent:GetQuest() == "Anti.Quest_7" and not self.parent:QuestCompleted() then
        self.parent:UpdateQuest(1)
    end
end

if target:HasModifier("modifier_item_lotus_orb_active") or target:HasModifier("modifier_item_mirror_shield") or params.ability.spell_shield_reflect then return end
if self.ignore_spells[reflected_spell_name] then return end

local old_spell = false
for hSpell,name in pairs(self.parent.counterspell_history) do
    if hSpell ~= nil and name == reflected_spell_name then
        old_spell = true
        break
    end
end

if old_spell then
    ability = self.parent:FindAbilityByName(reflected_spell_name)
else
    ability = self.parent:AddAbility(reflected_spell_name)
    ability:SetStolen(true)
    ability:SetHidden(true)
    ability.spell_shield_reflect = true
    ability:SetRefCountsModifiers(true)
    self.parent.counterspell_history[ability] = ability:GetName()
end

ability:SetLevel(params.ability:GetLevel())

self.parent:SetCursorCastTarget(target)
ability:OnSpellStart()

if ability.OnChannelFinish then
    ability:OnChannelFinish(false)
end

local mod = self.parent:FindModifierByName("modifier_antimage_counterspell_custom")
if mod then
    mod:OnIntervalThink()
end

return false
end





modifier_antimage_counterspell_custom = class(mod_hidden)
function modifier_antimage_counterspell_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end

function modifier_antimage_counterspell_custom:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.resist = self.ability:GetSpecialValueFor("magic_resistance")

self.total_block = 0
self.low_health = self.parent:GetTalentValue("modifier_antimage_hero_7", "health", true)
self.resist_bonus = self.parent:GetTalentValue("modifier_antimage_hero_7", "resist", true)
self.low_status = self.parent:GetTalentValue("modifier_antimage_hero_7", "status", true)

self.status_bonus = self.parent:GetTalentValue("modifier_antimage_counter_4", "status")

if not IsServer() then return end
self.parent.counterspell_history = {}

self.burn_duration = self.parent:GetTalentValue("modifier_antimage_counter_1", "duration", true)

self.interval = 0.5
self:StartIntervalThink(self.interval)

self:SetHasCustomTransmitterData(true)
self:UpdateTalent()
end

function modifier_antimage_counterspell_custom:OnRefresh(table)
self.resist = self.ability:GetSpecialValueFor("magic_resistance")
end

function modifier_antimage_counterspell_custom:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_antimage_counter_4" or self.parent:HasTalent("modifier_antimage_counter_4") then
    self.status_bonus = self.parent:GetTalentValue("modifier_antimage_counter_4", "status")
end

if name == "modifier_antimage_counter_1" or self.parent:HasTalent("modifier_antimage_counter_1") then
    self.parent:AddAttackEvent_out(self, true)
end

if name == "modifier_antimage_hero_7" or self.parent:HasTalent("modifier_antimage_hero_7") then
    self.total_block = 1
end

self:SendBuffRefreshToClients()
end

function modifier_antimage_counterspell_custom:AddCustomTransmitterData() 
return 
{
  status_bonus = self.status_bonus,
  total_block = self.total_block
} 
end

function modifier_antimage_counterspell_custom:HandleCustomTransmitterData(data)
self.status_bonus = data.status_bonus
self.total_block = data.total_block
end

function modifier_antimage_counterspell_custom:GetModifierStatusResistanceStacking()
local bonus = (self.total_block == 1 and self.parent:GetHealthPercent() <= self.low_health and not self.parent:PassivesDisabled()) and self.low_status or 0
return self.status_bonus + bonus
end

function modifier_antimage_counterspell_custom:AttackEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_antimage_counter_1") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

params.target:AddNewModifier(self.parent, self.ability, "modifier_antimage_counterspell_custom_burn_damage", {duration = self.burn_duration})
end


function modifier_antimage_counterspell_custom:GetModifierMagicalResistanceBonus( params )
if self.parent:PassivesDisabled() then return end
local bonus = (self.total_block == 1 and self.parent:GetHealthPercent() <= self.low_health) and self.resist_bonus or 0
return self.resist + bonus
end

function modifier_antimage_counterspell_custom:GetModifierIncomingDamage_Percentage(params)
if self.total_block == 0 then return end
if self.parent:PassivesDisabled() then return end
if params.inflictor == nil or params.damage_type == DAMAGE_TYPE_MAGICAL then return end
if Not_spell_damage[params.inflictor:GetName()] then return end

local bonus = (self.total_block == 1 and self.parent:GetHealthPercent() <= self.low_health) and self.resist_bonus or 0
return (self.resist + bonus)*-1
end


function modifier_antimage_counterspell_custom:OnIntervalThink()
if not IsServer() then return end

if self.total_block == 1 then
    if self.parent:GetHealthPercent() <= self.low_health and not self.cast_effect and not self.parent:PassivesDisabled() then
        self.parent:EmitSound("Antimage.Counterspell_lowhp")

        self.cast_effect = ParticleManager:CreateParticle("particles/bane/brain_shield.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt( self.cast_effect, 0,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( self.cast_effect, 1, self.parent:GetAbsOrigin() )
        ParticleManager:SetParticleControlEnt( self.cast_effect, 2,  self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc",  self.parent:GetAbsOrigin(), true )
        self:AddParticle( self.cast_effect, false, false, -1, false, false  )
    end

    if (self.parent:GetHealthPercent() > self.low_health or self.parent:PassivesDisabled()) and self.cast_effect then
        ParticleManager:Delete(self.cast_effect, 1)
        self.cast_effect = nil
    end
end

for hSpell,name in pairs(self.parent.counterspell_history) do

    if hSpell and not hSpell:IsNull() then
        if hSpell:GetToggleState() then
            hSpell:ToggleAbility()
        end
        local intrinsic_mod = hSpell:GetIntrinsicModifierName()
        if intrinsic_mod then
            self.parent:RemoveModifierByName(intrinsic_mod)
        end

        if hSpell:NumModifiersUsingAbility() <= 0 and not hSpell:IsChanneling() then

            self.parent.counterspell_history[hSpell] = nil

            self.parent:RemoveAbilityByHandle(hSpell)
            UTIL_Remove(hSpell)
            hSpell = nil

        --  print('no mods :(', name)
        end
    else
    --  print('remove!!!', name)
        self.parent.counterspell_history[hSpell] = nil
    end
end
self:StartIntervalThink(self.interval)
end




modifier_antimage_counterspell_custom_legendary_damage = class(mod_visible)
function modifier_antimage_counterspell_custom_legendary_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_antimage_counterspell_custom_legendary_damage:GetModifierIncomingDamage_Percentage()
return self.damage
end

function modifier_antimage_counterspell_custom_legendary_damage:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.damage = self.caster:GetTalentValue("modifier_antimage_counter_7", "damage")

if not IsServer() then return end
self.parent:GenericParticle("particles/general/generic_armor_reduction.vpcf", self, true)
end



modifier_antimage_counterspell_custom_heal = class(mod_visible)
function modifier_antimage_counterspell_custom_heal:GetTexture() return "buffs/antimage/counterspell_2" end
function modifier_antimage_counterspell_custom_heal:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end
function modifier_antimage_counterspell_custom_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_antimage_counterspell_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end

function modifier_antimage_counterspell_custom_heal:GetModifierHealthRegenPercentage()
return self.heal 
end

function modifier_antimage_counterspell_custom_heal:OnCreated()
self.heal = self:GetParent():GetTalentValue("modifier_antimage_counter_2", "heal")/self:GetRemainingTime()
end 




modifier_antimage_counterspell_custom_slow = class(mod_hidden)
function modifier_antimage_counterspell_custom_slow:IsPurgable() return true end
function modifier_antimage_counterspell_custom_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end
function modifier_antimage_counterspell_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_antimage_counterspell_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_antimage_counterspell_custom_slow:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()

self.slow = self.caster:GetTalentValue("modifier_antimage_counter_2", "slow")
end




modifier_antimage_counterspell_custom_burn_damage = class({})
function modifier_antimage_counterspell_custom_burn_damage:IsHidden() return false end
function modifier_antimage_counterspell_custom_burn_damage:IsPurgable() return true end
function modifier_antimage_counterspell_custom_burn_damage:GetTexture() return "buffs/antimage/counterspell_1" end

function modifier_antimage_counterspell_custom_burn_damage:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.damage_type = self.caster:GetTalentValue("modifier_antimage_counter_1", "damage_type")
self.damage = self.caster:GetTalentValue("modifier_antimage_counter_1", "damage")
self.interval = self.caster:GetTalentValue("modifier_antimage_counter_1", "interval")
self.max = self.caster:GetTalentValue("modifier_antimage_counter_1", "max")

if not IsServer() then return end

self.damageTable = {victim = self.parent, attacker = self.caster, ability = self.ability, damage_type = self.damage_type}
self.parent:GenericParticle("particles/units/heroes/hero_faceless_void/faceless_void_dialatedebuf_2.vpcf", self)
self:SetStackCount(1)
self:StartIntervalThink(self.interval - FrameTime())
end

function modifier_antimage_counterspell_custom_burn_damage:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_antimage_counterspell_custom_burn_damage:OnIntervalThink()
if not IsServer() then return end

self.damageTable.damage = self.interval*self.damage*self:GetStackCount()
DoDamage(self.damageTable, "modifier_antimage_counter_1")
end




modifier_antimage_counterspell_custom_shield = class(mod_hidden)
function modifier_antimage_counterspell_custom_shield:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.attacker = nil

self.max_shield = self.parent:GetTalentValue("modifier_antimage_counter_7", "shield", true)*self.parent:GetMaxHealth()/100
self:SetStackCount(self.max_shield)

self.duration = self.parent:GetTalentValue("modifier_antimage_counter_7", "duration")
self.stun = self.parent:GetTalentValue("modifier_antimage_counter_7", "stun")
self.radius = self.parent:GetTalentValue("modifier_antimage_counter_7", "radius", true)

self.heal = self.parent:GetTalentValue("modifier_antimage_counter_3", "heal")/100
self.damage_type = self.parent:GetTalentValue("modifier_antimage_counter_3", "damage_type", true)

self.end_anim = ACT_DOTA_CAST_ABILITY_2

if not IsServer() then return end
if not self.parent:HasTalent("modifier_antimage_counter_7") then return end

if self.parent:HasModifier("modifier_antimage_persona_custom_1") or self.parent:HasModifier("modifier_antimage_persona_custom_2")
 or self.parent:HasModifier("modifier_antimage_persona_custom_3") or self.parent:HasModifier("modifier_antimage_persona_custom_4")
  or self.parent:HasModifier("modifier_antimage_persona_custom_5") or self.parent:HasModifier("modifier_antimage_persona_custom_6") then

    self.start_anim = ACT_DOTA_TELEPORT
else
    self.parent:AddActivityModifier("slasher_weapon")
    self.parent:AddActivityModifier("slasher_offhand")
    self.parent:AddActivityModifier("slasher_mask")
    self.parent:AddActivityModifier("slasher_chest")
    self.parent:AddActivityModifier("slasher_belt")
    self.parent:AddActivityModifier("slasher_arms")
    self.parent:AddActivityModifier("slasher_shoulder")

    self.start_anim = ACT_DOTA_LOADOUT
end

self.parent:StartGesture(self.start_anim)
end



function modifier_antimage_counterspell_custom_shield:OnDestroy()
if not IsServer() then return end

if self.parent:HasTalent("modifier_antimage_counter_7") then
    self.parent:ClearActivityModifiers()
    self.parent:FadeGesture(self.start_anim)
end

if self:GetStackCount() > 0 then return end

self.parent:StartGestureWithPlaybackRate(self.end_anim, 1.3)

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )
 

if self.parent:HasTalent("modifier_antimage_counter_3") then
    self.parent:GenericHeal(self.parent:GetMaxHealth()*self.heal, self.ability, nil, nil, "modifier_antimage_counter_3")

    self.parent:EmitSound("Antimage.Counterspell_damage")

    local effect_cast = ParticleManager:CreateParticle( "particles/am_spell_damage.vpcf", PATTACH_WORLDORIGIN,  nil)
    ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetAbsOrigin() )
    ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius , 0, 0 ) )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end

self.parent:EmitSound("Hero_Antimage.Counterspell.Target")

local attack_hit = false
for _,target in pairs(self.parent:FindTargets(self.radius)) do

    if self.attacker and target == self.attacker then
        attack_hit = true
    end
    self:LegendaryHit(target)
end 

if not attack_hit and self.attacker and not self.attacker:IsNull() and self.attacker:IsAlive() then
    self:LegendaryHit(self.attacker, true)
end

end


function modifier_antimage_counterspell_custom_shield:LegendaryHit(target, range_hit)
if not IsServer() then return end

target:EmitSound("Antimage.Counterspell_damage_target")

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_manabreak_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

if self.parent:HasTalent("modifier_antimage_counter_7") then
    target:EmitSound("Antimage.Break_stun")
    local immortal_particle = ParticleManager:CreateParticle("particles/am_no_mana.vpcf", PATTACH_OVERHEAD_FOLLOW, target)
    ParticleManager:SetParticleControl(immortal_particle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(immortal_particle, 1, target:GetAbsOrigin() )
    ParticleManager:Delete(immortal_particle, 1)

    local particle = ParticleManager:CreateParticle( "particles/am_lightning.vpcf", PATTACH_POINT_FOLLOW, target )
    ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( particle, 1, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true )
    ParticleManager:ReleaseParticleIndex( particle )

    target:AddNewModifier(self.parent, self.parent:BkbAbility(self.ability, true), "modifier_antimage_counterspell_custom_legendary_damage", {duration = self.duration})
    target:AddNewModifier(self.parent, self.parent:BkbAbility(self.ability, true), "modifier_stunned", {duration = (1 - target:GetStatusResistance())*self.stun})
end

if not range_hit and self.parent:HasTalent("modifier_antimage_counter_3") then
    DoDamage({attacker = self.parent, damage = self.parent:GetMaxHealth()*self.heal, damage_type = self.damage_type, ability = self.ability, victim = target}, "modifier_antimage_counter_3")
end

end


function modifier_antimage_counterspell_custom_shield:CheckState()
if not self.parent:HasTalent("modifier_antimage_counter_7") then return end
return
{
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true
}
end

function modifier_antimage_counterspell_custom_shield:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
}
end

function modifier_antimage_counterspell_custom_shield:GetModifierIncomingDamageConstant( params )

if IsClient() then 
    if params.report_max then 
        return self.max_shield
    else  
        return self:GetStackCount()
    end 
end

if not IsServer() then return end
if params.attacker:GetTeamNumber() == self.parent:GetTeamNumber() then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self.parent:EmitSound("Antimage.Block_1")

local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex( particle )

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self.attacker = params.attacker
  self:Destroy()
end

return -damage
end





modifier_antimage_counterspell_custom_shard_shield = class(mod_visible)
function modifier_antimage_counterspell_custom_shard_shield:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.shield_talent = "Shard"
self.shard_shield = self.ability:GetSpecialValueFor("shard_shield")/100
self.max_shield = self.shard_shield*self.parent:GetMaxHealth()

if not IsServer() then return end
self.RemoveForDuel = true
self:AddShield(table.shield)
end

function modifier_antimage_counterspell_custom_shard_shield:OnRefresh(table)
self.max_shield = self.shard_shield*self.parent:GetMaxHealth()

if not IsServer() then return end
self:AddShield(table.shield)
end

function modifier_antimage_counterspell_custom_shard_shield:AddShield(shield)
if not IsServer() then return end
self:SetStackCount(math.min(self.max_shield, self:GetStackCount() + shield))
end


function modifier_antimage_counterspell_custom_shard_shield:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
}
end

function modifier_antimage_counterspell_custom_shard_shield:GetModifierIncomingPhysicalDamageConstant( params )
if self.parent:HasModifier("modifier_antimage_counterspell_custom_shield") then return end

if IsClient() then 
    if params.report_max then 
        return self.max_shield
    else  
        return self:GetStackCount()
    end 
end

if not IsServer() then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end


