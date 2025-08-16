if shop == nil then
    shop = class({})
    shop.saved_players_chest_items = {}
end

function HasDonateItem(id, item_id)
	local player_table = CustomNetTables:GetTableValue("sub_data", tostring(id))
	if player_table then
		if player_table.items_ids then
			for _, item_id_data in pairs(player_table.items_ids) do
				if tostring(item_id_data) == tostring(item_id) then
					return true
				end
			end
		end
	end
	return false
end

function shop:shop_buy_item_player(data)
    if data.PlayerID == nil then return end
    local id = data.PlayerID
    local item_id = tonumber(data.item_id)
    local is_item_bundle = nil

    local cost = 0

    for _,chat_item in pairs(Sound_list.general_ru) do 
    	if chat_item[1] == item_id then 
    		cost = chat_item[3]
    	end
    end

    if cost == 0 then 
	    for _,chat_item in pairs(Sound_list.general_eng) do 
	    	if chat_item[1] == item_id then 
	    		cost = chat_item[3]
	    	end
	    end
    end

    if cost == 0 then 
	    for _,chat_item in pairs(Sound_list.general_other) do 
	    	if chat_item[1] == item_id then 
	    		cost = chat_item[3]
	    	end
	    end
    end

    if cost == 0 then 
    	for _,pet_item in pairs(pets_item_list) do 
    		if (pet_item[1] == item_id) then 
    			cost = pet_item[4]
    		end
    	end
    end

    if cost == 0 then 
    	for _,tip_item in pairs(tips_item_list) do 
    		if (tip_item[1] == item_id) then 
    			cost = tip_item[4]
    		end
    	end
    end

    if cost == 0 then 
    	for _,tip_item in pairs(high_five_item_list) do 
    		if (tip_item[1] == item_id) then 
    			cost = tip_item[4]
    		end
    	end
    end

	if cost == 0 then
        if data.hero ~= nil then
            if wearables_system.items_data[tostring(data.hero)] then
                for _, item_info in pairs(wearables_system.items_data[tostring(data.hero)]) do 
                    if (item_info["item_id"] == item_id) then 
                        cost = item_info["price"]

                        if item_info["sale_price"] and item_info["sale_price"] > 0 then 
                        	cost = item_info["sale_price"]
                        end 
 
                        if item_info["OtherItemsBundle"] ~= nil then
                            is_item_bundle = item_info["OtherItemsBundle"]
                        end
                        break
                    end
                end
            end
        end
    end

    if cost == 0 and item_id == -1 then 
    	cost = CustomNetTables:GetTableValue('shop_items', 'votes_cost').cost*data.votes
    end

    if cost == 0 then 
    	return
    end

    local player = PlayerResource:GetPlayer(id)
    local player_table = CustomNetTables:GetTableValue('sub_data', tostring(id))
    local player_items_table = {}

    if player_table then

    	if player_table.points < cost then return end

        if player_table.items_ids then
            for k, v in pairs(player_table.items_ids) do
                table.insert(player_items_table, v)
            end
        end

        player_table.points = player_table.points - cost
        
		if data.item_id == -1 then 
		    player_table.votes_count = player_table.votes_count + data.votes
		    HTTP.BuyItem( data.PlayerID, "vote", cost, data.votes )
		else
		    table.insert(player_items_table, item_id)
		    if is_item_bundle ~= nil then
		        for _, item_bundle in pairs(is_item_bundle) do
		            if item_id ~= item_bundle[1] then
		                table.insert(player_items_table, item_bundle[1])
		            end
		        end
		    end
            if item_id == 23095 then
                table.insert(player_items_table, 23096)
                table.insert(player_items_table, 23098)
                table.insert(player_items_table, 23099)
                table.insert(player_items_table, 23097)
                HTTP.BuyItem( data.PlayerID, 23096, 0 )
                HTTP.BuyItem( data.PlayerID, 23098, 0 )
                HTTP.BuyItem( data.PlayerID, 23099, 0 )
                HTTP.BuyItem( data.PlayerID, 23097, 0 )
            end
            if item_id == 12930 then
                table.insert(player_items_table, 13768)
                table.insert(player_items_table, 13769)
                table.insert(player_items_table, 13770)
                HTTP.BuyItem( data.PlayerID, 13768, 0 )
                HTTP.BuyItem( data.PlayerID, 13769, 0 )
                HTTP.BuyItem( data.PlayerID, 13770, 0 )
            end
            
            if item_id == 13456 then
                table.insert(player_items_table, 13760)
                table.insert(player_items_table, 13743)
                table.insert(player_items_table, 13571)
                table.insert(player_items_table, 13473)
                table.insert(player_items_table, 13569)
                HTTP.BuyItem( data.PlayerID, 13760, 0 )
                HTTP.BuyItem( data.PlayerID, 13743, 0 )
                HTTP.BuyItem( data.PlayerID, 13571, 0 )
                HTTP.BuyItem( data.PlayerID, 13473, 0 )
                HTTP.BuyItem( data.PlayerID, 13569, 0 )
            end

			if item_id == 18539 then
				table.insert(player_items_table, 18540)
				table.insert(player_items_table, 18542)
				table.insert(player_items_table, 18543)
				table.insert(player_items_table, 18544)
				table.insert(player_items_table, 18541)
				HTTP.BuyItem( data.PlayerID, 18540, 0 )
				HTTP.BuyItem( data.PlayerID, 18542, 0 )
				HTTP.BuyItem( data.PlayerID, 18543, 0 )
				HTTP.BuyItem( data.PlayerID, 18544, 0 )
				HTTP.BuyItem( data.PlayerID, 18541, 0 )
			end 

            if item_id == 19090 then
			    table.insert(player_items_table, 19091)
			    table.insert(player_items_table, 19092)
			    table.insert(player_items_table, 19093)
			    table.insert(player_items_table, 19094)
			    table.insert(player_items_table, 19088)
			    table.insert(player_items_table, 19089)
			    HTTP.BuyItem( data.PlayerID, 19091, 0 )
			    HTTP.BuyItem( data.PlayerID, 19092, 0 )
			    HTTP.BuyItem( data.PlayerID, 19093, 0 )
			    HTTP.BuyItem( data.PlayerID, 19094, 0 )
			    HTTP.BuyItem( data.PlayerID, 19088, 0 )
			    HTTP.BuyItem( data.PlayerID, 19089, 0 )
			end

            if item_id == 7756 then
			    table.insert(player_items_table, 29687)
			    HTTP.BuyItem( data.PlayerID, 29687, 0 )
			end

            if item_id == 23697 then
                table.insert(player_items_table, 24100)
                HTTP.BuyItem( data.PlayerID, 24100, 0 )
            end

            if item_id == 2059 then
                table.insert(player_items_table, 30261)
                HTTP.BuyItem( data.PlayerID, 30261, 0 )
            end

            if item_id == 12964 then
                table.insert(player_items_table, 12968)
                HTTP.BuyItem( data.PlayerID, 12968, 0 )
                table.insert(player_items_table, 12965)
                HTTP.BuyItem( data.PlayerID, 12965, 0 )
                table.insert(player_items_table, 12966)
                HTTP.BuyItem( data.PlayerID, 12966, 0 )
            end
            if item_id == 5396 then
                table.insert(player_items_table, 5395)
                HTTP.BuyItem( data.PlayerID, 5395, 0 )
            end
            if item_id == 8271 then
                table.insert(player_items_table, 8324)
                HTTP.BuyItem( data.PlayerID, 8324, 0 )
            end
            if item_id == 7277 then
                table.insert(player_items_table, 7276)
                HTTP.BuyItem( data.PlayerID, 7276, 0 )
            end
            if item_id == 8734 then
                table.insert(player_items_table, 8735)
                HTTP.BuyItem( data.PlayerID, 8735, 0 )
            end
            if item_id == 14512 then
                table.insert(player_items_table, 14510)
                HTTP.BuyItem( data.PlayerID, 14510, 0 )
            end
            if item_id == 24931 then
                table.insert(player_items_table, 24932)
                HTTP.BuyItem( data.PlayerID, 24932, 0 )
            end
            if item_id == 23781 then
                table.insert(player_items_table, 23782)
                HTTP.BuyItem( data.PlayerID, 23782, 0 )
            end
		    player_table.items_ids = player_items_table
		    HTTP.BuyItem( data.PlayerID, item_id, math.abs( cost ) )
		end

        CustomNetTables:SetTableValue('sub_data', tostring(id), player_table)
    end
end


-- Массив с информацией предмета в магазине
_G.pets_item_list =
{
	-- ID предмета(не должен повторяться с айдишниками звуков) ID курьера с данными для создания, имя в магазине/иконки, стоимость в магазине
	{1001, 1, "pets_1", 2000, "file://{images}/econ/courier/minipudge/minipudge.png"},
	{1002, 2, "pets_2", 2000, "file://{images}/econ/courier/donkey_trio/mesh/donkey_trio.png"},
	{1003, 3, "pets_3", 800, "file://{images}/econ/loading_screens/duskie.png"},
	{1004, 4, "pets_4", 800, "file://{images}/econ/items/courier/snaggletooth_red_panda/snaggletooth_red_panda.png"},
	{1005, 5, "pets_5", 800, "file://{images}/econ/items/courier/beaverknight/beaverknight.png"},
	{1006, 6, "pets_6", 2000, "file://{images}/econ/items/courier/shagbark/shagbark.png"},
	{1007, 7, "pets_7", 2000, "file://{images}/econ/courier/baby_rosh/babyroshan.png"},
	{1008, 8, "pets_8", 500, "file://{images}/econ/items/courier/mighty_chicken/mighty_chicken.png"},
	{1009, 9, "pets_9", 300, "file://{images}/econ/courier/donkey_radiant_default.png"},
	{1010, 10, "pets_10", 800, "file://{images}/econ/items/courier/wabbit/wabbit.png"},
	{1011, 11, "pets_11", 2000, "file://{images}/econ/items/courier/shibe_dog_cat/shibe_dog_cat.png"},
	{1012, 12, "pets_12", 2000, "file://{images}/econ/items/courier/butch_pudge_dog/butch_pudge_dog.png"},
	{1013, 13, "pets_13", 500, "file://{images}/econ/props_gameplay/donkey1.png"},
	{1014, 14, "pets_14", 800, "file://{images}/econ/items/courier/captain_bamboo/captain_bamboo.png"},
	{1015, 15, "pets_15", 800, "file://{images}/econ/items/courier/el_gato_beyond_the_summit/el_gato_beyond_the_summit_flying.png"},
	{1016, 16, "pets_16", 800, "file://{images}/econ/items/courier/itsy/itsy.png"},
	{1017, 17, "pets_17", 800, "file://{images}/custom_game/shop/pet_wolf.png"},
	{1018, 18, "pets_18", 2000, "file://{images}/econ/pets/icewrack_wolf_alt/cm_persona_pet.png"},
	{1019, 19, "pets_19", 800, "file://{images}/econ/pets/almond_the_frondillo/almond_the_frondillo.png"},
	{1020, 20, "pets_20", 300, "file://{images}/custom_game/shop/pet_courier_dire.png"},
	{1021, 21, "pets_21", 2000, "file://{images}/econ/items/courier/krobeling/krobeling.png"},
	{1022, 22, "pets_22", 8000, "file://{images}/econ/courier/baby_rosh/babyroshan_ti96.png"},
	{1023, 23, "pets_23", 8000, "file://{images}/econ/courier/baby_rosh/babyroshan_winter18.png"},
	{1024, 24, "pets_24", 8000, "file://{images}/econ/courier/baby_rosh/babyroshan5.png"},
	{1025, 25, "pets_25", 8000, "file://{images}/econ/courier/baby_rosh/babyroshan_elemental2.png"},
	{1026, 26, "pets_26", 8000, "file://{images}/econ/courier/baby_rosh/babyroshan_elemental1.png"},
	{1027, 27, "pets_27", 2000, "file://{images}/econ/courier/doom_demihero_courier/doom_demihero_courier.png"},
	{1028, 28, "pets_28", 8000, "file://{images}/econ/courier/baby_rosh/babyroshan2.png"},
	{1029, 29, "pets_29", 15000, "file://{images}/econ/courier/baby_rosh/babyroshan_ti10.png"},
	{1030, 30, "pets_30", 4000, "file://{images}/econ/items/courier/courier_ti10/courier_ti10_lvl1/courier_ti10_lvl1_style3.png"},
	{1031, 31, "pets_31", 4000, "file://{images}/econ/items/courier/courier_ti10/courier_ti10_lvl1/courier_ti10_lvl1_style1.png"},
	{1032, 32, "pets_32", 4000, "file://{images}/econ/items/courier/courier_ti10/courier_ti10_lvl1/courier_ti10_lvl1_style2.png"},
	{1033, 33, "pets_33", 4000, "file://{images}/econ/items/courier/courier_ti10/courier_ti10_lvl1/courier_ti10_lvl1_style4.png"},
	{1034, 34, "pets_34", 4000, "file://{images}/econ/items/courier/courier_ti10/courier_ti10_lvl1/courier_ti10_lvl1_style5.png"},
	{1035, 35, "pets_35", 5000, "file://{images}/econ/items/courier/courier_ti10/courier_ti10_lvl1/courier_ti10_lvl1_style6.png"},
	{1036, 36, "pets_36", 2000, "file://{images}/econ/courier/huntling/huntling.png"},
	{1037, 37, "pets_37", 800, "file://{images}/econ/items/courier/hamster_courier/hamster_courier.png"},
	{1038, 38, "pets_38", 2000, "file://{images}/econ/courier/seekling/seekling.png"},
	{1039, 39, "pets_39", 2000, "file://{images}/econ/courier/venoling/venoling2.png"},
	{1040, 40, "pets_40", 2000, "file://{images}/econ/items/courier/faceless_rex/faceless_rex.png"},
	{1041, 41, "pets_41", 800, "file://{images}/econ/items/courier/courier_mvp_redkita/courier_mvp_redkita.png"},
	{1042, 42, "pets_42", 800, "file://{images}/econ/items/courier/bearzky/bearzky.png"},
	{1043, 43, "pets_43", 2000, "file://{images}/econ/items/courier/coco_the_courageous/coco_the_courageous.png"},
	{1044, 44, "pets_44", 800, "file://{images}/econ/items/courier/tinkbot/tinkbot.png"},
	{1045, 45, "pets_45", 800, "file://{images}/econ/courier/navi_courier/navi_courier.png"},
	{1046, 46, "pets_46", 800, "file://{images}/econ/courier/frog/frog.png"},
	{1047, 47, "pets_47", 800, "file://{images}/econ/items/courier/waldi_the_faithful/waldi_the_faithful.png"},
	{1048, 48, "pets_48", 2000, "file://{images}/econ/courier/baby_winter_wyvern/baby_winter_wyvern.png"},
	{1049, 49, "pets_49", 2000, "file://{images}/custom_game/shop/pet_amaterasu.png"},
	{1050, 50, "pets_50", 2000, "file://{images}/econ/courier/octopus/octopus.png"},
	{1051, 51, "pets_51", 4000, "file://{images}/custom_game/shop/Lefty_Oct.png"},
	{1052, 52, "pets_52", 4000, "file://{images}/custom_game/shop/Lefty_Ultimate.png"},
	{1053, 53, "pets_53", 4000, "file://{images}/custom_game/shop/Lefty_Refresher.png"},
	{1054, 54, "pets_54", 4000, "file://{images}/custom_game/shop/Lefty_Linken.png"},
	{1055, 55, "pets_55", 5000, "file://{images}/custom_game/shop/Lefty_Aegis.png"},
	{1056, 56, "pets_56", 800, "file://{images}/econ/items/courier/kanyu_shark/kanyu_shark.png"},
}

_G.tips_item_list =
{
    {44001, 0, "tip_0", 2500, "file://{images}/custom_game/tips/tip_0.png", "videos/custom_game/shop/tips/tip_1.webm"},
    -- Сверху оставить дефолтный
    {44002, 1, "tip_1", 1500, "file://{images}/custom_game/tips/tip_1.png", "videos/custom_game/shop/tips/tip_1.webm"},
    {44003, 2, "tip_2", 1500, "file://{images}/custom_game/tips/tip_2.png", "videos/custom_game/shop/tips/tip_2.webm"},
    {44004, 3, "tip_3", 1500, "file://{images}/custom_game/tips/tip_3.png", "videos/custom_game/shop/tips/tip_3.webm"},
    {44005, 4, "tip_4", 1500, "file://{images}/custom_game/tips/tip_4.png", "videos/custom_game/shop/tips/tip_4.webm"},
    {44006, 5, "tip_5", 1500, "file://{images}/custom_game/tips/tip_5.png", "videos/custom_game/shop/tips/tip_5.webm"},
    {44007, 6, "tip_6", 1500, "file://{images}/custom_game/tips/tip_6.png", "videos/custom_game/shop/tips/tip_6.webm"},
    {44008, 7, "tip_7", 1500, "file://{images}/custom_game/tips/tip_7.png", "videos/custom_game/shop/tips/tip_7.webm"},
    {44009, 8, "tip_8", 1500, "file://{images}/custom_game/tips/tip_8.png", "videos/custom_game/shop/tips/tip_8.webm"},
    {44010, 9, "tip_9", 1500, "file://{images}/custom_game/tips/tip_9.png", "videos/custom_game/shop/tips/tip_9.webm"},
    {44011, 10, "tip_10", 1500, "file://{images}/custom_game/tips/tip_10.png", "videos/custom_game/shop/tips/tip_10.webm"},
    {44012, 11, "tip_11", 1500, "file://{images}/custom_game/tips/tip_11.png", "videos/custom_game/shop/tips/tip_11.webm"},
    {44013, 12, "tip_12", 1500, "file://{images}/custom_game/tips/tip_12.png", "videos/custom_game/shop/tips/tip_12.webm"},
    {44014, 13, "tip_13", 1500, "file://{images}/custom_game/tips/tip_13.png", "videos/custom_game/shop/tips/tip_13.webm"},
    {44015, 14, "tip_14", 1500, "file://{images}/custom_game/tips/tip_14.png", "videos/custom_game/shop/tips/tip_14.webm"},
    {44016, 15, "tip_15", 1500, "file://{images}/custom_game/tips/tip_15.png", "videos/custom_game/shop/tips/tip_15.webm"},
    {44017, 16, "tip_16", 1500, "file://{images}/custom_game/tips/tip_16.png", "videos/custom_game/shop/tips/tip_16.webm"},
    {44018, 17, "tip_17", 1500, "file://{images}/custom_game/tips/tip_17.png", "videos/custom_game/shop/tips/tip_17.webm"},
    {44019, 18, "tip_18", 1500, "file://{images}/custom_game/tips/tip_18.png", "videos/custom_game/shop/tips/tip_18.webm"},
    {44020, 19, "tip_19", 1500, "file://{images}/custom_game/tips/tip_19.png", "videos/custom_game/shop/tips/tip_19.webm"},
}

_G.high_five_item_list =
{
    {55001, 0, "high_five_0", 1200, "file://{images}/custom_game/high_five/high_five_0.png", "videos/custom_game/shop/high_five/high_five_0.webm", "particles/econ/events/plus/high_five/high_five_impact.vpcf", "particles/econ/events/plus/high_five/high_five_lvl1_travel.vpcf", "particles/econ/events/plus/high_five/high_five_lvl1_overhead.vpcf"},
    {55002, 1, "high_five_1", 1200, "file://{images}/custom_game/high_five/high_five_1.png", "videos/custom_game/shop/high_five/high_five_1.webm", "particles/econ/events/diretide_2020/high_five/high_five_impact.vpcf", "particles/econ/events/diretide_2020/high_five/high_five_lvl1_travel.vpcf", "particles/econ/events/diretide_2020/high_five/high_five_lvl1_overhead.vpcf"},
    {55003, 2, "high_five_2", 1200, "file://{images}/custom_game/high_five/high_five_2.png", "videos/custom_game/shop/high_five/high_five_2.webm", "particles/econ/misc/high_five/aghanim_puppet_2021/high_five_agh_2021_impact.vpcf", "particles/econ/misc/high_five/aghanim_puppet_2021/high_five_agh_2021_travel.vpcf", "particles/econ/misc/high_five/aghanim_puppet_2021/high_five_agh_2021_overhead.vpcf"},
    {55004, 3, "high_five_3", 1200, "file://{images}/custom_game/high_five/high_five_3.png", "videos/custom_game/shop/high_five/high_five_3.webm", "particles/econ/events/fall_2022/high_five/high_five_fall2022_impact.vpcf", "particles/econ/events/fall_2022/high_five/high_five_fall2022_travel.vpcf", "particles/econ/events/fall_2022/high_five/high_five_fall_2022_overhead.vpcf"},
    {55005, 4, "high_five_4", 1200, "file://{images}/custom_game/high_five/high_five_4.png", "videos/custom_game/shop/high_five/high_five_4.webm", "particles/econ/events/fall_2022/high_five/high_five_foam_hand_impact.vpcf", "particles/econ/events/fall_2022/high_five/high_five_foam_hand_travel.vpcf", "particles/econ/events/fall_2022/high_five/high_five_foam_hand_overhead.vpcf"},
    {55006, 5, "high_five_5", 1200, "file://{images}/custom_game/high_five/high_five_5.png", "videos/custom_game/shop/high_five/high_five_5.webm", "particles/econ/events/frostivus_2023/high_five_mug_impact.vpcf", "particles/econ/events/frostivus_2023/high_five_mug_travel.vpcf", "particles/econ/events/frostivus_2023/high_five_mug_overhead.vpcf"},
    {55007, 6, "high_five_6", 1200, "file://{images}/custom_game/high_five/high_five_6.png", "videos/custom_game/shop/high_five/high_five_6.webm", "particles/econ/events/newbloom_2020/high_five_newbloom_impact.vpcf", "particles/econ/events/newbloom_2020/high_five_newbloom_travel.vpcf", "particles/econ/events/newbloom_2020/high_five_newbloom_overhead.vpcf"},
    {55008, 7, "high_five_7", 1200, "file://{images}/custom_game/high_five/high_five_7.png", "videos/custom_game/shop/high_five/high_five_7.webm", "particles/econ/events/plus/high_five/high_five_lvl2_impact.vpcf", "particles/econ/events/plus/high_five/high_five_lvl2_travel.vpcf", "particles/econ/events/plus/high_five/high_five_lvl2_overhead.vpcf"},
    {55009, 8, "high_five_8", 1200, "file://{images}/custom_game/high_five/high_five_8.png", "videos/custom_game/shop/high_five/high_five_8.webm", "particles/econ/events/spring_2021/high_five_spring_2021_impact.vpcf", "particles/econ/events/spring_2021/high_five_spring_2021_travel.vpcf", "particles/econ/events/spring_2021/high_five_spring_2021_overhead.vpcf"},
    {55010, 9, "high_five_9", 1200, "file://{images}/custom_game/high_five/high_five_9.png", "videos/custom_game/shop/high_five/high_five_9.webm", "particles/econ/events/spring_2021/high_five_spring_2021_impact.vpcf", "particles/econ/events/plus/high_five/high_five_lvl3_travel.vpcf", "particles/econ/events/plus/high_five/high_five_lvl3_overhead.vpcf"},
    {55011, 10, "high_five_10",5000, "file://{images}/custom_game/high_five/high_five_10.png", "videos/custom_game/shop/high_five/high_five_10.webm", "particles/econ/events/newbloom_2020/high_five_newbloom_impact.vpcf", "particles/econ/events/ti9/high_five/high_five_lvl3_travel.vpcf", "particles/econ/events/ti9/high_five/high_five_lvl3_overhead.vpcf"},
}

CustomNetTables:SetTableValue("shop_items", "pets", pets_item_list)
CustomNetTables:SetTableValue("shop_items", "tips", tips_item_list)
CustomNetTables:SetTableValue("shop_items", "high_five", high_five_item_list)
CustomNetTables:SetTableValue("shop_items", "chest", DOTA1X6_CHESTS_INFO)

CustomNetTables:SetTableValue("shop_items", "votes_cost", 
	{
		cost = 100,
		hero_stat = 1,
	}
)

-- Массив с информацией о курьере, айди, модель, партикл и материал
_G.PETS_DATA_LIST = 
{
	[1] = 
	{
		model = "models/courier/minipudge/minipudge.vmdl",
		particle = "particles/econ/courier/courier_minipudge/courier_minipudge_lvl2_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[2] = 
	{
		model = "models/courier/donkey_trio/mesh/donkey_trio.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[3] = 
	{
		model = "models/items/courier/duskie/duskie.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[4] = 
	{
		model = "models/items/courier/snaggletooth_red_panda/snaggletooth_red_panda.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[5] = 
	{
		model = "models/items/courier/beaverknight_s2/beaverknight_s2.vmdl",
		particle = nil,
		style = nil,
		scale = 30,
	},
	[6] = 
	{
		model = "models/items/courier/shagbark/shagbark.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[7] = 
	{
		model = "models/courier/baby_rosh/babyroshan.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[8] = 
	{
		model = "models/items/courier/mighty_chicken/mighty_chicken.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[9] = 
	{
		model = "models/props_gameplay/donkey.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[10] = 
	{
		model = "models/items/courier/wabbit_the_mighty_courier_of_heroes/wabbit_the_mighty_courier_of_heroes.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},

	[11] = 
	{
		model = "models/items/courier/shibe_dog_cat/shibe_dog_cat.vmdl",
		particle = "particles/econ/courier/courier_shibe/courier_shibe_ambient.vpcf",
		style = nil,
		scale = 0,
	},

	[12] = 
	{
		model = "models/items/courier/butch_pudge_dog/butch_pudge_dog.vmdl",
		particle = "particles/econ/courier/courier_butch/courier_butch_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[13] = 
	{
		model = "models/props_gameplay/donkey.vmdl",
		particle = nil,
		style = "1",
		scale = 0,
	},
	[14] = 
	{
		model = "models/items/courier/captain_bamboo/captain_bamboo.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[15] = 
	{
		model = "models/items/courier/el_gato_beyond_the_summit/el_gato_beyond_the_summit.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[16] = 
	{
		model = "models/items/courier/itsy/itsy.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},

	[17] = 
	{
		model = "models/pets/icewrack_wolf/icewrack_wolf.vmdl",
		particle = nil,
		style = nil,
		scale = 10,
	},
	[18] = 
	{
		model = "models/pets/icewrack_wolf_alt/icewrack_wolf_alt.vmdl",
		particle = nil,
		style = nil,
		scale = 15,
	},
	[19] = 
	{
		model = "models/pets/armadillo/armadillo.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[20] = 
	{
		model = "models/props_gameplay/donkey_dire.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},

	[21] = 
	{
		model = "models/items/courier/krobeling/krobeling_flying.vmdl",
		particle = "particles/econ/courier/courier_krobeling/courier_krobeling_ambient_hair.vpcf",
		style = nil,
		scale = 20,
	},

	[22] = 
	{
		model = "models/courier/baby_rosh/babyroshan_ti9.vmdl",
		particle = "particles/econ/courier/courier_babyroshan_ti9/courier_babyroshan_ti9_ambient.vpcf",
		style = nil,
		scale = 0,
	},

	[23] = 
	{
		model = "models/courier/baby_rosh/babyroshan_winter18.vmdl",
		particle = "particles/econ/courier/courier_babyroshan_winter18/courier_babyroshan_winter18_ambient.vpcf",
		style = nil,
		scale = 0,
	},

	[24] = 
	{
		model = "models/courier/baby_rosh/babyroshan.vmdl",
		particle = "particles/econ/courier/courier_roshan_ti8/courier_roshan_ti8.vpcf",
		style = "5",
		scale = 0,
	},

	[25] = 
	{
		model = "models/courier/baby_rosh/babyroshan_elemental.vmdl",
		particle = "particles/econ/courier/courier_roshan_frost/courier_roshan_frost_ambient.vpcf",
		style = "2",
		scale = 0,
	},

	[26] = 
	{
		model = "models/courier/baby_rosh/babyroshan_elemental.vmdl",
		particle = "particles/econ/courier/courier_roshan_lava/courier_roshan_lava.vpcf",
		style = "1",
		scale = 0,
	},

	[27] = 
	{
		model = "models/courier/doom_demihero_courier/doom_demihero_courier.vmdl",
		particle = "particles/econ/courier/courier_doomling/courier_doomling_ambient.vpcf",
		style = nil,
		scale = 25,
	},

	[28] = 
	{
		model = "models/courier/baby_rosh/babyroshan.vmdl",
		particle = "particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf",
		style = "2",
		scale = 0,
	},
	[29] = 
	{
		model = "models/courier/baby_rosh/babyroshan_ti10_dire.vmdl",
		particle = "particles/econ/courier/courier_babyroshan_ti10/courier_babyroshan_ti10_dire_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[30] = 
	{
		model = "models/items/courier/courier_ti10_radiant/courier_ti10_radiant_lvl4/courier_ti10_radiant_lvl4.vmdl",
		particle = "particles/econ/courier/courier_ti10/courier_ti10_lvl4_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[31] = 
	{
		model = "models/items/courier/courier_ti10_radiant/courier_ti10_radiant_lvl2/courier_ti10_radiant_lvl2.vmdl",
		particle = "particles/econ/courier/courier_ti10/courier_ti10_lvl2_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[32] = 
	{
		model = "models/items/courier/courier_ti10_radiant/courier_ti10_radiant_lvl3/courier_ti10_radiant_lvl3.vmdl",
		particle = "particles/econ/courier/courier_ti10/courier_ti10_lvl3_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[33] = 
	{
		model = "models/items/courier/courier_ti10_radiant/courier_ti10_radiant_lvl5/courier_ti10_radiant_lvl5.vmdl",
		particle = "particles/econ/courier/courier_ti10/courier_ti10_lvl5_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[34] = 
	{
		model = "models/items/courier/courier_ti10_radiant/courier_ti10_radiant_lvl6/courier_ti10_radiant_lvl6.vmdl",
		particle = "particles/econ/courier/courier_ti10/courier_ti10_lvl6_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[35] = 
	{
		model = "models/items/courier/courier_ti10_radiant/courier_ti10_radiant_lvl7/courier_ti10_radiant_lvl7.vmdl",
		particle = "particles/econ/courier/courier_ti10/courier_ti10_lvl7_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[36] = 
	{
		model = "models/courier/huntling/huntling.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[37] = 
	{
		model = "models/items/courier/hamster_courier/hamster_courier_lv1.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[38] = 
	{
		model = "models/courier/seekling/seekling.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[39] = 
	{
		model = "models/courier/venoling/venoling.vmdl",
		particle = "particles/econ/courier/courier_venoling/courier_venoling_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[40] = 
	{
		model = "models/items/courier/faceless_rex/faceless_rex.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[41] = 
	{
		model = "models/items/courier/courier_mvp_redkita/courier_mvp_redkita.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[42] = 
	{
		model = "models/items/courier/bearzky/bearzky.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[43] = 
	{
		model = "models/items/courier/coco_the_courageous/coco_the_courageous.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[44] = 
	{
		model = "models/items/courier/tinkbot/tinkbot.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[45] = 
	{
		model = "models/courier/navi_courier/navi_courier.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[46] = 
	{
		model = "models/courier/frog/frog.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[47] = 
	{
		model = "models/items/courier/waldi_the_faithful/waldi_the_faithful.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},
	[48] = 
	{
		model = "models/courier/baby_winter_wyvern/baby_winter_wyvern.vmdl",
		particle = "particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_ice.vpcf",
		style = nil,
		scale = 0,
	},
	[49] = 
	{
		model = "models/items/courier/amaterasu/amaterasu.vmdl",
		particle = "particles/econ/courier/courier_amaterasu/courier_amaterasu_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[50] = 
	{
		model = "models/courier/octopus/octopus.vmdl",
		particle = "particles/econ/courier/courier_oculopus/courier_oculopus_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[51] = 
	{
		model = "models/items/courier/hand_courier/hand_courier_radiant_lv6.vmdl",
		particle = "particles/econ/courier/hand_courier/hand_courier_dire_lv6/hand_courier_dire_lv6_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[52] = 
	{
		model = "models/items/courier/hand_courier/hand_courier_radiant_lv3.vmdl",
		particle = "particles/econ/courier/hand_courier/hand_courier_dire_lv3/hand_courier_dire_lv3_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[53] = 
	{
		model = "models/items/courier/hand_courier/hand_courier_radiant_lv5.vmdl",
		particle = "particles/econ/courier/hand_courier/hand_courier_dire_lv5/hand_courier_dire_lv5_ambient.vpcf",
		style = nil,
		scale = 0,
	},
	[54] = 
	{
		model = "models/items/courier/hand_courier/hand_courier_radiant_lv4.vmdl",
		particle = "particles/econ/courier/hand_courier/hand_courier_dire_lv4/hand_courier_dire_lv4_ambient.vpcf",
		style = nil,
		scale = 0,
	},

	[55] = 
	{
		model = "models/items/courier/hand_courier/hand_courier_radiant_lv7.vmdl",
		particle = "particles/econ/courier/hand_courier/hand_courier_dire_lv7/hand_courier_dire_lv7_ambient.vpcf",
		style = nil,
		scale = 0,
	},

	[56] = 
	{
		model = "models/items/courier/kanyu_shark/kanyu_shark.vmdl",
		particle = nil,
		style = nil,
		scale = 0,
	},

	
}









function shop:AddCourierParticle(particle, pet)

pet.particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, pet)	


if particle == "particles/econ/courier/courier_doomling/courier_doomling_ambient.vpcf" then 
	ParticleManager:SetParticleControlEnt(pet.particle, 0, pet, PATTACH_POINT_FOLLOW, "attach_weapon", pet:GetAbsOrigin(), true)
end

if particle == "particles/econ/courier/courier_faceless_rex/cour_rex_flying.vpcf" then 
	ParticleManager:SetParticleControlEnt(pet.particle, 0, pet, PATTACH_POINT_FOLLOW, "attach_hitloc", pet:GetAbsOrigin(), true)

end

end


function shop:ChangePetPremium(data)
	if data.PlayerID == nil then return end
	local id = data.PlayerID
	local pet_id = tonumber(data.pet_id)				
	local player =	PlayerResource:GetPlayer(id)

	local player_table = CustomNetTables:GetTableValue('sub_data', tostring(id))
	if player_table then
		player_table.pet_id = pet_id
		CustomNetTables:SetTableValue('sub_data', tostring(id), player_table)
	end

	if not PETS_DATA_LIST[pet_id] and pet_id ~= 0 then 
		return
	end

	if player then
		local hero = player:GetAssignedHero()
		if hero:GetUnitName() ~= "npc_dota_hero_wisp" then
			if player.pet and player.pet ~= nil and data.delete_pet == 0 then
				player.pet:SetModel(PETS_DATA_LIST[pet_id].model)
				player.pet:SetOriginalModel(PETS_DATA_LIST[pet_id].model)

				player.pet:AddNewModifier( hero, nil, "modifier_donate_pet", {scale = PETS_DATA_LIST[pet_id].scale } )

				if player.pet.particle then
					ParticleManager:DestroyParticle(player.pet.particle, true)
					player.pet.particle = nil
				end

				if PETS_DATA_LIST[pet_id].particle ~= nil then
					shop:AddCourierParticle(PETS_DATA_LIST[pet_id].particle, player.pet)
				end		

				if PETS_DATA_LIST[pet_id].style ~= nil then
					player.pet:SetMaterialGroup(PETS_DATA_LIST[pet_id].style)
				else
					player.pet:SetMaterialGroup("default")
				end	
			elseif player.pet and player.pet ~= nil and data.delete_pet == 1 then
				UTIL_Remove(player.pet)
				player.pet = nil
			else
				player.pet = CreateUnitByName("npc_dota_donate_pet", hero:GetAbsOrigin() + RandomVector(RandomFloat(0,100)), true, hero, nil, hero:GetTeamNumber())

				local ability = player.pet:FindAbilityByName("donate_pet_ability")
				if ability then 
					ability:SetLevel(1)
				end 

				--player.pet:SetOwner(hero)
				player.pet:AddNewModifier( hero, nil, "modifier_donate_pet", {scale = PETS_DATA_LIST[pet_id].scale } )
				--player.pet:AddNewModifier( hero, nil, "modifier_pet", {} )
				player.pet:SetModel(PETS_DATA_LIST[pet_id].model)
				player.pet:SetOriginalModel(PETS_DATA_LIST[pet_id].model)

				if PETS_DATA_LIST[pet_id].particle ~= nil then
					shop:AddCourierParticle(PETS_DATA_LIST[pet_id].particle, player.pet)
				end

				if PETS_DATA_LIST[pet_id].style ~= nil then
					player.pet:SetMaterialGroup(PETS_DATA_LIST[pet_id].style)
				else
					player.pet:SetMaterialGroup("default")
				end
			end
		end
	end
end

-- Функция спавна курьера если у игрока в данных есть его айди сервера. Можно вызывать при спавне героя
function shop:AddPetFromStart(id)
	local pet_id = nil
	local player =	PlayerResource:GetPlayer(id)

	local player_table = CustomNetTables:GetTableValue('sub_data', tostring(id))
	if player_table and player_table.pet_id then
		pet_id = player_table.pet_id
	end

	if player then
		local hero = player:GetAssignedHero()
		if hero:GetUnitName() ~= "npc_dota_hero_wisp" and pet_id ~= 0 and pet_id ~= nil and pet_id ~= "0" then
			player.pet = CreateUnitByName("npc_dota_donate_pet", hero:GetAbsOrigin() + RandomVector(RandomFloat(0,100)), true, hero, nil, hero:GetTeamNumber())

			local ability = player.pet:FindAbilityByName("donate_pet_ability")
			if ability then 
				ability:SetLevel(1)
			end 

			--player.pet:SetOwner(hero)
			player.pet:AddNewModifier( hero, nil, "modifier_donate_pet", {scale = PETS_DATA_LIST[pet_id].scale} )
			--player.pet:AddNewModifier( hero, nil, "modifier_pet", {} )
			player.pet:SetModel(PETS_DATA_LIST[pet_id].model)
			player.pet:SetOriginalModel(PETS_DATA_LIST[pet_id].model)

			if PETS_DATA_LIST[pet_id].particle ~= nil then
				shop:AddCourierParticle(PETS_DATA_LIST[pet_id].particle, player.pet)
			end

			if PETS_DATA_LIST[pet_id].style ~= nil then
				player.pet:SetMaterialGroup(PETS_DATA_LIST[pet_id].style)
			else
				player.pet:SetMaterialGroup("default")
			end
		end
	end
end



function shop:heroes_vote_change(kv)
local player =	PlayerResource:GetPlayer(kv.PlayerID)

if not player then return end
if not kv.count then return end
if not kv.name then return end

local heroes_vote = CustomNetTables:GetTableValue("sub_data", "heroes_vote")

for i = 1,3 do 
	if (heroes_vote.vote_table[tostring(i)]) then 
		if heroes_vote.vote_table[tostring(i)]['1'] == kv.name then 
			heroes_vote.vote_table[tostring(i)]['2'] = heroes_vote.vote_table[tostring(i)]['2'] + kv.count
			heroes_vote.vote_table[tostring(i)]['3'] = heroes_vote.vote_table[tostring(i)]['3'] + kv.count
		end
	end
end


CustomNetTables:SetTableValue("sub_data", "heroes_vote", heroes_vote)



local sub_data = CustomNetTables:GetTableValue('sub_data', tostring(kv.PlayerID))

if not sub_data then return end 

local count = sub_data.votes_count

sub_data.votes_count = math.max(0, sub_data.votes_count - kv.count)

HTTP.Vote( kv.PlayerID, kv.name, kv.count )

CustomNetTables:SetTableValue('sub_data', tostring(kv.PlayerID), sub_data)
end



function shop:heroes_vote_free(kv)
	local player =	PlayerResource:GetPlayer(kv.PlayerID)
	
	if not player then return end
	
	local sub_data = CustomNetTables:GetTableValue('sub_data', tostring(kv.PlayerID))
	
	sub_data.votes_count = sub_data.votes_count + 1
	sub_data.free_vote_cd = shop_free_vote_cd

	HTTP.BonusVotes( kv.PlayerID, 1, sub_data.free_vote_cd * 1000 )

	
	CustomNetTables:SetTableValue('sub_data', tostring(kv.PlayerID), sub_data)
end




function shop:get_bonus_shards(kv)
	local player =	PlayerResource:GetPlayer(kv.PlayerID)
	
	if not player then return end
	
	local sub_data = CustomNetTables:GetTableValue('sub_data', tostring(kv.PlayerID))
	
	
	if sub_data.bonus_shards_cd > 0 then
		return
	end
	
	local count = RandomInt(shop_daily_shards_min, shop_daily_shards_max)
	local limit = 0
	
	local change = count
	
	if sub_data.subscribed == 0 then 
	
		if sub_points_max - sub_data.points <= count then
			limit = 1
		end 
	
		change = math.min(math.max(sub_points_max - sub_data.points, 0), count)
	
		sub_data.points = sub_data.points + change
	else 
		sub_data.points = sub_data.points + count
	end

	sub_data.bonus_shards_cd = shop_daily_shards_cd

	HTTP.BonusShards( kv.PlayerID, math.abs( change ), sub_data.bonus_shards_cd * 1000 )

	CustomNetTables:SetTableValue('sub_data', tostring(kv.PlayerID), sub_data)


	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(kv.PlayerID), 'give_bonus_shards', {count = count, limit = limit} ) 
end


function shop:browser_subscribe(kv)
if not IsServer() then return end
local player =	PlayerResource:GetPlayer(kv.PlayerID)

if not player then return end

HTTP.Login(kv.PlayerID, kv.item_name) 

end




function shop:SelectQuest(kv)
if not IsServer() then return end
local player =	PlayerResource:GetPlayer(kv.PlayerID)
if not player then return end

local sub_data = CustomNetTables:GetTableValue('sub_data', tostring(kv.PlayerID))

if not sub_data or sub_data.subscribed == 0 then return end

if SelectedQuests[kv.PlayerID] ~= nil then return end

SelectedQuests[kv.PlayerID] = kv.name


end

-- Function Update Tip Wheel
function shop:update_tip_list(data)
if data.PlayerID == nil then return end
local id = data.PlayerID
local tip_id = tonumber(data.tip_id)	
local delete = data.delete			
local player =	PlayerResource:GetPlayer(id)
local player_table = CustomNetTables:GetTableValue('sub_data', tostring(id))

if not player_table or not player_table.player_tips or not player_table.selected_tip then return end

local selected = player_table.selected_tip
local player_tips_wheel_change = {}

for i,id in pairs(player_table.player_tips) do 
	player_tips_wheel_change[tostring(i)] = id
end 

local max = 0
for i,id in pairs(player_tips_wheel_change) do 
	if tonumber(i) >= max then 
		max = tonumber(i)
	end 
end 


if delete == 1 then

	for i = 1,max do 
		if player_tips_wheel_change[tostring(i)] == tip_id then 
            player_tips_wheel_change[tostring(i)] = 0
            break
		end 
	end 

else

    local has_null = false

	for i,id in pairs(player_tips_wheel_change) do 
		if id == tip_id then 
			return
		end 
	end 


	for i = 1,max do 
		if player_tips_wheel_change[tostring(i)] == 0 then 
            player_tips_wheel_change[tostring(i)] = tip_id
            selected = tostring(i)
            has_null = true
            break
		end 
	end 

    if not has_null then
        player_tips_wheel_change["1"] = tip_id
        selected = "1"
    end

    player_table.selected_tip = selected
end



for i,id in pairs(player_tips_wheel_change) do 
	player_table.player_tips[tostring(i)] = id
end 

if delete == 1 then 

	if selected and selected ~= "0" and (not player_table.player_tips[selected] or player_table.player_tips[selected] == 0) then 
		
		player_table.selected_tip = "0"

		for i = 1,max do
			if player_table.player_tips[tostring(i)] ~= 0 then 
				player_table.selected_tip = tostring(i)
				break
			end
		end 
	end 


end 


CustomNetTables:SetTableValue('sub_data', tostring(id), player_table)
CustomGameEventManager:Send_ServerToPlayer(player, "shop_update_tips_and_fives", {})
end





-- function Select Current Tip
function shop:select_current_tip(data)
if data.PlayerID == nil then return end
local id = data.PlayerID
local tip_id = tostring(data.tip_id)
local player = PlayerResource:GetPlayer(id)
local sub_data = CustomNetTables:GetTableValue('sub_data', tostring(id))



if sub_data and sub_data.player_tips and ((sub_data.player_tips[tip_id] ~= nil and sub_data.player_tips[tip_id] ~= 0) or tip_id == '0') then 
	sub_data.selected_tip = tip_id
	CustomNetTables:SetTableValue("sub_data", tostring(id), sub_data)
end
CustomGameEventManager:Send_ServerToPlayer(player, "shop_update_tips_and_fives", {})
end 

function shop:select_current_high_five(data)
    if data.PlayerID == nil then return end
    local id = data.PlayerID
    local high_five_id = data.high_five_id
    local sub_data = CustomNetTables:GetTableValue('sub_data', tostring(id))
    if sub_data then 
        sub_data.selected_high_five = high_five_id
        CustomNetTables:SetTableValue("sub_data", tostring(id), sub_data)
    end
end

function shop:GetHighFiveData(id)
    for _, data in pairs(high_five_item_list) do
        if data[2] == id then
            return {data[7], data[8], data[9]}
        end
    end
end


function shop:send_promo_code(data)
if data.PlayerID == nil then return end

local id = data.PlayerID
local text = data.text

if not text or text == "" then return end
local player =	PlayerResource:GetPlayer(id)
if not player then return end 

local player_table = players[id]

if not player_table then return end 

if player_table.promo_cd > 0 then 
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "panorama_cooldown_error", {message="#dota_item_change_error", time = player_table.promo_cd})
	return
end 

local send_data = 
{
	matchId = tostring(GameRules:Script_GetMatchID()), 
    matchKey = HTTP.MATCH_KEY,
    code = data.text, 
	playerId = tostring( PlayerResource:GetSteamAccountID( id ))	
}

HTTP.Request( "/promo", send_data, function( data )

	local status = -1
	local eng = ""
	local ru = ""
	local amount = 0
	local name = ""

	if data then
		status = data.status
		ru = data.ruResponse
		eng = data.engResponse
		if data.awardsAmount then 
			amount = data.awardsAmount
		end
		if data.awardsName then 
			name = data.awardsName
		end
		if status == 0 then 
			local steamIDs = {}
			table.insert( steamIDs, tostring( PlayerResource:GetSteamAccountID( id )))

			dota1x6:SendState(steamIDs)
		end 
	end

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "answer_promo_code", {status = status, ru = ru, eng = eng, amount = amount, name = name})	
end, nil, false )

player_table.promo_cd = 3
end



function shop:CheckGifts(for_id)
if not IsServer() then return end

local steamIDs = {}

for id = 0, 24 do
	if PlayerResource:IsValidPlayerID( id ) and (not for_id or for_id == id) then
		table.insert( steamIDs, tostring( PlayerResource:GetSteamAccountID( id ) ) )
	end
end


HTTP.Request("/gifts", {
	Players = steamIDs,
}, function(data)

	if not data then 
		return
	end
	shop:UpdateGifts(data)
end)

end



function shop:UpdateGifts(table)
if not IsServer() then return end 

local new_data = {}

for id = 0, 24 do
	if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetSteamAccountID(id) ~= 0 then
		new_data[id] = {}
	end
end

for _,data in pairs(table) do
	if data.count and data.count > 0 and data.gifts and #data.gifts > 0 then 
		local id = HTTP.GetPlayerBySteamID( data.playerId )	
		new_data[id] = data.gifts
	end 	
end 

for id,data in pairs(new_data) do 
    CustomNetTables:SetTableValue('gifts_data', tostring(id), data)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "gift_alert", {})
end

end 


function shop:accept_gift(js_data) 
if js_data.PlayerID == nil then return end
if js_data.giftId == nil then return end

local id = js_data.PlayerID
local giftId = js_data.giftId


local gifts_data = CustomNetTables:GetTableValue("gifts_data", tostring(id))

for _,data in pairs(gifts_data) do 

	if data.giftId == giftId then 
		
		HTTP.Request( "/accept_gift", 
			{
				matchId = tostring(GameRules:Script_GetMatchID()),
				matchKey = HTTP.MATCH_KEY,
				playerId = tostring( PlayerResource:GetSteamAccountID( id ) ),
				giftId = giftId
			}, 
			function(data)
				if not data then 
					return
				end

				local gifts_data = {}

				for _,player_data in pairs(data) do 
		 			if player_data.gifts and #player_data.gifts > 0 then 
						gifts_data = player_data.gifts
					end 
					break
				end

        		CustomNetTables:SetTableValue('gifts_data', tostring(id), gifts_data)
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "gift_alert", {})	
			
				local steamIDs = {}
				table.insert( steamIDs, tostring( PlayerResource:GetSteamAccountID( id )))

				dota1x6:SendState(steamIDs)
			end
		)

	end
end 


end 

shop.HOW_MUCH_CHEST_RETURN_GOLD_PERCENT = 20

function shop:shop_dota1x6_open_chest_get_items_list(data)
    if data.PlayerID == nil then return end
    local id = data.PlayerID
    local chest_id = tonumber(data.chest_id)
    if DOTA1X6_CHESTS_INFO[chest_id] == nil then return end
    local chest_info = 
    {
        ["chest_name"] = DOTA1X6_CHESTS_INFO[chest_id].chest_name,
        ["chest_items"] = DOTA1X6_CHESTS_INFO[chest_id].chest_items,
        ["chest_id"] = chest_id,
        ["chest_cost"] = DOTA1X6_CHESTS_INFO[chest_id].chest_cost,
        ["chance"] = DOTA1X6_CHESTS_INFO[chest_id].chance,
        ["is_no_buy"] = DOTA1X6_CHESTS_INFO[chest_id].is_no_buy,
        ["is_only_one_open"] = DOTA1X6_CHESTS_INFO[chest_id].is_only_one_open,
        ["is_reroll"] = DOTA1X6_CHESTS_INFO[chest_id].is_reroll,
        ["chest_item_id"] = DOTA1X6_CHESTS_INFO[chest_id].chest_item_id,
    }
    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'shop_dota1x6_open_chest_information', {chest_info = chest_info} ) 
end

function shop:shop_dota1x6_close_chest_checked_reward(data)
    if data.PlayerID == nil then return end
    local id = data.PlayerID

    if shop.saved_players_chest_items[id] == nil then return end

    local chest_id = shop.saved_players_chest_items[id].chest_id
    local cost = shop.saved_players_chest_items[id].cost
    local item_id = shop.saved_players_chest_items[id].item_id
    local player_table = CustomNetTables:GetTableValue('sub_data', tostring(id))
    local player_items_table = {}
    if player_table then
        if player_table.items_ids then
            for k, v in pairs(player_table.items_ids) do
                table.insert(player_items_table, v)
            end
        end
        player_table.points = player_table.points - cost
        table.insert(player_items_table, item_id)
        HTTP.BuyItem( id, item_id, math.abs( cost ) )

        if item_id == 23095 then
            table.insert(player_items_table, 23096)
            table.insert(player_items_table, 23098)
            table.insert(player_items_table, 23099)
            table.insert(player_items_table, 23097)
            HTTP.BuyItem( data.PlayerID, 23096, 0 )
            HTTP.BuyItem( data.PlayerID, 23098, 0 )
            HTTP.BuyItem( data.PlayerID, 23099, 0 )
            HTTP.BuyItem( data.PlayerID, 23097, 0 )
        end
        if item_id == 12930 then
            table.insert(player_items_table, 13768)
            table.insert(player_items_table, 13769)
            table.insert(player_items_table, 13770)
            HTTP.BuyItem( data.PlayerID, 13768, 0 )
            HTTP.BuyItem( data.PlayerID, 13769, 0 )
            HTTP.BuyItem( data.PlayerID, 13770, 0 )
        end
        
        if item_id == 13456 then
            table.insert(player_items_table, 13760)
            table.insert(player_items_table, 13743)
            table.insert(player_items_table, 13571)
            table.insert(player_items_table, 13473)
            table.insert(player_items_table, 13569)
            HTTP.BuyItem( data.PlayerID, 13760, 0 )
            HTTP.BuyItem( data.PlayerID, 13743, 0 )
            HTTP.BuyItem( data.PlayerID, 13571, 0 )
            HTTP.BuyItem( data.PlayerID, 13473, 0 )
            HTTP.BuyItem( data.PlayerID, 13569, 0 )
        end

        if item_id == 18539 then
            table.insert(player_items_table, 18540)
            table.insert(player_items_table, 18542)
            table.insert(player_items_table, 18543)
            table.insert(player_items_table, 18544)
            table.insert(player_items_table, 18541)
            HTTP.BuyItem( data.PlayerID, 18540, 0 )
            HTTP.BuyItem( data.PlayerID, 18542, 0 )
            HTTP.BuyItem( data.PlayerID, 18543, 0 )
            HTTP.BuyItem( data.PlayerID, 18544, 0 )
            HTTP.BuyItem( data.PlayerID, 18541, 0 )
        end 

        if item_id == 19090 then
            table.insert(player_items_table, 19091)
            table.insert(player_items_table, 19092)
            table.insert(player_items_table, 19093)
            table.insert(player_items_table, 19094)
            table.insert(player_items_table, 19088)
            table.insert(player_items_table, 19089)
            HTTP.BuyItem( data.PlayerID, 19091, 0 )
            HTTP.BuyItem( data.PlayerID, 19092, 0 )
            HTTP.BuyItem( data.PlayerID, 19093, 0 )
            HTTP.BuyItem( data.PlayerID, 19094, 0 )
            HTTP.BuyItem( data.PlayerID, 19088, 0 )
            HTTP.BuyItem( data.PlayerID, 19089, 0 )
        end

        if item_id == 7756 then
            table.insert(player_items_table, 29687)
            HTTP.BuyItem( data.PlayerID, 29687, 0 )
        end

        if item_id == 23697 then
            table.insert(player_items_table, 24100)
            HTTP.BuyItem( data.PlayerID, 24100, 0 )
        end

        if item_id == 2059 then
            table.insert(player_items_table, 30261)
            HTTP.BuyItem( data.PlayerID, 30261, 0 )
        end

        if item_id == 12964 then
            table.insert(player_items_table, 12968)
            HTTP.BuyItem( data.PlayerID, 12968, 0 )
            table.insert(player_items_table, 12965)
            HTTP.BuyItem( data.PlayerID, 12965, 0 )
            table.insert(player_items_table, 12966)
            HTTP.BuyItem( data.PlayerID, 12966, 0 )
        end
        if item_id == 5396 then
            table.insert(player_items_table, 5395)
            HTTP.BuyItem( data.PlayerID, 5395, 0 )
        end
        if item_id == 8271 then
            table.insert(player_items_table, 8324)
            HTTP.BuyItem( data.PlayerID, 8324, 0 )
        end
        if item_id == 7277 then
            table.insert(player_items_table, 7276)
            HTTP.BuyItem( data.PlayerID, 7276, 0 )
        end
        if item_id == 8734 then
            table.insert(player_items_table, 8735)
            HTTP.BuyItem( data.PlayerID, 8735, 0 )
        end
        if item_id == 14512 then
            table.insert(player_items_table, 14510)
            HTTP.BuyItem( data.PlayerID, 14510, 0 )
        end
        if item_id == 24931 then
            table.insert(player_items_table, 24932)
            HTTP.BuyItem( data.PlayerID, 24932, 0 )
        end
        if item_id == 23781 then
            table.insert(player_items_table, 23782)
            HTTP.BuyItem( data.PlayerID, 23782, 0 )
        end

        player_table.items_ids = player_items_table
        CustomNetTables:SetTableValue('sub_data', tostring(id), player_table)
    end
    shop.saved_players_chest_items[id] = nil
end

function shop:shop_dota1x6_open_chest_get_reward(data)
    if data.PlayerID == nil then return end
    local id = data.PlayerID
    local chest_id = data.chest_id
    local is_rerolled = data.rerolled
    local drop_id = nil
    if DOTA1X6_CHESTS_INFO[chest_id] == nil then return end
    local items_in_chest = DOTA1X6_CHESTS_INFO[chest_id].chest_items
    print("shop.saved_players_chest_items[id]", shop.saved_players_chest_items[id] == nil)
    if shop.saved_players_chest_items[id] then
        drop_id = shop:GetRandomRewardFromChest(id, items_in_chest, shop.saved_players_chest_items[id].item_id)
    else
        drop_id = shop:GetRandomRewardFromChest(id, items_in_chest)
    end
    if is_rerolled and not shop.saved_players_chest_items[id] then return end
    
    shop.saved_players_chest_items[id] = nil
    if drop_id == nil then return end
    local is_retry_drop = false
    local shard_counter = 0
    local cost = DOTA1X6_CHESTS_INFO[chest_id].chest_cost
    local player = PlayerResource:GetPlayer(id)
    local player_table = CustomNetTables:GetTableValue('sub_data', tostring(id))
    local player_items_table = {}

    local is_reroll = false


    if player_table then
        if player_table.points < cost then return end
        if DOTA1X6_CHESTS_INFO[chest_id].is_only_one_open and not is_rerolled then

            local chest_opened_table = {}
            for k, v in pairs(player_table.chest_opened) do
                table.insert(chest_opened_table, v)
            end
            table.insert(chest_opened_table, chest_id)
            player_table.chest_opened = chest_opened_table

			HTTP.BuyItem(id, DOTA1X6_CHESTS_INFO[chest_id].chest_item_id, 0)
        end
        if player_table.items_ids then
            for k, v in pairs(player_table.items_ids) do
                table.insert(player_items_table, v)
            end
        end
        if HasDonateItem(id, drop_id.item_id) then
            player_table.points = player_table.points - (cost * (1 - shop.HOW_MUCH_CHEST_RETURN_GOLD_PERCENT / 100))
            is_retry_drop = true
            shard_counter = cost * (shop.HOW_MUCH_CHEST_RETURN_GOLD_PERCENT / 100)
			HTTP.BuyItem( id, drop_id.item_id, math.abs( (cost * (1 - shop.HOW_MUCH_CHEST_RETURN_GOLD_PERCENT / 100)) ) )
        else
            if DOTA1X6_CHESTS_INFO[chest_id].is_reroll and not is_rerolled then
                shop.saved_players_chest_items[id] = 
                {
                    ["cost"] = cost,
                    ["item_id"] = drop_id.item_id,
                    ["chest_id"] = chest_id,
                }
                is_reroll = true
            else
                player_table.points = player_table.points - cost
                table.insert(player_items_table, drop_id.item_id)
                HTTP.BuyItem( id, drop_id.item_id, math.abs( cost ) )

                if drop_id.item_id == 23095 then
                    table.insert(player_items_table, 23096)
                    table.insert(player_items_table, 23098)
                    table.insert(player_items_table, 23099)
                    table.insert(player_items_table, 23097)
                    HTTP.BuyItem( data.PlayerID, 23096, 0 )
                    HTTP.BuyItem( data.PlayerID, 23098, 0 )
                    HTTP.BuyItem( data.PlayerID, 23099, 0 )
                    HTTP.BuyItem( data.PlayerID, 23097, 0 )
                end
                if drop_id.item_id == 12930 then
                    table.insert(player_items_table, 13768)
                    table.insert(player_items_table, 13769)
                    table.insert(player_items_table, 13770)
                    HTTP.BuyItem( data.PlayerID, 13768, 0 )
                    HTTP.BuyItem( data.PlayerID, 13769, 0 )
                    HTTP.BuyItem( data.PlayerID, 13770, 0 )
                end
                
                if drop_id.item_id == 13456 then
                    table.insert(player_items_table, 13760)
                    table.insert(player_items_table, 13743)
                    table.insert(player_items_table, 13571)
                    table.insert(player_items_table, 13473)
                    table.insert(player_items_table, 13569)
                    HTTP.BuyItem( data.PlayerID, 13760, 0 )
                    HTTP.BuyItem( data.PlayerID, 13743, 0 )
                    HTTP.BuyItem( data.PlayerID, 13571, 0 )
                    HTTP.BuyItem( data.PlayerID, 13473, 0 )
                    HTTP.BuyItem( data.PlayerID, 13569, 0 )
                end
    
                if drop_id.item_id == 18539 then
                    table.insert(player_items_table, 18540)
                    table.insert(player_items_table, 18542)
                    table.insert(player_items_table, 18543)
                    table.insert(player_items_table, 18544)
                    table.insert(player_items_table, 18541)
                    HTTP.BuyItem( data.PlayerID, 18540, 0 )
                    HTTP.BuyItem( data.PlayerID, 18542, 0 )
                    HTTP.BuyItem( data.PlayerID, 18543, 0 )
                    HTTP.BuyItem( data.PlayerID, 18544, 0 )
                    HTTP.BuyItem( data.PlayerID, 18541, 0 )
                end 
    
                if drop_id.item_id == 19090 then
                    table.insert(player_items_table, 19091)
                    table.insert(player_items_table, 19092)
                    table.insert(player_items_table, 19093)
                    table.insert(player_items_table, 19094)
                    table.insert(player_items_table, 19088)
                    table.insert(player_items_table, 19089)
                    HTTP.BuyItem( data.PlayerID, 19091, 0 )
                    HTTP.BuyItem( data.PlayerID, 19092, 0 )
                    HTTP.BuyItem( data.PlayerID, 19093, 0 )
                    HTTP.BuyItem( data.PlayerID, 19094, 0 )
                    HTTP.BuyItem( data.PlayerID, 19088, 0 )
                    HTTP.BuyItem( data.PlayerID, 19089, 0 )
                end
    
                if drop_id.item_id == 7756 then
                    table.insert(player_items_table, 29687)
                    HTTP.BuyItem( data.PlayerID, 29687, 0 )
                end
    
                if drop_id.item_id == 23697 then
                    table.insert(player_items_table, 24100)
                    HTTP.BuyItem( data.PlayerID, 24100, 0 )
                end
    
                if drop_id.item_id == 2059 then
                    table.insert(player_items_table, 30261)
                    HTTP.BuyItem( data.PlayerID, 30261, 0 )
                end
    
                if drop_id.item_id == 12964 then
                    table.insert(player_items_table, 12968)
                    HTTP.BuyItem( data.PlayerID, 12968, 0 )
                    table.insert(player_items_table, 12965)
                    HTTP.BuyItem( data.PlayerID, 12965, 0 )
                    table.insert(player_items_table, 12966)
                    HTTP.BuyItem( data.PlayerID, 12966, 0 )
                end

                if drop_id.item_id == 5396 then
                    table.insert(player_items_table, 5395)
                    HTTP.BuyItem( data.PlayerID, 5395, 0 )
                end

                if drop_id.item_id == 8271 then
                    table.insert(player_items_table, 8324)
                    HTTP.BuyItem( data.PlayerID, 8324, 0 )
                end

                if drop_id.item_id == 7277 then
                    table.insert(player_items_table, 7276)
                    HTTP.BuyItem( data.PlayerID, 7276, 0 )
                end

                if drop_id.item_id == 8734 then
                    table.insert(player_items_table, 8735)
                    HTTP.BuyItem( data.PlayerID, 8735, 0 )
                end

                if drop_id.item_id == 14512 then
                    table.insert(player_items_table, 14510)
                    HTTP.BuyItem( data.PlayerID, 14510, 0 )
                end

                if drop_id.item_id == 24931 then
                    table.insert(player_items_table, 24932)
                    HTTP.BuyItem( data.PlayerID, 24932, 0 )
                end

                if drop_id.item_id == 23781 then
                    table.insert(player_items_table, 23782)
                    HTTP.BuyItem( data.PlayerID, 23782, 0 )
                end

                shop.saved_players_chest_items[id] = nil
            end
        end
        if is_rerolled then
            is_reroll = false
        end
        player_table.items_ids = player_items_table
        CustomNetTables:SetTableValue('sub_data', tostring(id), player_table)
    end

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), 'shop_dota1x6_open_chest_active', {drop_id = drop_id.item_id, items = items_in_chest, is_retry_drop = is_retry_drop, shard_counter = shard_counter, is_reroll = is_reroll} ) 
end

function shop:GetRandomRewardFromChest(id, items_in_chest, remove_item_id)
    local get_drop = nil
    local has_items_with_chance = {}
    local no_items_list = {}
    local items_no_rare = {}
    for _, item in pairs(items_in_chest) do
        if not HasDonateItem(id, item.item_id) and item.chance ~= nil then
            table.insert(has_items_with_chance, item)
        end
        if not HasDonateItem(id, item.item_id) and item.chance == nil then
            table.insert(no_items_list, item)
        end
        if item.chance == nil then
            table.insert(items_no_rare, item)
        end
    end

    if remove_item_id ~= nil then
        if #has_items_with_chance > 1 then
            for i=#has_items_with_chance, 1, -1 do
                if has_items_with_chance[i] and tonumber(has_items_with_chance[i].item_id) == tonumber(remove_item_id) then
                    table.remove(has_items_with_chance, i)
                end
            end
        end
        if #no_items_list > 1 then
            for i=#no_items_list, 1, -1 do
                if no_items_list[i] and tonumber(no_items_list[i].item_id) == tonumber(remove_item_id) then
                    table.remove(no_items_list, i)
                end
            end
        end
        if #items_no_rare > 1 then
            for i=#items_no_rare, 1, -1 do
                if items_no_rare[i] and tonumber(items_no_rare[i].item_id) == tonumber(remove_item_id) then
                    table.remove(items_no_rare, i)
                end
            end
        end
        if #items_in_chest > 1 then
            for i=#items_in_chest, 1, -1 do
                if items_in_chest[i] and tonumber(items_in_chest[i].item_id) == tonumber(remove_item_id) then
                    table.remove(items_in_chest, i)
                end
            end
        end
        print("Из сундука больше не выпадет", remove_item_id)
    end

    if #has_items_with_chance > 0 then
        for _, item in pairs(has_items_with_chance) do
            if RollPercentage(item.chance) then
                get_drop = item
                break
            end
        end
        if get_drop == nil then
            if #no_items_list <= 0 then
                return items_no_rare[RandomInt(1, #items_no_rare)]
            else
                repeat
                    local random = RandomInt(1, #no_items_list)
                    get_drop = no_items_list[random]
                until not HasDonateItem(id, get_drop.item_id)
            end
        end
    else
        repeat
            local random = RandomInt(1, #items_in_chest)
            get_drop = items_in_chest[random]
        until not HasDonateItem(id, get_drop.item_id)
    end
    return get_drop
end

function shop:IsChestOpened(player_id, chest_id)
    local player_table = CustomNetTables:GetTableValue('sub_data', tostring(player_id))
    local chest_opened_table = {}
    for k, v in pairs(player_table.chest_opened) do
        chest_opened_table[tostring(v)] = true
    end
    if chest_opened_table[tostring(chest_id)] then
        return true
    end
    return false
end

function shop:GiveArcanaChestForPlayer(player_id)
local player_table = CustomNetTables:GetTableValue('sub_data', tostring(player_id))
local server_data = CustomNetTables:GetTableValue('server_data', tostring(player_id))

if not server_data or not player_table then return -1 end

local game_count = server_data.total_games

if player_table and player_table.subscribed == 1 and not HasDonateItem(player_id, 100000) then
	local player_items_table = {}
	if player_table.items_ids then
	    for k, v in pairs(player_table.items_ids) do
	        table.insert(player_items_table, v)
	    end
	end

	table.insert(player_items_table, 100000)

	player_table.items_ids = player_items_table
	CustomNetTables:SetTableValue('sub_data', tostring(player_id), player_table)
end

local result = -1

if not shop:IsChestOpened(player_id, 2) then
	result = 1
	if not HasDonateItem(player_id, 100000) then 
		result = 0
		if game_count <= 5 then
			result = -1
		end
	end
end

return result
end



function shop:IsChest(id)
for chest_id,chest_data in pairs(DOTA1X6_CHESTS_INFO) do
	if chest_data.chest_item_id then
		if chest_data.chest_item_id == id then
			return chest_id
		end
	end
end
return false
end



