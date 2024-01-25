modifier_legion_commander_ti7_head_custom = class({})
function modifier_legion_commander_ti7_head_custom:IsHidden() return true end
function modifier_legion_commander_ti7_head_custom:IsPurgable() return false end
function modifier_legion_commander_ti7_head_custom:IsPurgeException() return false end
function modifier_legion_commander_ti7_head_custom:RemoveOnDeath() return false end
function modifier_legion_commander_ti7_head_custom:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end
function modifier_legion_commander_ti7_head_custom:GetActivityTranslationModifiers()
    return "ti7"
end