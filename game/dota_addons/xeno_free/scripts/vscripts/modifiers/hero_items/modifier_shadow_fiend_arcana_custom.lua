modifier_shadow_fiend_arcana_custom = class({})
function modifier_shadow_fiend_arcana_custom:IsHidden() return true end
function modifier_shadow_fiend_arcana_custom:IsPurgable() return false end
function modifier_shadow_fiend_arcana_custom:IsPurgeException() return false end
function modifier_shadow_fiend_arcana_custom:RemoveOnDeath() return false end
function modifier_shadow_fiend_arcana_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PROJECTILE_NAME,
        MODIFIER_EVENT_ON_DEATH,
    }
end
function modifier_shadow_fiend_arcana_custom:GetActivityTranslationModifiers()
    return "arcana"
end
function modifier_shadow_fiend_arcana_custom:GetModifierProjectileName()
    return "particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_base_attack.vpcf"
end
function modifier_shadow_fiend_arcana_custom:OnDeath(params)
    if not IsServer() then return end
    if params.unit ~= self:GetParent() then return end
    if self:GetParent():IsIllusion() then return end
	local nFXIndex = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), false )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
end

function modifier_shadow_fiend_arcana_custom:OnCreated()
    if not IsServer() then return end
    self.shadow_fiend_changes =
    {
        ["kynomi/models/sf_default_arms/shadow_fiend_arms.vmdl"] = true,
        ["kynomi/models/sf_default_shoulders/shadow_fiend_shoulders.vmdl"] = true,
        ["kynomi/models/sf_souls_tyrant_shoulder/sf_souls_tyrant_shoulder.vmdl"] = true,
        ["kynomi/models/sf_immortal_flame_shoulder/sf_immortal_flame_shoulder.vmdl"] = true,
        ["kynomi/models/sf_immortal_flame_arms/sf_immortal_flame_arms.vmdl"] = true,
        ["kynomi/models/sf_arms_deso/arms_deso.vmdl"] = true,
    }

    if self:GetParent().other_model_backup["arms"] ~= nil and self.shadow_fiend_changes[self:GetParent().other_model_backup["arms"]:GetModelName()] ~= nil then
        self:GetParent().other_model_backup["arms"]:SetMaterialGroup("arcana")
    end
    if self:GetParent().other_model_backup["shoulder"] ~= nil and self.shadow_fiend_changes[self:GetParent().other_model_backup["shoulder"]:GetModelName()] ~= nil then
        self:GetParent().other_model_backup["shoulder"]:SetMaterialGroup("arcana")
    end

    if self:GetParent().items_data_custom["arms"] ~= nil and self.shadow_fiend_changes[self:GetParent().items_data_custom["arms"]:GetModelName()] ~= nil then
        self:GetParent().items_data_custom["arms"]:SetMaterialGroup("arcana")
    end
    if self:GetParent().items_data_custom["shoulder"] ~= nil and self.shadow_fiend_changes[self:GetParent().items_data_custom["shoulder"]:GetModelName()] ~= nil then
        self:GetParent().items_data_custom["shoulder"]:SetMaterialGroup("arcana")
    end
end

function modifier_shadow_fiend_arcana_custom:OnDestroy()
    if not IsServer() then return end
    if self:GetParent().other_model_backup["arms"] ~= nil and self.shadow_fiend_changes[self:GetParent().other_model_backup["arms"]:GetModelName()] ~= nil then
        self:GetParent().other_model_backup["arms"]:SetMaterialGroup("default")
    end
    if self:GetParent().other_model_backup["shoulder"] ~= nil and self.shadow_fiend_changes[self:GetParent().other_model_backup["shoulder"]:GetModelName()] ~= nil then
        self:GetParent().other_model_backup["shoulder"]:SetMaterialGroup("default")
    end
    if self:GetParent().items_data_custom["arms"] ~= nil and self.shadow_fiend_changes[self:GetParent().items_data_custom["arms"]:GetModelName()] ~= nil then
        self:GetParent().items_data_custom["arms"]:SetMaterialGroup("default")
    end
    if self:GetParent().items_data_custom["shoulder"] ~= nil and self.shadow_fiend_changes[self:GetParent().items_data_custom["shoulder"]:GetModelName()] ~= nil then
        self:GetParent().items_data_custom["shoulder"]:SetMaterialGroup("default")
    end
end