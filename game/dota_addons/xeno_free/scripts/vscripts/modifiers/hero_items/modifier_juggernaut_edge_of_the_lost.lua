modifier_juggernaut_edge_of_the_lost = class({})
function modifier_juggernaut_edge_of_the_lost:IsHidden() return true end
function modifier_juggernaut_edge_of_the_lost:IsPurgable() return false end
function modifier_juggernaut_edge_of_the_lost:IsPurgeException() return false end
function modifier_juggernaut_edge_of_the_lost:RemoveOnDeath() return false end
function modifier_juggernaut_edge_of_the_lost:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_juggernaut_edge_of_the_lost:GetActivityTranslationModifiers()
    return "ti8"
end