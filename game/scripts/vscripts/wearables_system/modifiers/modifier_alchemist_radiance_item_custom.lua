modifier_alchemist_radiance_item_custom = class({})
function modifier_alchemist_radiance_item_custom:IsHidden() return true end
function modifier_alchemist_radiance_item_custom:IsPurgable() return false end
function modifier_alchemist_radiance_item_custom:IsPurgeException() return false end
function modifier_alchemist_radiance_item_custom:RemoveOnDeath() return false end