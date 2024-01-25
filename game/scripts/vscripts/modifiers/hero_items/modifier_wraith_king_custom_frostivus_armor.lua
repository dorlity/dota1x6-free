modifier_wraith_king_custom_frostivus_armor = class({})
function modifier_wraith_king_custom_frostivus_armor:IsHidden() return true end
function modifier_wraith_king_custom_frostivus_armor:IsPurgable() return false end
function modifier_wraith_king_custom_frostivus_armor:IsPurgeException() return false end
function modifier_wraith_king_custom_frostivus_armor:RemoveOnDeath() return false end
function modifier_wraith_king_custom_frostivus_armor:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_wraith_king_custom_frostivus_armor:GetActivityTranslationModifiers()
    return "frostivus_2023"
end