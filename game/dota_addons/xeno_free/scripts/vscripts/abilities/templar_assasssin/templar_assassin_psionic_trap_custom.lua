LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_counter", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_debuff", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_vision", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_illusion", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_legendary", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_incoming", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_heal", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_stun", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_stun_cd", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_templar_assassin_psionic_trap_custom_trap_move", "abilities/templar_assasssin/templar_assassin_psionic_trap_custom", LUA_MODIFIER_MOTION_NONE )



-- Способность поставить ловушку

templar_assassin_psionic_trap_custom = class({})

templar_assassin_psionic_trap_custom.blast_damage = {50, 100, 150}

templar_assassin_psionic_trap_custom.charge_timer = 1

templar_assassin_psionic_trap_custom.vision_duration = 40

templar_assassin_psionic_trap_custom.illusion_damage = {0.02, 0.03}
templar_assassin_psionic_trap_custom.illusion_duration = 4
templar_assassin_psionic_trap_custom.illusion_max = 1
templar_assassin_psionic_trap_custom.illusion_creeps = 0.25


templar_assassin_psionic_trap_custom.heal = {0.1, 0.15, 0.2}






function templar_assassin_psionic_trap_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_trap.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_trap_slow.vpcf', context )
PrecacheResource( "particle", 'particles/pa_vendetta.vpcf', context )
PrecacheResource( "particle", 'particles/status_fx/status_effect_dark_seer_normal_punch_replica.vpcf', context )
PrecacheResource( "particle", 'particles/ta_trap_target.vpcf', context )
PrecacheResource( "particle", 'particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf', context )
PrecacheResource( "particle", 'particles/ta_timer.vpcf', context )
PrecacheResource( "particle", 'particles/ta_trap_damage.vpcf', context )

end


function templar_assassin_psionic_trap_custom:Teleport(point)
if not self:GetCaster():IsAlive() then return end

local start_point = self:GetCaster():GetAbsOrigin()

ProjectileManager:ProjectileDodge(self:GetCaster())

EmitSoundOnLocationWithCaster( start_point, "Hero_Antimage.Blink_out", self:GetCaster() )

local effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_start.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, start_point)

effect = ParticleManager:CreateParticle("particles/items3_fx/blink_arcane_end.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(effect, 0, point)

self:GetCaster():SetAbsOrigin(point)
FindClearSpaceForUnit(self:GetCaster(), point, true)


end





function templar_assassin_psionic_trap_custom:GetMaxTime()

local max_timer = self:GetSpecialValueFor("trap_max_charge_duration")

if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_1") then 
    max_timer = max_timer + self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_1", "charge")
end

return max_timer
end


function templar_assassin_psionic_trap_custom:GetIntrinsicModifierName()
    return "modifier_templar_assassin_psionic_trap_custom_counter"
end



function templar_assassin_psionic_trap_custom:ExplodeTrap(point, timer_k)
if not IsServer() then return end

local k = math.min(timer_k, 1)

local min_silence = self:GetSpecialValueFor("shard_min_silence")
local max_silence = self:GetSpecialValueFor("shard_max_silence")

local max_timer = self:GetMaxTime()


if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_4") and (self:GetCaster():GetAbsOrigin() - point):Length2D() < 2000 then 

    local count = 0

    for _,illusion in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)) do
        if illusion:IsIllusion() and illusion.templar_illusion == true then 
            count = count + 1
        end
    end

    if count < self.illusion_max then

        local illusion = CreateIllusions( self:GetCaster(), self:GetCaster(), {duration=self.illusion_duration, outgoing_damage= -100,incoming_damage=0}, 1, 0, false, false )  
        for k, v in pairs(illusion) do

            for _,mod in pairs(self:GetCaster():FindAllModifiers()) do
                 if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
                    v:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
                end
            end

            v.templar_illusion = true
            v.owner = self:GetCaster()
            FindClearSpaceForUnit(v, point, true)

            v:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_illusion", {})
            Timers:CreateTimer(0.1, function()
                v:MoveToPositionAggressive(v:GetAbsOrigin())
            end)
        end
    end
end


local explode_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap_explode.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(explode_particle, 0, point)
ParticleManager:ReleaseParticleIndex(explode_particle)

EmitSoundOnLocationWithCaster(point, "Hero_TemplarAssassin.Trap.Explode", self:GetCaster())

local radius = self:GetSpecialValueFor("trap_radius")
local duration = self:GetSpecialValueFor("trap_duration_tooltip")

local silence_duration = min_silence + (max_silence - min_silence) * k

local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY , DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

for _, enemy in pairs(targets) do
     

    if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_2") then 
        enemy:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_incoming", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_2", "duration")})
    end

    if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_3") then 
        enemy:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_3", "duration")})
    end 


    enemy:RemoveModifierByName("modifier_templar_assassin_psionic_trap_custom_trap_debuff")
    enemy:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_debuff", {duration = duration *(1 - enemy:GetStatusResistance()), k = k})
    
    if self:GetCaster():HasShard() then
        enemy:AddNewModifier(self:GetCaster(), self, "modifier_generic_silence", {duration = silence_duration*(1 - enemy:GetStatusResistance())})
    end



    if k >= 0.99 then 
        if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_6") and enemy:IsHero() then 
            enemy:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_vision", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_6", "duration")})
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_move", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_6", "duration")})
        
        end 

        if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_5") and not enemy:HasModifier("modifier_templar_assassin_psionic_trap_custom_trap_stun_cd") then 
           
            enemy:EmitSound("Arc.Field_shard")
            enemy:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_stun_cd", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_5", "cd")})
            enemy:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_stun", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_5", "stun")*(1 - enemy:GetStatusResistance())})
        end 
    end 



end


if #targets > 0 and self:GetCaster():HasModifier("modifier_templar_assassin_psionic_3") then    
   self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_heal", {duration = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_3", "duration")})
end

end



function templar_assassin_psionic_trap_custom:OnAbilityPhaseStart()
if not self:GetCaster():HasModifier("modifier_templar_assassin_psionic_7") then return true end
if not self:GetCursorTarget() then return true end

if self:GetCursorTarget():HasModifier("modifier_templar_assassin_psionic_trap_custom_trap_legendary") then  
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#has_trap"})
    return false
end

return true
end


function templar_assassin_psionic_trap_custom:GetBehavior()
    if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_7") then
        return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_AUTOCAST
    end
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end


function templar_assassin_psionic_trap_custom:GetCastPoint()
if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_6") then 
    return self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_6", "cast")
else 
    return self.BaseClass.GetCastPoint(self)
end

end



function templar_assassin_psionic_trap_custom:OnSpellStart()
if not IsServer() then return end

self:SetTrap(self:GetCursorPosition(), self:GetCursorTarget())
end




function templar_assassin_psionic_trap_custom:SetTrap(point, target)
if not IsServer() then return end

local max_timer = self:GetMaxTime()


self:GetCaster():EmitSound("Hero_TemplarAssassin.Trap.Cast")

if not self.counter_modifier or self.counter_modifier:IsNull() then
    self.counter_modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter")
end

if not self.counter_modifier or self.counter_modifier:IsNull() or not self.counter_modifier.trap_count then
    return
end


if target then 
    local target = self:GetCursorTarget()
    target:EmitSound("Hero_TemplarAssassin.Trap")
    target:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap_legendary", {duration = max_timer})
else 

    if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_1") then 
        self:GetCaster():CdAbility(self, self:GetCooldownTimeRemaining()*self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_1", "cd")/100)
    end

    local max_traps = self:GetSpecialValueFor("max_traps")
    if self:GetCaster():HasShard() then
       max_traps = max_traps + self:GetSpecialValueFor("shard_bonus_max_traps")
    end


    local trap = CreateUnitByName("npc_dota_templar_assassin_psionic_trap", point, false, nil, nil, self:GetCaster():GetTeamNumber())

    trap.ta_owner = self:GetCaster()
    
    FindClearSpaceForUnit(trap, trap:GetAbsOrigin(), false)
    local trap_modifier = trap:AddNewModifier(self:GetCaster(), self, "modifier_templar_assassin_psionic_trap_custom_trap", {})
    trap:SetControllableByPlayer(self:GetCaster():GetPlayerOwnerID(), true)

    EmitSoundOnLocationWithCaster(point, "Hero_TemplarAssassin.Trap", self:GetCaster())
    local remove_default = trap:FindAbilityByName("templar_assassin_self_trap")
    if remove_default then
        trap:RemoveAbility("templar_assassin_self_trap")
    end
    local custom_ability = trap:AddAbility("templar_assassin_self_trap_custom")

    if trap:HasAbility("templar_assassin_self_trap_custom") then
        trap:FindAbilityByName("templar_assassin_self_trap_custom"):SetHidden(false)
        trap:FindAbilityByName("templar_assassin_self_trap_custom"):SetLevel(self:GetLevel())
    end

    table.insert(self.counter_modifier.trap_count, trap_modifier)

    if #self.counter_modifier.trap_count > max_traps then
        if self.counter_modifier.trap_count[1]:GetParent() then
            self.counter_modifier.trap_count[1]:GetParent():ForceKill(false)
        end
    end

    self.counter_modifier:SetStackCount(#self.counter_modifier.trap_count)


end

end















-- Модификатор на ловушке с функцией взрыва и эффектом

modifier_templar_assassin_psionic_trap_custom_trap = class({})

function modifier_templar_assassin_psionic_trap_custom_trap:IsHidden() return true end
function modifier_templar_assassin_psionic_trap_custom_trap:IsPurgable() return false end

function modifier_templar_assassin_psionic_trap_custom_trap:OnCreated(params)
if not IsServer() then return end

self.self_particle      = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_trap.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.self_particle, 60, Vector(96, 0, 132))
ParticleManager:SetParticleControl(self.self_particle, 61, Vector(1, 0, 0))
self:AddParticle(self.self_particle, false, false, -1, false, false)

self.vision = self:GetAbility():GetSpecialValueFor("vision_radius")
if self:GetCaster():HasShard() then
    self.vision = self.vision + self:GetAbility():GetSpecialValueFor("shard_bonus_vision")
end


self.trap_counter_modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter")
self.activated = false
self.invis = false
self.timer = 0

self.invun = self:GetCaster():HasModifier("modifier_templar_assassin_psionic_5")


self.invun_timer = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_5", "duration")

self.main_ability = self:GetAbility()

self.invis_timer = self:GetAbility():GetSpecialValueFor("trap_fade_time")
self.max_timer = self:GetAbility():GetMaxTime()

self.interval = 0.1

self:StartIntervalThink(self.interval)
end


function modifier_templar_assassin_psionic_trap_custom_trap:OnDestroy()
if not IsServer() then return end

if self.trap_counter_modifier and self.trap_counter_modifier.trap_count then

    for trap_modifier = 1, #self.trap_counter_modifier.trap_count do
        if self.trap_counter_modifier.trap_count[trap_modifier] == self then
            table.remove(self.trap_counter_modifier.trap_count, trap_modifier)
            if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_trap_custom_counter") then
                self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter"):DecrementStackCount()
            end
            break
        end
    end
end

end

function modifier_templar_assassin_psionic_trap_custom_trap:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE]          = self.invis,
        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = self.invun,
        [MODIFIER_STATE_INVULNERABLE] = self.invun
    }
end


function modifier_templar_assassin_psionic_trap_custom_trap:Explode()
if not IsServer() then return end
    

self.main_ability:ExplodeTrap(self:GetParent():GetAbsOrigin(), self.timer/self.max_timer)

self:GetParent():ForceKill(false)

if not self:IsNull() then
    self:Destroy()
end

end

function modifier_templar_assassin_psionic_trap_custom_trap:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self.vision, self.interval, false)


if self.activated == true then return end

self.timer = self.timer + self.interval

if self.timer >= self.invun_timer then 
    self.invun = false
end

if self.timer >= self.invis_timer then
    self.invis = true
end

if self.timer >= self.max_timer then
    self.activated = true
    ParticleManager:SetParticleControl(self.self_particle, 60, Vector(0, 0, 0))
    ParticleManager:SetParticleControl(self.self_particle, 61, Vector(0, 0, 0))
end


end









-- Модификатор количества ловушек

modifier_templar_assassin_psionic_trap_custom_counter = class({})

function modifier_templar_assassin_psionic_trap_custom_counter:OnCreated()
    if not IsServer() then return end
    self.trap_count = {}
end

-- Способность у самой ловушки на взрыва

templar_assassin_self_trap_custom = class({})

function templar_assassin_self_trap_custom:OnSpellStart()
    local modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_trap")
    if modifier then
        modifier:Explode()
    end
end

-- Уничтожить ловушку через скилл темпларки

templar_assassin_trap_custom  = class({})

function templar_assassin_trap_custom:OnSpellStart()
if not IsServer() then return end


if not self.trap_ability then
    self.trap_ability = self:GetCaster():FindAbilityByName("templar_assassin_psionic_trap_custom")
end

if not self.counter_modifier or self.counter_modifier:IsNull() then
    self.counter_modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter")
end


if self.trap_ability and self.counter_modifier and self.counter_modifier.trap_count and #self.counter_modifier.trap_count > 0 then

    local search_point = self:GetCaster():GetAbsOrigin()

    if self:GetAutoCastState() == true then 
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), 'get_cursor_position', { } ) 
    else 
        self:Activate(search_point.x, search_point.y, search_point.z)
    end

end 


end


function templar_assassin_trap_custom:Activate(x, y, z)
if not IsServer() then return end

local search_point = Vector(x, y, z)

local distance  = nil
local index     = nil
for trap_number = 1, #self.counter_modifier.trap_count do
    if self.counter_modifier.trap_count[trap_number] and not self.counter_modifier.trap_count[trap_number]:IsNull() then
        if not distance then
            index       = trap_number
            distance    = (search_point - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D()

        else
            if ((search_point - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D() < distance) then
                index       = trap_number
                distance    = (search_point - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D()
            end
        end
    end
end
if index then
    self.counter_modifier.trap_count[index]:Explode()
end


end






templar_assassin_trap_teleport_custom = class({})



function templar_assassin_trap_teleport_custom:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function templar_assassin_trap_teleport_custom:GetChannelTime()
    return self.BaseClass.GetChannelTime(self)
end


function templar_assassin_trap_teleport_custom:GetCastRange(vLocation, hTarget)

if IsClient() then 
    return  self:GetSpecialValueFor("castrange")
else 
    return 9999999
end


end


function templar_assassin_trap_teleport_custom:GetRealPoint(point)

local vec = (point - self:GetCaster():GetAbsOrigin())
local max = self:GetSpecialValueFor("castrange") + self:GetCaster():GetCastRangeBonus()

if vec:Length2D() > max then 
    return self:GetCaster():GetAbsOrigin() + max*vec:Normalized()
else 
    return point
end

end 


function templar_assassin_trap_teleport_custom:GetAOERadius()
return self:GetSpecialValueFor("radius")
end


function templar_assassin_trap_teleport_custom:OnAbilityPhaseStart()

return self:FindTrap(self:GetRealPoint(self:GetCursorPosition()))
end






function templar_assassin_trap_teleport_custom:FindTrap(point)

local radius = self:GetSpecialValueFor("radius")

if not self.counter_modifier or self.counter_modifier:IsNull() then
    self.counter_modifier = self:GetCaster():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_counter")
end

local distance  = nil
local index     = nil

for trap_number = 1, #self.counter_modifier.trap_count do

    if self.counter_modifier.trap_count[trap_number] and not self.counter_modifier.trap_count[trap_number]:IsNull()

        and  (self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin() - point):Length2D() < radius then
                
        if not distance then
            index       = trap_number
            distance    = (point - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D()
        elseif ((self:GetCursorPosition() - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D() < distance) then
            index       = trap_number
            distance    = (point - self.counter_modifier.trap_count[trap_number]:GetParent():GetAbsOrigin()):Length2D()
        end

    end


end

if index then 
    return  self.counter_modifier.trap_count[index]
else 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetCaster():GetPlayerOwnerID()), "CreateIngameErrorMessage", {message = "#no_trap"})
    return false
end 


end 




function templar_assassin_trap_teleport_custom:OnSpellStart()
if not IsServer() then return end

self.point = self:GetRealPoint(self:GetCursorPosition())
end


function templar_assassin_trap_teleport_custom:OnChannelFinish(bInterrupted)
if not IsServer() then return end
if bInterrupted then return end

if not self.trap_ability then
    self.trap_ability = self:GetCaster():FindAbilityByName("templar_assassin_psionic_trap_custom")
end
        
if self.point then 

    local trap = self:FindTrap(self.point)

    if trap and trap:GetParent() and trap:GetParent():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_trap") then 
        local point = trap:GetParent():GetAbsOrigin()

        local start_point = self:GetCaster():GetAbsOrigin()

        self.trap_ability:Teleport(point)
     
        self.trap_ability:ExplodeTrap(start_point, 1)

        trap:GetParent():FindModifierByName("modifier_templar_assassin_psionic_trap_custom_trap"):Explode()


    end 

end         


end














modifier_templar_assassin_psionic_trap_custom_trap_debuff = class({})

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:IsPurgable() return true end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:OnCreated(params)
if not IsServer() then return end
if not params.k then return end

self.movement_speed_min = self:GetAbility():GetSpecialValueFor("movement_speed_min")
self.movement_speed_max = self:GetAbility():GetSpecialValueFor("movement_speed_max")

self.main_ability = self:GetAbility()

self.max_timer = self.main_ability:GetMaxTime()

self.movespeed_reduced = self.movement_speed_min + (self.movement_speed_max - self.movement_speed_min)*params.k

self:SetStackCount(self.movespeed_reduced)

self.damage = self:GetAbility():GetSpecialValueFor("trap_bonus_damage")


if params.k >= 0.99 then 

    if self:GetCaster():HasModifier("modifier_templar_assassin_psionic_7")  then 
        SendOverheadEventMessage(self:GetParent(), 4, self:GetParent(), self.damage, nil)
        ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
    else


        self.interval = self.main_ability:GetSpecialValueFor("damage_interval")
        self.damage = (self.damage/self:GetRemainingTime())*self.interval

        self:StartIntervalThink(self.interval)
    end

end

end



function modifier_templar_assassin_psionic_trap_custom_trap_debuff:OnRefresh(table)
if not IsServer() then return end
self:OnCreated(table)
end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:OnIntervalThink()
if not IsServer() then return end

ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }

    return funcs
end


function modifier_templar_assassin_psionic_trap_custom_trap_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self:GetStackCount()*-1
end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:GetTexture()  return "templar_assassin_psionic_trap" end

function modifier_templar_assassin_psionic_trap_custom_trap_debuff:GetEffectName()
    return "particles/units/heroes/hero_templar_assassin/templar_assassin_trap_slow.vpcf"
end





modifier_templar_assassin_psionic_trap_custom_trap_vision = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_vision:IsHidden() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_vision:IsPurgable() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_vision:GetTexture() return "buffs/psionic_vision" end


function modifier_templar_assassin_psionic_trap_custom_trap_vision:OnCreated(table)
if not IsServer() then return end
self.RemoveForDuel = true
self.parent = self:GetParent()
self.caster = self:GetCaster()


if self.parent:IsHero() then 
    self.particle_trail_fx = ParticleManager:CreateParticleForTeam("particles/pa_vendetta.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent, self.caster:GetTeamNumber())
    self:AddParticle(self.particle_trail_fx, false, false, -1, false, false)
end

self:StartIntervalThink(FrameTime())
end

function modifier_templar_assassin_psionic_trap_custom_trap_vision:OnIntervalThink()
if not IsServer() then return end
AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, FrameTime(), false )
end




modifier_templar_assassin_psionic_trap_custom_trap_illusion = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_illusion:IsHidden() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_illusion:IsPurgable() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_illusion:GetStatusEffectName() return "particles/status_fx/status_effect_dark_seer_normal_punch_replica.vpcf" end

function modifier_templar_assassin_psionic_trap_custom_trap_illusion:StatusEffectPriority()
    return 10010
end


function modifier_templar_assassin_psionic_trap_custom_trap_illusion:CheckState()
return
{
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_UNTARGETABLE] = true,
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_ROOTED] = true,
}
end

function modifier_templar_assassin_psionic_trap_custom_trap_illusion:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end





function modifier_templar_assassin_psionic_trap_custom_trap_illusion:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if params.target:IsBuilding() then return end

local damage = params.target:GetMaxHealth()*self:GetAbility().illusion_damage[self:GetCaster():GetUpgradeStack("modifier_templar_assassin_psionic_4")]

if params.target:IsCreep() then 
    damage = damage*self:GetAbility().illusion_creeps
end

SendOverheadEventMessage(params.target, 4, params.target, damage, nil)
ApplyDamage({victim = params.target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility()})



end



modifier_templar_assassin_psionic_trap_custom_trap_legendary = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_legendary:IsHidden() return true end
function modifier_templar_assassin_psionic_trap_custom_trap_legendary:IsPurgable() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_legendary:GetEffectName()
return "particles/ta_trap_target.vpcf"
end
function modifier_templar_assassin_psionic_trap_custom_trap_legendary:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_templar_assassin_psionic_trap_custom_trap_legendary:OnCreated(table)
if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_templar_assassin/templar_assassin_meld_armor.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)


self.old = -1

self.timer = self:GetAbility():GetMaxTime()



self:OnIntervalThink()
self:StartIntervalThink(0.1)
end


function modifier_templar_assassin_psionic_trap_custom_trap_legendary:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 400, 0.1, true)

local new = math.floor(self:GetElapsedTime()/0.5)


if self.old < new then 
    self.old = new
else 
    return
end



local caster = self:GetParent()

local number = (math.floor(self.timer / 0.5) - self.old )/2


local int = number
if number % 1 ~= 0 then 
    int = number - 0.5  
end


local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
   decimal = 8
else 
   decimal = 1
end

local particleName = "particles/ta_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end







function modifier_templar_assassin_psionic_trap_custom_trap_legendary:OnDestroy()
if not IsServer() then return end

if self:GetAbility() and self:GetAbility():GetAutoCastState() == true and not self:GetCaster():IsRooted() and not self:GetCaster():IsLeashed() then 

    self:GetAbility():Teleport(self:GetParent():GetAbsOrigin() - self:GetParent():GetForwardVector()*self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_7", "distance"))
end 


self:GetAbility():ExplodeTrap(self:GetParent():GetAbsOrigin(), 1)
end






modifier_templar_assassin_psionic_trap_custom_trap_incoming = class({})

function modifier_templar_assassin_psionic_trap_custom_trap_incoming:IsHidden() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_incoming:GetTexture() return "buffs/orb_attack_speed" end
function modifier_templar_assassin_psionic_trap_custom_trap_incoming:IsPurgable() return true end

function modifier_templar_assassin_psionic_trap_custom_trap_incoming:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_2", "damage")
if not IsServer() then return end

self.particle_peffect = ParticleManager:CreateParticle("particles/ta_trap_damage.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)

end

function modifier_templar_assassin_psionic_trap_custom_trap_incoming:DeclareFunctions()
return 
{ 
  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end


function modifier_templar_assassin_psionic_trap_custom_trap_incoming:GetModifierIncomingDamage_Percentage()
return self.damage
end 
  





modifier_templar_assassin_psionic_trap_custom_trap_heal = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_heal:IsHidden() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_heal:IsPurgable() return true end
function modifier_templar_assassin_psionic_trap_custom_trap_heal:GetTexture() return "buffs/arcane_regen" end
function modifier_templar_assassin_psionic_trap_custom_trap_heal:OnCreated()
self.heal = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_3", "heal")/self:GetRemainingTime()


end 


function modifier_templar_assassin_psionic_trap_custom_trap_heal:GetEffectName() return "particles/units/heroes/hero_oracle/oracle_purifyingflames.vpcf" end

function modifier_templar_assassin_psionic_trap_custom_trap_heal:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_templar_assassin_psionic_trap_custom_trap_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}

end


function modifier_templar_assassin_psionic_trap_custom_trap_heal:GetModifierHealthRegenPercentage()
return self.heal
end



modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce:IsHidden() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce:IsPurgable() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce:GetTexture() return "buffs/arcane_regen" end
function modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce:OnCreated()
self.reduce = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_3", "heal_reduce")
end

function modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
}
end


function modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce:GetModifierLifestealRegenAmplify_Percentage() 
return self.reduce
end

function modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce:GetModifierHealAmplify_PercentageTarget() 
return self.reduce
end

function modifier_templar_assassin_psionic_trap_custom_trap_heal_reduce:GetModifierHPRegenAmplify_Percentage() 
return self.reduce
end





modifier_templar_assassin_psionic_trap_custom_trap_stun = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_stun:IsHidden() return true end
function modifier_templar_assassin_psionic_trap_custom_trap_stun:IsPurgable() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_stun:IsStunDebuff() return true end
function modifier_templar_assassin_psionic_trap_custom_trap_stun:IsPurgeException() return true end
function modifier_templar_assassin_psionic_trap_custom_trap_stun:StatusEffectPriority() return 9999 end
function modifier_templar_assassin_psionic_trap_custom_trap_stun:GetStatusEffectName() return "particles/status_fx/status_effect_faceless_chronosphere.vpcf" end
function modifier_templar_assassin_psionic_trap_custom_trap_stun:CheckState()
return
{
    [MODIFIER_STATE_FROZEN] = true,
    [MODIFIER_STATE_STUNNED] = true
}
end


modifier_templar_assassin_psionic_trap_custom_trap_stun_cd = class({})

function modifier_templar_assassin_psionic_trap_custom_trap_stun_cd:IsHidden() return true end
function modifier_templar_assassin_psionic_trap_custom_trap_stun_cd:IsPurgable() return false end


modifier_templar_assassin_psionic_trap_custom_trap_move = class({})
function modifier_templar_assassin_psionic_trap_custom_trap_move:IsHidden() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_move:IsPurgable() return false end
function modifier_templar_assassin_psionic_trap_custom_trap_move:GetTexture() return "buffs/psionic_vision" end
function modifier_templar_assassin_psionic_trap_custom_trap_move:OnCreated()

self.move = self:GetCaster():GetTalentValue("modifier_templar_assassin_psionic_6", "move")
if not IsServer() then return end

local effect_cast = ParticleManager:CreateParticle( "particles/ta_psi_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetAbsOrigin() )
self:AddParticle( effect_cast, false, false, -1, false, false)
end

function modifier_templar_assassin_psionic_trap_custom_trap_move:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_templar_assassin_psionic_trap_custom_trap_move:GetModifierMoveSpeedBonus_Percentage()
return self.move
end