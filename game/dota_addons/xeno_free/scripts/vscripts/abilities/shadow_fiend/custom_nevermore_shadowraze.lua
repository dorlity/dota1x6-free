LinkLuaModifier("modifier_custom_shadowraze_debuff", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_combo", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_slow", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_silence", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_speedmax", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_tracker", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_cd", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_auto", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_slow_auto", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_quest", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_slow_stack", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_silence_cd", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nevermore_requiem_fear_cd", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_shadowraze_slow_cd", "abilities/shadow_fiend/custom_nevermore_shadowraze", LUA_MODIFIER_MOTION_NONE)



custom_nevermore_shadowraze_close =  class({})
custom_nevermore_shadowraze_far = class({})
custom_nevermore_shadowraze_medium = class({})


custom_nevermore_shadowraze_close.cd_init = 0
custom_nevermore_shadowraze_close.cd_inc = 1

custom_nevermore_shadowraze_close.damage_inc = {10, 15, 20}

custom_nevermore_shadowraze_close.legendary_timer = 3
custom_nevermore_shadowraze_close.legendary_cd = 0.2
custom_nevermore_shadowraze_close.legendary_damage = 0.6
custom_nevermore_shadowraze_close.legendary_mana = 0.6



custom_nevermore_shadowraze_close.stack_duration = 20	






function custom_nevermore_shadowraze_close:Precache(context)


PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/nvm_atk_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/nvm_atk_blur_b.vpcf", context )


PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf", context )
PrecacheResource( "particle", "particles/sf_double_.vpcf", context )
PrecacheResource( "particle", "particles/sf_refresh_a.vpcf", context )
PrecacheResource( "particle", "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze_triple.vpcf", context )

end




function custom_nevermore_shadowraze_close:GetCastPoint()
if self:GetCaster():HasShard() then
	return 0.55 + self:GetSpecialValueFor("shard_delay")
end

return 0.55
end
function custom_nevermore_shadowraze_medium:GetCastPoint()
if self:GetCaster():HasShard() then
	return 0.55 + self:GetSpecialValueFor("shard_delay")
end

return 0.55
end

function custom_nevermore_shadowraze_far:GetCastPoint()
if self:GetCaster():HasShard() then
	return 0.55 + self:GetSpecialValueFor("shard_delay")
end

return 0.55
end




custom_nevermore_shadowraze_far.cd_init = 0
custom_nevermore_shadowraze_far.cd_inc = 1

custom_nevermore_shadowraze_far.damage_inc = {10, 15, 20}

custom_nevermore_shadowraze_far.legendary_cd = 0.2
custom_nevermore_shadowraze_far.legendary_timer = 3
custom_nevermore_shadowraze_far.legendary_damage = 0.6
custom_nevermore_shadowraze_far.legendary_mana = 0.6


custom_nevermore_shadowraze_far.stack_duration = 20	




custom_nevermore_shadowraze_medium.cd_init = 0
custom_nevermore_shadowraze_medium.cd_inc = 1

custom_nevermore_shadowraze_medium.damage_inc = {10, 15, 20}

custom_nevermore_shadowraze_medium.legendary_timer = 3
custom_nevermore_shadowraze_medium.legendary_cd = 0.2
custom_nevermore_shadowraze_medium.legendary_damage = 0.6
custom_nevermore_shadowraze_medium.legendary_mana = 0.6


custom_nevermore_shadowraze_medium.stack_duration = 20		






function custom_nevermore_shadowraze_close:GetIntrinsicModifierName()
return "modifier_custom_shadowraze_tracker"
end


function custom_nevermore_shadowraze_close:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_nevermore_raze_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_raze_cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
end



function custom_nevermore_shadowraze_close:GetAbilityTextureName()
   return "nevermore_shadowraze1"
end

function custom_nevermore_shadowraze_close:IsHiddenWhenStolen()
	return false
end

function custom_nevermore_shadowraze_close:GetManaCost(level)
local caster = self:GetCaster()
local manacost = self.BaseClass.GetManaCost(self, level)
local k = 1

if self:GetCaster():HasModifier("modifier_nevermore_raze_legendary") then 
	k = self.legendary_mana
end

return manacost * k
end


function custom_nevermore_shadowraze_close:OnUpgrade()
	local caster = self:GetCaster()
	UpgradeShadowRazes(caster, self)
end



function custom_nevermore_shadowraze_close:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_shadow_07", "nevermore_nev_ability_shadow_18", "nevermore_nev_ability_shadow_21"}
	local sound_raze = "Hero_Nevermore.Shadowraze"
	caster:EmitSound(sound_raze)

	-- Ability specials
	local raze_radius = ability:GetSpecialValueFor("shadowraze_radius")
	local raze_distance = ability:GetSpecialValueFor("shadowraze_range")


	local t = CustomNetTables:GetTableValue("server_data", tostring(caster:GetPlayerID()))

	print(t.total_games)

	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance

	CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)

end


------------------------------------
--     SHADOW RAZE (MEDIUM)       --
------------------------------------



function custom_nevermore_shadowraze_medium:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_nevermore_raze_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_raze_cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
end

function custom_nevermore_shadowraze_medium:GetAbilityTextureName()
   return "nevermore_shadowraze2"
end

function custom_nevermore_shadowraze_medium:IsHiddenWhenStolen()
	return false
end

function custom_nevermore_shadowraze_medium:GetManaCost(level)
local caster = self:GetCaster()
local manacost = self.BaseClass.GetManaCost(self, level)
local k = 1

if self:GetCaster():HasModifier("modifier_nevermore_raze_legendary") then 
	k = self.legendary_mana
end

return manacost * k
end


function custom_nevermore_shadowraze_medium:OnUpgrade()
	local caster = self:GetCaster()
	UpgradeShadowRazes(caster, self)
end



function custom_nevermore_shadowraze_medium:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_shadow_08", "nevermore_nev_ability_shadow_20", "nevermore_nev_ability_shadow_22"}
	local sound_raze = "Hero_Nevermore.Shadowraze"
	caster:EmitSound(sound_raze)

	-- Ability specials
	local raze_radius = ability:GetSpecialValueFor("shadowraze_radius")
	local raze_distance = ability:GetSpecialValueFor("shadowraze_range")


	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance

	CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)


end

------------------------------------
--       SHADOW RAZE (FAR)        --
------------------------------------




function custom_nevermore_shadowraze_far:GetCooldown(iLevel)
local upgrade_cooldown = 0 

if self:GetCaster():HasModifier("modifier_nevermore_raze_cd") then 
  upgrade_cooldown = self.cd_init + self.cd_inc*self:GetCaster():GetUpgradeStack("modifier_nevermore_raze_cd")
end

 return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
 
end

function custom_nevermore_shadowraze_far:GetAbilityTextureName()
   return "nevermore_shadowraze3"
end

function custom_nevermore_shadowraze_far:IsHiddenWhenStolen()
	return false
end

function custom_nevermore_shadowraze_far:GetManaCost(level)
local caster = self:GetCaster()
local manacost = self.BaseClass.GetManaCost(self, level)

local k = 1

if self:GetCaster():HasModifier("modifier_nevermore_raze_legendary") then 
	k = self.legendary_mana
end

return manacost * k
end



function custom_nevermore_shadowraze_far:OnUpgrade()
	local caster = self:GetCaster()
	UpgradeShadowRazes(caster, self)
end

function custom_nevermore_shadowraze_far:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local cast_response = {"nevermore_nev_ability_shadow_11", "nevermore_nev_ability_shadow_19", "nevermore_nev_ability_shadow_23"}
	local sound_raze = "Hero_Nevermore.Shadowraze"
	caster:EmitSound(sound_raze)
	local raze_radius = ability:GetSpecialValueFor("shadowraze_radius")
	local raze_distance = ability:GetSpecialValueFor("shadowraze_range")

	local raze_point = caster:GetAbsOrigin() + caster:GetForwardVector() * raze_distance

	CastShadowRazeOnPoint(caster, ability, raze_point, raze_radius)


end


-------------------------
-- Shadowraze Handlers --
-------------------------


function CastShadowRazeOnPoint(caster, ability, point, radius, auto)

	local particle_raze = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"

	if caster:GetModelName() == "models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl" then 
		particle_raze = "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze.vpcf"
	end

	local modifier = ""
	local duration = 0 
	local sound = ""

	if not auto then 
		if ability:GetAbilityName() == "custom_nevermore_shadowraze_close" then 
		   modifier = "modifier_nevermore_requiem_fear"
		   sound = "Sf.Raze_Stun"
		   duration = caster:GetTalentValue("modifier_nevermore_raze_combocd", "fear")
		end

		if ability:GetAbilityName() == "custom_nevermore_shadowraze_medium" then 
		   modifier = "modifier_custom_shadowraze_silence"
		   sound = "Sf.Raze_Silence"
		   duration = caster:GetTalentValue("modifier_nevermore_raze_combocd", "silence")
		end

		if ability:GetAbilityName() == "custom_nevermore_shadowraze_far" then 
		   modifier = "modifier_custom_shadowraze_slow"
		   sound = "Sf.Raze_Slow"
		   duration = caster:GetTalentValue("modifier_nevermore_raze_combocd", "duration")
		end
	end


	local particle_raze_fx = ParticleManager:CreateParticle(particle_raze, PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(particle_raze_fx, 0, point)
	ParticleManager:SetParticleControl(particle_raze_fx, 1, Vector(radius, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_raze_fx)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), point,  nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_NONE,  FIND_ANY_ORDER,  false)

	if #enemies > 0 then
		if (caster:HasModifier("modifier_nevermore_raze_legendary") ) 
			and not ((#enemies== 1) and ((enemies[1]:IsBuilding() or enemies[1]:GetUnitName() == "npc_roshan_custom") )) then 	
			caster:AddNewModifier(caster, ability, "modifier_custom_shadowraze_combo", {duration = ability.legendary_timer})
		end

		if caster:HasModifier("modifier_nevermore_raze_speed") then 
			caster:AddNewModifier(caster, ability, "modifier_custom_shadowraze_speedmax", {duration =  caster:GetTalentValue("modifier_nevermore_raze_speed", "duration")})
		end
	end

	local creeps = 0 
	local heroes = 0

	for _,enemy in pairs(enemies) do
		if not enemy:IsMagicImmune()  then

			if enemy:IsCreep() or enemy:IsIllusion() then 
				creeps = creeps + 1
			end

			if enemy:IsRealHero() then 
				heroes = heroes + 1
			end


			if caster:HasModifier("modifier_nevermore_raze_combocd") and not enemy:IsBuilding() and not enemy:HasModifier(modifier..'_cd') then
				enemy:AddNewModifier(caster, ability, modifier, {duration = duration * (1 - enemy:GetStatusResistance())})
				enemy:AddNewModifier(caster, ability, modifier..'_cd', {duration = caster:GetTalentValue("modifier_nevermore_raze_combocd", "cd")})
				enemy:EmitSound(sound)
			end	

			if auto then 
				enemy:AddNewModifier(caster, ability, "modifier_custom_shadowraze_slow_auto", {duration = caster:GetTalentValue("modifier_nevermore_raze_burn", "duration")*(1 - enemy:GetStatusResistance())})
			end

			if enemy:IsRealHero() and caster:GetQuest() == "Never.Quest_5" then 
				enemy:AddNewModifier(caster, ability, "modifier_custom_shadowraze_quest", {duration = 3})
			end

			ApplyShadowRazeDamage(caster, ability, enemy)
		end
		
	end


	if caster:HasModifier("modifier_nevermore_requiem_bkb") and (creeps > 0 or heroes > 0) then 
		local ult_ability = caster:FindAbilityByName("custom_nevermore_requiem")

		if ult_ability then 
			ult_ability:ReduceCd(1, heroes <= 0)
		end
	end

end

function ApplyShadowRazeDamage(caster, ability, enemy)

local damage = ability:GetSpecialValueFor("shadowraze_damage")
local stack_bonus_damage = ability:GetSpecialValueFor("stack_bonus_damage")
local duration = ability:GetSpecialValueFor("duration") + ability.stack_duration*caster:GetUpgradeStack("modifier_nevermore_raze_duration")
local modifier_debuff = "modifier_custom_shadowraze_debuff"
local debuff_boost = 0

if caster:HasModifier("modifier_nevermore_raze_damage") then 
	stack_bonus_damage = stack_bonus_damage + ability.damage_inc[caster:GetUpgradeStack("modifier_nevermore_raze_damage")]
end


if caster:HasShard() then 
	damage = damage + ability:GetSpecialValueFor("shard_damage")*caster:GetAverageTrueAttackDamage(nil)/100
end

if caster:HasModifier("modifier_nevermore_raze_legendary") then 
	damage = damage*ability.legendary_damage	
end

if enemy:HasModifier(modifier_debuff) then
	debuff_boost	= enemy:FindModifierByName(modifier_debuff):GetStackCount() * (stack_bonus_damage )
end

damage 	= damage + debuff_boost 
	


local damageTable = {victim = enemy,damage = damage,damage_type = DAMAGE_TYPE_MAGICAL,attacker = caster,ability = ability}

local actualy_damage = ApplyDamage(damageTable)    
	

if not enemy:HasModifier(modifier_debuff) and not enemy:IsBuilding() then
	enemy:AddNewModifier(caster, ability, modifier_debuff, {duration = duration * (1 - enemy:GetStatusResistance())})
end

enemy:AddNewModifier(caster, ability, "modifier_custom_shadowraze_slow_stack", {duration = (1 - enemy:GetStatusResistance())*ability:GetSpecialValueFor("duration")})

	
local modifier_debuff_counter = enemy:FindModifierByName(modifier_debuff)
if modifier_debuff_counter then
	modifier_debuff_counter:IncrementStackCount()
	modifier_debuff_counter:ForceRefresh()
end

end

function UpgradeShadowRazes(caster, ability)
	local raze_close = "custom_nevermore_shadowraze_close"
	local raze_medium = "custom_nevermore_shadowraze_medium"
	local raze_far = "custom_nevermore_shadowraze_far"

	-- Get handles
	local raze_close_handler
	local raze_medium_handler
	local raze_far_handler

	if caster:HasAbility(raze_close) then
		raze_close_handler = caster:FindAbilityByName(raze_close)
	end

	if caster:HasAbility(raze_medium) then
		raze_medium_handler = caster:FindAbilityByName(raze_medium)
	end

	if caster:HasAbility(raze_far) then
		raze_far_handler = caster:FindAbilityByName(raze_far)
	end

	-- Get the level to compare
	local leveled_ability_level = ability:GetLevel()

	if raze_close_handler and raze_close_handler:GetLevel() < leveled_ability_level then
		raze_close_handler:SetLevel(leveled_ability_level)
	end

	if raze_medium_handler and raze_medium_handler:GetLevel() < leveled_ability_level then
		raze_medium_handler:SetLevel(leveled_ability_level)
	end

	if raze_far_handler and raze_far_handler:GetLevel() < leveled_ability_level then
		raze_far_handler:SetLevel(leveled_ability_level)
	end
end



-- Modifier to track increasing raze damage
modifier_custom_shadowraze_debuff = class ({})

function modifier_custom_shadowraze_debuff:IsDebuff() return true end
function modifier_custom_shadowraze_debuff:IsPurgable()
if self:GetCaster():HasModifier("modifier_nevermore_raze_duration") then 
	return false
else
	return true
end	

end

function modifier_custom_shadowraze_debuff:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOOLTIP2,
}
end

function modifier_custom_shadowraze_debuff:OnTooltip()
local bonus = 0
if self:GetCaster():HasModifier("modifier_nevermore_raze_damage") then 
	bonus = bonus + self:GetAbility().damage_inc[self:GetCaster():GetUpgradeStack("modifier_nevermore_raze_damage")]
end

return self:GetStackCount() * ( self:GetAbility():GetSpecialValueFor("stack_bonus_damage") + bonus )
end



function modifier_custom_shadowraze_debuff:OnCreated(table)
	self.RemoveForDuel = true

	self.slow = self:GetAbility():GetSpecialValueFor("slow_move")
	self.max = self:GetAbility():GetSpecialValueFor("slow_max")
end







modifier_custom_shadowraze_combo = class({})
function modifier_custom_shadowraze_combo:IsHidden() return false end
function modifier_custom_shadowraze_combo:IsPurgable() return false end

function modifier_custom_shadowraze_combo:OnCreated(table)
if not IsServer() then return end
	self:SetStackCount(1)
end

function modifier_custom_shadowraze_combo:OnRefresh(table)
if not IsServer() then return end


if self:GetStackCount() < 3 then 
	self:IncrementStackCount()
	
	if self:GetStackCount() == 2 and self:GetParent():HasModifier("modifier_nevermore_raze_legendary") then 
		self.particle_head = ParticleManager:CreateParticle("particles/sf_double_.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
   		 ParticleManager:SetParticleControl( self.particle_head, 0,  self:GetParent():GetOrigin())
   		 ParticleManager:ReleaseParticleIndex(self.particle_head)
	end

	if self:GetStackCount() >= 3 then 




		if self:GetParent():HasModifier("modifier_nevermore_raze_legendary") then 

			local ability = self:GetParent():FindAbilityByName("custom_nevermore_shadowraze_close")
			if ability then 
				if ability:GetCooldownTimeRemaining() > ability.legendary_cd then 
					ability:EndCooldown()
					ability:StartCooldown(ability.legendary_cd)
				end
			end

			ability = self:GetParent():FindAbilityByName("custom_nevermore_shadowraze_medium")
			if ability then 
				if ability:GetCooldownTimeRemaining() > ability.legendary_cd then 
					ability:EndCooldown()
					ability:StartCooldown(ability.legendary_cd)
				end
			end

			ability = self:GetParent():FindAbilityByName("custom_nevermore_shadowraze_far")
			if ability then 
				if ability:GetCooldownTimeRemaining() > ability.legendary_cd then 
					ability:EndCooldown()
					ability:StartCooldown(ability.legendary_cd)
				end
			end

			local particle = ParticleManager:CreateParticle("particles/sf_refresh_a.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
   			ParticleManager:SetParticleControlEnt( particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetOrigin(), true )
   			ParticleManager:ReleaseParticleIndex(particle)

    		if self.particle_head then 
   	 			ParticleManager:DestroyParticle(self.particle_head, true)
   			end

    		self.particle_head = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_shadowraze_triple.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
   			ParticleManager:SetParticleControl( self.particle_head, 0,  self:GetParent():GetOrigin())
   			ParticleManager:ReleaseParticleIndex(self.particle_head)
    

    		self:GetParent():EmitSound("Hero_Rattletrap.Overclock.Cast")	
    	end

		self:Destroy()

	end
end



end

modifier_custom_shadowraze_silence = class({})
modifier_custom_shadowraze_slow = class({})


function modifier_custom_shadowraze_silence:IsHidden() return false end
function modifier_custom_shadowraze_silence:IsPurgable() return true end
function modifier_custom_shadowraze_silence:CheckState() return {[MODIFIER_STATE_SILENCED] = true} end
function modifier_custom_shadowraze_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
function modifier_custom_shadowraze_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end

function modifier_custom_shadowraze_slow:IsHidden() return false end
function modifier_custom_shadowraze_slow:IsPurgable() return true end
function modifier_custom_shadowraze_slow:DeclareFunctions() return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end
function modifier_custom_shadowraze_slow:GetModifierMoveSpeedBonus_Percentage() return self.slow end

function modifier_custom_shadowraze_slow:OnCreated()

self.slow = self:GetCaster():GetTalentValue("modifier_nevermore_raze_combocd", "slow")
end




modifier_custom_shadowraze_speedmax = class({})

function modifier_custom_shadowraze_speedmax:IsPurgable() return true end
function modifier_custom_shadowraze_speedmax:IsHidden() return false end
function modifier_custom_shadowraze_speedmax:GetTexture() return "buffs/raze_speed" end

function modifier_custom_shadowraze_speedmax:OnCreated(table)

self.move = self:GetCaster():GetTalentValue("modifier_nevermore_raze_speed", "speed")
self.heal = self:GetCaster():GetTalentValue("modifier_nevermore_raze_speed", "heal")
self.max = self:GetCaster():GetTalentValue("modifier_nevermore_raze_speed", "max")

if not IsServer() then return end
self:SetStackCount(1)
self:GetCaster():EmitSound("Sf.Speed_Heal")     

end

function modifier_custom_shadowraze_speedmax:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
end

function modifier_custom_shadowraze_speedmax:GetEffectName()
return "particles/generic_gameplay/rune_haste_owner.vpcf"
end
function modifier_custom_shadowraze_speedmax:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
}

end


function modifier_custom_shadowraze_speedmax:GetModifierMoveSpeedBonus_Percentage() 
return self.move*self:GetStackCount()
end


function modifier_custom_shadowraze_speedmax:GetModifierConstantHealthRegen()
return self.heal*self:GetStackCount()
end


modifier_custom_shadowraze_tracker = class({})
function modifier_custom_shadowraze_tracker:IsHidden() return true end
function modifier_custom_shadowraze_tracker:IsPurgable() return false end
function modifier_custom_shadowraze_tracker:OnCreated(table)
if not IsServer() then return end
self:StartIntervalThink(0.2)
end

function modifier_custom_shadowraze_tracker:OnIntervalThink()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if not self:GetParent():HasModifier("modifier_nevermore_raze_burn") then return end
if self:GetParent():HasModifier("modifier_custom_shadowraze_cd") then return end
if self:GetParent():IsInvisible() then return end

local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetCaster():GetTalentValue("modifier_nevermore_raze_burn", "radius"),  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

if #enemies == 0 then return end



CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_custom_shadowraze_auto", {duration = self:GetCaster():GetTalentValue("modifier_nevermore_raze_burn", "delay")}, enemies[1]:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_custom_shadowraze_cd", {duration = self:GetCaster():GetTalentValue("modifier_nevermore_raze_burn", "cd")})
end

modifier_custom_shadowraze_cd = class({})
function modifier_custom_shadowraze_cd:IsHidden() return false end
function modifier_custom_shadowraze_cd:IsPurgable() return false end
function modifier_custom_shadowraze_cd:GetTexture() return "buffs/raze_burn" end
function modifier_custom_shadowraze_cd:IsDebuff() return true end
function modifier_custom_shadowraze_cd:RemoveOnDeath() return false end





modifier_custom_shadowraze_auto = class({})

function modifier_custom_shadowraze_auto:IsHidden() return true end
function modifier_custom_shadowraze_auto:IsPurgable() return false end
function modifier_custom_shadowraze_auto:OnCreated(table)
if not IsServer() then return end

self.radius = self:GetAbility():GetSpecialValueFor("shadowraze_radius")*self:GetCaster():GetTalentValue("modifier_nevermore_raze_burn", "aoe")

local particle_cast = "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_calldown.vpcf"
self.effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, self:GetParent())
ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetOrigin() )
ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.radius, 0, -self.radius) )
ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( self:GetRemainingTime(), 0, 0 ) )

end





function modifier_custom_shadowraze_auto:OnDestroy(table)
if not IsServer() then return end
if not self:GetCaster() then return end
if not self:GetCaster():IsAlive() then return end

ParticleManager:DestroyParticle( self.effect_cast, true )
ParticleManager:ReleaseParticleIndex( self.effect_cast )

local sound_raze = "Hero_Nevermore.Shadowraze"
self:GetParent():EmitSound(sound_raze)

CastShadowRazeOnPoint(self:GetCaster(), self:GetAbility(), self:GetParent():GetAbsOrigin(), self.radius, true)


end

modifier_custom_shadowraze_slow_auto = class({})
function modifier_custom_shadowraze_slow_auto:IsHidden() return true end
function modifier_custom_shadowraze_slow_auto:IsPurgable() return true end
function modifier_custom_shadowraze_slow_auto:GetEffectName() return "particles/sf_slow_attack.vpcf" end

function modifier_custom_shadowraze_slow_auto:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
}
end
function modifier_custom_shadowraze_slow_auto:GetModifierMoveSpeedBonus_Percentage()

return self.slow

end


function modifier_custom_shadowraze_slow_auto:OnCreated()
self.slow = self:GetCaster():GetTalentValue("modifier_nevermore_raze_burn", "slow")
end



modifier_custom_shadowraze_quest = class({})
function modifier_custom_shadowraze_quest:IsHidden() return true end
function modifier_custom_shadowraze_quest:IsPurgable() return false end
function modifier_custom_shadowraze_quest:OnCreated(table)
if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_custom_shadowraze_quest:OnRefresh(table)
if not IsServer() then return end
if not self:GetCaster():GetQuest() then return end

self:IncrementStackCount()
if self:GetStackCount() >= self:GetCaster().quest.number then 
	self:Destroy()
	self:GetCaster():UpdateQuest(1)
end


end


modifier_custom_shadowraze_slow_stack = class({})
function modifier_custom_shadowraze_slow_stack:IsHidden() return true end
function modifier_custom_shadowraze_slow_stack:IsPurgable() return true end
function modifier_custom_shadowraze_slow_stack:OnCreated(table)
self.slow = self:GetAbility():GetSpecialValueFor("slow_move")
self.max = self:GetAbility():GetSpecialValueFor("slow_max")

if not IsServer() then return end

self:SetStackCount(1)
end

function modifier_custom_shadowraze_slow_stack:OnRefresh(table)
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()

end

function modifier_custom_shadowraze_slow_stack:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
}
end


function modifier_custom_shadowraze_slow_stack:GetModifierMoveSpeedBonus_Percentage()

return self:GetStackCount()*self.slow
end



modifier_custom_shadowraze_slow_cd = class({})
function modifier_custom_shadowraze_slow_cd:IsHidden() return true end
function modifier_custom_shadowraze_slow_cd:IsPurgable() return false end
function modifier_custom_shadowraze_slow_cd:RemoveOnDeath() return false end
function modifier_custom_shadowraze_slow_cd:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true
end 

modifier_custom_shadowraze_silence_cd = class({})
function modifier_custom_shadowraze_silence_cd:IsHidden() return true end
function modifier_custom_shadowraze_silence_cd:IsPurgable() return false end
function modifier_custom_shadowraze_silence_cd:RemoveOnDeath() return false end
function modifier_custom_shadowraze_silence_cd:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true
end 

modifier_nevermore_requiem_fear_cd = class({})
function modifier_nevermore_requiem_fear_cd:IsHidden() return true end
function modifier_nevermore_requiem_fear_cd:IsPurgable() return false end
function modifier_nevermore_requiem_fear_cd:RemoveOnDeath() return false end
function modifier_nevermore_requiem_fear_cd:OnCreated()
if not IsServer() then return end

self.RemoveForDuel = true
end 