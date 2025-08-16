modifier_crystal_maiden_ti9_immortal_weapon_custom = class({})
function modifier_crystal_maiden_ti9_immortal_weapon_custom:IsHidden() return true end
function modifier_crystal_maiden_ti9_immortal_weapon_custom:IsPurgable() return false end
function modifier_crystal_maiden_ti9_immortal_weapon_custom:IsPurgeException() return false end
function modifier_crystal_maiden_ti9_immortal_weapon_custom:RemoveOnDeath() return false end
function modifier_crystal_maiden_ti9_immortal_weapon_custom:DecalreFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_crystal_maiden_ti9_immortal_weapon_custom:GetActivityTranslationModifiers()
    return "ti9"
end