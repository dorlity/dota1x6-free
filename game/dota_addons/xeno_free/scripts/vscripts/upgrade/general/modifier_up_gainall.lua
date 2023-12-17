
modifier_up_gainall = class({})



function modifier_up_gainall:IsHidden() return true end
function modifier_up_gainall:IsPurgable() return false end



function modifier_up_gainall:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)


self:Update()
self.StackOnIllusion = true 
end



function modifier_up_gainall:Update()
if not IsServer() then return end 

self.PercentStr   = (2.5 + 2.5*self:GetStackCount()) * 0.01
self.PercentAgi   = (2.5 + 2.5*self:GetStackCount()) * 0.01
self.PercentInt   = (2.5 + 2.5*self:GetStackCount()) * 0.01

end 

function modifier_up_gainall:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)

self:Update()
end


function modifier_up_gainall:RemoveOnDeath() return false end






