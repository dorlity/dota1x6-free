modifier_antimage_persona_custom_2 = class({})
function modifier_antimage_persona_custom_2:IsHidden() return true end
function modifier_antimage_persona_custom_2:IsPurgable() return false end
function modifier_antimage_persona_custom_2:IsPurgeException() return false end
function modifier_antimage_persona_custom_2:RemoveOnDeath() return false end

function modifier_antimage_persona_custom_2:OnCreated()
    if not IsServer() then return end
    self.original_size = self:GetParent():GetModelScale()
    self.item_scale = 1.12
    self:GetParent():SetModelScale(self.item_scale)
    local items = 
    {
        "models/items/antimage_female/anti_mage_nemesis_slayer_offhand_weapon_persona_1/anti_mage_nemesis_slayer_offhand_weapon_persona_1.vmdl",
        "models/items/antimage_female/anti_mage_nemesis_slayer_armor_persona_1/anti_mage_nemesis_slayer_armor_persona_1.vmdl",
        "models/items/antimage_female/anti_mage_nemesis_slayer_head_persona_1/anti_mage_nemesis_slayer_head_persona_1.vmdl",
        "models/items/antimage_female/anti_mage_nemesis_slayer_weapon_persona_1/anti_mage_nemesis_slayer_weapon_persona_1.vmdl",
    }
    self.items = {}
    for _, item_model in pairs(items) do
        local item = nil
        local item = wearables_system:CreateWearable(self:GetParent(), item_model)
        table.insert(self.items, item)
        if item then
            if item_model == "models/items/antimage_female/anti_mage_nemesis_slayer_offhand_weapon_persona_1/anti_mage_nemesis_slayer_offhand_weapon_persona_1.vmdl" then
                local particle = ParticleManager:CreateParticle("particles/econ/items/antimage_female/nemesis_slayer/nemesis_weapon_l_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
                self:AddParticle(particle, false, false, -1, false, false)
            end
            if item_model == "models/items/antimage_female/anti_mage_nemesis_slayer_weapon_persona_1/anti_mage_nemesis_slayer_weapon_persona_1.vmdl" then
                local particle = ParticleManager:CreateParticle("particles/econ/items/antimage_female/nemesis_slayer/nemesis_weapon_r_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
                self:AddParticle(particle, false, false, -1, false, false)
            end
            if item_model == "models/items/antimage_female/anti_mage_nemesis_slayer_armor_persona_1/anti_mage_nemesis_slayer_armor_persona_1.vmdl" then
                local particle = ParticleManager:CreateParticle("particles/econ/items/antimage_female/nemesis_slayer/nemesis_armor_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
                ParticleManager:SetParticleControlEnt( particle, 0, item, PATTACH_POINT_FOLLOW, "attach_eye_l", item:GetAbsOrigin(), true )
                ParticleManager:SetParticleControlEnt( particle, 1, item, PATTACH_POINT_FOLLOW, "attach_eye_r", item:GetAbsOrigin(), true )
                ParticleManager:SetParticleControlEnt( particle, 2, item, PATTACH_POINT_FOLLOW, "attach_waist", item:GetAbsOrigin(), true )
                self:AddParticle(particle, false, false, -1, false, false)
            end
            if item_model == "models/items/antimage_female/anti_mage_nemesis_slayer_head_persona_1/anti_mage_nemesis_slayer_head_persona_1.vmdl" then
                local particle = ParticleManager:CreateParticle("particles/econ/items/antimage_female/nemesis_slayer/nemesis_head_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
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

function modifier_antimage_persona_custom_2:OnIntervalThink()
    if not IsServer() then return end
    if self:GetParent():GetModelScale() > self.item_scale then
        self:GetParent():SetModelScale(self.item_scale)
    end
end

function modifier_antimage_persona_custom_2:OnDestroy()
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

function modifier_antimage_persona_custom_2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end

function modifier_antimage_persona_custom_2:GetAttackSound()
    return "Hero_Antimage.Attack.Persona"
end