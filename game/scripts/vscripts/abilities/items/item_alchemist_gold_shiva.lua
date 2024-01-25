LinkLuaModifier( "modifier_alchemist_gold_shiva_custom_stats", "abilities/items/item_alchemist_gold_shiva.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_gold_shiva_custom_stats", "abilities/items/item_alchemist_gold_shiva.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_gold_shiva_custom_burn", "abilities/items/item_alchemist_gold_shiva.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_alchemist_gold_shiva_custom_slow", "abilities/items/item_alchemist_gold_shiva.lua", LUA_MODIFIER_MOTION_NONE )

item_alchemist_gold_shiva = class({})

function item_alchemist_gold_shiva:GetIntrinsicModifierName()
	return "modifier_alchemist_gold_shiva_custom_stats" end



function item_alchemist_gold_shiva:OnSpellStart()
if not IsServer() then return end


	local blast_radius = self:GetSpecialValueFor("blast_radius")
	local blast_speed = self:GetSpecialValueFor("blast_speed")
	local damage = self:GetSpecialValueFor("blast_damage")
    local blast_debuff_duration = self:GetSpecialValueFor("blast_debuff_duration")
    
	local current_loc = self:GetCaster():GetAbsOrigin()

	-- Play cast sound
	self:GetCaster():EmitSound("DOTA_Item.ShivasGuard.Activate")
	
	local nParticleIndex = ParticleManager:CreateParticle("particles/econ/events/ti10/shivas_guard_ti10_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(nParticleIndex, 0, self:GetCaster():GetAbsOrigin())
	ParticleManager:SetParticleControl(nParticleIndex, 1, Vector(blast_radius, (blast_radius/blast_speed) * 1.33, blast_speed))
	ParticleManager:ReleaseParticleIndex(nParticleIndex)

	-- Initialize targets hit table
	local targets_hit = {}

	-- Main blasting loop
	local current_radius = 0
	local tick_interval = 0.1

	Timers:CreateTimer(tick_interval, function()
		-- Give vision
		AddFOWViewer(self:GetCaster():GetTeamNumber(), current_loc, current_radius, 0.1, false)

		current_radius = current_radius + blast_speed * tick_interval
		current_loc = self:GetCaster():GetAbsOrigin()

		-- Iterate through enemies in the radius
		local nearby_enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), current_loc, nil, current_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(nearby_enemies) do
			-- Check if this enemy was already hit
			local enemy_has_been_hit = false
			for _,enemy_hit in pairs(targets_hit) do
				if enemy == enemy_hit then enemy_has_been_hit = true end
			end

			-- If not, blast it
			if not enemy_has_been_hit then
				-- Play hit particle

				local hit_pfx = ParticleManager:CreateParticle("particles/econ/events/ti10/shivas_guard_ti10_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
				ParticleManager:SetParticleControl(hit_pfx, 0, enemy:GetAbsOrigin())
				ParticleManager:SetParticleControl(hit_pfx, 1, enemy:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(hit_pfx)

				-- Deal damage
				ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

				-- Apply slow modifier
				enemy:AddNewModifier(self:GetCaster(), self, "modifier_alchemist_gold_shiva_custom_slow", {duration=blast_debuff_duration})

				-- Add enemy to the targets hit table
				targets_hit[#targets_hit + 1] = enemy
			end
		end

		-- If the current radius is smaller than the maximum radius, keep going
		if current_radius < blast_radius then
			return tick_interval
		end
	end)


end



modifier_alchemist_gold_shiva_custom_stats = class({})

function modifier_alchemist_gold_shiva_custom_stats:IsHidden() return true end
function modifier_alchemist_gold_shiva_custom_stats:IsDebuff() return false end
function modifier_alchemist_gold_shiva_custom_stats:IsPurgable() return false end
function modifier_alchemist_gold_shiva_custom_stats:IsPermanent() return true end
function modifier_alchemist_gold_shiva_custom_stats:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_alchemist_gold_shiva_custom_stats:OnCreated(keys)

self.evasion = self:GetAbility():GetSpecialValueFor("evasion")
self.damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
self.armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
self.stats = self:GetAbility():GetSpecialValueFor("bonus_stats")
self.regen = self:GetAbility():GetSpecialValueFor("bonus_regen")

if not IsServer() then end
self.particle = ParticleManager:CreateParticle("particles/items2_fx/radiance_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
self:AddParticle(self.particle, false, false, -1, false, false)
end




function modifier_alchemist_gold_shiva_custom_stats:DeclareFunctions()
return 
{ 
	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	MODIFIER_PROPERTY_EVASION_CONSTANT,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end

function modifier_alchemist_gold_shiva_custom_stats:GetModifierPreAttack_BonusDamage()
	return self.damage
end

function modifier_alchemist_gold_shiva_custom_stats:GetModifierEvasion_Constant()
	return self.evasion
end

function modifier_alchemist_gold_shiva_custom_stats:GetModifierPhysicalArmorBonus()
	return self.armor
end


function modifier_alchemist_gold_shiva_custom_stats:GetModifierBonusStats_Intellect()
	return self.stats
end

function modifier_alchemist_gold_shiva_custom_stats:GetModifierBonusStats_Agility()
	return self.stats
end

function modifier_alchemist_gold_shiva_custom_stats:GetModifierBonusStats_Strength()
	return self.stats
end

function modifier_alchemist_gold_shiva_custom_stats:GetModifierConstantHealthRegen()
	return self.regen
end



function modifier_alchemist_gold_shiva_custom_stats:IsAura() return true end

function modifier_alchemist_gold_shiva_custom_stats:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_alchemist_gold_shiva_custom_stats:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_alchemist_gold_shiva_custom_stats:GetModifierAura()
	return "modifier_alchemist_gold_shiva_custom_burn"
end

function modifier_alchemist_gold_shiva_custom_stats:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("aura_radius")
end










modifier_alchemist_gold_shiva_custom_burn = class({})
function modifier_alchemist_gold_shiva_custom_burn:IsHidden() return false end
function modifier_alchemist_gold_shiva_custom_burn:IsDebuff() return true end
function modifier_alchemist_gold_shiva_custom_burn:IsPurgable() return false end
function modifier_alchemist_gold_shiva_custom_burn:GetTexture() return "buffs/gold_shiva" end


function modifier_alchemist_gold_shiva_custom_burn:DeclareFunctions()
return 
	{ 
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
	} 
end



function modifier_alchemist_gold_shiva_custom_burn:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end


function modifier_alchemist_gold_shiva_custom_burn:GetModifierLifestealRegenAmplify_Percentage()
	return self.heal_reduction
end

function modifier_alchemist_gold_shiva_custom_burn:GetModifierHealAmplify_PercentageTarget()
	return self.heal_reduction
end

function modifier_alchemist_gold_shiva_custom_burn:GetModifierHPRegenAmplify_Percentage()
	return self.heal_reduction
end




function modifier_alchemist_gold_shiva_custom_burn:OnCreated()
	
	local ability = self:GetAbility()
	self.creeps_damage = ability:GetSpecialValueFor("creeps_damage")
	self.heroes_damage_base = ability:GetSpecialValueFor("heroes_damage_base")
	self.heroes_damage_health = ability:GetSpecialValueFor("heroes_damage_health")
	self.illusions_damage = ability:GetSpecialValueFor("aura_damage_illusions")
	self.miss_pers = ability:GetSpecialValueFor("blind_pct")
	self.active_k = ability:GetSpecialValueFor("active_k")

	self.heal_reduction = ability:GetSpecialValueFor("hp_regen_degen_aura")*-1
	self.attack_slow = ability:GetSpecialValueFor("aura_attack_speed")

if not IsServer() then return end
	self.particle = ParticleManager:CreateParticle("particles/items2_fx/radiance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())

	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("think_interval"))


	self.aura_radius = ability:GetSpecialValueFor("aura_radius")

	self.miss_chance = ability:GetSpecialValueFor("blind_pct")

	EmitSoundOnEntityForPlayer("DOTA_Item.Radiance.Target.Loop", self:GetParent(), self:GetParent():GetPlayerOwnerID())
end

function modifier_alchemist_gold_shiva_custom_burn:OnDestroy()
if IsServer() then

	StopSoundOn("DOTA_Item.Radiance.Target.Loop", self:GetParent())

	if self.particle then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

end

function modifier_alchemist_gold_shiva_custom_burn:OnIntervalThink()
if not IsServer() then return end

	ParticleManager:SetParticleControl(self.particle, 1, self:GetCaster():GetAbsOrigin())

	local ability = self:GetAbility()
	local caster = self:GetCaster()

	local damage = self.creeps_damage

	if self:GetParent():IsHero() then 
		damage = self.heroes_damage_base + self.heroes_damage_health*self:GetParent():GetMaxHealth()
	end
	
	if self:GetCaster():IsIllusion() then 
		damage = self.illusions_damage
	end

	if self:GetParent():HasModifier("modifier_alchemist_gold_shiva_custom_slow") then 
		damage = damage*self.active_k
	end

	ApplyDamage({victim = self:GetParent(), attacker = caster, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})

end

function modifier_alchemist_gold_shiva_custom_burn:GetModifierMiss_Percentage()
	return self.miss_pers
end

function modifier_alchemist_gold_shiva_custom_burn:OnTooltip()

local damage = self.creeps_damage

if self:GetParent():IsHero() then 
	damage = self.heroes_damage_base + self.heroes_damage_health*self:GetParent():GetMaxHealth()
end
	
if self:GetCaster():IsIllusion() then 
	damage = self.illusions_damage
end


if self:GetParent():HasModifier("modifier_alchemist_gold_shiva_custom_slow") then 
	damage = damage*self.active_k
end

return damage
end



modifier_alchemist_gold_shiva_custom_slow = class({})
function modifier_alchemist_gold_shiva_custom_slow:IsHidden() return false end
function modifier_alchemist_gold_shiva_custom_slow:IsPurgable() return false end
function modifier_alchemist_gold_shiva_custom_slow:GetTexture() return "buffs/gold_shiva" end
function modifier_alchemist_gold_shiva_custom_slow:OnCreated(table)
if not self:GetAbility() then return end

self.slow = self:GetAbility():GetSpecialValueFor("blast_movement_speed")
end

function modifier_alchemist_gold_shiva_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end

function modifier_alchemist_gold_shiva_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end


function modifier_alchemist_gold_shiva_custom_slow:GetStatusEffectName()
return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_alchemist_gold_shiva_custom_slow:StatusEffectPriority()
return 9999
end
function modifier_alchemist_gold_shiva_custom_slow:GetEffectName()
  return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end
