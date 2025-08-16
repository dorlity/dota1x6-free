LinkLuaModifier("modifier_donate_hero_illusion_item", "wearables_system/modifiers/modifier_hero_donate_illusion", LUA_MODIFIER_MOTION_NONE)

modifier_pudge_hook_ti10_claws_custom = class({})
function modifier_pudge_hook_ti10_claws_custom:IsHidden() return true end
function modifier_pudge_hook_ti10_claws_custom:IsPurgable() return false end
function modifier_pudge_hook_ti10_claws_custom:IsPurgeException() return false end
function modifier_pudge_hook_ti10_claws_custom:RemoveOnDeath() return false end
function modifier_pudge_hook_ti10_claws_custom:OnCreated()
    if not IsServer() then return end
    self.hand = wearables_system:CreateWearable(self:GetParent(), "models/items/pudge/ti10_immortal_armhook/pudge_ti10_immortal_arm_bracer_model.vmdl")
end
function modifier_pudge_hook_ti10_claws_custom:OnDestroy()
    if not IsServer() then return end
    if self.hand and not self.hand:IsNull() then
        self.hand:AddEffects(EF_NODRAW)
        self.hand:Destroy()
    end
end