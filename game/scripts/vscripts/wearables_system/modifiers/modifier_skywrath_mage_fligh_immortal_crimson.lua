modifier_skywrath_mage_fligh_immortal_crimson = class({})
function modifier_skywrath_mage_fligh_immortal_crimson:IsHidden() return true end
function modifier_skywrath_mage_fligh_immortal_crimson:IsPurgable() return false end
function modifier_skywrath_mage_fligh_immortal_crimson:IsPurgeException() return false end
function modifier_skywrath_mage_fligh_immortal_crimson:RemoveOnDeath() return false end

function modifier_skywrath_mage_fligh_immortal_crimson:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_skywrath_mage_fligh_immortal_crimson:GetActivityTranslationModifiers()
    return "ti9"
end