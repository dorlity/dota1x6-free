LinkLuaModifier("modifier_item_alchemist_gold_cuirass", "abilities/items/item_alchemist_gold_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_cuirass_active_debuff", "abilities/items/item_alchemist_gold_cuirass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_cuirass_active_suck_buff", "abilities/items/item_alchemist_gold_cuirass", LUA_MODIFIER_MOTION_NONE)

item_alchemist_gold_cuirass = class({})

function item_alchemist_gold_cuirass:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_cuirass"
end


function item_alchemist_gold_cuirass:OnSpellStart()
if not IsServer() then return end

self:GetCaster():EmitSound("Item.Pavise.Target")
self:GetCaster():EmitSound("Item.Star_emblem_cast")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_alchemist_gold_cuirass_active_suck_buff", {duration = self:GetSpecialValueFor("duration")})

end







modifier_item_alchemist_gold_cuirass	= class({})

function modifier_item_alchemist_gold_cuirass:IsPurgable()		return false end
function modifier_item_alchemist_gold_cuirass:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_cuirass:IsHidden()	return true end

function modifier_item_alchemist_gold_cuirass:OnCreated()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_all_attributes = self:GetAbility():GetSpecialValueFor("bonus_all_attributes")
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
	self.bonus_mana = self:GetAbility():GetSpecialValueFor("bonus_mana")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")

end



function modifier_item_alchemist_gold_cuirass:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS
	}

	return funcs
end

function modifier_item_alchemist_gold_cuirass:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_item_alchemist_gold_cuirass:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end

function modifier_item_alchemist_gold_cuirass:GetModifierConstantHealthRegen()
	return self.bonus_health
end

function modifier_item_alchemist_gold_cuirass:GetModifierBonusStats_Strength()
	return self.bonus_all_attributes
end

function modifier_item_alchemist_gold_cuirass:GetModifierBonusStats_Agility()
	return self.bonus_all_attributes
end

function modifier_item_alchemist_gold_cuirass:GetModifierBonusStats_Intellect()
	return self.bonus_all_attributes
end

function modifier_item_alchemist_gold_cuirass:GetModifierMoveSpeedBonus_Constant()
	return self.bonus_movement_speed
end

function modifier_item_alchemist_gold_cuirass:GetModifierConstantManaRegen()
	return self.bonus_mana
end


function modifier_item_alchemist_gold_cuirass:GetAuraRadius()
	if self:GetAbility() then
		return self:GetAbility():GetSpecialValueFor("radius")
	end
end

function modifier_item_alchemist_gold_cuirass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_item_alchemist_gold_cuirass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_alchemist_gold_cuirass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING
end

function modifier_item_alchemist_gold_cuirass:GetModifierAura()
	return "modifier_item_alchemist_gold_cuirass_active_debuff"
end

function modifier_item_alchemist_gold_cuirass:IsAura()
	return true
end






modifier_item_alchemist_gold_cuirass_active_debuff = class({})

function modifier_item_alchemist_gold_cuirass_active_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	self.armor = self:GetAbility():GetSpecialValueFor("aura_negative_armor")
end

function modifier_item_alchemist_gold_cuirass_active_debuff:IsHidden() return false end
function modifier_item_alchemist_gold_cuirass_active_debuff:IsPurgable() return false end
function modifier_item_alchemist_gold_cuirass_active_debuff:IsDebuff() return true end

function modifier_item_alchemist_gold_cuirass_active_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_item_alchemist_gold_cuirass_active_debuff:GetModifierPhysicalArmorBonus()
	return self.armor
end







modifier_item_alchemist_gold_cuirass_active_suck_buff = class({})
function modifier_item_alchemist_gold_cuirass_active_suck_buff:IsHidden() return false end
function modifier_item_alchemist_gold_cuirass_active_suck_buff:IsPurgable() return true end

function modifier_item_alchemist_gold_cuirass_active_suck_buff:OnCreated( params )
self.max_shield = self:GetAbility():GetSpecialValueFor("absorb_amount")

self.attack = self:GetAbility():GetSpecialValueFor("target_attack_speed")
self.move = self:GetAbility():GetSpecialValueFor("target_movement_speed")

self.bonus_attack = self:GetAbility():GetSpecialValueFor("bonus_attack")
self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")

if not IsServer() then return end
self:SetStackCount(self.max_shield)

self.nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/star_emblem_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
self:AddParticle( self.nFXIndex, false, false, -1, false, true )

self.particle = ParticleManager:CreateParticle("particles/items2_fx/pavise_friend.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
self:AddParticle(self.particle, false, false, -1, false, false)

end



function modifier_item_alchemist_gold_cuirass_active_suck_buff:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
if self:GetStackCount() == 0 then 
    bonus = self.bonus_attack
end 

return self.attack + bonus
end 

function modifier_item_alchemist_gold_cuirass_active_suck_buff:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if self:GetStackCount() == 0 then 
    bonus = self.bonus_move
end   

return self.move + bonus
end 




function modifier_item_alchemist_gold_cuirass_active_suck_buff:OnRefresh()
self.max_shield = self:GetAbility():GetSpecialValueFor("absorb_amount")

if not IsServer() then return end
self:SetStackCount(self.max_shield)
end



function modifier_item_alchemist_gold_cuirass_active_suck_buff:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT,
    MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,
    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end



function modifier_item_alchemist_gold_cuirass_active_suck_buff:GetModifierIncomingPhysicalDamageConstant(params)

if IsClient() then 
  if params.report_max then 
    return self.max_shield 
  else 
    return self:GetStackCount()
  end 
end

end


function modifier_item_alchemist_gold_cuirass_active_suck_buff:GetModifierIncomingDamageConstant(params)
if not IsServer() then return end

if self:GetStackCount() == 0 then return end
if params.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end

if self:GetStackCount() > params.damage then
    self:SetStackCount(self:GetStackCount() - params.damage)
    local i = params.damage
    return -i
else
    
    local i = self:GetStackCount()
    self:SetStackCount(0)

    ParticleManager:DestroyParticle(self.nFXIndex, false)
    ParticleManager:ReleaseParticleIndex(self.nFXIndex)

    self.nFXIndex2 = ParticleManager:CreateParticle( "particles/items3_fx/star_emblem.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
    ParticleManager:SetParticleControlEnt( self.nFXIndex2, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true )
    self:AddParticle( self.nFXIndex2, false, false, -1, false, true )

    ParticleManager:DestroyParticle(self.particle, false)
    ParticleManager:ReleaseParticleIndex(self.particle)

    self:GetCaster():EmitSound("Item.Star_emblem_break")
    return -i
end

end
