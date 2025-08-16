modifier_magus_accord_custom = class({})
function modifier_magus_accord_custom:IsHidden() return true end
function modifier_magus_accord_custom:IsPurgable() return false end
function modifier_magus_accord_custom:IsPurgeException() return false end
function modifier_magus_accord_custom:RemoveOnDeath() return false end