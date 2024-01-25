LinkLuaModifier("modifier_zuus_cloud_custom", "abilities/zuus/zuus_cloud_custom", LUA_MODIFIER_MOTION_NONE)

zuus_cloud_custom = class({})




function zuus_cloud_custom:Precache(context)

PrecacheResource( "particle", 'particles/units/heroes/hero_zeus/zeus_cloud.vpcf', context )

end


function zuus_cloud_custom:GetAOERadius()
	return self:GetSpecialValueFor("cloud_radius")
end

function zuus_cloud_custom:OnInventoryContentsChanged()
    if self:GetCaster():HasScepter() then
        self:SetHidden(false)       
        if not self:IsTrained() then
            self:SetLevel(1)
        end
    else
        self:SetHidden(true)
    end
end

function zuus_cloud_custom:OnHeroCalculateStatBonus()
    self:OnInventoryContentsChanged()
end

function zuus_cloud_custom:OnSpellStart()
	if not IsServer() then return end
	self.target_point 			= self:GetCursorPosition()
	local caster 				= self:GetCaster()
	local cloud_bolt_interval 	= self:GetSpecialValueFor("cloud_bolt_interval")
	local cloud_duration 		= self:GetSpecialValueFor("cloud_duration")
	local cloud_radius 			= self:GetSpecialValueFor("cloud_radius")



	EmitSoundOnLocationWithCaster(self.target_point, "Hero_Zuus.Cloud.Cast", caster)

	self.zuus_nimbus_unit = CreateUnitByName("npc_dota_zeus_cloud", Vector(self.target_point.x, self.target_point.y, 450), false, caster, nil, caster:GetTeam())
	self.zuus_nimbus_unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	self.zuus_nimbus_unit:SetModelScale(0.7)
	self.zuus_nimbus_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_phased", {})
	self.zuus_nimbus_unit:AddNewModifier(caster, self, "modifier_zuus_cloud_custom", {duration = cloud_duration, cloud_bolt_interval = cloud_bolt_interval, cloud_radius = cloud_radius})
	self.zuus_nimbus_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = cloud_duration})


end

modifier_zuus_cloud_custom = class({})

function modifier_zuus_cloud_custom:IsHidden() return true end

function modifier_zuus_cloud_custom:OnCreated(keys)
	if not IsServer() then return end
	self.ability = self
	self.cloud_radius = keys.cloud_radius
	self.cloud_bolt_interval = keys.cloud_bolt_interval
	self.lightning_bolt = self:GetCaster():FindAbilityByName("zuus_lightning_bolt_custom")
	local target_point 	= GetGroundPosition(self:GetParent():GetAbsOrigin(), self:GetParent())


	self.melee_damage = self:GetParent():GetMaxHealth()/self:GetAbility():GetSpecialValueFor("hits_to_kill_melee")
	self.range_damage = self:GetParent():GetMaxHealth()/self:GetAbility():GetSpecialValueFor("hits_to_kill_range")

	self.original_z = target_point.z
	self:SetStackCount(self.original_z)

	self.counter = self.cloud_bolt_interval
	self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, Vector(target_point.x, target_point.y, 450))
	ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.cloud_radius, 0, 0))
	ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, Vector(target_point.x, target_point.y, target_point.z + 450))	
	self:AddParticle(self.zuus_nimbus_particle, false, false, -1, false, false)

	self:StartIntervalThink(FrameTime())
end

function modifier_zuus_cloud_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}

	return funcs
end

function modifier_zuus_cloud_custom:GetVisualZDelta()
	return 450
end

function modifier_zuus_cloud_custom:OnIntervalThink()
	if not IsServer() then return end
	if self.lightning_bolt:GetLevel() > 0 and self.counter >= self.cloud_bolt_interval then
		local nearby_enemy_units = FindUnitsInRadius( self:GetCaster():GetTeamNumber(),  self:GetParent():GetAbsOrigin(),  nil,  self.cloud_radius,  DOTA_UNIT_TARGET_TEAM_ENEMY,  self.lightning_bolt:GetAbilityTargetType(), DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for _,unit in pairs(nearby_enemy_units) do
			if unit:IsAlive() then
				self.lightning_bolt:CastLightningBolt(self:GetCaster(), unit, unit:GetAbsOrigin(), true, self:GetParent(), false, false)
				self.counter = 0
				break
			end
		end
	end
	self.counter = self.counter + FrameTime()
end

function modifier_zuus_cloud_custom:OnAttacked(params)
	if params.target == self:GetParent() then
		local damage = self.melee_damage

		if params.attacker:IsRangedAttacker() then 
			damage = self.range_damage
		end 

		if self:GetParent():GetHealth() > damage then 
			self:GetParent():SetHealth(self:GetParent():GetHealth() - damage)
		else 
			self:GetParent():Kill(nil, params.attacker)
		end
	end
end

function modifier_zuus_cloud_custom:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_zuus_cloud_custom:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_zuus_cloud_custom:GetAbsoluteNoDamagePure()
	return 1
end

function modifier_zuus_cloud_custom:OnRemoved()
	if not IsServer() then return end
	if self.zuus_nimbus_particle then
		ParticleManager:DestroyParticle(self.zuus_nimbus_particle, false)
	end
end