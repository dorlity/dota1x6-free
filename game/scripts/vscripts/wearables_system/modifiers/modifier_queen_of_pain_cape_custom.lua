modifier_queen_of_pain_cape_custom = class({})
function modifier_queen_of_pain_cape_custom:IsHidden() return true end
function modifier_queen_of_pain_cape_custom:IsPurgable() return false end
function modifier_queen_of_pain_cape_custom:IsPurgeException() return false end
function modifier_queen_of_pain_cape_custom:RemoveOnDeath() return false end

function modifier_queen_of_pain_cape_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
end

function modifier_queen_of_pain_cape_custom:GetActivityTranslationModifiers()
    return "qop_2022"
end

function modifier_queen_of_pain_cape_custom:GetOverrideAnimation()
    return ACT_DOTA_IDLE
end