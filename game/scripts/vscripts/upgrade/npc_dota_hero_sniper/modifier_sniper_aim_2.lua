

modifier_sniper_aim_2 = class({})


function modifier_sniper_aim_2:IsHidden() return true end
function modifier_sniper_aim_2:IsPurgable() return false end



function modifier_sniper_aim_2:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
self.StackOnIllusion = true 
self:GetParent():AddNewModifier(self:GetParent(), self:GetParent():FindAbilityByName("sniper_take_aim_custom"), "modifier_sniper_take_aim_custom_attack_speed", {})
end


function modifier_sniper_aim_2:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_sniper_aim_2:RemoveOnDeath() return false end