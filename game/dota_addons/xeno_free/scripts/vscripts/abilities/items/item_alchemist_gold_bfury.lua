LinkLuaModifier("modifier_item_alchemist_gold_bfury", "abilities/items/item_alchemist_gold_bfury", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_bfury_shield", "abilities/items/item_alchemist_gold_bfury", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_alchemist_gold_bfury_shield_cd", "abilities/items/item_alchemist_gold_bfury", LUA_MODIFIER_MOTION_NONE)


item_alchemist_gold_bfury = class({})


function item_alchemist_gold_bfury:GetIntrinsicModifierName()
	return "modifier_item_alchemist_gold_bfury"
end

function item_alchemist_gold_bfury:OnSpellStart()
if not IsServer() then return end
self:GetCaster():EmitSound("DOTA_Item.Mjollnir.Activate")

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_alchemist_gold_bfury_shield", {duration = self:GetSpecialValueFor("static_duration")})
end



modifier_item_alchemist_gold_bfury	= class({})

function modifier_item_alchemist_gold_bfury:AllowIllusionDuplicate()	return false end
function modifier_item_alchemist_gold_bfury:IsPurgable()		return false end
function modifier_item_alchemist_gold_bfury:RemoveOnDeath()	return false end
function modifier_item_alchemist_gold_bfury:IsHidden()	return true end

function modifier_item_alchemist_gold_bfury:OnCreated()
	self.damage_bonus			= self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.speed_bonus			= self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.hp_regen			= self:GetAbility():GetSpecialValueFor("bonus_health_regen")
	self.mp_regen	= self:GetAbility():GetSpecialValueFor("bonus_mana_regen")

	self.gold_bonus = self:GetAbility():GetSpecialValueFor("gold_bonus")/100
	self.blue_bonus = self:GetAbility():GetSpecialValueFor("blue_bonus")/100

	self.arc_damage = self:GetAbility():GetSpecialValueFor("chain_damage")
	self.chance = self:GetAbility():GetSpecialValueFor("chain_chance")

	self.proc = false
end

function modifier_item_alchemist_gold_bfury:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_FAIL
	}

	return funcs
end

function modifier_item_alchemist_gold_bfury:GetModifierPreAttack_BonusDamage()
	return self.damage_bonus
end


function modifier_item_alchemist_gold_bfury:GetModifierAttackSpeedBonus_Constant()
	return self.speed_bonus
end

function modifier_item_alchemist_gold_bfury:GetModifierConstantManaRegen()
	return self.mp_regen
end

function modifier_item_alchemist_gold_bfury:GetModifierConstantHealthRegen()
	return self.hp_regen
end


function modifier_item_alchemist_gold_bfury:CheckState()
if self.proc == true then 
	return
	{
		[MODIFIER_STATE_CANNOT_MISS] = true
	}
else 
	return 
end

end

function modifier_item_alchemist_gold_bfury:OnAttackFail(param)
if param.target:IsBuilding() then return end
if self:GetParent():IsIllusion() then return end
if self:GetParent() ~= param.attacker then return end 
self:RandomProcDamage()

end

function modifier_item_alchemist_gold_bfury:RandomProcDamage()

if RollPseudoRandomPercentage(self.chance,247,self:GetParent()) then 
  self.proc = true
end

end




 
function modifier_item_alchemist_gold_bfury:GetModifierProcAttack_Feedback(params)
if self:GetParent():IsIllusion() then return end
	if params.attacker ~= self:GetParent() then return end
	local target = params.target
	if target:IsBuilding() then return end

	local target_loc = target:GetAbsOrigin()

	local arc_damage = 0

	if self.proc == true then 
		arc_damage = self.arc_damage

		self.proc = false
	end

	local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("cleave_distance"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	for _, unit in pairs(units) do
		if unit ~= target or arc_damage > 0 then

			local cleave_damage = self:GetAbility():GetSpecialValueFor("cleave_damage_hero")
			if params.target:IsCreep() then 
				cleave_damage = self:GetAbility():GetSpecialValueFor("cleave_damage_creep")
			end

			local damage = params.original_damage * cleave_damage * 0.01
			
			if unit ~= target then 
				ApplyDamage({victim = unit, attacker = params.attacker, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility()})
			end

			if arc_damage > 0 then 


				unit:EmitSound("Hero_Zuus.ArcLightning.Target")

				local nParticleIndex = ParticleManager:CreateParticle("particles/econ/events/ti10/maelstrom_ti10.vpcf", PATTACH_POINT_FOLLOW, unit)
				ParticleManager:SetParticleControlEnt(nParticleIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(nParticleIndex, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(nParticleIndex)

				ApplyDamage({victim = unit, attacker = params.attacker, damage = arc_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})

				SendOverheadEventMessage(unit, 4, unit, arc_damage, nil)
			end


		end
	end
	local particle = ParticleManager:CreateParticle("particles/alchemist_special/gold_bfury.vpcf", PATTACH_WORLDORIGIN, nil)	
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())


self:RandomProcDamage()
end





modifier_item_alchemist_gold_bfury_shield = class({})
function modifier_item_alchemist_gold_bfury_shield:IsHidden() return false end
function modifier_item_alchemist_gold_bfury_shield:IsPurgable() return true end
function modifier_item_alchemist_gold_bfury_shield:GetEffectName() return "particles/econ/events/ti10/mjollnir_shield_ti10.vpcf" end

function modifier_item_alchemist_gold_bfury_shield:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_alchemist_gold_bfury_shield:OnCreated(table)

self.damage = self:GetAbility():GetSpecialValueFor("static_damage")
self.chance = self:GetAbility():GetSpecialValueFor("static_chance")
self.radius = self:GetAbility():GetSpecialValueFor("cleave_distance")
self.cd = self:GetAbility():GetSpecialValueFor("static_cooldown")
self.move = self:GetAbility():GetSpecialValueFor("static_move")

if not IsServer() then return end

self:GetParent():EmitSound("DOTA_Item.Mjollnir.Loop")
self.cd = 0
end


function modifier_item_alchemist_gold_bfury_shield:OnDestroy()
if not IsServer() then return end
self:GetParent():StopSound("DOTA_Item.Mjollnir.Loop")
end


function modifier_item_alchemist_gold_bfury_shield:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end



function modifier_item_alchemist_gold_bfury_shield:GetModifierMoveSpeedBonus_Percentage()
return self.move
end

function modifier_item_alchemist_gold_bfury_shield:OnTakeDamage(params)
if not IsServer() then return end
if self:GetParent() ~= params.unit then return end
if not self:GetAbility() then return end
if self:GetParent() == params.attacker then return end
if not RollPseudoRandomPercentage(self.chance,248,self:GetParent()) then return end 
if self.cd == 1 then return end

self:GetParent():EmitSound("Hero_Zuus.ArcLightning.Target")

local units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
	
for _,unit in pairs(units) do 
	

	local nParticleIndex = ParticleManager:CreateParticle("particles/econ/events/ti10/maelstrom_ti10.vpcf", PATTACH_POINT_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt(nParticleIndex, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(nParticleIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(nParticleIndex)

	ApplyDamage({victim = unit, attacker = self:GetParent(), damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})


end


self.cd = 1 
self:StartIntervalThink(self.cd)
end


function modifier_item_alchemist_gold_bfury_shield:OnIntervalThink()
if not IsServer() then return end

self.cd = 0

self:StartIntervalThink(-1)
end