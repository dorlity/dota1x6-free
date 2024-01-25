LinkLuaModifier( "modifier_invoker_wex_custom", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_wex_custom_passive", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_emp_custom", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_emp_custom_break", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_alacrity_custom", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_alacrity_custom_damage", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_tornado_custom", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invoker_tornado_custom_speed", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_emp_custom_teleport","abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_tornado_custom_thinker","abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_alacrity_custom_tracker", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_emp_custom_slow","abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_alacrity_custom_speed","abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_tornado_custom_purge", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE)



invoker_wex_custom = class({})

function invoker_wex_custom:ProcsMagicStick()
    return false
end

function invoker_wex_custom:Precache(context)


end


function invoker_wex_custom:GetIntrinsicModifierName()
    return "modifier_invoker_wex_custom_passive"
end

function invoker_wex_custom:OnSpellStart()
    local caster = self:GetCaster()
    local modifier = caster:AddNewModifier(
        caster,
        self, 
        "modifier_invoker_wex_custom",
        {  }
    )
    self.invoke:AddOrb( modifier )
end

function invoker_wex_custom:OnUpgrade()
    if not self.invoke then
        local invoke = self:GetCaster():FindAbilityByName( "invoker_invoke_custom" )
        if invoke:GetLevel()<1 then invoke:UpgradeAbility(true) end
        self.invoke = invoke
    else
        self.invoke:UpdateOrb("modifier_invoker_wex_custom", self:GetLevel())
    end
end

modifier_invoker_wex_custom = class({})

function modifier_invoker_wex_custom:IsHidden()
    return false
end

function modifier_invoker_wex_custom:IsDebuff()
    return false
end

function modifier_invoker_wex_custom:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_invoker_wex_custom:IsPurgable()
    return false
end

function modifier_invoker_wex_custom:OnCreated( kv )
    self.move_speed_per_instance = self:GetAbility():GetSpecialValueFor( "move_speed_per_instance" )
end

function modifier_invoker_wex_custom:OnRefresh( kv )
    self.move_speed_per_instance = self:GetAbility():GetSpecialValueFor( "move_speed_per_instance" )
end

function modifier_invoker_wex_custom:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end


function modifier_invoker_wex_custom:GetModifierMoveSpeedBonus_Percentage()
    return self.move_speed_per_instance
end





modifier_invoker_wex_custom_passive = class({})

function modifier_invoker_wex_custom_passive:IsHidden() return true end
function modifier_invoker_wex_custom_passive:IsPurgable() return false end
function modifier_invoker_wex_custom_passive:IsPurgeException() return false end

function modifier_invoker_wex_custom_passive:OnCreated()
self.agi = self:GetAbility():GetSpecialValueFor("agility_bonus")

if not IsServer() then return end
self:StartIntervalThink(FrameTime())
end

function modifier_invoker_wex_custom_passive:OnIntervalThink()
if not IsServer() then return end
local mod = self:GetCaster():FindAllModifiersByName("modifier_invoker_wex_custom")
self:SetStackCount(#mod)
end




function modifier_invoker_wex_custom_passive:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS
}
end

function modifier_invoker_wex_custom_passive:GetModifierBonusStats_Agility()
return self.agi*self:GetAbility():GetLevel()
end








invoker_emp_custom = class({})

function invoker_emp_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_emp.vpcf", context )
    PrecacheResource( "particle", "particles/invoker/emp_blink_start.vpcf", context )
    PrecacheResource( "particle", "particles/invoker/emp_legendarya.vpcf", context )
    PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
    PrecacheResource( "particle", "particles/void_spirit/remnant_hit.vpcf", context )
end



function invoker_emp_custom:GetIntrinsicModifierName()
return "modifier_invoker_alacrity_custom_tracker"
end

function invoker_emp_custom:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasModifier("modifier_invoker_wex_7") then 
  return self:GetCaster():GetTalentValue("modifier_invoker_wex_7", "range") - self:GetCaster():GetCastRangeBonus()
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function invoker_emp_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level ) * (1 - self:GetCaster():GetWexCd()/100)
end


function invoker_emp_custom:GetAOERadius()
    return self:GetSpecialValueFor( "area_of_effect" )
end


function invoker_emp_custom:GetAbilityTextureName()

if self:GetCaster():HasModifier("modifier_invoker_emp_custom_teleport") then 
    return "emp_blink"
end 

if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_emp_aghanim"
else
    return "invoker_emp"
end

end 



function invoker_emp_custom:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_invoker_emp_custom_teleport") then 
    return 0
end

return self.BaseClass.GetManaCost(self,iLevel) 
end



function invoker_emp_custom:GetBehavior()

local bonus = 0

if self:GetCaster():HasModifier("modifier_invoker_wex_7") then 
    bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 

if self:GetCaster():HasModifier("modifier_invoker_emp_custom_teleport") then 
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + bonus
end 

return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + bonus
end 



function invoker_emp_custom:OnSpellStart()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_invoker_emp_custom_teleport") then 

    self:GetCaster():StartGesture(ACT_DOTA_CAST_TORNADO)

    local mod = self:GetCaster():FindModifierByName("modifier_invoker_emp_custom_teleport")
    if mod and mod.thinker and not mod.thinker:IsNull() then 


        if self:GetAutoCastState() == true and not self:GetCaster():IsRooted() and not self:GetCaster():IsLeashed() then 

            local start_point = self:GetCaster():GetAbsOrigin()
            local end_point = mod.thinker:GetAbsOrigin()

            EmitSoundOnLocationWithCaster(start_point, "Invoker.Tornado_blink_start" , self:GetCaster())
            EmitSoundOnLocationWithCaster(start_point, "Invoker.Tornado_blink_start2" , self:GetCaster())

            local particle = ParticleManager:CreateParticle( "particles/invoker/emp_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
            ParticleManager:SetParticleControl(particle, 0,  start_point)
            ParticleManager:ReleaseParticleIndex(particle)

            FindClearSpaceForUnit(self:GetCaster(), end_point, true)
            ProjectileManager:ProjectileDodge(self:GetCaster())

            local particle4 = ParticleManager:CreateParticle( "particles/items3_fx/blink_arcane_end.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster() )
            ParticleManager:SetParticleControlEnt( particle4, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true )
            ParticleManager:ReleaseParticleIndex(particle4)


            self:GetCaster():EmitSound("Invoker.Tornado_blink_end")
        
            self:GetCaster():Stop()

            if mod.thinker:HasModifier("modifier_invoker_emp_custom") then 
                mod.thinker:FindModifierByName("modifier_invoker_emp_custom").teleport = true
            end 

        end

        mod.thinker:Destroy()
        self:GetCaster():RemoveModifierByName("modifier_invoker_emp_custom_teleport")
    end 

    return
end 




local point = self:GetCursorPosition()
local delay = self:GetSpecialValueFor("delay") + self:GetCaster():GetTalentValue("modifier_invoker_wex_5", "delay")
local target = Vector(0,0,0)


local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
local scepter = 0

if self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true
    and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then
    scepter = 1
    delay = delay + self:GetSpecialValueFor("scepter_delay")

    ult:UseScepter()
end 




if self:GetCaster():HasModifier("modifier_invoker_wex_7") then 

    point = self:GetCaster():GetAbsOrigin()
    target = self:GetCursorPosition()

    if target == point then 
        target = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()
    end 

    local dir = (target - point):Normalized()
    target = self:GetCaster():GetAbsOrigin() + dir*self:GetCaster():GetTalentValue("modifier_invoker_wex_7", "range")
end 

self:GetCaster():StartGesture(ACT_DOTA_CAST_EMP)

local thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_invoker_emp_custom", {is_scepter = scepter, x = target.x, y = target.y, quas = self:GetCaster():GetQuasHeal(), exort = self:GetCaster():GetExortDamage(), duration = delay }, point, self:GetCaster():GetTeamNumber(), false )
thinker:EmitSound("Hero_Invoker.EMP.Cast")
end




modifier_invoker_emp_custom = class({})

function modifier_invoker_emp_custom:IsHidden()
    return true
end

function modifier_invoker_emp_custom:IsPurgable()
    return false
end

function modifier_invoker_emp_custom:OnCreated( kv )
if not IsServer() then return end
self.teleport = false

self.is_scepter = kv.is_scepter

self.creeps_damage = self:GetCaster():GetValueWex(self:GetAbility(), "creeps_damage")

self.break_duration = self:GetAbility():GetSpecialValueFor("scepter_break")

self.area_of_effect = self:GetAbility():GetSpecialValueFor("area_of_effect")
self.mana_burned = self:GetCaster():GetValueWex(self:GetAbility(), "mana_burned")/100

self.self_mana = self:GetAbility():GetSpecialValueFor("self_mana")

self.damage_per_mana_pct = self:GetAbility():GetSpecialValueFor("damage_per_mana_pct") / 100

self.quas_heal = kv.quas/100
self.exort_damage = kv.exort/100

self:GetParent():EmitSound("Hero_Invoker.EMP.Charge")

local abs = self:GetParent():GetAbsOrigin()
abs.z = abs.z + 100

if self:GetCaster():HasModifier("modifier_invoker_wex_7") then 
    self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
else 
    self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_WORLDORIGIN, nil )
end 
ParticleManager:SetParticleControl( self.effect_cast, 0, abs )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.area_of_effect, 0, 0 ) )
self:AddParticle(self.effect_cast, false, false, -1, false, true)

self.more_damage = 0


self.slow_duration = self:GetCaster():GetTalentValue("modifier_invoker_wex_6", "duration")
self.knock_duration = self:GetCaster():GetTalentValue("modifier_invoker_wex_6", "knock_duration")
self.slow_knock = self:GetCaster():GetTalentValue("modifier_invoker_wex_6", "min_distance")

if not self:GetCaster():HasModifier("modifier_invoker_wex_7") then return end

self.legendary_k = self:GetCaster():GetTalentValue("modifier_invoker_wex_7", "damage")/100

self:GetAbility():EndCooldown()
self.mod = self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_emp_custom_teleport", {thinker = self:GetParent():entindex()})

self.target_point = GetGroundPosition(Vector(kv.x, kv.y, 0), nil)
self.origin_point = self:GetParent():GetAbsOrigin()

self.origin_point.z = 0
self.target_point.z = 0

self.dir = (self.target_point - self.origin_point):Normalized()
self.speed = self:GetCaster():GetTalentValue("modifier_invoker_wex_7", "range")/self:GetRemainingTime() 
self.interval = 0.03

self.max_time = (self.target_point - self.origin_point):Length2D()/self.speed

if not self:GetParent():HasModifier("modifier_invoker_invoke_custom_legendary") then
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'invoker_emp_change',  {hide = 0, max_time = self.max_time, time = (self.max_time - self:GetElapsedTime()), damage = 0})
end

self:StartIntervalThink(self.interval)
end



function modifier_invoker_emp_custom:OnIntervalThink()
if not IsServer() then return end 
if not self.max_time then return end
local original = (self.target_point - self.origin_point):Length2D()
local dist = (self.origin_point - self:GetParent():GetAbsOrigin()):Length2D()



self.legendary_damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*self.legendary_k

if self:GetParent():HasModifier("modifier_invoker_invoke_custom_legendary") then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'invoker_emp_change',  {hide = 1, max_time = self.max_time, time = (self.max_time - self:GetElapsedTime()), damage = self.legendary_damage*(dist/original)})
else 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'invoker_emp_change',  {hide = 0, max_time = self.max_time, time = (self.max_time - self:GetElapsedTime()), damage = self.legendary_damage*(dist/original)})
end 


if (self:GetParent():GetAbsOrigin() - self.target_point):Length2D() <= 20 then 
    self:Destroy()
    return
end

local dist = self.speed*self.interval*self.dir
local point = GetGroundPosition((self:GetParent():GetAbsOrigin() + dist), nil)
point.z = point.z + 100

AddFOWViewer(self:GetCaster():GetTeamNumber(), point, self.area_of_effect/2, self.interval, false)

self:GetParent():SetAbsOrigin(point)

end 




function modifier_invoker_emp_custom:OnDestroy( kv )
if not IsServer() then return end
self.max_time = nil

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'invoker_emp_change',  {hide = 1, max_time = 1, time = 0, damage = 0})


ParticleManager:DestroyParticle(self.effect_cast, true)
ParticleManager:ReleaseParticleIndex(self.effect_cast)

local effect_cast = ParticleManager:CreateParticle( "particles/invoker/emp_legendarya.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.area_of_effect, 0, 0 ) )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex(effect_cast)


if self.mod and not self.mod:IsNull() then 
    self:GetCaster():RemoveModifierByName("modifier_invoker_emp_custom_teleport")
end 

if self:GetCaster():HasModifier("modifier_invoker_wex_7") and self.origin_point and self.target_point and self.legendary_k then 
    local original = (self.target_point - self.origin_point):Length2D()
    local dist = (self.origin_point - self:GetParent():GetAbsOrigin()):Length2D()

    self.legendary_damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*self.legendary_k

    self.more_damage = self.legendary_damage*(dist/original)
end 

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.area_of_effect, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MANA_ONLY, 0, false )

local damageTable = 
{
    attacker = self:GetCaster(),
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self:GetAbility(),
}

local heroes_hit = false

for _,enemy in pairs(enemies) do
    if enemy:IsRealHero() then 
        heroes_hit = true
    end 

    if self.is_scepter and self.is_scepter == 1 then 
        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_emp_custom_break", {duration = (1 - enemy:GetStatusResistance())*self.break_duration})
    end 

    local mana_burn = enemy:GetMaxMana()*self.mana_burned

    enemy:Script_ReduceMana( mana_burn, self:GetAbility() )

    self:GetCaster():GiveMana(mana_burn * self.self_mana)

    self:GetCaster():SendNumber(11, mana_burn * self.self_mana)

    local damage = mana_burn * self.damage_per_mana_pct 

    if enemy:IsCreep() then 
        damage = self.creeps_damage
    end

    damage = damage + self.more_damage 

    if self.exort_damage and self.exort_damage > 0 then 
      damage = damage * (1 + self.exort_damage)
    end 

    damageTable.victim = enemy
    damageTable.damage = damage


    local real_damage = ApplyDamage(damageTable)

    if self.quas_heal and self.quas_heal > 0 and not enemy:IsIllusion() then

        local heal = real_damage*self.quas_heal
        if enemy:IsCreep() then 
            heal = heal/3
        end  

        self:GetCaster():GenericHeal(heal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")
    end

    if enemy:IsRealHero() then 
        local ability = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
        if ability then 
            ability:AbilityHit()
        end 
    end

    if self:GetCaster():HasModifier("modifier_invoker_wex_6") then 

        enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_emp_custom_slow", {duration = self.slow_duration})

        local direction = enemy:GetOrigin()-self:GetParent():GetOrigin()
        local center = self:GetParent():GetAbsOrigin()

        direction.z = 0
        direction = direction:Normalized()

        if enemy:GetOrigin() == self:GetParent():GetOrigin() then 
            direction = enemy:GetForwardVector()
            center = enemy:GetAbsOrigin() - direction
        end 
        local length = (center - enemy:GetAbsOrigin()):Length2D()

        local distance = math.max(self.slow_knock, self.area_of_effect*0.9 - length)


        if self.teleport == false then
            center = enemy:GetAbsOrigin() + direction
            
            local point = self:GetParent():GetAbsOrigin() + direction*150

            length = (point - enemy:GetAbsOrigin()):Length2D()

            distance = math.max(length, 0)

        end 

        local knockbackProperties =
        {
          center_x = center.x,
          center_y = center.y,
          center_z = center.z,
          duration = self.knock_duration,
          knockback_duration = self.knock_duration,
          knockback_distance = distance,
          knockback_height = 0,
          should_stun = 0
        }
        enemy:AddNewModifier( self:GetCaster(), self, "modifier_knockback", knockbackProperties )
        
    end 
end


if heroes_hit == true then 
    local mod = self:GetCaster():FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")

    if mod then 
        --mod:AddStack()
    end 
end



if self:GetCaster():HasModifier("modifier_invoker_wex_5") and (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.area_of_effect then 
    local effect_cast = ParticleManager:CreateParticle( "particles/cleance_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self:GetCaster())
    ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(170,0,0) )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    self:GetCaster():EmitSound("Invoker.EMP_purge")

    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_tornado_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_invoker_wex_5", "duration")})

    self:GetCaster():GenericHeal((self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())*self:GetCaster():GetTalentValue("modifier_invoker_wex_5", "heal")/100, self:GetAbility())
    self:GetCaster():Purge(false, true, false, true, false)
end 


self:GetParent():EmitSound("Hero_Invoker.EMP.Discharge")

UTIL_Remove( self:GetParent() )
end






modifier_invoker_alacrity_custom_tracker = class({})
function modifier_invoker_alacrity_custom_tracker:IsHidden() return true end
function modifier_invoker_alacrity_custom_tracker:IsPurgable() return false end
function modifier_invoker_alacrity_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end


function modifier_invoker_alacrity_custom_tracker:GetModifierAttackRangeBonus()
if not self:GetCaster():HasModifier("modifier_invoker_wex_3") then return end
return self:GetCaster():GetTalentValue("modifier_invoker_wex_3", "range")
end



function modifier_invoker_alacrity_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end 
if not params.target:IsHero() and not params.target:IsCreep() then return end



if params.attacker:HasModifier("modifier_invoker_alacrity_custom") and self:GetCaster():HasModifier("modifier_invoker_wex_4") then

    local duration = self:GetCaster():GetTalentValue("modifier_invoker_wex_4", "duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_alacrity_custom_speed", {duration = duration})
end


if self:GetParent() ~= params.attacker then return end 

if self:GetParent():HasModifier("modifier_invoker_wex_3") then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_invoker_alacrity_custom_damage", {duration = self:GetCaster():GetTalentValue("modifier_invoker_wex_3", "duration")})
end 


if not self:GetCaster():HasModifier("modifier_invoker_wex_7") then return end

local mod = self:GetCaster():FindModifierByName("modifier_invoker_emp_custom_teleport")

if mod then 
    mod:IncrementStackCount()
else 
    self:GetCaster():CdAbility(self:GetAbility(), self:GetCaster():GetTalentValue("modifier_invoker_wex_7", "cd"))
end 


end 



















invoker_alacrity_custom = class({})


function invoker_alacrity_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_alacrity.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_alacrity_buff.vpcf", context )
end

function invoker_alacrity_custom:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_HIDDEN + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES
end

function invoker_alacrity_custom:GetCooldown(level)

return self.BaseClass.GetCooldown( self, level ) * (1 - self:GetCaster():GetWexCd()/100)
end

function invoker_alacrity_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_alacrity_aghanim"
else
    return "invoker_alacrity"
end

end

function invoker_alacrity_custom:OnSpellStart()
if not IsServer() then return end



local target = self:GetCursorTarget()
local duration = self:GetSpecialValueFor("duration") + self:GetCaster():GetTalentValue("modifier_invoker_wex_2", "duration")

local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
local scepter = 0

if self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true
    and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then
    
    scepter = 1

    local friends = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), target:GetOrigin(), nil, self:GetSpecialValueFor("radius_scepter"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_CLOSEST, false )
    local count = 0 
    local max = self:GetSpecialValueFor("count")
    for _,unit in pairs(friends) do 
        if not unit:IsIllusion() and (unit:IsHero() or unit:IsCreep()) and unit ~= target then 
            count = count + 1
            unit:RemoveModifierByName("modifier_invoker_alacrity_custom")
            unit:AddNewModifier( self:GetCaster(), self, "modifier_invoker_alacrity_custom", {is_scepter = scepter, duration = duration } )
        end 

        if count >= max then 
            break
        end 
    end 

    ult:UseScepter()
end 


self:GetCaster():StartGesture(ACT_DOTA_CAST_ALACRITY)



target:RemoveModifierByName("modifier_invoker_alacrity_custom")
target:AddNewModifier( self:GetCaster(), self, "modifier_invoker_alacrity_custom", {is_scepter = scepter, duration = duration } )


target:EmitSound("Hero_Invoker.Alacrity")
end




modifier_invoker_alacrity_custom = class({})

function modifier_invoker_alacrity_custom:OnCreated( kv )

self.damage_heal = self:GetCaster():GetTalentValue("modifier_invoker_wex_2", "heal")/100
self.damage_heal_creeps = self:GetCaster():GetTalentValue("modifier_invoker_wex_2", "heal_creeps")

self.bonus_damage = self:GetCaster():GetValueExort(self:GetAbility(),  "bonus_damage")
self.bonus_attack_speed = self:GetCaster():GetValueWex(self:GetAbility(), "bonus_attack_speed")


if IsServer() then 

    self:SetStackCount(kv.is_scepter)

    self.tornado = self:GetCaster():FindAbilityByName("invoker_tornado_custom")
    self.emp = self:GetCaster():FindAbilityByName("invoker_emp_custom")

    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_alacrity.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    self:AddParticle( effect_cast, false, false, -1, false, false )
end 

if self:GetStackCount() == 1 then 
    self.bonus_damage = self.bonus_damage + self:GetAbility():GetSpecialValueFor("damage_scepter")
    self.bonus_attack_speed = self.bonus_attack_speed + self:GetAbility():GetSpecialValueFor("speed_scepter")
end 

end




function modifier_invoker_alacrity_custom:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end




function modifier_invoker_alacrity_custom:OnTakeDamage( params )
if not IsServer() then return end 
if not self:GetCaster():HasModifier("modifier_invoker_wex_2") then return end 
if self:GetParent() ~= params.attacker or params.unit:IsIllusion() then return end  
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end

local heal = params.damage*self.damage_heal
if params.unit:IsCreep() then 
    heal = heal/self.damage_heal_creeps
end 


self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end 





function modifier_invoker_alacrity_custom:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_invoker_alacrity_custom:GetModifierAttackSpeedBonus_Constant()
    return self.bonus_attack_speed
end

function modifier_invoker_alacrity_custom:GetEffectName()
    return "particles/units/heroes/hero_invoker/invoker_alacrity_buff.vpcf"
end

function modifier_invoker_alacrity_custom:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end


function modifier_invoker_alacrity_custom:GetStatusEffectName()
    return "particles/status_fx/status_effect_alacrity.vpcf"
end
function modifier_invoker_alacrity_custom:StatusEffectPriority()
    return 999999
end









invoker_tornado_custom = class({})

function invoker_tornado_custom:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_tornado.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_tornado_child.vpcf", context )
end



function invoker_tornado_custom:GetCooldown(level)

local bonus = 0
if self:GetCaster():HasModifier("modifier_invoker_wex_1") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_wex_1", "cd")
end 

return (self.BaseClass.GetCooldown( self, level ) + bonus) * (1 - self:GetCaster():GetWexCd()/100)
end


function invoker_tornado_custom:GetAbilityTextureName()
if self:GetCaster():HasScepter() and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then 
    return "invoker_tornado_aghanim"
else
    return "invoker_tornado"
end

end


function invoker_tornado_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():StartGesture(ACT_DOTA_CAST_TORNADO)



local point = self:GetCursorPosition()

if point == self:GetCaster():GetAbsOrigin() then
    point = point + self:GetCaster():GetForwardVector()
end


self.caster_origin = self:GetCaster():GetOrigin()

self.parent_origin = point

self.direction = self.parent_origin - self.caster_origin

self.direction.z = 0

self.direction = self.direction:Normalized()

self.radius = self:GetSpecialValueFor("area_of_effect")
self.distance = self:GetCaster():GetValueWex(self, "travel_distance")
self.speed = self:GetSpecialValueFor("travel_speed") + self:GetCaster():GetTalentValue("modifier_invoker_wex_1", "speed")
self.vision = self:GetSpecialValueFor("vision_distance")
self.vision_duration = self:GetSpecialValueFor("end_vision_duration")
self.duration = self:GetCaster():GetValueQuas(self, "lift_duration")

local thinker = CreateModifierThinker( self:GetCaster(), self, "modifier_invoker_tornado_custom_thinker", {}, self:GetCaster():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false )

thinker.hit_heroes = {}



local ult = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
local scepter = 0

if self:GetCaster():HasScepter() and ult and ult:GetAutoCastState() == true
    and not self:GetCaster():HasModifier("modifier_invoker_invoke_custom_scepter_cd") then
    scepter = 1

    ult:UseScepter()
end 




local tornado_projectile = 
{
    Ability = self,
    EffectName = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf",
    vSpawnOrigin = self.caster_origin,
    fDistance = self.distance,
    fStartRadius = self.radius,
    fEndRadius = self.radius,
    Source = self:GetCaster(),
    bHasFrontalCone = false,
    bReplaceExisting = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    bDeleteOnHit = false,
    vVelocity = self.direction * self.speed,
    bProvidesVision = true,
    iVisionRadius = self.vision,
    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    fExpireTime = GameRules:GetGameTime() + 10,
    ExtraData = {quas = self:GetCaster():GetQuasHeal(), exort = self:GetCaster():GetExortDamage(), thinker = thinker:entindex(), is_scepter = scepter}
}

ProjectileManager:CreateLinearProjectile(tornado_projectile)
EmitSoundOnLocationWithCaster(self.caster_origin, "Hero_Invoker.Tornado.Cast", self:GetCaster())
end



function invoker_tornado_custom:OnProjectileHit_ExtraData(hTarget, vLocation, table)
if not IsServer() then return end 
if not table.thinker then return end 

local thinker = EntIndexToHScript(table.thinker)
if not thinker then return end

if not hTarget then
    UTIL_Remove(thinker)
    AddFOWViewer(self:GetCaster():GetTeamNumber(), vLocation, self.vision, self.vision_duration, false)
    return nil
end

if hTarget:IsRealHero() and not thinker.hit_hero then 
    thinker.hit_hero = true
    local mod = self:GetCaster():FindModifierByName("modifier_invoker_chaos_meteor_custom_cataclysm_stack")

    if mod then 
        --mod:AddStack()
    end 
end 

if hTarget:IsRealHero() and not thinker.hit_heroes[hTarget] then 

    thinker.hit_heroes[hTarget] = true

    local ability = self:GetCaster():FindAbilityByName("invoker_invoke_custom")
    if ability then 
        ability:AbilityHit()
    end 


end 



if hTarget:IsCreep() then 
    local damageTable = 
    { 
        victim = hTarget,
        attacker = self:GetCaster(),
        damage = 1,
        damage_type = self:GetAbilityDamageType(),
        ability = self
    }
    local real_damage = ApplyDamage(damageTable)
end 

if not hTarget:IsDebuffImmune() then 
    hTarget:InterruptMotionControllers(true)
    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_invoker_tornado_custom", {is_scepter = table.is_scepter, quas = table.quas, exort = table.exort, duration = self.duration*(1 - hTarget:GetStatusResistance()) })
end

return false
end




function invoker_tornado_custom:OnProjectileThink_ExtraData(location, data)
if not IsServer() then return end

if data.thinker then
    local thinker = EntIndexToHScript(data.thinker)
    thinker:SetAbsOrigin(location)
end

end











modifier_invoker_tornado_custom = class({})

function modifier_invoker_tornado_custom:IsMotionController()
    return true
end

function modifier_invoker_tornado_custom:GetMotionControllerPriority()
    return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH
end



function modifier_invoker_tornado_custom:OnCreated(kv)
if not IsServer() then return end

local abs = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)

self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_tornado_child.vpcf", PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.effect_cast, 0, abs )
self:AddParticle(self.effect_cast, false, false, -1, false, true)

self.interval = 0.02

self.purge_duration = self:GetAbility():GetSpecialValueFor("scepter_purge")
self.is_scepter = kv.is_scepter

self:GetParent():EmitSound("Hero_Invoker.Tornado.Target" )
self:GetParent():Purge(true, false, false, false, false)

self.height = 450
self.height_duration = 0.3
self.height_inc = self.height/(self.height_duration/self.interval)

self.damage = self:GetAbility():GetSpecialValueFor("base_damage") + self:GetCaster():GetValueWex(self:GetAbility(), "wex_damage")

self.exort_damage = kv.exort/100
self.quas_heal = kv.quas/100

if self.exort_damage and self.exort_damage > 0 then 
  self.damage = self.damage * (1 + self.exort_damage)
end 

self.angle = self:GetParent():GetAngles()
self.abs = self:GetParent():GetAbsOrigin()
self.cyc_pos = self:GetParent():GetAbsOrigin()
self:StartIntervalThink(self.interval)
end


function modifier_invoker_tornado_custom:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_invoker_tornado_custom:GetOverrideAnimation()
return ACT_DOTA_FLAIL
end


function modifier_invoker_tornado_custom:OnIntervalThink()
if self:GetParent():IsDebuffImmune() then self:Destroy() return end
if self:GetParent():IsMagicImmune() then self:Destroy() return end

self:HorizontalMotion(self:GetParent(), self.interval)
end



function modifier_invoker_tornado_custom:OnDestroy()
if not IsServer() then return end
self:GetParent():Stop()

self:GetParent():StopSound("Hero_Invoker.Tornado.Target")

self:GetParent():EmitSound("Hero_Invoker.Tornado.LandDamage")


if not self:GetParent():IsDebuffImmune() then
    self:GetParent():SetAbsOrigin(self.abs)
    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)
    self:GetParent():SetAngles(self.angle[1], self.angle[2], self.angle[3])
end


if self:GetCaster() and self:GetAbility() then

    if self.is_scepter and self.is_scepter == 1 then 
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_invoker_tornado_custom_purge", {duration = self.purge_duration})
    end 

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

    if self:GetCaster():HasModifier("modifier_invoker_wex_6") then 
        self:GetParent():EmitSound("Sf.Raze_Silence")
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_invoker_wex_6", "silence")})
    end 
end


end

function modifier_invoker_tornado_custom:CheckState()
    local state =    
    {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
    return state
end

function modifier_invoker_tornado_custom:HorizontalMotion(unit, time)
if not IsServer() then return end
local angle = self:GetParent():GetAngles()
local new_angle = RotateOrientation(angle, QAngle(0, 14, 0))

self:GetParent():SetAngles(new_angle[1], new_angle[2], new_angle[3])



if self:GetElapsedTime() <= self.height_duration then
    self.cyc_pos.z = self.cyc_pos.z + self.height_inc
    self:GetParent():SetAbsOrigin(self.cyc_pos)

elseif self:GetDuration() - self:GetElapsedTime() < self.height_duration then
   
    self.cyc_pos.z = self.cyc_pos.z - self.height_inc
    self:GetParent():SetAbsOrigin(self.cyc_pos)
else
    local pos = GetRandomPosition2D(self:GetParent():GetAbsOrigin(), 4)
    if (pos - self.abs):Length2D() < self.height_inc  then
        self:GetParent():SetAbsOrigin(pos)
    end
end

end



function GetRandomPosition2D(point, distance)
    return point + RandomVector(distance)
end




modifier_invoker_tornado_custom_thinker = class({})
function modifier_invoker_tornado_custom_thinker:IsHidden() return true end
function modifier_invoker_tornado_custom_thinker:IsPurgable() return false end
function modifier_invoker_tornado_custom_thinker:OnCreated()
if not IsServer() then return end 
self:GetParent():EmitSound("Hero_Invoker.Tornado")


end 

function modifier_invoker_tornado_custom_thinker:OnDestroy()
if not IsServer() then return end 

self:GetParent():StopSound("Hero_Invoker.Tornado")


end

modifier_invoker_emp_custom_teleport = class({})
function modifier_invoker_emp_custom_teleport:IsHidden() return true end
function modifier_invoker_emp_custom_teleport:IsPurgable() return false end
function modifier_invoker_emp_custom_teleport:RemoveOnDeath() return false end
function modifier_invoker_emp_custom_teleport:OnCreated(table)
if not IsServer() then return end 

self:SetStackCount(0)

self.thinker = EntIndexToHScript(table.thinker)
end 

function modifier_invoker_emp_custom_teleport:OnDestroy()
if not IsServer() then return end 

local more_cd = self:GetCaster():GetTalentValue("modifier_invoker_wex_7", "cd")*self:GetStackCount()

self:GetAbility():UseResources(false, false, false, true)
self:GetCaster():CdAbility(self:GetAbility(), self:GetElapsedTime() - more_cd)
end 











modifier_invoker_emp_custom_slow = class({})
function modifier_invoker_emp_custom_slow:IsHidden() return true end
function modifier_invoker_emp_custom_slow:IsPurgable() return true end
function modifier_invoker_emp_custom_slow:GetEffectName() return "particles/void_astral_slow.vpcf" end
function modifier_invoker_emp_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end

function modifier_invoker_emp_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.move
end 



function modifier_invoker_emp_custom_slow:OnCreated()

self.move = self:GetCaster():GetTalentValue("modifier_invoker_wex_6", "slow")
end








modifier_invoker_alacrity_custom_speed = class({})
function modifier_invoker_alacrity_custom_speed:IsHidden() return false end
function modifier_invoker_alacrity_custom_speed:IsPurgable() return false end
function modifier_invoker_alacrity_custom_speed:GetTexture() return "buffs/psiblades_attack" end
function modifier_invoker_alacrity_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end

function modifier_invoker_alacrity_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed*self:GetStackCount()
end
   


function modifier_invoker_alacrity_custom_speed:GetModifierPercentageCooldown()
if self:GetStackCount() < self.max then return end
return self.cdr
end 


function modifier_invoker_alacrity_custom_speed:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_invoker_wex_4", "max")
self.cdr = self:GetCaster():GetTalentValue("modifier_invoker_wex_4", "cdr")
self.speed = self:GetCaster():GetTalentValue("modifier_invoker_wex_4", "speed")


if not IsServer() then return end 
self:SetStackCount(1)
end

function modifier_invoker_alacrity_custom_speed:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

    self:GetParent():EmitSound("Invoker.Alacrity_max")
    local effect_cast = ParticleManager:CreateParticle( "particles/invoker/alacrity_max.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
    self:AddParticle( effect_cast, false, false, -1, false, false)
end 

end















modifier_invoker_emp_custom_break = class({})
function modifier_invoker_emp_custom_break:IsHidden() return true end
function modifier_invoker_emp_custom_break:IsPurgable() return false end
function modifier_invoker_emp_custom_break:CheckState() return {[MODIFIER_STATE_PASSIVES_DISABLED] = true} end


function modifier_invoker_emp_custom_break:OnCreated(table)
if not IsServer() then return end
self.particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_break.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 1, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle, false, false, -1, false, false)
end




modifier_invoker_tornado_custom_purge = class({})
function modifier_invoker_tornado_custom_purge:IsHidden() return false end
function modifier_invoker_tornado_custom_purge:IsPurgable() return false end
function modifier_invoker_tornado_custom_purge:GetEffectName()
    return "particles/items4_fx/nullifier_mute_debuff.vpcf"
end 

function modifier_invoker_tornado_custom_purge:GetStatusEffectName()
    return "particles/status_fx/status_effect_nullifier.vpcf"
end 

function modifier_invoker_tornado_custom_purge:StatusEffectPriority()
    return 9999999
end 

function modifier_invoker_tornado_custom_purge:OnCreated()
self.damage = self:GetAbility():GetSpecialValueFor("scepter_damage")

if not IsServer() then return end 
self:GetParent():EmitSound("Invoker.Scepter_tornado")

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 

function modifier_invoker_tornado_custom_purge:OnIntervalThink()
if not IsServer() then return end 
if self:GetParent():IsDebuffImmune() then return end

self:GetParent():Purge(true, false, false, false,false)
end 


function modifier_invoker_tornado_custom_purge:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_invoker_tornado_custom_purge:GetModifierIncomingDamage_Percentage()
return self.damage
end








modifier_invoker_tornado_custom_speed = class({})
function modifier_invoker_tornado_custom_speed:IsHidden() return true end
function modifier_invoker_tornado_custom_speed:IsPurgable() return true end
function modifier_invoker_tornado_custom_speed:GetTexture() return "buffs/psiblades_speed" end

function modifier_invoker_tornado_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end



function modifier_invoker_tornado_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self.speed
end

function modifier_invoker_tornado_custom_speed:OnCreated(table)

self.speed = self:GetCaster():GetTalentValue("modifier_invoker_wex_5", "speed")
if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/ta_psi_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
self:AddParticle( effect_cast, false, false, -1, false, false)
end









modifier_invoker_alacrity_custom_damage = class({})
function modifier_invoker_alacrity_custom_damage:IsHidden() return false end
function modifier_invoker_alacrity_custom_damage:IsPurgable() return true end
function modifier_invoker_alacrity_custom_damage:GetTexture() return "buffs/wex_attack" end
function modifier_invoker_alacrity_custom_damage:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_invoker_wex_3", "damage")
self.max = self:GetCaster():GetTalentValue("modifier_invoker_wex_3", "max")
if not IsServer() then return end
self:SetStackCount(1)
end

function modifier_invoker_alacrity_custom_damage:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end


function modifier_invoker_alacrity_custom_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
}
end


 


function modifier_invoker_alacrity_custom_damage:GetModifierSpellAmplify_Percentage()
return self.damage*self:GetStackCount()
end 




