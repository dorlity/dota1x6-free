LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_pudge_harpoon_hook_custom = class({})
function modifier_pudge_harpoon_hook_custom:IsHidden() return true end
function modifier_pudge_harpoon_hook_custom:IsPurgable() return false end
function modifier_pudge_harpoon_hook_custom:IsPurgeException() return false end
function modifier_pudge_harpoon_hook_custom:RemoveOnDeath() return false end
function modifier_pudge_harpoon_hook_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_pudge_harpoon_hook_custom:GetActivityTranslationModifiers()
    return "harpoon"
end
function modifier_pudge_harpoon_hook_custom:OnCreated()
    if not IsServer() then return end
=
end
function modifier_pudge_harpoon_hook_custom:OnDestroy()
    if not IsServer() then return end
    if self.hand and not self.hand:IsNull() then
        self.hand:AddEffects(EF_NODRAW)
        self.hand:Destroy()
    end
end