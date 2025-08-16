LinkLuaModifier("modifier_item_sheepstick_custom", "abilities/items/item_sheepstick_custom", LUA_MODIFIER_MOTION_NONE)


item_sheepstick_custom = class({})

function item_sheepstick_custom:GetIntrinsicModifierName()
return "modifier_item_sheepstick_custom"
end


function item_sheepstick_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end

end



function item_sheepstick_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()

if target:TriggerSpellAbsorb(self) then return end

if target:IsIllusion() and not target:HasModifier("modifier_chaos_knight_phantasm_illusion") then
    target:Kill(self, caster)
    return
end

local duration = self:GetSpecialValueFor("sheep_duration")
if not IsSoloMode() then
    duration = self:GetSpecialValueFor("duration_duo")
end

target:AddNewModifier(caster, self, "modifier_sheepstick_debuff", {duration = (1 - target:GetStatusResistance())*duration})
end 





modifier_item_sheepstick_custom = class({})

function modifier_item_sheepstick_custom:IsHidden() return true end
function modifier_item_sheepstick_custom:IsPurgable() return false end
function modifier_item_sheepstick_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_sheepstick_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

}
end



function modifier_item_sheepstick_custom:OnCreated()

self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.int = self.ability:GetSpecialValueFor("bonus_intellect")
self.regen = self.ability:GetSpecialValueFor("bonus_mana_regen")
end 


function modifier_item_sheepstick_custom:GetModifierBonusStats_Intellect()
return self.int
end

function modifier_item_sheepstick_custom:GetModifierConstantManaRegen()
return self.regen
end
