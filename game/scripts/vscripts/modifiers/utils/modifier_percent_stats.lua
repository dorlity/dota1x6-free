

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
self.NeedRefresh = false
self.parent = self:GetParent()
self.StackOnIllusion = true

self.interval = 0.5
if self.parent:IsIllusion() or self.parent:IsTempestDouble() then
	self.interval = 1
end

self:StartIntervalThink(0.1)
end


function modifier_percent_stats:OnIntervalThink()
if not IsServer() then return end

local str_k = 0
local agi_k = 0
local int_k = 0

for _,mod in pairs(self.parent:FindAllModifiers()) do 
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

self.int = self.parent:GetIntellect(false)*int_k
self.str = self.parent:GetStrength()*str_k
self.agi = self.parent:GetAgility()*agi_k

if self.int ~= 0 or self.str ~= 0 or self.agi ~= 0 or self.NeedRefresh then
	self.NeedRefresh = false
	self.parent:CalculateStatBonus(true)
end

self:StartIntervalThink(self.interval)
end


function modifier_percent_stats:SendRefresh()
if not IsServer() then return end 
self.NeedRefresh = true
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
