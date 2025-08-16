modifier_pudge_whale_hook_custom = class({})
function modifier_pudge_whale_hook_custom:IsHidden() return true end
function modifier_pudge_whale_hook_custom:IsPurgable() return false end
function modifier_pudge_whale_hook_custom:IsPurgeException() return false end
function modifier_pudge_whale_hook_custom:RemoveOnDeath() return false end
function modifier_pudge_whale_hook_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_pudge_whale_hook_custom:GetActivityTranslationModifiers()
    return "whalehook"
end