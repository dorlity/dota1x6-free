modifier_juggernaut_bladekeeper_weapon = class({})
function modifier_juggernaut_bladekeeper_weapon:IsHidden() return true end
function modifier_juggernaut_bladekeeper_weapon:IsPurgable() return false end
function modifier_juggernaut_bladekeeper_weapon:IsPurgeException() return false end
function modifier_juggernaut_bladekeeper_weapon:RemoveOnDeath() return false end