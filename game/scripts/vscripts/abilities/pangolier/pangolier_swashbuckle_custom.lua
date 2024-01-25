LinkLuaModifier("modifier_pangolier_swashbuckle_custom_dash", "abilities/pangolier/pangolier_swashbuckle_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_pangolier_swashbuckle_custom_attacks", "abilities/pangolier/pangolier_swashbuckle_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_swashbuckle_custom_tracker", "abilities/pangolier/pangolier_swashbuckle_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_swashbuckle_custom_stun", "abilities/pangolier/pangolier_swashbuckle_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_swashbuckle_custom_range", "abilities/pangolier/pangolier_swashbuckle_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_swashbuckle_custom_range_slow", "abilities/pangolier/pangolier_swashbuckle_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_swashbuckle_custom_parry", "abilities/pangolier/pangolier_swashbuckle_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_swashbuckle_custom_blood", "abilities/pangolier/pangolier_swashbuckle_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_swashbuckle_custom_legendary_combat", "abilities/pangolier/pangolier_swashbuckle_custom", LUA_MODIFIER_MOTION_NONE)




pangolier_swashbuckle_custom = class({})





function pangolier_swashbuckle_custom:Precache(context)

PrecacheResource( "particle", 'particles/pangolier/buckle_stacks.vpcf', context )
PrecacheResource( "particle", 'particles/pangolier/buckle_refresh.vpcf', context )

end




function pangolier_swashbuckle_custom:GetCooldown(iLevel)

local upgrade_cooldown = 0

local k = 1


if self:GetCaster():HasModifier("modifier_pangolier_buckle_1") then  
  upgrade_cooldown = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_1", "cd")
end 

 return (self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown)*k

end



function pangolier_swashbuckle_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_pangolier_buckle_2") then 
  upgrade = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_2", "range")
end
return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end



function pangolier_swashbuckle_custom:DealDamage(target, stun, scepter)
if not IsServer() then return end

self.passive = self:GetCaster():FindAbilityByName("pangolier_lucky_shot_custom")

if self.passive and self.passive:GetLevel() > 0 then 
    self.passive:ProcPassive(target, false)
end

if (not scepter) and target:IsAlive() and self:GetCaster():HasModifier("modifier_pangolier_buckle_4") and not target:HasModifier("modifier_pangolier_swashbuckle_custom_blood") then 
    target:AddNewModifier(self:GetCaster(), self, "modifier_pangolier_swashbuckle_custom_blood", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_4", "duration")})

end

if stun and stun == true then 

    target:EmitSound("Pango.Lucky_dash2")

    local trail_pfx2 = ParticleManager:CreateParticle("particles/jugg_legendary_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
    ParticleManager:DestroyParticle(trail_pfx2, false)
    ParticleManager:ReleaseParticleIndex(trail_pfx2)


    target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = (1 - target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_pangolier_buckle_7", "stun")})
end 


self:GetCaster():PerformAttack( target, true, true, true, false, false, false, true )
target:EmitSound("Hero_Pangolier.Swashbuckle.Damage")



end





function pangolier_swashbuckle_custom:GetIntrinsicModifierName()
return "modifier_pangolier_swashbuckle_custom_tracker"
end

function pangolier_swashbuckle_custom:OnVectorCastStart(vStartLocation, vDirection)

local caster = self:GetCaster()

self:GetCaster():RemoveModifierByName("modifier_pangolier_rollup_custom")
self:GetCaster():RemoveModifierByName("modifier_pangolier_gyroshell_custom")

local stacks = 0
local mod = self:GetCaster():FindModifierByName("modifier_pangolier_swashbuckle_custom_tracker")

if mod then 
    stacks = mod:GetStackCount()
    mod:SetStackCount(0)
end

if stacks == self:GetCaster():GetTalentValue("modifier_pangolier_buckle_7", "max") then 


end

caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

local point = vStartLocation
local vector_point = point + vDirection*self:GetSpecialValueFor("range")

local speed = self:GetSpecialValueFor( "dash_speed" )
local direction = vDirection

local vector = (point-caster:GetOrigin())
local dist = vector:Length2D()
vector.z = 0
vector = vector:Normalized()

caster:SetForwardVector( direction )


self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_pangolier_swashbuckle_custom_dash", 
{
    x = point.x, 
    y = point.y, 
    z = point.z, 
    dist = dist,
    attacks_x = direction.x,
    attacks_y = direction.y,
    duration = dist/speed,
    stacks = stacks,
})



end




modifier_pangolier_swashbuckle_custom_dash = class({})

function modifier_pangolier_swashbuckle_custom_dash:IsDebuff() return false end
function modifier_pangolier_swashbuckle_custom_dash:IsHidden() return true end
function modifier_pangolier_swashbuckle_custom_dash:IsPurgable() return false end

function modifier_pangolier_swashbuckle_custom_dash:OnCreated(kv)
if not IsServer() then return end

self:GetParent():EmitSound("Hero_Pangolier.Swashbuckle.Cast")
self:GetParent():EmitSound("Hero_Pangolier.Swashbuckle.Layer")



if self:GetCaster():HasModifier("modifier_pangolier_buckle_6") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_swashbuckle_custom_parry", {})
end


self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pangolier_swashbuckle_custom_stun", {duration = self:GetRemainingTime() + 0.1})

self.point = Vector(kv.x, kv.y, kv.z)

self.angle = (self.point - self:GetParent():GetAbsOrigin()):Normalized()

self.distance = kv.dist / ( self:GetDuration() / FrameTime())

self.direction = Vector(kv.attacks_x, kv.attacks_y, 0):Normalized()

self.stacks = kv.stacks

self.targets = {}

if self:ApplyHorizontalMotionController() == false then
    self:Destroy()
end

end

function modifier_pangolier_swashbuckle_custom_dash:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_DISABLE_TURNING,
    MODIFIER_PROPERTY_OVERRIDE_ANIMATION
}
end

function modifier_pangolier_swashbuckle_custom_dash:CheckState()
return
{
    [MODIFIER_STATE_STUNNED] = true
}
end

function modifier_pangolier_swashbuckle_custom_dash:GetOverrideAnimation()
return ACT_DOTA_CAST_ABILITY_1
end

function modifier_pangolier_swashbuckle_custom_dash:GetModifierDisableTurning() return 1 end

function modifier_pangolier_swashbuckle_custom_dash:GetEffectName() return "particles/units/heroes/hero_pangolier/pangolier_swashbuckler_dash.vpcf" end

function modifier_pangolier_swashbuckle_custom_dash:OnDestroy()
if not IsServer() then return end


self:GetParent():InterruptMotionControllers( true )

local dir = self:GetParent():GetForwardVector()
dir.z = 0
self:GetParent():SetForwardVector(dir)
self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1)

if self:GetRemainingTime() < 0.1 then 

    self:GetParent():AddNewModifier(
    self:GetParent(), -- player source
    self:GetAbility(), -- ability source
    "modifier_pangolier_swashbuckle_custom_attacks", -- modifier name
    {
        dir_x = self.direction.x,
        dir_y = self.direction.y,
        duration = 3, -- max duration
        stacks = self.stacks,
    } )

else 
    self:GetParent():RemoveModifierByName("modifier_pangolier_swashbuckle_custom_stun")

    self:GetCaster():RemoveModifierByName("modifier_pangolier_swashbuckle_custom_parry")


end

end


function modifier_pangolier_swashbuckle_custom_dash:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end

local pos = self:GetParent():GetAbsOrigin()

local pos_p = self.angle * self.distance
local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
self:GetParent():SetAbsOrigin(next_pos)

end



function modifier_pangolier_swashbuckle_custom_dash:OnHorizontalMotionInterrupted()
    self:Destroy()
end











modifier_pangolier_swashbuckle_custom_attacks = class({})



function modifier_pangolier_swashbuckle_custom_attacks:IsHidden()
    return true
end

function modifier_pangolier_swashbuckle_custom_attacks:IsPurgable()
    return false
end

function modifier_pangolier_swashbuckle_custom_attacks:OnCreated( kv )


self.range = self:GetAbility():GetSpecialValueFor( "range" )
self.speed = self:GetAbility():GetSpecialValueFor( "dash_speed" )
self.radius = self:GetAbility():GetSpecialValueFor( "start_radius" )

self.interval = self:GetAbility():GetSpecialValueFor( "attack_interval" )
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
self.strikes = self:GetAbility():GetSpecialValueFor( "strikes" )

self.stun = false

if kv.stacks then 
    self.strikes = self.strikes + kv.stacks

    if self:GetCaster():HasModifier("modifier_pangolier_buckle_7") and kv.stacks >= self:GetCaster():GetTalentValue("modifier_pangolier_buckle_7", "max") then 
        self.stun = true
    end 
end

if not IsServer() then return end




if self:GetCaster():HasModifier("modifier_pangolier_buckle_3") then 
    self.damage = self.damage + self:GetCaster():GetTalentValue("modifier_pangolier_buckle_3", "damage")*self:GetParent():GetAverageTrueAttackDamage(nil)/100
end

self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1_END)

self.origin = self:GetParent():GetOrigin()
self.direction = Vector( kv.dir_x, kv.dir_y, 0 )
self.target = self.origin + self.direction*self.range

self.count = 0

self:StartIntervalThink( self.interval )
self:OnIntervalThink()
end

function modifier_pangolier_swashbuckle_custom_attacks:OnRefresh( kv )
end

function modifier_pangolier_swashbuckle_custom_attacks:GetEffectName() return "particles/units/heroes/hero_pangolier/pangolier_swashbuckler_dash.vpcf" end



function modifier_pangolier_swashbuckle_custom_attacks:OnDestroy()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_pangolier_buckle_2") then 
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_movespeed",
{
  duration = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_2", "duration"),
  effect = "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf",
  movespeed = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_2", "speed")
})
end

if self:GetCaster():HasModifier("modifier_pangolier_buckle_5") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_swashbuckle_custom_range", {duration = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_5", "buff_duration")})
end


if self:GetCaster():HasModifier("modifier_pangolier_swashbuckle_custom_parry") then 
    self:GetCaster():FindModifierByName("modifier_pangolier_swashbuckle_custom_parry"):SetDuration(self:GetCaster():GetTalentValue("modifier_pangolier_buckle_6", "duration"), true)
end

end


function modifier_pangolier_swashbuckle_custom_attacks:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,
      --  MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }

    return funcs
end

function modifier_pangolier_swashbuckle_custom_attacks:GetModifierOverrideAttackDamage()
    return self.damage
end


function modifier_pangolier_swashbuckle_custom_attacks:GetOverrideAnimation()
return 
end



function modifier_pangolier_swashbuckle_custom_attacks:CheckState()
    local state = {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_DISARMED] = true,
    }

    return state
end



function modifier_pangolier_swashbuckle_custom_attacks:OnIntervalThink()
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

if self.count%6 == 0 then 
    self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1_END)
    self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1_END)
end


local enemies = FindUnitsInLine(self:GetParent():GetTeamNumber(), self.origin, self.target, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  0 )

self:GetParent():EmitSound("Hero_Pangolier.Swashbuckle")

for _,enemy in pairs(enemies) do
    self:GetAbility():DealDamage(enemy, self.stun)
end

self:PlayEffects()

if self.count == 1 then 
    self.stun = false
end 


end

function modifier_pangolier_swashbuckle_custom_attacks:PlayEffects()
 
local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf"
local sound_cast = "Hero_Pangolier.Swashbuckle.Attack"


local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
ParticleManager:SetParticleControl( effect_cast, 1, self.direction*self:GetAbility():GetSpecialValueFor("range") )
ParticleManager:SetParticleControl( effect_cast, 3, self.direction*self:GetAbility():GetSpecialValueFor("range") )
    

self:AddParticle( effect_cast, false,  false, -1,  false, false )

Timers:CreateTimer(0.2, function()

    if effect_cast then
        ParticleManager:DestroyParticle(effect_cast, false)
        ParticleManager:ReleaseParticleIndex(effect_cast)
    end
end)


self:GetParent():EmitSound(sound_cast)
end



modifier_pangolier_swashbuckle_custom_tracker = class({})
function modifier_pangolier_swashbuckle_custom_tracker:IsHidden() return true end
function modifier_pangolier_swashbuckle_custom_tracker:IsPurgable() return false end


function modifier_pangolier_swashbuckle_custom_tracker:OnCreated(table)
if not IsServer() then return end


self.pos = self:GetParent():GetAbsOrigin()

self.distance = 0
self.stack = 0
self.reset_timer = 0
self.total = 0
self.combat = 0

self.old_pos = self:GetParent():GetAbsOrigin()

self:StartIntervalThink(1)
end


function modifier_pangolier_swashbuckle_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_pangolier_swashbuckle_custom_tracker:SetValues()
if not IsServer() then return end 
if self.max then return end 

self.max = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_7", "max")
self.max_distance = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_7", "distance")
self.timer = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_7", "timer")
self.timer_interval = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_7", "timer_interval")

end 


function modifier_pangolier_swashbuckle_custom_tracker:OnTakeDamage(params)
if not IsServer() then return end 
if not self:GetParent():HasModifier("modifier_pangolier_buckle_7") then return end
if self:GetParent() ~= params.attacker and self:GetCaster() ~= params.unit then return end 
if (params.attacker:GetAbsOrigin() - params.unit:GetAbsOrigin()):Length2D() > 1000 then return end
if params.attacker:IsBuilding() or params.unit:IsBuilding() then return end 
if not params.unit:IsHero() and not params.unit:IsCreep() then return end
if params.attacker == self:GetParent() and params.inflictor and params.inflictor:IsItem() and params.unit:IsCreep() then return end

self:SetValues()

self.combat = 1 
self.reset_timer = 0

self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_pangolier_swashbuckle_custom_legendary_combat", {duration = self.timer})
end


function modifier_pangolier_swashbuckle_custom_tracker:OnIntervalThink()
if not IsServer() then return end

local pass = (self:GetParent():GetAbsOrigin() - self.pos):Length2D()

self.pos = self:GetParent():GetAbsOrigin()


if not self:GetParent():HasModifier("modifier_pangolier_buckle_7") then return end

self:SetValues()

if not self.particle then 

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pangolier_stack_change',  {current = self:GetStackCount(), max_dist = self.max*self.max_distance, current_dist = self.distance, max_stack = self.max, stack_dist = self.max_distance})
   
    self.particle = ParticleManager:CreateParticle("particles/pangolier/buckle_stacks.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
    self:AddParticle(self.particle, false, false, -1, false, false)

    self:OnStackCountChanged()

end


if self.combat == 1 then 

    self.reset_timer = self.reset_timer + 0.1
    if self.reset_timer >= self.timer then 
        self.reset_timer = 0
        self.combat = 0
        self:DecrementStackCount()

    end

end


if self.combat == 0 then 

    self.reset_timer = self.reset_timer + 0.1
    if self.reset_timer >= self.timer_interval then 
        self.reset_timer = 0
        if self:GetStackCount() > 0 then 
            self:DecrementStackCount()
        end 
    end

    return
end  


if pass > 1500 then return end
if self:GetParent():HasModifier("modifier_pangolier_swashbuckle_custom_dash") then return end
if self:GetParent():HasModifier("modifier_pangolier_swashbuckle_custom_attacks") then return end


while pass > 0 do 
    self.distance = self.distance + pass

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pangolier_stack_change',  {current = self:GetStackCount(), max_dist = self.max*self.max_distance, current_dist = self.distance, max_stack = self.max, stack_dist = self.max_distance})
   

    if self.distance < self.max_distance then 
        pass = 0
    else 
        pass =  self.distance - self.max_distance
        self.distance = 0

        if self:GetStackCount() < self.max then 
            self:IncrementStackCount()
        end
    end
end


self:StartIntervalThink(0.1)
end


function modifier_pangolier_swashbuckle_custom_tracker:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if not self.particle then return end

self:SetValues()

if self:GetStackCount() == 0 then 
    self.distance = 0
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'pangolier_stack_change',  {current = self:GetStackCount(), max_dist = self.max*self.max_distance, current_dist = self.distance, max_stack = self.max, stack_dist = self.max_distance})
   

for i = 1, self.max do 

    if i <= self:GetStackCount() then 
        ParticleManager:SetParticleControl(self.particle, i, Vector(1, 0, 0))   
    else 
        ParticleManager:SetParticleControl(self.particle, i, Vector(0, 0, 0))   
    end
end

end










modifier_pangolier_swashbuckle_custom_stun = class({})
function modifier_pangolier_swashbuckle_custom_stun:IsHidden() return true end
function modifier_pangolier_swashbuckle_custom_stun:IsPurgable() return false end
function modifier_pangolier_swashbuckle_custom_stun:CheckState()
return
{
    [MODIFIER_STATE_STUNNED] = true
}
end



modifier_pangolier_swashbuckle_custom_range = class({})
function modifier_pangolier_swashbuckle_custom_range:IsHidden() return false end
function modifier_pangolier_swashbuckle_custom_range:IsPurgable() return false end
function modifier_pangolier_swashbuckle_custom_range:GetTexture() return "buffs/buckle_attacks" end
function modifier_pangolier_swashbuckle_custom_range:OnCreated(table)

self.range = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_5", "range")
self.heal = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_5", "heal")/100
self.duration = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_5", "duration")

if not IsServer() then return end
self.record = nil
self:SetStackCount(self:GetCaster():GetTalentValue("modifier_pangolier_buckle_5", "attacks"))
end

function modifier_pangolier_swashbuckle_custom_range:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end


function modifier_pangolier_swashbuckle_custom_range:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end


function modifier_pangolier_swashbuckle_custom_range:CheckState()
return
{
    [MODIFIER_STATE_CANNOT_MISS] = true
}

end



function modifier_pangolier_swashbuckle_custom_range:GetModifierAttackRangeBonus()
return self.range
end


function modifier_pangolier_swashbuckle_custom_range:OnAttack(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.no_attack_cooldown then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end


self.record = params.record


local dir = (params.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
local range = 800

local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf"
local sound_cast = "Hero_Pangolier.Swashbuckle.Attack"


local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
ParticleManager:SetParticleControl( effect_cast, 1, dir*range )
ParticleManager:SetParticleControl( effect_cast, 3, dir*range )

Timers:CreateTimer(0.2, function()
    if effect_cast then 
        ParticleManager:DestroyParticle(effect_cast, false)
        ParticleManager:ReleaseParticleIndex(effect_cast)
    end
end)


self:GetParent():EmitSound("Hero_Pangolier.Swashbuckle")
self:GetParent():EmitSound(sound_cast)


end


function modifier_pangolier_swashbuckle_custom_range:OnTakeDamage(params)
if not IsServer() then return end
if params.attacker ~= self:GetParent() then return end
if not params.record then return end
if params.inflictor then return end
if self.record == nil or self.record ~= params.record then return end

local target = params.unit

local heal = params.damage*self.heal
self:GetParent():GenericHeal(heal, self:GetAbility())

target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pangolier_swashbuckle_custom_range_slow", {duration = (1 - target:GetStatusResistance())*self.duration})


self:DecrementStackCount()

if self:GetStackCount() == 0 then 
    self:Destroy()
end

target:EmitSound("Hero_Pangolier.Swashbuckle.Damage")


end





modifier_pangolier_swashbuckle_custom_range_slow = class({})

function modifier_pangolier_swashbuckle_custom_range_slow:IsPurgable() return true end
function modifier_pangolier_swashbuckle_custom_range_slow:IsHidden() return true end



function modifier_pangolier_swashbuckle_custom_range_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_5", "slow")
end 

function modifier_pangolier_swashbuckle_custom_range_slow:DeclareFunctions()
local funcs = 
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
return funcs
end

function modifier_pangolier_swashbuckle_custom_range_slow:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end



function modifier_pangolier_swashbuckle_custom_range_slow:GetEffectName()
    return "particles/units/heroes/hero_sniper/sniper_headshot_slow.vpcf"
end


function modifier_pangolier_swashbuckle_custom_range_slow:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end



function modifier_pangolier_swashbuckle_custom_range_slow:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_pangolier_swashbuckle_custom_range_slow:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end



modifier_pangolier_swashbuckle_custom_parry = class({})
function modifier_pangolier_swashbuckle_custom_parry:IsHidden() return true end
function modifier_pangolier_swashbuckle_custom_parry:IsPurgable() return false end
function modifier_pangolier_swashbuckle_custom_parry:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_6", "damage_reduce")

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/pangolier/linken_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)


end



function modifier_pangolier_swashbuckle_custom_parry:DeclareFunctions()
return
{
MODIFIER_PROPERTY_ABSORB_SPELL,
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_pangolier_swashbuckle_custom_parry:GetAbsorbSpell(params) 
if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then return end

local particle = ParticleManager:CreateParticle("particles/pangolier/linken_proc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("DOTA_Item.LinkensSphere.Activate")

return 1 
end



function modifier_pangolier_swashbuckle_custom_parry:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end

if params.inflictor then return end

self:GetParent():EmitSound("Juggernaut.Parry")
local particle = ParticleManager:CreateParticle( "particles/jugg_parry.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), true )
ParticleManager:SetParticleControl( particle, 1, self:GetParent():GetAbsOrigin() )

return self.damage
end



modifier_pangolier_swashbuckle_custom_blood = class({})

function modifier_pangolier_swashbuckle_custom_blood:IsHidden() return false end
function modifier_pangolier_swashbuckle_custom_blood:IsPurgable() return false end
function modifier_pangolier_swashbuckle_custom_blood:OnCreated(table)

self.stack_damage = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_4", "damage")/100
--self.damage_creeps = self:GetCaster():GetTalentValue("modifier_pangolier_buckle_4", "damage_creeps")

if not IsServer() then return end

self:SetStackCount(0)
end


function modifier_pangolier_swashbuckle_custom_blood:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end

self.damage = self.stack_damage*self:GetStackCount()*self:GetCaster():GetAverageTrueAttackDamage(nil)

if self:GetParent():IsCreep() then 
   -- self.damage = self.damage*self.damage_creeps
end

local damage_table = ({ victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = self.damage, damage_type = DAMAGE_TYPE_PURE })
local damage = ApplyDamage(damage_table)

SendOverheadEventMessage(self:GetParent(), 6, self:GetParent(), damage, nil)


local parent = self:GetParent()

local trail_pfx2 = ParticleManager:CreateParticle("particles/jugg_legendary_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:DestroyParticle(trail_pfx2, false)
ParticleManager:ReleaseParticleIndex(trail_pfx2)

local trail_pfx = ParticleManager:CreateParticle("particles/items3_fx/iron_talon_active.vpcf", PATTACH_ABSORIGIN, self:GetParent())

ParticleManager:SetParticleControlEnt(trail_pfx, 0, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt( trail_pfx, 1, parent, PATTACH_ABSORIGIN_FOLLOW, nil, parent:GetAbsOrigin(), true)
ParticleManager:ReleaseParticleIndex(trail_pfx)
self:GetParent():EmitSound("Pango.Lucky_dash2")
self:GetParent():EmitSound("DOTA_Item.Daedelus.Crit")

end


function modifier_pangolier_swashbuckle_custom_blood:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED
}

end
function modifier_pangolier_swashbuckle_custom_blood:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end
if self:GetCaster() ~= params.attacker then return end


self:IncrementStackCount()
end


modifier_pangolier_swashbuckle_custom_legendary_combat = class({})
function modifier_pangolier_swashbuckle_custom_legendary_combat:IsHidden() return false end
function modifier_pangolier_swashbuckle_custom_legendary_combat:IsPurgable() return false end
function modifier_pangolier_swashbuckle_custom_legendary_combat:RemoveOnDeath() return false end