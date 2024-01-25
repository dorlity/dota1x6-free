
modifier_up_gainprimary = class({})



function modifier_up_gainprimary:IsHidden() return true end
function modifier_up_gainprimary:IsPurgable() return false end


function modifier_up_gainprimary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)


self:Update()
self.StackOnIllusion = true 
end



function modifier_up_gainprimary:Update()
if not IsServer() then return end 

if self:GetParent():GetPrimaryAttribute() == 0 then
  self.PercentStr   = (4 + 4*self:GetStackCount()) * 0.01
end 

if self:GetParent():GetPrimaryAttribute() == 1 then
  self.PercentAgi   = (4 + 4*self:GetStackCount()) * 0.01
end 


if self:GetParent():GetPrimaryAttribute() == 2 then
  self.PercentInt   = (4 + 4*self:GetStackCount()) * 0.01
end 


end 

function modifier_up_gainprimary:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)

self:Update()
end



function modifier_up_gainprimary:RemoveOnDeath() return false end






