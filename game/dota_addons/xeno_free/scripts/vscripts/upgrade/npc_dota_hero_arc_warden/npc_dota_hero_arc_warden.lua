

modifier_arc_warden_flux_1 = class({})

function modifier_arc_warden_flux_1:IsHidden() return true end
function modifier_arc_warden_flux_1:IsPurgable() return false end

function modifier_arc_warden_flux_1:OnCreated(table)
if not IsServer() then return end
self.StackOnIllusion = true

self:SetStackCount(1)
end

function modifier_arc_warden_flux_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_flux_1:RemoveOnDeath() return false end



modifier_arc_warden_flux_2 = class({})

function modifier_arc_warden_flux_2:IsHidden() return true end
function modifier_arc_warden_flux_2:IsPurgable() return false end

function modifier_arc_warden_flux_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_flux_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_flux_2:RemoveOnDeath() return false end



modifier_arc_warden_flux_3 = class({})

function modifier_arc_warden_flux_3:IsHidden() return true end
function modifier_arc_warden_flux_3:IsPurgable() return false end

function modifier_arc_warden_flux_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_flux_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_flux_3:RemoveOnDeath() return false end



modifier_arc_warden_flux_4 = class({})

function modifier_arc_warden_flux_4:IsHidden() return true end
function modifier_arc_warden_flux_4:IsPurgable() return false end

function modifier_arc_warden_flux_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_flux_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_flux_4:RemoveOnDeath() return false end



modifier_arc_warden_flux_5 = class({})

function modifier_arc_warden_flux_5:IsHidden() return true end
function modifier_arc_warden_flux_5:IsPurgable() return false end

function modifier_arc_warden_flux_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_flux_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_flux_5:RemoveOnDeath() return false end



modifier_arc_warden_flux_6 = class({})

function modifier_arc_warden_flux_6:IsHidden() return true end
function modifier_arc_warden_flux_6:IsPurgable() return false end

function modifier_arc_warden_flux_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true


local main_ability = self:GetParent():FindAbilityByName("arc_warden_flux_custom")

if main_ability then 
	main_ability:UpdateVectorValues()
end

end

function modifier_arc_warden_flux_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_flux_6:RemoveOnDeath() return false end



modifier_arc_warden_flux_7 = class({})

function modifier_arc_warden_flux_7:IsHidden() return true end
function modifier_arc_warden_flux_7:IsPurgable() return false end

function modifier_arc_warden_flux_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_flux_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_flux_7:RemoveOnDeath() return false end













modifier_arc_warden_field_1 = class({})

function modifier_arc_warden_field_1:IsHidden() return true end
function modifier_arc_warden_field_1:IsPurgable() return false end

function modifier_arc_warden_field_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_field_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_field_1:RemoveOnDeath() return false end



modifier_arc_warden_field_2 = class({})

function modifier_arc_warden_field_2:IsHidden() return true end
function modifier_arc_warden_field_2:IsPurgable() return false end

function modifier_arc_warden_field_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_field_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_field_2:RemoveOnDeath() return false end



modifier_arc_warden_field_3 = class({})

function modifier_arc_warden_field_3:IsHidden() return true end
function modifier_arc_warden_field_3:IsPurgable() return false end

function modifier_arc_warden_field_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_field_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_field_3:RemoveOnDeath() return false end



modifier_arc_warden_field_4 = class({})

function modifier_arc_warden_field_4:IsHidden() return true end
function modifier_arc_warden_field_4:IsPurgable() return false end

function modifier_arc_warden_field_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_field_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_field_4:RemoveOnDeath() return false end



modifier_arc_warden_field_5 = class({})

function modifier_arc_warden_field_5:IsHidden() return true end
function modifier_arc_warden_field_5:IsPurgable() return false end

function modifier_arc_warden_field_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_field_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_field_5:RemoveOnDeath() return false end



modifier_arc_warden_field_6 = class({})

function modifier_arc_warden_field_6:IsHidden() return true end
function modifier_arc_warden_field_6:IsPurgable() return false end

function modifier_arc_warden_field_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_field_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_field_6:RemoveOnDeath() return false end



modifier_arc_warden_field_7 = class({})

function modifier_arc_warden_field_7:IsHidden() return true end
function modifier_arc_warden_field_7:IsPurgable() return false end

function modifier_arc_warden_field_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_field_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_field_7:RemoveOnDeath() return false end














modifier_arc_warden_spark_1 = class({})

function modifier_arc_warden_spark_1:IsHidden() return true end
function modifier_arc_warden_spark_1:IsPurgable() return false end

function modifier_arc_warden_spark_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_spark_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_spark_1:RemoveOnDeath() return false end



modifier_arc_warden_spark_2 = class({})

function modifier_arc_warden_spark_2:IsHidden() return true end
function modifier_arc_warden_spark_2:IsPurgable() return false end

function modifier_arc_warden_spark_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_spark_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_spark_2:RemoveOnDeath() return false end



modifier_arc_warden_spark_3 = class({})

function modifier_arc_warden_spark_3:IsHidden() return true end
function modifier_arc_warden_spark_3:IsPurgable() return false end

function modifier_arc_warden_spark_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_spark_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_spark_3:RemoveOnDeath() return false end



modifier_arc_warden_spark_4 = class({})

function modifier_arc_warden_spark_4:IsHidden() return true end
function modifier_arc_warden_spark_4:IsPurgable() return false end

function modifier_arc_warden_spark_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_spark_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_spark_4:RemoveOnDeath() return false end



modifier_arc_warden_spark_5 = class({})

function modifier_arc_warden_spark_5:IsHidden() return true end
function modifier_arc_warden_spark_5:IsPurgable() return false end

function modifier_arc_warden_spark_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_spark_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_spark_5:RemoveOnDeath() return false end



modifier_arc_warden_spark_6 = class({})

function modifier_arc_warden_spark_6:IsHidden() return true end
function modifier_arc_warden_spark_6:IsPurgable() return false end

function modifier_arc_warden_spark_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_spark_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_spark_6:RemoveOnDeath() return false end



modifier_arc_warden_spark_7 = class({})

function modifier_arc_warden_spark_7:IsHidden() return true end
function modifier_arc_warden_spark_7:IsPurgable() return false end

function modifier_arc_warden_spark_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true

if self:GetParent():FindAbilityByName("arc_warden_spark_wraith_custom_legendary") then 
	self:GetParent():FindAbilityByName("arc_warden_spark_wraith_custom_legendary"):SetHidden(false)
end 

end

function modifier_arc_warden_spark_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_spark_7:RemoveOnDeath() return false end















modifier_arc_warden_double_1 = class({})

function modifier_arc_warden_double_1:IsHidden() return true end
function modifier_arc_warden_double_1:IsPurgable() return false end

function modifier_arc_warden_double_1:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_double_1:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_double_1:RemoveOnDeath() return false end



modifier_arc_warden_double_2 = class({})

function modifier_arc_warden_double_2:IsHidden() return true end
function modifier_arc_warden_double_2:IsPurgable() return false end

function modifier_arc_warden_double_2:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_double_2:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_double_2:RemoveOnDeath() return false end



modifier_arc_warden_double_3 = class({})

function modifier_arc_warden_double_3:IsHidden() return true end
function modifier_arc_warden_double_3:IsPurgable() return false end

function modifier_arc_warden_double_3:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true

end

function modifier_arc_warden_double_3:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)


end

function modifier_arc_warden_double_3:RemoveOnDeath() return false end








modifier_arc_warden_double_4 = class({})

function modifier_arc_warden_double_4:IsHidden() return true end
function modifier_arc_warden_double_4:IsPurgable() return false end

function modifier_arc_warden_double_4:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true

if self:GetParent():FindAbilityByName("arc_warden_tempest_double_custom_buff") then 
	self:GetParent():FindAbilityByName("arc_warden_tempest_double_custom_buff"):SetHidden(false)
end 

end

function modifier_arc_warden_double_4:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)



end

function modifier_arc_warden_double_4:RemoveOnDeath() return false end



modifier_arc_warden_double_5 = class({})

function modifier_arc_warden_double_5:IsHidden() return true end
function modifier_arc_warden_double_5:IsPurgable() return false end

function modifier_arc_warden_double_5:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_double_5:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_double_5:RemoveOnDeath() return false end



modifier_arc_warden_double_6 = class({})

function modifier_arc_warden_double_6:IsHidden() return true end
function modifier_arc_warden_double_6:IsPurgable() return false end

function modifier_arc_warden_double_6:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true
end

function modifier_arc_warden_double_6:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end

function modifier_arc_warden_double_6:RemoveOnDeath() return false end



modifier_arc_warden_double_7 = class({})

function modifier_arc_warden_double_7:IsHidden() return true end
function modifier_arc_warden_double_7:IsPurgable() return false end

function modifier_arc_warden_double_7:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true


end

function modifier_arc_warden_double_7:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)



end

function modifier_arc_warden_double_7:RemoveOnDeath() return false end



