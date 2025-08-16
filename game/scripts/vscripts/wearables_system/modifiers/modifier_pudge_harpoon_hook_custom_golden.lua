LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_pudge_harpoon_hook_custom_golden = class({})
function modifier_pudge_harpoon_hook_custom_golden:IsHidden() return true end
function modifier_pudge_harpoon_hook_custom_golden:IsPurgable() return false end
function modifier_pudge_harpoon_hook_custom_golden:IsPurgeException() return false end
function modifier_pudge_harpoon_hook_custom_golden:RemoveOnDeath() return false end
function modifier_pudge_harpoon_hook_custom_golden:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_pudge_harpoon_hook_custom_golden:GetActivityTranslationModifiers()
    return "harpoon"
end
function modifier_pudge_harpoon_hook_custom_golden:OnCreated()
    if not IsServer() then return end

end
function modifier_pudge_harpoon_hook_custom_golden:OnDestroy()
    if not IsServer() then return end
    if self.hand and not self.hand:IsNull() then
        self.hand:AddEffects(EF_NODRAW)
        self.hand:Destroy()
    end
end