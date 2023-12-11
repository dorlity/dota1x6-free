modifier_legion_commander_radiant_conquerror_custom = class({})
function modifier_legion_commander_radiant_conquerror_custom:IsHidden() return true end
function modifier_legion_commander_radiant_conquerror_custom:IsPurgable() return false end
function modifier_legion_commander_radiant_conquerror_custom:IsPurgeException() return false end
function modifier_legion_commander_radiant_conquerror_custom:RemoveOnDeath() return false end
function modifier_legion_commander_radiant_conquerror_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_legion_commander_radiant_conquerror_custom:GetActivityTranslationModifiers()
    return "fallen_legion"
end