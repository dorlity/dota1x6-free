LinkLuaModifier("modifier_item_alchemist_gold_heart", "abilities/items/item_alchemist_gold_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_heart_buff", "abilities/items/item_alchemist_gold_heart", LUA_MODIFIER_MOTION_NONE)

item_alchemist_gold_heart = class({})

function item_alchemist_gold_heart:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_heart"
end

function item_alchemist_gold_heart:OnSpellStart()
local caster = self:GetCaster()
if not IsServer() then return end

self:GetCaster():EmitSound("DOTA_Item.BlackKingBar.Activate")
self:GetCaster():Purge(false, true, false, false, false)

caster:AddNewModifier(caster, self, "modifier_item_alchemist_gold_heart_buff", {duration = self:GetSpecialValueFor("duration")})
self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_generic_debuff_immune", {magic_damage = self:GetSpecialValueFor("magic_resist"), duration = self:GetSpecialValueFor("duration")})

end

modifier_item_alchemist_gold_heart	= class({})

function modifier_item_alchemist_gold_heart:IsPurgable()		return false end
function modifier_item_alchemist_gold_heart:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_heart:IsHidden()	return true end

function modifier_item_alchemist_gold_heart:OnCreated()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_strength = self:GetAbility():GetSpecialValueFor("bonus_strength")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.health_regen_pct = self:GetAbility():GetSpecialValueFor("health_regen_pct")
	self.active_regen = self:GetAbility():GetSpecialValueFor("active_regen")
end

function modifier_item_alchemist_gold_heart:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end





function modifier_item_alchemist_gold_heart:GetModifierBonusStats_Strength()
	return self.bonus_strength
end

function modifier_item_alchemist_gold_heart:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end


function modifier_item_alchemist_gold_heart:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_alchemist_gold_heart:GetModifierHealthRegenPercentage()

if self:GetParent():HasModifier("modifier_item_alchemist_gold_heart_buff") then 
	return self.active_regen	
end
	return self.health_regen_pct
end







modifier_item_alchemist_gold_heart_buff = class({})

function modifier_item_alchemist_gold_heart_buff:IsPurgable() return false end

function modifier_item_alchemist_gold_heart_buff:OnCreated()
self.active_regen = self:GetAbility():GetSpecialValueFor("active_regen")

if not IsServer() then return end

self.particle = ParticleManager:CreateParticle("particles/huskar_lowhp.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)

end


function modifier_item_alchemist_gold_heart_buff:OnTooltip() return
self.active_regen
end

function modifier_item_alchemist_gold_heart_buff:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_item_alchemist_gold_heart_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_alchemist_gold_heart_buff:CheckState()
    return {
      --  [MODIFIER_STATE_MAGIC_IMMUNE] = true
    }
end

function modifier_item_alchemist_gold_heart_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_item_alchemist_gold_heart_buff:GetModifierModelScale()
    if self:GetAbility() then 
        return 30
    end
end

function modifier_item_alchemist_gold_heart_buff:GetStatusEffectName()
    return "particles/status_fx/status_effect_avatar.vpcf"
end

function modifier_item_alchemist_gold_heart_buff:StatusEffectPriority()
    return 99999
end
