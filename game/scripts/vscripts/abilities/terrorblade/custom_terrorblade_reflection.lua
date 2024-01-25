LinkLuaModifier("modifier_custom_terrorblade_reflection_slow", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_unit", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_spells", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_legendary_saved", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_silence", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_attributes", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_custom_terrorblade_reflection_gold", "abilities/terrorblade/custom_terrorblade_reflection", LUA_MODIFIER_MOTION_NONE)

 





custom_terrorblade_reflection = class({})


custom_terrorblade_reflection.cd_inc = {3, 4, 5}

custom_terrorblade_reflection.slow_attack = {-20, -30, -40}
custom_terrorblade_reflection.slow_move = {-10, -15, -20}

custom_terrorblade_reflection.main_silence = 2.5
custom_terrorblade_reflection.main_bash_chance = 15
custom_terrorblade_reflection.main_bash = 1
custom_terrorblade_reflection.main_heal = 0.015
custom_terrorblade_reflection.main_all = 0.33


custom_terrorblade_reflection.dispel_duration = 1.5
custom_terrorblade_reflection.dispel_heal = -25
	

custom_terrorblade_reflection.legendary_cd = 2



function custom_terrorblade_reflection:GetManaCost(level)


if self:GetCaster():HasModifier("modifier_terror_meta_legendary") then 
	return 0
end

return self.BaseClass.GetManaCost(self,level)
end



function custom_terrorblade_reflection:Precache(context)
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_weapon_blur.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_weapon_blur_both.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_weapon_blur_reverse.vpcf", context )


PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_str.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_agi.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_terrorblade_reflection.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf", context )
PrecacheResource( "particle", "particles/huskar_timer.vpcf", context )

end




function custom_terrorblade_reflection:GetIntrinsicModifierName()
return "modifier_custom_terrorblade_reflection_gold"
end

function custom_terrorblade_reflection:GetCooldown(iLevel)

local upgrade_cooldown = 0

if self:GetCaster():HasModifier("modifier_terror_reflection_duration") then 
	upgrade_cooldown = self.cd_inc[self:GetCaster():GetUpgradeStack("modifier_terror_reflection_duration")]
end

return self.BaseClass.GetCooldown(self, iLevel) - upgrade_cooldown
end

function custom_terrorblade_reflection:GetBehavior()
  if self:GetCaster():HasModifier("modifier_terror_reflection_legendary") then
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST end
 return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
end



function custom_terrorblade_reflection:GetAOERadius()
	return self:GetSpecialValueFor("range")
end




function custom_terrorblade_reflection:OnSpellStart()
if not IsServer() then return end


local caster = self:GetCaster()

local targets = FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS +  DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)


local creeps = FindUnitsInRadius(caster:GetTeamNumber(), self:GetCursorPosition(), nil, self:GetSpecialValueFor("range"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS +  DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)

if caster:HasModifier("modifier_terror_reflection_legendary") then

    if self:GetAutoCastState() == false and #targets > 0 then 

		local save = targets[RandomInt(1, #targets)]

		local particle_cast = ''
		if save:GetPrimaryAttribute() == 1 then 
			particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_agi.vpcf"
		end
		if save:GetPrimaryAttribute() == 0 then 
			particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_str.vpcf"
		end
		if save:GetPrimaryAttribute() > 1 then 
			particle_cast = "particles/units/heroes/hero_void_spirit/pulse/void_spirit_int.vpcf"
		end



		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt( effect_cast, 0, save, PATTACH_POINT_FOLLOW, "attach_hitloc", save:GetAbsOrigin(),  true )
		ParticleManager:SetParticleControlEnt( effect_cast, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true  )
		ParticleManager:ReleaseParticleIndex( effect_cast )


		local mod = caster:FindModifierByName("modifier_custom_terrorblade_reflection_legendary_saved")

		if mod then 
			mod:Destroy()
		end

		mod = caster:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_legendary_saved", {name = save:GetUnitName()})
		mod.level = save:GetLevel()
		mod.abilities = {}

		for abilitySlot = 0,15 do

			local ability = save:GetAbilityByIndex(abilitySlot)

			if ability ~= nil then

				mod.abilities[abilitySlot] = {}

				mod.abilities[abilitySlot].level = ability:GetLevel()
				mod.abilities[abilitySlot].name = ability:GetAbilityName()

			end
		end

		mod.items = {}
		for itemSlot=0,5 do

			local item = save:GetItemInSlot(itemSlot)

			if item ~= nil then

				mod.items[itemSlot] = item:GetName()

			end
	    end

	    mod.talents = {}
	    local j = 0
	    for _,modifier in pairs(save:FindAllModifiers()) do 

	    	if (modifier.StackOnIllusion ~= nil and modifier.StackOnIllusion == true) or modifier:GetName() == "modifier_item_aghanims_shard" then
	    		j = j + 1
	    		mod.talents[j] = {}
	    		mod.talents[j].name = modifier:GetName()
	    		mod.talents[j].level = modifier:GetStackCount()
			end
	    end



	end
end

if #creeps > 0 then 


	local max = 0

	for i,creep in pairs(creeps) do
		if not creep:IsHero() and (creep:IsCreep() or creep:IsConsideredHero()) then
			max = max + 1
			table.insert(targets, creep) 
			if max == self:GetSpecialValueFor("creeps_max") then 
				break
			end
		end
	end
end

for _,enemy in pairs(targets) do	

	self:LaunchIllusion(enemy, 0)
end

end


function custom_terrorblade_reflection:IllusionBuff(illusion, enemy, double)
if not IsServer() then return end

local caster = self:GetCaster()

illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_unit", {double = double, duration = self.duration * (1 - enemy:GetStatusResistance()), enemy_entindex = enemy:entindex()})

illusion.owner = caster
illusion.is_reflection = true 


if double == 0 and caster:HasModifier("modifier_terror_reflection_stun") and 
	(illusion:GetPrimaryAttribute() == 0 or illusion:GetPrimaryAttribute() == 1 or illusion:GetPrimaryAttribute() == 3) then

	illusion:AddNewModifier(self:GetCaster(), self, "modifier_custom_terrorblade_reflection_attributes", {})
end

if double == 0 and caster:HasModifier("modifier_terror_reflection_legendary") and enemy:IsHero() then 
	illusion:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_spells", {duration = self.legendary_cd, enemy = enemy:entindex()})
end


if double == 0 and caster:HasModifier("modifier_terror_reflection_stun") and enemy:IsHero() 
	and (illusion:GetPrimaryAttribute() == 2 or illusion:GetPrimaryAttribute() == 3) then 

	local duration = self.main_silence

	if illusion:GetPrimaryAttribute() == 3 then 
		duration = duration*self.main_all
	end

	enemy:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_silence", {duration = duration*(1 - enemy:GetStatusResistance())})
end


end



function custom_terrorblade_reflection:LaunchIllusion(enemy, double)
if not IsServer() then return end

local caster = self:GetCaster()

self.duration = self:GetSpecialValueFor("illusion_duration")

if caster:HasModifier("modifier_terror_reflection_double") then 
	self.duration = self.duration + self.dispel_duration
end

local damage = self:GetSpecialValueFor("illusion_outgoing_damage")

if enemy:GetHullRadius() > 8 then
	spawn_range = 108
else
	spawn_range	= 72
end

if double and double == 1 then 
	damage = self:GetCaster():GetTalentValue("modifier_terror_reflection_silence", "damage") - 100
	self.duration = self:GetCaster():GetTalentValue("modifier_terror_reflection_silence", "duration")
end


enemy:EmitSound("Hero_Terrorblade.Reflection")

enemy:AddNewModifier(caster, self, "modifier_custom_terrorblade_reflection_slow", {duration = self.duration * (1 - enemy:GetStatusResistance())})

local int = false


if caster:HasModifier("modifier_custom_terrorblade_reflection_legendary_saved") and self:GetAutoCastState() == true then 

	local mod = caster:FindModifierByName("modifier_custom_terrorblade_reflection_legendary_saved")

	local illusion = CreateUnitByName(mod.name, enemy:GetAbsOrigin() + RandomVector(spawn_range), false, self:GetCaster(), self:GetCaster(), caster:GetTeamNumber())
	
	illusion:AddNewModifier(self:GetCaster(), self, "modifier_illusion", {outgoing_damage = damage, incoming_damage = 0, duration = self.duration * (1 - enemy:GetStatusResistance()) })
	

	illusion:MakeIllusion()
	

	for i = 1,mod.level - 1 do 
		illusion:HeroLevelUp(false)
	end


	for abilitySlot = 0,15 do

		local ability = illusion:GetAbilityByIndex(abilitySlot)

		if ability ~= nil then
			if ability:GetAbilityName() == mod.abilities[abilitySlot].name then 
				ability:SetLevel(mod.abilities[abilitySlot].level)
			end
		end
	end

	for itemSlot=0,5 do

		local itemName = mod.items[itemSlot]

		local newItem = CreateItem(itemName, illusion, illusion)

		illusion:AddItem(newItem)

	end

	if #mod.talents > 0 then 

   		 for j = 1,#mod.talents do 

    		local up = illusion:AddNewModifier(illusion, nil, mod.talents[j].name, {})
	   		up:SetStackCount(mod.talents[j].level)
		end		

	end

	self:IllusionBuff(illusion, enemy, double)

	illusion.givegold = 1
else 

	local copy_unit = enemy
	if enemy:IsCreep() then 
		copy_unit = self:GetCaster()
	end

	local illusions = CreateIllusions(caster, copy_unit, {
		outgoing_damage = damage,
		bounty_base		= 0,
		bounty_growth	= nil,
		duration		= self.duration * (1 - enemy:GetStatusResistance())
	}
	, 1, spawn_range, false, true)


	for _, illusion in pairs(illusions) do


		if copy_unit == self:GetCaster() then 
			local abs = enemy:GetAbsOrigin() + RandomVector(spawn_range)

			illusion:SetAbsOrigin(abs)
			FindClearSpaceForUnit(illusion, abs, false)
		end


		for _,mod in pairs(enemy:FindAllModifiers()) do
			if mod.StackOnIllusion ~= nil and mod.StackOnIllusion == true then
				illusion:UpgradeIllusion(mod:GetName(), mod:GetStackCount() )
			end
		end

		self:IllusionBuff(illusion, enemy, double)
	end	



end


end








modifier_custom_terrorblade_reflection_slow	= class({})


function modifier_custom_terrorblade_reflection_slow:IsPurgable() 
return not self:GetCaster():HasModifier("modifier_terror_reflection_double")
end

function modifier_custom_terrorblade_reflection_slow:GetEffectName()
	return "particles/units/heroes/hero_terrorblade/terrorblade_reflection_slow.vpcf"
end


function modifier_custom_terrorblade_reflection_slow:OnCreated(keys)
if not self:GetAbility() then self:Destroy() return end
self.move_slow	= self:GetAbility():GetSpecialValueFor("move_slow") * (-1)
self.attack_slow	= self:GetAbility():GetSpecialValueFor("attack_slow") * (-1)

self.armor = self:GetCaster():GetTalentValue("modifier_terror_reflection_speed", "armor")

end


function modifier_custom_terrorblade_reflection_slow:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET,
	MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE,
}
end




function modifier_custom_terrorblade_reflection_slow:GetModifierLifestealRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_terror_reflection_double") then return end

return self:GetAbility().dispel_heal
end


function modifier_custom_terrorblade_reflection_slow:GetModifierHealAmplify_PercentageTarget()
if not self:GetCaster():HasModifier("modifier_terror_reflection_double") then return end

return self:GetAbility().dispel_heal
end


function modifier_custom_terrorblade_reflection_slow:GetModifierHPRegenAmplify_Percentage() 
if not self:GetCaster():HasModifier("modifier_terror_reflection_double") then return end

return self:GetAbility().dispel_heal
end



function modifier_custom_terrorblade_reflection_slow:GetModifierAttackSpeedBonus_Constant()
local bonus = 0
if self:GetCaster():HasModifier("modifier_terror_reflection_slow") then 
	bonus = self:GetAbility().slow_attack[self:GetCaster():GetUpgradeStack("modifier_terror_reflection_slow")]
end

	return self.attack_slow + bonus
end




function modifier_custom_terrorblade_reflection_slow:GetModifierMoveSpeedBonus_Percentage()
local bonus = 0
if self:GetCaster():HasModifier("modifier_terror_reflection_slow") then 
	bonus = self:GetAbility().slow_move[self:GetCaster():GetUpgradeStack("modifier_terror_reflection_slow")]
end

	return self.move_slow + bonus
end




function modifier_custom_terrorblade_reflection_slow:GetModifierPhysicalArmorBonus()
if not self:GetCaster():HasModifier("modifier_terror_reflection_speed") then return end
	return self.armor
end










modifier_custom_terrorblade_reflection_unit	=  class({})


function modifier_custom_terrorblade_reflection_unit:IsPurgable()	return false end

function modifier_custom_terrorblade_reflection_unit:GetStatusEffectName()
	return "particles/status_fx/status_effect_terrorblade_reflection.vpcf"
end

function modifier_custom_terrorblade_reflection_unit:StatusEffectPriority()
    return 10010
end




function modifier_custom_terrorblade_reflection_unit:OnCreated(keys)

self.speed = self:GetCaster():GetTalentValue("modifier_terror_reflection_silence", "speed")
self.max = self:GetCaster():GetTalentValue("modifier_terror_reflection_silence", "max")

if not IsServer() then return end
self.target = EntIndexToHScript( keys.enemy_entindex )
self:StartIntervalThink(0.1)

self.damage = self:GetCaster():GetTalentValue("modifier_terror_reflection_speed", "damage")

self.double = keys.double
end




function modifier_custom_terrorblade_reflection_unit:OnIntervalThink()
	if self.target and not self.target:IsNull() and self:GetParent():IsAlive() and self.target:IsAlive()
	and self.target:HasModifier("modifier_custom_terrorblade_reflection_slow")   then

		if not self:GetParent():IsDisarmed() then 
     	  self:GetParent():SetForceAttackTarget(self.target)
    	  self:GetParent():MoveToTargetToAttack(self.target)
    	 end

	else
		self:DestroyIllusion()
	end
end




function modifier_custom_terrorblade_reflection_unit:DestroyIllusion()
if not IsServer() then return end
	
	 for _,mod in ipairs(self:GetParent():FindAllModifiers()) do 
        mod:Destroy()
     end

	self:GetParent():SetForceAttackTarget(nil)

	self:GetParent():ForceKill(false)
end




function modifier_custom_terrorblade_reflection_unit:OnDestroy()
if not IsServer() then return end

	self:DestroyIllusion()
end




function modifier_custom_terrorblade_reflection_unit:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_MODEL_SCALE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end 



function modifier_custom_terrorblade_reflection_unit:OnAttackLanded(params)
if not IsServer() then return end
if self.double == 1 then return end
if not self:GetCaster():HasModifier("modifier_terror_reflection_silence") then return end
if self:GetParent() ~= params.attacker then return end

self:IncrementStackCount()

if self:GetStackCount() >= self.max then 
	self:SetStackCount(0)
	self:GetAbility():LaunchIllusion(params.target, 1)
end

end


function modifier_custom_terrorblade_reflection_unit:CheckState()
return
{
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
}

end



function modifier_custom_terrorblade_reflection_unit:GetModifierModelScale() 
if self:GetParent():GetUnitName() == self:GetCaster():GetUnitName() then 
	return 0
end
return 30 
end



function modifier_custom_terrorblade_reflection_unit:GetModifierAttackSpeedBonus_Constant()
local bonus = 0 
if self:GetCaster():HasModifier("modifier_terror_reflection_silence") then 
	bonus = self.speed
end

return bonus
end

function modifier_custom_terrorblade_reflection_unit:GetModifierTotalDamageOutgoing_Percentage()
local bonus = 0 
if self:GetCaster():HasModifier("modifier_terror_reflection_speed") then 
	bonus = self.damage
end

return bonus
end














modifier_custom_terrorblade_reflection_spells = class({})
function modifier_custom_terrorblade_reflection_spells:IsHidden() return true end
function modifier_custom_terrorblade_reflection_spells:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_spells:OnCreated(table)
if not IsServer() then return end
self:GetParent().owner = self:GetCaster()
self.target = EntIndexToHScript( table.enemy)

self.BlockSpells = {
	["primal_beast_pulverize_custom"] = true, 
	["monkey_king_tree_dance_custom"] = true
}


local j = 0
local ability = {}

for i = 0,self:GetParent():GetAbilityCount()-1 do

    local a = self:GetParent():GetAbilityByIndex(i)
    
    if not a or a:GetName() == "ability_capture" then break end


    if my_game:ContainsValue(a:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) 
        and my_game:ContainsValue(a:GetAbilityTargetTeam(),  DOTA_UNIT_TARGET_TEAM_ENEMY) and a:GetLevel() > 0 and not a:IsHidden()
        and (not my_game:ContainsValue(a:GetBehaviorInt(), DOTA_ABILITY_BEHAVIOR_AUTOCAST) or a:GetName() == "sven_storm_bolt_custom")
        and not self.BlockSpells[a:GetName()]  then

        j = j + 1 
        ability[j] = a
    end
     
	
end

if #ability == 0 then return end
local r = RandomInt(1,#ability)

self.ability = ability[r]

self.t = -1
self.timer = self:GetRemainingTime()*2 
self:StartIntervalThink(0.5)
self:OnIntervalThink()

end

function modifier_custom_terrorblade_reflection_spells:OnIntervalThink()
if not IsServer() then return end
self.t = self.t + 1
local caster = self:GetParent()

local number = (self.timer-self.t)/2 
local int = 0
int = number
if number % 1 ~= 0 then int = number - 0.5  end

local digits = math.floor(math.log10(number)) + 2

local decimal = number % 1

if decimal == 0.5 then
decimal = 8
else 
decimal = 1
end

local particleName = "particles/huskar_timer.vpcf"
local particle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, caster)
ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
ParticleManager:SetParticleControl(particle, 1, Vector(0, int, decimal))
ParticleManager:SetParticleControl(particle, 2, Vector(digits, 0, 0))
ParticleManager:ReleaseParticleIndex(particle)

end








function modifier_custom_terrorblade_reflection_spells:OnDestroy()
if not IsServer() then return end
if not self:GetParent():IsAlive() then return end
if not self.target:IsRealHero() then return end
if self.target:IsInvulnerable() then return end
if not self.ability then return end

self.ability:OnSpellStart(self.target)


end







modifier_custom_terrorblade_reflection_legendary_saved = class({})
function modifier_custom_terrorblade_reflection_legendary_saved:IsHidden() return false end
function modifier_custom_terrorblade_reflection_legendary_saved:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_legendary_saved:RemoveOnDeath() return false end
function modifier_custom_terrorblade_reflection_legendary_saved:GetTexture() return 
	self.name
end

function modifier_custom_terrorblade_reflection_legendary_saved:OnCreated(table)
if not IsServer() then return end 
self:SetHasCustomTransmitterData(true)
self.name = table.name
end


function modifier_custom_terrorblade_reflection_legendary_saved:AddCustomTransmitterData() return {
name = self.name,

} end

function modifier_custom_terrorblade_reflection_legendary_saved:HandleCustomTransmitterData(data)
self.name = data.name
end



modifier_custom_terrorblade_reflection_silence = class({})
function modifier_custom_terrorblade_reflection_silence:IsHidden() return false end
function modifier_custom_terrorblade_reflection_silence:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_silence:CheckState()
return
{
	[MODIFIER_STATE_SILENCED] = true
}
end

function modifier_custom_terrorblade_reflection_silence:GetEffectName() return "particles/generic_gameplay/generic_silenced.vpcf" end
 
function modifier_custom_terrorblade_reflection_silence:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end


modifier_custom_terrorblade_reflection_attributes = class({})
function modifier_custom_terrorblade_reflection_attributes:IsHidden() return true end
function modifier_custom_terrorblade_reflection_attributes:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_attributes:OnCreated(table)
if not IsServer() then return end

self.chance = self:GetAbility().main_bash_chance
self.bash = self:GetAbility().main_bash
self.heal = self:GetAbility().main_heal

self.state = self:GetParent():GetPrimaryAttribute()

if self.state == 3 then 
	self.heal = self.heal*self:GetAbility().main_all
	self.bash = self.bash*self:GetAbility().main_all
end

end

function modifier_custom_terrorblade_reflection_attributes:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED
}

end

function modifier_custom_terrorblade_reflection_attributes:OnAttackLanded(params)
if self:GetParent() ~= params.attacker then return end

if self.state == 1 or self.state == 3 then 
	self:GetCaster():GenericHeal(self.heal*self:GetCaster():GetMaxHealth(), self:GetAbility())

end


if self.state ~= 3 and self.state ~= 0 then return end

local random = RollPseudoRandomPercentage(self.chance,193,self:GetParent())

if not random then return end

params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_bashed", {duration = (1 - params.target:GetStatusResistance())*self.bash})
params.target:EmitSound("BB.Goo_stun")

end






modifier_custom_terrorblade_reflection_gold = class({})
function modifier_custom_terrorblade_reflection_gold:IsHidden() return true end
function modifier_custom_terrorblade_reflection_gold:IsPurgable() return false end
function modifier_custom_terrorblade_reflection_gold:RemoveOnDeath() return false end
function modifier_custom_terrorblade_reflection_gold:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_DEATH
}
end

function modifier_custom_terrorblade_reflection_gold:OnDeath(params)
if not IsServer() then return end 
if not params.attacker then return end
if not self:GetParent():IsRealHero() then return end
if params.attacker.givegold == nil then return end
if params.attacker.givegold == false then return end
if not params.attacker.owner then return end
if not params.unit:IsCreep() then return end
if params.attacker.owner ~= self:GetParent() then return end

local gold = params.unit:GetMaximumGoldBounty()
if gold == 0 then return end

params.attacker.owner:ModifyGold(gold , true , DOTA_ModifyGold_CreepKill)
SendOverheadEventMessage(params.unit, 0, params.unit, gold, nil)

end
