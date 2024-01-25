LinkLuaModifier("modifier_item_crimson_guard_custom", "abilities/items/item_crimson_guard_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_crimson_guard_custom_active", "abilities/items/item_crimson_guard_custom", LUA_MODIFIER_MOTION_NONE)

item_crimson_guard_custom = class({})

function item_crimson_guard_custom:GetIntrinsicModifierName()
	return "modifier_item_crimson_guard_custom"
end

function item_crimson_guard_custom:OnSpellStart()
	if not IsServer() then return end
	local radius = self:GetSpecialValueFor("bonus_aoe_radius")

	self:GetCaster():EmitSound("Item.CrimsonGuard.Cast")

	local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		
	--for _, unit in pairs(units) do
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_crimson_guard_custom_active", {duration = self:GetSpecialValueFor("duration")})
	--end
end

modifier_item_crimson_guard_custom = class({})

function modifier_item_crimson_guard_custom:IsHidden() return true end
function modifier_item_crimson_guard_custom:IsPurgable() return false end
function modifier_item_crimson_guard_custom:RemoveOnDeath() return false end
function modifier_item_crimson_guard_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end



function modifier_item_crimson_guard_custom:OnCreated(table)
	self.health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.regen = self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.chance = self:GetAbility():GetSpecialValueFor("block_chance")
	self.block = self:GetAbility():GetSpecialValueFor("block_damage_melee")
	--self.range_block = self:GetAbility():GetSpecialValueFor("block_damage_ranged")

end


function modifier_item_crimson_guard_custom:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
    	MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
	}
end


function modifier_item_crimson_guard_custom:GetModifierConstantHealthRegen()
	return self.regen
end

function modifier_item_crimson_guard_custom:GetModifierPhysicalArmorBonus()
	return self.armor
end


function modifier_item_crimson_guard_custom:GetModifierHealthBonus()
	return self.health
end


function modifier_item_crimson_guard_custom:GetModifierPhysical_ConstantBlock(params)
if not IsServer() then return end
if not RollPseudoRandomPercentage(self.chance, 2622,self:GetParent()) then return end
if self:GetParent() == params.attacker then return end
if params.inflictor then return end
if params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end

local block = self.block


return block
end







modifier_item_crimson_guard_custom_active = class({})

function modifier_item_crimson_guard_custom_active:IsDebuff() return false end
function modifier_item_crimson_guard_custom_active:IsHidden() return false end
function modifier_item_crimson_guard_custom_active:IsPurgable() return false end
function modifier_item_crimson_guard_custom_active:IsPurgeException() return false end

function modifier_item_crimson_guard_custom_active:OnCreated( params )
if not IsServer() then return end

self.reduce = self:GetAbility():GetSpecialValueFor("active_reduce")

local pfx = ParticleManager:CreateParticle("particles/items2_fx/vanguard_active.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControlEnt(pfx, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(pfx, false, false, 15, false, false)
end


function modifier_item_crimson_guard_custom_active:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
}
end




function modifier_item_crimson_guard_custom_active:GetModifierIncomingDamage_Percentage(params)
if params.inflictor then return end
if params.damage < 2 then return end

if IsServer() then 

	local forward = self:GetParent():GetAbsOrigin() - params.attacker:GetAbsOrigin()
	forward.z = 0
	forward = forward:Normalized()

	local particle_2 = ParticleManager:CreateParticle("particles/items/crimson_guard_hit.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle_2, 0, self:GetParent(), PATTACH_POINT, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle_2, 1, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlForward(particle_2, 1, forward)
	ParticleManager:SetParticleControlEnt(particle_2, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(particle_2)

	self:GetParent():EmitSound("Crimson.Damage")
end 

return self.reduce
end