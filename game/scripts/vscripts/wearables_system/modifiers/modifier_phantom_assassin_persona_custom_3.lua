LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_phantom_assassin_persona_custom_3 = class({})
function modifier_phantom_assassin_persona_custom_3:IsHidden() return true end
function modifier_phantom_assassin_persona_custom_3:IsPurgable() return false end
function modifier_phantom_assassin_persona_custom_3:IsPurgeException() return false end
function modifier_phantom_assassin_persona_custom_3:RemoveOnDeath() return false end

function modifier_phantom_assassin_persona_custom_3:OnCreated()
    if not IsServer() then return end
    self.original_size = self:GetParent():GetModelScale()
    self.item_scale = 0.950000
    local items = 
    {
        "models/items/phantom_assassin/2023panther_shadow_armor/2023panther_shadow_armor.vmdl",
        "models/items/phantom_assassin/2023panther_shadow_hair/2023panther_shadow_hair.vmdl",
        "models/items/phantom_assassin/2023panther_shadow_belt/2023panther_shadow_belt.vmdl",
        "models/items/phantom_assassin/2023panther_shadow_weapon/2023panther_shadow_weapon.vmdl",
    }
    self.items = {}
    for _, item_model in pairs(items) do
        local item = wearables_system:CreateWearable(self:GetParent(), item_model)
        if item_model == "models/items/phantom_assassin/2023panther_shadow_weapon/2023panther_shadow_weapon.vmdl" then
            local particle = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin_persona/panther_shadow/panther_shadow_weapon_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
            ParticleManager:SetParticleControlEnt( particle, 1, item, PATTACH_POINT_FOLLOW, "attach_blade", item:GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( particle, 3, item, PATTACH_POINT_FOLLOW, "attach_blade_bot", item:GetAbsOrigin(), true )
        elseif item_model == "models/items/phantom_assassin/2023panther_shadow_belt/2023panther_shadow_belt.vmdl" then
            local particle = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin_persona/panther_shadow/panther_shadow_belt_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, item)
            ParticleManager:SetParticleControlEnt( particle, 1, item, PATTACH_POINT_FOLLOW, "attach_buckle", item:GetAbsOrigin(), true )
        end
        table.insert(self.items, item)
    end
    local modifier_hero_donate_hex_checking = self:GetParent():FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end

function modifier_phantom_assassin_persona_custom_3:OnIntervalThink()
    if not IsServer() then return end
    if self:GetParent():GetModelScale() ~= self.item_scale then
        self:GetParent():SetModelScale(self.item_scale)
    end
end

function modifier_phantom_assassin_persona_custom_3:OnDestroy()
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

function modifier_phantom_assassin_persona_custom_3:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end

function modifier_phantom_assassin_persona_custom_3:GetAttackSound()
    return "Hero_PhantomAssassin.Attack.Persona"
end