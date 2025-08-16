modifier_skywrath_mage_fligh_immortal = class({})
function modifier_skywrath_mage_fligh_immortal:IsHidden() return true end
function modifier_skywrath_mage_fligh_immortal:IsPurgable() return false end
function modifier_skywrath_mage_fligh_immortal:IsPurgeException() return false end
function modifier_skywrath_mage_fligh_immortal:RemoveOnDeath() return false end

function modifier_skywrath_mage_fligh_immortal:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_skywrath_mage_fligh_immortal:GetActivityTranslationModifiers()
    return "ti9"
end