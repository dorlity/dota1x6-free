GameEvents.Subscribe_custom('shop_dota1x6_item_cooldown', shop_dota1x6_item_cooldown)

function shop_dota1x6_item_cooldown(data)
{
    items_cooldown[data.slot_type] = data.time
}

function InitHeroesItems()
{
	let table_heroes = CustomNetTables.GetTableValue("custom_pick", "hero_list")
	let heroes_panel = $.GetContextPanel().FindChildTraverse("HeroListItems")
	const hero_names_sorted = [...Object.keys(table_heroes)].sort()

	let heroes_strength = []
	let heroes_agility = []
	let heroes_intellect = []
	let heroes_all = []

    for (const hero_name of hero_names_sorted)
    {
        if (table_heroes[hero_name] == 0)
        {
            heroes_strength.push(hero_name)
        } else if (table_heroes[hero_name] == 1) {
            heroes_agility.push(hero_name)
        } else if (table_heroes[hero_name] == 2) {
            heroes_intellect.push(hero_name)
        } else if (table_heroes[hero_name] == 3) {
            heroes_all.push(hero_name)
        }
    }

	if (heroes_panel)
	{
		heroes_panel.RemoveAndDeleteChildren()

        // --------- New items
        let new_items_row = null
        if (Object.keys(new_items).length > 0)
        {
            let attribute_info_new = $.CreatePanel("Panel", heroes_panel, "");
            attribute_info_new.AddClass("attribute_info_new")
        
            let hero_icon_new = $.CreatePanel("Panel", attribute_info_new, "");
            hero_icon_new.AddClass("hero_icon_new")
        
            let hero_label_new = $.CreatePanel("Label", attribute_info_new, "");
            hero_label_new.AddClass("hero_label_new")
            hero_label_new.text = $.Localize("#DOTA_Tooltip_new_items_dota1x6")
    
            new_items_row = $.CreatePanel("Panel", heroes_panel, "NewItemsHeroes");
        }

		let attribute_info = $.CreatePanel("Panel", heroes_panel, "");
		attribute_info.AddClass("attribute_info")
	
		let hero_icon_str = $.CreatePanel("Panel", attribute_info, "");
		hero_icon_str.AddClass("hero_icon_str")
	
		let hero_label_str = $.CreatePanel("Label", attribute_info, "");
		hero_label_str.AddClass("hero_label_str")
		hero_label_str.text = $.Localize("#DOTA_Tooltip_Ability_item_power_treads_str")

		const str_row = $.CreatePanel("Panel", heroes_panel, "StrengthHeroes");

		let attribute_info_2 = $.CreatePanel("Panel", heroes_panel, "");
		attribute_info_2.AddClass("attribute_info")
	
		let hero_icon_agi = $.CreatePanel("Panel", attribute_info_2, "");
		hero_icon_agi.AddClass("hero_icon_agi")
	
		let hero_label_agi = $.CreatePanel("Label", attribute_info_2, "");
		hero_label_agi.AddClass("hero_label_agi")
		hero_label_agi.text = $.Localize("#DOTA_Tooltip_Ability_item_power_treads_agi")

		const agi_row = $.CreatePanel("Panel", heroes_panel, "AgilityHeroes");

		let attribute_info_3 = $.CreatePanel("Panel", heroes_panel, "");
		attribute_info_3.AddClass("attribute_info")
	
		let hero_icon_int = $.CreatePanel("Panel", attribute_info_3, "");
		hero_icon_int.AddClass("hero_icon_int")
	
		let hero_label_int = $.CreatePanel("Label", attribute_info_3, "");
		hero_label_int.AddClass("hero_label_int")
		hero_label_int.text = $.Localize("#DOTA_Tooltip_Ability_item_power_treads_int")

		const int_row = $.CreatePanel("Panel", heroes_panel, "IntellectHeroes");

        let attribute_info_4 = $.CreatePanel("Panel", heroes_panel, "");
		attribute_info_4.AddClass("attribute_info")
	
		let hero_icon_all = $.CreatePanel("Panel", attribute_info_4, "");
		hero_icon_all.AddClass("hero_icon_all")
	
		let hero_label_all = $.CreatePanel("Label", attribute_info_4, "");
		hero_label_all.AddClass("hero_label_all")
		hero_label_all.text = $.Localize("#stats_all")

		const all_row = $.CreatePanel("Panel", heroes_panel, "AllHeroes");

		for (var i = 0; i < Object.keys(heroes_strength).length; i++) 
		{
			CreateHeroPanelItems(str_row, heroes_strength[i])
		}
		for (var i = 0; i < Object.keys(heroes_agility).length; i++) 
		{
			CreateHeroPanelItems(agi_row, heroes_agility[i])
		}
		for (var i = 0; i < Object.keys(heroes_intellect).length; i++) 
		{
			CreateHeroPanelItems(int_row, heroes_intellect[i])
		}
        for (var i = 0; i < Object.keys(heroes_all).length; i++) 
		{
			CreateHeroPanelItems(all_row, heroes_all[i])
		}
        for (hero_name in new_items)
        {
            CreateHeroPanelItems(new_items_row, hero_name)
        }
	}
}


function CreateHeroPanelItems(panel, hero_name, stat) 
{
    var player_data_local = player_table_shop
    var BlockHero = $.CreatePanel("Panel", panel, "");
    BlockHero.AddClass("BlockHeroItems");
    var HeroImage = $.CreatePanel(`DOTAHeroImage`, BlockHero, "", {scaling: "stretch-to-cover-preserve-aspect", heroname : String(hero_name), tabindex : "auto", class: "HeroImage", heroimagestyle : "portrait"});
    if (!SAVE_DATA_SETS_ITEMS[String(hero_name)])
    {
        SAVE_DATA_SETS_ITEMS[String(hero_name)] = CustomNetTables.GetTableValue("heroes_items_info", String(hero_name));
    }
    let items = SAVE_DATA_SETS_ITEMS[String(hero_name)]
    if (new_items[hero_name])
    {
    	let new_alert = $.CreatePanel("Panel", BlockHero, "")
    	new_alert.AddClass("new_alert")
        BlockHero.AddClass("BlockHeroItems_new")
    }
    if (items)
    {
        if (Object.keys(items).length <= 0)
        {
            BlockHero.AddClass("hero_no_items")
        }
        else
        {
            BlockHero.SetPanelEvent("onactivate", function() 
            {	
                current_shop_hero_choose = hero_name
                OpenItemsForHero()
            });
        }
    }
    else
    {
        BlockHero.AddClass("hero_no_items")
    }
}

function OpenItemsForHero()
{
	Game.EmitSound("UI.Click")
	let heroes_panel = $.GetContextPanel().FindChildTraverse("HeroListItems")
	if (heroes_panel)
	{
		heroes_panel.style.visibility = "collapse"
	}
	let ItemsList = $.GetContextPanel().FindChildTraverse("ItemsList")
	if (ItemsList)
	{
		ItemsList.style.visibility = "visible"
	}
	InitShopItemsForHero(ItemsList)
}

function InitShopItemsForHero(panel)
{
    if (current_shop_hero_choose)
    {
        panel.RemoveAndDeleteChildren()
        if (!SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)])
        {
            SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)] = CustomNetTables.GetTableValue("heroes_items_info", String(current_shop_hero_choose));
        }
        let items = SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)]

        if (items)
        {
            if (SETS_PRIORITY[current_shop_hero_choose])
            {
                for (var i = 0; i < SETS_PRIORITY[current_shop_hero_choose].length; i++) 
                {
                    CreateSlotTypeInfo(panel, SETS_PRIORITY[current_shop_hero_choose][i])
                }
            }
            // Sort
            let new_table = []
            for (var item = 0; item <= Object.keys(items).length; item++)
            {
                let check_in = item
                if (items[Object.keys(items)[check_in]])
                {
                    new_table[item] = []
                    new_table[item].push(items[Object.keys(items)[check_in]]["item_id"], items[Object.keys(items)[check_in]]["price"])
                }
            }
            new_table.sort(function (a, b) 
            {
                return Number(a[1])-Number(b[1])
            });
            for (var i = 0; i <= new_table.length; i++) 
            {
                if (new_table[i])
                {
                    CreateItemShopItemHero(panel, items[new_table[i][0]], null, items)
                } 
            }
            if (Object.keys(items).length <= 0)
            {
                var ComingSoonText = $.CreatePanel("Label", panel, "");
                ComingSoonText.AddClass("QuestComingSoon");
                ComingSoonText.text = $.Localize("#soon_ingame")
            }
        } 
        else 
        {
            var ComingSoonText = $.CreatePanel("Label", panel, "");
            ComingSoonText.AddClass("QuestComingSoon");
            ComingSoonText.text = $.Localize("#soon_ingame")
        }
    }
}

function CreateSlotTypeInfo(panel, name)
{
    if (name == "rare")
    {
        let slot_name_panel = $.CreatePanel("Label", panel, "");
        slot_name_panel.AddClass("slot_name_panel");
        let slot_panel = $.CreatePanel("Panel", panel, "");
        slot_panel.AddClass("slot_panel");
        let slot_name = $.CreatePanel("Label", slot_name_panel, "");
        slot_name.AddClass("slot_name");
        slot_name.text = $.Localize("#"+name)
        let main_parent = $.CreatePanel("Panel", slot_panel, "panel_"+name);
        main_parent.AddClass("SlotType");
        return main_parent
    }
    else
    {
        let set_this_info = GetAllItemsInSet(name, current_shop_hero_choose)
        let panels_sets_list = panel.FindChildTraverse("panels_sets_list")
        if (panels_sets_list == null)
        {
            let slot_name_panel = $.CreatePanel("Label", panel, "");
            slot_name_panel.AddClass("slot_name_panel");

            let slot_name = $.CreatePanel("Label", slot_name_panel, "");
            slot_name.AddClass("slot_name");
            slot_name.text = $.Localize("#sets_names")

            panels_sets_list = $.CreatePanel("Panel", panel, "panels_sets_list")
            panels_sets_list.AddClass("panels_sets_list")
        }

        let player_has_items_from_set = false
        for (id in set_this_info[0])
        {
            let item_id = set_this_info[0][id]
            if (HasItemInventory(item_id))
            {
                player_has_items_from_set = true
            }
        }

        let slot_panel = $.CreatePanel("Panel", panels_sets_list, "");
        slot_panel.AddClass("slot_panel_new");

        if (!PLAYER_VIEW_ITEMS_FOR_BUY && !player_has_items_from_set)
        {
            slot_panel.style.visibility = "collapse"
        }

        let slot_panel_sets = $.CreatePanel("Panel", slot_panel, "");
        slot_panel_sets.AddClass("slot_panel_sets");

        let sets_texture = $.CreatePanel("Panel", slot_panel_sets, "");
        sets_texture.AddClass("sets_texture");

        let sets_texture_background = $.CreatePanel("Panel", sets_texture, "");
        sets_texture_background.AddClass("sets_texture_bg");

        let texture_bg = current_shop_hero_choose.replace("npc_dota_hero_", "")
        if (OTHER_BACKGROUND_HEROES[current_shop_hero_choose] != null)
        {
            texture_bg = OTHER_BACKGROUND_HEROES[current_shop_hero_choose]
        }
        sets_texture_background.style.backgroundImage = 'url("s2r://materials/portraits_card/portrait_backgrounds/' + texture_bg + '.psd")';
        sets_texture_background.style.backgroundSize = "cover"

        let hero_image_sets = $.CreatePanel("Panel", sets_texture, "");
        hero_image_sets.AddClass("hero_image_sets");
        hero_image_sets.style.backgroundImage = 'url("s2r://panorama/images/' + SETS_TEXTURE_FULL_ICON[name] + '.png")';
        hero_image_sets.style.backgroundSize = "100%"

        if (SETS_ARCANA_TYPE[name])
        {
            let label_set_rarity_header = $.CreatePanel("Label", sets_texture, "")
            label_set_rarity_header.AddClass("label_set_rarity_header")
            label_set_rarity_header.text = $.Localize("#is_arcana")
            let scene_panel = $.CreatePanel("DOTAScenePanel", sets_texture, "", {map:'scenes/armory/ui_armory_edges', hittest:'false', camera:'shot_camera', class:"set_rarity_scene", particleonly:"true"});
            $.RegisterEventHandler("DOTAScenePanelSceneLoaded", scene_panel, function() 
            {
                $.Schedule(0.2, function () 
                {
                    scene_panel.FireEntityInput("armory_edge_set", "Enable", "", 0.0);
                    scene_panel.FireEntityInput("armory_edge_set", "Start", "", 0.0); 
                });
            });
        }

        if (SETS_PERSONA_TYPE[name])
        {
            let label_set_rarity_header = $.CreatePanel("Label", sets_texture, "")
            label_set_rarity_header.AddClass("label_set_rarity_header")
            label_set_rarity_header.text = $.Localize("#is_persona")
            let scene_panel = $.CreatePanel("DOTAScenePanel", sets_texture, "", {map:'scenes/armory/ui_armory_edges', hittest:'false', camera:'shot_camera', class:"set_rarity_scene", particleonly:"true"});
            $.RegisterEventHandler("DOTAScenePanelSceneLoaded", scene_panel, function() 
            {
                $.Schedule(0.2, function () 
                {
                    scene_panel.FireEntityInput("armory_edge_set", "Enable", "", 0.0);
                    scene_panel.FireEntityInput("armory_edge_set", "Start", "", 0.0); 
                });
            });
        }

        slot_panel.SetPanelEvent("onactivate", function() 
        { 
            OpenItemsPreviewForHero(set_this_info[0]);
        });

        if (name != "pudge_persona" && name != "crystal_persona" && name != "phantom_persona" && name != "invoker_persona" && name != "antimage_persona" && name != "terrorblade_forms")
        {
            let buy_full_set_button = $.CreatePanel("Panel", sets_texture, "");
            buy_full_set_button.AddClass("buy_full_set_button");
            
            let set_center_button = $.CreatePanel("Panel", buy_full_set_button, "");
            set_center_button.AddClass("set_center_button");
            let shardcost_icon_sets = $.CreatePanel("Panel", set_center_button, "");
            shardcost_icon_sets.AddClass("buy_full_set_icon");
            let price_info_sets = $.CreatePanel("Label", set_center_button, "");
            price_info_sets.AddClass("buy_full_set_label");

            if (set_this_info[3] != null && set_this_info[3] != 0 && set_this_info[4] != null && set_this_info[4] != 0)
            {
                var buy_full_set_old_panel = $.CreatePanel("Panel", buy_full_set_button, "");
                buy_full_set_old_panel.AddClass("buy_full_set_old_panel");

                let buy_full_set_old_text = $.CreatePanel("Label", buy_full_set_old_panel, "");
                buy_full_set_old_text.AddClass("buy_full_set_old_text");
                buy_full_set_old_text.text = set_this_info[2]

                price_info_sets.text = set_this_info[4]

                var buy_full_set_line = $.CreatePanel("Panel", buy_full_set_old_panel, "");
                buy_full_set_line.AddClass("buy_full_set_line");

                buy_full_set_button.AddClass("buy_full_set_button_sale");
            }
            else 
            {
                price_info_sets.text = set_this_info[2]
            }
        }

        if (set_this_info[3] > 0)
        {
            var BlockItemSale = $.CreatePanel("Panel", sets_texture, "BlockItemSale");
            BlockItemSale.AddClass("sets_texture_sale");

            var BlockItemSaleText = $.CreatePanel("Label", BlockItemSale, "BlockItemSaleText");
            BlockItemSaleText.AddClass("sets_texture_sale_text");
            BlockItemSaleText.text = '-' + String(set_this_info[3]) + '%'
        }
    }
}

function CreateItemShopItemHero(panel, info, is_set, items_list)
{
    if (info["hide"] == 1)
    {
        return
    }

    if (HIDE_ITEMS_WITHOUT_HAS[info["item_id"]] && !HasItemInventory(info["item_id"]))
    {
        return
    }

    let main_parent = panel

    if (info["sets"] != null && info["sets"] == "rare")
    {
        main_parent = panel.FindChildTraverse("panel_"+info["sets"])
        if (main_parent == null)
        {
            main_parent = CreateSlotTypeInfo(panel, info["sets"])
        }
    }

    if (info["sets"] == null || info["sets"] != "rare")
    {
        if (!is_set)
        {
            return
        }
    }

    let sets = info["sets"]

    let original_item_id = info["item_id"]

    var BlockItem = $.CreatePanel("Panel", main_parent, "item_id_" + info["item_id"]);
    BlockItem.AddClass("BlockItem");
    BlockItem.slot_type = info["SlotType"]

    var BlockItemImage = $.CreatePanel("Panel", BlockItem, "BlockItemImage");
    BlockItemImage.AddClass("BlockItemImage");

    var BlockItemLabel = $.CreatePanel("Label", BlockItem, "");
    BlockItemLabel.AddClass("BlockItemLabel");

    var BlockItemBuyButton = $.CreatePanel("Panel", BlockItem, "button");
    BlockItemBuyButton.AddClass("BlockItemBuyButton");

    var BlockItemBuyButtonCenter = $.CreatePanel("Panel", BlockItemBuyButton, "");
    BlockItemBuyButtonCenter.AddClass("BlockItemBuyButtonCenter");

    var BlockItemBuyButtonLabel = $.CreatePanel("Label", BlockItemBuyButtonCenter, "");
    BlockItemBuyButtonLabel.AddClass("BlockItemBuyButtonLabel");
    BlockItemBuyButtonLabel.text = $.Localize("#shop_buy")
    BlockItemBuyButtonLabel.style.marginRight = "8px"

    var shardcost_icon = $.CreatePanel("Panel", BlockItemBuyButtonCenter, "");
    shardcost_icon.AddClass("shardcost_icon");

    var BlockItemBuyButtonLabel_price = $.CreatePanel("Label", BlockItemBuyButtonCenter, "");
    BlockItemBuyButtonLabel_price.AddClass("BlockItemBuyButtonLabel");
    
    if (info["chest_id"] != null)
    {
        let table_chest_info = CustomNetTables.GetTableValue("shop_items", "chest")
        if (table_chest_info && table_chest_info[info["chest_id"]])
        {
            BlockItemBuyButtonLabel_price.text = table_chest_info[info["chest_id"]].chest_cost
        }
    }
    else
    {
        BlockItemBuyButtonLabel_price.text = info["price"]
    }

    if (info['sale'] && info['sale'] > 0)
    {
        var BlockItemSale = $.CreatePanel("Panel", BlockItemImage, "BlockItemSale");
        BlockItemSale.AddClass("BlockItemImage_sale");

        var BlockItemSaleText = $.CreatePanel("Label", BlockItemSale, "BlockItemSaleText");
        BlockItemSaleText.AddClass("BlockItemImage_sale_text");
        BlockItemSaleText.text = '-' + String(info['sale']) + '%'

        if (info['sale_price'] && info['sale_price'] > 0 )
        {
            BlockItemBuyButtonLabel_price.text =  info['sale_price']
            BlockItemBuyButtonLabel.text =  info['price']

            BlockItemBuyButtonLabel_price.RemoveClass("BlockItemBuyButtonLabel")
            BlockItemBuyButtonLabel_price.AddClass("BlockItemBuyButtonLabel_new_price")

            BlockItemBuyButtonLabel.RemoveClass("BlockItemBuyButtonLabel")
            BlockItemBuyButtonLabel.AddClass("BlockItemBuyButtonLabel_old_price")

            var BlockItemBuyButton_line = $.CreatePanel("Panel", BlockItemBuyButton, "button_line");
            BlockItemBuyButton_line.AddClass("BlockItemBuyButton_line");

            BlockItemBuyButton.AddClass("BlockItemBuyButtonCenter_sale");
        }
    }

    var player_data_local = player_table_shop

    if (info["OtherItemsBundle"])
    {
        for (var i = 1; i <= Object.keys(info["OtherItemsBundle"]).length; i++) 
        {
            if (HasItemUneqieup(current_shop_hero_choose, info["OtherItemsBundle"][i][1]))
            {
                original_item_id = info["OtherItemsBundle"][i][1]
                break
            }
        }
    }

    let info_updated = items_list[original_item_id]

    if (info)
    {
        if (HasItemInventory(info["item_id"]))
        {
            BlockItemBuyButton.style.visibility = "collapse"
            BlockItem.AddClass("BlockItem_purchased")
            var BlockItemActivateButton = $.CreatePanel("Panel", BlockItem, "button_activate");
            BlockItemActivateButton.AddClass("BlockItemBuyButton");
            var BlockItemActivateButtonLabel = $.CreatePanel("Label", BlockItemActivateButton, "BlockItemActivateButtonLabel");
            BlockItemActivateButtonLabel.AddClass("BlockItemBuyButtonLabel");

            
            if (Players.GetPlayerSelectedHero( Players.GetLocalPlayer() ) != current_shop_hero_choose && !$("#HeroListItemsSelection"))
            {
                BlockItemActivateButton.style.opacity = "0"
                if (info["OtherItemsBundle"])
                {
                    var ButtonsItemStyles = $.CreatePanel("Panel", BlockItemImage, "ButtonsItemStyles");
                    ButtonsItemStyles.AddClass("ButtonsItemStyles");
                    for (var i = 1; i <= Object.keys(info["OtherItemsBundle"]).length; i++) 
                    {
                        var ButtonItemStyle = $.CreatePanel("Panel", ButtonsItemStyles, "item_style_" + info["OtherItemsBundle"][i][1]);
                        ButtonItemStyle.AddClass("ButtonItemStyle");
                        ButtonItemStyle.style.backgroundColor = info["OtherItemsBundle"][i][2]
                        var ButtonItemStyleActiveIcon = $.CreatePanel("Panel", ButtonItemStyle, "");
                        ButtonItemStyleActiveIcon.AddClass("ButtonItemStyleActiveIcon");
                    }
                }
            }
            else
            {
                if (HasItemUneqieup(current_shop_hero_choose, original_item_id))
                {
                    BlockItemActivateButtonLabel.text = $.Localize("#shop_unequip")
                    BlockItemActivateButton.AddClass("BlockItemBuyButton_unequip")
                    BlockItemActivateButton.RemoveClass("BlockItemBuyButton_equip")
                    BlockItemActivateButton.SetPanelEvent("onactivate", function() 
                    { 
                        UneuipItemHero(info["item_id"], info["SlotType"], original_item_id, BlockItem, sets)
                    });
                    BlockItem.SetPanelEvent("onactivate", function() 
                    { 
                        UneuipItemHero(info["item_id"], info["SlotType"], original_item_id, BlockItem, sets)
                    });
                }
                else
                {
                    BlockItemActivateButtonLabel.text = $.Localize("#shop_equip")
                    BlockItemActivateButton.RemoveClass("BlockItemBuyButton_unequip")
                    BlockItemActivateButton.AddClass("BlockItemBuyButton_equip")
                    BlockItemActivateButton.SetPanelEvent("onactivate", function() 
                    { 
                        UneuipItemHero(info["item_id"], info["SlotType"], original_item_id, BlockItem, sets)
                    });
                    BlockItem.SetPanelEvent("onactivate", function() 
                    { 
                        UneuipItemHero(info["item_id"], info["SlotType"], original_item_id, BlockItem, sets)
                    });
                }
    
                if (info["OtherItemsBundle"])
                {
                    var ButtonsItemStyles = $.CreatePanel("Panel", BlockItemImage, "ButtonsItemStyles");
                    ButtonsItemStyles.AddClass("ButtonsItemStyles");
                    for (var i = 1; i <= Object.keys(info["OtherItemsBundle"]).length; i++) 
                    {
                        var ButtonItemStyle = $.CreatePanel("Panel", ButtonsItemStyles, "item_style_" + info["OtherItemsBundle"][i][1]);
                        ButtonItemStyle.AddClass("ButtonItemStyle");
                        ButtonItemStyle.style.backgroundColor = info["OtherItemsBundle"][i][2]
                        var ButtonItemStyleActiveIcon = $.CreatePanel("Panel", ButtonItemStyle, "");
                        ButtonItemStyleActiveIcon.AddClass("ButtonItemStyleActiveIcon");
    
                        SetButtonStyle(ButtonItemStyle, info["OtherItemsBundle"][i][1], info["SlotType"], BlockItem, info["item_id"], sets)
                        if (HasItemUneqieup(current_shop_hero_choose, info["OtherItemsBundle"][i][1]))
                        {
                            ButtonItemStyle.SetHasClass("ButtonItemStyle_active", true)
                        } 
                    }
                }
            } 
        } 
        else 
        {
            if (razor_arcana_items_blocked[info["item_id"]])
            {
                // ДОБАВИТЬ СЮДА ТУПА СТИЛЬКА ЕСЛИ  НАДО
                BlockItemBuyButton.style.opacity = "0"
            }
            else if (pudge_persona_unique[info["item_id"]] && !HasItemInventory(999251))
            {
                BlockItemBuyButton.style.opacity = "0"
            }
            else if (crystal_maiden_persona_unique[info["item_id"]] && !HasItemInventory(26559))
            {
                BlockItemBuyButton.style.opacity = "0"
            }
            else if (phantom_persona_unique[info["item_id"]] && !HasItemInventory(4480))
            {
                BlockItemBuyButton.style.opacity = "0"
            }
            else if (invoke_persona_unique[info["item_id"]] && !HasItemInventory(13042))
            {
                BlockItemBuyButton.style.opacity = "0"
            }
            else if (antimage_persona_unique[info["item_id"]] && !HasItemInventory(13783))
            {
                BlockItemBuyButton.style.opacity = "0"
            }
            else
            {

                if ( info["sale_price"] &&  info["sale_price"] > 0)
                {
                    BlockItemBuyButton.RemoveClass("BlockItemBuyButton_nomoney")
                    BlockItemBuyButtonLabel.RemoveClass("BlockItemBuyButtonLabel_nomoney")
                    BlockItemBuyButton.AddClass("BlockItemBuyButton_sale")
                    BlockItemBuyButtonLabel.AddClass("BlockItemBuyButtonLabel")
                    BlockItem.AddClass("BlockItem_sale")

                    let buy = true

                    if (player_data_local && player_data_local["points"] >= info["sale_price"])
                    {
                        buy = null
                    }

                    BlockItem.SetPanelEvent("onactivate", function() 
                    { 
                        if (info["chest_id"] != null)
                        {
                            GameEvents.SendCustomGameEventToServer_custom( "shop_dota1x6_open_chest_get_items_list", { chest_id : info["chest_id"] } );
                        }
                        else
                        {
                            CreateBuyWindow(info["item_id"], info["sale_price"], info["name"], 0, current_shop_hero_choose, buy, info["OtherItemsBundle"])
                        }
                    })
                }
                else
                {
                    if (player_data_local && player_data_local["points"] >= info["price"])
                    {
                        BlockItemBuyButton.RemoveClass("BlockItemBuyButton_nomoney")
                        BlockItemBuyButton.AddClass("BlockItemBuyButton_money")
                        BlockItemBuyButtonLabel.RemoveClass("BlockItemBuyButtonLabel_nomoney")
                        BlockItemBuyButtonLabel.AddClass("BlockItemBuyButtonLabel")
                        BlockItem.AddClass("BlockItem_money")
                        BlockItem.RemoveClass("BlockItem_nomoney")
                        BlockItem.SetPanelEvent("onactivate", function() 
                        { 
                            if (info["chest_id"] != null)
                            {
                                GameEvents.SendCustomGameEventToServer_custom( "shop_dota1x6_open_chest_get_items_list", { chest_id : info["chest_id"] } );
                            }
                            else
                            {
                                CreateBuyWindow(info["item_id"], info["price"], info["name"], 0, current_shop_hero_choose, null, info["OtherItemsBundle"])
                            }
                        })
                    } 
                    else 
                    {
                        BlockItem.RemoveClass("BlockItem_money")
                        BlockItem.AddClass("BlockItem_nomoney")
                        BlockItemBuyButton.AddClass("BlockItemBuyButton_nomoney")
                        BlockItemBuyButton.RemoveClass("BlockItemBuyButton_money")
                        BlockItemBuyButtonLabel.AddClass("BlockItemBuyButtonLabel_nomoney")
                        BlockItemBuyButtonLabel.RemoveClass("BlockItemBuyButtonLabel")
                        BlockItem.SetPanelEvent("onactivate", function() 
                        { 
                            if (info["chest_id"] != null)
                            {
                                GameEvents.SendCustomGameEventToServer_custom( "shop_dota1x6_open_chest_get_items_list", { chest_id : info["chest_id"] } );
                            }
                            else
                            {
                                CreateBuyWindow(info["item_id"], info["price"], info["name"], 0, current_shop_hero_choose, true, info["OtherItemsBundle"])
                            }
                        })
                    }
                }
            }

            if (info["OtherItemsBundle"])
            {
                var ButtonsItemStyles = $.CreatePanel("Panel", BlockItemImage, "ButtonsItemStyles");
                ButtonsItemStyles.AddClass("ButtonsItemStyles");
                for (var i = 1; i <= Object.keys(info["OtherItemsBundle"]).length; i++) 
                {
                    var ButtonItemStyle = $.CreatePanel("Panel", ButtonsItemStyles, "item_style_" + info["OtherItemsBundle"][i][1]);
                    ButtonItemStyle.AddClass("ButtonItemStyle");
                    ButtonItemStyle.style.backgroundColor = info["OtherItemsBundle"][i][2]
                    var ButtonItemStyleActiveIcon = $.CreatePanel("Panel", ButtonItemStyle, "");
                    ButtonItemStyleActiveIcon.AddClass("ButtonItemStyleActiveIcon");
                    SetButtonStyleNoBuy(ButtonItemStyle, info["OtherItemsBundle"][i][1], info["SlotType"], BlockItem, info["item_id"], sets, i)
                    if (i == 1)
                    {
                        ButtonItemStyle.SetHasClass("ButtonItemStyle_active", true)
                    }
                }
            }
            if (!PLAYER_VIEW_ITEMS_FOR_BUY)
            {
                BlockItem.style.visibility = "collapse"
            }
        }

        BlockItemLabel.text = $.Localize(info["name"])

        if (info["local_icon"] && info["local_icon"] == 1)
        {
            BlockItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/heroes/' + info["icon"] + '.png")'
        }else 
        {
            BlockItemImage.style.backgroundImage = 'url("s2r://panorama/images/' + info_updated["icon"] + '.png")';
        }

        BlockItemImage.style.backgroundSize = "100%"

        if (ITEMS_TERRORBLADE_COLOR_GEM[info["item_id"]])
        {
            let item_icon_terrorblade_color = $.CreatePanel("Panel", BlockItemImage, "")
            item_icon_terrorblade_color.AddClass("item_icon_terrorblade_color")
            item_icon_terrorblade_color.style.washColor = ITEMS_TERRORBLADE_COLOR_GEM[info["item_id"]]
        }
    }
}
function SetButtonStyle(panel, item, slot, item_block, block_id, sets)
{
    panel.SetPanelEvent("onactivate", function() 
    {
        SwapUneuipItemHero(item, slot, item_block, block_id, sets)
    });
}

function SetButtonStyleNoBuy(panel, item, slot, item_block, block_id, sets, style)
{
    panel.SetPanelEvent("onactivate", function() 
    {
        UpdateShopBlockImageNoBuy(item_block, item, block_id, sets, style)
    });
}

function SwapUneuipItemHero(id, slot_type, item_block, block_id, sets)
{
    if (items_cooldown[slot_type] != null && items_cooldown[slot_type] > 0)
    {
        GameEvents.SendEventClientSide("dota_hud_error_message", 
        {
            "splitscreenplayer": 0,
            "reason": 80,
            "message": $.Localize("#dota_item_change_error") + items_cooldown[slot_type]
        })
        return
    }

    if (!HasItemUneqieup(current_shop_hero_choose, id))
    {
        if ((HeroIsAlive() || $("#HeroListItemsSelection") ) && IsLockedTime())
        {
            Game.EmitSound("UI.Shop_Buy_equip")
            GameEvents.SendCustomGameEventToServer_custom( "dota1x6_item_change", {item_id: id, current_hero:current_shop_hero_choose, remove : 0} );
            UpdateShopBlock(item_block, id, block_id, sets)
            UpdateQuipHeroItem(block_id, true, slot_type, sets)
        }
    }
}
function UpdateShopBlockImageNoBuy(BlockItem, item_id, block_id, sets, style)
{
    let info = null
    if (!SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)])
    {
        SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)] = CustomNetTables.GetTableValue("heroes_items_info", String(current_shop_hero_choose));
    }
	let items = SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)]
	if (items)
	{
		for (var i = 0; i < Object.keys(items).length; i++) 
		{
			if (items[Object.keys(items)[i]]["item_id"] == item_id)
			{
				info = items[Object.keys(items)[i]]
			}
		}
	}
    let ButtonsItemStyles = BlockItem.FindChildTraverse("ButtonsItemStyles")
    let BlockItemImage = BlockItem.FindChildTraverse("BlockItemImage")
    if (BlockItemImage)
    {
        BlockItemImage.style.backgroundImage = 'url("s2r://panorama/images/' + info["icon"] + '.png")';
        BlockItemImage.style.backgroundSize = "100%"
    }
    if (info["OtherItemsBundle"])
    {
        ButtonsItemStyles.RemoveAndDeleteChildren()
        for (var i = 1; i <= Object.keys(info["OtherItemsBundle"]).length; i++) 
        {
            var ButtonItemStyle = $.CreatePanel("Panel", ButtonsItemStyles, "item_style_" + info["OtherItemsBundle"][i][1]);
            ButtonItemStyle.AddClass("ButtonItemStyle");
            ButtonItemStyle.style.backgroundColor = info["OtherItemsBundle"][i][2]
            var ButtonItemStyleActiveIcon = $.CreatePanel("Panel", ButtonItemStyle, "");
			ButtonItemStyleActiveIcon.AddClass("ButtonItemStyleActiveIcon");
            SetButtonStyleNoBuy(ButtonItemStyle, info["OtherItemsBundle"][i][1], info["SlotType"], BlockItem, block_id, sets, i)
            if (style == i)
            {
                ButtonItemStyle.SetHasClass("ButtonItemStyle_active", true)
            }
        }
    }
}

function UpdateShopBlock(BlockItem, item_id, block_id, sets) 
{
    let info = null
    if (!SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)])
    {
        SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)] = CustomNetTables.GetTableValue("heroes_items_info", String(current_shop_hero_choose));
    }
	let items = SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)]
	if (items)
	{
		for (var i = 0; i < Object.keys(items).length; i++) 
		{
			if (items[Object.keys(items)[i]]["item_id"] == item_id)
			{
				info = items[Object.keys(items)[i]]
			}
		}
	}

    let BlockItemActivateButtonLabel = BlockItem.FindChildTraverse("BlockItemActivateButtonLabel")
    let BlockItemActivateButton = BlockItem.FindChildTraverse("button_activate")
    let ButtonsItemStyles = BlockItem.FindChildTraverse("ButtonsItemStyles")
    let BlockItemImage = BlockItem.FindChildTraverse("BlockItemImage")

    if (BlockItemActivateButtonLabel)
    {
        BlockItemActivateButtonLabel.text = $.Localize("#shop_unequip")   
    }

    if (BlockItemActivateButton)
    {
        BlockItemActivateButton.AddClass("BlockItemBuyButton_unequip")
        BlockItemActivateButton.RemoveClass("BlockItemBuyButton_equip")
        BlockItemActivateButton.SetPanelEvent("onactivate", function() 
        { 
            UneuipItemHero(block_id, info["SlotType"], info["item_id"], BlockItem, sets)
        });
        BlockItem.SetPanelEvent("onactivate", function() 
        { 
            UneuipItemHero(block_id, info["SlotType"], info["item_id"], BlockItem, sets)
        });
    }

    if (BlockItemImage)
    {
        BlockItemImage.style.backgroundImage = 'url("s2r://panorama/images/' + info["icon"] + '.png")';
        BlockItemImage.style.backgroundSize = "100%"
    }

    if (info["OtherItemsBundle"])
    {
        ButtonsItemStyles.RemoveAndDeleteChildren()
        for (var i = 1; i <= Object.keys(info["OtherItemsBundle"]).length; i++) 
        {
            var ButtonItemStyle = $.CreatePanel("Panel", ButtonsItemStyles, "item_style_" + info["OtherItemsBundle"][i][1]);
            ButtonItemStyle.AddClass("ButtonItemStyle");
            ButtonItemStyle.style.backgroundColor = info["OtherItemsBundle"][i][2]
            var ButtonItemStyleActiveIcon = $.CreatePanel("Panel", ButtonItemStyle, "");
			ButtonItemStyleActiveIcon.AddClass("ButtonItemStyleActiveIcon");
            SetButtonStyle(ButtonItemStyle, info["OtherItemsBundle"][i][1], info["SlotType"], BlockItem, block_id, sets)
            if (info["OtherItemsBundle"][i][1] == info["item_id"])
            {
                ButtonItemStyle.SetHasClass("ButtonItemStyle_active", true)
            }
        }
    }
}


function UneuipItemHero(id, slot_type, original_item_id, BlockItem, sets)
{
    id = Number(id)
    original_item_id = Number(original_item_id)
    
    if (items_cooldown[slot_type] != null && items_cooldown[slot_type] > 0)
    {
        GameEvents.SendEventClientSide("dota_hud_error_message", 
        {
            "splitscreenplayer": 0,
            "reason": 80,
            "message": $.Localize("#dota_item_change_error") + items_cooldown[slot_type]
        })
        return
    }

    if ((HeroIsAlive() || $("#HeroListItemsSelection") ) && IsLockedTime())
    {
        if (HasItemUneqieup(current_shop_hero_choose, original_item_id))
        {
            Game.EmitSound("UI.Shop_Buy_unequip")
            GameEvents.SendCustomGameEventToServer_custom( "dota1x6_item_change", {item_id: original_item_id, current_hero:current_shop_hero_choose, remove : 1} );
            UpdateQuipHeroItem(id, false, slot_type, sets)
            if (BlockItem)
            {
                let ButtonsItemStyles = BlockItem.FindChildTraverse("ButtonsItemStyles")
                if (ButtonsItemStyles)
                {
                    for (var i = 0; i < ButtonsItemStyles.GetChildCount(); i++) 
                    {
                        ButtonsItemStyles.GetChild(i).SetHasClass("ButtonItemStyle_active", false)
                    }
                }
            }
        }
        else
        {
            Game.EmitSound("UI.Shop_Buy_equip")
            GameEvents.SendCustomGameEventToServer_custom( "dota1x6_item_change", {item_id: original_item_id, current_hero:current_shop_hero_choose, remove : 0} );
            UpdateQuipHeroItem(id, true, slot_type, sets)
            if (BlockItem)
            {
                let ButtonsItemStyles = BlockItem.FindChildTraverse("ButtonsItemStyles")
                if (ButtonsItemStyles)
                {
                    for (var i = 0; i < ButtonsItemStyles.GetChildCount(); i++) 
                    {
                        if (ButtonsItemStyles.GetChild(i).id == "item_style_"+original_item_id)
                        {
                            ButtonsItemStyles.GetChild(i).SetHasClass("ButtonItemStyle_active", true)
                        }
                        else
                        {
                            ButtonsItemStyles.GetChild(i).SetHasClass("ButtonItemStyle_active", false)
                        }
                    }
                }
            }
        }
    }
}

var UPDATE_SELECTION_SETS = {}

function OpenItemsPreviewForHero(set_this_info)
{
    let main = $.GetContextPanel().FindChildTraverse("window_shop")

    let blur_panel = $.GetContextPanel().FindChildTraverse("shop_window_blur_selected_set")
    blur_panel.RemoveClass("shop_window_blur_hidden")
    blur_panel.AddClass("shop_window_blur_sets")

    Game.EmitSound("UI.Shop_Category_Open")

    let panel_items_sets_notif = $.CreatePanel("Panel", main, "panel_items_sets_notif")
    panel_items_sets_notif.AddClass("panel_items_sets_notif")
    panel_items_sets_notif.AddClass("panel_items_sets_notif_show")
    panel_items_sets_notif.hittest = true;
    panel_items_sets_notif.SetPanelEvent("onactivate", function() {})

    if (!SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)])
    {
        SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)] = CustomNetTables.GetTableValue("heroes_items_info", String(current_shop_hero_choose));
    }
    let items = SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)]
    for (id in set_this_info)
    {
        let item_id = set_this_info[id]
        if (items[item_id])
        {
            CreateItemShopItemHero(panel_items_sets_notif, items[item_id], true, items)
        }
    }

    UPDATE_SELECTION_SETS = set_this_info

    blur_panel.SetPanelEvent("onactivate", function() 
    {   
        if (panel_items_sets_notif && panel_items_sets_notif.IsValid())
        {
            panel_items_sets_notif.RemoveClass("panel_items_sets_notif_show")
            panel_items_sets_notif.AddClass("panel_items_sets_notif_hide")
            $.Schedule( 0.35, function()
            {
                if (panel_items_sets_notif && panel_items_sets_notif.IsValid())
                {
                    panel_items_sets_notif.DeleteAsync(0)
                }
            })
        }
        Game.EmitSound("UI.Shop_Category_Open")
        blur_panel.SetPanelEvent("onactivate", function() {})
        blur_panel.AddClass("shop_window_blur_hidden")
        blur_panel.RemoveClass("shop_window_blur_sets")
    })
}

function UpdateSelectionSets()
{
    if (UPDATE_SELECTION_SETS[0] == null) { return }
    if (!current_shop_hero_choose) { return }
    let main = $.GetContextPanel().FindChildTraverse("window_shop")
    let panel_items_sets_notif = main.FindChildTraverse("panel_items_sets_notif")
    if (panel_items_sets_notif && panel_items_sets_notif.IsValid())
    {
        panel_items_sets_notif.RemoveAndDeleteChildren()
        if (!SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)])
        {
            SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)] = CustomNetTables.GetTableValue("heroes_items_info", String(current_shop_hero_choose));
        }
        let items = SAVE_DATA_SETS_ITEMS[String(current_shop_hero_choose)]
        for (id in UPDATE_SELECTION_SETS)
        {
            let item_id = UPDATE_SELECTION_SETS[id]
            if (items[item_id])
            {
                CreateItemShopItemHero(panel_items_sets_notif, items[item_id], true, items)
            }
        }
    }
}

function PreClosePanel()
{
    let main = $.GetContextPanel().FindChildTraverse("window_shop")
    let buy_panel = main.FindChildTraverse("buy_panel")
    if (buy_panel)
    {
        buy_panel.DeleteAsync(0)
    }
}