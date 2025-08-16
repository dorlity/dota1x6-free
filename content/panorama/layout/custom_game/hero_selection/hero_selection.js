const kampf = $.GetContextPanel()
const main = $.GetContextPanel
$.GetContextPanel = () => main() || kampf
var dotahud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent();
var max_games = 5
var pick_started = false
var IS_DUO_MODE = false
var wrong_rating_status = 0
var hero_selected = ''
var current_tab = 0

function init()
{
    let game_mode_table = CustomNetTables.GetTableValue("custom_pick", "game_mode")
    let minimap = $.GetContextPanel().FindChildTraverse("minimap")

    if (game_mode_table && game_mode_table.team_size >= 2)
    {
        $.GetContextPanel().AddClass("IsDuoMode")
        //$.GetContextPanel().RemoveClass("IsDuoMode")
        minimap.AddClass("minimap_duo")
        IS_DUO_MODE = true
    }else
    {
        minimap.AddClass("minimap_solo")
    }

	GameEvents.Subscribe_custom("pick_start", pick_start)
	GameEvents.Subscribe_custom("pick_select_hero", pick_select_hero)
	GameEvents.Subscribe_custom("pick_select_base", pick_select_base)
	GameEvents.Subscribe_custom("reload_pick_heroes", reload_pick_heroes)
	GameEvents.Subscribe_custom("reload_pick_bases", reload_pick_bases)
	GameEvents.Subscribe_custom("pick_end", end_pick)
	GameEvents.Subscribe_custom("pick_base_end", pick_base_end)
	GameEvents.Subscribe_custom("start_base_pick", start_base_pick)
	GameEvents.Subscribe_custom("pick_start_time", pick_start_time)
	GameEvents.Subscribe_custom("pick_start_time_base", pick_start_time_base)
	GameEvents.Subscribe_custom("change_time_base", change_time_base)
	GameEvents.Subscribe_custom("change_time", change_time)
	GameEvents.Subscribe_custom("ban_hero_vote", ban_hero_vote)
	GameEvents.Subscribe_custom("ban_hero", ban_hero)
	GameEvents.Subscribe_custom("clear_ban_hero", clear_ban_hero)
	//GameEvents.Subscribe_custom('get_payment_url', get_custom_pick_url)
	GameEvents.Subscribe_custom("update_lobby_rating", update_lobby_rating)
	GameEvents.Subscribe_custom("StartBanStage", StartBanStage)
	GameEvents.Subscribe_custom("TimeBanStage", TimeBanStage)
	GameEvents.Subscribe_custom("EndBanStage", EndBanStage)
    GameEvents.Subscribe_custom("pick_update_selection_button", pick_update_selection_button)
    GameEvents.Subscribe_custom("update_pre_select_base", update_pre_select_base)
    GameEvents.Subscribe_custom("ReturnClickHero", ReturnClickHero)

	let InfoText = $.GetContextPanel().FindChildTraverse("InfoText")
	InfoText.text = $.Localize('#pick_start')
    let text = $.Localize("#RandomBonus_info")
	let SelectRandomHero_bonus = $.GetContextPanel().FindChildTraverse("SelectRandomHero_bonus")
	SelectRandomHero_bonus.SetPanelEvent('onmouseover', function() 
	{
		$.DispatchEvent('DOTAShowTextTooltip', SelectRandomHero_bonus, text)
	});
	SelectRandomHero_bonus.SetPanelEvent('onmouseout', function() 
	{
		$.DispatchEvent('DOTAHideTextTooltip', SelectRandomHero_bonus);
	});
    
    let start_quest_panel = $.CreatePanel("Panel", $.GetContextPanel(), "start_quest_panel")
    start_quest_panel.BLoadLayout( "file://{resources}/layout/custom_game/start_quest/start_quest.xml", false, false );
}

function pick_start() 
{
	if (pick_started) { return }
	StealButtons()
	let avg_rating = CustomNetTables.GetTableValue("custom_pick", "avg_rating");
	if (avg_rating) 
    {
		let lobby_rating = $.GetContextPanel().FindChildTraverse("lobby_rating_text")
        if (lobby_rating)
        {
            lobby_rating.text = $.Localize("#avg_rating") + avg_rating.avg_rating
        }
	}
    if (IS_DUO_MODE)
    {
        CreatePlayersDuo()
    }
    else
    {
        CreatePlayersSolo()
    }

	update_lobby_rating()
	$.Schedule(0.2, function() 
	{
		const pick_state = CustomNetTables.GetTableValue("custom_pick", "pick_state")
		if (pick_state === undefined || pick_state.in_progress)
        {
			pick_start()
        }
	})
}

function CreatePlayersSolo()
{
    let lobby_heroes = $.GetContextPanel().FindChildTraverse("lobby_players_list")
    let player_list = CustomNetTables.GetTableValue("custom_pick", "player_lobby");
	if (player_list) 
	{
		const players = Object.entries(player_list.lobby_players).map(([pid, data]) => [pid, data.pick_order]).sort((a, b) => a[1] - b[1])
		for (const [pid, i] of players) 
		{
			pick_started = true
			CreatePlayerPanel(pid, lobby_heroes)
		}
	}
}

function CreatePlayersDuo()
{
    let lobby_heroes = $.GetContextPanel().FindChildTraverse("lobby_players_list")
    let player_list = CustomNetTables.GetTableValue("custom_pick", "player_lobby");
    let teams_list = CustomNetTables.GetTableValue("custom_pick", "teams_lobby");
	if (player_list) 
	{
		const players = Object.entries(player_list.lobby_players).map(([pid, data]) => [pid, data.pick_order, data.player_team]).sort((a, b) => a[1] - b[1])
        const teams = Object.entries(teams_list.lobby_teams).map(([team_id, data]) => [team_id, data.pick_order]).sort((a, b) => a[1] - b[1])
        for (const [team_id, i] of teams)
        {
            pick_started = true
            let lobby_team_panel = CreateTeamPanel(team_id, lobby_heroes)
            if (lobby_team_panel)
            {
                for (const [pid, i, player_team] of players) 
                {
                    if (player_team == team_id)
                    {
                        CreatePlayerPanel(pid, lobby_team_panel)
                    }
                }
            }
        }
	}
}

function CreateTeamPanel(team_id, parent)
{
    let lobby_team_panel = $.GetContextPanel().FindChildTraverse("lobby_team_panel_"+team_id)
    if (lobby_team_panel)
    {
        return lobby_team_panel
    }
    lobby_team_panel = $.CreatePanel("Panel", parent, "lobby_team_panel_"+team_id);
    lobby_team_panel.AddClass("lobby_team_panel")
    return lobby_team_panel
}

function CreatePlayerPanel(pid, parent)
{
	let server_data = CustomNetTables.GetTableValue("server_data", String(pid));

    let player_and_timer = parent

    if (!IS_DUO_MODE)
    { 
        player_and_timer = $.CreatePanel("Panel", parent, "player_and_timer" + pid);
        player_and_timer.AddClass("player_and_timer")
    }

	let player_portrait = $.CreatePanel("Panel", player_and_timer, "player" + pid);
	player_portrait.AddClass("player_portrait")
	
	if (pid == Game.GetLocalPlayerID()) 
	{
		player_portrait.AddClass("player_portrait_local")
	}

	let player_icon = $.CreatePanel("Panel", player_portrait, "player_icon" + pid);
	player_icon.AddClass("hero_icon")
	player_icon.style.backgroundSize = "100%"
	player_icon.style.backgroundRepeat = "no-repeat"

	let random_icon_fill = $.CreatePanel("Panel", player_portrait, "random_icon_fill" + pid);
	random_icon_fill.AddClass("random_icon_fill")

	let random_icon = $.CreatePanel("Panel", random_icon_fill, "random_icon" + pid);
	random_icon.AddClass("random_icon")
	random_icon.backgroundSize = "100%"

	let rank_icon = $.CreatePanel("Panel", player_portrait, "rank_icon" + pid);
	rank_icon.AddClass("player_rank_icon")
	rank_icon.backgroundSize = "contain";

	let hero_tier = $.CreatePanel("Panel", player_portrait, "hero_tier" + pid);
	hero_tier.AddClass("hero_tier_icon")
	hero_tier.backgroundSize = "100%"
	hero_tier.style.visibility = "collapse";

	let hero_tier_text = $.CreatePanel("Label", hero_tier, "hero_tier_text" + pid);
	hero_tier_text.AddClass("hero_tier_text")

	let rating = "?"
	if (server_data && server_data.rating != null)
	{
		//rating = String(server_data.rating)
	}

	let player_nic = $.CreatePanel("Label", player_portrait, "nicname" + pid);
    if (IS_DUO_MODE)
    {
        player_nic.text = Players.GetPlayerName(parseInt(pid))
    }
    else
    {
        player_nic.text = $.Localize("#rating_change") + '    ' + rating // Players.GetPlayerName(parseInt(pid))   
    }

	let player_rank_text = $.CreatePanel("Label", player_portrait, "player_rank_text" + pid);
	player_rank_text.AddClass("player_rank_text")

	let text_style = "player_portrait_text"
	if (server_data && server_data.wrong_map_status && server_data.wrong_map_status == 2) 
	{	
		//text_style = "player_portrait_text_red"
		//MouseOver(player_portrait, $.Localize("#wrong_rating"))
	}
	player_nic.AddClass(text_style)
}

function start_base_pick() 
{
	var pick_phase = $.GetContextPanel().FindChildTraverse("lobby_players")
	var hero_pick = $.GetContextPanel().FindChildTraverse("hero_pick")
	pick_phase.RemoveClass("panel_open_left")
	hero_pick.RemoveClass("panel_open_right")
	pick_phase.AddClass("panel_close_right")
	hero_pick.AddClass("panel_close_left")
	hide_chosen_hero()
	$.Schedule(0.6, function()
	{
		Game.EmitSound("UI.Start_Pick_Base")
		pick_phase.DeleteAsync(0)
		hero_pick.DeleteAsync(0)
		var minimap = $.GetContextPanel().FindChildTraverse("pick_base_mimimap")
		minimap.RemoveClass("pick_base_mimimap_hidden")
		minimap.AddClass("pick_base_mimimap_show")
		minimap.AddClass("pick_base_mimimap_visible")
		var minimap_text = $.GetContextPanel().FindChildTraverse("minimap_text_text")
		minimap_text.text = $.Localize("#minimap_text")
		var player_list = CustomNetTables.GetTableValue("custom_pick", "player_lobby");
        let teams_list = CustomNetTables.GetTableValue("custom_pick", "teams_lobby");

		var player_pick = $.GetContextPanel().FindChildTraverse("pick_base_players")
		player_pick.RemoveClass("pick_base_players_hidden")
		player_pick.AddClass("pick_base_players_show")
		
		var player_heroes = $.GetContextPanel().FindChildTraverse("pick_base_heroes")
        
		if (player_list) 
		{
			const players_inv = Object.entries(player_list.lobby_players).map(([pid, data]) => [pid, data.pick_order, data.player_team]).sort((a, b) => a[1] - b[1])
            if (IS_DUO_MODE)
            {
                const teams = Object.entries(teams_list.lobby_teams).map(([team_id, data]) => [team_id, data.pick_order]).sort((a, b) => a[1] - b[1])
                for (const [team_id, i] of teams)
                {
                    let lobby_team_panel = CreateTeamPanelBase(team_id, player_heroes)
                    if (lobby_team_panel)
                    {
                        for (const [pid, i, player_team] of players_inv) 
                        {
                            if (player_team == team_id)
                            {
                                CreatePlayerPanelBase(pid, lobby_team_panel)
                            }
                        }
                    }
                }
            }
            else
            {
                for (const [pid, i, player_team] of players_inv) 
                {
                    CreatePlayerPanelBase(pid, player_heroes)
                }
            }
		}
		update_lobby_rating()
	})
}

function CreateTeamPanelBase(team_id, parent)
{
    let lobby_team_panel = $.GetContextPanel().FindChildTraverse("lobby_team_panel_base_"+team_id)
    if (lobby_team_panel)
    {
        return lobby_team_panel
    }
    lobby_team_panel = $.CreatePanel("Panel", parent, "lobby_team_panel_base_"+team_id);
    lobby_team_panel.AddClass("lobby_team_panel_base")
    return lobby_team_panel
}

function CreatePlayerPanelBase(pid, parent)
{
    var sub_data = CustomNetTables.GetTableValue("sub_data", String(pid));
    var player_list = CustomNetTables.GetTableValue("custom_pick", "player_lobby");
    var player_pick = $.GetContextPanel().FindChildTraverse("pick_base_players")

    let player_and_timer = parent

    if (!IS_DUO_MODE)
    { 
        player_and_timer = $.CreatePanel("Panel", parent, "player_and_timer_base_pick" + pid);
        player_and_timer.AddClass("player_and_timer_base_pick")
    }

    let player_portraits = $.CreatePanel("Panel", player_and_timer, "player_base" + pid);
    player_portraits.AddClass("player_base_pick")
    
    if (pid == Game.GetLocalPlayerID()) 
    {
        player_portraits.AddClass("player_base_pick_local")
        let empty_block_for_items = $.CreatePanel("Panel", $("#pick_base_main"), "")
        empty_block_for_items.BLoadLayout( "file://{resources}/layout/custom_game/info_reports/hero_selection_items.xml", false, false );
        if (GameUI.CustomUIConfig().PlayerHasItemInSelection(player_list.lobby_players[pid].picked_hero))
        {
            GameUI.CustomUIConfig().InitItemsForPlayer(player_list.lobby_players[pid].picked_hero)
            $.GetContextPanel().AddClass("HasItemsPanelHeroes")
            player_pick.AddClass("pick_base_players_visible_items")
        }
        else
        {
            empty_block_for_items.visible = false
            player_pick.AddClass("pick_base_players_visible")
        }
    }

    let player_icon = $.CreatePanel("Panel", player_portraits, "player_base_icon" + pid);
    player_icon.AddClass("player_base_icon")

    player_icon.style.backgroundImage = "url('file://{images}/heroes/" + Game.GetHeroImage(pid, String(player_list.lobby_players[pid].picked_hero)) + ".png')"
    player_icon.style.backgroundSize = "100%";

    let hero_tier = $.CreatePanel("Panel", player_portraits, "hero_base_tier" + pid);
    hero_tier.AddClass("hero_tier_icon")
    hero_tier.backgroundSize = "100%"
    hero_tier.style.visibility = "collapse";

    let hero_tier_text = $.CreatePanel("Label", hero_tier, "hero_base_tier_text" + pid);
    hero_tier_text.AddClass("hero_tier_text")

    let rank_icon = $.CreatePanel("Panel", player_portraits, "base_rank_icon" + pid);
      rank_icon.AddClass("player_rank_icon")
      rank_icon.backgroundSize = "contain";

    if (sub_data && sub_data.heroes_data[player_list.lobby_players[pid].picked_hero] && sub_data.heroes_data[player_list.lobby_players[pid].picked_hero].has_level == 1 && sub_data.subscribed == 1  && sub_data.hide_tier == 0) 
    {
        hero_tier.style.visibility = "visible";
        hero_tier.style.backgroundImage = 'url("file://{images}/custom_game/hero_level_big_' + String(sub_data.heroes_data[player_list.lobby_players[pid].picked_hero].tier) + '.png");'
    }

    if (sub_data && sub_data.heroes_data[player_list.lobby_players[pid].picked_hero] && sub_data.heroes_data[player_list.lobby_players[pid].picked_hero].has_level == 1 && sub_data.subscribed == 1  && sub_data.hide_tier == 0) 
    {
        hero_tier_text.text = sub_data.heroes_data[player_list.lobby_players[pid].picked_hero].level
    }

    let player_rank_text = $.CreatePanel("Label", player_portraits, "base_player_rank_text" + pid);
    player_rank_text.AddClass("player_rank_text")

    let player_nic = $.CreatePanel("Label", player_portraits, "nicname" + pid);
    player_nic.text = Players.GetPlayerName(parseInt(pid))
    player_nic.AddClass("player_base_text")
}

function pick_start_time_base(kv) 
{
    let timer = $.GetContextPanel().FindChildTraverse("pick_timer_base")
    if (timer && timer.IsValid())
    {
        timer.DeleteAsync(0)
    }

    CreateTimer(kv, true)

	var bases = []
	for (var i = 1; i <= 6; i++) 
    {
		bases[i] = $.GetContextPanel().FindChildTraverse("base_icon" + String(i))
		RemoveMouse(bases[i])
	}
    for (let base_team of $("#DuoBaseIcons").Children())
    {
        RemoveMouse(base_team)
    }
	if (Game.GetLocalPlayerID() == kv.id) 
    {
		Game.EmitSound("UI.Your_turn")
	}
}


function change_time_base(kv) 
{
    var timer = $.GetContextPanel().FindChildTraverse("pick_timer_base")

    if (!timer)
    {
        timer = CreateTimer(kv, true)
    }

    if (timer) 
    {
        timer.GetChild(0).text = String(kv.time)
    }

    let allow_sound = Game.GetLocalPlayerID() == kv.id

    if (IS_DUO_MODE)
    {
        allow_sound = Players.GetTeam(Game.GetLocalPlayerID()) == kv.current_team
    }

    if (allow_sound)
    {
        if (kv.time == 5) 
        {
            Game.EmitSound("UI.Pick_5_sec")
        }
        if (kv.time < 5) 
        {
            Game.EmitSound("General.ButtonClick");
        }
    }

	var bases = []
    let bases_counter = 6
    if (IS_DUO_MODE)
    {
        bases_counter = 5
    }
	for (var i = 1; i <= bases_counter; i++) 
	{
        if (IS_DUO_MODE)
        {
            bases[i] = $.GetContextPanel().FindChildTraverse("TeamBaseIcons_" + String(i))
        }
        else
        {
            bases[i] = $.GetContextPanel().FindChildTraverse("base_icon" + String(i))
        }
	}

	var flag = true
	var active_player = CustomNetTables.GetTableValue("custom_pick", "active_player");
	if (active_player.id == Game.GetLocalPlayerID() || active_player.current_team == Players.GetTeam( Players.GetLocalPlayer() )) 
	{
		for (var i = 1; i <= bases_counter; i++) 
		{
			flag = true
			for (var j = 0; j <= kv.picked_bases_length; j++) 
			{
				if (kv.picked_bases[j] == i) 
				{
					flag = false
				}
			}
			if (flag == true) 
			{
				SetMouse(bases[i], i)
			}
		}
	}
}

function IsSpectator() 
{
	const localPlayer = Players.GetLocalPlayer()
	if (Players.IsSpectator(localPlayer))
		return true
	const localTeam = Players.GetTeam(localPlayer)
	return localTeam !== 2 &&
		localTeam !== 3 &&
		localTeam !== 6 &&
		localTeam !== 7 &&
		localTeam !== 8 &&
		localTeam !== 9
}


CustomNetTables.SubscribeNetTableListener( "players_heroes", update_players_heroes );
function update_players_heroes(table, key, data)
{
	if (table != "players_heroes") return
	if (key == -1 || key == "-1" || key == "") return
	pick_select_hero(data)
}

function get_custom_pick_url(kv)
{
	$.DispatchEvent("ExternalBrowserGoToURL", kv.url);
}

function show_badmap(id)
{
	var server_data = CustomNetTables.GetTableValue("server_data", String(id));
	if (!server_data)
			return

	let kv = []
	kv.mmr = server_data.rating
	kv.max = server_data.map_rating.max
	kv.min = server_data.map_rating.min

	var hero_pick = $.GetContextPanel().FindChildTraverse("hero_pick")

	let event = hero_pick.FindChildTraverse("BadMap")

	event.RemoveClass("BadMap_hidden")

	let text = event.FindChildTraverse("BadMap_top_text")
	text.html = true
	text.text = $.Localize("#badmap_top")


	let text2 = event.FindChildTraverse("BadMap_your_mmr_text")
	text2.html = true
	text2.text = $.Localize("#badmap_your_mmr") + String(kv.mmr)

	let text3 = event.FindChildTraverse("BadMap_map_mmr_text")
	text3.html = true

	var max = kv.max 

	if (max > 10000)
	{
		text3.text = $.Localize("#badmap_map_mmr") + String(kv.min) + "+"

	}
    else 
	{
		text3.text = $.Localize("#badmap_map_mmr") + String(kv.min) + "-" + String(kv.max)
	}

	let text4 = event.FindChildTraverse("BadMap_bottom_text")
	text4.html = true
	text4.text = $.Localize("#badmap_pick_stage")

	let text5 = event.FindChildTraverse("BadMap_leave_text")
	text5.html = true
	text5.text = $.Localize("#badmap_pick_stage_leave")
	
	let text6 = event.FindChildTraverse("BadMap_leave_button_text")
	text6.html = true
	text6.text = $.Localize("#badmap_pick_stage_leave_button")

	let name_image = String($.Localize("#badmap_image"))

	let image = event.FindChildTraverse("BadMap_image")
    image.style.backgroundImage = "url('file://{images}/custom_game/" + name_image + ".png')"
    image.style.backgroundSize = 'contain';
}

function show_safe_leave(reason, id)
{
	if (wrong_rating_status == 1) return;
	var panel = $.GetContextPanel().FindChildTraverse("SafeToLeave")
	if (reason != 0 && panel)
	{
		panel.RemoveClass("SafeToLeave_hidden")
		panel.AddClass("SafeToLeave")
		var text = $.GetContextPanel().FindChildTraverse("SafeToLeave_text")
		text.html = true
		if (reason == 1)
		{
			text.text = $.Localize("#Savetoleave")
		}
		if (reason == 2)
		{
			wrong_rating_status = 1
			if (id !== null && Game.GetLocalPlayerID() == id)
			{
				var hero_pick = $.GetContextPanel().FindChildTraverse("hero_pick")
				var hero_pick_contet = hero_pick.FindChildTraverse("hero_pick_content")
				if (hero_pick_contet)
				{
					hide_chosen_hero()
					hero_pick_contet.DeleteAsync(0)
					show_badmap(id)
				}
			}
            else 
			{
				text.text = $.Localize("#Savetoleave_rating_players")
			}
		}
		if (reason == 3)
		{
			text.text = $.Localize("#Savetoleave_notstats")
		}
	}
	if (reason == 0 && panel && panel.BHasClass("SafeToLeave"))
	{
		panel.RemoveClass("SafeToLeave")
		panel.AddClass("SafeToLeave_hidden")
	}
}

function RandomHero() 
{
	GameEvents.SendCustomGameEventToServer_custom("chose_hero", {
		random: true,
		hero: "npc_dota_hero_wisp"
	});
    if (!IS_DUO_MODE)
    {
        var timer = $.GetContextPanel().FindChildTraverse("pick_timer")
        if (timer) 
        {
            timer.DeleteAsync(0)
        }
    }
}

function Player_Loaded() 
{
	check_connection()
	GameEvents.OnLoaded(() => {
		const pick_state = CustomNetTables.GetTableValue("custom_pick", "pick_state")
		if (pick_state === undefined || pick_state.in_progress)
		{
			pick_load_heroes()
			pick_start()
		}
		else
		{
			end_pick()
		}
	})
}

function getRandomInt(max) 
{
    return Math.floor(Math.random() * max);
}

function check_connection()
{
	for (var id = 0; id <= 5; id++) 
    {
		if (Players.GetPlayerSelectedHero(id) != 'invalid index') 
		{
			var server_data = CustomNetTables.GetTableValue("server_data", String(id));
			var playerInfo = Game.GetPlayerInfo(id);
			if (server_data && server_data.stats_match == false)
			{
				show_safe_leave(3)
			}
            else
			{
				show_safe_leave(0)
			}
			var icon = $.GetContextPanel().FindChildTraverse("player_icon" + id)
			if (icon && playerInfo) 
			{
				var connect = icon.FindChildTraverse("hero_connect" + id)
				var state = playerInfo.player_connection_state
				if (!connect && (state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED || state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED)) 
				{
					connect = $.CreatePanel("Panel", icon, "hero_connect" + id)
					connect.AddClass("hero_disconnect")
				}
				if (connect && playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_CONNECTED) 
				{
					connect.DeleteAsync(0)
				}
				if (playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED) 
				{
					if (server_data && server_data.wrong_map_status !== 2 && server_data.stats_match == true)
					{
						show_safe_leave(1)
					}
                    icon.RemoveClass("hero_icon_search")
					icon.AddClass("hero_abandon")
				}
			}
			var icon_base = $.GetContextPanel().FindChildTraverse("player_base_icon" + id)
			if (icon_base && playerInfo)
            {
				var connect = icon_base.FindChildTraverse("hero_connect_base" + id)
				var state = playerInfo.player_connection_state
				if (!connect && (state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED || state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED)) {
					connect = $.CreatePanel("Panel", icon_base, "hero_connect_base" + id)
					connect.AddClass("hero_base_disconnect")
				}
				if (connect && playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_CONNECTED) {
					connect.DeleteAsync(0)
				}
				if (playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED) {
					icon_base.AddClass("hero_abandon")
				}
			}
		}
	}
	$.Schedule(0.2, function() 
    {
		const pick_state = CustomNetTables.GetTableValue("custom_pick", "pick_state")
		if (pick_state === undefined || pick_state.in_progress)
			check_connection()
	})
}


function CreateTimer(kv, is_base_pick)
{
    let timer_name = "pick_timer"
    let timer_parent_panel = $.GetContextPanel().FindChildTraverse("player_and_timer" + kv.id)
    if (is_base_pick)
    {
        timer_name = "pick_timer_base"
        timer_parent_panel = $.GetContextPanel().FindChildTraverse("player_and_timer_base_pick" + kv.id)
    }

    if (IS_DUO_MODE)
    {
        if (is_base_pick)
        {
            timer_parent_panel = $("#pick_base_heroes").FindChildTraverse("lobby_team_panel_base_"+kv.current_team)
        }else
        {
            timer_parent_panel = $("#lobby_players_list").FindChildTraverse("lobby_team_panel_"+kv.current_team)
        }
    }
    if (timer_parent_panel)
    {
        let timer = $.CreatePanel("Panel", timer_parent_panel, timer_name)
        timer.AddClass("pick_timer_duo")

        let timer_text = $.CreatePanel("Label", timer, "pick_timer_text")
        timer_text.AddClass("timer_text_duo")
        timer_text.text = String(kv.time)

        return timer
    }
}



function pick_start_time(kv) 
{
    var timer = $.GetContextPanel().FindChildTraverse("pick_timer")
    if (timer) 
    {
        timer.DeleteAsync(0)
    }

    let allow_sound = Game.GetLocalPlayerID() == kv.id

    if (IS_DUO_MODE)
    {
        allow_sound = kv.current_team == Players.GetTeam(Game.GetLocalPlayerID())
    }

    CreateTimer(kv)

    if (allow_sound == true)
    {
        $.Schedule(1, function() 
        {
            Game.EmitSound("UI.Your_turn")
        })
    }

	if (hero_selected !== '') 
    {
		Refresh_Button()
	}
}

function RemoveMouse(panel) 
{
	panel.RemoveClass("base_icon_hover")
	panel.AddClass("base_icon_hover_out")
	panel.SetPanelEvent('onmouseover', function() {})
	panel.SetPanelEvent("onactivate", function() {});
	panel.SetPanelEvent('onmouseout', function() {})
}

function SetMouse(panel, number) 
{
	if (!panel) return

	panel.SetPanelEvent('onmouseover', function() 
    {
		panel.RemoveClass("base_icon_hover_out")
		panel.AddClass("base_icon_hover")
	})
	panel.SetPanelEvent('onmouseout', function() 
    {
		panel.RemoveClass("base_icon_hover")
		panel.AddClass("base_icon_hover_out")
	})
	panel.SetPanelEvent("onactivate", function() 
    {
		GameEvents.SendCustomGameEventToServer_custom("chose_base", 
        {
			number: number
		});
		panel.RemoveClass("base_icon_hover")
		panel.AddClass("base_icon_hover_out")
		Game.EmitSound("General.ButtonClick");
	});
}

function Refresh_Random_Button(low_priority) 
{
	var RandomHero_panel = $.GetContextPanel().FindChildTraverse("SelectRandomHero_panel")
	var RandomHero_button = $.GetContextPanel().FindChildTraverse("SelectRandomHero")
	var active_player = CustomNetTables.GetTableValue("custom_pick", "active_player");
    var player_list = CustomNetTables.GetTableValue("custom_pick", "player_lobby");

    if (!RandomHero_panel || !RandomHero_button)
    	return

	if ((active_player && (active_player.id !== Game.GetLocalPlayerID() && active_player.current_team !== Players.GetTeam( Players.GetLocalPlayer() ))) || (low_priority > 0) || (player_list.lobby_players[Game.GetLocalPlayerID()] && player_list.lobby_players[Game.GetLocalPlayerID()].picked_hero != null ) )
	{	
		RandomHero_button.SetPanelEvent("onactivate", function() {});
		RandomHero_panel.RemoveClass("SelectRandomHero_panel")
		RandomHero_panel.AddClass("SelectRandomHero_panel_hidden")
	}
    else
	{
		RandomHero_panel.RemoveClass("SelectRandomHero_panel_hidden")
		RandomHero_panel.AddClass("SelectRandomHero_panel")
		RandomHero_button.SetPanelEvent("onactivate", function()
		{
			RandomHero();
		});
	}
}

function change_time(kv) 
{
	var server_data = CustomNetTables.GetTableValue("server_data", Game.GetLocalPlayerID().toString());
	let lp_games = 0
	if ((server_data) && (server_data.lp_games_remaining > 0)) 
	{
		lp_games = server_data.lp_games_remaining
		var LP = $.GetContextPanel().FindChildTraverse("BanStagePanel")

		LP.RemoveClass("BanStagePanel_hidden")
		LP.AddClass("BanStagePanel_visible")

		var LP_text = $.GetContextPanel().FindChildTraverse("BanStagePanel_text")
		LP_text.text = $.Localize('#LowPriority')

		var LP_count_text = $.GetContextPanel().FindChildTraverse("BanStagePanel_timer")
		LP_count_text.text = $.Localize('#LowPriority_count') + String(server_data.lp_games_remaining)
	}
	Refresh_Random_Button(lp_games)
	var avg_rating = CustomNetTables.GetTableValue("custom_pick", "avg_rating");
	if (avg_rating) 
	{
		var lobby_rating = $.GetContextPanel().FindChildTraverse("lobby_rating_text")
		lobby_rating.text = $.Localize("#avg_rating") + avg_rating.avg_rating
	}

    let allow_sound = Game.GetLocalPlayerID() == kv.id
    let timer = $.GetContextPanel().FindChildTraverse("pick_timer")

    if (IS_DUO_MODE)
    {
        allow_sound = Players.GetTeam(Game.GetLocalPlayerID()) == kv.current_team
    }
      
    if (allow_sound) 
    {
        if (kv.time == 10) 
        {
            Game.EmitSound("UI.Pick_10_sec")
        }
        if (kv.time == 5) 
        {
            Game.EmitSound("UI.Pick_5_sec")
        }
        if (kv.time < 5) 
        {
            Game.EmitSound("General.ButtonClick");
        }
    }

    if (!timer) 
    {
        timer = CreateTimer(kv)
    }

    if (timer) 
    {
        timer.GetChild(0).text = String(kv.time)
    }
}

function update_lobby_rating()
{
	var player_list = CustomNetTables.GetTableValue("custom_pick", "player_lobby");
	var leaderboard = CustomNetTables.GetTableValue("leaderboard", "leaderboard");
	var pick_state = CustomNetTables.GetTableValue("custom_pick", "pick_state")
	if (pick_state == undefined || pick_state == 0)
	{
		return
	}

	var wrong_map_count = 0
	var rating_50 = 999999
	var rating_10 = 999999
	var rating_1 = 999999

	if (leaderboard != undefined)
	{
		if (leaderboard[50] != undefined)
		{
			rating_50 = leaderboard[50].rating
		}
		if (leaderboard[10] != undefined)
		{
			rating_10 = leaderboard[10].rating
		}
		if (leaderboard[1] != undefined)
		{
			rating_1 = leaderboard[1].rating
		}
	}

	var player_portraits = []
	var player_rank = []
	var base_player_rank = []

	if (player_list) 
    {
		const players = Object.entries(player_list.lobby_players).map(([pid, data]) => [pid, data.pick_order]).sort((a, b) => a[1] - b[1])
		for (const [pid, i] of players) 
		{
			var server_data = CustomNetTables.GetTableValue("server_data", String(pid));
			let rating = 0
			let n = 1
			let rank = 0
			if (server_data && server_data.rating != null)
            {
      	        rating = String(server_data.rating)
            }
            player_portraits[i] = $.GetContextPanel().FindChildTraverse("player" + String(pid))
            let base_player_portraits = $.GetContextPanel().FindChildTraverse("player_base" + String(pid))
            player_rank[i] = $.GetContextPanel().FindChildTraverse("rank_icon" + String(pid))
            base_player_rank[i] = $.GetContextPanel().FindChildTraverse("base_rank_icon" + String(pid))

    	    if (server_data && server_data.ranked_tier != null && server_data.in_ranked != 0)
            {
				rank = server_data.ranked_tier
				let player_rank_text = $.GetContextPanel().FindChildTraverse("player_rank_text" + String(pid))
				let base_player_rank_text = $.GetContextPanel().FindChildTraverse("base_player_rank_text" + String(pid))
                if (server_data.ranked_tier >= 6)
                {
                    n = 3
                }
                else
                {
                    if (server_data.ranked_tier >= 4)
                    {
                        n = 2
                    }
                }
				if (rating >= rating_1)
				{
					rank = 10
					n = 4
					if (player_rank_text)
					{
						player_rank_text.AddClass("player_rank_text_top1")
						player_rank_text.text = String(1)
					}

					if (base_player_rank_text)
					{
						base_player_rank_text.AddClass("player_rank_text_top1")
						base_player_rank_text.text = String(1)
					}
				}
                else 
				{
					if (rating >= rating_10)
					{
						rank = 9
						if (player_rank_text)
						{
							player_rank_text.text = String(10)
							player_rank_text.AddClass("player_rank_text_top10")
						}

						if (base_player_rank_text)
						{
							base_player_rank_text.AddClass("player_rank_text_top10")
							base_player_rank_text.text = String(10)
						}
					}
                    else 
					{
						if (rating >= rating_50)
						{
							rank = 8
							if (player_rank_text)
							{
								player_rank_text.text = String(50)
							}

							if (base_player_rank_text)
							{
								base_player_rank_text.text = String(50)
							}
						}
					}
				}
				if (pid == Game.GetLocalPlayerID()) 
				{
					if (player_portraits[i])
					{
						player_portraits[i].AddClass("player_portrait_local_" + String(n))
					}
					if (base_player_portraits)
					{
						base_player_portraits.AddClass("player_portrait_local_" + String(n))
					}
				}
                else
				{
					if (player_portraits[i])
					{
						player_portraits[i].AddClass("player_portrait_" + String(n))
					}
					if (base_player_portraits)
					{
						base_player_portraits.AddClass("player_portrait_" + String(n))
					}
				}
				if (player_rank[i])
				{
                    player_rank[i].AddClass("player_rank_icon_" + rank)
                }
				if (base_player_rank[i])
				{
                    base_player_rank[i].AddClass("player_rank_icon_" + rank)
                }
            }

			let player_nic = $.GetContextPanel().FindChildTraverse("nicname" + String(pid))
			if (player_nic)
			{
                if (IS_DUO_MODE)
                {
                    player_nic.text = Players.GetPlayerName(parseInt(pid))
                }
                else
                {
                    player_nic.text = $.Localize("#rating_change") + '    ' + rating
                }
				let text_style = "player_portrait_text"
				if (server_data && server_data.wrong_map_status && server_data.wrong_map_status == 2 && (server_data.stats_match == true || server_data.stats_match == 1)) 
				{	
					text_style = "player_portrait_text_red"
					MouseOver(player_portraits[i], $.Localize("#wrong_rating"))
					wrong_map_count = wrong_map_count + 1
					if (wrong_map_count >= 1)
					{
						show_safe_leave(2, pid)
					}
				}
                else
				{
					if (rank > 0)
					{
						MouseOver(player_portraits[i], $.Localize("#player_rank_icon_" + String(rank)))	
					}
				}
				player_nic.AddClass(text_style)
			}
		}
	}
}

function StealButtons() 
{
	if ($.GetContextPanel().BHasClass('Deletion')) return;
	var buttons = dotahud.FindChildTraverse('DashboardButton');
	if (buttons) 
    {
		buttons.SetParent($.GetContextPanel());
	}
	buttons = dotahud.FindChildTraverse('SettingsButton');
	if (buttons) 
    {
		buttons.SetParent($.GetContextPanel());
	}
}

function RestoreButtons() 
{
	var HudElements = dotahud.FindChildTraverse("MenuButtons").FindChildTraverse('ButtonBar');
	if (HudElements == undefined)
	{
		$.Schedule(0.5, function() 
        {
			RestoreButtons()
        });
	}
	var buttons = dotahud.FindChildTraverse('DashboardButton');
	if (buttons) 
    {
		buttons.SetParent(HudElements);
		HudElements.MoveChildBefore(buttons, HudElements.FindChildTraverse("ToggleScoreboardButton"))
	}
	buttons = dotahud.FindChildTraverse('SettingsButton');
	if (buttons) 
    {
		buttons.SetParent(HudElements);
		HudElements.MoveChildBefore(buttons, HudElements.FindChildTraverse("ToggleScoreboardButton"))
	}
}

function end_pick() 
{
	$.GetContextPanel().DeleteAsync(0)
}

function pick_base_end() 
{
	let loading = $.CreatePanel('Panel', $.GetContextPanel(), "pick_loading")
	loading.AddClass("loading")
	loading.style.opacity = "0";

	loading.hittest = false

	let loading_content = $.CreatePanel('Panel', loading, "")
	loading_content.AddClass("loading_content")

	let loading_content_spin = $.CreatePanel('Panel', loading_content, "")
	loading_content_spin.AddClass("loading_content_spin")

	let loading_content_close = $.CreatePanel('Panel', loading, "")
	loading_content_close.AddClass("loading_content_close")

	let loading_content_text = $.CreatePanel('Label', loading_content, "")
	loading_content_text.AddClass("loading_content_text")

	loading_content_text.text =  $.Localize("#pick_loading")

	loading.SetParent($.GetContextPanel().GetParent().GetParent().GetParent())

	var player_pick = $.GetContextPanel().FindChildTraverse("pick_base_players")

	var minimap = $.GetContextPanel().FindChildTraverse("pick_base_mimimap")
    if (GameUI.CustomUIConfig().CloseItemsPanelSelection)
    {
        GameUI.CustomUIConfig().CloseItemsPanelSelection()
    }
	player_pick.RemoveClass("pick_base_players_show")
	player_pick.AddClass("pick_base_players_hide")

	minimap.RemoveClass("pick_base_mimimap_show")
	minimap.AddClass("pick_base_mimimap_hide")

	EndQuestSelection(1)

	$.Schedule(0.65, function() 
    {
		player_pick.RemoveClass("pick_base_players_hide")
		player_pick.AddClass("pick_base_players_hidden")

		minimap.RemoveClass("pick_base_mimimap_hide")
		minimap.AddClass("pick_base_mimimap_hidden")

		$.GetContextPanel().FindChildTraverse("BGScene").AddClass("main_hide")

		$.Schedule(1.2, function() 
        {
			$.GetContextPanel().FindChildTraverse("BGScene").AddClass("hidden")
			$.GetContextPanel().AddClass("main_hide")
			RestoreButtons()
			let panel = $.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("pick_loading")
			if (panel)
			{
				panel.style.opacity = "1";
			}
			$.Schedule(1.2, function() 
            {
				$.GetContextPanel().AddClass("hidden")
				end_pick()
			})
		})
	})
}

function show_chosen_hero(hero)
{
	var hero_info = $.GetContextPanel().FindChildTraverse("hero_chosen")
	var hero_pick = $.GetContextPanel().FindChildTraverse("hero_pick")

    GameEvents.SendCustomGameEventToServer_custom("SetClickHero", { hero: hero });

	if (hero_info && hero_pick)
	{
		hero_info.RemoveClass("hero_chosen_closed")
		hero_info.RemoveClass("hero_chosen_close")
		hero_info.AddClass("hero_chosen_open")
		hero_pick.AddClass("hero_pick_blured")
	}
}

function hide_chosen_hero()
{
	var hero_info = $.GetContextPanel().FindChildTraverse("hero_chosen")
	var hero_pick = $.GetContextPanel().FindChildTraverse("hero_pick")
	if (hero_info && hero_pick && hero_info.BHasClass("hero_chosen_open"))
	{
		hero_info.AddClass("hero_chosen_closed")
		hero_info.AddClass("hero_chosen_close")
		hero_info.RemoveClass("hero_chosen_open")

		hero_pick.RemoveClass("hero_pick_blured")
		Game.EmitSound("UI.Hide_chosen_hero")
	}
}



function ShowHero(panel, hero) 
{
    var sub_data = CustomNetTables.GetTableValue("sub_data", String(Players.GetLocalPlayer()));
    var donate_heroes = CustomNetTables.GetTableValue("custom_pick", "donate_heroes")
    panel.SetPanelEvent('onmouseover', function() 
    {
	    let hero_pick = $.GetContextPanel().FindChildTraverse("hero_pick")
	    if (hero_pick.BHasClass("hero_pick_blured")) return
        $.CreatePanel("MoviePanel", $.GetContextPanel(), 'portrait_' + hero, {
            class: "hero_portrait_hover",
            src: "file://{resources}/videos/heroes/" + hero + ".webm",
            repeat: "true",
            hittest: "false",
            autoplay: "onload"
        });
	    var m = Game.GetScreenHeight() / 1080
	    var pos = panel.GetPositionWithinWindow()
	    var portrait_panel = $.GetContextPanel().FindChild('portrait_' + hero)
	    portrait_panel.SetPositionInPixels(pos.x / m, pos.y / m, 0)
	    for (var d = 1; d <= Object.keys(donate_heroes).length; d++)  
	    {
            if (donate_heroes[d] == hero) 
            {
                portrait_panel.AddClass("donate_hero")
                if (sub_data && sub_data.subscribed == 0)
                {
				    var locked_hero = $.CreatePanel("Panel", portrait_panel, "")
				    locked_hero.AddClass("locked_hero_select")
				    locked_hero.hittest = false;
				    portrait_panel.AddClass("donate_hero_locked")
                }
            }
	    }
    });
    panel.SetPanelEvent('onmouseout', function() 
    {
        var movie = $.GetContextPanel().FindChild('portrait_' + hero + '')
        if (movie) 
        {
            movie.DeleteAsync(0)
        }
    })
}

function check_donate_heroes()
{
	let hero_list = CustomNetTables.GetTableValue("custom_pick", "hero_list");
	var donate_heroes = CustomNetTables.GetTableValue("custom_pick", "donate_heroes")

	var sub_data = CustomNetTables.GetTableValue("sub_data", Players.GetLocalPlayer());

	if (hero_list === undefined)
		return

	var player_list = CustomNetTables.GetTableValue("custom_pick", "player_lobby");
	if (player_list)
	{
		var players_inv = Object.entries(player_list.lobby_players)
		for (const [pid, i] of players_inv) 
		{
			let icon = $.GetContextPanel().FindChildTraverse("player_icon" + pid)
			let base_icon = $.GetContextPanel().FindChildTraverse("player_base_icon" + pid)
			let picked_hero = CustomNetTables.GetTableValue("players_heroes", String(pid));
			if (picked_hero)
			{
				if (icon)
				{
                    icon.RemoveClass("hero_icon_search")
					icon.style.backgroundImage = "url('file://{images}/heroes/" + Game.GetHeroImage(pid, picked_hero.hero) + ".png')"
				}
				if (base_icon)
				{
					base_icon.style.backgroundImage = "url('file://{images}/heroes/" + Game.GetHeroImage(pid, picked_hero.hero) + ".png')"
				}
			}
		}
	}

	let hero_names_sorted = [...Object.keys(hero_list)].sort()
	for (let hero_name of hero_names_sorted) 
	{
		let panel = $.GetContextPanel().FindChildTraverse(hero_name)

		if (!panel)
			continue

		var level_container = $.GetContextPanel().FindChildTraverse("level_container_" + String(hero_name))
		var level_container_text = $.GetContextPanel().FindChildTraverse("level_container_text_" + String(hero_name))
		if (sub_data && sub_data.subscribed == 1 && sub_data.heroes_data[hero_name]  && sub_data.heroes_data[hero_name].has_level == 1)
		{
			level_container.style.visibility = "visible"
			level_container_text.text = String(sub_data.heroes_data[hero_name].level)
			level_container.style.backgroundImage = 'url("s2r://panorama/images/hero_badges/hero_badge_rank_' + String(sub_data.heroes_data[hero_name].tier) + '_tiny_png.vtex")'
		}
        else 
		{
			level_container.style.visibility = "collapse"
		}
		for (var d = 1; d <= Object.keys(donate_heroes).length; d++)  
		{
            if (donate_heroes[d] == hero_name) 
            {
				ShowHero(panel, hero_name)
                panel.AddClass("donate_hero")
                var locked_hero = $.GetContextPanel().FindChildTraverse("herolocker_" + hero_name)
                if (!locked_hero)
                {
                    locked_hero = $.CreatePanel("Panel", panel, "herolocker_" + hero_name)
                    locked_hero.AddClass("locked_hero")
                }

                if (sub_data && sub_data.subscribed == 0)
                {
        	        locked_hero.style.opacity = "1"
					panel.AddClass("donate_hero_locked")
                }
                else 
                {
        	        locked_hero.style.opacity = "0"
        	        panel.RemoveClass("donate_hero_locked")
                }
            }
        }
	}
	const pick_state = CustomNetTables.GetTableValue("custom_pick", "pick_state")
	if (pick_state === undefined || pick_state.in_progress)
	$.Schedule(1, function() 
    {
		check_donate_heroes()
	})
}


function pick_load_heroes() 
{
	let hero_pick_content = $.GetContextPanel().FindChildTraverse("hero_pick_content")
    let lobby_players_list = $.GetContextPanel().FindChildTraverse("lobby_players_list")
	if (!hero_pick_content)
		return

	let lang = $.Localize("#lang")
	let tg_panel = hero_pick_content.FindChildTraverse("tg_panel")
	if (lang != "rus" || true)
	{
	  tg_panel.AddClass("pick_base_players_hidden")
	}else
	{
	  tg_panel.RemoveClass("pick_base_players_hidden")
	  tg_panel.SetPanelEvent("onactivate", function() 
	  {  
	      $.DispatchEvent("ExternalBrowserGoToURL", 'https://t.me/Dota1x6');
	  })
	}
  

	const str_row = $.CreatePanel("Panel", hero_pick_content, "StrengthSelector");
	str_row.BLoadLayoutSnippet('heroes_row')

	const agi_row = $.CreatePanel("Panel", hero_pick_content, "AgilitySelector");
	agi_row.BLoadLayoutSnippet('heroes_row')

	const int_row = $.CreatePanel("Panel", hero_pick_content, "IntellectSelector");
	int_row.BLoadLayoutSnippet('heroes_row')

	const all_row = $.CreatePanel("Panel", hero_pick_content, "AllSelector");
	all_row.BLoadLayoutSnippet('heroes_row')

	$.Schedule(1, function() 
	{
		if (hero_pick_content)
		{
			hero_pick_content.RemoveClass("hero_pick_content_hidden")
			hero_pick_content.AddClass("hero_pick_content_show")
		}
    	if (lobby_players_list)
    	{
    		lobby_players_list.RemoveClass("hero_pick_content_hidden")
    		lobby_players_list.AddClass("lobby_players_list_show")
    	}
	})

	const hero_list = CustomNetTables.GetTableValue("custom_pick", "hero_list");
	if (hero_list === undefined)
		return

	const hero_names_sorted = [...Object.keys(hero_list)].sort()
	for (const current_hero of hero_names_sorted) 
	{
		let hero_name = current_hero

		const attribute = hero_list[hero_name]
		let selector, attribute_name
		switch (attribute) {
			case 0:
				selector = $("#StrengthSelector")
				attribute_name = "str"
				break
			case 1:
				selector = $("#AgilitySelector")
				attribute_name = "agi"
				break
			case 2:
				selector = $("#IntellectSelector")
				attribute_name = "int"
				break
			case 3:
				selector = $("#AllSelector")
				attribute_name = "all"
				break
			default:
				$.Msg(`Unknown attribute ${attribute} on hero ${hero_name}`)
				continue
		}
		var hero_creating = selector.FindChild(hero_name)
		let bane_only = false

		if (false)
		{
			let steam_id = Game.GetPlayerInfo( Players.GetLocalPlayer() ).player_steamid
			if (steam_id == "76561198133050347" || steam_id == 76561198133050347)
			{
				bane_only = true
			}
		}

		if (hero_creating && bane_only == false)
		{
			continue
		}

		var panel = $.CreatePanel("Panel", selector, hero_name)
		panel.AddClass("hero_select_panel")
		let hero_panel_name = hero_name
		if (bane_only == true)
		{
			hero_panel_name = "npc_dota_hero_bane"
		}
		SetPSelectEvent(panel, hero_panel_name, attribute_name)
		var port = $.CreatePanel("DOTAHeroImage", panel, 'hero_portrait', {
			heroname: hero_panel_name,
			heroimagestyle: "portrait",
			scaling: "stretch-to-cover-preserve-aspect"
		})
		var level_container = $.CreatePanel("Panel", port, "level_container_" + String(hero_name))
		level_container.AddClass("level_container")
		var level_container_text = $.CreatePanel("Label", level_container, "level_container_text_" + String(hero_name))
		level_container_text.AddClass("level_container_mini_text")
		var sub_data = CustomNetTables.GetTableValue("sub_data", Players.GetLocalPlayer());
		if (sub_data && sub_data.subscribed == 1 && sub_data.heroes_data[hero_name]  && sub_data.heroes_data[hero_name].has_level == 1)
		{
			level_container.style.visibility = "visible"
			level_container_text.text = String(sub_data.heroes_data[hero_name].level)
			level_container.style.backgroundImage = 'url("s2r://panorama/images/hero_badges/hero_badge_rank_' + String(sub_data.heroes_data[hero_name].tier) + '_tiny_png.vtex")'
		}
		panel.BLoadLayoutSnippet('hero_portrait')
		ShowHero(panel, hero_panel_name)
	}
	check_donate_heroes()
}

function pick_select_base(data) {

	Game.EmitSound("General.ButtonClick");
	var minimap_icon = $.GetContextPanel().FindChildTraverse("base_icon" + String(data.number))
	if (minimap_icon) 
    {
		minimap_icon.style.backgroundImage = 'url( "file://{images}/heroes/icons/' +  Game.GetHeroImage(data.id, String(data.hero)) + '.png" );'
		minimap_icon.style.backgroundSize = 'contain'
	}
}

function reload_pick_bases(data) 
{
	start_base_pick()

	for (var i = 0; i <= Object.keys(data.lobby_players).length - 1; i++) 
	{
		var minimap_icon = $.GetContextPanel().FindChildTraverse("base_icon" + String(data.lobby_players[i].select_base))
		if (minimap_icon) 
		{
			minimap_icon.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + String(data.lobby_players[i].picked_hero) + '.png" );'
			minimap_icon.style.backgroundSize = 'contain'
		}
	}
    let pre_select_base = CustomNetTables.GetTableValue("custom_pick", "pre_select_base");
    if (pre_select_base)
    {
        update_pre_select_base({info : pre_select_base})
    }
}

function reload_pick_heroes(data) 
{

	for (var i = 0; i <= Object.keys(data.lobby_players).length - 1; i++) 
    {
		var icon = $.GetContextPanel().FindChildTraverse(String(data.lobby_players[i].picked_hero))
		if (icon) 
        {
			icon.AddClass("hero_picked")
		}
		var left_hero = $.GetContextPanel().FindChildTraverse("player_icon" + String(i))
		if (left_hero) 
        {
			left_hero.style.backgroundImage = "url('file://{images}/heroes/" + Game.GetHeroImage(i, String(data.lobby_players[i].picked_hero)) + ".png')"
			left_hero.style.backgroundSize = 'contain'
			left_hero.style.backgroundRepeat = 'no-repeat'
		}
	}
}

function pick_select_hero(data) 
{
	var icon = $.GetContextPanel().FindChildTraverse(String(data.hero))
	if (icon)
	{
		icon.AddClass("hero_picked")
	}
	if (Game.GetLocalPlayerID() == data.id) 
	{
		Game.EmitSound("UI.Pick_Hero");
	}
	Game.EmitSound("UI.Pick_" + Game.GetHeroImage(data.id, String(data.hero)));	
	var left_hero = $.GetContextPanel().FindChildTraverse("player_icon" + String(data.id))
	if (left_hero) 
	{
        left_hero.RemoveClass("hero_icon_search")
		left_hero.style.backgroundImage = "url('file://{images}/heroes/" + Game.GetHeroImage(data.id, String(data.hero)) + ".png')"
		left_hero.style.backgroundSize = 'contain'
		left_hero.style.backgroundRepeat = 'no-repeat'
	}
    var left_random = $.GetContextPanel().FindChildTraverse("random_icon_fill" + String(data.id))
    var hero_tier = $.GetContextPanel().FindChildTraverse("hero_tier" + String(data.id))
    var hero_tier_text = $.GetContextPanel().FindChildTraverse("hero_tier_text" + String(data.id))
	var sub_data = CustomNetTables.GetTableValue("sub_data", String(data.id));
	if ((data.id == Game.GetLocalPlayerID())||(data.id == String(Game.GetLocalPlayerID())))
	{
		StartQuestSelection()
	}
    if ((left_random) && (data.random == 1))
    {
        left_random.style.visibility = "visible";
    }
    if ((hero_tier) && (sub_data && sub_data.heroes_data[data.hero] && sub_data.heroes_data[data.hero].has_level == 1) && sub_data.subscribed == 1 && sub_data.hide_tier == 0 ) 
    {
        hero_tier.style.visibility = "visible";
		hero_tier.style.backgroundImage = 'url("file://{images}/custom_game/hero_level_big_' + String(sub_data.heroes_data[data.hero].tier) + '.png");'
    }
    if ((hero_tier_text) && (sub_data && sub_data.heroes_data[data.hero] && sub_data.heroes_data[data.hero].has_level == 1) && sub_data.subscribed == 1 && sub_data.hide_tier == 0 ) 
    {
		hero_tier_text.text = String(sub_data.heroes_data[data.hero].level)
    }
}

function SetPSelectEvent(panel, hero, attribute) 
{
	panel.SetPanelEvent("onactivate", function() 
	{
		var ban_state_table = CustomNetTables.GetTableValue("custom_pick", "ban_stage_check");
		if (ban_state_table) 
		{
			if (ban_state_table.state == true) 
			{
				Game.EmitSound("General.ButtonClick");
				GameEvents.SendCustomGameEventToServer_custom("BanVoteHero", { hero: hero })
			    return
			}
		}
		var active_player = CustomNetTables.GetTableValue("custom_pick", "active_player");
		if (active_player == null) 
		{
			return
		}

		let hero_pick = $.GetContextPanel().FindChildTraverse("hero_pick")
		if (hero_pick.BHasClass("hero_pick_blured"))
		{
			hide_chosen_hero()
			return
		}

		ChangeHeroInfo(hero, attribute);
		var movie = $.GetContextPanel().FindChild('portrait_' + hero + '')
		if (movie) 
        {
			movie.DeleteAsync(0)
		}

		show_chosen_hero(hero)
	});
}

function pick_update_selection_button()
{
    Refresh_Button()
    Refresh_Random_Button()
}

function Refresh_Button() {

	var ChoseHero = $.GetContextPanel().FindChildTraverse("ChoseHero")
	var DonateButton = $.GetContextPanel().FindChildTraverse("DonateButton")

	var hero_list = CustomNetTables.GetTableValue("custom_pick", "player_list");

	ChoseHero.RemoveClass("ChoseHero_visible")
	ChoseHero.RemoveClass("ChoseHero_picked")
	DonateButton.RemoveClass("DonateButton_Visible")
	ChoseHero.AddClass("ChoseHero")

	let show = false
    let data = CustomNetTables.GetTableValue("server_data", String(Players.GetLocalPlayer()));
    let lang = $.Localize("#lang")

    if ((data && data.total_games && data.total_games >= max_games) || lang == "rus")
	{
		show = true
	}

	var active_player = CustomNetTables.GetTableValue("custom_pick", "active_player");
	var server_data = CustomNetTables.GetTableValue("server_data", Game.GetLocalPlayerID().toString());
	var sub_data = CustomNetTables.GetTableValue("sub_data", String(Players.GetLocalPlayer()));

	if ((server_data) && (server_data.lp_games_remaining > 0)) 
    {
		return
	}

	if (active_player.id !== Game.GetLocalPlayerID() && active_player.current_team !== Players.GetTeam( Players.GetLocalPlayer() )) 
    {   
		return
	}

    var player_list = CustomNetTables.GetTableValue("custom_pick", "player_lobby");
	if ((player_list.lobby_players[Game.GetLocalPlayerID()] && player_list.lobby_players[Game.GetLocalPlayerID()].picked_hero != null ))
	{
        return
    }

	var donate_heroes = CustomNetTables.GetTableValue("custom_pick", "donate_heroes")

	for (var d = 1; d <= Object.keys(donate_heroes).length; d++)  
	{
        if (donate_heroes[d] == hero_selected && (sub_data && sub_data.subscribed == 0)) 
        {
			if (show == true)
			{
				DonateButton.style.opacity = "1";
				DonateButton.RemoveClass("DonateButton_not")
				DonateButton.AddClass("DonateButton")
      	        let text = $.Localize("#Donate_hero_info")
				DonateButton.SetPanelEvent('onmouseover', function() {
					$.DispatchEvent('DOTAShowTextTooltip', DonateButton, text)
				});
				DonateButton.SetPanelEvent('onmouseout', function() {
					$.DispatchEvent('DOTAHideTextTooltip', DonateButton);
				});
				DonateButton.SetPanelEvent("onactivate", function() {
					GameEvents.SendCustomGameEventToServer_custom( "browser_subscribe", {item_name: "sub"});	
				});
			}
            else 
			{
				DonateButton.style.opacity = "0";
				DonateButton.RemoveClass("DonateButton")
				DonateButton.AddClass("DonateButton_not")
				DonateButton.SetPanelEvent('onmouseover', function() {});
				DonateButton.SetPanelEvent('onmouseout', function() {});
				DonateButton.SetPanelEvent("onactivate", function() {});
			}
    	    DonateButton.AddClass("DonateButton_Visible")
            return
        }
    }

	if (hero_list) 
	{
		for (var i = 1; i <= hero_list.picked_heroes_length; i++) {
			if (hero_list.picked_heroes[i] == hero_selected) {
				ChoseHero.RemoveClass("ChoseHero")
				ChoseHero.AddClass("ChoseHero_picked")
				ChoseHero.SetPanelEvent("onactivate", function() {});
			}
		}
	}

	if (ChoseHero.BHasClass("ChoseHero")) 
    {
		ChoseHero.RemoveClass("ChoseHero")
		ChoseHero.AddClass("ChoseHero_visible")
		ChoseHero.SetPanelEvent("onactivate", function() 
        {
			GameEvents.SendCustomGameEventToServer_custom("chose_hero", {hero: hero_selected});
            if (!IS_DUO_MODE)
            {
                var timer = $.GetContextPanel().FindChildTraverse("pick_timer")
                if (timer) 
                {
                    timer.DeleteAsync(0)
                }
            }
		});
	}
}

function DotaChangesHero(hero) 
{
	current_tab = 3
	DeleteEyes()

	var button_video = $.GetContextPanel().FindChildTraverse("Button_Video")
	var button_stats = $.GetContextPanel().FindChildTraverse("Button_Stats")
	var button_changelog = $.GetContextPanel().FindChildTraverse("Button_ChangeLog")

	button_video.RemoveClass("button_active")
	button_changelog.RemoveClass("button_not_active")
	button_stats.RemoveClass("button_active")

	button_stats.AddClass("button_not_active")
	button_changelog.AddClass("button_active")
	button_video.AddClass("button_not_active")

	var ChangeLog = $.GetContextPanel().FindChildTraverse("ChangeLog")
	var text_space = $.GetContextPanel().FindChildTraverse("Chosen_hero_space")
	if (text_space) 
    {
		text_space.DeleteAsync(0)
	}

	text_space = $.CreatePanel("Panel", ChangeLog, "Chosen_hero_space")
	text_space.AddClass("Chosen_hero_space")
	text_space.AddClass("Chosen_hero_space_changelog")

	let general_table = 
    [
		"innate",
		"scepter",
		"Scepter",
		"Shard",
		"shard",
		"movespeed",
		"Movespeed",
		"armor",
	]

	const all_hero_changes = CustomNetTables.GetTableValue("custom_pick", "hero_changes")
	if (all_hero_changes !== undefined) {
		const hero_changes = all_hero_changes[hero]
		if (hero_changes !== undefined) 
		{
			var hero_change = $.CreatePanel("Panel", text_space, "hero_change")
			hero_change.AddClass("Change_with_border")

			var hero_Changes_icons = $.CreatePanel("Panel", hero_change, "hero_change_icons")
			hero_Changes_icons.AddClass("hero_change_icon")
			hero_Changes_icons.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + hero + '.png" );'
			hero_Changes_icons.style.backgroundSize = '100%';

			var hero_Changes_text = $.CreatePanel("Label", hero_change, "hero_change_text")
			hero_Changes_text.AddClass("hero_changes_text")
			hero_Changes_text.text = $.Localize('#' + hero) + ":"

			let i = 0
			for (const change of Object.values(hero_changes)) {
				i++
				const Changes = $.CreatePanel("Panel", text_space, "Changes" + i)
				Changes.AddClass("Change")

				const Changes_icons = $.CreatePanel("Panel", Changes, "Changes_icons" + i)
				let path = '"file://{images}/custom_game/icons/mini/' + hero + '/'

				for (const general_icon of Object.values(general_table))
				{
					if (general_icon == change)
					{
						path = '"file://{images}/custom_game/icons/mini/general_changes/'
						break
					}
				}

				Changes_icons.style.backgroundImage = 'url(' + path + change + '.png")';
				if (change == "innate")
				{
					Changes_icons.AddClass("changes_icon_no_border")
					Changes_icons.style.backgroundSize = '90%';	
				}else 
				{
					Changes_icons.AddClass("changes_icon")
					Changes_icons.style.backgroundSize = '100%';
				}

				const Changes_text_array = $.CreatePanel("Label", Changes, "text" + i)
				Changes_text_array.html = true
				Changes_text_array.AddClass("changes_text")
				Changes_text_array.text = $.Localize('#hero_change_' + hero + '_' + i)
			}
		}
	}


 	if (true) return

	var general_changes_main = $.CreatePanel("Label", text_space, "ChangeLog_text")
	general_changes_main.AddClass("Change_with_border")

	var general_changes = $.CreatePanel("Label", general_changes_main, "ChangeLog_text")
	general_changes.AddClass("general_changes")
	general_changes.text = $.Localize('#general_dota_changes')

	var max_changes = $.Localize('#general_dota_changes_number')
	max_changes = parseInt(max_changes)

	var max_changes_neutrals = $.Localize('#general_dota_changes_neutrals_number')
	max_changes_neutrals = parseInt(max_changes_neutrals)

	var General_Changes = []
	var General_Changes_text_array = []
	var General_Changes_icons = []




	for (var i = 0; i <= max_changes; i++) {
		General_Changes[i] = $.CreatePanel("Panel", text_space, "General_Changes" + i)
		General_Changes[i].AddClass("Change")

		General_Changes_icons[i] = []

		var number = Number($.Localize("#general_change_number_" + i))

		for (var j = 1; j <= number; j++)

		{


			General_Changes_icons[i][j] = $.CreatePanel("DOTAItemImage",General_Changes[i],"")//$.CreatePanel("Panel", General_Changes[i], "General_Changes_icons_" + i + '_' + j)
			General_Changes_icons[i][j].AddClass("changes_icon_general")
			General_Changes_icons[i][j].itemname = "item_" + $.Localize('#general_change_icon_' + i + '_' + j)

			//General_Changes_icons[i][j].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + $.Localize('#general_change_icon_' + i + '_' + j) + '.png")';
			//General_Changes_icons[i][j].style.backgroundSize = '100%';
		}


		General_Changes_text_array[i] = $.CreatePanel("Label", General_Changes[i], "General_text" + i)
		General_Changes_text_array[i].html = true
		General_Changes_text_array[i].AddClass("changes_text")
		General_Changes_text_array[i].text = $.Localize('#general_change_' + i)

	}


	var General_Changes_Neutrals = []
	var General_Changes_Neutrals_text_array = []
	var General_Changes_Neutrals_icons = []



	for (var i = 0; i <= max_changes_neutrals; i++) {
		General_Changes_Neutrals[i] = $.CreatePanel("Panel", text_space, "General_Changes_Neutrals" + i)
		General_Changes_Neutrals[i].AddClass("Change")

		General_Changes_Neutrals_icons[i] = []

		var number = Number($.Localize("#general_change_neutrals_number_" + i))

		for (var j = 1; j <= number; j++)

		{


			General_Changes_Neutrals_icons[i][j] = $.CreatePanel("DOTAItemImage",General_Changes_Neutrals[i],"")//$.CreatePanel("Panel", General_Changes[i], "General_Changes_icons_" + i + '_' + j)
			General_Changes_Neutrals_icons[i][j].AddClass("changes_icon_general")
			General_Changes_Neutrals_icons[i][j].itemname = "item_" + $.Localize('#general_change_neutrals_icon_' + i + '_' + j)

			//General_Changes_icons[i][j].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + $.Localize('#general_change_icon_' + i + '_' + j) + '.png")';
			//General_Changes_icons[i][j].style.backgroundSize = '100%';
		}


		General_Changes_Neutrals_text_array[i] = $.CreatePanel("Label", General_Changes_Neutrals[i], "General_text" + i)
		General_Changes_Neutrals_text_array[i].html = true
		General_Changes_Neutrals_text_array[i].AddClass("changes_text")
		General_Changes_Neutrals_text_array[i].text = $.Localize('#general_change_neutrals_' + i)

	}

}

function roundPlus(x, n) 
{ 
    //x - число, n - количество знаков
	if (isNaN(x) || isNaN(n)) return false;
	var m = Math.pow(10, n);
	return Math.round(x * m) / m;
}

function StatsHero(hero) 
{
	current_tab = 2
	DeleteEyes()
	var button_video = $.GetContextPanel().FindChildTraverse("Button_Video")
	var button_stats = $.GetContextPanel().FindChildTraverse("Button_Stats")
	var button_changelog = $.GetContextPanel().FindChildTraverse("Button_ChangeLog")

	button_video.RemoveClass("button_active")
	button_changelog.RemoveClass("button_active")
	button_stats.RemoveClass("button_not_active")

	button_stats.AddClass("button_active")
	button_changelog.AddClass("button_not_active")
	button_video.AddClass("button_not_active")

	var ChangeLog = $.GetContextPanel().FindChildTraverse("ChangeLog")
	var text_space = $.GetContextPanel().FindChildTraverse("Chosen_hero_space")
	if (text_space) 
    {
		text_space.DeleteAsync(0)
	}

	text_space = $.CreatePanel("Panel", ChangeLog, "Chosen_hero_space")
	text_space.AddClass("Chosen_hero_space")
	text_space.AddClass("Chosen_hero_space_stats")

	var stats_left = $.CreatePanel("Panel", text_space, "stats_left")
	var stats_right = $.CreatePanel("Panel", text_space, "stats_right")
	stats_left.AddClass("stats_left")
	stats_right.AddClass("stats_right")

	var stats_left_text_block = $.CreatePanel("Panel", stats_left, "stats_left_text_block")
	stats_left_text_block.AddClass("stats_left_text_block")

	var stats_left_text_text = $.CreatePanel("Label", stats_left_text_block, "stats_left_text_text")
	stats_left_text_text.AddClass("stats_left_text_text")
	stats_left_text_text.text = $.Localize("#places_stats")

	var stats_left_places_block = $.CreatePanel("Panel", stats_left, "stats_left_places_block")
	stats_left_places_block.AddClass("stats_left_places_block")


	var stats_right_text_block = $.CreatePanel("Panel", stats_right, "stats_right_text_block")
	stats_right_text_block.AddClass("stats_right_text_block")

	var stats_right_text_text = $.CreatePanel("Label", stats_right_text_block, "stats_right_text_text")
	stats_right_text_text.AddClass("stats_right_text_text")
	stats_right_text_text.text = $.Localize("#general_stats")

	var table = Game.GetLocalPlayerID().toString() + '_' + hero
	var hero_data = CustomNetTables.GetTableValue("server_hero_stats", table);
	var stats_player_places = [0, 0, 0, 0, 0, 0]
	var total_games = 0
	var rating = 0
	var kills = 0
	var death = 0

	if (hero_data !== undefined) 
    {
		stats_player_places = hero_data.places
		rating = hero_data.rating
		kills = hero_data.kills
		death = hero_data.deaths
	}

	var max = 0
	var avg_place = 0
	var score = 0

	for (var i = 0; i < 6; i++) 
    {
		if (stats_player_places[i] >= max) 
        {
			max = stats_player_places[i]
		}
		total_games = total_games + stats_player_places[i]
		score = stats_player_places[i] * (i + 1) + score
	}

	if (total_games > 0) 
    {
		avg_place = score / total_games
		if (kills > 0) 
        {
			kills = (kills / total_games)
			if (kills % 1 !== 0) 
            {
				kills = kills
			}
		}
		if (death > 0) 
        {
			death = (death / total_games)
			if (death % 1 !== 0) 
            {
				death = death
			}
		}
	}

	var kd = 0
	if (death !== 0) 
    {
		kd = kills / death
	} 
    else
    {
		kd = kills
	}

	kd = roundPlus(kd, 1)
	kills = roundPlus(kills, 1)
	death = roundPlus(death, 1)
	avg_place = roundPlus(avg_place, 1)

	var stats_right_text_block_general_2 = $.CreatePanel("Panel", stats_right, "stats_right_text_block_general2")
	stats_right_text_block_general_2.AddClass("stats_right_text_block_genral")

	var stats_right_text_text_2 = $.CreatePanel("Label", stats_right_text_block_general_2, "stats_right_text_text2")
	stats_right_text_text_2.AddClass("stats_right_text_text")
	stats_right_text_text_2.text = $.Localize("#Avg_place") + ' ' + String(avg_place)
	stats_right_text_text_2.AddClass("stats_text_color_" + String(Math.trunc(avg_place)))

	var stats_right_text_block_general_1 = $.CreatePanel("Panel", stats_right, "stats_right_text_block_general1")
	stats_right_text_block_general_1.AddClass("stats_right_text_block_genral")

	var stats_right_text_text_1 = $.CreatePanel("Label", stats_right_text_block_general_1, "stats_right_text_text1")
	stats_right_text_text_1.AddClass("stats_right_text_text")
	stats_right_text_text_1.text = $.Localize("#Total_games") + ' ' + String(total_games)

	var stats_right_text_block_general_3 = $.CreatePanel("Panel", stats_right, "stats_right_text_block_general3")
	stats_right_text_block_general_3.AddClass("stats_right_text_block_genral")

	var stats_right_text_text_3 = $.CreatePanel("Label", stats_right_text_block_general_3, "stats_right_text_text3")
	stats_right_text_text_3.AddClass("stats_right_text_text")
	stats_right_text_text_3.text = $.Localize("#k_d") + ' ' + String(kills) + '/' + String(death) + ' (' + String(kd) + ')'

	var stats_right_text_block_general_4 = $.CreatePanel("Panel", stats_right, "stats_right_text_block_general4")
	stats_right_text_block_general_4.AddClass("stats_right_text_block_genral")

	var stats_right_text_text_4 = $.CreatePanel("Label", stats_right_text_block_general_4, "stats_right_text_text4")
	stats_right_text_text_4.AddClass("stats_right_text_text")

	if (rating >= 0) 
    {
		stats_right_text_text_4.AddClass("stats_text_color_rating_0")
		stats_right_text_text_4.text = $.Localize("#rating") + ' +' + String(Math.abs(rating))
	} 
    else 
    {
		stats_right_text_text_4.AddClass("stats_text_color_rating_1")
		stats_right_text_text_4.text = $.Localize("#rating") + ' -' + String(Math.abs(rating))
	}

	var places = []
	var places_game = []
	var places_text_block = []
	var places_text = []
	var places_game_text = []
	var number = 0
	var text = ''

	for (var i = 1; i <= 6; i++) 
    {
		places[i] = $.CreatePanel("Panel", stats_left_places_block, "place" + i)
		places[i].AddClass("stats_left_place")

		places_text_block[i] = $.CreatePanel("Panel", places[i], "place_text_block" + i)
		places_text_block[i].AddClass("stats_left_text_block")

		places_text[i] = $.CreatePanel("Label", places_text_block[i], "place_text" + i)
		places_text[i].AddClass("stats_left_place_text")
		places_text[i].text = String(i)

		places_game[i] = $.CreatePanel("Panel", places[i], "place_game" + i)
		places_game[i].AddClass("stats_left_place_all")
		places_game[i].AddClass("stats_left_place_" + i)

		if (total_games > 0) 
        {
			number = (stats_player_places[i - 1] / max) * 80
		}

		number = number + 0.01
		text = String(number) + '%'
		places_game[i].style.height = text

		places_game_text[i] = $.CreatePanel("Label", places_game[i], "place_game_text" + i)
		places_game_text[i].AddClass("stats_left_game_text")
		places_game_text[i].text = String(stats_player_places[i - 1])
	}
}

function VideoHero(hero) 
{
	current_tab = 1
	ShowVideo(null, hero)
	var button_video = $.GetContextPanel().FindChildTraverse("Button_Video")
	var button_stats = $.GetContextPanel().FindChildTraverse("Button_Stats")
	var button_changelog = $.GetContextPanel().FindChildTraverse("Button_ChangeLog")

	button_video.RemoveClass("button_not_active")
	button_changelog.RemoveClass("button_active")
	button_stats.RemoveClass("button_active")

	button_stats.AddClass("button_not_active")
	button_changelog.AddClass("button_not_active")
	button_video.AddClass("button_active")

	var orange_card = null
	var purple_card = null
	var blue_card = null
	var o_count = 1
	var p_count = 1
	var b_count = 1

	let i = 0
    DeleteEyes()

    let use_new_system = false
    if (Game.new_talent_system[hero])
        use_new_system = true

    let talent_table = Game.talents_values[hero]
    Object.entries(talent_table).map(([key, data]) => (data["name"] = key, data["name_number"] = key[Object.keys(key).length - 1], data))

    talent_table = Object.values(talent_table)
    talent_table.sort((a, b) => (a["skill_number"] - b["skill_number"]))

    var skills_array = {}

    for (const index in talent_table)
    {
        let number = talent_table[index]["skill_number"]
        let name_number = talent_table[index]["name_number"]

        if (name_number == "y") name_number = "7"
        if (!skills_array[number]) skills_array[number] = []   

        talent_table[index]["name_number"] = Number(name_number)

        skills_array[number].push(talent_table[index])
    }

    for (const skill in skills_array)
    {
        skills_array[skill].sort((a, b) => (a["name_number"] - b["name_number"]))

        let purple_count = 0
        let blue_count = 0

        for (const data of skills_array[skill])
        {
            let rarity = data["rarity"]
            let name = data["name"]
            let has_video = data["has_video"]
            let skill_number = data["skill_number"]
            i++

            if (rarity == "orange") 
            {
                if (use_new_system == true)
                {
                    orange_card = $.GetContextPanel().FindChildTraverse("LayerHeroTalents_Skill_" + skill_number).FindChildTraverse("talent_orange_card")
                }else
                {
                    orange_card = $.GetContextPanel().FindChildTraverse("orange_card_" + [o_count])
                }

                if ((orange_card) && (has_video == 1)) 
                {
                    let eye = $.CreatePanel("Panel", orange_card, "eye" + i)
                    eye.AddClass("Talent_card_eye_orange")
                    SetVideo(orange_card, name, hero)
                }
                o_count++
            }

            if (rarity == "purple") 
            {

                if (use_new_system == true)
                {   
                    purple_count = purple_count + 1
                    purple_card = $.GetContextPanel().FindChildTraverse("LayerHeroTalents_Skill_" + skill_number).FindChildTraverse("talent_purple_card_" + purple_count)
                }else
                {
                    purple_card = $.GetContextPanel().FindChildTraverse("purple_card_" + [p_count])
                }

                if ((purple_card) && (has_video == 1)) 
                {
                    let eye = $.CreatePanel("Panel", purple_card, "eye" + i)
                    eye.AddClass("Talent_card_eye")
                    SetVideo(purple_card, name, hero)
                }
                p_count++

            }
            if (rarity == "blue") 
            {
                if (use_new_system == true)
                {
                    blue_count = blue_count + 1
                    blue_card = $.GetContextPanel().FindChildTraverse("LayerHeroTalents_Skill_" + skill_number).FindChildTraverse("talent_blue_card_" + blue_count)
                }else
                {
                    blue_card = $.GetContextPanel().FindChildTraverse("blue_card_" + [b_count])
                }

                if ((blue_card) && (has_video == 1)) {
                    let eye = $.CreatePanel("Panel", blue_card, "eye" + i)
                    eye.AddClass("Talent_card_eye")
                    SetVideo(blue_card, name, hero)
                }
                b_count++
            }
        }
    }


}

function SetVideo(button, name, hero) 
{
	button.SetPanelEvent("onactivate", function() 
    {
		ShowVideo(name, hero)
	});
}

function ShowVideo(name, hero) 
{

	if (name == null)
    {
        for (const find_name in Game.talents_values[hero]) 
        {
            let find_table = Game.talents_values[hero][find_name]
            let has_video = find_table["has_video"]
            name = find_name
            if (has_video == 1)
                break
        }
    }

    let table = Game.talents_values[hero][name]

	if (table == null)
		return

    let rarity = table["rarity"]
    let icon_mini = table["mini_icon"]
    let skill_number = table["skill_number"]
    let max_level = Game.GetMaxLevel(table)

	var ChangeLog = $.GetContextPanel().FindChildTraverse("ChangeLog")
	var text_space = $.GetContextPanel().FindChildTraverse("Chosen_hero_space")
	if (text_space) 
    {
		text_space.DeleteAsync(0)
	}

	text_space = $.CreatePanel("Panel", ChangeLog, "Chosen_hero_space")
	text_space.AddClass("Chosen_hero_space")
	text_space.AddClass("Chosen_hero_space_video")

	let movieSrc = `file://{resources}/videos/custom_game/heroes/${hero}/${name}.webm`;
	
	$.CreatePanel("MoviePanel", text_space, "Movie", 
    {
		src: movieSrc,
		volume: "0",
		repeat: "true",
		muted: "muted",
		autoplay: "onload"
	});

	Game.EmitSound("General.ButtonClick");

	var right_panel = $.CreatePanel("Panel", text_space, "right_panel")
	right_panel.AddClass("video_right")

	var skill_icon = $.CreatePanel("Panel", right_panel, "skill_icon")
	skill_icon.AddClass("video_right_icon")
	skill_icon.AddClass("icon_" + rarity)


	skill_icon.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + icon_mini + '.png")';
	skill_icon.style.backgroundSize = "100%";

	var video_text_1 = $.CreatePanel("Panel", right_panel, "video_text_1")
	video_text_1.AddClass("video_text_label")

	var video_text_text_1 = $.CreatePanel("Label", video_text_1, "video_text_text_1")
	video_text_text_1.AddClass("video_text")
	video_text_text_1.text = $.Localize("#Skill_rare")


	var video_text_rarity = $.CreatePanel("Label", right_panel, "video_text_rarity")
	video_text_rarity.AddClass("video_text")
	video_text_rarity.AddClass("text_" + rarity)
	video_text_rarity.text = $.Localize('#' + rarity)

	var video_text_2 = $.CreatePanel("Panel", right_panel, "video_text_2")
	video_text_2.AddClass("video_text_label")

	var video_text_text_2 = $.CreatePanel("Label", video_text_2, "video_text_text_2")
	video_text_text_2.AddClass("video_text")
	var level = 1
	if (max_level > 1)
		level = max_level

	video_text_text_2.text = $.Localize("#Skill_max_level") + String(level)

	var video_text_3 = $.CreatePanel("Panel", right_panel, "video_text_3")
	video_text_3.AddClass("video_text_label")

	if (rarity != "orange" && skill_number != 0) 
    {
		var video_text_3 = $.CreatePanel("Panel", right_panel, "video_text_3")
		video_text_3.AddClass("video_text_label")

		var video_text_text_3 = $.CreatePanel("Label", video_text_3, "video_text_text_3")
		video_text_text_3.AddClass("video_text")
		video_text_text_3.text = $.Localize("#skill_text")

		skill_icon = $.CreatePanel("Panel", right_panel, "skill_icon_skill")
		skill_icon.AddClass("video_right_icon_mini")

        let icon_name

        for (const find_name in Game.talents_values[hero]) 
        {
            let table = Game.talents_values[hero][find_name]
            if (table["rarity"] == "orange" && table["skill_number"] == skill_number)
            {
                icon_name = table["skill_icon"]
                break
            }
        }
        if (icon_name)
        {
    		skill_icon.style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + icon_name + '.png")';
    		skill_icon.style.backgroundSize = "contain";
        }
	}
}

function ChangeHeroInfo(hero_name, attribute) 
{
	var active_player = CustomNetTables.GetTableValue("custom_pick", "active_player");
	if (active_player == null) 
	{
		return
	}

	player_icon = $.GetContextPanel().FindChildTraverse("player_icon" + Game.GetLocalPlayerID())

	if (player_icon)
	{
	//	player_icon.style.backgroundImage = "url('file://{images}/heroes/" + hero_name + ".png')"	
	//	player_icon.style.backgroundSize = 'contain'
	//	player_icon.AddClass("hero_icon_search")
	}
	
    let main_panel = $.GetContextPanel().FindChildTraverse("LayerGeneralPick")
    let parent = main_panel.GetParent()

    let use_new_system = false
    if (Game.new_talent_system[hero_name])
        use_new_system = true

    if (use_new_system)
    {
        parent.RemoveClass("hero_chosen")
        parent.AddClass("hero_chosen_HeroTalent")

        main_panel.RemoveClass("LayerGeneralPick")
        main_panel.AddClass("LayerGeneralPick_HeroTalent")
    }else
    {
        parent.AddClass("hero_chosen")
        parent.RemoveClass("hero_chosen_HeroTalent")
        
        main_panel.AddClass("LayerGeneralPick")
        main_panel.RemoveClass("LayerGeneralPick_HeroTalent")
    }

    let LayerGeneral = main_panel.FindChildTraverse("LayerGeneral")

    if (!LayerGeneral)
    {
        let talents_panel = $.CreatePanel("Panel", main_panel, "talents_panel")
        talents_panel.BLoadLayout( "file://{resources}/layout/custom_game/talents_panel/talents_panel.xml", false, false );
        LayerGeneral = main_panel.FindChildTraverse("LayerGeneral")
    }

    Game.init_talent_panel(LayerGeneral, hero_name, true)
	Game.EmitSound("UI.Click_Hero")


	if ((current_tab == 1) || (current_tab == 0)) 
    {
		VideoHero(hero_name)
	} 
    else 
    {
		if (current_tab == 2) 
        {
			StatsHero(hero_name)
		} 
        else 
        {
			if (current_tab == 3) 
            {
				DotaChangesHero(hero_name)
			}
		}
	}

	var ChangeLog = $.GetContextPanel().FindChildTraverse("ChangeLog")
	if (ChangeLog.BHasClass("ChangeLog")) {
		ChangeLog.RemoveClass("ChangeLog")
		ChangeLog.AddClass("ChangeLog_visible")
	}

	hero_selected = hero_name

	InitHeroQuests()

	var picked_hero = CustomNetTables.GetTableValue("players_heroes", String(Game.GetLocalPlayerID()));

	if (picked_hero == null)
	{
		ChangeQuestsInfo(hero_name)
	}

	var button_video = $.GetContextPanel().FindChildTraverse("Button_Video")
	var button_stats = $.GetContextPanel().FindChildTraverse("Button_Stats")
	var button_changelog = $.GetContextPanel().FindChildTraverse("Button_ChangeLog")
	var button_video_text = $.GetContextPanel().FindChildTraverse("Text_button_Video")
	var button_stats_text = $.GetContextPanel().FindChildTraverse("Text_button_stats")
	var button_changelog_text = $.GetContextPanel().FindChildTraverse("Text_button_changelog")

	button_video_text.text = $.Localize("#button_video")
	button_stats_text.text = $.Localize("#button_stats")
	button_changelog_text.text = $.Localize("#button_changelog")

	button_changelog.SetPanelEvent("onactivate", function() {
		DotaChangesHero(hero_name)
		Game.EmitSound("General.ButtonClick");
	});
	button_stats.SetPanelEvent("onactivate", function() {
		StatsHero(hero_name)
		Game.EmitSound("General.ButtonClick");
	});
	button_video.SetPanelEvent("onactivate", function() {
		VideoHero(hero_name)
		Game.EmitSound("General.ButtonClick");
	});

	var button_text = $.GetContextPanel().FindChildTraverse("ButtonText_Hero")
	button_text.text = $.Localize('#' + hero_name)

	var button_icon = $.GetContextPanel().FindChildTraverse("Button_HeroPortrait") 
	button_icon.style.backgroundImage = "url('file://{images}/heroes/" + Game.GetHeroImage(Game.GetLocalPlayerID(), hero_name) + ".png')"
    button_icon.style.backgroundSize = '100%';

	var mini_icon = $.GetContextPanel().FindChildTraverse("MiniIcon")
	mini_icon.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + hero_name + '.png" );'
	mini_icon.style.backgroundSize = '100%';

	var InfoText = $.GetContextPanel().FindChildTraverse("InfoText")
	InfoText.text = $.Localize('#' + hero_name)

	var HeroInfo = $.GetContextPanel().FindChildTraverse("HeroInfo")

	HeroInfo.RemoveClass("HeroInfo_str")
	HeroInfo.RemoveClass("HeroInfo_int")
	HeroInfo.RemoveClass("HeroInfo_agi")
	HeroInfo.RemoveClass("HeroInfo_all")

	if (attribute == "agi") {
		HeroInfo.AddClass("HeroInfo_agi")
	}
	if (attribute == "str") {
		HeroInfo.AddClass("HeroInfo_str")
	}
	if (attribute == "int") {
		HeroInfo.AddClass("HeroInfo_int")
	}

	if (attribute == "all") {
		HeroInfo.AddClass("HeroInfo_all")
	}
	Refresh_Button()
}


function DeleteEyes() 
{
	for (var i = 0; i <= 30; i++) 
    {
		let eye = $.GetContextPanel().FindChildTraverse("eye" + i)
		if (eye) 
			eye.DeleteAsync(0)

		let orange = $.GetContextPanel().FindChildTraverse("orange_card_" + i)
        if (orange)
            orange.SetPanelEvent("onactivate", function() {});

        let purple = $.GetContextPanel().FindChildTraverse("purple_card_" + i)
        if (purple)
            purple.SetPanelEvent("onactivate", function() {});

        let blue = $.GetContextPanel().FindChildTraverse("blue_card_" + i)
        if (blue)
            blue.SetPanelEvent("onactivate", function() {});
	}

    for (var i = 0; i <= 4; i++) 
    {
        let skill_panel = $.GetContextPanel().FindChildTraverse("LayerHeroTalents_Skill_" + i)
        if (skill_panel) 
        {
            let max = i == 0 ? 4 : 2
            let orange_panel = skill_panel.FindChildTraverse("talent_orange_card")
            if (orange_panel)
                orange_panel.SetPanelEvent("onactivate", function() {});
            for (var j = 1; j <= max; j++)
            {
                let purple_panel = skill_panel.FindChildTraverse("talent_purple_card_" + j)
                let blue_panel = skill_panel.FindChildTraverse("talent_purple_card_" + j)

                if (purple_panel)
                    purple_panel.SetPanelEvent("onactivate", function() {});

                if (blue_panel)
                    blue_panel.SetPanelEvent("onactivate", function() {});
            } 
        }
    }
}

function MouseOver(panel, text) 
{
	panel.SetPanelEvent('onmouseover', function() {
		$.DispatchEvent('DOTAShowTextTooltip', panel, text)
	});
	panel.SetPanelEvent('onmouseout', function() {
		$.DispatchEvent('DOTAHideTextTooltip', panel);
	});
}

function MouseOverTalent(panel, talent_text, name, lvl, all_levels, legendary) 
{
    panel.SetPanelEvent('onmouseover', function() 
    {
        let text = Game.ShowTalentValues(talent_text, name, lvl, all_levels, legendary)

        $.DispatchEvent('DOTAShowTextTooltip', panel, text)
    });
    panel.SetPanelEvent('onmouseout', function() 
    {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });
}



function clear_ban_hero(data)
{
	let hero_name = data.hero

	let hero_panel = $.GetContextPanel().FindChildTraverse(String(hero_name))
	if (hero_panel) 
	{
		hero_panel.RemoveClass("HeroBanned")
	}
}

function ban_hero_vote(data) {
	let hero_name = data.hero
	let votes = data.votes



	let hero_panel = $.GetContextPanel().FindChildTraverse(String(hero_name))
	if (hero_panel) {
		hero_panel.AddClass("HeroBanned")
		//let has_banned_panel = hero_panel.FindChildTraverse("BanPanel")
		//if (has_banned_panel) {
		//	let label_ban_votes = has_banned_panel.FindChildTraverse("BanPanelLabel")
		//	if (label_ban_votes) {
		//		label_ban_votes.text = "VOTE"
		//	}
		//} else {
			//let BanPanel = $.CreatePanel("Panel", hero_panel, "BanPanel")
		//	BanPanel.AddClass("ban_panel")
		//	let BanPanelLabel = $.CreatePanel("Label", BanPanel, "BanPanelLabel")
		//	BanPanelLabel.AddClass("ban_panel_label")
		//	BanPanelLabel.text = "VOTE"
		//}
	}
}

function ban_hero(data) 
{
	let hero_name = data.hero
	let votes_heroes_table = data.table_votes

    if (!data.no_sound)
	   Game.EmitSound("UI.Ban_" + String(hero_name));

	if (votes_heroes_table) {
		for (var i = 1; i <= Object.keys(votes_heroes_table).length; i++) {
			
			let hero_panel_check = $.GetContextPanel().FindChildTraverse(String(votes_heroes_table[i].name))
			if (hero_panel_check) {
				hero_panel_check.RemoveClass("HeroBanned")
			}
		}
	}

	let hero_panel = $.GetContextPanel().FindChildTraverse(String(hero_name))
	if (hero_panel) {
		let portrait = hero_panel.FindChildTraverse("hero_portrait")
		if (portrait) {
			var hero_avatar_blocked = $.CreatePanel("Panel", portrait, "hero_avatar_blocked");
			hero_avatar_blocked.AddClass("banned_portrait");
			portrait.AddClass('HeroBanned');
			hero_panel.SetPanelEvent("onactivate", function() {});
			hero_panel.SetPanelEvent("onmouseover", function() {});
		}
	}
}

function StartBanStage(data) {
	var BanStagePanel = $.GetContextPanel().FindChildTraverse("BanStagePanel")
	BanStagePanel.RemoveClass("BanStagePanel_hidden")
	BanStagePanel.AddClass("BanStagePanel_visible")

	Game.EmitSound("UI.Start_Ban")

	var BanStagePanel_text = $.GetContextPanel().FindChildTraverse("BanStagePanel_text")
	BanStagePanel_text.text = $.Localize('#PICK_STATE_PICK_BANNED')

	var BanStagePanel_timer = $.GetContextPanel().FindChildTraverse("BanStagePanel_timer")
	BanStagePanel_timer.text = data.time


	let no_ban_hero = data.no_ban_hero
	if (no_ban_hero) {
		for (var i = 1; i <= Object.keys(no_ban_hero).length; i++) {
			let no_ban_hero_panel = $.GetContextPanel().FindChildTraverse(String(no_ban_hero[i]))
			if (no_ban_hero_panel) {
				no_ban_hero_panel.AddClass("no_ban_hero")
				no_ban_hero_panel.SetPanelEvent("onmouseover", function() {});
			}
		}
	}
}

function TimeBanStage(data) {
	var BanStagePanel_timer = $.GetContextPanel().FindChildTraverse("BanStagePanel_timer")
	BanStagePanel_timer.text = data.time

	var avg_rating = CustomNetTables.GetTableValue("custom_pick", "avg_rating");


	if (avg_rating) {
		var lobby_rating = $.GetContextPanel().FindChildTraverse("lobby_rating_text")
		lobby_rating.text = $.Localize("#avg_rating") + avg_rating.avg_rating
	}


	let no_ban_hero = data.no_ban_hero
	if (no_ban_hero) {
		for (var i = 1; i <= Object.keys(no_ban_hero).length; i++) {
			let no_ban_hero_panel = $.GetContextPanel().FindChildTraverse(String(no_ban_hero[i]))
			if (no_ban_hero_panel) {
				no_ban_hero_panel.AddClass("no_ban_hero")
				no_ban_hero_panel.SetPanelEvent("onmouseover", function() {});
			}
		}
	}
}

function EndBanStage(data) 
{
	var BanStagePanel = $.GetContextPanel().FindChildTraverse("BanStagePanel")
	BanStagePanel.RemoveClass("BanStagePanel_visible")
	BanStagePanel.AddClass("BanStagePanel_hidden")


	$.Schedule(1, function() {
		Game.EmitSound("UI.Start_Pick")
	})


	let no_ban_hero = data.no_ban_hero
	if (no_ban_hero) {
		for (var i = 1; i <= Object.keys(no_ban_hero).length; i++) {
			let no_ban_hero_panel = $.GetContextPanel().FindChildTraverse(String(no_ban_hero[i]))
			if (no_ban_hero_panel) {
				no_ban_hero_panel.RemoveClass("no_ban_hero")
				ShowHero(no_ban_hero_panel, no_ban_hero[i])
			}
		}
	}
}

function InitHeroQuests()
{
	var sub_data = CustomNetTables.GetTableValue("sub_data", String(Game.GetLocalPlayerID()));
	let main = $.GetContextPanel().FindChildTraverse("HeroQuests")

	if (!sub_data)
	{
		return
	}

	if (!main.BHasClass("HeroQuests_collapse"))
	{
		return
	}

	if (sub_data.subscribed == 0)
	{
		return
	}

	let text_panel = $.GetContextPanel().FindChildTraverse("HeroQuestsTop_timer")
	let time =sub_data.quests_cd

	let days = Math.floor((time/3600)/24)
	let display = String(days) + $.Localize("#pass_active_sub_days")

	if (days < 1)
	{
		display = String(Math.max(0, Math.floor(((time/3600)/24 - days)*24))) + $.Localize("#pass_active_sub_hours")
	}


	text_panel.text = $.Localize("#QuestCd") + display


	main.RemoveClass("HeroQuests_collapse")

	var player_list = CustomNetTables.GetTableValue("players_heroes", String(Game.GetLocalPlayerID()));

	if (player_list == null)
	{
		return
	}
	StartQuestSelection()
}

function ShowHeroQuests()
{

	let main = $.GetContextPanel().FindChildTraverse("HeroQuests")
	let arrow = $.GetContextPanel().FindChildTraverse("HeroQuestsTop_Icon")

	if (!main)
	{
		return
	}

	if (main.BHasClass("HeroQuests_collapse"))
	{
		return
	}

	if (main.BHasClass("HeroQuests_open"))
	{
		main.RemoveClass("HeroQuests_open")
		main.AddClass("HeroQuests_close")

		arrow.RemoveClass("HeroQuestsTop_Icon_open")
		arrow.AddClass("HeroQuestsTop_Icon_close")
        Game.EmitSound("UI.Talent_hide")

	}else
	{
		main.AddClass("HeroQuests_open")
		main.RemoveClass("HeroQuests_close")

		arrow.AddClass("HeroQuestsTop_Icon_open")
		arrow.RemoveClass("HeroQuestsTop_Icon_close")
    Game.EmitSound("UI.Talent_show")
	}
}

function ChangeQuestsInfo(hero_name)
{
	var quests_data = CustomNetTables.GetTableValue("hero_quests", String(Game.GetLocalPlayerID()));

	var count = 0

	for (var i = 1; i <= 3; i++) 
	{
		let icon_container = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest_Icon_Container" + String(i))
		let reward_container = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest_Reward_Container" + String(i))
		let quest_container = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest" + String(i))

		let text = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest_Text" + String(i))
		let	icon = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest_Icon" + String(i))
		let reward_exp = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest_Reward_exp_text" + String(i))
		let	reward_shards = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest_Reward_shards_text" + String(i))

		if (quests_data[hero_name][i])
		{
			count = count + 1

			reward_container.style.opacity = "1"
			icon_container.style.opacity = "1"
			quest_container.style.opacity = "1"

			icon.style.backgroundImage = "url('file://{images}/custom_game/icons/skills/" + quests_data[hero_name][i].icon + ".png')"
			icon.backgroundSize = "contain"

			text.text = $.Localize("#" + quests_data[hero_name][i].name) + $.Localize("#QuestGoal") + "<b><font color='#53ea48'>" + String(quests_data[hero_name][i].goal) + "</font></b>"


			let number = '?'
			if (quests_data[hero_name][i].exp !== undefined)
			{
				number =  '+' + String(quests_data[hero_name][i].exp)
			}

			reward_exp.text = number

			number = '?'
			if (quests_data[hero_name][i].shards !== undefined)
			{
				number =  '+' + String(quests_data[hero_name][i].shards)
			}

			reward_shards.text = number

		}else 
		{
			reward_container.style.opacity = "0"
			icon_container.style.opacity = "0"
			quest_container.style.opacity = "0"
		}
	}

	if (count == 0)
	{
		let quest_container = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest1")
		let text = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest_Text1")
		quest_container.style.opacity = "1"
		text.text = $.Localize("#NoQuests")
	}
}

function StartQuestSelection()
{

	InitHeroQuests()

	let main = $.GetContextPanel().FindChildTraverse("HeroQuests")

	var quests_data = CustomNetTables.GetTableValue("hero_quests", String(Game.GetLocalPlayerID()));
	var player_list = CustomNetTables.GetTableValue("players_heroes", String(Game.GetLocalPlayerID()));

	if (player_list == null)
	{
		return
	}

	let hero_name = player_list.hero
	let count = 0

	ChangeQuestsInfo(hero_name)

	for (var i = 1; i <= 3; i++) 
	{
		let container = $.GetContextPanel().FindChildTraverse("HeroQuests_Quest" + String(i))

		if (quests_data[hero_name][i])
		{
			SetPickQuest(container, quests_data[hero_name][i].name)
			count = count + 1
		}
	}


	if (count > 0)
	{
		if ((main) && (main.BHasClass("HeroQuests_close")))
		{
			ShowHeroQuests()
		}


		let select_text = $.GetContextPanel().FindChildTraverse("HeroQuestsTop")
		select_text.text = $.Localize("#HeroQuestsTop_select")
	}else 
	{
		EndQuestSelection(0)
	}


}

function SetPickQuest(panel, name)
{


	panel.SetPanelEvent('onmouseover', function() 
	{
		panel.AddClass("HeroQuests_Quest_selected")
	})

	panel.SetPanelEvent('onmouseout', function() 
	{
		panel.RemoveClass("HeroQuests_Quest_selected")
	})

	panel.SetPanelEvent("onactivate", function() {

		panel.SetPanelEvent("onactivate", function(){});

		GameEvents.SendCustomGameEventToServer_custom("SelectQuest", {
			name: name,
		});

		Game.EmitSound("UI.Quest_Select")

		EndQuestSelection(0)
	});
}

function EndQuestSelection(random)
{

	let main = $.GetContextPanel().FindChildTraverse("HeroQuests")

	if (main.BHasClass("HeroQuests_end"))
	{
		return
	}

	if (main.BHasClass("HeroQuests_collapse"))
	{
		return
	}


	if (random == 1)
	{

		var quests_data = CustomNetTables.GetTableValue("hero_quests", String(Game.GetLocalPlayerID()));
		var player_list = CustomNetTables.GetTableValue("players_heroes", String(Game.GetLocalPlayerID()));

		if (player_list == null)
		{
			return
		}


		let hero_name = player_list.hero


		for (var i = 1; i <= 3; i++) 
		{

			if (quests_data[hero_name][i])
			{
				GameEvents.SendCustomGameEventToServer_custom("SelectQuest", {
					name: quests_data[hero_name][i].name,
				});
			break 
			}
		}
	}

	main.AddClass("HeroQuests_end")

    Game.EmitSound("UI.Talent_hide")

	$.Schedule(0.35, function() {
		main.style.opacity = "0"
	})
}

function update_pre_select_base(data)
{
    let player_list = CustomNetTables.GetTableValue("custom_pick", "player_lobby");
    let base_list = {}
    for (let i = 1; i <= 5; i++)
    {
        base_list[i] = []
    }
    for (let i = 0; i < Object.keys(data.info).length; i++)
    {
        let player_id = Object.keys(data.info)[i]
        let base_id = data.info[player_id]
        if (base_list[base_id])
        {
            base_list[base_id].push(player_id)
        }
    }
    for (let base_id in base_list)
    {
        let TeamBaseIcons = $.GetContextPanel().FindChildTraverse("TeamBaseIcons_" + String(base_id))
        let base_players = base_list[base_id]
        for (let i = 0; i <= 1; i++)
        {
            if (base_players[i] !== null && base_players[i] !== undefined)
            {
                TeamBaseIcons.GetChild(i).style.backgroundImage = 'url( "file://{images}/heroes/icons/' +  Game.GetHeroImage(base_players[i], String(player_list.lobby_players[base_players[i]].picked_hero)) + '.png" );'
                TeamBaseIcons.GetChild(i).style.backgroundSize = 'contain'
            }
            else
            {
                TeamBaseIcons.GetChild(i).style.backgroundImage = 'url( "s2r://panorama/images/custom_game/no_hero_png.vtex" );'
                TeamBaseIcons.GetChild(i).style.backgroundSize = "contain"
            }
        }
    }
}

function ReturnClickHero(kv)
{
    let id = kv.id
    let panel = $.GetContextPanel().FindChildTraverse("player_icon" + id)
    if (!panel)
        return

    panel.style.backgroundImage = "url('file://{images}/heroes/" + Game.GetHeroImage(id, kv.hero) + ".png')"
    panel.AddClass("hero_icon_search")
}




init()