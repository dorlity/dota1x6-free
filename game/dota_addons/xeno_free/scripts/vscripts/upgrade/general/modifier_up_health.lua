

modifier_up_health = class({})



function modifier_up_health:IsHidden() return true end
function modifier_up_health:IsPurgable() return false end


function modifier_up_health:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_HEALTH_BONUS

    } end

function modifier_up_health:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end


function modifier_up_health:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end

function modifier_up_health:GetModifierHealthBonus() 
local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	k = 1.4
end


	return 80*self:GetStackCount()*(1 + k + 0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints"))
end

function modifier_up_health:RemoveOnDeath() return false end