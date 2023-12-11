

modifier_start_stun = class({})


function modifier_start_stun:IsHidden() return false end
function modifier_start_stun:IsPurgable() return false end
function modifier_start_stun:RemoveOnDeath() return false end
function modifier_start_stun:CheckState()
return
{
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_INVULNERABLE] = true
}
end
