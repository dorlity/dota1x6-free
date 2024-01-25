

modifier_templar_assassin_meld_5 = class({})


function modifier_templar_assassin_meld_5:IsHidden() return true end
function modifier_templar_assassin_meld_5:IsPurgable() return false end



function modifier_templar_assassin_meld_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)


local ability = self:GetParent():FindAbilityByName("templar_assassin_meld_custom")
if not ability then return end


ability:ToggleAutoCast()

self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_templar_assassin_meld_custom_toggle", {})


end


function modifier_templar_assassin_meld_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_templar_assassin_meld_5:RemoveOnDeath() return false end