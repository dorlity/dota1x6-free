modifier_scorching_talon_custom = class({})
function modifier_scorching_talon_custom:IsHidden() return true end
function modifier_scorching_talon_custom:IsPurgable() return false end
function modifier_scorching_talon_custom:IsPurgeException() return false end
function modifier_scorching_talon_custom:RemoveOnDeath() return false end