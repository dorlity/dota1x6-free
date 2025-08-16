modifier_drow_ranger_ti6_cape_custom = class({})
function modifier_drow_ranger_ti6_cape_custom:IsHidden() return true end
function modifier_drow_ranger_ti6_cape_custom:IsPurgable() return false end
function modifier_drow_ranger_ti6_cape_custom:IsPurgeException() return false end
function modifier_drow_ranger_ti6_cape_custom:RemoveOnDeath() return false end
function modifier_drow_ranger_ti6_cape_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_drow_ranger_ti6_cape_custom:GetActivityTranslationModifiers()
    return "ti6"
end