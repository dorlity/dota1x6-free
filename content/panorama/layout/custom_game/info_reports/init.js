function init()
{
    GameEvents.Subscribe_custom('give_bonus_shards', give_bonus_shards)
    GameEvents.Subscribe_custom('show_active_vote', show_active_vote)
    GameEvents.Subscribe_custom('show_new_shop_heroes', show_new_shop_heroes)
    GameEvents.Subscribe_custom('shop_new_promo', shop_new_promo)
    //GameEvents.Subscribe_custom('get_payment_url', get_payment_url)
    GameEvents.Subscribe_custom('answer_promo_code', answer_promo_code)
    GameEvents.Subscribe_custom('shop_global_sale', shop_global_sale)
    GameEvents.Subscribe_custom('shop_update_tips_and_fives', shop_update_tips_and_fives)

    let sub_data = player_table_shop
    let shop_button = $.GetContextPanel().FindChildTraverse("shop_button")
    let sub_date = $.GetContextPanel().FindChildTraverse("InfoHeaderLabel_active_sub")
    let sub_label = $.GetContextPanel().FindChildTraverse("ButtonBuySubscribeLabel")
    let data = PLAYER_SERVER_DATA
    let lang = $.Localize("#lang")

    if (sub_data && sub_data.subscribed == 1)
    {
        let time = sub_data.sub_time
        let days = Math.floor((time/3600)/24)
        let display = String(days) + $.Localize("#pass_active_sub_days")
        if (days < 1)
        {
            display = String(Math.max(0, Math.floor(((time/3600)/24 - days)*24))) + $.Localize("#pass_active_sub_hours")
        }
        display = $.Localize("#pass_active_sub") + ' ' + display
        sub_date.text = display
        sub_label.text = $.Localize("#pass_header_top_button_active")
    }

    if ((data && data.total_games && data.total_games >= max_games) || lang == "rus")
    {
       shop_button.style.opacity = "1";
    }
    else 
    {
       shop_button.style.opacity = "0";
    }

    let info_button = $.GetContextPanel().FindChildTraverse("info_button")
    info_button.SetPanelEvent("onactivate", function() { Info_window_show() });
    info_button.SetPanelEvent('onmouseover', function() { $.DispatchEvent('DOTAShowTextTooltip', info_button, text) });
    info_button.SetPanelEvent('onmouseout', function() { $.DispatchEvent('DOTAHideTextTooltip', info_button) });

    let leaderbord_button = $.GetContextPanel().FindChildTraverse("leaderbord_button")
    leaderbord_button.SetPanelEvent("onactivate", function() { leaderbord_window_show() });
    leaderbord_button.SetPanelEvent('onmouseover', function() { $.DispatchEvent('DOTAShowTextTooltip', leaderbord_button, text2) });
    leaderbord_button.SetPanelEvent('onmouseout', function() { $.DispatchEvent('DOTAHideTextTooltip', leaderbord_button) });

    shop_button.SetPanelEvent("onactivate", function() { GameUI.CustomUIConfig().OpenShop()});

    var text = $.Localize("#info_button")
    var text2 = $.Localize("#leaderbord_button")

    var currency_info = $.GetContextPanel().FindChildTraverse("CurrencyInfo")
    if (currency_info) 
    {
        let text = $.Localize("#shop_shards_info")
        currency_info.SetPanelEvent('onmouseover', function() 
        {
            $.DispatchEvent('DOTAShowTextTooltip', currency_info, text) 
        });   
        currency_info.SetPanelEvent('onmouseout', function() 
        {
            $.DispatchEvent('DOTAHideTextTooltip', currency_info);
        });
    }

    // Check Items
    var heroes_buy_button = $.GetContextPanel().FindChildTraverse("heroes_buy_button")
    if (heroes_buy_button)
    {
        let text = $.Localize("#info_bought")
        heroes_buy_button.SetPanelEvent('onmouseover', function() 
        {
            $.DispatchEvent('DOTAShowTextTooltip', heroes_buy_button, text) 
        });    
        heroes_buy_button.SetPanelEvent('onmouseout', function() 
        {
            $.DispatchEvent('DOTAHideTextTooltip', heroes_buy_button);
        });

        heroes_buy_button.SetPanelEvent('onactivate', function() 
        {
            Game.EmitSound("UI.Click")
            if (PLAYER_VIEW_ITEMS_FOR_BUY)
            {
                PLAYER_VIEW_ITEMS_FOR_BUY = false
                heroes_buy_button.RemoveClass("buy_items_show_button_off")
                heroes_buy_button.AddClass("buy_items_show_button_on")
            }
            else
            {
                PLAYER_VIEW_ITEMS_FOR_BUY = true
                heroes_buy_button.RemoveClass("buy_items_show_button_on")
                heroes_buy_button.AddClass("buy_items_show_button_off")
            }
            let ItemsList = $.GetContextPanel().FindChildTraverse("ItemsList")
            if (ItemsList)
            {
                ItemsList.style.visibility = "visible"
            }
            InitShopItemsForHero(ItemsList)
            UpdateOnlyCouriers()
            InitItems()
        });  
    }

    CheckShards()

    if (IsSpectator())
    {
        $("#info_reports_buttons").style.opacity = "0"
        $("#info_reports_buttons").style.visibility = "collapse"
    }
}

function InitItems()
{
	let items_panel = $.GetContextPanel().FindChildTraverse("HeroListItems")
    if (items_panel)
    {
        items_panel.RemoveAndDeleteChildren()
        InitHeroesItems()
    }

    let cosmetics_panel = $.GetContextPanel().FindChildTraverse("CategoryCosmeticsContent")
    if (cosmetics_panel)
    {
        cosmetics_panel.RemoveAndDeleteChildren()
        InitCosmeticsItems(cosmetics_panel)
    }

    let CategoryChest = $.GetContextPanel().FindChildTraverse("CategoryChest")
	if (CategoryChest)
	{
		CategoryChest.RemoveAndDeleteChildren()
        let text_panel = $.CreatePanel("Panel", CategoryChest, "");
        text_panel.AddClass("pets_info_panel");
        let text_panel_text = $.CreatePanel("Label", text_panel, "");
        text_panel_text.AddClass("slot_name");
        text_panel_text.html = true
        text_panel_text.text = $.Localize("#chest_unique_chest")
		let chest_info_table = CustomNetTables.GetTableValue("shop_items", "chest")
		let new_table = []
		if (chest_info_table)
		{
		    for (chest_id in chest_info_table)
		    {
                let chest_info = chest_info_table[chest_id]
		        new_table.push([chest_id, chest_info.chest_name, chest_info.chest_cost, chest_info.chest_image, chest_info.hide_in_chest_menu, chest_info.is_no_buy, chest_info.is_only_one_open, chest_info.is_reroll, chest_info.chest_item_id])
		    }
			new_table.sort(function (a, b) 
            {
			    return Number(a[2])-Number(b[2])
			});
			for (var i = 0; i < new_table.length; i++)
			{
				CreateChestInShop(CategoryChest, new_table[i])
			}
		}
	}

	let CategoryPets = $.GetContextPanel().FindChildTraverse("CategoryPets")
	if (CategoryPets)
	{
		CategoryPets.RemoveAndDeleteChildren()
        let text_panel = $.CreatePanel("Panel", CategoryPets, "");
        text_panel.AddClass("pets_info_panel");
        let text_panel_text = $.CreatePanel("Label", text_panel, "");
        text_panel_text.AddClass("pets_info_text");
        text_panel_text.html = true
        text_panel_text.text = $.Localize("#pets_info_text")
		let pets_info_table = CustomNetTables.GetTableValue("shop_items", "pets")
		let new_table = []
		if (pets_info_table)
		{
		    for (var item = 1; item <= Object.keys(pets_info_table).length; item++)
		    {
		        new_table[item-1] = []
		        new_table[item-1].push(pets_info_table[item][1], pets_info_table[item][2], pets_info_table[item][3], pets_info_table[item][4], pets_info_table[item][5])
		    }
			new_table.sort(function (a, b) 
            {
			    return Number(a[3])-Number(b[3])
			});
			for (var i = 0; i < new_table.length; i++)
			{
				if (HasItemInventory(new_table[i][0]))
				{
                    let info = new_table[i]
                    CreatePanelInStore({
                        parent : CategoryPets,
                        item_id : info[0],
                        item_image : info[4],
                        item_name : info[2],
                        shard_cost : info[3],
                        item_type : "pet",
                        all_info : info,
                    })
				}
			}
			for (var i = 0; i < new_table.length; i++)
			{
				if (!HasItemInventory(new_table[i][0]))
				{
                    let info = new_table[i]
                    CreatePanelInStore({
                        parent : CategoryPets,
                        item_id : info[0],
                        item_image : info[4],
                        item_name : info[2],
                        shard_cost : info[3],
                        item_type : "pet",
                        all_info : info,
                    })
				}
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

init();