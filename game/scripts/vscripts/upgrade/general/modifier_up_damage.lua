

modifier_up_damage = class({})

function modifier_up_damage:IsHidden() return true end
function modifier_up_damage:IsPurgable() return false end


function modifier_up_damage:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE

    } end

function modifier_up_damage:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_damage:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_damage:GetModifierPreAttack_BonusDamage() 

local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	k = 1.4
end

	return 10*self:GetStackCount()*(1+0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints") + k)
end

function modifier_up_damage:RemoveOnDeath() return false end