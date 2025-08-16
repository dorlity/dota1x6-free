modifier_wraith_king_bloodshard_custom = class({})
function modifier_wraith_king_bloodshard_custom:IsHidden() return true end
function modifier_wraith_king_bloodshard_custom:IsPurgable() return false end
function modifier_wraith_king_bloodshard_custom:IsPurgeException() return false end
function modifier_wraith_king_bloodshard_custom:RemoveOnDeath() return false end
function modifier_wraith_king_bloodshard_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
    }
end
function modifier_wraith_king_bloodshard_custom:GetActivityTranslationModifiers()
    return "wraith_spin"
end