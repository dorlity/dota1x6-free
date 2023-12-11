

modifier_zuus_jump_7 = class({})


function modifier_zuus_jump_7:IsHidden() return true end
function modifier_zuus_jump_7:IsPurgable() return false end



function modifier_zuus_jump_7:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true
  name = "zuus_heavenly_jump_custom_legendary"
  if self:GetCaster():HasModifier("modifier_zuus_jump_5") then 
  	name = "zuus_heavenly_jump_custom_legendary_2"
  end

  self:GetParent():SwapAbilities("zuus_heavenly_jump_custom", name, false, true)

end


function modifier_zuus_jump_7:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_zuus_jump_7:RemoveOnDeath() return false end