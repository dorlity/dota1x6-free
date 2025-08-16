modifier_ls_ti10_custom = class({})
function modifier_ls_ti10_custom:IsHidden() return true end
function modifier_ls_ti10_custom:IsPurgable() return false end
function modifier_ls_ti10_custom:IsPurgeException() return false end
function modifier_ls_ti10_custom:RemoveOnDeath() return false end
function modifier_ls_ti10_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_ls_ti10_custom:GetActivityTranslationModifiers()
    return "ti10_head"
end