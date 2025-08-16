LinkLuaModifier( "modifier_invoker_wex_custom", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_wex_custom_passive", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_emp_custom", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_emp_custom_legendary", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_emp_custom_armor", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_alacrity_custom", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_tornado_custom", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_tornado_custom_damage", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_invoker_emp_custom_teleport","abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_tornado_custom_thinker","abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_alacrity_custom_tracker", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_emp_custom_slow","abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_alacrity_custom_speed","abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invoker_tornado_custom_purge", "abilities/invoker/invoker_wex_custom", LUA_MODIFIER_MOTION_NONE)



invoker_wex_custom = class({})

function invoker_wex_custom:CreateTalent()

local ability = self:GetCaster():FindAbilityByName("invoker_emp_custom")
if ability then 
    ability:ToggleAutoCast()
end 
end


function invoker_wex_custom:ProcsMagicStick()
    return false
end

function invoker_wex_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

PrecacheResource( "particle", "particles/invoker/emp_blink_start.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/blink_arcane_end.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_emp.vpcf", context )
PrecacheResource( "particle", "particles/invoker/emp_legendarya.vpcf", context )
PrecacheResource( "particle", "particles/cleance_blade.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_alacrity.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_alacrity_buff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_tornado.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_invoker/invoker_tornado_child.vpcf", context )
PrecacheResource( "particle", "particles/void_astral_slow.vpcf", context )
PrecacheResource( "particle", "particles/invoker/alacrity_max.vpcf", context )
PrecacheResource( "particle", "particles/generic_gameplay/generic_break.vpcf", context )
PrecacheResource( "particle", "particles/items4_fx/nullifier_mute_debuff.vpcf", context )
PrecacheResource( "particle", "particles/invoker/emp_stack.vpcf", context )
PrecacheResource( "particle", "particles/hoodwink/bush_damage.vpcf", context )

end

function invoker_wex_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_invoker_persona_1") or self:GetCaster():HasModifier("modifier_invoker_persona_2") or self:GetCaster():HasModifier("modifier_invoker_persona_3") or self:GetCaster():HasModifier("modifier_invoker_persona_4") or self:GetCaster():HasModifier("modifier_invoker_persona_5") or self:GetCaster():HasModifier("modifier_invoker_persona_6") then
    return "invoker_wex_persona1"
end
if self:GetCaster():HasModifier("modifier_magus_apex_custom") then
    return "invoker/magus_apex/invoker_wex"
end
return "invoker_wex"
end


function invoker_wex_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
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

function modifier_invoker_wex_custom:IsHidden() return false end
function modifier_invoker_wex_custom:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE  end
function modifier_invoker_wex_custom:IsPurgable() return false end

function modifier_invoker_wex_custom:OnCreated( kv )
self.caster = self:GetCaster()
self.move_speed_per_instance = self:GetAbility():GetSpecialValueFor( "move_speed_per_instance" )
self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

function modifier_invoker_wex_custom:OnRefresh( kv )
self.move_speed_per_instance = self:GetAbility():GetSpecialValueFor( "move_speed_per_instance" )
self.attack_speed = self:GetAbility():GetSpecialValueFor( "attack_speed" )
end

function modifier_invoker_wex_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_invoker_wex_custom:GetModifierMoveSpeedBonus_Percentage()
if self.caster:HasShard() then return end
return self.move_speed_per_instance
end

function modifier_invoker_wex_custom:GetModifierAttackSpeedBonus_Constant()
if self.caster:HasShard() then return end
return self.attack_speed
end




modifier_invoker_wex_custom_passive = class({})

function modifier_invoker_wex_custom_passive:IsHidden() return true end
function modifier_invoker_wex_custom_passive:IsPurgable() return false end
function modifier_invoker_wex_custom_passive:IsPurgeException() return false end

function modifier_invoker_wex_custom_passive:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.move_speed_per_instance = self.ability:GetSpecialValueFor( "move_speed_per_instance" )
self.attack_speed = self.ability:GetSpecialValueFor( "attack_speed" )
self.shard_bonus = self.ability:GetSpecialValueFor("shard_bonus")/100

self.agi = self.ability:GetSpecialValueFor("agility_bonus")

if not IsServer() then return end
self:StartIntervalThink(FrameTime())
end


function modifier_invoker_wex_custom_passive:OnRefresh()
self.attack_speed = self.ability:GetSpecialValueFor( "attack_speed" )
self.move_speed_per_instance = self.ability:GetSpecialValueFor( "move_speed_per_instance" )
end

function modifier_invoker_wex_custom_passive:OnIntervalThink()
if not IsServer() then return end
local mod = self.parent:FindAllModifiersByName("modifier_invoker_wex_custom")
self:SetStackCount(#mod)
end

function modifier_invoker_wex_custom_passive:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_invoker_wex_custom_passive:GetModifierBonusStats_Agility()
return self.agi*self.ability:GetLevel()
end

function modifier_invoker_wex_custom_passive:GetModifierAttackSpeedBonus_Constant()
if not self.parent:HasShard() then return end
return 3*self.attack_speed*(1 + self.shard_bonus)
end


function modifier_invoker_wex_custom_passive:GetModifierMoveSpeedBonus_Percentage()
if not self.parent:HasShard() then return end
return 3*self.move_speed_per_instance*(1 + self.shard_bonus)
end





invoker_emp_custom = class({})

function invoker_emp_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_invoker_alacrity_custom_tracker"
end

function invoker_emp_custom:GetCastRange(vLocation, hTarget)

if self:GetCaster():HasTalent("modifier_invoker_wex_7") then 
  return self:GetCaster():GetTalentValue("modifier_invoker_wex_7", "range") - self:GetCaster():GetCastRangeBonus()
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function invoker_emp_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level )
end

function invoker_emp_custom:GetAOERadius()
return self:GetSpecialValueFor( "area_of_effect" )
end

function invoker_emp_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_invoker_emp_custom_teleport") then 
    return "emp_blink"
end 
return "invoker_emp"
end 


function invoker_emp_custom:GetManaCost(iLevel)
if self:GetCaster():HasModifier("modifier_invoker_emp_custom_teleport") then 
    return 0
end
return self.BaseClass.GetManaCost(self,iLevel) 
end



function invoker_emp_custom:GetBehavior()

local bonus = 0

if self:GetCaster():HasTalent("modifier_invoker_wex_7") then 
    bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end 
if self:GetCaster():HasModifier("modifier_invoker_emp_custom_teleport") then 
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + bonus
end 
return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + bonus
end 



function invoker_emp_custom:OnSpellStart()
local caster = self:GetCaster()

if caster:HasModifier("modifier_invoker_emp_custom_teleport") then 

    caster:StartGesture(ACT_DOTA_CAST_TORNADO)

    local mod = caster:FindModifierByName("modifier_invoker_emp_custom_teleport")
    if mod and mod.thinker and not mod.thinker:IsNull() then 

        if self:GetAutoCastState() == true and not caster:IsRooted() and not caster:IsLeashed() then 

            local start_point = caster:GetAbsOrigin()
            local end_point = mod.thinker:GetAbsOrigin()

            EmitSoundOnLocationWithCaster(start_point, "Invoker.Tornado_blink_start" , caster)
            EmitSoundOnLocationWithCaster(start_point, "Invoker.Tornado_blink_start2" , caster)

            local particle = ParticleManager:CreateParticle( "particles/invoker/emp_blink_start.vpcf", PATTACH_WORLDORIGIN, nil )
            ParticleManager:SetParticleControl(particle, 0,  start_point)
            ParticleManager:ReleaseParticleIndex(particle)

            FindClearSpaceForUnit(caster, end_point, true)
            ProjectileManager:ProjectileDodge(caster)

            local particle4 = ParticleManager:CreateParticle( "particles/items3_fx/blink_arcane_end.vpcf", PATTACH_POINT_FOLLOW, caster )
            ParticleManager:SetParticleControlEnt( particle4, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
            ParticleManager:ReleaseParticleIndex(particle4)

            caster:EmitSound("Invoker.Tornado_blink_end")
            caster:Stop()

            if mod.thinker:HasModifier("modifier_invoker_emp_custom") then 
                mod.thinker:FindModifierByName("modifier_invoker_emp_custom").teleport = true
            end 
        end
        mod.thinker:Destroy()
        caster:RemoveModifierByName("modifier_invoker_emp_custom_teleport")
    end 

    return
end 


local point = self:GetCursorPosition()
local delay = self:GetSpecialValueFor("delay") + caster:GetTalentValue("modifier_invoker_wex_3", "delay")
local target = Vector(0,0,0)

if caster:HasTalent("modifier_invoker_wex_7") then 
    point = caster:GetAbsOrigin()
    target = self:GetCursorPosition()

    if target == point then 
        target = caster:GetAbsOrigin() + caster:GetForwardVector()
    end 

    local dir = (target - point):Normalized()
    target = caster:GetAbsOrigin() + dir*caster:GetTalentValue("modifier_invoker_wex_7", "range")
end 

caster:StartGesture(ACT_DOTA_CAST_EMP)

local thinker = CreateModifierThinker( caster, self, "modifier_invoker_emp_custom", {x = target.x, y = target.y, duration = delay }, point, caster:GetTeamNumber(), false )
thinker:EmitSound("Hero_Invoker.EMP.Cast")
end




modifier_invoker_emp_custom = class({})
function modifier_invoker_emp_custom:IsHidden() return true end
function modifier_invoker_emp_custom:IsPurgable() return false end

function modifier_invoker_emp_custom:OnCreated( kv )
if not IsServer() then return end
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.teleport = false

self.creeps_damage = self.caster:GetValueWex(self.ability, "creeps_damage")
self.area_of_effect = self.ability:GetSpecialValueFor("area_of_effect")
self.mana_burned = self.caster:GetValueWex(self.ability, "mana_burned")/100
self.self_mana = self.ability:GetSpecialValueFor("self_mana")
self.damage_per_mana_pct = self.ability:GetSpecialValueFor("damage_per_mana_pct") / 100

self.parent:EmitSound("Hero_Invoker.EMP.Charge")

local abs = self.parent:GetAbsOrigin()
abs.z = abs.z + 100

if self.caster:HasTalent("modifier_invoker_wex_7") then 
    self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
else 
    self.effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_emp.vpcf", PATTACH_WORLDORIGIN, nil )
end 

ParticleManager:SetParticleControl( self.effect_cast, 0, abs )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.area_of_effect, 0, 0 ) )
self:AddParticle(self.effect_cast, false, false, -1, false, true)

self.slow_duration = self.caster:GetTalentValue("modifier_invoker_wex_6", "duration")
self.knock_duration = self.caster:GetTalentValue("modifier_invoker_wex_6", "knock_duration")
self.slow_knock = self.caster:GetTalentValue("modifier_invoker_wex_6", "min_distance")

if not self.caster:HasTalent("modifier_invoker_wex_7") then return end

self.legendary_damage = self.caster:GetTalentValue("modifier_invoker_wex_7", "damage")/100

self.ability:EndCooldown()
self.mod = self.caster:AddNewModifier(self.caster, self.ability, "modifier_invoker_emp_custom_teleport", {thinker = self.parent:entindex()})

self.target_point = GetGroundPosition(Vector(kv.x, kv.y, 0), nil)
self.origin_point = self.parent:GetAbsOrigin()

self.origin_point.z = 0
self.target_point.z = 0

self.dir = (self.target_point - self.origin_point):Normalized()
self.speed = self.caster:GetTalentValue("modifier_invoker_wex_7", "range")/self:GetRemainingTime() 
self.interval = 0.03

self.max_time = (self.target_point - self.origin_point):Length2D()/self.speed

self.caster:UpdateUIshort({max_time = self.max_time, time = (self.max_time - self:GetElapsedTime()), style = "InvokerWex"})

self:StartIntervalThink(self.interval)
end


function modifier_invoker_emp_custom:OnIntervalThink()
if not IsServer() then return end 
if not self.max_time then return end
local original = (self.target_point - self.origin_point):Length2D()
local dist = (self.origin_point - self.parent:GetAbsOrigin()):Length2D()

self.caster:UpdateUIshort({max_time = self.max_time, time = (self.max_time - self:GetElapsedTime()), style = "InvokerWex"})

if (self.parent:GetAbsOrigin() - self.target_point):Length2D() <= 20 then 
    self:Destroy()
    return
end

local dist = self.speed*self.interval*self.dir
local point = GetGroundPosition((self.parent:GetAbsOrigin() + dist), nil)
point.z = point.z + 100

AddFOWViewer(self.caster:GetTeamNumber(), point, self.area_of_effect/2, self.interval, false)

self.parent:SetAbsOrigin(point)
end 



function modifier_invoker_emp_custom:OnDestroy( kv )
if not IsServer() then return end
self.max_time = nil
local parent_abs = self:GetParent():GetAbsOrigin()

self.caster:UpdateUIshort({hide = 1, style = "InvokerWex", hide_full = 1})

ParticleManager:DestroyParticle(self.effect_cast, true)
ParticleManager:ReleaseParticleIndex(self.effect_cast)

local effect_cast = ParticleManager:CreateParticle( "particles/invoker/emp_legendarya.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl( effect_cast, 0, parent_abs )
ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.area_of_effect, 0, 0 ) )
ParticleManager:DestroyParticle(effect_cast, false)
ParticleManager:ReleaseParticleIndex(effect_cast)

if self.mod and not self.mod:IsNull() then 
    self.caster:RemoveModifierByName("modifier_invoker_emp_custom_teleport")
end 

if self.caster:HasTalent("modifier_invoker_wex_3") then
    self.caster:AddNewModifier(self.caster, self.ability, "modifier_invoker_emp_custom_armor", {duration = self.caster:GetTalentValue("modifier_invoker_wex_3", "armor")})
end

local enemies = self.caster:FindTargets(self.area_of_effect, parent_abs) 

local damageTable = 
{
    attacker = self.caster,
    damage_type = DAMAGE_TYPE_MAGICAL,
    ability = self.ability,
}

local ability = self.caster:FindAbilityByName("invoker_invoke_custom")

for _,enemy in pairs(enemies) do

    local mana_burn = 0

    if enemy:GetMaxMana() > 0 then
        mana_burn = enemy:GetMaxMana()*self.mana_burned
        enemy:Script_ReduceMana( mana_burn, self.ability )
        self.caster:GiveMana(mana_burn * self.self_mana)
        self.caster:SendNumber(11, mana_burn * self.self_mana)
    end

    local damage = mana_burn * self.damage_per_mana_pct 

    if enemy:IsCreep() then 
        damage = self.creeps_damage
    end

    local mod = enemy:FindModifierByName("modifier_invoker_emp_custom_legendary")
    if mod then 
        damage = damage + mod:GetStackCount()*self.legendary_damage*self.caster:GetAverageTrueAttackDamage(nil)
        mod:Destroy()
    end 

    damageTable.victim = enemy
    damageTable.damage = damage
    local real_damage = DoDamage(damageTable)

    if ability then 
        ability:AbilityHit(enemy)
    end 

    if self.caster:HasTalent("modifier_invoker_wex_6") then 

        enemy:AddNewModifier(self.caster, self.ability, "modifier_invoker_emp_custom_slow", {duration = self.slow_duration})

        local direction = enemy:GetOrigin()-parent_abs
        local center = parent_abs

        direction.z = 0
        direction = direction:Normalized()

        if enemy:GetOrigin() == parent_abs then 
            direction = enemy:GetForwardVector()
            center = enemy:GetAbsOrigin() - direction
        end 
        local length = (center - enemy:GetAbsOrigin()):Length2D()

        local distance = math.max(self.slow_knock, self.area_of_effect*0.9 - length)

        if self.teleport == false then
            center = enemy:GetAbsOrigin() + direction
            
            local point = parent_abs + direction*150

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
        enemy:AddNewModifier( self.caster, self, "modifier_knockback", knockbackProperties )
    end 
end

self:GetParent():EmitSound("Hero_Invoker.EMP.Discharge")
UTIL_Remove( self:GetParent() )
end






modifier_invoker_alacrity_custom_tracker = class({})
function modifier_invoker_alacrity_custom_tracker:IsHidden() return true end
function modifier_invoker_alacrity_custom_tracker:IsPurgable() return false end


function modifier_invoker_alacrity_custom_tracker:OnCreated()

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.cdr_duration = self.parent:GetTalentValue("modifier_invoker_wex_4", "duration", true)
self.legendary_cd = self.parent:GetTalentValue("modifier_invoker_wex_7", "cd", true)
self.legendary_duration = self.parent:GetTalentValue("modifier_invoker_wex_7", "duration", true)
self.legendary_radius = self.parent:GetTalentValue("modifier_invoker_wex_7", "radius", true)

self.lifesteal = self.parent:GetTalentValue("modifier_invoker_wex_5", "heal", true)/100
self.heal_creeps = self.parent:GetTalentValue("modifier_invoker_wex_5", "heal_creeps", true)

self.parent:AddAttackEvent_out(self)
self.parent:AddDamageEvent_out(self)
end


function modifier_invoker_alacrity_custom_tracker:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_invoker_wex_5") then return end
if not params.unit:IsUnit() then return end

local attacker = params.attacker
if attacker:GetTeamNumber() ~= self.parent:GetTeamNumber() then return end

local mod = attacker:FindModifierByName("modifier_invoker_alacrity_custom")
if mod then
    local heal = (1 - attacker:GetHealthPercent()/100)*self.lifesteal
    if params.unit:IsCreep() then
        heal = heal/self.heal_creeps
    end
    attacker:GenericHeal(heal*params.damage, mod:GetAbility(), true, nil, "modifier_invoker_wex_5")
end

end


function modifier_invoker_alacrity_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end 
if not params.target:IsUnit() then return end
if self.parent ~= params.attacker then return end 
if not self.parent:HasTalent("modifier_invoker_wex_7") then return end

for _,target in pairs(self.parent:FindTargets(self.legendary_radius, params.target:GetAbsOrigin())) do 
    target:AddNewModifier(self.parent, self.ability, "modifier_invoker_emp_custom_legendary", {duration = self.legendary_duration})
end

local mod = self.parent:FindModifierByName("modifier_invoker_emp_custom_teleport")

if mod then 
    mod:IncrementStackCount()
else 
    self.parent:CdAbility(self.ability, self.legendary_cd)
end 

end 








invoker_alacrity_custom = class({})

function invoker_alacrity_custom:GetCooldown(level)
return self.BaseClass.GetCooldown( self, level ) 
end

function invoker_alacrity_custom:GetAbilityTextureName()
if self:GetCaster():HasModifier("modifier_magus_accord_custom") then
    return "invoker/immortal/invoker_alacrity"
end
return "invoker_alacrity"
end

function invoker_alacrity_custom:OnSpellStart()
local caster = self:GetCaster()


if caster:HasTalent("modifier_invoker_wex_5") then
    caster:Purge(false, true, false, false, false)

    local effect_cast = ParticleManager:CreateParticle( "particles/cleance_blade.vpcf", PATTACH_ABSORIGIN_FOLLOW,  caster)
    ParticleManager:SetParticleControl( effect_cast, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl( effect_cast, 1, Vector(170,0,0) )
    ParticleManager:ReleaseParticleIndex( effect_cast )

    caster:EmitSound("Invoker.EMP_purge")
end

local target = self:GetCursorTarget()

caster:StartGesture(ACT_DOTA_CAST_ALACRITY)
self:ApplyEffect(target)
end

function invoker_alacrity_custom:ApplyEffect(target)
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_invoker_wex_2", "duration")
target:RemoveModifierByName("modifier_invoker_alacrity_custom")
target:AddNewModifier( caster, self, "modifier_invoker_alacrity_custom", {duration = duration } )
target:EmitSound("Hero_Invoker.Alacrity")
end



modifier_invoker_alacrity_custom = class({})

function modifier_invoker_alacrity_custom:IsPurgable() return not self:GetCaster():HasTalent("modifier_invoker_wex_5") end

function modifier_invoker_alacrity_custom:OnCreated( kv )

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.bonus_damage = self.caster:GetValueExort(self.ability,  "bonus_damage") + self.caster:GetTalentValue("modifier_invoker_wex_2", "damage")
self.bonus_attack_speed = self.caster:GetValueWex(self.ability, "bonus_attack_speed") + self.caster:GetTalentValue("modifier_invoker_wex_2", "speed")

self.damage_reduce = self.caster:GetTalentValue("modifier_invoker_wex_5", "damage_reduce")

self.cdr = self.caster:GetTalentValue("modifier_invoker_wex_4", "cdr")

if not IsServer() then return end

local effect_name = "particles/units/heroes/hero_invoker/invoker_alacrity.vpcf"
if self:GetCaster():HasModifier("modifier_magus_accord_custom") then
    effect_name = "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity.vpcf"
end

local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
self:AddParticle( effect_cast, false, false, -1, false, false )

local buff_name_particle = "particles/units/heroes/hero_invoker/invoker_alacrity_buff.vpcf"
if self:GetCaster():HasModifier("modifier_magus_accord_custom") then
    buff_name_particle = "particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_buff.vpcf"
end

local overhead_effect = ParticleManager:CreateParticle( buff_name_particle, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
self:AddParticle( overhead_effect, false, false, -1, false, false )

if self:GetCaster():HasModifier("") then
    local particle_effect_hands = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_ti7/invoker_ti7_alacrity_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControlEnt(particle_effect_hands, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
    ParticleManager:SetParticleControlEnt(particle_effect_hands, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", Vector(0,0,0), true)
    ParticleManager:ReleaseParticleIndex(particle_effect_hands)
end

end

function modifier_invoker_alacrity_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end


function modifier_invoker_alacrity_custom:GetModifierPercentageCooldown()
if not self.caster:HasTalent("modifier_invoker_wex_4") then return end
return self.cdr
end 

function modifier_invoker_alacrity_custom:GetModifierIncomingDamage_Percentage()
if not IsServer() then return end 
if not self.caster:HasTalent("modifier_invoker_wex_5") then return end
return (1 - self.parent:GetHealthPercent()/100)*self.damage_reduce
end

function modifier_invoker_alacrity_custom:GetModifierPreAttack_BonusDamage()
return self.bonus_damage
end

function modifier_invoker_alacrity_custom:GetModifierAttackSpeedBonus_Constant()
return self.bonus_attack_speed
end


function modifier_invoker_alacrity_custom:GetStatusEffectName()
if self:GetCaster():HasModifier("modifier_magus_accord_custom") then
    return "particles/econ/items/invoker/invoker_ti7/status_effect_alacrity_ti7.vpcf"
end
return "particles/status_fx/status_effect_alacrity.vpcf"
end

function modifier_invoker_alacrity_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end









invoker_tornado_custom = class({})

function invoker_tornado_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_invoker_wex_1") then 
    bonus = self:GetCaster():GetTalentValue("modifier_invoker_wex_1", "cd")
end 
return self.BaseClass.GetCooldown( self, level ) + bonus
end


function invoker_tornado_custom:GetAbilityTextureName()
local scepter = false
local caster = self:GetCaster()

if caster:HasScepter() and not caster:HasModifier("modifier_invoker_invoke_custom_scepter_cd") and caster:FindAbilityByName("invoker_invoke_custom") then 
   scepter = true
end

if caster:HasModifier("modifier_invoker_persona_2") or (caster:HasModifier("modifier_invoker_dark_artistry_cape") and not (caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6"))) then
    if scepter then
        return "invoker_tornado_dark_artistry_aghanim"
    else
        return "invoker/dark_artistry/invoker_tornado"
    end
end

if scepter then
    return "invoker_tornado_aghanim"
else
    return "invoker_tornado"
end

end



function invoker_tornado_custom:OnSpellStart()

local caster = self:GetCaster()
caster:StartGesture(ACT_DOTA_CAST_TORNADO)

local point = self:GetCursorPosition()

if point == caster:GetAbsOrigin() then
    point = point + caster:GetForwardVector()
end

self.caster_origin = caster:GetOrigin()
self.parent_origin = point
self.direction = self.parent_origin - self.caster_origin
self.direction.z = 0

self.direction = self.direction:Normalized()

self.radius = self:GetSpecialValueFor("area_of_effect")
self.distance = caster:GetValueWex(self, "travel_distance")
self.speed = self:GetSpecialValueFor("travel_speed")
self.vision = self:GetSpecialValueFor("vision_distance")
self.vision_duration = self:GetSpecialValueFor("end_vision_duration")
self.duration = caster:GetValueQuas(self, "lift_duration")

local thinker = CreateModifierThinker( caster, self, "modifier_invoker_tornado_custom_thinker", {}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false )
thinker.hit_targets = {}

local ult = caster:FindAbilityByName("invoker_invoke_custom")
local scepter = 0

if caster:HasScepter() and ult and not caster:HasModifier("modifier_invoker_invoke_custom_scepter_cd") then
    scepter = 1
    ult:UseScepter()
end 

local particle_name = "particles/units/heroes/hero_invoker/invoker_tornado.vpcf"
if caster:HasModifier("modifier_invoker_dark_artistry_cape") and not (caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6")) then
    particle_name = "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf"
end
if caster:HasModifier("modifier_invoker_persona_2") then
    particle_name = "particles/econ/items/invoker/invoker_ti6/invoker_tornado_ti6.vpcf"
end

local tornado_projectile = 
{
    Ability = self,
    EffectName = particle_name,
    vSpawnOrigin = self.caster_origin,
    fDistance = self.distance,
    fStartRadius = self.radius,
    fEndRadius = self.radius,
    Source = caster,
    bHasFrontalCone = false,
    bReplaceExisting = false,
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    bDeleteOnHit = false,
    vVelocity = self.direction * self.speed,
    bProvidesVision = true,
    iVisionRadius = self.vision,
    iVisionTeamNumber = caster:GetTeamNumber(),
    fExpireTime = GameRules:GetGameTime() + 10,
    ExtraData = {thinker = thinker:entindex(), is_scepter = scepter}
}

ProjectileManager:CreateLinearProjectile(tornado_projectile)

local sound = "Hero_Invoker.Tornado.Cast"
if caster:HasModifier("modifier_invoker_dark_artistry_cape") and not (caster:HasModifier("modifier_invoker_persona_1") or caster:HasModifier("modifier_invoker_persona_3") or caster:HasModifier("modifier_invoker_persona_4") or caster:HasModifier("modifier_invoker_persona_5") or caster:HasModifier("modifier_invoker_persona_6")) then
    sound = "Hero_Invoker.Tornado.Cast.Immortal"
end
if caster:HasModifier("modifier_invoker_persona_2") then
    sound = "Hero_Invoker.Tornado.Cast.Immortal"
end

EmitSoundOnLocationWithCaster(self.caster_origin, sound, caster)
end



function invoker_tornado_custom:OnProjectileHit_ExtraData(hTarget, vLocation, table)
if not IsServer() then return end 
if not table.thinker then return end 

local caster = self:GetCaster()
local thinker = EntIndexToHScript(table.thinker)
if not thinker then return end

if not hTarget then
    UTIL_Remove(thinker)
    AddFOWViewer(caster:GetTeamNumber(), vLocation, self.vision, self.vision_duration, false)
    return nil
end

if not thinker.hit_targets[hTarget] then 

    thinker.hit_targets[hTarget] = true

    local ability = caster:FindAbilityByName("invoker_invoke_custom")
    if ability then 
        ability:AbilityHit(hTarget)
    end 
end 


if hTarget:IsCreep() then 
    local damageTable = 
    { 
        victim = hTarget,
        attacker = caster,
        damage = 1,
        damage_type = self:GetAbilityDamageType(),
        ability = self
    }
    local real_damage = DoDamage(damageTable)
end 

if not hTarget:IsDebuffImmune() then 
    hTarget:InterruptMotionControllers(true)
    hTarget:AddNewModifier(caster, self, "modifier_invoker_tornado_custom", {is_scepter = table.is_scepter, duration = self.duration*(1 - hTarget:GetStatusResistance()) })
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

function modifier_invoker_tornado_custom:IsMotionController() return true end
function modifier_invoker_tornado_custom:GetMotionControllerPriority()  return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHm end

function modifier_invoker_tornado_custom:OnCreated(kv)
if not IsServer() then return end

self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.damage_duration = self.caster:GetTalentValue("modifier_invoker_wex_1", "duration")

local abs = GetGroundPosition(self:GetParent():GetAbsOrigin(), nil)

local effect_name = "particles/units/heroes/hero_invoker/invoker_tornado_child.vpcf"
if self:GetCaster():HasModifier("modifier_invoker_dark_artistry_cape") and not (self:GetCaster():HasModifier("modifier_invoker_persona_1") or self:GetCaster():HasModifier("modifier_invoker_persona_3") or self:GetCaster():HasModifier("modifier_invoker_persona_4") or self:GetCaster():HasModifier("modifier_invoker_persona_5") or self:GetCaster():HasModifier("modifier_invoker_persona_6")) then
    effect_name = "particles/econ/items/invoker/invoker_ti6/invoker_tornado_child_ti6.vpcf"
end
if self:GetCaster():HasModifier("modifier_invoker_persona_2") then
    effect_name = "particles/econ/items/invoker/invoker_ti6/invoker_tornado_child_ti6.vpcf"
end

self.effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_WORLDORIGIN, nil )
ParticleManager:SetParticleControl( self.effect_cast, 0, abs )
self:AddParticle(self.effect_cast, false, false, -1, false, true)

self.interval = 0.02

self.purge_duration = self.ability:GetSpecialValueFor("scepter_purge")
self.is_scepter = kv.is_scepter

self.parent:EmitSound("Hero_Invoker.Tornado.Target" )
self.parent:Purge(true, false, false, false, false)

self.height = 450
self.height_duration = 0.3
self.height_inc = self.height/(self.height_duration/self.interval)

self.damage = self.ability:GetSpecialValueFor("base_damage") + self.caster:GetValueWex(self.ability, "wex_damage")

self.angle = self.parent:GetAngles()
self.abs = self.parent:GetAbsOrigin()
self.cyc_pos = self.parent:GetAbsOrigin()
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
if self.parent:IsDebuffImmune() then self:Destroy() return end
if self.parent:IsMagicImmune() then self:Destroy() return end

self:HorizontalMotion(self.parent, self.interval)
end


function modifier_invoker_tornado_custom:OnDestroy()
if not IsServer() then return end
self.parent:Stop()

self.parent:StopSound("Hero_Invoker.Tornado.Target")
self.parent:EmitSound("Hero_Invoker.Tornado.LandDamage")

if not self.parent:IsDebuffImmune() then
    self.parent:SetAbsOrigin(self.abs)
    ResolveNPCPositions(self.parent:GetAbsOrigin(), 128)
    self.parent:SetAngles(self.angle[1], self.angle[2], self.angle[3])
end

if self.caster and self.ability then

    if self.is_scepter and self.is_scepter == 1 then 
        self.parent:AddNewModifier(self.caster, self.ability, "modifier_invoker_tornado_custom_purge", {duration = self.purge_duration})
    end 

    if self.caster:HasTalent("modifier_invoker_wex_1") then
        self.parent:AddNewModifier(self.caster, self.ability, "modifier_invoker_tornado_custom_damage", {duration = self.damage_duration})
    end

    local damageTable = 
    { 
        victim = self.parent,
        attacker = self.caster,
        damage = self.damage,
        damage_type = self.ability:GetAbilityDamageType(),
        ability = self.ability 
    }
    DoDamage(damageTable)

    if self.caster:HasTalent("modifier_invoker_wex_6") then 
        self.parent:EmitSound("Sf.Raze_Silence")
        self.parent:AddNewModifier(self.caster, self.ability, "modifier_generic_silence", {duration = (1 - self.parent:GetStatusResistance())*self.caster:GetTalentValue("modifier_invoker_wex_6", "silence")})
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
if self:GetCaster():HasTalent("modifier_invoker_wex_6") then 
    state[MODIFIER_STATE_SILENCED] = true
end

return state
end


function modifier_invoker_tornado_custom:HorizontalMotion(unit, time)
if not IsServer() then return end
local angle = self.parent:GetAngles()
local new_angle = RotateOrientation(angle, QAngle(0, 14, 0))

self.parent:SetAngles(new_angle[1], new_angle[2], new_angle[3])

if self:GetElapsedTime() <= self.height_duration then
    self.cyc_pos.z = self.cyc_pos.z + self.height_inc
    self.parent:SetAbsOrigin(self.cyc_pos)

elseif self:GetDuration() - self:GetElapsedTime() < self.height_duration then
   
    self.cyc_pos.z = self.cyc_pos.z - self.height_inc
    self.parent:SetAbsOrigin(self.cyc_pos)
else
    local pos = GetRandomPosition2D(self.parent:GetAbsOrigin(), 4)
    if (pos - self.abs):Length2D() < self.height_inc  then
        self.parent:SetAbsOrigin(pos)
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
self.parent = self:GetParent()
self.ability = self:GetAbility()

local more_cd = self.parent:GetTalentValue("modifier_invoker_wex_7", "cd")*self:GetStackCount()

self.ability:UseResources(false, false, false, true)
self.parent:CdAbility(self.ability, self:GetElapsedTime() - more_cd)
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
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end

function modifier_invoker_alacrity_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end
   
function modifier_invoker_alacrity_custom_speed:GetModifierAttackRangeBonus()
return self.range
end

function modifier_invoker_alacrity_custom_speed:OnCreated()
self.parent = self:GetParent()

self.speed = self.parent:GetTalentValue("modifier_invoker_wex_4", "speed")
self.range = self.parent:GetTalentValue("modifier_invoker_wex_4", "range")
if not IsServer() then return end 
self.parent:GenericParticle("particles/invoker/alacrity_max.vpcf", self)
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
return MODIFIER_PRIORITY_SUPER_ULTRA 
end 

function modifier_invoker_tornado_custom_purge:CheckState() 
return 
{
    [MODIFIER_STATE_PASSIVES_DISABLED] = true
} 
end

function modifier_invoker_tornado_custom_purge:OnCreated()
if not IsServer() then return end 
self.parent = self:GetParent()
self.parent:GenericParticle("particles/generic_gameplay/generic_break.vpcf", self, true)

self.parent:EmitSound("Invoker.Scepter_tornado")

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end 

function modifier_invoker_tornado_custom_purge:OnIntervalThink()
if not IsServer() then return end 
if self.parent:IsDebuffImmune() then return end

self.parent:Purge(true, false, false, false,false)
end 






modifier_invoker_emp_custom_legendary = class({})
function modifier_invoker_emp_custom_legendary:IsHidden() return false end
function modifier_invoker_emp_custom_legendary:IsPurgable() return false end
function modifier_invoker_emp_custom_legendary:OnCreated()
self.caster = self:GetCaster()
self.parent = self:GetParent()
self.max = self.caster:GetTalentValue("modifier_invoker_wex_7", "max")

if not IsServer() then return end 

self.effect_cast = ParticleManager:CreateParticle( "particles/invoker/emp_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
self:AddParticle(self.effect_cast,false, false, -1, false, false)

self:SetStackCount(1)
self:OnIntervalThink()
self:StartIntervalThink(0.5)
end

function modifier_invoker_emp_custom_legendary:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end

function modifier_invoker_emp_custom_legendary:OnIntervalThink()
if not IsServer() then return end
if not self.parent:HasModifier("modifier_invoker_cold_snap_custom_legendary") then return end
if not self.effect_cast then return end 

ParticleManager:DestroyParticle(self.effect_cast, true)
ParticleManager:ReleaseParticleIndex(self.effect_cast)
self.effect_cast = nil

end

function modifier_invoker_emp_custom_legendary:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.effect_cast then return end

ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )
end


modifier_invoker_tornado_custom_damage = class({})
function modifier_invoker_tornado_custom_damage:IsHidden() return true end
function modifier_invoker_tornado_custom_damage:IsPurgable() return false end
function modifier_invoker_tornado_custom_damage:GetEffectName() return "particles/hoodwink/bush_damage.vpcf" end
function modifier_invoker_tornado_custom_damage:OnCreated()
self.damage = self:GetCaster():GetTalentValue("modifier_invoker_wex_1", "damage")
end

function modifier_invoker_tornado_custom_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_invoker_tornado_custom_damage:GetModifierIncomingDamage_Percentage()
return self.damage
end


modifier_invoker_emp_custom_armor = class({})
function modifier_invoker_emp_custom_armor:IsHidden() return false end
function modifier_invoker_emp_custom_armor:IsPurgable() return false end
function modifier_invoker_emp_custom_armor:GetTexture() return "buffs/wex_attack" end
function modifier_invoker_emp_custom_armor:OnCreated()
self.armor = self:GetParent():GetTalentValue("modifier_invoker_wex_3", "armor")
end

function modifier_invoker_emp_custom_armor:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_invoker_emp_custom_armor:GetModifierPhysicalArmorBonus()
return self.armor
end
