modifier_juggernaut_arcana = class({})
function modifier_juggernaut_arcana:IsHidden() return true end
function modifier_juggernaut_arcana:IsPurgable() return false end
function modifier_juggernaut_arcana:IsPurgeException() return false end
function modifier_juggernaut_arcana:RemoveOnDeath() return false end