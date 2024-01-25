LinkLuaModifier("modifier_item_eternal_shroud_custom", "abilities/items/item_eternal_shroud_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_eternal_shroud_custom_active", "abilities/items/item_eternal_shroud_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_eternal_shroud_custom_active_count", "abilities/items/item_eternal_shroud_custom", LUA_MODIFIER_MOTION_NONE)

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
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end


function modifier_item_eternal_shroud_custom:OnCreated()

self.health = self:GetAbility():GetSpecialValueFor("bonus_health") 
self.stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
self.resist = self:GetAbility():GetSpecialValueFor("bonus_spell_resist")
self.resist_bonus = self:GetAbility():GetSpecialValueFor("spell_resist_increase")

self.damage_thresh = self:GetAbility():GetSpecialValueFor("spell_damage_thresh")
self.duration = self:GetAbility():GetSpecialValueFor("spell_damage_duration")
self.max = self:GetAbility():GetSpecialValueFor("spell_damage_max")

self.damage_count = 0
end 



function modifier_item_eternal_shroud_custom:GetModifierHealthBonus()
return self.health 
end

function modifier_item_eternal_shroud_custom:GetModifierBonusStats_Strength()
return self.stats
end

function modifier_item_eternal_shroud_custom:GetModifierBonusStats_Agility()
return self.stats
end

function modifier_item_eternal_shroud_custom:GetModifierBonusStats_Intellect()
return self.stats
end



function modifier_item_eternal_shroud_custom:GetModifierMagicalResistanceBonus()
if self:GetParent():HasModifier("modifier_item_pipe_custom") then return end
if self:GetParent():HasModifier("modifier_item_spell_breaker") then return end
if self:GetParent():HasModifier("modifier_item_mage_slayer") then return end

local bonus = 0
if self:GetCaster():HasModifier("modifier_item_eternal_shroud_custom_active") then 
	bonus = self:GetCaster():GetUpgradeStack("modifier_item_eternal_shroud_custom_active") * self.resist_bonus
end 

return self.resist + bonus
end





function modifier_item_eternal_shroud_custom:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if self:GetParent() == params.attacker then return end
if not params.inflictor then return end
if params.attacker:IsBuilding() then return end

local damage = params.original_damage

local mana = damage*self:GetAbility():GetSpecialValueFor("mana_restore_pct")/100

self:GetParent():GiveMana(mana)


while damage > 0 do 
  self.damage_count = damage + self.damage_count

  if self.damage_count < self.damage_thresh then 
    damage = 0
  else 

    damage =  self.damage_count - self.damage_thresh
    self.damage_count = 0

		local mod = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_eternal_shroud_custom_active", {duration = self.duration})

		if not mod then return end

		if mod:GetStackCount() < self.max then 
		  mod:IncrementStackCount() 
			self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_eternal_shroud_custom_active_count", {duration = self.duration})
		else 
		  for _,all_counts in ipairs(self:GetParent():FindAllModifiersByName("modifier_item_eternal_shroud_custom_active_count")) do 
		    all_counts:Destroy()
		    mod:IncrementStackCount() 
		    self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_eternal_shroud_custom_active_count", {duration = self.duration})
		    break
		  end
		end
  end
end


end


modifier_item_eternal_shroud_custom_active = class({})
function modifier_item_eternal_shroud_custom_active:IsHidden() return false end
function modifier_item_eternal_shroud_custom_active:IsPurgable() return false end
function modifier_item_eternal_shroud_custom_active:OnCreated()

self.damage = self:GetAbility():GetSpecialValueFor("spell_damage_increase")
self.resist = self:GetAbility():GetSpecialValueFor("spell_resist_increase")
end

function modifier_item_eternal_shroud_custom_active:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    MODIFIER_PROPERTY_TOOLTIP
} 
end

function modifier_item_eternal_shroud_custom_active:GetModifierSpellAmplify_Percentage() 
return self:GetStackCount()*self.damage
end

function modifier_item_eternal_shroud_custom_active:OnTooltip()
return self:GetStackCount()*self.resist
end


modifier_item_eternal_shroud_custom_active_count = class({})
function modifier_item_eternal_shroud_custom_active_count:IsHidden() return true end
function modifier_item_eternal_shroud_custom_active_count:IsPurgable() return false end
function modifier_item_eternal_shroud_custom_active_count:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end 

function modifier_item_eternal_shroud_custom_active_count:OnDestroy()
if not IsServer() then return end 

local mod = self:GetParent():FindModifierByName("modifier_item_eternal_shroud_custom_active")

if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() < 1 then 
		mod:Destroy()
	end 
end 

end 