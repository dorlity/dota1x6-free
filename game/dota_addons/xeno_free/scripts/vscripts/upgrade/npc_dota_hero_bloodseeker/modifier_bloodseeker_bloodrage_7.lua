

modifier_bloodseeker_bloodrage_7 = class({})


function modifier_bloodseeker_bloodrage_7:IsHidden() return true end
function modifier_bloodseeker_bloodrage_7:IsPurgable() return false end



function modifier_bloodseeker_bloodrage_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self:GetParent():RemoveModifierByName("modifier_bloodseeker_bloodrage_custom")
end


function modifier_bloodseeker_bloodrage_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_bloodseeker_bloodrage_7:RemoveOnDeath() return false end