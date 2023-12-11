
modifier_up_allupgrade = class({})

function modifier_up_allupgrade:IsHidden() return true end
function modifier_up_allupgrade:IsPurgable() return false end

function modifier_up_allupgrade:DeclareFunctions()
return
{
  MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
  MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
  MODIFIER_PROPERTY_EVASION_CONSTANT
} 
end



function modifier_up_allupgrade:OnCreated(table)

  --print(self:GetParent():GetAgility()/700)
if not IsServer() then return end
 self:SetHasCustomTransmitterData(true)
self.str = 0
self.agi = 0
self.int = 0
self.bva = self:GetParent():GetBaseAttackTime()

 if self:GetParent():GetPrimaryAttribute() == 3 then 
	self.str = 1 
	self.agi = 1
	self.int = 1 
end 

  self:SetStackCount(1)
   self.StackOnIllusion = true 
  self:GetParent():CalculateStatBonus(true)
end

function modifier_up_allupgrade:AddCustomTransmitterData() return {
agi = self.agi,
int = self.int,
str = self.str,
bva = self.bva

} end

function modifier_up_allupgrade:HandleCustomTransmitterData(data)
self.agi = data.agi
self.str = data.str
self.int = data.int
self.bva = data.bva
end


function modifier_up_allupgrade:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end


--function modifier_up_allupgrade:GetModifierBaseAttackTimeConstant() return (self.bva - self:GetParent():GetAgility()/700)*self.agi end
function modifier_up_allupgrade:GetModifierSpellAmplify_Percentage() return 0.6*self:GetParent():GetIntellect()*self.int/20 end
function modifier_up_allupgrade:GetModifierStatusResistanceStacking() return 0.6*self:GetParent():GetStrength()*0.1*self.str end

function modifier_up_allupgrade:GetModifierMoveSpeedBonus_Percentage() return 0.6*0.1*self:GetParent():GetAgility()*self.agi end
function modifier_up_allupgrade:GetModifierEvasion_Constant() return 0.6*0.1*self:GetParent():GetAgility()*self.agi end


function modifier_up_allupgrade:RemoveOnDeath() return false end