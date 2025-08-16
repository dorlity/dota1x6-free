modifier_hero_donate_illusion_invisible = class({})
function modifier_hero_donate_illusion_invisible:IsHidden() return true end
function modifier_hero_donate_illusion_invisible:IsPurgable() return false end
function modifier_hero_donate_illusion_invisible:IsPurgeException() return false end
function modifier_hero_donate_illusion_invisible:RemoveOnDeath() return false end
function modifier_hero_donate_illusion_invisible:CheckState()
    return
    {
        [MODIFIER_STATE_INVISIBLE] = true,
    }
end

---------------------------------------------------------------------------------------------------------------

modifier_hero_donate_illusion = class({})
function modifier_hero_donate_illusion:IsHidden() return true end
function modifier_hero_donate_illusion:IsPurgable() return false end
function modifier_hero_donate_illusion:OnDestroy()
	if not IsServer() then return end
    local parent = self:GetParent()
    if not parent or parent:IsNull() then return end

    parent:AddDeathEvent(self)

    local modifiers_with_one_items = 
    {
        "modifier_huskar_2021_weapon_golden_custom",
        "modifier_huskar_2021_weapon_custom",
        "modifier_pudge_harpoon_hook_custom_golden",
        "modifier_pudge_harpoon_hook_custom_witness",
        "modifier_pudge_harpoon_hook_custom",
        "modifier_pudge_hook_ti10_claws_custom_green",
        "modifier_pudge_hook_ti10_claws_custom",
    }
    local modifiers_persona_items = 
    {
        "modifier_phantom_assassin_persona_custom",
        "modifier_phantom_assassin_persona_custom_2",
        "modifier_phantom_assassin_persona_custom_3",
        "modifier_pudge_persona_custom",
        "modifier_pudge_persona_custom_1",
        "modifier_pudge_persona_custom_2",
        "modifier_pudge_persona_custom_3",
        "modifier_crystal_maiden_persona_1",
        "modifier_crystal_maiden_persona_2",
        "modifier_crystal_maiden_persona_3",
        "modifier_crystal_maiden_persona_4",
        "modifier_invoker_persona_1",
        "modifier_invoker_persona_2",
        "modifier_invoker_persona_3",
        "modifier_invoker_persona_4",
        "modifier_invoker_persona_5",
        "modifier_invoker_persona_6",
        "modifier_antimage_persona_custom_1",
        "modifier_antimage_persona_custom_2",
        "modifier_antimage_persona_custom_3",
        "modifier_antimage_persona_custom_4",
        "modifier_antimage_persona_custom_5",
         "modifier_antimage_persona_custom_6",
    }
    -- Текущие надетые предметы
	if parent.items_data_custom ~= nil then
        for _, item in pairs(parent.items_data_custom) do
            if item and not item:IsNull() then
                item:AddEffects(EF_NODRAW)
                UTIL_Remove(item)
            end
        end
    end
    -- Предметы дефолтные
    if parent.other_model_backup ~= nil then
        for _, item in pairs(parent.other_model_backup) do
            if item and not item:IsNull() then
                item:AddEffects(EF_NODRAW)
                UTIL_Remove(item)
            end
        end
    end
    -- Модификаторы где есть одна доп. шмотка
    for _, mod in pairs(modifiers_with_one_items) do
        local modifier_with_item = parent:FindModifierByName(mod)
        if modifier_with_item and modifier_with_item.hand and not modifier_with_item.hand:IsNull() then
            modifier_with_item.hand:AddEffects(EF_NODRAW)
            UTIL_Remove(modifier_with_item.hand)
        end
    end
    -- Предметы персон
    for _, mod in pairs(modifiers_persona_items) do
        local modifier_with_items = parent:FindModifierByName(mod)
        if modifier_with_items and modifier_with_items.items then
            for _, item in pairs(modifier_with_items.items) do
                if item and not item:IsNull() then
                    item:AddEffects(EF_NODRAW)
                    UTIL_Remove(item)
                end
            end
        end
    end
    parent.first_spawn_model = nil
end



function modifier_hero_donate_illusion:DeathEvent(params)
    if not IsServer() then return end
    if params.unit == self:GetParent() then
        self:Destroy()
    end
end

---------------------------------------------------------------------------------------------------------------

modifier_donate_hero_illusion_item = class({})
function modifier_donate_hero_illusion_item:IsHidden() return true end
function modifier_donate_hero_illusion_item:IsPurgable() return false end
function modifier_donate_hero_illusion_item:IsPurgeException() return false end
function modifier_donate_hero_illusion_item:RemoveOnDeath() return false end
function modifier_donate_hero_illusion_item:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_donate_hero_illusion_item:CheckState()
return
{
    [MODIFIER_STATE_OUT_OF_GAME] = true,
    [MODIFIER_STATE_INVULNERABLE] = true,
    [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
    [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
    [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
    [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    [MODIFIER_STATE_PROVIDES_VISION] = true,
}
end

function modifier_donate_hero_illusion_item:OnCreated(table)
self.caster = self:GetCaster()
self.parent = self:GetParent()
if not IsServer() then return end
self.invis_counter = 0
-- self.parent:AddNewModifier(self.parent, nil, "modifier_hero_donate_illusion_invisible", {})
self:SetHasCustomTransmitterData(true)
end

function modifier_donate_hero_illusion_item:UpdateState(state)
if not IsServer() then return end
self.invis_counter = state
self:SendBuffRefreshToClients()
end

function modifier_donate_hero_illusion_item:AddCustomTransmitterData()
return 
{
    invis_counter = self.invis_counter,
}
end

function modifier_donate_hero_illusion_item:HandleCustomTransmitterData( data )
self.invis_counter = data.invis_counter
end

function modifier_donate_hero_illusion_item:DeclareFunctions()
return
{
    MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
}
end

function modifier_donate_hero_illusion_item:GetModifierInvisibilityLevel()
return self.invis_counter
end



---------------------------------------------------------------------------------------------------------------

modifier_donate_hero_illusion_item_effect_hero = class({})
function modifier_donate_hero_illusion_item_effect_hero:IsHidden() return false end
function modifier_donate_hero_illusion_item_effect_hero:IsPurgable() return false end
function modifier_donate_hero_illusion_item_effect_hero:IsPurgeException() return false end
function modifier_donate_hero_illusion_item_effect_hero:RemoveOnDeath() return false end
function modifier_donate_hero_illusion_item_effect_hero:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_donate_hero_illusion_item_effect_hero:OnCreated(params)
    if not IsServer() then return end
    self.particle = params.particle
    self:SetHasCustomTransmitterData(true)
end

function modifier_donate_hero_illusion_item_effect_hero:AddCustomTransmitterData()
    return 
    {
        particle = self.particle,
    }
end

function modifier_donate_hero_illusion_item_effect_hero:HandleCustomTransmitterData( data )
    self.particle = data.particle
end

function modifier_donate_hero_illusion_item_effect_hero:GetHeroEffectName()
    return self.particle
end
function modifier_donate_hero_illusion_item_effect_hero:HeroEffectPriority()
    return 10000
end