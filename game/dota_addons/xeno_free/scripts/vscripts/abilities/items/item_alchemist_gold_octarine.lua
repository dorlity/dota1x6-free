LinkLuaModifier("modifier_item_alchemist_gold_octarine", "abilities/items/item_alchemist_gold_octarine", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_octarine_active", "abilities/items/item_alchemist_gold_octarine", LUA_MODIFIER_MOTION_NONE)

item_alchemist_gold_octarine = class({})

function item_alchemist_gold_octarine:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_octarine"
end





function item_alchemist_gold_octarine:OnSpellStart()
if not IsServer() then return end
    local duration = self:GetSpecialValueFor("duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_alchemist_gold_octarine_active", {duration = duration})
end





modifier_item_alchemist_gold_octarine_active = class({})

function modifier_item_alchemist_gold_octarine_active:IsPurgable() return false end

function modifier_item_alchemist_gold_octarine_active:OnCreated()
if not IsServer() then return end
    if not self:GetAbility() then 
        self:Destroy() 
    end


for _,mod in pairs(self:GetParent():FindAllModifiers()) do
	print(mod:GetName())
end

self.orbs_inc = self:GetAbility():GetSpecialValueFor("orbs_inc")/100

self:GetParent():EmitSound("BB.Quill_cdr")
self.particle = ParticleManager:CreateParticle("particles/bristle_cdr.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
ParticleManager:SetParticleControlEnt(self.particle, 5, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)


end

function modifier_item_alchemist_gold_octarine_active:OnRefresh()
    if not IsServer() then return end
    self:OnCreated()
end



function modifier_item_alchemist_gold_octarine_active:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MODEL_SCALE
    }
end

function modifier_item_alchemist_gold_octarine_active:GetModifierModelScale()
    if self:GetAbility() then 
        return 20
    end
end







modifier_item_alchemist_gold_octarine	= class({})

function modifier_item_alchemist_gold_octarine:IsPurgable()		return false end
function modifier_item_alchemist_gold_octarine:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_octarine:IsHidden()	return true end

function modifier_item_alchemist_gold_octarine:OnCreated()
	self.bonus_cooldown = self:GetAbility():GetSpecialValueFor("bonus_cooldown")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.health_regen = self:GetAbility():GetSpecialValueFor("health_regen")
	self.bonus_stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
end

function modifier_item_alchemist_gold_octarine:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_IS_SCEPTER 
	}

	return funcs
end


function modifier_item_alchemist_gold_octarine:GetModifierScepter()
return 1
end

function modifier_item_alchemist_gold_octarine:GetModifierBonusStats_Strength()
	return self.bonus_stats
end

function modifier_item_alchemist_gold_octarine:GetModifierBonusStats_Intellect()
	return self.bonus_stats
end

function modifier_item_alchemist_gold_octarine:GetModifierBonusStats_Agility()
	return self.bonus_stats
end



function modifier_item_alchemist_gold_octarine:GetModifierPercentageCooldown()
if self:GetParent():HasModifier("modifier_item_octarine_core") then return end
	return self.bonus_cooldown
end


function modifier_item_alchemist_gold_octarine:GetModifierConstantHealthRegen()
	return self.health_regen
end

function modifier_item_alchemist_gold_octarine:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_alchemist_gold_octarine:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_alchemist_gold_octarine:GetModifierConstantManaRegen()
	return self.bonus_mana_regen
end



