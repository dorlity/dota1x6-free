LinkLuaModifier("modifier_ember_spirit_fire_remnant_custom_remnant", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ember_spirit_fire_remnant_custom_timer", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_caster", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_activate", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_slow", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_blast_timer", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_ember_remnant_fire_thinker", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_blast", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_resist", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_resist_count", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_bkb_count", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_bkb", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_stack_count", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)



ember_spirit_fire_remnant_custom = class({})



ember_spirit_fire_remnant_custom.slow_move = -80
ember_spirit_fire_remnant_custom.slow_attack = -100
ember_spirit_fire_remnant_custom.slow_duration = 2.5

ember_spirit_fire_remnant_custom.vision_radius = 700
ember_spirit_fire_remnant_custom.vision_duration = 20


ember_spirit_activate_fire_remnant_custom = class({})

ember_spirit_activate_fire_remnant_custom.resist_duration = 4
ember_spirit_activate_fire_remnant_custom.resist_heal = {20, 30, 40}



ember_spirit_activate_fire_remnant_custom.slow_move = -80
ember_spirit_activate_fire_remnant_custom.slow_attack = -100
ember_spirit_activate_fire_remnant_custom.slow_duration = 2.5
ember_spirit_activate_fire_remnant_custom.slow_mana = 75


function ember_spirit_activate_fire_remnant_custom:GetManaCost(level)

if self:GetCaster():HasModifier("modifier_ember_remnant_5") then  
  return self.slow_mana
end

return self.BaseClass.GetManaCost(self,level) 
end





function ember_spirit_fire_remnant_custom:Precache(context)

PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf", context )
PrecacheResource( "particle", "particles/sf_refresh_a.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", context )
PrecacheResource( "particle", "particles/dragon_fireball.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/ember_slow.vpcf", context )

end








function ember_spirit_fire_remnant_custom:OnInventoryContentsChanged()

	local mod = self:GetCaster():FindModifierByName("modifier_ember_remnant_1")
	local stack = 0
	local str = ''

	if mod then 
		stack = mod:GetStackCount()
		str = '_' .. tostring(stack)
	end



	if self:GetCaster():HasScepter() then
		if self:GetCaster():GetAbilityByIndex(5) then
			if self:GetCaster():GetAbilityByIndex(5):GetAbilityName() == "ember_spirit_fire_remnant_custom"..str then
				self:GetCaster():SwapAbilities("ember_spirit_fire_remnant_custom"..str, "ember_spirit_fire_remnant_custom_ult_scepter"..str, false, true)
			end
		end
	else
		if self:GetCaster():GetAbilityByIndex(5) then
			if self:GetCaster():GetAbilityByIndex(5):GetAbilityName() == "ember_spirit_fire_remnant_custom_ult_scepter"..str then
				self:GetCaster():SwapAbilities("ember_spirit_fire_remnant_custom_ult_scepter"..str, "ember_spirit_fire_remnant_custom"..str, false, true)
			end
		end
	end
end

function ember_spirit_fire_remnant_custom:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function ember_spirit_fire_remnant_custom:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end



function ember_spirit_fire_remnant_custom:GetCastRange(vLocation, hTarget)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget)
	else
		return self:GetSpecialValueFor("scepter_range")
	end
end

function ember_spirit_fire_remnant_custom:OnUpgrade()
	if IsServer() then
		local caster = self:GetCaster()
		local activate_ability = caster:FindAbilityByName("ember_spirit_activate_fire_remnant_custom")
		activate_ability:SetLevel(self:GetLevel())
	end
end


function ember_spirit_fire_remnant_custom:OnSpellStart()
self:Cast(self:GetCaster(), self:GetAbilityName())
end


function ember_spirit_fire_remnant_custom:ReduceCharges(caster, name)

local ability_base = caster:FindAbilityByName(name)
local charges = ability_base:GetCurrentAbilityCharges()

if charges > 0 then
	ability_base:SetCurrentAbilityCharges(charges - 1)
end	

end

function ember_spirit_fire_remnant_custom:AddStack()
if not self:GetCaster():HasModifier("modifier_ember_remnant_4") then return end

local mod = self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ember_spirit_activate_fire_remnant_stack_count", {})

end



function ember_spirit_fire_remnant_custom:Cast(caster, name, target)
	if not IsServer() then return end


	local duration = self:GetSpecialValueFor("duration")
	local speed_multiplier = self:GetSpecialValueFor("speed_multiplier")

	if caster:HasScepter() then
		speed_multiplier = self:GetSpecialValueFor("shard_remnant_speed_pct")
	end

	local StartPosition = caster:GetAbsOrigin()

	local TargetPosition = self:GetCursorPosition()


	if target ~= nil then 
		TargetPosition = target
	end

	local vDirection = TargetPosition - StartPosition
	vDirection.z = 0
	if vDirection:Length2D() == 0 then vDirection = caster:GetForwardVector() end

	local remnant_unit = CreateUnitByName("npc_dota_ember_spirit_remnant", StartPosition, false, caster, caster, caster:GetTeamNumber())


	if caster:HasShard() then 
		duration = duration + self.vision_duration
		remnant_unit:SetDayTimeVisionRange(self.vision_radius)
		remnant_unit:SetNightTimeVisionRange(self.vision_radius)
	end


	remnant_unit:AddNewModifier(caster, self, "modifier_ember_spirit_fire_remnant_custom_remnant", {})
	remnant_unit.mod = caster:AddNewModifier(caster, self, "modifier_ember_spirit_fire_remnant_custom_timer", { duration = duration, thinker_index = remnant_unit:entindex() })


	local remnant_speed = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), false) * speed_multiplier * 0.01

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf", PATTACH_CUSTOMORIGIN, remnant_unit)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, caster, PATTACH_CUSTOMORIGIN, nil, caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(iParticleID, 0, StartPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, vDirection:Normalized() * remnant_speed)
	ParticleManager:SetParticleShouldCheckFoW(iParticleID, false)
	remnant_unit.iParticleID = iParticleID
	remnant_unit.vVelocity = vDirection:Normalized() * remnant_speed

	local tInfo = {
		Ability = self,
		Source = caster,
		vSpawnOrigin = StartPosition,
		vVelocity = remnant_unit.vVelocity,
		fDistance = vDirection:Length2D(),
		ExtraData = {
			thinker_index = remnant_unit:entindex(),
		},
	}
	ProjectileManager:CreateLinearProjectile(tInfo)

	caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")


	local activate_remnant = caster:FindAbilityByName("ember_spirit_activate_fire_remnant_custom")
	if activate_remnant then
		local tRemnants = activate_remnant.tRemnants or {}
		table.insert(tRemnants, remnant_unit)
		activate_remnant.tRemnants = tRemnants
	end


	if name ~= "ember_spirit_fire_remnant_custom_ult_scepter" and name ~= "ember_spirit_fire_remnant_custom" then 

		self:ReduceCharges(caster,"ember_spirit_fire_remnant_custom_ult_scepter")
		self:ReduceCharges(caster,"ember_spirit_fire_remnant_custom")

	else 
		if name == "ember_spirit_fire_remnant_custom" then 
			self:ReduceCharges(caster,"ember_spirit_fire_remnant_custom_ult_scepter")
		else 
			self:ReduceCharges(caster,"ember_spirit_fire_remnant_custom")
		end

	end



	for i = 1,3 do 
		local str =  "ember_spirit_fire_remnant_custom_" .. tostring(i)

		if str ~= name then 
			self:ReduceCharges(caster,str)
		end
	end

	for i = 1,3 do 
		local str =  "ember_spirit_fire_remnant_custom_ult_scepter_" .. tostring(i)

		if str ~= name then 
			self:ReduceCharges(caster,str)
		end

	end
end

function ember_spirit_fire_remnant_custom:OnProjectileThink_ExtraData(vLocation, ExtraData)
	local hThinker = EntIndexToHScript(ExtraData.thinker_index)
	if hThinker and not hThinker:IsNull() and hThinker:IsAlive() then
		hThinker:SetAbsOrigin(vLocation)




	end
end

function ember_spirit_fire_remnant_custom:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hThinker = EntIndexToHScript(ExtraData.thinker_index)
	if hThinker and not hThinker:IsNull() and hThinker:IsAlive() then
		local hModifier = hThinker:FindModifierByName("modifier_ember_spirit_fire_remnant_custom_remnant")
		if hModifier then
			local hCaster = self:GetCaster()
			local radius = self:GetSpecialValueFor("radius")
			local tSequences = { 22, 23, 24 }

			vLocation = GetGroundPosition(vLocation, hCaster)



  	


			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant.vpcf", PATTACH_CUSTOMORIGIN, hThinker)
			ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
			ParticleManager:SetParticleFoWProperties(iParticleID, 0, -1, radius)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_CUSTOMORIGIN_FOLLOW, nil, vLocation, true)
			ParticleManager:SetParticleControl(iParticleID, 2, Vector(tSequences[RandomInt(1, #tSequences)], 0, 0))
			hModifier:AddParticle(iParticleID, true, false, -1, false, false)

			hThinker:EmitSound("Hero_EmberSpirit.FireRemnant.Create")
		end

		if hThinker.iParticleID ~= nil then
			ParticleManager:DestroyParticle(hThinker.iParticleID, false)
			hThinker.iParticleID = nil
		end
	end
end
























modifier_ember_spirit_fire_remnant_custom_timer = class({})

function modifier_ember_spirit_fire_remnant_custom_timer:IsHidden()		return false end
function modifier_ember_spirit_fire_remnant_custom_timer:IsPurgable()		return false end
function modifier_ember_spirit_fire_remnant_custom_timer:RemoveOnDeath()	return false end
function modifier_ember_spirit_fire_remnant_custom_timer:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ember_spirit_fire_remnant_custom_timer:OnCreated(params)
if not IsServer() then return end

self.RemoveForDuel = true
		self.hThinker = EntIndexToHScript(params.thinker_index)
		if self.hThinker and (self.hThinker:IsNull() or not self.hThinker:IsAlive()) then
			self:Destroy()
		end
end



function modifier_ember_spirit_fire_remnant_custom_timer:OnDestroy()
if not IsServer() then return end
local caster = self:GetParent()

if self:GetRemainingTime() > 0.1 then 
	self:GetAbility():AddStack()
end

if self.hThinker and not self.hThinker:IsNull() and self.hThinker:IsAlive() then
	self.hThinker:RemoveModifierByName("modifier_ember_spirit_fire_remnant_custom_remnant")
end



local burst_ability = self:GetParent():FindAbilityByName("ember_spirit_fire_remnant_burst")
if burst_ability then 
	local cd = burst_ability:GetCooldownTimeRemaining()
		
	burst_ability:EndCooldown()
	if cd > burst_ability:GetSpecialValueFor("cd_reduction") then 
		burst_ability:StartCooldown(cd - burst_ability:GetSpecialValueFor("cd_reduction"))
	end

end


end




modifier_ember_spirit_fire_remnant_custom_remnant = class({})

function modifier_ember_spirit_fire_remnant_custom_remnant:IsDebuff() return false end
function modifier_ember_spirit_fire_remnant_custom_remnant:IsHidden() return false end
function modifier_ember_spirit_fire_remnant_custom_remnant:IsPurgable() return false end



function modifier_ember_spirit_fire_remnant_custom_remnant:OnCreated()
	if IsServer() then
		local ability_activate = self:GetCaster():FindAbilityByName("ember_spirit_activate_fire_remnant_custom")
		
		if ability_activate then
			ability_activate:SetActivated(true)

		end
		self.caster = self:GetCaster()
		self.ability = self:GetAbility()
	end
end

function modifier_ember_spirit_fire_remnant_custom_remnant:CheckState()
	if IsServer() then
		local state = {
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_MAGIC_IMMUNE] = true,
			[MODIFIER_STATE_ROOTED] = true,
			[MODIFIER_STATE_UNSELECTABLE] = true,
			[MODIFIER_STATE_FORCED_FLYING_VISION] = true
		}

		return state
	end
end

function modifier_ember_spirit_fire_remnant_custom_remnant:OnDestroy()
if not IsServer() then return end

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleFoWProperties(iParticleID, 0, -1, self:GetAbility():GetSpecialValueFor("radius"))
		ParticleManager:ReleaseParticleIndex(iParticleID)

		self:GetParent():RemoveSelf()
		local ability_activate = self.caster:FindAbilityByName("ember_spirit_activate_fire_remnant_custom")

		if ability_activate then
			ability_activate:FilterRemnants()
			if ability_activate.tRemnants ~= nil and #ability_activate.tRemnants > 0 and not self.caster:HasModifier("modifier_ember_spirit_activate_fire_remnant_custom_caster") then
				ability_activate:SetActivated(true)
			else
				ability_activate:SetActivated(false)
			end
		end



end




























function ember_spirit_activate_fire_remnant_custom:OnUpgrade()
	if IsServer() then
		if self:GetLevel() == 1 then
			self:SetActivated(false)
		end
	end
end

function ember_spirit_activate_fire_remnant_custom:FilterRemnants()
	if self.tRemnants ~= nil then
		for i = #self.tRemnants, 1, -1 do
			local hRemnant = self.tRemnants[i]
			if hRemnant and (hRemnant:IsNull() or not hRemnant:IsAlive()) then
				table.remove(self.tRemnants, i)
			end
		end
	end
end

function ember_spirit_activate_fire_remnant_custom:OnSpellStart()
	self:FilterRemnants()


	if self.tRemnants ~= nil and #self.tRemnants > 0 then
		local vPosition = self:GetCursorPosition()
		local hCaster = self:GetCaster()

		-- Находим ближайший ремнант к курсору и удаляем его из таблицы

		table.sort( self.tRemnants, function(x,y) return (y:GetAbsOrigin()-vPosition):Length2D() > (x:GetAbsOrigin()-vPosition):Length2D() end )

		self.selected_remnant = self.tRemnants[1]

		for id, rem in pairs(self.tRemnants) do
			if rem == self.selected_remnant then
				table.remove(self.tRemnants, id)
				break
			end
		end

		-- Сортируем таблицу по самому дальному ремнанту и добавляем в конец последний ремнант

		table.sort( self.tRemnants, function(x,y) return (y:GetAbsOrigin()-vPosition):Length2D() < (x:GetAbsOrigin()-vPosition):Length2D() end )

		table.insert(self.tRemnants, self.selected_remnant)

		local hRemnant = self.tRemnants[1]

		if hRemnant and not hRemnant:IsNull() and hRemnant:IsAlive() then
			hCaster:RemoveModifierByName("modifier_ember_spirit_sleight_of_fist_custom_caster")

			local speed = self:GetSpecialValueFor("speed")
			local fDistance = (hRemnant:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D()

			self.hTargetRemnant = hRemnant
			self.vRemnantPosition = self.hTargetRemnant:GetAbsOrigin()

			self.vLocation = hCaster:GetAbsOrigin()
			local tInfo =			{
				Target = hRemnant,
				Source = hCaster,
				Ability = self,
				iMoveSpeed = fDistance > speed and (fDistance / 0.4) or speed,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_NONE,
				vSourceLoc = hCaster:GetAbsOrigin(),
				flExpireTime = GameRules:GetGameTime() + 10,
				bReplaceExisting = true,
			}
			ProjectileManager:CreateTrackingProjectile(tInfo)

			self.tTargets = {}

			hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_activate_fire_remnant_custom_caster", {})
		end
	end
end

function TableFindKey(t, v)
	if t == nil then
		return nil
	end

	for _k, _v in pairs(t) do
		if v == _v then
			return _k
		end
	end
	return nil
end

function ember_spirit_activate_fire_remnant_custom:OnProjectileThink(vLocation)
local hCaster = self:GetCaster()

if self.hTargetRemnant and not self.hTargetRemnant:IsNull() and self.hTargetRemnant:IsAlive() then
	self.vRemnantPosition = self.hTargetRemnant:GetAbsOrigin()
end

local vDirection = vLocation - self.vLocation
vDirection.z = 0

vLocation = GetGroundPosition(self.vLocation + vDirection:Normalized() * Clamp(vDirection:Length2D(), 0, (self.vLocation - self.vRemnantPosition):Length2D()), hCaster)

GridNav:DestroyTreesAroundPoint(vLocation, 200, false)

local radius = self:GetSpecialValueFor("radius")

local damage = self:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_ember_remnant_4") then 
	damage = damage + self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "damage")
end 

local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), self.vLocation, vLocation, nil, radius / 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)
for n, hTarget in pairs(tTargets) do
	if TableFindKey(self.tTargets, hTarget) == nil then


  	if hCaster:HasModifier("modifier_ember_remnant_5") then 
  		hTarget:AddNewModifier(hCaster, self, "modifier_ember_spirit_activate_fire_remnant_custom_slow", {duration = (1 - hTarget:GetStatusResistance())*self.slow_duration})
  	end

  	ApplyDamage({victim = hTarget, attacker = hCaster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})

  	if hTarget and not hTarget:IsNull() then 
			table.insert(self.tTargets, hTarget)
		end 
	end
end

	self.vLocation = vLocation
end





function ember_spirit_activate_fire_remnant_custom:OnProjectileHit(hTarget, vLocation)
local hCaster = self:GetCaster()

if self.hTargetRemnant and not self.hTargetRemnant:IsNull() and self.hTargetRemnant:IsAlive() then
	self.vRemnantPosition = self.hTargetRemnant:GetAbsOrigin()
end



self.vRemnantPosition = GetGroundPosition(self.vRemnantPosition, hCaster)
GridNav:DestroyTreesAroundPoint(self.vRemnantPosition, 200, false)

local fDamage = self:GetSpecialValueFor("damage")
local radius = self:GetSpecialValueFor("radius")

if self:GetCaster():HasModifier("modifier_ember_remnant_4") then 
	fDamage = fDamage + self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "damage")
end 



local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), self.vRemnantPosition, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
for n, hTarget in pairs(tTargets) do
	if TableFindKey(self.tTargets, hTarget) == nil then

	ApplyDamage({victim = hTarget, attacker = hCaster, damage = fDamage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})

	if hCaster:HasModifier("modifier_ember_remnant_5") then 
		hTarget:AddNewModifier(hCaster, self, "modifier_ember_spirit_activate_fire_remnant_custom_slow", {duration = (1 - hTarget:GetStatusResistance())*self.slow_duration})
	end

	table.insert(self.tTargets, hTarget)
	end
end

if hCaster:HasModifier("modifier_ember_remnant_2") then 
	hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_activate_fire_remnant_resist", {duration = self.resist_duration})
	hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_activate_fire_remnant_resist_count", {duration = self.resist_duration})
end

if hCaster:HasModifier("modifier_ember_remnant_6") then 
	hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_activate_fire_remnant_bkb_count", {duration = self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "duration")})
end 


if hCaster:HasModifier("modifier_ember_remnant_3") then 

	CreateModifierThinker(hCaster, self, "modifier_custom_ember_remnant_fire_thinker", {duration = self:GetCaster():GetTalentValue("modifier_ember_remnant_3", "duration")}, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)

end


local hRemnant = self.tRemnants[1]
if hRemnant and not hRemnant:IsNull() and hRemnant:IsAlive() then
	if hRemnant.iParticleID ~= nil then
		ParticleManager:DestroyParticle(hRemnant.iParticleID, false)
		hRemnant.iParticleID = nil
	end

	hRemnant:RemoveModifierByName("modifier_ember_spirit_fire_remnant_custom_remnant")

	local tTimerModifiers = hCaster:FindAllModifiersByName("modifier_ember_spirit_fire_remnant_custom_timer")
	for k, hTimerModifier in pairs(tTimerModifiers) do
		if hTimerModifier.hThinker and (hTimerModifier.hThinker:IsNull() or not hTimerModifier.hThinker:IsAlive()) then
			hTimerModifier:Destroy()
		end
	end
end

EmitSoundOnLocationWithCaster(self.vRemnantPosition, "Hero_EmberSpirit.FireRemnant.Explode", hCaster)

self:FilterRemnants()


table.sort( self.tRemnants, function(x,y) 
	if x ~= self.selected_remnant and y ~= self.selected_remnant then
		return (y:GetAbsOrigin()-self:GetCaster():GetAbsOrigin()):Length2D() > (x:GetAbsOrigin()-self:GetCaster():GetAbsOrigin()):Length2D() 
	end
end )

local mod = hCaster:FindModifierByName("modifier_ember_spirit_activate_fire_remnant_custom_caster")

if mod then 
	mod:IncrementStackCount()
end

if self.tRemnants ~= nil and #self.tRemnants > 0 then
	local hRemnant = self.tRemnants[1]
	if hRemnant and not hRemnant:IsNull() and hRemnant:IsAlive() then

		local speed = self:GetSpecialValueFor("speed")
		local fDistance = (hRemnant:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D()

		self.hTargetRemnant = hRemnant
		self.vRemnantPosition = self.hTargetRemnant:GetAbsOrigin()

		self.vLocation = hCaster:GetAbsOrigin()
		local tInfo =			
		{
			Target = hRemnant,
			Source = hCaster,
			Ability = self,
			iMoveSpeed = fDistance > speed and (fDistance / 0.4) or speed,
			vSourceLoc = hCaster:GetAbsOrigin(),
			flExpireTime = GameRules:GetGameTime() + 10,
			bReplaceExisting = true,
		}
		ProjectileManager:CreateTrackingProjectile(tInfo)

		self.tTargets = {}
	end
else
	hCaster:RemoveModifierByName("modifier_ember_spirit_activate_fire_remnant_custom_caster")
	FindClearSpaceForUnit(hCaster, self.vRemnantPosition, false)
	self.vLocation = nil
end



end











modifier_custom_ember_remnant_fire_thinker = class({})

function modifier_custom_ember_remnant_fire_thinker:IsHidden() return true end

function modifier_custom_ember_remnant_fire_thinker:IsPurgable() return false end


function modifier_custom_ember_remnant_fire_thinker:OnCreated(table)
if not IsServer() then return end
	
self.interval = self:GetCaster():GetTalentValue("modifier_ember_remnant_3", "interval")
self.damage = self:GetCaster():GetTalentValue("modifier_ember_remnant_3", "damage")*self.interval
self.radius = self:GetCaster():GetTalentValue("modifier_ember_remnant_3", "radius")

self.start_pos = self:GetParent():GetAbsOrigin()

self.nFXIndex = ParticleManager:CreateParticle("particles/dragon_fireball.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 1, self:GetParent():GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(self.radius, 0, 0))
ParticleManager:ReleaseParticleIndex(self.nFXIndex)

self:AddParticle(self.nFXIndex,false,false,-1,false,false)

self:StartIntervalThink(self.interval)
end

function modifier_custom_ember_remnant_fire_thinker:OnIntervalThink()
if not IsServer() then return end

local tTargets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)

for _,enemy in ipairs(tTargets) do

	local damage = self.damage

	ApplyDamage({attacker = self:GetCaster(), victim = enemy, ability = self:GetAbility(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	SendOverheadEventMessage(enemy, 4, enemy, damage, nil)

end

end























modifier_ember_spirit_activate_fire_remnant_custom_caster = class({})

function modifier_ember_spirit_activate_fire_remnant_custom_caster:GetTexture()
	return "ember_spirit_fire_remnant"
end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_caster:IsHidden() return true end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:OnCreated(params)
	if IsServer() then
		local hCaster = self:GetParent()


		hCaster:AddEffects(EF_NODRAW)
		hCaster:EmitSound("Hero_EmberSpirit.FireRemnant.Activate")
		hCaster:SetLocalAngles(0, 0, 0)

		if self:ApplyHorizontalMotionController() then
			self.hThinker = CreateModifierThinker(hCaster, self:GetAbility(), "modifier_ember_spirit_activate_fire_remnant_custom_activate", nil, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_remnant_dash.vpcf", PATTACH_CUSTOMORIGIN, self.hThinker)
			ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, self.hThinker, PATTACH_CUSTOMORIGIN_FOLLOW, nil, self.hThinker:GetAbsOrigin(), true)
			self:AddParticle(iParticleID, false, false, -1, false, false)
		else
			self:Destroy()
		end
	end
end

modifier_ember_spirit_activate_fire_remnant_custom_activate = class({})

function modifier_ember_spirit_activate_fire_remnant_custom_activate:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_TEAM_MOVE_TO] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:OnDestroy()
if not IsServer() then return end



local hCaster = self:GetParent()

hCaster:StopSound("Hero_EmberSpirit.FireRemnant.Activate")

hCaster:EmitSound("Hero_EmberSpirit.FireRemnant.Stop")

hCaster:RemoveHorizontalMotionController(self)

hCaster:RemoveEffects(EF_NODRAW)

if self.hThinker and not self.hThinker:IsNull() and self.hThinker:IsAlive() then
	self.hThinker:RemoveSelf()
end

		
end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local hAbility = self:GetAbility()
		if not hAbility or hAbility.vLocation == nil then
			self:Destroy()
			return
		end

		self.hThinker:SetAbsOrigin(hAbility.vLocation)
		me:SetAbsOrigin(hAbility.vLocation)
	end
end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:GetModifierDisableTurning(params)
	return 1
end













ember_spirit_fire_remnant_custom_ult_scepter = class(ember_spirit_fire_remnant_custom)

function ember_spirit_fire_remnant_custom_ult_scepter:GetCastRange(vLocation, hTarget)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget)
	else
		return self:GetSpecialValueFor("scepter_range")
	end
end

function ember_spirit_fire_remnant_custom_ult_scepter:OnSpellStart()
local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
ability:Cast(self:GetCaster(), self:GetAbilityName())
end

function ember_spirit_fire_remnant_custom_ult_scepter:GetIntrinsicModifierName()
return
end


modifier_ember_spirit_activate_fire_remnant_custom_blast_timer = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_blast_timer:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_custom_blast_timer:IsPurgable() return false end

function modifier_ember_spirit_activate_fire_remnant_custom_blast_timer:OnDestroy()
if not IsServer() then return end
if self:GetParent().mod == nil then return end  

self:GetParent():EmitSound("Hero_EmberSpirit.FireRemnant.Explode")
local main_ability = self:GetParent().mod:GetAbility()

local activate_ability = self:GetCaster():FindAbilityByName("ember_spirit_activate_fire_remnant_custom")

local damage = main_ability:GetSpecialValueFor("damage")

if self:GetCaster():HasModifier("modifier_ember_remnant_4") then 
	damage = damage + self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "damage")
end 

if self:GetCaster():HasModifier("modifier_ember_remnant_6") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), activate_ability, "modifier_ember_spirit_activate_fire_remnant_bkb_count", {duration = self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "duration")})
end 


if self:GetCaster():HasModifier("modifier_ember_remnant_2") then 
	self:GetCaster():AddNewModifier(self:GetCaster(), activate_ability, "modifier_ember_spirit_activate_fire_remnant_resist", {duration = activate_ability.resist_duration})
	self:GetCaster():AddNewModifier(self:GetCaster(), activate_ability, "modifier_ember_spirit_activate_fire_remnant_resist_count", {duration = activate_ability.resist_duration})

end

if self:GetCaster():HasModifier("modifier_ember_remnant_3") then 

	CreateModifierThinker(self:GetCaster(), activate_ability, "modifier_custom_ember_remnant_fire_thinker", {duration = self:GetCaster():GetTalentValue("modifier_ember_remnant_3", "duration")}, self:GetParent():GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
end

	
		
local tTargets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, main_ability:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
local active = self:GetCaster():FindAbilityByName("ember_spirit_activate_fire_remnant_custom")

for n, hTarget in pairs(tTargets) do

	if active.tTargets then 
		table.insert(active.tTargets, hTarget)
	end


    ApplyDamage({victim = hTarget, attacker = self:GetCaster(), damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self:GetAbility()})
        	
   if self:GetCaster():HasModifier("modifier_ember_remnant_5") then 
      hTarget:AddNewModifier(self:GetCaster(), main_ability, "modifier_ember_spirit_activate_fire_remnant_custom_slow", {duration = (1 - hTarget:GetStatusResistance())*main_ability.slow_duration})
   end
end


self:GetParent().mod:Destroy()
self:GetParent():Destroy()

end




ember_spirit_fire_remnant_burst = class({})

function ember_spirit_fire_remnant_burst:GetAOERadius()
	return self:GetSpecialValueFor("range")
end

function ember_spirit_fire_remnant_burst:OnAbilityPhaseStart()
if not IsServer() then return end

if self:GetCaster():HasModifier("modifier_ember_spirit_activate_fire_remnant_custom_caster") then 
	return false 
end
	return true
end



function ember_spirit_fire_remnant_burst:GetChannelTime()
	return self:GetSpecialValueFor("channel") + 2*FrameTime()
end


function ember_spirit_fire_remnant_burst:OnSpellStart()
if not IsServer() then return end
	local point = self:GetCursorPosition()
	self:GetCaster():StartGesture(ACT_DOTA_TELEPORT)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ember_spirit_activate_fire_remnant_custom_blast", {x = point.x, y = point.y, z = point.z})
end

function ember_spirit_fire_remnant_burst:OnChannelFinish(bInterrupted)
if not IsServer() then return end
	self:GetCaster():RemoveModifierByName("modifier_ember_spirit_activate_fire_remnant_custom_blast")
	self:GetCaster():FadeGesture(ACT_DOTA_TELEPORT)
end

----------------------------------------------------------------------------------------------

modifier_ember_spirit_activate_fire_remnant_custom_blast = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_blast:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_custom_blast:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_blast:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(self:GetAbility():GetSpecialValueFor("max"))

self.interval = self:GetAbility():GetSpecialValueFor("channel")/(self:GetStackCount() - 1)

self.point = Vector(table.x, table.y, table.z)
self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_ember_spirit_activate_fire_remnant_custom_blast:OnIntervalThink()
if not IsServer() then return end

local point = self.point + RandomVector(RandomInt(50, self:GetAbility():GetSpecialValueFor("range")))
self:FireRemnant(point)

self:DecrementStackCount() 

if self:GetStackCount() <= 0 then 
	self:Destroy()
	self:GetParent():Stop()
end 

end


function modifier_ember_spirit_activate_fire_remnant_custom_blast:FireRemnant(point)
if not IsServer() then return end
local ability = self:GetParent():FindAbilityByName("ember_spirit_fire_remnant_custom")
local caster = self:GetParent()

	local duration = ability:GetSpecialValueFor("duration")
	local speed_multiplier = ability:GetSpecialValueFor("speed_multiplier")

	if caster:HasScepter() then
		speed_multiplier = ability:GetSpecialValueFor("shard_remnant_speed_pct")
	end

	local StartPosition = caster:GetAbsOrigin()

	local TargetPosition = point


	local vDirection = TargetPosition - StartPosition
	vDirection.z = 0
	if vDirection:Length2D() == 0 then vDirection = caster:GetForwardVector() end

	local remnant_unit = CreateUnitByName("npc_dota_ember_spirit_remnant", StartPosition, false, caster, caster, caster:GetTeamNumber())


	if caster:HasShard() then 
		duration = duration + ability.vision_duration
		remnant_unit:SetDayTimeVisionRange(ability.vision_radius)
		remnant_unit:SetNightTimeVisionRange(ability.vision_radius)
	end


	remnant_unit:AddNewModifier(caster, ability, "modifier_ember_spirit_fire_remnant_custom_remnant", {})
	remnant_unit.mod = caster:AddNewModifier(caster, ability, "modifier_ember_spirit_fire_remnant_custom_timer", { duration = duration, thinker_index = remnant_unit:entindex() })


	local remnant_speed = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), false) * speed_multiplier * 0.01

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_fire_remnant_trail.vpcf", PATTACH_CUSTOMORIGIN, remnant_unit)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, caster, PATTACH_CUSTOMORIGIN, nil, caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(iParticleID, 0, StartPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, vDirection:Normalized() * remnant_speed)
	ParticleManager:SetParticleShouldCheckFoW(iParticleID, false)
	remnant_unit.iParticleID = iParticleID
	remnant_unit.vVelocity = vDirection:Normalized() * remnant_speed

	local tInfo = {
		Ability = ability,
		Source = caster,
		vSpawnOrigin = StartPosition,
		vVelocity = remnant_unit.vVelocity,
		fDistance = vDirection:Length2D(),
		ExtraData = {
			thinker_index = remnant_unit:entindex(),
		},
	}
	ProjectileManager:CreateLinearProjectile(tInfo)

	caster:EmitSound("Hero_EmberSpirit.FireRemnant.Cast")



	local activate_remnant = caster:FindAbilityByName("ember_spirit_activate_fire_remnant_custom")
	if activate_remnant then
		local tRemnants = activate_remnant.tRemnants or {}
		table.insert(tRemnants, remnant_unit)
		activate_remnant.tRemnants = tRemnants
	end

	remnant_unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_ember_spirit_activate_fire_remnant_custom_blast_timer", {duration = (caster:GetAbsOrigin() - point):Length2D()/remnant_speed})
end


























ember_spirit_fire_remnant_custom_1 = class(ember_spirit_fire_remnant_custom)

function ember_spirit_fire_remnant_custom_1:GetCastRange(vLocation, hTarget)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget)
	else
		return self:GetSpecialValueFor("scepter_range")
	end
end

function ember_spirit_fire_remnant_custom_1:OnSpellStart()
local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
ability:Cast(self:GetCaster(), self:GetAbilityName())
end

function ember_spirit_fire_remnant_custom_1:GetIntrinsicModifierName()
return
end









ember_spirit_fire_remnant_custom_2 = class(ember_spirit_fire_remnant_custom)

function ember_spirit_fire_remnant_custom_2:GetCastRange(vLocation, hTarget)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget)
	else
		return self:GetSpecialValueFor("scepter_range")
	end
end

function ember_spirit_fire_remnant_custom_2:OnSpellStart()
local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
ability:Cast(self:GetCaster(), self:GetAbilityName())
end


function ember_spirit_fire_remnant_custom_2:GetIntrinsicModifierName()
return
end




ember_spirit_fire_remnant_custom_3 = class(ember_spirit_fire_remnant_custom)

function ember_spirit_fire_remnant_custom_3:GetCastRange(vLocation, hTarget)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget)
	else
		return self:GetSpecialValueFor("scepter_range")
	end
end


function ember_spirit_fire_remnant_custom_3:OnSpellStart()
local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
ability:Cast(self:GetCaster(), self:GetAbilityName())
end

function ember_spirit_fire_remnant_custom_3:GetIntrinsicModifierName()
return
end





ember_spirit_fire_remnant_custom_ult_scepter_1 = class(ember_spirit_fire_remnant_custom)

function ember_spirit_fire_remnant_custom_ult_scepter_1:GetCastRange(vLocation, hTarget)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget)
	else
		return self:GetSpecialValueFor("scepter_range")
	end
end

function ember_spirit_fire_remnant_custom_ult_scepter_1:OnSpellStart()
local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
ability:Cast(self:GetCaster(), self:GetAbilityName())
end

function ember_spirit_fire_remnant_custom_ult_scepter_1:GetIntrinsicModifierName()
return
end




ember_spirit_fire_remnant_custom_ult_scepter_2 = class(ember_spirit_fire_remnant_custom)

function ember_spirit_fire_remnant_custom_ult_scepter_2:GetCastRange(vLocation, hTarget)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget)
	else
		return self:GetSpecialValueFor("scepter_range")
	end
end

function ember_spirit_fire_remnant_custom_ult_scepter_2:OnSpellStart()
local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
ability:Cast(self:GetCaster(), self:GetAbilityName())
end



function ember_spirit_fire_remnant_custom_ult_scepter_2:GetIntrinsicModifierName()
return
end



ember_spirit_fire_remnant_custom_ult_scepter_3 = class(ember_spirit_fire_remnant_custom)

function ember_spirit_fire_remnant_custom_ult_scepter_3:GetCastRange(vLocation, hTarget)
	if not self:GetCaster():HasScepter() then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget)
	else
		return self:GetSpecialValueFor("scepter_range")
	end
end

function ember_spirit_fire_remnant_custom_ult_scepter_3:GetIntrinsicModifierName()
return
end

function ember_spirit_fire_remnant_custom_ult_scepter_3:OnSpellStart()
local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
ability:Cast(self:GetCaster(), self:GetAbilityName())
end



modifier_ember_spirit_activate_fire_remnant_custom_slow = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_slow:IsHidden() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_slow:IsPurgable() return true end
function modifier_ember_spirit_activate_fire_remnant_custom_slow:GetTexture() return "buffs/remnant_slow" end
function modifier_ember_spirit_activate_fire_remnant_custom_slow:GetEffectName()
	return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end
function modifier_ember_spirit_activate_fire_remnant_custom_slow:OnCreated(table)
if not IsServer() then return end

local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/ember_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
self:AddParticle(iParticleID, true, false, -1, false, false)

end




function modifier_ember_spirit_activate_fire_remnant_custom_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
}

end

function modifier_ember_spirit_activate_fire_remnant_custom_slow:GetModifierMoveSpeedBonus_Percentage()
return self:GetAbility().slow_move
end
function modifier_ember_spirit_activate_fire_remnant_custom_slow:GetModifierAttackSpeedBonus_Constant()
return self:GetAbility().slow_attack
end


modifier_ember_spirit_activate_fire_remnant_resist = class({})
function modifier_ember_spirit_activate_fire_remnant_resist:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_resist:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_resist:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ember_spirit_activate_fire_remnant_resist:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end

function modifier_ember_spirit_activate_fire_remnant_resist:GetModifierConstantHealthRegen()
return self:GetAbility().resist_heal[self:GetCaster():GetUpgradeStack("modifier_ember_remnant_2")]
end


function modifier_ember_spirit_activate_fire_remnant_resist:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_ember_spirit_activate_fire_remnant_resist_count")

if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end


modifier_ember_spirit_activate_fire_remnant_resist_count = class({})
function modifier_ember_spirit_activate_fire_remnant_resist_count:GetTexture() return "buffs/leap_resist" end
function modifier_ember_spirit_activate_fire_remnant_resist_count:IsHidden() return false end
function modifier_ember_spirit_activate_fire_remnant_resist_count:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_resist_count:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_ember_spirit_activate_fire_remnant_resist_count:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
end

function modifier_ember_spirit_activate_fire_remnant_resist_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_ember_spirit_activate_fire_remnant_resist_count:OnTooltip()
return self:GetStackCount()*self:GetAbility().resist_heal[self:GetCaster():GetUpgradeStack("modifier_ember_remnant_2")]
end




function modifier_ember_spirit_activate_fire_remnant_resist:OnCreated(table)
self:SetStackCount(1)
end

function modifier_ember_spirit_activate_fire_remnant_resist:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self:GetAbility().resist_max then  return end

self:IncrementStackCount()

if self:GetStackCount() >= self:GetAbility().resist_max then 
	local iParticleID = ParticleManager:CreateParticle("particles/items3_fx/star_emblem_friend_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(iParticleID, true, false, -1, false, false)
	self:GetParent():EmitSound("BB.Back_ground")
end

end














function ember_spirit_fire_remnant_custom:GetCooldown(iLevel)
local upgrade_cooldown = 0	

if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cd")
end


return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end



function ember_spirit_fire_remnant_custom:GetCastPoint(iLevel)
if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cast")
end

return self.BaseClass.GetCastPoint(self)
end

function ember_spirit_fire_remnant_custom:ProcsMagicStick()
return false
end










function ember_spirit_fire_remnant_custom_1:GetCooldown(iLevel)
local upgrade_cooldown = 0	

if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end

function ember_spirit_fire_remnant_custom_1:GetCastPoint(iLevel)
if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cast")
end

return self.BaseClass.GetCastPoint(self)
end



function ember_spirit_fire_remnant_custom_1:ProcsMagicStick()
return false
end




function ember_spirit_fire_remnant_custom_2:GetCooldown(iLevel)
local upgrade_cooldown = 0	

if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end

function ember_spirit_fire_remnant_custom_2:GetCastPoint(iLevel)
if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cast")
end

return self.BaseClass.GetCastPoint(self)
end


function ember_spirit_fire_remnant_custom_2:ProcsMagicStick()
return false
end









function ember_spirit_fire_remnant_custom_3:GetCooldown(iLevel)
local upgrade_cooldown = 0	

if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end

function ember_spirit_fire_remnant_custom_3:GetCastPoint(iLevel)
if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cast")
end

return self.BaseClass.GetCastPoint(self)
end


function ember_spirit_fire_remnant_custom_3:ProcsMagicStick()
return false
end





function ember_spirit_fire_remnant_custom_ult_scepter:GetCooldown(iLevel)
local upgrade_cooldown = 0	

if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cd")
end



return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end

function ember_spirit_fire_remnant_custom_ult_scepter:GetCastPoint(iLevel)
if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cast")
end

return self.BaseClass.GetCastPoint(self)
end



function ember_spirit_fire_remnant_custom_ult_scepter:ProcsMagicStick()
return false
end








function ember_spirit_fire_remnant_custom_ult_scepter_1:GetCooldown(iLevel)
local upgrade_cooldown = 0	

if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cd")
end



return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end


function ember_spirit_fire_remnant_custom_ult_scepter_1:GetCastPoint(iLevel)
if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cast")
end

return self.BaseClass.GetCastPoint(self)
end



function ember_spirit_fire_remnant_custom_ult_scepter_1:ProcsMagicStick()
return false
end












function ember_spirit_fire_remnant_custom_ult_scepter_2:GetCooldown(iLevel)
local upgrade_cooldown = 0	

if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cd")
end


return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end

function ember_spirit_fire_remnant_custom_ult_scepter_2:ProcsMagicStick()
return false
end

function ember_spirit_fire_remnant_custom_ult_scepter_2:GetCastPoint(iLevel)
if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cast")
end


return self.BaseClass.GetCastPoint(self)
end





function ember_spirit_fire_remnant_custom_ult_scepter_3:GetCooldown(iLevel)
local upgrade_cooldown = 0	

if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cd")
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown 
end


function ember_spirit_fire_remnant_custom_ult_scepter_3:GetCastPoint(iLevel)
if self:GetCaster():HasModifier("modifier_ember_remnant_6")  then 
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "cast")
end


return self.BaseClass.GetCastPoint(self)
end

function ember_spirit_fire_remnant_custom_ult_scepter_3:ProcsMagicStick()
return false
end






modifier_ember_spirit_activate_fire_remnant_bkb_count = class({})
function modifier_ember_spirit_activate_fire_remnant_bkb_count:IsHidden() return false end
function modifier_ember_spirit_activate_fire_remnant_bkb_count:IsPurgable() return true end
function modifier_ember_spirit_activate_fire_remnant_bkb_count:GetTexture() return "buffs/Blade_dance_move" end
function modifier_ember_spirit_activate_fire_remnant_bkb_count:OnCreated()
if not IsServer() then return end 

self.max = self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "count")
self:SetStackCount(1)
end 

function modifier_ember_spirit_activate_fire_remnant_bkb_count:OnRefresh()
if not IsServer() then return end 

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self:GetParent():EmitSound("BS.Bloodrite_purge") 

	if self:GetParent().ember_bkb and not self:GetParent().ember_bkb:IsNull() then 
		self:GetParent().ember_bkb:SetDuration(self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "bkb"), true)
	else
		self:GetParent().ember_bkb = self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_debuff_immune", {duration = self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "bkb"), effect = 1})
	end
	self:Destroy()
end

end 




modifier_ember_spirit_activate_fire_remnant_stack_count = class({})
function modifier_ember_spirit_activate_fire_remnant_stack_count:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_stack_count:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_stack_count:RemoveOnDeath() return false end
function modifier_ember_spirit_activate_fire_remnant_stack_count:OnCreated()
if not IsServer() then return end 
self.timer = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "duration")
self:SetStackCount(1)

self:StartIntervalThink(self.timer)
end 

function modifier_ember_spirit_activate_fire_remnant_stack_count:OnRefresh()
if not IsServer() then return end 
self:IncrementStackCount()

if self:GetStackCount() >= self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "stack") then 
	self:Trigger()
	self:SetStackCount(0)
	return
end 

self:StartIntervalThink(self.timer)
end



function modifier_ember_spirit_activate_fire_remnant_stack_count:OnIntervalThink()
if not IsServer() then return end 

self:SetStackCount(0)
self:StartIntervalThink(-1)
end 


function modifier_ember_spirit_activate_fire_remnant_stack_count:OnStackCountChanged(iStackCount)
if not IsServer() then return end 
local max = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "stack")
local damage = self:GetStackCount()

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'ember_remnant_change',  {max = max, damage = damage})

end 


function modifier_ember_spirit_activate_fire_remnant_stack_count:Trigger()
if not IsServer() then return end 
local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

local name = "ember_spirit_fire_remnant_custom"
local max_count = 3

self:GiveCharge(name,max_count)

for i = 1,3 do 
	name =  "ember_spirit_fire_remnant_custom_" .. tostring(i)
	self:GiveCharge(name,max_count)
end

name = "ember_spirit_fire_remnant_custom_ult_scepter"
max_count = 5

self:GiveCharge(name,max_count)

for i = 1,3 do 
	name =  "ember_spirit_fire_remnant_custom_ult_scepter_" .. tostring(i)
	self:GiveCharge(name,max_count)
end

end



function modifier_ember_spirit_activate_fire_remnant_stack_count:GiveCharge(name, max)
if not IsServer() then return end 

local ability = self:GetCaster():FindAbilityByName(name)

local charges = ability:GetCurrentAbilityCharges()

if charges < max then
	ability:SetCurrentAbilityCharges(charges + 1)
end

if ability:GetCurrentAbilityCharges() == max then 
	ability:RefreshCharges()
end

end
