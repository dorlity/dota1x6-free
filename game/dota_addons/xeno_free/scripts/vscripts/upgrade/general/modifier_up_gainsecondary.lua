

modifier_up_gainsecondary = class({})


function modifier_up_gainsecondary:IsHidden() return true end
function modifier_up_gainsecondary:IsPurgable() return false end

function modifier_up_gainsecondary:DeclareFunctions()
if not IsServer() then return end
  if self:GetParent():GetPrimaryAttribute() == 1 then  return {MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS } end
  if self:GetParent():GetPrimaryAttribute() == 0 then return { MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end
  if self:GetParent():GetPrimaryAttribute() == 2 then return {  MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS} end

 end

function modifier_up_gainsecondary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true 


self:OnIntervalThink()
self:StartIntervalThink(0.5)
end






function modifier_up_gainsecondary:OnIntervalThink()
if not IsServer() then return end

self.agi_percentage = 4 + 4*self:GetStackCount()
self.str_percentage = 4 + 4*self:GetStackCount()
self.int_percentage = 4 + 4*self:GetStackCount()


self.agi  = 0
self.str  = 0
self.int  = 0


self.agi   = self:GetParent():GetAgility() * self.agi_percentage * 0.01
self.str   = self:GetParent():GetStrength() * self.str_percentage * 0.01
self.int   = self:GetParent():GetIntellect() * self.int_percentage * 0.01

self:GetParent():CalculateStatBonus(true)

end




function modifier_up_gainsecondary:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
end



function modifier_up_gainsecondary:GetModifierBonusStats_Agility () return self.agi end
function modifier_up_gainsecondary:GetModifierBonusStats_Strength() return self.str end
function modifier_up_gainsecondary:GetModifierBonusStats_Intellect() return self.int end


function modifier_up_gainsecondary:RemoveOnDeath() return false end






