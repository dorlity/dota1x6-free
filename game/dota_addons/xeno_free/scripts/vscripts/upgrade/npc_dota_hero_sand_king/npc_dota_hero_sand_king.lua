

modifier_sand_king_burrow_1 = class({})

function modifier_sand_king_burrow_1:IsHidden() return true end
function modifier_sand_king_burrow_1:IsPurgable() return false end

function modifier_sand_king_burrow_1:OnCreated(table)
if not IsServer() then return end


self:SetStackCount(1)
end

function modifier_sand_king_burrow_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_burrow_1:RemoveOnDeath() return false end



modifier_sand_king_burrow_2 = class({})

function modifier_sand_king_burrow_2:IsHidden() return true end
function modifier_sand_king_burrow_2:IsPurgable() return false end

function modifier_sand_king_burrow_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_burrow_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_burrow_2:RemoveOnDeath() return false end



modifier_sand_king_burrow_3 = class({})

function modifier_sand_king_burrow_3:IsHidden() return true end
function modifier_sand_king_burrow_3:IsPurgable() return false end

function modifier_sand_king_burrow_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_burrow_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_burrow_3:RemoveOnDeath() return false end



modifier_sand_king_burrow_4 = class({})

function modifier_sand_king_burrow_4:IsHidden() return true end
function modifier_sand_king_burrow_4:IsPurgable() return false end

function modifier_sand_king_burrow_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_burrow_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_burrow_4:RemoveOnDeath() return false end



modifier_sand_king_burrow_5 = class({})

function modifier_sand_king_burrow_5:IsHidden() return true end
function modifier_sand_king_burrow_5:IsPurgable() return false end

function modifier_sand_king_burrow_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_burrow_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_burrow_5:RemoveOnDeath() return false end



modifier_sand_king_burrow_6 = class({})

function modifier_sand_king_burrow_6:IsHidden() return true end
function modifier_sand_king_burrow_6:IsPurgable() return false end

function modifier_sand_king_burrow_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_burrow_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_burrow_6:RemoveOnDeath() return false end



modifier_sand_king_burrow_7 = class({})

function modifier_sand_king_burrow_7:IsHidden() return true end
function modifier_sand_king_burrow_7:IsPurgable() return false end

function modifier_sand_king_burrow_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetParent():FindAbilityByName("sandking_burrowstrike_custom_legendary")

if ability then 
	ability:SetHidden(false)
end 

end

function modifier_sand_king_burrow_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_burrow_7:RemoveOnDeath() return false end













modifier_sand_king_sand_1 = class({})

function modifier_sand_king_sand_1:IsHidden() return true end
function modifier_sand_king_sand_1:IsPurgable() return false end

function modifier_sand_king_sand_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_sand_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_sand_1:RemoveOnDeath() return false end



modifier_sand_king_sand_2 = class({})

function modifier_sand_king_sand_2:IsHidden() return true end
function modifier_sand_king_sand_2:IsPurgable() return false end

function modifier_sand_king_sand_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_sand_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_sand_2:RemoveOnDeath() return false end



modifier_sand_king_sand_3 = class({})

function modifier_sand_king_sand_3:IsHidden() return true end
function modifier_sand_king_sand_3:IsPurgable() return false end

function modifier_sand_king_sand_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_sand_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_sand_3:RemoveOnDeath() return false end



modifier_sand_king_sand_4 = class({})

function modifier_sand_king_sand_4:IsHidden() return true end
function modifier_sand_king_sand_4:IsPurgable() return false end

function modifier_sand_king_sand_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_sand_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_sand_4:RemoveOnDeath() return false end



modifier_sand_king_sand_5 = class({})

function modifier_sand_king_sand_5:IsHidden() return true end
function modifier_sand_king_sand_5:IsPurgable() return false end

function modifier_sand_king_sand_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_sand_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_sand_5:RemoveOnDeath() return false end



modifier_sand_king_sand_6 = class({})

function modifier_sand_king_sand_6:IsHidden() return true end
function modifier_sand_king_sand_6:IsPurgable() return false end

function modifier_sand_king_sand_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)


end

function modifier_sand_king_sand_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_sand_6:RemoveOnDeath() return false end



modifier_sand_king_sand_7 = class({})

function modifier_sand_king_sand_7:IsHidden() return true end
function modifier_sand_king_sand_7:IsPurgable() return false end

function modifier_sand_king_sand_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_sand_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_sand_7:RemoveOnDeath() return false end














modifier_sand_king_finale_1 = class({})

function modifier_sand_king_finale_1:IsHidden() return true end
function modifier_sand_king_finale_1:IsPurgable() return false end

function modifier_sand_king_finale_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_finale_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_finale_1:RemoveOnDeath() return false end



modifier_sand_king_finale_2 = class({})

function modifier_sand_king_finale_2:IsHidden() return true end
function modifier_sand_king_finale_2:IsPurgable() return false end

function modifier_sand_king_finale_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_finale_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_finale_2:RemoveOnDeath() return false end



modifier_sand_king_finale_3 = class({})

function modifier_sand_king_finale_3:IsHidden() return true end
function modifier_sand_king_finale_3:IsPurgable() return false end

function modifier_sand_king_finale_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_finale_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_finale_3:RemoveOnDeath() return false end



modifier_sand_king_finale_4 = class({})

function modifier_sand_king_finale_4:IsHidden() return true end
function modifier_sand_king_finale_4:IsPurgable() return false end

function modifier_sand_king_finale_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_finale_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_finale_4:RemoveOnDeath() return false end



modifier_sand_king_finale_5 = class({})

function modifier_sand_king_finale_5:IsHidden() return true end
function modifier_sand_king_finale_5:IsPurgable() return false end

function modifier_sand_king_finale_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

local ability = self:GetCaster():FindAbilityByName("sandking_caustic_finale_custom")

if ability then 
	self:GetCaster():AddNewModifier(self:GetCaster(), ability, "modifier_sandking_caustic_finale_custom_lowhp", {})
end 

end

function modifier_sand_king_finale_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_finale_5:RemoveOnDeath() return false end



modifier_sand_king_finale_6 = class({})

function modifier_sand_king_finale_6:IsHidden() return true end
function modifier_sand_king_finale_6:IsPurgable() return false end

function modifier_sand_king_finale_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_finale_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_finale_6:RemoveOnDeath() return false end



modifier_sand_king_finale_7 = class({})

function modifier_sand_king_finale_7:IsHidden() return true end
function modifier_sand_king_finale_7:IsPurgable() return false end

function modifier_sand_king_finale_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_finale_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_finale_7:RemoveOnDeath() return false end















modifier_sand_king_epicenter_1 = class({})

function modifier_sand_king_epicenter_1:IsHidden() return true end
function modifier_sand_king_epicenter_1:IsPurgable() return false end

function modifier_sand_king_epicenter_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_epicenter_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_epicenter_1:RemoveOnDeath() return false end



modifier_sand_king_epicenter_2 = class({})

function modifier_sand_king_epicenter_2:IsHidden() return true end
function modifier_sand_king_epicenter_2:IsPurgable() return false end

function modifier_sand_king_epicenter_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_epicenter_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_epicenter_2:RemoveOnDeath() return false end



modifier_sand_king_epicenter_3 = class({})

function modifier_sand_king_epicenter_3:IsHidden() return true end
function modifier_sand_king_epicenter_3:IsPurgable() return false end

function modifier_sand_king_epicenter_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)


end

function modifier_sand_king_epicenter_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)


end

function modifier_sand_king_epicenter_3:RemoveOnDeath() return false end








modifier_sand_king_epicenter_4 = class({})

function modifier_sand_king_epicenter_4:IsHidden() return true end
function modifier_sand_king_epicenter_4:IsPurgable() return false end

function modifier_sand_king_epicenter_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)


end

function modifier_sand_king_epicenter_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)



end

function modifier_sand_king_epicenter_4:RemoveOnDeath() return false end



modifier_sand_king_epicenter_5 = class({})

function modifier_sand_king_epicenter_5:IsHidden() return true end
function modifier_sand_king_epicenter_5:IsPurgable() return false end

function modifier_sand_king_epicenter_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_epicenter_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_epicenter_5:RemoveOnDeath() return false end



modifier_sand_king_epicenter_6 = class({})

function modifier_sand_king_epicenter_6:IsHidden() return true end
function modifier_sand_king_epicenter_6:IsPurgable() return false end

function modifier_sand_king_epicenter_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

end

function modifier_sand_king_epicenter_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_sand_king_epicenter_6:RemoveOnDeath() return false end



modifier_sand_king_epicenter_7 = class({})

function modifier_sand_king_epicenter_7:IsHidden() return true end
function modifier_sand_king_epicenter_7:IsPurgable() return false end

function modifier_sand_king_epicenter_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
local ability = self:GetParent():FindAbilityByName("sandking_epicenter_custom_legendary")

if ability then 
	ability:SetHidden(false)
end 

end

function modifier_sand_king_epicenter_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)



end

function modifier_sand_king_epicenter_7:RemoveOnDeath() return false end



