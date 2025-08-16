
if dota1x6 == nil then
    _G.dota1x6 = class({})
end


_G.test_pick_stage = false
_G.Time_to_pick_Hero = 25
_G.Time_to_pick_Base = 20

_G.pro_mod = false
_G.test = true and IsInToolsMode()

_G.start_wave = 0
_G.timer_test = 451111
_G.timer_test_start = 15111
_G.test_wave = 0
_G.DontUpgradeCreeps = false

_G.PlayerCount = 0
_G.TeamCount = 0
_G.TeamRegistred = {}

local couriers_spawned = {}

dota1x6.mob_thinker = nil
dota1x6.event_thinker = nil
_G.teleports = {}
_G.waves = {}
_G.boss_waves = {}
_G.players = {}
_G.towers = {}
_G.timer = 0
_G.Deaths = 0

_G.GAME_STARTED = false
_G.SpawnedPlayers = 0
_G.ReadyPlayers = 0
_G.GlobalHeroes = {}

Rating_Table = {40,30,10,-10,-30,-40}
Rating_Table_Max = {20,15,5,-5,-15,-20}

_G.Wave_boss_number = {5,21}
_G.Purple_Wave =
{
	[3] = true,
	[10] = true,
}

_G.upgrade_orange = 17

_G.PreGame_time = 30

_G.game_start = false
_G.Game_end = false
	
_G.new_round = false

_G.duel_start = 5


_G.duel_timer = 90
_G.round_timer = 5
_G.duel_timer_final = 80 + duel_start
_G.duel_timer_normal = 45 + duel_start
_G.field_stun = 0.5
_G.duel_push_time = 10
_G.duel_push_teleport = 6
_G.duel_start_wave = 11
_G.duel_last_field = "1"

_G.Target_timer = RandomInt(13*60, 17*60)
_G.Target_proc = false
_G.Target_duration = 150
_G.Target_gold_min = 0
_G.Target_gold = 0
_G.Target_radius = 1500

_G.Streak_k = 0.25

_G.Active_Roshan = false
_G.RoshanTimers = {1260,1800,2400,3000,3600,4200,4800,5400,6000,6600,7200,7800,8400,9000,9600,10200,10800,11400,12000,12600,13200,13800,14400,15000,15600,16200,16800,17400,18000,18600,19200,19800,20400,21000,21600,22200,22800,23400,24000,24600,25200,25800,26400,27000,27600,28200,28800,29400,30000,30600,31200,31800,32400,33000,33600,34200,34800,35400,36000,36600,37200,37800,38400,39000,39600,40200,40800,41400,42000,42600,43200,43800,44400,45000,45600,46200,46800,47400,48000,48600,49200,49800,50400,51000,51600,52200,52800,53400,54000,54600,55200,55800,56400,57000,57600,58200,58800,59400,60000,60600,61200}
_G.roshan_number = 1
_G.roshan_timer = 1
_G.roshan_alert = 60

_G.test_patrol = false
_G.patrol_timer = 0
_G.patrol_timer_max = 35
_G.patrol_timer_max_2 = 35
_G.patrol_timer_max_2_duel = 45
_G.patrol_wave = 5
_G.patrol_wave_2 = 13
_G.patrol_second_init = false 
_G.patrol_first_init = false
_G.tormentor_gold = 500
_G.tormentor_wave = 12
_G.tormentor_inc = 3
_G.patrol_launched = false
dota1x6.patrol_dontgo_radiant = false
dota1x6.patrol_dontgo_dire = false

_G.avg_rating = 0
_G.lobby_rating = {}
_G.lobby_rating_change = {}
_G.lobby_double_rating = {}

_G.DeathTimer = 2
_G.StartDeathTimer = 5
_G.DeathTimer_PerWave = 2
_G.Short_Respawn_target = 10
_G.DeathTimerDuo = 0.25

_G.lownet_gold = 1
_G.lownet_purple = 2
_G.lownet_blue = 2
_G.lownet_duration = 180

_G.teleport_cd = 20
_G.teleport_range = 350

_G.UpgradeGray = 0.2
_G.BlueMorePoints = 0.25

_G.GoldComeback = 3
_G.MaxTimer = 0

_G.StartPurple = 2
_G.PlusPurple = 1
_G.PlusPurpleMore = 2
_G.PlusPurpleThrash = 4

_G.auto_pick_talent = 120

_G.low_net_gold = 90
_G.low_net_waves = {[RandomInt(8, 10)] = true, [11 + RandomInt(0,1)*2] = true,}
_G.low_net_max = 2
_G.more_gold_wave = 5

_G.StartBlue = 45
_G.PlusBlue = 20

_G.Necro_Timer = 20

_G.PortalDelay = 5
_G.NeutralChance = 12
_G.MaxNeutral = 4

_G.dont_end_pick_hero = false
_G.dont_end_game = false and test

_G.creeps_team_health = 2
_G.creeps_team_damage = 1.3
_G.tormentor_team_health = 1.5

_G.enable_pause = false
_G.only_night = false
_G.healing = true

_G.push_timer = 900
_G.push_alert = false

_G.main_timer_interval = 1
_G.PushReduce_duration = 5

_G.Pause_Time = 30
_G.Pause_Time_Pro = 60

_G.Trap_Duration = 35

_G.ValidGame_Time = 900

_G.kill_net_gold = 200
_G.more_gold_radius = 900

_G.bounty_timer = 0
_G.bounty_max_timer = 120
_G.bounty_init = false 
_G.bounty_start = 120
_G.bounty_gold_init = 100
_G.bounty_gold_per_minute = 4.2
_G.bounty_exp_init = 150
_G.bounty_exp_per_minute = 6
_G.bounty_blue_init = 20
_G.bounty_blue_per_minute = 0.7

_G.muerta_quest_max = 30
_G.muerta_quest_max_start = 20
_G.muerta_quest_timer = 0
_G.muerta_quest_phase = 0
_G.muerta_quest_active = false
_G.muerta_quest_hero = nil
_G.muerta_quest_creep_count = 1
_G.muerta_quest_creeps = {"npc_muerta_ogre", "npc_muerta_satyr", "npc_muerta_ursa", "npc_muerta_centaur"}


_G.Grenade_Creeps_Max = 6
_G.Grenade_Max = 4
_G.Grenade_Timer = 1200
_G.Grenade_start = false

_G.Player_damage_max = 4
_G.Player_damage_inc = 10
_G.Player_damage_time = 900

_G.LowPriorityTime = 600
_G.SafeToLeave = false
_G.SafeToLeave_reason = 0
_G.SafeToLeave_alert = false

_G.DoubleRating_timer = 25
_G.DoubleRating_active = true

_G.PartyTable = {}

_G.After_Lich = false

_G.ACT_DOTA_SPAWN_STATUE = ACT_DOTA_SPAWN_STATUE or 1766

_G.No_end_screen = {}

_G.RATING_CHANGE_BASE = { 40, 30, 10, -10, -30, -40,}

_G.glyph_cd = 360
_G.glyph_cd_mid = 240
_G.glyph_duration = 5

_G.sub_places_points_solo = {14,12,10,8,6,4}
_G.sub_places_points_duo = {12,10,8,6,4}
_G.sub_random_inc = 1.15
_G.sub_kills_inc = 1
_G.sub_kills_max = 10
_G.sub_towers_inc = 4
_G.sub_bounty_inc = 0.5
_G.sub_bounty_max = 10
_G.sub_points_max = 500
_G.sub_level_thresh =  {50,60,70,80, 100,120,140,160,180,200, 230,260,290,320,350,380, 420,460,500,540,580,620,680, 800,900,1000,1100,1200, 1500}
_G.sub_place_exp_solo = {40,30,25,20,15,10}
_G.sub_place_exp_duo = {35,25,20,15,10}
_G.sub_level_max = 30
_G.level_thresh = {6,12,18,25,30}


_G.shop_daily_shards_min = 500 * 1000
_G.shop_daily_shards_max = 1000 * 1000
_G.shop_daily_shards_cd = 86400
_G.shop_double_rating_cd = 86400 * 3
_G.shop_free_vote_cd = 86400
_G.shop_item_build_cd = 86400
_G.shop_quests_cd = 86400 * 7


_G.TestMode = false
_G.TestMode_players = 2
_G.TimerStop = false
_G.WtfMode = false

_G.abandon_players = {}

_G.wrong_map_players = {}

_G.spell_cast_mods = {}
_G.spell_start_mods = {}
_G.death_mods = {}

_G.bounty_abs = {}
_G.hero_icons = {}

dota1x6.KillCount = 0

_G.SelectedHeroes = {}
_G.SelectedBases = {}
_G.SelectedQuests = {}

dota1x6.achivment_table = {}

dota1x6.goodwin_max = 33
dota1x6.goodwin_used = {}

dota1x6.current_wave = start_wave
dota1x6.go_wave = start_wave
dota1x6.go_boss_number = 0



require("util/safeguards")
require("events_protector")
require('addon_game_const')
require('addon_game_filter')
require('addon_game_utils')
require('chat_wheel')
require('server')
require('function')
require('timers')
require('spawn' )
require('upgrade')
require('start_quest')
require('hero_select')
require('vector_target')
require('patrol_main')
require('quests_table' )
require('chest_info' )
require("wearables_system/wearables_system")
require('shop')
require('talents_values')
require('addon_init')
require('test_mode')
require('rival_table' )
require('util/selection' )
require( 'resources')

_G.precache_items = require("precache_items")
_G.precache_units = require("precache_units")
_G.ChangeItemsCooldown = 5

_G.base_heroes_data =  require("base_heroes_data")

_G.arcana_sale = 0
_G.new_shop_heroes = {}


_G.ItemsTiming = 
{	
	[20] = false,
	[40] = false,
	[120] = false,
	[300] = false,
	[600] = false,
	[900] = false,
	[1200] = false,
	[1800] = false,
	[2400] = false
}




_G.duel_alert_init = false
_G.duel_alert_timer = 25
_G.duel_data = {}



function Precache(context)

for _,v in pairs(resources.Particles) do
	PrecacheResource( "particle", v, context )
end

for _,v in pairs(resources.Couriers) do
	PrecacheResource( "model", v, context )
end
PrecacheResource( "model", "custom/item_blue.vmdl", context )  
PrecacheResource( "model", "custom/item_orange.vmdl", context )     
PrecacheResource( "model", "custom/item_gray.vmdl", context )          
PrecacheResource( "model", "custom/item_purple.vmdl", context )      

PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_worg_small/n_creep_worg_small.vmdl", context )
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_vulture_b/n_creep_vulture_b.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_ghost_b/n_creep_ghost_b.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_forest_trolls/n_creep_forest_troll_berserker.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_harpy_a/n_creep_harpy_a.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_troll_dark_a/n_creep_troll_dark_a.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_forest_trolls/n_creep_forest_troll_berserker.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_centaur_lrg/n_creep_centaur_lrg.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_harpy_b/n_creep_harpy_b.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_forest_trolls/n_creep_forest_troll_high_priest.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_centaur_med/n_creep_centaur_med.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_small.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_gnoll/n_creep_gnoll.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_worg_large/n_creep_worg_large.vmdl", context )  
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_black_drake/n_creep_black_drake.vmdl", context )   
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_vulture_a/n_creep_vulture_a.vmdl", context )      
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_black_dragon/n_creep_black_dragon.vmdl", context ) 
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_beast/n_creep_beast.vmdl", context ) 
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_furbolg/n_creep_furbolg_disrupter.vmdl", context )    
PrecacheResource( "model", "models/heroes/attachto_ghost/attachto_ghost.vmdl", context )    
PrecacheResource( "model", "models/creeps/ice_biome/giant/ice_giant01.vmdl", context )     
PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_thunder_lizard/n_creep_thunder_lizard_big.vmdl", context ) 
PrecacheResource( "model", "models/props_gameplay/rune_goldxp.vmdl", context )   

for _,v in pairs(precache_items) do
	PrecacheItemByNameSync(v, context)
end

for _,v in pairs(precache_units) do
	PrecacheUnitByNameSync(v, context, -1)
end


PrecacheResource( "soundfile", "soundevents/vo_chat_wheel.vsndevts", context ) 
PrecacheResource( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer.vsndevts", context )
PrecacheResource( "soundfile", "soundevents/game_sounds_effects.vsndevts", context ) 
PrecacheResource( "soundfile", "soundevents/game_sounds_ui.vsndevts", context ) 
PrecacheResource( "soundfile", "soundevents/game_sounds_creeps.vsndevts", context ) 
PrecacheResource( "soundfile", "soundevents/game_sounds_pick_stage.vsndevts", context ) 

--PrecacheResource( "soundfile", "soundevents/game_sounds_ui_imported.vsndevts", context ) 
--PrecacheResource( "soundfile", "soundevents/soundevents_dota.vsndevts", context )
     
end


function dota1x6:PrecacheShopItems(name, context)
if wearables_system.is_hero_precached[name] then return end
wearables_system.is_hero_precached[name] = true

if base_heroes_data and base_heroes_data[name] then
	if base_heroes_data[name]["model"] then
		PrecacheResource( "model", base_heroes_data[name]["model"], context )
	end
	if base_heroes_data[name]["items"] then
		for item_name,_ in pairs(base_heroes_data[name]["items"]) do
		    PrecacheResource( "model", item_name, context )
		end
	end
	if base_heroes_data[name]["effects"] then
		for effect_name,_ in pairs(base_heroes_data[name]["effects"]) do
		    PrecacheResource( "particle", effect_name, context )
		end
	end
end

if wearables_system.items_data[name] == nil then return end

if PlayerCount > 1 then
	for pid, hero_table in pairs(wearables_system.selection_data) do
	    for hero_name, item_info in pairs(hero_table) do
	        if hero_name == name then
	            for slot, item_id in pairs(item_info) do
	                local item_info = wearables_system.items_data[name][item_id]
	                if item_info then
	                    if item_info["HeroModel"] ~= nil then
	                        PrecacheResource( "model", item_info["HeroModel"], context )
	                    end
	                    if item_info["ItemModel"] ~= nil then
	                        PrecacheResource( "model", item_info["ItemModel"], context )
	                    end
                        if item_info["OtherModelsPrecache"] ~= nil then
                            for __, info_vmdl in pairs(item_info["OtherModelsPrecache"]) do
	                            PrecacheResource( "model", info_vmdl, context )
                            end
	                    end
	                    if item_info["ParticlesItems"] ~= nil then
	                        for __, info_part in pairs(item_info["ParticlesItems"]) do
	                            PrecacheResource( "particle", info_part["ParticleName"], context )
	                        end
	                    end
	                    if item_info["ParticlesHero"] ~= nil then
	                        for __, info_part in pairs(item_info["ParticlesHero"]) do
                                print(info_part["ParticleName"])
	                            PrecacheResource( "particle", info_part["ParticleName"], context )
	                        end
	                    end
					    if item_info["ParticlesSkills"] ~= nil then
					        for _,name in pairs(item_info["ParticlesSkills"]) do
					            PrecacheResource( "particle", name, context )
					        end
					    end
	                end
	            end
	        end
	    end
	end
	print("Герой "..name.." запрекешен")
else
	local precache_this_units = require("wearables_system/donate_items/"..name)
	for _, info in pairs(precache_this_units) do
	    if info["HeroModel"] ~= nil then
	        PrecacheResource( "model", info["HeroModel"], context )
	    end
	    if info["ItemModel"] ~= nil then
	        PrecacheResource( "model", info["ItemModel"], context )
	    end
	    if info["ParticlesItems"] ~= nil then
	        for __, info_part in pairs(info["ParticlesItems"]) do
	            PrecacheResource( "particle", info_part["ParticleName"], context )
	        end
	    end
        if info["OtherModelsPrecache"] ~= nil then
            for __, info_vmdl in pairs(info["OtherModelsPrecache"]) do
                PrecacheResource( "model", info_vmdl, context )
            end
        end
	    if info["ParticlesHero"] ~= nil then
	        for __, info_part in pairs(info["ParticlesHero"]) do
	            PrecacheResource( "particle", info_part["ParticleName"], context )
	        end
	    end
	    if info["ParticlesSkills"] ~= nil then
	        for _,name in pairs(info["ParticlesSkills"]) do
	            PrecacheResource( "particle", name, context )
	        end
	    end
	end

	local precache_slots = require("wearables_system/donate_items/"..name.."_slots")

	for _, info in pairs(precache_slots) do
		for _,name in pairs(info) do 
	        PrecacheResource( "model", name, context )
		end 
	end
end

end 


-- Create the game mode when we activate
function Activate()

ListenToGameEvent( "player_disconnect", Dynamic_Wrap( hero_select, 'OnDisconnect' ), hero_select )
dota1x6:InitGameMode()
HTTP.FillOfflineServerData()
end


local AvailableTeams = {
    DOTA_TEAM_GOODGUYS,
    DOTA_TEAM_BADGUYS,
    DOTA_TEAM_CUSTOM_1,
    DOTA_TEAM_CUSTOM_2,
    DOTA_TEAM_CUSTOM_3,
    DOTA_TEAM_CUSTOM_4,
}



function dota1x6:PostMatchPoints(player)
if not IsServer() then return end
if not HTTP.IsValidGame(PlayerCount) then return end

local id = player:GetId()
local player_array = HTTP.playersData[id]

if not player_array then return end

local kills = player_array.kills_done
local towers = player_array.towers_destroyed
local runes = player_array.bounty_runes_picked

local place = HTTP.playersData[id].place
local table_data = CustomNetTables:GetTableValue("sub_data", tostring(id))

if not table_data then return end

local quest_shards = 0
local quest_exp = 0

if (player:GetQuest() ~= nil) and player:QuestCompleted() and place <= win_place then 
	quest_exp = player.quest.exp and player.quest.exp or 0
	quest_shards = player.quest.shards and player.quest.shards or 0
end

local random_k = 1
if player_array.randomed == 1 then 
	random_k = sub_random_inc
end

local sub_places_points = sub_places_points_solo
local sub_place_exp = sub_place_exp_solo
if not IsSoloMode() then
	sub_place_exp = sub_place_exp_duo
	sub_places_points = sub_places_points_duo
end

local points = math.min(kills*sub_kills_inc, sub_kills_max) + sub_places_points[place] + towers*sub_towers_inc + math.floor(math.min(runes*sub_bounty_inc, sub_bounty_max))

points = math.floor(points * random_k)

if table_data.subscribed == 0 then 
	points = math.min(math.max(sub_points_max - table_data.points, 0), points)
end

if GameRules:GetDOTATime(false, false) < push_timer then 
	points = 0
end

HTTP.AddPlayerMatchShardsReceipt( id, points, 'endGame')
HTTP.AddPlayerMatchShardsReceipt( id, quest_shards, 'questCompleted')

points = points + quest_shards

table_data.points = table_data.points + points

local level = table_data.heroes_data[player:GetUnitName()].level
local exp = table_data.heroes_data[player:GetUnitName()].exp

if table_data.subscribed == 1 and level < sub_level_max then 

	local max_exp = sub_level_thresh[level]
	local exp_inc = math.floor(sub_place_exp[place]*random_k)

	if GameRules:GetDOTATime(false, false) < push_timer then 
		exp_inc = 0
	end

	HTTP.playersData[id].dpHeroMatchXp = exp_inc
	HTTP.playersData[id].dpHeroQuestXp = quest_exp

	exp_inc = exp_inc + quest_exp


	local exp_left = exp_inc

	repeat 
		if (level < 30) then 

			max_exp = sub_level_thresh[level]

			if (exp_left >= (max_exp - exp)) then 
				exp_left = exp_left -(max_exp - exp)
				level = level + 1
				exp = 0
			else 
				exp = exp + exp_left
				exp_left = 0
			end
		else 
			exp_left = 0
			exp = 0
		end

	until exp_left < 1

	table_data.heroes_data[player:GetUnitName()].exp = exp 
	table_data.heroes_data[player:GetUnitName()].level = level
end

CustomNetTables:SetTableValue("sub_data", tostring(id), table_data)
end




function dota1x6:InitGameMode()

GameRules:SetCustomGameSetupAutoLaunchDelay(0)

local team_size = players_in_team
if team_size == 2 then
	low_net_max = 1
	GameRules:SetCustomGameSetupAutoLaunchDelay(15)
end

if pro_mod == true then
	GameRules:SetCustomGameTeamMaxPlayers(1, 2)
	GameRules:SetCustomGameSetupAutoLaunchDelay(30)
else
	GameRules:SetCustomGameTeamMaxPlayers(1, 0)
end


hero_select:RegisterHeroes()
upgrade:InitGameMode()
test_mode:InitGameMode()
start_quest:InitGameMode()
talents_values:InitGameMode()

for i = 1,max_teams do
	if AvailableTeams[i] then
    	GameRules:SetCustomGameTeamMaxPlayers(AvailableTeams[i], team_size)
	end
end

CustomNetTables:SetTableValue("custom_pick", "game_mode", {team_size = team_size, max_teams = max_teams, win_place = win_place})


GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 0 )

GameRules:GetGameModeEntity():SetGiveFreeTPOnDeath( false )
GameRules:SetPreGameTime( 99999 )
GameRules:GetGameModeEntity():SetDaynightCycleDisabled( only_night and test )
GameRules:SetCustomGameEndDelay( 3 )
GameRules:SetCustomVictoryMessageDuration(120)
GameRules:SetPostGameTime(120)
GameRules:SetTreeRegrowTime(4)
GameRules:GetGameModeEntity():SetCustomBuybackCostEnabled(true)
GameRules:GetGameModeEntity():SetCustomBackpackCooldownPercent(1)
GameRules:GetGameModeEntity():SetTPScrollSlotItemOverride("item_tpscroll_custom")
GameRules:GetGameModeEntity():SetAnnouncerDisabled( true )
GameRules:GetGameModeEntity():SetAnnouncerGameModeAnnounceDisabled(true)
GameRules:GetGameModeEntity():SetPlayerHeroAvailabilityFiltered(true)
GameRules:SetHeroSelectionTime(9999999)
GameRules:SetHeroSelectPenaltyTime(0)
GameRules:SetStrategyTime(2)
GameRules:SetShowcaseTime(0)
GameRules:SetStartingGold(850)
GameRules:GetGameModeEntity():SetCustomGlyphCooldown(300)
GameRules:SetUseUniversalShopMode( true )
GameRules:GetGameModeEntity():SetLoseGoldOnDeath(false)
GameRules:SetSafeToLeave(true)
GameRules:GetGameModeEntity():SetPauseEnabled( false )

--GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( dota1x6, "DamageFilter" ), self )
--GameRules:GetGameModeEntity():SetHealingFilter( Dynamic_Wrap( dota1x6, "HealingFilter" ), self )
GameRules:GetGameModeEntity():SetBountyRunePickupFilter( Dynamic_Wrap( self, "BountyRunePickupFilter" ), self )
GameRules:GetGameModeEntity():SetModifyExperienceFilter(Dynamic_Wrap(self, "ExpFilter"), self)
GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( dota1x6, "ExecuteOrderFilterCustom" ), self )

ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnEntityKilled"), self)
ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(self, 'OnRuneActivated'), self)
ListenToGameEvent("npc_spawned", Dynamic_Wrap( self, "OnNPCSpawned" ), self )
ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( self, 'OnGameRulesStateChange' ), self )
ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(self, 'OnPlayerLevelUp'), self)
ListenToGameEvent("dota_glyph_used", Dynamic_Wrap( self, 'OnGlyphUsed' ), self )
ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap( self, "OnItemPickUp"), self )
ListenToGameEvent("player_connect_full", Dynamic_Wrap(hero_select, "PlayerConnected"), hero_select)
ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(self, "ItemPurchased"), self)

CustomGameEventManager:RegisterListener( "ChangeTipsType", Dynamic_Wrap(self, 'ChangeTipsType'))
CustomGameEventManager:RegisterListener( "SelectVO", Dynamic_Wrap(chat_wheel, 'SelectVO'))
CustomGameEventManager:RegisterListener( "SelectHeroVO", Dynamic_Wrap(chat_wheel, 'SelectHeroVO'))
CustomGameEventManager:RegisterListener( "select_chatwheel_player", Dynamic_Wrap(chat_wheel, 'SelectChatWheel'))
CustomGameEventManager:RegisterListener( "GiveGlobalVision", Dynamic_Wrap(self, 'GiveGlobalVision'))
CustomGameEventManager:RegisterListener( "send_report", Dynamic_Wrap(self, 'send_report'))
CustomGameEventManager:RegisterListener( "DoubleRating", Dynamic_Wrap(self, 'DoubleRating'))
CustomGameEventManager:RegisterListener( "request_key", Dynamic_Wrap(self, 'show_key'))
CustomGameEventManager:RegisterListener( "shop_buy_item_player", Dynamic_Wrap(shop, 'shop_buy_item_player'))
CustomGameEventManager:RegisterListener( "heroes_vote_change", Dynamic_Wrap(shop, 'heroes_vote_change'))
CustomGameEventManager:RegisterListener( "heroes_vote_free", Dynamic_Wrap(shop, 'heroes_vote_free'))
CustomGameEventManager:RegisterListener( "get_bonus_shards", Dynamic_Wrap(shop, 'get_bonus_shards'))
CustomGameEventManager:RegisterListener( "browser_subscribe", Dynamic_Wrap(shop, 'browser_subscribe'))
CustomGameEventManager:RegisterListener( "player_change_keybind", Dynamic_Wrap(self, 'player_change_keybind'))
CustomGameEventManager:RegisterListener( "change_premium_pet", Dynamic_Wrap(shop, "ChangePetPremium"))
CustomGameEventManager:RegisterListener( "end_choise_js", Dynamic_Wrap(upgrade, "EndChoiseJs"))
CustomGameEventManager:RegisterListener( "ChangeSettings", Dynamic_Wrap(self, "ChangeSettings"))
CustomGameEventManager:RegisterListener( "RequestSettings", Dynamic_Wrap(self, "SendSettingsChange"))
CustomGameEventManager:RegisterListener( "LcDuelPick", Dynamic_Wrap(self, "LcDuelPick"))
CustomGameEventManager:RegisterListener( "PaHuntPick", Dynamic_Wrap(self, "PaHuntPick"))
CustomGameEventManager:RegisterListener( "TbReflectionPick", Dynamic_Wrap(self, "TbReflectionPick"))
CustomGameEventManager:RegisterListener( "TipPlayer", Dynamic_Wrap(self, "TipPlayer"))
CustomGameEventManager:RegisterListener( "dota1x6_item_change", Dynamic_Wrap(wearables_system, 'dota1x6_item_change'))
CustomGameEventManager:RegisterListener( "DoubleRating_show_change", Dynamic_Wrap(self, "DoubleRating_show_change"))
CustomGameEventManager:RegisterListener( "stop_timer", Dynamic_Wrap(self, 'stop_timer'))
CustomGameEventManager:RegisterListener( "wtf_mode", Dynamic_Wrap(self, 'wtf_mode'))
CustomGameEventManager:RegisterListener( "SelectQuest", Dynamic_Wrap(shop, "SelectQuest"))
CustomGameEventManager:RegisterListener( "check_id", Dynamic_Wrap(self, 'check_id'))
CustomGameEventManager:RegisterListener( "update_tip_list", Dynamic_Wrap(shop, "update_tip_list"))
CustomGameEventManager:RegisterListener( "select_current_tip", Dynamic_Wrap(shop, "select_current_tip"))
CustomGameEventManager:RegisterListener( "select_current_high_five", Dynamic_Wrap(shop, "select_current_high_five"))
CustomGameEventManager:RegisterListener( "send_cursor_position", Dynamic_Wrap(self, 'send_cursor_position'))
CustomGameEventManager:RegisterListener( "send_promo_code", Dynamic_Wrap(shop, 'send_promo_code'))
CustomGameEventManager:RegisterListener( "accept_gift", Dynamic_Wrap(shop, 'accept_gift'))
CustomGameEventManager:RegisterListener( "shop_dota1x6_open_chest_get_items_list", Dynamic_Wrap(shop, 'shop_dota1x6_open_chest_get_items_list'))
CustomGameEventManager:RegisterListener( "shop_dota1x6_open_chest_get_reward", Dynamic_Wrap(shop, 'shop_dota1x6_open_chest_get_reward'))
CustomGameEventManager:RegisterListener( "buildChosen", Dynamic_Wrap(self, "buildChosen"))
CustomGameEventManager:RegisterListener( "shop_dota1x6_close_chest_checked_reward", Dynamic_Wrap(shop, 'shop_dota1x6_close_chest_checked_reward'))
CustomGameEventManager:RegisterListener( "RequestAchivments", Dynamic_Wrap(self, 'RequestAchivments'))
CustomGameEventManager:RegisterListener( "RequestSubscribed", Dynamic_Wrap(self, 'RequestSubscribed'))
CustomGameEventManager:RegisterListener( "RequestItemBuild", Dynamic_Wrap(self, 'RequestItemBuild'))
CustomGameEventManager:RegisterListener( "update_damage_stats", Dynamic_Wrap(self, 'UpdateDamageStats'))
CustomGameEventManager:RegisterListener( "update_damage_bar", Dynamic_Wrap(self, 'UpdateDamageBar'))
CustomGameEventManager:RegisterListener( "used_free_build", Dynamic_Wrap(self, 'UsedFreeBuild'))

if test then 
	_G.PreGame_time = 5
	_G.push_timer = 0
	_G.Target_timer = 25111

	if test_patrol then
		_G.patrol_timer_max = 10
		_G.patrol_timer_max_2 = 10
		_G.patrol_timer_max_2_duel = 10
		_G.patrol_wave = 0

		if test_patrol == 2 then
			_G.patrol_wave_2 = 0
		end
		if test_patrol == 3 then
			_G.tormentor_wave = 0
		end
	end
end

local items_list = LoadKeyValues("scripts/npc/npc_ability_ids.txt")
local item_ids = {}
if items_list and items_list["ItemAbilities"] then
    for item_name, item_id in pairs(items_list["ItemAbilities"]["Locked"]) do
        item_ids[item_name] = tonumber(item_id)
    end
end
local items_list_custom = LoadKeyValues("scripts/npc/npc_ability_ids_custom.txt")
if items_list_custom and items_list_custom["ItemAbilities"] then
    for item_name, item_id in pairs(items_list_custom["ItemAbilities"]["Locked"]) do
        item_ids[item_name] = tonumber(item_id)
    end
end

CustomNetTables:SetTableValue("items_ids", "items_ids", item_ids)
end




function dota1x6:OnNPCSpawned(event)
local unit = EntIndexToHScript(event.entindex)
local new_spawned_hero = EntIndexToHScript(event.entindex)
wearables_system:InitPlayerWerable(unit)

if unit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then 

	local gold = unit:GetMinimumGoldBounty()*0.85
	local exp = (unit:GetDeathXP()*0.7)
	unit:SetMaximumGoldBounty(gold)
	unit:SetMinimumGoldBounty(gold)
	unit:SetDeathXP(exp)
end 

if unit and unit:HasAbility("twin_gate_portal_warp") then
	unit:RemoveAbility("twin_gate_portal_warp")
end

if SpawnedPlayers >= PlayerCount then return end

if unit and unit:IsRealHero() and (event.is_respawn == "0" or event.is_respawn == 0)  then 

	local id = unit:GetId()

	Timers:CreateTimer(0.1, function()
		if unit:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then return end

		GlobalHeroes[id] = unit

		unit:AddNewModifier(unit, nil, "modifier_start_stun", {})

	    if unit and unit:GetUnitName() == "npc_dota_hero_monkey_king" then
	        local monkey_king_ultimate = unit:FindAbilityByName("monkey_king_wukongs_command_custom")	       
	        if monkey_king_ultimate then
	            monkey_king_ultimate:CreateSoldiers()
	        end
	    end

	    _G.SpawnedPlayers = _G.SpawnedPlayers + 1

		dota1x6:initiate_player(unit)
	    if SelectedBases[id] then
	    	dota1x6:PlaceHero(id)
	    end
	end)
end
	

end



function dota1x6:PlaceHero(id)

if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 and SelectedBases[id] and GlobalHeroes[id] then

	local unit = GlobalHeroes[id]

	local tower = Entities:FindByName(nil, "tower_"..SelectedBases[id])
	if not tower then return end

	local position = tower:GetAbsOrigin() + RandomVector(300)
	
	unit:SetAbsOrigin(position)
	FindClearSpaceForUnit(unit, position, true)
	unit:SetRespawnPosition(position)
	
	local team = unit:GetTeamNumber()
	local respaw_pos = Entities:FindByName(nil, "tower_"..SelectedBases[id].."_respawn")
	local spawner = Entities:FindByName(nil, "spawn" .. team)
	if spawner then
		if respaw_pos then
			spawner:SetAbsOrigin(respaw_pos:GetAbsOrigin())
		else
	    	spawner:SetAbsOrigin(position)
		end
	end

	PlayerResource:SetCameraTarget(id, unit)
	
	Timers:CreateTimer(0.1, function() 
		PlayerResource:SetCameraTarget(id, nil) 
		dota1x6:SetTower(unit, position)
		unit:RemoveModifierByName("modifier_start_stun")
		unit:Stop()
	end)
	
	_G.ReadyPlayers = _G.ReadyPlayers + 1
	
	if _G.ReadyPlayers == PlayerCount then 

		CustomGameEventManager:Send_ServerToAllClients( 'end_loading', {} )
		CustomGameEventManager:Send_ServerToAllClients( 'PreGameEnd_top', {} ) 
	--	CustomGameEventManager:Send_ServerToAllClients( 'WaitingPlayers_end', {} ) 

		Timers:CreateTimer(1, function()
			dota1x6:UpdateHeroIcons()
			dota1x6:CheckBanStatus()
		end)
	end
end

end




function dota1x6:clear_towers()
local buildings = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

for _,building in pairs(buildings) do
	local team = building:GetTeamNumber()
	local is_teleport = building:GetUnitName() == "npc_teleport"

	if is_teleport then
		local number = tonumber(building:GetName())
		if IsDire(building:GetName()) then
		  building:SetMaterialGroup("1")
		end 

		if IsRadiant(building:GetName()) then
		  building:SetMaterialGroup("0")
		end 

		building:AddNewModifier(nil, nil, "modifier_mid_teleport", {})
	end


	if (is_teleport or building:IsBuilding()) and team == DOTA_TEAM_CUSTOM_6 and building:GetName() ~= "edge_teleport_1" and building:GetName() ~= "edge_teleport_2" then
		building:AddNewModifier(nil, nil, "modifier_tower_no_owner", {})
	end
end

end



        
function dota1x6:SetTower(unit, new_point)

local team = unit:GetTeamNumber()
if towers[team] then return end

local search_point = unit:GetAbsOrigin()
if new_point then
	search_point = new_point
end

local closest_tower = nil
local find_towers =  FindUnitsInRadius(team, search_point, nil, FIND_UNITS_EVERYWHERE,  DOTA_UNIT_TARGET_TEAM_BOTH,  DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false )

for _,tower in pairs(find_towers) do
	if (tower:GetUnitName() == "npc_towerradiant" or tower:GetUnitName() == "npc_towerdire") and not towers[tower:GetTeamNumber()] then
		closest_tower = tower
		break
	end
end

if not closest_tower then return end

find_towers =  FindUnitsInRadius(team, closest_tower:GetAbsOrigin(), nil, 2500, DOTA_UNIT_TARGET_TEAM_BOTH,  DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
for _,building in pairs(find_towers) do
	if (building:IsBuilding() or building:GetUnitName() == "npc_teleport") and not towers[building:GetTeamNumber()] then

		building:SetTeam(team)

		local effect_name = nil

  		building:RemoveModifierByName("modifier_tower_no_owner")
  		building:RemoveModifierByName("modifier_invulnerable")

  		if building:GetUnitName() == "npc_filler_radiant_resist" then
  			effect_name = "particles/radiant_resist.vpcf"
  		end
  		if building:GetUnitName() == "npc_filler_radiant_stun" then
  			effect_name = "particles/radiant_stun.vpcf"
  		end
  		if building:GetUnitName() == "npc_filler_radiant_plasma" then
  			effect_name = "particles/radiant_plasma.vpcf"
  		end

  		if building:GetUnitName() == "npc_filler_dire_resist" then
  			effect_name = "particles/dire_resist.vpcf"
  		end
  		if building:GetUnitName() == "npc_filler_dire_stun" then
  			effect_name = "particles/dire_stun.vpcf"
  		end
  		if building:GetUnitName() == "npc_filler_dire_plasma" then
  			effect_name =  "particles/world_shrine/dire_shrine_ambient.vpcf"
  		end

  		if effect_name then 
			building.effect = ParticleManager:CreateParticle(effect_name, PATTACH_ABSORIGIN_FOLLOW, building)
			building:AddNewModifier(building, nil, "modifier_tower_incoming", {})	
		end

		if building == closest_tower then
			towers[team] = building	
			towers[team].won_duel = 0
			towers[team].duel_data = -1
			towers[team].last_enemy = nil
			towers[team].trap_wave = false
			towers[team].last_reward_count = nil
			towers[team].can_use_trap = false
			towers[team].ids = dota1x6:FindPlayers(team)

			towers[team]:AddNewModifier(building, nil, "modifier_tower_level", {})	
			towers[team]:AddNewModifier(building, nil, "modifier_tower_incoming", {tower = 1})

			for i = 1,2 do
				local vision = Entities:FindByName(nil, building:GetName().."_vision_"..tostring(i))
				if vision then
					AddFOWViewer(unit:GetTeamNumber(), vision:GetAbsOrigin(), 800, 99999, true)
				end
			end
		end

   		if building:GetUnitName() == "npc_teleport"  then
			teleports[building:GetTeamNumber()] = building
			local number = tonumber(building:GetName())

			if (number == 2 or number == 3) and IsSoloMode() then 
				local mod = unit:FindModifierByName("modifier_item_custom_observer_ward_charges")
				if mod then 
					mod:IncrementStackCount()
				end
				mod = unit:FindModifierByName("modifier_item_custom_sentry_ward_charges")
				if mod then 
					mod:IncrementStackCount()
				end
				mod = unit:FindModifierByName("modifier_item_custom_smoke_charges")
				if mod then 
					mod:IncrementStackCount()
				end
			end
		end
	end
end
local tower = towers[unit:GetTeamNumber()]

if game_start == false then 
	tower:AddNewModifier(tower, nil, "modifier_tower_pre_game", {})	
end

end



function dota1x6:UpdateHeroIcons()

for _,icon in pairs(hero_icons) do
	if not icon:IsNull() and icon:IsAlive() then
		icon:ForceKill(false)
	end
end

for icon_team,icon_tower in pairs(towers) do
	local ids = dota1x6:FindPlayers(icon_team)
	if ids then
		local count = 0
		for _,id in pairs(ids) do 
			local player = players[id]
			if player then
				for target_team,target_tower in pairs(towers) do
					if target_team ~= icon_team or test then
					   	local abs = icon_tower:GetAbsOrigin()
					   	if #ids == 2 then
					   		local delta = 1400
					   		abs = icon_tower:GetAbsOrigin() + Vector(-delta/2 + count*delta, 0, 0) 
					   	end

						local hero_icon = CreateUnitByName(player:GetUnitName() .. '_icon', abs, false, nil, nil, target_team)
						hero_icon:AddNewModifier(nil, nil, "modifier_unselect", {})
						hero_icon.is_hero_icon = true
						table.insert(hero_icons, hero_icon)
					end
				end
			end
			count = count + 1
		end
	end
end

end




function dota1x6:PreGame()

hero_select:EndPick(true)
dota1x6:initiate_waves()

for i = 1,2 do
	local duel_field_1 = Entities:FindByName(nil, "duel_field_"..i.."_center")
	if duel_field_1 and duel_fields[tostring(i)] then
		local x_max = Entities:FindByName(nil, "duel_field_"..i.."_x_max")
		local x_min = Entities:FindByName(nil, "duel_field_"..i.."_x_min")
		local y_max = Entities:FindByName(nil, "duel_field_"..i.."_y_max")
		local y_min = Entities:FindByName(nil, "duel_field_"..i.."_y_min")

		local start_1_1 = Entities:FindByName(nil, "duel_field_"..i.."_start_1_1")
		local start_1_2 = Entities:FindByName(nil, "duel_field_"..i.."_start_1_2")
		local start_2_1 = Entities:FindByName(nil, "duel_field_"..i.."_start_2_1")
		local start_2_2 = Entities:FindByName(nil, "duel_field_"..i.."_start_2_2")

		duel_fields[tostring(i)].center = duel_field_1:GetAbsOrigin()
		duel_fields[tostring(i)].Xmax = x_max:GetAbsOrigin().x
		duel_fields[tostring(i)].Xmin = x_min:GetAbsOrigin().x
		duel_fields[tostring(i)].Ymax = y_max:GetAbsOrigin().y
		duel_fields[tostring(i)].Ymin = y_min:GetAbsOrigin().y
		duel_fields[tostring(i)].start1_1 = start_1_1:GetAbsOrigin()
		duel_fields[tostring(i)].start1_2 = start_1_2:GetAbsOrigin()
		duel_fields[tostring(i)].start2_1 = start_2_1:GetAbsOrigin()
		duel_fields[tostring(i)].start2_2 = start_2_2:GetAbsOrigin()
	end
end


local spawners = Entities:FindAllByName("bounty_spawner")
for _,spawner in pairs(spawners) do 
	local abs = spawner:GetAbsOrigin()
	abs.z = GetGroundPosition(abs, nil).z + 50
	bounty_abs[#bounty_abs + 1] = Vector(abs.x, abs.y , abs.z)
end

local duel_vision = Entities:FindAllByName("duel_vision")
for _,vision in pairs(duel_vision) do 
	local abs = vision:GetAbsOrigin()
	CreateModifierThinker(nil, nil, "modifier_duel_vision_thinker", {}, abs, DOTA_TEAM_NEUTRALS, false)
end

local haste_zones = Entities:FindAllByName("haste_zone")
for _,zone in pairs(haste_zones) do 
	local abs = zone:GetAbsOrigin()
	CreateModifierThinker(nil, nil, "modifier_haste_zone_thinker", {}, abs, DOTA_TEAM_NEUTRALS, false)
end 

for _,watcher in pairs(Entities:FindAllByName("watcher_radiant")) do 
	watcher:AddNewModifier(watcher, nil, "modifier_watcher_custom", {material = 1})
end

for _,watcher in pairs(Entities:FindAllByName("watcher_dire")) do 
	watcher:AddNewModifier(watcher, nil, "modifier_watcher_custom", {material = 2})
end

if (IsInToolsMode() or GameRules:IsCheatMode() or not HTTP.IsValidGame(PlayerCount)) or (enable_pause) then 
	GameRules:GetGameModeEntity():SetPauseEnabled( true )
end

dota1x6.mob_thinker = CreateModifierThinker(nil, nil, "modifier_mob_thinker", {}, Vector(), DOTA_TEAM_NEUTRALS, false)
dota1x6.event_thinker = CreateModifierThinker(nil, nil, "modifier_event_thinker", {}, Vector(), DOTA_TEAM_NEUTRALS, false)

Timers:CreateTimer(3, function()
	if #new_shop_heroes > 0 then  
	    CustomGameEventManager:Send_ServerToAllClients('show_new_shop_heroes', {sale = arcana_sale, heroes = new_shop_heroes} ) 
	end 
end)

Timers:CreateTimer(1, function()
	CustomGameEventManager:Send_ServerToAllClients( 'init_hero_level', {} )
end)

CustomGameEventManager:Send_ServerToAllClients( 'init_chat', {tools = IsInToolsMode(), cheat = GameRules:IsCheatMode(), valid = HTTP.IsValidGame( PlayerCount )} )
end



function dota1x6:EndPickStage()
for id = 0,24 do 
	if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 and GlobalHeroes[id] and towers[GlobalHeroes[id]:GetTeamNumber()] == nil then
		dota1x6:PlaceHero(id)
	end
end

for _,tower in pairs(towers) do
	tower:RemoveModifierByName("modifier_tower_pre_game")
end

GameRules:GetGameModeEntity():SetThink( start_game_timer, "StartGameTimer", 1 )
end

	


function start_game_timer()
_G.PreGame_time = _G.PreGame_time - 1

test_mode:InitPlayers()

CustomGameEventManager:Send_ServerToAllClients( 'PreGameStart', {time = PreGame_time} ) 

if PreGame_time == 7 then 
	CustomGameEventManager:Send_ServerToAllClients('generic_sound',  {sound = "UI.Battle_begin_sound"})
end

if PreGame_time <= 0 then 
	CustomGameEventManager:Send_ServerToAllClients('generic_sound',  {sound = "UI.Battle_begin"})
	CustomGameEventManager:Send_ServerToAllClients( 'PreGameEnd', {} ) 
	GameRules:ForceGameStart()
	return -1
end

return 1
end




function dota1x6:start_game()
if game_start then return end

_G.game_start = true 

for _,tower in pairs(towers) do
	tower:RemoveModifierByName("modifier_tower_pre_game")
end

dota1x6:GiveVisionForAll(2)

for _,player in pairs(players) do
	if player.goodwin_quest and (test or pro_mod) then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetId()), 'goodwin_quest_alert', {id = player.goodwin_quest}) 
	end
end


GameRules:SpawnNeutralCreeps()
GameRules:SetTimeOfDay(0.25)
end




function dota1x6:CheckBanStatus()

if not test then 
	--CustomGameEventManager:Send_ServerToAllClients('shop_new_promo', {} ) 
end

Timers:CreateTimer(2, function() 
	--CustomGameEventManager:Send_ServerToAllClients('shop_global_sale', {} ) 
end)


if not HTTP.IsValidGame(PlayerCount) then 
   	Timers:CreateTimer(1, function() 
   	--	CustomGameEventManager:Send_ServerToAllClients( 'alert_notvalid', {} ) 
	end)	
	return 
end

local active_vote = CustomNetTables:GetTableValue("sub_data", "heroes_vote" ).active_vote

if active_vote == 1 then
   CustomGameEventManager:Send_ServerToAllClients('show_active_vote', {} ) 
end 

for _,player in pairs(players) do 
	local id = player:GetId()

	if active_vote == 0 then
		if player.islp then 
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'alert_dont_leave', {lp = 1} )
		else 
		 --	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'alert_dont_leave', {lp = 0} )
		end
	end

	local name = tostring(GetMapName())
	local server_data = CustomNetTables:GetTableValue("server_data", tostring(id) )
	local wrong_map_status = server_data.wrong_map_status

	if wrong_map_status and wrong_map_status == 2 then 
		wrong_map_players[id] = true
	end 

	if HTTP.serverData.isStatsMatch == true or test == true then 
		if rating_thresh[name] and wrong_map_status then 
			
			if wrong_map_status == 2 then 
				player.banned = true
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'BadMap_ban', {mmr = lobby_rating[id], min = rating_thresh[name].min, max = rating_thresh[name].max} )
			end 

			if wrong_map_status == 1 then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'BadMap', {mmr = lobby_rating[id], min = rating_thresh[name].min, max = rating_thresh[name].max} )
			end
		else 
			if active_vote == 0 then
				--CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'unranked_alert', {} )
			end
		end
		player.wrong_map_status = wrong_map_status
	end
end

check_reports() 
end








function dota1x6:send_report(kv)
if kv.PlayerID == nil then return end

local reported1 = PlayerResource:GetSteamAccountID(kv.Hero_1)
local reported2 = PlayerResource:GetSteamAccountID(kv.Hero_2)

local targets = {tostring(reported1), tostring(reported2)}

local reports = CustomNetTables:GetTableValue("reports", tostring(kv.PlayerID))
if reports.report == 0 then
    return
end

reports.report = reports.report - 1

CustomNetTables:SetTableValue("reports", tostring(kv.PlayerID), reports)
HTTP.Report( kv.PlayerID, kv.Hero_1,kv.Hero_2, 0)
end




function dota1x6:FillQuests(hero_name)

local new_quests = {}
local normal_quests = {}
local legendary_quests = {}
local general_quests = {}

for number,shop_hero_quest in pairs(All_Quests.hero_quests[hero_name]) do 
	if shop_hero_quest.legendary and shop_hero_quest.legendary ~= nil then 
		legendary_quests[#legendary_quests + 1] = number
	else 
		normal_quests[#normal_quests + 1] = number
	end
end

for number,shop_hero_quest in pairs(All_Quests.general_quests) do 

	if (shop_hero_quest.not_for == nil or shop_hero_quest.not_for[hero_name] == nil) and 
	(shop_hero_quest.only_for == nil or shop_hero_quest.only_for[hero_name] ~= nil) then 
		general_quests[#general_quests + 1] = number
	end
end


if #normal_quests > 0 then 
	new_quests[#new_quests + 1] = All_Quests.hero_quests[hero_name][normal_quests[RandomInt(1, #normal_quests)]].name
end

if #legendary_quests > 0 then 
	new_quests[#new_quests + 1] = All_Quests.hero_quests[hero_name][legendary_quests[RandomInt(1, #legendary_quests)]].name
end


if #general_quests > 0 then 

	local name = All_Quests.general_quests[general_quests[RandomInt(1, #general_quests)]].name
	new_quests[#new_quests + 1] = name

end

return new_quests
end




function dota1x6:OnGameRulesStateChange()
local nNewState = GameRules:State_Get()

if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
	HTTP.FillOfflineServerData()
	_G.GAME_STARTED = true

	HTTP.MatchStart()

	for id = 0, 24 do
		if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then
			_G.PlayerCount = _G.PlayerCount + 1

			local party_id = PlayerResource:GetPartyID(id)
			if party_id ~= 0 and party_id ~= "0" then
				PartyTable[id] = tostring(party_id)
			end

			local reports = 1
			local max_map = 0
			if rating_thresh[GetMapName()] and rating_thresh[GetMapName()]["max"] and rating_thresh[GetMapName()]["max"] == 99999 then
				reports = 0
				max_map = 1
			end

			CustomNetTables:SetTableValue("reports", tostring(id), {max_map = max_map, report = reports })
		end
	end

	if PlayerCount <= TestMode_players then 
		_G.TestMode = true

		for name,_ in pairs(added_shop_heroes) do
	        wearables_system.items_data[name] = require("wearables_system/donate_items/"..name)
	        wearables_system.items_data_slots[name] = require("wearables_system/donate_items/"..name.."_slots")
	        wearables_system:SendHeroItems(name)
	    end
	end

	dota1x6:clear_towers()
end


if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
    if not IsSoloMode() then
        for id = 0, 24 do
            if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 and PlayerResource:GetTeam(id) == DOTA_TEAM_NOTEAM then
                local teams = {2,3,6,7}
                for _, team in pairs(teams) do
                    if PlayerResource:GetPlayerCountForTeam(team) < players_in_team then
                        PlayerResource:SetCustomTeamAssignment(id, team)
                        break
                    end
                end
            end
        end
    end

	CustomNetTables:SetTableValue("custom_pick", "pick_state", {in_progress = true})
	CustomNetTables:SetTableValue("custom_pick", "avg_rating", {avg_rating = avg_rating})

	Timers:CreateTimer(
	"",
	{
		useGameTime = false,
		endTime = 1,
		callback = function()

		hero_select:init()	
	end})

	Timers:CreateTimer(
	"main_timer",
	{
		useGameTime = false,
		endTime = 0,
		callback = function()

		dota1x6:spawn_timer()

		return main_timer_interval
	end})

end	

if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then
	dota1x6:PreGame()
end

if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then 
	dota1x6:start_game()
end

end





function dota1x6:TowerKill(hero, killed_tower)

local team = hero:GetTeamNumber()
local tower = towers[team]
if not tower then return end

local tower_count = 0
for _,tower in pairs(towers) do 
	if tower ~= killed_tower and tower:IsAlive() then
    	tower_count = tower_count + 1
	end
end

local heroes = dota1x6:FindPlayers(team, false, true)
for _,player in pairs(heroes) do
	local orb = 3
	if player.towers_destroyed > 0 then
	    orb = 2
	end 
	player.towers_destroyed = player.towers_destroyed + 1

	if GameRules:GetDOTATime(false, false) >= push_timer then
	    dota1x6:RefreshCooldowns(player, true) 
	    dota1x6:CreateUpgradeOrb(player, orb)
	end
	
	if tower_count == 2 and IsSoloMode() then 
	    player:AddNewModifier(player, nil, "modifier_duel_damage_final", {})
	end
end

end





function check_reports()
if not IsSoloMode() then return end

for _,server_player in pairs(HTTP.serverData.players) do

	local pid = HTTP.GetPlayerBySteamID( server_player.steamID )

	local player = nil

	if pid then 
		player = players[pid]
	end

	if player ~= nil and server_player.reports then

		if player.banned ~= true then
			player.banned = server_player.isBanned
		end

		for other_player, report_count in pairs(server_player.reports) do

			local other_pid = HTTP.GetPlayerBySteamID( other_player )

			if report_count > 0 then 
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid), 'report_alert',  {
			   	 id = other_pid,
			   	 number = report_count,
			   	 max = 6
				})
			end

			if report_count > player.reports then
				player.reports = report_count
				player.teammate = other_pid
			end
		end
	end
end


end



function dota1x6:Check_position(i)
if not IsSoloMode() then return end


local point = i:GetAbsOrigin()
local change = false  

if i:GetAbsOrigin().z < -1000 then 
	point.z = i.z
	change = true
end 

if i:GetAbsOrigin().x > i.x_max then 
	point.x = i.x_max - 200
	change = true
end

if i:GetAbsOrigin().x < i.x_min then 
	point.x = i.x_min + 200
	change = true
end

if i:GetAbsOrigin().y > i.y_max then 
	point.y = i.y_max - 200
	change = true
end

if i:GetAbsOrigin().y < i.y_min then 
	point.y = i.y_min + 200 
	change = true	
end   

if change == true then 
	i:SetAbsOrigin(point)
	FindClearSpaceForUnit(i, point, true)
end

end







function dota1x6:Destroy_Wave_Creeps()

local wave_creeps = FindUnitsInRadius(DOTA_TEAM_NOTEAM, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
for _,wave_creep in pairs(wave_creeps) do
	if not wave_creep:IsNull() and wave_creep:GetTeamNumber() == DOTA_TEAM_CUSTOM_5 and wave_creep:IsAlive() and not wave_creep.player_unit then 

		wave_creep:ForceKill(false)
	end
end

end


function dota1x6:Destroy_All_Units(caster)

local thirst = caster:FindAbilityByName("bloodseeker_thirst_custom")

local all_units = FindUnitsInRadius(caster:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, 0, false)
for _,unit in pairs(all_units) do
	if not unit:IsNull() and unit:IsAlive() and not unit:IsRealHero() and not unit:IsCourier()
	and not unit:HasModifier("modifier_monkey_king_wukongs_command_custom_soldier") then 
		unit:ForceKill(false)
	end
end

end




function dota1x6:DestroyPatrol()
if not IsServer() then return end

local patrols = FindUnitsInRadius(1, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)

for _,patrol in pairs(patrols) do
	if patrol and not patrol:IsNull() and patrol.is_patrol_creep then
		patrol:AddNewModifier(patrol, nil, "modifier_death", {})
		patrol:ForceKill(false)
	end
end


end


function MaxTime(n)
local t = 70
if n == 1 then t = 20 end 
if n >= 6 then t = 120 end
if n >= 13 then t = 180 end
if n >= 21 then t = 180 end
return t
end



function dota1x6:CheckPatrol()
if patrol_launched == true then return end

local patrol_max = patrol_timer_max

if dota1x6.current_wave >= patrol_wave_2 or tormentor_wave == dota1x6.current_wave then 
	patrol_max = patrol_timer_max_2

	if dota1x6:IsDuelWave(dota1x6.current_wave - 1) or (dota1x6.current_wave ) == Wave_boss_number[2] then
		patrol_max = patrol_timer_max_2_duel
	end
end 


if patrol_wave <= dota1x6.current_wave and timer + PortalDelay == patrol_max and dota1x6:FinalDuel() == false then 

	if tormentor_wave == dota1x6.current_wave then
		dota1x6:patrol_portal(3)
		dota1x6:patrol_portal(4)
	else 	
		dota1x6:patrol_portal(0)
		dota1x6:patrol_portal(1)
	end
end


if patrol_wave <= dota1x6.current_wave and timer == patrol_max and dota1x6:FinalDuel() == false then 

	if tormentor_wave == dota1x6.current_wave then
		tormentor_wave = tormentor_wave + tormentor_inc
		dota1x6:spawn_patrol(0, nil, nil, nil, nil, true)
		dota1x6:spawn_patrol(1, nil, nil, nil, nil, true)
	else

		local second_tier = false 
		local center_patrol = false

		if dota1x6.patrol_dontgo_dire == true or dota1x6.patrol_dontgo_radiant == true then
			--center_patrol = true
		end 

		local patrol_item = "patrol_1"

		if dota1x6.current_wave >= patrol_wave_2 then 
			second_tier = true
			patrol_item  = "patrol_2"
		end

		dota1x6.radiant_patrol_alive = true
		dota1x6:spawn_patrol(0, patrol_item, nil ,second_tier, false)
	
		dota1x6.dire_patrol_alive = true
		dota1x6:spawn_patrol(1, patrol_item, nil,second_tier, false)

	end
	patrol_launched = true

	dota1x6.current_patrol = dota1x6.current_patrol + 1 
	if dota1x6.current_patrol > math.floor(max_teams/2) then 
		dota1x6.current_patrol = 1
	end
end


end


function dota1x6:TimerAlerts()

if GameRules:GetDOTATime(false, false) >= DoubleRating_timer and DoubleRating_active == true then 
	DoubleRating_active = false
	CustomGameEventManager:Send_ServerToAllClients( 'hide_double_rating', {} ) 
end

if GameRules:GetDOTATime(false, false) >= push_timer and push_alert == false then 
	push_alert = true
	CustomGameEventManager:Send_ServerToAllClients( 'grenade_alert', {} ) 
end

if dota1x6.current_wave == patrol_wave and timer >= patrol_timer_max - 10 and patrol_first_init == false then 
	patrol_first_init = true 
	CustomGameEventManager:Send_ServerToAllClients( 'PatrolAlert', {number = 1} )
end  

if dota1x6.current_wave == patrol_wave_2 and timer >= patrol_timer_max_2 - 10 and  patrol_second_init == false then 
	patrol_second_init = true 
	CustomGameEventManager:Send_ServerToAllClients( 'PatrolAlert', {number = 2} )
end  

if SafeToLeave_alert == false and SafeToLeave == true and (HTTP.serverData.isStatsMatch == true or test) then 
	SafeToLeave_alert = true 
	CustomGameEventManager:Send_ServerToAllClients( 'saveleave', {reason = SafeToLeave_reason} )
end

if (MaxTimer - timer) <= duel_alert_timer and duel_alert_init == false and dota1x6:FinalDuel() == false then 

    local array = {}

    for _,data in pairs(duel_data) do 
        if data.stage == 1 and data.finished == 0 and data.final_duel == 0 and towers[data.tower1:GetTeamNumber()] and towers[data.tower2:GetTeamNumber()] then 
            table.insert(array, data.heroes)
        end 
    end 

    if #array > 0 then 
		duel_alert_init = true
        CustomGameEventManager:Send_ServerToAllClients( "DuelAlert", {array = array} )
    end
end

end 


function dota1x6:DuelSoon(team)
local tower = towers[team]
if not tower then return false end

if duel_data[tower.duel_data] and duel_data[tower.duel_data].finished == 0 and duel_data[tower.duel_data].stage == 1 and (MaxTimer - timer) <= duel_push_time then
	return true
end

return false
end


function dota1x6:FinalDuel()
if duel_data[#duel_data] and duel_data[#duel_data].finished == 0 and duel_data[#duel_data].final_duel == 1 then 
	return true
else 
	return false
end 

end


function dota1x6:GetTeamsNet()
local team_net = {}

for id,player in pairs(players) do 
	local team = player:GetTeamNumber()
	local index = #team_net + 1

	for count = 1,#team_net do
		if team_net[count] and team_net[count].team == team then
			index = count
			break
		end
	end

	if index == #team_net + 1 then
		team_net[index] = {}
		team_net[index].gold = 0
		team_net[index].team = team
	end

	team_net[index].gold = team_net[index].gold + PlayerResource:GetNetWorth(id)
end
return team_net
end





function dota1x6:UpdatePlayersTable(id)

local player = players[id]
if not player then return end

local team = player:GetTeamNumber()
local no_buyback = player.no_buyback
local hero_name = player:GetUnitName()
local hero_kills_table = nil
if GameRules:GetDOTATime(false, false) < Player_damage_time then 
	hero_kills_table = player.hero_kills
end

local razor_count = -1
if dota1x6.current_wave > duel_start_wave and player.razor_count then
	razor_count = player.razor_count
end

CustomNetTables:SetTableValue("networth_players", tostring(id), {
    place = -1,
    team = team,
    no_buyback = no_buyback,
    net = PlayerResource:GetNetWorth(id),
    damage_bonus = player.damage_bonus,
    hero_kills = hero_kills_table,
    hero_has_aegis = false,
    hero_tier = player.hero_tier,
    hide_tier = player.hide_tier,
    subscribed = player.subscribed,
    hero_name = hero_name,
    steam_id = PlayerResource:GetSteamID(id),
    rare = player.blue,
    purple = player.purple,
    legendary = player.chosen_skill_name,
    legendary_talent = player.legendary_talent,
    legendary_skill_name = player.legendary_skill_name,
    base = dota1x6:GetBase(player:GetTeamNumber()),
    tips_available = player.tips_available,
    tips_cooldown = player.tips_cooldown,
    razor_count = razor_count,
    team_color = player.team_color
})

end


local temp_damage_timer = 30

function dota1x6:spawn_timer()
if Game_end == true then return -1 end

local GameState = GameRules:State_Get()
local can_pause = game_start == true and not IsInToolsMode() and not GameRules:IsCheatMode() and HTTP.IsValidGame(PlayerCount) and not enable_pause
local should_pause = false
local is_paused = GameRules:IsGamePaused()
local team_net = dota1x6:GetTeamsNet()
local low_net_teams = {}
local more_gold_teams = {}
local number_wave = 0
local go_boss = false
local save_items = false
local next_boss = false
local next_wave_number = 0
local current_time = GameRules:GetDOTATime(false, false)

if GameState >= DOTA_GAMERULES_STATE_PRE_GAME and not is_paused then
	dota1x6:TimerAlerts()
	dota1x6:MuertaQuestTimer()
	start_quest:CheckTimer()
end

if dota1x6:FinalDuel() == false then  
	MaxTimer = MaxTime(dota1x6.current_wave + 1)
	
	if test then
		if dota1x6.current_wave + 1 == start_wave + 1 then 
			MaxTimer = timer_test_start
		else  
			MaxTimer = timer_test
		end
	end 
end 


if game_start == true and not is_paused then 

	if TimerStop == false then 
		timer = timer + 1
	end

	bounty_timer = bounty_timer + 1 

	for _,data in pairs(duel_data) do 
		if data and data.finished and data.finished == 0 and data.thinker and not data.thinker:IsNull() then 
			data.timer = data.timer + 1 

			if data.timer >= data.max_timer and data.thinker and not data.thinker:IsNull() then 
				data.thinker:RemoveModifierByName("modifier_duel_field_thinker")
			end 

		end 
	end 
end

if dota1x6:FinalDuel() == true and duel_data[#duel_data].new_round == true then 
	duel_data[#duel_data].new_round = false

	MaxTimer = round_timer
	timer = 0
end

if #team_net > 1 then
	table.sort( team_net, function(x,y) return y.gold > x.gold end )
end

if #team_net > win_place then 

	for i = 1,low_net_max do
		if team_net[i] then
			low_net_teams[team_net[i].team] = true
		end
	end
	
	if (dota1x6.current_wave >= more_gold_wave or test) then
		for i = 1,math.floor(#team_net/2)  do
			if team_net[i] then
				more_gold_teams[team_net[i].team] = true
			end
		end
	end

	if Target_timer <= current_time and Target_proc == false and team_net[#team_net].team then 

		local tower = towers[team_net[#team_net].team]
		local mod = nil

		if tower then
			local duration = Target_duration
			local max_time = 19*60 - Target_duration
			if current_time >= max_time then
				duration = 19*60 - current_time - 0.5
			end
			mod = tower:AddNewModifier(tower, nil, "modifier_the_hunt_custom_tower", {duration = duration})
		end

		if mod then
			Target_proc = true
		end
	end
end 


if timer >= MaxTimer then 

	if dota1x6:FinalDuel() == false then 

		if muerta_quest_phase ~= 0 and muerta_quest_hero ~= nil then 

			dota1x6:MuertaQuestClearArea()
			muerta_quest_timer = 0
			muerta_quest_active = true

		end

		dota1x6.current_wave = dota1x6.current_wave + 1
		patrol_launched = false

		for n = 1,#Wave_boss_number do 
			if dota1x6.current_wave == Wave_boss_number[n] then
				go_boss = true
				break
			end 
		end

		if go_boss then 
			dota1x6.go_boss_number = dota1x6.go_boss_number + 1
			number_wave = dota1x6.go_boss_number
		else 
			dota1x6.go_wave = dota1x6.go_wave + 1
			number_wave = dota1x6.go_wave
		end

		dota1x6:DestroyPatrol()
	end 
end 


if current_time >= bounty_start and bounty_init == false then 
	bounty_init = true 

	for i = 1,#bounty_abs do 
		local b_thinker = CreateUnitByName("npc_bounty_thinker", bounty_abs[i], false, nil, nil, DOTA_TEAM_NEUTRALS)
		b_thinker:AddNewModifier(b_thinker, nil, "modifier_bounty_map", {})

	end
end


if bounty_timer >= bounty_max_timer and current_time >= bounty_start then 
	bounty_timer = 0

	for i = 1,#bounty_abs do 

		local near_rune = Entities:FindByModelWithin(nil, "models/props_gameplay/rune_goldxp.vmdl", bounty_abs[i], 200)
		if not near_rune then
			CreateRune(bounty_abs[i], DOTA_RUNE_BOUNTY)  
		end

	end
end


for timing,state in pairs(ItemsTiming) do 

	if state == false and current_time >= timing then 
		ItemsTiming[timing] = true
		save_items = true
		break
	end 	
end 	

if not is_paused then
	dota1x6:CheckPatrol()
end


for n = 1,#Wave_boss_number do 
	if dota1x6.current_wave + 1 == Wave_boss_number[n] then
		next_boss = true
		break
	end 
end

if next_boss then 
	next_wave_number = dota1x6.go_boss_number + 1
else 
	next_wave_number = dota1x6.go_wave + 1
end

local next_wave = dota1x6:GetWave(next_wave_number, next_boss)
local skills = dota1x6:GetSkills(next_wave_number, next_boss)
local mkb = dota1x6:GetMkb(next_wave_number, next_boss)

local abandon_count = 0
for _,data in pairs(abandon_players) do 
	abandon_count = abandon_count + 1
end


for id = 0,24 do 
	if PlayerResource:IsValidPlayerID(id) then  

		local player = players[id]
		local state = PlayerResource:GetConnectionState(id)

		if ((state == DOTA_CONNECTION_STATE_ABANDONED) or (state == DOTA_CONNECTION_STATE_DISCONNECTED and abandon_count == PlayerCount - 1)) and abandon_players[id] ~= true then 

			abandon_players[id] = true
			HTTP.playersData[id].isLeaver = true

			local data = CustomNetTables:GetTableValue("server_data", tostring(id) )
			local wrong_map_status = data.wrong_map_status

			local lp_games = 0
			local switch_safetoleave = false
			local lp_games = data.lp_games_remaining

			if (HTTP.serverData.isStatsMatch == true or test) and SafeToLeave == false and current_time <= LowPriorityTime and HTTP.playersData[id].lost_game == false then 
				lp_games = lp_games + 1

	            _G.SafeToLeave = true
	            switch_safetoleave = true 
	            SafeToLeave_reason = 1
	        end

			data.lp_games_remaining = lp_games
	        data.switch_safetoleave = switch_safetoleave
			CustomNetTables:SetTableValue("server_data", tostring(id), data)
			HTTP.PlayerLeave( id )
		end

		if SafeToLeave == false and current_time < 3 then 

			local data = CustomNetTables:GetTableValue("server_data", tostring(id) )
	    	if data and data.wrong_map_status == 2 then 
				_G.SafeToLeave = true
				SafeToLeave_reason = 2
				break
			end
		end

		if player then
			local team = player:GetTeamNumber()

			if not couriers_spawned[id] then 
				dota1x6:CreateCourier(team, id)
			end

			local alert = false
			if state == DOTA_CONNECTION_STATE_ABANDONED and player.left_game == false and Game_end == false then 

				player.left_game_timer = 60
				local players = dota1x6:FindPlayers(team, false, true)
				if players then
					for _,team_player in pairs(players) do
						if team_player ~= player and not team_player.left_game then
							player.left_game_timer = 0
							break
						end
					end
				end

				player.left_game = true
			   	CustomGameEventManager:Send_ServerToAllClients( 'hero_lost', {ban = 0, abbandon = 1, hero2 = {}, hero = {player:GetUnitName()}} )
			   	alert = true
			end

			if player.banned == true and alert == false then
				CustomGameEventManager:Send_ServerToAllClients( 'hero_lost', {ban = 1, abbandon = 0, hero2 = {}, hero = {player:GetUnitName()}} )

				if player.teammate then 
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'banned', {reports = player.reports, id = player.teammate, max = 6} )
				end
			end

			if player:IsAlive() then
				for name,data in pairs(player.temp_damage_stat) do
				    if (current_time - data.time) >= temp_damage_timer then
				        player.temp_damage_stat[name] = nil
				    end
				end
			end

			if current_time >= Player_damage_time and current_time < Player_damage_time + 3 then 
				player:RemoveModifierByName("modifier_player_damage")
				player.damage_bonus = 0
			end

			if player.promo_cd > 0 then 
				player.promo_cd = math.max(0, player.promo_cd - 1)
			end 

			if player.left_game == true and not is_paused then 
				player.left_game_timer = player.left_game_timer - 1
			end

			if player.tips_available == 1 and player.tips_cooldown > 0 then 
				player.tips_cooldown = math.max(0, player.tips_cooldown - 1)
			end 

			if save_items == true then
				HTTP.FillItemsData(id, -1)
			end 	

			local tower = towers[team]

			if tower and duel_data[tower.duel_data] and duel_data[tower.duel_data].finished == 0 and duel_data[tower.duel_data].stage == 1 and (MaxTimer - timer) <= duel_push_teleport
				 and not player:HasModifier("modifier_duel_hero_teleport") then

				player:AddNewModifier(player, nil, "modifier_duel_hero_teleport", {duration = duel_push_teleport})
			end

			--dota1x6:Check_position(player)
			dota1x6:UpdatePlayersTable(id)

			if state ~= player.connect_state then
				player.connect_state = state
			end

			if can_pause then  
				if player.pause_time > 0 and ((state == DOTA_CONNECTION_STATE_DISCONNECTED or state == DOTA_CONNECTION_STATE_LOADING ) or 
					(player.after_pause_time > 0 and state == DOTA_CONNECTION_STATE_CONNECTED)) and current_time > 1 then

					should_pause = true

					local time = player.pause_time
					local hero_name = player:GetUnitName()
					
					if (player.pause_time > 0 and (state == DOTA_CONNECTION_STATE_DISCONNECTED or state == DOTA_CONNECTION_STATE_LOADING)) then 
						CustomGameEventManager:Send_ServerToAllClients( 'pause_think', {time = time, id = id, player = SelectedHeroes[id].hero} )

						player.pause_time = player.pause_time - 1
						player.after_pause_time = 3
					end

					if (player.after_pause_time > 0 and state == DOTA_CONNECTION_STATE_CONNECTED ) then 
						CustomGameEventManager:Send_ServerToAllClients( 'pause_think', {time = player.after_pause_time, id = id, player = SelectedHeroes[id].hero, ending = 1} )

						player.after_pause_time = player.after_pause_time - 1
					end
				else
					CustomGameEventManager:Send_ServerToAllClients( 'pause_end', {id = id} )
				end
			end

			if player.left_game_timer < 1 or player.banned == true then  
				dota1x6:destroy_player(id)
			end
		end


		if GameState >= DOTA_GAMERULES_STATE_PRE_GAME then

			local can_display = false 
			local givegold = false
			local reward = 0
			local necro = 0

			if player  then 
				local team = player:GetTeamNumber()

				if more_gold_teams[team] then
					givegold = 1
				end
				can_display = player.ActiveWave == nil
				necro = player.necro_wave
				player.reward = dota1x6:GetReward(dota1x6.current_wave + 1, player)
				reward = player.reward
			else 
				can_display = true
			end

			local duel_timer = false
			local duel = nil 

			if player and towers[player:GetTeamNumber()] then
				local tower = towers[player:GetTeamNumber()]
				if tower and duel_data[tower.duel_data] and duel_data[tower.duel_data].finished == 0 then
					duel_timer = true
					duel = duel_data[tower.duel_data]
				end
			end

			if dota1x6:FinalDuel() then
				duel_timer = true
				duel = duel_data[#duel_data]
			end

			if can_display == true or dota1x6:FinalDuel() == true then 

				if duel_timer then 

					local time = timer
					local max_timer = MaxTimer

					if duel.stage == 2 then 
						time = duel.timer
						max_timer = duel.max_timer
					end 

					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id) , 'duel_timer_progress',  
					{
						time = time, 
						max = max_timer, 
						stage = duel.stage, 
						final = duel.final_duel, 
						round = duel.rounds, 
						heroes1 = duel.heroes[1], 
						wins1 = duel.wins1, 
						heroes2 = duel.heroes[2],
						wins2 = duel.wins2,
					})
				else 

					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id) , 'timer_progress',  
					{
						necro = necro,
						units = -1, 
						units_max = -1,  	
						time = timer, 
						max = MaxTimer, 
						name = next_wave, 
						skills = skills, 
						mkb = mkb, 
						reward = reward, 
						gold = givegold, 
						number = dota1x6.current_wave + 1, 
						game_start = game_start
					})
				end
			end
		end
	end 
end


for team,tower in pairs(towers) do

	tower.can_use_trap = (MaxTimer - timer) > Necro_Timer

	if timer >= MaxTimer then 
		if duel_data[tower.duel_data] and duel_data[tower.duel_data].finished == 0 then 
			if duel_data[tower.duel_data].final_duel == 1 then 
				dota1x6:Destroy_Wave_Creeps()	
			end 
			dota1x6:CreateDuelField(tower.duel_data)
		else 
			local necro = false 
			local trap = false

			if tower.trap_wave == true then 
				trap = true 
				tower.trap_wave = false
			end

			local give_lownet = 0
			if low_net_teams[team] and low_net_waves[dota1x6.current_wave] then 
				give_lownet = 1
			end

			local give_more_gold = 0
			if more_gold_teams[team] then
				give_more_gold = 1
			end

			dota1x6:spawn_wave(team, number_wave, go_boss, give_lownet, give_more_gold, trap)
		end 

		if dota1x6.current_wave < 25 and dota1x6.current_wave > 1 then 
			tower:AddNewModifier(tower, nil, "modifier_tower_level", {})
		end

	end
	if not duel_data[tower.duel_data] and timer + PortalDelay == MaxTimer and dota1x6:FinalDuel() == false and not is_paused then 
		dota1x6:spawn_portal(team)
	end 

	if timer + 10 == MaxTimer and game_start == true and dota1x6:FinalDuel() == false and teleports[team] and not duel_data[tower.duel_data] and not is_paused then 
		local allow = true
		local count = 0

		if IsSoloMode() and false then
			local ids = players[dota1x6:FindPlayers(team)]

			if ids then
				local player = players[ids[1]]
				local table_tips = CustomNetTables:GetTableValue("TipsType", tostring(player:GetId()))

				if table_tips.type ~= 2 and table_tips.type ~= 3 then
					allow = false
				end
				if table_tips.type == 3 then
					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player:GetId()), "TipForPlayer", {duration = 10, text = "#Tip_WaveStart"})
				end
			end
		end

		if allow then
			local spawner = Entities:FindByName(nil, tower:GetName().."_vision_2")
			if spawner then
				Timers:CreateTimer(0, function()
					GameRules:ExecuteTeamPing( team, spawner:GetAbsOrigin().x, spawner:GetAbsOrigin().y, player, 0 )
					count = count + 1
					if count <= 2 then
						return 1.5
					end
				end)
			end
		end
	end 
	dota1x6:CheckTowerDeath(tower)
end

if timer >= MaxTimer then 

	duel_alert_init = false

	if dota1x6:FinalDuel() == false and dota1x6:IsDuelWave() then 
		dota1x6:FindDuelPairs()
	end 

	if dota1x6.go_wave == #waves then 
		dota1x6.go_wave = 0
	end 

	timer = 0
end


if can_pause then
	if is_paused then 
		if should_pause == false then 
			PauseGame(false)
		end
	else 
		if should_pause == true  then 
			PauseGame(true)
		end
	end
end

end


function dota1x6:IsDuelWave(override_wave)
if override_wave then
	return override_wave >= duel_start_wave and override_wave % 2 ~= 0
end
return dota1x6.current_wave >= duel_start_wave and dota1x6.current_wave % 2 ~= 0
end







function dota1x6:CheckParty(check_id)

local check_party = PartyTable[id]
if check_party == nil then return false end

for id,party in pairs(PartyTable) do 
	if party == check_party and check_id ~= id and players[id] ~= nil then  
		return true
	end
end

return false
end




function dota1x6:DestroyPlayerUnits(id)

local player = players[id]

if not player then return end 
local team = player:GetTeamNumber()

for _,mod in pairs(player:FindAllModifiers()) do
	if mod:GetName() == "modifier_ember_spirit_fire_remnant_custom_timer" then
		mod:Destroy()
	end
end

local allunits = FindUnitsInRadius( DOTA_TEAM_NOTEAM, Vector(0, 0, 0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 0, false)

for _,unit in pairs(allunits) do

	local unit_id = nil
	if unit and not unit:IsNull() then
		unit_id = unit:GetId()
	end

	if unit and not unit:IsNull() and unit ~= player and unit:GetUnitName() ~= "npc_teleport" and not unit:IsBuilding() then 
		for _, mod in pairs(unit:FindAllModifiers()) do
			if not mod:IsNull() and mod:GetCaster() and mod:GetCaster() == player then
				if mod:GetName() == "modifier_monkey_king_wukongs_command_custom_soldier" then  
					UTIL_Remove(unit)
					break
				else 
					mod:Destroy()
				end
			end
		end
	end

	if unit and not unit:IsNull() and unit_id and players[unit_id] and players[unit_id] == players[id] and not unit:IsBuilding() then
		unit:Kill(nil, nil)
		if unit and not unit:IsNull() and unit:IsCourier() then 
			UTIL_Remove(unit)
		end 
	end
end

local thinkers = Entities:FindAllByClassname("npc_dota_thinker")

for _, thinker in pairs(thinkers) do
	if thinker:GetTeamNumber() == player:GetTeamNumber() then
		UTIL_Remove(thinker)
	end
end

end 




function dota1x6:CheckTowerDeath(tower)
local team = tower:GetTeamNumber()

if not towers[team] then return end

if not tower:IsAlive() then

	local heroes = {}
	local heroes2 = {}
	local killer = tower.killer
	local ids = dota1x6:FindPlayers(team)

	if ids then
	    for _,id in pairs(ids) do
	        heroes[#heroes + 1] = players[id]:GetUnitName()
	    end
	end

	if killer then 
		local ids = dota1x6:FindPlayers(killer:GetTeamNumber())
		if ids then
		    for _,id in pairs(ids) do
		        heroes2[#heroes2 + 1] = players[id]:GetUnitName()
		    end
		end
	end
 	Timers:CreateTimer(0.5, function()
		CustomGameEventManager:Send_ServerToAllClients( 'hero_lost', {ban = 0, abbandon = 0, hero2 = heroes2, hero = heroes} )
	 end)

	dota1x6:destroy_tower(tower)
else
	local ids = dota1x6:FindPlayers(team)
	if not ids then
		dota1x6:destroy_tower(tower)
	end
end

end




function dota1x6:destroy_tower(tower)
local team = tower:GetTeamNumber()

local fillers = FindUnitsInRadius(tower:GetTeamNumber(), tower:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
for _,filler in pairs(fillers) do
	if filler ~= tower and filler ~= teleports[team] then 
		filler:RemoveModifierByName("modifier_invulnerable")
		filler:ForceKill(false)
	end
end

if teleports[team] then
	teleports[team]:AddNewModifier(nil, nil, "modifier_tower_no_owner", {})
end

if duel_data[tower.duel_data] and duel_data[tower.duel_data].finished == 0 then 
	local duel = duel_data[tower.duel_data]

	duel.finished = 1
	duel.tower1.duel_data = -1
	duel.tower2.duel_data = -1

	if duel.thinker and not duel.thinker:IsNull() then 
		duel.thinker:RemoveModifierByName("modifier_duel_field_thinker")
	end 
end

tower:ForceKill(false)

local ids = dota1x6:FindPlayers(team)
if ids then
	for _,id in pairs(ids) do
		if players[id] then
			dota1x6:destroy_player(id)
		end
	end
end

_G.Deaths = _G.Deaths + 1
local place = TeamCount - Deaths + 1

local all_ids = tower.ids
if all_ids then
	for _,id in pairs(all_ids) do
		dota1x6:SaveEndData(id, place)
	end
end

towers[team] = nil
local teams_register = {}
local team_array = {}
local team_count = 0

for _,player in pairs(players) do 
	local left_team = player:GetTeamNumber()
	if not teams_register[left_team] then
		teams_register[left_team] = true
		team_count = team_count + 1
		team_array[team_count] = left_team
	end 
end

if team_count == 3 then

	if IsSoloMode() then
		CustomGameEventManager:Send_ServerToAllClients( 'destroy_tower', {} )
	end

	for _,tower in pairs(towers) do 
		tower:RemoveModifierByName("modifier_the_hunt_custom_tower")
	end

	if dota1x6:IsDuelWave() then 
		for _,duel in pairs(duel_data) do 
			duel.finished = 1
			if duel.tower1 then 
				duel.tower1.duel_data = -1
			end 

			if duel.tower2 then 
				duel.tower2.duel_data = -1
			end
		end 
		
		CustomGameEventManager:Send_ServerToAllClients( "generic_sound", {sound = "Duel.Normal"} )
		dota1x6:FindDuelPairs()
	end 
end

if team_count == 2 then
	for _,player in pairs(players) do 
		player:RemoveModifierByName("modifier_player_damage")
		player.damage_bonus = 0
	end
    dota1x6:InitDuel(team_array[1], team_array[2], 1, false)
end

if team_count == 1 then 
    dota1x6:WinTeam(team_array[1])
    return
end


if TeamCount == 1 then
    dota1x6:WinTeam(team)
    return
end


end


function dota1x6:SaveEndData(id, place)
HTTP.playersData[id].place = place
HTTP.FillItemsData(id, place)
if HTTP.TalentsData and HTTP.TalentsData[tostring(id)] then
	HTTP.TalentsData[tostring(id)].place = place
end

local data = CustomNetTables:GetTableValue( "networth_players", tostring(id))
if data then
	data.place = place
	CustomNetTables:SetTableValue( "networth_players", tostring(id), data)
end

dota1x6:CheckAchivment(id, 1)

HTTP.PlayerEnd( id )
end


function dota1x6:WinAnimation(loser)

_G.Game_end = true

for id,hero in pairs(players) do
	if hero:GetTeamNumber() ~= loser then
		PlayerResource:SetCameraTarget(id, hero)
		hero:AddNewModifier(hero, nil, "modifier_endgame_winner", {})
	end
end

Timers:CreateTimer(2, function()
	if towers[loser] then
		dota1x6:destroy_tower(towers[loser])
	end
end)

CustomGameEventManager:Send_ServerToAllClients( "hide_all_timers", {} )
end


function dota1x6:WinTeam(team)
if test then 
	--return 
end

local tower = towers[team]

local ids = dota1x6:FindPlayers(team)
if ids then
	for _,id in pairs(ids) do
		if players[id] then
			dota1x6:destroy_player(id, true)
		end
	end
end

if tower and tower.ids then
	for _,id in pairs(tower.ids) do
		dota1x6:SaveEndData(id, 1)
	end
end


if HTTP.serverData.isStatsMatch then
	HTTP.Request( "/anal", HTTP.ItemsData, function() end, nil, true)
	if HTTP.TalentsData then
		HTTP.Request( "/anal-talents", HTTP.TalentsData, function() end, nil, true)
	end
end 

for id,player_data in pairs(HTTP.playersData) do
	if player_data.is_active == 1 then

		local change = lobby_rating_change[id]
		local before = 0

		if change and lobby_rating_change[id] and lobby_rating[id] then 
			before = lobby_rating[id] + lobby_rating_change[id]
		end

		local data = CustomNetTables:GetTableValue( "networth_players", tostring(id))
		if data then
			data.items = player_data.items
			data.rating_before = math.max(0,  before)
			data.rating_change = change
			CustomNetTables:SetTableValue( "networth_players", tostring(id), data)
		end

		HTTP.PlayerLeave( id )
	end
end

if dont_end_game == false then 
	CustomGameEventManager:Send_ServerToAllClients( "damage_stats_endscreen", {} )
	CustomGameEventManager:Send_ServerToAllClients( "GameEnded", {} )
	CustomNetTables:SetTableValue("networth_players", "", {game_ended = true})
end

end




function dota1x6:destroy_player(id, no_kill)
if not players[id] then return end

local player = players[id]

if not no_kill then
	dota1x6:DestroyPlayerUnits(id)

	if player:IsAlive() then
		player:AddNewModifier(player, nil, "modifier_death", {})
		player:Kill(nil, nil)
	end

	player:RemoveModifierByName("modifier_aegis_custom")
	player:SetTimeUntilRespawn(-1)
	player:SetBuyBackDisabledByReapersScythe(true)
end

dota1x6:UpdateDamageStats({PlayerID = id})

HTTP.FillOtherData(id)
HTTP.FillDamageData(id)
HTTP.playersData[id].wrong_map_status = player.wrong_map_status
HTTP.playersData[id].kills_done = player.kills_done
HTTP.playersData[id].towers_destroyed = player.towers_destroyed
HTTP.playersData[id].bounty_runes_picked = player.bounty_runes_picked
HTTP.playersData[id].randomed = player.randomed
HTTP.playersData[id].banned = player.banned
HTTP.playersData[id].net = PlayerResource:GetNetWorth(id)
HTTP.playersData[id].items = {}

for i = 0,5 do
    local item = player:GetItemInSlot(i)
    local name = ""
    if item then     
        name = item:GetName()
    end
    table.insert(HTTP.playersData[id].items, name)
end

for _, mod in pairs( player:FindAllModifiers() ) do
	local name = mod:GetName()
	if name == "modifier_item_aghanims_shard" or name == "modifier_item_moon_shard_consumed" or name == "modifier_item_ultimate_scepter_consumed" or name == "modifier_item_travel_boots_2_perma" then
		table.insert( HTTP.playersData[id].buffs, {name = mod:GetName(), stacks = mod:GetStackCount() })
	end
end

local data = CustomNetTables:GetTableValue( "networth_players", tostring(id))
if data then
	data.lost = 1
	data.items = HTTP.playersData[id].item
	CustomNetTables:SetTableValue( "networth_players", tostring(id), data)
end

CustomGameEventManager:Send_ServerToAllClients("pause_end", {id = id})

--if TeamCount == 1 then return end
players[id] = nil

dota1x6:UpdateHeroIcons()
end



function dota1x6:CreateCourier(team, id)
local tower = towers[team]
local teleport = teleports[team]
local player = PlayerResource:GetPlayer(id)

if not tower or not teleport or not player then return end

local vec = (tower:GetAbsOrigin() - teleport:GetAbsOrigin())
local point = teleport:GetAbsOrigin() + vec:Normalized()*230

local ids = dota1x6:FindPlayers(team)
if not ids then return end

for count,player_id in pairs(ids) do
	if player_id == id then
		point = RotatePosition(teleport:GetAbsOrigin(), QAngle(0, -45 + 90*(count - 1), 0), point)
		break
	end
end

local courier = player:SpawnCourierAtPosition(point)
courier:AddNewModifier(courier, nil, "modifier_invun", {})

courier:SetForwardVector(vec)
courier:FaceTowards(courier:GetAbsOrigin() + vec*10)
courier:SetControllableByPlayer(id, true)
couriers_spawned[id] = true

courier.player_owner = id

if players[id] then
	players[id].player_courier = courier
end

end



function dota1x6:initiate_player(player, is_bot)
player:Stop()
local id = player:GetId()

if not HTTP.playersData[id] then return end

HTTP.playersData[id].is_active = 1

if pro_mod then
	local random_number = RandomInt(1, dota1x6.goodwin_max)

	repeat 
		random_number = RandomInt(1, dota1x6.goodwin_max)
	until dota1x6.goodwin_used[random_number] == nil

	dota1x6.goodwin_used[random_number] = true
	player.goodwin_quest = random_number
end

local pause = Pause_Time
if pro_mod then
	pause = Pause_Time_Pro
end


local team = PlayerResource:GetTeam(id)
if not TeamRegistred[team] then
	TeamRegistred[team] = true
	_G.TeamCount = _G.TeamCount + 1
end

local hex_color = "#000000"
if team_color[team] then
	local table_color = team_color[team]
	if not IsSoloMode() then
		SetTeamCustomHealthbarColor(team, table_color[1], table_color[2], table_color[3])
	end
	PlayerResource:SetCustomPlayerColor(id, table_color[1], table_color[2], table_color[3])
	hex_color = dota1x6:rgbToHex(table_color)
end


HTTP.playersData[id].team = team
players[id] = player
player.choise = {}
player.respawn_mod = {}
player.choise_table = {}
player.hero_kills = {}
player.damage_out = {}
player.damage_inc = {}
player.healing_inc = {}
player.temp_damage_stat = {}

player.team_color = hex_color
player.HeroType = dota1x6:GetHeroType(player)
player.upgrades = {}
player.bluepoints = 0
player.purplepoints = 0
player.death = 0
player.purple = 0
player.gray = 0
player.blue = 0
player.chosen_skill = 0
player.chosen_skill_name = 0
player.bluemax = StartBlue
player.purplemax = StartPurple
player.ActiveWave = nil
player.banned = false
player.randomed = 0
player.tower_damage = 0

if SelectedHeroes[id] and  SelectedHeroes[id].random and  SelectedHeroes[id].random == 1 then
	player.randomed = 1
end

player.wrong_map_status = 0
player.reports = 0
player.after_pause_time = 0
player.kills_done = 0
player.towers_destroyed = 0
player.bounty_runes_picked = 0
player.can_refresh_choise = false
player.necro_wave = false
player.can_refresh = true
player.no_buyback = 0
player.left_game = false
player.left_game_timer = 60
player.pause_time = pause
player.promo_cd = 0
player.legendary_talent = 0
player.legendary_skill_name = 0
player.razor_count = 0
player.connect_state = 0

if tostring(PlayerResource:GetSteamAccountID(id)) == "390002773" then 
	player.pause_time = 60
end 

player.pause = -1
player.x_min = -8100
player.x_max = 8100
player.y_min = -8100
player.y_max = 8100



player.z = 215
player.HideDouble = 0
player.orange_count = 0
player.patrol_kills = 0
player.obs_placed = 0
player.sentry_placed = 0
player.obs_kills = 0
player.sentry_kills = 0
player.damage_bonus = 0
player.tips_cooldown = 0
player.tips_available = 1

player.hero_tier = -1
player.hide_tier = 0
player.disable_quest = 0
player.disable_tips = 0
player.subscribed = 0
player.uses_free_build = 0
player.completed_start_quest = (HTTP.playersData[id].achivment_done_before and HTTP.playersData[id].achivment_done_before[2]) and 1 or 0

player.base_attack_type = player:GetAttackCapability()
player.base_model = player:GetModelName()
player.base_model_scale = player:GetModelScale()

player:RemoveAbility("ability_capture")
player:RemoveAbility("abyssal_underlord_portal_warp")
player:RemoveAbility("ability_lamp_use")
player:RemoveAbility("ability_pluck_famango")

local add_abilites = 
{
	"mid_teleport",
	"custom_bkb_effects",
	"high_five_custom",
	"custom_ability_smoke",
	"custom_ability_observer",
	"custom_ability_sentry",
	"custom_ability_dust",
}

for _,ability_name in pairs(add_abilites) do
	local new_ability = player:AddAbility(ability_name)
	new_ability:SetLevel(1)
end

if player.is_bot then 
	--high_five:SetHidden(false)
end

if player:HasAbility("muerta_pierce_the_veil_custom") then 
	player:AddNewModifier(player, player:FindAbilityByName("muerta_pierce_the_veil_custom"), "modifier_muerta_pierce_the_veil_custom_tracker", {})
end

if custom_voice[player:GetUnitName()] then 
	player:AddNewModifier(player, nil, "modifier_voice_module", {})
end 

player:AddNewModifier(player, nil, "modifier_portrait_donate_custom", {})
player:AddNewModifier(player, nil, "modifier_percent_stats", {})
player:AddNewModifier(player, nil, "modifier_general_stats_init", {})
player:AddNewModifier(player, nil, "modifier_patrol_reward_timer", {})
player:AddNewModifier(player, nil, "modifier_on_respawn", {})

Timers:CreateTimer(1, function() 
	player:AddNewModifier(player, nil, "modifier_player_damage", {})
end)

local mod = player:FindModifierByName("modifier_item_custom_dust_charges")
if mod then 
	local stack = mod:GetAbility():GetSpecialValueFor("start_stack")
	if not IsSoloMode() then
		stack = mod:GetAbility():GetSpecialValueFor("start_stack_duo")
	end
	mod:SetStackCount(stack)
end

local hero_name = player:GetUnitName()
local sub_data = CustomNetTables:GetTableValue("sub_data", tostring(id))
local no_alert = false

if sub_data then
	player.hide_tier = sub_data.hide_tier
	player.disable_quest = sub_data.disable_quest
	player.disable_tips = sub_data.disable_tips

	if sub_data.used_quest_reward and sub_data.used_quest_reward == 0 and player.completed_start_quest == 1 then
		Timers:CreateTimer(5, function()
			start_quest:QuestReward(id)
		end)
	end

	if sub_data.subscribed == 1 then
		player.subscribed = 1
		if sub_data.heroes_data[hero_name] and sub_data.heroes_data[hero_name].has_level == 1 then 
			player.hero_tier = sub_data.heroes_data[hero_name].tier
			local particle = ParticleManager:CreateParticle( "particles/hero_spawn_hero_level_"..(sub_data.heroes_data[hero_name].tier + 1)..".vpcf", PATTACH_ABSORIGIN_FOLLOW, player )
			ParticleManager:ReleaseParticleIndex( particle )
		end
	end
end

local arcana_result = shop:GiveArcanaChestForPlayer(id, no_alert)
local no_achivment = HTTP.playersData[id].achivment_done_before and not HTTP.playersData[id].achivment_done_before[1]
if not pro_mod and arcana_result ~= -1 and (player.completed_start_quest == 1 or player.disable_quest == 1) and not test then
--	if arcana_result == 1 or (arcana_result == 0 and not no_achivment) then
		Timers:CreateTimer(3, function()
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'arcana_alert', {type = arcana_result} ) 
		end)
--	elseif no_achivment then
	--	Timers:CreateTimer(3, function()
		--	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'duo_gift_alert', {} ) 
		--end)
	--end
end


chat_wheel:SetDefaultSound(id)
   
if HTTP.GetPlayerData(id) then 
   	player.islp = HTTP.GetPlayerData(id).lowPriorityRemaining > 0
end

Timers:CreateTimer(0.2, function()
	player:HeroLevelUp(false)
	player:HeroLevelUp(false)
end)


for _,name in pairs(start_abilities) do 
	local ability = player:FindAbilityByName(name)
	if ability then 
		ability:SetLevel(1)
	end
end

if player:FindAbilityByName("monkey_king_mischief_custom") then 
	player:FindAbilityByName("monkey_king_mischief_custom"):SetLevel(1)
end


local tp_item = CreateItem("item_tpscroll_custom", player, player)
player:AddItem(tp_item)

CustomNetTables:SetTableValue("custom_items_button", tostring(id), {observer = 0, sentry = 0})

local lvl = -1
local hero_name = player:GetUnitName()

if sub_data then 

	if sub_data.heroes_data[hero_name] and sub_data.heroes_data[hero_name].has_level == 1 and sub_data.subscribed == 1 and sub_data.hide_tier == 0 then
		lvl = sub_data.heroes_data[hero_name].tier 
	end

	shop:AddPetFromStart(id)

	chat_wheel:SetDefaultSound(id)
end

if TopDonat[tostring(PlayerResource:GetSteamAccountID(id))] ~= nil then 
	player:AddNewModifier(player, nil, "modifier_top_donate", {})
end



if player:GetQuest() == nil and SelectedQuests[id] ~= nil then

	local quest_table = {}
	quest_table.name = SelectedQuests[id]
	local quests_data = CustomNetTables:GetTableValue("hero_quests", tostring(id));

	for hero_name,quest in pairs(quests_data) do 

		if hero_name == player:GetUnitName() then 

			for _,hero_quest in pairs(quest) do 
				if hero_quest.name == SelectedQuests[id] then 

					quest_table.exp = hero_quest.exp
					quest_table.shards = hero_quest.shards
					quest_table.icon = hero_quest.icon
					quest_table.goal = hero_quest.goal
					quest_table.legendary = hero_quest.legendary
					quest_table.number = hero_quest.number
				end
			end
		end
	end

	player:SetQuest(quest_table)
end

if HTTP.GetPlayerData(id) then 
    CustomNetTables:SetTableValue("TipsType", tostring(id), {type = HTTP.GetPlayerData(id).tipsType})
end

dota1x6:RequestSubscribed({PlayerID = id})

CustomNetTables:SetTableValue("hero_portrait_levels", tostring(hero_name), {tier = lvl, id = id})

CustomNetTables:SetTableValue("spectator_points", tostring(id), {blue = player.bluepoints, purple = player.purplepoints, max = StartBlue, max_p = StartPurple})
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "kill_progress", {blue = player.bluepoints, purple = player.purplepoints, max = StartBlue, max_p = StartPurple} )
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'init_damage_table', {free_build = player.uses_free_build, subscribed = player.subscribed} ) 
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'init_custom_item_build', {}) 
CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'reconnect_hero_image', { } ) 
CustomGameEventManager:Send_ServerToAllClients('update_score_table', {}) 

if player:HasAbility("invoker_invoke_custom") then
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "initInvokerPanel",  {})
end

if sub_data and (test or (not IsUnrankedMap() and HTTP.IsValidGame(PlayerCount))) then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'init_double_rating', {cd = sub_data.double_rating_cd, subscribed = sub_data.subscribed} ) 
end

if towers[player:GetTeamNumber()] then
	towers[player:GetTeamNumber()].ids = dota1x6:FindPlayers(player:GetTeamNumber())
end

if global_values[hero_name] then 
	talents_icons[hero_name] = {}
	for talent_name,talent in pairs(global_values[hero_name]) do
		talents_icons[hero_name][talent_name] = {}
		talents_icons[hero_name][talent_name].icon = hero_name .. "/" .. talent["mini_icon"]
		talents_icons[hero_name][talent_name].color = talent["rarity"]
	end 
end 

if not is_bot then return end

if not towers[player:GetTeamNumber()] then
	dota1x6:SetTower(player)
end

Timers:CreateTimer(0.1, function()

	if towers[player:GetTeamNumber()] then
		local team = player:GetTeamNumber()
		local respaw_pos = Entities:FindByName(nil, towers[player:GetTeamNumber()]:GetName() .."_respawn")
		local spawner = Entities:FindByName(nil, "spawn" .. team)
		if spawner then
			if respaw_pos then
				spawner:SetAbsOrigin(respaw_pos:GetAbsOrigin())
			else
		    	spawner:SetAbsOrigin(towers[player:GetTeamNumber()]:GetAbsOrigin() + RandomVector(300))
			end
		end
	end

	dota1x6:UpdateHeroIcons()
end)

end






function dota1x6:FindPlayers(team, give_names, give_heroes)
local result = {}
for id,player in pairs(players) do
	if player:GetTeamNumber() == team then
		if give_names then
			table.insert(result, player:GetUnitName())
		elseif give_heroes then
			table.insert(result, player)
		else
			table.insert(result, id)
		end
	end
end

if give_names or give_heroes or #result > 0 then
	return result
else
	return nil
end

end







function dota1x6:FindDuelPairs()

local net = dota1x6:GetTeamsNet()

if #net > 1 then 
    table.sort( net, function(x,y) return y.gold > x.gold end )
else 
	return
end 

if #net > 3 then 
	local duel_1_team_1 = net[#net].team
	local duel_1_team_2 = -1
	local duel_2_team_1 = net[#net - 3].team 
	local duel_2_team_2 = -1

	local duel_3_team_1 = -1
	local duel_3_team_2 = -1 

	local duel_3_only_mid = false

	if #net == 6 then 

		duel_3_team_1 = net[1].team
		duel_3_team_2 = net[2].team

		if dota1x6:IsMidPlayer(duel_3_team_1) and dota1x6:IsMidPlayer(duel_3_team_2) then 
			duel_3_only_mid = true
		end 

		dota1x6:InitDuel(duel_3_team_1, duel_3_team_2, 0, not duel_3_only_mid)
	end 


	if towers[duel_1_team_1] and towers[duel_1_team_1].last_enemy then 

		if towers[duel_1_team_1].last_enemy == net[#net - 1].team then 
			duel_1_team_2 = net[#net - 2].team
			duel_2_team_2 = net[#net - 1].team
		else 
			if towers[duel_1_team_1].last_enemy == net[#net - 2].team then 
				duel_1_team_2 = net[#net - 1].team
				duel_2_team_2 = net[#net - 2].team
			end 
		end 
	end 

	if duel_1_team_2 == -1 then

		if towers[duel_2_team_1] and towers[duel_2_team_1].last_enemy then 

			if towers[duel_2_team_1].last_enemy == net[#net - 1].team then 
				duel_2_team_2 = net[#net - 2].team
				duel_1_team_2 = net[#net - 1].team
			else 

				if towers[duel_2_team_1].last_enemy == net[#net - 2].team then 
					duel_2_team_2 = net[#net - 1].team
					duel_1_team_2 = net[#net - 2].team
				end 
			end 
		end 

		if duel_2_team_2 == -1 then 
			local random = RandomInt(1,2)

			local random2 = random

			repeat random2 = RandomInt(1, 2)
			until random2 ~= random

	 		duel_1_team_2 = net[#net - random].team 
	 		duel_2_team_2 = net[#net - random2].team 
	 	end
	end 

	dota1x6:InitDuel(duel_1_team_1, duel_1_team_2, 0, duel_3_only_mid)
	dota1x6:InitDuel(duel_2_team_1, duel_2_team_2, 0, false)
else 
	if #net > 2 then 
		local team_1 = nil 
		local team_2 = nil

		for team,tower in pairs(towers) do 
			if tower.won_duel == 1 then 
				team_1 = team
				break
			end 
		end 

		if team_1 then
			for team,tower in pairs(towers) do 
				if tower.won_duel ~= -1 and team ~= team_1 then 
					team_2 = team
					break
				end 
			end 
		else
			team_1 = net[#net].team
		end


		if team_2 == nil then 
			if towers[team_1] and towers[team_1].last_enemy then 

				if towers[team_1].last_enemy == net[1].team then 
					team_2 = net[2].team
				end 

				if towers[team_1].last_enemy == net[2].team then 
					team_2 = net[1].team
				end 
			end 

			if team_2 == nil then 
				team_2 = net[RandomInt(1, #net - 1)].team
			end 
		end 

		dota1x6:InitDuel(team_1, team_2, 0, false)
		
		for team,tower in pairs(towers) do 
			tower.won_duel = 0
		end 
	end 
end 

end 




function dota1x6:InitDuel(team1, team2, final, use_base_field)
if not IsServer() then return end
local tower1 = towers[team1]
local tower2 = towers[team2]

if not tower1 or not tower2 then return end
if team1 == team2 then return end

if final == 1 then 

	CustomGameEventManager:Send_ServerToAllClients( "generic_sound", {sound = "FinalDuel.Start"} )
			
	for _,data in pairs(duel_data) do 
		if data.finished == 0 then 
			data.finished = 1
			
			if data.tower1 and not data.tower1:IsNull() then
				data.tower1.duel_data = -1
			end

			if data.tower2 and not data.tower2:IsNull() then
				data.tower2.duel_data = -1
			end

			if data.thinker and not data.thinker:IsNull() then 
				data.thinker:RemoveModifierByName("modifier_duel_field_thinker")
			end 
		end 
	end 
end 


local number = #duel_data + 1

tower1.duel_data = number
tower2.duel_data = number

duel_data[number] = {}

duel_data[number].tower1 = tower1
duel_data[number].tower2 = tower2

duel_data[number].heroes = {}
for i = 1,2 do
	duel_data[number].heroes[i] = {}
	local team = team1
	if i == 2 then
		team = team2
	end
	local ids = dota1x6:FindPlayers(team)
	if ids then
		duel_data[number].heroes[i] = {}
		for _,id in pairs(ids) do
			local player = players[id]
			if player then
				local count = #duel_data[number].heroes[i] + 1
				duel_data[number].heroes[i][count] = {}
				duel_data[number].heroes[i][count].hero = player:GetUnitName()
				duel_data[number].heroes[i][count].id = id
			end
		end
	end
end

duel_data[number].wins1 = 0
duel_data[number].wins2 = 0
duel_data[number].final_duel = final
duel_data[number].field_created = 0
duel_data[number].field = nil
duel_data[number].rounds = 0
duel_data[number].finished = 0
duel_data[number].timer = 0
duel_data[number].max_timer = duel_timer_normal
duel_data[number].thinker = nil
duel_data[number].stage = 1
duel_data[number].top3 = 0
duel_data[number].use_base_field = -1


if use_base_field == true then
	if not dota1x6:IsMidPlayer(team1) then 
		duel_data[number].use_base_field = dota1x6:GetBase(team1)
	else 
		duel_data[number].use_base_field = dota1x6:GetBase(team2)
	end 
end  

if final == 1 then 
 	MaxTimer = duel_timer
 	if test then 
 		MaxTimer = 5
 	end
 	timer = 0
	duel_data[number].max_timer = duel_timer_final
end 

local count = 0

for _,tower in pairs(towers) do 
	count = count + 1
end 

if count == 3 then 
	duel_data[number].top3 = 1
end 

end


function dota1x6:CreateDuelField(index)
if not duel_data[index] then return end 
if duel_data[index].field_created == 1 then return end

local use_walls = 0
local field = 0

if duel_data[index].final_duel == 1 and duel_data[index].field then 

	if duel_data[index].field == duel_fields['1'] then 
		field = '2'
	else 
		field = '1'
	end 

else 
	if duel_data[index].use_base_field == -1 then 

		if duel_last_field == "1" then 
			duel_last_field = "2"
		else 
			duel_last_field = "1"
		end 

		field = duel_last_field
	else 
		use_walls = 1
		field = tostring(duel_data[index].use_base_field)
	end 
end 


duel_data[index].field = duel_fields[field]
duel_data[index].field_created = 1

duel_data[index].rounds = duel_data[index].rounds + 1

local vec = duel_data[index].field.start1_1 - duel_data[index].field.start2_1
local point = duel_data[index].field.start1_1 - vec:Normalized()*(vec:Length2D()/2)

if duel_data[index].center then
	point = duel_data[index].center
end

duel_data[index].thinker = CreateModifierThinker(nil, nil, "modifier_duel_field_thinker", {index = index, use_walls = use_walls}, point, DOTA_TEAM_NEUTRALS, false)
end 





function dota1x6:MuertaQuestPhase(hero)

if hero and muerta_quest_hero == nil then 
    muerta_quest_hero = hero
end

muerta_quest_phase = muerta_quest_phase + 1

if muerta_quest_phase > 2 then 
    muerta_quest_phase = 0
end

if muerta_quest_phase == 1 then 
    muerta_quest_timer = muerta_quest_max - muerta_quest_max_start
    muerta_quest_active = true

    local count = RandomInt(1, 10) 

    for i = 1,count do 

        local random_1 = RandomInt(1, #muerta_quest_creeps)
        local random_2 = random_1

        repeat random_2 = RandomInt(1, #muerta_quest_creeps)
        until random_2 ~= random_1
     
        local buffer = muerta_quest_creeps[random_1]

        muerta_quest_creeps[random_1] = muerta_quest_creeps[random_2]
        muerta_quest_creeps[random_2] = buffer
    end
end

end



function dota1x6:MuertaQuestSpawnDig()

local spawners = Entities:FindAllByName("muerta_dig_area")

if #spawners > 0 then 
    local abs = spawners[RandomInt(1, #spawners)]:GetAbsOrigin()

    GameRules:ExecuteTeamPing(muerta_quest_hero:GetTeamNumber(), abs.x, abs.y, muerta_quest_hero, 0 )

    local thinker = CreateUnitByName("npc_dota_companion", abs, false, nil, nil,muerta_quest_hero:GetTeamNumber())
    thinker:AddNewModifier(muerta_quest_hero, nil, "modifier_muerta_gunslinger_custom_dig_area", {}) 

    local bounty = CreateUnitByName("npc_dota_companion", abs + RandomVector(RandomInt(100, 500)), false, nil, nil,muerta_quest_hero:GetTeamNumber())
    bounty:AddNewModifier(muerta_quest_hero, nil, "modifier_muerta_gunslinger_custom_dig_bounty", {area = thinker:entindex()}) 
end

end


function dota1x6:MuertaQuestSpawnCreep()

local spawners = Entities:FindAllByName("muerta_creep_area")

if #spawners > 0 then 
    local abs = spawners[RandomInt(1, #spawners)]:GetAbsOrigin()
    GameRules:ExecuteTeamPing(muerta_quest_hero:GetTeamNumber(), abs.x, abs.y, muerta_quest_hero, 0 )

    local unit = CreateUnitByName(muerta_quest_creeps[muerta_quest_creep_count], abs, true, nil, nil, DOTA_TEAM_NEUTRALS)
    unit:AddNewModifier(muerta_quest_hero, nil, "modifier_muerta_creep", {})
end

muerta_quest_creep_count = muerta_quest_creep_count + 1

if muerta_quest_creep_count > #muerta_quest_creeps then 
    muerta_quest_creep_count = 1
end

end



function dota1x6:MuertaQuestClearArea()
if not muerta_quest_hero then return end

local units = FindUnitsInRadius( muerta_quest_hero:GetTeamNumber(), Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false )

for _,unit in pairs(units) do
    if unit and not unit:IsNull() and unit:HasModifier("modifier_muerta_gunslinger_custom_dig_bounty") then 
        unit:FindModifierByName("modifier_muerta_gunslinger_custom_dig_bounty"):Complete()
    end

    if unit and not unit:IsNull() and unit:HasModifier("modifier_muerta_creep") then 
        unit:Kill(nil, nil)
    end
end

end


function dota1x6:MuertaQuestTimer()

if muerta_quest_phase ~= 0 and muerta_quest_hero ~= nil and players[muerta_quest_hero:GetId()] and muerta_quest_active == true then 

    muerta_quest_timer = muerta_quest_timer + 1

    if muerta_quest_timer >= muerta_quest_max then 
        muerta_quest_active = false
        muerta_quest_timer = 0

        if muerta_quest_phase == 1 then 
            dota1x6:MuertaQuestSpawnDig()
        end

        if muerta_quest_phase == 2 then 
            dota1x6:MuertaQuestSpawnCreep()
        end
    end
end

end 




function dota1x6:TestQuest(hero)

if muerta_quest_phase == 1 then 
    dota1x6:MuertaQuestSpawnDig(hero)
end

if muerta_quest_phase == 2 then 
    dota1x6:MuertaQuestSpawnCreep(hero)

end

end
