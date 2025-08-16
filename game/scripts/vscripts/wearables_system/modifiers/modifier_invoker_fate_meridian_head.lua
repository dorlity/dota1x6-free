modifier_invoker_fate_meridian_head = class({})
function modifier_invoker_fate_meridian_head:IsHidden() return true end
function modifier_invoker_fate_meridian_head:IsPurgable() return false end
function modifier_invoker_fate_meridian_head:IsPurgeException() return false end
function modifier_invoker_fate_meridian_head:RemoveOnDeath() return false end
function modifier_invoker_fate_meridian_head:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_invoker_fate_meridian_head:GetActivityTranslationModifiers()
    return "ti8"
end