LinkLuaModifier("modifier_item_medallion_of_courage_custom", "abilities/items/item_medallion_of_courage_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_medallion_of_courage_custom_debuff", "abilities/items/item_medallion_of_courage_custom", LUA_MODIFIER_MOTION_NONE)

item_medallion_of_courage_custom = class({})

function item_medallion_of_courage_custom:GetIntrinsicModifierName()
	return "modifier_item_medallion_of_courage_custom"
end


function item_medallion_of_courage_custom:OnSpellStart()
if not IsServer() then return end 

self:GetCursorTarget():EmitSound("DOTA_Item.MedallionOfCourage.Activate")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_medallion_of_courage_custom_debuff", {duration = self:GetSpecialValueFor("duration")})
self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_medallion_of_courage_custom_debuff", {duration = self:GetSpecialValueFor("duration")})

end 


modifier_item_medallion_of_courage_custom = class({})

function modifier_item_medallion_of_courage_custom:IsHidden() return true end
function modifier_item_medallion_of_courage_custom:IsPurgable() return false end
function modifier_item_medallion_of_courage_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_medallion_of_courage_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end





function modifier_item_medallion_of_courage_custom:GetModifierPhysicalArmorBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_armor") end
end

function modifier_item_medallion_of_courage_custom:GetModifierConstantManaRegen()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_mana_regen_pct") end
end






modifier_item_medallion_of_courage_custom_debuff = class({})
function modifier_item_medallion_of_courage_custom_debuff:IsHidden() return false end
function modifier_item_medallion_of_courage_custom_debuff:IsPurgable() return true end
function modifier_item_medallion_of_courage_custom_debuff:IsDebuff() return true end 

function modifier_item_medallion_of_courage_custom_debuff:OnCreated(table)

self.armor = self:GetAbility():GetSpecialValueFor("armor_reduction")

self.move = 0 

if self:GetCaster() ~= self:GetParent() then
    self.move = self:GetAbility():GetSpecialValueFor("movespeed_slow")
end 

if not IsServer() then return end

local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/medallion_of_courage.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
self:AddParticle( nFXIndex, false, false, -1, false, true )

end

function modifier_item_medallion_of_courage_custom_debuff:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end
function modifier_item_medallion_of_courage_custom_debuff:GetModifierPhysicalArmorBonus()
return self.armor
end 

function modifier_item_medallion_of_courage_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.move
end 