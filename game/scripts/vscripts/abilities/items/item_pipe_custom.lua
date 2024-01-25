LinkLuaModifier("modifier_item_pipe_custom", "abilities/items/item_pipe_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe_custom_aura", "abilities/items/item_pipe_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_pipe_custom_active", "abilities/items/item_pipe_custom", LUA_MODIFIER_MOTION_NONE)

item_pipe_custom = class({})

function item_pipe_custom:GetIntrinsicModifierName()
	return "modifier_item_pipe_custom"
end

function item_pipe_custom:OnSpellStart()
	if not IsServer() then return end
	local radius = self:GetSpecialValueFor("barrier_radius")

	self:GetCaster():EmitSound("DOTA_Item.Pipe.Activate")

	local particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight_launch.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(particle)

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		
	for _, unit in pairs(units) do

		unit:RemoveModifierByName("modifier_item_eternal_shroud_custom_active")
		unit:RemoveModifierByName("modifier_item_pipe_custom_active")
		unit:RemoveModifierByName("modifier_item_hood_of_defiance_custom_active")
		unit:AddNewModifier(self:GetCaster(), self, "modifier_item_pipe_custom_active", {duration = self:GetSpecialValueFor("barrier_duration")})
	end
end

modifier_item_pipe_custom = class({})

function modifier_item_pipe_custom:IsHidden() return true end
function modifier_item_pipe_custom:IsPurgable() return false end
function modifier_item_pipe_custom:RemoveOnDeath() return false end
function modifier_item_pipe_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_pipe_custom:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_item_pipe_custom:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("health_regen")
	end
end

function modifier_item_pipe_custom:GetModifierMagicalResistanceBonus()
if self:GetParent():HasModifier("modifier_item_eternal_shroud_custom") then return end
if self:GetParent():HasModifier("modifier_item_spell_breaker") then return end
if self:GetParent():HasModifier("modifier_item_mage_slayer") then return end
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("magic_resistance")
	end
end

function modifier_item_pipe_custom:IsAura()	return true end
function modifier_item_pipe_custom:IsAuraActiveOnDeath() return false end
function modifier_item_pipe_custom:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_pipe_custom:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_pipe_custom:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_pipe_custom:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_pipe_custom:GetModifierAura() return "modifier_item_pipe_custom_aura" end

function modifier_item_pipe_custom:GetAuraEntityReject(hEntity)
return hEntity:IsRealHero() or not hEntity.owner or hEntity.owner ~= self:GetCaster()
end 


modifier_item_pipe_custom_aura = class({})

function modifier_item_pipe_custom_aura:IsPurgable() return false end

function modifier_item_pipe_custom_aura:OnCreated( params )
	self.aura_armor = self:GetAbility():GetSpecialValueFor("aura_armor")
	self.magic_resistance_aura = self:GetAbility():GetSpecialValueFor("magic_resistance_aura")
end

function modifier_item_pipe_custom_aura:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_item_pipe_custom_aura:GetModifierPhysicalArmorBonus()
	return self.aura_armor
end



function modifier_item_pipe_custom_aura:GetModifierMagicalResistanceBonus()
	return self.magic_resistance_aura
end



modifier_item_pipe_custom_active = class({})

function modifier_item_pipe_custom_active:IsDebuff() return false end
function modifier_item_pipe_custom_active:IsHidden() return false end
function modifier_item_pipe_custom_active:IsPurgable() return false end
function modifier_item_pipe_custom_active:IsPurgeException() return false end

function modifier_item_pipe_custom_active:OnCreated( params )
self.max_shield = self:GetAbility():GetSpecialValueFor("barrier_block")

if not IsServer() then return end
self:SetStackCount(self.max_shield)

self.particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight_v2.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetParent():GetModelRadius() * 1.1, 0, 0))
self:AddParticle(self.particle, false, false, -1, false, false)
end

function modifier_item_pipe_custom_active:OnRefresh()
self.max_shield = self:GetAbility():GetSpecialValueFor("barrier_block")

if not IsServer() then return end
self:SetStackCount(self.max_shield)
end

function modifier_item_pipe_custom_active:DeclareFunctions()
	return 
{
    MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,
}
end




--if self:GetParent():HasModifier("modifier_templar_assassin_refraction_custom_absorb") then return end
--if self:GetParent():HasModifier("modifier_sven_warcry_custom_legendary") then return end




function modifier_item_pipe_custom_active:GetModifierIncomingSpellDamageConstant(params)

if IsClient() then 
  if params.report_max then 
    return self.max_shield 
  else 
    return self:GetStackCount()
  end 
end


if not IsServer() then return end

if self:GetStackCount() == 0 then return end


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
