LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_pudge_persona_custom = class({})
function modifier_pudge_persona_custom:IsHidden() return true end
function modifier_pudge_persona_custom:IsPurgable() return false end
function modifier_pudge_persona_custom:IsPurgeException() return false end
function modifier_pudge_persona_custom:RemoveOnDeath() return false end

function modifier_pudge_persona_custom:OnCreated()
    if not IsServer() then return end
    local items = 
    {
        "models/heroes/pudge_cute/pudge_cute_offhand.vmdl",
        "models/heroes/pudge_cute/pudge_cute_hair.vmdl",
        "models/heroes/pudge_cute/pudge_cute_costume.vmdl",
        "models/heroes/pudge_cute/pudge_cute_arms.vmdl",
        "models/heroes/pudge_cute/pudge_cute_weapon.vmdl",
    }
    self.items = {}
    for _, item_model in pairs(items) do
        local item = wearables_system:CreateWearable(self:GetParent(), item_model)
        table.insert(self.items, item)
    end
    local modifier_hero_donate_hex_checking = self:GetParent():FindModifierByName("modifier_hero_donate_hex_checking")
    if modifier_hero_donate_hex_checking then
        modifier_hero_donate_hex_checking:UpdatePlayerItems()
    end
end
function modifier_pudge_persona_custom:OnDestroy()
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
function modifier_pudge_persona_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end
function modifier_pudge_persona_custom:GetActivityTranslationModifiers()
    return "persona"
end
function modifier_pudge_persona_custom:GetAttackSound()
    return "Hero_Pudge.Attack.Persona"
end