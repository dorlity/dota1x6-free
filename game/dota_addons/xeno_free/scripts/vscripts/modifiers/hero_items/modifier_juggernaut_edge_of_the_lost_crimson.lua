modifier_juggernaut_edge_of_the_lost_crimson = class({})
function modifier_juggernaut_edge_of_the_lost_crimson:IsHidden() return true end
function modifier_juggernaut_edge_of_the_lost_crimson:IsPurgable() return false end
function modifier_juggernaut_edge_of_the_lost_crimson:IsPurgeException() return false end
function modifier_juggernaut_edge_of_the_lost_crimson:RemoveOnDeath() return false end
function modifier_juggernaut_edge_of_the_lost_crimson:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_juggernaut_edge_of_the_lost_crimson:GetActivityTranslationModifiers()
    return "ti8"
end