

modifier_up_gainsecondary = class({})


function modifier_up_gainsecondary:IsHidden() return true end
function modifier_up_gainsecondary:IsPurgable() return false end


function modifier_up_gainsecondary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)


self:Update()
self.StackOnIllusion = true 
end







function modifier_up_gainsecondary:Update()
if not IsServer() then return end 

if self:GetParent():GetPrimaryAttribute() == 0 then
  self.PercentInt   = (4 + 4*self:GetStackCount()) * 0.01
  self.PercentAgi   = (4 + 4*self:GetStackCount()) * 0.01
end 

if self:GetParent():GetPrimaryAttribute() == 1 then
  self.PercentInt   = (4 + 4*self:GetStackCount()) * 0.01
  self.PercentStr   = (4 + 4*self:GetStackCount()) * 0.01
end 


if self:GetParent():GetPrimaryAttribute() == 2 then
  self.PercentAgi   = (4 + 4*self:GetStackCount()) * 0.01
  self.PercentStr   = (4 + 4*self:GetStackCount()) * 0.01
end 


end 

function modifier_up_gainsecondary:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)

self:Update()
end





function modifier_up_gainsecondary:RemoveOnDeath() return false end






