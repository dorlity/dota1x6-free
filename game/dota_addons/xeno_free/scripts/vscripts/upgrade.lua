LinkLuaModifier( "modifier_lownet_gold", "upgrade/general/modifier_lownet_gold", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lownet_blue", "upgrade/general/modifier_lownet_blue", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lownet_purple", "upgrade/general/modifier_lownet_purple", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lownet_choose", "modifiers/modifier_lownet_choose", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_end_choise", "modifiers/modifier_end_choise", LUA_MODIFIER_MOTION_NONE )


if upgrade == nil then
	_G.upgrade = class({})
end





skills = {
	all = {
		{"modifier_up_primary",0, "gray" ,0,"gray_item","Possessed_Mask",25,4, {"only_normal"}}, 
		{"modifier_up_health",0,"gray",0,"gray_item","Vitality_Booster",25,80}, 
		{"modifier_up_damage",0,"gray",0,"gray_item","Broadsword",25,10}, 
		{"modifier_up_armor",0,"gray",0,"gray_item","Chainmail",25,3},
		{"modifier_up_secondary",0, "gray",0,"gray_item","Pupil_Gift",25,3, {"only_normal"}}, 
		{"modifier_up_spelldamage",0, "gray",0,"gray_item","Kaya",25,2, {"mage"}}, 
		{"modifier_up_movespeed",0,"gray",0,"gray_item","Boots_of_Speed",25,10}, 
		{"modifier_up_evasion",0,"gray",0,"gray_item","Talisman_of_Evasion",25,6}, 
		{"modifier_up_lifesteal",0,"gray",0,"gray_item","Morbid_Mask",25,6},
		{"modifier_up_speed",0,"gray",0,"gray_item","Gloves_of_Haste",25,10},
		--{"modifier_up_gold",0,"gray",0,"gray_item","Philosopher_Stone",25,50},
		{"modifier_up_spellsteal",0,"gray",0,"gray_item","Voodoo_Mask",25,4, {"mage"}},
		{"modifier_up_statusresist",0,"gray",0,"gray_item","Titan_Sliver",25,4},
		{"modifier_up_cleave",0,"gray",0,"gray_item","Battle_Fury",25,10, {"melle"}},
		{"modifier_up_magicresist",0,"gray",0,"gray_item","Cloak",25,3},
		{"modifier_up_javelin",0,"gray",0,"gray_item","Javelin",25,15},
		{"modifier_up_creeps",0,"gray",0,"gray_item","Quelling_Blade",25,7},
		{"modifier_up_manaregen",0,"gray",0,"gray_item","Voidstone",25,3},
		{"modifier_up_allstats",0, "gray" ,0,"gray_item","circlet",25,2, {"only_all"}}, 
		{"modifier_up_ignore_armor",0, "gray" ,0,"gray_item","blight",25,1}, 
		{"modifier_up_aoe_damage",0, "gray" ,0,"gray_item","dragon",25,10}, 
	
		--{"modifier_tower_up",2,"gray",0,"gray_skill","Tower",25,2},
		
		{"modifier_up_slow",0,"blue",3,"blue_item","Penta-Edged_Sword",25,0},
		{"modifier_up_gainprimary",0,"blue",3,"blue_item","Crown",22,0, {"only_normal"}},
		{"modifier_up_gainsecondary",0,"blue",3,"blue_item","Ocean_Heart",22,0, {"only_normal"}},
		{"modifier_up_magicblock",0,"blue",3,"blue_item","Hood_of_Defiance",3,0},
		{"modifier_up_attackblock",0,"blue",3,"blue_item","Crimson_Guard",3,0},
		{"modifier_up_cooldown",0,"blue",3,"blue_item","Octarine_Core",3,0},
		{"modifier_up_stun",0,"blue",3,"blue_item","vest",3,0},
		{"modifier_up_root",0,"blue",3,"blue_skill","earthbind",3,0},
		{"modifier_up_bigdamage",0,"blue",3,"blue_skill","Defend_Matrix",22,0},
		{"modifier_up_venom",0,"blue",3,"blue_item","venom",22,0},
		{"modifier_up_range",0,"blue",3,"blue_item","dragon_lance",22,0},
		{"modifier_up_gainall",0,"blue",3,"blue_item","Crown",22,0, {"only_all"}},
		{"modifier_up_teamfight",0,"blue",3,"blue_item","Martyr",22,0},
		{"modifier_up_random_gray",0,"blue",3,"blue_item","Gray",22,0},
		--{"modifier_up_toweraoe",2,"blue",3,"blue_skill","Tower",25,0},
	

		{"modifier_up_primaryupgrade",0,"purple",1,"purple_item","Apex",19,0, {"only_normal"}},
		{"modifier_up_secondaryupgrade",0,"purple",1,"purple_item","Ultimate_Orb",19,0, {"only_normal"}},
		{"modifier_up_allupgrade",0,"purple",1,"purple_item","Apex",19,0, {"only_all"}},
		--{"modifier_up_fullhpresist",0,"purple",1,"purple_item","Aeon_Disk",22,0},
		{"modifier_up_graypoints",0,"purple",1,"purple_item","Gray",25,0},
		{"modifier_up_bluepoints",0,"purple",1,"purple_item","Blue",25,0},
		{"modifier_up_orangepoints",0,"purple",1,"purple_item","orange",25,0},
		{"modifier_up_res",0,"purple",1,"purple_skill","Phoenix_Ash",20,0},
		{"modifier_up_damagestack",0,"purple",1,"purple_item","Timeless_Relic",20,0},
		

		--{"modifier_up_towerdisarm",2,"purple",1,"purple_skill","Tower",22,0},
	},

	lowest = {
		{"modifier_lownet_gold",0, "blue", 1, "blue_skill", "greed", 22, 0},
		{"modifier_lownet_blue",0, "blue", 1, "blue_item", "blue", 22, 0},
		{"modifier_lownet_purple",0, "blue", 1, "blue_item", "purple", 22, 0},
	},

	patrol_1 = {
		{"modifier_patrol_reward_ward",0, "blue", 1, "blue_item", "Wards", 22, 0},
		{"modifier_patrol_reward_midas",0, "blue", 1, "blue_item", "patrol_midas", 22, 0},
	    --{"modifier_patrol_reward_repair",0, "blue", 1, "blue_item", "Repair_Kit", 22, 0},
		{"modifier_patrol_reward_warp_amulet",0, "blue", 1, "blue_item", "warp_amulet", 22, 0},
		{"modifier_patrol_reward_contract",0, "blue", 1, "blue_item", "contract", 22, 0},
		{"modifier_patrol_reward_orb",0, "blue", 1, "blue_item", "restrained_orb", 22, 0},
	},

	patrol_2 = {
		{"modifier_patrol_reward_eye",0, "blue", 1, "purple_item", "Third_Eye", 22, 0},
		--{"modifier_patrol_reward_trap",0, "blue", 1, "purple_skill", "item_trap", 22, 0},
		{"modifier_patrol_reward_razor",0, "blue", 1, "purple_item", "patrol_razor", 22, 0},
		{"modifier_patrol_reward_necro",0, "blue", 1, "purple_item", "patrol_necro", 22, 0},
		{"modifier_patrol_reward_fortifier",0, "blue", 1, "purple_item", "patrol_fortifier", 22, 0},
	--	{"modifier_patrol_reward_grenade",0, "blue", 1, "purple_item", "patrol_grenade", 22, 0},
		{"modifier_patrol_reward_ash",0, "blue", 1, "purple_skill", "Phoenix_Ash", 22, 0},
	},


	alchemist_items = {
		{"modifier_recipe_gold_skadi",0, "blue", 1, "purple_item", "gold_skadi", 22, 0},
		{"modifier_recipe_gold_heart",0, "blue", 1, "purple_item", "gold_heart", 22, 0},
		{"modifier_recipe_gold_assault",0, "blue", 1, "purple_item", "gold_assault", 22, 0},
		{"modifier_recipe_gold_octarine",0, "blue", 1, "purple_item", "gold_octarine", 22, 0},
		{"modifier_recipe_gold_daedalus",0, "blue", 1, "purple_item", "gold_crit", 22, 0},
		{"modifier_recipe_gold_bfury",0, "blue", 1, "purple_item", "gold_bf", 22, 0},
		{"modifier_recipe_gold_shiva",0, "blue", 1, "purple_item", "gold_shiva", 22, 0},
	},


	npc_dota_hero_juggernaut = {
		{"modifier_juggernaut_bladefury_damage",1,"blue",3,"blue_skill","Blade_Fury",25,1,"Blade_fury_1",0},
		{"modifier_juggernaut_bladefury_duration",1,"blue",3,"blue_skill","Blade_Fury",25,1,"Blade_fury_2",1},
		{"modifier_juggernaut_bladefury_chance",1,"blue",3,"blue_skill","Blade_Fury",19,1,"Blade_fury_3",1},
	
		{"modifier_juggernaut_healingward_heal",1,"blue",3,"blue_skill","Healing_Ward",25,2,"Healing_ward_1",0},
		{"modifier_juggernaut_healingward_cd",1,"blue",3,"blue_skill","Healing_Ward",25,2,"Healing_ward_2",0},
		{"modifier_juggernaut_healingward_move",1,"blue",3,"blue_skill","Healing_Ward",22,2,"Healing_ward_3",0},
	
		{"modifier_juggernaut_bladedance_lowhp",1,"blue",3,"blue_skill","Blade_Dance",18,3,"Blade_dance_6",0},
		{"modifier_juggernaut_bladedance_chance",1,"blue",3,"blue_skill","Blade_Dance",25,3,"Blade_dance_2",0},
		{"modifier_juggernaut_bladedance_speed",1,"blue",3,"blue_skill","Blade_Dance",22,3,"Blade_dance_3",0},
	
		{"modifier_juggernaut_omnislash_stack",1,"blue",3,"blue_skill","Omnislash",22,4,"Omnislash_1",0},
		{"modifier_juggernaut_omnislash_heal",1,"blue",3,"blue_skill","Omnislash",25,4,"Omnislash_4",0},
		{"modifier_juggernaut_omnislash_speed",1,"blue",3,"blue_skill","Omnislash",22,4,"Omnislash_6",1},

		{"modifier_juggernaut_bladefury_agility",1,"purple",2,"purple_skill","Blade_Fury",19,1,"Blade_fury_4",1},
		{"modifier_juggernaut_bladefury_silence",1,"purple",1,"purple_skill","Blade_Fury",25,1,"Blade_fury_5",1},
		{"modifier_juggernaut_bladefury_shield",1,"purple",1,"purple_skill","Blade_Fury",19,1,"Blade_fury_6",0},
	
		{"modifier_juggernaut_healingward_return",1,"purple",2,"purple_skill","Healing_Ward",22,2,"Healing_ward_5",1},
		{"modifier_juggernaut_healingward_purge",1,"purple",1,"purple_skill","Healing_Ward",25,2,"Healing_ward_4",1},
		{"modifier_juggernaut_healingward_stun",1,"purple",1,"purple_skill","Healing_Ward",20,2,"Healing_ward_6",1},
	
		{"modifier_juggernaut_bladedance_stack",1,"purple",2,"purple_skill","Blade_Dance",22,3,"Blade_dance_1",1},
		{"modifier_juggernaut_bladedance_double",1,"purple",1,"purple_skill","Blade_Dance",23,3,"Blade_dance_4",1},
		{"modifier_juggernaut_bladedance_parry",1,"purple",1,"purple_skill","Blade_Dance",22,3,"Blade_dance_5",0},
	
		{"modifier_juggernaut_omnislash_cd",1,"purple",2,"purple_skill","Omnislash",22,4,"Omnislash_3",1},
		{"modifier_juggernaut_omnislash_clone",1,"purple",1,"purple_skill","Omnislash",18,4,"Omnislash_2",0},
		{"modifier_juggernaut_omnislash_aoe_attack",1,"purple",1,"purple_skill","Omnislash",22,4,"Omnislash_5",1},

		{"modifier_juggernaut_bladefury_legendary",1,"orange",0,"orange_skill","Blade_Fury",25,1,1},
		{"modifier_juggernaut_healingward_legendary",1,"orange",0,"orange_skill","Healing_Ward",19,1,2},
		{"modifier_juggernaut_bladedance_legendary",1,"orange",0,"orange_skill","Blade_Dance",18,1,3},
		{"modifier_juggernaut_omnislash_legendary",1,"orange",0,"orange_skill","Omnislash",20,1,4},
	},


	npc_dota_hero_phantom_assassin = {
		{"modifier_phantom_assassin_dagger_cd",1,"blue",3,"blue_skill","Stifling_Dagger",25,1,"Stifling_Dagger_1",0},
		{"modifier_phantom_assassin_dagger_aoe",1,"blue",3,"blue_skill","Stifling_Dagger",25,1,"Stifling_Dagger_4",1},
		{"modifier_phantom_assassin_dagger_damage",1,"blue",3,"blue_skill","Stifling_Dagger",25,1,"Stifling_Dagger_5",1},
	
		{"modifier_phantom_assassin_blink_move",1,"blue",3,"blue_skill","Phantom_Strike",22,2,"Phantom_Strike_1",1},
		{"modifier_phantom_assassin_blink_duration",1,"blue",3,"blue_skill","Phantom_Strike",25,2,"Phantom_Strike_2",0},
		{"modifier_phantom_assassin_blink_damage",1,"blue",3,"blue_skill","Phantom_Strike",19,2,"Phantom_Strike_5",1},
	
		{"modifier_phantom_assassin_blur_delay",1,"blue",3,"blue_skill","Blur",25,3,"Blur_1",0},
		{"modifier_phantom_assassin_blur_heal",1,"blue",3,"blue_skill","Blur",22,3,"Blur_2",1},
		{"modifier_phantom_assassin_blur_chance",1,"blue",3,"blue_skill","Blur",25,3,"Blur_5",0},
	
		{"modifier_phantom_assassin_crit_chance",1,"blue",3,"blue_skill","Coup_de_Grace",25,4,"Coup_de_Grace_5",0},
		{"modifier_phantom_assassin_crit_damage",1,"blue",3,"blue_skill","Coup_de_Grace",22,4,"Coup_de_Grace_2",0},
		{"modifier_phantom_assassin_crit_speed",1,"blue",3,"blue_skill","Coup_de_Grace",22,4,"Coup_de_Grace_3",0},

		{"modifier_phantom_assassin_dagger_double",1,"purple",2,"purple_skill","Stifling_Dagger",19,1,"Stifling_Dagger_6",1},
		{"modifier_phantom_assassin_dagger_duration",1,"purple",1,"purple_skill","Stifling_Dagger",22,1,"Stifling_Dagger_2",1},
		{"modifier_phantom_assassin_dagger_heal",1,"purple",1,"purple_skill","Stifling_Dagger",20,1,"Stifling_Dagger_3",0},
	
		{"modifier_phantom_assassin_blink_illusion",1,"purple",2,"purple_skill","Phantom_Strike",21,2,"Phantom_Strike_3",0},
		{"modifier_phantom_assassin_blink_blink",1,"purple",1,"purple_skill","Phantom_Strike",19,2,"Phantom_Strike_4",1},
		{"modifier_phantom_assassin_blink_blind",1,"purple",1,"purple_skill","Phantom_Strike",19,2,"Phantom_Strike_6",1},
	
		{"modifier_phantom_assassin_blur_blood",1,"purple",2,"purple_skill","Blur",20,3,"Blur_6",1},
		{"modifier_phantom_assassin_blur_reduction",1,"purple",1,"purple_skill","Blur",18,3,"Blur_3",1},
		{"modifier_phantom_assassin_blur_stun",1,"purple",1,"purple_skill","Blur",20,3,"Blur_4",1},
	
		{"modifier_phantom_assassin_crit_stack",1,"purple",2,"purple_skill","Coup_de_Grace",22,4,"Coup_de_Grace_1",0},
		{"modifier_phantom_assassin_crit_lowhp",1,"purple",1,"purple_skill","Coup_de_Grace",22,4,"Coup_de_Grace_4",1},
		{"modifier_phantom_assassin_crit_steal",1,"purple",1,"purple_skill","Coup_de_Grace",22,4,"Coup_de_Grace_6",0},

		{"modifier_phantom_assassin_dagger_legendary",1,"orange",0,"orange_skill","Stifling_Dagger",18,1,1},
		{"modifier_phantom_assassin_blink_legendary",1,"orange",0,"orange_skill","Phantom_Strike",22,1,2},
		{"modifier_phantom_assassin_blur_legendary",1,"orange",0,"orange_skill","Blur",20,1,3},
		{"modifier_phantom_assassin_crit_legendary",1,"orange",0,"orange_skill","Coup_de_Grace",19,1,4},
	},

	npc_dota_hero_huskar = {
		{"modifier_huskar_disarm_duration",1,"blue",3,"blue_skill","Inner_Fire",25,1,"Inner_Fire_1",0},
		{"modifier_huskar_disarm_heal",1,"blue",3,"blue_skill","Inner_Fire",25,1,"Inner_Fire_2",1},
		{"modifier_huskar_disarm_crit",1,"blue",3,"blue_skill","Inner_Fire",2,1,"Inner_Fire_4",0},
	
		{"modifier_huskar_spears_damage",1,"blue",3,"blue_skill","Burning_Spears",25,2,"Burning_Spears_1",0},
		{"modifier_huskar_spears_blast",1,"blue",3,"blue_skill","Burning_Spears",25,2,"Burning_Spears_2",0},
		{"modifier_huskar_spears_armor",1,"blue",3,"blue_skill","Burning_Spears",22,2,"Burning_Spears_3",1},
	
		{"modifier_huskar_passive_regen",1,"blue",3,"blue_skill","Berserkers_Blood",25,3,"Berserkers_Blood_6",0},
		{"modifier_huskar_passive_speed",1,"blue",3,"blue_skill","Berserkers_Blood",22,3,"Berserkers_Blood_1",0},
		{"modifier_huskar_passive_damage",1,"blue",3,"blue_skill","Berserkers_Blood",25,3,"Berserkers_Blood_2",1},
	
		{"modifier_huskar_leap_damage",1,"blue",3,"blue_skill","Life_Break",22,4,"Life_Break_3",0},
		{"modifier_huskar_leap_cd",1,"blue",3,"blue_skill","Life_Break",25,4,"Life_Break_1",0},
		{"modifier_huskar_leap_double",1,"blue",3,"blue_skill","Life_Break",22,4,"Life_Break_5",0},
	
		{"modifier_huskar_disarm_str",1,"purple",2,"purple_skill","Inner_Fire",18,1,"Inner_Fire_3",1},
		{"modifier_huskar_disarm_silence",1,"purple",1,"purple_skill","Inner_Fire",25,1,"Inner_Fire_5",1},
		{"modifier_huskar_disarm_lowhp",1,"purple",1,"purple_skill","Inner_Fire",18,1,"Inner_Fire_6",0},
	
		{"modifier_huskar_spears_tick",1,"purple",2,"purple_skill","Burning_Spears",22,2,"Burning_Spears_4",0},
		{"modifier_huskar_spears_aoe",1,"purple",1,"purple_skill","Burning_Spears",18,2,"Burning_Spears_5",1},
		{"modifier_huskar_spears_pure",1,"purple",1,"purple_skill","Burning_Spears",22,2,"Burning_Spears_6",0},
	
		{"modifier_huskar_passive_active",1,"purple",2,"purple_skill","Berserkers_Blood",22,3,"Berserkers_Blood_4",1},
		{"modifier_huskar_passive_lowhp",1,"purple",1,"purple_skill","Berserkers_Blood",22,3,"Berserkers_Blood_3",1},
		{"modifier_huskar_passive_armor",1,"purple",1,"purple_skill","Berserkers_Blood",22,3,"Berserkers_Blood_5",1},
	
		{"modifier_huskar_leap_shield",1,"purple",2,"purple_skill","Life_Break",22,4,"Life_Break_2",1},
		{"modifier_huskar_leap_resist",1,"purple",1,"purple_skill","Life_Break",18,4,"Life_Break_4",1},
		{"modifier_huskar_leap_immune",1,"purple",1,"purple_skill","Life_Break",22,4,"Life_Break_6",1},

		{"modifier_huskar_disarm_legendary",1,"orange",0,"orange_skill","Inner_Fire",25,1,1},
		{"modifier_huskar_spears_legendary",1,"orange",0,"orange_skill","Burning_Spears",17,1,2},
		{"modifier_huskar_passive_legendary",1,"orange",0,"orange_skill","Berserkers_Blood",22,1,3},
		{"modifier_huskar_leap_legendary",1,"orange",0,"orange_skill","Life_Break",22,1,4},
	},

	npc_dota_hero_nevermore = {
		{"modifier_nevermore_raze_damage",1,"blue",3,"blue_skill","Shadowraze",25,1,"Shadowraze_1",0},
		{"modifier_nevermore_raze_cd",1,"blue",3,"blue_skill","Shadowraze",25,1,"Shadowraze_2",0},
		{"modifier_nevermore_raze_speed",1,"blue",3,"blue_skill","Shadowraze",2,1,"Shadowraze_3",0},
	
		{"modifier_nevermore_souls_damage",1,"blue",3,"blue_skill","Necromastery",25,2,"Necromastery_1",0},
		{"modifier_nevermore_souls_max",1,"blue",3,"blue_skill","Necromastery",25,2,"Necromastery_2",0},
		{"modifier_nevermore_souls_attack",1,"blue",3,"blue_skill","Necromastery",22,2,"Necromastery_3",0},
	
		{"modifier_nevermore_darklord_armor",1,"blue",3,"blue_skill","Dark_Lord",25,3,"Dark_Lord_1",0},
		{"modifier_nevermore_darklord_slow",1,"blue",3,"blue_skill","Dark_Lord",25,3,"Dark_Lord_2",0},
		{"modifier_nevermore_darklord_damage",1,"blue",3,"blue_skill","Dark_Lord",22,3,"Dark_Lord_4",0},
	
		{"modifier_nevermore_requiem_damage",1,"blue",3,"blue_skill","Requiem",22,4,"Requiem_1",0},
		{"modifier_nevermore_requiem_cd",1,"blue",3,"blue_skill","Requiem",25,4,"Requiem_2",0},
		{"modifier_nevermore_requiem_heal",1,"blue",3,"blue_skill","Requiem",22,4,"Requiem_3",0},

		{"modifier_nevermore_raze_burn",1,"purple",2,"purple_skill","Shadowraze",18,1,"Shadowraze_4",1},
		{"modifier_nevermore_raze_combocd",1,"purple",1,"purple_skill","Shadowraze",25,1,"Shadowraze_5",1},
		{"modifier_nevermore_raze_duration",1,"purple",1,"purple_skill","Shadowraze",18,1,"Shadowraze_6",0},
	
		{"modifier_nevermore_souls_tempo",1,"purple",2,"purple_skill","Necromastery",22,2,"Necromastery_6",1},
		{"modifier_nevermore_souls_heal",1,"purple",1,"purple_skill","Necromastery",18,2,"Necromastery_5",1},
		{"modifier_nevermore_souls_kills",1,"purple",1,"purple_skill","Necromastery",22,2,"Necromastery_4",0},
	
		{"modifier_nevermore_darklord_health",1,"purple",2,"purple_skill","Dark_Lord",22,3,"Dark_Lord_3",1},
		{"modifier_nevermore_darklord_self",1,"purple",1,"purple_skill","Dark_Lord",22,3,"Dark_Lord_5",0},
		{"modifier_nevermore_darklord_silence",1,"purple",1,"purple_skill","Dark_Lord",22,3,"Dark_Lord_6",1},
	
		{"modifier_nevermore_requiem_proc",1,"purple",2,"purple_skill","Requiem",22,4,"Requiem_6",1},
		{"modifier_nevermore_requiem_bkb",1,"purple",1,"purple_skill","Requiem",18,4,"Requiem_5",0},
		{"modifier_nevermore_requiem_cdsoul",1,"purple",1,"purple_skill","Requiem",22,4,"Requiem_4",1},

		{"modifier_nevermore_raze_legendary",1,"orange",0,"orange_skill","Shadowraze",25,1,1},
		{"modifier_nevermore_souls_legendary",1,"orange",0,"orange_skill","Necromastery",17,1,2},
		{"modifier_nevermore_darklord_legendary",1,"orange",0,"orange_skill","Dark_Lord",22,1,3},
		{"modifier_nevermore_requiem_legendary",1,"orange",0,"orange_skill","Requiem",22,1,4},	
	},

	npc_dota_hero_legion_commander = {
		{"modifier_legion_odds_cd",1,"blue",3,"blue_skill","Odds",25,1,"Odds_1",0},
		{"modifier_legion_odds_creep",1,"blue",3,"blue_skill","Odds",25,1,"Odds_2",0},
		{"modifier_legion_odds_triple",1,"blue",3,"blue_skill","Odds",2,1,"Odds_4",0},
	
		{"modifier_legion_press_cd",1,"blue",3,"blue_skill","Press",25,2,"Press_3",0},
		{"modifier_legion_press_regen",1,"blue",3,"blue_skill","Press",25,2,"Press_2",0},
		{"modifier_legion_press_speed",1,"blue",3,"blue_skill","Press",22,2,"Press_1",0},
	
		{"modifier_legion_moment_chance",1,"blue",3,"blue_skill","Moment",25,3,"Moment_1",0},
		{"modifier_legion_moment_defence",1,"blue",3,"blue_skill","Moment",25,3,"Moment_2",0},
		{"modifier_legion_moment_damage",1,"blue",3,"blue_skill","Moment",22,3,"Moment_3",0},
	
		{"modifier_legion_duel_passive",1,"blue",3,"blue_skill","Duel",22,4,"Duel_1",0},
		{"modifier_legion_duel_return",1,"blue",3,"blue_skill","Duel",25,4,"Duel_2",0},
		{"modifier_legion_duel_speed",1,"blue",3,"blue_skill","Duel",22,4,"Duel_3",0},

		{"modifier_legion_odds_proc",1,"purple",2,"purple_skill","Odds",18,1,"Odds_3",0},
		{"modifier_legion_odds_solo",1,"purple",1,"purple_skill","Odds",25,1,"Odds_5",0},
		{"modifier_legion_odds_mark",1,"purple",1,"purple_skill","Odds",18,1,"Odds_6",0},
	
		{"modifier_legion_press_duration",1,"purple",2,"purple_skill","Press",22,2,"Press_4",0},
		{"modifier_legion_press_after",1,"purple",1,"purple_skill","Press",18,2,"Press_5",1},
		{"modifier_legion_press_lowhp",1,"purple",1,"purple_skill","Press",22,2,"Press_6",0},
	
		{"modifier_legion_moment_armor",1,"purple",2,"purple_skill","Moment",22,3,"Moment_4",1},
		{"modifier_legion_moment_lowhp",1,"purple",1,"purple_skill","Moment",22,3,"Moment_5",1},
		{"modifier_legion_moment_bkb",1,"purple",1,"purple_skill","Moment",22,3,"Moment_6",0},
	
		{"modifier_legion_duel_damage",1,"purple",2,"purple_skill","Duel",22,4,"Duel_4",0},
		{"modifier_legion_duel_win",1,"purple",1,"purple_skill","Duel",18,4,"Duel_5",1},
		{"modifier_legion_duel_blood",1,"purple",1,"purple_skill","Duel",22,4,"Duel_6",0},

		{"modifier_legion_odds_legendary",1,"orange",0,"orange_skill","Odds",25,0,1},
		{"modifier_legion_press_legendary",1,"orange",0,"orange_skill","Press",17,0,2},
		{"modifier_legion_moment_legendary",1,"orange",0,"orange_skill","Moment",22,1,3},
		{"modifier_legion_duel_legendary",1,"orange",0,"orange_skill","Duel",22,0,4},
	},

	npc_dota_hero_queenofpain = {
		{"modifier_queen_Dagger_damage",1,"blue",3,"blue_skill","Dagger",25,1,"Dagger_1",0},
		{"modifier_queen_Dagger_heal",1,"blue",3,"blue_skill","Dagger",25,1,"Dagger_2",0},
		{"modifier_queen_Dagger_auto",1,"blue",3,"blue_skill","Dagger",2,1,"Dagger_3",0},
	
		{"modifier_queen_Blink_cd",1,"blue",3,"blue_skill","Blink",25,2,"Blink_1",0},
		{"modifier_queen_Blink_damage",1,"blue",3,"blue_skill","Blink",25,2,"Blink_2",0},
		{"modifier_queen_Blink_speed",1,"blue",3,"blue_skill","Blink",22,2,"Blink_3",0},
	
		{"modifier_queen_Scream_damage",1,"blue",3,"blue_skill","Scream",25,3,"Scream_1",0},
		{"modifier_queen_Scream_cd",1,"blue",3,"blue_skill","Scream",25,3,"Scream_2",0},
		{"modifier_queen_Scream_double",1,"blue",3,"blue_skill","Scream",22,3,"Scream_3",0},
	
		{"modifier_queen_Sonic_damage",1,"blue",3,"blue_skill","Sonic",22,4,"Sonic_1",0},
		{"modifier_queen_Sonic_fire",1,"blue",3,"blue_skill","Sonic",25,4,"Sonic_2",1},
		{"modifier_queen_Sonic_reduce",1,"blue",3,"blue_skill","Sonic",22,4,"Sonic_3",0},

		{"modifier_queen_Dagger_proc",1,"purple",2,"purple_skill","Dagger",18,1,"Dagger_4",0},
		{"modifier_queen_Dagger_aoe",1,"purple",1,"purple_skill","Dagger",25,1,"Dagger_5",0},
		{"modifier_queen_Dagger_poison",1,"purple",1,"purple_skill","Dagger",18,1,"Dagger_6",0},
	
		{"modifier_queen_Blink_magic",1,"purple",2,"purple_skill","Blink",22,2,"Blink_4",1},
		{"modifier_queen_Blink_spells",1,"purple",1,"purple_skill","Blink",18,2,"Blink_5",1},
		{"modifier_queen_Blink_absorb",1,"purple",1,"purple_skill","Blink",22,2,"Blink_6",0},
	
		{"modifier_queen_Scream_shield",1,"purple",2,"purple_skill","Scream",22,3,"Scream_6",0},
		{"modifier_queen_Scream_slow",1,"purple",1,"purple_skill","Scream",22,3,"Scream_5",0},
		{"modifier_queen_Scream_fear",1,"purple",1,"purple_skill","Scream",22,3,"Scream_4",0},
	
		{"modifier_queen_Sonic_taken",1,"purple",2,"purple_skill","Sonic",22,4,"Sonic_5",0},
		{"modifier_queen_Sonic_far",1,"purple",1,"purple_skill","Sonic",18,4,"Sonic_4",0},
		{"modifier_queen_Sonic_cd",1,"purple",1,"purple_skill","Sonic",22,4,"Sonic_6",1},

		{"modifier_queen_Dagger_legendary",1,"orange",0,"orange_skill","Dagger",25,0,1},
		{"modifier_queen_Blink_legendary",1,"orange",0,"orange_skill","Blink",17,1,2},
		{"modifier_queen_Scream_legendary",1,"orange",0,"orange_skill","Scream",22,0,3},
		{"modifier_queen_Sonic_legendary",1,"orange",0,"orange_skill","Sonic",22,0,4},
	},

	npc_dota_hero_terrorblade = {
		{"modifier_terror_reflection_duration",1,"blue",3,"blue_skill","Reflection",25,1,"Reflection_1",0},
		{"modifier_terror_reflection_speed",1,"blue",3,"blue_skill","Reflection",25,1,"Reflection_2",0},
		{"modifier_terror_reflection_slow",1,"blue",3,"blue_skill","Reflection",2,1,"Reflection_3",0},
	
		{"modifier_terror_illusion_incoming",1,"blue",3,"blue_skill","Illusion",25,2,"Illusion_1",0},
		{"modifier_terror_illusion_duration",1,"blue",3,"blue_skill","Illusion",25,2,"Illusion_2",0},
		{"modifier_terror_illusion_stack",1,"blue",3,"blue_skill","Illusion",22,2,"Illusion_4",0},
	
		{"modifier_terror_meta_stats",1,"blue",3,"blue_skill","Meta",25,3,"Meta_1",0},
		{"modifier_terror_meta_regen",1,"blue",3,"blue_skill","Meta",25,3,"Meta_6",0},
		{"modifier_terror_meta_magic",1,"blue",3,"blue_skill","Meta",22,3,"Meta_3",0},
	
		{"modifier_terror_sunder_cd",1,"blue",3,"blue_skill","Sunder",22,4,"Sunder_2",0},
		{"modifier_terror_sunder_damage",1,"blue",3,"blue_skill","Sunder",25,4,"Sunder_1",1},
		{"modifier_terror_sunder_amplify",1,"blue",3,"blue_skill","Sunder",22,4,"Sunder_5",0},

		{"modifier_terror_reflection_silence",1,"purple",2,"purple_skill","Reflection",18,1,"Reflection_4",0},
		{"modifier_terror_reflection_stun",1,"purple",1,"purple_skill","Reflection",25,1,"Reflection_5",1},
		{"modifier_terror_reflection_double",1,"purple",1,"purple_skill","Reflection",18,1,"Reflection_6",0},
	
		{"modifier_terror_illusion_double",1,"purple",2,"purple_skill","Illusion",22,2,"Illusion_3",0},
		{"modifier_terror_illusion_resist",1,"purple",1,"purple_skill","Illusion",18,2,"Illusion_5",1},
		{"modifier_terror_illusion_texture",1,"purple",1,"purple_skill","Illusion",22,2,"Illusion_6",0},
	
		{"modifier_terror_meta_start",1,"purple",2,"purple_skill","Meta",22,3,"Meta_4",0},
		{"modifier_terror_meta_range",1,"purple",1,"purple_skill","Meta",22,3,"Meta_5",0},
		{"modifier_terror_meta_lowhp",1,"purple",1,"purple_skill","Meta",22,3,"Meta_2",0},
	
		{"modifier_terror_sunder_stats",1,"purple",2,"purple_skill","Sunder",22,4,"Sunder_3",0},
		{"modifier_terror_sunder_heal",1,"purple",1,"purple_skill","Sunder",18,4,"Sunder_4",0},
		{"modifier_terror_sunder_swap",1,"purple",1,"purple_skill","Sunder",22,4,"Sunder_6",1},

		{"modifier_terror_reflection_legendary",1,"orange",0,"orange_skill","Reflection",25,1,1},
		{"modifier_terror_illusion_legendary",1,"orange",0,"orange_skill","Illusion",17,1,2},
		{"modifier_terror_meta_legendary",1,"orange",0,"orange_skill","Meta",22,0,3},
		{"modifier_terror_sunder_legendary",1,"orange",0,"orange_skill","Sunder",22,1,4},
	},

	npc_dota_hero_bristleback = {
		{"modifier_bristle_goo_max",1,"blue",3,"blue_skill","Goo",25,1,"Goo_1",0},
		{"modifier_bristle_goo_proc",1,"blue",3,"blue_skill","Goo",25,1,"Goo_2",1},
		{"modifier_bristle_goo_ground",1,"blue",3,"blue_skill","Goo",2,1,"Goo_3",1},
	
		{"modifier_bristle_spray_damage",1,"blue",3,"blue_skill","Spray",25,2,"Spray_1",0},
		{"modifier_bristle_spray_max",1,"blue",3,"blue_skill","Spray",25,2,"Spray_2",1},
		{"modifier_bristle_spray_heal",1,"blue",3,"blue_skill","Spray",22,2,"Spray_3",0},
	
		{"modifier_bristle_back_spray",1,"blue",3,"blue_skill","Back",25,3,"Back_1",0},
		{"modifier_bristle_back_return",1,"blue",3,"blue_skill","Back",25,3,"Back_2",1},
		{"modifier_bristle_back_heal",1,"blue",3,"blue_skill","Back",22,3,"Back_3",0},
	
		{"modifier_bristle_warpath_damage",1,"blue",3,"blue_skill","Warpath",22,4,"Warpath_5",0},
		{"modifier_bristle_warpath_resist",1,"blue",3,"blue_skill","Warpath",25,4,"Warpath_1",0},
		{"modifier_bristle_warpath_pierce",1,"blue",3,"blue_skill","Warpath",22,4,"Warpath_3",1},

		{"modifier_bristle_goo_damage",1,"purple",2,"purple_skill","Goo",18,1,"Goo_4",1},
		{"modifier_bristle_goo_stack",1,"purple",1,"purple_skill","Goo",25,1,"Goo_5",1},
		{"modifier_bristle_goo_status",1,"purple",1,"purple_skill","Goo",18,1,"Goo_6",0},
	
		{"modifier_bristle_spray_double",1,"purple",2,"purple_skill","Spray",22,2,"Spray_4",1},
		{"modifier_bristle_spray_lowhp",1,"purple",1,"purple_skill","Spray",18,2,"Spray_5",0},
		{"modifier_bristle_spray_reduce",1,"purple",1,"purple_skill","Spray",22,2,"Spray_6",0},
	
		{"modifier_bristle_back_damage",1,"purple",2,"purple_skill","Back",22,3,"Back_4",1},
		{"modifier_bristle_back_reflect",1,"purple",1,"purple_skill","Back",22,3,"Back_5",1},
		{"modifier_bristle_back_ground",1,"purple",1,"purple_skill","Back",22,3,"Back_6",0},
	
		{"modifier_bristle_warpath_bash",1,"purple",2,"purple_skill","Warpath",22,4,"Warpath_4",1},
		{"modifier_bristle_warpath_max",1,"purple",1,"purple_skill","Warpath",18,4,"Warpath_2",0},
		{"modifier_bristle_warpath_lowhp",1,"purple",1,"purple_skill","Warpath",22,4,"Warpath_6",1},

		{"modifier_bristle_goo_legendary",1,"orange",0,"orange_skill","Goo",25,1,1},
		{"modifier_bristle_spray_legendary",1,"orange",0,"orange_skill","Spray",17,0,2},
		{"modifier_bristle_back_legendary",1,"orange",0,"orange_skill","Back",22,1,3},
		{"modifier_bristle_warpath_legendary",1,"orange",0,"orange_skill","Warpath",22,1,4},
	},

	npc_dota_hero_puck = {
		{"modifier_puck_orb_damage",1,"blue",3,"blue_skill","Orb",18,1,"Orb_1",0},
		{"modifier_puck_orb_cd",1,"blue",3,"blue_skill","Orb",25,1,"Orb_2",0},
		{"modifier_puck_orb_range",1,"blue",3,"blue_skill","Orb",18,1,"Orb_5",1},
	
		{"modifier_puck_rift_damage",1,"blue",3,"blue_skill","Rift",22,2,"Rift_1",0},
		{"modifier_puck_rift_cd",1,"blue",3,"blue_skill","Rift",18,2,"Rift_2",0},
		{"modifier_puck_rift_mana",1,"blue",3,"blue_skill","Rift",22,2,"Rift_3",1},
	
		{"modifier_puck_shift_regen",1,"blue",3,"blue_skill","Shift",22,3,"Shift_1",0},
		{"modifier_puck_shift_damage",1,"blue",3,"blue_skill","Shift",22,3,"Shift_2",0},
		{"modifier_puck_shift_lowhp",1,"blue",3,"blue_skill","Shift",22,3,"Shift_6",1},
	
		{"modifier_puck_coil_duration",1,"blue",3,"blue_skill","Coil",22,4,"Coil_1",0},
		{"modifier_puck_coil_cd",1,"blue",3,"blue_skill","Coil",18,4,"Coil_2",0},
		{"modifier_puck_coil_resist",1,"blue",3,"blue_skill","Coil",22,4,"Coil_3",0},
		
	
	
		{"modifier_puck_orb_distance",1,"purple",2,"purple_skill","Orb",18,1,"Coil_5",0},
		{"modifier_puck_orb_double",1,"purple",1,"purple_skill","Orb",25,1,"Orb_3",1},
		{"modifier_puck_orb_blind",1,"purple",1,"purple_skill","Orb",18,1,"Orb_6",1},
	
		{"modifier_puck_rift_tick",1,"purple",2,"purple_skill","Rift",22,2,"Rift_4",1},
		{"modifier_puck_rift_purge",1,"purple",1,"purple_skill","Rift",18,2,"Rift_5",1},
		{"modifier_puck_rift_range",1,"purple",1,"purple_skill","Rift",22,2,"Rift_6",1},
	
		{"modifier_puck_shift_attacks",1,"purple",2,"purple_skill","Shift",22,3,"Shift_4",0},
		{"modifier_puck_shift_resist",1,"purple",1,"purple_skill","Shift",22,3,"Shift_5",1},
		{"modifier_puck_shift_stun",1,"purple",1,"purple_skill","Shift",22,3,"Shift_3",1},
	
		{"modifier_puck_coil_magic",1,"purple",2,"purple_skill","Coil",22,4,"Coil_4",0},
		{"modifier_puck_coil_attacks",1,"purple",1,"purple_skill","Coil",18,4,"Orb_4",0},
		{"modifier_puck_coil_cooldowns",1,"purple",1,"purple_skill","Coil",22,4,"Coil_6",0},

		{"modifier_puck_orb_legendary",1,"orange",0,"orange_skill","Orb",25,1,1},
		{"modifier_puck_rift_legendary",1,"orange",0,"orange_skill","Rift",17,1,2},
		{"modifier_puck_shift_legendary",1,"orange",0,"orange_skill","Shift",22,1,3},
		{"modifier_puck_coil_legendary",1,"orange",0,"orange_skill","Coil",22,0,4},
	},

	npc_dota_hero_void_spirit = {
		{"modifier_void_remnant_1",1,"blue",3,"blue_skill","Remnant",18,1,"Remnant_1",0},
		{"modifier_void_remnant_2",1,"blue",3,"blue_skill","Remnant",25,1,"Remnant_2",0},
		{"modifier_void_remnant_3",1,"blue",3,"blue_skill","Remnant",18,1,"Remnant_3",0},
	
		{"modifier_void_astral_1",1,"blue",3,"blue_skill","Astral",22,2,"Astral_1",0},
		{"modifier_void_astral_2",1,"blue",3,"blue_skill","Astral",18,2,"Astral_2",0},
		{"modifier_void_astral_3",1,"blue",3,"blue_skill","Astral",22,2,"Astral_3",0},
	
		{"modifier_void_pulse_1",1,"blue",3,"blue_skill","Pulse",22,3,"Pulse_1",0},
		{"modifier_void_pulse_2",1,"blue",3,"blue_skill","Pulse",22,3,"Pulse_2",0},
		{"modifier_void_pulse_3",1,"blue",3,"blue_skill","Pulse",22,3,"Pulse_4",0},
	
		{"modifier_void_step_1",1,"blue",3,"blue_skill","Step",22,4,"Step_1",0},
		{"modifier_void_step_2",1,"blue",3,"blue_skill","Step",18,4,"Step_2",0},
		{"modifier_void_step_3",1,"blue",3,"blue_skill","Step",22,4,"Step_3",0},

		{"modifier_void_remnant_4",1,"purple",2,"purple_skill","Remnant",18,1,"Remnant_6",1},
		{"modifier_void_remnant_5",1,"purple",1,"purple_skill","Remnant",25,1,"Remnant_5",1},
		{"modifier_void_remnant_6",1,"purple",1,"purple_skill","Remnant",18,1,"Remnant_4",0},
	
		{"modifier_void_astral_4",1,"purple",2,"purple_skill","Astral",22,2,"Astral_4",1},
		{"modifier_void_astral_5",1,"purple",1,"purple_skill","Astral",18,2,"Astral_5",1},
		{"modifier_void_astral_6",1,"purple",1,"purple_skill","Astral",22,2,"Astral_6",1},
	
		{"modifier_void_pulse_4",1,"purple",2,"purple_skill","Pulse",22,3,"Pulse_3",1},
		{"modifier_void_pulse_5",1,"purple",1,"purple_skill","Pulse",22,3,"Pulse_5",1},
		{"modifier_void_pulse_6",1,"purple",1,"purple_skill","Pulse",22,3,"Pulse_6",1},
	
		{"modifier_void_step_4",1,"purple",2,"purple_skill","Step",22,4,"Step_5",1},
		{"modifier_void_step_5",1,"purple",1,"purple_skill","Step",18,4,"Step_4",1},
		{"modifier_void_step_6",1,"purple",1,"purple_skill","Step",22,4,"Step_6",1},

		{"modifier_void_remnant_legendary",1,"orange",0,"orange_skill","Remnant",25,1,1},
		{"modifier_void_astral_legendary",1,"orange",0,"orange_skill","Astral",17,1,2},
		{"modifier_void_pulse_legendary",1,"orange",0,"orange_skill","Pulse",22,1,3},
		{"modifier_void_step_legendary",1,"orange",0,"orange_skill","Step",22,1,4},
	},

	npc_dota_hero_ember_spirit = {
		{"modifier_ember_chain_1",1,"blue",3,"blue_skill","Chain",18,1,"Chain_1",0},
		{"modifier_ember_chain_2",1,"blue",3,"blue_skill","Chain",25,1,"Chain_2",0},
		{"modifier_ember_chain_3",1,"blue",3,"blue_skill","Chain",18,1,"Chain_3",1},
	
		{"modifier_ember_fist_1",1,"blue",3,"blue_skill","Fist",22,2,"Fist_1",0},
		{"modifier_ember_fist_2",1,"blue",3,"blue_skill","Fist",18,2,"Fist_4",0},
		{"modifier_ember_fist_3",1,"blue",3,"blue_skill","Fist",22,2,"Fist_3",0},
	
		{"modifier_ember_guard_1",1,"blue",3,"blue_skill","Guard",22,3,"Guard_1",0},
		{"modifier_ember_guard_2",1,"blue",3,"blue_skill","Guard",22,3,"Guard_2",0},
		{"modifier_ember_guard_3",1,"blue",3,"blue_skill","Guard",22,3,"Guard_3",0},
	
		{"modifier_ember_remnant_1",1,"blue",3,"blue_skill","FireRemnant",22,4,"FireRemnant_1",0},
		{"modifier_ember_remnant_2",1,"blue",3,"blue_skill","FireRemnant",18,4,"FireRemnant_5",0},
		{"modifier_ember_remnant_3",1,"blue",3,"blue_skill","FireRemnant",22,4,"FireRemnant_3",1},

		{"modifier_ember_chain_4",1,"purple",2,"purple_skill","Chain",18,1,"Chain_4",0},
		{"modifier_ember_chain_5",1,"purple",1,"purple_skill","Chain",25,1,"Chain_5",0},
		{"modifier_ember_chain_6",1,"purple",1,"purple_skill","Chain",18,1,"Chain_6",0},
	
		{"modifier_ember_fist_4",1,"purple",2,"purple_skill","Fist",22,2,"Fist_5",0},
		{"modifier_ember_fist_5",1,"purple",1,"purple_skill","Fist",18,2,"Fist_2",0},
		{"modifier_ember_fist_6",1,"purple",1,"purple_skill","Fist",22,2,"Fist_6",0},
	
		{"modifier_ember_guard_4",1,"purple",2,"purple_skill","Guard",22,3,"Guard_4",1},
		{"modifier_ember_guard_5",1,"purple",1,"purple_skill","Guard",22,3,"Guard_5",1},
		{"modifier_ember_guard_6",1,"purple",1,"purple_skill","Guard",22,3,"Guard_6",1},
	
		{"modifier_ember_remnant_4",1,"purple",2,"purple_skill","FireRemnant",22,4,"FireRemnant_4",1},
		{"modifier_ember_remnant_5",1,"purple",1,"purple_skill","FireRemnant",18,4,"FireRemnant_2",1},
		{"modifier_ember_remnant_6",1,"purple",1,"purple_skill","FireRemnant",22,4,"FireRemnant_6",0},

		{"modifier_ember_chain_legendary",1,"orange",0,"orange_skill","Chain",25,0,1},
		{"modifier_ember_fist_legendary",1,"orange",0,"orange_skill","Fist",17,0,2},
		{"modifier_ember_guard_legendary",1,"orange",0,"orange_skill","Guard",22,0,3},
		{"modifier_ember_remnant_legendary",1,"orange",0,"orange_skill","FireRemnant",22,1,4},
	},

	npc_dota_hero_pudge = {
		{"modifier_pudge_hook_1",1,"blue",3,"blue_skill","hook",18,1,"hook_1",0},
		{"modifier_pudge_hook_2",1,"blue",3,"blue_skill","hook",25,1,"hook_2",0},
		{"modifier_pudge_hook_3",1,"blue",3,"blue_skill","hook",18,1,"hook_3",1},
	
		{"modifier_pudge_rot_1",1,"blue",3,"blue_skill","rot",22,2,"rot_1",0},
		{"modifier_pudge_rot_2",1,"blue",3,"blue_skill","rot",18,2,"rot_2",0},
		{"modifier_pudge_rot_3",1,"blue",3,"blue_skill","rot",22,2,"rot_3",0},
	
		{"modifier_pudge_flesh_1",1,"blue",3,"blue_skill","flesh",22,3,"flesh_1",1},
		{"modifier_pudge_flesh_2",1,"blue",3,"blue_skill","flesh",22,3,"flesh_2",0},
		{"modifier_pudge_flesh_3",1,"blue",3,"blue_skill","flesh",22,3,"flesh_3",0},
	
		{"modifier_pudge_dismember_1",1,"blue",3,"blue_skill","dismember",22,4,"dismember_3",0},
		{"modifier_pudge_dismember_2",1,"blue",3,"blue_skill","dismember",18,4,"dismember_2",0},
		{"modifier_pudge_dismember_3",1,"blue",3,"blue_skill","dismember",22,4,"dismember_1",0},

		{"modifier_pudge_hook_4",1,"purple",2,"purple_skill","hook",18,1,"hook_4",0},
		{"modifier_pudge_hook_5",1,"purple",1,"purple_skill","hook",25,1,"hook_5",0},
		{"modifier_pudge_hook_6",1,"purple",1,"purple_skill","hook",18,1,"hook_6",1},
	
		{"modifier_pudge_rot_4",1,"purple",2,"purple_skill","rot",22,2,"rot_4",0},
		{"modifier_pudge_rot_5",1,"purple",1,"purple_skill","rot",18,2,"rot_5",1},
		{"modifier_pudge_rot_6",1,"purple",1,"purple_skill","rot",22,2,"rot_6",0},
	
		{"modifier_pudge_flesh_4",1,"purple",2,"purple_skill","flesh",22,3,"flesh_4",1},
		{"modifier_pudge_flesh_5",1,"purple",1,"purple_skill","flesh",22,3,"flesh_5",0},
		{"modifier_pudge_flesh_6",1,"purple",1,"purple_skill","flesh",22,3,"flesh_6",0},
	
		{"modifier_pudge_dismember_4",1,"purple",2,"purple_skill","dismember",22,4,"dismember_4",0},
		{"modifier_pudge_dismember_5",1,"purple",1,"purple_skill","dismember",18,4,"dismember_6",1},
		{"modifier_pudge_dismember_6",1,"purple",1,"purple_skill","dismember",22,4,"dismember_5",1},

		{"modifier_pudge_hook_legendary",1,"orange",0,"orange_skill","hook",25,1,1},
		{"modifier_pudge_rot_legendary",1,"orange",0,"orange_skill","rot",17,1,2},
		{"modifier_pudge_flesh_legendary",1,"orange",0,"orange_skill","flesh",22,1,3},
		{"modifier_pudge_dismember_legendary",1,"orange",0,"orange_skill","dismember",22,1,4},
	},

	npc_dota_hero_hoodwink = {
		{"modifier_hoodwink_acorn_1",1,"blue",3,"blue_skill","acorn",18,1,"acorn_1",0},
		{"modifier_hoodwink_acorn_2",1,"blue",3,"blue_skill","acorn",25,1,"acorn_2",1},
		{"modifier_hoodwink_acorn_3",1,"blue",3,"blue_skill","acorn",18,1,"acorn_4",1},
	
		{"modifier_hoodwink_bush_1",1,"blue",3,"blue_skill","bush",22,2,"bush_1",0},
		{"modifier_hoodwink_bush_2",1,"blue",3,"blue_skill","bush",18,2,"bush_2",0},
		{"modifier_hoodwink_bush_3",1,"blue",3,"blue_skill","bush",22,2,"bush_3",1},
	
		{"modifier_hoodwink_scurry_1",1,"blue",3,"blue_skill","scurry",22,3,"scurry_1",0},
		{"modifier_hoodwink_scurry_2",1,"blue",3,"blue_skill","scurry",22,3,"scurry_2",0},
		{"modifier_hoodwink_scurry_3",1,"blue",3,"blue_skill","scurry",22,3,"scurry_3",0},
	
		{"modifier_hoodwink_sharp_1",1,"blue",3,"blue_skill","sharp",22,4,"sharp_3",1},
		{"modifier_hoodwink_sharp_2",1,"blue",3,"blue_skill","sharp",18,4,"sharp_2",0},
		{"modifier_hoodwink_sharp_3",1,"blue",3,"blue_skill","sharp",22,4,"sharp_1",1},

		{"modifier_hoodwink_acorn_4",1,"purple",2,"purple_skill","acorn",18,1,"acorn_3",0},
		{"modifier_hoodwink_acorn_5",1,"purple",1,"purple_skill","acorn",25,1,"acorn_5",1},
		{"modifier_hoodwink_acorn_6",1,"purple",1,"purple_skill","acorn",18,1,"acorn_6",0},
	
		{"modifier_hoodwink_bush_4",1,"purple",2,"purple_skill","bush",22,2,"bush_4",1},
		{"modifier_hoodwink_bush_5",1,"purple",1,"purple_skill","bush",18,2,"bush_5",1},
		{"modifier_hoodwink_bush_6",1,"purple",1,"purple_skill","bush",22,2,"bush_6",1},
	
		{"modifier_hoodwink_scurry_4",1,"purple",2,"purple_skill","scurry",22,3,"scurry_4",1},
		{"modifier_hoodwink_scurry_5",1,"purple",1,"purple_skill","scurry",22,3,"scurry_5",0},
		{"modifier_hoodwink_scurry_6",1,"purple",1,"purple_skill","scurry",22,3,"scurry_6",0},
	
		{"modifier_hoodwink_sharp_4",1,"purple",2,"purple_skill","sharp",22,4,"sharp_6",1},
		{"modifier_hoodwink_sharp_5",1,"purple",1,"purple_skill","sharp",18,4,"sharp_4",1},
		{"modifier_hoodwink_sharp_6",1,"purple",1,"purple_skill","sharp",22,4,"sharp_5",0},

		{"modifier_hoodwink_acorn_legendary",1,"orange",0,"orange_skill","acorn",25,1,1},
		{"modifier_hoodwink_bush_legendary",1,"orange",0,"orange_skill","bush",17,1,2},
		{"modifier_hoodwink_scurry_legendary",1,"orange",0,"orange_skill","scurry",22,1,3},
		{"modifier_hoodwink_sharp_legendary",1,"orange",0,"orange_skill","sharp",22,0,4},
		
	},

	npc_dota_hero_skeleton_king = {
		{"modifier_skeleton_blast_1",1,"blue",3,"blue_skill","blast",18,1,"blast_1",0},
		{"modifier_skeleton_blast_2",1,"blue",3,"blue_skill","blast",25,1,"blast_2",0},
		{"modifier_skeleton_blast_3",1,"blue",3,"blue_skill","blast",18,1,"blast_3",0},
	
		{"modifier_skeleton_vampiric_1",1,"blue",3,"blue_skill","vampiric",22,2,"vampiric_1",0},
		{"modifier_skeleton_vampiric_2",1,"blue",3,"blue_skill","vampiric",18,2,"vampiric_2",0},
		{"modifier_skeleton_vampiric_3",1,"blue",3,"blue_skill","vampiric",22,2,"vampiric_3",0},
	
		{"modifier_skeleton_strike_1",1,"blue",3,"blue_skill","strike",22,3,"strike_1",0},
		{"modifier_skeleton_strike_2",1,"blue",3,"blue_skill","strike",22,3,"strike_2",1},
		{"modifier_skeleton_strike_3",1,"blue",3,"blue_skill","strike",22,3,"strike_3",0},
	
		{"modifier_skeleton_reincarnation_1",1,"blue",3,"blue_skill","reincarnation",22,4,"reincarnation_1",0},
		{"modifier_skeleton_reincarnation_2",1,"blue",3,"blue_skill","reincarnation",18,4,"reincarnation_2",0},
		{"modifier_skeleton_reincarnation_3",1,"blue",3,"blue_skill","reincarnation",22,4,"reincarnation_3",0},

		{"modifier_skeleton_blast_4",1,"purple",2,"purple_skill","blast",18,1,"blast_4",1},
		{"modifier_skeleton_blast_5",1,"purple",1,"purple_skill","blast",25,1,"blast_5",0},
		{"modifier_skeleton_blast_6",1,"purple",1,"purple_skill","blast",18,1,"blast_6",1},
	
		{"modifier_skeleton_vampiric_4",1,"purple",2,"purple_skill","vampiric",22,2,"vampiric_4",0},
		{"modifier_skeleton_vampiric_5",1,"purple",1,"purple_skill","vampiric",18,2,"vampiric_5",0},
		{"modifier_skeleton_vampiric_6",1,"purple",1,"purple_skill","vampiric",22,2,"vampiric_6",0},
	
		{"modifier_skeleton_strike_4",1,"purple",2,"purple_skill","strike",22,3,"strike_4",1},
		{"modifier_skeleton_strike_5",1,"purple",1,"purple_skill","strike",22,3,"strike_5",1},
		{"modifier_skeleton_strike_6",1,"purple",1,"purple_skill","strike",22,3,"strike_6",1},
	
		{"modifier_skeleton_reincarnation_4",1,"purple",2,"purple_skill","reincarnation",22,4,"reincarnation_6",0},
		{"modifier_skeleton_reincarnation_5",1,"purple",1,"purple_skill","reincarnation",18,4,"reincarnation_5",0},
		{"modifier_skeleton_reincarnation_6",1,"purple",1,"purple_skill","reincarnation",22,4,"reincarnation_4",0},

		{"modifier_skeleton_blast_legendary",1,"orange",0,"orange_skill","blast",25,1,1},
		{"modifier_skeleton_vampiric_legendary",1,"orange",0,"orange_skill","vampiric",17,0,2},
		{"modifier_skeleton_strike_legendary",1,"orange",0,"orange_skill","strike",22,1,3},
		{"modifier_skeleton_reincarnation_legendary",1,"orange",0,"orange_skill","reincarnation",22,0,4},
	},

	npc_dota_hero_lina = {
		{"modifier_lina_dragon_1",1,"blue",3,"blue_skill","dragon",18,1,"dragon_1",0},
		{"modifier_lina_dragon_2",1,"blue",3,"blue_skill","dragon",25,1,"dragon_2",1},
		{"modifier_lina_dragon_3",1,"blue",3,"blue_skill","dragon",18,1,"dragon_3",0},
	
		{"modifier_lina_array_1",1,"blue",3,"blue_skill","array",22,2,"array_1",1},
		{"modifier_lina_array_2",1,"blue",3,"blue_skill","array",18,2,"array_2",0},
		{"modifier_lina_array_3",1,"blue",3,"blue_skill","array",22,2,"array_3",0},
	
		{"modifier_lina_soul_1",1,"blue",3,"blue_skill","soul",22,3,"soul_1",0},
		{"modifier_lina_soul_2",1,"blue",3,"blue_skill","soul",22,3,"soul_2",0},
		{"modifier_lina_soul_3",1,"blue",3,"blue_skill","soul",22,3,"soul_3",0},
	
		{"modifier_lina_laguna_1",1,"blue",3,"blue_skill","laguna",22,4,"laguna_1",0},
		{"modifier_lina_laguna_2",1,"blue",3,"blue_skill","laguna",18,4,"laguna_2",0},
		{"modifier_lina_laguna_3",1,"blue",3,"blue_skill","laguna",22,4,"laguna_3",0},

		{"modifier_lina_dragon_4",1,"purple",2,"purple_skill","dragon",18,1,"dragon_4",1},
		{"modifier_lina_dragon_5",1,"purple",1,"purple_skill","dragon",25,1,"dragon_5",0},
		{"modifier_lina_dragon_6",1,"purple",1,"purple_skill","dragon",18,1,"dragon_6",1},
	
		{"modifier_lina_array_4",1,"purple",2,"purple_skill","array",22,2,"array_5",1},
		{"modifier_lina_array_5",1,"purple",1,"purple_skill","array",18,2,"array_4",1},
		{"modifier_lina_array_6",1,"purple",1,"purple_skill","array",22,2,"array_6",1},
	
		{"modifier_lina_soul_4",1,"purple",2,"purple_skill","soul",22,3,"soul_4",1},
		{"modifier_lina_soul_5",1,"purple",1,"purple_skill","soul",22,3,"soul_5",0},
		{"modifier_lina_soul_6",1,"purple",1,"purple_skill","soul",22,3,"soul_6",1},
	
		{"modifier_lina_laguna_4",1,"purple",2,"purple_skill","laguna",22,4,"laguna_4",0},
		{"modifier_lina_laguna_5",1,"purple",1,"purple_skill","laguna",18,4,"laguna_5",1},
		{"modifier_lina_laguna_6",1,"purple",1,"purple_skill","laguna",22,4,"laguna_6",1},

		{"modifier_lina_dragon_legendary",1,"orange",0,"orange_skill","dragon",25,1,1},
		{"modifier_lina_array_legendary",1,"orange",0,"orange_skill","array",17,1,2},
		{"modifier_lina_soul_legendary",1,"orange",0,"orange_skill","soul",22,1,3},
		{"modifier_lina_laguna_legendary",1,"orange",0,"orange_skill","laguna",22,1,4},
	},

	npc_dota_hero_troll_warlord = {
		{"modifier_troll_rage_1",1,"blue",3,"blue_skill","rage",18,1,"rage_1",0},
		{"modifier_troll_rage_2",1,"blue",3,"blue_skill","rage",25,1,"rage_2",0},
		{"modifier_troll_rage_3",1,"blue",3,"blue_skill","rage",18,1,"rage_3",0},
	
		{"modifier_troll_axes_1",1,"blue",3,"blue_skill","axes",22,2,"axes_1",0},
		{"modifier_troll_axes_2",1,"blue",3,"blue_skill","axes",18,2,"axes_2",0},
		{"modifier_troll_axes_3",1,"blue",3,"blue_skill","axes",22,2,"axes_3",0},
	
		{"modifier_troll_fervor_1",1,"blue",3,"blue_skill","fervor",22,3,"fervor_1",0},
		{"modifier_troll_fervor_2",1,"blue",3,"blue_skill","fervor",22,3,"fervor_2",0},
		{"modifier_troll_fervor_3",1,"blue",3,"blue_skill","fervor",22,3,"fervor_3",0},
	
		{"modifier_troll_trance_1",1,"blue",3,"blue_skill","trance",22,4,"trance_1",0},
		{"modifier_troll_trance_2",1,"blue",3,"blue_skill","trance",18,4,"trance_2",0},
		{"modifier_troll_trance_3",1,"blue",3,"blue_skill","trance",22,4,"trance_3",0},

		{"modifier_troll_rage_4",1,"purple",2,"purple_skill","rage",18,1,"rage_4",0},
		{"modifier_troll_rage_5",1,"purple",1,"purple_skill","rage",25,1,"rage_5",0},
		{"modifier_troll_rage_6",1,"purple",1,"purple_skill","rage",18,1,"rage_6",0},
	
		{"modifier_troll_axes_4",1,"purple",2,"purple_skill","axes",22,2,"axes_4",0},
		{"modifier_troll_axes_5",1,"purple",1,"purple_skill","axes",18,2,"axes_5",0},
		{"modifier_troll_axes_6",1,"purple",1,"purple_skill","axes",22,2,"axes_6",0},
	
		{"modifier_troll_fervor_4",1,"purple",2,"purple_skill","fervor",22,3,"fervor_4",1},
		{"modifier_troll_fervor_5",1,"purple",1,"purple_skill","fervor",22,3,"fervor_5",0},
		{"modifier_troll_fervor_6",1,"purple",1,"purple_skill","fervor",22,3,"fervor_6",0},
	
		{"modifier_troll_trance_4",1,"purple",2,"purple_skill","trance",22,4,"trance_4",0},
		{"modifier_troll_trance_5",1,"purple",1,"purple_skill","trance",18,4,"trance_5",0},
		{"modifier_troll_trance_6",1,"purple",1,"purple_skill","trance",22,4,"trance_6",1},

		{"modifier_troll_rage_legendary",1,"orange",0,"orange_skill","rage",25,1,1},
		{"modifier_troll_axes_legendary",1,"orange",0,"orange_skill","Axes",17,1,2},
		{"modifier_troll_fervor_legendary",1,"orange",0,"orange_skill","fervor",22,1,3},
		{"modifier_troll_trance_legendary",1,"orange",0,"orange_skill","trance",22,1,4},
	},

	npc_dota_hero_axe = {
		{"modifier_axe_call_1",1,"blue",3,"blue_skill","call",18,1,"call_1",1},
		{"modifier_axe_call_2",1,"blue",3,"blue_skill","call",25,1,"call_2",0},
		{"modifier_axe_call_3",1,"blue",3,"blue_skill","call",18,1,"call_3",1},
	
		{"modifier_axe_hunger_1",1,"blue",3,"blue_skill","hunger",22,2,"hunger_1",0},
		{"modifier_axe_hunger_2",1,"blue",3,"blue_skill","hunger",18,2,"hunger_2",0},
		{"modifier_axe_hunger_3",1,"blue",3,"blue_skill","hunger",22,2,"hunger_3",0},
	
		{"modifier_axe_helix_1",1,"blue",3,"blue_skill","helix",22,3,"helix_1",0},
		{"modifier_axe_helix_2",1,"blue",3,"blue_skill","helix",22,3,"helix_2",0},
		{"modifier_axe_helix_3",1,"blue",3,"blue_skill","helix",22,3,"helix_3",0},
	
		{"modifier_axe_culling_1",1,"blue",3,"blue_skill","culling",22,4,"culling_1",0},
		{"modifier_axe_culling_2",1,"blue",3,"blue_skill","culling",18,4,"culling_2",0},
		{"modifier_axe_culling_3",1,"blue",3,"blue_skill","culling",22,4,"culling_3",0},

		{"modifier_axe_call_4",1,"purple",2,"purple_skill","call",18,1,"call_4",1},
		{"modifier_axe_call_5",1,"purple",1,"purple_skill","call",25,1,"call_5",0},
		{"modifier_axe_call_6",1,"purple",1,"purple_skill","call",18,1,"call_6",1},
	
		{"modifier_axe_hunger_4",1,"purple",2,"purple_skill","hunger",22,2,"hunger_4",0},
		{"modifier_axe_hunger_5",1,"purple",1,"purple_skill","hunger",18,2,"hunger_5",1},
		{"modifier_axe_hunger_6",1,"purple",1,"purple_skill","hunger",22,2,"hunger_6",1},
	
		{"modifier_axe_helix_4",1,"purple",2,"purple_skill","helix",22,3,"helix_4",0},
		{"modifier_axe_helix_5",1,"purple",1,"purple_skill","helix",22,3,"helix_5",0},
		{"modifier_axe_helix_6",1,"purple",1,"purple_skill","helix",22,3,"helix_6",0},
	
		{"modifier_axe_culling_4",1,"purple",2,"purple_skill","culling",22,4,"culling_4",0},
		{"modifier_axe_culling_5",1,"purple",1,"purple_skill","culling",18,4,"culling_5",0},
		{"modifier_axe_culling_6",1,"purple",1,"purple_skill","culling",22,4,"culling_6",0},

		{"modifier_axe_call_legendary",1,"orange",0,"orange_skill","call",25,1,1},
		{"modifier_axe_hunger_legendary",1,"orange",0,"orange_skill","hunger",17,1,2},
		{"modifier_axe_helix_legendary",1,"orange",0,"orange_skill","helix",22,1,3},
		{"modifier_axe_culling_legendary",1,"orange",0,"orange_skill","culling",22,1,4},
	},

	npc_dota_hero_alchemist = {
		{"modifier_alchemist_spray_1",1,"blue",3,"blue_skill","acid",25,1,"unstable_4",0},
		{"modifier_alchemist_spray_2",1,"blue",3,"blue_skill","acid",25,1,"acid_2",0},
		{"modifier_alchemist_spray_3",1,"blue",3,"blue_skill","acid",25,1,"acid_3",0},
	
		{"modifier_alchemist_unstable_1",1,"blue",3,"blue_skill","unstable",25,2,"unstable_1",0},
		{"modifier_alchemist_unstable_2",1,"blue",3,"blue_skill","unstable",25,2,"unstable_2",1},
		{"modifier_alchemist_unstable_3",1,"blue",3,"blue_skill","unstable",25,2,"unstable_3",0},
	
		{"modifier_alchemist_greed_1",1,"blue",3,"blue_skill","greed",25,3,"greed_1",0},
		{"modifier_alchemist_greed_2",1,"blue",3,"blue_skill","greed",25,3,"greed_2",0},
		{"modifier_alchemist_greed_3",1,"blue",3,"blue_skill","greed",25,3,"greed_6",1},
	
		{"modifier_alchemist_rage_1",1,"blue",3,"blue_skill","chemical",25,4,"chemical_1",0},
		{"modifier_alchemist_rage_2",1,"blue",3,"blue_skill","chemical",25,4,"chemical_2",0},
		{"modifier_alchemist_rage_3",1,"blue",3,"blue_skill","chemical",25,4,"chemical_3",0},

		{"modifier_alchemist_spray_4",1,"purple",2,"purple_skill","acid",25,1,"acid_4",0},
		{"modifier_alchemist_spray_5",1,"purple",1,"purple_skill","acid",25,1,"acid_5",1},
		{"modifier_alchemist_spray_6",1,"purple",1,"purple_skill","acid",25,1,"acid_6",1},
	
		{"modifier_alchemist_unstable_4",1,"purple",2,"purple_skill","unstable",25,2,"acid_1",0},
		{"modifier_alchemist_unstable_5",1,"purple",1,"purple_skill","unstable",25,2,"unstable_5",1},
		{"modifier_alchemist_unstable_6",1,"purple",1,"purple_skill","unstable",25,2,"unstable_6",1},
	
		{"modifier_alchemist_greed_4",1,"purple",2,"purple_skill","greed",25,3,"greed_4",0},
		{"modifier_alchemist_greed_5",1,"purple",1,"purple_skill","greed",25,3,"greed_5",1},
		{"modifier_alchemist_greed_6",1,"purple",1,"purple_skill","greed",25,3,"greed_3",0},
	
		{"modifier_alchemist_rage_4",1,"purple",2,"purple_skill","chemical",25,4,"chemical_4",1},
		{"modifier_alchemist_rage_5",1,"purple",1,"purple_skill","chemical",25,4,"chemical_5",1},
		{"modifier_alchemist_rage_6",1,"purple",1,"purple_skill","chemical",25,4,"chemical_6",1},

		{"modifier_alchemist_spray_legendary",1,"orange",0,"orange_skill","acid",18,1,1},
		{"modifier_alchemist_unstable_legendary",1,"orange",0,"orange_skill","unstable",22,1,2},
		{"modifier_alchemist_greed_legendary",1,"orange",0,"orange_skill","greed",20,1,3},
		{"modifier_alchemist_rage_legendary",1,"orange",0,"orange_skill","chemical",19,1,4},
	},

	npc_dota_hero_ogre_magi = {
		{"modifier_ogremagi_blast_1",1,"blue",3,"blue_skill","fireblast",25,1,"fireblast_1",0},
		{"modifier_ogremagi_blast_2",1,"blue",3,"blue_skill","fireblast",25,1,"fireblast_2",1},
		{"modifier_ogremagi_blast_3",1,"blue",3,"blue_skill","fireblast",25,1,"fireblast_3",0},
	
		{"modifier_ogremagi_ignite_1",1,"blue",3,"blue_skill","ignite",25,2,"ignite_1",0},
		{"modifier_ogremagi_ignite_2",1,"blue",3,"blue_skill","ignite",25,2,"ignite_2",0},
		{"modifier_ogremagi_ignite_3",1,"blue",3,"blue_skill","ignite",25,2,"ignite_3",1},
	
		{"modifier_ogremagi_bloodlust_1",1,"blue",3,"blue_skill","bloodlust",25,3,"bloodlust_1",0},
		{"modifier_ogremagi_bloodlust_2",1,"blue",3,"blue_skill","bloodlust",25,3,"bloodlust_2",0},
		{"modifier_ogremagi_bloodlust_3",1,"blue",3,"blue_skill","bloodlust",25,3,"bloodlust_3",0},
	
		{"modifier_ogremagi_multi_1",1,"blue",3,"blue_skill","multicast",25,4,"multicast_1",0},
		{"modifier_ogremagi_multi_2",1,"blue",3,"blue_skill","multicast",25,4,"multicast_2",0},
		{"modifier_ogremagi_multi_3",1,"blue",3,"blue_skill","multicast",25,4,"multicast_3",1},

		{"modifier_ogremagi_blast_4",1,"purple",2,"purple_skill","fireblast",25,1,"fireblast_4",1},
		{"modifier_ogremagi_blast_5",1,"purple",1,"purple_skill","fireblast",25,1,"fireblast_5",0},
		{"modifier_ogremagi_blast_6",1,"purple",1,"purple_skill","fireblast",25,1,"fireblast_6",1},
	
		{"modifier_ogremagi_ignite_4",1,"purple",2,"purple_skill","ignite",25,2,"ignite_4",0},
		{"modifier_ogremagi_ignite_5",1,"purple",1,"purple_skill","ignite",25,2,"ignite_5",1},
		{"modifier_ogremagi_ignite_6",1,"purple",1,"purple_skill","ignite",25,2,"ignite_6",1},
	
		{"modifier_ogremagi_bloodlust_4",1,"purple",2,"purple_skill","bloodlust",25,3,"bloodlust_4",1},
		{"modifier_ogremagi_bloodlust_5",1,"purple",1,"purple_skill","bloodlust",25,3,"bloodlust_5",1},
		{"modifier_ogremagi_bloodlust_6",1,"purple",1,"purple_skill","bloodlust",25,3,"bloodlust_6",1},
	
		{"modifier_ogremagi_multi_4",1,"purple",2,"purple_skill","multicast",25,4,"multicast_4",1},
		{"modifier_ogremagi_multi_5",1,"purple",1,"purple_skill","multicast",25,4,"multicast_5",1},
		{"modifier_ogremagi_multi_6",1,"purple",1,"purple_skill","multicast",25,4,"multicast_6",0},

		{"modifier_ogremagi_blast_7",1,"orange",0,"orange_skill","fireblast",18,1,1},
		{"modifier_ogremagi_ignite_7",1,"orange",0,"orange_skill","ignite",22,1,2},
		{"modifier_ogremagi_bloodlust_7",1,"orange",0,"orange_skill","bloodlust",20,0,3},
		{"modifier_ogremagi_multi_7",1,"orange",0,"orange_skill","multicast",19,1,4},
	},



	npc_dota_hero_antimage = {
		{"modifier_antimage_break_1",1,"blue",3,"blue_skill","manabreak",25,1,"manabreak_1",0},
		{"modifier_antimage_break_2",1,"blue",3,"blue_skill","manabreak",25,1,"manabreak_2",1},
		{"modifier_antimage_break_3",1,"blue",3,"blue_skill","manabreak",25,1,"manabreak_3",0},
	
		{"modifier_antimage_blink_1",1,"blue",3,"blue_skill","antimage_blink",25,2,"antimage_blink_1",1},
		{"modifier_antimage_blink_2",1,"blue",3,"blue_skill","antimage_blink",25,2,"antimage_blink_2",0},
		{"modifier_antimage_blink_3",1,"blue",3,"blue_skill","antimage_blink",25,2,"antimage_blink_3",0},
	
		{"modifier_antimage_counter_1",1,"blue",3,"blue_skill","counterspell",25,3,"counterspell_1",0},
		{"modifier_antimage_counter_2",1,"blue",3,"blue_skill","counterspell",25,3,"counterspell_2",1},
		{"modifier_antimage_counter_3",1,"blue",3,"blue_skill","counterspell",25,3,"counterspell_3",0},
	
		{"modifier_antimage_void_1",1,"blue",3,"blue_skill","manavoid",25,4,"manavoid_1",0},
		{"modifier_antimage_void_2",1,"blue",3,"blue_skill","manavoid",25,4,"manavoid_2",0},
		{"modifier_antimage_void_3",1,"blue",3,"blue_skill","manavoid",25,4,"manavoid_3",0},

		{"modifier_antimage_break_4",1,"purple",2,"purple_skill","manabreak",25,1,"manabreak_4",1},
		{"modifier_antimage_break_5",1,"purple",1,"purple_skill","manabreak",25,1,"manabreak_5",1},
		{"modifier_antimage_break_6",1,"purple",1,"purple_skill","manabreak",25,1,"manabreak_6",0},
	
		{"modifier_antimage_blink_4",1,"purple",2,"purple_skill","antimage_blink",25,2,"antimage_blink_6",1},
		{"modifier_antimage_blink_5",1,"purple",1,"purple_skill","antimage_blink",25,2,"antimage_blink_5",1},
		{"modifier_antimage_blink_6",1,"purple",1,"purple_skill","antimage_blink",25,2,"antimage_blink_4",1},

		{"modifier_antimage_counter_4",1,"purple",2,"purple_skill","counterspell",25,3,"counterspell_4",1},
		{"modifier_antimage_counter_5",1,"purple",1,"purple_skill","counterspell",25,3,"counterspell_5",1},
		{"modifier_antimage_counter_6",1,"purple",1,"purple_skill","counterspell",25,3,"counterspell_6",1},
	
		{"modifier_antimage_void_4",1,"purple",2,"purple_skill","manavoid",25,4,"manavoid_4",1},
		{"modifier_antimage_void_5",1,"purple",1,"purple_skill","manavoid",25,4,"manavoid_5",1},
		{"modifier_antimage_void_6",1,"purple",1,"purple_skill","manavoid",25,4,"manavoid_6",1},

		{"modifier_antimage_break_7",1,"orange",0,"orange_skill","manabreak",18,1,1},
		{"modifier_antimage_blink_7",1,"orange",0,"orange_skill","antimage_blink",22,1,2},
		{"modifier_antimage_counter_7",1,"orange",0,"orange_skill","counterspell",20,1,3},
		{"modifier_antimage_void_7",1,"orange",0,"orange_skill","manavoid",19,1,4},
	},

	npc_dota_hero_primal_beast = {
		{"modifier_primal_beast_onslaught_1",1,"blue",3,"blue_skill","onslaught",25,1,"onslaught_1",0},
		{"modifier_primal_beast_onslaught_2",1,"blue",3,"blue_skill","onslaught",25,1,"onslaught_4",0},
		{"modifier_primal_beast_onslaught_3",1,"blue",3,"blue_skill","onslaught",25,1,"onslaught_5",0},
	
		{"modifier_primal_beast_trample_1",1,"blue",3,"blue_skill","trample",25,2,"trample_1",0},
		{"modifier_primal_beast_trample_2",1,"blue",3,"blue_skill","trample",25,2,"trample_2",1},
		{"modifier_primal_beast_trample_3",1,"blue",3,"blue_skill","trample",25,2,"trample_3",0},
	
		{"modifier_primal_beast_uproar_1",1,"blue",3,"blue_skill","uproar",25,3,"uproar_1",0},
		{"modifier_primal_beast_uproar_2",1,"blue",3,"blue_skill","uproar",25,3,"uproar_2",1},
		{"modifier_primal_beast_uproar_3",1,"blue",3,"blue_skill","uproar",25,3,"uproar_3",0},
	
		{"modifier_primal_beast_pulverize_1",1,"blue",3,"blue_skill","pulverize",25,4,"pulverize_1",0},
		{"modifier_primal_beast_pulverize_2",1,"blue",3,"blue_skill","pulverize",25,4,"pulverize_2",1},
		{"modifier_primal_beast_pulverize_3",1,"blue",3,"blue_skill","pulverize",25,4,"pulverize_3",0},

		{"modifier_primal_beast_onslaught_4",1,"purple",2,"purple_skill","onslaught",25,1,"onslaught_2",0},
		{"modifier_primal_beast_onslaught_5",1,"purple",1,"purple_skill","onslaught",25,1,"onslaught_6",1},
		{"modifier_primal_beast_onslaught_6",1,"purple",1,"purple_skill","onslaught",25,1,"onslaught_3",0},
	
		{"modifier_primal_beast_trample_4",1,"purple",2,"purple_skill","trample",25,2,"trample_4",0},
		{"modifier_primal_beast_trample_5",1,"purple",1,"purple_skill","trample",25,2,"trample_5",1},
		{"modifier_primal_beast_trample_6",1,"purple",1,"purple_skill","trample",25,2,"trample_6",1},
	
		{"modifier_primal_beast_uproar_4",1,"purple",2,"purple_skill","uproar",25,3,"uproar_4",1},
		{"modifier_primal_beast_uproar_5",1,"purple",1,"purple_skill","uproar",25,3,"uproar_5",1},
		{"modifier_primal_beast_uproar_6",1,"purple",1,"purple_skill","uproar",25,3,"uproar_6",0},
	
		{"modifier_primal_beast_pulverize_4",1,"purple",2,"purple_skill","pulverize",25,4,"pulverize_4",0},
		{"modifier_primal_beast_pulverize_5",1,"purple",1,"purple_skill","pulverize",25,4,"pulverize_5",1},
		{"modifier_primal_beast_pulverize_6",1,"purple",1,"purple_skill","pulverize",25,4,"pulverize_6",0},

		{"modifier_primal_beast_onslaught_7",1,"orange",0,"orange_skill","onslaught",18,0,1},
		{"modifier_primal_beast_trample_7",1,"orange",0,"orange_skill","trample",22,1,2},
		{"modifier_primal_beast_uproar_7",1,"orange",0,"orange_skill","uproar",20,1,3},
		{"modifier_primal_beast_pulverize_7",1,"orange",0,"orange_skill","pulverize",19,1,4},
	},



	npc_dota_hero_marci = {
		{"modifier_marci_dispose_1",1,"blue",3,"blue_skill","dispose",25,1,"dispose_1",0},
		{"modifier_marci_dispose_2",1,"blue",3,"blue_skill","dispose",25,1,"dispose_2",1},
		{"modifier_marci_dispose_3",1,"blue",3,"blue_skill","dispose",25,1,"dispose_5",0},
	
		{"modifier_marci_rebound_1",1,"blue",3,"blue_skill","rebound",25,2,"rebound_1",1},
		{"modifier_marci_rebound_2",1,"blue",3,"blue_skill","rebound",25,2,"rebound_2",0},
		{"modifier_marci_rebound_3",1,"blue",3,"blue_skill","rebound",25,2,"rebound_3",1},
	
		{"modifier_marci_sidekick_1",1,"blue",3,"blue_skill","sidekick",25,3,"sidekick_1",1},
		{"modifier_marci_sidekick_2",1,"blue",3,"blue_skill","sidekick",25,3,"sidekick_2",1},
		{"modifier_marci_sidekick_3",1,"blue",3,"blue_skill","sidekick",25,3,"sidekick_3",0},
	
		{"modifier_marci_unleash_1",1,"blue",3,"blue_skill","unleash",25,4,"unleash_3",0},
		{"modifier_marci_unleash_2",1,"blue",3,"blue_skill","unleash",25,4,"unleash_2",1},
		{"modifier_marci_unleash_3",1,"blue",3,"blue_skill","unleash",25,4,"unleash_4",0},

		{"modifier_marci_dispose_4",1,"purple",2,"purple_skill","dispose",25,1,"dispose_3",1},
		{"modifier_marci_dispose_5",1,"purple",1,"purple_skill","dispose",25,1,"dispose_4",0},
		{"modifier_marci_dispose_6",1,"purple",1,"purple_skill","dispose",25,1,"dispose_6",1},
	
		{"modifier_marci_rebound_4",1,"purple",2,"purple_skill","rebound",25,2,"rebound_4",1},
		{"modifier_marci_rebound_5",1,"purple",1,"purple_skill","rebound",25,2,"rebound_5",1},
		{"modifier_marci_rebound_6",1,"purple",1,"purple_skill","rebound",25,2,"rebound_6",1},
	
		{"modifier_marci_sidekick_4",1,"purple",2,"purple_skill","sidekick",25,3,"sidekick_4",0},
		{"modifier_marci_sidekick_5",1,"purple",1,"purple_skill","sidekick",25,3,"sidekick_5",1},
		{"modifier_marci_sidekick_6",1,"purple",1,"purple_skill","sidekick",25,3,"sidekick_6",1},
	
		{"modifier_marci_unleash_4",1,"purple",2,"purple_skill","unleash",25,4,"unleash_1",1},
		{"modifier_marci_unleash_5",1,"purple",1,"purple_skill","unleash",25,4,"unleash_5",0},
		{"modifier_marci_unleash_6",1,"purple",1,"purple_skill","unleash",25,4,"unleash_6",0},

		{"modifier_marci_dispose_7",1,"orange",0,"orange_skill","dispose",18,1,1},
		{"modifier_marci_rebound_7",1,"orange",0,"orange_skill","rebound",22,1,2},
		{"modifier_marci_sidekick_7",1,"orange",0,"orange_skill","sidekick",20,1,3},
		{"modifier_marci_unleash_7",1,"orange",0,"orange_skill","unleash",19,1,4},
	},

	npc_dota_hero_templar_assassin = {
		{"modifier_templar_assassin_refraction_1",1,"blue",3,"blue_skill","refraction",25,1,"refraction_1",0},
		{"modifier_templar_assassin_refraction_2",1,"blue",3,"blue_skill","refraction",25,1,"refraction_2",1},
		{"modifier_templar_assassin_refraction_3",1,"blue",3,"blue_skill","refraction",25,1,"refraction_3",0},
	
		{"modifier_templar_assassin_meld_1",1,"blue",3,"blue_skill","meld",25,2,"meld_1",0},
		{"modifier_templar_assassin_meld_2",1,"blue",3,"blue_skill","meld",25,2,"meld_2",1},
		{"modifier_templar_assassin_meld_3",1,"blue",3,"blue_skill","meld",25,2,"meld_3",1},
	
		{"modifier_templar_assassin_psiblades_1",1,"blue",3,"blue_skill","psiblades",25,3,"psiblades_1",0},
		{"modifier_templar_assassin_psiblades_2",1,"blue",3,"blue_skill","psiblades",25,3,"psiblades_2",0},
		{"modifier_templar_assassin_psiblades_3",1,"blue",3,"blue_skill","psiblades",25,3,"psiblades_3",0},
	
		{"modifier_templar_assassin_psionic_1",1,"blue",3,"blue_skill","psionic",25,4,"psionic_1",0},
		{"modifier_templar_assassin_psionic_2",1,"blue",3,"blue_skill","psionic",25,4,"psionic_2",1},
		{"modifier_templar_assassin_psionic_3",1,"blue",3,"blue_skill","psionic",25,4,"psionic_3",1},

		{"modifier_templar_assassin_refraction_4",1,"purple",2,"purple_skill","refraction",25,1,"refraction_4",0},
		{"modifier_templar_assassin_refraction_5",1,"purple",1,"purple_skill","refraction",25,1,"refraction_5",1},
		{"modifier_templar_assassin_refraction_6",1,"purple",1,"purple_skill","refraction",25,1,"refraction_6",1},
	
		{"modifier_templar_assassin_meld_4",1,"purple",2,"purple_skill","meld",25,2,"meld_4",0},
		{"modifier_templar_assassin_meld_5",1,"purple",1,"purple_skill","meld",25,2,"meld_5",0},
		{"modifier_templar_assassin_meld_6",1,"purple",1,"purple_skill","meld",25,2,"meld_6",0},
	
		{"modifier_templar_assassin_psiblades_4",1,"purple",2,"purple_skill","psiblades",25,3,"psiblades_4",1},
		{"modifier_templar_assassin_psiblades_5",1,"purple",1,"purple_skill","psiblades",25,3,"psiblades_5",1},
		{"modifier_templar_assassin_psiblades_6",1,"purple",1,"purple_skill","psiblades",25,3,"psiblades_6",1},
	
		{"modifier_templar_assassin_psionic_4",1,"purple",2,"purple_skill","psionic",25,4,"psionic_4",1},
		{"modifier_templar_assassin_psionic_5",1,"purple",1,"purple_skill","psionic",25,4,"psionic_5",0},
		{"modifier_templar_assassin_psionic_6",1,"purple",1,"purple_skill","psionic",25,4,"psionic_6",1},

		{"modifier_templar_assassin_refraction_7",1,"orange",0,"orange_skill","refraction",18,1,1},
		{"modifier_templar_assassin_meld_7",1,"orange",0,"orange_skill","meld",22,1,2},
		{"modifier_templar_assassin_psiblades_7",1,"orange",0,"orange_skill","psiblades",20,1,3},
		{"modifier_templar_assassin_psionic_7",1,"orange",0,"orange_skill","psionic",19,1,4},
	},



	npc_dota_hero_bloodseeker = {
		{"modifier_bloodseeker_bloodrage_1",1,"blue",3,"blue_skill","bloodrage",25,1,"bloodrage_1",0},
		{"modifier_bloodseeker_bloodrage_2",1,"blue",3,"blue_skill","bloodrage",25,1,"bloodrage_2",0},
		{"modifier_bloodseeker_bloodrage_3",1,"blue",3,"blue_skill","bloodrage",25,1,"bloodrage_3",1},
	
		{"modifier_bloodseeker_bloodrite_1",1,"blue",3,"blue_skill","bloodrite",25,2,"bloodrite_1",1},
		{"modifier_bloodseeker_bloodrite_2",1,"blue",3,"blue_skill","bloodrite",25,2,"bloodrite_2",1},
		{"modifier_bloodseeker_bloodrite_3",1,"blue",3,"blue_skill","bloodrite",25,2,"bloodrite_3",1},
	
		{"modifier_bloodseeker_thirst_1",1,"blue",3,"blue_skill","thirst",25,3,"thirst_1",0},
		{"modifier_bloodseeker_thirst_2",1,"blue",3,"blue_skill","thirst",25,3,"thirst_6",0},
		{"modifier_bloodseeker_thirst_3",1,"blue",3,"blue_skill","thirst",25,3,"thirst_3",0},
	
		{"modifier_bloodseeker_rupture_1",1,"blue",3,"blue_skill","rupture",25,4,"rupture_1",0},
		{"modifier_bloodseeker_rupture_2",1,"blue",3,"blue_skill","rupture",25,4,"rupture_2",0},
		{"modifier_bloodseeker_rupture_3",1,"blue",3,"blue_skill","rupture",25,4,"rupture_3",0},

		{"modifier_bloodseeker_bloodrage_4",1,"purple",2,"purple_skill","bloodrage",25,1,"bloodrage_4",1},
		{"modifier_bloodseeker_bloodrage_5",1,"purple",1,"purple_skill","bloodrage",25,1,"bloodrage_5",0},
		{"modifier_bloodseeker_bloodrage_6",1,"purple",1,"purple_skill","bloodrage",25,1,"bloodrage_6",1},
	
		{"modifier_bloodseeker_bloodrite_4",1,"purple",2,"purple_skill","bloodrite",25,2,"bloodrite_4",1},
		{"modifier_bloodseeker_bloodrite_5",1,"purple",1,"purple_skill","bloodrite",25,2,"bloodrite_5",1},
		{"modifier_bloodseeker_bloodrite_6",1,"purple",1,"purple_skill","bloodrite",25,2,"bloodrite_6",1},
	
		{"modifier_bloodseeker_thirst_4",1,"purple",2,"purple_skill","thirst",25,3,"thirst_4",1},
		{"modifier_bloodseeker_thirst_5",1,"purple",1,"purple_skill","thirst",25,3,"thirst_2",0},
		{"modifier_bloodseeker_thirst_6",1,"purple",1,"purple_skill","thirst",25,3,"thirst_5",1},
	
		{"modifier_bloodseeker_rupture_4",1,"purple",2,"purple_skill","rupture",25,4,"rupture_4",1},
		{"modifier_bloodseeker_rupture_5",1,"purple",1,"purple_skill","rupture",25,4,"rupture_5",1},
		{"modifier_bloodseeker_rupture_6",1,"purple",1,"purple_skill","rupture",25,4,"rupture_6",1},

		{"modifier_bloodseeker_bloodrage_7",1,"orange",0,"orange_skill","bloodrage",18,1,1},
		{"modifier_bloodseeker_bloodrite_7",1,"orange",0,"orange_skill","bloodrite",22,1,2},
		{"modifier_bloodseeker_thirst_7",1,"orange",0,"orange_skill","thirst",20,0,3},
		{"modifier_bloodseeker_rupture_7",1,"orange",0,"orange_skill","rupture",19,1,4},
	},


	npc_dota_hero_monkey_king = {
		{"modifier_monkey_king_boundless_1",1,"blue",3,"blue_skill","boundless",25,1,"boundless_1",0},
		{"modifier_monkey_king_boundless_2",1,"blue",3,"blue_skill","boundless",25,1,"boundless_2",0},
		{"modifier_monkey_king_boundless_3",1,"blue",3,"blue_skill","boundless",25,1,"boundless_3",0},

		{"modifier_monkey_king_tree_1",1,"blue",3,"blue_skill","tree",25,2,"tree_1",0},
		{"modifier_monkey_king_tree_2",1,"blue",3,"blue_skill","tree",25,2,"tree_2",0},
		{"modifier_monkey_king_tree_3",1,"blue",3,"blue_skill","tree",25,2,"tree_3",0},

		{"modifier_monkey_king_mastery_1",1,"blue",3,"blue_skill","mastery",25,3,"mastery_1",1},
		{"modifier_monkey_king_mastery_2",1,"blue",3,"blue_skill","mastery",25,3,"mastery_2",0},
		{"modifier_monkey_king_mastery_3",1,"blue",3,"blue_skill","mastery",25,3,"mastery_3",1},

		{"modifier_monkey_king_command_1",1,"blue",3,"blue_skill","command",25,4,"command_1",0},
		{"modifier_monkey_king_command_2",1,"blue",3,"blue_skill","command",25,4,"command_2",0},
		{"modifier_monkey_king_command_3",1,"blue",3,"blue_skill","command",25,4,"command_3",1},

		{"modifier_monkey_king_boundless_4",1,"purple",2,"purple_skill","boundless",25,1,"boundless_4",1},
		{"modifier_monkey_king_boundless_5",1,"purple",1,"purple_skill","boundless",25,1,"boundless_5",1},
		{"modifier_monkey_king_boundless_6",1,"purple",1,"purple_skill","boundless",25,1,"boundless_6",1},

		{"modifier_monkey_king_tree_4",1,"purple",2,"purple_skill","tree",25,2,"tree_4",0},
		{"modifier_monkey_king_tree_5",1,"purple",1,"purple_skill","tree",25,2,"tree_5",0},
		{"modifier_monkey_king_tree_6",1,"purple",1,"purple_skill","tree",25,2,"tree_6",0},

		{"modifier_monkey_king_mastery_4",1,"purple",2,"purple_skill","mastery",25,3,"mastery_4",0},
		{"modifier_monkey_king_mastery_5",1,"purple",1,"purple_skill","mastery",25,3,"mastery_5",1},
		{"modifier_monkey_king_mastery_6",1,"purple",1,"purple_skill","mastery",25,3,"mastery_6",1},

		{"modifier_monkey_king_command_4",1,"purple",2,"purple_skill","command",25,4,"command_4",1},
		{"modifier_monkey_king_command_5",1,"purple",1,"purple_skill","command",25,4,"command_5",1},
		{"modifier_monkey_king_command_6",1,"purple",1,"purple_skill","command",25,4,"command_6",1},

		{"modifier_monkey_king_boundless_7",1,"orange",0,"orange_skill","boundless",18,1,1},
		{"modifier_monkey_king_tree_7",1,"orange",0,"orange_skill","tree",22,0,2},
		{"modifier_monkey_king_mastery_7",1,"orange",0,"orange_skill","mastery",20,1,3},
		{"modifier_monkey_king_command_7",1,"orange",0,"orange_skill","command",19,1,4},
	}, 

	npc_dota_hero_mars = {
		{"modifier_mars_spear_1",1,"blue",3,"blue_skill","spear",25,1,"spear_1",1},
		{"modifier_mars_spear_2",1,"blue",3,"blue_skill","spear",25,1,"spear_2",0},
		{"modifier_mars_spear_3",1,"blue",3,"blue_skill","spear",25,1,"spear_3",0},
	
		{"modifier_mars_rebuke_1",1,"blue",3,"blue_skill","rebuke",25,2,"rebuke_1",0},
		{"modifier_mars_rebuke_2",1,"blue",3,"blue_skill","rebuke",25,2,"rebuke_2",0},
		{"modifier_mars_rebuke_3",1,"blue",3,"blue_skill","rebuke",25,2,"rebuke_3",0},
	
		{"modifier_mars_bulwark_1",1,"blue",3,"blue_skill","bulwark",25,3,"bulwark_1",0},
		{"modifier_mars_bulwark_2",1,"blue",3,"blue_skill","bulwark",25,3,"bulwark_2",1},
		{"modifier_mars_bulwark_3",1,"blue",3,"blue_skill","bulwark",25,3,"bulwark_3",1},
	
		{"modifier_mars_arena_1",1,"blue",3,"blue_skill","arena",25,4,"arena_2",0},
		{"modifier_mars_arena_2",1,"blue",3,"blue_skill","arena",25,4,"arena_3",0},
		{"modifier_mars_arena_3",1,"blue",3,"blue_skill","arena",25,4,"arena_1",0},

		{"modifier_mars_spear_4",1,"purple",2,"purple_skill","spear",25,1,"spear_4",0},
		{"modifier_mars_spear_5",1,"purple",1,"purple_skill","spear",25,1,"spear_5",0},
		{"modifier_mars_spear_6",1,"purple",1,"purple_skill","spear",25,1,"spear_6",1},
	
		{"modifier_mars_rebuke_4",1,"purple",2,"purple_skill","rebuke",25,2,"rebuke_4",1},
		{"modifier_mars_rebuke_5",1,"purple",1,"purple_skill","rebuke",25,2,"rebuke_5",1},
		{"modifier_mars_rebuke_6",1,"purple",1,"purple_skill","rebuke",25,2,"rebuke_6",1},
	
		{"modifier_mars_bulwark_4",1,"purple",2,"purple_skill","bulwark",25,3,"bulwark_4",1},
		{"modifier_mars_bulwark_5",1,"purple",1,"purple_skill","bulwark",25,3,"bulwark_5",1},
		{"modifier_mars_bulwark_6",1,"purple",1,"purple_skill","bulwark",25,3,"bulwark_6",1},
	
		{"modifier_mars_arena_4",1,"purple",2,"purple_skill","arena",25,4,"arena_4",1},
		{"modifier_mars_arena_5",1,"purple",1,"purple_skill","arena",25,4,"arena_5",1},
		{"modifier_mars_arena_6",1,"purple",1,"purple_skill","arena",25,4,"arena_6",0},

		{"modifier_mars_spear_7",1,"orange",0,"orange_skill","spear",18,1,1},
		{"modifier_mars_rebuke_7",1,"orange",0,"orange_skill","rebuke",22,1,2},
		{"modifier_mars_bulwark_7",1,"orange",0,"orange_skill","bulwark",20,1,3},
		{"modifier_mars_arena_7",1,"orange",0,"orange_skill","arena",19,1,4},
	},

	npc_dota_hero_zuus = {
		{"modifier_zuus_arc_1",1,"blue",3,"blue_skill","arc",25,1,"arc_1",0},
		{"modifier_zuus_arc_2",1,"blue",3,"blue_skill","arc",25,1,"arc_2",0},
		{"modifier_zuus_arc_3",1,"blue",3,"blue_skill","arc",25,1,"arc_3",1},
	
		{"modifier_zuus_bolt_1",1,"blue",3,"blue_skill","bolt",25,2,"bolt_1",0},
		{"modifier_zuus_bolt_2",1,"blue",3,"blue_skill","bolt",25,2,"bolt_2",0},
		{"modifier_zuus_bolt_3",1,"blue",3,"blue_skill","bolt",25,2,"bolt_3",0},
	
		{"modifier_zuus_jump_1",1,"blue",3,"blue_skill","jump",25,3,"jump_1",0},
		{"modifier_zuus_jump_2",1,"blue",3,"blue_skill","jump",25,3,"jump_2",0},
		{"modifier_zuus_jump_3",1,"blue",3,"blue_skill","jump",25,3,"jump_3",1},
	
		{"modifier_zuus_wrath_1",1,"blue",3,"blue_skill","wrath",25,4,"wrath_1",0},
		{"modifier_zuus_wrath_2",1,"blue",3,"blue_skill","wrath",25,4,"wrath_2",0},
		{"modifier_zuus_wrath_3",1,"blue",3,"blue_skill","wrath",25,4,"wrath_3",1},

		{"modifier_zuus_arc_4",1,"purple",2,"purple_skill","arc",25,1,"arc_4",1},
		{"modifier_zuus_arc_5",1,"purple",1,"purple_skill","arc",25,1,"arc_5",0},
		{"modifier_zuus_arc_6",1,"purple",1,"purple_skill","arc",25,1,"arc_6",1},
	
		{"modifier_zuus_bolt_4",1,"purple",2,"purple_skill","bolt",25,2,"bolt_4",1},
		{"modifier_zuus_bolt_5",1,"purple",1,"purple_skill","bolt",25,2,"bolt_5",1},
		{"modifier_zuus_bolt_6",1,"purple",1,"purple_skill","bolt",25,2,"bolt_6",1},
	
		{"modifier_zuus_jump_4",1,"purple",2,"purple_skill","jump",25,3,"jump_4",1},
		{"modifier_zuus_jump_5",1,"purple",1,"purple_skill","jump",25,3,"jump_5",0},
		{"modifier_zuus_jump_6",1,"purple",1,"purple_skill","jump",25,3,"jump_6",1},
	
		{"modifier_zuus_wrath_4",1,"purple",2,"purple_skill","wrath",25,4,"wrath_4",1},
		{"modifier_zuus_wrath_5",1,"purple",1,"purple_skill","wrath",25,4,"wrath_5",0},
		{"modifier_zuus_wrath_6",1,"purple",1,"purple_skill","wrath",25,4,"wrath_6",0},

		{"modifier_zuus_arc_7",1,"orange",0,"orange_skill","arc",18,1,1},
		{"modifier_zuus_bolt_7",1,"orange",0,"orange_skill","bolt",22,1,2},
		{"modifier_zuus_jump_7",1,"orange",0,"orange_skill","jump",20,1,3},
		{"modifier_zuus_wrath_7",1,"orange",0,"orange_skill","wrath",19,1,4},
	},

	npc_dota_hero_leshrac = {
		{"modifier_leshrac_earth_1",1,"blue",3,"blue_skill","earth",25,1,"earth_1",0},
		{"modifier_leshrac_earth_2",1,"blue",3,"blue_skill","earth",25,1,"earth_2",0},
		{"modifier_leshrac_earth_3",1,"blue",3,"blue_skill","earth",25,1,"earth_3",0},
	
		{"modifier_leshrac_edict_1",1,"blue",3,"blue_skill","edict",25,2,"edict_1",0},
		{"modifier_leshrac_edict_2",1,"blue",3,"blue_skill","edict",25,2,"edict_2",0},
		{"modifier_leshrac_edict_3",1,"blue",3,"blue_skill","edict",25,2,"edict_3",0},
	
		{"modifier_leshrac_storm_1",1,"blue",3,"blue_skill","storm",25,3,"storm_1",0},
		{"modifier_leshrac_storm_2",1,"blue",3,"blue_skill","storm",25,3,"storm_2",0},
		{"modifier_leshrac_storm_3",1,"blue",3,"blue_skill","storm",25,3,"storm_3",0},
	
		{"modifier_leshrac_nova_1",1,"blue",3,"blue_skill","nova",25,4,"nova_1",0},
		{"modifier_leshrac_nova_2",1,"blue",3,"blue_skill","nova",25,4,"nova_2",0},
		{"modifier_leshrac_nova_3",1,"blue",3,"blue_skill","nova",25,4,"nova_3",0},

		{"modifier_leshrac_earth_4",1,"purple",2,"purple_skill","earth",25,1,"earth_4",1},
		{"modifier_leshrac_earth_5",1,"purple",1,"purple_skill","earth",25,1,"earth_5",1},
		{"modifier_leshrac_earth_6",1,"purple",1,"purple_skill","earth",25,1,"earth_6",0},
	
		{"modifier_leshrac_edict_4",1,"purple",2,"purple_skill","edict",25,2,"edict_4",1},
		{"modifier_leshrac_edict_5",1,"purple",1,"purple_skill","edict",25,2,"edict_5",1},
		{"modifier_leshrac_edict_6",1,"purple",1,"purple_skill","edict",25,2,"edict_6",1},
	
		{"modifier_leshrac_storm_4",1,"purple",2,"purple_skill","storm",25,3,"storm_4",1},
		{"modifier_leshrac_storm_5",1,"purple",1,"purple_skill","storm",25,3,"storm_5",1},
		{"modifier_leshrac_storm_6",1,"purple",1,"purple_skill","storm",25,3,"storm_6",0},
	
		{"modifier_leshrac_nova_4",1,"purple",2,"purple_skill","nova",25,4,"nova_4",1},
		{"modifier_leshrac_nova_5",1,"purple",1,"purple_skill","nova",25,4,"nova_5",0},
		{"modifier_leshrac_nova_6",1,"purple",1,"purple_skill","nova",25,4,"nova_6",0},

		{"modifier_leshrac_earth_7",1,"orange",0,"orange_skill","earth",18,1,1},
		{"modifier_leshrac_edict_7",1,"orange",0,"orange_skill","edict",22,1,2},
		{"modifier_leshrac_storm_7",1,"orange",0,"orange_skill","storm",20,1,3},
		{"modifier_leshrac_nova_7",1,"orange",0,"orange_skill","nova",19,1,4},
	},

		
	npc_dota_hero_crystal_maiden = {
		{"modifier_maiden_crystal_1",1,"blue",3,"blue_skill","crystal",25,1,"crystal_1",0},
		{"modifier_maiden_crystal_2",1,"blue",3,"blue_skill","crystal",25,1,"crystal_2",0},
		{"modifier_maiden_crystal_3",1,"blue",3,"blue_skill","crystal",25,1,"crystal_3",1},
	
		{"modifier_maiden_frostbite_1",1,"blue",3,"blue_skill","frostbite",25,2,"frostbite_1",0},
		{"modifier_maiden_frostbite_2",1,"blue",3,"blue_skill","frostbite",25,2,"frostbite_2",0},
		{"modifier_maiden_frostbite_3",1,"blue",3,"blue_skill","frostbite",25,2,"frostbite_3",1},
	
		{"modifier_maiden_arcane_1",1,"blue",3,"blue_skill","arcane",25,3,"arcane_1",0},
		{"modifier_maiden_arcane_2",1,"blue",3,"blue_skill","arcane",25,3,"arcane_2",0},
		{"modifier_maiden_arcane_3",1,"blue",3,"blue_skill","arcane",25,3,"arcane_3",0},
	
		{"modifier_maiden_freezing_1",1,"blue",3,"blue_skill","freezing",25,4,"freezing_1",0},
		{"modifier_maiden_freezing_2",1,"blue",3,"blue_skill","freezing",25,4,"freezing_2",0},
		{"modifier_maiden_freezing_3",1,"blue",3,"blue_skill","freezing",25,4,"freezing_3",0},

		{"modifier_maiden_crystal_4",1,"purple",2,"purple_skill","crystal",25,1,"crystal_4",0},
		{"modifier_maiden_crystal_5",1,"purple",1,"purple_skill","crystal",25,1,"crystal_5",1},
		{"modifier_maiden_crystal_6",1,"purple",1,"purple_skill","crystal",25,1,"crystal_6",1},
	
		{"modifier_maiden_frostbite_4",1,"purple",2,"purple_skill","frostbite",25,2,"frostbite_4",1},
		{"modifier_maiden_frostbite_5",1,"purple",1,"purple_skill","frostbite",25,2,"frostbite_5",1},
		{"modifier_maiden_frostbite_6",1,"purple",1,"purple_skill","frostbite",25,2,"frostbite_6",1},
	
		{"modifier_maiden_arcane_4",1,"purple",2,"purple_skill","arcane",25,3,"arcane_4",0},
		{"modifier_maiden_arcane_5",1,"purple",1,"purple_skill","arcane",25,3,"arcane_5",1},
		{"modifier_maiden_arcane_6",1,"purple",1,"purple_skill","arcane",25,3,"arcane_6",0},
	
		{"modifier_maiden_freezing_4",1,"purple",2,"purple_skill","freezing",25,4,"freezing_4",1},
		{"modifier_maiden_freezing_5",1,"purple",1,"purple_skill","freezing",25,4,"freezing_5",1},
		{"modifier_maiden_freezing_6",1,"purple",1,"purple_skill","freezing",25,4,"freezing_6",0},

		{"modifier_maiden_crystal_7",1,"orange",0,"orange_skill","crystal",18,1,1},
		{"modifier_maiden_frostbite_7",1,"orange",0,"orange_skill","frostbite",22,1,2},
		{"modifier_maiden_arcane_7",1,"orange",0,"orange_skill","arcane",20,1,3},
		{"modifier_maiden_freezing_7",1,"orange",0,"orange_skill","freezing",19,1,4},
	},
	
	npc_dota_hero_snapfire = {
		{"modifier_snapfire_scatter_1",1,"blue",3,"blue_skill","scatter",25,1,"scatter_1",0},
		{"modifier_snapfire_scatter_2",1,"blue",3,"blue_skill","scatter",25,1,"scatter_2",0},
		{"modifier_snapfire_scatter_3",1,"blue",3,"blue_skill","scatter",25,1,"scatter_3",0},
	
		{"modifier_snapfire_cookie_1",1,"blue",3,"blue_skill","cookie",25,2,"cookie_1",0},
		{"modifier_snapfire_cookie_2",1,"blue",3,"blue_skill","cookie",25,2,"cookie_2",0},
		{"modifier_snapfire_cookie_3",1,"blue",3,"blue_skill","cookie",25,2,"cookie_3",0},
	
		{"modifier_snapfire_shredder_1",1,"blue",3,"blue_skill","shredder",25,3,"shredder_1",0},
		{"modifier_snapfire_shredder_2",1,"blue",3,"blue_skill","shredder",25,3,"shredder_2",0},
		{"modifier_snapfire_shredder_3",1,"blue",3,"blue_skill","shredder",25,3,"shredder_3",0},
	
		{"modifier_snapfire_kisses_1",1,"blue",3,"blue_skill","kisses",25,4,"kisses_1",0},
		{"modifier_snapfire_kisses_2",1,"blue",3,"blue_skill","kisses",25,4,"kisses_2",0},
		{"modifier_snapfire_kisses_3",1,"blue",3,"blue_skill","kisses",25,4,"kisses_3",0},

		{"modifier_snapfire_scatter_4",1,"purple",2,"purple_skill","scatter",25,1,"scatter_4",1},
		{"modifier_snapfire_scatter_5",1,"purple",1,"purple_skill","scatter",25,1,"scatter_5",1},
		{"modifier_snapfire_scatter_6",1,"purple",1,"purple_skill","scatter",25,1,"scatter_6",1},
	
		{"modifier_snapfire_cookie_4",1,"purple",2,"purple_skill","cookie",25,2,"cookie_4",1},
		{"modifier_snapfire_cookie_5",1,"purple",1,"purple_skill","cookie",25,2,"cookie_5",1},
		{"modifier_snapfire_cookie_6",1,"purple",1,"purple_skill","cookie",25,2,"cookie_6",1},
	
		{"modifier_snapfire_shredder_4",1,"purple",2,"purple_skill","shredder",25,3,"shredder_4",1},
		{"modifier_snapfire_shredder_5",1,"purple",1,"purple_skill","shredder",25,3,"shredder_5",0},
		{"modifier_snapfire_shredder_6",1,"purple",1,"purple_skill","shredder",25,3,"shredder_6",1},
	
		{"modifier_snapfire_kisses_4",1,"purple",2,"purple_skill","kisses",25,4,"kisses_4",1},
		{"modifier_snapfire_kisses_5",1,"purple",1,"purple_skill","kisses",25,4,"kisses_5",1},
		{"modifier_snapfire_kisses_6",1,"purple",1,"purple_skill","kisses",25,4,"kisses_6",1},

		{"modifier_snapfire_scatter_7",1,"orange",0,"orange_skill","scatter",18,1,1},
		{"modifier_snapfire_cookie_7",1,"orange",0,"orange_skill","cookie",22,1,2},
		{"modifier_snapfire_shredder_7",1,"orange",0,"orange_skill","shredder",20,1,3},
		{"modifier_snapfire_kisses_7",1,"orange",0,"orange_skill","kisses",19,1,4},
	},
	
	npc_dota_hero_sven = {
		{"modifier_sven_hammer_1",1,"blue",3,"blue_skill","hammer",25,1,"hammer_1",0},
		{"modifier_sven_hammer_2",1,"blue",3,"blue_skill","hammer",25,1,"hammer_2",0},
		{"modifier_sven_hammer_3",1,"blue",3,"blue_skill","hammer",25,1,"hammer_3",0},

		{"modifier_sven_cleave_1",1,"blue",3,"blue_skill","cleave",25,2,"cleave_1",0},
		{"modifier_sven_cleave_2",1,"blue",3,"blue_skill","cleave",25,2,"cleave_2",0},
		{"modifier_sven_cleave_3",1,"blue",3,"blue_skill","cleave",25,2,"cleave_3",0},

		{"modifier_sven_cry_1",1,"blue",3,"blue_skill","cry",25,3,"cry_1",0},
		{"modifier_sven_cry_2",1,"blue",3,"blue_skill","cry",25,3,"cry_2",0},
		{"modifier_sven_cry_3",1,"blue",3,"blue_skill","cry",25,3,"cry_3",0},

		{"modifier_sven_god_1",1,"blue",3,"blue_skill","god",25,4,"god_1",0},
		{"modifier_sven_god_2",1,"blue",3,"blue_skill","god",25,4,"god_2",0},
		{"modifier_sven_god_3",1,"blue",3,"blue_skill","god",25,4,"god_3",0},

		{"modifier_sven_hammer_4",1,"purple",2,"purple_skill","hammer",25,1,"hammer_4",1},
		{"modifier_sven_hammer_5",1,"purple",1,"purple_skill","hammer",25,1,"hammer_5",1},
		{"modifier_sven_hammer_6",1,"purple",1,"purple_skill","hammer",25,1,"hammer_6",0},

		{"modifier_sven_cleave_4",1,"purple",2,"purple_skill","cleave",25,2,"cleave_4",0},
		{"modifier_sven_cleave_5",1,"purple",1,"purple_skill","cleave",25,2,"cleave_5",1},
		{"modifier_sven_cleave_6",1,"purple",1,"purple_skill","cleave",25,2,"cleave_6",0},

		{"modifier_sven_cry_4",1,"purple",2,"purple_skill","cry",25,3,"cry_4",1},
		{"modifier_sven_cry_5",1,"purple",1,"purple_skill","cry",25,3,"cry_5",1},
		{"modifier_sven_cry_6",1,"purple",1,"purple_skill","cry",25,3,"cry_6",0},

		{"modifier_sven_god_4",1,"purple",2,"purple_skill","god",25,4,"god_4",0},
		{"modifier_sven_god_5",1,"purple",1,"purple_skill","god",25,4,"god_5",1},
		{"modifier_sven_god_6",1,"purple",1,"purple_skill","god",25,4,"god_6",1},

		{"modifier_sven_hammer_7",1,"orange",0,"orange_skill","hammer",18,1,1},
		{"modifier_sven_cleave_7",1,"orange",0,"orange_skill","cleave",22,1,2},
		{"modifier_sven_cry_7",1,"orange",0,"orange_skill","cry",20,1,3},
		{"modifier_sven_god_7",1,"orange",0,"orange_skill","god",19,1,4},
	},
	
	npc_dota_hero_sniper = {
		{"modifier_sniper_shrapnel_1",1,"blue",3,"blue_skill","shrapnel",25,1,"shrapnel_1",0},
		{"modifier_sniper_shrapnel_2",1,"blue",3,"blue_skill","shrapnel",25,1,"shrapnel_2",0},
		{"modifier_sniper_shrapnel_3",1,"blue",3,"blue_skill","shrapnel",25,1,"shrapnel_3",1},

		{"modifier_sniper_headshot_1",1,"blue",3,"blue_skill","headshot",25,2,"headshot_1",0},
		{"modifier_sniper_headshot_2",1,"blue",3,"blue_skill","headshot",25,2,"headshot_2",0},
		{"modifier_sniper_headshot_3",1,"blue",3,"blue_skill","headshot",25,2,"headshot_3",0},

		{"modifier_sniper_aim_1",1,"blue",3,"blue_skill","aim",25,3,"aim_1",1},
		{"modifier_sniper_aim_2",1,"blue",3,"blue_skill","aim",25,3,"aim_2",0},
		{"modifier_sniper_aim_3",1,"blue",3,"blue_skill","aim",25,3,"aim_3",0},

		{"modifier_sniper_assassinate_1",1,"blue",3,"blue_skill","assassinate",25,4,"assassinate_1",0},
		{"modifier_sniper_assassinate_2",1,"blue",3,"blue_skill","assassinate",25,4,"assassinate_2",1},
		{"modifier_sniper_assassinate_3",1,"blue",3,"blue_skill","assassinate",25,4,"assassinate_3",0},

		{"modifier_sniper_shrapnel_4",1,"purple",2,"purple_skill","shrapnel",25,1,"shrapnel_4",1},
		{"modifier_sniper_shrapnel_5",1,"purple",1,"purple_skill","shrapnel",25,1,"shrapnel_5",1},
		{"modifier_sniper_shrapnel_6",1,"purple",1,"purple_skill","shrapnel",25,1,"shrapnel_6",0},

		{"modifier_sniper_headshot_4",1,"purple",2,"purple_skill","headshot",25,2,"headshot_4",1},
		{"modifier_sniper_headshot_5",1,"purple",1,"purple_skill","headshot",25,2,"headshot_5",1},
		{"modifier_sniper_headshot_6",1,"purple",1,"purple_skill","headshot",25,2,"headshot_6",0},

		{"modifier_sniper_aim_4",1,"purple",2,"purple_skill","aim",25,3,"aim_4",1},
		{"modifier_sniper_aim_5",1,"purple",1,"purple_skill","aim",25,3,"aim_5",1},
		{"modifier_sniper_aim_6",1,"purple",1,"purple_skill","aim",25,3,"aim_6",1},

		{"modifier_sniper_assassinate_4",1,"purple",2,"purple_skill","assassinate",25,4,"assassinate_4",1},
		{"modifier_sniper_assassinate_5",1,"purple",1,"purple_skill","assassinate",25,4,"assassinate_5",1},
		{"modifier_sniper_assassinate_6",1,"purple",1,"purple_skill","assassinate",25,4,"assassinate_6",0},

		{"modifier_sniper_shrapnel_7",1,"orange",0,"orange_skill","shrapnel",18,1,1},
		{"modifier_sniper_headshot_7",1,"orange",0,"orange_skill","headshot",22,1,2},
		{"modifier_sniper_aim_7",1,"orange",0,"orange_skill","aim",20,1,3},
		{"modifier_sniper_assassinate_7",1,"orange",0,"orange_skill","assassinate",19,1,4},
	},

	npc_dota_hero_muerta = {
		{"modifier_muerta_dead_1",1,"blue",3,"blue_skill","dead",25,1,"dead_1",0},
		{"modifier_muerta_dead_2",1,"blue",3,"blue_skill","dead",25,1,"dead_2",0},
		{"modifier_muerta_dead_3",1,"blue",3,"blue_skill","dead",25,1,"dead_3",0},
	
		{"modifier_muerta_calling_1",1,"blue",3,"blue_skill","calling",25,2,"calling_1",0},
		{"modifier_muerta_calling_2",1,"blue",3,"blue_skill","calling",25,2,"calling_2",0},
		{"modifier_muerta_calling_3",1,"blue",3,"blue_skill","calling",25,2,"calling_3",0},
	
		{"modifier_muerta_gun_1",1,"blue",3,"blue_skill","gun",25,3,"gun_1",0},
		{"modifier_muerta_gun_2",1,"blue",3,"blue_skill","gun",25,3,"gun_2",0},
		{"modifier_muerta_gun_3",1,"blue",3,"blue_skill","gun",25,3,"gun_3",0},
	
		{"modifier_muerta_veil_1",1,"blue",3,"blue_skill","veil",25,4,"veil_1",0},
		{"modifier_muerta_veil_2",1,"blue",3,"blue_skill","veil",25,4,"veil_2",0},
		{"modifier_muerta_veil_3",1,"blue",3,"blue_skill","veil",25,4,"veil_3",0},

		{"modifier_muerta_dead_4",1,"purple",2,"purple_skill","dead",25,1,"dead_4",1},
		{"modifier_muerta_dead_5",1,"purple",1,"purple_skill","dead",25,1,"dead_5",0},
		{"modifier_muerta_dead_6",1,"purple",1,"purple_skill","dead",25,1,"dead_6",1},
	
		{"modifier_muerta_calling_4",1,"purple",2,"purple_skill","calling",25,2,"calling_4",1},
		{"modifier_muerta_calling_5",1,"purple",1,"purple_skill","calling",25,2,"calling_5",0},
		{"modifier_muerta_calling_6",1,"purple",1,"purple_skill","calling",25,2,"calling_6",0},
	
		{"modifier_muerta_gun_4",1,"purple",2,"purple_skill","gun",25,3,"gun_4",1},
		{"modifier_muerta_gun_5",1,"purple",1,"purple_skill","gun",25,3,"gun_5",0},
		{"modifier_muerta_gun_6",1,"purple",1,"purple_skill","gun",25,3,"gun_6",1},
	
		{"modifier_muerta_veil_4",1,"purple",2,"purple_skill","veil",25,4,"veil_4",0},
		{"modifier_muerta_veil_5",1,"purple",1,"purple_skill","veil",25,4,"veil_5",1},
		{"modifier_muerta_veil_6",1,"purple",1,"purple_skill","veil",25,4,"veil_6",1},

		{"modifier_muerta_dead_7",1,"orange",0,"orange_skill","dead",18,1,1},
		{"modifier_muerta_calling_7",1,"orange",0,"orange_skill","calling",22,1,2},
		{"modifier_muerta_gun_7",1,"orange",0,"orange_skill","gun",20,0,3},
		{"modifier_muerta_veil_7",1,"orange",0,"orange_skill","veil",19,0,4},
	},

	npc_dota_hero_pangolier = {
		{"modifier_pangolier_buckle_1",1,"blue",3,"blue_skill","buckle",25,1,"buckle_1",0},
		{"modifier_pangolier_buckle_2",1,"blue",3,"blue_skill","buckle",25,1,"buckle_2",0},
		{"modifier_pangolier_buckle_3",1,"blue",3,"blue_skill","buckle",25,1,"buckle_3",0},

		{"modifier_pangolier_shield_1",1,"blue",3,"blue_skill","shield",25,2,"shield_1",0},
		{"modifier_pangolier_shield_2",1,"blue",3,"blue_skill","shield",25,2,"shield_2",0},
		{"modifier_pangolier_shield_3",1,"blue",3,"blue_skill","shield",25,2,"shield_3",0},

		{"modifier_pangolier_lucky_1",1,"blue",3,"blue_skill","lucky",25,3,"lucky_1",0},
		{"modifier_pangolier_lucky_2",1,"blue",3,"blue_skill","lucky",25,3,"lucky_2",0},
		{"modifier_pangolier_lucky_3",1,"blue",3,"blue_skill","lucky",25,3,"lucky_3",0},

		{"modifier_pangolier_rolling_1",1,"blue",3,"blue_skill","rolling",25,4,"rolling_1",0},
		{"modifier_pangolier_rolling_2",1,"blue",3,"blue_skill","rolling",25,4,"rolling_2",0},
		{"modifier_pangolier_rolling_3",1,"blue",3,"blue_skill","rolling",25,4,"rolling_3",0},

		{"modifier_pangolier_buckle_4",1,"purple",2,"purple_skill","buckle",25,1,"buckle_4",1},
		{"modifier_pangolier_buckle_5",1,"purple",1,"purple_skill","buckle",25,1,"buckle_5",1},
		{"modifier_pangolier_buckle_6",1,"purple",1,"purple_skill","buckle",25,1,"buckle_6",1},

		{"modifier_pangolier_shield_4",1,"purple",2,"purple_skill","shield",25,2,"shield_4",1},
		{"modifier_pangolier_shield_5",1,"purple",1,"purple_skill","shield",25,2,"shield_5",1},
		{"modifier_pangolier_shield_6",1,"purple",1,"purple_skill","shield",25,2,"shield_6",0},

		{"modifier_pangolier_lucky_4",1,"purple",2,"purple_skill","lucky",25,3,"lucky_4",0},
		{"modifier_pangolier_lucky_5",1,"purple",1,"purple_skill","lucky",25,3,"lucky_5",0},
		{"modifier_pangolier_lucky_6",1,"purple",1,"purple_skill","lucky",25,3,"lucky_6",1},

		{"modifier_pangolier_rolling_4",1,"purple",2,"purple_skill","rolling",25,4,"rolling_4",1},
		{"modifier_pangolier_rolling_5",1,"purple",1,"purple_skill","rolling",25,4,"rolling_5",1},
		{"modifier_pangolier_rolling_6",1,"purple",1,"purple_skill","rolling",25,4,"rolling_6",0},

		{"modifier_pangolier_buckle_7",1,"orange",0,"orange_skill","buckle",18,1,1},
		{"modifier_pangolier_shield_7",1,"orange",0,"orange_skill","shield",22,1,2},
		{"modifier_pangolier_lucky_7",1,"orange",0,"orange_skill","lucky",20,1,3},
		{"modifier_pangolier_rolling_7",1,"orange",0,"orange_skill","rolling",19,1,4},
	}, 

	
	npc_dota_hero_arc_warden = {
		{"modifier_arc_warden_flux_1",1,"blue",3,"blue_skill","flux",25,1,"flux_1",0},
		{"modifier_arc_warden_flux_2",1,"blue",3,"blue_skill","flux",25,1,"flux_2",0},
		{"modifier_arc_warden_flux_3",1,"blue",3,"blue_skill","flux",25,1,"flux_3",0},

		{"modifier_arc_warden_field_1",1,"blue",3,"blue_skill","field",25,2,"field_1",0},
		{"modifier_arc_warden_field_2",1,"blue",3,"blue_skill","field",25,2,"field_2",0},
		{"modifier_arc_warden_field_3",1,"blue",3,"blue_skill","field",25,2,"field_3",0},

		{"modifier_arc_warden_spark_1",1,"blue",3,"blue_skill","spark",25,3,"spark_1",0},
		{"modifier_arc_warden_spark_2",1,"blue",3,"blue_skill","spark",25,3,"spark_2",0},
		{"modifier_arc_warden_spark_3",1,"blue",3,"blue_skill","spark",25,3,"spark_3",0},

		{"modifier_arc_warden_double_1",1,"blue",3,"blue_skill","double",25,4,"double_1",1},
		{"modifier_arc_warden_double_2",1,"blue",3,"blue_skill","double",25,4,"double_2",0},
		{"modifier_arc_warden_double_3",1,"blue",3,"blue_skill","double",25,4,"double_3",0},

		{"modifier_arc_warden_flux_4",1,"purple",2,"purple_skill","flux",25,1,"flux_4",0},
		{"modifier_arc_warden_flux_5",1,"purple",1,"purple_skill","flux",25,1,"flux_5",1},
		{"modifier_arc_warden_flux_6",1,"purple",1,"purple_skill","flux",25,1,"flux_6",1},

		{"modifier_arc_warden_field_4",1,"purple",2,"purple_skill","field",25,2,"field_4",1},
		{"modifier_arc_warden_field_5",1,"purple",1,"purple_skill","field",25,2,"field_5",1},
		{"modifier_arc_warden_field_6",1,"purple",1,"purple_skill","field",25,2,"field_6",1},

		{"modifier_arc_warden_spark_4",1,"purple",2,"purple_skill","spark",25,3,"spark_4",1},
		{"modifier_arc_warden_spark_5",1,"purple",1,"purple_skill","spark",25,3,"spark_5",1},
		{"modifier_arc_warden_spark_6",1,"purple",1,"purple_skill","spark",25,3,"spark_6",1},

		{"modifier_arc_warden_double_4",1,"purple",2,"purple_skill","double",25,4,"double_4",1},
		{"modifier_arc_warden_double_5",1,"purple",1,"purple_skill","double",25,4,"double_5",1},
		{"modifier_arc_warden_double_6",1,"purple",1,"purple_skill","double",25,4,"double_6",0},

		{"modifier_arc_warden_flux_7",1,"orange",0,"orange_skill","flux",18,1,1},
		{"modifier_arc_warden_field_7",1,"orange",0,"orange_skill","field",22,1,2},
		{"modifier_arc_warden_spark_7",1,"orange",0,"orange_skill","spark",20,1,3},
		{"modifier_arc_warden_double_7",1,"orange",0,"orange_skill","double",19,1,4},
	},
	 npc_dota_hero_invoker = {
		{"modifier_invoker_quas_1",1,"blue",3,"blue_skill","coldsnap",25,1,"quas_1",0},
		{"modifier_invoker_quas_2",1,"blue",3,"blue_skill","coldsnap",25,1,"quas_2",0},
		{"modifier_invoker_quas_3",1,"blue",3,"blue_skill","walk",25,1,"quas_3",0},

		{"modifier_invoker_wex_1",1,"blue",3,"blue_skill","tornado",25,2,"wex_1",0},
		{"modifier_invoker_wex_2",1,"blue",3,"blue_skill","alacrity",25,2,"wex_2",0},
		{"modifier_invoker_wex_3",1,"blue",3,"blue_skill","wex",25,2,"wex_3",0},

		{"modifier_invoker_exort_1",1,"blue",3,"blue_skill","forge",25,3,"exort_1",0},
		{"modifier_invoker_exort_2",1,"blue",3,"blue_skill","sunstrike",25,3,"exort_2",1},
		{"modifier_invoker_exort_3",1,"blue",3,"blue_skill","meteor",25,3,"exort_3",0},

		{"modifier_invoker_invoke_1",1,"blue",3,"blue_skill","deafing",25,4,"invoke_1",0},
		{"modifier_invoker_invoke_2",1,"blue",3,"blue_skill","invoke",25,4,"invoke_2",0},
		{"modifier_invoker_invoke_3",1,"blue",3,"blue_skill","invoke",25,4,"invoke_3",0},

		{"modifier_invoker_quas_4",1,"purple",2,"purple_skill","coldsnap",25,1,"quas_4",0},
		{"modifier_invoker_quas_5",1,"purple",1,"purple_skill","icewall",25,1,"quas_5",1},
		{"modifier_invoker_quas_6",1,"purple",1,"purple_skill","walk",25,1,"quas_6",1},

		{"modifier_invoker_wex_4",1,"purple",2,"purple_skill","alacrity",25,2,"wex_4",0},
		{"modifier_invoker_wex_5",1,"purple",1,"purple_skill","emp",25,2,"wex_5",1},
		{"modifier_invoker_wex_6",1,"purple",1,"purple_skill","tornado",25,2,"wex_6",1},

		{"modifier_invoker_exort_4",1,"purple",2,"purple_skill","forge",25,3,"exort_4",1},
		{"modifier_invoker_exort_5",1,"purple",1,"purple_skill","sunstrike",25,3,"exort_5",1},
		{"modifier_invoker_exort_6",1,"purple",1,"purple_skill","forge",25,3,"exort_6",1},

		{"modifier_invoker_invoke_4",1,"purple",2,"purple_skill","invoke",25,4,"invoke_4",0},
		{"modifier_invoker_invoke_5",1,"purple",1,"purple_skill","deafing",25,4,"invoke_5",1},
		{"modifier_invoker_invoke_6",1,"purple",1,"purple_skill","invoke",25,4,"invoke_6",0},

		{"modifier_invoker_quas_7",1,"orange",0,"orange_skill","quas",18,1,1},
		{"modifier_invoker_wex_7",1,"orange",0,"orange_skill","wex",22,1,2},
		{"modifier_invoker_exort_7",1,"orange",0,"orange_skill","exort",20,1,3},
		{"modifier_invoker_invoke_7",1,"orange",0,"orange_skill","invoke",19,1,4},
	},

	npc_dota_hero_razor = {
		{"modifier_razor_plasma_1",1,"blue",3,"blue_skill","plasma",25,1,"plasma_1",0},
		{"modifier_razor_plasma_2",1,"blue",3,"blue_skill","plasma",25,1,"plasma_2",0},
		{"modifier_razor_plasma_3",1,"blue",3,"blue_skill","plasma",25,1,"plasma_3",0},

		{"modifier_razor_link_1",1,"blue",3,"blue_skill","link",25,2,"link_1",0},
		{"modifier_razor_link_2",1,"blue",3,"blue_skill","link",25,2,"link_2",0},
		{"modifier_razor_link_3",1,"blue",3,"blue_skill","link",25,2,"link_3",0},

		{"modifier_razor_current_1",1,"blue",3,"blue_skill","current",25,3,"current_1",0},
		{"modifier_razor_current_2",1,"blue",3,"blue_skill","current",25,3,"current_2",0},
		{"modifier_razor_current_3",1,"blue",3,"blue_skill","current",25,3,"current_3",0},

		{"modifier_razor_eye_1",1,"blue",3,"blue_skill","eye",25,4,"eye_1",0},
		{"modifier_razor_eye_2",1,"blue",3,"blue_skill","eye",25,4,"eye_2",0},
		{"modifier_razor_eye_3",1,"blue",3,"blue_skill","eye",25,4,"eye_3",0},

		{"modifier_razor_plasma_4",1,"purple",2,"purple_skill","plasma",25,1,"plasma_4",1},
		{"modifier_razor_plasma_5",1,"purple",1,"purple_skill","plasma",25,1,"plasma_5",1},
		{"modifier_razor_plasma_6",1,"purple",1,"purple_skill","plasma",25,1,"plasma_6",1},

		{"modifier_razor_link_4",1,"purple",2,"purple_skill","link",25,2,"link_4",0},
		{"modifier_razor_link_5",1,"purple",1,"purple_skill","link",25,2,"link_5",1},
		{"modifier_razor_link_6",1,"purple",1,"purple_skill","link",25,2,"link_6",1},

		{"modifier_razor_current_4",1,"purple",2,"purple_skill","current",25,3,"current_4",1},
		{"modifier_razor_current_5",1,"purple",1,"purple_skill","current",25,3,"current_5",0},
		{"modifier_razor_current_6",1,"purple",1,"purple_skill","current",25,3,"current_6",1},

		{"modifier_razor_eye_4",1,"purple",2,"purple_skill","eye",25,4,"eye_4",0},
		{"modifier_razor_eye_5",1,"purple",1,"purple_skill","eye",25,4,"eye_5",1},
		{"modifier_razor_eye_6",1,"purple",1,"purple_skill","eye",25,4,"eye_6",1},

		{"modifier_razor_plasma_7",1,"orange",0,"orange_skill","plasma",18,1,1},
		{"modifier_razor_link_7",1,"orange",0,"orange_skill","link",22,1,2},
		{"modifier_razor_current_7",1,"orange",0,"orange_skill","current",20,1,3},
		{"modifier_razor_eye_7",1,"orange",0,"orange_skill","eye",19,1,4},
	},

	npc_dota_hero_sand_king = {
		{"modifier_sand_king_burrow_1",1,"blue",3,"blue_skill","burrow",25,1,"burrow_1",0},
		{"modifier_sand_king_burrow_2",1,"blue",3,"blue_skill","burrow",25,1,"burrow_2",0},
		{"modifier_sand_king_burrow_3",1,"blue",3,"blue_skill","burrow",25,1,"burrow_3",0},

		{"modifier_sand_king_sand_1",1,"blue",3,"blue_skill","sand",25,2,"sand_1",0},
		{"modifier_sand_king_sand_2",1,"blue",3,"blue_skill","sand",25,2,"sand_2",0},
		{"modifier_sand_king_sand_3",1,"blue",3,"blue_skill","sand",25,2,"sand_3",0},

		{"modifier_sand_king_finale_1",1,"blue",3,"blue_skill","finale",25,3,"finale_1",0},
		{"modifier_sand_king_finale_2",1,"blue",3,"blue_skill","finale",25,3,"finale_2",1},
		{"modifier_sand_king_finale_3",1,"blue",3,"blue_skill","finale",25,3,"finale_3",0},

		{"modifier_sand_king_epicenter_1",1,"blue",3,"blue_skill","epicenter",25,4,"epicenter_1",0},
		{"modifier_sand_king_epicenter_2",1,"blue",3,"blue_skill","epicenter",25,4,"epicenter_2",0},
		{"modifier_sand_king_epicenter_3",1,"blue",3,"blue_skill","epicenter",25,4,"epicenter_3",0},

		{"modifier_sand_king_burrow_4",1,"purple",2,"purple_skill","burrow",25,1,"burrow_4",1},
		{"modifier_sand_king_burrow_5",1,"purple",1,"purple_skill","burrow",25,1,"burrow_5",0},
		{"modifier_sand_king_burrow_6",1,"purple",1,"purple_skill","burrow",25,1,"burrow_6",1},

		{"modifier_sand_king_sand_4",1,"purple",2,"purple_skill","sand",25,2,"sand_4",1},
		{"modifier_sand_king_sand_5",1,"purple",1,"purple_skill","sand",25,2,"sand_5",0},
		{"modifier_sand_king_sand_6",1,"purple",1,"purple_skill","sand",25,2,"sand_6",1},

		{"modifier_sand_king_finale_4",1,"purple",2,"purple_skill","finale",25,3,"finale_4",0},
		{"modifier_sand_king_finale_5",1,"purple",1,"purple_skill","finale",25,3,"finale_5",1},
		{"modifier_sand_king_finale_6",1,"purple",1,"purple_skill","finale",25,3,"finale_6",0},

		{"modifier_sand_king_epicenter_4",1,"purple",2,"purple_skill","epicenter",25,4,"epicenter_4",1},
		{"modifier_sand_king_epicenter_5",1,"purple",1,"purple_skill","epicenter",25,4,"epicenter_5",1},
		{"modifier_sand_king_epicenter_6",1,"purple",1,"purple_skill","epicenter",25,4,"epicenter_6",0},

		{"modifier_sand_king_burrow_7",1,"orange",0,"orange_skill","burrow",18,1,1},
		{"modifier_sand_king_sand_7",1,"orange",0,"orange_skill","sand",22,1,2},
		{"modifier_sand_king_finale_7",1,"orange",0,"orange_skill","finale",20,1,3},
		{"modifier_sand_king_epicenter_7",1,"orange",0,"orange_skill","epicenter",19,1,4},
	},
}




for group_name, skill_group in pairs(skills) do
	for _, data in pairs(skill_group) do
		local path
		if data[2] == 1 then
			path = "upgrade/" .. group_name .. "/" .. data[1] .. ".lua"
		elseif data[2] == 0 then
			path = "upgrade/general/" .. data[1] .. ".lua"
		elseif data[2] == 2 then
			path = "upgrade/tower/" .. data[1] .. ".lua"
		end

		if group_name == "npc_dota_hero_pangolier" or group_name == "npc_dota_hero_arc_warden" or group_name == "npc_dota_hero_invoker"
		 or group_name == "npc_dota_hero_razor" or group_name == "npc_dota_hero_sand_king" then 
			path = "upgrade/" .. group_name .. "/" .. group_name .. ".lua"
		end

		LinkLuaModifier(data[1], path, LUA_MODIFIER_MOTION_NONE)
	end
end

function upgrade:InitGameMode()
	ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnEntityKilled"), self)
	ListenToGameEvent("npc_spawned", Dynamic_Wrap(self, "OnEntitySpawned"), self)

	CustomGameEventManager:RegisterListener("activate_choise", Dynamic_Wrap(self, "make_choise"))
	CustomGameEventManager:RegisterListener("refresh_sphere", Dynamic_Wrap(self, "refresh_sphere"))

	for group_name, skills_group in pairs(skills) do
		CustomNetTables:SetTableValue("all_upgrades", group_name, skills_group)
	end
end

function upgrade:OnEntitySpawned(params)
	local unit = EntIndexToHScript(params.entindex)
	local owner = unit:GetOwner()

	if not owner or owner == nil or owner:IsNull() then
		return
	end




	for i = 1, 11 do
		if players[i] ~= nil then
			if unit:GetUnitName() then
				unit.x_max = players[i].x_max
				unit.x_min = players[i].x_min
				unit.y_max = players[i].y_max
				unit.y_min = players[i].y_min
				unit.z = players[i].z
			end
		end
	end
end

function upgrade:OnEntityKilled(param)
if param.entindex_attacker == nil then
	return
end

local hero = EntIndexToHScript(param.entindex_attacker)
local unit = EntIndexToHScript(param.entindex_killed)


if unit:IsTempestDouble() then 
	return
end

if hero:IsHero() and unit:IsValidKill(hero) then 
	my_game:CountKill()
end 

if players[hero:GetTeamNumber()] and unit:IsValidKill(hero) then 
	players[hero:GetTeamNumber()]:GiveKillExp(unit)
end 

local no_purple_for_hero = false

if hero.owner ~= nil and hero:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5  then
	hero = hero.owner
end


if (hero:GetQuest() ~= nil) and hero:GetUnitName() ~= unit:GetUnitName() then 

	if (hero:GetQuest() == "General.Quest_1") and unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS and not unit:IsPatrolCreep() then 
		hero:UpdateQuest(1)
	end

	if (hero:GetQuest() == "General.Quest_2") and unit:IsPatrolCreep() then 
		hero:UpdateQuest(1)
	end

	if (hero:GetQuest() == "General.Quest_17") and unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS and unit:IsAncient() then 
		hero:UpdateQuest(1)
	end

	if (hero:GetQuest() == "General.Quest_3") and unit:GetTeamNumber() ~= hero:GetTeamNumber() and (unit:GetUnitName() == "npc_dota_observer_wards" or unit:GetUnitName() == "npc_dota_sentry_wards") then 
		hero:UpdateQuest(1)
	end

	if (hero:GetQuest() == "General.Quest_4") and unit:IsRealHero() and not unit:IsReincarnating() then 
		hero:UpdateQuest(1)
	end

	if (hero:GetQuest() == "Mars.Quest_8") and unit:IsRealHero() and not unit:IsReincarnating() and unit:HasModifier("modifier_mars_arena_of_blood_custom_projectile_aura") then 
		hero:UpdateQuest(1)
	end




	if (hero:GetQuest() == "Never.Quest_6" or hero:GetQuest() == "Blood.Quest_7") and unit:IsRealHero() and not unit:IsReincarnating() then 

		if hero.quest.extra_data == nil then 
			hero.quest.extra_data = {}
		end

		if not hero.quest.extra_data[unit:GetUnitName()] then 

			hero.quest.extra_data[unit:GetUnitName()] = true
			hero:UpdateQuest(1)
		end
	end

	if (hero:GetQuest() == "Queen.Quest_8") and unit:IsRealHero() and not unit:IsReincarnating() and unit:HasModifier("modifier_custom_sonic_quest") then 
		hero:UpdateQuest(1)
	end

	if (hero:GetQuest() == "Terr.Quest_6") and EntIndexToHScript(param.entindex_attacker):IsIllusion() and unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS and not unit:IsPatrolCreep() then 
		hero:UpdateQuest(1)
	end


	if (hero:GetQuest() == "General.Quest_16") and unit:IsRealHero() and hero:HasModifier("modifier_item_custom_smoke_quest_kill") then 
		hero:UpdateQuest(1)
	end
end



if unit:IsRealHero() and unit:IsReincarnating() == false then
	

	if hero and players[hero:GetTeamNumber()] then 
		players[hero:GetTeamNumber()].kills_done = players[hero:GetTeamNumber()].kills_done + 1
	end


	if unit.died_on_duel == true then
		--unit:SetBuyBackDisabledByReapersScythe(true)
		unit:SetTimeUntilRespawn(round_timer + 1)
		unit.died_on_duel = nil
	else
		if players[unit:GetTeamNumber()] then

			if players[hero:GetTeamNumber()] ~= nil and hero ~= unit and hero:IsHero() and unit:HasModifier("modifier_player_damage") then

				local target_array = players[unit:GetTeamNumber()]
				local killer_array = players[hero:GetTeamNumber()]

				local mod = unit:FindModifierByName("modifier_player_damage")

				if mod then 

					if mod:GetStackCount() >= Player_damage_max then 
						no_purple_for_hero = true
					end 

					if mod:GetStackCount() < Player_damage_max then 
						mod:IncrementStackCount()
					end

					target_array.damage_bonus = math.max(0, (mod:GetStackCount() - 1)*Player_damage_inc)
				end 

				mod = hero:FindModifierByName("modifier_player_damage")

				if mod then 
					mod:SetStackCount(0)
					killer_array.damage_bonus = 0
				end 



			end

			if players[hero:GetTeamNumber()] ~= nil and hero ~= unit and hero:IsHero() then
				local target_array = players[unit:GetTeamNumber()]
				local killer_array = players[hero:GetTeamNumber()]

				if killer_array.hero_kills[unit:GetTeamNumber()] == nil then 
					killer_array.hero_kills[unit:GetTeamNumber()] = 0
				end

				killer_array.hero_kills[unit:GetTeamNumber()] = killer_array.hero_kills[unit:GetTeamNumber()] + 1

				if target_array then 
					target_array.hero_kills[hero:GetTeamNumber()] = 0
				end

			end


			local more_gold = 0--PlayerResource:GetNetWorth(unit:GetPlayerOwnerID()) * kill_net_gold


			if hero:IsHero() then

				local net_killer = PlayerResource:GetNetWorth(hero:GetPlayerOwnerID())
				local net_victim = PlayerResource:GetNetWorth(unit:GetPlayerOwnerID())

				bonus_gold = 0
				if net_victim > net_killer then
					bonus_gold = (net_victim - net_killer) * Streak_k
				end

				more_gold = more_gold + bonus_gold
			end


			if hero:IsHero() then
				hero:ModifyGold(more_gold, true, DOTA_ModifyGold_HeroKill)
				SendOverheadEventMessage(hero, 0, hero, more_gold, nil)
			end



			local target = unit:FindModifierByName("modifier_target")
			local mod = unit:FindModifierByName("modifier_patrol_repsawn")

			local tower = towers[unit:GetTeamNumber()]

			local killed_by_hero = false
			if hero:IsRealHero() or (hero.owner ~= nil and hero:GetTeamNumber() ~= DOTA_TEAM_CUSTOM_5) then 
				killed_by_hero = true
			end 


			local new_respawn = 0

				new_respawn = StartDeathTimer + my_game.current_wave*DeathTimer_PerWave
	
				if tower and tower:HasModifier("modifier_tower_armor_aura") then 
					new_respawn = new_respawn*(1 - tower:FindModifierByName("modifier_tower_armor_aura").respawn)
				end

			if (killed_by_hero and target) then 
				new_respawn = Short_Respawn_target
					target:Destroy()
			end

			if mod then 
				new_respawn = Short_Respawn
					mod:Destroy()
			end 

				unit:SetTimeUntilRespawn(new_respawn)

				if unit.is_bot then 
					unit:SetTimeUntilRespawn(3)
				end 
			
			players[unit:GetTeamNumber()].death = players[unit:GetTeamNumber()].death + 1
		else
			unit:SetTimeUntilRespawn(5)
		end
	end
end

if param.entindex_attacker == nil then
	return
end

if
	(unit:GetTeam() == DOTA_TEAM_CUSTOM_5) and (unit:GetUnitName() == "npc_roshan_custom") and
		EntIndexToHScript(param.entindex_attacker):GetUnitName() ~= "npc_roshan_custom"
 then
	local item = CreateItem("item_aegis", nil, nil)
	CreateItemOnPositionSync(GetGroundPosition(unit:GetAbsOrigin(), unit), item)
	if unit.number >= 1 then
		local item_2 = CreateItem("item_roshan_necro", nil, nil)
		CreateItemOnPositionSync(
			GetGroundPosition(unit:GetAbsOrigin() + RandomVector(RandomInt(-1, 1) + 100), unit),
			item_2
		)
	end
end


if not hero:IsHero() and not hero:IsBuilding() then
	return
end



if unit:GetTeam() == DOTA_TEAM_NEUTRALS and not hero:HasModifier("modifier_duel_hero_thinker") and unit.dire_patrol == nil and
		unit.radiant_patrol == nil 
		and #FindUnitsInRadius( hero:GetTeamNumber(), hero:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD+DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false ) == 0
 then
	local tier = 0
	local minute = math.floor(GameRules:GetDOTATime(false, false) / 60)
	if minute >= 40 then
		tier = 5
	elseif minute >= 30 then
		tier = 4
	elseif minute >= 20 then
		tier = 3
	elseif minute >= 10 then
		tier = 2
	elseif minute >= 0 then
		tier = 1
	end

	local szItemDrop = "item_tier"..tier.."_token" -- GetPotentialNeutralItemDrop(tier, hero:GetTeamNumber())

	local chance = NeutralChance

	if my_game:IsAncientCreep(unit) then
		chance = chance * 3
	end


	local random = RollPseudoRandomPercentage(chance, 153, hero)

	if szItemDrop ~= nil and players[hero:GetTeamNumber()].NeutraItems[tier] < 1 and random then
		players[hero:GetTeamNumber()].NeutraItems[tier] = players[hero:GetTeamNumber()].NeutraItems[tier] + 1

		if hero:IsIllusion() then
			hero = hero.owner
		end

		local point = Vector(0, 0, 0)

		if hero:IsAlive() then
			point = hero:GetAbsOrigin() + hero:GetForwardVector() * 150
		else
			if towers[hero:GetTeamNumber()] ~= nil then
				point =
					towers[hero:GetTeamNumber()]:GetAbsOrigin() +
					towers[hero:GetTeamNumber()]:GetForwardVector() * 300
			end
		end

		local hItem = DropNeutralItemAtPositionForHero(szItemDrop, point, hero, tier, true)
	end
end

local name = nil
local effect = nil
local sound = nil
local drop = true
local owner = nil

if (unit:GetTeam() == DOTA_TEAM_CUSTOM_5) and unit.ally and unit.ally ~= nil then
	local count_mob = 0

	for i = 1, #unit.ally do


		if not unit.ally[i]:IsNull() and unit.ally[i] ~= unit then

			if unit.ally[i]:IsAlive() then
				drop = false
				count_mob = count_mob + 1
			end

		end

		if unit.ally[i].dropped then 
			drop = false
			break
		end
	end

	if drop == true then 
		unit.dropped = true 
	end

	if unit.host ~= nil and players[unit.host:GetTeamNumber()] ~= nil and my_game:FinalDuel() == false then
		CustomGameEventManager:Send_ServerToPlayer(
			PlayerResource:GetPlayer(players[unit.host:GetTeamNumber()]:GetPlayerOwnerID()),
			"timer_progress",
			{
				units = count_mob,
				units_max = unit.max,
				time = -1,
				max = -1,
				name = my_game:GetWave(unit.wave_number, unit.isboss),
				skills = my_game:GetSkills(unit.wave_number, unit.isboss),
				mkb = my_game:GetMkb(unit.wave_number, unit.isboss),
				reward = unit.reward,
				gold = unit.givegold,
				number = my_game.current_wave,
				hide = false
			}
		)
	end

	if drop then
		if unit.lownet == 1 then

			my_game:InitLowNet(unit.host)

			--if not players[unit.host:GetTeamNumber()]:IsAlive() then
			--	players[unit.host:GetTeamNumber()].give_lownet = 1
			--else
			--	players[unit.host:GetTeamNumber()]:AddNewModifier(
				--	players[unit.host:GetTeamNumber()],
				--	nil,
			--		"modifier_lownet_choose",
			--		{}
			--	)
			--end
		end

		if unit.host ~= nil and players[unit.host:GetTeamNumber()] ~= nil then
			players[unit.host:GetTeamNumber()].ActiveWave = nil
		end

		if not hero:IsBuilding() or (unit.drop == "item_legendary_upgrade" or unit.drop == "item_purple_upgrade"
		or (unit.drop == "item_gray_upgrade" and unit.host:IsAlive() and (unit:GetAbsOrigin() - unit.host:GetAbsOrigin()):Length2D() <= 700)) then
			name = unit.drop
			effect = unit.effect
			sound = unit.sound

			if unit.drop == "item_legendary_upgrade" or unit.drop == "item_purple_upgrade" or unit.drop == "item_gray_upgrade"
			 then
				owner = unit.owner
			end

			local distance = (hero:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
			if distance > 1500 then
				owner = unit.owner
			end
		end
	end
end

if	(unit:GetTeam() == DOTA_TEAM_NEUTRALS or unit:IsBuilding()) and not hero:IsBuilding() and
		not hero:HasModifier("modifier_duel_hero_thinker") and not hero:HasModifier("modifier_item_midas_noblue")
 then
	if BluePoints[unit:GetUnitName()] ~= nil then
		local k = 1

		local killer_hero = players[hero:GetTeamNumber()]

		if killer_hero:HasModifier("modifier_up_bluepoints") then
			--k = k + BlueMorePoints
		end

		if killer_hero:HasModifier("modifier_item_alchemist_gold_bfury") then 
			k = k + killer_hero:FindModifierByName("modifier_item_alchemist_gold_bfury").blue_bonus
		else 
			if killer_hero:HasModifier("modifier_item_bfury_custom")  then
				k = k + killer_hero:FindModifierByName("modifier_item_bfury_custom").blue_bonus
			end
		end

		local points = BluePoints[unit:GetUnitName()]


		if killer_hero:HasModifier("modifier_alchemist_greed_2") then
			local ability = killer_hero:FindAbilityByName("alchemist_goblins_greed_custom")
			points = points + ability.blue[killer_hero:GetUpgradeStack("modifier_alchemist_greed_2")]
		end

		killer_hero.bluepoints = killer_hero.bluepoints + points * k

		if killer_hero.bluepoints >= killer_hero.bluemax then
			CustomGameEventManager:Send_ServerToPlayer(
				PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
				"kill_progress",
				{
					blue = killer_hero.bluemax,
					purple = killer_hero.purplepoints,
					max = killer_hero.bluemax,
					max_p = math.floor(killer_hero.purplemax)
				}
			)

			Timers:CreateTimer(
				0.5,
				function()
					CustomGameEventManager:Send_ServerToPlayer(
						PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
						"kill_progress",
						{
							blue = math.floor(killer_hero.bluepoints),
							purple = killer_hero.purplepoints,
							max = killer_hero.bluemax,
							max_p = math.floor(killer_hero.purplemax)
						}
					)
				end
			)

			killer_hero.bluepoints =
				killer_hero.bluepoints - killer_hero.bluemax
			killer_hero.bluemax = killer_hero.bluemax + PlusBlue
			name = "item_blue_upgrade"
			effect = "particles/blue_drop.vpcf"
			sound = "powerup_03"
		else
			CustomGameEventManager:Send_ServerToPlayer(
				PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
				"kill_progress",
				{
					blue = math.floor(killer_hero.bluepoints),
					purple = killer_hero.purplepoints,
					max = killer_hero.bluemax,
					max_p = math.floor(killer_hero.purplemax)
				}
			)
		end
	end
end

if hero:IsBuilding() then
	hero = players[hero:GetTeamNumber()]
end


if players[unit:GetTeamNumber()] ~= nil and players[hero:GetTeamNumber()] ~= nil and GameRules:GetDOTATime(false, false) < Player_damage_time then 
--	if players[hero:GetTeamNumber()].hero_kills and 
--		( players[hero:GetTeamNumber()].hero_kills[unit:GetTeamNumber()] and players[hero:GetTeamNumber()].hero_kills[unit:GetTeamNumber()] > 3) then 
--		no_purple_for_hero = true
--	end

end



if
	((unit:IsRealHero() and
		((players[unit:GetTeamNumber()] ~= nil and players[unit:GetTeamNumber()].no_purple == false) or test)) or
		unit:GetUnitName() == "npc_roshan_custom") and
		no_purple_for_hero == false and 
		hero:GetTeamNumber() ~= unit:GetTeamNumber() and
		(my_game:FinalDuel() == false or duel_data[#duel_data].rounds == 0) and
		unit:IsReincarnating() == false
 then


	players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints + 1

	if players[hero:GetTeamNumber()]:HasModifier("modifier_lownet_purple_buff") then
		players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints + lownet_purple
		players[hero:GetTeamNumber()]:RemoveModifierByName("modifier_lownet_purple_buff")
	end

	if players[hero:GetTeamNumber()].purplepoints >= math.floor(players[hero:GetTeamNumber()].purplemax) then
		CustomGameEventManager:Send_ServerToPlayer(
			PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
			"kill_progress",
			{
				blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
				purple = math.floor(players[hero:GetTeamNumber()].purplemax),
				max = players[hero:GetTeamNumber()].bluemax,
				max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
			}
		)

		Timers:CreateTimer(
			0.5,
			function()
				CustomGameEventManager:Send_ServerToPlayer(
					PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
					"kill_progress",
					{
						blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
						purple = players[hero:GetTeamNumber()].purplepoints,
						max = players[hero:GetTeamNumber()].bluemax,
						max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
					}
				)
			end
		)

		players[hero:GetTeamNumber()].purplepoints = players[hero:GetTeamNumber()].purplepoints - math.floor(players[hero:GetTeamNumber()].purplemax)
		players[hero:GetTeamNumber()].purplemax = players[hero:GetTeamNumber()].purplemax + PlusPurple

		name = "item_purple_upgrade"
		effect = "particles/purple_drop.vpcf"
		sound = "powerup_05"
	else
		CustomGameEventManager:Send_ServerToPlayer(
			PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
			"kill_progress",
			{
				blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
				purple = players[hero:GetTeamNumber()].purplepoints,
				max = players[hero:GetTeamNumber()].bluemax,
				max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
			}
		)
	end
end

if name ~= nil and hero and players[hero:GetTeamNumber()] ~= nil then
	if name == "item_purple_upgrade" then
		players[hero:GetTeamNumber()].purple = players[hero:GetTeamNumber()].purple + 1
	end

	if hero:IsIllusion() then
		hero = hero.owner
	end

	if owner ~= nil then
		hero = owner
	end

	local item = CreateItem(name, hero, hero)

	item_effect = ParticleManager:CreateParticle(effect, PATTACH_WORLDORIGIN, nil)

	local point = Vector(0, 0, 0)

	if hero:IsAlive() and not hero:HasModifier("modifier_duel_hero_end") and not hero:HasModifier("modifier_duel_hero_thinker") then
		point = hero:GetAbsOrigin() + hero:GetForwardVector() * 150
	else
		if towers[hero:GetTeamNumber()] ~= nil then
			point = towers[hero:GetTeamNumber()]:GetAbsOrigin() + towers[hero:GetTeamNumber()]:GetForwardVector() * 300
		end
	end

	ParticleManager:SetParticleControl(item_effect, 0, point)

	EmitSoundOnEntityForPlayer(sound, hero, hero:GetPlayerOwnerID())

	item.after_legen = After_Lich

	Timers:CreateTimer(
		0.8,
		function()
			CreateItemOnPositionSync(GetGroundPosition(point, unit), item)
		end
	)
end

end

function upgrade:GetRarityName(rare)
	if rare == 1 then
		return "gray"
	end
	if rare == 2 then
		return "blue"
	end
	if rare == 3 then
		return "purple"
	end
	if rare == 4 then
		return "orange"
	end
	return nil
end


function upgrade:GetAlchemistItems(player)

local items_table = skills['alchemist_items']

local chosen_table = {}

if player.alchemist_chosen_item ~= nil then 
	chosen_table = player.alchemist_chosen_item
end

local r_1
repeat r_1 = RandomInt(1, #items_table)
until chosen_table[items_table[r_1][1]] == nil


local r_2 = r_1

repeat r_2 = RandomInt(1, #items_table)
until (r_2 ~= r_1 and chosen_table[items_table[r_2][1]] == nil)

return {items_table[r_1][1], items_table[r_2][1]}
end


function upgrade:GetPatrol1()

local table_patrol = skills['patrol_1']

local r_1 = RandomInt(1, #table_patrol)
local r_2 = r_1

repeat r_2 = RandomInt(1, #table_patrol)
until r_2 ~= r_1

return {table_patrol[r_1][1], table_patrol[r_2][1]}
end


function upgrade:GetPatrol2()

local table_patrol = skills['patrol_2']

local r_1 = RandomInt(1, #table_patrol)
local r_2 = r_1
local r_3 = r_1

repeat r_2 = RandomInt(1, #table_patrol)
until r_2 ~= r_1

repeat r_3 = RandomInt(1, #table_patrol)
until (r_3 ~= r_1) and (r_3 ~= r_2)

return {table_patrol[r_1][1], table_patrol[r_2][1], table_patrol[r_3][1]}
end






function ContainName(name, array)
if not array then return false end

for i = 1,#array do 
	if array[i] == name then 
		return true
	end 
end 

return false
end 


function upgrade:CheckType(player, data)
if not data[9] then return true end 

local exceptions = data[9]
local hero_type = players[player:GetTeamNumber()].HeroType

if ContainName("only_normal", exceptions) and players[player:GetTeamNumber()]:GetPrimaryAttribute() == DOTA_ATTRIBUTE_ALL then
	return false
end

if ContainName("only_all", exceptions) and players[player:GetTeamNumber()]:GetPrimaryAttribute() ~= DOTA_ATTRIBUTE_ALL then
	return false
end

if ContainName("mage", exceptions) and not ContainName("mage", hero_type) then 
	return false
end 

if ContainName("melle", exceptions) and not ContainName("melle", hero_type) then 
	return false
end 

return true
end



function upgrade:MainEpicAllowed(player, data)
if not data then return true end 
if data[3] ~= "purple" then return true end 
if data[4] ~= 2 then return true end

local mod = player:FindModifierByName(data[1])

if not mod or mod:GetStackCount() ~= 1 then 
	return true
end 

local all_upgrades = skills[player:GetUnitName()]
local skill = data[8]

for _,upgrade in pairs(all_upgrades) do 
	if upgrade[8] == skill and upgrade[3] == "purple" and upgrade[4] == 1 and not player:HasModifier(upgrade[1]) then 
		return false
	end 
end 

return true
end 



function upgrade:FindUpgrade(player, skill, rarity, banned_talents, banned_skills)

local all_upgrades = skills[player:GetUnitName()]

if rarity == 1 or skill == 0 then  -- Белый или общий талант
	all_upgrades = skills["all"]
end 


local banned = {}
local possible_upgrades = {}
local rarity_name = upgrade:GetRarityName(rarity)

for _,data in pairs(all_upgrades) do 

	local skill_number = data[8]	
	if rarity == 4 then 
		skill_number = data[9]
	end 
	if data[2] == 0 then 
		skill_number = skill -- Если общий талант, номер скила всегда подходит
	end 

	local mod = player:FindModifierByName(data[1])
	if rarity == 1 then 
		mod = nil -- Если белый талант, уровень не важен
	end

	if data[3] ~= rarity_name or -- Не подходит тип 
	   (mod and (mod:GetStackCount() >= data[4] or rarity == 4)) or -- Улучшение уже есть с макс. уровнем
	   (skill_number ~= skill) or  -- Не тот скил
	   ((skill == 0 or rarity == 1) and not upgrade:CheckType(player, data)) or -- Тип героя подходит под общий талант
	   (ContainName(data[1], banned_talents)) or 
	   (ContainName(data[8], banned_skills) and skill ~= 0) or 
	   not upgrade:MainEpicAllowed(player, data)
	then 
		banned[data[1]] = true
	end 
end 

for _,data in pairs(all_upgrades) do 
	if not banned[data[1]] then 
		table.insert(possible_upgrades, data[1])
	end 
end 

return possible_upgrades
end 


function upgrade:FillChoise(player, all_table)

for _,skill_table in pairs(all_table) do 

	local random 

	repeat random = RandomInt(1, #skill_table)
	until not ContainName(skill_table[random], player.choise)

	table.insert(player.choise, skill_table[random])
end 

end

function upgrade:find_legendary(player)

	for _, data in pairs(skills[player:GetUnitName()]) do
		if data[3] == "orange" then
			local mod = player:FindModifierByName(data[1])
			if not mod then
				table.insert(players[player:GetTeamNumber()].choise, data[1])
			end
		end
	end
end


function upgrade:init_upgrade(player, rarity, can_refresh, after_legen, prev_choise, instant)
if not test then
	players[player:GetTeamNumber()].IsChoosing = true
	players[player:GetTeamNumber()]:AddNewModifier(players[player:GetTeamNumber()], nil, "modifier_end_choise", {duration = 120})
	
end

players[player:GetTeamNumber()].choise = {}


local legendary_info = false

if rarity == 11 then 
	players[player:GetTeamNumber()].choise = upgrade:GetPatrol1()
elseif rarity == 12 then 
	players[player:GetTeamNumber()].choise = upgrade:GetPatrol2()
elseif rarity == 13 then 
	players[player:GetTeamNumber()].choise = upgrade:GetAlchemistItems(player)
elseif rarity == 10 then
	players[player:GetTeamNumber()].choise = {"modifier_lownet_gold", "modifier_lownet_blue", "modifier_lownet_purple", }
elseif rarity == 4 then 

	upgrade:find_legendary(player)
	
	if players[player:GetTeamNumber()].chosen_skill == 0 then
		legendary_info = 1
	end


elseif (rarity == 1 or rarity == 2 or rarity == 3) then 


	local skills_upgrades = {}
	local rarity_table = {}
	local banned_upgrades = {}
	local banned_skills = {}
	local main_skill = nil


	if prev_choise then 
		for _,data in pairs(prev_choise) do
			if data['1'] ~= nil then 
				table.insert(banned_upgrades, data['1']) 
				
				if (after_legen == false or after_legen == 0) then 
					table.insert(banned_skills, tonumber(data['8'])) 
				end 
			end
		end 
	end 


	if player.chosen_skill ~= 0 and (after_legen == true or test == true) then 
		main_skill = player.chosen_skill
	end


	-- Выделить 1 возможное улучшение для каждого скила (+ 1 общее)
	-- Записать их редкости в rarity_table
	-- Пройтись по rarity_table в обратном порядке и найти 2 случайных скила (с приоритетом по редкости)

	for i = 1,4 do 
		rarity_table[i] = {}
	end 

	for i = 0,4 do 

		skills_upgrades[i] = {}

		local current_rarity = rarity + 1
		repeat current_rarity = current_rarity - 1

			skills_upgrades[i] = upgrade:FindUpgrade(player, i, current_rarity, banned_upgrades, banned_skills)

			if #skills_upgrades[i] > 0 then

				if i ~= 0 then 
					table.insert(rarity_table[current_rarity], i)
				end 
			else 
				if current_rarity == rarity then
					main_skill = nil -- Если в выбранной редкости нет таланта главной ветки - главная ветка не будет работать
				end  
			end  

		until #skills_upgrades[i] > 0
	end

	local skill_1 = main_skill
	local skill_2 = nil
	local skill_3 = 0

	for index = 1, 4 do

		local j = 5 - index

		local count = #rarity_table[j]
		if count > 0 then
			
			local skill_1_added = false

			if skill_1 == nil then 
				skill_1 = rarity_table[j][RandomInt(1, count)]
				skill_1_added = true
			end 

			if skill_2 == nil and (skill_1_added == false or count > 1) then 
				repeat skill_2 = rarity_table[j][RandomInt(1, count)]
				until skill_2 ~= skill_1
			end 
		
		end  

		if skill_1 ~= nil and skill_2 ~= nil then 
			break
		end 
	end 

	local final_table = {skills_upgrades[skill_1], skills_upgrades[skill_2], skills_upgrades[skill_3]}


	if rarity == 1 and player:HasModifier("modifier_up_graypoints") then
		table.insert(final_table, skills_upgrades[skill_3])
	end


	upgrade:FillChoise(player, final_table)
end 




local refresh = false

if can_refresh == nil then
	if rarity == 3 and (players[player:GetTeamNumber()].can_refresh == true or test == true) then --and After_Lich == true then
		refresh = true
	end
end

local mod_stacks = {}
for i = 1, #players[player:GetTeamNumber()].choise do
	mod_stacks[i] = 0
	local name = players[player:GetTeamNumber()].choise[i]

	local b = player:FindModifierByName(name) or towers[player:GetTeamNumber()]:FindModifierByName(name)
	if b then
		mod_stacks[i] = b:GetStackCount()
	end
end

local perma_info = {}

for i = 1, #players[player:GetTeamNumber()].choise do
	perma_info[i] = {}
	perma_info[i].stack = -1
	local name = players[player:GetTeamNumber()].choise[i]

	if player:GetTalentValue(name, "is_perma", true ) == 1 then 
		local mod = player:FindModifierByName(player:GetTalentValue(name, "mod_name", true ))

		perma_info[i].stack = 0
		perma_info[i].max = -1 

		if player:GetTalentValue(name, "max", true ) ~= 0 then 
			perma_info[i].max = player:GetTalentValue(name, "max", true )
		end 

		if mod then 
			perma_info[i].stack = mod:GetStackCount()
		end 
	end 
end


players[player:GetTeamNumber()].can_refresh_choise = refresh

if #players[player:GetTeamNumber()].choise == 0 then 
	players[player:GetTeamNumber()]:RemoveModifierByName("modifier_end_choise")
	return
end 

if not instant then 

	CustomGameEventManager:Send_ServerToPlayer(
		PlayerResource:GetPlayer(player:GetPlayerOwnerID()),
		"show_choise",
		{
			choise = players[player:GetTeamNumber()].choise,
			mods = mod_stacks,
			legendary = l,
			hasup = players[player:GetTeamNumber()]:HasModifier("modifier_up_graypoints"),
			refresh = refresh,
			after_legen = after_legen,
			perma_info = perma_info,
			alert = legendary_info
		}
	)


	players[player:GetTeamNumber()].choise_table = {players[player:GetTeamNumber()].choise, false, players[player:GetTeamNumber()]:HasModifier("modifier_up_graypoints"), mod_stacks, refresh }

else 
	local kv = {}
	kv.PlayerID = player:GetPlayerOwnerID()
	kv.chosen = RandomInt(1, #players[player:GetTeamNumber()].choise)
	kv.random = 1

	upgrade:make_choise(kv)
end

mod_stacks = {}
end






function upgrade:make_choise(kv)
	if kv.PlayerID == nil then
		return
	end

	local hero = GlobalHeroes[kv.PlayerID]

	if hero == nil then
		return
	end

	if players[hero:GetTeamNumber()] == nil then
		return
	end

	players[hero:GetTeamNumber()].IsChoosing = false

	local mod = players[hero:GetTeamNumber()]:FindModifierByName("modifier_end_choise")

	if mod then 
		mod:Destroy()
	end 

	if #players[hero:GetTeamNumber()].choise == 0 then
		return
	end

	players[hero:GetTeamNumber()].choise_table = {}
	players[hero:GetTeamNumber()].can_refresh_choise = false

	local skill_name = players[hero:GetTeamNumber()].choise[kv.chosen]

	if skill_name == nil then
		return
	end

	local skill_data = nil
	for _, group_name in pairs({hero:GetUnitName(), "all", "lowest", "patrol_1","patrol_2","alchemist_items"}) do
		local skills_group = skills[group_name]
		for _, data in ipairs(skills_group) do
			if data[1] == skill_name then
				skill_data = data
				break
			end
		end
	end
	if skill_data == nil then
		return
	end

	if kv.random and kv.random == 1 then

		CustomGameEventManager:Send_ServerToPlayer(
			PlayerResource:GetPlayer(hero:GetPlayerOwnerID()),
			"random_talent_alert",
			{
				skill = skill_name,
				hero = hero:GetUnitName()
			}
		)

	end


	if skill_data[3] == "orange" then
		HTTP.playersData[kv.PlayerID].firstOrangeTalent = HTTP.playersData[kv.PlayerID].firstOrangeTalent or skill_data[6]
	end


	if (skill_data[3] == "orange") and (players[hero:GetTeamNumber()].chosen_skill == 0) then
		players[hero:GetTeamNumber()].chosen_skill = skill_data[9]
	end

	if skill_data[3] == "orange" or skill_data[3] == "purple" then
		CustomGameEventManager:Send_ServerToAllClients("show_skill_event", {hero = hero:GetUnitName(), skill = skill_name})
	end


	if skill_data[2] ~= 2 then
		if hero:IsAlive() then
			local mod = hero:AddNewModifier(hero, nil, skill_name, {})
			if mod then
				mod.IsUpgrade = true
				mod.IsOrangeTalent = skill_data[3] == "orange"
				mod.Talenttree = skill_data[6]
			end
		else
			players[hero:GetTeamNumber()].respawn_mod = {}
			players[hero:GetTeamNumber()].respawn_mod.name = skill_name
			players[hero:GetTeamNumber()].respawn_mod.IsOrangeTalent = skill_data[3] == "orange"
			players[hero:GetTeamNumber()].respawn_mod.Talenttree = skill_data[6]
		end

		if hero:FindModifierByName(skill_name) then 
			players[hero:GetTeamNumber()].upgrades[skill_name] = hero:FindModifierByName(skill_name):GetStackCount()
		end

	else
		towers[hero:GetTeamNumber()]:AddNewModifier(hero, nil, skill_name, {})
	end


	CustomNetTables:SetTableValue(
		"upgrades_player",
		hero:GetUnitName(),
		{
			upgrades = players[hero:GetTeamNumber()].upgrades,
			hasup = hero:HasModifier("modifier_up_graypoints")
		}
	)


	if (hero:GetQuest() == "General.Quest_7") and not hero:QuestCompleted() then 
	
		local max = 0
		for _,talent in pairs(skills.all) do 
			local mod = hero:FindModifierByName(talent[1])


			if mod and mod:GetStackCount() >= max and (talent[3] == "gray" or (#talent[3] > 0 and (talent[3][1] == "gray" or talent[3][2] == "gray") )) then 
				max = mod:GetStackCount()
			end
		end

		hero:UpdateQuest(max - hero.quest.progress)
	end


	if (hero:GetQuest() == "General.Quest_8") and not hero:QuestCompleted() and skill_data[3] == "blue" then 

		local mod = hero:FindModifierByName(skill_data[1])

		if mod and mod:GetStackCount() >= skill_data[4] then 
			hero:UpdateQuest(1)
		end
	end


	if (hero:GetQuest() == "General.Quest_9") and not hero:QuestCompleted() and skill_data[3] == "purple" then 

		for _,talent in pairs(skills.all) do 
			local mod = hero:FindModifierByName(talent[1])

			if mod and talent[1] == skill_data[1] then 
				hero:UpdateQuest(1)
				break
			end
		end
			
	
	end


	players[hero:GetTeamNumber()].choise = {}
end

function upgrade:refresh_sphere(kv)
	if kv.PlayerID == nil then
		return
	end
	local hero = GlobalHeroes[kv.PlayerID]


	if players[hero:GetTeamNumber()] == nil then
		return
	end


	players[hero:GetTeamNumber()].can_refresh = false

	if #players[hero:GetTeamNumber()].choise == 0 then
		return
	end

	if not players[hero:GetTeamNumber()].can_refresh_choise then
		return
	end


	local after = false
	if kv.after_legen and kv.after_legen == 1 then 
		after = true
	end

	players[hero:GetTeamNumber()].can_refresh_choise = false
	players[hero:GetTeamNumber()].choise = {}
	upgrade:init_upgrade(hero, 3, nil, after, kv.global_choise)
end



function upgrade:EndChoiseJs(kv)
	if kv.PlayerID == nil then
		return
	end

	local hero = GlobalHeroes[kv.PlayerID]

	if hero then 
		--hero:RemoveModifierByName("modifier_end_choise")
	end
end