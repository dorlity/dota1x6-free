LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_pudge_harpoon_hook_custom_witness = class({})
function modifier_pudge_harpoon_hook_custom_witness:IsHidden() return true end
function modifier_pudge_harpoon_hook_custom_witness:IsPurgable() return false end
function modifier_pudge_harpoon_hook_custom_witness:IsPurgeException() return false end
function modifier_pudge_harpoon_hook_custom_witness:RemoveOnDeath() return false end
function modifier_pudge_harpoon_hook_custom_witness:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_pudge_harpoon_hook_custom_witness:GetActivityTranslationModifiers()
    return "harpoon"
end
function modifier_pudge_harpoon_hook_custom_witness:OnCreated()
    if not IsServer() then return end

end
function modifier_pudge_harpoon_hook_custom_witness:OnDestroy()
    if not IsServer() then return end
    if self.hand and not self.hand:IsNull() then
        self.hand:AddEffects(EF_NODRAW)
        self.hand:Destroy()
    end
end