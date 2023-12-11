
modifier_up_gainall = class({})



function modifier_up_gainall:IsHidden() return true end
function modifier_up_gainall:IsPurgable() return false end

function modifier_up_gainall:DeclareFunctions()
if not IsServer() then return end
if self:GetParent():GetPrimaryAttribute() == 3 then  
return 
{
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS 
} 
end

end



function modifier_up_gainall:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
self.StackOnIllusion = true 
self:GetParent():CalculateStatBonus(true)


self:OnIntervalThink()
self:StartIntervalThink(0.5)
end






function modifier_up_gainall:OnIntervalThink()
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




function modifier_up_gainall:OnRefresh(table)
if not IsServer() then return end
self:SetStackCount(self:GetStackCount()+1)
self:GetParent():CalculateStatBonus(true)
end

function modifier_up_gainall:GetModifierBonusStats_Agility () return self.agi end
function modifier_up_gainall:GetModifierBonusStats_Strength() return self.str end
function modifier_up_gainall:GetModifierBonusStats_Intellect() return self.int end


function modifier_up_gainall:RemoveOnDeath() return false end






