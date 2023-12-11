LinkLuaModifier("modifier_item_boots_of_bearing_custom", "abilities/items/item_boots_of_bearing_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_boots_of_bearing_custom_active", "abilities/items/item_boots_of_bearing_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_boots_of_bearing_custom_haste", "abilities/items/item_boots_of_bearing_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_boots_of_bearing_custom_aura", "abilities/items/item_boots_of_bearing_custom", LUA_MODIFIER_MOTION_NONE)

item_boots_of_bearing_custom = class({})

function item_boots_of_bearing_custom:GetIntrinsicModifierName()
	return "modifier_item_boots_of_bearing_custom"
end

function item_boots_of_bearing_custom:OnSpellStart()
if not IsServer() then return end

local units = FindUnitsInRadius( self:GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST,false)
  
for _,unit in pairs(units) do 
    unit:AddNewModifier(self:GetCaster(), self, "modifier_item_boots_of_bearing_custom_active", {duration = self:GetSpecialValueFor("duration")})
    unit:AddNewModifier(self:GetCaster(), self, "modifier_item_boots_of_bearing_custom_haste", {duration = self:GetSpecialValueFor("bonus_ms_duration")})
end 

self:GetCaster():EmitSound("DOTA_Item.DoE.Activate")
end

modifier_item_boots_of_bearing_custom = class({})

function modifier_item_boots_of_bearing_custom:IsHidden() return true end
function modifier_item_boots_of_bearing_custom:IsPurgable() return false end
function modifier_item_boots_of_bearing_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_boots_of_bearing_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
    }

    return funcs
end


function modifier_item_boots_of_bearing_custom:OnCreated()

self.radius = self:GetAbility():GetSpecialValueFor("radius")
end 


function modifier_item_boots_of_bearing_custom:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_str") end
end

function modifier_item_boots_of_bearing_custom:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_int") end
end




function modifier_item_boots_of_bearing_custom:GetModifierMoveSpeedBonus_Constant()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_movement_speed") end
end





function modifier_item_boots_of_bearing_custom:IsAura() return true end

function modifier_item_boots_of_bearing_custom:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_item_boots_of_bearing_custom:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_item_boots_of_bearing_custom:GetModifierAura()
    return "modifier_item_boots_of_bearing_custom_aura"
end

function modifier_item_boots_of_bearing_custom:GetAuraRadius()
    return self.radius
end



modifier_item_boots_of_bearing_custom_aura = class({})
function modifier_item_boots_of_bearing_custom_aura:IsHidden() return false end
function modifier_item_boots_of_bearing_custom_aura:IsPurgable() return true end
function modifier_item_boots_of_bearing_custom_aura:OnCreated()

self.speed = self:GetAbility():GetSpecialValueFor("aura_movement_speed")
self.regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
end 

function modifier_item_boots_of_bearing_custom_aura:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end

function modifier_item_boots_of_bearing_custom_aura:GetModifierMoveSpeedBonus_Constant()
return self.speed
end

function modifier_item_boots_of_bearing_custom_aura:GetModifierConstantHealthRegen()
return self.regen
end










modifier_item_boots_of_bearing_custom_active = class({})
function modifier_item_boots_of_bearing_custom_active:IsHidden() return false end
function modifier_item_boots_of_bearing_custom_active:IsPurgable() return true end

function modifier_item_boots_of_bearing_custom_active:OnCreated(table)


self.attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed_pct")
self.move_speed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed_pct")

if not IsServer() then return end 

local particle_buff_fx = ParticleManager:CreateParticle("particles/items_fx/drum_of_endurance_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(particle_buff_fx, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControl(particle_buff_fx, 1, Vector(0,0,0))
self:AddParticle(particle_buff_fx, false, false, -1, false, false)
end

function modifier_item_boots_of_bearing_custom_active:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_item_boots_of_bearing_custom_active:GetModifierMoveSpeedBonus_Percentage()
return self.move_speed
end

function modifier_item_boots_of_bearing_custom_active:GetModifierAttackSpeedBonus_Constant()
return self.attack_speed
end


function modifier_item_boots_of_bearing_custom_active:CheckState()
return
{
    [MODIFIER_STATE_CANNOT_MISS] = true
}
end



modifier_item_boots_of_bearing_custom_haste = class({})
function modifier_item_boots_of_bearing_custom_haste:IsHidden() return true end
function modifier_item_boots_of_bearing_custom_haste:IsPurgable() return false end
function modifier_item_boots_of_bearing_custom_haste:CheckState()
return
{
    [MODIFIER_STATE_UNSLOWABLE] = true
}
end