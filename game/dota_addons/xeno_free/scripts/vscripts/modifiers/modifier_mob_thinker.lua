

modifier_mob_thinker = class({})


function modifier_mob_thinker:IsHidden() return false end
function modifier_mob_thinker:IsPurgable() return false end



function modifier_mob_thinker:CheckState()
    return {
        [MODIFIER_STATE_UNSELECTABLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_OUT_OF_GAME] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
    }
end

function modifier_mob_thinker:RemoveOnDeath() return false end

function modifier_mob_thinker:OnCreated(table)
if not IsServer() then return end 
if _G.TestMode == false then return end 


self:StartIntervalThink(FrameTime())
end


function modifier_mob_thinker:OnIntervalThink()
if not IsServer() then return end
if _G.WtfMode == false then return end 

local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

for _,unit in pairs(units) do 
	my_game:RefreshCooldowns(unit)
end 


end 

function modifier_mob_thinker:DeclareFunctions()
return
{
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_EVENT_ON_ABILITY_EXECUTED,
}

end


function modifier_mob_thinker:OnAbilityExecuted( params )
if not IsServer() then return end
if not params.ability then return end
if params.ability:IsToggle() then return end
if not params.unit then return end

local caster = params.unit
local ability = params.ability


if _G.WtfMode == true then 
	caster:SetMana(caster:GetMaxMana())
end 




if params.ability:IsItem() then 
	if caster:GetQuest() == "General.Quest_15" and (params.ability:GetName() == "item_overwhelming_blink" or params.ability:GetName() == "item_swift_blink" or params.ability:GetName() == "item_arcane_blink" or params.ability:GetName() == "item_blink") then
		caster:AddNewModifier(caster, nil, "modifier_quest_blink", {duration = caster.quest.number})
	end
end



end


function modifier_mob_thinker:OnDeath(params)
if not IsServer() then return end
local killer = params.attacker

if killer == nil then return end
if killer.owner == nil and not killer:IsHero() then return end



if params.unit:IsRealHero() and towers[params.unit:GetTeamNumber()] and killer:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then 

	local enemies = FindUnitsInRadius(params.unit:GetTeamNumber(), params.unit:GetAbsOrigin() , nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE  + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_CLOSEST, false)

	local team_array = {}
	for _,enemy in pairs(enemies) do 
		if enemy:CheckOwner():IsHero() and enemy:GetTeamNumber() ~= killer:GetTeamNumber() then 
			team_array[#team_array + 1] = enemy:GetTeamNumber()
		end
	end

	team_array[#team_array + 1] = killer:GetTeamNumber()


	my_game:ActivatePushReduce(params.unit:GetTeamNumber(), killer:GetTeamNumber(), 1, team_array)
end

if players[killer:GetTeamNumber()] == nil then return end



if params.unit:GetUnitName() == "patrol_range_bad" or
	params.unit:GetUnitName() == "patrol_melee_bad" or
	params.unit:GetUnitName() == "patrol_range_good" or 
	params.unit:GetUnitName() == "patrol_melee_good" then
	players[killer:GetTeamNumber()].patrol_kills = players[killer:GetTeamNumber()].patrol_kills + 1
end


if params.unit:GetUnitName() == "npc_dota_observer_wards" and params.unit:GetTeamNumber() ~= killer:GetTeamNumber() then 
	players[killer:GetTeamNumber()].obs_kills = players[killer:GetTeamNumber()].obs_kills + 1
end


if params.unit:GetUnitName() == "npc_dota_sentry_wards" and params.unit:GetTeamNumber() ~= killer:GetTeamNumber()  then 
	players[killer:GetTeamNumber()].sentry_kills = players[killer:GetTeamNumber()].sentry_kills + 1
end


end

function modifier_mob_thinker:OnAttackLanded(params)
if not IsServer() then return end
local attacker = params.attacker
local target = params.target
if attacker == nil or target == nil then return end

if attacker:IsTempestDouble() and attacker.owner then 
	attacker = attacker.owner
end 


if attacker.owner and target:IsRealHero() and attacker.owner:GetQuest() == "Monkey.Quest_8" and not attacker.owner:QuestCompleted() and attacker:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
	attacker.owner:UpdateQuest(1)
end


if (target:GetQuest() and not target:QuestCompleted()) then 


end

if (attacker:GetQuest() and not attacker:QuestCompleted()) then 

	if target:IsRealHero() then 

		if attacker:GetQuest() == "Phantom.Quest_7" and attacker:HasModifier("modifier_phantom_assassin_phantom_smoke") and not attacker:HasModifier('modifier_custom_phantom_assassin_stifling_dagger_attack') then 
			attacker:UpdateQuest(1) 
		end


		if attacker:GetQuest() == "Terr.Quest_7" and attacker:HasModifier("modifier_custom_terrorblade_metamorphosis") then 
			attacker:UpdateQuest(1) 
		end


		if attacker:GetQuest() == "Brist.Quest_8"  then 

			local mod = attacker:FindModifierByName("modifier_custom_bristleback_warpath_buff")
			local ability = attacker:FindAbilityByName("bristleback_warpath_custom")

			if ability and mod and mod:GetStackCount() >= ability:GetSpecialValueFor("max_stacks") then
				attacker:UpdateQuest(1) 
			end

		end



		if attacker:GetQuest() == "Void.Quest_5" and target:HasModifier("modifier_custom_void_remnant_target") then 
			attacker:UpdateQuest(1) 
		end

		if (attacker:GetQuest() == "Hoodwink.Quest_7") then 
			local mod = attacker:FindModifierByName("modifier_hoodwink_scurry_custom")

			if mod and mod:GetStackCount() == 0 then 
				attacker:UpdateQuest(1)
			end

		end


		if attacker:GetQuest() == "Wraith.Quest_5" and target:HasModifier("modifier_skeleton_king_hellfire_blast_custom_debuff") then 
			attacker:UpdateQuest(1) 
		end


		if attacker:GetQuest() == "Troll.Quest_7"  then 

			local mod = attacker:FindModifierByName("modifier_troll_warlord_fervor_custom_speed")
			local ability = attacker:FindAbilityByName("troll_warlord_fervor_custom")

			if ability and mod and mod:GetStackCount() >= ability:GetSpecialValueFor("max_stacks") then
				attacker:UpdateQuest(1) 
			end

		end

		if attacker:GetQuest() == "Lina.Quest_7" and target:HasModifier("modifier_lina_fiery_soul_custom_quest") then 
			attacker:UpdateQuest(1) 
		end

		if attacker:GetQuest() == "Alch.Quest_8" and attacker:HasModifier("modifier_alchemist_chemical_rage_custom") then 
			attacker:UpdateQuest(1) 
		end

		if attacker:GetQuest() == "Zuus.Quest_7" and attacker:HasModifier("modifier_zuus_heavenly_jump_custom_quest") then 
			attacker:UpdateQuest(1) 
		end

		if attacker:GetQuest() == "Beast.Quest_7"  then 

			local mod = attacker:FindModifierByName("modifier_primal_beast_uproar_custom_buff")

			if mod and mod:GetStackCount() >= attacker.quest.number then
				attacker:UpdateQuest(1) 
			end

		end



		if attacker:GetQuest() == "Maiden.Quest_7" and (target:HasModifier("modifier_crystal_maiden_crystal_nova_custom") or target:HasModifier("modifier_crystal_maiden_freezing_field_custom_debuff") or target:HasModifier("modifier_crystal_maiden_frostbite_custom")) then 
			attacker:UpdateQuest(1) 
		end

		if attacker:GetQuest() == "Snapfire.Quest_7" and attacker:HasModifier("modifier_snapfire_lil_shredder_custom") then 
			attacker:UpdateQuest(1) 
		end

		if attacker:GetQuest() == "Sven.Quest_8" and attacker:HasModifier("modifier_sven_gods_strength_custom") then 
			attacker:UpdateQuest(1) 
		end

		if attacker:GetQuest() == "Blood.Quest_5" and attacker:GetHealthPercent() <= attacker.quest.number then 
			attacker:UpdateQuest(1) 
		end

		if attacker:GetQuest() == "Huskar.Quest_7" and attacker:GetHealthPercent() <= attacker.quest.number then 
			attacker:UpdateQuest(1)
		end

		if attacker:GetQuest() == "Muerta.Quest_8" and attacker:HasModifier("modifier_muerta_pierce_the_veil_custom") then 
			attacker:UpdateQuest(1)
		end
		

		if attacker:GetQuest() == "Arc.Quest_6" and (params.attacker:HasModifier("modifier_arc_warden_magnetic_field_custom_speed") or params.attacker:HasModifier("modifier_arc_warden_magnetic_field_custom_damage")) then 
			attacker:UpdateQuest(1)
		end
		
	
		if attacker:GetQuest() == "Invoker.Quest_6" and params.attacker:HasModifier("modifier_invoker_alacrity_custom") then 
			attacker:UpdateQuest(1)
		end


		if attacker:GetQuest() == "Sand.Quest_5" and params.attacker:HasModifier("modifier_sandking_burrowstrike_custom_quest") then 
			attacker:UpdateQuest(1)
		end
	end


end





if target:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 and attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then return end






if attacker:HasModifier("modifier_troll_heal") then 
	local mod = attacker:FindModifierByName("modifier_troll_heal")
	mod:DoScript()
end

if attacker:HasModifier("modifier_abbadon_silence_self") then 
	local mod = attacker:FindModifierByName("modifier_abbadon_silence_self")
	mod:DoScript(target)
end



if target:HasModifier("modifier_abbadon_silence") then 
	local mod = target:FindModifierByName("modifier_abbadon_silence")
	mod:DoScript(attacker)
end


if attacker:HasModifier("modifier_siege_attack") then 
	local mod = attacker:FindModifierByName("modifier_siege_attack")
	mod:DoScript(target)
end

if attacker:HasModifier("modifier_siege_melting") then 
	local mod = attacker:FindModifierByName("modifier_siege_melting")
	mod:DoScript(target)
end

if attacker:HasModifier("modifier_werewolf_bloodrage") then 
	local mod = attacker:FindModifierByName("modifier_werewolf_bloodrage")
	mod:DoScript()
end



if attacker:HasModifier("modifier_satyr_root_passive") then 
	local mod = attacker:FindModifierByName("modifier_satyr_root_passive")
	mod:DoScript(target)
end


end




modifier_mob_thinker.Teams_Neutrals_Camps = {
	-- Easy
	["neutralcamp_good_easy_1"] = "Easy",
	["neutralcamp_good_easy_2"] = "Easy",
	["neutralcamp_good_easy_3"] = "Easy",
	["neutralcamp_good_easy_4"] = "Easy",
	["neutralcamp_good_easy_5"] = "Easy",
	["neutralcamp_good_easy_6"] = "Easy",

	["neutralcamp_evil_easy_1"] = "Easy",
	["neutralcamp_evil_easy_2"] = "Easy",
	["neutralcamp_evil_easy_3"] = "Easy",
	["neutralcamp_evil_easy_4"] = "Easy",
	["neutralcamp_evil_easy_5"] = "Easy",
	["neutralcamp_evil_easy_6"] = "Easy",

	-- Medium
	["neutralcamp_good_medium_1"] = "Medium",
	["neutralcamp_good_medium_2"] = "Medium",
	["neutralcamp_good_medium_3"] = "Medium",
	["neutralcamp_good_medium_4"] = "Medium",
	["neutralcamp_good_medium_5"] = "Medium",
	["neutralcamp_good_medium_6"] = "Medium",
	["neutralcamp_good_medium_7"] = "Medium",
	["neutralcamp_good_medium_8"] = "Medium",

	["neutralcamp_evil_medium_1"] = "Medium",
	["neutralcamp_evil_medium_2"] = "Medium",
	["neutralcamp_evil_medium_3"] = "Medium",
	["neutralcamp_evil_medium_4"] = "Medium",
	["neutralcamp_evil_medium_5"] = "Medium",
	["neutralcamp_evil_medium_6"] = "Medium",

	--hard


	["neutralcamp_good_hard_1"] = "Hard",
	["neutralcamp_good_hard_2"] = "Hard",
	["neutralcamp_good_hard_3"] = "Hard",
	["neutralcamp_good_hard_4"] = "Hard",

	["neutralcamp_evil_hard_1"] = "Hard",
	["neutralcamp_evil_hard_2"] = "Hard",
	["neutralcamp_evil_hard_3"] = "Hard",
	["neutralcamp_evil_hard_4"] = "Hard",
	["neutralcamp_evil_hard_5"] = "Hard",
	["neutralcamp_evil_hard_6"] = "Hard",

	-- Ancient
	["neutralcamp_good_17"] = "Ancient",
	["neutralcamp_good_18"] = "Ancient",
}

function ModifyDamageData(data, params, received)
	local pre_reduction = nil
	local post_reduction = nil
	if received then
		pre_reduction = data.received_pre_reduction
		post_reduction = data.received_post_reduction
	else
		pre_reduction = data.dealt_pre_reduction
		post_reduction = data.dealt_post_reduction
	end
	local i = 1
	if params.damage_type == DAMAGE_TYPE_PHYSICAL then
		i = 1
	elseif params.damage_type == DAMAGE_TYPE_MAGICAL then
		i = 2
	elseif params.damage_type == DAMAGE_TYPE_PURE then
		i = 3
	elseif params.damage_type == DAMAGE_TYPE_HP_REMOVAL then
		i = 4
	end
	pre_reduction[i] = pre_reduction[i] + params.original_damage
	post_reduction[i] = post_reduction[i] + params.damage
end

function modifier_mob_thinker:OnTakeDamage(params)
if not IsServer() then return end
local attacker = params.attacker
local unit = params.unit

if attacker == nil or unit == nil then return end
if attacker:GetTeamNumber() == unit:GetTeamNumber() then return end


if attacker:IsRealHero() and unit:IsRealHero() and (attacker:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() < 1000 then 

	my_game:ActivatePushReduce(attacker:GetTeamNumber(), unit:GetTeamNumber())
	my_game:ActivatePushReduce(unit:GetTeamNumber(), attacker:GetTeamNumber())
end






local damage = math.floor(params.damage)

if (unit:GetQuest() and not unit:QuestCompleted()) then 

	if attacker:IsRealHero() then 

		if unit:GetQuest() == "Jugg.Quest_7" and unit:HasModifier("modifier_custom_juggernaut_healing_ward_aura") then 
			unit:UpdateQuest(damage)
		end



		if unit:GetQuest() == "Sven.Quest_7" and unit:HasModifier("modifier_sven_warcry_custom_quest") then 
			unit:UpdateQuest(math.floor(params.original_damage))
		end
	end


	if attacker:IsRealHero() then 

		if unit:GetQuest() == "Axe.Quest_5" and unit:HasModifier("modifier_axe_berserkers_call_custom_buff") then 
			unit:UpdateQuest( math.floor(params.original_damage))
		end

	end
end


if (attacker:IsIllusion()) and attacker.owner and attacker.owner:GetQuest() and not attacker.owner:QuestCompleted() then 

	if unit:IsRealHero() then 
		if attacker.owner:GetQuest() == "Terr.Quest_5" and attacker:HasModifier("modifier_custom_terrorblade_reflection_unit") then 
			attacker.owner:UpdateQuest(damage)
		end

	end
end


if attacker:IsTempestDouble() and attacker.owner then 
	attacker = attacker.owner
end 


if (attacker:GetQuest() and not attacker:QuestCompleted()) then 

	if unit:IsRealHero() then 

		if attacker:GetQuest() == "General.Quest_10" and params.damage_type == DAMAGE_TYPE_PHYSICAL then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "General.Quest_11" and params.damage_type == DAMAGE_TYPE_PURE then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "General.Quest_12" and params.damage_type == DAMAGE_TYPE_MAGICAL then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "General.Quest_13" and attacker:HasModifier("modifier_item_black_king_bar_custom_active") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Jugg.Quest_8" and attacker:HasModifier("modifier_custom_juggernaut_omnislash") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Huskar.Quest_6" and params.inflictor and params.inflictor:GetName() == "custom_huskar_burning_spear" then 
			attacker:UpdateQuest(damage)
		end
	
		if attacker:GetQuest() == "Never.Quest_7" and unit:HasModifier("modifier_nevermore_requiem_fear") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Queen.Quest_7"and params.inflictor and params.inflictor:GetName() == "custom_queenofpain_scream_of_pain" then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Legion.Quest_5"and params.inflictor and params.inflictor:GetName() == "custom_legion_commander_overwhelming_odds" then 
			attacker:UpdateQuest(damage)
		end	

		if attacker:GetQuest() == "Brist.Quest_6" and params.inflictor and params.inflictor:GetName() == "bristleback_quill_spray_custom" then 
			attacker:UpdateQuest(damage)
		end
	
		if attacker:GetQuest() == "Puck.Quest_7" and attacker:HasModifier("modifier_custom_puck_phase_shift") and params.damage_type == DAMAGE_TYPE_MAGICAL then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Void.Quest_8" and params.inflictor and params.inflictor:GetName() == "void_spirit_astral_step_custom" then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Ember.Quest_6" and not params.inflictor and attacker:HasModifier("modifier_ember_spirit_sleight_of_fist_custom_caster") then 
			attacker:UpdateQuest(damage)
		end	

		if attacker:GetQuest() == "Ember.Quest_8" and params.inflictor and (params.inflictor:GetName() == "ember_spirit_activate_fire_remnant_custom" or params.inflictor:GetName() == "ember_spirit_fire_remnant_burst") then 
			attacker:UpdateQuest(damage)
		end
	
		if attacker:GetQuest() == "Pudge.Quest_6" and params.inflictor and (params.inflictor:GetName() == "custom_pudge_rot") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Hoodwink.Quest_5" and not params.inflictor and attacker:HasModifier("modifier_hoodwink_acorn_shot_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Troll.Quest_8" and (attacker:HasModifier("modifier_troll_warlord_battle_trance_custom") or unit:HasModifier("modifier_troll_warlord_battle_trance_custom")) then 
			attacker:UpdateQuest(damage)
		end
	
		if attacker:GetQuest() == "Lina.Quest_8" and params.inflictor and (params.inflictor:GetName() == "lina_laguna_blade_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Axe.Quest_7" and params.inflictor and (params.inflictor:GetName() == "axe_counter_helix_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "General.Quest_15" and attacker:HasModifier("modifier_quest_blink") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Anti.Quest_6" and attacker:HasModifier("modifier_antimage_blink_custom_quest") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Beast.Quest_8" and params.inflictor and (params.inflictor:GetName() == "primal_beast_pulverize_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Templar.Quest_6" and params.damage_type == DAMAGE_TYPE_PHYSICAL and attacker:HasModifier("modifier_templar_assassin_meld_custom_quest") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Templar.Quest_8" and params.damage_type == DAMAGE_TYPE_MAGICAL and  params.inflictor and (params.inflictor:GetName() == "templar_assassin_psionic_trap_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Monkey.Quest_5" and not params.inflictor and attacker:HasModifier("modifier_monkey_king_boundless_strike_custom_crit") then 
			attacker:UpdateQuest(damage)
		end
		
		if attacker:GetQuest() == "Mars.Quest_6" and not params.inflictor and attacker:HasModifier("modifier_mars_gods_rebuke_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Zuus.Quest_6" and params.inflictor and (params.inflictor:GetName() == "zuus_lightning_bolt_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Leshrac.Quest_6" and params.inflictor and (params.inflictor:GetName() == "leshrac_diabolic_edict_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Leshrac.Quest_7" and params.inflictor and (params.inflictor:GetName() == "leshrac_lightning_storm_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Leshrac.Quest_8" and params.inflictor and (params.inflictor:GetName() == "leshrac_pulse_nova_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Maiden.Quest_8" and params.inflictor and (params.inflictor:GetName() == "crystal_maiden_freezing_field_custom" or params.inflictor:GetName() == "crystal_maiden_freezing_field_legendary") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Maiden.Quest_6" and params.unit:HasModifier("modifier_crystal_maiden_frostbite_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Snapfire.Quest_8" and params.inflictor and (params.inflictor:GetName() == "snapfire_mortimer_kisses_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Sven.Quest_6" and ((params.inflictor and (params.inflictor:GetName() == "sven_great_cleave_custom")) 
			or (not params.inflictor and attacker:HasModifier('modifier_sven_great_cleave_custom_legendary'))) then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Blood.Quest_8" and params.inflictor and (params.inflictor:GetName() == "bloodseeker_rupture_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Ogre.Quest_6" and params.inflictor and (params.inflictor:GetName() == "ogre_magi_ignite_custom") then 
			attacker:UpdateQuest(damage)
		end


		if attacker:GetQuest() == "Sniper.Quest_7" and attacker.quest.number and (attacker:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D() >= attacker.quest.number then 
			attacker:UpdateQuest(damage)
		end


		if attacker:GetQuest() == "Muerta.Quest_7" and params.inflictor and (params.inflictor:GetName() == "muerta_gunslinger_custom") then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Pangolier.Quest_5" and attacker:HasModifier("modifier_pangolier_swashbuckle_custom_attacks") then 
			attacker:UpdateQuest(damage)
		end


		if attacker:GetQuest() == "Arc.Quest_8" and params.attacker:IsTempestDouble() then 
			attacker:UpdateQuest(damage)
		end


		if attacker:GetQuest() == "Invoker.Quest_7" and params.inflictor and (params.inflictor:GetName() == "invoker_sun_strike_custom" or params.inflictor:GetName() == "invoker_chaos_meteor_custom")  then 
			attacker:UpdateQuest(damage)
		end


		if attacker:GetQuest() == "Razor.Quest_8" and params.inflictor and params.inflictor:GetName() == "razor_eye_of_the_storm_custom" then 
			attacker:UpdateQuest(damage)
		end

		if attacker:GetQuest() == "Sand.Quest_8" and params.inflictor and params.inflictor:GetName() == "sandking_epicenter_custom" then 
			attacker:UpdateQuest(damage)
		end
	end

end






if false then 

	local id = attacker:GetPlayerOwnerID()
	if id and HTTP and HTTP.playersData and HTTP.playersData[id] then
		if unit:IsRealHero() then
			HTTP.playersData[id].heroDamage = HTTP.playersData[id].heroDamage + params.damage
		elseif unit:IsBuilding() then
			HTTP.playersData[id].towerDamage = HTTP.playersData[id].towerDamage + params.damage
		end
	end

	if attacker:IsHero() or attacker.onwer ~= nil then 
		local attacker_player = players[attacker:GetTeamNumber()]
		if attacker_player ~= nil then 

			local damage_name = "auto"
			if params.inflictor ~= nil then 
				damage_name = params.inflictor:GetName()
			end

			local ability_data = nil
			for j,ability in pairs(attacker_player.abilities) do 
				if ability.name ~= nil and ability.name == damage_name then 
					ability_data = ability
					break
				end
			end


			if ability_data == nil then 
				ability_data = {
					name = damage_name,
					damage_pre_reduction = 0,
					damage_post_reduction = 0
				}
				table.insert(attacker_player.abilities, ability_data)
			end
			ability_data.damage_pre_reduction = ability_data.damage_pre_reduction + params.original_damage
			ability_data.damage_post_reduction = ability_data.damage_post_reduction + params.damage

			if params.unit:IsBuilding() then
				ModifyDamageData(attacker_player.tower_damage, params, false)
			end

			if params.unit:IsRealHero() then
				ModifyDamageData(attacker_player.hero_damage, params, false)
			end

			
			if params.unit:IsCreep() then
				ModifyDamageData(attacker_player.creep_damage, params, false)
			end
		end
	end


	local receiver_player = players[params.unit:GetTeamNumber()]
	if params.unit:IsRealHero() and receiver_player ~= nil then 

		if params.attacker:IsBuilding() then
			ModifyDamageData(receiver_player.tower_damage, params, true)
		end

		if params.attacker:IsHero() then
			ModifyDamageData(receiver_player.hero_damage, params, true)
		end

		if params.attacker:IsCreep() then
			ModifyDamageData(receiver_player.creep_damage, params, true)
		end

	end

end

if (unit:IsNeutralUnitType()) then
	if attacker:IsRealHero() and (attacker.tip_ready == nil or attacker.tip_ready == true) then
		local attacker_level = attacker:GetLevel()
		local current_camp = nil
		local range_trigger_last = 10000
		local camps_ping = {}
		local table_tips = CustomNetTables:GetTableValue("TipsType", tostring(attacker:GetPlayerOwnerID()))

		for trigger_name, camp_name in pairs(self.Teams_Neutrals_Camps) do
			local trigger = Entities:FindByName(nil, trigger_name)
			local length = (trigger:GetAbsOrigin() - attacker:GetAbsOrigin()):Length2D()
			if length <= range_trigger_last then
				range_trigger_last = length
				current_camp = camp_name
			end
		end

		if attacker_level < 3 then
			if current_camp ~= nil and current_camp ~= "Easy" then
				for trigger_name, camp_name in pairs(self.Teams_Neutrals_Camps) do
					if camp_name == "Easy" then
						table.insert(camps_ping, trigger_name)
					end
				end	


				table.sort( camps_ping, function(x,y) return (Entities:FindByName(nil, y):GetAbsOrigin()-towers[attacker:GetTeamNumber()]:GetAbsOrigin()):Length2D() > (Entities:FindByName(nil, x):GetAbsOrigin()-towers[attacker:GetTeamNumber()]:GetAbsOrigin()):Length2D() end )
				if table_tips.type == 3 then
					if camps_ping and camps_ping[1] then
						local unit_camp = Entities:FindByName(nil, camps_ping[1])
						local abs = unit_camp:GetAbsOrigin()
						GameRules:ExecuteTeamPing( attacker:GetTeamNumber(), abs.x, abs.y, attacker, 0 )
					end
					if camps_ping and camps_ping[2] then
						local unit_camp = Entities:FindByName(nil, camps_ping[2])
						local abs = unit_camp:GetAbsOrigin()
						Timers:CreateTimer(1.5, function()
							GameRules:ExecuteTeamPing( attacker:GetTeamNumber(), abs.x, abs.y, attacker, 0 )
						end)
					end
					attacker.tip_ready = false
					if table_tips.type == 3 then
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(attacker:GetPlayerOwnerID()), "TipForPlayer", {duration = 7, text = "#Tip_EasyCamp"})
					end
					Timers:CreateTimer(10, function ()
						attacker.tip_ready = true
					end)
				end
			end
		elseif attacker_level >= 3 and attacker_level <= 5 then

			if current_camp ~= nil and (current_camp ~= "Easy" and current_camp ~= "Medium") then

					for trigger_name, camp_name in pairs(self.Teams_Neutrals_Camps) do
						if camp_name == "Medium" then
							table.insert(camps_ping, trigger_name)
						end
					end	

				table.sort( camps_ping, function(x,y) return (Entities:FindByName(nil, y):GetAbsOrigin()-towers[attacker:GetTeamNumber()]:GetAbsOrigin()):Length2D() > (Entities:FindByName(nil, x):GetAbsOrigin()-towers[attacker:GetTeamNumber()]:GetAbsOrigin()):Length2D() end )
				if table_tips.type == 3 then
					if camps_ping and camps_ping[1] then
						local unit_camp = Entities:FindByName(nil, camps_ping[1])
						local abs = unit_camp:GetAbsOrigin()
						GameRules:ExecuteTeamPing( attacker:GetTeamNumber(), abs.x, abs.y, attacker, 0 )
					end
					if camps_ping and camps_ping[2] then
						local unit_camp = Entities:FindByName(nil, camps_ping[2])
						local abs = unit_camp:GetAbsOrigin()
						Timers:CreateTimer(1.5, function()
							GameRules:ExecuteTeamPing( attacker:GetTeamNumber(), abs.x, abs.y, attacker, 0 )
						end)
					end
					attacker.tip_ready = false

					if table_tips.type == 3 then
						CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(attacker:GetPlayerOwnerID()), "TipForPlayer", {duration = 7, text = "#Tip_MediumCamp"})
					end

					Timers:CreateTimer(10, function ()
						attacker.tip_ready = true
					end)
				end
			end
		end
	end
end







if (unit:GetUnitName() == "npc_towerdire" or unit:GetUnitName() == "npc_towerradiant") and unit:GetHealthPercent() < 0.001 and attacker:IsHero() then 

	unit.killer = attacker

end



if attacker:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 and unit:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5 then return end


if unit:HasModifier("modifier_abbadon_passive") then 
	local mod = unit:FindModifierByName("modifier_abbadon_passive")
	mod:DoScript()
end


end




modifier_quest_blink = class({})
function modifier_quest_blink:IsHidden() return false end
function modifier_quest_blink:IsPurgable() return false end