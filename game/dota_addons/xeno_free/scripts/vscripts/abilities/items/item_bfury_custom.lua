LinkLuaModifier("modifier_item_bfury_custom", "abilities/items/item_bfury_custom", LUA_MODIFIER_MOTION_NONE)

item_bfury_custom = class({})


function item_bfury_custom:GetIntrinsicModifierName()
	return "modifier_item_bfury_custom"
end

function item_bfury_custom:OnSpellStart()
local target = self:GetCursorTarget()

--if target.CutDown then
	--target:CutDown(self:GetCaster():GetTeamNumber())
GridNav:DestroyTreesAroundPoint(target:GetAbsOrigin(), 10, true)
--end 

end

modifier_item_bfury_custom	= class({})

function modifier_item_bfury_custom:AllowIllusionDuplicate()	return false end
function modifier_item_bfury_custom:IsPurgable()		return false end
function modifier_item_bfury_custom:RemoveOnDeath()	return false end
function modifier_item_bfury_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_bfury_custom:IsHidden()	return true end

function modifier_item_bfury_custom:OnCreated()
	self.damage_bonus			= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.hp_regen			= self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.mp_regen	= self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
	self.damage_bonus_creep_quelling = self:GetAbility():GetSpecialValueFor("quelling_bonus")

	self.damage_bonus_creep_quelling_ranged = self:GetAbility():GetSpecialValueFor("quelling_bonus_ranged")


	self.start_width = self:GetAbility():GetSpecialValueFor("cleave_starting_width")
	self.end_width = self:GetAbility():GetSpecialValueFor("cleave_ending_width")
	self.cleave_distance = self:GetAbility():GetSpecialValueFor("cleave_distance")
	self.gold_bonus = self:GetAbility():GetSpecialValueFor("gold_bonus")/100
	self.blue_bonus = self:GetAbility():GetSpecialValueFor("blue_bonus")/100

end



function modifier_item_bfury_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function modifier_item_bfury_custom:GetModifierPreAttack_BonusDamage(keys)
	return self.damage_bonus
end

function modifier_item_bfury_custom:GetModifierProcAttack_BonusDamage_Physical( keys )
	if not IsServer() then return end
	if keys.target and not keys.target:IsHero() and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
		
		if self:GetParent():IsRangedAttacker() then 
			return self.damage_bonus_creep_quelling_ranged
		else 
			return self.damage_bonus_creep_quelling
		end
	end
end

function modifier_item_bfury_custom:GetModifierConstantManaRegen()
	return self.mp_regen
end

function modifier_item_bfury_custom:GetModifierConstantHealthRegen()
	return self.hp_regen
end

function modifier_item_bfury_custom:OnAttackLanded( params )
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_tidehunter_anchor_smash_caster") then return end
if self:GetParent():HasModifier("modifier_no_cleave") then return end
if self:GetParent() ~= params.attacker then return end
if self:GetParent():IsRangedAttacker() then return end
if not params.target:IsHero() and not params.target:IsCreep() then return end


local k = self:GetAbility():GetSpecialValueFor("cleave_damage_percent")
if params.target:IsCreep() then 
	k = self:GetAbility():GetSpecialValueFor("cleave_damage_percent_creep")
end 


params.target:EmitSound("Hero_Sven.GreatCleave")

DoCleaveAttack(self:GetParent(), params.target, self:GetAbility(), params.damage*k/100, self.start_width, self.end_width, self.cleave_distance, "particles/items_fx/battlefury_cleave.vpcf")


end