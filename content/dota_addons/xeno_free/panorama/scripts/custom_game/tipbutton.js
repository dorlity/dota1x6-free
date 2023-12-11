var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements");
$.GetContextPanel().SetParent(parentHUDElements);

CustomNetTables.SubscribeNetTableListener( "TipsType", TypeChanged );

function SwapTipType() {

	let table = CustomNetTables.GetTableValue("TipsType", Players.GetLocalPlayer())

	Game.EmitSound("UI.Click")

	if (table) {
		if (table.type == 1) {
			GameEvents.SendCustomGameEventToServer_custom("ChangeTipsType", {type:2});
		} else if (table.type == 2) {
			GameEvents.SendCustomGameEventToServer_custom("ChangeTipsType", {type:3});
		} else if (table.type == 3) {
			GameEvents.SendCustomGameEventToServer_custom("ChangeTipsType", {type:1});
		}
	}
}

function TypeChanged(table_name, key, data) {
	if (key == Players.GetLocalPlayer()) {
		$("#SwapTipType").SetHasClass("type_1", false)
		$("#SwapTipType").SetHasClass("type_2", false)
		$("#SwapTipType").SetHasClass("type_3", false)
		$("#SwapTipType").SetHasClass("type_"+data.type, true)
		SetText($("#TipPanel"), $.Localize("#button_tip_" + data.type))
	}
}

function SetText(panel, text) {
	panel.SetPanelEvent('onmouseover', function() 
	{
		$.DispatchEvent('DOTAShowTextTooltip', panel, text) 
	});
		panel.SetPanelEvent('onmouseout', function() 
	{
		$.DispatchEvent('DOTAHideTextTooltip', panel);
	});
}

