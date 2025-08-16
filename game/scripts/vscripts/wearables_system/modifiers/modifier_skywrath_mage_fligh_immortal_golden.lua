modifier_skywrath_mage_fligh_immortal_golden = class({})
function modifier_skywrath_mage_fligh_immortal_golden:IsHidden() return true end
function modifier_skywrath_mage_fligh_immortal_golden:IsPurgable() return false end
function modifier_skywrath_mage_fligh_immortal_golden:IsPurgeException() return false end
function modifier_skywrath_mage_fligh_immortal_golden:RemoveOnDeath() return false end

function modifier_skywrath_mage_fligh_immortal_golden:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_skywrath_mage_fligh_immortal_golden:GetActivityTranslationModifiers()
    return "ti9"
end