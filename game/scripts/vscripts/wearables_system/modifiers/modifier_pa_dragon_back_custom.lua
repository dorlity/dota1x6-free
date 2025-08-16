modifier_pa_dragon_back_custom = class({})
function modifier_pa_dragon_back_custom:IsHidden() return true end
function modifier_pa_dragon_back_custom:IsPurgable() return false end
function modifier_pa_dragon_back_custom:IsPurgeException() return false end
function modifier_pa_dragon_back_custom:RemoveOnDeath() return false end

function modifier_pa_dragon_back_custom:OnCreated()
    if not IsServer() then return end
    self.parent = self:GetParent()
    self:HasHeadAltStyle(self.parent:HasModifier("modifier_pa_arcana_custom") or self.parent:GetModelName() == "models/heroes/phantom_assassin/pa_arcana.vmdl")
end

function modifier_pa_dragon_back_custom:HasHeadAltStyle(active)
    if not IsServer() then return end
    local all_items_list = {}
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
    for _, item in pairs(all_items_list) do
        if item and not item:IsNull() and item ~= nil then
            if active then
                if item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back.vmdl" or item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_1.vmdl" then
                    if tostring(item:GetMaterialGroupHash()) == "628863847" then
                        item:SetOriginalModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit_1.vmdl")
                        item:SetModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit_1.vmdl")
                    else
                        item:SetOriginalModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit.vmdl")
                        item:SetModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit.vmdl")
                    end
                end
            else
                if item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit.vmdl" or item:GetModelName() == "models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back_arcana_refit_1.vmdl" then
                    item:SetOriginalModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back.vmdl")
                    item:SetModel("models/items/phantom_assassin/lunar_dragon_pa/lunar_dragon_pa_back.vmdl")
                end
            end
        end
    end
end