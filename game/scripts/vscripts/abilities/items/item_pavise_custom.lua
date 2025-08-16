LinkLuaModifier("modifier_item_pavise_custom", "abilities/items/item_pavise_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pavise_custom_active", "abilities/items/item_pavise_custom", LUA_MODIFIER_MOTION_NONE)

item_pavise_custom = class({})

function item_pavise_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle","particles/items/pavise_shield.vpcf", context )
end

function item_pavise_custom:GetIntrinsicModifierName()
return "modifier_item_pavise_custom"
end


function item_pavise_custom:GetBehavior()
if not IsSoloMode() then 
    return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end 
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
end



function item_pavise_custom:OnSpellStart()
local caster = self:GetCaster()
local target = caster
if self:GetCursorTarget() then
  target = self:GetCursorTarget()
end

target:EmitSound("Item.Pavise.Target")
target:AddNewModifier(caster, self, "modifier_item_pavise_custom_active", {duration = self:GetSpecialValueFor("duration")})
end



modifier_item_pavise_custom = class({})
function modifier_item_pavise_custom:IsHidden() return true end
function modifier_item_pavise_custom:IsPurgable() return false end
function modifier_item_pavise_custom:RemoveOnDeath() return false end
function modifier_item_pavise_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_pavise_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MANA_BONUS,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
}
end

function modifier_item_pavise_custom:OnCreated()
self.ability = self:GetAbility()

self.armor = self.ability:GetSpecialValueFor("bonus_armor")
self.mana = self.ability:GetSpecialValueFor("bonus_mana")
self.health = self.ability:GetSpecialValueFor("bonus_health")
end

function modifier_item_pavise_custom:GetModifierPhysicalArmorBonus()
return self.armor
end

function modifier_item_pavise_custom:GetModifierManaBonus()
return self.mana
end

function modifier_item_pavise_custom:GetModifierHealthBonus()
return self.health
end



modifier_item_pavise_custom_active = class({})
function modifier_item_pavise_custom_active:IsHidden() return false end
function modifier_item_pavise_custom_active:IsPurgable() return false end

function modifier_item_pavise_custom_active:OnCreated( params )
self.parent = self:GetParent()
self.caster = self:GetCaster()
self.ability = self:GetAbility()
self.max_shield = self.ability:GetSpecialValueFor("absorb_amount")

if not IsServer() then return end
self:SetStackCount(self.max_shield)

self.particle = ParticleManager:CreateParticle("particles/items/pavise_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
ParticleManager:SetParticleControl(self.particle, 0, self.parent:GetAbsOrigin())
ParticleManager:SetParticleControl(self.particle, 3, Vector(115, 115, 115))
self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_item_pavise_custom_active:OnRefresh()
self.max_shield = self.ability:GetSpecialValueFor("absorb_amount")

if not IsServer() then return end
self:SetStackCount(self.max_shield)
end

function modifier_item_pavise_custom_active:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
  MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
}
end


function modifier_item_pavise_custom_active:GetModifierIncomingPhysicalDamageConstant(params)

if IsClient() then 
  if params.report_max then 
    return self.max_shield 
  else 
    return self:GetStackCount()
  end 
end

end

function modifier_item_pavise_custom_active:GetModifierIncomingDamageConstant(params)
if not IsServer() then return end

if self:GetStackCount() == 0 then return end
if params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end

local damage = math.min(params.damage, self:GetStackCount())
self.parent:AddShieldInfo({shield_mod = self, healing = damage, healing_type = "shield"})

self:SetStackCount(self:GetStackCount() - damage)
if self:GetStackCount() <= 0 then
  self:Destroy()
end

return -damage
end
