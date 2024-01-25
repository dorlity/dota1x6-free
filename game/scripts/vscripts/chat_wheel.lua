if chat_wheel == nil then
	chat_wheel = class({})
end

-- chat_wheel:SetDefaultSound(id) ФУНКЦИЯ УСТАНАВЛИВАЕТ СЛУЧАЙНЫЕ ЗВУКИ ИЗ ЛИСТА GENERAL В КОЛЕСО ВЫЗЫВАЙ ЕЕ ГДЕ-НИБУДЬ ЗВУКИ ВСЕ ХРАНЯТС В АЙДИ (1 В МАССИВЕ )

_G.Sound_list =
{

["general_ru"] = 
{
	{1, "Voice.General_rus_1", 1500},
--	{2, "Voice.General_rus_2", 3000},
	{3, "Voice.General_rus_3", 1500},
	{4, "Voice.General_rus_4", 3000},
	{5, "Voice.General_rus_5", 3000},
	{6, "Voice.General_rus_6", 3000},
	{7, "Voice.General_rus_7", 1500},
	{8, "Voice.General_rus_8", 3000},
	{9, "Voice.General_rus_9", 1500},
	{10, "Voice.General_rus_10", 3000},
	{11, "Voice.General_rus_11", 3000},
	{12, "Voice.General_rus_12", 5000},
	{13, "Voice.General_rus_13", 1500},
	{14, "Voice.General_rus_14", 3000},
	{15, "Voice.General_rus_15", 3000},
	{16, "Voice.General_rus_16", 1500},
	{17, "Voice.General_rus_17", 3000},
	{18, "Voice.General_rus_18", 1500},
	{19, "Voice.General_rus_19", 1500},
	{20, "Voice.General_rus_20", 15000},
	{21, "Voice.General_rus_21", 3000},
	{22, "Voice.General_rus_22", 5000},
	{23, "Voice.General_rus_23", 5000},
	{24, "Voice.General_rus_24", 1500},
	{25, "Voice.General_rus_25", 5000},
	{26, "Voice.General_rus_26", 5000},
	{27, "Voice.General_rus_27", 3000},
	{28, "Voice.General_rus_28", 1500},
	{29, "Voice.General_rus_29", 1500},
	{30, "Voice.General_rus_30", 1500},
	{31, "Voice.General_rus_31", 5000},
	{32, "Voice.General_rus_32", 3000},
	{33, "Voice.General_rus_33", 50000},
	{34, "Voice.General_rus_34", 20000},
	{35, "Voice.General_rus_35", 3000},
	{36, "Voice.General_rus_36", 3000},
	{37, "Voice.General_rus_37", 3000},
	{38, "Voice.General_rus_38", 1500},
	{39, "Voice.General_rus_39", 15000},
	{40, "Voice.General_rus_40", 20000},
	{41, "Voice.General_rus_41", 20000},
	{42, "Voice.General_rus_42", 15000},
	{43, "Voice.General_rus_43", 15000},
	{44, "Voice.General_rus_44", 3000},
	{45, "Voice.General_rus_45", 3000},
	{46, "Voice.General_rus_46", 3000},
	{47, "Voice.General_rus_47", 1500,},
	{48, "Voice.General_rus_48", 3000,},
	{49, "Voice.General_rus_49", 3000,},
	{50, "Voice.General_rus_50", 15000,},
	{51, "Voice.General_rus_51", 15000,},
	{52, "Voice.General_rus_52", 3000,},
	{53, "Voice.General_rus_53", 3000,},
	{54, "Voice.General_rus_54", 1500,},
	{55, "Voice.General_rus_55", 3000,},
	{56, "Voice.General_rus_56", 1500,},
	{57, "Voice.General_rus_57", 1500,},
	{58, "Voice.General_rus_58", 1500,},
	{59, "Voice.General_rus_59", 3000,},
	{60, "Voice.General_rus_60", 1500,},
	{61, "Voice.General_rus_61", 5000, 1},
},

["general_eng"] = 
{
	{100, "Voice.General_eng_1", 1500},
	{101, "Voice.General_eng_2", 1500, 0, 1},
	{102, "Voice.General_eng_3", 1500},
	{103, "Voice.General_eng_4", 3000},
	{104, "Voice.General_eng_5", 5000},
	{105, "Voice.General_eng_6", 3000, 0, 1},
	{106, "Voice.General_eng_7", 800},
	{107, "Voice.General_eng_8", 3000},
	{108, "Voice.General_eng_9", 1500},
	{109, "Voice.General_eng_10", 1500},
	{110, "Voice.General_eng_11", 5000},
	{111, "Voice.General_eng_12", 3000},
	{112, "Voice.General_eng_13", 1500},
	{113, "Voice.General_eng_14", 3000, 0, 1},
	{114, "Voice.General_eng_15", 3000},
	{115, "Voice.General_eng_16", 3000},
	{116, "Voice.General_eng_17", 3000},
	{117, "Voice.General_eng_18", 5000},
	{118, "Voice.General_eng_19", 5000},
	{119, "Voice.General_eng_20", 1500},
	{120, "Voice.General_eng_21", 1500},
	{121, "Voice.General_eng_22", 3000},
	{122, "Voice.General_eng_23", 5000},
	{123, "Voice.General_eng_24", 5000, 0, 1},
	{124, "Voice.General_eng_25", 20000},
	{125, "Voice.General_eng_26", 3000},
	{126, "Voice.General_eng_27", 3000},
	{127, "Voice.General_eng_28", 1500},
	{128, "Voice.General_eng_29", 1500},
	{129, "Voice.General_eng_30", 1500},
	{130, "Voice.General_eng_31", 3000, 0, 1},
	{131, "Voice.General_eng_32", 3000},
	{132, "Voice.General_eng_33", 3000},
	{133, "Voice.General_eng_34", 3000},
	{134, "Voice.General_eng_35", 3000, 0, 1},
	{135, "Voice.General_eng_36", 20000},
	{136, "Voice.General_eng_37", 20000},
	{137, "Voice.General_eng_38", 20000},
	{138, "Voice.General_eng_39", 20000},
	{139, "Voice.General_eng_40", 15000},
	{140, "Voice.General_eng_41", 15000},
	{141, "Voice.General_eng_42", 15000},
	{142, "Voice.General_eng_43", 1500},
	{143, "Voice.General_eng_44", 3000},
	{144, "Voice.General_eng_45", 1500},
	{145, "Voice.General_eng_46", 1500,},
	{146, "Voice.General_eng_47", 1500,},
	{147, "Voice.General_eng_48", 1500,},
},

["general_other"] =
{
	{200, "Voice.General_other_1", 800},	
	{201, "Voice.General_other_2", 800},
	{202, "Voice.General_other_3", 800},
	{203, "Voice.General_other_4", 1500},
	{204, "Voice.General_other_5", 400},
	{205, "Voice.General_other_6", 1500},
	{206, "Voice.General_other_7", 400},
	{207, "Voice.General_other_8", 1500},
	{208, "Voice.General_other_9", 3000},
	{209, "Voice.General_other_10", 800},
	{210, "Voice.General_other_11", 1500},
	{211, "Voice.General_other_12", 1500},
	{212, "Voice.General_other_13", 1500,},
	{213, "Voice.General_other_14", 5000,},
	{214, "Voice.General_other_15", 1500,},
	{215, "Voice.General_other_16", 1500,},
},



	["npc_dota_hero_juggernaut"] = {
		{0, "Voice.Jugg.1_1"},
		{0, "Voice.Jugg.1_2"},
		{1, "Voice.Jugg.2_1"},
		{1, "Voice.Jugg.2_2"},
		{2, "Voice.Jugg.3_1"},
		{2, "Voice.Jugg.3_2"},
		{3, "Voice.Jugg.4_1"},
		{4, "Voice.Jugg.5_1"},
		{5, "Voice.Jugg.6_1"},
	},

	["npc_dota_hero_phantom_assassin"] = {
		{0, "Voice.Phantom.1_1"},
		{0, "Voice.Phantom.1_2"},
		{1, "Voice.Phantom.2_1"},
		{1, "Voice.Phantom.2_2"},
		{2, "Voice.Phantom.3_1"},
		{2, "Voice.Phantom.3_2"},
		{3, "Voice.Phantom.4_1"},
		{4, "Voice.Phantom.5_1"},
		{5, "Voice.Phantom.6_1"},
		
	},


	["npc_dota_hero_huskar"] = {
		{0, "Voice.Huskar.1_1"},
		{0, "Voice.Huskar.1_2"},
		{1, "Voice.Huskar.2_1"},
		{1, "Voice.Huskar.2_2"},
		{2, "Voice.Huskar.3_1"},
		{2, "Voice.Huskar.3_2"},
		{3, "Voice.Huskar.4_1"},
		{4, "Voice.Huskar.5_1"},
		{5, "Voice.Huskar.6_1"},		
	},
	["npc_dota_hero_nevermore"] = {
		{0, "Voice.Never.1_1"},
		{0, "Voice.Never.1_2"},
		{1, "Voice.Never.2_1"},
		{1, "Voice.Never.2_2"},
		{2, "Voice.Never.3_1"},
		{2, "Voice.Never.3_2"},
		{3, "Voice.Never.4_1"},
		{4, "Voice.Never.5_1"},
		{5, "Voice.Never.6_1"},		
	},
	["npc_dota_hero_queenofpain"] = {
		{0, "Voice.Queen.1_1"},
		{0, "Voice.Queen.1_2"},
		{1, "Voice.Queen.2_1"},
		{1, "Voice.Queen.2_2"},
		{2, "Voice.Queen.3_1"},
		{2, "Voice.Queen.3_2"},
		{3, "Voice.Queen.4_1"},
		{4, "Voice.Queen.5_1"},
		{5, "Voice.Queen.6_1"},		
	},
	["npc_dota_hero_terrorblade"] = {
		{0, "Voice.Terr.1_1"},
		{0, "Voice.Terr.1_2"},
		{1, "Voice.Terr.2_1"},
		{1, "Voice.Terr.2_2"},
		{2, "Voice.Terr.3_1"},
		{2, "Voice.Terr.3_2"},
		{3, "Voice.Terr.4_1"},
		{4, "Voice.Terr.5_1"},
		{5, "Voice.Terr.6_1"},	
	},
	["npc_dota_hero_bristleback"] = {
		{0, "Voice.Brist.1_1"},
		{0, "Voice.Brist.1_2"},
		{1, "Voice.Brist.2_1"},
		{1, "Voice.Brist.2_2"},
		{2, "Voice.Brist.3_1"},
		{2, "Voice.Brist.3_2"},
		{3, "Voice.Brist.4_1"},
		{4, "Voice.Brist.5_1"},
		{5, "Voice.Brist.6_1"},	
	},
	["npc_dota_hero_puck"] = {
		{0, "Voice.Puck.1_1"},
		{0, "Voice.Puck.1_2"},
		{1, "Voice.Puck.2_1"},
		{1, "Voice.Puck.2_2"},
		{2, "Voice.Puck.3_1"},
		{2, "Voice.Puck.3_2"},
		{3, "Voice.Puck.4_1"},
		{4, "Voice.Puck.5_1"},
		{5, "Voice.Puck.6_1"},	
	},
	["npc_dota_hero_legion_commander"] = {
		{0, "Voice.Legion.1_1"},
		{0, "Voice.Legion.1_2"},
		{1, "Voice.Legion.2_1"},
		{1, "Voice.Legion.2_2"},
		{2, "Voice.Legion.3_1"},
		{2, "Voice.Legion.3_2"},
		{3, "Voice.Legion.4_1"},
		{4, "Voice.Legion.5_1"},
		{5, "Voice.Legion.6_1"},	
	},
	["npc_dota_hero_void_spirit"] = {
		{0, "Voice.Void.1_1"},
		{0, "Voice.Void.1_2"},
		{1, "Voice.Void.2_1"},
		{1, "Voice.Void.2_2"},
		{2, "Voice.Void.3_1"},
		{2, "Voice.Void.3_2"},
		{3, "Voice.Void.4_1"},
		{4, "Voice.Void.5_1"},
		{5, "Voice.Void.6_1"},		
	},
	["npc_dota_hero_ember_spirit"] = {
		{0, "Voice.Ember.1_1"},
		{0, "Voice.Ember.1_2"},
		{1, "Voice.Ember.2_1"},
		{1, "Voice.Ember.2_2"},
		{2, "Voice.Ember.3_1"},
		{2, "Voice.Ember.3_2"},
		{3, "Voice.Ember.4_1"},
		{4, "Voice.Ember.5_1"},
		{5, "Voice.Ember.6_1"},		
	},
	["npc_dota_hero_pudge"] = {
		{0, "Voice.Pudge.1_1"},
		{0, "Voice.Pudge.1_2"},
		{1, "Voice.Pudge.2_1"},
		{1, "Voice.Pudge.2_2"},
		{2, "Voice.Pudge.3_1"},
		{2, "Voice.Pudge.3_2"},
		{3, "Voice.Pudge.4_1"},
		{4, "Voice.Pudge.5_1"},
		{5, "Voice.Pudge.6_1"},		
	},
	["npc_dota_hero_hoodwink"] = {
		{0, "Voice.Hoodwink.1_1"},
		{0, "Voice.Hoodwink.1_2"},
		{1, "Voice.Hoodwink.2_1"},
		{1, "Voice.Hoodwink.2_2"},
		{2, "Voice.Hoodwink.3_1"},
		{2, "Voice.Hoodwink.3_2"},
		{3, "Voice.Hoodwink.4_1"},
		{4, "Voice.Hoodwink.5_1"},
		{5, "Voice.Hoodwink.6_1"},		
	},
	["npc_dota_hero_skeleton_king"] = {
		{0, "Voice.Wraith.1_1"},
		{0, "Voice.Wraith.1_2"},
		{1, "Voice.Wraith.2_1"},
		{1, "Voice.Wraith.2_2"},
		{2, "Voice.Wraith.3_1"},
		{2, "Voice.Wraith.3_2"},
		{3, "Voice.Wraith.4_1"},
		{4, "Voice.Wraith.5_1"},
		{5, "Voice.Wraith.6_1"},		
	},
	["npc_dota_hero_lina"] = {
		{0, "Voice.Lina.1_1"},
		{0, "Voice.Lina.1_2"},
		{1, "Voice.Lina.2_1"},
		{1, "Voice.Lina.2_2"},
		{2, "Voice.Lina.3_1"},
		{2, "Voice.Lina.3_2"},
		{3, "Voice.Lina.4_1"},
		{4, "Voice.Lina.5_1"},
		{5, "Voice.Lina.6_1"},		
	},
	["npc_dota_hero_troll_warlord"] = {
		{0, "Voice.Troll.1_1"},
		{0, "Voice.Troll.1_2"},
		{1, "Voice.Troll.2_1"},
		{1, "Voice.Troll.2_2"},
		{2, "Voice.Troll.3_1"},
		{2, "Voice.Troll.3_2"},
		{3, "Voice.Troll.4_1"},
		{4, "Voice.Troll.5_1"},
		{5, "Voice.Troll.6_1"},		
	},
	["npc_dota_hero_axe"] = {
		{0, "Voice.Axe.1_1"},
		{0, "Voice.Axe.1_2"},
		{1, "Voice.Axe.2_1"},
		{1, "Voice.Axe.2_2"},
		{2, "Voice.Axe.3_1"},
		{2, "Voice.Axe.3_2"},
		{3, "Voice.Axe.4_1"},
		{4, "Voice.Axe.5_1"},
		{5, "Voice.Axe.6_1"},	
	},
	["npc_dota_hero_alchemist"] = {
		{0, "Voice.Alch.1_1"},
		{0, "Voice.Alch.1_2"},
		{1, "Voice.Alch.2_1"},
		{1, "Voice.Alch.2_2"},
		{2, "Voice.Alch.3_1"},
		{2, "Voice.Alch.3_2"},
		{3, "Voice.Alch.4_1"},
		{4, "Voice.Alch.5_1"},
		{5, "Voice.Alch.6_1"},		
	},
	["npc_dota_hero_ogre_magi"] = {
		{0, "Voice.Ogre.1_1"},
		{0, "Voice.Ogre.1_2"},
		{1, "Voice.Ogre.2_1"},
		{1, "Voice.Ogre.2_2"},
		{2, "Voice.Ogre.3_1"},
		{2, "Voice.Ogre.3_2"},
		{3, "Voice.Ogre.4_1"},
		{4, "Voice.Ogre.5_1"},
		{5, "Voice.Ogre.6_1"},		
	},
	["npc_dota_hero_antimage"] = {
		{0, "Voice.Anti.1_1"},
		{0, "Voice.Anti.1_2"},
		{1, "Voice.Anti.2_1"},
		{1, "Voice.Anti.2_2"},
		{2, "Voice.Anti.3_1"},
		{2, "Voice.Anti.3_2"},
		{3, "Voice.Anti.4_1"},
		{4, "Voice.Anti.5_1"},
		{5, "Voice.Anti.6_1"},
	},
	["npc_dota_hero_primal_beast"] = {
		{0, "Voice.Beast.1_1"},
		{0, "Voice.Beast.1_2"},
		{1, "Voice.Beast.2_1"},
		{1, "Voice.Beast.2_2"},
		{2, "Voice.Beast.3_1"},
		{2, "Voice.Beast.3_2"},
		{3, "Voice.Beast.4_1"},
		{4, "Voice.Beast.5_1"},
		{5, "Voice.Beast.6_1"},
	},
	["npc_dota_hero_marci"] = {
		{0, "Voice.Marci.1_1"},
		{0, "Voice.Marci.1_2"},
		{1, "Voice.Marci.2_1"},
		{1, "Voice.Marci.2_2"},
		{2, "Voice.Marci.3_1"},
		{2, "Voice.Marci.3_2"},
		{3, "Voice.Marci.4_1"},
		{4, "Voice.Marci.5_1"},
		{5, "Voice.Marci.6_1"},
	},
	["npc_dota_hero_templar_assassin"] = {
		{0, "Voice.Templar.1_1"},
		{0, "Voice.Templar.1_2"},
		{1, "Voice.Templar.2_1"},
		{1, "Voice.Templar.2_2"},
		{2, "Voice.Templar.3_1"},
		{2, "Voice.Templar.3_2"},
		{3, "Voice.Templar.4_1"},
		{4, "Voice.Templar.5_1"},
		{5, "Voice.Templar.6_1"},
	},
	["npc_dota_hero_bloodseeker"] = {
		{0, "Voice.Blood.1_1"},
		{0, "Voice.Blood.1_2"},
		{1, "Voice.Blood.2_1"},
		{1, "Voice.Blood.2_2"},
		{2, "Voice.Blood.3_1"},
		{2, "Voice.Blood.3_2"},
		{3, "Voice.Blood.4_1"},
		{4, "Voice.Blood.5_1"},
		{5, "Voice.Blood.6_1"},
	},
	["npc_dota_hero_monkey_king"] = {
		{0, "Voice.Monkey.1_1"},
		{0, "Voice.Monkey.1_2"},
		{1, "Voice.Monkey.2_1"},
		{1, "Voice.Monkey.2_2"},
		{2, "Voice.Monkey.3_1"},
		{2, "Voice.Monkey.3_2"},
		{3, "Voice.Monkey.4_1"},
		{4, "Voice.Monkey.5_1"},
		{5, "Voice.Monkey.6_1"},
	},
	["npc_dota_hero_mars"] = {
		{0, "Voice.Mars.1_1"},
		{0, "Voice.Mars.1_2"},
		{1, "Voice.Mars.2_1"},
		{1, "Voice.Mars.2_2"},
		{2, "Voice.Mars.3_1"},
		{2, "Voice.Mars.3_2"},
		{3, "Voice.Mars.4_1"},
		{4, "Voice.Mars.5_1"},
		{5, "Voice.Mars.6_1"},
	},
	["npc_dota_hero_zuus"] = {
		{0, "Voice.Zuus.1_1"},
		{0, "Voice.Zuus.1_2"},
		{1, "Voice.Zuus.2_1"},
		{1, "Voice.Zuus.2_2"},
		{2, "Voice.Zuus.3_1"},
		{2, "Voice.Zuus.3_2"},
		{3, "Voice.Zuus.4_1"},
		{4, "Voice.Zuus.5_1"},
		{5, "Voice.Zuus.6_1"},
	},
	["npc_dota_hero_leshrac"] = {
		{0, "Voice.Leshrac.1_1"},
		{0, "Voice.Leshrac.1_2"},
		{1, "Voice.Leshrac.2_1"},
		{1, "Voice.Leshrac.2_2"},
		{2, "Voice.Leshrac.3_1"},
		{2, "Voice.Leshrac.3_2"},
		{3, "Voice.Leshrac.4_1"},
		{4, "Voice.Leshrac.5_1"},
		{5, "Voice.Leshrac.6_1"},
	},
	["npc_dota_hero_crystal_maiden"] = {
		{0, "Voice.Maiden.1_1"},
		{0, "Voice.Maiden.1_2"},
		{1, "Voice.Maiden.2_1"},
		{1, "Voice.Maiden.2_2"},
		{2, "Voice.Maiden.3_1"},
		{2, "Voice.Maiden.3_2"},
		{3, "Voice.Maiden.4_1"},
		{4, "Voice.Maiden.5_1"},
		{5, "Voice.Maiden.6_1"},
	},
	["npc_dota_hero_snapfire"] = {
		{0, "Voice.Snapfire.1_1"},
		{0, "Voice.Snapfire.1_2"},
		{1, "Voice.Snapfire.2_1"},
		{1, "Voice.Snapfire.2_2"},
		{2, "Voice.Snapfire.3_1"},
		{2, "Voice.Snapfire.3_2"},
		{3, "Voice.Snapfire.4_1"},
		{4, "Voice.Snapfire.5_1"},
		{5, "Voice.Snapfire.6_1"},
	},


	["npc_dota_hero_sven"] = {
		{0, "Voice.Sven.1_1"},
		{0, "Voice.Sven.1_2"},
		{1, "Voice.Sven.2_1"},
		{1, "Voice.Sven.2_2"},
		{2, "Voice.Sven.3_1"},
		{2, "Voice.Sven.3_2"},
		{3, "Voice.Sven.4_1"},
		{4, "Voice.Sven.5_1"},
		{5, "Voice.Sven.6_1"},
	},

	["npc_dota_hero_sniper"] = {
		{0, "Voice.Sniper.1_1"},
		{0, "Voice.Sniper.1_2"},
		{1, "Voice.Sniper.2_1"},
		{1, "Voice.Sniper.2_2"},
		{2, "Voice.Sniper.3_1"},
		{2, "Voice.Sniper.3_2"},
		{3, "Voice.Sniper.4_1"},
		{4, "Voice.Sniper.5_1"},
		{5, "Voice.Sniper.6_1"},
	},


	["npc_dota_hero_muerta"] = {
		{0, "Voice.Muerta.1_1"},
		{0, "Voice.Muerta.1_2"},
		{1, "Voice.Muerta.2_1"},
		{1, "Voice.Muerta.2_2"},
		{2, "Voice.Muerta.3_1"},
		{2, "Voice.Muerta.3_2"},
		{3, "Voice.Muerta.4_1"},
		{4, "Voice.Muerta.5_1"},
		{5, "Voice.Muerta.6_1"},
	},

	["npc_dota_hero_pangolier"] = {
		{0, "Voice.Pangolier.1_1"},
		{0, "Voice.Pangolier.1_2"},
		{1, "Voice.Pangolier.2_1"},
		{1, "Voice.Pangolier.2_2"},
		{2, "Voice.Pangolier.3_1"},
		{2, "Voice.Pangolier.3_2"},
		{3, "Voice.Pangolier.4_1"},
		{4, "Voice.Pangolier.5_1"},
		{5, "Voice.Pangolier.6_1"},
	},

	["npc_dota_hero_arc_warden"] = {
		{0, "Voice.Arc.1_1"},
		{0, "Voice.Arc.1_2"},
		{1, "Voice.Arc.2_1"},
		{1, "Voice.Arc.2_2"},
		{2, "Voice.Arc.3_1"},
		{2, "Voice.Arc.3_2"},
		{3, "Voice.Arc.4_1"},
		{4, "Voice.Arc.5_1"},
		{5, "Voice.Arc.6_1"},
	},
	["npc_dota_hero_invoker"] = {
		{0, "Voice.Invoker.1_1"},
		{0, "Voice.Invoker.1_2"},
		{1, "Voice.Invoker.2_1"},
		{1, "Voice.Invoker.2_2"},
		{2, "Voice.Invoker.3_1"},
		{2, "Voice.Invoker.3_2"},
		{3, "Voice.Invoker.4_1"},
		{4, "Voice.Invoker.5_1"},
		{5, "Voice.Invoker.6_1"},
	},
	["npc_dota_hero_razor"] = {
		{0, "Voice.Razor.1_1"},
		{0, "Voice.Razor.1_2"},
		{1, "Voice.Razor.2_1"},
		{1, "Voice.Razor.2_2"},
		{2, "Voice.Razor.3_1"},
		{2, "Voice.Razor.3_2"},
		{3, "Voice.Razor.4_1"},
		{4, "Voice.Razor.5_1"},
		{5, "Voice.Razor.6_1"},
	},
	["npc_dota_hero_sand_king"] = {
		{0, "Voice.Sand.1_1"},
		{0, "Voice.Sand.1_2"},
		{1, "Voice.Sand.2_1"},
		{1, "Voice.Sand.2_2"},
		{2, "Voice.Sand.3_1"},
		{2, "Voice.Sand.3_2"},
		{3, "Voice.Sand.4_1"},
		{4, "Voice.Sand.5_1"},
		{5, "Voice.Sand.6_1"},
	},
}

CustomNetTables:SetTableValue("custom_sounds", "sounds", Sound_list)

function chat_wheel:SelectChatWheel(keys)
	if keys.PlayerID == nil then return end
	local id_chatwheel = tostring(keys.id)
	local item_chatwheel = tostring(keys.sound_name)

	local player_table = CustomNetTables:GetTableValue('players_chat_wheel', tostring(keys.PlayerID))
	local player_chat_wheel_change = {}
	if player_table then
		for k, v in pairs(player_table) do
		      player_chat_wheel_change[k] = v
		end
	end

	local sub_data = CustomNetTables:GetTableValue('sub_data', tostring(keys.PlayerID))

	if sub_data and sub_data.chat_wheel then 
		sub_data.chat_wheel[id_chatwheel] = item_chatwheel
	end


	player_chat_wheel_change[id_chatwheel] = item_chatwheel
	player_table = player_chat_wheel_change
	CustomNetTables:SetTableValue('players_chat_wheel', tostring(keys.PlayerID), player_table)
	CustomNetTables:SetTableValue('sub_data', tostring(keys.PlayerID), sub_data)
end

function chat_wheel:SetDefaultSound(id)
    local sounds_random = table.random_some(Sound_list["general_ru"], 8)
    local player_chat_wheel_change = {}
    local player_table = CustomNetTables:GetTableValue("sub_data", tostring(id))


    for i=1,8 do
        if player_table then
            if player_table.chat_wheel then

                if player_table.chat_wheel[tostring(i)] and player_table.chat_wheel[tostring(i)] ~= 0 and player_table.chat_wheel[tostring(i)] ~= "0" then
                    player_chat_wheel_change[i] = player_table.chat_wheel[tostring(i)]
                else
                 --   player_chat_wheel_change[i] = sounds_random[i][1]
                end
            else
           --     player_chat_wheel_change[i] = sounds_random[i][1]
            end
        else
          --  player_chat_wheel_change[i] = sounds_random[i][1]
        end
    end

    CustomNetTables:SetTableValue('players_chat_wheel', tostring(id), player_chat_wheel_change)
end

function chat_wheel:SelectHeroVO(keys)
	if keys.PlayerID == nil then return end
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local sound_name = keys.num
	local hero_name = ""
	local hero = GlobalHeroes[keys.PlayerID]
	if hero then
		hero_name = hero:GetUnitName()
	end

	local tier_hero = chat_wheel:GetTier(hero_name, keys.PlayerID)
	local sound_string = "#"..keys.name
	local phase_tier = chat_wheel:GetPhraseTier(sound_name, hero_name)

	local table_data = CustomNetTables:GetTableValue("sub_data", tostring(keys.PlayerID))

	if table_data and table_data.subscribed == 0
	 or (table_data.heroes_data[hero_name] and table_data.heroes_data[hero_name].has_level == 0) then 
		return 
	end

	if chat_wheel:HasHeroTier(tier_hero, sound_name, hero_name) then
		if player.sound_use_one == nil then
		    player.sound_use_one = 0
		end

		if player.sound_use_two == nil then
		    player.sound_use_two = 0
		end
		
		if (player.sound_use_one and player.sound_use_one > 0) and (player.sound_use_two and player.sound_use_two > 0) then
		  	local player = PlayerResource:GetPlayer(keys.PlayerID)
		  	if player then
		      	local cooldown_sound = math.max(player.sound_use_one, player.sound_use_two)
		      	CustomGameEventManager:Send_ServerToPlayer(player, "panorama_cooldown_error", {message="#dota_sound_error", time=cooldown_sound})
		  	end
		  	EmitSoundOnClient("General.Cancel", player)
		  	return
		end

	  	if player.sound_use_one > 0 then

	  		local cd = 30
	  		if test then 
	  			cd = 0
	  		end

	      	player.sound_use_two = cd
	      	Timers:CreateTimer({
			    useGameTime = false,
			    endTime = 1,
			    callback = function()
			      	if player.sound_use_two <= 0 then return nil end
    		        player.sound_use_two = player.sound_use_two - 1
    		        return 1
			    end
			})
	  	else

	  		local cd = 30
	  		if test then 
	  			cd = 0
	  		end

	      	player.sound_use_one = cd
	      	Timers:CreateTimer({
			    useGameTime = false,
			    endTime = 1,
			    callback = function()
			      	if player.sound_use_one <= 0 then return nil end
    		        player.sound_use_one = player.sound_use_one - 1
    		        return 1
			    end
			})
	  	end

		CustomGameEventManager:Send_ServerToAllClients( 'chat_dota_sound', {hero_name = hero_name, player_id = keys.PlayerID, sound_name = sound_string, sound_name_global = sound_name, tier = tier_hero, phase_tier = phase_tier})
	else
		EmitSoundOnClient("General.Cancel", player)
	end
end

function chat_wheel:HasHeroTier(tier, sound, hero_name)
	for _, sound_data in pairs(Sound_list[hero_name]) do
		if sound_data[2] == sound then
			print(tier, sound_data[1])
			if tier >= sound_data[1] then
				return true
			else
				return false
			end 
		end
	end
	return false
end

function chat_wheel:GetPhraseTier(sound, hero_name)
	for _, sound_data in pairs(Sound_list[hero_name]) do
		if sound_data[2] == sound then
			return sound_data[1] 
		end
	end
	return 0
end

function chat_wheel:GetTier(hero_name, id)
	local table_data = CustomNetTables:GetTableValue("sub_data", tostring(id))
	if table_data then
		if table_data["heroes_data"][hero_name] then
			print(table_data["heroes_data"][hero_name]["tier"])
			return table_data["heroes_data"][hero_name]["tier"]
		end
	end
	return 0
end




function chat_wheel:SelectVO(keys)
	if keys.PlayerID == nil then return end


	local table_data = CustomNetTables:GetTableValue("sub_data", tostring(keys.PlayerID))
	if not table_data then
		return
	end
	
	local player = PlayerResource:GetPlayer(keys.PlayerID)

	local hero_name = ""
	local hero =  GlobalHeroes[keys.PlayerID]
	if hero then
		hero_name = hero:GetUnitName()
	end

	local sound_string = ""
	local sound_id = keys.num
	local sound_name = ""


	if HasDonateItem(keys.PlayerID, sound_id) == false then
        return
    end

	for _, sound_data in pairs(Sound_list["general_ru"]) do
		if sound_data[1] == sound_id then
			sound_string = "#"..sound_data[2]
			sound_name = sound_data[2]
		end
	end

	for _, sound_data in pairs(Sound_list["general_eng"]) do
		if sound_data[1] == sound_id then
			sound_string = "#"..sound_data[2]
			sound_name = sound_data[2]
		end
	end

	for _, sound_data in pairs(Sound_list["general_other"]) do
        if sound_data[1] == sound_id then
            sound_string = "#"..sound_data[2]
            sound_name = sound_data[2]
        end
    end

	if sound_string == "" then
		EmitSoundOnClient("General.Cancel", player)
		return
	end

	local tier_hero = chat_wheel:GetTier(hero_name, keys.PlayerID)

	if player.sound_use_one == nil then
	    player.sound_use_one = 0
	end

	if player.sound_use_two == nil then
	    player.sound_use_two = 0
	end
	
	if (player.sound_use_one and player.sound_use_one > 0) and (player.sound_use_two and player.sound_use_two > 0) then
	  	local player = PlayerResource:GetPlayer(keys.PlayerID)
	  	if player then
	     	local cooldown_sound = math.max(player.sound_use_one, player.sound_use_two)
	      	CustomGameEventManager:Send_ServerToPlayer(player, "panorama_cooldown_error", {message="#dota_sound_error", time=cooldown_sound})
	  	end
	  	EmitSoundOnClient("General.Cancel", player)
	  	return
	end

  	if player.sound_use_one > 0 then

	  	local cd = 30
	  	if test then 
	  		cd = 0
	  	end

      	player.sound_use_two = cd
      	Timers:CreateTimer({
		    useGameTime = false,
		    endTime = 1,
		    callback = function()
		      	if player.sound_use_two <= 0 then return nil end
		        player.sound_use_two = player.sound_use_two - 1
		        return 1
		    end
		})
  	else

	  	local cd = 30
	  	if test then 
	  		cd = 0
	  	end
	  	
      	player.sound_use_one = cd
      	Timers:CreateTimer({
		    useGameTime = false,
		    endTime = 1,
		    callback = function()
		      	if player.sound_use_one <= 0 then return nil end
		        player.sound_use_one = player.sound_use_one - 1
		        return 1
		    end
		})
  	end

	CustomGameEventManager:Send_ServerToAllClients( 'chat_dota_sound', {hero_name = hero_name, player_id = keys.PlayerID, sound_name = sound_string, sound_name_global = sound_name, tier = tier_hero})
end

function table.count(t)
    local c = 0
    for _ in pairs(t) do
        c = c + 1
    end

    return c
end

function table.contains(t, v)
    for _, _v in pairs(t or {}) do
        if _v == v then
            return true
        end
    end
end

function table.has_element_fit(t, func)
    for k, v in pairs(t) do
        if func(t, k, v) then
            return k, v
        end
    end
end

function table.findkey(t, v)
    for k, _v in pairs(t) do
        if _v == v then
            return k
        end
    end
end

function table.shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function table.deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value)
        end
        setmetatable(copy, table.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function table.random(t)
    local keys = {}
    for k, _ in pairs(t) do
        table.insert(keys, k)
    end
    local key = keys[RandomInt(1, # keys)]
    return t[key], key
end

function table.shuffle(tbl)
    -- 必须是一个hash表
    local t = table.shallowcopy(tbl)
    for i = # t, 2, - 1 do
        local j    = RandomInt(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function table.random_some(t, count)
    local key_table = table.make_key_table(t)
    key_table       = table.shuffle(key_table)
    local r         = {}
    for i = 1, count do
        local key = key_table[i]
        table.insert(r, t[key])
    end
    return r
end

-- 随机选择一个元素，带条件的
function table.random_with_condition(t, func)
    local keys = {}
    for k, v in pairs(t) do
        if func(t, k, v) then
            table.insert(keys, k)
        end
    end

    local key = keys[RandomInt(1, # keys)]
    return t[key], key
end

-- 带权重的选择某个元素
-- 权重表达的几种方式，获取顺序也是这个顺序
-- 1. GetWeight函数
-- 2. Weight变量
-- 3. 第二个元素
-- 4. 如果没有定义，默认为0
function table.random_with_weight(t)
    local weight_table = {}
    local total_weight = 0
    for k, v in pairs(t) do
        local w
        if v.GetWeight then
            w = v:GetWeight()
        else
            w = v.Weight or v[2] or 0
        end
        total_weight = total_weight + w
        table.insert(weight_table, { key = k, total_weight = total_weight })
    end

    local randomValue = RandomFloat(0, total_weight)
    for i = 1, # weight_table do
        if weight_table[i].total_weight >= randomValue then
            local key = weight_table[i].key
            return t[key]
        end
    end
end

-- 过滤一个表
-- 这个表会重新创建一个新的表
function table.filter(t, condition)
    local r = {}
    for k, v in pairs(t) do
        if condition(t, k, v) then
            r[k] = v
        end
    end
    return r
end

-- 将所有key作为一个table返回
function table.make_key_table(t)
    local r = {}
    for k, _ in pairs(t) do
        table.insert(r, k)
    end
    return r
end

-- 如果两个表每个key对应的值都相等，那么认为这两个表相等
function table.is_equal(t1, t2)
    for k, v in pairs(t1) do
        if t2[k] ~= v then
            return false
        end
    end
    return true
end

function table.random_key(t)
    return table.random(table.make_key_table(t))
end

function table.print(t)
    for k, v in pairs(t) do
        print(k, v)
    end
end

-- 只保留所有的字符串和数字，并且把所有的数字都转换成字符串
-- 避免在nettable传输过程中产生的bug
function table.safe_table(t)
    local r = {}
    for k,v in pairs(t) do
        if type(v) == "table" and k ~= "_M" then -- 避免module的死循环
            r[k] = table.safe_table(v)
        elseif type(v) == "string" or type(v) == "number" then
            r[k] = tostring(v)
        end
    end

    return r
end

---将一个表保存为KV文件
---@param tbl table 要输出的表
---@param filePath string 输出的文件路径
---@param headerName string 标题头，默认为unknown_header
function table.save_as_kv_file(tbl, filePath, headerName, utf16)
    local file = io.open(filePath, "w")
    if utf16 then
        file:write(utf8_to_utf16le("\"" .. (headerName or "unknown_header") .. "\"\n"))
        file:write(utf8_to_utf16le('{\n'))
        for _, line in pairs(table.to_kv_lines(tbl, 1)) do
            file:write(utf8_to_utf16le(line .. "\n"))
        end
        file:write(utf8_to_utf16le('}\n'))
    else
        file:write("\"" .. (headerName or "unknown_header") .. "\"\n")
        file:write('{\n')
        for _, line in pairs(table.to_kv_lines(tbl, 1)) do
            file:write(line .. "\n")
        end
        file:write('}\n')
    end

    file:flush()
    file:close()
end

function table.to_kv_lines(tbl, tabCount)
    tabCount = tabCount or 0
    local result = {}
    local preTabs = ""
    for i = 1, tabCount do
        preTabs = preTabs .. "\t"
    end
    for k,v in pairs(tbl) do
        if type(v) == "table" then
            table.insert(result, preTabs .. "\"" .. tostring(k) .. "\"")
            table.insert(result, preTabs .. "{")
            local lines = table.to_kv_lines(v, tabCount + 1)
            for _, line in pairs(lines) do
                table.insert(result, preTabs .. line)
            end
            table.insert(result, preTabs .. "}")
        else
            table.insert(result, string.format("%s\"%s\"\t\t\"%s\"", preTabs,k,v))
        end
    end
    return result
end

function table.join(...)
    local arg = {...}
    local r = {}
    for _, t in pairs(arg) do
        if type(t) == "table" then
            for _, v in pairs(t) do
                table.insert(r, v)
            end
        else
            -- 如果是数值，直接插入到表
            table.insert(r, t)
        end
    end

    return r
end

-- 获取一个表的反向表
function table.reverse(tbl)
    local t = {}
    for k, v in pairs(tbl) do
        t[v] = k
    end
    return t
end


-- remove item
function table.remove_item(tbl,item)
    local i,max=1,#tbl
    while i<=max do
        if tbl[i] == item then
            table.remove(tbl,i)
            i = i-1
            max = max-1
        end
        i= i+1
    end
    return tbl
end

-- remove one item
function table.pop_back_item(tbl,item)
    for i = #tbl, 1,-1 do
       if tbl[i] == item then
            table.remove(tbl,i)
            break
       end
    end
    return tbl
end