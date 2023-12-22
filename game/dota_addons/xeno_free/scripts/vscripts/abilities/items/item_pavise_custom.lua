LinkLuaModifier("modifier_item_pavise_custom", "abilities/items/item_pavise_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pavise_custom_active", "abilities/items/item_pavise_custom", LUA_MODIFIER_MOTION_NONE)

item_pavise_custom = class({})

function item_pavise_custom:GetIntrinsicModifierName()
	return "modifier_item_pavise_custom"
end

function item_pavise_custom:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Item.Pavise.Target")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_pavise_custom_active", {duration = self:GetSpecialValueFor("duration")})
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

function modifier_item_pavise_custom:GetModifierManaBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_mana")
	end
end


function modifier_item_pavise_custom:GetModifierHealthBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health")
	end
end


function modifier_item_pavise_custom:GetModifierPhysicalArmorBonus()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_armor")
	end
end




modifier_item_pavise_custom_active = class({})

function modifier_item_pavise_custom_active:IsHidden() return false end
function modifier_item_pavise_custom_active:IsPurgable() return false end

function modifier_item_pavise_custom_active:OnCreated( params )
self.max_shield = self:GetAbility():GetSpecialValueFor("absorb_amount")

if not IsServer() then return end
self:SetStackCount(self.max_shield)

self.particle = ParticleManager:CreateParticle("particles/items2_fx/pavise_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

end

function modifier_item_pavise_custom_active:OnRefresh()
self.max_shield = self:GetAbility():GetSpecialValueFor("absorb_amount")

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

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:Destroy()
    return -i
end

end
