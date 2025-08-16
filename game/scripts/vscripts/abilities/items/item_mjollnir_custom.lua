LinkLuaModifier("modifier_item_mjollnir_custom", "abilities/items/item_mjollnir_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_custom_proc", "abilities/items/item_mjollnir_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_custom_passive", "abilities/items/item_mjollnir_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_custom_cd", "abilities/items/item_mjollnir_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_custom_active", "abilities/items/item_mjollnir_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_custom_slow", "abilities/items/item_mjollnir_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mjollnir_custom_active_cd", "abilities/items/item_mjollnir_custom", LUA_MODIFIER_MOTION_NONE)

item_mjollnir_custom = class({})

function item_mjollnir_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items_fx/chain_lightning.vpcf", context ) 
end

function item_mjollnir_custom:GetIntrinsicModifierName()
return "modifier_item_mjollnir_custom"
end

function item_mjollnir_custom:GetCastRange(vLocation, hTarget)
return self:GetSpecialValueFor("active_radius")
end

function item_mjollnir_custom:OnSpellStart()
local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("static_duration")

caster:EmitSound("DOTA_Item.Mjollnir.Activate")
caster:AddNewModifier(caster, self, "modifier_item_mjollnir_custom_active", {duration = duration})
end


modifier_item_mjollnir_custom_active = class({})
function modifier_item_mjollnir_custom_active:IsHidden() return false end
function modifier_item_mjollnir_custom_active:IsPurgable() return true end
function modifier_item_mjollnir_custom_active:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage = self.ability:GetSpecialValueFor("static_damage")
self.max = self.ability:GetSpecialValueFor("static_strikes")
self.radius = self.ability:GetSpecialValueFor("active_radius")
self.chance = self.ability:GetSpecialValueFor("static_chance")
self.duration = self.ability:GetSpecialValueFor("slow_duration")
self.interval = self.ability:GetSpecialValueFor("proc_interval") - FrameTime()
self.illusion = self.ability:GetSpecialValueFor("illusion_multiplier_pct")/100
self.cd = self.ability:GetSpecialValueFor("static_cooldown")

self.damageTable = {attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL}

if not IsServer() then return end
self.parent:EmitSound("DOTA_Item.Mjollnir.Loop")
self.parent:GenericParticle("particles/items2_fx/mjollnir_shield.vpcf", self)
self.parent:AddDamageEvent_inc(self, true)

self:StartIntervalThink(self.interval)
end

function modifier_item_mjollnir_custom_active:DealDamage()
if not IsServer() then return end
local count = 0

for _,target in pairs(self.parent:FindTargets(self.radius)) do
    if self.parent:CanEntityBeSeenByMyTeam(target) then

        hit = true
        count = count + 1

        self.damageTable.victim = target
        self.damageTable.damage = self.damage
        if target:IsIllusion() then
            self.damageTable.damage = self.damage*self.illusion
        end
        DoDamage(self.damageTable)
        target:AddNewModifier(self.parent, self.ability, "modifier_item_mjollnir_custom_slow", {duration = (1 - target:GetStatusResistance())*self.duration})
        target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")

        local nParticleIndex = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_POINT_FOLLOW, self.parent)
        ParticleManager:SetParticleControlEnt(nParticleIndex, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(nParticleIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(nParticleIndex)

        if count >= self.max then
            break
        end
    end
end

end

function modifier_item_mjollnir_custom_active:OnIntervalThink()
if not IsServer() then return end
self:DealDamage()
end

function modifier_item_mjollnir_custom_active:DamageEvent_inc(params)
if not IsServer() then return end
if self.parent:HasModifier("modifier_item_mjollnir_custom_active_cd") then return end
if self.parent ~= params.unit then return end
if self.parent:GetTeamNumber() == params.attacker:GetTeamNumber() then return end
if not params.attacker:IsUnit() then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if not RollPseudoRandomPercentage(self.chance, 4260, self.parent) then return end 

self:DealDamage()
self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_mjollnir_custom_active_cd", {duration = self.cd})
end

function modifier_item_mjollnir_custom_active:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("DOTA_Item.Mjollnir.Loop")
self.parent:EmitSound("DOTA_Item.Mjollnir.DeActivate")
end

function modifier_item_mjollnir_custom_active:GetStatusEffectName()
return "particles/status_fx/status_effect_mjollnir_shield.vpcf"
end

function modifier_item_mjollnir_custom_active:StatusEffectPriority()
return MODIFIER_PRIORITY_HIGH 
end






modifier_item_mjollnir_custom = class({})
function modifier_item_mjollnir_custom:IsHidden() return true end
function modifier_item_mjollnir_custom:IsPurgable() return false end
function modifier_item_mjollnir_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}
end

function modifier_item_mjollnir_custom:GetModifierPreAttack_BonusDamage()
return self.damage
end

function modifier_item_mjollnir_custom:GetModifierAttackSpeedBonus_Constant()
return self.speed
end

function modifier_item_mjollnir_custom:CheckState()
if not self.parent:HasModifier("modifier_item_mjollnir_custom_proc") then return end 
return
{
    [MODIFIER_STATE_CANNOT_MISS] = true
}
end

function modifier_item_mjollnir_custom:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
self.damage = self.ability:GetSpecialValueFor("bonus_damage")
self.chance = self.ability:GetSpecialValueFor("chain_chance")
self.cd = self.ability:GetSpecialValueFor("chain_cooldown")

self.records = {}

if not IsServer() then return end
if not self.parent:IsRealHero() then return end
self:RollProc()

self.parent:AddRecordDestroyEvent(self, true)
self.parent:AddAttackStartEvent_out(self)
self.parent:AddAttackEvent_out(self, true)
end

function modifier_item_mjollnir_custom:RecordDestroyEvent( params )
if not self.records[params.record] then return end
self.records[params.record] = nil
end

function modifier_item_mjollnir_custom:RollProc()
if not IsServer() then return end
if self.parent:HasModifier("modifier_item_mjollnir_custom_cd") then return end
if not RollPseudoRandomPercentage(self.chance,4259,self.parent) then return end 

self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_mjollnir_custom_proc", {duration = 3})
end


function modifier_item_mjollnir_custom:AttackStartEvent_out(params)
if not IsServer() then return end 
if not params.target:IsUnit() then return end 
if self.parent ~= params.attacker then return end 

if self.parent:HasModifier("modifier_item_mjollnir_custom_proc") then 
    self.records[params.record] = true
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_mjollnir_custom_cd", {duration = self.cd})
end

self.parent:RemoveModifierByName("modifier_item_mjollnir_custom_proc")

self:RollProc()
end

function modifier_item_mjollnir_custom:AttackEvent_out(params)
if not IsServer() then return end 
if not params.target:IsUnit() then return end 
if self.parent ~= params.attacker then return end 
if not self.records[params.record] then return end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_mjollnir_custom_passive", {target = params.target:entindex()})
params.target:EmitSound("Item.Maelstrom.Chain_Lightning")
end


modifier_item_mjollnir_custom_passive = class({})
function modifier_item_mjollnir_custom_passive:IsHidden() return true end
function modifier_item_mjollnir_custom_passive:IsPurgable() return false end
function modifier_item_mjollnir_custom_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_mjollnir_custom_passive:OnCreated(table)

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage = self.ability:GetSpecialValueFor("chain_damage")
self.radius = self.ability:GetSpecialValueFor("chain_radius")
self.max = self.ability:GetSpecialValueFor("chain_strikes")
self.interval = self.ability:GetSpecialValueFor("chain_delay")
self.illusion = self.ability:GetSpecialValueFor("illusion_multiplier_pct")/100

self.damageTable = {attacker = self.parent, ability = self.ability, damage_type = DAMAGE_TYPE_MAGICAL, damage = self.damage}
if not IsServer() then return end

self.last_target = self.parent
if table.target then
    self.first_target = EntIndexToHScript(table.target)
end
self.targets = {}

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_item_mjollnir_custom_passive:OnIntervalThink()
if not IsServer() then return end

local pos = self.last_target:GetAbsOrigin()
if self.first_target then
    pos = self.first_target:GetAbsOrigin()
    self.first_target = nil
end

local targets = self.parent:FindTargets(self.radius, pos)
local new_unit = nil

for _,target in pairs(targets) do
    if not self.targets[target:entindex()] then
        self.targets[target:entindex()] = true
        new_unit = target
        break
    end
end

if not new_unit then
    self:Destroy()
    return
end

self.damageTable.victim = new_unit
if new_unit:IsIllusion() then
    self.damageTable.damage = self.damage*self.illusion
else
    self.damageTable.damage = self.damage
end

if self.last_target and not self.last_target:IsNull() then
    local nParticleIndex = ParticleManager:CreateParticle("particles/items_fx/chain_lightning.vpcf", PATTACH_POINT_FOLLOW, self.last_target)
    ParticleManager:SetParticleControlEnt(nParticleIndex, 0, self.last_target, PATTACH_POINT_FOLLOW, "attach_hitloc", self.last_target:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(nParticleIndex, 1, new_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", new_unit:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(nParticleIndex)
end

if self:GetStackCount() > 0 then
    new_unit:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
end

DoDamage(self.damageTable)
self:IncrementStackCount()

if self:GetStackCount() >= self.max then
    self:Destroy()
    return
end

self.last_target = new_unit
end

modifier_item_mjollnir_custom_slow = class({})
function modifier_item_mjollnir_custom_slow:IsHidden() return true end
function modifier_item_mjollnir_custom_slow:IsPurgable() return false end
function modifier_item_mjollnir_custom_slow:OnCreated()
self.slow = self:GetAbility():GetSpecialValueFor("slow_proc")
end

function modifier_item_mjollnir_custom_slow:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_item_mjollnir_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end

modifier_item_mjollnir_custom_proc = class({})
function modifier_item_mjollnir_custom_proc:IsHidden() return true end
function modifier_item_mjollnir_custom_proc:IsPurgable() return false end

modifier_item_mjollnir_custom_cd = class({})
function modifier_item_mjollnir_custom_cd:IsHidden() return true end
function modifier_item_mjollnir_custom_cd:IsPurgable() return false end

modifier_item_mjollnir_custom_active_cd = class({})
function modifier_item_mjollnir_custom_active_cd:IsHidden() return true end
function modifier_item_mjollnir_custom_active_cd:IsPurgable() return false end

