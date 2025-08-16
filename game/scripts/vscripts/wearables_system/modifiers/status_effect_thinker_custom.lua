status_effect_thinker_custom = class({})
function status_effect_thinker_custom:IsHidden() return true end
function status_effect_thinker_custom:IsPurgable() return false end
function status_effect_thinker_custom:RemoveOnDeath() return false end
function status_effect_thinker_custom:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function status_effect_thinker_custom:AddCustomTransmitterData() 
return 
{
    name = self.name, 
    priority = self.priority
}
end
function status_effect_thinker_custom:HandleCustomTransmitterData( data ) 
self.name = data.name 
self.priority = data.priority
end

function status_effect_thinker_custom:StatusEffectPriority() return self.priority end
function status_effect_thinker_custom:GetStatusEffectName() return self.name end

function status_effect_thinker_custom:OnCreated(params)
if not IsServer() then return end
self.name = params.name
self.priority = params.priority
self:SetHasCustomTransmitterData(true)
end
