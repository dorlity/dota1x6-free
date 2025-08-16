LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_phantom_assassin_persona_custom_2 = class({})
function modifier_phantom_assassin_persona_custom_2:IsHidden() return true end
function modifier_phantom_assassin_persona_custom_2:IsPurgable() return false end
function modifier_phantom_assassin_persona_custom_2:IsPurgeException() return false end
function modifier_phantom_assassin_persona_custom_2:RemoveOnDeath() return false end

function modifier_phantom_assassin_persona_custom_2:OnCreated()
    if not IsServer() then return end
    self.original_size = self:GetParent():GetModelScale()
    self.item_scale = 0.950000
    local items = 
    {
        "models/items/phantom_assassin/head_dark_carnival/head_dark_carnival.vmdl",
        "models/items/phantom_assassin/armor_dark_carnival/armor_dark_carnival.vmdl",
        "models/items/phantom_assassin/legs_dark_carnival/legs_dark_carnival.vmdl",
        "models/items/phantom_assassin/weapon_dark_carnival/weapon_dark_carnival.vmdl",
    }
    self.items = {}
    for _, item_model in pairs(items) do
        local item = wearables_system:CreateWearable(self:GetParent(), item_model)
        if item_model == "models/items/phantom_assassin/head_dark_carnival/head_dark_carnival.vmdl" then
            local particle = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin_persona/dark_carnival/dark_carnival_head_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
            ParticleManager:SetParticleControlEnt( particle, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l", self:GetParent():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( particle, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r", self:GetParent():GetAbsOrigin(), true )
        elseif item_model == "models/items/phantom_assassin/legs_dark_carnival/legs_dark_carnival.vmdl" then
            local particle = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin_persona/dark_carnival/dark_carnival_legs_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
            ParticleManager:SetParticleControlEnt( particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_skirt", self:GetParent():GetAbsOrigin(), true )
        end
        table.insert(self.items, item)
    end
    local modifier_hero_donate_hex_checking = self:GetParent():FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end

function modifier_phantom_assassin_persona_custom_2:OnIntervalThink()
    if not IsServer() then return end
    if self:GetParent():GetModelScale() ~= self.item_scale then
        self:GetParent():SetModelScale(self.item_scale)
    end
end

function modifier_phantom_assassin_persona_custom_2:OnDestroy()
    if not IsServer() then return end
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

function modifier_phantom_assassin_persona_custom_2:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end

function modifier_phantom_assassin_persona_custom_2:GetAttackSound()
    return "Hero_PhantomAssassin.Attack.Persona"
end