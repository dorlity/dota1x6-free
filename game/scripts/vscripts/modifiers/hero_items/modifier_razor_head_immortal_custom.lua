modifier_razor_head_immortal_custom = class({})
function modifier_razor_head_immortal_custom:IsHidden() return true end
function modifier_razor_head_immortal_custom:IsPurgable() return false end
function modifier_razor_head_immortal_custom:IsPurgeException() return false end
function modifier_razor_head_immortal_custom:RemoveOnDeath() return false end