modifier_hero_donate_illusion = class({})

function modifier_hero_donate_illusion:IsHidden() return true end
function modifier_hero_donate_illusion:IsPurgable() return false end
function modifier_hero_donate_illusion:OnDestroy()
	if not IsServer() then return end
	if self:GetParent().items_data_custom ~= nil then
        for _, item in pairs(self:GetParent().items_data_custom) do
            if not item:IsNull() then
                item:AddEffects(EF_NODRAW)
                UTIL_Remove(item)
            end
        end
    end
    if self:GetParent().other_model_backup ~= nil then
        for _, item in pairs(self:GetParent().other_model_backup) do
            if not item:IsNull() then
                item:AddEffects(EF_NODRAW)
                UTIL_Remove(item)
            end
        end
    end
    self:GetParent().first_spawn_model = nil
    self:GetParent():AddEffects(EF_NODRAW)
    local parent = self:GetParent()
    Timers:CreateTimer(0.1, function()
        UTIL_Remove(parent)
    end)
end

modifier_donate_hero_illusion_item = class({})

function modifier_donate_hero_illusion_item:IsHidden() return true end
function modifier_donate_hero_illusion_item:IsPurgable() return false end
function modifier_donate_hero_illusion_item:IsPurgeException() return false end
function modifier_donate_hero_illusion_item:RemoveOnDeath() return false end
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
        [MODIFIER_STATE_INVISIBLE] = self:GetStackCount() == 1,
    }
end

function modifier_donate_hero_illusion_item:OnCreated()
    if not IsServer() then return end
    self:SetStackCount(0)
    self:StartIntervalThink(0.1)
end

function modifier_donate_hero_illusion_item:OnIntervalThink()
    if not IsServer() then return end
    if self:GetParent():IsNull() then return end
    local invis = false

    for _, modifier in pairs(self:GetCaster():FindAllModifiers()) do
        if modifier then
            if modifier.GetModifierInvisibilityLevel then
                if modifier:GetModifierInvisibilityLevel() > 0 then
                    invis = true
                end
            end
        end
    end

    if invis or self:GetCaster():IsInvisible() then
        self:SetStackCount(1)
    else
        self:SetStackCount(0)
    end
end

function modifier_donate_hero_illusion_item:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_INVISIBILITY_LEVEL
    }
    return funcs
end

function modifier_donate_hero_illusion_item:GetModifierInvisibilityLevel(params)
    return self:GetStackCount()
end

modifier_donate_hero_illusion_item_effect_hero = class({})
function modifier_donate_hero_illusion_item_effect_hero:IsHidden() return true end
function modifier_donate_hero_illusion_item_effect_hero:IsPurgable() return false end
function modifier_donate_hero_illusion_item_effect_hero:IsPurgeException() return false end
function modifier_donate_hero_illusion_item_effect_hero:RemoveOnDeath() return false end
function modifier_donate_hero_illusion_item_effect_hero:GetStatusEffectName()
    return CustomNetTables:GetTableValue("heroes_items_info", "player_status_" .. tostring(self:GetCaster():GetEntityIndex())).particle or ""
end
function modifier_donate_hero_illusion_item_effect_hero:StatusEffectPriority()
    return 1
end

modifier_donate_hero_illusion_item_effect_status = class({})
function modifier_donate_hero_illusion_item_effect_status:IsHidden() return true end
function modifier_donate_hero_illusion_item_effect_status:IsPurgable() return false end
function modifier_donate_hero_illusion_item_effect_status:IsPurgeException() return false end
function modifier_donate_hero_illusion_item_effect_status:RemoveOnDeath() return false end
function modifier_donate_hero_illusion_item_effect_status:GetHeroEffectName()
    return CustomNetTables:GetTableValue("heroes_items_info", "player_effect_" .. tostring(self:GetCaster():GetEntityIndex())).particle or ""
end
function modifier_donate_hero_illusion_item_effect_status:HeroEffectPriority()
    return 1
end

