LinkLuaModifier( "modifier_invoker_quas_custom_passive", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_quas_custom", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_quas_custom_heal", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_quas_custom_burn", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_cold_snap_custom", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_cold_snap_custom_stun", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_ghost_walk_custom", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_ghost_walk_custom_resist", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_ghost_walk_custom_debuff", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_ice_wall_custom", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_ice_wall_custom_slow", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_cold_snap_custom_legendary", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_cold_snap_custom_legendary_proc", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_cold_snap_custom_legendary_no", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_ice_wall_custom_root", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_cold_snap_custom_resist", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )




invoker_quas_custom = class({})

function invoker_quas_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
   
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_arcane_start.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_arcane_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ice_wall.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ice_wall_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_drow/drow_hypothermia_counter_stack.vpcf", context )
PrecacheResource( "particle", "particles/maiden_mark.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", context )
PrecacheResource( "particle", "particles/invoker/walk_resist.vpcf", context )
PrecacheResource( "particle", "particles/zuus_heal.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_dot_enemy.vpcf", context )
end

function invoker_quas_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_invoker_persona_1") or self:GetCaster():HasModifier("modifier_invoker_persona_2") or self:GetCaster():HasModifier("modifier_invoker_persona_3") or self:GetCaster():HasModifier("modifier_invoker_persona_4") or self:GetCaster():HasModifier("modifier_invoker_persona_5") or self:GetCaster():HasModifier("modifier_invoker_persona_6") then
    return "invoker_quas_persona1"
end
if self:GetCaster():HasModifier("modifier_magus_apex_custom") then
    return "invoker/magus_apex/invoker_quas"
end
return "invoker_quas"
end

function invoker_quas_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_invoker_quas_custom_passive"
end

function invoker_quas_custom:ProcsMagicStick()
return false
end

function invoker_quas_custom:OnSpellStart()
local caster = self:GetCaster()
local modifier = caster:AddNewModifier(
    caster,
    self,
    "modifier_invoker_quas_custom",
    {  }
)
self.invoke:AddOrb( modifier )
end


function invoker_quas_custom:OnUpgrade()
if not self.invoke then
    local invoke = self:GetCaster():FindAbilityByName( "invoker_invoke_custom" )
    if invoke:GetLevel()<1 then invoke:UpgradeAbility(true) end
    self.invoke = invoke
else
    self.invoke:UpdateOrb("modifier_invoker_quas_custom", self:GetLevel())
end

end



modifier_invoker_quas_custom = class({})
function modifier_invoker_quas_custom:IsHidden() return false end
function modifier_invoker_quas_custom:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE  end
function modifier_invoker_quas_custom:IsPurgable()  return false end


function modifier_invoker_quas_custom:OnCreated( kv )
self.caster = self:GetCaster()
self.health_regen = self:GetAbility():GetSpecialValueFor( "heal" )
end

function modifier_invoker_quas_custom:OnRefresh( kv )
self.health_regen = self:GetAbility():GetSpecialValueFor( "heal" )
end

function modifier_invoker_quas_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end

function modifier_invoker_quas_custom:GetModifierConstantHealthRegen()
if self.caster:HasShard() then return end
return self.health_regen
end






modifier_invoker_quas_custom_passive = class({})
function modifier_invoker_quas_custom_passive:IsHidden() return true end
function modifier_invoker_quas_custom_passive:IsPurgable() return false end
function modifier_invoker_quas_custom_passive:IsPurgeException() return false end

function modifier_invoker_quas_custom_passive:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.str = self.ability:GetSpecialValueFor("strength_bonus")

self.health_regen = self.ability:GetSpecialValueFor( "heal" )
self.shard_bonus = self.ability:GetSpecialValueFor("shard_bonus")/100

self.burn_duration = self.parent:GetTalentValue("modifier_invoker_quas_3", "duration", true)

self.parent:AddAttackEvent_out(self)

if not IsServer() then return end
self:StartIntervalThink(FrameTime())
end

function modifier_invoker_quas_custom_passive:OnRefresh()
self.health_regen = self.ability:GetSpecialValueFor( "heal" )
end


function modifier_invoker_quas_custom_passive:OnIntervalThink()
if not IsServer() then return end
local mod = self.parent:FindAllModifiersByName("modifier_invoker_quas_custom")
self:SetStackCount(#mod)
end

function modifier_invoker_quas_custom_passive:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
  MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}
end

function modifier_invoker_quas_custom_passive:GetModifierBonusStats_Strength()
return self.str*self.ability:GetLevel()
end

function modifier_invoker_quas_custom_passive:GetModifierConstantHealthRegen()
if not self.parent:HasShard() then return end
return 3*self.health_regen*(1 + self.shard_bonus)
end




function modifier_invoker_quas_custom_passive:AttackEvent_out(params)
if not IsServer() then return end 
if not self.parent:HasTalent("modifier_invoker_quas_3") then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

params.target:AddNewModifier(self.parent, self.ability, "modifier_invoker_quas_custom_burn", {duration = self.burn_duration + 0.1})
end





invoker_cold_snap_custom = class({})

function invoker_cold_snap_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_invoker_quas_1") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_quas_1", "cd")
end 
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function invoker_cold_snap_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self, level)
end

function invoker_cold_snap_custom:OnAbilityPhaseStart()
self:GetCaster():StartGesture(ACT_DOTA_CAST_COLD_SNAP)
return true
end

function invoker_cold_snap_custom:OnAbilityPhaseInterrupted()
self:GetCaster():FadeGesture(ACT_DOTA_CAST_COLD_SNAP)
end

function invoker_cold_snap_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") and self:GetCaster():FindAbilityByName("invoker_invoke_custom")  then 
    return "invoker_cold_snap_aghanim"
else
    return "invoker_cold_snap"
end

end



function invoker_cold_snap_custom:OnSpellStart()

local caster = self:GetCaster()
local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end

local duration = caster:GetValueQuas(self, "duration") + caster:GetTalentValue("modifier_invoker_quas_1", "duration")

local ability = caster:FindAbilityByName("invoker_invoke_custom")
if ability then 
    ability:AbilityHit(target)
end 

local ult = caster:FindAbilityByName("invoker_invoke_custom")
local scepter = 0

if caster:HasScepter() and ult and not caster:HasModifier("modifier_invoker_invoke_custom_scepter_cd") then
    scepter = 1
    ult:UseScepter()
end 

target:AddNewModifier( caster, self, "modifier_invoker_cold_snap_custom", {duration = duration})
target:AddNewModifier( caster, self, "modifier_invoker_quas_custom_heal", {is_scepter = scepter, duration = duration})

target:EmitSound("Hero_Invoker.ColdSnap.Cast")
target:EmitSound("Hero_Invoker.ColdSnap")
end




modifier_invoker_cold_snap_custom = class({})

function modifier_invoker_cold_snap_custom:IsPurgable()
if not self.parent:HasModifier("modifier_invoker_quas_custom_heal") then return true end
if self.parent:GetModifierStackCount("modifier_invoker_quas_custom_heal", self.caster) <= 0 then return true end
return false
end 

function modifier_invoker_cold_snap_custom:OnCreated( kv )

self.caster = self:GetCaster()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.heal = self.caster:GetValueQuas(self.ability, "freeze_heal") + self.caster:GetTalentValue("modifier_invoker_quas_2", "heal")*self.caster:GetMaxHealth()/100
self.duration = self.ability:GetSpecialValueFor("freeze_duration")
self.cooldown = self.caster:GetValueQuas(self.ability, "freeze_cooldown") + self.caster:GetTalentValue("modifier_invoker_quas_4", "interval")
self.threshold = self.ability:GetSpecialValueFor("damage_trigger")
self.legendary_duration = self.caster:GetTalentValue("modifier_invoker_quas_7", "duration")
self.resist_duration = self.caster:GetTalentValue("modifier_invoker_quas_4", "duration")

self.attack = self.caster:GetTalentValue("modifier_invoker_quas_2", "attack")

if not IsServer() then return end

self.parent:AddDamageEvent_inc(self)

self.cold_snap = self.ability
self.ghost_walk = self.caster:FindAbilityByName("invoker_ghost_walk_custom")
self.ice_wall = self.caster:FindAbilityByName("invoker_ice_wall_custom")

self.damage = self.caster:GetValueQuas(self.ability,  "freeze_damage")

self.onCooldown = false
self:Freeze(self.caster)
end




function modifier_invoker_cold_snap_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_invoker_cold_snap_custom:GetModifierAttackSpeedBonus_Constant()
if not self.caster:HasTalent("modifier_invoker_quas_2") then return end
if self.parent:HasModifier("modifier_invoker_ice_wall_custom_slow") then return end
return self.attack
end


function modifier_invoker_cold_snap_custom:DamageEvent_inc( params )
if not IsServer() then return end 
if not params.attacker then return end
if params.unit~=self.parent then return end
if params.damage<self.threshold and params.damage ~= 0 then return end
if self.onCooldown then return end

self:Freeze(params.attacker)
end


function modifier_invoker_cold_snap_custom:OnIntervalThink()
self.onCooldown = false
self:StartIntervalThink(-1)
end

function modifier_invoker_cold_snap_custom:Freeze(attacker)
if self.onCooldown then return end

self.onCooldown = true
local damageTable = 
{ 
    victim = self.parent,
    attacker = self.caster,
    damage = self.damage,
    damage_type = self.ability:GetAbilityDamageType(),
    ability = self.ability 
}

local real_damage = DoDamage(damageTable)

if self.caster:GetQuest() == "Invoker.Quest_5" and not self.caster:QuestCompleted() and self.parent:IsRealHero() then 
    self.caster:UpdateQuest(1)
end 

if self.caster:HasTalent("modifier_invoker_quas_7") and not self.parent:HasModifier("modifier_invoker_cold_snap_custom_legendary_proc") then 
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_invoker_cold_snap_custom_legendary", {duration = self.legendary_duration})
end 

if self.caster:HasTalent("modifier_invoker_quas_4") then 
  self.parent:AddNewModifier(self.caster, self.ability, "modifier_invoker_cold_snap_custom_resist", {duration = self.resist_duration})
end 

self:PlayEffects( attacker )

if not self.parent:IsIllusion() and self.parent:HasModifier("modifier_invoker_quas_custom_heal") then
    self.caster:GenericHeal(self.heal, self.ability, nil, nil)
end

self.parent:AddNewModifier( self.caster, self.ability, "modifier_invoker_cold_snap_custom_stun", { duration = self.duration*(1 - self.parent:GetStatusResistance()) } )
self:StartIntervalThink( self.cooldown )
end



function modifier_invoker_cold_snap_custom:GetEffectName()
return "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf"
end

function modifier_invoker_cold_snap_custom:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_invoker_cold_snap_custom:PlayEffects( attacker )
local direction = self.parent:GetOrigin()-attacker:GetOrigin()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( effect_cast, 1,  attacker:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )
self.parent:EmitSound("Hero_Invoker.ColdSnap.Freeze")
end




modifier_invoker_quas_custom_heal = class({})
function modifier_invoker_quas_custom_heal:IsHidden() return true end
function modifier_invoker_quas_custom_heal:IsPurgable() return self:GetStackCount() ==0 end
function modifier_invoker_quas_custom_heal:OnCreated(table)

self.status = self:GetAbility():GetSpecialValueFor("scepter_status")    
if not IsServer() then return end
self:SetStackCount(table.is_scepter)
end

function modifier_invoker_quas_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end

function modifier_invoker_quas_custom_heal:GetModifierStatusResistanceStacking() 
if self:GetStackCount() == 0 then return end
return self.status
end





modifier_invoker_cold_snap_custom_stun = class({})
function modifier_invoker_cold_snap_custom_stun:IsHidden() return true end
function modifier_invoker_cold_snap_custom_stun:IsPurgable() return false end
function modifier_invoker_cold_snap_custom_stun:IsPurgeException() return true end
function modifier_invoker_cold_snap_custom_stun:IsStunDebuff() return true end
function modifier_invoker_cold_snap_custom_stun:CheckState()
return
{
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_FROZEN] = true
}
end


function modifier_invoker_cold_snap_custom_stun:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_invoker_cold_snap_custom_stun:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end




invoker_ghost_walk_custom = class({})

function invoker_ghost_walk_custom:CreateTalent()
self:ToggleAutoCast()
end

function invoker_ghost_walk_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasTalent("modifier_invoker_quas_6") then 
  bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 
return bonus + DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES
end


function invoker_ghost_walk_custom:GetCooldown(level)
local bonus = 0 
if self:GetCaster():HasTalent("modifier_invoker_quas_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_quas_6", "cd")
end 
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function invoker_ghost_walk_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_invoker_persona_1") or self:GetCaster():HasModifier("modifier_invoker_persona_2") or self:GetCaster():HasModifier("modifier_invoker_persona_3") or self:GetCaster():HasModifier("modifier_invoker_persona_4") or self:GetCaster():HasModifier("modifier_invoker_persona_5") or self:GetCaster():HasModifier("modifier_invoker_persona_6") then
    return "invoker_ghost_walk_persona1"
end
return "invoker_ghost_walk"
end

function invoker_ghost_walk_custom:OnSpellStart()

local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_CAST_GHOST_WALK)

local duration = caster:GetValueWex(self, "duration")

if self:GetAutoCastState() and caster:HasTalent("modifier_invoker_quas_6") and not caster:IsRooted() and not caster:IsLeashed() then

    local distance = caster:GetTalentValue("modifier_invoker_quas_6", "range")
    local point = caster:GetAbsOrigin() + caster:GetForwardVector()*distance

    caster:EmitSound("Puck.Rift_Legendary")
    local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_start.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(effect, 0, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(effect)

    FindClearSpaceForUnit(caster, point, true)

    effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_end.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster)
    ParticleManager:SetParticleControl(effect, 0, caster:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(effect)
end 

caster:AddNewModifier( caster, self, "modifier_invoker_ghost_walk_custom", { duration = duration } )
caster:GenericParticle("particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf")
caster:EmitSound("Hero_Invoker.GhostWalk")
end





modifier_invoker_ghost_walk_custom = class({})

function modifier_invoker_ghost_walk_custom:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.parent:AddAttackStartEvent_out(self)
self.parent:AddSpellEvent(self)

self.radius = self.ability:GetSpecialValueFor( "area_of_effect" )
self.aura_duration = self.ability:GetSpecialValueFor( "aura_fade_time" )
self.self_slow = self.parent:GetValueWex(self.ability, "self_slow")
self.enemy_slow = self.parent:GetValueQuas(self.ability, "enemy_slow")
self.health_regen = self.parent:GetValueQuas(self.ability, "health_regen")
self.mana_regen = self.parent:GetValueWex(self.ability, "mana_regen")

self.legendary_damage = self.parent:GetTalentValue("modifier_invoker_quas_7", "damage")
self.legendary_interval = self.parent:GetTalentValue("modifier_invoker_quas_7", "interval") - FrameTime()

self.more_duration = self.parent:GetTalentValue("modifier_invoker_quas_6", "duration")
if not IsServer() then return end

self.allow_abilities =
{
    ["invoker_quas_custom"] = true,
    ["invoker_wex_custom"] = true,
    ["invoker_exort_custom"] = true,
    ["invoker_invoke_custom"] = true,
}

self.ended = false

if not self.parent:HasTalent("modifier_invoker_quas_7") then return end

self:OnIntervalThink()
self:StartIntervalThink(self.legendary_interval)
end


function modifier_invoker_ghost_walk_custom:OnRefresh()
self.ended = false
end 

function modifier_invoker_ghost_walk_custom:OnIntervalThink()
if not IsServer() then return end

local targets = self.parent:FindTargets(self.radius)

for _,target in pairs(targets) do
  DoDamage({victim = target, attacker = self.parent, damage = self.legendary_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability})
end 

end


function modifier_invoker_ghost_walk_custom:IsAura() return true end
function modifier_invoker_ghost_walk_custom:GetModifierAura() return "modifier_invoker_ghost_walk_custom_debuff" end
function modifier_invoker_ghost_walk_custom:GetAuraRadius() return self.radius end
function modifier_invoker_ghost_walk_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_invoker_ghost_walk_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_invoker_ghost_walk_custom:GetAuraDuration() return self.aura_duration end
function modifier_invoker_ghost_walk_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
}
end



function modifier_invoker_ghost_walk_custom:SpellEvent( params )
if not IsServer() then return end
if self.allow_abilities[params.ability:GetName()] then return end
if params.unit ~= self.parent then return end
if self.ended then return end 

self.ended = true

if self.parent:HasTalent("modifier_invoker_quas_6") then 
  self:SetDuration(self.more_duration, true)
else 
  self:Destroy()
end

end

function modifier_invoker_ghost_walk_custom:AttackStartEvent_out(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker ~= self.parent then return end
if self.ended then return end 

self.ended = true

if self.parent:HasTalent("modifier_invoker_quas_6") then 
  self:SetDuration(self.more_duration, true)
else 
  self:Destroy()
end

end

function modifier_invoker_ghost_walk_custom:GetModifierConstantHealthRegen() return self.health_regen end
function modifier_invoker_ghost_walk_custom:GetModifierConstantManaRegen() return self.mana_regen end
function modifier_invoker_ghost_walk_custom:GetModifierMoveSpeedBonus_Percentage() return self.self_slow end
function modifier_invoker_ghost_walk_custom:GetModifierInvisibilityLevel() return 1 end



function modifier_invoker_ghost_walk_custom:CheckState()
local state_table = 
{
    [MODIFIER_STATE_INVISIBLE] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}

if self.parent:HasTalent("modifier_invoker_quas_6") then
    state_table[MODIFIER_STATE_UNSLOWABLE] = true
end

return state_table
end






modifier_invoker_ghost_walk_custom_debuff = class({})
function modifier_invoker_ghost_walk_custom_debuff:IsPurgable() return false end

function modifier_invoker_ghost_walk_custom_debuff:OnCreated()
self.enemy_slow = self:GetCaster():GetValueQuas(self:GetAbility(), "enemy_slow")
end

function modifier_invoker_ghost_walk_custom_debuff:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_invoker_ghost_walk_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.enemy_slow
end

function modifier_invoker_ghost_walk_custom_debuff:GetEffectName() return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf" end
function modifier_invoker_ghost_walk_custom_debuff:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_invoker_ghost_walk_custom_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_invoker_ghost_walk_custom_debuff:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL  end







invoker_ice_wall_custom = class({})

function invoker_ice_wall_custom:GetAbilityTextureName()
return "invoker_ice_wall"
end

function invoker_ice_wall_custom:CreateTalent()
self:UpdateVectorValues()
end

function invoker_ice_wall_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level )
end

function invoker_ice_wall_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_invoker_quas_5") then 
  return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING
end 
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end

function invoker_ice_wall_custom:GetCastRange(vLocation, hTarget)
if not self:GetCaster():HasTalent("modifier_invoker_quas_5") then return end 
return self:GetCaster():GetTalentValue("modifier_invoker_quas_5", "range")
end 




function invoker_ice_wall_custom:OnVectorCastStart(vStartLocation, vDirection)

local caster = self:GetCaster()
local target = self:GetCursorPosition()
if target == caster:GetAbsOrigin() then 
  target = caster:GetAbsOrigin() + caster:GetForwardVector()*1
end

local spacing = self:GetSpecialValueFor("wall_element_spacing")
local num = self:GetSpecialValueFor("num_wall_elements")
local ice_wall_length = spacing*num

local pos1 = GetGroundPosition(self:GetVectorPosition() + (ice_wall_length/2)*vDirection, nil)
local pos2 = GetGroundPosition(self:GetVectorPosition() - (ice_wall_length/2)*vDirection, nil)

local ice_wall_duration  = caster:GetValueQuas(self, "duration")

caster:StartGesture(ACT_DOTA_CAST_ICE_WALL)
caster:EmitSound("Hero_Invoker.IceWall.Cast")

CreateModifierThinker(caster, self, "modifier_invoker_ice_wall_custom", 
{
    duration = ice_wall_duration,  
    start_x = pos1.x,
    start_y = pos1.y,
    start_z = pos1.z,
    end_x = pos2.x,
    end_y = pos2.y,
    end_z = pos2.z
}, 
self:GetVectorPosition(), caster:GetTeamNumber(), false)

end


function invoker_ice_wall_custom:OnSpellStart()

local caster                        = self:GetCaster()
local caster_direction              = caster:GetForwardVector()
local ice_wall_duration             = caster:GetValueQuas(self, "duration")
local ice_wall_placement_distance   = self:GetSpecialValueFor("wall_place_distance")
local target_point = caster:GetAbsOrigin() + caster_direction * ice_wall_placement_distance


caster:StartGesture(ACT_DOTA_CAST_ICE_WALL)
caster:EmitSound("Hero_Invoker.IceWall.Cast")

CreateModifierThinker(caster, self, "modifier_invoker_ice_wall_custom", {duration = ice_wall_duration,  }, target_point, caster:GetTeamNumber(), false)
end




modifier_invoker_ice_wall_custom = class({})


function modifier_invoker_ice_wall_custom:CreateWall(kv)
if not IsServer() then return end
local index = #self.walls + 1

self.walls[index] = {}


local caster_direction  = self.caster:GetForwardVector()
local cast_direction = Vector(-caster_direction.y, caster_direction.x, caster_direction.z)
local endpoint_distance_from_center   = (cast_direction * self.ice_wall_length) / 2
local ice_wall_point = GetGroundPosition(self.parent:GetAbsOrigin(), nil)

if (kv.start_x) then 
  self.walls[index].ice_wall_start_point = Vector(kv.start_x, kv.start_y, kv.start_z)
  self.walls[index].ice_wall_end_point = Vector(kv.end_x, kv.end_y, kv.end_z)
else 
  self.walls[index].ice_wall_start_point  = ice_wall_point - endpoint_distance_from_center
  self.walls[index].ice_wall_end_point   = ice_wall_point + endpoint_distance_from_center
end

local ice_wall_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall.vpcf", PATTACH_CUSTOMORIGIN, nil)
ParticleManager:SetParticleControl(ice_wall_particle_effect, 0, self.walls[index].ice_wall_start_point)
ParticleManager:SetParticleControl(ice_wall_particle_effect, 1, self.walls[index].ice_wall_end_point  )
self:AddParticle(ice_wall_particle_effect, false, false, -1, false, true)

local ice_spikes_particle_effect  = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
ParticleManager:SetParticleControl(ice_spikes_particle_effect, 0, self.walls[index].ice_wall_start_point)
ParticleManager:SetParticleControl(ice_spikes_particle_effect, 1, self.walls[index].ice_wall_end_point  )
self:AddParticle(ice_spikes_particle_effect, false, false, -1, false, true)
end


function modifier_invoker_ice_wall_custom:OnCreated(kv)
if not IsServer() then return end

self.ability = self:GetAbility()
self.caster = self:GetCaster()
self.parent = self:GetParent()

self.hit_targets = {}
self.walls = {}

local spacing = self.ability:GetSpecialValueFor("wall_element_spacing")
local num = self.ability:GetSpecialValueFor("num_wall_elements")

self.ice_wall_length = spacing*num

self:CreateWall(kv)

if self.caster:HasTalent("modifier_invoker_quas_5") and self.walls[1] then

    local dir = (self.walls[1].ice_wall_end_point - self.walls[1].ice_wall_start_point):Normalized()
    
    dir = Vector(-dir.y, dir.x, 0)

    local pos1 = self.parent:GetAbsOrigin() + dir*self.ice_wall_length/2
    local pos2 = self.parent:GetAbsOrigin() - dir*self.ice_wall_length/2

    self:CreateWall({
        start_x = pos1.x,
        start_y = pos1.y,
        start_z = pos1.z,
        end_x = pos2.x,
        end_y = pos2.y,
        end_z = pos2.z
    })
end 

self.slow_duration   = self.ability:GetSpecialValueFor("slow_duration") + self.caster:GetTalentValue("modifier_invoker_quas_2", "duration")
self.ice_wall_slow  = self.ability:GetSpecialValueFor("slow")
self.ice_wall_area_of_effect  = 35
self.search_area  = self.ice_wall_length + (self.ice_wall_area_of_effect * 2)
self.origin  = self.parent:GetAbsOrigin()

self.max_count = 0.5 
self.damage = self.caster:GetValueExort(self.ability, "damage_per_second")*self.max_count

self.resist_duration = self.caster:GetTalentValue("modifier_invoker_quas_4", "duration")

self.heroes_hit = false

self.snap = self.caster:FindAbilityByName("invoker_cold_snap_custom")
self.snap_duration = self.caster:GetTalentValue("modifier_invoker_quas_7", "wall_duration")

self.interval = 0.05
self.count = self.max_count

self.root_duration = self.caster:GetTalentValue("modifier_invoker_quas_5", "root")
self.root_targets = {}

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end


function modifier_invoker_ice_wall_custom:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + self.interval
local nearby_enemy_units = self.caster:FindTargets(self.search_area, self.origin)

for _,enemy in pairs(nearby_enemy_units) do
  if self:IsUnitInProximity(enemy:GetAbsOrigin()) then

    if self.count >= self.max_count then 
      if self.snap and self.caster:HasTalent("modifier_invoker_quas_7") then 
        enemy:AddNewModifier( self.caster, self.snap, "modifier_invoker_cold_snap_custom", {duration = self.snap_duration } )
      end 

      if not self.root_targets[enemy] and self.caster:HasTalent("modifier_invoker_quas_5") then 
        self.root_targets[enemy] = true
        enemy:AddNewModifier(self.caster, self.ability, "modifier_invoker_ice_wall_custom_root", {duration = (1 - enemy:GetStatusResistance())*self.root_duration})
      end 

      if not self.hit_targets[enemy] then 
        self.hit_targets[enemy] = true
        local ability = self.caster:FindAbilityByName("invoker_invoke_custom")
        if ability then 
            ability:AbilityHit(enemy)
        end 
      end 

      DoDamage({victim = enemy, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability})
      
      if self.caster:HasTalent("modifier_invoker_quas_4") then 
        enemy:AddNewModifier(self.caster, self.ability, "modifier_invoker_cold_snap_custom_resist", {duration = self.resist_duration})
      end 
    end

    enemy:AddNewModifier(self.caster, self.ability, "modifier_invoker_ice_wall_custom_slow", {duration = self.slow_duration})
  end
end

if self.count >= self.max_count then 
  self.count = 0
end 

end


function modifier_invoker_ice_wall_custom:IsUnitInProximity(target_position)

local hit = false

for _,data in pairs(self.walls) do

    local ice_wall = data.ice_wall_end_point - data.ice_wall_start_point
    local target_vector = target_position - data.ice_wall_start_point
    local ice_wall_normalized = ice_wall:Normalized()
    local ice_wall_dot_vector = target_vector:Dot(ice_wall_normalized)
    local search_point
    if ice_wall_dot_vector <= 0 then
        search_point = data.ice_wall_start_point
    elseif ice_wall_dot_vector >= ice_wall:Length2D() then
        search_point = data.ice_wall_end_point
    else
        search_point = data.ice_wall_start_point + (ice_wall_normalized * ice_wall_dot_vector)
    end 
    local distance = target_position - search_point

    if distance:Length2D() <= self.ice_wall_area_of_effect*3 then
        hit = true
        break
    end
end

return hit
end






modifier_invoker_ice_wall_custom_slow = class({})
function modifier_invoker_ice_wall_custom_slow:IsPurgable() return false end
function modifier_invoker_ice_wall_custom_slow:IsHidden() return false end
function modifier_invoker_ice_wall_custom_slow:GetEffectName() return "particles/units/heroes/hero_invoker/invoker_ice_wall_debuff.vpcf" end
function modifier_invoker_ice_wall_custom_slow:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_invoker_ice_wall_custom_slow:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL  end
function modifier_invoker_ice_wall_custom_slow:OnCreated(table)
self.caster = self:GetCaster()
self.slow = self.caster:GetValueQuas(self:GetAbility(), "slow")
self.attack = self.caster:GetTalentValue("modifier_invoker_quas_2", "attack")

if not IsServer() then return end

end


function modifier_invoker_ice_wall_custom_slow:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_invoker_ice_wall_custom_slow:GetModifierAttackSpeedBonus_Constant()
if not self.caster:HasTalent("modifier_invoker_quas_2") then return end
return self.attack
end

function modifier_invoker_ice_wall_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end






modifier_invoker_quas_custom_burn = class({})
function modifier_invoker_quas_custom_burn:IsHidden() return true end
function modifier_invoker_quas_custom_burn:IsPurgable() return true end
function modifier_invoker_quas_custom_burn:OnCreated()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.heal_reduce = self.caster:GetTalentValue("modifier_invoker_quas_3", "heal_reduce")
self.damage = self.caster:GetTalentValue("modifier_invoker_quas_3", "damage")
self.interval = self.caster:GetTalentValue("modifier_invoker_quas_3", "interval")

self.parent = self:GetParent()
self.damageTable = {victim = self.parent, attacker = self.caster, damage = self.damage*self.interval, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}
if not IsServer() then return end
self.parent:GenericParticle("particles/units/heroes/hero_invoker/invoker_dot_enemy.vpcf", self)
self:StartIntervalThink(self.interval)
end


function modifier_invoker_quas_custom_burn:OnIntervalThink()
if not IsServer() then return end
DoDamage(self.damageTable, "modifier_invoker_quas_3")
end

function modifier_invoker_quas_custom_burn:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_invoker_quas_custom_burn:GetModifierLifestealRegenAmplify_Percentage() 
return self.heal_reduce
end

function modifier_invoker_quas_custom_burn:GetModifierHealAmplify_PercentageTarget()
return self.heal_reduce
end

function modifier_invoker_quas_custom_burn:GetModifierHPRegenAmplify_Percentage() 
return self.heal_reduce
end







modifier_invoker_cold_snap_custom_legendary = class({})
function modifier_invoker_cold_snap_custom_legendary:IsHidden() return true end
function modifier_invoker_cold_snap_custom_legendary:IsPurgable() return false end
function modifier_invoker_cold_snap_custom_legendary:GetTexture() return "buffs/arc_speed" end
function modifier_invoker_cold_snap_custom_legendary:OnCreated()

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.max = self.caster:GetTalentValue("modifier_invoker_quas_7", "max")
self.stun = self.caster:GetTalentValue("modifier_invoker_quas_7", "stun")

if not IsServer() then return end 

self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_drow/drow_hypothermia_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end 

function modifier_invoker_cold_snap_custom_legendary:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
  self.parent:AddNewModifier(self.caster, self:GetAbility(), "modifier_invoker_cold_snap_custom_legendary_proc", {duration = self.stun})
  self:Destroy()
end 

end 

function modifier_invoker_cold_snap_custom_legendary:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then return end 
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end





modifier_invoker_cold_snap_custom_legendary_proc = class({})
function modifier_invoker_cold_snap_custom_legendary_proc:IsHidden() return true end
function modifier_invoker_cold_snap_custom_legendary_proc:IsPurgable() return false end
function modifier_invoker_cold_snap_custom_legendary_proc:IsPurgeException() return true end
function modifier_invoker_cold_snap_custom_legendary_proc:IsStunDebuff() return true end
function modifier_invoker_cold_snap_custom_legendary_proc:CheckState()
return
{
  [MODIFIER_STATE_STUNNED] = true,
  [MODIFIER_STATE_FROZEN] = true
}
end


function modifier_invoker_cold_snap_custom_legendary_proc:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_invoker_cold_snap_custom_legendary_proc:StatusEffectPriority()
return MODIFIER_PRIORITY_ULTRA 
end


function modifier_invoker_cold_snap_custom_legendary_proc:OnCreated()

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.damage = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "health")/100
self.creeps = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "creeps")

if not IsServer() then return end 

self.damage_flag = RandomInt(100, 1000)
self.parent:AddDamageEvent_inc(self)

self.mark = ParticleManager:CreateParticle( "particles/maiden_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle(self.mark,false, false, -1, false, false)
self.parent:EmitSound("Maiden.Frostbite_max_slow")
end 


function modifier_invoker_cold_snap_custom_legendary_proc:DamageEvent_inc( params )
if not IsServer() then return end 
if self.caster:GetTeamNumber() ~= params.attacker:GetTeamNumber() then return end
if params.unit~=self.parent then return end
if params.damage<10 and params.damage ~= 0 then return end
if bit.band(params.damage_flags, self.damage_flag) == self.damage_flag then return end

self.parent:AddNewModifier(self.parent, nil, "modifier_invoker_cold_snap_custom_legendary_no", {duration = FrameTime()})

local damage = self.damage*self.parent:GetMaxHealth()

if self.parent:IsCreep() then 
  damage = math.min(damage, self.creeps)
end 

local damageTable = 
{ 
    victim = self.parent,
    attacker = self.caster,
    damage = damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self:GetAbility(),
    damage_flags = self.damage_flag
}

local real_damage = DoDamage(damageTable, "modifier_invoker_quas_7")
self.parent:SendNumber(4, real_damage)

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", PATTACH_POINT_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( effect_cast, 1,  params.attacker:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self.parent:EmitSound("Invoker.Legendary_snap_damage")
end



modifier_invoker_cold_snap_custom_legendary_no = class({})
function modifier_invoker_cold_snap_custom_legendary_no:IsHidden() return true end
function modifier_invoker_cold_snap_custom_legendary_no:IsPurgable() return false end



modifier_invoker_ice_wall_custom_root = class({})
function modifier_invoker_ice_wall_custom_root:IsHidden() return true end
function modifier_invoker_ice_wall_custom_root:IsPurgable() return true end
function modifier_invoker_ice_wall_custom_root:CheckState()
return
{
  [MODIFIER_STATE_ROOTED] = true
}
end

function modifier_invoker_ice_wall_custom_root:OnCreated()
if not IsServer() then return end 
self:GetParent():EmitSound("hero_Crystal.frostbite")
end

function modifier_invoker_ice_wall_custom_root:OnDestroy()
if not IsServer() then return end 
self:GetParent():StopSound("hero_Crystal.frostbite")
end

function modifier_invoker_ice_wall_custom_root:GetEffectName() return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf" end
function modifier_invoker_ice_wall_custom_root:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_invoker_ice_wall_custom_root:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_invoker_ice_wall_custom_root:StatusEffectPriority() return MODIFIER_PRIORITY_HIGH  end






modifier_invoker_cold_snap_custom_resist = class({})
function modifier_invoker_cold_snap_custom_resist:IsHidden() return false end
function modifier_invoker_cold_snap_custom_resist:IsPurgable() return false end
function modifier_invoker_cold_snap_custom_resist:GetTexture() return "buffs/quas_resist" end
function modifier_invoker_cold_snap_custom_resist:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_invoker_quas_4", "max")
self.resist = self:GetCaster():GetTalentValue("modifier_invoker_quas_4", "magic")

if not IsServer() then return end 
self:SetStackCount(1)
end

function modifier_invoker_cold_snap_custom_resist:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 
self:IncrementStackCount()
end 


function modifier_invoker_cold_snap_custom_resist:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
}
end

function modifier_invoker_cold_snap_custom_resist:GetModifierMagicalResistanceBonus()
return self.resist*self:GetStackCount()
end





