LinkLuaModifier("modifier_item_hood_of_defiance_custom", "abilities/items/item_hood_of_defiance_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hood_of_defiance_custom_active", "abilities/items/item_hood_of_defiance_custom", LUA_MODIFIER_MOTION_NONE)

item_hood_of_defiance_custom = class({})

function item_hood_of_defiance_custom:GetIntrinsicModifierName()
	return "modifier_item_hood_of_defiance_custom"
end

function item_hood_of_defiance_custom:OnSpellStart()
if not IsServer() then return end



	self:GetCaster():RemoveModifierByName("modifier_item_eternal_shroud_custom_active")
	self:GetCaster():RemoveModifierByName("modifier_item_pipe_custom_active")
	self:GetCaster():RemoveModifierByName("modifier_item_hood_of_defiance_custom_active")

	self:GetCaster():EmitSound("DOTA_Item.Pipe.Activate")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hood_of_defiance_custom_active", {duration = self:GetSpecialValueFor("barrier_duration")})
end

modifier_item_hood_of_defiance_custom = class({})

function modifier_item_hood_of_defiance_custom:IsHidden() return true end
function modifier_item_hood_of_defiance_custom:IsPurgable() return false end
function modifier_item_hood_of_defiance_custom:RemoveOnDeath() return false end
function modifier_item_hood_of_defiance_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_hood_of_defiance_custom:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_item_hood_of_defiance_custom:GetModifierConstantHealthRegen()

	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	end
end

function modifier_item_hood_of_defiance_custom:GetModifierMagicalResistanceBonus()
if self:GetParent():HasModifier("modifier_item_eternal_shroud_custom") then return end
if self:GetParent():HasModifier("modifier_item_pipe_custom") then return end
if self:GetParent():HasModifier("modifier_item_spell_breaker") then return end
if self:GetParent():HasModifier("modifier_item_mage_slayer") then return end
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_spell_resist")
	end
end

modifier_item_hood_of_defiance_custom_active = class({})

function modifier_item_hood_of_defiance_custom_active:IsDebuff() return false end
function modifier_item_hood_of_defiance_custom_active:IsHidden() return false end
function modifier_item_hood_of_defiance_custom_active:IsPurgable() return false end
function modifier_item_hood_of_defiance_custom_active:IsPurgeException() return false end

function modifier_item_hood_of_defiance_custom_active:OnCreated( params )
	if not IsServer() then return end
	self:SetStackCount(self:GetAbility():GetSpecialValueFor("barrier_block"))

	self.particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight_v2.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetParent():GetModelRadius() * 1.1, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_item_hood_of_defiance_custom_active:OnRefresh()
	if not IsServer() then return end
	self:SetStackCount(self:GetAbility():GetSpecialValueFor("barrier_block"))
end

function modifier_item_hood_of_defiance_custom_active:DeclareFunctions()
	return 
{
    MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
}
end



function modifier_item_hood_of_defiance_custom_active:GetModifierTotal_ConstantBlock(params)
if not IsServer() then return end
if self:GetParent() == params.attacker then return end
if self:GetStackCount() == 0 then return end
if self:GetParent():HasModifier("modifier_templar_assassin_refraction_custom_absorb") then return end
if self:GetParent():HasModifier("modifier_sven_warcry_custom_legendary") then return end
if params.damage_type ~= DAMAGE_TYPE_MAGICAL then return end

if self:GetStackCount() > params.damage then

    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
	return i
else
    local i = self:GetStackCount()
    self:Destroy()
    return i
end

end

