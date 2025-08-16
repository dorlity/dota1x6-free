modifier_invoker_dark_artistry_cape = class({})
function modifier_invoker_dark_artistry_cape:IsHidden() return true end
function modifier_invoker_dark_artistry_cape:IsPurgable() return false end
function modifier_invoker_dark_artistry_cape:IsPurgeException() return false end
function modifier_invoker_dark_artistry_cape:RemoveOnDeath() return false end
function modifier_invoker_dark_artistry_cape:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_invoker_dark_artistry_cape:GetActivityTranslationModifiers()
    return "ti6"
end