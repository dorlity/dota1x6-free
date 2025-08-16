require("wearables_system/configs")

function wearables_system:CopyTable(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[wearables_system:CopyTable(orig_key)] = wearables_system:CopyTable(orig_value)
        end
        setmetatable(copy, wearables_system:CopyTable(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

function wearables_system.remove_item(tbl,item) -- Удалить итем
    local i,max=1,#tbl
    while i<=max do
        if tbl[i] == item then
            table.remove(tbl,i)
            i = i-1
            max = max-1
        end
        i= i+1
    end
    return tbl
end

function wearables_system:CheckItemModelInHero(hero, model_name)
    if hero and hero:IsHero() then
        local children = hero:GetChildren();
        for k,child in pairs(children) do
            if child and child:GetClassname() == "dota_item_wearable" and child:GetModelName() == model_name then
                return true
            end
        end
    end
    return false
end

function wearables_system:GetRealChildInHero(hero, model_name)
    if hero and hero:IsHero() then
        local children = hero:GetChildren();
        for k,child in pairs(children) do
            if child and child:GetClassname() == "dota_item_wearable" and child:GetModelName() == model_name then
                return child
            end
        end
    end
    return nil
end

function wearables_system:IsRazorArcanaAbuse(hero)
    if hero and hero:GetUnitName() == "npc_dota_hero_razor" and not hero:IsIllusion() then 
        hero:SetModel("models/items/razor/razor_arcana/razor_arcana.vmdl")
        hero:SetOriginalModel("models/items/razor/razor_arcana/razor_arcana.vmdl")
        local has_arcana = false
        if wearables_system:CheckItemModelInHero(hero, "models/items/razor/razor_arcana/razor_arcana_weapon.vmdl") then
            has_arcana = true
        end
        wearables_system:RemoveAllItemsOtherModel(hero)
        Timers:CreateTimer(0.2, function()
            if not has_arcana then
                hero:SetOriginalModel("models/heroes/razor/razor.vmdl")
                hero:SetModel("models/heroes/razor/razor.vmdl")
                wearables_system:UpdateRazorParticle(hero, false)
            end
            wearables_system:AddedDonateHero(hero, hero:GetPlayerOwnerID())
        end)
        return true
    end
    return false
end

function wearables_system:IsCheckedPudgePersona(hero)
    if hero:GetUnitName() == "npc_dota_hero_pudge" and hero:GetModelName() == "models/heroes/pudge_cute/pudge_cute.vmdl" then
        if wearables_system:CheckItemModelInHero(hero, "models/items/pudge_cute/pudge_cute_calavera/pudge_cute_calavera_hair.vmdl") then
            hero.pudge_persona_1 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/pudge_cute/pudge_cute_frostivus/pudge_cute_frostivus_hair.vmdl") then
            hero.pudge_persona_2 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/pudge_cute/little_knight_head/little_knight_head.vmdl") then
            hero.pudge_persona_3 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/heroes/pudge_cute/pudge_cute_hair.vmdl") then
            hero.pudge_persona = true
        else
            hero.pudge_persona = true
        end
    end
end

function wearables_system:IsCheckedPhantomAssassinPersona(hero)
    if hero:GetUnitName() == "npc_dota_hero_phantom_assassin" and hero:GetModelName() == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then
        if wearables_system:CheckItemModelInHero(hero, "models/heroes/phantom_assassin_persona/phantom_assassin_persona_weapon.vmdl") then
            hero.phantom_persona = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/phantom_assassin/weapon_dark_carnival/weapon_dark_carnival.vmdl") then
            hero.phantom_persona_2 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/phantom_assassin/2023panther_shadow_weapon/2023panther_shadow_weapon.vmdl") then
            hero.phantom_persona_3 = true
        else
            hero.phantom_persona = true
        end
    end
end

function wearables_system:IsCheckedCrystalMaidenPersona(hero)
    if hero:GetUnitName() == "npc_dota_hero_crystal_maiden" and hero:GetModelName() == "models/heroes/crystal_maiden_persona/crystal_maiden_persona.vmdl" then
        if wearables_system:CheckItemModelInHero(hero, "models/heroes/crystal_maiden_persona/crystal_maiden_persona_crystals.vmdl") then
            hero.crystal_persona = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/crystal_maiden/guardiana_glacial_cristals/guardiana_glacial_cristals.vmdl") then
            hero.crystal_persona_2 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/crystal_maiden/frostfire_beads/frostfire_beads.vmdl") then
            hero.crystal_persona_3 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/crystal_maiden/crystal_diviner_misc/crystal_diviner_misc.vmdl") then
            hero.crystal_persona_4 = true
        else
            hero.crystal_persona = true
        end
    end
end

function wearables_system:IsCheckedInvokerPersona(hero)
    if hero:GetUnitName() == "npc_dota_hero_invoker" and hero:GetModelName() == "models/heroes/invoker_kid/invoker_kid.vmdl" then
        if wearables_system:CheckItemModelInHero(hero, "models/heroes/invoker_kid/invoker_kid_cape.vmdl") then
            hero.invoker_persona_1 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/invoker_kid/dark_artistry_kid/invoker_kid_dark_artistry_back.vmdl") then
            hero.invoker_persona_2 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/invoker/invoker_arrow_of_psychokinesis_back_persona_1/invoker_arrow_of_psychokinesis_back_persona_1.vmdl") then
            hero.invoker_persona_3 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/invoker/the_little_king_back/the_little_king_back.vmdl") then
            hero.invoker_persona_4 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/invoker_kid/continuum_echoes_back/continuum_echoes_back.vmdl") then
            hero.invoker_persona_5 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/invoker_kid/the_little_thief_of_kazim_back_blue/the_little_thief_of_kazim_back_blue.vmdl") then
            hero.invoker_persona_6 = true
        else
            hero.invoker_persona_1 = true
        end
    end
end

function wearables_system:IsCheckedAntimagePersona(hero)
    if hero:GetUnitName() == "npc_dota_hero_antimage" and hero:GetModelName() == "models/heroes/antimage_female/antimage_female.vmdl" then
        if wearables_system:CheckItemModelInHero(hero, "models/heroes/antimage_female/antimage_female_hair.vmdl") then
            hero.antimage_persona_1 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/antimage_female/anti_mage_nemesis_slayer_head_persona_1/anti_mage_nemesis_slayer_head_persona_1.vmdl") then
            hero.antimage_persona_2 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/antimage_female/anti_mage_cherry_blossom_head_persona_1/anti_mage_cherry_blossom_head_persona_1.vmdl") then
            hero.antimage_persona_3 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/antimage_female/am_screeauk/am_screeauk_hair.vmdl") then
            hero.antimage_persona_4 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/antimage_female/loong_warrior_head/loong_warrior_head.vmdl") then
            hero.antimage_persona_5 = true
        elseif wearables_system:CheckItemModelInHero(hero, "models/items/antimage_female/jewels_of_the_spellbreaker_head/jewels_of_the_spellbreaker_head.vmdl") then
            hero.antimage_persona_6 = true
        else
            hero.antimage_persona_1 = true
        end
    end
end

-- Удаление всех предметов с дефолтного героя
function wearables_system:RemoveAllItemsOtherModel(hero)
    if hero.MaterialGroupHash == nil then
        hero.MaterialGroupHash = hero:GetMaterialGroupHash()
    end
    local real_models = wearables_system.items_data_slots[hero:GetUnitName()]
    if real_models ~= nil then
        hero.portrait_custom = true
        CustomNetTables:SetTableValue("heroes_donate_portraits", tostring(hero:GetUnitName()), {donate = 1})
        wearables_system:CheckingUniqueArcaneItems(hero)
        wearables_system:StartingModifiersPersona(hero)
        for name_slot, model_list in pairs(real_models) do
            for _, model in pairs(model_list) do
                wearables_system:DeleteChildrenHero(hero, model, name_slot)
            end
        end
        if hero and hero:IsHero() then
            local children = hero:GetChildren();
            for k,child in pairs(children) do
                if child and child:GetClassname() == "dota_item_wearable" and child:GetModelName() == "" and _G.REMOVE_WEREABLES_ALL[hero:GetUnitName()] then
                    UTIL_Remove(child)
                end
            end
        end
    end
end

-- Удаление всех предметов с героя
function wearables_system:DeleteChildrenHero(hero, model, slot_type)
    local deleted_item = false
    if wearables_system:CheckItemModelInHero(hero, model) then
        local child = wearables_system:GetRealChildInHero(hero, model)
        if shadow_fiend_changes[model] then
            hero.other_model_backup_name[slot_type] = shadow_fiend_changes[model]
        else
            hero.other_model_backup_name[slot_type] = model
        end
        if wearables_system.items_hash_data then
            wearables_system.items_hash_data[tostring(model)] = tostring(child:GetMaterialGroupHash())
        end
        child:Destroy()
        deleted_item = true
    end
    if deleted_item then
        wearables_system:BackupOtherModelDota(hero, slot_type)
    end
end

-- Добавление партиклов для героя
function wearables_system:AddParticleToHeroFromItemInformation(hero, particle_items, particle_heroes, item_model_entity, item_slot_type, for_this_id)
    -- Партиклы на предметах - героях
    if particle_items ~= nil then
        for particle_id, particle_item in pairs(particle_items) do
            local particle_item_effect 
            if for_this_id then
                particle_item_effect = ParticleManager:CreateParticleForPlayer(particle_item["ParticleName"], particle_item["DefaultPattch"], item_model_entity, PlayerResource:GetPlayer( for_this_id ))
            else
                particle_item_effect = ParticleManager:CreateParticle(particle_item["ParticleName"], particle_item["DefaultPattch"], item_model_entity)
            end
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
    end
    -- Партиклы на героях - предметах (задержка нужна)
    local timer = Timers:CreateTimer(0.2, function()
        -- Визуальные частицы ГЕРОЯ
        if particle_heroes ~= nil then
            for particle_id, particle_hero in pairs(particle_heroes) do
                local particle_target = item_model_entity
                if particle_hero["IsHero"] ~= nil then
                    particle_target = hero
                end
                local particle_hero_effect
                if for_this_id then
                    particle_hero_effect = ParticleManager:CreateParticleForPlayer(particle_hero["ParticleName"], particle_hero["DefaultPattch"], particle_target, PlayerResource:GetPlayer( for_this_id ))
                else
                    particle_hero_effect = ParticleManager:CreateParticle(particle_hero["ParticleName"], particle_hero["DefaultPattch"], particle_target)
                end
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
            end
        end
    end)
    if timer then
        if hero.particles_timers_custom[item_slot_type] == nil then
            hero.particles_timers_custom[item_slot_type] = {}
        end
        table.insert(hero.particles_timers_custom[item_slot_type], timer)
    end
end

-- Обновление кастомного портрета
function wearables_system:UpdatePortraitInfo(id, item_id, delete)
    if delete then
        for i = #wearables_system.player_items_portrait[id], 1, -1 do
            if wearables_system.player_items_portrait[id][i] == item_id then
                table.remove(wearables_system.player_items_portrait[id], i)
                break
            end
        end
    else
        table.insert(wearables_system.player_items_portrait[id], item_id)
    end
    CustomNetTables:SetTableValue("heroes_items_info", "portrait_items_"..id, wearables_system.player_items_portrait[id])
end

-- Поиск информации о предмете по модели и хешу материала
function wearables_system:FindItemInfoOnModel(hero_name, item_model, hash_hero, hash_item, hero_original_model)
	hash_hero = tostring(hash_hero)
    local default_material_group_item = "0"
    local default_material_group_hero = "0"
    -- Всегда одинаковый меч на фантомку
    if hero_name == "npc_dota_hero_phantom_assassin" and item_model == "models/heroes/phantom_assassin/pa_arcana_weapons.vmdl" then
        for _, inf in pairs(wearables_system.items_data[hero_name]) do
            if inf and inf["ItemModel"] == item_model and inf["item_id"] == 4239 then
                return inf
            end
        end
    end
    -- Подбор хеша героя
    if hash_hero then
        default_material_group_hero = hash_info[hash_hero]
    end
    -- Подбор хеша предмета
    if hash_item then
        default_material_group_item = hash_info[hash_item]
    end
    -- Обычный поиск по модели героя
    if hero_original_model then
        for _, inf in pairs(wearables_system.items_data[hero_name]) do
            if inf and inf["HeroModel"] == hero_original_model and inf["MaterialGroup"] == default_material_group_hero then
                return inf
            end
        end
        for _, inf in pairs(wearables_system.items_data[hero_name]) do
            if inf and inf["HeroModel"] == hero_original_model then
                return inf
            end
        end
    end
    -- Поиск по оба хеша
    for _, inf in pairs(wearables_system.items_data[hero_name]) do
        if inf and inf["ItemModel"] == item_model and inf["MaterialGroupItem"] == default_material_group_item and inf["MaterialGroup"] == default_material_group_hero then
            return inf
        end
    end
    -- Поиск по предмету
    for _, inf in pairs(wearables_system.items_data[hero_name]) do
        if inf and inf["ItemModel"] == item_model and inf["MaterialGroupItem"] == default_material_group_item then
            return inf
        end
    end
    -- Поиск по герою
    for _, inf in pairs(wearables_system.items_data[hero_name]) do
        if inf and inf["ItemModel"] == item_model and inf["MaterialGroup"] == default_material_group_hero then
            return inf
        end
    end
    -- Дефолт поиск
    for _, inf in pairs(wearables_system.items_data[hero_name]) do
        if inf and inf["ItemModel"] == item_model and (inf["MaterialGroupItem"] == "0" or inf["MaterialGroupItem"] == "default") then
            return inf
        end
    end
    -- Обычный поиск если все таки ничего не нашлось
    for _, inf in pairs(wearables_system.items_data[hero_name]) do
        if inf and inf["ItemModel"] == item_model then
            return inf
        end
    end
    return nil
end

-- Запуск перезарядки на переодевание
function wearables_system:ItemCooldown(hero, PlayerID, slot_type)
    hero.cooldown_items_donate[slot_type] = wearables_system.cooldown_item_set + ChangeItemsCooldown
    Timers:CreateTimer(0, function()
        if hero then
            hero.cooldown_items_donate[slot_type] = hero.cooldown_items_donate[slot_type] - 1
            local player = PlayerResource:GetPlayer(PlayerID)
            if player then
                CustomGameEventManager:Send_ServerToPlayer(player, "shop_dota1x6_item_cooldown", {slot_type = slot_type, time = hero.cooldown_items_donate[slot_type]})
            end
            if hero.cooldown_items_donate[slot_type] <= 0 then
                hero.cooldown_items_donate[slot_type] = nil
                return
            end
            return 1
        end
    end)
end

-- Обновление визуала для разора
function wearables_system:UpdateRazorParticle(hero, delete)
    if delete then
        Timers:CreateTimer(0.45, function()
            if hero.razor_ambient_default ~= nil then
                for _, ambient in pairs(hero.razor_ambient_default) do
                    if ambient then
                        ParticleManager:DestroyParticle(ambient, true)
                    end
                end
            end
        end)
        return
    end
    Timers:CreateTimer(0.25, function()
        if hero.razor_ambient_default ~= nil then
            for _, ambient in pairs(hero.razor_ambient_default) do
                if ambient then
                    ParticleManager:DestroyParticle(ambient, true)
                end
            end
        end
        if hero:GetModelName() == "models/heroes/razor/razor.vmdl" then
            hero.razor_ambient_default = {}
            local whip = ParticleManager:CreateParticle("particles/razor_custom/razor_whip.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:SetParticleControlEnt( whip, 0, hero, PATTACH_POINT_FOLLOW, "attach_whip", hero:GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( whip, 1, hero, PATTACH_POINT_FOLLOW, "attach_whip1", hero:GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( whip, 2, hero, PATTACH_POINT_FOLLOW, "attach_whip2", hero:GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( whip, 3, hero, PATTACH_POINT_FOLLOW, "attach_whip3", hero:GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( whip, 4, hero, PATTACH_POINT_FOLLOW, "attach_whip4", hero:GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( whip, 5, hero, PATTACH_POINT_FOLLOW, "attach_whip5", hero:GetAbsOrigin(), true )
            table.insert(hero.razor_ambient_default, whip)
            local ambient_1 = ParticleManager:CreateParticle("particles/razor_custom/razor_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:SetParticleControlEnt( ambient_1, 3, hero, PATTACH_POINT_FOLLOW, "energyCore", hero:GetAbsOrigin(), true )
            table.insert(hero.razor_ambient_default, ambient_1)
            local ambient_2 = ParticleManager:CreateParticle("particles/razor_custom/razor_ambient_main.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:SetParticleControlEnt( ambient_2, 0, hero, PATTACH_POINT_FOLLOW, "energyCore", hero:GetAbsOrigin(), true )
            table.insert(hero.razor_ambient_default, ambient_2)
        end
    end)
end

function wearables_system:UpdateNevermoreAmbient(hero, delete)
    if delete then
        Timers:CreateTimer(0.45, function()
            if hero.shadow_fiend_ambient ~= nil then
                for _, ambient in pairs(hero.shadow_fiend_ambient) do
                    if ambient then
                        ParticleManager:DestroyParticle(ambient, true)
                    end
                end
            end
        end)
        return
    end
    Timers:CreateTimer(0.25, function()
        if hero.shadow_fiend_ambient ~= nil then
            for _, ambient in pairs(hero.shadow_fiend_ambient) do
                if ambient then
                    ParticleManager:DestroyParticle(ambient, true)
                end
            end
        end
        if hero:GetModelName() == "models/heroes/shadow_fiend/shadow_fiend.vmdl" then
            hero.shadow_fiend_ambient = {}
            local ambient = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            table.insert(hero.shadow_fiend_ambient, ambient)
        end
    end)
end

-- Обновление визуала для вк
function wearables_system:UpdateWraithKingAmbient(hero, delete)
    if delete then
        Timers:CreateTimer(0.45, function()
            if hero.wk_ambient_default ~= nil then
                for _, ambient in pairs(hero.wk_ambient_default) do
                    if ambient then
                        ParticleManager:DestroyParticle(ambient, true)
                    end
                end
            end
        end)
        return
    end
    Timers:CreateTimer(0.25, function()
        if hero.wk_ambient_default ~= nil then
            for _, ambient in pairs(hero.wk_ambient_default) do
                if ambient then
                    ParticleManager:DestroyParticle(ambient, true)
                end
            end
        end
        if hero:GetModelName() == "models/heroes/wraith_king/wraith_king.vmdl" then
            hero.wk_ambient_default = {}
            local ambient = ParticleManager:CreateParticle("particles/wraith_king_custom/wraith_king_ambient_custom.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            table.insert(hero.wk_ambient_default, ambient)
        end
    end)
end

-- Обновление визуала для terrorblade
function wearables_system:UpdateTerrorbladeColor(hero, delete, rgb)
    if delete then
        if hero.particles_items_data_custom ~= nil then
            for _, item_effect in pairs(hero.particles_items_data_custom) do
                for d, particle in pairs(item_effect) do
                    ParticleManager:DestroyParticle(particle, true)
                end
            end
            Timers:CreateTimer(0.25, function()
                wearables_system:UpdateTerrorbladeColorAll(hero:GetPlayerOwnerID(), hero)
            end)
        end
    else
        Timers:CreateTimer(0.25, function()
            if hero.particles_items_data_custom ~= nil then
                for _, item_effect in pairs(hero.particles_items_data_custom) do
                    for d, particle in pairs(item_effect) do
                        ParticleManager:DestroyParticle(particle, true)
                    end
                end
                wearables_system:UpdateTerrorbladeColorAll(hero:GetPlayerOwnerID(), hero)
            end
        end)
    end
    wearables_system:UpdateTerorbladeFeet(hero)
end

-- Обновление визуала для terrorblade ноги
function wearables_system:UpdateTerorbladeFeet(hero)
    if hero.terror_feet then
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
            ParticleManager:SetParticleControl(hero.terror_feet, 16, Vector(1,1,1))
            ParticleManager:SetParticleControl(hero.terror_feet, 15, modifier_terrorblade_arcana_custom.rgb)
        else
            ParticleManager:SetParticleControl(hero.terror_feet, 16, Vector(0,0,0))
        end
    else
        hero.terror_feet = ParticleManager:CreateParticle("particles/terrorblade_custom/terrorblade_feet_effects.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
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
            ParticleManager:SetParticleControl(hero.terror_feet, 16, Vector(1,1,1))
            ParticleManager:SetParticleControl(hero.terror_feet, 15, modifier_terrorblade_arcana_custom.rgb)
        else
            ParticleManager:SetParticleControl(hero.terror_feet, 16, Vector(0,0,0))
        end
    end
end

-- Обновление визуала для terrorblade шмотки
function wearables_system:UpdateTerrorbladeColorAll(id, hero)
    if hero.items_data_custom == nil then return end
	if hero.particles_items_data_custom == nil then return end
	local hero_name = hero:GetUnitName()
    local player_table = CustomNetTables:GetTableValue('sub_data', tostring(id))
    if player_table == nil then return end
    local player_items_table = {}
    for k, v in pairs(player_table.player_items_onequip[tostring(hero_name)]) do
        table.insert(player_items_table, v)
    end
    if hero.other_model_backup_name ~= nil then
        for slot, name in pairs(hero.other_model_backup_name) do
            local item_model = hero.other_model_backup_name[slot]
            local item_info = wearables_system:FindItemInfoOnModel(hero_name, item_model, hero.MaterialGroupHash, wearables_system.items_hash_data[item_model])
            if item_info and hero.other_model_backup[slot] ~= nil then
                local particle_items = item_info["ParticlesItems"]
                local particle_heroes = item_info["ParticlesHero"]
                local item_slot_type = item_info["SlotType"]
                wearables_system:AddParticleToHeroFromItemInformation(hero, particle_items, particle_heroes, hero.other_model_backup[slot], item_slot_type)
            end
        end
    end
    if player_items_table ~= nil then
		for _, item in pairs(player_items_table) do
            local item_info = wearables_system.items_data[hero_name][item]
            if item_info then
                local particle_items = item_info["ParticlesItems"]
                local particle_heroes = item_info["ParticlesHero"]
                local item_slot_type = item_info["SlotType"]
                if hero.items_data_custom[item_slot_type] ~= nil then
                    wearables_system:AddParticleToHeroFromItemInformation(hero, particle_items, particle_heroes, hero.items_data_custom[item_slot_type], item_slot_type)
                end
            end
        end
    end
end

-- Удаление дотовских предметов
function wearables_system:RemoveItemOtherModel(hero, model, item_id, player_id, hero_model, slot_type)
    if hero == nil then return end
    if hero.other_model_backup ~= nil and hero.other_model_backup[slot_type] ~= nil then
        local item_model = hero.other_model_backup[slot_type]:GetModelName()
        if item_model == "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana_wings.vmdl" then
            item_model = "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana_modest_wings.vmdl"
        end
        local item_info = wearables_system:FindItemInfoOnModel(hero:GetUnitName(), item_model, hero.MaterialGroupHash, wearables_system.items_hash_data[item_model])
        if item_info then
            if hero:IsRealHero() then
                if not IS_PERSONA_MODEL[hero.original_model_donate] then
                    wearables_system:UpdatePortraitInfo(player_id, item_info["item_id"], true)
                end
            end
        end
        hero.other_model_backup[slot_type]:AddEffects(EF_NODRAW)
        hero.other_model_backup[slot_type]:Destroy()
        hero.other_model_backup[slot_type] = nil
    end
    if hero.particles_items_data_custom ~= nil and hero.particles_items_data_custom[slot_type] ~= nil then
        for _, particle in pairs(hero.particles_items_data_custom[slot_type]) do
            ParticleManager:DestroyParticle(particle, true)
            ParticleManager:ReleaseParticleIndex(particle)
        end
    end
end

--  wearables_system:AddParticleToHeroFromItemInformation(hero, particle_items, particle_heroes, item_model_entity, item_slot_type)
-- Обновление партиклов для игрока при реконнете
function wearables_system:UpdateFullParticleForPlayer(id, hero, for_this_id)
    if hero.items_data_custom == nil then return end
	if hero.particles_items_data_custom == nil then return end
	local hero_name = hero:GetUnitName()
    local player_table = CustomNetTables:GetTableValue('sub_data', tostring(id))
    if player_table == nil then return end
    local player_items_table = {}
    for k, v in pairs(player_table.player_items_onequip[tostring(hero_name)]) do
        table.insert(player_items_table, v)
    end
    if hero.other_model_backup_name ~= nil then
        for slot, name in pairs(hero.other_model_backup_name) do
            local item_model = hero.other_model_backup_name[slot]
            if item_model == "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana_wings.vmdl" then
                item_model = "models/items/queenofpain/queenofpain_arcana/queenofpain_arcana_modest_wings.vmdl"
            end
            local item_info = wearables_system:FindItemInfoOnModel(hero_name, item_model, hero.MaterialGroupHash, wearables_system.items_hash_data[item_model])
            if item_info and hero.other_model_backup[slot] ~= nil then
                local particle_items = item_info["ParticlesItems"]
                local particle_heroes = item_info["ParticlesHero"]
                local item_slot_type = item_info["SlotType"]
                wearables_system:AddParticleToHeroFromItemInformation(hero, particle_items, particle_heroes, hero.other_model_backup[slot], slot, for_this_id)
            end
        end
    end
	if player_items_table ~= nil then
		for _, item in pairs(player_items_table) do
            local item_info = wearables_system.items_data[hero_name][item]
            if item_info then
	            local particle_items = item_info["ParticlesItems"]
	            local particle_heroes = item_info["ParticlesHero"]
                local item_slot_type = item_info["SlotType"]
                if hero.items_data_custom[item_slot_type] then
                    wearables_system:AddParticleToHeroFromItemInformation(hero, particle_items, particle_heroes, hero.items_data_custom[item_slot_type], item_slot_type, for_this_id)
                end
            end
		end
	end
end

function wearables_system:QueenOfPainUpdateShoulder(hero, active)
    if hero:HasModifier("modifier_queenofpain_immortal_custom") or hero:HasModifier("modifier_queenofpain_immortal_custom_v2") then
        Timers:CreateTimer(FrameTime(), function()
            local item_model_entity
            local model_name = "models/items/queenofpain/qop_2022_immortal/qop_2022_immortal.vmdl"
            local particle = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_arcana_2022_ambient.vpcf"
            local material_group = "default"
            if active then
                if hero.items_data_custom ~= nil and hero.items_data_custom["shoulder"] ~= nil then
                    hero.items_data_custom["shoulder"]:Destroy()
                    hero.items_data_custom["shoulder"] = nil
                end
                model_name = "models/items/queenofpain/qop_2022_immortal/qop_2022_immortal_arcana_refit.vmdl"
                if hero:HasModifier("modifier_queenofpain_immortal_custom") then
                    material_group = "default"
                    particle = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_arcana_2022_ambient.vpcf"
                elseif hero:HasModifier("modifier_queenofpain_immortal_custom_v2") then
                    material_group = "1"
                    particle = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_arcana_2022_ambient_blue_main.vpcf"
                end
            else
                if hero.items_data_custom ~= nil and hero.items_data_custom["shoulder"] ~= nil then
                    hero.items_data_custom["shoulder"]:Destroy()
                    hero.items_data_custom["shoulder"] = nil
                end
                if hero:HasModifier("modifier_queenofpain_immortal_custom") then
                    material_group = "default"
                    particle = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_ambient.vpcf"
                elseif hero:HasModifier("modifier_queenofpain_immortal_custom_v2") then
                    material_group = "1"
                    particle = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_ambient_blue.vpcf"
                end
            end
            if hero:HasModifier("modifier_queenofpain_arcana_custom_1") and hero:HasModifier("modifier_queenofpain_arcana_custom_2") and hero.items_data_custom["shoulder"] ~= nil and hero.items_data_custom["shoulder"]:GetModelName() == "models/items/queenofpain/qop_2022_immortal/qop_2022_immortal_arcana_refit.vmdl" then
                return
            end
            item_model_entity = wearables_system:CreateWearable(hero, model_name)
            if (hero:HasModifier("modifier_queenofpain_arcana_custom_1") or hero:HasModifier("modifier_queenofpain_arcana_custom_2")) then
                item_model_entity:AddActivityModifier("qop_2022")
            end
            item_model_entity:SetMaterialGroup(material_group)
            hero.items_data_custom["shoulder"] = item_model_entity
            Timers:CreateTimer(3, function()
                if hero ~= nil and hero.particles_items_data_custom ~= nil and hero.particles_items_data_custom["shoulder"] ~= nil then
                    for _, particle in pairs(hero.particles_items_data_custom["shoulder"]) do
                        ParticleManager:DestroyParticle(particle, true)
                    end
                    local new_particle = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, item_model_entity)
                    ParticleManager:SetParticleControl(new_particle, 0, hero:GetAbsOrigin())
                    table.insert(hero.particles_items_data_custom["shoulder"], new_particle)
                end
            end)
        end)
    end
end

function wearables_system:CheckingUniqueArcaneItems(hero)
    if hero and hero:GetModelName() == "models/items/pudge/arcana/pudge_arcana_base.vmdl" then
        print("[wearables_system] " .. "У игрока есть аркана на пуджа в доте")
        hero.other_model_backup_name["hero_base"] = "models/development/invisiblebox.vmdl"
        wearables_system:BackupOtherModelDota(hero, "hero_base")
    end
    if hero and hero:GetModelName() == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
        print("[wearables_system] " .. "У игрока есть аркана на джагернаута в доте")
        hero.other_model_backup_name["hero_base"] = "models/development/invisiblebox.vmdl"
        wearables_system:BackupOtherModelDota(hero, "hero_base")
    end
    if hero and hero:GetModelName() == "models/items/axe/ti9_jungle_axe/axe_bare.vmdl" then
        print("[wearables_system] " .. "У игрока есть персона на акса в доте")
        hero.other_model_backup_name["weapon"] = "models/development/invisiblebox.vmdl"
        wearables_system:BackupOtherModelDota(hero, "weapon")
    end
end

function wearables_system:StartingModifiersPersona(hero)
    if hero.crystal_persona then
        hero:AddNewModifier(hero, nil, "modifier_crystal_maiden_persona_1", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 26559, nil)
    elseif hero.crystal_persona_2 then
        hero:AddNewModifier(hero, nil, "modifier_crystal_maiden_persona_2", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 265591, nil)
    elseif hero.crystal_persona_3 then
        hero:AddNewModifier(hero, nil, "modifier_crystal_maiden_persona_3", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 265592, nil)
    elseif hero.crystal_persona_4 then
        hero:AddNewModifier(hero, nil, "modifier_crystal_maiden_persona_4", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29578, nil)
    elseif hero.phantom_persona then
        hero:AddNewModifier(hero, nil, "modifier_phantom_assassin_persona_custom", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 4480, nil)
    elseif hero.phantom_persona_2 then
        hero:AddNewModifier(hero, nil, "modifier_phantom_assassin_persona_custom_2", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 31081, nil)
    elseif hero.phantom_persona_3 then
        hero:AddNewModifier(hero, nil, "modifier_phantom_assassin_persona_custom_3", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 28320, nil)
    elseif hero.pudge_persona then
        hero:AddNewModifier(hero, nil, "modifier_pudge_persona_custom", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 999251, nil)
    elseif hero.pudge_persona_1 then
        hero:AddNewModifier(hero, nil, "modifier_pudge_persona_custom_1", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 999252, nil)
    elseif hero.pudge_persona_2 then
        hero:AddNewModifier(hero, nil, "modifier_pudge_persona_custom_2", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 999253, nil)
    elseif hero.pudge_persona_3 then
        hero:AddNewModifier(hero, nil, "modifier_pudge_persona_custom_3", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 30385, nil)
    elseif hero.invoker_persona_1 then
        hero:AddNewModifier(hero, nil, "modifier_invoker_persona_1", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 13042, nil)
    elseif hero.invoker_persona_2 then
        hero:AddNewModifier(hero, nil, "modifier_invoker_persona_2", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 21836, nil)
    elseif hero.invoker_persona_3 then
        hero:AddNewModifier(hero, nil, "modifier_invoker_persona_3", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 25513, nil)
    elseif hero.invoker_persona_4 then
        hero:AddNewModifier(hero, nil, "modifier_invoker_persona_4", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 23257, nil)
    elseif hero.invoker_persona_5 then
        hero:AddNewModifier(hero, nil, "modifier_invoker_persona_5", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 30575, nil)
    elseif hero.invoker_persona_6 then
        hero:AddNewModifier(hero, nil, "modifier_invoker_persona_6", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 30721, nil)
    elseif hero.antimage_persona_1 then
        hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_1", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 13783, nil)
    elseif hero.antimage_persona_2 then
        hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_2", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29296, nil)
    elseif hero.antimage_persona_3 then
        hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_3", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29137, nil)
    elseif hero.antimage_persona_4 then
        hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_4", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 27297, nil)
    elseif hero.antimage_persona_5 then
        hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_5", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 28278, nil)
    elseif hero.antimage_persona_6 then
        hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_6", {})
        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29126, nil)
    end
end

function wearables_system:SetItemPersonaUpdater(hero, modifier_item, onequip, item)
    if hero:GetUnitName() == "npc_dota_hero_antimage" and hero.original_model_donate == "models/heroes/antimage_female/antimage_female.vmdl" then
        if modifier_item == "modifier_antimage_persona_custom_1" or modifier_item == "modifier_antimage_persona_custom_2" or modifier_item == "modifier_antimage_persona_custom_3" or modifier_item == "modifier_antimage_persona_custom_4" or modifier_item == "modifier_antimage_persona_custom_5" or modifier_item == "modifier_antimage_persona_custom_6" then
            hero:RemoveModifierByName("modifier_antimage_persona_custom_1")
            hero:RemoveModifierByName("modifier_antimage_persona_custom_2")
            hero:RemoveModifierByName("modifier_antimage_persona_custom_3")
            hero:RemoveModifierByName("modifier_antimage_persona_custom_4")
            hero:RemoveModifierByName("modifier_antimage_persona_custom_5")
            hero:RemoveModifierByName("modifier_antimage_persona_custom_6")
            if hero:IsRealHero() then
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 13783, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29296, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29137, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 27297, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 28278, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29126, true)
            end
            if onequip then
                hero:AddNewModifier(hero, nil, modifier_item, {})
                if hero:IsRealHero() then
                    wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, nil)
                end
            else
                if hero.antimage_persona_1 then
                    hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_1", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 13783, nil)
                    end
                elseif hero.antimage_persona_2 then
                    hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_2", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29296, nil)
                    end
                elseif hero.antimage_persona_3 then
                    hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_3", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29137, nil)
                    end
                elseif hero.antimage_persona_4 then
                    hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_4", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 27297, nil)
                    end
                elseif hero.antimage_persona_5 then
                    hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_5", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 28278, nil)
                    end
                elseif hero.antimage_persona_6 then
                    hero:AddNewModifier(hero, nil, "modifier_antimage_persona_custom_6", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29126, nil)
                    end
                end
                if hero:IsRealHero() then
                    if item ~= 13783 and item ~= 29296 and item ~= 29137 and item ~= 27297 and item ~= 28278 and item ~= 29126 then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, true)
                    end
                end
            end
        end
        return true
    end
    if hero:GetUnitName() == "npc_dota_hero_invoker" and hero.original_model_donate == "models/heroes/invoker_kid/invoker_kid.vmdl" then
        if modifier_item == "modifier_invoker_persona_1" or modifier_item == "modifier_invoker_persona_2" or modifier_item == "modifier_invoker_persona_3" or modifier_item == "modifier_invoker_persona_4" or modifier_item == "modifier_invoker_persona_5" or modifier_item == "modifier_invoker_persona_6" then
            hero:RemoveModifierByName("modifier_invoker_persona_1")
            hero:RemoveModifierByName("modifier_invoker_persona_2")
            hero:RemoveModifierByName("modifier_invoker_persona_3")
            hero:RemoveModifierByName("modifier_invoker_persona_4")
            hero:RemoveModifierByName("modifier_invoker_persona_5")
            hero:RemoveModifierByName("modifier_invoker_persona_6")
            if hero:IsRealHero() then
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 13042, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 21836, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 25513, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 23257, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 30575, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 30721, true)
            end
            if onequip then
                hero:AddNewModifier(hero, nil, modifier_item, {})
                if hero:IsRealHero() then
                    wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, nil)
                end
            else
                if hero.invoker_persona_1 then
                    hero:AddNewModifier(hero, nil, "modifier_invoker_persona_1", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 13042, nil)
                    end
                elseif hero.invoker_persona_2 then
                    hero:AddNewModifier(hero, nil, "modifier_invoker_persona_2", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 21836, nil)
                    end
                elseif hero.invoker_persona_3 then
                    hero:AddNewModifier(hero, nil, "modifier_invoker_persona_3", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 25513, nil)
                    end
                elseif hero.invoker_persona_4 then
                    hero:AddNewModifier(hero, nil, "modifier_invoker_persona_4", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 23257, nil)
                    end
                elseif hero.invoker_persona_5 then
                    hero:AddNewModifier(hero, nil, "modifier_invoker_persona_5", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 30575, nil)
                    end
                elseif hero.invoker_persona_5 then
                    hero:AddNewModifier(hero, nil, "modifier_invoker_persona_6", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 30721, nil)
                    end
                end
                if hero:IsRealHero() then
                    if item ~= 13042 and item ~= 21836 and item ~= 25513 and item ~= 23257 and item ~= 30575 and item ~= 30721 then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, true)
                    end
                end
            end
        end
        return true
    end
    if hero:GetUnitName() == "npc_dota_hero_crystal_maiden" and hero.original_model_donate == "models/heroes/crystal_maiden_persona/crystal_maiden_persona.vmdl" then
        if modifier_item == "modifier_crystal_maiden_persona_1" or modifier_item == "modifier_crystal_maiden_persona_2" or modifier_item == "modifier_crystal_maiden_persona_3" or modifier_item == "modifier_crystal_maiden_persona_4" then
            hero:RemoveModifierByName("modifier_crystal_maiden_persona_1")
            hero:RemoveModifierByName("modifier_crystal_maiden_persona_2")
            hero:RemoveModifierByName("modifier_crystal_maiden_persona_3")
            hero:RemoveModifierByName("modifier_crystal_maiden_persona_4")
            if hero:IsRealHero() then
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 26559, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 265591, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 265592, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29578, true)
            end
            if onequip then
                hero:AddNewModifier(hero, nil, modifier_item, {})
                if hero:IsRealHero() then
                    wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, nil)
                end
            else
                if hero.crystal_persona then
                    hero:AddNewModifier(hero, nil, "modifier_crystal_maiden_persona_1", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 26559, nil)
                    end
                elseif hero.crystal_persona_2 then
                    hero:AddNewModifier(hero, nil, "modifier_crystal_maiden_persona_2", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 265591, nil)
                    end
                elseif hero.crystal_persona_3 then
                    hero:AddNewModifier(hero, nil, "modifier_crystal_maiden_persona_3", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 265592, nil)
                    end
                elseif hero.crystal_persona_4 then
                    hero:AddNewModifier(hero, nil, "modifier_crystal_maiden_persona_4", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 29578, nil)
                    end
                end
                if hero:IsRealHero() then
                    if item ~= 26559 and item ~= 265591 and item ~= 265592 and item ~= 29578 then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, true)
                    end
                end
            end
        end
        return true
    end
    if hero:GetUnitName() == "npc_dota_hero_pudge" and hero.original_model_donate == "models/heroes/pudge_cute/pudge_cute.vmdl" then
        if modifier_item == "modifier_pudge_persona_custom" or modifier_item == "modifier_pudge_persona_custom_1" or modifier_item == "modifier_pudge_persona_custom_2" then
            hero:RemoveModifierByName("modifier_pudge_persona_custom")
            hero:RemoveModifierByName("modifier_pudge_persona_custom_1")
            hero:RemoveModifierByName("modifier_pudge_persona_custom_2")
            hero:RemoveModifierByName("modifier_pudge_persona_custom_3")
            if hero:IsRealHero() then
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 999251, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 999252, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 999253, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 30385, true)
            end
            if onequip then
                hero:AddNewModifier(hero, nil, modifier_item, {})
                if hero:IsRealHero() then
                    wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, nil)
                end
            else
                if hero.pudge_persona then
                    hero:AddNewModifier(hero, nil, "modifier_pudge_persona_custom", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 999251, nil)
                    end
                elseif hero.pudge_persona_1 then
                    hero:AddNewModifier(hero, nil, "modifier_pudge_persona_custom_1", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 999252, nil)
                    end
                elseif hero.pudge_persona_2 then
                    hero:AddNewModifier(hero, nil, "modifier_pudge_persona_custom_2", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 999253, nil)
                    end
                elseif hero.pudge_persona_3 then
                    hero:AddNewModifier(hero, nil, "modifier_pudge_persona_custom_3", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 30385, nil)
                    end
                end
                if hero:IsRealHero() then
                    if item ~= 999251 and item ~= 999252 and item ~= 999253 and item ~= 30385 then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, true)
                    end
                end
            end
        end
        return true
    end
    if hero:GetUnitName() == "npc_dota_hero_phantom_assassin" and hero.original_model_donate == "models/heroes/phantom_assassin_persona/phantom_assassin_persona.vmdl" then
        if modifier_item == "modifier_phantom_assassin_persona_custom" or modifier_item == "modifier_phantom_assassin_persona_custom_2" or modifier_item == "modifier_phantom_assassin_persona_custom_3" then
            hero:RemoveModifierByName("modifier_phantom_assassin_persona_custom")
            hero:RemoveModifierByName("modifier_phantom_assassin_persona_custom_2")
            hero:RemoveModifierByName("modifier_phantom_assassin_persona_custom_3")
            if hero:IsRealHero() then
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 4480, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 31081, true)
                wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 28320, true)
            end
            if onequip then
                hero:AddNewModifier(hero, nil, modifier_item, {})
                if hero:IsRealHero() then
                    wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, nil)
                end
            else
                if hero.phantom_persona then
                    hero:AddNewModifier(hero, nil, "modifier_phantom_assassin_persona_custom", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 4480, nil)
                    end
                elseif hero.phantom_persona_2 then
                    hero:AddNewModifier(hero, nil, "modifier_phantom_assassin_persona_custom_2", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 31081, nil)
                    end
                elseif hero.phantom_persona_3 then
                    hero:AddNewModifier(hero, nil, "modifier_phantom_assassin_persona_custom_3", {})
                    if hero:IsRealHero() then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), 28320, nil)
                    end
                end
                if hero:IsRealHero() then
                    if item ~= 4480 and item ~= 31081 and item ~= 28320 then
                        wearables_system:UpdatePortraitInfo(hero:GetPlayerOwnerID(), item, true)
                    end
                end
            end
        end
        return true
    end
    return false
end