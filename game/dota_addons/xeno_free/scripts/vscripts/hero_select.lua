require("events_protector")

hero_select = class({})

PICK_STATE_PLAYERS_LOADED = "PICK_STATE_PLAYERS_LOADED"
PICK_STATE_PICK_BANNED = "PICK_STATE_PICK_BANNED"
PICK_STATE_SELECT_HERO = "PICK_STATE_SELECT_HERO"
PICK_STATE_SELECT_BASE = "PICK_STATE_SELECT_BASE"
PICK_STATE_PICK_END = "PICK_STATE_PICK_END"
PICK_STATE = PICK_STATE_PLAYERS_LOADED
BAN_TIME = 15
TIME_OF_STATE = {5, 75, 60, 0}
LOBBY_PLAYERS = {}
LOBBY_PLAYERS_MAX = 0
HEROES_FOR_PICK = {}
BASE_FOR_PICK = {2, 7, 6, 3, 8, 9}
PICKED_HEROES = {}
PICKED_BASES = {}
PICK_ORDER = 0
_G.IN_STATE = false
BAN_HEROES_VOTE = {}
_G.BANNED_HEROES = {}

NO_BANNED_HEROES = { }

DONATE_HEROES = 
{
}

_G.BASE_POSITION = {
    Vector(-5621.416016, -5693.873047, 343),
    Vector(1569.812500, -6398.656250, 343),
    Vector(-6276.908203, 1465.867554, 343),
    Vector(5030.81, 5390.27, 343),
    Vector(-1303.977173, 6414.658691, 343),
    Vector(6515.981445, -1486.434570, 343)
}

_G.COUR_POSITION = {
    Vector(-4745.94, -5358.05, 343),
    Vector(618.509, -6416.23, 343),
    Vector(-6310.89, 539.332, 343),
    Vector(5030.584961, 5390.719727, 343),
    Vector(-320.739, 6446.09, 343),
    Vector(6556.74, -467.617, 343)
}


function hero_select:IsHeroDonate(hero, id)

local subData = CustomNetTables:GetTableValue("sub_data", tostring( id ))


for _, donate in pairs(DONATE_HEROES) do
    if hero == donate and subData.subscribed == 0 then
        return true
    end
end
return false
end




function hero_select:RandomHero(id)
    local hero
    repeat
        local random = RandomInt(1, #HEROES_FOR_PICK)
        hero = HEROES_FOR_PICK[random]
    until not my_game:check_used(PICKED_HEROES, hero) and not hero_select:IsHeroDonate(hero, id)

    return hero
end

function hero_select:RandomBase()
    local base
    repeat
        base = RandomInt(1, #BASE_FOR_PICK)
    until not my_game:check_used(PICKED_BASES, base)

    return base
end

function hero_select:PickBase(id, number)
if SelectedBases[id] ~= nil then return end

    local player_info = LOBBY_PLAYERS[id]

    player_info.select_base = number

    HTTP.playersData[id].base = number

    table.insert(PICKED_BASES, number)

    CustomNetTables:SetTableValue(
        "custom_pick",
        "base_list",
        {
            picked_bases = PICKED_BASES,
            picked_bases_length = #PICKED_BASES
        }
    )

    CustomGameEventManager:Send_ServerToAllClients(
        "pick_select_base",
        {number = number, hero = player_info.picked_hero}
    )

    SelectedBases[id] = number


    if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 and SelectedHeroes[id] and SelectedHeroes[id].hero
        and PlayerResource:GetSelectedHeroName(id) == "" and PlayerResource:GetPlayer(id) then 


        PlayerResource:GetPlayer(id):SetSelectedHero(SelectedHeroes[id].hero)
    else 
        if PlayerResource:GetSelectedHeroName(id) ~= "" and GlobalHeroes[id] and towers[GlobalHeroes[id]:GetTeamNumber()] == nil then 
            my_game:PlaceHero(id)   
        end
    end



    hero_select:check_picked_bases()
end

function hero_select:ChoseBase(params)
    if params.PlayerID == nil then
        return
    end
    if not params.number then
        return
    end
    if PICK_STATE ~= PICK_STATE_SELECT_BASE then
        return
    end

    local player_info = LOBBY_PLAYERS[params.PlayerID]

    if player_info.select_base ~= nil or hero_select:check_picked_base_number(params.number) then
        return
    end

    hero_select:PickBase(params.PlayerID, params.number)
end




function hero_select:PickHero(id, name, random)
    local player_info = LOBBY_PLAYERS[id]

    player_info.picked_hero = name

    table.insert(PICKED_HEROES, name)

    CustomNetTables:SetTableValue(
        "custom_pick",
        "player_list",
        {
            picked_heroes = PICKED_HEROES,
            picked_heroes_length = #PICKED_HEROES
        }
    )

    CustomGameEventManager:Send_ServerToAllClients("pick_select_hero", {hero = name, id = id, random = random})

    SelectedHeroes[id] = {}
    SelectedHeroes[id].hero = name
    SelectedHeroes[id].random = random

    CustomNetTables:SetTableValue("players_heroes", tostring(id), {hero = name})


    hero_select:check_picked_players()
end





function hero_select:ChoseHero(params)
    if params.PlayerID == nil then
        return
    end
    if not params.hero then
        return
    end
    if PICK_STATE ~= PICK_STATE_SELECT_HERO then
        return
    end

    local player_info = LOBBY_PLAYERS[params.PlayerID]

    if params.random then
        local random_hero = hero_select:RandomHero(params.PlayerID)

        LOBBY_PLAYERS[params.PlayerID].randomed = true

        if player_info.picked_hero ~= nil or hero_select:check_picked(random_hero) then
            return
        end
        hero_select:PickHero(params.PlayerID, random_hero, 1)
        return
    end

    if player_info.picked_hero ~= nil or hero_select:check_picked(params.hero) then
        return
    end

    LOBBY_PLAYERS[params.PlayerID].randomed = false
    hero_select:PickHero(params.PlayerID, params.hero, 0)
end

function hero_select:EndPickHeroes()
    CustomNetTables:SetTableValue(
        "custom_pick",
        "player_lobby",
        {
            lobby_players = LOBBY_PLAYERS,
            lobby_players_length = LOBBY_PLAYERS_MAX
        }
    )
    PICK_ORDER = 0

    CustomGameEventManager:Send_ServerToAllClients("start_base_pick", {})
    PICK_STATE = PICK_STATE_SELECT_BASE


    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
                 hero_select:StartOrderPickBase()
            end
        })
end




function hero_select:OnDisconnect(params)
if GAME_STARTED == false then return end
if not params.PlayerID then return end
local id = params.PlayerID 

if PlayerResource:GetSelectedHeroName(id) ~= "" then return end
if GlobalHeroes[id] then return end

if LOBBY_PLAYERS[id].picked_hero == nil or SelectedHeroes[id] == nil or SelectedHeroes[id].hero == nil then
     hero_select:PickHero(id, hero_select:RandomHero(id), 1)
end 

if SelectedHeroes[id] and SelectedHeroes[id].hero then 
    PlayerResource:GetPlayer(params.PlayerID):SetSelectedHero(SelectedHeroes[id].hero)

end


end




function hero_select:EndPick(source)
if PICK_STATE == PICK_STATE_PICK_END then return end


    for id = 0,24 do 
        if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 and SelectedHeroes[id] and SelectedHeroes[id].hero 
            and  SelectedBases[id] == nil then 
            hero_select:PickBase(id, hero_select:RandomBase())
        end
    end


    PICK_STATE = PICK_STATE_PICK_END


    CustomGameEventManager:Send_ServerToAllClients("pick_base_end", {})

    --CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "pick_base_end", {})

    Timers:CreateTimer(0.4, function()
        _G.IN_STATE = false
        my_game:EndPickStage()
    end)


    CustomNetTables:SetTableValue( "custom_pick", "pick_state",  { in_progress = false } )



end




function hero_select:check_banned_players()
    for _, i in pairs(LOBBY_PLAYERS) do
        if i.ban_hero == nil then
            return false
        end
    end

    CustomGameEventManager:Send_ServerToAllClients("EndBanStage", {no_ban_hero = NO_BANNED_HEROES})
    CustomNetTables:SetTableValue("custom_pick", "ban_stage_check", {state = false})
    hero_select:BanHero()
    hero_select:StartSelectionStage()
end
function hero_select:check_picked_players()
    for _, i in pairs(LOBBY_PLAYERS) do
        if i.picked_hero == nil then
            return false
        end
    end

if dont_end_pick_hero == false then 
   hero_select:EndPickHeroes()
end

end

function hero_select:check_picked_bases()
    for _, i in pairs(LOBBY_PLAYERS) do
        if i.select_base == nil then
            return false
        end
    end
   hero_select:EndPick()
end

function hero_select:check_picked(hero)
    for _, i in pairs(BANNED_HEROES) do
        if i == hero then
            return true
        end
    end

    for _, i in pairs(PICKED_HEROES) do
        if i == hero then
            return true
        end
    end

    return false
end

function hero_select:check_picked_base_number(number)
    for _, i in pairs(PICKED_BASES) do
        if i == number then
            return true
        end
    end
    return false
end

function hero_select:RegisterPlayerInfo(pid)
    if PlayerResource:GetSteamAccountID(pid) == 0 then
        return
    end

    local pinfo = LOBBY_PLAYERS[pid]
    if pinfo == nil then
        pinfo = {
            bRegistred = false,
            bLoaded = false,
            steamid = PlayerResource:GetSteamAccountID(pid),
            picked_hero = nil,
            select_base = nil,
            pick_order = nil,
            ban_hero = nil
        }
        LOBBY_PLAYERS_MAX = LOBBY_PLAYERS_MAX + 1
    end

    LOBBY_PLAYERS[pid] = pinfo

    return pinfo
end

function hero_select:CheckReadyPlayers(attempt)
    if PICK_STATE ~= PICK_STATE_PLAYERS_LOADED then
        return
    end

    local bAllReady = true
    for pid, pinfo in pairs(LOBBY_PLAYERS) do
        if pinfo.bRegistred and not pinfo.bLoaded then
            bAllReady = false
        end
    end

    if bAllReady then
        hero_select:Start()
    else
        local check_interval = 0.5
        attempt = (attempt or 0) + check_interval
        if attempt > TIME_OF_STATE[1] then
            hero_select:Start()
        else
            Timers:CreateTimer(
                "",
                {
                    useGameTime = false,
                    endTime = check_interval,
                    callback = function()
                        hero_select:CheckReadyPlayers(attempt)
                    end
                }
            )
        end
    end
end

function hero_select:PlayerConnected(kv)
	if kv.PlayerID == nil then
		return
	end
    local pinfo = hero_select:RegisterPlayerInfo(kv.PlayerID)
    pinfo.bRegistred = true
end

function hero_select:PlayerLoaded(player, pid)


    if not LOBBY_PLAYERS[pid] then
            print('1')
        CustomGameEventManager:Send_ServerToPlayer(player, "pick_end", {})
        return
    end

    LOBBY_PLAYERS[pid].bLoaded = true

    local team = PlayerResource:GetTeam(pid)
    local hero = GlobalHeroes[pid]
    if hero ~= nil then
        hero:SetOwner(player)
        hero:SetControllableByPlayer(pid, true)
        player:SetAssignedHeroEntity(hero)
    end

    if not IN_STATE then
            print('2')
        CustomGameEventManager:Send_ServerToPlayer(player, "pick_end", {})

        Timers:CreateTimer(5, function()

            for _,player in pairs(players) do 
                print('reconnect!',player:GetUnitName())
                shop:UpdateFullParticleForPlayer(player:GetPlayerOwnerID(), player, pid)
            end 
        end)

        Timers:CreateTimer(
            1.5,
            function()
                local player = PlayerResource:GetPlayer(pid)
                if player == nil then
                    return
                end
                CustomGameEventManager:Send_ServerToPlayer(
                    player,
                    "init_chat",
                    {tools = IsInToolsMode(), cheat = GameRules:IsCheatMode(), valid = HTTP.IsValidGame(PlayerCount)}
                )

                if hero == nil then
                    return
                end
                if players[hero:GetTeamNumber()] == nil then
                    return
                end

                for _, mod in pairs(hero:FindAllModifiers()) do
                    if mod.ActiveTalent and mod.ActiveTalent == true then
                       -- hero:AddNewModifier(hero, nil, mod:GetName(), {})
                    end
                end

                hero:UpdateQuest(0)

                if hero.tempest_double_tempest then 
                    hero.tempest_double_tempest:SetOwner(hero)
                end 


                CustomGameEventManager:Send_ServerToPlayer(player, "set_test_mode",  {state = _G.TestMode})
                CustomGameEventManager:Send_ServerToAllClients( 'lua_wtf_mode', {wtf = _G.WtfMode} )
                CustomGameEventManager:Send_ServerToAllClients( 'lua_timer_stop', {stop = _G.TimerStop})

                CustomGameEventManager:Send_ServerToPlayer(player, 'init_hero_level', {    } ) 
                CustomGameEventManager:Send_ServerToPlayer(player, 'end_loading', {} )
            --    CustomGameEventManager:Send_ServerToPlayer(player, 'PreGameEnd', {} )
                CustomGameEventManager:Send_ServerToPlayer(player, 'PreGameEnd_top', {} )

                CustomGameEventManager:Send_ServerToPlayer(player, 'init_damage_table', { } ) 

                CustomGameEventManager:Send_ServerToPlayer(
                    player,
                    "kill_progress",
                    {
                        blue = math.floor(players[hero:GetTeamNumber()].bluepoints),
                        purple = players[hero:GetTeamNumber()].purplepoints,
                        max = players[hero:GetTeamNumber()].bluemax,
                        max_p = math.floor(players[hero:GetTeamNumber()].purplemax)
                    }
                )

                if GameRules:GetDOTATime(false, false) >= Grenade_Timer or Grenade_start == true then 
                    CustomGameEventManager:Send_ServerToAllClients('show_grenades',  {})
                end  


                if players[hero:GetTeamNumber()]:HasModifier("modifier_end_choise") then
                    CustomGameEventManager:Send_ServerToPlayer(
                        player,
                        "show_choise",
                        {
                            choise = players[hero:GetTeamNumber()].choise_table[1],
                            mods = players[hero:GetTeamNumber()].choise_table[4],
                            hasup = players[hero:GetTeamNumber()].choise_table[3],
                            alert = players[hero:GetTeamNumber()].choise_table[2],
                            refresh = players[hero:GetTeamNumber()].choise_table[5]
                        }
                    )
                end
            end
        )

        return
    end

    if PICK_STATE ~= PICK_STATE_PLAYERS_LOADED then
        hero_select:DrawPickScreenForPlayer(pid)

        if PICK_STATE == PICK_STATE_PICK_BANNED then
            CustomGameEventManager:Send_ServerToPlayer(
                player,
                "reload_pick_heroes",
                {
                    lobby_players = LOBBY_PLAYERS
                }
            )

            for _, banned_hero in pairs(BAN_HEROES_VOTE) do
                CustomGameEventManager:Send_ServerToPlayer(
                    player,
                    "ban_hero_vote",
                    {hero = banned_hero.name, votes = banned_hero.votes}
                )
            end
        elseif PICK_STATE == PICK_STATE_SELECT_HERO then
            CustomGameEventManager:Send_ServerToPlayer(
                player,
                "reload_pick_heroes",
                {
                    lobby_players = LOBBY_PLAYERS
                }
            )
            for _, banned_hero in pairs(BAN_HEROES_VOTE) do
                CustomGameEventManager:Send_ServerToPlayer(
                    player,
                    "ban_hero_vote",
                    {hero = banned_hero.name, votes = banned_hero.votes}
                )
            end
            for _, banned_hero in pairs(BANNED_HEROES) do
                CustomGameEventManager:Send_ServerToPlayer(player, "ban_hero", {hero = banned_hero})
            end
        elseif PICK_STATE == PICK_STATE_SELECT_BASE then
            for current, pinfo in pairs(LOBBY_PLAYERS) do
                if pinfo.pick_order == PICK_ORDER then
                    CustomGameEventManager:Send_ServerToPlayer(
                        PlayerResource:GetPlayer(pid),
                        "pick_start_time_base",
                        {
                            order = PICK_ORDER,
                            max = LOBBY_PLAYERS_MAX,
                            id = current,
                            time = -1,
                            picked_bases = PICKED_BASES,
                            picked_bases_length = #PICKED_BASES
                        }
                    )
                    break
                end
            end

            CustomGameEventManager:Send_ServerToPlayer(
                player,
                "reload_pick_bases",
                {
                    lobby_players = LOBBY_PLAYERS
                }
            )
        elseif PICK_STATE == PICK_STATE_PICK_END then
            print('3')
            CustomGameEventManager:Send_ServerToPlayer(player, "pick_end", {})
        end
    end
end

function hero_select:Start()
    local r = 0
    local used_numbers = {}



    for i, player in pairs(LOBBY_PLAYERS) do
        repeat
            r = RandomInt(0, LOBBY_PLAYERS_MAX - 1)
        until not my_game:check_used(used_numbers, r)
        used_numbers[#used_numbers + 1] = r
        player.pick_order = r
    end

    local place_admin = 0
    local place_normal = 1

    local first_pick_id = 
    {
        ['232290025'] = true,
        ['111393624'] = true, -- серега
        --['154672909'] = true, -- боря
        ['176855887'] = true, -- дисантро
         --['122413750'] = true, -- 
     --   ['883703644'] = true,
    } --362469930--

    if LOBBY_PLAYERS_MAX > 1 then
        for i, player in pairs(LOBBY_PLAYERS) do
            if LOBBY_PLAYERS[i].pick_order == 0 then
                place_normal = i
            end
        end

        for i, player in pairs(LOBBY_PLAYERS) do
            if first_pick_id[tostring(LOBBY_PLAYERS[i].steamid)] == true then
                place_admin = LOBBY_PLAYERS[i].pick_order

                LOBBY_PLAYERS[i].pick_order = 0
                LOBBY_PLAYERS[place_normal].pick_order = place_admin
                break
            end
        end
    end

    for id, player in pairs(LOBBY_PLAYERS) do
        print("QWESAEDAS", HTTP.playersData[id], id, player.pickOrder)
        HTTP.playersData[id].pickOrder = player.pick_order
    end

    CustomNetTables:SetTableValue(
        "custom_pick",
        "player_lobby",
        {
            lobby_players = LOBBY_PLAYERS,
            lobby_players_length = LOBBY_PLAYERS_MAX
        }
    )

    for pid, pinfo in pairs(LOBBY_PLAYERS) do
        if pinfo.bLoaded then
            hero_select:DrawPickScreenForPlayer(pid)
        end
    end

    --hero_select:StartSelectionStage()
    hero_select:StartBanStage()
end

function hero_select:StartBanStage()
    PICK_STATE = PICK_STATE_PICK_BANNED
    local time_ban_stage = BAN_TIME
    CustomGameEventManager:Send_ServerToAllClients(
        "StartBanStage",
        {time = time_ban_stage, no_ban_hero = NO_BANNED_HEROES}
    )
    CustomNetTables:SetTableValue("custom_pick", "ban_stage_check", {state = true})
    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
                time_ban_stage = time_ban_stage - 1
                CustomGameEventManager:Send_ServerToAllClients(
                    "TimeBanStage",
                    {time = time_ban_stage, no_ban_hero = NO_BANNED_HEROES}
                )
                if time_ban_stage <= 0 then
                    CustomGameEventManager:Send_ServerToAllClients("EndBanStage", {no_ban_hero = NO_BANNED_HEROES})
                    CustomNetTables:SetTableValue("custom_pick", "ban_stage_check", {state = false})
                    hero_select:BanHero()
                    hero_select:StartSelectionStage()
                    return
                end
                return 1
            end
        }
    )
end

function hero_select:BanHero()
    for ban_count = 1, 3 do
        if #BAN_HEROES_VOTE > 0 then
    	    local random_hero = RandomInt(1, #BAN_HEROES_VOTE)

    	    if BAN_HEROES_VOTE[random_hero] then
    	        table.insert(BANNED_HEROES, BAN_HEROES_VOTE[random_hero].name)

    	        for id, hero in pairs(HEROES_FOR_PICK) do
    	            if hero == BAN_HEROES_VOTE[random_hero].name then
    	                table.remove(HEROES_FOR_PICK, id)
    	                break
    	            end
    	        end

    	        CustomGameEventManager:Send_ServerToAllClients(
    	            "ban_hero",
    	            {hero = BAN_HEROES_VOTE[random_hero].name, table_votes = BAN_HEROES_VOTE}
    	        )

                table.remove(BAN_HEROES_VOTE, random_hero)
    	    end
    	end
    end
end

function hero_select:BanVoteHero(params)
    if params.PlayerID == nil then
        return
    end
    
    if LOBBY_PLAYERS[params.PlayerID].ban_hero == nil then
        for _, no_ban_hero in pairs(NO_BANNED_HEROES) do
            if no_ban_hero == params.hero then
                return
            end
        end

        for _, banned_hero in pairs(BAN_HEROES_VOTE) do
            if banned_hero.name == params.hero then
               
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(params.PlayerID), "CreateIngameErrorMessage", {message = "#wrong_ban"})
                return
            end
        end

        HTTP.playersData[params.PlayerID].bannedHero = params.hero
        LOBBY_PLAYERS[params.PlayerID].ban_hero = params.hero

        local new_table = {name = params.hero, votes = 1}
        table.insert(BAN_HEROES_VOTE, new_table)
        CustomGameEventManager:Send_ServerToAllClients("ban_hero_vote", {hero = params.hero, votes = 1})

        hero_select:check_banned_players()
    end
end

function hero_select:StartSelectionStage()
    PICK_STATE = PICK_STATE_SELECT_HERO

    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
                hero_select:StartOrderPick()
            end
        }
    )
end

function hero_select:StartOrderPick()
    local time = Time_to_pick_Hero

    local id = 0

    for pid, pinfo in pairs(LOBBY_PLAYERS) do
        if pinfo.pick_order == PICK_ORDER then
            CustomGameEventManager:Send_ServerToAllClients("pick_start_time", {id = pid, time = time})
            CustomNetTables:SetTableValue(
                "custom_pick",
                "active_player",
                {
                    id = pid
                }
            )

            id = pid
            break
        end
    end

    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
               if LOBBY_PLAYERS_MAX ~= 1 then
                    time = time - 1
               end

                if time == 20  then 
                  --  hero_select:OnDisconnect({PlayerID = id})
                end

                CustomGameEventManager:Send_ServerToAllClients("change_time", {time = time, id = id})

                local server_player = HTTP.GetPlayerData(id)
                print( "PWPEAS", server_player, id )
                if server_player ~= nil then
                    if server_player.lowPriorityRemaining > 0 then
                        hero_select:PickHero(id, hero_select:RandomHero(id), 1)
                    end
                end

                if time <= 0 or (LOBBY_PLAYERS[id].picked_hero ~= nil) then

                    if LOBBY_PLAYERS[id].picked_hero == nil then
                        hero_select:PickHero(id, hero_select:RandomHero(id), 1)
                    end

                    if PICK_STATE ~= PICK_STATE_SELECT_HERO then
                        return
                    end

                    PICK_ORDER = PICK_ORDER + 1

                    if PICK_ORDER < LOBBY_PLAYERS_MAX + 1 then
                        hero_select:StartOrderPick()
                    end

                    return
                end
                return 1
            end
        }
    )
end

function hero_select:StartOrderPickBase()
if PICK_STATE == PICK_STATE_PICK_END then return end

    local time = Time_to_pick_Base
    local id = 0


    for pid, pinfo in pairs(LOBBY_PLAYERS) do
        if pinfo.pick_order == PICK_ORDER then

             CustomNetTables:SetTableValue(
                "custom_pick",
                "active_player",
                {
                    id = pid
                }
            )

            
            CustomGameEventManager:Send_ServerToAllClients(
                "pick_start_time_base",
                {
                    order = PICK_ORDER,
                    max = LOBBY_PLAYERS_MAX,
                    id = pid,
                    time = time,
                    picked_bases = PICKED_BASES,
                    picked_bases_length = #PICKED_BASES
                }
            )
           
            id = pid

            break
        end
    end


    Timers:CreateTimer(
        "",
        {
            useGameTime = false,
            endTime = 1,
            callback = function()
                if LOBBY_PLAYERS_MAX ~= 1 then
                    time = time - 1
                end

                if PICK_ORDER + 1 == LOBBY_PLAYERS_MAX and LOBBY_PLAYERS[id].select_base == nil then 

                  --  PICK_ORDER = PICK_ORDER + 1
                  --  hero_select:PickBase(id, hero_select:RandomBase())
                --    return
                end

                CustomGameEventManager:Send_ServerToAllClients("change_time_base", {time = time, id = id})

                if time <= 0 or (LOBBY_PLAYERS[id].select_base ~= nil) then
                    PICK_ORDER = PICK_ORDER + 1


                    if LOBBY_PLAYERS[id].select_base == nil or PICK_ORDER >= LOBBY_PLAYERS_MAX + 1 then


                        hero_select:PickBase(id, hero_select:RandomBase())


                        if PICK_ORDER == LOBBY_PLAYERS_MAX then

                            return
                        end
                    end

                    if PICK_ORDER < LOBBY_PLAYERS_MAX + 1 then

                        hero_select:StartOrderPickBase()
                    end

                    return
                end

                return 1
            end
        }
    )
end

function hero_select:DrawPickScreenForPlayer(pid)
    if not PlayerResource:IsValidPlayerID(pid) then
        return
    end
--    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid), "pick_start", {})
end

function hero_select:init()
    _G.IN_STATE = true

    print('PICK START INIT')

    RegisterLoadListener(
        function(player, playerID)
            hero_select:PlayerLoaded(player, playerID)
        end
    )

    CustomGameEventManager:RegisterListener("chose_hero", Dynamic_Wrap(self, "ChoseHero"))
    CustomGameEventManager:RegisterListener("chose_base", Dynamic_Wrap(self, "ChoseBase"))
    CustomGameEventManager:RegisterListener("BanVoteHero", Dynamic_Wrap(self, "BanVoteHero"))

    for i = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
        if PlayerResource:IsValidTeamPlayerID(i) then
            self:RegisterPlayerInfo(i)
        end
    end

    self:CheckReadyPlayers()
end


hero_changes = 
{
    ["npc_dota_hero_juggernaut"] = {"Healing_Ward","Healing_Ward","Omnislash","Omnislash"},
    ["npc_dota_hero_phantom_assassin"] = {"Stifling_Dagger","Blur","Coup_de_Grace","Coup_de_Grace","Scepter"},
    ["npc_dota_hero_huskar"] = {"movespeed","Inner_Fire","Berserkers_Blood","Life_Break","Life_Break","Shard"},
    ["npc_dota_hero_nevermore"] = {"Shadowraze","Shadowraze","Necromastery","Requiem","Shard"},
    ["npc_dota_hero_legion_commander"] = {"Odds","Odds","Duel","Duel","Duel","Duel","Scepter"},
    ["npc_dota_hero_queenofpain"] = {"Dagger","Sonic","Scepter"},
    ["npc_dota_hero_terrorblade"] = {"Reflection","Illusion","Illusion","Meta","Sunder","Scepter","Shard"},
    ["npc_dota_hero_bristleback"] = {"Goo","Goo","Goo","Warpath","Scepter"},
    ["npc_dota_hero_puck"] = {"Orb","Shift","Shift","Coil","Scepter"},
    ["npc_dota_hero_void_spirit"] = {"movespeed","Remnant","Remnant","Pulse","Pulse","Step","Scepter","Shard"},
    ["npc_dota_hero_ember_spirit"] = {"Guard","FireRemnant","FireRemnant","FireRemnant","Shard"},
    ["npc_dota_hero_pudge"] = {"movespeed","Flesh","Dismember","Shard","Scepter"},
    ["npc_dota_hero_hoodwink"] = {"Vitality_Booster","Bush","Sharp","Sharp"},
    ["npc_dota_hero_skeleton_king"] = {"blast","Vampiric","Vampiric","reincarnation","Scepter","Shard"},
    ["npc_dota_hero_lina"] = {"Array","Scepter"},
    ["npc_dota_hero_troll_warlord"] = {"rage","axes","fervor","trance","trance","shard"},
    ["npc_dota_hero_axe"] = {"call","hunger","helix","culling","culling","culling","Shard"},
    ["npc_dota_hero_alchemist"] = {"Acid","Unstable","Corrosive","Greed","Scepter","Shard"},
    ["npc_dota_hero_ogre_magi"] = { "Fireblast", "Ignite","Bloodlust","Shard", "Scepter", "Scepter"},
    ["npc_dota_hero_antimage"] = {"Shard","Manabreak", "antimage_blink", "counterspell","manavoid","manavoid", "Scepter"},
    ["npc_dota_hero_primal_beast"] = {"Scepter","Onslaught", "Uproar"},
    ["npc_dota_hero_marci"] = {"dispose","rebound","sidekick","sidekick","unleash","unleash","shard","Scepter"},
    ["npc_dota_hero_templar_assassin"] = {"Refraction","Meld","Psiblades","Psiblades","Psionic","Psionic","Scepter","Shard"},
    ["npc_dota_hero_bloodseeker"] = {"Thirst","Thirst","Rupture","Scepter","Shard"},
    ["npc_dota_hero_monkey_king"] = {"Mastery","Mastery","Command","Command","Scepter"},
    ["npc_dota_hero_mars"] = {"Spear","Bulwark","Arena","Shard","Shard"},
    ["npc_dota_hero_zuus"] = {"Armor","Bolt","Wrath","Wrath","Wrath","Scepter"},
    ["npc_dota_hero_leshrac"] = {"Nova","Scepter","Shard","Shard"},
    ["npc_dota_hero_crystal_maiden"] = {"movespeed","Crystal","Frostbite","Frostbite","Arcane","Arcane","Freezing","Freezing","Shard"},
    ["npc_dota_hero_snapfire"] = {"Cookie", "Cookie", "Shredder", "Shredder", "Kisses", "Kisses", "Scepter"},
    ["npc_dota_hero_sven"] = {"Hammer",  "Cleave", "God", "God", "Scepter", "Shard"},
    ["npc_dota_hero_sniper"] = {"Vitality_Booster", "Shrapnel", "Headshot", "Aim", "Aim", "Assassinate", "Assassinate", "Shard"},
    ["npc_dota_hero_muerta"] = {"Gun", "Veil", "Veil", "Veil", "Scepter"},
    ["npc_dota_hero_pangolier"] = {"buckle","Shield", "Lucky", "Rolling", "Rolling", "Scepter"},
    ["npc_dota_hero_arc_warden"] = {"movespeed", "flux", "spark", "spark", "double", "double", "double", "double", "double", "Scepter"},
    ["npc_dota_hero_invoker"] = {"movespeed","invoke","wex","sunstrike","walk","emp","emp","deafing","Scepter"},
    ["npc_dota_hero_razor"] = {"link","link","link","link","eye","scepter","shard"},
    ["npc_dota_hero_sand_king"] = {"burrow", "sand", "finale", "epicenter", "Scepter", "Shard"},
}


function hero_select:RegisterHeroes()
    local enable_heroes = {}
    local hero_list = {}
    local anime = {}
    local all = {}
    local heroes = LoadKeyValues("scripts/npc/activelist.txt")
    local h = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
    local abilki = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")

    for k, v in pairs(heroes) do
        if v == 1 then
            table.insert(enable_heroes, k)
        end
    end

    for c = 1, #enable_heroes do
        local inf = h[enable_heroes[c]]
        local ability = {}
        local heroid = {}
        if inf then
            for ab = 1, 9 do
                if
                    inf["Ability" .. ab] ~= nil and inf["Ability" .. ab] ~= "" and
                        inf["Ability" .. ab] ~= "generic_hidden"
                 then
                    if abilki[inf["Ability" .. ab]] then
                        behavior = abilki[inf["Ability" .. ab]].AbilityBehavior
                    end
                    if behavior and not behavior:find("DOTA_ABILITY_BEHAVIOR_HIDDEN") then
                        table.insert(ability, inf["Ability" .. ab])
                    end
                end
            end
            CustomNetTables:SetTableValue("custom_pick", tostring(enable_heroes[c]), ability)
        end
    end

    HEROES_FOR_PICK = enable_heroes

    for _, hero in pairs(enable_heroes) do
        if h[hero].AttributePrimary == "DOTA_ATTRIBUTE_STRENGTH" then
            hero_list[hero] = 0
        elseif h[hero].AttributePrimary == "DOTA_ATTRIBUTE_AGILITY" then
            hero_list[hero] = 1
        elseif h[hero].AttributePrimary == "DOTA_ATTRIBUTE_INTELLECT" then
            hero_list[hero] = 2
        elseif h[hero].AttributePrimary == "DOTA_ATTRIBUTE_ALL" then
            hero_list[hero] = 3
        end
    end

    CustomNetTables:SetTableValue("custom_pick", "hero_list", hero_list)
    CustomNetTables:SetTableValue("custom_pick", "hero_changes", hero_changes)
    CustomNetTables:SetTableValue("custom_pick", "donate_heroes", DONATE_HEROES)
end
