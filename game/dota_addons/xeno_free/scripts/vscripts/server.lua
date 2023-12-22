require("debug_")

HTTP = {}


function GenerateMatchKey()
	local syms = {
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
		'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
		"1", "2", "3", "4", "5", "6", "7", "8", "9", "0"
	}

	local key = ""

	for i = 1, 32 do
		key = key .. syms[RandomInt( 1, #syms )]
	end

	return key
end

HTTP.GAME_HOST =  "https://dota1x6.com/api/game" --"http://23.111.202.212/api/game" --
HTTP.STATS_HOST =   "https://stats.dota1x6.com/api"
HTTP.KEY =   GetDedicatedServerKeyV3( "dota1x6key" )   -- 
HTTP.MATCH_ID = tostring( IsInToolsMode() and RandomInt( 1, 999999 ) or GameRules:Script_GetMatchID() )

HTTP.MATCH_KEY = GenerateMatchKey()
HTTP.MATCH_CLUSTER = Convars:GetInt( "sv_cluster" )
HTTP.MATCH_REGION = Convars:GetInt( "sv_region" )
HTTP.serverData = nil
HTTP.playersData = {}
HTTP.leavedPlayers = {}
HTTP.ItemsData = {}

for id = 0, 24 do
	HTTP.playersData[id] = {
		items = {},
		buffs = {},
		talents = {},
		heroDamage = 0,
		towerDamage = 0,
		isLeaver = false,
		ratingChange = 0,
		lost_game = false,
		dpHeroMatchXp = 0,
		dpHeroQuestXp = 0,
		matchShardsReceipts = {},
	}
end

function TableMap( t, cb )
	local new = {}

	for k, v in pairs( t or {} ) do
		local nv, nk = cb( v, k )
		new[nk or k] = nv or v
	end

	return new
end

function HTTP.GetMatchId()
	return HTTP.MATCH_ID == "0" and tostring( GameRules:Script_GetMatchID() ) or HTTP.MATCH_ID
end

function HTTP.GetAccountPlayerId( playerId )
	if type( playerId ) == "number" then
 		return tostring( PlayerResource:GetSteamAccountID( playerId ) )
	else
		return tostring( playerId )
	end
end


function HTTP.FillOfflineServerData()
	if HTTP.serverData and not HTTP.serverData.isOffline then
		return
	end

	local data = {
		isStatsMatch = false,
		isOffline = true,
		seasonName = "Server offline",
		averageRating = 0,
		leaderboard = {
		--	{
				--steamID = "",
				--favoriteHero = "npc_dota_hero_broodmother",
				--matchCount = 1337,
			--	rating = 228,
			--}
		},

		end_date = "24.01.2022",
        active_vote = 0,
        hero_won = "npc_dota_hero_sven",

		heroes_vote = 
		{
			{'npc_dota_hero_ursa', 0, 0, 2},
			{'npc_dota_hero_furion', 0, 0, 3},
			{'npc_dota_hero_sniper', 0, 0, 2},
		},
		players = {}
	}

	for id = 0, 24 do
		if PlayerResource:IsValidPlayerID( id ) then

 
			local all_heroes_data = {}

			local player_items_onequip = {}

			for _,hero_name in pairs(all_heroes) do 

				all_heroes_data[hero_name] = {}

				all_heroes_data[hero_name].quests = {}

				all_heroes_data[hero_name].exp = 0--RandomInt(1, 60)
				all_heroes_data[hero_name].level = 1
					
				if (hero_name == "npc_dota_hero_antimage") then  
					--all_heroes_data[hero_name].level = 2
				end

				player_items_onequip[hero_name] = {}

				if hero_name == "npc_dota_hero_razor" and test then 
				--	table.insert(player_items_onequip[hero_name], 23095)
				end 
			end	


			local items_ids = {}
			
			local chat_wheel = {0,0,0,0,0,0,0,0}

			local sub = 0
			if test then 
				sub = 1
			end
			local points = 0
			if test then 
				points = 10000000
			end

			data.players[id] = {
				steamID = tostring( PlayerResource:GetSteamAccountID( id ) ),
				rating = 0,
				tipsType = 3,
				UsedWrongMap = 0,
				isAdmin = false,
				isBanned = false,
				lowPriorityRemaining = 0,
				favoriteHero = "",
				matchCount = 0,
				subData = 
				{ 
					points = points,
					subscribed = sub,
					hide_tier = 0,
					pet_id = 0,
					double_rating_cd = 0, 
					heroes_data = all_heroes_data,
					items_ids = items_ids,
					chat_wheel = chat_wheel,
					votes_count = 3,
					free_vote_cd = 0,
					bonus_shards_cd = 0,
					sub_time = 0,
					quests_cd = 10,
					player_items_onequip = player_items_onequip,
				},

				keyBinds = {keybind_observer_ward = "1", keybind_sentry_ward = "2", keybind_smoke = "3", keybind_dust = "4", keybind_grenade = "5"},
				heroes = 
				{
					--npc_dota_hero_huskar = {
				--		matchCount = 12,
					--	kills = 44,
				--		deaths = 12,
				--		rating = -25
				--	}
				},
				matches = {
					--{
				--		heroName = "npc_dota_hero_huskar",
					--	firstOrangeTalent = "inner_fire",
					--	items = {"item_dagon_1_custom"},
				--		kills = 50,
				--		deaths = 120,
				--		duration = 45 * 60 + 12,
					--	date = 0,
				--	}
				}
			} 
		end
	end

	HTTP.serverData = data

	HTTP.InitServerData()
end


function HTTP.InitServerData()

local total = 0
local count = 0
for id = 0, 24 do
	if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then 
		_G.lobby_rating[id] = HTTP.serverData.players[id].rating
		total = total + lobby_rating[id]
		count = count + 1
	end
end

_G.avg_rating = math.floor(total/math.max(1,count))


local name = GetMapName()
local min = 0
local max = 99999

if rating_thresh[name] then
	min = rating_thresh[name].min
	max = rating_thresh[name].max
end



CustomNetTables:SetTableValue(
	"server_data",
	"",
	{
		is_match_made = true,
		season_name = HTTP.serverData.seasonName
	}
)



CustomNetTables:SetTableValue(
	"leaderboard",
	"leaderboard",
	TableMap( HTTP.serverData.leaderboard, function( row )
		return {
			playerId = row.playerId,
			rating = row.rating,
			favorite_hero = row.favoriteHero,
			total_matches = row.matchCount,

		}
	end )
)

if HTTP.serverData.voting then

	local heroes_vote = {}
	for _,kv in pairs(HTTP.serverData.voting.heroes) do 
		table.insert(heroes_vote, {kv.heroName, kv.voteCount, 0, kv.attributeId})
	end



	CustomNetTables:SetTableValue(
		"sub_data",
		"heroes_vote",
		{
			end_date = "23.11.2023",-- HTTP.serverData.voting.endDateString,
			hero_won =  HTTP.serverData.voting.heroWon,
			active_vote = HTTP.serverData.voting.isActive,
			vote_table = heroes_vote
		}
			
	)
else 

	CustomNetTables:SetTableValue(
		"sub_data",
		"heroes_vote",
		{
			end_date = HTTP.serverData.end_date,
			hero_won = HTTP.serverData.hero_won,
			active_vote = HTTP.serverData.active_vote,
			vote_table = HTTP.serverData.heroes_vote
		}	
	)

end


CustomNetTables:SetTableValue(
	"custom_pick",
	"avg_rating",
	{
		avg_rating = avg_rating
	}
)



for i, player in pairs( HTTP.serverData.players ) do

	local pid = HTTP.GetPlayerBySteamID( player.steamID )
	local sub_data = player.subData


	local new_quests = false


	if test or (sub_data.quests_cd == 0 and (sub_data.subscribed == 1 or sub_data.subscribed == true)) then 
		new_quests = true
		sub_data.quests_cd = shop_quests_cd
	end

	local all_heroes_data = {}
	local quests_net_table = {}


	for _,hero_name in pairs(all_heroes) do 


		all_heroes_data[hero_name] = {}
		all_heroes_data[hero_name].level = 1
		all_heroes_data[hero_name].exp = 0


		all_heroes_data[hero_name].quests = {}
		quests_net_table[hero_name] = {}


		if sub_data.heroes_data[hero_name] == nil then 
			sub_data.heroes_data[hero_name] = {}
			sub_data.heroes_data[hero_name].exp = 0
			sub_data.heroes_data[hero_name].level = 1
			sub_data.heroes_data[hero_name].quests = {}
		else 
			all_heroes_data[hero_name].level = sub_data.heroes_data[hero_name].level
			all_heroes_data[hero_name].exp = sub_data.heroes_data[hero_name].exp
		end


		all_heroes_data[hero_name].quests = sub_data.heroes_data[hero_name].quests or {}

		if new_quests == true then 
			all_heroes_data[hero_name].quests = my_game:FillQuests(hero_name)
		end

		for _,quest_name in pairs(all_heroes_data[hero_name].quests) do
			for _,shop_hero_quest in pairs(All_Quests.hero_quests[hero_name]) do 
				if (shop_hero_quest.name == quest_name) then 
   					local n = #quests_net_table[hero_name] + 1
   					quests_net_table[hero_name][n] = {}
   					quests_net_table[hero_name][n].goal = shop_hero_quest.goal
   					quests_net_table[hero_name][n].name = shop_hero_quest.name
   					quests_net_table[hero_name][n].exp = shop_hero_quest.reward_exp
   					quests_net_table[hero_name][n].shards = shop_hero_quest.reward_shards
   					quests_net_table[hero_name][n].icon = shop_hero_quest.icon
   					quests_net_table[hero_name][n].number = shop_hero_quest.number
   					quests_net_table[hero_name][n].legendary = nil 
   					if shop_hero_quest.legendary then 
   						quests_net_table[hero_name][n].legendary = shop_hero_quest.legendary
   					end
				end
			end

			for _,shop_hero_quest in pairs(All_Quests.general_quests) do 
				if (shop_hero_quest.name == quest_name) then
   					local n = #quests_net_table[hero_name] + 1
   					quests_net_table[hero_name][n] = {}
   					quests_net_table[hero_name][n].goal = shop_hero_quest.goal
  					quests_net_table[hero_name][n].name = shop_hero_quest.name
 					quests_net_table[hero_name][n].exp = shop_hero_quest.reward_exp
   					quests_net_table[hero_name][n].shards = shop_hero_quest.reward_shards
   					quests_net_table[hero_name][n].icon = shop_hero_quest.icon
   					quests_net_table[hero_name][n].number = shop_hero_quest.number
				end
			end
		end

	    local tier = 0

	    for i,thresh in pairs(level_thresh) do
	    	if all_heroes_data[hero_name].level >= thresh then 
	    		tier = i
	    	else
	    		break
	    	end 
	    end

	    all_heroes_data[hero_name].tier = tier
	    all_heroes_data[hero_name].has_level = 0


	    if all_heroes_data[hero_name].level > 1 or all_heroes_data[hero_name].exp > 0 then 
	   		all_heroes_data[hero_name].has_level = 1
	    end
	end	

	sub_data.heroes_data = all_heroes_data



	if new_quests == true then 
		HTTP.UpdateQuests( pid, all_heroes_data, sub_data.quests_cd * 1000 )
	end



	CustomNetTables:SetTableValue("sub_data", tostring(pid), sub_data)


	CustomNetTables:SetTableValue("hero_quests", tostring(pid), quests_net_table)

	CustomNetTables:SetTableValue("keybinds", tostring(pid), player.keyBinds)

	if pid then
		for hero_name, stats in pairs( player.heroes ) do
			CustomNetTables:SetTableValue(
				"server_hero_stats",
				tostring(pid) .. "_" .. hero_name,
				{
					places = TableMap( stats.places, function( count, place )
						return count, tonumber( place ) - 1
					end ),
					rating = stats.rating,
					kills = stats.kills,
					deaths = stats.deaths,
					total = stats.matchCount
				}
			)
		end

		local wrong_map = 0




		if player.rating and HTTP.serverData and HTTP.serverData.isStatsMatch == true then 
			if player.rating > max or player.rating < min then 
				wrong_map = 1
			end
		end

		local used_wrong_map = 0

		if player.UsedWrongMap ~= nil then 
			used_wrong_map = player.UsedWrongMap
		end

		local wrong_map_status = 0
		if test then 
		--	wrong_map_status = 2
		end 

		if wrong_map == 1 then 

			if (player.rating > max and player.rating - max <= 40) 
				or (player.rating < min and min - player.rating <= 40) then 

				wrong_map_status = 1
			else 
				wrong_map_status = 2
			end

		end


		local tier = 0
		local in_ranked = 0

		if player.rating then 
			for i = 1,#ranked_tier do 
				if player.rating < ranked_tier[i]  then 
					tier = i - 1
					break
				end
			end
		end
		if rating_thresh[GetMapName()] then 
			in_ranked = 1
		end

		CustomNetTables:SetTableValue(
			"server_data",
			tostring(pid),
			{
				stats_match = HTTP.serverData.isStatsMatch,
				total_games = player.matchCount,
			 	rating = player.rating,
			 	ranked_tier = tier,
				rank_tier = 0,
				in_ranked = in_ranked,
				leaderboard_rank = 0,
				map_rating = {min = min, max = max},
				wrong_map_status = wrong_map_status,
				competitive_calibration_games_remaining = 0,
				favorite_hero = player.favoriteHero,
				places = TableMap( player.places, function( count, place )
					return count, tonumber( place ) - 1
				end ),
				lp_games_remaining = player.lowPriorityRemaining,
				player_matches = TableMap( player.matches, function( match )
					return {
						hero = match.heroName,
						orange_talent = match.mainTalent,
						items = match.items,
						kills = match.kills,
						deaths = match.deaths,
						place = match.place,
						rating = match.ratingChange,
						duration = match.duration,
						date = match.date,
						endTime = match.endTime,
					}
				end )
			}
		)
	end
end

CustomGameEventManager:Send_ServerToAllClients( 'update_lobby_rating', {} ) 

end

function HTTP.SavePlayerItems( id ) 
	local hero = GlobalHeroes[id]

	if hero then
		local items = {}

		for i = 0, 5 do
			local item = hero:GetItemInSlot( i )
			
			if item then
				items[i] = item:GetAbilityName()
			end
		end

		HTTP.playersData[id].items = items
	end
end

function HTTP.AddDotaPlusHeroXp( id, amount )
	HTTP.playersData[id].dpHeroXp = HTTP.playersData[id].dpHeroXp + amount
end

function HTTP.AddPlayerMatchShardsReceipt( id, amount, desc )
	table.insert( HTTP.playersData[id].matchShardsReceipts, {
		amount = amount,
		desc = desc
	} ) 
end


function HTTP.SavePlayerBuffsTalents( id ) 
	local hero = GlobalHeroes[id]

	if hero then
		for _, mod in pairs( hero:FindAllModifiers() ) do
			local name = mod:GetName()

			if (
				name == "modifier_item_aghanims_shard" or
				name == "modifier_item_moon_shard_consumed" or
				name == "modifier_item_ultimate_scepter_consumed" or
				name == "modifier_item_essence_of_speed"
			) then
				table.insert( HTTP.playersData[id].buffs, {
					name = mod:GetName(),
					stacks = mod:GetStackCount()
				} )
			end

			if mod.IsUpgrade and mod.UpgradeName then
				table.insert( HTTP.playersData[id].talents, {
					name = mod.UpgradeName,
					level = mod:GetStackCount()
				} )
			end
		end
	end
end

function HTTP.GetPlayerData( id )
	if not HTTP.serverData then return end

	local steamID = tostring( PlayerResource:GetSteamAccountID( id ) )

	local fake = nil

	for _, player in pairs( HTTP.serverData.players or {} ) do

		fake = player

		if player.steamID == steamID then
			return player
		end
	end

	return fake
end

function HTTP.GetPlayerBySteamID( steamID )
	for id = 0, 24 do
		if steamID == tostring( PlayerResource:GetSteamAccountID( id ) ) then
			return id
		end
	end

	return -1
end

function HTTP.IsValidGame( count )
if test then return false end
	return IsInToolsMode() or count >= 6 or test == true 
end

function HTTP.Request( url, data, cb, tries, isStats )


    if not isStats then
        data.matchId = HTTP.GetMatchId()
        data.matchKey = HTTP.MATCH_KEY
    end

	local r = CreateHTTPRequestScriptVM( "POST", ( isStats and HTTP.STATS_HOST or HTTP.GAME_HOST ) .. url )


	print("Request - ", ( isStats and HTTP.STATS_HOST or HTTP.GAME_HOST ) .. url)

	if r == nil then 
	--	return
	end

	r:SetHTTPRequestHeaderValue( "dedicated-key", HTTP.KEY )
	r:SetHTTPRequestRawPostBody( "application/json", json.encode( data ) )
	r:SetHTTPRequestAbsoluteTimeoutMS( 600 * 1000 )
	r:Send( function( res )
		local body = nil
		
		print( "Req", url, res.StatusCode, res.Body )

		if res.StatusCode == 200 then
			print( "Req Body", res.Body, url )
			body = json.decode( res.Body or "{}" )
			if cb then
				cb( body )
			end

		elseif tries and tries > 0 then
			Timers:CreateTimer( 3, function()
				HTTP.Request( url, data, cb, tries - 1 )
			end )
		end
	end )
end

function HTTP.MatchStart()
	print( "HTTP MatchStart" )
	local steamIDs = {}

	--steamIDs = {1,2,3,4,5}

	for id = 0, 24 do
		if PlayerResource:IsValidPlayerID( id ) then
			table.insert( steamIDs, tostring( PlayerResource:GetSteamAccountID( id ) ) )
		end
	end



	local cheats = GameRules:IsCheatMode() 

	if IsInToolsMode() then
		cheats = false
	end

	HTTP.MatchDetailsData() 
	HTTP.MatchLeaderboardData()


	HTTP.Request( "/match_start", {
		matchId = tostring(GameRules:Script_GetMatchID()),
		matchKey = HTTP.MATCH_KEY,
		cluster = HTTP.MATCH_CLUSTER,
		region = HTTP.MATCH_REGION,
		players = steamIDs,
		mapName = GetMapName(),
		isCheatsMode = cheats
	}, function( data )

		--Timers:CreateTimer(3, function()

			print( "REQEST START", data )

			xpcall( function() 

			if data then
				--DeepPrintTable(data)
				HTTP.serverData.voting = data.voting
				HTTP.serverData.averageRating = data.averageRating
				HTTP.serverData.seasonName = data.seasonName
				HTTP.serverData.isStatsMatch = data.isStatsMatch

				for _,player in pairs(data.players) do 

					local player_data = HTTP.GetPlayerData( HTTP.GetPlayerBySteamID(player.playerId) )

					--print( "QWERTY1234515" )
					--DeepPrintTable( player )

					player_data.lowPriorityRemaining = player.lpCount
					player_data.rating = player.rating
					player_data.isAdmin = player.isAdmin
				--	player_data.isSubscriber = player.isSubscriber

					player_data.tipsType = player.savedData and player.savedData.tipsType or player_data.tipsType
					player_data.isBanned = player.isBanned
					player_data.reports = player.reports
					player_data.UsedWrongMap = player.usedWrongMap and 1 or 0

					local savedSubData = player.savedData and player.savedData.subData or nil

					local items_ids = {}

					if player.items then 
						for k, v in pairs( player.items ) do
							table.insert( items_ids, tonumber( v ) )
						end
					end

					local all_heroes_data = {}
					local items = {}


					for _,hero_name in pairs(all_heroes) do
						items[hero_name] = {}

						if savedSubData.player_items_onequip[hero_name] then 
							for _,item in pairs(savedSubData.player_items_onequip[hero_name]) do 
								table.insert(items[hero_name], item)
							end 
						end 

						if player.dotaPlusHeroes[hero_name] then 


							local xp = player.dotaPlusHeroes[hero_name].xp
							local level = 1

							for k, v in pairs( _G.sub_level_thresh ) do
								if xp >= v then
									xp = xp - v
									level = level + 1
								else
									break
								end
							end

							all_heroes_data[hero_name] = {
								exp = xp,
								level = level,
								quests = player.dotaPlusHeroes[hero_name].quests
							}
						end
					end

					player_data.subData = { 
						hide_tier = savedSubData and savedSubData.hide_tier or player_data.subData.hide_tier,
						pet_id = savedSubData and savedSubData.pet_id or player_data.subData.pet_id,
						chat_wheel = savedSubData and savedSubData.chat_wheel or player_data.subData.chat_wheel,

						subscribed = player.hasDotaPlus and player.hasDotaPlus or 0,
						points = player.shardsAmount and player.shardsAmount or 0,
						votes_count = player.voteCount and player.voteCount or 0,
						double_rating_cd = player.doubleRatingCd and player.doubleRatingCd / 1000 or 0, 
						free_vote_cd = player.bonusVotesCd and player.bonusVotesCd / 1000 or 0,
						bonus_shards_cd = player.bonusShardsCd and player.bonusShardsCd / 1000 or 0,
						quests_cd = player.updateQuestsCd and player.updateQuestsCd / 1000 or 0,
						sub_time = player.dotaPlusExpire and player.dotaPlusExpire / 1000 or 0,
						items_ids = items_ids,
						heroes_data = all_heroes_data,
						player_items_onequip = items

					}

					print('qqqqq123', player_data.subData.free_vote_cd, player.bonusVotesCd, type(player.bonusVotesCd))
					print('qqqqq123', player_data.subData.bonus_shards_cd, player.bonusShardsCd, type(player.bonusShardsCd))

				end
	 			
			end
			HTTP.InitServerData()	
			----------------------------------------
			end, function( err ) 

				Timers:CreateTimer(1, function()

					CustomGameEventManager:Send_ServerToAllClients('print_debug',  {text = "Error: " .. err .. "\n" .. debug.traceback() .. "\n" })

					return 5
				end)

				
			 end )	
		--end)

	end, not IsInToolsMode() and 50 or nil )
end




function HTTP.MatchDetailsData()
	local steamIDs = {}

	for id = 0, 24 do
		if PlayerResource:IsValidPlayerID( id ) then
			table.insert( steamIDs, tostring( PlayerResource:GetSteamAccountID( id ) ) )
		end
	end

	HTTP.Request( "/match_details", steamIDs, function( data )


		if not data then
			print("no data details") 
			return
		end


		for _,player in pairs(data) do 
			local player_data = HTTP.GetPlayerData( HTTP.GetPlayerBySteamID(player.playerId) )
			
			if player_data then 
				player_data.matchCount = player.matchCount
				player_data.favoriteHero = player.favoriteHero
				player_data.places = player.places
				player_data.heroes = player.heroes
				player_data.matches = player.matches
			end

		end
		HTTP.InitServerData()	
	end, nil, true )
end






function HTTP.MatchLeaderboardData()
	local steamIDs = {}

	for id = 0, 24 do
		if PlayerResource:IsValidPlayerID( id ) then
			table.insert( steamIDs, tostring( PlayerResource:GetSteamAccountID( id ) ) )
		end
	end

	HTTP.Request( "/match_leaderboard", steamIDs, function( data )


	if not data then
		print("no leaderboard") 
		return
	end

	HTTP.serverData.leaderboard = data


		HTTP.InitServerData()	
	end, nil, true )
end




local function RatingChange( id, data )
	local ratingChange = data and data.ratingChange or 0

	local player = PlayerResource:GetPlayer( id )

	HTTP.playersData[id].ratingChange = ratingChange

	local place = Deaths_Players[id] and Deaths_Players[id].player and Deaths_Players[id].player.place or 0
	local items = Deaths_Players[id] and Deaths_Players[id].player and Deaths_Players[id].player.items or {}
	local damage_bonus = Deaths_Players[id] and Deaths_Players[id].player and Deaths_Players[id].player.damage_bonus or 0

	CustomNetTables:SetTableValue(
		"networth_players",
		tostring(id),
		{
			net = End_net[id],
			place = place,
			purple = 0,
			streak = false,
			rating_before =  math.max(0, lobby_rating[id] + lobby_rating_change[id]),
			rating_change = lobby_rating_change[id],
			items = items,
			damage_bonus = damage_bonus
		}
	)
end

function HTTP.PlayerEnd( id )
if lobby_rating_change[id] ~= nil and dont_end_game == false then return end


lobby_rating_change[id] = my_game:calc_rating(avg_rating, lobby_rating[id], HTTP.playersData[id].place, id)

HTTP.playersData[id].lost_game = true



local hero = GlobalHeroes[id]

if hero then 
	print(hero:GetUnitName())
else 
	print('nil ',PlayerResource:GetSteamAccountID( id ))
	return
end

local player_array = players[hero:GetTeamNumber()] 

local subData = CustomNetTables:GetTableValue("sub_data", tostring( id ))

if hero:GetQuest() and hero.quest.legendary ~= nil and HTTP.playersData[id].firstOrangeTalent  and HTTP.playersData[id].place < 2 and string.lower(hero.quest.icon) == string.lower(HTTP.playersData[id].firstOrangeTalent) then 
	for _,talent in pairs(skills[hero:GetUnitName()]) do 

		if talent[6] == HTTP.playersData[id].firstOrangeTalent and hero:HasModifier(talent[1]) then 
			hero:UpdateQuest(1)
		end
	end
end	

local subData_visual = {points = 0, subscribed = 0, level = 1, exp = 0}

if subData and subData.heroes_data[hero:GetUnitName()] then 
	subData_visual = 
	{
		points = subData.points, 
		subscribed = subData.subscribed, 
		expire = subData.sub_time, 
		level = subData.heroes_data[hero:GetUnitName()].level,
		exp = subData.heroes_data[hero:GetUnitName()].exp	
	}
end

local quest_table = {}

if (hero:GetQuest() ~= nil) and hero:QuestCompleted() and HTTP.playersData[id].place < 4 then 
	quest_table.name = hero.quest.name
	quest_table.icon = hero.quest.icon
	quest_table.exp = hero.quest.exp
	quest_table.shards = hero.quest.shards
	quest_table.completed = 1
end

local screen_table = 
{
	place = HTTP.playersData[id].place,
	kills = player_array.kills_done,
	towers = player_array.towers_destroyed,
	runes = player_array.bounty_runes_picked, 
	rating_before = lobby_rating[id],
	rating_change = lobby_rating_change[id],
	calibration_games = 0, 
	randomed = player_array.randomed,
	points = subData_visual.points,
	subscribed = subData_visual.subscribed,
	level = subData_visual.level,
	exp = subData_visual.exp,
	expire = subData_visual.expire,
	quest_table = quest_table,
	valid_time = GameRules:GetDOTATime(false, false) >= push_timer		
}


if HTTP.playersData[id].place > 2 or dont_end_game then 

	if not player_array.banned then 

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "EndScreenShow", screen_table)
	end
else 
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer( id ), "EndScreen_game_end", screen_table)
end

my_game:PostMatchPoints(hero)


local data = CustomNetTables:GetTableValue("server_data", tostring(id))
local lp_games = data.lp_games_remaining


if lp_games > 0 and HTTP.playersData[id].place < 4 and SafeToLeave == false then 
	lp_games = lp_games - 1
end

data.lp_games_remaining = lp_games

CustomNetTables:SetTableValue("server_data", tostring(id), data)

if not HTTP.serverData.isStatsMatch then
	RatingChange( id )

	return
end

if SafeToLeave == true then 
	return
end

local completedQuest = nil

if hero and hero:GetQuest() and hero:QuestCompleted() and HTTP.playersData[id].place < 4 then
	completedQuest = hero.quest.name
end


print('the last', id)



HTTP.Request( "/end", {
	matchId = tostring(GameRules:Script_GetMatchID()),
	matchKey = HTTP.MATCH_KEY,
    lpCount = lp_games,
    isWrongMap = HTTP.playersData[id].wrong_map_status > 0,
	playerId = tostring( PlayerResource:GetSteamAccountID( id ) ),
	playerName = PlayerResource:GetPlayerName( id ),
	partyId = tostring( PlayerResource:GetPartyID( id ) ),
	heroName = PlayerResource:GetSelectedHeroName( id ),
	mainTalent = HTTP.playersData[id].firstOrangeTalent,
	totalTalents = HTTP.playersData[id].talents,
	totalBuffs = HTTP.playersData[id].buffs,
	items = HTTP.playersData[id].items,
	kills = PlayerResource:GetKills( id ),
	deaths = PlayerResource:GetDeaths( id ),
	assists = PlayerResource:GetAssists( id ),
	heroDamage = HTTP.playersData[id].heroDamage,
	towerDamage = HTTP.playersData[id].towerDamage,
	networth = PlayerResource:GetNetWorth( id ),
	gpm = PlayerResource:GetGoldPerMin( id ),
	xpm = PlayerResource:GetXPPerMin( id ),
	level = PlayerResource:GetLevel( id ),
	base = HTTP.playersData[id].base,
	bans = {HTTP.playersData[id].bannedHero},
	pickOrder = HTTP.playersData[id].pickOrder,
	place = HTTP.playersData[id].place,
	killer = HTTP.playersData[id].killer,
	isLeaver = HTTP.playersData[id].isLeaver,
	endTime = GameRules:GetDOTATime(false, false),
	dpHeroMatchXp = HTTP.playersData[id].dpHeroMatchXp,
	dpHeroQuestXp = HTTP.playersData[id].dpHeroQuestXp,
	completedQuest = completedQuest,
	shardsReceipts = HTTP.playersData[id].matchShardsReceipts
}, function( data )
	print('qweqwr',id)
	RatingChange( id, data )
end, not IsInToolsMode() and 50 or nil )

end

function HTTP.PlayerLeave( id )
	if HTTP.leavedPlayers[id] or not PlayerResource:IsValidPlayerID( id ) then
		return
	end

	HTTP.leavedPlayers[id] = true

    local data = CustomNetTables:GetTableValue("server_data", tostring(id) )
    local wrong_map_status = data.wrong_map_status
	local subData = CustomNetTables:GetTableValue("sub_data", tostring( id ))
	local playerData = HTTP.GetPlayerData( id )

	HTTP.Request( "/leave", {
		playerId = tostring( PlayerResource:GetSteamAccountID(id) ),
	    isWrongMap = wrong_map_status == 2, 
		isSafeToLeave = data.switch_safetoleave,
	    leaveTime = GameRules:GetDOTATime(false, false),
	    playerName = PlayerResource:GetPlayerName( id ),
	    lpCount = data.lp_games_remaining,   
		savedData = {
			tipsType = 2,
			subData = subData
		},
		--updateBonusShardsCd = playerData and playerData.shardsBonusCd and playerData.shardsBonusCd * 1000 or nil or nil,
		--updateFreeVoteCd = playerData and playerData.voteBonusCd and playerData.voteBonusCd * 1000 or nil or nil,
		--updateDoubleRatingCd = playerData and playerData.doubleRatingCd and playerData.doubleRatingCd * 1000 or nil or nil,
	} )
end

function HTTP.Report( reporter, reported1, reported2, t )
	print( "HTTP.PlayerEnd", id )

	HTTP.Request( "/report", {
		matchId = tostring(GameRules:Script_GetMatchID()),
		matchKey = HTTP.MATCH_KEY,
		reporter = tostring( PlayerResource:GetSteamAccountID( reporter ) ),
		reported1 = tostring( PlayerResource:GetSteamAccountID( reported1 ) ),
		reported2 = tostring( PlayerResource:GetSteamAccountID( reported2 ) ),
		type = t
	}, nil, 50 )
end

function HTTP.BuyItem( playerId, productId, amount, count )

	print('!!!!', amount, count)

	HTTP.Request( "/shards_expense", {
		playerId = HTTP.GetAccountPlayerId( playerId ),
		productId = productId,
		isItem = true,
		amount = amount,
		count = count or 1
	} )
end

function HTTP.Vote( playerId, heroName, count )
	HTTP.Request( "/vote", {
		playerId = HTTP.GetAccountPlayerId( playerId ),
		heroName = heroName,
		count = count
	} )
end

function HTTP.BonusShards( playerId, amount, cd )
	HTTP.Request( "/bonus_shards", {
		playerId = HTTP.GetAccountPlayerId( playerId ),
		amount = amount,
		cd = cd
	} )
end

function HTTP.BonusVotes( playerId, count, cd )
	HTTP.Request( "/bonus_votes", {
		playerId = HTTP.GetAccountPlayerId( playerId ),
		count = count,
		cd = cd
	} )
end

function HTTP.UpdateQuests( playerId, heroes, cd )
	local quests = {}

	for heroName, questsList in pairs( heroes ) do
		local hero = {
			heroName = heroName,
			quests = questsList.quests
		}

		table.insert( quests, hero )
	end



	HTTP.Request( "/update_quests", {
		playerId = HTTP.GetAccountPlayerId( playerId ),
		heroes = quests,
		cd = cd,
	} )
end

function HTTP.DoubleRating( playerId, cd )
	HTTP.Request( "/double_rating", {
		playerId = HTTP.GetAccountPlayerId( playerId ),
		cd = cd
	} )
end



--[[
function HTTP.ShopRequestBuy(playerId, point_change, item_id)
HTTP.Request( "/shards_expense", 
{
	playerId =  playerId,
	productId = item_id,
	count = 1,
	amount = math.abs( point_change ),
	isItem = true,

}, function( data )

	end)

end


function HTTP.ShopRequestBuyVote(playerId, point_change, count)
	print(point_change, count)
	
	HTTP.Request( "/shards_expense", {
		playerId =  playerId,
		productId = 'vote',
		amount = math.abs( point_change ),
		count = count,
		isItem = false,
	} )

end


function HTTP.ShopRequestAdd(playerId, point_change, reason)
	print(point_change, reason)
	
	HTTP.Request( "/shards_receipt", {
		playerId =  playerId,
		details = { reason = reason },
		amount = math.abs( point_change )
	} )
end


function HTTP.ShopRequestVote(playerId, amount, hero_name)
print(amount, hero_name)

HTTP.Request( "/vote", 
{
	playerId =  playerId,
	heroName = hero_name,
	count = amount,
}, function( data )

	end)

end

]]


function HTTP.Login(playerId, item_name) 


	local url = 'https://dota1x6.com/?popup=payment_method&productId='..item_name

	if item_name == "sub" then 
		url = 'https://dota1x6.com/?productId=shards_20&popup=dota_plus'
	end


	HTTP.Request( "/login", {
		playerId =  HTTP.GetAccountPlayerId( playerId ),
		redirectUrl = url,

	}, function( data )
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer( playerId ), "get_payment_url", {url = data.url}) 
	end )
end



function HTTP.PaymentDotaPlus(playerId, type) -- HTTP.PlayerSubscribe(playerId, type_sub)
	HTTP.Request( "/payment", {
		playerId =  HTTP.GetAccountPlayerId( playerId ),
		productId = "dota_plus_" .. type,
	}, function( data )
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer( playerId ), "get_payment_url", {url = data.url}) 
	end )
end




function HTTP.FillItemsData(id, place)


local data = {}
local hero = GlobalHeroes[id]

if not hero then return end 


local items = {}

for i = 0, 5 do
	local item = hero:GetItemInSlot( i )
	
	if item and not NonRecordItems[item:GetAbilityName()] then
		table.insert(items, item:GetAbilityName())
	end
end

if hero:HasShard() then 
	table.insert(items, "item_aghanims_shard")
end 

if hero:HasScepter() then 
	table.insert(items, "item_ultimate_scepter")
end 

data.player_id = PlayerResource:GetSteamAccountID( id )
data.match_id = tostring(GameRules:Script_GetMatchID())
data.place = place
data.hero_name = hero:GetUnitName()
data.main_talent = HTTP.playersData[id].firstOrangeTalent or '0'
data.networth = PlayerResource:GetNetWorth( id )
data.time = math.floor(GameRules:GetDOTATime(false, false)/60)
data.items = items
data.map_name = GetMapName() 

table.insert(HTTP.ItemsData, data)

if place and place ~= -1 then 

	for _,data in pairs(HTTP.ItemsData) do
		if data.place and data.hero_name and data.hero_name == hero:GetUnitName() then 
			data.place =  place
		end 
	end 
end 

end
