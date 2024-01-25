

modifier_templar_assassin_psiblades_2 = class({})


function modifier_templar_assassin_psiblades_2:IsHidden() return true end
function modifier_templar_assassin_psiblades_2:IsPurgable() return false end



function modifier_templar_assassin_psiblades_2:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_templar_assassin_psiblades_2:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_templar_assassin_psiblades_2:RemoveOnDeath() return false end