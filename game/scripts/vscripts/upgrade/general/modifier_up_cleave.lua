

modifier_up_cleave = class({})


function modifier_up_cleave:IsHidden() return true end
function modifier_up_cleave:IsPurgable() return false end


function modifier_up_cleave:DeclareFunctions()
return {
MODIFIER_EVENT_ON_ATTACK_LANDED


} end



function modifier_up_cleave:OnAttackLanded( param )
if not IsServer() then return end
if self:GetParent():HasModifier("modifier_tidehunter_anchor_smash_caster") then return end
if self:GetParent():HasModifier("modifier_no_cleave") then return end
if self:GetParent() ~= param.attacker or self:GetParent():IsRangedAttacker() then return end

local k = 0
if self:GetParent():HasModifier("modifier_item_alchemist_gold_octarine_active") then 
  k = 1.4
end



DoCleaveAttack(self:GetParent(), param.target, self.ability, param.damage*(10*self:GetStackCount()*(1 + k +0.3*self:GetParent():GetUpgradeStack("modifier_up_graypoints")) /100 ), 150, 360, 650, "particles/units/heroes/hero_magnataur/magnataur_empower_cleave_effect.vpcf")

end


function modifier_up_cleave:OnCreated(table)
if not IsServer() then return end
self:SetStackCount(1)

self.ability = self:GetParent():AddAbility("generic_talent")
self.ability:SetLevel(1)

self:GetParent():CalculateStatBonus(true)
end


function modifier_up_cleave:OnRefresh(table)
if not IsServer() then return end
  self:SetStackCount(self:GetStackCount()+1)
  self:GetParent():CalculateStatBonus(true)
end



function modifier_up_cleave:RemoveOnDeath() return false end