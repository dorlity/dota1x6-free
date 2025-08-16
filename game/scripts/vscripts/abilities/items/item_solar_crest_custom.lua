LinkLuaModifier("modifier_item_solar_crest_custom", "abilities/items/item_solar_crest_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_solar_crest_custom_speed", "abilities/items/item_solar_crest_custom", LUA_MODIFIER_MOTION_NONE)


item_solar_crest_custom = class({})

function item_solar_crest_custom:GetIntrinsicModifierName()
return "modifier_item_solar_crest_custom"
end

function item_solar_crest_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items3_fx/star_emblem_friend.vpcf", context )
PrecacheResource( "particle","particles/items2_fx/pavise_friend.vpcf", context )
PrecacheResource( "particle","particles/general/generic_armor_reduction.vpcf", context )
PrecacheResource( "particle","particles/items/pavise_shield.vpcf", context )
end


function item_solar_crest_custom:GetBehavior()
if not IsSoloMode() then 
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end


function item_solar_crest_custom:OnSpellStart()
local caster = self:GetCaster()
local target = caster
if self:GetCursorTarget() then
    target = self:GetCursorTarget()
end

target:EmitSound("Item.Pavise.Target")
caster:EmitSound("Item.Star_emblem_cast")
target:AddNewModifier(caster, self, "modifier_item_solar_crest_custom_speed", {duration = self:GetSpecialValueFor("duration")})
end 


modifier_item_solar_crest_custom = class({})

function modifier_item_solar_crest_custom:IsHidden() return true end
function modifier_item_solar_crest_custom:IsPurgable() return false end
function modifier_item_solar_crest_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_solar_crest_custom:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_MANA_BONUS,
    MODIFIER_PROPERTY_HEALTH_BONUS,
    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}
end

function modifier_item_solar_crest_custom:OnCreated()
self.ability = self:GetAbility()

self.armor = self.ability:GetSpecialValueFor("bonus_armor")
self.mana = self.ability:GetSpecialValueFor("bonus_mana")
self.health = self.ability:GetSpecialValueFor("bonus_health")
self.stats =  self.ability:GetSpecialValueFor("bonus_all_stats")
self.move = self.ability:GetSpecialValueFor("self_movement_speed")
end

function modifier_item_solar_crest_custom:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_item_solar_crest_custom:GetModifierManaBonus()
return self.mana
end

function modifier_item_solar_crest_custom:GetModifierHealthBonus()
return self.health
end

function modifier_item_solar_crest_custom:GetModifierBonusStats_Strength()
return self.stats
end

function modifier_item_solar_crest_custom:GetModifierBonusStats_Agility()
return self.stats
end

function modifier_item_solar_crest_custom:GetModifierBonusStats_Intellect()
return self.stats
end

function modifier_item_solar_crest_custom:GetModifierMoveSpeedBonus_Constant()
return self.move
end





modifier_item_solar_crest_custom_speed = class({})
function modifier_item_solar_crest_custom_speed:IsHidden() return false end
function modifier_item_solar_crest_custom_speed:IsPurgable() return true end

function modifier_item_solar_crest_custom_speed:OnCreated( params )
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()

self.max_shield = self.ability:GetSpecialValueFor("absorb_amount")

self.attack = self.ability:GetSpecialValueFor("target_attack_speed")
self.move = self.ability:GetSpecialValueFor("target_movement_speed")

self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")

if not IsServer() then return end
self:SetStackCount(self.max_shield)
self.RemoveForDuel = true

self.nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/star_emblem_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true )
self:AddParticle( self.nFXIndex, false, false, -1, false, true )

self.particle = ParticleManager:CreateParticle("particles/items/pavise_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 3, Vector(115, 115, 115))
self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_item_solar_crest_custom_speed:OnRefresh()
self.max_shield = self.ability:GetSpecialValueFor("absorb_amount")

if not IsServer() then return end
self:SetStackCount(self.max_shield)
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


function modifier_item_solar_crest_custom_speed:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
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

end


function modifier_item_solar_crest_custom_speed:GetModifierIncomingDamageConstant(params)

if not IsServer() then return end

if self:GetStackCount() == 0 then return end
if params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
    ParticleManager:DestroyParticle(self.nFXIndex, false)
    ParticleManager:ReleaseParticleIndex(self.nFXIndex)

    self.nFXIndex2 = ParticleManager:CreateParticle( "particles/general/generic_armor_reduction.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
    ParticleManager:SetParticleControlEnt( self.nFXIndex2, 1, self.parent, PATTACH_ABSORIGIN_FOLLOW, nil, self.parent:GetAbsOrigin(), true )
    self:AddParticle( self.nFXIndex2, false, false, -1, false, true )

    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)

    self.parent:EmitSound("Item.Star_emblem_break")
    return 0
end

return -damage
end

