modifier_blood_chaser_axe_custom = class({})
function modifier_blood_chaser_axe_custom:IsHidden() return true end
function modifier_blood_chaser_axe_custom:IsPurgable() return false end
function modifier_blood_chaser_axe_custom:IsPurgeException() return false end
function modifier_blood_chaser_axe_custom:RemoveOnDeath() return false end
function modifier_blood_chaser_axe_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end

function modifier_blood_chaser_axe_custom:GetActivityTranslationModifiers()
    return "blood_chaser"
end