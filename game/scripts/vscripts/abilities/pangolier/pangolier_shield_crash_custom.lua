LinkLuaModifier("modifier_pangolier_shield_crash_custom_tracker", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_shield_crash_custom_buff", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_shield_crash_custom_slow", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_shield_crash_custom_damage_tracker", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_shield_crash_custom_speed", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_shield_crash_custom_scepter", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_shield_crash_custom_ulti", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_shield_crash_custom_reduce", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_shield_crash_custom_legendary", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_shield_crash_custom_immune", "abilities/pangolier/pangolier_shield_crash_custom", LUA_MODIFIER_MOTION_NONE)

pangolier_shield_crash_custom = class({})





function pangolier_shield_crash_custom:GetIntrinsicModifierName()
return "modifier_pangolier_shield_crash_custom_tracker"
end

function pangolier_shield_crash_custom:GetCooldown(iLevel)

if self:GetCaster():HasModifier("modifier_pangolier_gyroshell_custom") and self:GetCaster():FindAbilityByName("pangolier_gyroshell_custom") then 
    return self:GetCaster():FindAbilityByName("pangolier_gyroshell_custom"):GetSpecialValueFor("crash_cd")
end

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_pangolier_shield_6") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_pangolier_shield_6", "cd")
end 

return self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown

end



function pangolier_shield_crash_custom:GetBehavior()
if self:GetCaster():HasModifier("modifier_pangolier_shield_6") then 
   -- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE
end

return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end






function pangolier_shield_crash_custom:OnSpellStart()
if not IsServer() then return end



local caster = self:GetCaster()
local distance = self:GetSpecialValueFor("jump_horizontal_distance")
local duration = self:GetSpecialValueFor("jump_duration")
local height = self:GetSpecialValueFor("jump_height")
local radius = self:GetSpecialValueFor("radius")
local damage = self:GetSpecialValueFor("damage")
local buff_duration = self:GetSpecialValueFor("duration")
local slow_duration = self:GetSpecialValueFor("slow_duration")
local scepter_strikes = self:GetSpecialValueFor("scepter_strikes")

local passive = self:GetCaster():FindAbilityByName("pangolier_lucky_shot_custom")
local swash = self:GetCaster():FindAbilityByName("pangolier_swashbuckle_custom")
local ulti = self:GetCaster():FindAbilityByName("pangolier_gyroshell_custom")


if swash and swash:GetLevel() > 0 and caster:HasScepter() then 
    caster:AddNewModifier(caster, swash, "modifier_pangolier_shield_crash_custom_scepter", {strikes = scepter_strikes })
end


local bonus = 0

if self:GetCaster():HasModifier("modifier_pangolier_shield_crash_custom_damage_tracker") then 

    for _,mod in pairs(self:GetCaster():FindAllModifiersByName("modifier_pangolier_shield_crash_custom_damage_tracker")) do 
        bonus = bonus + mod:GetStackCount()
        mod:Destroy()
    end

end

damage = damage + bonus

if self:GetCaster():HasModifier("modifier_pangolier_shield_2") then 
    slow_duration = slow_duration + self:GetCaster():GetTalentValue("modifier_pangolier_shield_2", "duration")
end

if self:GetCaster():HasModifier("modifier_pangolier_shield_5") then 
    distance = distance + self:GetCaster():GetTalentValue("modifier_pangolier_shield_5", "distance")
end



self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)

self:GetCaster():EmitSound("Hero_Pangolier.TailThump.Cast")


local ulti_mod = self:GetCaster():FindModifierByName("modifier_pangolier_gyroshell_custom")


if ulti_mod  then 
    duration = self:GetSpecialValueFor("jump_duration_gyroshell")
    height = self:GetSpecialValueFor("jump_height_gyroshell")
    distance = ulti_mod.max_speed*duration
end


if self:GetCaster():HasModifier("modifier_pangolier_rollup_custom") then 

    duration = self:GetSpecialValueFor("jump_duration_gyroshell")
    height = self:GetSpecialValueFor("jump_height_gyroshell")
    distance = 1

    self:GetCaster():StartGesture(ACT_DOTA_RUN)
end

if self:GetCaster():IsRooted() or self:GetCaster():IsStunned() then  
    distance = 1
    height = height*0.7
end




local speed = math.max(1, distance/duration)
local point = caster:GetAbsOrigin() + caster:GetForwardVector()*distance


local arc = caster:AddNewModifier( caster, self, "modifier_generic_arc",
{
  target_x = point.x,
  target_y = point.y,
  distance = distance,
  speed = speed,
  height = height,
  fix_end = false,
  isStun = true,

})

local dust = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(dust, 0, self:GetCaster():GetAbsOrigin())


arc:AddParticle( dust, false, false, -1, false, false  )




if not arc then return end

arc:SetEndCallback(function()

    if not self:GetCaster():HasModifier(("modifier_pangolier_gyroshell_custom")) then 
        self:GetCaster():FadeGesture(ACT_DOTA_RUN)
    else 
        self:GetCaster():AddNewModifier(self:GetCaster(), ulti, "modifier_pangolier_gyroshell_custom_turn_boost", {duration = ulti:GetSpecialValueFor("jump_recover_time")})
    end

    local part = "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf"


    if self:GetCaster():HasModifier("modifier_pangolier_shield_3") then 
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pangolier_shield_crash_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_shield_3", "duration")})
    end

    EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_Pangolier.TailThump", self:GetCaster())

    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE,  FIND_ANY_ORDER, false )

    if #enemies > 0 then 
        part = "particles/units/heroes/hero_pangolier/pangolier_tailthump_hero.vpcf"
        self:GetCaster():EmitSound("Hero_Pangolier.TailThump.Shield")


        if bonus > 0 then 

              self:GetCaster():EmitSound("Pango.Shield_heal")    

              local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
              ParticleManager:ReleaseParticleIndex( particle )
        end

        self:GetCaster():RemoveModifierByName("modifier_pangolier_shield_crash_custom_legendary")

        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pangolier_shield_crash_custom_buff", {duration = buff_duration, bonus = bonus})
    end

    for _,enemy in pairs(enemies) do

        if passive and passive:GetLevel() > 0 then 
            passive:ProcPassive(enemy, false)
        end

        if self:GetCaster():HasModifier("modifier_pangolier_shield_5") then 
            enemy:EmitSound("Sf.Raze_Silence")
            enemy:AddNewModifier(self:GetCaster(), self, "modifier_generic_silence", {duration = (1 - enemy:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_pangolier_shield_5", "silence")})
        end

        enemy:AddNewModifier(self:GetCaster(), self, "modifier_pangolier_shield_crash_custom_slow", {duration = (1 - enemy:GetStatusResistance())*slow_duration})

        if bonus > 0 then 

            SendOverheadEventMessage(enemy, 6, enemy,  bonus, nil)
        end

        local damage_table = ({ victim = enemy, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
        ApplyDamage(damage_table)
    end

    local smash = ParticleManager:CreateParticle(part, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(smash, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:DestroyParticle(smash, false)
    ParticleManager:ReleaseParticleIndex(smash)

end)


end


modifier_pangolier_shield_crash_custom_buff = class({})

function modifier_pangolier_shield_crash_custom_buff:IsHidden() return false end
function modifier_pangolier_shield_crash_custom_buff:IsPurgable() 
    return false
end

function modifier_pangolier_shield_crash_custom_buff:OnCreated(table)

self.shield = self:GetAbility():GetSpecialValueFor("hero_stacks")

if self:GetCaster():HasModifier("modifier_pangolier_shield_1") then 
    self.shield = self.shield + self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_pangolier_shield_1", "shield")/100
end


if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_pangolier_shield_6") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_shield_crash_custom_immune", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_shield_6", "immune")})
end 

self.max = self.shield + table.bonus

self.legendary_heal = self:GetCaster():GetTalentValue("modifier_pangolier_shield_7", "heal")/100
self.legendary_creeps = self:GetCaster():GetTalentValue("modifier_pangolier_shield_7", "creeps")


self.max_shield = self.shield + table.bonus
self:SetStackCount(self.shield + table.bonus)


self.time = self:GetRemainingTime()

self.damage = 0

self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "Hero_Pangolier.TailThump.Shield"
self.buff_particles = {}

self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)

self:SetHasCustomTransmitterData(true)
self:OnIntervalThink()
self:StartIntervalThink(0.1)
end




function modifier_pangolier_shield_crash_custom_buff:OnRefresh(table)
self.shield = self:GetAbility():GetSpecialValueFor("hero_stacks")

if self:GetCaster():HasModifier("modifier_pangolier_shield_1") then 
    self.shield = self.shield + self:GetParent():GetMaxHealth()*self:GetCaster():GetTalentValue("modifier_pangolier_shield_1", "shield")/100
end


if not IsServer() then return end

self.max_shield = self.shield + table.bonus

self:SetStackCount(self.shield + table.bonus)
self:SendBuffRefreshToClients()
end 


function modifier_pangolier_shield_crash_custom_buff:AddCustomTransmitterData() 
return 
{
    max_shield = self.max_shield ,
} 
end

function modifier_pangolier_shield_crash_custom_buff:HandleCustomTransmitterData(data)
self.max_shield  = data.max_shield
end


function modifier_pangolier_shield_crash_custom_buff:GetModifierIncomingDamageConstant( params )
if self:GetStackCount() == 0 then return end


if IsClient() then 
    if params.report_max then 
        return self.max_shield
    else 
        return self:GetStackCount()
    end 
end

if not IsServer() then return end

if self:GetStackCount() > params.damage or self:GetParent():HasModifier("modifier_pangolier_shield_crash_custom_immune")  then


    if not self:GetParent():HasModifier("modifier_pangolier_shield_crash_custom_immune") then
        self:SetStackCount(self:GetStackCount() - params.damage)
    else 
        self:GetParent():EmitSound("Juggernaut.Parry")
        local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
        ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )

    end 


    local i = params.damage

    if self:GetParent():GetQuest() == "Pangolier.Quest_6" and params.attacker:IsRealHero() then 
        self:GetParent():UpdateQuest(math.abs(i))
    end



    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)
    self:Destroy()

    if self:GetParent():GetQuest() == "Pangolier.Quest_6" and params.attacker:IsRealHero() then 
        self:GetParent():UpdateQuest(math.abs(i))
    end


    return -i
end

end


function modifier_pangolier_shield_crash_custom_buff:OnTakeDamage(params)
if not IsServer() then return end 

if not self:GetParent():HasModifier("modifier_pangolier_shield_7") then return end 
if self:GetParent() ~= params.attacker then return end 
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if params.unit:IsIllusion() then return end 
if params.damage < 0 then return end

local shield_k = self.legendary_heal


if params.unit:IsCreep() then 
    shield_k = shield_k/self.legendary_creeps
end 

self:SetStackCount(math.min(self.max, self:GetStackCount() + shield_k*params.damage))

end 



function modifier_pangolier_shield_crash_custom_buff:OnIntervalThink()
if not IsServer() then return end



if self:GetParent():HasModifier("modifier_pangolier_shield_7") then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pangolier_shield_change',  {stage = 0, hide = 0, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})
end

end




function modifier_pangolier_shield_crash_custom_buff:DeclareFunctions()
return
{
     MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end







function modifier_pangolier_shield_crash_custom_buff:OnDestroy()
if not IsServer() then return end


if self:GetParent():HasModifier("modifier_pangolier_shield_7") then 

    if self:GetStackCount() > 0 then 
        self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_shield_crash_custom_legendary", {count = self:GetStackCount(), duration = self:GetCaster():GetTalentValue("modifier_pangolier_shield_7", "duration")})
    else 
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pangolier_shield_change',  {stage = 0, hide = 1, max_time = self.time, time = self:GetRemainingTime(), damage = self:GetStackCount()})
    end 
end


if self:GetCaster():HasModifier("modifier_pangolier_shield_6") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_shield_crash_custom_reduce", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_shield_6", "duration")})
end



end



modifier_pangolier_shield_crash_custom_slow = class({})

function modifier_pangolier_shield_crash_custom_slow:IsPurgable() return true end
function modifier_pangolier_shield_crash_custom_slow:IsHidden() return false end


function modifier_pangolier_shield_crash_custom_slow:OnCreated(table)

self.slow = self:GetAbility():GetSpecialValueFor("slow")*-1

if self:GetCaster():HasModifier("modifier_pangolier_shield_2") then 
    self.slow = self.slow + self:GetCaster():GetTalentValue("modifier_pangolier_shield_2", "slow")

end

end

function modifier_pangolier_shield_crash_custom_slow:DeclareFunctions()
local funcs = 
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
return funcs
end

function modifier_pangolier_shield_crash_custom_slow:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end



function modifier_pangolier_shield_crash_custom_slow:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_pangolier_shield_crash_custom_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_pangolier_shield_crash_custom_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_pangolier_shield_crash_custom_slow:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end




pangolier_shield_crash_custom_legendary = class({})

function pangolier_shield_crash_custom_legendary:OnSpellStart()
if not IsServer() then return end


local mod = self:GetCaster():FindModifierByName("modifier_pangolier_shield_crash_custom_legendary")

if not mod then 
    return
end

local damage = mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_pangolier_shield_7", "damage")/100

mod:Destroy()

local main = self:GetCaster():FindAbilityByName("pangolier_shield_crash_custom")

local caster = self:GetCaster()
local distance = self:GetSpecialValueFor("jump_horizontal_distance")
local duration = self:GetSpecialValueFor("jump_duration")
local height = self:GetSpecialValueFor("jump_height")
local radius = self:GetSpecialValueFor("radius")

local ulti = self:GetCaster():FindAbilityByName("pangolier_gyroshell_custom")
local passive = self:GetCaster():FindAbilityByName("pangolier_lucky_shot_custom")



if self:GetCaster():HasModifier("modifier_pangolier_shield_5") and main then 
    distance = distance + self:GetCaster():GetTalentValue("modifier_pangolier_shield_5", "distance")
end



self:GetCaster():StartGesture(ACT_DOTA_CAST_ABILITY_2)

local ulti_mod = self:GetCaster():FindModifierByName("modifier_pangolier_gyroshell_custom")


if ulti_mod  then 
    duration = main:GetSpecialValueFor("jump_duration_gyroshell")
    height = main:GetSpecialValueFor("jump_height_gyroshell")
    distance = ulti_mod.max_speed*duration
end


if self:GetCaster():HasModifier("modifier_pangolier_rollup_custom") then 

    duration = main:GetSpecialValueFor("jump_duration_gyroshell")
    height = main:GetSpecialValueFor("jump_height_gyroshell")
    distance = 1

    self:GetCaster():StartGesture(ACT_DOTA_RUN)
end


local speed = distance/duration

local point = caster:GetAbsOrigin() + caster:GetForwardVector()*distance


self:GetCaster():EmitSound("Hero_Pangolier.TailThump.Cast")

local arc = caster:AddNewModifier( caster, self, "modifier_generic_arc",
{
  target_x = point.x,
  target_y = point.y,
  distance = distance,
  speed = speed,
  height = height,
  fix_end = false,
  isStun = true,

})

local dust = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_tailthump_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControl(dust, 0, self:GetCaster():GetAbsOrigin())


arc:AddParticle( dust, false, false, -1, false, false  )

if not arc then return end

arc:SetEndCallback(function()

    if not self:GetCaster():HasModifier(("modifier_pangolier_gyroshell_custom")) then 
        self:GetCaster():FadeGesture(ACT_DOTA_RUN)
    else 
        self:GetCaster():AddNewModifier(self:GetCaster(), ulti, "modifier_pangolier_gyroshell_custom_turn_boost", {duration = ulti:GetSpecialValueFor("jump_recover_time")})
    end


    if self:GetCaster():HasModifier("modifier_pangolier_shield_3") then 
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pangolier_shield_crash_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_shield_3", "duration")})
    end



    local part = "particles/units/heroes/hero_pangolier/pangolier_tailthump.vpcf"

    EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Hero_Pangolier.TailThump", self:GetCaster())

    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE,  FIND_ANY_ORDER, false )

    for _,enemy in pairs(enemies) do

        if passive and passive:GetLevel() > 0 then 
            passive:ProcPassive(enemy, false)
        end


        local damage_table = ({ victim = enemy, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_PURE })
        local real_damage = ApplyDamage(damage_table)
        

        SendOverheadEventMessage(enemy, 6, enemy, real_damage, nil)
    end



    local smash = ParticleManager:CreateParticle(part, PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(smash, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:DestroyParticle(smash, false)
    ParticleManager:ReleaseParticleIndex(smash)

    EmitSoundOnLocationWithCaster(self:GetCaster():GetAbsOrigin(), "Pango.Shield_legendary", self:GetCaster())

    local smash2 = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_burst.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(smash2, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(smash2, 1, Vector(radius, radius, radius))
    ParticleManager:DestroyParticle(smash2, false)
    ParticleManager:ReleaseParticleIndex(smash2)

    local smash3 = ParticleManager:CreateParticle("particles/items3_fx/blink_overwhelming_burst.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(smash3, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(smash3, 1, Vector(radius*0.6, radius*0.6, radius*0.6))
    ParticleManager:DestroyParticle(smash3, false)
    ParticleManager:ReleaseParticleIndex(smash3)
end)



end












modifier_pangolier_shield_crash_custom_damage_tracker = class({})
function modifier_pangolier_shield_crash_custom_damage_tracker:IsHidden() return true end
function modifier_pangolier_shield_crash_custom_damage_tracker:IsPurgable() return false end
function modifier_pangolier_shield_crash_custom_damage_tracker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end



modifier_pangolier_shield_crash_custom_tracker = class({})
function modifier_pangolier_shield_crash_custom_tracker:IsHidden() return true end
function modifier_pangolier_shield_crash_custom_tracker:IsPurgable() return false end
function modifier_pangolier_shield_crash_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_pangolier_shield_crash_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_pangolier_shield_4") then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end
if not params.attacker:IsCreep() and not params.attacker:IsHero() then return end


local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pangolier_shield_crash_custom_damage_tracker", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_shield_4", "duration")})

if mod then 
    mod:SetStackCount(params.damage*self:GetCaster():GetTalentValue("modifier_pangolier_shield_4", "heal")/100)
end

end





modifier_pangolier_shield_crash_custom_speed = class({})

function modifier_pangolier_shield_crash_custom_speed:IsHidden() return false end
function modifier_pangolier_shield_crash_custom_speed:IsPurgable() return false end
function modifier_pangolier_shield_crash_custom_speed:GetTexture() return "buffs/shield_speed" end
function modifier_pangolier_shield_crash_custom_speed:DeclareFunctions()
return
{
  MODIFIER_EVENT_ON_TAKEDAMAGE,
  MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end


function modifier_pangolier_shield_crash_custom_speed:OnCreated()

self.speed = self:GetCaster():GetTalentValue("modifier_pangolier_shield_3", "speed")
self.heal = self:GetCaster():GetTalentValue("modifier_pangolier_shield_3", "heal")/100
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_pangolier_shield_3", "heal_creeps")
end 


function modifier_pangolier_shield_crash_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end


function modifier_pangolier_shield_crash_custom_speed:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if self:GetParent() == params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

local heal = self.heal
if params.unit:IsCreep() then 
  heal = heal * self.heal_creeps
end

heal = heal*params.damage

self:GetParent():GenericHeal(heal, self:GetAbility(), true)

end






modifier_pangolier_shield_crash_custom_scepter = class({})
function modifier_pangolier_shield_crash_custom_scepter:IsHidden() return true end
function modifier_pangolier_shield_crash_custom_scepter:IsPurgable() return false end
function modifier_pangolier_shield_crash_custom_scepter:OnCreated(table)
if not IsServer() then return end

self.range = self:GetAbility():GetSpecialValueFor( "range" )
self.radius = self:GetAbility():GetSpecialValueFor( "start_radius" )

self.interval = self:GetAbility():GetSpecialValueFor( "attack_interval" )
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
self.strikes = table.strikes

if self:GetCaster():HasModifier("modifier_pangolier_buckle_3") then 
    self.damage = self.damage + self:GetCaster():GetTalentValue("modifier_pangolier_buckle_3", "damage")*self:GetParent():GetAverageTrueAttackDamage(nil)/100
end

self.origin = self:GetParent():GetAbsOrigin()


self.count = 0

self:StartIntervalThink(self.interval)
self:OnIntervalThink()
end


function modifier_pangolier_shield_crash_custom_scepter:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,
    }

    return funcs
end


function modifier_pangolier_shield_crash_custom_scepter:GetModifierOverrideAttackDamage()
    return self.damage
end



function modifier_pangolier_shield_crash_custom_scepter:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():IsHexed() then 
    self:Destroy()
    return
end

self.count = self.count+1
if self.count>self.strikes then
    self:Destroy()
    return
end

self:GetParent():EmitSound("Hero_Pangolier.Swashbuckle")

self.targets = {}

for i = 1,4 do 

    self.dir = Vector(self:GetParent():GetForwardVector().x, self:GetParent():GetForwardVector().y, 0)

    self.target = self.origin + self.dir*self.range

    if i == 2 then
        self.target = RotatePosition(self.origin , QAngle(0, -90, 0), self.target)
    end

    if i == 3 then
        self.dir = Vector(self:GetParent():GetForwardVector().x, self:GetParent():GetForwardVector().y, 0) * -1
        self.target = self.origin + self.dir*self.range
    end

    if i == 4 then
        self.target = RotatePosition(self.origin , QAngle(0, 90, 0), self.target)
    end

    self.dir = (self.target - self.origin):Normalized()


    local enemies = FindUnitsInLine(self:GetParent():GetTeamNumber(), self.origin, self.target, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  0 )

    for _,enemy in pairs(enemies) do
        if not self.targets[enemy] then 

            self.targets[enemy] = true
            self:GetAbility():DealDamage(enemy, false, true)
        end
    end


    local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf", PATTACH_POINT, self:GetParent() )
    ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_ABSORIGIN, "attach_hitloc", self:GetParent():GetOrigin(), true )
    ParticleManager:SetParticleControl( effect_cast, 1, self.dir*self:GetAbility():GetSpecialValueFor("range") )
    ParticleManager:SetParticleControl( effect_cast, 3, self.dir*self:GetAbility():GetSpecialValueFor("range") )
        
    self:AddParticle( effect_cast, false,  false, -1,  false, false )

    Timers:CreateTimer(0.2, function()

        if effect_cast then
            ParticleManager:DestroyParticle(effect_cast, false)
            ParticleManager:ReleaseParticleIndex(effect_cast)
        end
    end)

    self:GetParent():EmitSound("Hero_Pangolier.Swashbuckle.Attack")

end


end


modifier_pangolier_shield_crash_custom_ulti = class({})
function modifier_pangolier_shield_crash_custom_ulti:IsHidden() return true end
function modifier_pangolier_shield_crash_custom_ulti:IsPurgable() return false end
function modifier_pangolier_shield_crash_custom_ulti:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MODEL_CHANGE,
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_pangolier_shield_crash_custom_ulti:GetModifierModelChange()
return "models/heroes/pangolier/pangolier_gyroshell2.vmdl"
end

function modifier_pangolier_shield_crash_custom_ulti:GetOverrideAnimation()
return ACT_DOTA_RUN
end


function modifier_pangolier_shield_crash_custom_ulti:GetEffectName()
return "particles/units/heroes/hero_pangolier/pangolier_gyroshell.vpcf"
end

modifier_pangolier_shield_crash_custom_reduce = class({})

function modifier_pangolier_shield_crash_custom_reduce:IsHidden() return false end
function modifier_pangolier_shield_crash_custom_reduce:IsPurgable() return false end
function modifier_pangolier_shield_crash_custom_reduce:GetTexture() return "buffs/shield_reduce" end

function modifier_pangolier_shield_crash_custom_reduce:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_pangolier_shield_crash_custom_reduce:GetModifierIncomingDamage_Percentage()
return self.reduce
end


function modifier_pangolier_shield_crash_custom_reduce:OnCreated(table)

self.reduce = self:GetCaster():GetTalentValue("modifier_pangolier_shield_6", "damage_reduce")

if not IsServer() then return end

self.particle_1 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
self.particle_2 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_egg.vpcf"
self.particle_3 = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff_streaks.vpcf"
self.sound = "Hero_Pangolier.TailThump.Shield"
self.buff_particles = {}

self:GetParent():EmitSound(self.sound)

self.buff_particles[1] = ParticleManager:CreateParticle(self.particle_1, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[1], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[1], false, false, -1, true, false)
ParticleManager:SetParticleControl( self.buff_particles[1], 3, Vector( 255, 255, 255 ) )

self.buff_particles[2] = ParticleManager:CreateParticle(self.particle_2, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[2], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[2], false, false, -1, true, false)

self.buff_particles[3] = ParticleManager:CreateParticle(self.particle_3, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.buff_particles[3], 1, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, nil, Vector(0,0,0), false) 
self:AddParticle(self.buff_particles[3], false, false, -1, true, false)

end


modifier_pangolier_shield_crash_custom_legendary = class({})
function modifier_pangolier_shield_crash_custom_legendary:IsHidden() return true end
function modifier_pangolier_shield_crash_custom_legendary:IsPurgable() return false end
function modifier_pangolier_shield_crash_custom_legendary:GetEffectName() return "particles/mars_revenge_proc_hands.vpcf" end
function modifier_pangolier_shield_crash_custom_legendary:OnCreated(table)
if not IsServer() then return end 

local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex(particle_peffect)

self:GetParent():EmitSound("Pango.Shield_legendary_proc")

self:SetStackCount(table.count)

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pangolier_shield_change',  {stage = 1, hide = 0, max_time = 1, time = 0, damage = self:GetStackCount()})


if not self:GetAbility():IsHidden() then 
    self:GetCaster():SwapAbilities(self:GetAbility():GetName(), "pangolier_shield_crash_custom_legendary", false, true)
end 

end 

function modifier_pangolier_shield_crash_custom_legendary:OnDestroy()
if not IsServer() then return end 

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pangolier_shield_change',  {stage = 1, hide = 1, max_time = 1, time = 0, damage = self:GetStackCount()})

if self:GetAbility():IsHidden() then 
    self:GetCaster():SwapAbilities(self:GetAbility():GetName(), "pangolier_shield_crash_custom_legendary", true, false)
end 

end 


modifier_pangolier_shield_crash_custom_immune = class({})
function modifier_pangolier_shield_crash_custom_immune:IsHidden() return true end
function modifier_pangolier_shield_crash_custom_immune:IsPurgable() return false end