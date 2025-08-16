modifier_ogre_magi_immortal_weapon_custom = class({})

function modifier_ogre_magi_immortal_weapon_custom:IsHidden() return true end
function modifier_ogre_magi_immortal_weapon_custom:IsPurgable() return false end
function modifier_ogre_magi_immortal_weapon_custom:IsPurgeException() return false end
function modifier_ogre_magi_immortal_weapon_custom:RemoveOnDeath() return false end
function modifier_ogre_magi_immortal_weapon_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    }
end

function modifier_ogre_magi_immortal_weapon_custom:GetActivityTranslationModifiers()
    return "ti8"
end

function modifier_ogre_magi_immortal_weapon_custom:GetAttackSound()
    return "Hero_OgreMagi.Attack.TI8"
end