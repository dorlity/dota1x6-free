modifier_antimage_persona_custom_6 = class({})
function modifier_antimage_persona_custom_6:IsHidden() return true end
function modifier_antimage_persona_custom_6:IsPurgable() return false end
function modifier_antimage_persona_custom_6:IsPurgeException() return false end
function modifier_antimage_persona_custom_6:RemoveOnDeath() return false end

function modifier_antimage_persona_custom_6:OnCreated()
    if not IsServer() then return end
    self.original_size = self:GetParent():GetModelScale()
    self.item_scale = 1.12
    self:GetParent():SetModelScale(self.item_scale)
    local items = 
    {
        "models/items/antimage_female/jewels_of_the_spellbreaker_head/jewels_of_the_spellbreaker_head.vmdl",
        "models/items/antimage_female/jewels_of_the_spellbreaker_armor/jewels_of_the_spellbreaker_armor.vmdl",
        "models/items/antimage_female/jewels_of_the_spellbreaker_weapon/jewels_of_the_spellbreaker_weapon.vmdl",
        "models/items/antimage_female/jewels_of_the_spellbreaker_offhand/jewels_of_the_spellbreaker_offhand.vmdl",
    }
    self.items = {}
    for _, item_model in pairs(items) do
        local item = wearables_system:CreateWearable(self:GetParent(), item_model)
        table.insert(self.items, item)
        if item then
            if item_model == "models/items/antimage_female/jewels_of_the_spellbreaker_head/jewels_of_the_spellbreaker_head.vmdl" then
                local particle = ParticleManager:CreateParticle("particles/econ/items/antimage_female/jewels_spellbreaker/jewels_spellbreaker_head_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
                self:AddParticle(particle, false, false, -1, false, false)
            end
            if item_model == "models/items/antimage_female/jewels_of_the_spellbreaker_weapon/jewels_of_the_spellbreaker_weapon.vmdl" then
                local particle = ParticleManager:CreateParticle("particles/econ/items/antimage_female/jewels_spellbreaker/jewels_spellbreaker_weapon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
                self:AddParticle(particle, false, false, -1, false, false)
            end
            if item_model == "models/items/antimage_female/jewels_of_the_spellbreaker_offhand/jewels_of_the_spellbreaker_offhand.vmdl" then
                local particle = ParticleManager:CreateParticle("particles/econ/items/antimage_female/jewels_spellbreaker/jewels_spellbreaker_offhand_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
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

function modifier_antimage_persona_custom_6:OnIntervalThink()
    if not IsServer() then return end
    if self:GetParent():GetModelScale() > self.item_scale then
        self:GetParent():SetModelScale(self.item_scale)
    end
end

function modifier_antimage_persona_custom_6:OnDestroy()
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

function modifier_antimage_persona_custom_6:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end

function modifier_antimage_persona_custom_6:GetAttackSound()
    return "Hero_Antimage.Attack.Persona"
end