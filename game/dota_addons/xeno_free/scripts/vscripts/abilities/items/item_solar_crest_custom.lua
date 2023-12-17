LinkLuaModifier("modifier_item_solar_crest_custom", "abilities/items/item_solar_crest_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_solar_crest_custom_speed", "abilities/items/item_solar_crest_custom", LUA_MODIFIER_MOTION_NONE)


item_solar_crest_custom = class({})

function item_solar_crest_custom:GetIntrinsicModifierName()
	return "modifier_item_solar_crest_custom"
end


function item_solar_crest_custom:OnSpellStart()
if not IsServer() then return end 

self:GetCaster():EmitSound("Item.Pavise.Target")
self:GetCaster():EmitSound("Item.Star_emblem_cast")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_solar_crest_custom_speed", {duration = self:GetSpecialValueFor("duration")})

end 


modifier_item_solar_crest_custom = class({})

function modifier_item_solar_crest_custom:IsHidden() return true end
function modifier_item_solar_crest_custom:IsPurgable() return false end
function modifier_item_solar_crest_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_solar_crest_custom:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
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

function modifier_item_solar_crest_custom:GetModifierManaBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_mana") end
end

function modifier_item_solar_crest_custom:GetModifierHealthBonus()
    if self:GetAbility() then return self:GetAbility():GetSpecialValueFor("bonus_health") end
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






modifier_item_solar_crest_custom_speed = class({})
function modifier_item_solar_crest_custom_speed:IsHidden() return false end
function modifier_item_solar_crest_custom_speed:IsPurgable() return true end

function modifier_item_solar_crest_custom_speed:OnCreated( params )
self.max_shield = self:GetAbility():GetSpecialValueFor("absorb_amount")

self.attack = self:GetAbility():GetSpecialValueFor("target_attack_speed")
self.move = self:GetAbility():GetSpecialValueFor("target_movement_speed")

self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")

if not IsServer() then return end
self:SetStackCount(self.max_shield)

self.nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/star_emblem_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
self:AddParticle( self.nFXIndex, false, false, -1, false, true )

self.particle = ParticleManager:CreateParticle("particles/items2_fx/pavise_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

end



function modifier_item_solar_crest_custom_speed:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
if self:GetStackCount() == 0 then 
    bonus = self.bonus_attack
end 

return self.attack + bonus
end 

function modifier_item_solar_crest_custom_speed:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if self:GetStackCount() == 0 then 
    bonus = self.bonus_move
end   

return self.move + bonus
end 




function modifier_item_solar_crest_custom_speed:OnRefresh()
self.max_shield = self:GetAbility():GetSpecialValueFor("absorb_amount")

if not IsServer() then return end
self:SetStackCount(self.max_shield)
end



function modifier_item_solar_crest_custom_speed:DeclareFunctions()
return 
{
   -- MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end



function modifier_item_solar_crest_custom_speed:GetModifierIncomingPhysicalDamageConstant(params)

if IsClient() then 
  if params.report_max then 
    return self.max_shield 
  else 
    return self:GetStackCount()
  end 
end

if not IsServer() then return end

if self:GetStackCount() == 0 then return end
if params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)

    ParticleManager:DestroyParticle(self.nFXIndex, false)
    ParticleManager:ReleaseParticleIndex(self.nFXIndex)

    self.nFXIndex2 = ParticleManager:CreateParticle( "particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( self.nFXIndex2, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
    self:AddParticle( self.nFXIndex2, false, false, -1, false, true )

    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)

    self:GetCaster():EmitSound("Item.Star_emblem_break")
    return -i
end

end
