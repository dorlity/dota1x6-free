

modifier_bristle_back_legendary = class({})


function modifier_bristle_back_legendary:IsHidden() return true end
function modifier_bristle_back_legendary:IsPurgable() return false end



function modifier_bristle_back_legendary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.ActiveTalent = true

self:GetParent():FindAbilityByName("bristleback_bristleback_custom_legendary"):SetHidden(false)
end



function modifier_bristle_back_legendary:RemoveOnDeath() return false end