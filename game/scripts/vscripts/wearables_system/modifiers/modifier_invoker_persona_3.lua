modifier_invoker_persona_3 = class({})
function modifier_invoker_persona_3:IsHidden() return true end
function modifier_invoker_persona_3:IsPurgable() return false end
function modifier_invoker_persona_3:IsPurgeException() return false end
function modifier_invoker_persona_3:RemoveOnDeath() return false end

function modifier_invoker_persona_3:OnCreated()
    if not IsServer() then return end
    self.original_size = self:GetParent():GetModelScale()
    self:GetParent():SetModelScale(1.12)
    local items = 
    {
        "models/items/invoker/invoker_arrow_of_psychokinesis_armor_persona_1/invoker_arrow_of_psychokinesis_armor_persona_1.vmdl", 
        "models/items/invoker/invoker_arrow_of_psychokinesis_arms_persona_1/invoker_arrow_of_psychokinesis_arms_persona_1.vmdl",
        "models/items/invoker/invoker_arrow_of_psychokinesis_head_persona_1/invoker_arrow_of_psychokinesis_head_persona_1.vmdl",
        "models/items/invoker/invoker_arrow_of_psychokinesis_shoulder_persona_1/invoker_arrow_of_psychokinesis_shoulder_persona_1.vmdl",
        "models/items/invoker/invoker_arrow_of_psychokinesis_back_persona_1/invoker_arrow_of_psychokinesis_back_persona_1.vmdl",
    }
    self.items = {}
    for _, item_model in pairs(items) do
        local item = wearables_system:CreateWearable(self:GetParent(), item_model)
        table.insert(self.items, item)
        if item then
            if item_model == "models/items/invoker/invoker_arrow_of_psychokinesis_armor_persona_1/invoker_arrow_of_psychokinesis_armor_persona_1.vmdl" then
                local particle = ParticleManager:CreateParticle("particles/econ/items/invoker_kid/kid_invoker_psychokinesis/invoker_kid_psychokinesis_armor.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
                ParticleManager:SetParticleControlEnt(particle, 1, item, PATTACH_POINT_FOLLOW, "attach_bow", Vector(0,0,0), true)
                ParticleManager:SetParticleControlEnt(particle, 2, item, PATTACH_POINT_FOLLOW, "attach_heart_chest", Vector(0,0,0), true)
                self:AddParticle(particle, false, false, -1, false, false)
            end
            if item_model == "models/items/invoker/invoker_arrow_of_psychokinesis_head_persona_1/invoker_arrow_of_psychokinesis_head_persona_1.vmdl" then
                local particle = ParticleManager:CreateParticle("particles/econ/items/invoker_kid/kid_invoker_psychokinesis/invoker_kid_psychokinesis_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
                ParticleManager:SetParticleControlEnt(particle, 1, item, PATTACH_POINT_FOLLOW, "attach_head", Vector(0,0,0), true)
                self:AddParticle(particle, false, false, -1, false, false)
            end
        end
    end
    local modifier_hero_donate_hex_checking = self:GetParent():FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
    self:StartIntervalThink(0.1)
end

function modifier_invoker_persona_3:OnIntervalThink()
    if not IsServer() then return end
    local exort_count = self:GetParent():FindAllModifiersByName("modifier_invoker_exort_custom")
    local wex_count = self:GetParent():FindAllModifiersByName("modifier_invoker_wex_custom")
    local quas_count = self:GetParent():FindAllModifiersByName("modifier_invoker_quas_custom")
    if (#quas_count > #wex_count) and (#quas_count > #exort_count) then
        self:SetStackCount(3)
    elseif (#wex_count > #quas_count) and (#wex_count > #exort_count) then
        self:SetStackCount(2)
    elseif (#exort_count > #quas_count) and (#exort_count > #wex_count) then
        self:SetStackCount(1)
    else
        self:SetStackCount(0)
    end
end

function modifier_invoker_persona_3:OnDestroy()
    if not IsServer() then return end
    self:GetParent():SetModelScale(self.original_size)
    for _, item in pairs(self.items) do
        if item and not item:IsNull() then
            item:AddEffects(EF_NODRAW)
            item:Destroy()
        end
    end
    local modifier_hero_donate_hex_checking = self:GetParent():FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end

function modifier_invoker_persona_3:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function modifier_invoker_persona_3:GetModifierProjectileName()
    if self:GetStackCount() == 3 then
        return "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_quas.vpcf"
    elseif self:GetStackCount() == 2 then
        return "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_wex.vpcf"
    elseif self:GetStackCount() == 1 then
        return "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_exort.vpcf"
    else
        return "particles/units/heroes/hero_invoker_kid/invoker_kid_base_attack_all.vpcf"
    end
end

function modifier_invoker_persona_3:GetActivityTranslationModifiers()
    return "persona"
end