

modifier_templar_assassin_psionic_4 = class({})


function modifier_templar_assassin_psionic_4:IsHidden() return true end
function modifier_templar_assassin_psionic_4:IsPurgable() return false end



function modifier_templar_assassin_psionic_4:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_templar_assassin_psionic_4:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_templar_assassin_psionic_4:RemoveOnDeath() return false end