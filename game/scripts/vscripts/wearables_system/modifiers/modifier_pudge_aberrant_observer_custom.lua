modifier_pudge_aberrant_observer_custom = class({})
function modifier_pudge_aberrant_observer_custom:IsHidden() return true end
function modifier_pudge_aberrant_observer_custom:IsPurgable() return false end
function modifier_pudge_aberrant_observer_custom:IsPurgeException() return false end
function modifier_pudge_aberrant_observer_custom:RemoveOnDeath() return false end
function modifier_pudge_aberrant_observer_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end

function modifier_pudge_aberrant_observer_custom:GetActivityTranslationModifiers()
    return "aberrant_observer"
end