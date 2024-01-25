

modifier_up_random_gray = class({})


function modifier_up_random_gray:IsHidden() return true end
function modifier_up_random_gray:IsPurgable() return false end


function modifier_up_random_gray:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

for i = 1,3 do
	upgrade:init_upgrade(self:GetParent(),1,nil,false,nil,true)
end

end


function modifier_up_random_gray:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
 
for i = 1,3 do
	upgrade:init_upgrade(self:GetParent(),1,nil,false,nil,true)
end 

end



function modifier_up_random_gray:RemoveOnDeath() return false end
  