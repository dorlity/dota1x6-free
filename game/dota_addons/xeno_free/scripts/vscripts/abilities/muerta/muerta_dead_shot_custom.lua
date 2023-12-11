LinkLuaModifier("modifier_muerta_dead_shot_custom_debuff", "abilities/muerta/muerta_dead_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_dead_shot_custom_fear", "abilities/muerta/muerta_dead_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_dead_shot_custom_thinker", "abilities/muerta/muerta_dead_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_dead_shot_custom_legendary", "abilities/muerta/muerta_dead_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_dead_shot_custom_legendary_target", "abilities/muerta/muerta_dead_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_dead_shot_custom_damage_cd", "abilities/muerta/muerta_dead_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_dead_shot_custom_second", "abilities/muerta/muerta_dead_shot_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_dead_shot_custom_speed", "abilities/muerta/muerta_dead_shot_custom", LUA_MODIFIER_MOTION_NONE)




muerta_dead_shot_custom = class({})

muerta_dead_shot_custom.triple_angle = 20
muerta_dead_shot_custom.triple_damage = 0.4
muerta_dead_shot_custom.triple_count = 2
muerta_dead_shot_custom.triple_range = 200


muerta_dead_shot_custom.cd_inc = -1.5
muerta_dead_shot_custom.cd_speed = 1.2

muerta_dead_shot_custom.range_inc = {100, 150, 200}
muerta_dead_shot_custom.fear_inc = {0.3, 0.45, 0.6}

muerta_dead_shot_custom.proc_duration = 4

muerta_dead_shot_custom.speed_duration = 4
muerta_dead_shot_custom.speed_attack = {40, 60, 80}
muerta_dead_shot_custom.speed_move = {10, 15, 20}

muerta_dead_shot_custom.projs = {}



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




function muerta_dead_shot_custom:Precache(context)

    
PrecacheResource( "particle", "particles/muerta/dead_legendary_stun.vpcf", context )
PrecacheResource( "particle", "particles/muerta/dead_refresh.vpcf", context )
PrecacheResource( "particle", "particles/muerta/dead_proc_proj.vpcf", context )
PrecacheResource( "particle", "particles/muerta/gun_evasion.vpcf", context )

end




function muerta_dead_shot_custom:GetCastRange(vLocation, hTarget)

local upgrade = 0
if self:GetCaster():HasModifier("modifier_muerta_dead_2") then 
  upgrade = self.range_inc[self:GetCaster():GetUpgradeStack("modifier_muerta_dead_2")]
end

return self.BaseClass.GetCastRange(self , vLocation , hTarget) + upgrade 
end


function muerta_dead_shot_custom:GetAbilityTargetFlags()
if self:GetCaster():HasModifier("modifier_muerta_dead_5") then 
    return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
else 
    return DOTA_UNIT_TARGET_FLAG_NONE
end

end




function muerta_dead_shot_custom:GetCooldown(level)
    local bonus = 0
    if self:GetCaster():HasModifier("modifier_muerta_dead_5") then
        bonus = self.cd_inc
    end
    return self.BaseClass.GetCooldown( self, level ) + bonus
end

function muerta_dead_shot_custom:CastFilterResultTarget( hTarget )
	if self:GetCaster() == hTarget then
		return UF_FAIL_CUSTOM
	end

	local nResult = UnitFilter(
		hTarget,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_TREE,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		self:GetCaster():GetTeamNumber()
	)

	if nResult ~= UF_SUCCESS then
		return nResult
	end

	self.targetcast = hTarget

	return UF_SUCCESS
end



function muerta_dead_shot_custom:OnAbilityPhaseInterrupted()

self.targetcast = nil

end



function muerta_dead_shot_custom:OnVectorCastStart(vStartLocation, vDirection)
	if not IsServer() then return end



	local point = self:GetVector2Position()

	local point_check = self:GetTargetPositionCheck()

	local target = self.targetcast

	if self.targetcast == nil then
		target = self:GetCursorTarget()
	end

	if target == nil then return end

	if not target:IsBaseNPC() then
		local dummy = CreateUnitByName("npc_dota_companion", target:GetAbsOrigin(), false, nil, nil, self:GetCaster():GetTeamNumber())
        dummy:AddNewModifier(self:GetCaster(), self, "modifier_muerta_dead_shot_custom_thinker", {})
        dummy.tree = target
        target = dummy
        point_check = target:GetAbsOrigin()
	end

	local vel = point - point_check
	vel.z = 0
	vel = vel:Normalized()

    local speed = self:GetSpecialValueFor("speed")

    if self:GetCaster():HasModifier("modifier_muerta_dead_5") then 
        speed = speed*self.cd_speed
    end

    local info = 
    {
        EffectName = "particles/units/heroes/hero_muerta/muerta_deadshot_tracking_proj.vpcf",
        Ability = self,
        iMoveSpeed = speed,
        Source = self:GetCaster(),
        Target = target,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
        ExtraData = { x = vel.x, y = vel.y, tracking = 1 }
    }

    if self:GetCaster():HasModifier("modifier_muerta_dead_4") then 
        self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_muerta_dead_shot_custom_second", {duration = self.proc_duration})
    end


    self:GetCaster():EmitSound("Hero_Muerta.DeadShot.Cast")

    ProjectileManager:CreateTrackingProjectile( info )

    self.targetcast = nil
end






function muerta_dead_shot_custom:DealDamage(target, triple, damage_k)
if not IsServer() then return end

target:EmitSound("Hero_Muerta.DeadShot.Damage")

local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_deadshot_creep_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
ParticleManager:SetParticleControlEnt( particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

local damage = self:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_muerta_dead_1") then 
    damage = damage + self:GetCaster():GetTalentValue("modifier_muerta_dead_1", "damage")*self:GetCaster():GetIntellect()/100
end

--if target:HasModifier("modifier_muerta_dead_shot_custom_damage_cd") and triple then 
    --damage = damage*self.triple_damage
   -- SendOverheadEventMessage(target, 6, target, damage, nil)
--end

if damage_k then 
    damage = damage*damage_k
end

ApplyDamage({ victim = target, attacker = self:GetCaster(), ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL })

--target:AddNewModifier(self:GetCaster(), self, "modifier_muerta_dead_shot_custom_damage_cd", {duration = 0.3})

end








function muerta_dead_shot_custom:RicochetShot(x, y, target, damage_k)
if not IsServer() then return end

local vel = Vector(x, y, 0)

local effect = "particles/units/heroes/hero_muerta/muerta_deadshot_linear.vpcf"

local speed = self:GetSpecialValueFor("speed")

if self:GetCaster():HasModifier("modifier_muerta_dead_5") then 
    speed = speed*self.cd_speed
end

local damage = 1

local proj_number = nil

if damage_k then 
    damage = damage_k
else 
    proj_number = #self.projs + 1
    self.projs[proj_number] = false
end

local bonus = 0
if self:GetCaster():HasModifier("modifier_muerta_dead_6") then 
    bonus = self.triple_range
end

local info = 
{
    ExtraData = {proj_number = proj_number, x = vel.x, y = vel.y, tracking = 0, source = target:entindex(), source_x = target:GetAbsOrigin().x, source_y = target:GetAbsOrigin().y, damage_k = damage },
    Source = self:GetCaster(),
    Ability = self,
    EffectName = effect,
    vSpawnOrigin = target:GetAbsOrigin(),
    fDistance = self:GetSpecialValueFor("range") + bonus,
    vVelocity = vel * speed,
    fStartRadius = self:GetSpecialValueFor("ricochet_radius_start"),
    fEndRadius = self:GetSpecialValueFor("ricochet_radius_end"),
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    bProvidesVision = true,
    iVisionRadius = 115,
    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    fExpireTime         = GameRules:GetGameTime() + 5.0,
    bDeleteOnHit        = false,
}


ProjectileManager:CreateLinearProjectile( info )

end




function muerta_dead_shot_custom:OnProjectileHit_ExtraData( target, location, data )
    if not IsServer() then return end

    if target and data.tracking == 1 then

        if target:TriggerSpellAbsorb(self) then return end

        target:AddNewModifier(self:GetCaster(), self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_muerta_dead_5")), "modifier_muerta_dead_shot_custom_debuff", {duration = self:GetSpecialValueFor("impact_slow_duration") * (1-target:GetStatusResistance())})

        self:DealDamage(target)

        target:EmitSound("Hero_Muerta.DeadShot.Ricochet")
        target:EmitSound("Hero_Muerta.DeadShot.Slow")

        self:RicochetShot(data.x, data.y, target)

        if self:GetCaster():HasModifier("modifier_muerta_dead_6") then 

            for i = 1, self.triple_count do
                local newAngle = self.triple_angle * math.ceil(i / 2) * (-1)^i
                local newDir = RotateVector2D( Vector(data.x, data.y, 0), ToRadians( newAngle ) )
                
                self:RicochetShot(newDir.x, newDir.y, target, self.triple_damage)
            end

        end

        if target:GetUnitName() == "npc_dota_companion" then
            target:RemoveModifierByName("modifier_muerta_dead_shot_custom_thinker")
        	target:ForceKill(false)
        end
    end



    if target and data.tracking == 0 and target:entindex() ~= data.source and not target:HasModifier("modifier_muerta_dead_shot_custom_legendary") then
    	target:EmitSound("Hero_Muerta.DeadShot.Fear")
    	target:EmitSound("Hero_Muerta.DeadShot.Impact")
    	target:EmitSound("Hero_Muerta.DeadShot.Ricochet.Impact")
    	target:EmitSound("Hero_Muerta.Impact")

    	if data.proj_number ~= nil and self.projs[data.proj_number] == false then 

            local ult = self:GetCaster():FindAbilityByName("muerta_pierce_the_veil_custom")
            if ult and ult:GetLevel() > 0 and self:GetCaster():HasModifier("modifier_muerta_veil_7") then 
              --  ult:LegendaryProc(1)
            end

            self.projs[data.proj_number] = true
        end


        local new_x = target:GetAbsOrigin() + target:GetForwardVector()
        
        local new_y = new_x.y
        new_x = new_x.x

        if data.source_x then 
            new_x = data.source_x
        end
        if data.source_y then 
            new_y = data.source_y
        end

        local duration = self:GetSpecialValueFor("ricochet_fear_duration")

        if self:GetCaster():HasModifier("modifier_muerta_dead_2") then 
            duration = duration + self.fear_inc[self:GetCaster():GetUpgradeStack("modifier_muerta_dead_2")]
        end

        target:AddNewModifier(self:GetCaster(),  self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_muerta_dead_5")), "modifier_muerta_dead_shot_custom_fear", {duration = duration * (1-target:GetStatusResistance()), x = new_x, y = new_y})

        local damage_k = 1 
        if data.damage_k then 
            damage_k = data.damage_k
        end

        if self:GetCaster():HasModifier("modifier_muerta_dead_3") then 
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_muerta_dead_shot_custom_speed", {duration = self.speed_duration})
        end

        self:DealDamage(target, true, damage_k)

        if target:IsHero() then 

            if self:GetCaster():GetQuest() == "Muerta.Quest_5" and target:IsRealHero() then 
                self:GetCaster():UpdateQuest(1)
            end

            return true
        end
    end
end

modifier_muerta_dead_shot_custom_debuff = class({})


function modifier_muerta_dead_shot_custom_debuff:OnCreated(table)
self.main = self:GetCaster():FindAbilityByName("muerta_dead_shot_custom")

if not IsServer() then return end

self:StartIntervalThink(0.1)
end

function modifier_muerta_dead_shot_custom_debuff:OnIntervalThink()
if not IsServer() then return end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 10, 0.1, false)
end


function modifier_muerta_dead_shot_custom_debuff:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_muerta_dead_shot_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
if not self.main then return end
	return self.main:GetSpecialValueFor("impact_slow_percent")
end

function modifier_muerta_dead_shot_custom_debuff:GetEffectName()
    return "particles/units/heroes/hero_muerta/muerta_spell_fear_debuff.vpcf"
end

function modifier_muerta_dead_shot_custom_debuff:StatusEffectPriority()
    return 10
end

function modifier_muerta_dead_shot_custom_debuff:GetStatusEffectName()
    return "particles/units/heroes/hero_muerta/muerta_spell_fear_debuff_status.vpcf"
end

function modifier_muerta_dead_shot_custom_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end




modifier_muerta_dead_shot_custom_thinker = class({})

function modifier_muerta_dead_shot_custom_thinker:IsHidden() return true end
function modifier_muerta_dead_shot_custom_thinker:IsPurgable() return false end

function modifier_muerta_dead_shot_custom_thinker:CheckState()
    return 
    {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_muerta_dead_shot_custom_thinker:OnDestroy()
    if not IsServer() then return end
    if self:GetParent().tree then
        self:GetParent().tree:CutDown(self:GetCaster():GetTeamNumber())
    end
    GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 25, true)
end







modifier_muerta_dead_shot_custom_fear = class({})


function modifier_muerta_dead_shot_custom_fear:GetTexture() return "muerta_dead_shot" end

function modifier_muerta_dead_shot_custom_fear:OnCreated(data)
if not IsServer() then return end

local source_point = Vector(data.x, data.y, 0)

source_point = GetGroundPosition(source_point, nil)


local vec = (self:GetParent():GetAbsOrigin() - source_point):Normalized()

self.position = self:GetParent():GetAbsOrigin() + vec * 500

self.position = GetGroundPosition(self.position, nil)



if not self:GetParent():IsHero() then
	self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_disarmed", {duration = 0.1})
	--self:GetParent():SetAggroTarget(nil)
end

if not self:GetParent():IsDebuffImmune() or self:GetCaster():HasModifier("modifier_muerta_dead_5") then 
	self:GetParent():MoveToPosition( self.position )
end

end


function modifier_muerta_dead_shot_custom_fear:OnRefresh(table)
if not IsServer() then return end
--if self:GetParent():HasModifier("modifier_muerta_dead_shot_custom_damage_cd") then return end

self:OnCreated(table)
end



function modifier_muerta_dead_shot_custom_fear:GetEffectName()
    return "particles/units/heroes/hero_muerta/muerta_spell_fear_debuff.vpcf"
end

function modifier_muerta_dead_shot_custom_fear:StatusEffectPriority()
    return 10
end

function modifier_muerta_dead_shot_custom_fear:GetStatusEffectName()
    return "particles/units/heroes/hero_muerta/muerta_spell_fear_debuff_status.vpcf"
end

function modifier_muerta_dead_shot_custom_fear:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_muerta_dead_shot_custom_fear:CheckState()
    local state = 
    {
        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
        [MODIFIER_STATE_FEARED] = true,
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_UNSLOWABLE] = true,
    }
    return state
end

function modifier_muerta_dead_shot_custom_fear:OnDestroy()
    if not IsServer() then return end
    self:GetParent():Stop()
end







muerta_dead_shot_custom_legendary = class({})


function muerta_dead_shot_custom_legendary:OnAbilityPhaseStart()

self:GetCaster():EmitSound("Hero_Muerta.PartingShot.Start")

return true
end


function muerta_dead_shot_custom_legendary:OnSpellStart()
if not IsServer() then return end


local target = self:GetCursorTarget()

local info = 
{
    EffectName = "particles/units/heroes/hero_muerta/muerta_parting_shot_projectile.vpcf",
    Ability = self,
    iMoveSpeed = self:GetSpecialValueFor("speed"),
    Source = self:GetCaster(),
    Target = target,
    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
    ExtraData = {x = self:GetCaster():GetAbsOrigin().x, y = self:GetCaster():GetAbsOrigin().y }
}

self:GetCaster():EmitSound("Hero_Muerta.PartingShot.Cast")

ProjectileManager:CreateTrackingProjectile( info )



end


function muerta_dead_shot_custom_legendary:OnProjectileHit_ExtraData(hTarget, vLocation, table)
if not IsServer() then return end
if not hTarget then return end

if hTarget:TriggerSpellAbsorb(self) then return end

hTarget:EmitSound("Hero_Muerta.PartingShot.Soul")

local source = Vector(table.x, table.y, 0)

local vec = (hTarget:GetAbsOrigin() - source)
vec.z = 0

vec = vec:Normalized()

hTarget:AddNewModifier(self:GetCaster(), self, "modifier_muerta_dead_shot_custom_debuff", {duration = self:GetSpecialValueFor("impact_slow_duration") * (1 - hTarget:GetStatusResistance())})


local point = hTarget:GetAbsOrigin() + vec*50

local target = hTarget
if target:IsCreep() then 
    target = self:GetCaster()
end

local duration = self:GetCaster():GetTalentValue("modifier_muerta_dead_7", "duration")

local illusion = CreateIllusions( hTarget, target, {duration = self:GetSpecialValueFor('duration'), outgoing_damage = -100 ,incoming_damage = 0}, 1, 1, false, true )
for _,i in pairs(illusion) do

    i:Stop()
    i:StartGesture(ACT_DOTA_DISABLED)

    i:AddNewModifier(i, nil, "modifier_stunned", {duration = duration})
    i:AddNewModifier(i, nil, "modifier_chaos_knight_phantasm_illusion", {})
    i:AddNewModifier(i, nil, "modifier_muerta_dead_shot_custom_legendary", {duration = duration} )

    hTarget:AddNewModifier(self:GetCaster(), self, "modifier_muerta_dead_shot_custom_legendary_target", {duration = duration, soul = i:entindex()})


    i:SetAbsOrigin(point)
    FindClearSpaceForUnit(i, point, true)

    local new_point = hTarget:GetAbsOrigin() + vec*self:GetSpecialValueFor("start_range")

    i:AddNewModifier( i,  nil,  "modifier_generic_arc",  
    {
      target_x = new_point.x,
      target_y = new_point.y,
      distance = self:GetSpecialValueFor("start_range"),
      duration = 0.3,
      height = 0,
      fix_end = false,
      isStun = false,
      activity = ACT_DOTA_FLAIL,
    })

    i:SetHealth(i:GetMaxHealth())

    i.owner = hTarget

    for _,mod in pairs(hTarget:FindAllModifiers()) do
      if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
          i:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
      end
    end

end



end


modifier_muerta_dead_shot_custom_legendary = class({})

function modifier_muerta_dead_shot_custom_legendary:IsHidden() return true end
function modifier_muerta_dead_shot_custom_legendary:IsPurgable() return false end

function modifier_muerta_dead_shot_custom_legendary:OnCreated(table)
if not IsServer() then return end



self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_parting_shot_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

self:GetParent():StartGesture(ACT_DOTA_DISABLED)
end

function modifier_muerta_dead_shot_custom_legendary:CheckState()
return
{
  --  [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_ATTACK_IMMUNE] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
}

end

function modifier_muerta_dead_shot_custom_legendary:GetStatusEffectName()
    return "particles/status_fx/status_effect_muerta_parting_shot.vpcf"
end
function modifier_muerta_dead_shot_custom_legendary:StatusEffectPriority()
 return 9999999
end


function modifier_muerta_dead_shot_custom_legendary:GetEffectName()
    --return "particles/units/heroes/hero_muerta/muerta_parting_shot_soul.vpcf"
end

function modifier_muerta_dead_shot_custom_legendary:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_muerta_dead_shot_custom_legendary:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
    MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
}
end


function modifier_muerta_dead_shot_custom_legendary:GetActivityTranslationModifiers()
return ACT_DOTA_DISABLED
end


function modifier_muerta_dead_shot_custom_legendary:GetAbsoluteNoDamagePhysical()
return 1
end

function modifier_muerta_dead_shot_custom_legendary:GetAbsoluteNoDamagePure()
return 1
end

function modifier_muerta_dead_shot_custom_legendary:GetAbsoluteNoDamageMagical()
return 1
end



modifier_muerta_dead_shot_custom_legendary_target = class({})
function modifier_muerta_dead_shot_custom_legendary_target:IsHidden() return false end
function modifier_muerta_dead_shot_custom_legendary_target:IsPurgable() return false end
function modifier_muerta_dead_shot_custom_legendary_target:OnCreated(table)
if not IsServer() then return end
if not table.soul then return end

self.damage = self:GetCaster():GetTalentValue("modifier_muerta_dead_7", "damage")/100
self.heal = self:GetCaster():GetTalentValue("modifier_muerta_dead_7", "heal")/100

self.soul = EntIndexToHScript(table.soul)

self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_parting_shot_tether.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
ParticleManager:SetParticleControlEnt( self.particle, 1, self.soul, PATTACH_POINT_FOLLOW, "attach_hitloc", self.soul:GetOrigin(), true )
self:AddParticle(self.particle, false, false, -1, false, false)

self.max_range = self:GetAbility():GetSpecialValueFor("max_range")

self:StartIntervalThink(0.1)
end


function modifier_muerta_dead_shot_custom_legendary_target:OnIntervalThink()
if not IsServer() then return end

if not self.soul or self.soul:IsNull() or not self.soul:IsAlive() then 
    self:Destroy()
end

AddFOWViewer(self:GetCaster():GetTeamNumber(), self.soul:GetAbsOrigin(), 50, 0.2, false)


if (self.soul:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > self.max_range then 

    local part = ParticleManager:CreateParticle("particles/muerta/dead_legendary_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.soul)
    ParticleManager:ReleaseParticleIndex(part)

    local vect = (self.soul:GetAbsOrigin() - self:GetParent():GetAbsOrigin())
    local dist = self.max_range * 0.7
    local new_point = self:GetParent():GetAbsOrigin() + vect:Normalized()*dist
    --[[
    self:GetParent():AddNewModifier( self:GetCaster(),  nil,  "modifier_generic_arc",  
    {
      target_x = new_point.x,
      target_y = new_point.y,
      distance = dist,
      duration = 0.4,
      height = 0,
      fix_end = false,
      isStun = false,
      activity = ACT_DOTA_FLAIL,
    })
    ]]--

    self.soul:Kill(nil, nil)

    part = ParticleManager:CreateParticle("particles/muerta/dead_legendary_stun.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    ParticleManager:ReleaseParticleIndex(part)

    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self:GetAbility():GetSpecialValueFor("impact_stun")})
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_muerta_dead_shot_custom_debuff", {duration = self:GetAbility():GetSpecialValueFor("break_slow_duration")})

    self:GetParent():EmitSound("Hero_Muerta.PartingShot.Stun")

    local ability = self:GetCaster():FindAbilityByName("muerta_dead_shot_custom")
    if ability then 
        ability:DealDamage(self:GetParent(), false, self.damage)
    end

    local particle = ParticleManager:CreateParticle("particles/muerta/dead_refresh.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
    ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
    ParticleManager:ReleaseParticleIndex(particle)


    self:GetAbility():EndCooldown()
    self:GetCaster():EmitSound("Sniper.Shrapnel_legendary")


    self:Destroy()
end

end


function modifier_muerta_dead_shot_custom_legendary_target:CheckState()
return
{
    [MODIFIER_STATE_TETHERED] = true
}
end


function modifier_muerta_dead_shot_custom_legendary_target:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_TAKEDAMAGE
}
end

function modifier_muerta_dead_shot_custom_legendary_target:OnTakeDamage(params)
if not IsServer() then return end 
if self:GetCaster() ~= params.attacker then return end
if params.unit ~= self:GetParent() then return end
if params.unit:IsIllusion() then return end
if not params.unit:IsCreep() and not params.unit:IsHero() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

self:GetCaster():GenericHeal(params.damage*self.heal, self:GetAbility(), true)

end 


modifier_muerta_dead_shot_custom_damage_cd = class({})
function modifier_muerta_dead_shot_custom_damage_cd:IsHidden() return true end
function modifier_muerta_dead_shot_custom_damage_cd:IsPurgable() return false end






muerta_dead_shot_custom_proc = class({})


function muerta_dead_shot_custom_proc:GetCastRange(vLocation, hTarget)
if IsClient() then 
    return self:GetSpecialValueFor("range")
end

return 999999
end

function muerta_dead_shot_custom_proc:OnSpellStart()
if not IsServer() then return end

self.main = self:GetCaster():FindAbilityByName("muerta_dead_shot_custom")
if not self.main then return end

self:GetCaster():RemoveModifierByName("modifier_muerta_dead_shot_custom_second")

local point = self:GetCursorPosition()

if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then 
    point = self:GetCaster():GetAbsOrigin() + self:GetCaster():GetForwardVector()*10
end

local dir = (point - self:GetCaster():GetAbsOrigin()):Normalized()

local real_point = self:GetCaster():GetAbsOrigin() + dir*self:GetSpecialValueFor("range")
local vel = (real_point - self:GetCaster():GetAbsOrigin()):Normalized()

local effect = "particles/muerta/dead_proc_proj.vpcf"

self.speed = self:GetSpecialValueFor("speed")

if self:GetCaster():HasModifier("modifier_muerta_dead_5") then 
    self.speed = self.speed * self.main.cd_speed
end

local info = 
{
    ExtraData = { x = vel.x, y = vel.y, tracking = 0},
    Source = self:GetCaster(),
    Ability = self,
    EffectName = effect,
    vSpawnOrigin = self:GetCaster():GetAbsOrigin(),
    fDistance = self:GetSpecialValueFor("range"),
    vVelocity = vel * self.speed,
    fStartRadius = self:GetSpecialValueFor("ricochet_radius_start"),
    fEndRadius = self:GetSpecialValueFor("ricochet_radius_end"),
    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    bProvidesVision = true,
    iVisionRadius = 115,
    iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
    fExpireTime         = GameRules:GetGameTime() + 5.0,
    bDeleteOnHit        = false,
}


self:GetCaster():EmitSound("Muerta.Dead_proc")
ProjectileManager:CreateLinearProjectile( info )

end



function muerta_dead_shot_custom_proc:OnProjectileHit_ExtraData(hTarget, vLocation, table)
if not IsServer() then return end
if not table.tracking then return end


if table.tracking == 0 and hTarget == nil then 


    local vel = Vector(table.x, table.y, 0)*-1
    local effect = "particles/muerta/dead_proc_proj.vpcf"

    local info = 
    {
        ExtraData = { x = vel.x, y = vel.y, tracking = 1, source_x = vLocation.x, source_y = vLocation.y},
        Source = self:GetCaster(),
        Ability = self,
        EffectName = effect,
        vSpawnOrigin = vLocation,
        fDistance = self:GetSpecialValueFor("range"),
        vVelocity = vel * self.speed,
        fStartRadius = self:GetSpecialValueFor("ricochet_radius_start"),
        fEndRadius = self:GetSpecialValueFor("ricochet_radius_end"),
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        bProvidesVision = true,
        iVisionRadius = 115,
        iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
        fExpireTime         = GameRules:GetGameTime() + 5.0,
        bDeleteOnHit        = false,
    }

    ProjectileManager:CreateLinearProjectile( info )


    EmitSoundOnLocationWithCaster(vLocation, "Muerta.Dead_proc_rec", self:GetCaster())
    EmitSoundOnLocationWithCaster(vLocation, "Hero_Muerta.DeadShot.Slow", self:GetCaster())
end


if not hTarget then return end

local ability = self:GetCaster():FindAbilityByName("muerta_dead_shot_custom")
if not ability then return end

local target = hTarget

ability:DealDamage(hTarget, false, self:GetSpecialValueFor("damage_"..self:GetCaster():GetUpgradeStack("modifier_muerta_dead_4"))/100)

if table.tracking == 1 then 

    local duration = self:GetSpecialValueFor("fear_"..self:GetCaster():GetUpgradeStack("modifier_muerta_dead_4"))

    local new_x = target:GetAbsOrigin() + target:GetForwardVector()
    
    local new_y = new_x.y
    new_x = new_x.x

    if table.source_x then 
        new_x = table.source_x
    end
    if table.source_y then 
        new_y = table.source_y
    end


    if self:GetCaster():HasModifier("modifier_muerta_dead_3") then 
        self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_muerta_dead_shot_custom_speed", {duration = ability.speed_duration})
    end


    target:AddNewModifier(self:GetCaster(),  self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_muerta_dead_5")), "modifier_muerta_dead_shot_custom_fear", {duration = duration * (1-target:GetStatusResistance()), x = new_x, y = new_y})

    target:EmitSound("Hero_Muerta.DeadShot.Fear")
    target:EmitSound("Hero_Muerta.DeadShot.Impact")
    target:EmitSound("Hero_Muerta.DeadShot.Ricochet.Impact")
    target:EmitSound("Hero_Muerta.Impact")
end

if table.tracking == 0 then 

    hTarget:AddNewModifier(self:GetCaster(),  self:GetCaster():BkbAbility(self, self:GetCaster():HasModifier("modifier_muerta_dead_5")), "modifier_muerta_dead_shot_custom_debuff", {duration = self:GetSpecialValueFor("impact_slow_duration") * (1-hTarget:GetStatusResistance())})

    hTarget:EmitSound("Hero_Muerta.DeadShot.Slow")

end


end



modifier_muerta_dead_shot_custom_second = class({})

function modifier_muerta_dead_shot_custom_second:IsHidden() return false end
function modifier_muerta_dead_shot_custom_second:IsPurgable() return false end
function modifier_muerta_dead_shot_custom_second:GetTexture() return "dead_shot_proc" end
function modifier_muerta_dead_shot_custom_second:OnCreated(table)
if not IsServer() then return end

self.ability = self:GetCaster():FindAbilityByName("muerta_dead_shot_custom")
self.ability_proc = self:GetCaster():FindAbilityByName("muerta_dead_shot_custom_proc")

if self.ability and self.ability_proc and self.ability_proc:IsHidden() then 

    self:GetParent():SwapAbilities(self.ability:GetName(), self.ability_proc:GetName(), false, true)
    self.ability_proc:StartCooldown(0.3)
end

end


function modifier_muerta_dead_shot_custom_second:OnDestroy()
if not IsServer() then return end


if self.ability and self.ability_proc and not self.ability_proc:IsHidden() then 

    self:GetParent():SwapAbilities(self.ability:GetName(), self.ability_proc:GetName(), true, false)

end

end






modifier_muerta_dead_shot_custom_speed = class({})
function modifier_muerta_dead_shot_custom_speed:IsHidden() return false end
function modifier_muerta_dead_shot_custom_speed:IsPurgable() return false end
function modifier_muerta_dead_shot_custom_speed:GetTexture() return "buffs/reflection_speed" end

function modifier_muerta_dead_shot_custom_speed:GetEffectName() 
  return "particles/muerta/gun_evasion.vpcf"
end

function modifier_muerta_dead_shot_custom_speed:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_muerta_dead_shot_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end



function modifier_muerta_dead_shot_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().speed_attack[self:GetCaster():GetUpgradeStack("modifier_muerta_dead_3")]
end



function modifier_muerta_dead_shot_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().speed_move[self:GetCaster():GetUpgradeStack("modifier_muerta_dead_3")]
end