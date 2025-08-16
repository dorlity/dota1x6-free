modifier_drow_eldwurm_activity_custom = class({})
function modifier_drow_eldwurm_activity_custom:IsHidden() return true end
function modifier_drow_eldwurm_activity_custom:IsPurgable() return false end
function modifier_drow_eldwurm_activity_custom:IsPurgeException() return false end
function modifier_drow_eldwurm_activity_custom:RemoveOnDeath() return false end
function modifier_drow_eldwurm_activity_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_drow_eldwurm_activity_custom:GetActivityTranslationModifiers()
    return "eldwurm"
end