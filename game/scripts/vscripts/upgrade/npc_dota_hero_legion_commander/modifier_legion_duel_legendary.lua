

modifier_legion_duel_legendary = class({})


function modifier_legion_duel_legendary:IsHidden() return true end
function modifier_legion_duel_legendary:IsPurgable() return false end



function modifier_legion_duel_legendary:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)
local ability = self:GetParent():FindAbilityByName("custom_legion_commander_duel_double")
if ability then 
	ability:SetHidden(false)
end

local max = self:GetCaster():GetTalentValue("modifier_legion_duel_legendary", "init_charges")
local amp = self:GetCaster():GetTalentValue("modifier_legion_duel_legendary", "amp")
local damage = self:GetCaster():GetTalentValue("modifier_legion_duel_legendary", "damage")

if my_game.current_wave >= upgrade_orange then 

  local mod = self:GetParent():AddNewModifier(self:GetParent(), ability, "modifier_duel_double_win", {amp = amp, damage = damage})

  if mod then 
    mod:SetStackCount(max)
  end
end

end


function modifier_legion_duel_legendary:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  
end

function modifier_legion_duel_legendary:RemoveOnDeath() return false end