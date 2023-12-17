

modifier_up_range = class({})


function modifier_up_range:IsHidden() return true end
function modifier_up_range:IsPurgable() return false end

function modifier_up_range:DeclareFunctions()
return 
{
    MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
    MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
} 
end

function modifier_up_range:OnCreated(table)
if not IsServer() then return end
  self:SetStackCount(1)
  self.StackOnIllusion = true 


end


function modifier_up_range:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)

end

function modifier_up_range:GetModifierAttackRangeBonus()
if not self:GetParent():IsRangedAttacker() and self:GetParent():HasModifier("modifier_item_celestial_spear_custom") then return end
if self:GetParent():IsRangedAttacker() and (self:GetParent():HasModifier("modifier_item_dragon_lance") 
	or self:GetParent():HasModifier("modifier_item_hurricane_pike")) then return end

return 25 + 25*self:GetStackCount()
end


function modifier_up_range:GetModifierCastRangeBonusStacking()
if (self:GetParent():HasModifier("modifier_item_manaflare_lens_custom") or self:GetParent():HasModifier("modifier_item_aether_lens") or self:GetParent():HasModifier("modifier_item_ethereal_blade")) then return end

return 50 + 50*self:GetStackCount()
end



function modifier_up_range:RemoveOnDeath() return false end