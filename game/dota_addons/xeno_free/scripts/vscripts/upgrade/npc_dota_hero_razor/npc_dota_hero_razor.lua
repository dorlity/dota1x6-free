

modifier_razor_plasma_1 = class({})

function modifier_razor_plasma_1:IsHidden() return true end
function modifier_razor_plasma_1:IsPurgable() return false end

function modifier_razor_plasma_1:OnCreated(table)
if not IsServer() then return end


self:SetStackCount(1)
end

function modifier_razor_plasma_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_plasma_1:RemoveOnDeath() return false end



modifier_razor_plasma_2 = class({})

function modifier_razor_plasma_2:IsHidden() return true end
function modifier_razor_plasma_2:IsPurgable() return false end

function modifier_razor_plasma_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_plasma_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_plasma_2:RemoveOnDeath() return false end



modifier_razor_plasma_3 = class({})

function modifier_razor_plasma_3:IsHidden() return true end
function modifier_razor_plasma_3:IsPurgable() return false end

function modifier_razor_plasma_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_plasma_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_plasma_3:RemoveOnDeath() return false end



modifier_razor_plasma_4 = class({})

function modifier_razor_plasma_4:IsHidden() return true end
function modifier_razor_plasma_4:IsPurgable() return false end

function modifier_razor_plasma_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_plasma_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_plasma_4:RemoveOnDeath() return false end



modifier_razor_plasma_5 = class({})

function modifier_razor_plasma_5:IsHidden() return true end
function modifier_razor_plasma_5:IsPurgable() return false end

function modifier_razor_plasma_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_plasma_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_plasma_5:RemoveOnDeath() return false end



modifier_razor_plasma_6 = class({})

function modifier_razor_plasma_6:IsHidden() return true end
function modifier_razor_plasma_6:IsPurgable() return false end

function modifier_razor_plasma_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_plasma_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_plasma_6:RemoveOnDeath() return false end



modifier_razor_plasma_7 = class({})

function modifier_razor_plasma_7:IsHidden() return true end
function modifier_razor_plasma_7:IsPurgable() return false end

function modifier_razor_plasma_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetParent():FindAbilityByName("razor_plasma_field_custom_clone")

if ability then 
	ability:SetHidden(false)
end 

end

function modifier_razor_plasma_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_plasma_7:RemoveOnDeath() return false end













modifier_razor_link_1 = class({})

function modifier_razor_link_1:IsHidden() return true end
function modifier_razor_link_1:IsPurgable() return false end

function modifier_razor_link_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_link_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_link_1:RemoveOnDeath() return false end



modifier_razor_link_2 = class({})

function modifier_razor_link_2:IsHidden() return true end
function modifier_razor_link_2:IsPurgable() return false end

function modifier_razor_link_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_link_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_link_2:RemoveOnDeath() return false end



modifier_razor_link_3 = class({})

function modifier_razor_link_3:IsHidden() return true end
function modifier_razor_link_3:IsPurgable() return false end

function modifier_razor_link_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_link_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_link_3:RemoveOnDeath() return false end



modifier_razor_link_4 = class({})

function modifier_razor_link_4:IsHidden() return true end
function modifier_razor_link_4:IsPurgable() return false end

function modifier_razor_link_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_link_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_link_4:RemoveOnDeath() return false end



modifier_razor_link_5 = class({})

function modifier_razor_link_5:IsHidden() return true end
function modifier_razor_link_5:IsPurgable() return false end

function modifier_razor_link_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_link_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_link_5:RemoveOnDeath() return false end



modifier_razor_link_6 = class({})

function modifier_razor_link_6:IsHidden() return true end
function modifier_razor_link_6:IsPurgable() return false end

function modifier_razor_link_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetParent():FindAbilityByName("razor_static_link_custom")
if ability then 
  ability:ToggleAutoCast()
end 


end

function modifier_razor_link_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_link_6:RemoveOnDeath() return false end



modifier_razor_link_7 = class({})

function modifier_razor_link_7:IsHidden() return true end
function modifier_razor_link_7:IsPurgable() return false end

function modifier_razor_link_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_link_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_link_7:RemoveOnDeath() return false end














modifier_razor_current_1 = class({})

function modifier_razor_current_1:IsHidden() return true end
function modifier_razor_current_1:IsPurgable() return false end

function modifier_razor_current_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_current_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_current_1:RemoveOnDeath() return false end



modifier_razor_current_2 = class({})

function modifier_razor_current_2:IsHidden() return true end
function modifier_razor_current_2:IsPurgable() return false end

function modifier_razor_current_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_current_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_current_2:RemoveOnDeath() return false end



modifier_razor_current_3 = class({})

function modifier_razor_current_3:IsHidden() return true end
function modifier_razor_current_3:IsPurgable() return false end

function modifier_razor_current_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_current_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_current_3:RemoveOnDeath() return false end



modifier_razor_current_4 = class({})

function modifier_razor_current_4:IsHidden() return true end
function modifier_razor_current_4:IsPurgable() return false end

function modifier_razor_current_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_current_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_current_4:RemoveOnDeath() return false end



modifier_razor_current_5 = class({})

function modifier_razor_current_5:IsHidden() return true end
function modifier_razor_current_5:IsPurgable() return false end

function modifier_razor_current_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_current_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_current_5:RemoveOnDeath() return false end



modifier_razor_current_6 = class({})

function modifier_razor_current_6:IsHidden() return true end
function modifier_razor_current_6:IsPurgable() return false end

function modifier_razor_current_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_current_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_current_6:RemoveOnDeath() return false end



modifier_razor_current_7 = class({})

function modifier_razor_current_7:IsHidden() return true end
function modifier_razor_current_7:IsPurgable() return false end

function modifier_razor_current_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_current_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_current_7:RemoveOnDeath() return false end















modifier_razor_eye_1 = class({})

function modifier_razor_eye_1:IsHidden() return true end
function modifier_razor_eye_1:IsPurgable() return false end

function modifier_razor_eye_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_eye_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_eye_1:RemoveOnDeath() return false end



modifier_razor_eye_2 = class({})

function modifier_razor_eye_2:IsHidden() return true end
function modifier_razor_eye_2:IsPurgable() return false end

function modifier_razor_eye_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_eye_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_eye_2:RemoveOnDeath() return false end



modifier_razor_eye_3 = class({})

function modifier_razor_eye_3:IsHidden() return true end
function modifier_razor_eye_3:IsPurgable() return false end

function modifier_razor_eye_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)


end

function modifier_razor_eye_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)


end

function modifier_razor_eye_3:RemoveOnDeath() return false end








modifier_razor_eye_4 = class({})

function modifier_razor_eye_4:IsHidden() return true end
function modifier_razor_eye_4:IsPurgable() return false end

function modifier_razor_eye_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)


end

function modifier_razor_eye_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)



end

function modifier_razor_eye_4:RemoveOnDeath() return false end



modifier_razor_eye_5 = class({})

function modifier_razor_eye_5:IsHidden() return true end
function modifier_razor_eye_5:IsPurgable() return false end

function modifier_razor_eye_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_eye_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_eye_5:RemoveOnDeath() return false end



modifier_razor_eye_6 = class({})

function modifier_razor_eye_6:IsHidden() return true end
function modifier_razor_eye_6:IsPurgable() return false end

function modifier_razor_eye_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_eye_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_razor_eye_6:RemoveOnDeath() return false end



modifier_razor_eye_7 = class({})

function modifier_razor_eye_7:IsHidden() return true end
function modifier_razor_eye_7:IsPurgable() return false end

function modifier_razor_eye_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_razor_eye_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)



end

function modifier_razor_eye_7:RemoveOnDeath() return false end



