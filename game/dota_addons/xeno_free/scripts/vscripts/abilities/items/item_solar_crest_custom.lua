LinkLuaModifier("modifier_item_solar_crest_custom", "abilities/items/item_solar_crest_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_solar_crest_custom_debuff", "abilities/items/item_solar_crest_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_solar_crest_custom_speed", "abilities/items/item_solar_crest_custom", LUA_MODIFIER_MOTION_NONE)


item_solar_crest_custom = class({})

function item_solar_crest_custom:GetIntrinsicModifierName()
	return "modifier_item_solar_crest_custom"
end


function item_solar_crest_custom:OnSpellStart()
if not IsServer() then return end 

self:GetCursorTarget():EmitSound("Item.StarEmblem.Enemy")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_solar_crest_custom_debuff", {duration = self:GetSpecialValueFor("duration")})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_solar_crest_custom_speed", {duration = self:GetSpecialValueFor("duration")})
self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_solar_crest_custom_debuff", {duration = self:GetSpecialValueFor("duration")})

end 


modifier_item_solar_crest_custom = class({})

function modifier_item_solar_crest_custom:IsHidden() return true end
function modifier_item_solar_crest_custom:IsPurgable() return false end
function modifier_item_solar_crest_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_solar_crest_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }

    return funcs
end


function modifier_item_solar_crest_custom:GetModifierPhysicalArmorBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_armor") end
end

function modifier_item_solar_crest_custom:GetModifierConstantManaRegen()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_mana_regen_pct") end
end



function modifier_item_solar_crest_custom:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
end


function modifier_item_solar_crest_custom:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
end


function modifier_item_solar_crest_custom:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_all_stats") end
end


function modifier_item_solar_crest_custom:GetModifierMoveSpeedBonus_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("self_movement_speed") end
end




modifier_item_solar_crest_custom_debuff = class({})
function modifier_item_solar_crest_custom_debuff:IsHidden() return false end
function modifier_item_solar_crest_custom_debuff:IsPurgable() return true end
function modifier_item_solar_crest_custom_debuff:IsDebuff() return true end 

function modifier_item_solar_crest_custom_debuff:OnCreated(table)

self.armor = self:GetAbility():GetSpecialValueFor("target_armor")

self.move = 0 

if self:GetCaster() ~= self:GetParent() then
    self.move = self:GetAbility():GetSpecialValueFor("target_movement_speed")
end 

if not IsServer() then return end

local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
self:AddParticle( nFXIndex, false, false, -1, false, true )

end

function modifier_item_solar_crest_custom_debuff:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}

end
function modifier_item_solar_crest_custom_debuff:GetModifierPhysicalArmorBonus()
return self.armor
end 

function modifier_item_solar_crest_custom_debuff:GetModifierMoveSpeedBonus_Percentage()
return self.move
end 




modifier_item_solar_crest_custom_speed = class({})
function modifier_item_solar_crest_custom_speed:IsHidden() return true end
function modifier_item_solar_crest_custom_speed:IsPurgable() return false end

function modifier_item_solar_crest_custom_speed:OnCreated(table)

self.attack = self:GetAbility():GetSpecialValueFor("self_attack_speed") 

end

function modifier_item_solar_crest_custom_speed:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
}

end

function modifier_item_solar_crest_custom_speed:GetModifierAttackSpeedBonus_Constant()
return self.attack
end 