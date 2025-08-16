if wearables_system == nil then
    _G.wearables_system = class({})
end

require("wearables_system/configs")
require("wearables_system/util")

-- Init Server Info  ----------------------------------------------------
LinkLuaModifier("modifier_change_item_invis", "wearables_system/modifiers/modifier_change_item_invis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_donate_illusion", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_donate_hex_checking", "wearables_system/modifiers/modifier_hero_donate_hex_checking", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_queen_of_pain_cape_custom", "wearables_system/modifiers/modifier_queen_of_pain_cape_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_portrait_donate_custom", "wearables_system/modifiers/modifier_portrait_donate_custom", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_crystal_maiden_death_custom", "wearables_system/modifiers/modifier_crystal_maiden_death_custom", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_donate_illusion_invisible", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

wearables_system.cooldown_item_set = 1
wearables_system.items_data = {}
wearables_system.items_data_slots = {}
wearables_system.items_hash_data = {}
wearables_system.player_items_portrait = {}
wearables_system.selection_data = {}
wearables_system.is_hero_precached = {}


if IsInToolsMode() then
end

function wearables_system:SendHeroItems(name)
if not wearables_system.items_data[name] then return end

local info = wearables_system.items_data[name]
local hero_items_table_copy = wearables_system:CopyTable(info)
for _, itm_info in pairs(hero_items_table_copy) do
    itm_info["RemoveDefaultItemsList"] = nil
    itm_info["Modifier"] = nil
    itm_info["ParticlesItems"] = nil
    itm_info["ParticlesHero"] = nil
    itm_info["SetItems"] = nil
    itm_info["HeroModel"] = nil
    itm_info["ArcanaAnim"] = nil
    itm_info["MaterialGroup"] = nil
end
CustomNetTables:SetTableValue("heroes_items_info", tostring(name), hero_items_table_copy)
for _, info_item in pairs(info) do
    if info_item["Modifier"] ~= nil then
        LinkLuaModifier(info_item["Modifier"], "wearables_system/modifiers/"..info_item["Modifier"], LUA_MODIFIER_MOTION_NONE)
    end
end

end


if IsInToolsMode() then
    require("wearables_system/items_print")
end

----------------------------------------------------

-- Инициализация героя при спавне
function wearables_system:InitPlayerWerable(hero)
    if hero == nil then return end
    if not hero:IsHero() then return end
    if hero.first_spawn_model then return end
    if hero:GetUnitName() == "npc_dota_hero_monkey_king" and hero:IsRealHero() then
        if wearables_system.IsMonkeyItemSpawned then
            return
        end
        wearables_system.IsMonkeyItemSpawned = true
    end

    -- Инициализация массивов
    hero.first_spawn_model = true
    hero.items_data_custom = {}
    hero.particles_items_data_custom = {}
    hero.cooldown_items_donate = {}
    hero.other_model_backup_name = {}
    hero.other_model_backup = {}
    hero.items_slots_type = {}
    hero.particles_timers_custom = {}
    hero.original_model_donate = hero:GetModelName()
    wearables_system.player_items_portrait[hero:GetPlayerOwnerID()] = {}

    -- Отдельный партикл на сф
    if hero:GetUnitName() == "npc_dota_hero_nevermore" and hero:GetModelName() == "models/heroes/shadow_fiend/shadow_fiend.vmdl" then
	    wearables_system:UpdateNevermoreAmbient(hero, false)
	end
    -- Отдельный партикл на вк
    if hero:GetUnitName() == "npc_dota_hero_skeleton_king" and hero:GetModelName() ~= "models/items/wraith_king/arcana/wraith_king_arcana.vmdl" then
	    wearables_system:UpdateWraithKingAmbient(hero, false)
	end
    if hero:GetUnitName() == "npc_dota_hero_crystal_maiden" then
        hero:AddNewModifier(hero, nil, "modifier_crystal_maiden_death_custom", {})
    end
    -- Отдельный партикл для террорблейда
	if hero:GetUnitName() == "npc_dota_hero_terrorblade" then
	    wearables_system:UpdateTerorbladeFeet(hero)
	end
    -- Если это не разор, то выполняется код внутри, если разор, то IsRazorArcanaAbuse
    if not wearables_system:IsRazorArcanaAbuse(hero) then
        wearables_system:IsCheckedPudgePersona(hero)
        wearables_system:IsCheckedPhantomAssassinPersona(hero)
        wearables_system:IsCheckedCrystalMaidenPersona(hero)
        wearables_system:IsCheckedInvokerPersona(hero)
        wearables_system:IsCheckedAntimagePersona(hero)
        wearables_system:AddedDonateHero(hero, hero:GetPlayerOwnerID())
    end
end

-- Вызов функции на снятие или надевания предмета на героев
function wearables_system:dota1x6_item_change(data)
	if data.PlayerID == nil then return end
	local item_id = data.item_id
	local current_hero = data.current_hero
	local remove = data.remove
	local player_id = data.PlayerID
	if remove == 1 then
		wearables_system:RemoveDonateItemToHero(current_hero, player_id, item_id)
	else
		wearables_system:AddedDonateItemToHero(current_hero, player_id, item_id)
	end
end

-- Вызывается при инициализации героя, чтоб надеть на него ранее надетые шмотки 1х6 или доты
-- Прикрепить предметы с начала игры герою (ДОДЕЛАТЬ)
function wearables_system:AddedDonateHero(hero, PlayerID)
    wearables_system:RemoveAllItemsOtherModel(hero)
    -- Если это иллюзия, то удалять шмотки надо будет сразу
    if hero:IsIllusion() then
	    hero:AddNewModifier(hero, nil, "modifier_hero_donate_illusion", {})
    end
    -- Проверки на хекс
    if wearables_system.items_data[hero:GetUnitName()] then
        hero:AddNewModifier(hero, nil, "modifier_hero_donate_hex_checking", {})
    end
    -- Сбор предметов, которые могли быть надеты у игрока кастомные
	local hero_name = hero:GetUnitName()
    local player_table = CustomNetTables:GetTableValue('sub_data', tostring(PlayerID))
    if player_table == nil then return end
    local player_items_table = {}
    for k, v in pairs(player_table.player_items_onequip[tostring(hero_name)]) do
        if not _G.TERRORBLADE_COLORS_IDS[tostring(v)] or HasDonateItem(PlayerID, v) then 
            table.insert(player_items_table, v)
        end
    end
	if #player_items_table > 0 then
		for _, item in pairs(player_items_table) do
			wearables_system:SetItemToHero(hero, PlayerID, hero_name, item, hero:IsRealHero())
		end
	end
end

-- Возвращение дефолтного предмета для игрока из доты
function wearables_system:BackupOtherModelDota(hero, item_slot_type)
    if hero.other_model_backup_name == nil then return end
    if hero.other_model_backup_name[item_slot_type] == nil then return end
    if hero.other_model_backup[item_slot_type] ~= nil then return end
    if IS_PERSONA_MODEL[hero.original_model_donate] then return end
    local item_model = hero.other_model_backup_name[item_slot_type]
    if item_model == "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana_wings.vmdl" then
        item_model = "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana_modest_wings.vmdl"
    end
    if item_model == "models/items/pudge/aberrant_observer_arcana/aberrant_observer_arcana_head.vmdl" then
        item_model = "models/items/pudge/aberrant_observer_head/aberrant_observer_head.vmdl"
    end
    local item_info = wearables_system:FindItemInfoOnModel(hero:GetUnitName(), item_model, hero.MaterialGroupHash, wearables_system.items_hash_data[item_model])
    if item_slot_type == "hero_base" then
        item_info = wearables_system:FindItemInfoOnModel(hero:GetUnitName(), item_model, hero.MaterialGroupHash, wearables_system.items_hash_data[item_model], hero:GetModelName())
    end
    if hero:GetModelName() == "models/items/axe/ti9_jungle_axe/axe_bare.vmdl" and item_slot_type == "weapon" then
        item_info = wearables_system:FindItemInfoOnModel(hero:GetUnitName(), item_model, hero.MaterialGroupHash, wearables_system.items_hash_data[item_model], "models/items/axe/ti9_jungle_axe/axe_bare.vmdl")
    end
    local item_model_entity = wearables_system:CreateWearable(hero, item_model)
    if shadow_fiend_changes[item_model] ~= nil then
        if hero:GetModelName() == "models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl" then
            item_model_entity:SetMaterialGroup("arcana")
        else
            item_model_entity:SetMaterialGroup("default")
        end
    end
    if items_start_activity_idle[item_model] ~= nil then
        item_model_entity:StartGesture(ACT_DOTA_IDLE)
    end
    if hero:GetUnitName() == "npc_dota_hero_huskar" and item_slot_type == "weapon" then
        item_model_entity:SetBodygroupByName( "spear", 1 )
    end
    hero.other_model_backup[item_slot_type] = item_model_entity

    -- Если у нас есть кастомная информация для предмета, то ее всю крепим
    if item_info ~= nil then
        local material_group = item_info["MaterialGroup"]
        local material_group_item = item_info["MaterialGroupItem"]
        local particle_items = item_info["ParticlesItems"]
        local particle_heroes = item_info["ParticlesHero"]
        local is_exclusive = item_info["is_exclusive"]
        local modifier_item = item_info["Modifier"]
        local item_id = item_info["item_id"]
        -- Материал предмета
        if material_group_item ~= nil then
            item_model_entity:SetMaterialGroup(material_group_item)
        end
        -- Материал героя
        if material_group ~= nil then
            hero:SetMaterialGroup(material_group)
        end
        -- Апдейт портрета
        if hero:IsRealHero() then
            wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item_id, nil)
        end
        -- Добавление уникального модификатора
        if is_exclusive ~= nil and modifier_item ~= nil then
            hero:AddNewModifier(hero, nil, modifier_item, {})
        end
        -- Добавление партиклов итдитп
        wearables_system:AddParticleToHeroFromItemInformation(hero, particle_items, particle_heroes, item_model_entity, item_slot_type)
    end
    -- Кринжовое возвращение материальной группы у героя, ибо ломается хз почему
    if hero and hero:GetUnitName() == "npc_dota_hero_legion_commander" then
        if hero.MaterialGroupHash and (hero.MaterialGroupHash == "628863847" or hero.MaterialGroupHash == 628863847) then
            hero:SetMaterialGroup("1")
        else
            hero:SetMaterialGroup("default")
        end
    end
    if hero and hero:GetUnitName() == "npc_dota_hero_lina" then
        if hero.MaterialGroupHash and (hero.MaterialGroupHash == "628863847" or hero.MaterialGroupHash == 628863847) then
            hero:SetMaterialGroup("1")
        elseif hero.MaterialGroupHash and (hero.MaterialGroupHash == "1347516877" or hero.MaterialGroupHash == 1347516877) then
            hero:SetMaterialGroup("2")
        elseif hero.MaterialGroupHash and (hero.MaterialGroupHash == "628863847" or hero.MaterialGroupHash == 628863847) then
            hero:SetMaterialGroup("default")
        end
    end
    local modifier_hero_donate_hex_checking = hero:FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end

function wearables_system:ChangeModelHero(hero, model, starting)
    if starting then 
        Timers:CreateTimer(0.5, function()
            hero:SetModel(model)
            hero:SetOriginalModel(model)
            hero:RemoveGesture(ACT_DOTA_SPAWN)
            if model == "models/items/razor/razor_arcana/razor_arcana.vmdl" then
                hero:AddNewModifier(hero, nil, "modifier_razor_arcana", {})
                wearables_system:UpdateRazorParticle(hero, true)
                hero:ManageModelChanges()
                hero:AddNewModifier(hero, nil, "modifier_hexxed", {duration = FrameTime()})
            end
            if model == "models/items/wraith_king/arcana/wraith_king_arcana.vmdl" then
                wearables_system:UpdateWraithKingAmbient(hero, true)
            end
            if model == "models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl" then
                wearables_system:UpdateNevermoreAmbient(hero, true)
            end
            if model == "models/heroes/razor/razor.vmdl" then
                wearables_system:UpdateRazorParticle(hero, false)
            end
            if model == "models/heroes/wraith_king/wraith_king.vmdl" then
                wearables_system:UpdateWraithKingAmbient(hero, false)
            end
            if model == "models/heroes/shadow_fiend/shadow_fiend.vmdl" then
                wearables_system:UpdateNevermoreAmbient(hero, false)
            end
        end)
    else
        hero:SetModel(model)
        hero:SetOriginalModel(model)
	    hero:RemoveGesture(ACT_DOTA_SPAWN)
        if model == "models/items/razor/razor_arcana/razor_arcana.vmdl" then
            hero:AddNewModifier(hero, nil, "modifier_hexxed", {duration = FrameTime()})
        end
        Timers:CreateTimer(1, function()
            if model == "models/items/razor/razor_arcana/razor_arcana.vmdl" then
                hero:AddNewModifier(hero, nil, "modifier_razor_arcana", {})
                wearables_system:UpdateRazorParticle(hero, true)
            end
            if model == "models/items/wraith_king/arcana/wraith_king_arcana.vmdl" then
                wearables_system:UpdateWraithKingAmbient(hero, true)
            end
            if model == "models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl" then
                wearables_system:UpdateNevermoreAmbient(hero, true)
            end
        end)
        if model == "models/heroes/razor/razor.vmdl" then
            wearables_system:UpdateRazorParticle(hero, false)
        end
        if model == "models/heroes/wraith_king/wraith_king.vmdl" then
            wearables_system:UpdateWraithKingAmbient(hero, false)
        end
        if model == "models/heroes/shadow_fiend/shadow_fiend.vmdl" then
            wearables_system:UpdateNevermoreAmbient(hero, false)
        end
    end
end

-- Функция удаления предмета игроку ( Из ивента )
function wearables_system:RemoveDonateItemToHero(hero_name, PlayerID, item_id, fast, skip_add)
    local player = PlayerResource:GetPlayer(PlayerID)
    if player == nil then return end
    local player_table = CustomNetTables:GetTableValue('sub_data', tostring(PlayerID))
    if player_table == nil then return end
    local hero = player:GetAssignedHero()
    local original_item_information = wearables_system.items_data[hero_name][item_id]
    if original_item_information == nil then return end
    local item_slot_type = original_item_information["SlotType"]
    if hero_select:GetState() ~= "PICK_STATE_PICK_END" then
        if wearables_system.selection_data[PlayerID] == nil then
            wearables_system.selection_data[PlayerID] = {}
        end
        if wearables_system.selection_data[PlayerID][hero_name] == nil then
            wearables_system.selection_data[PlayerID][hero_name] = {}
        end
        if wearables_system.selection_data[PlayerID][hero_name][item_slot_type] ~= nil then
            wearables_system.selection_data[PlayerID][hero_name][item_slot_type] = nil
        end
        local player_items_table = {}
        for k, v in pairs(player_table.player_items_onequip[tostring(hero_name)]) do
            table.insert(player_items_table, v)
        end
        wearables_system.remove_item(player_items_table, item_id)     
        player_table.player_items_onequip[tostring(hero_name)] = player_items_table
        CustomNetTables:SetTableValue('sub_data', tostring(PlayerID), player_table)
        return
    end
    if hero == nil then return end
    -- Если сейчас перезарядки на переодевание предмета, то вывести окно или запустить перезарядку
    if fast == nil and skip_add == nil then
        if hero.cooldown_items_donate ~= nil and hero.cooldown_items_donate[item_slot_type] ~= nil and hero.cooldown_items_donate[item_slot_type] > 0 then
            local cooldown = hero.cooldown_items_donate[item_slot_type]
            CustomGameEventManager:Send_ServerToPlayer(player, "panorama_cooldown_error", {message="#dota_item_change_error", time=cooldown})
            EmitSoundOnClient("General.Cancel", player)
            return
        end
        wearables_system:ItemCooldown(hero, PlayerID, item_slot_type)
    end
    -- Изменение материал группы если снимаешь определенный предмет
    if MATERIAL_GROUP_CHANGES_DATA[item_id] then
        hero:SetMaterialGroup(MATERIAL_GROUP_CHANGES_DATA[item_id])
    end
    -- Если предмет был не снят, а переодет и заменен другим
    if skip_add == nil then
        local player_items_table = {}
        for k, v in pairs(player_table.player_items_onequip[tostring(hero_name)]) do
            table.insert(player_items_table, v)
        end
        wearables_system.remove_item(player_items_table, item_id)     
        if hero:IsRealHero() then
            wearables_system:UpdatePortraitInfo(PlayerID, item_id, true)
        end
        player_table.player_items_onequip[tostring(hero_name)] = player_items_table
    end
    -- Если текущий герой, это тот на которого надеваем слоты
    if hero_name == hero:GetUnitName() then
        wearables_system:RemoveItemToHero(hero, PlayerID, hero_name, item_id)
        if hero.other_model_backup_name ~= nil and hero.other_model_backup_name[item_slot_type] ~= nil then
            if fast == nil then
                wearables_system:BackupOtherModelDota(hero, item_slot_type)
            end
        end
    end

	CustomNetTables:SetTableValue('sub_data', tostring(PlayerID), player_table)

    -- Кринжовое возвращение материальной группы у героя, ибо ломается хз почему
    if hero and hero:GetUnitName() == "npc_dota_hero_legion_commander" then
        if hero.MaterialGroupHash and (hero.MaterialGroupHash == "628863847" or hero.MaterialGroupHash == 628863847) then
            hero:SetMaterialGroup("1")
        else
            hero:SetMaterialGroup("default")
        end
    end
    if hero and hero:GetUnitName() == "npc_dota_hero_lina" then
        if hero.MaterialGroupHash and (hero.MaterialGroupHash == "628863847" or hero.MaterialGroupHash == 628863847) then
            hero:SetMaterialGroup("1")
        elseif hero.MaterialGroupHash and (hero.MaterialGroupHash == "1347516877" or hero.MaterialGroupHash == 1347516877) then
            hero:SetMaterialGroup("2")
        elseif hero.MaterialGroupHash and (hero.MaterialGroupHash == "628863847" or hero.MaterialGroupHash == 628863847) then
            hero:SetMaterialGroup("default")
        end
    end

    local modifier_hero_donate_hex_checking = hero:FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end

-- Основная функция удаления предмета у героя
function wearables_system:RemoveItemToHero(hero, PlayerID, hero_name, item_id)
    local original_item_info = wearables_system.items_data[tostring(hero_name)][item_id]
    if original_item_info == nil then return end
    local item_slot_type = original_item_info["SlotType"]
    -- Если это персона, то вызываем отдельную функцию для снятия предмета
    if wearables_system:SetItemPersonaUpdater(hero, original_item_info["Modifier"], false, item_id) then return end
    -- Если была изменена модель, то вернуть старую
    if original_item_info["HeroModel"] ~= nil then
        wearables_system:ChangeModelHero(hero, hero.original_model_donate)
    end
    -- Не снимать персону, если игрок сам имеет персону
    if original_item_info["Modifier"] ~= nil then
	    hero:RemoveModifierByName(original_item_info["Modifier"])
	end
    -- Удаление предмета этого слота
    if hero.items_data_custom[item_slot_type] ~= nil then
        hero.items_data_custom[item_slot_type]:Destroy()
        hero.items_data_custom[item_slot_type] = nil
    end
    -- Удаление партиклов
    if hero.particles_items_data_custom ~= nil and hero.particles_items_data_custom[item_slot_type] ~= nil then
        for _, particle in pairs(hero.particles_items_data_custom[item_slot_type]) do
            ParticleManager:DestroyParticle(particle, true)
            ParticleManager:ReleaseParticleIndex(particle)
        end
    end
    hero.particles_items_data_custom[item_slot_type] = nil
    local modifier_hero_donate_hex_checking = hero:FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end

--- Функция добавления предмета игроку ( Из ивента )
function wearables_system:AddedDonateItemToHero(hero_name, PlayerID, item_id, skip_add)
	local player = PlayerResource:GetPlayer(PlayerID)
    if player == nil then return end
    local player_table = CustomNetTables:GetTableValue('sub_data', tostring(PlayerID))
    if player_table == nil then return end
    local hero = player:GetAssignedHero()
    local original_item_information = wearables_system.items_data[hero_name][item_id]
    if original_item_information == nil then return end
    local item_slot_type = original_item_information["SlotType"]
    if hero_select:GetState() ~= "PICK_STATE_PICK_END" then
        if wearables_system.selection_data[PlayerID] == nil then
            wearables_system.selection_data[PlayerID] = {}
        end
        if wearables_system.selection_data[PlayerID][hero_name] == nil then
            wearables_system.selection_data[PlayerID][hero_name] = {}
        end
        if wearables_system.selection_data[PlayerID][hero_name] and wearables_system.selection_data[PlayerID][hero_name][item_slot_type] ~= nil then
            local old_id = wearables_system.selection_data[PlayerID][hero_name][item_slot_type]
            wearables_system:RemoveDonateItemToHero(hero_name, PlayerID, old_id, true)
        end
        player_table = CustomNetTables:GetTableValue('sub_data', tostring(PlayerID))
        local player_items_table = {}
        for k, v in pairs(player_table.player_items_onequip[tostring(hero_name)]) do
            table.insert(player_items_table, v)
        end
        table.insert(player_items_table, item_id)
        player_table.player_items_onequip[tostring(hero_name)] = player_items_table
        CustomNetTables:SetTableValue('sub_data', tostring(PlayerID), player_table)
        wearables_system.selection_data[PlayerID][hero_name][item_slot_type] = item_id
        return
    end
    if hero == nil then return end
    -- Если сейчас перезарядки на переодевание предмета, то вывести окно или запустить перезарядку
    if skip_add == nil then
        if hero.cooldown_items_donate ~= nil and hero.cooldown_items_donate[item_slot_type] ~= nil and hero.cooldown_items_donate[item_slot_type] > 0 then
            local cooldown = hero.cooldown_items_donate[item_slot_type]
            CustomGameEventManager:Send_ServerToPlayer(player, "panorama_cooldown_error", {message="#dota_item_change_error", time=cooldown})
            EmitSoundOnClient("General.Cancel", player)
            return
        end
        wearables_system:ItemCooldown(hero, PlayerID, item_slot_type)
    end
    -- Если уже есть надетый предмет в слоты, то его надо снять быстренько
    if hero.items_slots_type and hero.items_slots_type[item_slot_type] ~= nil then
        local old_id = hero.items_slots_type[item_slot_type]
        wearables_system:RemoveDonateItemToHero(hero_name, PlayerID, old_id, true)
    end
    -- Обновить таблицу игрока
    player_table = CustomNetTables:GetTableValue('sub_data', tostring(PlayerID))
    -- Если предмет надет, но не обновлять его в таблице
    if skip_add == nil then
        local player_items_table = {}
        for k, v in pairs(player_table.player_items_onequip[tostring(hero_name)]) do
            table.insert(player_items_table, v)
        end
        table.insert(player_items_table, item_id)
        player_table.player_items_onequip[tostring(hero_name)] = player_items_table
    end
    -- Если текущий герой == выбранному меняем слоты в игре
    if hero_name == hero:GetUnitName() then
        wearables_system:SetItemToHero(hero, PlayerID, hero:GetUnitName(), item_id)
    end
    -- Обновление портрета
    if hero:IsRealHero() then
        if not IS_PERSONA_MODEL[hero.original_model_donate] then
            wearables_system:UpdatePortraitInfo(PlayerID, item_id, nil)
        end
    end
    CustomNetTables:SetTableValue('sub_data', tostring(PlayerID), player_table)

    local modifier_hero_donate_hex_checking = hero:FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end

-- Основная функция надевания предмета
function wearables_system:SetItemToHero(hero, PlayerID, hero_name, item, starting)
	local item_info = wearables_system.items_data[hero_name][item]
    if item_info == nil then return end
    -- Сбор информации о предмете
	local hero_model = item_info["HeroModel"]
	local material_group = item_info["MaterialGroup"]
    local material_group_item = item_info["MaterialGroupItem"]
	local item_model = item_info["ItemModel"]
	local particle_items = item_info["ParticlesItems"]
	local particle_heroes = item_info["ParticlesHero"]
    local modifier_item = item_info["Modifier"]
    local item_slot_type = item_info["SlotType"]
    local body_group = item_info["BodyGroup"]
    local body_group_style = item_info["BodyGroupStyle"]
    local persona = item_info["persona"]
    local dota_items_in_hero = wearables_system.items_data_slots[hero_name][item_slot_type]
    -- Если это персона, то вызываем отдельную функцию для надевания предмета
    if wearables_system:SetItemPersonaUpdater(hero, modifier_item, true, item) then return end

    -- Если это не стартовые предметы, то обновляем портрет
    if starting ~= nil then
        if hero:IsRealHero() then
            wearables_system:UpdatePortraitInfo(PlayerID, item, nil)
        end
    end
    -- Если это тип предмета, в котором не надо обновлять модель, а только добавлять модификатор
	if SLOTS_TYPE_ONLY_MODIFIER[item_slot_type] then
	    hero.items_slots_type[item_slot_type] = item
	    if modifier_item then
	        hero:AddNewModifier(hero, nil, modifier_item, {})
	    end
	    return
	end
    -- Удаление таймеров на пересоздание партиклов
    if hero.particles_timers_custom[item_slot_type] ~= nil then
        for _, timer_check in pairs(hero.particles_timers_custom[item_slot_type]) do
            Timers:RemoveTimer(timer_check)
        end
        hero.particles_timers_custom[item_slot_type] = {}
    end
    -- Сохранение предмета
    hero.items_slots_type[item_slot_type] = item
    -- Модификатор отвечающий за инвиз модельки, чтоб вераблы слетели
    hero:RemoveModifierByName("modifier_change_item_invis")

    local item_spawn_duration = FrameTime()
    if starting then
        item_spawn_duration = 0.5
    end

    local invis = hero:AddNewModifier(hero, nil, "modifier_change_item_invis", {duration = item_spawn_duration})
    --- Начинаем удалять предметы доты, похожие на предмет слота и если это аркана то удалять надо все предметы
    if dota_items_in_hero ~= nil then
        for _, model_name_dota in pairs(dota_items_in_hero) do
            wearables_system:RemoveItemOtherModel(hero, model_name_dota, item, PlayerID, hero_model, item_slot_type)
        end
    end
    -- Изменение модели игрока
    if hero_model ~= nil then
        wearables_system:ChangeModelHero(hero, hero_model, starting)
    end
    -- Изменение материал группы героя
    if material_group ~= nil then
        hero:SetMaterialGroup(material_group)
    end

    local delay_particle = 2

    local callback = function()
        if item_model ~= nil then
            if shadow_fiend_changes[item_model] ~= nil then
                item_model = shadow_fiend_changes[item_model]
            end
            local item_model_entity = wearables_system:CreateWearable(hero, item_model)
            if items_start_activity_idle[item_model] ~= nil then
                item_model_entity:StartGesture(ACT_DOTA_IDLE)
            end
            if body_group ~= nil then
                if body_group_style ~= nil then
                    item_model_entity:SetBodygroupByName( body_group, body_group_style )
                else
                    item_model_entity:SetBodygroupByName( body_group, 1 )
                end
            end 
            if hero_name == "npc_dota_hero_huskar" and item_slot_type == "weapon" then
                item_model_entity:SetBodygroupByName( "spear", 1 )
            end
            if shadow_fiend_changes_check[item_model] ~= nil then
                if hero:GetModelName() == "models/heroes/shadow_fiend/shadow_fiend_arcana.vmdl" then
                    item_model_entity:SetMaterialGroup("arcana")
                else
                    item_model_entity:SetMaterialGroup("default")
                end
            else
                if material_group_item ~= nil then
                    item_model_entity:SetMaterialGroup(material_group_item)
                end
            end
            hero.items_data_custom[item_slot_type] = item_model_entity
            -- Визуальные частицы
            if particle_items ~= nil then
                local part_count = 1
                local particle_spawn_duration = FrameTime()
                if starting then
                    particle_spawn_duration = 0.1
                end
                for particle_id, particle_item in pairs(particle_items) do
                    local timer = Timers:CreateTimer(part_count*particle_spawn_duration, function()
                        local particle_item_effect = ParticleManager:CreateParticle(particle_item["ParticleName"], particle_item["DefaultPattch"], item_model_entity)
                        if particle_item_effect then
                            if particle_item["ControllPoints"] ~= nil then
                                for control_point_id, particle_data in pairs(particle_item["ControllPoints"]) do
                                    if particle_data[1] == "SetParticleControl" then
                                        if particle_data[2] == "default" then
                                            ParticleManager:SetParticleControl(particle_item_effect, control_point_id, hero:GetAbsOrigin())
                                        else
                                            ParticleManager:SetParticleControl(particle_item_effect, control_point_id, Vector(particle_data[2][1], particle_data[2][2], particle_data[2][3]))
                                        end
                                    elseif particle_data[1] == "SetParticleControlEnt" then
                                        if particle_data[4] == "hero" then
                                            ParticleManager:SetParticleControlEnt( particle_item_effect, control_point_id, hero, particle_data[2], particle_data[3], Vector(0,0,0), true )
                                        else
                                            ParticleManager:SetParticleControlEnt( particle_item_effect, control_point_id, item_model_entity, particle_data[2], particle_data[3], item_model_entity:GetAbsOrigin(), true )
                                        end
                                    end
                                end
                            end
                            if hero.particles_items_data_custom[item_slot_type] == nil then
                                hero.particles_items_data_custom[item_slot_type] = {}
                            end
							local modifier_terrorblade_arcana_custom = hero:FindModifierByName("modifier_terrorblade_arcana_custom")
                            if modifier_terrorblade_arcana_custom then
                                for i=1, 15 do
                                    local arcana_color_style = hero:FindModifierByName("modifier_terrorblade_arcana_custom_" .. i)
                                    if arcana_color_style then
                                        modifier_terrorblade_arcana_custom.rgb = arcana_color_style.rgb
                                        break
                                    end
                                end
                            end
							if modifier_terrorblade_arcana_custom then
							    ParticleManager:SetParticleControl(particle_item_effect, 16, Vector(1,1,1))
							    ParticleManager:SetParticleControl(particle_item_effect, 15, modifier_terrorblade_arcana_custom.rgb)
							end
                            table.insert(hero.particles_items_data_custom[item_slot_type], particle_item_effect)
                        end
                    end)
                    if timer then
                        if hero.particles_timers_custom[item_slot_type] == nil then
                            hero.particles_timers_custom[item_slot_type] = {}
                        end
                        table.insert(hero.particles_timers_custom[item_slot_type], timer)
                    end
                    part_count = part_count + 1
                end
            end
            local modifier_hero_donate_hex_checking = hero:FindModifierByName("modifier_hero_donate_hex_checking")
            if modifier_hero_donate_hex_checking then
                modifier_hero_donate_hex_checking:UpdatePlayerItems()
            end
        end
        local new_timer = Timers:CreateTimer(delay_particle, function()
            if particle_heroes ~= nil then
                local part_count = 1
                for particle_id, particle_hero in pairs(particle_heroes) do
                    local timer = Timers:CreateTimer(part_count*FrameTime(), function()
                        local particle_target = item_model_entity
                        if particle_hero["IsHero"] ~= nil then
                            particle_target = hero
                        end
                        local particle_hero_effect = ParticleManager:CreateParticle(particle_hero["ParticleName"], particle_hero["DefaultPattch"], particle_target)
                        if particle_hero["ControllPoints"] ~= nil then
                            for control_point_id, particle_data in pairs(particle_hero["ControllPoints"]) do
                                if particle_data[1] == "SetParticleControl" then
                                    if particle_data[2] == "default" then
                                        ParticleManager:SetParticleControl(particle_hero_effect, control_point_id, hero:GetAbsOrigin())
                                    else
                                        ParticleManager:SetParticleControl(particle_hero_effect, control_point_id, Vector(particle_data[2][1], particle_data[2][2], particle_data[2][3]))
                                    end
                                elseif particle_data[1] == "SetParticleControlEnt" then
                                    ParticleManager:SetParticleControlEnt( particle_hero_effect, control_point_id, hero, particle_data[2], particle_data[3], Vector(0,0,0), true )
                                end
                            end
                        end
                        if hero.particles_items_data_custom[item_slot_type] == nil then
                            hero.particles_items_data_custom[item_slot_type] = {}
                        end
						local modifier_terrorblade_arcana_custom = hero:FindModifierByName("modifier_terrorblade_arcana_custom")
                        if modifier_terrorblade_arcana_custom then
                            for i=1, 15 do
                                local arcana_color_style = hero:FindModifierByName("modifier_terrorblade_arcana_custom_" .. i)
                                if arcana_color_style then
                                    modifier_terrorblade_arcana_custom.rgb = arcana_color_style.rgb
                                    break
                                end
                            end
                        end
						if modifier_terrorblade_arcana_custom then
						    ParticleManager:SetParticleControl(particle_hero_effect, 16, Vector(1,1,1))
						    ParticleManager:SetParticleControl(particle_hero_effect, 15, modifier_terrorblade_arcana_custom.rgb)
						end
                        table.insert(hero.particles_items_data_custom[item_slot_type], particle_hero_effect)
                    end)
                    if timer then
                        if hero.particles_timers_custom[item_slot_type] == nil then
                            hero.particles_timers_custom[item_slot_type] = {}
                        end
                        table.insert(hero.particles_timers_custom[item_slot_type], timer)
                    end
                    part_count = part_count + 1
                end
            end
        end)
        if new_timer then
            if hero.particles_timers_custom[item_slot_type] == nil then
                hero.particles_timers_custom[item_slot_type] = {}
            end
            table.insert(hero.particles_timers_custom[item_slot_type], new_timer)
        end
        if tostring(item) == "1293001" then
            if hero:HasModifier("modifier_queenofpain_arcana_custom_1") then
                hero:RemoveModifierByName("modifier_queenofpain_arcana_custom_1")
            end
        end
        -- Модификатор со свойствами
        if modifier_item ~= nil then
            hero:AddNewModifier(hero, nil, modifier_item, {})
        end
    end
    invis:SetEndCallback( callback )
end

function wearables_system:PreSaveItemSelectionData(PlayerID, item_id, hero_name)
if not wearables_system.items_data[hero_name] then return end

local original_item_information = wearables_system.items_data[hero_name][item_id]
if original_item_information == nil then return end
local item_slot_type = original_item_information["SlotType"]
if wearables_system.selection_data[PlayerID] == nil then
    wearables_system.selection_data[PlayerID] = {}
end
if wearables_system.selection_data[PlayerID][hero_name] == nil then
    wearables_system.selection_data[PlayerID][hero_name] = {}
end
wearables_system.selection_data[PlayerID][hero_name][item_slot_type] = item_id
end

function wearables_system:CreateMorphTeamItem(hero, item_model)
    local item_model_entity = CreateUnitByName("npc_dota_donate_item_illusion", Vector(0, 0, 0), false, nil, nil, hero:GetTeam())
    item_model_entity:AddNewModifier(hero, nil, "modifier_donate_hero_illusion_item", {})
    item_model_entity:SetModel( item_model )
    item_model_entity:SetOriginalModel( item_model )
    item_model_entity:SetTeam( hero:GetTeamNumber() )
    item_model_entity:SetOwner( hero )
    item_model_entity:FollowEntity(hero, true)
    if items_start_activity_idle[item_model] ~= nil then
        item_model_entity:StartGesture(ACT_DOTA_IDLE)
    end
    if item_model == "models/heroes/huskar/huskar_spear.vmdl" then
        item_model_entity:SetBodygroupByName( "spear", 1 )
    end
    return item_model_entity
end

function wearables_system:CreateWearable(hero, item_model)
local item_wearable = CreateUnitByName("npc_dota_donate_item_illusion", Vector(0, 0, 0), false, nil, nil, hero:GetTeam())
item_wearable:AddNewModifier(hero, nil, "modifier_donate_hero_illusion_item", {model_name = item_model})
item_wearable:SetModel(item_model)
item_wearable:SetOriginalModel(item_model)
item_wearable:SetTeam( hero:GetTeamNumber() )
item_wearable:SetOwner( hero )
item_wearable:FollowEntity(hero, true)
if hero:IsIllusion() then
    item_wearable:AddNewModifier(item_wearable, nil, "modifier_illusion", {})
end
return item_wearable
end