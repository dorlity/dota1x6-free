LinkLuaModifier("modifier_item_harpoon_custom", "abilities/items/item_harpoon_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_harpoon_custom_pull", "abilities/items/item_harpoon_custom", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_item_harpoon_custom_speed", "abilities/items/item_harpoon_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_harpoon_custom_cd", "abilities/items/item_harpoon_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_harpoon_custom_slow", "abilities/items/item_harpoon_custom", LUA_MODIFIER_MOTION_NONE)

item_harpoon_custom = class({})



function item_harpoon_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items_fx/harpoon_projectile.vpcf", context )
PrecacheResource( "particle","particles/items_fx/harpoon_pull.vpcf", context )
PrecacheResource( "particle","particles/status_fx/status_effect_forcestaff.vpcf", context )
end

function item_harpoon_custom:GetIntrinsicModifierName()
    return "modifier_item_harpoon_custom"
end

function item_harpoon_custom:OnSpellStart()
if not IsServer() then return end
local target = self:GetCursorTarget()

self:GetCaster():EmitSound("Item.Harpoon.Cast")

if target:TriggerSpellAbsorb(self) then
    return nil
end

local projectile =
{
  Target = target,
  Source = self:GetCaster(),
  Ability = self,
  EffectName = "particles/items_fx/harpoon_projectile.vpcf",
  iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
  vSourceLoc = self:GetCaster():GetAbsOrigin(),
  bDodgeable = true,
  bProvidesVision = false,
}
ProjectileManager:CreateTrackingProjectile( projectile )
end



function item_harpoon_custom:OnProjectileHit(hTarget, vLocation)
if not hTarget then return end 
if not IsServer() then return end

DoDamage({victim = hTarget, attacker = self:GetCaster(), ability = self, damage_type = DAMAGE_TYPE_PURE, damage = self:GetSpecialValueFor("damage")})

local dis = (hTarget:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()

if dis <= self:GetSpecialValueFor("min_distance") then return end 

hTarget:EmitSound("Item.Harpoon.Target")

hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_harpoon_custom_slow", {duration = (1 - hTarget:GetStatusResistance())*self:GetSpecialValueFor("slow_duration")})

hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_harpoon_custom_pull", {duration = self:GetSpecialValueFor("pull_duration"), target = self:GetCaster():entindex()})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_harpoon_custom_pull", {duration = self:GetSpecialValueFor("pull_duration"), target = hTarget:entindex()})
end 



modifier_item_harpoon_custom = class({})

function modifier_item_harpoon_custom:IsHidden()      return true end
function modifier_item_harpoon_custom:IsPurgable()        return false end
function modifier_item_harpoon_custom:RemoveOnDeath() return false end
function modifier_item_harpoon_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_harpoon_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
}
end


function modifier_item_harpoon_custom:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

if self.parent:IsRealHero() and not self.parent:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then
    self.parent:AddAttackEvent_out(self)
    self.parent:AddAttackFailEvent_out(self)
end

self.int = self.ability:GetSpecialValueFor("bonus_intellect")
self.agi = self.ability:GetSpecialValueFor("bonus_agility")
self.regen = self.ability:GetSpecialValueFor("bonus_mana_regen")
self.damage = self.ability:GetSpecialValueFor("bonus_damage")
self.str = self.ability:GetSpecialValueFor("bonus_strength")
self.slow_duration = self.ability:GetSpecialValueFor("slow_duration")
end 


function modifier_item_harpoon_custom:StartSpeed(target, slow)
if not IsServer() then return end
if not self.parent:IsRealHero() then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_harpoon_custom_cd", {duration = self.ability:GetSpecialValueFor("passive_cooldown")*self.parent:GetCooldownReduction()})
self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_harpoon_custom_speed", {})

if self.ability and target:IsUnit() and slow then 
    target:AddNewModifier(self:GetCaster(), self.ability, "modifier_item_harpoon_custom_slow", {duration = (1 - target:GetStatusResistance())*self.slow_duration})
end

end


function modifier_item_harpoon_custom:AttackFailEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

local mod = self.parent:FindModifierByName("modifier_item_harpoon_custom_speed")
if mod then 
    mod:Destroy()
end 

if params.attacker:FindAllModifiersByName(self:GetName())[1] ~= self then return end 
if self.parent:HasModifier("modifier_item_harpoon_custom_cd") then return end
if self.parent:IsRangedAttacker() then return end

self:StartSpeed(params.target, false)
end


function modifier_item_harpoon_custom:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end

local mod = self.parent:FindModifierByName("modifier_item_harpoon_custom_speed")
if mod then 
    params.target:AddNewModifier(self.parent, self.ability, "modifier_item_harpoon_custom_slow", {duration = (1 - params.target:GetStatusResistance())*self.slow_duration})
    mod:Destroy()
end 

if params.attacker:FindAllModifiersByName(self:GetName())[1] ~= self then return end 
if self.parent:HasModifier("modifier_item_harpoon_custom_cd") then return end
if self.parent:IsRangedAttacker() then return end

self:StartSpeed(params.target, true)
end



function modifier_item_harpoon_custom:GetModifierBonusStats_Intellect()
return self.int
end


function modifier_item_harpoon_custom:GetModifierBonusStats_Agility()
return self.agi
end

function modifier_item_harpoon_custom:GetModifierConstantManaRegen()
    return self.regen
end


function modifier_item_harpoon_custom:GetModifierPreAttack_BonusDamage()
    return self.damage
end

function modifier_item_harpoon_custom:GetModifierBonusStats_Strength()
    return self.str 
end








--///////////////////

modifier_item_harpoon_custom_pull = class({})

function modifier_item_harpoon_custom_pull:IsDebuff() return false end
function modifier_item_harpoon_custom_pull:IsHidden() return true end

function modifier_item_harpoon_custom_pull:OnCreated(params)
    if not IsServer() then return end
    self.target = EntIndexToHScript(params.target)
    self.pfx = ParticleManager:CreateParticle("particles/items_fx/harpoon_pull.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

    self:GetParent():StartGesture(ACT_DOTA_FLAIL)

    self.angle = (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
    self.point = (self:GetParent():GetAbsOrigin() + self.target:GetAbsOrigin()) / 2


    self.point = self.point - (self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()*50



    self.speed = (self:GetParent():GetAbsOrigin() - self.point):Length2D()/self:GetRemainingTime()

    if self:ApplyHorizontalMotionController() == false then
        self:Destroy()
    end
end

function modifier_item_harpoon_custom_pull:GetStatusEffectName() return "particles/status_fx/status_effect_forcestaff.vpcf" end
function modifier_item_harpoon_custom_pull:StatusEffectPriority() return MODIFIER_PRIORITY_NORMAL  end

function modifier_item_harpoon_custom_pull:OnDestroy()
    if not IsServer() then return end
    self:GetParent():InterruptMotionControllers( true )
    ParticleManager:DestroyParticle(self.pfx, false)
    ParticleManager:ReleaseParticleIndex(self.pfx)

    self:GetParent():FadeGesture(ACT_DOTA_FLAIL)

    ResolveNPCPositions(self:GetParent():GetAbsOrigin(), 128)

    if not self:GetParent():IsChanneling() then 
        --self:GetParent():MoveToTargetToAttack(self.target)
    end
end


function modifier_item_harpoon_custom_pull:UpdateHorizontalMotion( me, dt )
    if not IsServer() then return end

    if not self.target or self.target:IsNull() or not self.target:IsAlive() then
        self:Destroy()
        return
    end

    local origin = self:GetParent():GetOrigin()


    local direction = self.point - origin
    direction.z = 0
    local distance = direction:Length2D()
    direction = direction:Normalized()

    local flPad = self:GetParent():GetPaddedCollisionRadius()

    if distance<flPad then
        self:Destroy()
    elseif distance>1500 then
        self:Destroy()
    end

    GridNav:DestroyTreesAroundPoint(origin, 80, false)
    local target = origin + direction * self.speed * dt
    self:GetParent():SetOrigin( target )
    self:GetParent():FaceTowards( self.target:GetOrigin() )
end

function modifier_item_harpoon_custom_pull:OnHorizontalMotionInterrupted()
    self:Destroy()
end












modifier_item_harpoon_custom_cd = class({})
function modifier_item_harpoon_custom_cd:IsHidden() return false end
function modifier_item_harpoon_custom_cd:IsPurgable() return false end
function modifier_item_harpoon_custom_cd:RemoveOnDeath() return false end
function modifier_item_harpoon_custom_cd:IsDebuff() return true end



modifier_item_harpoon_custom_speed = class({})
function modifier_item_harpoon_custom_speed:IsHidden() return true end
function modifier_item_harpoon_custom_speed:IsPurgable() return false end
function modifier_item_harpoon_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_item_harpoon_custom_speed:GetModifierAttackSpeedBonus_Constant()
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury") then return end
if self:GetParent():HasModifier("modifier_custom_juggernaut_blade_fury_mini") then return end
if self:GetParent():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end

return 700
end

function modifier_item_harpoon_custom_speed:OnCreated(table)
if not IsServer() then return end

self.parent = self:GetParent()
self.ability = self:GetAbility()
self.name = self.ability:GetName()

self:StartIntervalThink(0.2)
end

function modifier_item_harpoon_custom_speed:OnIntervalThink()
if not IsServer() then return end

local item = self.parent:FindItemInInventory(self.name)

if not item or item:IsInBackpack() or self.parent:IsRangedAttacker() or not self.ability then 
    self:Destroy()
end

end






modifier_item_harpoon_custom_slow = class({})
function modifier_item_harpoon_custom_slow:IsHidden() return false end
function modifier_item_harpoon_custom_slow:IsPurgable() return true end
function modifier_item_harpoon_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_item_harpoon_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return -100
end

