

modifier_up_creeps = class({})


function modifier_up_creeps:IsHidden() return true end
function modifier_up_creeps:IsPurgable() return false end

function modifier_up_creeps:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
  
    }

 end

function modifier_up_creeps:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_creeps:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
end


function modifier_up_creeps:GetModifierTotalDamageOutgoing_Percentage( params ) 
if params.attacker ~= self:GetParent() then return end
if not params.target then return end
if not params.target:IsCreep() then return end 

local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	k = 1.4
end


return 7*self:GetStackCount()*(1 + k +0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints"))

end


function modifier_up_creeps:RemoveOnDeath() return false end