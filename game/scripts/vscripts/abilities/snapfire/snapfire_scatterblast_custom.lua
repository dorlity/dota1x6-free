LinkLuaModifier( "modifier_snapfire_scatterblast_custom_debuff", "abilities/snapfire/snapfire_scatterblast_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_scatterblast_custom_disarm", "abilities/snapfire/snapfire_scatterblast_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_scatterblast_custom_stack", "abilities/snapfire/snapfire_scatterblast_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_scatterblast_custom_disarm_cd", "abilities/snapfire/snapfire_scatterblast_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snapfire_scatterblast_custom_move", "abilities/snapfire/snapfire_scatterblast_custom", LUA_MODIFIER_MOTION_NONE )


snapfire_scatterblast_custom = class({})




snapfire_scatterblast_custom.cd_inc = {-2, -3, -4}

snapfire_scatterblast_custom.slow_inc = {0.4, 0.6, 0.8}
snapfire_scatterblast_custom.slow_damage = {-10, -15, -20}

snapfire_scatterblast_custom.damage_inc = {0.2, 0.3, 0.4}

snapfire_scatterblast_custom.close_heal = 0.15
snapfire_scatterblast_custom.close_move = 30
snapfire_scatterblast_custom.close_move_duration = 2

snapfire_scatterblast_custom.array = {}




function snapfire_scatterblast_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shells_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_pointblank_impact_sparks.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_impact.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_snapfire_slow.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf", context )
PrecacheResource( "particle", "particles/snapfire_scatter_stack.vpcf", context )

end




function snapfire_scatterblast_custom:OnAbilityPhaseStart()
    self:GetCaster():EmitSound("Hero_Snapfire.Shotgun.Load")
    return true
end

function snapfire_scatterblast_custom:OnAbilityPhaseInterrupted()
    self:GetCaster():StopSound("Hero_Snapfire.Shotgun.Load")
end


function snapfire_scatterblast_custom:GetCooldown(iLevel)


local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_snapfire_scatter_1") then 
    upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_snapfire_scatter_1")] 
end


 return (self.BaseClass.GetCooldown(self, iLevel) + upgrade_cooldown)

end





function snapfire_scatterblast_custom:GetCastPoint()

return self.BaseClass.GetCastPoint(self) - self:GetCaster():GetUpgradeStack("modifier_snapfire_scatterblast_custom_stack")*self:GetCaster():GetTalentValue("modifier_snapfire_scatter_4", "cast")
end


function snapfire_scatterblast_custom:OnSpellStart(new_point, forced_auto)
    if not IsServer() then return end
    local point = self:GetCursorPosition()

    if new_point then 
        point = new_point
    end

    if point == self:GetCaster():GetAbsOrigin() then
        point = point + self:GetCaster():GetForwardVector()
    end


    local auto = 0
    if forced_auto then 
        auto = 1
    end

    local distance = self:GetSpecialValueFor("distance")
    local blast_width_initial = self:GetSpecialValueFor( "blast_width_initial" )/2
    local blast_width_end = self:GetSpecialValueFor( "blast_width_end" )/2
    local blast_speed = self:GetSpecialValueFor( "blast_speed" )

    local direction = point-self:GetCaster():GetAbsOrigin()
    direction.z = 0
    direction = direction:Normalized()    

    local info = 
    {
        Source = self:GetCaster(),
        Ability = self,
        vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
        bDeleteOnHit = false,
        iUnitTargetTeam = self:GetAbilityTargetTeam(),
        iUnitTargetFlags = self:GetAbilityTargetFlags(),
        iUnitTargetType = self:GetAbilityTargetType(),
        EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun.vpcf",
        fDistance = distance,
        fStartRadius = blast_width_initial,
        fEndRadius =blast_width_end,
        vVelocity = direction * blast_speed,
        bProvidesVision = false,
        ExtraData = 
        {
            x = self:GetCaster():GetAbsOrigin().x,
            y = self:GetCaster():GetAbsOrigin().y,
            auto = auto,
        }
    }

    self.array[#self.array + 1] = 0
    

    local proj = ProjectileManager:CreateLinearProjectile(info)

    self:GetCaster():EmitSound("Hero_Snapfire.Shotgun.Fire")
end

function snapfire_scatterblast_custom:OnProjectileHit_ExtraData( target, location, extraData )
if not target then 

    local mod = self:GetCaster():FindModifierByName("modifier_snapfire_scatterblast_custom_stack")

    if mod and self.array[#self.array] ~= 2 and extraData.auto == 0 then 
        mod:DecrementStackCount()
        if mod:GetStackCount() <= 0 then 
            mod:Destroy()
        end
    end

    self.array[#self.array] = nil
    return 
end

    local point_blank_range = self:GetSpecialValueFor( "point_blank_range" )
    local point_blank_dmg_bonus_pct = self:GetSpecialValueFor( "point_blank_dmg_bonus_pct" )/100


    local damage = self:GetSpecialValueFor( "damage" )

    if self:GetCaster():HasModifier("modifier_snapfire_scatter_2") then 
        point_blank_dmg_bonus_pct = point_blank_dmg_bonus_pct + self.damage_inc[self:GetCaster():GetUpgradeStack("modifier_snapfire_scatter_2")]
    end

    local debuff_duration = self:GetSpecialValueFor( "debuff_duration" )

    if self:GetCaster():HasModifier("modifier_snapfire_scatter_3") then 
        debuff_duration = debuff_duration + self.slow_inc[self:GetCaster():GetUpgradeStack("modifier_snapfire_scatter_3")]
    end

    local origin = Vector( extraData.x, extraData.y, 0 )
    local length = (target:GetAbsOrigin()-origin):Length2D()


    if self:GetCaster():HasModifier("modifier_snapfire_scatterblast_custom_stack") then 
        damage = damage + (self:GetCaster():GetTalentValue("modifier_snapfire_scatter_4", "damage")/100) *self:GetCaster():GetUpgradeStack("modifier_snapfire_scatterblast_custom_stack")*self:GetCaster():GetIntellect()
    end

    if length <= point_blank_range then 

        if  self.array[#self.array] ~= 2 then 

            if self:GetCaster():HasModifier("modifier_snapfire_scatter_6") then 

                my_game:GenericHeal(self:GetCaster(), (self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth())*self.close_heal , self)

                self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_movespeed", 
                    {
                        duration = self.close_move_duration,
                        movespeed = self.close_move,
                        effect = "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
                    })
            end

            if self:GetCaster():HasModifier("modifier_snapfire_scatter_7") then 
                local cd = self:GetCooldownTimeRemaining()
                self:EndCooldown()
                self:StartCooldown(cd*(1 - self:GetCaster():GetTalentValue("modifier_snapfire_scatter_7", "cd")/100))
            end

            if self:GetCaster():HasModifier("modifier_snapfire_scatter_4") then 
                self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_snapfire_scatterblast_custom_stack" , {duration = self:GetCaster():GetTalentValue("modifier_snapfire_scatter_4", "duration")})
            end
        end

        self.array[#self.array] = 2


        if target:IsRealHero() and self:GetCaster():GetQuest() == "Snapfire.Quest_5" then 
            self:GetCaster():UpdateQuest(1)
        end

        damage = damage + (point_blank_dmg_bonus_pct * damage)

        local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_shells_impact.vpcf", PATTACH_POINT_FOLLOW, target )
        ParticleManager:SetParticleControlEnt( particle, 3, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
        ParticleManager:ReleaseParticleIndex( particle )

        local particle2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_pointblank_impact_sparks.vpcf", PATTACH_POINT_FOLLOW, target )
        ParticleManager:SetParticleControlEnt( particle2, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
        ParticleManager:ReleaseParticleIndex( particle2 )


        if self:GetCaster():HasModifier("modifier_snapfire_scatter_5") and not target:HasModifier("modifier_snapfire_scatterblast_custom_disarm_cd") then 

            local vec = (target:GetAbsOrigin() - self:GetCaster():GetAbsOrigin())

            local dir = vec:Normalized()

            local distance = self:GetCaster():GetTalentValue("modifier_snapfire_scatter_5", "range")
            local point = target:GetAbsOrigin() + dir*distance


            local dur = self:GetCaster():GetTalentValue("modifier_snapfire_scatter_5", "duration")
            local speed = distance/dur
            local height = 30

            target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = (1 - target:GetStatusResistance())*self:GetCaster():GetTalentValue("modifier_snapfire_scatter_5", "stun")})
             
            target:AddNewModifier(self:GetCaster(), self, "modifier_snapfire_scatterblast_custom_disarm_cd", {duration = self:GetCaster():GetTalentValue("modifier_snapfire_scatter_5", "cd")})

            if not target:IsCreep() then    
                local arc = target:AddNewModifier(self:GetCaster(), self, "modifier_generic_arc",
                {
                    target_x = point.x,
                    target_y = point.y,
                    distance = distance,
                    speed = speed,
                    height = height,
                    fix_end = false,
                    isStun = false,
                    activity = ACT_DOTA_FLAIL,

                })
            end
        end

    else 
        if  self.array[#self.array] == 0 then 
            self.array[#self.array] = 1
        end
    end

    ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = damage, damage_type = self:GetAbilityDamageType(), ability = self })
    target:AddNewModifier( self:GetCaster(), self, "modifier_snapfire_scatterblast_custom_debuff", { duration = debuff_duration*(1 - target:GetStatusResistance()) } )

    local particle3 = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
    ParticleManager:ReleaseParticleIndex( particle3 )

    target:EmitSound("Hero_Snapfire.Shotgun.Target")
end



modifier_snapfire_scatterblast_custom_debuff = class({})

function modifier_snapfire_scatterblast_custom_debuff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
    return funcs
end

function modifier_snapfire_scatterblast_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end
function modifier_snapfire_scatterblast_custom_debuff:GetModifierAttackSpeedBonus_Constant()
    return -1*self:GetAbility():GetSpecialValueFor( "attack_slow_pct" )
end


function modifier_snapfire_scatterblast_custom_debuff:GetModifierTotalDamageOutgoing_Percentage()
if not self:GetCaster():HasModifier("modifier_snapfire_scatter_3") then return end 
    return self:GetAbility().slow_damage[self:GetCaster():GetUpgradeStack("modifier_snapfire_scatter_3")]
end



function modifier_snapfire_scatterblast_custom_debuff:GetEffectName()
    return "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun_debuff.vpcf"
end

function modifier_snapfire_scatterblast_custom_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_snapfire_scatterblast_custom_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_snapfire_slow.vpcf"
end

function modifier_snapfire_scatterblast_custom_debuff:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end





modifier_snapfire_scatterblast_custom_disarm = class({})
function modifier_snapfire_scatterblast_custom_disarm:IsHidden() return true end
function modifier_snapfire_scatterblast_custom_disarm:IsPurgable() return true end

function modifier_snapfire_scatterblast_custom_disarm:GetEffectName()
  return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff.vpcf"
end

function modifier_snapfire_scatterblast_custom_disarm:GetEffectAttachType()
  return PATTACH_OVERHEAD_FOLLOW
end

function modifier_snapfire_scatterblast_custom_disarm:CheckState()
  return {[MODIFIER_STATE_DISARMED] = true}
end


modifier_snapfire_scatterblast_custom_stack = class({})
function modifier_snapfire_scatterblast_custom_stack:IsHidden() return false end
function modifier_snapfire_scatterblast_custom_stack:IsPurgable() return false end


function modifier_snapfire_scatterblast_custom_stack:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_snapfire_scatter_4", "damage")/100
self.max = self:GetCaster():GetTalentValue("modifier_snapfire_scatter_4", "max")

if not IsServer() then return end
self.RemoveForDuel = true

self:SetStackCount(1)

end



function modifier_snapfire_scatterblast_custom_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

end



function modifier_snapfire_scatterblast_custom_stack:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_snapfire_scatterblast_custom_stack:OnTooltip()
    return self.damage*self:GetStackCount()*self:GetCaster():GetIntellect()
end


function modifier_snapfire_scatterblast_custom_stack:OnStackCountChanged(iStackCount)
if not IsServer() then return end
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

  local particle_cast = "particles/snapfire_scatter_stack.vpcf"

  self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

  self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end
     






modifier_snapfire_scatterblast_custom_disarm_cd = class({})
function modifier_snapfire_scatterblast_custom_disarm_cd:IsHidden() return true end
function modifier_snapfire_scatterblast_custom_disarm_cd:IsPurgable() return false end



