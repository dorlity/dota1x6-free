LinkLuaModifier("modifier_ember_spirit_fire_remnant_custom_remnant", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ember_spirit_fire_remnant_custom_timer", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_caster", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_activate", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_burn", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_blast_timer", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_ember_remnant_fire_thinker", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_blast", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_heal", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_heal_count", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_stack_count", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_amp", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_silence_cd", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_attack_slow", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ember_spirit_activate_fire_remnant_custom_speed", "abilities/ember_spirit/fire_remnant", LUA_MODIFIER_MOTION_NONE)



ember_spirit_fire_remnant_custom = class({})



ember_spirit_activate_fire_remnant_custom = class({})






function ember_spirit_fire_remnant_custom:GetCastRange(vLocation, hTarget)
local bonus = 0
if self:GetCaster():HasModifier("modifier_ember_remnant_1") then 
	bonus = self:GetCaster():GetTalentValue("modifier_ember_remnant_1", "range")
end 

return self:GetSpecialValueFor("AbilityCastRange") + bonus
end


function ember_spirit_fire_remnant_custom:GetCooldown(iLevel)
if self:GetCaster():HasScepter() then 
--	return 0
end
return self.BaseClass.GetCooldown(self, iLevel) 
end


function ember_spirit_fire_remnant_custom:GetCastPoint(iLevel)
if self:GetCaster():HasScepter() then 
	return 0
end
return self.BaseClass.GetCastPoint(self)
end

function ember_spirit_fire_remnant_custom:ProcsMagicStick()
return false
end




ember_spirit_fire_remnant_custom_shard_ability = class({})



function ember_spirit_fire_remnant_custom_shard_ability:GetCastRange(vLocation, hTarget)
local bonus = 0
if self:GetCaster():HasModifier("modifier_ember_remnant_1") then 
	bonus = self:GetCaster():GetTalentValue("modifier_ember_remnant_1", "range")
end 

return self:GetSpecialValueFor("AbilityCastRange") + bonus
end


function ember_spirit_fire_remnant_custom_shard_ability:GetCooldown(iLevel)
if self:GetCaster():HasScepter() then 
	--return 0
end
return self.BaseClass.GetCooldown(self, iLevel)
end


function ember_spirit_fire_remnant_custom_shard_ability:GetCastPoint(iLevel)
if self:GetCaster():HasScepter() then 
	return 0
end
return self.BaseClass.GetCastPoint(self)
end


function ember_spirit_fire_remnant_custom_shard_ability:ProcsMagicStick()
return false
end







function ember_spirit_activate_fire_remnant_custom:GetManaCost(level)

if self:GetCaster():HasShard() and self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom") then  
  return self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom"):GetSpecialValueFor("shard_mana")
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
PrecacheResource( "particle", "particles/ember_spirit/remnant_fire.vpcf", context )

end








function ember_spirit_fire_remnant_custom:OnInventoryContentsChanged()


if self:GetCaster():HasShard() then
	local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom_shard_ability")
	if ability and ability:IsHidden() then 
		self:GetCaster():SwapAbilities(self:GetAbilityName(), ability:GetAbilityName(), false, true)
		ability:SetCurrentAbilityCharges(self:GetCurrentAbilityCharges())
	end 

else

	local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom_shard_ability")
	if ability and not ability:IsHidden() then 
		self:GetCaster():SwapAbilities(self:GetAbilityName(), ability:GetAbilityName(), true, false)
		self:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges())
	end 
end

end




function ember_spirit_fire_remnant_custom:OnSpellStart()
self:Cast(self:GetAbilityName())
end

function ember_spirit_fire_remnant_custom_shard_ability:OnSpellStart()
local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
ability:Cast(self:GetAbilityName())
end









function ember_spirit_fire_remnant_custom:ChangeCharges(count)

local caster = self:GetCaster()
local ability_base = self

if caster:HasShard() then 
	ability_base = caster:FindAbilityByName("ember_spirit_fire_remnant_custom_shard_ability")
end 

if not ability_base then return end

local max = ability_base:GetSpecialValueFor("AbilityCharges")

local charges = ability_base:GetCurrentAbilityCharges()

if count < 0 then 
	if charges > 0 then
		ability_base:SetCurrentAbilityCharges(charges - 1)
	end	
else 
	if charges < max then
		ability_base:SetCurrentAbilityCharges(charges + 1)
	end

	if ability_base:GetCurrentAbilityCharges() == max then 
		ability_base:RefreshCharges()
	end
end 

end






function ember_spirit_fire_remnant_custom:AddStack()

local caster = self:GetCaster()

if caster:HasModifier("modifier_ember_chain_4") then 
	if RollPseudoRandomPercentage(caster:GetTalentValue("modifier_ember_chain_4", "chance"),1221, caster) then 
		caster:EmitSound("Ember.Chain_speed")
		caster:AddNewModifier(caster, self, "modifier_searing_chains_custom_speed", {duration = caster:GetTalentValue("modifier_ember_chain_4", "duration")})
	end 
end

if caster:HasModifier("modifier_ember_remnant_2") then 
	local duration = caster:GetTalentValue("modifier_ember_remnant_2", "duration")
	caster:AddNewModifier(caster, self, "modifier_ember_spirit_activate_fire_remnant_custom_heal", {duration = duration})
	caster:AddNewModifier(caster, self, "modifier_ember_spirit_activate_fire_remnant_custom_heal_count", {duration = duration})
end

if caster:HasModifier("modifier_ember_remnant_3") then 
	caster:AddNewModifier(caster, self, "modifier_ember_spirit_activate_fire_remnant_custom_amp", {duration = caster:GetTalentValue("modifier_ember_remnant_3", "duration")})
end 

if not self:GetCaster():HasModifier("modifier_ember_remnant_5") then return end

self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ember_spirit_activate_fire_remnant_stack_count", {})

end



function ember_spirit_fire_remnant_custom:Cast(name, target)
if not IsServer() then return end

local caster = self:GetCaster()

local duration = self:GetSpecialValueFor("duration")
local speed_multiplier = self:GetSpecialValueFor("speed_multiplier")


local StartPosition = caster:GetAbsOrigin()

local TargetPosition = self:GetCursorPosition()


if target ~= nil then 
	TargetPosition = target
end

local vDirection = TargetPosition - StartPosition
vDirection.z = 0
if vDirection:Length2D() == 0 then vDirection = caster:GetForwardVector() end

local remnant_unit = CreateUnitByName("npc_dota_ember_spirit_remnant", StartPosition, false, caster, caster, caster:GetTeamNumber())

remnant_unit:SetDayTimeVisionRange(700)
remnant_unit:SetNightTimeVisionRange(700)

if caster:HasShard() then 
	--duration = duration + self:GetSpecialValueFor("shard_duration")
end 



remnant_unit:AddNewModifier(caster, self, "modifier_ember_spirit_fire_remnant_custom_remnant", {})
remnant_unit.mod = caster:AddNewModifier(caster, self, "modifier_ember_spirit_fire_remnant_custom_timer", { duration = duration, thinker_index = remnant_unit:entindex() })


local remnant_speed = caster:GetMoveSpeedModifier(caster:GetBaseMoveSpeed(), false) * speed_multiplier * 0.01


if caster:HasModifier("modifier_ember_remnant_5") then
		remnant_speed = caster:GetTalentValue("modifier_ember_remnant_5", "speed")
end

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

if name == "ember_spirit_fire_remnant_burst" then 
	remnant_unit:AddNewModifier(caster, caster:FindAbilityByName(name), "modifier_ember_spirit_activate_fire_remnant_custom_blast_timer", {duration = (StartPosition - TargetPosition):Length2D()/remnant_speed})
	return
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
	self:GetCaster():CdAbility(burst_ability, self:GetCaster():GetTalentValue("modifier_ember_remnant_legendary", "cd_inc"))
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














function ember_spirit_activate_fire_remnant_custom:DealDamage(target)
local caster = self:GetCaster()

local damage = self:GetSpecialValueFor("damage") + self:GetCaster():GetTalentValue("modifier_ember_remnant_3", "damage")

if caster:HasModifier("modifier_ember_remnant_6") and not target:HasModifier('modifier_ember_spirit_activate_fire_remnant_silence_cd') then 
	local duration = (1 - target:GetStatusResistance())*caster:GetTalentValue("modifier_ember_remnant_6", "silence")

	target:EmitSound("Sf.Raze_Silence")

	target:AddNewModifier(caster, self, "modifier_ember_spirit_activate_fire_remnant_attack_slow", {duration = duration})
	target:AddNewModifier(caster, self, "modifier_generic_silence", {duration = duration})
	target:AddNewModifier(caster, self, "modifier_ember_spirit_activate_fire_remnant_silence_cd", {duration = caster:GetTalentValue("modifier_ember_remnant_6", "cd")})
end

ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})


if caster:HasScepter() then
	local ability = caster:FindAbilityByName("ember_spirit_sleight_of_fist_custom")
	local remnant_ability = caster:FindAbilityByName("ember_spirit_fire_remnant_custom")

	if ability and remnant_ability then 
		ability:MakeAttack(target, remnant_ability:GetSpecialValueFor("scepter_damage"))
	end 

end


end 



function ember_spirit_activate_fire_remnant_custom:Explosion(point, is_legendary)

local caster = self:GetCaster()
local radius = self:GetSpecialValueFor("radius")

local tTargets = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
for n, hTarget in pairs(tTargets) do


	if TableFindKey(self.tTargets, hTarget) == nil or is_legendary == true then
		if not is_legendary then 
			table.insert(self.tTargets, hTarget)
		end
		self:DealDamage(hTarget)
	end
end


if caster:HasModifier("modifier_ember_remnant_4") then 
	CreateModifierThinker(caster, self, "modifier_custom_ember_remnant_fire_thinker", {duration = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "duration")}, point, caster:GetTeamNumber(), false)
end

if caster:HasModifier("modifier_ember_remnant_1") then 
	caster:AddNewModifier(caster, self, "modifier_ember_spirit_activate_fire_remnant_custom_speed", {duration = caster:GetTalentValue("modifier_ember_remnant_1", "duration")})
end 


EmitSoundOnLocationWithCaster(point, "Hero_EmberSpirit.FireRemnant.Explode", caster)
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

local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), self.vLocation, vLocation, nil, radius / 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0)
for n, hTarget in pairs(tTargets) do
	if TableFindKey(self.tTargets, hTarget) == nil then

		self:DealDamage(hTarget)

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

self.vRemnantPosition = GetGroundPosition(self.vRemnantPosition, nil)
GridNav:DestroyTreesAroundPoint(self.vRemnantPosition, 200, false)

self:Explosion(self.vRemnantPosition)


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

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.radius = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "radius")
self.duration = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "fire_duration")

self.start_pos = self:GetParent():GetAbsOrigin()

self.nFXIndex = ParticleManager:CreateParticle("particles/ember_spirit/remnant_fire.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 1, self:GetParent():GetOrigin())
ParticleManager:SetParticleControl(self.nFXIndex, 2, Vector(self.radius, 0, 0))
ParticleManager:SetParticleControl(self.nFXIndex, 4, Vector(self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "duration") - 1, 0, 0))
ParticleManager:ReleaseParticleIndex(self.nFXIndex)


self.parent:EmitSound("Ember.Fire_burn")

self:AddParticle(self.nFXIndex,false,false,-1,false,false)

self:OnIntervalThink()
self:StartIntervalThink(0.2)
end


function modifier_custom_ember_remnant_fire_thinker:OnDestroy()
if not IsServer() then return end

self:GetParent():StopSound("Ember.Fire_burn")
end


function modifier_custom_ember_remnant_fire_thinker:OnIntervalThink()
if not IsServer() then return end

for _,enemy in ipairs(self.caster:FindTargets(self.radius, self.parent:GetAbsOrigin())) do

	enemy:AddNewModifier(self.caster, self:GetAbility(), "modifier_ember_spirit_activate_fire_remnant_custom_burn", {duration = self.duration})
	
end

end













modifier_ember_spirit_activate_fire_remnant_custom_caster = class({})

function modifier_ember_spirit_activate_fire_remnant_custom_caster:GetTexture()
	return "ember_spirit_fire_remnant"
end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_caster:IsHidden() return true end

function modifier_ember_spirit_activate_fire_remnant_custom_caster:OnCreated(params)
if not IsServer() then return end
local hCaster = self:GetParent()

self.fire_duration = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "duration", true)
self.fire_radius = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "radius", true) + 50

self.old_pos = self:GetParent():GetAbsOrigin()
self.dist = self.fire_radius

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
if not IsServer() then return end

local hAbility = self:GetAbility()

if not hAbility or hAbility.vLocation == nil then
	self:Destroy()
	return
end

self.dist = self.dist + (hAbility.vLocation - self.old_pos):Length2D()

if self:GetCaster():HasModifier("modifier_ember_remnant_4") and self.dist >= self.fire_radius then 
	self.dist = 0

	CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_ember_remnant_fire_thinker", {duration = self.fire_duration}, hAbility.vLocation, self:GetCaster():GetTeamNumber(), false)
end


self.hThinker:SetAbsOrigin(hAbility.vLocation)
me:SetAbsOrigin(hAbility.vLocation)
self.old_pos = hAbility.vLocation
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















modifier_ember_spirit_activate_fire_remnant_custom_blast_timer = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_blast_timer:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_custom_blast_timer:IsPurgable() return false end

function modifier_ember_spirit_activate_fire_remnant_custom_blast_timer:OnDestroy()
if not IsServer() then return end
if self:GetParent().mod == nil then return end  
local activate_ability = self:GetCaster():FindAbilityByName("ember_spirit_activate_fire_remnant_custom")
if not activate_ability then return end

activate_ability:Explosion(self:GetParent():GetAbsOrigin(), true)

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
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_legendary", "cast") + 2*FrameTime()
end

function ember_spirit_fire_remnant_burst:GetCooldown()
	return self:GetCaster():GetTalentValue("modifier_ember_remnant_legendary", "cd")
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




modifier_ember_spirit_activate_fire_remnant_custom_blast = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_blast:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_custom_blast:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_blast:OnCreated(table)
if not IsServer() then return end

self.ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
self.count = self:GetCaster():GetTalentValue("modifier_ember_remnant_legendary", "count")

self:SetStackCount(self.count )

self.interval = self:GetCaster():GetTalentValue("modifier_ember_remnant_legendary", "cast")/(self:GetStackCount() - 1)

self.radius = self:GetAbility():GetSpecialValueFor("range")
self.center = Vector(table.x, table.y, table.z)
self.vec = RandomVector(self.radius*0.7)

self.line_position = self.center + self.vec
self.qangle_rotation_rate = 360 / (self.count - 1)

local cast_pfx = ParticleManager:CreateParticle("particles/ember_spirit/legendary_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
ParticleManager:SetParticleControl(cast_pfx, 0, self.center)
ParticleManager:SetParticleControl(cast_pfx, 1, Vector(self.radius, 1, 1))
ParticleManager:ReleaseParticleIndex(cast_pfx)

self:OnIntervalThink()
self:StartIntervalThink(self.interval)
end

function modifier_ember_spirit_activate_fire_remnant_custom_blast:OnIntervalThink()
if not IsServer() then return end


if self.ability then 

	local pos = self.line_position
	if self:GetStackCount() == self.count then 
		pos = self.center
	end

	self.ability:Cast(self:GetAbility():GetName(), pos)
end

self:DecrementStackCount() 

if self:GetStackCount() <= 0 then 
	self:Destroy()
	self:GetParent():Stop()
end 


self.line_position = RotatePosition(self.center, QAngle(0, self.qangle_rotation_rate, 0), self.line_position)
end













modifier_ember_spirit_activate_fire_remnant_custom_burn = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_burn:IsHidden() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_burn:IsPurgable() return true end
function modifier_ember_spirit_activate_fire_remnant_custom_burn:GetTexture() return "buffs/remnant_slow" end
function modifier_ember_spirit_activate_fire_remnant_custom_burn:GetEffectName()
	return "particles/units/heroes/hero_phoenix/phoenix_icarus_dive_burn_debuff.vpcf"
end
function modifier_ember_spirit_activate_fire_remnant_custom_burn:GetStatusEffectName()
    return "particles/status_fx/status_effect_burn.vpcf"
end

function modifier_ember_spirit_activate_fire_remnant_custom_burn:StatusEffectPriority()
    return 1019999
end


function modifier_ember_spirit_activate_fire_remnant_custom_burn:OnCreated(table)

self.slow = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "slow")
self.max = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "max")
self.burn_interval = 0.5
self.stack_interval = 1
self.stack_count = -self.burn_interval
self.damage = self:GetCaster():GetTalentValue("modifier_ember_remnant_4", "damage")

if not IsServer() then return end

self.caster = self:GetCaster()
self.parent = self:GetParent()

self.parent:EmitSound("Ember.Fire_burn_target")

self.damage_table = {attacker = self.caster, victim = self.parent, ability = self:GetAbility(), damage_type = DAMAGE_TYPE_MAGICAL}
self:SetStackCount(1)
self:OnIntervalThink()
self:StartIntervalThink(self.burn_interval)
end


function modifier_ember_spirit_activate_fire_remnant_custom_burn:OnDestroy()
if not IsServer() then return end
self.parent:StopSound("Ember.Fire_burn_target")
end


function modifier_ember_spirit_activate_fire_remnant_custom_burn:OnIntervalThink()
if not IsServer() then return end 

self.damage_table.damage = self:GetStackCount()*self.damage*self.burn_interval

ApplyDamage(self.damage_table)

self.stack_count = self.stack_count + self.burn_interval

if self.stack_count < self.stack_interval then return end
self.stack_count = 0

if self:GetStackCount() < self.max then 
	self:IncrementStackCount()
end 

end


function modifier_ember_spirit_activate_fire_remnant_custom_burn:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}

end

function modifier_ember_spirit_activate_fire_remnant_custom_burn:GetModifierMoveSpeedBonus_Percentage()
return self.slow
end





modifier_ember_spirit_activate_fire_remnant_custom_heal = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_heal:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_custom_heal:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_heal:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_ember_spirit_activate_fire_remnant_custom_heal:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
}
end

function modifier_ember_spirit_activate_fire_remnant_custom_heal:GetModifierConstantHealthRegen()
return self.heal
end


function modifier_ember_spirit_activate_fire_remnant_custom_heal:OnCreated()
self.heal = self:GetCaster():GetTalentValue("modifier_ember_remnant_2", "heal")/self:GetCaster():GetTalentValue("modifier_ember_remnant_2", "duration")
end


function modifier_ember_spirit_activate_fire_remnant_custom_heal:OnDestroy()
if not IsServer() then return end

local mod = self:GetParent():FindModifierByName("modifier_ember_spirit_activate_fire_remnant_custom_heal_count")

if mod then 
	mod:DecrementStackCount()
	if mod:GetStackCount() == 0 then 
		mod:Destroy()
	end
end

end






modifier_ember_spirit_activate_fire_remnant_custom_heal_count = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_heal_count:GetTexture() return "buffs/leap_resist" end
function modifier_ember_spirit_activate_fire_remnant_custom_heal_count:IsHidden() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_heal_count:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_heal_count:OnCreated(table)
self.heal = self:GetCaster():GetTalentValue("modifier_ember_remnant_2", "heal")/self:GetCaster():GetTalentValue("modifier_ember_remnant_2", "duration")
self:SetStackCount(1)
end

function modifier_ember_spirit_activate_fire_remnant_custom_heal_count:OnRefresh(table)
if not IsServer() then return end

self:IncrementStackCount()
end

function modifier_ember_spirit_activate_fire_remnant_custom_heal_count:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOOLTIP
}
end

function modifier_ember_spirit_activate_fire_remnant_custom_heal_count:OnTooltip()
return self:GetStackCount()*self.heal
end
























modifier_ember_spirit_activate_fire_remnant_stack_count = class({})
function modifier_ember_spirit_activate_fire_remnant_stack_count:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_stack_count:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_stack_count:RemoveOnDeath() return false end
function modifier_ember_spirit_activate_fire_remnant_stack_count:OnCreated()
if not IsServer() then return end 
self.timer = self:GetCaster():GetTalentValue("modifier_ember_remnant_5", "duration")
self.max = self:GetCaster():GetTalentValue("modifier_ember_remnant_5", "max")
self:SetStackCount(1)

self:StartIntervalThink(self.timer)
end 

function modifier_ember_spirit_activate_fire_remnant_stack_count:OnRefresh()
if not IsServer() then return end 
self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
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
local damage = self:GetStackCount()

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID()), 'ember_remnant_change',  {max = self.max, damage = damage})

end 


function modifier_ember_spirit_activate_fire_remnant_stack_count:Trigger()
if not IsServer() then return end 
local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
ParticleManager:SetParticleControlEnt( particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
ParticleManager:ReleaseParticleIndex(particle)

self:GetCaster():EmitSound("Sniper.Shrapnel_legendary")

local ability = self:GetCaster():FindAbilityByName("ember_spirit_fire_remnant_custom")
if not ability then return end

ability:ChangeCharges(1)

end






modifier_ember_spirit_activate_fire_remnant_custom_amp = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_amp:IsHidden() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_amp:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_custom_amp:GetTexture() return "buffs/acorn_range" end
function modifier_ember_spirit_activate_fire_remnant_custom_amp:OnCreated()

self.max = self:GetCaster():GetTalentValue("modifier_ember_remnant_3", "max")
self.damage = self:GetCaster():GetTalentValue("modifier_ember_remnant_3", "amp")
self:SetStackCount(1)
end

function modifier_ember_spirit_activate_fire_remnant_custom_amp:OnRefresh()
if not IsServer() then return end 
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end

function modifier_ember_spirit_activate_fire_remnant_custom_amp:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
}
end

function modifier_ember_spirit_activate_fire_remnant_custom_amp:GetModifierSpellAmplify_Percentage()
return self:GetStackCount()*self.damage
end




modifier_ember_spirit_activate_fire_remnant_attack_slow = class({})
function modifier_ember_spirit_activate_fire_remnant_attack_slow:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_attack_slow:IsPurgable() return true end

function modifier_ember_spirit_activate_fire_remnant_attack_slow:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MISS_PERCENTAGE
}
end

function modifier_ember_spirit_activate_fire_remnant_attack_slow:OnCreated(params)

self.miss_chance = self:GetCaster():GetTalentValue("modifier_ember_remnant_6", "miss")
end


function modifier_ember_spirit_activate_fire_remnant_attack_slow:GetModifierMiss_Percentage()
return self.miss_chance
end

function modifier_ember_spirit_activate_fire_remnant_attack_slow:GetEffectName()
return "particles/ember_spirit/attack_slow.vpcf"
end






modifier_ember_spirit_activate_fire_remnant_silence_cd = class({})
function modifier_ember_spirit_activate_fire_remnant_silence_cd:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_silence_cd:IsPurgable() return false end
function modifier_ember_spirit_activate_fire_remnant_silence_cd:RemoveOnDeath() return false end
function modifier_ember_spirit_activate_fire_remnant_silence_cd:IsDebuff() return true end
function modifier_ember_spirit_activate_fire_remnant_silence_cd:OnCreated()
self.RemoveForDuel = true
end










modifier_ember_spirit_activate_fire_remnant_custom_speed = class({})
function modifier_ember_spirit_activate_fire_remnant_custom_speed:IsHidden() return true end
function modifier_ember_spirit_activate_fire_remnant_custom_speed:IsPurgable() return false end

function modifier_ember_spirit_activate_fire_remnant_custom_speed:GetEffectName()
	return "particles/units/heroes/hero_marci/marci_rebound_allymovespeed.vpcf"
end
function modifier_ember_spirit_activate_fire_remnant_custom_speed:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_ember_spirit_activate_fire_remnant_custom_speed:OnCreated()
self.move = self:GetCaster():GetTalentValue("modifier_ember_remnant_1", 'move')
end


function modifier_ember_spirit_activate_fire_remnant_custom_speed:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_ember_spirit_activate_fire_remnant_custom_speed:GetModifierMoveSpeedBonus_Percentage()
return self.move
end