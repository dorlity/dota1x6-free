modifier_ogre_magi_immortal_back_custom_arcana = class({})
function modifier_ogre_magi_immortal_back_custom_arcana:IsHidden() return true end
function modifier_ogre_magi_immortal_back_custom_arcana:IsPurgable() return false end
function modifier_ogre_magi_immortal_back_custom_arcana:IsPurgeException() return false end
function modifier_ogre_magi_immortal_back_custom_arcana:RemoveOnDeath() return false end
function modifier_ogre_magi_immortal_back_custom_arcana:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_ogre_magi_immortal_back_custom_arcana:GetActivityTranslationModifiers()
    return "auspice"
end