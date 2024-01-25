

modifier_up_gold = class({})


function modifier_up_gold:IsHidden() return true end
function modifier_up_gold:IsPurgable() return false end



function modifier_up_gold:OnCreated(table)

if not IsServer() then return end
  self:SetStackCount(1)
  self:Gold()
end


function modifier_up_gold:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end


function modifier_up_gold:Gold()
if not self:GetParent() then return end

local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
	k = 1.4
end


self.rate = 60/(self:GetStackCount()*50*(1+ k +0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints")))

    Timers:CreateTimer(self.rate,function()
		self:GetParent():ModifyGold(1 , true , DOTA_ModifyGold_GameTick)
		self:Gold()
	end)
end


function modifier_up_gold:RemoveOnDeath() return false end


		