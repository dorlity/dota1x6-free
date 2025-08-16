
modifier_generic_leash = class({})

function modifier_generic_leash:IsHidden() return true end
function modifier_generic_leash:IsPurgable() return self:GetStackCount() == 0 end
function modifier_generic_leash:OnCreated(table)
if not IsServer() then return end

if table.no_dispel then
	self:SetStackCount(1)
end

end

function modifier_generic_leash:CheckState()
return
{
	[MODIFIER_STATE_TETHERED] = true,
}
end

