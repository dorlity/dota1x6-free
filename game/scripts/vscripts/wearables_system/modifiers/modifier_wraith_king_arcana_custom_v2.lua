modifier_wraith_king_arcana_custom_v2 = class({})
function modifier_wraith_king_arcana_custom_v2:IsHidden() return true end
function modifier_wraith_king_arcana_custom_v2:IsPurgable() return false end
function modifier_wraith_king_arcana_custom_v2:IsPurgeException() return false end
function modifier_wraith_king_arcana_custom_v2:RemoveOnDeath() return false end
function modifier_wraith_king_arcana_custom_v2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_wraith_king_arcana_custom_v2:GetActivityTranslationModifiers()
    return "arcana"
end
function modifier_wraith_king_arcana_custom_v2:OnCreated()
    if not IsServer() then return end
    if self:GetParent():HasModifier("modifier_wraith_king_blistering_shade_custom") then
        local find_shoulder = nil
        if self:GetParent().items_data_custom ~= nil and self:GetParent().items_data_custom["arms"] ~= nil and self:GetParent().items_data_custom["arms"]:GetModelName() == "models/items/wraith_king/blistering_shade/mesh/blistering_shade.vmdl" then
            find_shoulder = self:GetParent().items_data_custom["arms"]
        end
        if self:GetParent().other_model_backup ~= nil and self:GetParent().other_model_backup["arms"] ~= nil and self:GetParent().other_model_backup["arms"]:GetModelName() == "models/items/wraith_king/blistering_shade/mesh/blistering_shade.vmdl" then
            find_shoulder = self:GetParent().other_model_backup["arms"]
        end
        if find_shoulder ~= nil then
            find_shoulder:SetOriginalModel("models/items/wraith_king/blistering_shade/mesh/blistering_shade_alt.vmdl")
            find_shoulder:SetModel("models/items/wraith_king/blistering_shade/mesh/blistering_shade_alt.vmdl")
        end
    end
end
function modifier_wraith_king_arcana_custom_v2:OnDestroy()
    if not IsServer() then return end
    if self:GetParent():HasModifier("modifier_wraith_king_blistering_shade_custom") then
        local find_shoulder = nil
        if self:GetParent().items_data_custom ~= nil and self:GetParent().items_data_custom["arms"] ~= nil and self:GetParent().items_data_custom["arms"]:GetModelName() == "models/items/wraith_king/blistering_shade/mesh/blistering_shade_alt.vmdl" then
            find_shoulder = self:GetParent().items_data_custom["arms"]
        end
        if self:GetParent().other_model_backup ~= nil and self:GetParent().other_model_backup["arms"] ~= nil and self:GetParent().other_model_backup["arms"]:GetModelName() == "models/items/wraith_king/blistering_shade/mesh/blistering_shade_alt.vmdl" then
            find_shoulder = self:GetParent().other_model_backup["arms"]
        end
        if find_shoulder ~= nil then
            find_shoulder:SetOriginalModel("models/items/wraith_king/blistering_shade/mesh/blistering_shade.vmdl")
            find_shoulder:SetModel("models/items/wraith_king/blistering_shade/mesh/blistering_shade.vmdl")
        end
    end
end