LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_pudge_hook_ti10_claws_custom_green = class({})
function modifier_pudge_hook_ti10_claws_custom_green:IsHidden() return true end
function modifier_pudge_hook_ti10_claws_custom_green:IsPurgable() return false end
function modifier_pudge_hook_ti10_claws_custom_green:IsPurgeException() return false end
function modifier_pudge_hook_ti10_claws_custom_green:RemoveOnDeath() return false end
function modifier_pudge_hook_ti10_claws_custom_green:OnCreated()
    if not IsServer() then return end
    self.hand = wearables_system:CreateWearable(self:GetParent(), "models/items/pudge/ti10_immortal_armhook/pudge_ti10_immortal_arm_bracer_model.vmdl")
    self.hand:SetMaterialGroup("pudge_ti10_immortal_arcana_alt_style")
end
function modifier_pudge_hook_ti10_claws_custom_green:OnDestroy()
    if not IsServer() then return end
    if self.hand and not self.hand:IsNull() then
        self.hand:AddEffects(EF_NODRAW)
        self.hand:Destroy()
    end
end