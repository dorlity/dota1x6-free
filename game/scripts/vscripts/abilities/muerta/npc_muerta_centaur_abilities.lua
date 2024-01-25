LinkLuaModifier("modifier_npc_muerta_centaur_chrarge", "abilities/muerta/npc_muerta_centaur_abilities", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_npc_muerta_centaur_stuns_cast", "abilities/muerta/npc_muerta_centaur_abilities", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_npc_muerta_centaur_passive", "abilities/muerta/npc_muerta_centaur_abilities", LUA_MODIFIER_MOTION_HORIZONTAL)


npc_muerta_centaur_charge = class({})





function npc_muerta_centaur_charge:OnAbilityPhaseStart()
    self.sign = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster())
  
    self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.7)

    self:GetCaster():EmitSound("n_creep_Centaur.Stomp")

    return true
end 



function npc_muerta_centaur_charge:OnAbilityPhaseInterrupted()

ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:ReleaseParticleIndex(self.sign)
self:GetCaster():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end



function npc_muerta_centaur_charge:OnSpellStart()
if not IsServer() then return end

ParticleManager:DestroyParticle(self.sign, true)
ParticleManager:ReleaseParticleIndex(self.sign)

local point = self:GetCursorPosition()
local vec = (point - self:GetCaster():GetAbsOrigin())

point = point + vec:Normalized()*self:GetSpecialValueFor("additional_range")

local distance = (point - self:GetCaster():GetAbsOrigin()):Length2D()

local duration = distance/self:GetSpecialValueFor("speed")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_npc_muerta_centaur_chrarge", {x = point.x, y = point.y, z = point.z, duration = duration})

end


    
modifier_npc_muerta_centaur_chrarge = class({})

function modifier_npc_muerta_centaur_chrarge:IsDebuff() return false end
function modifier_npc_muerta_centaur_chrarge:IsHidden() return true end
function modifier_npc_muerta_centaur_chrarge:IsPurgable() return true end

function modifier_npc_muerta_centaur_chrarge:OnCreated(kv)
    if not IsServer() then return end
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_RUN)

    self.point = Vector(kv.x, kv.y, kv.z)

    self:GetParent():EmitSound("Lc.Odds_Charge")

    self.angle = self:GetParent():GetForwardVector():Normalized()--(self.point - self:GetParent():GetAbsOrigin()):Normalized() 

    self.distance = (self.point - self:GetCaster():GetAbsOrigin()):Length2D() / ( self:GetDuration() / FrameTime())

    self.stun = self:GetAbility():GetSpecialValueFor("stun")

    self.targets = {}

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_npc_muerta_centaur_chrarge:GetEffectName() return "particles/lc_odd_charge.vpcf" end

function modifier_npc_muerta_centaur_chrarge:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end




function modifier_npc_muerta_centaur_chrarge:GetModifierDisableTurning() return 1 end

function modifier_npc_muerta_centaur_chrarge:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end

function modifier_npc_muerta_centaur_chrarge:StatusEffectPriority() return 100 end

function modifier_npc_muerta_centaur_chrarge:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)

    self:GetParent():FadeGesture(ACT_DOTA_RUN)
   -- self:GetParent():StartGesture(ACT_DOTA_FORCESTAFF_END)


    local dir = self:GetParent():GetForwardVector()
    dir.z = 0
    self:GetParent():SetForwardVector(dir)
    self:GetParent():FaceTowards(self:GetParent():GetAbsOrigin() + dir*10)

    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

end


function modifier_npc_muerta_centaur_chrarge:UpdateHorizontalMotion( me, dt )
if not IsServer() then return end
local pos = self:GetParent():GetAbsOrigin()
GridNav:DestroyTreesAroundPoint(pos, 80, false)
local pos_p = self.angle * self.distance
local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())


self:GetParent():SetAbsOrigin(next_pos)


local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 170, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )


for _,unit in pairs(units) do
    if not self.targets[unit] then
        self.targets[unit] = true

        local enemy = unit

        enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_stunned", { duration = self.stun*(1 - enemy:GetStatusResistance()) } )
    

        if not (unit:IsCurrentlyHorizontalMotionControlled() or unit:IsCurrentlyVerticalMotionControlled()) then
            local direction = unit:GetOrigin()-self:GetParent():GetOrigin()
            direction.z = 0
            direction = direction:Normalized()

            local knockbackProperties =
            {
                center_x = unit:GetOrigin().x,
                center_y = unit:GetOrigin().y,
                center_z = unit:GetOrigin().z,
                duration = 0.3,
                knockback_duration = 0.3,
                knockback_distance = 100,
                knockback_height = 50
            }
            unit:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", knockbackProperties )

            unit:EmitSound("Hero_PrimalBeast.Onslaught.Hit")
        end

    end
end

end





function modifier_npc_muerta_centaur_chrarge:CheckState()
return
{
    [MODIFIER_STATE_SILENCED] = true,
    [MODIFIER_STATE_DISARMED] = true
}
end












npc_muerta_centaur_stun = class({})

function npc_muerta_centaur_stun:OnSpellStart()
if not IsServer() then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_npc_muerta_centaur_stuns_cast",{})

end


function npc_muerta_centaur_stun:OnChannelFinish(bInterrupted)
if not IsServer() then return end

self:GetCaster():RemoveModifierByName("modifier_npc_muerta_centaur_stuns_cast")
end


modifier_npc_muerta_centaur_stuns_cast = class({})

function modifier_npc_muerta_centaur_stuns_cast:IsHidden() return true end
function modifier_npc_muerta_centaur_stuns_cast:IsPurgable() return false end
function modifier_npc_muerta_centaur_stuns_cast:OnCreated(table)
if not IsServer() then return end

self.delay = self:GetAbility():GetSpecialValueFor("delay")
self.radius = self:GetAbility():GetSpecialValueFor("radius")
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.stun = self:GetAbility():GetSpecialValueFor("stun")
self.max = self:GetAbility():GetSpecialValueFor("amount")

self:CastAnim()
self:SetStackCount(0)

self:StartIntervalThink(self.delay)
end


function modifier_npc_muerta_centaur_stuns_cast:OnIntervalThink()
if not IsServer() then return end

self:IncrementStackCount()

self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
ParticleManager:DestroyParticle(self.effect_cast, false)
ParticleManager:ReleaseParticleIndex(self.effect_cast)


local trail_pfx = ParticleManager:CreateParticle("particles/neutral_fx/neutral_centaur_khan_war_stomp.vpcf",  PATTACH_ABSORIGIN, self:GetParent())
ParticleManager:SetParticleControl(trail_pfx, 1, Vector(self.radius, 0, 0))
ParticleManager:ReleaseParticleIndex(trail_pfx)

local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false )

for _,unit in pairs(units) do 

    local damage = self.damage*unit:GetMaxHealth()/100

    ApplyDamage({victim = unit, attacker = self:GetParent(), damage_type = DAMAGE_TYPE_MAGICAL,  damage = damage, ability = self:GetAbility(),})

    SendOverheadEventMessage(unit, 4, unit, damage, nil)

    unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_stunned", {duration = (1 - unit:GetStatusResistance())*self.stun})
end

if self:GetStackCount() < self.max then 

    self:CastAnim()
end

end


function modifier_npc_muerta_centaur_stuns_cast:CastAnim()
if not IsServer() then return end
self:GetParent():EmitSound("n_creep_Centaur.Stomp")

self:GetCaster():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 0.8)

local particle_cast = "particles/red_zone.vpcf"
self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetCaster())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetCaster():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self.delay, 0, 0 ) )

end



function modifier_npc_muerta_centaur_stuns_cast:OnDestroy()
if not IsServer() then return end
if not self.effect_cast then return end

self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1)

ParticleManager:DestroyParticle(self.effect_cast, false)
ParticleManager:ReleaseParticleIndex(self.effect_cast)
end









npc_muerta_centaur_passive = class({})
function npc_muerta_centaur_passive:GetIntrinsicModifierName()
return "modifier_npc_muerta_centaur_passive"
end


modifier_npc_muerta_centaur_passive = class({})
function modifier_npc_muerta_centaur_passive:IsHidden() return true end
function modifier_npc_muerta_centaur_passive:IsPurgable() return false end
function modifier_npc_muerta_centaur_passive:DeclareFunctions()
return
{
    MODIFIER_EVENT_ON_ATTACK_LANDED
}
end

function modifier_npc_muerta_centaur_passive:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(0)
end


function modifier_npc_muerta_centaur_passive:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end

self:IncrementStackCount()

if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("attacks") then return end

self:SetStackCount(0)

params.target:EmitSound("Hero_Tiny.CraggyExterior.Stun")
params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = (1 - params.target:GetStatusResistance())*self:GetAbility():GetSpecialValueFor("stun")})
end

