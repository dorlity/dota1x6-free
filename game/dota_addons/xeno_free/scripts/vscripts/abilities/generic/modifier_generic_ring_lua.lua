LinkLuaModifier( "modifier_generic_ring_slow", "abilities/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_ring_damage", "abilities/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )

modifier_generic_ring_tower_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_ring_tower_lua:IsHidden()
	return true
end

function modifier_generic_ring_tower_lua:IsDebuff()
	return false
end

function modifier_generic_ring_tower_lua:IsStunDebuff()
	return false
end

function modifier_generic_ring_tower_lua:IsPurgable()
	return false
end

function modifier_generic_ring_tower_lua:RemoveOnDeath()
	return false
end

function modifier_generic_ring_tower_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_ring_tower_lua:OnCreated( kv )

	if not IsServer() then return end



	-- references
	self.start_radius = kv.start_radius or 0
	self.end_radius = kv.end_radius or 0
	self.width = kv.width or 100
	self.speed = kv.speed or 0
	self.outward = self.end_radius>=self.start_radius
	if not self.outward then
		self.speed = -self.speed
	end

	self.target_team = kv.target_team or 0
	self.target_type = kv.target_type or 0
	self.target_flags = kv.target_flags or 0

	self.IsCircle = kv.IsCircle or 1

	self.targets = {}
end

function modifier_generic_ring_tower_lua:OnRemoved()
end

function modifier_generic_ring_tower_lua:OnDestroy()
	if self.EndCallback then
		self.EndCallback()
	end
	if not IsServer() then return end


	-- kill if thinker
	if self:GetParent():GetClassname()=="npc_dota_thinker" then
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_generic_ring_tower_lua:SetCallback( callback )
	self.Callback = callback

	-- Start interval
	self:StartIntervalThink( 0.03 )
	self:OnIntervalThink()
end

function modifier_generic_ring_tower_lua:SetEndCallback( callback )
	self.EndCallback = callback
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_generic_ring_tower_lua:OnIntervalThink()
	local radius = self.start_radius + self.speed * self:GetElapsedTime()
	if not self.outward and radius<self.end_radius then
		self:Destroy()
		return
	elseif self.outward and radius>self.end_radius then
		self:Destroy()
		return
	end

	-- Find targets in ring
	local targets = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self.target_team,	-- int, team filter
		self.target_type,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,target in pairs(targets) do

		-- only unaffected unit
		if not self.targets[target] then

			-- check if it is within circle/chakram
			if ((not self.IsCircle) or (target:GetOrigin()-self:GetParent():GetOrigin()):Length2D()>(radius-self.width)) and self:GetParent():IsAlive() then

					self.targets[target] = true

					local caster = self:GetParent()

					local duration = self:GetAbility():GetSpecialValueFor( "duration" )
					local duration_healing = self:GetAbility():GetSpecialValueFor( "duration_healing" )

					if target:IsIllusion() and not target:IsTalentIllusion() then 
						target:ForceKill(false)
					end

					target:AddNewModifier(caster, self:GetAbility(), "modifier_generic_ring_slow", {duration = duration*(1 - target:GetStatusResistance())})
					target:AddNewModifier(caster, self:GetAbility(), "modifier_generic_ring_damage", {duration = duration_healing})

					local sound_cast = "Ability.PlasmaFieldImpact"
					target:EmitSound( sound_cast )
			end
		end

	end
end


modifier_generic_ring_slow = class({})

function modifier_generic_ring_slow:IsHidden() return true end
function modifier_generic_ring_slow:IsPurgable() return true end
function modifier_generic_ring_slow:OnCreated(table)
self.slow =  -1*self:GetAbility():GetSpecialValueFor( "slow" )
end

function modifier_generic_ring_slow:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_generic_ring_slow:GetModifierMoveSpeedBonus_Percentage() return self.slow end







modifier_generic_ring_damage = class({})
function modifier_generic_ring_damage:IsHidden() return false end
function modifier_generic_ring_damage:IsPurgable() return false end
function modifier_generic_ring_damage:OnCreated(table)

self.heal = self:GetAbility():GetSpecialValueFor("heal")
end


function modifier_generic_ring_damage:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
    MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE
    }
end

function modifier_generic_ring_damage:GetModifierLifestealRegenAmplify_Percentage() return -1*self.heal end
function modifier_generic_ring_damage:GetModifierHealAmplify_PercentageTarget() return -1*self.heal end
function modifier_generic_ring_damage:GetModifierHPRegenAmplify_Percentage() return -1*self.heal end



function modifier_generic_ring_damage:GetEffectName() return "particles/items4_fx/spirit_vessel_damage.vpcf" end
 
function modifier_generic_ring_damage:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end










modifier_generic_ring_lua_sf = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_ring_lua_sf:IsHidden()
	return true
end

function modifier_generic_ring_lua_sf:IsDebuff()
	return false
end

function modifier_generic_ring_lua_sf:IsStunDebuff()
	return false
end

function modifier_generic_ring_lua_sf:IsPurgable()
	return false
end

function modifier_generic_ring_lua_sf:RemoveOnDeath()
	return false
end

function modifier_generic_ring_lua_sf:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_ring_lua_sf:OnCreated( kv )

	if not IsServer() then return end



	self.origin = self:GetParent():GetAbsOrigin()
	-- references
	self.start_radius = kv.start_radius or 0
	self.end_radius = kv.end_radius or 0
	self.width = kv.width or 100
	self.speed = kv.speed or 0
	self.outward = self.end_radius>=self.start_radius
	if not self.outward then
		self.speed = -self.speed
	end

	self.target_team = kv.target_team or 0
	self.target_type = kv.target_type or 0
	self.target_flags = kv.target_flags or 0

	self.IsCircle = kv.IsCircle or 1

	self.targets = {}
end

function modifier_generic_ring_lua_sf:OnRemoved()
end

function modifier_generic_ring_lua_sf:OnDestroy()
	if self.EndCallback then
		self.EndCallback()
	end
	if not IsServer() then return end


	-- kill if thinker
	if self:GetParent():GetClassname()=="npc_dota_thinker" then
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_generic_ring_lua_sf:SetCallback( callback )
	self.Callback = callback

	-- Start interval
	self:StartIntervalThink( 0.03 )
	self:OnIntervalThink()
end

function modifier_generic_ring_lua_sf:SetEndCallback( callback )
	self.EndCallback = callback
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_generic_ring_lua_sf:OnIntervalThink()
	local radius = self.start_radius + self.speed * self:GetElapsedTime()
	if not self.outward and radius<self.end_radius then
		self:Destroy()
		return
	elseif self.outward and radius>self.end_radius then
		self:Destroy()
		return
	end

	-- Find targets in ring
	local targets = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self.origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self.target_team,	-- int, team filter
		self.target_type,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _,target in pairs(targets) do

		-- only unaffected unit
		if not self.targets[target] then

			-- check if it is within circle/chakram
			if ((not self.IsCircle) or (target:GetOrigin()-self.origin):Length2D()>(radius-self.width))  then

				self.targets[target] = true

					local caster = self:GetParent()
					if not target:IsMagicImmune() then 
						target:EmitSound("Sf.Aura_Fear")
						target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_nevermore_requiem_fear", {duration = self:GetAbility().legendary_fear* (1 - target:GetStatusResistance())})
					end

	
			end
		end

	end
end










