

modifier_up_manaregen = class({})

function modifier_up_manaregen:IsHidden() return true end
function modifier_up_manaregen:IsPurgable() return false end


function modifier_up_manaregen:DeclareFunctions()
    return {

        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    } end

function modifier_up_manaregen:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
   self.StackOnIllusion = true 
end


function modifier_up_manaregen:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_up_manaregen:GetModifierConstantManaRegen() 
local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	k = 1.4
end

	return 3*self:GetStackCount()*(1 + k + 0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) 
end



function modifier_up_manaregen:RemoveOnDeath() return false end