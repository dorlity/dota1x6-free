

modifier_up_movespeed = class({})


function modifier_up_movespeed:IsHidden() return true end

function modifier_up_movespeed:IsPurgable() return false end


function modifier_up_movespeed:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT

    } end

function modifier_up_movespeed:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_movespeed:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_movespeed:GetModifierMoveSpeedBonus_Constant()
local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	k = 1.4
end


 return 10*self:GetStackCount()*(1 + k + 0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) 
end


  

function modifier_up_movespeed:RemoveOnDeath() return false end