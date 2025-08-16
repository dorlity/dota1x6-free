LinkLuaModifier( "modifier_morphling_replicate_custom_tracker", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_active", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_manager", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_quas", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_wex", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_exort", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_legendary_pick", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_legendary_autocast", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_legendary_saved", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_legendary_cd", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_morphling_replicate_custom_perma", "abilities/morphling/morphling_replicate_custom", LUA_MODIFIER_MOTION_NONE )


morphling_replicate_custom = class({})

function morphling_replicate_custom:CreateTalent()

local caster = self:GetCaster()
local index = nil
local mod = caster:FindModifierByName("modifier_morphling_replicate_custom_tracker")
if not mod or not mod.heroes_in_game then return end

for id,target in pairs(mod.heroes_in_game) do 
  if target and not target:IsNull() and target:GetTeamNumber() ~= caster:GetTeamNumber() then 
    index = target:entindex()
    break
  end
end

if not index then return end

caster:RemoveModifierByName("modifier_morphling_replicate_custom_legendary_saved")
caster:AddNewModifier(caster, self, "modifier_morphling_replicate_custom_legendary_saved", {index = index})
end

function morphling_replicate_custom:Precache(context)
if self:GetCaster() and self:GetCaster():IsIllusion() then return end
PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_replicate.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_replicate_finish.vpcf", context )
PrecacheResource( "particle", "particles/units/heroes/hero_morphling/morphling_replicate_buff.vpcf", context )
PrecacheResource( "particle", "particles/status_fx/status_effect_morphling_morph_target.vpcf", context )
PrecacheResource( "particle", "particles/morphling/morph_attack_range.vpcf", context )

end

function morphling_replicate_custom:GetAbilityTextureName()
return "morphling_replicate"
end

function morphling_replicate_custom:GetIntrinsicModifierName()
if not self:GetCaster():IsRealHero() then return end
return "modifier_morphling_replicate_custom_tracker"
end



morphling_morph_replicate_custom = class({})

function morphling_morph_replicate_custom:GetBehavior()
local bonus = 0
if self:GetCaster():HasTalent("modifier_morphling_morph_7") then
	bonus = DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + bonus
end

function morphling_morph_replicate_custom:CheckToggle()
local caster = self:GetCaster()
if caster:HasModifier("modifier_morphling_replicate_custom_legendary_cd") then
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetId()), "CreateIngameErrorMessage", {message = "#midteleport_cd"})
    return false
end
return true
end



function morphling_morph_replicate_custom:OnSpellStart()
local caster = self:GetCaster()

local morphling_replicate_custom = caster:FindAbilityByName("morphling_replicate_custom")
if caster:HasModifier("modifier_morphling_replicate_custom") then
	caster:RemoveModifierByName("modifier_morphling_replicate_custom")
else
	caster:AddNewModifier(caster, morphling_replicate_custom, "modifier_morphling_replicate_custom", {})
end

end


function morphling_replicate_custom:GetCooldown(level)
local bonus = 0
if self:GetCaster():HasTalent("modifier_morphling_morph_2") then
	bonus = self:GetCaster():GetTalentValue("modifier_morphling_morph_2", "cd")
end
return self.BaseClass.GetCooldown( self, level ) + bonus
end

function morphling_replicate_custom:GetCastRange(vLocation, hTarget)
return self.BaseClass.GetCastRange(self , vLocation , hTarget)
end

function morphling_replicate_custom:GetManaCost(level)
return self.BaseClass.GetManaCost(self,level) 
end

function morphling_replicate_custom:GetCastPoint(iLevel)
return self.BaseClass.GetCastPoint(self)
end


function morphling_replicate_custom:GetBehavior()
if self:GetCaster():HasTalent("modifier_morphling_morph_7") then
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end
return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
end

function morphling_replicate_custom:CastFilterResultTarget(target)

if not target:IsHero() then
	return UF_FAIL_CREEP
end
if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
       return UF_FAIL_FRIENDLY
end
if target:IsIllusion() then
	return UF_FAIL_ILLUSION
end
return UF_SUCCESS
end	



function morphling_replicate_custom:CheckToggle()
local caster = self:GetCaster()
if caster:HasModifier("modifier_morphling_replicate_custom_legendary_cd") then
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetId()), "CreateIngameErrorMessage", {message = "#midteleport_cd"})
    return false
end
return true
end

function morphling_replicate_custom:OnSpellStart()
local caster = self:GetCaster()
local target = self:GetCursorTarget()
if caster:GetUnitName() ~= "npc_dota_hero_morphling" then
    return
end

if not caster:HasTalent("modifier_morphling_morph_7") then
	if target:TriggerSpellAbsorb(self) then return end
else
	local mod = caster:FindModifierByName("modifier_morphling_replicate_custom_legendary_saved")
	if not mod then return end
	target = EntIndexToHScript(mod.index)

	if not target or target:IsNull() then return end
end

caster:AddNewModifier(caster, self, "modifier_morphling_replicate_custom_legendary_cd", {duration = caster:GetTalentValue("modifier_morphling_morph_7", "cd")})
caster:RemoveModifierByName("modifier_morphling_replicate_custom_legendary_pick")
self:SetTarget(target)
end


function morphling_replicate_custom:SetTarget(target)

local caster = self:GetCaster()
local duration = self:GetSpecialValueFor("duration") + caster:GetTalentValue("modifier_morphling_morph_2", "duration")

if not caster:HasModifier("modifier_morphling_replicate_custom_active") then
	caster:AddNewModifier(caster, self, "modifier_morphling_replicate_custom_active", {duration = duration, target = target:entindex()})
end

caster:AddNewModifier(caster, self, "modifier_morphling_replicate_custom_manager", {target = target:entindex()})

caster:AddNewModifier(caster, self, "modifier_morphling_replicate_custom", {})
end






modifier_morphling_replicate_custom_active = class(mod_visible)
function modifier_morphling_replicate_custom_active:GetTexture() return self.name end
function modifier_morphling_replicate_custom_active:OnCreated(table)
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.stats = self.parent:GetTalentValue("modifier_morphling_morph_3", "stats")/100
self.stack = self.parent:GetTalentValue("modifier_morphling_morph_3", "stack")/100
self.max = self.parent:GetTalentValue("modifier_morphling_morph_3", "max")

if not IsServer() then return end

self.RemoveForDuel = true
self.hero_health = self.parent:GetHealthPercent()
self.morph_health = self.hero_health

self.hero_mana = self.parent:GetManaPercent()
self.morph_mana = self.hero_mana

local target = EntIndexToHScript(table.target)

self.base_agi = target:GetAgility()
self.base_str = target:GetStrength()
self.base_int = target:GetIntellect(false)

self.name = target:GetUnitName()
self.parent:SwapAbilities("morphling_replicate_custom", "morphling_morph_replicate_custom", false, true)
self.ability:EndCd()

local ability = self.parent:FindAbilityByName("morphling_morph_replicate_custom")
if ability then
	ability:StartCd()
end

if self.parent:HasTalent("modifier_morphling_hero_8") then
	self.parent:Purge(false, true, false, false, false)
	self.bkb_mod = self.parent:AddNewModifier(self.parent, self.ability, "modifier_generic_debuff_immune", {effect = 1, duration = self.parent:GetTalentValue("modifier_morphling_hero_8", "bkb")})
end

self:SetHasCustomTransmitterData(true)
self:ChangeTarget(target)
end


function modifier_morphling_replicate_custom_active:AddStack()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end

self:IncrementStackCount()
self.parent:CalculateStatBonus(true)
end


function modifier_morphling_replicate_custom_active:AddCustomTransmitterData() 
return 
{
	name = self.name,
	base_str = self.base_str,
	base_int = self.base_int,
	base_agi = self.base_agi,
} 
end

function modifier_morphling_replicate_custom_active:HandleCustomTransmitterData(data)
self.name = data.name
self.base_agi = data.base_agi
self.base_str = data.base_str
self.base_int = data.base_int
end


function modifier_morphling_replicate_custom_active:ChangeTarget(target)
if not IsServer() then return end

self.name = target:GetUnitName()

if self.parent:HasTalent("modifier_morphling_morph_3") then
	self.base_agi = target:GetAgility()
	self.base_str = target:GetStrength()
	self.base_int = target:GetIntellect(false)
	self.parent:CalculateStatBonus(true)
end

self:SendBuffRefreshToClients()
end



function modifier_morphling_replicate_custom_active:OnDestroy()
if not IsServer() then return end
self.parent:RemoveModifierByName("modifier_morphling_replicate_custom_manager")
self.parent:SwapAbilities("morphling_morph_replicate_custom", "morphling_replicate_custom", false, true)
self.ability:StartCd()
end



function modifier_morphling_replicate_custom_active:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
}
end


function modifier_morphling_replicate_custom_active:GetModifierBonusStats_Agility()
return self.base_agi*(self.stats + self.stack*self:GetStackCount())
end

function modifier_morphling_replicate_custom_active:GetModifierBonusStats_Strength()
return self.base_str*(self.stats + self.stack*self:GetStackCount())
end

function modifier_morphling_replicate_custom_active:GetModifierBonusStats_Intellect()
return self.base_int*(self.stats + self.stack*self:GetStackCount())
end






modifier_morphling_replicate_custom_manager = class(mod_hidden)
function modifier_morphling_replicate_custom_manager:OnCreated(params)
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.target = EntIndexToHScript(params.target)

self.name =  self.target:GetUnitName()
self.model = base_heroes_data[self.name] and base_heroes_data[self.name]["model"] or self.target:GetModelName()
self.model_scale =  self.target:GetModelScale()

self.attack_type = self.target:GetAttackCapability()
self.attack_range = self.target:GetBaseAttackRange()

if self.parent:HasTalent("modifier_morphling_morph_4") then
	self.attack_range = math.max(self.attack_range, self.parent:GetBaseAttackRange())
end

if players[self.target:GetId()] then
	self.attack_type = players[self.target:GetId()].base_attack_type
	self.model_scale = players[self.target:GetId()].base_model_scale
end

self.target_abilities = {}

local hero_name = self.target:GetUnitName()

local mod = self.parent:FindModifierByName("modifier_morphling_replicate_custom_tracker")
if not mod or not mod.heroes_data or not mod.heroes_data[hero_name] then return end

local hero_table = mod.heroes_data[hero_name]

if self.target:GetUnitName() == "npc_dota_hero_invoker" then
	local quas = self.target:FindAbilityByName("invoker_quas_custom")
	local wex = self.target:FindAbilityByName("invoker_wex_custom")
	local exort = self.target:FindAbilityByName("invoker_exort_custom")

	local quas_level = quas and quas:GetLevel() or 0
	local wex_level = wex and wex:GetLevel() or 0
	local exort_level = exort and exort:GetLevel() or 0

	self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_replicate_custom_quas", {level = quas_level})
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_replicate_custom_wex", {level = wex_level})
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_replicate_custom_exort", {level = exort_level})
end


for id= 0,5 do 
	local ability_data = hero_table["Ability"..(id + 1)]
	if id == 5 then
		ability_data = hero_table["innate"]
	end

	if ability_data then
		local ability = self.target:FindAbilityByName(ability_data)
		if ability then
			local behavior = tonumber(tostring(ability:GetBehavior()))

			self.target_abilities[id] = {}
			self.target_abilities[id].ability = ability
			self.target_abilities[id].was_visible = hero_name == "npc_dota_hero_invoker" or bit.band(behavior, DOTA_ABILITY_BEHAVIOR_HIDDEN) == 0 or id == 5
			self.target_abilities[id].level = ability:GetLevel()

			if hero_table["shard"] == ability:GetName() or hero_table["scepter"] == ability:GetName() then
				self.target_abilities[id].level = 1
			end
			
			if hero_table["shard"] == ability:GetName() then
				self.target_abilities[id].was_visible = self.parent:HasShard()
			end
			if hero_table["scepter"] == ability:GetName() then
				self.target_abilities[id].was_visible = self.parent:HasScepter()
			end

		end
	end
end


end


function modifier_morphling_replicate_custom_manager:OnDestroy()
if not IsServer() then return end
self.parent:RemoveModifierByName("modifier_morphling_replicate_custom")

self.parent:RemoveModifierByName("modifier_morphling_replicate_custom_quas")
self.parent:RemoveModifierByName("modifier_morphling_replicate_custom_wex")
self.parent:RemoveModifierByName("modifier_morphling_replicate_custom_exort")
end







modifier_morphling_replicate_custom = class(mod_hidden)
function modifier_morphling_replicate_custom:OnCreated()
self.parent = self:GetParent()
self.ability = self:GetAbility()

self.damage_bonus = self.parent:GetTalentValue("modifier_morphling_morph_1", "damage")
self.spell_bonus = self.parent:GetTalentValue("modifier_morphling_morph_1", "spell")

self.damage_reduce = self.parent:GetTalentValue("modifier_morphling_hero_8", "damage_reduce")

if not IsServer() then return end

self.attack_type = self.parent:GetAttackCapability()
self.model_scale = self.parent:GetModelScale()

if players[self.parent:GetId()] then
	self.model_scale = players[self.parent:GetId()].base_model_scale
end

self.heal_creeps = self.parent:GetTalentValue("modifier_morphling_morph_7", "creeps", true)

self.parent:EmitSound("Hero_Morphling.Replicate")
self.parent:GenericParticle("particles/units/heroes/hero_morphling/morphling_replicate.vpcf")

self.innate_ability = nil	
self.base_abilities = {}

for id = 0,4 do
	local ability = self.parent:GetAbilityByIndex(id)
	if ability then
		self.base_abilities[id] =  {}
		self.base_abilities[id].ability = ability
		self.base_abilities[id].was_visible = not ability:IsHidden()

		ability:SetHidden(true)
		if ability:GetToggleState() then
			ability:ToggleAbility()
		end
	end
end

self.agi_speed = 0
self.str_heal = 0
self.int_cdr = 0
self.int_speed = 0

self.active_mod = self.parent:FindModifierByName("modifier_morphling_replicate_custom_active")
if self.parent:HasScepter() and self.active_mod then
	self.hero_health = self.parent:GetHealthPercent()
	self.hero_mana = self.parent:GetManaPercent()
	self.has_scepter = true

	self.active_mod.hero_mana = self.hero_mana
	self.active_mod.hero_health = self.hero_health

	self.parent:SetMana(math.max(1, self.active_mod.morph_mana*self.parent:GetMaxMana()/100))
	self.parent:SetHealth(math.max(1, self.active_mod.morph_health*self.parent:GetMaxHealth()/100))
	self.parent:AddDamageEvent_inc(self, true)
end

local manager = self.parent:FindModifierByName("modifier_morphling_replicate_custom_manager")
if manager then

	self.model = manager.model
	self.attack_range = manager.attack_range
	self.target = manager.target
	self.parent:SetAttackCapability(manager.attack_type)
	self.parent:SetModelScale(manager.model_scale)

	if self.parent:HasTalent("modifier_morphling_morph_7") then
		local primary = self.target:GetPrimaryAttribute()

		if primary == DOTA_ATTRIBUTE_AGILITY then
			self.agi_speed = self.parent:GetTalentValue("modifier_morphling_morph_7", "agi_speed")
		elseif primary == DOTA_ATTRIBUTE_STRENGTH then
			self.str_heal = self.parent:GetTalentValue("modifier_morphling_morph_7", "str_heal")
		elseif primary == DOTA_ATTRIBUTE_INTELLECT then
			self.int_cdr = self.parent:GetTalentValue("modifier_morphling_morph_7", "int_cdr")
			self.int_speed = self.parent:GetTalentValue("modifier_morphling_morph_7", "int_speed")
		elseif primary == DOTA_ATTRIBUTE_ALL then
			local universal = self.parent:GetTalentValue("modifier_morphling_morph_7", "universal")
			self.agi_speed = self.parent:GetTalentValue("modifier_morphling_morph_7", "agi_speed")/universal
			self.str_heal = self.parent:GetTalentValue("modifier_morphling_morph_7", "str_heal")/universal
			self.int_cdr = self.parent:GetTalentValue("modifier_morphling_morph_7", "int_cdr")/universal
			self.int_speed = self.parent:GetTalentValue("modifier_morphling_morph_7", "int_speed")/universal
		end
	end


	for id, data in pairs(manager.target_abilities) do
		local ability = data.ability
		local ability_name = data.ability:GetName()
		local was_visible = data.was_visible
		local level = data.level

		if ability_name ~= "generic_hidden" then
			local new_ability
			local old_ability = self.parent:FindAbilityByName(ability_name)


		    if self.parent.spell_steal_history[old_ability] then
		    	self.parent.spell_steal_history[old_ability] = nil

    			new_ability = old_ability
			else
				new_ability = self.parent:AddAbility(ability_name)
				new_ability:SetRefCountsModifiers(true)
				new_ability:SetStolen(true)
			end

			if new_ability then

				new_ability:SetLevel(level)
				if id ~= 5 then
					self.parent:SwapAbilities(self.base_abilities[id].ability:GetName(), new_ability:GetName(), false, was_visible)
				else
					self.innate_ability = new_ability
				end
			end
		end
	end

	self.parent.morphling_ult_items = {}
	local name = manager.name

	if base_heroes_data[name] then

		local items_list = base_heroes_data[name]["items"] and base_heroes_data[name]["items"] or {}
		for item_model,_  in pairs(items_list) do
		    local item_morph = wearables_system:CreateMorphTeamItem(self.parent, item_model)
		    item_morph:AddNewModifier(self.parent, nil, "status_effect_thinker_custom", {name = "particles/status_fx/status_effect_morphling_morph_target.vpcf", priority = MODIFIER_PRIORITY_ILLUSION})
		    
		    table.insert(self.parent.morphling_ult_items, item_morph)
		end

		local mod = self.parent:FindModifierByName("modifier_hero_donate_hex_checking")
		if mod then
			mod:StartMorph()
			mod:UpdatePlayerItems()
		end

		self.target_name = name
		self:StartIntervalThink(0.1)
	end
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetId()), 'morph_stats_replicated', {value = 1}) 

if self.str_heal > 0 then
	self.parent:AddDamageEvent_out(self, true)
end

self.parent:CalculateStatBonus(true)
self:SetHasCustomTransmitterData(true)
self:SendBuffRefreshToClients()
end


function modifier_morphling_replicate_custom:OnIntervalThink()
if not IsServer() then return end

if base_heroes_data[self.target_name] and base_heroes_data[self.target_name]["effects"] then
	for effect_name, effect_data in pairs(base_heroes_data[self.target_name]["effects"]) do
		
		local attach = particle_attach[effect_data["attach_type"]] and particle_attach[effect_data["attach_type"]] or nil
		local particle = ParticleManager:CreateParticle(effect_name, attach, self.parent)
		local points_data = effect_data["control_points"]

		if effect_data["control_points"] then
			for _,point_data in pairs(effect_data["control_points"]) do
				local point = point_data["control_point_index"] and tonumber(point_data["control_point_index"]) or 0
				local point_attach = particle_attach[point_data["attach_type"]] and particle_attach[point_data["attach_type"]] or nil
				local attachment = point_data["attachment"]
				local pos = point_data["position"] and point_data["position"] or self.parent:GetAbsOrigin()
				ParticleManager:SetParticleControlEnt(particle, point, self.parent, point_attach, attachment, pos, true )
			end
		end
		self:AddParticle(particle, false, false, -1, false, false)
	end
end

self:StartIntervalThink(-1)
end



function modifier_morphling_replicate_custom:AddCustomTransmitterData() 
return 
{
	attack_range = self.attack_range,
	model = self.model,
	agi_speed = self.agi_speed,
	int_cdr = self.int_cdr,
	int_speed = self.int_speed
} 
end

function modifier_morphling_replicate_custom:HandleCustomTransmitterData(data)
self.attack_range = data.attack_range
self.model = data.model
self.agi_speed = data.agi_speed
self.int_cdr = data.int_cdr
self.int_speed = data.int_speed
end


function modifier_morphling_replicate_custom:DamageEvent_out(params)
if not IsServer() then return end
if not self.parent:CheckLifesteal(params) then return end

local heal = params.damage*self.str_heal/100
heal = params.unit:IsCreep() and heal/self.heal_creeps or heal

self.parent:GenericHeal(heal, self.ability, true, "", "modifier_morphling_morph_7")
end




function modifier_morphling_replicate_custom:OnDestroy()
if not IsServer() then return end

if self.parent.morphling_ult_items then
	for _, morph_model in pairs(self.parent.morphling_ult_items) do
	    if morph_model and not morph_model:IsNull() then
	    	morph_model:AddEffects(EF_NODRAW)
	        UTIL_Remove(morph_model)
	    end
	end 
	self.parent.morphling_ult_items = {}
	local mod = self.parent:FindModifierByName("modifier_hero_donate_hex_checking")
	if mod then
		mod:UpdatePlayerItems()
		mod:EndMorph()
	end
end

self.parent:GenericParticle("particles/units/heroes/hero_morphling/morphling_replicate_finish.vpcf")
self.parent:SetAttackCapability(self.attack_type)
self.parent:SetModelScale(self.model_scale)

self.parent:FadeGesture(ACT_DOTA_DISABLED)

self.parent:EmitSound("Hero_Morphling.ReplicateEnd")

for id, data in pairs(self.base_abilities) do
	local ability = data.ability
	local ability_in_slot = self.parent:GetAbilityByIndex(id)

	if ability_in_slot and ability_in_slot:GetName() ~= ability:GetName() then
		self.parent:SwapAbilities(ability_in_slot:GetName(), ability:GetName(), false, true)
		ability_in_slot:SetHidden(true)
		self.parent.spell_steal_history[ability_in_slot] = ability_in_slot:GetName()
	end

	local was_visible = ability:GetName() == "morphling_attribute_legendary_custom" and self.parent:HasTalent("modifier_morphling_attribute_7") or data.was_visible

	ability:SetHidden(not was_visible)
end

if self.innate_ability then
	self.parent.spell_steal_history[self.innate_ability] = self.innate_ability:GetName()
end

local mod = self.parent:FindModifierByName("modifier_morphling_replicate_custom_tracker")
if mod then
	mod:OnIntervalThink()
end

if self.active_mod then
	if self.active_mod.bkb_mod and not self.active_mod.bkb_mod:IsNull() then
		self.active_mod.bkb_mod:Destroy()
	end

	if self.hero_health and self.parent:HasScepter() then
		self.active_mod.morph_health = self.parent:GetHealthPercent()
		self.active_mod.morph_mana = self.parent:GetManaPercent()
		self.parent:SetMana(math.max(1, self.hero_mana*self.parent:GetMaxMana()/100))
		self.parent:SetHealth(math.max(1, self.hero_health*self.parent:GetMaxHealth()/100))
	end
end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetId()), 'morph_stats_replicated', {value = 0}) 
self.parent:CalculateStatBonus(true)
end



function modifier_morphling_replicate_custom:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_MODEL_CHANGE,
	MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	MODIFIER_PROPERTY_MIN_HEALTH,
}
end


function modifier_morphling_replicate_custom:DamageEvent_inc(params)
if not IsServer() then return end
if not self.has_scepter then return end
if self.parent ~= params.unit then return end
if self.parent:LethalDisabled() then return end
if self.parent:GetHealth() > 5 then return end

self.parent:RemoveModifierByName("modifier_morphling_replicate_custom_active")
end


function modifier_morphling_replicate_custom:GetMinHealth()
if not self.has_scepter then return end
if self.parent:LethalDisabled() then return end
if not self.parent:IsAlive() then return end
if self.parent:GetHealth() <= 0 then return end

return 1
end

function modifier_morphling_replicate_custom:GetModifierIncomingDamage_Percentage()
return self.damage_reduce
end

function modifier_morphling_replicate_custom:GetModifierSpellAmplify_Percentage()
return self.spell_bonus
end

function modifier_morphling_replicate_custom:GetModifierDamageOutgoing_Percentage()
return self.damage_bonus
end

function modifier_morphling_replicate_custom:GetModifierPercentageCooldown(params) 
if not params.ability or params.ability:IsItem() then return end
return self.int_cdr
end

function modifier_morphling_replicate_custom:GetModifierPercentageCasttime() 
return self.int_speed
end

function modifier_morphling_replicate_custom:GetModifierAttackSpeedBonus_Constant()
return self.agi_speed
end

function modifier_morphling_replicate_custom:GetModifierModelChange()
return self.model
end

function modifier_morphling_replicate_custom:GetModifierAttackRangeOverride()
return self.attack_range
end

function modifier_morphling_replicate_custom:GetEffectAttachType()
return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_morphling_replicate_custom:GetEffectName()
return "particles/units/heroes/hero_morphling/morphling_replicate_buff.vpcf"
end

function modifier_morphling_replicate_custom:GetStatusEffectName()
return "particles/status_fx/status_effect_morphling_morph_target.vpcf"
end

function modifier_morphling_replicate_custom:StatusEffectPriority()
return MODIFIER_PRIORITY_ILLUSION
end





modifier_morphling_replicate_custom_tracker = class(mod_hidden)
function modifier_morphling_replicate_custom_tracker:OnCreated()
if not IsServer() then return end
self.ability = self:GetAbility()
self.parent = self:GetParent()
self.interval = 0.5

self.parent.spell_steal_history = {}
self:StartIntervalThink(self.interval)

self.parent:AddActivityModifier("jog")
self.parent:AddActivityModifier("trot")
self.parent:AddActivityModifier("walk")
self.parent:AddActivityModifier("attack_closest_range")
self.parent:AddActivityModifier("attack_close_range")
self.parent:AddActivityModifier("attack_medium_range")
self.parent:AddActivityModifier("attack_long_range")
self.parent:AddActivityModifier("fast")
self.parent:AddActivityModifier("faster")
self.parent:AddActivityModifier("fastest")
self.parent:AddActivityModifier("super_fast")


self.kv_exception = 
{
	["npc_dota_hero_antimage"] = "abilities_anti_mage",
	["npc_dota_hero_furion"] = "abilities_nature_prophet",
	["npc_dota_hero_nevermore"] = "abilities_shadow_fiend",
	["npc_dota_hero_zuus"] = "abilities_zeus",
	["npc_dota_hero_skeleton_king"] = "abilities_wraith_king",
	["npc_dota_hero_queenofpain"] = "abilities_queen_of_pain",
}

self.exception_skills =
{
	["custom_ability_dust"] = true,
	["custom_ability_smoke"] = true,
	["custom_ability_sentry"] = true,
	["custom_ability_observer"] = true,
}

self.invoker_skills = 
{
	["Ability1"] = "invoker_cold_snap_custom",
	["Ability2"] = "invoker_alacrity_custom",
	["Ability3"] = "invoker_tornado_custom",
	["Ability4"] = "invoker_deafening_blast_custom",
}
self.innate_exception = 
{
	["troll_warlord_berserkers_rage_custom"] = true,
	["monkey_king_mischief"] = true,
	["huskar_blood_magic"] = true,
	["bane_innate_custom"] = true,
	["void_spirit_innate_custom"] = true,
	["skeleton_king_innate_custom"] = true,
	["marci_innate_custom"] = true
}


self.heroes_kv = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
self.heroes_data = {}

self.heroes_in_game = {}
for _,player in pairs(players) do
	self.heroes_in_game[player:GetUnitName()] = player
end

if self.heroes_kv then
	for hero_name, skills in pairs(self.heroes_kv) do
		if self.heroes_in_game[hero_name] and self.parent:GetUnitName() ~= hero_name and type(skills) == "table" then
			self.heroes_data[hero_name] = {}
			if hero_name == "npc_dota_hero_invoker" then
				skills = self.invoker_skills
			end
			for slot_name,skill in pairs(skills) do
				if slot_name:match("Ability") ~= nil and skill ~= '' and not self.exception_skills[skill] then
					self.heroes_data[hero_name][slot_name] = skill
				end
			end
			local kv_name = self.kv_exception[hero_name] and self.kv_exception[hero_name] or hero_name:gsub("npc_dota_hero_", "abilities_")
			local ability_kv = LoadKeyValues("scripts/npc/heroes/"..kv_name..".txt")
			if ability_kv then
			    for name, data in pairs(ability_kv) do
			    	if data and type(data) == "table" then
				        for data_name, ability_data in pairs(data) do
				        	if data_name == "IsGrantedByScepter" then
				        		self.heroes_data[hero_name]["scepter"] = name
				        	end
				        	if data_name == "IsGrantedByShard" then
				        		self.heroes_data[hero_name]["shard"] = name
				        	end
				        	if data_name == "Innate" and not self.innate_exception[name] then
				        		self.heroes_data[hero_name]["innate"] = name
				        	end
				        end
				    end
			    end
			end
		end
	end
end

self.parent:AddAttackEvent_out(self, true)
self:UpdateTalent()
end


function modifier_morphling_replicate_custom_tracker:UpdateTalent(name)
if not IsServer() then return end

if name == "modifier_morphling_morph_3" or self.parent:HasTalent("modifier_morphling_morph_3") then
	self.parent:AddSpellEvent(self, true)
end

end


function modifier_morphling_replicate_custom_tracker:SpellEvent(params)
if not IsServer() then return end
if not self.parent:HasTalent("modifier_morphling_morph_3") then return end
if self.parent ~= params.unit then return end
if params.ability:IsItem() then return end

local active = self.parent:FindModifierByName("modifier_morphling_replicate_custom_active")
if active and self.parent:HasTalent("modifier_morphling_morph_3") then
	active:AddStack()
end

end


function modifier_morphling_replicate_custom_tracker:AttackEvent_out(params)
if not IsServer() then return end
if self.parent ~= params.attacker then return end
if not params.target:IsUnit() then return end

local target = params.target
local mod = self.parent:FindModifierByName("modifier_morphling_replicate_custom")

if mod and self.parent:HasTalent("modifier_morphling_morph_4") and not self.parent:IsRangedAttacker() then

	local particle = ParticleManager:CreateParticle( "particles/morphling/morph_attack_range.vpcf", PATTACH_ABSORIGIN_FOLLOW,  self.parent )
	ParticleManager:SetParticleControlEnt( particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true )
	ParticleManager:DestroyParticle(particle, false)
	ParticleManager:ReleaseParticleIndex( particle )
end


if mod and target:IsRealHero() then
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_replicate_custom_perma", {})
end

local active = self.parent:FindModifierByName("modifier_morphling_replicate_custom_active")
if active and self.parent:HasTalent("modifier_morphling_morph_3") then
	active:AddStack()
end

end




function modifier_morphling_replicate_custom_tracker:OnIntervalThink()
if not IsServer() then return end

if not self.ability:IsActivated() and not self.parent:HasModifier("modifier_morphling_replicate_custom_active") then
	self.ability:StartCd()
end



for hSpell,name in pairs(self.parent.spell_steal_history) do

    if hSpell and not hSpell:IsNull() then
	    if hSpell:GetToggleState() then
			hSpell:ToggleAbility()
		end
		local intrinsic_mod = hSpell:GetIntrinsicModifierName()

		if intrinsic_mod then
	        self.parent:RemoveModifierByName(intrinsic_mod)
	    end

	    if hSpell:NumModifiersUsingAbility() <= 0 and not hSpell:IsChanneling() then

			self.parent.spell_steal_history[hSpell] = nil

		    self.parent:RemoveAbilityByHandle(hSpell)
	        UTIL_Remove(hSpell)
	        hSpell = nil

		--	print('no mods :(', name)
	    end
	else
	--	print('remove!!!', name)
		self.parent.spell_steal_history[hSpell] = nil
	end
end

self:StartIntervalThink(self.interval)
end




modifier_morphling_replicate_custom_quas = class(mod_visible)
function modifier_morphling_replicate_custom_quas:GetTexture() return "invoker_quas" end
function modifier_morphling_replicate_custom_quas:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(table.level)
end


modifier_morphling_replicate_custom_wex = class(mod_visible)
function modifier_morphling_replicate_custom_wex:GetTexture() return "invoker_wex" end
function modifier_morphling_replicate_custom_wex:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(table.level)
end


modifier_morphling_replicate_custom_exort = class(mod_visible)
function modifier_morphling_replicate_custom_exort:GetTexture() return "invoker_exort" end
function modifier_morphling_replicate_custom_exort:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(table.level)
end






modifier_morphling_replicate_custom_legendary_pick = class(mod_hidden)
function modifier_morphling_replicate_custom_legendary_pick:OnCreated(table)
if not IsServer() then return end 

self.parent = self:GetParent()
self.ability = self:GetAbility()

self.targets = {}
local mod = self.parent:FindModifierByName("modifier_morphling_replicate_custom_tracker")
if not mod or not mod.heroes_in_game then return end

for id,target in pairs(mod.heroes_in_game) do 
  if target and not target:IsNull() and target:GetTeamNumber() ~= self.parent:GetTeamNumber() then 

  	local count = #self.targets + 1
    self.targets[count] = {}
    self.targets[count].target = target:GetUnitName()
    self.targets[count].index = target:entindex()
  end
end

if #self.targets == 0 then 
  self:Destroy()
  return
end

EmitAnnouncerSoundForPlayer("Morph.Replicate_pick", self.parent:GetPlayerOwnerID())

self:OnIntervalThink()
self:StartIntervalThink(0.5)
end 

function modifier_morphling_replicate_custom_legendary_pick:OnIntervalThink()
if not IsServer() then return end
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "tb_reflection_init", self.targets)
end 

function modifier_morphling_replicate_custom_legendary_pick:EndPick(pick)
if not IsServer() then return end
if not self.parent:IsAlive() then return end

if self.targets[pick] and self.targets[pick].index then 

	EmitAnnouncerSoundForPlayer("Lc.Duel_target_end", self.parent:GetPlayerOwnerID())
	self.parent:RemoveModifierByName("modifier_morphling_replicate_custom_legendary_saved")
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_replicate_custom_legendary_saved", {index = self.targets[pick].index})
end

self:Destroy()
end 

function modifier_morphling_replicate_custom_legendary_pick:OnDestroy()
if not IsServer() then return end

CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(self.parent:GetPlayerOwnerID()), "tb_reflection_init_end",  {})
end 




modifier_morphling_replicate_custom_legendary_autocast = class(mod_hidden)
function modifier_morphling_replicate_custom_legendary_autocast:OnCreated()
if not IsServer() then return end
self.parent = self:GetParent()
self.ability = self:GetAbility()

local mod = self.parent:FindModifierByName("modifier_morphling_replicate_custom_legendary_pick")
if mod then
	mod:Destroy()
else
	self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_replicate_custom_legendary_pick", {})
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_replicate_custom_legendary_cd", {duration = 0.5})

self.ability:ToggleAutoCast()
self:Destroy()
end





modifier_morphling_replicate_custom_legendary_saved = class(mod_visible)
function modifier_morphling_replicate_custom_legendary_saved:IsHidden() return self.parent:HasModifier("modifier_morphling_replicate_custom_manager") end
function modifier_morphling_replicate_custom_legendary_saved:RemoveOnDeath() return false end
function modifier_morphling_replicate_custom_legendary_saved:GetTexture() return self.name end
function modifier_morphling_replicate_custom_legendary_saved:OnCreated(table)
self.parent = self:GetParent()

if not IsServer() then return end 
self.ability = self.parent:FindAbilityByName("morphling_replicate_custom")
self.index = table.index

self.unit = EntIndexToHScript(self.index)

if not self.unit then 
	self:Destroy()
	return 
end

local mod = self.parent:FindModifierByName("modifier_morphling_replicate_custom_manager")
if mod and self.ability and (not mod.target or mod.target ~= self.unit) then
	mod:Destroy()
	self.ability:SetTarget(self.unit)
	local active = self.parent:FindModifierByName("modifier_morphling_replicate_custom_active")
	if active then
		active:ChangeTarget(self.unit)
	end 
end

self.parent:AddNewModifier(self.parent, self.ability, "modifier_morphling_replicate_custom_legendary_cd", {duration = self.parent:GetTalentValue("modifier_morphling_morph_7", "cd")})

self.name = self.unit:GetUnitName()
self:SetHasCustomTransmitterData(true)
end

function modifier_morphling_replicate_custom_legendary_saved:AddCustomTransmitterData() 
return 
{
	name = self.name,
} 
end

function modifier_morphling_replicate_custom_legendary_saved:HandleCustomTransmitterData(data)
self.name = data.name
end




modifier_morphling_replicate_custom_legendary_cd = class(mod_cd)
function modifier_morphling_replicate_custom_legendary_cd:GetTexture() return "morphling_replicate" end




modifier_morphling_replicate_custom_perma = class({})
function modifier_morphling_replicate_custom_perma:IsHidden() return not self.parent:HasTalent("modifier_morphling_morph_4") or self:GetStackCount() >= self.max end
function modifier_morphling_replicate_custom_perma:IsPurgable() return false end
function modifier_morphling_replicate_custom_perma:RemoveOnDeath() return false end
function modifier_morphling_replicate_custom_perma:GetTexture() return "buffs/morphling/morph_4" end
function modifier_morphling_replicate_custom_perma:OnCreated()
self.parent = self:GetParent()
self.max = self.parent:GetTalentValue("modifier_morphling_morph_4", "max", true)
self.cdr = self.parent:GetTalentValue("modifier_morphling_morph_4", "cdr", true)/self.max

if not IsServer() then return end
self:SetStackCount(1)
self:StartIntervalThink(0.5)
end

function modifier_morphling_replicate_custom_perma:OnRefresh()
if not IsServer() then return end
if self:GetStackCount() >= self.max then return end 

self:IncrementStackCount()
end

function modifier_morphling_replicate_custom_perma:OnIntervalThink()
if not IsServer() then return end 
if self:GetStackCount() < self.max then return end
if not self.parent:HasTalent("modifier_morphling_morph_4") then return end

self.parent:GenericParticle("particles/rare_orb_patrol.vpcf")
self.parent:EmitSound("BS.Thirst_legendary_active")
self:StartIntervalThink(-1)
end 


function modifier_morphling_replicate_custom_perma:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
}
end


function modifier_morphling_replicate_custom_perma:GetModifierPercentageCooldown() 
if not self.parent:HasTalent("modifier_morphling_morph_4") then return end
return self:GetStackCount()*self.cdr
end


