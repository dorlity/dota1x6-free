

modifier_zuus_jump_5 = class({})


function modifier_zuus_jump_5:IsHidden() return true end
function modifier_zuus_jump_5:IsPurgable() return false end



function modifier_zuus_jump_5:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)

  if self:GetCaster():HasModifier("modifier_zuus_jump_7") then 
  	self:GetParent():SwapAbilities("zuus_heavenly_jump_custom_legendary", "zuus_heavenly_jump_custom_legendary_2", false, true)
  end


end


function modifier_zuus_jump_5:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_zuus_jump_5:RemoveOnDeath() return false end