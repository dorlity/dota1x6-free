

modifier_percent_stats = class({})


function modifier_percent_stats:IsHidden() return true end
function modifier_percent_stats:IsPurgable() return false end
function modifier_percent_stats:RemoveOnDeath() return false end

function modifier_percent_stats:DeclareFunctions()
return 
{
	MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_STATS_AGILITY_BONUS 
}
end


function modifier_percent_stats:OnCreated(table)
if not IsServer() then return end

self.agi = 0
self.str = 0
self.int = 0

self.StackOnIllusion = true
self:StartIntervalThink(0.2)
end


function modifier_percent_stats:OnIntervalThink()
if not IsServer() then return end

local str_k = 0
local agi_k = 0
local int_k = 0

for _,mod in pairs(self:GetParent():FindAllModifiers()) do 
	if mod.PercentStr ~= nil then 
		str_k = str_k + mod.PercentStr 
	end

	if mod.PercentAgi ~= nil then 
		agi_k = agi_k + mod.PercentAgi 
	end

	if mod.PercentInt ~= nil then 
		int_k = int_k + mod.PercentInt
	end
end 


self.agi = 0
self.str = 0
self.int = 0

self.int = self:GetParent():GetIntellect()*int_k
self.str = self:GetParent():GetStrength()*str_k
self.agi = self:GetParent():GetAgility()*agi_k

self:GetParent():CalculateStatBonus(true)

end

function modifier_percent_stats:GetModifierBonusStats_Agility() 
return self.agi
end

function modifier_percent_stats:GetModifierBonusStats_Strength() 
return self.str
end


function modifier_percent_stats:GetModifierBonusStats_Intellect() 
return self.int
end
