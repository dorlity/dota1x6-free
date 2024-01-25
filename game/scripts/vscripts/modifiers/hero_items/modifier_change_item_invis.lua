modifier_change_item_invis = class({})
function modifier_change_item_invis:IsHidden() return false end
function modifier_change_item_invis:IsPurgable() return false end
function modifier_change_item_invis:IsPurgeException() return false end
function modifier_change_item_invis:RemoveOnDeath() return false end
--function modifier_change_item_invis:DeclareFunctions()
--    return
--    {
--        MODIFIER_PROPERTY_MODEL_CHANGE
--    }
--end
--
--function modifier_change_item_invis:GetModifierModelChange()
--	return "models/development/invisiblebox.vmdl"
--end

function modifier_change_item_invis:OnCreated(kv)
    self.model = kv.model
end

function modifier_change_item_invis:SetEndCallback( func ) 
	self.EndCallback = func
end

function modifier_change_item_invis:OnDestroy( kv )
	if not IsServer() then return end
	if self.EndCallback then
		self.EndCallback()
	end
end