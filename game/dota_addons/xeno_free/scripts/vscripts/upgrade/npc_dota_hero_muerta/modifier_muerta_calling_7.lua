

modifier_muerta_calling_7 = class({})


function modifier_muerta_calling_7:IsHidden() return true end
function modifier_muerta_calling_7:IsPurgable() return false end



function modifier_muerta_calling_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

if not self:GetParent():FindAbilityByName("muerta_the_calling_custom_legendary") then return end

self:GetParent():FindAbilityByName("muerta_the_calling_custom_legendary"):SetHidden(false)
end


function modifier_muerta_calling_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end




function modifier_muerta_calling_7:RemoveOnDeath() return false end