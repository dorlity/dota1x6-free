LinkLuaModifier("modifier_skeleton_king_reincarnation_custom", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_slow", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_legendary_skeleton_ai", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skelet_reincarnation", "abilities/wraith_king/skeleton_king_vampiric_aura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_silence", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_damage", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_aura", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_slow_aura", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_aura_damage", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_legendary", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_legendary_target", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_str", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_reincarnation_custom_invun", "abilities/wraith_king/skeleton_king_reincarnation", LUA_MODIFIER_MOTION_NONE)


skeleton_king_reincarnation_custom = class({})






function skeleton_king_reincarnation_custom:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf", context )
PrecacheResource( "particle", "particles/wk_shield.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_wraithking_ghosts.vpcf", context )
PrecacheResource( "particle", "particles/wk_burn.vpcf", context )
PrecacheResource( "particle", "particles/wraith_king/ult_legendary_damage.vpcf", context )

end





function skeleton_king_reincarnation_custom:GetIntrinsicModifierName()
	return "modifier_skeleton_king_reincarnation_custom"
end

function skeleton_king_reincarnation_custom:GetCooldown(level)
    local k = 0

    if self:GetCaster():HasModifier("modifier_skeleton_reincarnation_6") and 
     self:GetCaster():HasModifier("modifier_skeleton_king_reincarnation_custom_str") and 
     self:GetCaster():GetUpgradeStack("modifier_skeleton_king_reincarnation_custom_str") >= self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_6", "max")  then 
       
        k = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_6", "cd")
    end
    return self.BaseClass.GetCooldown( self, level ) + k
end



function skeleton_king_reincarnation_custom:GetManaCost(level)
    if self:GetCaster():HasShard()  then
        return 0
    end
    return self.BaseClass.GetManaCost(self, level)
end

function skeleton_king_reincarnation_custom:GetCastRange(vLocation, hTarget)

local bonus = 0
if self:GetCaster():HasShard() then 
    bonus = self:GetSpecialValueFor("shard_radius")
end

return self:GetSpecialValueFor("slow_radius") + bonus - self:GetCaster():GetCastRangeBonus()
end




function skeleton_king_reincarnation_custom:ReincarnationStart( params, modifier, caster )
    local unit = params.unit
    local reincarnate = params.reincarnate

    if reincarnate then
        modifier.reincarnation_death = true

        caster.reincarnate_res = true

        self:UseResources(true, false, false, true)
        local slow_duration = self:GetSpecialValueFor("slow_duration")

        if self:GetCaster():HasShard() then 
            slow_duration = slow_duration + self:GetSpecialValueFor("shard_slow")
        end

        local slow_radius = self:GetSpecialValueFor("slow_radius")

        if self:GetCaster():HasShard() then 
            slow_radius = slow_radius + self:GetSpecialValueFor("shard_radius")
        end


        local reincarnation_time = self:GetSpecialValueFor("reincarnate_time")

        local silence_duration = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_5", "silence")
        local pull_duration = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_5", "duration")

        local max_distance = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_5", "distance")

        if self:GetCaster():HasModifier("modifier_skeleton_reincarnation_5") then 

            reincarnation_time =  reincarnation_time + self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_5", "delay")

            local particle_cast = "particles/muerta/veil_pull.vpcf"

            local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
            ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetAbsOrigin() )
            ParticleManager:SetParticleControl( effect_cast, 1, Vector( slow_radius, slow_radius, slow_radius ) )
            ParticleManager:ReleaseParticleIndex( effect_cast )

        end

        local heroes = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, slow_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER,false)
        
        for _, target in ipairs(heroes) do
            if target:GetUnitName() ~= "npc_teleport" and not target:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
                
                if self:GetCaster():HasScepter() then 
                    local stun = self:GetCaster():FindAbilityByName("skeleton_king_hellfire_blast_custom")
                    if stun and stun:GetLevel() > 0 then 
                        stun:OnSpellStart(target)
                    end
                end

                target:AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_reincarnation_custom_slow", {duration = (1 - target:GetStatusResistance())*slow_duration})

                if caster:HasModifier("modifier_skeleton_reincarnation_5") then 
                    target:AddNewModifier(caster, self, "modifier_skeleton_king_reincarnation_custom_silence", {duration = (1 - target:GetStatusResistance())*silence_duration})
            
                    local dir = (self:GetCaster():GetAbsOrigin() -  target:GetAbsOrigin()):Normalized()
                    local point = self:GetCaster():GetAbsOrigin() - dir*100

                    local distance = (point - target:GetAbsOrigin()):Length2D()

                    distance = math.min(max_distance,  math.max(100, distance))
                    point = target:GetAbsOrigin() + dir*distance

                    target:AddNewModifier( self:GetCaster(),  self,  "modifier_generic_arc",  
                    {
                      target_x = point.x,
                      target_y = point.y,
                      distance = distance,
                      duration = pull_duration,
                      height = 0,
                      fix_end = false,
                      isStun = false,
                      activity = ACT_DOTA_FLAIL,
                    })

                end

            end
        end

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf", PATTACH_CUSTOMORIGIN, params.unit)
        ParticleManager:SetParticleAlwaysSimulate(particle)
        ParticleManager:SetParticleControl(particle, 0, params.unit:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, Vector(reincarnation_time, 0, 0))
        ParticleManager:SetParticleControl(particle, 11, Vector(200, 0, 0))
        ParticleManager:ReleaseParticleIndex(particle)

        params.unit:EmitSound("Hero_SkeletonKing.Reincarnate")

        if GameRules:IsDaytime() then
            AddFOWViewer(self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), 1800, reincarnation_time, true)
        else
            AddFOWViewer(self:GetCaster():GetTeamNumber(), params.unit:GetAbsOrigin(), 800, reincarnation_time, true)
        end
    else                
        modifier.reincarnation_death = false     
    end
end







modifier_skeleton_king_reincarnation_custom = class({})

function modifier_skeleton_king_reincarnation_custom:RemoveOnDeath() return false end
function modifier_skeleton_king_reincarnation_custom:IsHidden() return true end
function modifier_skeleton_king_reincarnation_custom:IsPurgable() return false end

function modifier_skeleton_king_reincarnation_custom:OnCreated(table)


self.multi = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_3", "bonus", true)

if not IsServer() then return end
self.caster = self:GetParent()
self.ability = self:GetAbility()

local ability = self:GetParent():FindAbilityByName("skeleton_king_reincarnation_custom_legendary")

local cooldown_mod = self.caster:AddNewModifier(self.caster, self:GetAbility(), "modifier_cooldown_speed", {ability = ability:GetName(), cd_inc = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_legendary", "cd_inc", true)})

cooldown_mod:SetProcRule(function()
    return self:GetParent():HasModifier("modifier_skeleton_reincarnation_legendary") and self.ability:GetCooldownTimeRemaining() > 0
end)


self:SetStackCount(1)
self:GetParent().reincarnate_res = false

self.str = 0

self.radius = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_1", "radius", true)

if self:GetParent():IsRealHero() then 
    self.interval = 0.5
    self:StartIntervalThink(self.interval)
end 

end


function modifier_skeleton_king_reincarnation_custom:OnIntervalThink()
if not IsServer() then return end

if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
    self:SetStackCount(self.multi)
else 
    self:SetStackCount(1)
end

self.str  = 0
local bonus = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_3", "str")*self:GetStackCount()/100

self.str  = self:GetParent():GetStrength() * bonus

self:GetParent():CalculateStatBonus(true)

if not self:GetParent():HasModifier("modifier_skeleton_king_reincarnation_custom_str") then 
    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_reincarnation_custom_str", {})
end

end 


function modifier_skeleton_king_reincarnation_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_REINCARNATION,    
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,  
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,                      
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_RESPAWN,
    }

end


function modifier_skeleton_king_reincarnation_custom:GetModifierBonusStats_Strength()
return self.str
end

function modifier_skeleton_king_reincarnation_custom:GetModifierPhysicalArmorBonus()
if not self:GetParent():HasModifier("modifier_skeleton_reincarnation_3") then return end 

local bonus = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_3", "armor")


return bonus * self:GetStackCount()
end



function modifier_skeleton_king_reincarnation_custom:OnRespawn(params)
if not IsServer() then return end
if params.unit ~= self:GetParent() then return end

self.reincarnation_death = false

if self:GetParent().reincarnate_res == false then return end

self:GetParent().reincarnate_res = false


if self:GetParent():HasScepter() then 

    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_reincarnation_custom_invun", {duration = self:GetAbility():GetSpecialValueFor("scepter_invun")})

    local crit = self:GetParent():FindAbilityByName("skeleton_king_mortal_strike_custom")
    if crit and crit:GetLevel() > 0 then 
        self:GetParent():AddNewModifier(self:GetParent(), crit, "modifier_skeleton_king_mortal_strike_scepter", {stack = self:GetAbility():GetSpecialValueFor("scepter_strikes"), duration = self:GetAbility():GetSpecialValueFor("scepter_duration")})
    end
end

end

function modifier_skeleton_king_reincarnation_custom:ReincarnateTime()
    if IsServer() then
        local bonus = 0

        if self:GetCaster():HasModifier("modifier_skeleton_reincarnation_5") then 
            bonus = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_5", "delay")
        end

        if self:GetParent():IsRealHero() and (not self:GetParent():HasModifier("modifier_death") or self:GetParent():HasModifier("modifier_axe_culling_blade_custom_aegis")) and self:GetAbility():IsFullyCastable() then

            return self:GetAbility():GetSpecialValueFor("reincarnate_time") + bonus
        end

        return nil
    end
end

function modifier_skeleton_king_reincarnation_custom:GetActivityTranslationModifiers()
    if self.reincarnation_death then
        return "reincarnate"
    end
    return nil
end

function modifier_skeleton_king_reincarnation_custom:OnDeath(params)
if not IsServer() then return end
local unit = params.unit
local reincarnate = params.reincarnate
if self:GetParent() ~= unit then return end
if not self:GetAbility():IsFullyCastable() then return end

if self:GetParent():GetQuest() == "Wraith.Quest_8" and (params.attacker:IsRealHero() or params.attacker:IsIllusion()) and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then 
    self:GetParent():UpdateQuest(1)
end


if (params.attacker:IsRealHero() or params.attacker:IsIllusion()) and params.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then 
    local mod = self:GetParent():FindModifierByName("modifier_skeleton_king_reincarnation_custom_str")

    if not mod then 
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_skeleton_king_reincarnation_custom_str", {})
    end 

    if mod then 
        mod:OnRefresh()
    end
end 


if self:GetCaster():HasModifier("modifier_skeleton_vampiric_legendary") then
    local ability = self:GetParent():FindAbilityByName("skeleton_king_vampiric_aura_custom")

    if ability then

        local duration = self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "duration")

        for i = 1,self:GetCaster():GetTalentValue("modifier_skeleton_vampiric_legendary", "reinc") do 
            ability:CreateSkeleton(self:GetParent():GetAbsOrigin() + RandomVector(200), nil, duration, false, true)
        end
    end 
end

self:GetAbility():ReincarnationStart( params, self, self:GetParent() )
end








function modifier_skeleton_king_reincarnation_custom:GetAuraRadius()
  return self.radius
end

function modifier_skeleton_king_reincarnation_custom:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skeleton_king_reincarnation_custom:GetAuraSearchType() 
  return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_skeleton_king_reincarnation_custom:GetModifierAura()
  return "modifier_skeleton_king_reincarnation_custom_slow_aura"
end

function modifier_skeleton_king_reincarnation_custom:IsAura()
  return self:GetParent():IsRealHero() and self:GetParent():HasModifier("modifier_skeleton_reincarnation_1")
end













modifier_skeleton_king_reincarnation_custom_slow = class({})

function modifier_skeleton_king_reincarnation_custom_slow:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_slow:IsPurgable() return not self:GetCaster():HasModifier("modifier_skeleton_reincarnation_5")
end

function modifier_skeleton_king_reincarnation_custom_slow:OnCreated()    
if not IsServer() then return end
local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_reincarnate_slow_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(particle, false, false, -1, false, false)    


if not self:GetCaster():HasModifier("modifier_skeleton_reincarnation_5") then return end

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )


self:StartIntervalThink(self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_5", "duration"))
end


function modifier_skeleton_king_reincarnation_custom_slow:OnIntervalThink()
if not IsServer() then return end
if not self.particle then return end

ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)

end

function modifier_skeleton_king_reincarnation_custom_slow:OnDestroy()
if not IsServer() then return end
if not self.particle then return end

ParticleManager:DestroyParticle(self.particle, false)
ParticleManager:ReleaseParticleIndex(self.particle)

end








function modifier_skeleton_king_reincarnation_custom_slow:DeclareFunctions()
    local decFuncs = {
    	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return decFuncs
end

function modifier_skeleton_king_reincarnation_custom_slow:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("movespeed")
end

function modifier_skeleton_king_reincarnation_custom_slow:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("attackslow")
end





modifier_skeleton_king_reincarnation_custom_silence = class({})
function modifier_skeleton_king_reincarnation_custom_silence:IsPurgable() return true end
function modifier_skeleton_king_reincarnation_custom_silence:IsHidden() return true end
function modifier_skeleton_king_reincarnation_custom_silence:CheckState()
return
{
    [MODIFIER_STATE_SILENCED] = true
}
end

function modifier_skeleton_king_reincarnation_custom_silence:GetTexture() return "buffs/reincarnate_silence" end
function modifier_skeleton_king_reincarnation_custom_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_skeleton_king_reincarnation_custom_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end








modifier_skeleton_king_reincarnation_custom_damage = class({})
function modifier_skeleton_king_reincarnation_custom_damage:IsHidden() 
    return self:GetStackCount() == 1
end
function modifier_skeleton_king_reincarnation_custom_damage:GetTexture() return "buffs/reincarnation_damage" end
function modifier_skeleton_king_reincarnation_custom_damage:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_damage:RemoveOnDeath() return false end
function modifier_skeleton_king_reincarnation_custom_damage:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(0.1)
end

function modifier_skeleton_king_reincarnation_custom_damage:OnIntervalThink()
if not IsServer() then return end
if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
    self:SetStackCount(0)
else 
    self:SetStackCount(1)
end

end

function modifier_skeleton_king_reincarnation_custom_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}

end

function modifier_skeleton_king_reincarnation_custom_damage:GetModifierTotalDamageOutgoing_Percentage()
if self:GetStackCount() == 1 then return end
return self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_2", "damage")
end


















modifier_skeleton_king_reincarnation_custom_aura = class({})

function modifier_skeleton_king_reincarnation_custom_aura:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_aura:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_aura:IsDebuff() return false end
function modifier_skeleton_king_reincarnation_custom_aura:GetTexture() return "buffs/reincarnation_aura" end
function modifier_skeleton_king_reincarnation_custom_aura:RemoveOnDeath() return false end



function modifier_skeleton_king_reincarnation_custom_aura:GetAuraRadius()
  return self.radius
end

function modifier_skeleton_king_reincarnation_custom_aura:GetAuraSearchTeam()
  return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skeleton_king_reincarnation_custom_aura:GetAuraSearchType() 
  return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end


function modifier_skeleton_king_reincarnation_custom_aura:GetModifierAura()
  return "modifier_skeleton_king_reincarnation_custom_aura_damage"
end

function modifier_skeleton_king_reincarnation_custom_aura:IsAura()
  return true
end

function modifier_skeleton_king_reincarnation_custom_aura:OnCreated()
self.radius = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_4", "radius", true)
self.interval = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_4", "interval", true)

if not IsServer() then return end 
self:StartIntervalThink(0.2)
end

function modifier_skeleton_king_reincarnation_custom_aura:OnIntervalThink()
if not IsServer() then return end 

if self:GetAbility():GetCooldownTimeRemaining() > 0 then 
    self:SetStackCount(-1)
else 
    self:SetStackCount(0)
end 


end 

function modifier_skeleton_king_reincarnation_custom_aura:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}
end 


function modifier_skeleton_king_reincarnation_custom_aura:GetModifierConstantHealthRegen()
if self:GetStackCount() == 0 then return end

return (self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())*self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_4", "heal")/100
end 

function modifier_skeleton_king_reincarnation_custom_aura:OnTooltip()
return  self:GetCaster():GetHealth()*self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_4", "damage")/100
end

modifier_skeleton_king_reincarnation_custom_aura_damage = class({})
function modifier_skeleton_king_reincarnation_custom_aura_damage:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_aura_damage:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_aura_damage:GetTexture() return "buffs/reincarnation_aura" end

function modifier_skeleton_king_reincarnation_custom_aura_damage:OnCreated(table)
if not IsServer() then return end

self.heal = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_4", "heal")/100
self.damage = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_4", "damage")/100
self.interval = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_4", "interval")
self.creeps = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_4", "creeps")

self:StartIntervalThink(self.interval)

end

function modifier_skeleton_king_reincarnation_custom_aura_damage:OnIntervalThink()
if not IsServer() then return end

local damage = (self:GetCaster():GetHealth())*self.interval*self.damage

if self:GetParent():IsCreep() then 
    damage = damage/self.creeps
end


local real_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE})

end




function modifier_skeleton_king_reincarnation_custom_aura_damage:GetEffectName()
  return "particles/wk_burn.vpcf"
end

function modifier_skeleton_king_reincarnation_custom_aura_damage:GetEffectAttachType()
  return PATTACH_ABSORIGIN_FOLLOW
end








skeleton_king_reincarnation_custom_legendary = class({})


function skeleton_king_reincarnation_custom_legendary:GetCooldown()
return self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_legendary", "cd")
end

function skeleton_king_reincarnation_custom_legendary:OnSpellStart()

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_skeleton_king_reincarnation_custom_legendary", {duration = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_legendary", "duration")})
end








modifier_skeleton_king_reincarnation_custom_legendary = class({})
function modifier_skeleton_king_reincarnation_custom_legendary:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_legendary:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_legendary:GetStatusEffectName()
    return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end
function modifier_skeleton_king_reincarnation_custom_legendary:StatusEffectPriority()
 return 99999 end

function modifier_skeleton_king_reincarnation_custom_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MODEL_SCALE,
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
   -- MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
}
end



function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierStatusResistanceStacking() 
    return self.status
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierIncomingDamage_Percentage()
return self.damage
end




function modifier_skeleton_king_reincarnation_custom_legendary:GetEffectName()
    return "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf"
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end



function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierModelScale()
return 30
end




function modifier_skeleton_king_reincarnation_custom_legendary:OnCreated(table)

self.move = self:GetAbility():GetSpecialValueFor("move")
self.status = self:GetAbility():GetSpecialValueFor("status")
self.damage = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_legendary", "damage_reduce")
self.radius = self:GetAbility():GetSpecialValueFor("radius")

if not IsServer() then return end
self.RemoveForDuel = true

self:GetCaster():EmitSound("WK.Ult_legendary_start")
end

function modifier_skeleton_king_reincarnation_custom_legendary:OnDestroy()
if not IsServer() then return end

self:GetCaster():EmitSound("Muerta.Calling_caster_end")

local particle = ParticleManager:CreateParticle( "particles/muerta/muerta_calling_caster_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
ParticleManager:ReleaseParticleIndex( particle )

end



function modifier_skeleton_king_reincarnation_custom_legendary:CheckState()
return
{
    [MODIFIER_STATE_MUTED] = true,
    [MODIFIER_STATE_SILENCED] = true,
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_UNSLOWABLE] = true,
}
end





function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraEntityReject(target)

end

function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraDuration()
    return 0
end


function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraRadius()
return self.radius
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_skeleton_king_reincarnation_custom_legendary:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end


function modifier_skeleton_king_reincarnation_custom_legendary:GetModifierAura()
    return "modifier_skeleton_king_reincarnation_custom_legendary_target"
end

function modifier_skeleton_king_reincarnation_custom_legendary:IsAura()
return true
end


modifier_skeleton_king_reincarnation_custom_legendary_target = class({})
function modifier_skeleton_king_reincarnation_custom_legendary_target:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_legendary_target:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_legendary_target:OnCreated()
if not self:GetCaster():HasModifier("modifier_skeleton_reincarnation_legendary") then return end

self.interval = 0.2

self.damage = self.interval*self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_legendary", "damage")/100
self.heal = self:GetAbility():GetSpecialValueFor("heal")/100

if self:GetParent():IsCreep() then 
    self.damage = self.damage/self:GetAbility():GetSpecialValueFor("creeps")
end

if not IsServer() then return end 

local caster = self:GetCaster()
local target = self:GetParent()

local mod = caster:FindModifierByName("modifier_skeleton_king_reincarnation_custom_legendary")
if not mod then return end 

local particle = ParticleManager:CreateParticle("particles/wraith_king/ult_legendary_damage.vpcf", PATTACH_CUSTOMORIGIN, caster)
ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
ParticleManager:SetParticleControl(particle, 5, Vector(mod:GetRemainingTime(), 0, 0))
self:AddParticle(particle, false, false, -1, false, false)    


self:StartIntervalThink(self.interval)
end


function modifier_skeleton_king_reincarnation_custom_legendary_target:OnIntervalThink()
if not IsServer() then return end 

local damage = self.damage*self:GetParent():GetMaxHealth()
local real_damage = ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_PURE})

self:GetCaster():GenericHeal(real_damage*self.heal, self:GetAbility(), true)
end 




modifier_skeleton_king_reincarnation_custom_slow_aura = class({})
function modifier_skeleton_king_reincarnation_custom_slow_aura:IsHidden() return false end
function modifier_skeleton_king_reincarnation_custom_slow_aura:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_slow_aura:GetTexture() return "buffs/reincarnation_shield" end


function modifier_skeleton_king_reincarnation_custom_slow_aura:OnCreated()

self.move = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_1", "slow")
self.attack = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_1", "attack")

end

function modifier_skeleton_king_reincarnation_custom_slow_aura:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}
end

function modifier_skeleton_king_reincarnation_custom_slow_aura:GetModifierAttackSpeedBonus_Constant()
return self.attack
end

function modifier_skeleton_king_reincarnation_custom_slow_aura:GetModifierMoveSpeedBonus_Percentage()
return self.move
end




modifier_skeleton_king_reincarnation_custom_str = class({})
function modifier_skeleton_king_reincarnation_custom_str:IsHidden() 
    if not self:GetParent():HasModifier("modifier_skeleton_reincarnation_6") or self:GetStackCount() < 1 then 
        return true
    end

    return false
end
function modifier_skeleton_king_reincarnation_custom_str:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_str:RemoveOnDeath() return false end
function modifier_skeleton_king_reincarnation_custom_str:GetTexture() return "buffs/reincarnation_active" end

function modifier_skeleton_king_reincarnation_custom_str:OnCreated()
self.max = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_6", "max", true)
self.str = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_6", "str", true)
self.cd = self:GetCaster():GetTalentValue("modifier_skeleton_reincarnation_6", "cd", true)

if not IsServer() then return end 


self:StartIntervalThink(0.5)
end 




function modifier_skeleton_king_reincarnation_custom_str:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_skeleton_reincarnation_6") then return end 

if self:GetStackCount() >= self.max then 

    self:GetParent():EmitSound("BS.Thirst_legendary_active")
    local particle_peffect = ParticleManager:CreateParticle("particles/brist_lowhp_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
    ParticleManager:SetParticleControl(particle_peffect, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, self:GetCaster():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_peffect)
    
    self:StartIntervalThink(-1)
end

end 




function modifier_skeleton_king_reincarnation_custom_str:OnRefresh(table)
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

self:GetParent():CalculateStatBonus(true)
end 


function modifier_skeleton_king_reincarnation_custom_str:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_skeleton_king_reincarnation_custom_str:GetModifierBonusStats_Strength()
if not self:GetParent():HasModifier("modifier_skeleton_reincarnation_6") then return end

return self.str*self:GetStackCount()
end

function modifier_skeleton_king_reincarnation_custom_str:OnTooltip()
if not self:GetParent():HasModifier("modifier_skeleton_reincarnation_6") then return end
if self:GetStackCount() < self.max then return end

return self.cd
end




modifier_skeleton_king_reincarnation_custom_invun = class({})
function modifier_skeleton_king_reincarnation_custom_invun:IsHidden() return true end
function modifier_skeleton_king_reincarnation_custom_invun:IsPurgable() return false end
function modifier_skeleton_king_reincarnation_custom_invun:CheckState()
return
{
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true
}
end