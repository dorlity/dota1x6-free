GameUI.CustomUIConfig().InitItemsForPlayer = function InitItemsForPlayer(hero_name)
{
    $.GetContextPanel().RemoveClass("panel_hidden_right_items")
    $.GetContextPanel().AddClass("panel_open_right_items")
    $("#HeroListItemsSelection").RemoveAndDeleteChildren()
    current_shop_hero_choose = hero_name
    UpdateShards()
    InitShopItemsForHero($("#HeroListItemsSelection"))
}

GameUI.CustomUIConfig().CloseItemsPanelSelection = function CloseItemsPanelSelection()
{
    $.GetContextPanel().RemoveClass("panel_open_right_items")
    $.GetContextPanel().AddClass("panel_close_right_items")
    $.Schedule(0.65, function() 
    {
        $.GetContextPanel().RemoveClass("panel_close_right_items")
        $.GetContextPanel().AddClass("panel_hidden_right_items")
    })
}

function OpenItemsPanelSelection()
{
    $("#HeroSelectionItemsPreview").SetHasClass("ButtonSwapPreviewClosed", !$("#HeroSelectionItemsPreview").BHasClass("ButtonSwapPreviewClosed"))
}

function activate_but_button()
{
    Game.EmitSound("UI.Shop_Category_Open")
    GameEvents.SendCustomGameEventToServer_custom( "browser_subscribe", {item_name: "shards"});  
}

GameUI.CustomUIConfig().PlayerHasItemInSelection = function PlayerHasItemInSelection(hero_name)
{
    if (!SAVE_DATA_SETS_ITEMS[String(hero_name)])
    {
        SAVE_DATA_SETS_ITEMS[String(hero_name)] = CustomNetTables.GetTableValue("heroes_items_info", String(hero_name));
    }
    let items = SAVE_DATA_SETS_ITEMS[String(hero_name)]
    if (!items)
    {
        return false
    }
    let data = CustomNetTables.GetTableValue("server_data", String(Players.GetLocalPlayer()));
    let lang = $.Localize("#lang")
    if ((data && data.total_games && data.total_games >= max_games) || lang == "rus")
    {
        return true
    }
    else 
    {
        return false
    }
}