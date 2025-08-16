LinkLuaModifier( "modifier_skeleton_king_mortal_strike_custom", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_armor", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_legendary", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_legendary_stack", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_legendary_heal_reduce", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_cd", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_stack", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_bkb_cd", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_bkb_speed", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_slow", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_skeleton_king_mortal_strike_bash_count", "abilities/wraith_king/skeleton_king_mortal_strike.lua", LUA_MODIFIER_MOTION_NONE )


skeleton_king_mortal_strike_custom = class({})

skeleton_king_mortal_strike_custom.current_target = nil


function skeleton_king_mortal_strike_custom:CreateTalent()
self:UpdateUI()
end


function skeleton_king_mortal_strike_custom:GetAbilityTextureName()
local caster = self:GetCaster()
local name = "skeleton_king_mortal_strike"

if caster:HasModifier("modifier_wraith_king_ti_8_weapon") then
    name = "skeleton_king/ti8_immortal_weapon/skeleton_king_mortal_strike_immortal"
elseif caster:HasModifier("modifier_wraith_king_ti_8_weapon_crimson") then
    name = "skeleton_king/ti8_immortal_weapon/skeleton_king_mortal_strike_immortal_crimson"
elseif caster:HasModifier("modifier_wraith_king_arcana_custom_v1") then
    name = "skeleton_king/arcana/skeleton_king_mortal_strike_arcana"
elseif caster:HasModifier("modifier_wraith_king_arcana_custom_v2") then
    name = "skeleton_king/arcana/skeleton_king_mortal_strike_arcana_alt"
end
return name
end

function skeleton_king_mortal_strike_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle","particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", context )
PrecacheResource( "particle","particles/wraith_king/crit_normal.vpcf", context )
PrecacheResource( "particle","particles/general/generic_armor_reduction.vpcf", context )
PrecacheResource( "particle","particles/lc_attack_buf.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_beserkers_call.vpcf", context )
PrecacheResource( "particle","particles/wk_crit_buf.vpcf", context )
PrecacheResource( "particle","particles/wk_stack.vpcf", context )
PrecacheResource( "particle","particles/strike_wk_damage.vpcf", context )
PrecacheResource( "particle","particles/items2_fx/sange_maim.vpcf", context )
PrecacheResource( "particle","particles/wraith_king/crit_arcana_v1.vpcf", context )
PrecacheResource( "particle","particles/wraith_king/crit_arcana_v2.vpcf", context )
PrecacheResource( "particle","particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", context )
PrecacheResource( "particle","particles/wraith_king/crit_legendary.vpcf", context )

end

    
function skeleton_king_mortal_strike_custom:GetIntrinsicModifierName()
return "modifier_skeleton_king_mortal_strike_custom"
end


function  skeleton_king_mortal_strike_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_skeleton_strike_legendary") then
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
return DOTA_ABILITY_BEHAVIOR_PASSIVE
end


function skeleton_king_mortal_strike_custom:GetCooldown(iLevel)
local caster = self:GetCaster()
if caster:HasTalent("modifier_skeleton_strike_legendary") then 
    return caster:GetTalentValue("modifier_skeleton_strike_legendary", "talent_cd")
end
local upgrade_cooldown = 0  
if caster:HasTalent("modifier_skeleton_strike_1") then 
    upgrade_cooldown = caster:GetTalentValue("modifier_skeleton_strike_1", "cd")
end
return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown 
end


function skeleton_king_mortal_strike_custom:OnSpellStart()
local caster = self:GetCaster()
caster:AddNewModifier(caster, self, "modifier_skeleton_king_mortal_strike_legendary", {duration = caster:GetTalentValue("modifier_skeleton_strike_legendary", "duration")})
end


function skeleton_king_mortal_strike_custom:UpdateUI()
if not IsServer() then return end

local caster = self:GetCaster()
local target = self.current_target
local stack = 0

if target and not target:IsNull() then 
    local mod = target:FindModifierByName("modifier_skeleton_king_mortal_strike_legendary_stack")
    if mod then
        stack = mod:GetStackCount()
    end
end

caster:UpdateUIlong({override_stack = stack, no_min = 1, style = "WraithCrit"})
end




modifier_skeleton_king_mortal_strike_custom = class(mod_hidden)
function modifier_skeleton_king_mortal_strike_custom:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.crit = self.ability:GetSpecialValueFor("crit_mult")
self.cd = self.ability:GetSpecialValueFor("AbilityCooldown")

if self.parent:IsRealHero() then 
    self.parent:AddDamageEvent_out(self, true)
end 

self.cleave_damage = 0
self.cd_inc = 0
self.range_bonus = 0
self.delay_damage = 0

self.armor_duration = self.parent:GetTalentValue("modifier_skeleton_strike_2", "duration", true)
self.delay_duration = self.parent:GetTalentValue("modifier_skeleton_strike_3", "delay", true)

self.base_bva = self.parent:GetBaseAttackTime()

self.bkb_duration = self.parent:GetTalentValue("modifier_skeleton_hero_7", "bkb", true)
self.bkb_cd = self.parent:GetTalentValue("modifier_skeleton_hero_7", "talent_cd", true)

self.legendary_bva = self.parent:GetTalentValue("modifier_skeleton_strike_legendary", "bva", true)
self.legendary_damage = self.parent:GetTalentValue("modifier_skeleton_strike_legendary", "damage", true)
self.legendary_mark_duration = self.parent:GetTalentValue("modifier_skeleton_strike_legendary", "mark_duration", true)
self.legendary_crit = self.parent:GetTalentValue("modifier_skeleton_strike_legendary", "crit", true)
self.heal_reduce_duration = self.parent:GetTalentValue("modifier_skeleton_strike_legendary", "heal_reduce_duration", true)

self.crit_range = self.parent:GetTalentValue("modifier_skeleton_strike_4", "range", true)
self.bash_duration = self.parent:GetTalentValue("modifier_skeleton_strike_4", "duration", true)

self.record = nil
self:UpdateTalent()

if not IsServer() then return end
self:SetHasCustomTransmitterData(true)
end


function modifier_skeleton_king_mortal_strike_custom:OnRefresh()
self.crit = self.ability:GetSpecialValueFor("crit_mult")
self.cd = self.ability:GetSpecialValueFor("AbilityCooldown")
end


function modifier_skeleton_king_mortal_strike_custom:UpdateTalent()
self.cleave_damage = self.parent:GetTalentValue("modifier_skeleton_hero_2", "cleave")/100
self.range_bonus = self.parent:GetTalentValue("modifier_skeleton_hero_2", "range")

self.delay_damage = self.parent:GetTalentValue("modifier_skeleton_strike_3", "damage")/100

self.cd_inc = self.parent:GetTalentValue("modifier_skeleton_strike_1", "cd")

if not IsServer() then return end
self:SendBuffRefreshToClients()
end

function modifier_skeleton_king_mortal_strike_custom:AddCustomTransmitterData() 
return 
{
    range_bonus = self.range_bonus
} 
end

function modifier_skeleton_king_mortal_strike_custom:HandleCustomTransmitterData(data)
self.range_bonus = data.range_bonus
end


function modifier_skeleton_king_mortal_strike_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
    MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_skeleton_king_mortal_strike_custom:CheckState()
if self.parent:PassivesDisabled() then return end
if not self.parent:HasTalent("modifier_skeleton_strike_4") then return end
if self.parent:HasModifier("modifier_skeleton_king_mortal_strike_cd") then return end
return
{
    [MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_skeleton_king_mortal_strike_custom:GetModifierBaseAttackTimeConstant()
if not self.parent:HasTalent("modifier_skeleton_strike_legendary") then return end
return self.base_bva + self.legendary_bva
end

function modifier_skeleton_king_mortal_strike_custom:GetModifierDamageOutgoing_Percentage()
if not self.parent:HasTalent("modifier_skeleton_strike_legendary") then return end
return self.legendary_damage
end

function modifier_skeleton_king_mortal_strike_custom:GetModifierAttackRangeBonus()
local bonus = self.range_bonus
if self.parent:HasTalent("modifier_skeleton_strike_4") and not self.parent:HasModifier("modifier_skeleton_king_mortal_strike_cd") and not self.parent:PassivesDisabled() then
    bonus = bonus + self.crit_range
end
return bonus
end

function modifier_skeleton_king_mortal_strike_custom:DamageEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.unit:IsUnit() then return end
if params.inflictor  then return end
if not self.record or self.record ~= params.record then return end
if params.original_damage < 0 then return end

local unit = params.unit

if self.parent:GetQuest() == "Wraith.Quest_7" and params.unit:IsRealHero() then 
    self.parent:UpdateQuest(math.floor(params.damage))
end

if self.parent:HasTalent("modifier_skeleton_strike_4") and not self.parent:HasBasher() then
    unit:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_mortal_strike_bash_count", {duration = self.bash_duration})
end

if self.parent:HasTalent("modifier_skeleton_strike_2") then 
    unit:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_mortal_strike_armor", {duration = self.armor_duration})
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_mortal_strike_armor", {duration = self.armor_duration})
end

if not self.parent:HasTalent("modifier_skeleton_strike_3") then return end
unit:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_mortal_strike_stack", {stack = self.delay_damage*params.original_damage, duration = self.delay_duration})
end


function modifier_skeleton_king_mortal_strike_custom:GetCritDamage() 
return self.crit
end

function modifier_skeleton_king_mortal_strike_custom:GetModifierPreAttack_CriticalStrike( params )
if not IsServer() then return end
self.record = nil

if not params.target:IsUnit() then return end
if self.parent:PassivesDisabled() then return end
if self.parent:HasModifier("modifier_skeleton_king_mortal_strike_cd") then return end

local crit = self.crit

if self.parent:HasModifier("modifier_skeleton_king_mortal_strike_legendary") then
    local mod = params.target:FindModifierByName("modifier_skeleton_king_mortal_strike_legendary_stack")
    if mod then
        crit = crit + mod:GetStackCount()*self.legendary_crit
    end
end

self.parent:RemoveGesture(ACT_DOTA_ATTACK_EVENT)
self.parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, self.parent:GetAttackSpeed(true))
self.record = params.record
return crit
end



function modifier_skeleton_king_mortal_strike_custom:GetModifierProcAttack_Feedback( params )
if not IsServer() then return end
if not self.record or self.record ~= params.record then return end

local target = params.target

if self.parent:HasTalent("modifier_skeleton_hero_7") and not self.parent:HasModifier("modifier_skeleton_king_mortal_strike_bkb_cd") and target:IsHero() then   
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {effect = 2, duration = self.bkb_duration})
    target:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_mortal_strike_bkb_speed", {duration = self.bkb_duration})
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_mortal_strike_bkb_cd", {duration = self.bkb_cd})
    self.parent:EmitSound("DOTA_Item.MinotaurHorn.Cast")
end 

if self.parent:HasTalent("modifier_skeleton_hero_2") then 
    DoCleaveAttack(self.parent, params.target, self.ability, params.damage*self.cleave_damage, 150, 360, 650, "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf")
end

if self.parent:HasTalent("modifier_skeleton_strike_legendary") then
    local mod = self.parent:FindModifierByName("modifier_skeleton_king_mortal_strike_legendary")
    local target_mod = target:FindModifierByName("modifier_skeleton_king_mortal_strike_legendary_stack")

    if mod then
        if target_mod then
            local vec = (target:GetAbsOrigin() - self.parent:GetAbsOrigin()):Normalized()
            local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
            ParticleManager:SetParticleControlEnt( coup_pfx, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
            ParticleManager:SetParticleControl( coup_pfx, 1, target:GetOrigin() )
            ParticleManager:SetParticleControlForward( coup_pfx, 1, -vec )
            ParticleManager:ReleaseParticleIndex( coup_pfx )

            params.target:EmitSound("WK.crit_hit")
            params.target:EmitSound("WK.crit_hit2")
            target_mod:Destroy()
            target:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_mortal_strike_legendary_heal_reduce", {duration = self.heal_reduce_duration})
        end
        mod:Destroy()
    else
        target:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_mortal_strike_legendary_stack", {duration = self.legendary_mark_duration})
    end
end

local sound = "Hero_SkeletonKing.CriticalStrike"
if self.parent:HasModifier("modifier_wraith_king_ti_8_weapon") or self.parent:HasModifier("modifier_wraith_king_ti_8_weapon_crimson") then
    sound = "Hero_SkeletonKing.CriticalStrike.TI8"
end

self.parent:EmitSound(sound)
	
local part = "particles/wraith_king/crit_normal.vpcf"
if self.parent:HasModifier("modifier_wraith_king_arcana_custom_v1") then
    part = "particles/wraith_king/crit_arcana_v1.vpcf"
elseif self.parent:HasModifier("modifier_wraith_king_arcana_custom_v2") then
    part = "particles/wraith_king/crit_arcana_v2.vpcf"
end

if self.parent:HasModifier("modifier_wraith_king_winterblight_custom") then 
    self.parent:GenericParticle("particles/econ/items/wraith_king/wraith_king_winterblight_weapon/wraith_king_winterblight_blur_critical.vpcf")
end 

self.parent:GenericParticle(part)

local cd_mod = self.parent:FindModifierByName("modifier_skeleton_king_reincarnation_custom_crit")
if cd_mod then
    cd_mod:Destroy()
    return
end

local cd = (self.cd + self.cd_inc)*self.parent:GetCooldownReduction()
self.parent:AddNewModifier(self.parent, self.ability, "modifier_skeleton_king_mortal_strike_cd", {duration = cd})

if not self.parent:HasTalent("modifier_skeleton_strike_legendary") then 
    self.ability:UseResources(false, false, false, true)
end

end



modifier_skeleton_king_mortal_strike_armor = class({})
function modifier_skeleton_king_mortal_strike_armor:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_armor:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_armor:GetTexture() return "buffs/strike_armor" end
function modifier_skeleton_king_mortal_strike_armor:RemoveOnDeath() return false end
function modifier_skeleton_king_mortal_strike_armor:OnCreated(table)

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.armor = self.caster:GetTalentValue("modifier_skeleton_strike_2", "armor")
self.max = self.caster:GetTalentValue("modifier_skeleton_strike_2", "max")

if self.parent == self.caster then
    self.armor = self.armor*-1
end

if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_skeleton_king_mortal_strike_armor:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()
end

function modifier_skeleton_king_mortal_strike_armor:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
}
end


function modifier_skeleton_king_mortal_strike_armor:GetModifierPhysicalArmorBonus()
return self:GetStackCount()*self.armor
end





modifier_skeleton_king_mortal_strike_legendary = class({})
function modifier_skeleton_king_mortal_strike_legendary:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_legendary:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_legendary:GetEffectName() return "particles/lc_attack_buf.vpcf" end
function modifier_skeleton_king_mortal_strike_legendary:GetStatusEffectName() return "particles/status_fx/status_effect_beserkers_call.vpcf" end
function modifier_skeleton_king_mortal_strike_legendary:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH  end

function modifier_skeleton_king_mortal_strike_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MODEL_SCALE
}
end

function modifier_skeleton_king_mortal_strike_legendary:GetModifierModelScale()
return 20
end


function modifier_skeleton_king_mortal_strike_legendary:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.ability:EndCd()

self.parent:EmitSound("WK.crit_buf")

self.parent:GenericParticle("particles/wraith_king/crit_legendary.vpcf", self, true)

self.effect_cast = ParticleManager:CreateParticle( "particles/wk_crit_buf.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
ParticleManager:SetParticleControl( self.effect_cast, 0, self.parent:GetAbsOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, self.parent:GetAbsOrigin() )
self:AddParticle(self.effect_cast,false, false, -1, false, false)
end


function modifier_skeleton_king_mortal_strike_legendary:OnDestroy()
if not IsServer() then return end
self.ability:StartCd()
end



modifier_skeleton_king_mortal_strike_legendary_stack = class({})
function modifier_skeleton_king_mortal_strike_legendary_stack:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_legendary_stack:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_legendary_stack:GetTexture() return "buffs/strike_legen_count" end
function modifier_skeleton_king_mortal_strike_legendary_stack:OnCreated(table)
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

if not IsServer() then return end
self.RemoveForDuel = true
self.effect_cast = self.parent:GenericParticle("particles/wk_stack.vpcf", self, true)
self:SetStackCount(1)
end

function modifier_skeleton_king_mortal_strike_legendary_stack:OnRefresh(table)
if not IsServer() then return end
self:IncrementStackCount()
end

function modifier_skeleton_king_mortal_strike_legendary_stack:OnStackCountChanged(iStackCount)
if not self.effect_cast then return end
self.ability.current_target = self.parent
self.ability:UpdateUI()
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end

function modifier_skeleton_king_mortal_strike_legendary_stack:OnDestroy()
if not IsServer() then return end
if not self.ability or not self.ability.current_target or self.ability.current_target ~= self.parent then return end

self.ability:UpdateUI()
end



modifier_skeleton_king_mortal_strike_stack = class({})
function modifier_skeleton_king_mortal_strike_stack:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_stack:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_stack:GetTexture() return "buffs/strike_stack" end
function modifier_skeleton_king_mortal_strike_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_skeleton_king_mortal_strike_stack:OnCreated(table)
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.damage = table.stack

self.slow_duration = self.caster:GetTalentValue("modifier_skeleton_strike_3", "duration")
self.damage_type = self.caster:GetTalentValue("modifier_skeleton_strike_3", "damage_type")
self:SetStackCount(self.damage)
end

function modifier_skeleton_king_mortal_strike_stack:OnDestroy()
if not IsServer() then return end
if not self.parent:IsAlive() then return end

self.parent:GenericParticle("particles/strike_wk_damage.vpcf")
self.parent:EmitSound("WK.Strike_damage")

local real = DoDamage( {victim = self.parent, attacker = self.caster, damage =  self.damage, damage_type = self.damage_type, ability = self.ability }, "modifier_skeleton_strike_3" )
self.parent:AddNewModifier(self.caster, self.ability, "modifier_skeleton_king_mortal_strike_slow", {duration = self.slow_duration})
end 



modifier_skeleton_king_mortal_strike_slow = class({})
function modifier_skeleton_king_mortal_strike_slow:IsHidden() return true end
function modifier_skeleton_king_mortal_strike_slow:IsPurgable() return true end
function modifier_skeleton_king_mortal_strike_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_skeleton_king_mortal_strike_slow:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_skeleton_strike_3", "slow")
end

function modifier_skeleton_king_mortal_strike_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

function modifier_skeleton_king_mortal_strike_slow:GetEffectName()
return "particles/items2_fx/sange_maim.vpcf"
end





modifier_skeleton_king_mortal_strike_cd = class(mod_cd)
function modifier_skeleton_king_mortal_strike_cd:IsHidden() return not self:GetParent():HasTalent("modifier_skeleton_strike_legendary") end



modifier_skeleton_king_mortal_strike_bkb_cd = class(mod_cd)
function modifier_skeleton_king_mortal_strike_bkb_cd:GetTexture() return "buffs/strike_bkb" end




modifier_skeleton_king_mortal_strike_legendary_heal_reduce = class({})
function modifier_skeleton_king_mortal_strike_legendary_heal_reduce:IsHidden() return false end
function modifier_skeleton_king_mortal_strike_legendary_heal_reduce:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_legendary_heal_reduce:OnCreated()

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.reduce = self.caster:GetTalentValue("modifier_skeleton_strike_legendary", "heal_reduce")
end

function modifier_skeleton_king_mortal_strike_legendary_heal_reduce:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end

function modifier_skeleton_king_mortal_strike_legendary_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.reduce
end

function modifier_skeleton_king_mortal_strike_legendary_heal_reduce:GetModifierHealAmplify_PercentageTarget() 
return self.reduce
end

function modifier_skeleton_king_mortal_strike_legendary_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.reduce
end

function modifier_skeleton_king_mortal_strike_legendary_heal_reduce:GetEffectName()
return "particles/items4_fx/spirit_vessel_damage.vpcf"
end



modifier_skeleton_king_mortal_strike_bash_count = class(mod_hidden)
function modifier_skeleton_king_mortal_strike_bash_count:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.bash = self.caster:GetTalentValue("modifier_skeleton_strike_4", "stun")
self.count = self.caster:GetTalentValue("modifier_skeleton_strike_4", "count")

self:SetStackCount(1)
end

function modifier_skeleton_king_mortal_strike_bash_count:OnRefresh()
if not IsServer() then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.count then
    self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_bashed", {duration = self.bash*(1 - self.parent:GetStatusResistance())})
    self.parent:EmitSound("BB.Goo_stun")
    self:Destroy()
end

end

modifier_skeleton_king_mortal_strike_bkb_speed = class({})
function modifier_skeleton_king_mortal_strike_bkb_speed:IsHidden() return true end
function modifier_skeleton_king_mortal_strike_bkb_speed:IsPurgable() return false end
function modifier_skeleton_king_mortal_strike_bkb_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_skeleton_hero_7", "speed")
if not IsServer() then return end
self:GetParent():GenericParticle("particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf", self, true)
end

function modifier_skeleton_king_mortal_strike_bkb_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_skeleton_king_mortal_strike_bkb_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end