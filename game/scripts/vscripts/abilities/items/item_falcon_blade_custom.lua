LinkLuaModifier("modifier_item_falcon_blade_custom", "abilities/items/item_falcon_blade_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_falcon_blade_custom_active", "abilities/items/item_falcon_blade_custom", LUA_MODIFIER_MOTION_HORIZONTAL)

item_falcon_blade_custom = class({})

function item_falcon_blade_custom:GetIntrinsicModifierName()
	return "modifier_item_falcon_blade_custom"
end

function item_falcon_blade_custom:OnAbilityPhaseStart()

if self:GetCaster():IsStunned() then 
    return false
end 

return true
end 


function item_falcon_blade_custom:GetCastRange(vLocation, hTarget)
if IsClient() then 
    return self:GetSpecialValueFor("range")
end

return 99999
end

function item_falcon_blade_custom:OnSpellStart()
if not IsServer() then return end


local point = self:GetCaster():GetCursorPosition()
if point == self:GetCaster():GetAbsOrigin() then 
    point = self:GetCaster():GetForwardVector()*10 + self:GetCaster():GetAbsOrigin()
end

local dir = (point - self:GetCaster():GetAbsOrigin()):Normalized()

self:GetCaster():SetForwardVector(dir)
self:GetCaster():FaceTowards(point)

ProjectileManager:ProjectileDodge(self:GetCaster())

self:GetCaster():EmitSound("Item.Falcon_blade")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_falcon_blade_custom_active", {x = point.x, y = point.y, z = point.z, duration = self:GetSpecialValueFor("duration")})
end









modifier_item_falcon_blade_custom_active = class({})

function modifier_item_falcon_blade_custom_active:IsDebuff() return false end
function modifier_item_falcon_blade_custom_active:IsHidden() return true end
function modifier_item_falcon_blade_custom_active:IsPurgable() return true end

function modifier_item_falcon_blade_custom_active:OnCreated(kv)
    if not IsServer() then return end
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/force_staff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
    self:GetParent():StartGesture(ACT_DOTA_RUN)

    self.point = Vector(kv.x, kv.y, kv.z)


    self.angle = self:GetParent():GetForwardVector():Normalized()--(self.point - self:GetParent():GetAbsOrigin()):Normalized() 

    self.distance = self:GetAbility():GetSpecialValueFor("range") / ( self:GetDuration() / FrameTime())

    self.targets = {}

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_item_falcon_blade_custom_active:DeclareFunctions()
return
{
 MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    MODIFIER_PROPERTY_DISABLE_TURNING
}
end

function modifier_item_falcon_blade_custom_active:GetActivityTranslationModifiers()
    return "haste"
end


function modifier_item_falcon_blade_custom_active:GetModifierDisableTurning() return 1 end

function modifier_item_falcon_blade_custom_active:GetEffectName() return "particles/falcon_blade_charge.vpcf" end
function modifier_item_falcon_blade_custom_active:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_item_falcon_blade_custom_active:StatusEffectPriority() return 100 end

function modifier_item_falcon_blade_custom_active:OnDestroy()
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


function modifier_item_falcon_blade_custom_active:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end
    local pos = self:GetParent():GetAbsOrigin()
    GridNav:DestroyTreesAroundPoint(pos, 80, false)
    local pos_p = self.angle * self.distance
    local next_pos = GetGroundPosition(pos + pos_p,self:GetParent())
    self:GetParent():SetAbsOrigin(next_pos)


end

function modifier_item_falcon_blade_custom_active:OnHorizontalMotionInterrupted()
    self:Destroy()
end

















modifier_item_falcon_blade_custom = class({})

function modifier_item_falcon_blade_custom:IsHidden() return true end
function modifier_item_falcon_blade_custom:IsPurgable() return false end
function modifier_item_falcon_blade_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_falcon_blade_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end


function modifier_item_falcon_blade_custom:GetModifierHealthBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_health") end
end
function modifier_item_falcon_blade_custom:GetModifierConstantManaRegen()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_mana_regen") end
end
function modifier_item_falcon_blade_custom:GetModifierPreAttack_BonusDamage()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_damage") end
end



function modifier_item_falcon_blade_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end
if not params.attacker:IsRealHero() and not params.attacker:IsIllusion() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

if params.damage < 5 then return end
if self:GetAbility():GetCooldownTime() > self:GetAbility():GetSpecialValueFor("damage_cd") then return end

self:GetAbility():EndCooldown()
self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("damage_cd"))

end