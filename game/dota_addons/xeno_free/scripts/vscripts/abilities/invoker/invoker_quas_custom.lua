LinkLuaModifier( "modifier_invoker_quas_custom_passive", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_quas_custom", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_cold_snap_custom", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_cold_snap_custom_stun", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_ghost_walk_custom", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_ghost_walk_custom_heal", "abilities/invoker/invoker_quas_custom", LUA_MODIFIER_MOTION_NONE )
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
   
end


function invoker_quas_custom:GetIntrinsicModifierName()
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

function modifier_invoker_quas_custom:IsHidden()
    return false
end

function modifier_invoker_quas_custom:IsDebuff()
    return false
end

function modifier_invoker_quas_custom:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_invoker_quas_custom:IsPurgable()
    return false
end







modifier_invoker_quas_custom_passive = class({})

function modifier_invoker_quas_custom_passive:IsHidden() return true end
function modifier_invoker_quas_custom_passive:IsPurgable() return false end
function modifier_invoker_quas_custom_passive:IsPurgeException() return false end

function modifier_invoker_quas_custom_passive:OnCreated()

self.str = self:GetAbility():GetSpecialValueFor("strength_bonus")

if not IsServer() then return end
self:StartIntervalThink(FrameTime())
end



function modifier_invoker_quas_custom_passive:OnIntervalThink()
if not IsServer() then return end
local mod = self:GetCaster():FindAllModifiersByName("modifier_invoker_quas_custom")
self:SetStackCount(#mod)
end

function modifier_invoker_quas_custom_passive:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
}
end

function modifier_invoker_quas_custom_passive:GetModifierBonusStats_Strength()
return self.str*self:GetAbility():GetLevel()
end







invoker_cold_snap_custom = class({})

function invoker_cold_snap_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", context )
end





function invoker_cold_snap_custom:GetCooldown(level)

local bonus = 0
if self:GetCaster():HasModifier("modifier_invoker_quas_1") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_quas_1", "cd")
end 

return (self.BaseClass.GetCooldown( self, level ) + bonus) * (1 - self:GetCaster():GetWexCd()/100)
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
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_cold_snap_aghanim"
else
    return "invoker_cold_snap"
end

end



function invoker_cold_snap_custom:OnSpellStart()
if not IsServer() then return end

local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end

local duration = self:GetCaster():GetValueQuas(self, "duration") + self:GetCaster():GetTalentValue("modifier_invoker_quas_2", "duration")

if target:IsRealHero() == true then 
    local mod = self:GetCaster():FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")

    if mod then 
       -- mod:AddStack()
    end 

    local ability = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
    if ability then 
        ability:AbilityHit()
    end 

end


local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
local scepter = 0

if self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true
    and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then

    scepter = 1
    ult:UseScepter()
end 



target:AddNewModifier( self:GetCaster(), self, "modifier_invoker_cold_snap_custom", {is_scepter = scepter, cast = 1, quas = self:GetCaster():GetQuasHeal(), exort = self:GetCaster():GetExortDamage(), duration = duration } )

target:EmitSound("Hero_Invoker.ColdSnap.Cast")
target:EmitSound("Hero_Invoker.ColdSnap")
end






modifier_invoker_cold_snap_custom = class({})


function modifier_invoker_cold_snap_custom:IsPurgable()
return self.is_scepter == 0
end 

function modifier_invoker_cold_snap_custom:OnCreated( kv )

self.heal = self:GetCaster():GetValueQuas(self:GetAbility(), "freeze_heal")
self.duration = self:GetAbility():GetSpecialValueFor("freeze_duration")
self.cooldown = self:GetCaster():GetValueQuas(self:GetAbility(), "freeze_cooldown") + self:GetCaster():GetTalentValue("modifier_invoker_quas_4", "interval")
self.threshold = self:GetAbility():GetSpecialValueFor("damage_trigger")


self.legendary_duration = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "duration")
self.resist_duration = self:GetCaster():GetTalentValue("modifier_invoker_quas_4", "duration")

if not IsServer() then return end


self.is_scepter = kv.is_scepter

if self.is_scepter == 1 then 
    self.heal = self.heal + self:GetAbility():GetSpecialValueFor("scepter_heal")
end 

self.cast = kv.cast

self.cold_snap = self:GetAbility()
self.ghost_walk = self:GetCaster():FindAbilityByName("invoker_ghost_walk_custom")
self.ice_wall = self:GetCaster():FindAbilityByName("invoker_ice_wall_custom")

self.damage = self:GetCaster():GetValueQuas(self:GetAbility(),  "freeze_damage") + self:GetCaster():GetTalentValue("modifier_invoker_quas_1", "damage")

self.quas_heal = kv.quas/100
self.exort_damage = kv.exort/100

if self.exort_damage and self.exort_damage > 0 then 
  self.damage = self.damage * (1 + self.exort_damage)
end 

print(self.damage)

self.onCooldown = false
self:Freeze(self:GetCaster())

end


function modifier_invoker_cold_snap_custom:OnRefresh(kv)
if not IsServer() then return end 

if kv.cast and kv.cast == 1 then 
  self.cast = kv.cast
end

if self.is_scepter == 1 then return end

self.is_scepter = kv.is_scepter

if self.is_scepter == 1 then 
    self.heal = self.heal + self:GetAbility():GetSpecialValueFor("scepter_heal")
end 



end 



function modifier_invoker_cold_snap_custom:DeclareFunctions()
local funcs = 
{
    MODIFIER_EVENT_ON_TAKEDAMAGE,
}
return funcs
end





function modifier_invoker_cold_snap_custom:OnTakeDamage( params )
if not IsServer() then return end 
if params.unit~=self:GetParent() then return end


if params.damage<self.threshold then return end
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
    victim = self:GetParent(),
    attacker = self:GetCaster(),
    damage = self.damage,
    damage_type = self:GetAbility():GetAbilityDamageType(),
    ability = self:GetAbility() 
}

local real_damage = ApplyDamage(damageTable)

if self.quas_heal and self.quas_heal > 0 and not self:GetParent():IsIllusion() then

    local heal = real_damage*self.quas_heal
    if self:GetParent():IsCreep() then 
        heal = heal/3
    end 

    self:GetCaster():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
end

if self:GetCaster():GetQuest() == "Invoker.Quest_5" and not self:GetCaster():QuestCompleted() and self:GetParent():IsRealHero() then 
    self:GetCaster():UpdateQuest(1)
end 


if self:GetCaster():HasModifier("modifier_invoker_quas_7") and not self:GetParent():HasModifier("modifier_invoker_cold_snap_custom_legendary_proc") then 
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_cold_snap_custom_legendary", {duration = self.legendary_duration})
end 

if self:GetCaster():HasModifier("modifier_invoker_quas_4") then 
  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_cold_snap_custom_resist", {duration = self.resist_duration})
end 

self:PlayEffects( attacker )

if not self:GetParent():IsIllusion() then 
    self:GetCaster():GenericHeal(self.heal, self:GetAbility())
end

self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_invoker_cold_snap_custom_stun", { duration = self.duration*(1 - self:GetParent():GetStatusResistance()) } )
self:StartIntervalThink( self.cooldown )
end



function modifier_invoker_cold_snap_custom:GetEffectName()
    return "particles/units/heroes/hero_invoker/invoker_cold_snap_status.vpcf"
end

function modifier_invoker_cold_snap_custom:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_invoker_cold_snap_custom:PlayEffects( attacker )
local direction = self:GetParent():GetOrigin()-attacker:GetOrigin()

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( effect_cast, 1,  attacker:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound("Hero_Invoker.ColdSnap.Freeze")
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
return 9999
end












invoker_ghost_walk_custom = class({})

function invoker_ghost_walk_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf", context )
end



function invoker_ghost_walk_custom:GetCooldown(level)
local bonus = 0 
if self:GetCaster():HasModifier("modifier_invoker_quas_3") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_quas_3", "cd")
end 
return (self.BaseClass.GetCooldown( self, level ) + bonus) * (1 - self:GetCaster():GetWexCd()/100)
end



function invoker_ghost_walk_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_ghost_walk_aghanim"
else
    return "invoker_ghost_walk"
end

end

function invoker_ghost_walk_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():StartGesture(ACT_DOTA_CAST_GHOST_WALK)

local duration = self:GetCaster():GetValueWex(self, "duration")

if self:GetCaster():HasModifier("modifier_invoker_quas_3") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_invoker_ghost_walk_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_invoker_quas_3", "duration")})
end 

self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_invoker_ghost_walk_custom", { duration = duration } )

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_ghost_walk.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:ReleaseParticleIndex( effect_cast )


self:GetCaster():EmitSound("Hero_Invoker.GhostWalk")
end





modifier_invoker_ghost_walk_custom = class({})

function modifier_invoker_ghost_walk_custom:OnCreated()
self.radius = self:GetAbility():GetSpecialValueFor( "area_of_effect" )
self.aura_duration = self:GetAbility():GetSpecialValueFor( "aura_fade_time" ) + self:GetCaster():GetTalentValue("modifier_invoker_quas_2", "duration")
self.self_slow = self:GetCaster():GetValueWex(self:GetAbility(), "self_slow")
self.enemy_slow = self:GetCaster():GetValueQuas(self:GetAbility(), "enemy_slow")
self.health_regen = self:GetCaster():GetValueQuas(self:GetAbility(), "health_regen")
self.mana_regen = self:GetCaster():GetValueWex(self:GetAbility(), "mana_regen")

self.legendary_damage = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "damage")
self.legendary_interval = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "interval") - FrameTime()

self.more_duration = self:GetCaster():GetTalentValue("modifier_invoker_quas_6", "duration")
if IsServer() then

    local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")

    if self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true
        and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then

        local distance = self:GetAbility():GetSpecialValueFor("scepter_blink")
        local point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*distance

        self:GetCaster():EmitSound("Puck.Rift_Legendary")
        local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_start.vpcf", PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(effect)

        FindClearSpaceForUnit(self:GetCaster(), point, true)

        effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
        ParticleManager:SetParticleControl(effect, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(effect)

        self:SetStackCount(1)
        ult:UseScepter()
    end 


    self.ended = false

    if self:GetCaster():HasModifier("modifier_invoker_quas_6") then 
      self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_ghost_walk_custom_resist", {})
    end 


    if not self:GetCaster():HasModifier("modifier_invoker_quas_7") then return end

    self:OnIntervalThink()

    self:StartIntervalThink(self.legendary_interval)
end

if self:GetStackCount() == 1 then 
    self.self_slow = self.self_slow + self:GetAbility():GetSpecialValueFor("scepter_speed")
end 

end


function modifier_invoker_ghost_walk_custom:OnDestroy()
if not IsServer() then return end
if not self or not self:GetParent() or self:GetParent():IsNull() or not self:GetParent():HasModifier("modifier_invoker_ghost_walk_custom_resist") then return end

self:GetParent():RemoveModifierByName("modifier_invoker_ghost_walk_custom_resist")
end 


function modifier_invoker_ghost_walk_custom:OnRefresh()
self.ended = false
end 

function modifier_invoker_ghost_walk_custom:OnIntervalThink()
if not IsServer() then return end

local targets = self:GetCaster():FindTargets(self.radius)

for _,target in pairs(targets) do
  ApplyDamage({victim = target, attacker = self:GetCaster(), damage = self.legendary_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
end 

end


function modifier_invoker_ghost_walk_custom:RemoveOnDeath() return true end

function modifier_invoker_ghost_walk_custom:IsAura()
    return true
end

function modifier_invoker_ghost_walk_custom:GetModifierAura()
    return "modifier_invoker_ghost_walk_custom_debuff"
end

function modifier_invoker_ghost_walk_custom:GetAuraRadius()
    return self.radius
end

function modifier_invoker_ghost_walk_custom:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_invoker_ghost_walk_custom:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_invoker_ghost_walk_custom:GetAuraDuration()
    return self.aura_duration
end

function modifier_invoker_ghost_walk_custom:DeclareFunctions()
local funcs = 
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    MODIFIER_EVENT_ON_DEATH
}
return funcs
end


function modifier_invoker_ghost_walk_custom:OnDeath(params)
if not IsServer() then return end 
if self:GetParent() ~= params.unit then return end

self:Destroy()
end 


function modifier_invoker_ghost_walk_custom:OnAbilityExecuted( params )
if not IsServer() then return end
if not params.ability then return end
if not params.unit then return end
if params.unit ~= self:GetParent() then return end
if self.ended then return end 

self.ended = true

if self:GetCaster():HasModifier("modifier_invoker_quas_6") then 
  self:SetDuration(self.more_duration, true)
else 
  self:Destroy()
end

end

function modifier_invoker_ghost_walk_custom:OnAttack(params)
if not IsServer() then return end
if not params.attacker then return end
if params.attacker ~= self:GetParent() then return end
if self.ended then return end 

self.ended = true


if self:GetCaster():HasModifier("modifier_invoker_quas_6") then 
  self:SetDuration(self.more_duration, true)
else 
  self:Destroy()
end

end


function modifier_invoker_ghost_walk_custom:GetModifierConstantHealthRegen()
    return self.health_regen
end

function modifier_invoker_ghost_walk_custom:GetModifierConstantManaRegen()
    return self.mana_regen
end

function modifier_invoker_ghost_walk_custom:GetModifierMoveSpeedBonus_Percentage()
    return self.self_slow
end

function modifier_invoker_ghost_walk_custom:GetModifierInvisibilityLevel()
    return 1
end




function modifier_invoker_ghost_walk_custom:CheckState()
return {
    [MODIFIER_STATE_INVISIBLE] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end





modifier_invoker_ghost_walk_custom_debuff = class({})

function modifier_invoker_ghost_walk_custom_debuff:IsPurgable()
    return false
end

function modifier_invoker_ghost_walk_custom_debuff:OnCreated()
    self.enemy_slow = self:GetCaster():GetValueQuas(self:GetAbility(), "enemy_slow")
end

function modifier_invoker_ghost_walk_custom_debuff:OnRefresh()
    self.enemy_slow = self:GetCaster():GetValueQuas(self:GetAbility(), "enemy_slow")
end

function modifier_invoker_ghost_walk_custom_debuff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

function modifier_invoker_ghost_walk_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.enemy_slow
end

function modifier_invoker_ghost_walk_custom_debuff:GetEffectName()
    return "particles/units/heroes/hero_invoker/invoker_ghost_walk_debuff.vpcf"
end

function modifier_invoker_ghost_walk_custom_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_invoker_ghost_walk_custom_debuff:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_invoker_ghost_walk_custom_debuff:StatusEffectPriority()
return 9999
end
















invoker_ice_wall_custom = class({})


function invoker_ice_wall_custom:Precache(context)
    PrecacheResource( "particle", "particles/invoker_ice_wall.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_ice_wall_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/status_fx/status_effect_frost.vpcf", context )
end

function invoker_ice_wall_custom:GetCooldown(level)

local bonus = 0 

if self:GetCaster():HasShard() then 
  bonus = self:GetSpecialValueFor("shard_cd")
end 

return (self.BaseClass.GetCooldown( self, level ) + bonus) * (1 - self:GetCaster():GetWexCd()/100)
end



function invoker_ice_wall_custom:GetBehavior()

if self:GetCaster():HasShard() then 
  return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING
end 

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end



function invoker_ice_wall_custom:GetCastRange(vLocation, hTarget)
if not self:GetCaster():HasShard() then return end 

return self:GetSpecialValueFor("shard_range")
end 

function invoker_ice_wall_custom:OnInventoryContentsChanged()
if self.shard then return end

if self:GetCaster():HasShard() then 
  self.shard = true
  self:UpdateVectorValues()
end 

end 






function invoker_ice_wall_custom:OnVectorCastStart(vStartLocation, vDirection)

local target = self:GetCursorPosition()
if target == self:GetCaster():GetAbsOrigin() then 
  target = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*1
end

local spacing = self:GetSpecialValueFor("wall_element_spacing")
local num = self:GetSpecialValueFor("num_wall_elements")
local ice_wall_length = spacing*num


local pos1 = GetGroundPosition(self:GetVectorPosition() + (ice_wall_length/2)*vDirection, nil)
local pos2 = GetGroundPosition(self:GetVectorPosition() - (ice_wall_length/2)*vDirection, nil)


local caster                        = self:GetCaster()
local ice_wall_duration             = self:GetCaster():GetValueQuas(self, "duration")


self:GetCaster():StartGesture(ACT_DOTA_CAST_ICE_WALL)
self:GetCaster():EmitSound("Hero_Invoker.IceWall.Cast")

 
CreateModifierThinker(caster, self, "modifier_invoker_ice_wall_custom", 
  {
    quas = self:GetCaster():GetQuasHeal(),
    exort = self:GetCaster():GetExortDamage(), 
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

function invoker_ice_wall_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_ice_wall_aghanim"
else
    return "invoker_ice_wall"
end

end

function invoker_ice_wall_custom:OnSpellStart()
if not IsServer() then return end

local caster                        = self:GetCaster()
local caster_direction              = caster:GetForwardVector()
local ice_wall_duration             = self:GetCaster():GetValueQuas(self, "duration")
local ice_wall_placement_distance   = self:GetSpecialValueFor("wall_place_distance")
local target_point = caster:GetAbsOrigin() + caster_direction * ice_wall_placement_distance


self:GetCaster():StartGesture(ACT_DOTA_CAST_ICE_WALL)
self:GetCaster():EmitSound("Hero_Invoker.IceWall.Cast")


 
CreateModifierThinker(caster, self, "modifier_invoker_ice_wall_custom", {quas = self:GetCaster():GetQuasHeal(), exort = self:GetCaster():GetExortDamage(), duration = ice_wall_duration,  }, target_point, caster:GetTeamNumber(), false)
end






modifier_invoker_ice_wall_custom = class({})

function modifier_invoker_ice_wall_custom:OnCreated(kv)
if not IsServer() then return end

self.hit_hero = {}

self.is_scepter = 0
if kv.is_scepter and kv.is_scepter == 1 then 
    self.is_scepter = 1
end 

local spacing = self:GetAbility():GetSpecialValueFor("wall_element_spacing")
local num = self:GetAbility():GetSpecialValueFor("num_wall_elements")

self.ice_wall_length = spacing*num

local caster                        = self:GetCaster()
local caster_point                  = caster:GetAbsOrigin() 
local caster_direction              = caster:GetForwardVector()

local cast_direction = Vector(-caster_direction.y, caster_direction.x, caster_direction.z)

local endpoint_distance_from_center   = (cast_direction * self.ice_wall_length) / 2

local ice_wall_point = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)

if (kv.start_x) then 
  self.ice_wall_start_point = Vector(kv.start_x, kv.start_y, kv.start_z)
  self.ice_wall_end_point = Vector(kv.end_x, kv.end_y, kv.end_z)
else 

  self.ice_wall_start_point               = ice_wall_point - endpoint_distance_from_center
  self.ice_wall_end_point                 = ice_wall_point + endpoint_distance_from_center
end


self.scepter_slow = self.is_scepter

local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")

if self.is_scepter == 0 and self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true
    and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then

    local dir = (self.ice_wall_end_point - self.ice_wall_start_point):Normalized()
    
    dir = Vector(-dir.y, dir.x, 0)

    local pos1 = self:GetParent():GetAbsOrigin() + dir*self.ice_wall_length/2
    local pos2 = self:GetParent():GetAbsOrigin() - dir*self.ice_wall_length/2

    CreateModifierThinker(caster, self:GetAbility(), "modifier_invoker_ice_wall_custom", 
    {
        is_scepter = 1,
        quas = self:GetCaster():GetQuasHeal(),
        exort = self:GetCaster():GetExortDamage(),
        duration = self:GetRemainingTime(),
        start_x = pos1.x,
        start_y = pos1.y,
        start_z = pos1.z,
        end_x = pos2.x,
        end_y = pos2.y,
        end_z = pos2.z
    }, 
    self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)

    self.scepter_slow = 1
    ult:UseScepter()
end 



local ice_wall_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall.vpcf", PATTACH_CUSTOMORIGIN, nil)
ParticleManager:SetParticleControl(ice_wall_particle_effect, 0, self.ice_wall_start_point)
ParticleManager:SetParticleControl(ice_wall_particle_effect, 1, self.ice_wall_end_point  )
self:AddParticle(ice_wall_particle_effect, false, false, -1, false, true)

local ice_spikes_particle_effect  = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
ParticleManager:SetParticleControl(ice_spikes_particle_effect, 0, self.ice_wall_start_point)
ParticleManager:SetParticleControl(ice_spikes_particle_effect, 1, self.ice_wall_end_point  )
self:AddParticle(ice_spikes_particle_effect, false, false, -1, false, true)


self.slow_duration                      = self:GetAbility():GetSpecialValueFor("slow_duration") + self:GetCaster():GetTalentValue("modifier_invoker_quas_2", "duration")


self.ice_wall_slow                      = self:GetAbility():GetSpecialValueFor("slow")
self.ice_wall_area_of_effect            = 35

self.search_area                        = self.ice_wall_length + (self.ice_wall_area_of_effect * 2)

self.GetTeam                            = self:GetParent():GetTeam()
self.origin                             = self:GetParent():GetAbsOrigin()
self.ability                            = self:GetAbility()
self.endpoint_distance_from_center      = ice_wall_point

self.damage = self:GetCaster():GetValueExort(self:GetAbility(), "damage_per_second")

self.resist_duration = self:GetCaster():GetTalentValue("modifier_invoker_quas_4", "duration")

self.heroes_hit = false

self.quas_heal = kv.quas/100
self.exort_damage = kv.exort/100

if self.exort_damage and self.exort_damage > 0 then 
  self.damage = self.damage * (1 + self.exort_damage)
end 

self.snap = self:GetCaster():FindAbilityByName("invoker_cold_snap_custom")
self.snap_duration = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "wall_duration")

self.interval = 0.05
self.count = 0

self.root_duration = self:GetCaster():GetTalentValue("modifier_invoker_quas_5", "root")
self.root_targets = {}

self.max_count = 1 
if self:GetCaster():HasModifier("modifier_invoker_quas_5") then 
    self.max_count = self.max_count*(1 + self:GetCaster():GetTalentValue("modifier_invoker_quas_5", "damage")/100)
end 

self:StartIntervalThink(self.interval)
end

function modifier_invoker_ice_wall_custom:OnIntervalThink()
if not IsServer() then return end

self.count = self.count + self.interval

local nearby_enemy_units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),  self.origin,  nil,  self.search_area,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  0,  FIND_ANY_ORDER,  false)

for _,enemy in pairs(nearby_enemy_units) do
  if self:IsUnitInProximity(enemy:GetAbsOrigin()) then

    if self.count >= self.max_count then 
      if self.snap and self:GetCaster():HasModifier("modifier_invoker_quas_7") then 
        enemy:AddNewModifier( self:GetCaster(), self.snap, "modifier_invoker_cold_snap_custom", {cast = 0, is_scepter = 0, quas = self:GetCaster():GetQuasHeal(), exort = self:GetCaster():GetExortDamage(), duration = self.snap_duration } )
      end 

      if not self.root_targets[enemy] and self:GetCaster():HasModifier("modifier_invoker_quas_5") then 
        self.root_targets[enemy] = true
        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_ice_wall_custom_root", {duration = (1 - enemy:GetStatusResistance())*self.root_duration})
      end 

      if enemy:IsRealHero() and self.heroes_hit == false and self.is_scepter == 0 then
        self.heroes_hit = true
        local mod = self:GetCaster():FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")

        if mod then 
           -- mod:AddStack()
        end 
      end 

      if enemy:IsRealHero() and self.is_scepter == 0 and not self.hit_hero[enemy] then 
        self.hit_hero[enemy] = true


        local ability = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
        if ability then 
            ability:AbilityHit()
        end 
  
      end 


      local real_damage = ApplyDamage({victim = enemy, attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
      
      if self:GetCaster():HasModifier("modifier_invoker_quas_4") then 
        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_cold_snap_custom_resist", {duration = self.resist_duration})
      end 
            

      if self.quas_heal and self.quas_heal > 0 and not enemy:IsIllusion() then 

        local heal = real_damage*self.quas_heal
        if enemy:IsCreep() then 
            heal = heal/3
        end 

        self:GetCaster():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
      end
    end

    enemy:AddNewModifier(self:GetCaster(), self.ability, "modifier_invoker_ice_wall_custom_slow", {is_scepter = self.scepter_slow, duration = self.slow_duration})
  end
end

if self.count >= self.max_count then 
  self.count = 0
end 

end


function modifier_invoker_ice_wall_custom:IsUnitInProximity(target_position)

local ice_wall = self.ice_wall_end_point   - self.ice_wall_start_point
local target_vector = target_position - self.ice_wall_start_point
local ice_wall_normalized = ice_wall:Normalized()
local ice_wall_dot_vector = target_vector:Dot(ice_wall_normalized)
local search_point
if ice_wall_dot_vector <= 0 then
    search_point = self.ice_wall_start_point
elseif ice_wall_dot_vector >= ice_wall:Length2D() then
    search_point = self.ice_wall_end_point
else
    search_point = self.ice_wall_start_point + (ice_wall_normalized * ice_wall_dot_vector)
end 
local distance = target_position - search_point
return distance:Length2D() <= self.ice_wall_area_of_effect*3

end



modifier_invoker_ice_wall_custom_slow = class({})

function modifier_invoker_ice_wall_custom_slow:IsPurgable() return false end
function modifier_invoker_ice_wall_custom_slow:IsHidden() return false end
function modifier_invoker_ice_wall_custom_slow:GetEffectName() return "particles/units/heroes/hero_invoker/invoker_ice_wall_debuff.vpcf" end
function modifier_invoker_ice_wall_custom_slow:GetStatusEffectName() return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_invoker_ice_wall_custom_slow:StatusEffectPriority() return 9999 end

function modifier_invoker_ice_wall_custom_slow:OnCreated(table)
self.slow = self:GetCaster():GetValueQuas(self:GetAbility(), "slow")
self.attack = self:GetAbility():GetSpecialValueFor("scepter_slow")

self.heal_reduce = self:GetCaster():GetTalentValue("modifier_invoker_quas_5", "heal")
if not IsServer() then return end

self:SetStackCount(table.is_scepter)
end


function modifier_invoker_ice_wall_custom_slow:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() == 1 then return end

self:SetStackCount(table.is_scepter)
end 


function modifier_invoker_ice_wall_custom_slow:DeclareFunctions()
local funcs = 
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
return funcs
end

function modifier_invoker_ice_wall_custom_slow:GetModifierAttackSpeedBonus_Constant()
    return self.attack*self:GetStackCount()
end

function modifier_invoker_ice_wall_custom_slow:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

function modifier_invoker_ice_wall_custom_slow:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_invoker_quas_5") then return end 

return self.heal_reduce
end

function modifier_invoker_ice_wall_custom_slow:GetModifierHealAmplify_PercentageTarget()
if not self:GetCaster():HasModifier("modifier_invoker_quas_5") then return end 

return self.heal_reduce
end



function modifier_invoker_ice_wall_custom_slow:GetModifierHPRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_invoker_quas_5") then return end 

return self.heal_reduce
end













modifier_invoker_cold_snap_custom_legendary = class({})
function modifier_invoker_cold_snap_custom_legendary:IsHidden() return true end
function modifier_invoker_cold_snap_custom_legendary:IsPurgable() return false end
function modifier_invoker_cold_snap_custom_legendary:GetTexture() return "buffs/arc_speed" end
function modifier_invoker_cold_snap_custom_legendary:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "max")
self.stun = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "stun")

if not IsServer() then return end 

self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_drow/drow_hypothermia_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
end 

function modifier_invoker_cold_snap_custom_legendary:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

  self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_cold_snap_custom_legendary_proc", {duration = (1 - self:GetParent():GetStatusResistance())*self.stun})
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
return 9999
end


function modifier_invoker_cold_snap_custom_legendary_proc:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "health")/100
self.creeps = self:GetCaster():GetTalentValue("modifier_invoker_quas_7", "creeps")

if not IsServer() then return end 


self.mark = ParticleManager:CreateParticle( "particles/maiden_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle(self.mark,false, false, -1, false, false)
self:GetParent():EmitSound("Maiden.Frostbite_max_slow")
end 



function modifier_invoker_cold_snap_custom_legendary_proc:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_invoker_cold_snap_custom_legendary_proc:OnTakeDamage( params )
if not IsServer() then return end 
if self:GetCaster():GetTeamNumber() ~= params.attacker:GetTeamNumber() then return end
if self:GetParent():HasModifier("modifier_invoker_cold_snap_custom_legendary_no") then return end
if params.unit~=self:GetParent() then return end
if params.damage<10 then return end

self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_invoker_cold_snap_custom_legendary_no", {duration = FrameTime()})

local damage = self.damage*self:GetParent():GetMaxHealth()

if self:GetParent():IsCreep() then 
  damage = math.min(damage, self.creeps)
end 

local damageTable = 
{ 
    victim = self:GetParent(),
    attacker = self:GetCaster(),
    damage = damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self:GetAbility() 
}

local real_damage = ApplyDamage(damageTable)

self:GetParent():SendNumber(4, real_damage)

local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_cold_snap.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
ParticleManager:SetParticleControl( effect_cast, 1,  params.attacker:GetAbsOrigin() )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetParent():EmitSound("Invoker.Legendary_snap_damage")

self:GetParent():RemoveModifierByName("modifier_invoker_cold_snap_custom_legendary_no")
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

function modifier_invoker_ice_wall_custom_root:GetEffectName()
  return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_invoker_ice_wall_custom_root:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_invoker_ice_wall_custom_root:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_invoker_ice_wall_custom_root:StatusEffectPriority()
return 9999
end





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
  --MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_invoker_cold_snap_custom_resist:GetModifierMagicalResistanceBonus()
return self.resist*self:GetStackCount()
end

function modifier_invoker_cold_snap_custom_resist:GetModifierMoveSpeedBonus_Percentage()
--return self.slow*self:GetStackCount()
end







modifier_invoker_ghost_walk_custom_resist = class({})

function modifier_invoker_ghost_walk_custom_resist:IsHidden() return false end
function modifier_invoker_ghost_walk_custom_resist:IsPurgable() return false end
function modifier_invoker_ghost_walk_custom_resist:GetEffectName() return "particles/invoker/walk_resist.vpcf" end
function modifier_invoker_ghost_walk_custom_resist:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_invoker_ghost_walk_custom_resist:GetTexture() return "buffs/ghost_resist" end
function modifier_invoker_ghost_walk_custom_resist:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_invoker_quas_6", "damage")


end 


function modifier_invoker_ghost_walk_custom_resist:CheckState()
return
{
  [MODIFIER_STATE_UNSLOWABLE] = true
}
end

function modifier_invoker_ghost_walk_custom_resist:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_invoker_ghost_walk_custom_resist:GetModifierIncomingDamage_Percentage()
return self.damage
end





modifier_invoker_ghost_walk_custom_heal = class({})
function modifier_invoker_ghost_walk_custom_heal:IsHidden() return true end
function modifier_invoker_ghost_walk_custom_heal:IsPurgable() return true end
function modifier_invoker_ghost_walk_custom_heal:GetTexture() return "buffs/jump_heal" end

function modifier_invoker_ghost_walk_custom_heal:OnCreated(table)
self.heal = self:GetCaster():GetTalentValue("modifier_invoker_quas_3", "heal")/self:GetRemainingTime()
if not IsServer() then return end

self:StartIntervalThink(1)
end

function modifier_invoker_ghost_walk_custom_heal:OnIntervalThink()
if not IsServer() then return end
local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal*self:GetParent():GetMaxHealth()/100, nil)
end


function modifier_invoker_ghost_walk_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end
function modifier_invoker_ghost_walk_custom_heal:GetModifierHealthRegenPercentage()
return self.heal
end

function modifier_invoker_ghost_walk_custom_heal:GetEffectName() return "particles/zuus_heal.vpcf" end

function modifier_invoker_ghost_walk_custom_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

