modifier_juggernaut_bladeform = class({})
function modifier_juggernaut_bladeform:IsHidden() return true end
function modifier_juggernaut_bladeform:IsPurgable() return false end
function modifier_juggernaut_bladeform:IsPurgeException() return false end
function modifier_juggernaut_bladeform:RemoveOnDeath() return false end
function modifier_juggernaut_bladeform:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_juggernaut_bladeform:GetActivityTranslationModifiers()
    return "favor"
end