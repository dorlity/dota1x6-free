LinkLuaModifier("modifier_donate_hero_illusion_item_effect_hero", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_hero_donate_hex_checking = class({})
function modifier_hero_donate_hex_checking:IsHidden() return true end
function modifier_hero_donate_hex_checking:IsPurgable() return false end
function modifier_hero_donate_hex_checking:RemoveOnDeath() return false end
function modifier_hero_donate_hex_checking:OnCreated()
if not IsServer() then return end
print("INIT modifier_hero_donate_hex_checking")
self.parent = self:GetParent()

self.parent:AddDeathEvent(self)
self.parent:AddRespawnEvent(self)

self.items_list = {}
self.no_draw_mods = {}
self.status_table = {}
self.no_draw_exception = {}

self.exception_items = {}

self:UpdatePlayerItems()

self.has_exception = false
self.invis_state = false
self.hide_state = false
self.status_state = false

self.interval = 0.2
if self.parent:IsIllusion() or self.parent:IsTempestDouble() then
    self.interval = 0.4
end

end


function modifier_hero_donate_hex_checking:OnIntervalThink()
if not IsServer() then return end

if self.invis_state then
    self:UpdateInvis()
end

if self.hide_state and self.has_exception == false then
    self:CheckNoDraw()
end

if self.status_state then
    self:CheckStatusTable()
end

end


function modifier_hero_donate_hex_checking:StartMorph()
if not IsServer() then return end

for _,item in pairs(self.items_list) do
    if item and not item:IsNull() then
        self.exception_items[item] = true
        item:AddEffects(EF_NODRAW)
    end
end

end


function modifier_hero_donate_hex_checking:EndMorph()
if not IsServer() then return end
self.exception_items = {}

self:UpdateVisibleItems()
end


function modifier_hero_donate_hex_checking:UpdatePlayerItems()
if not self.parent or self.parent:IsNull() then return end

-- Cбор всех предметов в один массив all_items_list
local all_items_list = {}
-- Нормальная база
if self.parent.items_data_custom ~= nil then
    for _, item in pairs(self.parent.items_data_custom) do
        table.insert(all_items_list, item)
    end
end
if self.parent.other_model_backup ~= nil then
    for _, item in pairs(self.parent.other_model_backup) do
        table.insert(all_items_list, item)
    end
end
-- Модификаторы где есть одна доп. шмотка
for _, mod in pairs(modifiers_with_one_items) do
    local modifier_with_item = self.parent:FindModifierByName(mod)
    if modifier_with_item and modifier_with_item.hand then
        table.insert(all_items_list, modifier_with_item.hand)
    end
end
-- Предметы персон
for _, mod in pairs(modifiers_persona_items) do
    local modifier_with_items = self.parent:FindModifierByName(mod)
    if modifier_with_items and modifier_with_items.items then
        for _, item in pairs(modifier_with_items.items) do
            table.insert(all_items_list, item)
        end
    end
end

if self.parent.morphling_ult_items then
    for _, item in pairs(self.parent.morphling_ult_items) do
        table.insert(all_items_list, item)
    end
end

self.items_list = all_items_list
self:UpdateVisibleItems()

self.invis_state = false
self.hide_state = false
self.status_state = false

self:UpdateInvis()
self:CheckNoDraw()
self:CheckStatusTable()
end



-- Поиск статус эффектов и херо эффектов
function modifier_hero_donate_hex_checking:UpdateEffectsList(modifier)

local modifier_name = modifier:GetName()

if modifier_name == "modifier_morphling_replicate_custom" then return end
if not dota_modifiers_status[modifier_name] and (not modifier.GetStatusEffectName or not modifier:GetStatusEffectName()) then return end

local table_result = {}
local priority = 0
local status_name = nil

table_result.status_mod = modifier

if (dota_modifiers_status[modifier_name]) then
    status_name = dota_modifiers_status[modifier_name][1]
    priority = dota_modifiers_status[modifier_name][2]
else
    status_name = modifier:GetStatusEffectName()
end

if (modifier.StatusEffectPriority ~= nil and modifier:StatusEffectPriority() ~= nil) then
    priority = modifier:StatusEffectPriority()
end

table_result.mod_table = {}

for _,item in pairs(self.items_list) do
    if item and not item:IsNull() then
        table.insert(table_result.mod_table, item:AddNewModifier(self.parent, nil, "status_effect_thinker_custom", {name = status_name, priority = priority}))
    end
end

if priority == MODIFIER_PRIORITY_ILLUSION then return end

self.status_table[table_result] = true

self:CheckStatusTable()
end



function modifier_hero_donate_hex_checking:AddModifier(mod)
if not IsServer() then return end

self:UpdateEffectsList(mod)

self:UpdateInvis()

if modifiers_alpha[mod:GetName()] then
    self:AddNoDrawMod(mod)
end

if mod and (items_list_persona[mod:GetName()]) then
    self:UpdateVisibleItems()
end

end


function modifier_hero_donate_hex_checking:UpdateInvis()
local invis_state = self.parent:IsInvisible() or self.parent:HasModifier("modifier_phantom_assassin_phantom_smoke")

if invis_state ~= self.invis_state then
    self.invis_state = invis_state
    for _,item in pairs(self.items_list) do
        if item and not item:IsNull() then
            local mod = item:FindModifierByName("modifier_donate_hero_illusion_item")
            if mod then
                mod:UpdateState(invis_state)
            end
        end
    end
    self:CheckInterval()
end

end


function modifier_hero_donate_hex_checking:AddNoDrawMod(mod, add_exception)

if add_exception then
    self.has_exception = true
    self.no_draw_exception[mod] = true
end

self.no_draw_mods[mod] = true
self:CheckNoDraw()
end


function modifier_hero_donate_hex_checking:RemoveException(delete_mod)

local has_exception = false
for mod,_ in pairs(self.no_draw_exception) do
    if not mod or mod:IsNull() or mod == delete_mod then
        self.no_draw_exception[mod] = nil
    else
        has_exception = true
    end
end

if has_exception ~= self.has_exception then
    self.has_exception = has_exception
    self:CheckInterval(true)
end

end



function modifier_hero_donate_hex_checking:CheckStatusTable()

local status_state = false
for data,_ in pairs(self.status_table) do
    if data.status_mod and not data.status_mod:IsNull() then
        status_state = true
    else
        if data.mod_table then
            for _,mod in pairs(data.mod_table) do
                if mod and not mod:IsNull() then
                    mod:Destroy()
                end
            end
        end
        self.status_table[data] = nil
    end
end

if status_state ~= self.status_state then
    self.status_state = status_state
    self:CheckInterval()
end

end

function modifier_hero_donate_hex_checking:CheckNoDraw()

local hide_state = false
for mod,_ in pairs(self.no_draw_mods) do
    if mod and not mod:IsNull() and (mod.NoDraw or modifiers_alpha[mod:GetName()]) then
        hide_state = true
        break
    else
        self.no_draw_mods[mod] = nil
    end
end

if self.hide_state ~= hide_state then
    self.hide_state = hide_state

    self:CheckInterval()

    if self.hide_state == true then
        for _, item in pairs(self.items_list) do
            if item and not item:IsNull() then
                item:AddEffects(EF_NODRAW)
            end
        end
    else
        self:UpdateVisibleItems()
    end
end

end

function modifier_hero_donate_hex_checking:CheckInterval(on_interval)

if self.invis_state == false and (self.hide_state == false or self.has_exception) and self.status_state == false then
    self:StartIntervalThink(-1)
else
    if on_interval then
        self:OnIntervalThink()
    end
    self:StartIntervalThink(self.interval)
end

end



function modifier_hero_donate_hex_checking:DeathEvent(params)
if not IsServer() then return end
if params.unit ~= self.parent then return end
if not self.parent:IsRealHero() then return end

if self.parent:GetUnitName() == "npc_dota_hero_crystal_maiden" and not self.parent:IsAlive() then
    self.NoDraw = true
    self:AddNoDrawMod(self)  
    return
end

if self.parent:GetUnitName() == "npc_dota_hero_lina" then
    Timers:CreateTimer(2.1, function()
        if not self.parent:IsAlive() then
            self.NoDraw = true
            self:AddNoDrawMod(self)            
            self.parent:AddNoDraw()
        end
    end)
    return
end

if self.parent:GetUnitName() == "npc_dota_hero_terrorblade" then
    Timers:CreateTimer(1.7, function()
        if not self.parent:IsAlive() then
            self.NoDraw = true
            self:AddNoDrawMod(self)            
            self.parent:AddNoDraw()
        end
    end)
    return
end

end

function modifier_hero_donate_hex_checking:RespawnEvent(params)
if not IsServer() then return end
if params.unit ~= self.parent then return end

if self.NoDraw then
    self.NoDraw = nil
    self.parent:RemoveNoDraw() 
end

end


function modifier_hero_donate_hex_checking:UpdateVisibleItems()
if self.hide_state then return end

if self.parent.items_data_custom ~= nil then
    for _, item in pairs(self.parent.items_data_custom) do
        if not item:IsNull() then 
            local should_hide = false
            for _, mod_persona_name in pairs(modifiers_persona_items) do
                if self.parent:HasModifier(mod_persona_name) and not items_list_persona[mod_persona_name][item:GetModelName()] then
                    should_hide = true
                    break
                end
            end

            if self.exception_items[item] then
                should_hide = true
            end

            if should_hide then
                item:AddEffects(EF_NODRAW)
            else
                if self.parent:HasModifier("modifier_custom_pudge_meat_hook_hidden") and _ == "back" and self.parent:GetModelName() == "models/heroes/pudge_cute/pudge_cute.vmdl" then
                    item:AddEffects(EF_NODRAW)
                elseif self.parent:HasModifier("modifier_custom_pudge_meat_hook_hidden") and _ == "weapon" then
                    item:AddEffects(EF_NODRAW)
                else
                    item:RemoveEffects(EF_NODRAW)
                end
            end
        end
    end
end
if self.parent.other_model_backup ~= nil then
    for _, item in pairs(self.parent.other_model_backup) do
        if not item:IsNull() then 
            local should_hide = false
            for _, mod_persona_name in pairs(modifiers_persona_items) do
                if self.parent:HasModifier(mod_persona_name) and not items_list_persona[mod_persona_name][item:GetModelName()] then
                    should_hide = true
                    break
                end
            end

            if self.exception_items[item] then
                should_hide = true
            end

            if should_hide then
                item:AddEffects(EF_NODRAW)
            else
                if self.parent:HasModifier("modifier_custom_pudge_meat_hook_hidden") and _ == "back" and self.parent:GetModelName() == "models/heroes/pudge_cute/pudge_cute.vmdl" then
                    item:AddEffects(EF_NODRAW)
                elseif self.parent:HasModifier("modifier_custom_pudge_meat_hook_hidden") and _ == "weapon" then
                    item:AddEffects(EF_NODRAW)
                else
                    item:RemoveEffects(EF_NODRAW)
                end
            end
        end
    end
end
for _, item_hand_modifier_name in pairs(modifiers_with_one_items) do
    local item_hand_modifier = self.parent:FindModifierByName(item_hand_modifier_name)
    if item_hand_modifier and item_hand_modifier.hand then
        if self.parent:HasModifier("modifier_pudge_persona_custom") or self.parent:HasModifier("modifier_pudge_persona_custom_1")  or self.parent:HasModifier("modifier_pudge_persona_custom_2") or self.parent:HasModifier("modifier_pudge_persona_custom_3") then
            item_hand_modifier.hand:AddEffects(EF_NODRAW)
        else
            item_hand_modifier.hand:RemoveEffects(EF_NODRAW)
        end
    end
end
for _, modifier_persona_modifier_name in pairs(modifiers_persona_items) do
    local modifier_persona_modifier = self.parent:FindModifierByName(modifier_persona_modifier_name)
    if modifier_persona_modifier and modifier_persona_modifier.items then
        for _, item in pairs(modifier_persona_modifier.items) do
            if item and not item:IsNull() then

                local model_name = item:GetModelName()
                if (model_name == "models/heroes/pudge_cute/pudge_cute_weapon.vmdl"
                    or model_name == "models/items/pudge_cute/pudge_cute_frostivus/pudge_cute_frostivus_hook.vmdl"
                    or model_name == "models/items/pudge_cute/little_knight_weapon/little_knight_weapon.vmdl"
                    or model_name == "models/items/pudge_cute/pudge_cute_calavera/pudge_cute_calavera_weapon.vmdl"
                    or model_name == "models/items/pudge_cute/pudge_cute_calavera/pudge_cute_calavera_handle.vmdl")
                    and self.parent:HasModifier("modifier_custom_pudge_meat_hook_hidden") then

                    item:AddEffects(EF_NODRAW)
                else
                    item:RemoveEffects(EF_NODRAW)
                end
            end
        end
        break
    end
end


if self.parent.morphling_ult_items then
    for _, item in pairs(self.parent.morphling_ult_items) do
        if item and not item:IsNull() then
            item:RemoveEffects(EF_NODRAW)
        end
    end
end


end