LinkLuaModifier( "modifier_sniper_shrapnel_custom", "abilities/sniper/sniper_shrapnel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_custom_damage", "abilities/sniper/sniper_shrapnel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_custom_damage_stack", "abilities/sniper/sniper_shrapnel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_custom_thinker", "abilities/sniper/sniper_shrapnel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_custom_mine", "abilities/sniper/sniper_shrapnel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_custom_tracker", "abilities/sniper/sniper_shrapnel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_custom_heal", "abilities/sniper/sniper_shrapnel_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_custom_silence", "abilities/sniper/sniper_shrapnel_custom", LUA_MODIFIER_MOTION_NONE )



sniper_shrapnel_custom = class({})
sniper_shrapnel_custom_1 = class({})
sniper_shrapnel_custom_2 = class({})
sniper_shrapnel_custom_3 = class({})
sniper_shrapnel_custom_4 = class({})
sniper_shrapnel_custom_4_1 = class({})
sniper_shrapnel_custom_4_2 = class({})
sniper_shrapnel_custom_4_3 = class({})




function sniper_shrapnel_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_shrapnel.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_sniper/sniper_shrapnel_launch.vpcf", context )
PrecacheResource( "particle", "particles/sf_refresh_a.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context)
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context)

end


function sniper_shrapnel_custom:GetIntrinsicModifierName()
return "modifier_sniper_shrapnel_custom_tracker"
end



function sniper_shrapnel_custom:GetAOERadius()

local bonus = 0

if self:GetCaster():HasModifier("modifier_sniper_shrapnel_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "radius")
end

    return self:GetSpecialValueFor( "radius" ) + bonus
end



function sniper_shrapnel_custom:Launch(point)


local caster = self:GetCaster()
CreateModifierThinker( caster, self, "modifier_sniper_shrapnel_custom_thinker", {}, point, caster:GetTeamNumber(), false) 


if caster:GetName() == "npc_dota_hero_sniper" and RollPercentage(100) then
    caster:EmitSound("sniper_snip_ability_shrapnel_0"..math.random(1,3))
end


self:PlayEffects( point )
end



function sniper_shrapnel_custom:OnSpellStart()

local point = self:GetCursorPosition()
self:Launch(point)

end



function sniper_shrapnel_custom:PlayEffects( point )

local particle_cast = "particles/units/heroes/hero_sniper/sniper_shrapnel_launch.vpcf"
local sound_cast = "Hero_Sniper.ShrapnelShoot"

local height = 2000

local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControlEnt(  effect_cast, 0,  self:GetCaster(),  PATTACH_POINT_FOLLOW,  "attach_attack1",  self:GetCaster():GetOrigin(),  false )
ParticleManager:SetParticleControl( effect_cast, 1, point + Vector( 0, 0, height ) )
ParticleManager:ReleaseParticleIndex( effect_cast )

self:GetCaster():EmitSound(sound_cast)

end







modifier_sniper_shrapnel_custom_thinker = class({})

function modifier_sniper_shrapnel_custom_thinker:IsHidden()
    return true
end

function modifier_sniper_shrapnel_custom_thinker:IsPurgable()
    return false
end



function modifier_sniper_shrapnel_custom_thinker:IsAura()
    return self.start
end

function modifier_sniper_shrapnel_custom_thinker:GetModifierAura()
    return "modifier_sniper_shrapnel_custom_damage"
end

function modifier_sniper_shrapnel_custom_thinker:GetAuraRadius()
    return self.radius
end
function modifier_sniper_shrapnel_custom_thinker:GetAuraDuration()
    return 0.5
end


function modifier_sniper_shrapnel_custom_thinker:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_sniper_shrapnel_custom_thinker:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


function modifier_sniper_shrapnel_custom_thinker:OnCreated( kv )

self.delay = self:GetAbility():GetSpecialValueFor( "damage_delay" ) 
self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
self.damage = self:GetAbility():GetSpecialValueFor( "shrapnel_damage" )
self.duration = self:GetAbility():GetSpecialValueFor( "duration" ) 
self.damage = self:GetAbility():GetSpecialValueFor( "shrapnel_damage" )

self.interval = 1

self.start = false



if self:GetCaster():HasModifier("modifier_sniper_shrapnel_6") then 
    self.radius = self.radius  + self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "radius")
    self.delay = self.delay + self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "delay")
end

if not IsServer() then return end

self.direction = (self:GetParent():GetOrigin()-self:GetCaster():GetOrigin()):Normalized()
self.direction.z = 0

self:StartIntervalThink( self.delay )
    

end

function modifier_sniper_shrapnel_custom_thinker:OnDestroy( kv )
end



function modifier_sniper_shrapnel_custom_thinker:OnIntervalThink()
if not self.start then
    self.start = true
    self:SetDuration( self.duration + FrameTime()*2, true )

    self:GetParent():EmitSound("Sniper.ShrapnelShatter")  

    if self:GetCaster():HasModifier("modifier_sniper_shrapnel_3") then 
        self:StartIntervalThink(0.2)
    end

    AddFOWViewer( self:GetCaster():GetTeamNumber(), self:GetParent():GetOrigin(), self.radius, self.duration, false )

    if self:GetCaster():HasModifier("modifier_sniper_shrapnel_4") then 

        local mine = CreateUnitByName("npc_sniper_mine", self:GetParent():GetAbsOrigin(), true, nil, nil, self:GetCaster():GetTeamNumber())

        mine:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sniper_shrapnel_custom_mine", {})
        mine:SetMaxHealth(self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_4", "attacks"))
        mine:SetHealth(self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_4", "attacks"))

    end

    self:PlayEffects()
end


if (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self.radius and self:GetCaster():HasModifier("modifier_sniper_shrapnel_3") then 
    self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sniper_shrapnel_custom_heal", {duration = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_3", "duration")})
end


end


function modifier_sniper_shrapnel_custom_thinker:OnDestroy()

    self:StopEffects()
end

function modifier_sniper_shrapnel_custom_thinker:PlayEffects()

    local particle_cast = "particles/units/heroes/hero_sniper/sniper_shrapnel.vpcf"


    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
    ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 1, 1 ) )
    ParticleManager:SetParticleControlForward( self.effect_cast, 2, self.direction + Vector(0, 0, 0.1) )
end

function modifier_sniper_shrapnel_custom_thinker:StopEffects()
if not IsServer() then return end

    if self.effect_cast then 
        ParticleManager:DestroyParticle( self.effect_cast, false )
        ParticleManager:ReleaseParticleIndex( self.effect_cast )
    end

    self:GetParent():StopSound(self.sound_cast )
end





modifier_sniper_shrapnel_custom_tracker = class({})

function modifier_sniper_shrapnel_custom_tracker:IsHidden() return true end
function modifier_sniper_shrapnel_custom_tracker:IsPurgable() return false end
function modifier_sniper_shrapnel_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end



function modifier_sniper_shrapnel_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():HasModifier('modifier_sniper_shrapnel_7') then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if self:GetParent() ~= params.attacker then return end



local chance = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_7", "chance")

if params.target:IsCreep() then 
    chance = chance*self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_7", "chance_creeps")
end

if not RollPseudoRandomPercentage(chance,276,self:GetParent()) then return end

self:GetParent():EmitSound("Sniper.Shrapnel_legendary")

local name = "sniper_shrapnel_custom"

if self:GetParent():HasModifier("modifier_sniper_shrapnel_6") then 
    name = "sniper_shrapnel_custom_4"
end

local mod = self:GetParent():FindModifierByName("modifier_sniper_shrapnel_1") 

if mod then 
    name = name..'_'..tostring(mod:GetStackCount())
end

local ability = self:GetParent():FindAbilityByName(name)

if ability then

    local max = ability:GetMaxAbilityCharges(ability:GetLevel())

    if ability:GetCurrentAbilityCharges() < max then 
         ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges() + 1)
    end 

    if ability:GetCurrentAbilityCharges() == max then 
        ability:RefreshCharges()
    end


    local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particle)
end



end










modifier_sniper_shrapnel_custom = class({})


function modifier_sniper_shrapnel_custom:IsHidden()
    return false
end


function modifier_sniper_shrapnel_custom:IsPurgable()
    return false
end


function modifier_sniper_shrapnel_custom:OnCreated(table)

self.ms_slow = self:GetAbility():GetSpecialValueFor( "slow_movement_speed" )

self.silence_max = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_5", "timer")

self.legendary_max = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_7", "stacks")
self.legendary_k =  self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_7", "slow")

self.silence_slow = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_5", "slow")

self.particle_peffect = nil

if not IsServer() then return end

self.silence_timer = 0
self.interval_timer = 0


self:StartIntervalThink(0.05)

if not self:GetCaster():HasModifier("modifier_sniper_shrapnel_7") then return end
self:SetStackCount(1)
end


function modifier_sniper_shrapnel_custom:OnRefresh(table)
if not IsServer() then return end
if not self:GetCaster():HasModifier("modifier_sniper_shrapnel_7") then return end

self:IncrementStackCount()

if self:GetStackCount() == self.legendary_max then 
    self:GetParent():EmitSound("Sniper.Shrapnel_slow")

    if self.particle_peffect == nil then 

        self.particle_peffect = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())   
        self:AddParticle(self.particle_peffect, false, false, -1, false, true)
    end

end 

end


function modifier_sniper_shrapnel_custom:OnStackCountChanged(iStackCount)
if not IsServer() then return end

if self:GetStackCount() < self.legendary_max then 

    if self.particle_peffect then 
        ParticleManager:DestroyParticle(self.particle_peffect, true)
        ParticleManager:ReleaseParticleIndex(self.particle_peffect)

        self.particle_peffect = nil
    end
end

end





function modifier_sniper_shrapnel_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }

    return funcs
end

function modifier_sniper_shrapnel_custom:GetModifierMoveSpeedBonus_Percentage()
local k = 1
if self:GetStackCount() >= self.legendary_max and self:GetCaster():HasModifier("modifier_sniper_shrapnel_7") then 
    k = self.legendary_k
end

local bonus = 0 
if self:GetCaster():HasModifier("modifier_sniper_shrapnel_5") then 
    bonus = self.silence_slow
end

    return (self.ms_slow + bonus) * k
end





function modifier_sniper_shrapnel_custom:OnIntervalThink()
if not IsServer() then return end

if self:GetParent():IsRealHero() and not self:GetCaster():QuestCompleted() and self:GetCaster():GetQuest() == "Sniper.Quest_5" then 
    self:GetCaster():UpdateQuest(0.05)
end

self.interval_timer = self.interval_timer + 0.05

if self.interval_timer >= 0.94 then 

    self.interval_timer = 0

    if self:GetCaster():HasModifier("modifier_sniper_shrapnel_5") and not self:GetParent():HasModifier("modifier_sniper_shrapnel_custom_silence") then 
        self.silence_timer = self.silence_timer + 1

        if self.silence_timer >= self.silence_max then 
            self.silence_timer = 0
            self:GetParent():EmitSound("Sniper.Shrapnel_Silence")

            self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sniper_shrapnel_custom_silence", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_5", "silence")})
        end

    end

    if self:GetCaster():HasModifier("modifier_sniper_shrapnel_2") then 
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sniper_shrapnel_custom_damage_stack", {duration = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_2", "duration")})
    end

end

end









modifier_sniper_shrapnel_custom_damage = class({})


function modifier_sniper_shrapnel_custom_damage:IsHidden()
    return true
end


function modifier_sniper_shrapnel_custom_damage:GetAttributes()
if not self:GetCaster():HasModifier("modifier_sniper_shrapnel_7") then return end
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_sniper_shrapnel_custom_damage:IsPurgable()
    return false
end


function modifier_sniper_shrapnel_custom_damage:OnCreated( kv )


self.damage = self:GetAbility():GetSpecialValueFor( "shrapnel_damage" ) -- special value
self.damage_inc = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_2", "damage")

local interval = 1
self.caster = self:GetAbility():GetCaster()

if not IsServer() then return end

self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_sniper_shrapnel_custom", {})

self.damageTable = { victim = self:GetParent(), attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(),  }


self:StartIntervalThink( interval )
self:OnIntervalThink()
end


function modifier_sniper_shrapnel_custom_damage:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_sniper_shrapnel_custom")

if mod then 
    mod:DecrementStackCount()
    if mod:GetStackCount() == 0 then 
        mod:Destroy()
    end
end

end


function modifier_sniper_shrapnel_custom_damage:OnIntervalThink()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_sniper_shrapnel_custom_damage_stack")

local damage = self.damage
if mod then 
    damage = damage + self.damage_inc*mod:GetStackCount()
end

self.damageTable.damage = damage

ApplyDamage(self.damageTable)

end











modifier_sniper_shrapnel_custom_mine = class({})
function modifier_sniper_shrapnel_custom_mine:IsHidden() return true end
function modifier_sniper_shrapnel_custom_mine:IsPurgable() return false end
function modifier_sniper_shrapnel_custom_mine:OnCreated(table)
if not IsServer() then return end

self.health = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_4", "attacks")

self:GetParent():EmitSound("Sniper.Shrapnel_mine_active")

self:StartIntervalThink(self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_4", "timer"))
end

function modifier_sniper_shrapnel_custom_mine:OnIntervalThink()
if not IsServer() then return end

local radius = self:GetAbility():GetSpecialValueFor( "radius" )

local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 1.0, 1.0, radius ) )
ParticleManager:SetParticleControl( nFXIndex, 2, Vector( 1.0, 1.0, radius ) )
ParticleManager:ReleaseParticleIndex( nFXIndex )

EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Sniper.Shrapnel_mine_explosion", self:GetCaster())

local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)


for _,enemy in pairs(enemies) do 

    enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - enemy:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_4", "stun")})
    

    local damage = self:GetAbility():GetSpecialValueFor("shrapnel_damage")
    local mod = enemy:FindModifierByName("modifier_sniper_shrapnel_custom_damage_stack")

    if mod then 
        damage = damage + mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_2", "damage")
    end
    damage = damage*self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_4", "damage")/100

    local damageTable = { victim = enemy, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(),  }
    ApplyDamage(damageTable)

    SendOverheadEventMessage(enemy, 4, enemy, damage, nil)

end


self:Destroy()
end


function modifier_sniper_shrapnel_custom_mine:OnDestroy()
if not IsServer() then return end

self:GetParent():ForceKill(false)
end


function modifier_sniper_shrapnel_custom_mine:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end


function modifier_sniper_shrapnel_custom_mine:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.target then return end

self.health = self.health - 1

if self.health < 1 then 
    self:Destroy()
else 

    self:GetParent():SetHealth(self.health)
end

end


function modifier_sniper_shrapnel_custom_mine:GetAbsoluteNoDamagePhysical()
return 1
end


function modifier_sniper_shrapnel_custom_mine:GetAbsoluteNoDamageMagical()
return 1
end

function modifier_sniper_shrapnel_custom_mine:GetAbsoluteNoDamagePure()
return 1
end


function modifier_sniper_shrapnel_custom_mine:CheckState()
return
{
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    [MODIFIER_STATE_ROOTED] = true,
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
}
end


modifier_sniper_shrapnel_custom_heal = class({})
function modifier_sniper_shrapnel_custom_heal:IsHidden() return false end
function modifier_sniper_shrapnel_custom_heal:IsPurgable() return false end
function modifier_sniper_shrapnel_custom_heal:GetTexture() return "buffs/cookie_heal" end

function modifier_sniper_shrapnel_custom_heal:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end


function modifier_sniper_shrapnel_custom_heal:GetModifierHealthRegenPercentage()
return self.heal
end


function modifier_sniper_shrapnel_custom_heal:GetModifierMoveSpeedBonus_Percentage()
return self.move
end



function modifier_sniper_shrapnel_custom_heal:OnCreated(table)

self.move = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_3", "move")
self.heal = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_3", "heal")

if not IsServer() then return end

self:OnIntervalThink()
self:StartIntervalThink(1)
end


function modifier_sniper_shrapnel_custom_heal:OnIntervalThink()
if not IsServer() then return end

local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )


SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal*self:GetParent():GetMaxHealth()/100, nil)

end


function modifier_sniper_shrapnel_custom_heal:GetEffectName()
    return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end
function modifier_sniper_shrapnel_custom_heal:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end





modifier_sniper_shrapnel_custom_damage_stack = class({})
function modifier_sniper_shrapnel_custom_damage_stack:IsHidden() return true end
function modifier_sniper_shrapnel_custom_damage_stack:IsPurgable() return false end
function modifier_sniper_shrapnel_custom_damage_stack:OnCreated(table)
if not IsServer() then return end

self.max = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_2", "max")

self:SetStackCount(1)
end

function modifier_sniper_shrapnel_custom_damage_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end


self:IncrementStackCount()
end





modifier_sniper_shrapnel_custom_silence = class({})

function modifier_sniper_shrapnel_custom_silence:IsHidden() return false end

function modifier_sniper_shrapnel_custom_silence:IsPurgable() return true end

function modifier_sniper_shrapnel_custom_silence:GetTexture() return "silencer_last_word" end

function modifier_sniper_shrapnel_custom_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end


function modifier_sniper_shrapnel_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_sniper_shrapnel_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end











function sniper_shrapnel_custom_1:OnSpellStart()

local point = self:GetCursorPosition()
local ability = self:GetCaster():FindAbilityByName("sniper_shrapnel_custom")

ability:Launch(point)

end

function sniper_shrapnel_custom_1:GetAOERadius()

local bonus = 0

if self:GetCaster():HasModifier("modifier_sniper_shrapnel_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "radius")
end

    return self:GetSpecialValueFor( "radius" ) + bonus
end

-----------------------------------------------------------------------


function sniper_shrapnel_custom_2:OnSpellStart()

local point = self:GetCursorPosition()
local ability = self:GetCaster():FindAbilityByName("sniper_shrapnel_custom")

ability:Launch(point)

end

function sniper_shrapnel_custom_2:GetAOERadius()

local bonus = 0

if self:GetCaster():HasModifier("modifier_sniper_shrapnel_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "radius")
end

    return self:GetSpecialValueFor( "radius" ) + bonus
end
-----------------------------------------------------------------------


function sniper_shrapnel_custom_3:OnSpellStart()

local point = self:GetCursorPosition()
local ability = self:GetCaster():FindAbilityByName("sniper_shrapnel_custom")

ability:Launch(point)

end

function sniper_shrapnel_custom_3:GetAOERadius()

local bonus = 0

if self:GetCaster():HasModifier("modifier_sniper_shrapnel_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "radius")
end

    return self:GetSpecialValueFor( "radius" ) + bonus
end
-----------------------------------------------------------------------


function sniper_shrapnel_custom_4:OnSpellStart()

local point = self:GetCursorPosition()
local ability = self:GetCaster():FindAbilityByName("sniper_shrapnel_custom")

ability:Launch(point)

end

function sniper_shrapnel_custom_4:GetAOERadius()

local bonus = 0

if self:GetCaster():HasModifier("modifier_sniper_shrapnel_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "radius")
end

    return self:GetSpecialValueFor( "radius" ) + bonus
end
-----------------------------------------------------------------------


function sniper_shrapnel_custom_4_1:OnSpellStart()

local point = self:GetCursorPosition()
local ability = self:GetCaster():FindAbilityByName("sniper_shrapnel_custom")

ability:Launch(point)

end

function sniper_shrapnel_custom_4_1:GetAOERadius()

local bonus = 0

if self:GetCaster():HasModifier("modifier_sniper_shrapnel_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "radius")
end

    return self:GetSpecialValueFor( "radius" ) + bonus
end
-----------------------------------------------------------------------


function sniper_shrapnel_custom_4_2:OnSpellStart()

local point = self:GetCursorPosition()
local ability = self:GetCaster():FindAbilityByName("sniper_shrapnel_custom")

ability:Launch(point)

end

function sniper_shrapnel_custom_4_2:GetAOERadius()

local bonus = 0

if self:GetCaster():HasModifier("modifier_sniper_shrapnel_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "radius")
end

    return self:GetSpecialValueFor( "radius" ) + bonus
end
-----------------------------------------------------------------------


function sniper_shrapnel_custom_4_3:OnSpellStart()

local point = self:GetCursorPosition()
local ability = self:GetCaster():FindAbilityByName("sniper_shrapnel_custom")

ability:Launch(point)

end

function sniper_shrapnel_custom_4_3:GetAOERadius()

local bonus = 0

if self:GetCaster():HasModifier("modifier_sniper_shrapnel_6") then 
    bonus = self:GetCaster():GetTalentValue("modifier_sniper_shrapnel_6", "radius")
end

    return self:GetSpecialValueFor( "radius" ) + bonus
end

-----------------------------------------------------------------------

