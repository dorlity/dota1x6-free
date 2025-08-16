function CreatePanelInStore(data)
{
    let player_data_local = player_table_shop

    let BlockItem = $.CreatePanel("Panel", data.parent, "item_id_" + data.item_id);
    BlockItem.AddClass(data.styles?.[0] ? data.styles?.[0] : "BlockItem");

    let BlockItemImage = $.CreatePanel("Panel", BlockItem, "BlockItemImage");
	BlockItemImage.AddClass(data.styles?.[1] ? data.styles?.[1] : "BlockItemImage");
    BlockItemImage.style.backgroundImage = 'url("' + data.item_image + '")';
	BlockItemImage.style.backgroundSize = "100%"

	let BlockItemLabel = $.CreatePanel("Label", BlockItem, "");
    BlockItemLabel.AddClass(data.styles?.[2] ? data.styles?.[2] : "BlockItemLabel");
    BlockItemLabel.text = $.Localize("#" + data.item_name)

	let BlockItemBuyButton = $.CreatePanel("Panel", BlockItem, "button");
    BlockItemBuyButton.AddClass(data.styles?.[3] ? data.styles?.[3] : "BlockItemBuyButton");

	let BlockItemBuyButtonCenter = $.CreatePanel("Panel", BlockItemBuyButton, "");
	BlockItemBuyButtonCenter.AddClass("BlockItemBuyButtonCenter");

	let BlockItemBuyButtonLabel = $.CreatePanel("Label", BlockItemBuyButtonCenter, "");
    BlockItemBuyButtonLabel.AddClass(data.styles?.[4] ? data.styles?.[4] : "BlockItemBuyButtonLabel");
	BlockItemBuyButtonLabel.text = $.Localize("#shop_buy")
	BlockItemBuyButtonLabel.style.marginRight = "8px"

	let shardcost_icon = $.CreatePanel("Panel", BlockItemBuyButtonCenter, "");
	shardcost_icon.AddClass("shardcost_icon");

	let BlockItemBuyButtonLabelPrice = $.CreatePanel("Label", BlockItemBuyButtonCenter, "");
	BlockItemBuyButtonLabelPrice.AddClass("BlockItemBuyButtonLabel");
	BlockItemBuyButtonLabelPrice.text = data.shard_cost

    if (data.video)
    {
        SetVideoItemCosmeticsPreview(BlockItem, data.video)
    }
    
    if (HasItemInventory(data.item_id))
    {
        BlockItemBuyButton.style.visibility = "collapse"
        BlockItem.AddClass("BlockItem_purchased")
        
        let BlockItemActivateButton = $.CreatePanel("Panel", BlockItem, "button_activate");
        BlockItemActivateButton.AddClass(data.styles?.[3] ? data.styles?.[3] : "BlockItemBuyButton");

        let BlockItemActivateButtonLabel = $.CreatePanel("Label", BlockItemActivateButton, "BlockItemActivateButtonLabel");
        BlockItemActivateButtonLabel.AddClass("BlockItemBuyButtonLabel");

        if (data.item_type == "pet")    
        {
            SetCourierEvent(player_data_local, data.all_info, BlockItemActivateButtonLabel, BlockItem, BlockItemActivateButton)
        }
        else if (data.item_type == "five")
        {
            SetFiveEvent(player_data_local, data.all_info, BlockItemActivateButtonLabel, BlockItem, BlockItemActivateButton)
        }
        else if (data.item_type == "tip")
        {
            SetTipEvent(player_data_local, data.all_info, BlockItemActivateButtonLabel, BlockItem, BlockItemActivateButton)
        }
    } 
    else 
    {
        if (player_data_local)
        {
            if (player_data_local["points"] >= data.shard_cost)
            {
                BlockItemBuyButton.RemoveClass("BlockItemBuyButton_nomoney")
                BlockItemBuyButton.AddClass("BlockItemBuyButton_money")
                BlockItemBuyButtonLabelPrice.RemoveClass("BlockItemBuyButtonLabel_nomoney")
                BlockItemBuyButtonLabelPrice.AddClass("BlockItemBuyButtonLabel")
                BlockItem.AddClass("BlockItem_money")
                BlockItem.RemoveClass("BlockItem_nomoney")
            }
            else
            {
                BlockItem.RemoveClass("BlockItem_money")
                BlockItem.AddClass("BlockItem_nomoney")
                BlockItemBuyButton.AddClass("BlockItemBuyButton_nomoney")
                BlockItemBuyButton.RemoveClass("BlockItemBuyButton_money")
                BlockItemBuyButtonLabelPrice.AddClass("BlockItemBuyButtonLabel_nomoney")
                BlockItemBuyButtonLabelPrice.RemoveClass("BlockItemBuyButtonLabel") 
            }
            BlockItem.SetPanelEvent("onactivate", function() 
            { 
                if (data.item_type == "pet")    
                {
                    CreateBuyWindow(data.item_id, data.shard_cost, data.item_name, 0, null, (player_data_local["points"] < data.shard_cost), null, null, 1)
                }
                else
                {
                    CreateBuyWindow(data.item_id, data.shard_cost, data.item_name, 0, null, (player_data_local["points"] < data.shard_cost), null, data.all_info[1])
                }
            })
        }
        if (!PLAYER_VIEW_ITEMS_FOR_BUY)
        {
            BlockItem.style.visibility = "collapse"
        }
    }
}

function SetTipEvent(player_data_local, info, BlockItemActivateButtonLabel, BlockItem, BlockItemActivateButton)
{
    let check_active = false
    if (GetPlayerTips(info[1]))
    {
        check_active = true
    }
    if (check_active)
    {
        BlockItemActivateButtonLabel.text = $.Localize("#shop_unequip")
        SetTipUpdate(BlockItem, info[1], true)
        BlockItemActivateButton.AddClass("BlockItemBuyButton_unequip")
        BlockItemActivateButton.RemoveClass("BlockItemBuyButton_equip")
    }
    else
    {
        BlockItemActivateButtonLabel.text = $.Localize("#shop_equip")
        SetTipUpdate(BlockItem, info[1])
        BlockItemActivateButton.RemoveClass("BlockItemBuyButton_unequip")
        BlockItemActivateButton.AddClass("BlockItemBuyButton_equip")
    }
}

function SetFiveEvent(player_data_local, info, BlockItemActivateButtonLabel, BlockItem, BlockItemActivateButton)
{
    let check_active = false
    if (GetCurrentHighFive(info[1], player_data_local))
    {
        check_active = true
    }
    if (check_active)
    {
        BlockItemActivateButtonLabel.text = $.Localize("#shop_unequip")
        SetHighFiveUpdate(BlockItem, info[1], true)
        BlockItemActivateButton.AddClass("BlockItemBuyButton_unequip")
        BlockItemActivateButton.RemoveClass("BlockItemBuyButton_equip")
    }
    else
    {
        BlockItemActivateButtonLabel.text = $.Localize("#shop_equip")
        SetHighFiveUpdate(BlockItem, info[1])
        BlockItemActivateButton.RemoveClass("BlockItemBuyButton_unequip")
        BlockItemActivateButton.AddClass("BlockItemBuyButton_equip")
    }
}

function SetCourierEvent(player_data_local, info, BlockItemActivateButtonLabel, BlockItem, BlockItemActivateButton)
{
    if (player_data_local && player_data_local.pet_id)
    {
        if (player_data_local.pet_id == info[1])
        {
            courier_selected = player_data_local.pet_id;
            BlockItemActivateButtonLabel.text = $.Localize("#shop_unequip")
            BlockItem.SetPanelEvent("onactivate", function() 
            { 
                SelectCourier(info[1], info[0])
            });
            BlockItemActivateButton.AddClass("BlockItemBuyButton_unequip")
            BlockItemActivateButton.RemoveClass("BlockItemBuyButton_equip")
        }
        else
        {
            courier_selected = player_data_local.pet_id;
            BlockItemActivateButtonLabel.text = $.Localize("#shop_equip")
            BlockItem.SetPanelEvent("onactivate", function() 
            { 
                SelectCourier(info[1], info[0])
            });
            BlockItemActivateButton.RemoveClass("BlockItemBuyButton_unequip")
            BlockItemActivateButton.AddClass("BlockItemBuyButton_equip")
        }
    }
    else
    {
        courier_selected = 0;
        BlockItemActivateButtonLabel.text = $.Localize("#shop_equip")
        BlockItem.SetPanelEvent("onactivate", function() 
        { 
            SelectCourier(info[1], info[0])
        });
        BlockItemActivateButton.RemoveClass("BlockItemBuyButton_unequip")
        BlockItemActivateButton.AddClass("BlockItemBuyButton_equip")
    }
}

function SelectCourier(num, id)
{
    if (courier_selected != num)
    {
    	Game.EmitSound("UI.Shop_Buy_equip")
        GameEvents.SendCustomGameEventToServer_custom( "change_premium_pet", {pet_id: num, delete_pet:false} );
        courier_selected = num;
        UpdateEquiupPet(id)
    }
    else
    {
    	Game.EmitSound("UI.Shop_Buy_unequip")
        GameEvents.SendCustomGameEventToServer_custom( "change_premium_pet", {pet_id: 0, delete_pet: true} );
        courier_selected = 0;
        UpdateEquiupPet(0)
    }
}

function InitCosmeticsItems(main_panel)
{
    if (selected_category == "tips")
    {
        InitTipsShop(main_panel)
    }
    else if (selected_category == "high_five")
    {
        InitHighFiveShop(main_panel)
    }
}

function InitHighFiveShop(main_panel)
{
    const highFiveInfoTable = ALL_FIVE_TABLE;
    const highFiveContainer = CreateCosmeticSlotLine(main_panel, "high_five");
    const highFiveSortedItems = Object.values(highFiveInfoTable)
        .filter(item => item[2] != 0)
        .map(item => [
            item[1], item[2], item[3], 
            item[4], item[5], item[6]
        ])
        .sort((a, b) => Number(a[3]) - Number(b[3]));
    [true, false].forEach(hasItem => {
        highFiveSortedItems.forEach(item => {
            if (HasItemInventory(item[0]) === hasItem) 
            {
                CreatePanelInStore({
                    parent : highFiveContainer,
                    item_id : item[0],
                    item_image : item[4],
                    item_name : item[2],
                    shard_cost : item[3],
                    item_type : "five",
                    video : item[5],
                    styles : ["BlockItemChat", "BlockItemImageChat_high_five", "BlockItemLabelChat", "BlockItemBuyButtonChat", "BlockItemBuyButtonLabelChat"],
                    all_info : item,
                })
            }
        });
    });
}

function InitTipsShop(main_panel)
{
    const tipsInfoTable = ALL_TIPS_TABLE;
    const tipsContainer = CreateCosmeticSlotLine(main_panel, "tips");
    const playerTipsData = GetPlayerTips();
    const sortedTips = Object.values(tipsInfoTable)
        .filter(tip => tip[2] !== 0)
        .map(tip => [
            tip[1], tip[2], tip[3],
            tip[4], tip[5], tip[6]
        ])
        .sort((a, b) => Number(a[3]) - Number(b[3]));
    const [ownedTips, unownedTips] = sortedTips.reduce(
        ([owned, unowned], tip) => {
            HasItemInventory(tip[0]) ? owned.push(tip) : unowned.push(tip);
            return [owned, unowned];
        },
        [[], []]
    );
    [...ownedTips, ...unownedTips].forEach(tip => 
    {
        CreatePanelInStore({
            parent : tipsContainer,
            item_id : tip[0],
            item_image : tip[4],
            item_name : tip[2],
            shard_cost : tip[3],
            item_type : "tip",
            video : tip[5],
            styles : ["BlockItemChat", "BlockItemImageChat_high_five", "BlockItemLabelChat", "BlockItemBuyButtonChat", "BlockItemBuyButtonLabelChat"],
            all_info : tip,
        })
    });
}

function CreateCosmeticSlotLine(panel, name)
{
    let panels_category_swap = $.CreatePanel("Panel", panel, "");
    panels_category_swap.AddClass("panels_category_swap");

    let panels_category_swap_buttons = $.CreatePanel("Panel", panels_category_swap, "");
    panels_category_swap_buttons.AddClass("panels_category_swap_buttons");

    if (name == "tips")
    {   
        let keybind_panel = $.CreatePanel("Panel", panel, "");
        keybind_panel.AddClass("keybind_panel");

        let keybind_tip_name = $.CreatePanel("Label", keybind_panel, "");
        keybind_tip_name.AddClass("keybind_name");
        keybind_tip_name.html = true
        keybind_tip_name.text = $.Localize("#button_second_wheel") + " <b><font color='#f1b257'>" + GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CHAT_WHEEL2) + "</font></b>"

        let keybind_tip_name_info = $.CreatePanel("Label", keybind_panel, "");
        keybind_tip_name_info.AddClass("keybind_name_info");
        keybind_tip_name_info.html = true
        keybind_tip_name_info.text = $.Localize("#button_second_wheel_info") 
    }

    if (name == "high_five")
    {   
        let keybind_panel = $.CreatePanel("Panel", panel, "");
        keybind_panel.AddClass("keybind_panel");

        let keybind_tip_name = $.CreatePanel("Label", keybind_panel, "");
        keybind_tip_name.AddClass("keybind_name");
        keybind_tip_name.html = true
        keybind_tip_name.text = $.Localize("#button_high_five") + " <b><font color='#f1b257'>" + GetGameKeybind(DOTAKeybindCommand_t.DOTA_KEYBIND_CONTROL_GROUP4) + "</font></b>"

        let keybind_tip_name_info = $.CreatePanel("Label", keybind_panel, "");
        keybind_tip_name_info.AddClass("keybind_name_info");
        keybind_tip_name_info.html = true
        keybind_tip_name_info.text = $.Localize("#button_high_five_info") 
    }

    let slot_panel = $.CreatePanel("Panel", panel, "");
    slot_panel.AddClass("slot_panel");

    let active_buttons_category_tips = $.CreatePanel("Panel", panels_category_swap_buttons, "");
    active_buttons_category_tips.AddClass("active_buttons_category");
    active_buttons_category_tips.AddClass("active_buttons_category_first");

    let active_buttons_category_tips_icon = $.CreatePanel("Panel", active_buttons_category_tips, "");
    active_buttons_category_tips_icon.AddClass("active_buttons_category_icon");
    active_buttons_category_tips_icon.AddClass("active_buttons_category_tip_icon");

    let active_buttons_category_tips_label = $.CreatePanel("Label", active_buttons_category_tips, "");
    active_buttons_category_tips_label.AddClass("active_buttons_category_label")
    active_buttons_category_tips_label.html = true
    active_buttons_category_tips_label.text = $.Localize("#tips")

    let active_buttons_category_five = $.CreatePanel("Panel", panels_category_swap_buttons, "");
    active_buttons_category_five.AddClass("active_buttons_category");
    active_buttons_category_five.AddClass("active_buttons_category_not_first");

    let active_buttons_category_five_icon = $.CreatePanel("Panel", active_buttons_category_five, "");
    active_buttons_category_five_icon.AddClass("active_buttons_category_icon");
    active_buttons_category_five_icon.AddClass("active_buttons_category_high_five_icon");

    let active_buttons_category_five_label = $.CreatePanel("Label", active_buttons_category_five, "");
    active_buttons_category_five_label.AddClass("active_buttons_category_label")
    active_buttons_category_five_label.html = true
    active_buttons_category_five_label.text = $.Localize("#high_five")

    active_buttons_category_tips.SetPanelEvent("onactivate", function() 
    { 
        Game.EmitSound("UI.Click")
        let cosmetics_panel = $.GetContextPanel().FindChildTraverse("CategoryCosmeticsContent")
        if (cosmetics_panel)
        {
            selected_category = "tips"
            cosmetics_panel.RemoveAndDeleteChildren()
            InitTipsShop(cosmetics_panel)
        }
    })
    active_buttons_category_five.SetPanelEvent("onactivate", function() 
    { 
        Game.EmitSound("UI.Click")
        let cosmetics_panel = $.GetContextPanel().FindChildTraverse("CategoryCosmeticsContent")
        if (cosmetics_panel)
        {
            selected_category = "high_five"
            cosmetics_panel.RemoveAndDeleteChildren()
            InitHighFiveShop(cosmetics_panel)
        }
    })
    if (name == "tips")
    {
        active_buttons_category_tips.AddClass("active_buttons_category_current");
        active_buttons_category_tips_label.AddClass("active_buttons_category_label_current");
        active_buttons_category_tips_icon.AddClass("active_buttons_category_icon_current_tip");
    }
    else if (name == "high_five")
    {
        active_buttons_category_five.AddClass("active_buttons_category_current");
        active_buttons_category_five_label.AddClass("active_buttons_category_label_current");
        active_buttons_category_five_icon.AddClass("active_buttons_category_icon_current_high_five");
    }
    let main_parent = $.CreatePanel("Panel", slot_panel, "panel_"+name);
    main_parent.AddClass("SlotType");
    return main_parent
}

function shop_update_tips_and_fives(data)
{
    InitItems()
}

function SetTipUpdate(panel, tip_id, fdelete)
{
    panel.SetPanelEvent("onactivate", function() 
    { 
        if (fdelete == null)
        {
            Game.EmitSound("UI.Shop_Buy_equip")
            GameEvents.SendCustomGameEventToServer_custom( "update_tip_list", {tip_id: tip_id, delete : false} );
        }
        else
        {
            Game.EmitSound("UI.Shop_Buy_unequip")
            GameEvents.SendCustomGameEventToServer_custom( "update_tip_list", {tip_id: tip_id, delete : true} );
        }
    }); 
}

function SetHighFiveUpdate(panel, high_five, fdelete)
{
    panel.SetPanelEvent("onactivate", function() 
    { 
        if (fdelete == null)
        {
            Game.EmitSound("UI.Shop_Buy_equip")
            GameEvents.SendCustomGameEventToServer_custom( "select_current_high_five", {high_five_id: high_five} );
        }
        else
        {
            Game.EmitSound("UI.Shop_Buy_unequip")
            GameEvents.SendCustomGameEventToServer_custom( "select_current_high_five", {high_five_id: 0} );
        }
    }); 
}

function CreateChestInShop(panel, info) 
{
    if (info[4]) { return }

 	let BlockItem = $.CreatePanel("Panel", panel, "chest_id_" + info[0]);
	BlockItem.AddClass("BlockItem");

	let BlockItemImage = $.CreatePanel("Panel", BlockItem, "BlockItemImage");
	BlockItemImage.AddClass("BlockItemImage");

	let BlockItemLabel = $.CreatePanel("Label", BlockItem, "");
	BlockItemLabel.AddClass("BlockItemLabel");

	let BlockItemBuyButton = $.CreatePanel("Panel", BlockItem, "button");
	BlockItemBuyButton.AddClass("BlockItemBuyButton");

	let BlockItemBuyButtonCenter = $.CreatePanel("Panel", BlockItemBuyButton, "");
	BlockItemBuyButtonCenter.AddClass("BlockItemBuyButtonCenter");

	let BlockItemBuyButtonLabel = $.CreatePanel("Label", BlockItemBuyButtonCenter, "");
	BlockItemBuyButtonLabel.AddClass("BlockItemBuyButtonLabel");
	BlockItemBuyButtonLabel.text = $.Localize("#shop_buy")
	BlockItemBuyButtonLabel.style.marginRight = "8px"

	let shardcost_icon = $.CreatePanel("Panel", BlockItemBuyButtonCenter, "");
	shardcost_icon.AddClass("shardcost_icon");

	let BlockItemBuyButtonLabel_cost = $.CreatePanel("Label", BlockItemBuyButtonCenter, "");
	BlockItemBuyButtonLabel_cost.AddClass("BlockItemBuyButtonLabel");
	BlockItemBuyButtonLabel_cost.text = info[2]

	let player_data_local = player_table_shop

    if (!info) { return }
    if (!player_data_local) {return }

    BlockItemLabel.text = $.Localize("#" + info[1])
	BlockItemImage.style.backgroundImage = 'url("s2r://panorama/images/' + info[3] + '.png")';
	BlockItemImage.style.backgroundSize = "100%"
    BlockItem.SetPanelEvent("onactivate", function()
    { 
        GameEvents.SendCustomGameEventToServer_custom( "shop_dota1x6_open_chest_get_items_list", { chest_id : info[0] } );
    })

    if (info[5])
    {
        shardcost_icon.visible = false
        BlockItemBuyButtonLabel.visible = false
        if (HasItemInventory(info[8]))
        {
            if (IsChestOpened(info[0]))
            {
                BlockItemBuyButton.AddClass("BlockItemBuyButton_is_chest_opened")
                BlockItemBuyButtonLabel_cost.text = $.Localize("#chest_is_opened")
            }
            else
            {
                BlockItemBuyButton.AddClass("BlockItemBuyButton_money")
                BlockItemBuyButtonLabel_cost.text = $.Localize("#open_chest")
            }
        }
        else
        {
            BlockItemBuyButtonLabel_cost.text = $.Localize("#how_to_get_chest")
            BlockItem.SetPanelEvent('onmouseover', function() 
            {
                $.DispatchEvent('DOTAShowTextTooltip', BlockItem, $.Localize(info[5])) 
            });
            BlockItem.SetPanelEvent('onmouseout', function() 
            {
                $.DispatchEvent('DOTAHideTextTooltip', BlockItem); 
            });
            BlockItemBuyButton.AddClass("BlockItemBuyButton_is_chest_no_buy")
        }
    }
    else
    {
        if (IsChestOpened(info[0]))
        {
            BlockItemBuyButton.AddClass("BlockItemBuyButton_is_chest_opened")
            BlockItemBuyButtonLabel_cost.text = $.Localize("#chest_is_opened")
        }
        else if (player_data_local["points"] >= info[3])
        {
            BlockItemBuyButton.AddClass("BlockItemBuyButton_money")
            BlockItemBuyButtonLabel.AddClass("BlockItemBuyButtonLabel")
            BlockItem.AddClass("BlockItem_money")
        }
        else
        {
            BlockItem.AddClass("BlockItem_nomoney")
            BlockItemBuyButton.AddClass("BlockItemBuyButton_nomoney")
            BlockItemBuyButtonLabel.AddClass("BlockItemBuyButtonLabel_nomoney")
        }
    }	
}

function PlayerHasActiveArcaneChest()
{
    if (!IsChestOpened(2) && HasItemInventory(100000))
    {
        return true
    }
    return false
}