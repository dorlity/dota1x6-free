modifier_huskar_shoulder_immortal = class({})
function modifier_huskar_shoulder_immortal:IsHidden() return true end
function modifier_huskar_shoulder_immortal:IsPurgable() return false end
function modifier_huskar_shoulder_immortal:IsPurgeException() return false end
function modifier_huskar_shoulder_immortal:RemoveOnDeath() return false end