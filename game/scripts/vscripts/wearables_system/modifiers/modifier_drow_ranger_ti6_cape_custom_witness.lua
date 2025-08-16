modifier_drow_ranger_ti6_cape_custom_witness = class({})
function modifier_drow_ranger_ti6_cape_custom_witness:IsHidden() return true end
function modifier_drow_ranger_ti6_cape_custom_witness:IsPurgable() return false end
function modifier_drow_ranger_ti6_cape_custom_witness:IsPurgeException() return false end
function modifier_drow_ranger_ti6_cape_custom_witness:RemoveOnDeath() return false end
function modifier_drow_ranger_ti6_cape_custom_witness:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_drow_ranger_ti6_cape_custom_witness:GetActivityTranslationModifiers()
    return "ti6"
end