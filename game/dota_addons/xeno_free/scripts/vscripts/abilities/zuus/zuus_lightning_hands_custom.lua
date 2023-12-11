LinkLuaModifier("modifier_zuus_lightning_hands_custom_tracker", "abilities/zuus/zuus_lightning_hands_custom" , LUA_MODIFIER_MOTION_NONE)

zuus_lightning_hands_custom = class({})




function zuus_lightning_hands_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasShard() then
        self:SetHidden(true)       
        if not self:IsTrained() then
            self:SetLevel(1)
        end
    else
        self:SetHidden(true)
    end
end

function zuus_lightning_hands_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end


function zuus_lightning_hands_custom:GetIntrinsicModifierName()
return "modifier_zuus_lightning_hands_custom_tracker"
end



modifier_zuus_lightning_hands_custom_tracker = class({})
function modifier_zuus_lightning_hands_custom_tracker:IsHidden() return false end
function modifier_zuus_lightning_hands_custom_tracker:IsPurgable() return false end
function modifier_zuus_lightning_hands_custom_tracker:OnCreated(table)
self.damage = self:GetAbility():GetSpecialValueFor("damage")
self.damage_illusions = self:GetAbility():GetSpecialValueFor("damage_illusions")
end

function modifier_zuus_lightning_hands_custom_tracker:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_EVENT_ON_ATTACK_LANDED,
    MODIFIER_PROPERTY_TOOLTIP,
    MODIFIER_PROPERTY_TOOLTIP2
}
end


function modifier_zuus_lightning_hands_custom_tracker:GetModifierAttackRangeBonus()
return self:GetAbility():GetSpecialValueFor("attack_range")
end


function modifier_zuus_lightning_hands_custom_tracker:OnAttackLanded(params)
if not IsServer() then return end
if self:GetParent() ~= params.attacker then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end
if params.target:IsMagicImmune() then return end

local arc = self:GetParent():FindAbilityByName("zuus_arc_lightning_custom")

if not arc then return end


arc:StartArc(params.target, arc:GetSpecialValueFor("jump_count"), true, 1)

end


function modifier_zuus_lightning_hands_custom_tracker:OnTooltip()
return self.damage
end

function modifier_zuus_lightning_hands_custom_tracker:OnTooltip2()
return self.damage_illusions
end