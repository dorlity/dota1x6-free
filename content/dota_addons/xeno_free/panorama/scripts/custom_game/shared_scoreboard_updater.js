"use strict";


let ended = false

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_SetTextSafe(panel, childName, textValue) {
	if (panel === null || panel == undefined)
		return;


	var childPanel = panel.FindChildInLayoutFile(childName)
	if (childPanel === null || childPanel == undefined)
		return;

	childPanel.text = textValue;
}

function HasHeroModifier(id, mod) {
	var hero = Players.GetPlayerHeroEntityIndex(id)
	for (var i = 0; i < Entities.GetNumBuffs(hero); i++) {
		var buffID = Entities.GetBuff(hero, i)
		if (Buffs.GetName(hero, buffID) == mod) {
			return true
		}
	}
	return false
}

function init()
{

  GameEvents.Subscribe_custom('EndScreen_game_end', EndScreen_game_end)
}


let qwe = {}
//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdatePlayerPanel(scoreboardConfig, playersContainer, playerId, localPlayerTeamId) {

	var playerInfo = Game.GetPlayerInfo(playerId);

	var progress = CustomNetTables.GetTableValue("custom_pick", "pick_state");
	if (progress) {
		if ((progress.in_progress == true) || ((playerInfo) && (playerInfo.player_selected_hero == "npc_dota_hero_wisp"))) {
			return
		}
	}


	var playerPanelName = "_dynamic_player_" + playerId;
	var playerPanel = playersContainer.FindChild(playerPanelName);
	if (playerPanel === null) {
		playerPanel = $.CreatePanel("Panel", playersContainer, playerPanelName);
		playerPanel.SetAttributeInt("player_id", playerId);
		playerPanel.BLoadLayout(scoreboardConfig.playerXmlName, false, false);
	}

	playerPanel.SetHasClass("is_local_player", (playerId == Game.GetLocalPlayerID()));


	var ultStateOrTime = PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN; // values > 0 mean on cooldown for that many seconds
	var isTeammate = false;


	var server_data = CustomNetTables.GetTableValue("server_data",  String(playerId));
	var table_end = CustomNetTables.GetTableValue('networth_players', String(playerId));
	var game_end = CustomNetTables.GetTableValue('networth_players', "");
	if (playerInfo) {

		isTeammate = (playerInfo.player_team_id == localPlayerTeamId);
		if (isTeammate) {
			ultStateOrTime = Game.GetPlayerUltimateStateOrTime(playerId);
		}

		var calibration_games = 0

		if (server_data)
		{
			calibration_games = server_data.competitive_calibration_games_remaining
		}

		if (calibration_games > 0)
		{
			_ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerMmr", $.Localize("#calibration_short") + ' (' + String(calibration_games) + ')');
			var panel = playerPanel.FindChildTraverse("PlayerMmr")
			if (panel)
			{
				panel.style.fontSize = "15px";
			}
		}
		else 
		{
			if (table_end && qwe[playerId] == undefined && game_end && game_end.game_ended == true) 
			{

				const func = function()
				{
					table_end = CustomNetTables.GetTableValue('networth_players', String(playerId));

					_ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerMmr", (table_end.rating_before || 0));
					if (table_end.rating_change < 0) {
						_ScoreboardUpdater_SetTextSafe(playerPanel, "MmrPlus", "- " + (table_end.rating_change * -1));

						if (playerPanel.FindChildTraverse("MmrPlus"))
						{
							playerPanel.FindChildTraverse("MmrPlus").text = "- " + (table_end.rating_change * -1);
							playerPanel.FindChildInLayoutFile("MmrPlus").style.color = "gradient( linear, 90% 80%, 30% 20%, from( white ), to( red ) )"
						}

					} else {


						_ScoreboardUpdater_SetTextSafe(playerPanel, "MmrPlus", "+ " + table_end.rating_change);

						if (playerPanel.FindChildTraverse("MmrPlus"))
						{	
							playerPanel.FindChildTraverse("MmrPlus").text = "+ " + table_end.rating_change;
						}
					}
					qwe[playerId] = $.Schedule(0.5, func)

				}

				qwe[playerId] = $.Schedule(0.5, func)
			}
		}

		playerPanel.SetHasClass("player_dead", (playerInfo.player_respawn_seconds >= 0));
		playerPanel.SetHasClass("local_player_teammate", isTeammate && (playerId != Game.GetLocalPlayerID()));

		playerPanel.SetPanelEvent('onactivate', function() {
			//PortraitClicked();
			Game.Upgrades(playerInfo.player_selected_hero)
		});


		_ScoreboardUpdater_SetTextSafe(playerPanel, "RespawnTimer", (playerInfo.player_respawn_seconds + 1)); // value is rounded down so just add one for rounded-up
		_ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerName", playerInfo.player_name);
		_ScoreboardUpdater_SetTextSafe(playerPanel, "Level", playerInfo.player_level);
		_ScoreboardUpdater_SetTextSafe(playerPanel, "Kills", playerInfo.player_kills);
		_ScoreboardUpdater_SetTextSafe(playerPanel, "Deaths", playerInfo.player_deaths);
		_ScoreboardUpdater_SetTextSafe(playerPanel, "Assists", playerInfo.player_assists);

		var playerPortrait = playerPanel.FindChildInLayoutFile("HeroIcon");

		let effect_panel = playerPanel.FindChildInLayoutFile("TopHero");

		if (effect_panel) {
			let portrait = effect_panel.FindChildInLayoutFile("HeroIcon");




			var table = CustomNetTables.GetTableValue('networth_players', String(playerId));

			var Player_has_aegis_panel = playerPanel.FindChildInLayoutFile("AegisIndicator");
			var Player_aegis_effect = playerPanel.FindChildInLayoutFile("ParticleAegis");
			var Player_no_Buyback = playerPanel.FindChildInLayoutFile("BuybackIndicator");

			if (table) {
				if (typeof table.hero_has_aegis !== 'undefined') {
					if (Player_has_aegis_panel)
						Player_has_aegis_panel.visible = table.hero_has_aegis == 1
					if (Player_aegis_effect)
						Player_aegis_effect.visible = table.hero_has_aegis == 1
				}


				
			}

			if ((table) && (table.streak == 1)) {

				let fire = portrait.FindChildInLayoutFile("fire_effect")
				if (fire == null) {
					//$.CreatePanel("DOTAParticleScenePanel", portrait, 'fire_effect', {style:'width:900px;height:300px;', fov:'25', lookAt:'-80 700 200', cameraOrigin:'0 -250 90', map:'scenes/dota_ui_particle_scene_panel_empty',  particleName: 'particles/fire_streak.vpcf',  particleonly:'true', camera:'default_camera'});

				}

			}

			if ((table) && (table.streak == 0)) {

				let fire = portrait.FindChildInLayoutFile("fire_effect")
				if (fire) {
					fire.DeleteAsync(0);
				}

			}
		}

		if (playerPortrait) 
		{
			if (playerInfo.player_selected_hero !== "") 
			{
				playerPortrait.SetImage("file://{images}/heroes/" + Game.GetHeroImage(String(playerId), playerInfo.player_selected_hero) + ".png");
			} else 
			{
				playerPortrait.SetImage("file://{images}/custom_game/unassigned.png");
			}
		}

		if (playerInfo.player_selected_hero_id == -1) {
			_ScoreboardUpdater_SetTextSafe(playerPanel, "HeroName", $.Localize("#DOTA_Scoreboard_Picking_Hero"))
		} else {
			_ScoreboardUpdater_SetTextSafe(playerPanel, "HeroName", $.Localize("#" + playerInfo.player_selected_hero))
		}



		var heroNameAndDescription = playerPanel.FindChildInLayoutFile("HeroNameAndDescription");
		if (heroNameAndDescription) {
			if (playerInfo.player_selected_hero_id == -1) {
				heroNameAndDescription.SetDialogVariable("hero_name", $.Localize("#DOTA_Scoreboard_Picking_Hero"));
			} else {
				heroNameAndDescription.SetDialogVariable("hero_name", $.Localize("#" + playerInfo.player_selected_hero));
			}
			heroNameAndDescription.SetDialogVariableInt("hero_level", playerInfo.player_level);
		}

		playerPanel.SetHasClass("player_connection_abandoned", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_ABANDONED);
		playerPanel.SetHasClass("player_connection_failed", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_FAILED);
		playerPanel.SetHasClass("player_connection_disconnected", playerInfo.player_connection_state == DOTAConnectionState_t.DOTA_CONNECTION_STATE_DISCONNECTED);

		var playerAvatar = playerPanel.FindChildInLayoutFile("AvatarImage");
		if (playerAvatar) {
			playerAvatar.steamid = playerInfo.player_steamid;
		}

		var playerColorBar = playerPanel.FindChildInLayoutFile("PlayerColorBar");
		if (playerColorBar !== null) {
			if (GameUI.CustomUIConfig().team_colors) {
				var teamColor = GameUI.CustomUIConfig().team_colors[playerInfo.player_team_id];
				if (teamColor) {
					playerColorBar.style.backgroundColor = teamColor;
				}
			} else {
				var playerColor = "#000000";
				playerColorBar.style.backgroundColor = playerColor;
			}
		}
	}
	var IdButton = playerPanel.FindChildInLayoutFile("TalentButton");
	if (IdButton) {

		IdButton.SetPanelEvent('onactivate', function() {

			init_space_end(playerInfo.player_selected_hero)
		});
	}





	var playerItemsContainer = playerPanel.FindChildInLayoutFile("PlayerItemsContainer");

	var item_table = CustomNetTables.GetTableValue('networth_players', String(playerId));


	if ((playerItemsContainer) && item_table && item_table.items) {

		for (var i = 0; i <= Object.keys(item_table.items).length; ++i) {
			var itemPanelName = "_dynamic_item_" + i;
			var itemPanel = playerItemsContainer.FindChild(itemPanelName);
			if (itemPanel === null) {

				itemPanel = $.CreatePanel("DOTAItemImage", playerItemsContainer, itemPanelName)
				itemPanel.AddClass("PlayerItem");
				itemPanel.itemname = item_table.items[i]
			}

			//if ( item_table.items[i] !== '' )
			//{
			//	var item_image_name = "file://{images}/items/" + item_table.items[i].replace( "item_", "" ) + ".png"
			//
			//itemPanel.SetImage( item_image_name );
			//}
			//else
			//{
			//	itemPanel.SetImage( "" );
			//}
		}
	}

	var goldValue = table_end ? table_end.net : -1;
	if (isTeammate) {
		_ScoreboardUpdater_SetTextSafe(playerPanel, "TeammateGoldAmount", goldValue);
	}

	_ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerGoldAmount", goldValue);

	playerPanel.SetHasClass("player_ultimate_ready", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_READY));
	playerPanel.SetHasClass("player_ultimate_no_mana", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NO_MANA));
	playerPanel.SetHasClass("player_ultimate_not_leveled", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_NOT_LEVELED));
	playerPanel.SetHasClass("player_ultimate_hidden", (ultStateOrTime == PlayerUltimateStateOrTime_t.PLAYER_ULTIMATE_STATE_HIDDEN));
	playerPanel.SetHasClass("player_ultimate_cooldown", (ultStateOrTime > 0));
	_ScoreboardUpdater_SetTextSafe(playerPanel, "PlayerUltimateCooldown", ultStateOrTime);
}


//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateTeamPanel(scoreboardConfig, containerPanel, teamDetails, teamsInfo) {



if (!containerPanel)
	return;

var teamId = teamDetails.team_id;

var teamPlayers = Game.GetPlayerIDsOnTeam(teamId)




//	$.Msg( "_ScoreboardUpdater_UpdateTeamPanel: ", teamId );

var teamPanelName = "_dynamic_team_" + teamId;
var teamPanel = containerPanel.FindChild(teamPanelName);
if (teamPanel === null) {
	//		$.Msg( "UpdateTeamPanel.Create: ", teamPanelName, " = ", scoreboardConfig.teamXmlName );
	teamPanel = $.CreatePanel("Panel", containerPanel, teamPanelName);
	teamPanel.SetAttributeInt("team_id", teamId);
	teamPanel.BLoadLayout(scoreboardConfig.teamXmlName, false, false);

	var logo_xml = GameUI.CustomUIConfig().team_logo_xml;
	if (logo_xml) {
		var teamLogoPanel = teamPanel.FindChildInLayoutFile("TeamLogo");
		if (teamLogoPanel) {
			teamLogoPanel.SetAttributeInt("team_id", teamId);
			teamLogoPanel.BLoadLayout(logo_xml, false, false);
		}
	}
}

var localPlayerTeamId = -1;
var localPlayer = Game.GetLocalPlayerInfo();
if (localPlayer) {
	localPlayerTeamId = localPlayer.player_team_id;
}


teamPanel.SetHasClass("local_player_team", localPlayerTeamId == teamId);
teamPanel.SetHasClass("not_local_player_team", localPlayerTeamId != teamId);



var teamPlayers = Game.GetPlayerIDsOnTeam(teamId)
var playersContainer = teamPanel.FindChildInLayoutFile("PlayersContainer");

var Player_Level = teamPanel.FindChildInLayoutFile("LevelIndicator");


if (playersContainer) 
{
	for (var playerId of teamPlayers) 
	{
		var table = CustomNetTables.GetTableValue('networth_players', String(playerId));

		var local_table = CustomNetTables.GetTableValue('networth_players', Players.GetLocalPlayer());
		var sub_table = CustomNetTables.GetTableValue('sub_data', String(playerId));


		if (table && sub_table && Player_Level && sub_table.heroes_data && sub_table.heroes_data[ table.hero_name ])
		{
			if (table.hero_tier !== -1 && sub_table.hide_tier == 0 && sub_table.heroes_data[table.hero_name].has_level == 1 && sub_table.subscribed == 1)
			{
				Player_Level.style.backgroundImage = 'url("file://{images}/custom_game/hero_level_' + String(table.hero_tier) + '.png")';
				Player_Level.style.backgroundSize = "contain";
				Player_Level.style.visibility = "visible";
			}	
			else 
			{
				Player_Level.style.visibility = "collapse";
			}
		}
		


		if (table) {
			teamPanel.SetHasClass("has_streak", table.streak == 1);

			_ScoreboardUpdater_SetTextSafe(teamPanel, "TeamScore", table.net)

			var Player_no_Buyback = teamPanel.FindChildTraverse("BuybackIndicator");

			if (typeof table.no_buyback !== 'undefined' && Player_no_Buyback)
					Player_no_Buyback.visible = table.no_buyback == 1

		}


		if (local_table) 
		{
			var panel_damage = teamPanel.FindChildTraverse("BlackScreen")
			var text_damage = teamPanel.FindChildTraverse("PurpleScore")
			var BlackScreen = teamPanel.FindChildTraverse("BlackScreen")
			var LocalTeam = teamPanel.FindChildTraverse("LocalTeamOverlay")
			var PurpleIndicator = teamPanel.FindChildTraverse("PurpleIndicator")



			if ((table) && (PurpleIndicator))
			{
				if ((local_table.hero_kills)&&(local_table.hero_kills[table.team] >= 3))
				{
					//PurpleIndicator.style.visibility = "visible";
				}
				else 
				{
					//PurpleIndicator.style.visibility = "collapse";
				}

			}

			let damage_bonus = 0

			if (table && table.damage_bonus)
			{
				damage_bonus = table.damage_bonus
			}


			if ((Game.GetDOTATime(false, false) <= 900) && (text_damage) ) 
			{
				
				text_damage.style.visibility = "visible"
				text_damage.RemoveClass("RedText")
				text_damage.RemoveClass("GreenText")

				var text = ''

				let max_damage = 30
				if (PurpleIndicator)
				{
					if (damage_bonus == max_damage)
					{
							PurpleIndicator.style.visibility = "visible";
					}
						else 
					{
							PurpleIndicator.style.visibility = "collapse";
					}
				}


				if (playerId == Game.GetLocalPlayerID() || damage_bonus == 0) 
				{
					text_damage.AddClass("GreenText")

					panel_damage.style.backgroundImage = 'url("file://{images}/custom_game/PanelGreen.png")';


					if (damage_bonus != 0)
					{
						text = $.Localize("#Incoming_damage") + Math.abs(damage_bonus) + '% ' + $.Localize("#Incoming_damage2") + Math.abs(damage_bonus) + '%'
					
						if (damage_bonus == max_damage)
						{
							text = text + $.Localize("#Incoming_damage3")
						}

						text = text + $.Localize("#Incoming_damage4")


						teamPanel.SetPanelEvent('onmouseover', function() {
							$.DispatchEvent('DOTAShowTextTooltip', teamPanel, text)
						});
						teamPanel.SetPanelEvent('onmouseout', function() {
							$.DispatchEvent('DOTAHideTextTooltip', teamPanel);
						});
					}
					else 
					{
					  teamPanel.SetPanelEvent('onmouseover', function() {
							
						});
						teamPanel.SetPanelEvent('onmouseout', function() {
						
						});
					}
				}
				else 
				{

					damage_bonus = damage_bonus*-1

					text_damage.AddClass("RedText")
					panel_damage.style.backgroundImage = 'url("file://{images}/custom_game/PanelRed.png")';

					text = $.Localize("#Outgoing_damage") + Math.abs(damage_bonus) + '% ' + $.Localize("#Outgoing_damage2") + Math.abs(damage_bonus) + '%'

					if (damage_bonus == max_damage*-1)
					{
						text = text + $.Localize("#Outgoing_damage3")
					}

					text = text + $.Localize("#Outgoing_damage4")

					teamPanel.SetPanelEvent('onmouseover', function() {
						$.DispatchEvent('DOTAShowTextTooltip', teamPanel, text)
					});
					teamPanel.SetPanelEvent('onmouseout', function() {
						$.DispatchEvent('DOTAHideTextTooltip', teamPanel);
					});

				}


				_ScoreboardUpdater_SetTextSafe(teamPanel, "PurpleScore", damage_bonus + '%')
				text_damage.html = true

				
			} 
			else 
			{
				if (LocalTeam) 
				{

					if (PurpleIndicator)
					{
							PurpleIndicator.style.visibility = "collapse";
					}

					LocalTeam.style.height = "67px"

					BlackScreen.style.height = "25px"
					text_damage.style.visibility = "collapse"
					panel_damage.style.backgroundImage = 'url("file://{images}/custom_game/Layer25.png")';


					teamPanel.SetPanelEvent('onmouseover', function() {
						
					});
					teamPanel.SetPanelEvent('onmouseout', function() {
					
					});

				}
			}
		}


		_ScoreboardUpdater_UpdatePlayerPanel(scoreboardConfig, playersContainer, playerId, localPlayerTeamId)
	}
}

teamPanel.SetHasClass("no_players", (teamPlayers.length == 0))
teamPanel.SetHasClass("one_player", (teamPlayers.length == 1))

if (teamsInfo.max_team_players < teamPlayers.length) {
	teamsInfo.max_team_players = teamPlayers.length;
}

//_ScoreboardUpdater_SetTextSafe( teamPanel, "TeamName", $.Localize( "#" + teamDetails.team_name ) )

if (GameUI.CustomUIConfig().team_colors) {
	var teamColor = GameUI.CustomUIConfig().team_colors[teamId];
	var teamColorPanel = teamPanel.FindChildInLayoutFile("TeamColor");

	teamColor = teamColor.replace(";", "");

	if (teamColorPanel) {
		teamNamePanel.style.backgroundColor = teamColor + ";";
	}

	var teamColor_GradentFromTransparentLeft = teamPanel.FindChildInLayoutFile("TeamColor_GradentFromTransparentLeft");
	if (teamColor_GradentFromTransparentLeft) {
		var gradientText = 'gradient( linear, 0% 0%, 800% 0%, from( #00000000 ), to( ' + teamColor + ' ) );';
		//			$.Msg( gradientText );
		teamColor_GradentFromTransparentLeft.style.backgroundColor = gradientText;
	}
}

return teamPanel;
}

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_ReorderTeam(scoreboardConfig, teamsParent, teamPanel, teamId, newPlace, prevPanel) {
	//	$.Msg( "UPDATE: ", GameUI.CustomUIConfig().teamsPrevPlace );
	var oldPlace = null;
	if (GameUI.CustomUIConfig().teamsPrevPlace.length > teamId) {
		oldPlace = GameUI.CustomUIConfig().teamsPrevPlace[teamId];
	}
	GameUI.CustomUIConfig().teamsPrevPlace[teamId] = newPlace;

	if (newPlace != oldPlace) {
		//		$.Msg( "Team ", teamId, " : ", oldPlace, " --> ", newPlace );
		teamPanel.RemoveClass("team_getting_worse");
		teamPanel.RemoveClass("team_getting_better");
		if (newPlace > oldPlace) {
			teamPanel.AddClass("team_getting_worse");
		} else if (newPlace < oldPlace) {
			teamPanel.AddClass("team_getting_better");
		}
	}

	teamsParent.MoveChildAfter(teamPanel, prevPanel);
}

// sort / reorder as necessary
function compareFunc(a, b) { // GameUI.CustomUIConfig().sort_teams_compare_func;
    const teamPlayers_a = Game.GetPlayerIDsOnTeam(a.team_id),
    	teamPlayers_b = Game.GetPlayerIDsOnTeam(b.team_id)
	if (teamPlayers_a.length === 0 && teamPlayers_b.length === 0)
        return 0
	if (teamPlayers_a.length !== 0 && teamPlayers_b.length === 0)
        return -1 // [ A, B ]
	if (teamPlayers_a.length === 0 && teamPlayers_b.length !== 0)
        return 1 // [ B, A ]
    var table, table2
    for (var playerId of teamPlayers_a)
        table = CustomNetTables.GetTableValue('networth_players', String(playerId)) || table

    for (var playerId of teamPlayers_b)
        table2 = CustomNetTables.GetTableValue('networth_players', String(playerId)) || table2

    var place1 = -1, place2 = -1, gold1 = 1, gold2 = 1
    if (table) {
        place1 = table.place
        gold1 = table.net
    }
    if (table2) {
        place2 = table2.place
        gold2 = table2.net
    }

    if (place1 < 0 && place2 < 0) {
        place1 = -gold1
        place2 = -gold2
    } else {
        if (place1 < 0 && place2 >= 0)
            return -1 // [ A, B ] place <0 first
        if (place1 >= 0 && place2 < 0)
            return 1 // [ B, A ] place <0 first
    }
    if (place1 < place2)
        return -1 // [ A, B ]
    if (place1 > place2)
        return 1 // [ B, A ]
    return 0
}

function stableCompareFunc(a, b) {

	var unstableCompare = compareFunc(a, b);
	if (unstableCompare != 0) {
		return unstableCompare;
	}

	if (GameUI.CustomUIConfig().teamsPrevPlace.length <= a.team_id) {
		return 0;
	}

	if (GameUI.CustomUIConfig().teamsPrevPlace.length <= b.team_id) {
		return 0;
	}

	//			$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );

	var a_prev = GameUI.CustomUIConfig().teamsPrevPlace[a.team_id];
	var b_prev = GameUI.CustomUIConfig().teamsPrevPlace[b.team_id];
	if (a_prev < b_prev) // [ A, B ]
	{
		return -1; // [ A, B ]
	} else if (a_prev > b_prev) // [ B, A ]
	{
		return 1; // [ B, A ]
	} else {
		return 0;
	}
};

//=============================================================================
//=============================================================================
function _ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardConfig, teamsContainer) {
	//	$.Msg( "_ScoreboardUpdater_UpdateAllTeamsAndPlayers: ", scoreboardConfig );

	var teamsList = [];
	for (var teamId of Game.GetAllTeamIDs()) {
		teamsList.push(Game.GetTeamDetails(teamId));
	}

	// update/create team panels
	var teamsInfo = {
		max_team_players: 0
	};
	var panelsByTeam = [];
	for (var i = 0; i < teamsList.length; ++i) {


		var teamId = teamsList[i].team_id;

		var teamPlayers = Game.GetPlayerIDsOnTeam(teamId)

		var n = 0

		for (var playerId of teamPlayers) {
			var playerInfo = Game.GetPlayerInfo(playerId);
			if ((playerInfo) && (playerInfo.player_selected_hero != "npc_dota_hero_wisp")) {
				n = n + 1
			}
		}
		if (n > 0) {

			var teamPanel = _ScoreboardUpdater_UpdateTeamPanel(scoreboardConfig, teamsContainer, teamsList[i], teamsInfo);
			if (teamPanel) {
				panelsByTeam[teamsList[i].team_id] = teamPanel;
			}
		}
	}

	if (teamsList.length > 1) {
		//		$.Msg( "panelsByTeam: ", panelsByTeam );

		// sort
		if (scoreboardConfig.shouldSort) {
			teamsList.sort(stableCompareFunc);
		}

		//		$.Msg( "POST: ", teamsAndPanels );

		// reorder the panels based on the sort
		var prevPanel = panelsByTeam[teamsList[0].team_id];
		for (var i = 0; i < teamsList.length; ++i) {

			var teamId = teamsList[i].team_id;
			var teamPanel = panelsByTeam[teamId];
			if (teamPanel && prevPanel)
				_ScoreboardUpdater_ReorderTeam(scoreboardConfig, teamsContainer, teamPanel, teamId, i, prevPanel);
			prevPanel = teamPanel;
		}
		//		$.Msg( GameUI.CustomUIConfig().teamsPrevPlace );
	}

	//	$.Msg( "END _ScoreboardUpdater_UpdateAllTeamsAndPlayers: ", scoreboardConfig );
}


//=============================================================================
//=============================================================================
function ScoreboardUpdater_InitializeScoreboard(scoreboardConfig, scoreboardPanel) {
	GameUI.CustomUIConfig().teamsPrevPlace = [];
	if (typeof(scoreboardConfig.shouldSort) === 'undefined') {
		// default to true
		scoreboardConfig.shouldSort = true;
	}
	_ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardConfig, scoreboardPanel);
	return {
		"scoreboardConfig": scoreboardConfig,
		"scoreboardPanel": scoreboardPanel
	}
}


//=============================================================================
//=============================================================================
function ScoreboardUpdater_SetScoreboardActive(scoreboardHandle, isActive) {
	if (scoreboardHandle.scoreboardConfig === null || scoreboardHandle.scoreboardPanel === null) {
		return;
	}

	if (isActive) {
		_ScoreboardUpdater_UpdateAllTeamsAndPlayers(scoreboardHandle.scoreboardConfig, scoreboardHandle.scoreboardPanel);
	}
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetTeamPanel(scoreboardHandle, teamId) {
	if (scoreboardHandle.scoreboardPanel === null) {
		return;
	}

	var teamPanelName = "_dynamic_team_" + teamId;
	return scoreboardHandle.scoreboardPanel.FindChild(teamPanelName);
}

//=============================================================================
//=============================================================================
function ScoreboardUpdater_GetSortedTeamInfoList(scoreboardHandle) {
	var teamsList = [];
	for (var teamId of Game.GetAllTeamIDs()) {
		teamsList.push(Game.GetTeamDetails(teamId));
	}

	if (teamsList.length > 1) {
		teamsList.sort(stableCompareFunc);
	}

	return teamsList;
}




function MouseOver(panel, text) {

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




function init_space_end(hero_alt) {

	delete_space()
	delete_end_screen()
	Game.EmitSound("UI.Click")

	var LayerGeneral = $.GetContextPanel().FindChildTraverse("LayerGeneralEnd");

	if (LayerGeneral) {


		//LayerGeneral.style.backgroundImage = 'url("file://{images}/custom_game/talent_back.png")';
		LayerGeneral.style.backgroundSize = "contain";


		var LayerGray_Left = $.CreatePanel("Panel", LayerGeneral, "LayerGray_left")
		LayerGray_Left.AddClass("LayerGray_left")


		var LayerPlayer_Skills = $.CreatePanel("Panel", LayerGeneral, "LayerPlayer_Skills")
		LayerPlayer_Skills.AddClass("LayerPlayer_Skills")



		var LayerGray_Right = $.CreatePanel("Panel", LayerGeneral, "LayerGray_Right")
		LayerGray_Right.AddClass("LayerGray_right")




		var LayerOrange = $.CreatePanel("Panel", LayerPlayer_Skills, "LayerOrange")
		LayerOrange.AddClass("LayerOrange")


		var LayerPurple = $.CreatePanel("Panel", LayerPlayer_Skills, "LayerPurple")
		LayerPurple.AddClass("LayerPurple")


		var LayerBlue = $.CreatePanel("Panel", LayerPlayer_Skills, "LayerBlue")
		LayerBlue.AddClass("LayerBlue")




		var LayerPurple_skill = []
		LayerPurple_skill[1] = $.CreatePanel("Panel", LayerPurple, "LayerPurple_skill")
		LayerPurple_skill[1].AddClass("Skill")
		LayerPurple_skill[2] = $.CreatePanel("Panel", LayerPurple, "LayerPurple_skill")
		LayerPurple_skill[2].AddClass("Skill")
		LayerPurple_skill[3] = $.CreatePanel("Panel", LayerPurple, "LayerPurple_skill")
		LayerPurple_skill[3].AddClass("Skill")
		LayerPurple_skill[4] = $.CreatePanel("Panel", LayerPurple, "LayerPurple_skill")
		LayerPurple_skill[4].AddClass("Skill")


		var LayerBlue_skill = []
		LayerBlue_skill[1] = $.CreatePanel("Panel", LayerBlue, "LayerBlue_skill")
		LayerBlue_skill[1].AddClass("Skill")
		LayerBlue_skill[2] = $.CreatePanel("Panel", LayerBlue, "LayerBlue_skill")
		LayerBlue_skill[2].AddClass("Skill")
		LayerBlue_skill[3] = $.CreatePanel("Panel", LayerBlue, "LayerBlue_skill")
		LayerBlue_skill[3].AddClass("Skill")
		LayerBlue_skill[4] = $.CreatePanel("Panel", LayerBlue, "LayerBlue_skill")
		LayerBlue_skill[4].AddClass("Skill")

		hero_alt = String(hero_alt)

		if (hero_alt == "undefined") {
			var hero_ent = Players.GetLocalPlayerPortraitUnit();
			var hero = Entities.GetUnitName(hero_ent)
		} else {
			var hero = hero_alt
		}


		var player_table = CustomNetTables.GetTableValue("upgrades_player", hero)

		var orange_card = []
		var orange_content = []
		var orange_icon = []
		var orange_lvl = []

		var blue_card = []
		var blue_content = []
		var blue_icon = []
		var blue_lvl = []

		var purple_card = []
		var purple_content = []
		var purple_icon = []
		var purple_lvl = []
		var c = 1
		var p = 1
		var b = 1
		var s = ''

		for (const data of Object.values(Game.upgrades_data[hero])) {
			const name = data[1]
			let lvl
			if (player_table !== undefined)
				lvl = player_table.upgrades[name]

			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		if (Game.UpgradeMatchesRarity(data, "orange")) {
				orange_card[c] = $.CreatePanel("Panel", LayerOrange, "orange_card" + c)
				orange_card[c].AddClass("orange_card")

        MouseOverTalent(orange_card[c], $.Localize('#upgrade_disc_' + name), name, lvl, false, true)

				orange_content[c] = $.CreatePanel("Panel", orange_card[c], "orange_content" + c)
				orange_content[c].AddClass("orange_content");
				//orange_content[c].style.backgroundImage = 'url("file://{images}/custom_game/orange_talent.png")';


				orange_icon[c] = $.CreatePanel("Panel", orange_content[c], "orange_icon" + c)
				orange_icon[c].AddClass("card_icon_orange")
				orange_icon[c].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + data[6] + '.png")';
				orange_icon[c].style.backgroundSize = "contain";
				orange_icon[c].style.backgroundRepeat = "no-repeat";
				orange_icon[c].style.washColor = "#666666";
				orange_icon[c].style.saturation = "0.1";


				orange_lvl[c] = $.CreatePanel("Panel", orange_content[c], "orange_lvl" + c)
				orange_lvl[c].AddClass("orange_lvl")
				s = 'olevel_0'

				if (lvl !== undefined) {
					s = 'orange_lvl_1'
					orange_icon[c].style.washColor = "none";
					orange_icon[c].style.saturation = "1";
					orange_content[c].RemoveClass("orange_content");
					orange_content[c].AddClass("orange_content_anim");
				}

				orange_lvl[c].style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
				orange_lvl[c].style.backgroundSize = "100%";
				orange_lvl[c].style.backgroundRepeat = "no-repeat";

				c++

			}
			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


			if (Game.UpgradeMatchesRarity(data, "purple")) {


				purple_card[p] = $.CreatePanel("Panel", LayerPurple_skill[data[8]], "purple_card" + p)
				purple_card[p].AddClass("purple_card")

				purple_content[p] = $.CreatePanel("Panel", purple_card[p], "purple_content" + p)
				purple_content[p].AddClass("card_content_purple");
				purple_content[p].style.backgroundSize = "contain";
				//purple_content[p].style.backgroundImage = 'url("file://{images}/custom_game/talent.png")';


				purple_icon[p] = $.CreatePanel("Panel", purple_content[p], "purple_icon" + p)
				purple_icon[p].AddClass("card_icon")
				purple_icon[p].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + data[9] + '.png")';
				purple_icon[p].style.backgroundSize = "contain";
				purple_icon[p].style.backgroundRepeat = "no-repeat";
				purple_icon[p].style.washColor = "#666666";
				purple_icon[p].style.saturation = "0.1";

				s = 'slevel_0'

				if (lvl !== undefined) {
					s = 'epic_level_' + data[4] + lvl

					purple_icon[p].style.washColor = "none";
					purple_icon[p].style.saturation = "1";

					if (lvl == data[5]) {

						purple_content[p].RemoveClass("card_content_purple");
						purple_content[p].AddClass("card_content_purple_anim");

					}
				}

				
				let talent_text = $.Localize('#upgrade_disc_' + name)
				var final_text = ""


				if (talent_text == "#upgrade_disc_" + name)
				{
				    if (data[4] > 1) 
				    {
				        let fake_lvl = lvl !== undefined ? lvl : 0
				        final_text = $.Localize('#talent_disc_' + name + '_' + fake_lvl)
				    } else {
				        final_text = $.Localize('#upgrade_disc_' + name + '_1')
				    }

				    MouseOver(purple_card[p], final_text )
				}else 
				{
				    MouseOverTalent(purple_card[p], talent_text, name, lvl, true)
        }


				purple_lvl[p] = $.CreatePanel("Panel", purple_content[p], "purple_lvl" + p)
				purple_lvl[p].AddClass("card_lvl")
				purple_lvl[p].style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
				purple_lvl[p].style.backgroundSize = "100%";
				purple_lvl[p].style.backgroundRepeat = "no-repeat";

				p++

			}


			//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

			if (Game.UpgradeMatchesRarity(data, "blue")) {

				blue_card[b] = $.CreatePanel("Panel", LayerBlue_skill[data[8]], "blue_card" + b)
				blue_card[b].AddClass("purple_card")


				blue_content[b] = $.CreatePanel("Panel", blue_card[b], "blue_content" + b)
				blue_content[b].AddClass("card_content_blue");
				blue_content[b].style.backgroundSize = "contain";
				//blue_content[b].style.backgroundImage = 'url("file://{images}/custom_game/talent.png")';	


				blue_icon[b] = $.CreatePanel("Panel", blue_content[b], "blue_icon" + b)
				blue_icon[b].AddClass("card_icon")
				blue_icon[b].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/' + hero + '/' + data[9] + '.png")';
				blue_icon[b].style.backgroundSize = "contain";
				blue_icon[b].style.backgroundRepeat = "no-repeat";
				blue_icon[b].style.washColor = "#666666";
				blue_icon[b].style.saturation = "0.1";

				s = 'slevel_0'

				if (lvl !== undefined) {
					s = 'blue_level_' + lvl

					blue_icon[b].style.washColor = "none";
					blue_icon[b].style.saturation = "1";

					if (lvl == data[4]) {
						blue_content[b].RemoveClass("card_content_blue");
						blue_content[b].AddClass("card_content_blue_anim");
					}
				}

        let talent_text = $.Localize('#upgrade_disc_' + name)
        var final_text = ""

        if (talent_text == "#upgrade_disc_" + name)
        {
            if (data[4] > 1) {
                let fake_lvl = lvl !== undefined ? lvl : 0
                final_text = $.Localize('#talent_disc_' + name + '_' + fake_lvl)
            } else {
                final_text = $.Localize('#upgrade_disc_' + name)
            }
            MouseOver(blue_card[b], final_text)
        }else 
        {
            MouseOverTalent(blue_card[b], talent_text, name, lvl, true)
        }


				blue_lvl[b] = $.CreatePanel("Panel", blue_content[b], "purple_lvl" + b)
				blue_lvl[b].AddClass("card_lvl")
				blue_lvl[b].style.backgroundImage = 'url("file://{images}/custom_game/' + s + '.png")';
				blue_lvl[b].style.backgroundSize = "100%";
				blue_lvl[b].style.backgroundRepeat = "no-repeat";

				b++

			}


		}

		var LayerGray_skill = []
		
		LayerGray_skill[1] = $.CreatePanel("Panel", LayerGray_Left, "LayerGray_skill")
		LayerGray_skill[1].AddClass("Gray_Skill")
		LayerGray_skill[2] = $.CreatePanel("Panel", LayerGray_Left, "LayerGray_skill")
		LayerGray_skill[2].AddClass("Gray_Skill")
		LayerGray_skill[3] = $.CreatePanel("Panel", LayerGray_Right, "LayerGray_skill")
		LayerGray_skill[3].AddClass("Gray_Skill")
		LayerGray_skill[4] = $.CreatePanel("Panel", LayerGray_Right, "LayerGray_skill")
		LayerGray_skill[4].AddClass("Gray_Skill")


		var general_purple_card = []
		var general_purple_color = []
		var general_purple_shadow = []
		var general_purple_image = []
		var general_purple_stack = []

		var general_blue_card = []
		var general_blue_color = []
		var general_blue_shadow = []
		var general_blue_image = []
		var general_blue_stack = []

		var general_gray_card = []
		var general_gray_color = []
		var general_gray_shadow = []
		var general_gray_image = []
		var general_gray_stack = []

		var gp = 0
		var gb = 0
		var gg = 0
		var gray_count = 0
		var purple_count = 0
		var blue_count = 0

		var number = 0
		var text = ''

		var gray_max = 6

		var general_gray_border = $.CreatePanel("Panel", LayerGray_skill[1], "general_gray_border")
		general_gray_border.AddClass("general_border")
		var general_gray_border = $.CreatePanel("Panel", LayerGray_skill[2], "general_gray_border")
		general_gray_border.AddClass("general_border")

		var general_gray_border = $.CreatePanel("Panel", LayerGray_skill[3], "general_gray_border")
		general_gray_border.AddClass("general_border")
		var general_gray_border = $.CreatePanel("Panel", LayerGray_skill[4], "general_gray_border")
		general_gray_border.AddClass("general_border")

		if (player_table) {
			for (const data of Object.values(Game.upgrades_data.all))
				if (player_table.upgrades[data[1]] !== undefined) {
					if (Game.UpgradeMatchesRarity(data, "purple"))
						gp = gp + 1
					if (Game.UpgradeMatchesRarity(data, "blue"))
						gb = gb + 1
					if (Game.UpgradeMatchesRarity(data, "gray"))
						gg = gg + 1
				}

			if (gg > 12)
				gray_max = Math.ceil(gg / 2)


			for (const data of Object.values(Game.upgrades_data.all)) {
				const name = data[1]
				const lvl = player_table.upgrades[name]
				if (lvl === undefined)
					continue

				//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


				if (Game.UpgradeMatchesRarity(data, "purple")) {

					purple_count = purple_count + 1

					general_purple_card[purple_count] = $.CreatePanel("Panel", LayerGray_skill[4], "general_purple_card" + purple_count)

					general_purple_card[purple_count].AddClass("general_card")

					MouseOver(general_purple_card[purple_count], $.Localize('#upgrade_disc_' + name) + '_1')


					general_purple_shadow[purple_count] = $.CreatePanel("Panel", general_purple_card[purple_count], "general_purple_shadow" + purple_count)
					general_purple_shadow[purple_count].AddClass("general_shadow")

					general_purple_image[purple_count] = $.CreatePanel("Panel", general_purple_shadow[purple_count], "general_purple_image" + purple_count)
					general_purple_image[purple_count].AddClass("general_image_purple")
					general_purple_image[purple_count].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + data[6] + '.png")';

					general_purple_image[purple_count].style.backgroundSize = "contain";
					general_purple_image[purple_count].style.backgroundRepeat = "no-repeat";


					general_purple_color[purple_count] = $.CreatePanel("Panel", general_purple_shadow[purple_count], "general_purple_color" + purple_count)

					general_purple_color[purple_count].AddClass("general_color")
					general_purple_color[purple_count].style.washColor = "#a619ff";


					general_purple_stack[purple_count] = $.CreatePanel("Label", general_purple_shadow[purple_count], "general_purple_stack" + purple_count)

					general_purple_stack[purple_count].AddClass("general_stack")

					if (lvl > 1) {
						general_purple_stack[purple_count].text = String(lvl)
					}

					if (gp > 6) {
						number = 0
						number = (96 / gp)

						text = String(number) + '%'
						general_purple_card[purple_count].style.height = text

						number = number * 5.1468
						text = String(number) + '%'
						general_purple_card[purple_count].style.width = text

						number = (100 - number) / 2
						text = String(number) + '%'
						general_purple_card[purple_count].style.marginLeft = text

						general_purple_stack[purple_count].style.fontSize = '22px'


					}

				}


				if (Game.UpgradeMatchesRarity(data, "blue")) {

					blue_count = blue_count + 1

					general_blue_card[blue_count] = $.CreatePanel("Panel", LayerGray_skill[3], "general_blue_card" + blue_count)

					general_blue_card[blue_count].AddClass("general_card")

					MouseOver(general_blue_card[blue_count], $.Localize('#upgrade_disc_' + name + '_' + lvl))


					general_blue_shadow[blue_count] = $.CreatePanel("Panel", general_blue_card[blue_count], "general_blue_shadow" + blue_count)
					general_blue_shadow[blue_count].AddClass("general_shadow")

					general_blue_image[blue_count] = $.CreatePanel("Panel", general_blue_shadow[blue_count], "general_blue_image" + blue_count)
					general_blue_image[blue_count].AddClass("general_image_blue")
					general_blue_image[blue_count].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + data[6] + '.png")';

					general_blue_image[blue_count].style.backgroundSize = "contain";
					general_blue_image[blue_count].style.backgroundRepeat = "no-repeat";


					general_blue_color[blue_count] = $.CreatePanel("Panel", general_blue_shadow[blue_count], "general_blue_color" + blue_count)

					general_blue_color[blue_count].AddClass("general_color")
					general_blue_color[blue_count].style.washColor = "#1a99e8";


					general_blue_stack[blue_count] = $.CreatePanel("Label", general_blue_shadow[blue_count], "general_blue_stack" + blue_count)

					general_blue_stack[blue_count].AddClass("general_stack")

					if (lvl > 1)
						general_blue_stack[blue_count].text = String(lvl)

					if (gb > 6) {
						number = 0
						number = (96 / gb)

						text = String(number) + '%'
						general_blue_card[blue_count].style.height = text

						number = number * 5.1468
						text = String(number) + '%'
						general_blue_card[blue_count].style.width = text

						number = (100 - number) / 2
						text = String(number) + '%'
						general_blue_card[blue_count].style.marginLeft = text

						general_blue_stack[blue_count].style.fontSize = '22px'
					}

				}


				if (Game.UpgradeMatchesRarity(data, "gray")) {

					gray_count = gray_count + 1

					if (gray_count <= gray_max) {
						general_gray_card[gray_count] = $.CreatePanel("Panel", LayerGray_skill[1], "general_gray_card" + gray_count)
					} else {
						general_gray_card[gray_count] = $.CreatePanel("Panel", LayerGray_skill[2], "general_gray_card" + gray_count)
					}

					general_gray_card[gray_count].AddClass("general_card")


					var t = '+' + String(Math.trunc(lvl * data[8] * (1 + 0.3 * player_table.hasup))) + $.Localize('#talent_disc_' + name)

					MouseOver(general_gray_card[gray_count], t)

					general_gray_shadow[gray_count] = $.CreatePanel("Panel", general_gray_card[gray_count], "general_gray_shadow" + gray_count)
					general_gray_shadow[gray_count].AddClass("general_shadow")

					general_gray_image[gray_count] = $.CreatePanel("Panel", general_gray_shadow[gray_count], "general_gray_image" + gray_count)
					general_gray_image[gray_count].AddClass("general_image_gray")
					general_gray_image[gray_count].style.backgroundImage = 'url("file://{images}/custom_game/icons/mini/general/' + data[6] + '.png")';

					general_gray_image[gray_count].style.backgroundSize = "contain";
					general_gray_image[gray_count].style.backgroundRepeat = "no-repeat";


					general_gray_color[gray_count] = $.CreatePanel("Panel", general_gray_shadow[gray_count], "general_gray_color" + gray_count)

					general_gray_color[gray_count].AddClass("general_color")
					general_gray_color[gray_count].style.washColor = "#e9e9e9";

					general_gray_stack[gray_count] = $.CreatePanel("Label", general_gray_shadow[gray_count], "general_gray_stack" + gray_count)

					general_gray_stack[gray_count].AddClass("general_stack")

					if (lvl > 9)
						general_gray_stack[gray_count].style.marginLeft = "0px"
					else if (lvl > 1)
						general_gray_stack[gray_count].text = String(lvl)


					if (gg > 12) {
						number = 0
						number = (96 / Math.ceil(gg / 2))

						text = String(number) + '%'
						general_gray_card[gray_count].style.height = text

						number = number * 5.1468
						text = String(number) + '%'
						general_gray_card[gray_count].style.width = text

						number = (100 - number) / 2
						text = String(number) + '%'
						general_gray_card[gray_count].style.marginLeft = text

						general_gray_stack[gray_count].style.fontSize = '22px'


					}

				}


			}
		}
	}
}


function delete_space() {


	var LayerGeneral = $.GetContextPanel().FindChildTraverse("LayerGeneralEnd");

	LayerGeneral.RemoveAndDeleteChildren();

}







var points_count = 0
var max_points = 0

var places_points = [14,12,10,8,6,4]
var kills_inc = 1
var kills_max = 10
var towers_inc = 4
var bounty_inc = 0.5
var bounty_max = 10

var gained_exp = 0
var init_exp = 0
var max_exp = 0
var current_exp = 0
var level = 0
var max_level = 30
var player_hero = ''
var place_taken = 0

var level_thresh = [6,12,18,25,30]
var place_exp = [40,30,25,20,15,10]

var can_add_exp = false

var account_points = 0
var max_account_points = 500

var sub_random_inc = 1.15

var subscribed = 0

var thresh = [50,60,70,80, 100,120,140,160,180,200, 230,260,290,320,350,380, 420,460,500,540,580,620,680, 800,900,1000,1100,1200, 1500 ]

var sound  
var sound_exp

var valid_time = 0

var window_init = false 


var closed = true

var quest_complete = false
var quest_icon = ""
var quest_exp = 0
var quest_shards = 0




function ShowHeroQuest(icon, exp, shards)
{
	let main = $.GetContextPanel().FindChildTraverse("EndScreenQuest")

	main.RemoveClass("EndScreenQuest_hide")
	main.RemoveClass("EndScreenQuest_hidden")
	main.AddClass("EndScreenQuest_show")
	
	$.Schedule(0.5, function()
	{ 	
		if (!main.BHasClass("EndScreenQuest_hide"))
		{
			main.RemoveClass("EndScreenQuest_show")
			main.AddClass("EndScreenQuest")
		}
	})

	let icon_panel = $.GetContextPanel().FindChildTraverse("EndScreenQuest_icon")

	icon_panel.style.backgroundImage = "url('file://{images}/custom_game/icons/skills/" + icon + ".png')"
	icon_panel.style.backgroundSize = "contain"


	let exp_panel = $.GetContextPanel().FindChildTraverse("EndScreenQuest_text_exp")

	exp_panel.text = '+' + String(exp)

	let shards_panel = $.GetContextPanel().FindChildTraverse("EndScreenQuest_text_shards")

	shards_panel.text = '+' + String(shards)
}








function delete_end_screen()
{
	var EndScreenPoints = $.GetContextPanel().FindChildTraverse("EndScreenPoints")
	EndScreenPoints.RemoveClass("EndScreenPoints_show")
	EndScreenPoints.AddClass("EndScreenPoints")

	var Quests = $.GetContextPanel().FindChildTraverse("EndScreenQuest")

	if (quest_complete == 1)
	{
		Quests.RemoveClass("EndScreenQuest_show")
		Quests.RemoveClass("EndScreenQuest")
		Quests.AddClass("EndScreenQuest_hide")
	}
}


function EndScreen_game_end(kv)
{
	var EndScreenPoints = $.GetContextPanel().FindChildTraverse("EndScreenPoints")

	if (!EndScreenPoints)
	{
		return
	}
	if (window_init == true)
	{
		return 
	}	
	window_init = true 
	EndScreenPoints.RemoveClass("EndScreenPoints")
	EndScreenPoints.AddClass("EndScreenPoints_show")


	closed = false

	$.Msg(kv.quest_table)

	if ((kv.quest_table) && (kv.quest_table.completed))
	{
		quest_complete = kv.quest_table.completed
		quest_icon = kv.quest_table.icon
		quest_exp = kv.quest_table.exp
		quest_shards = kv.quest_table.shards
	}


	can_add_exp = false

	subscribed = 0

	place_taken = kv.place
	var kills =  kv.kills
	var towers = kv.towers
	var bounty = kv.runes

	var init_exp = 0
	level = 1
	account_points = 0

	player_hero = Entities.GetUnitName( Players.GetPlayerHeroEntityIndex( Players.GetLocalPlayer() ) )




	account_points = kv.points
	subscribed = kv.subscribed
	valid_time = kv.valid_time

	level = kv.level
	init_exp = kv.exp


    max_exp = thresh[level - 1]

	ShowPoints(kills, towers, bounty, kv.randomed)


	var SubButton_active = $.GetContextPanel().FindChildTraverse("ShardsBot_Plus_active")
	var SubButton_date = $.GetContextPanel().FindChildTraverse("ShardsBot_Plus_date")
	var SubButton_info = $.GetContextPanel().FindChildTraverse("SubButton")
	var SubButton_text = $.GetContextPanel().FindChildTraverse("ShardsBot_Plus")

	var info_text = $.Localize("#Sub_info")




	if (subscribed == 1)
	{
		gained_exp = place_exp[place_taken - 1]

		if (kv.randomed == 1)
		{
			gained_exp = Math.floor(gained_exp*sub_random_inc) 
		}

		if (valid_time == 0)
		{
			gained_exp = 0
		}
	
		SubButton_info.AddClass("ShardsBot_hidden")
		SubButton_text.AddClass("ShardsBot_hidden")
		SubButton_active.RemoveClass("ShardsBot_hidden")
		SubButton_date.RemoveClass("ShardsBot_hidden")

	}else
	{

		SubButton_info.RemoveClass("ShardsBot_hidden")
		SubButton_text.RemoveClass("ShardsBot_hidden")
		SubButton_active.AddClass("ShardsBot_hidden")
		SubButton_date.AddClass("ShardsBot_hidden")

		SubButton_info.SetPanelEvent('onmouseover', function() {
			$.DispatchEvent('DOTAShowTextTooltip', SubButton_info, info_text)
		});


		SubButton_info.SetPanelEvent('onmouseout', function() {
			$.DispatchEvent('DOTAHideTextTooltip', SubButton_info);
		});


		SubButton_info.SetPanelEvent("onactivate", function() 
		{	
			GameUI.CustomUIConfig().OpenShop()
			GameUI.CustomUIConfig().OpenShopPlus("shop_window_1", "inshop_button_sub")
		});	

	}

	gained_exp = gained_exp + quest_exp

	var RandomBonus = $.GetContextPanel().FindChildTraverse("RandomBonus")


	if (kv.randomed == 1 && valid_time == 1)
	{
		RandomBonus.AddClass("RandomBonus")
		RandomBonus.RemoveClass("RandomBonus_hidden")



		var info_text_bonus = $.Localize("#RandomBonus_info")

		RandomBonus.SetPanelEvent('onmouseover', function() {
			$.DispatchEvent('DOTAShowTextTooltip', RandomBonus, info_text_bonus)
		});


		RandomBonus.SetPanelEvent('onmouseout', function() {
			$.DispatchEvent('DOTAHideTextTooltip', RandomBonus);
		});


	}else 
	{
		RandomBonus.AddClass("RandomBonus_hidden")
		RandomBonus.RemoveClass("RandomBonus")

	}


	InitHeroLevel(init_exp, gained_exp)




}








function AddPoints()
{
	var count = $.GetContextPanel().FindChildTraverse("ShardsCount_text")
	var bot_count = $.GetContextPanel().FindChildTraverse("ShardsBotCount_text")


	count.text = '+' + String(points_count)

	var max_text = ''
	if (subscribed == 0) 
	{
		max_text = '/' + String(max_account_points)
	}

	bot_count.text = String(account_points) + max_text


	if ((points_count < max_points) && ((account_points < max_account_points) || (subscribed == 1)  ))
	{

		points_count = points_count + 1
		account_points = account_points + 1

		$.Schedule(1.5 / max_points , function() 
			{AddPoints()}
		)
	}
	else 
	{
		Game.StopSound(sound)
		Game.EmitSound("Sub.Points_end")
		if ((account_points >= max_account_points) && (subscribed == 0) )
		{
			bot_count.AddClass("Max_points")
			count.AddClass("Max_points")
		}


		can_add_exp = true

		if ((closed == false)&&(quest_complete==true))
		{
			ShowHeroQuest(quest_icon, quest_exp, quest_shards)
		}


		var tier = 0
		var j = 0

		for (var i = 0; i <= level; i++) {
			if (i >= level_thresh[j])
			{
				j = j + 1
				tier = tier + 1
			} 
		}

		if (tier < 5)
		{

			var place_text = $.GetContextPanel().FindChildTraverse("PlaceForLevel_place")
			place_text.text = String(place_taken) + $.Localize("#place_for_level")

			var level_text = $.GetContextPanel().FindChildTraverse("PlaceForLevel_level")
			level_text.text = '+' + String(gained_exp)
			level_text.AddClass("Exp_for_place_" + String(tier))
			sound_exp = Game.EmitSound("Sub.Exp_count")
		}
	}
}







function ShowPoints(kills_n, towers_n, bounty_n, randomed)
{
	var main = $.GetContextPanel().FindChildTraverse("EndScreenPoints")

	var kills = $.GetContextPanel().FindChildTraverse("ShardsCount_kills")
	var towers = $.GetContextPanel().FindChildTraverse("ShardsCount_towers")
	var bounty = $.GetContextPanel().FindChildTraverse("ShardsCount_bounty")
	var place = $.GetContextPanel().FindChildTraverse("ShardsCount_place")

	kills.AddClass("ShardInfo_label_hide")
	towers.AddClass("ShardInfo_label_hide")
	bounty.AddClass("ShardInfo_label_hide")
	place.AddClass("ShardInfo_label_hide")




	points_count = 0


	max_points = Math.min(kills_n*kills_inc, kills_max) + places_points[place_taken - 1] + towers_n*towers_inc + Math.floor(Math.min(bounty_n*bounty_inc, bounty_max))

	max_points = max_points
	
	if (randomed == 1)
	{
		max_points = Math.floor(max_points * sub_random_inc) 
	}

	if (valid_time == 0)
	{
		max_points = 0
	}

	max_points = max_points + quest_shards

	sound = Game.EmitSound("Sub.Points_inc")
	AddPoints()

	$.Schedule(0.33, function()
	{ 	
		ShowShards_Place(kills_n, towers_n, bounty_n)
	})

}



function ShowShards_Place(kills, towers, bounty)
{
	var label = $.GetContextPanel().FindChildTraverse("ShardsCount_place")
	label.RemoveClass("ShardInfo_label_hide")
	label.AddClass("ShardInfo_label_show")

	var points = $.GetContextPanel().FindChildTraverse("ShardsInfo_place_text_points")

	let bonus = String(places_points[place_taken - 1])

	if (valid_time == 0)
	{
		bonus = 0
	}
	
	points.text = '(+' + bonus + ')';

	var text = $.GetContextPanel().FindChildTraverse("ShardsInfo_place_text")
	text.html = true;
	text.text =$.Localize("#shard_place") + String(place_taken)

	$.Schedule(0.33, function()
	{ 	
 		ShowShards_Kills( kills, towers, bounty)
	})

}



function ShowShards_Kills( kills, towers, bounty)
{
	var label = $.GetContextPanel().FindChildTraverse("ShardsCount_kills")
	label.RemoveClass("ShardInfo_label_hide")
	label.AddClass("ShardInfo_label_show")

	var text = $.GetContextPanel().FindChildTraverse("ShardsInfo_kills_text")
	var points = $.GetContextPanel().FindChildTraverse("ShardsInfo_kills_text_points")



	let bonus = String(Math.min(kills*kills_inc, kills_max) )

	if (valid_time == 0)
	{
		bonus = 0
	}

	points.text = '(+' + bonus + ')';

	text.html = true;
	var str = String(kills)
	if (kills > 10)
	{
		str = '10+'
	}

	text.text = $.Localize("#shard_kills") + str

	$.Schedule(0.33, function()
	{ 	
 		ShowShards_towers( towers, bounty)
	})

}


function ShowShards_towers( towers, bounty)
{
	var label = $.GetContextPanel().FindChildTraverse("ShardsCount_towers")
	label.RemoveClass("ShardInfo_label_hide")
	label.AddClass("ShardInfo_label_show")


	var points = $.GetContextPanel().FindChildTraverse("ShardsInfo_towers_text_points")


	let bonus = String(towers*towers_inc)

	if (valid_time == 0)
	{
		bonus = 0
	}


	points.text = '(+' + bonus + ')';

	var text = $.GetContextPanel().FindChildTraverse("ShardsInfo_towers_text")
	text.html = true;
	text.text = $.Localize("#shard_towers") + String(towers)

	$.Schedule(0.33, function()
	{ 	
 		ShowShards_bounty(bounty)
	})

}



function ShowShards_bounty(bounty)
{


	var label = $.GetContextPanel().FindChildTraverse("ShardsCount_bounty")
	label.RemoveClass("ShardInfo_label_hide")
	label.AddClass("ShardInfo_label_show")

	var points = $.GetContextPanel().FindChildTraverse("ShardsInfo_bounty_text_points")


	let bonus = Math.floor(String(Math.min(bounty*bounty_inc, bounty_max) ))

	if (valid_time == 0)
	{
		bonus = 0
	}



	points.text = '(+' + bonus + ')';


	var str = String(bounty)
	if (bounty > 20)
	{
		str = '20+'
	}


	$.Msg($.Localize("#shard_bounty") + str)
	var text = $.GetContextPanel().FindChildTraverse("ShardsInfo_bounty_text")
	text.html = true;
	text.text = $.Localize("#shard_bounty") + str



}



function InitHeroLevel(exp, gained)
{
	var hero_icon = $.GetContextPanel().FindChildTraverse("HeroLevel_icon")
	var hero_level = $.GetContextPanel().FindChildTraverse("HeroLevel_level")
    var level_text = $.GetContextPanel().FindChildTraverse("HeroLevel_bar_text")

	let bar = $.GetContextPanel().FindChildTraverse("HeroLevel_bar")
	let filler = $.GetContextPanel().FindChildTraverse("HeroLevel_bar_filler")

    hero_icon.style.backgroundImage = 'url( "file://{images}/heroes/icons/' + player_hero + '.png" );'
    hero_icon.style.backgroundSize = 'contain';

	var tier = 0
	var j = 0

	for (var i = 0; i <= level; i++) {
		if (i >= level_thresh[j])
		{
			j = j + 1
			tier = tier + 1
		} 
	}
    

    if (tier < 5)
    {
    	gained_exp = gained
    	init_exp = exp
    	current_exp = 0
    	AddLevel()
    }
    else
    {
    	if (subscribed == 1)
    	{
    		level_text.text = $.Localize('#hero_level') + String(level)
    	}
    	else 
    	{
    		level_text.text = $.Localize("#level_no_sub")
    	}

		filler.style.width = '97%';
    } 



    hero_level.AddClass("HeroLevel_icon_" + String(tier))
    bar.AddClass("HeroLevel_bar_" + String(tier))
    filler.AddClass("HeroLevel_filler_" + String(tier))


}



function IncLevel()
{
	init_exp = 0
	level = level + 1
    max_exp = thresh[level - 1]

    Game.EmitSound("Sub.Hero_levelup")

	var hero_level = $.GetContextPanel().FindChildTraverse("HeroLevel_level")

	let bar = $.GetContextPanel().FindChildTraverse("HeroLevel_bar")
	let filler = $.GetContextPanel().FindChildTraverse("HeroLevel_bar_filler")

    var tier = 0
	var j = 0

	for (var i = 0; i <= level; i++) {
		if (i >= level_thresh[j])
		{
			j = j + 1
			tier = tier + 1
		} 
	}
    

    hero_level.AddClass("HeroLevel_icon_" + String(tier))
    bar.AddClass("HeroLevel_bar_" + String(tier))
    filler.AddClass("HeroLevel_filler_" + String(tier))

}










function AddLevel()
{


	let filler = $.GetContextPanel().FindChildTraverse("HeroLevel_bar_filler")
    var level_text = $.GetContextPanel().FindChildTraverse("HeroLevel_bar_text")
	if (level == max_level)
	{
		let text = '97%'
		filler.style.width = text
    	level_text.text = $.Localize('#hero_level') + String(level)
		Game.StopSound(sound_exp)
		return
	}

	let width = ( (init_exp)/max_exp) * 98

	if (subscribed == 1)
	{
    	level_text.text = $.Localize('#hero_level') + String(level) + ' ' + String(init_exp) + '/' + String(max_exp)
    }
    else 
    {
    	level_text.text = $.Localize("#level_no_sub")
    }

	let text = String(width)+'%'
	filler.style.width = text


	if (can_add_exp == false)
	{

		$.Schedule(0.1, function()
		{
			AddLevel()
		})
		return
	}



	if (current_exp < gained_exp)
	{
		current_exp = current_exp + 1
		init_exp = init_exp + 1

		if (init_exp >= max_exp)
		{
			IncLevel()
		}

		$.Schedule(1.5 / gained_exp, function()
		{
			AddLevel()
		})
	}
	else 
	{
		Game.StopSound(sound_exp)
	}
}





function PortraitClicked()
{
	// TODO: ctrl and alt click support
	Players.PlayerPortraitClicked( $.GetContextPanel().GetAttributeInt( "player_id", -1 ), false, false );
}




init()