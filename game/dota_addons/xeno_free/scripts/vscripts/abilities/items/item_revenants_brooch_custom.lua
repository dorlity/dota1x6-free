LinkLuaModifier("modifier_revenants_brooch_custom", "abilities/items/item_revenants_brooch_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_revenants_brooch_custom_counter", "abilities/items/item_revenants_brooch_custom", LUA_MODIFIER_MOTION_NONE)

item_revenants_brooch_custom = class({})

function item_revenants_brooch_custom:GetIntrinsicModifierName()
    return "modifier_revenants_brooch_custom"
end

function item_revenants_brooch_custom:GetManaCost(level)
    if self and self:GetCaster() and self:GetCaster():HasModifier("modifier_revenants_brooch_custom_counter") then return 0 end

    return self.BaseClass.GetManaCost(self, level)
end


function item_revenants_brooch_custom:GetAbilityTextureName()
    if self:GetCaster():HasModifier("modifier_revenants_brooch_custom_counter") then
        return "item_revenants_brooch_active"
    end
   return "item_revenants_brooch"
end



function item_revenants_brooch_custom:OnToggle()
local caster = self:GetCaster()

if caster:HasModifier("modifier_revenants_brooch_custom_counter") then
    caster:RemoveModifierByName("modifier_revenants_brooch_custom_counter")
else
    caster:AddNewModifier(caster,self,"modifier_revenants_brooch_custom_counter", {})
    caster:EmitSound("Item.Brooch.Cast")
end


self:StartCooldown(0.5)
end



modifier_revenants_brooch_custom = class({})

function modifier_revenants_brooch_custom:IsHidden()
    return true
end

function modifier_revenants_brooch_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_revenants_brooch_custom:GetModifierPreAttack_BonusDamage()
    return self.bonus_damage
end


function modifier_revenants_brooch_custom:OnCreated()

self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
self.lifesteal = self:GetAbility():GetSpecialValueFor("spell_lifesteal")/100
self.lifesteal_creeps = self:GetAbility():GetSpecialValueFor("spell_lifesteal_creep")
end


function modifier_revenants_brooch_custom:OnTakeDamage(params)
if params.unit == self:GetParent() then return end
if params.attacker ~= self:GetParent() then return end
if params.inflictor == nil then return end
if self:GetParent():IsIllusion() then return end
if not params.unit then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end
if params.unit:IsIllusion() then return end
if (params.unit:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() > 2000 then return end

local lifesteal = self.lifesteal*params.damage

if not params.unit:IsHero() then
    lifesteal = lifesteal/self.lifesteal_creeps
end

self:GetParent():GenericHeal(lifesteal, self:GetAbility(), true, "particles/items3_fx/octarine_core_lifesteal.vpcf")

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
self.mana_cost = self:GetAbility():GetSpecialValueFor("manacost_per_hit")/100

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
if self:GetParent():GetMana() < self.mana_cost*self:GetParent():GetMaxMana() then return end

    if not self:GetAbility() then return "" end
    return "particles/items_fx/misery_projectile.vpcf"
end

function modifier_revenants_brooch_custom_counter:GetOverrideAttackMagical()
if self:GetParent():GetMana() < self.mana_cost*self:GetParent():GetMaxMana() then return 0 end

if not self:GetAbility() then return 0 end
return 1

end

function modifier_revenants_brooch_custom_counter:GetModifierTotalDamageOutgoing_Percentage(event)
local parent = self:GetParent()
if event.inflictor then return 0 end
if event.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
if event.damage_type == DAMAGE_TYPE_MAGICAL then return 0 end
if not self:GetAbility() then return 0 end
if self:GetParent():GetMana() < self.mana_cost*self:GetParent():GetMaxMana() then return 0 end

self:GetParent():SetMana(math.max(1, self:GetParent():GetMana() - self.mana_cost*self:GetParent():GetMaxMana()))

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


return -200
end



function modifier_revenants_brooch_custom_counter:CheckState()
if self:GetParent():GetMana() < self.mana_cost*self:GetParent():GetMaxMana() then return {} end

if not self:GetAbility() then return {} end

return {
    [MODIFIER_STATE_CANNOT_MISS] = true,
    [MODIFIER_STATE_CANNOT_TARGET_BUILDINGS] = true
}
end

function modifier_revenants_brooch_custom_counter:GetEffectName()

    return "particles/items5_fx/revenant_brooch.vpcf"
end

function modifier_revenants_brooch_custom_counter:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end




