LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_pudge_persona_custom_1 = class({})
function modifier_pudge_persona_custom_1:IsHidden() return true end
function modifier_pudge_persona_custom_1:IsPurgable() return false end
function modifier_pudge_persona_custom_1:IsPurgeException() return false end
function modifier_pudge_persona_custom_1:RemoveOnDeath() return false end

function modifier_pudge_persona_custom_1:OnCreated()
    if not IsServer() then return end
    local items = 
    {
        "models/items/pudge_cute/pudge_cute_calavera/pudge_cute_calavera_offhand.vmdl",
        "models/items/pudge_cute/pudge_cute_calavera/pudge_cute_calavera_hair.vmdl",
        "models/items/pudge_cute/pudge_cute_calavera/pudge_cute_calavera_arms.vmdl",
        "models/items/pudge_cute/pudge_cute_calavera/pudge_cute_calavera_costume.vmdl",
        "models/items/pudge_cute/pudge_cute_calavera/pudge_cute_calavera_weapon.vmdl",
        "models/items/pudge_cute/pudge_cute_calavera/pudge_cute_calavera_handle.vmdl",
    }
    self.items = {}
    self:GetParent():SetMaterialGroup("1")
    for _, item_model in pairs(items) do
        local item = wearables_system:CreateWearable(self:GetParent(), item_model)
        table.insert(self.items, item)
    end
    local modifier_hero_donate_hex_checking = self:GetParent():FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end
function modifier_pudge_persona_custom_1:OnDestroy()
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
function modifier_pudge_persona_custom_1:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end
function modifier_pudge_persona_custom_1:GetActivityTranslationModifiers()
    return "persona"
end
function modifier_pudge_persona_custom_1:GetAttackSound()
    return "Hero_Pudge.Attack.Persona"
end