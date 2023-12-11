LinkLuaModifier("modifier_item_spell_breaker", "abilities/items/item_spell_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spell_breaker_shield", "abilities/items/item_spell_breaker", LUA_MODIFIER_MOTION_NONE)

item_spell_breaker = class({})

function item_spell_breaker:GetIntrinsicModifierName()
	return "modifier_item_spell_breaker"
end


function item_spell_breaker:OnSpellStart()
if not IsServer() then return end 

self:GetCaster():EmitSound("Hero_Antimage.Counterspell.Cast")
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_spell_breaker_shield", {duration = self:GetSpecialValueFor("duration_active")})



end 


modifier_item_spell_breaker = class({})

function modifier_item_spell_breaker:IsHidden() return true end
function modifier_item_spell_breaker:IsPurgable() return false end
function modifier_item_spell_breaker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_spell_breaker:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }

    return funcs
end



function modifier_item_spell_breaker:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end
if self:GetParent():IsIllusion() then return end

--[[
if self:GetParent():GetHealthPercent() < self:GetAbility():GetSpecialValueFor("passive_health") and self:GetAbility():IsFullyCastable()
and not self:GetParent():PassivesDisabled() then 
    self:GetAbility():OnSpellStart()
    self:GetAbility():UseResources(true, false, false, true)
end 
]]

if not params.inflictor then return end
if params.attacker:IsBuilding() then return end

local mana = params.damage*self:GetAbility():GetSpecialValueFor("mana_restore_pct")/100

self:GetParent():GiveMana(mana)

end



function modifier_item_spell_breaker:GetModifierMagicalResistanceBonus()
if self:GetParent():HasModifier("modifier_item_bloodthorn") then return end
if self:GetParent():HasModifier("modifier_item_pipe_custom") then return end
if self:GetParent():HasModifier("modifier_item_eternal_shroud_custom") then return end
if self:GetParent():HasModifier("modifier_item_mage_slayer") then return end

    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_magical_armor") end
end


function modifier_item_spell_breaker:GetModifierBonusStats_Strength()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_strength") end
end

function modifier_item_spell_breaker:GetModifierBonusStats_Agility()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_agility") end
end

function modifier_item_spell_breaker:GetModifierBonusStats_Intellect()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_intellect") end
end


function modifier_item_spell_breaker:GetModifierConstantHealthRegen()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_health_regen") end
end







modifier_item_spell_breaker_shield = class({})
function modifier_item_spell_breaker_shield:IsHidden() return false end
function modifier_item_spell_breaker_shield:IsPurgable() return true end


function modifier_item_spell_breaker_shield:OnCreated(table)

self.damage = self:GetAbility():GetSpecialValueFor("resist_active")*-1
if not IsServer() then return end



local particle = ParticleManager:CreateParticle("particles/spell_breaker.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
ParticleManager:SetParticleControlEnt(particle,0,self:GetParent(),PATTACH_POINT_FOLLOW,"attach_hitloc",self:GetParent():GetAbsOrigin(),false)
ParticleManager:SetParticleControl(particle, 1 , Vector(100,1,1))
self:AddParticle(particle, false, false, -1, false, false)   



end

function modifier_item_spell_breaker_shield:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP
}

end
function modifier_item_spell_breaker_shield:GetModifierIncomingDamage_Percentage(params)

--if self:GetParent() ~= params.unit then return end
if params.inflictor == nil then return end
if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then return end

if  Not_spell_damage[params.inflictor:GetName()] then return end

return self.damage
end

function modifier_item_spell_breaker_shield:OnTooltip()
return self.damage
end