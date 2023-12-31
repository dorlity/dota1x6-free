LinkLuaModifier( "modifier_custom_pudge_meat_hook", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_debuff", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_HORIZONTAL  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_streak", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_streak_check", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_blood", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_root", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_attacks", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_speed", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_damage", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_tracker", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_legendary", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_move", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_incoming", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )
LinkLuaModifier( "modifier_custom_pudge_meat_hook_stack", "abilities/pudge/custom_pudge_meat_hook", LUA_MODIFIER_MOTION_NONE  )


custom_pudge_meat_hook = class({})

custom_pudge_meat_hook.hooks = {}



custom_pudge_meat_hook.range_bonus = 300
custom_pudge_meat_hook.range_speed = 0.2
custom_pudge_meat_hook.range_radius = 2000
custom_pudge_meat_hook.range_health = 50





custom_pudge_meat_hook.reduce_duration = 1.5
custom_pudge_meat_hook.reduce_cast = 0.15
custom_pudge_meat_hook.reduce_mana = 70





function custom_pudge_meat_hook:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasModifier("modifier_pudge_hook_2") then 
    bonus = self:GetCaster():GetTalentValue("modifier_pudge_hook_2", "cd")
end

    return self.BaseClass.GetCooldown( self, level ) + bonus
end





function custom_pudge_meat_hook:GetCastPoint(iLevel)
if self:GetCaster():HasModifier('modifier_pudge_hook_6') then 
    return self.BaseClass.GetCastPoint(self) - self.reduce_cast
end

return self.BaseClass.GetCastPoint(self)
end



function custom_pudge_meat_hook:Precache(context)

    
PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_meathook.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/pudge/pudge_arcana/pudge_arcana_hook_streak.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", context )
PrecacheResource( "particle", "particles/items3_fx/hook_root.vpcf", context )
PrecacheResource( "particle", "particles/pudge/hook_stack.vpcf", context )

end





function custom_pudge_meat_hook:GetIntrinsicModifierName()
return "modifier_custom_pudge_meat_hook_tracker"
end


function custom_pudge_meat_hook:GetManaCost(level)

if self:GetCaster():HasModifier("modifier_pudge_hook_6") then  
  return self.reduce_mana
end

return self.BaseClass.GetManaCost(self,level) 
end



function custom_pudge_meat_hook:GetCastRange(location, target)
local bonus = 0

if self:GetCaster():HasModifier("modifier_pudge_hook_5") then 
    bonus = self.range_bonus
end

    return self.BaseClass.GetCastRange(self, location, target) + bonus
end



function custom_pudge_meat_hook:OnAbilityPhaseStart()
    self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
    return true
end

function custom_pudge_meat_hook:OnAbilityPhaseInterrupted()
    self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
end

function custom_pudge_meat_hook:OnSpellStart()
    for id, hook in pairs(self.hooks) do
        if hook ~= nil then

            if self.hooks[id].hVictim and not self.hooks[id].hVictim:IsNull() then
                

                self.hooks[id].hVictim:RemoveModifierByName("modifier_custom_pudge_meat_hook_debuff")
            
                if self.hooks[id].hVictim and self.hooks[id].hVictim:GetUnitName() == "npc_dota_companion" then 
                    UTIL_Remove(self.hooks[id].hVictim)
                end

                 if self.hooks[id].thinker then 
                    UTIL_Remove(self.hooks[id].thinker)
                end
            end
            ProjectileManager:DestroyLinearProjectile(id)
        end
    end

    self.hooks = {}



    local caster_position = self:GetCaster():GetOrigin()

    local point = self:GetCursorPosition()
    if point == caster_position then 
        point = point + self:GetCaster():GetForwardVector()*5
    end

    local direction = CalculateDirection(point, caster_position)

    local distance = (point - self:GetCaster():GetAbsOrigin()):Length2D()

    self:UseHook(direction, distance)

    if self:GetCaster() and self:GetCaster():IsHero() then
        local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
        if hHook ~= nil then
            hHook:AddEffects( EF_NODRAW )
        end
    end

    if self:GetCaster():HasModifier("modifier_pudge_hook_legendary") then    -- Тестовый талант на несколько хуков
        local angle = self:GetCaster():GetTalentValue("modifier_pudge_hook_legendary", "angle")
        local hook_count = self:GetCaster():GetTalentValue("modifier_pudge_hook_legendary", "count")
        for i = 1, hook_count do
            local newAngle = angle * math.ceil(i / 2) * (-1)^i
            local newDir = RotateVector2D( direction, ToRadians( newAngle ) )
            self:UseHook( newDir, distance )
        end
    end
end

------------------------ Функции


function RotateVector2D(vector, theta)
    local xp = vector.x*math.cos(theta)-vector.y*math.sin(theta)
    local yp = vector.x*math.sin(theta)+vector.y*math.cos(theta)
    return Vector(xp,yp,vector.z):Normalized()
end

function ToRadians(degrees)
    return degrees * math.pi / 180
end

function CalculateDirection(ent1, ent2)
    local pos1 = ent1
    local pos2 = ent2
    if ent1.GetAbsOrigin then pos1 = ent1:GetAbsOrigin() end
    if ent2.GetAbsOrigin then pos2 = ent2:GetAbsOrigin() end
    local direction = (pos1 - pos2)
    direction.z = 0
    return direction:Normalized()
end

------------------------------------

function custom_pudge_meat_hook:UseHook( direction, distance )
    self.hook_damage = self:GetSpecialValueFor( "damage" )
    self.hook_speed = self:GetSpecialValueFor( "hook_speed" )
    self.hook_width = self:GetSpecialValueFor( "hook_width" )
    self.hook_distance = self:GetSpecialValueFor( "hook_distance" ) + self:GetCaster():GetCastRangeBonus()

    self.hook_followthrough_constant = 0.65
    self.vision_radius = self:GetSpecialValueFor( "vision_radius" )  
    self.vision_duration = self:GetSpecialValueFor( "vision_duration" )  

    local mod = self:GetCaster():FindModifierByName("modifier_custom_pudge_meat_hook_legendary")

    if mod and self:GetCaster():HasModifier("modifier_pudge_hook_4") then 
        self.hook_damage = self.hook_damage + self:GetCaster():GetTalentValue("modifier_pudge_hook_4", "damage")*mod:GetStackCount()
    end


    if self:GetCaster():HasModifier("modifier_pudge_hook_5") then 
        self.hook_speed = self.hook_speed*(1 + self.range_speed)
        self.hook_distance =  self.hook_distance + self.range_bonus
    end


    local caster_location = self:GetCaster():GetOrigin()
    local flFollowthroughDuration = ( self.hook_distance / self.hook_speed ) * self.hook_followthrough_constant 

    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_custom_pudge_meat_hook", { duration = flFollowthroughDuration } )

    self.vHookOffset = Vector( 0, 0, 96 )
    local vHookTarget = (caster_location + (direction * self.hook_distance)) + self.vHookOffset
    local vKillswitch = Vector( ( ( self.hook_distance / self.hook_speed ) * 2 ), 0, 0 )

    local hook_particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleAlwaysSimulate( hook_particle )

    ParticleManager:SetParticleControlEnt( hook_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetOrigin() + self.vHookOffset, true )
    ParticleManager:SetParticleControl( hook_particle, 1, vHookTarget )
    ParticleManager:SetParticleControl( hook_particle, 2, Vector( self.hook_speed, self.hook_distance, self.hook_width ) )
    ParticleManager:SetParticleControl( hook_particle, 3, vKillswitch )
    ParticleManager:SetParticleControl( hook_particle, 4, Vector( 1, 0, 0 ) )
    ParticleManager:SetParticleControl( hook_particle, 5, Vector( 0, 0, 0 ) )
    ParticleManager:SetParticleControlEnt( hook_particle, 7, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetOrigin(), true )


    --ParticleManager:SetParticleShouldCheckFoW( hook_particle, false )
    local thinker = CreateModifierThinker(
        self:GetCaster(),
        self,
        "modifier_invulnerable",
        {},
        self:GetCaster():GetOrigin(),
        self:GetCaster():GetTeamNumber(),
        false
    )



    local info = {
        Ability = self,
        vSpawnOrigin = self:GetCaster():GetOrigin(),
        vVelocity = direction * self.hook_speed,
        fDistance = self.hook_distance,
        fStartRadius = self.hook_width ,
        fEndRadius = self.hook_width ,
        Source = self:GetCaster(),
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
          iVisionRadius = 300,--
          iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
          bProvidesVision = true,

    }

    local projectileIndex = ProjectileManager:CreateLinearProjectile( info )

    self.hooks[projectileIndex] = {}
    self.hooks[projectileIndex].particleIndex = hook_particle
    self.hooks[projectileIndex].hook_speed = self.hook_speed
    self.hooks[projectileIndex].hook_width = self.hook_width
    self.hooks[projectileIndex].bRetracting = false
    self.hooks[projectileIndex].hVictim = nil
    self.hooks[projectileIndex].bDiedInHook = false
    self.hooks[projectileIndex].direction = caster_location * (direction * self.hook_distance)
    self.hooks[projectileIndex].start_position = caster_location
    self.hooks[projectileIndex].proj_location = nil
    self.hooks[projectileIndex].thinker = thinker
    EmitSoundOn("Hero_Pudge.AttackHookExtend", self.hooks[projectileIndex].thinker)
end


function custom_pudge_meat_hook:OnProjectileHitHandle( target, position, projectileIndex )
if not IsServer() then return end

    local caster = self:GetCaster()

    if target == caster then return false end


    if not self.hooks[projectileIndex].thinker or  self.hooks[projectileIndex].thinker:IsNull() then return end

    if self.hooks[projectileIndex] == nil then return true end


    if self.hooks[projectileIndex].bRetracting == false then
        if target ~= nil and ( not ( target:IsCreep() or target:IsConsideredHero() ) ) then
            return false
        end

        local bTargetPulled = false
        if target ~= nil then

            if target:HasModifier("modifier_custom_pudge_meat_hook_debuff") or  target:GetUnitName() == "npc_teleport" 
               or target:GetUnitName() == "npc_psi_blades_crystal" or target:GetUnitName() == "npc_psi_blades_crystal_mini" then 
                return false
            end
        

            if self:GetCaster():HasModifier("modifier_custom_pudge_meat_hook_streak_check") then 
                local mod = self:GetCaster():FindModifierByName("modifier_custom_pudge_meat_hook_streak_check")
                if target:IsRealHero() then 

                    local mod_stack = self:GetCaster():FindModifierByName("modifier_custom_pudge_meat_hook_streak")
                    local streak = 1
                    local max = 0

                    if mod_stack then 
                        streak = mod_stack:GetStackCount() + 1
                        if mod_stack:GetStackCount() == self.legendary_max then 
                            max = 6
                            streak = self.legendary_max
                        end
                    end


                    local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/pudge/pudge_arcana/pudge_arcana_hook_streak.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
                    ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
                    ParticleManager:SetParticleControl( nFXIndex, 2, Vector(0,streak,max) )
                    ParticleManager:ReleaseParticleIndex(nFXIndex)

                    mod.hit_hero = true 
                end
                if target:IsIllusion() or target:IsCreep() then 
                    mod.hit_creep = true
                end

            end

            self.hooks[projectileIndex].thinker:StopSound("Hero_Pudge.AttackHookExtend")

            if self:GetCaster():HasModifier("modifier_custom_pudge_meat_hook") then 
                self:GetCaster():RemoveModifierByName("modifier_custom_pudge_meat_hook")
            end

            target:EmitSound("Hero_Pudge.AttackHookImpact")


            local mod = target:FindModifierByName("modifier_backdoor_knock_aura_damage")


            if not target:HasModifier("modifier_waveupgrade_boss") and (not mod or not mod.target or mod.target == self:GetCaster()) then 

                target:AddNewModifier( self:GetCaster(), self, "modifier_custom_pudge_meat_hook_debuff", {} )
            end

            if target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then

                local damage = self.hook_damage

                local stack_mod = target:FindModifierByName("modifier_custom_pudge_meat_hook_stack")

                if stack_mod then 
                    damage = damage*(1 + stack_mod:GetStackCount()*self:GetCaster():GetTalentValue("modifier_pudge_hook_legendary", "damage")/100)
                end 

                local damage_table = {  victim = target, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self }

                if self:GetCaster():GetQuest() == "Pudge.Quest_5" and target:IsRealHero() and (self:GetCaster():GetAbsOrigin() - target:GetAbsOrigin()):Length2D() >= self:GetCaster().quest.number then 
                    self:GetCaster():UpdateQuest(1)
                end

                if target:IsValidKill(self:GetCaster()) then 
                    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_meat_hook_legendary", {})
                end

                if self:GetCaster():HasModifier("modifier_pudge_hook_1") then 
                    target:AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_meat_hook_incoming", {duration = self:GetCaster():GetTalentValue("modifier_pudge_hook_1", "duration")})
                end 

                ApplyDamage( damage_table )


                if self:GetCaster():HasModifier("modifier_pudge_hook_legendary") then 
                    target:AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_meat_hook_stack", {duration = self:GetCaster():GetTalentValue("modifier_pudge_hook_legendary", "duration")})
                end 


                if self:GetCaster():HasModifier("modifier_pudge_hook_2") then 
                    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_meat_hook_speed", {duration = self:GetCaster():GetTalentValue("modifier_pudge_hook_2", "duration")})
                end

                if self:GetCaster():HasModifier("modifier_pudge_hook_3") then 
                    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_custom_pudge_meat_hook_blood", {duration = self:GetCaster():GetTalentValue("modifier_pudge_hook_3", "duration")})
                end

                if not target:IsAlive() 
                 then self.hooks[projectileIndex].bDiedInHook = true end

                if not target:IsMagicImmune() then target:Interrupt() end

                local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, target )
                ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
                ParticleManager:ReleaseParticleIndex( nFXIndex )
            end
            AddFOWViewer( self:GetCaster():GetTeamNumber(), target:GetOrigin(), self.vision_radius, self.vision_duration, false )

            if not target:HasModifier("modifier_waveupgrade_boss") and (not mod or not mod.target or mod.target == self:GetCaster()) then 
                self.hooks[projectileIndex].hVictim = target
                bTargetPulled = true
            end
        end



        if self.hooks[projectileIndex].hVictim == nil then
            local dummy = CreateUnitByName("npc_dota_companion", position, false, nil, nil, self:GetCaster():GetTeamNumber())
            dummy:AddNewModifier(self, nil, "modifier_phased", {})
            dummy:AddNewModifier(self, nil, "modifier_no_healthbar", {})
            dummy:AddNewModifier(self, nil, "modifier_invulnerable", {})
            self.hooks[projectileIndex].hVictim = dummy
            target = dummy
        end

        local vHookPos = self.hooks[projectileIndex].direction
        local flPad = self:GetCaster():GetPaddedCollisionRadius()

        if target ~= nil then
            vHookPos = target:GetOrigin()
            flPad = flPad + target:GetPaddedCollisionRadius()
        end

        local vVelocity = self.hooks[projectileIndex].start_position - vHookPos
        vVelocity.z = 0.0

        local flDistance = vVelocity:Length2D() - flPad
        vVelocity = vVelocity:Normalized() * self.hook_speed

        --self.vProjectileLocation = vHookPos

        if bTargetPulled then

            ParticleManager:SetParticleControlEnt( self.hooks[projectileIndex].particleIndex, 0, self:GetCaster(), PATTACH_ABSORIGIN, "attach_weapon_chain_rt", self.hooks[projectileIndex].start_position + self.vHookOffset, true )
            ParticleManager:SetParticleControl( self.hooks[projectileIndex].particleIndex, 0, self.hooks[projectileIndex].start_position + self.vHookOffset )

            ParticleManager:SetParticleControlEnt( self.hooks[projectileIndex].particleIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin() + self.vHookOffset, true )
            ParticleManager:SetParticleControl( self.hooks[projectileIndex].particleIndex, 4, Vector( 0, 0, 0 ) )
            ParticleManager:SetParticleControl( self.hooks[projectileIndex].particleIndex, 5, Vector( 1, 0, 0 ) )
        else
            ParticleManager:SetParticleControlEnt( self.hooks[projectileIndex].particleIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetOrigin() + self.vHookOffset, true);
        end


        EmitSoundOn("Hero_Pudge.AttackHookRetract",  self.hooks[projectileIndex].thinker)
     

        if self:GetCaster():IsAlive() then
            self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
            self:GetCaster():StartGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
        end

        self.hooks[projectileIndex].bRetracting = true

        local info = {
            Ability = self,
            vSpawnOrigin = vHookPos,
            vVelocity = vVelocity,
            fDistance = flDistance,
            Source = self:GetCaster(),
        }

        local back_proj = ProjectileManager:CreateLinearProjectile( info )

        self.hooks[back_proj] = {}

        self.hooks[back_proj].hook_speed = self.hooks[projectileIndex].hook_speed
        self.hooks[back_proj].hook_width = self.hooks[projectileIndex].hook_width
        self.hooks[back_proj].particleIndex = self.hooks[projectileIndex].particleIndex
        self.hooks[back_proj].bRetracting =  self.hooks[projectileIndex].bRetracting
        self.hooks[back_proj].hVictim = self.hooks[projectileIndex].hVictim
        self.hooks[back_proj].bDiedInHook = self.hooks[projectileIndex].bDiedInHook
        self.hooks[back_proj].direction = self.hooks[projectileIndex].direction
        self.hooks[back_proj].start_position = self.hooks[projectileIndex].start_position
        self.hooks[back_proj].thinker = self.hooks[projectileIndex].thinker 
        self.hooks[back_proj].proj_location = position

        self.hooks[projectileIndex] = nil
    else


        if self:GetCaster() and self:GetCaster():IsHero() then
            local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
            if hHook ~= nil then
                hHook:RemoveEffects( EF_NODRAW )
            end
        end

        if self.hooks[projectileIndex].hVictim ~= nil and not self.hooks[projectileIndex].hVictim:IsNull() then

            local vFinalHookPos = position
            self.hooks[projectileIndex].hVictim:InterruptMotionControllers( true )
            
            self.hooks[projectileIndex].thinker:StopSound("Hero_Pudge.AttackHookRetract")

            self.hooks[projectileIndex].hVictim:RemoveModifierByName( "modifier_custom_pudge_meat_hook_debuff" )

            local vVictimPosCheck = self.hooks[projectileIndex].hVictim:GetOrigin() - vFinalHookPos 
            local flPad = self:GetCaster():GetPaddedCollisionRadius() + self.hooks[projectileIndex].hVictim:GetPaddedCollisionRadius()
            if vVictimPosCheck:Length2D() > flPad then
                local check_dir = (self.hooks[projectileIndex].start_position - self.hooks[projectileIndex].hVictim:GetAbsOrigin()):Normalized()
                local origin = self.hooks[projectileIndex].start_position + (check_dir * 75)
                origin.z = 0
                FindClearSpaceForUnit( self.hooks[projectileIndex].hVictim, origin, false )

             


                local angel =(self.hooks[projectileIndex].start_position - self.hooks[projectileIndex].hVictim:GetAbsOrigin())
                angel.z = 0.0
                angel = angel:Normalized()
                self.hooks[projectileIndex].hVictim:SetForwardVector(angel)
            end
        end

        if not self.hooks[projectileIndex].hVictim:IsNull() and self.hooks[projectileIndex].hVictim:GetUnitName() == "npc_dota_companion" then 
            UTIL_Remove(self.hooks[projectileIndex].hVictim)
        end


        self.hooks[projectileIndex].thinker:StopSound("Hero_Pudge.AttackHookRetract")
        self.hooks[projectileIndex].thinker:StopSound("Hero_Pudge.AttackHookExtend")
        UTIL_Remove(self.hooks[projectileIndex].thinker)

        self.hooks[projectileIndex].hVictim = nil


        ParticleManager:DestroyParticle( self.hooks[projectileIndex].particleIndex, true )
        EmitSoundOn("Hero_Pudge.AttackHookRetractStop", self:GetCaster())

        if self:GetCaster():HasModifier("modifier_custom_pudge_meat_hook_streak_check") then

            self:GetCaster():FindModifierByName("modifier_custom_pudge_meat_hook_streak_check"):DecrementStackCount()
            if self:GetCaster():FindModifierByName("modifier_custom_pudge_meat_hook_streak_check"):GetStackCount() == 0 then 
                self:GetCaster():RemoveModifierByName("modifier_custom_pudge_meat_hook_streak_check")
            end
        end


    end

    return true
end


function custom_pudge_meat_hook:OnProjectileThinkHandle( projectileIndex )
if not IsServer() then return end
    if self.hooks[projectileIndex] then

        if not self.hooks[projectileIndex].thinker or self.hooks[projectileIndex].thinker:IsNull() then return end

        local position = ProjectileManager:GetLinearProjectileLocation( projectileIndex )

        self.hooks[projectileIndex].thinker:SetAbsOrigin(position)

        if self.hooks[projectileIndex].bRetracting then
            local caster = self:GetCaster()
            local speed = self.hooks[projectileIndex].hook_speed or 0
            local width = self.hooks[projectileIndex].hook_width or 0
            local position = ProjectileManager:GetLinearProjectileLocation( projectileIndex )

            self.hooks[projectileIndex].thinker:SetAbsOrigin(position)

            if self.hooks[projectileIndex].hVictim then
                if not self.hooks[projectileIndex].hVictim:HasModifier("modifier_custom_pudge_meat_hook_debuff") then
                    self.hooks[projectileIndex].hVictim:AddNewModifier( self:GetCaster(), self, "modifier_custom_pudge_meat_hook_debuff", {} )
                end


                local check_dir_2 = (self.hooks[projectileIndex].start_position - self.hooks[projectileIndex].hVictim:GetAbsOrigin()):Normalized()

                self.hooks[projectileIndex].hVictim:SetOrigin(GetGroundPosition(position, self.hooks[projectileIndex].hVictim))
                self.hooks[projectileIndex].hVictim:SetForwardVector(check_dir_2)


                local vFinalHookPos = self.hooks[projectileIndex].start_position 

                local vVictimPosCheck = vFinalHookPos - self.hooks[projectileIndex].hVictim:GetOrigin() 
                local flPad = self:GetCaster():GetPaddedCollisionRadius() + self.hooks[projectileIndex].hVictim:GetPaddedCollisionRadius()
                if vVictimPosCheck:Length2D() < flPad then

                    local check_dir = (self.hooks[projectileIndex].start_position - self.hooks[projectileIndex].hVictim:GetAbsOrigin()):Normalized()


                    local origin = self.hooks[projectileIndex].start_position + (check_dir * 150)
                    origin.z = 0

                    FindClearSpaceForUnit( self.hooks[projectileIndex].hVictim, origin, false )

                    local angel = (self.hooks[projectileIndex].start_position - self.hooks[projectileIndex].hVictim:GetAbsOrigin())
                    angel.z = 0.0
                    angel = angel:Normalized()
                    self.hooks[projectileIndex].hVictim:SetForwardVector(angel)




                    self.hooks[projectileIndex].hVictim:InterruptMotionControllers( true )
                    self.hooks[projectileIndex].hVictim:RemoveModifierByName( "modifier_custom_pudge_meat_hook_debuff" )
                    if self.hooks[projectileIndex].hVictim:GetUnitName() == "npc_dota_companion" then
                        UTIL_Remove(self.hooks[projectileIndex].hVictim)
                    end
                end
            end
            ParticleManager:SetParticleControl(self.hooks[projectileIndex].particleIndex, 1, self:GetCaster():GetAbsOrigin())
        end
    end
end

function custom_pudge_meat_hook:OnOwnerDied()
    self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
    self:GetCaster():RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
end

modifier_custom_pudge_meat_hook = class({})

function modifier_custom_pudge_meat_hook:IsHidden()
    return true
end

function modifier_custom_pudge_meat_hook:IsPurgable()
    return false
end

function modifier_custom_pudge_meat_hook:CheckState()
    local state = {
    [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end

modifier_custom_pudge_meat_hook_debuff = class({})

function modifier_custom_pudge_meat_hook_debuff:IsDebuff()
    return true
end

function modifier_custom_pudge_meat_hook_debuff:IsHidden() return true end

function modifier_custom_pudge_meat_hook_debuff:RemoveOnDeath()
    return false
end

function modifier_custom_pudge_meat_hook_debuff:OnDestroy()
if not IsServer() then return end

    FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)

    local angel = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin())
    angel.z = 0.0
    angel = angel:Normalized()
    self:GetParent():SetForwardVector(angel)

    if self:GetParent():GetUnitName() ~= "npc_dota_companion" and self:GetCaster():HasModifier("modifier_pudge_hook_6") then 
        self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_custom_pudge_meat_hook_root", {duration = (1 - self:GetParent():GetStatusResistance())*self:GetAbility().reduce_duration})
    end


    self:GetParent():RemoveModifierByName("modifier_custom_pudge_meat_hook_attacks")


end


function modifier_custom_pudge_meat_hook_debuff:OnCreated(table)
if not IsServer() then return end

end


function modifier_custom_pudge_meat_hook_debuff:IsPurgable()
    return false
end

function modifier_custom_pudge_meat_hook_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
    }

    return funcs
end

function modifier_custom_pudge_meat_hook_debuff:GetOverrideAnimation( params )
    return ACT_DOTA_FLAIL
end

function modifier_custom_pudge_meat_hook_debuff:CheckState()
    --if IsServer() then
        if self:GetCaster() ~= nil and self:GetParent() ~= nil then
            if self:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() and ( not self:GetParent():IsMagicImmune() ) then
                local state = {
                [MODIFIER_STATE_STUNNED] = true,
                }

                return state
            end
        end
    --end

    local state = {}

    return state
end




modifier_custom_pudge_meat_hook_speed = class({})
function modifier_custom_pudge_meat_hook_speed:IsHidden() return false end
function modifier_custom_pudge_meat_hook_speed:IsPurgable() return false end
function modifier_custom_pudge_meat_hook_speed:GetTexture() return "buffs/hook_speed" end
function modifier_custom_pudge_meat_hook_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_custom_pudge_meat_hook_speed:GetModifierAttackSpeedBonus_Constant()
return self.speed
end




function modifier_custom_pudge_meat_hook_speed:OnCreated()
self.speed = self:GetCaster():GetTalentValue("modifier_pudge_hook_2", "speed")
end 






modifier_custom_pudge_meat_hook_streak = class({})
function modifier_custom_pudge_meat_hook_streak:IsHidden() return false end
function modifier_custom_pudge_meat_hook_streak:IsPurgable() return false end
function modifier_custom_pudge_meat_hook_streak:RemoveOnDeath() return false end

function modifier_custom_pudge_meat_hook_streak:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_custom_pudge_meat_hook_streak:OnTooltip()
return 100*self:GetStackCount()*self:GetAbility().legendary_damage
end


modifier_custom_pudge_meat_hook_streak_check = class({})
function modifier_custom_pudge_meat_hook_streak_check:IsHidden() return true end
function modifier_custom_pudge_meat_hook_streak_check:IsPurgable() return false end

function modifier_custom_pudge_meat_hook_streak_check:OnCreated(table)
if not IsServer() then return end
self.hit_hero = false
self.hit_creep = false

end

function modifier_custom_pudge_meat_hook_streak_check:OnDestroy()
if not IsServer() then return end
local mod = self:GetParent():FindModifierByName("modifier_custom_pudge_meat_hook_streak")


if mod and self.hit_hero == false and self.hit_creep == false then 
    mod:Destroy()
    return
end

if not mod and self.hit_hero == true then 
    mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_pudge_meat_hook_streak", {})
end

if self.hit_hero == true and mod:GetStackCount() < self:GetAbility().legendary_max then 
    mod:IncrementStackCount()
end

end


modifier_custom_pudge_meat_hook_blood = class({})
function modifier_custom_pudge_meat_hook_blood:IsHidden() return false end
function modifier_custom_pudge_meat_hook_blood:IsPurgable() return true end
function modifier_custom_pudge_meat_hook_blood:GetTexture() return "buffs/Crit_blood" end

function modifier_custom_pudge_meat_hook_blood:OnCreated(table)
self.heal = self:GetCaster():GetTalentValue("modifier_pudge_hook_3", "heal")/self:GetRemainingTime()
if not IsServer() then return end

self:StartIntervalThink(1)
end

function modifier_custom_pudge_meat_hook_blood:OnIntervalThink()
if not IsServer() then return end
local particle = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
ParticleManager:ReleaseParticleIndex( particle )
SendOverheadEventMessage(self:GetParent(), 10, self:GetParent(), self.heal*self:GetParent():GetMaxHealth()/100, nil)
end


function modifier_custom_pudge_meat_hook_blood:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
}
end
function modifier_custom_pudge_meat_hook_blood:GetModifierHealthRegenPercentage()
return self.heal
end



modifier_custom_pudge_meat_hook_root = class({})
function modifier_custom_pudge_meat_hook_root:IsHidden() return false end
function modifier_custom_pudge_meat_hook_root:IsPurgable() return true end
function modifier_custom_pudge_meat_hook_root:GetTexture() return "buffs/hook_root" end


function modifier_custom_pudge_meat_hook_root:CheckState()
return
{
    [MODIFIER_STATE_ROOTED] = true
}
end



function modifier_custom_pudge_meat_hook_root:OnCreated(table)
if not IsServer() then return end
self:GetParent():EmitSound("Pudge.Hook_Root")

local parent = self:GetParent()

self.nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/hook_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
ParticleManager:SetParticleControl( self.nFXIndex, 0, parent:GetAbsOrigin() )
self:AddParticle(self.nFXIndex, false, false, -1, false, false)

end







modifier_custom_pudge_meat_hook_tracker = class({})
function modifier_custom_pudge_meat_hook_tracker:IsHidden() return true end
function modifier_custom_pudge_meat_hook_tracker:IsPurgable() return false end
function modifier_custom_pudge_meat_hook_tracker:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED,
}
end




function modifier_custom_pudge_meat_hook_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not self:GetParent():HasModifier("modifier_pudge_hook_legendary") then return end
if not params.target:IsCreep() and not params.target:IsHero() then return end

self:GetCaster():CdAbility(self:GetAbility(), self:GetCaster():GetTalentValue("modifier_pudge_hook_legendary", "cd"))
end

function modifier_custom_pudge_meat_hook_tracker:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.2)
end


function modifier_custom_pudge_meat_hook_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():HasModifier("modifier_pudge_hook_5") then return end

local nearby_enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility().range_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)

for _,enemy in pairs(nearby_enemies) do
    if enemy:IsRealHero() and enemy:GetHealthPercent() < self:GetAbility().range_health then 
        AddFOWViewer(self:GetParent():GetTeamNumber(), enemy:GetAbsOrigin(), 10, 0.2, false)
    end
end

end









modifier_custom_pudge_meat_hook_legendary = class({})
function modifier_custom_pudge_meat_hook_legendary:IsHidden() return not self:GetCaster():HasModifier("modifier_pudge_hook_4") end
function modifier_custom_pudge_meat_hook_legendary:IsPurgable() return false end
function modifier_custom_pudge_meat_hook_legendary:RemoveOnDeath() return false end
function modifier_custom_pudge_meat_hook_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_TOOLTIP,
  MODIFIER_PROPERTY_TOOLTIP2
}
end

function modifier_custom_pudge_meat_hook_legendary:OnTooltip2()
return self:GetStackCount()*self:GetCaster():GetTalentValue("modifier_pudge_hook_4", "damage")
end


function modifier_custom_pudge_meat_hook_legendary:OnTooltip()
return self:GetStackCount()
end


function modifier_custom_pudge_meat_hook_legendary:GetModifierSpellAmplify_Percentage() 
if not self:GetParent():HasModifier("modifier_pudge_hook_4") then return 0 end 
if self:GetStackCount() < self.max then return end

    return self:GetCaster():GetTalentValue("modifier_pudge_hook_4", "amp")
end


function modifier_custom_pudge_meat_hook_legendary:OnCreated(table)

self.max = self:GetCaster():GetTalentValue("modifier_pudge_hook_4", "max", true)

if not IsServer() then return end 


self:SetStackCount(1)
end




function modifier_custom_pudge_meat_hook_legendary:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 

    local particle_peffect = ParticleManager:CreateParticle("particles/lc_odd_proc_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_peffect, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_peffect, 2, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle_peffect)

    self:GetCaster():EmitSound("BS.Thirst_legendary_active")

end

end



modifier_custom_pudge_meat_hook_move = class({})
function modifier_custom_pudge_meat_hook_move:IsHidden() return true end
function modifier_custom_pudge_meat_hook_move:IsPurgable() return false end










modifier_custom_pudge_meat_hook_incoming = class({})
function modifier_custom_pudge_meat_hook_incoming:IsHidden() return false end
function modifier_custom_pudge_meat_hook_incoming:IsPurgable() return true end
function modifier_custom_pudge_meat_hook_incoming:GetTexture() return "buffs/odds_mark" end

function modifier_custom_pudge_meat_hook_incoming:OnCreated(table)

self.damage = self:GetCaster():GetTalentValue("modifier_pudge_hook_1", "damage")

if not IsServer() then return end

self.particle_peffect = ParticleManager:CreateParticle("particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())   
ParticleManager:SetParticleControl(self.particle_peffect, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.particle_peffect, false, false, -1, false, true)
end

function modifier_custom_pudge_meat_hook_incoming:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end

function modifier_custom_pudge_meat_hook_incoming:GetModifierIncomingDamage_Percentage() 
    return self.damage
end




modifier_custom_pudge_meat_hook_stack = class({})
function modifier_custom_pudge_meat_hook_stack:IsHidden() return false end
function modifier_custom_pudge_meat_hook_stack:IsPurgable() return false end
function modifier_custom_pudge_meat_hook_stack:OnCreated()

self.damage = self:GetCaster():GetTalentValue("modifier_pudge_hook_legendary", "damage")

if not IsServer() then return end 

self.RemoveForDuel = true
self:SetStackCount(1)
end 

function modifier_custom_pudge_meat_hook_stack:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_pudge_hook_legendary", "max") then return end 

self:IncrementStackCount()
end 


function modifier_custom_pudge_meat_hook_stack:OnStackCountChanged(iStackCount)
if self:GetStackCount() == 0 then return end
if not self.effect_cast then 

    local particle_cast = "particles/pudge/hook_stack.vpcf"

    self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

    self:AddParticle(self.effect_cast,false, false, -1, false, false)
else 

  ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 0, self:GetStackCount(), 0 ) )

end

end
function modifier_custom_pudge_meat_hook_stack:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_TOOLTIP
}
end


function modifier_custom_pudge_meat_hook_stack:OnTooltip()
return self:GetStackCount()*self.damage
end