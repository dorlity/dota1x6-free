modifier_dragonclaw_hook_custom = class({})
function modifier_dragonclaw_hook_custom:IsHidden() return true end
function modifier_dragonclaw_hook_custom:IsPurgable() return false end
function modifier_dragonclaw_hook_custom:IsPurgeException() return false end
function modifier_dragonclaw_hook_custom:RemoveOnDeath() return false end