
modifier_no_cleave = class({})

function modifier_no_cleave:IsHidden() return true end
function modifier_no_cleave:IsPurgable() return false end
function modifier_no_cleave:RemoveOnDeath() return false end