var CURRENT_DROP_ID = null
var rarity_color = // Цвет рарности
{
    common : "#b0c3d9",
    uncommon : "#5e98d9", 
    rare: "#4b69ff",
    mythical : "#8847ff", 
    legendary : "#d32ce6", 
    immortal : "#e4ae39", 
} 
var DELAY_SPAWN_ITEMS_ANIM = 0.01 // 0 - off
var STARTING_SPEED = 5890
var DROP_SLOT = 70
var DROP_POS = [0,0] // Позиция дропнутого айтема
var SOUND_TICK_WIDTH = 128
var last_chest_info = null
var CHEST_ID_CURRENT = null

GameEvents.Subscribe_custom('shop_dota1x6_open_chest_information', shop_dota1x6_open_chest_information)
function shop_dota1x6_open_chest_information(data)
{
    last_chest_info = data.chest_info
    InitChest(data.chest_info)
}

GameEvents.Subscribe_custom('shop_dota1x6_open_chest_active', shop_dota1x6_open_chest_active)
function shop_dota1x6_open_chest_active(data)
{
    if (data.drop_id == null)
    {
        return
    }
    let item_position_in_drop_list = GetItemPositionInDropList(data.drop_id, data.items)
    if (item_position_in_drop_list == null)
    {
        return 
    }
    CURRENT_DROP_ID = item_position_in_drop_list
    OpenChest(data.items, data.is_retry_drop, data.shard_counter, data.is_reroll)
}

function InitChest(data, reopen)
{
    $("#ItemsInChestName").text = $.Localize("#chest_items_normal_2")
    $("#ItemDropRerollButton").visible = false
    $("#ChestHudMainPanel").SetHasClass("NoRareItems", true)
    ClearOldChest()
    CHEST_ID_CURRENT = data.chest_id
    $("#ChestName").text = $.Localize("#"+data.chest_name)
    ChestInitItemsInRoll(data.chest_items)
    ChestInitItemsInChest(data.chest_items)
    ButtonSet(data.chest_id, data.chest_cost, data.chest_items, data.is_no_buy, data.is_only_one_open, data.chest_item_id)
    $("#ChestHudMainPanel").style.opacity = "1"
    $("#ChestHudMainPanel").hittest = true
    $("#ChestCostIcon").visible = true

    $("#InfoOpenReroll").SetPanelEvent('onmouseover', function() 
    {
        $.DispatchEvent('DOTAShowTextTooltip', $("#InfoOpenReroll"), $.Localize("#reroll_chest_info_description")) 
    });

    $("#InfoOpenReroll").SetPanelEvent('onmouseout', function() 
    {
        $.DispatchEvent('DOTAHideTextTooltip', $("#InfoOpenReroll")); 
    });

    if (data.is_reroll)
    {
        $("#InfoOpenReroll").visible = true
    }
    else
    {
        $("#InfoOpenReroll").visible = false
    }

    if (data.is_no_buy && !HasItemInventory(data.chest_item_id))
    {
        $("#ChestCostIcon").visible = false
        $("#ChestCostLabel").text = $.Localize("#how_to_get_chest")
        $("#OpenChestButton").SetPanelEvent('onmouseover', function() 
        {
            $.DispatchEvent('DOTAShowTextTooltip', $("#OpenChestButton"), $.Localize(data.is_no_buy)) 
        });
        $("#OpenChestButton").SetPanelEvent('onmouseout', function() 
        {
            $.DispatchEvent('DOTAHideTextTooltip', $("#OpenChestButton")); 
        });
    }
    else if (data.is_only_one_open && IsChestOpened(data.chest_id))
    {
        $("#ChestCostIcon").visible = false
        $("#OpenChestButton").ClearPanelEvent( "onmouseover" )
        $("#ChestCostLabel").text = $.Localize("#chest_is_opened")
    }
    else if (HasItemInventory(data.chest_item_id))
    {
        $("#ChestCostIcon").visible = false
        $("#ChestCostLabel").text = $.Localize("#open_chest")
    }
    else
    {
        $("#OpenChestButton").ClearPanelEvent( "onmouseover" )
        $("#ChestCostLabel").text = data.chest_cost
    }

    $("#ChestHudMainPanel").SetPanelEvent("onactivate", function() {})
    $("#ChestHudMainPanel").SetHasClass("ChestHudAnimClose", false)
    $("#ChestHudMainPanel").SetHasClass("ChestHudAnimOpen", true)

    $("#OpenChestButton").style.opacity = "1"
    
    if (!reopen)
    {
        Game.EmitSound("UI.Shop_Buy_start")
    }

    let blur_panel = $.GetContextPanel().FindChildTraverse("shop_window_blur")
    blur_panel.RemoveClass("shop_window_blur_hidden")
    blur_panel.AddClass("shop_window_blur")

    blur_panel.SetPanelEvent("onactivate", function() 
    {
        CloseChest()
        blur_panel.SetPanelEvent("onactivate", function() {})
    })
}

function ButtonSet(chest_id, cost, chest_items, is_no_buy, is_only_one_open, chest_item_id)
{
    if (is_no_buy && !HasItemInventory(chest_item_id))
    {
        $("#OpenChestButton").SetHasClass("no_money", false)
        $("#OpenChestButton").SetHasClass("is_chest_no_buy", true)
        $("#OpenChestButton").SetPanelEvent('onactivate', function() {})
        return
    }
    $("#OpenChestButton").SetHasClass("is_chest_no_buy", false)
    if (is_only_one_open && IsChestOpened(chest_id))
    {
        $("#OpenChestButton").SetHasClass("is_chest_has_opened", true)
        $("#OpenChestButton").SetHasClass("no_money", false)
        $("#OpenChestButton").SetPanelEvent('onactivate', function() {})
        return
    }
    $("#OpenChestButton").SetHasClass("is_chest_has_opened", false)
    if (player_table_shop == null)
    {
        $("#OpenChestButton").SetPanelEvent('onactivate', function() {})
        $("#OpenChestButton").SetHasClass("no_money", true)
        $("#ChestCostLabel").SetHasClass("chest_cost_no_money", true)
        return
    }
    if (player_table_shop.points < cost)
    {
        $("#OpenChestButton").SetPanelEvent('onactivate', function() {})
        $("#OpenChestButton").SetHasClass("no_money", true)
        $("#ChestCostLabel").SetHasClass("chest_cost_no_money", true)
        return
    }
    $("#ChestCostLabel").SetHasClass("chest_cost_no_money", false)
    if (IsHeroHasAllItemsInChest(chest_items))
    {
        $("#OpenChestButton").SetPanelEvent('onactivate', function() {})
        $("#OpenChestButton").SetHasClass("has_all_items", true)
        return
    }
    $("#OpenChestButton").SetHasClass("no_money", false)
    $("#OpenChestButton").SetPanelEvent('onactivate', function()
    {
        GameEvents.SendCustomGameEventToServer_custom( "shop_dota1x6_open_chest_get_reward", { chest_id : chest_id } );
    })
}

function CloseChest()
{
    if (loop_sound != undefined)
    {
        Game.StopSound(loop_sound)
        loop_sound = undefined     
    }

    $("#ChestHudMainPanel").hittest = false
    $("#ChestHudMainPanel").style.opacity = "0"
    $("#DropItemPanel").SetHasClass("DropItemPanelVisible", false)
    last_chest_info = null

    Game.EmitSound("UI.Shop_Category_Open")

    let blur_panel = $.GetContextPanel().FindChildTraverse("shop_window_blur")
    blur_panel.AddClass("shop_window_blur_hidden")
    blur_panel.RemoveClass("shop_window_blur")

    GameEvents.SendCustomGameEventToServer_custom( "shop_dota1x6_close_chest_checked_reward", {} );

    $("#ChestHudMainPanel").SetHasClass("ChestHudAnimClose", true)
    $("#ChestHudMainPanel").SetHasClass("ChestHudAnimOpen", false)

    $.Schedule( 0.35, function()
    {
        UpdateShards()
        UpdateSelectionSets()
        let ItemsList = $.GetContextPanel().FindChildTraverse("ItemsList")
        if (ItemsList)
        {
            InitItems()
            InitSounds()
            InitVote()
            CloseActiveChatBlock()
            InitShopItemsForHero(ItemsList)
        }
    })

    CHEST_ID_CURRENT = null
}

function ClearOldChest()
{
    $("#RollItemsListMain").RemoveAndDeleteChildren()
    $("#ItemsInChestBlock").RemoveAndDeleteChildren()
    $("#ItemsInChestBlockRare").RemoveAndDeleteChildren()
    $("#RarePanelName").style.visibility = "collapse"
    $("#RarePanelBorder").style.visibility = "collapse"
    $("#ItemsInChestBlockRare").style.visibility = "collapse"
    $("#RollItemsListMain").style.position = "0px 0px 0px"
}

function ChestInitItemsInRoll(items)
{
    $("#RollItemsListMain").RemoveAndDeleteChildren()
    let copy_table = []
    let has_all_items = true
    for (let i = 0; i <= Object.keys(items).length; i++)
    {
        if (items[i] != null && !HasItemInventory(items[i].item_id) && items[i].chance == null)
        {
            has_all_items = false
        }
    }
    for (let i = 0; i <= Object.keys(items).length; i++)
    {
        if (items[i] != null && (!HasItemInventory(items[i].item_id) || has_all_items))
        {
            copy_table.push(items[i])
        }
    }
    if (copy_table.length > 0)
    {
        for (let i = 0; i <= 100; i++)
        {
            let randomIndex = Math.floor(Math.random() * copy_table.length);
            let randomElement = copy_table[randomIndex];
            CreateItemInfo($("#RollItemsListMain"), randomElement, 0, true, DROP_SLOT == i, i)
        }
    }
    $("#RollItemsListMain").style.position = "0px 0px 0px"
}  

function ChestInitItemsInChest(items)
{
    for (let i = 0; i <= Object.keys(items).length; i++)
    {
        let item_info = items[i]
        if (item_info)
        {
            CreateItemInfo($("#ItemsInChestBlock"), item_info, i)
        }
    }
}

function CreateItemInfo(main_panel, item_info, delay_count, roll, drop_slot, c)
{
    let rare = item_info.rare
    let name = item_info.item_name
    let icon = item_info.item_icon
    let chance = item_info.chance
    let is_rare = 0

    if (chance != null && roll == null)
    {
        $("#RarePanelName").style.visibility = "visible"
        $("#RarePanelBorder").style.visibility = "visible"
        $("#ItemsInChestBlockRare").style.visibility = "visible"
        $("#ItemsInChestName").text = $.Localize("#chest_items_normal")
        main_panel = $("#ItemsInChestBlockRare")
        is_rare = 1
        $("#ChestHudMainPanel").SetHasClass("NoRareItems", false)
    }

    $.Schedule( DELAY_SPAWN_ITEMS_ANIM * delay_count, function()
    {
        let panel_id = ""
        
        if (drop_slot)
        {
            panel_id = "dropped_item"
        }

        let item_panel = $.CreatePanel("Panel", main_panel, panel_id)

        if (roll)
        {
            item_panel.AddClass("item_panel_roll")
        }
        else
        {
            item_panel.AddClass("item_panel")

        }

        let item_icon = $.CreatePanel("Panel", item_panel, "item_icon")
        item_icon.AddClass("item_icon")
        item_icon.style.backgroundImage = 'url("' + icon + '")';
        item_icon.style.backgroundSize = "100%"

        if (ITEMS_TERRORBLADE_COLOR_GEM[item_info.item_id])
        {
            let item_icon_terrorblade_color = $.CreatePanel("Panel", item_icon, "item_icon_terrorblade_color")
            item_icon_terrorblade_color.AddClass("item_icon_terrorblade_color")
            item_icon_terrorblade_color.style.washColor = ITEMS_TERRORBLADE_COLOR_GEM[item_info.item_id]
        }

       // let item_panel_name = $.CreatePanel("Panel", item_panel, "item_panel_name")
        //item_panel_name.AddClass("item_panel_name")
        //item_panel_name.style.backgroundColor = rarity_color[rare]

        //let item_name = $.CreatePanel("Label", item_panel_name, "item_name")
        //item_name.AddClass("item_name")
        //item_name.text = name

        item_panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', item_panel, name) });
        
        item_panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', item_panel); });


        let item_panel_border = $.CreatePanel("Panel", item_panel, "item_panel_border")
        item_panel_border.AddClass("item_panel_border")
        item_panel_border.style.borderBrush = 'gradient( linear, 0% 100%, 0% 20%, from(' + rarity_color[rare] + '), to( rgba(0,0,0,0.1) ) )'

        if (!roll)
        {
            if (HasItemInventory(item_info.item_id))
            {
                item_panel.AddClass("has_dropped_item")
            }
            else
            {
                if (chance != null)
                {
                    $.Schedule( 0.2, function(){
                        item_panel.AddClass("item_panel_rare")})
                }
            }
        }

        $.Schedule( 0.1, function()
        {
            item_panel.style.opacity = "1" 

            if (roll && drop_slot)
            {
                let check_pos = item_panel.style.position
                let SpaceFind = check_pos.indexOf('px');
                let center_panel = Number(check_pos.substring(0, SpaceFind))
                SOUND_TICK_WIDTH = (item_panel.actuallayoutwidth / item_panel.actualuiscale_x) + (5 * 2) 
                DROP_POS[0] = -((Number(check_pos.substring(0, SpaceFind)) - ( (item_panel.actuallayoutwidth / item_panel.actualuiscale_x) * 3) - (5 * 4)) - (item_panel.actuallayoutwidth / item_panel.actualuiscale_x))
                DROP_POS[1] = -(Number(check_pos.substring(0, SpaceFind)) - ( (item_panel.actuallayoutwidth / item_panel.actualuiscale_x) * 3) - (5 * 4))
            }
        })
    }) 
}

var loop_sound = undefined

function OpenChest(items, retry_drop, shard_counter, is_reroll)
{
    $("#ItemDropRerollButton").visible = false
    Game.EmitSound("UI.Chest_open")
    loop_sound = Game.EmitSound("UI.Chest_open2")
    let current = 0
    // НУЖНО ПЕРЕДАТЬ ДРОП АЙДИ ШМОТКИ
    if (CURRENT_DROP_ID != null)
    {
        let drop_info = items[CURRENT_DROP_ID]
        let slot_drop = $("#RollItemsListMain").FindChildTraverse("dropped_item")
        if (slot_drop)
        {   
            let item_icon = slot_drop.FindChildTraverse("item_icon")
            if (item_icon)
            {
                item_icon.style.backgroundImage = 'url("' + drop_info.item_icon + '")';
            }
            let item_panel_name = slot_drop.FindChildTraverse("item_panel_name")
            if (item_panel_name)
            {
                item_panel_name.style.backgroundColor = rarity_color[drop_info.rare]
            }
            let item_name = slot_drop.FindChildTraverse("item_name")
            if (item_name)
            {
                item_name.text = drop_info.item_name
            }
            let item_panel_border = slot_drop.FindChildTraverse("item_panel_border")
            if (item_panel_border)
            {
                item_panel_border.style.borderBrush = 'gradient( linear, 0% 100%, 0% 20%, from(' + rarity_color[drop_info.rare] + '), to( rgba(0,0,0,0.1) ) )'
            }
            let item_icon_terrorblade_color = slot_drop.FindChildTraverse("item_icon_terrorblade_color")
            if (item_icon_terrorblade_color)
            {
                if (ITEMS_TERRORBLADE_COLOR_GEM[drop_info.item_id])
                {
                    item_icon_terrorblade_color.style.washColor = ITEMS_TERRORBLADE_COLOR_GEM[drop_info.item_id]
                }
            }
        }
    }

    let randomly_max_distance = Math.floor(Math.random() * (DROP_POS[1] - DROP_POS[0] + 1) + DROP_POS[0]);
    ChestAnimate(current, randomly_max_distance, STARTING_SPEED, SOUND_TICK_WIDTH, items[CURRENT_DROP_ID], items, retry_drop, shard_counter, is_reroll)
    $("#OpenChestButton").style.opacity = "0"
}

function ChestAnimate(current, drop_distance, speed, sound_tick, item_drop_info, items, retry_drop, shard_counter, is_reroll)
{
    if ($("#ChestHudMainPanel").BHasClass("ChestHudAnimClose"))
    {
        CURRENT_DROP_ID = null
        CloseDropPanel()
        $.Schedule( 0.35, function()
        {
            UpdateShards()
            UpdateSelectionSets()
            let ItemsList = $.GetContextPanel().FindChildTraverse("ItemsList")
            if (ItemsList)
            {
                InitItems()
                InitSounds()
                InitVote()
                CloseActiveChatBlock()
                InitShopItemsForHero(ItemsList)
            }
        })
        return
    }


    if (current <= drop_distance)
    {
        $.Schedule(0.1, function() 
        {
            GiveItemDrop(item_drop_info, items, retry_drop, shard_counter, is_reroll)
        })
        return
    }
    current = current - (speed * Game.GetGameFrameTime())
    sound_tick = sound_tick - (speed * Game.GetGameFrameTime())
    if (sound_tick <= 0)
    {
        sound_tick = SOUND_TICK_WIDTH
        Game.EmitSound("random_wheel_lever")
    }
    if (current <= 0.37 * drop_distance)
    {
        speed = speed - (speed * Game.GetGameFrameTime())
    }
    speed = Math.max(30, speed);

    $("#RollItemsListMain").style.position = current + "px 0px 0px"
    $.Schedule(Game.GetGameFrameTime(), function() 
    {
		ChestAnimate(current, drop_distance, speed, sound_tick, item_drop_info, items, retry_drop, shard_counter, is_reroll)
	})
}

function GiveItemDrop(item_drop_info, items, retry_drop, shard_counter, is_reroll)
{
    $("#OpenChestButton").style.opacity = "1"
    $("#DropItemPanel").SetHasClass("DropItemPanelVisible", true)
    
    let item_icon_terrorblade_color = $("#ItemDropIcon").FindChildTraverse("item_icon_terrorblade_color")
    if (item_icon_terrorblade_color)
    {
        item_icon_terrorblade_color.DeleteAsync(0)
    }

    if (retry_drop == 1)
    {
        $("#ItemDropIcon").style.backgroundImage = 'url("file://{images}/econ/tools/battle_points_ti11_levels_5.png")';
        $("#ItemDropIcon").style.backgroundSize = "100%"
        $("#ItemDropName").text = shard_counter + $.Localize("#gift_name_shards")
    }
    else
    {
        $("#ItemDropIcon").style.backgroundImage = 'url("' + item_drop_info.item_icon + '")';
        $("#ItemDropIcon").style.backgroundSize = "100%"
        $("#ItemDropName").text = item_drop_info.item_name
        if (ITEMS_TERRORBLADE_COLOR_GEM[item_drop_info.item_id])
        {
            let item_icon_terrorblade_color = $.CreatePanel("Panel", $("#ItemDropIcon"), "item_icon_terrorblade_color")
            item_icon_terrorblade_color.AddClass("item_icon_terrorblade_color")
            item_icon_terrorblade_color.style.washColor = ITEMS_TERRORBLADE_COLOR_GEM[item_drop_info.item_id]
        }
    }

    $("#DropEffect").style.washColor = rarity_color[item_drop_info.rare]
    $("#DropEffect_top").style.washColor = rarity_color[item_drop_info.rare]
    $("#DropEffect_bottom").style.washColor = rarity_color[item_drop_info.rare]

    let item_drop_effect = $.CreatePanel("DOTAParticleScenePanel", $("#ChestHudMainPanel"), "", {particleName:"particles/ui/ui_generic_treasure_impact.vpcf", renderdeferred:"true", particleonly:"false", startActive:"true", cameraOrigin:"0 0 300", lookAt:"0 0 0", fov:"60"})
    item_drop_effect.AddClass("item_drop_effect")
    item_drop_effect.hittest = false
    item_drop_effect.DeleteAsync(3)

    Game.EmitSound("ui.treasure_01")

    if (loop_sound != undefined)
    {
        Game.StopSound(loop_sound)  
        loop_sound = undefined   
    }
   
    $("#ItemDropClaimButton").SetPanelEvent('onactivate', function()
    {
        if (last_chest_info != null)
        {
            InitChest(last_chest_info, true)
        }
        CloseDropPanel()
        $.Schedule( 0.35, function()
        {
            UpdateShards()
            UpdateSelectionSets()
            let ItemsList = $.GetContextPanel().FindChildTraverse("ItemsList")
            if (ItemsList)
            {
                InitItems()
                InitSounds()
                InitVote()
                CloseActiveChatBlock()
                InitShopItemsForHero(ItemsList)
            }
        })
    })

    if (is_reroll == 1)
    {
        $("#ItemDropRerollButton").SetPanelEvent('onactivate', function()
        {
            InitChest(last_chest_info, true)
            $.Schedule( 0.25, function()
            {
                GameEvents.SendCustomGameEventToServer_custom( "shop_dota1x6_open_chest_get_reward", { chest_id : CHEST_ID_CURRENT, rerolled : true } );
            })
            CloseDropPanel(true)
        })
        $("#ItemDropRerollButton").visible = true
    }
    
    CURRENT_DROP_ID = null
}

function CloseDropPanel(is_reroll)
{
    if (!is_reroll)
    {
        GameEvents.SendCustomGameEventToServer_custom( "shop_dota1x6_close_chest_checked_reward", {} );
    }
    $("#RollItemsListMain").style.position = "0px 0px 0px"
    $("#DropItemPanel").SetHasClass("DropItemPanelVisible", false)
}

function GetItemPositionInDropList(id, items)
{
    for (let i = 0; i <= Object.keys(items).length; i++)
    {
        let item_info = items[i]
        if (item_info && item_info.item_id == id)
        {
            return i
        }
    }
    return null
}

function IsHeroHasAllItemsInChest(items)
{
    let all_items = true
    for (let i = 0; i <= Object.keys(items).length; i++)
    {
        let item_info = items[i]
        if (item_info && !HasItemInventory(item_info.item_id))
        {
            all_items = false
            break
        }
    }
    return all_items
}