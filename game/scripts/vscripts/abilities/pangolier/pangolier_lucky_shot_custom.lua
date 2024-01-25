LinkLuaModifier("modifier_pangolier_lucky_shot_custom_tracker", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_lucky_shot_custom_disarm", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_lucky_shot_custom_cd", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_lucky_shot_custom_dash", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_pangolier_lucky_shot_custom_silence_cd", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_lucky_shot_custom_legendary", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_lucky_shot_custom_legendary_proc", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_lucky_shot_custom_legendary_unit", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_lucky_shot_custom_disarm_effect", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_lucky_shot_custom_speed", "abilities/pangolier/pangolier_lucky_shot_custom", LUA_MODIFIER_MOTION_NONE)

pangolier_lucky_shot_custom = class({})





function pangolier_lucky_shot_custom:GetCastRange(vLocation, hTarget)
if self:GetCaster():HasModifier("modifier_pangolier_lucky_6") then 
    return self:GetCaster():GetTalentValue("modifier_pangolier_lucky_6", "cast")
end

return 
end


function pangolier_lucky_shot_custom:GetCooldown(iLevel)
if self:GetCaster():HasModifier("modifier_pangolier_lucky_6") then 
    return self:GetCaster():GetTalentValue("modifier_pangolier_lucky_6", "cd")
end

return 
end



function pangolier_lucky_shot_custom:GetBehavior()


if self:GetCaster():HasModifier("modifier_pangolier_lucky_6") then 
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end

return DOTA_ABILITY_BEHAVIOR_PASSIVE
end



function pangolier_lucky_shot_custom:GetIntrinsicModifierName()
return "modifier_pangolier_lucky_shot_custom_tracker"
end


function pangolier_lucky_shot_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():RemoveModifierByName("modifier_pangolier_rollup_custom")
self:GetCaster():RemoveModifierByName("modifier_pangolier_gyroshell_custom")

local target = self:GetCursorTarget()
local caster = self:GetCaster()
local dir = (target:GetAbsOrigin() - caster:GetAbsOrigin())

dir.z = 0
dir = dir:Normalized()

target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_6", "stun")})

target:EmitSound("Pango.Lucky_dash2")

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pangolier_lucky_shot_custom_dash", 
{
    target = target:entindex(),
    x = dir.x,
    y = dir.y,
    duration = 3
})


end



function pangolier_lucky_shot_custom:ProcPassive(target, proc)
if not IsServer() then return end

local chance = self:GetSpecialValueFor("chance_pct")
local duration = self:GetSpecialValueFor("duration")


if self:GetCaster():HasModifier("modifier_pangolier_lucky_1") then 
    chance = chance + self:GetCaster():GetTalentValue("modifier_pangolier_lucky_1", "chance")
end

duration = duration * (1 - target:GetStatusResistance())


if not proc then 

    if target:HasModifier("modifier_pangolier_lucky_shot_custom_cd") then 
        return
    else 

        if not RollPseudoRandomPercentage(chance, 842, self:GetCaster()) then 
            return 
        end
    end
end


if target:IsRealHero() and self:GetCaster():GetQuest() == "Pangolier.Quest_7" then 
    self:GetCaster():UpdateQuest(1) 
end 

--target:AddNewModifier(self:GetCaster(), self, "modifier_pangolier_lucky_shot_custom_cd", {duration = self:GetSpecialValueFor("cd")})


target:AddNewModifier(self:GetCaster(), self, "modifier_pangolier_lucky_shot_custom_disarm", {duration = duration})  

target:EmitSound("Hero_Pangolier.LuckyShot.Proc")

if self:GetCaster():HasModifier("modifier_pangolier_lucky_5") and not target:HasModifier("modifier_pangolier_lucky_shot_custom_silence_cd") then 

    target:EmitSound("Sf.Raze_Silence")
    target:AddNewModifier(self:GetCaster(), self, "modifier_pangolier_lucky_shot_custom_silence_cd", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_5", "cd")})
    target:AddNewModifier(self:GetCaster(), self, "modifier_pangolier_lucky_shot_custom_disarm_effect", {duration = duration})  
end

if self:GetCaster():HasModifier("modifier_pangolier_lucky_4") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pangolier_lucky_shot_custom_speed", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_4", "duration")})
end



local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_luckyshot_disarm_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
ParticleManager:SetParticleControlEnt( particle, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)


end




modifier_pangolier_lucky_shot_custom_tracker = class({})

function modifier_pangolier_lucky_shot_custom_tracker:IsPurgable() return false end

function modifier_pangolier_lucky_shot_custom_tracker:IsHidden()   return true end

function modifier_pangolier_lucky_shot_custom_tracker:DeclareFunctions()
return 
{
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    MODIFIER_EVENT_ON_ATTACK_START,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
}
end


function modifier_pangolier_lucky_shot_custom_tracker:OnCreated(table)


self.ability = self:GetAbility()
self.caster = self:GetCaster()

self.proc = false
end


function modifier_pangolier_lucky_shot_custom_tracker:GetModifierAttackRangeBonus()
if not self:GetParent():HasModifier("modifier_pangolier_lucky_3") then return end

return self:GetCaster():GetTalentValue("modifier_pangolier_lucky_3", "range")
end






function modifier_pangolier_lucky_shot_custom_tracker:OnAttackStart(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():IsIllusion() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end

if params.target:HasModifier("modifier_pangolier_lucky_shot_custom_cd") then 
    return
end

self.proc = false

local chance = self:GetAbility():GetSpecialValueFor("chance_pct")


if self:GetCaster():HasModifier("modifier_pangolier_lucky_1") then 
    chance = chance + self:GetCaster():GetTalentValue("modifier_pangolier_lucky_1", "chance")
end


if not RollPseudoRandomPercentage(chance, 842, self.caster) then return end

self.proc = true

if params.no_attack_cooldown then return end
self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, self:GetParent():GetAttackSpeed(true))


end




function modifier_pangolier_lucky_shot_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():IsIllusion() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end


if self:GetCaster():HasModifier("modifier_pangolier_lucky_3") and not params.no_attack_cooldown then 

  self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_movespeed", 
  {
    duration = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_3", "duration"),
    movespeed = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_3", "speed"),
    effect = "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
  })
end


if not self.proc then return end

local target = params.target

self.proc = false
self:GetAbility():ProcPassive(target, true)


end


modifier_pangolier_lucky_shot_custom_disarm = class({})
function modifier_pangolier_lucky_shot_custom_disarm:IsHidden() return false end
function modifier_pangolier_lucky_shot_custom_disarm:IsPurgable() return true end


function modifier_pangolier_lucky_shot_custom_disarm:OnCreated()

self.ability    = self:GetAbility()
self.armor      = self.ability:GetSpecialValueFor("armor")
self.speed = self.ability:GetSpecialValueFor("attack_slow")*-1 + self:GetCaster():GetTalentValue("modifier_pangolier_lucky_1", "speed")

self.inc_damage = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_2", "damage")

self.damage = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_5", "damage")

if not IsServer() then return end

self:OnIntervalThink()
self:StartIntervalThink(0.1)

end


function modifier_pangolier_lucky_shot_custom_disarm:OnIntervalThink()
if not IsServer() then return end

if self.particle then 
    if self:GetParent():HasModifier("modifier_pangolier_lucky_shot_custom_legendary") or self:GetParent():HasModifier("modifier_pangolier_heartpiercer_debuff") then 
        ParticleManager:DestroyParticle(self.particle, false)
        ParticleManager:ReleaseParticleIndex(self.particle)
    end

else 

    if not self:GetParent():HasModifier("modifier_pangolier_lucky_shot_custom_legendary") and not self:GetParent():HasModifier("modifier_pangolier_heartpiercer_debuff") then 
        self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_luckyshot_disarm_debuff.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        self:AddParticle(self.particle, false, false, -1, false, false)
    end
end



end



function modifier_pangolier_lucky_shot_custom_disarm:CheckState()
return 
{
    --[MODIFIER_STATE_DISARMED] = true
}
end

function modifier_pangolier_lucky_shot_custom_disarm:DeclareFunctions()
return  
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end
function modifier_pangolier_lucky_shot_custom_disarm:GetModifierAttackSpeedBonus_Constant()
return self.speed
end
function modifier_pangolier_lucky_shot_custom_disarm:GetModifierIncomingDamage_Percentage()
return self.inc_damage
end


function modifier_pangolier_lucky_shot_custom_disarm:GetModifierSpellAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_pangolier_lucky_5") then return end
return self.damage
end



function modifier_pangolier_lucky_shot_custom_disarm:GetModifierPhysicalArmorBonus()
    return (self.armor ) * (-1)
end




modifier_pangolier_lucky_shot_custom_cd = class({})
function modifier_pangolier_lucky_shot_custom_cd:IsHidden() return true end
function modifier_pangolier_lucky_shot_custom_cd:IsPurgable() return false end












modifier_pangolier_lucky_shot_custom_dash = class({})

function modifier_pangolier_lucky_shot_custom_dash:IsDebuff() return false end
function modifier_pangolier_lucky_shot_custom_dash:IsHidden() return true end
function modifier_pangolier_lucky_shot_custom_dash:IsPurgable() return false end

function modifier_pangolier_lucky_shot_custom_dash:OnCreated(kv)
if not IsServer() then return end


self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle( self.pfx , false,  false, -1,  false, false )

--self:GetParent():EmitSound("Hero_Pangolier.Swashbuckle.Cast")
self:GetParent():EmitSound("Pango.Lucky_dash")

self.target = EntIndexToHScript(kv.target)
self.dir = Vector(kv.x, kv.y, 0):Normalized()

self.range = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_6", "range")


self.point = self.target:GetAbsOrigin() + self.dir*self.range

self:GetParent():SetForwardVector(self:GetParent():GetForwardVector()*-1 )
self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() - self:GetParent():GetForwardVector()*10)

self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)

self.speed = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_6", "dash_speed")


if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end

end



function modifier_pangolier_lucky_shot_custom_dash:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end


if not self.target or self.target:IsNull() or not self.target:IsAlive() then 
    self:Destroy()
    return 
end


local pos = self:GetParent():GetAbsOrigin()

self.point = self.target:GetAbsOrigin() + self.dir*self.range

local dir = (self.point - pos):Normalized()
local pos_p = self:GetParent():GetAbsOrigin() + dir*self.speed*dt

local next_pos = GetGroundPosition(pos_p,self:GetParent())
self:GetParent():SetAbsOrigin(next_pos)

if (self.point - self:GetParent():GetAbsOrigin()):Length2D() < self.speed*dt then
    self:Destroy()
    return
end

end



function modifier_pangolier_lucky_shot_custom_dash:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_DISABLE_TURNING,
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_pangolier_lucky_shot_custom_dash:CheckState()
return
{
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true
}
end

function modifier_pangolier_lucky_shot_custom_dash:GetOverrideAnimation()
return ACT_DOTA_CAST_ABILITY_1
end

function modifier_pangolier_lucky_shot_custom_dash:GetModifierDisableTurning() return 1 end

function modifier_pangolier_lucky_shot_custom_dash:GetEffectName() return "particles/units/heroes/hero_pangolier/pangolier_swashbuckler_dash.vpcf" end

function modifier_pangolier_lucky_shot_custom_dash:OnDestroy()
if not IsServer() then return end


self:GetParent():InterruptMotionControllers( true )

if self.target then 

    self:GetAbility():ProcPassive(self.target, true)

    self:GetParent():SetForwardVector((self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin() ):Normalized())
    self:GetParent():FaceTowards(self.target:GetAbsOrigin())

end


ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1)


end





function modifier_pangolier_lucky_shot_custom_dash:OnHorizontalMotionInterrupted()
    self:Destroy()
end










modifier_pangolier_lucky_shot_custom_silence_cd = class({})
function modifier_pangolier_lucky_shot_custom_silence_cd:IsHidden() return true end
function modifier_pangolier_lucky_shot_custom_silence_cd:IsPurgable() return false end
function modifier_pangolier_lucky_shot_custom_silence_cd:OnCreated(table)
if not IsServer() then return end

self.RemoveForDuel = true
end



pangolier_heartpiercer_custom = class({})




function pangolier_heartpiercer_custom:OnAbilityPhaseStart()
if not IsServer() then return end

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_ATTACK_EVENT, 1.3)
self:GetCaster():EmitSound("Hero_Pangolier.PreAttack")

return true
end

function pangolier_heartpiercer_custom:OnAbilityPhaseInterrupted()

self:GetCaster():FadeGesture(ACT_DOTA_ATTACK_EVENT)
end




function pangolier_heartpiercer_custom:OnSpellStart()
if not IsServer() then return end

local target = self:GetCursorTarget()


self:GetCaster():EmitSound("Hero_Pangolier.PreAttack")

local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf"

local dir = (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin())

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
ParticleManager:SetParticleControl( effect_cast, 1, dir:Normalized()*dir:Length2D() )
ParticleManager:SetParticleControl( effect_cast, 3, dir:Normalized()*dir:Length2D() )
    

Timers:CreateTimer(0.2, function()

    if effect_cast then
        ParticleManager:DestroyParticle(effect_cast, false)
        ParticleManager:ReleaseParticleIndex(effect_cast)
    end
end)


--if target:TriggerSpellAbsorb(self) then return end

local particles = {}

for i = 1,2 do

    particles[i] = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_luckyshot_disarm_cast.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt( particles[i], 0, self:GetCaster(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( particles[i], 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( particles[i], 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particles[i])

end


target:EmitSound("Pango.Lucky_legendary")
target:EmitSound("Pango.Lucky_legendary2")



target:AddNewModifier(self:GetCaster(), self, "modifier_pangolier_lucky_shot_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_7", "duration")})

end



modifier_pangolier_lucky_shot_custom_legendary = class({})

function modifier_pangolier_lucky_shot_custom_legendary:IsHidden() return false end
function modifier_pangolier_lucky_shot_custom_legendary:IsPurgable() return false end
function modifier_pangolier_lucky_shot_custom_legendary:GetEffectName() 
    return "particles/units/heroes/hero_pangolier/pangolier_heartpiercer_delay.vpcf"
end

function modifier_pangolier_lucky_shot_custom_legendary:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end


function modifier_pangolier_lucky_shot_custom_legendary:GetStatusEffectName()
    return "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf"
end


function modifier_pangolier_lucky_shot_custom_legendary:StatusEffectPriority()
    return 999999
end


function modifier_pangolier_lucky_shot_custom_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}

end


function modifier_pangolier_lucky_shot_custom_legendary:OnCreated(table)

self.slow = self:GetAbility():GetSpecialValueFor("slow_pct")
self.proc_duration = self:GetAbility():GetSpecialValueFor("proc_duration")
self.RemoveForDuel = true

self.heal = self:GetAbility():GetSpecialValueFor("heal")/100

if not IsServer() then return end

self.sides = {}
self.sides_units = {}

local parent = self:GetParent()
local caster = self:GetCaster()

local caster_location = parent:GetAbsOrigin()

self.facing_direction = self:GetParent():GetAnglesAsVector().y

self.dist = 150



self:GetParent():EmitSound("Pango.Lucky_legendary_lp")

self.particles = ParticleManager:CreateParticle("particles/items2_fx/sange_maim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particles, false, false, -1, false, false)

local target = self:GetParent()

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

self.particles_sides = {}


self.particles_sides[1] = ParticleManager:CreateParticle( "particles/heroes/pango_v/pangolier_heartpiercer_v_front_models.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )


self.particles_sides[2] = ParticleManager:CreateParticle( "particles/heroes/pango_v/pangolier_heartpiercer_v_right_models.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

self.particles_sides[3] = ParticleManager:CreateParticle( "particles/heroes/pango_v/pangolier_heartpiercer_v_back_models.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

self.particles_sides[4] = ParticleManager:CreateParticle( "particles/heroes/pango_v/pangolier_heartpiercer_v_left_models.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )


self.forward = self:GetParent():GetForwardVector()

end





function modifier_pangolier_lucky_shot_custom_legendary:OnDestroy()
if not IsServer() then 
    return 
end 

for i = 1,4 do 
    if self.particles_sides[i] then 
        ParticleManager:DestroyParticle(self.particles_sides[i], false)
        ParticleManager:ReleaseParticleIndex(self.particles_sides[i])
        self.particles_sides[i] = nil
    end

end

for _,unit in pairs(self.sides_units) do 

    if unit and not unit:IsNull() then 
        UTIL_Remove(unit)
    end
end


self:GetParent():StopSound("Pango.Lucky_legendary_lp")

end



function modifier_pangolier_lucky_shot_custom_legendary:GetModifierMoveSpeedBonus_Percentage()
 return self.slow
end


function modifier_pangolier_lucky_shot_custom_legendary:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetCaster() ~= params.attacker then return end


local reduction = 0
local target = params.target


local attacker_vector = (params.attacker:GetOrigin() - self:GetParent():GetOrigin())

local attacker_direction = VectorToAngles( attacker_vector ).y

local angle_diff = AngleDiff( self.facing_direction, attacker_direction ) 


local side = 0

if (angle_diff < 45 and angle_diff > -45) then 
    side = 1


end 

if (angle_diff >= 45 and angle_diff <= 135) then 
    side = 2

end  

if (angle_diff > 135 or (angle_diff >= -180 and angle_diff < -135)) then 
    side = 3  

end  

if (angle_diff >= -135 and angle_diff <= -45) then 

    side = 4

end


if side ~= 0 then 

    if not self.sides[side] then 
        self.sides[side] = true

        if self.particles_sides[side] then 

            local end_part = "particles/heroes/pango_v/pangolier_heartpiercer_v_front_end.vpcf"

            if side == 2 then 
                end_part = "particles/heroes/pango_v/pangolier_heartpiercer_v_right_end.vpcf"
            end

            if side == 3 then 
                end_part = "particles/heroes/pango_v/pangolier_heartpiercer_v_back_end.vpcf"
            end
            if side == 4 then 
                end_part = "particles/heroes/pango_v/pangolier_heartpiercer_v_left_end.vpcf"
            end

            local hit_effect = ParticleManager:CreateParticle(end_part, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
            ParticleManager:SetParticleControlForward(hit_effect, 1, self.forward)
            ParticleManager:ReleaseParticleIndex(hit_effect)


            ParticleManager:DestroyParticle(self.particles_sides[side], false)
            ParticleManager:ReleaseParticleIndex(self.particles_sides[side])
            self.particles_sides[side] = nil
        end

        local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, target)
        ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
        ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
        ParticleManager:ReleaseParticleIndex(hit_effect)

        if self.sides_units[side] and not self.sides_units[side]:IsNull() then 
            UTIL_Remove(self.sides_units[side])
        end

        self:GetCaster():GenericHeal(self:GetCaster():GetMaxHealth()*self.heal, self:GetAbility())

        self:GetParent():EmitSound("Antimage.Break_legendary_hit")
    end


    local count = 0

    for i = 1,4 do
        if self.sides[i] then 
            count = count + 1
        end
    end

    if count >= 4 then


        local effect_cast = ParticleManager:CreateParticle( "particles/econ/items/troll_warlord/troll_warlord_ti7_axe/troll_ti7_axe_bash_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControl( effect_cast, 0,  self:GetParent():GetOrigin() )
        ParticleManager:SetParticleControl( effect_cast, 1, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex(effect_cast)

        local coup_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt( coup_pfx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( coup_pfx, 1, self:GetParent():GetOrigin() )
        ParticleManager:SetParticleControlForward( coup_pfx, 1, -1*self:GetCaster():GetForwardVector() )
        ParticleManager:ReleaseParticleIndex( coup_pfx )

        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_lucky_shot_custom_legendary_proc", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_7", "effect_duration")}) 
        self:Destroy()
    end
end




end




modifier_pangolier_lucky_shot_custom_legendary_proc = class({})
function modifier_pangolier_lucky_shot_custom_legendary_proc:IsHidden() return true end
function modifier_pangolier_lucky_shot_custom_legendary_proc:IsPurgable() return false end


function modifier_pangolier_lucky_shot_custom_legendary_proc:GetEffectName() 
    return "particles/items2_fx/sange_maim.vpcf"
end

function modifier_pangolier_lucky_shot_custom_legendary_proc:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_pangolier_lucky_shot_custom_legendary_proc:GetStatusEffectName()
    return "particles/status_fx/status_effect_life_stealer_open_wounds.vpcf"
end


function modifier_pangolier_lucky_shot_custom_legendary_proc:StatusEffectPriority()
    return 999999
end

function modifier_pangolier_lucky_shot_custom_legendary_proc:OnCreated(table)
if not IsServer() then return end

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_pangolier_lucky_7", "stun")})

self.target = self:GetParent()



self:GetParent():EmitSound("Pango.Lucky_legendary_proc")
self:GetParent():EmitSound("Pango.Lucky_dash2")
self:GetParent():EmitSound("Hero_Pangolier.LuckyShot.Proc")

self:OnIntervalThink()
self:StartIntervalThink(FrameTime())
end

function modifier_pangolier_lucky_shot_custom_legendary_proc:OnIntervalThink()
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_pangolier_heartpiercer_debuff") then return end


self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_heartpiercer_debuff", {duration = self:GetRemainingTime()})
end


function modifier_pangolier_lucky_shot_custom_legendary_proc:DeclareFunctions()
return
{

    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end



function modifier_pangolier_lucky_shot_custom_legendary_proc:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetCaster() ~= params.attacker then return end

local target = self:GetParent()

local hit_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_hit.vpcf", PATTACH_CUSTOMORIGIN, target)
ParticleManager:SetParticleControlEnt(hit_effect, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:SetParticleControlEnt(hit_effect, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), false) 
ParticleManager:ReleaseParticleIndex(hit_effect)

self:GetParent():EmitSound("Pango.Lucky_legendary_proc_attack")
end





modifier_pangolier_lucky_shot_custom_blood = class({})
function modifier_pangolier_lucky_shot_custom_blood:IsHidden() return false end
function modifier_pangolier_lucky_shot_custom_blood:IsPurgable() return false end
function modifier_pangolier_lucky_shot_custom_blood:GetTexture() return "buffs/lucky_blood" end


function modifier_pangolier_lucky_shot_custom_blood:GetEffectName() 
    return "particles/items2_fx/sange_maim.vpcf"
end

function modifier_pangolier_lucky_shot_custom_blood:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_pangolier_lucky_shot_custom_blood:OnCreated(table)
if not IsServer() then return end
self.blood_damage = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_4", "damage")/100

self.interval = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_4", "interval")
self.heal = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_4", "heal")/100
self.heal_creeps = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_4", "heal_creeps")

self:StartIntervalThink(self.interval)
end


function modifier_pangolier_lucky_shot_custom_blood:OnIntervalThink()
if not IsServer() then return end

self.damage = self:GetCaster():GetAverageTrueAttackDamage(nil)*self.blood_damage*self.interval


local damage_table = ({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK })
local damage = ApplyDamage(damage_table)

local heal = self.heal

if self:GetParent():IsCreep() then 
    heal = self.heal_creeps*heal
end

self:GetCaster():GenericHeal(damage*heal, self:GetAbility(), true )

end


function modifier_pangolier_lucky_shot_custom_blood:DeclareFunctions()
return
{

    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end



function modifier_pangolier_lucky_shot_custom_blood:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetCaster() ~= params.attacker then return end

self:SetDuration(self:GetCaster():GetTalentValue("modifier_pangolier_lucky_4", "duration"), true)
end





modifier_pangolier_lucky_shot_custom_legendary_unit = class({})

function modifier_pangolier_lucky_shot_custom_legendary_unit:IsHidden() return true end
function modifier_pangolier_lucky_shot_custom_legendary_unit:IsPurgable() return false end
function modifier_pangolier_lucky_shot_custom_legendary_unit:CheckState()
return
{
    [MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_STUNNED] = true,
}
end


function modifier_pangolier_lucky_shot_custom_legendary_unit:OnDestroy()
if not IsServer() then return end

if self:GetParent() and not self:GetParent() then 
    UTIL_Remove(self:GetParent())
end

end

modifier_pangolier_lucky_shot_custom_disarm_effect = class({})
function modifier_pangolier_lucky_shot_custom_disarm_effect:IsHidden() return true end
function modifier_pangolier_lucky_shot_custom_disarm_effect:IsPurgable() return true end
function modifier_pangolier_lucky_shot_custom_disarm_effect:CheckState()
return
{
    [MODIFIER_STATE_DISARMED] = true
}
end


modifier_pangolier_lucky_shot_custom_speed = class({})
function modifier_pangolier_lucky_shot_custom_speed:IsHidden() return false end
function modifier_pangolier_lucky_shot_custom_speed:IsPurgable() return false end
function modifier_pangolier_lucky_shot_custom_speed:GetTexture() return "buffs/lucky_blood" end
function modifier_pangolier_lucky_shot_custom_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_4", "speed")
self.status = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_4", "status")
self.max = self:GetCaster():GetTalentValue("modifier_pangolier_lucky_4", "max")

if not IsServer() then return end 

self:SetStackCount(1)
end 

function modifier_pangolier_lucky_shot_custom_speed:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
    self:GetParent():EmitSound("Pango.Lucky_stack")
    self.particle = ParticleManager:CreateParticle("particles/ogre_dd.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:AddParticle(self.particle, false, false, -1, false, false)

end 

end 





function modifier_pangolier_lucky_shot_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
}
end


function modifier_pangolier_lucky_shot_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed*self:GetStackCount()
end


function modifier_pangolier_lucky_shot_custom_speed:GetModifierStatusResistanceStacking() 
if self:GetStackCount() < self.max then return end
return self.status
end