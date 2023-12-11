

modifier_up_bluepoints = class({})


function modifier_up_bluepoints:IsHidden() return true end
function modifier_up_bluepoints:IsPurgable() return false end


function modifier_up_bluepoints:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

for i = 1,4 do
	upgrade:init_upgrade(self:GetParent(),2,nil,false,nil,true)
end

end


function modifier_up_bluepoints:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end



function modifier_up_bluepoints:RemoveOnDeath() return false end
  