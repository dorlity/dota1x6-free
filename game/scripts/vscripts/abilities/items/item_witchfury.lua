LinkLuaModifier("item_witchfury_passive", "abilities/items/item_witchfury", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_witchfury_root", "abilities/items/item_witchfury", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("item_witchfury_poison", "abilities/items/item_witchfury", LUA_MODIFIER_MOTION_NONE)

item_witchfury = class({})


function item_witchfury:GetIntrinsicModifierName()
return "item_witchfury_passive"
end






item_witchfury_passive = class({})
function item_witchfury_passive:IsHidden() return true end
function item_witchfury_passive:IsPurgable() return false end
function item_witchfury_passive:RemoveOnDeath() return false end
function item_witchfury_passive:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end


function item_witchfury_passive:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_EVENT_ON_ATTACK,
    MODIFIER_EVENT_ON_TAKEDAMAGE
    
}
end

function item_witchfury_passive:GetModifierBonusStats_Intellect()
if not self:GetAbility() then return end
return self:GetAbility():GetSpecialValueFor("int_bonus")
end

function item_witchfury_passive:GetModifierBonusStats_Strength()
if not self:GetAbility() then return end
return self:GetAbility():GetSpecialValueFor("str_bonus")
end
function item_witchfury_passive:GetModifierBonusStats_Agility()
if not self:GetAbility() then return end
return self:GetAbility():GetSpecialValueFor("agi_bonus")
end

function item_witchfury_passive:GetModifierAttackSpeedBonus_Constant()
if not self:GetAbility() then return end
return self:GetAbility():GetSpecialValueFor("speed_bonus")
end
function item_witchfury_passive:GetModifierPhysicalArmorBonus()
if not self:GetAbility() then return end
return self:GetAbility():GetSpecialValueFor("armor_bonus")
end
function item_witchfury_passive:GetModifierProjectileSpeedBonus()
if not self:GetAbility() then return end
return self:GetAbility():GetSpecialValueFor("proj_bonus")
end




function item_witchfury_passive:OnCreated()
  self.record = nil
  self.root_duration = self:GetAbility():GetSpecialValueFor("root")
  self.damage_duration = self:GetAbility():GetSpecialValueFor("damage_duration")
end


function item_witchfury_passive:OnAttack(params)
if not IsServer() then return end
if not self:GetAbility() then return end
if self:GetParent():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end
if self:GetParent():HasModifier("modifier_item_witch_blade") or self:GetParent():HasModifier("modifier_revenants_brooch_custom") then return end
if not self:GetParent():IsRealHero() then return end
if params.attacker ~= self:GetParent() then return end
if not self:GetAbility():IsFullyCastable() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end


self.record = params.record
self:GetAbility():UseResources(false, false, false, true)
end


function item_witchfury_passive:OnAttackLanded(params)
if not IsServer() then return end
if not self:GetParent():IsRealHero() then return end
if params.attacker ~= self:GetParent() then return end
if params.record ~= self.record then return end
if not self:GetAbility() then return end

params.target:EmitSound("Item.WitchBlade.Target")

params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "item_witchfury_root", {duration = self.root_duration})
params.target:AddNewModifier(self:GetParent(), self:GetAbility(), "item_witchfury_poison", {duration = self.damage_duration})
self.record = nil
end


function item_witchfury_passive:CheckState()
local state = {}
if not self:GetParent():IsRealHero() then return end
if self:GetParent():HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end
    
    if self:GetAbility():IsFullyCastable() then
        state = {[MODIFIER_STATE_CANNOT_MISS] = true}
    end

    return state
end




item_witchfury_root = class({})
function item_witchfury_root:IsHidden() return false end
function item_witchfury_root:IsPurgable() return true end

function item_witchfury_root:OnCreated(table)
if not IsServer() then return end

self.ground_particle = ParticleManager:CreateParticle("particles/sf_ulti_root.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.ground_particle, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(self.ground_particle, false, false, -1, true, false)

end

function item_witchfury_root:CheckState()
return
  {
    [MODIFIER_STATE_ROOTED] = true
  }

end




item_witchfury_poison = class({})
function item_witchfury_poison:IsHidden() return false end
function item_witchfury_poison:IsPurgable() return true end
function item_witchfury_poison:GetEffectName() return "particles/items3_fx/witch_blade_debuff.vpcf" end

function item_witchfury_poison:OnCreated(table)
self.damage = self:GetAbility():GetSpecialValueFor("int_damage")
self.interval = self:GetAbility():GetSpecialValueFor("interval")
self.slow = self:GetAbility():GetSpecialValueFor("slow")

if not IsServer() then return end
self:StartIntervalThink(self.interval)
end


function item_witchfury_poison:OnIntervalThink()
if not IsServer() then return end

local damage = self:GetCaster():GetIntellect()*self.damage

local damageTable = { victim = self:GetParent(), attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility(), damage_flags = DOTA_DAMAGE_FLAG_NONE }
ApplyDamage(damageTable)

SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), damage, nil)
  

end


function item_witchfury_poison:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function item_witchfury_poison:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end