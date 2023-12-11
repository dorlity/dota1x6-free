
modifier_generic_passing = class({})

function modifier_generic_passing:IsHidden() return true end
function modifier_generic_passing:IsPurgable() return true end
function modifier_generic_passing:CheckState()
return
{
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
}

end