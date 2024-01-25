

modifier_templar_assassin_psiblades_5 = class({})


function modifier_templar_assassin_psiblades_5:IsHidden() return true end
function modifier_templar_assassin_psiblades_5:IsPurgable() return false end



function modifier_templar_assassin_psiblades_5:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
end


function modifier_templar_assassin_psiblades_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_templar_assassin_psiblades_5:RemoveOnDeath() return false end