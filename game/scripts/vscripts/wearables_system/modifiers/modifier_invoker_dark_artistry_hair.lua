modifier_invoker_dark_artistry_hair = class({})
function modifier_invoker_dark_artistry_hair:IsHidden() return true end
function modifier_invoker_dark_artistry_hair:IsPurgable() return false end
function modifier_invoker_dark_artistry_hair:IsPurgeException() return false end
function modifier_invoker_dark_artistry_hair:RemoveOnDeath() return false end
function modifier_invoker_dark_artistry_hair:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_invoker_dark_artistry_hair:GetActivityTranslationModifiers()
    return "ti6"
end