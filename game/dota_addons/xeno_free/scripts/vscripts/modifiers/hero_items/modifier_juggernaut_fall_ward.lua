modifier_juggernaut_fall_ward = class({})
function modifier_juggernaut_fall_ward:IsHidden() return true end
function modifier_juggernaut_fall_ward:IsPurgable() return false end
function modifier_juggernaut_fall_ward:IsPurgeException() return false end
function modifier_juggernaut_fall_ward:RemoveOnDeath() return false end