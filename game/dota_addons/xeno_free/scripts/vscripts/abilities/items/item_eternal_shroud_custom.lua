LinkLuaModifier("modifier_item_eternal_shroud_custom", "abilities/items/item_eternal_shroud_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_eternal_shroud_custom_active", "abilities/items/item_eternal_shroud_custom", LUA_MODIFIER_MOTION_NONE)

item_eternal_shroud_custom = class({})

function item_eternal_shroud_custom:GetIntrinsicModifierName()
	return "modifier_item_eternal_shroud_custom"
end

function item_eternal_shroud_custom:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():RemoveModifierByName("modifier_item_eternal_shroud_custom_active")
	self:GetCaster():RemoveModifierByName("modifier_item_pipe_custom_active")
	self:GetCaster():RemoveModifierByName("modifier_item_hood_of_defiance_custom_active")

	local particle = ParticleManager:CreateParticle("particles/items2_fx/eternal_shroud_launch.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(particle)
	self:GetCaster():EmitSound("DOTA_Item.Pipe.Activate")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_eternal_shroud_custom_active", {duration = self:GetSpecialValueFor("barrier_duration")})
end

modifier_item_eternal_shroud_custom = class({})

function modifier_item_eternal_shroud_custom:IsHidden() return true end
function modifier_item_eternal_shroud_custom:IsPurgable() return false end
function modifier_item_eternal_shroud_custom:RemoveOnDeath() return false end
function modifier_item_eternal_shroud_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_eternal_shroud_custom:DeclareFunctions()
	return 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

function modifier_item_eternal_shroud_custom:GetModifierConstantHealthRegen()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	end
end
function modifier_item_eternal_shroud_custom:GetModifierBonusStats_Strength()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_strength")
	end
end


function modifier_item_eternal_shroud_custom:GetModifierMagicalResistanceBonus()
if self:GetParent():HasModifier("modifier_item_bloodthorn") then return end
if self:GetParent():HasModifier("modifier_item_pipe_custom") then return end
if self:GetParent():HasModifier("modifier_item_spell_breaker") then return end
if self:GetParent():HasModifier("modifier_item_mage_slayer") then return end
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("bonus_spell_resist")
	end
end


function modifier_item_eternal_shroud_custom:OnCreated(table)
if not IsServer() then return end

self.damage_thresh = self:GetAbility():GetSpecialValueFor("spell_damage_thresh")
self.duration = self:GetAbility():GetSpecialValueFor("spell_damage_duration")

self.damage_count = 0
end


function modifier_item_eternal_shroud_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end
if not params.inflictor then return end
if params.attacker:IsBuilding() then return end

local mana = params.damage*self:GetAbility():GetSpecialValueFor("mana_restore_pct")/100

self:GetParent():GiveMana(mana)

if true then return end

local damage = params.damage

while damage > 0 do 
    self.damage_count = damage + self.damage_count

    if self.damage_count < self.damage_thresh then 
      damage = 0
    else 
      damage =  self.damage_count - self.damage_thresh
      self.damage_count = 0
      self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_eternal_shroud_custom_active", {duration = self.duration})

    end
end


end


modifier_item_eternal_shroud_custom_active = class({})
function modifier_item_eternal_shroud_custom_active:IsHidden() return false end
function modifier_item_eternal_shroud_custom_active:IsPurgable() return false end
function modifier_item_eternal_shroud_custom_active:OnCreated()

self.damage = self:GetAbility():GetSpecialValueFor("spell_damage_increase")
self.max = self:GetAbility():GetSpecialValueFor("spell_damage_max")

if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_item_eternal_shroud_custom_active:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
} 
end

function modifier_item_eternal_shroud_custom_active:GetModifierSpellAmplify_Percentage() 
return self:GetStackCount()*self.damage
end



function modifier_item_eternal_shroud_custom_active:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

end