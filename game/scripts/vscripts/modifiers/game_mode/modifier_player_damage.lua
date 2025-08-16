

modifier_player_damage = class({})
function modifier_player_damage:IsHidden() return (self:GetStackCount() - 1) <= 0 end
function modifier_player_damage:GetTexture() return "buffs/duel_win" end
function modifier_player_damage:IsPurgable() return false end
function modifier_player_damage:RemoveOnDeath() return false end

function modifier_player_damage:DeclareFunctions()
return
{
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_TOOLTIP,
	MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
}
end

function modifier_player_damage:OnTooltip()
return 10*(self:GetStackCount() - 1)
end 


function modifier_player_damage:OnCreated(table)
if not IsServer() then return end 
self.parent = self:GetParent()
self.StackOnIllusion = true 

if not self.parent.owner then return end
self:StartIntervalThink(0.2)
end 


function modifier_player_damage:OnIntervalThink()
if not IsServer() then return end 

if not self.parent.owner or self.parent.owner:IsNull() then 
	self:Destroy()
	return
end 	

local mod = self.parent.owner:FindModifierByName(self:GetName())
if not mod then 
	self:Destroy()
	return
end
self:SetStackCount(mod:GetStackCount())
end 



function modifier_player_damage:GetModifierIncomingDamage_Percentage(params)
if not IsServer() then return end

local attacker = params.attacker
if not attacker or not attacker:IsHero() then return end 
if attacker == self.parent then return end

local player_array = players[self.parent:GetId()]
local attacker_array = players[attacker:GetId()]

if not player_array then return end
if not attacker_array then return end

local damage_bonus = player_array.damage_bonus

if damage_bonus == 0 then return end

local tower = towers[attacker:GetTeamNumber()] 
if tower and (tower:GetAbsOrigin() - self.parent:GetAbsOrigin()):Length2D() <= 900 then 
	return 0
end

return damage_bonus*-1
end






function modifier_player_damage:GetModifierTotalDamageOutgoing_Percentage(params)
if not IsServer() then return end


local unit = params.target
if not unit or not unit:IsHero() then return end 
if unit == self:GetParent() then return end

local player_array = players[self:GetParent():GetId()]
local unit_array = players[unit:GetId()]

if not player_array then return end
if not unit_array then return end

local damage_bonus = player_array.damage_bonus

if damage_bonus == 0 then return end

local tower = towers[unit:GetTeamNumber()] 
if tower and (tower:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= 900 then 
	return 0
end


return damage_bonus
end
