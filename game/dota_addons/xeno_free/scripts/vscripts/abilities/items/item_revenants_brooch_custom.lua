LinkLuaModifier("modifier_revenants_brooch_custom", "abilities/items/item_revenants_brooch_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_revenants_brooch_custom_counter", "abilities/items/item_revenants_brooch_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_revenants_brooch_custom_reduction", "abilities/items/item_revenants_brooch_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_witch_blade_custom_slow", "abilities/items/item_revenants_brooch_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_witch_blade_custom_cooldown", "abilities/items/item_revenants_brooch_custom", LUA_MODIFIER_MOTION_NONE)

item_revenants_brooch_custom = class({})

function item_revenants_brooch_custom:GetIntrinsicModifierName()
    return "modifier_revenants_brooch_custom"
end

function item_revenants_brooch_custom:GetManaCost(level)
    if self and self:GetCaster() and self:GetCaster():HasModifier("modifier_revenants_brooch_custom_counter") then return 0 end

    return self.BaseClass.GetManaCost(self, level)
end

function item_revenants_brooch_custom:OnSpellStart()
local caster = self:GetCaster()

if caster:HasModifier("modifier_revenants_brooch_custom_counter") then
    caster:RemoveModifierByName("modifier_revenants_brooch_custom_counter")

    self:UseResources(false, false, false, true)
else
    caster:AddNewModifier(
        caster,
        self,
        "modifier_revenants_brooch_custom_counter",
        {
            duration = self:GetSpecialValueFor("active_duration")
        }
    )

    self:EndCooldown()
    self:StartCooldown(0.5)
end

caster:EmitSound("Item.Brooch.Cast")
end

modifier_revenants_brooch_custom = class({})

function modifier_revenants_brooch_custom:IsHidden()
    return true
end

function modifier_revenants_brooch_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_revenants_brooch_custom:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor("bonus_intellect")
end

function modifier_revenants_brooch_custom:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
end

function modifier_revenants_brooch_custom:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_revenants_brooch_custom:GetModifierProjectileSpeedBonus()
    return self:GetAbility():GetSpecialValueFor("projectile_speed")
end

function modifier_revenants_brooch_custom:OnAttackLanded(event)
    local parent = self:GetParent()

    if parent == event.target then return end
    if parent ~= event.attacker then return end
    if parent:IsIllusion() then return end
    if event.target:GetTeamNumber() == parent:GetTeamNumber() then return end
    if event.target:IsBuilding() or event.target:IsOther() then return end
    if parent:HasModifier("modifier_witch_blade_custom_cooldown") then return end
    if parent:HasItemInInventory("item_witch_blade") then return end
    if parent:HasModifier("item_witchfury_passive") then return end

    event.target:AddNewModifier(
        parent,
        self:GetAbility(),
        "modifier_item_witch_blade_slow",
        {
            duration = (1 - event.target:GetStatusResistance()) * self:GetAbility():GetSpecialValueFor("slow_duration")
        }
    )

    event.target:EmitSound("Item.WitchBlade.Target" .. (parent:IsRangedAttacker() and ".Ranged" or ""))

    parent:AddNewModifier(
        parent,
        self:GetAbility(),
        "modifier_witch_blade_custom_cooldown",
        {
            duration = self:GetAbility():GetSpecialValueFor("passive_cooldown")
        }
    )
end

modifier_revenants_brooch_custom_counter = class({})

function modifier_revenants_brooch_custom_counter:IsHidden()
    return false
end

function modifier_revenants_brooch_custom_counter:IsPurgable()
    return false
end

function modifier_revenants_brooch_custom_counter:OnCreated(params)
self.damage_reduce = self:GetAbility():GetSpecialValueFor("damage_reduction")

self:SetStackCount(self:GetAbility():GetSpecialValueFor("number_of_attacks"))
end

function modifier_revenants_brooch_custom_counter:OnDestroy()
    if IsServer() then self:GetAbility():UseResources(false, false, false, true) end
end

function modifier_revenants_brooch_custom_counter:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end


function modifier_revenants_brooch_custom_counter:GetModifierDamageOutgoing_Percentage()
return self.damage_reduce
end


function modifier_revenants_brooch_custom_counter:GetModifierProjectileName()
    if not self:GetAbility() then return "" end
    return "particles/items_fx/misery_projectile.vpcf"
end

function modifier_revenants_brooch_custom_counter:GetOverrideAttackMagical()
    if not self:GetAbility() then return 0 end
    return 1
end

function modifier_revenants_brooch_custom_counter:GetModifierTotalDamageOutgoing_Percentage(event)
local parent = self:GetParent()
if event.inflictor then return 0 end
if event.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
if event.damage_type == DAMAGE_TYPE_MAGICAL then return 0 end
if not self:GetAbility() then return 0 end


event.target:AddNewModifier(
    parent,
    self:GetAbility(),
    "modifier_revenants_brooch_custom_reduction",
    {
        duration = self:GetAbility():GetSpecialValueFor("reduction_duration")
    }
)


local damageTable = {
    attacker = parent,
    damage = event.original_damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    victim = event.target,
    ability = self:GetAbility(),
    damage_flags = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK
}
ApplyDamage(damageTable)

event.target:EmitSound("Item.Brooch.Target." .. (parent:IsRangedAttacker() and "Ranged" or "Melee"))

self:DecrementStackCount()
if self:GetStackCount() <= 0 then self:Destroy() end

return -200
end

function modifier_revenants_brooch_custom_counter:CheckState()
    if not self:GetAbility() then return {} end

    return {
        [MODIFIER_STATE_CANNOT_MISS] = true,
        [MODIFIER_STATE_CANNOT_TARGET_BUILDINGS] = true
    }
end

function modifier_revenants_brooch_custom_counter:GetEffectName()
    if not self:GetAbility() then return "" end

    return "particles/items5_fx/revenant_brooch.vpcf"
end

function modifier_revenants_brooch_custom_counter:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_revenants_brooch_custom_reduction = class({})

function modifier_revenants_brooch_custom_reduction:IsHidden()
    return false
end

function modifier_revenants_brooch_custom_reduction:IsPurgable()
    return true
end

function modifier_revenants_brooch_custom_reduction:IsDebuff()
    return true
end

function modifier_revenants_brooch_custom_reduction:OnCreated(params)
    self.mres = self:GetAbility():GetSpecialValueFor("mres_reduction")
end

function modifier_revenants_brooch_custom_reduction:OnRefresh(params)
    self.mres = self:GetAbility():GetSpecialValueFor("mres_reduction")
end

function modifier_revenants_brooch_custom_reduction:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
    }
end

function modifier_revenants_brooch_custom_reduction:GetModifierMagicalResistanceBonus(event)
    return -self.mres
end

modifier_witch_blade_custom_slow = class({})

function modifier_witch_blade_custom_slow:IsHidden()
    return false
end

function modifier_witch_blade_custom_slow:IsPurgable()
    return true
end

function modifier_witch_blade_custom_slow:IsDebuff()
    return true
end

function modifier_witch_blade_custom_slow:OnCreated(params)
    self.ability = self:GetAbility()
    self.slow = self.ability:GetSpecialValueFor("slow")
    self.int_damage_multiplier = self.ability:GetSpecialValueFor("int_damage_multiplier")

    if IsServer() then self:StartIntervalThink(1) end
end

function modifier_witch_blade_custom_slow:OnRefresh(params)
    self.ability = self:GetAbility()
    self.slow = self.ability:GetSpecialValueFor("slow")
    self.int_damage_multiplier = self.ability:GetSpecialValueFor("int_damage_multiplier")
end

function modifier_witch_blade_custom_slow:OnIntervalThink()
    local parent = self:GetParent()
    local caster = self:GetCaster()

    local damage = caster:GetIntellect() * self.int_damage_multiplier

    local damageTable = {
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        victim = parent,
        ability = self.ability
    }
    ApplyDamage(damageTable)

    SendOverheadEventMessage(
        nil,
        OVERHEAD_ALERT_BONUS_POISON_DAMAGE,
        parent,
        damage,
        nil
    )
end

function modifier_witch_blade_custom_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_witch_blade_custom_slow:GetModifierMoveSpeedBonus_Percentage()
    return -self.slow
end

function modifier_witch_blade_custom_slow:GetEffectName()
    return "particles/items3_fx/witch_blade_debuff.vpcf"
end

function modifier_witch_blade_custom_slow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_witch_blade_custom_cooldown = class({})

function modifier_witch_blade_custom_cooldown:IsHidden()
    return false
end

function modifier_witch_blade_custom_cooldown:IsPurgable()
    return false
end

function modifier_witch_blade_custom_cooldown:RemoveOnDeath()
    return false
end

function modifier_witch_blade_custom_cooldown:AllowIllusionDuplicate()
    return false
end

function modifier_witch_blade_custom_cooldown:IsDebuff()
    return true
end
