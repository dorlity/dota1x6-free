LinkLuaModifier("modifier_donate_hero_illusion_item_effect_hero", "modifiers/hero_items/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_donate_hero_illusion_item_effect_status", "modifiers/hero_items/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_hero_donate_hex_checking = class({})

function modifier_hero_donate_hex_checking:IsHidden() return true end
function modifier_hero_donate_hex_checking:IsPurgable() return false end
function modifier_hero_donate_hex_checking:RemoveOnDeath() return false end

function modifier_hero_donate_hex_checking:OnCreated()
    if not IsServer() then return end
    self.last_effect = ""
    self.last_status = ""
    self.dota_modifiers_status = 
    {
        ["modifier_item_shivas_guard_blast"] = "particles/status_fx/status_effect_frost.vpcf",
        ["modifier_item_mage_slayer_debuff"] = "particles/items3_fx/status_effect_mage_slayer_debuff.vpcf",
        ["modifier_ghost_state"] = "particles/status_fx/status_effect_ghost.vpcf",
        ["modifier_item_ethereal_blade_ethereal"] = "particles/status_fx/status_effect_ghost.vpcf",
        ["modifier_item_ethereal_blade_slow"] = "particles/status_fx/status_effect_ghost.vpcf",
        ["modifier_item_skadi_slow"] = "particles/status_fx/status_effect_frost.vpcf",
    }
    self.dota_modifiers_effects = 
    {

    }
    CustomNetTables:SetTableValue("heroes_items_info", "player_effect_" .. tostring(self:GetParent():GetEntityIndex()), {particle = ""})
    CustomNetTables:SetTableValue("heroes_items_info", "player_status_" .. tostring(self:GetParent():GetEntityIndex()), {particle = ""})
    self.modifiers = 
    {
        "modifier_hexxed",
        "modifier_custom_puck_phase_shift",
        "modifier_sheepstick_debuff",
        "modifier_item_unstable_wand_critter",
    }
    self:StartIntervalThink(0.01)
end

function modifier_hero_donate_hex_checking:FindCurrentEffect(find)
    for _, modifier in pairs(self:GetParent():FindAllModifiers()) do
        if modifier then
            if find == "GetStatusEffectName" then
                if self.dota_modifiers_status[modifier:GetName()] then
                    return self.dota_modifiers_status[modifier:GetName()]
                end
                if modifier.GetStatusEffectName ~= nil and modifier:GetStatusEffectName() ~= nil then
                    return modifier:GetStatusEffectName()
                end
            end
            if find == "GetHeroEffectName" then
                if modifier.GetHeroEffectName ~= nil and modifier:GetHeroEffectName() ~= nil then
                    return modifier:GetHeroEffectName()
                end
            end
        end
    end
    return ""
end

function modifier_hero_donate_hex_checking:OnIntervalThink()
    if not IsServer() then return end
    local check_change_model = false
    for _, mod in pairs(self:GetParent():FindAllModifiers()) do
        if mod.NoDrow ~= nil then
            check_change_model = true
            break
        end
    end
    for _, mod in pairs(self.modifiers) do
        if self:GetParent():HasModifier(mod) then
            check_change_model = true
            break
        end
    end
    if check_change_model then
        if self:GetParent().items_data_custom ~= nil then
            for _, item in pairs(self:GetParent().items_data_custom) do
                if not item:IsNull() then
                    item:AddEffects(EF_NODRAW)
                end
            end
        end
        if self:GetParent().other_model_backup ~= nil then
            for _, item in pairs(self:GetParent().other_model_backup) do
                if not item:IsNull() then 
                    item:AddEffects(EF_NODRAW)
                end
            end
        end
        local modifier_huskar_2021_weapon_golden_custom = self:GetParent():FindModifierByName("modifier_huskar_2021_weapon_golden_custom")
        if modifier_huskar_2021_weapon_golden_custom then
            if modifier_huskar_2021_weapon_golden_custom.hand then
                modifier_huskar_2021_weapon_golden_custom.hand:AddEffects(EF_NODRAW)
            end
        end
        local modifier_huskar_2021_weapon_custom = self:GetParent():FindModifierByName("modifier_huskar_2021_weapon_custom")
        if modifier_huskar_2021_weapon_custom then
            if modifier_huskar_2021_weapon_custom.hand then
                modifier_huskar_2021_weapon_custom.hand:AddEffects(EF_NODRAW)
            end
        end
        local modifier_phantom_assassin_persona_custom = self:GetParent():FindModifierByName("modifier_phantom_assassin_persona_custom")
        if modifier_phantom_assassin_persona_custom then
            for _, item in pairs(modifier_phantom_assassin_persona_custom.items) do
                item:AddEffects(EF_NODRAW)
            end
        end
    else
        if self:GetParent().items_data_custom ~= nil then
            for _, item in pairs(self:GetParent().items_data_custom) do
                if not item:IsNull() then 
                    if self:GetParent():HasModifier("modifier_phantom_assassin_persona_custom") and 
                        item:GetModelName() ~= "models/heroes/phantom_assassin_persona/phantom_assassin_persona_weapon.vmdl" and 
                        item:GetModelName() ~= "models/heroes/phantom_assassin_persona/phantom_assassin_persona_head.vmdl" and 
                        item:GetModelName() ~= "models/heroes/phantom_assassin_persona/phantom_assassin_persona_legs.vmdl" and 
                        item:GetModelName() ~= "models/heroes/phantom_assassin_persona/phantom_assassin_persona_armor.vmdl" 
                    then
                        item:AddEffects(EF_NODRAW)
                    else
                        item:RemoveEffects(EF_NODRAW)
                    end
                end
            end
        end
        if self:GetParent().other_model_backup ~= nil then
            for _, item in pairs(self:GetParent().other_model_backup) do
                if not item:IsNull() then 
                    if self:GetParent():HasModifier("modifier_phantom_assassin_persona_custom") and 
                        item:GetModelName() ~= "models/heroes/phantom_assassin_persona/phantom_assassin_persona_weapon.vmdl" and 
                        item:GetModelName() ~= "models/heroes/phantom_assassin_persona/phantom_assassin_persona_head.vmdl" and 
                        item:GetModelName() ~= "models/heroes/phantom_assassin_persona/phantom_assassin_persona_legs.vmdl" and 
                        item:GetModelName() ~= "models/heroes/phantom_assassin_persona/phantom_assassin_persona_armor.vmdl" 
                    then
                        item:AddEffects(EF_NODRAW)
                    else
                        item:RemoveEffects(EF_NODRAW)
                    end
                end 
            end
        end
        local modifier_huskar_2021_weapon_golden_custom = self:GetParent():FindModifierByName("modifier_huskar_2021_weapon_golden_custom")
        if modifier_huskar_2021_weapon_golden_custom then
            if modifier_huskar_2021_weapon_golden_custom.hand then
                modifier_huskar_2021_weapon_golden_custom.hand:RemoveEffects(EF_NODRAW)
            end
        end
        local modifier_huskar_2021_weapon_custom = self:GetParent():FindModifierByName("modifier_huskar_2021_weapon_custom")
        if modifier_huskar_2021_weapon_custom then
            if modifier_huskar_2021_weapon_custom.hand then
                modifier_huskar_2021_weapon_custom.hand:RemoveEffects(EF_NODRAW)
            end
        end
        local modifier_phantom_assassin_persona_custom = self:GetParent():FindModifierByName("modifier_phantom_assassin_persona_custom")
        if modifier_phantom_assassin_persona_custom then
            for _, item in pairs(modifier_phantom_assassin_persona_custom.items) do
                item:RemoveEffects(EF_NODRAW)
            end
        end
    end

    local statusFx = self:FindCurrentEffect("GetStatusEffectName")
    local heroFx = self:FindCurrentEffect("GetHeroEffectName")

    if self.last_effect ~= heroFx then
        self.last_effect = heroFx
        CustomNetTables:SetTableValue("heroes_items_info", "player_effect_" .. tostring(self:GetParent():GetEntityIndex()), {particle = heroFx})
        self:Update()
    end

    if self.last_status ~= statusFx then
        self.last_status = statusFx
        CustomNetTables:SetTableValue("heroes_items_info", "player_status_" .. tostring(self:GetParent():GetEntityIndex()), {particle = statusFx})
        self:Update()
    end
end

function modifier_hero_donate_hex_checking:Update()
    if not IsServer() then return end
    if self:GetParent().items_data_custom ~= nil then
        for _, item in pairs(self:GetParent().items_data_custom) do
            item:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_hero")
            item:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_hero", {})
            item:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_status")
            item:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_status", {})
        end
    end
    if self:GetParent().other_model_backup ~= nil then
        for _, item in pairs(self:GetParent().other_model_backup) do
            item:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_hero")
            item:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_hero", {})
            item:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_status")
            item:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_status", {})
        end
    end
    local modifier_huskar_2021_weapon_golden_custom = self:GetParent():FindModifierByName("modifier_huskar_2021_weapon_golden_custom")
    if modifier_huskar_2021_weapon_golden_custom then
        if modifier_huskar_2021_weapon_golden_custom.hand then
            modifier_huskar_2021_weapon_golden_custom.hand:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_hero")
            modifier_huskar_2021_weapon_golden_custom.hand:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_hero", {})
            modifier_huskar_2021_weapon_golden_custom.hand:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_status")
            modifier_huskar_2021_weapon_golden_custom.hand:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_status", {})
        end
    end
    local modifier_huskar_2021_weapon_custom = self:GetParent():FindModifierByName("modifier_huskar_2021_weapon_custom")
    if modifier_huskar_2021_weapon_custom then
        if modifier_huskar_2021_weapon_custom.hand then
            modifier_huskar_2021_weapon_custom.hand:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_hero")
            modifier_huskar_2021_weapon_custom.hand:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_hero", {})
            modifier_huskar_2021_weapon_custom.hand:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_status")
            modifier_huskar_2021_weapon_custom.hand:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_status", {})
        end
    end
    local modifier_phantom_assassin_persona_custom = self:GetParent():FindModifierByName("modifier_phantom_assassin_persona_custom")
    if modifier_phantom_assassin_persona_custom then
        for _, item in pairs(modifier_phantom_assassin_persona_custom.items) do
            item:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_hero")
            item:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_hero", {})
            item:RemoveModifierByName("modifier_donate_hero_illusion_item_effect_status")
            item:AddNewModifier(self:GetCaster(), nil, "modifier_donate_hero_illusion_item_effect_status", {})
        end
    end
end