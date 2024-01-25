modifier_juggernaut_edge_of_the_lost_gold = class({})
function modifier_juggernaut_edge_of_the_lost_gold:IsHidden() return true end
function modifier_juggernaut_edge_of_the_lost_gold:IsPurgable() return false end
function modifier_juggernaut_edge_of_the_lost_gold:IsPurgeException() return false end
function modifier_juggernaut_edge_of_the_lost_gold:RemoveOnDeath() return false end
function modifier_juggernaut_edge_of_the_lost_gold:DeclareFunctions()
    return
    {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    }
end

function modifier_juggernaut_edge_of_the_lost_gold:GetActivityTranslationModifiers()
    return "ti8"
end