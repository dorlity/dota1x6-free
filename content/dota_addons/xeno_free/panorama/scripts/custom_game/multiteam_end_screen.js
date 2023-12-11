"use strict";

function InitEndScreen() {
	const CustomUIContainerHUD = $.GetContextPanel().GetParent()
	for (const panel of CustomUIContainerHUD.Children())
		if (panel.BHasClass("MainPick"))
			panel.style.visibility = "collapse"
	var dotahud = $.GetContextPanel().GetParent().GetParent().GetParent().GetParent()
    dotahud.FindChildTraverse("TopBarScoreboard").style.visibility = 'collapse'

	const CustomUIRoot = CustomUIContainerHUD.GetParent()
	const HeroSelection = CustomUIRoot.FindChild("CustomUIContainer_HeroSelection")
	if (HeroSelection !== null)
		HeroSelection.style.visibility = "collapse"
	const HudTopBar = CustomUIRoot.FindChild("CustomUIContainer_HudTopBar")
	if (HudTopBar !== null)
		HudTopBar.style.visibility = "collapse"
	$.GetContextPanel().style.visibility = "visible"

	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/multiteam_end_screen_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/multiteam_end_screen_player.xml",
	};

	var endScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" ) );
	$.GetContextPanel().SetHasClass( "endgame", 1 );
	
	var teamInfoList = ScoreboardUpdater_GetSortedTeamInfoList( endScoreboardHandle );
	var delay = 0.2;
	var delay_per_panel = 1 / teamInfoList.length;
	for ( var teamInfo of teamInfoList )
	{
		var teamPanel = ScoreboardUpdater_GetTeamPanel( endScoreboardHandle, teamInfo.team_id );
	
		if (teamPanel)
		{
			teamPanel.SetHasClass( "team_endgame", false );
			var callback = function( panel )
			{
				return function(){ panel.SetHasClass( "team_endgame", 1 ); }
			}( teamPanel );
			$.Schedule( delay, callback )
			delay += delay_per_panel;
		}
	}
	
	var winningTeamId = Game.GetGameWinner();
	var winningTeamDetails = Game.GetTeamDetails( winningTeamId );
	var endScreenVictory = $( "#EndScreenVictory" );
	if ( endScreenVictory )
	{
		endScreenVictory.SetDialogVariable( "winning_team_name", $.Localize( winningTeamDetails.team_name ) );
		if ( GameUI.CustomUIConfig().team_colors )
		{
			var teamColor = GameUI.CustomUIConfig().team_colors[ winningTeamId ];
			teamColor = teamColor.replace( ";", "" );
			endScreenVictory.style.color = teamColor + ";";
		}
	}

	var winningTeamLogo = $( "#WinningTeamLogo" );
	if ( winningTeamLogo )
	{
		var logo_xml = GameUI.CustomUIConfig().team_logo_large_xml;
		if ( logo_xml )
		{
			winningTeamLogo.SetAttributeInt( "team_id", winningTeamId );
			winningTeamLogo.BLoadLayout( logo_xml, false, false );
		}
	}
}

function CheckForEndGame() {
	const val = CustomNetTables.GetTableValue("networth_players", "")
	if (val !== undefined && val.game_ended) {
		InitEndScreen()
		return
	}
	$.GetContextPanel().style.visibility = "collapse"
	$.Schedule(0.2, CheckForEndGame)
}

CheckForEndGame()
